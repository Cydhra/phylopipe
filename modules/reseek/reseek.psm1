Import-Module $PSScriptRoot/../linux

function Get-Reseek {
    return ConvertTo-LinuxPath -Path ([System.IO.Path]::Combine($PSScriptRoot, "bin", "reseek"))
}

<#
 .SYNOPSIS
 Extract the Amino Acid sequence from a protein structure file (PDB, CIF/mmCIF, CAL, or BCA) or folder.

 .DESCRIPTION
 Extracts one or more chains from a protein structure file and writes the amino acid sequences to a Multi-FASTA
 file. The chain name (usually a letter) is appended to the structure name in the FASTA identifier.

 .PARAMETER Path
 Path to a PDB, CIF/mmCIF, CAL, or BCA file containing protein structures, or a folder of multiple such files.

 .PARAMETER Output
 Path of a fasta file where the output sequence(s) are stored.
#>
function ConvertTo-AminoAcidFasta {
    param(
        [Parameter(Mandatory = $true)]
        [string] $Path,

        [Parameter(Mandatory = $true)]
        [string] $Output
    )

    Invoke-OnLinux (Get-Reseek) -convert (ConvertTo-LinuxPath $Path) -fasta (ConvertTo-LinuxPath $Output)
}

<#
 .SYNOPSIS
 Extract the Mu structure sequence from a protein structure file (PDB, CIF/mmCIF, CAL, or BCA) or folder.

 .DESCRIPTION
 Extracts one or more chains from a protein structure file and writes the Mu character sequences to a Multi-FASTA
 file. The chain name (usually a letter) is appended to the structure name in the FASTA identifier.

 .PARAMETER Path
 Path to a PDB, CIF/mmCIF, CAL, or BCA file containing protein structures, or a folder of multiple such files.

 .PARAMETER Output
 Path of a fasta file where the output sequence(s) are stored.
#>
function ConvertTo-MuSequenceFasta {
    param(
        [Parameter(Mandatory = $true)]
        [string] $Path,

        [Parameter(Mandatory = $true)]
        [string] $Output
    )

    Invoke-OnLinux (Get-Reseek) -convert (ConvertTo-LinuxPath $Path) -alpha Mu -feature_fasta (ConvertTo-LinuxPath $Output)
}

Export-ModuleMember -Function ConvertTo-AminoAcidFasta
Export-ModuleMember -Function ConvertTo-MuSequenceFasta