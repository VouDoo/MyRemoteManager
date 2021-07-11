class ValidateConnectionName : ValidateArgumentsAttribute {
    [void] Validate(
        [System.Object] $Argument,
        [System.Management.Automation.EngineIntrinsics] $EngineIntrinsics
    ) {
        $Inventory = Import-Inventory
        if (-not $Inventory.ConnectionExists($Argument)) {
            Throw "Connection `"{0}`" does not exist." -f $Argument
        }
    }
}
