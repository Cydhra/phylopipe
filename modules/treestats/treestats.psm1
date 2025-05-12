class Treestats {

    static [string] r_script_path() {
        return [System.IO.Path]::Combine("$PSScriptRoot", "R", "bin", "Rscript.exe")
    }

    static [string] mpd_script_path() {
        return [System.IO.Path]::Combine("$PSScriptRoot", "mpd.R")
    }

    # Calculate the mean pairwise distance (MPD) for all trees in a file.
    static [double[]] mpd([string]$tree_file) {
        $values = & ([Treestats]::r_script_path()) ([Treestats]::mpd_script_path()) $tree_file 2> $null
        return $values
    }
}