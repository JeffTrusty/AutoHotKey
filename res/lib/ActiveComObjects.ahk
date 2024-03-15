x := GetActiveObjects()
msgbox 


GetActiveObjects(Prefix:="",CaseSensitive:="Off") {
    objects:=Map()
    DllCall("ole32\CoGetMalloc", "uint", 1, "ptr*", &malloc:=0) ; malloc: IMalloc
    DllCall("ole32\CreateBindCtx", "uint", 0, "ptr*", &bindCtx:=0) ; bindCtx: IBindCtx
    ComCall(8, bindCtx, "ptr*",&rot:=0) ; rot: IRunningObjectTable
    ComCall(9, rot, "ptr*", &enum:=0) ; enum: IEnumMoniker
    while (ComCall(3, enum, "uint", 1, "ptr*", &mon:=0, "ptr", 0)=0) ; mon: IMoniker
    {
        ComCall(20, mon, "ptr", bindCtx, "ptr", 0, "ptr*", &pname:=0) ; GetDisplayName
        name:=StrGet(pname, "UTF-16")
        ComCall(5,malloc,"ptr",pname) ; Free
        if ((Prefix="") OR (InStr(name,Prefix,CaseSensitive)=1)) {
            ComCall(6, rot, "ptr", mon, "ptr*", obj:=ComValue(13, 0, 1)) ; GetObject
            ; Wrap the pointer as IDispatch if available, otherwise as IUnknown.
            try obj := ComObjQuery(obj, "{00020400-0000-0000-C000-000000000046}")
            ; Store it in the return array by suffix.
            objects[SubStr(name,StrLen(Prefix) + 1)] := obj
        }
        ObjRelease(mon)
    }
    ObjRelease(enum)
    ObjRelease(rot)
    ObjRelease(bindCtx)
    ObjRelease(malloc)
    return objects
}