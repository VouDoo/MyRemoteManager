BeforeAll {
    $ModulePath = Join-Path -Path (Get-Item $PSScriptRoot).parent.FullName -ChildPath "Build\MyRemoteManager.psm1"
    Write-Debug -Message "Module Path: $ModulePath"
    Import-Module -Name $ModulePath -Force
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
Describe "Add-MyRMClient" {
    BeforeAll {
        $Env:MY_RM_INVENTORY = Join-Path -Path $TestDrive -ChildPath "MyRemoteManager.json"
        New-MyRMInventory
    }
    It "Adds a client." {
        $Arguments = @{
            Name        = "TstClient1"
            Executable  = "client.exe"
            Arguments   = "-p <port> <host>"
            DefaultPort = 1234
            Description = "A test client."
        }
        $TestClient = Add-MyRMClient @Arguments -PassThru
        $TestClient | Should -Be "TstClient1"
    }
    It "Adds another client." {
        $Arguments = @{
            Name        = "TstClient2"
            Executable  = "client.exe"
            Arguments   = "-p <port> <host>"
            DefaultPort = 5678
        }
        $TestClient = Add-MyRMClient @Arguments -PassThru
        $TestClient | Should -Be "TstClient2"
    }
    It "Adds a client with an already used name, and fails." {
        $Arguments = @{
            Name        = "TstClient2"
            Executable  = "client.exe"
            Arguments   = "-p <port> <host>"
            DefaultPort = 2468
        }
        { Add-MyRMClient @Arguments -PassThru } | Should -Throw -ExpectedMessage "Cannot add Client `"TstClient2`" as it already exists."
    }
    It "Adds a client without a required token in the command, and fails." {
        $Arguments = @{
            Name        = "TstClient3"
            Executable  = "client.exe"
            Arguments   = "-p <prot> <host>"
            DefaultPort = 1234
        }
        { Add-MyRMClient @Arguments -PassThru } | Should -Throw -ExpectedMessage "*The command does not contain the following token: port*"
    }
}
Describe "Add-MyRMConnection" {
    BeforeAll {
        $Env:MY_RM_INVENTORY = Join-Path -Path $TestDrive -ChildPath "MyRemoteManager.json"
        New-MyRMInventory
        $ClientArgs = @{
            Name        = "TestClient"
            Executable  = "client.exe"
            Arguments   = "-p <port> <host>"
            DefaultPort = 1234
        }
        Add-MyRMClient @ClientArgs
    }
    It "Adds a connection." {
        $Arguments = @{
            Name        = "TestConnection1"
            Hostname    = "Hostname.test"
            Port        = 1234
            Client      = "TestClient"
            Description = "A test connection."
        }
        Add-MyRMConnection @Arguments -PassThru | Should -Be "TestConnection1"
    }
    It "Adds another connection." {
        $Arguments = @{
            Name     = "TestConnection2"
            Hostname = "Hostname.test"
            Port     = 5678
            Client   = "TestClient"
        }
        Add-MyRMConnection @Arguments -PassThru | Should -Be "TestConnection2"
    }
    It "Adds a connection with an already used name, and fails." {
        $Arguments = @{
            Name     = "TestConnection2"
            Hostname = "Hostname.test"
            Port     = 2468
            Client   = "TestClient"
        }
        { Add-MyRMConnection @Arguments -PassThru } | Should -Throw -ExpectedMessage "Cannot add Connection `"TestConnection2`" as it already exists."
    }
}
Describe "Remove-MyRMClient" {
    BeforeAll {
        $Env:MY_RM_INVENTORY = Join-Path -Path $TestDrive -ChildPath "MyRemoteManager.json"
        New-MyRMInventory
    }
    BeforeEach {
        $ClientArgs = @{
            Name        = "TestClient"
            Executable  = "client.exe"
            Arguments   = "-p <port> <host>"
            DefaultPort = 1234
        }
        Add-MyRMClient @ClientArgs
    }
    It "Removes the `"TestClient`" Client" {
        Remove-MyRMClient -Name "TestClient" | Should -Be $null
    }
    It "Removes the `"TstClient0`" Client even if it does not exist, and fails." {
        { Remove-MyRMClient -Name "TstClient0" } | Should -Throw
    }
}
Describe "Remove-MyRMConnection" {
    BeforeAll {
        $Env:MY_RM_INVENTORY = Join-Path -Path $TestDrive -ChildPath "MyRemoteManager.json"
        New-MyRMInventory
        $ClientArgs = @{
            Name        = "TestClient"
            Executable  = "client.exe"
            Arguments   = "-p <port> <host>"
            DefaultPort = 1234
        }
        Add-MyRMClient @ClientArgs
    }
    BeforeEach {
        $TestConnectionArguments = @{
            Name        = "TestConnection"
            Hostname    = "Hostname.test"
            Port        = 1234
            Client      = "TestClient"
            Description = "A test connection."
        }
        Add-MyRMConnection @TestConnectionArguments
    }
    It "Removes the `"TestConnection`" Connection" {
        Remove-MyRMConnection -Name "TestConnection" | Should -Be $null
    }
    It "Removes the `"TstConnection0`" Connection even if it does not exist, and fails." {
        { Remove-MyRMConnection -Name "TstConnection0" } | Should -Throw
    }
}
