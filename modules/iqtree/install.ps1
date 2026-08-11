Push-Location $PSScriptRoot
Import-Module $PSScriptRoot/../linux

# load config
. ..\..\config.ps1

$INSTALL_DIR = "bin/"
New-Item -ItemType Directory -Path $INSTALL_DIR -ErrorAction SilentlyContinue > $null

if (Test-Path "$INSTALL_DIR/iqtree") {
    Pop-Location
    Write-Host "iqtree3 already installed."
    exit
}

$TarBall = [System.IO.Path]::Combine($INSTALL_DIR, "iqtree.tar.gz")
Invoke-WebRequest -Uri $IQTREE_URL -OutFile $TarBall

tar -xzf $TarBall --strip-components 2 -C $INSTALL_DIR "*/bin/iqtree3"
Remove-Item $TarBall

Pop-Location
Write-Host "Successfully installed iqtree3."