#SingleInstance Force ; Replaces the old instance of this script automatically
Gosub, GuiReset
GoSub, MenuChoice
Menu, WindowMenu,Show, 800, 400
ExitApp
Return

GuiReset:
CoordMode, Menu
Gui +LastFound        ; Window open/close detection
hWnd := WinExist()        ; Window open/close detection
DllCall( "RegisterShellHookWindow", UInt,hWnd )
MsgNum := DllCall( "RegisterWindowMessage", Str,"SHELLHOOK" )
OnMessage( MsgNum, "ShellMessage" )

Menu, MenuName, UseErrorLevel

WinGet, OpenWindow, List
Menu, WindowMenu, Delete
Menu, WindowMenu, Add, Rescan Windows, GuiReset
Menu, WindowMenu, Icon, Rescan Windows, C:\Windows\System32\imageres.dll, 140

Loop, %OpenWindow%
{
    WinGetTitle, Title, % "ahk_id " OpenWindow%A_Index%
    WinGetClass, Class, % "ahk_id " OpenWindow%A_Index%
    WinGet, AppName, ProcessPath, %Title%

    If (Title != "" and Class != "BasicWindow" and Title != "Start")
        ; and Title != "Program Manager")
    {
        Title := StrSplit(Title,"|")
        Menu, WindowMenu, Insert,, % Title[1] . " |" . OpenWindow%A_Index%, MenuChoice
        Menu, WindowMenu, Icon, % Title[1] . " |" . OpenWindow%A_Index%, %AppName%
        If ErrorLevel
            Menu, WindowMenu, Icon, % Title[1] . " |" . OpenWindow%A_Index%
        , C:\WINDOWS\System32\SHELL32.dll,36
    }
}

Return

MenuChoice:

ProcessID := StrSplit(A_ThisMenuItem,"|")
WinActivate, % "ahk_id " ProcessID[2]
WinMove, % "ahk_id " ProcessID[2],,0,0
Return
