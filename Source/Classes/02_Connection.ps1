class Connection : Item {
    # Hostname
    [ValidatePattern("^(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\-]*[A-Za-z0-9])$")]
    [string] $Hostname
    # Port
    [UInt16] $Port
    # Client name
    [ValidateLength(1, 10)]
    [ValidatePattern("^([a-zA-Z0-9]+)$")]
    [string] $ClientName

    Connection(
        [String] $Name,
        [String] $Hostname,
        [UInt16] $Port,
        [string] $ClientName,
        [string] $Description
    ) {
        $this.Name = $Name
        $this.Hostname = $Hostname.ToLower()
        $this.Port = $Port
        $this.ClientName = $ClientName
        $this.Description = $Description
    }

    [string] ToString() {
        return "{0} ({1}) - {2}:{3} with {4}" -f `
            $this.Name, `
            $this.Description, `
            $this.Hostname, `
            $this.Port.ToString().Replace("0", "default"), `
            $this.ClientName
    }
}
