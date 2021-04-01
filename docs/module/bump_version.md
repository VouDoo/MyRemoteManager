# Bump version

## Versionning

This project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

Version must respect the format `<major>.<minor>.<patch>`.

## How to bump the version

To bump the version number of the module,
edit the following files:

- Module manifest `Source\MyRemoteManager.psd1`, edit `ModuleVersion`:

   ```powershell
   @{
       # ...
       ModuleVersion = 'M.m.p'
       # ...
   }
   ```

- Build settings `build.settings.ps1`, edit `ModuleVersion`:

   ```powershell
    # ...
    $ModuleVersion = "M.m.p"
    # ...
   ```
