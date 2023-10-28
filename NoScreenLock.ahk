; REMOVED: #NoEnv
#Requires AutoHotkey v2.0
#SingleInstance Force
#NoTrayIcon
Persistent
; MsgBox("Screen Lock Disabled, "  2", "ScreenSaver", "")
CoordMode("Mouse", "Screen")
Loop
{
    ; Move mouse
    MouseMove 1, 1, 0, "R"
    ; Replace mouse to its original location
    MouseMove -1, -1, 0, "R"
    ; Wait before moving the mouse again
    Sleep(600000)
}
