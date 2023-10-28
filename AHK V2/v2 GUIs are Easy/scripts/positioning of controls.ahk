#SingleInstance
#Requires Autohotkey v2.0+

main := Gui('', 'Main')

main.AddEdit('w150', '')
main.AddEdit('x+m w150', 'This is a test')
main.AddButton('xm w75', 'OK')
main.AddButton('x+m w75', 'Cancel')

main.Show()
return