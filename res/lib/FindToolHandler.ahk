#Requires Autohotkey v2.0+
FindToolHandler(*){
	Global Moving
	OnMessage(0x202,LButtonUp)
	DllCall("SetCapture","Ptr",sGui.hwnd)
	hOldCursor:=DllCall("SetCursor","Ptr",hCrossHair)
	;GuiControl,,Static1,%Bitmap2%
    watch.Value := Bitmap2
	Moving:=1
}