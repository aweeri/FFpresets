@echo off
setlocal

:: Check for FFmpeg dependency
where ffmpeg >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo FFmpeg is not installed or not found in the system PATH.
    echo Please install it via winget by running the following command in a terminal:
    echo winget install -e --id Gyan.FFmpeg
    pause
    exit /b
)

:: Verify a file was passed
if "%~1"=="" (
    echo No input file specified.
    pause
    exit /b
)

:: No touchy this one
set "INPUT_FILE=%~1"
set "OUTPUT_DIR=%~dp1"
set "FILENAME=%~n1"
set "EXT=%~x1"

:: --- PRESET CONFIGURATION ---
:: Increment this number when adding a new preset
set "PRESET_COUNT=5"

set "PRESET_1_NAME=Extract Audio to MP3 (VBR)"
set "PRESET_1_SUFFIX=_audio.mp3"
set "PRESET_1_ARGS=-vn -c:a libmp3lame -q:a 2"

set "PRESET_2_NAME=Optimal H.264 (Original Res, Medium Preset, CRF 21)"
set "PRESET_2_SUFFIX=_optimal_orig.mp4"
set "PRESET_2_ARGS=-c:v libx264 -preset medium -crf 21 -pix_fmt yuv420p -c:a aac -b:a 192k"

set "PRESET_3_NAME=Optimal H.264 (FHD 1080p, Medium Preset, CRF 21)"
set "PRESET_3_SUFFIX=_optimal_1080p.mp4"
set "PRESET_3_ARGS=-vf scale=-2:1080 -c:v libx264 -preset medium -crf 21 -pix_fmt yuv420p -c:a aac -b:a 192k"

set "PRESET_4_NAME=Optimal H.264 (HD 720p, Medium Preset, CRF 21)"
set "PRESET_4_SUFFIX=_optimal_720p.mp4"
set "PRESET_4_ARGS=-vf scale=-2:720 -c:v libx264 -preset medium -crf 21 -pix_fmt yuv420p -c:a aac -b:a 192k"

set "PRESET_5_NAME=Strong Compression (H.264, CRF 28, 96k Audio)"
set "PRESET_5_SUFFIX=_compressed.mp4"
set "PRESET_5_ARGS=-c:v libx264 -preset slow -crf 28 -pix_fmt yuv420p -c:a aac -b:a 96k"

:: ----------------------------

:: Embed PowerShell to handle menu
set "PSCMD=$count=[int]$env:PRESET_COUNT; $ops=@(); for($i=1; $i -le $count; $i++){ $ops += [Environment]::GetEnvironmentVariable('PRESET_' + $i + '_NAME') }; $sel=0; try { [Console]::CursorVisible=$false } catch {}; $pos=$Host.UI.RawUI.CursorPosition; while($true){ $Host.UI.RawUI.CursorPosition=$pos; Write-Host '========================================================'; Write-Host 'FFpresets'; Write-Host ('Input: ' + $env:FILENAME + $env:EXT); Write-Host '========================================================'; for($i=0; $i -lt $ops.Length; $i++){ if($i -eq $sel){ Write-Host ('[X] ' + $ops[$i]) -ForegroundColor Cyan }else{ Write-Host ('[ ] ' + $ops[$i]) } }; Write-Host '========================================================'; $key=$Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown').VirtualKeyCode; if($key -eq 38 -and $sel -gt 0){ $sel-- }elseif($key -eq 40 -and $sel -lt ($ops.Length-1)){ $sel++ }elseif($key -eq 13){ break } }; try { [Console]::CursorVisible=$true } catch {}; exit ($sel+1)"
powershell -NoProfile -Command "%PSCMD%"

set "SEL=%ERRORLEVEL%"
if %SEL% equ 0 goto end

:: Dynamically evaluate and construct the execution command based on the selection
call set "OUT_SUFFIX=%%PRESET_%SEL%_SUFFIX%%"
call set "FF_ARGS=%%PRESET_%SEL%_ARGS%%"

set "OUTPUT_FILE=%OUTPUT_DIR%%FILENAME%%OUT_SUFFIX%"
ffmpeg -i "%INPUT_FILE%" %FF_ARGS% "%OUTPUT_FILE%"
goto end

:end
echo.
echo Operation finished.
pause