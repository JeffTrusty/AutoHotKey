#Requires AutoHotkey v2.0
#include <ScriptObj\scriptobj>
#include *i <Border>
#SingleInstance Force
;#Include <Border>
/*
* ============================================================================ *
* Want a clear path for learning AutoHotkey?                                   *
* Take a look at our AutoHotkey courses here: the-Automator.com/Discover          *
* They're structured in a way to make learning AHK EASY                        *
* And come with a 200% moneyback guarantee so you have NOTHING to risk!        *
* ============================================================================ *
*/

uGui := Gui('+AlwaysOnTop -caption -sysmenu +ToolWindow -DPIScale','the-Automator Ultimate Spy')
; Highlight.Border(ugui)
script := {
	        base : ScriptObj(),
	     version : "1.1.0",
	        hwnd : uGui.Hwnd,
	      author : "the-Automator",
	       email : "joe@the-automator.com",
	     crtdate : "",
	     moddate : "",
	   resfolder : A_ScriptDir "\res",
	    iconfile : 'mmcndmgr.dll' , ;A_ScriptDir "\res\UltimateSpybg512.ico",
	      config : A_ScriptDir "\settings.ini",
	homepagetext : "the-automator.com/UltimateSpy",
	homepagelink : "the-automator.com/UltimateSpy?src=app",
	  donateLink : "https://www.paypal.com/donate?hosted_button_id=MBT5HSD9G94N6",
}
; hIcon := LoadPicture("C:\Windows\system32\mmcndmgr.dll", "Icon68", &imgType)
RunasMode := iniread(Script.config, 'Settings', 'Admin','Ask')
if RunasMode = 'Ask'
&& !A_IsAdmin
{
	Askwidth := 250
	Askheight := 100
	dontAsk := Gui('+AlwaysOnTop -sysmenu','Ultimate Spy: Ask for Admin Mode')
	dontAsk.AddText('y20','Would you like to Run As Admin?')
	dontAsk.AddText('xs yp+30','Do not ask again')
	dontAsk.AddCheckbox('yp vAdminMode','')

	dontAsk.AddButton('x' Askwidth - 150 -20 ' w75','Yes').OnEvent('click',RunMode)
	dontAsk.AddButton('yp w75','No').OnEvent('click',RunMode)

	dontAsk.Show('h' Askheight ' w' Askwidth)

	while WinExist('Ultimate Spy: Ask for Admin Mode')
		sleep 200
}

SwDelay := IniRead(script.config,'ClosingIssue','SwitchingDelayBetweenTools',0)
if !SwDelay
{
	comment := '# increase the delay for slower PC'
	IniWrite(SwDelay := 500 ,script.config,'ClosingIssue', comment '`n' 'SwitchingDelayBetweenTools')
}

LastSpyX := A_ScreenWidth / 2
LastSpyY := A_ScreenHeight / 2

TraySetIcon script.iconfile, 84 ; shell.dll 23

tray := A_TrayMenu
tray.Delete()
tray.Add("About",(*) => Script.About())
tray.Add("Donate",(*) => Run(script.donateLink))
tray.Add()
tray.Add('Reset Settings' , ResetMode)
tray.Add()
tray.AddStandard()

if !A_IsAdmin
&& RunasMode = 'Yes'
{
	try Run '*runas ' A_ScriptFullPath
	ExitApp
}

SpyPid := 0
SpyHwnd := 0

SpyList := Map()
ddList := []

DiscoveryRefs := Map(
		'Win32 Menu', {spy:'Menu|SPY', ico:"⚪️",space:'  '},
		'Win32',      {spy:'SPY',      ico:'⚫️',space:'  '},
		'StatusBar',  {spy:'SPY',      ico:'⚡️',space:'  '},
		'ImageSearch',{spy:'FindText', ico:'⬜️',space:'  '},
		'COM',        {spy:'CLSID|COM',ico:'🔆',space:'  '},
		'Rufaydium',  {spy:'',         ico:'🔷',space:'  '},
		'ACC',        {spy:'ACC',      ico:'🅰',space:'  '}, ; 
		'UIA',        {spy:'UIA',      ico:'💊',space:'  '},
		'Messages',   {spy:'WinSpy',   ico:'🔍',space:'  '}
	)

loop files, A_ScriptDir '\inc\*'
	if A_LoopFileExt ~= 'ahk|ah2|exe'
	{
		spaces := ""
		SplitPath(A_LoopFileFullPath,,,,&NameNoExt)

		SPYIcons := ""
		for key, refs in DiscoveryRefs
		{
			if refs.spy
			&& RegExMatch(NameNoExt,'i)' refs.spy)
			{
				SPYIcons .= refs.ico 
				Spaces .= refs.space
			}
		}	
		spaces := Format('{:' (x := (StrLen(Spaces)) - 9) '}', ' ')
		SpyList[spaces SPYIcons ' ' NameNoExt] := A_LoopFileFullPath
		if InStr(NameNoExt,'Discovery')
			ddList.Push(spaces SPYIcons ' ' NameNoExt)


	}

for Name, Path in SpyList
{
	spaces := ''
	if InStr(Name,'Discovery')
	{
		defaultSpy := Name
		continue
	}
	; SPYIcons := ""
	; for key, refs in DiscoveryRefs
	; {
	; 	if refs.spy
	; 	&& RegExMatch(Name,'i)' refs.spy)
	; 	{
	; 		SPYIcons .= refs.ico 
	; 		Spaces .= refs.space
	; 	}
	; }	
	; spaces := Format('{:' (x := (StrLen(Spaces)) - 9) '}', ' ')
	; ddList.Push(spaces SPYIcons ' ' Name)
	ddList.Push(Name)
}

ddList.Push('Close')

uGui.LastSpy := ""
uGui.SetFont('s10','Courier New')
uGui.OnEvent('close',(*)=>ExitApp())
uGui.MarginX := 2
uGui.MarginY := 2
if A_IsAdmin
	uGui.backColor := 'Red'
else 
	uGui.backColor := 'Green'
ddl := uGui.AddDropDownList('w200  vCurSpy',ddList)
ddl.OnEvent('Change',SpyChange)
uGui.Show()

if IsSet(defaultSpy)
{
	ddl.Text := defaultSpy
	SpyChange()
}

OnExit CloseRunnningSpy
SetTimer AttachDDL,10

ResetMode(*)
{
	IniWrite('Ask',Script.config, 'Settings', 'Admin')
	if RunasMode = 'No'
		reload
	else
	{
		msgbox 'Please Exit and Restart UltimateSpy`nDo not Reload', 'UltimateSpy:Reset',4096
	}
	; Run A_ScriptFullPath
	; ExitApp

}


RunMode(ctrl,info)
{
	global RunasMode
	RunasMode := ctrl.Text
	dontAsk.submit()
	if dontAsk['AdminMode'].Value
		IniWrite ctrl.Text, Script.config, 'Settings', 'Admin'
	else
		IniWrite 'Ask', Script.config, 'Settings', 'Admin'
	dontAsk.Destroy()
}

SpyChange(obj?, *)
{
	Global SpyHwnd, SpyPid, ddl, LastSpyX, LastSpyY
	Static LastSpy := 0

	/*     
	static titles := Map(
		'the-AutomatorSpy.exe', 'title'
	)
 	*/
	if LastSpy = uGui['CurSpy'].Text
		return
	uGui.show('hide')

	if IsSet(obj) && obj = ddl
		CloseRunnningSpy()

	if uGui['CurSpy'].Text = 'close'
		exitapp()

	ahkGui := 'ahk_class AutoHotkeyGUI'


	while WinActive('ahk_class AutoHotkeyGUI')
		WinMinimize()

	Run SpyList[uGui['CurSpy'].Text]
	if !WinWaitActive("ahk_class AutoHotkeyGUI",,3)
			reload

	SpyHwnd := WinGetID()
	WinMove(LastSpyX,LastSpyY,,,'ahk_id ' SpyHwnd )
	SpyPid  := WinGetPID()

	WinSetStyle(+0x94CE0000,'ahk_id ' SpyHwnd) ; change Spy window style to support ssame padding settings
	padding := 14
	ypad := 10
	xpad := 10

	try WinSetAlwaysOnTop(true, SpyHwnd)
	;DISABLE(SpyHwnd)
	WinGetPos(&x,&y,&w,&h, 'ahk_id ' SpyHwnd )
	; LastSpyX := x
	; LastSpyY := x
	uGui.show('x' LastSpyX+xpad ' y' LastSpyY+h-ypad ' w' w - padding)
	ddl.Move(,, w - padding)
	uGui.LastSpy :=  LastSpy := uGui['CurSpy'].Text
	
}


CastBorder(SpyHwnd)
{
	if hwnd := WinActive('a')
	{
		Class := WinGetClass(hwnd) 
		if Class = 'AutoHotkeyGUI'
			return
		Pid := WinGetPID(hwnd)
		
		try 
		{
			if IsProcessElevated(Pid)
			&& !Highlight.marked.Has(hwnd)
			&& uGui.Hwnd != Hwnd
			{
				if SpyHwnd
				&& SpyHwnd != Hwnd
					Highlight.Border(hwnd,2,'Red')
			}
			else if !Highlight.marked.Has(hwnd)
				Highlight.Border(hwnd,2,'green')
		}
		
	} 
}


AttachDDL()
{
	Global LastSpyX, LastSpyY
	; highlight admin widnow
	
	CastBorder(SpyHwnd)
	
	if !SpyHwnd
		return
	
	if SpyPid
	{
		SetTimer CloseApp, -1
	}
	try WinGetPos(&x,&y,&w,&h, 'ahk_id ' SpyHwnd )
	catch
		return ;CloseRunnningSpy()

	; WinSetStyle(+0x94CE0000,'ahk_id ' SpyHwnd)
	padding := 14
	ypad := 8
	xpad := 7

	uGui.Move(x+xpad, y+h-ypad, w - padding ) 
	ddl.Move(2,, w - padding -4) ; removing 4 from the ddl control because of the borders we added
	LastSpyX := x
	LastSpyY := y
}

CloseApp()
{
	sleep SwDelay
	if !WinExist( "ahk_id" . SpyHwnd )
	{
		if uGui.LastSpy ~= 'Discovery Tool'
			ExitApp()

		ddl.Text := defaultSpy
		SpyChange()
	}
}

CloseRunnningSpy(*)
{
	Global SpyPid

	Sleep 500
	if ProcessExist(SpyPid)
	{
	   try
	   {
			WinClose("ahk_id" SpyHwnd)
			ProcessClose(SpyPid)
	   }
	   SpyPid := 0
	}
	Sleep 500
}

; from Skrommels Scripts noclose
DISABLE(id) ;By RealityRipple at http://www.xtremevbtalk.com/archive/index.php/t-258725.html
{
	menu:=DllCall("user32\GetSystemMenu","UInt",id,"UInt",0)
	DllCall("user32\DeleteMenu","UInt",menu,"UInt",0xF060,"UInt",0x0)
}

ENABLE(id) ;By Mosaic1 at http://www.xtremevbtalk.com/archive/index.php/t-258725.html
{
	menu:=DllCall("user32\GetSystemMenu","UInt",id,"UInt",1)
	DllCall("user32\DrawMenuBar","UInt",id)
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