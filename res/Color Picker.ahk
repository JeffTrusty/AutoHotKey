#SingleInstance, Force

Colors := {"Red": ["FF9999","FF6666","FF3333","FF0000","D90000","B20000","8C0000","660000","400000"], "Flame": ["FFB299","FF8C66","FF6633","FF4000","D93600","B22D00","8C2300","661A00","401000"], "Orange": ["FFCC99","FFB266","FF9933","FF8000","D96C00","B25900","8C4600","663300","402000"], "Amber": ["FFE599","FFD966","FFCC33","FFBF00","D9A300","B28600","8C6900","664D00","403000"], "Yellow": ["FFFF99","FFFF66","FFFF33","FFFF00","D9D900","B2B200","8C8C00","666600","404000"], "Lime": ["E5FF99","D9FF66","CCFF33","BFFF00","A3D900","86B200","698C00","4D6600","304000"], "Chartreuse": ["CCFF99","B2FF66","99FF33","80FF00","6CD900","59B200","468C00","336600","204000"], "Green": ["99FF99","66FF66","33FF33","00FF00","00D900","00B200","008C00","006600","004000"], "Sea": ["99FFCC","66FFB2","33FF99","00FF80","00D96C","00B259","008C46","006633","004020"], "Turquoise": [ "99FFE5","66FFD9","33FFCC","00FFBF","00D9A3","00B286","008C69","00664D","004030"], "Cyan": ["99FFFF","66FFFF","33FFFF","00FFFF","00D9D9","00B2B2","008C8C","006666","004040"], "Sky": ["99E5FF","66D9FF","33CCFF","00BFFF","00A3D9","0086B2","00698C","004D66","003040"], "Azure": ["99CCFF","66B2FF","3399FF","0080FF","006CD9","0059B2","00468C","003366","002040"], "Blue": ["9999FF","6666FF","3333FF","0000FF","0000D9","0000B2","00008C","000066","000040"], "Han": ["B299FF","8C66FF","6633FF","4000FF","3600D9","2D00B2","23008C","1A0066","100040"], "Violet": ["CC99FF","B266FF","9933FF","8000FF","6C00D9","5900B2","46008C","330066","200040"], "Purple": ["E599FF","D966FF","CC33FF","BF00FF","A300D9","8600B2","69008C","4D0066","300040"], "Fuchsia": ["FF99FF","FF66FF","FF33FF","FF00FF","D900D9","B200B2","8C008C","660066","400040"], "Magenta": ["FF99E5","FF66D9","FF33CC","FF00BF","D900A3","B20086","8C0069","66004D","400030"], "Pink": ["FF99CC","FF66B2","FF3399","FF0080","D9006C","B20059","8C0046","660033","400020"], "Crimson": ["FF99B2","FF668C","FF3366","FF0040","D90036","B2002D","8C0023","66001A","400010"], "Gray": ["DEDEDE","BFBFBF","9E9E9E","808080","666666","4D4D4D","333333","1A1A1A","000000"], "Sepia": ["DED3C3","BFAB8F","9E8664","806640","665233","4D3D26","33291A","1A140D","000000"]}

ColorList := ["Red","Flame","Orange","Amber","Yellow","Lime","Chartreuse","Green","Sea","Turquoise","Cyan","Sky","Azure","Blue","Han","Violet","Purple","Fuchsia","Magenta","Pink","Crimson","Gray","Sepia"]

Gui, ColorPalette: +LastFound -Resize +HWNDhColorPalette -MinimizeBox
Gui, ColorPalette: Margin, 0, 0
Gui, ColorPalette: Color, 000000

For RowNum, ColorName In ColorList {
	For ColNum, ColorHex In Colors[ColorName] {
		Gui, ColorPalette: Add, Text, % "x" (24 * ColNum) - 24 " y" (24 * RowNum) - 24 " w" 24 " h" 24 " +0x4E +HWNDhColor" A_Index, % ColorName " - #" ColorHex
		CtlColor(ColorHex, hColor%A_Index%)
	}
}

Gui, ColorPalette:Add, StatusBar,, click to copy the color
Gui, ColorPalette: Show, AutoSize, Color Palette
return

GuiEscape:
ColorPaletteGuiClose:
exitapp
return

ButtonHandler() {
	Global ; Assume-global mode

	MouseGetPos,,,, ButtonCtl, 2
	Gui, ColorPalette: Show
}

WM_MOUSEMOVE(wParam, lParam, Msg, Hwnd) {
	Global ; Assume-global mode
	Static Init := OnMessage(0x0200, "WM_MOUSEMOVE")

	If (Hwnd = hColorPalette) {
		VarSetCapacity(TME, 16, 0)
		NumPut(16, TME, 0)
		NumPut(2, TME, 4) ; TME_LEAVE
		NumPut(hColorPalette, TME, 8)
		DllCall("User32.dll\TrackMouseEvent", "UInt", &TME)

		MouseGetPos,,,, MouseCtl
		GuiControlGet, ColorVal,, % MouseCtl
		ToolTip, % ColorVal
	} Else {
		ToolTip
	}
}

WM_MOUSELEAVE(wParam, lParam, Msg, Hwnd) {
	Global ; Assume-global mode
	Static Init := OnMessage(0x02A3, "WM_MOUSELEAVE")
	ToolTip
}

WM_LBUTTONDOWN(wParam, lParam, Msg, Hwnd) {
	Global ; Assume-global mode
	Static Init := OnMessage(0x0201, "WM_LBUTTONDOWN")

	If (Hwnd = hColorPalette) {
		RegExMatch(ColorVal, "#(.*)", ClipColor)
		;Gui, ColorPalette: Hide
        Clipboard := ""
        tooltip 
		Clipboard := ClipColor1
		ClipWait 1
        SB_SetText("color copied: " ClipColor1)
		; If (ButtonCtl = hButton1) {
		; 	GuiControl, Main:, Edit1, % ClipColor1
		; } Else If (ButtonCtl = hButton2) {
		; 	GuiControl, Main:, Edit2, % ClipColor1
		; }
		ButtonCtl := ""
	}
}

CtlColor(Color, Handle) {
	Static CtlColorDB := {}

	If (CtlColorDB[Handle])
		hBM := CtlColorDB[Handle]
	Else {
		hBM := DllCall("Gdi32.dll\CreateBitmap", "Int", 1, "Int", 1, "UInt", 1, "UInt", 24, "Ptr", 0, "Ptr")
		hBM := DllCall("User32.dll\CopyImage", "Ptr", hBM, "UInt", 0, "Int", 0, "Int", 0, "UInt", 0x2008, "Ptr")
		CtlColorDB[Handle] := hBM
	}

	VarSetCapacity(BMBITS, 4, 0), Numput("0x" . Color, &BMBITS, 0, "UInt")
	DllCall("Gdi32.dll\SetBitmapBits", "Ptr", hBM, "UInt", 3, "Ptr", &BMBITS)
	DllCall("User32.dll\SendMessage", "Ptr", Handle, "UInt", 0x172, "Ptr", 0, "Ptr", hBM)
}