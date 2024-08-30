#Requires AutoHotkey v2.0
#include <ScriptObj\scriptobj>
;#Include <Border>
/*
* ============================================================================ *
* Want a clear path for learning AutoHotkey?                                   *
* Take a look at our AutoHotkey courses here: the-Automator.com/Learn          *
* They're structured in a way to make learning AHK EASY                        *
* And come with a 200% moneyback guarantee so you have NOTHING to risk!        *
* ============================================================================ *
*/
uGui := Gui('+AlwaysOnTop -caption -sysmenu +ToolWindow','the-Automator Ultimate Spy')
; Highlight.Border(ugui)
script := {
	        base : ScriptObj(),
	     version : "1.0.0",
	        hwnd : uGui.Hwnd,
	      author : "the-Automator",
	       email : "joe@the-automator.com",
	     crtdate : "",
	     moddate : "",
	   resfolder : A_ScriptDir "\res",
	    iconfile : 'shell32.dll' , ;A_ScriptDir "\res\UltimateSpybg512.ico",
	   ;  config : A_ScriptDir "\settings.ini",
	homepagetext : "the-automator.com/UltimateSpy",
	homepagelink : "the-automator.com/UltimateSpy?src=app",
	  donateLink : "https://www.paypal.com/donate?hosted_button_id=MBT5HSD9G94N6",
}

LastSpyX := A_ScreenWidth / 2
LastSpyY := A_ScreenHeight / 2

TraySetIcon script.iconfile, 23

tray := A_TrayMenu
tray.Delete()
tray.Add("About",(*) => Script.About())
tray.Add("Donate",(*) => Run(script.donateLink))
tray.Add()
tray.AddStandard()

if !A_IsAdmin
{
	try Run '*runas ' A_ScriptFullPath
	ExitApp
}
SpyPid := 0
SpyHwnd := 0

SpyList := Map()
ddList := []

loop files, A_ScriptDir '\inc\*'
	if A_LoopFileExt ~= 'ahk|ah2|exe'
	{
		SplitPath(A_LoopFileFullPath,,,,&NameNoExt)
		if InStr(NameNoExt,'Discovery')
			ddList.Push(NameNoExt)
		SpyList[NameNoExt] := A_LoopFileFullPath
	}

for Name, Path in SpyList
{
	if InStr(Name,'Discovery')
	{
		defaultSpy := Name
		continue
	}	
	ddList.Push(Name)
}

ddList.Push('Close')

uGui.LastSpy := ""
uGui.OnEvent('close',(*)=>ExitApp())
uGui.MarginX := 2
uGui.MarginY := 2
uGui.backColor := 'Red'
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

AttachDDL()
{
	Global LastSpyX, LastSpyY
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
	loop 6
		 sleep 100
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