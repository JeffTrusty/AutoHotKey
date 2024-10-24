#Requires AutoHotkey v2.0

class main {

	static gui := Gui('', 'Youtube Subtitles Search')

	static __New()
	{
		window := main.gui

		window.edtWidth := 250
		window.SetFont('s10')
		window.AddEdit('vQuery w' window.edtWidth)
		window.AddButton('vSearch x+m w75 default ', 'Search').OnEvent('Click', (*)=> main.Search())
		window.AddButton('x+m w75', 'Advanced').OnEvent('Click', (*)=> main.ShowAdvanced())

		window.AddText('xm Section', 'Video Results')
		headers := [
			'Channel',
			'#Views',
			'#Likes',
			'#Comm',
			'Count',
			'Date',
			'Title',
			'Tags',
			'Subtitles',
			'Video ID'
		]
		window.lvWidth := 800
		window.lvLimited := window.lvWidth / 2
		window.SetFont('s10', 'Courier New')
		global lvVideos := window.AddListView('xm w' window.lvWidth ' h450', headers)
		main.FixWidth(lvVideos)
		window.SetFont('s10')

		window.AddText('ys', 'Links in Description')
		global lvLinks := window.AddListView('-Hdr w' window.lvLimited ' r5', ['URL'])
		lvLinks.OnEvent('DoubleClick', (*)=> Run(lvLinks.GetText(lvLinks.GetNext(0, 'F'))))

		window.AddText('', 'Description')
		global highlighted_description := RichEdit(main, 'w' window.lvLimited ' h315')
		highlighted_description.WordWrap(true)
		

		lvVideos.OnEvent('ItemSelect', (*)=> main.GetData())
		lvVideos.OnEvent('DoubleClick', (obj, row)=> main.OpenVideo(obj, row))

		window.AddText('xm Section','Subtitle Results')
		headers := ['Timestamp', 'Count', 'Subtitle Preview']

		window.SetFont('s10', 'Courier New')

		global lvSubtitles := window.AddListView('w' window.lvWidth ' h300', headers)
		window.SetFont('s10')

		window.AddText('ys Section','Full Subtitles')
		global highlighted_subtitles := RichEdit(main, 'y+m w' window.lvLimited ' h300')
		highlighted_subtitles.WordWrap(true)

		main.FixWidth(lvSubtitles)

		lvSubtitles.OnEvent('ItemSelect', (obj, row, selected)=> main.SetSubtitlesResult(obj, row))
		lvSubtitles.OnEvent('DoubleClick', (obj, row)=> main.OpenVideo(obj, row))

		global sb := window.AddStatusBar()
		sb.SetParts(160)

		sb.SetText(' 0 videos found')
		sb.SetText(' 0 subtitles', 2)
	}

	static Search() => SubtitlesSearch.Search(main)
	static GetData() => SubtitlesSearch.GetData()
	static ShowAdvanced() => advanced.Show()
	static OpenVideo(obj, row)
	{
		videoId := ListViewGetContent('Focused col10', lvVideos)

		if obj = lvSubtitles
			timestamp := ListViewGetContent('Focused col1', lvSubtitles)
		else
			timestamp := 0

		Run url := 'https://www.youtube.com/watch?v=' videoId '&t=' TimestampToSeconds(timestamp)
		return

		TimestampToSeconds(timestamp)
		{
			timestamp := StrSplit(timestamp, ':')

			switch timestamp.Length
			{
			case 2:
				return timestamp[1]*60 + timestamp[2] - 3
			case 3:
				return timestamp[1]*3600 + timestamp[2]*60 + timestamp[3] - 3
			}
		}
	}
	static FixWidth(lv)
	{
		loop lv.GetCount('col')
		{
			switch lv
			{
			case lvVideos:
				switch A_Index
				{
				case 7: lv.ModifyCol(A_Index, 425)
				case 8,9,10: lv.ModifyCol(A_Index, 0)
				default: lv.ModifyCol(A_Index, 'AutoHDR')
				}

				loop 4
					lv.ModifyCol(A_Index+1, 'Integer')
			case lvSubtitles:
				switch A_Index
				{
				case 3: lv.ModifyCol(A_Index, 625)
				default: lv.ModifyCol(A_Index, 'AutoHDR')
				}
				lv.ModifyCol(2, 'Integer')
			}
		}
	}
	static SetSubtitlesResult(obj, row)
	{
		query := main['Query'].Text
		subtitle := ListViewGetContent('Focused col3', lvSubtitles)
		subtitle := RegExReplace(subtitle, 'i)(\Q' query '\E)', '\b\chcbpat1 $1\b0\chcbpat0 ')
		highlighted_subtitles.SetText('{\rtf1{\colortbl`s;\red10\green210\blue10;}' subtitle '}')
	}

	static __Call(name, params) => main.gui.%name%(params*)
	static __Item[name]
	{
		get => main.gui[name]
		set => main.gui[name] := value
	}
}