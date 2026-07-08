Init_Runeshape()
{
	local
	global vars, settings

	If !FileExist("ini" vars.poe_version "\rune-ninja.ini")
	{
		IniWrite, % settings.general.fSize + 2, % "ini" vars.poe_version "\rune-ninja.ini", settings, font-size
		IniWrite, % "1=""ix ,lx §1x ""`n2=""iox ,lox ,i0x ,l0x ,1ox §10x ""`n3=""greatwolfs§greatwolf's""", % "ini" vars.poe_version "\rune-ninja.ini", autocorrect
	}

	settings.runeshaping := {"autocorrect": []}, ini := IniBatchRead("ini" vars.poe_version "\rune-ninja.ini")
	settings.runeshaping.fSize := ini.settings["font-size"]
	LLK_FontDimensions(settings.runeshaping.fSize, fHeight, fWidth), settings.runeshaping.fWidth := fWidth, settings.runeshaping.fHeight := fHeight
	settings.runeshaping.debug := (!Blank(check := ini.settings["enable trouble-shooting"]) ? check : 0)
	settings.runeshaping.colors_default := {"high": "00FF00", "stack": "FFFF00", "unknown": "FF8000"}
	settings.runeshaping.hold_ctrl := (!Blank(check := ini.settings["hold down ctrl-key"]) ? check : 0)
	index := LLK_HasVal(vars.imagesearch.search, "runeshaping", 1)
	If !Blank(index)
		If (settings.general.input_method = 2)
			vars.imagesearch.search[index] := "runeshaping2"
		Else vars.imagesearch.search[index] := "runeshaping"

	For key, val in settings.runeshaping.colors_default
		settings.runeshaping["color_" key] := (!Blank(check := ini.settings["color " key]) ? check : val)

	For index, val in ini.autocorrect
		settings.runeshaping.autocorrect[index] := StrSplit(val, "§")
	If !LLK_HasVal(settings.runeshaping.autocorrect, "greatwolfs", 1,,, 1)
		settings.runeshaping.autocorrect.InsertAt(3, ["greatwolfs", "greatwolf's"])
}

Runeshape_OCR()
{
	local
	global vars, settings, JSON

	start := A_TickCount, cont := (settings.general.input_method = 2)
	Gui, ocr_comms: New, -DPIScale -Caption +LastFound +AlwaysOnTop +ToolWindow +Border, % "Exile UI: OCR"
	WinSet, Trans, 1
	Gui, ocr_comms: Add, Text,, % "client: " vars.hwnd.poe_client "|" vars.client.h
	. "`nclip: " Round(vars.client.h * (cont ? 19/120 : 1/8)) "|" Round(vars.client.h * (cont ? 23/96 : 11/80)) "|" Round(vars.client.h * (cont ? 25/72 : 3/8)) "|" Round(vars.client.h * 0.52) "`n"
	. (settings.general.blackbars ? "blackbars: " vars.client.x - vars.monitor.x "|0|" vars.client.w "|" vars.client.h "`n" : "")
	. "`nruneshaping" . (settings.runeshaping.debug ? "`ndebug" : "") . (settings.general.lang_client = "english" ? "`nenglish" : "")
	Gui, ocr_comms: Show, NA x10000 y10000

	vars.runeshaping := {"text": []}, vars.ocr_comms := {}
	Run, % """" A_AhkPath """ """ A_ScriptDir "\modules\_ocr thread.ahk""", % A_ScriptDir, UseErrorLevel

	If ErrorLevel
	{
		LLK_ToolTip(Lang_Trans("ocr_fail"), 2,,,, "Red")
		Gui, ocr_comms: Destroy
		Return
	}
	Else If !(settings.runeshaping.debug && GetKeyState("ALT", "P"))
		While !ocr_failed && Blank(vars.ocr_comms.text)
		{
			If (A_TickCount >= start + 1000)
				ocr_failed := 1
			Sleep 25
		}

	If ocr_failed || (vars.ocr_comms.text = "OCR failed") || settings.runeshaping.debug && GetKeyState("ALT", "P")
	{
		WinWaitClose, OCR debug
		If (vars.ocr_comms.text = "OCR failed") || !GetKeyState("ALT", "P")
			LLK_ToolTip(Lang_Trans("global_fail"), 1,,,, "Red")
		KeyWait, ALT
		Gui, ocr_comms: Destroy
		Return
	}
	text := vars.ocr_comms.text, text := SubStr(text, InStr(text, "`n") + 1)
	While InStr(text, "  ")
		text := StrReplace(text, "  ", " ")
	Loop, Parse, text, % "`n", % "`r`t' "
	{
		line := A_LoopField, object := {}
		For index, array in settings.runeshaping.autocorrect
			Loop, Parse, % array.1, % ","
				line := StrReplace(line, A_LoopField, array.2,, 1)
		If RegexMatch(line, "i)\[1\]$")
			object.tier := 1, line := StrReplace(line, " [1]")
		If RegexMatch(line, "i)\d{1,2}x\s")
			object.stack := SubStr(line, 1, InStr(line, "x") - 1), line := SubStr(line, InStr(line, "x ") + 2)
		Else If InStr(line, "x ")
			object.stack := "?", line := SubStr(line, InStr(line, "x ") + 2)
		object.line := line, vars.runeshaping.text.Push(object)
	}
	Gui, ocr_comms: Destroy
	Runeshape_GUI()
}

Runeshape_GUI()
{
	local
	global vars, settings
	static toggle := 0

	toggle := !toggle, GUI := vars.lootfilter.GUI := "runeshaping" toggle
	Gui, %GUI%: New, % "-DPIScale +LastFound -Caption +AlwaysOnTop +ToolWindow +E0x02000000 +E0x00080000 HWNDhwnd_runeshaping"
	Gui, %GUI%: Font, % "s" settings.runeshaping.fSize " cWhite", % vars.system.font
	Gui, %GUI%: Margin, 0, 0
	Gui, %GUI%: Color, % "Purple"
	WinSet, TransColor, Purple

	dBox := Round(vars.client.h * (2/45)) - 4, dBox2 := Round(vars.client.h * (3/40)) - 4, text := vars.runeshaping.text, prices := [], max_price := 0
	vars.hwnd.runeshaping := {"main": hwnd_runeshaping}

	For index, object in text
	{
		If RegexMatch(object.line, "thaumaturgic.flux.\(|\sore$")
			check := "expedition", Economy_Update(check)
		Else If RegExMatch(object.line, "i)uncut.*gem.\(")
			check := "uncutgems", Economy_Update(check)

		If (check_economy := LLK_HasVal(vars.economy.names, object.line)) || (check := LLK_HasKey(vars.stash, object.line,,,, 1))
		{
			If check_economy
			{
				ID := check_economy, check := LLK_HasKey(vars.economy, ID,,, 1, 1)
				For index, val in check
					If (val != "names")
						check := val
			}
			Else ID := vars.stash[check][object.line].ID
			check := (InStr(check, "runes") ? "runes" : (InStr(check, "currency") ? "currency" : check))
			Economy_Update(check)
			price := vars.economy[check][ID], stack := (IsNumber(object.stack) ? object.stack : 1), price *= stack
			If IsNumber(price)
				price := Round(price, 1), max_price := Max(max_price, price)
			Else price := "???"
			prices.Push(price)
		}
		Else prices.Push("???")
		check := ""
	}

	For index, price in prices
	{
		hText := (text[index].tier ? dBox2 : dBox), fHeight := settings.runeshaping.fHeight, offset := (fHeight >= hText ? 0 : hText//2 - fHeight//2)
		Gui, %GUI%: Add, Text, % "x0 y" (index = 1 ? offset : "+" offset + 4) " w" settings.runeshaping.fWidth * Max(5, StrLen(Round(max_price, (max_price >= 1000 ? 0 : 1)))) " 0x200 Right Border BackgroundTrans" (fHeight >= hText ? " h" hText : ""), % " " (IsNumber(price) ? Round(price, (price >= 1000 ? 0 : 1)) : price) " "
		color := (!IsNumber(price) ? settings.runeshaping.color_unknown : (!IsNumber(text[index].stack) ? settings.runeshaping.color_stack : (price = max_price ? settings.runeshaping.color_high : "White")))
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border cBlack Background" color, 100
		Gui, %GUI%: Add, Text, % "Hidden xp yp-" offset " w2 h" hText
	}
	Gui, %GUI%: Show, % "NA x" vars.client.x + (Round(vars.client.h//2 * 1.01)) " y" vars.client.y + Round(vars.client.h * (settings.general.input_method = 2 ? 11/45 : 5/36))
	LLK_Overlay(hwnd_runeshaping, "show",, GUI)
}
