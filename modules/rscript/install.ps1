Push-Location $PSScriptRoot

# Make sure conda is installed
& $PSScriptRoot/../conda/install.ps1

Import-Module $PSScriptRoot/../conda
Set-CondaEnvironment

conda install -y conda-forge::r-base

Pop-Location