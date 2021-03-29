class ValidateConnectionName : IValidateSetValuesGenerator {
    [string[]] GetValidValues() {
        $Inventory = New-Object -TypeName Inventory
        $Inventory.ReadFile()
        return $Inventory.Connections | ForEach-Object { $_.Name }
    }
}
