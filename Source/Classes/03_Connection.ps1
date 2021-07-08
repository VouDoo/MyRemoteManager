class Connection : Item {
    # Hostname
    [ValidatePattern("^(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\-]*[A-Za-z0-9])$")]
    [string] $Hostname
    # Port
    [UInt16] $Port
    # Default client
    [string] $DefaultClient
    # Default user
    [string] $DefaultUser

    Connection(
        [String] $Name,
        [String] $Hostname,
        [UInt16] $Port,
        [string] $DefaultClient,
        [string] $DefaultUser,
        [string] $Description
    ) {
        $this.Name = $Name
        $this.Hostname = $Hostname.ToLower()
        $this.Port = $Port
        $this.DefaultClient = $DefaultClient
        $this.DefaultUser = $DefaultUser
        $this.Description = $Description
    }

    [bool] IsDefaultPort() {
        return $this.Port -eq 0
    }

    [string] ToString() {
        return "{0}, Description `"{1}`", Default client {2}, Target {3}:{4}" -f (
            $this.Name,
            $this.Description,
            $this.DefaultClient,
            $this.Hostname,
            $(
                if ($this.IsDefaultPort()) {
                    "default"
                }
                else {
                    $this.Port.ToString()
                }
            )
        )
    }
}
