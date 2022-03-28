function Remove-MyRMClient {

    <#

    .SYNOPSIS
    Removes MyRemoteManager client.

    .DESCRIPTION
    Removes client entry from the MyRemoteManager inventory file.

    .PARAMETER Name
    Name of the client.

    .INPUTS
    None. You cannot pipe objects to Remove-MyRMClient.

    .OUTPUTS
    System.Void. None.

    .EXAMPLE
    PS> Remove-MyRMClient SSH

    .EXAMPLE
    PS> Remove-MyRMClient -Name SSH

    #>

    [OutputType([void])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(
            Position = 0,
            Mandatory = $true,
            HelpMessage = "Name of the client."
        )]
        [ValidateSet([ValidateSetClientName])]
        [ValidateClientName()]
        [string] $Name
    )

    begin {
        $ErrorActionPreference = "Stop"
    }

    process {
        try {
            $Inventory = Import-Inventory
        }
        catch {
            Write-Error -Message (
                "Cannot open inventory: {0}" -f $_.Exception.Message
            )
        }

        if ($PSCmdlet.ShouldProcess(
                "Inventory file {0}" -f $Inventory.Path,
                "Remove Client {0}" -f $Name
            )
        ) {
            $Inventory.RemoveClient($Name)

            try {
                $Inventory.SaveFile()
                Write-Verbose -Message (
                    "Client `"{0}`" has been removed from the inventory." -f $Name
                )
            }
            catch {
                Write-Error -Message (
                    "Cannot save inventory: {0}" -f $_.Exception.Message
                )
            }
        }
    }
}
