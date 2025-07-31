<#
.SYNOPSIS
Converts a path to a linux-compatible path.

.DESCRIPTION
Converts a path to a WSL-compatible path on windows, and leaves it as is on Linux.
This prepares the path to be used in a linux environment natively accessible by the platform,
but it cannot be used to prepare paths on windows to be used natively in a linux environment remotely.

.PARAMETER Path
A native path
#>
function ConvertTo-LinuxPath {
    param (
        [Parameter(Mandatory = $true)]
        [string] $Path
    )

    if (-not $IsLinux -and -not $IsWindows) {
        throw "This command supports only Windows and Linux"
    }

    if ($IsLinux) {
        return $Path
    }

    return (wsl wslpath -a "'$path'")
}

<#
 .SYNOPSIS
 Converts the line endings of a file to unix line endings.

 .DESCRIPTION
 Reads in a file and replaces all occurences of CRLF with LF. The file is read into memory at once and the file
 encoding is not respected, instead it is replaced with the default encoding for the current session. The
 `-Encoding` flag can be set to change the encoding.

 .PARAMETER Path
 A native path

 .PARAMETER Encoding
 If set, the file encoding is set to the desired encoding. If not set, the file encoding is set to the default
 encoding of powershell. In neither case the file encoding of the input file is respected.
#>
function ConvertTo-UnixLineEnding {
    param (
        [Parameter(Mandatory = $true)]
        [string] $Path,

        [Parameter(Mandatory = $false)]
        [string] $Encoding = ""
    )

    $ToReplace = "`r`n"
    $With = "`n"

    if ("" -eq $Encoding) {
        (Get-Content -Raw $Path).Replace($ToReplace, $With) | Set-Content -Path $Path -NoNewline
    } else {
        (Get-Content -Raw $Path).Replace($ToReplace, $With) | Set-Content -Path $Path -NoNewline -Encoding $Encoding
    }
}

<#
.SYNOPSIS
Execute a provided command line on linux.

.DESCRIPTION
Runs a provided executable natively on linux if the current platform is Linux,
or runs it in WSL if the platform is Windows.
Paths provided as parameters need to be converted before calling this function using `ConvertTo-LinuxPath`

.PARAMETER Path
Linux-compatible path to the executable.

.PARAMETER CommandLine
The full command line provided to the executable. Beware that powershell may interpret some arguments differently
than linux shells, so they have to be escaped to be properly passed by the linux shell.
#>
function Invoke-OnLinux {
    param (
        [Parameter(Mandatory = $true)]
        [string] $Path,

        [Parameter(Mandatory = $false, ValueFromRemainingArguments)]
        [string[]] $CommandLine
    )

    if (-not $IsLinux -and -not $IsWindows) {
        throw "This command supports only Windows and Linux"
    }

    if ($IsLinux) {
        return & $Path $CommandLine
    } else {
        return wsl $Path $CommandLine
    }
}