Task default -depends Build, Test

Task Build {
    & "$PSScriptRoot\Build-Module.ps1"
}

Task Test -depends Build {
    & "$PSScriptRoot\Test-Module.ps1"
}
