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
            HelpMessage = "Path to the executable to run as client."
        )]
        [ValidateNotNullOrEmpty()]
        [string] $Executable,

        [Parameter(
            Mandatory = $true,
            HelpMessage = "Arguments as a tokenized string. Please, read the documentation to get the list of tokens."
        )]
        [ValidateNotNullOrEmpty()]
        [string] $Arguments,

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
                    $Executable,
                    $Arguments,
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
