#Requires AutoHotkey v2.0
; startup.init('my new app')
; msgbox 'close startup'
; startup.close()
class startup
{
	static pic := A_ScriptDir '\res\the-Automator.gif'
	static Load(Header)
	{
		startup.mGui := Gui('-caption')
		startup.mGui.SetFont("s20 w600")
		startup.mGui.BackColor := '0xFFD23E'
		startup.Header := startup.mGui.AddText("x10 y50 w600 center BackgroundTrans", Header)
		startup.mGui.SetFont("s16 w200")
		startup.Note := startup.mGui.AddText("x10 y350 w600 center BackgroundTrans", "Loading...")
		startup.sGui := Gui('-caption parent' startup.mGui.hwnd)
		startup.sGui.MarginX := 0
		startup.sGui.MarginY := 0
		startup.sGui.Add("ActiveX", "x0 y0 w620 h410", "mshtml:<img src='" startup.pic "' />")
		startup.sGui.Show('x0 y0')
		startup.mGui.Show('h410 w620')
	}

	static UpdateHeader(Header) => startup.Header.value := Header

	static Update(Note) => startup.Note.value := Note
	static close()
	{
		startup.sGui.Destroy()
		startup.mGui.Destroy()
	}
}

