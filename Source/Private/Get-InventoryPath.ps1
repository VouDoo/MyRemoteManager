function Get-InventoryPath {
    process {
        try {
            $Path = "Env:{0}" -f $script:InventoryEnvironmentVariable
            Get-ChildItem -Path $Path -ErrorAction Stop | Select-Object -ExpandProperty Value
        }
        catch {
            $script:InventoryDefaultPath
        }
    }
}
