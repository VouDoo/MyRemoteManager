# Clients

The list below shows you various examples of clients, which can be added in your inventory.

## OpenSSH from Microsoft Windows features

Note: _This is part of the default clients when a new inventory is created._

- Executable: `C:\Windows\System32\OpenSSH\ssh.exe`
- Arguments: `-l <user> -p <port> <host>`
- Default port: `22`

```powershell
Add-MyRMClient -Name OpenSSH -Executable "C:\Windows\System32\OpenSSH\ssh.exe" -Arguments "-l <user> -p <port> <host>" -DefaultPort 22 -Description "OpenSSH (Microsoft Windows feature)"
```

## Putty SSH

Note: _This is part of the default clients when a new inventory is created._

- Executable: `putty.exe` (from PATH)
- Arguments: `-ssh -P <port> <user>@<host>`
- Default port: `22`

```powershell
Add-MyRMClient -Name PuTTY_SSH -Executable "putty.exe" -Arguments "-ssh -P <port> <user>@<host>" -DefaultPort 22 -Description "PuTTY using SSH protocol"
```

## Remote Desktop

Note: _This is part of the default clients when a new inventory is created._

- Executable: `C:\Windows\System32\mstsc.exe`
- Arguments: `/v:<host>:<port> /fullscreen`
- Default port: `3389`

```powershell
Add-MyRMClient -Name RD -Executable "C:\Windows\System32\mstsc.exe" -Arguments "/v:<host>:<port> /fullscreen" -DefaultPort 3389 -Description "Microsoft Remote Desktop"
```

## Google Chrome

- Executable: `C:\Program Files (x86)\Google\Chrome\Application\chrome.exe`
- Arguments: `<host>:<port>`
- Default port: `443`

```powershell
Add-MyRMClient -Name Chrome -Executable "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" -Arguments "<host>:<port>" -DefaultPort 443 -Description "Google Chrome"
```

## Telnet from Microsoft Windows features

- Executable: `C:\Windows\System32\telnet.exe`
- Arguments: `<host> <port>`
- Default port: `23`

```powershell
Add-MyRMClient -Name Telnet -Executable "C:\Windows\System32\telnet.exe" -Arguments "<host> <port>" -DefaultPort 23 -Description "Telnet (Microsoft Windows feature)"
```
