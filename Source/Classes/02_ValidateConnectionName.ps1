class ValidateConnectionName : IValidateSetValuesGenerator {
    [string[]] GetValidValues() {
        return (Read-Inventory -Path (Get-InventoryPath)).Connections.Keys
    }
}
