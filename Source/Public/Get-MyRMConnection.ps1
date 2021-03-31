function Get-MyRMConnection {
    [OutputType([PSCustomObject[]])]
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory = $false,
            HelpMessage = "Filter by connection name."
        )]
        [ValidateNotNullOrEmpty()]
        [string] $Name = "*",

        [Parameter(
            Mandatory = $false,
            HelpMessage = "Filter by client name."
        )]
        [ValidateNotNullOrEmpty()]
        [string] $Client = "*"
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
                Hostname    = $c.Hostname
                Port        = if ($c.Port -eq 0) {
                    $c.Client.DefaultPort
                }
                else {
                    $c.Port
                }
                Client      = $c.Client.Name
                Description = $c.Description
            }
        }
    }
    end {
        $Connections | Where-Object {
            $_.Name -like $Name -and $_.Client -Like $Client
        } | Sort-Object -Property Name
    }
}
