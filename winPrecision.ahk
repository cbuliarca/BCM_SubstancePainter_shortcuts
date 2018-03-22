;create window

winPrecision( title ) {
  WinGet, WinID, ID, ahk_exe Substance Painter.exe,,,
  WinGetPos, aX, aY, aW, aH, ahk_id %WinID%
  w := 760
  bX := aX + ((aW * 0.5) - (w*0.5))
  bY := aY + (aH*0.25)


	winPrecision_Create(bX, bY, w, title )

}

winPrecision_Create( sX, sY, sW, stitle) {

	global winPrecision_title, winPrecision_msg, w, curtranspSSPrecis, winPrecision_hwnd, winPrecision_isError
  global dVar0, dVar1, dVar2, dVar3, dVar4, dVar5, dVar6, dVar7, dVar8, dVar9,
  global dVar10, dVar11, dVar12, dVar13, dVar14, dVar15, dVar16, dVar17, dVar18, dVar19
  global dVar20, dVar21, dVar22, dVar23, dVar24, dVar25, dVar26, dVar27, dVar28, dVar29
  global dVar30, dVar31, dVar32, dVar33, dVar34, dVar35, dVar36, dVar37, dVar38, dVar39
  global dVar40, dVar41, dVar42, dVar43, dVar44, dVar45, dVar46, dVar47, dVar48, dVar49
  global dVar50, dVar51, dVar52, dVar53, dVar54, dVar55, dVar56, dVar57, dVar58, dVar59,
  global dVar60, dVar61, dVar62, dVar63, dVar64, dVar65, dVar66, dVar67, dVar68, dVar69,
  global dVar70, dVar71, dVar72, dVar73, dVar74, dVar75, dVar76, dVar77, dVar78, dVar79,
  global dVar80, dVar81, dVar82, dVar83, dVar84, dVar85, dVar86, dVar87, dVar88, dVar89,
  global dVar90, dVar91, dVar92, dVar93, dVar94, dVar95, dVar96, dVar97, dVar98, dVar99,
  global dVar100, dVar101, dVar102, dVar103, dVar104, dVar105, dVar106, dVar107, dVar108, dVar109,
  global dVar110, dVar111, dVar112, dVar113, dVar114, dVar115, dVar116, dVar117, dVar118, dVar119,

  ;MsgBox, %dVar0%
  ;dVar0 := "test"
  global precisionAdd
  global krPrecis
  global MyEditPrecis, MyTTPrecis, ChosenHotkeyPrecis
  global precisionObj, MyPrecisionEditQ, EnterBtn
  winPrecision_Destroy(0) ; make sure an old instance isn't still running or fading out

  Gui, 2:+AlwaysOnTop +ToolWindow -SysMenu -Caption +LastFound
	winPrecision_hwnd := WinExist()
  ;WinSet, ExStyle, +0x20 ; WS_EX_TRANSPARENT make the window transparent-to-mouse
	WinSet, Transparent, 160
	curtranspSSPrecis := 160
	Gui, 2:Color, 202020 ;background color

  ;:the title
  Gui, 2:Font, ce3e3e3 s10 wbold, Arial
  Gui, 2: Add, Text, Center x0 y5 w%sW%, %stitle%
  

  Gui, 2:Font, cF0F0F0 s12 wbold, Arial
  ;the listener
  ;Gui, 2: Add, Text, ReadOnly -Border w720 h10 x20 y20 vMyTTPrecis Hwndhwnd_Container 
  ;Gui, 2: Add, Edit, +ReadOnly -Border vMyEditPrecis Hwndhwnd_Keys w720 h10, 
  Gui, 2:Add, Hotkey, +ReadOnly -Border w720 h10 x20 y20 vChosenHotkeyPrecis gOnShortcutPrecision

  ;create buttons::::::::::::::
  butH := 60
  butW := 75
  ax := 25
  ay := 50
  ;wer := precisionObj.buttonsA[1].name
  ;MsgBox, %wer%
  krPrecis := 1

  For k, v in precisionObj.buttonsA
  {
      dVar%krPrecis% := v
      nName := v.name
      nSh := v.shortcut
      ;Gui, 2: Add, Text, x%ax% y%ay% w100 h100, sassasa
      Gui, 2: Add, Button, TOP x%ax% y%ay% h%butH% w%butW% +theme -0x400 -TabStop vdVar%krPrecis% gbutPressedPrecisionRoutine, >> %nSh% << %nName%        

      ax := ax + butW + 10
      if(ax > 680){
        ax := 25
        ay := ay + butH + 10
      }
      krPrecis := krPrecis + 1

  }
  ay := ay + butH + 10

  Gui, 2: Font, c000000 s50 wbold, Arial
  Gui, 2: Add, Edit, x10 y%ay% w740 h40 r1 -WantReturn vMyPrecisionEditQ, %precisionAdd%
  Gui, 2: Add, Button, w40 h1 -TabStop default vEnterBtn gButSSSS, OK
  
  Gui, 2:Font, ce3e3e3 s14 wbold, Arial
  Gui, 2: Add, Text, Center w%sW%, precision will be changed only if you press enter
  

  Gui, 2: Show, W%sW% x%sX% y%sY%

  GuiControl, 2:Hide, EnterBtn


  WinActivate, winPrecision_hwnd
  GuiControl, 2:Focus, MyEditPrecis
	Return
}

ButSSSS:
{

  GuiControlGet, pa ,, MyPrecisionEditQ
  precisionAdd := pa
  winPrecision_Destroy(1)
  Return
}

butPressedPrecisionRoutine:
{
  sss := %A_GuiControl%
  bsPrecisB := sss.precision
  GuiControl, Text, MyPrecisionEditQ , %bsPrecisB%
  Return
}

OnShortcutPrecision:
{
  sss1 := %A_GuiControl%
  bsss := searchShortcutPrecis( sss1 )
  if( bsss = "Naan"){
    Return
  }else{
    if(bsss.precision){
      bsPrecis := bsss.precision
    }
    GuiControl, Text, MyPrecisionEditQ , %bsPrecis%
  }
  Return
}


searchShortcutAndExecPrecis( ht ){
  ;MsgBox, %ht%
  ;splashInfo( ht )
  global precisionObj
  toSent := "Naan"
  if (ht = "Escape"){
    winPrecision_Destroy(0)
  }else{
    if( ht = ""){

      }else{

      For k, v in precisionObj.buttonsA
      {
        if (ht = v.shortcut){
          winPrecision_Destroy(0)
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

searchShortcutPrecis( ht ){
  global precisionObj
  toSent := "Naan"
  if (ht = "Escape"){
    winPrecision_Destroy(0)
  }else{
    if( ht = ""){

    }else{
      For k, v in precisionObj.buttonsA
      {
        if (ht = v.shortcut){
          ;winPrecision_Destroy(0)
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


winPrecision_Destroy( ws ) {
  global wasTextSelBeforeThisWin
	global curtranspSSPrecis
  global krPrecis
	curtranspSSPrecis := 0
  krPrecis := 1
	Gui, 2:Destroy
  if (ws = 1){
    if(wasTextSelBeforeThisWin.x){
      Sleep, 100
      sqx := wasTextSelBeforeThisWin.x
      sqy := wasTextSelBeforeThisWin.y
      Click, %sqx% %sqy%
      wasTextSelBeforeThisWin := {}
    }
  }
  Return
}




