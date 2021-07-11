class ValidateSetConnectionName : IValidateSetValuesGenerator {
    [string[]] GetValidValues() {
        try {
            $Inventory = Import-Inventory
            return $Inventory.Connections | ForEach-Object -Process { $_.Name }
        }
        catch {
            Write-Warning -Message $_.Exception.Message
        }
        return $null
    }
}
