function Save-Inventory {
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [hashtable] $Inventory,

        [Parameter(Mandatory = $true)]
        [string] $Path
    )
    begin {
        $BackupPath = "{0}.{1}" -f $Path, $script:InventoryBackupExtension
    }
    process {
        $Json = ConvertTo-Json -InputObject $Inventory -Depth 3
        if (Test-Path -Path $Path) {
            Write-Debug -Message "Backup previous inventory file to `"$BackupPath`""
            Move-Item -Path $Path -Destination $BackupPath -Force
        }
        Write-Debug -Message "Save inventory file to `"$Path`""
        Set-Content -Path $Path -Value $Json -Encoding $script:InventoryEncoding -Force
    }
}
