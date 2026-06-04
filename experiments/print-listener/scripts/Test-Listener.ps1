#Requires -Version 5.1
<#
.SYNOPSIS
    Smoke-tests the PrintListener on port 9100.

.DESCRIPTION
    Opens a TCP connection to the listener, optionally sends a payload,
    and validates that an ACK is returned. Exits 0 on success, 1 on failure.

.PARAMETER Host
    Target hostname or IP. Default: 127.0.0.1

.PARAMETER Port
    Target port. Default: 9100

.PARAMETER Payload
    Optional string payload to send. Simulates a print job header.

.PARAMETER TimeoutSeconds
    Connection and read timeout. Default: 5

.EXAMPLE
    .\scripts\Test-Listener.ps1
    .\scripts\Test-Listener.ps1 -Host 192.168.1.50 -Port 9100
    .\scripts\Test-Listener.ps1 -Payload "ESC%-12345X@PJL JOB"
#>

[CmdletBinding()]
param(
    [string] $TargetHost      = "127.0.0.1",
    [int]    $Port            = 9100,
    [string] $Payload         = "TEST_PRINT_JOB`r`n",
    [int]    $TimeoutSeconds  = 5
)

$success = $false

try {
    Write-Host ""
    Write-Host "PrintListener Test" -ForegroundColor Cyan
    Write-Host "──────────────────────────────────────────"
    Write-Host "  Target  : ${TargetHost}:${Port}"
    Write-Host "  Payload : $($Payload.Trim())"
    Write-Host "  Timeout : ${TimeoutSeconds}s"
    Write-Host ""

    # ── Connect ──────────────────────────────
    Write-Host "  [1/3] Connecting..." -NoNewline
    $tcp = New-Object System.Net.Sockets.TcpClient
    $connectResult = $tcp.BeginConnect($TargetHost, $Port, $null, $null)
    $connected = $connectResult.AsyncWaitHandle.WaitOne([TimeSpan]::FromSeconds($TimeoutSeconds))

    if (-not $connected -or -not $tcp.Connected) {
        throw "Connection timed out or refused."
    }
    $tcp.EndConnect($connectResult)
    Write-Host " Connected." -ForegroundColor Green

    $stream = $tcp.GetStream()
    $stream.ReadTimeout  = $TimeoutSeconds * 1000
    $stream.WriteTimeout = $TimeoutSeconds * 1000

    # ── Send payload ─────────────────────────
    Write-Host "  [2/3] Sending payload..." -NoNewline
    $bytes = [System.Text.Encoding]::ASCII.GetBytes($Payload)
    $stream.Write($bytes, 0, $bytes.Length)
    $stream.Flush()
    Write-Host " Sent $($bytes.Length) byte(s)." -ForegroundColor Green

    # ── Read ACK ─────────────────────────────
    Write-Host "  [3/3] Waiting for ACK..." -NoNewline
    $buffer   = New-Object byte[] 256
    $bytesRx  = $stream.Read($buffer, 0, $buffer.Length)
    $response = [System.Text.Encoding]::ASCII.GetString($buffer, 0, $bytesRx).Trim()

    if ($response -eq "ACK") {
        Write-Host " Received: '$response'" -ForegroundColor Green
        $success = $true
    } else {
        Write-Host " Unexpected response: '$response'" -ForegroundColor Yellow
    }

} catch {
    Write-Host " FAILED" -ForegroundColor Red
    Write-Host ""
    Write-Host "  Error: $_" -ForegroundColor Red

} finally {
    try { if ($stream) { $stream.Close() } } catch {}
    try { if ($tcp)    { $tcp.Close()    } } catch {}
}

Write-Host ""
Write-Host "──────────────────────────────────────────"

if ($success) {
    Write-Host "  RESULT: PASS — Listener is healthy." -ForegroundColor Green
    Write-Host ""
    exit 0
} else {
    Write-Host "  RESULT: FAIL — Check service status and logs." -ForegroundColor Red
    Write-Host "    Get-Service PrintListener"
    Write-Host "    Get-Content .\logs\listener.log -Tail 20"
    Write-Host ""
    exit 1
}
