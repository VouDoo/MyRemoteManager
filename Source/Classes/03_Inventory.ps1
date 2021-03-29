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
    static [string] $EnvVarName = "MY_RM_INVENTORY"

    static [string] GetPath() {
        $EnvPath = "Env:{0}" -f [Inventory]::EnvVarName
        if (Test-Path -Path $EnvPath) {
            return Get-ChildItem -Path $EnvPath | Select-Object -ExpandProperty Value
        }
        return Join-Path $env:HOME -ChildPath "MyRemoteManager.json"
    }

    [void] ReadFile() {
        $Items = Get-Content -Path $this.Path -Raw -Encoding ([Inventory]::Encoding) | ConvertFrom-Json -AsHashtable
        $Items.Clients | ForEach-Object -Process {
            $this.Clients += New-Object -TypeName Client -ArgumentList @(
                $_.Name,
                $_.Command,
                $_.DefaultPort,
                $_.Description
            )
        }
        $Items.Connections | ForEach-Object -Process {
            $this.Connections += New-Object -TypeName Connection -ArgumentList @(
                $_.Name,
                $_.Hostname,
                $_.Port,
                $_.ClientName,
                $_.Description
            )
        }
    }

    [void] SaveFile() {
        $Items = @{ Clients = @(); Connections = @() }
        foreach ($c in $this.Clients) {
            $Items.Clients += $c.Splat()
        }
        foreach ($c in $this.Connections) {
            $Items.Connections += $c.Splat()
        }
        $Json = ConvertTo-Json -InputObject $Items -Depth 3
        $BackupPath = "{0}.backup" -f $this.Path
        if (Test-Path -Path $this.Path) {
            Copy-Item -Path $this.Path -Destination $BackupPath -Force
        }
        Set-Content -Path $this.Path -Value $Json -Encoding ([Inventory]::Encoding) -Force
    }

    [bool] ClientExists([string] $Name) {
        return $(if (($this.Clients | Where-Object { $_.Name -eq $Name }).Count -gt 0) { $true } else { $false })
    }

    [bool] ConnectionExists([string] $Name) {
        return $(if (($this.Connections | Where-Object { $_.Name -eq $Name }).Count -gt 0) { $true } else { $false })
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
        $this.Clients = $this.Clients | Where-Object { $_.Name -ne $Name }
    }

    [void] RemoveConnection([string] $Name) {
        $this.Connections = $this.Connections | Where-Object { $_.Name -ne $Name }
    }
}
