@echo off
:loop
setlocal enabledelayedexpansion

rem Define the list of random notes
set "notes[0]=Note 1"
set "notes[1]=Note 2"
set "notes[2]=Note 3"
set "notes[3]=Note 4"
set "notes[4]=Note 5"

rem Generate a random number to select a note
set /a "index=%random% %% 5"

rem Get the current timestamp
for /f "tokens=1-4 delims=/ " %%a in ('echo %date%') do (
    set "yyyy=%%c"
    set "mm=%%a"
    set "dd=%%b"
)
for /f "tokens=1-2 delims=: " %%a in ('echo %time%') do (
    set "hh=%%a"
    set "nn=%%b"
)

rem Create the note file
echo %notes[%index%]% > "Note_%yyyy%-%mm%-%dd%_%hh%-%nn%.txt"

rem Delay for 5 minutes
timeout /t 300 >nul

goto :loop
