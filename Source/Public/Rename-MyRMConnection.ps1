function Rename-MyRMConnection {

    <#

    .SYNOPSIS
    Renames MyRemoteManager connection.

    .DESCRIPTION
    Renames connection entry from the MyRemoteManager inventory file.

    .PARAMETER Name
    Name of the connection to rename.

    .PARAMETER NewName
    New name for the connection.

    .INPUTS
    None. You cannot pipe objects to Rename-MyRMConnection.

    .OUTPUTS
    System.Void. None.

    .EXAMPLE
    PS> Rename-MyRMConnection -Name my_old_conn -NewName my_new_conn

    #>

    [OutputType([void])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(
            Position = 0,
            Mandatory = $true,
            HelpMessage = "Name of the connection to rename."
        )]
        [ValidateSet([ValidateSetConnectionName])]
        [ValidateConnectionName()]
        [string] $Name,

        [Parameter(
            Position = 1,
            Mandatory = $true,
            HelpMessage = "New name for the connection."
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
                ("Rename Connection {0} to {1}" -f $Name, $NewName)
            )
        ) {
            $Inventory.RenameConnection($Name, $NewName)

            try {
                $Inventory.SaveFile()
                Write-Verbose -Message (
                    "Connection `"{0}`" has been renamed `"{1}`" in the inventory." -f $Name, $NewName
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
