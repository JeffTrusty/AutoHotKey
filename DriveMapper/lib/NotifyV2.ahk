#Requires Autohotkey v2.0-
/**
 * ============================================================================ *
 * Want a clear path for learning AutoHotkey?                                   *
 * Take a look at our AutoHotkey courses.                                 *
 * They're structured in a way to make learning AHK EASY                        *
 * Discover how easy AutoHotkey is here: https://the-Automator.com/Discover   *
 * ============================================================================ *
 */

/*
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;Notify AHK V2;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	Notify(Duration)
	'Duration' is how long you want notice to wait and then disappear
	it should be number, if 0 msg will not disappear user have Class
	will then add click event which will callback using notify.close and hide the Gui with transition effect
	and another callback will

	example
	Text := "I am ok`nhere I am trying to convert this in V2`nbut before that`nI need to figure it out`nusing what stuff, its brings `nthis damn good looking notification."
	Notice := Notify(0)
	Notice.show("abcd")
	Notice.Show("2nd text")

	example 2
	Notify.Show({Text:"Click to close", Header:"The Automator",Backcolor:"0xFFD23E",BDFontSize:"10"})

	Notify.Show({Text:"Click to close",Header:"The Automator",Backcolor:"0xFFD23E",HDFont:"Impact",HDFontColor:"Black",HDFontSize:"14",BDFont:"Consolas",BDFontColor:"0x298939",BDFontSize:"10",})

	Notify.Show({
					Text:"Click to close",
					Header:"The Automator",
					Backcolor:"0xFFD23E",
					HDFont:"Impact",
					HDFontColor:"Black",
					HDFontSize:"14",
					BDFont:"Consolas",
					BDFontColor:"0x298939",
					BDFontSize:"10",
	})

	text color supported
	Black	000000
	Silver	C0C0C0
	Gray	808080
	White	FFFFFF
	Maroon	800000
	Red	FF0000
	Purple	800080
	Fuchsia	FF00FF
	Green	008000
	Lime	00FF00
	Olive	808000
	Yellow	FFFF00
	Navy	000080
	Blue	0000FF
	Teal	008080
	Aqua	00FFFF
*/

;OnError()
;{
;	should disable notifcations ?
;}

; TODO: Icon support I will soon add
; TODO: we should talk about the private vs public methods

class Notify
{
	Static LastPOs := {}
	Static LastGui := 0
	Static Priority := 0
	Static Duration := 3
	Static Input :=
	{
		Header     :"Notification",
		Backcolor  :"0xFFD23E",
		HDFont     :"Impact",
		HDFontColor:"Black",
		HDFontSize :"14",
		BDFont     :"Consolas",
		BDFontColor:"0x298939",
		BDFontSize :"10",
		Duration   : 3,
		Transition :"Slide",
		Scale      :140,
	}


	static ResetCoord()
	{
		Notify.LastPOs := {}
		Notify.LastNote := 0
	}

	Static DestroyLastGui()
	{
		critical -2
		if Notify.LastGui != 0
			Notify.LastGui.Destroy()
		Notify.LastGui := 0
		Notify.ResetCoord()
	}

	static __New()
	{
		Notify.Transition := "Slide"
		Notify.Scale := 140
		Notify.BackColor := "0xFFD23E"
		Notify.Header := {font:{}}
		Notify.Body := {font:{}}
	}

	__New(Duration:=0)
	{
		Notify.Duration := Duration
		this.Body := {font:{}}
		this.Header := {font:{}}
		this.Scale:=140
	}

	; onEvent(EventName,Callback)
	; {
	; 	this.Notice.OnEvent(EventName, Callback)
	; }

	Static GetTaskBarPos()
	{
		WinGetPos(&x,&y,&w,&h, "ahk_class Shell_TrayWnd")
		if x = 0 && y = 0 && w = A_ScreenWidth
			Docked := "T"
		else if x = 0 && y = 0 && h = A_ScreenHeight
			Docked := "L"
		else if x = 0 &&  y > 0 && w = A_ScreenWidth
			Docked := "B"
		else if x > 0 && y = 0 && h = A_ScreenHeight
			Docked := "R"
		return {x:x,y:y,w:w,h:h,Docked:Docked}
	}

	Show(Input:=0) => Notify.Show(Input)
	/**
	 * ### Parameters
	 * * `Input` - Object representing all the options
	 *
	 * ### Example
	 * ```
	 * Notify.Show({
	 * 		Text:"Click to close",
	 * 		Header:"The Automators",
	 * 		Backcolor:"0xFFD23E",
	 * 		HDFont:"Impact",
	 * 		HDFontColor:"Black",
	 * 		HDFontSize:"14",
	 * 		BDFont:"Consolas",
	 * 		BDFontColor:"0x298939",
	 * 		BDFontSize:"10",
	 * })
	 * ```
	*/
	static Show(Input:=0)
	{
		static LastNote := 0
		static TaskBar := Notify.GetTaskBarPos()
		Switch(Type(Input))
		{
		Case "String":
			this.BackColor   := Notify.Input.Backcolor
			this.Header      := {Font:{Color:Notify.input.HDFontColor,Size:Notify.input.HDFontSize,Name:Notify.input.HDFont}}
			this.Header.Text := Notify.input.Header
			this.Body        := {Font:{Color:Notify.input.BDFontColor,Size:Notify.input.BDFontSize,Name:Notify.input.BDFont}}
			this.Body.Text   := Input
			this.Duration          := Notify.input.Duration
		Case "Object":
			this.Transition        := input.HasOwnProp("Transition")  ? input.Transition  : Notify.input.Transition
			this.Scale             := input.HasOwnProp("Scale")       ? input.Scale       : Notify.input.Scale
			This.BackColor         := input.HasOwnProp("Backcolor")   ? input.Backcolor   : Notify.input.Backcolor
			this.Header.Font.Name  := input.HasOwnProp("HDFont")      ? input.HDFont      : Notify.input.HDFont
			this.Header.Font.Color := input.HasOwnProp("HDFontColor") ? input.HDFontColor : Notify.input.HDFontColor
			this.Header.Font.Size  := input.HasOwnProp("HDFontSize")  ? input.HDFontSize  : Notify.input.HDFontSize
			this.Header.Text       := input.HasOwnProp("Header")      ? input.Header      : Notify.input.Header
			this.Body.Font.Name    := input.HasOwnProp("BDFont")      ? input.BDFont      : Notify.input.BDFont
			this.Body.Font.Color   := input.HasOwnProp("BDFontColor") ? input.BDFontColor : Notify.input.BDFontColor
			this.Body.Font.Size    := input.HasOwnProp("BDFontSize")  ? input.BDFontSize  : Notify.input.BDFontSize
			this.Duration          := input.HasOwnProp("Duration")    ? input.Duration    : Notify.input.Duration
			this.Body.Text := Input.Text
			if input.HasOwnProp("Callback")
				This.Callback 		:=   input.Callback
		}
		MyGui := Gui("-Caption +AlwaysOnTop +Owner +LastFound")
		MyGui.MarginX := 5
		MyGui.MarginY := 5
		MyGui.BackColor := This.BackColor
		MyGui.SetFont("c" this.Header.Font.Color " s" this.Header.Font.Size , this.Header.Font.Name )
		HD := MyGui.Add("Text",, this.Header.Text)
		MyGui.SetFont("c" this.Body.Font.Color 	 " s" this.Body.Font.Size   , this.Body.Font.Name )
		Notice := MyGui.Add("Text","xm y+m",this.Body.Text ) ;"xp yp+" this.Header.Font.Size +9.5, this.Body.Text)
		MyGui.Show("Hide NoActivate")
		WinGetPos(&x,&y,&w,&h,MyGui)
		if !notify.LastPOs.HasOwnProp("y")
			LastNote := 0
		if LastNote = 1 ;IsSet(LastNote)
		{
			Switch Taskbar.Docked
			{
				Case "B":
					if( (notify.LastPOs.y - h) > 0)
						POS := "x" A_ScreenWidth - w " y" notify.LastPOs.y - h -1
					else
						POS := "x" notify.LastPOs.x - w " y" A_ScreenHeight - TaskBar.h - h
				Case "R":
					if( (notify.LastPOs.y - h) > 0)
						POS := "x" notify.LastPOs.x " y" notify.LastPOs.y - h - 1
					else
						POS := "x" notify.LastPOs.x - w " y" A_ScreenHeight - h
			}
		}
		else
		{
			Switch Taskbar.Docked
			{
				Case "B":
					POS := "x" A_ScreenWidth - w " y" A_ScreenHeight - TaskBar.h - h
				Case "R":
					POS := "x" A_ScreenWidth - w - TaskBar.w " y" A_ScreenHeight - h
				default:
					POS := "x" A_ScreenWidth - w " y" A_ScreenHeight - h
			}
		}
		if this.HasOwnProp("Callback")
		{
			Notice.OnEvent("Click", This.Callback )
			HD.OnEvent("Click", This.Callback )
		}
		MyGui.Show(POS " NoActivate")
		WinGetPos(&x,&y,&w,&h,MyGui)
		notify.LastPOs := {x:x,y:y,w:w,h:h}
		LastNote := 1
		Notify.LastGui := MyGui
		if this.Duration = 0
		{
			Notice.OnEvent("Click", ObjBindMethod(this,"Close",MyGui))
			HD.OnEvent("Click", ObjBindMethod(this,"Close",MyGui))
		}

		if this.Duration > 0
		{

			;sleep(this.Duration * 1000)
			;this.close(this.Transition)
			;MyGui.Destroy()
			MyGui.Duration := this.Duration
			Notify.Close(MyGui)
			y := y+h
			if y > A_ScreenHeight
				x := x + w, y := 0
			Notify.LastPOs := {x:x,y:y,w:w,h:h}
		}

	}

	;Close(Gui, *) => Notify.Close(Gui, *)
	static Close(Gui,*) ;=> Notify.animation(Gui)
	{
	 	fn := ObjBindMethod(this, "animation", Gui)
	 	Settimer fn, -(this.Duration * 1000) ;, Notify.Priority--
	}

	animation(Gui) => Notify.animation(Gui)
	static animation(Gui)
	{

		try WinGetPos(&x,&y,&w,&h,Gui)
		if !isset(x)
			return
		Left := Down := DontMoveLeft := DontMoveDown:= 1
		switch this.Transition
		{
			Case "Left", "Slide":
				Left := 6, DontMoveDown := 0
			Case "Down":
				Down := 6, DontMoveLeft := 0
			Case "Vanish":
				DontMoveLeft := DontMoveDown:= 0
		}
		; if Gui.hasProp("Duration")
		; 	loop 500
		; 	{
		; 		sleep((Gui.Duration * 1000) / 500)
		; 		if Notify.LastGui = 0
		; 			return
		; 	}
		Critical - 1
		loop( this.Scale / 15) ; calculating Hidding and Trasitions
		{
			if Notify.LastGui = 0
				return
			try WinSetTransColor("Blue " this.Scale-A_index * 15,Gui)
			If (!Mod(A_index, 5))
				try Gui.Move(X + ((a_index/Left)*DontMoveLeft), Y + ((a_index/Down)*DontMoveDown))
			sleep 10 ;0.9/this.scale * 255
			if a_index > this.Scale
				msgbox a_index "`n" this.Scale "`nif you get this Msbox You have done somthing wrong in calculations of notify transition`n`nYou are not suppose to get this message"
		}
		Gui.Destroy()
		Notify.ResetCoord()
		; y := y+h
		; if y > A_ScreenHeight
		; 	x := x + w, y := 0
		; Notify.LastPOs := {x:x,y:y,w:w,h:h}
	}
}