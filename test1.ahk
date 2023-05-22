#NoEnv
#SingleInstance, Force
; #Persistent ; Keep script running
SendMode Input
SetWorkingDir, %A_ScriptDir%

ControlGet,Var,List,,ComboBox1,ahk_class #32770
MsgBox % Var


