#Requires AutoHotkey v2.0.2+
#SingleInstance Force
DetectHiddenWindows true
ListLines True
SetWorkingDir A_InitialWorkingDir

; Define the menu data
menuData := [
  [
    "File",
    "New",
    "Creating a new file"
  ],
  [
    "File",
    "Open",
    "Opening an existing file"
  ],
  [
    "File",
    "Save",
    "Saving the current file"
  ],
  [
    "Edit",
    "Copy",
    "Copying selected text"
  ],
  [
    "Edit",
    "Paste",
    "Pasting copied text"
  ],
  [
    "Edit",
    "Cut",
    "Cutting selected text"
  ],
  [
    "Help",
    "About",
    "About this application"
  ],
  [
    "Help",
    "Documentation",
    "View documentation"
  ]
]

; Create the menu
createMenuFromArray(menuData)

; AutoExecute section ends here

; Hotkeys
^+e:: Edit  ; Ctrl+Shift+E to edit the script
^+Escape:: ExitApp  ; Ctrl+Shift+Escape to exit the script
^+r:: Reload  ; Ctrl+Shift+R to reload the script

; Function to create the menu from the array
createMenuFromArray(menuArray)
{
  ; Create the main menu
  mainMenu := Menu()

  ; Iterate through the menu data
  for item in menuArray
  {
    ; Check if the main menu item exists
    if !mainMenu.HasProp(item[1])
    {
      ; If not, create a new submenu
      mainMenu.%item[1]% := Menu()
    }

    ; Add the submenu item
    mainMenu.%item[1]%.Add(item[2], (*) => setClipboardText(item[3]))
  }

  ; Create a tray menu
  trayMenu := A_TrayMenu
  trayMenu.Delete()  ; Clear default menu items

  ; Add main menu items to the tray menu
  for menuName, submenu in mainMenu.OwnProps()
  {
    trayMenu.Add(menuName, submenu)
  }

  ; Add a separator and exit option
  trayMenu.Add()
  trayMenu.Add("Exit", (*) => ExitApp())
}

; Function to set clipboard text
setClipboardText(text)
{
  A_Clipboard := text  ; Set the clipboard content
  ToolTip("Copied to clipboard: " . text)  ; Show a tooltip
  SetTimer () => ToolTip(), -2000  ; Hide the tooltip after 2 seconds
}
