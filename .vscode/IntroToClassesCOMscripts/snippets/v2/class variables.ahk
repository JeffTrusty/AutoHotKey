#Requires Autohotkey v2.0+
class Person
{
	; this is a class variable
	static name := ""

	; this is an instance variable
	name := ""

	lastName := ""

	fullName()
	{
		return this.name " " this.lastName
	}
}

me := person()

me.name := "Isaias"
Person.name := "Class Name"
you := person()

msgbox me.name " / " Person.name " / " you.name