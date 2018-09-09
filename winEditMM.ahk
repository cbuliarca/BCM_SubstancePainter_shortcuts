editMMWin(){
	
   	global MMHotkeys, bcm_workArea
	global winEditMM_title, winEditMM_hwnd, winMMEditWidth
	global MMEditGuiGroups = []
	global MMHowManyMMenius, ApplyBtnMM

	getJsonMMKeys()
	pWin := findPainterWindow( )
	winEditMM_Destroy() ; make sure an old instance isn't still running or fading out

	winMMEditWidth := 560
	winW := winMMEditWidth
	;Gui, editMM:+AlwaysOnTop -ToolWindow -SysMenu -Caption +LastFound
	Gui, editMM:+AlwaysOnTop +LastFound
	winEditMM_hwnd := WinExist()
	;WinSet, Transparent, 230
	Gui, editMM:Color, ffffff ;background color


	Gui, editMM:Font, 151515 s10 wbold, Arial
	Gui, editMM: Add, Text, Center x5 y0 w%winW% h20, Edit Pie Menus

	Gui, editMM:Font, 151515 s8 wbold, Arial
	;Gui, editMM: Add, Progress, x0 y20 w560 h5 cBlue hwndLinehwnd, 100
	Gui, editMM: Add, Text, Left x5 y20 w250 h20, Title
	Gui, editMM: Add, Text, Left x270 y20 w100 h20, Shortcut
	Gui, editMM: Add, Button, Center x510 y15 w30 h20 gAddEmptyLine, +
	Gui, editMM: Add, Progress, x0 y35 w%winW% h3 caac3cc, 100




	Gui, editMM:Font, 151515 s8 wnormal, Arial

	;adding lines of controls
	incrY := 40
	MMHowManyMMenius := 1
	for k,v in MMHotkeys.markingMenus{
		addLine(incrY, winW, v)
		MMHowManyMMenius += 1
		incrY += 30
	}


	WApply := winW - 30
	Gui, editMM: Add, Button, x10 y350 w%WApply% h40 vApplyBtnMM gApplyBtn, Save Pie Menus
	;x := pWin.bLeft+( pWin.bWidth/2)
	Gui, editMM:Show, Center w550 h400
  	WinActivate, winEditMM_hwnd

	Return
}


addLine(yPos, wW, obj){
	global MMEditGuiGroups
	ttl := obj.title
	ssh := obj.shortcut
	;Gui, editMM:Font, 151515 s8 wbold, Arial
	Gui, editMM: Add, Edit, Left x5 y%yPos% w250 h20 hwndTexthwnd, %ttl%
	Gui, editMM: Add, Hotkey, x270 y%yPos% w100 h20 hwndHotkeyhwnd gCheckHotkeys, %ssh%
	;Gui, editMM:Font, 151515 s8 wnormal, Arial
	Gui, editMM: Add, Button, x380 y%yPos% w120 h20 hwndButtonhwnd gEditMMButton, Edit Menu
	Gui, editMM: Add, Button, x510 y%yPos% w30 h20 hwndDelhwnd gDelMMButton, x
	incrL := yPos + 22
	Gui, editMM: Add, Progress, x0 y%incrL% w%wW% h3 caac3cc hwndLinehwnd, 100

	cObMM := {}
	cObMM.guiTilte := Texthwnd
	cObMM.guiHotkey := Hotkeyhwnd
	cObMM.guiEdit := Buttonhwnd
	cObMM.guiDel := Delhwnd
	cObMM.guiLine := Linehwnd
	cObMM.y := yPos
	cObMM.visible := 1
	cObMM.file := obj.file
	cObMM.shortcut := obj.shortcut
	cObMM.title := obj.title

	MMEditGuiGroups.push(cObMM)
}



winEditMM_Destroy(){
	Gui, editMM:Destroy
}





AddEmptyLine:
{
	global MMEditGuiGroups, MMHowManyMMenius, winMMEditWidth, MMHotkeys, winEditMM_hwnd
	global ApplyBtnMM
	yNewLine := 40 + ((MMHowManyMMenius - 1) * 30)
	wNewLine := winMMEditWidth
	WinGetPos, ix,iy,iw,ih, ahk_id %winEditMM_hwnd%
	qnLine := yNewLine + 100
	if (qnLine > ih ){
		; expanding the window in case the added lines will be bigger
		;bcm_splashInfo("it's bigger")
		nh := ih + 30
		WinMove, ahk_id %winEditMM_hwnd%,,ix,iy,iw,nh
		GuiControlGet, appPos, Pos, ApplyBtnMM
		nAppPosY := appPosY + 30
		GuiControl, editMM:Move, ApplyBtnMM, y%nAppPosY%
	}
	nLine := {}
	nLine.title := ""
	nLine.shortcut := ""
	nLine.file := ""
	addLine(yNewLine, wNewLine, nLine)
	MMHowManyMMenius += 1
	;MMHotkeys.markingMenus.push(nLine)

	Return
}



ApplyBtn:
{
	;loop over the button s and get 
	
	newArr := []
	for a, b in MMEditGuiGroups{
		nOb := {}
		hk1 := b.guiTilte
		hk2 := b.guiHotkey
		hk3 := b.guiEdit
		hk4 := b.guiDel
		hk5 := b.guiLine
		if( b.visible = 1){
			;bcm_splashInfo(b.file)
			if(b.file = "")
			{

			}else{
				ControlGetText, titleName,,ahk_id %hk1%
				nOb.file := b.file
				nOb.shortcut := b.shortcut
				nOb.title := titleName
				newArr.push(nOb)
			}
		}
	}
	newArOb := {}
	newArOb.markingMenus := newArr
	MMSorcutsFile := "MMHotkeys.json"
	jStr := Jxon_Dump( newArOb, "`t")
  	FileDelete, %MMSorcutsFile%
  	FileAppend, %jStr% , %MMSorcutsFile%

  	Sleep, 500

  	Reload
	Return
}

DelMMButton:
{
	global MMEditGuiGroups, MMHowManyMMenius, winMMEditWidth
	;prsButton := A_GuiControl
	CoordMode, Mouse, Screen
	;get the control under mouse as hwnd
	MouseGetPos, mX, mY, ,mDelBtn, 2
	;loop throw all the conrols as lines and hide them
	;pY := 40
	foundDel := 0
	for a, b in MMEditGuiGroups{
		hk1 := b.guiTilte
		hk2 := b.guiHotkey
		hk3 := b.guiEdit
		hk4 := b.guiDel
		hk5 := b.guiLine
		if( b.guiDel = mDelBtn){
			foundDel := 1
			;first hide the line
			GuiControl, editMM:Hide, %hk1%
			GuiControl, editMM:Hide, %hk2%
			GuiControl, editMM:Hide, %hk3%
			GuiControl, editMM:Hide, %hk4%
			GuiControl, editMM:Hide, %hk5%
			;ControlGetText, test,,ahk_id %hk1%
			;bcm_splashInfo(test)
			MMHowManyMMenius -= 1
			b.visible := 0
			;pY -= 30
		}
		if (foundDel = 1){
			;andMove the others one upp
			pY := b.y - 30
			pYL := b.y - 30 + 22
			GuiControl, editMM:Move, %hk1%, y%pY%
			GuiControl, editMM:Move, %hk2%, y%pY%
			GuiControl, editMM:Move, %hk3%, y%pY%
			GuiControl, editMM:Move, %hk4%, y%pY%
			GuiControl, editMM:Move, %hk5%, y%pYL%
			b.y := pY
		}
		;pY += 30

	}
	Return
}
CheckHotkeys:
{
	global MMEditGuiGroups, MMHowManyMMenius, winMMEditWidth, winEditMM_hwnd
	;get the foicused control
	ControlGetFocus, cHotK, ahk_id %winEditMM_hwnd%
	GuiControlGet, cHH, Hwnd , %cHotK%
	GuiControlGet, shTxt, , %cHotK%
	;bcm_splashInfo(shTxt)
	dsIdx := 1
	htEx := 0
	for a, b in MMEditGuiGroups{
		hk2 := b.guiHotkey
		if(b.guiHotkey = cHH){
			;found the line clicked and skip comparation	
		}else{
			if(b.shortcut = shTxt){
				dsIdx := a
				htEx := 1
			}
		}
		;bcm_splashInfo(cHotK)
	}
	if(htEx = 1){
		CornerNotify(1, "!!! You cant use this shortcut, it used by another marking menu! !!!", "", "r hc", 1)
		cShs := MMEditGuiGroups[a].guiHotkey
		GuiControl, editMM:Text, %cShs%, ""
	}else{
		MMEditGuiGroups[a].shortcut := shTxt
	}
}

EditMMButton:
{
	global MMEditGuiGroups, MMHowManyMMenius, winMMEditWidth
	;prsButton := A_GuiControl
	CoordMode, Mouse, Screen
	;get the control under mouse as hwnd
	MouseGetPos, mX, mY, ,mEditBtn, 2
	for a, b in MMEditGuiGroups{
		if( b.guiEdit = mEditBtn ){
			hk11 := b.guiTilte
			if(b.file = ""){
				;check the title 
				ControlGetText, titleName,,ahk_id %hk11%
				;bcm_splashInfo(titleName)
				if(titleName = ""){
					;MsgBox, "You need to put a title for your Marking Menu!"
					CornerNotify(1, "!!! You need to put a title for your Marking Menu! !!!", "", "r hc", 1)
				}else{
					myMObjUI1 := {}
					myMObjUI1.file := titleName . ".json"
					myMObjUI1.title := titleName
					SH_GroupUI( myMObjUI1 )
					b.file := myMObjUI1.file
					b.title := myMObjUI1.title
				}

			}else{
				;open menu to edit buttons
				myMObjUI := {}
				myMObjUI.file := b.file
				myMObjUI.title := b.title
				SH_GroupUI( myMObjUI )

			}
			break
		}
	}
	Return 
}