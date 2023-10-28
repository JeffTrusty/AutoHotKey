#Requires Autohotkey v1.1.31.01+
#SingleInstance Force

Gui New, +AlwaysOnTop +ToolWindow
Gui, Font, s8, Fira Code
Gui Add, DropDownList, w300 gShow vSelectedServer, wp000081494 - Production DataBase |wp000059060 - Production Reporting |wp000060570 - Production DocLink |wp000060572 - Production DocLink OCR |wn000053201 - Stage DataBase |wn000054353 - Stage Reporting |wn000060565 - Stage DocLink |wn000060594 - Stage DocLink OCR
Gui Show, x0 y0, ServerName -> Clipboard
Return

Show:
	Gui Submit, nohide
	{
		SelectedServer := rtrim(SubStr(SelectedServer, 1, 11))
		A_Clipboard := % SelectedServer
	}
