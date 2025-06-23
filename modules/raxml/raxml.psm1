Import-Module $PSScriptRoot/../linux

function Get-RaxmlPath
{
    return ConvertTo-LinuxPath -Path ([System.IO.Path]::Combine($PSScriptRoot, "raxml-ng-2"))
}

<#
 .SYNOPSIS
 Calls the RAxML-ng tool on Linux using the provided arguments.

 .DESCRIPTION
 Calls the RAxML-ng tool using the provided arguments. The tool is invoked either in WSL or on native Linux.
 Parameters need not be provided in linux-compatible paths, instead, the command will convert all paths
 automatically. The parameters are largely defined exactly as raxml-ng does, and exact specifications can thus be
 found in the raxml-ng Wiki: https://github.com/amkozlov/raxml-ng/wiki/. Differences to the wiki are explained
 below.

 .PARAMETER Command
 The raxml-ng subcommand to execute.

 .PARAMETER Msa
 Path to the MSA file for the raxml command.

 .PARAMETER Model
 Model descriptor for the inference. This can be any descriptor except a partition file or a custom substitution
 matrix. Use "ModelFile" or "PartitionFile" for those.

 .PARAMETER ModelFile
 Model descriptor with a custom user-provided rate matrix. When using this, it is necessary to provide "ModelType"
 to specify the layout of the matrix. For example, a standard Amino Acid matrix requires the type to be set to
 "PROTGTR", as defined by raxml.

 .PARAMETER ModelType
 The matrix type for a user-provided rate matrix as defined by raxml-ng. This parameter must be provided only if
 "ModelFile" is set.

 .PARAMETER PartitionFile
 A file containing model descriptors for a partitioned analysis. Contains only the file name, no further model
 descriptor parts. Use "Model" for a single descriptor or "ModelFile" for a single custom rate matrix instead.

 .PARAMETER StateEncoding
 Custom MSA state encoding for the internal state model. Can accompany either a "Model" descriptor or a "ModelFile"
 path containing a custom rate matrix.

 .PARAMETER Tree
 Starting tree descriptor or file containing user-provided starting trees. The allowed descriptors are "pars{N}"
 and "rand{N}" as defined by raxml-ng.

 .PARAMETER Prefix
 Output file prefix. A path template which defines where the output files are stored. All directories of the path
 must exist.

 .PARAMETER BrLen
 Branch Length mode. Supports "scaled", "linked", and "unlinked" mode. Defaults to "scaled", just as raxml-ng.

 .PARAMETER TreeConstraint
 Optional path to a constraint file as defined by raxml-ng.

 .PARAMETER Outgroup
 Optional list of taxa used as an outgroup for tree rooting. The list is expected as a PowerShell list and will be
 converted to the format expected by raxml-ng automatically.

 .PARAMETER SiteWeights
 Optional path to a file containing per-site weights as defined by raxml-ng.

 .PARAMETER Threads
 Optional number of threads to use.

 .PARAMETER LhEpsilon
 Optional custom value for the `lh_epsilon` value of raxml-ng.

 .PARAMETER Redo
 Switch to force overwriting of existing results at the given prefix.
#>
function Invoke-Raxml
{
    param(
        [ValidateSet("all", "ancestral", "bootstrap", "bsconverge", "bsmsa", "check", "consense", "evaluate",
                "loglh", "parse", "rfdist", "search", "sitelh", "support", "start", "terrace", IgnoreCase = $true)]
        [Parameter(Mandatory = $true)]
        [string] $Command,

        [string] $Msa,

        [Parameter(Mandatory = $false, ParameterSetName="ModelDescriptor")]
        [string] $Model,

        [Parameter(Mandatory, ParameterSetName="ModelFile")]
        [string] $ModelFile,

        [Parameter(Mandatory, ParameterSetName="ModelFile")]
        [string] $ModelType,

        [Parameter(Mandatory, ParameterSetName="PartitionFile")]
        [string] $PartitionFile,

        [Parameter(Mandatory = $false, ParameterSetName="ModelDescriptor")]
        [Parameter(Mandatory = $false, ParameterSetName="ModelFile")]
        [string] $StateEncoding,

        [string] $Tree,

        [Parameter(Mandatory = $true)]
        [string] $Prefix,

        [ValidateSet("linked", "scaled", "unlinked", IgnoreCase = $true)]
        [Parameter(Mandatory = $false)]
        [string] $BrLen = "scaled",

        [Parameter(Mandatory = $false)]
        [string] $TreeConstraint,

        [Parameter(Mandatory = $false)]
        [string[]] $Outgroup,

        [Parameter(Mandatory = $false)]
        [string] $SiteWeights,

        [Parameter(Mandatory = $false)]
        [int] $Threads = -1,

        [Parameter(Mandatory = $false)]
        [int] $LhEpsilon = -1,

        [switch] $Redo
    )

    $CommandLine = @()
    $CommandLine += "--$($Command.ToLower())"

    if ($Msa -ne "") {
        $CommandLine += "--msa"
        $CommandLine += (ConvertTo-LinuxPath -Path $Msa)
    }

    if ($Model -ne "") {
        $CommandLine += "--model"
        $Param = $Model

        if ($StateEncoding -ne "") {
            $Param += "+M{$(ConvertTo-LinuxPath -Path $StateEncoding)}`""
        }

        $CommandLine += $Param
    } elseif ($ModelFile -ne "") {
        $CommandLine += "--model"
        $Param = "$ModelType{$(ConvertTo-LinuxPath -Path $ModelFile)}"

        if ($StateEncoding -ne "") {
            $Param += "+M{$(ConvertTo-LinuxPath -Path $StateEncoding)}`""
        }

        $CommandLine += $Param
    } elseif ($PartitionFile -ne "") {
        $CommandLine += "--model"
        $CommandLine += $(ConvertTo-LinuxPath -Path $PartitionFile)
    }

    if ($Tree -ne "") {
        $CommandLine += "--tree"
        if ($Tree.StartsWith("rand") -or $Tree.StartsWith("pars")) {
            $CommandLine += $Tree
        } else {
            $CommandLine += (ConvertTo-LinuxPath -Path $Tree)
        }
    }

    if ($BrLen.ToLower() -ne "scaled") {
        $CommandLine += "--brlen"
        $CommandLine += $BrLen.ToLower()
    }

    if ($TreeConstraint -ne "") {
        $CommandLine += "--tree-constraint"
        $CommandLine += (ConvertTo-LinuxPath -Path $TreeConstraint)
    }

    if ($null -ne $Outgroup -and ($Outgroup.Count -gt 0)) {
        $CommandLine += "--outgroup"
        $CommandLine += ($Outgroup -join ",")
    }

    if ($SiteWeights -ne "") {
        $CommandLine += "--site-weights"
        $CommandLine += (ConvertTo-LinuxPath -Path $SiteWeights)
    }

    $CommandLine += "--prefix"
    $CommandLine += (ConvertTo-LinuxPath -Path $Prefix)

    if ($Threads -gt 0) {
        $CommandLine += "--threads"
        $CommandLine += $Threads
    }

    if ($LhEpsilon -ge 0) {
        $CommandLine += "--lhepsilon"
        $CommandLine += $LhEpsilon
    }

    if ($Redo) {
        $CommandLine += "--redo"
    }

    Invoke-OnLinux -Path (Get-RaxmlPath) $CommandLine
}

Export-ModuleMember -Function Invoke-Raxml