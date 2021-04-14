class Item {
    # Name
    [ValidateLength(1, 50)]
    [ValidatePattern("^([a-zA-Z0-9_\-]+)$")]
    [string] $Name
    # Description
    [string] $Description

    [hashtable] Splat() {
        $Hashtable = @{}
        foreach ($p in $this.PSObject.Properties) {
            $this.PSObject.Properties | ForEach-Object -Process {
                $Hashtable[$p.Name] = $p.Value
            }
        }
        return $Hashtable
    }
}
