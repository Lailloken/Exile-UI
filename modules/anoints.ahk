Init_anoints()
{
	local
	global vars, settings, db, json

	If !IsObject(settings.anoints)
		settings.anoints := {}, vars.anoints := {"stock": [], "stock_check": 0}
	If !FileExist("ini" vars.poe_version "\anoints.ini")
		IniWrite, % "", % "ini" vars.poe_version "\anoints.ini", settings
	If vars.poe_version
		vars.anoints.currencies := ["ire", "guilt", "greed", "paranoia", "envy", "disgust", "despair", "fear", "suffering", "isolation"]
	Else vars.anoints.currencies := ["clear", "sepia", "amber", "verdant", "teal", "azure", "indigo", "violet", "crimson", "black", "opalescent", "silver", "golden", "prismatic"]

	ini := IniBatchRead("ini" vars.poe_version "\anoints.ini")
	settings.anoints.reforge := !Blank(check := ini.settings.reforging) ? check : 0
	settings.anoints.collapse_keywords := !Blank(check := ini.settings["collapse keywords"]) ? check : 0
	settings.anoints.cost := !Blank(check := ini.settings["cost sorting"]) ? check : "ascending"
	settings.anoints.fSize := !Blank(check := ini.settings["font-size"]) ? check : settings.general.fSize
	If ini.settings.stock
		Try stock := json.load(ini.settings.stock)

	If stock.Count()
	{
		vars.anoints.stock := stock.Clone(), vars.anoints.stock0 := json.dump(stock)
		For index, val in vars.anoints.stock
			vars.anoints.stock_check += val
	}
	Else
	{
		For index, currency in vars.anoints.currencies
			vars.anoints.stock.Push(0)
		vars.anoints.stock0 := json.dump(vars.anoints.stock)
	}
	LLK_FontDimensions(settings.anoints.fSize, fHeight, fWidth), settings.anoints.fHeight := fHeight, settings.anoints.fWidth := fWidth
	vars.anoints.rings := 0
}

Anoints(cHWND := "")
{
	local
	global vars, settings, db, json
	static toggle := 0, fSize, wIcons, wCost := {}, wUnhide, hwnd_last, results, keyword_list, RGBs, and_or := [], block := [], hide := {}

	If !RGBs
		RGBs := vars.poe_version ? ["Maroon", "990099", "CC6600", "999900", "Green", "344A00", "20367C", "4C0099", "505050", "Silver"] : ["FFFFFF", "663300", "FF8000", "Lime", "Aqua", "Blue", "Purple", "Fuchsia", "Red", "Black", "579DC0", "Gray", "FFD700", "FFC0CB"]
		, vars.anoints.keywords := []

	If !vars.anoints.dictionary
		Anoints_Dictionary()

	keywords := vars.anoints.keywords, data := vars.poe_version ? db.anoints : db.anoints[vars.anoints.rings ? "rings" : "amulets"]
	If (cHWND = "close")
	{
		LLK_Overlay(vars.hwnd.anoints.main, "hide"), vars.hwnd.anoints.main := 0
		If (json.dump(vars.anoints.stock) != vars.anoints.stock0)
			IniWrite, % (vars.anoints.stock0 := json.dump(vars.anoints.stock)), % "ini" vars.poe_version "\anoints.ini", settings, stock
		Return
	}
	Else If (cHWND = "stock")
	{
		item := vars.omnikey.item
		For index, currency in vars.anoints.currencies
			If InStr(item.name, currency)
			{
				currency := index
				Break
			}
		If !IsNumber(currency)
			Return
		vars.anoints.stock[currency] := item.stack, LLK_ToolTip(Lang_Trans("global_ok"),,,,, "Lime")
		GuiControl, Text, % vars.hwnd.anoints[currency "_text"], % " " vars.anoints.stock[currency]
		GuiControl, MoveDraw, % vars.hwnd.anoints[currency "_text"]
	}
	Else If InStr(cHWND, "stock")
	{
		currency := LLK_HasVal(vars.hwnd.anoints, vars.general.cMouse), currency := InStr(currency, "_") ? SubStr(currency, 1, InStr(currency, "_") - 1) : currency
		vars.anoints.stock[currency] += (InStr(cHWND, "+") ? 1 : -1), vars.anoints.stock[currency] := (vars.anoints.stock[currency] < 0 ? (settings.general.dev ? 100 : 0) : vars.anoints.stock[currency])
		GuiControl, Text, % vars.hwnd.anoints[currency "_text"], % " " vars.anoints.stock[currency]
		GuiControl, MoveDraw, % vars.hwnd.anoints[currency "_text"]
	}
	Else If cHWND
	{
		check := LLK_HasVal(vars.hwnd.anoints, cHWND), control := SubStr(check, InStr(check, "_") + 1), start := A_TickCount
		If (check = "search") || (check = "nodes_cost") || InStr("reforge, rings", check) && (keywords.Count() + and_or.Count() + block.Count() + results.Count())
		{
			settings.anoints.collapse_matches := 0, vars.anoints.rings := (check = "rings") ? !vars.anoints.rings : vars.anoints.rings
			If (check = "rings")
				data := db.anoints[vars.anoints.rings ? "rings" : "amulets"]

			If (check = "nodes_cost")
			{
				results0 := {}, results := []
				IniWrite, % (settings.anoints.cost := (settings.anoints.cost = "ascending" ? "descending" : "ascending")), % "ini" vars.poe_version "\anoints.ini", settings, cost sorting
			}
			Else If (check = "reforge")
			{
				results0 := {}, results := []
				IniWrite, % (settings.anoints.reforge := !settings.anoints.reforge), % "ini" vars.poe_version "\anoints.ini", settings, reforging
			}
			Else results0 := {}, results := [], keyword_list := {}, keywords := vars.anoints.keywords := [], hide := {}, block := [], and_or := []

			For notable, o in data
				If Anoints_Check(o.recipe, (reforges := 0))
				{
					cost := 0
					Loop, Parse, % o.recipe, % ",", % " "
						cost += 3**(A_LoopField - 1)
					If (settings.anoints.cost = "ascending")
						results0[Format("{:07}", cost) " " notable] := ""
					Else results0[Format("{:07}", 9999999 - cost) " " notable] := ""
				}
			For key in results0
				results.Push(SubStr(key, InStr(key, " ") + 1))
		}
		Else If (check = "reforge")
		{
			IniWrite, % (settings.anoints.reforge := !settings.anoints.reforge), % "ini" vars.poe_version "\anoints.ini", settings, reforging
			GuiControl, % "+c" (settings.anoints.reforge ? "Lime" : "Gray"), % cHWND
			GuiControl, % "MoveDraw", % cHWND
			Return
		}
		Else If (check = "rings")
		{
			vars.anoints.rings := !vars.anoints.rings
			GuiControl, % "+c" (vars.anoints.rings ? "Lime" : "Gray"), % vars.hwnd.anoints.rings
			GuiControl, % "MoveDraw", % vars.hwnd.anoints.rings
			Return
		}
		Else If (check = "stock_reset")
		{
			If LLK_Progress(vars.hwnd.anoints.stock_reset_bar, "LButton")
				For index, val in vars.anoints.stock
					vars.anoints.stock[index] := 0, vars.anoints.stock_check := 0
			Else Return

			results0 := {}, results := []
		}
		Else If InStr(check, "collapse_")
		{
			settings.anoints["collapse_" control] := (!settings.anoints["collapse_" control] ? 1 : 0)
			If (control = "keywords")
				IniWrite, % settings.anoints.collapse_keywords, % "ini" vars.poe_version "\anoints.ini", settings, collapse keywords
		}
		Else If InStr(check, "keyword_")
		{
			settings.anoints.collapse_matches := 0
			While GetKeyState("LButton", "P") && !longpress
				If (A_TickCount >= start + 250)
					longpress := 1
			type := (vars.system.click = 1 ? (longpress ? "and_or" : "keywords") : "block"), hide := {}
			If (check := LLK_HasVal(keywords, control))
				keywords.RemoveAt(check)
			Else If (check := LLK_HasVal(and_or, control))
				and_or.RemoveAt(check)
			Else If (check := LLK_HasVal(block, control))
				block.RemoveAt(check)
			Else %type%.Push(control)
		}
		Else If (check = "OK")
		{
			input := Trim(LLK_ControlGet(vars.hwnd.anoints.edit_matches), " ")
			If (input != vars.anoints.search_matches)
				vars.anoints.search_matches := input, vars.anoints.search_keywords := Trim(LLK_ControlGet(vars.hwnd.anoints.edit_keywords), " ,.")
			Else
			{
				input := Trim(LLK_ControlGet(vars.hwnd.anoints.edit_keywords), " ,.")
				While InStr(input, "  ")
					input := StrReplace(input, "  ", " ")
				vars.anoints.search_keywords := (StrLen(input) < 3) ? "" : input
				Anoints_Highlight()
				Return
			}
		}
		Else If InStr(check, "clear_")
		{
			If (control = "keywords")
			{
				GuiControl,, % vars.hwnd.anoints.edit_keywords, % (vars.anoints.search_keywords := "")
				Anoints_Highlight()
				Return
			}
			Else If (control = "matches") && !vars.anoints.search_matches
				Return
			Else vars.anoints.search_matches := ""
		}
		Else If (InStr(check, "list_"))
		{
			If (vars.system.click = 2)
				hide[control] := 1
			Else
			{
				KeyWait, LButton
				If vars.anoints.rings
					Return
				WinActivate, % "ahk_id " vars.hwnd.poe_client
				WinWaitActive, % "ahk_id " vars.hwnd.poe_client
				Clipboard := "^(" StrReplace(control, " ", ".") ")$"
				SendInput, ^{f}
				Sleep 100
				SendInput, {DEL}^{v}{Enter}
				Return
			}
		}
		Else If (check = "nodes_reset")
			hide := {}
		Else
		{
			LLK_ToolTip("no action")
			Return
		}
	}

	If LLK_StringCompare(cHWND, ["stock"])
	{
		vars.anoints.stock_check := 0
		For index, stock in vars.anoints.stock
			vars.anoints.stock_check += stock

		If results.Count() || results0.Count()
			results0 := {}, results := []
		Else
		{
			GuiControl, % (vars.anoints.stock_check >= 3 ? "-" : "+") "Hidden", % vars.hwnd.anoints.search
			GuiControl, % (vars.anoints.stock_check >= 3 ? "-" : "+") "Hidden", % vars.hwnd.anoints.reforge
			GuiControl, % (vars.anoints.stock_check >= 3 ? "-" : "+") "Hidden", % vars.hwnd.anoints.rings
			GuiControl, % (vars.anoints.stock_check >= 3 ? "-" : "+") "Hidden", % vars.hwnd.anoints.stock_reset
			GuiControl, % (vars.anoints.stock_check >= 3 ? "-" : "+") "Hidden", % vars.hwnd.anoints.stock_reset_bar
			Return
		}
	}

	If (vars.hwnd.anoints.main = 0)
	{
		LLK_Overlay(hwnd_last, "show"), vars.hwnd.anoints.main := hwnd_last
		Return
	}

	toggle := !toggle, GUI_name := "anoints" toggle, margin := settings.anoints.fWidth//2
	Gui, %GUI_name%: New, % "-Caption -DPIScale +LastFound +AlwaysOnTop +ToolWindow +Border +E0x02000000 +E0x00080000 HWNDhwnd_anoints"
	Gui, %GUI_name%: Font, % "s" settings.anoints.fSize " cWhite", % vars.system.font
	Gui, %GUI_name%: Color, Black
	Gui, %GUI_name%: Margin, % (margin0 := settings.anoints.fWidth), % settings.anoints.fWidth
	hwnd_old := vars.hwnd.anoints.main, vars.hwnd.anoints := {"main": hwnd_anoints, "GUI_name": GUI_name}, hwnd_last := hwnd_anoints
	anoints := vars.anoints, dic := vars.anoints[vars.anoints.rings ? "dictionary_rings" : "dictionary"]

	Gui, %GUI_name%: Font, underline bold
	Gui, %GUI_name%: Add, Text, % "Section", % Lang_Trans("anoints_materials") Lang_Trans("global_colon")
	Gui, %GUI_name%: Add, Button, % "xp yp wp hp gAnoints HWNDhwnd Default Hidden", OK
	Gui, %GUI_name%: Add, Pic, % "ys hp w-1 HWNDhwnd1 x+" margin, % "HBitmap:*" vars.pics.global.help
	vars.hwnd.anoints.OK := hwnd, vars.hwnd.help_tooltips["anoints_materials"] := hwnd1
	Gui, %GUI_name%: Font, norm

	Gui, %GUI_name%: Add, Text, % "ys x+" margin " Border gAnoints HWNDhwnd" (vars.anoints.stock_check ? "" : " Hidden"), % " " Lang_Trans("global_calculate") " "
	vars.hwnd.anoints.search := hwnd
	Gui, %GUI_name%: Add, Text, % "ys x+" margin " Border gAnoints HWNDhwnd c" (settings.anoints.reforge ? "Lime" : "Gray") . (vars.anoints.stock_check ? "" : " Hidden"), % " " Lang_Trans("anoints_reforging", vars.poe_version) " "
	vars.hwnd.anoints.reforge := vars.hwnd.help_tooltips["anoints_reforging"] := hwnd
	If !vars.poe_version
	{
		Gui, %GUI_name%: Add, Text, % "ys x+" margin " Border gAnoints HWNDhwnd c" (vars.anoints.rings ? "Lime" : "Gray") . (vars.anoints.stock_check ? "" : " Hidden"), % " " Lang_Trans("anoints_rings") " "
		vars.hwnd.anoints.rings := vars.hwnd.help_tooltips["anoints_rings"] := hwnd
	}

	Gui, %GUI_name%: Add, Text, % "ys x+" margin " Border BackgroundTrans gAnoints HWNDhwnd" (vars.anoints.stock_check ? "" : " Hidden"), % " " Lang_Trans("global_reset") " "
	Gui, %GUI_name%: Add, Progress, % "Disabled xp yp wp hp HWNDhwnd1 BackgroundBlack cRed Range0-500 Vertical" (vars.anoints.stock_check ? "" : " Hidden"), 0
	vars.hwnd.anoints.stock_reset := hwnd, vars.hwnd.anoints.stock_reset_bar := vars.hwnd.help_tooltips["anoints_stock reset"] := hwnd1

	If !vars.pics.anoints.Count()
		Loop
			If !FileExist("img\GUI\anoints\" A_Index . vars.poe_version ".png")
				Break
			Else vars.pics.anoints[A_Index] := LLK_ImageCache("img\GUI\anoints\" A_Index . vars.poe_version ".png", (wIcons := (Round(vars.client.h*0.62) - margin0 * 2) / vars.anoints.currencies.Count() - 2))

	If (fSize != settings.anoints.fSize)
	{
		For index, val in ["ascending", "descending", "unhide"]
			LLK_PanelDimensions([(index < 3 ? Lang_Trans("global_cost") . Lang_Trans("global_colon") " " : "") Lang_Trans("global_" val)], settings.anoints.fSize, width_%val%, height)
		wCost := {"ascending": width_ascending, "descending": width_descending}, wUnhide := width_unhide
		fSize := settings.anoints.fSize
	}

	For index, hbmBitmap in vars.pics.anoints
	{
		Gui, %GUI_name%: Add, Text, % (index = 1 ? "Section xs y+" margin : "ys x+0") " BackgroundTrans HWNDhwnd -Wrap w" wIcons, % " " anoints.stock[index]
		Gui, %GUI_name%: Add, Pic, % "xp+1 yp+1 wp hp HWNDhwnd2 BackgroundTrans", % "HBitmap:*" vars.pics.global.black_trans
		Gui, %GUI_name%: Add, Pic, % "xp-1 yp-1 Border HWNDhwnd3", % "HBitmap:*" hbmBitmap
		Gui, %GUI_name%: Add, Text, % "Disabled xp y+-1 wp h" margin*2 " Border BackgroundTrans HWNDhwnd_mats"
		Gui, %GUI_name%: Add, Progress, % "Disabled xp yp wp hp Border BackgroundBlack c" RGBs[index], 100
		vars.hwnd.anoints[index "_text"] := hwnd, vars.hwnd.anoints[index] := hwnd2, vars.hwnd.anoints[index "_2"] := hwnd3
	}
	ControlGetPos, xMats, yMats, wMats, hMats,, ahk_id %hwnd_mats%

	keyword_list0 := {}, keyword_list := {}, wMax := xMats + wMats
	For index0, val in results
	{
		For index, keyword in keywords
			If !LLK_HasVal(data[val].stats, keyword, 1, 1)
				Continue 2

		For index, word in block
			If LLK_HasVal(data[val].stats, word, 1, 1)
				Continue 2

		If hide[val]
			Continue

		For index, stat in data[val].stats
		{
			If vars.anoints.rings
			{
				For ring_keyword in vars.anoints.dictionary_rings
					If InStr(stat, ring_keyword, 1)
						keyword_list0[ring_keyword] := !keyword_list0[ring_keyword] ? 0 : keyword_list0[ring_keyword] + 1
				Continue
			}

			stat := StrSplit(stat, " ", " .,")
			For index, word in stat
			{
				If RegExMatch(SubStr(word, 1, 1), "[A-Z]")
				{
					If (index = skip) && !RegExMatch(SubStr(stat[index + 1], 1, 1), "[A-Z]")
						Continue
					skip := 0
					If LLK_HasVal(keywords, word,, 1) && (next := stat[index + 1]) && RegExMatch(SubStr(next, 1, 1), "[A-Z]")
						keyword_list0[word " " next] := !keyword_list0[word " " next] ? 1 : keyword_list0[word " " next] + 1, skip := index + 1
					Else If (next := stat[index + 1]) && LLK_HasVal(keywords, next,, 1)
						keyword_list0[word " " next] := !keyword_list0[word " " next] ? 1 : keyword_list0[word " " next] + 1, skip := index + 1

					If !skip
						If !dic[word]
						{
							found := 0
							For key, val in dic
								If LLK_StringCompare(word, [key])
								{
									found := 1
									If !(keywords.Count() || val > 2 || vars.anoints.rings)
										Continue
									keyword_list0[key] := (!keyword_list0[key] ? 1 : keyword_list0[key] + 1)
									Break
								}
							If !found && settings.general.dev
								MsgBox, % "not found: " word
						}
						Else If (keywords.Count() || dic[word] > 2 || vars.anoints.rings)
							keyword_list0[word] := !keyword_list0[word] ? 1 : keyword_list0[word] + 1
				}
			}
		}
	}

	For key, val in keyword_list0
		keyword_list[9999 - val " " key] := ""

	keywords_count := 0
	If results.Count()
	{
		Gui, %GUI_name%: Add, Pic, % "Section xs y+" margin0 " h" settings.anoints.fHeight - 2 " w-1 Border gAnoints HWNDhwnd", % "HBitmap:*" vars.pics.global[settings.anoints.collapse_keywords ? "expand" : "collapse"]
		vars.hwnd.anoints.collapse_keywords := hwnd

		Gui, %GUI_name%: Font, underline bold
		Gui, %GUI_name%: Add, Text, % "ys x+" margin " hp HWNDhwnd_keywords" (settings.anoints.collapse_keywords ? "" : " Hidden"), % settings.anoints.collapse_keywords ? Lang_Trans("global_keywords") . Lang_Trans("global_colon") : "000"
		Gui, %GUI_name%: Font, norm
		ControlGetPos, xLast2, yLast2, wLast2, hLast2,, ahk_id %hwnd_keywords%

		If !settings.anoints.collapse_keywords
		{
			check := 0
			For index, keyword in keywords
			{
				If (index = 1)
				{
					Gui, %GUI_name%: Add, Text, % "xs Section HWNDhwnd0 y+" margin, % Lang_Trans("anoints_statgroups") . Lang_Trans("global_colon")
					ControlGetPos, x1, y1, w1, h1,, ahk_id %hwnd0%
				}
				If (LLK_HasVal(keywords, keyword, 1, 1, 1).Count() > 1)
					Continue

				Gui, %GUI_name%: Add, Text, % "ys x+" margin/(!check ? 1 : 2) " cLime Border Center BackgroundTrans gAnoints HWNDhwnd", % " " LLK_StringCase(keyword) " "
				ControlGetPos, xN, yN, wN, hN,, ahk_id %hwnd%
				If (xN + wN >= wMax)
				{
					GuiControl, +Hidden, % hwnd
					Gui, %GUI_name%: Add, Text, % "Section x" x1 + w1 + margin - 1 " y" yN + hN + margin/2 - 1 " cLime Border Center BackgroundTrans gAnoints HWNDhwnd", % " " LLK_StringCase(keyword) " "
				}
				vars.hwnd.anoints["keyword_" keyword] := hwnd, keywords_count += 1, check := 1
			}

			For index, keyword in and_or
			{
				If (index = 1)
				{
					Gui, %GUI_name%: Add, Text, % "Section x" margin0 " HWNDhwnd0 y+" margin/2, % Lang_Trans("anoints_statgroups", 2) . Lang_Trans("global_colon")
					ControlGetPos, x1, y1, w1, h1,, ahk_id %hwnd0%
				}

				Gui, %GUI_name%: Add, Text, % "ys x+" margin/(index = 1 ? 1 : 2) " cYellow Border Center BackgroundTrans gAnoints HWNDhwnd", % " " LLK_StringCase(keyword) " "
				ControlGetPos, xN, yN, wN, hN,, ahk_id %hwnd%
				If (xN + wN >= wMax)
				{
					GuiControl, +Hidden, % hwnd
					Gui, %GUI_name%: Add, Text, % "Section x" x1 + w1 + margin - 1 " y" yN + hN + margin/2 - 1 " cYellow Border Center BackgroundTrans gAnoints HWNDhwnd", % " " LLK_StringCase(keyword) " "
				}
				vars.hwnd.anoints["keyword_" keyword] := hwnd, keywords_count += 1, check := 1
			}

			For index, keyword in block
			{
				If (index = 1)
				{
					Gui, %GUI_name%: Add, Text, % "Section x" margin0 " HWNDhwnd0 y+" margin/2, % Lang_Trans("anoints_statgroups", 3) . Lang_Trans("global_colon")
					ControlGetPos, x1, y1, w1, h1,, ahk_id %hwnd0%
				}

				Gui, %GUI_name%: Add, Text, % "ys x+" margin/(index = 1 ? 1 : 2) " cRed Border Center BackgroundTrans gAnoints HWNDhwnd", % " " LLK_StringCase(keyword) " "
				ControlGetPos, xN, yN, wN, hN,, ahk_id %hwnd%
				If (xN + wN >= wMax)
				{
					GuiControl, +Hidden, % hwnd
					Gui, %GUI_name%: Add, Text, % "Section x" x1 + w1 + margin - 1 " y" yN + hN + margin/2 - 1 " cRed Border Center BackgroundTrans gAnoints HWNDhwnd", % " " LLK_StringCase(keyword) " "
				}
				vars.hwnd.anoints["keyword_" keyword] := hwnd, keywords_count += 1, check := 1
			}
			ControlGetPos, xLast2, yLast2, wLast2, hLast2,, ahk_id %hwnd%
		}
	}

	If !settings.anoints.collapse_keywords
	{
		If (keyword_list.Count() > 1)
			For key in keyword_list
			{
				key := SubStr(key, InStr(key, " ") + 1), group_check := 0
				For i, keyword in keywords
					If InStr(keyword, key, 1)
						Continue 2
					Else If InStr(key, keyword, 1)
						group_check := 100

				If LLK_HasVal(and_or, key,, 1)
					Continue
				highlight_check := 0
				Loop, Parse, % vars.anoints.search_keywords, % " ", % " .,"
					If (StrLen(A_LoopField) >= 3) && InStr(key, A_LoopField)
					{
						highlight_check := 100
						Break
					}

				Gui, %GUI_name%: Add, Text, % (!added ? "Section x" margin0 " y+" margin : "ys x+" margin/2) " gAnoints Border Center BackgroundTrans HWNDhwnd" (LLK_Haskey(block, key) ? " cRed" : ""), % " " LLK_StringCase(key) " "
				ControlGetPos, xLast2, yLast2, wLast2, hLast2,, ahk_id %hwnd%
				override := 0
				If (xLast2 + wLast2 >= wMax)
				{
					GuiControl, +Hidden, % hwnd
					Gui, %GUI_name%: Add, Text, % "Section xs y+" margin/2 " gAnoints Border Center BackgroundTrans HWNDhwnd" (LLK_Haskey(block, key) ? " cRed" : ""), % " " LLK_StringCase(key) " "
				}
				Gui, %GUI_name%: Add, Progress, % "Disabled xp yp wp hp Border BackgroundBlack HWNDhwnd2 c" (highlight_check ? "404080" : "006600"), % Max(highlight_check, group_check)
				vars.hwnd.anoints["keyword_" key] := hwnd, vars.hwnd.anoints["keywordbar_" key] := hwnd2, added := 1, keywords_count += 1
				ControlGetPos, xLast2, yLast2, wLast2, hLast2,, ahk_id %hwnd%
			}

		If results.Count()
		{
			ControlGetPos, xKeywords, yKeywords, wKeywords, hKeywords,, ahk_id %hwnd_keywords%
			Gui, %GUI_name%: Font, underline bold
			Gui, %GUI_name%: Add, Text, % "x" xKeywords - 1 " y" yKeywords - 1 " h" settings.anoints.fHeight, % Lang_Trans("global_keywords") " (" keywords_count ")" Lang_Trans("global_colon")
			Gui, %GUI_name%: Add, Pic, % "yp x+" margin " hp w-1 HWNDhwnd", % "HBitmap:*" vars.pics.global.help
			vars.hwnd.help_tooltips["anoints_keywords"] := hwnd
			Gui, %GUI_name%: Font, % "norm s" settings.anoints.fSize - 4
			Gui, %GUI_name%: Add, Edit, % "yp x+" margin " hp HWNDhwnd cBlack w" settings.anoints.fWidth * 15, % vars.anoints.search_keywords
			Gui, %GUI_name%: Add, Pic, % "yp x+-1 hp-2 w-1 Border HWNDhwnd2 gAnoints", % "HBitmap:*" vars.pics.global.close
			vars.hwnd.anoints.edit_keywords := hwnd, vars.hwnd.anoints.clear_keywords := hwnd2
			Gui, %GUI_name%: Font, % "s" settings.anoints.fSize
		}
	}

	If results.Count()
	{
		Gui, %GUI_name%: Add, Pic, % "Section x" margin0 " y" yLast2 + hLast2 - 1 + margin0 " h" settings.anoints.fHeight - 2 " w-1 Border gAnoints HWNDhwnd", % "HBitmap:*" vars.pics.global[settings.anoints.collapse_matches ? "expand" : "collapse"]
		vars.hwnd.anoints.collapse_matches := hwnd

		Gui, %GUI_name%: Font, underline bold
		Gui, %GUI_name%: Add, Text, % "ys x+" margin " hp HWNDhwnd_matches" (settings.anoints.collapse_matches ? "" : " Hidden"), % settings.anoints.collapse_matches ? Lang_Trans("global_matches") . Lang_Trans("global_colon") : "000"
		Gui, %GUI_name%: Font, norm

		If !settings.anoints.collapse_matches
		{
			added := 0, wText := wMax - margin0 - margin*2 - 2, match_count := 0
			For index0, val in results
			{
				For index, keyword in keywords
					If !LLK_HasVal(data[val].stats, keyword, 1, 1)
						Continue 2

				If and_or.Count()
				{
					and_or_check := 0
					For index, word in and_or
						and_or_check += (LLK_HasVal(data[val].stats, word, 1, 1) ? 1 : 0)
					If !and_or_check
						Continue
				}

				For index, word in block
					If LLK_HasVal(data[val].stats, word, 1, 1)
						Continue 2

				If hide[val]
					Continue

				If vars.anoints.search_matches
				{
					regex := 0
					For index, stat in data[val].stats
						If RegExMatch(stat, "i)" vars.anoints.search_matches)
							regex += 1
					If !regex
						Continue
				}

				match_count += 1
				If continue
					Continue

				reforges := 0, Anoints_Check(data[val].recipe, reforges), HWNDs := 0
				Loop, Parse, % data[val].recipe, % ",", % " "
				{
					Gui, %GUI_name%: Add, Text, % (A_Index = 1 ? (!added ? "Section xs x" margin0 + margin : "xs y+" margin) " HWNDhwnd" (HWNDs += 1) : "yp x+-1 HWNDhwnd" (HWNDs += 1)) " BackgroundTrans Border w" settings.anoints.fHeight * 0.66 " h" settings.anoints.fHeight - 2
					Gui, %GUI_name%: Add, Progress, % "Disabled xp yp wp hp Border BackgroundBlack c" RGBs[A_LoopField] " HWNDhwnd" (HWNDs += 1), 100
				}
				Gui, %GUI_name%: Add, Text, % "yp x+" margin " cFFCC99 HWNDhwnd" (HWNDs += 1), % (IsNumber(val) ? "" : LLK_StringCase(val)) . (reforges ? " (" reforges ")" : "")
				ControlGetPos, xNode, yNode, wNode, hNode,, ahk_id %hwnd1%
				For index, stat in data[val].stats
					Gui, %Gui_name%: Add, Text, % "HWNDhwnd" (HWNDs += 1) " x" xNode " y" (index = 1 ? yNode + hNode : "+0") " w" wText, % LLK_StringCase(stat)
				ControlGetPos, xLast, yLast, wLast, hLast,, % "ahk_id" hwnd%HWNDs%
				Gui, %GUI_name%: Add, Text, % "BackgroundTrans gAnoints HWNDhwnd" (hwnds += 1) " Border x" margin0 " y" yNode - margin " w" wText + margin*2 + 1 " h" yLast + hLast - yNode + margin*2

				ControlGetPos, xBox, yBox, wBox, hBox,, % "ahk_id" hwnd%HWNDs%
				If (yBox + hBox >= vars.monitor.h - margin0)
				{
					Loop, % HWNDs
						GuiControl, +Hidden, % hwnd%A_Index%
					continue := 1
					Continue
				}
				vars.hwnd.anoints["list_" val] := hwnd%HWNDs%
				If !added
					ControlGetPos, xFirst, yFirst, wFirst, hFirst,, ahk_id %hwnd%
				added := 1
			}
			ControlGetPos, xMatches, yMatches, wMatches, hMatches,, ahk_id %hwnd_matches%
			Gui, %GUI_name%: Font, underline bold
			Gui, %GUI_name%: Add, Text, % "x" xMatches - 1 " y" yMatches - 1 " h" settings.anoints.fHeight, % Lang_Trans("global_matches") " (" match_count ")" Lang_Trans("global_colon")
			Gui, %GUI_name%: Font, norm

			Gui, %GUI_name%: Add, Pic, % "yp hp w-1 HWNDhwnd x+" margin, % "HBitmap:*" vars.pics.global.help
			Gui, %GUI_name%: Font, % "norm s" settings.anoints.fSize - 4
			ControlGetPos, xHelp, yHelp, wHelp, hHelp,, ahk_id %hwnd%
			Gui, %GUI_name%: Add, Edit, % "yp x+" margin " hp HWNDhwnd2 cBlack w" wMax - (hHelp - 1) - (xHelp + wHelp + margin) - (wCost[settings.anoints.cost] + margin) - (hide.Count() ? wUnhide + margin : 0), % vars.anoints.search_matches
			Gui, %GUI_name%: Add, Pic, % "yp x+-1 hp-2 w-1 Border HWNDhwnd3 gAnoints", % "HBitmap:*" vars.pics.global.close
			Gui, %GUI_name%: Font, % "s" settings.anoints.fSize
			Gui, %GUI_name%: Add, Text, % "yp x+" margin " hp gAnoints Border HWNDhwnd4 w" wCost[settings.anoints.cost], % " " Lang_Trans("global_cost") . Lang_Trans("global_colon") " " Lang_Trans("global_" settings.anoints.cost) " "
			Gui, %GUI_name%: Add, Text, % "yp x+" margin " hp gAnoints Border HWNDhwnd5 w" wUnhide . (hide.Count() ? "" : " Hidden"), % " " Lang_Trans("global_unhide") " "

			vars.hwnd.help_tooltips["anoints_matches"] := hwnd, vars.hwnd.anoints.edit_matches := hwnd2, vars.hwnd.anoints.clear_matches := hwnd3
			vars.hwnd.anoints.nodes_cost := vars.hwnd.help_tooltips["anoints_sort"] := hwnd4, vars.hwnd.anoints.nodes_reset := hwnd5
		}
	}
	ControlFocus,, % "ahk_id " vars.hwnd.anoints.search
	Gui, %GUI_name%: Show, % "NA x" vars.monitor.x " y" vars.monitor.y " w" wMax + margin0 . (continue ? " h" vars.monitor.h - 2 : "")
	LLK_Overlay(hwnd_anoints, "show",, GUI_name), LLK_Overlay(hwnd_old, "destroy")
	Clipboard := json.dump(keyword_list,, "  ")
}

Anoints_Check(recipe, ByRef reforges)
{
	local
	global vars, settings

	stock := vars.anoints.stock.Clone()
	For index, currency in StrSplit(recipe, ",", " ")
	{
		While settings.anoints.reforge && !stock[currency] && (currency != 14)
		{
			While (stock[currency - 1] < 3)
				If (stock[currency - 2] < 3)
					Break 2
				Else stock[currency - 1] += 1, stock[currency - 2] -= 3, reforges += 1
			stock [currency] += 1, stock[currency - 1] -= 3, reforges += 1
		}
		If !stock[currency]
			Return
		Else stock[currency] -= 1
	}
	Return 1
}

Anoints_Dictionary()
{
	local
	global vars, settings, db

	DB_Load("anoints"), vars.anoints.dictionary := {}, data := vars.poe_version ? db.anoints : db.anoints.amulets
	For anoint, o in data
		For index, stat in o.stats
			Loop, Parse, stat, % " ", % ",."
				If RegExMatch(SubStr(A_LoopField, 1, 1), "[A-Z]")
					vars.anoints.dictionary[A_LoopField] := 1

	remove := [], dic_copy := vars.anoints.dictionary.Clone()
	For key0 in vars.anoints.dictionary
		If !InStr(key0, "/")
			For key in dic_copy
				If !InStr(key0, "-") && (key != key0) && LLK_StringCompare(key0, [key])
					vars.anoints.dictionary[key "/" key0] := 1, remove.Push(key), remove.Push(key0)
	For index, key in remove
		vars.anoints.dictionary.Delete(key)

	remove := []
	For key, val in vars.anoints.dictionary
		If (check := InStr(key, "/"))
			vars.anoints.dictionary[SubStr(key, 1, check - 1)] := 1, remove.Push(key)
	For index, val in remove
		vars.anoints.dictionary.Delete(val)

	dictionary0 := {}
	For key in vars.anoints.dictionary
		For anoint, o in data
			For index, stat in o.stats
			{
				count := 0
				While InStr(stat, key, 1,, count + 1)
					count += 1
				dictionary0[key] := !dictionary0[key] ? count : dictionary0[key] + count
			}
	vars.anoints.dictionary := dictionary0.Clone()

	If vars.poe_version
		Return

	vars.anoints.dictionary_rings := {}, data := db.anoints.rings
	For index, o in data
		For index, stat in o.stats
			If (check := RegExMatch(stat, "i)your\s.*\stowers"))
				keyword := SubStr(stat, check + 5), keyword := SubStr(keyword, 1, InStr(keyword, "towers") - 2), vars.anoints.dictionary_rings[keyword] := 1
}
/*
Anoints_Dictionary()
{
	local
	global vars, settings, db

	DB_Load("anoints"), vars.anoints.dictionary := {}, vars.anoints.dictionary_rings := {}
	For index0, type in (vars.poe_version ? ["amulets"] : ["amulets", "rings"])
	{
		data := vars.poe_version ? db.anoints : db.anoints[type], dictionary := vars.anoints[(index0 = 1) ? "dictionary" : "dictionary_rings"]
		For anoint, o in data
			For index, stat in o.stats
				Loop, Parse, stat, % " ", % ",."
					If RegExMatch(SubStr(A_LoopField, 1, 1), "[A-Z]")
						dictionary[A_LoopField] := 1

		remove := [], dic_copy := dictionary.Clone()
		For key0 in dictionary
			If !InStr(key0, "/")
				For key in dic_copy
					If !InStr(key0, "-") && (key != key0) && LLK_StringCompare(key0, [key])
						dictionary[key "/" key0] := 1, remove.Push(key), remove.Push(key0)
		For index, key in remove
			dictionary.Delete(key)

		remove := []
		For key, val in dictionary
			If (check := InStr(key, "/"))
				dictionary[SubStr(key, 1, check - 1)] := 1, remove.Push(key)
		For index, val in remove
			dictionary.Delete(val)

		dictionary0 := {}
		For key in dictionary
			For anoint, o in data
				For index, stat in o.stats
				{
					count := 0
					While InStr(stat, key, 1,, count + 1)
						count += 1
					dictionary0[key] := !dictionary0[key] ? count : dictionary0[key] + count
				}
		vars.anoints[(index0 = 1) ? "dictionary" : "dictionary_rings"] := dictionary0.Clone()
	}
}
*/

Anoints_Highlight()
{
	local
	global vars, settings

	For key, hwnd in vars.hwnd.anoints
		If InStr(key, "keywordbar_")
		{
			search := group_check := 0, key := SubStr(key, InStr(key, "_") + 1)
			If LLK_HasVal(vars.anoints.keywords, key,, 1)
				Continue
			Loop, Parse, % vars.anoints.search_keywords, % " "
				If (StrLen(A_LoopField) >= 3) && InStr(key, A_LoopField)
				{
					search := 100
					Break
				}

			If !search
				For i, keyword in vars.anoints.keywords
					If (key != keyword) && InStr(key, keyword, 1)
						group_check := 100
			GuiControl, % "+c" (search ? "404080" : "006600"), % hwnd
			GuiControl,, % hwnd, % Max(search, group_check)
		}
}
