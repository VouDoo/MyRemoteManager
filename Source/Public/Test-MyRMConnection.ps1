function Test-MyRMConnection {

    <#
    .SYNOPSIS
        Tests MyRemoteManager connection.
    .DESCRIPTION
        Tests MyRemoteManager connection which is defined in the inventory.
    .PARAMETER Name
        Name of the connection.
    .INPUTS
        None. You cannot pipe objects to Test-MyRMConnection.
    .OUTPUTS
        System.Void. None.
    .EXAMPLE
        PS> Test-MyRMConnection myconn
    .EXAMPLE
        PS> Test-MyRMConnection -Name myconn
    #>

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
        $Connection = $Inventory.Connections | Where-Object -Property Name -EQ $Name
        if (Test-Connection -TargetName $Connection.Hostname -TcpPort $Connection.GetPort() -TimeoutSeconds 3) {
            Write-Information -MessageData (
                "Connection {0} is up." -f $Connection.ToString()
            )
        }
        else {
            Write-Error -Exception (
                [System.Exception] ("Connection: {0} is down." -f $Connection.ToString())
            )
        }
    }
    end {}
}
