class Inventory {
    # Title for the inventory file
    [string] $Title = "MyRemoteManager inventory"
    # description for the inventory file
    [string] $Description = "MyRemoteManager inventory file where the connections and clients are stored"
    # Version of the inventory file
    [string] $Version = "0.1.0"
    # Path to the inventory file
    [string] $Path = [Inventory]::GetPath()
    # Collection of Clients
    [Client[]] $Clients
    # Collection of Connections
    [Connection[]] $Connections
    # Encoding for inventory file
    static [string] $Encoding = "utf-8"
    # Name of the environement variable to use a custom path to the inventory file
    static [string] $EnvVariable = "MY_RM_INVENTORY"

    static [string] GetPath() {
        foreach ($Target in @("Process", "User", "Machine")) {
            $Value = [System.Environment]::GetEnvironmentVariable(
                [Inventory]::EnvVariable,
                [System.EnvironmentVariableTarget]::"$Target"
            )
            if ($Value) { return $Value }
        }
        return Join-Path -Path $env:USERPROFILE -ChildPath "MyRemoteManager.json"
    }

    [void] ReadFile() {
        # Get content from the file
        $GetContentParams = @{
            Path        = $this.Path
            Raw         = $true
            Encoding    = [Inventory]::Encoding
            ErrorAction = "Stop"
        }
        try {
            $Items = Get-Content @GetContentParams | ConvertFrom-Json -AsHashtable
        }
        catch {
            throw "Cannot open inventory: {0}" -f $_.Exception.Message
        }

        # Check version of the inventory
        if ($Items.Version -ne $this.Version) {
            throw (
                "Version of the inventory file is not supported.",
                "Current version: `"{0}`", Expected version: `"{1}`"" -f (
                    $Items.Version, $this.Version
                )
            )
        }

        # Re-initialize Clients array
        $this.Clients = @()

        # Add every Client to inventory object
        foreach ($c in $Items.Clients) {
            $this.Clients += New-Object -TypeName Client -ArgumentList @(
                $c.Name,
                $c.Executable,
                $c.TokenizedArgs,
                $c.DefaultPort,
                $c.DefaultScope,
                $c.Description
            )
        }

        # Check if Client name duplicates exist
        if ($this.ClientNameDuplicatesExist()) {
            Write-Warning -Message ("Fix the inventory by renaming the duplicated client names in the inventory file: {0}" -f (
                    [Inventory]::GetPath()
                )
            )
        }

        # Re-initialize Connections array
        $this.Connections = @()

        # Add every Connection to inventory object
        foreach ($c in $Items.Connections) {
            $this.Connections += New-Object -TypeName Connection -ArgumentList @(
                $c.Name,
                $c.Hostname,
                $c.Port,
                $c.DefaultClient,
                $c.DefaultUser,
                $c.Description
            )
        }

        # Check if Connection name duplicates exist
        if ($this.ConnectionNameDuplicatesExist()) {
            Write-Warning -Message (
                "Fix the inventory by renaming the duplicated connection names in the inventory file: {0}" -f (
                    [Inventory]::GetPath()
                )
            )
        }
    }

    [void] SaveFile() {
        $Items = [ordered] @{
            Title       = $this.Title
            Description = $this.Description
            Version     = $this.Version
            Clients     = @()
            Connections = @()
        }

        foreach ($c in $this.Clients) {
            $Items.Clients += $c.Splat()
        }

        foreach ($c in $this.Connections) {
            $Connection = $c.Splat()
            $Items.Connections += $Connection
        }

        $Json = ConvertTo-Json -InputObject $Items -Depth 3

        $BackupPath = "{0}.backup" -f $this.Path
        if (Test-Path -Path $this.Path -PathType Leaf) {
            Copy-Item -Path $this.Path -Destination $BackupPath -Force
        }

        Set-Content -Path $this.Path -Value $Json -Encoding ([Inventory]::Encoding) -Force
    }

    hidden [bool] ClientNameDuplicatesExist() {
        $Duplicates = $this.Clients
        | Group-Object -Property Name
        | Where-Object -Property Count -GT 1

        if ($Duplicates) {
            $Duplicates | ForEach-Object -Process {
                Write-Warning -Message ("It exists more than one client named `"{0}`"." -f $_.Name)
            }
            return $true
        }
        return $false
    }

    hidden [bool] ConnectionNameDuplicatesExist() {
        $Duplicates = $this.Connections
        | Group-Object -Property Name
        | Where-Object -Property Count -GT 1

        if ($Duplicates) {
            $Duplicates | ForEach-Object -Process {
                Write-Warning -Message ("It exists more than one connection named `"{0}`"." -f $_.Name)
            }
            return $true
        }
        return $false
    }

    [Client] GetClient([string] $Name) {
        return $this.Clients | Where-Object -Property Name -EQ $Name
    }

    [Connection] GetConnection([string] $Name) {
        return $this.Connections | Where-Object -Property Name -EQ $Name
    }

    [bool] ClientExists([string] $Name) {
        return $this.GetClient($Name).Count -gt 0
    }

    [bool] ConnectionExists([string] $Name) {
        return $this.GetConnection($Name).Count -gt 0
    }

    [void] AddClient([Client] $Client) {
        if ($this.ClientExists($Client.Name)) {
            throw "Cannot add Client `"{0}`" as it already exists." -f $Client.Name
        }
        $this.Clients += $Client
    }

    [void] AddConnection([Connection] $Connection) {
        if ($this.ConnectionExists($Connection.Name)) {
            throw "Cannot add Connection `"{0}`" as it already exists." -f $Connection.Name
        }
        $this.Connections += $Connection
    }

    [void] RemoveClient([string] $Name) {
        $this.Clients = $this.Clients | Where-Object -Property Name -NE $Name
    }

    [void] RemoveConnection([string] $Name) {
        $this.Connections = $this.Connections | Where-Object -Property Name -NE $Name
    }

    [void] RenameConnection([string] $Name, [string] $NewName) {
        if ($Name -eq $NewName) {
            throw "The two names are similar."
        }
        elseif (-not $this.ConnectionExists($Name)) {
            throw "No Connection `"{0}`" to rename." -f $Name
        }
        elseif ($this.ConnectionExists($NewName)) {
            throw "Cannot rename Connection `"{0}`" to `"{1}`" as this name is already used." -f $Name, $NewName
        }

        for ($i = 0; $i -lt $this.Connections.count; $i++) {
            if ($this.Connections[$i].Name -eq $Name) {
                $this.Connections[$i].Name = $NewName
            }
        }
    }
}
