/**
 * ============================================================================ *
 * @Author   : Rizwan                                                          *
 * @Homepage : the-automator.com                                               *
 *                                                                             *
 * @Created  : Dec 03, 2024                                                    *
 * ============================================================================ *
 * Want a clear path for learning AutoHotkey?                                   *
 * Take a look at our AutoHotkey courses here: the-Automator.com/Discover       *
 * They're structured in a way to make learning AHK EASY                        *
 * And come with a 200% moneyback guarantee so you have NOTHING to risk!        *
 * ============================================================================ *
 */

/*
This work by the-Automator.com is licensed under CC BY 4.0

Attribution — You must give appropriate credit , provide a link to the license,
and indicate if changes were made.
You may do so in any reasonable manner, but not in any way that suggests the licensor
endorses you or your use.
No additional restrictions — You may not apply legal terms or technological measures that
legally restrict others from doing anything the license permits.
*/
;@Ahk2Exe-SetVersion     0.0.1
;@Ahk2Exe-SetMainIcon    res\main.ico
;@Ahk2Exe-SetProductName Bring Window to Mouse
;@Ahk2Exe-SetDescription Bring Window to Mouse
;--
#SingleInstance
#Requires Autohotkey v2.0+
Persistent
#include <NotifyV2>
#include <ScriptObject>

script := {
	        base   : ScriptObj(),
	     version   : "0.0.1",
	        hwnd   : 0,
	      author   : "the-Automator",
	       email   : "joe@the-automator.com",
	     crtdate   : "",
	     moddate   : "",
	   resfolder   : A_ScriptDir "\res",
	    ; iconfile : 'res\ocr2.ico' , ;A_ScriptDir "\res\UltimateSpybg512.ico",
	         ini   : A_ScriptDir "\settings.ini",
	homepagetext   : "BringWinToMouse",
	homepagelink   : "https://the-Automator.com/BringWinToMouse/",
	VideoLink      : "",
	DevPath  	   : "S:\Bring Window to Mouse\Bring Window to Mouse.ahk",
	donateLink     : "", ; "https://www.paypal.com/donate?hosted_button_id=MBT5HSD9G94N6"
}

CoordMode "Mouse", "Screen"
main := Gui(,'Assign Hotkey')
ini := 'Settings.ini'

CreateTryMenu()
CreateTryMenu(*)
{
	global tray := A_TrayMenu
	tray.Delete()
	tray.Add("Preferences`t",(*) =>  main.Show())
	hk := IniRead(ini,'HOTKEY','HK',"NotAssign")
	tray.Add("Display list of all running program",DisplayAllProgram)
	tray.Add("Move window to mouse`t" HKToString(hk),(*) => false)
	if (IniRead(ini,'Display','List',0) = 1)
		tray.Check("Display list of all running program")
	else
		tray.UnCheck("Display list of all running program")
	tray.Add()
	tray.add('Open Folder',(*)=>Run(A_ScriptDir))
	tray.SetIcon("Open Folder","shell32.dll",4)
	tray.Add("About",(*) => Script.About())
	tray.Add("Exit`t",(*) => Exitapp())
}



TraySetIcon("C:\WINDOWS\system32\shell32.dll", 101)
move_active := false
ListViewfontsize := 13
main.SetFont('S' ListViewfontsize)
main.AddText('w250 center h25 ','Hotkey to Bring Window').SetFont('S' ListViewfontsize+2)
SetWin := main.AddCheckbox('yp+40','Win')
SetHK := main.AddHotkey('x+m yp-3', '')
main.AddButton('w115 xm','Apply').OnEvent('Click',Apply)
main.AddButton('w115 x+m','Cancel').OnEvent('Click',(*) => ExitApp())
Showkey
Showkey(*)
{
	AssignedHK := IniRead(ini,'HOTKEY','HK', false)
	if InStr(AssignedHK,"#")
	{
		AssignedHK := StrReplace(AssignedHK,"#")
		SetHK.value := AssignedHK
		SetWin.value := true
	}
	else
	{
		if (AssignedHK = false)
		{
			main.Show()
		}
		else
		{
			SetHK.value := AssignedHK
			Hotkey(AssignedHK, MoveActiveWindow,'on')
		}
	}
}


DisplayAllProgram(*)
{
	hk := IniRead(ini,'HOTKEY','HK',"NotAssign")
	if (IniRead(ini,'Display','List',0) = 1)
	{
		IniWrite(0,ini,'Display','List')
		tray.UnCheck("Display list of all running program")
		main.Hide()
		if WinExist('Bring window to mouse')
		{
			WinActivate('Bring window to mouse')
			WinClose('Bring window to mouse')
		}
		return
	}
	else
	{
		IniWrite(1,ini,'Display','List')
		tray.Check("Display list of all running program")
	}
	CreateTryMenu
}

; Move active window to current mouse position this is useful for moving programs
; to a visible location when they are shown in another monitor or out of the main gui
; specially when you are remote controlling another machine and cannot see all monitors
;^+m:: ;Control+shift+m to Bring program back to active window
Apply(*)
{	
	oldHK := IniRead(ini,'HOTKEY','HK','NotAssign')
    if (oldHK != "NotAssign")
        Hotkey(oldHK,MoveActiveWindow,'off')

	IF SetWin.value
	{
		IniWrite('#' SetHK.value,ini,'HOTKEY','HK')
		Hotkey('#' SetHK.value,MoveActiveWindow,'on')
	}
	else
	{
		IniWrite(SetHK.value,ini,'HOTKEY','HK')
		Hotkey(SetHK.value,MoveActiveWindow,'on')
	}
	CreateTryMenu
	Showkey
	;NotifyHotkey()
    main.Hide()
}


NotifyHotkey(*)
{
	Notify.Show({HDText:"Hotkey Updated",
	HDFontSize  : 20,
	HDFontColor : "2500f7",
	HDFont:"Impact",
	GenDuration : 3,
	BDText : (SetWin.value=1)?(HKToString('#' SetHK.value)):((HKToString(SetHK.value))),
	GenLoc: 'center',
	BDFontSize  : 18})
}

MoveActiveWindow(*)
{
	if IniRead(ini,'Display','List',0)
		Hotkey_Apply()
	Else
	{
		MouseGetPos &x, &y
		if !WinExist('A')
		{
			Notify.Show({HDText:"No Active window Found",HDFontSize  : 20,HDFontColor : "2500f7",GenLoc: 'center'})
			Return
		}
		WinMove x, y,,,'A'
		return
	}
}

Hotkey_Apply(*)
{
	static window_list := unset
	static lv := unset
	MouseGetPos &x1, &y1
	global x1 , y1
	if !IsSet(window_list)
	{
		window_list := Gui(,'Bring window to mouse')
		window_list.SetFont('S' ListViewfontsize)
		lv := window_list.AddListView('w500 r20', ['Executable','Title'])
		lv.OnEvent('DoubleClick', MoveWindow)
	}

	hIcon_list := IL_Create()
	iconName := Map()

	lv.Delete()  ; Clear existing items
	num := 0
	lv.SetImageList(hIcon_list)

	lv.Opt('-Redraw')
	lv.Delete()

	for hwnd in WinGetList()
	{
		if !WinGetTitle(hwnd)
			continue

		pid := WinGetPID(hwnd)
		Path := ProcessGetPath(pid)
		; if instr(Path,"ApplicationFrameHost")
		; {
		; 	xx := WinGetTitle(hwnd)
		; 	path := "C:\Windows\System32\" WinGetTitle(hwnd) ".exe"
		; }

		if !iconName.Has(hwnd)
		{
			num := IL_Add(hIcon_list, path, 1)
			iconName[hwnd] := num
		}
		appname := WinGetProcessName(hwnd)
		appname := StrReplace(appname,"ApplicationFrameHost.exe","Windows App")
		lv.Add("Icon" num, appname, WinGetTitle(hwnd))
	}

	lv.ModifyCol(2, 'Sort')
	lv.ModifyCol()

	lv.Opt('+Redraw')
	MouseGetPos &x, &y
	window_list.Show('x' x ' y' y)
	;NotifyHotkey
	return 

	MoveWindow(obj, row)
	{
		window_list.Hide()
		title := lv.GetText(row, 2)

		WinActivate title
		;MouseGetPos &x, &y
		WinRestore title
		WinMove x1, y1,,, title
	}
}

HKToString(hk)
{
	; removed logging due to performance issues
	; Log.Add(DEBUG_ICON_INFO, A_Now, A_ThisFunc, 'started', 'none')

	if !hk
		return

	temphk := []

	if InStr(hk, '#')
		temphk.Push('Win+')
	if InStr(hk, '^')
		temphk.Push('Ctrl+')
	if InStr(hk, '+')
		temphk.Push('Shift+')
	if InStr(hk, '!')
		temphk.Push('Alt+')

	hk := RegExReplace(hk, '[#^+!]')
	for mod in temphk
		fixedMods .= mod

	; Log.Add(DEBUG_ICON_INFO, A_Now, A_ThisFunc, 'ended', 'none')
	return (fixedMods ?? '') StrUpper(hk)
}