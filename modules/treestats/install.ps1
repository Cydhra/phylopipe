Push-Location $PSScriptRoot

$r_install = "R"
$r_path = [System.IO.Path]::Combine($r_install, "R-4.5.0-win.exe")
$r_url = "https://cran.r-project.org/bin/windows/base/R-4.5.0-win.exe"

if (-not (Test-Path ([System.IO.Path]::Combine($r_install, "bin\Rscript.exe")))) {
    if (-not (Test-Path $r_install)) {
        Write-Host "Downloading R..."
        New-Item -Path $r_install -ItemType Directory > $null

        curl $($r_url) -o $r_path
    } else {
        Write-Host "R is already downloaded."
    }

    Write-Host "Installing R..."
    Start-Process -FilePath $r_path -ArgumentList "/VERYSILENT /DIR=`"$r_install`" /v/qn /NORESTART /NOCANCEL /SUPPRESSMSGBOXES /CURRENTUSER /SP- /LANG=en /MERGETASKS=!desktopicon" -Wait
} else {
    Write-Host "R is already installed."
}

$rscript_path = [System.IO.Path]::Combine($r_install, "bin\Rscript.exe")
& $rscript_path packages.R

Pop-Location