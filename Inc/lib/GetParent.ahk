#Requires Autohotkey v2.0+
GetParent(hWnd) {
	Return DllCall("GetParent", "Ptr", hWnd, "Ptr")
}