#Requires Autohotkey v1.1.31.01+

; SearchPath := "U:\JeffAudioBooks"
SearchPath := "\\TrustyServer\Media\JeffAudioBooks"
; SetWorkingDir U:\JeffAudioBooks ; worked
SetWorkingDir %SearchPath%

FileNameFilter := "*.m4b"

Loop Files, %FileNameFilter%, R
{
	Msgbox %A_LoopFileFullPath%
}
; MsgBox %A_WorkingDir%