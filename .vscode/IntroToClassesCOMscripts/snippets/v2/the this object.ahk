#Requires Autohotkey v2.0+
class Person
{
	name := ""
	lastName := ""

	fullName()
	{
		return this.name " " this.lastName
	}
}

me := person()
me.name := "Isaias"
me.lastname := "baez"

you := person()
you.name := "Michael"
you.lastname := "Jordan"

; you := me
; you.name := "Michael"

msgbox me.fullName()
msgbox you.fullName()