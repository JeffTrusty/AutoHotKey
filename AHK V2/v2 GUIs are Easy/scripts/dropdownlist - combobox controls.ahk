#SingleInstance
#Requires Autohotkey v2.0+

main := Gui('', 'Main')
main.addDropDownList('vDDLColor w150 r20', ['red', 'green', 'Blue', 'Black', 'White']).Choose('Black')
main.addComboBox('vCBColor w150 r20', ['red', 'green', 'Blue', 'Black', 'White']).Choose('Black')
main.addButton('w75', 'Show Value').onEvent('Click', ShowValues)
main.Show()

return

ShowValues(*)
{
	msgbox main['DDLColor'].value
	msgbox main['DDLColor'].text
	msgbox main['CBColor'].value
	msgbox main['CBColor'].text
}