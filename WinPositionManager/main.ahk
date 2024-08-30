#NoEnv
#SingleInstance Force
#Persistent
SetBatchLines, -1
#Include <json>
#Include <JSON_FromObj>
#Include <json_beautifier>
global currentMonitor := 1

F1:: ; Save Config
windowData := {}
Loop, Files, data\monitor\%currentMonitor%\*.json
{
	FileDelete, data\monitor\%currentMonitor%\%A_LoopFileName%
}
for k, v in getWindows()
{
	FileAppend, % JSON_Beautify(json_fromobj(v)), % "data\monitor\" currentMonitor "\" v.exe "_" v.class ".json"
}
return

F2:: ; Load Config
windowData := {}
for k, v in getWindows_Json()
{
	if(WinExist(v.title " ahk_class " v.class " ahk_exe " v.exe))
	{
		WinMove, % v.title " ahk_class " v.class " ahk_exe " v.exe,, % v.x, v.y, v.w, v.h
		;~ MsgBox, % "Moving " v.title " to: " v.x " - " v.y " - " v.w " - " v.h
	}
}
return

F3:: ; Open config gui
	if(!WinExist("WinPos Manager Config"))
	{
		Gui Font, s16 Bold
		Gui Add, Button, x16 y56 w184 h65 gmonitor1, First Monitor
		Gui Add, Button, x240 y56 w184 h65 gmonitor2, Second Monitor
		Gui Font, s14
		Gui Add, Text, x18 y13 w407 h23 +0x200 +Center, Monitor Layout in use?
		Gui Show, w438 h143, WinPos Manager Config
	}else
	{
		WinActivate, WinPos Manager Config
	}
return

getWindows_Json()
{
	winList := {}
	Loop, Files, data\monitor\%currentMonitor%\*.json
	{
		FileRead, file, data\monitor\%currentMonitor%\%A_LoopFileName%
		win := JSON.Load(file)
		winList[winList.length()+1] := win 
	}
	return winList
}

getWindows()
{
	winList := {}
    WinGet, OpenWindow, List 
    Loop, %OpenWindow%
    {
        WinGetTitle, title, % "ahk_id " OpenWindow%A_Index%
        WinGetClass, class, % "ahk_id " OpenWindow%A_Index%
		WinGet, exe, ProcessName, % "ahk_id " OpenWindow%A_Index%
		WinGetPos, x, y, w, h, % "ahk_id " OpenWindow%A_Index%
        if(Title != "") 
		{
			win := {}
            win["title"] := title
            win["class"] := class
            win["exe"] := exe
            win["x"] := x
            win["y"] := y
            win["w"] := w
            win["h"] := h
			winList[winList.length()+1] := win 
		}
    }
    return winList
}

monitor1:
	currentMonitor := 1
	Gui, Destroy
return

monitor2:
	currentMonitor := 2
	Gui, Destroy
return

Esc::ExitApp