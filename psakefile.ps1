Task default -depends Build, Test

Task Build {
    & "$PSScriptRoot\Build-Module.ps1" -InformationAction Continue
}

Task Test -depends Build {
    & "$PSScriptRoot\Test-Module.ps1"
}
