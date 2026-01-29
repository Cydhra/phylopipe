Import-Module $PSScriptRoot/../rscript

<#
 .SYNOPSIS
 Returns the absolute path to the script that invokes treestats in R.
#>
function Get-ScriptPath {
    Return [System.IO.Path]::Combine("$PSScriptRoot", "exec.R")
}

<#
 .SYNOPSIS
 Calculate the Mean Pairwise Distance (MPD) for all trees in the provided file.

 .PARAMETER TreeFile
 Newick file containing one or more trees.
#>
function Get-TreeStatMpd {
    [OutputType([double[]])]
    param(
        [Parameter(Mandatory)]
        [string] $TreeFile
    )

    Return (Invoke-R -Path (Get-ScriptPath) -- "mean_pair_dist" TreeFile)
}

<#
 .SYNOPSIS
 Calculate the Treeness statistic for all trees in the provided file.

 .PARAMETER TreeFile
 Newick file containing one or more trees.
#>
function Get-TreeStatTreeness {
    [OutputType([double[]])]
    param(
        [Parameter(Mandatory)]
        [string] $TreeFile
    )

    Return (Invoke-R -Path (Get-ScriptPath) -- "treeness" TreeFile)
}

<#
 .SYNOPSIS
 Calculate the number of Cherries for all trees in the provided file.

 .PARAMETER TreeFile
 Newick file containing one or more trees.
#>
function Get-TreeStatCherries {
    [OutputType([int[]])]
    param(
        [Parameter(Mandatory)]
        [string] $TreeFile
    )

    Return (Invoke-R -Path (Get-ScriptPath) -- "cherries" TreeFile)
}

<#
 .SYNOPSIS
 Calculate the number of Double Cherries for all trees in the provided file.

 .PARAMETER TreeFile
 Newick file containing one or more trees.
#>
function Get-TreeStatDoubleCherries {
    [OutputType([int[]])]
    param(
        [Parameter(Mandatory)]
        [string] $TreeFile
    )

    Return (Invoke-R -Path (Get-ScriptPath) -- "double_cherries" TreeFile)
}

<#
 .SYNOPSIS
 Calculate the Mean Branch Length for all trees in the provided file.

 .PARAMETER TreeFile
 Newick file containing one or more trees.
#>
function Get-TreeStatMeanBranchLength {
    [OutputType([double[]])]
    param(
        [Parameter(Mandatory)]
        [string] $TreeFile
    )

    Return (Invoke-R -Path (Get-ScriptPath) -- "mean_branch_length" TreeFile)
}

<#
 .SYNOPSIS
 Calculate the number of Imbalance Steps for all trees in the provided file.

 .PARAMETER TreeFile
 Newick file containing one or more trees.
#>
function Get-TreeStatImbalance {
    [OutputType([int[]])]
    param(
        [Parameter(Mandatory)]
        [string] $TreeFile
    )

    Return (Invoke-R -Path (Get-ScriptPath) -- "imbalance_steps" TreeFile)
}


<#
 .SYNOPSIS
 Calculate the maximum width for all trees in the provided file.

 .PARAMETER TreeFile
 Newick file containing one or more trees.
#>
function Get-TreeStatMaxWidth {
    [OutputType([int[]])]
    param(
        [Parameter(Mandatory)]
        [string] $TreeFile
    )

    Return (Invoke-R -Path (Get-ScriptPath) -- "max_width" TreeFile)
}