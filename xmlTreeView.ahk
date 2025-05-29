#SingleInstance Force
xx := new XML("Settings")
;Gui, Font s20
xx.Add("Main/Second/Third/Fourth")
xx.Add("Moar/Tree/Branches/To/Look/At")
Gui, Add, TreeView, w500 h500
all := xx.sn("//")
while (aa := All.Item[A_index - 1], aa := XML.EA(aa)) {
  aa.SetAttribute("tv", TV_Add(aa.nodeName, SSN(aa.parentNode, "@tv").Text))
}
Gui, Show
return
GuiEscape:
  ExitApp
  return
  #Include <XML>
