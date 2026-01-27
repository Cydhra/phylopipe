Push-Location $PSScriptRoot

if (Test-Path "miniconda3/bin/activate") {
    Write-Host "conda is already installed"
    Pop-Location
    exit
}

Import-Module $PSScriptRoot/../linux

# load config
. ..\..\config.ps1

if (-not (Test-Path "./Miniconda3-latest-Linux-x86_64.sh")) {
    Invoke-OnLinux wget $CONDA_INSTALLER
}

New-Item -ItemType Directory -ErrorAction SilentlyContinue miniconda3 > $null

# set directory to case sensitive to prevent dumb packages (ncurses) from crashing
fsutil.exe file setCaseSensitiveInfo miniconda3 enable

Invoke-OnLinux chmod u+x ./Miniconda3-latest-Linux-x86_64.sh
Invoke-OnLinux ./Miniconda3-latest-Linux-x86_64.sh "-b" "-f" "-p" ./miniconda3

Remove-Item ./Miniconda3-latest-Linux-x86_64.sh

Pop-Location