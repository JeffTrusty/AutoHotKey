#Requires Autohotkey v1.1.36+
class Person
{
	name := ""
	lastName := ""
	address := ""

	talk(txt)
	{
		msgbox % txt
	}

	walk()
	{
		; code for walking
	}
}

class Student extends Person
{
	classroom := ""
	grades := ""

	enroll()
	{
		; code for enrolling
	}

	drop()
	{
		; code for dropping a class
	}
}

Isaias := new student
Isaias.talk("Hello World!")
return