#Include <ConfigGui>
#Include <ScriptObject>
#SingleInstance Force
#Requires AutoHotkey v2.0+

/*
 * ============================================================================ *
 * Want a clear path for learning AutoHotkey?                                   *
 * Take a look at our AutoHotkey courses here: the-Automator.com/Discover       *
 * They're structured in a way to make learning AHK EASY                        *
 * And come with a 200% moneyback guarantee so you have NOTHING to risk!        *
 * ============================================================================ *
*/

/*
This work by the-Automator.com is licensed under CC BY 4.0

Attribution — You must give appropriate credit , provide a link to the license,and indicate if changes were made.
You may do so in any reasonable manner, but not in any way that suggests the licensor endorses you or your use.
No additional restrictions — You may not apply legal terms or technological measures that legally restrict others from doing anything the license permits.
*/

script := {
	        base : ScriptObj(),
	     version : "0.0.1",
	        hwnd : '',
	      author : "the-Automator",
	       email : "joe@the-automator.com",
	     crtdate : 'March 07, 2024',
	     moddate : 'March 07, 2024',
	   resfolder : A_ScriptDir "\res",
        ;iconfile : "ddores.dll",
    homepagetext : "the-Automator.com/FlexiFinder",
	homepagelink : "https://the-Automator.com/FlexiFinder?src=app",
	  donateLink : 'https://www.paypal.com/donate?hosted_button_id=MBT5HSD9G94N6',
}

defaultSites := 
(
	"Autohotkey.com=1
	Autohotkey.com/docs/v1=0
	Autohotkey.com/docs/v2=0
	StackOverflow.com=0
	StackOverflow.com/questions/tagged/Autohotkey=0
	the-Automator.com=0
	YouTube.com=0"
)

if !Fileexist(ini := A_ScriptDir "\Search.ini")
{
	IniWrite defaultSites, ini, "Site"
	IniWrite 0 , ini, "Radio", 'Google'
	;myGui.Show()
}

Create_SettingGui()

The_TrayMenu()
{
	tray := A_TrayMenu
	tray.Delete()

	;tray.Add("Show`t" HKToString(cGui.oldHK),(*) => myGui.Show())
	tray.Add("Show`t" HKToString(cGui.oldHK),ReCreateGui)
	tray.Add("Preference",(*) => cgui.Show())
	tray.Add("About",(*) => Script.About())
	tray.Default := "Show`t" HKToString(cGui.oldHK)
	tray.ClickCount := 1

	tray.Add()
	tray.AddStandard()

}

ReCreateGui(*)
{
	global myGui
	myGui.Destroy()
	myGui := Gui()
	CreateGui(400)
	myGui.Show()
}

last_Setting := IniRead(ini, "Setting",,"Color=1")
last_Setting := StrSplit(last_Setting, "`n", "`r")
for data in last_Setting
	last_Setting := StrSplit(data,'=')

;Radio := IniRead(ini, "Last Search", 'Radio' ,1)
Radio := IniRead(ini, "Radio",'Goolge' ,'Google=1')
RadioSearch := StrSplit(Radio,'=')

TraySetIcon("shell32.dll","14")
myGui := Gui()

FontSize := IniRead(ini, "Setting", 'FontSize' ,14)
myGui.SetFont('s' FontSize ' cBlack')
; myGui.BackColor := "White"
CreateGui(400)
Persistent

CreateGui(GuiWidth := 500)
{
	switch IniRead(ini, "Setting", 'FontSize' ,14)
	{
		case 10,11,12,13:GuiWidth:=380
		case 14,15,16:GuiWidth:=500
		case 17,18:GuiWidth:=550
		default:
	}

	FontSize := IniRead(ini, "Setting", 'FontSize' ,14)
	myGui.SetFont('s' FontSize ' cBlack')
	The_TrayMenu()

	startup := []
	Sites := IniRead(ini,"Site",,defaultSites)
	Sites := StrSplit(Sites, "`n", "`r")
	for data in Sites
	{
		Sites := StrSplit(data,'=')
		RegExMatch(Sites[1], "i)^(?:https?:\/\/)?(?:www\.)?(.+)$", &Site)
		startup.Push(Site[1])
	}

	SearchSites := myGui.Add("ListView", "vLV xm y16 w" GuiWidth " r" (Startup.Length>10?10:Startup.Length) " +LV0x4000 +Background0xFFFFFF +Checked -hdr", ["Sites"])
	for site in startup
	{
		isChecked := IniRead(ini, 'Site', site, false)
		SearchSites.add("Check" isChecked, site)
	}

	Radio := IniRead(ini, "Radio",'Goolge' ,'Google=1')
	RadioSearch := StrSplit(Radio,'=')

	switch RadioSearch[2]
	{
		Case 1:
			Google := myGui.Add("Radio", "xm  +Checked vgoogle" , "Google")
			Bing := myGui.Add("Radio", "x+m  vbing", "Bing")
			Duck := myGui.Add("Radio", "x+m  vDuck", "Duckduckgo")
		Case 2:
			Google := myGui.Add("Radio", "xm vgoogle" , "Google")
			Bing := myGui.Add("Radio", "x+m  vBing +checked", "Bing")
			Duck := myGui.Add("Radio", "x+m  vDuck ", "Duckduckgo")
		Case 3:
			Google := myGui.Add("Radio", "xm vgoogle " , "Google")
			Bing := myGui.Add("Radio", "x+m  vbing ", "Bing")
			Duck := myGui.Add("Radio", "x+m  vDuck +Checked", "Duckduckgo")
		default:
			MsgBox("The last search value is invalid", "Error", "IconX")
			return
	}
	myGui.Add("Edit", "xm w" GuiWidth " h31 vEdit -VScroll")
	Search := myGui.Add("Button", "w100 x+-100 y+m Default ", "Search")
	Pref := myGui.Add("Button", "xm yp", "Options")
	MyGui.Add("CheckBox", "x+m yp+7 vquotes w180", "Double quotes")
	Mygui.OnEvent("Escape",(*) => mygui.Hide())

	Pref.OnEvent("Click", Prefe)
	Search.OnEvent("Click", SerachSite)

	myGui.Title := "FlexiFinder"
	if (IniRead(ini, "Setting", "Color" ,"AutoHotkey.com=1") = 1)
	{
		Sleep 200
		StartWithDarkMode(1)
	}

	if FileExist(ini)
		myGui.Show()
}

Prefe(*)
{
	Create_SettingGui()
	cgui.Show()
	Send '{End}'
}

StartWithDarkMode(*)
{
	for ctrl in MyGui
	{
		if ctrl.type ~= 'i)ListView|Edit'
		{
			ctrl.Opt('+Background292929')
			;SearchSites.opt('+Background0xC0C0C0')
			;continue
		}
		ctrl.SetFont('cffffff')
	}
	myGui.BackColor := "Black"
	;myGui.Show()
}

;  show the search gui
AHKSearcher(*)
{
	clipsave := a_clipboard
	a_clipboard := ''
	send '^c'
	Sleep 200

	text := a_clipboard
	myGui['Edit'].value := text

	myGui.Show()
	a_clipboard := clipsave ;Restore Clipboard
}

SerachSite(*)
{
	if !myGui['Edit'].Value
	{
		msgbox  'Your did not type anything in Search Box  ' ,,16
		return
	
	}
	else
	{
		MyGui.Hide()
		LastSearchini()
		Row := 0
		loop
		{
			row := MyGui['LV'].GetNext(Row,'Checked')
			if !row
			{
				if (A_Index = 1)
				{
					msgbox  'Your did not select a site to search' ,,16
					return
				}
				Break
			}

			if myGui['Google'].value
			{
				GoogleSearch := "http://www.google.com/search?q="
				Site_data := MyGui['LV'].GetText(row,1)
				IF myGui['quotes'].value
					Runthis := GoogleSearch '"' myGui['Edit'].text '"' "+site:" Site_data
				else
					Runthis := GoogleSearch myGui['Edit'].text "+site:" Site_data

				Run  Runthis
				IniWrite 1 , ini, "Site", Site_data
				IniWrite 1 , ini, "Radio", 'Google'
			}
			else if myGui['Bing'].value
			{
				BingSite := "https://www.bing.com/search?q="
				Site_data := MyGui['LV'].GetText(row,1)
				IF myGui['quotes'].value
					Runthis := BingSite '"' myGui['Edit'].text '"' "+site:" Site_data
				else
					Runthis := BingSite myGui['Edit'].text "+site:" Site_data
				Run  Runthis
				IniWrite 2 , ini, "Site", Site_data
				IniWrite 2 , ini, "Radio", 'Bing'
			}
			else if myGui['Duck'].value
			{
				DuckSite := "https://duckduckgo.com/?va=c&t=h_&q="
				Site_data := MyGui['LV'].GetText(row,1)
				IF myGui['quotes'].value
					Runthis := DuckSite '"' myGui['Edit'].text '"' "+site:" Site_data
				else
					Runthis := DuckSite myGui['Edit'].text "+site:" Site_data
				Run  Runthis
				IniWrite 3 , ini, "Site", Site_data
				IniWrite 3 , ini, "Radio", 'Duck'
			}
		}
	}
}

LastSearchini()
{
	ini := A_ScriptDir "\Search.ini"
	IniDelete ini,"Radio"
	Sites := IniRead(ini,"Site",, defaultSites)
	Sites := StrSplit(Sites, "`n", "`r")
	for data in Sites
	{
		Sites := StrSplit(data,'=')
		IniWrite 0, ini,'Site',Sites[1]
	}
}