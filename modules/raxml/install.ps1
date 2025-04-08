Push-Location $PSScriptRoot

# load config
. ..\..\config.ps1

$INSTALL_FILE = "raxml-ng-2"

if (Test-Path $INSTALL_FILE) {
    Pop-Location
    Write-Host "RAxML already installed."
    exit
}

Write-Host "Cloning RAxML at latest supported commit"
git clone $RAXML_URL --branch $RAXML_BRANCH
Push-Location raxml-ng
git checkout $RAXML_COMMIT
git submodule update --init --recursive

Write-Host "Compiling RAxML under WSL"
 # Make sure the compile script is well-formed
wsl dos2unix ../compile.sh

# Build the project under WSL
wsl ../compile.sh
Pop-Location

# Copy the compiled binary to the scripts directory
cp raxml-ng/bin/raxml-ng-2 $INSTALL_FILE

Write-Host "Cleaning up..."
# Clean up
rm -Recurse -Force raxml-ng

Pop-Location
Write-Host "Done."