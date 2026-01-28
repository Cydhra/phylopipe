Push-Location $PSScriptRoot

if (Test-Path "miniconda3") {
    Write-Host "conda is already installed"
    Pop-Location
    exit
}

# load config
. ..\..\config.ps1

if ($IsWindows) {
    if (-not (Test-Path "miniconda3.exe")) {
        curl $CONDA_INSTALLER --output "miniconda3.exe"
    }

    Start-Process -Wait "miniconda3.exe" -ArgumentList "/S /D=$PSScriptRoot\miniconda3"
} else {
    if (-not (Test-Path "miniconda3.sh")) {
        curl $CONDA_INSTALLER --output "miniconda3.sh"
    }

    New-Item -ItemType Directory -ErrorActthe ion SilentlyContinue miniconda3 > $null
    & ./miniconda3.sh "-b" "-f" "-p" ./miniconda3
}

Import-Module $PSScriptRoot/../conda

Invoke-InConda -- conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main
Invoke-InConda -- conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r
Invoke-InConda -- conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/msys2
Invoke-InConda -- conda env create -f phylopipe.yml

Pop-Location