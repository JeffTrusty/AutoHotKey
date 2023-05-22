;*******************************************************
; Want a clear path for learning AutoHotkey; Take a look at our AutoHotkey Udemy courses.  They're structured in a way to make learning AHK EASY
; Right now you can  get a coupon code here: https://the-Automator.com/Learn
;*******************************************************
#SingleInstance,Force
;SKAN  https://autohotkey.com/board/topic/20642-consolidating-tray-icons/
;Tweaks made by the-Automator on 4/29/2021
#Persistent ; Master TrayIcon to control all running instances of AutoHotkey
Menu, Tray, Icon, User32.DLL, 4 ;If this causes an error, comment it out.
DetectHiddenWindows, On
SelfID := WinExist( A_ScriptFullPath " ahk_class AutoHotkey")
Menu, Tray, NoStandard ;disable standard menu
WinGet, AList, List, ahk_class AutoHotkey ;get list of all AutoHotkey scripts
Loop %AList% {
	ID := AList%A_Index%
	IfEqual, ID, %SelfID%, Continue ;if the ahk script is this script, ddn't proceed
	WinGetTitle, ATitle, ahk_id %ID%
	ATitle1:=Format("{:U}",SubStr(ATitle,1,InStr(ATitle,"-",0,0,1)-1))
	SplitPath, ATitle1, Name
	Menu,%Name%,Add, %A_Index%:Reload , MenuChoice
	Menu,%Name%,Add, %A_Index%:Edit   , MenuChoice
	Menu,%Name%,Add, %A_Index%:Pause  , MenuChoice
	Menu,%Name%,Add, %A_Index%:Suspend, MenuChoice
	Menu,%Name%,Add, %A_Index%:Exit   , MenuChoice
	Menu, Tray, Add, %Name%,  :%Name%
}
Menu, Tray, Add ;Insert a blank line in menus for a break
Menu, Tray, Add, Quick Reload, Reload
Menu, Tray, Default, Quick Reload ;set it so reload is the default if clicking
Menu, Tray, Click, 1 ;single click to reload
;~ Menu, Tray, Standard ;add standard options to menu ;Joe Glines changed this.  If you want the other options in your menu uncomment this line
Return

MenuChoice:
F:=StrSplit(A_ThisMenuItem,":")
ControlHWND := "AList" f[1] ;need to put it into a variable so we can have dynamic reference later
if (F.2 = "Reload")
	PostMessage,0x111,65400,0,,% "ahk_id " %ControlHWND%
if (F.2="Edit")
	PostMessage,0x111,65401,0,,% "ahk_id " %ControlHWND%
if (F.2 = "Pause")
	PostMessage,0x111,65403,0,,% "ahk_id " %ControlHWND%
if (F.2 = "Suspend")
	PostMessage,0x111,65404,0,,% "ahk_id " %ControlHWND%
if (F.2 = "Exit")
	PostMessage,0x111,65405,0,,% "ahk_id " %ControlHWND%
Return

Reload:
Reload
Return

esc::exitapp