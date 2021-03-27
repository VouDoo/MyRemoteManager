function Read-Inventory {
    [OutputType([hashtable])]
    param (
        [Parameter(Mandatory = $true)]
        [string] $Path
    )
    process {
        Write-Debug -Message "Read inventory file to `"$Path`""
        Get-Content -Path $Path -Raw -Encoding $script:InventoryEncoding | ConvertFrom-Json -AsHashtable
    }
}
