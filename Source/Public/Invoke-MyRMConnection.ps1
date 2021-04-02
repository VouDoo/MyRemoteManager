function Invoke-MyRMConnection {

    <#
    .SYNOPSIS
        Invokes MyRemoteManager connection.
    .DESCRIPTION
        Invokes MyRemoteManager connection which is defined in the inventory.
    .PARAMETER Name
        Name of the connection.
    .INPUTS
        None. You cannot pipe objects to Invoke-MyRMConnection.
    .OUTPUTS
        System.Void. None.
    .EXAMPLE
        PS> Invoke-MyRMConnection myconn
    .EXAMPLE
        PS> Invoke-MyRMConnection -Name myconn
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
        $Connection = $Inventory.Connections | Where-Object -Property Name -EQ $Name
        if ($PSCmdlet.ShouldProcess($Connection.ToString(), "Initiate connection")) {
            $Connection.Invoke()
        }
    }
    end {}
}
