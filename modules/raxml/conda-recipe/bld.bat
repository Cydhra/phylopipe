@echo off

if not exist "%PREFIX%\Scripts" mkdir "%PREFIX%\Scripts"

copy "%SRC_DIR%\bin\raxml-ng" "%PREFIX%\Scripts\raxml-ng-2"
copy "%SRC_DIR%\raxml-ng.bat" "%PREFIX%\Scripts\raxml-ng.bat"
if errorlevel 1 exit 1