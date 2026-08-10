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

function Enter-Conda {
    conda activate phylopipe
}

Enter-Conda

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

    Enter-Conda

    # has to be linux-style path
    conda install -y -c "../../channel" $Name --override-channels
}