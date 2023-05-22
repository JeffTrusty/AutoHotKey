scan(scriptToScan)
{
	gui, main:Default

	global mainLV, SummaryText
	static firstRun:=true
	static recurseLevel:=0
	static keywords

	icons := IL_Create(3)
	LV_SetImageList(icons)

	loop 3
		IL_Add(icons, script.resfolder "\severity.dll", A_Index)

	OutputDebug, % (recurseLevel += 1) "/" scriptToScan
	SplitPath, scriptToScan, scriptToScanName, workDir

	; check in which standard lib the file is located
	if (RegExMatch(scriptToScan, "O)<(.*?)>", match))
		scriptToScan := "lib\" scriptToScanName := match.1 ".ahk"
	
	if (firstRun)
	{
		static watchList := {}
		Loop, Read, lib\watch.h
		{
			if (a_index == 1)
				Continue
			
			line := StrSplit(A_LoopReadLine, "`t")
			keywords .= line[1] ","
			watchList[line[1]] := {"type": line[2], "severity": line[3], "purpose":line[4]}
		}
		SetWorkingDir, % workDir
		firstRun := false
	}

	; if (recurseLevel == 1)
	; 	GuiControl, -redraw, mainLV
	
	Loop, Read, %scriptToScan%
	{
		currentLine := A_Index
		if (regexMatch(A_LoopReadLine, "^\s*(\/\*|\((?!.*\)))"))
			commentBlock := true
		else if (regexMatch(A_LoopReadLine, "^(\s+)?(\*\/|\))"))
			commentBlock := false

		; if a_index = 33
		; 	sleep 100
			
		if (commentBlock || RegExMatch(A_LoopReadLine, "^(\s+)?;.*?$"))
			continue
		
		if (InStr(A_LoopReadLine, "#include"))
		{
			if (!regexMatch(libpath := StrSplit(A_LoopReadLine, " ").2, "<|>|\."))
			{
				oldWorkDir := workDir
				SetWorkingDir, % A_WorkingDir "\" libpath
				continue
			}

			scan(StrSplit(A_LoopReadLine, " ").2)
		}
		
		if A_LoopReadLine Contains %keywords%
		{
			for keyword,info in watchList
			{
				if (info.type == "Command")
					regex := "^(\s+)?\b\Q" keyword "\E\b"
				else if (info.type == "Function")
					regex := "\Q" keyword "\E\("
				else if (info.type == "Hotkey")
					regex := "^[[:alnum:]&<>^!+#~*\s]+\Q" keyword "\E.*$"
				else
					regex := "\b\Q" keyword "\E\b"
				
				if (RegExMatch(A_LoopReadLine, "i)" regex))
				{
					GuiControl,, SummaryText, % LV_GetCount() " items"
					
					switch
					{
					case (info.severity > 6):
						icoNum := 1
					case (info.severity > 3):
						icoNum := 2
					case (info.severity >= 1):
						icoNum := 3
					}
					
					LV_Add("Icon" icoNum, keyword, info.type, info.severity, info.purpose, currentLine, scriptToScanName, Trim(A_LoopReadLine))
				}

				
			}
		}
	}
	
	if (!currentLine)
		OutputDebug, % "Could not read " scriptToScan " using WorkingDir: " A_WorkingDir
	
	LV_ModifyCol(1, "Sort"), LV_ModifyCol(3, "SortDesc")
	
	Loop % LV_GetCount()
		LV_ModifyCol(A_Index, "AutoHdr") ;(a_index == 7 ? LV_ModifyCol(7, 500) : LV_ModifyCol(A_Index, "AutoHdr"))
	
	; if (recurseLevel == 1)
	; 	GuiControl, +redraw, mainLV

	GuiControl,, SummaryText, % (LV_GetCount() ? LV_GetCount() : 0) " items"
	
	return recurseLevel -= 1
}