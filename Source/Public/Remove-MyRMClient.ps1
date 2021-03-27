function Remove-MyRMClient {
    [CmdletBinding()]
    [OutputType([System.Void])]
    param (
        [Parameter(
            Position = 0,
            Mandatory = $true,
            HelpMessage = "Name of the client."
        )]
        [ValidateNotNullOrEmpty()]
        [ValidateSet( [ValidateClientName] )]
        [string] $Name
    )
    begin {
        $InventoryFile = Get-InventoryPath
    }
    process {
        Read-Inventory -Path $InventoryFile `
        | Remove-InventoryItem -ClientName $Name `
        | Save-Inventory -Path $InventoryFile
        Write-Verbose -Message ("Client `"{0}`" has been removed from the inventory." -f $Name)
    }
}
