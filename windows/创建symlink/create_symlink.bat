@echo off
setlocal enabledelayedexpansion

if "%~1"=="" (
    echo [ERROR] Usage: %~nx0 ^<target_directory^>
    echo Create a directory symlink in current directory pointing to target
    exit /b 1
)

set "TARGET_DIR=%~1"

if not exist "%TARGET_DIR%" (
    echo [ERROR] Target directory does not exist: "%TARGET_DIR%"
    exit /b 1
)

pushd "%TARGET_DIR%" 2>nul
if errorlevel 1 (
    echo [ERROR] Cannot access directory: "%TARGET_DIR%"
    exit /b 1
)
set "TARGET_ABS=%CD%"
popd

for %%I in ("%TARGET_ABS%") do set "LINK_NAME=%%~nxI"
set "LINK_PATH=%CD%\%LINK_NAME%"

if exist "%LINK_PATH%" (
    echo [WARN] Symlink exists, removing: "%LINK_PATH%"
    rmdir "%LINK_PATH%" 2>nul
    if exist "%LINK_PATH%" (
        echo [ERROR] Failed to remove existing symlink
        exit /b 1
    )
)

mklink /D "%LINK_PATH%" "%TARGET_ABS%"

if errorlevel 1 (
    echo [ERROR] Failed to create symlink. You may need Administrator privileges or Developer Mode enabled.
    exit /b 1
)

echo [OK] Symlink created: "%LINK_PATH%"
echo      Target: "%TARGET_ABS%"

endlocal
