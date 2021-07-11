class ValidateSetClientName : IValidateSetValuesGenerator {
    [string[]] GetValidValues() {
        try {
            $Inventory = Import-Inventory
            return $Inventory.Clients | ForEach-Object -Process { $_.Name }
        }
        catch {
            Write-Warning -Message $_.Exception.Message
        }
        return $null
    }
}
