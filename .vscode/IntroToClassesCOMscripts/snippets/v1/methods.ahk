#Requires Autohotkey v1.1.36+
Obj := {name: "isaias", showMsg: Func("showMsg")}

Obj.showMsg("This is a test")
return

showMsg(this, txt)
{
	msgbox % txt
}