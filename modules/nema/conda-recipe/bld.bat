@echo off

if not exist "%PREFIX%\Scripts" mkdir "%PREFIX%\Scripts"

copy "%SRC_DIR%\bin\nema.exe" "%PREFIX%\Scripts\nema.exe"
if errorlevel 1 exit 1