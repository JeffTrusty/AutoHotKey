#Requires Autohotkey v1.1.31.01+
#SingleInstance Force
#NoEnv
SetWorkingDir %A_ScriptDir%
SetBatchLines -1
FilesFound := []
Files := ""
FileContainsSearchFor := True
LaunchPath := A_WorkingDir

Gui Font, s8, Verdana
Gui Add, Tab3, x32 y16 w750 h420, Main|Servers|Extentions
Gui Add, Text, x55 y80 w75 h23, Search For:
Gui Add, Edit, x175 y80 w120 h21 vSearchFor
Gui Add, Button, x330 y80 w80 h23 gFindFiles, &Find Files
Gui Add, Text, x55 y115 w97 h23, Replace With:
Gui Add, Edit, x175 y115 w120 h21 vReplaceWith
Gui Add, Button, x330 y115 w80 h23 +Disabled gReplaceFiles vReplaceButton, &Replace
Gui Add, CheckBox, x55 y157 w120 h23 +Checked vBackup, Create Backup
Gui Add, Button, x330 y155 gView Default, View Selected
Gui Add, ListBox, x55 y192 w700 r17 vFilesListBox, %FileList%
Gui Tab, Servers
Gui Add, Edit, x40 y48 w200 r20 vServerList,
Gui Add, Button, x40 y368 w80 h23 gSaveServers, &Save
Gui Tab, Extentions
Gui Add, Edit, x40 y48 w100 r20 vExtentionList,
Gui Add, Button, x40 y368 w80 h23 gSaveExtentions, &Save
Gui Tab

; Read ServerList
if !FileExist("Servers.txt")
  FileAppend `n, Servers.txt
FileRead, ServerList, Servers.txt
ServerArray := StrSplit(ServerList, "`r`n")
GuiControl,, ServerList,%ServerList%

; Read ExtentionList
if !FileExist("Extentions.txt")
  FileAppend `n, Extentions.txt
FileRead, ExtentionList, Extentions.txt
Extentions := StrReplace(ExtentionList,"`r`n", ",")
ExtentionArray := StrSplit(ExtentionList, "`r`n")
GuiControl,, ExtentionList,%ExtentionList%

Gui Show, x-810 y-200 w800 h450, Find In Files
Return

GuiEscape:
GuiClose:
ExitApp

FindFiles:
  {
    Gui Submit, NoHide
    FileList := ""
    FilesFound := []
    GuiControl,, Files

    SearchPath := ""
    For Each, Server In ServerArray
    {
      SearchPath .= "\\"
      SearchPath .= Server 
      ; SearchPath .= "\Media\JeffAudioBooks\" ; Change to "\Apps\" in work environment
      SearchPath .= "\Media\Apps\" ; Change to "\Apps\" in work environment
      WorkingDir := SearchPath
      SetWorkingDir %SearchPath%

      SearchPath := "*"
      ; MsgBox Looking for: `n`t%SearchFor% `nIn files with extentions:`n%extentions% `nin: `n%A_WorkingDir%
      Loop, Files, *, R  ; Recurse into subfolders.
      {
        SplitPath, A_LoopFileFullPath,,, Ext
        If Ext in %extentions%
        {
        ; DoSearchFile with A_LoopFileFullPath
          ; If InStr(A_LoopFileFullPath, SearchFor)
          ;   {
          ;     FilesFound.Push(A_LoopFileLongPath)
          ;   }

          FileRead, FileContents, % A_LoopFileLongPath
          ; MsgBox, "Read File: %A_LoopFileLongPath%"
          ; MsgBox, %FileContents%

          If InStr(FileContents, SearchFor)
          {
            ; MsgBox %FileContents%
            FilesFound.Push(A_LoopFileLongPath)
          }
        }
      }
    }

    For Each, File In FilesFound
      {
        FileList .= File ; add the full path and filename to the Files string
        FileLIst .= "|" ; add pipe to the Files string
      }
    ; MsgBox %FileList%
    GuiControl, , FilesListBox, |%FileList%

    GuiControl,Enable,ReplaceButton
    Gui, Submit, nohide
    Return
  }

SearchFile:
  {
    FileContainsSearchFor := false
    ; Open and search A_LoopFileFullPath
    ; if found, set FileContainsSearchFor := true
    Return
  }

ReplaceFiles:
  {
    Gui Submit, NoHide
    ; MsgBox % ReplaceWith
    ; Do replace here
    For Each, File In FilesFound
    {
      ; MsgBox % File
      FileRead, FileContents, %File%
      StringReplace, FileContents, FileContents, %SearchFor%, %ReplaceWith%, ReplaceAll
      ; MsgBox % FileContents
      If Backup
      {
        ; MsgBox "Copy %File% To: %File%_Backup_%A_YYYY%-%A_MM%-%A_DD%_%A_Hour%%A_Min%.bak"
        FileMove, %File%, %File%_Backup_%A_YYYY%-%A_MM%-%A_DD%_%A_Hour%%A_Min%.bak
        ; MsgBox % A_LastError
      }
      FileHandle := FileOpen(File,"w") ; Open and clear the file
      FileHandle.Close() ; close the file
      FileAppend, %FileContents%, %File%
    }
    Return
  }

  View:
  {
    Gui, Submit
    FileRead, FileContents, %FilesListBox%
    MsgBox % FileContents
    Gui Show
    ; Run, NotePad.exe """%FilesListBox%"""
    Return
  }

  SaveServers:
  {
    Gui Submit, NoHide
    ; MsgBox % ServerList
    ; Save server list
    FileDelete, Servers.txt
    FileAppend, %ServerList%, %LaunchPath%\Servers.txt
    ServerArray := StrSplit ServerList, "`r`n"
    Return
  }

  SaveExtentions:
  {
    Gui Submit, NoHide
    ; MsgBox, % ExtentionList
    ; Save extention list
    FileDelete, Extentions.txt
    FileAppend, %ExtentionList%, %LaunchPath%\Extentions.txt
    ExtentionArray := StrSplit ExtentionList, "`r`n"
    Return
  }
