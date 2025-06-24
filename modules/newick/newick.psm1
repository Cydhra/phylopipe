Import-Module $PSScriptRoot/../linux

function Get-NewickPath {
    return ConvertTo-LinuxPath -Path ([System.IO.Path]::Combine($PSScriptRoot, "newick"))
}

<#
 .SYNOPSIS
 Call Newick to obtain the RF distance between two trees given as newick files.

 .DESCRIPTION
 Calls Newick with two paths and returns and array of three values: The absolute RF distance, the maximum possible
 RF distance, and the relative RF distance between both trees. The paths may be native paths and will automatically
 converted to Linux-compatible paths. If the "File" parameter is set, it returns a triple of results for each pair
 of trees in the file, in upper-triangle matrix row-major order.

 .PARAMETER Tree1
 Path to a newick file containing one tree.

 .PARAMETER Tree2
 Path to a newick file containing one tree with the same number of taxa.

 .PARAMETER File
 Path to a newick file containing many trees, of which Newick calculates the pairwise RF distances.
#>
function Get-RFDistance {
    param(
        [Parameter(Mandatory, ParameterSetName="TwoTrees")]
        [string] $Tree1,

        [Parameter(Mandatory, ParameterSetName="TwoTrees")]
        [string] $Tree2,

        [Parameter(Mandatory, ParameterSetName="ManyTrees")]
        [string] $File
    )
    $all_outputs = $null

    if ($Tree1 -ne "") {
        $t1 = ConvertTo-LinuxPath -Path $Tree1
        $t2 = ConvertTo-LinuxPath -Path $Tree2

        $all_outputs = ((Invoke-OnLinux -Path (Get-NewickPath) -rofo $t1 -tree2 $t2) 2>&1) | ?{ $_ -is [System.Management.Automation.ErrorRecord] }
    } else {
        $trees = ConvertTo-LinuxPath -Path $File
        $all_outputs = ((((Invoke-OnLinux -Path (Get-NewickPath) -rofos $trees) 2>&1) | ?{ $_ -is [System.Management.Automation.ErrorRecord] }) -split "`n") | select -Skip 1
    }

    $all_outputs | % {
        if ($_ -match "^RF = (\d+) / (\d+), (\-?\d+(\.\d+)?)") {
            [PSCustomObject]@{
                RF = $Matches[1]
                Max = $Matches[2]
                Relative = $Matches[3]
            }
        }
    }
}

