Push-Location $PSScriptRoot

$LATEST_SUPPORTED_VERSION = "https://github.com/rcedgar/newick/releases/download/v1.0.1429/newick_v1.0.1429_linux"
$INSTALL_FILE = "newick"

if (-not (Test-Path $INSTALL_FILE)) {
    Write-Host "Downloading Newick..."
    Invoke-WebRequest -Method GET -uri $LATEST_SUPPORTED_VERSION -OutFile $INSTALL_FILE
    Write-Host "Done."
} else {
    Write-Host "Newick already installed."
}

Pop-Location