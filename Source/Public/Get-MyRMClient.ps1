function Get-MyRMClient {

    <#

    .SYNOPSIS
    Gets MyRemoteManager clients.

    .DESCRIPTION
    Gets available clients from the MyRemoteManager inventory file.
    Clients can be filtered by their name.

    .PARAMETER Name
    Filters clients by name.

    .INPUTS
    None. You cannot pipe objects to Get-MyRMClient.

    .OUTPUTS
    PSCustomObject. Get-MyRMClient returns objects with details of the available clients.

    .EXAMPLE
    PS> Get-MyRMClient
    (objects)

    .EXAMPLE
    PS> Get-MyRMClient -Name "custom_*"
    (filtered objects)

    #>

    [OutputType([PSCustomObject[]])]
    [CmdletBinding()]
    param (
        [Parameter(
            HelpMessage = "Filter by client name."
        )]
        [ValidateNotNullOrEmpty()]
        [string] $Name = "*"
    )

    begin {
        $Inventory = Import-Inventory
    }

    process {
        $Clients = @()
        foreach ($c in $Inventory.Clients) {
            $Clients += [PSCustomObject] @{
                Name         = $c.Name
                Command      = "{0} {1}" -f $c.Executable, $c.TokenizedArgs
                DefaultPort  = $c.DefaultPort
                DefaultScope = $c.DefaultScope
                Description  = $c.Description
            }
        }
    }

    end {
        $Clients
        | Where-Object -Property Name -Like $Name
        | Sort-Object -Property Name
    }
}
