$CONSEL_URL = "https://github.com/shimo-lab/consel"

$RAXML_URL = "https://github.com/amkozlov/raxml-ng"
$RAXML_BRANCH = "master"
$RAXML_COMMIT = "861756d02f82ec81fe72ef49e697db78cc377d76"

$NEWICK_URL = "https://github.com/rcedgar/newick"
$NEWICK_COMMIT = "83701cb4040ac5d364eb1403c7732af4f900d6bf"

$MUSCLE_URL = "https://github.com/rcedgar/muscle"
$MUSCLE_COMMIT = "cfc3eeedb98fa9cc9bd5b32c2edad95ae0416725"

$RESEEK_URL = "https://github.com/rcedgar/reseek"
$RESEEK_COMMIT = "d13dfa15205816994a5d904765a17e48060bf8d4"

if ($IsWindows) {
    $USEARCH_URL = "https://github.com/rcedgar/usearch12/releases/download/v12.0-beta1/usearch_win_12.0-beta.exe"
    $CONDA_INSTALLER = "https://repo.anaconda.com/miniconda/Miniconda3-latest-Windows-x86_64.exe"
} elseif ($IsLinux) {
    $USEARCH_URL = "https://github.com/rcedgar/usearch12/releases/download/v12.0-beta1/usearch_linux_x86_12.0-beta"
    $CONDA_INSTALLER = "https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
}

$IQTREE_URL = "https://github.com/iqtree/iqtree3/releases/download/v3.1.3/iqtree-3.1.3-Linux-intel.tar.gz"

$NEMA_URL = "https://github.com/Cydhra/nema"
$NEMA_COMMIT = "1082c437a82fb4b9af71c9a564610f6f441a9ada"

function Exit-Script {
    Param(
        [Parameter(Position = 0, Mandatory = $false)]
        [int] $NumPops = 1
    )

    foreach ($i in 1..$NumPops) {
        Pop-Location
    }

    exit 1
}

function Exit-On-Failure {
    Param(
        [Parameter(Position = 0, Mandatory = $false)]
        [int] $NumPops = 1
    )

    if ($LASTEXITCODE) {
        Write-Error "Aborting due to previous error (code $LASTEXITCODE)"

        Exit-Script $NumPops
    }
}

function Check-Conda-Build {
    Param(
        [Parameter(Position = 0, Mandatory = $false)]
        [int] $NumPops = 1
    )

    if ((conda list -n base | Where-Object { $_ -match "conda-build" } | Measure-Object).Count -eq 0) {
        Write-Error "Aborting because conda-build is not available"
        Exit-Script $NumPops
    }
}