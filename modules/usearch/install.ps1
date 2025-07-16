Push-Location $PSScriptRoot

# load config
. ..\..\config.ps1

$InstallDir = "bin/"
New-Item -ItemType Directory -Path $InstallDir -ErrorAction SilentlyContinue > $null

# to make conversion between platforms easier, we name it .exe on linux as well, they won't catch us.
$Binary = [System.IO.Path]::Combine($InstallDir, "usearch12.exe")

if (Test-Path $Binary) {
    Pop-Location
    Write-Host "usearch12 already installed."
    exit
}

Write-Host "Downloading usearch12 binary..."
Invoke-WebRequest -Uri $USEARCH_URL -OutFile $Binary

Pop-Location
Write-Host "Successfully installed usearch12."