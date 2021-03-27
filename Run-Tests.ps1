Import-Module Pester, PSScriptAnalyzer -Force

$TestFiles = Get-ChildItem -File -Path "$PSScriptRoot" -Include "*.Tests.ps1" -Recurse
Invoke-Pester -Path $TestFiles -OutputFile TestResult.xml -OutputFormat NUnitXml
