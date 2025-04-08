class Util {
    # Convert a windows-style path into a WSL compatible path
    static [string] wsl_path([string]$path) {
        return (wsl wslpath -a "'$path'")
    }
}