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

conda activate phylopipe