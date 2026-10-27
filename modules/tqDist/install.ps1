Push-Location $PSScriptRoot

$INSTALL_DIR = "bin"

if (Test-Path "$INSTALL_FILE/quartet_dist") {
    Pop-Location
    Write-Host -ForegroundColor Yellow "tqDist already installed."
    exit
}

# load config
. ..\..\config.ps1

Import-Module $PSScriptRoot/../linux
Import-Module $PSScriptRoot/../conda

# Download source
$SOURCE_ARCHIVE = "tq_source.zip"
$ARCHIVE_DEST = "src"
Invoke-WebRequest -Uri $TQ_URL -OutFile $SOURCE_ARCHIVE -ErrorAction Stop
Expand-Archive -Path $SOURCE_ARCHIVE -DestinationPath $ARCHIVE_DEST -ErrorAction Stop

Push-Location "src/tqDist-1.0.2"

Invoke-OnLinux -Path dos2unix ../../compile.sh
Invoke-OnLinux -Path /usr/bin/env bash ../../compile.sh

Pop-Location

Write-Host -ForegroundColor Yellow "Cleaning up..."
Remove-Item $SOURCE_ARCHIVE
Remove-Item -Recurse -Force $ARCHIVE_DEST

Write-Host -ForegroundColor Yellow "Installing conda package..."
Install-LocalCondaPackage -Path . -Name "tq_dist"

Pop-Location
Write-Host -ForegroundColor Yellow "Done."