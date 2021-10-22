Properties -properties {
    $Settings = . (Join-Path -Path $PSScriptRoot -ChildPath "build.settings.ps1")
}

Task default -depends Build

Task Init {
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

Task Build -depends Init, Clean {
    # Compile module file (.psm1)
    "[{0}][module] Start build module file." -f $psake.context.currentTaskName
    $ModuleFile = @{
        Path     = $Settings.OutModule
        Encoding = $Settings.OutEncoding
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
    Add-Content @ModuleFile -Value "#region Private functions"
    $Settings.SourcePrivateFunctions | ForEach-Object -Process {
        "[{0}][module] Add private function {1}" -f $psake.context.currentTaskName, $_.Basename
        Add-Content @ModuleFile -Value (Get-Content -Path $_.FullName)
    }
    Add-Content @ModuleFile -Value "#endregion Private functions`n"
    Add-Content @ModuleFile -Value "#region Public functions"
    $Settings.SourcePublicFunctions | ForEach-Object -Process {
        "[{0}][module] Add public function `"{1}`"." -f $psake.context.currentTaskName, $_.Basename
        Add-Content @ModuleFile -Value (Get-Content -Path $_.FullName)
    }
    Add-Content @ModuleFile -Value "#endregion Public functions`n"
    "[{0}][module] Done." -f $psake.context.currentTaskName

    # Copy data files
    <#
    "[{0}][data] Copy data files." -f $psake.context.currentTaskName
    $Settings.SourceDataFiles | ForEach-Object -Process {
        "[{0}][data] Copy `"{1}`"." -f $psake.context.currentTaskName, $_.Name
        Copy-Item -Path $_.FullName -Destination $Settings.Out -Recurse
    }
    #>

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

Task Analyze -depends Build {
    # Import module
    if (-not (Get-Module PSScriptAnalyzer -ListAvailable)) {
        "[{0}][import] PSScriptAnalyzer module is not installed. Skipping task." -f $psake.context.currentTaskName
        return
    }
    Import-Module PSScriptAnalyzer

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

Task Pester -depends Build {
    # Import module
    if (-not (Get-Module Pester -ListAvailable)) {
        "[{0}][import] Pester module is not installed. Skipping task." -f $psake.context.currentTaskName
        return
    }
    Import-Module Pester

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

Task Test -depends Analyze, Pester -description "Run combined tests"

Task platyPS -depends Build {
    # Import module
    if (-not (Get-Module platyPS -ListAvailable)) {
        "[{0}][import] platyPS module is not installed. Skipping task." -f $psake.context.currentTaskName
        return
    }
    Import-Module platyPS

    $ModuleInfo = Import-Module $Settings.OutManifest -Global -Force -PassThru

    # Set MarkdownHelp parameters
    $platyPSParams = @{
        Module         = $Settings.ModuleName
        OutputFolder   = $Settings.DocsHelpOut
        WithModulePage = $false
        Locale         = $Settings.DocsHelpLocale
        Encoding       = [System.Text.Encoding]::GetEncoding($Settings.DocsHelpOutEncoding)
        Force          = $true
        Verbose        = $VerbosePreference
    }

    try {
        # Check if some commands have been exported
        if ($ModuleInfo.ExportedCommands.Count -eq 0) {
            "[{0}][import] No commands have been exported. Skipping task." -f $psake.context.currentTaskName
            return
        }

        # Create help out directory
        if (-not (Test-Path -Path $Settings.Out)) {
            "[{0}][outdir] Create help out directory." -f $psake.context.currentTaskName
            New-Item -Path $Settings.DocsHelpOut -ItemType Directory -Force -Verbose:$VerbosePreference | Out-Null
        }

        # Update markdown help files
        #if (Get-ChildItem -Path $Settings.DocsHelpOut -Filter *.md -Recurse) {
        #    Get-ChildItem -Path $Settings.DocsHelpOut -Directory | ForEach-Object -Process {
        #        Update-MarkdownHelp -Path $_.FullName -Verbose:$VerbosePreference | Out-Null
        #    }
        #}

        # Build markdown help files
        New-MarkdownHelp @platyPSParams
    }
    finally {
        Remove-Module $Settings.ModuleName
    }
} -description "Run platyPS to build Markdown help files"

Task BuildHelp -depends platyPS -description "Build help files"

Task Publish -depends Test {
    # Get API key from environment variable
    $ApiKey = [System.Environment]::GetEnvironmentVariable($Settings.PublishApiKeyEnvVar)
    if (-not $ApiKey) {
        "[{0}][apikey] No API key found from environment variable `"{1}`". Skipping task." -f (
            $psake.context.currentTaskName, $Settings.PublishApiKeyEnvVar
        )
        return
    }

    # Set Publish parameters
    $PublishParams = @{
        Path        = $Settings.Out
        NuGetApiKey = $ApiKey
        Repository  = $Settings.PublishRepository
    }

    # Publish module
    "[{0}][module] Publish {1} module in {2}." -f (
        $psake.context.currentTaskName,
        $Settings.ModuleName,
        $Settings.PublishRepository
    )
    Publish-Module @PublishParams
} -description "Publish module to a defined PowerShell repository"
