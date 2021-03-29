function Remove-MyRMClient {
    [OutputType([void])]
    [CmdletBinding()]
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
        $Inventory = New-Object -TypeName Inventory
        $Inventory.ReadFile()
    }
    process {
        $Inventory.RemoveClient($Name)
        $Inventory.SaveFile()
        Write-Verbose -Message ("Client `"{0}`" has been removed from the inventory." -f $Name)
    }
    end {}
}
