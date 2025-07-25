Import-Module $PSScriptRoot/../linux

function Get-MakermtPath {
    return ConvertTo-LinuxPath -Path ([System.IO.Path]::Combine($PSScriptRoot, "bin", "makermt"))
}

function Get-ConselPath {
    return ConvertTo-LinuxPath -Path ([System.IO.Path]::Combine($PSScriptRoot, "bin", "consel"))
}

function Get-CatpvPath {
    return ConvertTo-LinuxPath -Path ([System.IO.Path]::Combine($PSScriptRoot, "bin", "catpv"))
}


<#
 .SYNOPSIS
 Invokes the consel program makermt.

 .DESCRIPTION
 Converts all provided paths into linux-compatible paths and then calls consel's makermt binary with the provided
 parameters.

 .PARAMETER sitelh
 Path of the sitelh file containing the per-site log-likelihoods used for bootstrapping. The "format" parameter
 controls which file format is expected for the sitelh file, and defaults to the tree-puzzle format, which is also
 used by raxml-ng. The extension ".sitelh" can be ommitted.

 .PARAMETER output
 Output file name pattern. Makermt will generate two output files, which will use the provided output pattern and
 the respective file ending. Do not append a file ending to the output pattern. One of the files will be the
 "output.rmt" file required for invoking consel.

 .PARAMETER format
 File format to use for the log-likelihoods file. Defaults to "puzzle", which is the format used by tree-puzzle and
 raxml-ng. Further supports "molphy", "paml", "paup", and "pyhml".
#>
function Invoke-Makermt {
    param(
        [Parameter(Mandatory = $true)]
        [string] $Sitelh,

        [Parameter(Mandatory = $true)]
        [string] $Output,

        [ValidateSet("molphy", "paml", "paup", "puzzle", "phyml", IgnoreCase = $true)]
        [Parameter(Mandatory = $false)]
        [string] $Format = "puzzle"
    )

    $linux_sitelh = ConvertTo-LinuxPath -Path $Sitelh
    $linux_output = ConvertTo-LinuxPath -Path $Output

    Invoke-OnLinux -Path (Get-MakermtPath) "--$Format" $linux_sitelh $linux_output
}

<#
 .SYNOPSIS
 Invokes the consel program.

 .DESCRIPTION
 Converts all provided paths into linux-compatible paths and then calls the consel binary with the provided
 parameters.

 .PARAMETER rmt
 Path of the rmt file containing the bootstrap values created by makermt. The extension ".rmt" can be ommitted.

 .PARAMETER output
 Output file name pattern. Makermt will generate two output files, which will use the provided output pattern and
 the respective file ending. Do not append a file ending to the output pattern.
#>
function Invoke-Consel {
    param(
        [Parameter(Mandatory = $true)]
        [string] $Rmt,

        [Parameter(Mandatory = $true)]
        [string] $Output
    )

    $linux_rmt = ConvertTo-LinuxPath -Path $Rmt
    $linux_output = ConvertTo-LinuxPath -Path $Output

    Invoke-OnLinux -Path (Get-ConselPath) $linux_rmt $linux_output
}

<#
 .SYNOPSIS
 Imports the contents of the consel pv file as PS objects.

 .DESCRIPTION
 Converts the provided path into a linux-compatible path and then calls the consel binary "catpv" with the provided
 pv path. Then, it converts the output of "catpv" into a properly formatted Powershell objects containing all
 properties of the PV table.

 .PARAMETER InputPv
 The path to the "*.pv" file generated by Invoke-Consel.

 .EXAMPLE
 # Convert the pv file into a CSV file
 Import-Pv -InputPv "gene1\ranks.pv" | Export-Csv -NoTypeInformation -UseQuotes -Path "gene1\ranks.csv"
#>
function Import-Pv {
    param(
        [Parameter(Mandatory)]
        [string] $InputPv
    )

    $linux_pv = ConvertTo-LinuxPath -Path $InputPv
    Invoke-OnLinux -Path (Get-CatpvPath) $linux_pv | `
        where { -not [string]::IsNullOrEmpty($_) } | `
        select -Skip 2 | `
        % {
            $cols = $_ -split '\s{1,}'
            [PSCustomObject]@{
                rank = [int]$cols[1]
                item = [int]$cols[2]
                obs = [float]$cols[3]
                au = [float]$cols[4]
                np = [float]$cols[5]
                bp = [float]$cols[7]
                pp = [float]$cols[8]
                kh = [float]$cols[9]
                sh = [float]$cols[10]
                wkh = [float]$cols[11]
                wsh = [float]$cols[12]
            }
        }
}

Export-ModuleMember -Function Invoke-Makermt
Export-ModuleMember -Function Invoke-Consel
Export-ModuleMember -Function Import-Pv