#SingleInstance
#Requires Autohotkey v2.0+

main := Gui('', 'Main')
main.addSlider('vSlide h300 Range0-100 TickInterval10 Vertical Invert', 20).onEvent('Change', ShowTip)
main.Show()

return

ShowTip(*)
{
	tooltip main['Slide'].value
}