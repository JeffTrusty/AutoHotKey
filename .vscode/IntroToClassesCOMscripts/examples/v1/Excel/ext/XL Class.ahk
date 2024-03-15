class XL
{
	PXL := ""

	__New(vis:=true)
	{
		Try this.PXL := ComObjActive("Excel.Application") ;handle
		Catch
			this.PXL := ComObjCreate("Excel.Application") ;handle
		this.PXL.Visible := vis ;1=Visible/Default 0=hidden
	}

	visible[]
	{
		get {
			return this.PXL.visible
		}
		set {
			return this.PXL.visible := value
		}
	}

	;~ XL:=Handle(1) ; 1=pointer to Application   2= Pointer to Workbook
	Handle(Sel){
		ControlGet, hwnd, hwnd, , Excel71, ahk_class XLMAIN ;identify the hwnd for Excel
		Obj:=this.ObjectFromWindow(hwnd,-16)
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
	Open(Path=""){
		this.PXL:=this.PXL.Workbooks.Open(path) ;wrb =handle to specific workbook
		this.PXL:=this.Handle(1) ;Raise it up to Application
		Return,this.PXL
	}
	Save(File="",Format="2007",WarnOverWrite=0){
		this.PXL.Application.DisplayAlerts := WarnOverWrite ;doesn't ask if I care about overwriting the file
		IfEqual,Format,TAB,SetEnv,Format,-4158 ;Tab
		IfEqual,Format,CSV,SetEnv,Format,6 ;CSV
		IfEqual,Format,2003,SetEnv,Format,56 ;2003 format
		IfEqual,Format,2007,SetEnv,Format,51 ;2007 format
		this.PXL.Application.ActiveWorkbook.Saveas(File, Format) ;save it
		this.PXL.Application.DisplayAlerts := true ;Turn back on warnings
	}
	Create_New_Workbook(){
		this.PXL.Workbooks.Add() ;create new workbook
	}
	Screen_Update(){
		this.PXL.Application.ScreenUpdating := ! this.PXL.Application.ScreenUpdating ;toggle update
	}
	Speedup(Status){ ;Helps COM functions work faster/prevent screen flickering, etc.
		if(!Status){
			this.PXL.application.displayalerts := 0
			this.PXL.application.EnableEvents := 0
			this.PXL.application.ScreenUpdating := 0
			this.PXL.application.Calculation := -4135
		}else{
			this.PXL.application.displayalerts := 1
			this.PXL.application.EnableEvents := 1
			this.PXL.application.ScreenUpdating := 1
			this.PXL.application.Calculation := -4105
		}
	}
	Screen_Visibility(){
		this.PXL.Visible:= ! this.PXL.Visible ;Toggle screen visibility
	}
	Copy_to_Clipboard(RG:=""){
		this.PXL.Application.ActiveSheet.Range(RG).Copy ;copy to clipboard
	}
}