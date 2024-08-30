#Requires AutoHotkey v2.0
;IconUnmute := A_ScriptDir '\res\MicUnmute.ico'
;TraySetIcon IconUnmute

Create_SettingGui(*)
{
	global
	ini := A_ScriptDir "\Search.ini"
	global cGui := Gui(,'AHKSearcher')
	cGui.Opt("+AlwaysOnTop")
	
	FontSize := IniRead(ini, "Setting", 'FontSize' ,14)
	cGui.SetFont('s' FontSize ' cBlack')

	cGui.oldHK := IniRead(ini,"Hotkeys" ,'HK','^+m')

	cGui.AddText("xm +0x200 ", "Hotkey:")
	cGui.AddHotkey("vHK xm ", StrReplace(cGui.oldHK,"#"))

	cGui.AddCheckbox('x+m yp+3 vSet_Win','Win')
	if InStr(cGui.oldHK,"#")
		cGui['Set_Win'].value := true
	else
		cGui['Set_Win'].value := false

	cGui.AddText("+0x200 xm ", "Font Size")
	Edit1 := cGui.AddEdit('xm +ReadOnly w85')
	CGui.AddUpDown('x+m vfsize Range10-18', FontSize)

	check := (IniRead(ini, "Setting",'color',0)?'+':'-')
	Check_DarkMode := cGui.AddCheckbox('x+m+100 yp+3 vDarkMode ' check 'Checked','DarkMode')

	Site := ""
	Sites := IniRead(ini, "Site",  ,defaultSites)
	Sites := StrSplit(Sites, "`n", "`r")
	for data in Sites
	{
		Sites := StrSplit(data,'=')	
		Site .= Sites[1] '`n'
	}
	
	Hotkey(cGui.oldHK,AHKSearcher,'on')
	EditSites := cGui.Add("Edit", "xm w400 h267 +Multi -wrap", Site)

	cGui.AddButton( "xm w100", "&Apply").OnEvent("Click",SetHotkey)
	cGui.AddButton( "w100 x+m", "&Cancel").OnEvent("Click",(*) => cGui.Hide())
	cGui.OnEvent("Escape",(*) => cGui.Hide())
	cGui.Title := "Set Hotkey"

	EditSites.Focus()

	color := IniRead(ini, "Setting",'Color','0')
	if (color = 1)
		StartWithDarkModeHotkeyGui()	

}

StartWithDarkModeHotkeyGui(*)
{
	r := 1
	for ctrl in cGui
	{
		if ctrl.type ~= 'i)ListView|UpDown'
		{
			EditSites.Opt('+Background292929')
			Edit1.SetFont('cBlack')
			continue
		}
		ctrl.SetFont('cffffff')
	}
	cGui.BackColor := "Black"
	;myGui.Show()
}


;cGui.Show()
SetHotkey(*)
{
	global myGui
	myGui.Destroy()
	myGui := Gui()
	
	if (Check_DarkMode.Value = 1)
	{
		myGui.BackColor := "Black"
		IniWrite 1 , ini, "Setting", 'Color'
		IniWrite cGui['fsize'].Value , ini, "Setting", 'FontSize'
	}
	else
	{
		myGui.BackColor := ""
		IniWrite 0 , ini, "Setting", 'Color'	
		IniWrite cGui['fsize'].Value , ini, "Setting", 'FontSize'
	}
	
	;Notify.show({BDText:'No Cant set Manualy font size'})
	
	;DarkMode(FontSize.Value,Check_DarkMode.Value)
    cGui.Hide()
    Hotkey(cGui.oldHK,AHKSearcher,'off')
    
    Set_Win := cGui['Set_Win'].value
    if Set_Win
        IniWrite cGui.oldHK := "#" cGui['HK'].value, ini, "Hotkeys" ,"HK"
    else
        IniWrite cGui.oldHK := cGui['HK'].value, ini, "Hotkeys" ,"HK"
    Hotkey(cGui.oldHK,AHKSearcher, 'on')

	SitedataMap := map()
	Sites := IniRead(ini,"Site",,defaultSites)
	Sites := StrSplit(Sites, "`n", "`r")
	for data in Sites
	{
		Sites := StrSplit(data,'=')
		if (sites[2] > 0)
			SitedataMap[sites[1]] := sites[1]
	}

	IniDelete ini, 'Site'
	last_Setting := StrSplit(EditSites.value, "`n", "`r")
	for data in last_Setting
	{
		if !data
			continue		

		Avalabel := 0
		for oldSite in SitedataMap 
		{
			if (oldSite = data)
			{
				Avalabel := 1
				Break
			}
		}

		if !(Avalabel = 1)
			IniWrite 0, ini, "Site" ,data
		else
			IniWrite 1, ini, "Site" ,data
	}
	CreateGui(400)		
}	

HKToString(hk)
{
	; removed logging due to performance issues
	; Log.Add(DEBUG_ICON_INFO, A_Now, A_ThisFunc, 'started', 'none')

	if !hk
		return

	temphk := []

	if InStr(hk, '#')
		temphk.Push('Win+')
	if InStr(hk, '^')
		temphk.Push('Ctrl+')
	if InStr(hk, '+')
		temphk.Push('Shift+')
	if InStr(hk, '!')
		temphk.Push('Alt+')

	hk := RegExReplace(hk, '[#^+!]')
	for mod in temphk
		fixedMods .= mod

	; Log.Add(DEBUG_ICON_INFO, A_Now, A_ThisFunc, 'ended', 'none')
	return (fixedMods ?? '') StrUpper(hk)
}