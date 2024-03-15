#Requires Autohotkey v2.0+
Obj := {name: "isaias", showMsg: showMsg}

Obj.showMsg("This is a test")
return

showMsg(this, txt)
{
	msgbox txt
}