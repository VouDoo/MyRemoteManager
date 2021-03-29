class Client : Item {
    # Command
    [string] $Command
    # Default port
    [UInt16] $DefaultPort

    Client(
        [string] $Name,
        [string] $Command,
        [UInt16] $DefaultPort,
        [string] $Description
    ) {
        [Client]::ValidateCommand($Command)
        $this.Name = $Name
        $this.Command = $Command
        $this.DefaultPort = $DefaultPort
        $this.Description = $Description
    }

    static [void] ValidateCommand([string] $Command) {
        "host", "port" | ForEach-Object -Process {
            if ($Command -notmatch ("<{0}>" -f $_)) {
                throw "The command does not contain the following token: {0}" -f $_
            }
        }
    }

    [string] GenerateCommand([string] $Hostname) {
        return $this.Command.Replace(
            "<host>", $Hostname
        ).Replace(
            "<port>", $this.DefaultPort
        )
    }

    [string] GenerateCommand([string] $Hostname, [UInt16] $Port) {
        return $this.Command.Replace(
            "<host>", $Hostname
        ).Replace(
            "<port>", $Port
        )
    }

    [string] ToString() {
        return "{0} ({1}) - {2}" -f `
            $this.Name, `
            $this.Description, `
            $this.Command.Replace("<port>", "<port:{0}>" -f $this.DefaultPort)
    }
}
