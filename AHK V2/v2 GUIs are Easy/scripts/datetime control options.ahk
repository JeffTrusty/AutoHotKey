#SingleInstance
#Requires Autohotkey v2.0+

main := Gui('', 'Main')
main.addDateTime('vDatePick w150 Choose' A_now, 'yyyy/MM/dd HH:mm:ss')
main.Show()

msgbox main['DatePick'].value
return