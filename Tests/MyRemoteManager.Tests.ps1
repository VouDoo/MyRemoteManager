BeforeAll {
    $ModulePath = Join-Path -Path (Get-Item $PSScriptRoot).parent.FullName -ChildPath "Build\MyRemoteManager.psm1"
    Import-Module -Name $ModulePath -Force
}
Describe "New-MyRMInventory" {
    BeforeAll {
        $TestInventoryFile = Join-Path -Path $TestDrive -ChildPath "MyRemoteManager.json"
        $Env:MY_RM_INVENTORY = $TestInventoryFile
    }
    It "Creates a new inventory file." {
        New-MyRMInventory -PassThru | Should -Be $TestInventoryFile
    }
    It "Creates a new inventory file, even if it already exists." {
        { New-MyRMInventory -PassThru } | Should -Throw -ExceptionType "System.IO.IOException"
    }
    It "Forces the creation of a new inventory file." {
        New-MyRMInventory -Force -PassThru | Should -Be $TestInventoryFile
    }
    It "Forces the creation of a new inventory file (path from environment variable)." {
        New-MyRMInventory -Force -PassThru | Should -Be $TestInventoryFile
    }
    It "Checks if a backup file has been created." {
        $TestInventoryBackupFile = $TestInventoryFile + ".backup"
        Test-Path -Path $TestInventoryBackupFile -PathType Leaf | Should -BeTrue
    }
    It "Validates the JSON content from the inventory file." {
        $PSObject = Get-Content -Path $TestInventoryFile | ConvertFrom-Json -AsHashtable
        $PSObject.ContainsKey("Connections") | Should -BeTrue
        $PSObject.ContainsKey("Clients") | Should -BeTrue
        $PSObject.ContainsKey("Foo") | Should -BeFalse
    }

}
Describe "Add-MyRMClient" {
    BeforeAll {
        $Env:MY_RM_INVENTORY = Join-Path -Path $TestDrive -ChildPath "MyRemoteManager.json"
        New-MyRMInventory | Out-Null
    }
    It "Adds a client." {
        $Arguments = @{
            Name        = "TstClient1"
            Command     = "client -u <user> -p <port> <host>"
            DefaultPort = 1234
            Description = "A test client."
        }
        $TestClient = Add-MyRMClient @Arguments -PassThru
        $TestClient | Should -BeOfType object
        $TestClient.Name | Should -BeExactly "TstClient1"
        $TestClient.Command | Should -BeExactly "client -u <user> -p <port> <host>"
        $TestClient.RequiresCmdKey | Should -BeExactly $false
        $TestClient.DefaultPort | Should -BeExactly 1234
        $TestClient.Description | Should -BeExactly "A test client."
    }
    It "Adds another client (path from environment variable)." {
        $Arguments = @{
            Name        = "TstClient2"
            Command     = "client -u <user> -p <port> <host>"
            DefaultPort = 1234
        }
        Add-MyRMClient @Arguments -PassThru | Should -BeOfType object
    }
    It "Adds a client, but with a already used name." {
        $Arguments = @{
            Name        = "TstClient2"
            Command     = "client -u <user> -p <port> <host>"
            DefaultPort = 1234
        }
        { Add-MyRMClient @Arguments -PassThru } | Should -Throw -ExpectedMessage "Client `"TstClient2`" already exists."
    }
    It "Adds a client, without a required token in the command." {
        $Arguments = @{
            Name        = "TstClient3"
            Command     = "client -u <user> -p <prot> <host>"
            DefaultPort = 1234
        }
        { Add-MyRMClient @Arguments -PassThru } | Should -Throw -ExpectedMessage "*The command does not contain the following token: port*"
    }
    It "Adds a client, with RequiresCmdKey and without the <user> token in the command." {
        $Arguments = @{
            Name           = "TstClient4"
            Command        = "client -p <port> <host>"
            DefaultPort    = 1234
            RequiresCmdKey = $true
            Description    = "A test client that requires cmdkey."
        }
        Add-MyRMClient @Arguments -PassThru | Should -BeOfType object
    }
}
Describe "Add-MyRMConnection" {
    BeforeAll {
        $Env:MY_RM_INVENTORY = Join-Path -Path $TestDrive -ChildPath "MyRemoteManager.json"
        New-MyRMInventory -Force | Out-Null
        Add-MyRMClient -Name "TestClient" -Command "client -u <user> -p <port> <host>" -DefaultPort 1234
    }
    It "Adds a connection." {
        $Arguments = @{
            Name        = "TestConnection1"
            Hostname    = "Hostname.test"
            Port        = 1234
            User        = "test-user"
            ClientName  = "TestClient"
            Description = "A test connection."
        }
        $TestConnection = Add-MyRMConnection @Arguments -PassThru
        $TestConnection | Should -BeOfType object
        $TestConnection.Name | Should -BeExactly "TestConnection1"
        $TestConnection.Hostname | Should -BeExactly "hostname.test"
        $TestConnection.Port | Should -BeExactly 1234
        $TestConnection.Username | Should -BeExactly "test-user"
        $TestConnection.ClientName | Should -BeExactly "TestClient"
        $TestConnection.Description | Should -BeExactly "A test connection."
    }
    It "Adds another connection (path from environment variable)." {
        $Arguments = @{
            Name       = "TestConnection2"
            Hostname   = "Hostname.test"
            Port       = 1234
            User       = "test-user"
            ClientName = "TestClient"
        }
        Add-MyRMConnection @Arguments -PassThru | Should -BeOfType object
    }
    It "Adds a connection, but with a already used name." {
        $Arguments = @{
            Name       = "TestConnection2"
            Hostname   = "Hostname.test"
            Port       = 1234
            User       = "test-user"
            ClientName = "TestClient"
        }
        { Add-MyRMConnection @Arguments -PassThru } | Should -Throw -ExpectedMessage "Connection `"TestConnection2`" already exists."
    }
}
Describe "Remove-MyRMClient" {
    BeforeAll {
        $TestClientArguments = @{
            Name        = "TestClient"
            Command     = "client -u <user> -p <port> <host>"
            DefaultPort = 1234
            Description = "A test client."
        }
        $Env:MY_RM_INVENTORY = Join-Path -Path $TestDrive -ChildPath "MyRemoteManager.json"
        New-MyRMInventory | Out-Null
    }
    It "Removes the `"TestClient`" Client" {
        Add-MyRMClient @TestClientArguments
        Remove-MyRMClient -Name "TestClient" | Should -Be $null
    }
    It "Removes the `"TestClient`" Client (path from environment variable)" {
        Add-MyRMClient @TestClientArguments
        Remove-MyRMClient -Name "TestClient" | Should -Be $null
    }
    It "Removes the `"TestClient`" Client, even if it does not exist." {
        { Remove-MyRMClient -Name "TestClient" } | Should -Throw
    }
}
Describe "Remove-MyRMConnection" {
    BeforeAll {
        $Env:MY_RM_INVENTORY = Join-Path -Path $TestDrive -ChildPath "MyRemoteManager.json"
        New-MyRMInventory | Out-Null
        Add-MyRMClient -Name "TestClient" -Command "client -u <user> -p <port> <host>" -DefaultPort 1234
        $TestConnectionArguments = @{
            Name        = "TestConnection"
            Hostname    = "Hostname.test"
            Port        = 1234
            User        = "test-user"
            ClientName  = "TestClient"
            Description = "A test connection."
        }
    }
    It "Removes the `"TestConnection`" Connection" {
        Add-MyRMConnection @TestConnectionArguments
        Remove-MyRMConnection -Name "TestConnection" | Should -Be $null
    }
    It "Removes the `"TestConnection`" Connection (path from environment variable)" {
        Add-MyRMConnection @TestConnectionArguments
        Remove-MyRMConnection -Name "TestConnection" | Should -Be $null
    }
    It "Removes the `"TestConnection`" Connection, even if it does not exist." {
        { Remove-MyRMConnection -Name "TestConnection" } | Should -Throw
    }
}
