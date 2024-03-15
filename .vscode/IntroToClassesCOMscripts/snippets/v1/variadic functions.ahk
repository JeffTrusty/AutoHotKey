#Requires Autohotkey v1.1.36+
msgbox % addNumbers(5, 7, 3, 10, 25)
MsgBox % subNumbers(100, 5, 3, 10)
return

addNumbers(params*)
{
	total := 0
	for each, value in params
		total += value
	
	return total
}

subNumbers(params*)
{
	total := params[1]
	for each, value in params
	{
		if A_Index = 1
			Continue
		total -= value
	}
	
	return total
}