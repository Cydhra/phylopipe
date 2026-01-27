$ALPHAFOLD_API_PATTERN = "https://alphafold.com/api/prediction/{0}"
$ALPHAFOLD_UNIPROT_PATTERN = "https://alphafold.com/api/uniprot/summary/{0}.json"

<#
 .SYNOPSIS
 Get the alphafold metadata entries to a uniprot accession.

 .DESCRIPTION
 Queries the AlphaFold.com API hosted by EMBL-EBI and returns all query results for a uniprot accession.

 .PARAMETER Accession
 Uniprot accession string

 .OUTPUTS [Object[]]
 An array of hashtables containing the metadata returned by the AlphaFold API for the given accession.
#>
function Get-AlphaFoldEntry {
    param(
        [Parameter(Mandatory = $true, Position=0)]
        [string] $Accession
    )

    $URL = $ALPHAFOLD_API_PATTERN -f $Accession
    Return (curl --silent $URL | ConvertFrom-Json)
}

<#
 .SYNOPSIS
 Get the uniprot database entry to a uniprot accession.

 .DESCRIPTION
 Queries the AlphaFold.com API hosted by EMBL-EBI and returns the uniprot database entry for a uniprot accession.

 .PARAMETER Accession
 Uniprot accession string

 .OUTPUTS [Object]
 A Powershell object containing the uniprot data for the given accession.
#>
function Get-UniprotEntry {
    param(
        [Parameter(Mandatory = $true, Position=0)]
        [string] $Accession
    )

    $URL = $ALPHAFOLD_API_PATTERN -f $Accession
    Return (curl --silent $URL | ConvertFrom-Json)
}

<#
 .SYNOPSIS
 Download an AlphaFold structure file to a specified path.

 .DESCRIPTION
 Queries the AlphaFold.com API hosted by EMBL-EBI and takes the link to the structure file. Downlaods the structure
 to the specified path. The downloaded structure file type can be selected. Alternatively, a link can be provided
 directly.

 .PARAMETER Accession
 Uniprot accession string

 .PARAMETER FileType

 .PARAMETER AlphafoldUrl
 Url to the structure file to download.

 .PARAMETER Directory
 Directory where to store the downloaded file.

 .OUTPUTS [Object[]]
 An array of hashtables containing the metadata returned by the AlphaFold API for the given accession.
 If the AlphaFold entry does not exist, returns an empty object.
 The filename of the downloaded path is equal to the filename of the remote file.
#>
function Get-AlphaFoldStructure {
    param(
        [Parameter(Mandatory = $true, Position=0, ParameterSetName="Accession")]
        [string] $Accession,

        [ValidateSet("cif", "pdb", "bcif", IgnoreCase = $true)]
        [Parameter(Mandatory = $false, ParameterSetName="Accession")]
        [string] $FileType = "cif",

        [Parameter(Mandatory = $true, Position=0, ParameterSetName="Url")]
        [string] $AlphafoldUrl,

        [Parameter(Mandatory = $true, Position=1)]
        [string] $Path
    )

    if ($Accession) {
        $Metadata = Get-AlphaFoldEntry $Accession

        if ($FileType -ieq "bcif") {
            $AlphafoldUrl = $Metadata.bcifUrl
        } elseif ($FileType -ieq "pdb") {
            $AlphafoldUrl = $Metadata.pdbUrl
        } else {
            $AlphafoldUrl = $Metadata.cifUrl
        }
    }

    if (-not $AlphafoldUrl) {
        Write-Error "No URL found for alphafold structure for accession $Accession"
        Return $Metadata
    }

    curl --silent $AlphafoldUrl --output $Path
    Return $Metadata
}

Export-ModuleMember -Function Get-AlphaFoldEntry
Export-ModuleMember -Function Get-UniprotEntry
Export-ModuleMember -Function Get-AlphaFoldStructure