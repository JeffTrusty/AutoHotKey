#Requires Autohotkey v2.0+
#Include "ext\JSON\JSON.ahk"

json_file := FileRead('files\test.json')

res := json.parse(json_file)
OutputDebug res['questions'][2]['name']
