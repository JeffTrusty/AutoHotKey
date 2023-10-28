#SingleInstance
#Requires Autohotkey v2.0+ 64-Bit

main := Gui('Resize', 'Window Title') ; options: +ToolWindow, +Resize, -Caption, +AlwaysOnTop
/*
	There are 2 ways to add controls
	1. main.Add('ControlType', 'Options','Initial value')
	2. main.AddEdit('Options','Initial value') ; Control type is not needed as the AddButton method defines the control type
*/

/*
	Positioning Controls:
	Position controls relative to other controls.
	yp places the control next to the previous control
	xp places the control under the previous control
	ym places the control to the right of last control (2nd, 3rd, 4th... column)
	xm places the control on the next line at the left margin

*/

/*
	Naming and accessing named controls:
	In the Options of a control, use 'v' and the name you want the control to be named
	vFirstName
	vOkButton

	FirstNameValue := main['name'].value
	Alternatively, when you add a control to the gui, the control will return an object
	FirstNameObj := main.AddEdit('vFirstName w150', 'Jeff')
	MsgBox FirstNameObj.Value
*/

main.AddText('cBlue', 'First Name: ')
FirstNameObj := main.AddEdit('vFirstName yp w150', 'Jeff')
main.AddText('cBlue ym', 'Last Name:  ')
LastNameObj := main.AddEdit('vLastName yp w150', 'Trusty')
main.AddButton('vOk ym w75', 'Jeffrey').OnEvent('Click', ShowMessage) ; Create OK button
EditBoxObj := main.AddEdit('xm w441 r5', 'C:\Program Files\Autohotkey\v2\AutoHotkey.exe" /ErrorStdOut=utf-8 "c:\Development\AHK\AHK V2\v2 GUIs are Easy\Gui1.ahk')
main.AddButton('yp w75', 'Hide').OnEvent('Click', HideWindow) ; Create Cancel button
main.AddButton('xp w75', 'Close').OnEvent('Click', CloseApp) ; Create Edit button
main.OnEvent('DropFiles', ParseFiles)

main.Show() ; Show can auto size based on the controls that have been added. You can force a specific size: 'w600 h300'

/*
FirstNameValue := main['FirstName'].value
MsgBox FirstNameObj.Value
*/
return

ShowMessage(*)
{
	FirstNameObj.Value := 'Jeffrey'
}

HideWindow(*)
{
	main.Hide()
}

CloseApp(*)
{
	ExitApp 0
}

ParseFiles(GuiObj, GuiCtrlObj, FileArray, X, Y)
{
	for wFile in FileArray
		msgbox wFile
}


F1:: main.Show()