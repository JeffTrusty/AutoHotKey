#Requires Autohotkey v1.1.36+
class Person
{
	name := ""
	lastName := ""

	fullName()
	{
		return this.name " " this.lastName
	}
}

me := new person
me.name := "Isaias"
me.lastname := "baez"

you := new person
you.name := "Michael"
you.lastname := "Jordan"

; you := me
; you.name := "Michael"

msgbox % me.fullName()
msgbox % you.fullName()