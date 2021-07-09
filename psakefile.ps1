Properties -properties {
    $Settings = . (Join-Path -Path $PSScriptRoot -ChildPath "build.settings.ps1")
}

Task -name default -depends Build

Task -name Init {
    # Show PowerShell version
    "[{0}][psenv] Building on {1} with PowerShell:" -f (
        $psake.context.currentTaskName,
        $env:COMPUTERNAME
    )
    $PSVersionTable | Format-Table

    # Create out directory
    if (-not (Test-Path -Path $Settings.Out)) {
        "[{0}][outdir] Create out directory." -f $psake.context.currentTaskName
        New-Item -Path $Settings.Out -ItemType Directory -Force -Verbose:$VerbosePreference | Out-Null
    }
} -description "Initialize psake and task variables"

Task Clean -depends Init {
    # Remove files from existing out directory
    "[{0}][remove] Remove files from out directory." -f $psake.context.currentTaskName
    Get-ChildItem -Path $Settings.Out | Remove-Item -Recurse -Force -Verbose:$VerbosePreference
} -description "Clean output directory"

Task -name Build -depends Init, Clean {
    # Compile module file (.psm1)
    "[{0}][module] Start build module file." -f $psake.context.currentTaskName
    $ModuleFile = @{
        Path     = $Settings.OutModule
        Encoding = $Settings.Encoding
    }
    "[{0}][module] Add header." -f $psake.context.currentTaskName
    Add-Content @ModuleFile -Value ((Get-Content -Path $Settings.SourceHeader.FullName) + "`n")
    Add-Content @ModuleFile -Value "#region Enum"
    $Settings.SourceEnum | ForEach-Object -Process {
        "[{0}][module] Add enum `"{1}`"." -f $psake.context.currentTaskName, $_.Basename
        Add-Content @ModuleFile -Value (Get-Content -Path $_.FullName)
    }
    Add-Content @ModuleFile -Value "#endregion Enums`n"
    Add-Content @ModuleFile -Value "#region Classes"
    $Settings.SourceClasses | ForEach-Object -Process {
        "[{0}][module] Add class `"{1}`"." -f $psake.context.currentTaskName, $_.Basename
        Add-Content @ModuleFile -Value (Get-Content -Path $_.FullName)
    }
    Add-Content @ModuleFile -Value "#endregion Classes`n"
    #Add-Content @ModuleFile -Value "#region Private functions"
    #$Settings.SourcePrivateFunctions | ForEach-Object -Process {
    #    "[{0}][module] Add private function {1}" -f $psake.context.currentTaskName, $_.Basename
    #    Add-Content @ModuleFile -Value (Get-Content -Path $_.FullName)
    #}
    #Add-Content @ModuleFile -Value "#endregion Private functions`n"
    Add-Content @ModuleFile -Value "#region Public functions"
    $Settings.SourcePublicFunctions | ForEach-Object -Process {
        "[{0}][module] Add public function `"{1}`"." -f $psake.context.currentTaskName, $_.Basename
        Add-Content @ModuleFile -Value (Get-Content -Path $_.FullName)
    }
    Add-Content @ModuleFile -Value "#endregion Public functions`n"
    "[{0}][module] Done." -f $psake.context.currentTaskName

    # Copy data directory as it is
    #"[{0}][datadir] Copy data directory" -f $psake.context.currentTaskName
    #Copy-Item -Path $Settings.SourceData -Destination $Settings.Out -Recurse

    # Copy and update manifest file (.psd1)
    "[{0}][manifest] Start build manifest file." -f $psake.context.currentTaskName
    "[{0}][manifest] Copy manifest." -f $psake.context.currentTaskName
    Copy-Item -Path $Settings.SourceManifest -Destination $Settings.OutManifest
    "[{0}][manifest] Update manifest." -f $psake.context.currentTaskName
    $ModuleManifestParams = @{
        Path              = $Settings.OutManifest
        FunctionsToExport = $Settings.SourcePublicFunctions.BaseName
        ModuleVersion     = $Settings.ModuleVersion
    }
    Update-ModuleManifest @ModuleManifestParams
    "[{0}][manifest] Done." -f $psake.context.currentTaskName
} -description "Clean and build module in output directory"

Task -name Analyze -depends Build {
    # Import module
    if (-not (Get-Module -name PSScriptAnalyzer -ListAvailable)) {
        "[{0}][import] PSScriptAnalyzer module is not installed. Skipping task." -f $psake.context.currentTaskName
        return
    }
    Import-Module -Name PSScriptAnalyzer

    # Set ScriptAnalyzer parameters
    $ScriptAnalyzerParams = @{
        Path     = $Settings.Out
        Settings = $Settings.TestsScriptAnalyzerSettings
        Recurse  = $true
        Verbose  = $VerbosePreference
    }

    # Run ScriptAnalyzer
    $Result = Invoke-ScriptAnalyzer @ScriptAnalyzerParams
    $Result | Format-Table -AutoSize

    # Assertions
    Assert -conditionToCheck (
        ($Result | Where-Object -Property Severity -Match "Error").Count -eq 0
    ) -failureMessage (
        "[{0}][result] One or more errors were found." -f $psake.context.currentTaskName
    )
    Assert -conditionToCheck (
        ($Result | Where-Object -Property Severity -Match "Warning").Count -eq 0
    ) -failureMessage (
        "[{0}][result] One or more warning were found." -f $psake.context.currentTaskName
    )
} -description "Run PSScriptAnalyzer tests"

Task -name Pester -depends Build {
    # Import module
    if (-not (Get-Module -name Pester -ListAvailable)) {
        "[{0}][import] Pester module is not installed. Skipping task." -f $psake.context.currentTaskName
        return
    }
    Import-Module -Name Pester

    # Set Pester parameters
    $env:PESTER_FILE_TO_TEST = $Settings.OutModule
    $PesterParams = @{
        Path     = $Settings.TestsFiles
        Output   = "Detailed"
        Verbose  = $VerbosePreference
        PassThru = $true
    }

    # Run Pester
    $Result = Invoke-Pester @PesterParams

    # Assertions
    Assert -conditionToCheck (
        $Result.FailedCount -eq 0
    ) -failureMessage (
        "[{0}][result] One or more tests failed." -f $psake.context.currentTaskName
    )
} -description "Run Pester tests"

Task -name Test -depends Analyze, Pester -description "Run combined tests"

Task -name Publish -depends Test {
    Write-Warning -Message "[{0}][alert] No repository defined yet." -f $psake.context.currentTaskName
} -description "Publish module to defined PowerShell repository"
