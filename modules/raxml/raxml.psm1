Import-Module $PSScriptRoot/../linux

function Get-RaxmlPath
{
    return ConvertTo-LinuxPath -Path ([System.IO.Path]::Combine($PSScriptRoot, "raxml-ng-2"))
}

function Invoke-Raxml
{
    param(
        [ValidateSet("all", "ancestral", "bootstrap", "bsconverge", "bsmsa", "check", "consense", "evaluate",
                "loglh", "parse", "rfdist", "search", "sitelh", "support", "start", "terrace", IgnoreCase = $true)]
        [Parameter(Mandatory = $true)]
        [string] $Command,

        [string] $msa,

        [string] $model,

        [Parameter(Mandatory = $false)]
        [string] $state_encoding,

        [string] $tree,

        [Parameter(Mandatory = $true)]
        [string] $prefix,

        [ValidateSet("linked", "scaled", "unlinked", IgnoreCase = $true)]
        [Parameter(Mandatory = $false)]
        [string] $brlen = "scaled",

        [Parameter(Mandatory = $false)]
        [string] $tree_constraint,

        [Parameter(Mandatory = $false)]
        [string[]] $outgroup,

        [Parameter(Mandatory = $false)]
        [string] $site_weights,

        [Parameter(Mandatory = $false)]
        [int] $threads = -1,

        [Parameter(Mandatory = $false)]
        [int] $lh_epsilon = -1,

        [switch] $redo
    )

    $CommandLine = @()
    $CommandLine += "--$($Command.ToLower())"

    if ($msa -ne "") {
        $CommandLine += "--msa"
        $CommandLine += (ConvertTo-LinuxPath -Path $msa)
    }

    if ($model -ne "") {
        $CommandLine += "--model"
        $Param = $model

        if ($state_encoding -ne "") {
            $Param += "+M{$(ConvertTo-LinuxPath -Path $state_encoding)}`""
        }

        $CommandLine += $Param
    }

    if ($tree -ne "") {
        $CommandLine += "--tree"
        if ($tree.StartsWith("rand") -or $tree.StartsWith("pars")) {
            $CommandLine += $tree
        } else {
            $CommandLine += (ConvertTo-LinuxPath -Path $tree)
        }
    }

    if ($brlen.ToLower() -ne "scaled") {
        $CommandLine += "--brlen"
        $CommandLine += $brlen.ToLower()
    }

    if ($tree_constraint -ne "") {
        $CommandLine += "--tree-constraint"
        $CommandLine += (ConvertTo-LinuxPath -Path $tree_constraint)
    }

    if ($null -ne $outgroup -and ($outgroup.Count -gt 0)) {
        $CommandLine += "--outgroup"
        $CommandLine += ($outgroup -join ",")
    }

    if ($site_weights -ne "") {
        $CommandLine += "--site-weights"
        $CommandLine += (ConvertTo-LinuxPath -Path $site_weights)
    }

    $CommandLine += "--prefix"
    $CommandLine += (ConvertTo-LinuxPath -Path $prefix)

    if ($threads -gt 0) {
        $CommandLine += "--threads"
        $CommandLine += $threads
    }

    if ($lh_epsilon -ge 0) {
        $CommandLine += "--lhepsilon"
        $CommandLine += $lh_epsilon
    }

    if ($redo) {
        $CommandLine += "--redo"
    }

    Invoke-OnLinux -Path (Get-RaxmlPath) $CommandLine
}

Export-ModuleMember -Function Invoke-Raxml