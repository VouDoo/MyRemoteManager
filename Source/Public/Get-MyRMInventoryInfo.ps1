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
    (objects)

    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param ()

    begin {
        $Inventory = New-Object -TypeName Inventory
        $FileExists = $false
    }

    process {
        if (Test-Path -Path $Inventory.Path -PathType Leaf) {
            $Inventory.ReadFile()
            $FileExists = $true
        }

        $InventoryInfo = [PSCustomObject] @{
            Path                = $Inventory.Path
            EnvVariable         = [Inventory]::EnvVariable
            FileExists          = $FileExists
            NumberOfClients     = $Inventory.Clients.Count
            NumberOfConnections = $Inventory.Connections.Count
        }
    }

    end {
        $InventoryInfo
    }
}
