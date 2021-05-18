# Changelog

All notable changes to MyRemoteManager is documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [develop]

### Added

- `Hostname` parameter in `Get-MyRMConnection` to filter connections by hostname
- `Get-MyRMInventoryInfo` shows whether the inventory file exists or not
- Check and warn if duplicates exist at inventory file access
- `Test-MyRMConnection` Cmdlet to test a connection defined in the inventory

### Changed

- The maximum length of the Client/Connection Name has been increased from 30 to 50

### Fixed

- `Get-MyRMInventoryInfo` does not fail anymore if the inventory file does not exist

## [0.1.0]

### Added

- Initial release of the module
