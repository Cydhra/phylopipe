class Treestats {

    static [string] r_script_path() {
        return [System.IO.Path]::Combine("$PSScriptRoot", "R", "bin", "Rscript.exe")
    }

    static [string] function_path() {
        return [System.IO.Path]::Combine("$PSScriptRoot", "exec.R")
    }

    # Calculate the mean pairwise distance (MPD) for all trees in a file.
    static [double[]] mpd([string]$tree_file) {
        $values = & ([Treestats]::r_script_path()) ([Treestats]::function_path()) "mpd" $tree_file 2> $null
        return $values
    }

    # Calculate the treeness (fraction of internal branches) for all trees in a file.
    static [double[]] treeness([string]$tree_file) {
        $values = & ([Treestats]::r_script_path()) ([Treestats]::function_path()) "treeness" $tree_file 2> $null
        return $values
    }

    # Calculate the number of cherries for all trees in a file.
    static [int[]] cherries([string]$tree_file) {
        $values = & ([Treestats]::r_script_path()) ([Treestats]::function_path()) "cherries" $tree_file 2> $null
        return $values
    }

    # Calculate the number of double cherries for all trees in a file.
    static [int[]] double_cherries([string]$tree_file) {
        $values = & ([Treestats]::r_script_path()) ([Treestats]::function_path()) "double_cherries" $tree_file 2> $null
        return $values
    }

    # Calculate the mean branch length for all trees in a file.
    static [double[]] mean_branch_length([string]$tree_file) {
        $values = & ([Treestats]::r_script_path()) ([Treestats]::function_path()) "mean_branch_length" $tree_file 2> $null
        return $values
    }

    # Calculate the number of steps required to turn a tree into a fully imbalanced tree (a caterpillar).
    static [int[]] imbalance([string]$tree_file) {
        $values = & ([Treestats]::r_script_path()) ([Treestats]::function_path()) "imbalance_steps" $tree_file 2> $null
        return $values
    }
}