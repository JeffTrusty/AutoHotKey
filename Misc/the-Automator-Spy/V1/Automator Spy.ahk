;******************************************************************************
; Want a clear path for learning AutoHotkey?                                  *
; Take a look at our AutoHotkey Udemy courses.                                *
; They're structured in a way to make learning AHK EASY                       *
; Right now you can  get a coupon code here: https://the-Automator.com/Learn  *
;******************************************************************************
#SingleInstance,Force
#HotkeyModifierTimeout, 100
;
; Window Spy
;
#Requires AutoHotkey v1.1.33+
#NoEnv
#SingleInstance Ignore
SetWorkingDir, %A_ScriptDir%
SetBatchLines, -1
CoordMode, Pixel, Screen
CoordMode Mouse, Screen

loop 10
{
	num := a_index - 1
	Hotkey, Numpad%num%, NumpadToNum
}

txtNotFrozen := "(Hold Ctrl or Shift to suspend updates)"
txtFrozen := "(Updates suspended)"
txtMouseCtrl := "Control Under Mouse Position"
txtFocusCtrl := "Focused Control"

Gui, New, hwndhGui AlwaysOnTop Resize MinSize
; Gui, Font, s16
Gui, Add, Text,, Window Title, Class and Process:
Gui, Add, Checkbox, Checked yp xp+200 w120 Right vCtrl_FollowMouse, Follow Mouse
Gui, Add, Edit, xm w320 r4 ReadOnly -Wrap vCtrl_Title
Gui, Add, Text,, Mouse Position:
Gui, Add, Edit, w320 r4 ReadOnly vCtrl_MousePos
Gui, Add, Text, w320 vCtrl_CtrlLabel, % txtFocusCtrl ":"
Gui, Add, Edit, w320 r4 ReadOnly vCtrl_Ctrl
Gui, Add, Text,, Active Window Position:
Gui, Add, Edit, w320 r2 ReadOnly vCtrl_Pos
Gui, Add, Text,, Status Bar Text:
Gui, Add, Edit, w320 r4 ReadOnly vCtrl_SBText
Gui, Add, Checkbox, Checked vCtrl_IsSlow, Slow TitleMatchMode
Gui, Add, Text, x+m vAdmincheck cRed w120,
Gui, Add, Text, ym vCtrl_VisTextCaption, Visible Text:
Gui, Add, Edit, Section w320 r13 ReadOnly vCtrl_VisText
Gui, Add, Text, vCtrl_AllTextCaption, All Text:
Gui, Add, Edit, w320 r13 ReadOnly vCtrl_AllText
Gui, Add, Text, w320 r1 vCtrl_Freeze, % txtNotFrozen
Gui, Add, Button, ys w75, WinSpy
Gui, Add, Button,  w75, UIAViewer
Gui, %hGui%: Show, NoActivate, Window Spy
SetTimer, Update, 250
return

GuiSize:
Gui %hGui%:Default
if !horzMargin
	return
SetTimer, Update, % A_EventInfo=1 ? "Off" : "On" ; Suspend on minimize
ctrlW := A_GuiWidth - horzMargin
ctrlX := A_GuiWidth - horzMargin + 20
list = Title,MousePos,Ctrl,Pos,Freeze,SBText
Loop, Parse, list, `,
	GuiControl, Move, Ctrl_%A_LoopField%, w%ctrlW%
list = VisText,AllText,VisTextCaption,AllTextCaption
Loop, Parse, list, `,
	GuiControl, Move, Ctrl_%A_LoopField%, x%ctrlX%
return

Update:
Gui %hGui%:Default
GuiControlGet, Ctrl_FollowMouse
CoordMode, Mouse, Screen
MouseGetPos, msX, msY, msWin, msCtrl
actWin := WinExist("A")
if Ctrl_FollowMouse
{
	curWin := msWin
	curCtrl := msCtrl
	WinExist("ahk_id " curWin)
}
else
{
	curWin := actWin
	ControlGetFocus, curCtrl
}
WinGetTitle, t1
WinGetClass, t2
if (curWin = hGui || t2 = "MultitaskingViewFrame") ; Our Gui || Alt-tab
{
	UpdateText("Ctrl_Freeze", txtFrozen)
	return
}
UpdateText("Ctrl_Freeze", txtNotFrozen)
WinGet, t3, ProcessName
WinGet, t4, PID
UpdateText("Ctrl_Title", t1 "`nahk_class " t2 "`nahk_exe " t3 "`nahk_pid " t4)
CoordMode, Mouse, Relative
MouseGetPos, mrX, mrY
CoordMode, Mouse, Client
MouseGetPos, mcX, mcY
PixelGetColor, mClr, %msX%, %msY%, RGB
mClr := SubStr(mClr, 3)
UpdateText("Ctrl_MousePos", "Screen:`t" msX ", " msY " (less often used)`nWindow:`t" mrX ", " mrY " (default)`nClient:`t" mcX ", " mcY " (recommended)")
	;. "`nColor:`t" mClr " (Red=" SubStr(mClr, 1, 2) " Green=" SubStr(mClr, 3, 2) " Blue=" SubStr(mClr, 5) ")")
UpdateText("Ctrl_CtrlLabel", (Ctrl_FollowMouse ? txtMouseCtrl : txtFocusCtrl) ":")
if (curCtrl)
{
	ControlGetText, ctrlTxt, %curCtrl%
	cText := "ClassNN:`t" curCtrl "`nText:`t" textMangle(ctrlTxt)
    ControlGetPos cX, cY, cW, cH, %curCtrl%
    cText .= "`n`tx: " cX "`ty: " cY "`tw: " cW "`th: " cH
    WinToClient(curWin, cX, cY)
	ControlGet, curCtrlHwnd, Hwnd,, % curCtrl
    GetClientSize(curCtrlHwnd, cW, cH)
    cText .= "`nClient:`tx: " cX "`ty: " cY "`tw: " cW "`th: " cH
}
else
	cText := ""
UpdateText("Ctrl_Ctrl", cText)
WinGetPos, wX, wY, wW, wH
GetClientSize(curWin, wcW, wcH)
UpdateText("Ctrl_Pos", "`tx: " wX "`ty: " wY "`tw: " wW "`th: " wH "`nClient:`tx: 0`ty: 0`tw: " wcW "`th: " wcH)
sbTxt := ""
Loop
{
	StatusBarGetText, ovi, %A_Index%
	if ovi =
		break
	sbTxt .= "(" A_Index "):`t" textMangle(ovi) "`n"
}
StringTrimRight, sbTxt, sbTxt, 1
UpdateText("Ctrl_SBText", sbTxt)
GuiControlGet, bSlow,, Ctrl_IsSlow
if bSlow
{
	DetectHiddenText, Off
	WinGetText, ovVisText
	DetectHiddenText, On
	WinGetText, ovAllText
}
else
{
	ovVisText := WinGetTextFast(false)
	ovAllText := WinGetTextFast(true)
}
UpdateText("Ctrl_VisText", ovVisText)
UpdateText("Ctrl_AllText", ovAllText)
;ToolTip, % (IsProcessElevated(t4)? "Admin Mode Detected":"tttttttttt")
UpdateText("Admincheck", (IsProcessElevated(t4)? "Admin Mode Detected":""))
; 

return

GuiClose:
Gui, %hGui%: Hide
return

WinGetTextFast(detect_hidden)
{
	; WinGetText ALWAYS uses the "Slow" mode - TitleMatchMode only affects the
	; WinText/ExcludeText parameters.  In "Fast" mode, GetWindowText() is used
	; to retrieve the text of each control.
	WinGet controls, ControlListHwnd
	static WINDOW_TEXT_SIZE := 32767 ; Defined in AutoHotkey source.
	VarSetCapacity(buf, WINDOW_TEXT_SIZE * (A_IsUnicode ? 2 : 1))
	text := ""
	Loop Parse, controls, `n
	{
		if !detect_hidden && !DllCall("IsWindowVisible", "ptr", A_LoopField)
			continue
		if !DllCall("GetWindowText", "ptr", A_LoopField, "str", buf, "int", WINDOW_TEXT_SIZE)
			continue
		text .= buf "`r`n"
	}
	return text
}

UpdateText(ControlID, NewText)
{
	; Unlike using a pure GuiControl, this function causes the text of the
	; controls to be updated only when the text has changed, preventing periodic
	; flickering (especially on older systems).
	static OldText := {}
	global hGui
	if (OldText[ControlID] != NewText)
	{
		GuiControl, %hGui%:, % ControlID, % NewText
		OldText[ControlID] := NewText
	}
}

GetClientSize(hWnd, ByRef w := "", ByRef h := "")
{
	VarSetCapacity(rect, 16)
	DllCall("GetClientRect", "ptr", hWnd, "ptr", &rect)
	w := NumGet(rect, 8, "int")
	h := NumGet(rect, 12, "int")
}

WinToClient(hWnd, ByRef x, ByRef y)
{
    WinGetPos wX, wY,,, ahk_id %hWnd%
    x += wX, y += wY
    VarSetCapacity(pt, 8), NumPut(y, NumPut(x, pt, "int"), "int")
    if !DllCall("ScreenToClient", "ptr", hWnd, "ptr", &pt)
        return false
    x := NumGet(pt, 0, "int"), y := NumGet(pt, 4, "int")
    return true
}

textMangle(x)
{
	if pos := InStr(x, "`n")
		x := SubStr(x, 1, pos-1), elli := true
	if StrLen(x) > 40
	{
		StringLeft, x, x, 40
		elli := true
	}
	if elli
		x .= " (...)"
	return x
}


^+w::
Gui, %hGui%: Show, NoActivate, Window Spy
GetClientSize(hGui, temp)
horzMargin := temp*96//A_ScreenDPI - 320
SetTimer, Update, 250
return

~*Ctrl::
~*Shift::
SetTimer, Update, Off
UpdateText("Ctrl_Freeze", txtFrozen)
return

~*Ctrl up::
~*Shift up::
SetTimer, Update, On
return

; ^+e::Edit
; ^+r::Reload
^+Escape::Exitapp ;Shift + Escape will Exit the app

; Move active window to current mouse position
; this is useful for moving programs to a visible location when
; they are shown in another monitor or out of the main gui
; specially when you are remote controlling another machine and cannot see
; all monitors
^+m::
MouseGetPos, x, y
WinMove A,, %x%, %y%
return

^+c::
MouseGetPos, x, y
clipboard := x "," c
return

NumpadToNum:
Send % SubStr(A_ThisHotkey,0)
return


IsProcessElevated(ProcessID) {
	if !(hProcess := DllCall("OpenProcess", "uint", 0x1000, "int", 0, "uint", ProcessID, "ptr"))
		throw Exception("OpenProcess failed", -1)
	if !(DllCall("advapi32\OpenProcessToken", "ptr", hProcess, "uint", 0x0008, "ptr*", hToken))
		throw Exception("OpenProcessToken failed", -1), DllCall("CloseHandle", "ptr", hProcess)
	if !(DllCall("advapi32\GetTokenInformation", "ptr", hToken, "int", 20, "uint*", IsElevated, "uint", 4, "uint*", size))
		throw Exception("GetTokenInformation failed", -1), DllCall("CloseHandle", "ptr", hToken) && DllCall("CloseHandle", "ptr", hProcess)
	if !(DllCall("advapi32\GetTokenInformation", "ptr", hToken, "int", 26, "uint*", UIAccess, "uint", 4, "uint*", size))
		throw Exception("GetTokenInformation failed", -1), DllCall("CloseHandle", "ptr", hToken) && DllCall("CloseHandle", "ptr", hProcess)
	return IsElevated or UIAccess , DllCall("CloseHandle", "ptr", hToken) && DllCall("CloseHandle", "ptr", hProcess)
}