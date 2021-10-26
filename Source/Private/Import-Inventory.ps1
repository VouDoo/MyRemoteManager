function Import-Inventory {

    <#

    .SYNOPSIS
    Import inventory.

    .DESCRIPTION
    Creates inventory object, reads inventory file and returns the object.

    .INPUTS
    None. You cannot pipe objects to Import-Inventory.

    .OUTPUTS
    Inventory. Import-Inventory returns the inventory object.

    .EXAMPLE
    PS> Import-Inventory
    (Inventory)

    #>

    [OutputType([Inventory])]
    param ()

    process {
        $Inventory = New-Object -TypeName Inventory
        $Inventory.ReadFile()
    }

    end {
        $Inventory
    }
}
