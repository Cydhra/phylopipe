Import-Module $PSScriptRoot/../linux

<#
.SYNOPSIS
Execute a provided command line in the conda environment.

.DESCRIPTION
Runs the provided command in the installed conda environment. This does not have to be a conda command, and
consequently "conda" still needs to be part of the command if it is a conda command.

.PARAMETER Path
Linux-compatible path to the executable.

.PARAMETER CommandLine
The full command line provided to the executable. Beware that powershell may interpret some arguments differently
than linux shells, so they have to be escaped to be properly passed by the linux shell.
#>
function Invoke-InConda {
    param(
        [Parameter(Mandatory = $false, ValueFromRemainingArguments)]
        [string[]] $ManualArgs
    )

    Invoke-OnLinux source ./miniconda3/bin/activate "&&" $ManualArgs
}