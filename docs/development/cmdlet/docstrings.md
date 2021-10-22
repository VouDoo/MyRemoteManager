# Cmdlet - Docstrings

Every Cmdlet docstring must respect the [PowerShell Comment-based Help syntax](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_comment_based_help).

Example:

```powershell
function New-File {

    <#

    .SYNOPSIS
    Creates file.

    .DESCRIPTION
    Creates file to a user-defined path.

    .PARAMETER Path
    Defines file path.

    .PARAMETER Force
    Forces the file creation if it already exists.

    .INPUTS
    None. You cannot pipe objects to New-File.

    .OUTPUTS
    System.String. New-File returns a string with the file path.

    .EXAMPLE
    PS> New-File -Path "C:\test.txt"
    C:\test.txt

    Creates a file

    .EXAMPLE
    PS> New-File -Path "C:\test.txt" -Force
    C:\test.txt

    Creates a file (force)

    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $Path,

        [switch] $Force
    )

    begin {
        # ...
    }

    process {
        # ...
    }

    end {
        $Path
    }
}
```
