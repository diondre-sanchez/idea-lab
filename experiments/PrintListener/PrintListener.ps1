# PrintListener.ps1
# Place this in: C:\PrintListener\PrintListener.ps1

$Port = 9100
$LogFile = "C:\PrintListener\listener.log"

function Write-Log {
    param([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp - $Message" | Out-File -FilePath $LogFile -Append -Encoding UTF8
}

Write-Log "PrintListener starting on port $Port"

$listener = [System.Net.Sockets.TcpListener]::new([System.Net.IPAddress]::Any, $Port)
$listener.Start()
Write-Log "Listener active on port $Port"

while ($true) {
    try {
        $client = $listener.AcceptTcpClient()
        $remoteEndpoint = $client.Client.RemoteEndPoint.ToString()
        Write-Log "Connection received from $remoteEndpoint"

        $stream = $client.GetStream()

        # Read incoming data (non-blocking, short window)
        $buffer = New-Object byte[] 4096
        $stream.ReadTimeout = 500
        try {
            $bytesRead = $stream.Read($buffer, 0, $buffer.Length)
            if ($bytesRead -gt 0) {
                $received = [System.Text.Encoding]::ASCII.GetString($buffer, 0, $bytesRead)
                Write-Log "Received $bytesRead bytes from $remoteEndpoint"
            }
        } catch {
            # Timeout on read is acceptable — client may have sent nothing
        }

        # Send dummy ACK response (mimics basic RAW/9100 acceptance)
        $ack = [System.Text.Encoding]::ASCII.GetBytes("ACK`r`n")
        $stream.Write($ack, 0, $ack.Length)
        $stream.Flush()

        Write-Log "ACK sent to $remoteEndpoint"

        $stream.Close()
        $client.Close()
    } catch {
        Write-Log "ERROR: $_"
        Start-Sleep -Seconds 2
    }
}