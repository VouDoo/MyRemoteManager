function New-MyRMInventory {

    <#

    .SYNOPSIS
    Creates MyRemoteManager inventory file.

    .DESCRIPTION
    Creates a new inventory file where MyRemoteManager saves items.

    .PARAMETER NoDefaultClients
    Does not add defaults clients to the new inventory.

    .PARAMETER Force
    Overwrites existing inventory file.

    .PARAMETER PassThru
    Indicates that the cmdlet sends items from the interactive window down the pipeline as input to other commands.

    .INPUTS
    None. You cannot pipe objects to New-MyRMInventory.

    .OUTPUTS
    System.Void. None.
        or if PassThru is set,
    System.String. New-MyRMInventory returns a string with the path to the created inventory.

    .EXAMPLE
    PS> New-MyRMInventory

    .EXAMPLE
    PS> New-MyRMInventory -NoDefaultClients

    .EXAMPLE
    PS> New-MyRMInventory -Force

    .EXAMPLE
    PS> New-MyRMInventory -PassThru
    C:\Users\MyUsername\MyRemoteManager.json

    .EXAMPLE
    PS> New-MyRMInventory -NoDefaultClients -Force -PassThru
    C:\Users\MyUsername\MyRemoteManager.json

    #>

    [OutputType([void])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(
            HelpMessage = "Do not add defaults clients."
        )]
        [switch] $NoDefaultClients,

        [Parameter(
            HelpMessage = "Overwrite existing inventory file."
        )]
        [switch] $Force,

        [Parameter(
            HelpMessage = "Indicates that the cmdlet sends items from the interactive window down the pipeline as input to other commands."
        )]
        [switch] $PassThru
    )

    begin {
        $Inventory = New-Object -TypeName Inventory
    }

    process {
        if ((Test-Path -Path $Inventory.Path -PathType Leaf) -and -not ($Force.IsPresent)) {
            Write-Error -ErrorAction Stop -Exception (
                [System.IO.IOException] "Inventory file already exists. Use `"-Force`" to overwrite it."
            )
        }
        if ($PSCmdlet.ShouldProcess($Inventory.Path, "Create inventory file")) {
            if (-not $NoDefaultClients.IsPresent) {
                $Inventory.AddClient(
                    (New-Object -TypeName Client -ArgumentList @(
                            "OpenSSH",
                            "C:\Windows\System32\OpenSSH\ssh.exe",
                            "-l <user> -p <port> <host>",
                            22,
                            "OpenSSH (Microsoft Windows feature)"
                        )
                    )
                )
                $Inventory.AddClient(
                    (New-Object -TypeName Client -ArgumentList @(
                            "PuTTY_SSH",
                            "putty.exe",
                            "-ssh -P <port> <user>@<host>",
                            22,
                            "PuTTY using SSH protocol"
                        )
                    )
                )
                $Inventory.AddClient(
                    (New-Object -TypeName Client -ArgumentList @(
                            "RD",
                            "C:\Windows\System32\mstsc.exe",
                            "/v:<host>:<port> /fullscreen",
                            3389,
                            "Microsoft Remote Desktop"
                        )
                    )
                )
            }
            $Inventory.SaveFile()
            Write-Verbose -Message ("Inventory file has been created: {0}" -f $Inventory.Path)
        }
    }

    end {
        if ($PassThru.IsPresent) {
            Resolve-Path $Inventory.Path | Select-Object -ExpandProperty Path
        }
    }
}
