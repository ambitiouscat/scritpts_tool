@echo off
:: Windows 10 Context Menu Manager Launcher
title Windows 10 Context Menu Manager Launcher
cd /d "%~dp0"

:: If an argument is provided (e.g. debug or /debug), run in foreground debug mode
if not "%~1"=="" (
    cls
    echo ======================================================
    echo     Windows 10 Context Menu Manager - Debug Mode
    echo ======================================================
    echo.
    echo Launching in foreground with console output visible...
    echo.
    powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0ContextMenuManager.ps1"
    echo.
    echo ------------------------------------------------------
    echo Session finished.
    pause
    exit /b
)

:: Run PowerShell script silently in the background
powershell -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "%~dp0ContextMenuManager.ps1"

:: If background launch failed, try running in foreground diagnostic mode
if %errorlevel% neq 0 (
    cls
    echo ======================================================
    echo     Windows 10 Context Menu Manager - Diagnostic Mode
    echo ======================================================
    echo.
    echo Warning: Silent launch failed. 
    echo Launching in foreground mode to capture error output...
    echo.
    powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0ContextMenuManager.ps1"
    echo.
    echo ------------------------------------------------------
    echo Diagnostic session finished.
    pause
)
