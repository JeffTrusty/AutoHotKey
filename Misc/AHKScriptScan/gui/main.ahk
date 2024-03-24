#Include gui\mainmenu.ahk

gui Main:new,, % "Script Scan"
gui Margin, 10, 10
gui Font, s10

; gui add, Text, w200 xm, % "Current File:"
gui Font, bold
gui add, Text, w500 xm c55B9DD vOutlineText, % "Script Outline:"
gui add, Text, x+m c55B9DD, % "Security Summary:"
gui Font, normal
gui add, Text, w300 x+m vSummaryText, % "0 items"
gui Font,,% "Lucida Sans Typewriter"
gui add, TreeView, w500 h600 xm altsubmit vmainTV gTreeViewHandler
gui add, ListView, w1280 h600 x+m vmainLV gListViewHandler, % "Keyword|Type|Severity|Potential Risk|Line|File|Context"
gui menu, % "MainMenu"

LV_ModifyCol(1,"right"), LV_ModifyCol(3, "integer"), LV_ModifyCol(5, "integer right"), LV_ModifyCol(6, "left")

mainGuiWidth := 500+1280+10+20 ; treeview, listview, margin, outside margins

; gui add, Text, % 0x10 " w" mainGuiWidth + 5 " x0"
; gui add, Button, % "w75 x" mainGuiWidth - 75 - 10 " yp+10", % "Open"

MainButtonOpen(CtrlHwnd, GuiEvent, EventInfo, ErrLevel:=""){
	gui Main:Default

	if (GuiEvent != "GuiDropFiles"){
		FileSelectFile, scriptPath,,, % "Select the script to be scanned", *.ahk
		
		if (!scriptPath){
			MsgBox, % 0x10, % "Error", % "No file was selected."
			Return
		}
	}
	else
		scriptPath := EventInfo[1]

	gui show,, % "Script Scan - " scriptPath
	
	LV_Delete(), TV_Delete()
	SetWorkingDir, %A_ScriptFullPath%
	
	outline(scriptPath)
	scan(scriptPath)
	Return
}


TreeViewHandler(CtrlHwnd, GuiEvent, EventInfo, ErrLevel:=""){
	switch (GuiEvent){
	case "Normal":
		if !TV_GetParent(EventInfo)
			return
		TV_GetText(Info, EventInfo)
		Clipboard := RegExReplace(info, "^.*?\|\s")
		ToolTip, % "Copied to the clipboard"
		SetTimer, TooltipOff, -1000
	}
}

ListViewHandler(CtrlHwnd, GuiEvent, EventInfo, ErrLevel:=""){
}

MainGuiDropFiles(GuiHwnd, FileArray, CtrlHwnd, X, Y){
	MainButtonOpen(GuiHwnd, "GuiDropFiles", FileArray)
}

MainGuiClose(){
	ExitApp, 0
}

MainGuiEscape(){
	ExitApp, 0
}

TooltipOff(){
	ToolTip
	return
}