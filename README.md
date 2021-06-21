# MyRemoteManager

MyRemoteManager is a PowerShell module that contains a collection of functions for managing remote connections.

It is a very (very) simplified version of mRemoteNG, MobaXterm, and other similar tools.

## License

MyRemoteManager is released under the terms of the MIT license.
See [LICENSE](LICENSE) for more information or see <https://opensource.org/licenses/MIT>.

---

## Installation

To install the PowerShell module, follow one of these methods:

- [Install from PS Gallery](#install-from-ps-gallery)
- [Get released versions](#get-released-versions)
- [Build from Source](#build-from-source)

Please note that the module is only available for PowerShell Core (7 or later).

Get the latest version of PS Core from [the official PowerShell repository](https://github.com/PowerShell/PowerShell/releases).

### Install from PS Gallery

The module is published on PowerShell Gallery.
See <https://www.powershellgallery.com/packages/MyRemoteManager>.

To install it, run:

```powershell
Install-Module -Name MyRemoteManager -Repository PSGallery
```

### Get released versions

Download `MyRemoteManager.zip` from [the "Releases" page](https://github.com/VouDoo/MyRemoteManager/releases).
Extract it in `C:\Users\<your_user>\Documents\PowerShell\Modules\`.

### Build from Source

1. Unblock downloaded scripts _(optional)_

    ```powershell
    Get-ChildItem -Filter *.ps1 | Unblock-File
    ```

2. Build the module

    ```powershell
    .\build.ps1 build -Bootstrap
    ```

3. Remove any old versions of the module

    ```powershell
    Remove-Item "$HOME\Documents\PowerShell\Modules\MyRemoteManager" -Force
    ```

4. Install the freshly built module

    ```powershell
    Copy-Item ".\Out\MyRemoteManager" "$HOME\Documents\PowerShell\Modules\" -Recurse
    ```

---

## Usage

- [Prepare your environment](#prepare-your-environment)
- [Create an inventory file](#create-an-inventory-file)
- [Add a client](#add-a-client)
- [Add a connection](#add-a-connection)
- [Invoke a connection](#invoke-a-connection)

### Prepare your environment

1. Import the module

    ```powershell
    Import-Module -Name MyRemoteManager
    ```

2. Get the available commands

    ```powershell
    Get-Command -Module MyRemoteManager
    ```

The fastest way to use the module is to import it from your [PowerShell profile](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_profiles?view=powershell-7.1).
Then, each time you will open your PowerShell console, the module will be automatically imported.

We also recommend that you create aliases for the most commonly used commands.

Here is an example of code that you can add to your profile file:

```powershell
# Add in Microsoft.PowerShell_profile.ps1
Import-Module -Name MyRemoteManager
New-Alias -Name co -Value Invoke-MyRMConnection
New-Alias -Name coTest -Value Test-MyRMConnection
New-Alias -Name coGet -Value Get-MyRMConnection
New-Alias -Name coAdd -Value Add-MyRMConnection
New-Alias -Name coRm -Value Remove-MyRMConnection
```

_Feel free to use your own aliases!_

### Create an inventory file

First, you need to create an inventory file, where your connections will be stored.

Use `New-MyRMInventory` to create the inventory file.
Simply run:

```powershell
New-MyRMInventory
```

By default, the inventory file is created in your user's home directory as `MyRemoteManager.json`.

To use a custom path, run:

```powershell
Set-MyRMInventoryPath "C:\path\to\your\Inventory.json"
```

_The inventory uses the JSON format._

### Add a client

Clients are defined programs that are interpreted and executed when you invoke a connection.

To add a client, use `Add-MyRMClient`.
For instance:

```powershell
Add-MyRMClient -Name MySSH -Executable "ssh.exe" -Arguments "-l <user> -p <port> <host>" -DefaultPort 22 -Description "My first SSH client"
```

Find out more examples [here](examples/clients.md).

The `-Arguments` parameter takes a tokenized string which represents the arguments passed to the executable.

_Some tokens must be present in this string._

| Token    | Required | Description |
|:--------:|:--------:| :---------- |
| `<host>` | Yes      | Name of the remote host. |
| `<port>` | Yes      | Port to connect to on the remote host. |
| `<user>` | No       | Name of the user to log in with.</br>If set, Invoke-MyRMConnection will ask for a username at each execution. |

### Add a connection

To add a connection, use `Add-MyRMConnection`.
For instance:

```powershell
Add-MyRMConnection -Name Perseverance -Hostname perseverance.mars.solarsys -Client MySSH -Description "My connection to the Perseverance Rover"
```

**Tip**: _Use the `TAB` key to autocomplete the name of the client._

### Invoke a connection

To invoke a connection, use `Invoke-MyRMConnection`.
For instance:

```powershell
Invoke-MyRMConnection Perseverance
```

**Tip**: _Use the `TAB` key to autocomplete the name of the connection._

### Get help

Use [the `Get-Help` Cmdlet](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/get-help?view=powershell-7.1) to obtain more information about a command.

---

## What's next?

Here are some ideas that future releases might cover:

- Make client arguments more flexible.
  - Remove required tokens when it is possible.
  - Add extra tokens with custom features.
- Implement specific error exceptions.
- Optimize code.
- Provide better documentation.
- Keep it simple, stupid.
- And more...

## Support

If you have any bug reports, log them on [the issue tracker](https://github.com/VouDoo/MyRemoteManager/issues).

If you have some suggestions, please don't hesitate to contact me (find email on [my GitHub profile](https://github.com/VouDoo)).
