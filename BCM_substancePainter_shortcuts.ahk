
#Include %A_ScriptDir%              ; Set working directory for #Include.
#Include *i Jxon22.ahk
#Include *i CornerNotify.ahk        ; Notifyer.
#Include *i winSearches.ahk        ; Notifyer.
#Include *i winPrecision.ahk        ; Notifyer.
;#Include *i Eval.ahk



toPerformAfterInfoGet := ""
painterInfoObj := {}

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

splashInfo( sq ){
	WinGet, WinID1, ID, ahk_exe Substance Painter.exe,,,
	WinGetPos, aX, aY, aW, aH, ahk_id %WinID1%
	w := 500
	bX := aX + ((aW * 0.5) - (w*0.5))
	bY := aY + (aH*0.35)

	SplashImage , , x%bX% y%bY% W%w% b1 cw008000 ctffff00, sssss: .%sq%, %sq%
	Sleep,1000
	SplashImage, Off
}

msgBObj( ob ){
	txt := ""
	For k, v in ob{
		txt1 := (" " . k . " :: " . v . "`n")
		txt := txt . txt1
	}
	MsgBox, %txt%
	return
}

toogleSizePressure( bTabX, bTabY ){

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
		Click, %theSizeX%, %theSizeY%
		npY := theSizeY + 40
		Click, %theSizeX%, %npY%
		BlockInput, off
	}
	Else
	{
		CornerNotify(1, "Size pressure OFF", "", "r hc", 0)
		BlockInput, on
		Click, %theSizeX%, %theSizeY%
		npY1 := theSizeY + 10
		Click, %theSizeX%, %npY1%
		BlockInput, off
	}
}


toogleOpacityPressure( bTabX, bTabY ){

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
		Click, %theSizeX%, %theSizeY%
		npY := theSizeY + 40
		Click, %theSizeX%, %npY%
		BlockInput, off
	}
	Else
	{
		CornerNotify(1, "Flow pressure OFF", "", "r hc", 0)
		BlockInput, on
		Click, %theSizeX%, %theSizeY%
		npY1 := theSizeY + 10
		Click, %theSizeX%, %npY1%
		BlockInput, off
	}
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
		;global painterInfoObj

	;CornerNotify(1, "!!! setChannelsToPassthrough !!!", "", "r hc", 0)

	;set all properties to passthrow
	layersPanel := {}
	MouseGetPos, xpos, ypos 
	mSpeed := 0.000001
	ImageSearch, LayersFoundX, LayersFoundY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, %A_ScriptDir%\images\Layers.png
	if (ErrorLevel = 2)
	{
	    CornerNotify(1, "!!! Could not conduct the search !!!", "", "r hc", 1)
	}
	else if (ErrorLevel = 1)
	{
	    CornerNotify(1, "!!! 'Layers' could not be found on the screen !!!", "", "r hc", 1)
	}
	else
	{
		layersPanel.bLeft := LayersFoundX - 8
		layersPanel.bTop := LayersFoundY - 13
		ImageSearch, LayersEndPanelDownX, LayersEndPanelDownY, layersPanel.bLeft, layersPanel.bTop + 13, layersPanel.bLeft + 14, %A_ScreenHeight%, %A_ScriptDir%\images\bottomPanel.png
		if (ErrorLevel = 1)
		{
		    CornerNotify(1, "!!! end of 'Layers' panel could not be found on the screen !!!", "", "r hc", 1)
		}
		else{
			layersPanel.bBottom := LayersEndPanelDownY
			ImageSearch, LayersClosePanelX, LayersClosePanelY, layersPanel.bLeft , layersPanel.bTop + 8, %A_ScreenWidth% , layersPanel.bTop + 25, %A_ScriptDir%\images\closePanel.png
			if (ErrorLevel = 1)
			{
			    CornerNotify(1, "!!! close of 'Layers' panel could not be found on the screen !!!", "", "r hc", 1)
			}
			else{
				layersPanel.bRight := LayersClosePanelX + 21

				;BlockInput, On
				;MouseMove, layersPanel.bLeft, layersPanel.bTop, 10s
				;MouseMove, layersPanel.bLeft, layersPanel.bBottom, 10
				;MouseMove, layersPanel.bRight, layersPanel.bBottom, 10
				;MouseMove, layersPanel.bRight, layersPanel.bTop, 10
				;BlockInput, Off

				
			}
		}
	}

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
	;s1 := lP.bRight - 20
	;s2 := lP.bTop
	;s3 := lP.bRight
	;s4 := lP.bBottom
	;MsgBox, bRight: %s1% . bTop:%s2% . bLeft:%s3% . bBottom:%s4%
	;s1 := tq.scrollerTop
	;s2 := tq.scrollerBottom
	;s3 := tq.scrollerCenterY
	;s4 := tq.scrollerLeft
	;s5 := tq.scrollUppY
	;s6 := tq.scrollerOffset
	;MsgBox, scrollerTop: %s1% . scrollerBottom:%s2% . scrollerCenterY:%s3% . scrollerLeft:%s4% . scrollUppY:%s5% . scrollerOffset:%s6%
	;splashInfo( tq.scrollerCenterY )
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
	;shelf := getShelfTab( shelf )
	;if(shelf.shelfTabActive = 0){
	;	;select the shelf
	;	sTX := shelf.shelfTabX + 5
	;	sTY := shelf.shelfTabY + 5
	;	BlockInput, on
	;	Click, %sTX%, %sTY%
	;	BlockInput, off
	;	Sleep, 50
	;}
	shelf := getShelfFolder( shelf )
	shelf := getShelfFilter( shelf )
	shelf := getShelfSerchesEndX( shelf )
	if(shelf.shelfSearchEndX = 1){
		sT1X := shelf.shelfSearchEndXX + 9
		sT1Y := shelf.shelfSearchEndXY + 9
		BlockInput, on
		Click, %sT1X%, %sT1Y%
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
getShelfSearchX( sh ){
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
getShelfSerchesEndX( sh ){
	ImageSearch, ShelfSearchEndXX, ShelfSearchEndXY, sh.shelfFilterX + 12, sh.shelfFilterY - 7, %A_ScreenWidth%, sh.shelfFilterY + 20, %A_ScriptDir%\images\searchX.png
	if (ErrorLevel = 1)
	{
		ImageSearch, ShelfSearchEndXX, ShelfSearchEndXY, sh.shelfFilterX + 12, sh.shelfFilterY - 7, %A_ScreenWidth%, sh.shelfFilterY + 20, %A_ScriptDir%\images\searchX2.png
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
getShelfSearch( sh ){
	ImageSearch, ShelfSearchX, ShelfSearchY, sh.shelfFilterX + 12, sh.shelfFilterY - 7, %A_ScreenWidth%, sh.shelfFilterY + 24, %A_ScriptDir%\images\searchStart.png
	if (ErrorLevel = 1)
	{
		ImageSearch, ShelfSearchX, ShelfSearchY, sh.shelfFilterX + 12, sh.shelfFilterY - 7, %A_ScreenWidth%, sh.shelfFilterY + 24, %A_ScriptDir%\images\searchStartOn.png
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

getShelfFilter( sh ){
	if( sh.shelfFolderX ){
		shStartX := sh.shelfFolderX + 10
		shStartY := sh.shelfFolderY - 2
		shEndY := sh.shelfFolderY + 20

	}else{
		shStartX := 0
		shStartY := 0
		shEndY := A_ScreenHeight
	}
	ImageSearch, ShelfFilterX, ShelfFilterY, shStartX, shStartY, %A_ScreenWidth%, shEndY, %A_ScriptDir%\images\filerActive.png
	if (ErrorLevel = 1)
	{
		ImageSearch, ShelfFilterX, ShelfFilterY, shStartX, shStartY, %A_ScreenWidth%, shEndY, %A_ScriptDir%\images\filerInactive.png
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
			ImageSearch, ShelfFilterEndX, ShelfFilterEndY, sh.shelfFilterX, sh.shelfFilterY + 29, %A_ScreenWidth%, sh.shelfFilterY + 36, %A_ScriptDir%\images\filterActiveBand.png
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



getShelfFolder( sh ){
	ImageSearch, ShelfFolderX, ShelfFolderY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, %A_ScriptDir%\images\folderActive.png
	if (ErrorLevel = 1)
	{
		ImageSearch, ShelfFolderX, ShelfFolderY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, %A_ScriptDir%\images\folderInactive.png
		if (ErrorLevel = 1)
		{
		;shelf Folder could not be found
			CornerNotify(1, "!!! The shelf Folder is not visible !!!", "", "r hc", 1)
		}Else{
			sh.shelfFolderX := ShelfFolderX
			sh.shelfFolderY := ShelfFolderY
			sh.shelfFolderActive := 0l
			;return tr 
		}	
	}Else{
			sh.shelfFolderX := ShelfFolderX
			sh.shelfFolderY := ShelfFolderY
			sh.shelfFolderActive := 1
			ImageSearch, ShelfFolderEndX, ShelfFolderEndY, ShelfFolderX, ShelfFolderY + 4, %A_ScreenWidth%, ShelfFolderY + 6, %A_ScriptDir%\images\folderActiveBand.png
			if (ErrorLeve = 1)
			{
				CornerNotify(1, "!!! The shelf FolderEnd is not visible !!!", "", "r hc", 1)
			}
			Else{
				sh.shelfFolderEndX := ShelfFolderEndX + 3 
			}
			;MsgBox, ssss is .%tr.shelfTabX%
			;return tr
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
	MouseGetPos, xpos, ypos 
	mSpeed = 0.000001
	shelfA := getShelf()
	if(shelfA.shelfSearchX){
		sX := shelfA.shelfSearchX + 2
		sY := shelfA.shelfSearchY + 4
		;MsgBox, %sX% . %sY%
		BlockInput, on
		Click, %sX%, %sY% ; clcik on the serch field
		
		;clear the field
		Send {Home}
		Send {Shift}+{End}
		Send {Backspace}

		;if there is a filter on just close it
		if (shelfA.shelfSearchFilterOn = 1){
			sfX := shelfA.shelfSearchFilterOnX + 5
			sfY := shelfA.shelfSearchFilterOnY + 5
			Click, %sfX%, %sfY%
		}

		;send text to search
		myText := myOb.toSearch
		clipboard := myText
		Send, ^v
		;Send {Text} %myText%


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
				Click, %selX%, %selY%
				Sleep, 100
			}
			
		}
		if( myOb.clearAfter = "True"){
			Click, %sX%, %sY%
			Send {Home}
			Send {Shift}+{End}
			Send {Backspace}
		}
		BlockInput, off
		MouseMove, xpos, ypos, mSpeed  
		BlockInput, Off
	}
}

test( myObj ){
	ss := myObj.var
	MsgBox, %ss%
}





getPropertiesPanel(){

	propPanel := {}
	ImageSearch, propFoundX, propFoundY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, %A_ScriptDir%\images\Properies - Paint.png
	if (ErrorLevel = 2)
	{
	    CornerNotify(1, "!!! Could not conduct the search !!!", "", "r hc", 1)
	}
	else if (ErrorLevel = 1)
	{
		ImageSearch, propIconFoundX, propIconFoundY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, %A_ScriptDir%\images\PropertiesDocked.png
		if (ErrorLevel = 1)
		{
	    	CornerNotify(1, "!!! 'Properties -' could not be found on the screen !!!", "", "r hc", 1)
		}else{
			propPanel.IconX := propIconFoundX + 10
			propPanel.IconY := propIconFoundY + 10
			propPanel := getWindowUnDocked( propPanel )
		}
	}
	else
	{
		propPanel.bLeft := propFoundX - 6
		propPanel.bTop := propFoundY - 14
		ImageSearch, propEndPanelDownX, propEndPanelDownY, propPanel.bLeft, propPanel.bTop, propPanel.bLeft + 100, %A_ScreenHeight%, %A_ScriptDir%\images\bottomPanel.png
		if (ErrorLevel = 1)
		{
		    CornerNotify(1, "!!! end of 'Properties -' panel could not be found on the screen !!!", "", "r hc", 1)
		}
		else{
			propPanel.bBottom := propEndPanelDownY
			ImageSearch, propClosePanelX, propClosePanelY, propPanel.bLeft, propPanel.bTop + 8, %A_ScreenWidth% , propPanel.bTop + 26, %A_ScriptDir%\images\closePanel.png
			if (ErrorLevel = 1)
			{
			    CornerNotify(1, "!!! close of 'Properties -' panel could not be found on the screen !!!", "", "r hc", 1)
			}
			else{
				propPanel.bRight := propClosePanelX + 21 

				;BlockInput, On
				;MouseMove, propPanel.bLeft, propPanel.bTop, 10
				;MouseMove, propPanel.bLeft, propPanel.bBottom, 10
				;MouseMove, propPanel.bRight, propPanel.bBottom, 10
				;MouseMove, propPanel.bRight, propPanel.bTop, 10
				;BlockInput, Off

				
			}
		}
	}

	return propPanel
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




getWindowUnDocked( pr ){
	cX := pr.IconX
	cY := pr.IconY
	MouseGetPos, xpos, ypos 
	mSpeed := 0.000001
	BlockInput, on
	Click, %cX%, %cY%
	Sleep, 50
	WinGet, WinID, ID, ahk_exe Substance Painter.exe,,,
	WinGetPos, aX, aY, aW, aH, ahk_id %WinID%
	WinGetClass, aClass, ahk_id %WinID%
	qr := GetMonitorUnderMouse2()
	;splashInfo(" x: " . aX . " y: " . aY . " w: " . aW . " h: " . aH . " class: " . aClass)
	if (aClass = "Qt5QWindowToolSaveBits"){
		if(aX < 0){
			pr.bLeft := A_ScreenWidth + aX + 4 + 2
		}else{
			pr.bLeft := aX + 4 + 2
		}
		pr.bRight := pr.bLeft + aW - 4
		pr.bTop := aY + 4 + 2
		pr.bBottom := pr.bTop + aH - 4
	}
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
	createEffects( myObj )
	sleep 100
	filterSearchAndSelect( myObj )
}


filterSearchAndSelect( myObj ){

	flr := getFilterSearch()
	MouseGetPos, xpos, ypos 
	mSpeed = 0.000001
	if(flr.bRight){
		BlockInput, on
		if(flr.scrollerOffset > 0){
			moveScrollUp( flr )
		} 

		flr := getSBSField(flr)
		if( flr.sbsFieldTop){

			sx1 := flr.sbsFieldLeft + 19
			sy1 := flr.sbsFieldTop + 14

			flr.searchBLeft := sx1
			flr.searchBTop := sy1
			flr.searchBRight := flr.searchBLeft + 297
			flr.searchBBottom := flr.searchBTop + 306
			if(flr.searchBRight > A_ScreenWidth){
				flr.searchBRight := A_ScreenWidth
				flr.searchBLeft := flr.searchBRight - 297
			}
			if(flr.searchBBottom > A_ScreenHeight){
				flr.searchBTop := sy1 + 306
				flr.searchBBottom := sy1
			}
			;open search window
			Click %sx1% %sy1%

			Send {Home}
			Send {Shift}+{End}
			Send {Backspace}

			myText := myObj.toSearch
			clipboard := myText
			Send, ^v

			if( myObj.selectFirst = "True"){
				sx2 := flr.searchBLeft + 33
				sy2 := flr.searchBTop + 74
				Sleep 50
				if( flr.IconX ){
					; this means that the window last opened was the over one
					; the coordinates were changed
					sx2 := sx2 - flr.bLeft 
					sy2 := sy2 - flr.bTop 
					Click %sx2% %sy2%
					;close the panel, click on the x
					sx3 := (flr.bLeft + (flr.bRight - flr.bleft - 16)) -  flr.bLeft
					sy3 := (flr.bTop + 16) - flr.bTop
					Click %sx3% %sy3%
				}else{
					Click %sx2% %sy2%
				}
			}
		}

		BlockInput, off

		MouseMove, xpos, ypos, mSpeed  
	}

	return
}
getFilterSearch(){
	pr := getPropertiesPanel()
	if(pr.bRight) prSc := getScroll( pr )
	return pr
}

;====================masks
;================================================================
;================================================================
maskCreate( myObj ){
	MouseGetPos, xpos, ypos 
	mSpeed := 0.000001
	lay := getLayersPanel()
	msk := getMaskButton(lay)
	mx := msk.x + 4
	my := msk.y + 4
	BlockInput, on
	Click, %mx%, %my%
	Sleep, 100
	if( myObj.var = "addBlackMask"){
		my1 := msk.addBlackMask
		Click, %mx%, %my1%
	}else if(myObj.var = "addWhiteMask"){
		my1 := msk.addWhiteMask
		Click, %mx%, %my1%
	}else if(myObj.var = "addBitmapMask"){
		my1 := msk.addBitmapMask
		Click, %mx%, %my1%
	}else if(myObj.var = "addMaskWithCS"){
		my1 := msk.addMaskWithCS
		Click, %mx%, %my1%
	}
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
 maskGroupUI(){
 	global searchesObj
 	searchesObj :={}
 	;wer := searchesObj.buttonsA[1].name
 	;MsgBox, %wer%
 	Fileread, searches1, masksButtons.json
	searchesObj := Jxon_Load(searches1)
	custWindow( "Mask creations")
	Return
 }
 shelfSearchUI(){
 	global searchesObj
 	searchesObj :={}
 	;wer := searchesObj.buttonsA[1].name
 	;MsgBox, %wer%
 	Fileread, searches1, searches.json
	searchesObj := Jxon_Load(searches1)
	custWindow( "Shelf Predefined Searches" )
	Return
 }

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
	 	;splashInfo(cx)
	 	MouseGetPos, xpos, ypos 
	 	mSpeed := 0.000001
	 	BlockInput, On
	 	Click, %cx%, %cy%
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
	 	;splashInfo(cx)
	 	MouseGetPos, xpos, ypos 
	 	mSpeed := 0.000001
	 	BlockInput, On
	 	Click, %cx%, %cy%
		MouseMove, xpos, ypos, mSpeed  
		BlockInput, off
   	}
	Return
}



 selectMask( ){
 	layPanel := getLayersPanel()
 	;if (layPanel.bRight) layPanel := getLayerPanelScroller(layPanel)
 	layPanel := getSelectedLayerP(layPanel)

 	if(layPanel.activeLayUp) layPanel := getLayerIcons(layPanel)
 	;if(layPanel.hasMask) layPanel := isMaskActive( layPanel )

 	cx := layPanel.acvLayMaskCenterX
 	cy := layPanel.activeLayUp + 18
 	MouseGetPos, xpos, ypos 
 	mSpeed := 0.000001
 	BlockInput, On
 	Click, %cx%, %cy%
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
	MouseGetPos, xpos, ypos 
	mSpeed := 0.000001
 	if( doIt = 1){
	 	cx := layPanel.acvLayMaskCenterX
	 	cy := layPanel.activeLayUp + 18
	 	BlockInput, On
		Send !{Click, %cx%, %cy%}
		if(doItD = 1){
			Click, %dx%, %dy%
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
 	;msgBobj(layPanel)
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
		Send +{Click, %cx%, %cy%}
		if(doItD = 1){
			Click, %dx%, %dy%
		}
		MouseMove, xpos, ypos, mSpeed  
		BlockInput, off
 	}
 	Return
 }

removeMask(){
	layPanel := getLayersPanel()
	layPanel := getSelectedLayerP(layPanel)
	MouseGetPos, xpos, ypos 
	mSpeed := 0.000001
	BlockInput, On
	ay := layPanel.activeLayUp + 20
	ax := layPanel.bLeft + 10
	Click, right, %ax%, %ay%
	Sleep, 100
	layPanel := getLayContextWindow(layPanel)
	by := layPanel.actvLayCtxRemoveMask
	bx := ax + 10
	Click, %bx%, %by%
	MouseMove, xpos, ypos, mSpeed  
	BlockInput, off
	;msgBobj(layPanel)

}
clearMask(){
	layPanel := getLayersPanel()
	layPanel := getSelectedLayerP(layPanel)
	MouseGetPos, xpos, ypos 
	mSpeed := 0.000001
	BlockInput, On
	ay := layPanel.activeLayUp + 20
	ax := layPanel.bLeft + 10
	Click, right, %ax%, %ay%
	Sleep, 100
	layPanel := getLayContextWindow(layPanel)
	by := layPanel.actvLayCtxClearMask
	bx := ax + 10
	Click, %bx%, %by%
	MouseMove, xpos, ypos, mSpeed  
	BlockInput, off

}
removeEffect(){
	layPanel := getLayersPanel()
	layPanel := getSelectedLayerP(layPanel)
	;msgBobj(layPanel)
	if(layPanel.activeStackUp){
		layPanel := getStacksAfterActive(layPanel)
		MouseGetPos, xpos, ypos 
		mSpeed := 0.000001
		BlockInput, On
		ay := layPanel.activeStackUp + 11
		ax := layPanel.bRight - 22
		Click, %ax%, %ay%
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
			Click, %mx%, %my2%
		}
		MouseMove, xpos, ypos, mSpeed  
		BlockInput, off
	}

}


 tglSelectCorOrMask(){
 	layPanel := getLayersPanel()
 	;if (layPanel.bRight) layPanel := getLayerPanelScroller(layPanel)
 	layPanel := getSelectedLayerP(layPanel)
 	layPanel := getLayerIcons(layPanel)
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
 	Click, %cx%, %cy%
	MouseMove, xpos, ypos, mSpeed  
	BlockInput, off
 	Return
 }

 getLayerIcons(lp){
 	ImageSearch, acStackX, acStackY, lp.lLeft, lp.activeLayDown - 11, lp.bRight, lp.activeLayDown - 4, %A_ScriptDir%\images\grayStacks.png
  	if (ErrorLevel = 1)
	{
		;CornerNotify(1, "!!! can't see the stack icon !!!", "", "r hc", 1)	
	}else{
		s1X := acStackX
	}

 	ImageSearch, caaaX, acStack1Y, lp.lLeft, lp.activeLayDown - 11, lp.bRight, lp.activeLayDown - 4, %A_ScriptDir%\images\oranageStacks.png
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

createFill( myObj ){

	lay := getLayersPanel()
	if(lay.addFillButtonX){
		MouseGetPos, xpos, ypos 
		mSpeed = 0.000001
		lx := lay.addFillButtonX
		ly := lay.addFillButtonY
		msk := getMaskButton(lay)
		BlockInput, on
		Click, %lx%, %ly%
		Sleep, 300
		if( myObj.var ){
			mx := msk.x
			my := msk.y 
			Click, %mx%, %my%
			Sleep, 100
			if( myObj.var = "addBlackMask"){
				my1 := msk.addBlackMask
				Click, %mx%, %my1%
			}else if(myObj.var = "addWhiteMask"){
				my1 := msk.addWhiteMask
				Click, %mx%, %my1%
			}else if(myObj.var = "addBitmapMask"){
				my1 := msk.addBitmapMask
				Click, %mx%, %my1%
			}else if(myObj.var = "addMaskWithCS"){
				my1 := msk.addMaskWithCS
				Click, %mx%, %my1%
			}
		}
		MouseMove, xpos, ypos, mSpeed  
		BlockInput, Off
	}
	return
}

createEffects( myObj ){

	MouseGetPos, xpos, ypos 
	mSpeed = 0.000001
	lay := getLayersPanel()
	lay := getEffectsButton(lay)
	mx := lay.addFxButtonX
	my := lay.addFxButtonY

	if( myObj.var = "FxAddGenerator"){
		my1 := lay.FxAddGenerator
		BlockInput, on
		Click, %mx%, %my%
		Sleep, 100
		Click, %mx%, %my1%
	}else if(myObj.var = "FxAddPaint"){
		my1 := lay.FxAddPaint
		BlockInput, on
		Click, %mx%, %my%
		Sleep, 100
		Click, %mx%, %my1%
	}else if(myObj.var = "FxAddFill"){
		my1 := lay.FxAddFill
		BlockInput, on
		Click, %mx%, %my%
		Sleep, 100
		Click, %mx%, %my1%
	}else if(myObj.var = "FxAddLevels"){
		my1 := lay.FxAddLevels
		BlockInput, on
		Click, %mx%, %my%
		Sleep, 100
		Click, %mx%, %my1%
	}else if(myObj.var = "FxAddFilter"){
		my1 := lay.FxAddFilter
		BlockInput, on
		Click, %mx%, %my%
		Sleep, 100
		Click, %mx%, %my1%
	}else if(myObj.var = "FxAddColorSelection"){
		my1 := lay.FxAddColorSelection
		BlockInput, on
		Click, %mx%, %my%
		Sleep, 100
		Click, %mx%, %my1%
	}else if(myObj.var = "FxAddAnchorPoint"){
		my1 := lay.FxAddAnchorPoint
		BlockInput, on
		Click, %mx%, %my%
		Sleep, 100
		Click, %mx%, %my1%
	}else if(myObj.var = "FxRemove"){
		my1 := lay.FxRemove
		lay := getSelectedLayerP(lay)
		if(lay.activestackUp OR lay.activeAnchorUp){
			lay := getStacksAfterActive(lay)
			BlockInput, on
			Click, %mx%, %my%
			Sleep, 100
			Click, %mx%, %my1%
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
				Click, %mx%, %my2%
			}
			
		}
	}
	MouseMove, xpos, ypos, mSpeed  
	BlockInput, Off
	Return

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
	 		mx := lay.bRight - 71
	 		my := lay.activeStackUp + 12
	 	}else{
	 		mx := lay.bRight - 25
	 		my := lay.activeLayUp + 15 
	 	}
	 		MouseGetPos, xpos, ypos 
			mSpeed = 0.000001
			BlockInput, on
			Click, %mx%, %my%
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
	 			Click, %mx1%, %my1%
	 		}

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
	;splashInfo(" x: " . aX . " y: " . aY . " w: " . aW . " h: " . aH . " class: " . aClass)
	if (aClass = "Qt5QWindowPopupDropShadowSaveBits"){
		if( aX = 0 AND aY = 0){
			lp.blendingsWinTop := 0
			lp.blendingsWinLeft := 0
			lp.blendingsWinRight := lp.blendingsWinLeft + 147
			lp.blendingsWinBottom := lp.blendingsWinTop + 600
			if(qr.swaped = 1){
				;splashInfo( "swaped sssss")
				lp.blendingsWinLeft := A_ScreenWidth 
				lp.blendingsWinRight := lp.blendingsWinLeft - 147
			}
			;the error happend
		}else{
			if( lp.activeStackDown){
				lp.blendingsWinTop := lp.activeStackDown - 1
				lp.blendingsWinLeft := lp.bRight - 84
				lp.blendingsWinRight := lp.blendingsWinLeft + 147
				lp.blendingsWinBottom := lp.blendingsWinTop + 600
				if( lp.blendingsWinBottom > A_ScreenHeight){
					lp.blendingsWinBottom := lp.activeStackUp - 1
					lp.blendingsWinTop := lp.blendingsWinBottom - 600
				}
				if( lp.blendingsWinRight > A_ScreenWidth){
					lp.blendingsWinRight := A_ScreenWidth
					lp.blendingsWinLeft := lp.blendingsWinRight - 147
				}
			}else if( lp.activeLayDown ){
				lp.blendingsWinTop := lp.activeLayUp + 23
				lp.blendingsWinLeft := lp.bRight - 54
				lp.blendingsWinRight := lp.blendingsWinLeft + 147
				lp.blendingsWinBottom := lp.blendingsWinTop + 600
				if( lp.blendingsWinBottom > A_ScreenHeight){
					lp.blendingsWinBottom := lp.activeStackUp - 1
					lp.blendingsWinTop := lp.blendingsWinBottom - 600
					if(lp.blendingsWinTop < 0){
						lp.blendingsWinTop := 0
						lp.blendingsWinBottom := lp.blendingsWinTop + 600
					}
				}
				if( lp.blendingsWinRight > A_ScreenWidth){
					lp.blendingsWinRight := A_ScreenWidth
					lp.blendingsWinLeft := lp.blendingsWinRight - 147
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

custWindow( ttl ){
	winSearches( ttl )
}

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
			test( myObj )
		}
		else if(myObj.command = "maskCreate"){
			;putting defaults
			myObj.var := myObj.var ? myObj.var : "addBlackMask"
			maskCreate( myObj )
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

	}else{
		CornerNotify(1, "!!! No .commad specifyed in the json file for this button !!!", "", "r hc", 1)
	}
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
	Click %cPx%, %cPy%
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

moveScrollUp( scrollInfo  ){
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

getBrushSize(){
	tr := {}
	ImageSearch, FoundX, FoundY, 0, 30 , %A_ScreenWidth%, 95 , %A_ScriptDir%\images\BrushSizeUpp.png
	if (ErrorLevel = 2)
	{
		CornerNotify(1, "!!! Could not conduct the search !!!", "", "r hc", 1)
	}
	else if (ErrorLevel = 1)
	{
	    CornerNotify(1, " !!! 'Size' could not be found on the upper part. !!!", "", "r hc", 1)
	    ;MsgBox "Properies -" could not be found on the screen.
	}
	else
	{
		tr.sizeX := FoundX
		tr.sizeY := FoundY
		ImageSearch, penPressureX, penPressureY, tr.sizeX + 110, tr.sizeY, tr.sizeX + 136, tr.sizeY+ 25, %A_ScriptDir%\images\penPressure.png
		if (ErrorLevel = 1){
			tr.penPressure := 0
		}else{
			tr.penPressure := 1

		}
		tr.sizeDropDownX := tr.sizeX + 122
		tr.sizeDropDownY := tr.sizeY + 14
		tr.noPressureD := tr.sizeDropDownY + 30
		tr.penPressureD := tr.sizeDropDownY + 53
	}
	return tr
}
getBrushFlow(){
	tr := {}
	ImageSearch, FoundX, FoundY, 0, 30 , %A_ScreenWidth%, 95 , %A_ScriptDir%\images\BrushFlowUpp.png
	if (ErrorLevel = 2)
	{
		CornerNotify(1, "!!! Could not conduct the search !!!", "", "r hc", 1)
	}
	else if (ErrorLevel = 1)
	{
	    CornerNotify(1, " !!! 'Flow' could not be found on the upper part. !!!", "", "r hc", 1)
	    ;MsgBox "Properies -" could not be found on the screen.
	}
	else
	{
		tr.flowX := FoundX
		tr.flowY := FoundY
		ImageSearch, penPressureX, penPressureY, tr.flowX + 110, tr.flowY, tr.flowX + 136, tr.flowY+ 25, %A_ScriptDir%\images\penPressure.png
		if (ErrorLevel = 1){
			tr.penPressure := 0
		}else{
			tr.penPressure := 1

		}
		tr.flowDropDownX := tr.flowX + 122
		tr.flowDropDownY := tr.flowY + 14
		tr.noPressureD := tr.flowDropDownY + 30
		tr.penPressureD := tr.flowDropDownY + 53
	}
	return tr
}

;the ctrl+alt+s ---- toogle pressure for size
#IfWinActive, ahk_exe Substance Painter.exe
!^s::
{
	pressSize := getBrushSize()
	if(pressSize.sizeX){
		MouseGetPos, xpos, ypos 
		mSpeed := 0.000001
		BlockInput, On
		clX := pressSize.sizeDropDownX
		clY := pressSize.sizeDropDownY
		Click %clX% %clY%
		Sleep 100
		if(pressSize.penPressure = 1){
			clX1 := pressSize.sizeDropDownX
			clY1 := pressSize.noPressureD

			Click %clX1% %clY1%
			CornerNotify(1, " Brush Size set to NO pen pressure ", "", "r hc", 0)
		}else{
			clX1 := pressSize.sizeDropDownX
			clY1 := pressSize.penPressureD
			Click %clX1% %clY1%		
			CornerNotify(1, " Brush Size set to PEN PRESSURE ", "", "r hc", 0)	
		}

		MouseMove, xpos, ypos, mSpeed  
		BlockInput, Off
	}
	Send {Ctrl}{Alt}
	Return
}

;the ctrl+alt+a ---- toogle pressure for flow
#IfWinActive, ahk_exe Substance Painter.exe
!^a::
{
	pressFlow := getBrushFlow()
	if(pressFlow.flowX){
		MouseGetPos, xpos, ypos 
		mSpeed := 0.000001
		BlockInput, On
		clX := pressFlow.flowDropDownX
		clY := pressFlow.flowDropDownY
		Click %clX% %clY%
		Sleep 100
		if(pressFlow.penPressure = 1){
			clX1 := pressFlow.flowDropDownX
			clY1 := pressFlow.noPressureD
						;splashInfo( clX )
			Click %clX% %clY1%
			CornerNotify(1, " Brush Flow set to NO pen pressure ", "", "r hc", 0)
		}else{
			clX1 := pressFlow.sizeDropDownX
			clY1 := pressFlow.penPressureD
						;splashInfo( clX )
			Click %clX% %clY1%		
			CornerNotify(1, " Brush Flow set to PEN PRESSURE ", "", "r hc", 0)	
		}

		MouseMove, xpos, ypos, mSpeed  
		BlockInput, Off
	}
	Send {Ctrl}{Alt}
	Return
}



;shift + alt + p
#IfWinActive, ahk_exe Substance Painter.exe
+!p::
{
	toPerformAfterInfoGet := "setChannelsToPassthrough"
	getInfoFromPainter( )

	Return
}


;` do a shelf search
#IfWinActive, ahk_exe Substance Painter.exe
!1::
{
	Fileread, searches, searches.json
	searchesObj := Jxon_Load(searches)
	custWindow( "Shelf Predefined Searches" )
	Return
}


;alt` open the mask window`
#IfWinActive, ahk_exe Substance Painter.exe
`::
{
	
	Fileread, searches, masksButtons.json
	searchesObj := Jxon_Load(searches)
	custWindow( "Mask creattions")
	Return
}

;ctrl` open the filters window`
#IfWinActive, ahk_exe Substance Painter.exe
^`::
{
	
	Fileread, searches, filtersButtons.json
	searchesObj := Jxon_Load(searches)
	custWindow( "Filters creations")
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
	Fileread, searches, blendingModesButtons.json
	searchesObj := Jxon_Load(searches)
	custWindow( "Change Blending Mode")
	Return
}
sqFormat(){
	global precisionAdd
	SetFormat, float, 0.4
	return precisionAdd
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
	tx := {}
	ImageSearch, txFoundX, txFoundY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, %A_ScriptDir%\images\textSelected.png
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
	sTx := getTextsel()

	;cx := A_CaretY
	;;splashInfo( cx )
	sss := getWindowTest()
	if(sss.aClass = "Qt5QWindowPopupDropShadowSaveBits"){
		sss := getTheNumber(sss)
		if(sss.nbX){
		;splashInfo( sss.nbX)
			;BlockInput, On
			sx2 := sss.bRight - 5
			sy2 := sss.bTop + 3
			Click, %sx2% %sy2%
			setOpp(opps,0)
			sx1 := sss.nbX + 5 
			sy1 := sss.nbY - 5
			
			;splashInfo( sx1 . sy1)
			;Sleep, 100
			Click, %sx1% %sy1%
			Click, %sx1% %sy1%
			;Sleep, 1000
			Click, %sx2% %sy2%
			;BlockInput, Off
		}
	}else{
		;BlockInput, On
		setOpp(opps,0)
		sx := sTx.x
		sy := sTx.y
		Click, %sx% %sy%
		;BlockInput, Off
	}
}

#IfWinActive, ahk_exe Substance Painter.exe
Up::
{	
	accOp("add")
	Return	
}


#IfWinActive, ahk_exe Substance Painter.exe
Down::
{	
	accOp("minus")
	Return	
}

;alt + p open the filters window`
#IfWinActive, ahk_exe Substance Painter.exe
Left::
{
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


	Return
}
