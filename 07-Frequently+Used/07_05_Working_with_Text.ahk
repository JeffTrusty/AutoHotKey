#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance,Force

;********************String Manipulation***********************************
Txt:=" The quick brown Fox and brown Dog "
;~ 
Txt:=StrReplace(Txt,"brown","blue",Cnt)  ;Replaces a string with a new string
txt:=Trim(Txt) ;Trim charachters off a string.  Ltrim() and RTrim
nmb:="0023220"
MsgBox % RTrim(nmb,"0")
MsgBox % InStr(Txt,"foxdd")  ;Searches for charachters in a string
MsgBox % StrLen(txt)  ;Returns the count (Length) of how many characters are in a string
Sub:=Trim(SubStr(Txt,1,4))  ;Retrieves character(s) from a specified position in a string
MsgBox % "|" Sub "|"
MsgBox % StrSplit(Txt,"b").3
Parsed:=StrSplit(Txt," ")  ;Parses a string into an array of substrings
MsgBox % Parsed.2 a_tab parsed.3 a_tab parsed.4
MsgBox % "|" Txt "|"

Text:="`nathis`na`nis`na`nmulti-line`na`ntext"
MsgBox % text
Sort,Text,U
MsgBox % text



;********************Advanced- but great to know they exist!***********************************
;~ RegExMatch()  ;Looks for a pattern in a string (Regular Expression)
;~ RegExReplace()  ;Replaces strings inside a string that match a pattern

 ;~ The quick brown Fox