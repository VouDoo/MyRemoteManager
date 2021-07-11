# Changelog

All notable changes to MyRemoteManager is documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [develop]

## Fixed

- Bug in `Invoke-MyRMConnection`: null-valued client when the default client does not exist for a connection

## [0.3.2]

### Patch note

- Added more exception handlers

## [0.3.1]

### Patch note

- Code optimization
- Enhanced parameter validators
- Improved exception handlers

## [0.3.0]

### Added

- Scopes in which connections can be invoked
- `DefaultScope` parameter in `Add-MyRMClient` to define a default scope associated to the new client
- Default user for connections
- `DefaultUser` parameter in `Add-MyRMConnection` to define a default user associated to the new connection
- `DefaultClient` parameter in `Add-MyRMConnection` to define a default client associated to the new connection
- `Client` parameter (alias `c`) in `Invoke-MyRMConnection` to define a client to use to initiate the connection
- `User` parameter (alias `u`) in `Invoke-MyRMConnection` to define a user to connect with
- `Scope` parameter (alias `x`) in `Invoke-MyRMConnection` to define a scope in which the connection will be invoked
- Debug messages in `Invoke-MyRMConnection` Cmdlet
- Markdown help files in [docs/cmdlet-help](docs/cmdlet-help) generated with [platyPS module](https://github.com/PowerShell/platyPS)

### Changed

- Connections have a default client instead of a "fixed" client

### Removed

- `RunInCurrentScope` parameter (alias `X`) in `Invoke-MyRMConnection` to start the connection process in the current console

## [0.2.0]

### Added

- `Hostname` parameter in `Get-MyRMConnection` to filter connections by hostname
- `Get-MyRMInventoryInfo` shows whether the inventory file exists or not
- Check and warn if duplicates exist at inventory file access
- `Test-MyRMConnection` Cmdlet to test a connection defined in the inventory
- `RunInCurrentScope` parameter (alias `X`) in `Invoke-MyRMConnection` to start the connection process in the current console

### Changed

- The maximum length of the Client/Connection Name has been increased from 30 to 50
- Module is supported for PowerShell version 7 and later

### Fixed

- `Get-MyRMInventoryInfo` does not fail anymore if the inventory file does not exist

## [0.1.0]

### Added

- Initial release of the module
