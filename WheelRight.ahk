#Requires AutoHotkey v2.0.2+
#SingleInstance Force
; Create the popup menu by adding some items to it.
MyMenu := Menu()
MyMenu.Add("Item 1", MenuHandler)
MyMenu.Add("Item 2", MenuHandler)
MyMenu.Add()  ; Add a separator line.

; Create another menu destined to become a submenu of the above menu.
Submenu1 := Menu()
Submenu1.Add("Item A", MenuHandler)
Submenu1.Add("Item B", MenuHandler)

; Create a submenu in the first menu (a right-arrow indicator). When the user selects it, the second menu is displayed.
MyMenu.Add("My Submenu", Submenu1)

MyMenu.Add()  ; Add a separator line below the submenu.
MyMenu.Add("Item 3", MenuHandler)  ; Add another menu item beneath the submenu.

MenuHandler(Item, *)
{
  MsgBox("You selected " Item)
}

WheelRight:: MyMenu.Show()  ; i.e. press the Win-Z hotkey to show the menu.
