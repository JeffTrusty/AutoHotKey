class gdip
{
	;#####################################################################################
	; Extra functions
	;#####################################################################################

	Startup()
	{
		Ptr := A_PtrSize ? "UPtr" : "UInt"
		
		if !DllCall("GetModuleHandle", "str", "gdiplus", Ptr)
			DllCall("LoadLibrary", "str", "gdiplus")
		VarSetCapacity(si, A_PtrSize = 8 ? 24 : 16, 0), si := Chr(1)
		DllCall("gdiplus\GdiplusStartup", A_PtrSize ? "UPtr*" : "uint*", pToken, Ptr, &si, Ptr, 0)
		return pToken
	}

	Shutdown(pToken)
	{
		Ptr := A_PtrSize ? "UPtr" : "UInt"
		
		DllCall("gdiplus\GdiplusShutdown", Ptr, pToken)
		if hModule := DllCall("GetModuleHandle", "str", "gdiplus", Ptr)
			DllCall("FreeLibrary", Ptr, hModule)
		return 0
	}

	;#####################################################################################

	; Function				CreateDIBSection
	; Description			The CreateDIBSection function creates a DIB (Device Independent Bitmap) that applications can write to directly
	;
	; w						width of the bitmap to create
	; h						height of the bitmap to create
	; hdc					a handle to the device context to use the palette from
	; bpp					bits per pixel (32 = ARGB)
	; ppvBits				A pointer to a variable that receives a pointer to the location of the DIB bit values
	;
	; return				returns a DIB. A gdi bitmap
	;
	; notes					ppvBits will receive the location of the pixels in the DIB

	CreateDIBSection(w, h, hdc="", bpp=32, ByRef ppvBits=0)
	{
		Ptr := A_PtrSize ? "UPtr" : "UInt"
		
		hdc2 := hdc ? hdc : this.GetDC()
		VarSetCapacity(bi, 40, 0)
		
		NumPut(w, bi, 4, "uint")
		, NumPut(h, bi, 8, "uint")
		, NumPut(40, bi, 0, "uint")
		, NumPut(1, bi, 12, "ushort")
		, NumPut(0, bi, 16, "uInt")
		, NumPut(bpp, bi, 14, "ushort")
		
		hbm := DllCall("CreateDIBSection"
						, Ptr, hdc2
						, Ptr, &bi
						, "uint", 0
						, A_PtrSize ? "UPtr*" : "uint*", ppvBits
						, Ptr, 0
						, "uint", 0, Ptr)

		if !hdc
			this.ReleaseDC(hdc2)
		return hbm
	}

	;#####################################################################################

	; Function				CreateCompatibleDC
	; Description			This function creates a memory device context (DC) compatible with the specified device
	;
	; hdc					Handle to an existing device context					
	;
	; return				returns the handle to a device context or 0 on failure
	;
	; notes					If this handle is 0 (by default), the function creates a memory device context compatible with the application's current screen

	CreateCompatibleDC(hdc=0)
	{
	return DllCall("CreateCompatibleDC", A_PtrSize ? "UPtr" : "UInt", hdc)
	}

	;#####################################################################################

	; Function				SelectObject
	; Description			The SelectObject function selects an object into the specified device context (DC). The new object replaces the previous object of the same type
	;
	; hdc					Handle to a DC
	; hgdiobj				A handle to the object to be selected into the DC
	;
	; return				If the selected object is not a region and the function succeeds, the return value is a handle to the object being replaced
	;
	; notes					The specified object must have been created by using one of the following functions
	;						Bitmap - CreateBitmap, CreateBitmapIndirect, CreateCompatibleBitmap, CreateDIBitmap, CreateDIBSection (A single bitmap cannot be selected into more than one DC at the same time)
	;						Brush - CreateBrushIndirect, CreateDIBPatternBrush, CreateDIBPatternBrushPt, CreateHatchBrush, CreatePatternBrush, CreateSolidBrush
	;						Font - CreateFont, CreateFontIndirect
	;						Pen - CreatePen, CreatePenIndirect
	;						Region - CombineRgn, CreateEllipticRgn, CreateEllipticRgnIndirect, CreatePolygonRgn, CreateRectRgn, CreateRectRgnIndirect
	;
	; notes					If the selected object is a region and the function succeeds, the return value is one of the following value
	;
	; SIMPLEREGION			= 2 Region consists of a single rectangle
	; COMPLEXREGION			= 3 Region consists of more than one rectangle
	; NULLREGION			= 1 Region is empty

	SelectObject(hdc, hgdiobj)
	{
		Ptr := A_PtrSize ? "UPtr" : "UInt"
		
		return DllCall("SelectObject", Ptr, hdc, Ptr, hgdiobj)
	}

	;#####################################################################################

	; Function				GraphicsFromHDC
	; Description			This function gets the graphics from the handle to a device context
	;
	; hdc					This is the handle to the device context
	;
	; return				returns a pointer to the graphics of a bitmap
	;
	; notes					You can draw a bitmap into the graphics of another bitmap

	GraphicsFromHDC(hdc)
	{
	DllCall("gdiplus\GdipCreateFromHDC", A_PtrSize ? "UPtr" : "UInt", hdc, A_PtrSize ? "UPtr*" : "UInt*", pGraphics)
	return pGraphics
	}

	; Default = 0
	; HighSpeed = 1
	; HighQuality = 2
	; None = 3
	; AntiAlias = 4
	SetSmoothingMode(pGraphics, SmoothingMode)
	{
	return DllCall("gdiplus\GdipSetSmoothingMode", A_PtrSize ? "UPtr" : "UInt", pGraphics, "int", SmoothingMode)
	}

	;#####################################################################################

	BrushCreateSolid(ARGB=0xff000000)
	{
		DllCall("gdiplus\GdipCreateSolidFill", "UInt", ARGB, A_PtrSize ? "UPtr*" : "UInt*", pBrush)
		return pBrush
	}

	;#####################################################################################

	; Function				FillEllipse
	; Description			This function uses a brush to fill an ellipse in the Graphics of a bitmap
	;
	; pGraphics				Pointer to the Graphics of a bitmap
	; pBrush				Pointer to a brush
	; x						x-coordinate of the top left of the ellipse
	; y						y-coordinate of the top left of the ellipse
	; w						width of the ellipse
	; h						height of the ellipse
	;
	; return				status enumeration. 0 = success

	FillEllipse(pGraphics, pBrush, x, y, w, h)
	{
		Ptr := A_PtrSize ? "UPtr" : "UInt"
		
		return DllCall("gdiplus\GdipFillEllipse", Ptr, pGraphics, Ptr, pBrush, "float", x, "float", y, "float", w, "float", h)
	}


	;#####################################################################################

	DeleteBrush(pBrush)
	{
	return DllCall("gdiplus\GdipDeleteBrush", A_PtrSize ? "UPtr" : "UInt", pBrush)
	}

	;#####################################################################################

	; Function				FillRectangle
	; Description			This function uses a brush to fill a rectangle in the Graphics of a bitmap
	;
	; pGraphics				Pointer to the Graphics of a bitmap
	; pBrush				Pointer to a brush
	; x						x-coordinate of the top left of the rectangle
	; y						y-coordinate of the top left of the rectangle
	; w						width of the rectanlge
	; h						height of the rectangle
	;
	; return				status enumeration. 0 = success

	FillRectangle(pGraphics, pBrush, x, y, w, h)
	{
		Ptr := A_PtrSize ? "UPtr" : "UInt"
		
		return DllCall("gdiplus\GdipFillRectangle"
						, Ptr, pGraphics
						, Ptr, pBrush
						, "float", x
						, "float", y
						, "float", w
						, "float", h)
	}

	;#####################################################################################

	; Function:   UpdateLayeredWindow
	; Description:Updates a layered window with the handle to the DC of a gdi bitmap
	; 
	; hwnd        Handle of the layered window to update
	; hdc         Handle to the DC of the GDI bitmap to update the window with
	; Layeredx    x position to place the window
	; Layeredy    y position to place the window
	; Layeredw    Width of the window
	; Layeredh    Height of the window
	; Alpha       Default = 255 : The transparency (0-255) to set the window transparency
	;
	; return      If the function succeeds, the return value is nonzero
	;
	; notes       If x or y omitted, then layered window will use its current coordinates
	;             If w or h omitted then current width and height will be used

	UpdateLayeredWindow(hwnd, hdc, x="", y="", w="", h="", Alpha=255)
	{
		Ptr := A_PtrSize ? "UPtr" : "UInt"
		
		if ((x != "") && (y != ""))
			VarSetCapacity(pt, 8), NumPut(x, pt, 0, "UInt"), NumPut(y, pt, 4, "UInt")

		if (w = "") ||(h = "")
			WinGetPos,,, w, h, ahk_id %hwnd%
	
		return DllCall("UpdateLayeredWindow"
						, Ptr, hwnd
						, Ptr, 0
						, Ptr, ((x = "") && (y = "")) ? 0 : &pt
						, "int64*", w|h<<32
						, Ptr, hdc
						, "int64*", 0
						, "uint", 0
						, "UInt*", Alpha<<16|1<<24
						, "uint", 2)
	}

	;#####################################################################################

	; Function				DeleteObject
	; Description			This function deletes a logical pen, brush, font, bitmap, region, or palette, freeing all system resources associated with the object
	;						After the object is deleted, the specified handle is no longer valid
	;
	; hObject				Handle to a logical pen, brush, font, bitmap, region, or palette to delete
	;
	; return				Nonzero indicates success. Zero indicates that the specified handle is not valid or that the handle is currently selected into a device context

	DeleteObject(hObject)
	{
	return DllCall("DeleteObject", A_PtrSize ? "UPtr" : "UInt", hObject)
	}

	;#####################################################################################

	; Function				DeleteDC
	; Description			The DeleteDC function deletes the specified device context (DC)
	;
	; hdc					A handle to the device context
	;
	; return				If the function succeeds, the return value is nonzero
	;
	; notes					An application must not delete a DC whose handle was obtained by calling the GetDC function. Instead, it must call the ReleaseDC function to free the DC

	DeleteDC(hdc)
	{
	return DllCall("DeleteDC", A_PtrSize ? "UPtr" : "UInt", hdc)
	}

	;#####################################################################################

	DeleteGraphics(pGraphics)
	{
	return DllCall("gdiplus\GdipDeleteGraphics", A_PtrSize ? "UPtr" : "UInt", pGraphics)
	}

	;#####################################################################################

	; Function				ReleaseDC
	; Description			This function releases a device context (DC), freeing it for use by other applications. The effect of ReleaseDC depends on the type of device context
	;
	; hdc					Handle to the device context to be released
	; hwnd					Handle to the window whose device context is to be released
	;
	; return				1 = released
	;						0 = not released
	;
	; notes					The application must call the ReleaseDC function for each call to the GetWindowDC function and for each call to the GetDC function that retrieves a common device context
	;						An application cannot use the ReleaseDC function to release a device context that was created by calling the CreateDC function; instead, it must use the DeleteDC function. 

	ReleaseDC(hdc, hwnd=0)
	{
		Ptr := A_PtrSize ? "UPtr" : "UInt"
		
		return DllCall("ReleaseDC", Ptr, hwnd, Ptr, hdc)
	}

	;#####################################################################################

	; Function				GetDC
	; Description			This function retrieves a handle to a display device context (DC) for the client area of the specified window.
	;						The display device context can be used in subsequent graphics display interface (GDI) functions to draw in the client area of the window. 
	;
	; hwnd					Handle to the window whose device context is to be retrieved. If this value is NULL, GetDC retrieves the device context for the entire screen					
	;
	; return				The handle the device context for the specified window's client area indicates success. NULL indicates failure

	GetDC(hwnd=0)
	{
		return DllCall("GetDC", A_PtrSize ? "UPtr" : "UInt", hwnd)
	}
}