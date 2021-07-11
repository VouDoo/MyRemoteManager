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
    System.String. Test-MyRMConnection returns a string with the status of the remote host.

    .EXAMPLE
    PS> Test-MyRMConnection myconn

    .EXAMPLE
    PS> Test-MyRMConnection -Name myconn

    #>

    [OutputType([string])]
    [CmdletBinding()]
    param (
        [Parameter(
            Position = 0,
            Mandatory = $true,
            HelpMessage = "Name of the connection."
        )]
        [ValidateSet([ValidateSetConnectionName])]
        [ValidateConnectionName()]
        [string] $Name
    )

    begin {
        $Inventory = Import-Inventory
        $Status = "Unknown"
    }

    process {
        $Connection = $Inventory.GetConnection($Name)

        $Port = if ($Connection.IsDefaultPort()) {
            $Inventory.GetClient($Connection.DefaultClient).DefaultPort
        }
        else {
            $Connection.Port
        }

        $TestConnectionParams = @{
            TargetName     = $Connection.Hostname
            TcpPort        = $Port
            TimeoutSeconds = 3
            ErrorAction    = "Stop"
        }

        try {
            if (Test-Connection @TestConnectionParams) {
                Write-Information -MessageData (
                    "Connection {0} is up on port {1}." -f $Connection.ToString(), $Port
                ) -InformationAction Continue
                $Status = "Online"
            }
            else {
                Write-Error -Message (
                    "Connection: {0} is down on port {1}." -f $Connection.ToString(), $Port
                )
                $Status = "Offline"
            }
        }
        catch {
            Write-Error -Message $_.Exception.Message
            $Status = "CritialFailure"
        }
    }

    end {
        $Status
    }
}
