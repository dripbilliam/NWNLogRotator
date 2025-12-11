@echo off
setlocal EnableDelayedExpansion
 
echo *** Starting Neverwinter Nights ***
 
:: BOTH WITHOUT QUOTES
:: Your NWN:EE document directory on the next line, the location of your logs directory and nwnplayer.ini
set "EEDocDir=NWN DOCUMENTS FOLDER HERE
:: Your EE nwmain.exe install directory on the next line
set "EEInstallDir=STEAMAPPS NWN WIN32 DIRECTORY HERE
 
set "logdir=%EEDocDir%"
 
 
 
 
 
 
:: --- PRE-LAUNCH LOG ARCHIVE ---
if exist "%logdir%\logs\nwclientLog1.txt" (
    echo Found existing log before launch, archiving...
    call :ArchiveLog
)
 
START "" /WAIT steam://rungameid/704450
 
timeout /t 5 /nobreak > nul
 
:loop
timeout /t 1 /nobreak > nul
tasklist /fi "imagename eq nwmain.exe" | find ":" > nul
if errorlevel 1 goto loop
 
echo *** Neverwinter Nights Terminated ***
echo *** Processing Logs ***
 
:: --- POST-EXIT LOG ARCHIVE ---
if exist "%logdir%\logs\nwclientLog1.txt" (
    call :ArchiveLog
)
 
cd /D "%EEInstallDir%"
".\Neverwinter Nights Enhanced Edition.url"
goto :eof
 
 
:ArchiveLog
    :: get timestamp
    for /f %%i in ('powershell -NoProfile -Command "Get-Date -Format yyyy-MM-dd_HH-mm-ss"') do set "datetime=%%i"
    set "TODAY=!datetime:~0,10!"
    set "NOW=!datetime:~11!"
 
    :: base path without extension
    set "base=%logdir%\logs\log-!TODAY!-!NOW!"
    set "target=!base!.txt"
    set /a n=1
 
    :: if a file with this name already exists, append fixture, ...
    :check_target
    if exist "!target!" (
        set "target=!base!_!n!.txt"
        set /a n+=1
        goto check_target
    )
 
    echo Archiving "%logdir%\logs\nwclientLog1.txt"
    echo   -> "!target!"
    move "%logdir%\logs\nwclientLog1.txt" "!target!" >nul
goto :eof