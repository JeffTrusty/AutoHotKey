#Requires Autohotkey v2.0+
LButtonUp(x*){
	Global Moving
	if(Moving){
		watch.Value := Bitmap1
		Moving:=0
		OnMessage(0x202,LButtonUp,0)
		DllCall("ReleaseCapture"),DllCall("SetCursor","Ptr",hOldCursor:=0)
		MouseGetPos(,,&hwnd, &Control,2)
		if IsProcessElevated(WinGetPID('ahk_id ' hwnd))
			sGui['Admincheck'].value := 'Admin Process Detected'
		else
			sGui['Admincheck'].value := ''

		if Control
		&& CheckWin32Control(ControlGetClassNN(Control))
			sGui['Win32'].Visible := false
		else
		{
			sGui['Win32'].Visible := true
			sGui['EdtClassNN'].value := ''
			sGui['EdtText'].value := ''
			sGui['EdtClass'].value := ''
			return
		}
			
		switch Control
		{
			Case sGui['TreeVis'].hwnd: TreeVis()
			Case sGui['BtnSetText'].hwnd: SetText()
			; Case sGui.hwnd:
			; 	; do nothing
			Default:
			if sGui.hwnd != hwnd
				ShowBorder(Control,1000) ;the 1000 is the duration of how long the Border stays visible

		}
		; if(sGui['TreeVis'].hwnd = Control)
		; 	TreeVis()
		; if(sGui['TreeVis'].hwnd = Control)
		; 	TreeVis()
		; else if sGui.hwnd != hwnd
			
	}
} ;*[LButtonUp]
