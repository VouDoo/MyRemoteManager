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

    [string] GenerateArgs() {
        return $this.Client.TokenizedArgs.Replace(
            "<host>", $this.Hostname
        ).Replace(
            "<port>", $(if ($this.Port -eq 0) { $this.Client.DefaultPort } else { $this.Port })
        )
    }

    [string] GenerateArgs([string] $User) {
        return $this.GenerateArgs().Replace(
            "<user>", $User
        )
    }

    [void] Invoke() {
        $FilePath = $this.Client.Executable
        if ([Client]::UserTokenExists($this.Client.TokenizedArgs)) {
            $User = Read-Host -Prompt ("Username" -f $this.Hostname)
            $Arguments = $this.GenerateArgs($User)
        }
        else {
            $Arguments = $this.GenerateArgs()
        }
        Start-Process -FilePath $FilePath -ArgumentList $Arguments
    }

    [string] ToString() {
        return "{0} ({1}): {2} to {3}:{4}" -f `
            $this.Name, `
            $this.Description, `
            $this.Client.Name, `
            $this.Hostname, `
            $this.Port.ToString().Replace("0", "default")
    }
}
