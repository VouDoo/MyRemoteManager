function Get-MyRMClient {
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
        $Clients = @()
        foreach ($c in $Inventory.Clients) {
            $Clients += [PSCustomObject] @{
                Name        = $c.Name
                Command     = "{0} {1}" -f $c.Executable, $c.TokenizedArgs
                DefaultPort = $c.DefaultPort
                Description = $c.Description
            }
        }
        $Clients = $Clients | Where-Object {
            $_.Name -like $Name
        } | Sort-Object -Property Name
    }
    end {
        $Clients
    }
}
