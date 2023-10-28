#SingleInstance
#Requires Autohotkey v2.0+

main := Gui('', 'Main')
main.onEvent('Close', ExitApplication)

main.AddEdit('vName w150', 'Isaias')
main.AddEdit('vLastName x+m w150', 'Baez')
main.AddButton('xm w75', 'OK').onEvent('Click', ShowMessage)
main.AddButton('x+m w75', 'Cancel').onEvent('Click', HideWindow)

main.Show()
return

ShowMessage(*)
{
	main['Name'].value := 'Michael'
}

HideWindow(*)
{
	main.hide()
}

ExitApplication(*)
{
	Exitapp 0
}

F1::main.show()