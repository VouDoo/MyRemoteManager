Import-Module psake

$psakefile = Join-Path -Path $PSScriptRoot -ChildPath "psakefile.ps1"
Invoke-psake -buildFile $psakefile -InformationAction Continue
