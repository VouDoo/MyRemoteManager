class ValidateClientName : IValidateSetValuesGenerator {
    [string[]] GetValidValues() {
        $Inventory = New-Object -TypeName Inventory
        $Inventory.ReadFile()
        return $Inventory.Clients | ForEach-Object { $_.Name }
    }
}
