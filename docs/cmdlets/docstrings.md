# Cmdlets - Docstrings

Each Cmdlet docstring respects the [PowerShell Comment-based Help syntax](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_comment_based_help?view=powershell-7.1).

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
    .EXAMPLE
        PS> New-File -Path "C:\test.txt" -Force
        C:\test.txt
    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string] $Path,

        [switch] $Force
    )
    begin(
        # ...
    )
    process(
        # ...
    )
    end(
        $Path
    )
```