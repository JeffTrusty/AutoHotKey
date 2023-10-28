#SingleInstance
#Requires Autohotkey v2.0+

defaultR := true
defaultG := false
defaultB := false

main := Gui('', 'Main')
main.addText('', 'Color:')
main.addRadio('vclrRed Checked' defaultR, 'Red')
main.addRadio('x+m vclrGreen Checked' defaultG, 'Green')
main.addRadio('x+m vclrBlue Checked' defaultB, 'Blue')
main.addText('xm', 'Size:')
main.addRadio('vclrS', 'Small')
main.addRadio('x+m vclrM Checked', 'Medium')
main.addRadio('x+m vclrL', 'Large')
main.Show()
return