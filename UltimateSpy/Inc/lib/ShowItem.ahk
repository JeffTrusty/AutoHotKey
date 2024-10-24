#Requires Autohotkey v2.0+
ShowItem(obj,info){
	x := TV.GetSelection()
	if !TreeIDs.Has(x)
		return
	Control:=TreeIDs[x]
	;if(A_GuiEvent~="i)(S|Normal)"&&Control){
		ShowBorder(Control,"Flash")
		Win:=GetAncestor(Control)
		if !Win
			return
		Title := WinGetTitle('ahk_id ' Win)
		Text := ControlGetText(Control,'ahk_id ' win)
		EXE := ProcessGetName(WinGetPID('ahk_id ' win))
		Class := WinGetClass('ahk_id ' Win)


		ClassNN:=Control_GetClassNN(Win,Control)
		charbuff := Buffer(256,0)  ; VarSetCapacity( charbuff, 256, 0 )
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

		; for a,b in {(ClassNN):ClassNNHWND,(Text):TextHWND,"0x" Format("{:x}",Control):HWNDHWND,(TitleHWND):Title,(Title "`r`nahk_class " Class "`r`nahk_exe " EXE):ParentHWND}
		; 	ControlSetText,,%a%,ahk_id%b%
	;}
	
}