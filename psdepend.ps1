Install-Module PSDepend
Import-Module PSDepend

$RequirementsFile = Join-Path -Path $PSScriptRoot -ChildPath requirements.psd1

Invoke-PSDepend -Path $RequirementsFile
