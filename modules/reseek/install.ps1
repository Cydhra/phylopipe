Push-Location $PSScriptRoot
Import-Module $PSScriptRoot/../linux

# load config
. ..\..\config.ps1

$INSTALL_DIR = "bin/"
New-Item -ItemType Directory -Path $INSTALL_DIR -ErrorAction SilentlyContinue > $null

if (Test-Path "$INSTALL_DIR/reseek") {
    Pop-Location
    Write-Host "reseek already installed."
    exit
}

Write-Host "Cloning reseek at commit $RESEEK_COMMIT"
git clone $RESEEK_URL reseek
Push-Location reseek

git checkout $RESEEK_COMMIT
Push-Location src

Write-Host "Running build script..."
ConvertTo-UnixLineEnding -Path ./build_linux_x86.bash
Invoke-OnLinux -Path /usr/bin/env bash ./build_linux_x86.bash
Pop-Location

Copy-Item ./bin/reseek ../$INSTALL_DIR/reseek

Write-Host "Cleaning up..."
Pop-Location
Remove-Item -Recurse -Force reseek

Pop-Location
Write-Host "Successfully installed reseek."