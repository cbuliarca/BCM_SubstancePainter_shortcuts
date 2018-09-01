;create window


winEditShortcuts( sX, sY, sWW, stitle, contrl) {

	global winEditShortcuts_title, winEditShortcuts_hwnd
  global eVar0, eVar1, eVar2, eVar3, eVar4, eVar5, eVar6, eVar7, eVar8, eVar9,
  global eVar10, eVar11, eVar12, eVar13, eVar14, eVar15, eVar16, eVar17, eVar18, eVar19
  global eVar20, eVar21, eVar22, eVar23, eVar24, eVar25, eVar26, eVar27, eVar28, eVar29
  global eVar30, eVar31, eVar32, eVar33, eVar34, eVar35, eVar36, eVar37, eVar38, eVar39
  global eVar40, eVar41, eVar42, eVar43, eVar44, eVar45, eVar46, eVar47, eVar48, eVar49
  global eVar50, eVar51, eVar52, eVar53, eVar54, eVar55, eVar56, eVar57, eVar58, eVar59,
  global eVar60, eVar61, eVar62, eVar63, eVar64, eVar65, eVar66, eVar67, eVar68, eVar69,
  global eVar70, eVar71, eVar72, eVar73, eVar74, eVar75, eVar76, eVar77, eVar78, eVar79,
  global eVar80, eVar81, eVar82, eVar83, eVar84, eVar85, eVar86, eVar87, eVar88, eVar89,
  global eVar90, eVar91, eVar92, eVar93, eVar94, eVar95, eVar96, eVar97, eVar98, eVar99,
  global eVar100, eVar101, eVar102, eVar103, eVar104, eVar105, eVar106, eVar107, eVar108, eVar109,
  global eVar110, eVar111, eVar112, eVar113, eVar114, eVar115, eVar116, eVar117, eVar118, eVar119,
  global eVar120, eVar121, eVar122, eVar123, eVar124, eVar125, eVar126, eVar127, eVar128, eVar129,
  global eVar130, eVar131, eVar132, eVar133, eVar134, eVar135, eVar136, eVar137, eVar138, eVar139,
  global eVar140, eVar141, eVar142, eVar143, eVar144, eVar145, eVar146, eVar147, eVar148, eVar149,
  global eVar150, eVar151, eVar152, eVar153, eVar154, eVar155, eVar156, eVar157, eVar158, eVar159,
  global eVar160, eVar161, eVar162, eVar163, eVar164, eVar165, eVar166, eVar167, eVar168, eVar169,
  global eVar170, eVar171, eVar172, eVar173, eVar174, eVar175, eVar176, eVar177, eVar178, eVar179,
  global eVar180, eVar181, eVar182, eVar183, eVar184, eVar185, eVar186, eVar187, eVar188, eVar189,
  global eVar190, eVar191, eVar192, eVar193, eVar194, eVar195, eVar196, eVar197, eVar198, eVar199,
  global eVar200, eVar201, eVar202, eVar203, eVar204, eVar205, eVar206, eVar207, eVar208, eVar209,
  global eVar210, eVar211, eVar212, eVar213, eVar214, eVar215, eVar216, eVar217, eVar218, eVar219,
  global eVar220, eVar221, eVar222, eVar223, eVar224, eVar225, eVar226, eVar227, eVar228, eVar229,

  global searchesObj, EditShortEnterBtn, EditShortDeleteBtn, aCommands, aa, sW, currentCtrl
  global eButName, eShortcut, eCommand, btnObjG, eTitle
  winEditShortcuts_Destroy() ; make sure an old instance isn't still running or fading out

  currentCtrl := contrl.btToEdit
  btnObjG := contrl
  
  sW := sWW
  ;Gui, bcmOptWin:+AlwaysOnTop -ToolWindow -SysMenu -Caption +LastFound
  Gui, bcmOptWin:+AlwaysOnTop +LastFound
	winEditShortcuts_hwnd := WinExist()
	WinSet, Transparent, 230
	Gui, bcmOptWin:Color, ffffff ;background color

  ;:the title
  Gui, bcmOptWin:Font, 151515 s10 wbold, Arial
  Gui, bcmOptWin: Add, Text, Center x0 y5 w%sW% veTitle, %stitle%


  if(aCommands.avilableCommands){

  }else{

    Fileread, commands, commands.json
    aCommands := Jxon_Load(commands)
  }

  if(stitle = "Edit shortcut")
  {
    Gui, bcmOptWin: Add, Button, x0 y25 w%sW% h30 -TabStop vEditShortDeleteBtn gDeleteEditShortcuts, Delete this Button
    eY := 40
  
  }else{
    eY := 20
  }

  spY := 25
  ;eY := 10
  if(contrl.name){
    cName := contrl.name
    shName := contrl.shortcut
    cmdName := contrl.command
  }else{
    cName := ""
    shName := ""
    cmdName := ""
  }

  txW := 100
  eX := txW + 5
  eW := sW - txW - 10
  ey := ey + spY
  Gui, bcmOptWin: Add, Text, Left x5 y%eY% w%txW%, Button Name
  Gui, bcmOptWin: Add, Edit, x%eX% y%eY% w%eW% veButName, %cName%


  ey := ey + spY
  Gui, bcmOptWin: Add, Text, Left x5 y%eY% w%txW%, Shortcut
  Gui, bcmOptWin: Add, Hotkey, x%eX% y%eY% w%eW% veShortcut gCheckHotkey, %shName%




  aComs := ""
  aCC := aCommands.avilableCommands
  for ka, va in aCC
  {
    aComs := aComs . aCC[ka].command . "|"
    if(aCC[ka].command = cmdName){
        aComs := aComs . "|"
        opt := aCC[ka].options
      } 
  }

  ey := ey + spY
  Gui, bcmOptWin: Add, Text, Left x5 y%eY% w%txW%, Command
  Gui, bcmOptWin: Add, DropDownList, x%eX% y%eY% w%eW% gCommandChanged veCommand, %aComs%




  ey := ey + spY
  Gui, bcmOptWin: Add, Text, Left x5 y%eY% w%txW%, Options:

  ;splashInfo(ey)

  aa := 0
  for k,v in opt{
      
    if(v = "Boolean"){
      bolOpts := "True|"
      noP := 1
      for kc, vc in contrl{
        if(kc = k){
            if( vc = "True"){
              bolOpts := bolOpts . "|False"
            }else{
              bolOpts := bolOpts . "False||"
            }
            noP := 0
            break
        }
      }
      if (noP = 1)
      {
            bolOpts := bolOpts . "|False"
      }

    ey := ey + spY
    Gui, bcmOptWin: Add, Text, Center x5 y%eY% w%txW% veVar%aa%, %k%
    aa := aa + 1
    Gui, bcmOptWin: Add, DropDownList, x%eX% y%eY% w%eW% veVar%aa%, %bolOpts%
    

    }else if(v = "String"){
      strOpts := ""
      for kc, vc in contrl{
        if(kc = k){
          strOpts := vc
          break
        }
      }

      ey := ey + spY
      Gui, bcmOptWin: Add, Text, Center x5 y%eY% w%txW% veVar%aa%, %k%
      aa := aa + 1
      Gui, bcmOptWin: Add, Edit, x%eX% y%eY% w%eW% veVar%aa%, %strOpts%


    }else if(v = "Integer"){
      intOpts := ""
      for kc, vc in contrl{
        if(kc = k){
          intOpts := vc
          break
        }
      }
      ey := ey + spY
      Gui, bcmOptWin: Add, Text, Center x5 y%eY% w%txW% veVar%aa%, %k%
      aa := aa + 1
      Gui, bcmOptWin: Add, Edit, Number x%eX% y%eY% w%eW% veVar%aa%, %intOpts%


    }else{
      drOpts := ""
      drOppp := v
      ds := ""
      noPP := 1
      for kc, vc in contrl{
        if(kc = k){
          ds := vc
          noPP := 0
          break
          }
      }

      noPA := 1
      for kk,vk in drOppp
      {
        drOpts := drOpts . vk . "|"
        if( noPP = 1){
          if(kk = 1){
            drOpts := drOpts . "|"
          }
        }else{
          ;splashInfo( vk . "::" . ds )
          if( vk = ds ){
            drOpts := drOpts . "|"
            noPA := 0
          }
        }
      }

      if(noPA = 1){
        drOpts := drOpts . "|"
      }
      ;splashInfo( drOpts)
      ey := ey + spY
      Gui, bcmOptWin: Add, Text, Center x5 y%eY% w%txW% veVar%aa%, %k%
      aa := aa + 1
      Gui, bcmOptWin: Add, DropDownList, x%eX% y%eY% w%eW% veVar%aa%, %drOpts%
    }
    aa := aa + 1
  }

  
  Gui, bcmOptWin: Add, Button, x0 w%sW% h40 -TabStop default vEditShortEnterBtn gSaveEditShortcuts, Apply
  Gui, bcmOptWin:Show, W%sW% x%sX% y%sY%
  WinActivate, winEditShortcuts_hwnd

	Return
}


winEditShortcuts_Destroy() {
	curtranspSS := 0
  kr := 1
	Gui, bcmOptWin:Destroy
}

CheckHotkey:
{
  checkExistentHotkey()
  Return
}


DeleteEditShortcuts:
{
  bStr := getCurrentSettings()
  changeSearchesObj( bStr, "delete")
  winEditShortcuts_Destroy()
  Sleep 100
  Return
}

SaveEditShortcuts:
{
  bStr := getCurrentSettings()
  changeSearchesObj( bStr, "add")
  ;btntext := ">> " . bStr.shortcut . " << " . bStr.name
  ;GuiControl, 2:, %currentCtrl%, %btntext%
  winEditShortcuts_Destroy()
  Sleep 100
  Return
}

CommandChanged:
{
  ;splashInfo( A_GuiControl )
  ;splashInfo( aa )
  ;hide existent controls
  bb := 0
  while 1{
    GuiControl, Hide, eVar%bb%
    if(bb = aa){
      break
    }
    bb := bb + 1
  }

  addDefaultOptions( A_GuiControl )

  Return
}

checkExistentHotkey(){
  global searchesObj, btnObjG
  GuiControlGet, eQQShortcut, , eShortcut
  GuiControlGet, eQQName, , eButName
  for k, v in searchesObj.buttonsA{
    if( v.shortcut = eQQShortcut){
      CornerNotify(1, "!!! You can't use this shortcut.There is already a button with this shortcut !!!", "", "r hc", 1)
      if(btnObjG.shortcut){
          sc := btnObjG.shortcut
          GuiControl, bcmOptWin:, eShortcut, %sc%
        }else{
          GuiControl, bcmOptWin:, eShortcut, 
        }
    }
  }
}


changeSearchesObj( bStr, action ){
  global searchesObj, btnObjG, openedFile, winSerTitle

  oldBtnName := btnObjG.name
  GuiControlGet, editTitle, , eTitle
  if( editTitle = "Create shortcut"){
    qk := 1
    For k, v in searchesObj.buttonsA{
      qk := qk + 1
    }
    searchesObj.buttonsA[qk] := bStr

  }else{
    For k, v in searchesObj.buttonsA{
      if( v.name = oldBtnName){
        if( action = "delete" ){
            searchesObj.buttonsA.remove(k, "")
          }else{
            searchesObj.buttonsA[k] := bStr
          }
        break
      }
    }
  }
  jStr := Jxon_Dump( searchesObj, "`t")
  FileDelete, %openedFile%
  FileAppend, %jStr% , %openedFile%

  Gui, 2:Destroy

  Fileread, searches, %openedFile%
  searchesObj := Jxon_Load(searches)
  custWindow( winSerTitle, openedFile )

  Return
}


getCurrentSettings(){
  global aa, winEditShortcuts_hwnd
  tr := {}
  GuiControlGet, eCShortcut, , eShortcut
  GuiControlGet, eCButName, , eButName
  GuiControlGet, eCCommand, , eCommand
  if(eCButName = "")
  {
    eCButName := "."
  }
  tr.shortcut := eCShortcut
  tr.name := eCButName
  tr.command := eCCommand

  ;MsgBox, %aa%
  qs := aa - 1
  while 1{

    if(qs < 0){
      Break
    }else{
      GuiControlGet, eVisQs, Visible , eVar%qs%
      if(eVisQs = 0){
        Break
      }else{
        GuiControlGet, eQSVal, , eVar%qs%
        GuiControlGet, eQSHwnd, Hwnd , eVar%qs%
        ControlGet, eQsStyle, Style,, %eQSVal%, ahk_id %winEditShortcuts_hwnd%
        if(eQsStyle = 0x50012080){
          ;it's a number
          ;splashInfo( eQSVal . " ||| " . eQsStyle)
          eQSVal := 0 + eQSVal
        }
        qs := qs - 1 
        GuiControlGet, eQS, , eVar%qs%
        ;splashInfo( qs . "|||" . eQs . " :: " . eQSVal )
        tr[eQs] := eQSVal
      }
    }
    qs := qs - 1 
  }

  
  Return tr
}


addDefaultOptions( comm ){
  GuiControlGet, comm, , %comm%
  global aa, aCommands, sW, winEditShortcuts_hwnd, EditShortEnterBtn
  ;search the selected command and get it's options
  aCC := aCommands.avilableCommands
  for ka, va in aCC
  {
    if(aCC[ka].command = comm){
        opt := aCC[ka].options
      } 
  }


  spY := 30
  eY := 130
  txW := 100
  eX := txW + 5
  eW := sW - txW - 10
  ;ey := ey + spY


  ; add the new controls a defaults
  for k,v in opt{
      
    if(v = "Boolean"){
      bolOpts := "True||False"

      ey := ey + spY
      Gui, bcmOptWin: Add, Text, Center x5 y%eY% w%txW% veVar%aa%, %k%
      aa := aa + 1
      Gui, bcmOptWin: Add, DropDownList, x%eX% y%eY% w%eW% veVar%aa%, %bolOpts%
    

    }else if(v = "String"){
      strOpts := ""

      ey := ey + spY
      Gui, bcmOptWin: Add, Text, Center x5 y%eY% w%txW% veVar%aa%, %k%
      aa := aa + 1
      Gui, bcmOptWin: Add, Edit, x%eX% y%eY% w%eW% veVar%aa%, %strOpts%


    }else if(v = "Integer"){
      intOpts := 1

      ey := ey + spY
      Gui, bcmOptWin: Add, Text, Center x5 y%eY% w%txW% veVar%aa%, %k%
      aa := aa + 1
      Gui, bcmOptWin: Add, Edit, Number x%eX% y%eY% w%eW% veVar%aa%, %intOpts%


    }else{
      drOpts := ""
      drOppp := v

      for kk,vk in drOppp
      {
        drOpts := drOpts . vk . "|"
          if(kk = 1){
            drOpts := drOpts . "|"
        }
      }

      ;splashInfo( drOpts)
      ey := ey + spY
      Gui, bcmOptWin: Add, Text, Center x5 y%eY% w%txW% veVar%aa%, %k%
      aa := aa + 1
      Gui, bcmOptWin: Add, DropDownList, x%eX% y%eY% w%eW% veVar%aa%, %drOpts%
    }
    aa := aa + 1
  }

  WinGetPos, ix,iy,w,h, ahk_id %winEditShortcuts_hwnd%

  ey := ey + spY + 10
  eye := ey + 60
  if( eye > h){
    GuiControl, Move, EditShortEnterBtn, y%ey%
    ey := ey + 60
    WinMove, ahk_id %winEditShortcuts_hwnd%,,ix,iy,w,ey
  }
  ;splashInfo(h)

}