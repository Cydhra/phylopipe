function Get-UsearchPath {
    Return [System.IO.Path]::Combine($PSScriptRoot, "bin", "usearch12.exe")
}

<#
 .SYNOPSIS
 Clusters a Multi-FASTA file and writes cluster centroid sequences into an output file.
#>
function Get-ClusterCentroids {
    param(
        [Parameter(Mandatory = $true)]
        [string] $Path,

        [Parameter(Mandatory = $true)]
        [float] $Identity,

        [Parameter(Mandatory = $true)]
        [string] $Output
    )

    & (Get-UsearchPath) -cluster_fast $Path -id $Identity -centroids $Output
}

<#
 .SYNOPSIS
 Clusters a Multi-FASTA file and writes all found clusters into an output directory.
#>
function Get-Clusters {
    param(
        [Parameter(Mandatory = $true)]
        [string] $Path,

        [Parameter(Mandatory = $true)]
        [float] $Identity,

        [Parameter(Mandatory = $true)]
        [string] $OutDirectory
    )

    $ClusterPrefix = [System.IO.Path]::Combine($OutDirectory, "c")

    & (Get-UsearchPath) -cluster_fast $Path -id $Identity -clusters $ClusterPrefix
}

Export-ModuleMember -Function Get-ClusterCentroids
Export-ModuleMember -Function Get-Clusters