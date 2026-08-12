@ECHO OFF

REM Wrapper script to call raxml binary (renamed to raxml-ng-2) via wsl on windows.

FOR /f "tokens=*" %%a IN (
'wsl wslpath -a '%~dp0''
) DO (
SET pth=%%a
)
wsl "%pth%/raxml-ng-2" %*