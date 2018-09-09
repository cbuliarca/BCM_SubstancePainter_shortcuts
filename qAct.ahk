bcm_workArea := {}
bcm_workArea := getAllPixelsMonitors()
addTrayMenus()

#Include %A_ScriptDir%              ; Set working directory for #Include.
#Include *i Jxon22.ahk
#Include *i pbuttons_class.ahk
#Include *i markingMenu.ahk
#Include *i CornerNotify.ahk
#Include *i winSearches.ahk
#Include *i winPrecision.ahk
#Include *i winEditShortcuts.ahk
#Include *i winEditMM.ahk
#Include *i helpWin.ahk

;#Include *i Eval.ahk

#WinActivateForce

toPerformAfterInfoGet := ""
painterInfoObj := {}
bcm_workArea := {}
precisionAdd := 0.1
MMcreated := 0
MMOn := 0
brushSpacingDefault := 5
;dontMoveMMO := 1


CoordMode, Mouse, Screen
CoordMode Pixel


;https://autohotkey.com/board/topic/122-automatic-reload-of-changed-script/page-2
~^s::
SetTitleMatchMode, 2	;--- works in ANYTHING displaying scripts name as ANY part of the window title
IfWinActive,%A_ScriptName%
{
  SplashImage , ,b1 cw008000 ctffff00, %A_ScriptName%, Reloaded
  Sleep,750
  SplashImage, Off
  Reload
}
return







bcm_splashInfo( sq ){
	WinGet, WinID1, ID, ahk_exe Substance Painter.exe,,,
	WinGetPos, aX, aY, aW, aH, ahk_id %WinID1%
	w := 500
	bX := aX + ((aW * 0.5) - (w*0.5))
	bY := aY + (aH*0.35)

	SplashImage , , x%bX% y%bY% W%w% b1 cw008000 ctffff00, sssss: .%sq%, %sq%
	Sleep,1000
	SplashImage, Off
}

bcm_msgBObj( ob ){
	txt := ""
	For k, v in ob{
		txt1 := (" " . k . " :: " . v . "`n")
		txt := txt . txt1
	}
	MsgBox, %txt%
	return
}

cal_forMyMonitors( val ){
	if(val < 0){
		return 1920 - val
	}else if (val >= 0){
		return 1920 + val
	}else{
		return val
	}
}

myClick( val1, val2, btnN ){
	;a click with errors check, if the values are ok it will click
	CoordMode, Mouse, Screen

	doIt := 0
	if( val1 AND val2)
	{
		if( val1 is number AND val2 in number){
			;bcm_splashInfo("click")
			if (btnN == "right"){
				Click, right, %val1%, %val2%
				
			}else{
				Click, %val1%, %val2%
			}
		}
	}
}

toogleSizePressure0( bTabX, bTabY ){
	;old version obsolette

	theSizeX := bTabX - 5
	theSizeY := bTabY + 16

	;MsgBox, move to Size Pressure 
	;see if the size has pressure or not
	theSizeXS := bTabX - 32
	theSizeYS := bTabY + 1
	thePressPos = 40
	ImageSearch, theSizeImgY, theSizeImgY, theSizeXS, theSizeYS, %A_ScreenWidth%, %A_ScreenHeight%, %A_ScriptDir%\images\hasPressure.png
	if ErrorLevel = 1 ; no presure set to pressure
	{
		CornerNotify(1, "Size pressure ON", "", "r hc", 0)
		BlockInput, on
		myClick( theSizeX , theSizeY, "left")
		npY := theSizeY + 40
		myClick( theSizeX , npY, "left")
		BlockInput, off
	}
	Else
	{
		CornerNotify(1, "Size pressure OFF", "", "r hc", 0)
		BlockInput, on
		myClick( theSizeX , theSizeY, "left")
		npY1 := theSizeY + 10
		myClick( theSizeX , npY1, "left")
		BlockInput, off
	}
}


toogleOpacityPressure0( bTabX, bTabY ){
	;old version obsolette
	theSizeX := bTabX - 5
	theSizeY := bTabY + 36

	;MsgBox, move to Size Pressure 
	;see if the size has pressure or not
	theSizeXS := bTabX - 32
	theSizeYS := bTabY + 25
	thePressPos = 40
	ImageSearch, theSizeImgY, theSizeImgY, theSizeXS, theSizeYS, %A_ScreenWidth%, %A_ScreenHeight%, %A_ScriptDir%\images\hasPressure.png
	if ErrorLevel = 1 ; no presure set to pressure
	{
		CornerNotify(1, "Flow pressure ON", "", "r hc", 0)
		BlockInput, on
		myClick( theSizeX , theSizeY, "left")
		npY := theSizeY + 40
		myClick( theSizeX , npY, "left")
		BlockInput, off
	}
	Else
	{
		CornerNotify(1, "Flow pressure OFF", "", "r hc", 0)
		BlockInput, on
		myClick( theSizeX , theSizeY, "left")
		npY1 := theSizeY + 10
		myClick( theSizeX , npY1, "left")
		BlockInput, off
	}
}


toogleBrushSizePressure(){
	pressSize := getBrushUppOptions("Size")
	CoordMode, Mouse, Screen
	if(pressSize.X){
		MouseGetPos, xpos, ypos 
		mSpeed := 0.000001
		BlockInput, On
		clX := pressSize.DropDownX
		clY := pressSize.DropDownY
		myClick( clX , clY, "left")
		Sleep 100
		if(pressSize.penPressure = 1){
			clX1 := pressSize.DropDownX
			clY1 := pressSize.noPressureD

			myClick( clX1 , clY1, "left")
			CornerNotify(1, " Brush Size set to NO pen pressure ", "", "r hc", 0)
		}else{
			clX1 := pressSize.DropDownX
			clY1 := pressSize.penPressureD
			myClick( clX1 , clY1, "left")		
			CornerNotify(1, " Brush Size set to PEN PRESSURE ", "", "r hc", 0)	
		}
		CoordMode, Mouse, Screen
		MouseMove, xpos, ypos, mSpeed  
		BlockInput, Off
	}
	Send {Ctrl}{Alt}
	Return
}

toogleBrushFlowPressure(){
	pressFlow := getBrushUppOptions("Flow")
	CoordMode, Mouse, Screen
	if(pressFlow.X){
		MouseGetPos, xpos, ypos 
		mSpeed := 0.000001
		BlockInput, On
		clX := pressFlow.DropDownX
		clY := pressFlow.DropDownY
		myClick( clX , clY, "left")
		Sleep 100
		if(pressFlow.penPressure = 1){
			clX1 := pressFlow.DropDownX
			clY1 := pressFlow.noPressureD
						;splashInfo( clX )
			myClick( clX , clY1, "left")
			CornerNotify(1, " Brush Flow set to NO pen pressure ", "", "r hc", 0)
		}else{
			clX1 := pressFlow.DropDownX
			clY1 := pressFlow.penPressureD
						;splashInfo( clX )
			myClick( clX , clY1, "left")		
			CornerNotify(1, " Brush Flow set to PEN PRESSURE ", "", "r hc", 0)	
		}
		CoordMode, Mouse, Screen
		MouseMove, xpos, ypos, mSpeed  
		BlockInput, Off
	}
	Send {Ctrl}{Alt}
	Return
}

bcm_simpleGUI(){
	global winSimple_hwnd
	Gui, simpleB:Destroy
	;Gui, simpleB:+AlwaysOnTop -ToolWindow -SysMenu -Caption +LastFound
	winSimple_hwnd := WinExist()
	Gui, simpleB:+AlwaysOnTop +LastFound
	;WinSet, Transparent, 23
	Gui, simpleB:Show, Center w100 h100
  	WinActivate, winSimple_hwnd
	;Gui, editMM:Hide
}



toogleBrushBackfaceCulling(){
	list1 := findPainterWindow()
	CoordMode, Mouse, Screen
	CoordMode, Pixel
	MouseGetPos, xpos, ypos 
	mSpeed := 0.000001
	winMenuX := list1.bLeft + 161
	winMenuY := list1.bTop + 29 
	BlockInput, On
	;click on the window menu
	myClick(winMenuX, winMenuY, "left")
	Sleep, 200
	;search for ckeck for HideUI to see if the UI's are already hidden
	;setinBB := ""
	isAlreadyHiddenUI := 0
	CoordMode, Pixel
	ImageSearch, ckX, ckY, list1.bLeft + 110, list1.bTop + 90, list1.bLeft + 146, list1.bTop + 112, %A_ScriptDir%\images\checkMenu.png
	if (ErrorLevel = 2){
		;bcm_splashInfo("errrrrrrr")
	}
	else if (ErrorLevel = 1){
		isAlreadyHiddenUI := 0
	}else{
		isAlreadyHiddenUI := 1
	}

	if( isAlreadyHiddenUI = 0){
		;hide all the UI
		myClick(list1.bLeft + 171, list1.bTop + 104, "left")
		;Sleep,100
	}


	;now to open the properties right clikc in the upper corner of painter
	; I think for the right click to work with the tablet, Painter should not have the focus
	WinClose, Program Manager
	WinActivate, Program Manager
	myClick(list1.bLeft + 53, list1.bTop + 89, "right")
	Sleep, 100


	;find the propertiesWindow
	prop := getThePropWindow()
	CoordMode, Mouse, Screen
	prop.wasRightClickOpened := 1
	prop.rightClickX := list1.bLeft + 53
	prop.rightClickY := list1.bTop + 89
	
	;BlockInput, Off
	;bcm_msgBObj(prop)
	;see if there is a brush selected
	prop := searchForBrushShortcutWhenRightClick( prop )

	if(prop.brushShortcutX){

		;now claculate the scroll
		prop.scrollerLeft := prop.bRight - 16
		prop.scrollerTop  := prop.bTop + 168
		prop.scrollerRight := prop.bRight - 4
		prop.scrollerBottom := prop.bBottom - 4
		prop.scrollerCenterY := prop.scrollerTop + 18
		prop.scrollerCenterX := prop.scrollerLeft + 6
		;prop.scrollUppX := prop.scrollerTop + 2
		;prop.scrollUppY := prop.scrollerLeft + 1
		;prop.scrollerOffset := 0
		ImageSearch, scrlBeginX, scrlBeginY, prop.scrollerLeft-1, prop.scrollerTop, prop.scrollerRight + 1, prop.scrollerBottom, %A_ScriptDir%\images\scollUp.png
		if(ErrorLevel =  1){

		}else{
			prop.scrollUppY := scrlBeginY
		}

		; now put the scroll to 96
		CoordMode, Mouse, Screen
		ofsssetQ := 96 - (prop.scrollUppY - prop.scrollerTop)
		if(Abs(ofsssetQ) > 5){
			MouseMove, prop.scrollerCenterX, prop.scrollUppY + 3, 0.0000001
			Click, down
			Sleep, 50
			MouseMove,  0, ofsssetQ , 1, R
			Click, up
		}
	
		;find if backface culling is on or off or disabled
		Sleep, 50
		CoordMode, Pixel
		prop := getBakfaceCulling( prop )
		
		;click on backface culling
		if(prop.backfaceCullingX){
			if(prop.backfaceCullingEnabled = 1){
				myClick(prop.backfaceCullingX, prop.backfaceCullingY, "left" )
				MouseMove, 0, 20 , 0, R
			}
		}

		;close the righjt cliked properties
		Send, {Esc}

	}else{
		;close the rightclicked porperties
		Send, {Esc}
		CornerNotify(1, "You need to be on the Properties for a Brush!!!", "", "r hc", 1)
	}

	if( isAlreadyHiddenUI = 0){
		;clic on the window menu
		myClick(winMenuX, winMenuY, "left")
		Sleep, 100
		;show all the UI
		myClick(list1.bLeft + 171, list1.bTop + 104, "left")
	}


	MouseMove, xpos, ypos ,0.0000001
	BlockInput, Off

	;give info after the script finished
	if(prop.backfaceCullingX){
		if(prop.backfaceCullingEnabled = 1){
			if(prop.backfaceCullingOn = 1){
				CornerNotify(1, "Backface Culling OFF", "", "r hc", 0)
			}else{
				CornerNotify(1, "Backface Culling ON", "", "r hc", 0)
			}
		}else{
			CornerNotify(1, "Backface Culling can't be chnaged because it's disabled", "", "r hc", 0)
		}
	}
}

getBakfaceCulling( pnl ){

	CoordMode, Pixel
	ImageSearch, bckCullX, bckCullY, pnl.bRight - 260, pnl.scrollerTop + 1, pnl.bRight - 207, pnl.bBottom, %A_ScriptDir%\images\on_Enabled.png
	if(ErrorLevel =  1){
		ImageSearch, bckCullX1, bckCullY1, pnl.bRight - 260, pnl.scrollerTop + 1, pnl.bRight - 207, pnl.bBottom, %A_ScriptDir%\images\off_Enabled.png
		if(ErrorLevel =  1){
			ImageSearch, bckCullX2, bckCullY2, pnl.bRight - 260, pnl.scrollerTop + 1, pnl.bRight - 207, pnl.bBottom, %A_ScriptDir%\images\on_Disabled.png
			if(ErrorLevel =  1){
				ImageSearch, bckCullX3, bckCullY3, pnl.bRight - 260, pnl.scrollerTop + 1, pnl.bRight - 207, pnl.bBottom, %A_ScriptDir%\images\off_Disabled.png
				if(ErrorLevel =  1){
					CornerNotify(1, "Can't see the backface culling option!!!", "", "r hc", 1)
				}else{
					pnl.backfaceCullingX := bckCullX3
					pnl.backfaceCullingY := bckCullY3
					pnl.backfaceCullingOn := 0
					pnl.backfaceCullingEnabled := 0
				}
			}else{
				pnl.backfaceCullingX := bckCullX2
				pnl.backfaceCullingY := bckCullY2
				pnl.backfaceCullingOn := 1
				pnl.backfaceCullingEnabled := 0
			}
		}else{
			pnl.backfaceCullingX := bckCullX1
			pnl.backfaceCullingY := bckCullY1
			pnl.backfaceCullingOn := 0
			pnl.backfaceCullingEnabled := 1
		}
	}else{
		pnl.backfaceCullingX := bckCullX
		pnl.backfaceCullingY := bckCullY
		pnl.backfaceCullingOn := 1
		pnl.backfaceCullingEnabled := 1
	}
	return pnl
}

getThePropWindow(){

	WinGet, WinList, List, ahk_exe Substance Painter.exe,,,
	Loop %WinList%
	{
		WinID := WinList%A_Index%
		WinGetClass, WinClass, ahk_id %WinID%
		
		if(WinClass == "Qt5QWindowToolSaveBits"){
			WinGetTitle, WinTitle, ahk_id %WinID%
			;bcm_splashInfo(WinTitle)
			If (WinTitle = "Substance Painter")
			{
				;bcm_splashInfo("foundddddddd")
				WinGetPos, aX, aY, aW, aH, ahk_id %WinID%
				break
			}
		}
	}

	prop := {}
	prop.bLeft := aX
	prop.bTop := aY
	prop.bRight := aX + aW
	prop.bBottom := aY + aH
	prop.bWidth := aW
	prop.bHeight := aH
	return prop
}


setBrushSpacingTo( myObj ){
	global brushSpacingDefault
	CoordMode, Mouse, Screen
	MouseGetPos, xpos, ypos 
	mSpeed = 0.000001
	pnl := getPanel("Properties")
	pnl := getScroll(pnl)
	;bcm_msgBObj(pnl)x
	pnl := searchForBrushShortcut(pnl)

	if(pnl.brushShortcutX){
		;it menas thet it is brush properties		
		;click on the surface nera the scroller up to make it active

		BlockInput, on
		myClick( pnl.bleft + 2, pnl.brushShortcutY + 2, "left")
		Sleep, 200
		myClick( pnl.bleft + 15, pnl.brushShortcutY + 18, "left")

		; navigate with tabs to spacing : 2 tabs
		;ControlSend, {Tab}, ahk_exe Substance Painter.exe
		Send, {Tab}
		;Sleep, 1000
		Send, {Tab}
		;Sleep, 1000

		spp := myObj.var
		;bcm_splashInfo(spp)

		Send, {%spp%}
		
		if(pnl.IconX){
		;if the panel was opened by clicking on the docked icon
			myClick(pnl.iconX, pnl.iconY, left)
		}

		MouseMove, xpos, ypos, mSpeed 
		BlockInput, Off


	}else{

		;if the panel was opened by clicking on the docked icon just close it
		BlockInput, on
		if(pnl.IconX){
			myClick(pnl.iconX, pnl.iconY, left)
		}
		MouseMove, xpos, ypos, mSpeed 
		BlockInput, Off

		CornerNotify(1, "!!! Can't set brush to " . myObj.var . ". You need to be on the Properties for a Brush!!!", "", "r hc", 1)
	}
}

setBrushAlignement(myObj){
	CoordMode, Mouse, Screen
	MouseGetPos, xpos, ypos 
	mSpeed = 0.000001
	pnl := getPanel("Properties")
	pnl := getScroll(pnl)
	;bcm_msgBObj(pnl)
	pnl := searchForBrushShortcut(pnl)

	if(pnl.brushShortcutX){
		;it menas thet it is brush properties		
		;click on the surface nera the scroller up to make it active

		BlockInput, on
		myClick( pnl.bleft + 2, pnl.brushShortcutY + 2, "left")
		Sleep, 200
		myClick( pnl.bleft + 15, pnl.brushShortcutY + 18, "left")

		; navigate with tabs to alignment : 7 tabs
		;ControlSend, {Tab}, ahk_exe Substance Painter.exe
		Send, {Tab}
		;Sleep, 1000
		Send, {Tab}
		;Sleep, 1000
		Send, {Tab}
		;Sleep, 1000
		Send, {Tab}
		;Sleep, 1000
		Send, {Tab}
		;Sleep, 1000
		Send, {Tab}
		;Sleep, 1000
		Send, {Tab}
		;Sleep, 1000


		;;set to camera first with the arrow up keys
		Send, {Up}
		;Sleep, 1000
		Send, {Up}
		;Sleep, 1000
		Send, {Up}
		;Sleep, 1000
		Send, {Up}
		;Sleep, 1000
		Send, {Up}
		;Sleep, 1000

		if(myObj.var = "UV"){
			; chose with the arrow keys
			Send, {Down}
			;Sleep, 1000
			Send, {Down}
			;Sleep, 1000
			Send, {Down}
			Sleep, 200

		}else if (myObj.var = "Tangent_Wrap"){
			Send, {Down}

		}
		else if (myObj.var = "Tangent_Planar"){
			Send, {Down}
			Send, {Down}


		}
		;if the panel was opened by clicking on the docked icon
		if(pnl.IconX){
			myClick(pnl.iconX, pnl.iconY, left)
		}

		MouseMove, xpos, ypos, mSpeed 
		BlockInput, Off


	}else{

		;if the panel was opened by clicking on the docked icon just close it
		BlockInput, on
		if(pnl.IconX){
			myClick(pnl.iconX, pnl.iconY, left)
		}
		MouseMove, xpos, ypos, mSpeed 
		BlockInput, Off

		CornerNotify(1, "!!! Can't set brush to " . myObj.var . ". You need to be on the Properties for a Brush!!!", "", "r hc", 1)
	}
}
searchForBrushShortcutWhenRightClick( pnl){
	CoordMode, Pixel
	ImageSearch, brshPropX, brshPropY, pnl.rightClickX - 3, pnl.rightClickY - 15, pnl.rightClickX + 30, pnl.rightClickY + 30, %A_ScriptDir%\images\brushPropertiesShortcutSelected2.png
	if(ErrorLevel = 2){
		bcm_splashInfo("eereeeeeeeeeee")
	}
	else if(ErrorLevel = 1){
	}else{
		pnl.brushShortcutX := brshPropX
		pnl.brushShortcutY := brshPropY
	}
	return pnl
}

searchForBrushShortcut( pnl){
	CoordMode, Pixel
	ImageSearch, brshPropX, brshPropY, pnl.bLeft, pnl.bTop + 149, pnl.bRight, pnl.bBottom, %A_ScriptDir%\images\brushPropertiesShortcutSelected.png
	if(ErrorLevel = 1){
		ImageSearch, brshPropX1, brshPropY1, pnl.bLeft, pnl.bTop + 149, pnl.bRight, pnl.bBottom, %A_ScriptDir%\images\brushPropertiesShortcutUnselected.png
		if(ErrorLevel = 1){

		}else{
			pnl.brushShortcutX := brshPropX1
			pnl.brushShortcutY := brshPropY1
		}
	}else{
		pnl.brushShortcutX := brshPropX
		pnl.brushShortcutY := brshPropY
	}
	return pnl
}

getInfoFromPainter( ){
	tr = {}
	ImageSearch, getInfoX, getInfoY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, %A_ScriptDir%\images\getInfoPlugin.png
	if (ErrorLevel = 1)
	{
		CornerNotify(1, "!!! Could not find the getInfoPlugin !!!", "", "r hc", 1)

	}
	Else
	{
		FileDelete checkDone.txt
		checkForChanges()
		BlockInput, On
			MouseClick, Left , getInfoX+10, getInfoY+10
		BlockInput, Off

	}


}

checkForChanges(){

	#Persistent
	setTimer, checkFile, On, 20
	return
	checkFile:
			;SplashImage , ,b1 cw501d0c ctffff00, %value% , Reloaded
		 ; 	Sleep,500
		 ; 	SplashImage, Off
		if FileExist("checkDone.txt"){
			setTimer, checkFile, Off
			infoWasSent()
			return
		}

	return

}

infoWasSent(){
	
	global toPerformAfterInfoGet
	global painterInfoObj


	Fileread, painterInfo, painterInfo.json
	StringReplace, painterInfo, painterInfo, false, "false", All
	StringReplace, painterInfo, painterInfo, true, "true", All
	;MsgBox, %painterInfo%
	;val := Jxon_Load(painterInfo)

	
	painterInfoObj := Jxon_Load(painterInfo)

	if( toPerformAfterInfoGet == "setChannelsToPassthrough"){
		setChannelsToPassthrough()

	}

}

setChannelsToPassthrough(){

	layPanel := getLayersPanel()
	listUIInfo := getListUIInfo(layPanel)
	currentLayer := getCurrentLayers( layPanel )
	if( listUIInfo.x ){
		if( currentLayer.bTop ){
			goThroughList(listUIInfo, currentLayer)
		}
	}

}


getLayersPanel(){

	layersPanel := getPanel("Layers")


	if(layersPanel.bRight){ 
		layersPanel.binButtonX := layersPanel.bRight - 18
		layersPanel.binButtonY := layersPanel.bTop + 50
		layersPanel.addFolderButtonX := layersPanel.bRight - 49
		layersPanel.addFolderButtonY := layersPanel.bTop + 50
		layersPanel.addSmartButtonX := layersPanel.bRight - 56
		layersPanel.addSmartButtonY := layersPanel.bTop + 75
		layersPanel.addFillButtonX := layersPanel.bRight - 103
		layersPanel.addFillButtonY := layersPanel.bTop + 50
		layersPanel.addLayButtonX := layersPanel.bRight - 130
		layersPanel.addLayButtonY := layersPanel.bTop + 50
		layersPanel.maskCfgButtonX := layersPanel.bRight - 158
		layersPanel.maskCfgButtonY := layersPanel.bTop + 50
		layersPanel.addFxButtonX := layersPanel.bRight - 183
		layersPanel.addFxButtonY := layersPanel.bTop + 50
	}
	return layersPanel


}

getLayerPanelScroller( lP ){
	tq := getScrollPosition(lP.bRight - 20, lP.bTop, lP.bRight ,lP.bBottom  )
	lP.scrollerLeft  := tq.scrollerLeft
	lP.scrollerTop := tq.scrollerTop
	lP.scrollerRight := tq.scrollerRight
	lP.scrollerBottom  := tq.scrollerBottom
	lP.scrollerCenterY := tq.scrollerCenterY
	lP.scrollerCenterX := tq.scrollerCenterX
	lP.scrollUppX := tq.scrollUppX
	lP.scrollUppY := tq.scrollUppY
	lP.scrollerOffset := tq.scrollerOffset
	lP.scrollDownX := tq.scrollDownX
	lP.scrollDownY := tq.scrollDownY
	lP.scrollerOffsetDown := tq.scrollerOffsetDown
	return lP
}

getListUIInfo( layersPanel ){

	listUI := {}
	ImageSearch, ListsUIX, ListsUIY, layersPanel.bLeft, layersPanel.bTop, layersPanel.bRight, layersPanel.bBottom, %A_ScriptDir%\images\listsArrow.png
	if (ErrorLevel = 1)
	{
		ImageSearch, ListsUIX1, ListsUIY1, layersPanel.bLeft, layersPanel.bTop, layersPanel.bRight, layersPanel.bBottom, %A_ScriptDir%\images\listsArrowDark.png
		if (ErrorLevel = 1)
		{
			CornerNotify(1, "!!! Could not find the lists !!!", "", "r hc", 1)
		}else{
			listUI.x := ListsUIX1
			listUI.y := ListsUIY1
			listUI1 := rrrrListss(listUI)
			;sss := listUI1.x
			;MsgBox, %sss%
			return listUI1
		}

	}
	Else
	{
		listUI.x := ListsUIX
		listUI.y := ListsUIY
		listUI2 := rrrrListss(listUI)
		;sss := listUI2.x
		;MsgBox, %sss%
		return listUI2

	}
}

rrrrListss( listUIInput ){
	;press first to see if there is a scroller
	listUI0 := {}
	listUI0.x := listUIInput.x
	listUI0.y := listUIInput.y
	MouseClick, Left , listUIInput.x-10, listUIInput.y+11
	Sleep, 200
	ImageSearch, ListsUIScrollX, ListsUIScrollY, listUIInput.x, listUIInput.y, %A_ScreenWidth%, %A_ScreenHeight%, %A_ScriptDir%\images\listsArrowScrlUp.png
	listUI0.hasScroll := 0
	if (ErrorLevel = 1)
	{
		;CornerNotify(1, "!!! No Scroll !!!", "", "r hc", 0)
		listUI0.hasScroll := 0
	}else{

		;CornerNotify(1, "!!! Has Scroll !!!", "", "r hc", 0)
		listUI0.hasScroll := 1
		listUI0.ScrollUpX := ListsUIScrollX + 5
		listUI0.ScrollUpY := ListsUIScrollY + 18
		ImageSearch, ListsUIScrollDownX, ListsUIScrollDownY, listUIInput.x, listUIInput.y, %A_ScreenWidth%, %A_ScreenHeight%, %A_ScriptDir%\images\listsArrowScrlDown.png
		if (ErrorLevel = 1)
		{
			CornerNotify(1, "!!! can't see the scroll down !!!", "", "r hc", 0)
		}else{
			listUI0.ScrollDownX := ListsUIScrollDownX + 5
			listUI0.ScrollDownY := ListsUIScrollDownY + 3
			listUI0.ScrollEndDDY := ListsUIScrollDownY + 9
		}
		; move the listUI ScrollUpp to the first sss
		MouseClick, Left , listUI0.ScrollUpX, listUI0.ScrollUpY+5
		MouseClick, Left , listUI0.ScrollUpX - 20, listUI0.ScrollUpY+5
	}
	MouseClick, Left , listUIInput.x-10, listUIInput.y+11

	Return, listUI0
}



goThroughList(listUI , currentLayer ){
	global painterInfoObj

	materials := painterInfoObj.materials

	For k, v in materials
		if (v.selected == "true"){
			;nm := v.name
			;MsgBox %nm% is selected
			cMaterial := v
			Break
		}
	
	channels := cMaterial.stacks[1].channels 
	channelsLength := ObjMaxIndex(channels)


	;go through each chnnel
	addA := 13
	kkA := addA
	strr := ""
	For kk, channel in channels{
		;strr .= " | " . channel 
		BlockInput, On
			MouseClick, Left , listUI.x-10, listUI.y+11
			Sleep, 500
			newYPos := listUI.y + 11 + kkA
			if( listUI.hasScroll == 1){
				if ( newYPos > listUI.ScrollEndDDY){
					MouseClick, Left , listUI.ScrollDownX, listUI.ScrollDownY
					Sleep, 200
					MouseClick, Left , listUI.ScrollDownX - 20, listUI.ScrollDownY
				}else{
					MouseClick, Left , listUI.x - 10, newYPos
					kkA := kkA + addA
						
				}
				
			}else{
				MouseClick, Left , listUI.x - 10, newYPos
				kkA := kkA + addA
			}
		

		;MouseClick, Left , listUI.x - 10, newYPos
		Sleep, 200
		;click on layersblend options

		MouseClick, Left, currentLayer.bRight - 30, currentLayer.bTop + 15
		Sleep, 200
		; set to passthrough
		MouseClick, Left, currentLayer.bRight - 30, currentLayer.bTop + 50 
		
		BlockInput, Off	


		Sleep, 200
	}
	; just to be sure click on the layer again
	MouseClick, Left, currentLayer.bRight - 100 , currentLayer.bTop + 2

}


getCurrentLayers( layersPanel ){
	currentLayer := {}
	ImageSearch, curreLayerX, curreLayerY, layersPanel.bRight - 12, layersPanel.bTop + 48, layersPanel.bRight,  layersPanel.bBottom, %A_ScriptDir%\images\selLayerColor.png
	if (ErrorLevel = 1)
	{
		CornerNotify(1, "!!! The selected layer should be fully visible !!!", "", "r hc", 1)

	}
	Else
	{
		currentLayer.bTop := curreLayerY + 1
		currentLayer.bBottom := curreLayerY + 40
		currentLayer.bLeft := layersPanel.bLeft
		currentLayer.bRight := layersPanel.bRight

	}
	return currentLayer
}

getShelf(){
	shelf :={}
	shelf := getPanel( "Shelf" )
	shelf := getShelfFolder( shelf )
	shelf := getShelfFilter( shelf )
	shelf := getShelfSerchesEndX( shelf )
	CoordMode, Mouse, Screen
	if(shelf.shelfSearchEndX = 1){
		sT1X := shelf.shelfSearchEndXX + 9
		sT1Y := shelf.shelfSearchEndXY + 9
		BlockInput, on
		myClick( sT1X , sT1Y, "left")
		BlockInput, off
		Sleep, 50
	}
	shelf := getShelfSearch( shelf )
	if (shelf.shelfSearchX){
		shelf := getShelfSearchX( shelf )
	}
	;msgBObj(shelf)
	return shelf
}

getShelfFolder( sh ){
	CoordMode, Pixel
	sh.shelfFolderX := sh.bLeft + 16
	sh.shelfFolderY := sh.bTop + 50
	ImageSearch, ShelfFolderEndX, ShelfFolderEndY, sh.shelfFolderX, sh.shelfFolderY , sh.bRight, sh.shelfFolderY + 11, %A_ScriptDir%\images\folderActiveBand.png
	if (ErrorLevel = 1)
	{
		;CornerNotify(1, "!!! The shelf FolderEnd is 1not visible !!!", "", "r hc", 1)
		sh.shelfFolderActive := 0
		sh.shelfFolderEndX := sh.bLeft
	}
	Else{
		sh.shelfFolderEndX := ShelfFolderEndX + 3 
		sh.shelfFolderActive := 1
	}

	return sh
}
getShelfFilter( sh ){
	
	if( sh.shelfFolderX ){
		shStartX := sh.shelfFolderX + 10
		shStartY := sh.shelfFolderY - 10
		shEndY := sh.shelfFolderY + 20

	}else{
		shStartX := sh.bLeft
		shStartY := sh.bTop
		shEndY := sh.bBottom
	}
	CoordMode, Pixel
	ImageSearch, ShelfFilterX, ShelfFilterY, sh.bLeft, sh.bTop, sh.bRight, sh.bTop + 100, %A_ScriptDir%\images\filerActive.png
	if (ErrorLevel = 1)
	{
		CoordMode, Pixel
		ImageSearch, ShelfFilterX, ShelfFilterY, sh.bLeft, sh.bTop, sh.bRight, sh.bTop + 100, %A_ScriptDir%\images\filerInactive.png
		if (ErrorLevel = 1)
		{
		;shelf Filter could not be found
			CornerNotify(1, "!!! The shelf Filter is not visible !!!", "", "r hc", 1)
		}Else{
			sh.shelfFilterX := ShelfFilterX
			sh.shelfFilterY := ShelfFilterY
			sh.shelfFilterActive := 0
			;return tr
		}	
	}Else{
			sh.shelfFilterX := ShelfFilterX
			sh.shelfFilterY := ShelfFilterY
			sh.shelfFilterActive := 1
			CoordMode, Pixel
			ImageSearch, ShelfFilterEndX, ShelfFilterEndY, sh.shelfFilterX, sh.shelfFilterY + 29, sh.bRight, sh.shelfFilterY + 36, %A_ScriptDir%\images\filterActiveBand.png
			if (ErrorLevel = 1)
			{
				CornerNotify(1, "!!! The shelf FilterEnd is not visible !!!", "", "r hc", 1)
			}
			Else{
				sh.shelfFilterEndX := ShelfFilterEndX + 3
			}
	}
	return sh
}


getShelfSerchesEndX( sh ){
	CoordMode, Pixel
	ImageSearch, ShelfSearchEndXX, ShelfSearchEndXY, sh.shelfFilterX + 12, sh.shelfFilterY - 7, sh.bRight, sh.shelfFilterY + 20, %A_ScriptDir%\images\searchX.png
	if (ErrorLevel = 1)
	{
		ImageSearch, ShelfSearchEndXX, ShelfSearchEndXY, sh.shelfFilterX + 12, sh.shelfFilterY - 7, sh.bRight, sh.shelfFilterY + 20, %A_ScriptDir%\images\searchX2.png
		if (ErrorLevel = 1)
		{
			sh.shelfSearchEndX := 0
		}else{
			sh.shelfSearchEndX := 1
			sh.shelfSearchEndXX := ShelfSearchEndXX
			sh.shelfSearchEndXY := shelfSearchEndXY
		}
	}else{
		sh.shelfSearchEndX := 1
		sh.shelfSearchEndXX := ShelfSearchEndXX
		sh.shelfSearchEndXY := shelfSearchEndXY
	}
	return sh
}

getShelfSearchX( sh ){
	CoordMode, Pixel
	ImageSearch, ShelfSearchFilterOnX, ShelfSearchFilterOnY, sh.shelfSearchX - 35 , sh.shelfSearchY , sh.shelfSearchX, sh.shelfSearchY + 27, %A_ScriptDir%\images\searchFilterX.png
	if (ErrorLevel = 1)
	{
		sh.shelfSearchFilterOn := 0
	}Else{
		sh.shelfSearchFilterOn := 1
		sh.shelfSearchFilterOnX := ShelfSearchFilterOnX
		sh.shelfSearchFilterOnY := ShelfSearchFilterOnY
	}
	return sh
}

getShelfSearch( sh ){
	CoordMode, Pixel
	ImageSearch, ShelfSearchX, ShelfSearchY, sh.shelfFilterX + 12, sh.shelfFilterY - 7, sh.bRight, sh.shelfFilterY + 24, %A_ScriptDir%\images\searchStart.png
	if (ErrorLevel = 1)
	{
		ImageSearch, ShelfSearchX, ShelfSearchY, sh.shelfFilterX + 12, sh.shelfFilterY - 7, sh.bRight, sh.shelfFilterY + 24, %A_ScriptDir%\images\searchStartOn.png
		if (ErrorLevel = 1){
			CornerNotify(1, "!!! The shelf Search is not visible !!!", "", "r hc", 1)
		}Else{
			sh.shelfSearchX := ShelfSearchX + 1
			sh.shelfSearchY := ShelfSearchY + 1
			sh.shelfSearchOn := 1
		}
	}Else{
			sh.shelfSearchX := ShelfSearchX + 1
			sh.shelfSearchY := ShelfSearchY + 1
			sh.shelfSearchOn := 0
	}
	return sh
}


getShelfTab( sh ){

	ImageSearch, ShelfTabX, ShelfTabY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, %A_ScriptDir%\images\shelfActive.png
	if (ErrorLevel = 1)
	{
		ImageSearch, ShelfTabX, ShelfTabY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, %A_ScriptDir%\images\shelfInactive.png
		if (ErrorLevel = 1)
		{
		;shelf tab could not be found
			CornerNotify(1, "!!! The shelf tab is not visible !!!", "", "r hc", 1)
		}Else{
			sh.shelfTabX := ShelfTabX
			sh.shelfTabY := ShelfTabY
			sh.shelfTabActive := 0
			;return tr
		}	
	}Else{
			sh.shelfTabX := ShelfTabX
			sh.shelfTabY := ShelfTabY
			sh.shelfTabActive := 1
			;MsgBox, ssss is .%tr.shelfTabX%
			;return tr
	}
	return sh
}


shelfSearchAndSelect( myOb ){
	CoordMode, Mouse, Screen
	MouseGetPos, xpos, ypos 
	mSpeed = 0.000001
	shelfA := getShelf()
	if(shelfA.shelfSearchX){
		sX := shelfA.shelfSearchX + 2
		sY := shelfA.shelfSearchY + 4
		;MsgBox, %sX% . %sY%
		BlockInput, on
		myClick( sX , sY, "left") ; clcik on the serch field
		
		;clear the field
		Send {Home}
		Send {Shift}+{End}
		Send {Backspace}

		;if there is a filter on just close it
		if (shelfA.shelfSearchFilterOn = 1){
			sfX := shelfA.shelfSearchFilterOnX + 5
			sfY := shelfA.shelfSearchFilterOnY + 5
			myClick( sfX , sfY, "left")
		}

		;send text to search
		myText := myOb.toSearch
		clipboard := myText
		Send, ^v
		;Send {Text} %myText%

		;bcm_msgBObj(shelfA)
		;select result
		if( myOb.selectFirst = "True"){
			selX := shelfA.shelfFolderX + 10
			selY := shelfA.shelfFolderY + 35
			if(shelfA.shelfFolderActive = 1){
				selX := shelfA.shelfFolderEndX + 10
			}
			if( shelfA.shelfFilterActive = 1){
				selX := shelfA.shelfFilterEndX + 10

			}
			Sleep, 100
			clk := myOb.click
			Loop, %clk%{
				myClick( selX , selY, "left")
				Sleep, 100
			}
			
		}
		if( myOb.clearAfter = "True"){
			myClick( sX , sY, "left")
			Send {Home}
			Send {Shift}+{End}
			Send {Backspace}
		}
		BlockInput, off
		MouseMove, xpos, ypos, mSpeed  
		BlockInput, Off
	}
}

getViewport(){
	;;
	pntr := findPainterWindow( )
	vp := {}
	CoordMode, Pixel
	ImageSearch, vX, vY, pntr.bLeft, pntr.bTop, pntr.bRight, pntr.bBottom, %A_ScriptDir%\images\upperViewportCamera.png
	if (ErrorLevel = 1){
			CornerNotify(1, "!!! Couldn't find the viewport's upper camera !!!", "", "r hc", 1)

	}else{
		vp.bRight := vX + 68
		vp.bTop := vY + 27

		ImageSearch, bX, bY, vp.bRight - 4v, vp.bTop, vp.bRight + 1, pntr.bBottom, %A_ScriptDir%\images\bottomPanel.png
		if (ErrorLevel = 1){
			CornerNotify(1, "!!! Couldn't find the viewport's bottom border  !!!", "", "r hc", 1)
		}else{
			vp.bBottom := bY - 7
			ImageSearch, cX, cY, pntr.bLeft, vp.bBottom + 4 , vp.bRight, vp.bBottom + 10, %A_ScriptDir%\images\viewportLeftBorder.png
			if (ErrorLevel = 1){
				CornerNotify(1, "!!! Couldn't find the viewport's left border  !!!", "", "r hc", 1)
			}else{
				vp.bLeft := cX + 1
			}
		}
	}
	;getBrushUppOptions( "Size" )
}


getPanel( typ ){
	global bcm_workArea
	bcm_workArea := getAllPixelsMonitors()

	qPanel := {}
	qPanel := findFloatPanel( typ )
	CoordMode, Pixel
	if(qPanel.bLeft){
		;the panel is floating so we don't need to search with image search
		;bcm_msgBObj(qPanel)
	}else{
		;first seach for docker image

		prIc := getDockedIcon( typ )
		;bcm_msgBObj(prIc)
		if( prIc.isOn = 0){

			qPanel.IconX := prIc.dockedIconX + 10
			qPanel.IconY := prIc.dockedIconY + 10
			qPanel := getWindowUnDocked( qPanel, typ )
			qPanel.IconXWasClicked := 1

		}else{
			linkITitle := A_ScriptDir . "\images\" . typ . ".png"
			ImageSearch, propFoundX, propFoundY, bcm_workArea.startX , bcm_workArea.startY, bcm_workArea.endX, bcm_workArea.endY, %linkITitle%
			if (ErrorLevel = 2)
			{
			    CornerNotify(1, "!!! Could not conduct the search !!!", "", "r hc", 1)
			}
			else if (ErrorLevel = 1)
			{
				;didnt found the main title of panel image, search for the tabbed
				qPanel := getTabbedPanel( typ )

			}
			else
			{
				;the main title image found, set the top and left
				qPanel.bLeft :=  propFoundX - 6
				qPanel.bTop := propFoundY - 14  
				;now find the bottom
				ImageSearch, propEndPanelDownX, propEndPanelDownY, qPanel.bLeft, qPanel.bTop + 4, qPanel.bLeft + 100, bcm_workArea.endY, %A_ScriptDir%\images\bottomPanel.png
				if (ErrorLevel = 1)
				{
				    CornerNotify(1, "!!! end of " . typ . " panel could not be found on the screen !!!", "", "r hc", 1)
				}
				else{
					;the bottom found
					qPanel.bBottom := propEndPanelDownY + 1
					;now search for the "x" close
					ImageSearch, propClosePanelX, propClosePanelY, qPanel.bLeft, qPanel.bTop + 8, bcm_workArea.endX , qPanel.bTop + 26, %A_ScriptDir%\images\closePanel.png
					if (ErrorLevel = 1)
					{
					    CornerNotify(1, "!!! close of " . typ . " panel could not be found on the screen !!!", "", "r hc", 1)
					}
					else{
						qPanel.bRight := propClosePanelX + 21 	

						;BlockInput, On
						;MouseMove, qPanel.bLeft, qPanel.bTop, 10
						;MouseMove, qPanel.bLeft, qPanel.bBottom, 10
						;MouseMove, qPanel.bRight, qPanel.bBottom, 10
						;MouseMove, qPanel.bRight, qPanel.bTop, 10
						;BlockInput, Off

						
					}
				}
			}
		}
	}
	return qPanel

}

getTabbedPanel( styp ){
	;bcm_splashInfo( "started tabbed" )
	global bcm_workArea
	;bcm_msgBObj(bcm_workArea)
	CoordMode, Pixel
	linkITabbed := A_ScriptDir . "\images\" . styp . "Tabbed.png"
	linkITabbedSelected := A_ScriptDir . "\images\" . styp . "TabbedSelected.png"
	qRRPanel := {}
	ImageSearch, propFoundX, propFoundY, bcm_workArea.startX , bcm_workArea.startY, bcm_workArea.endX, bcm_workArea.endY, %linkITabbed%
	if (ErrorLevel = 1)
	{
		ImageSearch, propFoundX, propFoundY, bcm_workArea.startX , bcm_workArea.startY, bcm_workArea.endX, bcm_workArea.endY, %linkITabbedSelected%
		if (ErrorLevel = 1)
		{
			CornerNotify(1, "!!! '" . typ . "' could not be found on the screen !!!", "", "r hc", 1)
		}else{
			;it's tabbed selected
			;bcm_splashInfo( "tabbed selected" )
			qRRPanel.bTop := propFoundY - 14
			qRRPanel.tabbed := 1
			qRRPanel.tabbedSelected := 1
		}
	}else{
		;it's tabbed unselected
		;bcm_splashInfo( "tabbed unselected" )
		qRRPanel.bTop := propFoundY - 14
		qRRPanel.tabbed := 1
		qRRPanel.tabbedSelected := 0
	}

	if(qRRPanel.bTop){
		;bcm_splashInfo("looking for left")
		;search for left, right and bottom starting from the found tabbed images
		;left::
		llimg := A_ScriptDir . "\images\panelLeftBorder.png"
		lleftX := recursiveToFindLastX( bcm_workArea.painterStartX, propFoundY, propFoundX, propFoundY + 9, llimg, 1)
		if(lleftX == bcm_workArea.painterStartX){
			CornerNotify(1, "!!! '" . typ . "'s left panel border could not be found on the screen !!!", "", "r hc", 1)
			qRRPanel := {}
		}else{
			qRRPanel.bLeft := lleftX
			;bcm_splashInfo(lleftX)
		}

		;right
		if(qRRPanel.bLeft){
			CoordMode, Pixel
			ImageSearch, qRightX, qRightY, propFoundX , propFoundY, bcm_workArea.painterEndX, propFoundY + 9, %llimg%
			if (ErrorLevel = 1)
			{
				CornerNotify(1, "!!! '" . typ . "'s right panel border could not be found on the screen !!!", "", "r hc", 1)
				qRRPanel := {}
			}else{
				qRRPanel.bRight := qRightX + 1
			}
		}

		;bottom
		if(qRRPanel.bRight){
			CoordMode, Pixel
			ImageSearch, qBtmX, qBtmY, qRRPanel.bLeft + 1 , qRRPanel.bTop + 5, qRRPanel.bRight, bcm_workArea.painterEndY, %A_ScriptDir%\images\bottomPanel.png
			if (ErrorLevel = 1)
			{
				CornerNotify(1, "!!! '" . typ . "'s bottom panel border could not be found on the screen !!!", "", "r hc", 1)
				qRRPanel := {}
			}else{
				qRRPanel.bBottom := qBtmY
			}
		}
	}
	return qRRPanel
}

recursiveToFindLastX( startX, startY , endx, endY , img, imgWidth){
	;MsgBox, , , %startX%
	CoordMode, Pixel
	ImageSearch, fndX, fndY, startX , startY, endx, endY, %img%
	if (ErrorLevel = 1)
	{
		fndX := startX - imgWidth
		;CornerNotify(1, "!!! '" . typ . "' left panel border could not be found on the screen !!!", "", "r hc", 1)
	}else{
		fndX += imgWidth
		fndX := recursiveToFindLastX( fndX, fndY , endx, endY , img, imgWidth)
	}
	return fndX
}

getWindowTest( ){
	pr := {}

	WinGet, WinID, ID, ahk_exe Substance Painter.exe,,,
	WinGetPos, aX, aY, aW, aH, ahk_id %WinID%
	WinGetClass, aClass, ahk_id %WinID%
	qr := GetMonitorUnderMouse2()
	;splashInfo(" x: " . aX . " y: " . aY . " w: " . aW . " h: " . aH . " class: " . aClass)
	if (aClass = "Qt5QWindowPopupDropShadowSaveBits"){
		if(aX < 0){
			pr.bLeft := A_ScreenWidth + aX + 4 + 2
		}else{
			pr.bLeft := aX + 4 + 2
		}
		pr.bRight := pr.bLeft + aW - 4
		pr.bTop := aY + 4 + 2
		pr.bBottom := pr.bTop + aH - 4
	}
	pr.aClass := aClass
	pr.bHeight := aH
	pr.bWidth := aW
	return pr
}




getWindowUnDocked( pr, typ ){
	; this will click on the dock icon to show the panel
	cX := pr.IconX
	cY := pr.IconY
	;bcm_msgBObj(pr)
	CoordMode, Mouse, Screen
	MouseGetPos, xpos, ypos 
	mSpeed := 0.000001
	BlockInput, on
	myClick( cX , cY, "left")
	pr.IconXWasClicked := 1
	Sleep, 100

	flP := findFloatPanel( typ )

	if(flP.bLeft){
		pr.bLeft := flP.bLeft
		pr.bRight := flP.bRight 
		pr.bTop := flP.bTop
		pr.bBottom := flP.bBottom
		
	}
	;WinGet, WinID, ID, ahk_exe Substance Painter.exe,,,
	;WinGetPos, aX, aY, aW, aH, ahk_id %WinID%
	;WinGetClass, aClass, ahk_id %WinID%
	;;qr := GetMonitorUnderMouse2()
	;;splashInfo(" x: " . aX . " y: " . aY . " w: " . aW . " h: " . aH . " class: " . aClass)
	;if (aClass = "Qt5QWindowToolSaveBits"){
	;	if(aX < 0){
	;		pr.bLeft := A_ScreenWidth + aX + 4 + 2
	;	}else{
	;		pr.bLeft := aX + 4 + 2
	;	}
	;	pr.bRight := pr.bLeft + aW - 4
	;	pr.bTop := aY + 4 + 2
	;	pr.bBottom := pr.bTop + aH - 4
	;}
	BlockInput, off
	MouseMove, xpos, ypos, mSpeed  

	return pr
}

getFilterTab( pr ){
	;ImageSearch, propFoundX, propFoundY, pr.bLeft + 103, pr.bTop + 22, pr.bRight - 50, pr.bTop + 43, %A_ScriptDir%\images\filterTab.png
	;if(ErrorLevel = 1){
	;	CornerNotify(1, "!!! Filter tabBar could not be found on the screen !!!", "", "r hc", 1)
	;}else{
		pr.filterTabBarY := pr.bTop + 35
		ImageSearch, propFound2X, propFound2Y, pr.bLeft, pr.bTop + 22, pr.bLeft - 30, pr.bLeft + 44, %A_ScriptDir%\images\filterTabArrowDown.png
		if(ErrorLevel = 1){
				pr.filterTabBarOpened := 0
			}else{
				pr.filterTabBarOpened := 1

			}
			pr.filterTabArrowX := pr.bLeft + 16
			pr.filterTabArrowY := pr.bLeft + 35
	;}
	return pr
}

getSBSField(pr){
	CoordMode, Pixel
	CoordMode, Mouse, Screen

	ImageSearch, sbsFoundX, sbsFoundY, pr.bLeft + 7, pr.bTop + 31, pr.bLeft + 11, pr.bBottom, %A_ScriptDir%\images\SBSFieldLeft.png
	if(ErrorLevel = 1){
		CornerNotify(1, "!!! Filter loading area could not be found on the screen !!!", "", "r hc", 1)
	}else{
		pr.sbsFieldTop := sbsFoundY
		pr.sbsFieldLeft := sbsFoundX
	}
	return pr
}
filterSearchAndCreate( myObj ){
	ob := createEffects( myObj )
	sleep 100
	if(ob.bTop){
		;it means that the layers was found in the createEffects()
		filterSearchAndSelect( myObj )
	}
}


filterSearchAndSelect( myObj ){
	flr := getFilterSearch()
	CoordMode, Mouse, Screen
	MouseGetPos, xpos, ypos 
	mSpeed = 0.000001
	if(flr.bRight){
		BlockInput, on
		if(flr.scrollerOffset > 0){
			moveScrollUp( flr )
		} 

		flr := getSBSField(flr)

		;bcm_msgBObj(flr)
		if( flr.sbsFieldTop){

			sx1 := flr.sbsFieldLeft + 19
			sy1 := flr.sbsFieldTop + 14

			flr.searchBLeft := sx1
			flr.searchBTop := sy1
			flr.searchBRight := flr.searchBLeft + 297
			flr.searchBBottom := flr.searchBTop + 284
			if(flr.searchBRight > A_ScreenWidth){
				flr.searchBRight := A_ScreenWidth
				flr.searchBLeft := flr.searchBRight - 297
			}
			if(flr.searchBBottom > A_ScreenHeight){
				flr.searchBBottom := sy1
				flr.searchBTop := sy1 - 284
			}
			;open search window
			myClick( sx1 , sy1, "left")
			Send {Home}
			Send {Shift}+{End}
			Send {Backspace}

			myText := myObj.toSearch
			clipboard := myText
			Send, ^v
			;bcm_msgBObj(flr)
			if( myObj.selectFirst = "True"){
				;click for selecting the filter
				sx2 := flr.searchBLeft + 27
				sy2 := flr.searchBTop + 74
				Sleep 50
				if( flr.IconX ){
					CoordMode, Mouse, Screen
					myClick( sx2 , sy2, "left")
					if(flr.IconXWasClicked = 1){
						;close the panel, click on the icon again
						sx3 := flr.IconX
						sy3 := flr.IconY
						myClick( sx3 , sy3, "left")
					}
				}else{
					myClick( sx2 , sy2, "left")
				}
			}
		}

		BlockInput, off
		CoordMode, Mouse, Screen
		MouseMove, xpos, ypos, mSpeed  
	}

	return
}
getFilterSearch(){
	pr := getPanel("Properties")
	;bcm_msgBObj(pr)
	if(pr.bRight) prSc := getScroll( pr )
	return pr
}

;====================masks
;================================================================
;================================================================
maskCreate( myObj ){
	CoordMode, Mouse , Screen
	MouseGetPos, xpos, ypos 
	mSpeed := 0.000001
	lay := getLayersPanel()
	msk := getMaskButton(lay)
	;bcm_msgBObj(msk)
	mx := msk.x + 4
	my := msk.y + 4
	BlockInput, on
	myClick( mx , my, "left")
	Sleep, 100
	if( myObj.var = "addBlackMask"){
		my1 := msk.addBlackMask
		myClick( mx , my1, "left")
	}else if(myObj.var = "addWhiteMask"){
		my1 := msk.addWhiteMask
		myClick( mx , my1, "left")
	}else if(myObj.var = "addBitmapMask"){
		my1 := msk.addBitmapMask
		myClick( mx , my1, "left")
	}else if(myObj.var = "addMaskWithCS"){
		my1 := msk.addMaskWithCS
		myClick( mx , my1, "left")
	}
	CoordMode, Mouse , Screen
	MouseMove, xpos, ypos, mSpeed  
	BlockInput, Off
	Return
}

getMaskButton( layersP ){
	tr :={}
	tr.x := layersP.maskCfgButtonX
	tr.y := layersP.maskCfgButtonY
	tr.addWhiteMask := layersP.maskCfgButtonY + 25
	tr.addBlackMask := layersP.maskCfgButtonY + 48
	tr.addBitmapMask := layersP.maskCfgButtonY + 69
	tr.addMaskWithCS := layersP.maskCfgButtonY + 89
	;tr.toggleMask := layersP.maskCfgButtonY + 114
	;tr.invertMaskBck := layersP.maskCfgButtonY + 133
	;tr.invertMask := layersP.maskCfgButtonY + 161
	;tr.clearMask := layersP.maskCfgButtonY + 180
	;tr.removetMask := layersP.maskCfgButtonY + 199
	;tr.expMaskToFile := layersP.maskCfgButtonY + 218
	;tr.expMaskToClipboard := layersP.maskCfgButtonY + 237
	return tr
}


;--------------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------------

 maskGroupUI(){
 	global searchesObj
 	searchesObj :={}
 	;wer := searchesObj.buttonsA[1].name
 	;MsgBox, %wer%
 	Fileread, searches1, masksButtons.json
	searchesObj := Jxon_Load(searches1)
	custWindow( "Mask creations", "masksButtons.json" )
	Return
 }
 shelfSearchUI(){
 	global searchesObj
 	searchesObj :={}
 	;wer := searchesObj.buttonsA[1].name
 	;MsgBox, %wer%
 	Fileread, searches1, searches.json
	searchesObj := Jxon_Load(searches1)
	custWindow( "Shelf Predefined Searches", "searches.json" )
	Return
 }
custWindow( ttl, opFile ){
	global openedFile, winSerTitle
	winSerTitle := ttl
	openedFile := opFile
	winSearches( ttl )
}

SH_GroupUI( myObj ){
	global searchesObj, openedFile
	isFile := FileExist( myObj.file)
	if(isFile = ""){
		jStrNew := "{`n`t""buttonsA"": [`n`t`t{`n`t`t`t""command"": """",`n`t`t`t""name"": ""."",`n`t`t`t""shortcut"": """"`n`t`t}`n`t]`n}"
		openedFile := myObj.file
		FileAppend, %jStrNew% , %openedFile%

		Fileread, searches, %openedFile%
	}else{
		openedFile := myObj.file
		Fileread, searches, %openedFile%
	}

	searchesObj := Jxon_Load(searches)
	custWindow( myObj.title, myObj.file)
	Return
}




;--------------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------------

;toogleHide(){
;	layPanel := getLayersPanel()
; 	;if (layPanel.bRight) layPanel := getLayerPanelScroller(layPanel)
; 	layPanel := getSelectedLayerP(layPanel)
;}
;selectUppMainLayStack(){
; 	layPanel := getLayersPanel()
; 	;if (layPanel.bRight) layPanel := getLayerPanelScroller(layPanel)
; 	layPanel := getSelectedLayerP(layPanel)
; 	;bcm_msgBObj(layPanel)
; 	doIt := 0
; 	if(layPanel.activestackUp){
; 		cy := layPanel.activestackUp - 4
; 		cx := layPanel.bLeft + ((layPanel.bRight - layPanel.bLeft)*.5) 
; 		doIt := 1
; 	}else if( layPanel.activeLayUp ){
; 		cy := layPanel.activeLayUp - 4
; 		cx := layPanel.bLeft + ((layPanel.bRight - layPanel.bLeft)*.5)
; 		doIt := 1
; 	}
; 	if(doIt = 1){
; 		CoordMode, Mouse , Screen
;	 	;splashInfo(cx)
;	 	MouseGetPos, xpos, ypos 
;	 	mSpeed := 0.000001
;	 	BlockInput, On
;	 	myClick( cx , cy, "left")
;		MouseMove, xpos, ypos, mSpeed  
;		BlockInput, off
;   	}
;	Return
;}


 selectUpperLayStack(){
 	layPanel := getLayersPanel()
 	;if (layPanel.bRight) layPanel := getLayerPanelScroller(layPanel)
 	layPanel := getSelectedLayerP(layPanel)
 	doIt := 0
 	if(layPanel.activestackUp){
 		cy := layPanel.activestackUp - 4
 		cx := layPanel.bLeft + ((layPanel.bRight - layPanel.bLeft)*.5) 
 		doIt := 1
 	}else if( layPanel.activeLayUp ){
 		cy := layPanel.activeLayUp - 4
 		cx := layPanel.bLeft + ((layPanel.bRight - layPanel.bLeft)*.5)
 		doIt := 1
 	}
 	if(doIt = 1){
 		CoordMode, Mouse , Screen
	 	;splashInfo(cx)
	 	MouseGetPos, xpos, ypos 
	 	mSpeed := 0.000001
	 	BlockInput, On
	 	myClick( cx , cy, "left")
		MouseMove, xpos, ypos, mSpeed  
		BlockInput, off
   	}
	Return
}

selectDownLayStack(){

 	layPanel := getLayersPanel()
 	;if (layPanel.bRight) layPanel := getLayerPanelScroller(layPanel)
 	layPanel := getSelectedLayerP(layPanel)
 	doIt := 0
 	if(layPanel.activestackDown){
 		cy := layPanel.activestackDown + 4
 		cx := layPanel.bLeft + ((layPanel.bRight - layPanel.bLeft)*.5) 
 		doIt := 1
 	}else if( layPanel.activeLayDown ){
 		cy := layPanel.activeLayDown + 4
 		cx := layPanel.bLeft + ((layPanel.bRight - layPanel.bLeft)*.5)
 		doIt := 1
 	}
 	if(doIt = 1){
 		CoordMode, Mouse , Screen
	 	;splashInfo(cx)
	 	MouseGetPos, xpos, ypos 
	 	mSpeed := 0.000001
	 	BlockInput, On
	 	myClick( cx , cy, "left")
		MouseMove, xpos, ypos, mSpeed  
		BlockInput, off
   	}
	Return
}



 selectMask( ){
 	layPanel := getLayersPanel()
 	;if (layPanel.bRight) layPanel := getLayerPanelScroller(layPanel)
 	layPanel := getSelectedLayerP(layPanel)
 	CoordMode, Mouse, Screen
 	if(layPanel.activeLayUp) layPanel := getLayerIcons(layPanel)
 	;if(layPanel.hasMask) layPanel := isMaskActive( layPanel )

 	cx := layPanel.acvLayMaskCenterX
 	cy := layPanel.activeLayUp + 18
 	MouseGetPos, xpos, ypos 
 	mSpeed := 0.000001
 	BlockInput, On
 	CoordMode, Mouse, Screen
 	myClick( cx , cy, "left")
 	CoordMode, Mouse, Screen
	MouseMove, xpos, ypos, mSpeed  
	BlockInput, off

 	Return
 }

 viewMask( ){
 	doIt := 0
 	doItD := 0
 	layPanel := getLayersPanel()
 	;if (layPanel.bRight) layPanel := getLayerPanelScroller(layPanel)
 	layPanel := getSelectedLayerP(layPanel)
 	layPanel := getLayerIcons(layPanel)
 	;msgBobj(layPanel)
 	if(layPanel.hasMask = 1) doIt := 1
 	if(layPanel.activestackDown){
 		dy := layPanel.activestackUp + 4
 		dx := layPanel.bRight - 100
 		doItD := 1
 	}
 	CoordMode, Mouse , Screen
	MouseGetPos, xpos, ypos 
	mSpeed := 0.000001
 	if( doIt = 1){
	 	cx := layPanel.acvLayMaskCenterX
	 	cy := layPanel.activeLayUp + 18
	 	BlockInput, On
		Send !{myClick( cx , cy, "left")}
		if(doItD = 1){
			myClick( dx , dy, "left")
		}
		MouseMove, xpos, ypos, mSpeed  
		BlockInput, off
 	}
 	Return
 }

 toggleMask( ){
 	doIt := 0
 	doItD := 0
 	layPanel := getLayersPanel()
 	;if (layPanel.bRight) layPanel := getLayerPanelScroller(layPanel)
 	layPanel := getSelectedLayerP(layPanel)
 	layPanel := getLayerIcons(layPanel)
 	CoordMode, Mouse, Screen
 	if(layPanel.hasMask = 1) doIt := 1
 	if(layPanel.activestackDown){
 		dy := layPanel.activestackUp + 4
 		dx := layPanel.bRight - 120
 		doItD := 1
 	}
	MouseGetPos, xpos, ypos 
	mSpeed := 0.000001
 	if( doIt = 1){
	 	cx := layPanel.acvLayMaskCenterX
	 	cy := layPanel.activeLayUp + 18
	 	BlockInput, On
		Send +{myClick( cx , cy, "left")}
		if(doItD = 1){
			myClick( dx , dy, "left")
		}
		MouseMove, xpos, ypos, mSpeed  
		BlockInput, off
 	}
 	Return
 }

removeMask(){
	layPanel := getLayersPanel()
	layPanel := getSelectedLayerP(layPanel)
	CoordMode, Mouse , Screen
	MouseGetPos, xpos, ypos 
	mSpeed := 0.000001
	BlockInput, On
	ay := layPanel.activeLayUp + 20
	ax := layPanel.bLeft + 10
	myClick( ax , ay, "right")
	Sleep, 100
	layPanel := getLayContextWindow(layPanel)
	by := layPanel.actvLayCtxRemoveMask
	bx := ax + 10
	myClick( bx , by, "right")
	MouseMove, xpos, ypos, mSpeed  
	BlockInput, off
	;msgBobj(layPanel)

}
clearMask(){
	layPanel := getLayersPanel()
	layPanel := getSelectedLayerP(layPanel)
	CoordMode, Mouse , Screen
	MouseGetPos, xpos, ypos 
	mSpeed := 0.000001
	BlockInput, On
	ay := layPanel.activeLayUp + 20
	ax := layPanel.bLeft + 10
	myClick( ax , ay, "right")
	Sleep, 100
	layPanel := getLayContextWindow(layPanel)
	by := layPanel.actvLayCtxClearMask
	bx := ax + 10
	myClick( bx , by, "left")
	MouseMove, xpos, ypos, mSpeed  
	BlockInput, off

}
removeEffect(){
	layPanel := getLayersPanel()
	layPanel := getSelectedLayerP(layPanel)
	;msgBobj(layPanel)
	if(layPanel.activeStackUp){
		layPanel := getStacksAfterActive(layPanel)
		CoordMode, Mouse , Screen
		MouseGetPos, xpos, ypos 
		mSpeed := 0.000001
		BlockInput, On
		ay := layPanel.activeStackUp + 11
		ax := layPanel.bRight - 22
		myClick( ax , ay, "left")
		doClickSel := 0
		mx := layPanel.bRight - 120
		if(layPanel.stacksAfterActive > 0){
			my2 := layPanel.activeStackUp + 11
			doClickSel := 1
		}else if( layPanel.stacksBeforeActive > 0){
			my2 := layPanel.activeStackUp - 11
			doClickSel := 1
		}
		if(doClickSel = 1){
			Sleep, 200
			myClick( mx , my2, "left")
		}
		CoordMode, Mouse , Screen
		MouseMove, xpos, ypos, mSpeed  
		BlockInput, off
	}

}


 tglSelectCorOrMask(){
 	layPanel := getLayersPanel()
 	;if (layPanel.bRight) layPanel := getLayerPanelScroller(layPanel)
 	layPanel := getSelectedLayerP(layPanel)
 	layPanel := getLayerIcons(layPanel)
 	CoordMode, Mouse, Screen
 	if(layPanel.hasMask = 1) layPanel := isMaskActive( layPanel ) 
 	if(layPanel.acvLayMaskOn = 1){
 		cx := layPanel.acvLayColorCenterX
 		cy := layPanel.activeLayDown - 27
 	}else{
 		cx := layPanel.acvLayMaskCenterX
 		cy := layPanel.activeLayDown - 27
 	}
 	MouseGetPos, xpos, ypos 
 	mSpeed := 0.000001
 	BlockInput, On
 	myClick( cx , cy, "left")
	MouseMove, xpos, ypos, mSpeed  
	BlockInput, off
 	Return
 }

 getLayerIcons(lp){
 	CoordMode, Pixel
 	ImageSearch, acStackX, acStackY, lp.bLeft, lp.activeLayDown - 11, lp.bRight, lp.activeLayDown - 4, %A_ScriptDir%\images\grayStacks.png
	if (ErrorLevel = 1)
	{
		;CornerNotify(1, "!!! can't see the stack icon !!!", "", "r hc", 1)	
	}else{
		s1X := acStackX
	}
	CoordMode, Pixel
 	ImageSearch, caaaX, acStack1Y, lp.bLeft, lp.activeLayDown - 11, lp.bRight, lp.activeLayDown - 4, %A_ScriptDir%\images\oranageStacks.png
  	if (ErrorLevel = 1)
	{
		;CornerNotify(1, "!!! you need to see the entyre eye on your screen !!!", "", "r hc", 1)	
	}else{
		s2X := caaaX
	}

	if( s1X AND s2X){
		if(s1X < s2X){
			lp.acvLayColorCenterX := s1X
		}else{
			lp.acvLayColorCenterX := s2X
		}
	}else if( s1X ){
		lp.acvLayColorCenterX := s1X
	}else if ( s2X ){
		lp.acvLayColorCenterX := s2X
	}

	lp.acvLayColorCenterX := lp.acvLayColorCenterX + 11
	lp.acvLayMaskCenterX := lp.acvLayColorCenterX + 30


	if(lp.activeStackUp){
		bckk := A_ScriptDir . "\images\unselectedLayerBack.png"
	}else{
		bckk := A_ScriptDir . "\images\selectedLayerBack.png"
	}

	ImageSearch, hasMaskX, hasMaskY, lp.acvLayMaskCenterX - 3, lp.activeLayUp + 8, lp.acvLayMaskCenterX, lp.activeLayUp + 14, %bckk%
	if (ErrorLevel = 1)
	{
		lp.hasMask := 1
	}else{
		lp.hasMask := 0
	}
 	return lp
 }
 

 getSelectedLayerEye(lp){
 	ImageSearch, activeLayerEyeX, activeLayerEyeY, lp.lLeft, lp.activeLayUp + 11, lp.bRight, lp.activeLayUp + 27, %A_ScriptDir%\images\layerVisPointStart.png
 	if (ErrorLevel = 1)
	{
		CornerNotify(1, "!!! you need to see the entyre eye on your screen !!!", "", "r hc", 1)
	}else{
		lp.activeLayerEyeLeft := activeLayerEyeX
		lp.activeLayerEyeTop := activeLayerEyeY
		lp.acvLayMaskCenterX := lp.activeLayerEyeLeft + 64
		lp.acvLayMaskDown := lp.activeLayDown - 12
		lp.acvLayColorCenterX := lp.activeLayerEyeLeft + 32
		lp.acvLayColorDown := lp.activeLayDown - 12
	}
	return lp
 }
 ;isMaskActive( lp ){
 ;	if(lp.activestackUp){
 ;		ImageSearch, maskOnX, maskOnY, lp.activeLayerEyeLeft + 48 , lp.activeLayUp + 13, lp.activeLayerEyeLeft + 51, lp.activeLayUp + 15, %A_ScriptDir%\images\activeLayerGray.png
 ;		if (ErrorLevel = 1)
	;	{
	;		lp.acvLayMaskOn := 0
	;	}else{
	;		lp.acvLayMaskOn := 1
	;	}
 		
 ;	}else{
 ;		ImageSearch, maskOnX, maskOnY, lp.activeLayerEyeLeft + 48 , lp.activeLayUp + 13, lp.activeLayerEyeLeft + 51, lp.activeLayUp + 15, %A_ScriptDir%\images\activeLayerBlue.png
	; 	if (ErrorLevel = 1)
	;	{
	;		lp.acvLayMaskOn := 0
	;	}else{
	;		lp.acvLayMaskOn := 1
	;	}
 ;	}
 ;	return lp
 ;}
 isMaskActive( lp ){
	if(lp.activeStackUp){
		bckk := A_ScriptDir . "\images\activeIconsBorder.png"
	}else{
		bckk := A_ScriptDir . "\images\activeIconsBorderBlue.png"
	}


 	ImageSearch, actvIconX, actvIconY, lp.acvLayMaskCenterX - 14, lp.activeLayUp + 8 , lp.acvLayMaskCenterX - 11, lp.activeLayUp + 11, %bckk%
 	if (ErrorLevel = 1)
	{
		lp.acvLayMaskOn := 0
	}else{
		lp.acvLayMaskOn := 1
	}

 	return lp
 }
 getSelectedLayerP0(lp){
 	ImageSearch, activeLayerUpX, activeLayerUpY, lp.bRight - 25, lp.bTop + 72, lp.bRight - 11, lp.bBottom, %A_ScriptDir%\images\activeLayerUp.png
 	if (ErrorLevel = 1)
	{
		;search for a stack filter active
		ImageSearch, activeStackUpX, activeStackUpY, lp.bRight - 25, lp.bTop-48, lp.bRight - 11, lp.bBottom, %A_ScriptDir%\images\activeStackUp.png
		if (ErrorLevel = 1)
		{
			;search for a anchor filter active
			ImageSearch, activeAnchorUpX, activeAnchorUpY, lp.bRight - 25, lp.bTop-48, lp.bRight - 11, lp.bBottom, %A_ScriptDir%\images\activeAnchorUp.png
			if (ErrorLevel = 1)
			{
				CornerNotify(1, "!!! Can't see any layer or active stack !!!", "", "r hc", 1)
			}else{
				lp.activeStackIsAnchor := 1
				lp.activestackUp := activeAnchorUpY
				lp.activestackDown := activeAnchorUpY + 22
				lp := getStacksBeforeActive(lp)
			}

		}else{
			lp.activeStackIsAnchor := 0
			lp.activestackUp := activeStackUpY
			lp.activestackDown := activeStackUpY + 22
			lp := getStacksBeforeActive(lp)
		}
	}else{
		lp.activeLayUp := activeLayerUpY
		lp.activeLayDown := activeLayerUpY + 42
	}
 	return lp
 }

getSelectedLayerP(lp){
 	ImageSearch, activeLayerUpX, activeLayerUpY, lp.bRight - 25, lp.bTop + 72, lp.bRight - 11, lp.bBottom, %A_ScriptDir%\images\activeLayerUp.png
 	if (ErrorLevel = 1)
	{
		CornerNotify(1, "!!! Can't see any layer or active stack !!!", "", "r hc", 1)
		;;search for a stack filter active
		;ImageSearch, activeStackUpX, activeStackUpY, lp.bRight - 25, lp.bTop-48, lp.bRight - 11, lp.bBottom, %A_ScriptDir%\images\activeStackUp.png
		;if (ErrorLevel = 1)
		;{
		;	;search for a anchor filter active
		;	ImageSearch, activeAnchorUpX, activeAnchorUpY, lp.bRight - 25, lp.bTop-48, lp.bRight - 11, lp.bBottom, %A_ScriptDir%\images\activeAnchorUp.png
		;	if (ErrorLevel = 1)
		;	{
		;		CornerNotify(1, "!!! Can't see any layer or active stack !!!", "", "r hc", 1)
		;	}else{
		;		lp.activeStackIsAnchor := 1
		;		lp.activestackUp := activeAnchorUpY
		;		lp.activestackDown := activeAnchorUpY + 22
		;		lp := getStacksBeforeActive(lp)
		;	}

		;}else{
		;	lp.activeStackIsAnchor := 0
		;	lp.activestackUp := activeStackUpY
		;	lp.activestackDown := activeStackUpY + 22
		;	lp := getStacksBeforeActive(lp)
		;}
	}else{
		lp.activeLayUp := activeLayerUpY
		;lp.activeLayDown := activeLayerUpY + 42

		ImageSearch, activeLayerDownX, activeLayerDownY, lp.bRight - 25, lp.activeLayUp + 18, lp.bRight - 11, lp.activeLayUp + 47, %A_ScriptDir%\images\activeLayerDown.png
		if (ErrorLevel = 1)
		{
			CornerNotify(1, "!!! Can't see any layer or active stack !!!", "", "r hc", 1)
		}else{
			lp.activeLayDown := activeLayerDownY + 3
			if( lp.activeLayDown - lp.activeLayUp < 40){
				lp.activeStackIsAnchor := 0
				lp.activestackUp := lp.activeLayUp 
				lp.activestackDown := lp.activeLayDown
				lp := getStacksBeforeActive(lp)
			}
		}
	}
 	return lp
 }

 getStacksBeforeActive(lp){
 	if(lp.activestackUp){

		lp.stacksBeforeActive := 0
		teststop := 0
		While 1
		{	
			ImageSearch, cStackUpX, cStackUpY, lp.bRight - 25, (lp.activestackUp) - (lp.stacksBeforeActive * 22 ), lp.bRight - 22, ((lp.activestackUp + 1) - (lp.stacksBeforeActive * 22 )), %A_ScriptDir%\images\betwenLayers.png
			if (ErrorLevel = 1)
			{
				lp.stacksBeforeActive := lp.stacksBeforeActive - 1
				lp.activeLayDown := ((lp.activestackUp) - (lp.stacksBeforeActive * 22 ))
				lp.activeLayUp := lp.activeLayDown - 44
				Break
			}else{
				lp.stacksBeforeActive := lp.stacksBeforeActive + 1
			}
			;stop it after 30 loops
			if( teststop > 30 ){
				Break
			}
			teststop := teststop + 1
		}

	}
	return lp
 }


 getStacksAfterActive(lp){
 	if(lp.activestackUp){

		lp.stacksAfterActive := 0
		teststop := 0
		While 1
		{	
			ImageSearch, cStackUpX, cStackUpY, lp.bRight - 25, (lp.activestackDown - 1) + (lp.stacksAfterActive * 22 ), lp.bRight - 22, ((lp.activestackDown) + (lp.stacksAfterActive * 22 )), %A_ScriptDir%\images\betwenLayers.png
			if (ErrorLevel = 1)
			{
				lp.stacksAfterActive := lp.stacksAfterActive - 1
				Break
			}else{
				lp.stacksAfterActive := lp.stacksAfterActive + 1
			}
			;stop it after 30 loops
			if( teststop > 30 ){
				Break
			}
			teststop := teststop + 1
		}

	}
	return lp
 }
 getStacksBeforeActive0(lp){
 	if(lp.activestackUp){

		lp.stacksBeforeActive := 0
		teststop := 0
		;splashInfo( "while start:" )
		While 1
		{	
			ImageSearch, cStackUpX, cStackUpY, lp.bRight - 25, (lp.activestackUp - 1) - (lp.stacksBeforeActive * 22 ), lp.bRight - 11, ((lp.activestackUp + 1) - (lp.stacksBeforeActive * 22 )), %A_ScriptDir%\images\stackRedColor.png
			if (ErrorLevel = 1)
			{
				ImageSearch, cStackUpX, cStackUpY, lp.bRight - 25, (lp.activestackUp - 1) - (lp.stacksBeforeActive * 22 ), lp.bRight - 11, ((lp.activestackUp + 1) - (lp.stacksBeforeActive * 22 )), %A_ScriptDir%\images\anchorBlueColor.png
				if (ErrorLevel = 1){
					lp.activeLayDown := lp.activestackUp + 1
					lp.activeLayUp := lp.activeLayDown - 42
					break
				}else{
					lp.stacksBeforeActive := lp.stacksBeforeActive + 1
				}
			}else{
				;splashInfo( teststop )
				lp.stacksBeforeActive := lp.stacksBeforeActive + 1
			}
			if( teststop > 30 ){
				Break
			}
			teststop := teststop + 1
		}
		;splashInfo( "while end: " . lp.stacksBeforeActive )
		if(lp.stacksBeforeActive > 0){
			lp.activeLayDown := (lp.activestackUp ) - (lp.stacksBeforeActive-1) - ((lp.stacksBeforeActive) * 20)
			lp.activeLayUp := lp.activeLayDown - 42
		}
	}
	return lp
 }
 getStacksAfterActive0(lp){
 	if(lp.activestackUp){
 		lp.stacksAfterActive := 0
		teststop := 0
		While 1
		{
			ImageSearch, cStackUpX, cStackUpY, lp.bRight - 25, (lp.activestackDown + 1) + (lp.stacksAfterActive * 22 ), lp.bRight - 11, ((lp.activestackDown + 2) + (lp.stacksAfterActive * 22 )), %A_ScriptDir%\images\stackRedColor.png
			if (ErrorLevel = 1)
			{
				ImageSearch, cStackUpX, cStackUpY, lp.bRight - 25, (lp.activestackDown + 1) + (lp.stacksAfterActive * 22 ), lp.bRight - 11, ((lp.activestackDown + 2) + (lp.stacksAfterActive * 22 )), %A_ScriptDir%\images\anchorBlueColor.png
				if (ErrorLevel = 1){
					break
				}else{
					lp.stacksAfterActive := lp.stacksAfterActive + 1
				}
			}else{
				lp.stacksAfterActive := lp.stacksAfterActive + 1
			}
			if( teststop > 30 ){
				Break
			}
			teststop := teststop + 1
		}
	}

 	return lp
 }
;==================== end masks
;================================================================
;================================================================
createLayer( myObj ){
	CoordMode, Mouse, Screen
	lay := getLayersPanel()
	;bcm_msgBObj(lay)
	if(lay.addLayButtonX){
		MouseGetPos, xpos, ypos 
		mSpeed = 0.000001
		lx := lay.addLayButtonX
		ly := lay.addLayButtonY
		msk := getMaskButton(lay)
		BlockInput, on
		myClick( lx , ly, "left")
		Sleep, 300
		if( myObj.var ){
			if(myObj.var = "noMask"){
				;my1 := msk.addMaskWithCS
				;myClick( mx , my1, "left")
			}else{
				mx := msk.x
				my := msk.y 
				myClick( mx , my, "left")
				Sleep, 100
				if( myObj.var = "addBlackMask"){
					my1 := msk.addBlackMask
					myClick( mx , my1, "left")
				}else if(myObj.var = "addWhiteMask"){
					my1 := msk.addWhiteMask
					myClick( mx , my1, "left")
				}else if(myObj.var = "addBitmapMask"){
					my1 := msk.addBitmapMask
					myClick( mx , my1, "left")
				}else if(myObj.var = "addMaskWithCS"){
					my1 := msk.addMaskWithCS
					myClick( mx , my1, "left")
				}
			}
		}
		MouseMove, xpos, ypos, mSpeed  
		BlockInput, Off
	}
	return
}

createFill( myObj ){
	CoordMode, Mouse, Screen
	lay := getLayersPanel()
	if(lay.addFillButtonX){
		MouseGetPos, xpos, ypos 
		mSpeed = 0.000001
		lx := lay.addFillButtonX
		ly := lay.addFillButtonY
		msk := getMaskButton(lay)
		BlockInput, on
		myClick( lx , ly, "left")
		Sleep, 300
		if( myObj.var ){
			if(myObj.var = "noMask"){
				;my1 := msk.addMaskWithCS
				;myClick( mx , my1, "left")
			}else{
				mx := msk.x
				my := msk.y 
				myClick( mx , my, "left")
				Sleep, 100
				if( myObj.var = "addBlackMask"){
					my1 := msk.addBlackMask
					myClick( mx , my1, "left")
				}else if(myObj.var = "addWhiteMask"){
					my1 := msk.addWhiteMask
					myClick( mx , my1, "left")
				}else if(myObj.var = "addBitmapMask"){
					my1 := msk.addBitmapMask
					myClick( mx , my1, "left")
				}else if(myObj.var = "addMaskWithCS"){
					my1 := msk.addMaskWithCS
					myClick( mx , my1, "left")
				}
			}
		}
		MouseMove, xpos, ypos, mSpeed  
		BlockInput, Off
	}
	return
}

createEffects( myObj ){
	CoordMode, Mouse, Screen
	CoordMode, Pixel
	MouseGetPos, xpos, ypos 
	mSpeed = 0.000001
	lay := getLayersPanel()
	if (lay.bTop){
		;it means that it was not an error when searching for the layers panel


		lay := getEffectsButton(lay)
		;bcm_msgBObj(lay)
		mx := lay.addFxButtonX
		my := lay.addFxButtonY
		CoordMode, Mouse, Screen
		if( myObj.var = "FxAddGenerator"){
			my1 := lay.FxAddGenerator
			BlockInput, on
			myClick( mx , my, "left")
			Sleep, 100
			myClick( mx , my1, "left")`
		}else if(myObj.var = "FxAddPaint"){
			my1 := lay.FxAddPaint
			BlockInput, on
			myClick( mx , my, "left")
			Sleep, 100`
			myClick( mx , my1, "left")
		}else if(myObj.var = "FxAddFill"){
			my1 := lay.FxAddFill
			BlockInput, on
			myClick( mx , my, "left")
			Sleep, 100
			myClick( mx , my1, "left")
		}else if(myObj.var = "FxAddLevels"){
			my1 := lay.FxAddLevels
			BlockInput, on
			myClick( mx , my, "left")
			Sleep, 100
			myClick( mx , my1, "left")
		}else if(myObj.var = "FxAddFilter"){
			my1 := lay.FxAddFilter
			BlockInput, on
			myClick( mx , my, "left")
			Sleep, 100
			myClick( mx , my1, "left")
		}else if(myObj.var = "FxAddColorSelection"){
			my1 := lay.FxAddColorSelection
			BlockInput, on
			myClick( mx , my, "left")
			Sleep, 100
			myClick( mx , my1, "left")
		}else if(myObj.var = "FxAddAnchorPoint"){
			my1 := lay.FxAddAnchorPoint
			BlockInput, on
			myClick( mx , my, "left")
			Sleep, 100
			myClick( mx , my1, "left")
		}else if(myObj.var = "FxRemove"){
			my1 := lay.FxRemove
			lay := getSelectedLayerP(lay)
			if(lay.activestackUp OR lay.activeAnchorUp){
				lay := getStacksAfterActive(lay)
				BlockInput, on
				myClick( mx , my, "left")
				Sleep, 100
				myClick( mx , my1, "left")
				doClickSel := 0
				if(lay.stacksAfterActive > 0){
					my2 := lay.activeStackUp + 10
					doClickSel := 1
				}else if( lay.stacksBeforeActive > 0){
					my2 := lay.activeStackUp - 10
					doClickSel := 1
				}
				if(doClickSel = 1){
					Sleep, 400
					myClick( mx , my2, "left")
				}
				
			}
		}
		MouseMove, xpos, ypos, mSpeed  
		BlockInput, Off
	}
	Return lay

}


getEffectsButton( layersP ){
	layersP.FxAddGenerator := layersP.addFxButtonY + 28
	layersP.FxAddPaint := layersP.addFxButtonY + 53
	layersP.FxAddFill := layersP.addFxButtonY + 77
	layersP.FxAddLevels := layersP.addFxButtonY + 102
	layersP.FxAddFilter := layersP.addFxButtonY + 126
	layersP.FxAddColorSelection := layersP.addFxButtonY + 150
	layersP.FxAddAnchorPoint := layersP.addFxButtonY + 173
	;layersP.FxRemove := layersP.addFxButtonY + 262
	return layersP
}





setBlendMode( myObj ){

	 lay := getLayersPanel()
	 if(lay.bRight){
	 	lay := getSelectedLayerP( lay )
	 }
	 ;msgBobj(lay)
	 if( lay.activeLayUp ){
	 	if(lay.activeStackUp){
	 		mx := lay.bRight - 76
	 		my := lay.activeStackUp + 12
	 	}else{
	 		mx := lay.bRight - 25
	 		my := lay.activeLayUp + 15 
	 	}
	 		CoordMode, Mouse, Screen
	 		MouseGetPos, xpos, ypos 
			mSpeed = 0.000001
			BlockInput, on
			;MsgBox,,, %mx% || %my%
			myClick( mx , my, "left")
			Sleep, 100	

			
			lay := getBlendingsWindow( lay )
			if (lay.blendingsWinBottom){
	 			mx1 := lay.blendingsWinLeft + 72
	 			;splashInfo(myObj.blendMode)
	 			if(myObj.blendMode = "Normal"){
	 				my1 := lay.blendingsWinTop + 11	 			
	 			}else if( myObj.blendMode = "Passthrough" ){
	 				my1 := lay.blendingsWinTop + 28
	 			}else if( myObj.blendMode = "Disable" ){
	 				my1 := lay.blendingsWinTop + 44
	 			}else if( myObj.blendMode = "Replace" ){
	 				my1 := lay.blendingsWinTop + 62
	 			}else if( myObj.blendMode = "Multiply" ){
	 				my1 := lay.blendingsWinTop + 87
	 			}else if( myObj.blendMode = "Divide" ){
	 				my1 := lay.blendingsWinTop + 105
	 			}else if( myObj.blendMode = "Inverse divide" ){
	 				my1 := lay.blendingsWinTop + 127
	 			}else if( myObj.blendMode = "Min" ){
	 				my1 := lay.blendingsWinTop + 138
	 			}else if( myObj.blendMode = "Max" ){
	 				my1 := lay.blendingsWinTop + 156
	 			}else if( myObj.blendMode = "Add" ){
	 				my1 := lay.blendingsWinTop + 181
	 			}else if( myObj.blendMode = "Substact" ){
	 				my1 := lay.blendingsWinTop + 198
	 			}else if( myObj.blendMode = "Inverse substact" ){
	 				my1 := lay.blendingsWinTop + 216
	 			}else if( myObj.blendMode = "Diference" ){
	 				my1 := lay.blendingsWinTop + 232
	 			}else if( myObj.blendMode = "Exclusion" ){
	 				my1 := lay.blendingsWinTop + 250
	 			}else if( myObj.blendMode = "AddSub" ){
	 				my1 := lay.blendingsWinTop + 267
	 			}else if( myObj.blendMode = "Overlay" ){
	 				my1 := lay.blendingsWinTop + 294
	 			}else if( myObj.blendMode = "Screen" ){
	 				my1 := lay.blendingsWinTop + 309
	 			}else if( myObj.blendMode = "Linear burn" ){
	 				my1 := lay.blendingsWinTop + 327
	 			}else if( myObj.blendMode = "Color burn" ){
	 				my1 := lay.blendingsWinTop + 344
	 			}else if( myObj.blendMode = "Color dodge" ){
	 				my1 := lay.blendingsWinTop + 361
	 			}else if( myObj.blendMode = "Soft light" ){
	 				my1 := lay.blendingsWinTop + 385
	 			}else if( myObj.blendMode = "Hard light" ){
	 				my1 := lay.blendingsWinTop + 403
	 			}else if( myObj.blendMode = "Vivid light" ){
	 				my1 := lay.blendingsWinTop + 420
	 			}else if( myObj.blendMode = "Linear light" ){
	 				my1 := lay.blendingsWinTop + 437
	 			}else if( myObj.blendMode = "Pin light" ){
	 				my1 := lay.blendingsWinTop + 454
	 			}else if( myObj.blendMode = "Tint" ){
	 				my1 := lay.blendingsWinTop + 479
	 			}else if( myObj.blendMode = "Saturation" ){
	 				my1 := lay.blendingsWinTop + 498
	 			}else if( myObj.blendMode = "Color" ){
	 				my1 := lay.blendingsWinTop + 514
	 			}else if( myObj.blendMode = "Value" ){
	 				my1 := lay.blendingsWinTop + 530
	 			}else if( myObj.blendMode = "Normal map combine" ){
	 				my1 := lay.blendingsWinTop + 559
	 			}else if( myObj.blendMode = "Normal map detail" ){
	 				my1 := lay.blendingsWinTop + 575
	 			}else if( myObj.blendMode = "Normal map inverse detail" ){
	 				my1 := lay.blendingsWinTop + 591
	 			}
	 			lay.my1 := my1
	 			lay.mx1 := mx1
	 			myClick( mx1 , my1, "left")
	 		}
	 		CoordMode, Mouse, Screen
	 		MouseMove, xpos, ypos, mSpeed  
			BlockInput, Off
			;msgBobj( lay )
	 }
	 Return
}

getBlendingsWindow( lp ){
	WinGet, WinID, ID, ahk_exe Substance Painter.exe,,,
	WinGetPos, aX, aY, aW, aH, ahk_id %WinID%
	WinGetClass, aClass, ahk_id %WinID%
	qr := GetMonitorUnderMouse2()
	oos := {}
	oos.x := aX
	oos.y := aY
	oos.w := aW
	oos.h := aH
	;msgBObj()lp
	;splashInfo(" ax: " . aX . " y: " . aY . " w: " . aW . " h: " . aH . " class: " . aClass)
	
	if (aClass = "Qt5QWindowPopupDropShadowSaveBits"){
		if( aX = 0 AND aY = 0){
			lp.blendingsWinTop := 0
			lp.blendingsWinLeft := 0
			lp.blendingsWinRight := lp.blendingsWinLeft + aW
			lp.blendingsWinBottom := lp.blendingsWinTop + aH
			if(qr.swaped = 1){
				;splashInfo( "swaped sssss")
				lp.blendingsWinLeft := A_ScreenWidth 
				lp.blendingsWinRight := lp.blendingsWinLeft - aW
			}
			;the error happend
		}else{
			if( lp.activeStackDown){
				;this means that it was a stack triggered for change blending
				lp.blendingsWinTop := lp.activeStackDown - 1
				lp.blendingsWinLeft := lp.bRight - 84
				lp.blendingsWinRight := lp.blendingsWinLeft + aW
				lp.blendingsWinBottom := lp.blendingsWinTop + aH
				if( lp.blendingsWinBottom > A_ScreenHeight){
					lp.blendingsWinBottom := lp.activeStackUp - 1
					lp.blendingsWinTop := lp.blendingsWinBottom - aH
				}
				if( lp.blendingsWinRight > A_ScreenWidth){
					lp.blendingsWinRight := A_ScreenWidth
					lp.blendingsWinLeft := lp.blendingsWinRight - aW
				}
			}else if( lp.activeLayDown ){
				lp.blendingsWinTop := lp.activeLayUp + 23
				lp.blendingsWinLeft := lp.bRight - 54
				lp.blendingsWinRight := lp.blendingsWinLeft + aW
				lp.blendingsWinBottom := lp.blendingsWinTop + aH
				if( lp.blendingsWinBottom > A_ScreenHeight){
					lp.blendingsWinBottom := lp.activeLayUp - 1
					lp.blendingsWinTop := lp.blendingsWinBottom - aH
					if(lp.blendingsWinTop < 0){
						lp.blendingsWinTop := 0
						lp.blendingsWinBottom := lp.blendingsWinTop + aH
					}
				}
				if( lp.blendingsWinRight > A_ScreenWidth){
					lp.blendingsWinRight := A_ScreenWidth
					lp.blendingsWinLeft := lp.blendingsWinRight - aW
				}
			}
		}	
	}
	Return lp
}

getLayContextWindow( lp ){
	WinGet, WinID, ID, ahk_exe Substance Painter.exe,,,
	WinGetPos, aX, aY, aW, aH, ahk_id %WinID%
	WinGetClass, aClass, ahk_id %WinID%
	qr := GetMonitorUnderMouse2()
	;splashInfo(" x: " . aX . " y: " . aY . " w: " . aW . " h: " . aH . " class: " . aClass)
	if (aClass = "Qt5QWindowPopupDropShadowSaveBits"){
		if( aX = 0 AND aY = 0){
			lp.actvLayContextWinTop := 0
			lp.actvLayContextWinLeft := 0
			lp.actvLayContextWinRight := lp.actvLayContextWinLeft + 271
			lp.actvLayContextWinBottom := lp.actvLayContextWinTop + 716
			if(qr.swaped = 1){
				;splashInfo( "swaped sssss")
				lp.actvLayContextWinLeft := A_ScreenWidth 
				lp.actvLayContextWinRight := lp.actvLayContextWinLeft - 271
			}
			;the error happend
		}else{
			if( lp.activeLayDown ){
				lp.actvLayContextWinTop := lp.activeLayUp + 20
				lp.actvLayContextWinLeft := lp.bLeft + 10
				lp.actvLayContextWinRight := lp.actvLayContextWinLeft + 271
				lp.actvLayContextWinBottom := lp.actvLayContextWinTop + 716
				if( lp.actvLayContextWinBottom > A_ScreenHeight){
					lp.actvLayContextWinBottom := lp.activeStackUp - 1
					lp.actvLayContextWinTop := lp.actvLayContextWinBottom - 716
					if(lp.actvLayContextWinTop < 0){
						lp.actvLayContextWinTop := 0
						lp.actvLayContextWinBottom := lp.actvLayContextWinTop + 716
					}
				}
				if( lp.actvLayContextWinRight > A_ScreenWidth){
					lp.actvLayContextWinRight := A_ScreenWidth
					lp.actvLayContextWinLeft := lp.actvLayContextWinRight - 271
				}
			}
		}	
	}

	lp.actvLayCtxAddWhiteMask := lp.actvLayContextWinTop + 12
	lp.actvLayCtxAddBlackMask := lp.actvLayContextWinTop + 35
	lp.actvLayCtxAddBitmapMask := lp.actvLayContextWinTop + 54
	lp.actvLayCtxAddCSMask := lp.actvLayContextWinTop + 75
	lp.actvLayCtxToggleMask := lp.actvLayContextWinTop + 105
	lp.actvLayCtxInvMaskBck := lp.actvLayContextWinTop + 127
	lp.actvLayCtxInvMask := lp.actvLayContextWinTop + 157
	lp.actvLayCtxClearMask := lp.actvLayContextWinTop + 176
	lp.actvLayCtxRemoveMask := lp.actvLayContextWinTop + 198
	lp.actvLayCtxExpMask := lp.actvLayContextWinTop + 228
	lp.actvLayCtxExpMaskClip := lp.actvLayContextWinTop + 249
	lp.actvLayCtxSmartMask := lp.actvLayContextWinTop + 270
	lp.actvLayCtxCutLayer := lp.actvLayContextWinTop + 300
	lp.actvLayCtxCopyLayer := lp.actvLayContextWinTop + 322
	lp.actvLayCtxPasteLayer := lp.actvLayContextWinTop + 343
	lp.actvLayCtxPasteAsInstance := lp.actvLayContextWinTop + 363
	lp.actvLayCtxDupLayer := lp.actvLayContextWinTop + 383
	lp.actvLayCtxInstAccrosTxtSets := lp.actvLayContextWinTop + 407
	lp.actvLayCtxRmvLayer := lp.actvLayContextWinTop + 427
	lp.actvLayCtxGrpLayer := lp.actvLayContextWinTop + 448



	Return lp
}





BrushTabInfo( startX, startY){
	tr := {} 
	ImageSearch, BrushTabX, BrushTabY, startX, startY, %A_ScreenWidth%, %A_ScreenHeight%, %A_ScriptDir%\images\BrushTab_End.png
	if (ErrorLevel = 1)
	{
		;MsgBox, %startX% . %startY%
	    theScroll := getScrollPosition(startX, startY, A_ScreenWidth, A_ScreenHeight)

	;s1 := theScroll.scrollerTop
	;s2 := theScroll.scrollerBottom
	;s3 := theScroll.scrollerCenterY
	;s4 := tq.scrollerLeft
	;MsgBox, scrollerTop: %s1% . scrollerBottom:%s2% . scrollerCenterY:%s3% . scrollerLeft:%s4%




	    moveScrollUp(theScroll)

	    tr.scrollerLeft :=  theScroll.scrollerLeft
		tr.scrollerTop := theScroll.scrollerTop
		tr.scrollerRight := theScroll.scrollerRight
		tr.scrollerBottom := theScroll.scrollerBottom
		tr.scrollerCenterY := theScroll.scrollerCenterY
		tr.scrollerCenterY := theScroll.scrollerCenterY
		tr.scrollUppX := theScroll.scrollUppX
		tr.scrollUppY := theScroll.scrollUppY
		tr.scrollerOffset := theScroll.scrollerOffset

	    tr.visible := 0
	    ImageSearch, BrushTabX, BrushTabY, startX, startY, %A_ScreenWidth%, %A_ScreenHeight%, %A_ScriptDir%\images\BrushTab_End.png

	}	
	else
	{
		tr.visible := 1
	}

	tr.posX := BrushTabX
	tr.posY := BrushTabY
	BrushTabX := BrushTabX -4
	BrushTabY := BrushTabY -4
	ImageSearch, BrushTabOpenX, BrushTabOpenY, BrushTabX, BrushTabY, %A_ScreenWidth%, %A_ScreenHeight%, %A_ScriptDir%\images\BrushTab_opened.png
	if (ErrorLevel = 1)
	{
		tr.isOpened := 0
	}
	else{
		tr.isOpened := 1
	}

	return tr
}

openCloseTab( theTab ){

	BlockInput, On
	cPx := theTab.posX
	cPy := theTab.posY
	myClick( cPx , cPy, "left")
	BlockInput, Off
}

getScrollPosition(startX, startY, endX, endY){
	tr := {}
	ImageSearch, scrollerBottomX, scrollerBottomY, startX, startY, endX, endY, %A_ScriptDir%\images\scrollBar_lowerPart_vertical1.png
	if (ErrorLevel = 1)
	{
		tr.visible := 0
		;CornerNotify(1, "!!! No scrollerBottom visible !!!", "", "r hc", 1)
	}else{
		tr.visible := 1
		ImageSearch, scrollerTopX, scrollerTopY, startX, startY, endX, endY, %A_ScriptDir%\images\scrollBar_upperPart_vertical1.png
		if (ErrorLevel = 1)
		{
			 ;CornerNotify(1, "!!! No scrollerTop visible !!!", "", "r hc", 1)
		}else{
			tr.scrollerLeft :=  scrollerBottomX
			tr.scrollerTop := scrollerTopY
			tr.scrollerRight := scrollerBottomX + 10
			tr.scrollerBottom := scrollerBottomY + 11
			tr.scrollerCenterY := tr.scrollerTop + ((tr.scrollerBottom - tr.scrollerTop ) * 0.5)
			tr.scrollerCenterY := Floor(tr.scrollerCenterY)
			tr.scrollerCenterX := tr.scrollerLeft + ((tr.scrollerRight - tr.scrollerLeft ) * 0.5)
			tr.scrollerCenterX := Floor(tr.scrollerCenterX)		
		}
	}
	ImageSearch, scrollUpX, scrollUpY, startX, startY, endX, endY, %A_ScriptDir%\images\scrollUpp_vertical.png
	if (ErrorLevel = 1)
	{
		;CornerNotify(1, "!!! No scrollUpArrow visible !!!", "", "r hc", 1)
	}else{
		tr.scrollUppX := scrollUpX
		tr.scrollUppY := scrollUpY
		tr.scrollerOffset := ((tr.scrollerTop) - (tr.scrollUppY + 9))
	}
	ImageSearch, scrollDownX, scrollDownY, startX, startY, endX, endY, %A_ScriptDir%\images\scrollDown_vertical.png
	if (ErrorLevel = 1)
	{
		;CornerNotify(1, "!!! No scrollDownArrow visible !!!", "", "r hc", 1)
	}else{
		tr.scrollDownX := scrollDownX
		tr.scrollDownY := scrollDownY
		tr.scrollerOffsetDown := ((tr.scrollerBottom) - (tr.scrollDownY))
	}
	return tr
}

getScroll(tr){
	;tr := {}
	CoordMode, Pixel
	ImageSearch, scrollerTopX, scrollerTopY, tr.bRight - 15, tr.bTop + 30, tr.bRight , tr.bBottom, %A_ScriptDir%\images\scollUp.png
 	if(ErrorLevel = 1){
 		tr.visible := 0
 	}else{
 		tr.visible := 1
 		tr.scrollerBottom := tr.bBottom
 		tr.scrollerLeft := tr.bRight - 12
 		tr.scrollerRight := tr.bRight
 		tr.scrollUppY := scrollerTopY
 		ImageSearch, scrollerBtmX, scrollerBtmY, tr.bRight - 15, scrollerTopY, tr.bRight - 1, tr.bBottom, %A_ScriptDir%\images\scrollBck.png
 		if(ErrorLevel = 1){
 			CornerNotify(1, "!!! can't see the buttom part of the scroller !!!", "", "r hc", 1)
 		}else{
 			tr.scrollDownY := scrollerBtmY
	 		ImageSearch, scrollerTopX, scrollerTopY, tr.bRight - 15, tr.bTop,  tr.bRight - 1, scrollerTopY, %A_ScriptDir%\images\scrollBck.png
	 		if(ErrorLevel = 1){
	 			CornerNotify(1, "!!! can't see the buttom part of the scroller !!!", "", "r hc", 1)
	 		}else{
	 			tr.scrollerTop := scrollerTopY + 1
				tr.scrollerCenterY := tr.scrollerTop + ((tr.scrollerBottom - tr.scrollerTop ) * 0.5)
				tr.scrollerCenterY := Floor(tr.scrollerCenterY)		 		
		 		tr.scrollCenterY := tr.scrollUppY + ((tr.scrollDownY - tr.scrollUppY ) * 0.5)
				tr.scrollCenterY := Floor(tr.scrollCenterY)
				tr.scrollerCenterX := tr.scrollerLeft + ((tr.scrollerRight - tr.scrollerLeft ) * 0.5)
				tr.scrollerCenterX := Floor(tr.scrollerCenterX)
				tr.scrollerOffset := ((tr.scrollUppY) - (tr.scrollerTop))
				tr.scrollerOffsetDown := ((tr.scrollerBottom) - (tr.scrollDownY))
	 		}
 		}


 	}
	return tr
}
moveScrollAt(  offset  ){
	if (scrollInfo.visible == 1){
		CoordMode, Mouse, Screen
		;move scroll bar upp
		scrollerY := scrollInfo.scrollerCenterY
		scrollerX := scrollInfo.scrollerLeft + 4
		ScrollBarYOff0 := ScrollBarY + 100
		ScrollBarYOff := scrollerY - 800
		scrollerMoveOff := 0 - scrollInfo.scrollerOffset
		;MsgBox, offset is : %scrollerMoveOff%
		;MsgBox, YCenter is : %scrollerY%



		BlockInput, On
		MouseMove, scrollerX, scrollerY, 0.0000001
		;Click, down
		;MouseMove, 0, +100, 1, R
		;Click, up

		Click, down
		MouseMove, 0, %scrollerMoveOff% , 1, R
		Click, up

		BlockInput, Off
		}else{
			CornerNotify(1, "!!! No scrollerBar visible !!!", "", "r hc", 1)
		}
}
moveScrollUp( scrollInfo  ){
	CoordMode, Mouse, Screen
	if (scrollInfo.visible == 1){

		;move scroll bar upp
		scrollerY := scrollInfo.scrollerCenterY
		scrollerX := scrollInfo.scrollerLeft + 4
		ScrollBarYOff0 := ScrollBarY + 100
		ScrollBarYOff := scrollerY - 800
		scrollerMoveOff := 0 - scrollInfo.scrollerOffset
		;MsgBox, offset is : %scrollerMoveOff%
		;MsgBox, YCenter is : %scrollerY%



		BlockInput, On
		MouseMove, scrollerX, scrollerY, 0.0000001
		;Click, down
		;MouseMove, 0, +100, 1, R
		;Click, up
		CoordMode, Mouse, Screen
		Click, down
		MouseMove, 0, %scrollerMoveOff% , 1, R
		Click, up

		BlockInput, Off
		}else{
			CornerNotify(1, "!!! No scrollerBar visible !!!", "", "r hc", 1)
		}
}
moveScrollBack( tabNFO ){

		;move scroll bar upp
		cPosX := tabNFO.scrollerLeft + 4
		cPosY := tabNFO.scrollerCenterY - tabNFO.scrollerOffset

		ePosY := tabNFO.scrollerOffset
		;MsgBox, theScrollerPosY is : %cPosY%


		BlockInput, On
		
		MouseMove, cPosX, cPosY, 0.0000001
		Click, down
		MouseMove, 0, %ePosY%, 5, R
		Click, up

		BlockInput, Off


}


getBrushUppOptions( whatOp ){
	global bcm_workArea
	bcm_workArea := getAllPixelsMonitors()
	CoordMode, Pixel`
	tr := {}
	linkITitle := A_ScriptDir . "\images\Brush" . whatOp . "Upp.png"

	ImageSearch, FoundX, FoundY, bcm_workArea.painterStartX, bcm_workArea.painterStartY , bcm_workArea.painterEndX, bcm_workArea.painterStartY + 95 , %linkITitle%
	if (ErrorLevel = 2)
	{
		CornerNotify(1, "!!! Could not conduct the search !!!", "", "r hc", 1)
	}
	else if (ErrorLevel = 1)
	{
	    CornerNotify(1, " !!! '" . whatOp . "' could not be found on the upper part. !!!", "", "r hc", 1)
	    ;MsgBox "Properies -" could not be found on the screen.
	}
	else
	{
		tr.X := FoundX
		tr.Y := FoundY
		ImageSearch, penPressureX, penPressureY, tr.X + 110, tr.Y, tr.X + 136, tr.Y+ 25, %A_ScriptDir%\images\penPressure.png
		if (ErrorLevel = 1){
			tr.penPressure := 0
		}else{
			tr.penPressure := 1

		}
		tr.DropDownX := tr.X + 122
		tr.DropDownY := tr.Y + 14
		tr.noPressureD := tr.DropDownY + 30
		tr.penPressureD := tr.DropDownY + 53
	}
	return tr
}

getDockedIcon( whStr ){
	global bcm_workArea
	bcm_workArea := getAllPixelsMonitors()
	;bcm_msgBObj(bcm_workArea)
	tr :={}
	strr := A_ScriptDir . "\images\" . whStr . "Docked.png"
	strrB := A_ScriptDir . "\images\" . whStr . "DockedSelected.png"
	startX := bcm_workArea.startX
	startY := bcm_workArea.startY
	endX := bcm_workArea.endX
	endY := bcm_workArea.endY
	CoordMode Pixel
	ImageSearch, dockedX, dockedY, bcm_workArea.startX , bcm_workArea.startY, bcm_workArea.endX, bcm_workArea.endY, %strrB%
	if(ErrorLevel = 1){
		ImageSearch, dockedX, dockedY, bcm_workArea.startX, bcm_workArea.startY, bcm_workArea.endX, bcm_workArea.endY, %strr%
		if(ErrorLevel = 1){
		}else{
			if(whStr = "Properties"){
				;on the properties panel it could actually find the tab from the brush so fisrt let's check if in 
				;the right if itr has the alpha shortcut
				ImageSearch, alphX, aplhY, dockedX + 31, dockedY - 1, dockedX + 51, dockedY + 18, %A_ScriptDir%\images\alphaPropertiesShortcut.png
				if(ErrorLevel = 1){
					;didn't found any alpha shortcut near for the properties panel
					tr.isDocked := 1
					tr.isOn := 0
					tr.dockedIconX := dockedX
					tr.dockedIconY := dockedY
				}
			}else{
				tr.isDocked := 1
				tr.isOn := 0
				tr.dockedIconX := dockedX
				tr.dockedIconY := dockedY
			}
		}
	}else{
		tr.isDocked := 1
		tr.isOn := 1
		tr.dockedIconX := dockedX
		tr.dockedIconY := dockedY
	}
	return tr
}


toggleDocked( whStr ){
	;will press the docked panel opening it or closing it
	st := getDockedIcon( whStr )
	if(st.isDocked){
		CoordMode, Mouse , Screen
		MouseGetPos, xpos, ypos 
		mSpeed := 0.000001
		BlockInput, On
		
		clX := st.dockedIconX
		clY := st.dockedIconY
		myClick( clX , clY, "left")	
		;Sleep 200
		;if(st.isOn = 1){
		;	WinGet, WinID, ID, ahk_exe Substance Painter.exe,,,
		;	WinGetPos, aX, aY, aW, aH, ahk_id %WinID%
		;	WinGetClass, aClass, ahk_id %WinID%
		;}

		MouseMove, xpos, ypos, mSpeed  
		BlockInput, Off
	}
}
getAllPixelsMonitors(){
	;this function is for getting the working area in case of multiple monitors
	; it's for replacing the A_ScreenWidth and A_ScreenHeight
	SysGet, MonC, MonitorCount
    SysGet, Mon1, Monitor, 1
    SysGet, Mon2, Monitor, 2
    SysGet, Mon3, Monitor, 3
    SysGet, Mon4, Monitor, 4
    SysGet, Mon5, Monitor, 5
    SysGet, Mon6, Monitor, 6
    SysGet, Mon7, Monitor, 7
    SysGet, Mon8, Monitor, 8
    SysGet, Mon9, Monitor, 9

    smallX := 0
    bigX := 0
    smallY := 0
    bigY := 0
    alLoop := MonC * 2

    theX := []
    theY := []
    j := 1
    loop %MonC%
	{
		theX[j] := Mon%A_Index%Left
		theX[j + 1] := Mon%A_Index%Right

		theY[j] := Mon%A_Index%Top
		theY[j + 1] := Mon%A_Index%Bottom
		j += 2
	}
	loop %alLoop%
	{
		if(smallX > theX[A_Index]){
			smallX := theX[A_Index]
		}
		if(smallY > theY[A_Index]){
			smallY := theY[A_Index]
		}

		if(bigX < theX[A_Index]){
			bigX := theX[A_Index]
		}
		if(bigY < theY[A_Index]){
			bigY := theY[A_Index]
		}
	}

	workAre :={}
	workAre.startX := smallX
	workAre.endX := bigX
	workAre.startY := smallY
	workAre.endY := bigY
	pnbt := findPainterWindow( )
	workAre.painterStartX := pnbt.bLeft
	workAre.painterStartY := pnbt.bTop
	workAre.painterEndX := pnbt.bRight
	workAre.painterEndY := pnbt.bBottom
	return workAre
}




findFloatPanel( typ ){

		WinGet, WinList, List, ahk_class Qt5QWindowToolSaveBits,,,
		;WinGet, WinList, List, ahk_exe Substance Painter.exe,,,]

		Loop %WinList%
		{
			WinID := WinList%A_Index%
			WinGet, WinProc, ProcessName, ahk_id %WinID%
			if(WinProc == "Substance Painter.exe"){
				WinGetTitle, WinTitle, ahk_id %WinID%
				;bcm_splashInfo(WinTitle)
				If InStr(WinTitle, typ)
				{
					WinGetPos, aX, aY, aW, aH, ahk_id %WinID%
				}
			}
		}

		winW := {}
		winW.bLeft := aX
		winW.bTop := aY
		winW.bRight := aX + aW
		winW.bBottom := aY + aH
		winW.isFloat := 1

		;bcm_msgBObj(winW)
		return winW

}	



findPainterWindow( ){

		WinGet, WinList, List, ahk_exe Substance Painter.exe,,,

		Loop %WinList%
		{
			WinID := WinList%A_Index%
			WinGetClass, WinClass, ahk_id %WinID%
			if(WinClass == "Qt5QWindowIcon"){
				WinGetTitle, WinTitle, ahk_id %WinID%
				;bcm_splashInfo(WinTitle)
				If InStr(WinTitle, "Substance Painter")
				{
					WinGetPos, aX, aY, aW, aH, ahk_id %WinID%
				}
			}
		}

		winW := {}
		winW.bLeft := aX
		winW.bTop := aY
		winW.bWidth := aW
		winW.bHeight := aH
		winW.bRight := aX + aW
		winW.bBottom := aY + aH
		winW.isFloat := 1

		;bcm_msgBObj(winW)
		return winW

}	

doChannels( mobj ){
	;second atempt by using right click like in the bacface culling
	CoordMode, Mouse, Screen
	CoordMode, Pixel
	MouseGetPos, xpos, ypos 
	mSpeed := 0.000001


	;maybe the right clikc window was already opened
	prop := getThePropWindow()
	propAlreadyOpened := 0
	if(prop.bLeft){
		;search for material shortcut
		prop := searchForMaterialShortcut( prop )
		propAlreadyOpened := 1
		;bcm_msgBObj(prop)
		if(prop.materialShortcutX){
			;calculate the right click just to get the brush shortcut
			prop.wasRightClickOpened := 1
			prop.rightClickX := prop.bLeft + 5
			prop.rightClickY := prop.materialShortcutY
		}
		BlockInput, On
	}else{

		list1 := findPainterWindow()
		winMenuX := list1.bLeft + 161
		winMenuY := list1.bTop + 29 
		BlockInput, On
		;click on the window menu
		myClick(winMenuX, winMenuY, "left")
		Sleep, 200
		;search for ckeck for HideUI to see if the UI's are already hidden
		isAlreadyHiddenUI := 0
		CoordMode, Pixel
		ImageSearch, ckX, ckY, list1.bLeft + 110, list1.bTop + 90, list1.bLeft + 146, list1.bTop + 112, %A_ScriptDir%\images\checkMenu.png
		if (ErrorLevel = 2){
			;bcm_splashInfo("errrrrrrr")
		}
		else if (ErrorLevel = 1){
			isAlreadyHiddenUI := 0
		}else{
			isAlreadyHiddenUI := 1
		}

		if( isAlreadyHiddenUI = 0){
			;hide all the UI
			myClick(list1.bLeft + 171, list1.bTop + 104, "left")
			;Sleep,100
		}


		;now to open the properties right click in the upper corner of painter
		; I think for the right click to work with the tablet, Painter should not have the focus
		WinClose, Program Manager
		WinActivate, Program Manager
		myClick(list1.bLeft + 53, list1.bTop + 89, "right")
		Sleep, 100
		;WinActivate, Substance Painter

		;find the propertiesWindow
		prop := getThePropWindow()
		CoordMode, Mouse, Screen
		prop.wasRightClickOpened := 1
		prop.rightClickX := list1.bLeft + 53
		prop.rightClickY := list1.bTop + 89
		

		;see if there is materialShortcut
		prop := searchForMaterialShortcutWhenRightClick( prop )

	}
	

	if(prop.materialShortcutX){
		;;se if the properties are for brush or not, this is faster then to press the material shortcut
		;prop := searchForBrushShortcutWhenRightClick( prop )

		;now claculate the scroll
		prop.scrollerLeft := prop.bRight - 16
		;prop.scrollerTop  := prop.bTop + 168
		;prop.scrollerRight := prop.bRight - 4
		;prop.scrollerBottom := prop.bBottom - 4
		;prop.scrollerCenterY := prop.scrollerTop + 18
		;prop.scrollerCenterX := prop.scrollerLeft + 6

		;ImageSearch, scrlBeginX, scrlBeginY, prop.scrollerLeft-1, prop.scrollerTop, prop.scrollerRight + 1, prop.scrollerBottom, %A_ScriptDir%\images\scollUp.png
		;if(ErrorLevel =  1){

		;}else{
		;	prop.scrollUppY := scrlBeginY
		;}

		;if(prop.brushShortcutX){
		;	;if it's a brush put it to 194
		;	CoordMode, Mouse, Screen
		;	ofsssetQ := 194 - (prop.scrollUppY - prop.scrollerTop)
		;	if(Abs(ofsssetQ) > 1){
		;		MouseMove, prop.scrollerCenterX, prop.scrollUppY + 3, 0.0000001
		;		Click, down
		;		Sleep, 50
		;		MouseMove,  0, ofsssetQ , 1, R
		;		Click, up
		;	}
		;}else{

		;click on the material icon
		myClick(prop.materialShortcutX, prop.materialShortcutY, "left")
		Sleep, 500


			;;if it's a fill put it to 0
			;CoordMode, Mouse, Screen
			;ofsssetQ := 0 - (prop.scrollUppY - prop.scrollerTop)
			;if(Abs(ofsssetQ) > 5){
			;	MouseMove, prop.scrollerCenterX, prop.scrollUppY + 3, 0.0000001
			;	Click, down
			;	Sleep, 50
			;	MouseMove,  0, ofsssetQ , 1, R
			;	Click, up
			;}	


	
		;get the channels
		prop := getPropsChannels( prop )
		;bcm_msgBObj(prop)
		
		;now click on each channel to disable it
		if(prop.avChannels){
			for k,v in prop.channels{
				if(mObj.var = "disableAll"){
					if( v.isOn =  1){
						myClick( v.X , v.Y, "left")
					}
				}else if(mObj.var = "toggleAll"){
					myClick( v.X , v.Y, "left")
				}else if(mObj.var = "enableAll"){
					if( v.isOn =  0){
						myClick( v.X , v.Y, "left")
					}
				}
			}
		}

		;close the righjt cliked properties
		if(propAlreadyOpened = 0){
			Send, {Esc}
		}

	}else{
		;close the rightclicked porperties
		if(propAlreadyOpened = 0){
			Send, {Esc}
		}
		CornerNotify(1, "You need to be on the Properties that has materials !!!", "", "r hc", 1)
	}

	if( isAlreadyHiddenUI = 0){
		;clic on the window menu
		myClick(winMenuX, winMenuY, "left")
		Sleep, 100
		;show all the UI
		myClick(list1.bLeft + 171, list1.bTop + 104, "left")
	}



	MouseMove, xpos, ypos ,0.0000001
	BlockInput, Off

	;WinClose, Program Manager
	;;give info after the script finished
	;if(prop.backfaceCullingX){
	;	if(prop.backfaceCullingEnabled = 1){
	;		if(prop.backfaceCullingOn = 1){
	;			CornerNotify(1, "Backface Culling OFF", "", "r hc", 0)
	;		}else{
	;			CornerNotify(1, "Backface Culling ON", "", "r hc", 0)
	;		}
	;	}else{
	;		CornerNotify(1, "Backface Culling can't be chnaged because it's disabled", "", "r hc", 0)
	;	}
	;}
}

searchForMaterialShortcutWhenRightClick( pnl){
	CoordMode, Pixel
	ImageSearch, matX, matY, pnl.rightClickX, pnl.rightClickY - 15, pnl.bRight, pnl.rightClickY + 40, %A_ScriptDir%\images\MaterialShortcut_off.png
	if(ErrorLevel = 2){
	}
	else if(ErrorLevel = 1){
		ImageSearch, matX1, matY1, pnl.rightClickX, pnl.rightClickY - 15, pnl.bRight, pnl.rightClickY + 40, %A_ScriptDir%\images\MaterialShortcut_on.png
		if(ErrorLevel = 1){
			
		}else{
			pnl.materialShortcutX := matX1
			pnl.materialShortcutY := matY1
			pnl.materialShortcutOn := 1
		}
	}else{
		pnl.materialShortcutX := matX
		pnl.materialShortcutY := matY
		pnl.materialShortcutOn := 0
	}
	return pnl
}

searchForMaterialShortcut( pnl){
	CoordMode, Pixel
	ImageSearch, matX, matY, pnl.bLeft, pnl.bTop, pnl.bRight, pnl.bBottom, %A_ScriptDir%\images\MaterialShortcut_off.png
	if(ErrorLevel = 2){
		;bcm_splashInfo("errrrror")
	}
	else if(ErrorLevel = 1){
		ImageSearch, matX1, matY1, pnl.bLeft, pnl.bTop, pnl.bRight, pnl.bBottom, %A_ScriptDir%\images\MaterialShortcut_on.png
		if(ErrorLevel = 1){
			
		}else{
			pnl.materialShortcutX := matX1
			pnl.materialShortcutY := matY1
			pnl.materialShortcutOn := 1
		}
	}else{
		pnl.materialShortcutX := matX
		pnl.materialShortcutY := matY
		pnl.materialShortcutOn := 0
	}
	return pnl
}

getPropsMatIconWhenRightClicked( pr ){
	;getting the small materials icon from the properties panel
	ImageSearch, aX, aY, rightClickX - 4, rightClickY - 4, rightClickX + 4, pr.bBottom, %A_ScriptDir%\images\propsMaterial.png
  	if (ErrorLevel = 1)
	{
		ImageSearch, aX, aY, pr.bLeft, pr.bTop + 14, pr.bRight, pr.bBottom, %A_ScriptDir%\images\propsMaterialSel.png
		if (ErrorLevel = 1)
		{
			;CornerNotify(1, "!!! can't see the material icon !!!", "", "r hc", 1)	

		}else{
			pr.matIconX := aX
			pr.matIconY := aY
		}
	}else{
		pr.matIconX := aX
		pr.matIconY := aY
	}

	Return pr
}



getPropsMatIcon( pr ){
	;getting the small materials icon from the properties panel
	ImageSearch, aX, aY, pr.bLeft, pr.bTop + 14, pr.bRight, pr.bBottom, %A_ScriptDir%\images\propsMaterial.png
  	if (ErrorLevel = 1)
	{
		ImageSearch, aX, aY, pr.bLeft, pr.bTop + 14, pr.bRight, pr.bBottom, %A_ScriptDir%\images\propsMaterialSel.png
		if (ErrorLevel = 1)
		{
			;CornerNotify(1, "!!! can't see the material icon !!!", "", "r hc", 1)	

		}else{
			pr.matIconX := aX
			pr.matIconY := aY
		}
	}else{
		pr.matIconX := aX
		pr.matIconY := aY
	}

	Return pr
}

getPropsChannels( pr ){
	;getting the small channels from the properties panel
	aw := 0
	theXStart := pr.bLeft
	theYStart := pr.materialShortcutY
	;bcm_msgBObj(pr)
	ac := 1 
		if(pr.scrollerLeft){
			qwe := pr.scrollerLeft
		}else{
			qwe := pr.bRight
		}
	while 1{

		;bcm_splashInfo( theXStart . " ||| " . theYStart )
		if (theXStart > qwe){
			theXStart := pr.bLeft
			theYStart := aY + 22
		}
		ImageSearch, aX, aY, theXStart, theYStart, pr.bRight, pr.bBottom, %A_ScriptDir%\images\propsChannelSelBtm.png
		if (ErrorLevel = 1){
			ImageSearch, aX, aY, theXStart, theYStart, pr.bRight, pr.bBottom, %A_ScriptDir%\images\propsChannelBtm.png
			if (ErrorLevel = 1){
				break
			}else{
				;splashInfo( theXStart . " ||| " . theYStart . " :: found0")
				chann := {}
				chann.isOn := 0
				chann.X := aX + 21
				chann.Y := aY - 2
				pr.channels[ac] := chann
				pr.avChannels := ac

				theXStart := aX + 50
				ac := ac + 1
			}
		}else{
				;splashInfo( theXStart . " ||| " . theYStart . " :: found1")
				chann := {}
				chann.isOn := 1
				chann.X := aX + 21
				chann.Y := aY - 2
				pr.channels[ac] := chann
				pr.avChannels := ac

				theXStart := aX + 50
				ac := ac + 1
		}

		;if(aw > 10){
		;	break
		;}
		aw := aw + 1
	}

	return pr	
}


;--------------------------------------------------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------------------------------------------------

;for the up down sliders::
sqFormat(){
	global precisionAdd
	if (precisionAdd){
		prAA := precisionAdd		
	}else{
		prAA := 0.1
	}
	SetFormat, float, 0.4
	return prAA
}
setOpp( what, doClick ){
	Send {Home}
	Send {Shift}+{End}
	clipboard =  ; Start off empty to allow ClipWait to detect when the text has arrived.
	Send ^c
	ClipWait  ; Wait for the clipboard to contain text.
	qs = A_FormatFloat
	if( what = "add"){
		;splashInfo( what )
		ss := Clipboard + sqFormat()
	}else{ 
		ss := Clipboard - sqFormat()
	}
	clipboard := ss
	Send, ^v
	Send, {Enter}
	if( doClick = 1){
		Click
	}

}
getTextSel(){
	global bcm_workArea
	CoordMode, Pixel
	tx := {}
	ImageSearch, txFoundX, txFoundY, bcm_workArea.startX, bcm_workArea.startY, bcm_workArea.endX, bcm_workArea.endY, %A_ScriptDir%\images\textSelected.png
	if(ErrorLevel = 1){
		;CornerNotify(1, "!!! The caret is not visible !!!", "", "r hc", 1)

	}else{
		;MsgBox, %txFoundX% . %txFoundY%
		tx.x := txFoundX
		tx.y := txFoundY - 4
	}
	return tx
}

getTheNumber( w ){
	CoordMode, Pixel
	ImageSearch, txnbX, txnbY, w.bLeft , w.bTop - 18 , w.bRight, w.bTop - 4, %A_ScriptDir%\images\blueForNumber.png
	if(ErrorLevel = 1){
		ImageSearch, txnbX, txnbY, w.bLeft , w.bTop - 18 , w.bRight, w.bTop - 4, %A_ScriptDir%\images\blueForNumber_2.png
		if(ErrorLevel = 1){
			}else{
				w.nbX := txnbX
				w.nbY := txnbY
			}
	}else{
		w.nbX := txnbX
		w.nbY := txnbY
	}
	return w
}

accOp(opps){
	CoordMode, Mouse, Screen
	sTx := getTextSel()
	sss := getWindowTest()
	;bcm_msgBObj(sTx)
	if(sss.aClass = "Qt5QWindowPopupDropShadowSaveBits"){
		sss := getTheNumber(sss)
		if(sss.nbX){
		;splashInfo( sss.nbX)
			;BlockInput, On
			sx2 := sss.bRight - 5
			sy2 := sss.bTop + 3
			myClick( sx2 , sy2, "left")
			setOpp(opps,0)
			sx1 := sss.nbX + 5 
			sy1 := sss.nbY - 5
			
			;splashInfo( sx1 . sy1)
			;Sleep, 100
			myClick( sx1 , sy1, "left")
			myClick( sx1 , sy1, "left")
			;Sleep, 1000
			myClick( sx2 , sy2, "left")
			;BlockInput, Off
		}
	}else{
		;BlockInput, On
		setOpp(opps,0)
		sx := sTx.x
		sy := sTx.y
		myClick( sx , sy, "left")
		;BlockInput, Off
	}
}

openPrecisionW(){
	global precisionAdd
	global precisionObj
	global wasTextSelBeforeThisWin
	wasTextSelBeforeThisWin := getTextSel()
	if(wasTextSelBeforeThisWin.x){

	}else{
		sss := getWindowTest()
		if(sss.aClass = "Qt5QWindowPopupDropShadowSaveBits"){
			sss := getTheNumber(sss)
			if(sss.nbX){
				wasTextSelBeforeThisWin := {}
				wasTextSelBeforeThisWin.x := sss.nbX
				wasTextSelBeforeThisWin.y := sss.nbY
			}
		}
	}

	if (precisionAdd){

	}else{
		precisionAdd := 0.1
	} 
	Fileread, searches, precisionButtons.json
	precisionObj := Jxon_Load(searches)
	winPrecision( "Change precision for UP and Down shortcuts" )

}

;gather all the mask action in one command
doMask( myObj ){
	if( myObj.var = "addBlackMask"){
		maskCreate( myObj )
	}else if( myObj.var = "addWhiteMask"){
		maskCreate( myObj )
	}else if( myObj.var = "addBitmapMask"){
		maskCreate( myObj )
	}else if( myObj.var = "addMaskWithCS"){
		maskCreate( myObj )
	}else if( myObj.var = "selectMask"){
		selectMask()
	}else if( myObj.var = "toggleMask"){
		toggleMask()
	}else if( myObj.var = "removeMask"){
		removeMask()
	}else if( myObj.var = "clearMask"){
		clearMask()
	}else if( myObj.var = "tglSelectCorOrMask"){
		tglSelectCorOrMask()
	}
}

doLayers(myObj){
	if( myObj.var = "selectUpperLayStack"){
		selectUpperLayStack()
	}else if( myObj.var = "selectDownLayStack"){
		selectDownLayStack()
	}
}



; this is the function that the pressing of a button will call
; when adding a function it's necessary to add it here as well
buttonPress( myObj ){
	if(myObj.command){

		if(myObj.command = "shelfSearchAndSelect"){
			;putting defaults
			myObj.toSearch := myObj.toSearch ? myObj.toSearch : ""
			myObj.selectFirst := myObj.selectFirst ? myObj.selectFirst : "False"
			myObj.click := myObj.click ? myObj.click : 1
			myObj.clearAfter := myObj.clearAfter? myObj.clearAfter : "False"
			shelfSearchAndSelect( myObj )
		
		}
		else if(myObj.command = "filterSearchAndSelect"){
			;putting defaults
			myObj.toSearch := myObj.toSearch ? myObj.toSearch : ""
			myObj.selectFirst := myObj.selectFirst ? myObj.selectFirst : "False"
			myObj.click := myObj.click ? myObj.click : 1
			myObj.clearAfter := myObj.clearAfter? myObj.clearAfter : "False"
			filterSearchAndSelect( myObj )
		
		}
		else if(myObj.command = "filterSearchAndCreate"){
			;putting defaults
			myObj.toSearch := myObj.toSearch ? myObj.toSearch : ""
			myObj.selectFirst := myObj.selectFirst ? myObj.selectFirst : "False"
			myObj.click := myObj.click ? myObj.click : 1
			myObj.clearAfter := myObj.clearAfter? myObj.clearAfter : "False"
			myObj.var := myObj.var? myObj.var : "FxAddFilter"
			
			filterSearchAndCreate( myObj )
		
		}

		else if(myObj.command = "test"){
			;putting defaults
			myObj.var := myObj.var ? myObj.var : " deff "
			;test( myObj )
		}
		else if(myObj.command = "maskCreate"){
			;putting defaults
			myObj.var := myObj.var ? myObj.var : "addBlackMask"
			maskCreate( myObj )
		}
		else if(myObj.command = "doLayers"){
			;putting defaults
			myObj.var := myObj.var ? myObj.var : "selectUpperLayStack"
			doLayers( myObj )
		}
		else if(myObj.command = "doMask"){
			;putting defaults
			myObj.var := myObj.var ? myObj.var : "addBlackMask"
			doMask( myObj )
		}
		else if(myObj.command = "maskGroupUI"){
			;putting defaults
			maskGroupUI()
		}
		else if(myObj.command = "shelfSearchUI"){
			;putting defaults
			shelfSearchUI()
		}
		else if(myObj.command = "selectMask"){
			;putting defaults
			selectMask()
		}
		else if(myObj.command = "toggleMask"){
			;putting defaults
			toggleMask()
		}
		else if(myObj.command = "removeMask"){
			;putting defaults
			removeMask()
		}
		else if(myObj.command = "clearMask"){
			;putting defaults
			clearMask()
		}
		else if(myObj.command = "tglSelectCorOrMask"){
			;putting defaults
			tglSelectCorOrMask()
		}
		else if(myObj.command = "viewMask"){
			;putting defaults
			viewMask()
		}
		else if(myObj.command = "createFill"){
			;putting defaults
			createFill( myObj )
		}
		else if(myObj.command = "removeEffect"){
			;putting defaults
			removeEffect()
		}
		else if(myObj.command = "createLayer"){
			;putting defaults
			myObj.var := myObj.var ? myObj.var : "noMask"
			createLayer( myObj )
		}
		else if(myObj.command = "createEffects"){
			;putting defaults
			myObj.var := myObj.var ? myObj.var : "FxAddFilter"
			createEffects( myObj )
		}
		else if(myObj.command = "setBlendMode"){
			;putting defaults
			myObj.blendMode := myObj.blendMode ? myObj.blendMode : "Normal"
			setBlendMode( myObj )
		}
		else if(myObj.command = "toggleDocked"){
			;putting defaults
			myObj.var := myObj.var ? myObj.var : "TextureSets"
			toggleDocked( myObj.var )
		}
		else if(myObj.command = "SH_GroupUI"){
			;putting defaults
			myObj.file := myObj.file ? myObj.file : "empty.json"
			myObj.title := myObj.title ? myObj.title : "BCM_UI"
			SH_GroupUI( myObj )
		}
		else if(myObj.command = "setBrushAlignement"){
			;putting defaults
			myObj.var := myObj.var ? myObj.var : "Tangent|Wrap"
			setBrushAlignement( myObj )
		}
		else if(myObj.command = "setBrushSpacingTo"){
			;putting defaults
			myObj.var := myObj.var ? myObj.var : "5"
			setBrushSpacingTo( myObj )
		}
		else if(myObj.command = "toogle_Flow_Pressure"){
			;putting defaults
			toogleBrushFlowPressure(  )
		}

		else if(myObj.command = "toogle_Size_Pressure"){
			;putting defaults
			toogleBrushSizePressure(  )
		}

		else if(myObj.command = "toogle_Backface_Culling"){
			;putting defaults
			toogleBrushBackfaceCulling(  )
		}

		else if(myObj.command = "doChannels"){
			;putting defaults
			myObj.var := myObj.var ? myObj.var : "disableAll"
			doChannels( myObj )
		}

	}else{
		CornerNotify(1, "!!! No .commad specifyed in the json file for this button !!!", "", "r hc", 1)
	}
}

getMMCreated(){
	global MMcreated
	if(MMcreated == 1){
		CornerNotify(1, "alreadyCreated", "", "r hc", 0)

	}else{
		CornerNotify(1, "not Created", "", "r hc", 0)

	}
}


;======================Tray

addTrayMenus(){
	I_Icon = ico_hZW_icon.ico
	Menu, Tray, Icon, %I_Icon%
	Menu, Tray, NoStandard ; remove standard Menu items
	Menu, Tray, Add , &Help, HelpBtn ;add a item named Change that goes to the Change label
	Menu, Tray, Add , &About Me, AboutAuthorBtn ;add a item named Change that goes to the Change label
	Menu, Tray, Add , &Edit Pie Menus, EditMMM ;add a item named Change that goes to the Change label
	Menu, Tray, Add , &Reload, ReloadBtn ;add a item named Exit that goes to the ButtonExit label
	Menu, Tray, Add , &Exit, ButtonExit ;add a item named Exit that goes to the ButtonExit label
	Return
}

AboutAuthorBtn:
{
	Run, https://www.artstation.com/cbuliarca
	Return
}

HelpBtn:
{	
	bcm_helpWin()
	Return
}

ReloadBtn:
{
	Reload
	Return
}

ButtonExit:
{
	ExitApp
	Return
}

EditMMM:
{
	editMMWin()
	Return
}







;direct hotkeys
;--------------------------------------------------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------------------------------------------------

;the ctrl+alt+s ---- toogle pressure for size
#IfWinActive, ahk_exe Substance Painter.exe
!^s::
{
	toogleBrushSizePressure()
	Return
}

;the ctrl+alt+a ---- toogle pressure for flow
#IfWinActive, ahk_exe Substance Painter.exe
!^a::
{
	toogleBrushFlowPressure()
	Return
}



;shift + alt + p --- set all channels to passthrough
#IfWinActive, ahk_exe Substance Painter.exe
+!p::
{
	toPerformAfterInfoGet := "setChannelsToPassthrough"
	getInfoFromPainter( )

	Return
}


;alt+1 do a shelf search
#IfWinActive, ahk_exe Substance Painter.exe
!1::
{

	myMObjUI := {}
	myMObjUI.file := "searches.json"
	myMObjUI.title := "Shelf Predefined Searches"
	SH_GroupUI( myMObjUI )

	;Fileread, searches, searches.json
	;searchesObj := Jxon_Load(searches)
	;custWindow( "Shelf Predefined Searches", "searches.json" )
	Return
}


;alt` open the mask window`
#IfWinActive, ahk_exe Substance Painter.exe
`::
{
	myMObjUI := {}
	myMObjUI.file := "masksButtons.json"
	myMObjUI.title := "BCM_Commands"
	SH_GroupUI( myMObjUI )
	
	;Fileread, searches, masksButtons.json
	;searchesObj := Jxon_Load(searches)
	;custWindow( "Mask creattions", "masksButtons.json")
	Return
}

;ctrl` open the filters window`
#IfWinActive, ahk_exe Substance Painter.exe
^`::
{
	myMObjUI := {}
	myMObjUI.file := "filtersButtons.json"
	myMObjUI.title := "Filters creations"
	SH_GroupUI( myMObjUI )


	;Fileread, searches, filtersButtons.json
	;searchesObj := Jxon_Load(searches)
	;custWindow( "Filters creations", "filtersButtons.json")
	Return
}
;alt] select upper`
#IfWinActive, ahk_exe Substance Painter.exe
!]::
{
	selectUpperLayStack()
	Return
}

;alt[ down upper`
#IfWinActive, ahk_exe Substance Painter.exe
![::
{
	selectDownLayStack()
	Return
}

;altc view mask`
#IfWinActive, ahk_exe Substance Painter.exe
!c::
{
	viewMask()
	Return
}

;altc view mask`
#IfWinActive, ahk_exe Substance Painter.exe
!`::
{	

	myMObjUI := {}
	myMObjUI.file := "blendingModesButtons.json"
	myMObjUI.title := "Change Blending Mode"
	SH_GroupUI( myMObjUI )

	;Fileread, searches, blendingModesButtons.json
	;searchesObj := Jxon_Load(searches)
	;custWindow( "Change Blending Mode", "blendingModesButtons.json")
	Return
}
;alt + Up add increment by precision `
#IfWinActive, ahk_exe Substance Painter.exe
!Right::
{	
	accOp("add")
	Return	
}

;alt + Down substract increment by precision `
#IfWinActive, ahk_exe Substance Painter.exe
!Left::
{	
	accOp("minus")
	Return	
}


;shift + alt + right open the precision window`
#IfWinActive, ahk_exe Substance Painter.exe
+!Right::
{
	openPrecisionW()
	Return
}
;shift + alt + left open the precision window`
#IfWinActive, ahk_exe Substance Painter.exe
+!Left::
{
	openPrecisionW()
	Return
}
;alt + F1 click on the docked texture Sets button`
#IfWinActive, ahk_exe Substance Painter.exe
!F1::
{

	toggleDocked("TextureSets")
	Return
}
;alt + F1 click on the docked texture Sets button`
#IfWinActive, ahk_exe Substance Painter.exe
!F2::
{

	toggleDocked("TextureSetsSettings")
	Return
}


;alt + F1 click on the docked Properties button`
#IfWinActive, ahk_exe Substance Painter.exe
!F3::
{

	toggleDocked("DisplaySettings")
	Return
}
;alt + F1 click on the docked Properties button`
#IfWinActive, ahk_exe Substance Painter.exe
!F4::
{

	toggleDocked("ShaderSettings")
	Return
}

;alt + F1 click on the docked Properties button`
#IfWinActive, ahk_exe Substance Painter.exe
!F5::
{

	toggleDocked("Properties")
	Return
}



;BCM_substancePainter_shortcuts.ahk
;ahk_class AutoHotkeyGUI
;ahk_exe AutoHotkey.exe

;#IfWinActive, BCM_substancePainter_shortcuts.ahk BCM_substancePainter_shortcuts.exe 
#if WinActive("qAct.ahk") or WinActive("qAct.exe")
Esc::
{
	;destroy the gui with the esc key
	Gui, bcmSH1:Destroy
	Gui, bcmPrWin:Destroy
	Gui, bcmOptWin:Destroy
	Return
}

;F7::
;{
	
;	DetectHiddenWindows, On
;	WinGet, allWIN, list ;get allWIN hwnd
;	as := 1
;	myWin := {}
;	ssss := allWIN1
;	;MsgBox, %ssss%
;	Loop, %allWIN%
;    {
;        WinGetClass, WClass, % "ahk_id " allWIN%A_Index%
;        if (WClass = "Qt5QWindowPopupDropShadowSaveBits"){

;        	myWin[as] := allWIN%A_Index%
;        	WinGet, Style, Style, % "ahk_id " allWIN%A_Index%
;        	;WinGetPos, X, Y, Width, Height, 
;        	;splashinfo( Style )
;        	;WinActivate, % "ahk_id " allWIN%A_Index%
;        	WinRestore, % "ahk_id " allWIN%A_Index%
;        	WinShow, % "ahk_id " allWIN%A_Index%
;        	;WinSet, Style, +0x80000000 +0x80880000 +0x40000 +0x10000000, % "ahk_id " allWIN%A_Index%
;        	as := as + 1
;        }
;    }

;    ;MsgBox, %cs%
;    ;msgBObj(myWin)
;	;splashInfo( spWin )
;	Return
;}

;ctrl+F7 clciks on the channels
;#IfWinActive, ahk_exe Substance Painter.exe
;^F7::
;{

;	doChannels( obj )
;	Return
;}

;`F7
#IfWinActive, ahk_exe Substance Painter.exe
F7::
{
	
	;getAllPixelsMonitors()
	;bcm_msgBObj(getPanel( "Shelf" ))
	;findFloatPanel( "Properties" )
	;bcm_splashInfo( "tttttttt")

	;selectUppMainLayStack()
	;myObj.var := "noMask"
	;createLayer( myObj )
	;myObj := {}
	;myObj.var := "UV"
	;setBrushAlignement(myObj)
	;editMMWin()
	;bcm_helpWin()
	;getViewport()
	;toogleBrushBackfaceCulling()

	WinGet, WinList, List, ahk_exe osdHotkey.exe,,,
	Loop %WinList%
	{
		WinID := WinList%A_Index%
		bcm_splashInfo(WinID)
		Winset, AlwaysOnTop, On, ahk_id %WinID%
		;WinSet, Style, +0x80000000	, ahk_id %WinID%
		WinSet, Style, -0xC00000, ahk_id %WinID%
	}
	Return
}

#IfWinActive, ahk_exe Substance Painter.exe
~MButton::
{
	global AllowMM
	;if( AllowMM = 1){
		theMM()
	;}
	Return
}




