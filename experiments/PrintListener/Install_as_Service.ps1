# Step 1 — Download NSSM if not already present
# https://nssm.cc/download — place nssm.exe in C:\PrintListener\

# Step 2 — Install the service
C:\PrintListener\nssm.exe install PrintListener "powershell.exe" `
    "-NoProfile -ExecutionPolicy Bypass -File C:\PrintListener\PrintListener.ps1"

# Step 3 — Set service description and startup type
C:\PrintListener\nssm.exe set PrintListener Description "Port 9100 Print Listener for Performance Testing"
C:\PrintListener\nssm.exe set PrintListener Start SERVICE_AUTO_START

# Step 4 — Redirect stdout/stderr to log (optional but useful)
C:\PrintListener\nssm.exe set PrintListener AppStdout C:\PrintListener\service.log
C:\PrintListener\nssm.exe set PrintListener AppStderr C:\PrintListener\service_err.log

# Step 5 — Start the service
Start-Service PrintListener



# Open Port 9100
New-NetFirewallRule -DisplayName "PrintListener 9100" `
    -Direction Inbound `
    -Protocol TCP `
    -LocalPort 9100 `
    -Action Allow `
    -Profile Any




# Check service is running
Get-Service PrintListener

# Confirm port is listening
netstat -ano | findstr :9100

# Quick test from the same machine
$tcp = New-Object System.Net.Sockets.TcpClient("127.0.0.1", 9100)
$stream = $tcp.GetStream()
$reader = New-Object System.IO.StreamReader($stream)
$response = $reader.ReadLine()
Write-Host "Response: $response"
$tcp.Close()