function Add-InventoryItem {
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [hashtable] $Inventory,

        [Parameter(ParameterSetName = "Client", Mandatory = $true)]
        [Client] $Client,

        [Parameter(ParameterSetName = "Connection", Mandatory = $true)]
        [Connection] $Connection
    )
    begin {
        switch ($PSCmdlet.ParameterSetName) {
            "Client" {
                $Item = $Client
                $ItemType = "Client"
                $ItemParent = "Clients"
            }
            "Connection" {
                $Item = $Connection
                $ItemType = "Connection"
                $ItemParent = "Connections"
            }
            Default { throw "Function error: ParameterSetName is incorrect." }
        }
    }
    process {
        if ($Inventory."$ItemParent".ContainsKey($Item.Name) -eq $false) {
            $Inventory."$ItemParent".Add(
                $Item.Name,
                ($Item | Select-Object -ExcludeProperty Name)
            )
        }
        else {
            throw ("{0} `"{1}`" already exists." -f $ItemType, $Item.Name)
        }
    }
    end {
        $Inventory
    }
}
