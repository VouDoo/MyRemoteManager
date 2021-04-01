function Get-MyRMConnection {
    [OutputType([PSCustomObject[]])]
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory = $false,
            HelpMessage = "Filter by client name."
        )]
        [ValidateNotNullOrEmpty()]
        [string] $Name = "*"
    )
    begin {
        $Inventory = New-Object -TypeName Inventory
        $Inventory.ReadFile()
    }
    process {
        $Connections = @()
        foreach ($c in $Inventory.Connections) {
            $Connections += [PSCustomObject] @{
                Name        = $c.Name
                Command     = "{0} {1}" -f $c.Executable, $c.TokenizedArgs
                DefaultPort = $c.DefaultPort
                Description = $c.Description
            }
        }
        $Connections = $Connections | Where-Object {
            $_.Name -like $Name
        } | Sort-Object -Property Name
    }
    end {
        $Connections
    }
}
