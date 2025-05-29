#Requires AutoHotkey v2.0
/*

From: https://www.autohotkey.com/boards/viewtopic.php?t=122402

*/
; OneNoteSelectQuickMenu.ahk
; No need for functions or classes here, all built-in using AHK V2
; Using this menu to quickly access my frequently used OneNote documentation pages on my desktop
; MenuName: choose unique name — like ONQAMenu for uniqueness when adding it to my other script menus

; Create a 2-d array for the menu strings ----------------------------------------------------------
; Note the reversal, V2 goes to Menu display, V1 goes to Menuhandler Switch/Case for action
; In this example, the menu gets a title, which is toggled to make it not enabled.
; It won't work to add the menu title and toggle it before the array menuhandling section because this throws the index off later
; This way, the array is managed, title is shown, and the index to the Switch/Case section is perfect.

Strings := [
  ; Array[1] contains the caption used in the Switch/Case section, Array[2] contains the text displayed in the Menu
  ["MenuTitle", "* * * Quick Text Insert Menu * * *"],
  ["GMail", "My Gmail E-mail Address"],
  ["Optum", "My Optum E-mail Address"],
  ["HotMail", "My Hotmail E-mail Address"],
  ["Query", "SQL Query Template"]
]

; Create the menu ----------------------------------------------------------------------------------

ONQAMenu := Menu()
ONQAMenu.SetColor("FFFFFF", true)

For V In Strings
  ONQAMenu.Add(V[2], MenuHandler) ; Using the Display names listed in the menu

;ONQAMenu.ToggleEnable( "* * * OneNote Quick Access Menu * * *") ; Title in display not enabled here
;so it doesn't foul up the indexing for the Switch/case.  Using array reference picks up the correct string title.

ONQAMenu.ToggleEnable(Strings[1][2])


; Ctrl+Shift+Middle Mouse button: Show the menu ----------------------------------------------------------------------

^+MButton:: ONQAMenu.Show()

; Menu handlers ------------------------------------------------------------------------------------

MenuHandler(ItemName, ItemPos, ThisMenu) {
  ; The menu handler uses the selected string, but sets up the Switch/Case section
  ; with the caption string based on the ItemPos index and assigns it to variable res

  res := Strings[ItemPos][1]  ; Note the Caption is used in the Switch/Case for brevity in defining the Case references

  ; ToolTip(res . "`n`nhas been selected to open")
  ; SetTimer(() => ToolTip(), -2000)

  Switch res
  {
    case "Gmail":
      A_Clipboard := 'jeff.trusty@gmail.com'
      Send("^v")
      ; Send("jeff.trusty@gmail.com")
    case "Optum":
      Send("{Raw}jeff.trusty@optum.com")
    case "Hotmail":
      Send("{Raw}jeff_trusty@hotmail.com")
    case "Query":
      Send("{Raw}select top 5 *{Enter}--begin tran update <TableName,,> set <Field,,> = <Update Value,,>{Enter}from <TableName,,>{Enter}where 1=1{Enter}and <Field,,> = <Field Value,,>^+m{right}{right}")


    default:
  }


}
