class Client : Item {
    # Executable
    [string] $Executable
    # Command template
    [string] $TokenizedArgs
    # Default port
    [UInt16] $DefaultPort

    Client(
        [string] $Name,
        [string] $Executable,
        [string] $TokenizedArgs,
        [UInt16] $DefaultPort,
        [string] $Description
    ) {
        $this.Name = $Name
        $this.Executable = $Executable
        [Client]::ValidateTokenizedArgs($TokenizedArgs)
        $this.TokenizedArgs = $TokenizedArgs
        $this.DefaultPort = $DefaultPort
        $this.Description = $Description
    }

    static [void] ValidateTokenizedArgs([string] $TokenizedArgs) {
        "host", "port" | ForEach-Object -Process {
            if ($TokenizedArgs -notmatch ("<{0}>" -f $_)) {
                throw "The command does not contain the following token: {0}" -f $_
            }
        }
    }

    static [bool] UserTokenExists([string] $TokenizedArgs) {
        return $(if ($TokenizedArgs -match "<user>") { $true } else { $false })
    }

    [string] ToString() {
        return "{0} ({1}) - {2}" -f `
            $this.Name, `
            $this.Description, `
            $this.TokenizedArgs.Replace("<port>", "<port:{0}>" -f $this.DefaultPort)
    }
}
