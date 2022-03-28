# Contributing

- [Contributing](#contributing)
  - [Build and use the module](#build-and-use-the-module)
  - [Other useful commands](#other-useful-commands)
    - [Test the module](#test-the-module)
    - [Generate documentation](#generate-documentation)
    - [Publish to PSGallery](#publish-to-psgallery)
    - [Clean up your mess](#clean-up-your-mess)

## Build and use the module

1. Clone the repository to your local disk

   ```sh
   git clone https://github.com/VouDoo/MyRemoteManager
   cd MyRemoteManager
   ```

2. Build the module

   ```powershell
   ./build.ps1 -Bootstrap Build
   ```

3. Import the module

   ```powershell
   Import-Module -Name .\Out\MyRemoteManager\<x.x.x>\MyRemoteManager.psd1 -Force
   ```

4. Get the available commands

   ```powershell
   Get-Command -Module MyRemoteManager
   ```

## Other useful commands

### Test the module

_This command runs PSScriptAnalyzer and the Pester tests._

```powershell
./build.ps1 Test
```

### Generate documentation

_This command generates the Help documentation for each public cmdlet._

```powershell
./build.ps1 BuildHelp
```

### Publish to PSGallery

_Before executing the command, you must read [publish.md](./docs/development/module/publish.md)._

```powershell
./build.ps1 Publish
```

### Clean up your mess

```powershell
./build.ps1 Clean
```
