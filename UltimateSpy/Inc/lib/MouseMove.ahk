#Requires Autohotkey v2.0+
checkMouseMove(a,b,c,Win){
	static LastControl := 0,LastAncestor := ""
	if(a="Control")
		return LastControl
	MouseGetPos(,,&window)
	if(Window=sGui.hwnd or !Window)
		return
	if(Moving){
		DllCall("SetCursor","Ptr",hCrossHair,"Ptr")
		MouseGetPos(,,&win,&Control,2)
		Ancestor:=GetAncestor(Control)
		if(Ancestor!=LastAncestor&&Ancestor){
			;GuiControl,-Redraw,SysTreeView321
			TV.Opt('-redraw')
			Title := WinGetTitle('ahk_id ' Win)
			Class := WinGetClass('ahk_id ' Win)
			TV.Delete(),TreeIDs:=[]
			Tree(Win,TV.Add(Title,,"Icon" GetWindowIcon(Ancestor,Class)))
			DllCall("SetCapture","Ptr",sGui.hwnd)
			TV.Opt('+redraw')
		}
		if(Ancestor)
			LastAncestor:=Ancestor
		if(Control!=LastControl&&Control){
			MouseGetPos(,,&Win,&ClassNN)
			ShowBorder(Control,'Flash')
			Title := WinGetTitle('ahk_id ' Win)
			Text := ControlGetText(Control,'ahk_id ' win)
			EXE := ProcessGetName(WinGetPID('ahk_id ' win))
			Class := WinGetClass('ahk_id ' Win)
			ClassNN:=InStr(ClassNN,"ComboLBox")?RegExReplace(ClassNN,"i)ComboLBox","Combobox"):ClassNN

			postMap := Map(
				ClassNN, 'EdtClassNN',
				Text,'EdtText',
				;"0x" Format("{:x}",Control),'HWNDHWND',				
				; Title,TitleHWND
				(Title "`r`nahk_class " Class "`r`nahk_exe " EXE),'EdtClass'
			)
			for a,b in postMap
				sGui[b].value := a
			
			;for a,b in {(ClassNN):ClassNNHWND,(Text):TextHWND,"0x" Format("{:x}",Control):HWNDHWND,(TitleHWND):Title,(Title "`r`nahk_class " Class "`r`nahk_exe " EXE):ParentHWND}
				;ControlSetText,,%a%,ahk_id%b%

			; for a,b in TreeIDs{
			; 	if(b=Control){
			; 		TV.Modify(a,"Select Vis Focus")
			; 		Break
			; 	}
			; }
		}
		LastControl:=Control
	}
}