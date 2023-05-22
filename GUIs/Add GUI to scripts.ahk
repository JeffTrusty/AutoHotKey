;*******************************************************
; From: https://www.youtube.com/watch?v=AU9EINktPyQ
;*******************************************************
#SingleInstance, force

Gui, main:new
Gui, add, text,w50, Rows
Gui, add, edit, w50 x+10 vedRow ; x+10 puts the control 10 pixels to the right of the previous control
Gui, add, text,w50 xm, Columns ; xm=X Margin IE next row of GUI
Gui, add, edit, w50 x+10 vedCol
; Gui, add, text, 0x10 w250 xm
Gui, add, button, w75 xm-1 gCreate, % "Create Table"
Gui, show
return

;********************Function to Create HTML ***********************************
Create(CtrlHwnd, GuiEvent, EventInfo, ErrLevel:=""){
	GuiControlGet, edRow ;Get Row data from GUI
	GuiControlGet, edCol ;Get Column data from GUI
	;**************************************
	ColCount:=edCol ;Push into origial variable
	RowCount:=edRow ;Push into original Row count variable

	;********************build columns***********************************
	Row:="<tr>" ;Begin row with Table Row tag
	Loop, % ColCount
		row.=" <td></td> " ;Add columns
	row.="</tr>`n" ;End Table Row tag and add new line

	;********************Now take care of rows***********************************
	loop, % RowCount
		rows.=row ;Simply create multiple rows

	;********************Clear out variables and push to clipboard***********************************
	MsgBox % Clipboard:="<table>`n" rows "</table>"
	row:=rows:="" ;Clear variables
	return
}

;********************To easily exit the program, either hit escape or close the GUI***********************************
mainGuiEscape:
mainGuiClose:
ExitApp
return
