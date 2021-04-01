Install-Module -Name PSDepend
Import-Module -Name PSDepend

$RequirementsFile = Join-Path -Path $PSScriptRoot -ChildPath requirements.psd1
Invoke-PSDepend -Path $RequirementsFile
