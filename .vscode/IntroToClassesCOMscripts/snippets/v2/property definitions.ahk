#Requires Autohotkey v2.0+
class Person
{
	_name := ""
	lastName := ""
	address := ""

	name
	{
		set
		{
			return this._name := value
		}
		get
		{
			return this.title " " this._name
		}
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

isaias := person()
isaias.title := "Mr."
isaias.name := "Isaias"

msgbox isaias.name