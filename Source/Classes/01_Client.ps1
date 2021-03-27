class Client {
    # Name
    [ValidateLength(1, 10)]
    [ValidatePattern("^([a-zA-Z0-9_]+)$")]
    [string] $Name
    # Command
    [string] $Command
    # Requires cmdkey
    [bool] $RequiresCmdKey
    # Default port
    [UInt16] $DefaultPort
    # Description
    [string] $Description

    Client (
        [string] $Name,
        [string] $Command,
        [bool] $RequiresCmdKey,
        [UInt16] $DefaultPort,
        [string] $Description
    ) {
        # Validate if required tokens are present in the command
        $RequiredTokens = "host", "port"
        if ($RequiresCmdKey -eq $false) { $RequiredTokens += "user" }
        $RequiredTokens | ForEach-Object -Process {
            if ($Command -notmatch ("<{0}>" -f $_)) {
                throw "The command does not contain the following token: {0}" -f $_
            }
        }

        $this.Name = $Name
        $this.Command = $Command
        $this.RequiresCmdKey = $RequiresCmdKey
        $this.DefaultPort = $DefaultPort
        $this.Description = $Description
    }

    [string] ToString() {
        return "{0} ({1}) - {2}" -f `
            $this.Name, `
            $this.Description, `
            $this.Command.Replace("<port>", "<port:{0}>" -f $this.DefaultPort)
    }
}
