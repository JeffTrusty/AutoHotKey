#SingleInstance
#Requires Autohotkey v2.0+

main := Gui('', 'Main')
main.Add('Edit', 'w150', '')
main.AddEdit('w150', 'This is a test')
main.Add('Button', 'w75', 'OK')
main.AddButton('w75', 'Cancel')
main.Add()
main.Show()
return