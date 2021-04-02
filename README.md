# MyRemoteManager

## Description

MyRemoteManager is a PowerShell module which contains a collection of functions for managing remote connections.

It is a very (very) simplied version of mRemoteNG, MobaXterm, and other similar tools.

---

## Installation

To install the PowerShell module, follow one of the following methods.

### Get released versions

Download files from [Releases](https://github.com/VouDoo/MyRemoteManager/releases) and extract in `C:\Users\<your_user>\Documents\PowerShell\Modules\`.

### Build from Source

1. Build the module

    ```powershell
    .\build.ps1 build -Bootstrap
    ```

2. Remove any old versions of the module

    ```powershell
    Remove-Item "$HOME\Documents\PowerShell\Modules\MyRemoteManager" -Force
    ```

3. Install the freshly built module

    ```powershell
    Copy-Item ".\Out\MyRemoteManager" "$HOME\Documents\PowerShell\Modules\" -Recurse
    ```

---

## Usage

### Prepare your environment

1. Import the module

    ```powershell
    Import-Module -Name MyRemoteManager
    ```

2. Get the available commands

    ```powershell
    Get-Command -Module MyRemoteManager
    ```

The fastest way to use the module is to import it from your [PowerShell profile](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_profiles?view=powershell-7.1). Then, each time you will open your PowerShell console, the module will be automatically imported.

We also recommend that you create aliases for the most commonly used commands.

Here is an example of code you can append in your profile file:

```powershell
# Add in Microsoft.PowerShell_profile.ps1
Import-Module -Name MyRemoteManager
New-Alias -Name co -Value Invoke-MyRMConnection
New-Alias -Name coGet -Value Get-MyRMConnection.ps1
New-Alias -Name coAdd -Value Add-MyRMConnection.ps1
New-Alias -Name coRm -Value Remove-MyRMConnection.ps1
```

_feel free to use your own aliases!_

### Create an inventory file

First, you need to create an inventory file, where your connections will be stored.

To do so, run:

```powershell
New-MyRMInventory
```

By default, the inventory file is created in your user's home directory as `MyRemoteManager.json`.

To use a custom path, run:

```powershell
Set-MyRMInventoryPath "C:\path\to\your\MyInventory.json"
```

_Note that the inventory uses the JSON format._

### Create a client

Clients are defined programs that are executed when you invoke a connection.

To add your first client, run:

```powershell
Add-MyRMClient -Name MySSH -Executable "ssh.exe" -Arguments "-l <user> -p <port> <host>" -DefaultPort 22 -Description "My first SSH client"
```

The `-Arguments` parameter takes a tokenized string which represents the arguments passed to the executable.

Here is the list of tokens to include in the this string:

| Token    | Required | Description |
|:--------:|:--------:| :---------- |
| `<host>` | Yes      | Name of the remote host. |
| `<port>` | Yes      | Port to connect to on the remote host. |
| `<user>` | No       | Name of the user to log in with.</br>If set, Invoke-MyRMConnection will ask for a username at each execution. |

### Create a connection

To add your first connection, run:

```powershell
Add-MyRMConnection -Name Perseverance -Hostname perseverance.mars.solarsys -Client MySSH -Description "My connection to the Perseverance Rover"
```

**Tip**: _Use the `TAB` key to autocomplete the name of the client._

### Invoke your connection

To connect to your remote host, run:

```powershell
Invoke-MyRMConnection Perseverance
```

**Tip**: _Use the `TAB` key to autocomplete the name of the connection._

### Get help

Use [the `Get-Help` Cmdlet](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/get-help?view=powershell-7.1) and specify the command on which you want to obtain more information.
