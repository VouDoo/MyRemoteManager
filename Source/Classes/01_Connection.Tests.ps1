BeforeAll {
    . $PSCommandPath.Replace('.Tests.ps1', '.ps1')
}
Describe "Connection" {
    It "Creates a Connection object." {
        $Argument = (
            "TestConnection",
            "Hostname.test",
            1234,
            "test-user",
            "TestClient",
            "A test connection."
        )
        $TestConnection = New-Object -TypeName Connection -ArgumentList $Argument
        $TestConnection.Name | Should -BeExactly "TestConnection"
        $TestConnection.Hostname | Should -BeExactly "hostname.test"
        $TestConnection.Port | Should -BeExactly 1234
        $TestConnection.Username | Should -BeExactly "test-user"
        $TestConnection.ClientName | Should -BeExactly "TestClient"
        $TestConnection.Description | Should -BeExactly "A test connection."
        $TestConnection.ToString() | Should -BeExactly "TestConnection (A test connection.) - hostname.test:1234 with TestClient as test-user"
    }
    It "Creates a Connection object with an incorrect hostname." {
        $Argument = (
            "TestConnection",
            "hostname..test",
            1234,
            "test-user",
            "TestClient",
            "A test connection."
        )
        {
            New-Object -TypeName Connection -ArgumentList $Argument
        } | Should -Throw -ExpectedMessage "*The argument `"hostname..test`" does not match the*"
    }
}
