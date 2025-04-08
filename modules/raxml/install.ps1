Push-Location $PSScriptRoot

$INSTALL_FILE = "raxml-ng-2"

if (Test-Path $INSTALL_FILE) {
    Pop-Location
    Write-Host "RAxML already installed."
    exit
}

Write-Host "Cloning RAxML at latest supported commit"
git clone https://github.com/amkozlov/raxml-ng --branch dev
Push-Location raxml-ng
git checkout 5c07bb65fd50b7d739b4e9cebfbae0475b44a51d
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