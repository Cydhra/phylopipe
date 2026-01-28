Import-Module $PSScriptRoot/../linux

function Get-CondaHook {
     Return "$PSScriptRoot/miniconda3/shell/condabin/conda-hook.ps1"
}

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
        [Parameter(Mandatory = $true, Position=0)]
        [string[]] $Command,

        [Parameter(Mandatory = $false, ValueFromRemainingArguments)]
        [string[]] $Args
    )

    $CondaHook = Get-CondaHook
    . $CondaHook
    conda activate phylopipe

    & $Command @Args
}