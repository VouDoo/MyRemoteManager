BeforeAll {
    $Module = Get-Item -Path $env:PESTER_FILE_TO_TEST
    Import-Module -Name $Module.FullName -Force

    $env:MY_RM_INVENTORY = Join-Path -Path $TestDrive -ChildPath "MyRemoteManager.json"
}
Describe "New-MyRMInventory" {
    It "Creates a new inventory file" {
        New-MyRMInventory -PassThru | Should -BeExactly $env:MY_RM_INVENTORY
    }
    It "Creates a new inventory file even if it already exists, and fails" {
        { New-MyRMInventory -PassThru } | Should -Throw -ExceptionType "System.IO.IOException"
    }
    It "Forces the creation of a new inventory file" {
        New-MyRMInventory -Force -PassThru | Should -BeExactly $env:MY_RM_INVENTORY
    }
    It "Checks if a backup file has been created" {
        $TestInventoryBackupFile = $env:MY_RM_INVENTORY + ".backup"
        Test-Path -Path $TestInventoryBackupFile -PathType Leaf | Should -BeTrue
    }
    It "Validates the JSON content from the inventory file" {
        $PSObject = Get-Content -Path $env:MY_RM_INVENTORY | ConvertFrom-Json -AsHashtable
        $PSObject.ContainsKey("Connections") | Should -BeTrue
        $PSObject.ContainsKey("Clients") | Should -BeTrue
        $PSObject.ContainsKey("Foo") | Should -BeFalse
    }
}
Describe "Get-MyRMInventoryInfo" {
    BeforeAll {
        New-MyRMInventory -Force
    }
    It "Collects information about the inventory" {
        $Info = Get-MyRMInventoryInfo
        $Info.Path | Should -BeExactly $env:MY_RM_INVENTORY
        $Info.EnvVariable | Should -BeExactly "MY_RM_INVENTORY"
        $Info.NumberOfClients | Should -BeExactly 3
        $Info.NumberOfConnections | Should -BeExactly 0
    }
}
Describe "Set-MyRMInventoryPath" {
    It "Sets the inventory path and creates a new file" {
        $CustomPath = Join-Path -Path $TestDrive -ChildPath "MyOtherRemoteManager.json"
        Set-MyRMInventoryPath -Path $CustomPath -Target "Process"
        New-MyRMInventory -Force -PassThru | Should -BeExactly $CustomPath
    }
}
