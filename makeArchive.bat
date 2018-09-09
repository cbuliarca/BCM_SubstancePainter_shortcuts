@echo OFF
set "curpath=%cd%"

"C:\Program Files\WinRAR\Rar.exe" a -r -x*.psd -x*video -x*helpers -x*.git -x*.ahk -x*.gitignore -x*.bat qAct.rar 

pause