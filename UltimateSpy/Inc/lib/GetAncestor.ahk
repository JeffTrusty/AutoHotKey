#Requires Autohotkey v2.0+
GetAncestor(hWnd, Flag := 2) {
	if hWnd
	&& hWnd > 0
		Return DllCall("GetAncestor", "Ptr", hWnd, "UInt", Flag)
}