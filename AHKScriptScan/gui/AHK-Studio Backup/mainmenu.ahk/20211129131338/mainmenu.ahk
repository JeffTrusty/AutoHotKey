; Menu, Help, Add, % "Check for Updates", % "Update"
Menu, Help, Add, % "Keyword Information", % "Info"
Menu, Help, Add, % "About"

Menu, File, Add, % "Open Script", % "OpenScript"
Menu, File, Add
Menu, File, Add, % "Exit"

Menu, MainMenu, Add, % "File", :File
Menu, MainMenu, Add, % "Help", :Help

Info(ItemName, ItemPos, MenuName){
	Run %A_ScriptDir%\gui\info.html
}

OpenScript(ItemName, ItemPos, MenuName){
	MainButtonOpen(MenuName, ItemName, ItemPos)
}

About(ItemName, ItemPos, MenuName){
	script.About()
	return
}

Update(ItemName, ItemPos, MenuName){
	try
		script.update(false, false)
	catch err
		msgbox % err.code ": " err.msg

	return
}

Exit(ItemName, ItemPos, MenuName){
	ExitApp, 0
}