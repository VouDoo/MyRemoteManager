function Add-MyRMClient {

    <#
    .SYNOPSIS
        Adds MyRemoteManager client.
    .DESCRIPTION
        Adds client entry to the MyRemoteManager inventory file.
    .PARAMETER Name
        Name of the client.
    .PARAMETER Executable
        Path to the executable program that the client uses.
    .PARAMETER Arguments
        String of Arguments to pass to the executable.
        The string should contain the required tokens.
        Please read the documentation of MyRemoteManager.
    .PARAMETER DefaultPort
        Network port to use if the connection has no defined port.
    .PARAMETER Description
        Short description for the client.
    .PARAMETER PassThru
        Indicates that the cmdlet sends items from the interactive window down the pipeline as input to other commands.
    .INPUTS
        None. You cannot pipe objects to Add-MyRMClient.
    .OUTPUTS
        System.Void. None.
            or if PassThru is set,
        System.String. Add-MyRMClient returns a string with the name of the added client.
    .EXAMPLE
        PS> Add-MyRMClient -Name SSH -Executable "ssh.exe" -Arguments "-l <user> -p <port> <host>" -DefaultPort 22
    .EXAMPLE
        PS> Add-MyRMClient -Name MyCustomClient -Executable "client.exe" -Arguments "--hostname <host> --port <port>" -DefaultPort 666 -Description "My custom client"
    .EXAMPLE
        PS> Add-MyRMClient -Name SSH -Executable "ssh.exe" -Arguments "-l <user> -p <port> <host>" -DefaultPort 22 -PassThru
        SSH
    #>

    [OutputType([void])]
    [CmdletBinding(SupportsShouldProcess = $true)]
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
        $Client = New-Object -TypeName Client -ArgumentList @(
            $Name,
            $Executable,
            $Arguments,
            $DefaultPort,
            $Description
        )
        if (
            $PSCmdlet.ShouldProcess(
                "Inventory file {0}" -f $Inventory.Path,
                "Add Client {0}" -f $Client.ToString()
            )
        ) {
            $Inventory.AddClient($Client)
            $Inventory.SaveFile()
            Write-Verbose -Message ("Client `"{0}`" has been added to the inventory." -f $Name)
        }
    }
    end {
        if ($PassThru.IsPresent) {
            $Name
        }
    }
}
