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

    .PARAMETER DefaultClient
    Name of the default client.

    .PARAMETER DefaultUser
    Default client to use to connect to the remote host.

    .PARAMETER Description
    Short description for the connection.

    .INPUTS
    None. You cannot pipe objects to Add-MyRMConnection.

    .OUTPUTS
    System.Void. None.

    .EXAMPLE
    PS> Add-MyRMConnection -Name myconn -Hostname myhost -DefaultClient SSH

    .EXAMPLE
    PS> Add-MyRMConnection -Name myrdpconn -Hostname myhost -DefaultClient RDP -Description "My RDP connection"

    .EXAMPLE
    PS> Add-MyRMConnection -Name mysshconn -Hostname myhost -Port 2222 -DefaultClient SSH -DefaultUser myuser -Description "My SSH connection"

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
            HelpMessage = "Port to connect to on the remote host."
        )]
        [UInt16] $Port,

        [Parameter(
            Mandatory = $true,
            HelpMessage = "Default client to use to connect to the remote host."
        )]
        [ValidateSet([ValidateSetClientName])]
        [ValidateClientName()]
        [string] $DefaultClient,

        [Parameter(
            HelpMessage = "Default user to use to connect to the remote host."
        )]
        [string] $DefaultUser,

        [Parameter(
            HelpMessage = "Short description of the connection."
        )]
        [string] $Description
    )

    begin {
        $Inventory = Import-Inventory
    }

    process {
        $Connection = New-Object -TypeName Connection -ArgumentList @(
            $Name,
            $Hostname,
            $Port,
            $DefaultClient,
            $DefaultUser,
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
}
