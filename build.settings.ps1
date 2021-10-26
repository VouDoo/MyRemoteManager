$ProjectRoot = $PSScriptRoot

$ModuleName = "MyRemoteManager"
$ModuleVersion = "0.3.3"

$Source = Join-Path -Path $ProjectRoot -ChildPath "Source"
$Tests = Join-Path -Path $ProjectRoot -ChildPath "Tests"
$Out = Join-Path -Path $ProjectRoot -ChildPath "Out\$ModuleName\$ModuleVersion"
$Docs = Join-Path -Path $ProjectRoot -ChildPath "docs"

@{
    # Project
    ProjectRoot                 = $ProjectRoot
    # Module
    ModuleName                  = $ModuleName
    ModuleVersion               = $ModuleVersion
    # Source
    Source                      = $Source
    SourceHeader                = Get-Item -Path "$Source\$ModuleName.Header.ps1"
    SourceEnum                  = Get-ChildItem -Path "$Source\Enum" -Include "*.ps1" -Recurse -File
    SourceClasses               = Get-ChildItem -Path "$Source\Classes" -Include "*.ps1" -Recurse -File | Sort-Object Name
    SourcePrivateFunctions      = Get-ChildItem -Path "$Source\Private" -Include "*.ps1" -Recurse -File
    SourcePublicFunctions       = Get-ChildItem -Path "$Source\Public" -Include "*.ps1" -Recurse -File
    #SourceDataFiles             = Get-ChildItem -Path "$Source\Data"
    SourceManifest              = Join-Path -Path $Source -ChildPath "$ModuleName.psd1"
    # Tests
    Tests                       = $Tests
    TestsFiles                  = Get-ChildItem -Path $Tests -Include "*.Tests.ps1" -Recurse -File
    TestsScriptAnalyzerSettings = Join-Path -Path $Tests -ChildPath "PSScriptAnalyzerSettings.psd1"
    TestOut                     = Join-Path -Path $Tests -ChildPath "TestResults.xml"
    # Out
    Out                         = $Out
    OutModule                   = Join-Path -Path $Out -ChildPath "$ModuleName.psm1"
    OutManifest                 = Join-Path -Path $Out -ChildPath "$ModuleName.psd1"
    OutEncoding                 = "utf8"  # String
    # Docs
    Docs                        = $Docs
    DocsHelpOut                 = Join-Path -Path $Docs -ChildPath "cmdlet-help"
    DocsHelpOutEncoding         = "UTF-8"  # System.Text.Encoding
    DocsHelpLocale              = "EN-US"
    # Publish
    PublishApiKeyEnvVar         = "{0}_API_KEY" -f $ModuleName
    PublishRepository           = "PSGallery"
}
