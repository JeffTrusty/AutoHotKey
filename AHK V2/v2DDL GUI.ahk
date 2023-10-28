#Requires AutoHotkey v2+
#SingleInstance Force

MyGui_Create()
Return

MyGui_Create() {
	MyGui := Gui(, "New Gui")
	DDL1 := MyGui.AddDropDownList("x10 y7", ["DDL1Option1", "DDL1Option2"])
	DDL2 := MyGui.AddDropDownList("x137 y5", ["Option1", "Option2"])
	ogSB := MyGui.AddStatusBar(, "Status Bar")
	MyGui.Show("w530 h426")
	Return
}