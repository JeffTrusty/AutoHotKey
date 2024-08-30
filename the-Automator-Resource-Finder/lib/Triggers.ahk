/**
 * ============================================================================ *
 * @Library  : Triggers                                                         *
 * @Verson   : v 0.2.0                                                          *
 * @Author   : Xeo786                                                           *
 * @Homepage : the-automator.com                                                *
 * @Created  : June 14, 2024                                                    *
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

/**
 * ============================================================================ *
 *                               Using Trigger Class                            *
 * ============================================================================ *
 * The Trigger Class is designed to simplify the process of creating interactive
 * user interfaces (UI) for AutoHotkey scripts that require user-defined hotkeys,
 * hotstrings, or mouse shortcuts. It abstracts the complexities of GUI and tray
 * menu management, providing an easy-to-use interface for both developers and
 * end-users.
 * 
 * Why Use Trigger Class?
 * ----------------------
 * - **Ease of Use**: Developers can easily integrate the Trigger Class into their
 *   projects, allowing for quick assignment of functions to triggers without
 *   delving into the intricacies of GUI or tray menu creation and management.
 * 
 * - **Flexibility**: Users are given the freedom to customize their hotkeys,
 *   hotstrings, and mouse shortcuts through a user-friendly interface, making
 *   the application more adaptable to their needs.
 * 
 * - **Automatic Updates**: The class handles the GUI, tray menu, and ini togather
 *   automatically update them whenever a user makes changes, ensuring a seamless experience.
 * 
 * How to Use Trigger Class?
 * -------------------------
 * Include the Trigger Class in your AutoHotkey script as a library.
 * 
 * 1. **Static Class**: Trigger Class is designed as a static class,
 *    there's no need to create an instance of it. Directly use the class methods to interact
 *    with the functionality it provides.
 * 
 * 2. **Triggers.AddMouse() Method**: This method allows you to assign a mouse shortcut to a specific function.
 *    - `Callback`: The name of the function to be called when the mouse shortcut is activated.
 *    - `Label`: A unique identifier for the mouse shortcut.
 *    - `DefaultHotkey`: (Optional) The default mouse shortcut. Leave as an empty string for none.
 *    - `Title`: (Optional) A descriptive title for the mouse shortcut, so Trigger  on work when the window with Title is active.
 *    - `trayAction`: (Optional) A boolean indicating whether this shortcut should appear in the tray menu. Default is `false`.
 * 
 * 3. **Triggers.addHotkey() Method**: Use this method to assign a keyboard hotkey to trigger a function.
 *    - `Callback`: The function to execute when the hotkey is pressed.
 *    - `Label`: A unique identifier for the hotkey.
 *    - `DefaultHotkey`: (Optional) The default keyboard hotkey. Leave as an empty string if not applicable.
 *    - `Title`: (Optional) A descriptive title for the hotkey, so Trigger  on work when the window with Title is active.
 *    - `trayAction`: (Optional) A boolean value indicating if this hotkey should be included in the tray menu. Default is `false`.
 * 
 * 4. **Triggers.AddHotstring() Method**: This method allows you to assign a hotstring (a specific sequence of characters) to a function.
 *    - `Callback`: The function to be called when the hotstring is typed.
 *    - `Label`: A unique identifier for the hotstring.
 *    - `Defaulthotstring`: (Optional) The default sequence of characters for the hotstring. Leave as an empty string if not applicable.
 *    - `Title`: (Optional) A descriptive title for the hotstring, so Trigger  on work when the window with Title is active.
 *    - `trayAction`: (Optional) Indicates whether this Callback should be called using prior tray menu or Open Prefernces. Default is `false`.
 * 
 * 5. **Triggers.show() Mains ui Title**: It's mandatory to call `Triggers.show()` at the end after adding all the triggers.
 *    - `opt` : (Optional) A string that specifies options same as ahk GUI options.
 *    - `name`: (Optional) A string that sets the title of the UI window. If not provided, "Preference" is used as a default title.
 *
 * 6. ** Triggers.SetParent() Method**: This function sets a parent for the Triggers preferences GUI, making the specified GUI window the owner.
 *    - `GuiObj`: The GUI object whose window handle (`hwnd`) will be set as the parent for the Triggers preferences GUI. This GUI object becomes the owner of the Triggers preferences GUI.
 * 
 * The Trigger Class is a powerful tool for developers looking to enhance their
 * AutoHotkey scripts with dynamic and user-friendly trigger assignment
 * capabilities. By leveraging this class, you can create more versatile and
 * customizable applications with minimal additional coding effort.
 * ============================================================================ *
 */
#SingleInstance
#Requires Autohotkey v2.0+

Class triggers
{
	static Actions   := Map()
	static MouseBtns := ['LButton','RButton','MButton','XButton1','XButton2']
	static finished := false
	static __New()
	{
		this.ini := A_ScriptDir "\settings.ini"
		this.tray := A_TrayMenu
		this.tray.delete()
		this.LoadAllHotkeys()
		this.ui := Gui()
		this.ui.SetFont('s12','Verdana')
		this.BuildChildGuis()
	}
	static SetParent(GuiObj)
	{
		this.ui.opt('owner' GuiObj.hwnd )
	}

	Static     AddMouse(Callback,Label,DefaultHotkey:='',Title:='',trayAction:=false) => this.Add(Callback,Label,DefaultHotkey,Title,1,trayAction)
	Static    AddHotkey(Callback,Label,DefaultHotkey:='',Title:='',trayAction:=false) => this.Add(Callback,Label,DefaultHotkey,Title,2,trayAction)
	Static AddHotstring(Callback,Label,DefaultHotkey:='',Title:='',trayAction:=false) => this.Add(Callback,Label,DefaultHotkey,Title,3,trayAction)

	Static Add(Callback,Label,DefaultHotkey,Title, type, trayAction)
	{
		if this.finished
			throw Error('Cannot add new triggers after calling triggers.FinishMenu()')
		name := Callback.name
		if !DefaultHotkey := IniRead(this.ini, 'Hotkeys',name,DefaultHotkey)
			type := 0
		if name = ''
			return
		hstr := ''
		Label := IniRead(this.ini, 'Label',name,Label)
		Title := IniRead(this.ini, 'Title',name,Title)
		Dropdown := IniRead(this.ini, 'Dropdown',name,type)

		this.Actions[name] := Map('label',Label,'trigger',DefaultHotkey,'callback',Callback,'Title',Title)
		IF Dropdown = 3
			this.Actions[name]['oldDDL'] := 'hotstring', hstr := '::'
		ELSE
			this.Actions[name]['oldDDL'] := 'hotkey'
		this.Actions[name]['group'] 	:= 	this.ui.AddGroupBox('xm w600 h70', Label)
											; this.ui.AddText('xp+230','Context (WinTitle)')
		this.Actions[name]['ddl'] 		:= 	this.ui.AddDDL('xp+20 yp+30 w110 choose' Dropdown ' section',['mouse','keyboard','HotString','disable'])
		; this.Actions[name]['context'] 	:= 	this.ui.AddEdit('x+m w180')
											; this.ui.AddText('xs','Trigger:')
		this.UI.SetFont('s12','Arial Narrow')
		this.Actions[name]['HK']     	:= 	this.ui.AddEdit('x+m w440 readonly', text :=  this.HKToString(DefaultHotkey) ' - ' Title )
		this.UI.SetFont('s12','Verdana')

		this.Actions[name]['ddl'].onEvent('change',(ctrl,*)=>this.ChooseNewTriggerSelector(ctrl,name))
		this.Actions[name]['tempddl'] := Dropdown
		this.Actions[name]['tempddlstr'] := this.Actions[name]['ddl'].text
		this.Actions[name]['Disabled'] := ''
		; this.ui.Show()
		this.initHotkey(DefaultHotkey,callback)
		if trayAction
			this.tray.add(this.Actions[name]['tray'] := Label '`t' (hstr ? hstr DefaultHotkey:this.HKToString(DefaultHotkey)),(*)=>%name%())
		else
			this.tray.add(this.Actions[name]['tray'] := Label '`t' (hstr ? hstr DefaultHotkey:this.HKToString(DefaultHotkey)),(*)=>this.UI.Show())
		HotIfWinActive Title

		if !DefaultHotkey
			return

		if( Dropdown = 3)
			Hotstring(hstr DefaultHotkey,Callback,'on')
		Else
			Hotkey(DefaultHotkey,Callback,'on')
		HotIfWinActive

	}

	Static SetDefaultTray(Callback)
	{
		this.tray.Default := this.Actions[Callback.name]['tray']
	}

	static SetDDL(Callback,ddl:=[])
	{
		name            := Callback.name
		str             := this.Actions[name]['tempddlstr']
		currentDDL      := this.Actions[name]['ddl']
		currentDDL.delete()
		currentDDL.add(ddl)
		currentDDL.text := str
		
	}

	static Show(opt:='') => this.UI.show(opt)

	static FinishMenu(name:='Preferences',setDefault:=false)
	{
		
		this.UI.Title := name
		if this.finished
			return
		this.tray.add()
		this.tray.add(name,(*)=>this.UI.Show())
		this.tray.add()
		this.UI.AddButton('xm w80','save').onEvent('click',(*)=>this.ApplyTriggers())
		this.UI.AddButton('x+m w80','Cancel').onEvent('click',(*)=>this.UI.hide())
		if	setDefault
			this.tray.Default := name
		this.finished := true
	}

	static ApplyTriggers()
	{
		for name, action in this.Actions
		{
			this.Change(action['callback'])
		}
		this.UI.hide()
	}

	;;;;;;;;;;;;;;; Child Guis and interactions ;;;;;;;;;;;;;;;;;;;
	static BuildChildGuis()
	{
		; https://app.moqups.com/51AEbtdMaYYurh5QfBGOHV9ZPCSc715R/edit/page/ad64222d5
		; Hotkeys Gui
		Crosshairbg := A_ScriptDir '\res\crosshairbg.png'
		this.CH := {h:70,w:70}

		this.HKUI := Gui('Owner' this.ui.hwnd,'Select Hotkey')
		this.HKUI.SetFont('s12','Verdana')

		this.HKCR := this.HKUI.addpic('h' this.CH.h ' w' this.CH.w,Crosshairbg)
					 this.HKUI.AddText('xp+80 yp+10','Context (WinTitle):')
					 this.HKUI.SetFont('s12','Arial Narrow')
		this.HKCX := this.HKUI.AddEdit('xm+80 y+m w300')
					 this.HKUI.SetFont('s12','Verdana')
		; this.HKUI.AddPic('x+m h27 w-1 +border')

		this.HKUI.AddText('xm y+40 right','Select Hotkeys:')
		this.HKWin   := 	this.HKUI.AddCheckbox('xm','Win')
		this.HKCtrl  := 	this.HKUI.AddCheckbox('x+m','Ctrl')
		this.HKShift := 	this.HKUI.AddCheckbox('x+m','Shift')
		this.HKAlt   := 	this.HKUI.AddCheckbox('x+m','Alt')
		this.HK    := 	this.HKUI.Addhotkey('xm w380 readonly')


		this.HKApply := this.HKUI.AddButton('xm y+20 w80','Apply')
		this.HKCancel := this.HKUI.AddButton('x+m w80','Cancel')
		; Mouse Gui
		this.MSUI := Gui('Owner' this.ui.hwnd,'Select Mouse Trigger')
		this.MSUI.SetFont('s12','Verdana')

		this.MSCR :=  this.MSUI.addpic('h' this.CH.h ' w' this.CH.w,Crosshairbg)
					  this.MSUI.AddText('xp+80 yp+10','Context (WinTitle):')
					  this.MSUI.SetFont('s12','Arial Narrow')
		this.MSCX :=  this.MSUI.AddEdit('xm+80 y+m w300')
					  this.MSUI.SetFont('s12','Verdana')

		this.MSUI.AddText('xm y+40','Select Mouse Trigger:')
		this.MSWin   := 	this.MSUI.AddCheckbox('xm','Win')
		this.MSCtrl  := 	this.MSUI.AddCheckbox('x+m','Ctrl')
		this.MSShift := 	this.MSUI.AddCheckbox('x+m','Shift')
		this.MSAlt   := 	this.MSUI.AddCheckbox('x+m','Alt')
		this.MS      :=   this.MSUI.AddDDL('xm w300',['Left','Right','Middle','XButton1','XButton2'])
		this.MSApply :=   this.MSUI.AddButton('xm y+20 w80','Apply')
		this.MSCancel :=  this.MSUI.AddButton('x+m w80','Cancel')

		; Hotstrings Gui
		this.HSUI := Gui('Owner' this.ui.hwnd,'Select Hotstring')
		this.HSUI.SetFont('s12','Verdana')

		this.HSCR :=  this.HSUI.addpic('h' this.CH.h ' w' this.CH.w,Crosshairbg)
					  this.HSUI.AddText('xp+80 yp+10','Context (WinTitle):')
					  this.HSUI.SetFont('s12','Arial Narrow')
		this.HSCX :=  this.HSUI.AddEdit('xm+80 y+m w300')
					  this.HSUI.SetFont('s12','Verdana')

		this.HSUI.AddText('xm y+40','Hotstring:')
		this.HS := this.HSUI.AddEdit('xm w380')
		this.HSApply := this.HSUI.AddButton('xm y+20 w80','Apply')
		this.HSCancel := this.HSUI.AddButton('x+m w80','Cancel')


		this.HKUI.onEvent('close',(ctrl,*)=>this.HideAllChildGuis(ctrl))
		this.MSUI.onEvent('close',(ctrl,*)=>this.HideAllChildGuis(ctrl))
		this.HSUI.onEvent('close',(ctrl,*)=>this.HideAllChildGuis(ctrl))

		this.HKCancel.onEvent('click',(ctrl,*)=>this.HideAllChildGuis(ctrl))
		this.MSCancel.onEvent('click',(ctrl,*)=>this.HideAllChildGuis(ctrl))
		this.HSCancel.onEvent('click',(ctrl,*)=>this.HideAllChildGuis(ctrl))

		this.HKApply.onEvent('click',(*)=>this.ChildSubmit())
		this.MSApply.onEvent('click',(*)=>this.ChildSubmit())
		this.HSApply.onEvent('click',(*)=>this.ChildSubmit())

		this.HKCR.onEvent('click',(*)=>this.showCrosshairs())
		this.MSCR.onEvent('click',(*)=>this.showCrosshairs())
		this.HSCR.onEvent('click',(*)=>this.showCrosshairs())

		; creatig crosshairs

		this.Crosshair := Gui("-SysMenu +AlwaysOnTop -Border -Caption -DPIScale")
		this.Crosshair.AddPicture('x0 y0 h40 w40'  ,A_ScriptDir "\res\Crosshair.png")
		this.Crosshair.MarginX := 0
		this.Crosshair.MarginY := 0
		this.Crosshair.Show('hide')
		WinSetTransColor('white ' 100 ,this.Crosshair)

		this.HK.onEvent('change',hkupdate)

		hkupdate(*) ; disable to set win, shift, alt, ctrl hotkey
		{
			if this.HK.Value ~= '\+|\!|\^'
				this.HK.Value := 'None'
		}

	}

	static UpdateMSUI()
	{
		trigger := this.Actions[this.CurrentLabel]['trigger']
		if InStr(trigger, '#')
			this.MSWin.value := 1
		if InStr(trigger, '^')
			this.MSCtrl.value := 1
		if InStr(trigger, '+')
			this.MSShift.value := 1
		if InStr(trigger, '!')
			this.MSAlt.value := 1
		MB := RegExReplace(trigger,'\#|\^|\+|\!')
		for i, mbtn in this.MouseBtns
			if mbtn = MB
				this.MS.value := i
		this.MSCX.value := this.Actions[this.CurrentLabel]['Title']
	}

	static UpdateHKUI()
	{
		trigger := this.Actions[this.CurrentLabel]['trigger']
		if InStr(trigger, '#')
			this.HKWin.value := 1
		if InStr(trigger, '^')
			this.HKCtrl.value := 1
		if InStr(trigger, '+')
			this.HKShift.value := 1
		if InStr(trigger, '!')
			this.HKAlt.value := 1
		this.HK.value := RegExReplace(trigger,'\#|\^|\+|\!')
		this.HKCX.value := this.Actions[this.CurrentLabel]['Title']
	}

	static UpdateHSUI()
	{
		trigger := this.Actions[this.CurrentLabel]['trigger']
		this.HS.value := trigger
		this.HSCX.value := this.Actions[this.CurrentLabel]['Title']
	}

	static ResetAllChildGuis()
	{
		this.HKCX.value := ''
		this.HKWin.value := 0
		this.HKCtrl.value := 0
		this.HKShift.value := 0
		this.HKAlt.value := 0
		this.HK.value := ''

		this.MSWin.value := 0
		this.MSCtrl.value := 0
		this.MSShift.value := 0
		this.MSAlt.value := 0
		this.MS.value := 0
		this.MSCX.value := ''

		this.HS.value := ''
		this.HSCX.value := ''
	}

	static showCrosshairs()
	{
		Switch this.CurrentChild.title
		{
			Case 'Select Hotkey':
				this.Crosshair.opt('owner' this.HKUI.hwnd)
				CR := this.HKCR
				titlefilter := this.HKCX
			Case 'Select Mouse Trigger':
				this.Crosshair.opt('owner' this.MSUI.hwnd)
				CR := this.MSCR
				titlefilter := this.MSCX
			Case 'Select Hotstring':
				this.Crosshair.opt('owner' this.HSUI.hwnd)
				CR := this.HSCR
				titlefilter := this.HSCX
		}

		CoordMode 'Mouse', 'Screen'
		this.Crosshair.Show()
		WinSetTransColor('white ' 0 ,CR)
		;while Lbutton_Pressed
		while GetKeyState("Lbutton","P")
		{
			MouseGetPos &X, &Y
			sleep 5
			this.Crosshair.Move(X- (this.CH.h/2),Y- (this.CH.w/2))
		}
		this.Crosshair.hide()
		WinSetTransColor('white ' 255 ,CR)
		WinWaitNotActive WinExist(this.Crosshair)
		MouseGetPos &X, &Y, &iHwnd, &Editnn

		MouseGetPos(&x,&y,&hwnd,&ctrlHwnd,1)
		if title := WinGetTitle('ahk_id' hwnd)
			titlefilter.value := title
	}

	static ChildSubmit()
	{
		str := ''
		Switch this.CurrentChild.title
		{
			Case 'Select Mouse Trigger':
				if !this.MS.value
					return
				if this.MSWin.value
					str .= '#'
				if this.MSCtrl.value
					str .= '^'
				if this.MSShift.value
					str .= '+'
				if this.MSAlt.value
					str .= '!'
				str .= this.MouseBtns[this.MS.value]
				titlefilter := this.MSCX
				tempddl := 1
				if str = 'LButton'
				{
					ToolTip('Left Button is not allowed`nplease combine any modifier key with it.')
					settimer(ToolTip, -2000)
					return
				}
			Case 'Select Hotkey':
				if !this.HK.value
					return
				if this.HKWin.value
					str .= '#'
				if this.HKCtrl.value
					str .= '^'
				if this.HKShift.value
					str .= '+'
				if this.HKAlt.value
					str .= '!'
				str .= this.HK.value
				titlefilter := this.HKCX
				tempddl := 2
			Case 'Select Hotstring':
				if !this.HS.value
					return
				str := this.HS.value
				titlefilter := this.HSCX
				tempddl := 3
		}
		if this.CheckDuplicateHotkey(str,titlefilter.value)
			return
		this.Actions[this.CurrentLabel]['NewTrigger'] := str
		this.Actions[this.CurrentLabel]['tempddl']    := tempddl
		this.Actions[this.CurrentLabel]['HK'].value   := this.HKToString(str) ( titlefilter.value ? ' - ' titlefilter.value : '')
		this.Actions[this.CurrentLabel]['Title']      := ( titlefilter.value ? titlefilter.value : '')
		this.HideAllChildGuis()

	}

	static CheckDuplicateHotkey(HK,title)
	{
		if !FileExist(this.ini)
			return
		for i, line in StrSplit(IniRead(this.ini,'Hotkeys'),'`n','`r')
		{
			if RegExMatch(line,'(.*)=(.*)',&r)
			&& r[1] != this.CurrentLabel
			&& title = iniread(this.ini,'Title',r[1],'')
			&& hk = r[2]
			{
				tooltip 'Hotkey already in use'
				settimer(tooltip,-2000)
				return true
			}
		}
	}

	static HideAllChildGuis(ctrl := 0)
	{
		this.HKUI.hide()
		this.MSUI.hide()
		this.HSUI.hide()
		this.UI.opt('-disabled')
		this.UI.show()
		if ctrl
			this.actions[this.CurrentLabel]['ddl'].value := this.Actions[this.CurrentLabel]['tempddl']
		this.CurrentLabel := ''
		this.CurrentChild := ''
	}

	;;;;;;;;;;;;;;; Main Gui and interactions ;;;;;;;;;;;;;;;;;;;

	static ChooseNewTriggerSelector(ctrl,name)
	{
		this.UI.opt('+disabled')
		this.ResetAllChildGuis()
		;Dropdown := IniRead(this.ini, 'Dropdown',name,0)
		Dropdown := this.Actions[name]['tempddl']
		title := this.Actions[name]['Title']
		this.Actions[name]['Disabled'] := false
		this.tray.Enable(this.Actions[name]['tray'])
		switch ctrl.text, 0 ; 'mouse','keyboard','HotString','disable'
		{
			Case 'mouse':
			this.MSUI.show()
			this.CurrentChild := this.MSUI
			this.CurrentLabel := name
			this.MSCX.value := title
			this.MS.Focus()
			if Dropdown = ctrl.value
				this.UPdateMSUI()
			Case 'keyboard':
			this.HKUI.show()
			this.CurrentChild := this.HKUI
			this.CurrentLabel := name
			this.HKCX.value := title
			this.HK.focus()
			if Dropdown = ctrl.value
				this.UPdateHKUI()
			Case 'HotString':
			this.HSUI.show()
			this.CurrentChild := this.HSUI
			this.CurrentLabel := name
			this.HSCX.value := title
			this.HS.focus()
			if Dropdown = ctrl.value
				this.UPdateHSUI()
			Case 'disable':
				this.HotkeyRemove(this.Actions[name]['callback'])
				this.Actions[name]['Disabled'] := true
				this.UI.opt('-disabled')
		}
	}

	static initHotkey(defaultkey,callback)
	{
		name := callback.name
		title := ''
		if this.Actions.Has(name)
		{
			Lable := this.Actions[name]['label']
			; this.Actions[name]['HK'].value := this.Actions[name]['trigger'] title
			if this.Actions[name]['Title'] != ''
				this.Actions[name]['HK'].value .= ' - ' this.Actions[name]['Title']
			return
		}
		this.Hotkey(defaultkey,callback)
		this.Actions[name]['HK'].value := defaultkey
	}

	static Hotkey(key,callback) ; should change the name to settrigger
	{
		Name := callback.name
		Dropdown := IniRead(this.ini, 'Dropdown',name) + 0
		if Dropdown = 3
			Hotstring('::' key,callback,'on')
		Else
			Hotkey(key,callback,'on')
	}

	static Change(callback)
	{
		switch type(callback), 0
		{
			Case 'Func':
				Name := callback.name
				if !this.Actions.Has(name)
				|| this.Actions[name]['Disabled']
					return
				if this.Actions[name].has('NewTrigger')
					newHotkey := this.Actions[name]['NewTrigger']
				else
					newHotkey := this.Actions[name]['trigger']
				
				if newHotkey = ''
					return

				oldHotkey := this.Actions[name]['trigger']

				Label     := this.Actions[name]['label']
				Title     := this.Actions[name]['Title']
				ddl       := this.Actions[name]['ddl'].value
				oldDDl    := this.Actions[name]['oldDDL']

				HotIfWinActive IniRead(this.ini, 'Title',name,Title) 
				if oldDDl = 'hotstring'
				&& oldHotkey != ''
					Hotstring(hst := '::' this.Actions[name]['trigger'],,'Off')
				else if oldHotkey != ''
					Hotkey(this.Actions[name]['trigger'],callback,'Off')
				; newHotkey := control.value
				HotIfWinActive Title
				if( ddl = 3)
					Hotstring('::' newHotkey,callback,'On')
				Else
					Hotkey(newHotkey,callback,'On')
				HotIfWinActive
				IniWrite(Label, this.ini, 'Label',name)
				IniWrite(newHotkey, this.ini, 'Hotkeys',name)
				IniWrite(Title, this.ini, 'Title',name)
				IniWrite(ddl, this.ini, 'Dropdown',name)

				if ( ddl = 3)
				&& oldDDl = 'hotstring'
					this.tray.Rename(  Label '`t::' this.Actions[name]['trigger'], this.Actions[name]['tray'] := Label '`t::' newHotkey)
				else if ( ddl != 3)
				&& oldDDl = 'hotstring'
					this.tray.Rename(  Label '`t::' this.Actions[name]['trigger'], this.Actions[name]['tray'] := Label '`t' this.HKToString(newHotkey))
				else if ( ddl = 3)
				&& oldDDl != 'hotstring'
					this.tray.Rename(  Label '`t' this.HKToString(this.Actions[name]['trigger']), this.Actions[name]['tray'] := Label '`t::' newHotkey )
				else
					this.tray.Rename(  Label '`t' this.HKToString(this.Actions[name]['trigger']), this.Actions[name]['tray'] := Label '`t' this.HKToString(newHotkey) )

				IF ddl = 3
					this.Actions[name]['oldDDL'] := 'hotstring'
				else
					this.Actions[name]['oldDDL'] := 'hotkey'

					this.Actions[name]['trigger'] := newHotkey
			Case 'Array':
				for i, cb in callback
					this.Change(cb)
		}
	}

	static HotkeyRemove(callback)
	{
		Name := callback.name
		currenthotkey := this.Actions[name]['trigger']
		; Label := this.Actions[name]['label']
		Title := this.Actions[name]['Title']
		HotIfWinActive Title
		try 
			Hotkey(currenthotkey,callback,'off')
		catch
			try 
				Hotstring('::' currenthotkey,,'off')

		HotIfWinActive
		; IniDelete(this.ini, 'Hotkeys',name)
		; IniDelete(this.ini, 'Label',name)
		; IniDelete(this.ini, 'Title',name)
		; IniDelete(this.ini, 'Dropdown',name)
		;this.tray.Rename(this.Actions[name]['label'] '`t' this.HKToString(currenthotkey), this.Actions[name]['label'])
		this.tray.Disable(this.Actions[name]['tray'] )
		; this.tray.Delete(name '`t' this.HKToString(this.Hotkeys[name]))
	}

	static LoadAllHotkeys()
	{
		try hotkeyslist := IniRead(this.ini, 'Hotkeys')
		if isset(hotkeyslist)
		{
			for i, line in StrSplit(hotkeyslist,'`n','`r')
			{
				name := RegExReplace(line,'^([^=]+)=.*','$1')
				key := IniRead(this.ini, 'Hotkeys',name)
				Label := IniRead(this.ini, 'Label',name)
				Title := IniRead(this.ini, 'Title',name,'')
				if !IsSet(%name%)
					continue
				HotIfWinActive Title
				this.Hotkey(key,%name%)
				HotIfWinActive
				;this.Hotkeys[name] := key ; (Title ? ' - ' Title : '')
			}
		}
	}

	static reset()
	{
		this.Hotkeys := Map()
		this.Controls := Map()
		this.tray.delete()
		try FileDelete this.ini
	}

	static HKToString(hk)
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

}