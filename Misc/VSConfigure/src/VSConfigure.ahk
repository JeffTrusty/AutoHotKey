#SingleInstance
#Requires Autohotkey v2.0+
;--
;@Ahk2Exe-SetVersion     0.1.0
;@Ahk2Exe-SetMainIcon    res\visual-studio.ico ; https://www.flaticon.com/free-icons/microsoft
;@Ahk2Exe-SetProductName VSConfigure
;@Ahk2Exe-SetDescription Automatically configure vscode for use with ahk v2
/**
 * ============================================================================ *
 * @Author   : RaptorX                                                          *
 * @Homepage :                                                                  *
 *                                                                              *
 * @Created  : February 04, 2023                                                *
 * @Modified : February 09, 2023                                                *
 * ============================================================================ *
 * License:                                                                     *
 * Copyright ©2023 <GPLv3>                                                      *
 *                                                                              *
 * This program is free software: you can redistribute it and/or modify         *
 * it under the terms of the **GNU General Public License** as published by     *
 * the Free Software Foundation, either version 3 of the License, or            *
 * (at your option) any later version.                                          *
 *                                                                              *
 * This program is distributed in the hope that it will be useful,              *
 * but **WITHOUT ANY WARRANTY**; without even the implied warranty of           *
 * **MERCHANTABILITY** or **FITNESS FOR A PARTICULAR PURPOSE**.  See the        *
 * **GNU General Public License** for more details.                             *
 *                                                                              *
 * You should have received a copy of the **GNU General Public License**        *
 * along with this program. If not, see:                                        *
 * <http://www.gnu.org/licenses/gpl-3.0.txt>                                    *
 * ============================================================================ *
 */

settings :=
(
	'"AutoHotkey2.AutoLibInclude": "Local",
	"AutoHotkey2.SymbolFoldingFromOpenBrace": true,
	"terminal.integrated.defaultProfile.windows": "Git Bash",
	"files.eol": "\n",
	"editor.unfoldOnClickAfterEndOfLine": true,
	"editor.rulers": [
		{"color": "#00c732","column": 80},
		{"color": "#e0a500","column": 120},
		{"color": "#ff0000","column": 160},
	],
	"workbench.iconTheme": "vscode-icons",
	"editor.insertSpaces": false,
	"editor.autoIndent": "brackets",
	"editor.mouseWheelZoom": true,
	"editor.wordWrap": "on",
	"[ahk]": {
		"files.encoding": "utf8bom"
	},
	"[ahk2]": {
		"files.encoding": "utf8bom"
	},
	"AutoHotkey2.FormatOptions": {
		"one_true_brace": "0",
		"preserve_newlines": true
	},
	"files.associations": {
		"*.ahk": "ahk2"
	},
	"editor.renderLineHighlight": "all",
	"editor.renderLineHighlightOnlyWhenFocus": true,
	"insertnum.formatstr": "%d",
	"insertnum.start": 1,
	"insertnum.step": 1,
	"AutoHotkey2.ActionWhenV1IsDetected": "SwitchToV1",
	"color-highlight.markerType": "foreground",
	"color-highlight.markRuler": false,
	"color-highlight.matchRgbWithNoFunction": true,
	"color-highlight.matchWords": true,
	"editor.suggest.localityBonus": true,
	"indentRainbow.colorOnWhiteSpaceOnly": true'
)

#Include <AdPop\ShowPopUp>

#Include <gui\actions>
#Include <gui\extensions>

actions.Show()
return