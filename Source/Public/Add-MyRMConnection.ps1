function Add-MyRMConnection {

    <#
    .SYNOPSIS
        Adds MyRemoteManager connection.
    .DESCRIPTION
        Adds connection entry to the MyRemoteManager inventory file.
    .PARAMETER Name
        Name of the connection.
    .PARAMETER Hostname
        Name of the remote host.
    .PARAMETER Port
        Port to connect to on the remote host.
        If not set, it will use the default port of the client.
    .PARAMETER Client
        Name of the client.
    .PARAMETER Description
        Short description for the connection.
    .PARAMETER PassThru
        Indicates that the cmdlet sends items from the interactive window down the pipeline as input to other commands.
    .INPUTS
        None. You cannot pipe objects to Add-MyRMConnection.
    .OUTPUTS
        System.Void. None.
            or if PassThru is set,
        System.String. Add-MyRMConnection returns a string with the name of the added connection.
    .EXAMPLE
        PS> Add-MyRMConnection -Name myconn -Hostname myhost -Client SSH
    .EXAMPLE
        PS> Add-MyRMConnection -Name myconn -Hostname myhost -Port 2222 -Client SSH -Description "My connection"
    .EXAMPLE
        PS> Add-MyRMConnection -Name myconn -Hostname myhost -Client SSH -PassThru
        myconn
    #>

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
