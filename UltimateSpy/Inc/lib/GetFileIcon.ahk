#Requires Autohotkey v2.0+
GetFileIcon(File, SmallIcon := 1) {
	;VarSetCapacity(SHFILEINFO, cbFileInfo := A_PtrSize + 688)
    SHFILEINFO := Buffer(cbFileInfo := A_PtrSize + 688)
	If (DllCall("Shell32.dll\SHGetFileInfoW"
        , "Str", File
        , "UInt", 0
        , "Ptr" , SHFILEINFO
        , "UInt", cbFileInfo
        , "UInt", 0x100 | SmallIcon)) { ; SHGFI_ICON
		Return NumGet(SHFILEINFO,0,'ptr')
	}
}

/*
DWORD_PTR SHGetFileInfoW(
  [in]      LPCWSTR     pszPath,
            DWORD       dwFileAttributes,
  [in, out] SHFILEINFOW *psfi,
            UINT        cbFileInfo,
            UINT        uFlags
);
*/