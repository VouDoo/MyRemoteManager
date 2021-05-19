class Connection : Item {
    # Hostname
    [ValidatePattern("^(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\-]*[A-Za-z0-9])$")]
    [string] $Hostname
    # Port
    [UInt16] $Port
    # Client
    [Client] $Client

    Connection(
        [String] $Name,
        [String] $Hostname,
        [UInt16] $Port,
        [Client] $Client,
        [string] $Description
    ) {
        $this.Name = $Name
        $this.Hostname = $Hostname.ToLower()
        $this.Port = $Port
        $this.Client = $Client
        $this.Description = $Description
    }

    [UInt16] GetPort() {
        if ($this.Port -eq 0) {
            return $this.Client.DefaultPort
        }
        return $this.Port
    }

    [string] GenerateArgs() {
        return $this.Client.TokenizedArgs.Replace(
            "<host>", $this.Hostname
        ).Replace(
            "<port>", $this.GetPort()
        )
    }

    [string] GenerateArgs([string] $User) {
        return $this.GenerateArgs().Replace(
            "<user>", $User
        )
    }

    [string] ToString() {
        return "{0} ({1}): {2} to {3}:{4}" -f `
            $this.Name, `
            $this.Description, `
            $this.Client.Name, `
            $this.Hostname, `
            $this.GetPort()
    }
}
