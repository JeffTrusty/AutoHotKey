#SingleInstance Force
OutputFolder := "C:\Development\AHK\GUIs\"


; Prefix variable names with the letter v
;Gui, Add, dropdownlist, vOption, Option 1|Option 2|Option 3
myGui := Gui()
myGui.OnEvent("Close", GuiEscape)
myGui.OnEvent("Escape", GuiEscape)
myGui.New(, "Search & Replace")

myGui.Add("Text", , "Folder to Search:")
ogcEditSearchFolderPath := myGui.Add("Edit", "w400 vSearchFolderPath X+5")
ogcButton := myGui.Add("Button", "x+5", "...")
ogcButton.OnEvent("Click", GetFolderPath.Bind("Normal"))

myGui.Add("Text", "xm", "Text to Find:")
ogcEditTextToFind := myGui.Add("Edit", "w400 vTextToFind X+22")

myGui.Add("Text", "xm", "Replace With:")
ogcEditReplaceWith := myGui.Add("Edit", "w400 vReplaceWith X+12")


; prefix subroutine names with the letter g
; Gui, Add, Text, Y+20 w400 +0x10 ; Seperator line
myGui.add("text", "0x10 w525 xm")
ogcButtonExecute := myGui.Add("Button", "w75  Default", "Execute")
ogcButtonExecute.OnEvent("Click", Submit.Bind("Normal")) ; Default option sets Enter as hot key
ogcButtonSaveSettings := myGui.Add("Button", "X+10", "&Save Settings")
ogcButtonSaveSettings.OnEvent("Click", SaveSettings.Bind("Normal")) ; & here sets Alt-S as hot key
myGui.Show()
return

; Subroutine name
Submit(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
oSaved := myGui.Submit("0")
SearchFolderPath := oSaved.SearchFolderPath
TextToFind := oSaved.TextToFind
ReplaceWith := oSaved.ReplaceWith
MsgBox(SearchFolderPath)
MsgBox(TextToFind)
MsgBox(ReplaceWith)
return
} ; V1toV2: Added bracket before function

GetFolderPath(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
vSearchFolderPath := DirSelect(, 3)
ogcEditSearchFolderPath.Value := "`"" vSearchFolderPath "`""
return
} ; V1toV2: Added Bracket before label

SaveSettings(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
  MsgBox(OutputFolder)
return
} ; V1toV2: Added bracket before function

GuiEscape(*)
{ ; V1toV2: Added bracket
GuiClose:
  ; msgbox Exiting app.
  ExitApp()


} ; Added bracket in the end


