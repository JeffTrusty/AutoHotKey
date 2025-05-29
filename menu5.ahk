#Requires AutoHotkey v2.0.2+
#SingleInstance Force
DetectHiddenWindows true
ListLines True
SetWorkingDir A_InitialWorkingDir
Persistent

dataArray := []
csvData := readCsvFile("servers2.csv")

; Create the main menu
mainMenu := Menu()

; build the menu

; createMenuFromArray(csvData)
{
  ; Iterate through the menu data
  for item in csvData
  {

    ; Add the menu item
    mainMenu.Add(item[1], MenuHandler)
  }

}


MenuHandler(text, *)
{
  MsgBox("You selected " item)
}


; Hotkeys
; ^+Escape:: Exitapp
; ^+r:: Reload
WheelRight:: mainMenu.Show()

; Function to read CSV file
readCsvFile(fileName)
{
  ; global csvData
  try
  {
    ; Open the file for reading
    fileObj := FileOpen(fileName, "r")

    ; Read the file line by line
    while !fileObj.AtEOF
    {
      line := fileObj.ReadLine()

      ; Split the line into columns
      columns := StrSplit(line, ",")

      ; Ensure we have exactly 3 columns
      if (columns.Length == 2)
      {
        ; Add the columns to the array
        dataArray.Push([
          columns[1],
          columns[2]
          ; columns[3]
        ])
      }
    }

    ; Close the file
    fileObj.Close()
  }
  catch Error as err
  {
    MsgBox("Error reading CSV file: " . err.Message)
  }

  return dataArray
}


; ; Function to set clipboard text
; setClipboardText(text, *)
; {
;   A_Clipboard := text  ; Set the clipboard content
;   ToolTip("Copied to clipboard: " . text)  ; Show a tooltip
;   SetTimer () => ToolTip(), -2000  ; Hide the tooltip after 2 seconds
; }
