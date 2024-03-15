;~ XL:=XL_Handle(1) ; 1=pointer to Application   2= Pointer to Workbook
XL_Handle(Sel){
	ControlGet, hwnd, hwnd, , Excel71, ahk_class XLMAIN ;identify the hwnd for Excel
	Obj:=ObjectFromWindow(hwnd,-16)
	return (Sel=1?Obj.Application:Sel=2?Obj.Parent:Sel=3?Obj.ActiveSheet:"")
}
ObjectFromWindow(hWnd, idObject = -4){
	if(h:=DllCall("LoadLibrary","Str","oleacc","Ptr"))
		If DllCall("oleacc\AccessibleObjectFromWindow","Ptr", hWnd
								,"UInt", idObject&=0xFFFFFFFF
								,"Ptr", -VarSetCapacity(IID,16)+NumPut(idObject==0xFFFFFFF0?0x46000000000000C0:0x719B3800AA000C81,NumPut(idObject==0xFFFFFFF0?0x0000000000020400:0x11CF3C3D618736E0,IID,"Int64"),"Int64")
								,"Ptr*", pacc)=0
			Return ComObjEnwrap(9,pacc,1)
}
XL_Open(byref PXL, vis=1,Try=1,Path=""){
	If (Try=1){
		Try PXL := ComObjActive("Excel.Application") ;handle
		Catch
			PXL := ComObjCreate("Excel.Application") ;handle
		PXL.Visible := vis ;1=Visible/Default 0=hidden
	}Else{
		PXL := ComObjCreate("Excel.Application") ;handle
		PXL.Visible := vis ;1=Visible/Default 0=hidden
	}
	PXL:=PXL.Workbooks.Open(path) ;wrb =handle to specific workbook
	PXL:=XL_Handle(1) ;Raise it up to Application
	Return,PXL
}
XL_Save(PXL,File="",Format="2007",WarnOverWrite=0){
	PXL.Application.DisplayAlerts := WarnOverWrite ;doesn't ask if I care about overwriting the file
	IfEqual,Format,TAB,SetEnv,Format,-4158 ;Tab
	IfEqual,Format,CSV,SetEnv,Format,6 ;CSV
	IfEqual,Format,2003,SetEnv,Format,56 ;2003 format
	IfEqual,Format,2007,SetEnv,Format,51 ;2007 format
	PXL.Application.ActiveWorkbook.Saveas(File, Format) ;save it
	PXL.Application.DisplayAlerts := true ;Turn back on warnings
}
XL_Create_New_Workbook(PXL){
	PXL.Workbooks.Add() ;create new workbook
}
XL_Screen_Update(PXL){
	PXL.Application.ScreenUpdating := ! PXL.Application.ScreenUpdating ;toggle update
}
XL_Speedup(PXL,Status){ ;Helps COM functions work faster/prevent screen flickering, etc.
	if(!Status){
		PXL.application.displayalerts := 0
		PXL.application.EnableEvents := 0
		PXL.application.ScreenUpdating := 0
		PXL.application.Calculation := -4135
	}else{
		PXL.application.displayalerts := 1
		PXL.application.EnableEvents := 1
		PXL.application.ScreenUpdating := 1
		PXL.application.Calculation := -4105
	}
}
XL_Screen_Visibility(PXL){
	PXL.Visible:= ! PXL.Visible ;Toggle screen visibility
}
XL_Copy_to_Clipboard(PXL,RG:=""){
	PXL.Application.ActiveSheet.Range(RG).Copy ;copy to clipboard
}