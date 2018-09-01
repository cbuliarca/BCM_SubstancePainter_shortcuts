/*
	;Custom Progress Buttons By Hellbent aka CivReborn
	
	Date Started: May 31st, 2018
	Date of Last Edit: June 18th, 2018
	
	PasteBin Link: https://pastebin.com/XPcJMcqj
	
	Link To Video Tutorial: https://youtu.be/a2gmBUNYDgw
	
	Instructions to use:
	
	1: #Include this script in your script / **(or paste it in (not tested may have to move some things around))
	
	2: Call the pButton_StartUp() Function in your script
	
	3: Create New Buttons by First setting a global object Called "pButton"
		;pButton will be need to be an array of objects.
		
	4: Add your buttons by making your button a Progress_Button Class Object 
		; Example
			;(see video for arg meanings and take notes/ or look over code to see what is needed).
			; pButton[1]:= New Progress_Button(args). In this method use array position as the Button_Name. ie. 1 
		; Example 2
			; pButton.Push(New Progress_Button(args)). In this method, use pButton.Length()+1 as the Button_Name
	
	5:  Add the Button_Press() Method to any lable that is using a Progress_Button Class Button.
		;set it in a if statement to test if the statement returns a true or false
		
		;Example
			;if(!pButton[A_GuiControl].Button_Press())
				return
			; your code that you want the button to do comes after the if statement
			; See video if you get stuck.
			
		;Full Example
			;-----------------------------------
			My_Label:
				if(!pButton[A_GuiControl].Button_Press())
					return
				a:=5
				b:=6
				c:=a+b
				msgbox,% c
				return
			;---------------------------------------			
*/






           ; Button Class
;------------------------------------------------------------------------------------------------
;------------------------------------------------------------------------------------------------
;------------------------------------------------------------------------------------------------
global Press_active:=0,Hover_On:=0,Active_Button






pButton_StartUp(){
	SetTimer,Watch_Hover,10
}	
Watch_Hover(){
	global
	if(Press_active=0){
		if(Hover_On=0){
			MouseGetPos,,,,ctrl,2
			loop,% pButton.Length()	{
				GuiControlGet,cName,% pButton[A_Index].Window_Name ":Name",% ctrl
				cut:=Strlen(cName)
				StringLeft,bName,cName,cut-2
				;~ Loop,% pButton.Length()
					if(bname=pButton[A_Index].Button_Name){
						pButton[A_Index].Button_Hover_On()
						Hover_On:=1,Active_Button:=bname,win:=pButton[A_Index].Window_Name
						return
					}	
			}
		}else if(Hover_On=1){
			MouseGetPos,,,,ctrl,2
			GuiControlGet,cName,%win%:Name,% ctrl
			cut:=Strlen(cName)
			StringLeft,nBName,cName,cut-2
			if(NbName!=Active_Button){
				pButton[Active_Button].Button_Hover_Off()
					Hover_On:=0,Active_Button:=""
			}
		}
	}			
}

Class Progress_Button	{
		__New(Window_Name,Button_Name,Label,x,y,w,h,BC,TRC,TC1,TC2,TC3,Button_Text,Text_Offset:=0)
			{
				This.Text_Offset:=Text_Offset
				This.Window_Name:=Window_Name
				This.Button_Name:=Button_Name
				This.Label:=Label
				This.Button_ID1:=Button_Name "_1"
				This.Button_ID2:=Button_Name "_2"
				This.Button_ID3:=Button_Name "_3"
				This.Button_ID4:=Button_Name "_4"
				This.Button_Text:=Button_Text
				This.X:=x
				This.Y:=y 
				This.W:=w 
				This.H:=h 
				This.Bottom_Color:=BC
				This.Trim_Color:=TRC
				This.Top_Color_1:=TC1
				This.Top_Color_2:=TC2
				This.Top_Color_3:=TC3
				This.Add_Button()
			}
		Add_Button()
			{
				global
				Gui,% This.Window_Name ":Add",Text,% "x" This.X " y" This.Y " w" This.W " h" This.H " v" This.Button_Name " g" This.Label
				Gui,% This.Window_Name ":Add",Progress,% "x" This.X " y" This.Y " w" This.W " h" This.H " Background" This.Bottom_Color " v" This.Button_ID1
				Gui,% This.Window_Name ":Add",Progress,% "x" This.X " y" This.Y " w" This.W-1 " h" This.H-1 " Background" This.Trim_Color " v" This.Button_ID2
				Gui,% This.Window_Name ":Add",Progress,% "x" This.X+1 " y" This.Y+1 " w" This.W-2 " h" This.H-2 " Background" This.Top_Color_1 " v" This.Button_ID3
				Gui,% This.Window_Name ":Add",Text,% "x" This.X+1 " y" This.Y+This.Text_Offset " w" This.W-2 " r1 Center BackgroundTrans v" This.Button_ID4,% This.Button_Text
			}
		Button_Press()
			{
				global 
				Press_Active:=1
				GuiControl,% This.Window_Name ":Move",% This.Button_ID4,% "x" This.X+1 " y" This.Y+1+This.Text_Offset
				sleep,-1
				GuiControl,% This.Window_Name ":Hide",This.Button_ID2
				GuiControl,% This.Window_Name ":+Background" This.Top_Color_3,% This.Button_ID3
				GuiControl,% This.Window_Name ":+Redraw",% This.Button_ID1
				GuiControl,% This.Window_Name ":+Redraw",% This.Button_ID3
				GuiControl,% This.Window_Name ":+Redraw",% This.Button_ID4
				While(GetKeyState("LButton"))
					Sleep, 10
				MouseGetPos,,,,ctrl,2
				GuiControlGet,cName,% win ":Name",% ctrl
				cut:=Strlen(cName)
				StringLeft,bName,cName,cut-2
				if(bname=This.Button_Name)
					{
						GuiControl,% This.Window_Name ":Show",This.Button_ID2
						GuiControl,% This.Window_Name ":+Background" This.Top_Color_1,% This.Button_ID3
						GuiControl,% This.Window_Name ":+Redraw",% This.Button_ID1
						GuiControl,% This.Window_Name ":+Redraw",% This.Button_ID2
						GuiControl,% This.Window_Name ":+Redraw",% This.Button_ID3
						GuiControl,% This.Window_Name ":Move",% This.Button_ID4,% "x" This.X " y" This.Y+This.Text_Offset
						GuiControl,% This.Window_Name ":+Redraw",% This.Button_ID4
						%bName%.Button_Hover_On()
						Hover_On:=0
						Active_Button:=bname
						Press_Active:=0
						sleep,10
						return true
					}
				GuiControl,% This.Window_Name ":Show",This.Button_ID2
				GuiControl,% This.Window_Name ":Move",% This.Button_ID4,% "x" This.X " y" This.Y+This.Text_Offset
				GuiControl,% This.Window_Name ":+Background" This.Top_Color_1,% This.Button_ID3
				GuiControl,% This.Window_Name ":+Redraw",% This.Button_ID1
				GuiControl,% This.Window_Name ":+Redraw",% This.Button_ID2
				GuiControl,% This.Window_Name ":+Redraw",% This.Button_ID3
				GuiControl,% This.Window_Name ":+Redraw",% This.Button_ID4
				Hover_On:=0
				Press_Active:=0
				sleep,10
				return False
			}
		Button_Hover_On(){
			global 
			GuiControl,% This.Window_Name ":+Background" This.Top_Color_2,% This.Button_ID3
			GuiControl,% This.Window_Name ":+Redraw",% This.Button_ID4
		}
		Button_Hover_Off()
			{
				global 
				GuiControl,% This.Window_Name ":+Background" This.Top_Color_1,% This.Button_ID3
				GuiControl,% This.Window_Name ":+Redraw",% This.Button_ID4
			}
		Set_Text( str )
			{
				global 
				GuiControl,% This.Window_Name ":Text",% This.Button_ID4, %str%
				GuiControl,% This.Window_Name ":+Redraw",% This.Button_ID4
			}
	}