#Requires Autohotkey v2.0+
class Person
{
	name := ""
	lastName := ""
	address := ""

	__new(name, lName)
	{
		this.name := name
		this.lastName := lName
	}

	__delete()
	{
		MsgBox "Object was deleted"
	}

	fullName()
	{
		return this.name " " this.lastName
	}

	talk(txt)
	{
		MsgBox txt
	}

	walk()
	{
		; code for walking
	}
}

guy := person("Isaias", "Baez")
gal := person("Michel", "Gomez")

MsgBox guy.fullName()
MsgBox gal.fullName()

guy := ""
gal := ""