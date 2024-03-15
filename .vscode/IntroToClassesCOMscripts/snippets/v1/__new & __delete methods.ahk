#Requires Autohotkey v1.1.36+
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
		msgbox % "Object was deleted"
	}

	fullName()
	{
		return this.name " " this.lastName
	}

	talk(txt)
	{
		msgbox % txt
	}

	walk()
	{
		; code for walking
	}
}

guy := new person("Isaias", "Baez")
gal := new person("Michel", "Gomez")

msgbox % guy.fullName()
msgbox % gal.fullName()

guy := ""
gal := ""