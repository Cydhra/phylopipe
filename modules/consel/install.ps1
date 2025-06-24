Push-Location $PSScriptRoot
Import-Module $PSScriptRoot/../linux

# load config
. ..\..\config.ps1

$INSTALL_DIR = "bin/"

if (Test-Path "$INSTALL_DIR/consel") {
    Pop-Location
    Write-Host "consel already installed."
    exit
}

Write-Host "Cloning consel at latest commit"
git clone $CONSEL_URL
Push-Location consel

Write-Host "Compiling consel under WSL"
# Make sure the compile script is well-formed
Invoke-OnLinux -Path dos2unix ../compile.sh

# Build the project under WSL
Invoke-OnLinux -Path /usr/bin/env bash ../compile.sh
Pop-Location

# Copy the compiled binary to the scripts directory
New-Item -ItemType Directory bin/ -ErrorAction SilentlyContinue > $null
Copy-Item consel/bin/* bin/

Write-Host "Cleaning up..."
# Clean up
rm -Recurse -Force consel

Pop-Location
Write-Host "Successfully installed consel."