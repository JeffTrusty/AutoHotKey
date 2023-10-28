#SingleInstance
#Requires Autohotkey v2.0+

main := Gui('', 'Main')

main.AddEdit('vName w150', 'Isaias')
main.AddEdit('vLastName x+m w150', 'Baez')
OKBtn := main.AddButton('xm w75', 'OK')
CancelBtn := main.AddButton('x+m w75', 'Cancel')

main.Show()


main['Name'].value := 'Michael'

msgbox OKBtn.text ' and ' CancelBtn.text
return