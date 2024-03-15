#Include <My Altered Gdip lib> ;point to your file 
#Include <PopUpWindow Class> ;point to your file 

#SingleInstance, Force
SetBatchLines, -1
#NoEnv

Bob := {X:100 , Color: 0}

Gdip_StartUp()
Gui1 := New PopUpWindow( { WindowName: "1" , WindowOptions: " -DPIScale +AlwaysOnTop " , WindowSmoothing: 2 , X: "Center" , Y: "Center" , W: 1200 , H: 400 } )
Gui1.DrawBitmap( HB_BITMAP_MAKER( bob ) , { X: 0 , Y: 0 , W: 1200 , H: 200 } , dispose := 1 )
Gui1.DrawBitmap( HB_BITMAP_MAKER( bob ) , { X: 0 , Y: 200 , W: 1200 , H: 200 } , dispose := 1 )
Gui1.UpdateWindow()
Gui1.ShowWindow()


SetTimer, WatchCursor, 30
return
GuiClose:
GuiContextMenu:
*ESC::ExitApp

Numpad3::PopUpWindow.Helper()


numpad5::
Gui1.DeleteWindow()
Gui1 := ""
return


WatchCursor:
bob.X+=10
if(bob.x>500)
	bob.Color := 1
Gui1.ClearWindow()
Gui1.DrawBitmap( HB_BITMAP_MAKER( bob ) , { X: 0 , Y: 0 , W: 1200 , H: 200 } , dispose := 1 )
Gui1.DrawBitmap( HB_BITMAP_MAKER( bob ) , { X: 0 , Y: 200 , W: 1200 , H: 200 } , dispose := 1 )
Gui1.UpdateWindow()
return





HB_BITMAP_MAKER( obj ){
	;Bitmap Created Using: HB Bitmap Maker
	pBitmap := Gdip_CreateBitmap( 1200 , 200 ) , G := Gdip_GraphicsFromImage( pBitmap ) , Gdip_SetSmoothingMode( G , 2 )
	Brush := Gdip_BrushCreateSolid( (obj.Color) ? ( "0xFF336699" ) : ( "0xFFFF0000" ) ) , Gdip_FillEllipse( G , Brush , obj.X , 10 , 50 , 50 ) , Gdip_DeleteBrush( Brush )
	Gdip_DeleteGraphics( G )
	return pBitmap
}