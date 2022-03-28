# Contributing

- [Contributing](#contributing)
  - [Contributing Code](#contributing-code)
    - [Quick run](#quick-run)

## Contributing Code

### Quick run

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
