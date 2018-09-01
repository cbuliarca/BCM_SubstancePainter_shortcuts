;create window

winSearches( title ) {
  ;WinGet, WinID, ID, ahk_exe Substance Painter.exe,,,
  ;WinGetPos, aX, aY, aW, aH, ahk_id %WinID%

  qq := findPainterWindow( )
  aX := qq.bLeft
  aY := qq.bTop
  aW := qq.bWidth
  aH := qq.bHeight
  w := 760
  bX := aX + ((aW * 0.5) - (w*0.5))
  bY := aY + (aH*0.25)

	winSearches_Create(bX, bY, w, title )
  millisec := secs*1000.00

}

winSearches_Create( sX, sY, sW, stitle) {

	global winSearches_title, winSearches_msg, w, curtranspSS, winSearches_hwnd, winSearches_isError
  global bVar0, bVar1, bVar2, bVar3, bVar4, bVar5, bVar6, bVar7, bVar8, bVar9,
  global bVar10, bVar11, bVar12, bVar13, bVar14, bVar15, bVar16, bVar17, bVar18, bVar19
  global bVar20, bVar21, bVar22, bVar23, bVar24, bVar25, bVar26, bVar27, bVar28, bVar29
  global bVar30, bVar31, bVar32, bVar33, bVar34, bVar35, bVar36, bVar37, bVar38, bVar39
  global bVar40, bVar41, bVar42, bVar43, bVar44, bVar45, bVar46, bVar47, bVar48, bVar49
  global bVar50, bVar51, bVar52, bVar53, bVar54, bVar55, bVar56, bVar57, bVar58, bVar59,
  global bVar60, bVar61, bVar62, bVar63, bVar64, bVar65, bVar66, bVar67, bVar68, bVar69,
  global bVar70, bVar71, bVar72, bVar73, bVar74, bVar75, bVar76, bVar77, bVar78, bVar79,
  global bVar80, bVar81, bVar82, bVar83, bVar84, bVar85, bVar86, bVar87, bVar88, bVar89,
  global bVar90, bVar91, bVar92, bVar93, bVar94, bVar95, bVar96, bVar97, bVar98, bVar99,
  global bVar100, bVar101, bVar102, bVar103, bVar104, bVar105, bVar106, bVar107, bVar108, bVar109,
  global bVar110, bVar111, bVar112, bVar113, bVar114, bVar115, bVar116, bVar117, bVar118, bVar119,

  ;MsgBox, %bVar0%
  ;bVar0 := "test"
  global kr
  global MyEdit, MyTT, ChosenHotkey
  global searchesObj
  winSearches_Destroy() ; make sure an old instance isn't still running or fading out

  Gui, bcmSH1:+AlwaysOnTop -ToolWindow -SysMenu -Caption +LastFound
  ;Gui, bcmSH1:+AlwaysOnTop +LastFound
	winSearches_hwnd := WinExist()
  ;WinSet, ExStyle, +0x20 ; WS_EX_TRANSPARENT make the window transparent-to-mouse
	WinSet, Transparent, 160
	curtranspSS := 160
	Gui, bcmSH1:Color, 202020 ;background color

  ;:the title
  Gui, bcmSH1:Font, ce3e3e3 s10 wbold, Arial
  Gui, bcmSH1: Add, Text, Center x0 y5 w%sW%, %stitle%
  

  Gui, bcmSH1:Font, cF0F0F0 s12 wbold, Arial
  ;the listener
  ;Gui, bcmSH1: Add, Text, ReadOnly -Border w720 h10 x20 y20 vMyTT Hwndhwnd_Container 
  ;Gui, bcmSH1: Add, Edit, +ReadOnly -Border vMyEdit Hwndhwnd_Keys w720 h10, 
  Gui, bcmSH1:Add, Hotkey, +ReadOnly -Border w720 h10 x20 y20 vChosenHotkey gOnShortcut

  ;create buttons::::::::::::::
  butH := 80
  butW := 80
  ax := 25
  ay := 50
  ;wer := searchesObj.buttonsA[1].name
  ;MsgBox, %wer%
  kr := 1

  For k, v in searchesObj.buttonsA
  {
      bVar%kr% := v
      nName := v.name
      nSh := v.shortcut
      ;Gui, bcmSH1: Add, Text, x%ax% y%ay% w100 h100, sassasa
      Gui, bcmSH1: Add, Button, TOP x%ax% y%ay% h%butH% w%butW% +theme -0x400 vbVar%kr% gbutPressedRoutine, >> %nSh% << %nName%        

      ax := ax + butW + 10
      if(ax > 680){
        ax := 25
        ay := ay + butH + 10
      }
      kr := kr + 1

  }
  Gui, bcmSH1:Show, W%sW% x%sX% y%sY%

  ;DllCall("SetParent", "uint", hwnd_gui2, "uint", hwnd_Container)
  ;OnMessage(WM_KEYDOWN := 0x100, "DetectKeyButtonPress")
  ;OnMessage( 0x7B, "TheContextPressed")
  OnMessage( 0x204, "WM_RBUTTONDOWN")
  WinActivate, winSearches_hwnd
  GuiControl, Focus, MyEdit

	Return
}

WM_RBUTTONDOWN(wParam, lParam){

  CoordMode, Mouse, Screen
  MouseGetPos, x, y

  
  eddTx := "Edit shortcut"
  if A_GuiControl
    sss := %A_GuiControl%
    GuiControlGet, butEdited, Hwnd, %A_GuiControl%
    sss.btToEdit := butEdited
    sss.btToEditVar := A_GuiControl
  CoordMode Mouse, relative
  if( sss.name = ""){
    eddTx := "Create shortcut"
  }

  ;GuiControl, bcmSH1:, %butEdited%, "testtsstts"
  winEditShortcuts( x, y, 400, eddTx, sss)

  Return
}




butPressedRoutine:
{
  sss := %A_GuiControl%
  winSearches_Destroy()
  Sleep, 50
  buttonPress( sss )
  Return
}

OnShortcut:
{
  sss1 := %A_GuiControl%
  ;MsgBox, %sss1%
  bsss := searchShortcut( sss1 )
  if( bsss = "Naan"){
    Return
  }else{  
    winSearches_Destroy()
    Sleep, 50
    buttonPress( bsss )
  }
  Return
}



ClearModifierOnlyValue:
  ControlGetText, DisplayedKeys,, ahk_id %hwnd_Keys%  ; ControlGet, DisplayedKeys, Line , 1,,  ahk_id %hwnd_MyEdit%,
  ModifierKeyList := "Control,Shift,Alt"  ;,RWin,LWin are removed
  if (SubStr(Trim(DisplayedKeys, A_Space), 0) = "+") {
    Loop, Parse, ModifierKeyList, `, 
      If GetKeyState(A_LoopField, "P")    ;still holding down
        Return  
    Gui, bcmSH1:Font, cGray  
    GuiControl, bcmSH1:Font, MyEdit    
    ControlSetText,, % EditBoxDefaultText, ahk_id %hwnd_Keys%,
  }
Return

DetectKeyButtonPress(wParam, lParam, msg) {
  Static MouseParamToVK := {1:1, bcmSH1:2, 0x10:4, 0x20:5, 0x40:6} ; L,R,M,X1,X2
  if (msg < 0x200 && lParam & 1<<30) ; Not a mouse message && key-repeat.
    return
  if A_GuiControl != MyEdit
    return
  if msg >= 0x201 ; Mouse message.
    wParam := MouseParamToVK[wParam & ~12] 
  ModifierKeyList := "Control,Shift,Alt"  ;,RWin,LWin are removed
  DisabledKeyList := "RWin,LWin"
  NumPMods := 0
  PressedModifiers := ""
  Loop, Parse, ModifierKeyList, `, 
  {
    if NumPMods > 3
      break
    If GetKeyState(A_LoopField, "P") {    ;if it is pressed
      PressedModifiers .= A_LoopField " + "
      NumPMods++
    }
  }
  SetFormat IntegerFast, H
  PressedKeyName := GetKeyName("VK" SubStr(wParam+0, 3))
  If PressedKeyName in %DisabledKeyList%
    Return
  Gui, bcmSH1:Font, cBlack
  GuiControl, bcmSH1:Font, MyEdit  
  If PressedKeyName in %ModifierKeyList%
    GuiControl,, MyEdit, % PressedModifiers
  Else
    GuiControl,, MyEdit, % PressedModifiers . PressedKeyName
  ;SetTimer, ClearModifierOnlyValue, -300
  ;MsgBox, %PressedKeyName%
  searchShortcutAndExec( PressedKeyName )
  Return
}

searchShortcutAndExec( ht ){
  ;MsgBox, %ht%
  ;splashInfo( ht )
  global searchesObj
  toSent := "Naan"
  if (ht = "Escape"){
    winSearches_Destroy()
  }else{
    if( ht = ""){

      }else{

      For k, v in searchesObj.buttonsA
      {
        if (ht = v.shortcut){
          winSearches_Destroy()
          Sleep, 100
          toSent := v
          break
        }
      }
    }
  }
  buttonPress( toSent )
  Return
}

searchShortcut( ht ){
  global searchesObj
  toSent := "Naan"
  if (ht = "Escape"){
    winSearches_Destroy()
  }else{
    if( ht = ""){

    }else{
      For k, v in searchesObj.buttonsA
      {
        if (ht = v.shortcut){
          winSearches_Destroy()
          Sleep, 100
          toSent := v
          ;buttonPress( v )
          break
        }
      }
    }
  }

  Return toSent
}
;winSearches_ModifyTitle(title) {
;	global winSearches_title
;	GuiControl,Text,winSearches_title, %title%
;}

;winSearches_ModifyMessage(message, isError) {
;	global winSearches_msg, winSearches_isError
;	GuiControl,Text,winSearches_msg, %message%
;}


winSearches_Destroy() {
	global curtranspSS
  global kr
	curtranspSS := 0
  kr := 1
	Gui, bcmSH1:Destroy
}

winSearchesBeginFadeOut:
	SetTimer, winSearchesBeginFadeOut, Off
	SetTimer, winSearches_FadeOut_Destroy, 10
Return

winSearches_FadeOut_Destroy:
	If(curtranspSS > 0) {
		curtranspSS := curtranspSS - 4
		WinSet, Transparent, %curtranspSS%, ahk_id %winSearches_hwnd%
	} Else {
		Gui, bcmSH1: Destroy
		SetTimer, winSearches_FadeOut_Destroy, Off
	}
Return

;---------------------------------------------------------------
; Modification of WinMove function by Learning One (http://www.autohotkey.com/board/topic/72630-gui-bottom-right/#entry461385)

; position argument syntax is to create a string with the following:
; t=top, vc= vertical center, b=bottom
; l=left, hc=horizontal center, r=right

WinMove2(hwnd,position) {   ; by Learning one

   mntNb := GetMonitorUnderMouse2()

   ;SplashImage , ,b1 cw008000 ctffff00, sssss: .%mntNb%
   ;Sleep,750
   ;SplashImage, Off ;MsgBox, sss Folder: .%sq%

   SysGet, Mon, Monitor, %mntNb%

   ;MsgBox, Left: %MonLeft% -- Top: %MonTop% -- Right: %MonRight% -- Bottom %MonBottom%.
   ;WinMove,,,,, 700, 400
   ;WinGet, WinID, ID, ahk_exe Substance Painter.exe,,,
   ;WinGetPos, aX, aY, aW, aH, ahk_id %WinID%
   ;bX := aX + ((aW * 0.5) - (w*0.5))
   ;bY := iy - (h*0.7)
   ;WinMove, ahk_id %hwnd%,,bX,bY


   WinGetPos,ix,iy,w,h, ahk_id %hwnd%
   x := InStr(position,"l") ? MonLeft : InStr(position,"hc") ?  (( MonLeft + MonRight )-w)/2 : InStr(position,"r") ? MonRight - w : ix
   y := InStr(position,"t") ? MonTop : InStr(position,"vc") ?  (MonBottom-h)/4 : InStr(position,"b") ? MonBottom - h : iy
   WinMove, ahk_id %hwnd%,,x,y
   WinActivate, ahk_id %hwnd%
}

;---------------------------------------------------------------
GetMonitorUnderMouse2()
{
    CoordMode, Mouse, Screen
    MouseGetPos, x, y
    SysGet, Mon1, Monitor, 1
    SysGet, Mon2, Monitor, 2
    tr := {}
    ;swaped := 0

    ;MsgBox, %x% ... %Mon2Left% ... %Mon1Left%
    tr.swaped := 0
    if(Mon2Left < 0)
    {
      tr.swaped := 1
    }
    ;MsgBox %x%
    ;MsgBox, Left: %Mon1Left% -- Top: %Mon1Top% -- Right: %Mon1Right% -- Bottom: %Mon1Bottom% -- x: %x%.
    ;MsgBox, Left: %Mon2Left% -- Top: %Mon2Top% -- Right: %Mon2Right% -- Bottom: %Mon2Bottom% -- x: %x%.

    ;tr := 1
    if( x >= Mon1Left )
    {
    	if(x <= Mon1Right )
    	{
    		tr.monitorUnderMouse := 1
    	}
    }

    if (x >= Mon2Left)
    {
    	if(	x <= Mon2Right)
    	{
    		tr.monitorUnderMouse := 2
    	}
    }
    ;CoordMode Mouse, relative
    return tr
        
}
