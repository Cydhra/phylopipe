# This script sets up the modules to be available system-wide.
# This is unrelated to the `install.ps1` script which installs software required for the modules to function.

"# Add phylopipe modules to powershell path. Remove below line to uninstall." | Add-Content $profile
"`$env:PSModulePath += `";$PSScriptRoot\modules`"" | Add-Content $profile