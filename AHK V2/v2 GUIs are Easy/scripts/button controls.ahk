#SingleInstance
#Requires Autohotkey v2.0+

main := Gui('', 'Main')
main.addButton('w75', 'Save').onEvent('Click', Save)
main.addButton('x+m w75', 'Exit').onEvent('Click', ExitProgram)
main.Show()
return

Save(*)
{
	Msgbox 'The file has been saved'
}

ExitProgram(*)
{
	ExitApp()
}

