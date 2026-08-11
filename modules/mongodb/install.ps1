Push-Location $PSScriptRoot

. ../../config.ps1

if (Test-Path "data") {
    Write-Host -ForegroundColor Yellow "mongodb is already installed"
    Pop-Location
}

Import-Module $PSScriptRoot/../conda
$Success = Install-CondaPackage -Channel conda-forge -Name mongodb

If (-not $Success) {
    Exit-Script
}

Install-CondaPackage -Channel conda-forge -Name mongo-tools

If (-not $Success) {
    Exit-Script
}

New-Item "data" -ItemType Directory

Write-Host -ForegroundColor Yellow "mongodb successfully installed."
Pop-Location