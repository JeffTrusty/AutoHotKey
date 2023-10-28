#SingleInstance
#Requires AutoHotkey v2.0

filePath := FileSelect() ; Function to get path & filename of text file
txt := filePath

; Use function to get and store counts
charCount := StrSplit(txt, "", "`r`n").Length
lineCount := StrSplit(txt, "`n", "`r").Length
wordCount := StrSplit(txt, [A_Space, "`n"], "`r`n").Length

; Command syntax as we don't need to capture any return information
MsgBox "Select file has: `n" charCount " Characters: `n" lineCount " Lines`n" wordCount " Words."

return ; End of auto-execute section
