#Requires Autohotkey v2.0+
IsWindowVisible(hWnd) {
	Return DllCall("IsWindowVisible", "Ptr", hWnd)
}