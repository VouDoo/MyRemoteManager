class Inventory {
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
        $Items = Get-Content -Path $this.Path -Raw -Encoding ([Inventory]::Encoding) | ConvertFrom-Json -AsHashtable
        foreach ($c in $Items.Clients) {
            $this.Clients += New-Object -TypeName Client -ArgumentList @(
                $c.Name,
                $c.Executable,
                $c.TokenizedArgs,
                $c.DefaultPort,
                $c.Description
            )
        }
        if ($this.ClientNameDuplicateExists()) {
            Write-Warning -Message ("Fix it by renaming the duplicated client names in the inventory file: {0}" -f [Inventory]::GetPath())
        }
        foreach ($c in $Items.Connections) {
            $Client = $this.Clients | Where-Object -Property Name -EQ $c.Client
            $this.Connections += New-Object -TypeName Connection -ArgumentList @(
                $c.Name,
                $c.Hostname,
                $c.Port,
                $Client,
                $c.Description
            )
        }
        if ($this.ConnectionNameDuplicateExists()) {
            Write-Warning -Message ("Fix it by renaming the duplicated connection names in the inventory file: {0}" -f [Inventory]::GetPath())
        }
    }

    [void] SaveFile() {
        $Items = @{ Clients = @(); Connections = @() }
        foreach ($c in $this.Clients) {
            $Items.Clients += $c.Splat()
        }
        foreach ($c in $this.Connections) {
            $Connection = $c.Splat()
            $Connection.Client = $Connection.Client.Name
            $Items.Connections += $Connection
        }
        $Json = ConvertTo-Json -InputObject $Items -Depth 3
        $BackupPath = "{0}.backup" -f $this.Path
        if (Test-Path -Path $this.Path) {
            Copy-Item -Path $this.Path -Destination $BackupPath -Force
        }
        Set-Content -Path $this.Path -Value $Json -Encoding ([Inventory]::Encoding) -Force
    }

    hidden [bool] ClientNameDuplicateExists() {
        $Duplicates = $this.Clients
        | Group-Object -Property Name
        | Where-Object -Property Count -GT 1
        if ($Duplicates) {
            $Duplicates | ForEach-Object {
                Write-Warning -Message ("It exists more than one client named `"{0}`"." -f $_.Name)
            }
            return $true
        }
        return $false
    }

    hidden [bool] ConnectionNameDuplicateExists() {
        $Duplicates = $this.Connections
        | Group-Object -Property Name
        | Where-Object -Property Count -GT 1
        if ($Duplicates) {
            $Duplicates | ForEach-Object {
                Write-Warning -Message ("It exists more than one connection named `"{0}`"." -f $_.Name)
            }
            return $true
        }
        return $false
    }

    [bool] ClientExists([string] $Name) {
        return $(if (($this.Clients | Where-Object -Property Name -EQ $Name).Count -gt 0) { $true } else { $false })
    }

    [bool] ConnectionExists([string] $Name) {
        return $(if (($this.Connections | Where-Object -Property Name -EQ $Name ).Count -gt 0) { $true } else { $false })
    }

    [Client] GetClient([string] $Name) {
        return $this.Clients | Where-Object -Property Name -EQ $Name
    }

    [Connection] GetConnection([string] $Name) {
        return $this.Connections | Where-Object -Property Name -EQ $Name
    }

    [void] AddClient([Client] $Client) {
        if ($this.ClientExists($Client.Name)) {
            throw "Cannot add Client `"{0}`" as it already exists." -f $Client.Name
        }
        else {
            $this.Clients += $Client
        }
    }

    [void] AddConnection([Connection] $Connection) {
        if ($this.ConnectionExists($Connection.Name)) {
            throw "Cannot add Connection `"{0}`" as it already exists." -f $Connection.Name
        }
        else {
            $this.Connections += $Connection
        }
    }

    [void] RemoveClient([string] $Name) {
        $this.Clients = $this.Clients | Where-Object -Property Name -NE $Name
    }

    [void] RemoveConnection([string] $Name) {
        $this.Connections = $this.Connections | Where-Object -Property Name -NE $Name
    }
}
