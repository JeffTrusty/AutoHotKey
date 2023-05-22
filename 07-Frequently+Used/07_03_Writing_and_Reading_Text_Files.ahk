#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance,Force
;********************Writing and Reading Text files***********************************
Var:="Just my example`n"
FileAppend,%Var%,Example.txt,UTF-8

FileRead,OutVar,         Example.txt
FileRead,OutVar, *P65001 Example.txt ; with file path

MsgBox % OutVar
;********************Detect if File Exists***********************************

If (FileExist("Example2.txt"))
	MsgBox Found file

;********************Detect if File Does NOT exist***********************************
If (!FileExist("Example2.txt"))
	MsgBox Didn't find the file