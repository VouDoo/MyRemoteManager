BeforeAll {
    $Module = Get-Item -Path $env:PESTER_FILE_TO_TEST
    Import-Module -Name $Module.FullName -Force

    $env:MY_RM_INVENTORY = Join-Path -Path $TestDrive -ChildPath "MyRemoteManager.json"
    New-MyRMInventory

    $ClientArgs = @{
        Name        = "TestClient"
        Executable  = "client.exe"
        Arguments   = "-p <port> <host>"
        DefaultPort = 1234
    }
    Add-MyRMClient @ClientArgs
}
Describe "Add-MyRMConnection" {
    It "Adds a connection." {
        $Arguments = @{
            Name        = "TestConnection1"
            Hostname    = "Hostname.test"
            Port        = 1234
            Client      = "TestClient"
            Description = "A test connection."
        }
        Add-MyRMConnection @Arguments | Should -BeNullOrEmpty
    }
    It "Adds another connection." {
        $Arguments = @{
            Name     = "TestConnection2"
            Hostname = "Hostname.test"
            Port     = 5678
            Client   = "TestClient"
        }
        Add-MyRMConnection @Arguments | Should -BeNullOrEmpty
    }
    It "Adds a connection with an already used name, and fails." {
        $Arguments = @{
            Name     = "TestConnection2"
            Hostname = "Hostname.test"
            Port     = 2468
            Client   = "TestClient"
        }
        { Add-MyRMConnection @Arguments } | Should -Throw -ExpectedMessage "Cannot add Connection `"TestConnection2`" as it already exists."
    }
}
Describe "Remove-MyRMConnection" {
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
    It "Removes the `"TestConnection0`" Connection even if it does not exist, and fails." {
        { Remove-MyRMConnection -Name "TestConnection0" } | Should -Throw
    }
}
