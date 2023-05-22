#SingleInstance, Force
OutputFolder := "C:\Development\AHK\GUIs\"


; Prefix variable names with the letter v
;Gui, Add, dropdownlist, vOption, Option 1|Option 2|Option 3
Gui, New,, Search & Replace

Gui, Add, Text,, Folder to Search:
Gui, Add, Edit, w400 vSearchFolderPath X+5
Gui, Add, Button, gGetFolderPath x+5, ...

Gui, Add, Text, xm, Text to Find:
Gui, Add, Edit, w400 vTextToFind X+22

Gui, Add, Text, xm, Replace With:
Gui, Add, Edit, w400 vReplaceWith X+12


; prefix subroutine names with the letter g
; Gui, Add, Text, Y+20 w400 +0x10 ; Seperator line
Gui, add, text, 0x10 w525 xm
Gui, Add, Button, w75 gSubmit Default, Execute ; Default option sets Enter as hot key
Gui, Add, Button, X+10 gSaveSettings, &Save Settings ; & here sets Alt-S as hot key
Gui Show
return

; Subroutine name
Submit:
Gui Submit, Nohide
msgbox %SearchFolderPath%
msgbox %TextToFind%
msgbox %ReplaceWith%
return

GetFolderPath:
FileSelectFolder, vSearchFolderPath,, 3
GuiControl,, SearchFolderPath, "%vSearchFolderPath%"
return

SaveSettings:
  msgbox %OutputFolder%
return

GuiEscape:
GuiClose:
  ; msgbox Exiting app.
  ExitApp
