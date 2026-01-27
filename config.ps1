$CONSEL_URL = "https://github.com/shimo-lab/consel"

$RAXML_URL = "https://github.com/amkozlov/raxml-ng"
$RAXML_BRANCH = "dev"
$RAXML_COMMIT = "11dc3c49efdc0f8462180688f4fad3a78fc71114"

$NEWICK_URL = "https://github.com/rcedgar/newick"
$NEWICK_COMMIT = "83701cb4040ac5d364eb1403c7732af4f900d6bf"

$MUSCLE_URL = "https://github.com/rcedgar/muscle"
$MUSCLE_COMMIT = "cfc3eeedb98fa9cc9bd5b32c2edad95ae0416725"

$RESEEK_URL = "https://github.com/rcedgar/reseek"
$RESEEK_COMMIT = "d13dfa15205816994a5d904765a17e48060bf8d4"

if ($IsWindows) {
    $USEARCH_URL = "https://github.com/rcedgar/usearch12/releases/download/v12.0-beta1/usearch_win_12.0-beta.exe"
} elseif ($IsLinux) {
    $USEARCH_URL = "https://github.com/rcedgar/usearch12/releases/download/v12.0-beta1/usearch_linux_x86_12.0-beta"
}

$CONDA_INSTALLER = "https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"

$IQTREE_URL = "https://github.com/iqtree/iqtree3/releases/download/v3.0.1/iqtree-3.0.1-Linux-intel.tar.gz"