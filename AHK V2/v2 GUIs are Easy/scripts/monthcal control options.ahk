#SingleInstance
#Requires Autohotkey v2.0+

main := Gui('', 'Main')
main.addMonthCal('vCalendar w-2 r4 Multi', '20230211-20230301')
main.addButton('w75', 'Show Range').onEvent('Click', ShowRange)
main.Show()
return

ShowRange(*)
{
	dates := strsplit(main['Calendar'].value, '-')

	msgbox 'Start date: ' dates[1] '`nEnd date: ' dates[2]
}