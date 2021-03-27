function Add-MyRMClient {
    [CmdletBinding()]
    [OutputType([Client])]
    param (
        [Parameter(
            Mandatory = $true,
            HelpMessage = "Name of the client."
        )]
        [ValidateNotNullOrEmpty()]
        [string] $Name,

        [Parameter(
            Mandatory = $true,
            HelpMessage = "Command to execute when calling the client. It must contain the following template token."
        )]
        [ValidateNotNullOrEmpty()]
        [string] $Command,

        [Parameter(
            HelpMessage = "Execute CmdKey before the client's command."
        )]
        [bool] $RequiresCmdKey = $false,

        [Parameter(
            Mandatory = $true,
            HelpMessage = "Default port to connect to on the remote host."
        )]
        [ValidateNotNullOrEmpty()]
        [UInt16] $DefaultPort,

        [Parameter(
            HelpMessage = "Short description of the client."
        )]
        [string] $Description,

        [Parameter(
            HelpMessage = "Indicates that the cmdlet sends items from the interactive window down the pipeline as input to other commands."
        )]
        [switch] $PassThru
    )
    begin {
        $InventoryFile = Get-InventoryPath
        $Client = New-Object -TypeName Client -ArgumentList $Name, $Command, $RequiresCmdKey, $DefaultPort, $Description
    }
    process {
        Read-Inventory -Path $InventoryFile `
        | Add-InventoryItem -Client $Client `
        | Save-Inventory -Path $InventoryFile
        Write-Verbose -Message ("Client `"{0}`" has been added to the inventory." -f $Client.Name)
    }
    end {
        if ($PassThru.IsPresent) {
            $Client
        }
    }
}
