function Set-MyRMInventoryPath {

    <#
    .SYNOPSIS
        Sets MyRemoteManager inventory path.
    .DESCRIPTION
        Sets the specific environment variable to overwrite default path to the MyRemoteManager inventory file.
    .PARAMETER Name
        Path to the inventory file.
        This path is set in the specific environment variable.
    .INPUTS
        None. You cannot pipe objects to Set-MyRMInventoryPath.
    .OUTPUTS
        System.Void. None.
    .EXAMPLE
        PS> Set-MyRMInventoryPath -Path C:\MyCustomInventory.json
    #>

    [OutputType([void])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(
            Position = 0,
            Mandatory = $true,
            HelpMessage = "Path to the inventory file."
        )]
        [string] $Path
    )
    begin {
        $EnvVar = [Inventory]::EnvVarName
    }
    process {
        if (
            $PSCmdlet.ShouldProcess(
                "User environment variable {0}" -f $EnvVar,
                "Set value {0}" -f $Path
            )
        ) {
            [System.Environment]::SetEnvironmentVariable(
                $EnvVar,
                $Path,
                [System.EnvironmentVariableTarget]::User
            )
        }
    }
    end {}
}
