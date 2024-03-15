#Requires Autohotkey v1.1.36+
class Person
{
	static name := ""
	lastName := ""

	fullName()
	{
		return this.name " " this.lastName
	}
}

me := new person

me.name := "Isaias"
Person.name := "Class Name"
you := new person

msgbox % me.name " / " Person.name " / " you.name