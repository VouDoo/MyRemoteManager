function Remove-MyRMClient {
    [OutputType([void])]
    [CmdletBinding(SupportsShouldProcess = $true)]
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
        if ($PSCmdlet.ShouldProcess("Target", "Operation")) {
            $Inventory.SaveFile()
            Write-Verbose -Message ("Client `"{0}`" has been removed from the inventory." -f $Name)
        }
        else {
            Write-Verbose -Message ("Remove Client `"{0}`" from the inventory." -f $Client.ToString())
        }
    }
    end {}
}
