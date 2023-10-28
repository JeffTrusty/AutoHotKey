#SingleInstance Force
#Requires AutoHotkey v2

MyGui_Create()
Return

MyGui_Create(){
	MyGui := Gui(, "New Gui")

	; MenuBar of Gui
	myMenuBar := Menu()
	FileMenu := Menu()
	FileMenu.Add("&Open ScriptDir",(*) => (Run(A_ScriptDir)))
	FileMenu.Add("&Reload",(*) => (Reload()))
	FileMenu.Add()
	FileMenu.Add("&Exit",(*) => (ExitApp))
	myMenuBar.Add("FileMenu",FileMenu)
	MyGui.MenuBar := myMenuBar


	Tv1 := MyGui.AddTreeView(, "")
	DDL1 := MyGui.AddDropDownList(, ["DropDownList"])
	MyGui.Show("w300 h280")
	Return
}
