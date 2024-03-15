#Include .\lib\Native.ahk

class JSON {
    static __New() {
        Native.LoadModule(A_LineFile '\..\lib\ahk-json\' (A_PtrSize * 8) 'bit\ahk-json.dll', ['JSON'])
        this.DefineProp('true', {value: 1})
        this.DefineProp('false', {value: 0})
        this.DefineProp('null', {value: ''})
    }
    static parse(str) => 1
    static stringify(obj, space := 0) => 1
}