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

		border := Gui('-Caption +ToolWindow +AlwaysOnTop')
		border.parent    := WinGetID(winTitle)
		border.BackColor := color

		opts := Format('Hide x{} y{} w{} h{}', rect.x+1, rect.y, rect.w-1, rect.h)
		border.Show(opts) ; show hidden to later get a size

		region := Highlight.CalculateBorderRegion(rect, size)
		WinSetRegion region, border
		border.Show('NoActivate')

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
				border.Destroy()
				return 
			}
			OutputDebug WinGetStyle(uGui.hwnd) & WS_VISIBLE
			if WinGetMinMax(border.parent) = -1
			|| !(WinGetStyle(uGui.hwnd) & WS_VISIBLE)
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

			if !WinActive(border.parent) 
			; if !(WinGetStyle(border.parent) & WS_VISIBLE)
				return border.Hide()

			outputDebug 'moving window to: ' x ',' y ',' w ',' h '`n'
			border.Show('NoActivate')
			border.Move(x, y-2, w, h)
		}
	}
}