function Remove-MyRMConnection {
    [OutputType([void])]
    [CmdletBinding(SupportsShouldProcess = $true)]
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
        $Inventory.RemoveConnection($Name)
        if ($PSCmdlet.ShouldProcess("Target", "Operation")) {
            $Inventory.SaveFile()
            Write-Verbose -Message ("Connection `"{0}`" has been removed from the inventory." -f $Name)
        }
        else {
            Write-Verbose -Message ("Remove Connection `"{0}`" from the inventory." -f $Connection.ToString())
        }
    }
    end {}
}
