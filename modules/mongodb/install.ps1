Push-Location $PSScriptRoot

if (Test-Path "mongodata") {
    Write-Host "mongodb is already installed"
    Pop-Location
    exit
}

# Make sure conda is installed
& $PSScriptRoot/../conda/install.ps1

Import-Module $PSScriptRoot/../conda
Invoke-InConda -- conda install -y anaconda::mongodb conda-forge::mongo-tools

New-Item "mongodata" -ItemType Directory