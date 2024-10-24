#Requires AutoHotkey v2.0

class advanced {
	static gui := Gui('+ToolWindow +AlwaysOnTop', 'Advanced')
	static checkboxes := ['Title', 'Description', 'Tags', 'Subtitles']

	static __New()
	{
		window := advanced.gui

		window.AddText('xm', 'Search in:')
		for ctrlName in advanced.checkboxes
			window.AddCheckbox('v' ctrlName ' ' (A_Index & 1 ? 'xm w50 Section' : 'ys') ' checked', ctrlName)

		window.gbWidth := 160
		window.dtWidth := 140
		window.AddGroupbox('xm y+' window.MarginY * 2 ' w' window.gbWidth, 'From:')
		window.AddDateTime('vFrom xp+10 yp+20 w' window.dtWidth ' choose' DateAdd(A_Now, -1095, 'd'))

		window.AddGroupbox('xm w' window.gbWidth, 'To:')
		window.AddDateTime('vTo xp+10 yp+20 w' window.dtWidth)


		xloc := 75*2 + window.MarginX
		window.AddButton('vAdvSubmit xm w75', 'Submit').OnEvent('Click', ObjBindMethod(advanced, 'Search'))
		window.AddButton('x+m w75', 'Cancel').OnEvent('Click', ObjBindMethod(advanced, 'Cancel'))
	}

	static __Call(name, params) => advanced.gui.%name%(params*)
	static __Item[name]
	{
		get => advanced.gui[name]
		set => advanced.gui[name] := value
	}

	static Search(*) => SubtitlesSearch.Search(advanced)

	static Cancel(*)
	{
		window := advanced.gui

		window.Hide()
		window['From'].value :=  DateAdd(A_Now, -1095, 'd')
		window['To'].value := A_Now

		for ctrlName in advanced.checkboxes
			window[ctrlName].value := true
	}
}