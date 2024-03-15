#Requires Autohotkey v2.0+
x := 'test'
myFunction()
MsgBox 'outside of the function: ' x
return

myFunction()
{
	global x
	
	x := 5
	MsgBox 'inside of the function: ' x
}