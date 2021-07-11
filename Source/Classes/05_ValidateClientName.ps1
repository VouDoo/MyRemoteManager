class ValidateClientName : ValidateArgumentsAttribute {
    [void] Validate(
        [System.Object] $Argument,
        [System.Management.Automation.EngineIntrinsics] $EngineIntrinsics
    ) {
        $Inventory = Import-Inventory
        if (-not $Inventory.ClientExists($Argument)) {
            Throw "Client `"{0}`" does not exist." -f $Argument
        }
    }
}
