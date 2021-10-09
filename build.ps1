[cmdletbinding(DefaultParameterSetName = "Task")]
param(
    [parameter(
        ParameterSetName = "task",
        position = 0,
        HelpMessage = "Build task(s) to execute"
    )]
    [string[]] $Task = "default",

    [parameter(
        HelpMessage = "Bootstrap dependencies"
    )]
    [switch] $Bootstrap,

    [parameter(
        ParameterSetName = "Help",
        HelpMessage = "List available build tasks"
    )]
    [switch] $Help
)

$ErrorActionPreference = "Stop"

#region Bootstrap dependencies
$RequirementsFile = Join-Path -Path $PSScriptRoot -ChildPath requirements.psd1
if ($Bootstrap.IsPresent) {
    Get-PackageProvider -Name Nuget -ForceBootstrap | Out-Null
    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
    if (-not (Get-Module -Name PSDepend -ListAvailable)) {
        Install-Module -Name PSDepend -Repository PSGallery
    }
    Import-Module -Name PSDepend -Verbose:$false
    Invoke-PSDepend -Path $RequirementsFile -Install -Import -Force -WarningAction SilentlyContinue
}
#endregion Bootstrap dependencies

#region Execute psake task(s)
$psakeFile = Join-Path -Path $PSScriptRoot -ChildPath "psakefile.ps1"
if ($PSCmdlet.ParameterSetName -eq "Help") {
    Invoke-psake -buildFile $psakeFile -docs
}
else {
    Invoke-psake -buildFile $psakeFile -taskList $Task -nologo
    #exit ( [int]( -not $psake.build_success ) )
}
#endregion Execute psake task(s)
