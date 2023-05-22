outline(script)
{
	gui Main:Default

	static commentRegex := "(?:\s+(?:;.*))?"
	static boundary := "(?:,|\s+)"

	static sections := {"Directives"     : "^(?:\s+)?(?P<directives>#(?!include)\w+)" boundary ".*?$"
	                   ,"Included Files" : "|^(?:\s+)?#include" boundary "(?P<included_files>.*?)" commentRegex "$"
	                ;    ,"Classes"        : ""
	                   ,"Labels"         : "|^(?:\s+)?(?P<labels>\w+):" commentRegex "$"
	                   ,"Functions"      : "|^(?:\s+)?(?P<functions>\w+\(.*?\))\{?$"
	                   ,"DllCalls"       : "|(?:\s+)?(?P<dllcalls>dllcall\(.*?\))"
	                   ,"Hotkeys"        : "|^(?:\s+)?(?P<hotkeys>[^:=""]*?)\:\:"}
	                ;    ,"Hotstrings"     : "|^(?:\s+)?:.*?:(?P<hotstrings>.*?)\:\:"}

	; add main sections
	; SplitPath, script, scriptName
	; tvScript := TV_Add(scriptName, 0, "expand")

	for section in sections
	{
		sectionVar := RegExReplace(section, "\s", "_")
		tv%sectionVar% := TV_Add(section, 0)
	}

	GuiControl, -redraw, mainTV
	for section,sectionRegex in sections
		regex .= sectionRegex
	regex := "(" regex ")"

	Loop, Read, % script
	{
		; scan script and categorize each read line
		RegExMatch(A_LoopReadLine, "iSO)" regex, match)
		currentLine := a_index

		if (regexMatch(A_LoopReadLine, "^(\s+)?(\/\*|\()"))
			commentBlock := true
		else if (regexMatch(A_LoopReadLine, "^(\s+)?(\*\/|\))"))
			commentBlock := false

		if (commentBlock || RegExMatch(A_LoopReadLine, "^\s+;.*?$"))
			continue

		if (match)
		{
			for section,sectionRegex in sections
			{
				r:=RegExMatch(mv:=match.value, sr:="iSO)" RegexReplace(sectionRegex, "^\|","","",1), sectionMatch)
				sectionVar := "tv" matchSection := RegExReplace(section, "\s", "_")
				
				if (!sectionRegex)
					continue
				else if (sectionMatch)
					OutputDebug, % match.value "`t" section "`t" sr "`t(" match[matchSection] ")"

				; add line to correct section
				if (sectionMatch)
				{
					TV_Add("Line: " format("{: 4}",currentLine) " | " match[matchSection], %sectionVar%)
					break
				}
			}
		}
	}
	GuiControl, +redraw, mainTV
	return
}