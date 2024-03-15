#Requires Autohotkey v2.0+
ShowFullName := myFunction.Bind('Isaias')
ShowFullName('Baez')
return

myFunction(first, last)
{
	MsgBox first ' ' last
}
