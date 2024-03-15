msgbox addNumbers(5, 7)
msgbox addNumbers(5, 7, 3)

staticFunction()
staticFunction()
return

addNumbers(num1, num2, num3 := 0)
{
	return num1 + num2 + num3
}
staticFunction()
{
	static var := 0

	var += 1
	msgbox var
}