Import-Module $PSScriptRoot/../conda

<#
 .SYNOPSIS
 Invokes an R script file in the R-Interpreter.

 .DESCRIPTION
 Enables the phylopipe conda environment and runs the provided script file through the R-Interpreter.

 .PARAMETER Path
 Path to the R script file

 .PARAMETER Args
 CLI arguments for the script file.
#>
function Invoke-R {
    param(
        [Parameter(Mandatory = $true)]
        [string] $Path,

        [Parameter(Mandatory = $false, ValueFromRemainingArguments)]
        [string[]] $Args
    )

    Set-CondaEnvironment
    Rscript $Path @Args
}