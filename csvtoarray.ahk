#Requires AutoHotkey v2.0.2+
#SingleInstance Force
DetectHiddenWindows true
ListLines True
SetWorkingDir A_InitialWorkingDir

; Auto-execute section
csvData := readCsvFile("servers2.csv")
displayCsvData(csvData)

; Hotkeys
^+e:: Edit
^+Escape:: Exitapp
^+r:: Reload

; Function to read CSV file
readCsvFile(fileName)
{
  csvArray := []

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
        csvArray.Push([
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

  return csvArray
}

; Function to display CSV data
displayCsvData(csvArray)
{
  displayText := ""

  ; Loop through the array and format the data for display
  for row in csvArray
  {
    displayText .= "Column 1: " . row[1] . ", Column 2: " . row[2] . "`n"
    ; displayText .= "Column 1: " . row[1] . ", Column 2: " . row[2] . ", Column 3: " . row[3] . "`n"
  }

  ; Show the data in a message box
  MsgBox("CSV Data:`n`n" . displayText)
}
