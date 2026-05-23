@echo off
:: Request Administrative privileges to modify HKCR
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )

echo Removing FFpresets context menu entries...

:: Delete the registry key and all subkeys silently
reg delete "HKCR\*\shell\FFpresets" /f >nul 2>&1

if %errorlevel% equ 0 (
    echo Context menu registry keys removed.
) else (
    echo Failed to remove registry keys or they were already removed.
)

set "INSTALL_DIR=%ProgramData%\FFpresets"
if exist "%INSTALL_DIR%" (
    echo Removing installed files from %INSTALL_DIR%...
    del /q "%INSTALL_DIR%\ffpresets.bat" 2>nul
    del /q "%INSTALL_DIR%\icon.ico" 2>nul
)

echo Uninstallation complete.
pause
:: Self-delete the uninstall script and its parent folder to prevent locking issues
(goto) 2>nul & cd /d "%TEMP%" & del "%~f0" & rmdir "%INSTALL_DIR%" 2>nul