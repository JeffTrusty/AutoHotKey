#Requires Autohotkey v2.0+
; reference: 
; https://docs.microsoft.com/en-us/windows/win32/winhttp/winhttprequest

http := ComObject("WinHttp.WinHttpRequest.5.1") ; create the object
http.open("GET", "https://www.autohotkey.com")     ; use methods defined
http.send()                                        ; in the reference above

msgbox http.status
msgbox http.responseText