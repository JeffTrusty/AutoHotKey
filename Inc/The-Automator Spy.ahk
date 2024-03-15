/*
 * ============================================================================ *
 * Want a clear path for learning AutoHotkey?                                   *
 * Take a look at our AutoHotkey courses here: the-Automator.com/Learn          *
 * They're structured in a way to make learning AHK EASY                        *
 * And come with a 200% moneyback guarantee so you have NOTHING to risk!        *
 * ============================================================================ *
 */
;;;;;;;;;;;;;;;;;;;;;;
;Window Spy for AHKv2;
;;;;;;;;;;;;;;;;;;;;;;
#Requires AutoHotkey v2.0

#include <ScriptObj\scriptobj>
script := {
	        base : ScriptObj(),
	     version : "1.0.0",
	      author : "the-Automator",
	       email : "joe@the-automator.com",
	     crtdate : "",
	     moddate : "",
       resfolder : A_ScriptDir "\res",
        iconfile : 'shell32.dll' , ;A_ScriptDir "\res\UltimateSpybg512.ico",
        ;  config : A_ScriptDir "\settings.ini",
	homepagetext : "www.the-automator.com/AutomatorSpy",
	homepagelink : "www.the-automator.com/AutomatorSpy?src=app",
	  donateLink : "https://www.paypal.com/donate?hosted_button_id=MBT5HSD9G94N6",
}

; #NoTrayIcon
; When program is in admin mode we cant reload without exiting from menu so, we ignore restarting any other way.
#SingleInstance Ignore
SetWorkingDir A_ScriptDir
CoordMode "Pixel", "Screen"
AdminProcesses := Map()
txtNotFrozen := ''
tray := A_TrayMenu
tray.Delete()
tray.Add("Display Automator Spy`tCtrl+Shift+W",(*) => a_now)
tray.Add("Control to Updates`tCtrl",(*) => a_now)
tray.Add("Exit App`tCtrl+Shift+Escape",(*) => a_now)
tray.Add("Bring Program to MousePos`tCtrl+Shift+M",(*) => a_now)
tray.Add()
tray.Add("About",(*) => Run('https://' script.homepagelink))
tray.Add("Donate",(*) => Run(script.donateLink))
tray.Add()
tray.AddStandard()

OnError Logger

Global oGui, SB

SetTimer CheckforAdmin, 300

WinSpyGui()

WinSpyGui() {
	Global oGui, SB, lv, txtNotFrozen

	try TraySetIcon "res\spy.ico"

	; TraySetIcon 'C:\WINDOWS\system32\accessibilitycpl.dll', 9
	DllCall("shell32\SetCurrentProcessExplicitAppUserModelID", "wstr", "AutoHotkey.WindowSpy")

	oGui := Gui("AlwaysOnTop Resize MinSize +DPIScale","Automator Spy" (A_IsAdmin ? ' (Admin Mode)' : '') )
	; msgbox IsProcessElevated(WinGetPID(WinExist(oGui)))

	oGui.OnEvent("Close",(*) => Exitapp())
	oGui.OnEvent("Size", WinSpySize)

	oGui.SetFont('s9 ', "Segoe UI")
	;oGui.SetFont('cblack', "Segoe UI")

	oGui.Add("Text",'cblue',"Current Positions:")
	lv := oGui.Add("ListView", "w360 r7 ReadOnly -NoSortHdr -Multi vctrl_lv", ["Title", "x", "y", "Width", "Height"])
	lv.OnEvent('Click',CopyPosition)
	names := [
		'Mouse Screen:',
		'Mouse Window:',
		'Mouse Client:',
		'Window Screen:',
		'Window Client:',
		'Control Screen:',
		'Control Client:'
	]
	for name in names
		lv.Add('', name)

	loop lv.GetCount('col')
		lv.ModifyCol(A_Index, 'Integer Center AutoHDR')

	lv.ModifyCol(1, "Right")

	oGui.Add("Text",'cblue',"Window Title, Class and Process:")
	oGui.Add("Checkbox","yp xp+200 w120 Right +hidden vCtrl_FollowMouse","Follow Mouse").Value := 1
	oGui.Add("Edit","xm w360 r5 ReadOnly -Wrap vCtrl_Title")
	oGui.Add("Text","w360 cblue vCtrl_CtrlLabel", "Control ClassNN Under Mouse:")
	oGui.Add("Edit","w360 r15 ReadOnly vCtrl_Ctrl")

	oGui.SetFont('cRed Bold s10', 'Verdana')
	oGui.Add("Text","cblue xm w360 r1 vCtrl_Freeze",(txtNotFrozen := "(Press Control to update)"))
	oGui.SetFont('s9 cBlack w300', "Segoe UI")
	oGui.Add("Text",'cblue ym vCtrl_HeaderVisText',"Visible Text:")
	oGui.Add("Edit","w360 r10.1 ReadOnly vCtrl_VisText")
	oGui.Add("Text","cblue vCtrl_HeaderAllText","All Text:")
	oGui.Add("Edit","w360 r12 ReadOnly vCtrl_AllText")

	oGui.Add("Text",'cblue vCtrl_SBHdr',"Status Bar Text:")
	oGui.Add("Edit","w360 r8 ReadOnly vCtrl_SBText")
	oGui.SetFont('cRed Bold s10', 'Verdana')
	oGui.Add("Text","w360 vCtrl_AdminCheck")
	oGui.SetFont('s9 cBlack w300', "Segoe UI")

	SB := oGui.AddStatusBar(,,)
	SB.SetParts(250)
	SB.OnEvent('click',SBRead)

	oGui.Show()

	if A_IsAdmin
		Highlight.Border(oGui)

	WinGetClientPos(&x_temp, &y_temp2,,,"ahk_id " oGui.hwnd)

	; oGui.horzMargin := x_temp*96//A_ScreenDPI - 320 ; now using oGui.MarginX

	oGui.txtNotFrozen := txtNotFrozen       ; create properties for futur use
	oGui.txtFrozen    := "(Can't self spy! move to other window and try again)"
	; oGui.txtMouseCtrl :=
	; oGui.txtFocusCtrl := txtFocusCtrl

	; SetTimer Update, 250
}

WinSpySize(GuiObj, MinMax, Width, Height) {
	Global oGui

	If !oGui.HasProp("txtNotFrozen") ; WinSpyGui() not done yet, return until it is
		return

	; SetTimer Update, (MinMax=0)?250:0 ; suspend updates on minimize

	ctrlW := Width - (oGui.MarginX * 3) ; ctrlW := Width - horzMargin
	;list := "Title,MousePos,Ctrl,Pos,SBText,VisText,AllText,Freeze"
	list := "lv,Title,Ctrl,SBText,VisText,AllText,Freeze,HeaderVisText,HeaderAllText,SBHdr,AdminCheck"
	moveHList := 'HeaderVisText,HeaderAllText,VisText,AllText,SBHdr,SBText,AdminCheck'
	Loop Parse list, ","
	{
		if InStr(moveHList, A_LoopField)
			oGui["Ctrl_" A_LoopField].Move((ctrlW / 2) +20,,(ctrlW / 2 ))
		else
			oGui["Ctrl_" A_LoopField].Move(,,(ctrlW / 2 ))
	}
	Highlight.UpdateBorderPos() ; seems to fix the leg issue 
}

LButtonUp(x*)
{
	;Try TryUpdate() ; Try
	MouseGetPos(,,&hwnd, &Control)
	ToolTip 'this is a test'

	settimer (*)=>ToolTip(), -2000
}

~*Ctrl::
Update(hk?) { ; timer, no params
	Try TryUpdate() ; Try
}

TryUpdate() {
	Global oGui, SB

	If !oGui.HasProp("txtNotFrozen") ; WinSpyGui() not done yet, return until it is
		return

	Ctrl_FollowMouse := oGui["Ctrl_FollowMouse"].Value
	CoordMode "Mouse", "Screen"
	MouseGetPos &msX, &msY, &msWin, &msCtrl, 2 ; get ClassNN and hWindow
	actWin := WinExist("A")

	if (Ctrl_FollowMouse) {
		curWin := msWin, curCtrl := msCtrl
		WinExist("ahk_id " curWin) ; updating LastWindowFound?
	} else {
		curWin := actWin
		curCtrl := ControlGetFocus() ; get focused control hwnd from active win
	}
	curCtrlClassNN := ""
	Try curCtrlClassNN := ControlGetClassNN(curCtrl)

	pTitle := WinGetTitle(), pClass := WinGetClass()
	if (curWin = oGui.hwnd || pClass = "MultitaskingViewFrame") { ; Our Gui || Alt-tab
		UpdateText("Ctrl_Freeze", oGui.txtFrozen)
		return
	}

	UpdateText("Ctrl_Freeze", oGui.txtNotFrozen)
	pName := WinGetProcessName(), pPID := WinGetPID()

	WinDataText := pTitle "`n" ; ZZZ
				 . "ahk_class " pClass "`n"
				 . "ahk_exe " pName "`n"
				 . "ahk_pid " pPID "`n"
				 . "ahk_id " curWin

	UpdateText("Ctrl_Title", WinDataText)
	CoordMode "Mouse", "Window"
	MouseGetPos &mrX, &mrY
	CoordMode "Mouse", "Client"
	MouseGetPos &mcX, &mcY
	mClr := PixelGetColor(msX,msY,"RGB")
	mClr := SubStr(mClr, 3)

	; SB.SetText("Screen: " msX ", " msY ,1)
	; SB.SetText("Window: " mrX ", " mrY ,2)
	; SB.SetText("Client: " mcX ", " mcY ,3)

	static MONITOR_DEFAULTTONEAREST := 0x00000002
	if !hMon := DllCall("MonitorFromWindow", "ptr", curWin, "int", MONITOR_DEFAULTTONEAREST)
		Throw Error("couldnt get the monitor handle", A_ThisFunc, curWin)

	DllCall("Shcore.dll\GetScaleFactorForMonitor"
		   , "ptr", hMon     ; [in]  HMONITOR            hMon,
		   , "ptr*", &pScale:=0) ; [out] DEVICE_SCALE_FACTOR *pScale

	pScale /= (A_ScreenDPI / 96) * 100.0


	SB.SetText("Color: " mClr " (Red=" SubStr(mClr, 1, 2) " Green=" SubStr(mClr, 3, 2) " Blue=" SubStr(mClr, 5) ")")
	SB.SetText( 'Current DPI: ' pScale * 100 "%",2)
	;SB.Opt('c' mClr)
	; UpdateText("Ctrl_CtrlLabel", (Ctrl_FollowMouse ? oGui.txtMouseCtrl : oGui.txtFocusCtrl) ":")


	wX := wY := wW := wH := sX := sY := sW := sH := cX := cY := cW := cH := ''
	if (curCtrl)
	{
		ctrlTxt := ControlGetText(curCtrl)

		ControlGetPos &cX, &cY, &cW, &cH, curCtrl
		WinGetClientPos(&sX, &sY, &sW, &sH, curCtrl)
		cText := "ClassNN:`t" curCtrlClassNN "`n"
			   . "Text: " Trim(ctrlTxt, ' `t') ;textMangle()
	}
	else
		cText := ""


	WinGetPos &wX, &wY, &wW, &wH, "ahk_id " curWin
	WinGetClientPos(&wcX, &wcY, &wcW, &wcH, "ahk_id " curWin)

	positions := [
		{x:msX, y:msY, w:'', h:''},
		{x:mrX, y:mrY, w:'', h:''},
		{x:mcX, y:mcY, w:'', h:''},
		{x:wX, y:wY, w:wW, h:wH},
		{x:wcX, y:wcY, w:wcW, h:wcH},
		{x:sX, y:sY, w:sW, h:sH},
		{x:cX, y:cY, w:cW, h:cH}
	]
	for pos in positions
		lv.Modify(A_Index,,, pos.x, pos.y, pos.w, pos.h)

	; wText := "Screen:`tx: " wX "`ty: " wY "`tw: " wW "`th: " wH "`n"
	;        . "Client:`tx: " wcX "`ty: " wcY "`tw: " wcW "`th: " wcH

	; ; UpdateText("Ctrl_Pos", wText)
	sbTxt := ""
	Loop {
		ovi := ""
		Try ovi := StatusBarGetText(A_Index)
		if (ovi = "")
			break
		sbTxt .= "(" A_Index "): " Trim(ovi, ' `t') '`n' ; textMangle() "`n"
	}

	sbTxt := SubStr(sbTxt,1,-1) ; StringTrimRight, sbTxt, sbTxt, 1

	;bSlow := oGui["Ctrl_IsSlow"].Value ; GuiControlGet, bSlow,, Ctrl_IsSlow
	bSlow := 1
	if (bSlow) {
		DetectHiddenText False
		ovVisText := WinGetText() ; WinGetText, ovVisText
		DetectHiddenText True
		ovAllText := WinGetText() ; WinGetText, ovAllText
	} else {
		ovVisText := WinGetTextFast(false)
		ovAllText := WinGetTextFast(true)
	}

	;if AdminProcesses.Has(t4)
	IsElevated := IsProcessElevated(pPID)

	oGui['Ctrl_Freeze'].opt('c' (IsElevated ? 'Red' : 'Blue'))
	oGui['Ctrl_AdminCheck'].opt('c' (IsElevated ? 'Red' : 'Blue'))
	UpdateText('Ctrl_AdminCheck', IsElevated ? 'Admin Process: ' pName : 'Normal Process')
	UpdateText('Ctrl_Freeze', IsElevated ? 'Press Control when ' pName ' is not Active' : '(Press Control to update)')
	UpdateText("Ctrl_Ctrl", cText)
	UpdateText("Ctrl_SBText", sbTxt)
	UpdateText("Ctrl_VisText", ovVisText)
	UpdateText("Ctrl_AllText", ovAllText)

	loop lv.GetCount('col')
	{
		if a_index = 5
			 lv.ModifyCol(A_Index, '60')
		else
			lv.ModifyCol(A_Index, 'AutoHDR')
	}
}

; ===========================================================================================
; WinGetText ALWAYS uses the "slow" mode - TitleMatchMode only affects
; WinText/ExcludeText parameters. In "fast" mode, GetWindowText() is used
; to retrieve the text of each control.
; ===========================================================================================
WinGetTextFast(detect_hidden) {
	controls := WinGetControlsHwnd()

	static WINDOW_TEXT_SIZE := 32767 ; Defined in AutoHotkey source.

	buf := Buffer(WINDOW_TEXT_SIZE * 2,0)

	text := ""

	Loop controls.Length {
		hCtl := controls[A_Index]
		if !detect_hidden && !DllCall("IsWindowVisible", "ptr", hCtl)
			continue
		if !DllCall("GetWindowText", "ptr", hCtl, "Ptr", buf.ptr, "int", WINDOW_TEXT_SIZE)
			continue

		text .= StrGet(buf, 'utf-8') "`r`n" ; text .= buf "`r`n"
	}
	return text
}

; ===========================================================================================
; Unlike using a pure GuiControl, this function causes the text of the
; controls to be updated only when the text has changed, preventing periodic
; flickering (especially on older systems).
; ===========================================================================================
UpdateText(vCtl, NewText) {
	Global oGui
	static OldText := {}
	ctl := oGui[vCtl], hCtl := Integer(ctl.hwnd)

	if (!oldText.HasProp(hCtl) Or OldText.%hCtl% != NewText) {
		ctl.Value := NewText
		OldText.%hCtl% := NewText
	}
}

textMangle(x) {
	elli := false
	if (pos := InStr(x, "`n"))
		x := SubStr(x, 1, pos-1), elli := true
	else if (StrLen(x) > 40)
		x := SubStr(x,1,40), elli := true
	if elli
		x .= " (...)"
	return x
}

suspend_timer() {
	Global oGui
	SetTimer Update, 0
	UpdateText("Ctrl_Freeze", oGui.txtFrozen)
}

SBRead(obj,info)
{
	if !GetKeyState('Shift', 'P')
		A_Clipboard := ''

	A_Clipboard .= RegExReplace(StatusBarGetText(info, oGui),'(\w+):\s(-?\d+,\s-?\d+)|(\w+):\s(\w+)\s(.*)','$2$4 `; $1$3 $5') '`n'
	if !ClipWait(1)
		return
	ToolTip('Copied: ' A_Clipboard)
	SetTimer((*) => ToolTip(), -600)
}

CopyPosition(obj,row)
{
	static last_relative := ''
	if !row
		return

	for var in [&relative_to, &xPos, &yPos, &width, &height]
		%var% := Lv.GetText(row, A_index)

	if xPos = ''
	|| yPos = ''
		return

	if !GetKeyState('Shift')
	|| relative_to != last_relative
		A_Clipboard := ''

	last_relative := relative_to
	size := width && height ? ' width: ' width ' height: ' height : ''
	A_Clipboard  .= xPos ',' yPos A_Space '; Relative to ' StrReplace(relative_to, ':') size '`n'

	ToolTip 'Copied to clipboard:`n' A_Clipboard
	SetTimer (*)=>ToolTip(), -2000
}


^+w::oGui.Show('NA Restore')

; ^+e::Edit
^+r::Reload
^+Escape::Exitapp ;Shift + Escape will Exit the app

; Move active window to current mouse position this is useful for moving programs
; to a visible location when they are shown in another monitor or out of the main gui
; specially when you are remote controlling another machine and cannot see all monitors
^+m:: ;Control+shift+m to Bring program back to active window
{
	MouseGetPos &x, &y
	WinMove x, y,,,'A'
}

Logger(err, *)
{
	OutputDebug err.What '(' A_LineFile '):`n' err.Message '`n'
	return true ; block the display of error messages
}

CheckforAdmin()
{
	GLOBAL txtNotFrozen
	oGui.Opt('+OwnDialogs')
	try Pid :=  WinGetPID('a')
	catch
		return

	OutputDebug A_ThisFunc '> Getting pid: ' pid
	pName := StrTitle(ProcessGetName(pid))
	if IsProcessElevated(Pid)
	&& !A_IsAdmin
	; && !AdminProcesses.Has(pid)
	{
		; AdminProcesses.Set(pid, true)
		; Sleep 1000
		if MsgBox('The program you are trying to automate is in admin mode.`nDo you want to restart Automator Spy in admin mode?',
		'Window is Admin', 'Y/N icon!') = 'No'
		{
			oGui.Show()
			oGui['Ctrl_Freeze'].opt('cRed')
			oGui['Ctrl_Freeze'].value := oGui.txtNotFrozen := 'Press Control when ' pName ' is not Active'
			OutputDebug 'Creating border for non elevated pid: ' pid
			Highlight.Border('ahk_pid' pid)
		}
		else
		{
			Run '*RunAs ' A_ScriptFullPath
			ExitApp
		}
	}
	else if IsProcessElevated(Pid)
	{
		OutputDebug 'Creating border for elevated pid: ' pid
		Highlight.Border('ahk_pid' pid)
	}
	else if !Highlight.marked.Has(WinGetID('ahk_pid' pid))
	{
		OutputDebug A_ThisFunc '> if statement > Didnt find pid in marked: ' pid
		oGui['Ctrl_Freeze'].opt('cBlue')
		oGui['Ctrl_Freeze'].value := oGui.txtNotFrozen := '(Press Control to update)'
	}
}

; =============================================================================================================================================================
; Author ........: jNizM
; Released ......: 2017-01-10
; Modified ......: 2023-01-16
; Tested with....: AutoHotkey v2.0.2 (x64)
; Tested on .....: Windows 11 - 22H2 (x64)
; Function ......: IsProcessElevated()
;
; Parameter(s)...: ProcessID - The process identifier of the process.
;
; Return ........: Retrieves whether a token has elevated privileges.
; =============================================================================================================================================================

IsProcessElevated(ProcessID)
{
	static INVALID_HANDLE_VALUE              := -1
	static PROCESS_QUERY_INFORMATION         := 0x0400
	static PROCESS_QUERY_LIMITED_INFORMATION := 0x1000
	static TOKEN_QUERY                       := 0x0008
	static TOKEN_QUERY_SOURCE                := 0x0010
	static TokenElevation                    := 20

	hProcess := DllCall("OpenProcess", "UInt", PROCESS_QUERY_INFORMATION, "Int", False, "UInt", ProcessID, "Ptr")
	if (!hProcess) || (hProcess = INVALID_HANDLE_VALUE)
	{
		hProcess := DllCall("OpenProcess", "UInt", PROCESS_QUERY_LIMITED_INFORMATION, "Int", False, "UInt", ProcessID, "Ptr")
		if (!hProcess) || (hProcess = INVALID_HANDLE_VALUE)
			throw OSError()
	}

	if !(DllCall("advapi32\OpenProcessToken", "Ptr", hProcess, "UInt", TOKEN_QUERY | TOKEN_QUERY_SOURCE, "Ptr*", &hToken := 0))
	{
		DllCall("CloseHandle", "Ptr", hProcess)
		throw OSError()
	}

	if !(DllCall("advapi32\GetTokenInformation", "Ptr", hToken, "Int", TokenElevation, "UInt*", &IsElevated := 0, "UInt", 4, "UInt*", &Size := 0))
	{
		DllCall("CloseHandle", "Ptr", hToken)
		DllCall("CloseHandle", "Ptr", hProcess)
		throw OSError()
	}

	DllCall("CloseHandle", "Ptr", hToken)
	DllCall("CloseHandle", "Ptr", hProcess)
	return IsElevated
}

class Highlight {
	static marked := Map()
	static Border(winTitle, size:=2, color:='Red', flash:=false) => Border(winTitle, size, color, flash)

	static CalculateBorderRegion(point, px)
	{
		static outer_region := '0-0 {1}-0 {1}-{2} 0-{2} 0-0'
		static inner_region := '{1}-{1} {2}-{1} {2}-{3} {1}-{3} {1}-{1}'

		return Format(outer_region, point.w, point.h) ' ' Format(inner_region, px, point.w-px, point.h-px)
	}
}

class Border extends Highlight {
	__New(winTitle, size:=2, color:='Red', flash:=false)
	{
		WinGetPos(&x, &y, &width, &height, winTitle)
		rect := {x:x, y:y, w:width, h:height}

		border := Gui('-Caption +ToolWindow')
		border.parent    := WinGetID(winTitle)
		border.BackColor := color

		opts := Format('Hide x{} y{} w{} h{}', rect.x+1, rect.y, rect.w-1, rect.h)
		border.Show(opts) ; show hidden to later get a size

		region := Highlight.CalculateBorderRegion(rect, size)
		WinSetRegion region, border
		border.Show('NoActivate')

		Highlight.marked.Set(border.parent, true)
		; we should use Shell Hook instead Timmer
		; onmessage when window moved and destroyed
		SetTimer UpdateBorderPos, 5 
		return this

		UpdateBorderPos()
		{
			static WS_VISIBLE := 0x10000000

			if WinGetMinMax(border.parent) = -1
			; || !WinActive(border.parent)
				return border.Hide()

			try WinGetPos(&x, &y, &w, &h, border.parent)
			catch
			{
				SetTimer UpdateBorderPos, false
				Highlight.marked.Delete(border.parent)
				border.Destroy()
				return border := ''
			}

			if !(WinGetStyle(border.parent) & WS_VISIBLE)
				return border.Hide()

			; outputDebug 'moving window to: ' x ',' y ',' w ',' h '`n'
			border.Show('NoActivate')
			border.Move(x, y-2, w, h)
		}
	}
}