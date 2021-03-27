function Remove-MyRMConnection {
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
        $InventoryFile = Get-InventoryPath
    }
    process {
        Read-Inventory -Path $InventoryFile `
        | Remove-InventoryItem -ConnectionName $Name `
        | Save-Inventory -Path $InventoryFile
        Write-Verbose -Message ("Connection `"{0}`" has been removed from the inventory." -f $Name)
    }
}
