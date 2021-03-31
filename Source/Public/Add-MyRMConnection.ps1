function Add-MyRMConnection {
    [OutputType([string])]
    [CmdletBinding(SupportsShouldProcess = $true)]
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
        [string] $Client,

        [Parameter(
            HelpMessage = "Short description of the connection."
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
        $Connection = New-Object -TypeName Connection -ArgumentList @(
            $Name,
            $Hostname,
            $Port,
            $Inventory.GetClient($Client),
            $Description
        )
        if ($PSCmdlet.ShouldProcess(
                "Inventory file {0}" -f $Inventory.Path,
                "Add Connection {0}" -f $Connection.ToString()
            )
        ) {
            $Inventory.AddConnection($Connection)
            $Inventory.SaveFile()
            Write-Verbose -Message ("Connection `"{0}`" has been added to the inventory." -f $Name)
        }
    }
    end {
        if ($PassThru.IsPresent) {
            $Name
        }
    }
}
