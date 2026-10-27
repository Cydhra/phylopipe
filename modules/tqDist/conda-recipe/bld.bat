@echo off

if not exist "%PREFIX%\Scripts" mkdir "%PREFIX%\Scripts"

copy "%SRC_DIR%\bin\all_pairs_quartet_dist" "%PREFIX%\Scripts\_all_pairs_quartet_dist"
copy "%SRC_DIR%\bin\all_pairs_triplet_dist" "%PREFIX%\Scripts\_all_pairs_triplet_dist"
copy "%SRC_DIR%\bin\pairs_quartet_dist" "%PREFIX%\Scripts\_pairs_quartet_dist"
copy "%SRC_DIR%\bin\pairs_triplet_dist" "%PREFIX%\Scripts\_pairs_triplet_dist"
copy "%SRC_DIR%\bin\quartet_dist" "%PREFIX%\Scripts\_quartet_dist"
copy "%SRC_DIR%\bin\triplet_dist" "%PREFIX%\Scripts\_triplet_dist"

copy "%SRC_DIR%\template.bat" "%PREFIX%\Scripts\all_pairs_quartet_dist.bat"
copy "%SRC_DIR%\template.bat" "%PREFIX%\Scripts\all_pairs_triplet_dist.bat"
copy "%SRC_DIR%\template.bat" "%PREFIX%\Scripts\pairs_quartet_dist.bat"
copy "%SRC_DIR%\template.bat" "%PREFIX%\Scripts\pairs_triplet_dist.bat"
copy "%SRC_DIR%\template.bat" "%PREFIX%\Scripts\quartet_dist.bat"
copy "%SRC_DIR%\template.bat" "%PREFIX%\Scripts\triplet_dist.bat"
if errorlevel 1 exit 1