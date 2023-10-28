#SingleInstance
#Requires Autohotkey v2.0+

main := Gui('', 'Main')
main.addMonthCal('vCalendar w-2 r4')
main.Show()
return