@echo off
title Mining Setup Automation
color 0A

echo =========================================
echo    Mining Setup Automation Script
echo =========================================
echo.

:: Get current directory
set "CURRENT_DIR=%~dp0"

:: Prompt for new worker name
set /p WORKER_NAME="Enter new worker name (will replace 'unmineable_worker_bi7'): "

if "%WORKER_NAME%"=="" (
    echo Error: Worker name cannot be empty!
    pause
    exit /b 1
)

echo.
echo Processing...

:: Update start.cmd with new worker name
if exist "start.cmd" (
    echo Updating start.cmd with new worker name...
    powershell -Command "(Get-Content 'start.cmd') -replace 'worker_bi7', '%WORKER_NAME%' | Set-Content 'start.cmd'"
    echo ✓ start.cmd updated successfully
) else (
    echo Warning: start.cmd not found in current directory
)

:: Check if backg.vbs exists
if not exist "backg.vbs" (
    echo Error: backg.vbs not found in current directory
    echo Please make sure backg.vbs is in the same folder as this script
    pause
    exit /b 1
)

:: Get startup folder path
set "STARTUP_FOLDER=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"

:: Create shortcut using PowerShell
echo Creating shortcut in Startup folder...
powershell -Command "$WshShell = New-Object -comObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%STARTUP_FOLDER%\MiningBackground.lnk'); $Shortcut.TargetPath = '%CURRENT_DIR%backg.vbs'; $Shortcut.WorkingDirectory = '%CURRENT_DIR%'; $Shortcut.Save()"

if exist "%STARTUP_FOLDER%\MiningBackground.lnk" (
    echo ✓ Shortcut created successfully in Startup folder
) else (
    echo Error: Failed to create shortcut
    pause
    exit /b 1
)

echo.
echo =========================================
echo Setup completed successfully!
echo =========================================
echo.
echo Summary:
echo - Worker name updated to: %WORKER_NAME%
echo - Startup shortcut created: MiningBackground.lnk
echo - Mining will start automatically on system boot
echo.

:: Ask user if they want to start mining now
set /p START_NOW="Do you want to start mining now? (Y/N): "

if /i "%START_NOW%"=="Y" (
    echo.
    echo Starting mining in background...
    
    :: Start the background script
    if exist "backg.vbs" (
        cscript //nologo "backg.vbs"
        echo ✓ Mining started in background
        echo.
        echo Mining is now running! Check Task Manager to verify.
    ) else (
        echo Error: backg.vbs not found
    )
) else (
    echo.
    echo Mining setup complete. You can start it manually later or restart the computer.
)

echo.
echo Press any key to exit...
pause >nul