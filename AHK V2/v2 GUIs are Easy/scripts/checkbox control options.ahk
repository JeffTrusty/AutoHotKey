#SingleInstance
#Requires Autohotkey v2.0+

main := Gui('', 'Main')
main.addCheckBox('vsww Check3 CheckedGray', 'Start With Windows')
main.addCheckBox('vssw Checked', 'Show Splash Window')
main.addCheckBox('vstt Checked', 'Show Tooltips')
main.Show()
return