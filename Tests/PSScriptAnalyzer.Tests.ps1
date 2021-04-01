BeforeAll {
    $ModulePath = Join-Path -Path (Get-Item $PSScriptRoot).parent.FullName -ChildPath "Build\MyRemoteManager.psm1"
    Write-Debug -Message "Module Path: $ModulePath"
}
Describe 'Testing against PSScriptAnalyzer rules' {
    Context "PSScriptAnalyzer Standard Rules" {
        It "Should pass <IncludeRule>." -TestCases @(
            Get-ScriptAnalyzerRule | ForEach-Object {
                @{ IncludeRule = $_.RuleName }
            }
        ) {
            param($IncludeRule)
            Invoke-ScriptAnalyzer -Path $ModulePath -IncludeRule $IncludeRule | Should -BeNullOrEmpty
        }
    }
}
