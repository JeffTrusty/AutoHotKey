#Requires Autohotkey v2.0+
; reference:
; https://docs.microsoft.com/en-us/previous-versions//kxt24tyh(v=vs.85)?redirectedfrom=MSDN

haystack := "<A id='MyLink'>one<SPAN id='MyText'>two</SPAN>three</A>"
regex := ComObject("VBScript.RegExp")
regex.Global := true
regex.IgnoreCase := true
regex.Pattern := "<.*?(id='\w+')?>"

match := regex.Execute(haystack)
t := "Haystack: " haystack "`nNeedle:`t " regex.Pattern "`n`n"

t .= "`tPos (-1)`tLen`tVal`n`t------------------------------------------`n"
for item in match {
	_ := "[" A_Index-1 "]`t" 
	t .= _ item.FirstIndex "`t" item.Length "`t" item.value "`n"
	s .= _ item.SubMatches(0) "`n"
}
;// first character in the string is identified as 0
MsgBox t, match.count " Matches"
MsgBox s, "SubPatterns"
MsgBox regex.Replace(haystack, "|"), "Tags Replaced"