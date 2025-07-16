<#
 .SYNOPSIS
 Imports a Multi-FASTA file into a hashtable mapping the identifiers to sequences.

 .DESCRIPTION
 Imports one or multiple sequences from a FASTA file into a map, where the keys are the sequence identifiers,
 and the values are the state sequences with whitespace removed.

 .PARAMETER Path
 Path to a fasta file containing the sequences.

 .OUTPUTS [System.Collections.Hashtable]
 Returns a map of all sequences in the FASTA file.
#>
function Import-MultiFasta {
    param(
        [Parameter(Mandatory = $true)]
        [string] $Path
    )

    $SequenceMap = @{}

    $FileContent = Get-Content -Path $Path -Raw
    $Entries = $FileContent -split '(?=\n>[^>]+)'

    $Entries | ForEach-Object {
        $Data = ($_ -split '\r?\n') | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne '' }
        $Descriptor = $Data[0]
        $StateSequence = $Data[1..($Data.Length - 1)] -join ""
        $SequenceMap[$Descriptor] = $StateSequence
    }

    return $SequenceMap
}

<#
 .SYNOPSIS
 Exports a hashtable containing FASTA names and sequences into a Multi-FASTA file.

 .DESCRIPTION
 Exports one or multiple sequences from a map, where the keys are the sequence identifiers,
 and the values are the state sequences into a Multi-FASTA file.

 .PARAMETER Sequences
 Hashtable containing the mapping of sequence identifiers to sequences.

 .PARAMETER Path
 Path to the output file.

 .OUTPUTS [System.Collections.Hashtable]
 Returns a map of all sequences in the FASTA file.
#>
function Export-MultiFasta {
    param(
        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable] $Sequences,

        [Parameter(Mandatory = $true)]
        [string] $Path
    )

    $Sequences.getEnumerator() | `
        ForEach-Object {
            $_.Key
            $_.Value
        } | `
        Set-Content -Path $Path
}

<#
 .SYNOPSIS
 Projects the alignment of a given MSA onto an unaligned Multi-FASTA file with the same taxa.

 .DESCRIPTION
 Given a Multi-Sequence-Alignment and a set of unaligned sequences with the same set of identifiers,
 project the gaps of the existing alignment onto the unaligned sequences, creating an analogous alignment.
 This only works correctly, if the unaligned sequences have the same length as the aligned sequences (without gaps).
 The unaligned sequence map may contain sequences which are not present in the alignment. Those sequences will not
 be present in the projected alignment.

 .PARAMETER Msa
 Hashtable containing the aligned sequences.

 .PARAMETER MsaPath
 Path to a fasta file containing aligned sequences.

.PARAMETER UnalignedSequences
 Hashtable containing multiple unaligned sequences with the same identifiers as the Msa sequences.

 .PARAMETER UnalignedPath
 Path to a multi-fasta file containing multiple unaligned sequences with the same identifiers as the Msa sequences.

 .OUTPUTS [System.Collections.Hashtable]
 Returns a hashtable containing the unaligned sequences with gaps inserted in analogous positions as in the given
 alignment.
#>
function ConvertTo-AlignmentProjection {
    param(
        [Parameter(Mandatory = $true, ParameterSetName = "in_map_out_map")]
        [Parameter(Mandatory = $true, ParameterSetName = "in_map_out_file")]
        [System.Collections.Hashtable] $Msa,

        [Parameter(Mandatory = $true, ParameterSetName = "in_file_out_map")]
        [Parameter(Mandatory = $true, ParameterSetName = "in_file_out_file")]
        [string] $MsaPath,

        [Parameter(Mandatory = $true, ParameterSetName = "in_map_out_map")]
        [Parameter(Mandatory = $true, ParameterSetName = "in_file_out_map")]
        [System.Collections.Hashtable] $UnalignedSequences,

        [Parameter(Mandatory = $true, ParameterSetName = "in_map_out_file")]
        [Parameter(Mandatory = $true, ParameterSetName = "in_file_out_file")]
        [string] $UnalignedPath
    )

    # read in MSA
    if ($PSCmdlet.ParameterSetName.StartsWith("in_file")) {
        $Msa = Import-MultiFasta -Path $MsaPath
    }

    if ($PSCmdlet.ParameterSetName.EndsWith("out_file")) {
        $UnalignedSequences = Import-MultiFasta -Path $UnalignedPath
    }

    $ProjectedAlignment = @{}

    foreach ($entry in $Msa.getEnumerator()) {
        $AlignedHeader = $entry.Key
        $AlignedSequence = $entry.Value

        if (-not ($UnalignedSequences.ContainsKey($AlignedHeader))) {
            Write-Error "No sequence $AlignedHeader found among unaligned sequences."
            Return $null
        }

        $TargetSequence = $UnalignedSequences[$AlignedHeader]
        $Index = 0
        $AlignedTargetSequence = ""

        foreach ($char in $AlignedSequence.ToCharArray())
        {
            if ($char -eq '-')
            {
                $AlignedTargetSequence += '-'
            }
            else
            {
                $AlignedTargetSequence += $TargetSequence[$Index]
                $Index++
            }
        }

        $ProjectedAlignment[$AlignedHeader] = $AlignedTargetSequence
    }

    return $ProjectedAlignment
}