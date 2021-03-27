function New-MyRMInventory {
    [CmdletBinding()]
    [OutputType([string])]
    param (
        [Parameter(
            HelpMessage = "Do not add defaults clients."
        )]
        [switch] $NoDefaultClients,

        [Parameter(
            HelpMessage = "Overwrite existing inventory file."
        )]
        [switch] $Force,

        [Parameter(
            HelpMessage = "Indicates that the cmdlet sends items from the interactive window down the pipeline as input to other commands."
        )]
        [switch] $PassThru
    )
    begin {
        $File = Get-InventoryPath
        $Inventory = @{ Clients = @{}; Connections = @{} }
        if (-not $NoDefaultClients.IsPresent) {
            # TODO Dynamically call Add-Inventory for each $script:DefaultClient* variables
            $Inventory = $Inventory `
            | Add-InventoryItem -Client $script:DefaultClientRD `
            | Add-InventoryItem -Client $script:DefaultClientSSH
        }
    }
    process {
        if (Test-Path -Path $File -PathType Leaf) {
            if ($Force.IsPresent) {
                Save-Inventory -Inventory $Inventory -Path $File
                Write-Verbose -Message "Inventory file has been overwritten: $File"
            }
            else {
                Write-Error -ErrorAction Stop -Exception (
                    [System.IO.IOException] "Inventory file already exists. Use `"-Force`" to overwrite it."
                )
            }
        }
        else {
            Save-Inventory -Inventory $Inventory -Path $File
            Write-Verbose -Message "Inventory file has been created: $File"
        }
    }
    end {
        if ($PassThru.IsPresent) {
            Resolve-Path $File | Select-Object -ExpandProperty Path
        }
    }
}
