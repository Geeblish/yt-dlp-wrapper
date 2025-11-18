@echo off
setlocal
set "OUTDIR=%cd%\output"
if not exist "%OUTDIR%" mkdir "%OUTDIR%"

:start
cls

:quality
cls
echo Choose the download preset: 
echo [1] High
echo [2] Medium
echo [3] MP3
echo [4] Captions (.mkv)
set /p MODE="selection> "

rem normalize
if /I "%MODE%"=="high" set "MODE=1"
if /I "%MODE%"=="medium" set "MODE=2"
if /I "%MODE%"=="mp3" set "MODE=3"
if /I "%MODE%"=="caption" set "MODE=4"

if "%MODE%"=="1" goto :link
if "%MODE%"=="2" goto :link
if "%MODE%"=="3" goto :link
if "%MODE%"=="4" goto :link

echo.
echo ======================================
echo == choose 1, 2, 3, or 4             ==
echo ======================================
echo.
pause
goto :quality


:link
set /p URL="Input the URL> "
if not defined URL goto :link

set qual=""

if "%MODE%"=="1" set "qual=high" & goto :high
if "%MODE%"=="2" set "qual=medium" & goto :medium
if "%MODE%"=="3" set "qual=mp3" & goto :mp3
if "%MODE%"=="4" set "qual=captions" & goto :captions



:high
cls
yt-dlp -f "bv*+ba/b" --merge-output-format mp4 -o "%OUTDIR%\%%(title)s [%qual%]\%%(title)s.%%(ext)s" "%URL%" --live-from-start
echo. 
echo Saved in "%OUTDIR%" as "%%(title)s.%%(ext)s"
goto :done

:medium
cls
yt-dlp -f "bv*[height<=720]+ba/b[height<=720]" --merge-output-format mp4 -o "%OUTDIR%\%%(title)s [%qual%]\%%(title)s.%%(ext)s" "%URL%" --live-from-start -N 6
goto :done

:mp3
cls
yt-dlp -x --audio-format mp3 -o "%OUTDIR%\%%(title)s [%qual%]\%%(title)s.%%(ext)s" "%URL%" --live-from-start -N 6
goto :done

:captions
cls
yt-dlp -f "bv*+ba/b" --merge-output-format mkv --write-auto-sub --sub-langs "en,en-orig" --sub-format srt --convert-subs srt --embed-subs --sub-langs "en.*" -o "%OUTDIR%\%%(title)s [%qual%]\%%(title)s.%%(ext)s" "%URL%" --live-from-start -N 6
goto :done

:done

echo. 
echo Saved in "%OUTDIR%" 
echo Want to download another one? 
set /p another="[y/n]> "
if "%another%"=="y" goto :start
cls
echo returning to eop...
pause >nul
echo 