function Invoke-MyRMConnection {

    <#

    .SYNOPSIS
    Invokes MyRemoteManager connection.

    .DESCRIPTION
    Invokes MyRemoteManager connection which is defined in the inventory.

    .PARAMETER Name
    Name of the connection.

    .PARAMETER Client
    Name of the client to use to initiate the connection.

    .PARAMETER User
    Name of the user to connect with.

    .PARAMETER Scope
    Scope in which the connection will be invoked.

    .INPUTS
    None. You cannot pipe objects to Invoke-MyRMConnection.

    .OUTPUTS
    System.Void. None.

    .EXAMPLE
    PS> Invoke-MyRMConnection myconn

    .EXAMPLE
    PS> Invoke-MyRMConnection -Name myconn -Client SSH -User root -Scope Console

    #>

    [OutputType([void])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(
            Position = 0,
            Mandatory = $true,
            HelpMessage = "Name of the connection."
        )]
        [ValidateSet([ValidateSetConnectionName])]
        [ValidateConnectionName()]
        [string] $Name,

        [Parameter(
            HelpMessage = "Name of the client to use to initiate the connection."
        )]
        [ValidateSet([ValidateSetClientName])]
        [ValidateClientName()]
        [Alias("c")]
        [string] $Client,

        [Parameter(
            HelpMessage = "Name of the user to connect with."
        )]
        [Alias("u")]
        [string] $User,

        [Parameter(
            HelpMessage = "Scope in which the connection will be invoked."
        )]
        [Alias("x")]
        [Scopes] $Scope
    )

    begin {
        $Inventory = Import-Inventory
    }

    process {
        $Invocation = @{}

        $Invocation.Connection = $Inventory.GetConnection($Name)
        Write-Debug -Message ("Invoke connection {0}" -f $Invocation.Connection.ToString())

        $Invocation.Client = if ($Client) {
            $Inventory.GetClient($Client)
        }
        else {
            $Inventory.GetClient($Invocation.Connection.DefaultClient)
        }
        Write-Debug -Message ("Invoke connection with client {0}" -f $Invocation.Client.ToString())

        $Invocation.Port = if ($Invocation.Connection.IsDefaultPort()) {
            $Invocation.Client.DefaultPort
        }
        else {
            $Invocation.Connection.Port
        }
        Write-Debug -Message ("Invoke connection on port {0}" -f $Invocation.Port)

        $Invocation.Executable = $Invocation.Client.Executable
        $Invocation.Arguments = if ($Invocation.Client.RequiresUser) {
            if ($User) {
                $Invocation.Client.GenerateArgs(
                    $Invocation.Connection.Hostname,
                    $Invocation.Port,
                    $User
                )
            }
            elseif ($Invocation.Connection.DefaultUser) {
                $Invocation.Client.GenerateArgs(
                    $Invocation.Connection.Hostname,
                    $Invocation.Port,
                    $Invocation.Connection.DefaultUser
                )
            }
            else {
                Write-Error -Message "Cannot invoke connection: A user must be specified." -ErrorAction Stop
            }
        }
        else {
            $Invocation.Client.GenerateArgs(
                $Invocation.Connection.Hostname,
                $Invocation.Port
            )
        }
        $Invocation.Command = "{0} {1}" -f $Invocation.Executable, $Invocation.Arguments
        Write-Debug -Message ("Invoke connection with command `"{0}`"" -f $Invocation.Command)

        $Invocation.Scope = if ($Scope) {
            $Scope
        }
        else {
            $Invocation.Client.DefaultScope
        }
        Write-Debug -Message ("Invoke connection in scope `"{0}`"" -f $Invocation.Scope)

        if ($PSCmdlet.ShouldProcess($Invocation.Connection.ToString(), "Initiate connection")) {
            switch ($Invocation.Scope) {
                ([Scopes]::Console) {
                    Invoke-Expression -Command $Invocation.Command
                }
                ([Scopes]::External) {
                    Start-Process -FilePath $Invocation.Executable -ArgumentList $Invocation.Arguments
                }
                ([Scopes]::Undefined) {
                    Write-Error -Message "Cannot invoke connection: Scope is undefined."
                }
                default {
                    Write-Error -Message "Cannot invoke connection: Scope is unknown."
                }
            }
        }
    }
}
