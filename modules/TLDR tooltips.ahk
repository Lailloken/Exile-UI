Init_TLDR()
{
	local
	global vars, settings, db, Json

	If vars.poe_version
		Return

	If !FileExist("ini" vars.poe_version "\TLDR.ini")
		IniWrite, % "", % "ini" vars.poe_version "\TLDR.ini", settings
	If !FileExist("ini" vars.poe_version "\TLDR - altars.ini")
		IniWrite, % "", % "ini" vars.poe_version "\TLDR - altars.ini", settings
	If !FileExist("ini" vars.poe_version "\TLDR - vaal areas.ini")
		IniWrite, % "", % "ini" vars.poe_version "\TLDR - vaal areas.ini", settings

	ini := IniBatchRead("ini" vars.poe_version "\TLDR.ini"), settings.TLDR := {"profile": 1, "highlighting": {}} ;in case profiles are desired in the future
	settings.TLDR.hotkey := !Blank(check := ini.settings["hotkey"]) ? check : ""
	settings.TLDR.z_hotkey := !Blank(check := ini.settings["toggle highlighting hotkey"]) ? check : ""

	For key, val in {"hotkey": "hotkey", "z_hotkey": "toggle highlighting hotkey"}
	{
		If Blank(settings.TLDR[key "_single"] := settings.TLDR[key])
			Continue
		If (StrLen(settings.TLDR[key]) > 1)
			Loop, Parse, % "+!^#"
				settings.TLDR[key "_single"] := StrReplace(settings.TLDR[key "_single"], A_LoopField)
		If !GetKeyVK(settings.TLDR[key "_single"])
			IniWrite, % """" (settings.TLDR[key] := "") """", % "ini" vars.poe_version "\TLDR.ini", settings, % val
	}

	settings.TLDR.hotkey_block := !Blank(check := ini.settings["block native key-function"]) ? check : 0
	settings.TLDR.hotkey_shared := !Blank(check := ini.settings["shared hotkeys"]) ? check : (!Blank(settings.TLDR.hotkey) ? 0 : 1)
	settings.TLDR.debug := !Blank(check := ini.settings["enable debug"]) ? check : 0
	settings.TLDR.fSize := !Blank(check := ini.settings["font-size"]) ? check : settings.general.fSize
	LLK_FontDimensions(settings.TLDR.fSize, font_height, font_width), settings.TLDR.fHeight := font_height, settings.TLDR.fWidth := font_width
	settings.TLDR.dColors := [["00FF00", "00000"], ["FF8000", "00000"], ["FF0000", "00000"], ["FF00FF", "00000"], ["FF0000", "FFFFFF"]], settings.TLDR.dColors.0 := ["FFFFFF", "000000"]
	settings.TLDR.colors := []
	For index, color in settings.TLDR.dColors
		If !Blank(check := ini.UI["pattern " index])
			settings.TLDR.colors[index] := StrSplit(check, ",")
		Else settings.TLDR.colors[index] := color.Clone()

	settings.features.TLDR := settings.features.TLDR * (vars.client.h > 720 ? 1 : 0), shared := settings.TLDR.hotkey_shared
	If settings.features.TLDR && (shared && !Blank(settings.TLDR.z_hotkey) || !shared && !Blank(settings.TLDR.hotkey))
	{
		Hotkey, If, WinActive("ahk_id " vars.hwnd.poe_client) || WinActive("ahk_id " vars.hwnd.TLDR.main)
		Hotkey, % "*" (!shared && settings.TLDR.hotkey_block ? "" : "~") . Hotkeys_Convert(settings.TLDR[shared ? "z_hotkey" : "hotkey"]), TLDR_Hotkey
	}
}

TLDR(mode := "GUI")
{
	local
	global vars, settings

	If !IsObject(vars.TLDR)
		vars.TLDR := {"wGUI": vars.client.h // 2.5, "hGUI": vars.client.h // 4.8}

	If vars.TLDR.in_progress
		Return
	vars.TLDR.in_progress := 1

	If (mode = "GUI")
	{
		vars.TLDR.GUI := 1, square := vars.client.h / 10, square1 := vars.client.h / 20
		Gui, TLDR_GUI: New, -Caption -DPIScale +LastFound +AlwaysOnTop +ToolWindow +E0x02000000 +E0x00080000 HWNDTLDR_GUI
		Gui, TLDR_GUI: Color, Gray
		WinSet, TransColor, Gray 75

		Gui, TLDR_GUI2: New, -Caption -DPIScale +LastFound +AlwaysOnTop +ToolWindow +E0x02000000 +E0x00080000 HWNDTLDR_GUI2 +OwnerTLDR_GUI
		Gui, TLDR_GUI2: Margin, 0, 0
		Gui, TLDR_GUI2: Color, Gray
		WinSet, TransColor, Gray 75

		Loop
		{
			If (A_Index = 10)
			{
				Gui, TLDR_GUI: Color, White
				Gui, TLDR_GUI2: Color, White
			}
			MouseGetPos, xMouse, yMouse
			wGUI := vars.TLDR.wGUI, hGUI := vars.TLDR.hGUI
			xPos := (xMouse - wGUI < vars.client.x) ? vars.client.x : (xMouse + wGUI >= vars.client.x + vars.client.w) ? vars.client.x + vars.client.w - wGUI * 2 : xMouse - wGUI
			yPos := (yMouse - hGUI < vars.client.y) ? vars.client.y : (yMouse + hGUI >= vars.client.y + vars.client.h) ? vars.client.y + vars.client.h - hGUI * 2 : yMouse - hGUI
			xPos2 := (xMouse - square1 < vars.client.x) ? vars.client.x : (xMouse + square1 >= vars.client.x + vars.client.w) ? vars.client.x + vars.client.w - square : xMouse - square1
			yPos2 := (yMouse - square1 < vars.client.y) ? vars.client.y : (yMouse + square1 >= vars.client.y + vars.client.h) ? vars.client.y + vars.client.h - square : yMouse - square1
			Gui, TLDR_GUI: Show, % "NA x" xPos " y" yPos " w" wGUI * 2 " h" hGUI * 2
			Gui, TLDR_GUI2: Show, % "NA x" xPos2 " y" yPos2 " w" square " h" square

			If !GetKeyState(settings.TLDR.hotkey_single, "P") && !(settings.TLDR.hotkey_shared && GetKeyState(settings.TLDR.z_hotkey_single, "P"))
			{
				WinGetPos, xWin, yWin,,, ahk_id %TLDR_GUI%
				vars.TLDR.coords := {"xMouse": xMouse, "yMouse": yMouse, "hPanel": 0}
				If Blank(xWin) || Blank(yWin)
					Continue
				Gui, TLDR_GUI: Destroy
				While WinExist("ahk_id " TLDR_GUI)
					Sleep 100
				xCap := xWin - vars.client.x, yCap := yWin - vars.client.y, wCap := 2*wGUI, hCap := 2*hGUI
				vars.TLDR.GUI := 0
				Break
			}
			Sleep 20
		}
	}

	debug := (settings.TLDR.debug && GetKeyState("ALT", "P"))
	text := OCR_Start(xCap, yCap, wCap, hCap, (settings.TLDR.debug ? "ALT" : ""), "TLDR",, [[5, 0, 35, 0]])
	vars.TLDR.in_progress := 0
	;pEffect := Gdip_CreateEffect(2, 0, 100), Gdip_BitmapApplyEffect(pBitmap, pEffect), Gdip_DisposeEffect(pEffect)

	If Blank(text)
	{
		TLDR_Error((debug ? Lang_Trans("ocr_debug") : Lang_Trans("ocr_notext")) "`n" Lang_Trans("ocr_closetooltip"))
		Return
	}
	Else
	{
		vars.TLDR.text := text
		If InStr(text, Lang_Trans("items_mapquantity"))
			TLDR_VaalAreas()
		Else If InStr(text, ":",,, 2)
			TLDR_Altars()
		Else TLDR_Error(Lang_Trans("ocr_nousecase") "`n" Lang_Trans("ocr_closetooltip"))
	}
}

TLDR_Altars()
{
	local
	global db, vars, settings
	static toggle := 0

	vars.TLDR.toggle := toggle := !toggle, GUI_name := "TLDR_tooltip" toggle
	Gui, %GUI_name%: New, -Caption -DPIScale +LastFound +AlwaysOnTop +ToolWindow +E0x02000000 +E0x00080000 HWNDhwnd_altars
	Gui, %GUI_name%: Color, Purple
	WinSet, TransColor, Purple
	Gui, %GUI_name%: Margin, 0, 0
	Gui, %GUI_name%: Font, % "s" settings.TLDR.fSize " cWhite", % vars.system.font
	hwnd_old := vars.hwnd.TLDR.main, vars.hwnd.TLDR := {"main": hwnd_altars, "type": "altars"}, panels := [[], []], header := 0, parsed_text := [[], []], header_check := ["boss", "minions", "player"]
	header_dictionary := ["map", "boss", "gains", "eldritch", "minions", "gain", "player"], header_lookup := ["map boss gains:", "eldritch minions gain:", "player gains:"]
	text := vars.TLDR.text, square1 := vars.client.h / 20

	If !IsObject(db.altars)
		DB_Load("TLDR")

	Loop, Parse, text, `n, % "`r`t" A_Space
	{
		loopfield_copy := ""
		Loop, Parse, A_LoopField
			If LLK_IsType(A_LoopField, "alpha")
				loopfield_copy .= A_LoopField
		If Blank(loopfield_copy)
			Continue
		While InStr(loopfield_copy, "  ")
			loopfield_copy := StrReplace(loopfield_copy, "  ", " ")
		While (SubStr(loopfield_copy, 1, 1) = " ")
			loopfield_copy := SubStr(loopfield_copy, 2)
		While (SubStr(loopfield_copy, 0) = " ")
			loopfield_copy := SubStr(loopfield_copy, 1, -1)

		If (SubStr(A_LoopField, 0) = ":")
		{
			regex := regex_all := "", regex_array := StrSplit(loopfield_copy, A_Space), regex_array_copy := regex_array.Clone()
			For index, val in regex_array
				If !LLK_HasVal(header_dictionary, val)
					regex_array_copy[index] := ""
				Else regex .= (!regex ? "" : ".*") val

			regex_results := LLK_HasRegex(header_lookup, regex, 1)
			If (regex_results.Count() > 1)
			{
				regex := ""
				For index, key in regex_array_copy
				{
					If Blank(key)
					{
						blank_regex := ""
						Loop, Parse, % regex_array[index]
						{
							If LLK_HasRegex(header_lookup, TLDR_RegexCheck(regex_array_copy, index, blank_regex . A_LoopField), 1)
								blank_regex .= A_LoopField
							Else blank_regex .= (SubStr(blank_regex, -1) = ".*") ? "" : ".*"
						}
						If (blank_regex != ".*")
							regex .= (!regex || SubStr(regex, -1) = ".*" ? "" : ".*") regex_array_copy[index] := blank_regex
					}
				}
				regex_results := LLK_HasRegex(header_lookup, regex, 1)
			}
			If (regex_results.Count() = 1) && (key != header_check[regex_results.1])
				key := header_check[regex_results.1], header += 1, parsed_text[header].Push(key ":")
		}
		Else If key
		{
			line := ""
			Loop, Parse, A_LoopField
				If LLK_IsType(A_LoopField, "alpha") || InStr("-',", A_LoopField)
					line .= A_LoopField
			While InStr(line, "  ")
				line := StrReplace(line, "  ", " ")
			While (SubStr(line, 1, 1) = " ")
				line := SubStr(line, 2)
			While (SubStr(line, 0) = " ")
				line := SubStr(line, 1, -1)
			parsed_text[header].Push(line)
		}
	}

	For index0, array in parsed_text
	{
		parsed_mods := []
		For index, line in array
		{
			If (index = 1)
			{
				key := StrReplace(line, ":"), panels[index0].Push(line), mod_lookup := db.altars[key "_check"]
				Continue
			}
			If (LLK_InStrCount(line, " ") < 2) && !InStr(line, "armour")
				Continue
			check := LLK_HasVal(mod_lookup, line)
			If check
			{
				If !LLK_HasVal(parsed_mods, line)
					parsed_mods.Push(line)
				Continue
			}

			regex := "i)", regex_array := StrSplit(line, A_Space), regex_array_copy := regex_array.Clone(), regex_all := "i)"
			For iRegex, vRegex in regex_array
			{
				If !LLK_HasVal(db.altar_dictionary, vRegex)
					regex_array_copy[iRegex] := 0
				Else regex .= (regex = "i)") ? vRegex : ".*" vRegex
			}

			If (LLK_HasRegex(mod_lookup, regex, 1).Count() = 1)
				regex_all := regex
			Else If (LLK_HasVal(regex_array_copy, 0,,, 1).Count() < regex_array_copy.Count()//2)
			{
				For iRegex, vRegex in regex_array_copy
				{
					If !vRegex
					{
						blank_regex := ""
						Loop, Parse, % regex_array[iRegex]
						{
							If LLK_HasRegex(mod_lookup, TLDR_RegexCheck(regex_array_copy, iRegex, blank_regex . A_LoopField), 1)
								blank_regex .= A_LoopField
							Else blank_regex .= (SubStr(blank_regex, -1) = ".*") ? "" : ".*"
						}
						regex_array_copy[iRegex] := (blank_regex = ".*") ? "" : blank_regex
					}
				}

				For iRegex, vRegex in regex_array_copy
					If vRegex
						regex_all .= (regex_all = "i)" ? "" : ".*") vRegex
			}
			If (regex_all != "i)") && (regex_result := LLK_HasRegex(mod_lookup, regex_all, 1))
				parsed_mods.Push(regex_result.Count() > 1 ? "???" : mod_lookup[regex_result.1])
		}

		skip := 0
		For index, mod in parsed_mods
		{
			If skip
			{
				skip := 0
				Continue
			}
			prev_line := parsed_mods[index - 1], next_line := parsed_mods[index + 1], push := ""
			If next_line && (check := LLK_HasVal(db.altars[key], mod "`r`n" next_line, 1,, 1, 1)) && (check.Count() = 1)
			|| prev_line && (check := LLK_HasVal(db.altars[key], prev_line "`r`n" mod, 1,, 1, 1)) && (check.Count() = 1)
			|| (check := LLK_HasVal(db.altars[key], mod "`r`n", 1,, 1, 1)) && (check.Count() = 1) || (check := LLK_HasVal(db.altars[key], "`r`n" mod, 1,, 1, 1)) && (check.Count() = 1)
				push := db.altars[key][check.1].2
			Else If (check := LLK_HasVal(db.altars[key], mod "`r`n", 1,, 1, 1)) && InStr(next_line, "?")
				push := mod " | ???", skip := 1
			Else If (check := LLK_HasVal(db.altars[key], mod,,,, 1))
				push := db.altars[key][check].2
			Else If InStr(mod, "?") && next_line && (check := LLK_HasVal(db.altars[key], "`r`n" next_line, 1,, 1, 1))
				push := (check.Count() != 1) ? "??? | " next_line : db.altars[key][check.1].2, skip := 1
			Else push := "???"

			If push && (!LLK_HasVal(panels[index0], push) || InStr(push, "?"))
				panels[index0].Push(push)
		}
	}

	If (panels.1.Count() < 3) || (panels.2.Count() < 3) || !LLK_HasVal(panels, ":", 1,,, 1)
		TLDR_Error(Lang_Trans("ocr_erroraltar"))
	Else
	{
		LLK_PanelDimensions(panels.1, settings.TLDR.fSize, w1, h1), LLK_PanelDimensions(panels.2, settings.TLDR.fSize, w2, h2)
		If !IsObject(settings.TLDR.highlighting.altars)
		{
			settings.TLDR.highlighting.altars := {"boss": {}, "minions": {}, "player": {}}, profile := settings.TLDR.profile
			ini := IniBatchRead("ini\TLDR - altars.ini")
			For index, val in ["boss", "minions", "player"]
				If ini["profile " profile " " val].Count()
					settings.TLDR.highlighting.altars[val] := ini["profile " profile " " val].Clone()
		}
		width := Max(w1, w2)
		For index, array in panels
			For index1, panel_text in array
			{
				If (index = 2 && index1 = 1)
					vars.TLDR.coords.hPanel := yControl + hControl
				If (index1 = 1)
					key := StrReplace(panel_text, ":")
				rank := !Blank(check := settings.TLDR.highlighting.altars[key][panel_text]) ? check : 0
				colors := (index1 = 1) ? ["FFFFFF", "000000"] : settings.TLDR.colors[rank].Clone()
				Gui, %GUI_name%: Add, Text, % (index = 2 && index1 = 1 ? "y+" vars.client.h / 10 : (index = 1 && index1 = 1) ? "" : "y+-1") " xs Section Center Border BackgroundTrans HWNDhwnd0 w" width " c" colors.1, % StrReplace(panel_text, "&", "&&")
				Gui, %GUI_name%: Add, Progress, % "xp yp wp hp Border HWNDhwnd BackgroundBlack c" colors.2, 100
				ControlGetPos,, yControl, wControl, hControl,, ahk_id %hwnd%
				If (index1 != 1) && !InStr(panel_text, "?")
					vars.hwnd.TLDR[key "_" panel_text] := hwnd, vars.hwnd.TLDR[key "_" panel_text "_text"] := hwnd0
			}

		Gui, %GUI_name%: Show, NA x10000 y10000
		WinGetPos,,, wWin, hWin, ahk_id %hwnd_altars%
		xPos := vars.TLDR.coords.xMouse - wWin / 2, yPos := vars.TLDR.coords.yMouse - vars.TLDR.coords.hPanel - square1
		xPos := (xPos < vars.client.x) ? vars.client.x : (xPos + wWin >= vars.client.x + vars.client.w) ? vars.client.x + vars.client.w - wWin : xPos
		yPos := (yPos < vars.client.y) ? vars.client.y : (yPos + hWin >= vars.client.y + vars.client.h) ? vars.client.y + vars.client.h - hWin : yPos
		Gui, %GUI_name%: Show, % "NA x" xPos " y" yPos
		LLK_Overlay(hwnd_altars, "show",, GUI_name), LLK_Overlay(hwnd_old, "destroy"), vars.TLDR.last := "_altars"
	}
}

TLDR_Close(mode := "")
{
	local
	global vars, settings

	If !WinActive("ahk_id " vars.hwnd.poe_client)
	{
		WinActivate, % "ahk_id " vars.hwnd.poe_client
		WinWaitActive, % "ahk_id " vars.hwnd.poe_client
	}
	If (mode = "ESC") || !settings.TLDR.hotkey_shared
		SendInput, % "{" settings.TLDR.z_hotkey "}"
	LLK_Overlay(vars.hwnd.TLDR.main, "destroy"), vars.hwnd.TLDR.main := ""
}

TLDR_Error(error)
{
	local
	global vars, settings

	Gui, TLDR_tooltip: New, -Caption -DPIScale +LastFound +AlwaysOnTop +ToolWindow +E0x02000000 +E0x00080000 HWNDhwnd_altars
	Gui, TLDR_tooltip: Color, Black
	Gui, TLDR_tooltip: Margin, 0, 0
	Gui, TLDR_tooltip: Font, % "s" settings.TLDR.fSize * 1.5 " cRed", % vars.system.font
	Gui, TLDR_tooltip: Add, Text, % "Center Border", % " " error " "
	vars.hwnd.TLDR := {"main": hwnd_altars}

	Gui, TLDR_tooltip: Show, NA x10000 y10000
	WinGetPos, xWin, yWin, wWin, hWin, % "ahk_id " hwnd_altars
	xPos := vars.TLDR.coords.xMouse - wWin / 2, yPos := vars.TLDR.coords.yMouse - hWin
	xPos := (xPos < vars.client.x) ? vars.client.x : (xPos + wWin >= vars.client.x + vars.client.w) ? vars.client.x + vars.client.w - wWin : xPos
	yPos := (yPos < vars.client.y) ? vars.client.y : (yPos + hWin >= vars.client.y + vars.client.h) ? vars.client.y + vars.client.h - hWin : yPos
	Gui, TLDR_tooltip: Show, % "NA x" xPos " y" yPos
	LLK_Overlay(hwnd_altars, "show",, "TLDR_tooltip")
}

TLDR_FilterInput(text) ;WIP, currently not in use
{
	local
	global vars, settings, db

	parsed := []
	Loop, Parse, text, `n, "`r`t" A_Space
	{
		loopfield_copy := ""
		Loop, Parse, A_LoopField
			If LLK_IsType(A_LoopField, "alnum")
				loopfield_copy .= A_LoopField
		loopfield_copy := InStr(loopfield_copy, ":") ? SubStr(loopfield_copy, 1, InStr(loopfield_copy, ":") - 1) : loopfield_copy
		If !InStr(loopfield_copy, ":") && !InStr(loopfield_copy, " ",,, 2)
			Continue
		parsed.Push(loopfield_copy)
	}

	lookup := {"altars": ["map boss gains:", "eldritch minions gain:", "player gains:"], "vaalareas": [Lang_Trans("items_mapquantity")]}
	dictionary := {"altars": ["map", "boss", "gains", "eldritch", "minions", "gain", "player"], "vaalareas": []}
	Loop, Parse, % Lang_Trans("items_mapquantity"), % A_Space, % ":"
		dictionary.vaalareas.Push(A_LoopField)
	For index, text in parsed
	{
		text := "mep boss gains:"
		If (SubStr(text, 0) != ":") || usecase || (usecase := LLK_HasVal(lookup, text,,,, 1))
			Continue
		Else
		{
			regex := "i)", results := 0, regex_array := StrSplit(text, A_Space, ":"), regex_array_copy := regex_array.Clone()
			For index, word in regex_array
				If !LLK_HasVal(dictionary, word,,,, 1)
					regex_array_copy[index] := 0
				Else regex .= (InStr(".*i)", SubStr(regex, -1)) ? "" : ".*") word

			For k, array in lookup
				results += (check := LLK_HasRegex(array, regex, 1).Count()) ? check : 0, usecase0 := check ? k : usecase0
			If (results = 1)
			{
				usecase := usecase0
				Break
			}
		}
	}
	MsgBox, % usecase
}

TLDR_Highlight(hotkey)
{
	local
	global vars, settings

	If !vars.general.cMouse || Blank(LLK_HasVal(vars.hwnd.TLDR, vars.general.cMouse))
		Return

	hotkey0 := Hotkeys_RemoveModifiers(A_ThisHotkey)
	hotkey := (hotkey = "space") ? 0 : hotkey
	cHWND := vars.general.cMouse, check := LLK_HasVal(vars.hwnd.TLDR, vars.general.cMouse), category := StrReplace(SubStr(check, 1, InStr(check, "_") - 1), ":")
	mod := (vars.hwnd.TLDR.type = "altars") ? SubStr(check, InStr(check, "_") + 1) : check, text_cHWND := vars.hwnd.TLDR[check "_text"]
	GuiControl, % "+c" settings.TLDR.colors[hotkey].2, % cHWND
	GuiControl, movedraw, % cHWND
	GuiControl, % "+c" settings.TLDR.colors[hotkey].1, % text_cHWND
	GuiControl, movedraw, % text_cHWND

	If (type := vars.hwnd.TLDR.type)
	{
		IniWrite, % hotkey, % "ini\TLDR - " type ".ini", % "profile " settings.TLDR.profile (type = "altars" ? " " category : ""), % mod
		If (type = "altars")
			settings.TLDR.highlighting.altars[category][mod] := hotkey
		Else settings.TLDR.highlighting["vaal areas"][mod] := hotkey
	}
	KeyWait, % hotkey0
}

TLDR_Hotkey()
{
	local
	global vars, settings

	If vars.hwnd.TLDR.main && WinExist("ahk_id " vars.hwnd.TLDR.main)
		TLDR_Close(), close := 1
	Else If settings.TLDR.hotkey_shared
	{
		KeyWait, % settings.TLDR.z_hotkey_single, T0.15
		longpress := ErrorLevel
	}
	Else SendInput, % "{" settings.TLDR.z_hotkey "}"

	If !close && (longpress || !settings.TLDR.hotkey_shared)
		TLDR()
	KeyWait, % settings.TLDR.hotkey_single
	KeyWait, % settings.TLDR.z_hotkey_single
}

TLDR_RegexCheck(array, insert_index, insert_val, newline := 0) ;takes an array with blanks derived from an ambiguous regex match, inserts a new value into a chosen blank, and returns the new regex string
{
	local

	If !IsObject(array) || Blank(insert_index) || Blank(insert_val) && insert_index
		Return 0
	array[insert_index] := insert_val
	For index, val in array
		If !Blank(val)
			regex .= (!regex ? "i" (!newline ? "m" : "") ")" : ".*") val
	Return regex
}

TLDR_VaalAreas()
{
	local
	global db, vars, settings
	static toggle := 0

	vars.TLDR.toggle := toggle := !toggle, GUI_name := "TLDR_tooltip" toggle
	Gui, %GUI_name%: New, -Caption -DPIScale +LastFound +AlwaysOnTop +ToolWindow +E0x02000000 +E0x00080000 HWNDhwnd_vaalareas
	Gui, %GUI_name%: Color, Purple
	WinSet, TransColor, Purple
	Gui, %GUI_name%: Margin, 0, 0
	Gui, %GUI_name%: Font, % "s" settings.TLDR.fSize " cWhite", % vars.system.font
	hwnd_old := vars.hwnd.TLDR.main, vars.hwnd.TLDR := {"main": hwnd_vaalareas, "type": "vaal areas"}
	square1 := vars.client.h / 20, lines := {"player": [], "monsters": [], "boss": [], "area": [], "vessel": [], "z_unclear": []}
	text := SubStr(vars.TLDR.text, InStr(vars.TLDR.text, ":",, 0) + 1), text := SubStr(text, InStr(text, "`n") + 1)

	If !IsObject(db.vaalareas)
		DB_Load("TLDR")

	Loop, Parse, text, `n, % " `r`t"
	{
		loopfield_copy := ""
		Loop, Parse, A_LoopField
			loopfield_copy .= LLK_IsType(A_LoopField, "alpha") ? A_LoopField : ""
		While InStr(loopfield_copy, "  ")
			loopfield_copy := StrReplace(loopfield_copy, "  ", " ")
		While (SubStr(loopfield_copy, 1, 1) = " ")
			loopfield_copy := SubStr(loopfield_copy, 2)
		While (SubStr(loopfield_copy, 0) = " ")
			loopfield_copy := SubStr(loopfield_copy, 1, -1)
		If !loopfield_copy || !InStr(loopfield_copy, " ",,, 2)
			Continue
		If !db.vaalareas.HasKey(loopfield_copy)
		{
			regex_array := StrSplit(loopfield_copy, A_Space), regex_array_copy := regex_array.Clone()
			For index, val in regex_array
				If !LLK_HasVal(db.vaalareas_dictionary, val)
					regex_array_copy[index] := ""
			For index, val in regex_array_copy
				If Blank(val)
				{
					regex := ""
					Loop, Parse, % regex_array[index]
					{
						check := LLK_HasRegex(db.vaalareas, TLDR_RegexCheck(regex_array_copy, index, regex . A_LoopField), 1, 1)
						regex .= check.Count() ? A_LoopField : (SubStr(regex, -1) = ".*" ? "" : ".*")
						If (check.Count() = 1)
						{
							regex_array_copy[index] := regex
							Break 2
						}
					}
				}
			If ((check := LLK_HasRegex(db.vaalareas, TLDR_RegexCheck(regex_array_copy, 0, ""), 1, 1)).Count() = 1) && !LLK_HasVal(lines[db.vaalareas[check.1].2], (line1 := db.vaalareas[check.1].1))
			{
				If InStr(line1, "corr. packs") && !extra_pack
				{
					extra_pack := 1
					Continue
				}
				lines[db.vaalareas[check.1].2].Push(db.vaalareas[check.1].1)
			}
			Else If (check.Count() > 1)
				For iCheck, vCheck in check
					lines.z_unclear.Push(db.vaalareas[vCheck].1 " (?)")
		}
		Else If db.vaalareas.HasKey(loopfield_copy) && !LLK_HasVal(lines[db.vaalareas[loopfield_copy].2], (line1 := db.vaalareas[loopfield_copy].1))
		{
			If InStr(line1, "corr. packs") && !extra_pack
			{
				extra_pack := 1
				Continue
			}
			lines[db.vaalareas[loopfield_copy].2].Push(db.vaalareas[loopfield_copy].1)
		}
	}

	categories := [], wPanels := 0
	For key, val in lines
	{
		If (key = "z_unclear")
			key := "unclear"
		categories.Push(Lang_Trans("ocr_vaal" key))
		If val.Count()
			LLK_PanelDimensions(val, settings.TLDR.fSize, w%key%, h%key%), wPanels := (w%key% > wPanels) ? w%key% : wPanels
	}
	LLK_PanelDimensions(categories, settings.TLDR.fSize, wCategories, hCategories), added := -1

	If !IsObject(settings.TLDR.highlighting["vaal areas"])
	{
		settings.TLDR.highlighting["vaal areas"] := {}
		ini := IniBatchRead("ini\TLDR - vaal areas.ini")
		If ini["profile " settings.TLDR.profile].Count()
			settings.TLDR.highlighting["vaal areas"] := ini["profile " settings.TLDR.profile].Clone()
	}

	For key, val in lines
	{
		If !val.Count()
			Continue
		If (key = "z_unclear")
			key := "unclear"
		For index, line in val
		{
			rank := !Blank(check := settings.TLDR.highlighting["vaal areas"][StrReplace(line, "`n", ";")]) ? check : 0, colors := settings.TLDR.colors[rank].Clone(), added += 1
			Gui, %GUI_name%: Add, Text, % "xs x" wCategories - 1 . (added = 0 ? "" : " y+-1") " Section Border BackgroundTrans HWNDhwnd c" colors.1 " w" wPanels, % " " StrReplace(StrReplace(line, "`n", "`n "), "&", "&&") " "
			Gui, %GUI_name%: Add, Progress, % "xp yp wp hp Border BackgroundBlack HWNDhwnd1 c" colors.2, 100
			If (index = 1)
			{
				yPrev := yControl + hControl ? yControl + hControl : 0
				ControlGetPos, xControl, yControl, wControl, hControl,, ahk_id %hwnd%
			}
			(key != "unclear")
				line := StrReplace(line, "`n", ";"), vars.hwnd.TLDR[line] := hwnd1, vars.hwnd.TLDR[line "_text"] := hwnd
		}
		ControlGetPos, xControl1, yControl1, wControl1, hControl1,, ahk_id %hwnd%
		Gui, %GUI_name%: Add, Text, % "x0 y" yControl " w" wCategories " h" yControl1 + hControl1 - yControl " Border BackgroundTrans Right 0x200", % Lang_Trans("ocr_vaal" key) " "
		Gui, %GUI_name%: Add, Progress, % "xp yp wp hp BackgroundBlack Border", 0
	}
	Gui, %GUI_name%: Show, NA x10000 y10000
	WinGetPos,,, wWin, hWin, ahk_id %hwnd_vaalareas%
	xPos := vars.TLDR.coords.xMouse - wWin//2, yPos := vars.TLDR.coords.yMouse - hWin
	xPos := (xPos < vars.client.x) ? vars.client.x : (xPos + wWin >= vars.client.x + vars.client.w) ? vars.client.x + vars.client.w - wWin : xPos
	yPos := (yPos < vars.client.y) ? vars.client.y : (yPos + hWin >= vars.client.y + vars.client.h) ? vars.client.y + vars.client.h - hWin : yPos
	Gui, %GUI_name%: Show, % "NA x" xPos " y" yPos
	LLK_Overlay(vars.hwnd.TLDR.main, "show",, GUI_name)
}
