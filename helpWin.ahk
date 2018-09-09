bcm_helpWin(){
	global WB

	Gui, qAHelp:Destroy
	Gui, qAHelp:+AlwaysOnTop +LastFound
	winEditMM_hwnd := WinExist()
	;WinSet, Transparent, 230
	Gui, qAHelp:Color, 2c2c2c ;background color


;	textHelpString=
;	(
;Scripts for Substance Painter 2018 that automaticaly moves your mouse. 
;It's searching for some image patterns on the screen and it's trying to find the options.


;Features so far:


   	




;The default shorcuts list:
;for the moment you can't change these:
;	)
	

;	textHelpStringFeatures1=
;	(
;.toggle pressure for size and flow
;.set Alignment for brush to UV or Tnagent|Wrap
;.custom predefined searches into the Shelf 
;	with these you can quickliy acces some favorites tools or brushes
;.quckly create some favorites effects like: Blur or Sharpen....
;.all these options can be accesd by marking Menus or windows with shortcuts
;.increment slider
;	)


;	textHelpStringshortcuts=
;	(
;Ctrl + Alt + A  		toogle pressure for Flow
;Ctrl + Alt + S  		toogle pressure for Size

;Alt + Left Arrow 	incremnet slider's value by a custom set value
;Alt + Right Arrow  	decrease slider's value by a custom set value
;Alt + Shift + Left Arrow 	set custom value for the increment

;Alt + ]  			select upper layer stack
;Alt + [  			select lower layer stack

;Alt + F1 		toogle docked "Textures Sets"
;Alt + F2 		toogle docked "TextureSetsSettings"
;Alt + F3 		toogle docked "DisplaySettings"
;Alt + F4 		toogle docked "ShaderSettings"
;Alt + F5 		toogle docked "Properties"

;Middle Mouse: 		PIE MENUS: 
;			Each Pie menu can be accesed by pressing 
;			it's shortcut and the Middle Mouse
;			You can change the keys for the Pie 
;			Menus by Right Clicking on the Tray Icon Menu 
;			and chose Edit Pie Menus.
;			Don't worry if the shortcuts for the Pie 
;			Menius are the same as the ones in S.Painter
;			They will still work in S.Painter but on the
;			release of the key. 
;			You can customize each marking menu by adding
;			buttons like with the shortcuts window

;`` 			WINDOW WITH SHORTCUTS:
;			With this window opened you can press any of 
;			the shortcuts you see on the upper part of the
;			button between the >> <<, and that action will 
;			happen. 
;			With Right Clik on one button you can change
;			that shortcut.
;			To add another shortcut Right Click on the 
;			black area.

;Alt + `			the blendings shortcuts window

;Ctrl + `			the filters window

;Alt + 1			some shelf searches window

;	)

;	textHelpStringshortcutsBold=
;(
;Ctrl + Alt + A  		
;Ctrl + Alt + S  		

;Alt + Left Arrow 	
;Alt + Right Arrow  	
;Alt + Shift + Left  	 

;Alt + ]  			
;Alt + [  			

;Alt + F1 		
;Alt + F2 		
;Alt + F3 		
;Alt + F4 		
;Alt + F5 		

;Middle Mouse: 	
			
			
			
			
			
			
			
			
			
			


;`` 		
		
		
		
		
		
		
		
		

;Alt + ``	

;Ctrl + ``

;Alt + 1
;)
;	;MsgBox % ">" textHelpString "<" 

;	Gui, qAHelp:Font, c151515 s9 wbold, Arial
;	Gui, qAHelp:Add, Text, Center x5 y5 w500, %textHelpString%
;	Gui, qAHelp:Font, c151515 s8 wnormal, Arial
;	Gui, qAHelp:Add, Text, Left x50 y80 w400, %textHelpStringFeatures1%
;	Gui, qAHelp:Add, Text, Left x100 y220 w400, %textHelpStringshortcuts%
;	Gui, qAHelp:Font, c151515 s8 wbold, Arial
;	Gui, qAHelp:Add, Text, Left x100 y220 w118, %textHelpStringshortcutsBold%

;	Gui, qAHelp:Font, c151515 s8 wnormal, Arial
;	Gui, qAHelp:Add, Button, x5 w530 y35 Center gHelpGoToVideo, You can check this video as well

	Gui qAHelp:Add, ActiveX, w980 h640 vWB, Shell.Explorer  ; The final parameter is the name of the ActiveX component.
	WB.Navigate(A_ScriptDir . "\help\help.html")  ; This is specific to the web browser control.
	Gui, qAHelp:Show, Center
  	WinActivate, winEditMM_hwnd
}

HelpGoToVideo:
{
	Run, https://www.youtube.com/watch?v=hW8mC2H5nAw&t=1s
}