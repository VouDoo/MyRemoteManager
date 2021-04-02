function Get-MyRMInventoryInfo {

    <#
    .SYNOPSIS
        Gets MyRemoteManager inventory information.
    .DESCRIPTION
        Gets detailed information about the MyRemoteManager inventory.
    .INPUTS
        None. You cannot pipe objects to Get-MyRMInventoryInfo.
    .OUTPUTS
        PSCustomObject. Get-MyRMInventoryInfo returns an object with detailed information.
    .EXAMPLE
        PS> Get-MyRMInventoryInfo
        (shows object)
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param ()
    begin {
        $Inventory = New-Object -TypeName Inventory
        $Inventory.ReadFile()
    }
    process {
        $InventoryInfo = [PSCustomObject] @{
            Path                = $Inventory.Path
            EnvVariable         = [Inventory]::EnvVariable
            NumberOfClients     = $Inventory.Clients.Count
            NumberOfConnections = $Inventory.Connections.Count
        }
    }
    end {
        $InventoryInfo
    }
}
