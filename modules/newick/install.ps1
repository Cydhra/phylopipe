Push-Location $PSScriptRoot
Import-Module $PSScriptRoot/../linux

# load config
. ..\..\config.ps1

$INSTALL_FILE = "newick"
$REPO_PATH = "newick_repo"

if (Test-Path $INSTALL_FILE) {
    Write-Host "Newick already installed."
    Pop-Location
    exit
}

Write-Host "Cloning newick at commit $NEWICK_COMMIT"
git clone $NEWICK_URL $REPO_PATH
Push-Location $REPO_PATH

git checkout $NEWICK_COMMIT
Push-Location src

Write-Host "Running build script..."
ConvertTo-UnixLineEnding -Path ./build_linux_x86.bash
Invoke-OnLinux -Path /usr/bin/env bash ./build_linux_x86.bash
Pop-Location

Copy-Item ./bin/newick ../$INSTALL_FILE

Write-Host "Cleaning up..."
Pop-Location
Remove-Item -Recurse -Force $REPO_PATH

Pop-Location