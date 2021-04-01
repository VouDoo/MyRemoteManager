function Remove-MyRMConnection {

    <#
    .SYNOPSIS
        Removes MyRemoteManager connection.
    .DESCRIPTION
        Removes connection entry from the MyRemoteManager inventory file.
    .PARAMETER Name
        Name of the connection.
    .INPUTS
        None. You cannot pipe objects to Remove-MyRMConnection.
    .OUTPUTS
        System.Void. None.
    .EXAMPLE
        PS> Remove-MyRMConnection myconn
    .EXAMPLE
        PS> Remove-MyRMConnection -Name myconn
    #>

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
        if (
            $PSCmdlet.ShouldProcess(
                "Inventory file {0}" -f $Inventory.Path,
                "Remove Connection {0}" -f $Name
            )
        ) {
            $Inventory.RemoveConnection($Name)
            $Inventory.SaveFile()
            Write-Verbose -Message ("Connection `"{0}`" has been removed from the inventory." -f $Name)
        }
    }
    end {}
}
