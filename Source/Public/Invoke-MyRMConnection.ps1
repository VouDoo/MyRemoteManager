function Invoke-MyRMConnection {
    [OutputType([void])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(
            Position = 0,
            Mandatory = $true,
            HelpMessage = "Name of the connection."
        )]
        [ValidateNotNullOrEmpty()]
        [ValidateSet( [ValidateConnectionName] )]
        [string] $Name
    )
    begin {
        $Inventory = New-Object -TypeName Inventory
        $Inventory.ReadFile()
    }
    process {
        $Connection = $Inventory.Connections | Where-Object { $_.Name -eq $Name }
        if ($PSCmdlet.ShouldProcess($Connection.ToString(), "Initiate connection")) {
            $Connection.Invoke()
        }
    }
    end {}
}
