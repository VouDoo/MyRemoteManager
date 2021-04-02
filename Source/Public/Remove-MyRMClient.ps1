function Remove-MyRMClient {

    <#
    .SYNOPSIS
        Removes MyRemoteManager client.
    .DESCRIPTION
        Removes client entry from the MyRemoteManager inventory file.
    .PARAMETER Name
        Name of the client.
    .INPUTS
        None. You cannot pipe objects to Remove-MyRMClient.
    .OUTPUTS
        System.Void. None.
    .EXAMPLE
        PS> Remove-MyRMClient SSH
    .EXAMPLE
        PS> Remove-MyRMClient -Name SSH
    #>

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
        if (
            $PSCmdlet.ShouldProcess(
                "Inventory file {0}" -f $Inventory.Path,
                "Remove Client {0}" -f $Name
            )
        ) {
            $Inventory.RemoveClient($Name)
            $Inventory.SaveFile()
            Write-Verbose -Message ("Client `"{0}`" has been removed from the inventory." -f $Name)
        }
    }
    end {}
}
