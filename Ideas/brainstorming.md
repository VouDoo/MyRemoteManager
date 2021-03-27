# Brainstorming

## Why?

MyRemoteManager is a PowerShell module that provides functions to manage and initiate remote connections.

## Inventory

Connections are stored in an inventory file.

The inventory file respects the JSON format.

By default, it is saved in the `$HOME` directory as `MyRemoteManager.json`.

The `MY_RM_INVENTORY` environment variable can be set to define the path to the inventory file.

The inventory file contains the following items:

``` txt
- Clients: Collection of clients (programs/commands) used by the connection entries
    - A client entry is defined as following:
        - Name: Short name of the client
        - Command: Template of the command line to execute
            - Template tokens in the string:
                - <host>
                - <user>
                - <port>
        - RequiresCmdKey: Execute CmdKey to register the user before running the command
            - For instance, this is required for the Remote Desktop client (mstsc.exe)
        - DefaultPort: Default client network port
        - Description: Short description of the client
    - When an inventory file is created, it must include those types by default:
        - Remote Desktop Connection
            - Name: RD
            - Command: C:\Windows\System32\mstsc.exe /v:<host>:<port> /fullscreen
            - RequiresCmdKey: True
            - Port: 3389
            - Description: Microsoft Remote Desktop
        - OpenSSH (installed as Microsoft Windows feature)
            - Name: SSH
            - Command: C:\Windows\System32\OpenSSH\ssh.exe -l <user> -p <port> <host>
            - RequiresCmdKey: False
            - Port: 22
            - Description: Microsoft OpenSSH
        - PowerShell Session HTTP
            - Name: PSSessionHTTP
            - Command: Enter-PSSession -ComputerName <host> -Credential <user> -Port <port>
            - RequiresCmdKey: False
            - Port: 5985
            - Description: PowerShell Session over HTTP (non-secure)
        - PowerShell Session HTTPS
            - Name: PSSessionHTTPS
            - RequiresCmdKey: False
            - Command: Enter-PSSession -ComputerName <host> -Credential <user> -Port <port> -UseSSL
            - Port: 5986
            - Description: PowerShell Session over HTTPS (secure)
- Connections: collection of connection entries
    - A connection entry is defined as following:
        - Name: Name of the connection [required]
        - Hostname: Name of the remote host [required]
        - User: User to log in as on the remote host [required]
            - Examples: "maxence" (Linux-like), "Domain\Maxence" (Windows-like)
        - Client: Client to use to connect to the remote host [required]
        - Port: Port to connect to on the remote host
            - If not specified, use Client's default port
        - Project: Name of the project or category
            - If empty, set as "undefined"
        - Description: Short description of the remote machine
```

## CmdKey

See <https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/cmdkey>
