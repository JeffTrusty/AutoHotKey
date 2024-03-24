;Hellbent  9/22

class PopUpWindow	{
	;Class By: Hellbent
	;Apr 2021
	static Index := 0 , Windows := [] , Handles := [] , HelpHandles := [] , HelperEditHwnd
	__New( obj := "" ){
		This._SetDefaults()
		if( isObject( obj ) )
			This.SetWindowProperties( obj )
		This._SetupWindowGraphics()
	}
	_SetDefaults(){
		PopUpWindow.Index++
		This.WindowName := "HBLayeredWindow" PopUpWindow.Index
		This.WindowSmoothing := 2
		This.WindowOptions := " -DPIScale +AlwaysOnTop "
		This.X := 10
		This.Y := 10
		This.W := 10
		This.H := 10
	}
	PaintBackground( color := "0xFF000000" ){
		Brush := Gdip_BrushCreateSolid( color ) 
		Gdip_FillRectangle( This.G , Brush , -1 , -1 , This.W + 2 , This.H + 2 ) 
		Gdip_DeleteBrush( Brush )
	}
	_SetupWindowGraphics(){
		This.Hwnd := This._CreateGUI()
		This.hbm := CreateDIBSection( This.W , This.H )
		This.hdc := CreateCompatibleDC()
		This.obm := SelectObject( This.hdc , This.hbm )
		This.G := Gdip_GraphicsFromHDC( This.hdc )
		Gdip_SetSmoothingMode( This.G , This.WindowSmoothing )
		PopUpWindow.Handles[ This.Hwnd ] := PopUpWindow.Index
		PopUpWindow.Windows[ PopUpWindow.Index ] := This
	}
	SetWindowProperties( obj , updateG := 0 ){
		local k , v 
		for k , v in obj
			if( k != "hwnd" )
				This[k] := v
			
			
		if(updateG){	
			SelectObject( This.hdc , This.obm )
			DeleteObject( This.hbm )
			DeleteDC( This.hdc )
			
			This.hbm := CreateDIBSection( This.W , This.H )
			This.hdc := CreateCompatibleDC()
			This.obm := SelectObject( This.hdc , This.hbm )
			This.G := Gdip_GraphicsFromHDC( This.hdc )
			Gdip_SetSmoothingMode( This.G , This.WindowSmoothing )	
		}
		( This.X = "center" ) ? ( This.X := ( A_ScreenWidth - This.W ) / 2 )
		( This.Y = "center" ) ? ( This.Y := ( A_ScreenHeight - This.H ) / 2 )
	}
	ShowWindow( Title := "" ){
		Gui , % This.WindowName ":Show", % "x" This.X " y" This.Y " w" This.W " h" This.H " NA", % Title
	}
	HideWindow(){
		Gui , % This.WindowName ":Hide",
	}
	UpdateWindow(){
		UpdateLayeredWindow( This.hwnd , This.hdc , This.X , This.Y , This.W , This.H )
	}
	ClearWindow(){
		Gdip_GraphicsClear( This.G )
	}
	DrawBitmap( pBitmap , obj , dispose := 1 ){
		Gdip_DrawImage( This.G , pBitmap , obj.X , obj.Y , obj.W , obj.H )
		if( dispose )
			Gdip_DisposeImage( pBitmap )
	}
	DeleteWindow(){
		Gui, % This.WindowName ":Destroy"
		SelectObject( This.hdc , This.obm )
		DeleteObject( This.hbm )
		DeleteDC( This.hdc )
		Gdip_DeleteGraphics( This.G )
		hwnd := This.Hwnd
		for k, v in PopUpWindow.Windows[ Hwnd ]
			This[k] := ""
		PopUpWindow.Windows[ Hwnd ] := ""
	}
	_CreateGUI(){
		local hwnd
		Gui , % This.WindowName ":New" , % " +E0x80000 hwndhwnd -Caption  " This.WindowOptions
		return hwnd
	}
	Helper(){
		local List := ["New Window","SetWindowProperties","ShowWindow","HideWindow","UpdateWindow","ClearWindow","DrawBitmap","PaintBackground","DeleteWindow"]
		local hwnd, bd
		
		
		Gui, HBLWHelperGui:New, +AlwaysOnTop 
		Gui, HBLWHelperGui:Color, 62666a, 24282c
		Gui, HBLWHelperGui:Font, cWhite s10 , Segoe UI
		Gui, HBLWHelperGui:Margin, 5 , 5
		
		Gui, HBLWHelperGui:Add, Edit, xm ym w200 r1 Center hwndHwnd, Gui1
		PopUpWindow.HelperEditHwnd := Hwnd
		Gui, HBLWHelperGui:Margin, 5 , 1
		Loop, % List.Length()	{
		
			Gui, HBLWHelperGui:Add, Button, xm wp h23 -Theme hwndhwnd, % List[ A_Index ]
			PopUpWindow.HelpHandles[hwnd] := List[ A_Index ]
			bd := PopUpWindow._ClipIt.Bind( PopUpWindow )
			GuiControl , HBLWHelperGui: +G , % Hwnd , % bd
		}
		
		Gui, HBLWHelperGui:Show, 
		
	}
	_ClipIt(){
		local List := ["New Window","SetWindowProperties","ShowWindow","HideWindow","UpdateWindow","ClearWindow","DrawBitmap","PaintBackground","DeleteWindow"]
		local Output , FQ := 400
		GuiControlGet, Output , HBLWHelperGui: , % PopUpWindow.HelperEditHwnd
		Switch A_GuiControl
		{
			case List[1]:
				Clipboard := Output " := New PopUpWindow( { WindowName: ""1"" , WindowOptions: "" -DPIScale +AlwaysOnTop "" , WindowSmoothing: 2 , X: ""Center"" , Y: ""Center"" , W: 100 , H: 100 } )"
				loop 2
					SoundBeep, FQ
				return
			case List[2]:
				Clipboard := Output ".SetWindowProperties( { X: """" , Y: """" , W: """" , H: """" } )"
				loop 2
					SoundBeep, FQ
				return
			case List[3]:
				Clipboard := Output ".ShowWindow( MyWindowTitle := """" )"
				loop 2
					SoundBeep, FQ
				return
			case List[4]:
				Clipboard := Output ".HideWindow()"
				loop 2
					SoundBeep, FQ
				return
			case List[5]:
				Clipboard := Output ".UpdateWindow()"
				loop 2
					SoundBeep, FQ
				return
			case List[6]:
				Clipboard := Output ".ClearWindow()"
				loop 2
					SoundBeep, FQ
				return
			case List[7]:
				Clipboard := Output ".DrawBitmap( pBitmap := """" , { X: """" , Y: """" , W: """" , H: """" } , dispose := 1 )"
				loop 2
					SoundBeep, FQ
				return
			case List[8]:
				Clipboard := Output ".PaintBackground( color := ""0xFF000000"" )"
				loop 2
					SoundBeep, FQ
				return
			case List[9]:
				Clipboard := Output ".DeleteWindow()"
				loop 2
					SoundBeep, FQ
				return
			Default:
				ToolTip, Looks like a new case needs to be added
				return
			
		}
	}
}
