BeforeAll {
    $Module = Get-Item -Path $env:PESTER_FILE_TO_TEST
    Import-Module -Name $Module.FullName -Force

    $env:MY_RM_INVENTORY = Join-Path -Path $TestDrive -ChildPath "MyRemoteManager.json"
    New-MyRMInventory -NoDefaultClients

    @(
        @{
            Name        = "TestClient"
            Executable  = "client.exe"
            Arguments   = "-p <port> <host>"
            DefaultPort = 1234
        },
        @{
            Name        = "ClientTest"
            Executable  = "client.exe"
            Arguments   = "--host <host> --port <port> --user <user>"
            DefaultPort = 5678
        }
    ) | ForEach-Object -Process {
        Add-MyRMClient @_
    }
}
Describe "Add-MyRMConnection" {
    It "Adds a connection" {
        $Arguments = @{
            Name          = "TestConnection1"
            Hostname      = "conn1.test"
            Port          = 1234
            DefaultClient = "TestClient"
            Description   = "A test connection."
        }
        Add-MyRMConnection @Arguments | Should -BeNullOrEmpty
    }
    It "Adds another connection" {
        $Arguments = @{
            Name          = "TestConnection2"
            Hostname      = "conn2.test"
            DefaultClient = "TestClient"
        }
        Add-MyRMConnection @Arguments | Should -BeNullOrEmpty
    }
    It "Adds a connection with an already used name, and fails" {
        $Arguments = @{
            Name          = "TestConnection2"
            Hostname      = "conn2.test"
            Port          = 2468
            DefaultClient = "TestClient"
        }
        { Add-MyRMConnection @Arguments }
        | Should -Throw -ExpectedMessage "Cannot add Connection `"TestConnection2`" as it already exists."
    }
}
Describe "Get-MyRMConnection" {
    BeforeAll {
        @(
            @{
                Name          = "TestConnection3"
                Hostname      = "Hostname.test"
                DefaultClient = "ClientTest"
            },
            @{
                Name          = "ConnectionTest4"
                Hostname      = "Hostname.test"
                Port          = 6666
                DefaultClient = "TestClient"
            }
        ) | ForEach-Object -Process {
            Add-MyRMConnection @_
        }
    }
    It "Gets Connections" {
        Get-MyRMConnection | Should -BeOfType PSCustomObject
    }
    It "Gets Connections with exact count" {
        (Get-MyRMConnection).count | Should -BeExactly 4
    }
    It "Gets Connections filtered by name" {
        (Get-MyRMConnection -Name "ConnectionTest*")[0].Name | Should -BeExactly "ConnectionTest4"
    }
    It "Gets Connections filtered by client name" {
        (Get-MyRMConnection -Client "ClientTest")[0].Name | Should -BeExactly "TestConnection3"
    }
    It "Gets Connections filtered by hostname" {
        (Get-MyRMConnection -Hostname "conn2*")[0].Name | Should -BeExactly "TestConnection2"
    }
    It "Gets Connections filtered by name and client name" {
        (Get-MyRMConnection -Name "*tion2" -Client "TestClient")[0].Name | Should -BeExactly "TestConnection2"
    }
    It "Gets Connections filtered by name and hostname name" {
        (Get-MyRMConnection -Name "*tion3" -Hostname "*.test")[0].Name | Should -BeExactly "TestConnection3"
    }
    It "Gets Connections filtered by name and client name that do not exist" {
        (Get-MyRMConnection -Name "*Test3" -Client "TestClient") | Should -BeNullOrEmpty
    }
    It "Gets Connections filtered by name and hostname name that do not exist" {
        (Get-MyRMConnection -Name "*Test2" -Hostname "do.not.exist") | Should -BeNullOrEmpty
    }
}
Describe "Remove-MyRMConnection" {
    It "Removes an existing connection" {
        Remove-MyRMConnection -Name "TestConnection1" | Should -BeNullOrEmpty
    }
    It "Removes a connection that does not exist, and fails" {
        { Remove-MyRMConnection -Name "TestConnection0" } | Should -Throw
    }
}

Describe "Rename-MyRMConnection" {
    BeforeAll {
        @(
            @{
                Name          = "BadlyNamedConnection"
                Hostname      = "hostname.test"
                DefaultClient = "ClientTest"
            },
            @{
                Name          = "WhateverConnection"
                Hostname      = "hostname.test"
                DefaultClient = "ClientTest"
            }
        ) | ForEach-Object -Process {
            Add-MyRMConnection @_
        }
    }
    It "Renames an existing connection" {
        Rename-MyRMConnection -Name "BadlyNamedConnection" -NewName "NicelyNamedConnection"
        | Should -BeNullOrEmpty
    }
    It "Renames a connection that does not exist, and fails" {
        { Rename-MyRMConnection -Name "MissingConnection" -NewName "NopeConnection" } | Should -Throw
    }
    It "Renames a connection with a name already used, and fails" {
        { Rename-MyRMConnection -Name "NicelyNamedConnection" -NewName "WhateverConnection" }
        | Should -Throw -ExpectedMessage "Cannot rename Connection `"NicelyNamedConnection`" to `"WhateverConnection`" as this name is already used."
    }
    It "Uses same name for renaming, and fails" {
        { Rename-MyRMConnection -Name "NicelyNamedConnection" -NewName "NicelyNamedConnection" }
        | Should -Throw -ExpectedMessage "The two names are similar."
    }
}
