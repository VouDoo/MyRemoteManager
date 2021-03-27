Task default -depends Build, Test

Task Build {
    & "$PSScriptRoot\build.ps1"
}

Task Test -depends Build {
    & "$PSScriptRoot\Run-Tests.ps1"
}
