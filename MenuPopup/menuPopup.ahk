#Requires AutoHotkey v2.0
#SingleInstance Force

/*

Script was obtained at: https://www.autohotkey.com/boards/viewtopic.php?t=122402

*/

MenuItems := readCsvFile("menus.csv")
primaryMenu := ""


/*     Create the menu      */
menuPopup := Menu()
menuPopup.SetColor("ffffff", true)

For menuItem In MenuItems

  If (menuItem[1] != primaryMenu)
  {
    primaryMenu := menuItem[1]
    /* Add the primary menu item */
    menuPopup.Add(menuItem[1], MenuHandler) ; not sure how to pass 4 array items to the MenuHandler
  }
  ; not sure how to build the sub-menu



/*    Windows-Q or Ctrl+Shift+Middle Mouse button: Show the menu  */
#Q::
^+MButton:: menuPopup.Show()

/*    Menu handlers      */

MenuHandler(ItemName, ItemPos, ThisMenu) ; not sure how to receive 4 array items
{
  mainMenu := MenuItems[ItemPos][1]
  subMenu := MenuItems[ItemPos][2]
  actionType := MenuItems[ItemPos][3]
  actionValue := MenuItems[ItemPos][4]

  Switch mainMenu
  {
    case "Prod":
      MsgBox("Production Server")
    case "Stage":
      MsgBox("Stage Server")
    case "Test":
      MsgBox("Test Server")
    case "Dev":
      MsgBox("Dev Server")
    case "SendText":
      MsgBox("Sending text")
    case "Run":
      MsgBox("Run")
    default:
      MsgBox(mainMenu)
  }
}
/*     Function to read CSV file       */
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
      if (columns.Length == 4)
      {
        ; Add the columns to the array
        csvArray.Push([
          columns[1],
          columns[2],
          columns[3],
          columns[4]
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
