#SingleInstance
#Requires Autohotkey v2.0+

main := Gui('', 'Main')
main.AddProgress('vaProgress w150 Range1-100')
main.Show()

loop 100
{
	main['aProgress'].value := a_index
	sleep 10
}
return