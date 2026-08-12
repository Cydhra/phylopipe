Push-Location $PSScriptRoot
Import-Module $PSScriptRoot/../linux
Import-Module $PSScriptRoot/../conda

# load config
. ..\..\config.ps1

Check-Conda-Build

if ($IsWindows) {
    $INSTALL_DIR = "bin/"
    $INSTALL_BIN = "nema.exe"
} else {
    $INSTALL_DIR = "bin/"
    $INSTALL_BIN = "nema"
}

New-Item $INSTALL_DIR -ItemType Directory -ErrorAction SilentlyContinue > $null

if (Test-Path ([System.IO.Path]::Combine($INSTALL_DIR, $INSTALL_BIN))) {
    Write-Host -ForegroundColor Yellow "Nema already installed."
    Pop-Location
    exit
}

Write-Host -ForegroundColor Yellow "Cloning nema..."
$REPO_PATH = "nema"

git clone $NEMA_URL $REPO_PATH
Push-Location $REPO_PATH
Exit-On-Failure

git checkout $NEMA_COMMIT
Exit-On-Failure 2

git submodule update --init --recursive
Exit-On-Failure 2

Enter-Conda

cargo build --release
Exit-On-Failure 2

if ($IsWindows) {
    Copy-Item ./target/release/nema.exe ../$INSTALL_DIR/$INSTALL_BIN
} else {
    Copy-Item ./target/release/nema ../$INSTALL_DIR/$INSTALL_BIN
}

Write-Host -ForegroundColor Yellow "Cleaning up..."

Pop-Location
Remove-Item -Recurse -Force $REPO_PATH

Check-Conda-Build
conda activate base

Write-Host -ForegroundColor Yellow "Building conda package..."
Install-LocalCondaPackage -Path . -Name nema

Pop-Location

