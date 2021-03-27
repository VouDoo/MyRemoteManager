BeforeAll {
    . $PSCommandPath.Replace('.Tests.ps1', '.ps1')
}
Describe "Client" {
    It "Creates a Client object." {
        $Argument = (
            "TestClient",
            "client -u <user> -p <port> <host>",
            $false,
            1234,
            "A test client."
        )
        $TestClient = New-Object -TypeName Client -ArgumentList $Argument
        $TestClient.Name | Should -BeExactly "TestClient"
        $TestClient.Command | Should -BeExactly "client -u <user> -p <port> <host>"
        $TestClient.RequiresCmdKey | Should -BeExactly $false
        $TestClient.DefaultPort | Should -BeExactly 1234
        $TestClient.Description | Should -BeExactly "A test client."
        $TestClient.ToString() | Should -BeExactly "TestClient (A test client.) - client -u <user> -p <port:1234> <host>"
    }
    It "Creates a Client object which has a command with no token at all." {
        $Argument = (
            "TestClient",
            "client",
            $false,
            1234,
            "A test client."
        )
        {
            New-Object -TypeName Client -ArgumentList $Argument
        } | Should -Throw -ExpectedMessage "*The command does not contain the following token: host*"
    }
    It "Creates a Client object which requires CmdKey and `"user`" token is missing." {
        $Argument = (
            "TestClient",
            "client -p <port> <host>",
            $true,
            1234,
            "A test client."
        )
        New-Object -TypeName Client -ArgumentList $Argument
    }
    It "Creates a Client object which does not require CmdKey and `"user`" token is missing." {
        $Argument = (
            "TestClient",
            "client -p <port> <host>",
            $false,
            1234,
            "A test client."
        )
        {
            New-Object -TypeName Client -ArgumentList $Argument
        } | Should -Throw -ExpectedMessage "*The command does not contain the following token: user*"
    }
}
