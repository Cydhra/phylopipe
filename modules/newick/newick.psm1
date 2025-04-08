using module ..\util

class Newick {
    static [string] wsl_newick_path() {
        return [Util]::wsl_path([System.IO.Path]::Combine($PSScriptRoot, "newick"))
    }

    # Compare two trees using the Robinson-Foulds metric.
    # Returns three values: the absolute RF distance, the maximum RF distance possible between the trees,
    # and the normalized RF distance (between 0 and 1).
    static [Object[]] robinson_foulds([string]$tree1, [string]$tree2) {
        $wsl_tree1 = [Util]::wsl_path($tree1)
        $wsl_tree2 = [Util]::wsl_path($tree2)

        $newick_path = [Newick]::wsl_newick_path()

        $allOutput = $null # modules may not use uninitialized variables
        (wsl $newick_path -rofo $wsl_tree1 -tree2 $wsl_tree2) 2>&1 | tee -Variable allOutput
        $stderr = $allOutput | ?{ $_ -is [System.Management.Automation.ErrorRecord] } | Select-Object -Last 1

        if ($stderr -match "^RF = (\d+) / (\d+), (\-?\d+(\.\d+)?)") {
            return $Matches[1], $Matches[2], $Matches[3]
        } else {
            Write-Host "Error comparing trees: $stderr"
            return $null
        }
    }

    # convert a newick tree to a TSV file
    static [void] newick2tsv([string]$path, [string]$output) {
        $newick_path = [Newick]::wsl_newick_path()
        $wsl_path = [Util]::wsl_path($path)
        $wsl_output = [Util]::wsl_path($output)
        (wsl $newick_path -newick2tsv $wsl_path -output $wsl_output) *> $null
    }

    # Compare a tree to a taxonomy given as a feature file
    static [void] tax([string]$tree, [string]$feature_file, [string]$output_file) {
        $wsl_tree = [Util]::wsl_path($tree)
        $wsl_feature_file = [Util]::wsl_path($feature_file)
        $wsl_output_file = [Util]::wsl_path($output_file)
        $newick_path = [Newick]::wsl_newick_path()

        (wsl dos2unix $wsl_feature_file) *> $null
        (wsl $newick_path -tax $wsl_tree -features $wsl_feature_file -fevout $wsl_output_file) *> $null
    }

    # Extract the subtrees of all nodes that are identified to be the LCA nodes of the features in the given feature file.
    static [void] lca_subtrees([string]$tree, [string]$feature_file, [string]$output_file) {
        $wsl_tree = [Util]::wsl_path($tree)
        $wsl_feature_file = [Util]::wsl_path($feature_file)
        $wsl_output_file = [Util]::wsl_path($output_file)
        $newick_path = [Newick]::wsl_newick_path()

        (wsl dos2unix $wsl_feature_file) *> $null
        (wsl $newick_path -getlcasubtrees $wsl_tree -features $wsl_feature_file -fevout $wsl_output_file) *> $null
    }

    # Condense a given tree using the taxonomic features in the given feature file.
    # Newick will attempt to find the LCA nodes for each feature, and then condense the tree so its leaves
    # correspond to the identified LCA nodes.
    static [void] condense([string]$tree, [string]$feature_file, [string]$output_file) {
        $wsl_tree = [Util]::wsl_path($tree)
        $wsl_feature_file = [Util]::wsl_path($feature_file)
        $wsl_output_file = [Util]::wsl_path($output_file)
        $newick_path = [Newick]::wsl_newick_path()

        (wsl dos2unix $wsl_feature_file) *> $null
        (wsl $newick_path -condense $wsl_tree -features $wsl_feature_file -output $wsl_output_file) *> $null
    }
}