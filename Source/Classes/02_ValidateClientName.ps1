class ValidateClientName : IValidateSetValuesGenerator {
    [string[]] GetValidValues() {
        return (Read-Inventory -Path (Get-InventoryPath)).Clients.Keys
    }
}
