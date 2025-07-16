$CONSEL_URL = "https://github.com/shimo-lab/consel"

$RAXML_URL = "https://github.com/amkozlov/raxml-ng"
$RAXML_BRANCH = "dev"
$RAXML_COMMIT = "c056d0e6a429fafd71cfec9e190e2a640f250d85"

$NEWICK_URL = "https://github.com/rcedgar/newick/releases/download/v1.0.1429/newick_v1.0.1429_linux"

$MUSCLE_URL = "https://github.com/rcedgar/muscle"
$MUSCLE_COMMIT = "cfc3eeedb98fa9cc9bd5b32c2edad95ae0416725"

if ($IsWindows) {
    $USEARCH_URL = "https://github.com/rcedgar/usearch12/releases/download/v12.0-beta1/usearch_win_12.0-beta.exe"
} elseif ($IsLinux) {
    $USEARCH_URL = "https://github.com/rcedgar/usearch12/releases/download/v12.0-beta1/usearch_linux_x86_12.0-beta"
}