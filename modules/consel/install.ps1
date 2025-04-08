Push-Location $PSScriptRoot

$INSTALL_DIR = "bin/"

if (Test-Path "$INSTALL_DIR/consel") {
    Pop-Location
    Write-Host "consel already installed."
    exit
}

Write-Host "Cloning consel at latest commit"
git clone https://github.com/shimo-lab/consel
Push-Location consel

Write-Host "Compiling consel under WSL"
# Make sure the compile script is well-formed
wsl dos2unix ../compile.sh

# Build the project under WSL
wsl ../compile.sh
Pop-Location

# Copy the compiled binary to the scripts directory
mkdir bin/ -ErrorAction SilentlyContinue > $null
cp consel/bin/* bin/

Write-Host "Cleaning up..."
# Clean up
rm -Recurse -Force consel

Pop-Location
Write-Host "Successfully installed consel."