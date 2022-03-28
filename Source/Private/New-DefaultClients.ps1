function New-DefaultClients {

    <#

    .SYNOPSIS
    Creates default clients.

    .DESCRIPTION
    Creates and returns Client objects with popular programs.

    .INPUTS
    None. You cannot pipe objects to New-DefaultClients.

    .OUTPUTS
    Client[]. New-DefaultClients returns an array of Client objects.

    .EXAMPLE
    PS> New-DefaultClients
    (Client[])

    #>

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "", Scope = "Function", Target = "*")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "", Scope = "Function", Target = "*")]
    [OutputType([Client[]])]
    param ()

    process {
        $DefaultClient = @()

        # OpenSSH (Microsoft Windows feature)
        $DefaultClient += New-Object -TypeName Client -ArgumentList @(
            "OpenSSH",
            "C:\Windows\System32\OpenSSH\ssh.exe",
            "-l <user> -p <port> <host>",
            22,
            [Scopes]::Console,
            "OpenSSH (Microsoft Windows feature)"
        )

        # PuTTY using SSH protocol
        $DefaultClient += New-Object -TypeName Client -ArgumentList @(
            "PuTTY_SSH",
            "putty.exe",
            "-ssh -P <port> <user>@<host>",
            22,
            [Scopes]::External,
            "PuTTY using SSH protocol"
        )

        # Microsoft Remote Desktop
        $DefaultClient += New-Object -TypeName Client -ArgumentList @(
            "RD",
            "C:\Windows\System32\mstsc.exe",
            "/v:<host>:<port> /fullscreen",
            3389,
            [Scopes]::External,
            "Microsoft Remote Desktop"
        )

        $DefaultClient
    }
}
