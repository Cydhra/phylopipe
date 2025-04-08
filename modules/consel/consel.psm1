using module ..\util

class Consel {
    static [string] wsl_makermt_path() {
        return [Util]::wsl_path([System.IO.Path]::Combine($PSScriptRoot, "bin", "makermt"))
    }

    static [string] wsl_consel_path() {
        return [Util]::wsl_path([System.IO.Path]::Combine($PSScriptRoot, "bin", "consel"))
    }

    static [void] make_rmt([string]$sitelh_file) {
        $wsl_sitelh_file = [Util]::wsl_path($sitelh_file)
        $wsl_makermt_path = [Consel]::wsl_makermt_path()

        wsl $wsl_makermt_path --puzzle $wsl_sitelh_file
    }
}