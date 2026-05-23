@echo off
title Windows 10 Context Menu Manager [Debug Mode]
cd /d "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0ContextMenuManager.ps1"
pause
