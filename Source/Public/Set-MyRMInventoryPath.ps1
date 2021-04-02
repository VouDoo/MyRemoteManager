function Set-MyRMInventoryPath {

    <#
    .SYNOPSIS
        Sets MyRemoteManager inventory path.
    .DESCRIPTION
        Sets the specific environment variable to overwrite default path to the MyRemoteManager inventory file.
    .PARAMETER Name
        Path to the inventory file.
        This path is set in a environment variable.
        Pass an empty string or null to reset to the default path.
    .PARAMETER Target
        Target scope where the environment variable will be saved.
    .INPUTS
        None. You cannot pipe objects to Set-MyRMInventoryPath.
    .OUTPUTS
        System.Void. None.
    .EXAMPLE
        PS> Set-MyRMInventoryPath C:\MyCustomInventory.json
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
        [AllowEmptyString()]
        [string] $Path,

        [Parameter(
            Mandatory = $false,
            HelpMessage = "Target scope of the environment variable."
        )]
        [ValidateSet("Process", "User")]
        [string] $Target = "User"
    )
    begin {
        $EnvVar = [Inventory]::EnvVariable
    }
    process {
        if (
            $PSCmdlet.ShouldProcess(
                ("{0} environment variable {1}" -f $Target, $EnvVar),
                "Set value {0}" -f $Path
            )
        ) {
            [System.Environment]::SetEnvironmentVariable(
                $EnvVar,
                $Path,
                [System.EnvironmentVariableTarget]::"$Target"
            )
            Write-Verbose -Message ("{0} environment variable `"{1}`" has been set to `"{2}`"." -f $Target, $EnvVar, $Path)
        }
    }
    end {}
}
