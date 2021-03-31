function New-MyRMInventory {
    [OutputType([string])]
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
        if (-not $NoDefaultClients.IsPresent) {
            $Inventory.AddClient(
                (New-Object -TypeName Client -ArgumentList @(
                        "SSH",
                        "C:\Windows\System32\OpenSSH\ssh.exe",
                        "-l <user> -p <port> <host>",
                        22,
                        "OpenSSH from Microsoft Windows feature"
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
        if ($PSCmdlet.ShouldProcess("Target", "Operation")) {
            $Inventory.SaveFile()
            Write-Verbose -Message ("Inventory file has been created: {0}" -f $Inventory.Path)
        }
        else {
            Write-Verbose -Message ("Create inventory file to `"{0}`"." -f $Inventory.Path)
        }
    }
    end {
        if ($PassThru.IsPresent) {
            Resolve-Path $Inventory.Path | Select-Object -ExpandProperty Path
        }
    }
}
