Push-Location $PSScriptRoot

# load config
. ..\..\config.ps1

$INSTALL_FILE = "newick"

if (-not (Test-Path $INSTALL_FILE)) {
    Write-Host "Downloading Newick..."
    Invoke-WebRequest -Method GET -uri $NEWICK_URL -OutFile $INSTALL_FILE
    Write-Host "Done."
} else {
    Write-Host "Newick already installed."
}

Pop-Location