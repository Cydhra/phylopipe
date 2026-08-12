. $PSScriptRoot/../../config.ps1

Import-Module $PSScriptRoot/../conda
Enter-Conda
$Success = Install-CondaPackage -Channel "conda-forge", "bioconda" -Name "snakemake"
if (-not $Success) {
    Exit-Script 0
}
$Success = Install-CondaPackage -Channel "conda-forge", "bioconda" -Name "snakemake-executor-plugin-slurm"
if (-not $Success) {
    Exit-Script 0
}

Write-Host -ForegroundColor Yellow "Successfully installed snakemake."