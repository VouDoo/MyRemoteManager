function Invoke-MyRMConnection {

    <#

    .SYNOPSIS
    Invokes MyRemoteManager connection.

    .DESCRIPTION
    Invokes MyRemoteManager connection which is defined in the inventory.

    .PARAMETER Name
    Name of the connection.

    .PARAMETER Scope
    Scope in which the connection will be invoked.

    .INPUTS
    None. You cannot pipe objects to Invoke-MyRMConnection.

    .OUTPUTS
    System.Void. None.

    .EXAMPLE
    PS> Invoke-MyRMConnection myconn

    .EXAMPLE
    PS> Invoke-MyRMConnection -Name myconn

    #>

    [OutputType([void])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(
            Position = 0,
            Mandatory = $true,
            HelpMessage = "Name of the connection."
        )]
        [ValidateNotNullOrEmpty()]
        [ValidateSet( [ValidateConnectionName] )]
        [string] $Name,

        [Parameter(
            HelpMessage = "Scope in which the connection will be invoked."
        )]
        [Scopes] $Scope
    )

    begin {
        $Inventory = New-Object -TypeName Inventory
        $Inventory.ReadFile()
    }

    process {
        $Connection = $Inventory.Connections | Where-Object -Property Name -EQ $Name
        if ($PSCmdlet.ShouldProcess($Connection.ToString(), "Initiate connection")) {
            if ($Connection.Client.RequiresUser) {
                $User = Read-Host -Prompt ("Username" -f $Connection.Hostname)
                $Arguments = $Connection.GenerateArgs($User)
            }
            else {
                $Arguments = $Connection.GenerateArgs()
            }

            $Process = @{
                FilePath     = $Connection.Client.Executable
                ArgumentList = $Arguments
            }
            switch ($Scope) {
                ([Scopes]::Console) {
                    $Command = "{0} {1}" -f $Process.FilePath, $Process.ArgumentList
                    Invoke-Expression -Command $Command
                }
                ([Scopes]::External) {
                    Start-Process @Process
                }
                ([Scopes]::Undefined) {
                    throw "Cannot invoke connection: Scope is undefined."
                }
                default {
                    throw "Cannot invoke connection: Scope is unknown."
                }
            }
        }
    }
}
