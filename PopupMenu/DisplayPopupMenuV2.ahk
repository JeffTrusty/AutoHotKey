#Requires AutoHotkey v2.0+
#SingleInstance Force

; Create the popup menu by adding some items to it.
PopupMenu := Menu()

; Create another menu destined to become a submenu of the above menu.
DevMenu := Menu()
DevMenu.Add "DevServiceSchedulerServer", MenuHandler
DevMenu.Add "DevIntegrationServer", MenuHandler
DevMenu.Add "DevAppDatabaseServer", MenuHandler
DevMenu.Add "DevRptDatabaseServer", MenuHandler
DevMenu.Add "DevIpsServer", MenuHandler

TestMenu := Menu()
TestMenu.Add "Test Item A", MenuHandler
TestMenu.Add "Test Item B", MenuHandler

StageMenu := Menu()
StageMenu.Add "Test Item A", MenuHandler
StageMenu.Add "Test Item B", MenuHandler

ProductionMenu := Menu()
ProductionMenu.Add "Test Item A", MenuHandler
ProductionMenu.Add "Test Item B", MenuHandler

; Add submenus in the first menu (a right-arrow indicator). When the user selects it, the second menu is displayed.
PopupMenu.Add "DevMenu", DevMenu
PopupMenu.Add "TestMenu", TestMenu
PopupMenu.Add "StageMenu", StageMenu
PopupMenu.Add "ProductionMenu", ProductionMenu

PopupMenu.Add  ; Add a separator line below the submenu.
PopupMenu.Add "Enter", MenuHandler  ; Add another menu item beneath the submenu.

MenuHandler(Item, *) {
	Switch Item {
		Case "DevServiceScheduler":
			A_Clipboard := "wn000039362"
			; Send("^v")
			Return
		Case "Enter":
			if WinActive("ahk_exe Code.exe")
				Send("{Enter}")
			else Send "`n"
	default:
		MsgBox "You selected " Item
		Return
	}
}
PopupMenu.Show
