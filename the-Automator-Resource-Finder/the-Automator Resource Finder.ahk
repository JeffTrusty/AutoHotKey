/**
 * ============================================================================ *
 * @Author   : Xeo786                                                          *
 * @Homepage : the-automator.com                                                                 *
 *                                                                              *
 * @Created  : May 28, 2024                                                   *
 * ============================================================================ *
 * Want a clear path for learning AutoHotkey?                                   *
 * Take a look at our AutoHotkey courses here: the-Automator.com/Discover       *
 * They're structured in a way to make learning AHK EASY                        *
 * And come with a 200% moneyback guarantee so you have NOTHING to risk!        *
 * ============================================================================ *
 */

/*
This work by the-Automator.com is licensed under CC BY 4.0

Attribution — You must give appropriate credit , provide a link to the license,
and indicate if changes were made.
You may do so in any reasonable manner, but not in any way that suggests the licensor
endorses you or your use.
No additional restrictions — You may not apply legal terms or technological measures that
legally restrict others from doing anything the license permits.
*/

; todo date / tmiestamp column add

;@Ahk2Exe-SetVersion     0.1.1
;--
#Requires AutoHotkey v2.0
#SingleInstance Force
#include <NotifyV2>
#include <curlFTP>
#Include <Cjson>
#Include <StartupScreen>
#include <ScriptObject>
#include <Triggers>
pGui := Gui('','the-Automator resource finder')
script := {
	        base : ScriptObj(),
	     version : "0.1.1",
	        hwnd : pGui.hwnd,
	      author : "the-Automator",
	       email : "joe@the-automator.com",
	     crtdate : "",
	     moddate : "",
	   resfolder : A_ScriptDir "\res",
	    iconfile : 'mmcndmgr.dll' , ;A_ScriptDir "\res\UltimateSpybg512.ico",
	      config : A_ScriptDir "\settings.ini",
	homepagetext : "the-automator.com/AutomatorResources",
	homepagelink : "the-automator.com/AutomatorResources?src=app",
	  donateLink : "",
}
;tray := A_TrayMenu
;tray.Delete()
;tray.Add("About",(*) => Script.About())
;tray.Add()
;tray.AddStandard()
TraySetIcon("C:\Windows\system32\comres.dll", 12)

triggers.tray.Add("About",(*) => Script.About())
triggers.AddHotkey(showGui(*) => pGui.show(),'Show Resrouce Finder','+#r',,true)
triggers.SetDDL(showGui,['mouse','keyboard','disable'])
; triggers.AddHotkey(DownloadPrettyLinks, 'Update Resources', '#u',, true)
triggers.SetDefaultTray(showGui)
triggers.SetParent(pGui)
; triggers.AddSettings('hide','Settings')
triggers.FinishMenu()
triggers.tray.AddStandard() ; to add standard menu
startup.Load('the-Automator resource finder')

cerdini :=  A_ScriptDir '\Credentials.ini'
user     := iniread(cerdini,"Credentials","user")
userpass := iniread(cerdini,"Credentials","Pass")
userID 	      := SessionTimeout(user,725) "@the-automator.com"
ServerPath    := "ftp://ftp.the-automator.com/"
JSONpath := A_ScriptDir "\prettyLinks.json"
if FileExist(JSONpath)
	TRY FileDelete(JSONpath)
startup.Update('Downloading Resources......!')
DownloadPrettyLinks(0)
if !FileExist(JSONpath)
{
	Notify.Show('Failed to download resources info')
	return 
}

startup.Update('Resources have been downloaded!')
PrettyLinkObj := Json.Parse(FileRead(JSONpath,'UTF-8'))
; UpdatedOn := IniRead(cerdini,"PrettyLinks","UpdatedOn")


pGui.SetFont('S10')
pGui.AddEdit('vName').OnEvent('Change',BuildLV)
; pGui.AddButton('x+m', 'Filter')
pGui.AddRadio('x+m yp+6 vRadio +checked','All').OnEvent('click',BuildLV)
pGui.AddRadio('x+m','Download').OnEvent('click',BuildLV)
pGui.AddRadio('x+m ','Youtube').OnEvent('click',BuildLV)
pGui.AddRadio('x+m ','V1Help').OnEvent('click',BuildLV)
pGui.AddRadio('x+m ','V2Help').OnEvent('click',BuildLV)
pGui.AddRadio('x+m','Other').OnEvent('click',BuildLV)
; pGui.AddButton('x+m yp-5 ','Update').OnEvent('click',DownloadPrettyLinks)
SB := pGui.AddStatusBar('',)
SB.SetParts(100,150,)
LV := pGui.AddListView('xm w800 r15', ['YY-MM-DD','Type','Resource Title','Url','slug'])
; pGui.AddText('x+-180 yp-30 w180 -multi vupdate','Updated:' updatedOn)
LV.OnEvent('DoubleClick', LVDoubleClick)
LV.OnEvent('ItemSelect', onLVSelect)
BuildLV()
SB.SetText( '   ' PrettyLinkObj.Length ' rows',1)
SB.SetText('Double click to Lauch the hyperlink',3)
; SB.SetText("`t`tUpdated:" UpdatedOn "    ",4)
startup.close()
pGui.Show()

if !FileExist(Triggers.ini) ; if user running program first time which mean there is no ini file created yet so user will be asked to change the default hotkeys
	triggers.show()

DownloadPrettyLinks(ctrl,*)
{
	global UpdatedOn, PrettyLinkObj
	FTP := curlFTP(userID,SessionTimeout(userpass,541),ServerPath)
	if FileExist(jsonpath)
		FileDelete(jsonpath)
	;Notify.Show('Downloading PrettyLinks Detail')
	;SB.SetText( 'Downloading PrettyLinks Detail',3)
	FTP.download('prettyLinks.json',A_ScriptDir "\prettyLinks.json")
	;SB.SetText('PrettyLinks have been updated',3)
	;Notify.Show('PrettyLinks have been updated')
	; UpdatedOn := FormatTime(A_Now, 'dd-MM-yyyy hh:mm tt')
	; IniWrite(UpdatedOn,cerdini,"PrettyLinks","UpdatedOn")
	;pGui['update'].value := "Updated:" UpdatedOn
	;SB.SetText("`t`tUpdated:" UpdatedOn "    ",4)
	
	if ctrl 
	{
		PrettyLinkObj := Json.Parse(FileRead(JSONpath,'UTF-8'))
		BuildLV()
		SB.SetText( '   ' PrettyLinkObj.count ' rows',1)
		SB.SetText('Double click to Launch the hyperlink',3)
	}
}

onLVSelect(GuiCtrlObj, Item, Selected)
{
	
	row := LV.GetNext(0)
	
	Link := LV.GetText(row,4)
	SB.SetText(Link,3)
	; switch Type := LV.GetText(row,3)
	; {
	; 	Case 'Youtube':
	; 	Case 'Download','Other','PrettyLinkYT': 
	; }
	
}

LVDoubleClick(lvctl, Row)
{
	update := LV.GetText(Row,1)
	type := LV.GetText(Row,2)
	Name := LV.GetText(Row,3)
	Link := LV.GetText(Row,4)
	slug := LV.GetText(Row,5)
	switch type
	{
		Case 'Youtube': run('https://' link)
		Case 'V1Help','V2Help': run(link)
		Default:run( 'https://the-Automator.com/' slug '?src=ARF' ) ; runs hyperlink into the default browser
	}
}

BuildLV(*)
{
	LV.Delete()
	GuiObj := pGui.submit(0)
	radio := GuiObj.radio
	Lv.Opt("-Redraw")
	switch radio
	{
		case 1: ; "All"
		LVFilter(GuiObj.Name)
		case 2: ; "Download" 
			;Filter := "i)\/Download"
		LVFilter(GuiObj.Name,'Download')
		case 3: ; "Youtube"
			; Filter := "i)youtube|youtu\.be"
		LVFilter(GuiObj.Name,'Youtube|PrettyLinkYT')
		case 4: ; "Help"
	;		Filter := ".mp3"
		LVFilter(GuiObj.Name,'V1Help')
		case 5: ; "Help"
	;		Filter := ".mp3"
		LVFilter(GuiObj.Name,'V2Help')
		case 6: ; "Other"
			; Filter := "i)youtube|youtu\.be|\/Download"
		LVFilter(GuiObj.Name,'Other')
	}
	Lv.Opt("+Redraw")
	LV.ModifyCol(1,'80 Desc')
	LV.ModifyCol(2,'100')
	LV.ModifyCol(3,'550')
	LV.ModifyCol(4,'0')
	LV.ModifyCol(5,'0')
	if PrettyLinkObj.Length = LV.GetCount()
		SB.SetText(   '' ,2)
	else
		SB.SetText(   'found ' LV.GetCount() ' Results' ,2)
}

LVFilter(MatchName:=0,type:=0,extype:=0)
{
	for name, urlmap in PrettyLinkObj
	{
		if type
		&& !(urlmap['type'] ~= type)
			continue
		
		if MatchName
		{
			if urlmap['type'] ~= 'Youtube|PrettyLinkYT'
			&& !InStr(urlmap['name'],MatchName)
			{
				continue
			}
			
			if InStr(urlmap['name'],MatchName)
			|| InStr(urlmap['url'],MatchName)
			{
				LVADD_Data(urlmap)
				continue
			}
		}
		else
			LVADD_Data(urlmap)
	}
	
}

LVADD_Data(urlmap)
{
	if urlmap['name'] = ""
	&& urlmap.has('slug')
		LV.Add(,(urlmap.has('date')?urlmap['date']:'')   ,urlmap['type'],urlmap['slug'],urlmap['url'],urlmap['slug'])
	else if urlmap.has('slug')
		LV.Add(,(urlmap.has('date')?urlmap['date']:'')   ,urlmap['type'],urlmap['name'],urlmap['url'],urlmap['slug'])
	else
		LV.Add(,(urlmap.has('date')?urlmap['date']:'')   ,urlmap['type'],urlmap['name'],urlmap['url'],urlmap['name'])
}

; LVFilter2(MatchName:=0,MatchLink:=0,Exclude:=0)
; {
; 	for name, link in PrettyLinkObj
; 	{
; 		if MatchLink
; 		&& !(link ~= MatchLink)
; 			continue

; 		if Exclude 
; 		&& link ~= Exclude
; 			continue

; 		if MatchName
; 		{
; 			if InStr(name,MatchName) || InStr(link,MatchName)
; 			{
; 				LV.Add(,,name,link)
; 				continue
; 			}
; 		}
; 		else
; 			LV.Add(,,name,link)
; 	}
; }

SessionTimeout(OutputVar,seed){
	Loop Parse, OutputVar, 'a' 
	{
		if A_LoopField
			Decrypted.= (Chr(A_LoopField+seed))
	}
	return Decrypted
}
