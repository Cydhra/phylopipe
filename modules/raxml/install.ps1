Push-Location $PSScriptRoot

# load config
. ..\..\config.ps1

Import-Module $PSScriptRoot/../linux
Import-Module $PSScriptRoot/../conda

$INSTALL_DIR = "bin"
$INSTALL_FILE = "$INSTALL_DIR/raxml-ng"

if (Test-Path $INSTALL_FILE) {
    Pop-Location
    Write-Host -ForegroundColor Yellow "RAxML already installed."
    exit
}

New-Item -ItemType Directory $INSTALL_DIR > $null

Write-Host "Cloning RAxML at latest supported commit"
git clone $RAXML_URL --branch $RAXML_BRANCH
Push-Location raxml-ng
git checkout $RAXML_COMMIT
git submodule update --init --recursive

Write-Host -ForegroundColor Yellow "Compiling RAxML under WSL"
 # Make sure the compile script is well-formed
Invoke-OnLinux -Path dos2unix ../compile.sh

# Build the project under WSL
Invoke-OnLinux -Path /usr/bin/env bash ../compile.sh
Pop-Location

# Copy the compiled binary to the scripts directory
Copy-Item raxml-ng/bin/raxml-ng $INSTALL_FILE
Exit-On-Failure

Write-Host -ForegroundColor Yellow "Cleaning up..."
# Clean up
Remove-Item -Recurse -Force raxml-ng

Write-Host -ForegroundColor Yellow "Installing conda package..."
Install-LocalCondaPackage -Path . -Name "raxml-ng"

Pop-Location
Write-Host -ForegroundColor Yellow "Done."