# The module variables exist in the Script scope (equivalant to the module scope) and are set as read-only.
@(
    # Inventory
    @{
        Name        = "InventoryDefaultPath"
        Description = "Default path to the inventory file."
        Value       = Join-Path $HOME -ChildPath "MyRemoteManager.json"
    }
    @{
        Name        = "InventoryEnvironmentVariable"
        Description = "Name of the environment variable that defines the path to the inventory file."
        Value       = "MY_RM_INVENTORY"
    }
    @{
        Name        = "InventoryEncoding"
        Description = "Encoding used by the inventory file."
        Value       = "utf-8"
    }
    @{
        Name        = "InventoryBackupExtension"
        Description = "File extension used to backup the inventory file."
        Value       = "backup"
    }
    # Default clients
    @{
        Name        = "DefaultClientRD"
        Description = "Default Remote Desktop Client."
        Value       = New-Object -TypeName Client -ArgumentList "RD", "C:\Windows\System32\mstsc.exe /v:<host>:<port> /fullscreen", $true, 3389, "Microsoft Remote Desktop."
    }
    @{
        Name        = "DefaultClientSSH"
        Description = "Default OpenSSH Client."
        Value       = New-Object -TypeName Client -ArgumentList "SSH", "C:\Windows\System32\OpenSSH\ssh.exe -l <user> -p <port> <host>", $false, 22, "OpenSSH from Microsoft Windows feature."
    }
) | ForEach-Object -Process {
    New-Variable -Option ReadOnly -Scope Script -Name $_.Name -Description $_.Description -Value $_.Value
}
