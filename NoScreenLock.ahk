#NoEnv
#SingleInstance, Force
#NoTrayIcon
#Persistent
MsgBox,,ScreenSaver, Screen Lock Disabled, % 2
CoordMode, Mouse, Screen
Loop
{
    ; Move mouse
    MouseMove, 1, 1, 0, R
    ; Replace mouse to its original location
    MouseMove, -1, -1, 0, R
    ; Wait before moving the mouse again
    Sleep, 600000
}
