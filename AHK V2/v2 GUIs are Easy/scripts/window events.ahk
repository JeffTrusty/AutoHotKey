#SingleInstance
#Requires Autohotkey v2.0+

main := Gui('+Resize', 'Main')
main.onEvent('Close', ExitApplication)
main.onEvent('Escape', ExitApplication)
main.onEvent('Size', ResizeGui)
main.onEvent('DropFiles', ParseFiles)

main.Show('w400 h400')
return

ExitApplication(*)
{
	ExitApp 0
}

ResizeGui(GuiObj, MinMax, Width, Height)
{
	Tooltip Width ',' Height
}

ParseFiles(GuiObj, GuiCtrlObj, FileArray, X, Y)
{
	for wFile in fileArray
		msgbox wFile
}