Push-Location $PSScriptRoot

# Ensure rscript is installed
& $PSScriptRoot/../rscript/install.ps1

Import-Module $PSScriptRoot/../rscript

Invoke-R packages.R

Write-Host "Successfully installed treestats."

Pop-Location