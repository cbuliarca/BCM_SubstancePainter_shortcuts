;#SingleInstance,Force
;#Include %A_ScriptDir%    
;#Include *i pbuttons_class.ahk
#InstallMouseHook
#InstallKeybdHook
pButton_StartUp()
; first read the MMHotkeys
getJsonMMKeys()
; register the MM hotkeys, more explains on the function
registerHotkeysMM()
global pButton := {}
global MMButtonsJson
global MMHotkeys := {}
global MMButtons := []
global MMButtonsNb := 12
global radMM


createGui2(){
   ;the gui for the visual buttons
   global radMM
   global MMHotkeys
   global MMButtons
   global MMButtonsJson
   global pButton
   global MMButtonsNb
   global GuiHwnd
   global bVarMM0, bVarMM1, bVarMM2, bVarMM3, bVarMM4, bVarMM5, bVarMM6, bVarMM7, bVarMM8, bVarMM9,
   global bVarMM10, bVarMM11, bVarMM12, bVarMM13, bVarMM14, bVarMM15, bVarMM16, bVarMM17,

   ;regitser the keys to listen for when the MM is on:
   getJsonMMKeys()


   Gui, 1:+LastFound +AlwaysOnTop +ToolWindow
   Gui, 1:-Caption
   Gui, 1:Color, 008080
   WinSet, TransColor, 008080
   Gui, 1:Font, cbdbdbd wbold s10, Arial
   GuiHwnd := WinExist()


   getJsonMM(MMHotkeys.markingMenus[1])

   nbrs := MMButtonsNb
   step :=  2 *  3.141592653589/nbrs
   PI := 3.141592653589
   h := 0
   w := 0
   r := 170
   ofset := 300
   theta := 0
   thetay := 0 
   aII :=0
   incr := 0
   ;create buttons for the first time

   Pnts := [343, 104, 332, 65, 258, 33, 183, 4, 108, 33, 34, 65, 24, 104, 34, 143, 108, 176, 183, 205, 258, 176, 332, 143]
   zpnts := Pnts.Length/2
   aa := 1
   loop, 12
   {
      pButton[A_Index] := New Progress_Button( 1, A_Index, "Some_Label", Pnts[aa], Pnts[aa+1], 120, 25, "5a5a5a", "5a5a5a", "313131", "0077AA", "c2c2c2", MMButtonsJson.buttonsA[A_Index].name, 4 )
      aa += 2
   }

   ;For k, v in MMButtonsJson.buttonsA
   ;{
   ;   if( k > nbrs){
   ;      ; only 12 buttons alowed
   ;      Break
   ;   }

   ;   ;Mod(k, nbrs/4)
   ;   Qye := easeInOutCubic(incr, 0, r*2, nbrs)
   ;   ;Qye := easeInCubic(incr, 0, r*2, nbrs)
   ;   Qx := h + r * Cos(theta) + (sin(Qye) * 3)
   ;   ;Qy :=  Qye
   ;   Qy :=  (w - 0.5 * r * Sin(theta)) - (sin(Qye) * 12)
   ;   ;Qy := Round( w - 0.5 * r * Sin(theta))
   ;   QAngle := G_GetAngle(Qx,Qy)



   ;   ;Qy := 0
   ;   ;Qy := (sin(Qy)*r) - r * sin(theta) 
   ;   ;Qx := 0

   ;   Qx += ofset
   ;   Qy += ofset
   ;   Qx := Ceil(Qx)
   ;   Qy := Ceil(Qy)
   ;   pButton[k] := New Progress_Button( 1, k, "Some_Label", Qx, Qy, 120, 22, "5a5a5a", "5a5a5a", "313131", "0077AA", "c2c2c2", v.name, 2 )
      

   ;   qbtn := {}
   ;   qbtn.angle := QAngle
   ;   qbtn.name := "Radial" . aII
   ;   qbtn.command := "1"
   ;   MMButtons[A_Index] := qbtn
   ;   theta += step
   ;   incr += 1
   ;   aII += 1
   ;}

   Gui, 1:Show, w900 h900
   Gui, 1:Hide
}

easeOutIn(t, b, c, d){
  p := easeInQuad(t, b, c, d)
  return p
}

easeInQuad(t, b, c, d) {
   t /= d
   return c*t*t + b
}
easeInOutQuad(t, b, c, d) {
   t /= d/2
   if (t < 1) return c/2*t*t + b
   t--
   return -c/2 * (t*(t-2) - 1) + b
}


easeInCubic(t, b, c, d) {
   t /= d
   return c*t*t*t + b
}
easeOutQuad(t, b, c, d) {
   t /= d
   rt := (-c * t*(t-2) + b)
   return rt
}

easeInOutCubic(t, b, c, d) {
   ;increment, start, end, planneditterations
   t /= d/2
   if (t < 1){
      return c/2*t*t*t + b
   }
   t -= 2
   return c/2*(t*t*t + 2) + b
}



getJsonMMKeys(){
   global MMHotkeys
   MMKeysFile := "MMHotkeys.json"
   isFile := FileExist( MMKeysFile)
   if(isFile = ""){
      jStrNew := "{`n`t""markingMenus"": [`n`t`t{`n`t`t`t""file"": """",`n`t`t`t""title"": """",`n`t`t`t""shortcut"": """"`n`t`t}`n`t]`n}"
      openedFile := MMKeysFile
      FileAppend, %jStrNew% , %openedFile%

      Fileread, searches, %openedFile%
   }else{
      openedFile := MMKeysFile
      Fileread, searches, %openedFile%
   }

   MMHotkeys := Jxon_Load(searches)
}

getJsonMM( myObj ){
   global MMButtonsJson
   isFile := FileExist( myObj.file)
   if(isFile = ""){
      jStrNew := "{`n`t""buttonsA"": [`n`t`t{`n`t`t`t""command"": """",`n`t`t`t""name"": """",`n`t`t`t""shortcut"": """"`n`t`t}`n`t]`n}"
      openedFile := myObj.file
      FileAppend, %jStrNew% , %openedFile%

      Fileread, searches, %openedFile%
   }else{
      openedFile := myObj.file
      Fileread, searches, %openedFile%
   }

   MMButtonsJson := Jxon_Load(searches)
}

Some_Label(){
   ;SplashImage, , , , Test, ,
   MsgBox, ,, sss,1
}

calculateZones( arr, arCnt ){
   z := {}
   z.a1 := 360
   za2 := arr[2].angle + ( 0.5 * (360.000 - arr[2].angle))
   z.a2 := za2
   z.b1 := 0
   z.b2 := arr[arCnt].angle - ( 0.5 * (arr[arCnt].angle - 0))
   arr[1].zoneLimits := z

   
   z2 := {}
   z2.a1 := za2
   z2.a2 := arr[2].angle
   z2.b1 := arr[2].angle
   z2.b2 := arr[2].angle + ( 0.5 * (arr[2].angle - arr[3].angle))
   arr[2].zoneLimits := z2

   q := 3
   arCntQ := arCnt - 2
   loop, %arCntQ%
   {
      z1 := {}
      z1.a1 := arr[q-1].angle + ( 0.5 * (arr[q-1].angle - arr[q].angle))
      z1.a2 := arr[q].angle
      z1.b1 := arr[q].angle
      z1.b2 := arr[q].angle + ( 0.5 * (arr[q].angle - arr[q+1].angle))
      arr[q].zoneLimits := z1

      q += 1
   }
   return arr
}



showGui2(x,y){
   global radMM
   getJsonMMKeys()
   sx := x - 244
   sy := y - 116
   ;sx := x
   ;sy := y
   Gui, 1:Show, x%sx% y%sy%
}

executeSelection( sx, sy, fx, fy){
   global MMButtonsJson
   global pButton
   btnIdx := getSelection( sx, sy, fx, fy)
   if (btnIdx != "none"){
      theB := MMButtonsJson.buttonsA[btnIdx]
      excSt:= theB.command
      buttonPress( theB )
   }

   ;MsgBox, ,,%excSt%, 
}

getSelection( sx, sy, fx, fy){
   ox := sx - fx
   oy := sy - fy
   dist := G_Getlength(sx, sy, fx, fy)
   ;MsgBox, , , %dist%, 1
   if(dist >= 40){
      angle := G_GetAngle(ox, oy)
      angle1 := angle
      return Get_Btn(angle1)
   }else{
      return "none"
   }
}

G_Getlength(sx, sy, fx, fy){
   return dist := Sqrt( ((sx-fx) * (sx-fx)) + ((sy-fy) * (sy-fy)) )
}

G_GetAngle(x, y)
{
    if (x != 0) {
        deg := ATan(y/x) * 57.295779513082323 
         ;deg := rad * 180/PI
        if x < 0
            return deg + 180
        else
            if y < 0
                return deg + 360
        return deg
    } else ; x = 0
        if y > 0
            return 90.0
        else if y < 0
            return 270.0 ;-90
        ; else no return value.
}

Get_Btn(angle){
   global MMButtons
   global MMButtonsNb
   ;bcm_msgBObj(MMButtons)
   ; Calculate zone size.
   degPerZone := 360/MMButtonsNb

   ; Calculate nearest zone integer.
   zone := Mod(Round(angle/degPerZone),MMButtonsNb)

   ; change ranges to match the numbers well
   aa := chRange( zone, 0, 6, 6, 0)
   if(aa < 0){
      aa := chRange(zone, 6, 12, 12, 6)
   }

   return Round(aa + 1)
}


chRange( nb, InputLow, InputHigh, OutputLow, OutputHigh ){
      Result := ((nb - InputLow) / (InputHigh - InputLow))*(OutputHigh - OutputLow) + OutputLow

      return Result
}

;bcm_msgBObj( ob ){
;   txt := ""
;   For k, v in ob{
;      txt1 := (" " . k . " :: " . v . "`n")
;      txt := txt . txt1
;   }
;   ;MsgBox, %txt%
;   return
;}
createGUI(){
   global GuiHwnd
   global ChosenHotkeyMM
   Gui, testLine:+LastFound +AlwaysOnTop +ToolWindow
   Gui, testLine:-Caption
   Gui, testLine:Color, 008080
   WinSet, TransColor, 008080
   GuiHwnd := WinExist()
   ;Gui, testLine:Show
   ;Gui, testLine:Add, Hotkey, +ReadOnly -Border w720 h10 x20 y20 vChosenHotkeyMM gMMHotkeyPressed
   Gui, testLine:Maximize
   Gui, testLine:Hide
}



theMM(){
   global MMOn
   ; THIS IS THE FUNCTION THAT'S CALLED when the Middle mouse is pressed
   global GuiHwnd
   global GuiHwnd2
   global pButton
   global ChosenHotkeyMM

   MMOn := 1
   if(!GuiHwnd){
      createGUI2()
      createGUI()
   }else{
      CoordMode, Mouse, Screen
      MouseGetPos, p_x1, p_y1
      showGui2(p_x1,p_y1)
      SysGet, XVirtualScreen, 76
      SysGet, YVirtualScreen, 77
      SysGet, CXVirtualScreen, 78
      SysGet, CYVirtualScreen, 79
      hDC := DllCall("GetDC", UInt, GuiHwnd)
      DllCall("SetViewportOrgEx", "uint", hDC, "int", -XVirtualScreen, "int", -YVirtualScreen, "uint", 0)
      ; Show the trail canvas over the entire virtual screen (all monitors).
      Gui, testLine:Show, X-30000 Y-30000 W%CXVirtualScreen% H%CYVirtualScreen% NA
      ; Showing the Gui initially off-screen may help reduce "screen flash".
      Gui, testLine:Show, X%XVirtualScreen% Y%YVirtualScreen% NA
      GuiControl, Focus, ChosenHotkeyMM
      hCurrPen := DllCall("CreatePen", UInt, 0, UInt, 5, UInt, "0x232323")
      DllCall("SelectObject", UInt,hdc, UInt,hCurrPen)
   }
   
   SetTimer, MMKeyListenSubroutine, 1

   ssold := 0
   ss := 0
   loop,
   {
      ;loop to look for middle mouse down
      GetKeyState, state, MButton, P 
      if state = U
      {
         SetTimer, MMKeyListenSubroutine, Off
         ;if the mouse is unpp hide the UI
         ;and execute the selected option
         Gui, testLine:Hide
         Gui, 1:Hide
         CoordMode, Mouse, Screen
         MouseGetPos, b_finX, b_finY
         executeSelection( p_x1, p_y1, b_finX, b_finY)

         pButton[ss].Button_Hover_Off()
         Break
      }else{
         SetTimer, MMKeyListenSubroutine, On
         ;mous is down
         ;constanly checking the mouse position 

         CoordMode, Mouse, Screen
         MouseGetPos, b_endX, b_endY
         ;if the mouse is moved
         if ( b_endx != b_endx1 or b_endy != b_endy1){
            ;redrwaw the GUI with the line
            WinSet, Redraw,, ahk_id %GuiHwnd%
            ;SplashImage, Off
            ;get the sleected zone
            ss := getSelection( p_x1, p_y1, b_endX, b_endY)
            if (ss != "none"){
               ;nothing selected
               if( ss != ssold){
                  ;updating the buttons highlit
                  pButton[ss].Button_Hover_On()
                  pButton[ssold].Button_Hover_Off()
                  ssold := ss
               }
            }else{
               pButton[ss].Button_Hover_Off()
               pButton[ssold].Button_Hover_Off()
            }
            ;SplashImage, ,,, %ss% . " || " . %ssold% . " || " . %ss2%, ,
         }
         
         ;draw the line
         DllCall("MoveToEx", UInt, hdc, Uint,p_x1, Uint, p_y1, Uint, 0 )
         DllCall("LineTo", UInt, hdc, Uint, b_endx, Uint, b_endy )

         b_endy1 := b_endy
         b_endx1 := b_endx

      }      
   }

}



changeMM( myObj ){
   global MMButtonsNb
   global MMButtonsJson
   global pButton
   getJsonMM(myObj)
   lessThen12 := 0
   For k, v in MMButtonsJson.buttonsA
   {
      if( k > MMButtonsNb){
         Break
      }
      lessThen12 := k 
      pButton[k].Set_Text(v.name)
   }
   if(lessThen12 < MMButtonsNb){
      loop,
      {
         if( lessThen12 > MMButtonsNb){
            Break
         }
         lessThen12 ++
         pButton[lessThen12].Set_Text("")
      }
   }
}

registerHotkeysMM(){
   ;this function will register the hotheys assigned to every MM
   ;thius way if the uesr keep pressed the c key in substance painter 
   ;the channels will not be changed, it will wait 2 seconds before it will send
   ;the c again, this way the user can start the MM by pressing the Middle mouse

   global MMHotkeys
   for k, v in MMHotkeys.markingMenus{
      aa := v.shortcut
      aa := "$" . aa
      ;MsgBox, ,, theHK to register %aa% , 1
      Hotkey, IfWinActive, ahk_exe Substance Painter.exe 
      ;Hotkey, IfWinActive, BCM_substancePainter_shortcuts.ahk
      ;Hotkey, IfWinActive, BCM_substancePainter_shortcuts.exe
      Hotkey, %aa% , MMHotkeyPressedLabel 
   }
}


global isPressedMM := 0
global QpressedKey := {}
QpressedKey.shortcut := ""
MMKeyListenSubroutine:
{
   global MMHotkeys
   ;this routine it's ckecking if the keyse are pressed or not
   ;if the keys from MMHotkeys.json are pressed the marking menus are changed
   ;the first menu in the file it's the default one
   
   global isPressedMM
   ;SplashImage, , , , %keyPressedA%, , 
   ;Sleep 0.5
   nothingPressed := 0
   
   for k, v in MMHotkeys.markingMenus{
      theKey := v.shortcut
      GetKeyState, keyPressedA, %theKey%, P
      if(keyPressedA == "D"){
         ; found a key pressed
         isPressedMM := 1
         nothingPressed := 1
         if(QpressedKey.shortcut == v.shortcut){
            ;the same key it's keept pressed
            ;do nothing
         }else{
            ;change the MM keys
            QpressedKey := v
            changeMM( v )
         }
         ;don't go on with the search
         Break
      }
      ;}else{
      ;   ;when there is no key pressed
      ;   ;SplashImage, , , , %keyPressedA%, , 
      ;   ;Sleep 0.5
      ;   if(isPressed == 1){
      ;      ;the key was previously pressed
      ;      QpressedKey := MMHotkeys.markingMenus[1]
      ;      isPressedMM := 0
      ;      changeMM( MMHotkeys.markingMenus[1] )
      ;   }
      ;   ;isPressedMM := 0
      ;}
   }
   if(nothingPressed == 0){
         ;when there is no key pressed
         ;SplashImage, , , , %isPressed%, , 
         ;Sleep 0.5
      if(isPressedMM == 1){
         ;the key was previously pressed
         QpressedKey := MMHotkeys.markingMenus[1]
         isPressedMM := 0
         changeMM( MMHotkeys.markingMenus[1] )            
      }
      isPressedMM := 0
   }
      SplashImage, Off

   Return
}

;esc::
;   exitapp
;   Return


;~MButton::
;   theMM()
;   Return

;~^s::
;SetTitleMatchMode, 2 ;--- works in ANYTHING displaying scripts name as ANY part of the window title
;IfWinActive,%A_ScriptName%
;{
;  SplashImage , ,b1 cw008000 ctffff00, %A_ScriptName%, Reloaded
;  Sleep,750
;  SplashImage, Off
;  Reload
;}
;return

F9::
{
   ListHotkeys
   return
}



MMHotkeyPressedLabel:
{
   ;this function will register the hotheys assigned to every MM
   ;thius way if the uesr keep pressed the c key in substance painter 
   ;the channels will not be changed, it will wait 2 seconds before it will send
   ;the c again, this way the user can start the MM by pressing the Middle mouse
   
   ;this varible is checking if the MM was on
   global MMOn

   ;geting the hotkey pressed, we know that it has a $ in front so we need to strip it
   ;we know that because it was added when the key was registered, it means that it has a hook
   myKey1 := A_ThisHotkey
   StringTrimLeft, myKey, myKey1, 1

   Keywait, %myKey%, t2 ;<- see if key is being held down for 2 seconds::
   
   err := Errorlevel
   if (err) ;<- if key was held for that long 
   {
      ;MsgBox, , , %myKey%, 1 
      ;bcm_splashInfo("ssss")
   }
   if(MMOn = 1){
      ;if the MM was on, don't sent the key
      MMOn := 0
   }else{
      ;if the key was released right away then send that key back, 
      ;working like it suposed to work in SP
      MMOn := 0
      ControlSend,, %myKey%, ahk_exe Substance Painter.exe
      ;Send, %myKey%
      
   }
   return
}