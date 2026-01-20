Import-Module $PSScriptRoot/../linux

function Get-IqTreePath {
    Return ConvertTo-LinuxPath -Path ([System.IO.Path]::Combine($PSScriptRoot, "..", "iqtree", "bin", "iqtree3"))
}

<#
 .SYNOPSIS
 Simulate a Multiple Sequence Alignment using alisim.

 .PARAMETER Tree
 The tree file to use as guidance when creating the simulated MSA.

 .PARAMETER Model
 The substitution model to use with IQ-Tree.

 .PARAMETER Prefix
 Output file prefix. All generated files will be named with this prefix, allowing a directory and name-prefix to
 be defined.
#>
function New-SimulatedMsa {
    param(
        [Parameter(Mandatory = $true)]
        [string] $Tree,

        [Parameter(Mandatory = $true)]
        [string] $Model,

        [Parameter(Mandatory = $true)]
        [string] $Prefix,

        [Parameter(Mandatory = $false)]
        [ValidateSet("BIN", "DNA", "AA", "NT2AA", "CODON", "MORPH", IgnoreCase = $false)]
        [string] $SequenceType,

        [Parameter(ParameterSetName="Indel")]
        [float] $InsertionRate = -1.0,

        [Parameter(ParameterSetName="Indel")]
        [float] $DeletionRate = -1.0,

        [Parameter(Mandatory = $false)]
        [int] $Seed
    )

    $CommandLine = @()

    $LinuxPrefix = ConvertTo-LinuxPath $Prefix
    $LinuxTree = ConvertTo-LinuxPath $Tree

    $CommandLine += "--alisim"
    $CommandLine += $LinuxPrefix
    $CommandLine += "-m"
    $CommandLine += $Model
    $CommandLine += "-t"
    $CommandLine += $LinuxTree

    if ($SequenceType -ne "") {
        $CommandLine += "--seqtype"
        $CommandLine += $SequenceType
    }

    if (($InsertionRate -gt 0) -and ($DeletionRate -gt 0)) {
        $CommandLine += "--indel"
        $CommandLine += "$InsertionRate,$DeletionRate"
    }

    Invoke-OnLinux -Path (Get-IqTreePath) $CommandLine
}