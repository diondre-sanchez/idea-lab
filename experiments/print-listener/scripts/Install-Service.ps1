#Requires -RunAsAdministrator
<#
.SYNOPSIS
    Installs or removes the PrintListener Windows Service using NSSM.

.DESCRIPTION
    Wraps NSSM to register PrintListener.ps1 as a Windows Service that starts
    automatically at boot. Must be run from an elevated (Administrator) prompt.

.PARAMETER Action
    Install  — registers and starts the service (default)
    Remove   — stops and removes the service
    Status   — shows current service state

.PARAMETER NssmPath
    Full path to nssm.exe. Defaults to .\tools\nssm.exe

.PARAMETER ScriptPath
    Full path to PrintListener.ps1. Defaults to .\PrintListener.ps1

.PARAMETER ServiceName
    Windows service name. Default: PrintListener

.EXAMPLE
    # Install (run from repo root as Administrator)
    .\scripts\Install-Service.ps1

    # Remove
    .\scripts\Install-Service.ps1 -Action Remove

    # Check status
    .\scripts\Install-Service.ps1 -Action Status

.NOTES
    Download NSSM: https://nssm.cc/download
    Place nssm.exe in .\tools\nssm.exe  (ignored by .gitignore)
#>

[CmdletBinding()]
param (
    [ValidateSet("Install","Remove","Status")]
    [string] $Action      = "Install",

    [string] $NssmPath    = (Join-Path $PSScriptRoot "..\tools\nssm.exe"),
    [string] $ScriptPath  = (Join-Path $PSScriptRoot "..\PrintListener.ps1"),
    [string] $ServiceName = "PrintListener"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# ─── Resolve absolute paths ───────────────────
$NssmPath   = Resolve-Path $NssmPath   -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Path
$ScriptPath = Resolve-Path $ScriptPath -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Path
$LogDir     = Join-Path (Split-Path $ScriptPath -Parent) "logs"

function Write-Step { param([string]$Msg) Write-Host "  >> $Msg" -ForegroundColor Cyan }
function Write-OK   { param([string]$Msg) Write-Host "  OK $Msg" -ForegroundColor Green }
function Write-Fail { param([string]$Msg) Write-Host "  !! $Msg" -ForegroundColor Red }

# ─── STATUS ──────────────────────────────────
if ($Action -eq "Status") {
    $svc = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue
    if ($svc) {
        Write-Host "`nService : $ServiceName"
        Write-Host "Status  : $($svc.Status)"
        Write-Host "StartType: $($svc.StartType)`n"
    } else {
        Write-Host "`nService '$ServiceName' is NOT installed.`n"
    }
    exit 0
}

# ─── REMOVE ──────────────────────────────────
if ($Action -eq "Remove") {
    Write-Step "Stopping service '$ServiceName'..."
    & $NssmPath stop $ServiceName confirm 2>&1 | Out-Null

    Write-Step "Removing service '$ServiceName'..."
    & $NssmPath remove $ServiceName confirm

    # Remove firewall rule
    Write-Step "Removing firewall rule..."
    Remove-NetFirewallRule -DisplayName "PrintListener 9100" -ErrorAction SilentlyContinue

    Write-OK "Service '$ServiceName' removed."
    exit 0
}

# ─── INSTALL ─────────────────────────────────

# Validate prerequisites
if (-not $NssmPath -or -not (Test-Path $NssmPath)) {
    Write-Fail "nssm.exe not found at: $NssmPath"
    Write-Host "  Download from https://nssm.cc/download and place at .\tools\nssm.exe"
    exit 1
}

if (-not $ScriptPath -or -not (Test-Path $ScriptPath)) {
    Write-Fail "PrintListener.ps1 not found at: $ScriptPath"
    exit 1
}

# Check if already installed
$existing = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue
if ($existing) {
    Write-Fail "Service '$ServiceName' already exists. Run with -Action Remove first."
    exit 1
}

# Ensure log directory exists
if (-not (Test-Path $LogDir)) {
    New-Item -ItemType Directory -Path $LogDir -Force | Out-Null
}

Write-Step "Installing service '$ServiceName'..."
& $NssmPath install $ServiceName powershell.exe `
    "-NoProfile -ExecutionPolicy Bypass -File `"$ScriptPath`""

Write-Step "Configuring service properties..."
& $NssmPath set $ServiceName DisplayName  "Print Listener (Port 9100)"
& $NssmPath set $ServiceName Description  "RAW/9100 print port listener for performance testing. Responds with dummy ACK."
& $NssmPath set $ServiceName Start        SERVICE_AUTO_START
& $NssmPath set $ServiceName AppStdout    (Join-Path $LogDir "service_stdout.log")
& $NssmPath set $ServiceName AppStderr    (Join-Path $LogDir "service_stderr.log")
& $NssmPath set $ServiceName AppRotateFiles      1
& $NssmPath set $ServiceName AppRotateBytes      10485760   # 10 MB
& $NssmPath set $ServiceName AppRestartDelay     3000       # 3s restart on crash

Write-Step "Adding Windows Firewall rule for TCP 9100..."
$fwRule = Get-NetFirewallRule -DisplayName "PrintListener 9100" -ErrorAction SilentlyContinue
if (-not $fwRule) {
    New-NetFirewallRule `
        -DisplayName "PrintListener 9100" `
        -Direction   Inbound `
        -Protocol    TCP `
        -LocalPort   9100 `
        -Action      Allow `
        -Profile     Any | Out-Null
    Write-OK "Firewall rule created."
} else {
    Write-Host "  -- Firewall rule already exists, skipping."
}

Write-Step "Starting service..."
Start-Service -Name $ServiceName

$svc = Get-Service -Name $ServiceName
Write-OK "Service '$ServiceName' installed and running."
Write-Host ""
Write-Host "  Status   : $($svc.Status)"
Write-Host "  StartType: Automatic (starts on reboot)"
Write-Host "  Logs     : $LogDir"
Write-Host ""
Write-Host "  Test with:"
Write-Host "    .\scripts\Test-Listener.ps1"
Write-Host ""
