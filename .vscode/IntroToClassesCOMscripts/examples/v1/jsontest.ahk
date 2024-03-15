#Requires Autohotkey v1.1.36+
#Include, ext\json.ahk

json := new json

FileRead, result, files\test.json

res := json.load(result)
OutputDebug, % res.questions[2].name
