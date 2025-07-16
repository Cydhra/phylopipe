Import-Module $PSScriptRoot/../linux

function Get-Muscle {
    return ConvertTo-LinuxPath -Path ([System.IO.Path]::Combine($PSScriptRoot, "bin", "muscle"))
}

<#
 .SYNOPSIS
 Creates an alignment from a Multi-FASTA or similar sequence file.

 .DESCRIPTION
 Uses the muscle default parameters to create a single alignment from the given sequence file. The sequence file
 is assumed to be a Multi-FASTA file or another format supported by muscle. The file type will be automatically
 determined.

 .PARAMETER Sequences
 Path of the file containing all sequences to be aligned.

 .PARAMETER Output
 Path of the output file. The output file will be created even if muscle fails to create an alignment, so make sure
 you don't use the file's existence as a success indicator.

 .PARAMETER Super5
 Use the Super5 algorithm instead of the slower PPP algorithm. This is recommended for large alignments with more
 than roughly 100 sequences.

 .PARAMETER PerturbSeed
 If specified, uses a custom seed for HMM perturbations.

 .PARAMETER GuideTreePerm
 If specified, forces a specific guide tree permutation. Defaults to "all".

 .PARAMETER ConsistencyIterations
 Number of consistency iterations (defaults to 2).

 .PARAMETER RefinementIterations
 Number of refinement iterations (defaults to 100).

 .PARAMETER Alphabet
 Change the input alphabet of the sequences. By default, muscle automatically detects the alphabet.

 .PARAMETER Threads
 How many threads muscle uses. By default, muscle uses all available cores but at most 20.
#>
function New-Alignment {
    param (
        [Parameter(Mandatory = $true)]
        [string] $Sequences,

        [Parameter(Mandatory = $true)]
        [string] $Output,

        [switch] $Super5,

        [Parameter(Mandatory = $false)]
        [int] $PerturbSeed = 0,

        [ValidateSet("none", "abc", "acb", "bca", IgnoreCase = $false)]
        [Parameter(Mandatory = $false)]
        [string] $GuideTreePerm = "none",

        [Parameter(Mandatory = $false)]
        [int] $ConsistencyIterations = 2,

        [Parameter(Mandatory = $false)]
        [int] $RefinementIterations = 100,

        [ValidateSet("auto", "nt", "amino", IgnoreCase = $true)]
        [Parameter(Mandatory = $false)]
        [string] $Alphabet = "auto",

        [Parameter(Mandatory = $false)]
        [int] $Threads = 0
    )

    $CommandLine = @()

    $Algorithm = "-align"
    if ($Super5) {
        $Algorithm = "-super5"
    }
    $CommandLine += $Algorithm
    $CommandLine += (ConvertTo-LinuxPath -Path $Sequences)
    $CommandLine += "-output"
    $CommandLine += (ConvertTo-LinuxPath -Path $Output)

    if ($PerturbSeed -ne 0) {
        $CommandLine += "-perturb"
        $CommandLine += $PerturbSeed
    }

    if ($GuideTreePerm -ne "none") {
        $CommandLine += "-perm"
        $CommandLine += $GuideTreePerm
    }

    if ($ConsistencyIterations -ne 2) {
        $CommandLine += "-consiters"
        $CommandLine += $ConsistencyIterations
    }

    if ($RefinementIterations -ne 100) {
        $CommandLine += "-refineiters"
        $CommandLine += $RefinementIterations
    }

    if ($Alphabet -ne "auto") {
        $CommandLine += "-$($Alphabet.ToLower())"
    }

    if ($Threads -gt 0) {
        $CommandLine += "-threads"
        $CommandLine += $Threads
    }

    Invoke-OnLinux -Path (Get-Muscle) $CommandLine
}

<#
 .SYNOPSIS
 Creates an alignment ensemble from a Multi-FASTA or similar sequence file.

 .DESCRIPTION
 Creates an alignment ensemble using the provided parameters. By default it uses the PPP algorithm with the
 "stratified" ensemble type to generate 16 alignments. The type and number of replicates can be changed.
 Alternatively, the algorithm can be changed to Super5, in which case exactly 4 replicates are being generated.
 Larger alignments with Super5 are possible using by manually setting different `-PermSeed` parameters.
 The sequence file assumed to be a Multi-FASTA file or another format supported by muscle. The file type will be
 automatically determined.

 .PARAMETER Sequences
 Path of the file containing all sequences to be aligned.

 .PARAMETER Output
 Path of the output file. The output file will be created even if muscle fails to create an ensemble, so make sure
 you don't use the file's existence as a success indicator. The output is an ensemble fasta file.

 .PARAMETER Super5
 Use the super5 algorithm of muscle instead of PPP.

 .PARAMETER EnsembleType
 Which type of ensemble to generate. Defaults "stratified" for one replicate per guide tree permutation. The number
 of replicates is `4 * N` where `N` is 4 by default and can be changed with `-Replicates`. The other option is
 "diversified" which generates replicates using HMM perturbations. If `-Replicates` is not given for "diversified",
 it defaults to 100.

 .PARAMETER Replicates
 How many ensemble replicates to generate. If `-EnsembleType` is "stratified" (default), the number of replicates
 is multiplied with 4. If `-Super5` is set, this parameter cannot be used. Instead, `-perm all` is set, so that
 4 replicates are generated for each guide tree permutation.

  .PARAMETER PerturbSeed
 If specified, uses a custom seed for HMM perturbations. This can be used to generate diversified ensembles using
 the Super5 algorithm.

 .PARAMETER ConsistencyIterations
 Number of consistency iterations (defaults to 2).

 .PARAMETER RefinementIterations
 Number of refinement iterations (defaults to 100).

 .PARAMETER Alphabet
 Change the input alphabet of the sequences. By default, muscle automatically detects the alphabet.

 .PARAMETER Threads
 How many threads muscle uses. By default, muscle uses all available cores but at most 20.
#>
function New-Ensemble {
    [CmdletBinding(DefaultParameterSetName="ppp")]
    param (
        [Parameter(Mandatory = $true)]
        [string] $Sequences,

        [Parameter(Mandatory = $true)]
        [string] $Output,

        [Parameter(Mandatory = $true, ParameterSetName = "super5")]
        [switch] $Super5,

        [Parameter(Mandatory = $false, ParameterSetName = "super5")]
        [int] $PerturbSeed = 0,

        [ValidateSet("stratified", "diversified", IgnoreCase = $false)]
        [Parameter(Mandatory = $false, ParameterSetName = "ppp")]
        [string] $EnsembleType = "stratified",

        [Parameter(Mandatory = $false, ParameterSetName = "ppp")]
        [int] $Replicates = 0,

        [Parameter(Mandatory = $false)]
        [int] $ConsistencyIterations = 2,

        [Parameter(Mandatory = $false)]
        [int] $RefinementIterations = 100,

        [ValidateSet("auto", "nt", "amino", IgnoreCase = $true)]
        [Parameter(Mandatory = $false)]
        [string] $Alphabet = "auto",

        [Parameter(Mandatory = $false)]
        [int] $Threads = 0
    )

    if (-not $Super5) {
        $PPP = $true
    }

    $CommandLine = @()

    $Algorithm = "-align"
    if ($Super5) {
        $Algorithm = "-super5"
    }
    $CommandLine += $Algorithm
    $CommandLine += $(ConvertTo-LinuxPath -Path $Sequences)

    if ($PPP) {
        $CommandLine += "-$EnsembleType"

        if ($Replicates -gt 0) {
            $CommandLine += "-replicates"
            $CommandLine += $Replicates
        }
    }

    if ($PerturbSeed -ne 0) {
        $CommandLine += "-perturb"
        $CommandLine += $PerturbSeed
    }

    $CommandLine += "-perm"
    $CommandLine += "all"

    $CommandLine += "-output"
    $CommandLine += $(ConvertTo-LinuxPath -Path $Output)

    Invoke-OnLinux -Path (Get-Muscle) $CommandLine
}

<#
 .SYNOPSIS
 Calculates the dispersion in an ensemble fasta file.

 .DESCRIPTION
 Uses the muscle default parameters to create an ensemble of 16 alignments from the given sequence file. The
 sequence file assumed to be a Multi-FASTA file or another format supported by muscle. The file type will be
 automatically determined.

 .PARAMETER Sequences
 Path of the file containing all sequences to be aligned.

 .PARAMETER Output
 Path of the output file. The output file will be created even if muscle fails to create an ensemble, so make sure
 you don't use the file's existence as a success indicator.
#>
function Get-Dispersion {
    param (
        [Parameter(Mandatory = $true)]
        [string] $Ensemble
    )

    Invoke-OnLinux -Path (Get-Muscle) "-disperse" "$(ConvertTo-LinuxPath -Path $Ensemble)"
}

Export-ModuleMember -Function New-Alignment
Export-ModuleMember -Function New-Ensemble
Export-ModuleMember -Function Get-Dispersion