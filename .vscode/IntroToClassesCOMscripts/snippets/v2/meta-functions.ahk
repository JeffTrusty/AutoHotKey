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
		; code on exit
	}

	__set(aName, value)
	{
		if (aName = "add")
		{
			this.address := value
			return value
		}
	}

	__get(aName)
	{
		msgbox "the property " aName " hasnt been defined"
	}

	__call(aName)
	{
		msgbox "the method " aName " hasnt been defined"
	}

	fullName()
	{
		return this.name " " this.lastName
	}

	talk(txt)
	{
		msgbox txt
	}

	walk()
	{
		; code for walking
	}
}

isaias := Person("Isaias", "Baez")

isaias.add()

