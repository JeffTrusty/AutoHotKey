#Requires AutoHotkey v1.1.37+
#SingleInstance, Force

/*
	DisplayPopupMenuV1.ahk
	* Place this or whatever hotkey / mouse option in your main AHK script
	WheelLeft:: Run("C:\Development\AHK\PopupMenu\DisplayPopupMenuV1.ahk")

	! The code below must be in a seperate file to prevent the main AHK script from being interupted
*/

; Define DevMenu sub-menu
Menu, DevMenu, Add, DevServiceSchedulerServer, MenuHandler
Menu, DevMenu, Add, DevIntegrationServer, MenuHandler
Menu, DevMenu, Add, DevAppDatabaseServer, MenuHandler
Menu, DevMenu, Add, DevRptDatabaseServer, MenuHandler
Menu, DevMenu, Add, DevIpsServer, MenuHandler

; Define TestMenu sub-menu
Menu, TestMenu, Add, TestMenu1, MenuHandler
Menu, TestMenu, Add, TestMenu2, MenuHandler

; Define StageMenu sub-menu
Menu, StageMenu, Add, StageMenu1, MenuHandler
Menu, StageMenu, Add, StageMenu2, MenuHandler

; Define ProductionMenu sub-menu
Menu, ProductionMenu, Add, ProductionMenu1, MenuHandler
Menu, ProductionMenu, Add, ProductionMenu2, MenuHandler

; Create the primary menu and add the sub-menus
Menu, PopupMenu, Add, Dev, :DevMenu
Menu, PopupMenu, Add, Test, :TestMenu
Menu, PopupMenu, Add, Stage, :StageMenu
Menu, PopupMenu, Add, Production, :ProductionMenu
Menu, PopupMenu, Add, Enter, MenuHandler
Menu, PopupMenu, Show
return

MenuHandler(){
	Switch A_ThisMenuItem {
		Case "DevServiceScheduler":
			A_Clipboard := "wn000039362"
			; Send ^v
			Return
		Case "Enter":
			if WinActive("ahk_exe Code.exe")
				Send {Enter}
			else Send "`n"
		Default:
			MsgBox You selected %A_ThisMenuItem% from the menu %A_ThisMenu%.
			Return
	}
	; MsgBox You selected %A_ThisMenuItem% from the menu %A_ThisMenu%.
}