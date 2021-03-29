function Add-MyRMConnection {
    [OutputType([string])]
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory = $true,
            HelpMessage = "Name of the connection."
        )]
        [ValidateNotNullOrEmpty()]
        [string] $Name,

        [Parameter(
            Mandatory = $true,
            HelpMessage = "Name of the remote host."
        )]
        [ValidateNotNullOrEmpty()]
        [string] $Hostname,

        [Parameter(
            Mandatory = $false,
            HelpMessage = "Port to connect to on the remote host."
        )]
        [UInt16] $Port,

        [Parameter(
            Mandatory = $true,
            HelpMessage = "Client to use to connect to the remote host."
        )]
        [ValidateNotNullOrEmpty()]
        [ValidateSet( [ValidateClientName] )]
        [string] $ClientName,

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
        $Inventory.AddConnection(
            (New-Object -TypeName Connection -ArgumentList @(
                    $Name,
                    $Hostname,
                    $Port,
                    $ClientName,
                    $Description
                )
            )
        )
        $Inventory.SaveFile()
        Write-Verbose -Message ("Connection `"{0}`" has been added to the inventory." -f $Name)
    }
    end {
        if ($PassThru.IsPresent) {
            $Name
        }
    }
}
