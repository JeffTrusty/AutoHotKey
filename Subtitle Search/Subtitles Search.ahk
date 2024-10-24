#SingleInstance
#Requires Autohotkey v2.0+
;--
;@Ahk2Exe-SetVersion     0.0.0
;@Ahk2Exe-SetMainIcon    res\main.ico
;@Ahk2Exe-SetProductName
;@Ahk2Exe-SetDescription
/**
 * ============================================================================ *
 * @Author   : RaptorX                                                          *
 * @Homepage :                                                                  *
 *                                                                              *
 * @Created  : Thursday, January 11, 2024                                       *
 * @Modified : Thursday, January 11, 2024                                       *
 * ============================================================================ *
 */

#Include <classes\main>
#Include <classes\advanced>
#Include <classes\RichEdit>
#Include <ext\SQLite\SQLite>

class SubtitlesSearch {
	static db := SQLite('Youtube.db')
	static subtitle_regex := '\((?<timestamp>.*?)\)(?<text>.*?)(\s{2}|$)'

	static __New() => main.Show()

	static Search(class)
	{
		static db := SubtitlesSearch.db
		static sql_template :=
		(
			'SELECT [Publish date],
			        [Title],
			        [Description],
			        [Tags],
			        [Subtitles],
			        [Video ID],
			        SUM( (LENGTH([Subtitles]) - LENGTH(REPLACE([Subtitles], "{1}", "") ) ) /LENGTH("{1}") ) AS [occurrences],
			        viewCount,
			        likeCount,
			        commentCount
			FROM [subtitles]
			WHERE ([Title] LIKE "%{1}%" OR
			       [Description] LIKE "%{1}%" OR
			       [Tags] LIKE "%{1}%" OR
			       [Subtitles] LIKE "%{1}%") {2}
			GROUP BY "Video ID"
			UNION
			SELECT [Publish date],
			       [Title],
			       [Description],
			       [Tags],
			       [Subtitles],
			       [Video ID],
			       SUM( (LENGTH([Subtitles]) - LENGTH(REPLACE([Subtitles], "{1}", "") ) ) /LENGTH("{1}") ),
			        viewCount,
			        likeCount,
			        commentCount
			FROM [subtitles]
			WHERE "Video ID"=[Video ID] AND
			       (([Title] LIKE "%{1}%" OR
			       [Description] LIKE "%{1}%" OR
			       [Tags] LIKE "%{1}%" OR
			       [Subtitles] LIKE "%{1}%") {2})
			GROUP BY "Video ID"
			ORDER BY [Publish date] DESC;'
		)
		static date_template := '`nAND [Publish date] BETWEEN "{1}" AND "{2}"'

		query := main['Query'].value
		switch class
		{
		case main:
			SQL := Format(sql_template, query)
			SQL := StrReplace(SQL, '{2}')
		case advanced:
			from := FormatTime(advanced['From'].value, 'yyyy-MM-dd')
			to   := FormatTime(advanced['To'].value, 'yyyy-MM-dd')
			dateFilter := Format(date_template, from, to)
			SQL := Format(sql_template, query, dateFilter)
			advanced.Hide()
			for checkbox in advanced.checkboxes
			{
				if !advanced[checkbox].value
					SQL := RegexReplace(SQL, 'i)\Q[' advanced[checkbox].name '] LIKE "%' query '%"\E(\sOR\n)?')
			}

			fixes := Map(
				'\sOR\s*\)', ')',
				'WHERE \(\s+\)\s*AND\s+', 'WHERE ',
				'WHERE.*\R.*\(\(\s+\)\s+AND\s', 'WHERE "Video ID"=[Video ID] AND (',
			)
			for fix, replace in fixes
				SQL := RegExReplace(SQL, fix, replace)
		default: return
		}

		table := db.Exec(SQL)

		if db.status != SQLITE_OK
			return MsgBox(db.error, 'SQL Error', 'Iconx')

		for lv in [lvVideos, lvSubtitles]
		{
			lv.Opt('-Redraw')
			lv.Delete()
		}

		for row in table.rows
		{

			if (advanced['Title'].value       && row.Title       ~= 'i)\Q' query '\E' = false)
			&& (advanced['Description'].value && row.Description ~= 'i)\Q' query '\E' = false)
			&& (advanced['Tags'].value        && row.Tags        ~= 'i)\Q' query '\E' = false)
			&& (advanced['Subtitles'].value   && row.Subtitles   ~= 'i)\Q' query '\E' = false)
				continue

			lvVideos.Add('',
				'the-Automator.com', 
				row.viewCount,
				row.likeCount,
				row.commentCount,
				row.occurrences,
				row.%'Publish date'%,
				row.Title,
				row.Tags,
				row.Subtitles,
				row.%'Video ID'%,
			)
		}

		for lv in [lvVideos, lvSubtitles]
		{
			main.FixWidth(lv)
			lv.Opt('+Redraw')
		}

		sb.SetText(' ' lvVideos.GetCount() ' videos found')
	}

	static GetData()
	{
		static db := SubtitlesSearch.db
		static sql_template :=
		(
			'SELECT [Subtitles],[Description]
			FROM [subtitles]
			WHERE [Video ID] = "{1}";'
		)

		highlighted_description.SetText('')
		highlighted_subtitles.SetText('')

		row := lvVideos.GetNext(0, 'F')
		video_id := lvVideos.GetText(row, 10)

		table := db.Exec(Format(sql_template, video_id))
		if db.status != SQLITE_OK
			return MsgBox(db.error, 'SQL Error', 'Iconx')

		SubtitlesSearch.HandleDescription(table[1, 'description'])
		highlighted_subtitles.SetText('')

		lvSubtitles.Delete()
		lvSubtitles.Opt('-Redraw')
		pos := 0
		while pos := RegExMatch(table[1, 'subtitles'], SubtitlesSearch.subtitle_regex, &match, pos ? pos+1 : 1)
		{
			RegExReplace(match.Text, 'i)\Q' main['Query'].value '\E', '', &count)

			if  !count
				continue

			lvSubtitles.Add('', match.timestamp, count, match.text)
		}

		if !lvSubtitles.GetCount()
			lvSubtitles.Add('', '00:00', 0, 'None Found, double click to open video.')

		main.FixWidth(lvSubtitles)
		lvSubtitles.Opt('+Redraw')

		sb.SetText(' ' lvSubtitles.GetCount() ' subtitles', 2)
	}

	static HandleDescription(description)
	{
		lvLinks.Delete()
		lvLinks.Opt('-Redraw')
		query := main['Query'].Text
		links := ParseLinks(description)

		for link in links
		{
			lvLinks.Add('', link)
			description := RegExReplace(description, link, AddBold(link))
		}
		lvLinks.Opt('+Redraw')
		description := RegExReplace(description, 'i)(\Q' query '\E)', '\b\chcbpat1 $1\b0\chcbpat0 ')
		highlighted_description.SetText('{\rtf1{\colortbl`s;\red10\green210\blue10;}' description '}')
		return

		ParseLinks(text)
		{
			local links := []

			pos := 0
			while pos := RegExMatch(text, 'i)(?<url>https?:\/\/\S+)', &match, pos ? pos+1 : 1)
				links.Push(match.url)
			
			return links
		}

		ConvertToRTF(text) => Format('{\field{\*\fldinst{HYPERLINK "{1}"}}{\fldrslt{{1}}}}', text)
		AddBold(text) => Format('\b {1}\b0', text)
	}
}