; gdi+ ahk tutorial 1 written by tic (Tariq Porter)
; Requires Gdip.ahk either in your Lib folder as standard library or using #Include
;
; Tutorial to draw a single ellipse and rectangle to the screen

#SingleInstance, Force
#NoEnv
SetBatchLines, -1

; Uncomment if Gdip.ahk is not in your standard library
#Include, GdipClassEx.ahk

class gidEx extends gdip
{
	newMethod()
	{
		msgbox % "this is my new method"
	}
}

gdi := new gidEx

; Start gdi+
If !pToken := gdi.Startup()
{
	MsgBox, 48, gdiplus error!, Gdiplus failed to start. Please ensure you have gdiplus on your system
	ExitApp
}
OnExit, Exit

gdi.newMethod()
; Set the width and height we want as our drawing area, to draw everything in. This will be the dimensions of our bitmap
Width :=1400, Height := 1050

; Create a layered window (+E0x80000 : must be used for UpdateLayeredWindow to work!) that is always on top (+AlwaysOnTop), has no taskbar entry or caption
Gui, 1: -Caption +E0x80000 +LastFound +AlwaysOnTop +ToolWindow +OwnDialogs

; Show the window
Gui, 1: Show, NA

; Get a handle to this window we have created in order to update it later
hwnd1 := WinExist()

; Create a gdi bitmap with width and height of what we are going to draw into it. This is the entire drawing area for everything
hbm := gdi.CreateDIBSection(Width, Height)

; Get a device context compatible with the screen
hdc := gdi.CreateCompatibleDC()

; Select the bitmap into the device context
obm := gdi.SelectObject(hdc, hbm)

; Get a pointer to the graphics of the bitmap, for use with drawing functions
G := gdi.GraphicsFromHDC(hdc)

; Set the smoothing mode to antialias = 4 to make shapes appear smother (only used for vector drawing and filling)
gdi.SetSmoothingMode(G, 4)

; Create a fully opaque red brush (ARGB = Transparency, red, green, blue) to draw a circle
pBrush := gdi.BrushCreateSolid(0xffff0000)

; Fill the graphics of the bitmap with an ellipse using the brush created
; Filling from coordinates (100,50) an ellipse of 200x300
gdi.FillEllipse(G, pBrush, 100, 500, 200, 300)

; Delete the brush as it is no longer needed and wastes memory
gdi.DeleteBrush(pBrush)

; Create a slightly transparent (66) blue brush (ARGB = Transparency, red, green, blue) to draw a rectangle
pBrush := gdi.BrushCreateSolid(0x660000ff)

; Fill the graphics of the bitmap with a rectangle using the brush created
; Filling from coordinates (250,80) a rectangle of 300x200
gdi.FillRectangle(G, pBrush, 250, 80, 300, 200)

; Delete the brush as it is no longer needed and wastes memory
gdi.DeleteBrush(pBrush)


; Update the specified window we have created (hwnd1) with a handle to our bitmap (hdc), specifying the x,y,w,h we want it positioned on our screen
; So this will position our gui at (0,0) with the Width and Height specified earlier
gdi.UpdateLayeredWindow(hwnd1, hdc, 0, 0, Width, Height)


; Select the object back into the hdc
gdi.SelectObject(hdc, obm)

; Now the bitmap may be deleted
gdi.DeleteObject(hbm)

; Also the device context related to the bitmap may be deleted
gdi.DeleteDC(hdc)

; The graphics may now be deleted
gdi.DeleteGraphics(G)
Return

;#######################################################################

Exit:
; gdi+ may now be shutdown on exiting the program
gdi.Shutdown(pToken)
ExitApp
Return