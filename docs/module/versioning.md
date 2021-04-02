# Module - Versioning

## Versioning

This project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

Version must respect the format `<major>.<minor>.<patch>`.
In the examples, this is represented by `M.m.p`.

## How to bump the module version

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
