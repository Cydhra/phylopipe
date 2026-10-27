@ECHO OFF

REM Wrapper script to call a binary via wsl, the binary is being determined by the filename of this template

FOR /f "tokens=*" %%a IN (
'wsl wslpath -a '%~dp0''
) DO (
SET pth=%%a
)
wsl "%pth%/_%~n0" %*