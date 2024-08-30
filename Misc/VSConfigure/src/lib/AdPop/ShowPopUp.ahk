; ShowPopUp('https://www.the-automator.com/adsinfo')

; check for internet connection
; base64 img for default
; default parameters if no internet
ShowPopUp(InfoFileURL)
{
	static BS_ICON     := 0x40
	static BM_SETIMAGE := 0xF7

	static savePath    := A_Temp '\' A_Now '.png'
	static http := ComObject("WinHttp.WinHttpRequest.5.1")

	http.Open('GET', InfoFileURL)
	http.Send()

	if http.status != 200
		throw Error('Could not retrieve the Info File', A_ThisFunc, http.status)

	ads := StrSplit(http.responseText, '`n', '`r')

	values := StrSplit(ads[Random(1, ads.Length)], A_Tab)
	for param in [&prettyLink,&imgUrl,&header,&discount]
		%param% := values[A_Index]

	OnMessage(0x20, WM_SETCURSOR)

	PopUp := Gui('-Caption +Border +AlwaysOnTop', 'VSConfigure - Completed')
	PopUp.OnEvent('Close', (*)=>ExitApp())

	PopUp.BackColor := 'cfcffcc'

	wdth := 620
	PopUp.AddButton('x' wdth - 3 ' vClose w16 h16 ' BS_ICON).OnEvent('Click', (*)=>ExitApp())

	Download imgUrl, savePath

	PopUp.SetFont('s18 cRed', 'Arial Black')
	PopUp.AddText('xm w' wdth ' Center', 'Get a ' discount '% discount by clicking this image')

	PopUp.AddPicture('vAds xm w' wdth ' h-1', savePath)
	PopUp['Ads'].OnEvent('Click', (*)=>(Run(prettyLink), ExitApp()))

	SendMessage BM_SETIMAGE, true,
		LoadPicture("C:\WINDOWS\system32\imageres.dll", "Icon236 w16 h16", &imgType), PopUp['Close']

	PopUp.SetFont('s18 c1d1d1d', 'Arial Black')
	PopUp.AddText('vRecomendation xm y+5 w' wdth ' Center', header)
	PopUp['Recomendation'].Focus()
	PopUp.Show()

	WM_SETCURSOR(wParam, lParam, msg, hwnd)
	{
		static BCursor := DllCall("LoadCursor", "UInt", 0, "Int", IDC_HAND := 32649, "UInt")

		; hwnd from onMessage refers to the parent window
		MouseGetPos(,,,&hwnd,2)

		if hwnd = PopUp['Ads'].hwnd
			return DllCall("SetCursor", "ptr", BCursor)
	}
}