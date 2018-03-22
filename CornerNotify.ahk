;---------------------------------------------------------------
; CornerNotify.ahk
; http://www.autohotkey.com/board/topic/94458-msgbox-replacement-monolog-non-modal-transparent-message-box-cornernotify/

;---------------------------------------------------------------
; CHANGELOG

; v1.1 2013-06-19
; added optional position argument that calls WinMove function from user "Learning One"
; position argument syntax is to create a string containing the following:
; t=top, vc= vertical center, b=bottom
; l=left, hc=horizontal center, r=right

;---------------------------------------------------------------

CornerNotify(secs, title, message, position="b r", isError=0) {
	CornerNotify_Create(title, message, position, isError)
  millisec := secs*1000.00
  ;MsgBox, %millisec%
  ;SetTimer, CornerNotifyBeginFadeOut, %millisec%
	SetTimer, CornerNotifyBeginFadeOut, %millisec%
}

CornerNotify_Create(title, message, position="b r", isError=0) {
	global cornernotify_title, cornernotify_msg, w, curtransp, cornernotify_hwnd, cornernotify_isError
	CornerNotify_Destroy() ; make sure an old instance isn't still running or fading out
	Gui, 2:+AlwaysOnTop +ToolWindow -SysMenu -Caption +LastFound
	cornernotify_hwnd := WinExist()
	WinSet, ExStyle, +0x20 ; WS_EX_TRANSPARENT make the window transparent-to-mouse
	WinSet, Transparent, 160
	curtransp := 160
	Gui, 2:Color, 202020 ;background color
	;Gui, 2:Font, cF0F0F0 s17 wbold, Arial
    if (isError == 1)
    {
        Gui, 2:Font, cFF6060 s17 wbold, Arial
    }
    else{
        Gui, 2:Font, cF0F0F0 s17 wbold, Arial
    }

	Gui, 2:Add, Text, Center x20 y12 w300 vcornernotify_title, %title%
    if (isError == 1)
    {
        Gui, 2:Font, cFF6060 s15 wnorm
    }
    else{
        Gui, 2:Font, cF0F0F0 s15 wnorm
    }
	Gui, 2:Add, Text, x20 y100 w400 vcornernotify_msg, %message%
	Gui, 2:Show, NoActivate W700
	WinMove(cornernotify_hwnd, position, title)
	Return
}

;CornerNotify_ModifyTitle(title) {
;	global cornernotify_title
;	GuiControl,Text,cornernotify_title, %title%
;}

;CornerNotify_ModifyMessage(message, isError) {
;	global cornernotify_msg, cornernotify_isError
;	GuiControl,Text,cornernotify_msg, %message%
;}

CornerNotify_Destroy() {
	global curtransp
	curtransp := 0
	Gui, 2:Destroy
	SetTimer, CornerNotify_FadeOut_Destroy, Off
}

CornerNotifyBeginFadeOut:
	SetTimer, CornerNotifyBeginFadeOut, Off
	SetTimer, CornerNotify_FadeOut_Destroy, 10
Return

CornerNotify_FadeOut_Destroy:
	If(curtransp > 0) {
		curtransp := curtransp - 4
		WinSet, Transparent, %curtransp%, ahk_id %cornernotify_hwnd%
	} Else {
		Gui, 2: Destroy
		SetTimer, CornerNotify_FadeOut_Destroy, Off
	}
Return

;---------------------------------------------------------------
; Modification of WinMove function by Learning One (http://www.autohotkey.com/board/topic/72630-gui-bottom-right/#entry461385)

; position argument syntax is to create a string with the following:
; t=top, vc= vertical center, b=bottom
; l=left, hc=horizontal center, r=right

WinMove(hwnd,position, title) {   ; by Learning one

   mntNb := GetMonitorUnderMouse()
   ;MsgBox, %mntNb%
   ;SysGet, Mon, MonitorWorkArea
   SysGet, Mon, Monitor, %mntNb%

   ;MsgBox, Left: %MonLeft% -- Top: %MonTop% -- Right: %MonRight% -- Bottom %MonBottom%.
   WinMove,,,,, 360, 100
   WinGetPos,ix,iy,w,h, ahk_id %hwnd%
   x := InStr(position,"l") ? MonLeft : InStr(position,"hc") ?  (( MonLeft + MonRight )-w)/2 : InStr(position,"r") ? MonRight - w : ix
   y := InStr(position,"t") ? MonTop : InStr(position,"vc") ?  (MonBottom-h)/4 : InStr(position,"b") ? MonBottom - h : iy
   WinMove, ahk_id %hwnd%,,x,y
}

;---------------------------------------------------------------
GetMonitorUnderMouse()
{
    CoordMode, Mouse, Screen
    MouseGetPos, x, y
    SysGet, Mon1, Monitor, 1
    SysGet, Mon2, Monitor, 2


    ;if(Mon2Left < 0)
    ;{
    ;	; this measn tahat the monitors are swaped
    ;	x := x + Mon2Left
    ;}
    ;MsgBox %x%
    ;MsgBox, Left: %Mon1Left% -- Top: %Mon1Top% -- Right: %Mon1Right% -- Bottom: %Mon1Bottom% -- x: %x%.
    ;MsgBox, Left: %Mon2Left% -- Top: %Mon2Top% -- Right: %Mon2Right% -- Bottom: %Mon2Bottom% -- x: %x%.

    ;tr := 1
    if( x >= Mon1Left )
    {
    	if(x <= Mon1Right )
    	{
    		tr := 1
    	}
    }

    if (x >= Mon2Left)
    {
    	if(	x <= Mon2Right)
    	{
    		tr := 2
    	}
    }
    CoordMode Mouse, relative
    return tr
        
}