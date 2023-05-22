#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance,Force
;********************Buit-in Variables:   File Paths / Windows Paths***********************************
;~ MsgBox % A_ScriptDir
Path:= A_ScriptFullPath
;~ MsgBox % A_WinDir
;~ MsgBox % A_ProgramFiles "`n" A_MyDocuments

SplitPath,Path,OFN,OtD,EXT,FNnE,Drive
ListVars
MsgBox pause