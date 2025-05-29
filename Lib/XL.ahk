#Requires Autohotkey v2.0+
/**
 * ============================================================================ *
 * @Author   : Joe Glines                                                       *
 * @Homepage : the-automator.com                                                *
 * @Version  : 2.2.0                                                            *
 * ============================================================================ *
 * Want a clear path for learning AutoHotkey?                                   *
 * Take a look at our AutoHotkey courses here: the-Automator.com/Discover       *
 * They're structured in a way to make learning AHK EASY                        *
 * And come with a 200% moneyback guarantee so you have NOTHING to risk!        *
 * ============================================================================ *
 */
;~ Joe Glines   https://the-Automator.com  https://www.the-automator.com/excel-and-autohotkey/
/*
This work by the-Automator.com is licensed under CC BY 4.0

Attribution â€” You must give appropriate credit , provide a link to the license,
and indicate if changes were made.
You may do so in any reasonable manner, but not in any way that suggests the licensor
endorses you or your use.
No additional restrictions â€” You may not apply legal terms or technological measures that
legally restrict others from doing anything the license permits.
*/


;***********************Excel Handles********************************.
;~ XL:=XL_Handle(1) ; 1=pointer to Application   2= Pointer to Workbook

/**
 *
 * @param {Integer} Sel
 * @returns {String}
 */
XL_Handle(Sel:=1){
	static OBJID_NATIVEOM := 0xFFFFFFF0
	; OBJID_NATIVEOM In response to this object identifier,
	; third-party applications can expose their own object model.
	; Third-party applications can return any COM interface in response to this object identifier.
	; https://docs.microsoft.com/en-us/windows/win32/winauto/object-identifiers
	Obj:=ObjectFromWindow(OBJID_NATIVEOM, "ahk_class XLMAIN","Excel71")
	return (Sel=1?Obj.Application:Sel=2?Obj.Parent:Sel=3?Obj.ActiveSheet:"")
}

;***borrowd & tweaked from Acc.ahk Standard Library*** by Sean  Updated by jethrow*****************

/**
 *
 * @param {String} idObject
 * @param {String} WinTitle
 * @param {String} ClassNN
 * @returns {Float | Integer | String | ComValue | ComObject | ComObjArray}
 */
ObjectFromWindow(idObject, WinTitle?, ClassNN?) {
	oldMode := A_TitleMatchMode
	SetTitleMatchMode 2
	if IsSet(ClassNN)
		hwnd := ControlGetHwnd(ClassNN, WinTitle?)
	else
		hwnd := WinExist(WinTitle?)
	SetTitleMatchMode oldMode

	IID := Buffer(16)
	res := DllCall("oleacc\AccessibleObjectFromWindow"
	              ,"ptr" , hwnd
	              ,"uint", idObject &= 0xFFFFFFFF
	              ,"ptr" , -16 + NumPut("int64", idObject == 0xFFFFFFF0 ? 0x46000000000000C0 : 0x719B3800AA000C81
	                                   , NumPut("int64", idObject == 0xFFFFFFF0 ? 0x0000000000020400 : 0x11CF3C3D618736E0, IID))
	              ,"ptr*", ComObj := ComValue(9,0))

	return res ? res : ComObj
}
;***********************Show name of object handle is referencing********************************.
;~ XL_Reference(XL) ;will pop up with a message box showing what pointer is referencing
/**
 *
 * @param {ComObject} PXL
 */
XL_Reference(PXL){
	;~ MsgBox, %HWND%
	;~ MsgBox, % ComObjType(window)
	MsgBox ComObjType(PXL,"Name")
}

;;********************Reference Cell by row and column number***********************************
;~ XL.Range(XL.Cells(1,1).Address,XL.Cells(5,5).Address)
;~ MsgBox % XL.Cells(1,4).Value  ;Row, then column
;~ XL.Range(XL.Cells(1,1).Address,XL.Cells(5,5).Address)

;***********************Screen update toggle********************************.
;~ XL_Screen_Update(XL)

/**
 *
 * @param {ComObject} PXL
 */
XL_Screen_Update(PXL){
	PXL.Application.ScreenUpdating := ! PXL.Application.ScreenUpdating ;toggle update
}

;~ XL_Speedup(XL,1) ;Speed up Excel tweaked from Tre4shunter https://github.com/tre4shunter/XLFunctions/

/**
 *
 * @param {ComObject} PXL
 * @param {String} Status
 */
XL_Speedup(PXL,Status){ ;Helps COM functions work faster/prevent screen flickering, etc.
	if(!Status){
		PXL.application.Cursor  := 2 ; the cursor must be set to prevent excel from updating it
		PXL.application.displayalerts := 0
		PXL.application.EnableEvents := 0
		PXL.application.ScreenUpdating := 0
		PXL.application.Calculation := -4135
	}else{
		;
		PXL.application.Cursor  := -4143
		PXL.application.displayalerts := 1
		PXL.application.EnableEvents := 1
		PXL.application.ScreenUpdating := 1
		PXL.application.Calculation := -4105
	}
}

;~ XL_Screen_Visibility(XL)
/**
 *
 * @param {ComObject} PXL
 * @returns {Number}
 */
XL_Screen_Visibility(PXL) => PXL.Visible:= ! PXL.Visible ;Toggle screen visibility
;***********************First row********************************.
;~ XL_First_Row(XL)
/**
 *
 * @param {ComObject} PXL
 */
XL_First_Row(PXL) => PXL.Application.ActiveSheet.UsedRange.Rows(1).Row

;***********************Used Rows********************************.
;~ Rows:=XL_Used_Rows(XL)
/**
 *
 * @param {ComObject} PXL
 */
XL_Used_rows(PXL) => PXL.Application.ActiveSheet.UsedRange.Rows
;***********************Last Row********************************.
;~ LR:=XL_Last_Row(XL)

/**
 *
 * @param {ComObject} PXL
 */
XL_Last_Row(PXL) => PXL.Cells.Find("*",,,,1,2).Row  ;~  Return PXL.ActiveSheet.Cells.SpecialCells(11).Row ;This will treat formatting as a used cell

;***********************Last Row in Specific Column********************************.
;~ Last_Row:=XL_Last_Row_in_Column(XL,"A")

/**
 *
 * @param {ComObject} PXL
 * @param {String} Col
 */
XL_Last_Row_in_Column(PXL,Col) => PXL.Cells(PXL.Rows.Count,XL_String_To_Number(Col)).End(-4162).Row

;~ XL.cells.rows.count count of all rows available in Excel.  Last row available
;***********************First Column********************************.
;~ XL_First_Col_Nmb(XL)
/**
 *
 * @param {ComObject} PXL
 */
XL_First_Col_Nmb(PXL) => PXL.Application.ActiveSheet.UsedRange.Columns(1).Column

;***********************First Column Alpha**********************************.
;~ XL_Last_Col_Alpha(XL)
/**
 *
 * @param {ComObject} PXL
 * @returns {String}
 */
XL_First_Col_Alpha(PXL){
	FirstCol:=PXL.Application.ActiveSheet.UsedRange.Columns(1).Column
	return (FirstCol<=26?(Chr(64+FirstCol)):(FirstCol>26)?(Chr((FirstCol-1)/26+64) . Chr(Mod((FirstCol- 1),26)+65)):"")
}
;***********************Used Columns Count********************************.
;~ LC:=XL_Used_Cols_Nmb(XL)
/**
 *
 * @param {ComObject} PXL
 */
XL_Used_Cols_Nmb(PXL) => PXL.Application.ActiveSheet.UsedRange.Columns.Count
;***********************Last Column********************************.
;~ LC:=XL_Last_Col_Nmb(XL)

/**
 *
 * @param {ComObject} PXL
 */
XL_Last_Col_Nmb(PXL) => PXL.Cells.Find("*",,,,2,2).Column
;~ Return, PXL.Application.ActiveSheet.UsedRange.Columns(PXL.Application.ActiveSheet.UsedRange.Columns.Count).Column ;This will treat formatted cells as valid data

;***********************Last Column Alpha**  Needs Workbook********************************.
;~ XL_Last_Col_Alpha(XL)

/**
 *
 * @param {ComObject} PXL
 * @returns {String}
 */
XL_Last_Col_Alpha(PXL){
	d:=XL_Last_Col_Nmb(PXL)
	Col := ""
	while(d>0){
		m:=Mod(d-1,26)
		Col:=Chr(65+m) Col
		d:=Floor((d-m)/26)
	}return Col
}
;***********************Used_Range Used range********************************.
;~ RG:=XL_Used_RG(XL,Header:=1) ;Use header to include/skip first row

/**
 *
 * @param {ComObject} PXL
 * @param {Integer} Header
 * @returns {String}
 */
XL_Used_RG(PXL,Header:=1){
	return Header=0?XL_First_Col_Alpha(PXL) . XL_First_Row(PXL) ":" XL_Last_Col_Alpha(PXL) . XL_Last_Row(PXL):Header=1?XL_First_Col_Alpha(PXL) . XL_First_Row(PXL)+1 ":" XL_Last_Col_Alpha(PXL) . XL_Last_Row(PXL):""
}
;***********************Numeric Column to string********************************.
; Column index to Character
;~ XL_Col_To_Char(26)

/**
 *
 * @param {String} Index
 * @returns {String}
 */
XL_Col_To_Char(Index){ ;Converting Columns to Numeric for Excel
	return Index<=26?(Chr(64+index)):Index>26?Chr((index-1)/26+64) . Chr(mod((index - 1),26)+65):""
}
;***********************String to Number********************************.
;~ XL_String_To_Number("ab")

/**
 *
 * @param {String} Column
 * @returns {Number}
 */
XL_String_To_Number(Column)
{
	if Type(Column) = "Integer"
		return Column
	Column := Format("{:U}",Column)
	Index := 0
	Loop Parse, Column  ;loop for each character
	{
		ascii := Ord( A_LoopField )
    	if (ascii >= 65 && ascii <= 90)
			index := index * 26 + ascii - 65 + 1    ;Base = 26 (26 letters)
		else
			return
	}
	return index+0 ;Adding zero here is needed to ensure you're returning an Integer, not a String
}
;***********************Freeze Panes********************************.
;~ XL_Freeze(XL,Row:="1",Col:="B") ;Col A will not include cols which is default so leave out if unwanted
;***********************Freeze Panes in Excel********************************.
/**
 *
 * @param {ComObject} PXL
 * @param {Range} RG
 * @param {String} Col
 */
XL_Freeze(PXL,Row:="",Col:="A"){
	PXL.Application.ActiveWindow.FreezePanes := False ;unfreeze in case already frozen
	if !row ;if no row value passed row;  turn off freeze panes
		return
	PXL.Application.ActiveSheet.Range(Col . Row+1).Select ;Helps it work more intuitivly so 1 includes 1 not start at zero
	PXL.Application.ActiveWindow.FreezePanes := True
}

;*******************************************************.
;***********************Formatting********************************.
;*******************************************************.
;***********************Alignment********************************.
;~ XL_Format_HAlign(XL,RG:="A1:A10",h:=2) ;1=Left 2=Center 3=Right

/**
 *
* @param {ComObject} PXL
 * @param {Range} RG
 * @param {'1'|'2'|'3'|'4'|'5'} h
 */
XL_Format_HAlign(PXL,RG:="",h:="1"){ ;defaults are Right bottom
	PXL.Application.ActiveSheet.Range(RG).HorizontalAlignment:=(h=1?-4131:h=2?-4108:h=3?-4152:h=4?-4108:"")
	/*
		IfEqual,h,1,Return,PXL.Application.ActiveSheet.Range(RG).HorizontalAlignment:=-4131 ;Left
		IfEqual,h,2,Return,PXL.Application.ActiveSheet.Range(RG).HorizontalAlignment:=-4108 ;Center
		IfEqual,h,3,Return,PXL.Application.ActiveSheet.Range(RG).HorizontalAlignment:=-4152 ;Right
	*/
}
;~ XL_Format_VAlign(XL,RG:="A1:A10",v:=4) ;1=Top 2=Center 3=Distrib 4=Bottom 5=Horiz align

/**
 *
* @param {ComObject} PXL
 * @param {Range} RG
 * @param {String} v
 */
XL_Format_VAlign(PXL,RG:="",v:="1"){
	PXL.Application.ActiveSheet.Range(RG).VerticalAlignment:=(v=1?-4160:v=2?-4108:v=3?-4117:v=4?-4107:"")
	/*
		IfEqual,v,1,Return,PXL.Application.ActiveSheet.Range(RG).VerticalAlignment:=-4160 ;Top
		IfEqual,v,2,Return,PXL.Application.ActiveSheet.Range(RG).VerticalAlignment:=-4108 ;Center
		IfEqual,v,3,Return,PXL.Application.ActiveSheet.Range(RG).VerticalAlignment:=-4117 ;Distributed equal to warp
		IfEqual,v,4,Return,PXL.Application.ActiveSheet.Range(RG).VerticalAlignment:=-4107 ;Bottom
		*/
}
;***********************Wrap text********************************.
;~ XL_Format_Wrap(XL,RG:="A1:B4",Wrap:=0) ;1=Wrap text, 0=no

/**
 *
 * @param {ComObject} PXL
 * @param {Range} RG
 * @param {Boolean} Wrap
 */
XL_Format_Wrap(PXL,RG:="",Wrap:="1"){ ;defaults to Wrapping
	PXL.Application.ActiveSheet.Range(RG).WrapText:=Wrap
}

;********************Indent text in a cell***********************************
;~ XL_Indent(XL,"A1:A10",3)

/**
 *
 * @param {ComObject} PXL
 * @param {Range} RG
 * @param {String} Indent
 */
XL_Indent(PXL,RG,Indent){
	PXL.Application.ActiveSheet.Range(RG).IndentLevel := 3
}
;***********Shrink to fit*******************
;~ XL_Format_Shrink_to_Fit(XL,RG:="A1",Shrink:=0) ;1=Wrap text, 0=no

/**
 *
 * @param {ComObject} PXL
 * @param {Range} RG
 * @param {Integer} Shrink
 */
XL_Format_Shrink_to_Fit(PXL,RG:="",Shrink:=1){ ;defaults to Shrink to fit
	if(Shrink=1)
		PXL.Application.ActiveSheet.Range(RG).WrapText:=0 ;if setting Shrink to fit need to turn-off Wrapping
	PXL.Application.ActiveSheet.Range(RG).ShrinkToFit :=Shrink
}

;***********************Merge / Unmerge cells********************************.
;~ XL_Merge_Cells(XL,RG:="A12:B13",Warn:=0,Merge:=1) ;set to true if you want them merged

/**
 *
 * @param {ComObject} PXL
 * @param {Range} RG
 * @param {bolean} warn
 * @param {bolean} Merge
 */
XL_Merge_Cells(PXL,RG,warn:=0,Merge:=0){ ;default is unmerge and warn off
	PXL.Application.DisplayAlerts := warn ;Warn about unmerge keeping only one cell
	PXL.Application.ActiveSheet.Range(RG).MergeCells:=Merge ;set merge for range
	if (warn=0)
		PXL.Application.DisplayAlerts:=1 ;if warnings were turned off, turn back on
}
;***********************Font size, type, ********************************.
;~ XL_Format_Font(XL,RG:="A1:B1",Font:="Arial Narrow",Size:=25) ;Arial, Arial Narrow, Calibri,Book Antiqua

/**
 *
 * @param {ComObject} PXL
 * @param {Range} RG
 * @param {String.FontName} Font
 * @param {Integer} Size
 */
XL_Format_Font(PXL,RG:="",Font:="Arial",Size:="11"){
	PXL.Application.ActiveSheet.Range(RG).Font.Name:=Font
	PXL.Application.ActiveSheet.Range(RG).Font.Size:=Size
}

;********************Font color***********************************
;2=none 3=Red 4=Lt Grn 5=Blue 6=Brt Yel 7=Mag 8=brt blu 15=Grey 17=Lt purp  19=Lt Yell 20=Lt blu 22=Salm 26=Brt Pnk
;~ XL_Format_Font_Color(XL,RG:="A1",3)
/**
 *
 * @param {ComObject} PXL
 * @param {Range} RG
 * @param {Integer} Color
 */
XL_Format_Font_Color(PXL,RG:="",Color:=0){
	PXL.Application.ActiveSheet.Range(RG).Font.ColorIndex:=Color
}

;********************Font color***********************************
;~ XL_Format_Font_Color_RGB(XL,RG:="A1",Red:=0,Green:=0,Blue:=0,Color:="Red")

/**
 *
 * @param {ComObject} PXL
 * @param {Range} RG
 * @param {Integer} Red
 * @param {Integer} Green
 * @param {Integer} Blue
 * @param {String} Color
 */
XL_Format_Font_Color_RGB(PXL,RG:="",Red:=0,Green:=0,Blue:=0,Color:=""){
	if color
	{
		Switch Color, 0
		{
			Case "White" : (Red:=255,Green:=255,Blue:=255)
			Case "Red"   : (Red:=255,Green:=0  ,Blue:=0  )
			Case "Green" : (Red:=0  ,Green:=255,Blue:=0  )
			Case "Blue"  : (Red:=0  ,Green:=0  ,Blue:=255)
			Default      : (Red:=0  ,Green:=0  ,Blue:=0  ) ;otherwise make it black
		}
	}
	PXL.Application.ActiveSheet.Range(RG).Font.Color:=(Blue<<16) + (Green<<8) + Red ;eduardo bispo
}


;***********************Font bold, normal, italic, Underline********************************.
;~ XL_Format_Format(XL,RG:="A1:B1",1) ; Bold:=1,Italic:=0,Underline:=3  Underline 1 thru 5
;~ XL_Format_Format(XL,RG:="A1:B1",Bold:=0,Italic:=0,Underline:=0) ; Bold:=1,Italic:=0,Underline:=3  Underline 1 thru 5

/**
 *
 * @param {ComObject} PXL
 * @param {Range} RG
 * @param {bolean} Bold
 * @param {bolean} Italic
 * @param {bolean} Underline
 */
XL_Format_Format(PXL,RG:="",Bold:=0,Italic:=0,Underline:=0){
	PXL.Application.ActiveSheet.Range(RG).Font.Bold:= bold
	PXL.Application.ActiveSheet.Range(RG).Font.Italic:=Italic
	(Underline="0")?(PXL.Application.ActiveSheet.Range(RG).Font.Underline:=-4142):(PXL.Application.ActiveSheet.Range(RG).Font.Underline:=Underline+1)
}
;***********Cell Shading*******************
;2=none 3=Red 4=Lt Grn 5=Blue 6=Brt Yel 7=Mag 8=brt blu 15=Grey 17=Lt purp  19=Lt Yell 20=Lt blu 22=Salm 26=Brt Pnk
;~ XL_Format_Cell_Shading(XL,RG:="A1:H1",Color:=28)

/**
 *
 * @param {ComObject} PXL
 * @param {Range} RG
 * @param {Integer} Color
 */
XL_Format_Cell_Shading(PXL,RG:="",Color:=0){
	PXL.Application.ActiveSheet.Range(RG).Interior.ColorIndex :=Color
}
;***********************Cell Number format********************************.
;~ XL_Format_Number(XL,RG:="A1:B4",Format:="#,##0") ;#,##0 ;0,000 ;0,00.0 ;0000 ;000.0 ;.0% ;$0 ;m/dd/yy ;m/dd ;dd/mm/yyyy ;for plain text use:="@"

/**
 *
 * @param {ComObject} PXL
 * @param {Range} RG
 * @param {String} format
 */
XL_Format_Number(PXL,RG:="",format:="#,##0"){
	PXL.Application.ActiveSheet.Range(RG).NumberFormat := Format
}
;***********tab/Worksheet color*******************
;1=Black 2=White  3=Red 4=Lt Grn 5=Blue 6=Brt Yel 7=Mag 8=brt blu 15=Grey 17=Lt purp  19=Lt Yell 20=Lt blu 22=Salm 26=Brt Pnk
;XL_Tab_Color(xl,"Sheet1","4")

/**
 *
 * @param {ComObject} PXL
 * @param {String} Sheet_Name
 * @param {Integer} Color
 */
XL_Tab_Color(PXL,Sheet_Name,Color){
	PXL.Sheets(Sheet_Name).Tab.ColorIndex:=Color ;color tab yellow
}
;********************Select / Activate sheet***********************************
;XL_Select_Sheet(XL,"Sheet2")
/**
 *
 * @param {ComObject} PXL
 * @param {String} Sheet_Name
 */
XL_Select_Sheet(PXL,Sheet_Name){
	PXL.Sheets(Sheet_Name).Select
}

;********************Change text orientation***********************************
;XL_Format_Text_Alignment(XL,"A1","80")

/**
 *
 * @param {ComObject} PXL
 * @param {Range} RG
 * @param {Integer.angle} Rotate
 */
XL_Format_Text_Alignment(PXL,RG:="",Rotate:="90"){
	PXL.Range(RG).Orientation:=Rotate
}

;***********************Search- find text- Cell shading and Font color********************************.
;~ XL_Color(PXL:=XL,RG:="A1:D50",Value:="Joe",Color:="2",Font:=1) ;change the font color
;~ XL_Color(PXL:=XL,RG:="A1:D50",Value:="Joe",Color:="1") ;change the interior shading
;***********************to do ********************************.
;*this is one or the other-  redo it so it does both***************.
;~ XL_Color(XL,"A1:A2","asdf",<Color Value>,<Background=0,Text=1>)

/**
 *
 * @param {ComObject} PXL
 * @param {Range} RG
 * @param {String} Value
 * @param {bolean} CellShading
 * @param {Integer} FontColor
 */
XL_Color(PXL:="",RG:="",Value:="*",CellShading:=true,FontColor:="0"){
	Last := 0
	if(f:=PXL.Application.ActiveSheet.Range[RG].Find[Value]){
		first :=f.Address
		Loop
		{
			f.Interior.ColorIndex:=CellShading
			f.Font.ColorIndex :=FontColor
			f :=PXL.Application.ActiveSheet.Range[RG].FindNext[f]
			if(Last)
				Break
			if(PXL.Application.ActiveSheet.Range[RG].FindNext[f].Address=First)
				Last:=1
		}
	}

	return

	/*
		if  f:=PXL.Application.ActiveSheet.Range[RG].Find[Value]{ ; if the text can be found in the Range
			first :=f.Address  ; save the address of the first found match
			Loop
				If (FontColor=0){
					f.Interior.ColorIndex:=CellShading
					f :=PXL.Application.ActiveSheet.Range[RG].FindNext[f] ;color Interior & move to next found cell
				}Else{
				f.Font.ColorIndex :=FontColor, f :=PXL.Application.ActiveSheet.Range[RG].FindNext[f] ;color font & move to next found cell
			}Until (f.Address = first) ; stop looking when we're back to the first found cell
		}
	*/
}

;***********************Cell Borders (box)********************************.
;***********Note- some weights and linestyles overwrite each other*******************
;~ XL_Border(XL,RG:="a20:b21",Weight:=2,Line:=2) ;Weight 1=Hairline 2=Thin 3=Med 4=Thick  ***  Line 0=None 1=Solid 2=Dash 4=DashDot 5=DashDotDot 13=Slanted Dashes
;***********************Cell Borders (box)********************************.

/**
 *
 * @param {ComObject} PXL
 * @param {Range} RG
 * @param {Integer} Weight
 * @param {Integer} Line
 * @param {Integer} Fill
 */
XL_Border(PXL,RG:="",Weight:=3,Line:=1,Fill := 1){
	Line:=Line=0?-4142:Line
	/*
		xlContinuous		1	Continuous line.
		xlDash			-4115	Dashed line.
		xlDashDot			4	Alternating dashes and dots.
		xlDashDotDot		5	Dash followed by two dots.
		xlDot			-4118	Dotted line.
		xlDouble
		-4119	Double line.
		xlLineStyleNone	-4142	No line.
		xlSlantDashDot		13	Slanted dashes.
	*/
	/*
		https://docs.microsoft.com/en-us/office/vba/api/excel.xlbordersindex
		PXL.Application.ActiveSheet.Range(RG).Borders(6).Weight:=1
		xlDiagonalDown		5	Border running from the upper-left corner to the lower-right of each cell in the range.
		xlDiagonalUp		6	Border running from the lower-left corner to the upper-right of each cell in the range.
		xlEdgeLeft		7	Border at the left edge of the range.
		xlEdgeTop			8	Border at the top of the range.
		xlEdgeBottom		9	Border at the bottom of the range.
		xlEdgeRight		10	Border at the right edge of the range.
		xlInsideVertical	11	Vertical borders for all the cells in the range except borders on the outside of the range.
		xlInsideHorizontal	12	Horizontal borders for all cells in the range except borders on the outside of the range.
	*/
	Obj:=PXL.Application.ActiveSheet.Range(RG)
	if Fill
	{
		loop 2
		{
		Border:=Obj.Borders(a_index+1)
		Border.Weight:=Weight
		Border.LineStyle:=Line
		}
	}

	while((Index:=A_Index+6)<=10){
		Border:=Obj.Borders(Index)
		Border.Weight:=Weight
		Border.LineStyle:=Line
	}
}

;***********************Row Height********************************.
;~ XL_Row_Height(XL,RG:="1:4=-1|10:13=50|21=15") ;rows first then height -1 is auto

/**
*
* @param {ComObject} PXL
* @param {Range} RG
*/
XL_Row_Height(PXL,RG:=""){
	for k, v in StrSplit(rg,"|") ;Iterate over array
		((Obj:=StrSplit(v,"="))[2]="-1")?(PXL.Application.ActiveSheet.rows(Obj[1]).AutoFit):(PXL.Application.ActiveSheet.rows(Obj[1]).RowHeight:=Obj[2])
}

;***********************Column Widths********************************.
;~ XL_Col_Width_Set(XL,RG:="A:B=-1|D:F=-1|H=15|K=3") ;-1 is auto

/**
 *
 * @param {ComObject} PXL
 * @param {Range} RG
 */
XL_Col_Width_Set(PXL,RG:=""){
	for k, v in StrSplit(rg,"|") ;Iterate over array
		((Obj:=StrSplit(v,"="))[2]="-1")?(PXL.Application.ActiveSheet.Columns(Obj[1]).AutoFit):(PXL.Application.ActiveSheet.Columns(Obj[1]).ColumnWidth:=Obj[2])
}

;***********************Column Insert********************************.
; XL_Col_Insert(PXL,RG:="A:A",WD:="20")

/**
 *
 * @param {ComObject} PXL
 * @param {Range} RG
 * @param {String} WD
 */
XL_Col_Insert(PXL,RG:="",WD:="5"){ ;Default width is 5
	PXL.Application.ActiveSheet.Columns(RG).Insert(-4161)
	PXL.Application.ActiveSheet.Columns(RG).ColumnWidth:=WD
}

;***********************Row Insert********************************.
;~ XL_Row_Insert(XL,RG:="1:5",HT:=16)  ;~ XL_Row_Insert(XL,RG:="1")

/**
 *
 * @param {ComObject} PXL
 * @param {Range} RG
 * @param {String} HT
 */
XL_Row_Insert(PXL,RG:="",HT:="15"){ ;default height is 15
	PXL.Application.ActiveSheet.Rows(RG).Insert(-4121)
	PXL.Application.ActiveSheet.Rows(RG).RowHeight:=HT
}

;***********************Column Delete********************************.
;~  XL_Col_Delete(XL,RG:="A:B|F|G|Z|BD ")

/**
 *
 * @param {ComObject} PXL
 * @param {Range} RG
 */
XL_Col_Delete(PXL,RG:=""){
	for j,k in StrSplit(RG,"|")
		List.=(InStr(k,":")?k:k ":" k) "," ;need to make for two if only 1 Row
	PXL.Application.ActiveSheet.Range(Trim(List,",")).Delete
}

;***********************Row Delete********************************.
;~ XL_Row_Delete(XL,RG:="4:5|9|67|8|10") ;range or single but cannot overlap

/**
 *
 * @param {ComObject} PXL
 * @param {Range} RG
 */
XL_Row_Delete(PXL,RG:=""){
	for j,k in StrSplit(RG,"|")
		List.=(InStr(k,":")?k:k ":" k) "," ;need to make for two if only 1 Row
	PXL.Application.ActiveSheet.Range(Trim(List,",")).Delete ;use list but remove final comma
}

;***********************Delete Column Based on Value********************************.
;~ XL_Delete_Col_Based_on_Value(XL,RG:="A1:H1",Val:="Joe")
/**
 *
 * @param {ComObject} PXL
 * @param {Range} RG
 * @param {String} Val
 */
XL_Delete_Col_Based_on_Value(PXL,RG:="",Val:=""){
	Columns:=[]
	For C in PXL.Application.ActiveSheet.Range(RG)
		If(C.Value==Val)
			Columns.InsertAt(1,(Col:=XL_Col_To_Char(C.Column)) ":" Col)
	for a,b in Columns
		PXL.Application.ActiveSheet.Range(b).EntireColumn.Delete
}

;***********************Row delete based on Column value********************************.
;~ XL_Delete_Row_Based_on_Value(XL,RG:="B1:B20",Val:="Joe")
/**
 *
 * @param {ComObject} PXL
 * @param {Range} RG
 * @param {String} Val
 */
XL_Delete_Row_Based_on_Value(PXL,RG:="",Val:=""){
	Rows:=[]
	For C in PXL.Application.ActiveSheet.Range(RG)
		If(C.Value==Val)
			Rows.InsertAt(1,(C.Row) ":" C.Row)
	for a,b in Rows
		PXL.Application.ActiveSheet.Range(b).EntireRow.Delete
}

;***********looping over cells*******************
/*
	For Cell in xl.range(XL.Selection.Address) {
		Current_Cell:=Cell.Address(0,0) ;get absolue reference; change to 1 if want releative
		MsgBox % cell.value
	}
*/

;*******************************************************.
;***********************Clipboard actions********************************.
;*******************************************************.
;***********************Copy to clipboard********************************.
;~ XL_Copy_to_Clipboard(XL,RG:="A1:A5")

/**
 *
 * @param {ComObject} PXL
 * @param {Range} RG
 */
XL_Copy_to_Clipboard(PXL,RG:=""){
	PXL.Application.ActiveSheet.Range(RG).Copy() ;copy to clipboard
}

;***********************Copy to a var and specify delimiter********************************.
;~ XL_Copy_to_Var(XL,RG:="A1:A5",Delim="|")
/**
 *
 * @param {ComObject} PXL
 * @param {Range} RG
 * @param {String} Delim
 * @returns {String}
 */
XL_Copy_to_Var(PXL,RG:="",Delim:="|"){ ;pipe is defualt
	For Cell in PXL.Application.ActiveSheet.Range(RG)
		Data.=Cell.Text Delim
	return Data:=Trim(Data,Delim) ;trimming off last delimiter
}

/**
 *
 * @param {ComObject} PXL
 * @param {Range} RG
 * @param {Integer} Blank_Values
 * @returns {Object}
 */
XL_Copy_To_Obj(PXL,RG:="",Blank_Values:=0){
	Data:= {}
	For Cell in PXL.Application.ActiveSheet.Range(RG)
		if(Cell.Text||Blank_Values)
			Data.%Cell.Address[0,0]%:=Cell.Text
	return Data
}

/**
 *
 * @param {ComObject} PXL
 * @param {Range} RG
 * @param {Integer} Blank_Values
 * @returns {Map}
 */
XL_Copy_To_MAP(PXL,RG:="",Blank_Values:=0){
	Data:= Map()
	For Cell in PXL.Application.ActiveSheet.Range(RG)
		if(Cell.Text||Blank_Values)
			Data[Cell.Address[0,0]]:=Cell.Text
	return Data
}
;***********************Paste ********************************.
;~ XL_Paste(XL,Source_RG:="C1",Dest_RG:="F1:F10",Paste:=1)

/**
 *
 * @param {ComObject} PXL
 * @param {Range} Source_RG
 * @param {String} Dest_RG
 * @param {String} Paste
 */
XL_Paste(PXL,Source_RG:="",Dest_RG:="",Paste:=""){       ;1=All 2=Values 3=Comments 4=Formats 5=Formulas 6=Validation 7=All Except Borders
	; Everything after 5 is the correct parameter for t he setting  I.e. "All Except Borders"=7
	Switch Paste
	{
		Case 1: Paste := -4104 ;xlPasteAll        ;8=Col Widths 11=Formulas and Number formats 12=Values and Number formats
		Case 2: Paste := -4163 ;xlPasteValues
		Case 3: Paste := -4144 ;xlPasteComments
		Case 4: Paste := -4122 ;xlPasteFormats
		Case 5: Paste := -4123 ;xlPasteFormulas
		Default: Paste := -4104 ;xlPasteFormulas
	}

	PXL.Application.ActiveSheet.Range(Source_RG).Copy
	PXL.Application.ActiveSheet.Range(Dest_RG).PasteSpecial(Paste)
}

;********************Select Cells / Range***********************************
;~ XL_Select_Range(XL,"A1:A4")

/**
 *
 * @param {ComObject} PXL
 * @param {Range} RG
 * @param {String} Sheet_Name
 */
XL_Select_Range(PXL,Range,Sheet_Name:=""){
	if (Sheet_Name="")
		PXL.Application.ActiveSheet.Range(Range).Select
	Else {
		XL_Select_Sheet(PXL,Sheet_Name)
		PXL.Sheets(Sheet_Name).Range(Range).Select
	}
}


;***********************deselect cells ********************************.
;~ XL_UnSelect(XL) ;Unselects highlighted cells
/**
 *
 * @param {ComObject} PXL
 */
XL_UnSelect(PXL){
	PXL.Application.CutCopyMode := False
}
;***********************Set cell values / Formulas********************************.

; XL_Set_Values(PXL,{A1:"the",A2:"last",B1:"term"}) ;Destination cell & Words are in an object with key-value pairs
; XL_Set_Values(PXL,Map("A1","the","A2","last","B1","term")) ;Destination cell & Words are in an Map with key-value pairs

/**
 *
 * @param {ComObject} PXL
 * @param Obj
 */
XL_Set_Values(PXL,Obj){
	switch Type(Obj),0
	{
		Case "Map":
			For key,Value in Obj ;use For loop to iterate over object keys & Values
				PXL.Application.ActiveSheet.Range(key).Value:=Value ;Set the cell(key) to the corresponding value
		Case "Object":
			For key,Value in Obj.OwnProps() ;use For loop to iterate over object keys & Values
				PXL.Application.ActiveSheet.Range(key).Value:=Value ;Set the cell(key) to the corresponding value
	}
}
;***********************Insert Comment********************************.
;~ XL_Insert_Comment(XL,RG:="b3",Comment:="Hello there`n`rMr monk`n`rWhatup",Vis:=1,Size:=11,Font:="Book Antique",ForeClr:=5)

/**
 *
 * @param {ComObject} PXL
 * @param {Range} RG
 * @param {String} Comment
 * @param {Integer} Vis
 * @param {Integer} Size
 * @param {String} Font
 * @param {Integer} ForeClr
 */
XL_Insert_Comment(PXL,RG:="",Comment:="",Vis:=0,Size:=11,Font:="Arial",ForeClr:=5){
	try
	{
		x := PXL.Application.ActiveSheet.Range(RG).comment.text
		if x
			PXL.Application.ActiveSheet.Range(RG).Comment.Delete
	}
	PXL.Application.ActiveSheet.Range(RG).Addcomment(Comment)
	PXL.Application.ActiveSheet.Range(RG).Comment.Visible := Vis
	PXL.Application.ActiveSheet.Range(RG).Comment.Shape.Fill.ForeColor.SchemeColor:=ForeClr
	PXL.Application.ActiveSheet.Range(RG).Comment.Shape.TextFrame.Characters.Font.size:=Size
	PXL.Application.ActiveSheet.Range(RG).Comment.Shape.TextFrame.Characters.Font.Name:=Font
}
;***********Insert new worksheet*******************
;~  XL_Insert_Worksheet(XL,"Test")

/**
 *
 * @param {ComObject} PXL
 * @param {String} Name
 */
XL_Insert_Worksheet(PXL,Name:=""){
	PXL.Sheets.Add ; Worksheet.Add ;add a new workbook
	If (Name)
		PXL.ActiveSheet.Name := Name
}
/**
 *
 * @param {ComObject} PXL
 * @param {String} Name
 */
XL_Delete_Worksheet(PXL,Name:="") => (Name)?PXL.Sheets(Name).Delete():PXL.ActiveSheet.Delete()
;********************Rename sheet***********************************
;~ XL_Rename_Sheet(XL,"Sheet 1","New_Name")
/**
 *
 * @param {ComObject} PXL
 * @param {String} Orig_Name
 * @param {String} New_Name
 */
XL_Rename_Sheet(PXL,Orig_Name,New_Name) => PXL.Sheets(Orig_Name).Name := New_Name

;********************move Active worksheet to be first***********************************

/**
 *
 * @param {ComObject} PXL
 */
XL_Move_Active_Sheet_to_First(PXL) => PXL.ActiveSheet.Move(PXL.Sheets(1)) ;# move active sheet to front

;********************Move X sheet to y location***********************************

/**
 *
 * @param {ComObject} PXL
 * @param {Integer} Orig_Index
 * @param {Integer} Dest_Index
 */
XL_Move_Xindex_to_yIndex(PXL,Orig_Index,Dest_Index) => PXL.Sheets(Orig_Index).Move(PXL.Sheets(Dest_Index))

;********************Move XXX sheet name to y location***********************************

/**
 *
 * @param {ComObject} PXL
 * @param {String} Sheet_Name
 * @param {Integer} Dest_Index
 */
XL_Move_SheetName_to_yIndex(PXL,Sheet_Name,Dest_Index) => PXL.Sheets(Sheet_Name).Move(PXL.Sheets(Dest_Index))

;***********************Insert Hyperlink********************************.
; this function inserts hyper link XL_Insert_Hyperlink inserts a hyperlink function
/**
 *
 * @param {ComObject} PXL
 * @param {Range} RG
 * @param {String} Link
 * @param {String} Name
 * @param {String} tooltip
 */
XL_Add_Hyperlink(PXL,RG:="",Link:="",Name:="",tooltip:= "")
{
	RG:=RG?RG:PXL.Selection.Address(0,0) ;If RG is blank, Get selection for use
	xlrange := PXL.ActiveSheet.range(RG)
	PXL.ActiveSheet.Hyperlinks.Add(xlrange, link, "", tooltip, Name)
}

;url needs to be in format https://www.google.com
; XL_Insert_Hyperlink(PXL,URL:="https://the-Automator.com",Display:="Coo coo",Destination_Cell:="C2")
; XL_Set_Values(PXL,{B1:"https://the-Automator.com"})
; XL_Insert_Hyperlink(PXL,URL:="B1",Display:="b1 refere",Destination_Cell:="B8")
/**
 *
 * @param {ComObject} PXL
 * @param {String} URL
 * @param {String} Display
 * @param {String} Destination_Cell
 * @returns {String}
 */
XL_Insert_Hyperlink(PXL,URL,Display,Destination_Cell) => PXL.Application.ActiveSheet.Range(Destination_Cell).Value:= '=Hyperlink(' (URL ~='http'? '"' URL '"' : URL) ',"' Display '")'

;***********************Insert Hyperlink via OFFSET in Columns (data is in rows)******************.
; XL_Set_Values(PXL,Map("c1:c8","the-Automator","b1:b8","https://the-Automator.com"))
; XL_Insert_Hyperlink_Offset_Col(PXL,RG:="E1:E8",URL:="-3",Freindly:="-2")

/**
 *
 * @param {ComObject} PXL
 * @param {String} Destination_RG
 * @param {String} URL_Offset
 * @param {String} Freindly_Offset
 */
XL_Insert_Hyperlink_Offset_Col(PXL,Destination_RG,URL_Offset,Freindly_Offset){
	For Cell in PXL.Application.ActiveSheet.Range(Destination_RG){
		Cell.Value:= '=Hyperlink("' . Cell.offset(0,URL_Offset).value . '","'  Cell.Offset(0,Freindly_Offset).Text '")'
}}
;***********************Insert Hyperlink via OFFSET in Rows (data is in Columns)******************.
;XL_Set_Values(PXL,Map("B17:C17","the-Automator","B16:C16","https://the-Automator.com"))
;XL_Insert_Hyperlink_Offset_Row(PXL,RG:="B18:C18",URL:="-2",Freindly:="-1") ;Neg values are rows Above/ Pos are Rows below
/**
 *
 * @param {ComObject} PXL
 * @param {Range} RG
 * @param {String} URL_Offset
 * @param {String} Freindly_Offset
 */
XL_Insert_Hyperlink_Offset_Row(PXL,RG:="",URL_Offset:="",Freindly_Offset:=""){
	For Cell in PXL.Application.ActiveSheet.Range(RG){
		Cell.Value:= '=Hyperlink("' . Cell.offset(URL_Offset,0).value . '","' . Cell.Offset(Freindly_Offset,0).Value . '")'
}}
;***********************Remove Hyperlink********************************.
;~ XL_Delete_Hyperlink_on_URL(XLs,RG="B1:B10")
/**
 *
 * @param {ComObject} PXL
 * @param {Range} RG
 */
XL_Delete_Hyperlink_on_URL(PXL,RG){
	For Cell in PXL.Application.ActiveSheet.Range(RG)
		Cell.Hyperlinks.Delete
}
;********************Get hyperlinks from selection and push into offset***********************************
; this function does not work for '=Hyperlink()' formula it works with  XL_Add_Hyperlink
;XL_Add_Hyperlink(PXL,"b1","https://the-Automator.com","The Automator","we automate stuff on windows")
;msgbox XL_GetHyperlinks(PXL,0,0,"b1")
/**
 *
 * @param {ComObject} PXL
 * @param {Integer} Row_Offset
 * @param {Integer} Col_Offset
 * @param {Range} RG
 * @returns {String}
 */
XL_GetHyperlinks(PXL,Row_Offset:=0,Col_Offset:=1,RG:=""){
	RG:=RG?RG:PXL.Selection.Address(0,0) ;If RG is blank, Get selection for use
	;~ msgbox % RG
	Text := ""
	For Cell in PXL.Application.ActiveSheet.Range(RG){ ;loop over selection
		try if(cell.Hyperlinks(1).Address){ ;only do if there is a hyperlinks
			;~ msgbox % cell.text
			If (Row_Offset=0) and (Col_Offset=0) ;if there is no offset, then return the data
				Text.=cell.Value A_Tab cell.Hyperlinks(1).Address "`n" ;append to var with tab delimiting
			Else
				cell.Offset(Row_Offset,Col_Offset).Value:=cell.Hyperlinks(1).Address
	}}
	Return text
}

;***********************insert email link********************************.

/*
XL_Set_Values(PXL,{
	A1:"Email",
	B1:"Subject",
	C1:"Body",
	D1:"Display",
	E1:"ToolTip",
	F1:"Email hyperlink",

	A2:"arbabirfan@gmail.com",
	B2:"Testing XL2.ahk",
	C2:"I am testing this insert email function",
	D2:"this is a test",
	E2:"this is a tooltip test",
	})
XL_Add_Email(PXL,"A2","B2","C2","D2","E2","F2")
*/

/**
 *
 * @param {ComObject} PXL
 * @param {String} email
 * @param {String} Subj
 * @param {String} Body
 * @param {String} Display
 * @param {String} tooltip
 * @param {String} Destination_RG
 */
XL_Add_Email(PXL,email,Subj,Body,Display,tooltip,Destination_RG:="")
{
	Link:= (
		'Mailto:' PXL.Application.ActiveSheet.Range(email).value
		'?Subject=' PXL.Application.ActiveSheet.Range(Subj).value
		'&Body=' PXL.Application.ActiveSheet.Range(Body).value
	)
	Display := PXL.Application.ActiveSheet.Range(Display).Value
	tooltip := PXL.Application.ActiveSheet.Range(tooltip).Value
	XL_Add_Hyperlink(PXL,Destination_RG,Link,Display,tooltip)
}

/*
XL_Set_Values(PXL,{
	A1:"Email",
	B1:"Subject",
	C1:"Body",
	D1:"Display",
	E1:"Email hyperlink",

	A2:"arbabirfan@gmail.com",
	B2:"Testing XL2.ahk",
	C2:"I am tetsing this insert email function",
	D2:"this is a test",
	})
XL_Insert_Email(PXL,"A2","B2","C2","D2","E2")
*/

/**
 *
 * @param {ComObject} PXL
 * @param {String} email
 * @param {Stinrg} Subj
 * @param {String} Body
 * @param {String} Display
 * @param {String} Destination_RG
 */
XL_Insert_Email(PXL,email,Subj,Body,Display,Destination_RG:=""){
	PXL.Application.ActiveSheet.Range(Destination_RG).Value:= '=HYPERLINK("Mailto:'
   . PXL.Application.ActiveSheet.Range(email).value
   . '?Subject=' PXL.Application.ActiveSheet.Range(Subj).value
   . '&Body=' . PXL.Application.ActiveSheet.Range(Body).value '","'
   . PXL.Application.ActiveSheet.Range(Display).Value . '")'
}
;***********************Insert email OFFSET in Columns ********************************.
/*
XL_Set_Values(PXL,{
	A1:"Email hyperlink",
	B1:"Email",
	C1:"Display",
	D1:"Subject",
	E1:"Body",

	B2:"arbabirfan@gmail.com",
	C2:"Testing XL2.ahk",
	D2:"this is a test",
	E2:"I am testing this insert email function",


	B3:"X@gmail.com",
	C3:"Testing 1",
	D3:"this is a test 1",
	E3:"I am testing this insert email function 1",

	B4:"Y@gmail.com",
	C4:"Testing 2",
	D4:"this is a test 2",
	E4:"I am testing this insert email function 2",

	B5:"Z@gmail.com",
	C5:"Testing 3",
	D5:"this is a test 3",
	E5:"I am testing this insert email function 3",
	})
XL_Insert_email_Offset_Col(PXL,Destination_RG:="A1:A15",email_OffSet:=1,Freindly_OffSet:=2,Subj_OffSet:=3,Body_OffSet:=4)
*/
;~ XL_Insert_email_Offset_Col(XL,RG:="E1:E5",URL:="-4",Freindly:="-3",Subj:="-2",Body:="-1") ;Neg values are col to left / Pos are col to right

/**
 *
 * @param {ComObject} PXL
 * @param {String} Destination_RG
 * @param {String} email_OffSet
 * @param {String} Freindly_OffSet
 * @param {String} Subj_OffSet
 * @param {String} Body_OffSet
 */
XL_Insert_email_Offset_Col(PXL,Destination_RG,email_OffSet:="",Freindly_OffSet:="",Subj_OffSet:="",Body_OffSet:=""){
	For Cell in PXL.Application.ActiveSheet.Range(Destination_RG){
		Cell.Value:= '=Hyperlink("mailto:' . Cell.offset(0,email_OffSet).value
		. '?Subject=' . Cell.offset(0,Subj_OffSet).Value '&Body=' Cell.offset(0,Body_OffSet).Value '","'
		. Cell.Offset(0,Freindly_OffSet).Value  '")'
	}
}
;***********************Insert email OFFSET in Rows ********************************.
;~ XL_email_Offset_Row(XL,RG:="B24:D24",URL:="-3",Freindly:="-2",Subj:="-1") ;Neg values are Rows Above / Pos are Rows below
/**
 *
 * @param {ComObject} PXL
 * @param {String} Destination_RG
 * @param {String} URL
 * @param {String} Freindly
 * @param {String} Subj
 */
XL_email_Offset_Row(PXL,Destination_RG,URL:="",Freindly:="",Subj:=""){
	For Cell in PXL.Application.ActiveSheet.Range(Destination_RG){
		Cell.Value:= '=Hyperlink("mailto:' . Cell.offset(URL,0).value . '?Subject=' . Cell.offset(Subj,0).Value . '","' . Cell.Offset(Freindly,0).Value . '")'
	}
}

;~ XL_Search_Replace(XL,RG:="A1:A39",Sch:="Text",Rep:="New Text",Match_Case:="True",CellCont:=0) ;CC=1 Exact, 2=Any

/**
 *
 * @param {ComObject} PXL
 * @param {String} RG
 * @param {String} Sch
 * @param {String} Rep
 * @param {String} Match_Case
 * @param {String} Exact_Match
 */
XL_Search_Replace(PXL,RG:="",Sch:="",Rep:="",Match_Case:="0",Exact_Match:="0")
{
	Exact_Match:= (Exact_Match="0")?("2"):("1")
	SchRrange := PXL.Application.ActiveSheet.Range[RG]
	f := SchRrange.Find(Sch)
	f.Replace(Schedule:=Sch,
		Replace:=Rep,
		Exact_Match,
		SearchOrder:=1,
		MatchCase:=Match_Case,
		MatchByte:=True,
		ComValue(0xB,-1),
		ComValue(0xB, -1)
	)
}

; not working
; XL_Search_Replace(PXL,RG:="",Sch:="",Rep:="",Match_Case:="0",Exact_Match:="0"){
; 	Exact_Match:= (Exact_Match="0")?("2"):("1") ;If set to zero then change to 2 so matches any
; 	;~ Exact_Match:= Exact_Match=0?2:1 ;If set to zero then change to 2 so matches any
; 	RG:=(RG)?(RG):(XL_Used_RG(PXL,0)) ;If Range not provided, default to used range
; 	For Cell in PXL.Application.ActiveSheet.Range(RG){
; 		If Cell.Find[Sch]{
; 			cell.Replace(Schedule:=Sch,
; 			Replace:=Rep,
; 			Exact_Match,
; 			SearchOrder:=1,
; 			MatchCase:=Match_Case,
; 			MatchByte:=True,
; 			ComValue(0xB,-1),
; 			ComValue(0xB, -1)
; 			)
; 		}
; 	}
;}

;********************VLookup***********************************
/*
XL_Set_Values(PXL,{
	A1:"Fruit",
	B1:"count",
	D1:"lookup Name",
	E1:"Result",

	A2:"Apple",
	B2:10,
	D2:"Banana",

	A3:"Mango",
	B3:6,
	D3:"Orange",

	A4:"Lime",
	B4:12,
	D4:"Apple",

	A5:"Peach",
	B5:19,
	D5:"Cherry",

	A6:"Grapes",
	B6:21,
	D6:"Mango",

	A7:"Cherry",
	B7:30,
	D7:"Lime",

	A8:"Banana",
	B8:12,
	D8:"guava",

	A9:"Orange",
	B9:24,
	D9:"Grapes",

	A10:"guava",
	B10:7,
	D10:"Peach",
	})
*/
; XL_VLookup(PXL,"E2:E10","D2:D10","A1:B10",2,0)
/**
 *
 * @param {ComObject} PXL
 * @param {String} Destination_RG
 * @param {String} Vals_to_Lookup_RG
 * @param {Stinrg} Source_Array_RG
 * @param {String} ColNumb_From_Array
 * @param {Integer} Exact_Match
 */
XL_VLookup(PXL,Destination_RG,Vals_to_Lookup_RG,Source_Array_RG,ColNumb_From_Array,Exact_Match:=0){
	PXL.Range(Destination_RG).value := PXL.VLookup( PXL.Range(Vals_to_Lookup_RG).value, PXL.Range(Source_Array_RG) ,ColNumb_From_Array,0 )
}


/*
XL_Set_Values(PXL,{
	A1:"Fruit",
	B1:"count",
	D1:"lookup Value",
	E1:"Result",

	A2:"Apple",
	B2:10,
	D2:"Banana",

	A3:"Mango",
	B3:6,
	D3:"Orange",

	A4:"Lime",
	B4:12,
	D4:"Apple",

	A5:"Peach",
	B5:19,
	D5:"Cherry",

	A6:"Grapes",
	B6:21,
	D6:"Mango",

	A7:"Cherry",
	B7:30,
	D7:"Lime",

	A8:"Banana",
	B8:12,
	D8:"guava",

	A9:"Orange",
	B9:24,
	D9:"Grapes",

	A10:"guava",
	B10:7,
	D10:"Peach",
	})
sleep 100
*/
;XL_insert_Vlookup(PXL,"E2:E10","D2:D10","A1:B10",2,0)

/**
 *
 * @param {ComObject} PXL
 * @param {Stinrg} Destination_RG
 * @param {String} Vals_to_Lookup_RG
 * @param {Stinrg} Source_Array_RG
 * @param {String} ColNumb_From_Array
 * @param {Integer} Exact_Match
 */
XL_insert_Vlookup(PXL,Destination_RG,Vals_to_Lookup_RG,Source_Array_RG,ColNumb_From_Array,Exact_Match:=0)
{
	lv := PXL.ActiveSheet.Range(Vals_to_Lookup_RG)
	for cell in PXL.ActiveSheet.Range(Destination_RG)
		cell.value := '=vlookup('  lv.cells(a_index,1).address[0,0] ',' Source_Array_RG ','  ColNumb_From_Array ',' Exact_Match ')'
}

;**********************Dictionary Search / REplace - multiple in range*********************************
;~ Search_Replace_Multiple(XL,rg:="A1:A10", {"ACC":"Account Spec.","RMK":"Rel Mark"})

/**
 *
 * @param {ComObject} PXL
 * @param {String} RG
 * @param {String} Terms
 */
XL_Search_Replace_Multiple(PXL,RG:="",Terms:=""){
	RG:=(RG)?(RG):(XL_Used_RG(PXL,0)) ;If Range not provided, default to used range
	For Cell in PXL.Application.ActiveSheet.Range(RG) ;Use For loop to iterate over each cell in range
		for key, val in Terms ;Terms is Object passed in form of dictionary
			if Cell.Value=(key)  ;look for key
				Cell.Value:=Val   ;if found, change to corresponding value
}

;**********************replace "#NULL!"*********************************
;~  XL_Replace_Null(PXL,RG)

/**
 * 
 * @param {ComObject} PXL
 * @param {String} RG 
 */
XL_Replace_Null(PXL,RG:=""){
	RG:=(RG)?(RG):(XL_Used_RG(PXL,0)) ;If Range not provided, default to used range
	PXL.Range(RG).Replace("#NULL!","")  ;
}

;********************Find location of text and return the position***********************************
;~ XL_Find_And_Return_Position(XL,"A5:F5","5",0,3)

/**
 *
 * @param {ComObject} PXL
 * @param {String} RG
 * @param {String} Search
 * @param {Integer} Absolute
 * @param {Integer} Instance
 * @returns {String}
 */
XL_Find_And_Return_Position(PXL,RG:="",Search:="",Absolute:=0,Instance:=1){
	RG:=(RG)?(RG):(XL_Used_RG(PXL,0)) ;If Range not provided, default to used range
	Index:=0
	For Cell in PXL.Application.ActiveSheet.Range(RG) { ;Use For loop to iterate over each cell in range
		if Cell.Value=(Search) { ;Stop looping if you find the value
			Index++ ;Increment Index
			If (Index=Instance){ ;If this is the correct instance
				if Absolute
					Return Cell.address ;;~  Cell with $ in them
				Else
					Return Cell.address(0,0) ;;Cell without $ in them

				/*
					Return Absolute?Cell.Address:Cell.Address(0,0)
				*/
			}
		}
	} Return "Not found" ;If finish looping then it was not found
}


;********************search***Find columns based on header********************************.
;~  loc:=XL_Find_Headers_in_Cols(XL,["email","country","Age"]) ;pass search terms as an array
;~  MsgBox % "email: "  loc["email"]   .  "`nCountry: " loc["country's"]   .  "`nAge: " loc["Age"]
/**
 *
 * @param {ComObject} PXL
 * @param {Integer} Values
 * @returns {Object}
 */
XL_Find_Headers_in_Cols(PXL,Values){
	Headers:=map() ;need to create the object for storing Key-value pairs of search term and Location
	for k, Search_Term in Values{
		Loop XL_Last_Col_Nmb(PXL){ ;loop over all used columns
			if (PXL.Application.ActiveSheet.cells(1,A_Index).Value=Search_Term) ;if cell in row 1, column A_Index = search term
				Headers[Search_Term]:=XL_Col_To_Char(A_Index)  ;"1" ;set column to value in Hearders object
		}
	} return Headers ;return the key-value pairs Object
}

;***********************Clear********************************.
;~  XL_Clear(XL,RG:="A1:A8",All:=0,Format:=0,Content:=0,Hyperlink:=1,Notes:=0,Outline:=0,Comments:=1) ;0 clears contents but leaves formatting 1 clears both
/**
 *
 * @param {ComObject} PXL
 * @param {String} RG
 * @param {Integer} All
 * @param {Integer} Format
 * @param {Integer} Content
 * @param {Integer} Hyperlink
 * @param {Integer} Notes
 * @param {Integer} Outline
 * @param {Integer} Comments
 */
XL_Clear(PXL,RG:="",All:=0,Format:=0,Content:=0,Hyperlink:=0,Notes:=0,Outline:=0,Comments:=0){
	; https://analysistabs.com/excel-vba/clear-cells-data-range-worksheet/  ;https://msdn.microsoft.com/en-us/vba/excel-vba/articles/range-clearcontents-method-excel
	Obj:=PXL.Application.ActiveSheet.Range(RG)
	if(All=1)
		return Obj.Clear           ;clear the range of cells including Formats

	(Format=1)   ? (Obj.ClearFormats)    : "" ;clear Formats but leave data
	(Content=1)  ? (Obj.ClearContents)   : "" ;clear Data but leave Formats
	(Hyperlink=1)? (Obj.ClearHyperlinks) : "" ;clear Hyperlinks but leave formatting & Data
	(Notes=1)    ? (Obj.ClearNotes)      : "" ;clear Notes
	(Outline=1)  ? (Obj.ClearOutline)    : "" ;clear Outline
	(Comments=1) ? (Obj.ClearComments)   : "" ;clear Comments
}
;***********************Delete blank columns*********** ;Jetrhow wrote this http://www.autohotkey.com/board/topic/69033-basic-ahk-l-com-tutorial-for-excel/?p=557697
;~ XL_Delete_Blank_Col(XL)

/**
 *
 * @param {ComObject} PXL
 */
XL_Delete_Blank_Col(PXL){
	for column in PXL.Application.ActiveSheet.UsedRange.Columns
		if !PXL.Application.WorkSheetFunction.count(column)
			delete_range .= column.entireColumn.address(0,0) ","
	Try PXL.Application.Range(Trim(delete_range,",")).delete() ;remove last comma and delete columns
	Catch
		MsgBox("no missing COLUMNS","XL: No Missing Columns",1)
}
;***********************Delete blank Rows********************************.
;~ XL_Delete_Blank_Row(XL)
/**
 *
 * @param {ComObject} PXL
 */
XL_Delete_Blank_Row(PXL){
	for Row in PXL.Application.ActiveSheet.UsedRange.Rows
		if !PXL.Application.WorkSheetFunction.counta(Row)
			delete_range .= Row.entireRow.address(0,0) ","
	Try PXL.Application.Range(Trim(delete_range,",")).delete()
	Catch
		MsgBox("no missing ROWS","XL: No Missing Rows",1)
}
;***********************Delete Column based on Header********************************.
;~ XL_DropColumns_Per_Header(XL,Values:="One|Two|more")
/**
 *
 * @param {ComObject} PXL
 * @param {String} Values
 */
XL_DropColumns_Per_Header(PXL,Values:=""){
	LoopCount:=XL_Last_Col_Nmb(PXL)
	Loop LoopCount
	{
		Col:=loopCount-(A_Index-1)
		Header:=PXL.Application.ActiveSheet.cells(1,Col).Value
		Loop parse Values, "|"
			If (Header=A_LoopField)
				PXL.Application.ActiveSheet.Columns(Col).Delete
	}
}

;~XL_DropRows_Per_First_Col(XL,"Joe")
/**
 *
 * @param {ComObject} PXL
 * @param {String} Values
 */
XL_DropRows_Per_First_Col(PXL,Values:=""){
	Values:=StrSplit(Values,"|")
	LoopCount:=PXL.ActiveSheet.Cells.SpecialCells(11).Row
	Loop LoopCount
	{
		Row:=LoopCount-(A_Index-1)
		Header:=PXL.Application.ActiveSheet.Cells(Row,1).Text
		for a,Value in Values
			If (Header==Value)
				PXL.Application.ActiveSheet.Rows(Row).Delete
	}
}
;***********************Remove Duplicates / Dedupe********************************.
;~ XL_Remove_Dup_Used_Range(XL)
/**
 *
 * @param {ComObject} PXL
 * @param {String} Header_Text
 */
XL_Remove_Dup_Used_Range(PXL,Header_Text:=""){
	Dedupe_CL:=PXL.Application.ActiveSheet.Rows(XL_First_Row(PXL)).Find(Header_Text).column
	PXL.Application.ActiveSheet.Range(XL_Used_RG(PXL)).RemoveDuplicates(Columns:=Dedupe_CL).Header:=1 ;added header
}
;***********************Sort by Column ********************************.
;~ XL_Sort_UsedRange(XL,Head:=1,Sort_Col:="A",Ord:="d") ;Sort used range w/without header
/**
 *
 * @param {ComObject} PXL
 * @param {String} Head
 * @param {String} Sort_Col
 * @param {String} Ord
 */
XL_Sort_UsedRange(PXL,Head:="1",Sort_Col:="",Ord:="A"){
	Range:=XL_Used_RG(PXL,Header:=Head)
	Ord := Format('{:U}',Ord)
	Sort_Col:=XL_String_To_Number(Sort_Col)+0 ; w/o the +0 will not work even though it is integer???
	switch Ord
	{
		Case 'A': PXL.Application.ActiveSheet.Range(Range).Sort(PXL.Application.ActiveSheet.Columns(Sort_Col),1) ;Ascending
		Case 'D': PXL.Application.ActiveSheet.Range(Range).Sort(PXL.Application.ActiveSheet.Columns(Sort_Col),2) ;Descending
	}
}
;***********************Sort Two Columns********************************.
;~ XL_Sort_TwoCols_UsedRange(XL,1,Sort_1:="a",Ord_1:="D",Sort_2:="b",Ord_2:="d")
/**
 *
 * @param {ComObject} PXL
 * @param {String} Head
 * @param {String} Sort_1
 * @param {String} Ord_1
 * @param {String} Sort_2
 * @param {String} Ord_2
 */
XL_Sort_TwoCols_UsedRange(PXL,Head:="1",Sort_1:="b",Ord_1:="a",Sort_2:="c",Ord_2:="a"){
		/*
			StringUpper, Ord_1, Ord_1, StringUpper, Ord_2, Ord_2
			IfEqual, Ord_1,A,SetEnv,Ord_1,1
			IfEqual, Ord_1,D,SetEnv,Ord_1,2
			IfEqual, Ord_2,A,SetEnv,Ord_2,1
			IfEqual, Ord_2,D,SetEnv,Ord_2,2
		*/

		Ord_1:=Ord_1="A"?1:2
		Ord_2:=Ord_2="A"?1:2

	;~ PXL.Application.ActiveSheet.Range(XL_Used_RG(PXL,Header:=1)).Sort(PXL.Application.ActiveSheet.Columns(XL_String_To_Number(Sort_2)+0),Ord_2),PXL.Application.ActiveSheet.Range(XL_Used_RG(PXL,Header:=1)).Sort(PXL.Application.ActiveSheet.Columns(XL_String_To_Number(Sort_1)+0),Ord_1)
		PXL.Application.ActiveSheet.Range(XL_Used_RG(PXL,Header:=Head)).Sort(PXL.Application.ActiveSheet.Columns(XL_String_To_Number(Sort_2)+0),Ord_2),PXL.Application.ActiveSheet.Range(XL_Used_RG(PXL,Header:=Head)).Sort(PXL.Application.ActiveSheet.Columns(XL_String_To_Number(Sort_1)+0),Ord_1) ;suggested by Dink G.
	}

;***********Sort by Row*****https://docs.microsoft.com/en-us/office/vba/api/Excel.Range.Sort**************

/**
 *
 * @param {ComObject} PXL
 * @param {String} RG
 * @param {String} Sort_Row
 * @param {String} Ord
 */
XL_Sort_Rows(PXL,RG,Sort_Row:="",Ord:="A"){
		/*
			StringUpper,Ord,Ord
			IfEqual, Ord,A,SetEnv,Ord,1 ;Ascending
			IfEqual, Ord,D,SetEnv,Ord,2 ;Descending
		*/
		Ord:=Ord="A"?1:2
		PXL.Range(RG).Sort(PXL.rows(Sort_Row),Ord,,,,,,,,,2) ;the last 2 tells it to sort by rows instead of columns
	}

;********************Text to Column / Parse strings in Excel***********************************
;~ XL_Text_to_Column(XL,"A1","B1",Tab:=1,Semicolon:=1,Comma:=1,Space:=0,Other:=1,"|")
/**
 *
 * @param {ComObject} PXL
 * @param {String} Src_RG
 * @param {String} Dest_Cell
 * @param {Integer} Tab
 * @param {Integer} semicolon
 * @param {Integer} comma
 * @param {Integer} space
 * @param {Integer} other
 * @param {String} Other_Value
 */
XL_Text_to_Column(PXL,Src_RG,Dest_Cell,Tab:=0,semicolon:=0,comma:=0,space:=0,other:=0,Other_Value:=""){
		PXL.Range(Src_RG).TextToColumns(PXL.range(Dest_Cell),1,1,0,tab,semicolon,comma,space,other,Other_Value)
}


;***********************Auto filter********************************.
;***********************Clear Auto filter********************************.
;~ XL_Filter_Clear_AutoFilter(XL)
/**
 *
 * @param {ComObject} PXL
 */
XL_Filter_Clear_AutoFilter(PXL) => PXL.Application.ActiveSheet.Range(XL_Used_RG(PXL,Header:=0)).AutoFilter ;Clear autofilter

;***********Add filters*******************
;~ XL_Filter_Turn_On(XL,"A:G")
/**
 *
 * @param {ComObject} PXL
 * @param {String} Col_RG
 */
XL_Filter_Turn_On(PXL,Col_RG:=""){
		CoL_RG:=(Col_RG)?(Col_RG):(XL_Used_RG(PXL,0)) ;If Range not provided, default to used range
		PXL.Application.ActiveSheet.Range(COL_RG).AutoFilter ;Clear autofilter
}

;********************* AUtofiler header row ********************
; HedareRow := XL_GetAutofilerHeaderRow(XL) ; return header row of autofilter

/**
 * 
 * @param {ComObject} PXL
 */
XL_GetAutofilerHeaderRow(PXL)
{
	if PXL.ActiveSHeet.AutofilterMode
		return PXL.Activesheet.AutoFilter.Range.row
}

;***********************Filter Used Range********************************.
;~ XL_Filter_Column(XL,Filt_Col:="a",FilterA:="joe",FilterB:="king")
/**
 *
 * @param {ComObject} PXL
 * @param {String} Filt_Col
 * @param {String} FilterA
 * @param {String} FilterB
 */
XL_Filter_Column(PXL,Filt_Col:="",FilterA:="",FilterB:=""){
		PXL.Application.ActiveSheet.Range(XL_Used_RG(PXL,Header:=0)).AutoFilter ;Clear autofilter
		PXL.Application.ActiveSheet.Range(XL_Used_RG(PXL,Header:=0)).AutoFilter(XL_String_To_Number(Filt_Col),FilterA,2,FilterB)
}
;********************Get cell from specific worksheet / named worksheet***********************************
/**
 *
 * @param {ComObject} PXL
 * @param {String} Cell
 * @param {String} Worksheet
 */
XL_Get_Value_On_Specific_Worksheet(PXL,Cell,Worksheet:=""){
		if (Worksheet)
			return PXL.Worksheets(Worksheet).Range(Cell).Value
		Return PXL.Application.ActiveSheet.Range(Cell).Value
}

;********************Set cell from specific worksheet / named worksheet***********************************
/**
 *
 * @param {ComObject} PXL
 * @param {String} Cell
 * @param {Integer} Value
 * @param {String} Worksheet
 */
XL_Set_Value_On_Specific_Worksheet(PXL,Cell,Value,Worksheet:=""){
	if ( Worksheet)
		PXL.Worksheets(Worksheet).Range(Cell).Value:=Value
		Else PXL.Application.ActiveSheet.Range(Cell).Value:=Value

}
;********************Get selected range (set absolute to 1 if you want $)***********************************
;~ Range:=XL_Get_Selected_Range(XL,0)
/**
 *
 * @param {ComObject} PXL
 * @param {Integer} Absolute
 */
XL_Get_Selected_Range(PXL,Absolute:=0){
		if Absolute
			Address:=PXL.Selection.address ;;~  Selected range with $ in them
		Else
			Address:=PXL.Selection.address(0,0) ;;Selected range without $ in them
		return Address
}
;********************Get First selected Column***********************************
;~ XL_Get_First_Selected_Col(XL)
/**
 *
 * @param {ComObject} PXL
 * @returns {String}
 */
XL_Get_First_Selected_Col(PXL){
		return XL_Col_To_Char(PXL.Selection.column)
}

;********************Get first selected row***********************************
/**
 *
 * @param {ComObject} PXL
 */
XL_Get_First_Selected_Row(PXL){
		return PXL.Selection.row
}
;  *******************************************************
;**************************File********************************
;  *******************************************************.
;~ XL:=XL_Start_Get(1,1) ;store pointer to Excel Application in XL
;~ XL:=XL_Start_Get(1,0) ;store pointer to Excel- start off hidden
/**
 *
 * @param {Integer} Vis
 * @param {Integer} Add_Blank_Worksheet
 * @returns {ComObject<"Excel.Application">}
 */
XL_Start_Get(Vis:=1,Add_Blank_Worksheet:=1){
	Try {
		PXL := XL_Handle(1)
		PXL.Visible := Vis
	}
	Catch{
		PXL := ComObject("Excel.Application") ;handle
		PXL.Visible := Vis ; 1=Visible/Default 0=hidden
		If (Add_Blank_Worksheet)
			PXL.Workbooks.Add()
	}
	Return PXL
}
;***********************Open********************************.
;***********************open excel********************************.
;~ XL_Open(XL,Vis:=1,Path:="B:\Americas.xlsx") ;XL is pointer to workbook, Vis=0 for hidden Try=0 for new Excel
/**
 *
 * @param {ComObject} PXL
 * @param {Integer} vis
 * @param {String} Path
 */
Xl_Open(PXL,vis:=1,Path:=""){
	PXL.Visible := vis ;1=Visible/Default 0=hidden
	Return PXL.Workbooks.Open(path) ;wrb =handle to specific workbook
}

;~ XL := XL_GetApplicationfromWorkbook(WB) ; XL is pointer to application & WB is pointer to workbook
/**
 *
 * @param WB
 */
XL_GetApplicationfromWorkbook(WB){
	return WB.application
}

;***********Detect and opens Tab & Comma delimited, HTML, XML and Excel 2003/2007 with pre-set defaults********************************.
;~ XL_Multi_Opener(XL,FullFileName:="C:\Diet.txt")
;~ XL_Multi_Opener(XL,FullFileName:="C:\Users\Joe\Downloads\Roofers_6.csv")
;~ XL_Multi_Opener(XL,FullFileName:="C:\Users\Joe\Dropbox\diet.xlsx")
;~ XL_Multi_Opener(XL,FullFileName:="C:\Users\Joe\Dropbox\Custom\MyDocs\Files\New Start.html")
;~ XL_Multi_Opener(XL,FullFileName:="B:\Progs\AutoHotkey_L\TI\Engage\API\Mailings Feb 01, 2013.xlsx")
;~ XL_Multi_Opener(XL,FullFileName:="B:\Progs\AutoHotkey_L\TI\Engage\API\mailing.xml")
/**
 *
 * @param {ComObject} PXL
 * @param {String} FullFileName
 */
XL_Multi_Opener(PXL,FullFileName:=""){
	Ext := RegExReplace(FullFileName,"(.*)\.(\w{3,4})", "$L2") ;grab Extension and Lowercase it
	If (EXT="txt") or (EXT="txt") or (Ext="csv") or (Ext="tab"){
		TabD:=False, csvD:=False
		Switch ext, 0
		{
			Case 'txt': tabD := True
			Case 'tsv': tabD := True
			Case 'csv': csvD := True
		}

		SafeArray := ComObjArray(0xC,2,2)
		SafeArray[0, 0] := 1    ; Column Number
		SafeArray[0, 1] := 2    ; xlTextFormat
		SafeArray[1, 0] := 2    ; Column Number
		SafeArray[1, 1] := 1    ; xlGeneralFormat

		PXL.Workbooks.OpenText(FullFileName,origin:=65001,StartRow:=1,DataType:=1,TextQualifier:=1,ConsecutiveDelimiter:=False,Tab:=TabD,Semicolon:=False,Comma:=csvD,Space:=False,Other:=False,,SafeArray,,,True)
	;~ PXL.Application.Workbooks.OpenText(FullFileName), ;origin:=65001, StartRow:=1, DataType:=1, TextQualifier:=1, ConsecutiveDelimiter:=False, Tab:=tabD, Semicolon:=False, Comma:=csvD, Space:=False, Other:=False, FieldInfo:=Array(Array(1, 1), Array(2, 1)), TrailingMinusNumbers:=True
	;~  PXL.Application.Workbooks.OpenText(FullFileName,origin:=65001, StartRow:=1, DataType:=1, TextQualifier:=1, ConsecutiveDelimiter:=False, Tab:=tabD, Semicolon:=False, Comma:=csvD, Space:=False, Other:=False, FieldInfo:=Array(Array(1, 1), Array(2, 1)), TrailingMinusNumbers:=True)
	} Else if (Ext="xml"){
		PXL.Application.Workbooks.OpenXML(FullFileName, 1, 2) ;.LoadOption.2 ;import xml file
	} Else If (Ext ~= "xls|htm") {
		PXL.Application.Workbooks.Open(FullFileName) ;Opens Excel 2003,2007 and html
}}
;***********************Save as********************************.
;~  XL_Save(Wrb,File:="C:\try",Format:="2007",WarnOverWrite:=0) ;2007
;~ XL_Save(Wrb,File:="C:\try",Format:="2007",WarnOverWrite:=0) ;2007 format no warn on overwrite
;~ XL_Save(Wrb,File:="C:\try",Format:="CSV",WarnOverWrite:=1) ;CSV format warn on overwrite
;~ XL_Save(Wrb,File:="C:\try",Format:="TAB",WarnOverWrite:=0) ;Tab delimited no warn on overwrite
/**
 *
 * @param {ComObject} PXL
 * @param {String} File
 * @param {String} xlFormat
 * @param {Integer} WarnOverWrite
 */
XL_Save(PXL,File:="",xlFormat:="2007",WarnOverWrite:=0){
		PXL.Application.DisplayAlerts := WarnOverWrite ;doesn't ask if I care about overwriting the file
		Switch xlFormat, 0
		{
			Case 'TAB' : Format := -4158 ;Tab':
			Case 'CSV' : Format :=     6 ;CSV':
			Case '2003': Format :=    56 ;2003 format':
			Case '2007': Format :=    51 ;2007 format':
		}
		PXL.Application.ActiveWorkbook.Saveas(File, Format) ;save it
		PXL.Application.DisplayAlerts := true ;Turn back on warnings
}
;***********************Quit********************************.
/**
 *
 * @param {ComObject} PXL
 */
XL_Quit(&PXL){
		PXL.Application.Quit
		PXL:=""
}

;***********Create a new workbook*******************
;~  XL_Create_New_Workbook(XL)
/**
 *
 * @param {ComObject} PXL
 */
XL_Create_New_Workbook(PXL) => PXL.Workbooks.Add() ;create new workbook

;***********************MRU*********************************.
;~ XL_Handle(XL,1) ;1=Application 2=Workbook 3=Worksheet
;~ MRU(FileName:="")

/**
 *
 * @param {ComObject} PXL
 * @param {String} FileName
 */
XL_MRU(PXL,FileName:=""){
	PXL.RecentFiles.Add(FileName) ;adds file to recently accessed file list
	mruList := []
	For file in ComObject("Excel.Application").RecentFiles
		if  (A_Index != 1)
			mruList.Insert(file.name)
	mruList.Insert(RegExReplace(Filename,"^[A-Z]:")) ;adds to MRU list
}
;***********close workbook*******************
;~XL.Close_Workbook(XL,1) ;close need pointer to workbook, will close first workbook
;~ XL_Close_Workbook(XL,"My Workbook") ;close workbook by name
;~ XL_Close_Workbook(XL,"B:\Tracts")

/**
 *
 * @param {ComObject} PXL
 * @param {String} File_Path
 */
XL_Close_Workbook(PXL,File_Path:=""){
		If (File_Path)
			PXL.Workbooks(File_Path).Close
		Else PXL.ActiveWorkbook.Close
}
;***********Save & close workbook*******************
;~ XL.XL_SaveClose_Workbook(XL,1) 			;Save then close need pointer to workbook, will close first workbook
;~ XL_SaveClose_Workbook(XL,"My Workbook") 	;Save then close workbook by name
;~ XL_SaveClose_Workbook(XL,"B:\Tracts")

/**
 *
 * @param {ComObject} PXL
 * @param {String} File_Path
 */
XL_SaveClose_Workbook(PXL,File_Path:=""){
		If (File_Path)
			PXL.Workbooks(File_Path).Close(1)
		Else PXL.ActiveWorkbook.Close(1)
}

;********************Good examples***********************************
;~ https://excel.officetuts.net/en/vba/deleting-a-row-with-vba

;~ XL_ListWorkbooks() ;Get a list of all Active Excel Instances borrowed from Jethrow and Tre4shunter https://github.com/tre4shunter/XLFunctions/
XL_ListWorkbooks(){
	wbObj:=[], i=1
	for name, obj in GetActiveObjects()
		if (ComobjType(obj, "Name") = "_Workbook"){
			SplitPath(name,&oFN)
			wbObj[i++] := oFN
		}
	return wbObj
}

; for AHK V1 by lexikos http://ahkscript.org/boards/viewtopic.php?f=6&t=6494
; for AHK V2 by fatodubs https://www.autohotkey.com/boards/viewtopic.php?f=82&t=80074&hilit=GetActiveObjects
; gets all active comObjects that are available on the system
/**
 *
 * @param {String} Prefix
 * @param {String} CaseSensitive
 * @returns {Map}
 */
GetActiveObjects(Prefix:="",CaseSensitive:="Off") {
    objects:=Map()
    DllCall("ole32\CoGetMalloc", "uint", 1, "ptr*", &malloc:=0) ; malloc: IMalloc
    DllCall("ole32\CreateBindCtx", "uint", 0, "ptr*", &bindCtx:=0) ; bindCtx: IBindCtx
    ComCall(8, bindCtx, "ptr*",&rot:=0) ; rot: IRunningObjectTable
    ComCall(9, rot, "ptr*", &enum:=0) ; enum: IEnumMoniker
    while (ComCall(3, enum, "uint", 1, "ptr*", &mon:=0, "ptr", 0)=0) ; mon: IMoniker
    {
        ComCall(20, mon, "ptr", bindCtx, "ptr", 0, "ptr*", &pname:=0) ; GetDisplayName
        name:=StrGet(pname, "UTF-16")
        ComCall(5,malloc,"ptr",pname) ; Free
        if ((Prefix="") OR (InStr(name,Prefix,CaseSensitive)=1)) {
            ComCall(6, rot, "ptr", mon, "ptr*", obj:=ComValue(13, 0, 1)) ; GetObject
            ; Wrap the pointer as IDispatch if available, otherwise as IUnknown.
            try obj := ComObjQuery(obj, "{00020400-0000-0000-C000-000000000046}")
            ; Store it in the return array by suffix.
            objects[SubStr(name,StrLen(Prefix) + 1)] := obj
        }
        ObjRelease(mon)
    }
    ObjRelease(enum)
    ObjRelease(rot)
    ObjRelease(bindCtx)
    ObjRelease(malloc)
    return objects
}

; GetActiveObjects(Prefix:="", CaseSensitive:=false) {
; 		objects := {}
; 		DllCall("ole32\CoGetMalloc", "uint", 1, "ptr*", malloc) ; malloc: IMalloc
; 		DllCall("ole32\CreateBindCtx", "uint", 0, "ptr*", bindCtx) ; bindCtx: IBindCtx
; 		DllCall(NumGet(NumGet(bindCtx+0)+8*A_PtrSize), "ptr", bindCtx, "ptr*", rot) ; rot: IRunningObjectTable
; 		DllCall(NumGet(NumGet(rot+0)+9*A_PtrSize), "ptr", rot, "ptr*", enum) ; enum: IEnumMoniker
; 		while DllCall(NumGet(NumGet(enum+0)+3*A_PtrSize), "ptr", enum, "uint", 1, "ptr*", mon, "ptr", 0) = 0 { ; mon: IMoniker
; 			DllCall(NumGet(NumGet(mon+0)+20*A_PtrSize), "ptr", mon, "ptr", bindCtx, "ptr", 0, "ptr*", pname) ; GetDisplayName
; 			name := StrGet(pname, "UTF-16")
; 			DllCall(NumGet(NumGet(malloc+0)+5*A_PtrSize), "ptr", malloc, "ptr", pname) ; Free
; 			if InStr(name, Prefix, CaseSensitive) = 1 {
; 				DllCall(NumGet(NumGet(rot+0)+6*A_PtrSize), "ptr", rot, "ptr", mon, "ptr*", punk) ; GetObject
; 				if (pdsp := ComObjQuery(punk, "{00020400-0000-0000-C000-000000000046}"))   ; Wrap the pointer as IDispatch if available, otherwise as IUnknown.
; 					obj := ComObject(9, pdsp, 1), ObjRelease(punk)
; 				else
; 					obj := ComObject(13, punk, 1)
; 				objects[SubStr(name, StrLen(Prefix) + 1)] := obj	  ; Store it in the return array by suffix.
; 			}
; 			ObjRelease(mon)
; 		}
; 		ObjRelease(enum)
; 		ObjRelease(rot)
; 		ObjRelease(bindCtx)
; 		ObjRelease(malloc)
; 		return objects
; }

;***********Named Cells thanks to Ryan Wells for the suggestion*******************
;***********Set name of range / Cell*******************
;~  Xl.Range("A1").name :="duh" ;Set a name. Not case sensitive
;~  XL_Name_Range(XL,"A1","Ryan")

/**
 * 
 * @param {ComObject} PXL
 * @param {Range} RG 
 * @param {String} Name 
 */
XL_Name_Range(PXL,RG,Name) => PXL.Range(RG).name := Name

;***********Delete name for a range*******************
;~  XL_Name_Delete_Range(XL,"Ryan")

/**
 * 
 * @param {ComObject} PXL
 * @param {String} Name 
 */
XL_Name_Delete_Range(PXL,Name) => PXL.Names(Name).Delete ;Delete a name

;***********Get name of range*******************
;~  MyName:=XL_Name_GetName(XL,"A1")

/**
 * 
 * @param {ComObject} PXL
 * @param {Range} RG 
 */
XL_Name_GetName(PXL,RG) => PXL.Range(RG).name.name ;Get the name of a cell


;***********Return content from range based on a name*******************
;~  duh:=XL_Name_GetData_in_Range(XL,"A1",0)

/**
 * 
 * @param {ComObject} PXL
 * @param {Range} RG 
 * @param {Integer} Type 
 */
XL_Name_GetData_in_Range(PXL,RG,Type:=0){
	If (Type)
		Return PXL.Evaluate(RG).text
	else
		Return PXL.Evaluate(RG).Value ;Get the text in a named cell/range
}


; Built in Document Properties
; Title
; Subject
; Author
; Keywords
; Comments
; Template
; Last Author
; Revision Number
; Application Name
; Last Print Date
; Creation Date
; Last Save Time
; Total Editing Time
; Number of Pages
; Number of Words
; Number of Characters
; Security
; Category
; Format
; Manager
; Company
; Number of Bytes
; Number of Lines
; Number of Paragraphs
; Number of Slides
; Number of Notes
; Number of Hidden Slides
; Number of Multimedia Clips
; Hyperlink Base
; Number of Characters (with spaces)

;***********Playing with Paths*******************
;~ results:=XL_Paths(XL)

/**
 * 
 * @param {ComObject} PXL
 * @param {String} RG 
 * @returns {Object} 
 */
XL_Paths(PXL,RG:="A1"){
	Obj:={} ;Create object for returning information
	SplitPath(PXL.ActiveWorkbook.FullName,&FileName,&Directory,&Extension,&NameNoExt,&Drive)
	Obj.FileName:=FileName
	Obj.Dir:=Directory
	Obj.Ext:=Extension
	Obj.NameNoExt:=NameNoExt
	Obj.Drive:=Drive
	Obj.AppName:=PXL.Name ;application name
	Obj.FullPathFileName:=PXL.ActiveWorkbook.FullName ;Full path to file
	;~ Obj.FileName:=PXL.ActiveWorkbook.Name ;file name already found above but you could use this directly
	Obj.UserName:=PXL.UserName ;Get username
	Obj.WorksheetFromRange:=PXL.Range(RG).Parent.Name
	Obj.WorkbookFromRange:=PXL.Range(RG).Parent.Parent.Name
	Obj.LastAuthor:=PXL.ActiveWorkbook.BuiltinDocumentProperties("Last author").Value
	return obj
}

;********************Pulling Excel properties***********************************
;~ Props:=XL_Properties(XL) ;Call function
;~ for k, v in Props
	;~ data.= "key: " k "`t`tValue: " v "`n"
;~ MsgBox % data

/**
 * 
 * @param {ComObject} PXL
 * @returns {Object} 
 */
XL_Properties(PXL){
	Obj:={} ;Create object for returning information
	Try For Prop in PXL.ActiveWorkbook.BuiltinDocumentProperties {
		Obj[Prop.Name] := Prop.Value
	}
	return Obj
}

; ************************ XL Table **********************

; ******************* Create Table ***********************
; table1 := XL_Table_Create(XL,tableName:= "Table1",Range:="A1:C10",Style:='TableStyleLight1')               ; apply table style 'TableStyleLight1' to the range A1:C10 with the name 'Table1' and no sorting
; table2 := XL_Table_Create(XL,tableName:= "Table1",Range:="A1:C10",Style:='TableStyleMedium26',sort:=true)  ; apply table style 'TableStyleMedium26' to the range A1:C10 with the name 'Table2' and sorting

/**
 * 
 * @param {ComObject} PXL
 * @param {range} tableName 
 * @param {String} RG 
 * @param {String} Style 
 * @param {Integer} sort 
 */
XL_Table_Create(PXL,tableName,Range,Style:='',sort:=false)
{
	/*
		xlSrcRange;
	 		for range table  xlSrcRange := 1 is used ;see https://docs.microsoft.com/en-us/office/vba/api/excel.listobjects.add

		xlNo	2	Default. The entire range should be sorted.
		xlYes	1	The entire range should not be sorted.

		Table Styles

		User has to provide the style number.
		i.e.
			'TableStyleLight1'
			'TableStyleLight14'
			'TableStyleMedium2'
			'TableStyleMedium11'
			'TableStyleMedium26'
			'PivotStyleLight1'

		following code enumrate through all styles and copy them to clipboard
		s := ''
		for style in xl.ActiveWorkbook.TableStyles
			s .= style.name '`n'
			msgbox A_Clipboard := s
	*/

	if (sort)
		yesno := 2
	else
		yesno := 1

	table := PXL.Application.ActiveSheet.ListObjects.Add(xlSrcRange	:= 1,range, yesno)
	table.name := tableName
	table.TableStyle := Style
	return table
}

; ******************* Get Table by name Table ***********************
; table1 := XL_Get_Table(XL,"Table1") ; get table object by name 'Table1'

/**
 * 
 * @param {ComObject} PXL
 * @param {range} tableName 
 */
XL_Get_Table(PXL,tableName)
{
	return PXL.Application.ActiveSheet.ListObjects(tableName)
}


; ******************* Delete Table ***********************
; XL_Table_Delete(XL,table1) ; delete table1
/**
 * 
 * @param {ComObject} PXL
 * @param {range} tableName 
 */
XL_Table_Delete(PXL,tablename)
{
	table := XL_Get_Table(PXL,tableName)
	table.Delete()
}

; ******************* autofilter Table ***********************
; XL_Table_AutoFilter(XL,table1,Filt_Col:="A" ,FilterA:="Joe",FilterB:="King") ; autofilter table1 by column A with filter 'Joe' and 'King'
/**
 * 
 * @param {ComObject} PXL
 * @param {range} tableName 
 * @param {String} Filt_Col 
 * @param {String} FilterA 
 * @param {String} FilterB 
 */
XL_Table_AutoFilter(PXL,tableName,Filt_Col:="" ,FilterA:="",FilterB:="")
{
	table := XL_Get_Table(PXL,tableName)
	table.Range.AutoFilter
	table.Range.AutoFilter(XL_String_To_Number(Filt_Col),FilterA,2,FilterB)
}

; ********************* Move Range ***********************
; XL_Move(PXL,Source:="A1:C20",Destination:="D1")
; XL_Move(PXL,Source:="A:A",Destination:="D")
; XL_Move(PXL,Source:="A:C",Destination:="D")
; XL_Move(PXL,Source:="2:3",Destination:="7")

/**
 * 
 * @param {ComObject} PXL
 * @param {String} Source 
 * @param {String} Destination 
 */
XL_Move(PXL,Source,Destination)
{
	PXL.Range(Source).Cut
	PXL.Range(Destination).select
	PXL.ActiveSheet.Paste
}

; ********************* Move Column ***********************
; XL_Move_Column(XL,Col:="A",Colto:="G") ; move column Col A to Col G
; XL_Move_Column(XL,Col:=1,Colto:=7)    ; move column Col A to Col G but usnig column numbers

/**
 * 
 * @param {ComObject} PXL
 * @param {String} Col 
 * @param {String} Colto 
 */
XL_Move_Column(PXL,Col,Colto)
{
	if Type(col) = "Integer"
		Col := ColNumberToAlpha(Col)
	if Type(colto) = "Integer"
		Colto := ColNumberToAlpha(Colto)
	PXL.Range(Col ":" Col).Cut
	PXL.Range(Colto ":" Colto).Insert
}

ColNumberToAlpha(ColNumber) => (ColNumber<=26?(Chr(64+ColNumber)):(ColNumber>26)?(Chr((ColNumber-1)/26+64) . Chr(Mod((ColNumber- 1),26)+65)):"")

; ********************* Move Row ***********************
; XL_Move_Row(XL,Row:=1,Rowto:=7) ; move row 1 to row 7

/**
 * 
 * @param {ComObject} PXL
 * @param {String} Row 
 * @param {String} Rowto 
 */
XL_Move_Row(PXL,Row,Rowto)
{
	PXL.Range(Row ":" Row).Cut
	PXL.Range(Rowto ":" Rowto).Insert
}


; ********************* indiretc ***********************
; using indirect in functions we can assign formulas to given range
; Learn more https://www.youtube.com/watch?v=GUClkvJ7Gag
/**
 * 
 * @param {ComObject} PXL
 * @param {String} Range 
 * @param {String} Refernce 
 */
XL_Indirect(PXL,Range,Refernce)
{
	PXL.Range(Range).Formula :=  "=INDIRECT("  Refernce ")"
}

;********************Execute VBA onto Excel Applicatoin **************************
; VBAScript := fileread(myexcel.vba,'utf-8')
; pxl.Application.ExecuteExcel4Macro(VBAScript) ;Execute VBA code
/**
 * 
 * @param {ComObject}	PXL 
 * @param {VBAcode} str 
 */
XL_ExecuteVBA(PXL,str:='')
{
	return pxl.Application.ExecuteExcel4Macro(str)
}

;********************Hides/Displays different GUI bars**************************
; XL_ToggleBars(XL, formulaBar:=true, StatusBars:=true, ScrollBars:=false, Headings:=false)
/**
 * 
 * @param {ComObject} PXL 
 * @param {Bolean} formulaBar 
 * @param {Bolean} StatusBars 
 * @param {Bolean} ScrollBars 
 * @param {Bolean} Headings 
 */
XL_ToggleBars(PXL, formulaBar:=false, StatusBars:=false, ScrollBars:=false, Headings:=false){
	PXL.DisplayFormulaBar := formulaBar
	PXL.DisplayStatusBar  := StatusBars
	PXL.DisplayScrollBars := ScrollBars
	; PXL.ActiveWindow.DisplayHeadings := Headings
	pxl.Application.ExecuteExcel4Macro "show.toolbar(`"Ribbon`", " Headings ")"
}

;********************Hides/Displays Window Title Caption************************
; XL_ToggleCaption(XL, status:=false)
/**
 * 
 * @param {ComObject} PXL 
 * @param {Bolean} status 
 */
XL_ToggleCaption(PXL, status:=false) {
	static WS_CAPTION := 0xC00000
	WinSetStyle((status ? "+" : "-") WS_CAPTION, PXL.hwnd)
}

;********************Sets the width and hight of the worksheet******************
; XL_Resize(XL,x:=600, y:=200, w:=800, h:=300)
/**
 * 
 * @param {ComObject} PXL 
 * @param {Integer} x 
 * @param {Integer} y 
 * @param {Integer} w 
 * @param {Integer} h 
 */
XL_Resize(PXL,x:=600, y:=200, w:=800, h:=300){
	return WinMove(x, y, w, h, PXL.hwnd)
}