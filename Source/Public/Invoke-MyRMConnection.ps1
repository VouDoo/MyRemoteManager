# TODO develop Invoke-MyRMConnection function
function Invoke-MyRMConnection {
    [CmdletBinding()]
    [OutputType([System.Void])]
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
        $Inventory = Read-Inventory -Path (Get-InventoryPath)
        $Connection = $Inventory | Get-InventoryItem -ConnectionName $Name
        $Client = $Inventory | Get-InventoryItem -ClientName $Connection.ClientName
    }
    process {
        $Port = if ($Connection.Port -eq 0) { $Client.DefaultPort } else { $Connection.Port }
        $Command = $Client.Command `
            -replace "<host>", $Connection.Hostname `
            -replace "<port>", $Port `
            -replace "<user>", $Connection.Username
        Invoke-Expression -Command $Command
    }
}
