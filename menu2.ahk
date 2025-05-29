#Requires AutoHotkey v2.0
/*
          From: https://www.autohotkey.com/boards/viewtopic.php?t=122402
*/
; Create a 2-d array for the menu strings ----------------------------------------------------------
Strings := [
  ; Array[1] contains the caption, Array[2] contains the text
  [
    "Prod",
    "Prod-UI-Server",
    "Prod-UI ServerName"
  ],
  [
    "Prod",
    "Prod-API-Server",
    "Prod-API ServerName"
  ],
  [
    "Prod",
    "Prod-DB-Server",
    "Prod-DB ServerName"
  ],
  [
    "Stage",
    "Stage-UI-Server",
    "Stage-UI ServerName"
  ],
  [
    "Stage",
    "Stage-API-Server",
    "Stage-API ServerName"
  ],
  [
    "Stage",
    "Stage-DB-Server",
    "Stage-DB ServerName"
  ],
  [
    "Test",
    "Test-UI-Server",
    "Test-UI ServerName"
  ],
  [
    "Test",
    "Test-API-Server",
    "Test-API ServerName"
  ],
  [
    "Test",
    "Test-DB-Server",
    "Test-DB ServerName"
  ],
  [
    "Dev",
    "Dev-UI-Server",
    "Dev-UI ServerName"
  ],
  [
    "Dev",
    "Dev-API-Server",
    "Dev-API ServerName"
  ],
  [
    "Dev",
    "Dev-DB-Server",
    "Dev-DB ServerName"
  ]
]
; Create the menu ----------------------------------------------------------------------------------
MyMenu := Menu()
For V In Strings
{
  if !MyMenu.HasProp(V[1]) ; If the top level menu doesn't exist, create it
  {
    MyMenu.%V[1]% := Menu()
  }
  MyMenu.%V[1]%.Add(V[2]) ; := Menu() ; , (*) => MenuHandler(V[1], V[2], V[3]) ; Add the submenu item
}

; Ctrl+Mouse Middle Button or Ctrl-7: Show the menu ----------------------------------------------
^MButton::
^7::
{
  MyMenu.Show()
}
; Menu handler ------------------------------------------------------Stage-DB ServerName-------------------------------
MenuHandler(ItemName, ItemPos, ThisMenu)
{
  ; OldClip := ClipboardAll()
  ; A_Clipboard := ThisMenu ; uncomment to set the clipboard
  ; MsgBox(A_Clipboard)
  ; Send("^v")
  ; Sleep 200
  ; Send("{Enter}")
  ; A_Clipboard := OldClip
  ; ToolTip(Strings[ItemPos][2] . "`n`nhas been copied to the clipboard")
  ; SetTimer(() => ToolTip(), -2000)
}


/*
names := [
  'isaias',
  'joe',
  'irfan'
]

main := gui()

main.addedit('vSearch w600').onEvent('Change', Filter)
lv := main.addlistview('w600 r20', ['names'])

for name in names
  lv.add('', name)

main.show()
return

Filter(*)
{
  lv.Opt('-Redraw')
  lv.delete()
  for name in names
  {
    if name ~= 'i)\Q' main['Search'].value '\E'
      lv.Add('', name)
  }
  lv.Opt('+Redraw')
}


*/
