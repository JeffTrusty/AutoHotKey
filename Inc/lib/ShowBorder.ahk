#Requires Autohotkey v2.0+
; The color attribute in the following line sets the color     0x3FBBE3
ShowBorder(Control,Duration:=500,r:=3) { 
	Local x,y,w,h
	static Window
	;MouseGetPos( ,, &hwnd, &Control,2)
	;CHwnd := ControlGetHwnd(Control,'ahk_id ' hwnd)
	try WinGetPos &x, &y, &w, &h, 'ahk_id ' Control
	
	if !isset(w) 
	||!w
		Return
	for a,b in Window:=[[91,x-r,y-r,w+r,r],[92,x-r,y+h,w+r,r],[93,x-r,y,r,h],[94,x+w,y,r,h]]
		Borders[a_index].Show("NA x" b[2] " y" b[3] " w" b[4] " h" b[5])
	SetTimer Flash,-1
	 if(Duration!=-1&&Duration!="Flash"){
			SetTimer Flash, 0
			sleep Duration
			intiBorder(1)
	 }else if(Duration="Flash"){
	 	SetTimer Flash,-1
		; return
		; Flash:
		; while(A_Index<8){
		; 	Index:=A_Index
		; 	for a,b in Window{
		; 		Gui,% "+ToolWindow"
		; 		Gui,% b.1 ":" (Mod(Index,2)?"Show":"Hide"),NA
		; 	}
		; 	Sleep,150
		; }for a,b in Window
		; 	Gui,% b.1 ":Destroy"
		; return
	}
}

Flash()
{
	loop 4
	{
		if Mod(a_index,2)
			intiBorder(1)
		else
			intiBorder(0)
		Sleep 200
	}
}

intiBorder(status:=1)
{
	if status
	{
		loop 4
			Borders[a_index].Show()
	}
	else
	{
		loop 4
			Borders[a_index].Hide()
	}
}