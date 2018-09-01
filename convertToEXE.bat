@echo OFF
set "curpath=%cd%"
cd /d "C:\Program Files\AutoHotkey\Compiler"

:: echo my current path: %curpath% 
@echo ON
Ahk2Exe.exe /in %curpath%/BCM_substancePainter_shortcuts.ahk /out %curpath%/BCM_substancePainter_shortcuts.exe






pause
