[CmdletBinding()]
param ()

$ErrorActionPreference = "Stop"

$ModuleName = "MyRemoteManager"
$Source = Join-Path -Path $PSScriptRoot -ChildPath "Source"
$Build = Join-Path -Path $PSScriptRoot -ChildPath "Build"

$Header = Get-Item -Path "$Source\$ModuleName.Header.ps1"
$Variables = Get-Item -Path "$Source\$ModuleName.Variables.ps1"
$Classes = Get-ChildItem -Path "$Source\Classes\*.ps1" -Exclude "*.Tests.*" | Sort-Object Name
$PrivateFunctions = Get-ChildItem -Path "$Source\Private\*.ps1" -Exclude "*.Tests.*"
$PublicFunctions = Get-ChildItem -Path "$Source\Public\*.ps1" -Exclude "*.Tests.*"
$Footer = Get-Item -Path "$Source\$ModuleName.Footer.ps1"

Write-Information -MessageData "[build][start] --- build started ---"

#region Initialize build environment
if (-not (Test-Path -Path $Build -PathType Container)) {
    Write-Information -MessageData "[build][init] Create build directory."
    New-Item -Path $Build -ItemType Directory | Out-Null
}
#endregion Initialize build environment

#region Build module file
Write-Information -MessageData "[build][module] Start build module file."

$ModuleFile = @{
    Path     = "$Build\$ModuleName.psm1"
    Encoding = "utf8"
}

if (Test-Path -Path $ModuleFile.Path) {
    Write-Information -MessageData "[build][module] Remove old file."
    Remove-Item -Path $ModuleFile.Path -Force
}

# Add header
Write-Information -MessageData "[build][module] Add header."
Add-Content @ModuleFile -Value ((Get-Content -Path $Header.FullName) + "`n")

# Add global variable declarations
Write-Information -MessageData "[build][module] Add global variable declarations."
Add-Content @ModuleFile -Value ((Get-Content -Path $Variables.FullName) + "`n")

# Add classes
Add-Content @ModuleFile -Value "#region Classes"
$Classes | ForEach-Object {
    Write-Information -MessageData ("[build][module] Add class {0}." -f $_.Basename)
    Add-Content @ModuleFile -Value (Get-Content -Path $_.FullName)
}
Add-Content @ModuleFile -Value "#endregion Classes`n"

# Add private functions
Add-Content @ModuleFile -Value "#region Private functions"
$PrivateFunctions | ForEach-Object {
    Write-Information -MessageData ("[build][module] Add private function {0}." -f $_.Basename)
    Add-Content @ModuleFile -Value (Get-Content -Path $_.FullName)
}
Add-Content @ModuleFile -Value "#endregion Private functions`n"

# Add public functions
Add-Content @ModuleFile -Value "#region Public functions"
$PublicFunctions | ForEach-Object {
    Write-Information -MessageData ("[build][module] Add public function {0}." -f $_.Basename)
    Add-Content @ModuleFile -Value (Get-Content -Path $_.FullName)
}
Add-Content @ModuleFile -Value "#endregion Public functions`n"

# Add footer
Write-Information -MessageData "[build][module] Add footer."
Add-Content @ModuleFile -Value (Get-Content -Path $Footer.FullName)

Write-Information -MessageData "[build][module] Done."
#endregion Build module file

#region Copy and update manifest
Write-Information -MessageData "[build][manifest] Start build manifest file."

# Copy manifest file from source
Write-Information -MessageData "[build][manifest] Copy manifest."
Copy-Item -Path "$Source\$ModuleName.psd1" -Destination "$Build\$ModuleName.psd1"

# Copy Update manifest
Write-Information -MessageData "[build][manifest] Update manifest."
Update-ModuleManifest -Path "$Build\$ModuleName.psd1" -FunctionsToExport $PublicFunctions.BaseName

Write-Information -MessageData "[build][manifest] Done."
#endregion Copy and update manifest

Write-Information -MessageData "[build][end] --- build finished ---"
