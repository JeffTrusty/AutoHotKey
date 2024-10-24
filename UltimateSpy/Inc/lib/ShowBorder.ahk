#Requires Autohotkey v2.0+
; The color attribute in the following line sets the color     0x3FBBE3
ShowBorder(Control,Duration:=500,r:=3) { 
	; Local x,y,w,h
	; static Window
	; try WinGetPos &x, &y, &w, &h, 'ahk_id ' Control
	if !control 
		return
	static window := Highlight.Border('ahk_id ' Control,,A_IsAdmin ? 'Red':'Green',1)
	window.Border.Parent := Control

	; if !isset(w) 
	; ||!w
	; 	Return
	; for a,b in Window:=[[91,x-r,y-r,w+r,r],[92,x-r,y+h,w+r,r],[93,x-r,y,r,h],[94,x+w,y,r,h]]
	; 	Borders[a_index].Show("NA x" b[2] " y" b[3] " w" b[4] " h" b[5])
	; SetTimer Flash,-1
	;  if(Duration!=-1&&Duration!="Flash"){
	; 		SetTimer Flash, 0
	; 		sleep Duration
	; 		intiBorder(1)
	;  }else if(Duration="Flash"){
	;  	SetTimer Flash,-1
	; }
}

; Flash()
; {
; 	loop 4
; 	{
; 		if Mod(a_index,2)
; 			intiBorder(1)
; 		else
; 			intiBorder(0)
; 		Sleep 200
; 	}
; }

; intiBorder(status:=1)
; {
; 	if status
; 	{
; 		loop 4
; 			Borders[a_index].Show()
; 	}
; 	else
; 	{
; 		loop 4
; 			Borders[a_index].Hide()
; 	}
; }


class Highlight {
	static marked := Map()
	static Border(winTitle, size:=2, color:='Red', flash:=false) => Border(winTitle, size, color, flash)

	static CalculateBorderRegion(point, px)
	{
		static outer_region := '0-0 {1}-0 {1}-{2} 0-{2} 0-0'
		static inner_region := '{1}-{1} {2}-{1} {2}-{3} {1}-{3} {1}-{1}'

		return Format(outer_region, point.w, point.h) ' ' Format(inner_region, px, point.w-px, point.h-px)
	}
}

class Border extends Highlight {
	__New(winTitle, size:=2, color:='Red', flash:=false)
	{
		WinGetPos(&x, &y, &width, &height, winTitle)
		rect := {x:x, y:y, w:width, h:height}

		border := Gui('-Caption +ToolWindow +AlwaysOnTop -DPIScale')
		border.parent    := WinGetID(winTitle)
		border.BackColor := color

		opts := Format('Hide x{} y{} w{} h{}', rect.x+1, rect.y, rect.w-1, rect.h)
		border.Show(opts) ; show hidden to later get a size
		border.size := size
		region := Highlight.CalculateBorderRegion(rect, size)
		WinSetRegion region, border
		border.Show('NoActivate')
		this.border := border
		Highlight.marked.Set(border.parent, true)
		; we should use Shell Hook instead Timmer
		; onmessage when window moved and destroyed
		SetTimer UpdateBorderPos, 5 
		return this

		UpdateBorderPos()
		{
			static WS_VISIBLE := 0x10000000

			if !WinExist(border.parent)
			{
				border.hide()
				return
			}

			if WinGetMinMax(border.parent) = -1
			; || !WinActive(border.parent)
				return border.Hide()

			try WinGetPos(&x, &y, &w, &h, border.parent)
			catch
			{
				SetTimer UpdateBorderPos, false
				Highlight.marked.Delete(border.parent)
				border.Destroy()
				return border := ''
			}

			if !(WinGetStyle(border.parent) & WS_VISIBLE)
				return border.Hide()
			
			rect := {x:x, y:y, w:w, h:h}
			region := Highlight.CalculateBorderRegion(rect, border.size)
			WinSetRegion region, border

			; outputDebug 'moving window to: ' x ',' y ',' w ',' h '`n'
			border.Show('NoActivate')
			border.Move(x, y-2, w, h)
			; WinMove x, y-2,w, h, border
		}
	}
}