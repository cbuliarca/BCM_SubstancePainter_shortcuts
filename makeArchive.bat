@echo OFF
::make exe
set "curpath=%cd%"
cd /d "C:\Program Files\AutoHotkey\Compiler"
@echo ON
Ahk2Exe.exe /in %curpath%/qAct.ahk /out %curpath%/qAct.exe

:: go back to this path and make the archive
cd /d %curpath%

"C:\Program Files\WinRAR\Rar.exe" a -r -x*.psd -x*video -x*helpers -x*.git -x*.ahk -x*.gitignore -x*.gif -x*.bat qAct.rar 

pause