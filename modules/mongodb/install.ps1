Push-Location $PSScriptRoot

if (Test-Path "data") {
    Write-Host "mongodb is already installed"
    Pop-Location
    exit
}

# Make sure conda is installed
& $PSScriptRoot/../conda/install.ps1

Import-Module $PSScriptRoot/../conda
Invoke-InConda -- conda install -y conda-forge::mongodb conda-forge::mongo-tools

New-Item "data" -ItemType Directory

Pop-Location