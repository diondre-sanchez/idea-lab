# PrintListener

A lightweight TCP listener for **port 9100** (RAW/JetDirect) designed for print controller performance testing on Windows Server. Accepts incoming connections from a dummy printer (`127.0.0.1`), reads the payload, and responds with a dummy `ACK`. Runs as a persistent Windows Service via [NSSM](https://nssm.cc) and survives reboots automatically.

---

## Features

- Binds to `0.0.0.0:9100` (all interfaces) on startup
- Accepts connections, reads data, responds with `ACK\r\n`
- Structured timestamped logging with automatic log rotation
- Runs as a Windows Service (auto-start on boot)
- Includes install, remove, and smoke-test scripts
- No external PowerShell modules required

---

## Requirements

| Requirement | Notes |
|---|---|
| Windows Server 2016+ (or Windows 10+) | PowerShell 5.1 included |
| PowerShell 5.1+ | Pre-installed on all modern Windows |
| Administrator privileges | Required for port binding and service install |
| [NSSM](https://nssm.cc/download) | Place `nssm.exe` in `.\tools\` (not committed) |

---

## Repository Structure

```
print-listener/
├── PrintListener.ps1          # Main listener script
├── scripts/
│   ├── Install-Service.ps1    # Install / remove the Windows Service
│   └── Test-Listener.ps1      # Smoke-test the running listener
├── tools/                     # Place nssm.exe here (gitignored)
├── logs/                      # Runtime logs (gitignored)
├── .gitignore
└── README.md
```

---

## Quick Start

### 1. Clone the repo

```powershell
git clone https://github.com/YOUR_USERNAME/print-listener.git
cd print-listener
```

### 2. Download NSSM

Download from [https://nssm.cc/download](https://nssm.cc/download) and place `nssm.exe` in the `tools\` folder:

```
print-listener\
└── tools\
    └── nssm.exe
```

### 3. Install the service (run as Administrator)

```powershell
.\scripts\Install-Service.ps1
```

This will:
- Register `PrintListener` as a Windows Service
- Set startup type to **Automatic** (survives reboot)
- Add a Windows Firewall inbound rule for TCP 9100
- Start the service immediately

### 4. Verify it's working

```powershell
.\scripts\Test-Listener.ps1
```

Expected output:
```
PrintListener Test
──────────────────────────────────────────
  Target  : 127.0.0.1:9100
  Payload : TEST_PRINT_JOB
  Timeout : 5s

  [1/3] Connecting... Connected.
  [2/3] Sending payload... Sent 16 byte(s).
  [3/3] Waiting for ACK... Received: 'ACK'

──────────────────────────────────────────
  RESULT: PASS — Listener is healthy.
```

---

## Service Management

```powershell
# Check status
.\scripts\Install-Service.ps1 -Action Status

# Stop the service
Stop-Service PrintListener

# Start the service
Start-Service PrintListener

# Remove the service and firewall rule
.\scripts\Install-Service.ps1 -Action Remove
```

---

## Logs

Logs are written to `.\logs\listener.log` and auto-rotate at 10 MB.

```powershell
# Tail live log
Get-Content .\logs\listener.log -Wait -Tail 20
```

Log format:
```
[2025-06-03 14:22:01] [INFO]  PrintListener initializing | Port: 9100
[2025-06-03 14:22:01] [INFO]  Listening on 0.0.0.0:9100 — waiting for connections...
[2025-06-03 14:22:10] [INFO]  Connection from 127.0.0.1:54312
[2025-06-03 14:22:10] [INFO]  Received 16 byte(s) from 127.0.0.1:54312
[2025-06-03 14:22:10] [INFO]  ACK sent to 127.0.0.1:54312
```

---

## Running Manually (without the service)

```powershell
# Run directly in your terminal (Ctrl+C to stop)
powershell -ExecutionPolicy Bypass -File .\PrintListener.ps1

# Run on a custom port
powershell -ExecutionPolicy Bypass -File .\PrintListener.ps1 -Port 9101
```

---

## Troubleshooting

| Issue | Fix |
|---|---|
| Port already in use | `netstat -ano \| findstr :9100` to find the PID |
| Service won't start | Check `.\logs\service_stderr.log` |
| ACK not received | Confirm firewall rule: `Get-NetFirewallRule -DisplayName "PrintListener 9100"` |
| Execution policy error | Run `Set-ExecutionPolicy RemoteSigned -Scope LocalMachine` as admin |

---

## License

MIT
