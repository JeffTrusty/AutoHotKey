#Requires Autohotkey v1.1.36+
msgbox % addNumbers(5, 7)
msgbox % addNumbers(5, 7, 3)
return


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
	msgbox % var
}