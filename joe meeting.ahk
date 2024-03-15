#Include lib/Gdip.ahk
#Include lib/PopUpWindow Class.ahk

#SingleInstance, Force
SetBatchLines, -1
#NoEnv

Gdip_StartUp()


pBitmap := Gdip_CreateBitmapFromFile("C:\Users\jeff_\OneDrive\Pictures\Screenshots\Screenshot 2023-10-27 123035.png")
w := Gdip_GetImageWidth( pBitmap )
h := Gdip_GetImageHeight( pBitmap )


Gui1 := New PopUpWindow( { WindowName: "1" , WindowOptions: " -DPIScale +AlwaysOnTop " , WindowSmoothing: 2 , X: "Center" , Y: "Center" , W: w , H: h } )
Gui1.DrawBitmap( pBitmap  , { X: 0 , Y: 0 , W: w , H: h } , dispose := 0 )
Gui1.UpdateWindow()
Gui1.ShowWindow()



OnMessage( 0x201 , func("OnCLick").Bind( Gui1 ) )

return
GuiClose:
GuiContextMenu:
*ESC::ExitApp

Numpad3::PopUpWindow.Helper()

Test:
	Run, calc.exe
	return





OnClick( Gui1 , w, l, msg, hwnd){
	MouseGetPos,x,y, Win
	if( win = Gui1.Hwnd ){
		
		if( y < 20 ){
			Postmessage, 0xA1, 2
		}else if( x > Gui1.Button.X && x < Gui1.Button.X + Gui1.Button.W && y > Gui1.Button.Y && y < Gui1.Button.Y + Gui1.Button.H ){
			gosub, Test
		}
	}
	
}