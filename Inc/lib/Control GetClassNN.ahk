#Requires Autohotkey v2.0+
Control_GetClassNN(hWndWindow,hWndControl){ ;https://autohotkey.com/board/topic/45627-function-control-getclassnn-get-a-control-classnn/
	DetectHiddenWindows 'On'
	ClassNNList := WinGetControls('ahk_id ' hWndWindow )
	for Classnn in ClassNNList
	{
		try hwnd := ControlGetHwnd(Classnn,'ahk_id ' hWndWindow )
		if( hwnd = hWndControl)
			return Classnn
	}
}


/*
WinGet,ClassNNList,ControlList,ahk_id %hWndWindow%
Chrome_RenderWidgetHostHWND1`nIntermediate D3D Window1
Int   := WinGetID(...)
Int   := WinGetIDLast(...)
Int   := WinGetPID(...)
Str   := WinGetProcessName(...)
Str   := WinGetProcessPath(...)
Int   := WinGetCount(...)
Arr   := WinGetList(...)
Int   := WinGetMinMax(...)
Arr   := WinGetControls(...)
Arr   := WinGetControlsHwnd(...)
Int   := WinGetTransparent(...)
Str   := WinGetTransColor(...)
Int   := WinGetStyle(...)
Int   := WinGetExStyle(...)
*/