using module ..\util

class Raxml {
    static [string] raxml_path() {
        return [Util]::wsl_path("$PSScriptRoot\raxml-ng-2")
    }

    static [void] consensus([string]$tree_file, [string]$prefix) {
        $raxml_path = [Raxml]::raxml_path()
        $wsl_tree_file = [Util]::wsl_path($tree_file)
        $wsl_prefix = [Util]::wsl_path($prefix)

        wsl $raxml_path --consense --tree "$wsl_tree_file" --prefix "$wsl_prefix"
    }

    static [void] rf_dist([string]$tree_file, [string]$prefix) {
        $raxml_path = [Raxml]::raxml_path()
        $wsl_tree_file = [Util]::wsl_path($tree_file)
        $wsl_prefix = [Util]::wsl_path($prefix)

        wsl $raxml_path --rfdist --tree "$wsl_tree_file" --prefix "$wsl_prefix"
    }

    static [void] rf_dist_list([string[]]$tree_files, [string]$prefix) {
        $raxml_path = [Raxml]::raxml_path()
        $wsl_prefix = [Util]::wsl_path($prefix)

        $wsl_tree_pattern = ($tree_files | % { [Util]::wsl_path($_) }) -join ","

        wsl $raxml_path --rfdist --tree "$wsl_tree_pattern" --prefix "$wsl_prefix"
    }
}