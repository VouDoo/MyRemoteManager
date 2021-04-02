BeforeAll {
    $Module = Get-Item -Path $env:PESTER_FILE_TO_TEST
    Import-Module -Name $Module.FullName -Force

    $env:MY_RM_INVENTORY = Join-Path -Path $TestDrive -ChildPath "MyRemoteManager.json"
    New-MyRMInventory -NoDefaultClients
}
Describe "Add-MyRMClient" {
    It "Adds a client" {
        $Arguments = @{
            Name        = "TestClient1"
            Executable  = "client1.exe"
            Arguments   = "-p <port> <host>"
            DefaultPort = 1234
            Description = "A test client."
        }
        Add-MyRMClient @Arguments | Should -BeNullOrEmpty
    }
    It "Adds another client" {
        $Arguments = @{
            Name        = "TestClient2"
            Executable  = "client2.exe"
            Arguments   = "<port>:<host> --with <user>"
            DefaultPort = 5678
        }
        Add-MyRMClient @Arguments | Should -BeNullOrEmpty
    }
    It "Adds a client with an already used name, and fails" {
        $Arguments = @{
            Name        = "TestClient2"
            Executable  = "client2.exe"
            Arguments   = "-p <port> -h <host>"
            DefaultPort = 2468
        }
        { Add-MyRMClient @Arguments } | Should -Throw -ExpectedMessage "Cannot add Client `"TestClient2`" as it already exists."
    }
    It "Adds a client with incorrect tokens, and fails" {
        $Arguments = @{
            Name        = "IncorrectTestClient"
            Executable  = "incorrectclient.exe"
            Arguments   = "--port <prot> --host <host>"
            DefaultPort = 1234
        }
        { Add-MyRMClient @Arguments } | Should -Throw -ExpectedMessage "*The command does not contain the following token: port*"
    }
}
Describe "Get-MyRMClient" {
    BeforeAll {
        @(
            @{
                Name        = "TestClient3"
                Executable  = "client3.exe"
                Arguments   = "-p <port> <host>"
                DefaultPort = 7654
            },
            @{
                Name        = "ClientTest4"
                Executable  = "client4.exe"
                Arguments   = "-h <host> -p <port> --user <user>"
                DefaultPort = 5678
            }
        ) | ForEach-Object -Process {
            Add-MyRMClient @_
        }
    }
    It "Gets Clients" {
        Get-MyRMClient | Should -BeOfType PSCustomObject
    }
    It "Gets Clients with exact count" {
        (Get-MyRMClient).count | Should -BeExactly 4
    }
    It "Gets Clients filtered by name" {
        (Get-MyRMClient -Name "ClientTest*")[0].Name | Should -BeExactly "ClientTest4"
    }
    It "Gets Clients filtered by name that do not exist" {
        (Get-MyRMClient -Name "ClientTestt*") | Should -BeNullOrEmpty
    }
}
Describe "Remove-MyRMClient" {
    It "Removes an existing Client" {
        Remove-MyRMClient -Name "TestClient1" | Should -BeNullOrEmpty
    }
    It "Removes a client that does not exist, and fails" {
        { Remove-MyRMClient -Name "TestClient0" } | Should -Throw
    }
}
