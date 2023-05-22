#SingleInstance, Force

Gui New, +Resize
Gui Show, w500 h500
Return

GuiSize:
tooltip % a_guiwidth "x" a_guiheight
Return

GuiDropFiles:
msgbox % A_GuiEvent
Return

GuiEscape:
GuiClose:
msgbox Exiting app.
ExitApp
