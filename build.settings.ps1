$ProjectRoot = $PSScriptRoot

$ModuleName = "MyRemoteManager"
$ModuleVersion = "0.2.0"

$Source = Join-Path -Path $ProjectRoot -ChildPath "Source"
$Tests = Join-Path -Path $ProjectRoot -ChildPath "Tests"
$Out = Join-Path -Path $ProjectRoot -ChildPath "Out\$ModuleName\$ModuleVersion"

@{
    # Project
    ProjectRoot                 = $ProjectRoot
    # Module
    ModuleName                  = $ModuleName
    ModuleVersion               = $ModuleVersion
    # Source
    Source                      = $Source
    SourceHeader                = Get-Item -Path "$Source\$ModuleName.Header.ps1"
    SourceData                  = Get-ChildItem -Path "$Source\Data\*.psd1"
    SourceEnums                 = Get-ChildItem -Path "$Source\Enums\*.ps1"
    SourceClasses               = Get-ChildItem -Path "$Source\Classes\*.ps1" | Sort-Object Name
    #SourcePrivateFunctions = Get-ChildItem -Path "$Source\Private\*.ps1"
    SourcePublicFunctions       = Get-ChildItem -Path "$Source\Public\*.ps1"
    SourceManifest              = Join-Path -Path $Source -ChildPath "$ModuleName.psd1"
    # Tests
    Tests                       = $Tests
    TestsFiles                  = Get-ChildItem -File -Path $Tests -Include "*.Tests.ps1" -Recurse
    TestsScriptAnalyzerSettings = Join-Path -Path $Tests -ChildPath "PSScriptAnalyzerSettings.psd1"
    TestOut                     = Join-Path -Path $Tests -ChildPath "TestResults.xml"
    # Out
    Out                         = $Out
    OutModule                   = Join-Path -Path $Out -ChildPath "$ModuleName.psm1"
    OutManifest                 = Join-Path -Path $Out -ChildPath "$ModuleName.psd1"
    # Other
    Encoding                    = "utf8"
}
