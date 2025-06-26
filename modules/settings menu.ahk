﻿Settings_actdecoder()
{
	local
	global vars, settings

	GUI := "settings_menu" vars.settings.GUI_toggle, x_anchor := vars.settings.x_anchor
	Gui, %GUI%: Add, Link, % "Section x" x_anchor " y" vars.settings.ySelection, <a href="https://github.com/Lailloken/Exile-UI/wiki/Act‐Decoder">wiki page</a>

	Gui, %GUI%: Add, Checkbox, % "xs y+" vars.settings.spacing " Section gSettings_actdecoder2 HWNDhwnd Checked" settings.features.actdecoder, % Lang_Trans("m_actdecoder_enable")
	vars.hwnd.settings.enable := vars.hwnd.help_tooltips["settings_actdecoder enable"] := hwnd

	If !settings.features.actdecoder
		Return

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "Section xs y+" vars.settings.spacing, % Lang_Trans("global_general")
	Gui, %GUI%: Font, norm

	LLK_PanelDimensions([Lang_Trans("m_actdecoder_opacity") " ", Lang_Trans("m_actdecoder_zoom") " "], settings.general.fSize, wPanels, hPanels,,, 0)
	Gui, %GUI%: Add, Checkbox, % "Section xs HWNDhwnd gSettings_actdecoder2 Checked" (settings.actdecoder.generic ? 1 : 0), % Lang_Trans("m_actdecoder_simple")
	vars.hwnd.settings.generic := vars.hwnd.help_tooltips["settings_actdecoder generic"] := hwnd

	Gui, %GUI%: Add, Text, % "Section xs Center HWNDhwnd", % Lang_Trans("m_actdecoder_opacity")
	vars.hwnd.help_tooltips["settings_actdecoder layouts opacity"] := hwnd

	Gui, %GUI%: Add, Text, % "ys x" x_anchor + wPanels " gSettings_actdecoder2 Center Border HWNDhwnd w" settings.general.fWidth * 2, % "–"
	Gui, %GUI%: Add, Text, % "ys x+" settings.general.fWidth / 4 " Center Border HWNDhwnd1 w" settings.general.fWidth * 3, % settings.actdecoder.trans_zones
	Gui, %GUI%: Add, Text, % "ys x+" settings.general.fWidth / 4 " Center Border HWNDhwnd2 gSettings_actdecoder2 w" settings.general.fWidth * 2, % "+"
	vars.hwnd.settings["zonesopac_minus"] := hwnd, vars.hwnd.settings["zonesopac_text"] := hwnd1, vars.hwnd.settings["zonesopac_plus"] := hwnd2

	Gui, %GUI%: Add, Text, % "Section xs HWNDhwnd", % Lang_Trans("m_actdecoder_zoom")
	vars.hwnd.help_tooltips["settings_actdecoder layouts locked zoom"] := hwnd
	Gui, %GUI%: Add, Text, % "ys x" x_anchor + wPanels " gSettings_actdecoder2 Center Border HWNDhwnd w" settings.general.fWidth * 2, % "–"
	Gui, %GUI%: Add, Text, % "ys x+" settings.general.fWidth / 4 " Center Border HWNDhwnd1 w" settings.general.fWidth * 3, % settings.actdecoder.sLayouts1
	Gui, %GUI%: Add, Text, % "ys x+" settings.general.fWidth / 4 " Center Border HWNDhwnd2 gSettings_actdecoder2 w" settings.general.fWidth * 2, % "+"
	vars.hwnd.settings["zoneszoom_minus"] := hwnd, vars.hwnd.settings["zoneszoom_text"] := hwnd1, vars.hwnd.settings["zoneszoom_plus"] := hwnd2
}

Settings_actdecoder2(cHWND := "")
{
	local
	global vars, settings

	check := LLK_HasVal(vars.hwnd.settings, cHWND), control := SubStr(check, InStr(check, "_") + 1)
	KeyWait, LButton
	If (check = "enable")
	{
		IniWrite, % (settings.features.actdecoder := LLK_ControlGet(cHWND)), % "ini" vars.poe_version "\config.ini", Features, enable act-decoder
		If !settings.features.actdecoder
			vars.actdecoder.layouts_lock := 0, LLK_Overlay(vars.hwnd.actdecoder.main, "destroy"), vars.hwnd.actdecoder.main := ""
		Settings_menu("actdecoder")
	}
	Else If (check = "generic")
	{
		IniWrite, % (settings.actdecoder.generic := LLK_ControlGet(cHWND)), % "ini" vars.poe_version "\act-decoder.ini", settings, show generic layouts
		If !vars.actdecoder.tab && WinExist("ahk_id " vars.hwnd.actdecoder.main)
			Actdecoder_ZoneLayouts(2)
	}
	Else If InStr(check, "zonesopac_")
	{
		If (settings.actdecoder.trans_zones = 1) && (control = "minus") || (settings.actdecoder.trans_zones = 10) && (control = "plus")
			Return
		
		IniWrite, % (settings.actdecoder.trans_zones += (control = "plus") ? 1 : -1), % "ini" vars.poe_version "\act-decoder.ini", settings, zone transparency
		If WinExist("ahk_id " vars.hwnd.actdecoder.main)
			WinSet, TransColor, % "Green " (settings.actdecoder.trans_zones * 25), % "ahk_id " vars.hwnd.actdecoder.main

		GuiControl, Text, % vars.hwnd.settings["zonesopac_text"], % settings.actdecoder.trans_zones
		GuiControl, movedraw, % vars.hwnd.settings["zonesopac_text"]
	}
	Else If InStr(check, "zoneszoom_")
	{
		If (settings.actdecoder.sLayouts1 = 0) && (control = "minus") || (settings.actdecoder.sLayouts1 = 5) && (control = "plus")
			Return
		
		IniWrite, % (settings.actdecoder.sLayouts1 += (control = "plus") ? 1 : -1), % "ini" vars.poe_version "\act-decoder.ini", settings, zone-layouts locked size
		If WinExist("ahk_id " vars.hwnd.actdecoder.main)
			Actdecoder_ZoneLayouts(2)

		GuiControl, Text, % vars.hwnd.settings["zoneszoom_text"], % settings.actdecoder.sLayouts1
		GuiControl, movedraw, % vars.hwnd.settings["zoneszoom_text"]
	}
	Else LLK_ToolTip("no action")
}

Settings_anoints()
{
	local
	global vars, settings, db

	GUI := "settings_menu" vars.settings.GUI_toggle, x_anchor := vars.settings.x_anchor
	Gui, %GUI%: Add, Link, % "Section x" x_anchor " y" vars.settings.ySelection, <a href="https://github.com/Lailloken/Exile-UI/wiki/Enchant-Finder">wiki page</a>

	Gui, %GUI%: Add, Checkbox, % "Section xs HWNDhwnd gSettings_anoints2 y+" vars.settings.spacing " Checked" settings.features.anoints, % Lang_Trans("m_anoints_enable")
	vars.hwnd.settings.enable := vars.hwnd.help_tooltips["settings_anoints enable"] := hwnd

	If !settings.features.anoints
		Return

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "Section xs Center y+"vars.settings.spacing, % Lang_Trans("global_ui")
	Gui, %GUI%: Font, norm

	Gui, %GUI%: Add, Text, % "xs Section HWNDhwnd0", % Lang_Trans("global_font")
	Gui, %GUI%: Add, Text, % "ys x+" settings.general.fWidth/2 " Center Border gSettings_anoints2 HWNDhwnd w"settings.general.fWidth*2, % "–"
	vars.hwnd.help_tooltips["settings_font-size"] := hwnd0, vars.hwnd.settings.font_minus := vars.hwnd.help_tooltips["settings_font-size|"] := hwnd
	Gui, %GUI%: Add, Text, % "ys x+"settings.general.fWidth/4 " Center Border gSettings_anoints2 HWNDhwnd w"settings.general.fWidth*3, % settings.anoints.fSize
	vars.hwnd.settings.font_reset := vars.hwnd.help_tooltips["settings_font-size||"] := hwnd
	Gui, %GUI%: Add, Text, % "ys x+"settings.general.fWidth/4 " Center Border gSettings_anoints2 HWNDhwnd w"settings.general.fWidth*2, % "+"
	vars.hwnd.settings.font_plus := vars.hwnd.help_tooltips["settings_font-size|||"] := hwnd

	If !IsObject(db.anoints)
		DB_Load("anoints")

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "Section xs Center y+"vars.settings.spacing, % Lang_Trans("global_databaseinfo") . Lang_Trans("global_colon")
	Gui, %GUI%: Font, norm
	Gui, %GUI%: Add, Text, % "Section xs Center", % Lang_Trans("global_current") . Lang_Trans("global_colon") " " vars.anoints.timestamp " "
	Gui, %GUI%: Add, Pic, % "ys x+0 hp-2 w-1 Border BackgroundTrans HWNDhwnd gSettings_anoints2", % "HBitmap:*" vars.pics.global.reload
	vars.hwnd.settings.update := vars.hwnd.help_tooltips["settings_anoints update"] := hwnd
}

Settings_anoints2(cHWND)
{
	local
	global vars, settings, db, json

	check := LLK_HasVal(vars.hwnd.settings, cHWND), control := SubStr(check, InStr(check, "_") + 1)
	If (check = "enable")
	{
		IniWrite, % (settings.features.anoints := LLK_ControlGet(cHWND)), % "ini" vars.poe_version "\config.ini", features, enable enchant finder
		Init_GUI()
		Settings_menu("anoints")
	}
	Else If (check = "update")
	{
		If vars.settings.anoint_timestamp && (A_TickCount < vars.settings.anoint_timestamp + 60000)
		{
			LLK_ToolTip(Lang_Trans("global_updatewait"), 2,,,, "Yellow")
			Return
		}
		vars.settings.anoint_timestamp := A_TickCount
		Try file := HTTPtoVar("https://raw.githubusercontent.com/Lailloken/Exile-UI/refs/heads/" (settings.general.dev_env ? "dev" : "main") "/data/english/anoints" StrReplace(vars.poe_version, " ", "%20") ".json")

		If file
			Try database := json.load(file)
		If !IsObject(database)
		{
			LLK_ToolTip(Lang_Trans("global_fail"),,,,, "Red")
			Return
		}
		file_new := FileOpen("data\english\anoints" vars.poe_version ".json", "w", "UTF-8-RAW")
		file_new.Write(file "`r`n"), file_new.Close(), db.anoints := ""
		Settings_menu("anoints"), LLK_ToolTip(Lang_Trans("global_success"),,,,, "Lime")
	}
	Else If InStr(check, "font_")
	{
		While GetKeyState("LButton", "P")
		{
			If (control = "reset")
				settings.anoints.fSize := settings.general.fSize
			Else settings.anoints.fSize += (control = "minus") ? -1 : 1, settings.anoints.fSize := (settings.anoints.fSize < 6) ? 6 : settings.anoints.fSize
			GuiControl, Text, % vars.hwnd.settings.font_reset, % settings.anoints.fSize
			Sleep 150
		}
		IniWrite, % settings.anoints.fSize, % "ini" vars.poe_version "\anoints.ini", settings, font-size
		LLK_FontDimensions(settings.anoints.fSize, height, width), settings.anoints.fWidth := width, settings.anoints.fHeight := height
		If WinExist("ahk_id " vars.hwnd.anoints.main)
			Anoints()
	}
}

Settings_betrayal()
{
	local
	global vars, settings

	GUI := "settings_menu" vars.settings.GUI_toggle
	Gui, %GUI%: Add, Link, % "Section x" vars.settings.x_anchor " y" vars.settings.ySelection, <a href="https://github.com/Lailloken/Lailloken-UI/wiki/Betrayal-Info">wiki page</a>

	Gui, %GUI%: Add, Checkbox, % "xs y+"vars.settings.spacing " Section gSettings_betrayal2 HWNDhwnd Checked"settings.features.betrayal, % Lang_Trans("m_betrayal_enable")
	vars.hwnd.settings.enable := vars.hwnd.help_tooltips["settings_betrayal enable"] := hwnd

	If !settings.features.betrayal
		Return

	Gui, %GUI%: Add, Checkbox, % "xs Section gSettings_betrayal2 HWNDhwnd Checked"settings.betrayal.ruthless, % Lang_Trans("m_betrayal_ruthless")
	vars.hwnd.settings.ruthless := vars.hwnd.help_tooltips["settings_betrayal ruthless"] := hwnd

	Gui, %GUI%: Font, % "underline bold"
	Gui, %GUI%: Add, Text, % "xs Section y+"vars.settings.spacing, % Lang_Trans("m_betrayal_recognition", 1)
	Gui, %GUI%: Font, % "norm"

	Gui, %GUI%: Add, Text, % "xs Section BackgroundTrans Border gSettings_betrayal2 HWNDhwnd", % " " Lang_Trans("global_imgfolder") " "
	vars.hwnd.settings.folder := hwnd, vars.hwnd.help_tooltips["settings_betrayal folder"] := hwnd

	Gui, %GUI%: Font, % "underline bold"
	Gui, %GUI%: Add, Text, % "xs Section y+"vars.settings.spacing, % Lang_Trans("global_ui")
	Gui, %GUI%: Font, % "norm"

	Gui, %GUI%: Add, Text, % "xs Section HWNDhwnd0", % Lang_Trans("global_font")
	Gui, %GUI%: Add, Text, % "ys x+"settings.general.fWidth/2 " Center HWNDhwnd gSettings_betrayal2 Border w"settings.general.fWidth*2, % "–"
	vars.hwnd.settings.mFont := hwnd, vars.hwnd.help_tooltips["settings_font-size"] := hwnd0, vars.hwnd.help_tooltips["settings_font-size|"] := hwnd
	Gui, %GUI%: Add, Text, % "ys x+"settings.general.fWidth/4 " Center HWNDhwnd gSettings_betrayal2 Border w"settings.general.fWidth*3, % settings.betrayal.fSize
	vars.hwnd.settings.rFont := hwnd, vars.hwnd.help_tooltips["settings_font-size||"] := hwnd
	Gui, %GUI%: Add, Text, % "ys x+"settings.general.fWidth/4 " Center HWNDhwnd gSettings_betrayal2 Border w"settings.general.fWidth*2, % "+"
	vars.hwnd.settings.pFont := hwnd, vars.hwnd.help_tooltips["settings_font-size|||"] := hwnd

	Gui, %GUI%: Add, Text, % "xs Section HWNDhwnd0", % Lang_Trans("m_betrayal_colors")
	Loop 3
	{
		Gui, %GUI%: Add, Text, % "ys x+" settings.general.fWidth/(A_Index = 1 ? 2 : 4) " Center HWNDhwnd gSettings_betrayal2 Border c"settings.betrayal.colors[A_Index], % " " Lang_Trans("global_tier") " " A_Index " "
		handle .= "|", vars.hwnd.settings["tier"A_Index] := hwnd, vars.hwnd.help_tooltips["settings_betrayal color"] := hwnd0, vars.hwnd.help_tooltips["settings_betrayal color"handle] := hwnd
	}

	Gui, %GUI%: Font, % "underline bold"
	Gui, %GUI%: Add, Text, % "xs Section y+"vars.settings.spacing, % Lang_Trans("m_betrayal_rewards")
	Gui, %GUI%: Add, Pic, % "ys hp w-1 BackgroundTrans HWNDhwnd", % "HBitmap:*" vars.pics.global.help
	vars.hwnd.help_tooltips["settings_betrayal rewards"] := hwnd
	Gui, %GUI%: Font, % "norm"
	wMembers := []
	For key in vars.betrayal.members ; create an array with every member in order to find the widest
		wMembers.Push(Lang_Trans("betrayal_" key))
	LLK_PanelDimensions(wMembers, settings.betrayal.fSize, width, height)

	For member_loc, member in vars.betrayal.members_localized
	{
		If (A_Index = 1)
			pos := "Section xs"
		Else If Mod(A_Index - 1, 6)
			pos := "xs y+"settings.general.fWidth/4
		Else pos := "Section ys x+"settings.general.fWidth/4
		Gui, %GUI%: Add, Text, % pos " Border gSettings_betrayal2 HWNDhwnd w"width, % " " Lang_Trans("betrayal_" member)
		vars.hwnd.settings[member] := hwnd
		ControlGetPos, xLast, yLast, wLast, hLast,, ahk_id %hwnd%
		yMax := (yLast + hLast > yMax) ? yLast + hLast : yMax
	}

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "Section xs x" vars.settings.x_anchor " Center y" yMax + vars.settings.spacing, % Lang_Trans("global_databaseinfo") . Lang_Trans("global_colon")
	Gui, %GUI%: Font, norm
	Gui, %GUI%: Add, Text, % "Section xs Center", % Lang_Trans("global_current") . Lang_Trans("global_colon") " " vars.betrayal.timestamp " "
	Gui, %GUI%: Add, Pic, % "ys x+0 hp-2 w-1 Border BackgroundTrans HWNDhwnd gSettings_betrayal2", % "HBitmap:*" vars.pics.global.reload
	vars.hwnd.settings.update := vars.hwnd.help_tooltips["settings_betrayal update"] := hwnd
}

Settings_betrayal2(cHWND := "")
{
	local
	global vars, settings, json

	check := LLK_HasVal(vars.hwnd.settings, cHWND), divisions := {"t": "transportation", "f": "fortification", "r": "research", "i": "intervention"}

	If (check = "enable")
	{
		settings.features.betrayal := LLK_ControlGet(cHWND)
		IniWrite, % settings.features.betrayal, ini\config.ini, Features, enable betrayal-info
		Settings_menu("betrayal-info")
	}
	Else If (check = "ruthless")
	{
		settings.betrayal.ruthless := LLK_ControlGet(cHWND)
		IniWrite, % settings.betrayal.ruthless, ini\betrayal info.ini, settings, ruthless
		Init_betrayal(), Settings_menu("betrayal-info")
	}
	Else If (check = "folder")
	{
		If FileExist("img\Recognition ("vars.client.h "p)\Betrayal\")
			Run, % "explore img\Recognition ("vars.client.h "p)\Betrayal\"
		Else LLK_ToolTip(Lang_Trans("cheat_filemissing"))
	}
	Else If InStr(check, "font")
	{
		While GetKeyState("LButton", "P")
		{
			If (SubStr(check, 1, 1) = "m") && (settings.betrayal.fSize > 6)
				settings.betrayal.fSize -= 1
			Else If (SubStr(check, 1, 1) = "r")
				settings.betrayal.fSize := settings.general.fSize
			Else If (SubStr(check, 1, 1) = "p")
				settings.betrayal.fSize += 1
			GuiControl, text, % vars.hwnd.settings.rFont, % settings.betrayal.fSize
			Sleep 150
		}
		IniWrite, % settings.betrayal.fSize, ini\betrayal info.ini, settings, font-size
		LLK_FontDimensions(settings.betrayal.fSize, height, width), settings.betrayal.fWidth := width, settings.betrayal.fHeight := height
	}
	Else If InStr(check, "tier")
	{
		If (vars.system.click = 1)
			picked_rgb := RGB_Picker(settings.betrayal.colors[StrReplace(check, "tier")])
		If (vars.system.click = 1) && Blank(picked_rgb)
			Return
		Else color := (vars.system.click = 2) ? settings.betrayal.dColors[StrReplace(check, "tier")] : picked_rgb
		GuiControl, +c%color%, % cHWND
		GuiControl, movedraw, % cHWND
		IniWrite, % color, ini\betrayal info.ini, settings, % "rank "StrReplace(check, "tier") " color"
		settings.betrayal.colors[StrReplace(check, "tier")] := color
	}
	Else If vars.betrayal.members.HasKey(check)
	{
		Betrayal_Info(check)
		KeyWait, LButton
		vars.hwnd.betrayal_info.active := "", LLK_Overlay(vars.hwnd.betrayal_info.main, "destroy")
	}
	Else If (check = "update")
	{
		If vars.settings.betrayal_timestamp && (A_TickCount < vars.settings.betrayal_timestamp + 60000)
		{
			LLK_ToolTip(Lang_Trans("global_updatewait"), 2,,,, "Yellow")
			Return
		}
		vars.settings.betrayal_timestamp := A_TickCount
		Try file := HTTPtoVar("https://raw.githubusercontent.com/Lailloken/Exile-UI/refs/heads/" (settings.general.dev_env ? "dev" : "main") "/data/english/Betrayal.json")

		If file
			Try database := json.load(file)
		If !IsObject(database)
		{
			LLK_ToolTip(Lang_Trans("global_fail"),,,,, "Red")
			Return
		}
		file_new := FileOpen("data\english\Betrayal.json", "w", "UTF-8-RAW")
		file_new.Write(file "`r`n"), file_new.Close()
		Init_betrayal()
		Settings_menu("betrayal-info"), LLK_ToolTip(Lang_Trans("global_success"),,,,, "Lime")
	}
	Else LLK_ToolTip("no action")
}

Settings_cheatsheets()
{
	local
	global vars, settings

	GUI := "settings_menu" vars.settings.GUI_toggle, Init_cheatsheets()
	Gui, %GUI%: Add, Link, % "Section x" vars.settings.x_anchor " y" vars.settings.ySelection, <a href="https://github.com/Lailloken/Lailloken-UI/wiki/Cheat-sheet-Overlay-Toolkit">wiki page</a>

	Gui, %GUI%: Add, Checkbox, % "xs y+"vars.settings.spacing " Section gSettings_cheatsheets2 HWNDhwnd Checked"settings.features.cheatsheets, % Lang_Trans("m_cheat_enable")
	vars.hwnd.settings.feature := hwnd, vars.hwnd.help_tooltips["settings_cheatsheets enable"] := hwnd
	If !settings.features.cheatsheets
		Return

	Gui, %GUI%: Font, % "underline bold"
	Gui, %GUI%: Add, Text, % "xs Section y+"vars.settings.spacing, % Lang_Trans("m_cheat_hotkeys")
	Gui, %GUI%: Font, % "norm"

	Gui, %GUI%: Add, Text, % "xs Section HWNDhwnd0", % Lang_Trans("m_cheat_modifier")
	Loop, Parse, % "alt, ctrl, shift", `,, %A_Space%
	{
		Gui, %GUI%: Add, Radio, % "ys x+" (A_Index = 1 ? settings.general.fWidth/2 : 0) " hp HWNDhwnd gSettings_cheatsheets2 checked"(settings.cheatsheets.modifier = A_LoopField ? 1 : 0), % Lang_Trans("m_cheat_modifier", A_Index + 1)
		handle .= "|", vars.hwnd.settings["modifier_"A_LoopField] := hwnd, vars.hwnd.help_tooltips["settings_cheatsheets modifier-key"] := hwnd0, vars.hwnd.help_tooltips["settings_cheatsheets modifier-key"handle] := hwnd
	}

	If vars.cheatsheets.count_advanced
	{
		Gui, %GUI%: Font, bold underline
		Gui, %GUI%: Add, Text, % "xs Section BackgroundTrans y+"vars.settings.spacing, % Lang_Trans("global_ui") " " Lang_Trans("m_cheat_advance")
		Gui, %GUI%: Font, norm

		Loop 4
		{
			style := (A_Index = 1) ? "xs Section" : "ys x+"settings.general.fWidth/4, handle1 .= "|"
			Gui, %GUI%: Add, Text, % style " Center Border HWNDhwnd gSettings_cheatsheets2 c"settings.cheatsheets.colors[A_Index], % " " Lang_Trans("global_color")" " A_Index " "
			vars.hwnd.settings["color"A_Index] := hwnd, vars.hwnd.help_tooltips["settings_cheatsheets color"handle1] := hwnd
		}

		Gui, %GUI%: Add, Text, % "xs Section BackgroundTrans HWNDhwnd0", % Lang_Trans("global_font")
		Gui, %GUI%: Add, Text, % "ys x+" settings.general.fWidth/2 " Center HWNDhwnd Border gSettings_cheatsheets2 w"settings.general.fWidth*2, % "–"
		vars.hwnd.help_tooltips["settings_font-size"] := hwnd0, vars.hwnd.settings.font_minus := hwnd, vars.hwnd.help_tooltips["settings_font-size|"] := hwnd
		Gui, %GUI%: Add, Text, % "ys x+"settings.general.fWidth/4 " Center HWNDhwnd Border gSettings_cheatsheets2 w"settings.general.fWidth*3, % settings.cheatsheets.fSize
		vars.hwnd.settings.font_reset := hwnd, vars.hwnd.help_tooltips["settings_font-size||"] := hwnd
		Gui, %GUI%: Add, Text, % "ys x+"settings.general.fWidth/4 " Center HWNDhwnd Border gSettings_cheatsheets2 w"settings.general.fWidth*2, % "+"
		vars.hwnd.settings.font_plus := hwnd, vars.hwnd.help_tooltips["settings_font-size|||"] := hwnd
	}

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "xs Section y+"vars.settings.spacing, % Lang_Trans("m_cheat_create")
	Gui, %GUI%: Font, norm
	Gui, %GUI%: Add, Text, % "xs Section BackgroundTrans", % Lang_Trans("global_name")
	Gui, %GUI%: Font, % "s"settings.general.fSize - 4
	Gui, %GUI%: Add, Edit, % "ys x+" settings.general.fWidth/2 " w"settings.general.fWidth*10 " cBlack HWNDhwnd",
	vars.hwnd.settings.name := hwnd
	Gui, %GUI%: Font, % "s"settings.general.fSize
	Gui, %GUI%: Add, Text, % "ys HWNDhwnd0 x+"settings.general.fWidth, % Lang_Trans("global_type")
	Gui, %GUI%: Font, % "s"settings.general.fSize - 4
	Gui, %GUI%: Add, DDL, % "ys hp x+" settings.general.fWidth/2 " w"settings.general.fWidth*8 " r10 AltSubmit cBlack HWNDhwnd", % Lang_Trans("m_cheat_images") "||" Lang_Trans("m_cheat_app") "|" Lang_Trans("m_cheat_advanced") "|"
	vars.hwnd.help_tooltips["settings_cheatsheets types"] := hwnd0, vars.hwnd.settings.type := hwnd, vars.hwnd.help_tooltips["settings_cheatsheets types|"] := hwnd
	Gui, %GUI%: Font, % "s"settings.general.fSize
	Gui, %GUI%: Add, Text, % "ys hp Border gSettings_cheatsheets2 HWNDhwnd", % " " Lang_Trans("global_add") " "
	vars.hwnd.settings.add := hwnd, handle := ""

	For cheatsheet in vars.cheatsheets.list
	{
		If (A_Index = 1)
		{
			Gui, %GUI%: Font, bold underline
			Gui, %GUI%: Add, Text, % "xs Section BackgroundTrans y+"vars.settings.spacing, % Lang_Trans("m_cheat_list")
			Gui, %GUI%: Font, norm
		}

		If !IsNumber(vars.cheatsheets.list[cheatsheet].enable)
			vars.cheatsheets.list[cheatsheet].enable := LLK_IniRead("cheat-sheets" vars.poe_version "\" cheatsheet "\info.ini", "general", "enable", 1)
		color := !vars.cheatsheets.list[cheatsheet].enable ? " cGray" : !FileExist("cheat-sheets" vars.poe_version "\" cheatsheet "\[check].*") ? " cRed" : "", handle .= "|"
		Gui, %GUI%: Add, Text, % "xs Section border HWNDhwnd y+"settings.general.fSize*0.4 color (vars.cheatsheets.list[cheatsheet].enable ? " gSettings_cheatsheets2" : ""), % " " Lang_Trans("global_calibrate") " "
		vars.hwnd.settings["calibrate_"cheatsheet] := hwnd, vars.hwnd.help_tooltips["settings_cheatsheets calibrate"handle] := (color = " cGray") ? "" : hwnd
		color := !vars.cheatsheets.list[cheatsheet].enable ? " cGray" : !vars.cheatsheets.list[cheatsheet].x1 ? " cRed" : ""
		Gui, %GUI%: Add, Text, % "ys x+"settings.general.fSize/4 " border HWNDhwnd" color (vars.cheatsheets.list[cheatsheet].enable ? " gSettings_cheatsheets2" : ""), % " " Lang_Trans("global_test") " "
		vars.hwnd.settings["test_"cheatsheet] := hwnd, vars.hwnd.help_tooltips["settings_cheatsheets test"handle] := (color = " cGray") ? "" : hwnd
		Gui, %GUI%: Add, Text, % "ys x+"settings.general.fSize/4 " border HWNDhwnd gSettings_cheatsheets2", % " " Lang_Trans("global_edit") " "
		vars.hwnd.settings["edit_"cheatsheet] := hwnd, vars.hwnd.help_tooltips["settings_cheatsheets edit"handle] := hwnd
		Gui, %GUI%: Add, Text, % "ys x+"settings.general.fSize/4 " border BackgroundTrans gSettings_cheatsheets2 HWNDhwnd0", % " " Lang_Trans("global_delete", 2) " "
		Gui, %GUI%: Add, Progress, % "xp yp wp hp border BackgroundBlack Disabled cRed range0-500 HWNDhwnd", 0
		vars.hwnd.settings["delbar_"cheatsheet] := vars.hwnd.help_tooltips["settings_cheatsheets delete"handle] := hwnd, vars.hwnd.settings["delete_"cheatsheet] := hwnd0
		Gui, %GUI%: Add, Text, % "ys x+"settings.general.fSize/4 " Center gSettings_cheatsheets2 Border HWNDhwnd", % " " Lang_Trans("global_info") " "
		vars.hwnd.settings["info_"cheatsheet] := vars.hwnd.help_tooltips["settings_cheatsheets info"handle] := hwnd
		Gui, %GUI%: Add, Checkbox, % "ys gSettings_cheatsheets2 HWNDhwnd c"(!vars.cheatsheets.list[cheatsheet].enable ? "Gray" : "White") " Checked"vars.cheatsheets.list[cheatsheet].enable, % cheatsheet
		vars.hwnd.settings["enable_"cheatsheet] := vars.hwnd.help_tooltips["settings_cheatsheets toggle"handle] := hwnd
	}
}

Settings_cheatsheets2(cHWND)
{
	local
	global vars, settings

	check := LLK_HasVal(vars.hwnd.settings, cHWND), control := SubStr(check, InStr(check, "_") + 1)

	If (check = "feature") ;toggling the feature on/off
	{
		IniWrite, % LLK_ControlGet(cHWND), % "ini" vars.poe_version "\config.ini", features, enable cheat-sheets
		settings.features.cheatsheets := LLK_ControlGet(cHWND)
		If !settings.features.cheatsheets
			LLK_Overlay(vars.hwnd.cheatsheet.main, "hide"), LLK_Overlay(vars.hwnd.cheatsheet_menu.main, "hide")
		Settings_menu("cheat-sheets")
	}
	Else If (check = "add") ;adding a new sheet
		Cheatsheet_Add(LLK_ControlGet(vars.hwnd.settings.name), LLK_ControlGet(vars.hwnd.settings.type))
	Else If (check = "quick") ;toggling the quick-access feature
	{
		settings.cheatsheets.quick := LLK_ControlGet(cHWND)
		IniWrite, % settings.cheatsheets.quick, % "ini" vars.poe_version "\cheat-sheets.ini", settings, quick access
	}
	Else If InStr(check, "modifier_") ;setting the omni-key modifier
	{
		If (settings.cheatsheets.modifier = control)
			Return
		settings.cheatsheets.modifier := control
		IniWrite, % control, % "ini" vars.poe_version "\cheat-sheets.ini", settings, modifier-key
	}
	Else If InStr(check, "color") ;applying a text-color
	{
		control := StrReplace(check, "color")
		If (vars.system.click = 1)
			picked_rgb := RGB_Picker(settings.cheatsheets.colors[control])
		If (vars.system.click = 1) && Blank(picked_rgb)
			Return
		Else color := (vars.system.click = 2) ? settings.cheatsheets.dColors[control] : picked_rgb
		GuiControl, +c%color%, % cHWND
		GuiControl, movedraw, % cHWND
		IniWrite, % color, % "ini" vars.poe_version "\cheat-sheets.ini", UI, % "rank "control " color"
		settings.cheatsheets.colors[control] := color
	}
	Else If InStr(check, "font_") ;resizing the font
	{
		While GetKeyState("LButton", "P")
		{
			If (control = "minus") && (settings.cheatsheets.fSize > 6)
				settings.cheatsheets.fSize -= 1
			Else If (control = "reset")
				settings.cheatsheets.fSize := settings.general.fSize
			Else If (control = "plus")
				settings.cheatsheets.fSize += 1
			GuiControl, text, % vars.hwnd.settings.font_reset, % settings.cheatsheets.fSize
			Sleep 150
		}
		IniWrite, % settings.cheatsheets.fSize, % "ini" vars.poe_version "\cheat-sheets.ini", settings, font-size
		LLK_FontDimensions(settings.cheatsheets.fSize, font_width, font_height), settings.cheatsheets.fWidth := font_width, settings.cheatsheets.fHeight := font_height
		LLK_ToolTip("sample text:`nle toucan has arrived", 2, vars.general.xMouse, vars.general.yMouse,,, settings.cheatsheets.fSize, "center")
	}
	Else If InStr(check, "calibrate_") ;clicking calibrate
	{
		pBitmap := Screenchecks_ImageRecalibrate()
		If (pBitmap > 0)
		{
			Gdip_SaveBitmapToFile(pBitmap, "cheat-sheets" vars.poe_version "\" control "\[check].bmp", 100)
			Gdip_DisposeImage(pBitmap)
			IniDelete, % "cheat-sheets" vars.poe_version "\" control "\info.ini", image search
			Settings_menu("cheat-sheets")
		}
	}
	Else If InStr(check, "test_")
	{
		If Cheatsheet_Search(control)
		{
			;Settings_menu("cheat-sheets")
			GuiControl, +cWhite, % vars.hwnd.settings["test_"control]
			GuiControl, movedraw, % vars.hwnd.settings["test_"control]
			Init_cheatsheets()
			LLK_ToolTip(Lang_Trans("global_positive"),,,,, "Lime")
		}
	}
	Else If InStr(check, "info_")
		Cheatsheet_Info(control)
	Else If InStr(check, "edit_")
		Cheatsheet_Menu(control)
	Else If InStr(check, "delete_")
	{
		If LLK_Progress(vars.hwnd.settings["delbar_"control], "LButton", cHWND)
		{
			FileRemoveDir, % "cheat-sheets" vars.poe_version "\" control "\", 1
			Settings_menu("cheat-sheets")
			KeyWait, LButton
		}
		Else Return
	}
	Else If InStr(check, "enable_")
	{
		vars.cheatsheets.list[control].enable := LLK_ControlGet(vars.hwnd.settings[check])
		IniWrite, % vars.cheatsheets.list[control].enable, % "cheat-sheets" vars.poe_version "\" control "\info.ini", general, enable
		Settings_menu("cheat-sheets")
	}
	Else LLK_ToolTip("no action")
}

Settings_cloneframes()
{
	local
	global vars, settings

	Init_cloneframes()
	GUI := "settings_menu" vars.settings.GUI_toggle, x_anchor := vars.settings.x_anchor, xMargin := settings.general.fWidth * 0.75
	Gui, %GUI%: Add, Link, % "Section x" x_anchor " y" vars.settings.ySelection, <a href="https://github.com/Lailloken/Lailloken-UI/wiki/Clone-frames">wiki page</a>

	If vars.general.MultiThreading && (vars.cloneframes.list.Count() > 1)
	{
		Gui, %GUI%: Font, bold underline
		Gui, %GUI%: Add, Text, % "xs Section y+"vars.settings.spacing, % Lang_Trans("m_clone_performance")
		Gui, %GUI%: Font, norm
		Gui, %GUI%: Add, Pic, % "ys HWNDhwnd hp w-1", % "HBitmap:*" vars.pics.global.help
		vars.hwnd.help_tooltips["settings_cloneframes performance"] := hwnd
		For index, val in ["low", "normal", "high", "max"]
		{
			Gui, %GUI%: Add, Radio, % (index = 1 ? "xs Section" : "ys x+0") " HWNDhwnd gSettings_cloneframes2" (index = settings.cloneframes.speed ? " Checked" : "")
			, % Lang_Trans("m_clone_performance", 2 + index) " (" (index = 3 ? 20 : (index = 4 ? 30 : index * 5)) ")"
			vars.hwnd.settings["performance_" index] := hwnd
		}
		Gui, %GUI%: Add, Text, % "xs Section", % Lang_Trans("m_clone_performance", 2)
		Gui, %GUI%: Add, Text, % "ys x+0 HWNDhwnd", % "100"
		vars.hwnd.settings.fps := hwnd
	}

	wMax := settings.general.fWidth * 20
	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "xs Section HWNDhwnd -Wrap y+" vars.settings.spacing, % Lang_Trans("m_clone_list")
	ControlGetPos, xHeader, yHeader, wHeader, hHeader,, % "ahk_id " hwnd
	Gui, %GUI%: Font, norm
	LLK_PanelDimensions([Lang_Trans("global_edit")], settings.general.fSize, width1, height1), width0 := Floor(width0), width1 := Floor(width1)
	Gui, %GUI%: Font, % "s"settings.general.fSize - 4
	Gui, %GUI%: Add, Edit, % "xs Section hp cBlack HWNDhwnd w" Max(wMax, wHeader)
	vars.hwnd.settings.name := hwnd, vars.hwnd.help_tooltips["settings_cloneframes new"] := hwnd
	ControlGetPos, xLast, yLast, wLast, hLast,, % "ahk_id " hwnd
	Gui, %GUI%: Add, Button, % "xp yp wp hp Hidden Default gSettings_cloneframes2 HWNDhwnd", % "ok"
	vars.hwnd.settings.add := hwnd
	Gui, %GUI%: Font, % "s"settings.general.fSize

	For cloneframe, val in vars.cloneframes.list
	{
		If (cloneframe = "settings_cloneframe")
			Continue
		Gui, %GUI%: Add, Text, % "xs Section Border Center gSettings_cloneframes2 HWNDhwnd w" width1, % Lang_Trans("global_edit")
		handle .= "|", vars.hwnd.settings["edit_"cloneframe] := vars.hwnd.help_tooltips["settings_cloneframes edit"handle] := hwnd
		Gui, %GUI%: Add, Text, % "ys hp x+-1 Border gSettings_cloneframes2 BackgroundTrans Center HWNDhwnd0 w" settings.general.fWidth*2, % "x"
		Gui, %GUI%: Add, Progress, % "xp yp wp hp Border Disabled BackgroundBlack range0-500 cRed HWNDhwnd", 0
		vars.hwnd.settings["delbar_"cloneframe] := vars.hwnd.help_tooltips["settings_cloneframes delete"handle] := hwnd, vars.hwnd.settings["del_"cloneframe] := hwnd0
		Gui, %GUI%: Add, Checkbox, % "ys gSettings_cloneframes2 hp -Wrap HWNDhwnd Checked"val.enable " c"(val.enable ? "White" : "Gray") " w" Max(wMax, wHeader) - width1 - settings.general.fWidth*2.85, % cloneframe
		vars.hwnd.settings["enable_"cloneframe] := vars.hwnd.help_tooltips["settings_cloneframes toggle"handle] := hwnd
		ControlGetPos, xLast, yLast, wLast, hLast,, % "ahk_id " hwnd
	}

	If (vars.cloneframes.list.Count() = 1)
		Return

	Gui, %GUI%: Add, Progress, % "Disabled Section BackgroundWhite x" xHeader + Max(wMax, wHeader) + xMargin " y" yHeader - 1 " w1 h" (hDivider := yLast + hLast - yHeader), 0
	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "Section ys", % Lang_Trans("m_clone_toggle")
	Gui, %GUI%: Font, % "norm s" settings.general.fSize - 4
	Gui, %GUI%: Add, DDL, % "ys hp w" settings.general.fWidth*7 " r2 AltSubmit gSettings_cloneframes2 HWNDhwnd Choose" settings.cloneframes.toggle, % Lang_Trans("global_global") "|" Lang_Trans("global_custom")
	;Gui, %GUI%: Add, Pic, % "ys hp w-1 BackgroundTrans HWNDhwnd", % "HBitmap:*" vars.pics.global.help
	vars.hwnd.settings.toggle := vars.hwnd.help_tooltips["settings_cloneframes toggle-info"] := hwnd, handle := ""
	Gui, %GUI%: Font, % "s" settings.general.fSize

	LLK_PanelDimensions([Lang_Trans("global_inventory"), Lang_Trans("global_ignore") " ", Lang_Trans("global_hide") " ", Lang_Trans("global_show") " "], settings.general.fSize, wHeader1max, hHeader1max,,, 0)
	LLK_PanelDimensions([Lang_Trans("m_screen_gamescreen"), Lang_Trans("global_ignore") " ", Lang_Trans("global_hide") " ", Lang_Trans("global_show") " "], settings.general.fSize, wHeader2max, hHeader2max,,, 0)
	Gui, %GUI%: Add, Text, % "Section xs HWNDhwnd Center w" wHeader1max, % Lang_Trans("global_inventory")
	ControlGetPos, xHeader1, yHeader1, wHeader1, hHeader1,, % "ahk_id " hwnd
	Gui, %GUI%: Font, % "s" settings.general.fSize - 4
	For key, val in (settings.cloneframes.toggle = 2 ? vars.cloneframes.list : {"global": {"inventory": settings.cloneframes.inventory}})
	{
		If (key = "settings_cloneframe")
			Continue
		Gui, %GUI%: Add, DDL, % "xs wp hp r3 AltSubmit HWNDhwnd gSettings_cloneframes2 Choose" val.inventory + 1, % Lang_Trans("global_ignore") "|" Lang_Trans("global_hide") "|" Lang_Trans("global_show")
		ControlGetPos, xLast1, yLast1, wLast1, hLast1,, % "ahk_id " hwnd
		vars.hwnd.settings["inventory_" key] := vars.hwnd.help_tooltips["settings_cloneframes toggle-modes" handle] := hwnd, handle .= "|"
	}
	Gui, %GUI%: Font, % "s" settings.general.fSize

	If !vars.poe_version
	{
		Gui, %GUI%: Add, Progress, % "Disabled Section ys BackgroundWhite w1 h" yLast1 + hLast1 - (yHeader + hHeader) - settings.general.fHeight/4, 0
		Gui, %GUI%: Add, Text, % "Section ys Center w" wHeader2max, % Lang_Trans("m_screen_gamescreen")
		Gui, %GUI%: Font, % "s" settings.general.fSize - 4
		For key, val in (settings.cloneframes.toggle = 2 ? vars.cloneframes.list : {"global": {"gamescreen": settings.cloneframes.gamescreen}})
		{
			If (key = "settings_cloneframe")
				Continue
			Gui, %GUI%: Add, DDL, % "xs wp hp r3 AltSubmit HWNDhwnd gSettings_cloneframes2 Choose" val.gamescreen + 1, % Lang_Trans("global_ignore") "|" Lang_Trans("global_hide") "|" Lang_Trans("global_show")
			handle .= "|", vars.hwnd.settings["gamescreen_" key] := vars.hwnd.help_tooltips["settings_cloneframes toggle-modes" handle] := hwnd
		}
		Gui, %GUI%: Font, % "s" settings.general.fSize
	}

	LLK_PanelDimensions([Lang_Trans("global_coordinates"), Lang_Trans("global_width") "/" Lang_Trans("global_height")], settings.general.fSize, width, height)
	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "xs Section x" x_anchor " HWNDhwnd y" yLast + hLast + vars.settings.spacing, % Lang_Trans("m_clone_editing")
	colors := ["3399FF", "Yellow", "DC3220"], handle := "", vars.hwnd.settings.edit_text := vars.hwnd.help_tooltips["settings_cloneframes corners"handle] := hwnd
	Gui, %GUI%: Font, norm
	For index, val in vars.lang.global_mouse
	{
		Gui, %GUI%: Add, Text, % "ys x+"settings.general.fWidth/2 " Center BackgroundTrans Border cBlack w"settings.general.fWidth*3, % val
		Gui, %GUI%: Add, Progress, % "xp yp wp hp Border BackgroundBlack HWNDhwnd c"colors[index], 100
		handle .= "|", vars.hwnd.help_tooltips["settings_cloneframes corners"handle] := hwnd
	}
	Gui, %GUI%: Add, Text, % "xs Section c3399FF", % Lang_Trans("global_coordinates") ":"
	Gui, %GUI%: Font, % "s" settings.general.fSize - 4
	Gui, %GUI%: Add, Edit, % "ys x" x_anchor + width " hp Disabled Number cBlack Right gCloneframes_SettingsApply HWNDhwnd w"settings.general.fWidth*4, % vars.client.x + 4 - vars.monitor.x
	vars.hwnd.settings.xSource := vars.cloneframes.scroll.xSource := vars.hwnd.help_tooltips["settings_cloneframes scroll"] := hwnd
	Gui, %GUI%: Add, Edit, % "ys x+"settings.general.fWidth/4 " hp Disabled Number cBlack Right gCloneframes_SettingsApply HWNDhwnd w"settings.general.fWidth*4, % vars.client.y + 4 - vars.monitor.y
	vars.hwnd.settings.ySource := vars.cloneframes.scroll.ySource := vars.hwnd.help_tooltips["settings_cloneframes scroll|"] := hwnd
	Gui, %GUI%: Font, % "s"settings.general.fSize

	Gui, %GUI%: Add, Text, % "ys", % Lang_Trans("m_clone_scale")
	Gui, %GUI%: Font, % "s"settings.general.fSize - 4
	Gui, %GUI%: Add, Edit, % "ys x+" settings.general.fWidth/2 " hp Disabled Number cBlack Right gCloneframes_SettingsApply HWNDhwnd w"settings.general.fWidth*3, 100
	vars.hwnd.settings.xScale := vars.cloneframes.scroll.xScale := vars.hwnd.help_tooltips["settings_cloneframes scroll||||||"] := hwnd
	Gui, %GUI%: Add, Edit, % "ys x+"settings.general.fWidth/4 " hp Disabled Number cBlack Right gCloneframes_SettingsApply HWNDhwnd w"settings.general.fWidth*3, 100
	vars.hwnd.settings.yScale := vars.cloneframes.scroll.yScale := vars.hwnd.help_tooltips["settings_cloneframes scroll|||||||"] := hwnd
	Gui, %GUI%: Font, % "s"settings.general.fSize

	Gui, %GUI%: Add, Text, % "xs Section cYellow", % Lang_Trans("global_coordinates") ":"
	Gui, %GUI%: Font, % "s"settings.general.fSize - 4
	Gui, %GUI%: Add, Edit, % "ys x" x_anchor + width " hp Disabled Number cBlack Right gCloneframes_SettingsApply HWNDhwnd w"settings.general.fWidth*4, % Format("{:0.0f}", vars.client.xc - 100)
	vars.hwnd.settings.xTarget := vars.cloneframes.scroll.xTarget := vars.hwnd.help_tooltips["settings_cloneframes scroll||||"] := hwnd
	Gui, %GUI%: Add, Edit, % "ys x+"settings.general.fWidth/4 " hp Disabled Number cBlack Right gCloneframes_SettingsApply HWNDhwnd w"settings.general.fWidth*4, % vars.client.y + 13 - vars.monitor.y
	vars.hwnd.settings.yTarget := vars.cloneframes.scroll.yTarget := vars.hwnd.help_tooltips["settings_cloneframes scroll|||||"] := hwnd
	Gui, %GUI%: Font, % "s"settings.general.fSize

	Gui, %GUI%: Add, Text, % "ys", % Lang_Trans("global_opacity")
	Gui, %GUI%: Add, Text, % "ys x+" settings.general.fWidth/2 " 0x200 hp Border Center HWNDhwnd w"settings.general.fWidth*2, 5
	;Gui, %GUI%: Add, UpDown, % "ys hp Disabled range0-5 gSettings_cloneframes2 HWNDhwnd", 5
	vars.hwnd.settings.opacity := vars.cloneframes.scroll.opacity := vars.hwnd.help_tooltips["settings_cloneframes scroll||||||||"] := hwnd

	Gui, %GUI%: Add, Text, % "xs Section cDC3220", % Lang_Trans("global_width") "/" Lang_Trans("global_height") ":"
	Gui, %GUI%: Font, % "s"settings.general.fSize - 4
	Gui, %GUI%: Add, Edit, % "ys x" x_anchor + width " hp Disabled Number cBlack Right gCloneframes_SettingsApply HWNDhwnd w"settings.general.fWidth*4, % 200
	vars.hwnd.settings.width := vars.cloneframes.scroll.width := vars.hwnd.help_tooltips["settings_cloneframes scroll||"] := hwnd
	Gui, %GUI%: Add, Edit, % "ys x+"settings.general.fWidth/4 " hp Disabled Number cBlack Right gCloneframes_SettingsApply HWNDhwnd w"settings.general.fWidth*4, % 200
	vars.hwnd.settings.height := vars.cloneframes.scroll.height := vars.hwnd.help_tooltips["settings_cloneframes scroll|||"] := hwnd
	Gui, %GUI%: Font, % "s"settings.general.fSize

	Gui, %GUI%: Add, Text, % "xs Section cGray Border HWNDhwnd", % " " Lang_Trans("global_save") " "
	vars.hwnd.settings.save := hwnd
	Gui, %GUI%: Add, Text, % "ys x+"settings.general.fWidth/4 " cGray Border HWNDhwnd", % " " Lang_Trans("global_discard") " "
	vars.hwnd.settings.discard := hwnd
}

Settings_cloneframes2(cHWND)
{
	local
	global vars, settings, json

	check := LLK_HasVal(vars.hwnd.settings, cHWND), control := SubStr(check, InStr(check, "_") + 1), name := vars.cloneframes.editing

	If InStr(check, "performance_")
	{
		IniWrite, % (settings.cloneframes.speed := speed := control), % "ini" vars.poe_version "\clone frames.ini", settings, performance
		settings.cloneframes.fps := 1000//vars.cloneframes.intervals[speed], Cloneframes_Thread(1, control)
	}
	Else If (check = "add")
		Cloneframes_SettingsAdd()
	Else If InStr(check, "edit_")
		Cloneframes_SettingsRefresh(control)
	Else If InStr(check, "del_")
	{
		If vars.cloneframes.editing
		{
			LLK_ToolTip(Lang_Trans("m_clone_exitedit"), 1.5,,,, "red")
			Return
		}
		If LLK_Progress(vars.hwnd.settings["delbar_"control], "LButton", cHWND)
		{
			IniDelete, % "ini" vars.poe_version "\clone frames.ini", % control
			Settings_menu("clone-frames"), Cloneframes_Thread()
		}
		Else Return
	}
	Else If InStr(check, "enable_")
	{
		If vars.cloneframes.editing
		{
			LLK_ToolTip(Lang_Trans("m_clone_exitedit"), 1.5,,,, "red")
			GuiControl,, % cHWND, % vars.cloneframes.list[control].enable
			Return
		}
		vars.cloneframes.list[control].enable := LLK_ControlGet(cHWND)
		GuiControl, % "+c"(LLK_ControlGet(cHWND) ? "White" : "Gray"), % cHWND
		GuiControl, movedraw, % cHWND
		IniWrite, % vars.cloneframes.list[control].enable, % "ini" vars.poe_version "\clone frames.ini", % control, enable
		Init_cloneframes(), Cloneframes_Thread()
		GuiControl, % "+c" (!vars.cloneframes.enabled ? "Gray" : "White"), % vars.hwnd.settings["clone-frames"]
		GuiControl, % "movedraw", % vars.hwnd.settings["clone-frames"]
	}
	Else If (check = "toggle")
	{
		IniWrite, % LLK_ControlGet(cHWND), % "ini" vars.poe_version "\clone frames.ini", settings, toggle
		Settings_menu("clone-frames"), Cloneframes_Thread()
	}
	Else If InStr(check, "inventory_")
	{
		input := LLK_ControlGet(cHWND) - 1
		If (control = "global")
			IniWrite, % input, % "ini" vars.poe_version "\clone frames.ini", settings, inventory toggle
		Else IniWrite, % input, % "ini" vars.poe_version "\clone frames.ini", % control, inventory toggle
	}
	Else If InStr(check, "gamescreen_")
	{
		input := LLK_ControlGet(cHWND) - 1
		If (control = "global")
			IniWrite, % input, % "ini" vars.poe_version "\clone frames.ini", settings, gamescreen toggle
		Else IniWrite, % input, % "ini" vars.poe_version "\clone frames.ini", % control, gamescreen toggle
	}
	Else If (check = "save")
		Cloneframes_SettingsSave()
	Else If (check = "discard")
		Cloneframes_SettingsRefresh()
	Else If (check = "opacity")
	{
		vars.cloneframes.list[name].opacity := LLK_ControlGet(cHWND)
		If vars.general.MultiThreading
			StringSend("clone-edit=" json.dump(vars.cloneframes.list[name]))
	}
	Else LLK_ToolTip("no action")

	If InStr(check, "inventory_") || InStr(check, "gamescreen_")
		Init_cloneframes(), Cloneframes_Thread()
}

Settings_donations()
{
	local
	global vars, settings, JSON
	static last_update, live_list, patterns := [["000000", "F99619"], ["000000", "F05A23"], ["FFFFFF", "F05A23"], ["Red", "FFFFFF"]]
	, placeholder := "these are placeholders, not actual donations:`ncouldn't download the list, or it doesn't exist yet"

	If !vars.settings.donations
		vars.settings.donations := {"Le Toucan": [1, ["june 17, 2024:`ni have arrived. caw, caw"]], "Lightwoods": [4, ["december 23, 2015:`ni can offer you 2 exalted orbs for your mirror", "december 23, 2015:`nsince i'm feeling happy today, i'll give you some maps on top", "december 23, 2015:`n<necropolis map> 5 of these?"]], "Average Redditor": [1, ["june 18, 2024:`nbruh, just enjoy the game"]], "Sanest Redditor": [3, ["august 5, 2023:`nyassss keep making more powerful and intrusive tools so ggg finally bans all ahk scripts"]], "ILoveLootsy": [2, ["february 1, 2016:`ndang yo"]]}

	If (last_update + 120000 < A_TickCount)
	{
		Try donations_new := HTTPtoVar("https://raw.githubusercontent.com/Lailloken/Lailloken-UI/" (settings.general.dev_env ? "dev" : "main") "/img/readme/donations.json")
		If (SubStr(donations_new, 1, 1) . SubStr(donations_new, 0) = "{}")
			vars.settings.donations := JSON.load(donations_new), live_list := 1
	}

	last_update := A_TickCount, dimensions := ["`n"], rearrange := []
	For key, val in vars.settings.donations
		If !val.0
			new_key := LLK_PanelDimensions([StrReplace(key, "|")], settings.general.fSize, width0, height0,,,, 1), dimensions.Push(new_key), rearrange.Push([key, new_key])
		Else dimensions.Push(key)

	For index, val in rearrange
	{
		If (val.1 != val.2)
			vars.settings.donations[val.2] := vars.settings.donations[val.1].Clone(), vars.settings.donations.Delete(val.1)
		vars.settings.donations[val.2].0 := 1
	}

	LLK_PanelDimensions(dimensions, settings.general.fSize - 2, width, height), LLK_PanelDimensions([placeholder], settings.general.fSize, wPlaceholder, hPlaceholder,,, 0)
	columns := wPlaceholder//width
	GUI := "settings_menu" vars.settings.GUI_toggle, x_anchor := vars.settings.x_anchor
	Gui, %GUI%: Add, Text, % "Section x" x_anchor " y" vars.settings.yselection, special thanks to these people for donating:
	Gui, %GUI%: Font, % "s" settings.general.fSize - 2
	For key, val in vars.settings.donations
	{
		pos := (A_Index = 1) || !Mod(A_Index - 1, columns) ? "xs Section" (A_Index = 1 ? " y+" vars.settings.spacing : "") : "ys"
		Gui, %GUI%: Add, Text, % pos " Center Border HWNDhwnd BackgroundTrans w" width " h" height " c" patterns[val.1].1 . (!InStr(key, "`n") ? " 0x200" : ""), % StrReplace(key, "|")
		Gui, %GUI%: Add, Progress, % "xp+3 yp+3 wp-6 hp-6 Disabled HWNDhwnd Background" patterns[val.1].2, 0
		Gui, %GUI%: Add, Progress, % "xp-3 yp-3 wp+6 hp+6 Disabled Background" patterns[val.1].1, 0
		vars.hwnd.help_tooltips["donation_" key] := hwnd
	}
	Gui, %GUI%: Font, % "s" settings.general.fSize
	If !live_list
		Gui, %GUI%: Add, Text, % "xs Section cAqua y+" vars.settings.spacing, % placeholder
	Gui, %GUI%: Add, Link, % "xs Section HWNDhwnd y+" vars.settings.spacing, <a href="https://github.com/Lailloken/Lailloken-UI/discussions/407">how to donate</a>
	vars.hwnd.help_tooltips["settings_donations howto"] := hwnd
}

Settings_general()
{
	local
	global vars, settings

	GUI := "settings_menu" vars.settings.GUI_toggle
	Gui, %GUI%: Add, Link, % "Section x" vars.settings.x_anchor " y" vars.settings.ySelection, <a href="https://github.com/Lailloken/Lailloken-UI/wiki">llk-ui wiki && setup guide</a>

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "xs Section y+"vars.settings.spacing, % Lang_Trans("m_general_settings")
	Gui, %GUI%: Font, norm

	multi := vars.general.MultiThreading
	Gui, %GUI%: Add, Text, % "ys c" (multi ? "Lime" : "Yellow"), % Lang_Trans("global_multithreading", multi ? 1 : 2)
	Gui, %GUI%: Add, Pic, % "ys HWNDhwnd hp w-1", % "HBitmap:*" vars.pics.global.help
	vars.hwnd.help_tooltips["settings_multi-threading " multi] := hwnd

	If settings.general.dev
	{
		Gui, %GUI%: Add, Checkbox, % "xs Section hp gSettings_general2 HWNDhwnd Checked" settings.general.dev_env, % "dev branch"
		vars.hwnd.settings.dev_env := hwnd
	}

	Gui, %GUI%: Add, Checkbox, % "xs Section hp gSettings_general2 HWNDhwnd Checked" settings.general.kill[1], % Lang_Trans("m_general_kill")
	vars.hwnd.settings.kill_timer := hwnd, vars.hwnd.help_tooltips["settings_kill timer"] := hwnd
	Gui, %GUI%: Font, % "s"settings.general.fsize - 4 "norm"
	Gui, %GUI%: Add, Edit, % "ys x+0 hp cBlack Number gSettings_general2 Center Limit2 HWNDhwnd w"2* settings.general.fwidth, % settings.general.kill[2]
	vars.hwnd.settings.kill_timeout := hwnd, vars.hwnd.help_tooltips["settings_kill timer|"] := hwnd
	Gui, %GUI%: Font, % "s"settings.general.fsize
	Gui, %GUI%: Add, Checkbox, % "xs Section HWNDhwnd gSettings_general2 Checked"settings.features.browser, % Lang_Trans("m_general_browser")
	vars.hwnd.settings.browser := hwnd, vars.hwnd.help_tooltips["settings_browser features"] := hwnd
	Gui, %GUI%: Add, Checkbox, % "ys HWNDhwnd gSettings_general2 Checked" settings.general.capslock, % Lang_Trans("m_general_capslock")
	vars.hwnd.settings.capslock := hwnd, vars.hwnd.help_tooltips["settings_capslock toggling"] := hwnd, check := ""

	If vars.log.file_location
	{
		dimensions := [Lang_Trans("m_general_character"), vars.log.level && settings.features.maptracker && settings.maptracker.character ? Lang_Trans("m_general_build") : ""]
		LLK_PanelDimensions(dimensions, settings.general.fSize, wChar, hChar,,, 0), wName := settings.general.fWidth2 * 18
		color := (settings.general.lang_client = "unknown" ? "Gray" : vars.log.level ? "Lime" : settings.general.character ? "Yellow" : "Red")
		Gui, %GUI%: Add, Text, % "xs Section HWNDhwnd c" color " w" wChar, % Lang_Trans("m_general_character")
		vars.hwnd.settings.character_text := hwnd
		If (settings.general.lang_client != "unknown")
			vars.hwnd.help_tooltips["settings_active character status"] := hwnd
		Else vars.hwnd.help_tooltips["settings_lang incompatible"] := hwnd

		Gui, %GUI%: Font, % "s"settings.general.fSize - 4
		Gui, %GUI%: Add, Edit, % "ys x+0 cBlack r1 hp gSettings_general2 HWNDhwnd" (settings.general.lang_client = "unknown" ? " Disabled" : "") " w" wName, % LLK_StringCase(settings.general.character)
		ControlGetPos,,,, hEdit,, % "ahk_id " (vars.hwnd.settings.character := hwnd)

		If settings.general.character && !(settings.general.lang_client = "unknown")
		{
			Gui, %GUI%: Add, Pic, % "ys x+-1 HWNDhwnd00 gSettings_general2 Border hp-2 w-1", % "HBitmap:*" vars.pics.global.reload
			vars.hwnd.settings.ascendancy := vars.hwnd.help_tooltips["settings_active character whois"] := hwnd00
		}

		If vars.log.level
		{
			Gui, %GUI%: Add, Text, % "ys x+-1 HWNDhwnd0 Border hp 0x200 Center", % " " vars.log.character_class " (" vars.log.level ") "
			ControlGetPos,,, wInfo, hInfo,, ahk_id %hwnd0%
			vars.hwnd.help_tooltips["settings_ascendancy"] := hwnd0
			If settings.features.maptracker && settings.maptracker.character
			{
				Gui, %GUI%: Font, % "s"settings.general.fSize
				Gui, %GUI%: Add, Text, % "Section xs w" wChar, % Lang_Trans("m_general_build")
				Gui, %GUI%: Font, % "s"settings.general.fSize - 4
				Gui, %GUI%: Add, Edit, % "ys x+0 cBlack r1 hp gSettings_general2 HWNDhwnd0" (settings.general.lang_client = "unknown" ? " Disabled" : "") " w" wName + wInfo + hEdit - 2, % settings.general.build
				vars.hwnd.settings.build := hwnd0, vars.hwnd.help_tooltips["settings_active build"] := hwnd0
			}
		}

		Gui, %GUI%: Font, % "s"settings.general.fSize
		If (settings.general.lang_client != "unknown")
		{
			vars.hwnd.help_tooltips["settings_active character"] := hwnd
			Gui, %GUI%: Add, Button, % "xp yp wp hp Default Hidden gSettings_general2 HWNDhwnd", % "save"
			vars.hwnd.settings.save_character := hwnd
		}
		Else vars.hwnd.help_tooltips["settings_lang incompatible|"] := hwnd
	}

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "xs Section y+"vars.settings.spacing, % Lang_Trans("global_ui")
	Gui, %GUI%: Font, norm

	Loop, Files, data\*, R
		If (A_LoopFileName = "client.txt")
			parse := StrReplace(StrReplace(A_LoopFilePath, "data\"), "\client.txt"), check .= parse "|"
	If (LLK_InStrCount(check, "|") > 1)
	{
		parse := 0
		Loop, Parse, check, |
			parse := (StrLen(A_LoopField) > parse) ? StrLen(A_LoopField) : parse
		Gui, %GUI%: Add, Text, % "xs Section HWNDhwnd00", % Lang_Trans("m_general_language") " "
		Gui, %GUI%: Font, % "s"settings.general.fSize - 4
		Gui, %GUI%: Add, DDL, % "ys x+0 HWNDhwnd0 gSettings_general2 r"LLK_InStrCount(check, "|") " w"settings.general.fWidth * parse + settings.general.fWidth, % StrReplace(check, settings.general.lang, settings.general.lang "|")
		Gui, %GUI%: Font, % "s"settings.general.fSize
		Gui, %GUI%: Add, Text, % "ys HWNDhwnd Border x+"settings.general.fWidth, % " " Lang_Trans("global_credits") " "
		vars.hwnd.help_tooltips["settings_lang language"] := vars.hwnd.settings.language := hwnd0, vars.hwnd.help_tooltips["settings_lang translators"] := hwnd, vars.hwnd.help_tooltips["settings_lang language|"] := hwnd00
	}

	Gui, %GUI%: Add, Text, % "xs Section HWNDhwnd", % Lang_Trans("global_font")
	vars.hwnd.help_tooltips["settings_font-size"] := hwnd
	Gui, %GUI%: Add, Text, % "ys gSettings_general2 Border Center HWNDhwnd w"settings.general.fWidth*2, % "–"
	vars.hwnd.settings.font_minus := hwnd, vars.hwnd.help_tooltips["settings_font-size|"] := hwnd
	Gui, %GUI%: Add, Text, % "x+" settings.general.fwidth / 4 " ys gSettings_general2 Border Center HWNDhwnd", % " " settings.general.fSize " "
	vars.hwnd.settings.font_reset := hwnd, vars.hwnd.help_tooltips["settings_font-size||"] := hwnd
	Gui, %GUI%: Add, Text, % "wp x+" settings.general.fwidth / 4 " ys gSettings_general2 Border Center HWNDhwnd w"settings.general.fWidth*2, % "+"
	vars.hwnd.settings.font_plus := hwnd, vars.hwnd.help_tooltips["settings_font-size|||"] := hwnd

	Gui, %GUI%: Add, Text, % "x+" settings.general.fwidth " ys gSettings_general2 Center HWNDhwnd w"settings.general.fWidth*2, % Lang_Trans("m_general_toolbar")
	vars.hwnd.help_tooltips["settings_font-size||||"] := hwnd
	Gui, %GUI%: Add, Text, % "ys gSettings_general2 Border Center HWNDhwnd w"settings.general.fWidth*2, % "–"
	vars.hwnd.settings.toolbar_minus := hwnd, vars.hwnd.help_tooltips["settings_font-size|||||"] := hwnd
	Gui, %GUI%: Add, Text, % "x+" settings.general.fwidth / 4 " ys gSettings_general2 Border Center HWNDhwnd", % " " settings.gui.sToolbar " "
	vars.hwnd.settings.toolbar_reset := hwnd, vars.hwnd.help_tooltips["settings_font-size||||||"] := hwnd
	Gui, %GUI%: Add, Text, % "wp x+" settings.general.fwidth / 4 " ys gSettings_general2 Border Center HWNDhwnd w"settings.general.fWidth*2, % "+"
	vars.hwnd.settings.toolbar_plus := hwnd, vars.hwnd.help_tooltips["settings_font-size|||||||"] := hwnd

	Gui, %GUI%: Add, Checkbox, % "xs Section HWNDhwnd gSettings_general2 Checked" settings.general.hide_toolbar, % Lang_Trans("m_general_hidetoolbar")
	vars.hwnd.settings.toolbar_hide := vars.hwnd.help_tooltips["settings_toolbar hide"] := hwnd

	If !vars.client.stream
	{
		Gui, %GUI%: Font, bold underline
		Gui, %GUI%: Add, Text, % "xs Section y+"vars.settings.spacing, % Lang_Trans("m_general_client", 2)
		Gui, %GUI%: Font, norm

		Gui, %GUI%: Add, Text, % "ys cLime", % "path of exile " (vars.poe_version ? 2 : 1) . (vars.general.input_method.1 = 2 ? " (" Lang_Trans("global_controller") ")" : "")
		Gui, %GUI%: Add, Text, % "xs Section", % Lang_Trans("m_general_language", 2) " "
		Gui, %GUI%: Add, Text, % "ys x+0 c" (settings.general.lang_client = "unknown" ? "Red" : "Lime"), % (settings.general.lang_client = "unknown") ? Lang_Trans("m_general_language", 3) : settings.general.lang_client

		If (settings.general.lang_client = "unknown")
		{
			Gui, %GUI%: Add, Pic, % "ys hp w-1 HWNDhwnd", % "HBitmap:*" vars.pics.global.help
			Gui, %GUI%: Add, Text, % "xs Section cRed", % "(some features will not be available)"
			vars.hwnd.help_tooltips["settings_lang unknown"] := hwnd
		}

		If !InStr("unknown,english", settings.general.lang_client)
		{
			Gui, %GUI%: Add, Text, % "ys Border HWNDhwnd", % " " Lang_Trans("global_credits") " "
			vars.hwnd.help_tooltips["settings_lang contributors"] := hwnd
		}

		Gui, %GUI%: Add, Text, % "xs Section", % Lang_Trans("m_general_display", 1) " "
		Gui, %GUI%: Add, Text, % "ys x+0 cLime HWNDhwnd", % Lang_Trans("m_general_display", (vars.client.fullscreen = "true") ? 2 : !vars.client.borderless ? 3 : 4)
		vars.hwnd.settings.window_mode := hwnd

		Gui, %GUI%: Add, Text, % "xs Section", % Lang_Trans("m_general_logfile")
		red := Min(255, Max(0, vars.log.file_size - 100)), green := 255 - red, rgb := (red < 10 ? "0" : "") . Format("{:X}", red) . (green < 10 ? "0" : "") . Format("{:X}", green) "00"
		Gui, %GUI%: Add, Text, % "ys HWNDhwnd x+0 BackgroundTrans gSettings_general2 c" rgb, % " " Max(0, Round((355-vars.log.file_size)/355*100)) "% (" vars.log.file_size " mb / " vars.log.access_time " ms) "
		Gui, %GUI%: Add, Progress, % "xp yp wp hp Disabled BackgroundBlack cRed Vertical Range0-500 HWNDhwnd1", 0
		If !vars.pics.global.folder
			vars.pics.global.folder := LLK_ImageCache("img\GUI\folder.png")
		Gui, %GUI%: Add, Pic, % "ys x+0 hp w-1 Border gSettings_general2 HWNDhwnd2", % "HBitmap:*" vars.pics.global.folder
		vars.hwnd.settings.logfile := hwnd, vars.hwnd.settings.logfile_bar := vars.hwnd.help_tooltips["settings_logfile"] := hwnd1
		vars.hwnd.settings.logfolder := vars.hwnd.help_tooltips["settings_logfolder"] := hwnd2

		Gui, %GUI%: Font, bold underline
		Gui, %GUI%: Add, Text, % "xs Section y+"vars.settings.spacing, % Lang_Trans("m_general_client")
		Gui, %GUI%: Font, norm
		Gui, %GUI%: Add, Text, % "ys Border HWNDhwnd Hidden cRed gSettings_general2", % " " Lang_Trans("global_restart") " "
		vars.hwnd.settings.apply := hwnd

		Gui, %GUI%: Add, Text, % "xs Section HWNDhwnd", % Lang_Trans("m_general_resolution")
		vars.hwnd.help_tooltips["settings_force resolution"] := hwnd
		If (vars.client.fullscreen = "true")
		{
			Gui, %GUI%: Add, Text, % "ys hp BackgroundTrans HWNDhwnd x+"settings.general.fwidth/2, % vars.monitor.w
			vars.hwnd.settings.custom_width := hwnd, vars.hwnd.help_tooltips["settings_force resolution|"] := hwnd
		}
		Else
		{
			Gui, %GUI%: Font, % "s"settings.general.fsize - 4
			Gui, %GUI%: Add, Edit, % "ys hp Limit4 Number Center cBlack BackgroundTrans gSettings_general2 HWNDhwnd x+"settings.general.fwidth/2 " w"settings.general.fWidth*4, % vars.client.w0
			vars.hwnd.settings.custom_width := hwnd, vars.hwnd.help_tooltips["settings_force resolution||"] := hwnd
			Gui, %GUI%: Font, % "s"settings.general.fsize
		}
		Gui, %GUI%: Add, Text, % "ys hp BackgroundTrans x+0", % " x "

		Gui, %GUI%: Font, % "s"settings.general.fsize - 4
		If vars.general.safe_mode
			vars.general.available_resolutions := StrReplace(vars.general.available_resolutions, vars.monitor.h "|")
		Gui, %GUI%: Add, DDL, % "ys hp BackgroundTrans HWNDhwnd gSettings_general2 r10 x+0 w"5* settings.general.fwidth, % StrReplace(vars.general.available_resolutions, vars.client.h "|", vars.client.h "||")
		vars.hwnd.settings.custom_resolution := hwnd, vars.hwnd.help_tooltips["settings_force resolution|||"] := hwnd
		Gui, %GUI%: Font, % "s"settings.general.fsize

		WinGetPos,,, wCheck, hCheck, ahk_group poe_window
		If !vars.general.safe_mode && (wCheck < vars.monitor.w || hCheck < vars.monitor.h)
		{
			Gui, %GUI%: Add, Text, % "xs Section HWNDhwnd", % Lang_Trans("m_general_position")
			vars.hwnd.help_tooltips["settings_window position"] := hwnd
			Gui, %GUI%: Font, % "s"settings.general.fsize - 4
			If (wCheck < vars.monitor.w)
			{
				Gui, %GUI%: Add, DDL, % "ys hp r3 HWNDhwnd w"Floor(settings.general.fWidth* 6.5) " gSettings_general2", % StrReplace(Lang_Trans("m_general_posleft") "|" Lang_Trans("m_general_poscenter") "|" Lang_Trans("m_general_posright") "|", Lang_Trans("m_general_pos" vars.client.docked) "|", Lang_Trans("m_general_pos" vars.client.docked) "||")
				vars.hwnd.settings.dock := hwnd, vars.hwnd.help_tooltips["settings_window position|"] := hwnd
			}
			If (hCheck < vars.monitor.h)
			{
				Gui, %GUI%: Add, DDL, % "ys hp r3 HWNDhwnd gSettings_general2" (wCheck < vars.monitor.w ? " wp" : " w"settings.general.fWidth * 6.5), % StrReplace(Lang_Trans("m_general_postop") "|" Lang_Trans("m_general_poscenter") "|" Lang_Trans("m_general_posbottom") "|", Lang_Trans("m_general_pos" vars.client.docked2) "|", Lang_Trans("m_general_pos" vars.client.docked2) "||")
				vars.hwnd.settings.dock2 := hwnd, vars.hwnd.help_tooltips["settings_window position||"] := hwnd
				Gui, %GUI%: Font, % "s"settings.general.fsize
			}
			If (vars.client.fullscreen = "false")
			{
				Gui, %GUI%: Add, Checkbox, % "xs Section HWNDhwnd Checked"vars.client.borderless " gSettings_general2", % Lang_Trans("m_general_borderless")
				vars.hwnd.settings.remove_borders := hwnd, vars.hwnd.help_tooltips["settings_window borders"] := hwnd
			}
		}

		If settings.general.FillerAvailable
		{
			Gui, %GUI%: Add, Checkbox, % "xs Section gSettings_general2 HWNDhwnd Checked" settings.general.ClientFiller, % Lang_Trans("m_general_filler")
			vars.hwnd.settings.ClientFiller := vars.hwnd.help_tooltips["settings_client filler"] := hwnd
		}

		If (vars.client.h0 / vars.client.w0 < (5/12))
		{
			settings.general.blackbars := LLK_IniRead("ini" vars.poe_version "\config.ini", "Settings", "black-bar compensation", 0)
			Gui, %GUI%: Add, Checkbox, % "hp xs Section BackgroundTrans gSettings_general2 HWNDhwnd Center Checked"settings.general.blackbars, % Lang_Trans("m_general_blackbars")
			vars.hwnd.settings.blackbars := hwnd, vars.hwnd.help_tooltips["settings_black bars"] := hwnd
		}
	}

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "xs Section BackgroundTrans HWNDhwnd y+"vars.settings.spacing, % Lang_Trans("m_general_permissions")
	vars.hwnd.settings.permissions_test := hwnd
	Gui, %GUI%: Add, Pic, % "ys hp w-1 BackgroundTrans HWNDhwnd0", % "HBitmap:*" vars.pics.global.help
	Gui, %GUI%: Font, norm
	Gui, %GUI%: Add, Text, % "xs Section BackgroundTrans Border gSettings_WriteTest", % " " Lang_Trans("m_general_start") " "
	Gui, %GUI%: Add, Progress, % "xp yp wp hp Border Disabled BackgroundBlack cGreen Range0-700 HWNDhwnd", 0
	Gui, %GUI%: Add, Text, % "ys BackgroundTrans Border gSettings_WriteTest HWNDhwnd1", % " " Lang_Trans("m_general_admin") " "
	vars.hwnd.help_tooltips["settings_write permissions"] := hwnd0, vars.hwnd.settings.bar_writetest := hwnd, vars.hwnd.settings.writetest := hwnd1
}

Settings_general2(cHWND := "")
{
	local
	global vars, settings
	static char_wait

	check := LLK_HasVal(vars.hwnd.settings, cHWND), control := SubStr(check, InStr(check, "_") + 1), update := vars.update

	Switch check
	{
		Case "winbar":
			While GetKeyState("LButton", "P") ;dragging the window
			{
				WinGetPos, xWin, yWin, wWin, hWin, % "ahk_id " vars.hwnd.settings.main
				MouseGetPos, xMouse, yMouse
				While GetKeyState("LButton", "P")
				{
					LLK_Drag(wWin, hWin, xPos, yPos, 1,,, xMouse - xWin, yMouse - yWin)
					sleep 1
				}
				KeyWait, LButton
				WinGetPos, xPos, yPos, w, h, % "ahk_id " vars.hwnd.settings.main
				vars.settings.x := xPos, vars.settings.y := yPos, vars.general.drag := 0
				Return
			}
		Case "dev_env":
			settings.general.dev_env := LLK_ControlGet(cHWND)
			IniWrite, % settings.general.dev_env, % "ini" vars.poe_version "\config.ini", Settings, dev env
		Case "kill_timer":
			settings.general.kill.1 := LLK_ControlGet(cHWND)
			IniWrite, % settings.general.kill.1, % "ini\config.ini", Settings, kill script
		Case "kill_timeout":
			settings.general.kill.2 := Blank(LLK_ControlGet(cHWND)) ? 0 : LLK_ControlGet(cHWND)
			IniWrite, % settings.general.kill.2, % "ini\config.ini", Settings, kill-timeout
		Case "browser":
			settings.features.browser := LLK_ControlGet(cHWND)
			IniWrite, % LLK_ControlGet(cHWND), % "ini" vars.poe_version "\config.ini", settings, enable browser features
		Case "capslock":
			IniWrite, % LLK_ControlGet(cHWND), % "ini" vars.poe_version "\config.ini", settings, enable capslock-toggling
			IniWrite, general, % "ini" vars.poe_version "\config.ini", versions, reload settings
			KeyWait, LButton
			Reload
			ExitApp
		Case "character":
			input := LLK_ControlGet(cHWND)
			GuiControl, % "+c" (input = settings.general.character ? "Black" : "Red"), % cHWND
			GuiControl, % "movedraw", % cHWND
		Case "ascendancy":
			If char_wait
				Return
			char_wait := 1
			KeyWait, LButton
			KeyWait, RButton
			WinActivate, % "ahk_id " vars.hwnd.poe_client
			WinWaitActive, % "ahk_id " vars.hwnd.poe_client
			Clipboard := "/whois " settings.general.character
			ClipWait, 0.1
			SendInput, {Enter}
			Sleep, 100
			SendInput, ^{a}^{v}{Enter}
			Sleep, 100
			Clipboard := ""
			char_wait := 0
		Case "build":
			input := LLK_ControlGet(cHWND)
			GuiControl, % "+c" (input = settings.general.build ? "Black" : "Red"), % cHWND
			GuiControl, % "movedraw", % cHWND
		Case "save_character":
			ControlGetFocus, hwnd, % "ahk_id " vars.hwnd.settings.main
			ControlGet, hwnd, HWND,, % hwnd
			If !InStr(vars.hwnd.settings.character "," vars.hwnd.settings.build, hwnd) || char_wait
				Return
			parse := LLK_StringCase(LLK_ControlGet(hwnd)), parse := Trim(parse, " ")
			key := LLK_HasVal(vars.hwnd.settings, hwnd)
			If (parse = settings.general[key])
				Return
			IniWrite, % (settings.general[key] := parse), % "ini" vars.poe_version "\config.ini", Settings, active %key%
			If (key = "character")
			{
				char_wait := 1
				GuiControl, +disabled, % hwnd
			}
			Else
			{
				GuiControl, +cBlack, % hwnd
				GuiControl, movedraw, % hwnd
				Return
			}
			Init_log("refresh")
			If WinExist("ahk_id " vars.hwnd.geartracker.main)
				Geartracker_GUI()
			Else If settings.leveltracker.geartracker && vars.hwnd.geartracker.main
				Geartracker_GUI("refresh")
			If LLK_Overlay(vars.hwnd.leveltracker.main, "check")
				Leveltracker_Progress()
			If settings.features.maptracker && settings.maptracker.character
				Maptracker_GUI()
			Settings_menu("general"), char_wait := 0
		Case "language":
			IniWrite, % LLK_ControlGet(vars.hwnd.settings.language), % "ini" vars.poe_version "\config.ini", settings, language
			IniWrite, % vars.settings.active, % "ini" vars.poe_version "\config.ini", Versions, reload settings
			KeyWait, LButton
			Reload
			ExitApp
		Case "logfile":
			If LLK_Progress(vars.hwnd.settings.logfile_bar, "LButton")
				Log_Backup()
		Case "logfolder":
			KeyWait, LButton
			Run, % "explore " SubStr(vars.log.file_location, 1, InStr(vars.log.file_location, "\",, 0) - 1)
		Case "custom_width":
			GuiControl, -Hidden, % vars.hwnd.settings.apply
			GuiControl, movedraw, % vars.hwnd.settings.apply
		Case "custom_resolution":
			GuiControl, -Hidden, % vars.hwnd.settings.apply
			GuiControl, movedraw, % vars.hwnd.settings.apply
		Case "apply":
			width := (LLK_ControlGet(vars.hwnd.settings.custom_width) > vars.monitor.w) ? vars.monitor.w : LLK_ControlGet(vars.hwnd.settings.custom_width)
			height := LLK_ControlGet(vars.hwnd.settings.custom_resolution)
			If !IsNumber(height) || !IsNumber(width)
			{
				LLK_ToolTip(Lang_Trans("global_errorname", 2),,,,, "red")
				Return
			}
			horizontal := LLK_ControlGet(vars.hwnd.settings.dock), vertical := LLK_ControlGet(vars.hwnd.settings.dock2)
			For key, val in vars.lang
				If InStr(key, "m_general_pos") && (val.1 = horizontal || val.1 = vertical)
					horizontal := (val.1 = horizontal) ? StrReplace(key, "m_general_pos") : horizontal, vertical := (val.1 = vertical) ? StrReplace(key, "m_general_pos") : vertical
			If InStr("left, right, center", horizontal) && InStr("top, bottom, center", vertical)
			{
				IniWrite, % horizontal, % "ini" vars.poe_version "\config.ini", Settings, window-position
				IniWrite, % vertical, % "ini" vars.poe_version "\config.ini", Settings, window-position vertical
			}
			IniWrite, % height, % "ini" vars.poe_version "\config.ini", Settings, custom-resolution
			IniWrite, % width, % "ini" vars.poe_version "\config.ini", Settings, custom-width
			IniWrite, % LLK_ControlGet(vars.hwnd.settings.remove_borders), % "ini" vars.poe_version "\config.ini", settings, remove window-borders
			If vars.hwnd.settings.ClientFiller
				IniWrite, % LLK_ControlGet(vars.hwnd.settings.ClientFiller), % "ini" vars.poe_version "\config.ini", Settings, client background filler
			If vars.hwnd.settings.blackbars
				IniWrite, % LLK_ControlGet(vars.hwnd.settings.blackbars), % "ini" vars.poe_version "\config.ini", Settings, black-bar compensation
			IniWrite, % vars.settings.active, % "ini" vars.poe_version "\config.ini", Versions, reload settings
			KeyWait, LButton
			Reload
			ExitApp
		Case "ClientFiller":
			GuiControl, -Hidden, % vars.hwnd.settings.apply
			GuiControl, movedraw, % vars.hwnd.settings.apply
		Case "dock":
			GuiControl, -Hidden, % vars.hwnd.settings.apply
			GuiControl, movedraw, % vars.hwnd.settings.apply
		Case "dock2":
			GuiControl, -Hidden, % vars.hwnd.settings.apply
			GuiControl, movedraw, % vars.hwnd.settings.apply
		Case "remove_borders":
			state := LLK_ControlGet(cHWND), ddl_state := LLK_ControlGet(vars.hwnd.settings.custom_resolution)
			For key in vars.general.supported_resolutions
				If state && (key <= vars.monitor.h) || !state && (key < vars.monitor.h)
					ddl := !ddl ? key : key "|" ddl
			ddl := !InStr(ddl, ddl_state) ? "|" StrReplace(ddl, "|", "||",, 1) : "|" StrReplace(ddl, InStr(ddl, ddl_state "|") ? ddl_state "|" : ddl_state, ddl_state "||")
			GuiControl,, % vars.hwnd.settings.custom_resolution, % ddl
			GuiControl, -Hidden, % vars.hwnd.settings.apply
			GuiControl, movedraw, % vars.hwnd.settings.apply
		Case "blackbars":
			GuiControl, -Hidden, % vars.hwnd.settings.apply
			GuiControl, movedraw, % vars.hwnd.settings.apply
		Default:
			If InStr(check, "font_")
			{
				While GetKeyState("LButton", "P")
				{
					If (control = "minus")
						settings.general.fSize -= (settings.general.fSize > 6) ? 1 : 0
					Else If (control = "reset")
						settings.general.fSize := LLK_FontDefault()
					Else settings.general.fSize += 1
					GuiControl, text, % vars.hwnd.settings.font_reset, % settings.general.fSize
					Sleep 150
				}
				LLK_FontDimensions(settings.general.fSize, font_height, font_width), settings.general.fheight := font_height, settings.general.fwidth := font_width
				LLK_FontDimensions(settings.general.fSize - 4, font_height, font_width), settings.general.fheight2 := font_height, settings.general.fwidth2 := font_width
				IniWrite, % settings.general.fSize, % "ini" vars.poe_version "\config.ini", Settings, font-size
				Init_GUI()
				Settings_menu("general")
			}
			Else If InStr(check, "toolbar_")
			{
				If (control = "hide")
				{
					settings.general.hide_toolbar := LLK_ControlGet(cHWND)
					IniWrite, % settings.general.hide_toolbar, % "ini" vars.poe_version "\config.ini", UI, hide toolbar
					Init_GUI()
					Return
				}
				While GetKeyState("LButton", "P")
				{
					If (control = "minus")
						settings.gui.sToolbar -= (settings.gui.sToolbar > Round((vars.monitor.h / 72) / 2)) ? 1 : 0
					Else If (control = "reset")
						settings.gui.sToolbar := Round(vars.monitor.h / 72)
					Else settings.gui.sToolbar += 1
					GuiControl, text, % vars.hwnd.settings.toolbar_reset, % settings.gui.sToolbar
					Sleep 150
				}
				IniWrite, % settings.gui.sToolbar, % "ini" vars.poe_version "\config.ini", UI, toolbar-size
				Init_GUI("refresh")
			}
			Else LLK_ToolTip("no action")
	}
}

Settings_hotkeys()
{
	local
	global vars, settings

	GUI := "settings_menu" vars.settings.GUI_toggle, x_anchor := vars.settings.x_anchor
	Gui, %GUI%: Add, Link, % "Section x" x_anchor " y" vars.settings.ySelection, <a href="https://www.autohotkey.com/docs/v1/KeyList.htm">ahk: list of keys</a>
	Gui, %GUI%: Add, Link, % "ys x+"settings.general.fWidth, <a href="https://www.autohotkey.com/docs/v1/Hotkeys.htm">ahk: formatting</a>

	If !vars.client.stream || settings.features.leveltracker
	{
		Gui, %GUI%: Font, bold underline
		Gui, %GUI%: Add, Text, % "xs Section y+"vars.settings.spacing, % Lang_Trans("m_hotkeys_settings")
		Gui, %GUI%: Add, Pic, % "ys hp w-1 BackgroundTrans HWNDhwnd0", % "HBitmap:*" vars.pics.global.help
		Gui, %GUI%: Font, norm
	}

	If !vars.client.stream
	{
		Gui, %GUI%: Add, Checkbox, % "xs Section HWNDhwnd gSettings_hotkeys2 Checked"settings.hotkeys.rebound_alt, % Lang_Trans("m_hotkeys_descriptions")
		vars.hwnd.settings.rebound_alt := hwnd, vars.hwnd.help_tooltips["settings_hotkeys ingame-keybinds"] := hwnd0
		If settings.hotkeys.rebound_alt
		{
			Gui, %GUI%: Add, Text, % "xs Section HWNDhwnd0 xp+" settings.general.fWidth * 1.5, % Lang_Trans("m_hotkeys_descriptions", 2)
			Gui, %GUI%: font, % "s"settings.general.fSize - 4
			Gui, %GUI%: Add, Edit, % "ys x+" settings.general.fWidth/2 " hp gSettings_hotkeys2 w"settings.general.fWidth*10 " HWNDhwnd cBlack", % settings.hotkeys.item_descriptions
			vars.hwnd.help_tooltips["settings_hotkeys altkey"] := hwnd0, vars.hwnd.settings.item_descriptions := vars.hwnd.help_tooltips["settings_hotkeys altkey|"] := hwnd
			Gui, %GUI%: font, % "s"settings.general.fSize
		}
		Gui, %GUI%: Add, Checkbox, % "xs Section HWNDhwnd gSettings_hotkeys2 Checked" settings.hotkeys.rebound_c " x" x_anchor, % Lang_Trans("m_hotkeys_ckey")
		vars.hwnd.settings.rebound_c := hwnd
	}

	If settings.features.leveltracker
	{
		Gui, %GUI%: Add, Text, % "xs Section HWNDhwnd0 x" x_anchor, % Lang_Trans("m_hotkeys_movekey")
		Gui, %GUI%: font, % "s"settings.general.fSize - 4
		Gui, %GUI%: Add, Edit, % "ys x+" settings.general.fWidth/2 " hp gSettings_hotkeys2 w"settings.general.fWidth*10 " HWNDhwnd cBlack", % settings.hotkeys.movekey
		vars.hwnd.help_tooltips["settings_hotkeys movekey"] := hwnd0, vars.hwnd.settings.movekey := hwnd, vars.hwnd.help_tooltips["settings_hotkeys movekey|"] := hwnd
		Gui, %GUI%: font, % "s"settings.general.fSize
	}

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "xs Section y+"vars.settings.spacing " x" x_anchor, % Lang_Trans("m_hotkeys_omnikey")
	Gui, %GUI%: Add, Pic, % "ys hp w-1 BackgroundTrans HWNDhwnd", % "HBitmap:*" vars.pics.global.help
	vars.hwnd.help_tooltips["settings_hotkeys omnikey-info"] := hwnd
	Gui, %GUI%: Font, norm

	LLK_PanelDimensions([Lang_Trans("m_hotkeys_omnikey", 2), settings.hotkeys.rebound_c ? Lang_Trans("m_hotkeys_omnikey", 3) : ""], settings.general.fSize, wText, hText,,, 0)
	Gui, %GUI%: Add, Text, % "xs Section HWNDhwnd0 w" wText, % Lang_Trans("m_hotkeys_omnikey", 2)
	Gui, %GUI%: Font, % "s"settings.general.fSize - 4
	Gui, %GUI%: Add, Edit, % "ys hp cBlack HWNDhwnd gSettings_hotkeys2 x+" settings.general.fWidth/2 " w"settings.general.fWidth*10, % (settings.hotkeys.omnikey = "MButton") ? "" : settings.hotkeys.omnikey
	vars.hwnd.help_tooltips["settings_hotkeys omnikey"] := hwnd0, vars.hwnd.settings.omnikey := vars.hwnd.help_tooltips["settings_hotkeys omnikey|"] := hwnd
	ControlGetPos, x, y,,,, % "ahk_id "hwnd
	Gui, %GUI%: Font, % "s"settings.general.fSize

	If settings.hotkeys.rebound_c
	{
		Gui, %GUI%: Add, Text, % "xs Section HWNDhwnd0 w" wText, % Lang_Trans("m_hotkeys_omnikey", 3)
		Gui, %GUI%: font, % "s"settings.general.fSize - 4
		Gui, %GUI%: Add, Edit, % "yp x+" settings.general.fWidth/2 " hp cBlack HWNDhwnd gSettings_hotkeys2 w"settings.general.fWidth*10, % settings.hotkeys.omnikey2
		vars.hwnd.help_tooltips["settings_hotkeys omnikey2"] := hwnd0, vars.hwnd.settings.omnikey2 := vars.hwnd.help_tooltips["settings_hotkeys omnikey2|"] := hwnd
		Gui, %GUI%: font, % "s"settings.general.fSize
	}

	Gui, %GUI%: Add, Checkbox, % "xs Section HWNDhwnd gSettings_hotkeys2 Checked"settings.hotkeys.omniblock, % Lang_Trans("m_hotkeys_keyblock")
	vars.hwnd.settings.omniblock := hwnd, vars.hwnd.help_tooltips["settings_hotkeys omniblock"] := hwnd
	;Gui, %GUI%: Add, Hotkey, % "ys hp Disabled gSettings_hotkeys2 HWNDhwnd x+"settings.general.fWidth/2 " cBlack w"settings.general.fWidth* 6, % (settings.hotkeys.omnikey = "MButton") ? "" : settings.hotkeys.omnikey
	;vars.hwnd.settings.omnikey := hwnd

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "xs Section y+"vars.settings.spacing, % Lang_Trans("m_hotkeys_misc")
	Gui, %GUI%: Font, norm
	Gui, %GUI%: Add, Text, % "xs Section HWNDhwnd0", % Lang_Trans("m_hotkeys_tab")
	Gui, %GUI%: Font, % "s"settings.general.fSize - 4
	Gui, %GUI%: Add, Edit, % "ys hp cBlack HWNDhwnd gSettings_hotkeys2 x+"settings.general.fWidth/2 " w"settings.general.fWidth*10, % (settings.hotkeys.tab = "TAB") ? "" : settings.hotkeys.tab
	vars.hwnd.help_tooltips["settings_hotkeys tab"] := hwnd0, vars.hwnd.settings.tab := hwnd, vars.hwnd.help_tooltips["settings_hotkeys tab|"] := hwnd
	Gui, %GUI%: Font, % "s"settings.general.fSize
	Gui, %GUI%: Add, Checkbox, % "xs Section HWNDhwnd gSettings_hotkeys2 Checked"settings.hotkeys.tabblock, % Lang_Trans("m_hotkeys_keyblock")
	Gui, %GUI%: Add, Text, % "xs Section HWNDhwnd0 cAqua", % Lang_Trans("m_hotkeys_emergency") " win + "
	vars.hwnd.help_tooltips["settings_hotkeys restart"] := hwnd0, vars.hwnd.settings.tabblock := hwnd, vars.hwnd.help_tooltips["settings_hotkeys omniblock|"] := hwnd
	Gui, %GUI%: Font, % "s" settings.general.fSize - 4
	Gui, %GUI%: Add, Edit, % "ys x+0 hp HWNDhwnd gSettings_hotkeys2 cBlack w" settings.general.fWidth * 6, % settings.hotkeys.emergencykey
	vars.hwnd.settings.emergencykey := hwnd
	Gui, %GUI%: Font, % "s"settings.general.fSize + 4
	Gui, %GUI%: Add, Text, % "xs Border gSettings_hotkeys2 Hidden cRed Section HWNDhwnd y+"vars.settings.spacing, % " " Lang_Trans("global_restart") " "
	Gui, %GUI%: Add, Text, % "xp yp wp hp BackgroundTrans", % ""
	vars.hwnd.settings.apply := hwnd
	Gui, %GUI%: Font, % "s"settings.general.fSize
}

Settings_hotkeys2(cHWND)
{
	local
	global vars, settings

	check := LLK_HasVal(vars.hwnd.settings, cHWND), keycheck := {}
	If (check = 0)
		check := A_GuiControl

	settings.hotkeys.item_descriptions := LLK_ControlGet(vars.hwnd.settings.item_descriptions)
	settings.hotkeys.omnikey2 := LLK_ControlGet(vars.hwnd.settings.omnikey2)
	Switch check
	{
		Case "rebound_alt":
			settings.hotkeys.rebound_alt := LLK_ControlGet(cHWND)
			Settings_menu("hotkeys", 1)
		Case "rebound_c":
			settings.hotkeys.rebound_c := LLK_ControlGet(cHWND)
			Settings_menu("hotkeys", 1)
		Case "emergencykey":
			input := LLK_ControlGet(cHWND)
			GuiControl, % "+c" (input != settings.hotkeys.emergencykey ? "Red" : "Black"), % cHWND
			GuiControl, % "movedraw", % cHWND
		Case "apply":
			Loop, Parse, % "item_descriptions, omnikey, omnikey2, tab, emergencykey", `,, % A_Space
			{
				If (A_LoopField != "item_descriptions")
				{
					If !vars.hwnd.settings[A_LoopField]
						Continue
					hotkey := LLK_ControlGet(vars.hwnd.settings[A_LoopField])
					If (StrLen(hotkey) != 1)
						Loop, Parse, % "+!^#"
							hotkey := StrReplace(hotkey, A_LoopField)

					If !Blank(LLK_ControlGet(vars.hwnd.settings[A_LoopField])) && (!GetKeyVK(hotkey) || (hotkey = ""))
					{
						WinGetPos, x, y, w,, % "ahk_id "vars.hwnd.settings[A_LoopField]
						LLK_ToolTip(Lang_Trans("m_hotkeys_error"),, x + w, y,, "red")
						Return
					}
				}

				If (A_LoopField != "emergencykey") && keycheck.HasKey(hotkey)
				{
					LLK_ToolTip(Lang_Trans("m_hotkeys_error", 2), 1.5,,,, "red")
					Return
				}
				If (A_LoopField != "emergencykey") && !Blank(hotkey)
					keycheck[hotkey] := 1
			}
			If LLK_ControlGet(vars.hwnd.settings.rebound_alt) && !LLK_ControlGet(vars.hwnd.settings.item_descriptions)
			{
				WinGetPos, xControl, yControl, wControl, hControl, % "ahk_id " vars.hwnd.settings.item_descriptions
				LLK_ToolTip(Lang_Trans("m_hotkeys_error", 3), 3, xControl + wControl, yControl,, "red")
				Return
			}
			If LLK_ControlGet(vars.hwnd.settings.rebound_c) && !LLK_ControlGet(vars.hwnd.settings.omnikey2)
			{
				WinGetPos, xControl, yControl, wControl, hControl, % "ahk_id " vars.hwnd.settings.omnikey2
				LLK_ToolTip(Lang_Trans("m_hotkeys_error", 4), 3, xControl + wControl, yControl,, "red")
				Return
			}
			IniWrite, % LLK_ControlGet(vars.hwnd.settings.rebound_alt), % "ini" vars.poe_version "\hotkeys.ini", settings, advanced item-info rebound
			IniWrite, % LLK_ControlGet(vars.hwnd.settings.item_descriptions), % "ini" vars.poe_version "\hotkeys.ini", hotkeys, item-descriptions key
			IniWrite, % LLK_ControlGet(vars.hwnd.settings.rebound_c), % "ini" vars.poe_version "\hotkeys.ini", settings, c-key rebound
			IniWrite, % LLK_ControlGet(vars.hwnd.settings.omnikey), % "ini" vars.poe_version "\hotkeys.ini", hotkeys, omni-hotkey
			IniWrite, % LLK_ControlGet(vars.hwnd.settings.omniblock), % "ini" vars.poe_version "\hotkeys.ini", hotkeys, block omnikey's native function
			IniWrite, % LLK_ControlGet(vars.hwnd.settings.omnikey2), % "ini" vars.poe_version "\hotkeys.ini", hotkeys, omni-hotkey2
			IniWrite, % LLK_ControlGet(vars.hwnd.settings.tab), % "ini" vars.poe_version "\hotkeys.ini", hotkeys, tab replacement
			IniWrite, % LLK_ControlGet(vars.hwnd.settings.tabblock), % "ini" vars.poe_version "\hotkeys.ini", hotkeys, block tab-key's native function
			IniWrite, % LLK_ControlGet(vars.hwnd.settings.movekey), % "ini" vars.poe_version "\hotkeys.ini", hotkeys, move-key
			IniWrite, % LLK_ControlGet(vars.hwnd.settings.emergencykey), % "ini" vars.poe_version "\hotkeys.ini", hotkeys, emergency hotkey
			IniWrite, hotkeys, % "ini" vars.poe_version "\config.ini", versions, reload settings
			KeyWait, LButton
			Reload
			ExitApp
	}
	GuiControl, -Hidden, % vars.hwnd.settings.apply
	GuiControl, movedraw, % vars.hwnd.settings.apply
}

Settings_iteminfo()
{
	local
	global vars, settings

	GUI := "settings_menu" vars.settings.GUI_toggle
	Gui, %GUI%: Add, Link, % "Section x" vars.settings.x_anchor " y" vars.settings.ySelection, <a href="https://github.com/Lailloken/Lailloken-UI/wiki/Item-info">wiki page</a>

	If (settings.general.lang_client = "unknown")
	{
		Settings_unsupported()
		Return
	}

	Gui, %GUI%: Add, Checkbox, % "xs Section Center gSettings_iteminfo2 HWNDhwnd y+"vars.settings.spacing " Checked" (settings.features.iteminfo ? 1 : 0), % Lang_Trans("m_iteminfo_enable")
	vars.hwnd.settings.enable := vars.hwnd.help_tooltips["settings_iteminfo enable"] := hwnd

	If !settings.features.iteminfo
		Return

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "xs Section Center y+"vars.settings.spacing, % Lang_Trans("m_iteminfo_profiles")
	Gui, %GUI%: Font, norm
	;Gui, %GUI%: Add, Text, % "xs Section Center HWNDhwnd0", % Lang_Trans("m_iteminfo_profiles", 2)
	Loop 5
	{
		Gui, %GUI%: Add, Text, % "ys x+"settings.general.fWidth/(A_Index = 1 ? 2 : 4) " Center Border HWNDhwnd gSettings_iteminfo2 c"(InStr(settings.iteminfo.profile, A_Index) ? "Fuchsia" : "White"), % " " A_Index " "
		vars.hwnd.help_tooltips["settings_iteminfo profiles"] := hwnd0, handle .= "|", vars.hwnd.settings["profile_"A_Index] := hwnd, vars.hwnd.help_tooltips["settings_iteminfo profiles"handle] := hwnd
	}

	Gui, %GUI%: Add, Text, % "xs Section Center HWNDhwnd0", % Lang_Trans("m_iteminfo_profiles", 3)
	Gui, %GUI%: Add, Text, % "ys x+" settings.general.fWidth/2 " Center Border BackgroundTrans HWNDhwnd gSettings_iteminfo2", % " " Lang_Trans("m_iteminfo_desired") " "
	vars.hwnd.help_tooltips["settings_iteminfo reset"] := hwnd0, vars.hwnd.settings.desired := hwnd
	Gui, %GUI%: Add, Progress, % "xp yp wp hp Border Disabled Vertical range0-500 BackgroundBlack cRed HWNDhwnd", 0
	vars.hwnd.settings.delbar_desired := vars.hwnd.help_tooltips["settings_iteminfo reset|"] := hwnd
	Gui, %GUI%: Add, Text, % "ys x+"settings.general.fWidth/4 " Center Border BackgroundTrans HWNDhwnd0 gSettings_iteminfo2", % " " Lang_Trans("m_iteminfo_undesired") " "
	Gui, %GUI%: Add, Progress, % "xp yp wp hp Border Disabled Vertical range0-500 BackgroundBlack cRed HWNDhwnd", 0
	vars.hwnd.settings.undesired := hwnd0, vars.hwnd.settings.delbar_undesired := vars.hwnd.help_tooltips["settings_iteminfo reset||"] := hwnd

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "xs Section Center BackgroundTrans y+"vars.settings.spacing, % Lang_Trans("global_general")
	Gui, %GUI%: Font, norm

	Gui, %GUI%: Add, Text, % "ys Center BackgroundTrans HWNDhwnd0", % Lang_Trans("global_font")
	Gui, %GUI%: Add, Text, % "ys x+" settings.general.fWidth/2 " Center gSettings_iteminfo2 Border HWNDhwnd w"settings.general.fWidth*2, % "–"
	vars.hwnd.help_tooltips["settings_font-size"] := hwnd0, vars.hwnd.settings.font_minus := vars.hwnd.help_tooltips["settings_font-size|"] := hwnd
	Gui, %GUI%: Add, Text, % "ys x+"settings.general.fWidth/4 " Center gSettings_iteminfo2 Border HWNDhwnd w"settings.general.fWidth*3, % settings.iteminfo.fSize
	vars.hwnd.settings.font_reset := vars.hwnd.help_tooltips["settings_font-size||"] := hwnd
	Gui, %GUI%: Add, Text, % "ys x+"settings.general.fWidth/4 " Center gSettings_iteminfo2 Border HWNDhwnd w"settings.general.fWidth*2, % "+"
	vars.hwnd.settings.font_plus := vars.hwnd.help_tooltips["settings_font-size|||"] := hwnd

	Gui, %GUI%: Add, Text, % "xs Section", % Lang_Trans("global_activation")
	Gui, %Gui%: Add, Radio, % "ys HWNDhwnd1 gSettings_iteminfo2 Checked" settings.iteminfo.omnikey, % "omni"
	Gui, %Gui%: Add, Radio, % "ys HWNDhwnd2 gSettings_iteminfo2 Checked" !settings.iteminfo.omnikey, % "alt"
	vars.hwnd.settings.omni_key := vars.hwnd.help_tooltips["settings_iteminfo omni-key"] := hwnd1
	vars.hwnd.settings.alt_key := vars.hwnd.help_tooltips["settings_iteminfo alt-key"] := hwnd2

	Gui, %GUI%: Add, Checkbox, % "ys gSettings_iteminfo2 HWNDhwnd Checked"settings.iteminfo.trigger, % Lang_Trans("m_iteminfo_shift")
	vars.hwnd.settings.trigger := hwnd, vars.hwnd.help_tooltips["settings_iteminfo shift-click"] := hwnd

	If vars.poe_version
	{
		Gui, %GUI%: Add, Text, % "xs Section", % Lang_Trans("m_iteminfo_modbars")
		Gui, %GUI%: Add, Radio, % "ys HWNDhwnd gSettings_iteminfo2 Checked" (settings.iteminfo.roll_range = 1 ? 1 : 0), % Lang_Trans("global_tier")
		Gui, %GUI%: Add, Radio, % "ys HWNDhwnd1 gSettings_iteminfo2 Checked" (settings.iteminfo.roll_range = 2 ? 1 : 0), % Lang_Trans("global_global")
		Gui, %GUI%: Add, Radio, % "ys HWNDhwnd2 gSettings_iteminfo2 Checked" (settings.iteminfo.roll_range = 3 ? 1 : 0), % Lang_Trans("global_ilvl")
		vars.hwnd.settings.roll_range1 := vars.hwnd.help_tooltips["settings_iteminfo modbars tier"] := hwnd
		vars.hwnd.settings.roll_range2 := vars.hwnd.help_tooltips["settings_iteminfo modbars global"] := hwnd1
		vars.hwnd.settings.roll_range3 := vars.hwnd.help_tooltips["settings_iteminfo modbars ilevel"] := hwnd2
	}

	Gui, %GUI%: Add, Checkbox, % (vars.poe_version ? "ys" : "Section xs") " gSettings_iteminfo2 HWNDhwnd Checked"settings.iteminfo.modrolls, % Lang_Trans((vars.poe_version ? "global_hide" : "m_iteminfo_hiderange"))
	vars.hwnd.settings.modrolls := hwnd, vars.hwnd.help_tooltips["settings_iteminfo modrolls"] := hwnd

	Gui, %GUI%: Add, Text, % "Section xs", % Lang_Trans("m_iteminfo_affixinfo")
	Gui, %GUI%: Add, Radio, % "ys gSettings_iteminfo2 HWNDhwnd Checked" (settings.iteminfo.affixinfo = 1 ? 1 : 0), % Lang_Trans("global_icon")
	Gui, %GUI%: Add, Radio, % "ys gSettings_iteminfo2 HWNDhwnd1 Checked" (settings.iteminfo.affixinfo = 2 ? 1 : 0), % Lang_Trans("global_ilvl")
	If vars.poe_version
	{
		Gui, %GUI%: Add, Radio, % "ys gSettings_iteminfo2 HWNDhwnd2 Checked" (settings.iteminfo.affixinfo = 3 ? 1 : 0), % Lang_Trans("m_iteminfo_maxtier")
		vars.hwnd.settings["affixinfo_3"] := vars.hwnd.help_tooltips["settings_iteminfo affix-info max tier"] := hwnd2
	}
	Gui, %GUI%: Add, Radio, % "ys gSettings_iteminfo2 HWNDhwnd3 Checked" (settings.iteminfo.affixinfo = 0 ? 1 : 0), % Lang_Trans("global_off")
	vars.hwnd.settings["affixinfo_1"] := vars.hwnd.help_tooltips["settings_iteminfo affix-info icon"] := hwnd
	vars.hwnd.settings["affixinfo_2"] := vars.hwnd.help_tooltips["settings_iteminfo affix-info ilvl"] := hwnd1
	vars.hwnd.settings["affixinfo_0"] := vars.hwnd.help_tooltips["settings_iteminfo affix-info off"] := hwnd3

	If vars.poe_version
	{
		Gui, %GUI%: Add, Checkbox, % "xs Section gSettings_iteminfo2 HWNDhwnd Checked" settings.iteminfo.qual_scaling, % Lang_Trans("m_iteminfo_quality")
		vars.hwnd.settings.qual_scaling := hwnd, vars.hwnd.help_tooltips["settings_iteminfo quality scaling"] := hwnd
	}
	Else
	{
		Gui, %GUI%: Add, Checkbox, % "xs Section gSettings_iteminfo2 HWNDhwnd Checked"settings.iteminfo.compare (settings.general.lang_client != "english" ? " cGray" : ""), % Lang_Trans("m_iteminfo_league")
		vars.hwnd.settings.compare := hwnd, vars.hwnd.help_tooltips["settings_" (settings.general.lang_client = "english" ? "iteminfo league-start" : "lang unavailable") ] := hwnd
	}
	If !settings.iteminfo.compare
	{
		Gui, %GUI%: Add, Checkbox, % "xs Section gSettings_iteminfo2 HWNDhwnd Checked"settings.iteminfo.itembase, % Lang_Trans("m_iteminfo_base")
		vars.hwnd.settings.itembase := hwnd, vars.hwnd.help_tooltips["settings_iteminfo base-info" vars.poe_version] := hwnd
	}

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "xs Section Center BackgroundTrans y+"vars.settings.spacing, % Lang_Trans("m_iteminfo_highlight")
	Gui, %GUI%: Font, norm
	LLK_PanelDimensions([Lang_Trans("global_tier"), Lang_Trans("global_ilvl")], settings.general.fSize, wText, hText,,, 0)

	Gui, %GUI%: Add, Text, % "xs Section", % Lang_Trans("m_iteminfo_undesired", 2) " "

	Loop 2
	{
		Gui, %GUI%: Add, Text, % "ys HWNDhwnd0" (A_Index = 1 ? " x+0" : ""), % (A_Index = 1) ? Lang_Trans("global_global") : Lang_Trans("m_iteminfo_class")
		Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans gSettings_iteminfo2 HWNDhwnd x+" settings.general.fWidth//2 " w" settings.general.fWidth//2
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border BackgroundBlack HWNDhwnd2 c" settings.iteminfo.colors_marking[A_Index + A_Index//2], 100
		Gui, %GUI%: Add, Text, % "ys x+-1 Border BackgroundTrans gSettings_iteminfo2 HWNDhwnd3 w" settings.general.fWidth//2
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border BackgroundBlack HWNDhwnd4 c" settings.iteminfo.colors_marking[A_Index + A_Index//2 + 1], 100
		vars.hwnd.settings["marking_desired" (A_Index = 1 ? "" : "_class")] := hwnd, vars.hwnd.settings["marking_desired" (A_Index = 1 ? "" : "_class") "_bar"] := hwnd2
		vars.hwnd.settings["marking_undesired" (A_Index = 1 ? "" : "_class")] := hwnd3, vars.hwnd.settings["marking_undesired" (A_Index = 1 ? "" : "_class") "_bar"] := hwnd4
		vars.hwnd.help_tooltips["settings_iteminfo marking " (A_Index = 1 ? "global" : "class")] := hwnd0
		vars.hwnd.help_tooltips["settings_iteminfo marking " (A_Index = 1 ? "global" : "class") "|"] := hwnd2, vars.hwnd.help_tooltips["settings_iteminfo marking " (A_Index = 1 ? "global" : "class") "||"] := hwnd4
	}

	Loop 8
	{
		parse := (A_Index = 1) ? 7 : A_Index - 2
		If (A_Index = 1)
			Gui, %GUI%: Add, Text, % "xs Section HWNDhwnd0 w" wText, % Lang_Trans("global_tier")
		Gui, %GUI%: Add, Text, % "ys x+"settings.general.fWidth/(A_Index = 1 ? 2 : 4) " w"settings.general.fWidth*3 " cBlack Center Border BackgroundTrans gSettings_iteminfo2 HWNDhwnd", % (A_Index = 1) ? Lang_Trans("m_iteminfo_fractured") : (A_Index = 2) ? "#" : parse
		vars.hwnd.help_tooltips["settings_iteminfo item-tier"] := hwnd0, vars.hwnd.settings["tier_"parse] := hwnd, handle := (A_Index = 1) ? "|" : handle "|"
		Gui, %GUI%: Add, Progress, % "xp yp wp hp BackgroundBlack HWNDhwnd Disabled c"settings.iteminfo.colors_tier[parse], 100
		vars.hwnd.settings["tierbar_"parse] := vars.hwnd.help_tooltips["settings_iteminfo item-tier" vars.poe_version . handle] := hwnd
	}

	If (settings.iteminfo.affixinfo = 2)
		Loop 8
		{
			If (A_Index = 1)
				Gui, %GUI%: Add, Text, % "xs Section Center BackgroundTrans HWNDhwnd00 w" wText, % Lang_Trans("global_ilvl")
			color := (settings.iteminfo.colors_ilvl[A_Index] = "ffffff") && (A_Index = 1) ? "Red" : "Black", vars.hwnd.help_tooltips["settings_iteminfo item-level"] := hwnd00, handle := (A_Index = 1) ? "|" : handle "|"
			Gui, %GUI%: Add, Text, % "ys x+" settings.general.fWidth/(A_Index = 1 ? 2 : 4) " w"settings.general.fWidth*3 " c"color " Border Center BackgroundTrans gSettings_iteminfo2 HWNDhwnd0", % settings.iteminfo.ilevels[A_Index]
			Gui, %GUI%: Add, Progress, % "xp yp wp hp BackgroundBlack HWNDhwnd Disabled c"settings.iteminfo.colors_ilvl[A_Index], 100
			vars.hwnd.settings["ilvl_"A_Index] := hwnd0, vars.hwnd.settings["ilvlbar_"A_Index] := vars.hwnd.help_tooltips["settings_iteminfo item-level"handle] := hwnd
		}

	Gui, %GUI%: Add, Checkbox, % "xs Section hp gSettings_iteminfo2 HWNDhwnd Checked"settings.iteminfo.override, % Lang_Trans("m_iteminfo_override")
	vars.hwnd.settings.override := hwnd, vars.hwnd.help_tooltips["settings_iteminfo override"] := hwnd, colors := (settings.general.lang_client != "english") ? ["Gray", "Gray"] : [settings.iteminfo.colors_tier.1, settings.iteminfo.colors_tier.6]

	If vars.poe_version
		Return

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "xs Section Center BackgroundTrans HWNDhwnd0 y+"vars.settings.spacing, % Lang_Trans("m_iteminfo_rules")
	Gui, %GUI%: Add, Pic, % "ys hp w-1 BackgroundTrans HWNDhwnd0", % "HBitmap:*" vars.pics.global.help
	Gui, %GUI%: Font, norm
	Gui, %GUI%: Add, Checkbox, % "Section xs BackgroundTrans gSettings_iteminfo2 HWNDhwnd02 c" colors.2 " Checked"settings.iteminfo.rules.attacks, % Lang_Trans("m_iteminfo_rules", 3)
	vars.hwnd.settings.rule_attacks := hwnd02
	GuiControlGet, text_, Pos, % hwnd02
	checkbox_spacing := text_w + settings.general.fWidth/2

	Gui, %GUI%: Add, Checkbox, % "ys xp+"checkbox_spacing "BackgroundTrans gSettings_iteminfo2 HWNDhwnd03 c" colors.2 " Checked"settings.iteminfo.rules.spells, % Lang_Trans("m_iteminfo_rules", 4)
	vars.hwnd.settings.rule_spells := hwnd03
	Gui, %GUI%: Add, Checkbox, % "ys BackgroundTrans gSettings_iteminfo2 HWNDhwnd06 c" colors.2 " Checked"settings.iteminfo.rules.crit, % Lang_Trans("m_iteminfo_rules", 7)
	vars.hwnd.settings.rule_crit := hwnd06
	Gui, %GUI%: Add, Checkbox, % "xs Section BackgroundTrans gSettings_iteminfo2 HWNDhwnd04 c" colors.1 " Checked"settings.iteminfo.rules.res, % Lang_Trans("m_iteminfo_rules", 5)
	vars.hwnd.settings.rule_res := hwnd04
	Gui, %GUI%: Add, Checkbox, % "ys xp+"checkbox_spacing " BackgroundTrans gSettings_iteminfo2 HWNDhwnd05 c" colors.2 "" " Checked"settings.iteminfo.rules.hitgain, % Lang_Trans("m_iteminfo_rules", 6)
	vars.hwnd.settings.rule_hitgain := hwnd05

	If (settings.general.lang_client != "english")
		Loop 6
			handle .= "|", vars.hwnd.help_tooltips["settings_lang unavailable" . handle] := hwnd0%A_Index%
}

Settings_iteminfo2(cHWND)
{
	local
	global vars, settings

	check := LLK_HasVal(vars.hwnd.settings, cHWND), control := SubStr(check, InStr(check, "_") + 1)

	If (check = "enable")
	{
		IniWrite, % (settings.features.iteminfo := LLK_ControlGet(cHWND)), % "ini" vars.poe_version "\config.ini", Features, enable item-info
		If WinExist("ahk_id " vars.hwnd.iteminfo.main)
			LLK_Overlay(vars.hwnd.iteminfo.main, "destroy")
		Settings_menu("item-info")
		Return
	}
	Else If InStr(check, "profile_")
	{
		GuiControl, +cWhite, % vars.hwnd.settings["profile_"settings.iteminfo.profile]
		GuiControl, movedraw, % vars.hwnd.settings["profile_"settings.iteminfo.profile]
		GuiControl, +cFuchsia, % vars.hwnd.settings[check]
		GuiControl, movedraw, % vars.hwnd.settings[check]
		settings.iteminfo.profile := control
		IniWrite, % control, % "ini" vars.poe_version "\item-checker.ini", settings, current profile
		Init_iteminfo()
	}
	Else If (check = "desired")
	{
		If LLK_Progress(vars.hwnd.settings.delbar_desired, "LButton", cHWND)
		{
			IniRead, parse, % "ini" vars.poe_version "\item-checker.ini", % "highlighting "settings.iteminfo.profile
			Loop, Parse, parse, `n
			{
				key := SubStr(A_LoopField, 1, InStr(A_LoopField, "=") - 1)
				If InStr(key, "highlight")
					IniWrite, % "", % "ini" vars.poe_version "\item-checker.ini", % "highlighting "settings.iteminfo.profile, % key
			}
			Init_iteminfo()
		}
		Else Return
	}
	Else If (check = "undesired")
	{
		If LLK_Progress(vars.hwnd.settings.delbar_undesired, "LButton", cHWND)
		{
			IniRead, parse, % "ini" vars.poe_version "\item-checker.ini", % "highlighting "settings.iteminfo.profile
			Loop, Parse, parse, `n
			{
				key := SubStr(A_LoopField, 1, InStr(A_LoopField, "=") - 1)
				If InStr(key, "blacklist")
					IniWrite, % "", % "ini" vars.poe_version "\item-checker.ini", % "highlighting "settings.iteminfo.profile, % key
			}
			Init_iteminfo()
		}
		Else Return
	}
	Else If InStr("omni_key,alt_key", check)
		IniWrite, % (settings.iteminfo.omnikey := LLK_ControlGet(vars.hwnd.settings.omni_key)), % "ini" vars.poe_version "\item-checker.ini", Settings, omni-key activation
	Else If InStr(check, "font_")
	{
		While GetKeyState("LButton", "P")
		{
			If (control = "minus")
				settings.iteminfo.fSize -= (settings.iteminfo.fSize > 6) ? 1 : 0
			Else If (control = "reset")
				settings.iteminfo.fSize := settings.general.fSize
			Else settings.iteminfo.fSize += 1
			GuiControl, text, % vars.hwnd.settings.font_reset, % settings.iteminfo.fSize
			Sleep 150
		}
		LLK_FontDimensions(settings.iteminfo.fSize, height, width), settings.iteminfo.fWidth := width, settings.iteminfo.fHeight := height, vars.iteminfo.UI := {}
		IniWrite, % settings.iteminfo.fSize, % "ini" vars.poe_version "\item-checker.ini", settings, font-size
	}
	Else If (check = "trigger")
	{
		settings.iteminfo.trigger := LLK_ControlGet(cHWND), Settings_ScreenChecksValid()
		IniWrite, % settings.iteminfo.trigger, % "ini" vars.poe_version "\item-checker.ini", settings, enable wisdom-scroll trigger
	}
	Else If (check = "modrolls")
		IniWrite, % (settings.iteminfo.modrolls := LLK_ControlGet(cHWND)), % "ini" vars.poe_version "\item-checker.ini", settings, hide roll-ranges
	Else If (check = "qual_scaling")
		IniWrite, % (settings.iteminfo.qual_scaling := LLK_ControlGet(cHWND)), % "ini" vars.poe_version "\item-checker.ini", settings, quality scaling
	Else If InStr(check, "roll_range")
		IniWrite, % (settings.iteminfo.roll_range := SubStr(check, 0)), % "ini" vars.poe_version "\item-checker.ini", settings, roll range
	Else If (check = "compare")
	{
		If (settings.general.lang_client != "english")
		{
			GuiControl,, % cHWND, 0
			Return
		}
		settings.iteminfo.compare := LLK_ControlGet(cHWND)
		IniWrite, % settings.iteminfo.compare, % "ini" vars.poe_version "\item-checker.ini", settings, enable gear-tracking
		Init_iteminfo()
		If vars.general.MultiThreading
			StringSend("iteminfo-compare=" settings.iteminfo.compare)
		Settings_menu("item-info")
	}
	Else If (check = "itembase")
	{
		settings.iteminfo.itembase := LLK_ControlGet(cHWND)
		IniWrite, % settings.iteminfo.itembase, % "ini" vars.poe_version "\item-checker.ini", settings, enable base-info
	}
	Else If InStr(check, "affixinfo_")
	{
		previous := settings.iteminfo.affixinfo
		IniWrite, % (settings.iteminfo.affixinfo := control), % "ini" vars.poe_version "\item-checker.ini", settings, affix-info
		If InStr(previous . control, 2)
			Settings_menu("item-info")
	}
	Else If InStr(check, "marking_")
	{
		type := (InStr(control, "class") ? (InStr(control, "undesired") ? 4 : 3) : (control = "desired" ? 1 : 2))
		If (vars.system.click = 1)
			picked_rgb := RGB_Picker(settings.iteminfo.colors_marking[type])
		Else picked_rgb := settings.iteminfo.dColors_marking[type]
		
		If Blank(picked_rgb)
			Return
		IniWrite, % """" (settings.iteminfo.colors_marking[type] := picked_rgb) """", % "ini" vars.poe_version "\item-checker.ini", UI, % StrReplace(control, "_", " ") " highlighting"
		GuiControl, % "+c" picked_rgb, % vars.hwnd.settings[check "_bar"]
		;GuiControl, % "movedraw", % vars.hwnd.settings[check "_bar"]
	}
	Else If InStr(check, "tier_")
	{
		If (vars.system.click = 1)
			picked_rgb := RGB_Picker(settings.iteminfo.colors_tier[control])
		If (vars.system.click = 1) && Blank(picked_rgb)
			Return
		Else color := (vars.system.click = 2) ? settings.iteminfo.dColors_tier[control] : picked_rgb
		GuiControl, +c%color%, % vars.hwnd.settings["tierbar_"control]
		If (control = 1 || control = 6)
		{
			If (control = 6)
				Loop, Parse, % "res_weapons, attacks, spells, hitgain, crit", `,, %A_Space%
				{
					GuiControl, +c%color%, % vars.hwnd.settings["rule_"A_LoopField]
					GuiControl, movedraw, % vars.hwnd.settings["rule_"A_LoopField]
				}
			Else
			{
				GuiControl, +c%color%, % vars.hwnd.settings.rule_res
				GuiControl, movedraw, % vars.hwnd.settings.rule_res
			}
		}
		IniWrite, % """" color """", % "ini" vars.poe_version "\item-checker.ini", UI, % (control = 7) ? "fractured" : "tier "control
		settings.iteminfo.colors_tier[control] := color
	}
	Else If InStr(check, "ilvl_")
	{
		If (vars.system.click = 1)
			picked_rgb := RGB_Picker(settings.iteminfo.Colors_ilvl[control])
		If (vars.system.click = 1) && Blank(picked_rgb)
			Return
		Else color := (vars.system.click = 2) ? settings.iteminfo.dColors_ilvl[control] : picked_rgb
		GuiControl, +c%color%, % vars.hwnd.settings["ilvlbar_"control]
		GuiControl, movedraw, % vars.hwnd.settings["ilvlbar_"control]
		If (control = 1)
		{
			GuiControl, % "+c"(color = "FFFFFF" ? "Red" : "Black"), % cHWND
			GuiControl, movedraw, % cHWND
		}
		IniWrite, % """" color """", % "ini" vars.poe_version "\item-checker.ini", UI, % "ilvl tier "control
		settings.iteminfo.colors_ilvl[control] := color
	}
	Else If (check = "override")
	{
		settings.iteminfo.override := LLK_ControlGet(cHWND)
		IniWrite, % settings.iteminfo.override, % "ini" vars.poe_version "\item-checker.ini", settings, enable blacklist-override
	}
	Else If InStr(check, "rule_")
	{
		If (settings.general.lang_client != "english")
		{
			GuiControl,, % cHWND, 0
			Return
		}
		settings.iteminfo.rules[control] := LLK_ControlGet(cHWND)
		parse := (control = "res_weapons") ? "weapon res" : (control = "hitgain") ? "lifemana gain" : control
		IniWrite, % settings.iteminfo.rules[control], % "ini" vars.poe_version "\item-checker.ini", settings, % parse " override"
	}
	Else LLK_ToolTip("no action")

	If WinExist("ahk_id " vars.hwnd.iteminfo.main)
		Iteminfo(1)
}

Settings_leveltracker()
{
	local
	global vars, settings, db
	static fSize, wImport, wEdit, wLeague, wReset, wPob, wOptionals

	GUI := "settings_menu" vars.settings.GUI_toggle, x_anchor := vars.settings.x_anchor
	Gui, %GUI%: Add, Link, % "Section x" x_anchor " y" vars.settings.ySelection, <a href="https://github.com/Lailloken/Lailloken-UI/wiki/Act‐Tracker">wiki page</a>

	Gui, %GUI%: Add, Checkbox, % "xs y+"vars.settings.spacing " Section gSettings_leveltracker2 HWNDhwnd Checked"settings.features.leveltracker, % Lang_Trans("m_lvltracker_enable")
	vars.hwnd.settings.enable := hwnd, vars.hwnd.help_tooltips["settings_leveltracker enable"] := hwnd

	If !settings.features.leveltracker
		Return

	If !IsObject(db.leveltracker)
		DB_Load("leveltracker")

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "xs Section y+"vars.settings.spacing, % Lang_Trans("global_general")
	Gui, %GUI%: Font, norm
	Gui, %GUI%: Add, Button, % "ys Hidden hp Default gSettings_leveltracker2 HWNDhwnd w" settings.general.fWidth, ok
	vars.hwnd.settings.apply_button := hwnd

	If !vars.client.stream
	{
		Gui, %GUI%: Add, Checkbox, % "xs Section gSettings_leveltracker2 HWNDhwnd Checked"settings.leveltracker.timer, % Lang_Trans("m_lvltracker_timer")
		vars.hwnd.settings.timer := vars.hwnd.help_tooltips["settings_leveltracker timer"] := hwnd
		If settings.leveltracker.timer
		{
			Gui, %GUI%: Add, Checkbox, % "ys x+"settings.general.fWidth/2 " gSettings_leveltracker2 HWNDhwnd Checked"settings.leveltracker.pausetimer, % Lang_Trans("m_lvltracker_pause")
			vars.hwnd.settings.pausetimer := hwnd, vars.hwnd.help_tooltips["settings_leveltracker timer-pause"] := hwnd
		}
	}
	Gui, %GUI%: Add, Checkbox, % "xs Section gSettings_leveltracker2 HWNDhwnd Checked"settings.leveltracker.fade, % Lang_Trans("m_lvltracker_fade")
	vars.hwnd.settings.fade := hwnd, vars.hwnd.help_tooltips["settings_leveltracker fade-timer"] := hwnd
	WinGetPos, xPos,,,, ahk_id %hwnd%
	Gui, %GUI%: Font, % "s"settings.general.fSize - 4
	Gui, %GUI%: Add, Edit, % "ys x+0 hp cBlack Center gSettings_leveltracker2 Limit1 Number HWNDhwnd w"settings.general.fWidth*2, % !settings.leveltracker.fadetime ? 0 : Format("{:0.0f}", settings.leveltracker.fadetime/1000)
	vars.hwnd.settings.fadetime := hwnd, vars.hwnd.help_tooltips["settings_leveltracker fade-timer|"] := hwnd
	Gui, %GUI%: Font, % "s"settings.general.fSize

	If settings.leveltracker.fade
	{
		Gui, %GUI%: Add, Checkbox, % "xs x" xPos + 2*settings.general.fWidth " gSettings_leveltracker2 HWNDhwnd Checked"settings.leveltracker.fade_hover, % Lang_Trans("m_lvltracker_fade", 2)
		vars.hwnd.settings.fade_hover := hwnd, vars.hwnd.help_tooltips["settings_leveltracker fade mouse"] := hwnd
	}

	If !vars.poe_version
	{
		Gui, %GUI%: Add, Checkbox, % "xs Section gSettings_leveltracker2 HWNDhwnd Checked"settings.leveltracker.recommend, % Lang_Trans("m_lvltracker_recommend")
		vars.hwnd.settings.recommend := vars.hwnd.help_tooltips["settings_leveltracker recommendation"] := hwnd
	}

	If !vars.client.stream && !vars.poe_version
	{
		Gui, %GUI%: Add, Checkbox, % "ys gSettings_leveltracker2 HWNDhwnd Checked"settings.leveltracker.geartracker, % Lang_Trans("m_lvltracker_gear")
		vars.hwnd.settings.geartracker := hwnd, vars.hwnd.help_tooltips["settings_leveltracker geartracker"] := hwnd
	}

	Gui, %GUI%: Add, Checkbox, % "Section xs gSettings_leveltracker2 HWNDhwnd Checked" settings.leveltracker.hotkeys, % Lang_Trans("m_lvltracker_hotkeys")
	vars.hwnd.settings.hotkeys_enable := vars.hwnd.help_tooltips["settings_leveltracker hotkeys enable"] := hwnd
	If settings.leveltracker.hotkeys
	{
		width := settings.general.fWidth * 6
		Gui, %GUI%: Font, % "s" settings.general.fSize - 4
		Gui, %GUI%: Add, Edit, % "Section ys Right cBlack HWNDhwnd1 gSettings_leveltracker2 Limit w" width " h" settings.general.fHeight, % settings.leveltracker.hotkey_1
		Gui, %GUI%: Font, % "s" settings.general.fSize
		Gui, %GUI%: Add, Text, % "ys x+0 Center BackgroundTrans Border w" settings.general.fWidth * 2, % "<"
		Gui, %GUI%: Add, Text, % "ys x+0 Center BackgroundTrans Border wp", % ">"
		Gui, %GUI%: Font, % "s" settings.general.fSize - 4
		Gui, %GUI%: Add, Edit, % "ys x+0 cBlack HWNDhwnd2 Limit gSettings_leveltracker2 w" width " h" settings.general.fHeight, % settings.leveltracker.hotkey_2
		Gui, %GUI%: Font, % "s" settings.general.fSize
		vars.hwnd.settings.hotkey_1 := vars.hwnd.help_tooltips["settings_leveltracker hotkeys"] := hwnd1, vars.hwnd.settings.hotkey_2 := vars.hwnd.help_tooltips["settings_leveltracker hotkeys|"] := hwnd2
	}

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "xs y+"vars.settings.spacing " Section x" x_anchor, % Lang_Trans("m_lvltracker_guide")
	Gui, %GUI%: Font, norm

	Gui, %GUI%: Add, Pic, % "ys hp w-1 HWNDhwnd", % "HBitmap:*" vars.pics.global.help
	vars.hwnd.help_tooltips["settings_leveltracker guide info" vars.poe_version] := hwnd

	handle := "", bandits := ["none", "alira", "kraityn", "oak"], profile := settings.leveltracker.profile, files := 0
	If (fSize != settings.general.fSize)
	{
		LLK_PanelDimensions([Lang_Trans("global_import")], settings.general.fSize, wImport, hImport)
		LLK_PanelDimensions([Lang_Trans("global_edit")], settings.general.fSize, wEdit, hEdit)
		LLK_PanelDimensions([Lang_Trans("m_lvltracker_leaguestart")], settings.general.fSize, wLeague, hLeague)
		If (wLeague > wEdit + wImport + settings.general.fWidth/4)
			wEdit := wLeague - wImport - settings.general.fWidth/4
		Else wLeague := wEdit + wImport + settings.general.fWidth/4

		LLK_PanelDimensions([Lang_Trans("global_reset")], settings.general.fSize, wReset, hReset)
		LLK_PanelDimensions(["pob"], settings.general.fSize, wPob, hPob)
		LLK_PanelDimensions([Lang_Trans("m_lvltracker_optionals")], settings.general.fSize, wOptionals, hOptionals)
		If (wOptionals > wReset + wPob + settings.general.fWidth/4)
			wPob := wOptionals - wReset - settings.general.fWidth/4
		Else wOptionals := wReset + wPob + settings.general.fWidth/4
		fSize := settings.general.fSize
	}

	Gui, %GUI%: Font, % "s" settings.general.fSize - 4
	Gui, %GUI%: Add, Edit, % "Section xs Hidden HWNDhwnd h" settings.general.fHeight, bla
	ControlGetPos,,,, hEdit,, ahk_id %hwnd%
	Gui, %GUI%: Font, % "s" settings.general.fSize

	For index, val in ["", 2, 3]
	{
		file_missing := !FileExist("ini" vars.poe_version "\leveling guide" val ".ini") ? 1 : 0
		files += file_missing ? 0 : 1
		Gui, %GUI%: Add, Text, % (index = 1 ? "Section xp yp" : "xs y+" settings.general.fWidth/4) " Border BackgroundTrans Center 0x200 gSettings_leveltracker2 h" hEdit " HWNDhwnd w" settings.general.fWidth * 2 . (profile = val ? " cFuchsia" : ""), % index
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp BackgroundBlack Vertical cRed Range0-500 HWNDhwnd1", 0
		vars.hwnd.settings["profile" val] := hwnd, vars.hwnd.settings["profile" val "_bar"] := hwnd1, vars.hwnd.help_tooltips["settings_leveltracker profile select" handle] := hwnd1
		If (index = 1)
			ControlGetPos, xFirst, yFirst,, hFirst,, ahk_id %hwnd%
		Else ControlGetPos, xLabel, yLabel,, hLabel,, ahk_id %hwnd%
		Gui, %GUI%: Font, % "s" settings.general.fSize - 4
		Gui, %GUI%: Add, Edit, % "yp x+" settings.general.fWidth/4 " cBlack HWNDhwnd Limit r1 gSettings_leveltracker2 w" settings.general.fWidth*13 (file_missing ? " Hidden" : ""), % settings.leveltracker["guide" val].info.name
		Gui, %GUI%: Font, % "s" settings.general.fSize
		vars.hwnd.settings["name" val] := vars.hwnd.help_tooltips["settings_leveltracker profile name" handle] := hwnd
		handle .= "|"

		If (index < 3)
			Continue

		If files
			Gui, %GUI%: Add, Progress, % "ys x+" settings.general.fWidth/2 " Disabled BackgroundWhite w" settings.general.fWidth/4 " h" yLabel + hLabel - yFirst, 0

		If FileExist("ini" vars.poe_version "\leveling guide" settings.leveltracker.profile ".ini")
		{
			Gui, %GUI%: Add, Text, % "ys Section x+"settings.general.fWidth/2 " Center Border gSettings_leveltracker2 HWNDhwnd w" wImport, % Lang_Trans("global_import")
			vars.hwnd.settings["import"] := vars.hwnd.help_tooltips["settings_leveltracker import"] := hwnd

			Gui, %GUI%: Add, Text, % "ys x+"settings.general.fWidth/4 " Center Border BackgroundTrans gSettings_leveltracker2 HWNDhwnd w" wEdit, % Lang_Trans("global_edit")
			vars.hwnd.settings["editprofile"] := vars.hwnd.help_tooltips["settings_leveltracker editor"] := hwnd

			Gui, %GUI%: Add, Text, % "ys x+"settings.general.fWidth/4 " Center Border BackgroundTrans gSettings_leveltracker2 HWNDhwnd w" wReset, % Lang_Trans("global_reset")
			Gui, %GUI%: Add, Progress, % "xp yp wp hp Border Disabled BackgroundBlack cRed HWNDhwnd1 Vertical Range0-500", 0
			vars.hwnd.settings["reset"] := hwnd, vars.hwnd.settings["resetbar"] := vars.hwnd.help_tooltips["settings_leveltracker reset"] := hwnd1

			If vars.leveltracker["pob" profile].Count()
			{
				Gui, %GUI%: Add, Text, % "ys x+" settings.general.fWidth/4 " Center BackgroundTrans cLime Border gSettings_leveltracker2 HWNDhwnd w" wPob, % "pob"
				Gui, %GUI%: Add, Progress, % "xp yp wp hp Border Disabled BackgroundBlack Vertical cRed HWNDhwnd1 range0-500", 0
				vars.hwnd.settings["pobpreview"] := hwnd
				vars.hwnd.settings["pobpreview_bar"] := vars.hwnd.help_tooltips["settings_leveltracker pob preview"] := hwnd1
			}

			Gui, %GUI%: Add, Text, % "Section xs y+" settings.general.fWidth/4 " Border Center gSettings_leveltracker2 HWNDhwnd c" (settings.leveltracker["guide" profile].info.leaguestart ? "Lime" : "Gray") " w" wLeague
			, % Lang_Trans("m_lvltracker_leaguestart")
			vars.hwnd.settings["leaguestart"] := vars.hwnd.help_tooltips["settings_leveltracker leaguestart" vars.poe_version] := hwnd

			Gui, %GUI%: Add, Text, % "ys x+" settings.general.fWidth/4 " Border Center gSettings_leveltracker2 HWNDhwnd c" (settings.leveltracker["guide" profile].info.optionals ? "Lime" : "Gray") " w" wOptionals
			, % Lang_Trans("m_lvltracker_optionals")
			vars.hwnd.settings["optionals"] := vars.hwnd.help_tooltips["settings_leveltracker optionals" vars.poe_version] := hwnd

			If !vars.poe_version
			{
				Gui, %Gui%: Add, Text, % "xs hp Center Border y+" settings.general.fWidth/4, % " " Lang_Trans("m_lvltracker_bandit") " "
				Gui, %GUI%: Font, % "s" settings.general.fSize - 4
				Gui, %GUI%: Add, DDL, % "yp x+-1 r4 AltSubmit gSettings_leveltracker2 HWNDhwnd Choose" LLK_HasVal(bandits, settings.leveltracker["guide" profile].info.bandit) " w" settings.general.fWidth * 8
				, % Lang_Trans("global_none") "|" Lang_Trans("m_lvltracker_bandits") "|" Lang_Trans("m_lvltracker_bandits", 2) "|" Lang_Trans("m_lvltracker_bandits", 3)
				vars.hwnd.settings["bandit"] := vars.hwnd.help_tooltips["settings_leveltracker bandit"] := hwnd
				Gui, %GUI%: Font, % "s" settings.general.fSize
			}
		}
		Else
		{
			Gui, %GUI%: Add, Text, % (files ? "ys x+"settings.general.fWidth/2 : "ys x" x_anchor + settings.general.fWidth*2.25) " Center 0x200 Border BackgroundTrans gSettings_leveltracker2 HWNDhwnd_load", % " " Lang_Trans("lvltracker_editor_load") " "
			vars.hwnd.settings["loaddefault"] := vars.hwnd.help_tooltips["settings_leveltracker default"] := hwnd_load
		}
	}

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "xs Section x" x_anchor " y" yLabel + hLabel + vars.settings.spacing, % Lang_Trans("m_lvltracker_poboverlays")
	Gui, %GUI%: Font, norm
	Gui, %GUI%: Add, Picture, % "ys BackgroundTrans hp HWNDhwnd0 w-1", % "HBitmap:*" vars.pics.global.help
	vars.hwnd.help_tooltips["settings_leveltracker skilltree-info"] := hwnd0

	If !settings.leveltracker.pobmanual && FileExist("data\global\[leveltracker] tree" vars.poe_version " *.json")
	{
		Gui, %GUI%: Add, Text, % "ys Center Border BackgroundTrans gSettings_leveltracker2 HWNDhwnd", % " " Lang_Trans("m_lvltracker_treeclear") " "
		Gui, %GUI%: Add, Progress, % "xp yp wp hp Disabled Border HWNDhwnd1 BackgroundBlack Vertical cRed Range0-500", 0
		vars.hwnd.settings.treeclear := hwnd, vars.hwnd.help_tooltips["settings_leveltracker skilltree clear"] := vars.hwnd.settings.treeclear_bar := hwnd1
	}

	Gui, %GUI%: Add, Checkbox, % "xs Section gSettings_leveltracker2 HWNDhwnd Checked" settings.leveltracker.gemlinksToggle, % Lang_Trans("m_lvltracker_pobgems")
	vars.hwnd.settings.pobgems := vars.hwnd.help_tooltips["settings_leveltracker pob gems"] := hwnd
	Gui, %GUI%: Add, Checkbox, % "xs Section gSettings_leveltracker2 HWNDhwnd Checked" settings.leveltracker.pobmanual, % Lang_Trans("m_lvltracker_pobmanual")
	vars.hwnd.settings.pobmanual := vars.hwnd.help_tooltips["settings_leveltracker pob manual"] := hwnd

	If settings.leveltracker.pobmanual
	{
		Gui, %GUI%: Add, Checkbox, % "xs Section gSettings_leveltracker2 HWNDhwnd Checked"settings.leveltracker.pob, % Lang_Trans("m_lvltracker_pob")
		vars.hwnd.settings.pob := vars.hwnd.help_tooltips["settings_leveltracker pob"] := hwnd
		Gui, %GUI%: Add, Text, % "xs Section gSettings_leveltracker2 Border HWNDhwnd", % " " Lang_Trans("m_lvltracker_screencap") " "
		vars.hwnd.settings.screencap := vars.hwnd.help_tooltips["settings_leveltracker screen-cap menu"] := hwnd
		Gui, %GUI%: Add, Text, % "ys x+"settings.general.fWidth/4 " gSettings_leveltracker2 Border HWNDhwnd", % " " Lang_Trans("global_imgfolder") " "
		vars.hwnd.settings.folder := vars.hwnd.help_tooltips["settings_leveltracker folder"] := hwnd
	}

	Gui, %GUI%: Font, underline bold
	Gui, %GUI%: Add, Text, % "xs Section BackgroundTrans y+"vars.settings.spacing, % Lang_Trans("global_ui")
	Gui, %GUI%: Font, norm

	Gui, %GUI%: Add, Text, % "xs Section Center HWNDhwnd0", % Lang_Trans("global_font")
	Gui, %GUI%: Add, Text, % "ys Center gSettings_leveltracker2 Border HWNDhwnd w"settings.general.fWidth*2, % "–"
	vars.hwnd.help_tooltips["settings_font-size"] := hwnd0, vars.hwnd.settings.font_minus := vars.hwnd.help_tooltips["settings_font-size|"] := hwnd
	Gui, %GUI%: Add, Text, % "ys x+"settings.general.fWidth/4 " Center gSettings_leveltracker2 Border HWNDhwnd w"settings.general.fWidth*3, % settings.leveltracker.fSize
	vars.hwnd.settings.font_reset := vars.hwnd.help_tooltips["settings_font-size||"] := hwnd
	Gui, %GUI%: Add, Text, % "ys x+"settings.general.fWidth/4 " Center gSettings_leveltracker2 Border HWNDhwnd w"settings.general.fWidth*2, % "+"
	vars.hwnd.settings.font_plus := vars.hwnd.help_tooltips["settings_font-size|||"] := hwnd

	Gui, %GUI%: Add, Text, % "ys Center", % Lang_Trans("global_opacity")
	Loop 5
	{
		Gui, %GUI%: Add, Text, % "ys" (A_Index = 1 ? "" : " x+" settings.general.fWidth / 4) " Center gSettings_leveltracker2 Border HWNDhwnd w" settings.general.fWidth * 2 (settings.leveltracker.trans = A_Index ? " cFuchsia" : ""), % A_Index
		vars.hwnd.settings["opac_" A_Index] := hwnd
	}
}

Settings_leveltracker2(cHWND := "")
{
	local
	global vars, settings, JSON, db

	If !IsObject(db.leveltracker)
		DB_Load("leveltracker")

	check := LLK_HasVal(vars.hwnd.settings, cHWND), control := SubStr(check, InStr(check, "_") + 1)
	If (check = "enable")
	{
		settings.features.leveltracker := LLK_ControlGet(cHWND), timer := vars.leveltracker.timer
		If !settings.features.leveltracker && IsNumber(timer.current_split) && (timer.current_split != timer.current_split0) ;save current timer state
			IniWrite, % (timer.current_split0 := timer.current_split), % "ini" vars.poe_version "\leveling tracker.ini", % "current run" settings.leveltracker.profile, time
		IniWrite, % settings.features.leveltracker, % "ini" vars.poe_version "\config.ini", features, enable leveling guide
		Leveltracker_Toggle("destroy"), LLK_Overlay(vars.hwnd.geartracker.main, "destroy")
		vars.leveltracker := "", vars.hwnd.Delete("leveltracker"), vars.hwnd.Delete("geartracker")
		If settings.features.leveltracker
			Init_leveltracker()
		Settings_menu("leveling tracker"), Init_GUI()
	}
	Else If (check = "timer")
	{
		settings.leveltracker.timer := LLK_ControlGet(cHWND), timer := vars.leveltracker.timer
		IniWrite, % settings.leveltracker.timer, % "ini" vars.poe_version "\leveling tracker.ini", settings, enable timer
		If !settings.leveltracker.timer && IsNumber(timer.current_split) && (timer.current_split != timer.current_split0)
			IniWrite, % (timer.current_split0 := timer.current_split), % "ini" vars.poe_version "\leveling tracker.ini", % "current run" settings.leveltracker.profile, time
		If LLK_Overlay(vars.hwnd.leveltracker.main, "check")
			Leveltracker_Progress(1)
		vars.leveltracker.timer.pause := -1, Settings_menu("leveling tracker")
	}
	Else If (check = "pausetimer")
	{
		settings.leveltracker.pausetimer := LLK_ControlGet(cHWND)
		IniWrite, % settings.leveltracker.pausetimer, % "ini" vars.poe_version "\leveling tracker.ini", settings, hideout pause
	}
	Else If (check = "fade")
	{
		settings.leveltracker.fade := LLK_ControlGet(cHWND)
		If !settings.leveltracker.fade && LLK_Overlay(vars.hwnd.leveltracker.main, "check")
			Leveltracker_Progress(1)
		IniWrite, % settings.leveltracker.fade, % "ini" vars.poe_version "\leveling tracker.ini", settings, enable fading
		Settings_menu("leveling tracker")
	}
	Else If (check = "fadetime")
	{
		settings.leveltracker.fadetime := !LLK_ControlGet(cHWND) ? 0 : Format("{:0.0f}", LLK_ControlGet(cHWND)*1000)
		IniWrite, % settings.leveltracker.fadetime, % "ini" vars.poe_version "\leveling tracker.ini", settings, fade-time
	}
	Else If (check = "fade_hover")
	{
		settings.leveltracker.fade_hover := LLK_ControlGet(cHWND)
		IniWrite, % settings.leveltracker.fade_hover, % "ini" vars.poe_version "\leveling tracker.ini", settings, show on hover
	}
	Else If (check = "geartracker")
	{
		settings.leveltracker.geartracker := LLK_ControlGet(cHWND)
		IniWrite, % settings.leveltracker.geartracker, % "ini" vars.poe_version "\leveling tracker.ini", settings, enable geartracker
		If settings.leveltracker.geartracker
			Geartracker_GUI("refresh")
	}
	Else If (check = "recommend")
	{
		IniWrite, % (settings.leveltracker.recommend := LLK_ControlGet(cHWND)), % "ini" vars.poe_version "\leveling tracker.ini", settings, enable level recommendations
		If LLK_Overlay(vars.hwnd.leveltracker.main, "check")
			Leveltracker_Progress(1)
	}
	Else If (check = "hotkeys_enable")
	{
		IniWrite, % (settings.leveltracker.hotkeys := LLK_ControlGet(cHWND)), % "ini" vars.poe_version "\leveling tracker.ini", settings, enable page hotkeys
		settings.leveltracker.hotkey_01 := settings.leveltracker.hotkey_1, settings.leveltracker.hotkey_02 := settings.leveltracker.hotkey_2
		Leveltracker_Hotkeys("refresh"), Settings_menu("leveling tracker")
	}
	Else If InStr(check, "hotkey_")
	{
		GuiControl, % "+c" (LLK_ControlGet(cHWND) != settings.leveltracker[check] ? "Red" : "Black"), % cHWND
		GuiControl, movedraw, % cHWND
	}
	Else If (check = "apply_button")
	{
		ControlGetFocus, hwnd, % "ahk_id " vars.hwnd.settings.main
		ControlGet, hwnd, HWND,, % hwnd
		If !InStr(vars.hwnd.settings.hotkey_1 "," vars.hwnd.settings.hotkey_2, hwnd) && !(name := InStr(vars.hwnd.settings.name "," vars.hwnd.settings.name2 "," vars.hwnd.settings.name3, hwnd))
			Return
		input0 := LLK_ControlGet(hwnd)
		If !name
		{
			If (StrLen(input0) > 1)
				Loop, Parse, % "^!+#"
					input := (A_Index = 1) ? input0 : input, input := StrReplace(input, A_LoopField)

			If !GetKeyVK(input)
			{
				WinGetPos, x, y, w, h, ahk_id %hwnd%
				LLK_ToolTip(Lang_Trans("m_hotkeys_error"), 1.5, x, y + h - 1,, "Red")
				Return
			}
			settings.leveltracker.hotkey_01 := settings.leveltracker.hotkey_1, settings.leveltracker.hotkey_02 := settings.leveltracker.hotkey_2
			control := (hwnd = vars.hwnd.settings.hotkey_1) ? 1 : 2
			IniWrite, % (settings.leveltracker["hotkey_" control] := input0), % "ini" vars.poe_version "\leveling tracker.ini", settings, % "hotkey " control
			Leveltracker_Hotkeys("refresh")
		}
		Else
		{
			Loop, Parse, input0
				If !LLK_IsType(A_LoopField, "alnum")
				{
					LLK_ToolTip(Lang_Trans("global_errorname", 3), 2,,,, "red")
					Return
				}
			check := LLK_HasVal(vars.hwnd.settings, hwnd)
			number := IsNumber(SubStr(check, 0)) ? SubStr(check, 0) : ""
			IniWrite, % """" (settings.leveltracker["guide" number].info.name := input0) """", % "ini" vars.poe_version "\leveling guide" number ".ini", info, name
		}
		GuiControl, +cBlack, % hwnd
		GuiControl, movedraw, % hwnd
	}
	Else If (check = "treeclear")
	{
		If LLK_Progress(vars.hwnd.settings.treeclear_bar, "LButton")
		{
			KeyWait, LButton
			For index, version in db.leveltracker.trees.supported
			{
				FileDelete, % "data\global\[leveltracker] tree" vars.poe_version " " version ".json"
				db.leveltracker.trees.Delete(version)
			}
			Settings_menu("leveling tracker")
			LLK_ToolTip(Lang_Trans("global_success"), 1,,,, "Lime")
			Return
		}
	}
	Else If (check = "pobgems")
		IniWrite, % (settings.leveltracker.gemlinksToggle := LLK_ControlGet(cHWND)), % "ini" vars.poe_version "\leveling tracker.ini", settings, toggle gem-links
	Else If (check = "pobmanual")
	{
		IniWrite, % (settings.leveltracker.pobmanual := LLK_ControlGet(cHWND)), % "ini" vars.poe_version "\leveling tracker.ini", settings, manual pob-screencap
		Settings_menu("leveling tracker")
	}
	Else If (check = "pob")
		IniWrite, % (settings.leveltracker.pob := LLK_ControlGet(cHWND)), % "ini" vars.poe_version "\leveling tracker.ini", settings, enable pob-screencap
	Else If (check = "screencap")
	{
		KeyWait, LButton
		LLK_Overlay(vars.hwnd.settings.main, "hide"), Leveltracker_ScreencapMenu()
	}
	Else If (check = "folder")
	{
		KeyWait, LButton
		Run, % "explore img\GUI\skill-tree" settings.leveltracker.profile "\"
	}
	Else If InStr(check, "editprofile")
		Leveltracker_GuideEditor("profile#" settings.leveltracker.profile), LLK_Overlay(vars.hwnd.settings.main, "hide")
	Else If InStr(check, "profile")
	{
		target_profile := IsNumber(SubStr(check, 0)) ? SubStr(check, 0) : ""
		If FileExist("ini" vars.poe_version "\leveling guide" target_profile ".ini") && LLK_Progress(vars.hwnd.settings["profile" target_profile "_bar"], "RButton")
		{
			FileDelete, % "ini" vars.poe_version "\leveling guide" target_profile ".ini"
			Init_leveltracker()
			If (settings.leveltracker.profile = target_profile)
			{
				Leveltracker_Toggle("destroy"), vars.hwnd.leveltracker.main := ""
				Leveltracker_Load(settings.leveltracker.profile)
			}
			Settings_menu("leveling tracker")
			Return
		}
		Else If (vars.system.click = 2)
			Return
		KeyWait, LButton
		KeyWait, RButton
		If (settings.leveltracker.profile = target_profile)
			Return
		GuiControl, +cWhite, % vars.hwnd.settings["profile" settings.leveltracker.profile]
		GuiControl, movedraw, % vars.hwnd.settings["profile" settings.leveltracker.profile]
		timer := vars.leveltracker.timer
		If IsNumber(timer.current_split) && (timer.current_split != timer.current_split0)
			IniWrite, % (timer.current_split0 := timer.current_split), % "ini" vars.poe_version "\leveling tracker.ini", % "current run" settings.leveltracker.profile, time
		settings.leveltracker.profile := target_profile, vars.leveltracker.timer.pause := -1
		IniWrite, % settings.leveltracker.profile, % "ini" vars.poe_version "\leveling tracker.ini", Settings, profile
		GuiControl, +cFuchsia, % vars.hwnd.settings["profile" settings.leveltracker.profile]
		GuiControl, movedraw, % vars.hwnd.settings["profile" settings.leveltracker.profile]
		If vars.leveltracker.skilltree_schematics.GUI
			Leveltracker_PobSkilltree("close")
		Init_leveltracker(), Leveltracker_Load()
		If LLK_Overlay(vars.hwnd.leveltracker.main, "check") && vars.leveltracker.guide.import.Count()
			Leveltracker_Progress(1)
		Else Leveltracker_Toggle("destroy"), vars.hwnd.leveltracker.main := ""
		Settings_menu("leveling tracker")
	}
	Else If InStr(check, "import")
	{
		KeyWait, LButton
		profile := settings.leveltracker.profile
		If vars.leveltracker.skilltree_schematics.GUI
			Leveltracker_PobSkilltree("close")
		If Leveltracker_Import(IsNumber(profile) ? profile : "")
			LLK_ToolTip(Lang_Trans("global_success"),,,,, "Lime")
	}
	Else If InStr(check, "loaddefault")
		Leveltracker_GuideEditor("default#" settings.leveltracker.profile)
	Else If InStr(check, "reset") && !InStr(check, "font")
	{
		If LLK_Progress(vars.hwnd.settings.resetbar, "LButton")
			Leveltracker_ProgressReset(settings.leveltracker.profile)
		Else Return
	}
	Else If InStr(check, "name")
	{
		input := LLK_ControlGet(cHWND), number := IsNumber(SubStr(check, 0)) ? SubStr(check, 0) : ""
		GuiControl, % "+c" (input != vars.settings.guidenames[number ? number : 1] ? "Red" : "Black"), % cHWND
		GuiControl, % "movedraw", % cHWND
	}
	Else If InStr(check, "pobpreview")
	{
		profile := settings.leveltracker.profile, info := vars.leveltracker["pob" profile]
		If LLK_Progress(vars.hwnd.settings[check "_bar"], "RButton")
		{
			If vars.leveltracker.skilltree_schematics.GUI
				Leveltracker_PobSkilltree("close")
			IniDelete, % "ini" vars.poe_version "\leveling guide" profile ".ini", PoB
			Init_leveltracker()
			Leveltracker_Load()
			If LLK_Overlay(vars.hwnd.leveltracker.main, "check")
				Leveltracker_Progress(1)
			Settings_menu("leveling tracker")
			Return
		}
		For index, val in info.ascendancies
			ascendancy .= (!ascendancy ? "" : ", ") val
		text := "class: " info.class "`nascendancy: " ascendancy (!vars.poe_version ? "`nbandit: " info.bandit : "") "`nskill-sets: " info.gems.Count() "`nskill-trees: " info.trees.Count()
		LLK_ToolTip(text, 0,,, "pobtooltip")
		KeyWait, LButton
		vars.tooltip[vars.hwnd["tooltippobtooltip"]] := A_TickCount
	}
	Else If InStr(check, "leaguestart")
	{
		profile := settings.leveltracker.profile
		IniWrite, % (input := settings.leveltracker["guide" profile].info.leaguestart := !settings.leveltracker["guide" profile].info.leaguestart), % "ini" vars.poe_version "\leveling guide" profile ".ini", Info, leaguestart
		IniWrite, 0, % "ini" vars.poe_version "\leveling guide" profile ".ini", Progress, pages
		Leveltracker_Load()
		If LLK_Overlay(vars.hwnd.leveltracker.main, "check")
			Leveltracker_Progress(1)
		GuiControl, % "+c" (input ? "Lime" : "Gray"), % cHWND
		GuiControl, % "movedraw", % cHWND
	}
	Else If InStr(check, "optionals")
	{
		profile := settings.leveltracker.profile
		IniWrite, % (input := settings.leveltracker["guide" profile].info.optionals := !settings.leveltracker["guide" profile].info.optionals), % "ini" vars.poe_version "\leveling guide" profile ".ini", Info, optionals
		If LLK_Overlay(vars.hwnd.leveltracker.main, "check")
			Leveltracker_Progress(1)
		GuiControl, % "+c" (input ? "Lime" : "Gray"), % cHWND
		GuiControl, % "movedraw", % cHWND
	}
	Else If InStr(check, "bandit")
	{
		bandits := ["none", "alira", "kraityn", "oak"], profile := settings.leveltracker.profile
		IniWrite, % (settings.leveltracker["guide" profile].info.bandit := bandits[LLK_ControlGet(cHWND)]), % "ini" vars.poe_version "\leveling guide" profile ".ini", Info, bandit
		IniWrite, 0, % "ini" vars.poe_version "\leveling guide" profile ".ini", Progress, pages
		Leveltracker_Load()
		If LLK_Overlay(vars.hwnd.leveltracker.main, "check")
			Leveltracker_Progress(1)
	}
	Else If InStr(check, "font_")
	{
		While GetKeyState("LButton", "P")
		{
			If (control = "minus") && (settings.leveltracker.fSize > 6)
				settings.leveltracker.fSize -= 1
			Else If (control = "reset")
				settings.leveltracker.fSize := settings.general.fSize
			Else If (control = "plus")
				settings.leveltracker.fSize += 1
			GuiControl, text, % vars.hwnd.settings.font_reset, % settings.leveltracker.fSize
			Sleep 150
		}
		IniWrite, % settings.leveltracker.fSize, % "ini" vars.poe_version "\leveling tracker.ini", settings, font-size
		LLK_FontDimensions(settings.leveltracker.fSize, height, width), settings.leveltracker.fHeight := height, settings.leveltracker.fWidth := width
		If LLK_Overlay(vars.hwnd.leveltracker.main, "check")
			Leveltracker()
		If WinExist("ahk_id "vars.hwnd.geartracker.main)
			Geartracker_GUI()
	}
	Else If InStr(check, "opac_")
	{
		GuiControl, +cWhite, % vars.hwnd.settings["opac_" settings.leveltracker.trans]
		GuiControl, movedraw, % vars.hwnd.settings["opac_" settings.leveltracker.trans]
		settings.leveltracker.trans := control
		If LLK_Overlay(vars.hwnd.leveltracker.main, "check")
			Leveltracker()
		IniWrite, % settings.leveltracker.trans, % "ini" vars.poe_version "\leveling tracker.ini", settings, transparency
		GuiControl, +cFuchsia, % vars.hwnd.settings["opac_" control]
		GuiControl, movedraw, % vars.hwnd.settings["opac_" control]
	}
	Else LLK_ToolTip("no action")
}

Settings_lootfilter()
{
	local
	global vars, settings

	GUI := "settings_menu" vars.settings.GUI_toggle, x_anchor := vars.settings.x_anchor
	Gui, %GUI%: Add, Link, % "Section x" x_anchor " y" vars.settings.ySelection, <a href="https://github.com/Lailloken/Lailloken-UI/wiki/FilterSpoon">wiki page</a>

	Gui, %GUI%: Add, Checkbox, % "xs Section gSettings_lootfilter2 y+" vars.settings.spacing " HWNDhwnd Checked" settings.features.lootfilter, % Lang_Trans("m_lootfilter_enable")
	vars.hwnd.settings.enable := vars.hwnd.help_tooltips["settings_lootfilter enable"] := hwnd

	If !settings.features.lootfilter
		Return
}

Settings_lootfilter2(cHWND := "")
{
	local
	global vars, settings

	check := LLK_HasVal(vars.hwnd.settings, cHWND), control := SubStr(check, InStr(check, "_") + 1)
	If (check = "enable")
	{
		IniWrite, % (settings.features.lootfilter := LLK_ControlGet(cHWND)), % "ini" vars.poe_version "\config.ini", features, enable filterspoon
		If !settings.features.lootfilter && WinExist("ahk_id " vars.hwnd.lootfilter.main)
			Lootfilter_GUI("close")
		Settings_menu("filterspoon")
	}
}

Settings_mapinfo()
{
	local
	global vars, settings, db

	GUI := "settings_menu" vars.settings.GUI_toggle, x_anchor := vars.settings.x_anchor
	Gui, %GUI%: Add, Link, % "Section x" x_anchor " y" vars.settings.ySelection, <a href="https://github.com/Lailloken/Lailloken-UI/wiki/Map-info-panel">wiki page</a>

	If (settings.general.lang_client = "unknown")
	{
		Settings_unsupported()
		Return
	}

	Gui, %GUI%: Add, Checkbox, % "xs Section gSettings_mapinfo2 y+"vars.settings.spacing " HWNDhwnd Checked"settings.features.mapinfo, % Lang_Trans("m_mapinfo_enable")
	vars.hwnd.settings.enable := vars.hwnd.help_tooltips["settings_mapinfo enable"] := hwnd

	If !settings.features.mapinfo
		Return

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "xs Section Center y+"vars.settings.spacing, % Lang_Trans("global_general")
	Gui, %GUI%: Font, norm

	Gui, %GUI%: Add, Text, % "xs Section", % Lang_Trans("global_activation")
	Gui, %Gui%: Add, Radio, % "ys HWNDhwnd1 gSettings_mapinfo2 Checked" settings.mapinfo.omnikey, % "omni-key"
	Gui, %Gui%: Add, Radio, % "ys HWNDhwnd2 gSettings_mapinfo2 Checked" !settings.mapinfo.omnikey, % "alt"
	vars.hwnd.settings.omni_key := vars.hwnd.help_tooltips["settings_mapinfo omni-key"] := hwnd1
	vars.hwnd.settings.alt_key := vars.hwnd.help_tooltips["settings_mapinfo alt-key"] := hwnd2

	Gui, %GUI%: Add, Checkbox, % "xs Section gSettings_mapinfo2 HWNDhwnd Checked"settings.mapinfo.trigger, % Lang_Trans("m_mapinfo_shift")
	vars.hwnd.settings.shiftclick := vars.hwnd.help_tooltips["settings_mapinfo shift-click"] := hwnd
	ControlGetPos, x, y, w, h,, ahk_id %hwnd%
	Gui, %GUI%: Add, Checkbox, % "xs Section gSettings_mapinfo2 HWNDhwnd Checked"settings.mapinfo.tabtoggle, % Lang_Trans("m_mapinfo_tab")
	vars.hwnd.settings.tabtoggle := vars.hwnd.help_tooltips["settings_mapinfo tab"] := hwnd

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "xs Section y+"vars.settings.spacing, % Lang_Trans("global_ui")
	Gui, %GUI%: Font, norm
	Gui, %GUI%: Add, Text, % "xs Section HWNDhwnd0", % Lang_Trans("global_font")
	Gui, %GUI%: Add, Text, % "ys x+" settings.general.fWidth/2 " Center Border gSettings_mapinfo2 HWNDhwnd w"settings.general.fWidth*2, % "–"
	vars.hwnd.help_tooltips["settings_font-size"] := hwnd0, vars.hwnd.settings.font_minus := vars.hwnd.help_tooltips["settings_font-size|"] := hwnd
	Gui, %GUI%: Add, Text, % "ys x+"settings.general.fWidth/4 " Center Border gSettings_mapinfo2 HWNDhwnd w"settings.general.fWidth*3, % settings.mapinfo.fSize
	vars.hwnd.settings.font_reset := vars.hwnd.help_tooltips["settings_font-size||"] := hwnd
	Gui, %GUI%: Add, Text, % "ys x+"settings.general.fWidth/4 " Center Border gSettings_mapinfo2 HWNDhwnd w"settings.general.fWidth*2, % "+"
	vars.hwnd.settings.font_plus := vars.hwnd.help_tooltips["settings_font-size|||"] := hwnd
	Gui, %GUI%: Add, Text, % "ys", % Lang_Trans("m_mapinfo_textcolors")
	handle := ""
	Loop 4
	{
		Gui, %GUI%: Add, Text, % "ys x+"settings.general.fWidth/4 " Center Border gSettings_mapinfo2 HWNDhwnd c"settings.mapinfo.color[A_Index], % " " A_Index " "
		vars.hwnd.settings["color_"A_Index] := vars.hwnd.help_tooltips["settings_mapinfo colors"handle] := hwnd, handle .= "|"
	}
	ControlGetPos, xGui,, wGui,,, ahk_id %hwnd%

	If !vars.poe_version
	{
		Gui, %GUI%: Add, Text, % "xs Section", % Lang_Trans("m_mapinfo_logbook")
		Loop 4
		{
			Gui, %GUI%: Add, Text, % "ys x+" settings.general.fWidth/(A_Index = 1 ? 2 : 4) " Center Border gSettings_mapinfo2 HWNDhwnd c"settings.mapinfo.eColor[A_Index], % " " A_Index " "
			vars.hwnd.settings["colorlogbook_"A_Index] := vars.hwnd.help_tooltips["settings_mapinfo logbooks"handle1] := hwnd, handle1 .= "|"
		}

		Gui, %GUI%: Add, Checkbox, % "xs Section gSettings_mapinfo2 HWNDhwnd Checked" settings.mapinfo.roll_highlight, % Lang_Trans("m_mapinfo_roll_highlight")
		vars.hwnd.settings.roll_highlight := vars.hwnd.help_tooltips["settings_mapinfo roll highlight"] := hwnd, handle := ""
		ControlGetPos, xControl,,,,, ahk_id %hwnd%
		If settings.mapinfo.roll_highlight
		{
			Gui, %GUI%: Add, Text, % "ys Center BackgroundTrans HWNDhwnd1 Border c" settings.mapinfo.roll_colors.1 " x+" settings.general.fWidth / 4, % " 117" Lang_Trans("maps_stats", 2) " "
			Gui, %GUI%: Add, Progress, % "xp yp wp hp HWNDhwnd11 Border BackgroundBlack c" settings.mapinfo.roll_colors.2, 100
			Gui, %GUI%: Add, Text, % "ys x+-1 BackgroundTrans gSettings_mapinfo2 HWNDhwnd2 Border w" settings.general.fWidth, % " "
			Gui, %GUI%: Add, Progress, % "xp yp wp hp HWNDhwnd21 Border BackgroundBlack c" settings.mapinfo.roll_colors.1, % 100
			Gui, %GUI%: Add, Text, % "ys x+-1 BackgroundTrans gSettings_mapinfo2 HWNDhwnd3 Border w" settings.general.fWidth, % " "
			Gui, %GUI%: Add, Progress, % "xp yp wp hp HWNDhwnd31 Border BackgroundBlack c" settings.mapinfo.roll_colors.2, % 100
			Loop 3
				vars.hwnd.help_tooltips["settings_mapinfo roll colors" handle] := hwnd%A_Index%1, handle .= "|"
			vars.hwnd.settings.rollcolor_text := hwnd1, vars.hwnd.settings.rollcolor_back := hwnd11
			vars.hwnd.settings.rollcolor_1 := hwnd2, vars.hwnd.settings.rollcolor_11 := hwnd21
			vars.hwnd.settings.rollcolor_2 := hwnd3, vars.hwnd.settings.rollcolor_21 := hwnd31, dimensions := [], handle := ""
			Loop 6
			{
				Gui, %GUI%: Add, Text, % (A_Index = 1 ? "xs Section" : "ys x+" settings.general.fWidth//2) " Center HWNDhwnd Border w" settings.general.fWidth * 2, % Lang_Trans("maps_stats", A_Index + 1)
				Gui, %GUI%: Font, % "s" settings.general.fSize - 4
				Gui, %GUI%: Add, Edit, % "ys x+-1 hp Right cBlack Number HWNDhwnd1 Limit3 gSettings_mapinfo2 w" settings.general.fWidth * 3, % settings.mapinfo.roll_requirements[Lang_Trans("maps_stats_full", A_Index + 1)]
				Gui, %GUI%: Font, % "s" settings.general.fSize
				vars.hwnd.help_tooltips["settings_mapinfo requirements" handle] := hwnd, vars.hwnd.help_tooltips["settings_mapinfo requirements|" handle] := vars.hwnd.settings["thresh_" Lang_Trans("maps_stats_full", A_Index + 1)] := hwnd1, handle .= "||"
			}
		}
	}

	Gui, %GUI%: Font, % "bold underline"
	Gui, %GUI%: Add, Text, % "xs Section x" x_anchor " y+" vars.settings.spacing, % Lang_Trans("m_mapinfo_modsettings")
	Gui, %GUI%: Font, % "norm"
	Gui, %GUI%: Add, Pic, % "ys hp w-1 HWNDhwnd", % "HBitmap:*" vars.pics.global.help
	vars.hwnd.help_tooltips["settings_mapinfo mod settings"] := hwnd

	Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans gSettings_mapinfo2 HWNDhwnd", % " " Lang_Trans("m_mapinfo_reset") " "
	Gui, %GUI%: Add, Progress, % "Disabled Range0-500 Vertical xp yp wp hp BackgroundBlack cRed HWNDhwnd2", 0
	vars.hwnd.settings.reset_tiers := hwnd, vars.hwnd.settings.reset_tiers_bar := vars.hwnd.help_tooltips["settings_mapinfo reset tiers"] := hwnd2

	If !IsObject(db.mapinfo)
		DB_Load("mapinfo")

	For ID, val in settings.mapinfo.pinned
	{
		If (A_Index = 1)
			Gui, %GUI%: Add, Text, % "xs Section", % Lang_Trans("m_mapinfo_pinned")
		If !(check := LLK_HasVal(db.mapinfo.mods, ID,,,, 1)) || !val
			Continue
		ID := (ID < 100 ? "0" : "") . (ID < 10 ? "0" : "") . ID, ini := IniBatchRead("ini" vars.poe_version "\map info.ini", ID)
		text := db.mapinfo.mods[check].text, text := InStr(text, ":") ? SubStr(text, 1, InStr(text, ":") - 1) : text, color := settings.mapinfo.color[!Blank(check := ini[ID].rank) ? check : 0]
		style := (xLast + wLast + StrLen(text) * settings.general.fWidth >= xGui + wGui) ? "xs Section" : "ys", show := !Blank(check := ini[ID].show) ? check : 1
		If !show
			Gui, %GUI%: Font, strike
		Gui, %GUI%: Add, Text, % style " Border Center HWNDhwnd c" color, % " " text " "
		Gui, %GUI%: Font, norm
		ControlGetPos, xLast,, wLast,,, ahk_id %hwnd%
		Gui, %GUI%: Add, Text, % "ys x+-1 Border Center HWNDhwnd1 gSettings_mapinfo2 cRed w" settings.general.fWidth * 2, % "–"
		vars.hwnd.settings["mapmod_" ID] := hwnd, vars.hwnd.settings["unpin_" ID] := hwnd1
	}
	Gui, %GUI%: Add, Text, % "xs Section HWNDhwnd", % Lang_Trans("m_mapinfo_modsearch")
	Gui, %GUI%: Add, Button, % "xp yp wp hp Hidden Default HWNDhwnd1 gSettings_mapinfo2", OK
	ControlGetPos, x1, y1, w1, h1,, ahk_id %hwnd%
	Gui, %GUI%: Font, % "norm s" settings.general.fSize - 4
	Gui, %GUI%: Add, Edit, % "ys cBlack HWNDhwnd2 gSettings_mapinfo2 w" w - w1 - settings.general.fWidth, % vars.settings.mapinfo_search
	vars.hwnd.settings.modsearch := vars.hwnd.help_tooltips["settings_mapinfo modsearch"] := hwnd2, vars.hwnd.settings.modsearch_ok := hwnd1
	Gui, %GUI%: Font, % "s" settings.general.fSize

	If (search := vars.settings.mapinfo_search)
	{
		For outer in ["", ""]
		{
			If (outer = 2) && (added.Count() > 10)
			{
				Gui, %GUI%: Add, Text, % "xs Section cRed", % Lang_Trans("global_match", 2)
				Return
			}
			added := {}
			For mod, object in db.mapinfo.mods
			{
				If !InStr(mod, search) || added[object.ID] || settings.mapinfo.pinned[object.ID]
					Continue
				style := !added.Count() || (xLast + wLast + StrLen(text) * settings.general.fWidth >= xGui + wGui) ? "xs Section" : "ys", added[object.ID] := 1
				If (outer = 1)
					Continue
				ini := IniBatchRead("ini" vars.poe_version "\map info.ini", object.ID), color := settings.mapinfo.color[!Blank(check := ini[object.ID].rank) ? check : 0]
				show := !Blank(check := ini[object.ID].show) ? check : 1, text := InStr(object.text, ":") ? SubStr(object.text, 1, InStr(object.text, ":") - 1) : object.text
				If !show
					Gui, %GUI%: Font, strike
				Gui, %GUI%: Add, Text, % style " Border Center HWNDhwnd c" color, % " " text " "
				Gui, %GUI%: Font, norm
				ControlGetPos, xLast,, wLast,,, ahk_id %hwnd%
				Gui, %GUI%: Add, Text, % "ys x+-1 Border Center HWNDhwnd1 gSettings_mapinfo2 cLime w" settings.general.fWidth * 2, % "+"
				vars.hwnd.settings["mapmod_" object.ID] := hwnd, vars.hwnd.settings["pin_" object.ID] := hwnd1
			}
		}
	}
}

Settings_mapinfo2(cHWND)
{
	local
	global vars, settings

	check := LLK_HasVal(vars.hwnd.settings, cHWND), control := SubStr(check, InStr(check, "_") + 1)
	Switch check
	{
		Case "enable":
			settings.features.mapinfo := LLK_ControlGet(cHWND)
			IniWrite, % settings.features.mapinfo, % "ini" vars.poe_version "\config.ini", features, enable map-info panel
			Settings_menu("map-info")
			LLK_Overlay(vars.hwnd.mapinfo.main, "destroy")
		Case "omni_key":
			IniWrite, % (settings.mapinfo.omnikey := LLK_ControlGet(vars.hwnd.settings.omni_key)), % "ini" vars.poe_version "\map info.ini", settings, omni-key activation
		Case "alt_key":
			IniWrite, % (settings.mapinfo.omnikey := LLK_ControlGet(vars.hwnd.settings.omni_key)), % "ini" vars.poe_version "\map info.ini", settings, omni-key activation
		Case "shiftclick":
			settings.mapinfo.trigger := LLK_ControlGet(cHWND), Settings_ScreenChecksValid()
			IniWrite, % settings.mapinfo.trigger, % "ini" vars.poe_version "\map info.ini", settings, enable shift-clicking
		Case "tabtoggle":
			settings.mapinfo.tabtoggle := LLK_ControlGet(cHWND)
			IniWrite, % settings.mapinfo.tabtoggle, % "ini" vars.poe_version "\map info.ini", settings, show panel while holding tab
		Case "modsearch":
			GuiControl, +cBlack, % cHWND
		Case "modsearch_ok":
			vars.settings.mapinfo_search := LLK_ControlGet(cHWND := vars.hwnd.settings.modsearch), Settings_menu("map-info",, 0)
			Return
		Case "reset_tiers":
			If LLK_Progress(vars.hwnd.settings.reset_tiers_bar, "LButton")
			{
				For key, val in IniBatchRead("ini" vars.poe_version "\map info.ini")
					If !IsNumber(key)
						Continue
					Else
					{
						key := (key < 100 ? "0" : "") . (key < 10 ? "0" : "") . key
						IniDelete, % "ini" vars.poe_version "\map info.ini", % key
					}
				Init_mapinfo(), Settings_menu("map-info")
			}
			Else Return
		Case "roll_highlight":
			IniWrite, % (settings.mapinfo.roll_highlight := LLK_ControlGet(cHWND)), % "ini" vars.poe_version "\map info.ini", settings, highlight map rolls
			Settings_menu("map-info")
		Default:
			If InStr(check, "font_")
			{
				While GetKeyState("LButton", "P")
				{
					If (control = "reset")
						settings.mapinfo.fSize := settings.general.fSize
					Else settings.mapinfo.fSize += (control = "minus") ? -1 : 1, settings.mapinfo.fSize := (settings.mapinfo.fSize < 6) ? 6 : settings.mapinfo.fSize
					GuiControl, text, % vars.hwnd.settings.font_reset, % settings.mapinfo.fSize
					Sleep 150
				}
				IniWrite, % settings.mapinfo.fSize, % "ini" vars.poe_version "\map info.ini", settings, font-size
				LLK_FontDimensions(settings.mapinfo.fSize, height, width), settings.mapinfo.fWidth := width, settings.mapinfo.fHeight := height
			}
			Else If InStr(check, "thresh_")
			{
				IniWrite, % (settings.mapinfo.roll_requirements[control] := LLK_ControlGet(cHWND)), % "ini" vars.poe_version "\map info.ini", UI, % control " requirement"
				Return
			}
			Else If InStr(check, "rollcolor")
			{
				KeyWait, LButton
				KeyWait, RButton
				color := (vars.system.click = 1) ? RGB_Picker(settings.mapinfo.roll_colors[control]) : (control = 1 ? "00FF00" : "000000")
				If Blank(color)
					Return
				GuiControl, % "+c" color, % vars.hwnd.settings["rollcolor_" control "1"]
				GuiControl, % "+c" color, % vars.hwnd.settings["rollcolor_" (control = 1 ? "text" : "back")]
				GuiControl, % "movedraw", % vars.hwnd.settings["rollcolor_" (control = 1 ? "text" : "back")]
				IniWrite, % (settings.mapinfo.roll_colors[control] := color), % "ini"vars.poe_version "\map info.ini", UI, % "map rolls " (control = 1 ? "text" : "back") " color"
			}
			Else If InStr(check, "color")
			{
				key := InStr(check, "color_") ? "color" : "eColor"
				If (vars.system.click = 1)
					picked_rgb := RGB_Picker(settings.mapinfo[key][control])
				If (vars.system.click = 1) && Blank(picked_rgb)
					Return
				Else settings.mapinfo[key][control] := (vars.system.click = 1) ? picked_rgb : settings.mapinfo[InStr(check, "color_") ? "dColor" : "eColor_default"][control]

				IniWrite, % settings.mapinfo[key][control], % "ini" vars.poe_version "\map info.ini", UI, % InStr(check, "color_") ? (control = 5 ? "header" : "difficulty " control) " color" : "logbook " control " color"
				GuiControl, % "+c" settings.mapinfo[key][control], % cHWND
				GuiControl, movedraw, % cHWND
			}
			Else If InStr(check, "pin_")
			{
				KeyWait, LButton
				If InStr(check, "unpin_")
				{
					settings.mapinfo.pinned.Delete(control)
					IniDelete, % "ini" vars.poe_version "\map info.ini", pinned, % control
				}
				Else IniWrite, % (settings.mapinfo.pinned[control] := 1), % "ini" vars.poe_version "\map info.ini", pinned, % control
				Settings_menu("map-info",, 0)
				Return
			}
			Else LLK_ToolTip("no action")
			If WinExist("ahk_id "vars.hwnd.mapinfo.main)
				Mapinfo_Parse(0, vars.poe_version), Mapinfo_GUI(GetKeyState(vars.hotkeys.tab, "P") ? 2 : 0)
	}
}

Settings_maptracker()
{
	local
	global vars, settings

	GUI := "settings_menu" vars.settings.GUI_toggle, x_anchor := vars.settings.x_anchor
	Gui, %GUI%: Add, Link, % "Section x" x_anchor " y" vars.settings.ySelection, <a href="https://github.com/Lailloken/Lailloken-UI/wiki/Map‐Tracker">wiki page</a>

	If (settings.general.lang_client = "unknown")
	{
		Settings_unsupported()
		Return
	}

	Gui, %GUI%: Add, Checkbox, % "xs Section gSettings_maptracker2 y+"vars.settings.spacing " HWNDhwnd Checked"settings.features.maptracker, % Lang_Trans("m_maptracker_enable")
	vars.hwnd.settings.enable := vars.hwnd.help_tooltips["settings_maptracker enable"] := hwnd

	If !settings.features.maptracker
		Return

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "xs Section Center y+"vars.settings.spacing, % Lang_Trans("global_general")
	Gui, %GUI%: Font, norm
	Gui, %GUI%: Add, Checkbox, % "xs Section gSettings_maptracker2 HWNDhwnd Checked"settings.maptracker.hide, % Lang_Trans("m_maptracker_hide")
	vars.hwnd.settings.hide := vars.hwnd.help_tooltips["settings_maptracker hide"] := hwnd
	If !vars.poe_version
	{
		Gui, %GUI%: Add, Checkbox, % "xs Section gSettings_maptracker2 HWNDhwnd Checked"settings.maptracker.loot, % Lang_Trans("m_maptracker_loot")
		vars.hwnd.settings.loot := hwnd, vars.hwnd.help_tooltips["settings_maptracker loot-tracker"] := hwnd
	}
	Gui, %GUI%: Add, Checkbox, % (!vars.poe_version ? "ys" : "xs Section") " gSettings_maptracker2 HWNDhwnd Checked"settings.maptracker.kills, % Lang_Trans("m_maptracker_kills")
	vars.hwnd.settings.kills := vars.hwnd.help_tooltips["settings_maptracker kill-tracker"] := hwnd
	Gui, %GUI%: Add, Checkbox, % "ys gSettings_maptracker2 HWNDhwnd Checked"settings.maptracker.mapinfo (!settings.features.mapinfo ? " cGray" : ""), % Lang_Trans("m_maptracker_mapinfo")
	vars.hwnd.settings.mapinfo := hwnd, vars.hwnd.help_tooltips["settings_maptracker mapinfo"] := hwnd
	Gui, %GUI%: Add, Checkbox, % "ys gSettings_maptracker2 HWNDhwnd Checked"settings.maptracker.notes, % Lang_Trans("m_maptracker_notes")
	vars.hwnd.settings.notes := vars.hwnd.help_tooltips["settings_maptracker notes"] := hwnd
	If !vars.poe_version
	{
		Gui, %GUI%: Add, Checkbox, % "xs Section gSettings_maptracker2 HWNDhwnd Checked"settings.maptracker.sidecontent, % Lang_Trans("m_maptracker_sidearea")
		vars.hwnd.settings.sidecontent := vars.hwnd.help_tooltips["settings_maptracker side-content"] := hwnd, style := "ys"
	}
	Else style := "xs"

	Gui, %GUI%: Add, Checkbox, % style " gSettings_maptracker2 HWNDhwnd Checked"settings.maptracker.rename, % Lang_Trans("m_maptracker_rename")
	vars.hwnd.settings.rename := vars.hwnd.help_tooltips["settings_maptracker rename" vars.poe_version] := hwnd
	Gui, %GUI%: Add, Checkbox, % "xs Section gSettings_maptracker2 HWNDhwnd Checked"settings.maptracker.character, % Lang_Trans("m_maptracker_character")
	vars.hwnd.settings.character := vars.hwnd.help_tooltips["settings_maptracker character"] := hwnd
	Gui, %GUI%: Add, Checkbox, % "xs Section gSettings_maptracker2 HWNDhwnd Checked"settings.maptracker.mechanics, % Lang_Trans("m_maptracker_content")
	vars.hwnd.settings.mechanics := vars.hwnd.help_tooltips["settings_maptracker mechanics"] := hwnd

	If settings.maptracker.mechanics
	{
		added := 0
		For mechanic, type in vars.maptracker.mechanics
		{
			If type
				Continue
			added += 1, color := settings.maptracker[mechanic] ? " cLime" : " c505050"
			Gui, %GUI%: Add, Text, % (added = 1 || !Mod(added - 1, 4) ? "xs Section x" x_anchor + settings.general.fWidth * 2 : "ys x+"settings.general.fWidth/4) " Border Center gSettings_maptracker2 HWNDhwnd" color, % " " Lang_Trans("mechanic_" mechanic) " "
			vars.hwnd.settings["mechanic_"mechanic] := vars.hwnd.help_tooltips["settings_maptracker dialoguemechanic"handle] := hwnd, handle .= "|"
		}

		Gui, %GUI%: Add, Text, % "xs Section Center x" x_anchor + settings.general.fWidth * 2, % Lang_Trans("m_maptracker_dialogue")
		Gui, %GUI%: Add, Pic, % "ys hp w-1 BackgroundTrans HWNDhwnd", % "HBitmap:*" vars.pics.global.help
		vars.hwnd.help_tooltips["settings_maptracker dialogue tracking"] := hwnd, added := 0, ingame_dialogs := vars.maptracker.dialog := InStr(LLK_FileRead(vars.system.config), "output_all_dialogue_to_chat=true") ? 1 : 0
		For mechanic, type in vars.maptracker.mechanics
		{
			If (type != 1)
				Continue
			added += 1, color := !ingame_dialogs ? " cRed" : settings.maptracker[mechanic] ? " cLime" : " c505050"
			Gui, %GUI%: Add, Text, % (added = 1 || !Mod(added - 1, 4) ? "xs Section" : "ys x+"settings.general.fWidth/4) " Border Center gSettings_maptracker2 HWNDhwnd" color, % " " Lang_Trans("mechanic_" mechanic) " "
			vars.hwnd.settings["mechanic_"mechanic] := vars.hwnd.help_tooltips["settings_maptracker dialoguemechanic"handle] := hwnd, handle .= "|"
		}

		Gui, %GUI%: Add, Text, % "xs Section Center", % Lang_Trans("m_maptracker_screen")
		Gui, %GUI%: Add, Pic, % "ys hp w-1 BackgroundTrans HWNDhwnd", % "HBitmap:*" vars.pics.global.help
		vars.hwnd.help_tooltips["settings_maptracker screen tracking"] := hwnd, handle := "", added := 0
		For mechanic, type in vars.maptracker.mechanics
		{
			If (type != 2)
				Continue
			added += 1, color := !FileExist("img\Recognition ("vars.client.h "p)\Mapping Tracker\"mechanic . vars.poe_version ".bmp") ? "red" : settings.maptracker[mechanic] ? " cLime" : " c505050"
			Gui, %GUI%: Add, Text, % (added = 1 || !Mod(added - 1, 4) ? "xs Section" : "ys x+"settings.general.fWidth/4) " Border Center gSettings_maptracker2 HWNDhwnd c" color, % " " Lang_Trans("mechanic_" mechanic) " "
			vars.hwnd.settings["screenmechanic_"mechanic] := vars.hwnd.help_tooltips["settings_maptracker screenmechanic"handle] := hwnd, handle .= "|"
		}

		Gui, %GUI%: Add, Checkbox, % "xs Section gSettings_maptracker2 HWNDhwnd Checked"settings.maptracker.portal_reminder, % Lang_Trans("m_maptracker_portal")
		ControlGetPos,,, wControl,,, ahk_id %hwnd%
		vars.hwnd.settings.portal_reminder := vars.hwnd.help_tooltips["settings_maptracker portal reminder"] := hwnd, handle := ""
		If settings.maptracker.portal_reminder
		{
			Gui, %GUI%: Add, Text, % "xs Section HWNDhwnd0", % Lang_Trans("m_maptracker_portal", 2)
			ControlGetPos,,, wControl2,,, ahk_id %hwnd0%
			Gui, %GUI%: Font, % "s" settings.general.fSize - 4
			Gui, %GUI%: Add, Edit, % "ys cBlack gSettings_maptracker2 HWNDhwnd w" wControl - wControl2 - settings.general.fWidth, % settings.maptracker.portal_hotkey
			Gui, %GUI%: Font, % "s" settings.general.fSize
			vars.hwnd.settings.portal_hotkey := vars.hwnd.help_tooltips["settings_maptracker portal hotkey"] := hwnd
		}
	}

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "xs Section Center y+"vars.settings.spacing " x" x_anchor, % Lang_Trans("global_ui")
	Gui, %GUI%: Font, norm
	Gui, %GUI%: Add, Text, % "xs Section Center HWNDhwnd0", % Lang_Trans("global_panelsize") " "
	Gui, %GUI%: Add, Text, % "ys x+0 Center gSettings_maptracker2 Border HWNDhwnd w"settings.general.fWidth*2, % "–"
	vars.hwnd.help_tooltips["settings_font-size"] := hwnd0, vars.hwnd.settings.font_minus := vars.hwnd.help_tooltips["settings_font-size|"] := hwnd
	Gui, %GUI%: Add, Text, % "ys Center gSettings_maptracker2 Border HWNDhwnd x+"settings.general.fWidth/4, % " " settings.maptracker.fSize " "
	vars.hwnd.settings.font_reset := vars.hwnd.help_tooltips["settings_font-size||"] := hwnd
	Gui, %GUI%: Add, Text, % "ys Center gSettings_maptracker2 Border HWNDhwnd x+"settings.general.fWidth/4 " w"settings.general.fWidth * 2, % "+"
	vars.hwnd.settings.font_plus := vars.hwnd.help_tooltips["settings_font-size|||"] := hwnd

	Gui, %GUI%: Add, Text, % "xs Section", % Lang_Trans("global_color", 2) " "
	Loop 2
	{
		Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans HWNDhwnd0 gSettings_maptracker2 x+" settings.general.fWidth * (A_Index = 1 ? 0 : 0.25) " w" settings.general.fHeight, % ""
		Gui, %GUI%: Add, Progress, % "xp yp wp hp Border Disabled HWNDhwnd BackgroundBlack c" settings.maptracker.colors["date_" (A_Index = 1 ? "un" : "") "selected"], % 100
		vars.hwnd.settings["color_date_" (A_Index = 1 ? "un" : "") "selected"] := hwnd0, vars.hwnd.settings["color_date_" (A_Index = 1 ? "un" : "") "selected_bar"] := vars.hwnd.help_tooltips["settings_maptracker color " (A_Index = 1 ? "un" : "") "selected"] := hwnd, handle := ""
	}

	For index, league in vars.maptracker.leagues
	{
		Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans HWNDhwnd0 gSettings_maptracker2 x+" settings.general.fWidth / 4 " w" settings.general.fHeight, % ""
		Gui, %GUI%: Add, Progress, % "xp yp wp hp Border Disabled HWNDhwnd BackgroundBlack c" settings.maptracker.colors["league " index], % 100
		vars.hwnd.settings["color_league " index] := hwnd0, vars.hwnd.settings["color_league " index "_bar"] := vars.hwnd.help_tooltips["settings_maptracker color leagues" handle] := hwnd, handle .= "|"
	}
}

Settings_maptracker2(cHWND)
{
	local
	global vars, settings

	check := LLK_HasVal(vars.hwnd.settings, cHWND), control := SubStr(check, InStr(check, "_") + 1)
	Switch check
	{
		Case "enable":
			settings.features.maptracker := LLK_ControlGet(cHWND)
			IniWrite, % settings.features.maptracker, % "ini" vars.poe_version "\config.ini", features, enable map tracker
			If !settings.features.maptracker
				vars.maptracker.Delete("map"), LLK_Overlay(vars.hwnd.maptracker.main, "destroy")
			Init_GUI(), Settings_menu("mapping tracker")
		Case "hide":
			settings.maptracker.hide := LLK_ControlGet(cHWND)
			IniWrite, % settings.maptracker.hide, % "ini" vars.poe_version "\map tracker.ini", settings, hide panel when paused
			If LLK_Overlay(vars.hwnd.maptracker.main, "check")
				Maptracker_GUI()
		Case "loot":
			settings.maptracker.loot := LLK_ControlGet(cHWND), Settings_ScreenChecksValid()
			IniWrite, % settings.maptracker.loot, % "ini" vars.poe_version "\map tracker.ini", settings, enable loot tracker
		Case "kills":
			settings.maptracker.kills := LLK_ControlGet(cHWND), vars.maptracker.refresh_kills := ""
			IniWrite, % settings.maptracker.kills, % "ini" vars.poe_version "\map tracker.ini", settings, enable kill tracker
		Case "mapinfo":
			If !settings.features.mapinfo
			{
				GuiControl,, % cHWND, 0
				Return
			}
			settings.maptracker.mapinfo := LLK_ControlGet(cHWND)
			IniWrite, % settings.maptracker.mapinfo, % "ini" vars.poe_version "\map tracker.ini", settings, log mods from map-info panel
		Case "notes":
			settings.maptracker.notes := LLK_ControlGet(cHWND)
			IniWrite, % settings.maptracker.notes, % "ini" vars.poe_version "\map tracker.ini", settings, enable notes
			Maptracker_GUI()
		Case "sidecontent":
			settings.maptracker.sidecontent := LLK_ControlGet(cHWND)
			IniWrite, % settings.maptracker.sidecontent, % "ini" vars.poe_version "\map tracker.ini", settings, track side-areas
		Case "rename":
			settings.maptracker.rename := LLK_ControlGet(cHWND)
			IniWrite, % settings.maptracker.rename, % "ini" vars.poe_version "\map tracker.ini", settings, rename boss maps
		Case "character":
			settings.maptracker.character := LLK_ControlGet(cHWND)
			IniWrite, % settings.maptracker.character, % "ini" vars.poe_version "\map tracker.ini", settings, log character info
			Maptracker_GUI()
		Case "mechanics":
			settings.maptracker.mechanics := LLK_ControlGet(cHWND)
			IniWrite, % settings.maptracker.mechanics, % "ini" vars.poe_version "\map tracker.ini", settings, track league mechanics
			Settings_menu("mapping tracker")
		Case "portal_reminder":
			settings.maptracker.portal_reminder := LLK_ControlGet(cHWND)
			IniWrite, % settings.maptracker.portal_reminder, % "ini" vars.poe_version "\map tracker.ini", settings, portal-scroll reminder
			Settings_menu("mapping tracker")
		Case "portal_hotkey":
			input := LLK_ControlGet(cHWND)
			If (StrLen(input) != 1)
				Loop, Parse, % "#!^+"
					input := StrReplace(input, A_LoopField)
			If !Blank(input) && GetKeyVK(input)
			{
				settings.maptracker.portal_hotkey := LLK_ControlGet(cHWND)
				IniWrite, % settings.maptracker.portal_hotkey, % "ini" vars.poe_version "\map tracker.ini", settings, portal-scroll hotkey
				GuiControl, +cBlack, % cHWND
				Init_maptracker()
			}
			Else GuiControl, +cRed, % cHWND
		Default:
			If InStr(check, "font_")
			{
				While GetKeyState("LButton", "P")
				{
					If (control = "minus")
						settings.maptracker.fSize -= (settings.maptracker.fSize > 6) ? 1 : 0
					Else If (control = "reset")
						settings.maptracker.fSize := settings.general.fSize
					Else If (control = "plus")
						settings.maptracker.fSize += 1
					GuiControl, text, % vars.hwnd.settings.font_reset, % settings.maptracker.fSize
					Sleep 150
				}
				LLK_FontDimensions(settings.maptracker.fSize, height, width), settings.maptracker.fWidth := width, settings.maptracker.fHeight := height
				IniWrite, % settings.maptracker.fSize, % "ini" vars.poe_version "\map tracker.ini", settings, font-size
				If WinExist("ahk_id "vars.hwnd.maptracker.main)
					Maptracker_GUI()
				If WinExist("ahk_id "vars.hwnd.maptracker_logs.main)
					Maptracker_Logs()
			}
			Else If InStr(check, "mechanic_")
			{
				If InStr(check, "screen") && (vars.system.click = 2)
				{
					pClipboard := Screenchecks_ImageRecalibrate()
					If (pClipboard <= 0)
						Return
					Gdip_SaveBitmapToFile(pClipboard, "img\Recognition ("vars.client.h "p)\Mapping Tracker\"control . vars.poe_version ".bmp", 100), Gdip_DisposeImage(pClipboard)
					GuiControl, % "+c"(settings.maptracker[control] ? "Lime" : "505050"), % vars.hwnd.settings["screenmechanic_"control]
					GuiControl, movedraw, % vars.hwnd.settings["screenmechanic_"control]
					Return
				}
				If InStr(check, "screen") && !FileExist("img\Recognition ("vars.client.h "p)\Mapping Tracker\"control . vars.poe_version ".bmp")
					Return
				If !InStr(check, "screen") && !vars.maptracker.dialog
				{
					LLK_ToolTip(Lang_Trans("maptracker_dialogue"), 3,,,, "red")
					Return
				}
				settings.maptracker[control] := !settings.maptracker[control] ? 1 : 0
				IniWrite, % settings.maptracker[control], % "ini" vars.poe_version "\map tracker.ini", mechanics, % control
				GuiControl, % "+c"(settings.maptracker[control] ? "Lime" : "505050"), % cHWND
				GuiControl, movedraw, % cHWND
			}
			Else If InStr(check, "color_")
			{
				If (vars.system.click = 1)
				{
					picked_rgb := RGB_Picker(settings.maptracker.colors[control])
					If Blank(picked_rgb)
						Return
				}
				settings.maptracker.colors[control] := (vars.system.click = 1) ? picked_rgb : settings.maptracker.dColors[control]
				IniWrite, % settings.maptracker.colors[control], % "ini" vars.poe_version "\map tracker.ini", UI, % control " color"
				GuiControl, % "+c" settings.maptracker.colors[control], % vars.hwnd.settings[check "_bar"]
				If InStr(check, "selected") && WinExist("ahk_id " vars.hwnd.maptracker_logs.main)
					Maptracker_Logs()
			}
			Else LLK_ToolTip("no action")
			If WinExist("ahk_id " vars.hwnd.maptracker_logs.main)
				LLK_Overlay(vars.hwnd.settings.main, "show", 0)
	}
}

Settings_menu(section, mode := 0, NA := 1) ;mode parameter is used when manually calling this function to refresh the window
{
	local
	global vars, settings
	static toggle := 0

	If !IsObject(vars.settings)
	{
		If !vars.poe_version
			vars.settings := {"sections": ["general", "hotkeys", "screen-checks", "updater", "donations", "actdecoder", "leveling tracker", "betrayal-info", "cheat-sheets", "clone-frames", "anoints", "item-info", "map-info", "mapping tracker", "minor qol tools", "sanctum", "search-strings", "stash-ninja", "tldr-tooltips"], "sections2": []}
		Else vars.settings := {"sections": ["general", "hotkeys", "screen-checks", "updater", "donations", "actdecoder", "leveling tracker", "cheat-sheets", "clone-frames", "anoints", "item-info", "map-info", "mapping tracker", "minor qol tools", "search-strings", "sanctum", "statlas"], "sections2": []}
		For index, val in vars.settings.sections
			vars.settings.sections2.Push(Lang_Trans("ms_" val, (vars.poe_version && val = "sanctum") ? 2 : 1))
	}

	If !Blank(LLK_HasVal(vars.hwnd.settings, section))
		section := LLK_HasVal(vars.hwnd.settings, section) ? LLK_HasVal(vars.hwnd.settings, section) : section

	If (mode != 1) && (vars.settings.active = "hotkeys") && (section != "hotkeys")
		Init_hotkeys()

	vars.settings.xMargin := settings.general.fWidth*0.75, vars.settings.yMargin := settings.general.fHeight*0.15, vars.settings.line1 := settings.general.fHeight/4
	vars.settings.spacing := settings.general.fHeight*0.8, vars.settings.wait := 1, vars.settings.last_refresh := A_TickCount

	If !IsNumber(mode)
		mode := 0
	vars.settings.active := vars.settings.active_last := section ;which section of the settings menu is currently active (for purposes of reloading the correct section after restarting)

	If WinExist("ahk_id "vars.hwnd.settings.main)
	{
		WinGetPos, xPos, yPos,,, % "ahk_id " vars.hwnd.settings.main
		vars.settings.x := xPos, vars.settings.y := yPos
	}

	vars.settings.GUI_toggle := toggle := !toggle, GUI_name := "settings_menu" toggle
	Gui, %GUI_name%: New, % "-DPIScale -Caption +LastFound +AlwaysOnTop +ToolWindow +Border +E0x02000000 +E0x00080000 HWNDsettings_menu", LLK-UI: Settings Menu (%section%)
	Gui, %GUI_name%: Color, Black
	Gui, %GUI_name%: Margin, % vars.settings.xMargin, % vars.settings.line1
	Gui, %GUI_name%: Font, % "s" settings.general.fSize - 2 " cWhite", % vars.system.font
	hwnd_old := vars.hwnd.settings.main ;backup of the old GUI's HWND with which to destroy it after drawing the new one
	vars.hwnd.settings := {"main": settings_menu, "GUI_name": GUI_name} ;settings-menu HWNDs are stored here

	Gui, %GUI_name%: Add, Text, % "Section x-1 y-1 Border Center BackgroundTrans gSettings_general2 HWNDhwnd", % "exile ui: " Lang_Trans("global_window")
	vars.hwnd.settings.winbar := hwnd
	ControlGetPos,,,, hWinbar,, ahk_id %hwnd%
	Gui, %GUI_name%: Add, Text, % "ys w"settings.general.fWidth*2 " Border Center gSettings_menuClose HWNDhwnd", % "x"
	vars.hwnd.settings.winx := hwnd

	LLK_PanelDimensions(vars.settings.sections2, settings.general.fSize, section_width, height)
	Gui, %GUI_name%: Font, % "s" settings.general.fSize
	Gui, %GUI_name%: Add, Text, % "xs x-1 y+-1 Section BackgroundTrans Border gSettings_menu HWNDhwnd 0x200 h"settings.general.fHeight*1.3 " w"section_width, % " " Lang_Trans("ms_general") " "
	Gui, %GUI_name%: Add, Progress, % "xp yp wp hp Border Disabled HWNDhwnd1 BackgroundBlack cBlack", 100
	ControlGetPos, x, y,,,, ahk_id %hwnd%
	vars.hwnd.settings.general := hwnd, vars.settings.xSelection := x, vars.settings.ySelection := y + vars.settings.line1, vars.settings.wSelection := section_width, vars.hwnd.settings["background_general"] := hwnd1
	vars.settings.x_anchor := vars.settings.xSelection + vars.settings.wSelection + vars.settings.xMargin
	feature_check := {"actdecoder": "actdecoder", "betrayal-info": "betrayal", "cheat-sheets": "cheatsheets", "leveling tracker": "leveltracker", "mapping tracker": "maptracker", "map-info": "mapinfo", "tldr-tooltips": "OCR", "sanctum": "sanctum", "stash-ninja": "stash", "filterspoon" : "lootfilter", "item-info": "iteminfo", "statlas": "statlas", "anoints": "anoints"}
	feature_check2 := {"item-info": 1, "mapping tracker": 1, "map-info": 1, "statlas": 1}

	If !vars.general.buggy_resolutions.HasKey(vars.client.h) && !vars.general.safe_mode
		For key, val in vars.settings.sections
		{
			If (val = "general") || (val = "screen-checks") && !IsNumber(vars.pixelsearch.gamescreen.x1) || !vars.log.file_location && InStr("mapping tracker, actdecoder", val)
			|| WinExist("ahk_exe GeForceNOW.exe") && InStr("item-info, map-info, filterspoon", val)
				Continue
			color := (val = "updater" && IsNumber(vars.update.1) && vars.update.1 < 0) ? " cRed" : (val = "updater" && IsNumber(vars.update.1) && vars.update.1 > 0) ? " cLime" : ""
			color := feature_check[val] && !settings.features[feature_check[val]] || (val = "clone-frames") && !vars.cloneframes.enabled || (val = "search-strings") && !vars.searchstrings.enabled || (val = "minor qol tools") && !(settings.qol.alarm + settings.qol.lab + settings.qol.notepad) ? " cGray" : color, color := feature_check2[val] && (settings.general.lang_client = "unknown") ? " cGray" : color
			color := (val = "donations") ? " cCCCC00" : color
			Gui, %GUI_name%: Add, Text, % "Section xs y+-1 wp BackgroundTrans Border gSettings_menu HWNDhwnd 0x200 h" settings.general.fHeight*1.2 . color, % " " Lang_Trans("ms_" val, (vars.poe_version && val = "sanctum") ? 2 : 1) " "
			Gui, %GUI_name%: Add, Progress, % "xp yp wp hp Border Disabled HWNDhwnd1 BackgroundBlack cBlack", 100
			vars.hwnd.settings[val] := hwnd, vars.hwnd.settings["background_"val] := hwnd1
			If (val = "donations")
				Gui, %GUI_name%: Add, Progress, % "Section xs y+0 wp Background646464 h" settings.general.fWidth//2, 0
		}
	ControlGetPos, x, yLast_section, w, hLast_section,, ahk_id %hwnd%
	Gui, %GUI_name%: Font, norm

	;if aspect-ratio is wider than officially supported by PoE, show message and force-open the general section
	If !vars.general.safe_mode && !settings.general.warning_ultrawide && (vars.client.h0/vars.client.w0 < (5/12))
	{
		MsgBox, 4, % Lang_Trans("m_general_resolution"), % Lang_Trans("global_ultrawide") "`n" Lang_Trans("global_ultrawide", 2) "`n" Lang_Trans("global_ultrawide", 3)
		IniWrite, 1, % "ini" vars.poe_version "\config.ini", Versions, ultrawide warning
		settings.general.warning_ultrawide := 1
		IfMsgBox, Yes
		{
			IniWrite, 1, % "ini" vars.poe_version "\config.ini", Settings, black-bar compensation
			KeyWait, LButton
			Reload
			ExitApp
		}
	}

	If vars.settings.restart
		section := vars.settings.restart

	;highlight selected section
	GuiControl, %GUI_name%: +c303030, % vars.hwnd.settings["background_"vars.settings.active]
	GuiControl, %GUI_name%: movedraw, % vars.hwnd.settings["background_"vars.settings.active]

	If vars.settings.active0 && (vars.settings.active0 != vars.settings.active) ;remove highlight from previously-selected section
	{
		GuiControl, %GUI_name%: +cBlack, % vars.hwnd.settings["background_"vars.settings.active0]
		GuiControl, %GUI_name%: movedraw, % vars.hwnd.settings["background_"vars.settings.active0]
	}

	vars.settings.active0 := section
	Settings_ScreenChecksValid() ;check if 'screen-checks' section needs to be highlighted red

	Settings_menu2(section, mode)
	Gui, %GUI_name%: Margin, % vars.settings.xMargin, -1
	Gui, %GUI_name%: Show, % "NA AutoSize x10000 y10000"
	ControlFocus,, % "ahk_id "vars.hwnd.settings.general
	WinGetPos,,, w, h, % "ahk_id "vars.hwnd.settings.main

	If (h > yLast_section + hLast_section)
	{
		Gui, %GUI_name%: Add, Text, % "x-1 Border BackgroundTrans y"vars.settings.ySelection - 1 - vars.settings.line1 " w"section_width " h"h - hWinbar + vars.settings.line1
		h := h + vars.settings.line1 - 1
	}

	GuiControl, Move, % vars.hwnd.settings.winbar, % "w"w - settings.general.fWidth*2 + 2
	GuiControl, Move, % vars.hwnd.settings.winx, % "x"w - settings.general.fWidth*2 " y-1"
	sleep 50

	If (vars.settings.x != "") && (vars.settings.y != "")
	{
		vars.settings.x := (vars.settings.x + w > vars.monitor.x + vars.monitor.w) ? vars.monitor.x + vars.monitor.w - w - 1 : vars.settings.x
		vars.settings.y := (vars.settings.y + h > vars.monitor.y + vars.monitor.h) ? vars.monitor.y + vars.monitor.h - h : vars.settings.y
		Gui, %GUI_name%: Show, % "NA x"vars.settings.x " y"vars.settings.y " w"w - 1 " h"h - 2
	}
	Else
	{
		Gui, %GUI_name%: Show, % "NA x" vars.monitor.x + vars.client.xc - w//2 " y" vars.monitor.y + vars.client.yc - h//2 " w"w - 1 " h"h - 2
		vars.settings.x := vars.monitor.x + vars.client.xc - w//2
	}
	LLK_Overlay(vars.hwnd.settings.main, "show", NA, GUI_name), LLK_Overlay(hwnd_old, "destroy")
	vars.settings.w := w, vars.settings.h := h, vars.settings.restart := vars.settings.wait := ""
}

Settings_menu2(section, mode := 0) ;mode parameter used when manually calling this function to refresh the window
{
	local
	global vars, settings

	Switch section
	{
		Case "anoints":
			Settings_anoints()
		Case "general":
			Settings_general()
		Case "actdecoder":
			Settings_actdecoder()
		Case "betrayal-info":
			Settings_betrayal()
		Case "cheat-sheets":
			Settings_cheatsheets()
		Case "clone-frames":
			Settings_cloneframes()
		Case "donations":
			Settings_donations()
		Case "tldr-tooltips":
			Settings_OCR()
		Case "filterspoon":
			Settings_lootfilter()
		Case "hotkeys":
			If !mode
				Init_hotkeys() ;reload settings from ini when accessing this section (makes it easier to discard unsaved settings if apply-button wasn't clicked)
			Settings_hotkeys()
		Case "item-info":
			Settings_iteminfo()
		Case "leveling tracker":
			Settings_leveltracker()
		Case "mapping tracker":
			Settings_maptracker()
		Case "map-info":
			Settings_mapinfo()
		Case "minor qol tools":
			Settings_qol()
		Case "sanctum":
			Settings_sanctum()
		Case "screen-checks":
			Settings_screenchecks()
		Case "search-strings":
			Init_searchstrings()
			Settings_searchstrings()
		Case "stash-ninja":
			Settings_stash()
		Case "statlas":
			Settings_statlas()
		Case "updater":
			Settings_updater()
	}
}

Settings_menuClose(activate := 1)
{
	local
	global vars, settings

	KeyWait, LButton
	If (vars.settings.active = "hotkeys")
		Init_hotkeys()
	LLK_Overlay(vars.hwnd.settings.main, "destroy"), vars.settings.active := "", vars.hwnd.Delete("settings"), vars.settings.mapinfo_search := ""
	If !settings.general.dev && activate
		WinActivate, ahk_group poe_window
}

Settings_OCR()
{
	local
	global vars, settings

	GUI := "settings_menu" vars.settings.GUI_toggle, x_anchor := vars.settings.x_anchor
	Gui, %GUI%: Add, Link, % "Section x" x_anchor " y" vars.settings.ySelection, <a href="https://github.com/Lailloken/Lailloken-UI/wiki/TLDR‐Tooltips">wiki page</a>
	Gui, %GUI%: Add, Link, % "ys x+" settings.general.fWidth, <a href="https://www.autohotkey.com/docs/v1/KeyList.htm">ahk: list of keys</a>
	Gui, %GUI%: Add, Link, % "ys HWNDhwnd x+" settings.general.fWidth, <a href="https://www.autohotkey.com/docs/v1/Hotkeys.htm">ahk: formatting</a>

	If (vars.client.h <= 720) ;&& !settings.general.dev
	{
		ControlGetPos, x,, w,,, ahk_id %hwnd%
		Gui, %GUI%: Add, Text, % "xs Section cRed w" x + w - x_anchor " y+" vars.settings.spacing, % Lang_Trans("m_ocr_unsupported")
		Return
	}

	If (settings.general.lang_client != "english") && !vars.client.stream
	{
		Settings_unsupported()
		Return
	}

	Gui, %GUI%: Add, Checkbox, % "xs Section gSettings_OCR2 HWNDhwnd Checked" settings.features.ocr " y+"vars.settings.spacing . (!settings.OCR.allow ? " cRed" : ""), % Lang_Trans("m_ocr_enable")
	vars.hwnd.settings.enable := vars.hwnd.help_tooltips["settings_ocr " (settings.OCR.allow ? "enable" : "compatibility")] := hwnd

	If !settings.features.ocr
		Return

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "xs Section y+"vars.settings.spacing, % Lang_Trans("global_general")
	Gui, %GUI%: Font, norm
	Gui, %GUI%: Add, Text, % "ys Border HWNDhwnd1 gSettings_OCR2 cRed Hidden", % " " Lang_Trans("global_restart") " "

	Gui, %GUI%: Add, Text, % "xs Section HWNDhwnd", % Lang_Trans("m_ocr_hotkey")
	Gui, %GUI%: Font, % "s" settings.general.fSize - 4
	Gui, %GUI%: Add, Edit, % "ys hp HWNDhwnd0 cBlack gSettings_OCR2 w" settings.general.fWidth * 10, % settings.OCR.z_hotkey
	Gui, %GUI%: Font, % "s" settings.general.fSize
	Gui, %GUI%: Add, Text, % "xs Section HWNDhwnd", % Lang_Trans("global_hotkey")
	Gui, %GUI%: Font, % "s" settings.general.fSize - 4
	Gui, %GUI%: Add, Edit, % "ys hp HWNDhwnd cBlack gSettings_OCR2 w" settings.general.fWidth * 10, % settings.OCR.hotkey
	Gui, %GUI%: Font, % "s" settings.general.fSize

	Gui, %GUI%: Add, Checkbox, % "ys HWNDhwnd3 gSettings_OCR2 Checked" settings.OCR.hotkey_block, % Lang_Trans("m_hotkeys_keyblock")
	Gui, %GUI%: Add, Checkbox, % "xs Section HWNDhwnd2 gSettings_OCR2 Checked" settings.OCR.debug, % Lang_Trans("m_ocr_debug")
	vars.hwnd.settings.z_hotkey := vars.hwnd.help_tooltips["settings_ocr z hotkey"] := hwnd0
	vars.hwnd.settings.hotkey := vars.hwnd.help_tooltips["settings_ocr hotkey"] := hwnd
	vars.hwnd.settings.hotkey_set := hwnd1, vars.hwnd.settings.debug := vars.hwnd.help_tooltips["settings_ocr debug"] := hwnd2
	vars.hwnd.settings.hotkey_block := vars.hwnd.help_tooltips["settings_hotkeys omniblock"] := hwnd3

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "xs Section y+"vars.settings.spacing, % Lang_Trans("global_ui")
	Gui, %GUI%: Font, norm

	Gui, %GUI%: Add, Text, % "xs Section HWNDhwnd0", % Lang_Trans("global_font")
	Gui, %GUI%: Add, Text, % "ys x+" settings.general.fWidth/2 " Center Border gSettings_OCR2 HWNDhwnd w"settings.general.fWidth*2, % "–"
	vars.hwnd.help_tooltips["settings_font-size"] := hwnd0, vars.hwnd.settings.font_minus := vars.hwnd.help_tooltips["settings_font-size|"] := hwnd
	Gui, %GUI%: Add, Text, % "ys x+"settings.general.fWidth/4 " Center Border gSettings_OCR2 HWNDhwnd w"settings.general.fWidth*3, % settings.OCR.fSize
	vars.hwnd.settings.font_reset := vars.hwnd.help_tooltips["settings_font-size||"] := hwnd
	Gui, %GUI%: Add, Text, % "ys x+"settings.general.fWidth/4 " Center Border gSettings_OCR2 HWNDhwnd w"settings.general.fWidth*2, % "+"
	vars.hwnd.settings.font_plus := vars.hwnd.help_tooltips["settings_font-size|||"] := hwnd
	Gui, %GUI%: Add, Text, % "xs Section", % Lang_Trans("m_iteminfo_highlight")
	Gui, %GUI%: Add, Pic, % "ys hp w-1 HWNDhwnd", % "HBitmap:*" vars.pics.global.help
	vars.hwnd.help_tooltips["settings_ocr colors"] := hwnd

	LLK_PanelDimensions([Lang_Trans("global_pattern") " 7"], settings.general.fSize, width, height)
	For index, array in settings.OCR.colors
	{
		Gui, %GUI%: Add, Text, % (InStr("14", A_Index) ? "xs Section" : "ys x+" settings.general.fWidth / 2) " Border Center HWNDhwndtext BackgroundTrans c" array.1 " w" width, % (index = 0 ? Lang_Trans("global_regular") : Lang_Trans("global_pattern") " " index)
		Gui, %GUI%: Add, Progress, % "xp yp wp hp Border BackgroundBlack HWNDhwndback c" array.2, 100
		Gui, %GUI%: Add, Text, % "ys x+-1 Border BackgroundTrans gSettings_OCR2 HWNDhwnd00", % "  "
		Gui, %GUI%: Add, Progress, % "xp yp wp hp Border BackgroundBlack HWNDhwnd01 c" array.1, 100
		Gui, %GUI%: Add, Text, % "ys x+-1 Border BackgroundTrans gSettings_OCR2 HWNDhwnd10", % "  "
		Gui, %GUI%: Add, Progress, % "xp yp wp hp Border BackgroundBlack HWNDhwnd11 c" array.2, 100
		vars.hwnd.settings["color_" index "1"] := hwnd00, vars.hwnd.settings["color_" index "_panel1"] := hwnd01, vars.hwnd.settings["color_" index "_text1"] := hwndtext
		vars.hwnd.settings["color_" index "2"] := hwnd10, vars.hwnd.settings["color_" index "_panel2"] := hwnd11, vars.hwnd.settings["color_" index "_text2"] := hwndback
		vars.hwnd.help_tooltips["settings_generic color double" handle] := hwnd01, vars.hwnd.help_tooltips["settings_generic color double1" handle] := hwnd11, handle .= "|"
	}
}

Settings_OCR2(cHWND)
{
	local
	global vars, settings
	static compat_text

	check := LLK_HasVal(vars.hwnd.settings, cHWND), control := SubStr(check, InStr(check, "_") + 1)
	Switch check
	{
		Case "enable":
			If !settings.OCR.allow
			{
				GuiControl,, % cHWND, 0
				compat_text := OCR("compat")
				Return
			}

			settings.features.ocr := LLK_ControlGet(cHWND)
			IniWrite, % settings.features.ocr, ini\config.ini, Features, enable ocr
			If !Blank(settings.OCR.hotkey)
			{
				Hotkey, IfWinActive, ahk_group poe_window
				Hotkey, % "*" (settings.OCR.hotkey_block ? "" : "~") . Hotkeys_Convert(settings.OCR.hotkey), OCR, % settings.features.OCR ? "On" : "Off"
			}
			If WinExist("ahk_id " vars.hwnd.ocr_tooltip.main)
				OCR_Close()
			Settings_menu("tldr-tooltips")

		Case "compat_edit":
			If settings.OCR.allow
				Return
			compat_edit := LLK_ControlGet(vars.hwnd.settings.compat_edit), correct := ""
			input := [], count := 0
			Loop, Parse, compat_edit, % A_Space
				If (StrLen(A_LoopField) > 1) && !LLK_HasVal(input, A_LoopField)
					input.Push(A_LoopField)
			For index, word in input
				If vars.OCR.text_check.HasKey(word)
					count += 1, correct .= (Blank(correct) ? "" : ", ") word
			GuiControl, text, % vars.hwnd.settings.compat_correct, % (count >= 8 ? "" : "(" count "/8) ") . Lang_Trans("global_success") ": " (count >= 8 ? Lang_Trans("m_ocr_finish") : correct)
			If (count < 8)
				Return
			Else
			{
				settings.OCR.allow := 1
				IniWrite, 1, ini\ocr.ini, Settings, allow ocr
			}

		Case "debug":
			settings.OCR.debug := LLK_ControlGet(cHWND)
			IniWrite, % settings.OCR.debug, ini\ocr.ini, settings, enable debug

			Case "z_hotkey":
			input := LLK_ControlGet(cHWND)
			If (StrLen(input) != 1)
				Loop, Parse, % "+!^#"
					input := StrReplace(input, A_LoopField)

			If !Blank(input) && GetKeyVK(input)
			{
				settings.OCR.z_hotkey := input
				IniWrite, % input, ini\ocr.ini, settings, toggle highlighting hotkey
				GuiControl, +cBlack, % cHWND
			}
			Else GuiControl, +cRed, % cHWND

		Case "hotkey_set":
			input := LLK_ControlGet(vars.hwnd.settings.hotkey)
			If (StrLen(input) != 1)
				Loop, Parse, % "+!^#"
					input := StrReplace(input, A_LoopField)

			If LLK_ControlGet(vars.hwnd.settings.hotkey) && (!GetKeyVK(input) || (input = ""))
			{
				WinGetPos, x, y, w, h, % "ahk_id "vars.hwnd.settings.hotkey
				LLK_ToolTip(Lang_Trans("m_hotkeys_error"),, x, y + h,, "red")
				Return
			}
			IniWrite, % LLK_ControlGet(vars.hwnd.settings.hotkey_block), ini\ocr.ini, settings, block native key-function
			IniWrite, % input, ini\ocr.ini, settings, hotkey
			IniWrite, % "tldr-tooltips", ini\config.ini, versions, reload settings
			KeyWait, LButton
			Reload
			ExitApp

		Default:
			If InStr(check, "font")
			{
				While GetKeyState("LButton", "P")
				{
					If (control = "reset")
						settings.OCR.fSize := settings.general.fSize
					Else settings.OCR.fSize += (control = "minus") ? -1 : 1, settings.OCR.fSize := (settings.OCR.fSize < 6) ? 6 : settings.OCR.fSize
					GuiControl, text, % vars.hwnd.settings.font_reset, % settings.OCR.fSize
					Sleep 150
				}
				IniWrite, % settings.OCR.fSize, ini\ocr.ini, settings, font-size
				LLK_FontDimensions(settings.OCR.fSize, height, width), settings.OCR.fWidth := width, settings.OCR.fHeight := height
			}
			Else If InStr(check, "color_")
			{
				pattern := SubStr(control, 1, 1), type := SubStr(control, 2, 1)
				color := (vars.system.click = 1) ? RGB_Picker(settings.OCR.colors[pattern][type]) : settings.OCR.dColors[pattern][type]
				If !Blank(color)
				{
					settings.OCR.colors[pattern][type] := color
					IniWrite, % settings.OCR.colors[pattern].1 "," settings.OCR.colors[pattern].2, ini\ocr.ini, UI, % "pattern " pattern
					Loop, 2
					{
						GuiControl, % "+c" settings.OCR.colors[pattern][A_Index], % vars.hwnd.settings["color_" pattern "_text" A_Index]
						GuiControl, % "movedraw", % vars.hwnd.settings["color_" pattern "_text" A_Index]
						GuiControl, % "+c" settings.OCR.colors[pattern][A_Index], % vars.hwnd.settings["color_" pattern "_panel" A_Index]
						GuiControl, % "movedraw", % vars.hwnd.settings["color_" pattern "_panel" A_Index]
					}
				}
			}
			Else If (check = "hotkey" || check = "hotkey_block")
			{
				setting := LLK_ControlGet(cHWND)
				If (check = "hotkey")
				{
					If (StrLen(setting) > 1)
						Loop, Parse, % "+!^#"
							setting := StrReplace(setting, A_LoopField)
					GuiControl, % "+c" (!GetKeyVK(setting) ? "Red" : "Black"), % cHWND
					GuiControl, movedraw, % cHWND
				}
				GuiControl, % (setting != settings.OCR[check] ? "-Hidden" : "+Hidden"), % vars.hwnd.settings.hotkey_set
			}
			Else LLK_ToolTip("no action: " check)

			If (InStr(check, "color_") || InStr(check, "font")) && vars.hwnd.ocr_tooltip.main && WinExist("ahk_id " vars.hwnd.ocr_tooltip.main)
				mode := vars.OCR.last, OCR%mode%()
	}
}

Settings_qol()
{
	local
	global vars, settings

	GUI := "settings_menu" vars.settings.GUI_toggle
	Gui, %GUI%: Add, Link, % "Section x" vars.settings.x_anchor " y" vars.settings.ySelection, <a href="https://github.com/Lailloken/Lailloken-UI/wiki/Minor-Features">wiki page</a>

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "xs HWNDhwnd1 y+"vars.settings.spacing " Section", % Lang_Trans("m_qol_alarm")
	Gui, %GUI%: Font, norm
	Gui, %GUI%: Add, Checkbox, % "ys x+"settings.general.fWidth " gSettings_qol2 HWNDhwnd Checked"settings.qol.alarm, % Lang_Trans("global_enable")
	Gui, %GUI%: Add, Text, % "ys wp BackgroundTrans"
	vars.hwnd.help_tooltips["settings_alarm enable"] := hwnd1, vars.hwnd.settings.enable_alarm := vars.hwnd.help_tooltips["settings_alarm enable|"] := hwnd

	If settings.qol.alarm
	{
		Gui, %GUI%: Add, Text, % "xs HWNDhwnd0 Section", % Lang_Trans("global_font")
		Gui, %GUI%: Add, Text, % "ys x+" settings.general.fWidth/2 " HWNDhwnd Border Center gSettings_qol2 w"settings.general.fWidth*2, % "–"
		vars.hwnd.help_tooltips["settings_font-size"] := hwnd0, vars.hwnd.settings.alarmfont_minus := vars.hwnd.help_tooltips["settings_font-size|"] := hwnd
		Gui, %GUI%: Add, Text, % "ys x+"settings.general.fWidth/4 " HWNDhwnd Border Center gSettings_qol2 w"settings.general.fWidth*3, % settings.alarm.fSize
		vars.hwnd.settings.alarmfont_reset := vars.hwnd.help_tooltips["settings_font-size||"] := hwnd
		Gui, %GUI%: Add, Text, % "ys x+"settings.general.fWidth/4 " HWNDhwnd Border Center gSettings_qol2 w"settings.general.fWidth*2, % "+"
		vars.hwnd.settings.alarmfont_plus := vars.hwnd.help_tooltips["settings_font-size|||"] := hwnd

		Gui, %GUI%: Add, Text, % "ys x+" settings.general.fWidth, % Lang_Trans("global_color", 2)
		Gui, %GUI%: Add, Text, % "ys x+" settings.general.fWidth/2 " BackgroundTrans Border HWNDhwnd gSettings_qol2", % "  "
		Gui, %GUI%: Add, Progress, % "xp yp wp hp Border Disabled BackgroundBlack HWNDhwnd1 c" settings.alarm.color, 100
		vars.hwnd.settings.color_alarm := hwnd, vars.hwnd.settings.color_alarm_bar := vars.hwnd.help_tooltips["settings_generic color double"] := hwnd1
		Gui, %GUI%: Add, Text, % "ys x+-1 BackgroundTrans Border HWNDhwnd gSettings_qol2", % "  "
		Gui, %GUI%: Add, Progress, % "xp yp wp hp Border Disabled BackgroundBlack HWNDhwnd1 c" settings.alarm.color1, 100
		vars.hwnd.settings.color_alarm1 := hwnd, vars.hwnd.settings.color_alarm1_bar := vars.hwnd.help_tooltips["settings_generic color double1"] := hwnd1
	}

	If !vars.poe_version
	{
		Gui, %GUI%: Font, bold underline
		Gui, %GUI%: Add, Text, % "xs HWNDhwnd0 y+"vars.settings.spacing " Section", % Lang_Trans("m_qol_map_events")
		Gui, %GUI%: Font, norm
		Gui, %GUI%: Add, Checkbox, % "ys x+"settings.general.fWidth " gSettings_qol2 HWNDhwnd Checked" settings.qol.mapevents, % Lang_Trans("global_enable")
		vars.hwnd.help_tooltips["settings_map-events enable"] := hwnd0, vars.hwnd.settings.enable_mapevents := vars.hwnd.help_tooltips["settings_map-events enable|"] := hwnd

		If settings.qol.mapevents
		{
			Gui, %GUI%: Add, Text, % "xs Section HWNDhwnd0", % Lang_Trans("global_font")
			Gui, %GUI%: Add, Text, % "ys x+" settings.general.fWidth/2 " HWNDhwnd Border Center gSettings_qol2 w"settings.general.fWidth*2, % "–"
			vars.hwnd.help_tooltips["settings_font-size"] := hwnd0, vars.hwnd.settings.mapeventsfont_minus := vars.hwnd.help_tooltips["settings_font-size|"] := hwnd
			Gui, %GUI%: Add, Text, % "ys x+"settings.general.fWidth/4 " HWNDhwnd Border Center gSettings_qol2 w"settings.general.fWidth*3, % settings.mapevents.fSize
			vars.hwnd.settings.mapeventsfont_reset := vars.hwnd.help_tooltips["settings_font-size||"] := hwnd
			Gui, %GUI%: Add, Text, % "ys x+"settings.general.fWidth/4 " HWNDhwnd Border Center gSettings_qol2 w"settings.general.fWidth*2, % "+"
			vars.hwnd.settings.mapeventsfont_plus := vars.hwnd.help_tooltips["settings_font-size|||"] := hwnd

			Gui, %GUI%: Add, Text, % "ys x+" settings.general.fWidth, % Lang_Trans("global_color", 2)
			Gui, %GUI%: Add, Text, % "ys x+" settings.general.fWidth/2 " BackgroundTrans Border HWNDhwnd gSettings_qol2", % "  "
			Gui, %GUI%: Add, Progress, % "xp yp wp hp Border Disabled BackgroundBlack HWNDhwnd1 c" settings.mapevents.color, 100
			vars.hwnd.settings.color_mapevents := hwnd, vars.hwnd.settings.color_mapevents_bar := vars.hwnd.help_tooltips["settings_generic color double|"] := hwnd1
			Gui, %GUI%: Add, Text, % "ys x+-1 BackgroundTrans Border HWNDhwnd gSettings_qol2", % "  "
			Gui, %GUI%: Add, Progress, % "xp yp wp hp Border Disabled BackgroundBlack HWNDhwnd1 c" settings.mapevents.color1, 100
			vars.hwnd.settings.color_mapevents1 := hwnd, vars.hwnd.settings.color_mapevents1_bar := vars.hwnd.help_tooltips["settings_generic color double1|"] := hwnd1

			Gui, %GUI%: Add, Text, % "Section xs", % Lang_Trans("global_duration") . Lang_Trans("global_colon")
			Gui, %GUI%: Add, Slider, % "ys x+0 hp w" settings.general.fWidth*10 " HWNDhwnd ToolTip gSettings_qol2 NoTicks Center Range3-10", % settings.mapevents.duration
			vars.hwnd.settings.duration_mapevents := hwnd

			Gui, %GUI%: Add, Text, % "Section xs HWNDhwnd", % Lang_Trans("global_position") . Lang_Trans("global_colon") " "
			Gui, %GUI%: Font, % "s" settings.general.fSize - 4
			For index, val in ["top", "bottom", "left", "right"]
				mapevents_ddl .= (index = 1 ? "" : "|") . Lang_Trans("m_general_pos" val)
			Gui, %GUI%: Add, DDL, % "ys x+0 hp w" settings.general.fWidth*10 " HWNDhwnd1 gSettings_qol2 AltSubmit R4 Choose" settings.mapevents.position, % mapevents_ddl
			Gui, %GUI%: Font, % "s" settings.general.fSize
			vars.hwnd.settings.position_mapevents := hwnd1, vars.hwnd.help_tooltips["settings_map-events position"] := hwnd

			Gui, %GUI%: Add, Text, % "ys Border HWNDhwnd gSettings_qol2", % " " Lang_Trans("global_test") " "
			vars.hwnd.settings.test_mapevents := vars.hwnd.help_tooltips["settings_map-events test"] := hwnd
		}
	}

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "xs HWNDhwnd0 y+"vars.settings.spacing " Section", % Lang_Trans("m_qol_notepad")
	Gui, %GUI%: Font, norm
	Gui, %GUI%: Add, Checkbox, % "ys x+"settings.general.fWidth " gSettings_qol2 HWNDhwnd Checked"settings.qol.notepad, % Lang_Trans("global_enable")
	vars.hwnd.help_tooltips["settings_notepad enable"] := hwnd0, vars.hwnd.settings.enable_notepad := vars.hwnd.help_tooltips["settings_notepad enable|"] := hwnd

	If settings.qol.notepad
	{
		Gui, %GUI%: Add, Text, % "xs Section HWNDhwnd0", % Lang_Trans("global_font")
		Gui, %GUI%: Add, Text, % "ys x+" settings.general.fWidth/2 " HWNDhwnd Border Center gSettings_qol2 w"settings.general.fWidth*2, % "–"
		vars.hwnd.help_tooltips["settings_font-size"] := hwnd0, vars.hwnd.settings.notepadfont_minus := vars.hwnd.help_tooltips["settings_font-size|"] := hwnd
		Gui, %GUI%: Add, Text, % "ys x+"settings.general.fWidth/4 " HWNDhwnd Border Center gSettings_qol2 w"settings.general.fWidth*3, % settings.notepad.fSize
		vars.hwnd.settings.notepadfont_reset := vars.hwnd.help_tooltips["settings_font-size||"] := hwnd
		Gui, %GUI%: Add, Text, % "ys x+"settings.general.fWidth/4 " HWNDhwnd Border Center gSettings_qol2 w"settings.general.fWidth*2, % "+"
		vars.hwnd.settings.notepadfont_plus := vars.hwnd.help_tooltips["settings_font-size|||"] := hwnd
		Gui, %GUI%: Add, Text, % "xs Section HWNDhwnd", % Lang_Trans("m_qol_widgetcolor")
		vars.hwnd.help_tooltips["settings_notepad default color"] := hwnd
		Gui, %GUI%: Add, Text, % "ys x+" settings.general.fWidth/2 " BackgroundTrans Border HWNDhwnd gSettings_qol2", % "  "
		Gui, %GUI%: Add, Progress, % "xp yp wp hp Border Disabled BackgroundBlack HWNDhwnd1 c" settings.notepad.color, 100
		vars.hwnd.settings.color_notepad := hwnd, vars.hwnd.settings.color_notepad_bar := vars.hwnd.help_tooltips["settings_generic color double||"] := hwnd1
		Gui, %GUI%: Add, Text, % "ys x+-1 BackgroundTrans Border HWNDhwnd gSettings_qol2", % "  "
		Gui, %GUI%: Add, Progress, % "xp yp wp hp Border Disabled BackgroundBlack HWNDhwnd1 c" settings.notepad.color1, 100
		vars.hwnd.settings.color_notepad1 := hwnd, vars.hwnd.settings.color_notepad1_bar := vars.hwnd.help_tooltips["settings_generic color double1||"] := hwnd1
		Gui, %GUI%: Add, Text, % "xs Section HWNDhwnd", % Lang_Trans("m_qol_widget")
		vars.hwnd.help_tooltips["settings_notepad opacity"] := hwnd, handle := "|"
		Loop 6
		{
			Gui, %GUI%: Add, Text, % "ys x+" settings.general.fWidth / (A_Index = 1 ? 2 : 4) " HWNDhwnd Border Center gSettings_qol2 w" settings.general.fWidth*2 (A_Index - 1 = settings.notepad.trans ? " cFuchsia" : ""), % A_Index - 1
			vars.hwnd.settings["notepadopac_" A_Index - 1] := vars.hwnd.help_tooltips["settings_notepad opacity" handle] := hwnd, handle .= "|"
		}
	}

	If vars.client.stream || vars.poe_version
		Return
	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "Section xs HWNDhwnd0 y+"vars.settings.spacing (settings.general.lang_client = "unknown" ? " cGray" : ""), % Lang_Trans("m_qol_lab")
	Gui, %GUI%: Font, norm
	Gui, %GUI%: Add, Checkbox, % "ys x+"settings.general.fWidth " gSettings_qol2 HWNDhwnd Checked"settings.qol.lab (settings.general.lang_client = "unknown" ? " cGray" : ""), % Lang_Trans("global_enable")
	If (settings.general.lang_client = "unknown")
		vars.hwnd.help_tooltips["settings_lang incompatible"] := hwnd0, vars.hwnd.settings.enable_lab := vars.hwnd.help_tooltips["settings_lang incompatible|"] := hwnd
	Else vars.hwnd.help_tooltips["settings_lab enable"] := hwnd0, vars.hwnd.settings.enable_lab := vars.hwnd.help_tooltips["settings_lab enable|"] := hwnd
}

Settings_qol2(cHWND)
{
	local
	global vars, settings

	check := LLK_HasVal(vars.hwnd.settings, cHWND), control := SubStr(check, InStr(check, "_") + 1), control1 := SubStr(check, 1, InStr(check, "_") - 1)
	If InStr(check, "enable_")
	{
		If (control = "lab" && settings.general.lang_client = "unknown")
		{
			GuiControl,, % cHWND, 0
			Return
		}
		settings.qol[control] := LLK_ControlGet(cHWND)
		IniWrite, % settings.qol[control], % "ini" vars.poe_version "\qol tools.ini", features, % control
		If (control = "alarm") && !settings.qol.alarm
			vars.alarm.timestamp := "", LLK_Overlay(vars.hwnd.alarm.main, "destroy")
		If (control = "notepad")
			Init_GUI()
		If (control = "notepad") && !settings.qol.notepad
		{
			LLK_Overlay(vars.hwnd.notepad.main, "destroy"), vars.hwnd.notepad.main := ""
			For key, val in vars.hwnd.notepad_widgets
				LLK_Overlay(val, "destroy")
			vars.hwnd.notepad_widgets := {}, vars.notepad_widgets := {}
		}
		Settings_menu("minor qol tools")
	}
	Else If InStr(check, "color_")
	{
		If (vars.system.click = 1)
			picked_rgb := RGB_Picker(settings[(SubStr(control, 0) = "1") ? SubStr(control, 1, -1) : control]["color" (InStr(control, "1") ? "1" : "")])
		If (vars.system.click = 1) && Blank(picked_rgb)
			Return
		Else
		{
			If InStr(check, "1")
				control := StrReplace(control, "1"), settings[control].color1 := (vars.system.click = 1) ? picked_rgb : (InStr(check, "mapevents") ? "FFFFFF" : "000000")
			Else settings[control].color := (vars.system.click = 1) ? picked_rgb : (InStr(check, "mapevents") ? "FF0000" : "FFFFFF")
		}
		IniWrite, % settings[control]["color" (InStr(check, "1") ? "1" : "")], % "ini" vars.poe_version "\qol tools.ini", % control, % (InStr(check, "1") ? "background " : "font-") "color"
		GuiControl, % "+c"settings[control]["color" (InStr(check, "1") ? "1" : "")], % vars.hwnd.settings[check "_bar"]
		GuiControl, movedraw, % vars.hwnd.settings[check "_bar"]
		If (control = "notepad")
		{
			Notepad_Reload()
			For key, val in vars.hwnd.notepad_widgets
					Notepad_Widget(key)
			If WinExist("ahk_id " vars.hwnd.notepad.main)
				Notepad("save"), Notepad()
		}
		If (control = "alarm") && vars.alarm.toggle
			Alarm()
	}
	Else If InStr(check, "duration_")
		IniWrite, % (settings.mapevents.duration := LLK_ControlGet(cHWND)), % "ini" vars.poe_version "\qol tools.ini", % control, duration
	Else If InStr(check, "position_")
		IniWrite, % (settings.mapevents.position := LLK_ControlGet(cHWND)), % "ini" vars.poe_version "\qol tools.ini", % control, position
	Else If InStr(check, "font_")
	{
		control1 := StrReplace(control1, "font")
		While GetKeyState("LButton")
		{
			If (control = "minus") && (settings[control1].fSize > 6)
				settings[control1].fSize -= 1
			Else If (control = "reset")
				settings[control1].fSize := settings.general.fSize
			Else If (control = "plus")
				settings[control1].fSize += 1
			GuiControl, text, % vars.hwnd.settings[control1 "font_reset"], % settings[control1].fSize
			If (control = "reset")
				Break
			Sleep 100
		}
		LLK_FontDimensions(settings[control1].fSize, height, width), settings[control1].fWidth := width, settings[control1].fHeight := height
		IniWrite, % settings[control1].fSize, % "ini" vars.poe_version "\qol tools.ini", % control1, font-size
		If (control1 = "notepad") && WinExist("ahk_id "vars.hwnd.notepad.main)
			Notepad("save"), Notepad()
		If (control1 = "notepad") && vars.hwnd.notepad_widgets.Count()
			For key, val in vars.hwnd.notepad_widgets
				Notepad_Widget(key)
		If (control1 = "alarm") && vars.alarm.toggle
			Alarm()
	}
	Else If InStr(check, "opac_")
	{
		control1 := SubStr(control1, 1, InStr(control1, "opac") - 1)
		GuiControl, +cWhite, % vars.hwnd.settings[control1 "opac_" settings[control1].trans]
		GuiControl, movedraw, % vars.hwnd.settings[control1 "opac_" settings[control1].trans]
		settings[control1].trans := control
		IniWrite, % settings[control1].trans, % "ini" vars.poe_version "\qol tools.ini", % control1, transparency
		GuiControl, +cFuchsia, % vars.hwnd.settings[control1 "opac_" settings[control1].trans]
		GuiControl, movedraw, % vars.hwnd.settings[control1 "opac_" settings[control1].trans]
		If (control1 = "notepad") && vars.hwnd.notepad_widgets.Count()
			For key, val in vars.hwnd.notepad_widgets
				WinSet, Transparent, % (key = "notepad_reminder_feature") ? 250 : 50 * settings.notepad.trans, % "ahk_id "val
	}
	Else If (check = "test_mapevents")
		MapEvent("seer")
	Else LLK_ToolTip("no action")
}

Settings_sanctum()
{
	local
	global vars, settings

	GUI := "settings_menu" vars.settings.GUI_toggle, x_anchor := vars.settings.x_anchor
	Gui, %GUI%: Add, Link, % "Section x" x_anchor " y" vars.settings.ySelection, <a href="https://github.com/Lailloken/Exile-UI/wiki/Sanctum-and-Sekhema-Planner">wiki page</a>

	Gui, %GUI%: Add, Checkbox, % "xs Section HWNDhwnd gSettings_sanctum2 y+" vars.settings.spacing " Checked" settings.features.sanctum, % Lang_Trans("m_sanctum_enable", vars.poe_version ? 2 : 1)
	vars.hwnd.settings.enable := vars.hwnd.help_tooltips["settings_sanctum enable"] := hwnd

	If !settings.features.sanctum
		Return

	If !vars.poe_version
	{
		Gui, %GUI%: Font, underline bold
		Gui, %GUI%: Add, Text, % "xs Section y+" vars.settings.spacing, % Lang_Trans("global_general")
		Gui, %GUI%: Font, norm
	
		Gui, %GUI%: Add, Checkbox, % "xs Section HWNDhwnd gSettings_sanctum2 Checked" settings.sanctum.cheatsheet, % Lang_Trans("m_sanctum_cheatsheets")
		vars.hwnd.settings.cheatsheet := vars.hwnd.help_tooltips["settings_sanctum cheatsheet"] := hwnd
	}

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "xs Section y+" vars.settings.spacing, % Lang_Trans("global_ui")
	Gui, %GUI%: Font, norm

	Gui, %GUI%: Add, Text, % "xs Section", % Lang_Trans("global_font")
	Gui, %GUI%: Add, Text, % "ys x+" settings.general.fWidth/2 " Center Border gSettings_sanctum2 HWNDhwnd w"settings.general.fWidth*2, % "–"
	vars.hwnd.help_tooltips["settings_font-size"] := hwnd0, vars.hwnd.settings.font_minus := vars.hwnd.help_tooltips["settings_font-size|"] := hwnd
	Gui, %GUI%: Add, Text, % "ys x+"settings.general.fWidth/4 " Center Border gSettings_sanctum2 HWNDhwnd w"settings.general.fWidth*3, % settings.sanctum.fSize
	vars.hwnd.settings.font_reset := vars.hwnd.help_tooltips["settings_font-size||"] := hwnd
	Gui, %GUI%: Add, Text, % "ys x+"settings.general.fWidth/4 " Center Border gSettings_sanctum2 HWNDhwnd w"settings.general.fWidth*2, % "+"
	vars.hwnd.settings.font_plus := vars.hwnd.help_tooltips["settings_font-size|||"] := hwnd
}

Settings_sanctum2(cHWND := "")
{
	local
	global vars, settings

	check := LLK_HasVal(vars.hwnd.settings, cHWND), control := SubStr(check, InStr(check, "_") + 1)
	If (check = "enable")
	{
		IniWrite, % (settings.features.sanctum := LLK_ControlGet(cHWND)), % "ini" vars.poe_version "\config.ini", features, enable sanctum planner
		Settings_menu("sanctum")
	}
	Else If (check = "cheatsheet")
	{
		IniWrite, % (settings.sanctum.cheatsheet := LLK_ControlGet(cHWND)), % "ini" vars.poe_version "ini\sanctum.ini", settings, enable cheat-sheet
		vars.hwnd.sanctum.uptodate := 0
		If WinExist("ahk_id " vars.hwnd.sanctum.second)
			Sanctum()
	}
	Else If InStr(check, "font_")
	{
		While GetKeyState("LButton", "P")
		{
			If (control = "reset")
				settings.sanctum.fSize := settings.general.fSize
			Else settings.sanctum.fSize += (control = "plus") ? 1 : (settings.sanctum.fSize > 6 ? -1 : 0)
			GuiControl, Text, % vars.hwnd.settings.font_reset, % settings.sanctum.fSize
			Sleep 200
		}
		IniWrite, % settings.sanctum.fSize, % "ini" vars.poe_version "ini\sanctum.ini", settings, font-size
		LLK_FontDimensions(settings.sanctum.fSize, fHeight, fWidth), settings.sanctum.fWidth := fWidth, settings.sanctum.fHeight := fHeight
		vars.hwnd.sanctum.uptodate := 0
		If WinExist("ahk_id " vars.hwnd.sanctum.second)
			Sanctum()
		If WinExist("ahk_id " vars.hwnd.sanctum_relics.main)
			Sanctum_Relics()
	}
	Else LLK_ToolTip("no action")

	If !settings.features.sanctum && WinExist("ahk_id " vars.hwnd.sanctum.second)
		LLK_Overlay(vars.hwnd.sanctum.main, "destroy"), LLK_Overlay(vars.hwnd.sanctum.second, "destroy"), vars.sanctum.lock := vars.sanctum.active := vars.hwnd.sanctum := vars.sanctum.scanning := ""
}

Settings_screenchecks()
{
	local
	global vars, settings

	GUI := "settings_menu" vars.settings.GUI_toggle
	Gui, %GUI%: Add, Link, % "Section x" vars.settings.x_anchor " y" vars.settings.ySelection, <a href="https://github.com/Lailloken/Lailloken-UI/wiki/Screen-checks">wiki page</a>
	Gui, %GUI%: Font, % "underline bold"
	Gui, %GUI%: Add, Text, % "xs Section y+"vars.settings.spacing, % Lang_Trans("m_screen_pixel")
	Gui, %GUI%: Add, Pic, % "ys hp w-1 BackgroundTrans HWNDhwnd", % "HBitmap:*" vars.pics.global.help
	Gui, %GUI%: Font, % "norm"
	vars.hwnd.help_tooltips["settings_screenchecks pixel-about"] := hwnd

	For key in vars.pixelsearch.list
	{
		If vars.poe_version && (key = "gamescreen")
			Continue
		Gui, %GUI%: Add, Text, % "xs Section border gSettings_screenchecks2 HWNDhwnd", % " " Lang_Trans("global_info") " "
		vars.hwnd.settings["info_"key] := vars.hwnd.help_tooltips["settings_screenchecks pixel-info"handle] := hwnd
		Gui, %GUI%: Add, Text, % "ys x+"settings.general.fWidth/4 " border gSettings_screenchecks2 HWNDhwnd"(Blank(vars.pixelsearch[key].color1) ? " cRed" : ""), % " " Lang_Trans("global_calibrate") " "
		vars.hwnd.settings["cPixel_"key] := vars.hwnd.help_tooltips["settings_screenchecks pixel-calibration"handle] := hwnd
		Gui, %GUI%: Add, Text, % "ys x+"settings.general.fWidth/4 " border gSettings_screenchecks2 HWNDhwnd", % " " Lang_Trans("global_test") " "
		vars.hwnd.settings["tPixel_"key] := vars.hwnd.help_tooltips["settings_screenchecks pixel-test"handle] := hwnd, handle .= "|"
		Gui, %GUI%: Add, Text, % "ys", % Lang_Trans((key = "inventory" ? "global_" : "m_screen_") key)
	}
	Gui, %GUI%: Font, norm

	If vars.client.stream
	{
		Gui, %GUI%: Add, Text, % "xs Section", % Lang_Trans("global_variance") ":"
		Gui, %GUI%: Font, % "s" settings.general.fSize - 4
		Gui, %GUI%: Add, Edit, % "ys hp Number Limit3 r1 cBlack gSettings_screenchecks2 HWNDhwnd w" settings.general.fWidth * 3, % vars.pixelsearch.variation
		Gui, %GUI%: Font, % "s" settings.general.fSize
		Gui, %GUI%: Add, Pic, % "ys hp w-1 HWNDhwnd1", % "HBitmap:*" vars.pics.global.help
		vars.hwnd.help_tooltips["settings_screenchecks variance"] := hwnd1, vars.hwnd.settings.variance_pixel := hwnd
	}

	count := 0
	For key in vars.imagesearch.list
	{
		If (key = "skilltree" && !settings.features.leveltracker) || (key = "stash" && (!settings.features.maptracker || !settings.maptracker.loot))
		|| (key = "atlas") && !settings.features.statlas || (key = "betrayal") && !settings.features[key]
			Continue
		count += 1
	}
	If !count
		Return

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "xs Section BackgroundTrans y+"vars.settings.spacing, % Lang_Trans("m_screen_image")
	Gui, %GUI%: Add, Pic, % "ys hp w-1 BackgroundTrans HWNDhwnd", % "HBitmap:*" vars.pics.global.help
	Gui, %GUI%: Font, norm
	vars.hwnd.help_tooltips["settings_screenchecks image-about"] := hwnd, handle := ""

	For key in vars.imagesearch.list
	{
		If (key = "skilltree" && !settings.features.leveltracker) || (key = "stash" && (!settings.features.maptracker || !settings.maptracker.loot))
		|| (key = "atlas") && !settings.features.statlas || (key = "betrayal") && !settings.features[key]
			Continue
		Gui, %GUI%: Add, Text, % "xs Section border gSettings_screenchecks2 HWNDhwnd", % " " Lang_Trans("global_info") " "
		vars.hwnd.settings["info_"key] := vars.hwnd.help_tooltips["settings_screenchecks image-info"handle] := hwnd
		Gui, %GUI%: Add, Text, % "ys x+"settings.general.fWidth/4 " border gSettings_screenchecks2 HWNDhwnd"(!FileExist("img\Recognition (" vars.client.h "p)\GUI\" key . vars.poe_version ".bmp") ? " cRed" : ""), % " " Lang_Trans("global_calibrate") " "
		vars.hwnd.settings["cImage_"key] := vars.hwnd.help_tooltips["settings_screenchecks image-calibration"handle] := hwnd
		Gui, %GUI%: Add, Text, % "ys x+"settings.general.fWidth/4 " border gSettings_screenchecks2 HWNDhwnd" (Blank(vars.imagesearch[key].x1) ? " cRed" : ""), % " " Lang_Trans("global_test") " "
		vars.hwnd.settings["tImage_"key] := vars.hwnd.help_tooltips["settings_screenchecks image-test"handle] := hwnd, handle .= "|"
		Gui, %GUI%: Add, Text, % "ys", % Lang_Trans((key = "betrayal" ? "mechanic_" : "global_") key)
	}
	Gui, %GUI%: Font, norm
	Gui, %GUI%: Add, Text, % "xs Section Center Border gSettings_screenchecks2 HWNDhwnd", % " " Lang_Trans("global_imgfolder") " "
	vars.hwnd.settings.folder := vars.hwnd.help_tooltips["settings_screenchecks folder"] := hwnd

	If vars.client.stream
	{
		Gui, %GUI%: Add, Text, % "xs Section", % Lang_Trans("global_variance") ":"
		Gui, %GUI%: Font, % "s" settings.general.fSize - 4
		Gui, %GUI%: Add, Edit, % "ys hp Number Limit3 r1 cBlack gSettings_screenchecks2 HWNDhwnd w" settings.general.fWidth * 3, % vars.imagesearch.variation
		Gui, %GUI%: Font, % "s" settings.general.fSize
		Gui, %GUI%: Add, Pic, % "ys hp w-1 HWNDhwnd1", % "HBitmap:*" vars.pics.global.help
		vars.hwnd.help_tooltips["settings_screenchecks variance|"] := hwnd1, vars.hwnd.settings.variance_image := hwnd
	}
}

Settings_screenchecks2(cHWND := "")
{
	local
	global vars, settings

	check := LLK_HasVal(vars.hwnd.settings, cHWND), control := SubStr(check, InStr(check, "_") + 1)
	If (check = 0)
		check := A_GuiControl

	Switch check
	{
		Case "folder":
			If FileExist("img\Recognition (" vars.client.h "p)\GUI")
				Run, % "explore img\Recognition ("vars.client.h "p)\GUI\"
			Else LLK_ToolTip(Lang_Trans("cheat_filemissing"),,,,, "red")
		Default:
			If InStr(check, "variance_")
			{
				input := LLK_ControlGet(cHWND), input := (input > 255) ? 255 : Blank(input) ? 0 : input
				IniWrite, % (vars[control "search"].variation := input), % "ini" vars.poe_version "\geforce now.ini", settings, % control "-check variation"
			}
			Else If InStr(check, "Pixel")
			{
				Switch SubStr(check, 1, 1)
				{
					Case "t":
						If Screenchecks_PixelSearch(control)
							LLK_ToolTip(Lang_Trans("global_positive"),,,,, "lime")
						Else LLK_ToolTip(Lang_Trans("global_negative"),,,,, "red")
					Case "c":
						Screenchecks_PixelRecalibrate(control)
						LLK_ToolTip(Lang_Trans("global_success"),,,,, "lime"), Settings_ScreenChecksValid()
						GuiControl, +cWhite, % cHWND
						GuiControl, movedraw, % cHWND
				}
			}
			Else If InStr(check, "Image")
			{
				Switch SubStr(check, 1, 1)
				{
					Case "t":
						If (Screenchecks_ImageSearch(control) > 0)
						{
							LLK_ToolTip(Lang_Trans("global_positive"),,,,, "lime"), Settings_ScreenChecksValid()
							GuiControl, +cWhite, % cHWND
							GuiControl, movedraw, % cHWND
						}
						Else LLK_ToolTip(Lang_Trans("global_negative"),,,,, "red")
					Case "c":
						pClipboard := Screenchecks_ImageRecalibrate("", control)
						If (pClipboard <= 0)
							Return
						Else
						{
							Gdip_SaveBitmapToFile(pClipboard, "img\Recognition (" vars.client.h "p)\GUI\" control . vars.poe_version ".bmp", 100), Gdip_DisposeImage(pClipboard)
							For key in vars.imagesearch[control]
							{
								If (SubStr(key, 1, 1) = "x" || SubStr(key, 1, 1) = "y") && IsNumber(SubStr(key, 2, 1))
									vars.imagesearch[control][key] := ""
							}
							IniWrite, % "", % "ini" vars.poe_version "\screen checks ("vars.client.h "p).ini", % control, last coordinates
							Settings_ScreenChecksValid()
							GuiControl, +cWhite, % vars.hwnd.settings["cImage_"control]
							GuiControl, movedraw, % vars.hwnd.settings["cImage_"control]
							GuiControl, +cRed, % vars.hwnd.settings["tImage_"control]
							GuiControl, movedraw, % vars.hwnd.settings["tImage_"control]
						}
				}
			}
			Else If InStr(check, "info_")
				Screenchecks_Info(control)
			Else LLK_ToolTip("no action")
	}
}

Settings_ScreenChecksValid()
{
	local
	global vars, settings

	valid := 1
	For key, val in vars.pixelsearch.list
		If vars.poe_version && (key = "gamescreen")
			Continue
		Else valid *= vars.pixelsearch[key].color1 ? 1 : 0

	For key, val in vars.imagesearch.list
	{
		If (key = "skilltree" && !settings.features.leveltracker) || (key = "stash" && (vars.poe_version || !settings.features.maptracker || !settings.maptracker.loot))
		|| (key = "atlas") && !settings.features.statlas || (key = "betrayal") && !settings.features[key]
			Continue
		valid *= FileExist("img\Recognition ("vars.client.h "p)\GUI\" key . vars.poe_version ".bmp") && !Blank(vars.imagesearch[key].x1) ? 1 : 0
	}

	If valid
		GuiControl, % vars.hwnd.settings.main ": +cWhite", % vars.hwnd.settings["screen-checks"]
	Else GuiControl, % vars.hwnd.settings.main ": +cRed", % vars.hwnd.settings["screen-checks"]
	GuiControl, % vars.hwnd.settings.main ": movedraw", % vars.hwnd.settings["screen-checks"]
}

Settings_searchstrings()
{
	local
	global vars, settings

	GUI := "settings_menu" vars.settings.GUI_toggle
	Gui, %GUI%: Add, Link, % "Section x" vars.settings.x_anchor " y" vars.settings.ySelection, <a href="https://github.com/Lailloken/Lailloken-UI/wiki/Search-strings">wiki page</a>
	Gui, %GUI%: Add, Link, % "ys HWNDhwnd x+"2*settings.general.fWidth, <a href="https://poe.re/">poe regex</a>
	vars.hwnd.help_tooltips["settings_searchstrings poe-regex"] := hwnd

	For string, val in vars.searchstrings.list
	{
		If (A_Index = 1)
		{
			Gui, %GUI%: Font, bold underline
			Gui, %GUI%: Add, Text, % "xs Section BackgroundTrans y+"vars.settings.spacing, % Lang_Trans("m_search_usecases")
			Gui, %GUI%: Add, Pic, % "ys hp w-1 BackgroundTrans HWNDhwnd69", % "HBitmap:*" vars.pics.global.help
			Gui, %GUI%: Font, norm
		}
		vars.hwnd.help_tooltips["settings_searchstrings about" vars.poe_version] := hwnd69, var := vars.searchstrings.list[string] ;short-cut variable

		color := !var.enable ? "Gray" : !FileExist("img\Recognition ("vars.client.h "p)\GUI\[search-strings" vars.poe_version "] " string ".bmp") ? "Red" : "White", style := !var.enable ? "" : " gSettings_searchstrings2"
		Gui, %GUI%: Add, Text, % "Section xs Border HWNDhwnd c"color style, % " " Lang_Trans("global_calibrate") " "
		vars.hwnd.settings["cal_"string] := vars.hwnd.help_tooltips["settings_searchstrings calibrate"handle] := hwnd

		color := !var.enable ? "Gray" : !var.x1 ? "Red" : "White"
		Gui, %GUI%: Add, Text, % "ys Border HWNDhwnd x+"settings.general.fWidth/4 " c"color style, % " " Lang_Trans("global_test") " "
		vars.hwnd.settings["test_"string] := vars.hwnd.help_tooltips["settings_searchstrings test"handle] := hwnd

		Gui, %GUI%: Add, Text, % "ys Border cWhite gSettings_searchstrings2 HWNDhwnd x+"settings.general.fWidth/4, % " " Lang_Trans("global_edit") " "
		vars.hwnd.settings["edit_"string] := vars.hwnd.help_tooltips["settings_searchstrings edit"handle] := hwnd

		Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans HWNDhwnd0 x+"settings.general.fWidth/4 " c"(string = "beast crafting" ? "Gray" : "White") (string = "beast crafting" ? "" : " gSettings_searchstrings2")
			, % " " Lang_Trans("global_delete", 2) " "
		Gui, %GUI%: Add, Progress, % "xp yp wp hp BackgroundBlack Disabled cRed range0-500 HWNDhwnd", 0
		vars.hwnd.settings["del_"string] := hwnd0, vars.hwnd.settings["delbar_"string] := vars.hwnd.help_tooltips["settings_searchstrings delete"handle] := hwnd

		Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans gSettings_searchstrings2 HWNDhwnd x+"settings.general.fWidth/4, % " " Lang_Trans("global_copy") " "
		vars.hwnd.settings["copy_" string] := vars.hwnd.help_tooltips["settings_searchstrings copy" handle] := hwnd

		color := !var.enable ? "Gray" : "White"
		Gui, %GUI%: Add, Checkbox, % "ys x+"settings.general.fWidth " c"color " gSettings_searchstrings2 HWNDhwnd Checked"vars.searchstrings.list[string].enable
			, % (vars.lang["m_search_" string] || vars.lang2["m_search_" string]) ? Lang_Trans("m_search_" string) : string
		vars.hwnd.settings["enable_"string] := vars.hwnd.help_tooltips["settings_searchstrings enable" (string = "hideout lilly" ? "-lilly" : (string = "beast crafting" ? "-beastcrafting" : "")) handle] := hwnd, handle .= "|"
	}

	Gui, %GUI%: Add, Text, % "Section xs HWNDhwnd0 y+"vars.settings.spacing, % Lang_Trans("m_search_add")
	Gui, %GUI%: Add, Button, % "xp yp wp hp Hidden default HWNDhwnd gSettings_searchstrings2", ok
	vars.hwnd.help_tooltips["settings_searchstrings add"] := hwnd0, vars.hwnd.settings.add := hwnd
	Gui, %GUI%: Font, % "s"settings.general.fSize - 4
	Gui, %GUI%: Add, Edit, % "ys cBlack x+" settings.general.fWidth/2 " hp HWNDhwnd w"settings.general.fWidth*20
	If !vars.searchstrings.list.Count()
	{
		Gui, %GUI%: Add, Pic, % "ys hp w-1 BackgroundTrans HWNDhwnd69", % "HBitmap:*" vars.pics.global.help
		vars.hwnd.help_tooltips["settings_searchstrings about" vars.poe_version] := hwnd69
	}
	vars.hwnd.settings.name := vars.hwnd.help_tooltips["settings_searchstrings add|"] := hwnd
	Gui, %GUI%: Font, % "s"settings.general.fSize
	GuiControl, % "+c" (!vars.searchstrings.enabled ? "Gray" : "White"), % vars.hwnd.settings["search-strings"]
	GuiControl, % "movedraw", % vars.hwnd.settings["search-strings"]
}

Settings_searchstrings2(cHWND)
{
	local
	global vars, settings

	check := LLK_HasVal(vars.hwnd.settings, cHWND), control := SubStr(check, InStr(check, "_") + 1)
	If InStr(check, "cal_")
	{
		pBitmap := Screenchecks_ImageRecalibrate()
		If (pBitmap > 0)
		{
			Gdip_SaveBitmapToFile(pBitmap, "img\Recognition (" vars.client.h "p)\GUI\[search-strings" vars.poe_version "] " control ".bmp", 100)
			Gdip_DisposeImage(pBitmap)
			IniDelete, % "ini" vars.poe_version "\search-strings.ini", % control, last coordinates
			Settings_menu("search-strings")
		}
	}
	Else If InStr(check, "test_")
	{
		If String_Search(control)
		{
			GuiControl, +cWhite, % vars.hwnd.settings["test_"control]
			GuiControl, movedraw, % vars.hwnd.settings["test_"control]
			Init_searchstrings()
		}
	}
	Else If InStr(check, "edit_")
		String_Menu(control)
	Else If InStr(check, "del_")
	{
		If LLK_Progress(vars.hwnd.settings["delbar_"control], "LButton")
		{
			IniDelete, % "ini" vars.poe_version "\search-strings.ini", searches, % control
			IniDelete, % "ini" vars.poe_version "\search-strings.ini", % control
			Settings_menu("search-strings")
		}
		Else Return
	}
	Else If InStr(check, "enable_")
	{
		IniWrite, % LLK_ControlGet(cHWND), % "ini" vars.poe_version "\search-strings.ini", searches, % control
		Settings_menu("search-strings")
	}
	Else If (check = "add") || InStr(check, "copy_")
	{
		KeyWait, LButton
		name := LLK_ControlGet(vars.hwnd.settings.name)
		WinGetPos, x, y, w, h, % "ahk_id "vars.hwnd.settings.name
		While (SubStr(name, 1, 1) = " ")
			name := SubStr(name, 2)
		While (SubStr(name, 0) = " ")
			name := SubStr(name, 1, -1)
		If (name = "searches" || name = "exile-leveling")
			error := ["invalid name", 1]
		If vars.searchstrings.list.HasKey(name)
			error := ["name already in use", 1.5]
		Loop, Parse, name
			If !LLK_IsType(A_LoopField, "alnum")
				error := ["regular letters, spaces,`nand numbers only", 2]
		If (name = "")
			error := ["name cannot be blank", 1.5]
		If error.1
		{
			LLK_ToolTip(error.1, error.2, x, y + h,, "red")
			Return
		}

		If InStr(check, "copy_")
		{
			read := LLK_IniRead("ini" vars.poe_version "\search-strings.ini", control)
			write := "last coordinates="
			Loop, parse, read, `n, % " `r"
				If !InStr(A_LoopField, "last coordinates")
					write .= "`n" A_LoopField
			IniWrite, % write, % "ini" vars.poe_version "\search-strings.ini", % name
		}
		Else IniWrite, % "", % "ini" vars.poe_version "\search-strings.ini", % name, last coordinates

		IniWrite, 1, % "ini" vars.poe_version "\search-strings.ini", searches, % name
		Settings_menu("search-strings")
	}
	Else LLK_ToolTip("no action")
}

Settings_stash()
{
	local
	global vars, settings

	GUI := "settings_menu" vars.settings.GUI_toggle, x_anchor := vars.settings.x_anchor
	Gui, %GUI%: Add, Link, % "Section x" x_anchor " y" vars.settings.ySelection, <a href="https://github.com/Lailloken/Lailloken-UI/wiki/Stash‐Ninja">wiki page</a>

	Gui, %GUI%: Add, Checkbox, % "xs Section HWNDhwnd gSettings_stash2 y+" vars.settings.spacing " Checked" settings.features.stash, % Lang_Trans("m_stash_enable")
	vars.hwnd.settings.enable := vars.hwnd.help_tooltips["settings_stash enable"] := hwnd

	If !settings.features.stash
		Return

	Gui, %GUI%: Font, underline bold
	Gui, %GUI%: Add, Text, % "xs Section y+" vars.settings.spacing, % Lang_Trans("global_general")
	Gui, %GUI%: Add, Button, % "xp yp wp hp Hidden Default HWNDhwnd gSettings_stash2", OK
	Gui, %GUI%: Font, norm
	Gui, %GUI%: Add, Text, % "xs Section", % Lang_Trans("m_stash_leagues")
	leagues := settings.stash.leagues, vars.hwnd.settings.apply_button := hwnd
	For index, array in leagues
	{
		Gui, %GUI%: Add, Text, % (!InStr(array.1, leagues[index - 1].1) ? "xs Section" : "ys x+" settings.general.fWidth//2) " HWNDhwnd Border Center gSettings_stash2" (index = 1 ? " Section" : "") . (array.2 = settings.stash.league ? " cLime" : ""), % " " array.1 " "
		vars.hwnd.settings["league_" array.2] := hwnd
	}

	If vars.client.stream
	{
		Gui, %GUI%: Add, Text, % "xs Section x" x_anchor, % Lang_Trans("global_hotkey")
		Gui, %GUI%: Font, % "s" settings.general.fSize - 4
		Gui, %GUI%: Add, Edit, % "ys HWNDhwnd Limit cBlack r1 gSettings_stash2 w" settings.general.fWidth * 8, % settings.stash.hotkey
		Gui, %GUI%: Font, % "s" settings.general.fSize
		vars.hwnd.settings.hotkey := vars.hwnd.help_tooltips["settings_stash hotkey"] := hwnd
	}

	Gui, %GUI%: Add, Checkbox, % "xs x" x_anchor " Section HWNDhwnd gSettings_stash2 Checked" settings.stash.history, % Lang_Trans("m_stash_history")
	Gui, %GUI%: Add, Checkbox, % "ys HWNDhwnd1 gSettings_stash2 Checked" settings.stash.show_exalt, % Lang_Trans("m_stash_exalt")
	Gui, %GUI%: Add, Checkbox, % "xs Section HWNDhwnd4 gSettings_stash2 Checked" settings.stash.bulk_trade, % Lang_Trans("m_stash_bulk")
	If settings.stash.bulk_trade
	{
		Gui, %GUI%: Add, Text, % "xs+" settings.general.fWidth * 3 " Section HWNDhwnd3", % Lang_Trans("m_stash_mintrade")
		Gui, %GUI%: Font, % "s" settings.general.fSize - 4
		Gui, %GUI%: Add, Edit, % "ys cBlack Number HWNDhwnd2 gSettings_stash2 Limit hp Right w" settings.general.fWidth * 3, % settings.stash.min_trade
		Gui, %GUI%: Font, % "s" settings.general.fSize
		Gui, %GUI%: Add, Checkbox, % "xs Section HWNDhwnd00 gSettings_stash2 Checked" settings.stash.autoprofiles, % Lang_Trans("m_stash_profiles")
		vars.hwnd.settings.min_trade := hwnd2, vars.hwnd.help_tooltips["settings_stash mintrade"] := hwnd2, vars.hwnd.help_tooltips["settings_stash mintrade|"] := hwnd3
		vars.hwnd.settings.autoprofiles := vars.hwnd.help_tooltips["settings_stash autoprofiles"] := hwnd00
	}
	vars.hwnd.settings.history := vars.hwnd.help_tooltips["settings_stash history"] := hwnd, vars.hwnd.settings.exalt := vars.hwnd.help_tooltips["settings_stash exalt"] := hwnd1
	vars.hwnd.settings.bulk_trade := vars.hwnd.help_tooltips["settings_stash bulk"] := hwnd4

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "xs Section y+" vars.settings.spacing " x" x_anchor, % Lang_Trans("global_ui")
	Gui, %GUI%: Font, norm

	Gui, %GUI%: Add, Text, % "xs Section", % Lang_Trans("stash_pricetags")
	colors := settings.stash.colors.Clone()
	Loop 3
	{
		color1 := colors[A_Index * 2 - 1], color2 := colors[A_Index * 2]
		Gui, %GUI%: Add, Text, % "ys Border Center HWNDhwndtext BackgroundTrans c" color1, % " 69.42 "
		Gui, %GUI%: Add, Progress, % "xp yp wp hp Border BackgroundBlack HWNDhwndback c" color2, 100
		Gui, %GUI%: Add, Text, % "ys x+-1 Border BackgroundTrans gSettings_stash2 HWNDhwnd00", % "  "
		Gui, %GUI%: Add, Progress, % "xp yp wp hp Border BackgroundBlack HWNDhwnd01 c" color1, 100
		Gui, %GUI%: Add, Text, % "ys x+-1 Border BackgroundTrans gSettings_stash2 HWNDhwnd10", % "  "
		Gui, %GUI%: Add, Progress, % "xp yp wp hp Border BackgroundBlack HWNDhwnd11 c" color2, 100
		vars.hwnd.settings["color_" A_Index * 2 - 1] := hwnd00, vars.hwnd.settings["color_" A_Index * 2 - 1 "_panel"] := hwnd01, vars.hwnd.settings["color_" A_Index * 2 - 1 "_text"] := hwndtext
		vars.hwnd.settings["color_" A_Index * 2] := hwnd10, vars.hwnd.settings["color_" A_Index * 2 "_panel"] := hwnd11, vars.hwnd.settings["color_" A_Index * 2 "_text"] := hwndback
		vars.hwnd.help_tooltips["settings_generic color double" handle] := hwnd01, vars.hwnd.help_tooltips["settings_generic color double1" handle] := hwnd11
		vars.hwnd.help_tooltips["settings_stash color tag" A_Index] := hwndback, handle .= "|"
	}


	Gui, %GUI%: Add, Text, % "xs Section", % Lang_Trans("global_font")
	Gui, %GUI%: Add, Text, % "ys x+" settings.general.fWidth/2 " Center Border gSettings_stash2 HWNDhwnd w"settings.general.fWidth*2, % "–"
	vars.hwnd.help_tooltips["settings_font-size"] := hwnd0, vars.hwnd.settings.font_minus := vars.hwnd.help_tooltips["settings_font-size|"] := hwnd
	Gui, %GUI%: Add, Text, % "ys x+"settings.general.fWidth/4 " Center Border gSettings_stash2 HWNDhwnd w"settings.general.fWidth*3, % settings.stash.fSize
	vars.hwnd.settings.font_reset := vars.hwnd.help_tooltips["settings_font-size||"] := hwnd
	Gui, %GUI%: Add, Text, % "ys x+"settings.general.fWidth/4 " Center Border gSettings_stash2 HWNDhwnd w"settings.general.fWidth*2, % "+"
	vars.hwnd.settings.font_plus := vars.hwnd.help_tooltips["settings_font-size|||"] := hwnd

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "xs Section y+" vars.settings.spacing, % Lang_Trans("m_stash_tabs")
	Gui, %GUI%: Font, norm
	Gui, %GUI%: Add, Pic, % "ys BackgroundTrans HWNDhwnd hp w-1", % "HBitmap:*" vars.pics.global.help

	vars.hwnd.help_tooltips["settings_stash config"] := hwnd
	If WinExist("ahk_id " vars.hwnd.stash.main) && vars.stash.active
		vars.settings.selected_tab := vars.stash.active
	Gui, %GUI%: Add, Text, % "xs Section HWNDhwnd2", % Lang_Trans("m_stash_active")
	Gui, %GUI%: Add, Text, % "ys Center Left c" (vars.settings.selected_tab ? "Lime" : "Red"), % (vars.settings.selected_tab ? Lang_Trans("m_stash_" vars.settings.selected_tab) : Lang_Trans("global_none"))
	If !vars.settings.selected_tab
		Return

	Gui, %GUI%: Add, Text, % "ys HWNDhwnd2", % "    " Lang_Trans("global_gap") ":"
	Gui, %GUI%: Add, Text, % "ys HWNDhwnd3 gSettings_stash2 Center Border w" settings.general.fWidth * 2, % "–"
	Gui, %GUI%: Add, Text, % "ys HWNDhwnd4 gSettings_stash2 Center Border wp x+" settings.general.fWidth//2, % "+"
	Gui, %GUI%: Add, Checkbox, % "xs Section HWNDhwnd5 gSettings_stash2 Checked" settings.stash[vars.stash.active].in_folder, % Lang_Trans("m_stash_folder")
	Gui, %GUI%: Add, Checkbox, % "xs Section HWNDhwnd6 gSettings_stash2 Checked" settings.stash[vars.stash.active].bookmarking, % Lang_Trans("m_stash_bookmarking")
	vars.hwnd.settings.test := vars.hwnd.help_tooltips["settings_stash test"] := hwnd1, tab := vars.settings.selected_tab
	vars.hwnd.settings["gap-_" tab] := hwnd3, vars.hwnd.settings["gap+_" tab] vars.hwnd.help_tooltips["settings_stash gap"] := hwnd2
	vars.hwnd.settings["gap+_" tab] := hwnd4, vars.hwnd.settings["infolder_" tab] := vars.hwnd.help_tooltips["settings_stash in folder"] := hwnd5
	vars.hwnd.settings["bookmarking_" tab] := vars.hwnd.help_tooltips["settings_stash bookmarking"] := hwnd6

	Gui, %GUI%: Add, Text, % "xs Section", % Lang_Trans("m_stash_limits")
	Gui, %GUI%: Add, Pic, % "ys HWNDhwnd hp w-1", % "HBitmap:*" vars.pics.global.help
	Gui, %GUI%: Font, % "s" settings.general.fSize - 4 " cBlack"
	vars.hwnd.help_tooltips["settings_stash limits"] := hwnd, currencies := ["c", "e", "d", "%"]
	Loop 5
	{
		style := (A_Index != 5) && settings.stash.bulk_trade && settings.stash.min_trade && settings.stash.autoprofiles ? " Disabled" : ""
		If style
			Gui, %GUI%: Add, Edit, % (A_Index = 1 ? "xs" : "ys x+" settings.general.fWidth/2) " Section Border Center w" settings.stash.fWidth * 2 " h" settings.stash.fHeight . style, % A_Index
		Else
		{
			Gui, %GUI%: Add, Text, % (A_Index = 1 ? "xs" : "ys x+" settings.general.fWidth/2) " Section cWhite 0x200 Border Center w" settings.stash.fWidth * 2 " h" settings.stash.fHeight, % A_Index
			;Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp BackgroundWhite", 0
		}
		Gui, %GUI%: Add, Edit, % "xs y+-1 Center HWNDhwnd2 gSettings_stash2 Limit1 wp hp" style, % currencies[settings.stash[tab].limits[A_Index].3]
		Gui, %GUI%: Add, Edit, % "ys Section x+-1 Center HWNDhwnd gSettings_stash2 Limit w" settings.general.fWidth * 4 " hp" style, % settings.stash[tab].limits[A_Index].2
		Gui, %GUI%: Add, Edit, % "xs y+-1 Center HWNDhwnd1 Limit gSettings_stash2 wp hp" style, % settings.stash[tab].limits[A_Index].1

		vars.hwnd.settings["limits" A_Index "top_" tab] := hwnd, vars.hwnd.settings["limits" A_Index "bot_" tab] := hwnd1, vars.hwnd.settings["limits" A_Index "cur_" tab] := hwnd2
	}
}

Settings_stash2(cHWND)
{
	local
	global vars, settings
	static in_progress

	If in_progress
		Return
	check := LLK_HasVal(vars.hwnd.settings, cHWND), control := SubStr(check, InStr(check, "_") + 1), in_progress := 1
	If !InStr(check, "test") && !InStr(check, "font_")
		KeyWait, LButton

	If (check = "enable")
	{
		IniWrite, % (settings.features.stash := LLK_ControlGet(cHWND)), ini\config.ini, features, enable stash-ninja
		If !settings.features.stash
			Stash_Close()
		Settings_menu("stash-ninja")
	}
	Else If (check = "hotkey")
	{
		GuiControl, +cRed, % cHWND
		GuiControl, movedraw, % cHWND
	}
	Else If (check = "apply_button")
	{
		ControlGetFocus, hwnd, % "ahk_id " vars.hwnd.settings.main
		ControlGet, hwnd, HWND,, % hwnd
		If !InStr(vars.hwnd.settings.hotkey "," vars.hwnd.settings.min_trade, hwnd)
		{
			in_progress := 0
			Return
		}
		If (hwnd = vars.hwnd.settings.min_trade)
		{
			input := LLK_ControlGet(vars.hwnd.settings.min_trade)
			IniWrite, % (settings.stash.min_trade := !input ? "" : input), ini\stash-ninja.ini, settings, minimum trade value
			Init_stash("bulk_trade"), Settings_menu("stash-ninja"), in_progress := 0
			Return
		}
		Else If (hwnd = vars.hwnd.settings.hotkey)
		{
			If (StrLen(input0 := LLK_ControlGet(vars.hwnd.settings.hotkey)) > 1)
				Loop, Parse, % "^!#+"
					input := (A_Index = 1) ? input0 : input, input := StrReplace(input, A_LoopField)
			If !GetKeyVK(input)
			{
				WinGetPos, x, y, w, h, % "ahk_id " vars.hwnd.settings.hotkey
				LLK_ToolTip(Lang_Trans("m_hotkeys_error"), 1.5, x + w - 1, y,, "Red")
			}
			Else
			{
				Hotkey, IfWinActive, ahk_group poe_window
				Hotkey, % "~" Hotkeys_Convert(settings.stash.hotkey), Stash_Selection, Off
				Hotkey, % "~" Hotkeys_Convert(settings.stash.hotkey := input0), Stash_Selection, On
				IniWrite, % """" input0 """", ini\stash-ninja.ini, settings, hotkey
				GuiControl, +cBlack, % vars.hwnd.settings.hotkey
				GuiControl, movedraw, % vars.hwnd.settings.hotkey
			}
			in_progress := 0
			Return
		}
	}
	Else If InStr(check, "enable_")
	{
		IniWrite, % (settings.stash[control].enable := LLK_ControlGet(cHWND)), ini\stash-ninja.ini, % control, enable
		Settings_menu("stash-ninja")
	}
	Else If InStr(check, "league_")
	{
		GuiControl, +cWhite, % vars.hwnd.settings["league_" settings.stash.league]
		GuiControl, movedraw, % vars.hwnd.settings["league_" settings.stash.league]
		IniWrite, % (settings.stash.league := control), ini\stash-ninja.ini, settings, league
		GuiControl, +cLime, % cHWND
		GuiControl, movedraw, % cHWND
		Stash_PriceFetch("flush")
	}
	Else If (check = "history")
		IniWrite, % (settings.stash.history := LLK_ControlGet(cHWND)), ini\stash-ninja.ini, settings, enable price history
	Else If (check = "exalt")
		IniWrite, % (settings.stash.show_exalt := LLK_ControlGet(cHWND)), ini\stash-ninja.ini, settings, show exalt conversion
	Else If (check = "bulk_trade")
	{
		IniWrite, % (settings.stash.bulk_trade := LLK_ControlGet(cHWND)), ini\stash-ninja.ini, settings, show bulk-sale suggestions
		If !settings.stash.bulk_trade && WinExist("ahk_id " vars.hwnd.stash_picker.main)
			Stash_PricePicker("destroy"), vars.stash.enter := 0
		Init_stash("bulk_trade"), Settings_menu("stash-ninja")
	}
	Else If (check = "min_trade")
	{
		GuiControl, +cRed, % cHWND
		GuiControl, movedraw, % cHWND
	}
	Else If (check = "autoprofiles")
	{
		IniWrite, % (settings.stash.autoprofiles := LLK_ControlGet(cHWND)), ini\stash-ninja.ini, settings, enable trade-value profiles
		Init_stash("bulk_trade"), Settings_menu("stash-ninja")
	}
	Else If InStr(check, "font_")
	{
		If (control = "minus") && (settings.stash.fSize <= 6)
		{
			in_progress := 0
			Return
		}
		While GetKeyState("LButton", "P") ;&& !InStr(check, "reset")
		{
			If (control = "reset")
				settings.stash.fSize := settings.general.fSize
			Else settings.stash.fSize += (control = "minus" && settings.stash.fSize > 6) ? -1 : (control = "plus" ? 1 : 0)
			GuiControl, Text, % vars.hwnd.settings.font_reset, % settings.stash.fSize
			Sleep 150
		}
		IniWrite, % settings.stash.fSize, ini\stash-ninja.ini, settings, font-size
		Init_stash("font")
	}
	Else If InStr(check, "color_")
	{
		color := (vars.system.click = 1) ? RGB_Picker(settings.stash.colors[control]) : (InStr("135", control) ? "000000" : (control = 2) ? "00FF00" : (control = 4) ? "FF8000" : "00FFFF")
		If Blank(color)
		{
			in_progress := 0
			Return
		}
		GuiControl, % "+c" color, % vars.hwnd.settings["color_" control "_panel"]
		GuiControl, % "+c" color, % vars.hwnd.settings["color_" control "_text"]
		GuiControl, % "movedraw", % vars.hwnd.settings["color_" control "_text"]
		IniWrite, % (settings.stash.colors[control] := color), ini\stash-ninja.ini, UI, % (InStr("135", control) ? "text" : "background") " color" (control > 2 ? Ceil(control/2) : "")
	}
	Else If InStr(check, "gap")
	{
		If InStr(check, "-") && (settings.stash[control].gap = 0)
		{
			in_progress := 0
			Return
		}
		settings.stash[control].gap += InStr(check, "-") ? -1 : 1
		IniWrite, % settings.stash[control].gap, ini\stash-ninja.ini, % control, gap
		Init_stash("gap")
	}
	Else If InStr(check, "infolder_")
	{
		groups := [["fragments", "scarabs", "breach"], ["currency1", "currency2"], ["delve"], ["blight"], ["delirium"], ["essences"], ["ultimatum"]], gCheck := LLK_HasVal(groups, control,,,, 1)
		For index, tab in groups[gCheck]
			IniWrite, % (settings.stash[tab].in_folder := LLK_ControlGet(cHWND)), ini\stash-ninja.ini, % tab, tab is in folder
		Init_stash(1)
	}
	Else If InStr(check, "bookmarking")
		IniWrite, % (settings.stash[vars.stash.active].bookmarking := LLK_ControlGet(cHWND)), ini\stash-ninja.ini, % vars.stash.active, bookmarking
	Else If InStr(check, "limits")
	{
		types := {"bot": 1, "top": 2, "cur": 3}
		input := StrReplace(LLK_ControlGet(cHWND), ",", "."), lIndex := SubStr(check, 7, 1), lType := types[SubStr(check, 8, 3)], tab := control, currencies := ["c", "e", "d", "%"]
		If (SubStr(input, 1, 1) = "." || SubStr(input, 0) = ".") || InStr(input, "+")
			input := "invalid"
		If Blank(input)
			settings.stash[tab].limits0[lIndex][lType] := settings.stash[tab].limits[lIndex][lType] := "", input := "null"
		Else
		{
			lTop := settings.stash[tab].limits[lIndex].2, lBot := settings.stash[tab].limits[lIndex].1
			If (lType < 3) && !IsNumber(input) || (lType = 1 && !Blank(lTop) && input > lTop) || (lType = 2 && !Blank(lBot) && input < lBot)
			|| (lType = 3) && !InStr("ced%", input)
				valid := 0
			Else valid := 1
			GuiControl, % "+c" (!valid ? "Red" : "Black"), % cHWND
			GuiControl, movedraw, % cHWND
			If !valid
			{
				in_progress := 0
				Return
			}
			If (lType = 3)
				input := InStr("ced%", input)
			settings.stash[tab].limits0[lIndex][lType] := settings.stash[tab].limits[lIndex][lType] := input
			While InStr(settings.stash[tab].limits[lIndex][lType], ".") && InStr(".0", SubStr(settings.stash[tab].limits[lIndex][lType], 0))
				input := settings.stash[tab].limits0[lIndex][lType] := settings.stash[tab].limits[lIndex][lType] := SubStr(settings.stash[tab].limits[lIndex][lType], 1, -1)
		}
		IniWrite, % input, ini\stash-ninja.ini, % tab, % "limit " lIndex " " SubStr(check, 8, 3)
	}
	Else If InStr(check, "test")
		Stash(vars.settings.selected_stash, 1)
	Else LLK_ToolTip("no action")

	For index, val in ["limits", "gap", "color_", "font_", "league_", "history", "folder", "bookmarking_"]
		If InStr(check, val) && WinExist("ahk_id " vars.hwnd.stash.main)
			Stash("refresh", (val = "gap") ? 1 : 0)
	in_progress := 0
}

Settings_statlas()
{
	local
	global vars, settings

	GUI := "settings_menu" vars.settings.GUI_toggle, x_anchor := vars.settings.x_anchor
	Gui, %GUI%: Add, Link, % "Section x" x_anchor " y" vars.settings.ySelection, <a href="https://github.com/Lailloken/Lailloken-UI/wiki/Statlas">wiki page</a>

	Gui, %GUI%: Add, Checkbox, % "Section xs HWNDhwnd gSettings_statlas2 y+" vars.settings.spacing " Checked" settings.features.statlas, % Lang_Trans("m_statlas_enable")
	vars.hwnd.settings.enable := vars.hwnd.help_tooltips["settings_statlas enable"] := hwnd

	If !settings.features.statlas
		Return

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "Section xs Center y+"vars.settings.spacing, % Lang_Trans("global_general")
	Gui, %GUI%: Font, norm

	Gui, %GUI%: Add, Checkbox, % "Section xs HWNDhwnd gSettings_statlas2 Checked" settings.statlas.maptracker, % Lang_Trans("m_statlas_maptracker")
	vars.hwnd.settings.maptracker := vars.hwnd.help_tooltips["settings_statlas maptracker"] := hwnd
	Gui, %GUI%: Add, Checkbox, % "Section xs HWNDhwnd gSettings_statlas2 Checked" settings.statlas.notable, % Lang_Trans("m_statlas_localknowledge")
	vars.hwnd.settings.notable := vars.hwnd.help_tooltips["settings_statlas notable"] := hwnd

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "xs Section y+" vars.settings.spacing " x" x_anchor, % Lang_Trans("global_ui")
	Gui, %GUI%: Font, norm

	Gui, %GUI%: Add, Text, % "xs Section HWNDhwnd0", % Lang_Trans("global_font")
	Gui, %GUI%: Add, Text, % "ys x+" settings.general.fWidth/2 " Center Border gSettings_statlas2 HWNDhwnd w"settings.general.fWidth*2, % "–"
	vars.hwnd.help_tooltips["settings_font-size"] := hwnd0, vars.hwnd.settings.font_minus := vars.hwnd.help_tooltips["settings_font-size|"] := hwnd
	Gui, %GUI%: Add, Text, % "ys x+"settings.general.fWidth/4 " Center Border gSettings_statlas2 HWNDhwnd w"settings.general.fWidth*3, % settings.statlas.fSize
	vars.hwnd.settings.font_reset := vars.hwnd.help_tooltips["settings_font-size||"] := hwnd
	Gui, %GUI%: Add, Text, % "ys x+"settings.general.fWidth/4 " Center Border gSettings_statlas2 HWNDhwnd w"settings.general.fWidth*2, % "+"
	vars.hwnd.settings.font_plus := vars.hwnd.help_tooltips["settings_font-size|||"] := hwnd
}

Settings_statlas2(cHWND)
{
	local
	global vars, settings

	check := LLK_HasVal(vars.hwnd.settings, cHWND), control := SubStr(check, InStr(check, "_") + 1)
	If (check = "enable")
	{
		IniWrite, % (settings.features.statlas := LLK_ControlGet(cHWND)), % "ini" vars.poe_version "\config.ini", features, enable statlas
		Settings_menu("statlas")
	}
	Else If (check = "maptracker")
		IniWrite, % (settings.statlas.maptracker := LLK_ControlGet(cHWND)), % "ini" vars.poe_version "\statlas.ini", settings, include map-tracker data
	Else If (check = "notable")
		IniWrite, % (settings.statlas.notable := LLK_ControlGet(cHWND)), % "ini" vars.poe_version "\statlas.ini", settings, show atlas-notable effect
	Else If InStr(check, "font_")
	{
		While GetKeyState("LButton", "P")
		{
			If (control = "reset")
				settings.statlas.fSize := settings.general.fSize
			Else settings.statlas.fSize += (control = "minus") ? -1 : 1, settings.statlas.fSize := (settings.statlas.fSize < 6) ? 6 : settings.statlas.fSize
			GuiControl, text, % vars.hwnd.settings.font_reset, % settings.statlas.fSize
			Sleep 150
		}
		IniWrite, % settings.statlas.fSize, % "ini" vars.poe_version "\statlas.ini", settings, font-size
		LLK_FontDimensions(settings.statlas.fSize, height, width), settings.statlas.fWidth := width, settings.statlas.fHeight := height
	}
	Else LLK_ToolTip("no action")
}

Settings_unsupported()
{
	local
	global vars, settings

	GUI := "settings_menu" vars.settings.GUI_toggle
	Gui, %GUI%: Font, norm
	Gui, %GUI%: Add, Text, % "xs Section y+"vars.settings.spacing, % "this feature is not available on clients`nwith an unsupported language.`n`nit will be available once a language-`npack for the current language has been`ninstalled.`n`nthese packs have to be created by the`ncommunity. to find out if there are any`nfor your language or how to`ncreate one, click the link below.`n"
	Gui, %GUI%: Font, norm
	Gui, %GUI%: Add, Link, % "Section xs", <a href="https://github.com/Lailloken/Lailloken-UI/discussions/categories/translations-localization">llk-ui discussions: translations</a>
}

Settings_updater()
{
	local
	global vars, settings

	GUI := "settings_menu" vars.settings.GUI_toggle
	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "Section x" vars.settings.x_anchor " y" vars.settings.ySelection, % Lang_Trans("global_general")
	Gui, %GUI%: Font, norm

	Gui, %GUI%: Add, Checkbox, % "Section xs HWNDhwnd gSettings_updater2 checked"settings.updater.update_check, % Lang_Trans("m_updater_autocheck")
	Gui, %GUI%: Add, Text, % "ys", % "        " ;to make the window a bit wider and improve changelog tooltips
	WinGetPos,,, wCheckbox, hCheckbox, ahk_id %hwnd%
	vars.hwnd.settings.update_check := vars.hwnd.help_tooltips["settings_update check"] := hwnd

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "Section xs y+"vars.settings.spacing, % Lang_Trans("m_updater_version")
	Gui, %GUI%: Font, norm
	Gui, %GUI%: Add, Pic, % "ys hp w-1 Center Border BackgroundTrans HWNDhwnd gSettings_updater2", % "HBitmap:*" vars.pics.global.reload
	vars.hwnd.settings.update_refresh := hwnd, LLK_PanelDimensions([Lang_Trans("m_updater_version", 2), Lang_Trans("m_updater_version", 3)], settings.general.fSize, width, height)

	Gui, %GUI%: Add, Text, % "Section xs w" width, % Lang_Trans("m_updater_version", 2)
	Gui, %GUI%: Add, Text, % "ys HWNDhwnd x+0", % vars.updater.version.2
	ControlGetPos, x,,,,, ahk_id %hwnd%
	color := vars.updater.skip && (vars.updater.latest.1 = vars.updater.skip) ? " cYellow" : (IsNumber(vars.updater.latest.1) && vars.updater.latest.1 > vars.updater.version.1) ? " cLime" : ""
	Gui, %GUI%: Add, Text, % "Section xs w" width . color, % Lang_Trans("m_updater_version", 3) " "
	Gui, %GUI%: Add, Text, % "ys x" x . color, % vars.updater.latest.2

	If InStr(vars.updater.latest.1, ".")
	{
		Gui, %GUI%: Add, Pic, % "ys hp w-1 HWNDhwnd", % "HBitmap:*" vars.pics.global.help
		vars.hwnd.help_tooltips["settings_update hotfix"] := hwnd
	}

	If !InStr(vars.updater.latest.1, ".") && IsNumber(vars.updater.latest.1) && (vars.updater.latest.1 > vars.updater.version.1) && (vars.updater.latest.1 != vars.updater.skip)
	{
		Gui, %GUI%: Add, Text, % "ys Border Center BackgroundTrans gSettings_updater2 HWNDhwnd", % " " Lang_Trans("m_updater_skip") " "
		Gui, %GUI%: Add, Progress, % "xp yp wp hp Disabled Border BackgroundBlack cRed range0-500 HWNDhwnd0", 0
		vars.hwnd.settings.skip := hwnd, vars.hwnd.settings.skip_bar := vars.hwnd.help_tooltips["settings_update skip"] := hwnd0
	}

	If IsNumber(vars.updater.latest.1) && IsObject(vars.updater.changelog)
	{
		Gui, %GUI%: Font, underline bold
		Gui, %GUI%: Add, Text, % "Section xs y+" vars.settings.spacing, % Lang_Trans("m_updater_versions")
		added := {}, selected := vars.updater.selected, selected_sub := SubStr(selected, InStr(selected, ".",, 0) + 1)
		Gui, %GUI%: Font, norm
		Gui, %GUI%: Add, Pic, % "ys hp w-1 HWNDhwnd", % "HBitmap:*" vars.pics.global.help
		vars.hwnd.help_tooltips["settings_update versions"] := hwnd

		For index, val in vars.updater.changelog
		{
			major := SubStr(val.1.1, 1, 5)
			If (val.1.2 < 15600)
				Continue
			If !added[major]
				Gui, %GUI%: Add, Text, % "Section xs", % major
			minor := SubStr(val.1.2, -1) + 0, color := (selected = major . minor) ? " cFuchsia" : val.1.3 ? " cFF8000" : ""
			Gui, %GUI%: Add, Text, % "ys Border HWNDhwnd gSettings_updater2 Center w" settings.general.fWidth * 2 . color . (!added[major] ? " x+0" : " x+" settings.general.fWidth/2), % minor
			vars.hwnd.settings["versionselect_" major . minor] := vars.hwnd.help_tooltips["settings_update changelog " major . minor] := hwnd, added[major] := 1
		}
	}

	If vars.updater.selected
	{
		Gui, %GUI%: Add, Text, % "Section xs Border Center BackgroundTrans gSettings_updater2 HWNDhwnd00", % " " Lang_Trans("m_updater_changelog") " "
		Gui, %GUI%: Add, Text, % "ys Border Center BackgroundTrans gSettings_updater2 HWNDhwnd cFuchsia", % " " Lang_Trans("global_restart") " "
		Gui, %GUI%: Add, Progress, % "xp yp wp hp Disabled Border BackgroundBlack cRed range0-500 HWNDhwnd0", 0
		ControlGetPos,,, wButton,,, ahk_id %hwnd%
		vars.hwnd.settings["fullchangelog_" vars.updater.selected] := vars.hwnd.help_tooltips["settings_update full changelog"] := hwnd00
		vars.hwnd.settings.restart_install := hwnd, vars.hwnd.settings.restart_bar := vars.hwnd.help_tooltips["settings_update restart"] := hwnd0
	}

	If IsNumber(vars.update.1) && (vars.update.1 < 0)
	{
		Gui, %GUI%: Font, bold underline
		Gui, %GUI%: Add, Text, % "Section xs cRed y+"vars.settings.spacing, % Lang_Trans("m_updater_failed")
		Gui, %GUI%: Font, norm

		If InStr("126", StrReplace(vars.update.1, "-"))
			Gui, %GUI%: Add, Text, % "Section xs w" wCheckbox, % Lang_Trans("m_updater_error1") "`n`n" Lang_Trans("m_updater_error1", 2)
		Else If (vars.update.1 = -4)
			Gui, %GUI%: Add, Text, % "Section xs w" wCheckbox, % Lang_Trans("m_updater_error2") " " Lang_Trans("m_updater_error2", 2) "`n`n" Lang_Trans("m_updater_error2", 3)
		Else If (vars.update.1 = -3)
			Gui, %GUI%: Add, Text, % "Section xs w" wCheckbox, % Lang_Trans("m_updater_error3")
		Else If InStr("5", StrReplace(vars.update.1, "-"))
			Gui, %GUI%: Add, Text, % "Section xs w" wCheckbox, % Lang_Trans("m_updater_error4") " " Lang_Trans("m_updater_error2", 2) "`n`n" Lang_Trans("m_updater_error2", 3)

		If InStr("35", StrReplace(vars.update.1, "-"))
		{
			Gui, %GUI%: Add, Text, % "Section xs Center Border BackgroundTrans HWNDmanual gSettings_updater2", % " " Lang_Trans("m_updater_manual") " "
			Gui, %GUI%: Add, Progress, % "xp yp wp hp Border HWNDbar range0-10 BackgroundBlack cGreen", 0
			Gui, %GUI%: Add, Text, % "ys Center Border HWNDgithub gSettings_updater2", % " " Lang_Trans("m_updater_manual", 2) " "
			vars.hwnd.settings.manual := manual, vars.hwnd.settings.manual_bar := vars.hwnd.help_tooltips["settings_update manual"] := bar, vars.hwnd.settings.github := vars.hwnd.help_tooltips["settings_update github"] := github
		}
	}

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "Section xs y+"vars.settings.spacing, % Lang_Trans("m_updater_github")
	Gui, %GUI%: Font, norm
	Gui, %GUI%: Add, Text, % "Section xs Center Border HWNDpage gSettings_updater2", % " " Lang_Trans("m_updater_github", 2) " "
	Gui, %GUI%: Add, Text, % "ys Center Border HWNDreleases gSettings_updater2", % " " Lang_Trans("m_updater_github", 3) " "
	vars.hwnd.settings["githubpage_"(InStr(LLK_FileRead("data\versions.json"), "main.zip") ? "main" : "beta")] := page, vars.hwnd.settings.releases_page := releases
}

Settings_updater2(cHWND := "")
{
	local
	global vars, settings, Json
	static in_progress, refresh_tick

	If in_progress
		Return
	check := LLK_HasVal(vars.hwnd.settings, cHWND), control := SubStr(check, InStr(check, "_") + 1)
	If InStr(check, "githubpage_")
		Run, % "https://github.com/Lailloken/Lailloken-UI/tree/"control
	Else If (check = "releases_page")
		Run, % "https://github.com/Lailloken/Lailloken-UI/releases"
	Else If (check = "update_check")
	{
		settings.updater.update_check := LLK_ControlGet(cHWND)
		IniWrite, % settings.updater.update_check, ini\config.ini, settings, update auto-check
	}
	Else If (check = "update_refresh")
	{
		If vars.updater.latest.2 && (A_TickCount < refresh_tick + 10000 && !settings.general.dev)
			Return
		in_progress := 1, UpdateCheck(1), in_progress := 0, refresh_tick := A_TickCount, Settings_menu("updater")
	}
	Else If InStr(check, "versionselect_")
	{
		vars.updater.selected := SubStr(check, InStr(check, "_") + 1)
		Settings_menu("updater")
	}
	Else If InStr(check, "fullchangelog_")
		Run, % "https://github.com/Lailloken/Lailloken-UI/releases/tag/v" control
	Else If (check = "restart_install")
	{
		If !settings.general.dev || LLK_Progress(vars.hwnd.settings.restart_bar, "LButton")
		{
			KeyWait, LButton
			IniWrite, % vars.updater.selected, ini\config.ini, versions, apply update
			Reload
			ExitApp
		}
	}
	Else If (check = "manual")
	{
		in_progress := 1, UpdateDownload(vars.hwnd.settings.manual_bar)
		UrlDownloadToFile, % "https://github.com/Lailloken/Lailloken-UI/archive/refs/tags/v" vars.update.2 ".zip", % "update\update_" vars.updater.target_version.2 ".zip"
		error := ErrorLevel || !FileExist("update\update_" vars.updater.target_version.2 ".zip") ? 1 : 0
		in_progress := 0
		SetTimer, UpdateDownload, Delete
		UpdateDownload("reset")
		If error
		{
			LLK_ToolTip(Lang_Trans("m_updater_download"), 3,,,, "red")
			Return
		}
		Run, explore %A_ScriptDir%
		Run, % "update\update_" vars.updater.target_version.2 ".zip"
		ExitApp
	}
	Else If (check = "github")
	{
		Run, % "https://github.com/Lailloken/Lailloken-UI/archive/refs/tags/v" vars.update.2 ".zip"
		Run, explore %A_ScriptDir%
		ExitApp
	}
	Else If (check = "skip")
	{
		If LLK_Progress(vars.hwnd.settings.skip_bar, "LButton")
		{
			KeyWait, LButton
			vars.updater.skip := vars.updater.latest.1, vars.update := [0]
			IniWrite, % vars.updater.latest.1, ini\config.ini, versions, skip
			Gui, LLK_panel: Color, Black
			Settings_menu("updater")
		}
	}
	Else LLK_ToolTip("no action")
}

Settings_WriteTest(cHWND := "")
{
	local
	global vars, settings
	static running

	If (cHWND = vars.hwnd.settings.writetest)
	{
		IniWrite, % vars.settings.active, % "ini" vars.poe_version "\config.ini", Versions, reload settings
		Run *RunAs "%A_AhkPath%" /restart "%A_ScriptFullPath%"
		ExitApp
	}

	If running
		Return
	running := 1, HWND_bar := vars.hwnd.settings.bar_writetest, yes := Lang_Trans("m_permission_yes"), no := Lang_Trans("m_permission_no"), unknown := Lang_Trans("m_permission_unknown")
	FileRemoveDir, data\write-test\, 1
	If FileExist("data\write-test\")
	{
		running := 0
		MsgBox,, % Lang_Trans("m_general_permissions"), % Lang_Trans("m_permission_error", 1) "`n`n" Lang_Trans("m_permission_error", 2)
		Run, explore %A_WorkingDir%\data\
		Return
	}
	status .= Lang_Trans("m_permission_admin") " " (A_IsAdmin ? yes : no) "`n`n"
	FileCreateDir, data\write-test\
	GuiControl,, % HWND_bar, 100
	sleep, 250
	status .= Lang_Trans("m_permission_folder", 1) " " (FileExist("data\write-test\") ? yes : no) "`n`n", folder_creation := FileExist("data\write-test\") ? 1 : 0

	FileAppend,, data\write-test.ini
	GuiControl,, % HWND_bar, 200
	sleep, 250
	status .= Lang_Trans("m_permission_ini", 1) " " (FileExist("data\write-test.ini") ? yes : no) "`n`n", ini_creation := FileExist("data\write-test.ini") ? 1 : 0

	IniWrite, 1, data\write-test.ini, write-test, test
	GuiControl,, % HWND_bar, 300
	sleep, 250
	IniRead, ini_test, data\write-test.ini, write-test, test, 0
	status .= Lang_Trans("m_permission_ini", 2) " " (ini_test ? yes : no) "`n`n"

	pWriteTest := Gdip_BitmapFromScreen("0|0|100|100"), Gdip_SaveBitmapToFile(pWriteTest, "data\write-test.bmp", 100), Gdip_DisposeImage(pWriteTest)
	GuiControl,, % HWND_bar, 400
	sleep, 250
	status .= Lang_Trans("m_permission_image", 1) " " (FileExist("data\write-test.bmp") ? yes : no) "`n`n", img_creation := FileExist("data\write-test.bmp") ? 1 : 0

	If folder_creation
	{
		FileRemoveDir, data\write-test\
		sleep, 250
		status .= Lang_Trans("m_permission_folder", 2) " " (!FileExist("data\write-test\") ? yes : no) "`n`n"
	}
	Else status .= Lang_Trans("m_permission_folder", 2) " " unknown "`n`n"
	GuiControl,, % HWND_bar, 500

	If ini_creation
	{
		FileDelete, data\write-test.ini
		sleep, 250
		status .= Lang_Trans("m_permission_ini", 3) " " (!FileExist("data\write-test.ini") ? yes : no) "`n`n"
	}
	Else status .= Lang_Trans("m_permission_ini", 3) " " unknown "`n`n"
	GuiControl,, % HWND_bar, 600

	If img_creation
	{
		FileDelete, data\write-test.bmp
		sleep, 250
		status .= Lang_Trans("m_permission_image", 2) " " (!FileExist("data\write-test.bmp") ? yes : no) "`n`n"
	}
	Else status .= Lang_Trans("m_permission_image", 2) " " unknown "`n`n"
	GuiControl,, % HWND_bar, 700

	MsgBox, 4096, % Lang_Trans("m_permission_header"), % status
	GuiControl,, % HWND_bar, 0
	running := 0
}
