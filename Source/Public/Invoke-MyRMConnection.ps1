function Invoke-MyRMConnection {
    [OutputType([void])]
    [CmdletBinding()]
    param (
        [Parameter(
            Position = 0,
            Mandatory = $true,
            HelpMessage = "Name of the connection."
        )]
        [ValidateNotNullOrEmpty()]
        [ValidateSet( [ValidateConnectionName] )]
        [string] $Name
    )
    begin {
        $Inventory = New-Object -TypeName Inventory
        $Inventory.ReadFile()
    }
    process {
        $Connection = $Inventory.Connections | Where-Object { $_.Name -eq $Name }
        $Client = $Inventory.Clients | Where-Object { $_.Name -eq $Connection.ClientName }
        if ($Connection.Port -eq 0) {
            Invoke-Expression -Command $Client.GenerateCommand($Connection.Hostname)
        }
        else {
            Invoke-Expression -Command $Client.GenerateCommand($Connection.Hostname, $Connection.Port)
        }
    }
    end {}
}
