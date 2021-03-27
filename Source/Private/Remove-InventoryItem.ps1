function Remove-InventoryItem {
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [hashtable] $Inventory,

        [Parameter(ParameterSetName = "Client", Mandatory = $true)]
        [string] $ClientName,

        [Parameter(ParameterSetName = "Connection", Mandatory = $true)]
        [string] $ConnectionName
    )
    begin {
        switch ($PSCmdlet.ParameterSetName) {
            "Client" {
                $KeyName = $ClientName
                $ItemType = "Client"
                $ItemParent = "Clients"
            }
            "Connection" {
                $KeyName = $ConnectionName
                $ItemType = "Connection"
                $ItemParent = "Connections"
            }
            Default { throw "Function error: ParameterSetName is incorrect." }
        }
    }
    process {
        if ($Inventory."$ItemParent".ContainsKey($KeyName)) {
            $Inventory."$ItemParent".Remove($KeyName)
        }
        else {
            throw ("{0} `"{1}`" does not exist." -f $ItemType, $KeyName)
        }
    }
    end {
        $Inventory
    }
}
