#Requires Autohotkey v2.0
SetText(*) => ControlSetText(t := sGui['EdtText'].value,c :=sGui['EdtClassNN'].value,title := StrReplace(sGui['EdtClass'].value,"`n"," "))


