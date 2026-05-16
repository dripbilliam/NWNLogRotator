@echo off
setlocal EnableDelayedExpansion

echo *** Starting Neverwinter Nights ***

:: BOTH WITHOUT QUOTES
:: Your NWN:EE document directory on the next line, the location of your logs directory and nwnplayer.ini
set "EEDocDir=NWN DOCUMENTS FOLDER HERE"
:: Your EE nwmain.exe install directory on the next line
set "EEInstallDir=STEAMAPPS NWN WIN32 DIRECTORY HERE"

set "logdir=%EEDocDir%"


:: --- PRE-LAUNCH LOG ARCHIVE ---
if exist "%logdir%\logs\nwclientLog*.txt" (
    echo Found existing logs before launch, archiving...
    call :ArchiveAllLogs
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
if exist "%logdir%\logs\nwclientLog*.txt" (
    call :ArchiveAllLogs
)

cd /D "%EEInstallDir%"
".\Neverwinter Nights Enhanced Edition.url"
goto :eof


:ArchiveAllLogs
    for %%F in ("%logdir%\logs\nwclientLog*.txt") do (
        if exist "%%~fF" (
            call :ArchiveLog "%%~fF"
        )
    )
goto :eof


:ArchiveLog
    set "src=%~1"

    :: get timestamp
    for /f %%i in ('powershell -NoProfile -Command "Get-Date -Format yyyy-MM-dd_HH-mm-ss"') do set "datetime=%%i"
    set "TODAY=!datetime:~0,10!"
    set "NOW=!datetime:~11!"

    :: keep original log number/name in the archived filename
    set "srcname=%~n1"

    :: base path without extension
    set "base=%logdir%\logs\log-!TODAY!-!NOW!-!srcname!"
    set "target=!base!.txt"
    set /a n=1

    :: if a file with this name already exists, append _1, _2, etc.
    :check_target
    if exist "!target!" (
        set "target=!base!_!n!.txt"
        set /a n+=1
        goto check_target
    )

    echo Archiving "!src!"
    echo   -^> "!target!"
    move "!src!" "!target!" >nul
goto :eof
