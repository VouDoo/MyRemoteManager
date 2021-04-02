BeforeAll {
    $Module = Get-Item -Path $env:PESTER_FILE_TO_TEST
    Import-Module -Name $Module.FullName -Force

    $env:MY_RM_INVENTORY = Join-Path -Path $TestDrive -ChildPath "MyRemoteManager.json"
    New-MyRMInventory
}
Describe "Add-MyRMClient" {
    It "Adds a client." {
        $Arguments = @{
            Name        = "TestClient1"
            Executable  = "client.exe"
            Arguments   = "-p <port> <host>"
            DefaultPort = 1234
            Description = "A test client."
        }
        Add-MyRMClient @Arguments | Should -BeNullOrEmpty
    }
    It "Adds another client." {
        $Arguments = @{
            Name        = "TestClient2"
            Executable  = "client.exe"
            Arguments   = "-p <port> <host>"
            DefaultPort = 5678
        }
        Add-MyRMClient @Arguments | Should -BeNullOrEmpty
    }
    It "Adds a client with an already used name, and fails." {
        $Arguments = @{
            Name        = "TestClient2"
            Executable  = "client.exe"
            Arguments   = "-p <port> <host>"
            DefaultPort = 2468
        }
        { Add-MyRMClient @Arguments } | Should -Throw -ExpectedMessage "Cannot add Client `"TestClient2`" as it already exists."
    }
    It "Adds a client without a required token in the command, and fails." {
        $Arguments = @{
            Name        = "TestClient3"
            Executable  = "client.exe"
            Arguments   = "-p <prot> <host>"
            DefaultPort = 1234
        }
        { Add-MyRMClient @Arguments } | Should -Throw -ExpectedMessage "*The command does not contain the following token: port*"
    }
}
Describe "Remove-MyRMClient" {
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
        Remove-MyRMClient -Name "TestClient" | Should -BeNullOrEmpty
    }
    It "Removes the `"TestClient0`" Client even if it does not exist, and fails." {
        { Remove-MyRMClient -Name "TestClient0" } | Should -Throw
    }
}
