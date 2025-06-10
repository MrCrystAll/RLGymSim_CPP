@echo off
setlocal

set "ARCHIVE_PATH=%~1"
set "EXTRACT_DIR=%~2"

if "%ARCHIVE_PATH%"=="" (
    echo Usage: download_extract.bat ^<ARCHIVE_PATH^> ^<EXTRACT_DIR^>
    exit /b 1
)

if "%EXTRACT_DIR%"=="" (
    echo Usage: download_extract.bat ^<ARCHIVE_PATH^> ^<EXTRACT_DIR^>
    exit /b 1
)

if not exist "%ARCHIVE_PATH%" (
    echo Archive not found: %ARCHIVE_PATH%
    exit /b 1
)

if not exist "%EXTRACT_DIR%" mkdir "%EXTRACT_DIR%"

for %%F in ("%ARCHIVE_PATH%") do (
    set "FILENAME=%%~nxF"
    set "EXT=%%~xF"
)

call :check_tar_gz "%FILENAME%"
if errorlevel 1 (
    if /I "%EXT%"==".zip" (
        powershell -Command "Expand-Archive -Path '%ARCHIVE_PATH%' -DestinationPath '%EXTRACT_DIR%' -Force"
    ) else (
        echo Unsupported archive format: %ARCHIVE_PATH%
        exit /b 1
    )
) else (
    powershell -Command "tar -xzf '%ARCHIVE_PATH%' -C '%EXTRACT_DIR%'"
)
goto :eof

:check_tar_gz
setlocal
set "NAME=%~1"
if /I "%NAME:~-7%"==".tar.gz" (
    endlocal & exit /b 0
) else (
    endlocal & exit /b 1
)

endlocal
