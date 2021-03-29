function Add-MyRMClient {
    [OutputType([string])]
    [CmdletBinding()]
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
        $Inventory = New-Object -TypeName Inventory
        $Inventory.ReadFile()
    }
    process {
        $Inventory.AddClient(
            (New-Object -TypeName Client -ArgumentList @(
                    $Name,
                    $Command,
                    $DefaultPort,
                    $Description
                )
            )
        )
        $Inventory.SaveFile()
        Write-Verbose -Message ("Client `"{0}`" has been added to the inventory." -f $Name)
    }
    end {
        if ($PassThru.IsPresent) {
            $Name
        }
    }
}
