#Requires Autohotkey v2.0+
class Person
{
	name := ""
	lastName := ""
	address := ""

	talk(txt)
	{
		msgbox txt
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

Isaias := student()
Isaias.talk("Hello World!")
return