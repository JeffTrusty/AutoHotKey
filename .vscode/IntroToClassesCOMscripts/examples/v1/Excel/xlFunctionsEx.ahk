#NoEnv
#SingleInstance, Force

#Include, ext\XL.ahk

xl := XL_Handle(1)
XL_Open(xl,,,A_ScriptDir "\files\Sudoku game.xlsx")

XL_Copy_to_Clipboard(xl, "A1:A5")
XL_Create_New_Workbook(xl)
return