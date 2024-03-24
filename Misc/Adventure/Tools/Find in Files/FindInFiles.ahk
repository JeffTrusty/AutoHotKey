#SingleInstance, Force

Gui New,, Search and Replace
Gui Font, s9, Segoe UI

Gui Add, Edit, hWndg_hEdtIPC x0 y0 w0 h0 ; For initial focus and data exchange
Gui Show, y100 w900 h484 Hide,Search and Replace

Gui Add, Tab3, hWndhTab x8 y8 w800 h260, Search

Gui Add, Text, x22 y50 w86 h23 +0x200, Search in:
Gui Add, ComboBox, vSearchIn x114 y50 w450, %SearchInHistory%

Gui Add, Button, gBrowse x600 y50 w85 h24, Browse...

Gui Add, Text, x22 y88 w86 h23 +0x200, Filters:
Gui Add, ComboBox, vFilters x114 y86 w450, %FilterHistory%

sw := GuiWidth - 22 - 14 - 6 - 84 - 6
Gui Add, Text, hWndhSep1 x22 y120 w650 h2 +0x10

Gui Add, Text, x22 y130 w86 h23 +0x200, Find Text:
Gui Add, ComboBox, hWndg_hCbxSearch vTextToFind x111 y130 w450, %SearchHistory%
Gui Add, Text, x22 y165 w86 h23 +0x200, Replace With:
Gui Add, ComboBox, hWndg_hCbxReplace vReplaceWith x111 y165 w450, %ReplaceHistory%

Gui Add, Text, hWndhSep2 x22 y195 w650 h2 +0x10

Gui Add, CheckBox, vChkRecurse x22 y196 w160 h23, &Search subdirectories

Gui, Tab

x := GuiWidth - 84 - 6
Gui Add, Button, gPerformSearch x695 y7 w84 h24 +Default, Start
Gui Add, Button, gCancelSearch x695 y38 w84 h24, Cancel
Gui Add, Button, gShowHelp x695 y69 w84 h24, Help

Gui Add, StatusBar, vStatusBar
GuiControlGet sb, Pos, msctls_statusbar321

Gui Show
return

Browse:
FileSelectFolder, vSearchFolderPath,, 3
GuiControl,, SearchFolderPath, "%vSearchFolderPath%"
return

PerformSearch:
    Gui Submit, NoHide

; from: https://www.autohotkey.com/board/topic/94861-search-for-a-string-in-all-files-in-a-folder/
msgbox,% findstring("a_index", "*.ahk")
; edit: changed pattern to filepattern to reduce "confusion".
findstring(string, filepattern = "*.*", rec = 0, case = 0){
    len := strlen(string)
    if (len = 0)
        return
    loop,% filepattern, 0,% rec
    {
        fileread, x,% a_loopfilefullpath
        if (pos := instr(x, string, case)){
            positions .= a_loopfilefullpath "|" pos
            while(pos := instr(x, string, case, pos+len))
                positions .= "|" pos
            positions .= "`n"
        }
    }
    return, positions
}

CancelSearch:
msgbox Cancel
return

ShowHelp:
msgbox Help
Return

GuiEscape:
GuiClose:
  ; msgbox Exiting app.
  ExitApp
