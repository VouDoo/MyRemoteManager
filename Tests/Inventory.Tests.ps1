BeforeAll {
    $Module = Get-Item -Path $env:PESTER_FILE_TO_TEST
    Import-Module -Name $Module.FullName -Force
}
Describe "New-MyRMInventory" {
    BeforeAll {
        $Env:MY_RM_INVENTORY = Join-Path -Path $TestDrive -ChildPath "MyRemoteManager.json"
    }
    It "Creates a new inventory file." {
        New-MyRMInventory -PassThru | Should -Be $Env:MY_RM_INVENTORY
    }
    It "Creates a new inventory file even if it already exists, and fails." {
        { New-MyRMInventory -PassThru } | Should -Throw -ExceptionType "System.IO.IOException"
    }
    It "Forces the creation of a new inventory file." {
        New-MyRMInventory -Force -PassThru | Should -Be $Env:MY_RM_INVENTORY
    }
    It "Checks if a backup file has been created." {
        $TestInventoryBackupFile = $Env:MY_RM_INVENTORY + ".backup"
        Test-Path -Path $TestInventoryBackupFile -PathType Leaf | Should -BeTrue
    }
    It "Validates the JSON content from the inventory file." {
        $PSObject = Get-Content -Path $Env:MY_RM_INVENTORY | ConvertFrom-Json -AsHashtable
        $PSObject.ContainsKey("Connections") | Should -BeTrue
        $PSObject.ContainsKey("Clients") | Should -BeTrue
        $PSObject.ContainsKey("Foo") | Should -BeFalse
    }
}
