#Requires AutoHotkey v2.0
#SingleInstance Force
#Include JSON.ahk

obj := Json.Load(FileRead('menus.json'))

for primaryMenu, item in obj
  MsgBox("Primary Menu: " + primaryMenu)
sleep 10

; str := Json.Dump(context_menu)
; FileAppend str, 'menu.json'
