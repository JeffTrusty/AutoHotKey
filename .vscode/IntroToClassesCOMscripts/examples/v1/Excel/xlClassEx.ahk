#NoEnv
#Persistent
#SingleInstance, Force

#Include, ext\XL Class.ahk

xl := new xl
xl.open(A_ScriptDir "\files\Sudoku game.xlsx")

xl.visible := false
return