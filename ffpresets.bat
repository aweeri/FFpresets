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
set "TAB_COUNT=6"
  
:: --- TAB 1: Compatibility & Web ---
set "TAB_1_NAME=Compatibility & Web"
set "TAB_1_PRESET_COUNT=4"
  
set "T1_P1_NAME=FHD (8-bit, Strong Compression)"
set "T1_P1_SUFFIX=_fhd_compat.mp4"
set "T1_P1_ARGS=-vf scale=-2:1080 -c:v libx264 -preset slow -crf 28 -profile:v high -pix_fmt yuv420p -c:a aac -b:a 128k"
  
set "T1_P2_NAME=HD (8-bit, Strong Compression)"
set "T1_P2_SUFFIX=_hd_compat.mp4"
set "T1_P2_ARGS=-vf scale=-2:720 -c:v libx264 -preset slow -crf 28 -profile:v high -pix_fmt yuv420p -c:a aac -b:a 128k"
  
set "T1_P3_NAME=SD (8-bit, Strong Compression)"
set "T1_P3_SUFFIX=_sd_compat.mp4"
set "T1_P3_ARGS=-vf scale=-2:480 -c:v libx264 -preset slow -crf 28 -profile:v main -pix_fmt yuv420p -c:a aac -b:a 96k"
  
set "T1_P4_NAME=Original Resolution WebM (Optimal Compression)"
set "T1_P4_SUFFIX=_web.webm"
set "T1_P4_ARGS=-c:v libvpx-vp9 -crf 30 -b:v 0 -c:a libopus -b:a 128k"
  
:: --- TAB 2: Generic H.264 ---
set "TAB_2_NAME=Generic H.264"
set "TAB_2_PRESET_COUNT=4"
  
set "T2_P1_NAME=Original Resolution (Optimal Compression)"
set "T2_P1_SUFFIX=_h264_opt.mp4"
set "T2_P1_ARGS=-c:v libx264 -preset medium -crf 23 -pix_fmt yuv420p -c:a aac -b:a 192k"
  
set "T2_P2_NAME=Original Resolution (Strong Compression)"
set "T2_P2_SUFFIX=_h264_strong.mp4"
set "T2_P2_ARGS=-c:v libx264 -preset slow -crf 28 -pix_fmt yuv420p -c:a aac -b:a 128k"
  
set "T2_P3_NAME=Full HD (Optimal Compression)"
set "T2_P3_SUFFIX=_h264_fhd.mp4"
set "T2_P3_ARGS=-vf scale=-2:1080 -c:v libx264 -preset medium -crf 23 -pix_fmt yuv420p -c:a aac -b:a 192k"
  
set "T2_P4_NAME=HD (Optimal Compression)"
set "T2_P4_SUFFIX=_h264_hd.mp4"
set "T2_P4_ARGS=-vf scale=-2:720 -c:v libx264 -preset medium -crf 23 -pix_fmt yuv420p -c:a aac -b:a 192k"
  
:: --- TAB 3: Generic HEVC ---
set "TAB_3_NAME=Generic HEVC"
set "TAB_3_PRESET_COUNT=4"
  
set "T3_P1_NAME=Original Resolution (Optimal Compression)"
set "T3_P1_SUFFIX=_hevc_opt.mp4"
set "T3_P1_ARGS=-c:v libx265 -preset medium -crf 26 -pix_fmt yuv420p -c:a aac -b:a 192k"
  
set "T3_P2_NAME=Original Resolution (Strong Compression)"
set "T3_P2_SUFFIX=_hevc_strong.mp4"
set "T3_P2_ARGS=-c:v libx265 -preset slow -crf 30 -pix_fmt yuv420p -c:a aac -b:a 128k"
  
set "T3_P3_NAME=Full HD (Optimal Compression)"
set "T3_P3_SUFFIX=_hevc_fhd.mp4"
set "T3_P3_ARGS=-vf scale=-2:1080 -c:v libx265 -preset medium -crf 26 -pix_fmt yuv420p -c:a aac -b:a 192k"
  
set "T3_P4_NAME=HD (Optimal Compression)"
set "T3_P4_SUFFIX=_hevc_hd.mp4"
set "T3_P4_ARGS=-vf scale=-2:720 -c:v libx265 -preset medium -crf 26 -pix_fmt yuv420p -c:a aac -b:a 192k"
  
:: --- TAB 4: Audio Handling ---
set "TAB_4_NAME=Audio Handling"
set "TAB_4_PRESET_COUNT=4"
  
set "T4_P1_NAME=Extract Audio (MP3)"
set "T4_P1_SUFFIX=_audio.mp3"
set "T4_P1_ARGS=-vn -c:a libmp3lame -q:a 2"
  
set "T4_P2_NAME=Extract Audio (WAV)"
set "T4_P2_SUFFIX=_audio.wav"
set "T4_P2_ARGS=-vn -c:a pcm_s16le"
  
set "T4_P3_NAME=Remove Audio (Wipes all tracks)"
set "T4_P3_SUFFIX=_silent.mp4"
set "T4_P3_ARGS=-c:v copy -an"
  
set "T4_P4_NAME=Normalize Audio (Loudness)"
set "T4_P4_SUFFIX=_norm.mp4"
set "T4_P4_ARGS=-c:v copy -af loudnorm -c:a aac -b:a 192k"
  
:: --- TAB 5: Utility Tools ---
set "TAB_5_NAME=Utility Tools"
set "TAB_5_PRESET_COUNT=5"
  
set "T5_P1_NAME=Extract Thumbnail (First Frame)"
set "T5_P1_SUFFIX=_thumb.jpg"
set "T5_P1_ARGS=-vframes 1 -q:v 2"
  
set "T5_P2_NAME=Convert to GIF (Strong Compression)"
set "T5_P2_SUFFIX=_anim.gif"
set "T5_P2_ARGS=-vf "fps=12,scale=480:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse=dither=bayer:bayer_scale=5" -loop 0"
  
set "T5_P3_NAME=Rotate Left (Rotate by 90 degrees)"
set "T5_P3_SUFFIX=_rot_left.mp4"
set "T5_P3_ARGS=-vf transpose=2 -c:a copy"
  
set "T5_P4_NAME=Rotate Right (Rotate by 90 degrees)"
set "T5_P4_SUFFIX=_rot_right.mp4"
set "T5_P4_ARGS=-vf transpose=1 -c:a copy"
  
set "T5_P5_NAME=Turn Upside-Down (Rotate by 180 degrees)"
set "T5_P5_SUFFIX=_rot_180.mp4"
set "T5_P5_ARGS=-vf "transpose=2,transpose=2" -c:a copy"
  
:: --- TAB 6: Advanced ---
set "TAB_6_NAME=Advanced"
set "TAB_6_PRESET_COUNT=5"
  
set "T6_P1_NAME=AV1 (Original Resolution)"
set "T6_P1_SUFFIX=_av1.mkv"
set "T6_P1_ARGS=-c:v libaom-av1 -crf 30 -b:v 0 -strict experimental -c:a libopus -b:a 128k"
  
set "T6_P2_NAME=DNxHR (10-bit intermediary)"
set "T6_P2_SUFFIX=_dnxhr.mov"
set "T6_P2_ARGS=-c:v dnxhd -profile:v dnxhr_hqx -pix_fmt yuv422p10le -c:a pcm_s16le"
  
set "T6_P3_NAME=HEVC 10-bit (Main10)"
set "T6_P3_SUFFIX=_hevc10.mp4"
set "T6_P3_ARGS=-c:v libx265 -preset medium -crf 26 -pix_fmt yuv420p10le -c:a aac -b:a 192k"
  
set "T6_P4_NAME=Apple ProRes (HQ/422)"
set "T6_P4_SUFFIX=_prores.mov"
set "T6_P4_ARGS=-c:v prores_ks -profile:v 3 -vendor apl0 -pix_fmt yuv422p10le -c:a pcm_s16le"
  
set "T6_P5_NAME=FFV1 (Lossless Archival)"
set "T6_P5_SUFFIX=_ffv1.mkv"
set "T6_P5_ARGS=-c:v ffv1 -level 3 -g 1 -c:a flac"
  
:: ----------------------------

:: Embed PowerShell to handle menu
set "PSCMD=$W=80; $sep='='*$W; $clr=' '*$W; $tabs=@(); for($t=1; $t -le [int]$env:TAB_COUNT; $t++){ $pCount=[int][Environment]::GetEnvironmentVariable('TAB_'+$t+'_PRESET_COUNT'); $p=@(); for($i=1; $i -le $pCount; $i++){ $p += @{Id=('T'+$t+'_P'+$i); Name=[Environment]::GetEnvironmentVariable('T'+$t+'_P'+$i+'_NAME')} }; $tabs += @{Name=[Environment]::GetEnvironmentVariable('TAB_'+$t+'_NAME'); Exp=$false; Presets=$p} }; $sel=0; try { [Console]::CursorVisible=$false } catch {}; Clear-Host; $pos=$Host.UI.RawUI.CursorPosition; while($true){ $disp=@(); foreach($tab in $tabs){ $tPfx=if($tab.Exp){'[-] '}else{'[+] '}; $disp += @{Type='Tab'; Text=($tPfx+$tab.Name); Ref=$tab}; if($tab.Exp){ foreach($pr in $tab.Presets){ $disp += @{Type='Preset'; Text='    [ ] '+$pr.Name; Ref=$pr} } } }; if($sel -ge $disp.Length){$sel=$disp.Length-1}elseif($sel -lt 0){$sel=0}; $Host.UI.RawUI.CursorPosition=$pos; Write-Host $sep; Write-Host ('FFpresets - Up/Down to navigate, Enter to toggle/select').PadRight($W); Write-Host ('Input: ' + $env:FILENAME + $env:EXT).PadRight($W); Write-Host $sep; for($i=0; $i -lt $disp.Length; $i++){ $it=$disp[$i]; $pfx=if($i -eq $sel){'>'}else{' '}; $txt=$it.Text; if($it.Type -eq 'Preset' -and $i -eq $sel){$txt=$txt.Replace('[ ]','[X]')}; $line=(' '+$pfx+' '+$txt); if($line.Length -gt $W){$line=$line.Substring(0,$W)}else{$line=$line.PadRight($W)}; if($i -eq $sel){ Write-Host $line -F Black -B Cyan }else{ $fg=if($it.Type -eq 'Tab'){'Yellow'}else{'White'}; Write-Host $line -F $fg -B Black } }; Write-Host $sep; for($c=0; $c -lt 8; $c++){ Write-Host $clr }; $key=$Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown').VirtualKeyCode; if($key -eq 38){$sel--}elseif($key -eq 40){$sel++}elseif($key -eq 13){ $tgt=$disp[$sel]; if($tgt.Type -eq 'Tab'){ $tgt.Ref.Exp = -not $tgt.Ref.Exp }elseif($tgt.Type -eq 'Preset'){ [IO.File]::WriteAllText($env:TEMP+'\ffp_sel.txt', $tgt.Ref.Id); break } }elseif($key -eq 27){ break } }; try { [Console]::CursorVisible=$true; Clear-Host } catch {};"

:: Embed PowerShell for confirmation menu
set "PSCONF=$W=80; $sep='='*$W; $clr=' '*$W; $opts=@('Run (Pretty)','Run (Verbose)','Return'); $sel=0; try { [Console]::CursorVisible=$false } catch {}; Clear-Host; $pos=$Host.UI.RawUI.CursorPosition; while($true){ $Host.UI.RawUI.CursorPosition=$pos; Write-Host $sep; Write-Host ('FFpresets - Confirm Execution').PadRight($W); Write-Host $sep; Write-Host ('Command about to be run:').PadRight($W) -F Yellow; Write-Host $env:CMD_STR -F Cyan; Write-Host $clr; Write-Host ('Select Action:').PadRight($W) -F Yellow; for($i=0; $i -lt $opts.Length; $i++){ $pfx=if($i -eq $sel){'>'}else{' '}; $line=(' '+$pfx+' '+$opts[$i]); if($line.Length -gt $W){$line=$line.Substring(0,$W)}else{$line=$line.PadRight($W)}; if($i -eq $sel){ Write-Host $line -F Black -B Cyan }else{ Write-Host $line -F White -B Black } }; Write-Host $sep; for($c=0; $c -lt 5; $c++){ Write-Host $clr }; $key=$Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown').VirtualKeyCode; if($key -eq 38){$sel--}elseif($key -eq 40){$sel++}elseif($key -eq 13){ [IO.File]::WriteAllText($env:TEMP+'\ffp_act.txt', $opts[$sel]); break }elseif($key -eq 27){ [IO.File]::WriteAllText($env:TEMP+'\ffp_act.txt', 'Return'); break }; if($sel -ge $opts.Length){$sel=$opts.Length-1}elseif($sel -lt 0){$sel=0}; }; try { [Console]::CursorVisible=$true; Clear-Host } catch {};"

:menu
if exist "%TEMP%\ffp_sel.txt" del "%TEMP%\ffp_sel.txt"
if exist "%TEMP%\ffp_act.txt" del "%TEMP%\ffp_act.txt"
powershell -NoProfile -Command "%PSCMD%"

set "SEL_ID="
if exist "%TEMP%\ffp_sel.txt" (
    set /p SEL_ID=<"%TEMP%\ffp_sel.txt"
    del "%TEMP%\ffp_sel.txt"
)

if "%SEL_ID%"=="" goto end

:: Dynamically evaluate and construct the execution command based on the selection
call set "OUT_SUFFIX=%%%SEL_ID%_SUFFIX%%"
call set "FF_ARGS=%%%SEL_ID%_ARGS%%"

set "OUTPUT_FILE=%OUTPUT_DIR%%FILENAME%%OUT_SUFFIX%"
set "CMD_STR=ffmpeg -i "%INPUT_FILE%" %FF_ARGS% "%OUTPUT_FILE%""

:: Show confirmation TUI
powershell -NoProfile -Command "%PSCONF%"

set "ACT_ID="
if exist "%TEMP%\ffp_act.txt" (
    set /p ACT_ID=<"%TEMP%\ffp_act.txt"
    del "%TEMP%\ffp_act.txt"
)

if "%ACT_ID%"=="Return" goto menu
if "%ACT_ID%"=="" goto end

echo.
if "%ACT_ID%"=="Run (Pretty)" (
    echo Starting encode...
    :: Captures frame count and time elapsed from the stats stream
    ffmpeg -hide_banner -loglevel info -stats -i "%INPUT_FILE%" %FF_ARGS% "%OUTPUT_FILE%" 2>&1 | powershell -NoProfile -Command "$regex='frame=\s*(\d+).*time=(\d{2}:\d{2}:\d{2}\.\d{2})'; while($line = [Console]::In.ReadLine()){ if($line -match $regex){ $f=$matches[1]; $t=$matches[2]; Write-Host ('[Encoding] Frames: ' + $f + ' | Time Elapsed: ' + $t) -F Green -NoNewline; Write-Host `r -NoNewline } }"
    echo.
    echo [Done] Operation complete.
) else (
    ffmpeg -i "%INPUT_FILE%" %FF_ARGS% "%OUTPUT_FILE%"
)
goto end

:end
echo.
echo Operation finished.
pause