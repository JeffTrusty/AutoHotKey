;******************************************************************************
; Want a clear path for learning AutoHotkey?                                  *
; Take a look at our AutoHotkey Udemy courses.                                *
; They're structured in a way to make learning AHK EASY                       *
; Right now you can  get a coupon code here: https://the-Automator.com/Learn  *
;********************https://the-Automator.com/HotkeyString***********************************
;******************************************************************************
#NoEnv
#SingleInstance Force

getScript(HWND){
WinGetTitle, title, % "ahk_id " HWND
scriptPath := RegExReplace(title, "\s-.*")
SplitPath, scriptPath, scriptName, scriptDir
return {"hwnd": HWND, "scriptPath": scriptPath, "scriptName": scriptName, "scriptDir": scriptDir}
}
;******************************************************************************
LoadCommands(){
	global runningScripts, HotList, baseList, scriptList
	static lineComment  := "(\s*;\s?(?<comment>.*?))?"                                                               ; match comment
	static lineRegex    := "^(?!$)\s*(:(?<hsopts>(?:[*?BCKOPRTXZ0-9]|S(?:I|E|P))*):(?<hs>.*?)`:`:(?<hstext>.*?)"    ; match inline hotstrings
	                    .  "|(?<hk>[\w\s#!^+&<>*~$]+)`:`:.*?)" lineComment "$"                                      ; match inline hotkeys
	static commandRegex := "(Hotkey(\s|,\s*)*(?<hkcom>[^,]+)"                                                       ; match command hotkeys
	                    .  "|Hotstring\(""(\:(?<hscomopt>(?:[*?BCKOPRTXZ0-9]|S(?:I|E|P))*):(?<hscom>.*?))"""        ; match function hotstrings

	Gui, Main:default
	Gui, listview, HotList
	Progress, % "R1-" runningScripts, % "0/" runningScripts, % "Reading Files"

	LV_Delete()
	; loop over each script
	hotkeyCount := hotstringCount := 0, baseList := {}, scriptList := {}, matched := {}
	Loop, % runningScripts {
		Progress, % A_Index, % A_Index "/" runningScripts

		cs := getScript(runningScripts%A_Index%)
		FileRead, scriptContents, % cs.scriptPath

		IniRead, toBeRead, % script.configfile, % "Status", % regexReplace(cs.scriptName, "\..*$"), % true

		if (!toBeRead)
			Continue

		matched[cs.scriptName] := false ; no match yet
		; parse each line
		Loop, Parse, scriptContents, `n, `r
		{

			if (A_LoopField ~= "^\s*(\/\*|\((?!.*\)))")
				commentBlock := true
			else if (A_LoopField ~= "^\s*(\*\/|\))")
				commentBlock := false

			if (!A_LoopField || commentBlock || A_LoopField ~= "^\s*;.*?$")
				continue

			if (StrSplit(A_LoopField,";").1 ~= "i)\bHotkey|Hotstring\b") ;added strsplit to fix if comment has "hotstring" in it
				RegExMatch(StrSplit(A_LoopField,";").1, "iSO)" commandRegex, match)
			else
				RegExMatch(A_LoopField, "iSO)" lineRegex, match)

			;~  if (Match)
				;~  m(match.value,match.HK,match.HS,match.value,match.comment,match.hsopts,match.hscom)
			 ;~ OutputDebug, % A_LoopField "`n"
				;~ . "value  :`t" match.value "`n"
			 	;~ . "comment:`t" match.comment "`n"
			 	;~ . "OPTIONS:`t" match.hsOpts match.hsComOpt "`n"
			 	;~ . "COMMAND:`t" match.hs match.hk match.hkCom  match.hsCom "`n"

			if (!match)
				continue

			matched[cs.scriptName] := true

			; as they are mutually exclusive there will only be one var with values at a time
			options := match.hsOpts match.hsComOpt
			command := match.hs match.hsCom match.hk match.hkCom
			isHotkey := (match.hk || match.hkCom) ? true : false

			; update counter
			(isHotkey ? hotkeyCount++ : hotstringCount++)

			/*
				if(InStr(cs.scriptPath,"autohotkey.ahk")&&(A_LoopField~="i)appskey\s*\&\s*(g|h)")){
					m(A_LoopField,"",command)
				}
			*/
			scriptList[cs.scriptName] := true
			LV_Add("icon" (isHotkey ? 1 : 2), command
			                                , comment := match.hstext ? match.hstext : match.comment
			                                , cs.scriptName
			                                , A_Index
			                                , isHotkey ? "k" : "s"
			                                , cs.HWND
			                                , true)

			baseList.push({"command"     : command
			              ,"description" : comment
			              ,"file"        : cs.scriptName
			              ,"line"        : A_Index
			              ,"type"        : isHotkey ? "k" : "s"
			              ,"hwnd"        : cs.HWND
			              ,"status"      : true})
		}
	}

	GuiControl,, filterFile, % "|All||"
	for scriptName in scriptList
		GuiControl,, filterFile, % scriptName

	opts := ["125 right",625,180,73,"0 sort", 0, 0]
	Loop % LV_GetCount("Col")
		LV_ModifyCol(A_Index, opts[A_Index])

	SB_SetParts(150)
	SB_SetText("Hotkeys: " hotkeyCount, 1), SB_SetText("Hotstrings: " hotstringCount , 2)

	Progress, hide
	Gui, Main:show

	notMatched:=""
	for scriptFile,status in matched{
		if (!status)
			notMatched .= scriptFile "`n"
	}
	/*
		if (  notMatched){ ;Disabled by Joe
			MsgBox, % 0x30
		      , % "No Matches"
		      , % "These scripts don't seem to contain hotkeys or hotstrings:`n`n" notMatched "`n"
		      .   "Check the scripts directly to confirm.`n"
		      ;~ .   "If you are certain there should be a match, please create a bug report."
		}
		*/
		return
	}

;******************************************************************************
	/**
		* ============================================================================ *
		* @Author           : RaptorX <graptorx@gmail.com>
		* @Script Name      : Script Object
		* @Script Version   : 0.20.2
		* @Homepage         :
		*
		* @Creation Date    : November 09, 2020
		* @Modification Date: July 02, 2021
		*
		* @Description      :
		* -------------------
		* This is an object used to have a few common functions between scripts
		* Those are functions and variables related to basic script information,
		* upgrade and configuration.
		*
		* ============================================================================ *
	*/

; global script := {base         : script
;                  ,name          : regexreplace(A_ScriptName, "\.\w+")
;                  ,version      : "0.1.0"
;                  ,author       : ""
;                  ,email        : ""
;                  ,crtdate      : ""
;                  ,moddate      : ""
;                  ,homepagetext : ""
;                  ,homepagelink : ""
;                  ,donateLink   : "https://www.paypal.com/donate?hosted_button_id=MBT5HSD9G94N6"
;                  ,resfolder    : A_ScriptDir "\res"
;                  ,iconfile     : A_ScriptDir "\res\sct.ico"
;                  ,configfile   : A_ScriptDir "\AHKHotkeyString_settings.ini"
;                  ,configfolder : A_ScriptDir ""}

	class script{
		static DBG_NONE     := 0
	      ,DBG_ERRORS   := 1
	      ,DBG_WARNINGS := 2
	      ,DBG_VERBOSE  := 3

		static name         := ""
	      ,version      := ""
	      ,author       := ""
	      ,email        := ""
	      ,crtdate      := ""
	      ,moddate      := ""
	      ,homepagetext := ""
	      ,homepagelink := ""
	      ,resfolder    := ""
	      ,icon         := ""
	      ,config       := ""
	      ,systemID     := ""
	      ,dbgFile      := ""
	      ,dbgLevel     := this.DBG_NONE


		/**
			Function: Update
			Checks for the current script version
			Downloads the remote version information
			Compares and automatically downloads the new script file and reloads the script.

			Parameters:
			vfile - Version File
			Remote version file to be validated against.
			rfile - Remote File
			Script file to be downloaded and installed if a new version is found.
			Should be a zip file that will be unzipped by the function

			Notes:
			The versioning file should only contain a version string and nothing else.
			The matching will be performed against a SemVer format and only the three
			major components will be taken into account.

			e.g. '1.0.0'

			For more information about SemVer and its specs click here: <https://semver.org/>
		*/
		Update(vfile, rfile)
		{
		; Error Codes
			static ERR_INVALIDVFILE := 1
		,ERR_INVALIDRFILE       := 2
		,ERR_NOCONNECT          := 3
		,ERR_NORESPONSE         := 4
		,ERR_INVALIDVER         := 5
		,ERR_CURRENTVER         := 6
		,ERR_MSGTIMEOUT         := 7
		,ERR_USRCANCEL          := 8

		; A URL is expected in this parameter, we just perform a basic check
		; TODO make a more robust match
			if (!regexmatch(vfile, "^((?:http(?:s)?|ftp):\/\/)?((?:[a-z0-9_\-]+\.)+.*$)"))
				throw {code: ERR_INVALIDVFILE, msg: "Invalid URL`n`nThe version file parameter must point to a valid URL."}

		; This function expects a ZIP file
			if (!regexmatch(rfile, "\.zip"))
				throw {code: ERR_INVALIDRFILE, msg: "Invalid Zip`n`nThe remote file parameter must point to a zip file."}

		; Check if we are connected to the internet
			http := comobjcreate("WinHttp.WinHttpRequest.5.1")
			http.Open("GET", "https://www.google.com", true)
			http.Send()
			try
				http.WaitForResponse(1)
			catch e
				throw {code: ERR_NOCONNECT, msg: e.message}

			Progress, 50, 50/100, % "Checking for updates", % "Updating"

		; Download remote version file
			http.Open("GET", vfile, true)
			http.Send(), http.WaitForResponse()

			if !(http.responseText)
			{
				Progress, OFF
				throw {code: ERR_NORESPONSE, msg: "There was an error trying to download the ZIP file.`n"
											. "The server did not respond."}
			}

			regexmatch(this.version, "\d+\.\d+\.\d+", loVersion)
			regexmatch(http.responseText, "\d+\.\d+\.\d+", remVersion)

			Progress, 100, 100/100, % "Checking for updates", % "Updating"
			sleep 500 	; allow progress to update
			Progress, OFF

		; Make sure SemVer is used
			if (!loVersion || !remVersion)
				throw {code: ERR_INVALIDVER, msg: "Invalid version.`nThis function works with SemVer. "
											. "For more information refer to the documentation in the function"}

		; Compare against current stated version
			ver1 := strsplit(loVersion, ".")
			ver2 := strsplit(remVersion, ".")

			for i1,num1 in ver1
			{
				for i2,num2 in ver2
				{
					if (newversion)
						break

					if (i1 == i2)
						if (num2 > num1)
						{
							newversion := true
							break
						}
					else
						newversion := false
				}
			}

			if (!newversion)
				throw {code: ERR_CURRENTVER, msg: "You are using the latest version"}
			else
			{
			; If new version ask user what to do
			; Yes/No | Icon Question | System Modal
				msgbox % 0x4 + 0x20 + 0x1000
				 , % "New Update Available"
				 , % "There is a new update available for this application.`n"
				   . "Do you wish to upgrade to v" remVersion "?"
				 , 10	; timeout

				ifmsgbox timeout
					throw {code: ERR_MSGTIMEOUT, msg: "The Message Box timed out."}
				ifmsgbox no
					throw {code: ERR_USRCANCEL, msg: "The user pressed the cancel button."}

			; Create temporal dirs
				ghubname := (InStr(rfile, "github") ? regexreplace(a_scriptname, "\..*$") "-latest\" : "")
				filecreatedir % tmpDir := a_temp "\" regexreplace(a_scriptname, "\..*$")
				filecreatedir % zipDir := tmpDir "\uzip"

			; Create lock file
				fileappend % a_now, % lockFile := tmpDir "\lock"

			; Download zip file
				urldownloadtofile % rfile, % tmpDir "\temp.zip"

			; Extract zip file to temporal folder
				oShell := ComObjCreate("Shell.Application")
				oDir := oShell.NameSpace(zipDir), oZip := oShell.NameSpace(tmpDir "\temp.zip")
				oDir.CopyHere(oZip.Items), oShell := oDir := oZip := ""

				filedelete % tmpDir "\temp.zip"

				/*
						******************************************************
					* Wait for lock file to be released
					* Copy all files to current script directory
					* Cleanup temporal files
					* Run main script
					* EOF
					*******************************************************
				*/
				if (a_iscompiled){
					tmpBatch =
				(Ltrim
					:lock
					if not exist "%lockFile%" goto continue
					timeout /t 10
					goto lock
					:continue

					xcopy "%zipDir%\%ghubname%*.*" "%a_scriptdir%\" /E /C /I /Q /R /K /Y
					if exist "%a_scriptfullpath%" cmd /C "%a_scriptfullpath%"

					cmd /C "rmdir "%tmpDir%" /S /Q"
					exit
				)
					fileappend % tmpBatch, % tmpDir "\update.bat"
					run % a_comspec " /c """ tmpDir "\update.bat""",, hide
				}
				else
				{
					tmpScript =
				(Ltrim
					while (fileExist("%lockFile%"))
						sleep 10

					FileCopyDir %zipDir%\%ghubname%, %a_scriptdir%, true
					FileRemoveDir %tmpDir%, true

					if (fileExist("%a_scriptfullpath%"))
						run %a_scriptfullpath%
					else
						msgbox `% 0x10 + 0x1000
							 , `% "Update Error"
							 , `% "There was an error while running the updated version.``n"
								. "Try to run the program manually."
							 ,  10
						exitapp
				)
					fileappend % tmpScript, % tmpDir "\update.ahk"
					run % a_ahkpath " " tmpDir "\update.ahk"
				}
				filedelete % lockFile
				exitapp
			}
		}

		/**
			Function: Autostart
			This Adds the current script to the autorun section for the current
			user.

			Parameters:
			status - Autostart status
			It can be either true or false.
			Setting it to true would add the registry value.
			Setting it to false would delete an existing registry value.
		*/
		Autostart(status){
			if (status){
				RegWrite, REG_SZ
			        , HKCU\SOFTWARE\microsoft\windows\currentversion\run
			        , %a_scriptname%
			        , %a_scriptfullpath%
			}else
				regdelete, HKCU\SOFTWARE\microsoft\windows\currentversion\run
			         , %a_scriptname%
		}

		/**
			Function: Splash
			Shows a custom image as a splash screen with a simple fading animation

			Parameters:
			img   (opt) - file to be displayed
			speed (opt) - fast the fading animation will be. Higher value is faster.
			pause (opt) - long in seconds the image will be paused after fully displayed.
		*/
		Splash(img:="", speed:=10, pause:=2)
		{
			global

			gui, splash: -caption +lastfound +border +alwaysontop +owner
			$hwnd := winexist(), alpha := 0
			winset, transparent, 0

			gui, splash: add, picture, x0 y0 vpicimage, % img
			guicontrolget, picimage, splash:pos
			gui, splash: show, w%picimagew% h%picimageh%

			setbatchlines 3
			loop, 255
			{
				if (alpha >= 255)
					break
				alpha += speed
				winset, transparent, %alpha%
			}

		; pause duration in seconds
			sleep pause * 1000

			loop, 255
			{
				if (alpha <= 0)
					break
				alpha -= speed
				winset, transparent, %alpha%
			}
			setbatchlines -1

			gui, splash:destroy
			return
		}

		/**
			Funtion: Debug
			Allows sending conditional debug messages to the debugger and a log file filtered
			by the current debug level set on the object.

			Parameters:
			level - Debug Level, which can be:
			* this.DBG_NONE
			* this.DBG_ERRORS
			* this.DBG_WARNINGS
			* this.DBG_VERBOSE

			If you set the level for a particular message to *this.DBG_VERBOSE* this message
				wont be shown when the class debug level is set to lower than that (e.g. *this.DBG_WARNINGS*).

			label - Message label, mainly used to show the name of the function or label that triggered the message
			msg   - Arbitrary message that will be displayed on the debugger or logged to the log file
			vars* - Aditional parameters that whill be shown as passed. Useful to show variable contents to the debugger.

			Notes:
			The point of this function is to have all your debug messages added to your script and filter them out
			by just setting the object's dbgLevel variable once, which in turn would disable some types of messages.
		*/
		Debug(level:=1, label:=">", msg:="", vars*)
		{
			if !this.dbglevel
				return

			for i,var in vars
				varline .= "|" var

			dbgMessage := label ">" msg "`n" varline

			if (level <= this.dbglevel)
				outputdebug % dbgMessage
			if (this.dbgFile)
				FileAppend, % dbgMessage, % this.dbgFile
		}

		/**
			Function: About
			Shows a quick HTML Window based on the object's variable information

			Parameters:
			scriptName   (opt) - Name of the script which will be
			shown as the title of the window and the main header
			version      (opt) - Script Version in SimVer format, a "v"
			will be added automatically to this value
			author       (opt) - Name of the author of the script
			homepagetext (opt) - Display text for the script website
			homepagelink (opt) - Href link to that points to the scripts
			website (for pretty links and utm campaing codes)
			donateLink   (opt) - Link to a donation site
			email        (opt) - Developer email

			Notes:
			The function will try to infer the paramters if they are blank by checking
			the class variables if provided. This allows you to set all information once
			when instatiating the class, and the about GUI will be filled out automatically.
		*/
		About(scriptName:="", version:="", author:="", homepagetext:="", homepagelink:="", donateLink:="", email:="")
		{
			static doc

			scriptName := scriptName ? scriptName : this.name
			version := version ? version : this.version
			author := author ? author : this.author
			homepagetext := homepagetext ? homepagetext : RegExReplace(this.homepagetext, "http(s)?:\/\/")
			homepagelink := homepagelink ? homepagelink : RegExReplace(this.homepagelink, "http(s)?:\/\/")
			donateLink := donateLink ? donateLink : RegExReplace(this.donateLink, "http(s)?:\/\/")
			email := email ? email : this.email

			if (donateLink)
			{
				donateSection =
			(
				<div class="donate">
					<p>If you like this tool please consider <a href="https://%donateLink%">donating</a>.</p>
				</div>
				<hr>
			)
			}

			html =
		(
			<!DOCTYPE html>
			<html lang="en" dir="ltr">
				<head>
					<meta charset="utf-8">
					<meta http-equiv="X-UA-Compatible" content="IE=edge">
					<style media="screen">
						.top {
							text-align:center;
						}
						.top h2 {
							color:#2274A5;
							margin-bottom: 5px;
						}
						.donate {
							color:#E83F6F;
							text-align:center;
							font-weight:bold;
							font-size:small;
							margin: 20px;
						}
						p {
							margin: 0px;
						}
					</style>
				</head>
				<body>
					<div class="top">
						<h2>%scriptName%</h2>
						<p>v%version%</p>
						<hr>
						<p>%author%</p>
						<p><a href="https://%homepagelink%" target="_blank">%homepagetext%</a></p>
					</div>
					%donateSection%
				</body>
			</html>
		)

			btnxPos := 300/2 - 75/2
			axHight := donateLink ? 16 : 12

			gui aboutScript:new, +alwaysontop +toolwindow, % "About " this.name
			gui margin, 0
			gui color, white
			gui add, activex, w300 r%axHight% vdoc, htmlFile
			gui add, button, w75 x%btnxPos% gaboutClose, % "Close"
			doc.write(html)
			gui show
			return

			aboutClose:
			gui aboutScript:destroy
			return
		}

		/*
			Function: GetLicense
			Parameters:
			Notes:
		*/
		GetLicense()
		{
			global

			this.systemID := this.GetSystemID()
			cleanName := RegexReplace(A_ScriptName, "\..*$")
			for i,value in ["Type", "License"]
				RegRead, %value%, % "HKCU\SOFTWARE\" cleanName, % value

			if (!License)
			{
				MsgBox, % 0x4 + 0x20
			      , % "No license"
			      , % "Seems like there is no license activated on this computer.`n"
			        . "Do you have a license that you want to activate now?"

				IfMsgBox, Yes
				{
					Gui, license:new
					Gui, add, Text, w160, % "Paste the License Code here"
					Gui, add, Edit, w160 vLicenseNumber
					Gui, add, Button, w75 vTest, % "Save"
					Gui, add, Button, w75 x+10, % "Cancel"
					Gui, show

					saveFunction := Func("licenseButtonSave").bind(this)
					GuiControl, +g, test, % saveFunction
					Exit
				}

				MsgBox, % 0x30
			      , % "Unable to Run"
			      , % "This program cannot run without a license."

				ExitApp, 1
			}

			return {"type"    : Type
		       ,"number"  : License}
		}

		/*
			Function: SaveLicense
			Parameters:
			Notes:
		*/
		SaveLicense(licenseType, licenseNumber)
		{
			cleanName := RegexReplace(A_ScriptName, "\..*$")

			Try
			{
				RegWrite, % "REG_SZ"
			        , % "HKCU\SOFTWARE\" cleanName
			        , % "Type", % licenseType

				RegWrite, % "REG_SZ"
			        , % "HKCU\SOFTWARE\" cleanName
			        , % "License", % licenseNumber

				return true
			}
			catch
				return false
		}

		/*
			Function: IsLicenceValid
			Parameters:
			Notes:
		*/
		IsLicenceValid(licenseType, licenseNumber, URL)
		{
			res := this.EDDRequest(URL, "check_license", licenseType ,licenseNumber)

			if InStr(res, """license"":""inactive""")
				res := this.EDDRequest(URL, "activate_license", licenseType ,licenseNumber)

			if InStr(res, """license"":""valid""")
				return true
			else
				return false
		}

		GetSystemID()
		{
			wmi := ComObjGet("winmgmts:{impersonationLevel=impersonate}!\\" A_ComputerName "\root\cimv2")
			(wmi.ExecQuery("Select * from Win32_BaseBoard")._newEnum)[Computer]
			return Computer.SerialNumber
		}

		/*
			Function: EDDRequest
			Parameters:
			Notes:
		*/
		EDDRequest(URL, Action, licenseType, licenseNumber)
		{
			strQuery := url "?edd_action=" Action
		         .  "&item_id=" licenseType
		         .  "&license=" licenseNumber
		         .  (this.systemID ? "&url=" this.systemID : "")

			try
			{
				http := ComObjCreate("WinHttp.WinHttpRequest.5.1")
				http.Open("GET", strQuery)
				http.SetRequestHeader("Pragma", "no-cache")
				http.SetRequestHeader("Cache-Control", "no-cache, no-store")
				http.SetRequestHeader("User-Agent", "Mozilla/4.0 (compatible; Win32)")

				http.Send()
				http.WaitForResponse()

				return http.responseText
			}
			catch err
				return err.what ":`n" err.message
		}

	; Activate()
	; 	{
	; 	strQuery := this.strEddRootUrl . "?edd_action=activate_license&item_id=" . this.strRequestedProductId . "&license=" . this.strEddLicense . "&url=" . this.strUniqueSystemId
	; 	strJSON := Url2Var(strQuery)
	; 	Diag(A_ThisFunc . " strQuery", strQuery, "")
	; 	Diag(A_ThisFunc . " strJSON", strJSON, "")
	; 	return JSON.parse(strJSON)
	; 	}
	; Deactivate()
	; 	{
	; 	Loop, Parse, % "/|", |
	; 	{
	; 	strQuery := this.strEddRootUrl . "?edd_action=deactivate_license&item_id=" . this.strRequestedProductId . "&license=" . this.strEddLicense . "&url=" . this.strUniqueSystemId . A_LoopField
	; 	strJSON := Url2Var(strQuery)
	; 	Diag(A_ThisFunc . " strQuery", strQuery, "")
	; 	Diag(A_ThisFunc . " strJSON", strJSON, "")
	; 	this.oLicense := JSON.parse(strJSON)
	; 	if (this.oLicense.success)
	; 	break
	; 	}
	; 	}
	; GetVersion()
	; 	{
	; 	strQuery := this.strEddRootUrl . "?edd_action=get_version&item_id=" . this.oLicense.item_id . "&license=" . this.strEddLicense . "&url=" . this.strUniqueSystemId
	; 	strJSON := Url2Var(strQuery)
	; 	Diag(A_ThisFunc . " strQuery", strQuery, "")
	; 	Diag(A_ThisFunc . " strJSON", strJSON, "")
	; 	return JSON.parse(strJSON)
	; 	}
	; RenewLink()
	; 	{
	; 	strUrl := this.strEddRootUrl . "checkout/?edd_license_key=" . this.strEddLicense . "&download_id=" . this.oLicense.item_id
	; 	Diag(A_ThisFunc . " strUrl", strUrl, "")
	; 	return strUrl
	; 	}
	}

	licenseButtonSave(this, CtrlHwnd, GuiEvent, EventInfo, ErrLevel:="")
	{
		GuiControlGet, LicenseNumber
		if this.IsLicenceValid(this.eddID, licenseNumber, "https://the-Automator.com")
		{
			this.SaveLicense(this.eddID, LicenseNumber)
			Reload
		}
		else
		{
			MsgBox, % 0x10
		      , % "Invalid License"
		      , % "The license you entered is invalid and cannot be activated."

			ExitApp, 1
		}
	}

	licenseButtonCancel(CtrlHwnd, GuiEvent, EventInfo, ErrLevel:="")
	{
		MsgBox, % 0x30
	      , % "Unable to Run"
	      , % "This program cannot run without a license."

		ExitApp, 1
	}

	global script := {base         : script
                 ,name          : regexreplace(A_ScriptName, "\.\w+")
                 ,version      : "0.49.11"
                 ,author       : "Joe Glines"
                 ,email        : "Joe@the-Automator.com"
                 ,crtdate      : "May 21, 2021"
                 ,moddate      : "July 20, 2021"
                 ,homepagetext : "the-Automator.com/HotkeyString"
                 ,homepagelink : "https://the-Automator.com/HotkeyString"
                 ,donateLink   : "https://www.paypal.com/donate?hosted_button_id=MBT5HSD9G94N6"
			  ,resfolder    : A_ScriptDir "\res"
			  ;~ ,iconfile     : A_ScriptDir "\res\questionmark.ico"
                 ,configfile   : A_ScriptDir "\AHKHotkeyString_settings.ini"
                 ,configfolder : A_ScriptDir ""}

;******************************************************************************
; Want a clear path for learning AutoHotkey?                                  *
; Take a look at our AutoHotkey Udemy courses.                                *
; They're structured in a way to make learning AHK EASY                       *
; Right now you can  get a coupon code here: https://the-Automator.com/Learn  *
;********************https://the-Automator.com/HotkeyString***********************************
;******************************************************************************
;******************************************************************************
; Want a clear path for learning AutoHotkey?                                  *
; Take a look at our AutoHotkey Udemy courses.                                *
; They're structured in a way to make learning AHK EASY                       *
; Right now you can  get a coupon code here: https://the-Automator.com/Learn  *
;********************https://the-Automator.com/HotkeyString***********************************
;******************************************************************************
FilesToScan:=1
; Tray Menu
Menu, Tray, Click, 1
Menu, Tray, MainWindow

Menu, Tray, NoStandard
Menu, Tray, Icon, % script.iconfile
Menu, Tray, Icon, %A_WinDir%\system32\shell32.dll,24 ;Set custom Script icon

Menu, Tray, Add, % "Show Main GUI", % "ShowMainGUI"
Menu, Tray, Default, % "Show Main GUI"

Menu, Tray, Add
;~ Menu, Tray, Add, % "Preferences"
Menu, Tray, Add, &Preferences,Preferences

;~ Menu, Tray, Add, % "Check for Updates", % "Update"
Menu, Tray, Add, &About,About
Menu, Tray, Add
Menu, Tray, Add, % "Reload"
Menu, Tray, Add, % "Exit"

; Main Submenus
;~ Menu, File, Add, % "Preferences"
Menu, File, Add, &Preferences,Preferences
Menu, File, Add
Menu, File, Add, &Reload, Reload
Menu, File, Add, E&xit,Exit

	; Menu, Help, Add, % "Check for Updates", % "Update"
Menu, Help, Add, &About,About

; Main Menu
Menu, MainMenu, Add, &File, :File
Menu, MainMenu, Add, &Help, :Help

; Context Menu
Menu, MainContext, Add, % "Enable"
Menu, MainContext, Disable, % "Enable"
Menu, MainContext, Add, % "Disable"
Menu, MainContext, Add
Menu, MainContext, Add, % "Edit on Script", % "EditScript"

Reload(ItemName, ItemPos, MenuName){
		Reload
	}

	Exit(ItemName, ItemPos, MenuName){
		ExitApp, 0
	}

	About(ItemName, ItemPos, MenuName){
		script.About()
		return
	}

	Update(ItemName, ItemPos, MenuName){
		try
			script.update(false, false)
		catch err
			msgbox % err.code ": " err.msg

		return
	}

	Preferences(ItemName, ItemPos, MenuName){
		Gui, Preferences:default
		LV_Delete()

		WinGet, runningScripts, List, % "ahk_class AutoHotkey"
		Loop % runningScripts{
			currentScript := getScript(runningScripts%A_Index%)
			IniRead, status, % script.configfile, % "Status", % regexReplace(currentScript.scriptName, "\..*$"), % true

			LV_Add("check" status, currentScript.scriptName)
		}

		IniRead, GUIHotkey, % script.configfile, % "Hotkeys", % "MainGui", % "^+h" ;read the file- set default hotkey if none there
		GuiControl,, MainHotkey, % GUIHotkey
		Gui, Preferences:show
	}

	ShowMainGUI(ItemName:=0, ItemPos:=0, MenuName:=0){
		Gui, main:show
		return
	}

	Enable(ItemName, ItemPos, MenuName){
		Gui, main:Default
		Menu, MainContext, Disable, % "Enable"
		Menu, MainContext, Enable, % "Disable"

		row := LV_GetNext(0, "F")
		LV_Modify(row,,,,,,,,true)
		LV_GetText(command, row, 1)

		Hotkey, % command, % "DisableAction", OFF
	}

	Disable(ItemName, ItemPos, MenuName){
		Gui, main:Default
		Menu, MainContext, Enable, % "Enable"
		Menu, MainContext, Disable, % "Disable"

		row := LV_GetNext(0, "F")
		LV_Modify(row,,,,,,,,false)
		LV_GetText(command, row, 1)

		Hotkey, % command, % "DisableAction", ON
	}

	EditScript(ItemName, ItemPos, MenuName){
		Gui, main:Default
		LaunchEditor(LV_GetNext(0, "F"))
	}

	DisableAction(){
		tooltip % "This hotkey/hotstring was disabled by AHKHotkeyStringLookup."
		sleep 3000
		tooltip

		return
	}

	OnMessage(0x100, "ButtonDown") ; WM_BUTTONDOWN

	Gui, main:new
	Gui, Menu, MainMenu

	Gui, Font, s12, Segoe UI
	Gui, add, Text, w200, % "Search Text:"
	Gui, add, Text, w200 x+10, % "Filter by Type:"
	Gui, add, Text, w200 x+10, % "Filter by File:"

	Gui, add, Edit, w200 xm -WantReturn hwnd_searchTerm vsearchTerm gFilter
	Gui, add, DropDownList, w200 x+10 hwnd_filterType vfilterType gFilter, % "All||Hotkeys|Hotstrings"
	Gui, add, DropDownList, w200 x+10 hwnd_filterFile vfilterFile gFilter

	Gui, Font, s12, Consolas
	Gui, add, ListView, w1024 r30 xm           hwnd_hotList       vHotList       ghotListHandler, % "Command|Description|File|Line|type|hwnd|status"
	Gui, add, ListView, w1024 r30 xp yp hidden hwnd_hotListSearch vHotListSearch ghotListHandler, % "Command|Description|File|Line|type|hwnd|status"
; Gui, add, Button, x0 y0 hidden default, % "LaunchScript"

	Gui, Font, s12, Segoe UI
	Gui, add, StatusBar

	icons := IL_Create()
	for i,iconNumber in [1,5]
		IL_Add(icons, A_AhkPath, iconNumber)


	Gui, listview, HotList
	LV_ModifyCol("AutoHDR")
	LV_SetImageList(icons)

	Gui, listview, HotListSearch
	LV_ModifyCol("AutoHDR")
	LV_SetImageList(icons)

	Filter(CtrlHwnd, GuiEvent, EventInfo, ErrLevel:=""){
		global baseList, _filterType, _filterFile

		Gui, main:default
		GuiControl, hide, HotList
		GuiControl, show, HotListSearch
		GuiControlGet, searchTerm
		GuiControlGet, filterType
		GuiControlGet, filterFile

		Gui, ListView, HotListSearch
		LV_Delete()

		GuiControl, -redraw, HotList
		GuiControl, -redraw, HotListSearch
		hotkeyCount := hotstringCount := 0
		if (searchTerm){
			searchTerm := "i)\Q" searchTerm "\E" ; case insensitive regex
			for i,current in baseList{
				if (current.command ~= searchTerm || current.description ~= searchTerm
			||  current.script ~= searchTerm  || current.line ~= searchTerm)
			&& (filterType == "All" || current.type == (filterType == "Hotkeys" ? "k" : "s"))
			&& (filterFile == "All" || current.file == filterFile)	{
					current.type == "k" ? hotkeyCount++ : hotstringCount++
					LV_Add("icon" (current.type == "k" ? 1 : 2), current.command, current.description
				              ,current.file, current.line, current.type, current.hwnd, true)
				}
			}

		}
		else if ("0x" format("{:x}",CtrlHwnd) ~= _filterType "|" _filterFile){
			for i,current in baseList{
				if (filterType == "All" || current.type == (filterType == "Hotkeys" ? "k" : "s"))
			&& (filterFile == "All" || current.file == filterFile){
					current.type == "k" ? hotkeyCount++ : hotstringCount++
					LV_Add("icon" (current.type == "k" ? 1 : 2), current.command, current.description
				              ,current.file, current.line, current.type, current.hwnd, true)
				}
			}
		}else{
			for i,current in baseList
				current.type == "k" ? hotkeyCount++ : hotstringCount++
			ShowHotList()
		}

		opts := ["125 right",625,180,90,"0 sort", 0, 0]
		Loop % LV_GetCount("Col")
			LV_ModifyCol(A_Index, opts[A_Index])

		GuiControl, +redraw, HotList
		GuiControl, +redraw, HotListSearch

		SB_SetText("Hotkeys: " hotkeyCount, 1)
		SB_SetText("Hotstrings: " hotstringCount, 2)

		return
	}

	hotListHandler(CtrlHwnd, GuiEvent, EventInfo, ErrLevel:=""){
		static checkScript

		Gui, ListView, % A_GuiControl
		switch (GuiEvent){
			case "DoubleClick":
			LaunchEditor(EventInfo)
		}
	}

	ButtonDown(wParam, lParam, msg, hwnd){
		global _searchTerm, _hotList, _hotListSearch

		if (hwnd == _searchTerm){
			switch (wParam){
				case 13: ; Enter Key
				Gui, ListView, HotListSearch

				if (LV_GetCount() == 1)
					LaunchEditor(1)
				case 27: ; Escape Key
				GuiControl,, searchTerm, % ""
				ShowHotList()
			}
		}
		else if (RegExMatch(format("{:#x}", hwnd), _hotList "|" _hotListSearch)){
			switch (wParam){
				case 13: ; Enter Key
				Gui, ListView, % A_GuiControl
				LaunchEditor(LV_GetNext(0, "F"))
			}
		}
	}

	ShowHotList(){
		GuiControl, show, HotList
		GuiControl, hide, HotListSearch
		LV_Delete()
	}

	MainGuiContextMenu(GuiHwnd, CtrlHwnd, EventInfo, IsRightClick, X, Y){
		Menu, MainContext, Show
		return
}
;******************************************************************************
; Want a clear path for learning AutoHotkey?                                  *
; Take a look at our AutoHotkey Udemy courses.                                *
; They're structured in a way to make learning AHK EASY                       *
; Right now you can  get a coupon code here: https://the-Automator.com/Learn  *
;********************https://the-Automator.com/HotkeyString***********************************
;******************************************************************************
Gui, Preferences:new
IniRead, WarnNoneFound, % script.configfile, % "WarnNonefound", % "Warn", % "1"
Gui, add, groupbox, w220 r2, % "Main GUI Hotkey"
If (WarnNoneFound)
	Gui, add, CheckBox,x+100 Checked  vWarnNoneFound, Warn no Hotkeys/Strings found in file ;Joe Added
else
	Gui, add, CheckBox,x+100 vWarnNoneFound, Warn no Hotkeys/Strings found in file ;Joe Added
Gui, add, hotkey, w200 xm+10 yp+20 vMainHotkey

Gui, add, groupbox, w420 r23.2 xm, % "Ignored Files"
Gui, add, text, w400 xp+10 yp+20, % "Unchecked files will not be checked by the script.`n"
                                  . "Use this when the file does not contain any hotkeys.`n"
Gui, add, text, 0x10 w400 y+1

Gui, Font, s12, Consolas
Gui, add, ListView, w400 r15 y+1 checked vScriptIgnore, % "File"

Gui, Font
Gui, add, Button, w75 x355 y+20, % "Save"
LV_ModifyCol("AutoHDR")

PreferencesButtonSave(CtrlHwnd, GuiEvent, EventInfo, ErrLevel:=""){
	Gui, Preferences:default
	Loop, % LV_GetCount()
	{
		LV_GetText(scriptName, A_Index)

		SendMessage, 0x102C, A_Index - 1, 0xF000, SysListView321        ; 0x102C is LVM_GETITEMSTATE. 0xF000 is LVIS_STATEIMAGEMASK.
		IsChecked := (ErrorLevel >> 12) - 1                             ; This sets IsChecked to true if RowNumber is checked or false otherwise.

		IniWrite, % IsChecked, % script.configfile, % "Status", % regexReplace(scriptName, "\..*$")
	}

	IniRead, GUIHotkey, % script.configfile, % "Hotkeys", % "MainGui", % "!s"
	Hotkey, %  GUIHotkey, OFF
	;~ ControlGet,WarnNoHotkeys,Checked,,Button2,AHKHotkeyStringLookup2.ahk ;Joe Adding
	ControlGet,Warnkeys,Checked,,Button2, ;Simple Input Example
	IniWrite, % Warnkeys, % script.configfile, % "WarnNoneFound", % "Warn"
	GuiControlGet, MainHotkey
	IniWrite, % MainHotkey, % script.configfile, % "Hotkeys", % "MainGui"
	Hotkey, % MainHotkey, % "ShowMainGUI", ON

	Gui, Preferences:hide
	LoadCommands()
	return
}

OnExit("NotifyEnable")

; retreive running scripts
DetectHiddenWindows, On
WinGet, runningScripts, List, % "ahk_class AutoHotkey"

; - no scripts are running
if (!runningScripts){
	MsgBox, % 0x30, "Information", % "No scripts were running at this time."
	ExitApp, 0
}

if (!script.configfile)
	Preferences("ConfigMissing", 0, "None")
else
	LoadCommands()

IniRead, WarnNoneFound, % script.configfile, % "WarnNonefound", % "Warn", % "1"
;~ msgbox % WarnNoneFound
IniRead, GUIHotkey, % script.configfile, % "Hotkeys", % "MainGui", % "!s"
Hotkey, % GUIHotkey, % "ShowMainGUI"
return

NotifyEnable(){
	MsgBox, % 0x30
	      , % "Exit"
	      , % "All hotkeys previously disabled by HotkeyStringLookup will be re-enabled now"
	Return
}
;******************************************************************************
; Want a clear path for learning AutoHotkey?                                  *
; Take a look at our AutoHotkey Udemy courses.                                *
; They're structured in a way to make learning AHK EASY                       *
; Right now you can  get a coupon code here: https://the-Automator.com/Learn  *
;********************https://the-Automator.com/HotkeyString***********************************
;******************************************************************************
LaunchEditor(row){
	oldTitleMode := A_TitleMatchMode
	SetTitleMatchMode, 2

	LV_GetText(scriptName, row, 3), LV_GetText(scriptLine, row, 4)
	LV_GetText(scriptHWND, row, 6)

	SendMessage, 0x111, 65401, 0,, % "ahk_id " scriptHWND,,,, 1

	WinWait, % scriptName,,3
	if (!ErrLevel)	{
		DetectHiddenWindows, Off
		while !WinActive(scriptName){
			tooltip % "Waiting for Editor"
			WinActivate, % scriptName
		}
		tooltip
		DetectHiddenWindows, On


		/*
			The sleep below is important because
			some editors perform some actions on starup.

			AHKStudio for example remembers your last caret position.
			We have to wait until it sends the caret pos message
			before we do our own because if not the caret will be reset
		and one would think that the message failed.
		*/
		sleep 1000

		if WinActive("Notepad++")
			SendMessage, 2024, scriptLine-1,, Scintilla1, Notepad++
		else if WinActive("AHK Studio")
			SendMessage, 2024, scriptLine-1,, Scintilla2, AHK Studio
		else if WinActive("Notepad")
			SendMessage, 0x00B6, 0, scriptLine-1, Edit1, Notepad
		else
			SendInput, ^g%scriptLine%{enter}

		/*
			Sending the select command below in notepad
			would scroll back up giving the impression that
			the sendmessage above was not successful
		*/
		if !WinActive("Notepad")
			SendInput, +{End}
	}
	else
		MsgBox, % 0x10, % "Error", % "Could not open the script file"

	SetTitleMatchMode, % oldTitleMode
}
