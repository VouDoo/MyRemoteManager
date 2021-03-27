class Connection {
    # Name
    [ValidateLength(1, 30)]
    [ValidatePattern("^([a-zA-Z0-9]+)$")]
    [string] $Name
    # Hostname
    [ValidatePattern("^(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\-]*[A-Za-z0-9])$")]
    [string] $Hostname
    # Port
    [UInt16] $Port
    # Username
    [string] $Username
    # Client name
    [ValidateLength(1, 10)]
    [ValidatePattern("^([a-zA-Z0-9]+)$")]
    [string] $ClientName
    # Description
    [string] $Description

    Connection (
        [String] $Name,
        [String] $Hostname,
        [UInt16] $Port,
        [string] $Username,
        [string] $ClientName,
        [string] $Description
    ) {
        $this.Name = $Name
        $this.Hostname = $Hostname.ToLower()
        $this.Port = $Port
        $this.Username = $Username
        $this.ClientName = $ClientName
        $this.Description = $Description
    }

    [string] ToString() {
        return "{0} ({1}) - {2}:{3} with {4} as {5}" -f `
            $this.Name, `
            $this.Description, `
            $this.Hostname, `
            $this.Port.ToString().Replace("0", "default"), `
            $this.ClientName, `
            $this.Username
    }
}
