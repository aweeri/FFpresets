@echo off
:: Request Administrative privileges to write to HKCR
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
pushd "%CD%"
CD /D "%~dp0"

set "INSTALL_DIR=%ProgramData%\FFpresets"
echo Installing files to %INSTALL_DIR%...
if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"

copy /y "ffpresets.bat" "%INSTALL_DIR%\ffpresets.bat" >nul
copy /y "icon.ico" "%INSTALL_DIR%\icon.ico" >nul
copy /y "uninstall.bat" "%INSTALL_DIR%\uninstall.bat" >nul

set "SCRIPT_PATH=%INSTALL_DIR%\ffpresets.bat"
set "ICON_PATH=%INSTALL_DIR%\icon.ico"
echo Registering context menu for %SCRIPT_PATH%...

:: Apply to all files but filter for video types using AppliesTo
reg add "HKCR\*\shell\FFpresets" /ve /d "Convert with FFpresets..." /f
reg add "HKCR\*\shell\FFpresets" /v "Icon" /d "\"%ICON_PATH%\"" /f
reg add "HKCR\*\shell\FFpresets" /v "AppliesTo" /d "kind:=video" /f
reg add "HKCR\*\shell\FFpresets\command" /ve /d "\"%SCRIPT_PATH%\" \"%%1\"" /f

echo.
echo Installation complete. The script can now be run from the right-click menu of any video file.
echo You can now safely delete this downloaded folder.
pause