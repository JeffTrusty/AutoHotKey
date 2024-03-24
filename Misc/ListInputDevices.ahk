;
; AutoHotkey "Raw Input" listing and capture
; You can get the latest version of this file at:
; https://gist.github.com/TheZoc/4bf163aa9a9922b21fbf
;
;==========================================================================================================================================
; Please, if you make a significant change, fix or would like to improve this script,
; I'd really appreciate if you can contact me so we can merge both works :)
;==========================================================================================================================================
;
; The original code can be found on the link:
; http://www.autohotkey.com/board/topic/36304-hidextended-input-devices-ms-natural-keyboard-4000-etc/
;
;==========================================================================================================================================
;
; List all of the "Raw Input" devices available for use and allow
; capture of output
;
; There may be more than one 'raw' device per device actually attached
; to the system. This is because these devices generally represent
; "HID Collections", and there may be more than one HID collection per
; USB device. For example, the Natural Keyboard 4000 supports a normal
; keyboard HID collection, plus an additional HID collection that can
; be used for the zoom slider and other important buttons
;


; Replace any previous instance
#SingleInstance force

DetectHiddenWindows, on
OnMessage(0x00FF, "InputMessage")

SizeofRawInputDeviceList	:= A_PtrSize * 2
SizeofRawInputDevice		:= 8 + A_PtrSize

RIM_TYPEMOUSE				:= 0
RIM_TYPEKEYBOARD			:= 1
RIM_TYPEHID					:= 2

RIDI_DEVICENAME				:= 0x20000007
RIDI_DEVICEINFO				:= 0x2000000b

RIDEV_INPUTSINK				:= 0x00000100

RID_INPUT					:= 0x10000003

DoCapture					:= 0

Gui, Add, Edit, HScroll w460 h300 vInfoOut -Wrap ReadOnly HwndInfoHwnd
Gui, Add, Edit, HScroll w460 h300 vEditOut -Wrap ReadOnly HwndEditHwnd
Gui, Add, Button, Default gCapture vCaptureButton w150, &Capture
Gui, Show, , HIDList

HWND := WinExist("HIDList")

Res := DllCall("GetRawInputDeviceList", "Ptr", 0, "UInt*", Count, UInt, SizeofRawInputDeviceList)

If (Res = -1) {
	InfoOutput("[1]GetRawInputDeviceList call failed.`r`n")
}

InfoOutput("There are " . Count . " raw input devices`r`n`r`n")

VarSetCapacity(RawInputList, SizeofRawInputDeviceList * Count)

Res := DllCall("GetRawInputDeviceList", "Ptr", &RawInputList, "UInt*", Count, "UInt", SizeofRawInputDeviceList)
If (Res = -1) {
	InfoOutput("[2]GetRawInputDeviceList call failed.`r`n")
}
InfoOutput(RawInputList)

MouseRegistered := 0
KeyboardRegistered := 0

Loop %Count% {
	Handle := NumGet(RawInputList, (A_Index - 1) * SizeofRawInputDeviceList, "UInt")
	Type := NumGet(RawInputList, ((A_Index - 1) * SizeofRawInputDeviceList) + A_PtrSize, "UInt")
	if (Type = RIM_TYPEMOUSE)
		TypeName := "RIM_TYPEMOUSE"
	else if (Type = RIM_TYPEKEYBOARD)
		TypeName := "RIM_TYPEKEYBOARD"
	else if (Type = RIM_TYPEHID)
		TypeName := "RIM_TYPEHID"
	else
		TypeName := "RIM_OTHER"

	InfoOutput("`r`nDevice " . A_Index . ":`r`n`tHandle " . Handle . "`r`n`tType " . Type . " (" . TypeName . ") `r`n")

	Res := DllCall("GetRawInputDeviceInfo", "Ptr", Handle, "UInt", RIDI_DEVICENAME, "Ptr", 0, "UInt *", nLength)

	If (Res = -1) {
		InfoOutput("[1]GetRawInputDeviceInfo call failed.`r`n")
	}

	VarSetCapacity(Name, (nLength + 1) * 2)

	Res := DllCall("GetRawInputDeviceInfo", "Ptr", Handle, "UInt", RIDI_DEVICENAME, "Str", Name, "UInt*", nLength)

	If (Res = -1) {
		InfoOutput("[2]GetRawInputDeviceInfo call failed.`r`n")
	}

	InfoOutput("`tName " . Name . "`r`n")

	Res := DllCall("GetRawInputDeviceInfo", "Ptr", Handle, "UInt", RIDI_DEVICEINFO, "Ptr", 0, "UInt *", iLength)

	If (Res = -1) {
		InfoOutput("[3]GetRawInputDeviceInfo call failed.`r`n")
	}

	VarSetCapacity(Info, iLength)
	NumPut(iLength, Info, 0, "UInt") ;Put length in struct RIDI_DEVICEINFO

	Res := DllCall("GetRawInputDeviceInfo", "Ptr", Handle, "UInt", RIDI_DEVICEINFO, "UInt", &Info, "UInt *", iLength)

	If (Res = -1) {
		InfoOutput("[4]GetRawInputDeviceInfo call failed.`r`n")
	}

	if (Type = RIM_TYPEMOUSE)
		InfoOutput("`tButtons " . NumGet(Info, 4 * 3) . "`r`n`tSample rate " . NumGet(Info, 4 * 4) . "`r`n")
	else if (Type = RIM_TYPEKEYBOARD)
		InfoOutput("`tMode " . NumGet(Info, 4 * 4) . "`r`n`tFunction keys " . NumGet(Info, 4 * 5) . "`r`n")
	else if (Type = RIM_TYPEHID)
	{
		InfoOutput("`tVendor " . NumGet(Info, 4 * 2) . " Product " . NumGet(Info, 4 * 3) . " Version " . NumGet(Info, 4 * 4) . " `r`n")
		UsagePage := NumGet(Info, (4 * 5), "UShort")
		Usage := NumGet(Info, (4 * 5) + 2, "UShort")
		InfoOutput("`tUsage " . Usage . " Usage Page " . UsagePage . "`r`n")
	}

	; Keyboards are always Usage 6, Usage Page 1, Mice are Usage 2, Usage Page 1,
	; HID devices specify their top level collection in the info block

	VarSetCapacity(RawDevice, SizeofRawInputDevice, 0)
	NumPut(RIDEV_INPUTSINK, RawDevice, 4)
	NumPut(HWND, RawDevice, 8)

	DoRegister := 0

	if (Type = RIM_TYPEMOUSE && MouseRegistered = 0)
	{
		DoRegister := 1
		; Mice are Usage 2, Usage Page 1
		NumPut(1, RawDevice, 0, "UShort")
		NumPut(2, RawDevice, 2, "UShort")
		MouseRegistered := 1
	}
	else if (Type = RIM_TYPEKEYBOARD && KeyboardRegistered = 0)
	{
		DoRegister := 1
		; Keyboards are always Usage 6, Usage Page 1
		NumPut(1, RawDevice, 0, "UShort")
		NumPut(6, RawDevice, 2, "UShort")
		KeyboardRegistered := 1
	}
	else if (Type = RIM_TYPEHID)
	{
		DoRegister := 1
		NumPut(UsagePage, RawDevice, 0, "UShort")
		NumPut(Usage, RawDevice, 2, "UShort")
	}

	if (DoRegister)
	{
		Res := DllCall("RegisterRawInputDevices", "Ptr", &RawDevice, "UInt", 1, "UInt", 8 + A_PtrSize)

		if (Res = 0)
				InfoOutput("`t>>> Failed to register for this device! <<<`r`n`r`n")
			else
				InfoOutput("`tRegistered for this device`r`n")
	}
}

Count := 1

InputMessage(wParam, lParam, msg, hwnd)
{
	global DoCapture
	global RIM_TYPEMOUSE, RIM_TYPEKEYBOARD, RIM_TYPEHID
	global RID_INPUT

	if (DoCapture = 0)
		return

	Res := DllCall("GetRawInputData", "UInt", lParam, "UInt", RID_INPUT, "Ptr", 0, "UInt *", Size, "UInt", 8 + A_PtrSize * 2)

	If (Res = -1) {
		InfoOutput("[1]GetRawInputData call failed.`r`n")
	}

	VarSetCapacity(Buffer, Size)

	Res := DllCall("GetRawInputData", "UInt", lParam, "UInt", RID_INPUT, "Ptr", &Buffer, "UInt *", Size, "UInt", 8 + A_PtrSize * 2)

	If (Res = -1) {
		InfoOutput("[2]GetRawInputData call failed.`r`n")
	}

	; AppendOutput(Mem2Hex(&Buffer, Size))

	Type := NumGet(Buffer, 0 * 4, "UInt")
	Size := NumGet(Buffer, 1 * 4, "UInt")
	Handle := NumGet(Buffer, 2 * 4, "UInt")

	;AppendOutput("Got Input with " . Res . " size " . Size . " Type " . Type . " Handle " . Handle . "`r`n")
	if (Type = RIM_TYPEMOUSE)
	{
		LastX := NumGet(Buffer, (20+A_PtrSize*2), "Int")
		LastY := NumGet(Buffer, (24+A_PtrSize*2), "Int")
		AppendOutput("`r`nHND " . Handle . " MOUSE LastX " . LastX . " LastY " . LastY . "`r`n")
	}
	else if (Type = RIM_TYPEKEYBOARD)
	{
		ScanCode := NumGet(Buffer, (8+A_PtrSize*2), "UShort")
		VKey := NumGet(Buffer, (14+A_PtrSize*2), "UShort")
		Message := NumGet(Buffer, (16+A_PtrSize*2))
		AppendOutput("HND " . Handle . " KBD ScanCode " . ScanCode . " VKey " . VKey . " Msg " . Message . "`r`n")
	}
	else if (Type = RIM_TYPEHID)
	{
		SizeHid := NumGet(Buffer, (8+A_PtrSize*2), "UInt")
		InputCount := NumGet(Buffer, (12+A_PtrSize*2), "UInt")
		AppendOutput("HND " . Handle . " HID Size " . SizeHid . " Count " . InputCount . " Ptr " . &Buffer)
		Loop %InputCount% {
			Addr := &Buffer + (16+A_PtrSize*2) + ((A_Index - 1) * SizeHid)
			BAddr := &Buffer
			;MsgBox, BAddr %BAddr% Addr %Addr%
			AppendOutput(" - Input " . Mem2Hex(Addr, SizeHid) . "`r`n")
		}
	}
	else
	{
		AppendOutput("HND " . Handle . " Unknown Type " . Type . "`r`n")
	}

	return
}
return

Exit

Capture:
{
	if (DoCapture = 0)
	{
		GuiControl, , CaptureButton, Stop &Capture
		DoCapture := 1
	}
	else
	{
		GuiControl, , CaptureButton, &Capture
		DoCapture := 0
	}
	return
}


GuiClose:
ExitApp

Mem2Hex( pointer, len )
{
	A_FI := A_FormatInteger
	SetFormat, Integer, Hex
	Loop, %len%  {
		Hex := *Pointer+0
		StringReplace, Hex, Hex, 0x, 0x0
		StringRight Hex, Hex, 2
		hexDump := hexDump . hex
		Pointer ++
	}
	SetFormat, Integer, %A_FI%
	StringUpper, hexDump, hexDump
	Return hexDump
}

InfoOutput(Text)
{
	global InfoHwnd
	GuiControlGet, InfoOut
	NewText := InfoOut . Text
	GuiControl, , InfoOut, %NewText%
	return
}

AppendOutput(Text)
{
	global EditHwnd
	GuiControlGet, EditOut
	NewText := EditOut . Text
	GuiControl, , EditOut, %NewText%
	; WM_VSCROLL (0x115), SB_BOTTOM (7)
	;MsgBox, %EditHwnd%
	SendMessage, 0x115, 0x0000007, 0, , ahk_id %EditHwnd%
	return
}
