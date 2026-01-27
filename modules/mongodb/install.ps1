# Make sure conda is installed
& $PSScriptRoot/../conda/install.ps1

Import-Module $PSScriptRoot/../conda
Invoke-InConda conda install "-y" anaconda::mongodb conda-forge::mongo-tools