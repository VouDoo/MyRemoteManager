Properties {
    $Settings = . (Join-Path -Path $PSScriptRoot -ChildPath "build.settings.ps1")
}

Task default -depends Test

Task Init {
    "[env] Testing with PowerShell {0}" -f $PSVersionTable.PSVersion.ToString()
} -description "Initialize build environment"

Task Test -depends Init, Analyze, Pester -description "Run test suite"

Task Analyze -depends Build {
    $Results = Invoke-ScriptAnalyzer -Path $Settings.Out -Recurse `
        -Settings $Settings.TestsScriptAnalyzerSettings -Verbose:$false
    $Errors = $Results | Where-Object { $_.Severity -eq 'Error' }
    if (@($Errors).Count -gt 0) {
        Write-Error -Message 'One or more Script Analyzer errors were found. Build cannot continue!'
        $Errors | Format-Table -AutoSize
    }
    $Warnings = $Results | Where-Object { $_.Severity -eq 'Warning' }
    if (@($Warnings).Count -gt 0) {
        Write-Warning -Message 'One or more Script Analyzer warnings were found. These should be corrected.'
        $Warnings | Format-Table -AutoSize
    }
} -description 'Run PSScriptAnalyzer'

Task Pester -depends Build {
    $env:PESTER_FILE_TO_TEST = $Settings.OutModule
    $Results = Invoke-Pester -Path $Settings.TestsFiles -Output Detailed
    if ($Results.FailedCount -gt 0) {
        $Results | Format-List
        Write-Error -Message 'One or more Pester tests failed. Build cannot continue!'
    }
} -description "Run Pester tests"

Task Clean -depends Init {
    if (Test-Path -Path $Settings.Out) {
        Remove-Item -Path $Settings.Out -Recurse -Force -Verbose:$false
    }
} -description "Clean out directory"

Task Build -depends Init, Clean {
    # Module file
    "[build][init] Create out directory"
    New-Item -Path $Settings.Out -ItemType Directory -Force | Out-Null
    "[build][module] Start build module file"
    $ModuleFile = @{
        Path     = $Settings.OutModule
        Encoding = $Settings.Encoding
    }
    "[build][module] Add header"
    Add-Content @ModuleFile -Value ((Get-Content -Path $Settings.SourceHeader.FullName) + "`n")
    Add-Content @ModuleFile -Value "#region Classes"
    $Settings.SourceClasses | ForEach-Object -Process {
        "[build][module] Add class {0}" -f $_.Basename
        Add-Content @ModuleFile -Value (Get-Content -Path $_.FullName)
    }
    Add-Content @ModuleFile -Value "#endregion Classes`n"
    #Add-Content @ModuleFile -Value "#region Private functions"
    #$Settings.SourcePrivateFunctions | ForEach-Object -Process {
    #    "[build][module] Add private function {0}" -f $_.Basename
    #    Add-Content @ModuleFile -Value (Get-Content -Path $_.FullName)
    #}
    #Add-Content @ModuleFile -Value "#endregion Private functions`n"
    Add-Content @ModuleFile -Value "#region Public functions"
    $Settings.SourcePublicFunctions | ForEach-Object -Process {
        "[build][module] Add public function {0}" -f $_.Basename
        Add-Content @ModuleFile -Value (Get-Content -Path $_.FullName)
    }
    Add-Content @ModuleFile -Value "#endregion Public functions`n"
    "[build][module] Done"
    # Manifest file
    "[build][manifest] Start build manifest file"
    "[build][manifest] Copy manifest"
    Copy-Item -Path $Settings.SourceManifest -Destination $Settings.OutManifest
    "[build][manifest] Update manifest"
    Update-ModuleManifest -Path $Settings.OutManifest `
        -CmdletsToExport $Settings.SourcePublicFunctions.BaseName `
        -ModuleVersion $Settings.ModuleVersion
    "[build][manifest] Done"
}
