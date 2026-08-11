Push-Location $PSScriptRoot
Import-Module $PSScriptRoot/../linux

# load config
. ..\..\config.ps1

$INSTALL_DIR = "bin/"
New-Item -ItemType Directory -Path $INSTALL_DIR -ErrorAction SilentlyContinue > $null

if (Test-Path "$INSTALL_DIR/muscle") {
    Pop-Location
    Write-Host -ForegroundColor Yellow "muscle already installed."
    exit
}

Write-Host -ForegroundColor Yellow "Cloning muscle at commit $MUSCLE_COMMIT"
git clone $MUSCLE_URL muscle
Push-Location muscle

git checkout $MUSCLE_COMMIT
Push-Location src
Write-Host -ForegroundColor Yellow "Running build script..."
ConvertTo-UnixLineEnding -Path ./build_linux.bash
Invoke-OnLinux -Path /usr/bin/env bash ./build_linux.bash
Pop-Location

Copy-Item ./bin/muscle ../$INSTALL_DIR/muscle
Write-Host -ForegroundColor Yellow "Cleaning up..."
Pop-Location
Remove-Item -Recurse -Force muscle

Pop-Location
Write-Host -ForegroundColor Yellow "Successfully installed muscle."