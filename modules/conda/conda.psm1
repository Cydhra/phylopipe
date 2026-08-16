Import-Module $PSScriptRoot/../linux

$CondaHook = "$PSScriptRoot/miniconda3/shell/condabin/conda-hook.ps1"

# check if hook is present, in which case we prefer the local conda instance
if (Test-Path $CondaHook) {
    . $CondaHook
} else {
    conda --version > $null

    if ($LASTEXITCODE) {
        $Prompt = Read-Host -Prompt "No conda available. Do you want to install a local instance? (Y/N)"

        if ($Prompt -ieq "y") {
            . "$PSScriptRoot/install.ps1"
            . $CondaHook
        } else {
            Return 1
        }
    }
}

$Env
conda info | ForEach-Object {
    if ($_ -match "active environment : (?<env>.*)") {
        $Env = $Matches["env"]
    }
}

conda list -n phylopipe > $null
if ($LASTEXITCODE) {
    conda create -n phylopipe
}

<#
 .SYNOPSIS
 Ensure the phylopipe channel is active.
#>
function Enter-Conda {
    conda activate phylopipe
}

Enter-Conda

<#
 .SYNOPSIS
 Install a conda package from a local path into the phylopipe environment.

 .PARAMETER Name
 Name of the conda package

 .PARAMETER Path
 File path to the channel where the package is located.

 .RETURN
 A boolean value indicating whether the package was installed successfully.
#>
function Install-LocalCondaPackage {
    Param (
        [Parameter(Mandatory)]
        [string] $Path,

        [Parameter(Mandatory)]
        [string] $Name
    )

    $ChannelPath = [System.IO.Path]::Combine($PSScriptRoot, "..", "..", "channel")

    conda activate base
    conda build "$Path" --output-folder "$ChannelPath"

    # has to be linux-style path, but we cannot use a wsl path.
    $LinuxChannelPath = $ChannelPath -replace '\\', '/'
    conda install -y -c "$LinuxChannelPath" -n phylopipe $Name --override-channels --force-reinstall

    Return $LASTEXITCODE -eq 0
}

<#
 .SYNOPSIS
 Install a conda package from a remote channel into the phylopipe environment.

 .PARAMETER Name
 Name of the conda package

 .PARAMETER Channel
 Optionally the channel where to get the package.

 .RETURN
 A boolean value indicating whether the package was installed successfully.
#>
function Install-CondaPackage {
    Param (
        [Parameter(Mandatory = $false)]
        [string[]] $Channel = @(),

        [Parameter(Mandatory)]
        [string] $Name
    )

    $Parameters = "-y", "-n", "phylopipe"

    foreach ($C in $Channel) {
        $Parameters += "-c", $C
    }

    conda install @Parameters $Name

    Return $LASTEXITCODE -eq 0
}

<#
 .SYNOPSIS
 Check if a conda package is installed in phylopipe.

 .PARAMETER Name
 Name of the conda package

 .RETURN
 A boolean value indicating whether the package is installed.
#>
function Test-CondaPackage {
    Param (
        [Parameter(Mandatory)]
        [string] $Name
    )

    conda list -n phylopipe $Name > $null
    Return $LASTEXITCODE -eq 0
}