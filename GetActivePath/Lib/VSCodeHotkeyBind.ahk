#Requires AutoHotkey v2.0

BindVScodeHotkey(key)
{
	keybindings := a_appdata "\Code\User\keybindings.json"
	if FileExist(keybindings)
		KBJson := FileRead(keybindings,'utf-8')
	else
		KBJson := '[]'
	/*
		Key Bind Json is Invalid because it starts with array []
		we take into account if the file is empty or not has brackets or has comments
	*/
	KBJson := RegExReplace(KBJson, "^\/\/[\s\w]+", "")
	KBJson := StrReplace(KBJson,']',']}')
	KBJson := StrReplace(KBJson,'[','{"keybindings":[')
	x := JSON.Parse(KBJson)
	found := false
	if x.has('keybindings')
	{
		for index, keymap in x['keybindings']
		{
			if Type(keymap) != "map"
				continue
			if keymap['command'] = 'copyFilePath'
			&& keymap['key'] = key
			{
				found := true
			}	
		}

		if found
			return

		addkeymap := Map(
			"key"    , key,
			"command", "copyFilePath"
		)
		x['keybindings'].Push(addkeymap)
		KBJson := JSON.Stringify(x)
		KBJson := StrReplace(KBJson,']}',']')
		KBJson := StrReplace(KBJson,'{"keybindings":[','[')
	}
	else
	{
		KBJson := '[{"key":"' key '","command":"copyFilePath"}]'
	}
	Fileobj := FileOpen(keybindings, "w")
	Fileobj.Write(KBJson)
	Fileobj.Close()
}


