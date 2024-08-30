extensions := Gui('ToolWindow AlwaysOnTop', 'VSConfigure - Extensions')
extensions.OnEvent('Close', (*)=>ExitApp())

extensions.SetFont('s10 c3b3bf7 bold', 'Arial')
extensions.AddText('', 'Available Extensions')
extensions.SetFont()

wdth := 750
list := extensions.AddListView('w' wdth ' r21 Checked Sort', ['Name', 'id', 'Description'])
list.ModifyCol(2, 0)

disabled := 'eamodio.gitlens,GitHub.remotehub,GitHub.vscode-pull-request-github,'
         .  'ms-vscode.azure-repos,ms-vscode.remote-repositories,DavidAnson.vscode-markdownlint'

extList := Map(
	'Alpha4.jsonl'                           ,{name:'JSONL',desc:'JSON Lines (jsonl) Language Support'},
	'Asuka.insertnumbers'                    ,{name:'Insert Numbers',desc:'Insert numbers on selected lines'},
	'DavidAnson.vscode-markdownlint'         ,{name:'VSCode Markdown Lint',desc:'Markdown linting and style checking for Visual Studio Code'},
	'DotJoshJohnson.xml'                     ,{name:'Xml Tools',desc:'XML Formatting, XQuery, and XPath Tools for Visual Studio Code'},
	'eamodio.gitlens'                        ,{name:'Gitlens',desc:'Visualize code authorship at a glance via Git blame annotations'},
	'equinusocio.vsc-material-theme-icons'   ,{name:'Material Theme Icons',desc:'Material Theme Icons, the most epic icons theme for Visual Studio Code and Material Theme'},
	'GitHub.remotehub'                       ,{name:'RemoteHub',desc:'Remotely browse and edit any GitHub repository'},
	'GitHub.vscode-pull-request-github'      ,{name:'Vscode Pull Request Github',desc:'Pull Request and Issue Provider for GitHub'},
	'gurumukhi.selected-lines-count'         ,{name:'Selected Lines Count',desc:'Shows the count of the currently selected lines'},
	'JannisX11.batch-rename-extension'       ,{name:'Batch Rename Extension',desc:'Batch rename files in the explorer inside VSCode'},
	'mark-wiemer.vscode-autohotkey-plus-plus',{name:'VSCode Autohotkey Plus Plus',desc:'AutoHotkey v1 IntelliSense, debug, and Language Support for VS Code'},
	'mechatroner.rainbow-csv'                ,{name:'Rainbow Csv',desc:'Highlight CSV and TSV files, Run SQL-like queries'},
	'mhutchie.git-graph'                     ,{name:'Git Graph',desc:'View a Git Graph of your repository, and perform Git actions from the graph.'},
	'ms-vscode.azure-repos'                  ,{name:'Azure Repos',desc:'Remotely browse and edit any Azure Repos'},
	'ms-vscode.hexeditor'                    ,{name:'Hexeditor',desc:'Allows viewing and editing files in a hex editor'},
	'ms-vscode.remote-repositories'          ,{name:'Remote Repositories',desc:'Remotely browse and edit git repositories'},
	'naumovs.color-highlight'                ,{name:'Color Highlight',desc:'Highlight web colors in your editor'},
	'oderwat.indent-rainbow'                 ,{name:'Indent Rainbow',desc:'Makes indentation easier to read'},
	'pejmannikram.vscode-auto-scroll'        ,{name:'VSCode Auto Scroll',desc:'Auto scroll to the end of file.'},
	'PKief.material-icon-theme'              ,{name:'Material Icon Theme',desc:'Material Design Icons for Visual Studio Code'},
	'shalimski.swapdiff'                     ,{name:'Swapdiff',desc:'Swap diff documents'},
	'thqby.vscode-autohotkey2-lsp'           ,{name:'VSCode Autohotkey2 Lsp',desc:'AutoHotkey v2 IntelliSense, debug, and Language Support for VS Code'},
	'timkmecl.codegpt3'                      ,{name:'Codegpt3',desc:'Use GPT3 or ChatGPT right inside the IDE to enhance and automate your coding with AI-powered assistance'},
	'yo1dog.cursor-align'                    ,{name:'Cursor Align',desc:'Aligns all cursors using spaces.'},
	'yzhang.markdown-all-in-one'             ,{name:'Markdown All In One',desc:'All you need to write Markdown'},
	'zero-plusplus.vscode-autohotkey-debug'  ,{name:'VSCode Autohotkey Debug',desc:'Advanced debugging support for AutoHotkey(includes H) v1 and v2'}
)
for id, ext in extList
	list.Add('Check' . !(disabled ~= id), ext.name, id, ext.desc)

loop list.GetCount('Column')
	list.ModifyCol(A_Index, A_Index = 2 ? 0 : 'AutoHDR')

extensions.AddButton('x' wdth+extensions.MarginX-75 ' w75', 'Install').OnEvent('Click', InstallExtensions)

InstallExtensions(*)
{
	extensions.Submit()
	while nextItem := list.GetNext(nextItem ?? 0, 'Checked')
	{
		id := list.GetText(nextItem, 2)
		cmds .= 'code --force --install-extension ' id ' & '
	}
	else
		cmds := ''
	
	if cmds
		RunWait A_ComSpec ' /C ' cmds

	Run 'code',, 'Hide'
	ShowPopUp('https://www.the-automator.com/adsinfo')
}

#HotIf list.Focused
Space::
{
	static LVM_GETITEMSTATE := 0x00102C
	static LVIS_STATEIMAGEMASK := 0x00F000
	
	while NextItem := list.GetNext(NextItem ?? 0)
	{
		ItemState := SendMessage(LVM_GETITEMSTATE, NextItem - 1, LVIS_STATEIMAGEMASK, list)
		IsChecked := (ItemState >> 12) - 1  ; This sets IsChecked to true if RowNumber is checked or false otherwise.
		list.Modify(NextItem, 'Check' . !IsChecked)
	}
}

^a::list.Modify(0,'Select')