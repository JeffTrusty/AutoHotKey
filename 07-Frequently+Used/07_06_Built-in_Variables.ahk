#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance,Force
A_Enter:="`r`n"

;~ use period . for Continuation from previous line
/*
	MsgBox % "Hello, How are you doing today, I'm doing great.  What else is going on with you? `n`n"
	 . "Not much, how are you?`n`n"
	 . "very cool!"
*/
;~ Can use a comma , to have write multiple sub-expressions on a single line
x:="10", y:="20" , z:="30"
;~ MsgBox % X A_tab Y A_Enter  Z

;********************special Charchters***********************************
;~ A_Space A_Tab

;********************Some frequently used Built-in Variables***********************************
;~ A_WorkingDir, A_ScriptDir, A_ScriptName
;~ A_OSVersion, A_OSType, A_ScreenHeight, A_ScreenWidth, A_MyDocuments, A_Startup, A_Programs, A_AppData, A_ComputerName A_UserName
;~ MsgBox % A_DDD a_tab  A_MMM a_tab A_DD a_tab  A_MM a_tab  A_YYYY a_tab  A_Now ;A_Hour  A_Min, A_Sec, 
;~ ^t::
;~ Clipboard:="AutoHotkey rocks!"
;~ Send, ^v

;~ AutoHotkey rocks!AutoHotkey rocks!
;~ loop
;~ MsgBox % A_Index