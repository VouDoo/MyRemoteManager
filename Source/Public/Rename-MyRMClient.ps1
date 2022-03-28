function Rename-MyRMClient {

    <#

    .SYNOPSIS
    Renames MyRemoteManager client.

    .DESCRIPTION
    Renames client entry from the MyRemoteManager inventory file.

    .PARAMETER Name
    Name of the client to rename.

    .PARAMETER NewName
    New name for the client.

    .INPUTS
    None. You cannot pipe objects to Rename-MyRMClient.

    .OUTPUTS
    System.Void. None.

    .EXAMPLE
    PS> Rename-MyRMClient -Name my_old_client -NewName my_new_client

    #>

    [OutputType([void])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(
            Position = 0,
            Mandatory = $true,
            HelpMessage = "Name of the client to rename."
        )]
        [ValidateSet([ValidateSetClientName])]
        [ValidateClientName()]
        [string] $Name,

        [Parameter(
            Position = 1,
            Mandatory = $true,
            HelpMessage = "New name for the client."
        )]
        [ValidateNotNullOrEmpty()]
        [string] $NewName
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
                ("Rename Client {0} to {1}" -f $Name, $NewName)
            )
        ) {
            $Inventory.RenameClient($Name, $NewName)

            try {
                $Inventory.SaveFile()
                Write-Verbose -Message (
                    "Client `"{0}`" has been renamed `"{1}`" in the inventory." -f $Name, $NewName
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
