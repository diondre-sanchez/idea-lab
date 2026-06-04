#Requires -Version 5.1
<#
.SYNOPSIS
    TCP listener on port 9100 for print job simulation and performance testing.

.DESCRIPTION
    Binds to TCP port 9100, accepts incoming connections, reads data from the
    client, and responds with a dummy ACK. Designed to simulate a RAW/JetDirect
    print endpoint. Intended to run as a Windows Service via NSSM.

.PARAMETER Port
    TCP port to listen on. Default: 9100

.PARAMETER LogFile
    Path to the log file. Default: <script directory>\logs\listener.log

.PARAMETER MaxLogSizeMB
    Max log file size in MB before rotation. Default: 10

.EXAMPLE
    .\PrintListener.ps1
    .\PrintListener.ps1 -Port 9100 -LogFile "C:\Logs\print.log"

.NOTES
    Author:      MOR / Performance Testing
    Requires:    PowerShell 5.1+, Run as Administrator (for port binding)
    Service Mgr: NSSM (https://nssm.cc)
#>

[CmdletBinding()]
param (
    [int]    $Port          = 9100,
    [string] $LogFile       = (Join-Path $PSScriptRoot "logs\listener.log"),
    [int]    $MaxLogSizeMB  = 10
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# ─────────────────────────────────────────────
#  Logging
# ─────────────────────────────────────────────

function Initialize-Log {
    $logDir = Split-Path $LogFile -Parent
    if (-not (Test-Path $logDir)) {
        New-Item -ItemType Directory -Path $logDir -Force | Out-Null
    }
}

function Write-Log {
    param(
        [string] $Message,
        [ValidateSet("INFO","WARN","ERROR")] [string] $Level = "INFO"
    )
    $entry = "[{0}] [{1}] {2}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"), $Level, $Message

    # Console output (visible in NSSM service log)
    Write-Host $entry

    # Rotate log if over size limit
    if ((Test-Path $LogFile) -and ((Get-Item $LogFile).Length / 1MB) -ge $MaxLogSizeMB) {
        $archive = $LogFile -replace '\.log$', ("_{0}.log" -f (Get-Date -Format "yyyyMMdd_HHmmss"))
        Move-Item $LogFile $archive -Force
    }

    Add-Content -Path $LogFile -Value $entry -Encoding UTF8
}

# ─────────────────────────────────────────────
#  Cleanup on exit
# ─────────────────────────────────────────────

function Stop-Listener {
    param($TcpListener)
    if ($null -ne $TcpListener) {
        try { $TcpListener.Stop() } catch {}
        Write-Log "Listener stopped."
    }
}

# ─────────────────────────────────────────────
#  Handle a single client connection
# ─────────────────────────────────────────────

function Invoke-ClientSession {
    param([System.Net.Sockets.TcpClient] $Client)

    $remote = $Client.Client.RemoteEndPoint.ToString()
    Write-Log "Connection from $remote"

    try {
        $stream = $Client.GetStream()
        $stream.ReadTimeout = 1000   # 1s read window

        # ── Read incoming data ──────────────────
        $buffer    = New-Object byte[] 8192
        $bytesRead = 0

        try {
            $bytesRead = $stream.Read($buffer, 0, $buffer.Length)
        } catch [System.IO.IOException] {
            # Timeout is acceptable — client may connect without sending data first
        }

        if ($bytesRead -gt 0) {
            Write-Log "Received $bytesRead byte(s) from $remote"
        } else {
            Write-Log "No data received from $remote (connection only)" -Level "WARN"
        }

        # ── Send ACK ───────────────────────────
        # Mimics a minimal JetDirect/RAW port acknowledgement
        $ack = [System.Text.Encoding]::ASCII.GetBytes("ACK`r`n")
        $stream.Write($ack, 0, $ack.Length)
        $stream.Flush()
        Write-Log "ACK sent to $remote"

    } catch {
        Write-Log "Session error for $remote`: $_" -Level "ERROR"
    } finally {
        try { $Client.Close() } catch {}
    }
}

# ─────────────────────────────────────────────
#  Main
# ─────────────────────────────────────────────

Initialize-Log
Write-Log "PrintListener initializing | Port: $Port | Log: $LogFile"

$listener = $null

try {
    $listener = [System.Net.Sockets.TcpListener]::new(
        [System.Net.IPAddress]::Any, $Port
    )
    $listener.Start()
    Write-Log "Listening on 0.0.0.0:$Port — waiting for connections..."

    while ($true) {
        try {
            $client = $listener.AcceptTcpClient()
            Invoke-ClientSession -Client $client
        } catch [System.Net.Sockets.SocketException] {
            # Thrown when listener is stopped externally (service stop)
            Write-Log "Socket closed — shutting down." -Level "WARN"
            break
        } catch {
            Write-Log "Unexpected error in accept loop: $_" -Level "ERROR"
            Start-Sleep -Seconds 2
        }
    }

} catch {
    Write-Log "Fatal error: $_" -Level "ERROR"
    exit 1

} finally {
    Stop-Listener -TcpListener $listener
}
