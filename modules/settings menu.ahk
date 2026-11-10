Settings_actdecoder()
{
	local
	global vars, settings
	static fSize, wOpacity

	GUI := "settings_menu" vars.settings.GUI_toggle, x_anchor := vars.settings.x_anchor, slop := settings.general.slop, cButtons := settings.general.cButtons, fWidth := settings.general.fWidth
	Gui_Label(GUI, "Section x" x_anchor " y" vars.settings.ySelection " gSettings_actdecoder2", " " Lang_Trans("global_enable") " ", "settings_actdecoder enable", "hwnd.settings.enable", slop,,, cButtons, settings.features.actdecoder)
	hwnd := Gui_Label(GUI, "ys gURL cAqua", " wiki page ", "settings_website",, slop,,, cButtons), vars.URLs := {(hwnd.text): "https://github.com/Lailloken/Exile-UI/wiki/Act‐Decoder"}

	If !settings.features.actdecoder
		Return

	hwnd := Gui_Label(GUI, "ys gURL cAqua", " ahk: key list ", "settings_website|",, slop,,, cButtons), vars.URLs[hwnd.text] := "https://www.autohotkey.com/docs/v1/KeyList.htm"
	FileDelete, % "img\GUI\act-decoder\Exile-UI*"
	Loop, Files, % "img\GUI\act-decoder\Exile-UI*", D
		FileRemoveDir, % A_LoopFilePath, 1

	If (fSize != settings.general.fSize)
	{
		fSize := settings.general.fSize
		LLK_PanelDimensions([Lang_Trans("global_opacity",,, 1), Lang_Trans("global_zoom",,, 1)], fSize, wOpacity, hOpacity)
	}

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "Section xs y+" vars.settings.spacing " BackgroundTrans", % Lang_Trans("m_actdecoder_download")
	Gui, %GUI%: Font, norm

	If !vars.actdecoder.file_list.Count() || vars.actdecoder.updater.available
	{
		If FileExist("img\GUI\act-decoder\Exile-UI*")
		{
			Gui, %GUI%: Add, Text, % "Section xs cFF8000 BackgroundTrans", % Lang_Trans("m_actdecoder_leftover")
			Gui_Label(GUI, "Section xs gSettings_actdecoder2", " " Lang_Trans("global_openfolder") " ", "settings_actdecoder folder", "hwnd.settings.open_folder", slop,,, cButtons)
			Return
		}
		Else If !vars.actdecoder.file_list.Count()
			Gui, %GUI%: Add, Text, % "Section xs cFF8000 BackgroundTrans", % Lang_Trans("m_actdecoder_download", 2)
		Else Gui_Label(GUI, "Section xs cLime", " " Lang_Trans("global_update", 2) " ",,, [slop, 0, slop, 0])

		If vars.actdecoder.updater.check.requires && (vars.actdecoder.updater.check.requires > vars.actdecoder.tool_version)
			Gui, %GUI%: Add, Text, % "Section xs y+0 hp cFF8000 BackgroundTrans", % Lang_Trans("m_actdecoder_required")
		Else Gui_Label(GUI, "ys x+0 gSettings_actdecoder2", " " Lang_Trans("global_download") " ",, "hwnd.settings.dload_layouts", [0, slop, 0, slop],,, cButtons)

		If !vars.actdecoder.file_list.Count()
			Return
	}
	Else If Blank(vars.actdecoder.updater.last) || (LLK_TimeElapsed(vars.actdecoder.updater.last, "seconds") >= 60)
		Gui_Label(GUI, "Section xs gSettings_actdecoder2", " " Lang_Trans("global_update", 3) " ",, "hwnd.settings.dload_check", slop,,, cButtons)
	Else
	{
		If (vars.actdecoder.updater.check = "failed")
			Gui, %GUI%: Add, Text, % "Section xs h" settings.general.fHeight " cFF8000 BackgroundTrans", % Lang_Trans("m_actdecoder_failed")
		Else If (vars.actdecoder.updater.check.version = vars.actdecoder.version)
			Gui, %GUI%: Add, Text, % "Section xs h" settings.general.fHeight " cLime BackgroundTrans", % Lang_Trans("m_actdecoder_success")
	}

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "Section xs y+" vars.settings.spacing " BackgroundTrans", % Lang_Trans("global_general")
	Gui, %GUI%: Font, norm

	Gui_Label(GUI, "Section xs", " " Lang_Trans("global_hotkey", 2) " ", "settings_actdecoder hotkey", ["hwnd.settings.hotkey_label", "_bar"], [slop, slop, 0, 0])
	Gui_Label(GUI, "Hidden xp yp wp Center cRed gSettings_actdecoder2", Lang_Trans("global_save"),, ["hwnd.settings.hotkey_save", "_bar"], [slop, slop, 0, 0],, "insert 800000", cButtons)
	Gui_Label(GUI, "xs y+0 wp",, "settings_hotkeys formatting",, [0, 0, slop, slop],,, "0x01000000")
	Gui, %GUI%: Font, % "s" settings.general.fSize - 2
	Gui, %GUI%: Add, Edit, % "xp yp wp hp cBlack Center gSettings_actdecoder2 HWNDhwnd", % settings.actdecoder.hotkey
	Gui, %GUI%: Font, % "s" settings.general.fSize
	vars.hwnd.settings.hotkey := hwnd

	Gui_Label(GUI, "Section ys w" wOpacity " Right", Lang_Trans("global_opacity",,, 1) " ", "settings_actdecoder layouts opacity",, [slop, 0, 0, 0])
	Gui_Label(GUI, "ys x+0 w" 3*fWidth " Center", settings.actdecoder.trans_zones, "settings_actdecoder layouts opacity|", "hwnd.settings.zonesopac_text",,,, 0)
	Gui_Label(GUI, "ys x+0 w" 2*fWidth " Center gSettings_actdecoder2", "–", "settings_actdecoder layouts opacity||", "hwnd.settings.zonesopac_minus",,,, cButtons)
	Gui_Label(GUI, "ys x+0 w" 2*fWidth " Center gSettings_actdecoder2", "+", "settings_actdecoder layouts opacity|||", "hwnd.settings.zonesopac_plus", [0, slop, 0, 0],,, cButtons)

	Gui_Label(GUI, "Section xs y+0 w" wOpacity " Right", Lang_Trans("global_zoom",,, 1) " ", "settings_actdecoder layouts locked zoom",, [0, 0, slop, 0])
	Gui_Label(GUI, "ys x+0 w" 3*fWidth " Center", settings.actdecoder.sLayouts1, "settings_actdecoder layouts locked zoom|", "hwnd.settings.zoneszoom_text",,,, 0)
	Gui_Label(GUI, "ys x+0 w" 2*fWidth " Center gSettings_actdecoder2", "–", "settings_actdecoder layouts locked zoom||", "hwnd.settings.zoneszoom_minus",,,, cButtons)
	Gui_Label(GUI, "ys x+0 w" 2*fWidth " Center gSettings_actdecoder2", "+", "settings_actdecoder layouts locked zoom|||", "hwnd.settings.zoneszoom_plus", [0, 0, 0, slop],,, cButtons)

	If !Blank(settings.actdecoder.xLayouts . settings.actdecoder.yLayouts)
	{
		Gui_Label(GUI, "Section xs x" x_anchor " gSettings_actdecoder2", " " Lang_Trans("global_reset", 3) " ", "settings_actdecoder position reset", "hwnd.settings.reset_position", slop,,, cButtons)
		Gui, %GUI%: Add, Progress, % "Disabled ys x+-1 w4 hp Vertical Range0-500 HWNDhwnd BackgroundBlack cRed", 0
		vars.hwnd.settings.reset_position_bar := hwnd
	}

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "Section xs x" x_anchor " y+" vars.settings.spacing " BackgroundTrans", % Lang_Trans("global_credits") . Lang_Trans("global_colon")
	Gui, %GUI%: Font, norm

	If !vars.poe_version
	{
		Gui, %GUI%: Add, Text, % "Section xs BackgroundTrans", % ">> CyclonDefinitiv's "
		hwnd := Gui_Label(GUI, "ys x+0 gURL cAqua", " layout guide ", "settings_website||",, slop,,, cButtons), vars.URLs[hwnd.text] := "https://www.definitivguide.com/"
		Gui, %GUI%: Add, Text, % "Section xs BackgroundTrans", % ">> lailloken (compilation && editing)"
	}
	Else
	{
		Gui, %GUI%: Add, Text, % "Section xs BackgroundTrans", % ">> poe 2 campaign codex discord"
		Gui, %GUI%: Add, Text, % "Section xs BackgroundTrans", % ">> lailloken (compilation && editing)"
	}
}

Settings_actdecoder2(cHWND := "")
{
	local
	global vars, settings
	static wait

	If wait
		Return
	check := LLK_HasVal(vars.hwnd.settings, cHWND), control := SubStr(check, InStr(check, "_") + 1)
	If !InStr(check, "reset_position")
		KeyWait, LButton
	If (check = "enable")
	{
		IniWrite, % (settings.features.actdecoder := !settings.features.actdecoder), % "ini" vars.poe_version "\config.ini", Features, enable act-decoder
		Hotkey, If, vars.actdecoder.zones[vars.log.areaID] && WinActive("ahk_group poe_ahk_window")
		If !settings.features.actdecoder
		{
			vars.actdecoder.layouts_lock := 0, LLK_Overlay(vars.hwnd.actdecoder.main, "destroy"), vars.hwnd.actdecoder.main := ""
			If !Blank(settings.actdecoder.hotkey)
				Hotkey, % Hotkeys_Convert(settings.actdecoder.hotkey), Actdecoder_Hotkey, Off
		}
		Else If !Blank(settings.actdecoder.hotkey)
			Hotkey, % Hotkeys_Convert(settings.actdecoder.hotkey), Actdecoder_Hotkey, On
		Settings_menu("actdecoder")
	}
	Else If (check = "open_folder")
	{
		Run, explore img\GUI\act-decoder\
		Settings_menuClose()
	}
	Else If (check = "dload_check")
	{
		Actdecoder_UpdateCheck()
		Settings_menu("actdecoder")
	}
	Else If (check = "dload_layouts")
	{
		wait := 1, failed := 0
		LLK_ToolTip(Lang_Trans("global_downloading"), 0,,, "dload_layout", "Lime")
		UrlDownloadToFile, % "https://github.com/Lailloken/Exile-UI/archive/refs/heads/layouts" StrReplace(vars.poe_version, " ", "_") ".zip", % "img\GUI\act-decoder\Exile-UI-layouts.zip"
		If ErrorLevel || !FileExist("img\GUI\act-decoder\Exile-UI*.zip")
			failed := 1
		LLK_Overlay(vars.hwnd.tooltip_dload_layout, "destroy")
		If !failed
		{
			LLK_ToolTip(Lang_Trans("global_extracting"), 0,,, "dload_layout", "Lime")
			FileCopyDir, % "img\GUI\act-decoder\Exile-UI-layouts.zip", % "img\GUI\act-decoder\", 1
			If ErrorLevel
				failed := 1
			LLK_Overlay(vars.hwnd.tooltip_dload_layout, "destroy")

			If !failed
			{
				LLK_ToolTip(Lang_Trans("global_copying"), 0,,, "dload_layout", "Lime")
				Loop, Files, % "img\GUI\act-decoder\Exile-UI-layouts" StrReplace(vars.poe_version, " ", "_") "\*", DF
				{
					If InStr(A_LoopFilePath, ".json")
						FileMove, % A_LoopFilePath, % "img\GUI\act-decoder\", 1
					Else FileMoveDir, % A_LoopFilePath, % "img\GUI\act-decoder\zones" vars.poe_version, 2

					If ErrorLevel
					{
						failed := 1
						FileDelete, % "img\GUI\act-decoder\*" vars.poe_version ".json"
						FileRemoveDir, % "img\GUI\act-decoder\zones" vars.poe_version, 1
						Break
					}
				}
				LLK_Overlay(vars.hwnd.tooltip_dload_layout, "destroy")
			}
		}
		Init_actdecoder(failed ? 2 : 1)
		wait := 0, vars.actdecoder.updater.last := A_NowUTC
		Settings_menu("actdecoder")
		If failed
			LLK_ToolTip(Lang_Trans("global_fail"), 3,,,, "Red")
	}
	Else If (check = "hotkey")
	{
		input := LLK_ControlGet(cHWND)
		GuiControl, % "+c" (input != settings.actdecoder.hotkey ? "Red" : "Black"), % cHWND
		GuiControl, % "movedraw", % cHWND
		GuiControl, % (input != settings.actdecoder.hotkey ? "-" : "+") "Hidden", % vars.hwnd.settings.hotkey_save
		GuiControl, % (input != settings.actdecoder.hotkey ? "-" : "+") "Hidden", % vars.hwnd.settings.hotkey_save_bar
		GuiControl, % (input != settings.actdecoder.hotkey ? "+" : "-") "Hidden", % vars.hwnd.settings.hotkey_label
		GuiControl, % (input != settings.actdecoder.hotkey ? "+" : "-") "Hidden", % vars.hwnd.settings.hotkey_label_bar
	}
	Else If (check = "hotkey_save")
	{
		input := LLK_ControlGet(vars.hwnd.settings.hotkey)
		If !(Blank(input) || GetKeyVK(input))
		{
			LLK_ToolTip(Lang_Trans("m_hotkeys_error"), 1.5,,,, "Red")
			Return
		}
		Hotkey, If, vars.actdecoder.zones[vars.log.areaID] && WinActive("ahk_group poe_ahk_window")
		If !Blank(settings.actdecoder.hotkey)
			Hotkey, % Hotkeys_Convert(settings.actdecoder.hotkey), Actdecoder_Hotkey, Off
		If !Blank(input)
			Hotkey, % Hotkeys_Convert(input), Actdecoder_Hotkey, On
		IniWrite, % """" (settings.actdecoder.hotkey := input) """", % "ini" vars.poe_version "\act-decoder.ini", settings, alternative hotkey
		GuiControl, +cBlack, % vars.hwnd.settings.hotkey
		GuiControl, movedraw, % vars.hwnd.settings.hotkey
		GuiControl, +Hidden, % vars.hwnd.settings.hotkey_save
		GuiControl, +Hidden, % vars.hwnd.settings.hotkey_save_bar
		GuiControl, -Hidden, % vars.hwnd.settings.hotkey_label
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
	Else If (check = "reset_position")
	{
		If (vars.system.click = 1) && LLK_Progress(vars.hwnd.settings.reset_position_bar, "LButton")
		{
			IniWrite, % (settings.actdecoder.xLayouts := ""), % "ini" vars.poe_version "\act-decoder.ini", settings, zone-layouts x
			IniWrite, % (settings.actdecoder.yLayouts := ""), % "ini" vars.poe_version "\act-decoder.ini", settings, zone-layouts y
			If WinExist("ahk_id " vars.hwnd.actdecoder.main)
				Actdecoder_ZoneLayouts()
		}
		Else Return
	}
	Else LLK_ToolTip("no action")

	If (check != "hotkey") && InStr("enable, generic, hotkey_save", check) && WinExist("ahk_id " vars.hwnd.leveltracker.main)
		Leveltracker_Progress()
}

Settings_addons(mode := 0)
{
	local
	global vars, settings, db
	static fSize, wEnable

	GUI := "settings_menu" vars.settings.GUI_toggle, x_anchor := vars.settings.x_anchor, slop := settings.general.slop, cButtons := settings.general.cButtons, fWidth := settings.general.fWidth, fHeight := settings.general.fHeight
	Gui_Label(GUI, "Section x" x_anchor " y" vars.settings.ySelection " gSettings_addons2", " " Lang_Trans("global_enable") " ", "settings_addons enable", "hwnd.settings.enable", slop,,, cButtons, settings.features.addons)
	;hwnd := Gui_Label(GUI, "ys gURL cAqua", " wiki page ", "settings_website",, slop,,, cButtons), vars.URLs := {(hwnd.text): "https://github.com/Lailloken/Exile-UI/wiki/Enchant-Finder"}

	If !settings.features.addons
	{
		Gui, %Gui%: Add, Text, % "Hidden Section xs y+" vars.settings.spacing " w" settings.general.fWidth * vars.settings.min_width " HWNDhwnd cRed", % Lang_Trans("m_addons_failed")
		vars.hwnd.settings.addons_failed := hwnd
		Return
	}

	If (fSize != settings.general.fSize)
	{
		fSize := settings.general.fSize
		LLK_PanelDimensions([Lang_Trans("global_enable"), Lang_Trans("global_delete", 3)], fSize, wEnable, hEnable)
		For key, hbm in vars.pics.settings_addons
			DeleteObject(hbm)
		vars.pics.settings_addons := {}
	}

	If !mode
		For key, val in vars.addons.list
			vars.addons.list[key].Delete("deleted")
	deletion := LLK_HasKey(vars.addons.list, "deleted",,,, 1)

	Gui, %GUI%: Add, Text, % "Section xs w" settings.general.fWidth * vars.settings.min_width " cFF8000 BackgroundTrans", % Lang_Trans("m_addons_warning")
	Gui_Label(GUI, "Section xs " (deletion ? "cGray" : "gSettings_addons2"), " " Lang_Trans("global_import") " ", (!deletion ? "settings_addons import" : ""), "hwnd.settings.import", slop,,, (deletion ? 0 : cButtons))

	Gui_Label(GUI, (deletion ? "" : "Hidden ") "ys gSettings_addons2 cRed", " " Lang_Trans("global_restart") " ",, ["hwnd.settings.restart", "_bar"], slop,, "insert 800000", cButtons)
	If vars.addons.list.Count()
	{
		Gui, %GUI%: Font, bold underline
		Gui, %GUI%: Add, Text, % "Section xs y+" vars.settings.spacing " BackgroundTrans", % Lang_Trans("m_addons_list")
		Gui, %GUI%: Font, norm
	}

	For key, val in vars.addons.list
	{
		vars.addons.list[key].enabled_provisional := val.enabled, label := ((deleted := val.deleted) ? Lang_Trans("global_delete", 3) : Lang_Trans("global_enable"))
		Gui_Label(GUI, "Section xs w" wEnable " Center c" (deleted ? "Red" : (val.enabled ? "Lime" : "Gray") " gSettings_addons2"), label,, ["hwnd.settings.enable_" key, "_bar"], [slop, 0, slop, 0],, (deleted ? "insert 800000" : ""), (deleted ? 0 : cButtons))
		Gui, %GUI%: Add, Pic, % "xp yp BackgroundTrans", % "HBitmap:" Gui_BackgroundPanel([vars.hwnd.settings["enable_" key "_bar"]], [slop, 0, slop, 0],, "insert 800000", cButtons)

		Gui_Label(GUI, "ys x+0 w" fHeight " Center" (deleted ? "" : " gSettings_addons2"), "x", (deleted ? "" : "settings_addons delete" handle), ["hwnd.settings.delete_" key, "_bar"],,, (deleted ? "insert 800000" : ""), (deleted ? 0 : cButtons))
		Gui, %GUI%: Add, Pic, % "xp yp BackgroundTrans", % "HBitmap:" Gui_BackgroundPanel([vars.hwnd.settings["delete_" key "_bar"]],,, "insert 800000", cButtons)

		Gui_Label(GUI, "ys x+0 w" fHeight " Center" (deleted ? "" : " gSettings_addons2"), "?", (deleted ? "" : "settings_addons about" handle), ["hwnd.settings.info_" key, "_bar"],,, (deleted ? "insert 800000" : ""), (deleted ? 0 : cButtons))
		Gui, %GUI%: Add, Pic, % "xp yp BackgroundTrans", % "HBitmap:" Gui_BackgroundPanel([vars.hwnd.settings["info_" key "_bar"]],,, "insert 800000", cButtons)

		If !vars.pics.settings_addons.settings
			vars.pics.settings_addons.settings := LLK_ImageCache("img\GUI\settings\general.png",, settings.general.fHeight - 2)

		Gui, %GUI%: Add, Pic, % hidden "ys x+1 yp+1 BackgroundTrans HWNDhwnd", % "HBitmap:*" vars.pics.settings_addons.settings
		Gui_Label(GUI, "xp-1 yp-1 w" fHeight (!deleted && val.enabled ? " gSettings_addons2" : ""),,, ["hwnd.settings.settings_" key, "_bar"], [0, slop, 0, slop],, (deleted ? "insert 800000" : ""), (deleted ? 0 : cButtons))
		Gui, %GUI%: Add, Pic, % "xp yp BackgroundTrans", % "HBitmap:" Gui_BackgroundPanel([vars.hwnd.settings["settings_" key "_bar"]], [0, slop, 0, slop],, "insert 800000", cButtons)
		vars.hwnd.help_tooltips["settings_addons settings" handle] := (!deleted && val.enabled ? hwnd : ""), handle .= "|"
		Gui, %GUI%: Add, Text, % "ys hp BackgroundTrans c" (deleted ? "Red" : (val.enabled ? "White" : "Gray")), % LLK_StringCase(key)
	}
}

Settings_addons2(cHWND)
{
	local
	global vars, settings, json

	check := LLK_HasVal(vars.hwnd.settings, cHWND), control := SubStr(check, InStr(check, "_") + 1)
	If !RegexMatch(check, "i)info_|delete_")
		KeyWait, LButton

	Switch
	{
		Case (check = "enable"):
		If !settings.features.addons
		{
			If Gui_MsgBox("addon warning", "(color:Red)" Lang_Trans("global_warning"), [Lang_Trans("m_addons_warning2"), Lang_Trans("m_addons_warning2", 2), Lang_Trans("msg_proceed")],, ["yes", "no"])
			{
				FileCreateDir, % "add-ons"
				Sleep, 100
				If !FileExist("add-ons")
				{
					GuiControl, -Hidden, % vars.hwnd.settings.addons_failed
					Return
				}
			}
			Else Return
		}
		Else If vars.addons.enabled
		{
			If Gui_MsgBox("addons disable",, [Lang_Trans("m_addons_disable"), Lang_Trans("msg_proceed")],, ["yes", "no"], "Center")
			{
				FileDelete, % "add-ons\loader" vars.poe_version
				IniWrite, % (settings.features.addons := !settings.features.addons), % "ini" vars.poe_version "\config.ini", features, enable add-ons
				IniWrite, addons, % "ini" vars.poe_version "\config.ini", versions, reload settings
				LLK_Restart()
			}
			Else Return
		}
		IniWrite, % (settings.features.addons := !settings.features.addons), % "ini" vars.poe_version "\config.ini", features, enable add-ons
		Settings_menu()
		;######################################################
		Case (check = "restart"):
		FileDelete, % "add-ons\loader" vars.poe_version
		FileDelete, % "add-ons\delete"
		For key, val in vars.addons.list
			If val.deleted
				delete .= (delete ? "`n" : "") val.info.name
			Else If val.enabled_provisional && FileExist("add-ons\" val.info.name "\" val.info.classname ".ahk")
				dump .= (dump ? "`n" : "") "#Include add-ons\" val.info.name "\" val.info.classname ".ahk"

		If dump
			file := FileOpen("add-ons\loader" vars.poe_version, "w", "UTF-8-RAW"), file.Write(dump), file.Close()
		If delete
			file := FileOpen("add-ons\delete", "w", "UTF-8-RAW"), file.Write(delete), file.Close()
		IniWrite, addons, % "ini" vars.poe_version "\config.ini", versions, reload settings
		LLK_Restart()
		;######################################################
		Case (check = "import"):
		If !InStr(Clipboard, "github.com/")
		{
			LLK_ToolTip(Lang_Trans("global_errorname", 2),,,,, "Red")
			Return
		}
		FileDelete, add-ons\*.zip
		If FileExist("add-ons\*.zip")
		{
			If Gui_MsgBox("addons leftovers",, [Lang_Trans("m_addons_leftover"), Lang_Trans("m_addons_leftover", 2)],, ["yes", "no"])
				Run, explore add-ons\
			Return
		}

		folders := {}, game := (vars.poe_version ? 2 : 1)
		Loop, Files, add-ons\*, D
			folders[A_LoopFileName] := 1
		If InStr(Clipboard, "/tree/")
			dload := StrReplace(Clipboard, "/tree/", "/archive/refs/heads/") ".zip", info := StrReplace(StrReplace(Clipboard, "github.com", "raw.githubusercontent.com"), "/tree/", "/refs/heads/") "/info.json"
		Else dload := Clipboard "/archive/refs/heads/main.zip", info := StrReplace(Clipboard, "github.com", "raw.githubusercontent.com") "/refs/heads/main/info.json"

		Try info_json := HTTPtoVar(info)
		Catch
			error := 1

		If !error
			If !InStr(info_json, """classname"":")
				error := 2
			Else If !InStr(info_json, """poe" game """")
				error := 3
			Else Try info_json := json.load(info_json)

		If !error
			If Blank(info_json.name)
				error := 4
			Else If vars.addons.list.HasKey(info_json.name)
				error := 5

		If error
		{
			Gui_MsgBox("addons import fail",, Lang_Trans("m_addons_importfail", error),,, "Center")
			Return
		}
		UrlDownloadToFile, % dload, add-ons\addon.zip
		If ErrorLevel || !FileExist("add-ons\addon.zip")
			error := 1
		If !error
		{
			FileCopyDir, add-ons\addon.zip, add-ons, 1
			error := (ErrorLevel ? 6 : 0)
			FileDelete, add-ons\addon.zip
		}
		If !error
		{
			found := []
			Loop, Files, add-ons\*, D
				If !folders[A_LoopFileName]
				{
					found.Push(A_LoopFileName)
					Break
				}
			If (found.Count() > 1)
				For index, folder in found
					FileRemoveDir, % "add-ons\" folder, 1
			error := (!found.Count() ? 6 : (found.Count() > 1 ? 7 : 0))
		}
		If error
		{
			Gui_MsgBox("addons download fail",, Lang_Trans("m_addons_importfail", error),,, "Center")
			Return
		}

		FileMoveDir, % "add-ons\" found.1, % "add-ons\" info_json.name, R
		If ErrorLevel
		{
			FileRemoveDir, % "add-ons\" found.1, 1
			FileRemoveDir, % "add-ons\" info_json.name, 1
			Gui_MsgBox("addons download fail",, Lang_Trans("m_addons_importfail", 8),,, "Center")
			Return
		}
		Init_addons(), Settings_menu()
		;######################################################
		Case InStr(check, "enable_"):
		vars.addons.list[control].enabled_provisional := !vars.addons.list[control].enabled_provisional, toggle := (vars.addons.list[control].enabled != vars.addons.list[control].enabled_provisional ? "+" : "-")
		GuiControl, % "+c" (vars.addons.list[control].enabled_provisional ? "Lime" : "Gray"), % cHWND
		GuiControl, % "movedraw", % cHWND
		GuiControl, % toggle "Hidden", % vars.hwnd.settings[check "_bar"]
		GuiControl, % toggle "Hidden", % vars.hwnd.settings["delete_" control "_bar"]
		GuiControl, % toggle "Hidden", % vars.hwnd.settings["info_" control "_bar"]
		GuiControl, % toggle "Hidden", % vars.hwnd.settings["settings_" control "_bar"]

		For key, val in vars.addons.list
			If (val.enabled != val.enabled_provisional)
				modified := 1

		GuiControl, % (modified ? "-" : "+") "Hidden", % vars.hwnd.settings.restart
		GuiControl, % (modified ? "-" : "+") "Hidden", % vars.hwnd.settings.restart_bar
		;######################################################
		Case InStr(check, "delete_"):
		If (vars.system.click = 1) && LLK_Progress(vars.hwnd.settings[check "_progress"], "LButton")
		{
			If vars.addons.list[control].enabled
				vars.addons.list[control].deleted := 1
			Else
			{
				FileRemoveDir, % "add-ons\" control, 1
				vars.addons.list.Delete(control)
			}
			Settings_menu("addons", 1)
		}
		;######################################################
		Case InStr(check, "settings_"):
		Settings_menu("addons_" control)
		;######################################################
		Case InStr(check, "info_"):
		info := vars.addons.list[control].info
		For index, val in info.creators
			creators .= (creators ? ", " : "") . val.name
		text := LLK_StringCase(info.description) "`n`n" Lang_Trans("global_credits") . Lang_Trans("global_colon") "`n" creators
		LLK_ToolTip(text, 0,,, "addons_info",,,,, 1,, 1, settings.general.fWidth * 20)
		KeyWait, LButton
		LLK_Overlay(vars.hwnd.tooltip_addons_info, "destroy")
		;######################################################
		Default:
		LLK_ToolTip("no action")
	}
}

Settings_anoints()
{
	local
	global vars, settings, db

	GUI := "settings_menu" vars.settings.GUI_toggle, x_anchor := vars.settings.x_anchor

	Gui, %GUI%: Add, Text, % "Section x" x_anchor " y" vars.settings.ySelection " Border BackgroundTrans gSettings_anoints2 HWNDhwnd" (settings.features.anoints ? " cLime" : " cGray"), % " " Lang_Trans("global_enable") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.enable := hwnd, vars.hwnd.help_tooltips["settings_anoints enable"] := hwnd1

	Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans HWNDhwnd gURL cAqua", % " wiki page "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.URLs := {}, vars.URLs[hwnd] := "https://github.com/Lailloken/Exile-UI/wiki/Enchant-Finder", vars.hwnd.help_tooltips["settings_website"] := hwnd1

	If !settings.features.anoints
		Return

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "Section xs Center y+"vars.settings.spacing, % Lang_Trans("global_ui")
	Gui, %GUI%: Font, norm

	Gui, %GUI%: Add, Text, % "xs Section Border BackgroundTrans", % " " Lang_Trans("global_font") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd0 Background404040 cBlack", 100
	Gui, %GUI%: Add, Text, % "ys x+-1 Center Border BackgroundTrans gSettings_anoints2 HWNDhwnd w"settings.general.fWidth*2, % "–"
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.font_minus := hwnd, vars.hwnd.help_tooltips["settings_font-size|"] := hwnd1
	Gui, %GUI%: Add, Text, % "ys x+-1 Center Border BackgroundTrans gSettings_anoints2 HWNDhwnd w"settings.general.fWidth*3, % settings.anoints.fSize
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.font_reset := hwnd, vars.hwnd.help_tooltips["settings_font-size||"] := hwnd1
	Gui, %GUI%: Add, Text, % "ys x+-1 Center Border BackgroundTrans gSettings_anoints2 HWNDhwnd w"settings.general.fWidth*2, % "+"
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.font_plus := hwnd, vars.hwnd.help_tooltips["settings_font-size|||"] := hwnd1

	If !IsObject(db.anoints)
		DB_Load("anoints")

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "Section xs Center y+"vars.settings.spacing, % Lang_Trans("global_databaseinfo") . Lang_Trans("global_colon")
	Gui, %GUI%: Font, norm
	Gui, %GUI%: Add, Text, % "Section xs Center", % Lang_Trans("global_current") . Lang_Trans("global_colon") " " vars.anoints.timestamp " "
	Gui, %GUI%: Add, Pic, % "ys x+0 hp-2 w-1 Border BackgroundTrans HWNDhwnd gSettings_anoints2", % "HBitmap:*" vars.pics.global.reload
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.update := hwnd, vars.hwnd.help_tooltips["settings_anoints update"] := hwnd1
}

Settings_anoints2(cHWND)
{
	local
	global vars, settings, db, json

	check := LLK_HasVal(vars.hwnd.settings, cHWND), control := SubStr(check, InStr(check, "_") + 1)
	If !InStr(check, "font_")
		KeyWait, LButton

	If (check = "enable")
	{
		IniWrite, % (settings.features.anoints := !settings.features.anoints), % "ini" vars.poe_version "\config.ini", features, enable enchant finder
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
	static fSize, wColumn, columns, columns2

	GUI := "settings_menu" vars.settings.GUI_toggle, x_anchor := vars.settings.x_anchor, slop := settings.general.slop, cButtons := settings.general.cButtons, fWidth := settings.general.fWidth, fHeight := settings.general.fHeight
	Gui_Label(GUI, "Section x" x_anchor " y" vars.settings.ySelection " gSettings_betrayal2", " " Lang_Trans("global_enable") " ", "settings_betrayal enable", "hwnd.settings.enable", slop,,, cButtons, settings.features.betrayal)
	hwnd := Gui_Label(GUI, "ys gURL cAqua", " wiki page ", "settings_website",, slop,,, cButtons), vars.URLs := {(hwnd.text): "https://github.com/Lailloken/Exile-UI/wiki/Betrayal-Info"}

	If !settings.features.betrayal
		Return

	Gui, %GUI%: Font, % "underline bold"
	Gui, %GUI%: Add, Text, % "Section xs y+"vars.settings.spacing " BackgroundTrans", % Lang_Trans("global_general")
	Gui, %GUI%: Font, % "norm"

	Gui_Label(GUI, "Section xs", " " Lang_Trans("global_mode") " ",,, [slop, 0, slop, 0])
	Gui_Label(GUI, "ys x+0 gSettings_betrayal2", " " Lang_Trans("global_league_normal") " ", "settings_betrayal mode", "hwnd.settings.ruthless0",,,, cButtons, [!settings.betrayal.ruthless, "White"])
	Gui_Label(GUI, "ys x+0 gSettings_betrayal2", " " Lang_Trans("global_league_ruthless") " ", "settings_betrayal mode|", "hwnd.settings.ruthless1", [0, slop, 0, slop],,, cButtons, [settings.betrayal.ruthless, "White"])

	Gui_Label(GUI, "ys gSettings_betrayal2", " " Lang_Trans("global_openfolder") " ", "settings_betrayal folder", "hwnd.settings.folder", slop,,, cButtons)

	Gui, %GUI%: Font, % "underline bold"
	Gui, %GUI%: Add, Text, % "xs Section y+"vars.settings.spacing " h" settings.general.fHeight " 0x200 BackgroundTrans", % Lang_Trans("global_ui")
	Gui, %GUI%: Font, % "norm"

	Gui_Label(GUI, "Section xs", " " Lang_Trans("global_font",,, 1) " ",,, [slop, 0, slop, 0])
	Gui_Label(GUI, "ys x+0 w" fHeight " Center gSettings_betrayal2", "–", "settings_font-size", "hwnd.settings.mFont",,,, cButtons)
	Gui_Label(GUI, "ys x+0 w" 3*fWidth " Center gSettings_betrayal2", settings.betrayal.fSize, "settings_font-size|", "hwnd.settings.rFont",,,, cButtons)
	Gui_Label(GUI, "ys x+0 w" fHeight " Center gSettings_betrayal2", "+", "settings_font-size||", "hwnd.settings.pFont", [0, slop, 0, slop],,, cButtons)

	Gui_Label(GUI, "ys", " " Lang_Trans("global_color", 2,, 1) " ", "settings_betrayal colors",, [slop, 0, slop, 0])
	Loop 3
		Gui_Label(GUI, "ys x+0 gSettings_betrayal2 c" settings.betrayal.colors[A_Index], " t" A_Index " ", "settings_betrayal color" handle, "hwnd.settings.tier" A_Index, (A_Index = 3 ? [0, slop, 0, slop] : ""),,, cButtons)
		, handle .= "|"

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "Section xs y+" vars.settings.spacing " BackgroundTrans", % Lang_Trans("global_databaseinfo") . Lang_Trans("global_colon")
	Gui, %GUI%: Font, norm

	Gui_Label(GUI, "Section xs", " " Lang_Trans("global_current") . Lang_Trans("global_colon") " ",,, [slop, 0, slop, 0])
	Gui_Label(GUI, "ys x+0", " " vars.betrayal.timestamp " ",,,,,, 0)

	Gui, %GUI%: Add, Pic, % "ys x+3 yp+1 w" fHeight - 4 " h-1 BackgroundTrans HWNDhwnd", % "HBitmap:*" vars.pics.global.reload
	Gui_Label(GUI, "xp-3 yp-1 w" fHeight " gSettings_betrayal2",, "settings_betrayal update||", "hwnd.settings.update", [0, slop, 0, slop]), vars.hwnd.help_tooltips["settings_betrayal update"] := hwnd

	Gui, %GUI%: Font, % "underline bold"
	Gui, %GUI%: Add, Text, % "Section xs y+" vars.settings.spacing " BackgroundTrans", % Lang_Trans("m_betrayal_rewards")
	Gui, %GUI%: Add, Pic, % "ys hp w-1 BackgroundTrans HWNDhwnd", % "HBitmap:*" vars.pics.global.help
	vars.hwnd.help_tooltips["settings_betrayal rewards"] := hwnd, wMembers := []
	Gui, %GUI%: Font, % "norm"

	If (fSize != settings.general.fSize)
	{
		fSize := settings.general.fSize, wColumn := [], columns := [[], [], [], [], []], columns2 := [[], [], [], [], []], column := 1
		For key, member in vars.betrayal.members_localized
			columns[column].Push(Lang_Trans("betrayal_" key)), columns2[column].Push(member), column += (columns[column].Count() = 5 ? 1 : 0)
		For index, val in columns
			LLK_PanelDimensions(val, fSize, width, height), wColumn[index] := width
	}

	For outer, array in columns
		For inner, val in array
			style := (inner = 1 ? "Section " (outer = 1 ? "xs" : "ys") : "") . (inner != 1 ? "xs y+0" : "")
			, Gui_Label(GUI, style " w" wColumn[outer] " gSettings_betrayal2", " " val,, "hwnd.settings." columns2[outer][inner], (inner = 1 ? [slop, slop, 0, 0] : (inner = 5 || inner = array.Count() ? [0, 0, slop, slop] : "")),,, cButtons)
}

Settings_betrayal2(cHWND := "")
{
	local
	global vars, settings, json

	check := LLK_HasVal(vars.hwnd.settings, cHWND), divisions := {"t": "transportation", "f": "fortification", "r": "research", "i": "intervention"}
	If !InStr(check, "font") && !vars.betrayal.members.HasKey(check)
		KeyWait, LButton

	If (check = "enable")
	{
		IniWrite, % (settings.features.betrayal := !settings.features.betrayal), ini\config.ini, Features, enable betrayal-info
		Settings_menu("betrayal-info")
	}
	Else If InStr(check, "ruthless")
	{
		IniWrite, % (settings.betrayal.ruthless := SubStr(check, 0)), ini\betrayal info.ini, settings, ruthless
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
	static fSize, wDDL, wAlt

	GUI := "settings_menu" vars.settings.GUI_toggle, Init_cheatsheets(), x_anchor := vars.settings.x_anchor

	Gui, %GUI%: Add, Text, % "Section x" x_anchor " y" vars.settings.ySelection " Border BackgroundTrans gSettings_cheatsheets2 HWNDhwnd" (settings.features.cheatsheets ? " cLime" : " cGray"), % " " Lang_Trans("global_enable") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.enable := hwnd, vars.hwnd.help_tooltips["settings_cheatsheets enable"] := hwnd1

	Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans HWNDhwnd gURL cAqua", % " wiki page "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.URLs := {}, vars.URLs[hwnd] := "https://github.com/Lailloken/Exile-UI/wiki/Cheat-sheet-Overlay-Toolkit", vars.hwnd.help_tooltips["settings_website"] := hwnd1

	If !settings.features.cheatsheets
		Return

	If (fSize != settings.general.fSize)
	{
		fSize := settings.general.fSize
		LLK_PanelDimensions([Lang_Trans("m_cheat_images"), Lang_Trans("m_cheat_app"), Lang_Trans("m_cheat_advanced")], fSize - 2, wDDL, hDDL)
		LLK_PanelDimensions([Lang_Trans("global_alt"), Lang_Trans("global_ctrl")], settings.general.fSize, wAlt, hAlt)
	}

	Gui, %GUI%: Font, % "underline bold"
	Gui, %GUI%: Add, Text, % "xs Section y+"vars.settings.spacing, % Lang_Trans("m_cheat_hotkeys")
	Gui, %GUI%: Font, % "norm"

	Gui, %GUI%: Add, Text, % "xs Section Border BackgroundTrans", % " " Lang_Trans("m_cheat_modifier") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd0 Background404040 cBlack", 100

	For index, val in ["ctrl", "alt"]
	{
		Gui, %GUI%: Add, Text, % "ys x+-1 w" wAlt " Center Border BackgroundTrans HWNDhwnd gSettings_cheatsheets2" (settings.cheatsheets.modifier = val ? " cLime" : ""), % Lang_Trans("global_" val)
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		handle .= "|", vars.hwnd.settings["modifier_" val] := hwnd, vars.hwnd.help_tooltips["settings_cheatsheets modifier-key"] := hwnd0, vars.hwnd.help_tooltips["settings_cheatsheets modifier-key" handle] := hwnd1
	}

	If vars.cheatsheets.count_advanced
	{
		Gui, %GUI%: Font, bold underline
		Gui, %GUI%: Add, Text, % "xs Section BackgroundTrans y+"vars.settings.spacing, % Lang_Trans("global_ui") " " Lang_Trans("m_cheat_advance")
		Gui, %GUI%: Font, norm

		Loop 4
		{
			style := (A_Index = 1) ? "xs Section" : "ys x+"settings.general.fWidth/4
			Gui, %GUI%: Add, Text, % style " Center Border BackgroundTrans HWNDhwnd gSettings_cheatsheets2 c"settings.cheatsheets.colors[A_Index], % " " Lang_Trans("global_color") " " A_Index " "
			Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
			vars.hwnd.settings["color"A_Index] := hwnd, vars.hwnd.help_tooltips["settings_cheatsheets color"handle1] := hwnd1, handle1 .= "|"
		}

		Gui, %GUI%: Add, Text, % "xs Section Border BackgroundTrans", % " " Lang_Trans("global_font") " "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border Background404040 cBlack", 100
		Gui, %GUI%: Add, Text, % "ys x+-1 Center HWNDhwnd Border BackgroundTrans gSettings_cheatsheets2 w"settings.general.fWidth*2, % "–"
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings.font_minus := hwnd, vars.hwnd.help_tooltips["settings_font-size|"] := hwnd1
		Gui, %GUI%: Add, Text, % "ys x+-1 Center HWNDhwnd Border BackgroundTrans gSettings_cheatsheets2 w"settings.general.fWidth*3, % settings.cheatsheets.fSize
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings.font_reset := hwnd, vars.hwnd.help_tooltips["settings_font-size||"] := hwnd1
		Gui, %GUI%: Add, Text, % "ys x+-1 Center HWNDhwnd Border BackgroundTrans gSettings_cheatsheets2 w"settings.general.fWidth*2, % "+"
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings.font_plus := hwnd, vars.hwnd.help_tooltips["settings_font-size|||"] := hwnd1
	}

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "Section xs y+"vars.settings.spacing, % Lang_Trans("m_cheat_create")
	Gui, %GUI%: Font, norm

	Gui, %GUI%: Font, % "s" settings.general.fSize
	Gui, %GUI%: Add, Text, % "Section xs Border BackgroundTrans", % " " Lang_Trans("global_type") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd0 Background404040 cBlack", 100
	Gui, %GUI%: Font, % "s" settings.general.fSize - 2

	DDL := [Lang_Trans("m_cheat_images"), Lang_Trans("m_cheat_app"), Lang_Trans("m_cheat_advanced")]
	Gui, %GUI%: Add, Text, % "ys x+-1 w" wDDL " hp 0x200 Center Border BackgroundTrans HWNDhwnd gSettings_cheatsheets2", % DDL.1
	vars.ddl.cheatsheet_type := {"cHWND": hwnd, "current": Lang_Trans("m_cheat_images"), "list": DDL.Clone(), "fSize": settings.general.fSize - 2, "color": vars.settings.cButtons}
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	Gui, %GUI%: Add, Button, % "Hidden xp yp wp hp Default HWNDhwnd2 gSettings_cheatsheets2", ok
	vars.hwnd.help_tooltips["settings_cheatsheets types"] := hwnd0, vars.hwnd.settings.type := hwnd, vars.hwnd.help_tooltips["settings_cheatsheets types|"] := hwnd1, vars.hwnd.settings.add := hwnd2
	Gui, %GUI%: Font, % "s"settings.general.fSize

	Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans", % " " Lang_Trans("global_name") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border Background404040 cBlack", 100
	Gui, %GUI%: Font, % "s" settings.general.fSize - 4
	Gui, %GUI%: Add, Text, % "ys x+-1 w" settings.general.fWidth*12 " hp Border BackgroundTrans"
	Gui, %GUI%: Add, Edit, % "xp yp wp hp Border cBlack HWNDhwnd",
	Gui, %GUI%: Font, % "s" settings.general.fSize
	vars.hwnd.settings.name := vars.hwnd.help_tooltips["settings_cheatsheets name"] := hwnd

	For index, object in vars.cheatsheets.samples
	{
		name := SubStr(object.folder, InStr(object.folder, "]") + 2)
		If vars.cheatsheets.list[name] && (object.version = vars.cheatsheets.list[name].version)
			Continue
		If !valid_samples
		{
			LLK_PanelDimensions([Lang_Trans("global_update"), Lang_Trans("global_enable")], settings.general.fSize, wSample, hSample)
			Gui, %GUI%: Font, bold underline
			Gui, %GUI%: Add, Text, % "Section xs BackgroundTrans y+"vars.settings.spacing, % Lang_Trans("m_cheat_samples")
			Gui, %GUI%: Font, norm
			valid_samples := 1
		}
		Gui, %GUI%: Add, Text, % "Section xs gSettings_cheatsheets2 HWNDhwnd Border BackgroundTrans Center w" wSample . (vars.cheatsheets.list[name] ? " cLime" : ""), % Lang_Trans("global_" (vars.cheatsheets.list[name] ? "update" : "enable"))
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		Gui, %GUI%: Add, Text, % "ys hp 0x200", % name
		vars.hwnd.settings["sampleget_" index] := vars.hwnd.help_tooltips["settings_cheatsheets samples " (vars.cheatsheets.list[name] ? "update" : "get") handle_samples] := hwnd, handle_samples .= "|"
	}

	LLK_PanelDimensions(vars.cheatsheets.list, settings.general.fSize - 2, wList, hList,,,,, 1), style := "x+" settings.general.fWidth/4, handle := ""
	For cheatsheet in vars.cheatsheets.list
	{
		If (A_Index = 1)
		{
			Gui, %GUI%: Font, bold underline
			Gui, %GUI%: Add, Text, % "Section xs y+" vars.settings.spacing, % Lang_Trans("m_cheat_list")
			Gui, %GUI%: Font, % "norm s" settings.general.fSize - 2
		}

		Gui, %GUI%: Add, Text, % "Section xs" (A_Index = 1 ? "" : " y+" settings.general.fWidth/2) " w" wList " 0x200 Border BackgroundTrans gSettings_cheatsheets2 HWNDhwnd " (vars.cheatsheets.list[cheatsheet].enable ? " cLime" : " cGray"), % " " cheatsheet
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings["enable_"cheatsheet] := hwnd, vars.hwnd.help_tooltips["settings_cheatsheets toggle"handle] := hwnd1

		If !IsNumber(vars.cheatsheets.list[cheatsheet].enable)
			vars.cheatsheets.list[cheatsheet].enable := LLK_IniRead("cheat-sheets" vars.poe_version "\" cheatsheet "\info.ini", "general", "enable", 1)
		color := !vars.cheatsheets.list[cheatsheet].enable ? " cGray" : !FileExist("cheat-sheets" vars.poe_version "\" cheatsheet "\[check].*") ? " cRed" : "", handle .= "|"
		Gui, %GUI%: Add, Text, % "ys " style " Border BackgroundTrans HWNDhwnd" color . (vars.cheatsheets.list[cheatsheet].enable ? " gSettings_cheatsheets2" : ""), % " " Lang_Trans("global_calibrate") " "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings["calibrate_"cheatsheet] := hwnd, vars.hwnd.help_tooltips["settings_cheatsheets calibrate"handle] := (color = " cGray") ? "" : hwnd1

		color := !vars.cheatsheets.list[cheatsheet].enable ? " cGray" : !vars.cheatsheets.list[cheatsheet].x1 ? " cRed" : ""
		Gui, %GUI%: Add, Text, % "ys " style " Border BackgroundTrans HWNDhwnd" color (vars.cheatsheets.list[cheatsheet].enable ? " gSettings_cheatsheets2" : ""), % " " Lang_Trans("global_test") " "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings["test_"cheatsheet] := hwnd, vars.hwnd.help_tooltips["settings_cheatsheets test"handle] := (color = " cGray") ? "" : hwnd1

		Gui, %GUI%: Add, Text, % "ys " style " Border BackgroundTrans HWNDhwnd gSettings_cheatsheets2", % " " Lang_Trans("global_edit") " "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings["edit_"cheatsheet] := hwnd, vars.hwnd.help_tooltips["settings_cheatsheets edit"handle] := hwnd1

		Gui, %GUI%: Add, Text, % "ys " style " Border BackgroundTrans BackgroundTrans gSettings_cheatsheets2 HWNDhwnd0", % " x "
		Gui, %GUI%: Add, Progress, % "xp yp wp hp Border Disabled range0-500 HWNDhwnd Vertical Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 500
		vars.hwnd.settings["delbar_"cheatsheet] := vars.hwnd.help_tooltips["settings_cheatsheets delete"handle] := hwnd, vars.hwnd.settings["delete_"cheatsheet] := hwnd0

		Gui, %GUI%: Add, Text, % "ys " style " Center gSettings_cheatsheets2 Border BackgroundTrans HWNDhwnd", % " " Lang_Trans("global_info") " "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings["info_"cheatsheet] := hwnd, vars.hwnd.help_tooltips["settings_cheatsheets info"handle] := hwnd1
	}
}

Settings_cheatsheets2(cHWND)
{
	local
	global vars, settings

	check := LLK_HasVal(vars.hwnd.settings, cHWND), control := SubStr(check, InStr(check, "_") + 1)
	If !RegexMatch(check, "(font|delete|info)_")
	{
		KeyWait, LButton
		KeyWait, RButton
		KeyWait, ENTER
	}

	If (check = "enable") ;toggling the feature on/off
	{
		IniWrite, % (settings.features.cheatsheets :=  !settings.features.cheatsheets), % "ini" vars.poe_version "\config.ini", features, enable cheat-sheets
		If !settings.features.cheatsheets
			LLK_Overlay(vars.hwnd.cheatsheet.main, "destroy"), LLK_Overlay(vars.hwnd.cheatsheet_menu.main, "destroy")
		Settings_menu("cheat-sheets")
	}
	Else If (check = "add") ;adding a new sheet
		Cheatsheet_Add(LLK_ControlGet(vars.hwnd.settings.name), LLK_ControlGet(vars.hwnd.settings.type))
	Else If (check = "type")
	{
		If Blank(input := Gui_DropDownList(vars.ddl.cheatsheet_type, LLK_WinGetPos(cHWND, "array"), "Center",, "Center"))
			Return
		vars.ddl.cheatsheet_type.current := input
	}
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
		GuiControl, % "+cLime", % cHWND
		GuiControl, % "movedraw", % cHWND
		GuiControl, % "+cWhite", % vars.hwnd.settings["modifier_" (control = "alt" ? "ctrl" : "alt")]
		GuiControl, % "movedraw", % vars.hwnd.settings["modifier_" (control = "alt" ? "ctrl" : "alt")]
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
	Else If InStr(check, "sampleget_")
	{
		KeyWait, LButton
		folder := vars.cheatsheets.samples[control].folder, name := SubStr(folder, InStr(folder, "]") + 2)
		If !vars.cheatsheets.list[name]
			FileCopyDir, % folder, % "cheat-sheets" vars.poe_version "\" name
		Else
		{
			Loop, Files, % folder "\*"
				If (A_LoopFileName != "info.ini")
					FileCopy, % A_LoopFilePath, % "cheat-sheets" vars.poe_version "\" name "\", 1
			ini := IniBatchRead(folder "\info.ini"), vars.cheatsheets.list[name].version := ini.general.version
			IniWrite, % ini.general.version, % "cheat-sheets" vars.poe_version "\" name "\info.ini", general, version
		}
		Settings_menu("cheat-sheets")
	}
	Else If InStr(check, "calibrate_") ;clicking calibrate
	{
		pBitmap := Screenchecks_ImageRecalibrate()
		If (pBitmap > 0)
		{
			If vars.pics.cheatsheets_checks[control " [check].bmp"]
				DeleteObject(vars.pics.cheatsheets_checks[control " [check].bmp"])
			vars.pics.cheatsheets_checks[control " [check].bmp"] := Gdip_CreateHBITMAPFromBitmap(pBitmap, 0)
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
		If (vars.system.click = 1) && LLK_Progress(vars.hwnd.settings["delbar_"control], "LButton", cHWND,, 500, "Red", vars.settings.cButtons)
		{
			FileRemoveDir, % "cheat-sheets" vars.poe_version "\" control "\", 1
			For key, hbm in vars.pics.cheatsheets_checks
				If InStr(key, control " [")
					DeleteObject(hbm), vars.pics.cheatsheets_checks.Delete(key)
			Settings_menu("cheat-sheets")
		}
		Else Return
	}
	Else If InStr(check, "enable_")
	{
		IniWrite, % (vars.cheatsheets.list[control].enable := !vars.cheatsheets.list[control].enable), % "cheat-sheets" vars.poe_version "\" control "\info.ini", general, enable
		Settings_menu("cheat-sheets")
	}
	Else LLK_ToolTip("no action")
}

Settings_client()
{
	local
	global vars, settings
	static fSize, wDock, wDock2, wResolution, wPosition, wFiller, wTaskbar, wSplit, wLanguage, wWindow

	GUI := "settings_menu" vars.settings.GUI_toggle, x_anchor := vars.settings.x_anchor, vars.settings.borderless_provisional := vars.client.borderless, vars.settings.blackbars_provisional := settings.general.blackbars
	cButtons := settings.general.cButtons, slop := settings.general.slop, fWidth := settings.general.fWidth, fHeight := settings.general.fHeight, radius := settings.general.radius, xMargin := vars.settings.xMargin
	fullscreen := vars.client.fullscreen
	hwnd := Gui_Label(GUI, "Section x" x_anchor " y" vars.settings.ySelection " gURL cAqua", " wiki && setup guide ", "settings_website",, slop,,, cButtons), vars.URLs := {(hwnd.text): "https://github.com/Lailloken/Exile-UI/wiki"}

	If (fSize != settings.general.fSize)
	{
		fSize := settings.general.fSize
		LLK_PanelDimensions([Lang_Trans("m_general_resolution", 2,, 1), (fullscreen = "false" ? Lang_Trans("m_general_borderless", 2) : "")], fSize, wResolution, hResolution)
		LLK_PanelDimensions([Lang_Trans("m_general_position"),,, 1], fSize, wPosition, hPosition)
		LLK_PanelDimensions([Lang_Trans("m_general_posleft"), Lang_Trans("m_general_poscenter"), Lang_Trans("m_general_posright")], fSize, wDock, hDock)
		LLK_PanelDimensions([Lang_Trans("m_general_postop"), Lang_Trans("m_general_poscenter"), Lang_Trans("m_general_posbottom"), Lang_Trans("m_general_postaskbar")], fSize, wDock2, hDock2)
		LLK_PanelDimensions([Lang_Trans("m_general_screenfiller")], fSize, wFiller, hFiller)
		LLK_PanelDimensions([Lang_Trans("m_general_postaskbar")], fSize, wTaskbar, hTaskbar)
		LLK_PanelDimensions([Lang_Trans("m_general_screenfiller", 2)], fSize, wSplit, hSplit)
		LLK_PanelDimensions([" " Lang_Trans("m_general_language", 2), " " Lang_Trans("m_general_display", 1)], fSize, wLanguage, hLanguage,,, 0)
		LLK_PanelDimensions([(settings.general.lang_client = "unknown" ? Lang_Trans("m_general_language", 3) : settings.general.lang_client), Lang_Trans("m_general_display", (fullscreen = "true") ? 2 : !vars.client.borderless ? 3 : 4)], fSize, wWindow, hWindow)

		If (wResolution < settings.general.fWidth * 8)
			wResolution := settings.general.fWidth * 8
		Else While Mod(wResolution, 2)
			wResolution += 1

		If (wPosition < wDock + wDock2)
			wPosition := wDock + wDock2
		Else
		{
			wDock := wDock2 := Max(wDock, wDock2)
			While Mod(wPosition, 2) || (wPosition < wDock * 2)
				wPosition += 1
			While (wDock * 2 < wPosition)
				wDock := wDock2 := wDock + 1
		}
	}

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "Section xs y+" vars.settings.spacing " BackgroundTrans", % Lang_Trans("m_general_client", 2)
	Gui, %GUI%: Font, norm

	Gui, %GUI%: Add, Text, % "ys cLime BackgroundTrans", % "path of exile " (vars.poe_version ? 2 : 1)
	If vars.client.stream
		Return
	Gui_Label(GUI, "Section xs w" wLanguage, " " Lang_Trans("m_general_language", 2),,, [slop, 0, 0, 0])
	Gui_Label(GUI, "ys x+0 w" wWindow " c" (settings.general.lang_client = "unknown" ? "Red" : "Lime"), " " (settings.general.lang_client = "unknown" ? Lang_Trans("m_general_language", 3) : settings.general.lang_client), (!InStr("unknown,english", settings.general.lang_client) ? "settings_lang contributors" : ""),, [0, slop, 0, 0],,, 0)

	If (settings.general.lang_client = "unknown")
	{
		Gui, %GUI%: Add, Pic, % "ys x+2 hp w-1 HWNDhwnd BackgroundTrans", % "HBitmap:*" vars.pics.global.help
		vars.hwnd.help_tooltips["settings_lang unknown"] := hwnd
	}

	Gui_Label(GUI, "Section xs y+0 w" wLanguage, " " Lang_Trans("m_general_display", 1),,, [0, 0, slop, 0])
	Gui_Label(GUI, "ys x+0 w" wWindow " cLime", " " Lang_Trans("m_general_display", (fullscreen = "true") ? 2 : !vars.client.borderless ? 3 : 4),,, [0, 0, 0, slop],,, 0)

	If !vars.log.latest_location
	{
		Gui_Label(GUI, "Section xs", " " Lang_Trans("m_general_logfile",,, 1) " ",,, [slop, 0, slop, 0])
		red := Min(255, Max(0, vars.log.file_size - 100)), green := 255 - red, rgb := (red < 10 ? "0" : "") . Format("{:X}", red) . (green < 10 ? "0" : "") . Format("{:X}", green) "00"
		Gui_Label(GUI, "ys x+0 c" rgb, " " vars.log.file_size " mb / " vars.log.access_time " ms ", "settings_logfile")
		Gui_Label(GUI, "ys x+0 gSettings_client2", " " Lang_Trans("global_folder") " ", "settings_logfolder", "hwnd.settings.logfolder", [0, slop, 0, slop],,, cButtons)
	}

	If !vars.general.safe_mode
	{
		Gui_Label(GUI, "Section xs", " " Lang_Trans("m_general_input", 2,, 1) " ",,, [slop, 0, slop, 0])
		For index, val in ["keyboard", "controller"]
			Gui_Label(GUI, "ys x+0 gSettings_client2", " " Lang_Trans("global_" val) " ", "settings_input method " index, "hwnd.settings.inputmethod_" index, (index = 2 ? [0, slop, 0, slop] : ""),,, cButtons, [(settings.general.input_method = index), "White"])
	}

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "xs Section y+"vars.settings.spacing " BackgroundTrans", % Lang_Trans("m_general_client")
	Gui, %GUI%: Font, norm

	Gui_Label(GUI, "Hidden ys cRed gSettings_client2", " " Lang_Trans("global_restart", 2) " ",, ["hwnd.settings.apply", "_bar"], slop,, "insert 800000", cButtons)
	Gui, %GUI%: Add, Text, % "yp x+0 w1 hp BackgroundTrans"

	Gui_Label(GUI, "Section xs w" wResolution " Center", Lang_Trans("m_general_resolution", 2,, 1), "settings_force resolution",, [slop, (slop && fullscreen != "true"), 0, 0])
	If (fullscreen = "true")
		Gui_Label(GUI, "xp y+0 w" wResolution/2 " Center", vars.monitor.w, "settings_force resolution|", "hwnd.settings.custom_width", [0, 0, slop, 0],,, 0)
	Else
	{
		Gui, %GUI%: Font, % "s" settings.general.fSize - 2
		Gui_Label(GUI, "xp y+0 w" wResolution/2 " h" settings.general.fHeight - 2,, "settings_force resolution|",, [0, 0, slop, 0],,, "0x50" cButtons)
		Gui, %GUI%: Add, Edit, % "xp yp wp hp Limit4 Number Center cBlack gSettings_client2 HWNDhwnd", % vars.client.w0
		vars.hwnd.settings.custom_width := hwnd
		Gui, %GUI%: Font, % "s" settings.general.fSize
	}

	If vars.general.safe_mode
		vars.general.available_resolutions := StrReplace(vars.general.available_resolutions, vars.monitor.h "|")
	Gui_Label(GUI, "x+0 yp wp h" settings.general.fHeight - 2 " 0x200 Center gSettings_client2", vars.client.h, "settings_force resolution||", "hwnd.settings.custom_resolution", [0, 0, 0, (slop && fullscreen != "true")],,, cButtons)
	vars.ddl.custom_resolution := {"cHWND": vars.hwnd.settings.custom_resolution, "current": vars.client.h, "list": StrSplit(Trim(vars.general.available_resolutions, "|"), "|", " "), "fSize": fSize, "color": cButtons}

	If (fullscreen = "true")
		Gui_Label(GUI, "ys x+0 w" fWidth * (StrLen(Lang_Trans("global_reset", 2)) + 1) " h" 2*fHeight - 2 " Center 0x200 gSettings_client2", Lang_Trans("global_reset", 2), "settings_reset resolution", "hwnd.settings.reset_resolution", [0, slop, 0, slop], radius,, cButtons)
	Else Gui_Label(GUI, "xs w" wResolution " Center gSettings_client2", Lang_Trans("m_general_borderless", 2), "settings_window borders", "hwnd.settings.remove_borders", slop,,, cButtons, vars.client.borderless)

	If vars.general.safe_mode
		Return

	WinGetPos,,, wCheck, hCheck, ahk_group poe_window
	If (wCheck < vars.monitor.w || hCheck < vars.monitor.h)
	{
		Gui_Label(GUI, "Section ys" (fullscreen = "true" ? " x+" xMargin - Max(vars.settings.line1, 6) : "") " w" wPosition " Center", Lang_Trans("m_general_position",,, 1),,, [slop, slop, 0, 0])
		If (wCheck < vars.monitor.w)
		{
			DDL := []
			For index, val in ["left", "center", "right"]
				DDL.Push(Lang_Trans("m_general_pos" val))
			Gui_Label(GUI, "xp y+0 w" wDock " Center gSettings_client2", DDL[vars.client.docked], "settings_window position", "hwnd.settings.dock", [0, 0, slop, 0],,, cButtons)
			vars.ddl.dock := {"cHWND": vars.hwnd.settings.dock, "current": DDL[vars.client.docked], "list": DDL.Clone(), "fSize": fSize, "color": cButtons}
		}
		Else Gui_Label(GUI, "xp y+0 w" wDock " Center", Lang_Trans("m_general_poscenter"), "settings_window position",, [0, 0, slop, 0],,, 0)

		If (hCheck < vars.monitor.h)
		{
			DDL := []
			For index, val in ["top", "center", "bottom", "taskbar"]
				DDL.Push(Lang_Trans("m_general_pos" val))
			Gui_Label(GUI, "x+0 yp w" wDock2 " Center gSettings_client2", DDL[vars.client.docked2], "settings_window position|", "hwnd.settings.dock2", [0, 0, 0, slop],,, cButtons)
			vars.ddl.dock2 := {"cHWND": vars.hwnd.settings.dock2, "current": DDL[vars.client.docked2], "list": DDL.Clone(), "fSize": fSize, "color": cButtons}
		}
		Else Gui_Label(GUI, "x+0 yp w" wDock2 " Center", Lang_Trans("m_general_poscenter"), "settings_window position|",, [0, 0, 0, slop],,, 0)
	}

	If settings.general.FillerAvailable
	{
		width := (settings.general.ClientFillerTaskbar && (vars.client.w < vars.monitor.w) ? Max(wFiller, wTaskbar + wSplit) : Max(wFiller, wTaskbar)), ClientFiller := settings.general.ClientFiller
		taskbar := settings.general.ClientFillerTaskbar, split := settings.general.ClientFillerSplit
		Gui_Label(GUI, "Section xs w" width " Center gSettings_client2", Lang_Trans("m_general_screenfiller"), "settings_client filler", "hwnd.settings.ClientFiller", (!ClientFiller ? slop : [slop, slop, 0, 0]),,, cButtons, ClientFiller)

		width := (taskbar && (vars.client.w < vars.monitor.w) ? "wp-" wSplit : "wp")
		Gui_Label(GUI, (ClientFiller ? "" : "Hidden ") "xp y+0 " width " Center gSettings_client2", Lang_Trans("m_general_postaskbar"), "settings_client filler taskbar", "hwnd.settings.ClientFillerTaskbar", [0, 0, slop, (slop && (!taskbar || vars.client.w >= vars.monitor.w))],,, cButtons, taskbar)

		If taskbar && (vars.client.w < vars.monitor.w)
			Gui_Label(GUI, "x+0 yp w" wSplit " Center gSettings_client2", Lang_Trans("m_general_screenfiller", 2), "settings_client filler split", "hwnd.settings.ClientFillerSplit", [0, 0, 0, slop],,, cButtons, split)
	}

	If (vars.client.h0 / vars.client.w0 < (5/12))
	{
		settings.general.blackbars := LLK_IniRead("ini" vars.poe_version "\config.ini", "Settings", "black-bar compensation", 0)
		Gui_Label(GUI, (fullscreen = "false" || settings.general.FillerAvailable ? "ys" : "Section xs") " Center gSettings_client2", " " Lang_Trans("m_general_ultrawidebars") " ", "settings_black bars", "hwnd.settings.blackbars", slop,,, cButtons, vars.settings.blackbars_provisional)
	}
}

Settings_client2(cHWND := "")
{
	local
	global vars, settings
	static char_wait

	check := LLK_HasVal(vars.hwnd.settings, cHWND), control := SubStr(check, InStr(check, "_") + 1), update := vars.update
	If !InStr(check, "reset_resolution")
		KeyWait, LButton

	Switch
	{
		Case (check = "logfolder"):
		Run, % "explore " SubStr(vars.log.file_location, 1, InStr(vars.log.file_location, "\",, 0) - 1)

		Case InStr(check, "inputmethod_"):
		IniWrite, % (settings.general.input_method := control), % "ini" vars.poe_version "\config.ini", settings, input method
		GuiControl, +cLime, % cHWND
		GuiControl, movedraw, % cHWND
		GuiControl, +cWhite, % vars.hwnd.settings["inputmethod_" (control = 1 ? 2 : 1)]
		GuiControl, movedraw, % vars.hwnd.settings["inputmethod_" (control = 1 ? 2 : 1)]
		index := LLK_HasVal(vars.imagesearch.search, "runeshaping", 1)
		If !Blank(index)
		{
			If (settings.general.input_method = 2)
				vars.imagesearch.search[index] := "runeshaping2"
			Else vars.imagesearch.search[index] := "runeshaping"
			Settings_menu()
		}

		Case (check = "apply"):
		width := (LLK_ControlGet(vars.hwnd.settings.custom_width) > vars.monitor.w) ? vars.monitor.w : LLK_ControlGet(vars.hwnd.settings.custom_width)
		height := LLK_ControlGet(vars.hwnd.settings.custom_resolution)
		If !IsNumber(height) || !IsNumber(width)
		{
			LLK_ToolTip(Lang_Trans("global_errorname", 2),,,,, "red")
			Return
		}
		horizontal := [], vertical := []
		For index, val in ["left", "center", "right"]
			horizontal.Push(Lang_Trans("m_general_pos" val))
		For index, val in ["top", "center", "bottom", "taskbar"]
			vertical.Push(Lang_Trans("m_general_pos" val))
		horizontal := LLK_HasVal(horizontal, LLK_ControlGet(vars.hwnd.settings.dock)), vertical := LLK_HasVal(vertical, LLK_ControlGet(vars.hwnd.settings.dock2))
		IniWrite, % (IsNumber(horizontal) ? horizontal : 2), % "ini" vars.poe_version "\config.ini", Settings, window-position
		IniWrite, % (IsNumber(vertical) ? vertical : 1), % "ini" vars.poe_version "\config.ini", Settings, window-position vertical
		IniWrite, % height, % "ini" vars.poe_version "\config.ini", Settings, custom-resolution
		IniWrite, % width, % "ini" vars.poe_version "\config.ini", Settings, custom-width
		IniWrite, % vars.settings.borderless_provisional, % "ini" vars.poe_version "\config.ini", settings, remove window-borders
		IniWrite, % vars.settings.blackbars_provisional, % "ini" vars.poe_version "\config.ini", Settings, black-bar compensation
		IniWrite, % vars.settings.active, % "ini" vars.poe_version "\config.ini", Versions, reload settings
		Reload
		ExitApp

		Case (check = "blackbars"):
		vars.settings.blackbars_provisional := !vars.settings.blackbars_provisional
		GuiControl, % "+c" (vars.settings.blackbars_provisional ? "Lime" : "Gray"), % cHWND
		GuiControl, % "movedraw", % cHWND
		GuiControl, -Hidden, % vars.hwnd.settings.apply
		GuiControl, -Hidden, % vars.hwnd.settings.apply_bar

		Case RegexMatch(check, "i)custom_(width|resolution)|dock2{0,1}$"):
		If InStr("custom_resolution,dock2", check)
			If Blank(input := Gui_DropDownList(vars.ddl[check], LLK_WinGetPos(cHWND, "array"), "Center"))
				Return
		GuiControl, -Hidden, % vars.hwnd.settings.apply
		GuiControl, -Hidden, % vars.hwnd.settings.apply_bar

		Case (check = "reset_resolution"):
		If (vars.system.click = 1) && LLK_Progress(vars.hwnd.settings.reset_resolution_bar, "LButton")
		{
			IniWrite, % vars.monitor.h, % "ini" vars.poe_version "\config.ini", Settings, custom-resolution
			IniWrite, % vars.monitor.w, % "ini" vars.poe_version "\config.ini", Settings, custom-width
			IniWrite, % vars.settings.active, % "ini" vars.poe_version "\config.ini", Versions, reload settings
			Reload
			ExitApp
		}

		Case (check = "remove_borders"):
		state := (vars.settings.borderless_provisional := !vars.settings.borderless_provisional), ddl_state := LLK_ControlGet(vars.hwnd.settings.custom_resolution), ddl := []
		For key in vars.general.supported_resolutions
			If state && (key <= vars.monitor.h) || !state && (key < vars.monitor.h)
				ddl.InsertAt(1, key)
		If !LLK_HasVal(ddl, ddl_state)
			ddl_state := ddl.1
		vars.ddl.custom_resolution.list := ddl.Clone()
		GuiControl, Text, % vars.hwnd.settings.custom_resolution, % ddl_state
		GuiControl, -Hidden, % vars.hwnd.settings.apply
		GuiControl, -Hidden, % vars.hwnd.settings.apply_bar
		GuiControl, % "+c" (state ? "Lime" : "Gray"), % cHWND
		GuiControl, % "movedraw", % cHWND

		Case (check = "ClientFiller"):
		IniWrite, % (settings.general.ClientFiller := !settings.general.ClientFiller), % "ini" vars.poe_version "\config.ini", Settings, client background filler
		If !settings.general.ClientFiller
		{
			Gui, ClientFiller: Destroy
			IniWrite, % (settings.general.ClientFillerTaskbar := 0), % "ini" vars.poe_version "\config.ini", Settings, cover taskbar
			IniWrite, % (settings.general.ClientFillerSplit := 0), % "ini" vars.poe_version "\config.ini", Settings, split-screen mode
		}
		Else
		{
			Gui_ClientFiller()
			WinActivate, % "ahk_id " vars.hwnd.poe_client
		}
		Settings_menu("client")

		Case (check = "ClientFillerTaskbar"):
		IniWrite, % (settings.general.ClientFillerTaskbar := !settings.general.ClientFillerTaskbar), % "ini" vars.poe_version "\config.ini", Settings, cover taskbar
		If !settings.general.ClientFillerTaskbar
			IniWrite, % (settings.general.ClientFillerSplit := 0), % "ini" vars.poe_version "\config.ini", Settings, split-screen mode
		Gui_ClientFiller()
		WinActivate, % "ahk_id " vars.hwnd.poe_client
		Settings_menu("client")

		Case (check = "ClientFillerSplit"):
		IniWrite, % (settings.general.ClientFillerSplit := !settings.general.ClientFillersplit), % "ini" vars.poe_version "\config.ini", Settings, split-screen mode
		GuiControl, % "+c" (settings.general.ClientFillerSplit ? "Lime" : "Gray"), % cHWND
		GuiControl, % "movedraw", % cHWND
		Gui_ClientFiller()
		WinActivate, % "ahk_id " vars.hwnd.poe_client

		Case !Blank(check):
		LLK_ToolTip("no action")
	}
}

Settings_cloneframes()
{
	local
	global vars, settings
	static fSize, wDDL, wEdit, wCoords

	Init_cloneframes()
	GUI := "settings_menu" vars.settings.GUI_toggle, x_anchor := vars.settings.x_anchor, xMargin := settings.general.fWidth * 0.75

	Gui, %GUI%: Add, Text, % "Section x" x_anchor " y" vars.settings.ySelection " Border BackgroundTrans HWNDhwnd gURL cAqua", % " wiki page "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.URLs := {}, vars.URLs[hwnd] := "https://github.com/Lailloken/Exile-UI/wiki/Clone-frames", vars.hwnd.help_tooltips["settings_website"] := hwnd1

	If vars.general.MultiThreading && (vars.cloneframes.list.Count() > 1)
	{
		Gui, %GUI%: Font, bold underline
		Gui, %GUI%: Add, Text, % "xs Section y+"vars.settings.spacing, % Lang_Trans("m_clone_performance")
		Gui, %GUI%: Font, norm
		Gui, %GUI%: Add, Pic, % "ys HWNDhwnd hp w-1", % "HBitmap:*" vars.pics.global.help
		vars.hwnd.help_tooltips["settings_cloneframes performance"] := hwnd
		For index, val in ["low", "normal", "high", "max"]
		{
			Gui, %GUI%: Add, Text, % (index = 1 ? "xs Section" : "ys ") " HWNDhwnd Border BackgroundTrans gSettings_cloneframes2" (index = settings.cloneframes.speed ? " cLime" : "")
			, % " " Lang_Trans("m_clone_performance", 2 + index) " (" (index = 3 ? 20 : (index = 4 ? 30 : index * 5)) ") "
			Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
			vars.hwnd.settings["performance_" index] := hwnd
		}
		Gui, %GUI%: Add, Text, % "xs Section", % Lang_Trans("m_clone_performance", 2)
		Gui, %GUI%: Add, Text, % "ys x+0 HWNDhwnd", % "100"
		vars.hwnd.settings.fps := hwnd
	}

	If (fSize != settings.general.fSize)
	{
		fSize := settings.general.fSize
		LLK_PanelDimensions([Lang_Trans("global_inventory"), Lang_Trans("m_screen_gamescreen")], fSize, wHeaders, hHeaders,,, 0)
		LLK_PanelDimensions([Lang_Trans("global_ignore"), Lang_Trans("global_hide"), Lang_Trans("global_show")], fSize - 2, wDDL, hDDL)
		LLK_PanelDimensions([Lang_Trans("global_edit")], fSize, wEdit, hEdit)
		LLK_PanelDimensions([Lang_Trans("global_coordinates"), Lang_Trans("global_width") "/" Lang_Trans("global_height")], settings.general.fSize, wCoords, hCoords)
		wDDL := Max(wDDL, wHeaders)
	}

	wMax := settings.general.fWidth * (vars.cloneframes.list.Count() = 1 ? vars.settings.min_width : 20)
	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "xs Section HWNDhwnd y+" vars.settings.spacing, % Lang_Trans("m_clone_list")
	ControlGetPos, xHeader, yHeader, wHeader, hHeader,, % "ahk_id " hwnd

	Gui, %GUI%: Font, % "norm s"settings.general.fSize - 4
	Gui, %GUI%: Add, Text, % "Section xs w" Max(wMax, wHeader) " hp Border BackgroundTrans"
	Gui, %GUI%: Add, Edit, % "xp yp wp hp Border cBlack HWNDhwnd"
	vars.hwnd.settings.name := hwnd, vars.hwnd.help_tooltips["settings_cloneframes new"] := hwnd
	ControlGetPos, xLast, yLast, wLast, hLast,, % "ahk_id " hwnd
	Gui, %GUI%: Add, Button, % "xp yp wp hp Hidden Default gSettings_cloneframes2 HWNDhwnd", % "ok"
	vars.hwnd.settings.add := hwnd
	Gui, %GUI%: Font, % "s"settings.general.fSize

	For cloneframe, val in vars.cloneframes.list
	{
		If (cloneframe = "settings_cloneframe")
			Continue

		Gui, %GUI%: Add, Text, % "Section xs Border BackgroundTrans Center gSettings_cloneframes2 HWNDhwnd w" wEdit, % Lang_Trans("global_edit")
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings["edit_" cloneframe] := hwnd, vars.hwnd.help_tooltips["settings_cloneframes edit" handle] := hwnd1

		Gui, %GUI%: Add, Text, % "ys hp x+-1 Border gSettings_cloneframes2 BackgroundTrans Center HWNDhwnd0 w" settings.general.fWidth*2, % "x"
		Gui, %GUI%: Add, Progress, % "xp yp wp hp Border Disabled range0-500 Vertical HWNDhwnd Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 500
		vars.hwnd.settings["del_" cloneframe] := hwnd0, vars.hwnd.settings["delbar_" cloneframe] := vars.hwnd.help_tooltips["settings_cloneframes delete" handle] := hwnd

		Gui, %GUI%: Font, % "s" settings.general.fSize - 4
		Gui, %GUI%: Add, Text, % "ys x+-1 wp hp Border BackgroundTrans"
		Gui, %GUI%: Add, Edit, % "xp yp wp hp Border gSettings_cloneframes2 cBlack Center Limit1 Number HWNDhwnd", % val.group
		vars.hwnd.settings["group_" cloneframe] := vars.hwnd.help_tooltips["settings_cloneframes groups" handle] := hwnd

		Gui, %GUI%: Font, % "s" settings.general.fSize - 2
		Gui, %GUI%: Add, Text, % "ys w" Max(wMax, wHeader) - wEdit - Round(settings.general.fWidth*4.75) + 2 " hp 0x200 -Wrap gSettings_cloneframes2 Border BackgroundTrans HWNDhwnd c" (val.enable ? "Lime" : "Gray"), % " " cloneframe
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings["enable_" cloneframe] := hwnd, vars.hwnd.help_tooltips["settings_cloneframes toggle" handle] := hwnd1, handle .= "|"
		ControlGetPos, xLast, yLast, wLast, hLast,, % "ahk_id " hwnd
		Gui, %GUI%: Font, % "s" settings.general.fSize
	}

	If (vars.cloneframes.list.Count() = 1)
		Return

	Gui, %GUI%: Add, Progress, % "Disabled Section BackgroundWhite x" xHeader + Max(wMax, wHeader) + xMargin " y" yHeader - 1 " w2 h" (hDivider := yLast + hLast - yHeader), 0
	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "Section ys", % Lang_Trans("m_clone_hide")
	Gui, %GUI%: Font, % "norm s" settings.general.fSize - 2
	Gui, %GUI%: Add, Text, % "ys hp 0x200 Border BackgroundTrans cLime gSettings_cloneframes2 HWNDhwnd", % " " Lang_Trans("global_" (settings.cloneframes.toggle = 1 ? "global" : "custom")) " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.toggle := hwnd, vars.hwnd.help_tooltips["settings_cloneframes toggle-info"] := hwnd1, handle := ""
	Gui, %GUI%: Font, % "s" settings.general.fSize

	Gui, %GUI%: Add, Text, % "Section xs HWNDhwnd Center w" wDDL, % Lang_Trans("global_inventory")
	ControlGetPos, xHeader1, yHeader1, wHeader1, hHeader1,, % "ahk_id " hwnd
	Gui, %GUI%: Font, % "s" settings.general.fSize - 2
	For key, val in (settings.cloneframes.toggle = 2 ? vars.cloneframes.list : {"global": {"inventory": settings.cloneframes.inventory}})
	{
		If (key = "settings_cloneframe")
			Continue
		DDL := [Lang_Trans("global_ignore"), Lang_Trans("global_hide"), Lang_Trans("global_show")]
		Gui, %GUI%: Add, Text, % "xs wp h" settings.general.fHeight " Center 0x200 Border BackgroundTrans HWNDhwnd gSettings_cloneframes2 cLime", % DDL[val.inventory + 1]
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.ddl["inventory_" key] := {"cHWND": hwnd, "current": DDL[val.inventory + 1], "list": DDL.Clone(), "fSize": fSize - 2, "color": vars.settings.cButtons}
		ControlGetPos, xLast1, yLast1, wLast1, hLast1,, % "ahk_id " hwnd
		vars.hwnd.settings["inventory_" key] := hwnd, vars.hwnd.help_tooltips["settings_cloneframes toggle-modes" handle] := hwnd1, handle .= "|"
	}
	Gui, %GUI%: Font, % "s" settings.general.fSize

	Gui, %GUI%: Add, Progress, % "Disabled Section ys BackgroundWhite w2 h" yLast1 + hLast1 - (yHeader + hHeader) - settings.general.fHeight/4, 0
	Gui, %GUI%: Add, Text, % "Section ys Center HWNDhwnd_info w" wDDL, % Lang_Trans("m_screen_gamescreen")
	ControlGetPos, xInfo, yInfo, wInfo, hInfo,, % "ahk_id " hwnd_info
	Gui, %GUI%: Font, % "s" settings.general.fSize - 2
	For key, val in (settings.cloneframes.toggle = 2 ? vars.cloneframes.list : {"global": {"gamescreen": settings.cloneframes.gamescreen}})
	{
		If (key = "settings_cloneframe")
			Continue

		DDL := [Lang_Trans("global_ignore"), Lang_Trans("global_hide"), Lang_Trans("global_show")]
		Gui, %GUI%: Add, Text, % "xs wp h" settings.general.fHeight " Center 0x200 Border BackgroundTrans HWNDhwnd gSettings_cloneframes2 cLime", % DDL[val.gamescreen + 1]
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.ddl["gamescreen_" key] := {"cHWND": hwnd, "current": DDL[val.gamescreen + 1], "list": DDL.Clone(), "fSize": fSize - 2, "color": vars.settings.cButtons}
		handle .= "|", vars.hwnd.settings["gamescreen_" key] := hwnd, vars.hwnd.help_tooltips["settings_cloneframes toggle-modes" handle] := hwnd1
	}

	If vars.poe_version
	{
		Gui, %GUI%: Font, % "s" settings.general.fSize - 2
		Gui, %GUI%: Add, Text, % "Section xs x" xHeader1 - 1 " y+" settings.general.fWidth/2 " w" xInfo + wInfo - xHeader1 " hp 0x200 Center Border BackgroundTrans HWNDhwnd gSettings_cloneframes2" (settings.cloneframes.closebutton_toggle ? " cLime" : " cGray"), % " " Lang_Trans("m_clone_closetoggle") " "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings.closebutton_toggle := hwnd, vars.hwnd.help_tooltips["settings_cloneframes close button toggle"] := hwnd1
	}
	Gui, %GUI%: Font, % "s" settings.general.fSize

	Gui, %GUI%: Font, % "cAqua bold s" settings.general.fSize - 2
	Gui, %GUI%: Add, Text, % "Section xs x" x_anchor . (vars.poe_version ? "" : " y" yLast + hLast + settings.general.fWidth/2) " w" (xInfo + wInfo - x_anchor), % Lang_Trans("m_clone_town")
	Gui, %GUI%: Font, % "cWhite norm s" settings.general.fSize

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "xs Section x" x_anchor " HWNDhwnd y+" vars.settings.spacing, % Lang_Trans("m_clone_editing")
	colors := ["3399FF", "Yellow", "DC3220"], handle := "", vars.hwnd.settings.edit_text := vars.hwnd.help_tooltips["settings_cloneframes corners"handle] := hwnd
	Gui, %GUI%: Font, norm
	For index, val in vars.lang.global_mouse
	{
		Gui, %GUI%: Add, Text, % "ys x+"settings.general.fWidth/2 " hp 0x200 Center BackgroundTrans Border cBlack w"settings.general.fWidth*3, % val
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border BackgroundBlack HWNDhwnd c"colors[index], 100
		handle .= "|", vars.hwnd.help_tooltips["settings_cloneframes corners"handle] := hwnd
	}
	Gui, %GUI%: Add, Text, % "xs Section c3399FF", % Lang_Trans("global_coordinates") ":"
	Gui, %GUI%: Font, % "s" settings.general.fSize - 4
	Gui, %GUI%: Add, Edit, % "ys x" x_anchor + wCoords " hp Border Disabled Number cBlack Right gCloneframes_SettingsApply HWNDhwnd w"settings.general.fWidth*4, % vars.client.x + 4 - vars.monitor.x
	vars.hwnd.settings.xSource := vars.cloneframes.scroll.xSource := vars.hwnd.help_tooltips["settings_cloneframes scroll"] := hwnd
	Gui, %GUI%: Add, Edit, % "ys x+"settings.general.fWidth/4 " hp Border Disabled Number cBlack Right gCloneframes_SettingsApply HWNDhwnd w"settings.general.fWidth*4, % vars.client.y + 4 - vars.monitor.y
	vars.hwnd.settings.ySource := vars.cloneframes.scroll.ySource := vars.hwnd.help_tooltips["settings_cloneframes scroll|"] := hwnd
	Gui, %GUI%: Font, % "s"settings.general.fSize

	Gui, %GUI%: Add, Text, % "ys", % Lang_Trans("m_clone_scale")
	Gui, %GUI%: Font, % "s"settings.general.fSize - 4
	Gui, %GUI%: Add, Edit, % "ys x+" settings.general.fWidth/2 " hp Border Disabled Number cBlack Right gCloneframes_SettingsApply HWNDhwnd w"settings.general.fWidth*3, 100
	vars.hwnd.settings.xScale := vars.cloneframes.scroll.xScale := vars.hwnd.help_tooltips["settings_cloneframes scroll||||||"] := hwnd
	Gui, %GUI%: Add, Edit, % "ys x+"settings.general.fWidth/4 " hp Border Disabled Number cBlack Right gCloneframes_SettingsApply HWNDhwnd w"settings.general.fWidth*3, 100
	vars.hwnd.settings.yScale := vars.cloneframes.scroll.yScale := vars.hwnd.help_tooltips["settings_cloneframes scroll|||||||"] := hwnd
	Gui, %GUI%: Font, % "s"settings.general.fSize

	Gui, %GUI%: Add, Text, % "xs Section cYellow", % Lang_Trans("global_coordinates") ":"
	Gui, %GUI%: Font, % "s"settings.general.fSize - 4
	Gui, %GUI%: Add, Edit, % "ys x" x_anchor + wCoords " hp Border Disabled Number cBlack Right gCloneframes_SettingsApply HWNDhwnd w"settings.general.fWidth*4, % Format("{:0.0f}", vars.client.xc - 100)
	vars.hwnd.settings.xTarget := vars.cloneframes.scroll.xTarget := vars.hwnd.help_tooltips["settings_cloneframes scroll||||"] := hwnd
	Gui, %GUI%: Add, Edit, % "ys x+"settings.general.fWidth/4 " hp Border Disabled Number cBlack Right gCloneframes_SettingsApply HWNDhwnd w"settings.general.fWidth*4, % vars.client.y + 13 - vars.monitor.y
	vars.hwnd.settings.yTarget := vars.cloneframes.scroll.yTarget := vars.hwnd.help_tooltips["settings_cloneframes scroll|||||"] := hwnd
	Gui, %GUI%: Font, % "s"settings.general.fSize

	Gui, %GUI%: Add, Text, % "ys", % Lang_Trans("global_opacity")
	Gui, %GUI%: Add, Text, % "ys x+" settings.general.fWidth/2 " 0x200 hp Border BackgroundTrans Center HWNDhwnd w"settings.general.fWidth*2, 5
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background404040 cBlack", 100
	vars.hwnd.settings.opacity := hwnd, vars.cloneframes.scroll.opacity := vars.hwnd.help_tooltips["settings_cloneframes scroll||||||||"] := hwnd1

	Gui, %GUI%: Add, Text, % "xs Section cDC3220", % Lang_Trans("global_width") "/" Lang_Trans("global_height") ":"
	Gui, %GUI%: Font, % "s"settings.general.fSize - 4
	Gui, %GUI%: Add, Edit, % "ys x" x_anchor + wCoords " hp Border Disabled Number cBlack Right gCloneframes_SettingsApply HWNDhwnd w"settings.general.fWidth*4, % 200
	vars.hwnd.settings.width := vars.cloneframes.scroll.width := vars.hwnd.help_tooltips["settings_cloneframes scroll||"] := hwnd
	Gui, %GUI%: Add, Edit, % "ys x+"settings.general.fWidth/4 " hp Border Disabled Number cBlack Right gCloneframes_SettingsApply HWNDhwnd w"settings.general.fWidth*4, % 200
	vars.hwnd.settings.height := vars.cloneframes.scroll.height := vars.hwnd.help_tooltips["settings_cloneframes scroll|||"] := hwnd
	Gui, %GUI%: Font, % "s"settings.general.fSize

	Gui, %GUI%: Add, Text, % "xs Section cGray Border BackgroundTrans HWNDhwnd", % " " Lang_Trans("global_save") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.save := hwnd
	Gui, %GUI%: Add, Text, % "ys x+"settings.general.fWidth/4 " cGray Border BackgroundTrans HWNDhwnd", % " " Lang_Trans("global_discard") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.discard := hwnd
}

Settings_cloneframes2(cHWND)
{
	local
	global vars, settings, json

	check := LLK_HasVal(vars.hwnd.settings, cHWND), control := SubStr(check, InStr(check, "_") + 1), name := vars.cloneframes.editing
	If !InStr(check, "del_")
		KeyWait, LButton

	If InStr(check, "performance_")
	{
		IniWrite, % (settings.cloneframes.speed := speed := control), % "ini" vars.poe_version "\clone frames.ini", settings, performance
		Loop 4
		{
			GuiControl, % "+c" (A_Index = speed ? "Lime" : "White"), % vars.hwnd.settings["performance_" A_Index]
			GuiControl, % "movedraw", % vars.hwnd.settings["performance_" A_Index]
		}
		settings.cloneframes.fps := 1000//vars.cloneframes.intervals[speed], Cloneframes_Thread(1, control)
	}
	Else If (check = "add")
		Cloneframes_SettingsAdd()
	Else If InStr(check, "edit_")
	{
		Cloneframes_SettingsRefresh(control)
		For key, hwnd in vars.hwnd.settings
			If InStr(key, "group_")
				GuiControl, Disable, % hwnd
	}
	Else If InStr(check, "del_")
	{
		If vars.cloneframes.editing
		{
			LLK_ToolTip(Lang_Trans("m_clone_exitedit"), 1.5,,,, "red")
			Return
		}
		If (vars.system.click = 1) && LLK_Progress(vars.hwnd.settings["delbar_"control], "LButton", cHWND,, 500, "Red", vars.settings.cButtons)
		{
			IniDelete, % "ini" vars.poe_version "\clone frames.ini", % control
			Settings_menu("clone-frames"), Cloneframes_Thread(), Settings_ScreenChecksValid()
		}
		Else Return
	}
	Else If InStr(check, "group_")
	{
		IniWrite, % (vars.cloneframes.list[control].group := LLK_ControlGet(cHWND)), % "ini" vars.poe_version "\clone frames.ini", % control, group
		Cloneframes_Thread()
	}
	Else If InStr(check, "enable_")
	{
		If vars.cloneframes.editing
		{
			LLK_ToolTip(Lang_Trans("m_clone_exitedit"), 1.5,,,, "red")
			GuiControl,, % cHWND, % vars.cloneframes.list[control].enable
			Return
		}
		IniWrite, % (vars.cloneframes.list[control].enable := !vars.cloneframes.list[control].enable), % "ini" vars.poe_version "\clone frames.ini", % control, enable
		GuiControl, % "+c" (vars.cloneframes.list[control].enable ? "Lime" : "Gray"), % cHWND
		GuiControl, movedraw, % cHWND
		Init_cloneframes(), Cloneframes_Thread(), Settings_ScreenChecksValid()
		GuiControl, % "+c" (!vars.cloneframes.enabled ? "Gray" : "White"), % vars.hwnd.settings["clone-frames"]
		GuiControl, % "movedraw", % vars.hwnd.settings["clone-frames"]
	}
	Else If (check = "toggle")
	{
		IniWrite, % (settings.cloneframes.toggle := (settings.cloneframes.toggle = 1 ? 2 : 1)), % "ini" vars.poe_version "\clone frames.ini", settings, toggle
		Settings_menu("clone-frames"), Cloneframes_Thread(), Settings_ScreenChecksValid()
	}
	Else If RegexMatch(check, "i)inventory_|gamescreen_")
	{
		If Blank(input := Gui_DropDownList(vars.ddl[check], LLK_WinGetPos(cHWND, "array"), "Center", 1)) || IsObject(input) && Blank(input.1 . input.2)
			Return

		vars.ddl[check].current := input.1
		If (control = "global")
			IniWrite, % input.2 - 1, % "ini" vars.poe_version "\clone frames.ini", settings, % (InStr(check, "inventory") ? "inventory" : "gamescreen") " toggle"
		Else IniWrite, % input.2 - 1, % "ini" vars.poe_version "\clone frames.ini", % control, % (InStr(check, "inventory") ? "inventory" : "gamescreen") " toggle"
	}
	Else If (check = "closebutton_toggle")
	{
		IniWrite, % (settings.cloneframes.closebutton_toggle := !settings.cloneframes.closebutton_toggle), % "ini" vars.poe_version "\clone frames.ini", settings, close button toggle
		Cloneframes_SettingsRefresh()
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
		Init_cloneframes(), Cloneframes_Thread(), Settings_ScreenChecksValid()
}

Settings_donations()
{
	local
	global vars, settings, JSON
	static last_update, live_list, patterns := [["000000", "F99619"], ["000000", "F05A23"], ["FFFFFF", "F05A23"], ["Red", "FFFFFF"]], placeholder := "these are placeholders, not actual donations:`ncouldn't download the list"

	If !vars.settings.donations
		vars.settings.donations := {"Le Toucan": [1, ["june 17, 2024:`ni have arrived. caw, caw"]], "Lightwoods": [4, ["december 23, 2015:`ni can offer you 2 exalted orbs for your mirror", "december 23, 2015:`nsince i'm feeling happy today, i'll give you some maps on top", "december 23, 2015:`n<necropolis map> 5 of these?"]], "Average Redditor": [1, ["june 18, 2024:`nbruh, just enjoy the game"]], "Sanest Redditor": [3, ["august 5, 2023:`nyassss keep making more powerful and intrusive tools so ggg finally bans all ahk scripts"]], "ILoveLootsy": [2, ["february 1, 2016:`ndang yo"]]}

	If (last_update + 120000 < A_TickCount)
	{
		Try donations_new := HTTPtoVar("https://raw.githubusercontent.com/Lailloken/Exile-UI/misc/donations.json")
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

	LLK_PanelDimensions(dimensions, settings.general.fSize - 2, width, height), columns := 4, slop := settings.general.slop, cButtons := settings.general.cButtons
	GUI := "settings_menu" vars.settings.GUI_toggle, x_anchor := vars.settings.x_anchor
	hwnd := Gui_Label(GUI, "Section x" x_anchor " y" vars.settings.ySelection " gURL cAqua", " more info ", "settings_donations howto",, slop,,, cButtons)
	vars.URLs := {(hwnd.text): "https://github.com/Lailloken/Exile-UI/discussions/407"}

	hwnd := Gui_Label(GUI, "ys gURL cAqua", " ko-fi.com ", "settings_donations kofi",, slop,,, cButtons), vars.URLs[hwnd.text] := "https://ko-fi.com/lailloken"

	Gui, %GUI%: Add, Text, % "Section xs y+" vars.settings.spacing " BackgroundTrans", % "special thanks to these exiles who help me stay sane:"
	Gui, %GUI%: Font, % "s" settings.general.fSize - 2
	For key, val in vars.settings.donations
	{
		pos := (A_Index = 1) || !Mod(A_Index - 1, columns) ? "xs Section" : "ys"
		Gui, %GUI%: Add, Text, % pos " Center Border HWNDhwnd BackgroundTrans w" width " h" height " c" patterns[val.1].1 . (!InStr(key, "`n") ? " 0x200" : ""), % StrReplace(key, "|")
		Gui, %GUI%: Add, Progress, % "xp+3 yp+3 wp-6 hp-6 Disabled HWNDhwnd Background" patterns[val.1].2, 0
		Gui, %GUI%: Add, Progress, % "xp-3 yp-3 wp+6 hp+6 Disabled Background" patterns[val.1].1, 0
		vars.hwnd.help_tooltips["donation_" key] := hwnd
	}
	Gui, %GUI%: Font, % "s" settings.general.fSize
	If !live_list
		Gui, %GUI%: Add, Text, % "xs Section cAqua y+" vars.settings.spacing, % placeholder
}

Settings_exchange()
{
	local
	global vars, settings

	GUI := "settings_menu" vars.settings.GUI_toggle, x_anchor := vars.settings.x_anchor, xMargin := settings.general.fWidth * 0.75

	Gui, %GUI%: Add, Text, % "Section x" x_anchor " y" vars.settings.ySelection " Border BackgroundTrans HWNDhwnd gURL cAqua", % " wiki page "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.URLs := {}, vars.URLs[hwnd] := "https://github.com/Lailloken/Exile-UI/wiki/Vaal-Street", vars.hwnd.help_tooltips["settings_website"] := hwnd1

	Gui, %GUI%: Add, Text, % "Section xs y+" vars.settings.spacing " Border BackgroundTrans HWNDhwnd gSettings_exchange2" (settings.features.exchange ? " cLime" : " cGray"), % " " Lang_Trans("global_enable") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	Gui, %GUI%: Add, Text, % "ys hp 0x200 HWNDhwnd2" (settings.features.exchange ? "" : " cGray"), % Lang_Trans("m_exchange_currency")
	vars.hwnd.settings.enable := hwnd, vars.hwnd.help_tooltips["settings_exchange enable"] := hwnd1, vars.hwnd.help_tooltips["settings_exchange enable|"] := hwnd2

	If settings.features.exchange
	{
		Gui, %GUI%: Add, Text, % "Section xs y+0 w2 h" vars.settings.line1 " Border HWNDhwnd_brace"

		Gui, %GUI%: Add, Text, % "Section ys y+0 Border BackgroundTrans", % " " Lang_Trans("global_font") " "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border Background404040 cBlack", 100
		Gui, %GUI%: Add, Text, % "ys x+-1 Center Border BackgroundTrans gSettings_exchange2 HWNDhwnd w"settings.general.fWidth*2, % "–"
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.help_tooltips["settings_font-size"] := hwnd0, vars.hwnd.settings.font_minus := hwnd, vars.hwnd.help_tooltips["settings_font-size|"] := hwnd1

		Gui, %GUI%: Add, Text, % "ys x+-1 Center Border BackgroundTrans gSettings_exchange2 HWNDhwnd w"settings.general.fWidth*3, % settings.exchange.fSize
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings.font_reset := hwnd, vars.hwnd.help_tooltips["settings_font-size||"] := hwnd1

		Gui, %GUI%: Add, Text, % "ys x+-1 Center Border BackgroundTrans gSettings_exchange2 HWNDhwnd w"settings.general.fWidth*2, % "+"
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings.font_plus := hwnd, vars.hwnd.help_tooltips["settings_font-size|||"] := hwnd1

		Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans HWNDhwnd gSettings_exchange2" (settings.exchange.graphs ? " cLime" : " cGray"), % " " Lang_Trans("m_exchange_balance") " "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings.graphs := hwnd, vars.hwnd.help_tooltips["settings_exchange graphs"] := hwnd1

		count := vars.exchange.transactions.Count(), count1 := 0
		For date, array in vars.exchange.transactions
			count1 += array.Count()

		If (count * count1)
		{
			Gui, %GUI%: Add, Text, % "Section xs Border BackgroundTrans", % " " Lang_Trans("maptracker_logs") " " count " " Lang_Trans("global_day", (count > 1 ? 2 : 1)) ", " count1 " " Lang_Trans("global_trade", (count1 > 1 ? 2 : 1)) " "
			Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border Background404040 cBlack", 100
			Gui, %GUI%: Add, Text, % "ys x+-1 Border Center BackgroundTrans HWNDhwnd gSettings_exchange2", % " " Lang_Trans("global_delete") " "
			Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border Range0-500 Vertical HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 500
			vars.hwnd.settings.logs_delete := hwnd, vars.hwnd.help_tooltips["settings_exchange delete logs"] := vars.hwnd.settings.logs_delete_bar := hwnd1
		}

		Gui, %GUI%: Add, Text, % "Section xs x" vars.settings.x_anchor " w" settings.general.fWidth * 25 " h2 Border HWNDhwnd"
		GuiControl, movedraw, % hwnd_brace, % "h" LLK_ControlGetPos(hwnd, "y") - LLK_ControlGetPos(hwnd_brace, "y")
	}

	Gui, %GUI%: Add, Text, % "Section xs y+" vars.settings.spacing " Border BackgroundTrans HWNDhwnd gSettings_exchange2" (settings.features.async ? " cLime" : " cGray"), % " " Lang_Trans("global_enable") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	Gui, %GUI%: Add, Text, % "ys hp 0x200 HWNDhwnd2" (settings.features.async ? "" : " cGray"), % Lang_Trans("m_async_trade")
	vars.hwnd.settings.async_enable := hwnd, vars.hwnd.help_tooltips["settings_exchange async enable"] := hwnd1, vars.hwnd.help_tooltips["settings_exchange async enable|"] := hwnd2

	If settings.features.async
	{
		Gui, %GUI%: Add, Text, % "Section xs y+0 w2 h" vars.settings.line1 " Border HWNDhwnd_brace"
		Gui, %GUI%: Add, Text, % "Section ys y+0 Border BackgroundTrans", % " " Lang_Trans("m_async_minchange") " "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border Background404040 cBlack", 100
		Gui, %GUI%: Add, Text, % "ys x+-1 w" settings.general.fWidth*4 " Border BackgroundTrans HWNDhwnd1 gSettings_exchange2 Center", % settings.async.minchange "%"
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd2 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings.minchange := hwnd1, vars.hwnd.help_tooltips["settings_exchange async minchange"] := hwnd2

		Gui, %GUI%: Add, Text, % "Section xs Border BackgroundTrans gSettings_exchange2 HWNDhwnd" (settings.async.show_name ? " cLime" : " cGray"), % " " Lang_Trans("m_async_name") " "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings.async_name := hwnd, vars.hwnd.help_tooltips["settings_exchange async name"] := hwnd1

		Gui, %GUI%: Add, Text, % "Section xs x" vars.settings.x_anchor " w" settings.general.fWidth * 25 " h2 Border HWNDhwnd"
		GuiControl, movedraw, % hwnd_brace, % "h" LLK_ControlGetPos(hwnd, "y") - LLK_ControlGetPos(hwnd_brace, "y")
	}
}

Settings_exchange2(cHWND)
{
	local
	global vars, settings

	check := LLK_HasVal(vars.hwnd.settings, cHWND), control := SubStr(check, InStr(check, "_") + 1)
	If !RegexMatch(check, "i)font_|logs_delete|minchange")
		KeyWait, LButton

	If (check = "enable")
	{
		IniWrite, % (settings.features.exchange := !settings.features.exchange), % "ini" vars.poe_version "\config.ini", features, enable vaal street
		If WinExist("ahk_id " vars.hwnd.exchange.main)
			Exchange("close")
		Settings_menu("exchange")
	}
	Else If (check = "graphs")
	{
		IniWrite, % (settings.exchange.graphs := !settings.exchange.graphs), % "ini" vars.poe_version "\vaal street.ini", settings, % "show graphs"
		If vars.pics.exchange_trades.graph_day
			DeleteObject(vars.pics.exchange_trades.graph_day), vars.pics.exchange_trades.graph_day := ""
		If vars.pics.exchange_trades.graph_week
			DeleteObject(vars.pics.exchange_trades.graph_week), vars.pics.exchange_trades.graph_week := ""
		If WinExist("ahk_id " vars.hwnd.exchange.main)
			Exchange()
		GuiControl, % "+c" (settings.exchange.graphs ? "Lime" : "Gray"), % cHWND
		GuiControl, % "movedraw", % cHWND
	}
	Else If (check = "logs_delete")
	{
		If (vars.system.click = 1) && LLK_Progress(vars.hwnd.settings[check "_bar"], "LButton",,, 500, "Red", vars.settings.cButtons)
		{
			For key, hbm in vars.pics.exchange_trades
				DeleteObject(hbm)
			FileRemoveDir, % "img\GUI\vaal street" vars.poe_version, 1
			vars.pics.exchange_trades := {}, vars.exchange.transactions := {}, vars.exchange.date := 0
			FileDelete, % "ini" vars.poe_version "\vaal street log.ini"
			If WinExist("ahk_id " vars.hwnd.exchange.main)
				Exchange()
			Settings_menu("exchange")
		}
		Else Return

		If vars.pics.exchange_trades.graph_day
			DeleteObject(vars.pics.exchange_trades.graph_day), vars.pics.exchange_trades.graph_day := ""
		If vars.pics.exchange_trades.graph_week
			DeleteObject(vars.pics.exchange_trades.graph_week), vars.pics.exchange_trades.graph_week := ""
	}
	Else If InStr(check, "font_")
	{
		While GetKeyState("LButton", "P")
		{
			If (control = "reset")
				settings.exchange.fSize := settings.general.fSize
			Else settings.exchange.fSize += (control = "minus") ? -1 : 1, settings.exchange.fSize := (settings.exchange.fSize < 6) ? 6 : settings.exchange.fSize
			GuiControl, Text, % vars.hwnd.settings.font_reset, % settings.exchange.fSize
			Sleep 150
		}
		IniWrite, % settings.exchange.fSize, % "ini" vars.poe_version "\vaal street.ini", settings, font-size
		LLK_FontDimensions(settings.exchange.fSize, height, width), settings.exchange.fWidth := width, settings.exchange.fHeight := height

		If WinExist("ahk_id " vars.hwnd.exchange.main)
			Exchange()
	}
	Else If (check = "async_enable")
	{
		IniWrite, % (settings.features.async := !settings.features.async), % "ini" vars.poe_version "\config.ini", features, enable async trade
		If WinExist("ahk_id " vars.hwnd.async.main)
			AsyncTrade("close")
		If WinExist("ahk_id " vars.hwnd.async_logs.main)
			AsyncTradeLogs("close")
		Settings_menu("exchange")
	}
	Else If (check = "async_name")
	{
		IniWrite, % (settings.async.show_name := !settings.async.show_name), % "ini" vars.poe_version "\vaal street.ini", settings async trade, show full name
		If WinExist("ahk_id " vars.hwnd.async.main)
			AsyncTrade()
		If WinExist("ahk_id " vars.hwnd.async_logs.main)
			AsyncTradeLogs()
		GuiControl, % "+c" (settings.async.show_name ? "Lime" : "Gray"), % cHWND
		GuiControl, % "movedraw", % cHWND
	}
	Else If (check = "minchange")
	{
		input := Gui_Slider(cHWND, [5, settings.async.minchange, 50], 20, ["", "%"], 5)
		IniWrite, % (settings.async.minchange := input), % "ini" vars.poe_version "\vaal street.ini", settings async trade, minimum price change
	}
	Else LLK_ToolTip("no action")
}

Settings_general()
{
	local
	global vars, settings
	static fSize, wTheme, wBlue, wGray, wChoc, wCustom, wContrast

	GUI := "settings_menu" vars.settings.GUI_toggle, x_anchor := vars.settings.x_anchor, cButtons := settings.general.cButtons, cButtons2 := settings.general.cButtons2, slop := settings.general.slop, dev := settings.general.dev
	fWidth := settings.general.fWidth, fHeight := settings.general.fHeight
	hwnd := Gui_Label(GUI, "Section x" x_anchor " y" vars.settings.ySelection " gURL cAqua", " wiki && setup guide ", "settings_website",, 1,,, cButtons), vars.URLs := {(hwnd.text): "https://github.com/Lailloken/Exile-UI/wiki"}

	If (fSize != settings.general.fSize)
	{
		fSize := settings.general.fSize
		LLK_PanelDimensions([Lang_Trans("global_theme"), Lang_Trans("global_design")], fSize, wTheme, hTheme)
		LLK_PanelDimensions([Lang_Trans("global_gray"), Lang_Trans("global_new")], fSize, wGray, hGray)
		LLK_PanelDimensions([Lang_Trans("global_blue"), Lang_Trans("global_old")], fSize, wBlue, hBlue)
		LLK_PanelDimensions([Lang_Trans("global_choc"), Lang_Trans("global_fill")], fSize, wChoc, hChoc)
		LLK_PanelDimensions([Lang_Trans("global_custom")], fSize, wCustom, hCustom)
		LLK_PanelDimensions([Lang_Trans("global_contrast")], fSize, wContrast, hAnimations)

		If (wContrast < wCustom + 2*fHeight)
			wContrast := wCustom + 2*fHeight
		Else wCustom := wContrast - 2*fHeight
	}

	DDL := []
	Loop, Files, data\*, R
		If (A_LoopFileName = "client.txt")
			parse := StrReplace(StrReplace(A_LoopFilePath, "data\"), "\client.txt"), DDL.Push(parse)
	If (dev || DDL.Count() > 1)
		Gui_Label(GUI, "ys", " " Lang_Trans("m_general_language",,, 1) " ", "settings_lang language",, [1, 0, 1, 0])
		, Gui_Label(GUI, "ys x+0 Center gSettings_general2 cLime", " " settings.general.lang " ", "settings_lang translators", "hwnd.settings.language", [0, 1, 0, 1],,, cButtons)
		, vars.ddl.lang_select := {"cHWND": hwnd, "current": settings.general.lang, "list": DDL.Clone(), "fSize": settings.general.fSize, "color": cButtons}

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "xs Section y+" vars.settings.spacing " BackgroundTrans", % Lang_Trans("m_general_settings")
	Gui, %GUI%: Font, norm

	multi := vars.general.MultiThreading
	Gui_Label(GUI, "Section xs", " " Lang_Trans("global_multithreading", 3,, 1) " ",,, [1, 0, 1, 0])
	Gui_Label(GUI, "ys x+0 gSettings_general2" (!settings.general.multithread_off && !multi ? " cFF8000" : (multi ? " cLime" : "")), " " Lang_Trans("global_multithreading") " ", "settings_multi-threading multi" (!settings.general.multithread_off && !multi ? " failed" : ""), "hwnd.settings.threads_0",,,, cButtons)
	Gui_Label(GUI, "ys x+0 gSettings_general2" (settings.general.multithread_off ? " cLime" : ""), " " Lang_Trans("global_multithreading", 2) " ", "settings_multi-threading single", "hwnd.settings.threads_1", [0, 1, 0, 1],,, cButtons)

	Gui_Label(GUI, "ys", " " Lang_Trans("m_general_autoclose",,, 1) " ",,, [1, 0, 1, 0])
	Gui_Label(GUI, "ys x+0 w" 3 * fWidth " Center gSettings_general2", settings.general.kill.2, "settings_kill time", "hwnd.settings.kill_timeout", [0, 1, 0, 1],,, cButtons, settings.general.kill.1)

	If !vars.poe_version
		Gui_Label(GUI, "Section xs gSettings_general2", " " Lang_Trans("m_general_browser") " ", "settings_browser features", "hwnd.settings.browser", 1,,, cButtons, settings.features.browser)
	Gui_Label(GUI, (vars.poe_version ? "Section xs" : "ys") " gSettings_general2", " " Lang_Trans("m_general_capslock") " ", "settings_capslock toggling", "hwnd.settings.capslock", 1,,, cButtons, settings.general.capslock)

	;If dev
	;	Gui_Label(GUI, "Section xs gSettings_general2", " dev branch ",, "hwnd.settings.dev_env", 1,,, cButtons, settings.general.dev_env)

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "Section x" vars.settings.x_anchor " y+" vars.settings.spacing " BackgroundTrans", % Lang_Trans("global_ui")
	Gui, %GUI%: Font, norm

	Gui_Label(GUI, "Section xs", " " Lang_Trans("global_font",,, 1) " ",,, [1, 0, 1, 0])
	Gui_Label(GUI, "ys x+0 w" fHeight " Center gSettings_general2", "–", "settings_font-size", "hwnd.settings.font_minus",,,, cButtons)
	Gui_Label(GUI, "ys x+0 w" 3 * fWidth " Center gSettings_general2", settings.general.fSize, "settings_font-size|", "hwnd.settings.font_reset",,,, cButtons)
	Gui_Label(GUI, "ys x+0 w" fHeight " Center gSettings_general2", "+", "settings_font-size||", "hwnd.settings.font_plus", [0, 1, 0, 1],,, cButtons)

	Gui_Label(GUI, "ys gSettings_general2", " " Lang_Trans("m_general_menuwidget",,, 1) " ",,, [1, 0, 1, 0])
	Gui_Label(GUI, "ys x+0 w" fHeight " Center gSettings_general2", "–", "settings_font-size|||", "hwnd.settings.toolbar_minus",,,, cButtons)
	Gui_Label(GUI, "ys x+0 w" 3 * fWidth " Center gSettings_general2", settings.general.sMenu, "settings_font-size||||", "hwnd.settings.toolbar_reset",,,, cButtons)
	Gui_Label(GUI, "ys x+0 w" fHeight " Center gSettings_general2", "+", "settings_font-size|||||", "hwnd.settings.toolbar_plus", [0, 1, 0, 1],,, cButtons)

	Gui_Label(GUI, "Section xs w" wTheme " Center", Lang_Trans("global_theme"),,, [slop, 0, 0, 0])
	Gui_Label(GUI, "ys x+0 w" wGray " Center gSettings_general2", Lang_Trans("global_gray"), "settings_themes", "hwnd.settings.theme_gray",,,, cButtons, [(settings.general.theme = "gray"), "White"])
	Gui_Label(GUI, "ys x+0 w" wBlue " Center gSettings_general2", Lang_Trans("global_blue"), "settings_themes|", "hwnd.settings.theme_blue",,,, cButtons, [(settings.general.theme = "blue"), "White"])
	Gui_Label(GUI, "ys x+0 w" wChoc " Center gSettings_general2", Lang_Trans("global_choc"), "settings_themes||", "hwnd.settings.theme_choc",,,, cButtons, [(settings.general.theme = "choc"), "White"])
	Gui_Label(GUI, "ys x+0 w" wCustom " Center gSettings_general2", Lang_Trans("global_custom"), "settings_themes custom", "hwnd.settings.theme_custom",,,, cButtons, [(settings.general.theme = "custom"), "White"])
	Gui_Label(GUI, "ys x+0 w" fHeight " gSettings_general2",, "settings_themes color1", "hwnd.settings.themecolor_1",,, "push 000000", settings.general.themecustom1)
	Gui_Label(GUI, "ys x+0 w" fHeight " gSettings_general2",, "settings_themes color2", "hwnd.settings.themecolor_2", [0, slop, 0, 0],, "push 000000", settings.general.themecustom2)

	Gui_Label(GUI, "Section xs y+0 w" wTheme " Center", Lang_Trans("global_design"),,, [0, 0, slop, 0])
	Gui_Label(GUI, "ys x+0 w" wGray " Center gSettings_general2", Lang_Trans("global_new"), "settings_themes new", "hwnd.settings.slop1",,,, cButtons, [slop, "White"])
	Gui_Label(GUI, "ys x+0 w" wBlue " Center gSettings_general2", Lang_Trans("global_old"), "settings_themes old", "hwnd.settings.slop0",,,, cButtons, [!slop, "White"])
	Gui_Label(GUI, "ys x+0 w" wChoc " Center gSettings_general2", Lang_Trans("global_fill"), "settings_fill", "hwnd.settings.fill",,,, cButtons, settings.general.fill)
	Gui_Label(GUI, "ys x+0 w" wContrast " Center gSettings_general2", Lang_Trans("global_contrast"), "settings_contrast", "hwnd.settings.contrast", [0, 0, 0, slop],,, cButtons, settings.general.contrast)

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "xs Section y+"vars.settings.spacing " BackgroundTrans", % Lang_Trans("m_general_charleague")
	Gui, %GUI%: Font, norm

	Settings_LeagueSelection(yCoord, width)
	If vars.log.file_location
		Settings_CharTracking("general", width, yCoord)

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "Section xs x" x_anchor . (vars.log.file_location ? " y+" vars.settings.spacing : " y" yCoord + vars.settings.spacing) " BackgroundTrans", % Lang_Trans("global_troubleshoot") . Lang_Trans("global_colon")
	Gui, %GUI%: Font, norm

	Gui_Label(GUI, "ys gSettings_WriteTest", " " Lang_Trans("m_general_start") " ", "settings_write permissions",, slop,,, cButtons)
	Gui, %GUI%: Add, Progress, % "Disabled ys x+0 w8 hp Vertical Range0-700 BackgroundBlack cGreen HWNDhwnd0", 0
	vars.hwnd.settings.bar_writetest := hwnd0
}

Settings_general2(cHWND := "")
{
	local
	global vars, settings
	static char_wait

	check := LLK_HasVal(vars.hwnd.settings, cHWND), control := SubStr(check, InStr(check, "_") + 1), update := vars.update
	If !RegExMatch(check, "i)winbar|font_|toolbar_|kill_timeout")
	{
		KeyWait, LButton
		KeyWait, RButton
	}

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
					Sleep 15
				}
				WinGetPos, xPos, yPos, w, h, % "ahk_id " vars.hwnd.settings.main
				vars.settings.x := xPos, vars.settings.y := yPos, vars.general.drag := 0
				Return
			}
		Case "dev_env":
			IniWrite, % (settings.general.dev_env := !settings.general.dev_env), % "ini" vars.poe_version "\config.ini", Settings, dev env
			GuiControl, % "+c" (settings.general.dev_env ? "Lime" : "Gray"), % cHWND
			GuiControl, % "movedraw", % cHWND
		Case "kill_timeout":
			input := Gui_Slider(cHWND, [0, settings.general.kill.2, 10], 20)
			IniWrite, % (settings.general.kill.1 := Blank(input) ? 0 : input), % "ini\config.ini", Settings, kill script		;these are still split into 2 for back-compat
			IniWrite, % (settings.general.kill.2 := Blank(input) ? 0 : input), % "ini\config.ini", Settings, kill-timeout
			GuiControl, % "+c" (input ? "Lime" : "Gray"), % cHWND
			GuiControl, % "movedraw", % cHWND
		Case "browser":
			settings.features.browser := !settings.features.browser
			IniWrite, % settings.features.browser, % "ini" vars.poe_version "\config.ini", settings, enable browser features
			GuiControl, % "+c" (settings.features.browser ? "Lime" : "Gray"), % cHWND
			GuiControl, % "movedraw", % cHWND
		Case "capslock":
			IniWrite, % !settings.general.capslock, % "ini" vars.poe_version "\config.ini", settings, enable capslock-toggling
			IniWrite, general, % "ini" vars.poe_version "\config.ini", versions, reload settings
			Reload
			ExitApp
		Case "animations":
			IniWrite, % (settings.general.animations := !settings.general.animations), % "ini" vars.poe_version "\config.ini", settings, animations
			GuiControl, % "+c" (settings.general.animations ? "Lime" : "Gray"), % cHWND
			GuiControl, % "movedraw", % cHWND
		Case "language":
			If Blank(input := Gui_DropDownList(vars.ddl.lang_select, LLK_WinGetPos(cHWND, "array"), "Center",, "Center"))
				Return
			IniWrite, % """" input """", % "ini" vars.poe_version "\config.ini", settings, language
			IniWrite, % vars.settings.active, % "ini" vars.poe_version "\config.ini", Versions, reload settings
			Reload
			ExitApp
		Case "fill":
			IniWrite, % (settings.general.fill := !settings.general.fill), % "ini\config.ini", settings, fill panels
			Settings_menu()
		Case "contrast":
			IniWrite, % (settings.general.contrast := !settings.general.contrast), % "ini\config.ini", settings, high contrast
			Settings_menu(), refresh_guide := 1
		Default:
			If InStr(check, "slop")
			{
				IniWrite, % (settings.general.slop := SubStr(check, 0)), % "ini\config.ini", settings, rounded corners ;store it globally, for both games
				Settings_menu()
			}
			Else If InStr(check, "threads_")
			{
				If (settings.general.multithread_off = control)
					Return
				IniWrite, % control, % "ini\config.ini", Settings, disable multi-threading
				IniWrite, % "general", % "ini" vars.poe_version "\config.ini", Versions, reload settings
				Reload
				ExitApp
			}
			Else If InStr(check, "font_")
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
				LLK_FontDimensions(settings.general.fSize, font_height, font_width), settings.general.fheight := font_height, settings.general.fwidth := font_width, settings.general.radius := Ceil((font_height - 2)/3)
				LLK_FontDimensions(settings.general.fSize - 4, font_height, font_width), settings.general.fheight2 := font_height, settings.general.fwidth2 := font_width, settings.general.radius2 := Ceil((font_height - 2)/3)
				IniWrite, % settings.general.fSize, % "ini" vars.poe_version "\config.ini", Settings, font-size
				For key, hbm in vars.pics.settings_lootfilter
					DeleteObject(hbm)
				vars.pics.settings_lootfilter := {}
				Settings_menu("general")
			}
			Else If InStr(check, "toolbar_")
			{
				While GetKeyState("LButton", "P")
				{
					If (control = "minus")
						settings.general.sMenu -= (settings.general.sMenu > 10) ? 1 : 0
					Else If (control = "reset")
						settings.general.sMenu := Max(settings.general.fSize, 10)
					Else settings.general.sMenu += 1
					GuiControl, text, % vars.hwnd.settings.toolbar_reset, % settings.general.sMenu
					Sleep 150
				}
				IniWrite, % settings.general.sMenu, % "ini" vars.poe_version "\config.ini", Settings, menu-widget size
				LLK_FontDimensions(settings.general.sMenu, height, width), settings.general.wMenu := width
				For key, hbm in vars.pics.radial.menu
					DeleteObject(hbm)
				vars.pics.radial.menu := {}
			}
			Else If InStr(check, "theme_")
			{
				If (vars.system.click = 2)
				{
					IniWrite, % (settings.general["themecustom1"] := settings.general.themes.custom.1 :=  settings.general.themes[control].1), % "ini\config.ini", settings, custom color 1
					IniWrite, % (settings.general["themecustom2"] := settings.general.themes.custom.2 :=  settings.general.themes[control].2), % "ini\config.ini", settings, custom color 2
				}
				Else IniWrite, % (settings.general.theme := theme := control), % "ini\config.ini", settings, theme
			}
			Else If InStr(check, "themecolor_")
			{
				If (vars.system.click = 2)
					rgb := settings.general["themecustom" control "_default"]
				Else If Blank(rgb := RGB_Picker(settings.general["themecustom" control]))
					Return
				IniWrite, % (settings.general.theme := "custom"), % "ini\config.ini", settings, theme
				IniWrite, % """" (settings.general["themecustom" control] := settings.general.themes.custom[control] := rgb) """", % "ini\config.ini", settings, % "custom color " control
			}
			Else LLK_ToolTip("no action")

			If InStr(check, "theme")
			{
				settings.general.cButtons := settings.general.themes[settings.general.theme].1, settings.general.cButtons2 := settings.general.themes[settings.general.theme].2
				settings.general.cDisabled := RGB_Middle(settings.general.cButtons,, 1), Settings_menu(), refresh_guide := 1
			}
	}
	If refresh_guide && LLK_Overlay(vars.hwnd.leveltracker.main, "check")
		Leveltracker_Progress(1)
}

Settings_hotkeys()
{
	local
	global vars, settings
	static fSize, wHotkeys, wHotkeys2, wMovekey, wCtrl

	If (fSize != settings.general.fSize)
	{
		fSize := settings.general.fSize
		LLK_PanelDimensions([Lang_Trans("m_hotkeys_omnikey_new",,, 1), Lang_Trans("m_hotkeys_widget",,, 1), Lang_Trans("m_hotkeys_menukey",,, 1), Lang_Trans("m_hotkeys_restartkey",,, 1)], fSize, wHotkeys, hHotkeys)
		LLK_PanelDimensions([Lang_Trans("m_hotkeys_omnikey_new",,, 1) " 2"], fSize, wHotkeys2, hHotkeys2)
		LLK_PanelDimensions([Lang_Trans("m_hotkeys_movekey",,, 1)], fSize, wMovekey, hMovekey)
		LLK_PanelDimensions([Lang_Trans("global_ctrl"), Lang_Trans("global_alt")], fSize, wCtrl, hCtrl), wCtrl := Max(wCtrl, 4*settings.general.fWidth)
	}

	GUI := "settings_menu" vars.settings.GUI_toggle, x_anchor := vars.settings.x_anchor, wEdits := 2*wCtrl, slop := settings.general.slop, cButtons := settings.general.cButtons, radius := settings.general.radius
	vars.settings.tabblock_provisional := settings.hotkeys.tabblock, vars.settings.emergencykey_ctrl_provisional := settings.hotkeys.emergencykey_ctrl, vars.settings.emergencykey_alt_provisional := settings.hotkeys.emergencykey_alt
	fWidth := settings.general.fWidth, fHeight := settings.general.fHeight, spacing := vars.settings.spacing, rebound_c := settings.hotkeys.rebound_c

	hwnd := Gui_Label(GUI, "Section x" x_anchor " y" vars.settings.ySelection " gURL cAqua", " ahk: key list ", "settings_website",, slop,,, cButtons), vars.URLs := {(hwnd.text): "https://www.autohotkey.com/docs/v1/KeyList.htm"}
	hwnd := Gui_Label(GUI, "ys gURL cAqua", " ahk: formatting ", "settings_website|",, slop,,, cButtons), vars.URLs[hwnd.text] := "https://www.autohotkey.com/docs/v1/Hotkeys.htm"

	If !vars.client.stream || settings.features.leveltracker
	{
		Gui, %GUI%: Font, bold underline
		Gui, %GUI%: Add, Text, % "xs Section y+"vars.settings.spacing " BackgroundTrans", % Lang_Trans("m_hotkeys_settings")
		Gui, %GUI%: Add, Pic, % "ys hp w-1 BackgroundTrans HWNDhwnd0", % "HBitmap:*" vars.pics.global.help
		Gui, %GUI%: Font, norm
		vars.hwnd.help_tooltips["settings_hotkeys ingame-keybinds"] := hwnd0
	}

	If !vars.client.stream
		Gui_Label(GUI, "Section xs gSettings_hotkeys2", " " Lang_Trans("m_hotkeys_ckey2") " ",, "hwnd.settings.rebound_c", slop,, (rebound_c ? "insert 00FFFF" : ""), cButtons, rebound_c)

	If (settings.features.leveltracker * settings.leveltracker.fade * settings.leveltracker.fade_hover)
	{
		Gui_Label(GUI, "Section xs w" Max(wMovekey, wHotkeys, (rebound_c ? wHotkeys2 : 0)) " Right", Lang_Trans("m_hotkeys_movekey",,, 1) " ", "settings_hotkeys movekey",, [slop, 0, slop, 0])
		Gui_Label(GUI, "ys x+0 w" wEdits,, "settings_hotkeys formatting",, [0, slop, 0, slop],,, "0x01000000")
		Gui, %GUI%: Font, % "s"settings.general.fSize - 2
		Gui, %GUI%: Add, Edit, % "xp yp wp hp gSettings_hotkeys2 HWNDhwnd cBlack", % settings.hotkeys.movekey
		vars.hwnd.settings.movekey := hwnd, movekey := 1
		Gui, %GUI%: Font, % "s"settings.general.fSize
	}

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "Section xs x" x_anchor " y+"vars.settings.spacing " BackgroundTrans", % Lang_Trans("m_hotkeys_settings", 2)
	Gui, %GUI%: Font, norm

	Gui_Label(GUI, "Hidden ys gSettings_hotkeys2 cRed", " " Lang_Trans("global_restart", 2) " ",, ["hwnd.settings.apply", "_bar"], slop,, "insert 800000", cButtons)
	Gui, %GUI%: Add, Text, % "xp yp wp hp BackgroundTrans", % ""
	width := (rebound_c ? Max(wHotkeys, wHotkeys2, (movekey ? wMovekey : 0)) : Max(wHotkeys, (movekey ? wMovekey : 0)))

	Gui_Label(GUI, "Section xs w" width " Right", Lang_Trans("m_hotkeys_omnikey_new",,, 1) " ", "settings_hotkeys omnikey-info",, [slop, 0, slop, 0])
	Gui_Label(GUI, "ys x+0 w" wEdits,, "settings_hotkeys formatting|",,,,, "0x01000000")
	Gui, %GUI%: Font, % "s" settings.general.fSize - 2
	Gui, %GUI%: Add, Edit, % "xp yp wp hp cBlack HWNDhwnd gSettings_hotkeys2", % settings.hotkeys.omnikey
	Gui, %GUI%: Font, % "s" settings.general.fSize
	Gui_Label(GUI, "ys x+0 cFF8000", " " Lang_Trans("m_hotkeys_exclusive") " ", "settings_hotkeys omniblock",, [0, slop, 0, slop],,, 0)
	vars.hwnd.settings.omnikey := hwnd

	If rebound_c
	{
		Gui_Label(GUI, "Section xs w" Max(wHotkeys, wHotkeys2, (movekey ? wMovekey : 0)) " Right", Lang_Trans("m_hotkeys_omnikey_new",,, 1) " 2 ", "settings_hotkeys omnikey2",, [slop, 0, slop, 0],, (rebound_c ? "insert 00FFFF" : ""))
		Gui_Label(GUI, "ys x+0 w" wEdits,, "settings_hotkeys formatting||",,,, (rebound_c ? "insert 00FFFF" : ""), "0x01000000")
		Gui, %GUI%: Font, % "s" settings.general.fSize - 2
		Gui, %GUI%: Add, Edit, % "xp yp wp hp cBlack HWNDhwnd gSettings_hotkeys2", % settings.hotkeys.omnikey2
		vars.hwnd.settings.omnikey2 := hwnd
		Gui, %GUI%: Font, % "s" settings.general.fSize
		Gui_Label(GUI, "ys x+0 cFF8000", " " Lang_Trans("m_hotkeys_exclusive") " ", "settings_hotkeys omniblock|",, [0, slop, 0, slop],, (rebound_c ? "insert 00FFFF" : ""), 0)
	}

	Gui_Label(GUI, "Section xs w" width " Right", Lang_Trans("m_hotkeys_widget",,, 1) " ", "settings_hotkeys tab",, [slop, 0, slop, 0])
	Gui_Label(GUI, "ys x+0 w" wEdits,, "settings_hotkeys formatting|||",,,,, "0x01000000")
	Gui, %GUI%: Font, % "s"settings.general.fSize - 2
	Gui, %GUI%: Add, Edit, % "xp yp wp hp cBlack HWNDhwnd gSettings_hotkeys2", % settings.hotkeys.tab
	vars.hwnd.settings.tab := hwnd
	Gui, %GUI%: Font, % "s"settings.general.fSize

	Gui_Label(GUI, "ys x+0 gSettings_hotkeys2", " " Lang_Trans("m_hotkeys_exclusive") " ", "settings_hotkeys omniblock||", "hwnd.settings.tabblock", [0, slop, 0, slop],,, cButtons, vars.settings.tabblock_provisional)
	Gui_Label(GUI, "Section xs w" width " Right", Lang_Trans("m_hotkeys_menukey",,, 1) " ", "settings_hotkeys menu-widget alternative",, [slop, 0, slop, 0])
	Gui_Label(GUI, "ys x+0 w" wEdits,, "settings_hotkeys formatting||||",, [0, slop, 0, slop],,, "0x01000000")
	Gui, %GUI%: Font, % "s" settings.general.fSize - 2
	Gui, %GUI%: Add, Edit, % "xp yp wp hp HWNDhwnd gSettings_hotkeys2 cBlack", % settings.hotkeys.menuwidget
	vars.hwnd.settings.menuwidget := hwnd
	Gui, %GUI%: Font, % "s"settings.general.fSize

	Gui_Label(GUI, "Section xs w" width " h" 2*settings.general.fHeight - 2 " Right 0x200", Lang_Trans("m_hotkeys_restartkey",,, 1) " ", "settings_hotkeys restart",, [slop, 0, slop, 0], radius)
	For index, val in ["ctrl", "alt"]
		Gui_Label(GUI, (index = 1 ? "Section " : "") "ys x+0 w" wCtrl " Center gSettings_hotkeys2", Lang_Trans("global_" val), "settings_hotkeys modifiers" handle, "hwnd.settings.emergencykey_" val, [0, (slop && index = 2), 0, 0],,, cButtons, settings.hotkeys["emergencykey_" val]), handle .= "|"
	Gui_Label(GUI, "xs y+0 w" wEdits,, "settings_hotkeys formatting|||||",, [0, 0, 0, slop],,, "0x01000000")
	Gui, %GUI%: Font, % "s" settings.general.fSize - 2
	Gui, %GUI%: Add, Edit, % "xp yp wp hp HWNDhwnd gSettings_hotkeys2 cBlack", % settings.hotkeys.emergencykey
	vars.hwnd.settings.emergencykey := hwnd
	Gui, %GUI%: Font, % "s" settings.general.fSize
}

Settings_hotkeys2(cHWND)
{
	local
	global vars, settings

	check := LLK_HasVal(vars.hwnd.settings, cHWND), keycheck := {}
	If (check = 0)
		check := A_GuiControl

	settings.hotkeys.omnikey := LLK_ControlGet(vars.hwnd.settings.omnikey)
	settings.hotkeys.omnikey2 := LLK_ControlGet(vars.hwnd.settings.omnikey2)
	settings.hotkeys.tab := LLK_ControlGet(vars.hwnd.settings.tab), settings.hotkeys.tabblock := vars.settings.tabblock_provisional
	settings.hotkeys.emergencykey := LLK_ControlGet(vars.hwnd.settings.emergencykey)
	settings.hotkeys.emergencykey_ctrl := vars.settings.emergencykey_ctrl_provisional, settings.hotkeys.emergencykey_alt := vars.settings.emergencykey_alt_provisional

	Switch check
	{
		Case "rebound_c":
			settings.hotkeys.rebound_c := !settings.hotkeys.rebound_c
			Settings_menu("hotkeys", 1)
		Case "tabblock":
			vars.settings.tabblock_provisional := !vars.settings.tabblock_provisional
			GuiControl, % "+c" (vars.settings.tabblock_provisional ? "Lime" : "Gray"), % cHWND
			GuiControl, % "movedraw", % cHWND
		Case "emergencykey_ctrl":
			vars.settings[check "_provisional"] := !vars.settings[check "_provisional"]
			GuiControl, % "+c" (vars.settings[check "_provisional"] ? "Lime" : "Gray"), % cHWND
			GuiControl, % "movedraw", % cHWND
		Case "emergencykey_alt":
			vars.settings[check "_provisional"] := !vars.settings[check "_provisional"]
			GuiControl, % "+c" (vars.settings[check "_provisional"] ? "Lime" : "Gray"), % cHWND
			GuiControl, % "movedraw", % cHWND
		Case "apply":
			If settings.hotkeys.rebound_c && Blank(LLK_ControlGet(vars.hwnd.settings.omnikey2))
			{
				WinGetPos, xControl, yControl, wControl, hControl, % "ahk_id " vars.hwnd.settings.omnikey2
				LLK_ToolTip(Lang_Trans("m_hotkeys_error", 4), 3, xControl + wControl, yControl,, "red")
				Return
			}
			For index, val in ["omnikey", "omnikey2", "tab", "emergencykey", "movekey", "menuwidget"]
			{
				If !vars.hwnd.settings[val]
					Continue
				hotkey := LLK_ControlGet(vars.hwnd.settings[val])

				If !GetKeyVK(hotkey) && !(Blank(hotkey) && val = "menuwidget") || Blank(hotkey) && (val != "menuwidget")
				{
					WinGetPos, x, y, w,, % "ahk_id "vars.hwnd.settings[val]
					LLK_ToolTip(Lang_Trans("m_hotkeys_error"),, x + w, y,, "red")
					Return
				}

				If keycheck[(LLK_ControlGet(vars.hwnd.settings[val "_ctrl"]) ? "^" : "") . (LLK_ControlGet(vars.hwnd.settings[val "_alt"]) ? "!" : "") . hotkey]
				{
					LLK_ToolTip(Lang_Trans("m_hotkeys_error", 2), 1.5,,,, "red")
					Return
				}
				If !Blank(hotkey)
					keycheck[(LLK_ControlGet(vars.hwnd.settings[val "_ctrl"]) ? "^" : "") . (LLK_ControlGet(vars.hwnd.settings[val "_alt"]) ? "!" : "") . hotkey] := 1
			}
			IniWrite, % """" settings.hotkeys.rebound_c """", % "ini" vars.poe_version "\hotkeys.ini", settings, c-key rebound

			IniWrite, % """" LLK_ControlGet(vars.hwnd.settings.omnikey) """", % "ini" vars.poe_version "\hotkeys.ini", hotkeys, omni-hotkey
			IniWrite, % """" LLK_ControlGet(vars.hwnd.settings.omnikey2) """", % "ini" vars.poe_version "\hotkeys.ini", hotkeys, omni-hotkey2

			IniWrite, % """" LLK_ControlGet(vars.hwnd.settings.tab) """", % "ini" vars.poe_version "\hotkeys.ini", hotkeys, tab replacement
			IniWrite, % """" vars.settings.tabblock_provisional """", % "ini" vars.poe_version "\hotkeys.ini", hotkeys, block tab-key's native function

			If vars.hwnd.settings.movekey
				IniWrite, % """" LLK_ControlGet(vars.hwnd.settings.movekey) """", % "ini" vars.poe_version "\hotkeys.ini", hotkeys, move-key

			IniWrite, % """" LLK_ControlGet(vars.hwnd.settings.emergencykey) """", % "ini" vars.poe_version "\hotkeys.ini", hotkeys, emergency hotkey
			IniWrite, % """" vars.settings.emergencykey_ctrl_provisional """", % "ini" vars.poe_version "\hotkeys.ini", hotkeys, emergency key ctrl
			IniWrite, % """" vars.settings.emergencykey_alt_provisional """", % "ini" vars.poe_version "\hotkeys.ini", hotkeys, emergency key alt

			IniWrite, % """" ((menuwidget := LLK_ControlGet(vars.hwnd.settings.menuwidget)) = "" ? "blank" : menuwidget) """", % "ini" vars.poe_version "\hotkeys.ini", hotkeys, menu-widget alternative

			IniWrite, hotkeys, % "ini" vars.poe_version "\config.ini", versions, reload settings
			KeyWait, LButton
			Reload
			ExitApp
	}
	GuiControl, -Hidden, % vars.hwnd.settings.apply
	GuiControl, -Hidden, % vars.hwnd.settings.apply_bar
}

Settings_iteminfo()
{
	local
	global vars, settings
	static fSize, wActive, wReset, wDesired, wUndesired, wActivation, wTier

	GUI := "settings_menu" vars.settings.GUI_toggle, profile := settings.iteminfo.profile, x_anchor := vars.settings.x_anchor

	If (settings.general.lang_client = "unknown")
	{
		Settings_unsupported()
		Return
	}

	Gui, %GUI%: Add, Text, % "Section x" x_anchor " y" vars.settings.ySelection " Border BackgroundTrans gSettings_iteminfo2 HWNDhwnd" (settings.features.iteminfo ? " cLime" : " cGray"), % " " Lang_Trans("global_enable") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.enable := hwnd, vars.hwnd.help_tooltips["settings_iteminfo enable"] := hwnd1

	Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans HWNDhwnd gURL cAqua", % " wiki page "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.URLs := {}, vars.URLs[hwnd] := "https://github.com/Lailloken/Exile-UI/wiki/Item-info", vars.hwnd.help_tooltips["settings_website"] := hwnd1

	If !settings.features.iteminfo
		Return

	If (fSize != settings.general.fSize)
	{
		fSize := settings.general.fSize
		LLK_PanelDimensions([Lang_Trans("global_active"), Lang_Trans("global_name")], fSize, wActive, hActive)
		LLK_PanelDimensions([Lang_Trans("m_iteminfo_profiles", 3)], fSize, wReset, hReset)
		LLK_PanelDimensions([Lang_Trans("m_iteminfo_desired")], fSize, wDesired, hDesired)
		LLK_PanelDimensions([Lang_Trans("m_iteminfo_undesired")], fSize, wUndesired, hUndesired)
		If (wDesired + wUndesired - 1 > wReset)
			wReset := wDesired + wUndesired - 1
		Else While (wDesired + wUndesired - 1 < wReset)
			wUndesired += 1

		LLK_PanelDimensions([Lang_Trans("global_activation"), Lang_Trans("m_iteminfo_modbars"), Lang_Trans("m_iteminfo_affixinfo")], fSize, wActivation, hActivation)
		LLK_PanelDimensions([Lang_Trans("global_tier") . Lang_Trans("global_colon"), Lang_Trans("global_ilvl") . Lang_Trans("global_colon")], settings.general.fSize, wTier, hTier)
	}

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "Section xs Center y+"vars.settings.spacing, % Lang_Trans("m_iteminfo_profiles")
	Gui, %GUI%: Font, norm

	Gui, %GUI%: Add, Text, % "Section xs w" wActive " Border BackgroundTrans Right", % Lang_Trans("global_active") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd0 Background404040 cBlack", 100
	vars.hwnd.help_tooltips["settings_iteminfo profiles"] := hwnd0

	Loop 5
	{
		Gui, %GUI%: Add, Text, % "ys x+-1 w" settings.general.fWidth*2 " Center Border BackgroundTrans HWNDhwnd gSettings_iteminfo2 c" (settings.iteminfo.profile = A_Index ? "Lime" : "White"), % A_Index
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		handle .= "|", vars.hwnd.settings["profile_" A_Index] := hwnd, vars.hwnd.help_tooltips["settings_iteminfo profiles" handle] := hwnd1
	}

	Gui, %GUI%: Add, Text, % "xs y+-1 w" wActive " Border BackgroundTrans Right", % Lang_Trans("global_name") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd0 Background404040 cBlack", 100
	Gui, %GUI%: Add, Text, % "yp x+-1 Border BackgroundTrans w" settings.general.fWidth * 10 - 4
	Gui, %GUI%: Font, % "s" settings.general.fSize - 4
	Gui, %GUI%: Add, Edit, % "xp yp wp hp Border cBlack gSettings_iteminfo2 HWNDhwnd", % settings.iteminfo["profile_name" profile]
	Gui, %GUI%: Add, Button, % "Hidden xp yp wp hp Default HWNDhwnd1 gSettings_iteminfo2", ok
	Gui, %GUI%: Font, % "s" settings.general.fSize
	vars.hwnd.settings.profile_name := vars.hwnd.help_tooltips["settings_iteminfo profile name"] := hwnd, vars.hwnd.help_tooltips["settings_iteminfo profile name|"] := hwnd0, vars.hwnd.settings.ok_button := hwnd1

	Gui, %GUI%: Add, Text, % "ys w" wReset " Center Border BackgroundTrans", % Lang_Trans("m_iteminfo_profiles", 3)
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd0 Background404040 cBlack", 100
	Gui, %GUI%: Add, Text, % "xp y+-1 w" wDesired " Center Border BackgroundTrans HWNDhwnd gSettings_iteminfo2", % Lang_Trans("m_iteminfo_desired")
	vars.hwnd.help_tooltips["settings_iteminfo reset"] := hwnd0, vars.hwnd.settings.desired := hwnd
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border Vertical range0-500 HWNDhwnd Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 500
	vars.hwnd.settings.delbar_desired := vars.hwnd.help_tooltips["settings_iteminfo reset|"] := hwnd
	Gui, %GUI%: Add, Text, % "yp x+-1 w" wUndesired " Center Border BackgroundTrans HWNDhwnd0 gSettings_iteminfo2", % Lang_Trans("m_iteminfo_undesired")
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border Vertical range0-500 HWNDhwnd Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 500
	vars.hwnd.settings.undesired := hwnd0, vars.hwnd.settings.delbar_undesired := vars.hwnd.help_tooltips["settings_iteminfo reset||"] := hwnd

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "xs y+"vars.settings.spacing " h" settings.general.fHeight " 0x200 Section Center BackgroundTrans", % Lang_Trans("global_general")
	Gui, %GUI%: Font, norm

	Gui, %GUI%: Add, Text, % "xs w" wActivation " Section Border BackgroundTrans Right", % Lang_Trans("global_activation") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border Background404040 cBlack", 100
	Gui, %Gui%: Add, Text, % "ys x+-1 Border BackgroundTrans HWNDhwnd gSettings_iteminfo2" (settings.iteminfo.activation = "toggle" ? " cLime" : ""), % " " Lang_Trans("global_toggle") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.activation_toggle := hwnd, vars.hwnd.help_tooltips["settings_iteminfo toggle"] := hwnd1

	Gui, %Gui%: Add, Text, % "ys x+-1 Border BackgroundTrans HWNDhwnd gSettings_iteminfo2" (settings.iteminfo.activation = "hold" ? " cLime" : ""), % " " Lang_Trans("global_hold") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.activation_hold := hwnd, vars.hwnd.help_tooltips["settings_iteminfo hold"] := hwnd1

	Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans gSettings_iteminfo2 HWNDhwnd" (settings.iteminfo.trigger ? " cLime" : " cGray"), % " " Lang_Trans("global_shiftclick") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.trigger := hwnd, vars.hwnd.help_tooltips["settings_iteminfo shift-click"] := hwnd1

	Gui, %GUI%: Add, Text, % "Section xs w" wActivation " Border BackgroundTrans Right", % Lang_Trans("m_iteminfo_modbars") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border Background404040 cBlack", 100

	If vars.poe_version
	{
		Gui, %GUI%: Add, Text, % "ys x+-1 HWNDhwnd Center Border BackgroundTrans gSettings_iteminfo2" (settings.iteminfo.roll_range = 1 ? " cLime" : ""), % " " Lang_Trans("global_tier") " "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings.roll_range1 := hwnd, vars.hwnd.help_tooltips["settings_iteminfo modbars tier"] := hwnd1

		Gui, %GUI%: Add, Text, % "ys x+-1 HWNDhwnd Center Border BackgroundTrans gSettings_iteminfo2" (settings.iteminfo.roll_range = 2 ? " cLime" : ""), % " " Lang_Trans("global_global") " "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings.roll_range2 := hwnd, vars.hwnd.help_tooltips["settings_iteminfo modbars global"] := hwnd1

		Gui, %GUI%: Add, Text, % "ys x+-1 HWNDhwnd Center Border BackgroundTrans gSettings_iteminfo2" (settings.iteminfo.roll_range = 3 ? " cLime" : ""), % " " Lang_Trans("global_ilvl") " "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings.roll_range3 := hwnd, vars.hwnd.help_tooltips["settings_iteminfo modbars ilevel"] := hwnd1
	}

	Gui, %GUI%: Add, Text, % "ys" (vars.poe_version ? "" : " x+-1") " Border BackgroundTrans gSettings_iteminfo2 HWNDhwnd" (settings.iteminfo.modrolls ? " cLime" : " cGray"), % " " Lang_Trans("global_hide", 2) " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.modrolls := hwnd, vars.hwnd.help_tooltips["settings_iteminfo modrolls"] := hwnd1

	Gui, %GUI%: Add, Text, % "Section xs w" wActivation " Border BackgroundTrans Right", % Lang_Trans("m_iteminfo_affixinfo") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border Background404040 cBlack", 100
	Gui, %GUI%: Add, Text, % "ys x+-1 Border BackgroundTrans gSettings_iteminfo2 HWNDhwnd" (settings.iteminfo.affixinfo = 1 ? " cLime" : ""), % " " Lang_Trans("global_icon") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings["affixinfo_1"] := hwnd, vars.hwnd.help_tooltips["settings_iteminfo affix-info icon"] := hwnd1

	If vars.poe_version
	{
		Gui, %GUI%: Add, Text, % "ys x+-1 Border BackgroundTrans gSettings_iteminfo2 HWNDhwnd" (settings.iteminfo.affixinfo = 2 ? " cLime" : ""), % " " Lang_Trans("global_ilvl") " "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings["affixinfo_2"] := hwnd, vars.hwnd.help_tooltips["settings_iteminfo affix-info ilvl"] := hwnd1

		Gui, %GUI%: Add, Text, % "ys x+-1 Border BackgroundTrans gSettings_iteminfo2 HWNDhwnd" (settings.iteminfo.affixinfo = 3 ? " cLime" : ""), % " " Lang_Trans("m_iteminfo_maxtier") " "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings["affixinfo_3"] := hwnd, vars.hwnd.help_tooltips["settings_iteminfo affix-info max tier"] := hwnd1
	}
	Gui, %GUI%: Add, Text, % "ys x+-1 Border BackgroundTrans gSettings_iteminfo2 HWNDhwnd" (settings.iteminfo.affixinfo = 0 ? " cLime" : ""), % " " Lang_Trans("global_off") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings["affixinfo_0"] := hwnd, vars.hwnd.help_tooltips["settings_iteminfo affix-info off"] := hwnd1

	If vars.poe_version
	{
		Gui, %GUI%: Add, Text, % "Section xs Border BackgroundTrans gSettings_iteminfo2 HWNDhwnd" (settings.iteminfo.qual_scaling ? " cLime" : " cGray"), % " " Lang_Trans("m_iteminfo_qualscaling") " "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings.qual_scaling := hwnd, vars.hwnd.help_tooltips["settings_iteminfo quality scaling"] := hwnd1
	}
	Else
	{
		Gui, %GUI%: Add, Text, % "xs Section Border BackgroundTrans gSettings_iteminfo2 HWNDhwnd" (settings.iteminfo.compare ? " cLime" : " cGray"), % " " Lang_Trans("m_iteminfo_stattrack") " "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings.compare := hwnd, vars.hwnd.help_tooltips["settings_" (settings.general.lang_client = "english" ? "iteminfo league-start" : "lang unavailable") ] := hwnd1
	}
	If !settings.iteminfo.compare
	{
		Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans gSettings_iteminfo2 HWNDhwnd" (settings.iteminfo.itembase ? " cLime" : " cGray"), % " " Lang_Trans("m_iteminfo_basestats") " "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings.itembase := hwnd, vars.hwnd.help_tooltips["settings_iteminfo base-info"] := hwnd1
	}

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "Section xs Center BackgroundTrans y+"vars.settings.spacing, % Lang_Trans("global_ui")
	Gui, %GUI%: Font, norm

	Gui, %GUI%: Add, Text, % "Section xs Border BackgroundTrans", % " " Lang_Trans("global_font") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border Background404040 cBlack", 100
	Gui, %GUI%: Add, Text, % "ys x+-1 Center gSettings_iteminfo2 Border BackgroundTrans HWNDhwnd w"settings.general.fWidth*2, % "–"
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.font_minus := hwnd, vars.hwnd.help_tooltips["settings_font-size|"] := hwnd1

	Gui, %GUI%: Add, Text, % "ys x+-1 Center gSettings_iteminfo2 Border BackgroundTrans HWNDhwnd w"settings.general.fWidth*3, % settings.iteminfo.fSize
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.font_reset := hwnd, vars.hwnd.help_tooltips["settings_font-size||"] := hwnd1

	Gui, %GUI%: Add, Text, % "ys x+-1 Center gSettings_iteminfo2 Border BackgroundTrans HWNDhwnd w"settings.general.fWidth*2, % "+"
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.font_plus := hwnd, vars.hwnd.help_tooltips["settings_font-size|||"] := hwnd1

	Loop 2
	{
		Gui, %GUI%: Add, Text, % (A_Index = 1 ? "Section xs" : "ys") " Border BackgroundTrans", % " " (A_Index = 1 ? Lang_Trans("global_global") : Lang_Trans("m_iteminfo_iclass")) " "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd0 Background404040 cBlack", 100
		Gui, %GUI%: Add, Text, % "ys x+-1 w" settings.general.fWidth " hp Border BackgroundTrans gSettings_iteminfo2 HWNDhwnd"
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border BackgroundBlack HWNDhwnd2 c" settings.iteminfo.colors_marking[A_Index + A_Index//2], 100
		Gui, %GUI%: Add, Text, % "ys x+-1 w" settings.general.fWidth " hp Border BackgroundTrans gSettings_iteminfo2 HWNDhwnd3"
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border BackgroundBlack HWNDhwnd4 c" settings.iteminfo.colors_marking[A_Index + A_Index//2 + 1], 100
		vars.hwnd.settings["marking_desired" (A_Index = 1 ? "" : "_class")] := hwnd, vars.hwnd.settings["marking_desired" (A_Index = 1 ? "" : "_class") "_bar"] := hwnd2
		vars.hwnd.settings["marking_undesired" (A_Index = 1 ? "" : "_class")] := hwnd3, vars.hwnd.settings["marking_undesired" (A_Index = 1 ? "" : "_class") "_bar"] := hwnd4
		vars.hwnd.help_tooltips["settings_iteminfo marking " (A_Index = 1 ? "global" : "class")] := hwnd0
		vars.hwnd.help_tooltips["settings_iteminfo marking " (A_Index = 1 ? "global" : "class") "|"] := hwnd2, vars.hwnd.help_tooltips["settings_iteminfo marking " (A_Index = 1 ? "global" : "class") "||"] := hwnd4
	}

	Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans gSettings_iteminfo2 HWNDhwnd" (settings.iteminfo.override ? " cLime" : " cGray"), % " " Lang_Trans("m_iteminfo_overridetier") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.override := hwnd, vars.hwnd.help_tooltips["settings_iteminfo override"] := hwnd1

	Gui, %GUI%: Add, Text, % "Section xs w" wTier " Right Border BackgroundTrans", % Lang_Trans("global_tier") . Lang_Trans("global_colon") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd Background404040 cBlack", 100
	vars.hwnd.help_tooltips["settings_iteminfo item-tier"] := hwnd, handle := "|"
	Loop 8
	{
		parse := (A_Index = 1 ? 7 : A_Index - 2)
		Gui, %GUI%: Add, Text, % "ys x+-1 w" settings.general.fWidth*3 " cBlack Center Border BackgroundTrans gSettings_iteminfo2 HWNDhwnd", % (A_Index = 1 ? Lang_Trans("m_iteminfo_fractured") : (A_Index = 2 ? "#" : parse))
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 BackgroundBlack c" settings.iteminfo.colors_tier[parse], 100
		vars.hwnd.settings["tier_"parse] := hwnd, vars.hwnd.settings["tierbar_"parse] := vars.hwnd.help_tooltips["settings_iteminfo item-tier" handle] := hwnd1, handle .= "|"
	}

	If (settings.iteminfo.affixinfo = 2)
	{
		Gui, %GUI%: Add, Text, % "Section xs w" wTier " Right Border BackgroundTrans HWNDhwnd00", % Lang_Trans("global_ilvl") . Lang_Trans("global_colon") " "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd Background404040 cBlack", 100
		vars.hwnd.help_tooltips["settings_iteminfo item-level"] := hwnd, handle := "|"
		Loop 8
		{
			color := (settings.iteminfo.colors_ilvl[A_Index] = "ffffff") && (A_Index = 1) ? "Red" : "Black"
			Gui, %GUI%: Add, Text, % "ys x+-1 w" settings.general.fWidth*3 " c" color " Border Center BackgroundTrans gSettings_iteminfo2 HWNDhwnd", % settings.iteminfo.ilevels[A_Index]
			Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 BackgroundBlack c"settings.iteminfo.colors_ilvl[A_Index], 100
			vars.hwnd.settings["ilvl_"A_Index] := hwnd, vars.hwnd.settings["ilvlbar_"A_Index] := vars.hwnd.help_tooltips["settings_iteminfo item-level"handle] := hwnd1, handle .= "|"
		}
	}

	;If vars.poe_version || (settings.general.lang_client != "english")
		Return

	colors := [settings.iteminfo.colors_tier.1, settings.iteminfo.colors_tier.6]
	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "xs Section Center BackgroundTrans HWNDhwnd0 y+"vars.settings.spacing, % Lang_Trans("m_iteminfo_rules")
	Gui, %GUI%: Add, Pic, % "ys hp w-1 BackgroundTrans HWNDhwnd0", % "HBitmap:*" vars.pics.global.help
	Gui, %GUI%: Font, norm
	Gui, %GUI%: Add, Checkbox, % "Section xs BackgroundTrans 0x400 gSettings_iteminfo2 HWNDhwnd02 c" colors.2 " Checked"settings.iteminfo.rules.attacks, % Lang_Trans("m_iteminfo_rules", 3)
	vars.hwnd.settings.rule_attacks := hwnd02, vars.hwnd.help_tooltips["settings_iteminfo rules"] := hwnd0
	GuiControlGet, text_, Pos, % hwnd02
	checkbox_spacing := text_w + settings.general.fWidth/2

	Gui, %GUI%: Add, Checkbox, % "ys xp+"checkbox_spacing "BackgroundTrans 0x400 gSettings_iteminfo2 HWNDhwnd03 c" colors.2 " Checked"settings.iteminfo.rules.spells, % Lang_Trans("m_iteminfo_rules", 4)
	vars.hwnd.settings.rule_spells := hwnd03
	Gui, %GUI%: Add, Checkbox, % "ys BackgroundTrans 0x400 gSettings_iteminfo2 HWNDhwnd06 c" colors.2 " Checked"settings.iteminfo.rules.crit, % Lang_Trans("m_iteminfo_rules", 7)
	vars.hwnd.settings.rule_crit := hwnd06
	Gui, %GUI%: Add, Checkbox, % "xs Section BackgroundTrans 0x400 gSettings_iteminfo2 HWNDhwnd04 c" colors.1 " Checked"settings.iteminfo.rules.res, % Lang_Trans("m_iteminfo_rules", 5)
	vars.hwnd.settings.rule_res := hwnd04
	Gui, %GUI%: Add, Checkbox, % "ys xp+"checkbox_spacing " BackgroundTrans 0x400 gSettings_iteminfo2 HWNDhwnd05 c" colors.2 "" " Checked"settings.iteminfo.rules.hitgain, % Lang_Trans("m_iteminfo_rules", 6)
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
	If !RegexMatch(check, "font_|^(un){0,1}desired$")
	{
		KeyWait, LButton
		KeyWait, RButton
	}

	If (check = "enable")
	{
		IniWrite, % (settings.features.iteminfo := !settings.features.iteminfo), % "ini" vars.poe_version "\config.ini", Features, enable item-info
		If WinExist("ahk_id " vars.hwnd.iteminfo.main)
			LLK_Overlay(vars.hwnd.iteminfo.main, "destroy")
		Settings_menu("item-info")
		If vars.general.MultiThreading
			StringSend("iteminfo=" settings.features.iteminfo)
		Return
	}
	Else If (check = "profile_name")
	{
		profile := settings.iteminfo.profile, input := LLK_ControlGet(cHWND), edited := (settings.iteminfo["profile_name" profile] != input)
		GuiControl, % "+c" (edited ? "Red" : "Black"), % cHWND
		GuiControl, % "movedraw", % cHWND
	}
	Else If (check = "ok_button")
	{
		profile := settings.iteminfo.profile
		IniWrite, % """" (settings.iteminfo["profile_name" profile] := LLK_ControlGet(vars.hwnd.settings.profile_name)) """", % "ini" vars.poe_version "\item-checker.ini", settings, % "profile " profile " name"
		GuiControl, % "+cBlack", % vars.hwnd.settings.profile_name
		GuiControl, % "movedraw", % vars.hwnd.settings.profile_name
	}
	Else If InStr(check, "profile_")
	{
		GuiControl, +cWhite, % vars.hwnd.settings["profile_"settings.iteminfo.profile]
		GuiControl, movedraw, % vars.hwnd.settings["profile_"settings.iteminfo.profile]
		GuiControl, +cLime, % vars.hwnd.settings[check]
		GuiControl, movedraw, % vars.hwnd.settings[check]
		IniWrite, % (settings.iteminfo.profile := control), % "ini" vars.poe_version "\item-checker.ini", settings, current profile
		Init_iteminfo()
		GuiControl,, % vars.hwnd.settings.profile_name, % settings.iteminfo["profile_name" settings.iteminfo.profile]
	}
	Else If (check = "desired")
	{
		If (vars.system.click = 1) && LLK_Progress(vars.hwnd.settings.delbar_desired, "LButton", cHWND,, 500, "Red", vars.settings.cButtons)
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
		If (vars.system.click = 1) && LLK_Progress(vars.hwnd.settings.delbar_undesired, "LButton", cHWND,, 500, "Red", vars.settings.cButtons)
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
	Else If InStr(check, "activation_")
	{
		IniWrite, % (settings.iteminfo.activation := control), % "ini" vars.poe_version "\item-checker.ini", Settings, activation
		GuiControl, % "+cLime", % cHWND
		GuiControl, % "movedraw", % cHWND
		GuiControl, % "+cWhite", % vars.hwnd.settings["activation_" (control = "toggle" ? "hold" : "toggle")]
		GuiControl, % "movedraw", % vars.hwnd.settings["activation_" (control = "toggle" ? "hold" : "toggle")]
	}
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
		IniWrite, % (settings.iteminfo.trigger := !settings.iteminfo.trigger), % "ini" vars.poe_version "\item-checker.ini", settings, enable wisdom-scroll trigger
		Settings_ScreenChecksValid()
		GuiControl, % "+c" (settings.iteminfo.trigger ? "Lime" : "Gray"), % cHWND
		GuiControl, % "movedraw", % cHWND
	}
	Else If (check = "modrolls")
	{
		IniWrite, % (settings.iteminfo.modrolls := !settings.iteminfo.modrolls), % "ini" vars.poe_version "\item-checker.ini", settings, hide roll-ranges
		GuiControl, % "+c" (settings.iteminfo.modrolls ? "Lime": "Gray"), % cHWND
		GuiControl, % "movedraw", % cHWND
	}
	Else If (check = "qual_scaling")
	{
		IniWrite, % (settings.iteminfo.qual_scaling := !settings.iteminfo.qual_scaling), % "ini" vars.poe_version "\item-checker.ini", settings, quality scaling
		GuiControl, % "+c" (settings.iteminfo.qual_scaling ? "Lime" : "Gray"), % cHWND
		GuiControl, % "movedraw", % cHWND
	}
	Else If InStr(check, "roll_range")
	{
		IniWrite, % (settings.iteminfo.roll_range := SubStr(check, 0)), % "ini" vars.poe_version "\item-checker.ini", settings, roll range
		Loop 3
		{
			GuiControl, % "+c" (A_Index = SubStr(check, 0) ? "Lime" : "White"), % vars.hwnd.settings["roll_range" A_Index]
			GuiControl, % "movedraw", % vars.hwnd.settings["roll_range" A_Index]
		}
	}
	Else If (check = "compare")
	{
		If (settings.general.lang_client != "english")
			Return
		IniWrite, % (settings.iteminfo.compare := !settings.iteminfo.compare), % "ini" vars.poe_version "\item-checker.ini", settings, enable gear-tracking
		Init_iteminfo()
		If vars.general.MultiThreading
			StringSend("iteminfo-compare=" settings.iteminfo.compare)
		Settings_menu("item-info")
		GuiControl, % "+c" (settings.iteminfo.compare ? "Lime" : "Gray"), % cHWND
		GuiControl, % "movedraw", % cHWND
	}
	Else If (check = "itembase")
	{
		IniWrite, % (settings.iteminfo.itembase := !settings.iteminfo.itembase), % "ini" vars.poe_version "\item-checker.ini", settings, enable base-info
		GuiControl, % "+c" (settings.iteminfo.itembase ? "Lime" : "Gray"), % cHWND
		GuiControl, % "movedraw", % cHWND
	}
	Else If InStr(check, "affixinfo_")
	{
		previous := settings.iteminfo.affixinfo
		IniWrite, % (settings.iteminfo.affixinfo := control), % "ini" vars.poe_version "\item-checker.ini", settings, affix-info
		If InStr(previous . control, 2)
			Settings_menu("item-info")
		Else For index, val in (vars.poe_version ? [0, 1, 2, 3] : [0, 1])
		{
			GuiControl, % "+c" (val = control ? "Lime" : "White"), % vars.hwnd.settings["affixinfo_" val]
			GuiControl, % "movedraw", % vars.hwnd.settings["affixinfo_" val]
		}
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
		IniWrite, % (settings.iteminfo.override := !settings.iteminfo.override), % "ini" vars.poe_version "\item-checker.ini", settings, enable blacklist-override
		GuiControl, % "+c" (settings.iteminfo.override ? "Lime" : "Gray"), % cHWND
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
	static fSize, wLeague, wChar, DDL, wDDL, wQuests, wManual, wPoB, wTrees

	GUI := "settings_menu" vars.settings.GUI_toggle, x_anchor := vars.settings.x_anchor, margin := Round(settings.general.fWidth/4), slop := settings.general.slop, cButtons := settings.general.cButtons
	cButtons2 := settings.general.cButtons2, fWidth := settings.general.fWidth, fHeight := settings.general.fHeight, xMargin := vars.settings.xMargin, radius := settings.general.radius
	Gui_Label(GUI, "Section x" x_anchor " y" vars.settings.ySelection " gSettings_leveltracker2", " " Lang_Trans("global_enable") " ", "settings_leveltracker enable", "hwnd.settings.enable", slop,,, cButtons, settings.features.leveltracker)

	hwnd := Gui_Label(GUI, "ys gURL cAqua", " wiki page ", "settings_website",, slop,,, cButtons), vars.URLs := {(hwnd.text): "https://github.com/Lailloken/Exile-UI/wiki/Act‐Tracker"}
	If !settings.features.leveltracker
		Return

	If !IsObject(db.leveltracker)
		DB_Load("leveltracker")

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "xs Section y+" vars.settings.spacing " BackgroundTrans", % Lang_Trans("global_general")
	Gui, %GUI%: Font, norm
	Gui, %GUI%: Add, Button, % "ys Hidden hp Default gSettings_leveltracker2 HWNDhwnd w" settings.general.fWidth, ok
	vars.hwnd.settings.apply_button := hwnd, timer := settings.leveltracker.timer, fade := settings.leveltracker.fade

	If !vars.client.stream
	{
		Gui_Label(GUI, "Section xs gSettings_leveltracker2", " " Lang_Trans("m_lvltracker_timer") " ", "settings_leveltracker timer", "hwnd.settings.timer", (!timer ? slop : [slop, 0, slop, 0]),,, cButtons, timer)
		If settings.leveltracker.timer
			Gui_Label(GUI, "ys x+0 gSettings_leveltracker2", " " Lang_Trans("global_flash") " ", "settings_leveltracker timer flash", "hwnd.settings.timer_flash", [0, slop, 0, slop],,, cButtons, settings.leveltracker.timer_flash)
	}
	Gui_Label(GUI, "ys gSettings_leveltracker2", " " Lang_Trans("m_lvltracker_fadeout") " ", "settings_leveltracker fade-timer", "hwnd.settings.fade", (!fade ? slop : [slop, 0, slop, 0]),,, cButtons, fade)

	If settings.leveltracker.fade
	{
		Gui_Label(GUI, "ys x+0 w" 2*fWidth,, "settings_leveltracker fade-timer|",,,,, "0x50" cButtons)
		Gui, %GUI%: Font, % "s"settings.general.fSize - 2
		Gui, %GUI%: Add, Edit, % "xp yp wp hp cBlack Center gSettings_leveltracker2 Limit1 Number HWNDhwnd", % !settings.leveltracker.fadetime ? 0 : Round(settings.leveltracker.fadetime/1000)
		Gui, %GUI%: Font, % "s"settings.general.fSize
		vars.hwnd.settings.fadetime := hwnd

		Gui_Label(GUI, "ys x+0 gSettings_leveltracker2", " " Lang_Trans("m_lvltracker_fadeout", 2) " ", "settings_leveltracker fade mouse", "hwnd.settings.fade_hover", [0, slop, 0, slop],,, cButtons, settings.leveltracker.fade_hover)
	}

	Gui_Label(GUI, "ys gSettings_leveltracker2", " " Lang_Trans("m_lvltracker_lvltips") " ", "settings_leveltracker recommendation", "hwnd.settings.recommend", slop,,, cButtons, settings.leveltracker.recommend)
	
	Gui_Label(GUI, (fade ? "Section xs" : "ys") " gSettings_leveltracker2", " " Lang_Trans("m_lvltracker_autotracking") " ", "settings_leveltracker auto tracking", "hwnd.settings.autotrack", slop,,, cButtons, settings.leveltracker.autotrack)

	If !vars.client.stream && !vars.poe_version
		Gui_Label(GUI, (!fade ? "Section xs" : "ys") " gSettings_leveltracker2", " " Lang_Trans("m_lvltracker_gear") " ", "settings_leveltracker geartracker", "hwnd.settings.geartracker", slop,,, cButtons, settings.leveltracker.geartracker)

	line_break := (vars.poe_version && !settings.leveltracker.fade), hotkeys := settings.leveltracker.hotkeys
	Gui_Label(GUI, "Section " (line_break ? "xs" : "ys") . (hotkeys ? " w" settings.general.fWidth * 16  : "") " Center gSettings_leveltracker2", " " Lang_Trans("m_lvltracker_pagehotkeys") " ", "settings_leveltracker hotkeys enable", "hwnd.settings.hotkeys_enable", (!hotkeys ? slop : [slop, slop, 0, 0]),,, cButtons, hotkeys)

	If settings.leveltracker.hotkeys
	{
		width := settings.general.fWidth * 8
		Gui_Label(GUI, "xs y+0 w" width,, "settings_leveltracker hotkeys",, [0, 0, slop, 0],,, "0x50" cButtons)
		Gui, %GUI%: Font, % "s" settings.general.fSize - 2
		Gui, %GUI%: Add, Edit, % "xp yp wp hp Center cBlack HWNDhwnd1 gSettings_leveltracker2", % settings.leveltracker.hotkey_1
		Gui, %GUI%: Font, % "s" settings.general.fSize
		Gui_Label(GUI, "yp x+0 w" width,, "settings_leveltracker hotkeys|",, [0, 0, 0, slop],,, "0x50" cButtons)
		Gui, %GUI%: Font, % "s" settings.general.fSize - 2
		Gui, %GUI%: Add, Edit, % "xp yp wp hp Center cBlack HWNDhwnd2 gSettings_leveltracker2", % settings.leveltracker.hotkey_2
		Gui, %GUI%: Font, % "s" settings.general.fSize
		vars.hwnd.settings.hotkey_1 := hwnd1, vars.hwnd.settings.hotkey_2 := hwnd2
	}

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "Section xs x" x_anchor " yp+" settings.general.fHeight + vars.settings.spacing " BackgroundTrans", % Lang_Trans("m_lvltracker_guide")
	Gui, %GUI%: Font, norm



	files := [0, 0, 0, 0, 0, 0, 0, 0, 0], handle := ""
	Loop, Files, % "ini" vars.poe_version "\leveling guide*.ini"
		index := SubStr(StrReplace(A_LoopFileName, ".ini"), 0), index := IsNumber(index) ? index : 1, files[index] := 1, max_index := (index > max_index ? index : max_index)

	If max_index
		Gui_Label(GUI, "ys", " " Lang_Trans("lvltracker_editor_slot") " ", "settings_leveltracker guide info",, [slop, 0, slop, 0])

	Loop, % max_index
	{
		color := (!files[A_Index] ? " cLime" : (settings.leveltracker.profile = (A_Index = 1 ? "" : A_Index) ? " cLime" : "")), index := (A_Index = 1 ? "" : A_Index)
		If !files[A_Index]
			Gui, %GUI%: Font, % "bold s" settings.general.fSize + 6
		Gui_Label(GUI, "ys x+0 w" fHeight " h" fHeight - 2 " 0x200 Center gSettings_leveltracker2" color, files[A_Index] ? A_Index : "+", "settings_leveltracker profile " (files[A_Index] ? "select" : "create") . handle, "hwnd.settings.profile" index, (A_Index = 9 ? [0, slop, 0, slop] : 0),,, cButtons)
		If !files[A_Index]
			Gui, %GUI%: Font, % "norm s" settings.general.fSize
		handle .= "|"
	}

	If (max_index != 9)
	{
		If max_index
			Gui, %GUI%: Font, % "bold s" settings.general.fSize + 6
		Gui_Label(GUI, "ys x+" (max_index ? "0 w" fHeight : xMargin) " h" fHeight - 2 " 0x200 Center cLime gSettings_leveltracker2", (!max_index ? " " Lang_Trans("global_load") " " : "+"), "settings_leveltracker profile create" handle, "hwnd.settings.profile" max_index + 1, (!max_index ? slop : [0, slop, 0, slop]),,, cButtons)
		Gui, %GUI%: Font, % "norm s" settings.general.fSize
	}

	handle := "", bandits := ["none", "alira", "kraityn", "oak"], profile := settings.leveltracker.profile, files := 0, info := settings.leveltracker["guide" profile].info
	If (fSize != settings.general.fSize)
	{
		fSize := settings.general.fSize
		LLK_PanelDimensions([Lang_Trans("m_lvltracker_leaguestart"), Lang_Trans("m_lvltracker_optionals")], fSize, wLeague, hLeague)
		LLK_PanelDimensions([Lang_Trans("m_lvltracker_quests"), "+ " Lang_Trans("m_lvltracker_quests", 2)], fSize, wQuests, hQuests)
		LLK_PanelDimensions([Lang_Trans("global_manual"), Lang_Trans("global_menu")], fSize, wManual, hManual), LLK_PanelDimensions([Lang_Trans("global_folder"), "pob hotkey"], fSize, wPoB, hPoB)
		LLK_PanelDimensions([Lang_Trans("global_tree", 2), Lang_Trans("global_save")], fSize, wTrees, hTrees)
		DDL := [Lang_Trans("global_none"), Lang_Trans("m_lvltracker_bandits"), Lang_Trans("m_lvltracker_bandits", 2), Lang_Trans("m_lvltracker_bandits", 3)]
		LLK_PanelDimensions(DDL, fSize, wDDL, hDDL)
	}

	If max_index
	{
		custom := settings.leveltracker["guide" profile].info.custom, pob := vars.leveltracker["pob" profile].Count()
		Gui_Label(GUI, "Section xs gSettings_leveltracker2", " " Lang_Trans("global_import") " ", "settings_leveltracker import", "hwnd.settings.import", slop,,, cButtons)

		Gui_Label(GUI, "ys", " " Lang_Trans("m_lvltracker_guide", 2) " ",,, [slop, 0, slop, 0])
		Gui_Label(GUI, "ys x+0 gSettings_leveltracker2", " " Lang_Trans("global_edit") " ", "settings_leveltracker editor", "hwnd.settings.editprofile",,,, cButtons)

		Gui_Label(GUI, "ys x+0 gSettings_leveltracker2", " " Lang_Trans("global_reset") " ", "settings_leveltracker reset" (custom ? " custom" : ""), "hwnd.settings.reset", [0, slop, 0, slop],, (custom ? "push FFFF00" : ""), cButtons)

		Gui_Label(GUI, "ys", " pob ", "settings_leveltracker pob info",, [slop, 0, slop, 0])
		Gui_Label(GUI, "ys x+0 " (pob ? "gSettings_leveltracker2" : "cYellow"), " " Lang_Trans("global_" (pob ? "show" : "none")) " ", "settings_leveltracker pob " (pob ? "preview" : "info|"), "hwnd.settings.pobpreview", [0, slop, 0, slop],,, (pob ? cButtons : cButtons2))

		If !vars.poe_version
		{
			current_bandit := LLK_HasVal(bandits, settings.leveltracker["guide" profile].info.bandit), current_bandit := Lang_Trans((current_bandit = 1 ? "global_none" : "m_lvltracker_bandits"), Max(1, current_bandit - 1))
			Gui_Label(GUI, "Section xs", " " Lang_Trans("m_lvltracker_bandit") " ",,, [slop, 0, slop, 0])
			Gui_Label(GUI, "ys x+0 w" wDDL " Center gSettings_leveltracker2 cLime", current_bandit, "settings_leveltracker bandit", "hwnd.settings.bandit", [0, slop, 0, slop],,, cButtons)
			vars.ddl.bandit := {"cHWND": vars.hwnd.settings.bandit, "current": current_bandit, "list": DDL.Clone(), "fSize": settings.general.fSize, "color": cButtons}
		}

		If !vars.poe_version
		{
			Gui_Label(GUI, "ys", " " Lang_Trans("m_lvltracker_gemquests") " ",,, [slop, 0, slop, 0])
			If vars.leveltracker["pob" profile].gems.Count()
				custom_gems := (settings.leveltracker["guide" profile].info.gems && vars.leveltracker["PoB" profile].vendors.Count()), hidden := (settings.leveltracker["guide" profile].info.gems ? "" : " Hidden")
				, Gui_Label(GUI, "ys x+0 gSettings_leveltracker2", " " Lang_Trans("global_enable") " ", "settings_leveltracker gems", "hwnd.settings.gems", (info.gems ? "" : [0, slop, 0, slop]),, (custom_gems ? "push FFFF00" : ""), cButtons, info.gems)
				, Gui_Label(GUI, "ys x+0 gSettings_leveltracker2" hidden, " " Lang_Trans("global_all") " ", "settings_leveltracker gems all", ["hwnd.settings.gems_all", "_bar"], [0, slop, 0, slop],,, cButtons, info.gems_all)
			Else Gui_Label(GUI, "ys x+0 gSettings_leveltracker2", " " Lang_Trans("global_enable") " ", "settings_leveltracker gems all", "hwnd.settings.gems_all", [0, slop, 0, slop],,, cButtons, info.gems_all)
		}

		Gui_Label(GUI, "Section xs w" wQuests " h" 2*fHeight - 2 " Center", Lang_Trans("m_lvltracker_quests") "`n+ " Lang_Trans("m_lvltracker_quests", 2),,, [slop, 0, slop, 0], radius)
		Gui_Label(GUI, "ys x+0 w" wLeague " Center gSettings_leveltracker2", Lang_Trans("m_lvltracker_leaguestart"), "settings_leveltracker leaguestart", "hwnd.settings.leaguestart", [0, slop, 0, 0],,, cButtons, info.leaguestart)
		Gui_Label(GUI, "xp y+0 w" wLeague " Center gSettings_leveltracker2", Lang_Trans("m_lvltracker_optionals"), "settings_leveltracker optionals", "hwnd.settings.optionals", [0, 0, 0, slop],,, cButtons, info.optionals)
		
		Settings_CharTracking("leveltracker")

		Gui, %GUI%: Font, underline bold
		Gui, %GUI%: Add, Text, % "xs x" x_anchor " y+" vars.settings.spacing " Section BackgroundTrans", % Lang_Trans("global_ui")
		Gui, %GUI%: Font, norm

		Gui_Label(GUI, "ys", " " Lang_Trans("global_design") " ",,, [slop, 0, slop, 0])
		Gui_Label(GUI, "ys x+0 gSettings_leveltracker2", " " Lang_Trans("global_new") " ", "settings_themes new", "hwnd.settings.slop1",,,, cButtons, [settings.leveltracker.slop, "White"])
		Gui_Label(GUI, "ys x+0 gSettings_leveltracker2", " " Lang_Trans("global_old") " ", "settings_themes old", "hwnd.settings.slop0", [0, slop, 0, slop],,, cButtons, [!settings.leveltracker.slop, "White"])

		Gui_Label(GUI, "Section xs", " " Lang_Trans("global_font") " ",,, [slop, 0, slop, 0])
		Gui_Label(GUI, "ys x+0 w" fHeight " Center gSettings_leveltracker2", "–", "settings_font-size", "hwnd.settings.font_minus",,,, cButtons)
		Gui_Label(GUI, "ys x+0 w" 3*fWidth " Center gSettings_leveltracker2", settings.leveltracker.fSize, "settings_font-size|", "hwnd.settings.font_reset",,,, cButtons)
		Gui_Label(GUI, "ys x+0 w" fHeight " Center gSettings_leveltracker2", "+", "settings_font-size||", "hwnd.settings.font_plus", [0, slop, 0, slop],,, cButtons)

		Gui_Label(GUI, "ys", " " Lang_Trans("global_opacity") " ",,, [slop, 0, slop, 0])
		Loop 5
			Gui_Label(GUI, "ys x+0 w" fHeight " Center gSettings_leveltracker2", A_Index,, "hwnd.settings.opac_" A_Index, (A_Index = 5 ? [0, slop, 0, slop] : ""),,, cButtons, [(A_Index = settings.leveltracker.trans), "White"])

		Gui, %GUI%: Font, bold underline
		Gui, %GUI%: Add, Text, % "xs Section x" x_anchor " y+" vars.settings.spacing " BackgroundTrans", % Lang_Trans("m_lvltracker_poboverlays")
		Gui, %GUI%: Font, norm

		Gui_Label(GUI, "Section xs", " " Lang_Trans("global_gem", 2) " ", "settings_leveltracker pobgems info",, [slop, 0, slop, 0])
		Gui_Label(GUI, "ys x+0 gSettings_leveltracker2", " " Lang_Trans("global_toggle") " ", "settings_leveltracker pob gems", "hwnd.settings.pobgems", [0, slop, 0, slop],,, cButtons, settings.leveltracker.gemlinksToggle)
		If !(manual := settings.leveltracker.pobmanual)
			Gui_Label(GUI, "Hidden ys w" wTrees " Center gSettings_leveltracker2 cRed", Lang_Trans("global_save"),, ["hwnd.settings.tree_hotkey_save", "_bar"], [slop, 0, slop, 0],, "insert 800000", cButtons)

		Gui_Label(GUI, (manual ? "ys h" 2*fHeight - 2 " 0x200" : "xp yp w" wTrees " Center"), " " Lang_Trans("global_tree", 2) " ", "settings_leveltracker skilltree info",, [slop, 0, slop, 0], radius)
		If !manual
		{
			If FileExist("data\global\[leveltracker] tree" vars.poe_version " *.json")
				Gui_Label(GUI, "ys x+0 gSettings_leveltracker2", " " Lang_Trans("global_delete", 2) " ", "settings_leveltracker skilltree clear", "hwnd.settings.treeclear",,,, cButtons)
			Gui_Label(GUI, "ys x+0 w" 8*fWidth,, "settings_leveltracker tree hotkey",,,,, "0x50" cButtons)
			Gui, %GUI%: Font, % "s" settings.general.fSize - 4
			Gui, %GUI%: Add, Edit, % "xp yp wp hp Center gSettings_leveltracker2 cBlack HWNDhwnd", % settings.leveltracker.tree_hotkey
			vars.hwnd.settings.tree_hotkey := hwnd
			Gui, %GUI%: Font, % "s" settings.general.fSize
		}
		Gui_Label(GUI, "ys x+0" (manual ? " w" wManual : "") " gSettings_leveltracker2", " " Lang_Trans("global_manual") " ", "settings_leveltracker pob manual", "hwnd.settings.pobmanual", (manual ? "" : [0, slop, 0, slop]),,, cButtons, manual)

		If manual
		{
			Gui_Label(GUI, "xp y+0 w" wManual " Center gSettings_leveltracker2", Lang_Trans("global_menu"), "settings_leveltracker screen-cap menu", "hwnd.settings.screencap",,,, cButtons)
			Gui_Label(GUI, "ys x+0 w" wPoB " Center gSettings_leveltracker2", "pob hotkey", "settings_leveltracker pob", "hwnd.settings.pob", [0, slop, 0, 0],,, cButtons, settings.leveltracker.pob)
			Gui_Label(GUI, "xp y+0 w" wPob " Center gSettings_leveltracker2", Lang_Trans("global_folder"), "settings_leveltracker folder", "hwnd.settings.folder", [0, 0, 0, slop],,, cButtons)
		}
	}
}

Settings_leveltracker2(cHWND := "")
{
	local
	global vars, settings, JSON, db

	If !IsObject(db.leveltracker)
		DB_Load("leveltracker")

	check := LLK_HasVal(vars.hwnd.settings, cHWND), control := SubStr(check, InStr(check, "_") + 1)
	If !RegexMatch(check, "i)font_|pobpreview|^profile|treeclear|^reset$")
	{
		KeyWait, LButton
		KeyWait, RButton
	}

	If (check = "enable")
	{
		timer := vars.leveltracker.timer
		IniWrite, % (settings.features.leveltracker := !settings.features.leveltracker), % "ini" vars.poe_version "\config.ini", features, enable leveling guide
		If !settings.features.leveltracker && IsNumber(timer.current_split) && (timer.current_split != timer.current_split0) ;save current timer state
			IniWrite, % (timer.current_split0 := timer.current_split), % "ini" vars.poe_version "\leveling tracker.ini", % "current run" settings.leveltracker.profile, time
		Leveltracker_Toggle("destroy"), LLK_Overlay(vars.hwnd.geartracker.main, "destroy")
		vars.leveltracker := "", vars.hwnd.Delete("leveltracker"), vars.hwnd.Delete("geartracker")
		If settings.features.leveltracker
			Init_leveltracker()
		Settings_menu("leveling tracker")

		If WinExist("ahk_id " vars.hwnd.radial.main)
			LLK_Overlay(vars.hwnd.radial.main, "destroy"), vars.hwnd.radial.main := ""
	}
	Else If InStr(check, "slop")
	{
		If (settings.leveltracker.slop = (input := SubStr(check, 0)))
			Return
		IniWrite, % (settings.leveltracker.slop := input), % "ini" vars.poe_version "\leveling tracker.ini", settings, rounded corners
		GuiControl, % "+c" (settings.leveltracker.slop ? "Lime" : "White"), % vars.hwnd.settings.slop1
		GuiControl, % "movedraw", % vars.hwnd.settings.slop1
		GuiControl, % "+c" (settings.leveltracker.slop ? "White" : "Lime"), % vars.hwnd.settings.slop0
		GuiControl, % "movedraw", % vars.hwnd.settings.slop0
		If LLK_Overlay(vars.hwnd.leveltracker.main, "check")
			Leveltracker_Progress(1)
	}
	Else If (check = "timer")
	{
		timer := vars.leveltracker.timer
		IniWrite, % (settings.leveltracker.timer := !settings.leveltracker.timer), % "ini" vars.poe_version "\leveling tracker.ini", settings, enable timer
		If !settings.leveltracker.timer && IsNumber(timer.current_split) && (timer.current_split != timer.current_split0)
			IniWrite, % (timer.current_split0 := timer.current_split), % "ini" vars.poe_version "\leveling tracker.ini", % "current run" settings.leveltracker.profile, time
		If LLK_Overlay(vars.hwnd.leveltracker.main, "check")
			Leveltracker_Progress(1)
		vars.leveltracker.timer.pause := -1
		GuiControl, % "+c" (settings.leveltracker.timer ? "Lime" : "Gray"), % cHWND
		GuiControl, % "movedraw", % cHWND
		Settings_menu("leveling tracker")
	}
	Else If (check = "timer_flash")
	{
		IniWrite, % (settings.leveltracker.timer_flash := !settings.leveltracker.timer_flash), % "ini" vars.poe_version "\leveling tracker.ini", settings, enable timer flashing
		GuiControl, % "+c" (settings.leveltracker.timer_flash ? "Lime" : "Gray"), % cHWND
		GuiControl, % "movedraw", % cHWND
	}
	Else If (check = "fade")
	{
		IniWrite, % (settings.leveltracker.fade := !settings.leveltracker.fade), % "ini" vars.poe_version "\leveling tracker.ini", settings, enable fading
		If !settings.leveltracker.fade && LLK_Overlay(vars.hwnd.leveltracker.main, "check")
			Leveltracker_Progress(1)
		Settings_menu("leveling tracker")
	}
	Else If (check = "fadetime")
	{
		input := LLK_ControlGet(cHWND)
		IniWrite, % (settings.leveltracker.fadetime := (!input ? 0 : Round(input * 1000))), % "ini" vars.poe_version "\leveling tracker.ini", settings, fade-time
	}
	Else If (check = "fade_hover")
	{
		IniWrite, % (settings.leveltracker.fade_hover := !settings.leveltracker.fade_hover), % "ini" vars.poe_version "\leveling tracker.ini", settings, show on hover
		GuiControl, % "+c" (settings.leveltracker.fade_hover ? "Lime" : "Gray"), % cHWND
		GuiControl, % "movedraw", % cHWND
	}
	Else If (check = "geartracker")
	{
		IniWrite, % (settings.leveltracker.geartracker := !settings.leveltracker.geartracker), % "ini" vars.poe_version "\leveling tracker.ini", settings, enable geartracker
		If settings.leveltracker.geartracker
			Geartracker_GUI("refresh")
		If WinExist("ahk_id " vars.hwnd.leveltracker.main)
			Leveltracker_Progress(1)
		GuiControl, % "+c" (settings.leveltracker.geartracker ? "Lime" : "Gray"), % cHWND
		GuiControl, % "movedraw", % cHWND
	}
	Else If (check = "recommend")
	{
		IniWrite, % (settings.leveltracker.recommend := !settings.leveltracker.recommend), % "ini" vars.poe_version "\leveling tracker.ini", settings, enable level recommendations
		If LLK_Overlay(vars.hwnd.leveltracker.main, "check")
			Leveltracker_Progress(1)
		GuiControl, % "+c" (settings.leveltracker.recommend ? "Lime" : "Gray"), % cHWND
		GuiControl, % "movedraw", % cHWND
	}
	Else If (check = "hotkeys_enable")
	{
		IniWrite, % (settings.leveltracker.hotkeys := !settings.leveltracker.hotkeys), % "ini" vars.poe_version "\leveling tracker.ini", settings, enable page hotkeys
		settings.leveltracker.hotkey_01 := settings.leveltracker.hotkey_1, settings.leveltracker.hotkey_02 := settings.leveltracker.hotkey_2
		Leveltracker_Hotkeys("refresh"), Settings_menu("leveling tracker")
	}
	Else If (check = "tree_hotkey")
	{
		input := LLK_ControlGet(cHWND)
		If Blank(input) && !Blank(settings.leveltracker.tree_hotkey) || (input != settings.leveltracker.tree_hotkey)
		{
			GuiControl, % "-Hidden", % vars.hwnd.settings.tree_hotkey_save
			GuiControl, % "-Hidden", % vars.hwnd.settings.tree_hotkey_save_bar
			GuiControl, % "+cRed", % cHWND
			GuiControl, % "movedraw", % cHWND
		}
		Else
		{
			GuiControl, % "+Hidden", % vars.hwnd.settings.tree_hotkey_save
			GuiControl, % "+Hidden", % vars.hwnd.settings.tree_hotkey_save_bar
			GuiControl, % "+cBlack", % cHWND
			GuiControl, % "movedraw", % cHWND
		}
	}
	Else If (check = "tree_hotkey_save")
	{
		input := LLK_ControlGet(vars.hwnd.settings.tree_hotkey)
		If !GetKeyVK(input) && !Blank(input)
		{
			LLK_ToolTip(Lang_Trans("m_hotkeys_error"),,,,, "Red")
			Return
		}
		Hotkey, If, vars.leveltracker.skilltree_schematics.GUI && WinActive("ahk_group poe_ahk_window")
		If !Blank(settings.leveltracker.tree_hotkey)
			Hotkey, % "~" Hotkeys_Convert(settings.leveltracker.tree_hotkey), Hotkeys_ESC, Off
		If !Blank(input)
			Hotkey, % "~" Hotkeys_Convert(input), Hotkeys_ESC, On
		IniWrite, % """" (settings.leveltracker.tree_hotkey := input) """", % "ini" vars.poe_version "\leveling tracker.ini", settings, tree hotkey
		GuiControl, % "+Hidden", % vars.hwnd.settings.tree_hotkey_save
		GuiControl, % "movedraw", % vars.hwnd.settings.tree_hotkey_save
	}
	Else If (check = "autotrack")
	{
		IniWrite, % (settings.leveltracker.autotrack := !settings.leveltracker.autotrack), % "ini" vars.poe_version "\leveling tracker.ini", Settings, autotrack
		GuiControl, % "+c" (settings.leveltracker.autotrack ? "Lime" : "Gray"), % cHWND
		GuiControl, % "movedraw", % cHWND
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
		If !InStr(vars.hwnd.settings.hotkey_1 "," vars.hwnd.settings.hotkey_2, hwnd)
			Return
		input0 := LLK_ControlGet(hwnd)

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

		GuiControl, +cBlack, % hwnd
		GuiControl, movedraw, % hwnd
	}
	Else If (check = "treeclear")
	{
		If (vars.system.click = 1) && LLK_Progress(vars.hwnd.settings.treeclear_bar, "LButton",,, 500, "Red", vars.settings.cButtons)
		{
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
	{
		IniWrite, % (settings.leveltracker.gemlinksToggle := !settings.leveltracker.gemlinksToggle), % "ini" vars.poe_version "\leveling tracker.ini", settings, toggle gem-links
		GuiControl, % "+c" settings.general["c" (settings.leveltracker.gemlinksToggle ? "Enabled" : "Disabled")], % cHWND
		GuiControl, % "movedraw", % cHWND
	}
	Else If (check = "pobmanual")
	{
		IniWrite, % (settings.leveltracker.pobmanual := !settings.leveltracker.pobmanual), % "ini" vars.poe_version "\leveling tracker.ini", settings, manual pob-screencap
		Settings_menu("leveling tracker")
	}
	Else If (check = "pob")
	{
		IniWrite, % (settings.leveltracker.pob := !settings.leveltracker.pob), % "ini" vars.poe_version "\leveling tracker.ini", settings, enable pob-screencap
		GuiControl, % "+c" settings.general["c" (settings.leveltracker.pob ? "Enabled" : "Disabled")], % cHWND
		GuiControl, % "movedraw", % cHWND
	}
	Else If (check = "screencap")
		LLK_Overlay(vars.hwnd.settings.main, "hide"), Leveltracker_ScreencapMenu()
	Else If (check = "folder")
		Run, % "explore img\GUI\skill-tree" settings.leveltracker.profile "\"
	Else If InStr(check, "editprofile")
		Leveltracker_GuideEditor("profile#" settings.leveltracker.profile), LLK_Overlay(vars.hwnd.settings.main, "hide")
	Else If InStr(check, "profile")
	{
		target_profile := IsNumber(SubStr(check, 0)) ? SubStr(check, 0) : ""
		If (vars.system.click = 2) && FileExist("ini" vars.poe_version "\leveling guide" target_profile ".ini") && LLK_Progress(vars.hwnd.settings["profile" target_profile "_bar"], "RButton",,, 500, "Red", vars.settings.cButtons)
		{
			FileDelete, % "ini" vars.poe_version "\leveling guide" target_profile ".ini"
			IniDelete, % "ini" vars.poe_version "\search-strings.ini", hideout lilly, % "00-PoB gems: slot " (!target_profile ? "1" : target_profile)
			IniDelete, % "ini" vars.poe_version "\leveling tracker.ini", % "current run" target_profile
			If vars.searchstrings.list["hideout lilly"]
				Init_searchstrings()

			If (settings.leveltracker.profile = target_profile)
			{
				Leveltracker_Toggle("destroy"), vars.hwnd.leveltracker.main := ""
				vars.leveltracker.timer := {}
				Loop, Files, % "ini" vars.poe_version "\leveling guide*.ini"
				{
					new_file := SubStr(StrReplace(A_LoopFileName, ".ini"), 0), new_file := IsNumber(new_file) ? new_file : ""
					Break
				}
				IniWrite, % (settings.leveltracker.profile := new_file), % "ini" vars.poe_version "\leveling tracker.ini", Settings, profile
				Init_leveltracker(), Leveltracker_Load()
			}
			Else vars.leveltracker.characters.Delete((target_profile ? target_profile : 1))
			Settings_menu("leveling tracker")
			Return
		}
		Else If (vars.system.click = 2)
			Return
		KeyWait, LButton
		KeyWait, RButton
		If (settings.leveltracker.profile = target_profile) && FileExist("ini" vars.poe_version "\leveling guide" target_profile ".ini")
			Return
		If !FileExist("ini" vars.poe_version "\leveling guide" target_profile ".ini")
		{
			Leveltracker_GuideEditor("default#" target_profile)
			Return
		}
		GuiControl, +cWhite, % vars.hwnd.settings["profile" settings.leveltracker.profile]
		GuiControl, movedraw, % vars.hwnd.settings["profile" settings.leveltracker.profile]
		timer := vars.leveltracker.timer
		If IsNumber(timer.current_split) && (timer.current_split != timer.current_split0)
			IniWrite, % (timer.current_split0 := timer.current_split), % "ini" vars.poe_version "\leveling tracker.ini", % "current run" settings.leveltracker.profile, time
		settings.leveltracker.profile := target_profile, vars.leveltracker.timer.pause := -1
		IniWrite, % settings.leveltracker.profile, % "ini" vars.poe_version "\leveling tracker.ini", Settings, profile

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
		profile := settings.leveltracker.profile
		If (vars.system.click = 1) && LLK_Progress(vars.hwnd.settings.resetbar, "LButton",,, 500, "Red", vars.settings.cButtons,, (settings.leveltracker["guide" profile].info.custom ? "FF8000" : vars.settings.cButtons2))
			Leveltracker_ProgressReset(settings.leveltracker.profile)
		Else Return
	}
	Else If InStr(check, "pobpreview")
	{
		profile := settings.leveltracker.profile, info := vars.leveltracker["pob" profile]
		If (vars.system.click = 2) && LLK_Progress(vars.hwnd.settings[check "_bar"], "RButton",,, 500, "Red", vars.settings.cButtons)
		{
			If vars.leveltracker.skilltree_schematics.GUI
				Leveltracker_PobSkilltree("close")
			IniDelete, % "ini" vars.poe_version "\leveling guide" profile ".ini", PoB
			IniDelete, % "ini" vars.poe_version "\leveling guide" profile ".ini", Info, gems
			IniWrite, 0, % "ini" vars.poe_version "\leveling guide" profile ".ini", Progress, pages
			Init_leveltracker(), Leveltracker_Load()
			IniDelete, % "ini" vars.poe_version "\search-strings.ini", hideout lilly, % "00-PoB gems: slot " (!profile ? "1" : profile)
			Init_searchstrings()
			If LLK_Overlay(vars.hwnd.leveltracker.main, "check")
				Leveltracker_Progress(1)
			Settings_menu("leveling tracker")
			Return
		}
		Else If (vars.system.click = 2)
			Return
		For index, val in info.ascendancies
			ascendancy .= (!ascendancy ? "" : ", ") val
		text := "class: " info.class "`nascendancy: " ascendancy (!vars.poe_version ? "`nbandit: " info.bandit : "") "`nskill-sets: " info.gems.Count() "`nskill-trees: " info.trees.Count()
		LLK_ToolTip(text, 0,,, "pobtooltip")
		KeyWait, LButton
		LLK_Overlay(vars.hwnd.tooltip_pobtooltip, "destroy")
	}
	Else If (check = "leaguestart")
	{
		profile := settings.leveltracker.profile
		IniWrite, % (input := settings.leveltracker["guide" profile].info.leaguestart := !settings.leveltracker["guide" profile].info.leaguestart), % "ini" vars.poe_version "\leveling guide" profile ".ini", Info, leaguestart
		IniWrite, 0, % "ini" vars.poe_version "\leveling guide" profile ".ini", Progress, pages

		If input
			IniWrite, % (settings.leveltracker["guide" profile].info.gems := 1), % "ini" vars.poe_version "\leveling guide" profile ".ini", Info, gems
		Settings_menu("leveling tracker")
		Leveltracker_Load()
		If LLK_Overlay(vars.hwnd.leveltracker.main, "check")
			Leveltracker_Progress(1)
		GuiControl, % "+c" (input ? "Lime" : "Gray"), % cHWND
		GuiControl, % "movedraw", % cHWND
	}
	Else If (check = "optionals")
	{
		profile := settings.leveltracker.profile
		IniWrite, % (input := settings.leveltracker["guide" profile].info.optionals := !settings.leveltracker["guide" profile].info.optionals), % "ini" vars.poe_version "\leveling guide" profile ".ini", Info, optionals
		If LLK_Overlay(vars.hwnd.leveltracker.main, "check")
			Leveltracker_Progress(1)
		GuiControl, % "+c" (input ? "Lime" : "Gray"), % cHWND
		GuiControl, % "movedraw", % cHWND
	}
	Else If (check = "gems")
	{
		profile := settings.leveltracker.profile
		If (vars.system.click = 2)
		{
			If !settings.leveltracker["guide" profile].info.gems
				Return
			LLK_Overlay(vars.hwnd.settings.main, "hide")
			Leveltracker_GemPickups()
			Return
		}
		If settings.leveltracker["guide" profile].info.leaguestart
			Return
		IniWrite, % (input := settings.leveltracker["guide" profile].info.gems := !settings.leveltracker["guide" profile].info.gems), % "ini" vars.poe_version "\leveling guide" profile ".ini", Info, gems
		If !input
			IniWrite, % (settings.leveltracker["guide" profile].info.gems_all := 0), % "ini" vars.poe_version "\leveling guide" profile ".ini", Info, gems_all
		IniWrite, 0, % "ini" vars.poe_version "\leveling guide" profile ".ini", Progress, pages
		Leveltracker_Load()
		If LLK_Overlay(vars.hwnd.leveltracker.main, "check")
			Leveltracker_Progress(1)
		Settings_menu()
	}
	Else If (check = "gems_all")
	{
		profile := settings.leveltracker.profile
		IniWrite, % (input := settings.leveltracker["guide" profile].info.gems_all := !settings.leveltracker["guide" profile].info.gems_all), % "ini" vars.poe_version "\leveling guide" profile ".ini", Info, gems_all
		IniWrite, 0, % "ini" vars.poe_version "\leveling guide" profile ".ini", Progress, pages
		Leveltracker_Load()
		If LLK_Overlay(vars.hwnd.leveltracker.main, "check")
			Leveltracker_Progress(1)
		GuiControl, % "+c" (input ? "Lime" : "Gray"), % cHWND
		GuiControl, % "movedraw", % cHWND
	}
	Else If (check = "bandit")
	{
		bandits := ["none", "alira", "kraityn", "oak"], profile := settings.leveltracker.profile
		If Blank(input := Gui_DropDownList(vars.ddl.bandit, LLK_WinGetPos(cHWND, "array"), "Center", 1, "Center")) || IsObject(input) && Blank(input.1 . input.2)
			Return
		IniWrite, % (settings.leveltracker["guide" profile].info.bandit := bandits[input.2]), % "ini" vars.poe_version "\leveling guide" profile ".ini", Info, bandit
		IniWrite, 0, % "ini" vars.poe_version "\leveling guide" profile ".ini", Progress, pages
		Leveltracker_Load(), vars.ddl.bandit.current := input.1
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
		LLK_FontDimensions(settings.leveltracker.fSize, height, width), settings.leveltracker.fHeight := height, settings.leveltracker.fWidth := width, settings.leveltracker.radius := Ceil((height - 2)/3)
		LLK_FontDimensions(settings.leveltracker.fSize - 2, height, width), settings.leveltracker.fHeight2 := height, settings.leveltracker.fWidth2 := width, settings.leveltracker.radius2 := Ceil((height - 2)/3)
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
		GuiControl, +cLime, % vars.hwnd.settings["opac_" control]
		GuiControl, movedraw, % vars.hwnd.settings["opac_" control]
	}
	Else LLK_ToolTip("no action")
}

Settings_lootfilter()
{
	local
	global vars, settings
	static fSize, wALT, wSize

	GUI := "settings_menu" vars.settings.GUI_toggle, x_anchor := vars.settings.x_anchor

	Gui, %GUI%: Add, Text, % "Section x" x_anchor " y" vars.settings.ySelection " Border BackgroundTrans gSettings_lootfilter2 HWNDhwnd" (settings.features.lootfilter ? " cLime" : " cGray"), % " " Lang_Trans("global_enable") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.enable := hwnd, vars.hwnd.help_tooltips["settings_lootfilter enable"] := hwnd1

	Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans HWNDhwnd gURL cAqua", % " wiki page "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.URLs := {}, vars.URLs[hwnd] := "https://github.com/Lailloken/Exile-UI/wiki/FilterSpoon", vars.hwnd.help_tooltips["settings_website"] := hwnd1

	If !settings.features.lootfilter
		Return

	If (fSize != settings.general.fSize)
	{
		fSize := settings.general.fSize
		LLK_PanelDimensions([Lang_Trans("global_ctrl"), Lang_Trans("global_alt")], fSize, wALT, hALT)
		LLK_PanelDimensions([Lang_Trans("global_size") . Lang_Trans("global_colon"), Lang_Trans("global_opacity"), Lang_Trans("global_volume") . Lang_Trans("global_colon"), Lang_Trans("global_sound", 2) . Lang_Trans("global_colon"), Lang_Trans("global_test"), Lang_Trans("global_restore")], fSize, wSize, hSize)
	}

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "xs Section y+" vars.settings.spacing, % Lang_Trans("global_general")
	Gui, %GUI%: Font, norm

	Gui, %GUI%: Add, Text, % "xs Section Border BackgroundTrans", % " " Lang_Trans("m_cheat_modifier") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd Background404040 cBlack", 100
	For index, val in ["ctrl", "alt"]
	{
		Gui, %GUI%: Add, Text, % "ys x+-1 Border BackgroundTrans Center gSettings_lootfilter2 HWNDhwnd c" (settings.lootfilter.modifier_key = val ? "Lime" : "White") " w" wALT, % Lang_Trans("global_" val)
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd_bar Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings["modifierkey_" val] := hwnd, vars.hwnd.help_tooltips["settings_lootfilter modifier keys" (index = 2 ? "|" : "")] := hwnd_bar
	}
	vars.hwnd.help_tooltips["settings_lootfilter modifier keys||"] := hwnd

	Gui, %GUI%: Add, Text, % "Section xs Center Border BackgroundTrans gSettings_lootfilter2 HWNDhwnd c" (settings.lootfilter.notify ? "Lime" : "Gray"), % " " Lang_Trans("global_notification") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.notify := hwnd, vars.hwnd.help_tooltips["settings_lootfilter notification"] := hwnd1

	If settings.lootfilter.notify
	{
		Gui, %GUI%: Add, Text, % "ys x+-1 w" settings.general.fWidth * 3 " Center Border BackgroundTrans gSettings_lootfilter2 HWNDhwnd", % settings.lootfilter.notify
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings.notify_hours := hwnd, vars.hwnd.help_tooltips["settings_slider general"] := hwnd1
	}

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "xs Section y+" vars.settings.spacing, % Lang_Trans("global_ui")
	Gui, %GUI%: Font, norm

	Gui, %GUI%: Add, Text, % "xs Section Border BackgroundTrans", % " " Lang_Trans("global_font") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd0 Background404040 cBlack", 100
	Gui, %GUI%: Add, Text, % "ys x+-1 gSettings_lootfilter2 Border BackgroundTrans Center HWNDhwnd w" settings.general.fWidth*2, % "–"
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.font_minus := hwnd, vars.hwnd.help_tooltips["settings_font-size|"] := hwnd1

	Gui, %GUI%: Add, Text, % "x+-1 ys Border BackgroundTrans Center gSettings_lootfilter2 HWNDhwnd w" settings.general.fWidth*3, % settings.lootfilter.fSize
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.font_reset := hwnd, vars.hwnd.help_tooltips["settings_font-size||"] := hwnd1

	Gui, %GUI%: Add, Text, % "wp x+-1 ys gSettings_lootfilter2 Border BackgroundTrans Center HWNDhwnd w" settings.general.fWidth*2, % "+"
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.font_plus := hwnd, vars.hwnd.help_tooltips["settings_font-size|||"] := hwnd1

	Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans", % " " Lang_Trans("m_lootfilter_colors") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd Background404040 cBlack", 100
	vars.hwnd.help_tooltips["settings_lootfilter colors"] := hwnd
	Gui, %GUI%: Add, Text, % "ys x+-1 w" settings.general.fWidth " hp Border BackgroundTrans gSettings_lootfilter2 HWNDhwnd"
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border BackgroundBlack HWNDhwnd1 c" settings.lootfilter.color_background, 100
	Gui, %GUI%: Add, Text, % "ys x+-1 w" settings.general.fWidth " hp Border BackgroundTrans gSettings_lootfilter2 HWNDhwnd2"
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border BackgroundBlack HWNDhwnd3 c" settings.lootfilter.color_accent, 100
	vars.hwnd.settings.color_background := hwnd, vars.hwnd.settings.color_background_bar := vars.hwnd.help_tooltips["settings_generic color"] := hwnd1
	vars.hwnd.settings.color_accent := hwnd2, vars.hwnd.settings.color_accent_bar := vars.hwnd.help_tooltips["settings_generic color|"] := hwnd3

	If !settings.lootfilter.active_filter || !vars.lootfilter.filters_list.Count()
	{
		vars.lootfilter.settings_waiting := 1
		Return
	}

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "xs Section y+" vars.settings.spacing, % Lang_Trans("m_lootfilter_tester")
	Gui, %GUI%: Font, norm
	Gui, %GUI%: Add, Pic, % "ys hp w-1 HWNDhwnd", % "HBitmap:*" vars.pics.global.help
	vars.hwnd.help_tooltips["settings_lootfilter filter-tester"] := hwnd, dimensions := []

	For index, val in ["wisdom", "transmute", "aug", "whetstone", "scrap"]
	{
		If !vars.pics.settings_lootfilter[val]
			vars.pics.settings_lootfilter[val] :=LLK_ImageCache("img\GUI\currency\" val . vars.poe_version ".png",, settings.general.fHeight)
		Gui, %GUI%: Add, Pic, % (index = 1 ? "x+" vars.settings.spacing : "x+0") " ys", % "HBitmap:*" vars.pics.settings_lootfilter[val]
	}

	If !vars.lootfilter_tester.Count()
		vars.lootfilter_tester := {"opacity": "maximum", "size": "maximum", "volume": "maximum", "sound": 1}
	tester := vars.lootfilter_tester, types := ["size", "opacity", "volume"]

	For outer, type in types
	{
		Gui, %GUI%: Add, Text, % "Section xs Right Border BackgroundTrans w" wSize, % StrReplace(Lang_Trans("global_" type), Lang_Trans("global_colon")) . Lang_Trans("global_colon") " "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border Background404040 cBlack", 100
		For key, val in {"i": "minimum", "ii": "medium", "iii": "maximum"}
		{
			label := Lang_Trans("global_" val, 2) . Lang_Trans("global_colon") " " settings.lootfilter[type "_" val]
			Gui, %GUI%: Add, Text, % "ys x+-1 Center Border BackgroundTrans gSettings_lootfilter2 HWNDhwnd w" 3*settings.general.fWidth . (val = vars.lootfilter_tester[type] ? " cLime" : ""), % key
			Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
			vars.hwnd.settings[type "preset_" val] := hwnd, vars.hwnd.help_tooltips["settings_lootfilter filter-tester presets" preset_handle] := hwnd1, preset_handle .= "|"
		}
		Gui, %GUI%: Add, Text, % "ys x+-1 w" 4*settings.general.fWidth " Center Border BackgroundTrans gSettings_lootfilter2 HWNDhwnd", % settings.lootfilter[type "_" tester[type]]
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		Gui, %GUI%: Add, Text, % "ys x+-1 hp Border BackgroundTrans 0x200 HWNDhwnd2 gSettings_lootfilter2", % " " Lang_Trans("global_reset") " "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings[type "value"] := hwnd, vars.hwnd.help_tooltips["settings_slider general|" slider_handle] := hwnd1, vars.hwnd.settings["reset_" type] := hwnd2, slider_handle .= "|"
	}

	cReset := LLK_ControlGetPos(hwnd2), DDL := []
	If !settings.lootfilter.sound_tags.HasKey(tester.sound)
		vars.lootfilter_tester.sound := LLK_HasVal(settings.lootfilter.sound_tags, tester.sound)
	vars.lootfilter_tester.sound_index := settings.lootfilter.sound_tags[tester.sound]

	For outer in [1, 2]
		For key, val in settings.lootfilter.sound_tags
			If (outer = 1) && !IsNumber(key) || (outer = 2) && IsNumber(key)
				DDL.Push(key)

	Gui, %GUI%: Add, Text, % "Section xs Right Border BackgroundTrans w" wSize, % Lang_Trans("global_sound", 2) . Lang_Trans("global_colon") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border Background404040 cBlack", 100
	Gui, %GUI%: Font, % "s" settings.general.fSize
	LLK_PanelDimensions(DDL, fSize, wDDL, hDDL)

	Gui, %GUI%: Add, Text, % "ys x+-1 w" wDDL " hp Center Border BackgroundTrans gSettings_lootfilter2 HWNDhwnd cLime", % vars.lootfilter_tester.sound
	vars.ddl.sound_pick := {"cHWND": hwnd, "current": vars.lootfilter_tester.sound, "fSize": fSize, "list": DDL.Clone(), "color": vars.settings.cButtons}
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	cDDL := LLK_ControlGetPos(hwnd), vars.hwnd.help_tooltips["settings_lootfilter filter-tester sound pick"] := hwnd1

	Gui, %GUI%: Font, % "s" settings.general.fSize - 4
	Gui, %GUI%: Add, Edit, % "ys x+0 hp Border Limit16 cBlack gSettings_lootfilter2 HWNDhwnd1 w" cReset.xMax - cDDL.xMax, % (IsNumber(vars.lootfilter_tester.sound) ? "" : vars.lootfilter_tester.sound)
	Gui, %GUI%: Add, Button, % "xp hp Hidden Default gSettings_lootfilter2 HWNDhwnd2", a
	vars.hwnd.settings.sound_pick := vars.hwnd.help_tooltips["settings_lootfilter filter-tester sounds"] := hwnd
	vars.hwnd.settings.sound_tag := vars.hwnd.help_tooltips["settings_lootfilter filter-tester sound tags"] := hwnd1, vars.hwnd.settings.sound_ok := hwnd2

	Gui, %GUI%: Font, % "s" settings.general.fSize
	Gui, %GUI%: Add, Text, % "Section xs y+" vars.settings.spacing " Center Border BackgroundTrans HWNDhwnd gSettings_lootfilter2 w" wSize, % Lang_Trans("global_test")
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	Gui, %GUI%: Add, Text, % "Section xs wp Border BackgroundTrans Center HWNDhwnd2 gSettings_lootfilter2", % Lang_Trans("global_restore")
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd3 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.tester_test := hwnd, vars.hwnd.help_tooltips["settings_lootfilter filter-tester apply"] := hwnd1
	vars.hwnd.settings.tester_restore := hwnd2, vars.hwnd.settings.tester_restore_bar := vars.hwnd.help_tooltips["settings_lootfilter filter-tester restore"] := hwnd3

	vars.lootfilter.settings_waiting := 0
}

Settings_lootfilter2(cHWND := "")
{
	local
	global vars, settings

	check := LLK_HasVal(vars.hwnd.settings, cHWND), control := SubStr(check, InStr(check, "_") + 1)
	If !RegExMatch(check, "i)font_|notify_hours|value$")
	{
		KeyWait, LButton
		KeyWait, RButton
	}
	If (check = "sound_pick")
	{
		If Blank(input := Gui_DropDownList(vars.ddl[check], LLK_WinGetPos(cHWND, "array")))
			Return
		vars.ddl.sound_pick.current := vars.lootfilter_tester.sound := input, vars.lootfilter_tester.sound_index := settings.lootfilter.sound_tags[input], check := "tester_test", control := "test"
		GuiControl,, % vars.hwnd.settings.sound_tag, % (IsNumber(input) ? "" : input)
	}
	Switch
	{
		Case (check = "enable"):
		IniWrite, % (settings.features.lootfilter := !settings.features.lootfilter), % "ini" vars.poe_version "\config.ini", features, enable filterspoon
		If !settings.features.lootfilter && WinExist("ahk_id " vars.hwnd.lootfilter.main)
			Lootfilter_Editor("close")
		Settings_menu("filterspoon")
		;######################################################
		Case (check = "notify"):
		If (vars.system.click = 2)
		{
			Settings_menu("notifications")
			Return
		}
		IniWrite, % (settings.lootfilter.notify := (settings.lootfilter.notify ? 0 : 8)), % "ini" vars.poe_version "\lootfilter.ini", settings, sync notification
		Settings_menu("filterspoon")
		;######################################################
		Case (check = "notify_hours"):
		input := Gui_Slider(cHWND, [4, settings.lootfilter.notify, 48], 10)
		IniWrite, % (settings.lootfilter.notify := input), % "ini" vars.poe_version "\lootfilter.ini", settings, sync notification
		;######################################################
		Case InStr(check, "modifierkey_"):
		IniWrite, % (settings.lootfilter.modifier_key := control), % "ini" vars.poe_version "\lootfilter.ini", settings, modifier key
		GuiControl, +cLime, % cHWND
		GuiControl, movedraw, % cHWND
		GuiControl, +cWhite, % vars.hwnd.settings["modifierkey_" (control = "ctrl" ? "alt" : "ctrl")]
		GuiControl, movedraw, % vars.hwnd.settings["modifierkey_" (control = "ctrl" ? "alt" : "ctrl")]
		;######################################################
		Case InStr(check, "font_"):
		While GetKeyState("LButton", "P")
		{
			If (control = "reset")
				settings.lootfilter.fSize := settings.general.fSize
			Else settings.lootfilter.fSize += (control = "minus" && settings.lootfilter.fSize > 6 ? -1 : (control = "plus" ? 1 : 0))
			GuiControl, text, % vars.hwnd.settings.font_reset, % settings.lootfilter.fSize
			Sleep 150
		}
		IniWrite, % settings.lootfilter.fSize, % "ini" vars.poe_version "\lootfilter.ini", settings, font-size
		LLK_FontDimensions(settings.lootfilter.fSize, height, width), settings.lootfilter.fWidth := width, settings.lootfilter.fHeight := height
		LLK_FontDimensions(settings.lootfilter.fSize - 2, height, width), settings.lootfilter.fWidth2 := width, settings.lootfilter.fHeight2 := height
		If WinExist("ahk_id " vars.hwnd.lootfilter.main)
			Lootfilter_Editor()
		;######################################################
		Case InStr(check, "color_"):
		If (vars.system.click = 2)
			RGB := settings.lootfilter["color_" control "_default"]
		Else RGB := RGB_Picker(settings.lootfilter["color_" control])

		If Blank(RGB)
			Return
		settings.lootfilter["color_" control] := RGB
		IniWrite, % """" (vars.system.click = 2 ? "" : RGB) """", % "ini" vars.poe_version "\lootfilter.ini", UI, % control " color"
		GuiControl, % "+c" RGB, % vars.hwnd.settings["color_" control "_bar"]
		GuiControl, % "movedraw", % vars.hwnd.settings["color_" control "_bar"]
		If WinExist("ahk_id " vars.hwnd.lootfilter.main)
			Lootfilter_Editor()
		;######################################################
		Case InStr(check, "preset_"):
		type := SubStr(check, 1, InStr(check, "preset_") - 1)
		For key, hwnd in vars.hwnd.settings
			If InStr(key, type "preset_")
			{
				GuiControl, % "+c" (InStr(key, control) ? "Lime" : "White"), % hwnd
				GuiControl, % "movedraw", % hwnd
			}
		vars.lootfilter_tester[type] := control
		GuiControl,, % vars.hwnd.settings[type "value"], % settings.lootfilter[type "_" control]
		;######################################################
		Case InStr(check, "value"):
		type := SubStr(check, 1, InStr(check, "value") - 1), ranges := {"size": [10, 45], "opacity": [50, 255], "volume": [0, 300]}, ranges[type].InsertAt(2, settings.lootfilter[type "_" vars.lootfilter_tester[type]])
		increments := {"size": 1, "opacity": 5, "volume": 10}
		input := Gui_Slider(cHWND, ranges[type], (type = "size" ? 10 : 15),, increments[type])
		If (input = settings.lootfilter[type "_" vars.lootfilter_tester[type]])
			Return
		IniWrite, % (settings.lootfilter[type "_" vars.lootfilter_tester[type]] := input), % "ini" vars.poe_version "\lootfilter.ini", UI, % vars.lootfilter_tester[type] " " type
		If WinExist("ahk_id " vars.hwnd.lootfilter.main)
			Lootfilter_Editor()
		ControlFocus,, % "ahk_id " vars.hwnd.settings.enable
		;######################################################
		Case InStr(check, "reset_"):
		For index, val in ["minimum", "medium", "maximum"]
			IniWrite, % (settings.lootfilter[control "_" val] := settings.lootfilter.defaults[control][val]), % "ini" vars.poe_version "\lootfilter.ini", UI, % val " " control
		Settings_menu("filterspoon")
		;######################################################
		Case (check = "sound_tag"):
		input := LLK_ControlGet(cHWND)
		If !Blank(input)
		{
			GuiControl, % "+c" (input != LLK_HasVal(settings.lootfilter.sound_tags, vars.lootfilter_tester.sound_index) ? "Red" : "Black"), % vars.hwnd.settings.sound_tag
			GuiControl, % "movedraw", % vars.hwnd.settings.sound_tag
		}
		;######################################################
		Case (check = "sound_ok"):
		input := LLK_ControlGet(vars.hwnd.settings.sound_tag)
		If IsNumber(input)
		{
			LLK_ToolTip(Lang_Trans("global_errorname", 2),,,,, "Red")
			Return
		}
		input := (Blank(input) ? vars.lootfilter_tester.sound_index : input)
		settings.lootfilter.sound_tags.Delete(vars.lootfilter_tester.sound), settings.lootfilter.sound_tags[input] := vars.lootfilter_tester.sound_index
		IniWrite, % """" input """", % "ini" vars.poe_version "\lootfilter.ini", sounds, % vars.lootfilter_tester.sound_index
		vars.lootfilter_tester.sound := input, Settings_menu("filterspoon")
		If vars.hwnd.lootfilter.main && WinExist("ahk_id " vars.hwnd.lootfilter.main)
			Lootfilter_Editor()
		;######################################################
		Case InStr(check, "tester_"):
			If (control = "test")
				Lootfilter_TesterDump(), vars.lootfilter.tester_applied := 1
			Else
			{
				vars.lootfilter.tester_applied := 0
				GuiControl, % "+cWhite", % vars.hwnd.settings.tester_restore
				GuiControl, % "+c" vars.settings.cButtons " +Background" vars.settings.cButtons2, % vars.hwnd.settings.tester_restore_bar
			}
			Clipboard := "/itemfilter " (control = "test" || vars.lootfilter.modifications["profile" settings.lootfilter.profile].Count() > 1 ? "FilterSpoon" (control = "test" ? "_tester" : "") : settings.lootfilter.active_filter)
			WinActivate, % "ahk_id " vars.hwnd.poe_client
			WinWaitActive, % "ahk_id " vars.hwnd.poe_client,, 2
			If ErrorLevel
			{
				LLK_ToolTip(Lang_Trans("global_errorpaste"), 2,,,, "Red")
				Return
			}
			SendInput, {ENTER}
			Sleep, 100
			SendInput, ^{a}^{v}{ENTER}
		;######################################################
		Case check:
			LLK_ToolTip("no action")
			Return
	}
}

Settings_macros()
{
	local
	global vars, settings
	static sMenu, fSize, wHotkey, wHeader

	If (fSize != settings.general.fSize) || (settings.macros.sMenu != sMenu)
	{
		fSize := settings.general.fSize
		LLK_PanelDimensions([Lang_Trans("global_hotkey"), Lang_Trans("global_save")], fSize, wHotkey, hHotkey)
		LLK_PanelDimensions([Lang_Trans("m_macros_fasttravel"), Lang_Trans("m_macros_custom")], fSize, wHeader, hHeader,,, 0,,, "underline bold")
		For key, hbm in vars.pics.settings_macros
			DeleteObject(hbm)
		vars.pics.settings_macros := {}, sMenu := settings.macros.sMenu
	}

	GUI := "settings_menu" vars.settings.GUI_toggle, x_anchor := vars.settings.x_anchor, margin := vars.settings.xMargin

	Gui, %GUI%: Add, Text, % "Section x" x_anchor " y" vars.settings.ySelection " Border BackgroundTrans HWNDhwnd gURL cAqua", % " wiki page "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.URLs := {}, vars.URLs[hwnd] := "https://github.com/Lailloken/Exile-UI/wiki/Chat-Macros", vars.hwnd.help_tooltips["settings_website"] := hwnd1

	Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans HWNDhwnd gURL cAqua", % " ahk: key list "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.URLs[hwnd] := "https://www.autohotkey.com/docs/v1/KeyList.htm", vars.hwnd.help_tooltips["settings_website|"] := hwnd1

	Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans HWNDhwnd gURL cAqua", % " poe.wiki: chat "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.URLs[hwnd] := "https://www.poe" StrReplace(vars.poe_version, " ") "wiki.net/wiki/Chat#Commands", vars.hwnd.help_tooltips["settings_website||"] := hwnd1

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "Section xs Center y+" vars.settings.spacing, % Lang_Trans("global_ui")
	Gui, %GUI%: Font, norm
	Gui, %GUI%: Add, Text, % "Section xs Border BackgroundTrans", % " " Lang_Trans("m_general_menuwidget") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd Background404040 cBlack", 100
	vars.hwnd.help_tooltips["settings_font-size"] := hwnd
	Gui, %GUI%: Add, Text, % "ys x+-1 gSettings_macros2 Border BackgroundTrans Center HWNDhwnd w"settings.general.fWidth*2, % "–"
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.widget_minus := hwnd, vars.hwnd.help_tooltips["settings_font-size|"] := hwnd1
	Gui, %GUI%: Add, Text, % "x+-1 ys gSettings_macros2 Border BackgroundTrans Center HWNDhwnd", % " " settings.macros.sMenu " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.widget_reset := hwnd, vars.hwnd.help_tooltips["settings_font-size||"] := hwnd1
	Gui, %GUI%: Add, Text, % "wp x+-1 ys gSettings_macros2 Border BackgroundTrans Center HWNDhwnd w"settings.general.fWidth*2, % "+"
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.widget_plus := hwnd, vars.hwnd.help_tooltips["settings_font-size|||"] := hwnd1

	Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans gSettings_macros2 HWNDhwnd" (settings.macros.animations ? " cLime" : " cGray"), % " " Lang_Trans("global_animations", 2) " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.animations := hwnd, vars.hwnd.help_tooltips["settings_macros animations"] := hwnd1

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "Section xs x" x_anchor " y+" vars.settings.spacing " h" settings.general.fHeight " 0x200", % Lang_Trans("m_macros_fasttravel")
	Gui, %GUI%: Font, norm

	xPos := x_anchor + 2*settings.general.fWidth + Max(wHeader, 2*settings.general.fWidth + Round(settings.general.fWidth * 3.2 * 4.5))
	Gui, %GUI%: Add, Text, % "ys x" xPos " Right Border BackgroundTrans HWNDhwnd0 w" wHotkey, % Lang_Trans("global_hotkey") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd01 Background404040 cBlack", 100
	Gui, %GUI%: Add, Text, % "Hidden xp yp wp hp Border BackgroundTrans Center cRed gSettings_macros2 HWNDhwnd1", % Lang_Trans("global_save")
	Gui, %GUI%: Add, Progress, % "Disabled Hidden xp yp wp hp Border HWNDhwnd2 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	Gui, %GUI%: Font, % "s" settings.general.fSize - 4
	Gui, %GUI%: Add, Text, % "ys x+-1 w" settings.general.fWidth * 6 " hp Border BackgroundTrans"
	Gui, %GUI%: Add, Edit, % "xp yp wp hp Border HWNDhwnd gSettings_macros2 cBlack", % settings.macros.hotkey_fasttravel
	Gui, %GUI%: Font, % "s" settings.general.fSize
	vars.hwnd.settings.hotkey_fasttravel_label := hwnd0, vars.hwnd.settings.hotkey_fasttravel := vars.hwnd.help_tooltips["settings_macros hotkeys"] := hwnd
	vars.hwnd.settings.hotkeysave_fasttravel := hwnd1, vars.hwnd.settings.hotkeysave_fasttravel_bar := hwnd2, vars.hwnd.settings.hotkey_fasttravel_label_bar := vars.hwnd.help_tooltips["settings_macros fast-travel"] := hwnd01

	height := Round(settings.general.fWidth * 3.2)
	For index, travel in vars.macros.fasttravels
	{
		If !vars.pics.settings_macros[travel]
			vars.pics.settings_macros[travel] := LLK_ImageCache("img\GUI\radial menu\" travel ".png",, height)
		Gui, %GUI%: Add, Text, % (index = 1 ? "Section xs" : "ys x+" settings.general.fWidth/2) " HWNDhwnd1 BackgroundTrans Border gSettings_macros2 w" height + 4 " h" height + 4
		Gui, %GUI%: Add, Pic, % "xp+2 yp+2 HWNDhwnd", % "HBitmap:*" vars.pics.settings_macros[travel]
		Gui, %GUI%: Add, Progress, % "xp-2 yp-2 w" height + 4 " h" height + 4 " HWNDhwnd2 Border Background" (settings.macros[travel] ? "Lime" : "Black") " cBlack", 100
		vars.hwnd.help_tooltips["settings_macros " travel] := hwnd, vars.hwnd.settings["fasttravel_" travel] := hwnd1, vars.hwnd.settings["fasttravel_" travel "_bar"] := hwnd2
	}

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "Section xs Center y+"vars.settings.spacing " h" settings.general.fHeight " 0x200 HWNDhwnd", % Lang_Trans("m_macros_custom")
	vars.hwnd.settings.header_custom := hwnd
	Gui, %GUI%: Font, norm

	Gui, %GUI%: Add, Text, % "Hidden xp yp wp hp Center Border BackgroundTrans gSettings_macros2 cRed HWNDhwnd", % " " Lang_Trans("global_save") " "
	Gui, %GUI%: Add, Progress, % "Hidden Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.custommacros_save := hwnd, vars.hwnd.settings.custommacros_save_bar := hwnd1

	Gui, %GUI%: Add, Text, % "ys x" xPos " Border BackgroundTrans Right HWNDhwnd0 w" wHotkey, % Lang_Trans("global_hotkey") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd01 Background404040 cBlack", 100
	Gui, %GUI%: Add, Text, % "Hidden xp yp wp hp Border Center BackgroundTrans cRed gSettings_macros2 HWNDhwnd1", % " " Lang_Trans("global_save") " "
	Gui, %GUI%: Add, Progress, % "Hidden Disabled xp yp wp hp Border HWNDhwnd2 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	Gui, %GUI%: Font, % "s" settings.general.fSize - 4
	Gui, %GUI%: Add, Text, % "ys x+-1 w" settings.general.fWidth * 6 " hp Border BackgroundTrans"
	Gui, %GUI%: Add, Edit, % "xp yp wp hp Border HWNDhwnd gSettings_macros2 cBlack", % settings.macros.hotkey_custommacros
	Gui, %GUI%: Font, % "s" settings.general.fSize
	vars.hwnd.settings.hotkey_custommacros := vars.hwnd.help_tooltips["settings_macros hotkeys|"] := hwnd, vars.hwnd.settings.hotkey_custommacros_label := hwnd0
	vars.hwnd.settings["hotkeysave_custommacros"] := hwnd1, vars.hwnd.settings.hotkeysave_custommacros_bar := hwnd2, vars.hwnd.settings.hotkey_custommacros_label_bar := vars.hwnd.help_tooltips["settings_macros custom"] := hwnd01
	wEdit := Max(wHeader, 2*settings.general.fWidth + Round(settings.general.fWidth * 3.2 * 4.5)) + wHotkey - settings.general.fHeight - 2*(settings.general.fWidth//2) + 4*settings.general.fWidth - 1

	Loop 9
	{
		Gui, %GUI%: Add, Text, % "Section xs w" settings.general.fHeight " Center HWNDhwnd0 Border BackgroundTrans gSettings_macros2", % A_Index - 1
		enabled := (settings.macros["enable_" A_Index - 1] && (!Blank(settings.macros["label_" A_Index - 1]) || A_Index = 1) && !Blank(settings.macros["command_" A_Index - 1]) ? 1 : 0)
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd01 Background" (enabled ? "Lime" : vars.settings.cButtons2) " c" vars.settings.cButtons, 100
		Gui, %GUI%: Font, % "s" settings.general.fSize - 4
		Gui, %GUI%: Add, Text, % "ys x+" settings.general.fWidth//2 " w" settings.general.fWidth * 4 " hp Border BackgroundTrans"
		Gui, %GUI%: Add, Edit, % "xp yp wp hp Border cBlack HWNDhwnd Limit3 gSettings_macros2" (A_Index = 1 ? " Disabled" : ""), % settings.macros["label_" A_Index - 1]
		Gui, %GUI%: Add, Text, % "ys x+" settings.general.fWidth//2 " w" wEdit " hp Border BackgroundTrans"
		Gui, %GUI%: Add, Edit, % "xp yp wp hp Border cBlack HWNDhwnd1 gSettings_macros2", % settings.macros["command_" A_Index - 1]
		Gui, %GUI%: Font, % "s" settings.general.fSize
		vars.hwnd.settings["enable_" A_Index - 1] := hwnd0, vars.hwnd.settings["enable_" A_Index - 1 "_bar"] := vars.hwnd.help_tooltips["settings_macros enable" handle] := hwnd01
		If (A_Index != 1)
			vars.hwnd.help_tooltips["settings_macros label" handle] := vars.hwnd.settings["label_" A_Index - 1] := hwnd
		vars.hwnd.help_tooltips["settings_macros command" handle] := vars.hwnd.settings["command_" A_Index - 1] := hwnd1, handle .= "|"
	}
}

Settings_macros2(cHWND)
{
	local
	global vars, settings

	check := LLK_HasVal(vars.hwnd.settings, cHWND), control := SubStr(check, InStr(check, "_") + 1)
	If !InStr(check, "widget_")
		KeyWait, LButton

	Switch
	{
		Case InStr(check, "widget_"):
			While GetKeyState("LButton", "P")
			{
				If (control = "minus")
					settings.macros.sMenu -= (settings.macros.sMenu > 10 ? 1 : 0)
				Else If (control = "reset")
					settings.macros.sMenu := Max(settings.general.fSize, 10)
				Else settings.macros.sMenu += 1
				GuiControl, Text, % vars.hwnd.settings.widget_reset, % settings.macros.sMenu
				Sleep 150
			}
			IniWrite, % settings.macros.sMenu, % "ini" vars.poe_version "\chat macros.ini", settings, menu-widget size
			LLK_FontDimensions(settings.macros.sMenu, height, width), settings.macros.wMenu := width
			For key, hbm in vars.pics.radial.macros
				DeleteObject(hbm)
			vars.pics.radial.macros := {}, Settings_menu("macros")

		Case (check = "animations"):
			IniWrite, % (settings.macros.animations := !settings.macros.animations), % "ini" vars.poe_version, settings, animations
			GuiControl, % "+c" (settings.macros.animations ? "Lime" : "Gray"), % cHWND
			GuiControl, % "movedraw", % cHWND

		Case InStr(check, "fasttravel_"):
			IniWrite, % (settings.macros[control] := !settings.macros[control]), % "ini" vars.poe_version "\chat macros.ini", settings, % "enable " control
			GuiControl, % "+Background" (settings.macros[control] ? "Lime" : "Black"), % vars.hwnd.settings["fasttravel_" control "_bar"]

		Case InStr(check, "hotkey_"):
			input := LLK_ControlGet(cHWND)
			GuiControl, % (input != settings.macros["hotkey_" control] ? "+" : "-") "Hidden", % vars.hwnd.settings["hotkey_" control "_label"]
			GuiControl, % (input != settings.macros["hotkey_" control] ? "+" : "-") "Hidden", % vars.hwnd.settings["hotkey_" control "_label_bar"]
			GuiControl, % (input != settings.macros["hotkey_" control] ? "-" : "+") "Hidden", % vars.hwnd.settings["hotkeysave_" control]
			GuiControl, % (input != settings.macros["hotkey_" control] ? "-" : "+") "Hidden", % vars.hwnd.settings["hotkeysave_" control "_bar"]

		Case InStr(check, "hotkeysave_"):
			input := LLK_ControlGet(vars.hwnd.settings["hotkey_" control])
			If Blank(input) || GetKeyVK(input)
			{
				Hotkey, IfWinActive, ahk_group poe_ahk_window
				If !Blank(settings.macros["hotkey_" control])
					Hotkey, % Hotkeys_Convert(settings.macros["hotkey_" control]), % "Macro_" control, Off
				If !Blank(input)
					Hotkey, % Hotkeys_Convert(input), % "Macro_" control, On
				IniWrite, % """" (settings.macros["hotkey_" control] := input) """", % "ini" vars.poe_version "\chat macros.ini", settings, % control " hotkey"
				Settings_menu("macros")
			}
			Else LLK_ToolTip(Lang_Trans("m_hotkeys_error"), 1.5,,,, "Red")

		Case InStr(check, "enable_"):
			If Blank(LLK_ControlGet(vars.hwnd.settings["label_" control])) && (control != 0) || Blank(LLK_ControlGet(vars.hwnd.settings["command_" control]))
				Return
			IniWrite, % (settings.macros["enable_" control] := !settings.macros["enable_" control]), % "ini" vars.poe_version "\chat macros.ini", macros, % "enable " control
			GuiControl, % "+Background" (settings.macros["enable_" control] ? "Lime" : vars.settings.cButtons2), % vars.hwnd.settings["enable_" control "_bar"]

		Case InStr(check, "command_"):
			input := LLK_ControlGet(cHWND)
			GuiControl, % "+c" (input != settings.macros["command_" control] ? "Red" : "Black"), % cHWND
			GuiControl, % "movedraw", % cHWND

		Case InStr(check, "label_"):
			input := LLK_ControlGet(cHWND)
			GuiControl, % "+c" (input != settings.macros["label_" control] ? "Red" : "Black"), % cHWND
			GuiControl, % "movedraw", % cHWND

		Case (check = "custommacros_save"):
			Loop 9
			{
				label := LLK_ControlGet(vars.hwnd.settings["label_" A_Index - 1]), command := LLK_ControlGet(vars.hwnd.settings["command_" A_Index - 1])
				If !Blank(label) && Blank(command) || Blank(label) && !Blank(command) && (A_Index != 1)
				{
					WinGetPos, xControl, yControl, wControl, hControl, % "ahk_id " vars.hwnd.settings[(Blank(label) ? "label" : "command") "_" A_Index - 1]
					LLK_ToolTip(Lang_Trans("global_errorname"), 2, xControl, yControl + hControl,, "Red")
					Return
				}
				If (label != settings.macros["label_" A_Index - 1])
					IniWrite, % """" (settings.macros["label_" A_Index - 1] := label) . (Blank(label) ? "blank" : "") """", % "ini" vars.poe_version "\chat macros.ini", macros, % "label " A_Index - 1
				If (command != settings.macros["command_" A_Index - 1])
					IniWrite, % """" (settings.macros["command_" A_Index - 1] := command) . (Blank(command) ? "blank" : "") """", % "ini" vars.poe_version "\chat macros.ini", macros, % "command " A_Index - 1
			}
			Settings_menu("macros")
	}

	If InStr(check, "command_") || InStr(check, "label_")
	{
		Loop 9
			If (LLK_ControlGet(vars.hwnd.settings["label_" A_Index - 1]) != settings.macros["label_" A_Index - 1]) || (LLK_ControlGet(vars.hwnd.settings["command_" A_Index - 1]) != settings.macros["command_" A_Index - 1])
			{
				modified := 1
				Break
			}
		GuiControl, % (modified ? "-" : "+") "Hidden", % vars.hwnd.settings.custommacros_save
		GuiControl, % (modified ? "-" : "+") "Hidden", % vars.hwnd.settings.custommacros_save_bar
		GuiControl, % (modified ? "+" : "-") "Hidden", % vars.hwnd.settings.header_custom
	}
}

Settings_mapinfo()
{
	local
	global vars, settings, db
	static fSize, wFont, wMapmods, wDDL

	GUI := "settings_menu" vars.settings.GUI_toggle, x_anchor := vars.settings.x_anchor, margin := vars.settings.xMargin

	If (settings.general.lang_client = "unknown")
	{
		Settings_unsupported()
		Return
	}

	Gui, %GUI%: Add, Text, % "Section x" x_anchor " y" vars.settings.ySelection " Border BackgroundTrans gSettings_mapinfo2 HWNDhwnd" (settings.features.mapinfo ? " cLime" : " cGray"), % " " Lang_Trans("global_enable") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.enable := hwnd, vars.hwnd.help_tooltips["settings_mapinfo enable"] := hwnd1

	Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans HWNDhwnd gURL cAqua", % " wiki page "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.URLs := {}, vars.URLs[hwnd] := "https://github.com/Lailloken/Exile-UI/wiki/Map-info-panel", vars.hwnd.help_tooltips["settings_website"] := hwnd1

	If !settings.features.mapinfo
		Return

	If (fSize != settings.general.fSize)
	{
		fSize := settings.general.fSize
		LLK_PanelDimensions([Lang_Trans("m_mapinfo_maprolls"), Lang_Trans("global_font")], fSize, wFont, hFont)
		LLK_PanelDimensions([Lang_Trans("m_mapinfo_mapmods"), Lang_Trans("m_mapinfo_logbooks")], fSize, wMapmods, hMapmods)
		LLK_PanelDimensions([Lang_Trans("m_general_posleft"), Lang_Trans("m_general_posright"), Lang_Trans("m_general_postop"), Lang_Trans("m_general_posbottom")], fSize, wDDL, hDDL)
	}

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "xs Section Center y+"vars.settings.spacing, % Lang_Trans("global_general")
	Gui, %GUI%: Font, norm

	Gui, %GUI%: Add, Text, % "xs Section Right Border BackgroundTrans", % " " Lang_Trans("global_activation") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border Background404040 cBlack", 100
	Gui, %Gui%: Add, Text, % "ys x+-1 Border BackgroundTrans HWNDhwnd gSettings_mapinfo2" (settings.mapinfo.activation = "toggle" ? " cLime" : ""), % " " Lang_Trans("global_toggle") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.activation_toggle := hwnd, vars.hwnd.help_tooltips["settings_mapinfo toggle"] := hwnd1

	Gui, %Gui%: Add, Text, % "ys x+-1 Border BackgroundTrans HWNDhwnd gSettings_mapinfo2" (settings.mapinfo.activation = "hold" ? " cLime" : ""), % " " Lang_Trans("global_hold") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.activation_hold := hwnd, vars.hwnd.help_tooltips["settings_mapinfo hold"] := hwnd1

	Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans gSettings_mapinfo2 HWNDhwnd" (settings.mapinfo.trigger ? " cLime" : " cGray"), % " " Lang_Trans("global_shiftclick") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.shiftclick := hwnd, vars.hwnd.help_tooltips["settings_mapinfo shift-click"] := hwnd1

	Gui, %GUI%: Add, Text, % "Section xs Border BackgroundTrans Right", % " " Lang_Trans("global_position") . Lang_Trans("global_colon") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border Background404040 cBlack", 100
	DDL := [Lang_Trans("m_general_postop"), Lang_Trans("m_general_posbottom"), Lang_Trans("m_general_posleft"), Lang_Trans("m_general_posright")], current := DDL[settings.mapinfo.position]
	Gui, %GUI%: Add, Text, % "ys x+-1 w" wDDL " Center Border BackgroundTrans gSettings_mapinfo2 HWNDhwnd cLime", % current
	vars.ddl.mapinfo_position := {"current": current, "cHWND": hwnd, "list": DDL.Clone(), "color": vars.settings.cButtons, "fSize": fSize}
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.position := hwnd, vars.hwnd.help_tooltips["settings_mapinfo position"] := hwnd1

	Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans gSettings_mapinfo2 HWNDhwnd" (settings.mapinfo.tabtoggle ? " cLime" : " cGray"), % " " Lang_Trans("m_mapinfo_sidepanel") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.tabtoggle := hwnd, vars.hwnd.help_tooltips["settings_mapinfo tab"] := hwnd1

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "xs Section y+"vars.settings.spacing, % Lang_Trans("global_ui")
	Gui, %GUI%: Font, norm

	Gui, %GUI%: Add, Text, % "Section xs" (vars.poe_version ? "" : " w" wFont) " Right Border BackgroundTrans", % (vars.poe_version ? " " : "") Lang_Trans("global_font") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border Background404040 cBlack", 100
	Gui, %GUI%: Add, Text, % "ys x+-1 Center Border BackgroundTrans gSettings_mapinfo2 HWNDhwnd w"settings.general.fWidth*2, % "–"
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.font_minus := hwnd, vars.hwnd.help_tooltips["settings_font-size|"] := hwnd1

	Gui, %GUI%: Add, Text, % "ys x+-1 Center Border BackgroundTrans gSettings_mapinfo2 HWNDhwnd w"settings.general.fWidth*3, % settings.mapinfo.fSize
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.font_reset := hwnd, vars.hwnd.help_tooltips["settings_font-size||"] := hwnd1

	Gui, %GUI%: Add, Text, % "ys x+-1 Center Border BackgroundTrans gSettings_mapinfo2 HWNDhwnd w"settings.general.fWidth*2, % "+"
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.font_plus := hwnd, vars.hwnd.help_tooltips["settings_font-size|||"] := hwnd1

	Gui, %GUI%: Add, Text, % "ys w" wMapmods " Right Border BackgroundTrans", % Lang_Trans("m_mapinfo_mapmods") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd Background404040 cBlack", 100
	vars.hwnd.help_tooltips["settings_mapinfo mapmod colors"] := hwnd, handle := ""

	Loop 4
	{
		Gui, %GUI%: Add, Text, % "ys x+-1 Center Border BackgroundTrans gSettings_mapinfo2 HWNDhwnd c"settings.mapinfo.color[A_Index], % " " A_Index " "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings["color_"A_Index] := hwnd, vars.hwnd.help_tooltips["settings_mapinfo colors"handle] := hwnd1, handle .= "|"
	}
	ControlGetPos, xGui,, wGui,,, ahk_id %hwnd%

	Gui, %GUI%: Add, Text, % "Section xs" (vars.poe_version ? "" : " w" wFont) " Center Border BackgroundTrans gSettings_mapinfo2 HWNDhwnd" (settings.mapinfo.roll_highlight ? " cLime" : " cGray"), % " " Lang_Trans("m_mapinfo_maprolls") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.roll_highlight := hwnd, vars.hwnd.help_tooltips["settings_mapinfo roll highlight"] := hwnd1, handle := ""

	If settings.mapinfo.roll_highlight
	{
		Gui, %GUI%: Add, Text, % "ys x+-1 w" settings.general.fWidth * 5 " Center BackgroundTrans HWNDhwnd1 Border c" settings.mapinfo.roll_colors.1, % " 117" Lang_Trans("maps_stats", 2) " "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp HWNDhwnd11 Border Background404040 c" settings.mapinfo.roll_colors.2, 100
		Gui, %GUI%: Add, Text, % "ys x+-1 w" settings.general.fWidth " hp BackgroundTrans gSettings_mapinfo2 HWNDhwnd2 Border"
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp HWNDhwnd21 Border BackgroundBlack c" settings.mapinfo.roll_colors.1, 100
		Gui, %GUI%: Add, Text, % "ys x+-1 w" settings.general.fWidth " hp BackgroundTrans gSettings_mapinfo2 HWNDhwnd3 Border"
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp HWNDhwnd31 Border BackgroundBlack c" settings.mapinfo.roll_colors.2, 100
		Loop 3
			vars.hwnd.help_tooltips["settings_mapinfo roll colors" handle] := hwnd%A_Index%1, handle .= "|"
		vars.hwnd.settings.rollcolor_text := hwnd1, vars.hwnd.settings.rollcolor_back := hwnd11
		vars.hwnd.settings.rollcolor_1 := hwnd2, vars.hwnd.settings.rollcolor_11 := hwnd21
		vars.hwnd.settings.rollcolor_2 := hwnd3, vars.hwnd.settings.rollcolor_21 := hwnd31, handle := ""
	}

	If !vars.poe_version
	{
		Gui, %GUI%: Add, Text, % "ys x" x_anchor + wFont + settings.general.fWidth * 7 - 3 + margin " w" wMapmods " Right Border BackgroundTrans", % Lang_Trans("m_mapinfo_logbooks") " "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd Background404040 cBlack", 100
		vars.hwnd.help_tooltips["settings_mapinfo mapmod colors|"] := hwnd
		Loop 4
		{
			Gui, %GUI%: Add, Text, % "ys x+-1 Center Border BackgroundTrans gSettings_mapinfo2 HWNDhwnd c"settings.mapinfo.eColor[A_Index], % " " A_Index " "
			Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
			vars.hwnd.settings["colorlogbook_"A_Index] := hwnd, vars.hwnd.help_tooltips["settings_mapinfo colors||||" handle1] := hwnd1, handle1 .= "|"
		}
	}

	If settings.mapinfo.roll_highlight
	{
		For index, val in settings.mapinfo.roll_types
		{
			Gui, %GUI%: Add, Text, % (A_Index = 1 ? "xs Section" : "ys x+" settings.general.fWidth//2) " Center Border BackgroundTrans w" settings.general.fWidth * 2, % Lang_Trans("maps_stats" . StrReplace(vars.poe_version, " "), A_Index + 1)
			Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd Background404040 cBlack", 100
			Gui, %GUI%: Font, % "s" settings.general.fSize - 4
			Gui, %GUI%: Add, Text, % "ys x+-1 w" settings.general.fWidth * 3 " hp Border BackgroundTrans"
			Gui, %GUI%: Add, Edit, % "xp yp wp hp Border Right cBlack Number HWNDhwnd1 Limit3 gSettings_mapinfo2", % settings.mapinfo.roll_requirements[val]
			Gui, %GUI%: Font, % "s" settings.general.fSize
			vars.hwnd.help_tooltips["settings_mapinfo requirements" handle] := hwnd
			vars.hwnd.help_tooltips["settings_mapinfo requirements|" handle] := vars.hwnd.settings["thresh_" val] := hwnd1, handle .= "||"
		}
	}

	Gui, %GUI%: Font, % "bold underline"
	Gui, %GUI%: Add, Text, % "xs Section x" x_anchor " y+" vars.settings.spacing " h" settings.general.fHeight, % Lang_Trans("m_mapinfo_modsettings")
	Gui, %GUI%: Font, % "norm"
	Gui, %GUI%: Add, Pic, % "ys hp w-1 HWNDhwnd", % "HBitmap:*" vars.pics.global.help
	vars.hwnd.help_tooltips["settings_mapinfo mod settings"] := hwnd

	Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans gSettings_mapinfo2 HWNDhwnd", % " " Lang_Trans("m_mapinfo_reset") " "
	Gui, %GUI%: Add, Progress, % "Disabled Range0-500 Vertical xp yp wp hp HWNDhwnd2 Border Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 500
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
		Gui, %GUI%: Add, Text, % style " Border BackgroundTrans Center c" color, % " " text " "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd Background404040 cBlack", 100
		Gui, %GUI%: Font, norm
		ControlGetPos, xLast,, wLast,,, ahk_id %hwnd%
		Gui, %GUI%: Font, Bold
		Gui, %GUI%: Add, Text, % "ys x+-1 Border BackgroundTrans 0x200 Center HWNDhwnd1 gSettings_mapinfo2 cRed w" settings.general.fWidth * 2, % "–"
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		Gui, %GUI%: Font, Norm
		vars.hwnd.settings["mapmod_" ID] := hwnd, vars.hwnd.settings["unpin_" ID] := hwnd1
	}
	Gui, %GUI%: Add, Text, % "xs Section HWNDhwnd", % Lang_Trans("m_mapinfo_modsearch")
	Gui, %GUI%: Add, Button, % "xp yp wp hp Hidden Default HWNDhwnd1 gSettings_mapinfo2", OK
	ControlGetPos, x1, y1, w1, h1,, ahk_id %hwnd%
	Gui, %GUI%: Font, % "norm s" settings.general.fSize - 4
	Gui, %GUI%: Add, Edit, % "ys Border cBlack HWNDhwnd2 gSettings_mapinfo2 w" (settings.general.fWidth * 30) - w1 - settings.general.fWidth, % vars.settings.mapinfo_search
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
				Gui, %GUI%: Add, Text, % style " Border BackgroundTrans Center c" color, % " " text " "
				Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd Background404040 cBlack", 100
				Gui, %GUI%: Font, norm
				ControlGetPos, xLast,, wLast,,, ahk_id %hwnd%
				Gui, %GUI%: Font, Bold
				Gui, %GUI%: Add, Text, % "ys x+-1 Border BackgroundTrans 0x200 Center HWNDhwnd1 gSettings_mapinfo2 cLime w" settings.general.fWidth * 2, % "+"
				Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
				Gui, %GUI%: Font, Norm
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
	If !RegExMatch(check, "i)font_|reset_tiers")
		KeyWait, LButton

	Switch check
	{
		Case "enable":
			IniWrite, % (settings.features.mapinfo := !settings.features.mapinfo), % "ini" vars.poe_version "\config.ini", features, enable map-info panel
			Settings_menu("map-info")
			LLK_Overlay(vars.hwnd.mapinfo.main, "destroy")
		Case "activation_toggle":
			IniWrite, % (settings.mapinfo.activation := "toggle"), % "ini" vars.poe_version "\map info.ini", settings, activation
			GuiControl, % "+cLime", % cHWND
			GuiControl, % "movedraw", % cHWND
			GuiControl, % "+cWhite", % vars.hwnd.settings.activation_hold
			GuiControl, % "movedraw", % vars.hwnd.settings.activation_hold
		Case "activation_hold":
			IniWrite, % (settings.mapinfo.activation := "hold"), % "ini" vars.poe_version "\map info.ini", settings, activation
			GuiControl, % "+cLime", % cHWND
			GuiControl, % "movedraw", % cHWND
			GuiControl, % "+cWhite", % vars.hwnd.settings.activation_toggle
			GuiControl, % "movedraw", % vars.hwnd.settings.activation_toggle
		Case "shiftclick":
			settings.mapinfo.trigger := !settings.mapinfo.trigger, Settings_ScreenChecksValid()
			IniWrite, % settings.mapinfo.trigger, % "ini" vars.poe_version "\map info.ini", settings, enable shift-clicking
			GuiControl, % "+c" (settings.mapinfo.trigger ? "Lime" : "Gray"), % cHWND
			GuiControl, % "movedraw", % cHWND
		Case "position":
			input := Gui_DropDownList(vars.ddl.mapinfo_position, LLK_WinGetPos(cHWND, "array"), "Center", 1)
			If Blank(input) || IsObject(input) && Blank(input.1 . input.2)
				Return
			IniWrite, % (settings.mapinfo.position := input.2), % "ini" vars.poe_version "\map info.ini", settings, position
			vars.ddl.mapinfo_position.current := input.1
		Case "tabtoggle":
			IniWrite, % (settings.mapinfo.tabtoggle := !settings.mapinfo.tabtoggle), % "ini" vars.poe_version "\map info.ini", settings, show panel while holding tab
			GuiControl, % "+c" (settings.mapinfo.tabtoggle ? "Lime" : "Gray"), % cHWND
			GuiControl, % "movedraw", % cHWND
		Case "modsearch":
			GuiControl, +cBlack, % cHWND
		Case "modsearch_ok":
			vars.settings.mapinfo_search := LLK_ControlGet(cHWND := vars.hwnd.settings.modsearch), Settings_menu("map-info",, 0)
			Return
		Case "reset_tiers":
			If (vars.system.click = 1) && LLK_Progress(vars.hwnd.settings.reset_tiers_bar, "LButton",,, 500, "Red", vars.settings.cButtons)
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
			Else If (check = "roll_highlight")
			{
				IniWrite, % (settings.mapinfo.roll_highlight := !settings.mapinfo.roll_highlight), % "ini" vars.poe_version "\map info.ini", settings, highlight map rolls
				Settings_menu("map-info")
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
				color := (vars.system.click = 1) ? RGB_Picker(settings.mapinfo.roll_colors[control]) : (control = 1 ? "000000" : "FFFF00")
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
				Settings_menu()
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
	static fSize, wMaps, wOn

	GUI := "settings_menu" vars.settings.GUI_toggle, x_anchor := vars.settings.x_anchor

	If (settings.general.lang_client = "unknown")
	{
		Settings_unsupported()
		Return
	}

	Gui, %GUI%: Add, Text, % "Section x" x_anchor " y" vars.settings.ySelection " Border BackgroundTrans gSettings_maptracker2 HWNDhwnd" (settings.features.maptracker ? " cLime" : " cGray"), % " " Lang_Trans("global_enable") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.enable := hwnd, vars.hwnd.help_tooltips["settings_maptracker enable"] := hwnd1

	Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans HWNDhwnd gURL cAqua", % " wiki page "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.URLs := {}, vars.URLs[hwnd] := "https://github.com/Lailloken/Exile-UI/wiki/Map‐Tracker", vars.hwnd.help_tooltips["settings_website"] := hwnd1

	If !settings.features.maptracker
		Return

	Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans HWNDhwnd gURL cAqua", % " ahk: key list "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.URLs[hwnd] := "https://www.autohotkey.com/docs/v1/KeyList.htm", vars.hwnd.help_tooltips["settings_website|"] := hwnd1

	If (fSize != settings.general.fSize)
	{
		fSize := settings.general.fSize
		LLK_PanelDimensions([Lang_Trans("global_maps") . Lang_Trans("global_colon") " ", Lang_Trans("global_meta") " "], fSize, wMaps, hMaps,,, 0)
		LLK_PanelDimensions([Lang_Trans("global_on"), Lang_Trans("global_off")], fSize, wOn, hOn)
	}

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "xs Section y+"vars.settings.spacing, % Lang_Trans("global_general")
	Gui, %GUI%: Font, norm

	Gui, %GUI%: Add, Text, % "Section xs Border BackgroundTrans", % " " Lang_Trans("global_panelsize") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border Background404040 cBlack", 100
	Gui, %GUI%: Add, Text, % "ys x+-1 w"settings.general.fWidth*2 " Center gSettings_maptracker2 Border BackgroundTrans HWNDhwnd", % "–"
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.font_minus := hwnd, vars.hwnd.help_tooltips["settings_font-size|"] := hwnd1

	Gui, %GUI%: Add, Text, % "ys x+-1 w" settings.general.fWidth * 3 " Center gSettings_maptracker2 Border BackgroundTrans HWNDhwnd", % settings.maptracker.fSize
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.font_reset := hwnd, vars.hwnd.help_tooltips["settings_font-size||"] := hwnd1

	Gui, %GUI%: Add, Text, % "ys x+-1 w" settings.general.fWidth * 2 " Center gSettings_maptracker2 Border BackgroundTrans HWNDhwnd", % "+"
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.font_plus := hwnd, vars.hwnd.help_tooltips["settings_font-size|||"] := hwnd1

	Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans gSettings_maptracker2 HWNDhwnd" (settings.maptracker.hide ? " cLime" : " cGray"), % " " Lang_Trans("m_maptracker_pausehide") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.hide := hwnd, vars.hwnd.help_tooltips["settings_maptracker hide"] := hwnd1

	Gui, %GUI%: Add, Text, % "Section xs Border BackgroundTrans gSettings_maptracker2 HWNDhwnd" (settings.maptracker.rename ? " cLime" : " cGray"), % " " Lang_Trans("m_maptracker_bosstags") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.rename := hwnd, vars.hwnd.help_tooltips["settings_maptracker rename"] := hwnd1

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "xs Section y+"vars.settings.spacing, % Lang_Trans("m_maptracker_tracking")
	Gui, %GUI%: Font, norm

	Gui, %GUI%: Add, Text, % "Section xs w" wMaps - 2 " h" settings.general.fHeight " Right 0x200", % Lang_Trans("global_meta") " "
	Gui, %GUI%: Add, Text, % "ys x+0 Border BackgroundTrans gSettings_maptracker2 HWNDhwnd" (settings.maptracker.notes ? " cLime" : " cGray"), % " " Lang_Trans("m_maptracker_notes") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.notes := hwnd, vars.hwnd.help_tooltips["settings_maptracker notes"] := hwnd1

	Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans gSettings_maptracker2 HWNDhwnd" (settings.maptracker.character ? " cLime" : " cGray"), % " " Lang_Trans("m_maptracker_character") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.character := hwnd, vars.hwnd.help_tooltips["settings_maptracker character"] := hwnd1

	Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans gSettings_maptracker2 HWNDhwnd" (settings.maptracker.league ? " cLime" : " cGray"), % " " Lang_Trans("m_maptracker_league") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.league := hwnd, vars.hwnd.help_tooltips["settings_maptracker league"] := hwnd1

	Gui, %GUI%: Add, Text, % "Section xs w" wMaps - 2 " h" settings.general.fHeight " Right 0x200", % Lang_Trans("global_maps") . Lang_Trans("global_colon") " "
	Gui, %GUI%: Add, Text, % "Section ys x+0 Border BackgroundTrans gSettings_maptracker2 HWNDhwnd" (settings.maptracker.kills ? " cLime" : " cGray"), % " " Lang_Trans("m_maptracker_kills") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.kills := hwnd, vars.hwnd.help_tooltips["settings_maptracker kill-tracker"] := hwnd1

	If settings.maptracker.kills
	{
		Gui, %GUI%: Add, Text, % "ys x+-1 Border BackgroundTrans gSettings_maptracker2 HWNDhwnd" (settings.maptracker.kills_omnikey ? " cLime" : " cGray"), % " " Lang_Trans("global_omnikey", 2) " "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings.kills_omnikey := hwnd, vars.hwnd.help_tooltips["settings_maptracker kill-tracker omni-key"] := hwnd1
	}

	Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans gSettings_maptracker2 HWNDhwnd" (!settings.features.mapinfo ? " cFF8000" : (settings.maptracker.mapinfo ? " cLime" : " cGray")), % " " Lang_Trans("ms_map-info") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.mapinfo := hwnd, vars.hwnd.help_tooltips["settings_maptracker mapinfo"] := hwnd1

	Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans gSettings_maptracker2 HWNDhwnd" (settings.maptracker.sidecontent ? " cLime" : " cGray"), % " " Lang_Trans("m_maptracker_sidearea") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.sidecontent := hwnd, vars.hwnd.help_tooltips["settings_maptracker side-content"] := hwnd1

	Gui, %GUI%: Add, Text, % "Section xs Center Border BackgroundTrans gSettings_maptracker2 HWNDhwnd" (settings.maptracker.mechanics ? " cLime" : " cGray"), % " " Lang_Trans("maptracker_content") " "
	hwnd_label := hwnd
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.mechanics := hwnd, vars.hwnd.help_tooltips["settings_maptracker mechanics"] := hwnd1

	If !vars.poe_version
	{
		Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans gSettings_maptracker2 HWNDhwnd" (settings.maptracker.loot ? " cLime" : " cGray"), % " " Lang_Trans("m_maptracker_loot") " "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings.loot := hwnd, vars.hwnd.help_tooltips["settings_maptracker loot-tracker"] := hwnd1
	}

	If settings.maptracker.mechanics
	{
		added := 0
		Gui, %GUI%: Add, Text, % "Section x" x_anchor " y+-2 w" wMaps - 2 " h2 Border"
		Gui, %GUI%: Add, Text, % "xs y+0 w2 h" vars.settings.line1 + 1 " Border HWNDhwnd_brace"

		If (general_mechanics := LLK_HasVal(vars.maptracker.mechanics, 0)) ; note: section currently empty -- keep it in case content such as nameless seer and reflecting mist returns
			For mechanic, type in vars.maptracker.mechanics
			{
				If type
					Continue
				added += 1, color := (settings.maptracker[mechanic] ? " cLime" : " cGray")
				Gui, %GUI%: Add, Text, % (added = 1 ? "Section xs x+" vars.settings.xMargin " y+-1" : "ys") " Border BackgroundTrans gSettings_maptracker2 HWNDhwnd" color, % " " Lang_Trans("mechanic_" mechanic) " "
				Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
				vars.hwnd.settings["mechanic_"mechanic] := hwnd, vars.hwnd.help_tooltips["settings_maptracker dialoguemechanic"handle] := hwnd1, handle .= "|"
			}

		If general_mechanics && !vars.poe_version
			Gui, %GUI%: Add, Text, % "xs x" x_anchor " w" settings.general.fWidth * 20 " h2 Border"
		Gui, %GUI%: Add, Text, % "Section" (!added ? " xs x+" vars.settings.xMargin " y+-1" : " xs"), % Lang_Trans("m_maptracker_dialogue")
		vars.hwnd.help_tooltips["settings_maptracker dialogue tracking"] := hwnd, added := 0, ingame_dialogs := vars.maptracker.dialog := InStr(LLK_FileRead(vars.system.config), "output_all_dialogue_to_chat=true") ? 1 : 0
		For mechanic, type in vars.maptracker.mechanics
		{
			If (type != 1)
				Continue
			added += 1, color := (!ingame_dialogs ? " cRed" : settings.maptracker[mechanic] ? " cLime" : " cGray")
			Gui, %GUI%: Add, Text, % (RegexMatch(added, "^(1|5|9)$") ? "Section xs" : "ys") " Border BackgroundTrans gSettings_maptracker2 HWNDhwnd" color, % " " Lang_Trans("mechanic_" mechanic) " "
			Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
			vars.hwnd.settings["mechanic_"mechanic] := hwnd, vars.hwnd.help_tooltips["settings_maptracker dialoguemechanic"handle] := hwnd1, handle .= "|"
		}

		Gui, %GUI%: Add, Text, % "xs x" x_anchor " w" settings.general.fWidth * 20 " h2 Border"
		Gui, %GUI%: Add, Text, % "Section xs", % Lang_Trans("m_maptracker_screen")
		vars.hwnd.help_tooltips["settings_maptracker screen tracking"] := hwnd, handle := "", added := 0
		For mechanic, type in vars.maptracker.mechanics
		{
			If (type != 2)
				Continue
			added += 1, color := !FileExist("img\Recognition ("vars.client.h "p)\Mapping Tracker\"mechanic . vars.poe_version ".bmp") ? "red" : settings.maptracker[mechanic] ? " cLime" : " cGray"
			Gui, %GUI%: Add, Text, % (RegexMatch(added, "^(1|5|9)$") ? "Section xs" : "ys") " Border BackgroundTrans gSettings_maptracker2 HWNDhwnd c" color, % " " Lang_Trans("mechanic_" mechanic) " "
			Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
			vars.hwnd.settings["screenmechanic_"mechanic] := hwnd, vars.hwnd.help_tooltips["settings_maptracker screenmechanic"handle] := hwnd1, handle .= "|"
		}

		Gui, %GUI%: Add, Text, % "xs x" x_anchor " w" settings.general.fWidth * 20 " h2 Border HWNDhwnd"
		Gui, %GUI%: Add, Text, % "Section xs Border BackgroundTrans", % " " Lang_Trans("m_maptracker_portalreminder") " "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border Background404040 cBlack", 100
		Gui, %GUI%: Add, Text, % "ys x+-1 w" wOn " Center Border BackgroundTrans gSettings_maptracker2 HWNDhwnd" (settings.maptracker.portal_reminder ? " cLime" : " cGray"), % Lang_Trans("global_" (settings.maptracker.portal_reminder ? "on" : "off"))
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings.portal_reminder := hwnd, vars.hwnd.help_tooltips["settings_maptracker portal reminder"] := hwnd1, handle := ""

		If settings.maptracker.portal_reminder
		{
			Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans", % " " Lang_Trans("global_hotkey") " "
			Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border Background404040 cBlack", 100
			Gui, %GUI%: Font, % "s" settings.general.fSize - 4
			Gui, %GUI%: Add, Text, % "ys x+1 yp+1 w" settings.general.fWidth * 6 - 2 " hp-2 Border BackgroundTrans"
			Gui, %GUI%: Add, Edit, % "xp yp wp hp Border cBlack gSettings_maptracker2 HWNDhwnd", % settings.maptracker.portal_hotkey
			Gui, %GUI%: Add, Progress, % "Disabled xp-1 yp-1 wp+2 hp+2 HWNDhwnd1 Background" (Blank(settings.maptracker.portal_hotkey) ? "Red" : "Lime"), 0
			Gui, %GUI%: Font, % "s" settings.general.fSize
			vars.hwnd.settings.portal_hotkey := vars.hwnd.help_tooltips["settings_maptracker portal hotkey"] := hwnd, vars.hwnd.settings.portal_hotkey_bar := hwnd1
		}
		Gui, %GUI%: Add, Text, % "xs x" x_anchor " w" settings.general.fWidth * 20 " h2 Border HWNDhwnd"
		ControlGetPos, xLast, yLast, wLast, hLast,, ahk_id %hwnd%
		GuiControl, movedraw, % hwnd_brace, % "h" yLast + hLast - LLK_ControlGetPos(hwnd_brace, "y")
	}
}

Settings_maptracker2(cHWND)
{
	local
	global vars, settings

	check := LLK_HasVal(vars.hwnd.settings, cHWND), control := SubStr(check, InStr(check, "_") + 1)
	If !InStr(check, "font_")
		KeyWait, LButton

	Switch check
	{
		Case "enable":
			IniWrite, % (settings.features.maptracker := !settings.features.maptracker), % "ini" vars.poe_version "\config.ini", features, enable map tracker
			If !settings.features.maptracker
				vars.maptracker.Delete("map"), LLK_Overlay(vars.hwnd.maptracker.main, "destroy")
			Settings_menu("mapping tracker")

			If WinExist("ahk_id " vars.hwnd.radial.main)
				LLK_Overlay(vars.hwnd.radial.main, "destroy"), vars.hwnd.radial.main := ""
		Case "hide":
			IniWrite, % (settings.maptracker.hide := ! settings.maptracker.hide), % "ini" vars.poe_version "\map tracker.ini", settings, hide panel when paused
			If LLK_Overlay(vars.hwnd.maptracker.main, "check")
				Maptracker_GUI()
			GuiControl, % "+c" (settings.maptracker.hide ? "Lime" : "Gray"), % cHWND
			GuiControl, % "movedraw", % cHWND
		Case "loot":
			settings.maptracker.loot := !settings.maptracker.loot, Settings_ScreenChecksValid()
			IniWrite, % settings.maptracker.loot, % "ini" vars.poe_version "\map tracker.ini", settings, enable loot tracker
			GuiControl, % "+c" (settings.maptracker.loot ? "Lime" : "Gray"), % cHWND
			GuiControl, % "movedraw", % cHWND
		Case "kills":
			vars.maptracker.refresh_kills := ""
			IniWrite, % (settings.maptracker.kills := !settings.maptracker.kills), % "ini" vars.poe_version "\map tracker.ini", settings, enable kill tracker
			GuiControl, % "+c" (settings.maptracker.kills ? "Lime" : "Gray"), % cHWND
			GuiControl, % "movedraw", % cHWND
			Settings_menu()
		Case "kills_omnikey":
			IniWrite, % (settings.maptracker.kills_omnikey := !settings.maptracker.kills_omnikey), % "ini" vars.poe_version "\map tracker.ini", settings, omni-key refreshes kills
			GuiControl, % "+c" (settings.maptracker.kills_omnikey ? "Lime" : "Gray"), % cHWND
			GuiControl, % "movedraw", % cHWND
		Case "mapinfo":
			If !settings.features.mapinfo
				Return
			IniWrite, % (settings.maptracker.mapinfo := !settings.maptracker.mapinfo), % "ini" vars.poe_version "\map tracker.ini", settings, log mods from map-info panel
			GuiControl, % "+c" (settings.maptracker.mapinfo ? "Lime" : "Gray"), % cHWND
			GuiControl, % "movedraw", % cHWND
		Case "notes":
			IniWrite, % (settings.maptracker.notes := !settings.maptracker.notes), % "ini" vars.poe_version "\map tracker.ini", settings, enable notes
			GuiControl, % "+c" (settings.maptracker.notes ? "Lime" : "Gray"), % cHWND
			GuiControl, % "movedraw", % cHWND
			Maptracker_GUI()
		Case "sidecontent":
			IniWrite, % (settings.maptracker.sidecontent := !settings.maptracker.sidecontent), % "ini" vars.poe_version "\map tracker.ini", settings, track side-areas
			GuiControl, % "+c" (settings.maptracker.sidecontent ? "Lime" : "Gray"), % cHWND
			GuiControl, % "movedraw", % cHWND
		Case "rename":
			IniWrite, % (settings.maptracker.rename := !settings.maptracker.rename), % "ini" vars.poe_version "\map tracker.ini", settings, rename boss maps
			GuiControl, % "+c" (settings.maptracker.rename ? "Lime" : "Gray"), % cHWND
			GuiControl, % "movedraw", % cHWND
		Case "character":
			IniWrite, % (settings.maptracker.character := !settings.maptracker.character), % "ini" vars.poe_version "\map tracker.ini", settings, log character info
			GuiControl, % "+c" (settings.maptracker.character ? "Lime" : "Gray"), % cHWND
			GuiControl, % "movedraw", % cHWND
			Maptracker_GUI()
		Case "league":
			IniWrite, % (settings.maptracker.league := !settings.maptracker.league), % "ini" vars.poe_version "\map tracker.ini", settings, log league info
			GuiControl, % "+c" (settings.maptracker.league ? "Lime" : "Gray"), % cHWND
			GuiControl, % "movedraw", % cHWND
			Maptracker_GUI()
		Case "mechanics":
			IniWrite, % (settings.maptracker.mechanics := !settings.maptracker.mechanics), % "ini" vars.poe_version "\map tracker.ini", settings, track league mechanics
			Settings_menu("mapping tracker")
		Case "portal_reminder":
			IniWrite, % (settings.maptracker.portal_reminder := !settings.maptracker.portal_reminder), % "ini" vars.poe_version "\map tracker.ini", settings, portal-scroll reminder
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
				GuiControl, movedraw, % cHWND
				GuiControl, +BackgroundLime, % vars.hwnd.settings.portal_hotkey_bar
				Init_maptracker()
			}
			Else
			{
				GuiControl, +cRed, % cHWND
				GuiControl, movedraw, % cHWND
				GuiControl, +BackgroundRed, % vars.hwnd.settings.portal_hotkey_bar
			}
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

					If vars.pics.maptracker_checks[control]
						DeleteObject(vars.pics.maptracker_checks[control])
					vars.pics.maptracker_checks[control] := Gdip_CreateHBITMAPFromBitmap(pClipboard, 0)
					Gdip_SaveBitmapToFile(pClipboard, "img\Recognition ("vars.client.h "p)\Mapping Tracker\"control . vars.poe_version ".bmp", 100), Gdip_DisposeImage(pClipboard)
					GuiControl, % "+c"(settings.maptracker[control] ? "Lime" : "505050"), % vars.hwnd.settings["screenmechanic_"control]
					GuiControl, movedraw, % vars.hwnd.settings["screenmechanic_"control]
					Return
				}
				If InStr(check, "screen") && !FileExist("img\Recognition ("vars.client.h "p)\Mapping Tracker\"control . vars.poe_version ".bmp")
					Return
				If !RegexMatch(check, "i)screen|seer|mist") && !vars.maptracker.dialog
				{
					LLK_ToolTip(Lang_Trans("maptracker_dialogue"), 3,,,, "red")
					Return
				}
				settings.maptracker[control] := !settings.maptracker[control]
				IniWrite, % settings.maptracker[control], % "ini" vars.poe_version "\map tracker.ini", mechanics, % control
				GuiControl, % "+c"(settings.maptracker[control] ? "Lime" : "Gray"), % cHWND
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
				IniWrite, % """" settings.maptracker.colors[control] """", % "ini" vars.poe_version "\map tracker.ini", UI, % control " color"
				GuiControl, % "+c" settings.maptracker.colors[control], % vars.hwnd.settings[check "_bar"]
				If InStr(check, "selected")
					If WinExist("ahk_id " vars.hwnd.maptracker_logs.main)
						Maptracker_Logs()
					Else LLK_Overlay(vars.hwnd.maptracker_logs.main, "destroy")
			}
			Else LLK_ToolTip("no action")

			If WinExist("ahk_id " vars.hwnd.maptracker_logs.main)
				LLK_Overlay(vars.hwnd.settings.main, "show", 0)
	}
}

Settings_menu(section := "", mode := 0, NA := 1) ;mode parameter is used when manually calling this function to refresh the window
{
	local
	global vars, settings
	static toggle := 0, fSize, section_width, dIcon, fHeight, wHeader, cBorder, cBorder_check

	If vars.settings.wait
		Return
	Else If !settings.general.dev && (WinExist("ahk_id " vars.hwnd.cheatsheet_menu.main) || WinExist("ahk_id " vars.hwnd.searchstrings_menu.main) || WinExist("ahk_id "vars.hwnd.leveltracker_screencap.main)
	|| WinExist("ahk_id " vars.hwnd.leveltracker_editor.main) || WinExist("ahk_id " vars.hwnd.leveltracker_gempickups.main))
	{
		LLK_ToolTip(Lang_Trans("global_configwindow"), 2,,,, "yellow")
		Return
	}

	If !section || (NA = "tray")
		section := (vars.settings.active_last ? vars.settings.active_last : "general")

	If (NA = "tray")
		If !WinExist("ahk_group poe_window")
			Return
		Else
		{
			WinActivate, % "ahk_group poe_window"
			WinWaitActive, % "ahk_group poe_window",, 3
			If ErrorLevel
				Return
		}

	If !IsObject(vars.settings)
	{
		If !vars.poe_version
			vars.settings := {"sections": ["general", "client", "hotkeys", "screen-checks", "notifications", "updater", "addons", "donations", "actdecoder", "leveling tracker", "betrayal-info", "macros", "cheat-sheets", "clone-frames", "anoints", "filterspoon", "item-info", "map-info", "mapping tracker", "minor qol tools", "sanctum", "search-strings", "stash-ninja", "tldr-tooltips", "exchange"], "sections2": []}
		Else vars.settings := {"sections": ["general", "client", "hotkeys", "screen-checks", "notifications", "updater", "addons", "donations", "actdecoder", "leveling tracker", "macros", "cheat-sheets", "clone-frames", "anoints", "filterspoon", "item-info", "map-info", "mapping tracker", "minor qol tools", "runeshaping", "search-strings", "sanctum", "stash-ninja", "statlas", "exchange"], "sections2": []}
		For index, val in vars.settings.sections
			vars.settings.sections2.Push(Lang_Trans("ms_" val, (vars.poe_version && val = "sanctum") ? 2 : 1))
		If Blank(settings.general.theme) ;Gui_MsgBox during startup may be called before general/global settings have been loaded, so use placeholder defaults for now
			settings.general.cButtons := "404040", settings.general.cButtons2 := "646464"
		vars.settings.cButtons := "171750", vars.settings.cButtons2 := "252580", vars.settings.cButtons3 := "3030CC", vars.settings.min_width := 30, vars.settings.cEnabled := "Lime", vars.settings.cDisabled := "Gray"
	}

	If (section = "init")
		Return

	If InStr(section, "addons_")
		sub_section := SubStr(section, InStr(section, "_") + 1), section := "addons"

	If !Blank(LLK_HasVal(vars.hwnd.settings, section))
	{
		section := LLK_HasVal(vars.hwnd.settings, section)
		KeyWait, LButton
	}

	If (mode != 1) && (vars.settings.active = "hotkeys") && (section != "hotkeys")
		Init_hotkeys()

	xMargin := vars.settings.xMargin := Round(settings.general.fWidth*0.75), vars.settings.line1 := Ceil(settings.general.fHeight/8)
	vars.settings.spacing := Ceil(settings.general.fHeight/3), vars.settings.wait := 1, vars.settings.last_refresh := A_TickCount, slop := settings.general.slop, radius := settings.general.radius

	If !IsNumber(mode)
		mode := 0
	vars.settings.active := vars.settings.active_last := section ;which section of the settings menu is currently active (for purposes of reloading the correct section after restarting)

	If WinExist("ahk_id "vars.hwnd.settings.main)
	{
		WinGetPos, xPos, yPos,,, % "ahk_id " vars.hwnd.settings.main
		vars.settings.x := xPos, vars.settings.y := yPos
	}

	vars.settings.GUI_toggle := toggle := !toggle, GUI_name := "settings_menu" toggle
	Gui, %GUI_name%: New, % "-DPIScale -Caption +LastFound +AlwaysOnTop +ToolWindow +E0x02000000 +E0x00080000 HWNDsettings_menu", LLK-UI: Settings Menu (%section%)
	Gui, %GUI_name%: Color, Purple
	WinSet, TransColor, Purple
	Gui, %GUI_name%: Margin, % vars.settings.xMargin, % vars.settings.line1
	Gui, %GUI_name%: Font, % "s" settings.general.fSize - 2 " cWhite", % vars.system.font
	hwnd_old := vars.hwnd.settings.main, vars.hwnd.settings := {"main": settings_menu, "GUI_name": GUI_name}

	Gui, %GUI_name%: Add, Text, % "Section x0 y0 w" settings.general.fWidth*2 " h" settings.general.fHeight " 0x200 Center BackgroundTrans gSettings_menuClose HWNDhwnd", % "x"
	Gui, %GUI_name%: Add, Text, % "Section x0 y0 hp Center BackgroundTrans 0x200 gSettings_general2 HWNDhwnd1", % "exile ui: " Lang_Trans("global_window")
	vars.hwnd.settings.winx := hwnd, vars.hwnd.settings.winbar := hwnd1, active := (vars.settings.active = "general"), cButtons := settings.general.cButtons, cButtons2 := settings.general.cButtons2
	ControlGetPos,,,, hWinbar,, ahk_id %hwnd1%

	If (fSize != settings.general.fSize)
	{
		fHeight := settings.general.fHeight - 2, LLK_PanelDimensions(vars.settings.sections2, settings.general.fSize, section_width, height)
		For key, hbm in vars.pics.settings
			DeleteObject(hbm)
		dIcon := Round((fHeight + 2) * 2), wHeader := dIcon * (FileExist("add-ons") ? 8 : 7)
		vars.pics.settings := {}, fSize := settings.general.fSize, vars.pics.settings.selection_general := LLK_ImageCache("img\GUI\settings\general.png", dIcon)
	}

	Gui, %GUI_name%: Font, % "s" settings.general.fSize - 2
	Gui_Label(GUI_name, (vars.general.safe_mode ? "Hidden " : "") "Section xs x" xMargin " y+" vars.settings.line1 " w" section_width " Center", Lang_Trans("ms_header"),,, [slop, 0, 0, 0], radius, -2)
	Gui_Label(GUI_name, (vars.general.safe_mode ? "Hidden " : "") "Section ys x+0 w" wHeader " Center", Lang_Trans("ms_header2"),,, [0, slop, 0, 0], radius, - 2)
	Gui, %GUI_name%: Font, % "s" settings.general.fSize
	Gui, %GUI_name%: Add, Pic, % (vars.general.safe_mode ? "Hidden " : "") "Section xs y+0 BackgroundTrans HWNDhwnd gSettings_menu", % "HBitmap:*" vars.pics.settings.selection_general
	Gui, %GUI_name%: Add, Pic, % (vars.general.safe_mode ? "Hidden " : "") "xp yp BackgroundTrans HWNDhwnd1", % "HBitmap:" Gui_BackgroundPanel([hwnd],, radius, (active ? "push FFFF00" : ""), cButtons)
	ControlGetPos, x, y,, h,, ahk_id %hwnd%
	vars.hwnd.settings.general := hwnd, vars.settings.xSelection := x, vars.settings.ySelection := y + h + vars.settings.xMargin, vars.settings.wSelection := section_width
	vars.hwnd.settings["background_general"] := vars.hwnd.help_tooltips["settings_selection general"] := hwnd1, vars.settings.x_anchor := vars.settings.wSelection + 2*vars.settings.xMargin
	feature_check := {"actdecoder": "actdecoder", "betrayal-info": "betrayal", "cheat-sheets": "cheatsheets", "leveling tracker": "leveltracker", "mapping tracker": "maptracker", "map-info": "mapinfo", "tldr-tooltips": "TLDR", "sanctum": "sanctum", "stash-ninja": "stash", "filterspoon" : "lootfilter", "item-info": "iteminfo", "statlas": "statlas", "anoints": "anoints", "addons": "addons", "runeshaping": "runeshaping"}
	feature_check2 := {"item-info": 1, "mapping tracker": 1, "map-info": 1, "statlas": 1, "runeshaping": 1}, cDisabled := settings.general.cDisabled

	If vars.general.safe_mode
		vars.settings.x_anchor := vars.settings.xMargin, vars.settings.ySelection := fHeight + xMargin
	Else For index, val in vars.settings.sections
	{
		If (val = "general") || (val = "screen-checks") && !IsNumber(vars.pixelsearch.gamescreen.x1) || !vars.log.file_location && InStr("mapping tracker, actdecoder", val)
		|| vars.client.stream && InStr("item-info, map-info, filterspoon", val) || (val = "addons") && !FileExist("add-ons")
			Continue
		color := (val = "updater" && IsNumber(vars.update.1) && vars.update.1 < 0) ? " cRed" : (val = "updater" && IsNumber(vars.update.1) && vars.update.1 > 0) ? " cLime" : ""
		color := feature_check[val] && !settings.features[feature_check[val]] || (val = "clone-frames") && !vars.cloneframes.enabled || (val = "search-strings") && !vars.searchstrings.enabled || (val = "minor qol tools") && !LLK_HasVal(settings.qol, 1) ? " c" cDisabled : color, color := feature_check2[val] && (settings.general.lang_client = "unknown") ? " c" cDisabled : color
		color := (val = "donations" ? " cFFFF00" : (val = "news" && vars.news.unread ? " cLime" : color))
		color := (val = "macros" ? (!Blank(settings.macros.hotkey_fasttravel) || !Blank(settings.macros.hotkey_custommacros) ? " cWhite" : " c" cDisabled) : color)
		color := (val = "exchange" && !(settings.features.exchange + settings.features.async) ? " c" cDisabled : color), active := (val = vars.settings.active || val = "updater" && vars.settings.active = "news")
		If (val = "cheat-sheets")
			For sheet, object in vars.cheatsheets.list
				If object.version && (sheet_check := LLK_HasVal(vars.cheatsheets.samples, sheet, 1,,, 1)) && (object.version < vars.cheatsheets.samples[sheet_check].version)
					color := " cLime"

		If !main_section && FileExist("img\GUI\settings\" val "*")
		{
			If !vars.pics.settings[val]
				vars.pics.settings[val] := LLK_ImageCache("img\GUI\settings\" val . (val = "client" ? vars.poe_version : "") ".png", dIcon)
			Gui, %GUI_name%: Add, Pic, % "ys x+0 BackgroundTrans gSettings_menu HWNDhwnd", % "HBitmap:*" vars.pics.settings[val]
		}
		Else Gui, %GUI_name%: Add, Text, % (main_section = 1 ? "Section x" vars.settings.xMargin " yp" : "xs y+0") " w" section_width " h" fHeight " BackgroundTrans gSettings_menu HWNDhwnd" color, % " " Lang_Trans("ms_" val, (vars.poe_version && val = "sanctum") ? 2 : 1)

		If slop
			slop2 := (val = "donations" ? [0, 0, 0, 1] : (index = vars.settings.sections.Count() ? [0, 0, 1, 1] : 0))
		Else slop2 := 0
		Gui, %GUI_name%: Add, Pic, % "xp yp BackgroundTrans HWNDhwnd1", % "HBitmap:" Gui_BackgroundPanel((!main_section ? [hwnd] : hwnd), slop2, radius, (active ? "push FFFF00" : ""), cButtons)
		If RegExMatch(val, "client|screen-checks|updater")
			Gui, %GUI_name%: Add, Pic, % "xp yp BackgroundTrans HWNDhwnd2", % "HBitmap:" Gui_BackgroundPanel([hwnd], slop2, radius, (active ? "push FFFF00" : ""), (InStr("client,screen-checks", val) || (val = "updater" && IsNumber(vars.update.1) && vars.update.1 < 0) ? "700000" : "006000"))
		Else hwnd2 := ""

		vars.hwnd.settings[val] := hwnd, vars.hwnd.settings["background_"val] := hwnd1, main_section += (main_section ? 1 : 0)
		If !main_section
		{
			vars.hwnd.help_tooltips["settings_selection " val] := hwnd1
			If hwnd2
				vars.hwnd.help_tooltips["settings_selection " val "|"] := hwnd2
		}

		If (index = vars.settings.sections.Count())
			Gui, %GUI_name%: Add, Text, % "xs y+0 wp h" fHeight + vars.settings.line1 " BackgroundTrans"
		If (val = "donations")
			main_section := 1
	}
	ControlGetPos, x, yLast_section, w, hLast_section,, ahk_id %hwnd%
	Gui, %GUI_name%: Font, norm

	;if aspect-ratio is wider than officially supported by PoE, show message and force-open the general section
	If !vars.general.safe_mode && !settings.general.warning_ultrawide && (vars.client.h0/vars.client.w0 < (5/12))
	{
		IniWrite, 1, % "ini" vars.poe_version "\config.ini", Versions, ultrawide warning
		settings.general.warning_ultrawide := 1
		If Gui_MsgBox("utrawide warning",, [Lang_Trans("global_ultrawide"), Lang_Trans("global_ultrawide", 2), Lang_Trans("global_ultrawide", 3)],, ["yes", "no"])
		{
			IniWrite, 1, % "ini" vars.poe_version "\config.ini", Settings, black-bar compensation
			IniWrite, general, % "ini" vars.poe_version "\config.ini", versions, reload settings
			KeyWait, LButton
			Reload
			ExitApp
		}
	}

	If vars.settings.restart
		section := vars.settings.restart

	vars.settings.active0 := section
	Settings_ScreenChecksValid() ;check if 'screen-checks' section needs to be highlighted red

	Settings_menu2(section, mode, sub_section)
	Gui, %GUI_name%: Margin, % vars.settings.xMargin, 0
	Gui, %GUI_name%: Add, Text, % "Section xs x" vars.settings.x_anchor " y+0 w" settings.general.fWidth * vars.settings.min_width " h" vars.settings.spacing " BackgroundTrans"
	Gui, %GUI_name%: Show, % "NA AutoSize x10000 y10000"
	ControlFocus,, % "ahk_id "vars.hwnd.settings.general
	WinGetPos,,, w, h, % "ahk_id "vars.hwnd.settings.main

	If WinExist("ahk_id " vars.hwnd.help_tooltips.main)
		Gui, % Gui_Name(vars.hwnd.help_tooltips.main) ":+Owner" vars.hwnd.settings.main

	GuiControl, Move, % vars.hwnd.settings.winbar, % "w" w
	GuiControl, Move, % vars.hwnd.settings.winx, % "x" w - settings.general.fWidth * 2.5
	Gui, %GUI_name%: Margin, 0, 0

	If (cBorder_check != cButtons "|" cButtons2)
		cBorder_check := cButtons "|" cButtons2, cBorder := RGB_Max(cButtons, cButtons2)

	Gui, %GUI_name%: Add, Pic, % "x0 y0", % "HBitmap:" Gui_BackgroundPanel(vars.hwnd.settings.main, slop, 2*settings.general.radius)
	WinSet, Redraw,, % "ahk_id " vars.hwnd.settings.main
	Sleep 50

	If (vars.settings.x != "") && (vars.settings.y != "")
		vars.settings.x := (vars.settings.x + w > vars.monitor.x + vars.monitor.w) ? vars.monitor.x + vars.monitor.w - w - 1 : vars.settings.x
		, vars.settings.y := (vars.settings.y + h > vars.monitor.y + vars.monitor.h) ? vars.monitor.y + vars.monitor.h - h : vars.settings.y
	Else vars.settings.x := vars.monitor.x + vars.monitor.w/2 - w/2, vars.settings.y := vars.monitor.y + vars.monitor.h/8

	Gui, %GUI_name%: Show, % "NA x" vars.settings.x " y" vars.settings.y
	LLK_Overlay(vars.hwnd.settings.main, "show", NA, GUI_name), LLK_Overlay(hwnd_old, "destroy")
	vars.settings.w := w, vars.settings.h := h, vars.settings.restart := vars.settings.wait := ""
}

Settings_menu2(section, mode := 0, sub_section := "") ;mode parameter used when manually calling this function to refresh the window
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
		Case "addons":
			If sub_section
				vars.addons.list[sub_section].func.Settings_menu()
			Else Settings_addons(mode)
		Case "betrayal-info":
			Settings_betrayal()
		Case "cheat-sheets":
			Settings_cheatsheets()
		Case "client":
			Settings_client()
		Case "clone-frames":
			Settings_cloneframes()
		Case "donations":
			Settings_donations()
		Case "notifications":
			Settings_notifications()
		Case "exchange":
			Settings_exchange()
		Case "tldr-tooltips":
			Settings_TLDR()
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
		Case "macros":
			Settings_macros()
		Case "mapping tracker":
			Settings_maptracker()
		Case "map-info":
			Settings_mapinfo()
		Case "minor qol tools":
			Settings_qol()
		Case "news":
			Settings_news()
		Case "runeshaping":
			Settings_runeshaping()
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

Settings_news()
{
	local
	global vars, settings, db, json
	static fSize, colors := [" cYellow", " cFF8000", " cRed"]

	If (fSize != settings.general.fSize)
	{
		fSize := settings.general.fSize
		For key, val in vars.pics.news
			DeleteObject(val)
		vars.pics.news := {"bullet": LLK_ImageCache("img\GUI\bullet_diamond.png",, settings.general.fHeight - 2)}
	}

	If settings.general.dev
		vars.news.file := json.Load(LLK_FileRead("data\announcements.json"))
	GUI := "settings_menu" vars.settings.GUI_toggle, x_anchor := vars.settings.x_anchor, margin := settings.general.fWidth//2, news := vars.news
	Gui, %GUI%: Add, Text, % "Section x" x_anchor " y" vars.settings.ySelection " BackgroundTrans", % Lang_Trans("m_news_recent")
	For index, array in news.file.messages
	{
		timestamp := StrReplace(StrReplace(StrReplace(array.1.stamp, "-"), " "), ":"), topic := array.1.topic, color := colors[array.1.priority]
		now := A_NowUTC, days := hours := 0
		EnvSub, now, timestamp, minutes
		While (now >= 1440)
			now -= 1440, days += 1
		While (now >= 60)
			now -= 60, hours += 1

		Gui, %GUI%: Font, bold underline
		Gui, %GUI%: Add, Text, % "Section xs y+" margin * 2 . color  " BackgroundTrans", % Trim((days ? days "d, " : "") . (hours ? hours "h" : "") . (days ? "" : (hours ? ", " : "") . (now ? now "m" : "")), " ,") " ago: " topic
		Gui, %GUI%: Font, norm

		For index, line in array
			If (index != 1)
			{
				Gui, %GUI%: Add, Pic, % "Section xs y+" margin " BackgroundTrans", % "HBitmap:*" vars.pics.news.bullet
				Gui, %GUI%: Add, Text, % "ys x+0 w" settings.general.fWidth * 35 " BackgroundTrans", % line
			}
	}

	If vars.news.unread
	{
		IniWrite, % """" (vars.news.last_read := vars.news.file.timestamp) """", % "ini\config.ini", % "versions", % "announcement"
		vars.news.unread := 0

		If WinExist("ahk_id " vars.hwnd.radial.main)
			LLK_Overlay(vars.hwnd.radial.main, "destroy"), vars.hwnd.radial.main := ""
	}
	GuiControl, % "+cWhite", % vars.hwnd.settings.news
}

Settings_notifications()
{
	local
	global vars, settings
	static fSize, wDuration, wList, wHideout, wTiers, wFont, DDL, wDDL

	GUI := "settings_menu" vars.settings.GUI_toggle, x_anchor := vars.settings.x_anchor, slop := settings.general.slop, cButtons := settings.general.cButtons, fWidth := settings.general.fWidth, fHeight := settings.general.fHeight
	If (fSize != settings.general.fSize)
	{
		fSize := settings.general.fSize
		LLK_PanelDimensions([Lang_Trans("global_duration"), Lang_Trans("global_opacity",,, 1)], fSize, wDuration, hDuration)
		LLK_PanelDimensions([Lang_Trans("global_font",,, 1), Lang_Trans("global_position")], fSize, wFont, hFont)

		dimensions := []
		For i, v in ["", 2]
			For index, val in settings.notifications["event_list" v]
				If (val != "hideout")
					dimensions.Push(Lang_Trans(i = 1 ? "mechanic_" val : "notification_" val))

		LLK_PanelDimensions(dimensions, fSize, wList, hList)
		LLK_PanelDimensions([Lang_Trans("mechanic_hideout")], fSize, wHideout, hHideout)
		LLK_PanelDimensions([Lang_Trans("global_tiers", 1), Lang_Trans("global_tiers", 2), Lang_Trans("global_tiers", 3)], fSize, wTiers, hTiers)
		wList := Max(wList, wHideout + 3 * wTiers), DDL := []

		For index, val in ["top", "bottom", "left", "right"]
			DDL.Push(Lang_Trans("m_general_pos" val))
		LLK_PanelDimensions(DDL, fSize, wDDL, hDDL), wDDL := Max(wDDL, 7*fWidth)
	}

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "Section x" x_anchor " y" vars.settings.ySelection " BackgroundTrans", % Lang_Trans("global_general")
	Gui, %GUI%: Font, norm

	Gui_Label(GUI, "Section xs w" wFont " Right", Lang_Trans("global_font",,, 1) " ",,, [slop, 0, 0, 0])
	Gui_Label(GUI, "ys x+0 w" 2*fWidth " Center gSettings_notifications2", "–", "settings_font-size", "hwnd.settings.font_minus",,,, cButtons)
	Gui_Label(GUI, "ys x+0 w" wDDL - 4*fWidth " Center gSettings_notifications2", settings.notifications.fSize, "settings_font-size|", "hwnd.settings.font_reset",,,, cButtons)
	Gui_Label(GUI, "ys x+0 w" 2*fWidth " Center gSettings_notifications2", "+", "settings_font-size||", "hwnd.settings.font_plus", [0, slop, 0, 0],,, cButtons)

	Gui_Label(GUI, "xs y+0 w" wFont " Right", Lang_Trans("global_position") " ",,, [0, 0, slop, 0])
	Gui_Label(GUI, "ys x+0 yp w" wDDL " Center gSettings_notifications2", DDL[settings.notifications.position], "settings_map-events position", "hwnd.settings.position_notifications", [0, 0, 0, slop],,, cButtons)
	vars.ddl.position_notifications := {"cHWND": hwnd, "current": DDL[settings.notifications.position], "list": DDL.Clone(), "color": cButtons, "fSize": fSize}

	For index, val in ["duration", "opacity"]
		Gui_Label(GUI, (index = 1 ? "Section ys" : "xs y+0") " w" wDuration " Right", Lang_Trans("global_" val,,, 1) " ",,, [(slop && A_Index = 1), 0, (slop && A_Index = 2), 0])
		, Gui_Label(GUI, "ys yp x+0 w" 3*fWidth " Center gSettings_notifications2", settings.notifications[val], "settings_slider general" handle, "hwnd.settings." val, [0, (slop && A_Index = 1), 0, (slop && A_Index = 2)],,, cButtons), handle .= "|"

	mechanics := {}, handle := ""
	For index, val in settings.notifications.event_list
		mechanics[Lang_Trans("mechanic_" val)] := val

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "Section xs x" x_anchor " y+" vars.settings.spacing " BackgroundTrans", % Lang_Trans("m_notifications_label")
	Gui, %GUI%: Font, norm
	Gui, %GUI%: Add, Pic, % "ys hp w-1 HWNDhwnd BackgroundTrans", % "HBitmap:*" vars.pics.global.help
	vars.hwnd.help_tooltips["settings_notifications events about"] := hwnd

	If vars.poe_version
		Gui, %GUI%: Add, Text, % "Section xs w" settings.general.fWidth * vars.settings.min_width " cYellow", % "poe2 doesn't have notable in-game events (as far as i know)"
	For key, val in mechanics
	{
		Gui_Label(GUI, "Section xs w" (val = "hideout" ? wHideout : wList) " gSettings_notifications2", " " key, "settings_map-events enable event" handle, "hwnd.settings.enable_" val, [slop, 0, slop, 0],,, cButtons, settings.notifications.events[val])
		If (val = "hideout")
			Loop 3
				color := (settings.notifications.events.hideout && settings.notifications.events["hideout_t" A_Index] ? "Lime" : "Gray")
				, Gui_Label(GUI, "ys x+0 w" wTiers " Center gSettings_notifications2", Lang_Trans("global_tiers", A_Index), "settings_map-events hideout tiers" handle_tiers, "hwnd.settings.hideouttier_" A_Index,,,, cButtons, (settings.notifications.events.hideout && settings.notifications.events["hideout_t" A_Index])), handle_tiers .= "|"

		For i, v in ["", 1]
			Gui_Label(GUI, "ys x+0 w" fHeight " gSettings_notifications2",, "settings_generic color double" v . handle, "hwnd.settings.color" v "_" val, (i = 1 ? 0 : [0, slop, 0, slop]),, "push 000000", settings.notifications["color" v "_" val]), handle .= "|"
	}

	features := {}, names := {"lootfilter": Lang_Trans("ms_filterspoon"), "updater": Lang_Trans("ms_updater")}, enabled := 0
	For index, val in settings.notifications.event_list2
		features[Lang_Trans("notification_" val)] := val, enabled += (settings.features[val] ? 1 : 0)

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "Section xs x" x_anchor " y+" vars.settings.spacing " BackgroundTrans", % Lang_Trans("m_notifications_label2")
	Gui, %GUI%: Font, norm
	Gui, %GUI%: Add, Pic, % "ys hp w-1 HWNDhwnd BackgroundTrans", % "HBitmap:*" vars.pics.global.help
	vars.hwnd.help_tooltips["settings_notifications features about"] := hwnd

	For key, val in features
	{
		enabled := (settings.features[val] || val = "updater" && (settings.updater.update_check || settings.general.dev))
		tooltip := (enabled ? "settings_map-events enable notification" handle : "settings_notifications disabled" handle_disabled)
		Gui_Label(GUI, "Section xs w" wList " c" (enabled ? (settings[val].notify ? "Lime" : "Gray") " gSettings_notifications2" : "Gray"), " " key, tooltip, "hwnd.settings.feature_" val, [slop, 0, slop, 0],,, cButtons)

		tooltip := (enabled ? "settings_generic color double" handle : "settings_notifications disabled" handle_disabled "|")
		Gui_Label(GUI, "ys x+0 w" fHeight . (enabled ? " gSettings_notifications2" : ""),, tooltip, "hwnd.settings.color_" val,,, "push 000000", (enabled ? settings.notifications["color_" val] : ""))

		tooltip := (enabled ? "settings_generic color double1" handle : "settings_notifications disabled" handle_disabled "||")
		Gui_Label(GUI, "ys x+0 w" fHeight . (enabled ? " gSettings_notifications2" : ""),, tooltip, "hwnd.settings.color1_" val, [0, slop, 0, slop],, "push 000000", (enabled ? settings.notifications["color1_" val] : ""))
		handle .= "|", handle_disabled := handle_disabled . (enabled ? "" : "|||")

		Gui, %GUI%: Add, Text, % "ys hp BackgroundTrans" (enabled ? "" : " cGray"), % names[val]
	}
}

Settings_notifications2(cHWND)
{
	local
	global vars, settings

	check := LLK_HasVal(vars.hwnd.settings, cHWND), control := SubStr(check, InStr(check, "_") + 1)
	If !RegExMatch(check, "i)font_|duration|opacity")
	{
		KeyWait, LButton
		KeyWait, RButton
	}
	Switch
	{
		Case InStr(check, "font_"):
			While GetKeyState("LButton", "P")
			{
				settings.notifications.fSize := (control = "reset" ? settings.general.fSize * 2 : settings.notifications.fSize + (control = "minus" && settings.notifications.fSize > 6 ? - 1 : 1))
				GuiControl, Text, % vars.hwnd.settings.font_reset, % settings.notifications.fSize
				Sleep, 100
			}
			IniWrite, % settings.notifications.fSize, % "ini" vars.poe_version "\notifications.ini", settings, font-size

		Case InStr(check, "enable_"):
			If (vars.system.click = 2)
			{
				Notification(control)
				Return
			}
			If !(type := (LLK_HasVal(settings.notifications.event_list, control) ? "events" : (LLK_HasVal(settings.notifications.event_list2, control) ? "features" : "")))
				Return
			IniWrite, % (settings.notifications[type][control] := !settings.notifications[type][control]), % "ini" vars.poe_version "\notifications.ini", % type, % control
			GuiControl, % "+c" (settings.notifications[type][control] ? "Lime" : "Gray"), % cHWND
			GuiControl, % "movedraw", % cHWND
			If (control != "hideout")
				Return
			If settings.notifications.events.hideout && !(settings.notifications.events.hideout_t1 + settings.notifications.events.hideout_t2 + settings.notifications.events.hideout_t3)
				IniWrite, % (settings.notifications.events.hideout_t1 := 1), % "ini" vars.poe_version "\notifications.ini", events, % "hideout T1"
			Loop 3
			{
				GuiControl, % "+c" (settings.notifications.events.hideout && settings.notifications.events["hideout_t" A_Index] ? "Lime" : "Gray"), % vars.hwnd.settings["hideouttier_" A_Index]
				GuiControl, % "movedraw", % vars.hwnd.settings["hideouttier_" A_Index]
			}

		Case InStr(check, "feature_"):
			If (vars.system.click = 2)
			{
				Notification(control)
				Return
			}
			Else
			{
				If (control = "lootfilter")
					IniWrite, % (enabled := settings.lootfilter.notify := (!settings.lootfilter.notify ? 4 : 0)), % "ini" vars.poe_version "\lootfilter.ini", settings, sync notification
				Else If (control = "updater")
					IniWrite, % (enabled := settings.updater.notify := !settings.updater.notify), % "ini\config.ini", settings, update notification
				GuiControl, % "+c" (enabled ? "Lime" : "Gray"), % cHWND
				GuiControl, % "movedraw", % cHWND
			}
		
		Case InStr(check, "hideouttier_"):
			If !settings.notifications.events.hideout
				Return
			IniWrite, % (settings.notifications.events["hideout_t" control] := !settings.notifications.events["hideout_t" control]), % "ini" vars.poe_version "\notifications.ini", events, % "hideout T" control
			GuiControl, % "+c" (settings.notifications.events["hideout_t" control] ? "Lime" : "Gray"), % cHWND
			GuiControl, % "movedraw", % cHWND
			If !(settings.notifications.events.hideout_t1 + settings.notifications.events.hideout_t2 + settings.notifications.events.hideout_t3)
			{
				IniWrite, % (settings.notifications.events.hideout := 0), % "ini" vars.poe_version "\notifications.ini", events, % "hideout"
				GuiControl, % "+cGray", % vars.hwnd.settings["enable_hideout"]
				GuiControl, % "movedraw", % vars.hwnd.settings["enable_hideout"]
			}

		Case RegexMatch(check, "^color"):
			If (vars.system.click = 1)
				rgb := RGB_Picker(settings.notifications["color" (InStr(check, "1") ? "1" : "") "_" control])
			If (vars.system.click = 1) && Blank(rgb)
				Return
			Else If (vars.system.click = 2)
				rgb := (InStr(check, "1") ? "FFFFFF" : (LLK_HasVal(settings.notifications.event_list, control) ? "FF0000" : "0000FF"))

			IniWrite, % """" (settings.notifications["color" (InStr(check, "1") ? "1" : "") "_" control] := rgb) """", % "ini" vars.poe_version "\notifications.ini", settings, % (InStr(check, "1") ? "background-color " : "text-color ") . control
			Settings_menu()
		
		Case RegexMatch(check, "i)(duration|opacity)"):
			input := Gui_Slider(cHWND, [(check = "duration" ? 3 : 1), settings.notifications[check], (check = "duration" ? 10 : 5)], 20)
			If (settings.notifications[check] != input)
				IniWrite, % (settings.notifications[check] := input), % "ini" vars.poe_version "\notifications.ini", settings, % check

		Case InStr(check, "position_"):
			If Blank(input := Gui_DropDownList(vars.ddl[check], LLK_WinGetPos(cHWND, "array"), "Center", 1)) || IsObject(input) && Blank(input.1 . input.2)
				Return
			vars.ddl[check].current := input.1
			IniWrite, % (settings.notifications.position := input.2), % "ini" vars.poe_version "\notifications.ini", settings, position

		Default:
			LLK_ToolTip("no action")
	}
}

Settings_qol()
{
	local
	global vars, settings
	static fSize, wFont, wDuration, wPosition, wTiers, wHotkey, wControl, wSnip

	GUI := "settings_menu" vars.settings.GUI_toggle, x_anchor := vars.settings.x_anchor, yMax := 0
	vars.settings.quickpob_alt_provisional := settings.quickpob.hotkey_alt, vars.settings.quickpob_ctrl_provisional := settings.quickpob.hotkey_ctrl

	If (fSize != settings.general.fSize)
	{
		fSize := settings.general.fSize
		LLK_PanelDimensions([Lang_Trans("global_hotkey"), Lang_Trans("global_save"), Lang_Trans("global_mode") . Lang_Trans("global_colon"), Lang_Trans("global_folder") . Lang_Trans("global_colon")], fSize, wHotkey, hHotkey)
		LLK_PanelDimensions([Lang_Trans("global_ctrl"), Lang_Trans("global_alt")], fSize, wControl, hControl), wControl := (wControl < 3*settings.general.fWidth ? 3*settings.general.fWidth : wControl)
		LLK_PanelDimensions([Lang_Trans("quickpob_snip"), Lang_Trans("global_calibrate", 3)], fSize, wSnip, hSnip)
	}

	Gui, %GUI%: Add, Text, % "Section x" x_anchor " y" vars.settings.ySelection " Border BackgroundTrans HWNDhwnd gURL cAqua", % " wiki page "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.URLs := {}, vars.URLs[hwnd] := "https://github.com/Lailloken/Exile-UI/wiki/Minor-Features", vars.hwnd.help_tooltips["settings_website"] := hwnd1

	If settings.qol.quickpob
	{
		Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans HWNDhwnd gURL cAqua", % " ahk: key list "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.URLs[hwnd] := "https://www.autohotkey.com/docs/v1/KeyList.htm", vars.hwnd.help_tooltips["settings_website|"] := hwnd1
	}

	Gui, %GUI%: Add, Text, % "Section xs y+" vars.settings.spacing " Border BackgroundTrans gSettings_qol2 HWNDhwnd" (settings.qol.alarm ? " cLime" : " cGray"), % " " Lang_Trans("global_enable") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	Gui, %GUI%: Add, Text, % "ys x+" settings.general.fWidth/2 " hp 0x200 HWNDhwnd0" (settings.qol.alarm ? "" : " cGray"), % StrReplace(Lang_Trans("m_qol_alarm"), Lang_Trans("global_colon"))
	vars.hwnd.help_tooltips["settings_alarm enable"] := hwnd1, vars.hwnd.settings.enable_alarm := hwnd, vars.hwnd.help_tooltips["settings_alarm enable|"] := hwnd0

	If settings.qol.alarm
	{
		Gui, %GUI%: Add, Text, % "Section xs y+0 w2 h" vars.settings.line1 " Border HWNDhwnd_brace"

		Gui, %GUI%: Add, Text, % "Section ys yp+" vars.settings.line1 " Right Border BackgroundTrans", % " " Lang_Trans("global_font") " "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border Background404040 cBlack", 100
		Gui, %GUI%: Add, Text, % "ys x+-1 HWNDhwnd Border BackgroundTrans Center gSettings_qol2 w"settings.general.fWidth*2, % "–"
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings.alarmfont_minus := hwnd, vars.hwnd.help_tooltips["settings_font-size|"] := hwnd1

		Gui, %GUI%: Add, Text, % "ys x+-1 HWNDhwnd Border BackgroundTrans Center gSettings_qol2 w"settings.general.fWidth*3, % settings.alarm.fSize
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings.alarmfont_reset := hwnd, vars.hwnd.help_tooltips["settings_font-size||"] := hwnd1

		Gui, %GUI%: Add, Text, % "ys x+-1 HWNDhwnd Border BackgroundTrans Center gSettings_qol2 w"settings.general.fWidth*2, % "+"
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings.alarmfont_plus := hwnd, vars.hwnd.help_tooltips["settings_font-size|||"] := hwnd1

		Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans", % " " Lang_Trans("global_color", 2) " "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border Background404040 cBlack", 100
		Gui, %GUI%: Add, Text, % "ys x+-1 w" settings.general.fWidth " hp BackgroundTrans Border HWNDhwnd gSettings_qol2"
		Gui, %GUI%: Add, Progress, % "xp yp wp hp Border Disabled BackgroundBlack HWNDhwnd1 c" settings.alarm.color, 100
		vars.hwnd.settings.color_alarm := hwnd, vars.hwnd.settings.color_alarm_bar := vars.hwnd.help_tooltips["settings_generic color double"] := hwnd1

		Gui, %GUI%: Add, Text, % "ys x+-1 w" settings.general.fWidth " hp Border BackgroundTrans HWNDhwnd gSettings_qol2"
		Gui, %GUI%: Add, Progress, % "xp yp wp hp Border Disabled BackgroundBlack HWNDhwnd1 c" settings.alarm.color1, 100
		vars.hwnd.settings.color_alarm1 := hwnd, vars.hwnd.settings.color_alarm1_bar := vars.hwnd.help_tooltips["settings_generic color double1"] := hwnd1

		Gui, %GUI%: Add, Text, % "Section xs x" x_anchor " w" settings.general.fWidth * 20 " h2 Border HWNDhwnd"
		GuiControl, movedraw, % hwnd_brace, % "h" LLK_ControlGetPos(hwnd, "y") - LLK_ControlGetPos(hwnd_brace, "y")
	}

	cLast := LLK_ControlGetPos(hwnd), yMax := Max(yMax, cLast.y + cLast.h)
	Gui, %GUI%: Add, Text, % "Section xs x" x_anchor " y" yMax + vars.settings.spacing " Border BackgroundTrans gSettings_qol2 HWNDhwnd" (settings.qol.notepad ? " cLime" : " cGray"), % " " Lang_Trans("global_enable") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	Gui, %GUI%: Add, Text, % "ys x+" settings.general.fWidth/2 " hp 0x200 HWNDhwnd0" (settings.qol.notepad ? "" : " cGray"), % StrReplace(Lang_Trans("m_qol_notepad"), Lang_Trans("global_colon"))
	vars.hwnd.help_tooltips["settings_notepad enable"] := hwnd0, vars.hwnd.settings.enable_notepad := hwnd, vars.hwnd.help_tooltips["settings_notepad enable|"] := hwnd1

	If settings.qol.notepad
	{
		Gui, %GUI%: Add, Text, % "Section xs y+0 w2 h" vars.settings.line1 " Border HWNDhwnd_brace"

		Gui, %GUI%: Add, Text, % "Section ys yp+" vars.settings.line1 " Border BackgroundTrans Right", % " " Lang_Trans("global_font") " "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border Background404040 cBlack", 100
		Gui, %GUI%: Add, Text, % "ys x+-1 HWNDhwnd Border BackgroundTrans Center gSettings_qol2 w"settings.general.fWidth*2, % "–"
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings.notepadfont_minus := hwnd, vars.hwnd.help_tooltips["settings_font-size|||||||||"] := hwnd1

		Gui, %GUI%: Add, Text, % "ys x+-1 HWNDhwnd Border BackgroundTrans Center gSettings_qol2 w"settings.general.fWidth*3, % settings.notepad.fSize
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings.notepadfont_reset := hwnd, vars.hwnd.help_tooltips["settings_font-size||||||||||"] := hwnd1

		Gui, %GUI%: Add, Text, % "ys x+-1 HWNDhwnd Border BackgroundTrans Center gSettings_qol2 w"settings.general.fWidth*2, % "+"
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings.notepadfont_plus := hwnd, vars.hwnd.help_tooltips["settings_font-size|||||||||||"] := hwnd1

		Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans", % " " Lang_Trans("m_qol_widgetcolor") " "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd Background404040 cBlack", 100
		vars.hwnd.help_tooltips["settings_notepad default color"] := hwnd
		Gui, %GUI%: Add, Text, % "ys x+-1 w" settings.general.fWidth " hp BackgroundTrans Border HWNDhwnd gSettings_qol2"
		Gui, %GUI%: Add, Progress, % "xp yp wp hp Border Disabled BackgroundBlack HWNDhwnd1 c" settings.notepad.color, 100
		vars.hwnd.settings.color_notepad := hwnd, vars.hwnd.settings.color_notepad_bar := vars.hwnd.help_tooltips["settings_generic color double|" handle] := hwnd1

		Gui, %GUI%: Add, Text, % "ys x+-1 w" settings.general.fWidth " hp BackgroundTrans Border HWNDhwnd gSettings_qol2"
		Gui, %GUI%: Add, Progress, % "xp yp wp hp Border Disabled BackgroundBlack HWNDhwnd1 c" settings.notepad.color1, 100
		vars.hwnd.settings.color_notepad1 := hwnd, vars.hwnd.settings.color_notepad1_bar := vars.hwnd.help_tooltips["settings_generic color double1|" handle] := hwnd1

		Gui, %GUI%: Add, Text, % "Section xs Border BackgroundTrans", % " " Lang_Trans("m_qol_widget") " "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd Background404040 cBlack", 100
		vars.hwnd.help_tooltips["settings_notepad opacity"] := hwnd, handle := "|"
		Loop 6
		{
			Gui, %GUI%: Add, Text, % "ys x+-1 HWNDhwnd Border BackgroundTrans Center gSettings_qol2 w" settings.general.fWidth*2 (A_Index - 1 = settings.notepad.trans ? " cLime" : ""), % A_Index - 1
			Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
			vars.hwnd.settings["notepadopac_" A_Index - 1] := hwnd, vars.hwnd.help_tooltips["settings_notepad opacity" handle] := hwnd1, handle .= "|"
		}

		Gui, %GUI%: Add, Text, % "Section xs x" x_anchor " w" settings.general.fWidth * 20 " h2 Border HWNDhwnd"
		GuiControl, movedraw, % hwnd_brace, % "h" LLK_ControlGetPos(hwnd, "y") - LLK_ControlGetPos(hwnd_brace, "y")
	}

	If vars.client.stream
		Return

	If !vars.poe_version
	{
		Gui, %GUI%: Add, Text, % "Section xs y+" vars.settings.spacing " Border BackgroundTrans gSettings_qol2 HWNDhwnd" (settings.general.lang_client = "unknown" ? " cGray" : (settings.qol.lab ? " cLime" : " cGray")), % " " Lang_Trans("global_enable") " "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		Gui, %GUI%: Add, Text, % "ys x+" settings.general.fWidth/2 " hp 0x200 HWNDhwnd0" (settings.general.lang_client = "unknown" || !settings.qol.lab ? " cGray" : ""), % StrReplace(Lang_Trans("m_qol_lab"), Lang_Trans("global_colon"))
		If (settings.general.lang_client = "unknown")
			vars.hwnd.help_tooltips["settings_lang incompatible"] := hwnd0, vars.hwnd.settings.enable_lab := hwnd, vars.hwnd.help_tooltips["settings_lang incompatible|"] := hwnd1
		Else vars.hwnd.help_tooltips["settings_lab enable"] := hwnd0, vars.hwnd.settings.enable_lab := hwnd, vars.hwnd.help_tooltips["settings_lab enable|"] := hwnd1
	}

	Gui, %GUI%: Add, Text, % "Section xs y+" vars.settings.spacing " Border BackgroundTrans gSettings_qol2 HWNDhwnd" (settings.qol.quickpob ? " cLime" : " cGray"), % " " Lang_Trans("global_enable") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	Gui, %GUI%: Add, Text, % "ys x+" settings.general.fWidth/2 " hp 0x200 HWNDhwnd0" (settings.qol.quickpob ? "" : " cGray"), % Lang_Trans("m_qol_quickpob")
	vars.hwnd.help_tooltips["settings_quickpob enable"] := hwnd0, vars.hwnd.settings.enable_quickpob := hwnd, vars.hwnd.help_tooltips["settings_quickpob enable|"] := hwnd1

	If settings.qol.quickpob
	{
		Gui, %GUI%: Add, Text, % "Section xs y+0 w2 h" vars.settings.line1 " Border HWNDhwnd_brace"

		Gui, %GUI%: Add, Text, % "Hidden Section ys yp+" vars.settings.line1 " w" wHotkey " h" 2*settings.general.fHeight - 1 " 0x200 Center Border BackgroundTrans cRed gSettings_qol2 HWNDhwnd", % Lang_Trans("global_save")
		Gui, %GUI%: Add, Progress, % "Hidden Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings.quickpob_save := hwnd, vars.hwnd.settings.quickpob_save_bar := hwnd1
		Gui, %GUI%: Add, Text, % "xp yp wp hp Right Border BackgroundTrans 0x200", % Lang_Trans("global_hotkey") " "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border Background" vars.settings.cButtons2 " cBlack", 100

		For index, val in ["ctrl", "alt"]
		{
			Gui, %GUI%: Add, Text, % "ys x+-1 w" wControl " Center Border BackgroundTrans gSettings_qol2 HWNDhwnd c" (settings.quickpob["hotkey_" val] ? "Lime" : "Gray"), % Lang_Trans("global_" val)
			Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
			vars.hwnd.settings["quickpob_" val] := hwnd
		}

		Gui, %GUI%: Font, % "s" settings.general.fSize - 4
		Gui, %GUI%: Add, Text, % "xp-" wControl - 1 " y+-1" " w" 2*wControl - 1 " hp Border BackgroundTrans"
		Gui, %GUI%: Add, Edit, % "xp yp wp hp Center Border cBlack gSettings_qol2 HWNDhwnd1", % settings.quickpob.hotkey
		Gui, %GUI%: Font, % "s" settings.general.fSize
		vars.hwnd.settings.quickpob_hotkey := vars.hwnd.help_tooltips["settings_hotkeys formatting"] := hwnd1

		Gui, %GUI%: Add, Text, % "ys w" wSnip " Center Border BackgroundTrans HWNDhwnd c" (settings.quickpob.snip_offset ? "Lime" : "FF8000"), % Lang_Trans("quickpob_snip")
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " cBlack", 100
		vars.hwnd.settings.quickpob_snip_label := hwnd, vars.hwnd.help_tooltips["settings_quickpob snip"] := hwnd1

		Gui, %GUI%: Add, Text, % "xp y+-1 wp Center Border BackgroundTrans gSettings_qol2 HWNDhwnd", % Lang_Trans("global_calibrate", 3)
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings.quickpob_snip := hwnd, vars.hwnd.help_tooltips["settings_quickpob snip offset"] := hwnd1

		Gui, %GUI%: Add, Text, % "Section xs w" wHotkey " Right Border BackgroundTrans", % Lang_Trans("global_mode") . Lang_Trans("global_colon") " "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " cBlack", 100
		For index, val in ["full", "compact"]
		{
			Gui, %GUI%: Add, Text, % "ys x+-1 Border BackgroundTrans gSettings_qol2 HWNDhwnd" (settings.quickpob.mode = val ? " cLime" : ""), % " " Lang_Trans("global_" val) " "
			Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
			vars.hwnd.settings["quickpob_" val] := hwnd, vars.hwnd.help_tooltips["settings_quickpob mode " val] := hwnd1
		}

		Gui, %GUI%: Add, Text, % "Section xs w" wHotkey " Right Border BackgroundTrans", % Lang_Trans("global_folder") . Lang_Trans("global_colon") " "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border Background" vars.settings.cButtons2 " cBlack", 100

		Gui, %GUI%: Font, % "s" settings.general.fSize - 2
		path := SubStr(settings.quickpob.exe.1, 1, InStr(settings.quickpob.exe.1, "\",, 0) - 1), path := (StrLen(path) > 30 ? SubStr(path, 1, 30) "..." : path)
		Gui, %GUI%: Add, Text, % "ys x+-1 hp Border BackgroundTrans 0x200 HWNDhwnd_text c" (settings.quickpob.exe.1 ? "Lime" : "Yellow"), % " " (settings.quickpob.exe.1 ? LLK_StringCase(path) : Lang_Trans("global_setup", 2)) " "
		Gui, %GUI%: Font, % "s" settings.general.fSize
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " cBlack", 100

		Gui, %GUI%: Add, Pic, % "ys x+-1 w-1 hp-2 Border BackgroundTrans gSettings_qol2 HWNDhwnd", % "HBitmap:*" vars.pics.global.reload
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings.locate_install := hwnd, vars.hwnd.help_tooltips["settings_quickpob locate install"] := hwnd1

		Gui, %GUI%: Add, Text, % "Section xs x" x_anchor " w" settings.general.fWidth * 20 " h2 Border HWNDhwnd"
		GuiControl, movedraw, % hwnd_brace, % "h" LLK_ControlGetPos(hwnd, "y") - LLK_ControlGetPos(hwnd_brace, "y")
	}
}

Settings_qol2(cHWND)
{
	local
	global vars, settings

	check := LLK_HasVal(vars.hwnd.settings, cHWND), control := SubStr(check, InStr(check, "_") + 1), control1 := SubStr(check, 1, InStr(check, "_") - 1)
	If !RegexMatch(check, "i)font_|quickpob_snip")
		KeyWait, LButton

	If InStr(check, "enable_")
	{
		If (control = "lab" && settings.general.lang_client = "unknown")
			Return
		IniWrite, % (settings.qol[control] := !settings.qol[control]), % "ini" vars.poe_version "\qol tools.ini", features, % control
		If (control = "alarm") && !settings.qol.alarm
			vars.alarm.timestamp := "", LLK_Overlay(vars.hwnd.alarm.main, "destroy")
		If (control = "notepad") && WinExist("ahk_id " vars.hwnd.radial.main)
			LLK_Overlay(vars.hwnd.radial.main, "destroy"), vars.hwnd.radial.main := ""
		If (control = "notepad") && !settings.qol.notepad
		{
			LLK_Overlay(vars.hwnd.notepad.main, "destroy"), vars.hwnd.notepad.main := ""
			For key, val in vars.hwnd.notepad_widgets
				LLK_Overlay(val, "destroy")
			vars.hwnd.notepad_widgets := {}, vars.notepad_widgets := {}
		}
		If (control = "quickpob") && !Blank(settings.quickpob.hotkey)
		{
			Hotkey, IfWinActive, % "ahk_group poe_window"
			Hotkey, % Hotkeys_Convert((settings.quickpob.hotkey_alt ? "!" : "") . (settings.quickpob.hotkey_ctrl ? "^" : "") . settings.quickpob.hotkey), QuickPob, % (settings.qol[control] ? "On" : "Off")
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
				control := StrReplace(control, "1"), settings[control].color1 := (vars.system.click = 1) ? picked_rgb : "000000"
			Else settings[control].color := (vars.system.click = 1) ? picked_rgb : "FFFFFF"
		}
		IniWrite, % """" settings[control]["color" (InStr(check, "1") ? "1" : "")] """", % "ini" vars.poe_version "\qol tools.ini", % control, % (InStr(check, "1") ? "background " : "font-") "color"
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
	Else If InStr(check, "font_")
	{
		control1 := StrReplace(control1, "font")
		While GetKeyState("LButton")
		{
			If (control = "minus") && (settings[control1].fSize > 6)
				settings[control1].fSize -= 1
			Else If (control = "reset")
				settings[control1].fSize := Round(settings.general.fSize * 1.5)
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
		GuiControl, +cLime, % vars.hwnd.settings[control1 "opac_" settings[control1].trans]
		GuiControl, movedraw, % vars.hwnd.settings[control1 "opac_" settings[control1].trans]
		If (control1 = "notepad") && vars.hwnd.notepad_widgets.Count()
			For key, val in vars.hwnd.notepad_widgets
				WinSet, Transparent, % (key = "notepad_reminder_feature") ? 250 : 50 * settings.notepad.trans, % "ahk_id "val
	}
	Else If (check = "locate_install")
	{
		WinGet, pob_windows, List, % "ahk_exe " settings.quickpob.exe.2
		If (pob_windows > 1)
		{
			LLK_ToolTip(Lang_Trans("quickpob_multi"), 2,,,, "Red")
			Return
		}
		WinGet, pob_path, ProcessPath, % "ahk_exe " settings.quickpob.exe.2
		If !pob_path
			LLK_ToolTip(Lang_Trans("global_fail"),,,,, "FF8000")
		Else If Gui_MsgBox("pob path", Lang_Trans("m_qol_findpob"), [Lang_Trans("m_qol_findpob", 2), "(color:aqua)" LLK_StringCase(pob_path)],, ["yes", "no"])
		{
			IniWrite, % """" (settings.quickpob.exe.1 := pob_path) """", % "ini" vars.poe_version "\qol tools.ini", quickpob, install folder
			Settings_menu("minor qol tools")
		}
	}
	Else If (check = "quickpob_save")
	{
		input := LLK_ControlGet(vars.hwnd.settings.quickpob_hotkey)
		If !Blank(input) && !Hotkeys_Convert(input)
		{
			LLK_ToolTip(Lang_Trans("m_hotkeys_error"), 1.5,,,, "Red")
			Return
		}
		Hotkey, IfWinActive, % "ahk_group poe_window"
		modifiers := (settings.quickpob.hotkey_alt ? "!" : "") . (settings.quickpob.hotkey_ctrl ? "^" : "")
		modifiers_new := (vars.settings.quickpob_alt_provisional ? "!" : "") . (vars.settings.quickpob_ctrl_provisional ? "^" : "")
		If !Blank(settings.quickpob.hotkey)
			Hotkey, % Hotkeys_Convert(modifiers . settings.quickpob.hotkey), QuickPob, Off
		If !Blank(input)
			Hotkey, % Hotkeys_Convert(modifiers_new . input), QuickPob, On
		Else
		{
			vars.settings.quickpob_alt_provisional := vars.settings.quickpob_ctrl_provisional := 0
			GuiControl, % "+cGray", % vars.hwnd.settings.quickpob_alt
			GuiControl, % "movedraw", % vars.hwnd.settings.quickpob_alt
			GuiControl, % "+cGray", % vars.hwnd.settings.quickpob_ctrl
			GuiControl, % "movedraw", % vars.hwnd.settings.quickpob_ctrl
		}
		IniWrite, % """" (settings.quickpob.hotkey := input) """", % "ini" vars.poe_version "\qol tools.ini", quickpob, hotkey
		IniWrite, % (settings.quickpob.hotkey_alt := vars.settings.quickpob_alt_provisional), % "ini" vars.poe_version "\qol tools.ini", quickpob, alt modifier
		IniWrite, % (settings.quickpob.hotkey_ctrl := vars.settings.quickpob_ctrl_provisional), % "ini" vars.poe_version "\qol tools.ini", quickpob, ctrl modifier
		GuiControl, % "+Hidden", % vars.hwnd.settings.quickpob_save
		GuiControl, % "+Hidden", % vars.hwnd.settings.quickpob_save_bar
		GuiControl, % "+cBlack", % vars.hwnd.settings.quickpob_hotkey
		GuiControl, % "movedraw", % vars.hwnd.settings.quickpob_hotkey
	}
	Else If (check = "quickpob_hotkey")
	{
		input := LLK_ControlGet(cHWND), modified := (input != settings.quickpob.hotkey)
		GuiControl, % "+c" (modified ? "Red" : "Black"), % cHWND
		GuiControl, % "movedraw", % cHWND
		GuiControl, % (modified ? "-" : "+") "Hidden", % vars.hwnd.settings.quickpob_save
		GuiControl, % (modified ? "-" : "+") "Hidden", % vars.hwnd.settings.quickpob_save_bar
	}
	Else If (check = "quickpob_snip")
	{
		If !WinExist("ahk_exe " settings.quickpob.exe.2)
		{
			LLK_ToolTip(Lang_Trans("global_fail"),,,,, "FF8000")
			KeyWait, LButton
			Return
		}
		WinActivate, % "ahk_exe " settings.quickpob.exe.2
		WinWaitActive, % "ahk_exe " settings.quickpob.exe.2
		SendEvent, {Control down}
		SendEvent, {3}
		SendEvent, {Control up}
		Gui, snip: New, % "-DPIScale +LastFound -Caption +AlwaysOnTop +ToolWindow +E0x02000000 +E0x00080000 HWNDhwnd_snip"
		Gui, snip: Color, Aqua
		WinSet, Trans, 100
		Gui, snip: Show, NA w23 h23

		Gui, zoom: New, -Caption +E0x80000 +E0x20 +LastFound +AlwaysOnTop +ToolWindow +OwnDialogs +Border HWNDzoom
		Gui, zoom: Show, NA

		While GetKeyState("LButton", "P")
		{
			pBitmap := Gdip_BitmapFromScreen(vars.general.xMouse - 9 "|" vars.general.yMouse - 9 "|15|15" )
			hbmBitmap := CreateDIBSection(120, 120), hdcBitmap := CreateCompatibleDC(), obmBitmap := SelectObject(hdcBitmap, hbmBitmap), gBitmap := Gdip_GraphicsFromHDC(hdcBitmap)
			Gdip_SetInterpolationMode(gBitmap, 5), Gdip_DrawImage(gBitmap, pBitmap, 0, 0, 120, 120, 0, 0, 15, 15), UpdateLayeredWindow(zoom, hdcBitmap, vars.general.xMouse + 64, vars.general.yMouse + 64, 120, 120)
			Gdip_DisposeImage(pBitmap), SelectObject(hdcBitmap, obmBitmap), DeleteObject(hbmBitmap), DeleteDC(hdcBitmap), Gdip_DeleteGraphics(gBitmap)

			Gui, snip: Show, % "NA x" vars.general.xMouse - 7 " y" vars.general.yMouse - 7
			Sleep, 50
		}
		WinGetPos, xPob, yPob, wPob, hPob, % "ahk_exe " settings.quickpob.exe.2
		WinGetPos, xSnip, ySnip, wSnip, hSnip, % "ahk_id " hwnd_snip
		IniWrite, % (settings.quickpob.snip_offset := xSnip - (xPob + vars.system.xborder)), % "ini" vars.poe_version "\qol tools.ini", quickpob, snip offset
		Gui, snip: Destroy
		Gui, zoom: Destroy
		QuickPob_Gui("flush")
		GuiControl, % "+cLime", % vars.hwnd.settings.quickpob_snip_label
		GuiControl, % "movedraw", % vars.hwnd.settings.quickpob_snip_label
		WinActivate, % "ahk_id " vars.hwnd.poe_client
	}
	Else If RegexMatch(check, "i)quickpob_(alt|ctrl)")
	{
		input := vars.settings["quickpob_" control "_provisional"] := !vars.settings["quickpob_" control "_provisional"], other := (control = "alt" ? "ctrl" : "alt")
		modified := (input . vars.settings["quickpob_" other "_provisional"] != settings.quickpob["hotkey_" control] . settings.quickpob["hotkey_" other])
		GuiControl, % "+c" (input ? "Lime" : "Gray"), % cHWND
		GuiControl, % "movedraw", % cHWND
		GuiControl, % (modified ? "-" : "+") "Hidden", % vars.hwnd.settings.quickpob_save
		GuiControl, % (modified ? "-" : "+") "Hidden", % vars.hwnd.settings.quickpob_save_bar
	}
	Else If RegExMatch(check, "i)quickpob_(full|compact)")
	{
		IniWrite, % (settings.quickpob.mode := control), % "ini" vars.poe_version "\qol tools.ini", quickpob, mode
		other := (control = "full" ? "compact" : "full")
		GuiControl, % "+cLime", % cHWND
		GuiControl, % "movedraw", % cHWND
		GuiControl, % "+cWhite", % vars.hwnd.settings["quickpob_" other]
		GuiControl, % "movedraw", % vars.hwnd.settings["quickpob_" other]
	}
	Else LLK_ToolTip("no action")
}

Settings_runeshaping()
{
	local
	global vars, settings
	static fSize, wOnOff

	GUI := "settings_menu" vars.settings.GUI_toggle, x_anchor := vars.settings.x_anchor

	Gui, %GUI%: Add, Text, % "Section x" x_anchor " y" vars.settings.ySelection " Border BackgroundTrans gSettings_runeshaping2 HWNDhwnd" (settings.features.runeshaping ? " cLime" : " cGray"), % " " Lang_Trans("global_enable") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.enable := hwnd, vars.hwnd.help_tooltips["settings_runeshaping enable"] := hwnd1

	Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans HWNDhwnd gURL cAqua", % " wiki page "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.URLs := {}, vars.URLs[hwnd] := "https://github.com/Lailloken/Exile-UI/wiki/Rune‐Ninja", vars.hwnd.help_tooltips["settings_website"] := hwnd1

	If !settings.features.runeshaping
		Return

	If (fSize != settings.general.fSize)
	{
		fSize := settings.general.fSize
		LLK_PanelDimensions([Lang_Trans("global_on"), Lang_Trans("global_off")], fSize, wOnOff, hOnOff)
	}

	Gui, %GUI%: Font, underline bold
	Gui, %GUI%: Add, Text, % "xs Section y+" vars.settings.spacing, % Lang_Trans("global_general")
	Gui, %GUI%: Font, norm

	Gui, %GUI%: Add, Text, % "Section xs Border BackgroundTrans", % " " Lang_Trans("global_league") . Lang_Trans("global_colon") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border Background404040 cBlack", 100
	Gui, %GUI%: Add, Text, % "ys x+-1 HWNDhwnd cLime Border BackgroundTrans gSettings_runeshaping2", % " " Lang_Trans("global_league_" settings.general.league.1) " " Lang_Trans("global_league_" settings.general.league[vars.poe_version ? 3 : 4]) " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp HWNDhwnd1 Border Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.league_select := hwnd, vars.hwnd.help_tooltips["settings_league selection other"] := hwnd1

	Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans", % " " Lang_Trans("global_hold_ctrl") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border Background404040 cBlack", 100
	Gui, %GUI%: Add, Text, % "ys x+-1 w" wOnOff " Border BackgroundTrans HWNDhwnd Center gSettings_runeshaping2" (settings.runeshaping.hold_ctrl ? " cLime" : " cGray"), % Lang_Trans("global_" (settings.runeshaping.hold_ctrl ? "on" : "off"))
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.hold_ctrl := hwnd, vars.hwnd.help_tooltips["settings_runeshaping hold ctrl"] := hwnd1

	Gui, %GUI%: Add, Text, % "Section xs Border BackgroundTrans HWNDhwnd gSettings_runeshaping2" (settings.runeshaping.debug ? " cLime" : " cGray"), % " " Lang_Trans("global_troubleshoot") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.debug := hwnd, vars.hwnd.help_tooltips["settings_runeshaping debug"] := hwnd1

	If settings.runeshaping.debug
	{
		Gui, %GUI%: Add, Text, % "Section xs y+0 w2 h" vars.settings.line1 " Border HWNDhwnd_brace"
		Gui, %GUI%: Add, Text, % "Section ys y+0 w" settings.general.fWidth * 36 - 2 " Center Border BackgroundTrans", % Lang_Trans("m_runeshaping_correction")
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd Background404040 cBlack", 100
		Gui, %GUI%: Font, % "s" settings.general.fSize - 4
		vars.hwnd.help_tooltips["settings_runeshaping dictionary"] := hwnd

		Gui, %GUI%: Add, Button, % "Hidden ys hp Default HWNDhwnd gSettings_runeshaping2", ok
		vars.hwnd.settings.ok := hwnd, count := 0

		For index, array in (settings.runeshaping.autocorrect.Count() ? settings.runeshaping.autocorrect : [["", ""]])
			Loop, % (index = settings.runeshaping.autocorrect.MaxIndex() && settings.runeshaping.autocorrect.Count() ? 2 : 1)
			{
				Gui, %GUI%: Add, Text, % "Section xs y+-1 w" settings.general.fWidth * 2 " hp Center 0x200 Border BackgroundTrans", % count + 1
				Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border Background404040 cBlack", 100
				Gui, %GUI%: Add, Text, % "ys x+-1 w" settings.general.fWidth * 17 " hp Border BackgroundTrans"
				Gui, %GUI%: Add, Edit, % "xp yp wp hp Border cBlack HWNDhwnd Lowercase gSettings_runeshaping2", % (A_Index = 1 ? array.1 : "")
				Gui, %GUI%: Add, Text, % "ys x+-1 wp hp Border BackgroundTrans"
				Gui, %GUI%: Add, Edit, % "xp yp wp hp Border cBlack HWNDhwnd1 gSettings_runeshaping2", % (A_Index = 1 ? array.2 : "")
				vars.hwnd.settings["acInput_" index + (A_Index - 1)] := vars.hwnd.help_tooltips["settings_runeshaping auto-correct input" ac_handle] := hwnd
				vars.hwnd.settings["acOutput_" index + (A_Index - 1)] := vars.hwnd.help_tooltips["settings_runeshaping auto-correct output" ac_handle] := hwnd1
				ac_handle .= "|", count += 1
			}
		Gui, %GUI%: Font, % "s" settings.general.fSize
		Gui, %GUI%: Add, Text, % "Section xs x" vars.settings.x_anchor " w" settings.general.fWidth * 25 " h2 Border HWNDhwnd"
		GuiControl, movedraw, % hwnd_brace, % "h" LLK_ControlGetPos(hwnd, "y") - LLK_ControlGetPos(hwnd_brace, "y")
	}

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "xs Section y+" vars.settings.spacing, % Lang_Trans("global_ui")
	Gui, %GUI%: Font, norm

	Gui, %GUI%: Add, Text, % "xs Section Border BackgroundTrans", % " " Lang_Trans("global_font") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border Background404040 cBlack", 100
	Gui, %GUI%: Add, Text, % "ys x+-1 Center Border BackgroundTrans gSettings_runeshaping2 HWNDhwnd w"settings.general.fWidth*2, % "–"
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp HWNDhwnd1 Border Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.help_tooltips["settings_font-size"] := hwnd0, vars.hwnd.settings.font_minus := hwnd, vars.hwnd.help_tooltips["settings_font-size|"] := hwnd1

	Gui, %GUI%: Add, Text, % "ys x+-1 Center Border BackgroundTrans gSettings_runeshaping2 HWNDhwnd w"settings.general.fWidth*3, % settings.runeshaping.fSize
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp HWNDhwnd1 Border Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.font_reset := hwnd, vars.hwnd.help_tooltips["settings_font-size||"] := hwnd1

	Gui, %GUI%: Add, Text, % "ys x+-1 Center Border BackgroundTrans gSettings_runeshaping2 HWNDhwnd w"settings.general.fWidth*2, % "+"
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp HWNDhwnd1 Border Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.font_plus := hwnd, vars.hwnd.help_tooltips["settings_font-size|||"] := hwnd1

	Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans", % " " Lang_Trans("global_color", 2) " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border Background404040 cBlack", 100
	For index, val in ["high", "stack", "unknown"]
	{
		Gui, %GUI%: Add, Text, % "ys x+-1 w" settings.general.fWidth " hp gSettings_runeshaping2 Border BackgroundTrans HWNDhwnd"
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border BackgroundBlack HWNDhwnd1 c" settings.runeshaping["color_" val], 100

		vars.hwnd.settings["pricecolor_" val] := hwnd, vars.hwnd.settings["pricecolor_" val "_bar"] := vars.hwnd.help_tooltips["settings_runeshaping color " val] := hwnd1
	}
}

Settings_runeshaping2(cHWND := "")
{
	local
	global vars, settings

	check := LLK_HasVal(vars.hwnd.settings, cHWND), control := SubStr(check, InStr(check, "_") + 1)
	If !InStr(check, "font_")
	{
		KeyWait, LButton
		KeyWait, RButton
		KeyWait, Enter
	}

	Switch
	{
		Case (check = "enable"):
		IniWrite, % (settings.features.runeshaping := !settings.features.runeshaping), % "ini" vars.poe_version "\config.ini", features, enable rune-ninja
		Settings_menu("runeshaping")
		;######################################################
		Case (check = "debug"):
		IniWrite, % (settings.runeshaping.debug := !settings.runeshaping.debug), % "ini" vars.poe_version "\rune-ninja.ini", settings, enable trouble-shooting
		If !settings.runeshaping.debug && WinExist("OCR debug")
			WinClose, OCR debug
		Settings_menu("runeshaping")
		;######################################################
		Case (check = "ok"):
		For outer in [1, 2]
			For key, hwnd in vars.hwnd.settings
				If InStr(key, "acInput_")
				{
					index := SubStr(key, InStr(key, "_") + 1), input := LLK_ControlGet(hwnd), output := LLK_ControlGet(vars.hwnd.settings["acOutput_" index])
					If (Blank(input) + Blank(output) = 1)
					{
						WinGetPos, xPos, yPos, width, height, % "ahk_id " vars.hwnd.settings["acOutput_" index]
						LLK_ToolTip("<- " Lang_Trans("global_errorname", 2),, xPos + width, yPos,, "FF8000")
						Return
					}
					Else If (outer = 1)
						Continue
					If Blank(input . output) && !Blank(settings.runeshaping.autocorrect[index].1 . settings.runeshaping.autocorrect[index].2)
					{
						IniDelete, % "ini" vars.poe_version "\rune-ninja.ini", autocorrect, % index
						settings.runeshaping.autocorrect.Delete(index), edited := 1
					}
					Else If (input != settings.runeshaping.autocorrect[index].1 || output != settings.runeshaping.autocorrect[index].2)
					{
						If !IsObject(settings.runeshaping.autocorrect[index])
							settings.runeshaping.autocorrect[index] := []
						IniWrite, % """" (settings.runeshaping.autocorrect[index].1 := input) "§" (settings.runeshaping.autocorrect[index].2 := output) """", % "ini" vars.poe_version "\rune-ninja.ini", autocorrect, % index
						edited := 1
					}
				}
		If edited
			Settings_menu("runeshaping")
		;######################################################
		Case RegexMatch(check, "i)ac(in|out)put_"):
		input := LLK_ControlGet(cHWND), index := SubStr(check, InStr(check, "_") + 1), type := (InStr(check, "in") ? 1 : 2)
		GuiControl, % "+c" (input != settings.runeshaping.autocorrect[index][type] ? "FF8111" : "Black"), % cHWND
		GuiControl, % "movedraw", % cHWND
		;######################################################
		Case (check = "league_select"):
		Settings_menu("general")
		;######################################################
		Case (check = "hold_ctrl"):
		IniWrite, % (settings.runeshaping.hold_ctrl := !settings.runeshaping.hold_ctrl), % "ini" vars.poe_version "\rune-ninja.ini", settings, hold down ctrl-key
		GuiControl, % "+c" (settings.runeshaping.hold_ctrl ? "Lime" : "Gray"), % cHWND
		GuiControl, % "Text", % cHWND, % Lang_Trans("global_" (settings.runeshaping.hold_ctrl ? "on" : "off"))
		GuiControl, % "movedraw", % cHWND
		;######################################################
		Case InStr(check, "pricecolor_"):
		RGB := (vars.system.click = 2 ? settings.runeshaping.colors_default[control] : RGB_Picker(settings.runeshaping["color_" control]))
		If Blank(RGB)
			Return
		IniWrite, % """" (settings.runeshaping["color_" control] := RGB) """", % "ini" vars.poe_version "\rune-ninja.ini", settings, % "color " control
		GuiControl, % "+c" RGB, % vars.hwnd.settings["pricecolor_" control "_bar"]
		;######################################################
		Case InStr(check, "font_"):
		While GetKeyState("LButton", "P")
		{
			If (control = "reset")
				settings.runeshaping.fSize := settings.general.fSize
			Else settings.runeshaping.fSize += (control = "plus") ? 1 : (settings.runeshaping.fSize > 6 ? -1 : 0)
			GuiControl, Text, % vars.hwnd.settings.font_reset, % settings.runeshaping.fSize
			Sleep 200
		}
		IniWrite, % settings.runeshaping.fSize, % "ini" vars.poe_version "\rune-ninja.ini", settings, font-size
		LLK_FontDimensions(settings.runeshaping.fSize, fHeight, fWidth), settings.runeshaping.fWidth := fWidth, settings.runeshaping.fHeight := fHeight
		;######################################################
		Case check:
		LLK_ToolTip("no action")
	}
}

Settings_sanctum()
{
	local
	global vars, settings

	GUI := "settings_menu" vars.settings.GUI_toggle, x_anchor := vars.settings.x_anchor

	Gui, %GUI%: Add, Text, % "Section x" x_anchor " y" vars.settings.ySelection " Border BackgroundTrans gSettings_sanctum2 HWNDhwnd" (settings.features.sanctum ? " cLime" : " cGray"), % " " Lang_Trans("global_enable") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.enable := hwnd, vars.hwnd.help_tooltips["settings_sanctum enable"] := hwnd1

	Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans HWNDhwnd gURL cAqua", % " wiki page "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.URLs := {}, vars.URLs[hwnd] := "https://github.com/Lailloken/Exile-UI/wiki/Sanctum-and-Sekhema-Planner", vars.hwnd.help_tooltips["settings_website"] := hwnd1

	If !settings.features.sanctum
		Return

	Gui, %GUI%: Font, underline bold
	Gui, %GUI%: Add, Text, % "xs Section y+" vars.settings.spacing, % Lang_Trans("global_general")
	Gui, %GUI%: Font, norm

	Gui, %GUI%: Add, Text, % "Section xs Border BackgroundTrans", % " " Lang_Trans("global_font") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border Background404040 cBlack", 100
	Gui, %GUI%: Add, Text, % "ys x+-1 Center Border BackgroundTrans gSettings_sanctum2 HWNDhwnd w"settings.general.fWidth*2, % "–"
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.help_tooltips["settings_font-size"] := hwnd0, vars.hwnd.settings.font_minus := hwnd, vars.hwnd.help_tooltips["settings_font-size|"] := hwnd1

	Gui, %GUI%: Add, Text, % "ys x+-1 Center Border BackgroundTrans gSettings_sanctum2 HWNDhwnd w"settings.general.fWidth*3, % settings.sanctum.fSize
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.font_reset := hwnd, vars.hwnd.help_tooltips["settings_font-size||"] := hwnd1

	Gui, %GUI%: Add, Text, % "ys x+-1 Center Border BackgroundTrans gSettings_sanctum2 HWNDhwnd w"settings.general.fWidth*2, % "+"
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.font_plus := hwnd, vars.hwnd.help_tooltips["settings_font-size|||"] := hwnd1

	Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans HWNDhwnd gSettings_sanctum2" (settings.sanctum.relics ? " cLime" : " cGray"), % " " Lang_Trans("m_sanctum_relicmanager") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.relics := hwnd, vars.hwnd.help_tooltips["settings_sanctum relics"] := hwnd1

	If !vars.poe_version
	{
		Gui, %GUI%: Add, Text, % "Section xs Border BackgroundTrans HWNDhwnd gSettings_sanctum2" (settings.sanctum.cheatsheet ? " cLime" : " cGray"), % " " Lang_Trans("m_sanctum_cheatsheet") " "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings.cheatsheet := hwnd, vars.hwnd.help_tooltips["settings_sanctum cheatsheet"] := hwnd1
	}
}

Settings_sanctum2(cHWND := "")
{
	local
	global vars, settings

	check := LLK_HasVal(vars.hwnd.settings, cHWND), control := SubStr(check, InStr(check, "_") + 1)
	If !InStr(check, "font_")
		KeyWait, LButton

	If (check = "enable")
	{
		IniWrite, % (settings.features.sanctum := !settings.features.sanctum), % "ini" vars.poe_version "\config.ini", features, enable sanctum planner
		Settings_menu("sanctum")
	}
	Else If (check = "cheatsheet")
	{
		IniWrite, % (settings.sanctum.cheatsheet := !settings.sanctum.cheatsheet), % "ini" vars.poe_version "\sanctum.ini", settings, enable cheat-sheet
		vars.hwnd.sanctum.uptodate := 0
		GuiControl, % "+c" (settings.sanctum.cheatsheet ? "Lime" : "Gray"), % cHWND
		GuiControl, % "movedraw", % cHWND
		If WinExist("ahk_id " vars.hwnd.sanctum.second)
			Sanctum()
	}
	Else If (check = "relics")
	{
		IniWrite, % (settings.sanctum.relics := !settings.sanctum.relics), % "ini" vars.poe_version "\sanctum.ini", settings, enable relic management
		If !settings.sanctum.relics && WinExist("ahk_id " vars.hwnd.sanctum_relics.main)
			Sanctum_Relics("close")
		GuiControl, % "+c" (settings.sanctum.relics ? "Lime" : "Gray"), % cHWND
		GuiControl, % "movedraw", % cHWND
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
		IniWrite, % settings.sanctum.fSize, % "ini" vars.poe_version "\sanctum.ini", settings, font-size
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

	GUI := "settings_menu" vars.settings.GUI_toggle, x_anchor := vars.settings.x_anchor, slop := settings.general.slop, cButtons := settings.general.cButtons, fWidth := settings.general.fWidth
	hwnd := Gui_Label(GUI, "Section x" x_anchor " y" vars.settings.ySelection " gURL cAqua", " wiki page ", "settings_website",, slop,,, cButtons), vars.URLs := {(hwnd.text): "https://github.com/Lailloken/Exile-UI/wiki/Screen-checks"}

	For key in (active_pixel := Settings_ScreenChecksValid("pixel").1)
	{
		If !header_pixel
		{
			Gui, %GUI%: Font, % "underline bold"
			Gui, %GUI%: Add, Text, % "xs Section y+"vars.settings.spacing " BackgroundTrans", % Lang_Trans("m_screen_pixel")
			Gui, %GUI%: Add, Pic, % "ys hp w-1 BackgroundTrans HWNDhwnd", % "HBitmap:*" vars.pics.global.help
			Gui, %GUI%: Font, % "norm"
			vars.hwnd.help_tooltips["settings_screenchecks pixel-about"] := hwnd, header_pixel := 1
		}
		Gui_Label(GUI, "Section xs gSettings_screenchecks2", " " Lang_Trans("global_info") " ", "settings_screenchecks pixel-info" handle, "hwnd.settings.info_" key, [slop, 0, slop, 0],,, cButtons)
		Gui_Label(GUI, "ys x+0 gSettings_screenchecks2" (!vars.pixelsearch[key].color1 ? " cRed" : ""), " " Lang_Trans("global_calibrate") " ", "settings_screenchecks pixel-calibration" handle, "hwnd.settings.cPixel_" key,,,, cButtons)
		Gui_Label(GUI, "ys x+0 gSettings_screenchecks2", " " Lang_Trans("global_test") " ", "settings_screenchecks pixel-test" handle, "hwnd.settings.tPixel_" key, [0, slop, 0, slop],,, cButtons), handle .= "|"
		Gui, %GUI%: Add, Text, % "ys BackgroundTrans", % Lang_Trans((key = "inventory" ? "global_" : "m_screen_") key)
	}

	If vars.client.stream && active_pixel.Count()
	{
		Gui_Label(GUI, "Section xs", " " Lang_Trans("global_variance") " ", "settings_screenchecks variance",, [slop, 0, slop, 0])
		Gui_Label(GUI, "ys x+0 w" 4*fWidth,, "settings_screenchecks variance input",, [0, slop, 0, slop],,, "0x01000000")
		Gui, %GUI%: Font, % "s" settings.general.fSize - 2
		Gui, %GUI%: Add, Edit, % "xp yp wp hp Center Border Number Limit3 cBlack gSettings_screenchecks2 HWNDhwnd", % vars.pixelsearch.variation
		Gui, %GUI%: Font, % "s" settings.general.fSize
	}

	For key in (active_image := Settings_ScreenChecksValid("image").1)
	{
		If !header_image
		{
			Gui, %GUI%: Font, bold underline
			Gui, %GUI%: Add, Text, % "xs Section BackgroundTrans y+"vars.settings.spacing, % Lang_Trans("m_screen_image")
			Gui, %GUI%: Add, Pic, % "ys hp w-1 BackgroundTrans HWNDhwnd", % "HBitmap:*" vars.pics.global.help
			Gui, %GUI%: Font, norm
			vars.hwnd.help_tooltips["settings_screenchecks image-about"] := hwnd, handle := "", header_image := 1
		}
		Gui_Label(GUI, "Section xs gSettings_screenchecks2", " " Lang_Trans("global_info") " ", "settings_screenchecks image-info" handle, "hwnd.settings.info_" key, [slop, 0, slop, 0],,, cButtons)
		color := (!FileExist("img\Recognition (" vars.client.h "p)\GUI\" key . vars.poe_version ".bmp") ? " cRed" : "")
		Gui_Label(GUI, "ys x+0 gSettings_screenchecks2" color, " " Lang_Trans("global_calibrate") " ", "settings_screenchecks image-calibration" handle, "hwnd.settings.cImage_" key,,,, cButtons)
		Gui_Label(GUI, "ys x+0 gSettings_screenchecks2" (Blank(vars.imagesearch[key].x1) ? " cRed" : ""), " " Lang_Trans("global_test") " ", "settings_screenchecks image-test" handle, "hwnd.settings.tImage_" key, [0, slop, 0, slop],,, cButtons), handle .= "|"
		Gui, %GUI%: Add, Text, % "ys hp 0x200 BackgroundTrans", % Lang_Trans((RegExMatch(key, "i)sanctum|async|runeshaping|tradesearch") ? "m_screen_" : (key = "betrayal" ? "mechanic_" : "global_")) key, (key = "sanctum" ? vars.poe_version : ""))
	}

	If active_image.Count()
	{
		Gui_Label(GUI, "Section xs gSettings_screenchecks2", " " Lang_Trans("global_imgfolder") " ", "settings_screenchecks folder", "hwnd.settings.folder", slop,,, cButtons)
		If vars.client.stream
		{
			Gui_Label(GUI, "ys", " " Lang_Trans("global_variance") " ", "settings_screenchecks variance|",, [slop, 0, slop, 0])
			Gui_Label(GUI, "ys x+0 w" 4*fWidth " Center",, "settings_screenchecks variance input|",, [0, slop, 0, slop],,, "0x01000000")
			Gui, %GUI%: Font, % "s" settings.general.fSize - 2
			Gui, %GUI%: Add, Edit, % "xp yp wp hp Center Number Limit3 cBlack gSettings_screenchecks2 HWNDhwnd", % vars.imagesearch.variation
			Gui, %GUI%: Font, % "s" settings.general.fSize
			vars.hwnd.settings.variance_image := hwnd
		}
	}
	Else If !(active_pixel.Count() + active_image.Count())
		Gui, %GUI%: Add, Text, % "Section xs cLime y+" vars.settings.spacing " w" settings.general.fWidth * vars.settings.min_width, % Lang_Trans("m_screen_inactive")
}

Settings_screenchecks2(cHWND := "")
{
	local
	global vars, settings

	check := LLK_HasVal(vars.hwnd.settings, cHWND), control := SubStr(check, InStr(check, "_") + 1)
	If (check = 0)
		check := A_GuiControl

	If !InStr(check, "info_") && !RegexMatch(check, "i)cPixel_(gamescreen|close_button)")
		KeyWait, LButton

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
						start := A_TickCount
						While vars.poe_version && InStr("gamescreen, close_button", control) && !longpress && GetKeyState("LButton", "P")
							If (A_TickCount >= start + 250)
								longpress := 1

						If vars.poe_version && InStr("gamescreen, close_button", control)
						{
							If longpress
								result := Screenchecks_PixelRecalibrate2(control)
							Else
							{
								LLK_ToolTip(Lang_Trans("m_screen_instructions"), 2,,,, "Red")
								Return
							}
						}
						Else result := Screenchecks_PixelRecalibrate(control)
						LLK_ToolTip(Lang_Trans("global_" (result ? "success" : "fail")),,,,, (result ? "lime" : "red")), Settings_ScreenChecksValid()
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
							If vars.pics.screen_checks[control]
								DeleteObject(vars.pics.screen_checks[control])
							vars.pics.screen_checks[control] := Gdip_CreateHBITMAPFromBitmap(pClipboard, 0)
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

Settings_ScreenChecksValid(type := "")
{
	local
	global vars, settings

	valid := 1, active_pixel := {}, active_image := {}
	For key, val in vars.pixelsearch.list
		If (key = "gamescreen") && !vars.cloneframes.gamescreen
		|| (key = "close_button") && !(vars.cloneframes.enabled && settings.cloneframes.closebutton_toggle)
		|| (key = "inventory") && !(vars.cloneframes.inventory || settings.features.iteminfo * (settings.iteminfo.compare + settings.iteminfo.trigger) || settings.features.exchange || settings.features.sanctum * settings.sanctum.relics || settings.features.mapinfo * settings.mapinfo.trigger)
			Continue
		Else valid *= vars.pixelsearch[key].color1 ? 1 : 0, active_pixel[key] := 1

	If (type = "pixel")
		Return [active_pixel, valid]

	For key, val in vars.imagesearch.list
		If (key = "skilltree" && !settings.features.leveltracker) || (key = "stash" && !(settings.features.maptracker * settings.maptracker.loot))
		|| (key = "atlas") && !settings.features.statlas || RegexMatch(key, "i)betrayal|exchange|sanctum") && !settings.features[key] || InStr(key, "async") && !settings.features.async
		|| InStr(key, "runeshaping") && (!settings.features.runeshaping || InStr(key, "2") && (settings.general.input_method = 1) || !InStr(key, "2") && (settings.general.input_method = 2))
		|| (key = "tradesearch") && !settings.qol.quickpob
			Continue
		Else valid *= !Blank(vars.imagesearch[key].x1) && FileExist("img\Recognition (" vars.client.h "p)\GUI\" key . vars.poe_version ".bmp") ? 1 : 0, active_image[key] := 1

	If (type = "image")
		Return [active_image, valid]

	GuiControl, % (!valid ? "+" : "-") "Hidden", % vars.hwnd.settings["background_screen-checks"]
}

Settings_searchstrings()
{
	local
	global vars, settings
	static fSize, wList, listcount, wHotkey

	GUI := "settings_menu" vars.settings.GUI_toggle, x_anchor := vars.settings.x_anchor
	If (fSize != settings.general.fSize || listcount != vars.searchstrings.list.Count())
	{
		fSize := settings.general.fSize, dimensions := [], listcount := vars.searchstrings.list.Count()
		For string, val in vars.searchstrings.list
			If !InStr(string, "_")
				dimensions.Push(Lang_Trans("m_search_" string) ? Lang_Trans("m_search_" string) : string)
		LLK_PanelDimensions(dimensions, fSize, wList, hList)
		LLK_PanelDimensions([Lang_Trans("global_hotkey"), Lang_Trans("global_save")], fSize, wHotkey, hHotkey)
	}

	Gui, %GUI%: Add, Text, % "Section x" x_anchor " y" vars.settings.ySelection " Border BackgroundTrans HWNDhwnd gURL cAqua", % " wiki page "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.URLs := {}, vars.URLs[hwnd] := "https://github.com/Lailloken/Exile-UI/wiki/Search-strings", vars.hwnd.help_tooltips["settings_website"] := hwnd1

	Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans HWNDhwnd gURL cAqua", % " poe.re "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.URLs[hwnd] := "https://poe" StrReplace(vars.poe_version, " ") ".re", vars.hwnd.help_tooltips["settings_searchstrings poe-regex"] := hwnd1

	Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans HWNDhwnd gURL cAqua", % " ahk: key list "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.URLs[hwnd] := "https://www.autohotkey.com/docs/v1/KeyList.htm", vars.hwnd.help_tooltips["settings_website|"] := hwnd1

	For string, val in vars.searchstrings.list
	{
		If InStr(string, "_")
			Continue
		If (A_Index = 1)
		{
			Gui, %GUI%: Font, bold underline
			Gui, %GUI%: Add, Text, % "xs Section BackgroundTrans y+"vars.settings.spacing, % Lang_Trans("m_search_usecases")
			Gui, %GUI%: Add, Pic, % "ys hp w-1 BackgroundTrans HWNDhwnd69", % "HBitmap:*" vars.pics.global.help
			Gui, %GUI%: Font, norm
			vars.hwnd.help_tooltips["settings_searchstrings about"] := hwnd69
		}
		var := vars.searchstrings.list[string]
		Gui, %GUI%: Add, Text, % "Section xs w" wList " Border BackgroundTrans gSettings_searchstrings2 HWNDhwnd c" (var.enable ? "Lime" : "Gray"), % " " (Lang_Trans("m_search_" string) ? Lang_Trans("m_search_" string) : string)
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings["enable_"string] := hwnd, vars.hwnd.help_tooltips["settings_searchstrings enable" (string = "hideout lilly" ? "-lilly" : (string = "beast crafting" ? "-beastcrafting" : "")) handle] := hwnd1

		color := (!var.enable ? "Gray" : (!FileExist("img\Recognition (" vars.client.h "p)\GUI\[search-strings" vars.poe_version "] " string ".bmp") ? "Red" : "White"))
		style := " x+" settings.general.fWidth/4 . (!var.enable ? "" : " gSettings_searchstrings2")
		Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans HWNDhwnd c"color style, % " " Lang_Trans("global_calibrate") " "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings["cal_"string] := hwnd, vars.hwnd.help_tooltips["settings_searchstrings calibrate"handle] := hwnd1

		color := !var.enable ? "Gray" : !var.x1 ? "Red" : "White"
		Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans HWNDhwnd c"color style, % " " Lang_Trans("global_test") " "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings["test_"string] := hwnd, vars.hwnd.help_tooltips["settings_searchstrings test"handle] := hwnd1

		Gui, %GUI%: Add, Text, % "ys x+" settings.general.fWidth/4 " Border BackgroundTrans gSettings_searchstrings2 HWNDhwnd", % " " Lang_Trans("global_edit") " "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings["edit_"string] := hwnd, vars.hwnd.help_tooltips["settings_searchstrings edit"handle] := hwnd1

		Gui, %GUI%: Add, Text, % "ys x+" settings.general.fWidth/4 " Border BackgroundTrans HWNDhwnd c"(string = "beast crafting" ? "Gray" : "White") . (string = "beast crafting" ? "" : " gSettings_searchstrings2"), % " x "
		Gui, %GUI%: Add, Progress, % "xp yp wp hp Disabled range0-500 Vertical HWNDhwnd1 Border Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 500
		vars.hwnd.settings["del_"string] := hwnd, vars.hwnd.settings["delbar_"string] := vars.hwnd.help_tooltips["settings_searchstrings delete"handle] := hwnd1

		Gui, %GUI%: Add, Text, % "ys x+" settings.general.fWidth/4 " Border BackgroundTrans gSettings_searchstrings2 HWNDhwnd", % " " Lang_Trans("global_copy") " "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings["copy_" string] := hwnd, vars.hwnd.help_tooltips["settings_searchstrings copy" handle] := hwnd1, handle .= "|"
	}

	Gui, %GUI%: Add, Text, % "Section xs Border BackgroundTrans HWNDhwnd0", % " " Lang_Trans("m_search_add") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border Background404040 cBlack", 100
	Gui, %GUI%: Add, Button, % "xp yp wp hp Hidden default HWNDhwnd gSettings_searchstrings2", ok
	vars.hwnd.help_tooltips["settings_searchstrings add"] := hwnd0, vars.hwnd.settings.add := hwnd, width := (xMax := LLK_ControlGetPos(hwnd1).xMax) - LLK_ControlGetPos(hwnd0).xMax + 1
	Gui, %GUI%: Font, % "s"settings.general.fSize - 4
	Gui, %GUI%: Add, Text, % "ys x+-1 w" width " h" settings.general.fHeight " Border BackgroundTrans HWNDhwnd"
	Gui, %GUI%: Add, Edit, % "xp yp wp hp Border cBlack HWNDhwnd"
	If !(vars.searchstrings.list.Count() > 1)
	{
		Gui, %GUI%: Add, Pic, % "ys hp w-1 BackgroundTrans HWNDhwnd69", % "HBitmap:*" vars.pics.global.help
		vars.hwnd.help_tooltips["settings_searchstrings about"] := hwnd69
	}
	vars.hwnd.settings.name := vars.hwnd.help_tooltips["settings_searchstrings add|"] := hwnd
	Gui, %GUI%: Font, % "s" settings.general.fSize
	GuiControl, % "+c" (!vars.searchstrings.enabled ? "Gray" : "White"), % vars.hwnd.settings["search-strings"]
	GuiControl, % "movedraw", % vars.hwnd.settings["search-strings"]

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "Section xs y+" vars.settings.spacing, % Lang_Trans("m_search_universal")
	Gui, %GUI%: Add, Pic, % "ys hp w-1 BackgroundTrans HWNDhwnd", % "HBitmap:*" vars.pics.global.help
	Gui, %GUI%: Font, norm
	Gui, %GUI%: Add, Text, % "Section xs Border BackgroundTrans gSettings_searchstrings2 HWNDhwnd1", % " " Lang_Trans("m_search_edit") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd4 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	Gui, %GUI%: Add, Text, % "Hidden ys w" wHotkey " Border BackgroundTrans Center cRed HWNDhwnd3 gSettings_searchstrings2", % Lang_Trans("global_save")
	Gui, %GUI%: Add, Progress, % "Hidden Disabled xp yp wp hp Border HWNDhwnd31 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	Gui, %GUI%: Add, Text, % "xp yp wp hp Right Border BackgroundTrans HWNDhwnd0", % Lang_Trans("global_hotkey") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border Background404040 cBlack", 100
	Gui, %GUI%: Font, % "s" settings.general.fSize - 4
	Gui, %GUI%: Add, Text, % "ys x+-1 w" xMax - LLK_ControlGetPos(hwnd0).xMax + 1 " hp Border BackgroundTrans"
	Gui, %GUI%: Add, Edit, % "xp yp wp hp Border cBlack HWNDhwnd2 gSettings_searchstrings2", % settings.searchstrings.universal_hotkey
	Gui, %GUI%: Font, % "s" settings.general.fSize
	vars.hwnd.help_tooltips["settings_searchstrings universal"] := hwnd, vars.hwnd.settings.universal_bind := vars.hwnd.help_tooltips["settings_hotkeys formatting"] := hwnd2
	vars.hwnd.settings.universal_save := hwnd3, vars.hwnd.settings.universal_save_bar := hwnd31
	vars.hwnd.settings["edit_universal_search-strings"] := hwnd1, vars.hwnd.help_tooltips["settings_searchstrings edit" handle] := hwnd4
}

Settings_searchstrings2(cHWND)
{
	local
	global vars, settings

	check := LLK_HasVal(vars.hwnd.settings, cHWND), control := SubStr(check, InStr(check, "_") + 1)
	If !InStr(check, "del_")
		KeyWait, LButton

	If InStr(check, "cal_")
	{
		pBitmap := Screenchecks_ImageRecalibrate()
		If (pBitmap > 0)
		{
			If vars.pics.search_strings[control]
				DeleteObject(vars.pics.search_strings[control])
			vars.pics.search_strings[control] := Gdip_CreateHBITMAPFromBitmap(pBitmap, 0)
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
		If (vars.system.click = 1) && LLK_Progress(vars.hwnd.settings["delbar_"control], "LButton",,, 500, "Red", vars.settings.cButtons)
		{
			IniDelete, % "ini" vars.poe_version "\search-strings.ini", searches, % control
			IniDelete, % "ini" vars.poe_version "\search-strings.ini", % control
			FileDelete, % "img\Recognition (" vars.client.h "p)\GUI\[search-strings" vars.poe_version "] " control ".bmp"
			Settings_menu("search-strings")
		}
		Else Return
	}
	Else If InStr(check, "enable_")
	{
		IniWrite, % (vars.searchstrings.list[control].enable := !vars.searchstrings.list[control].enable), % "ini" vars.poe_version "\search-strings.ini", searches, % control
		Settings_menu("search-strings")
	}
	Else If (check = "add") || InStr(check, "copy_")
	{
		name := Trim(LLK_ControlGet(vars.hwnd.settings.name), " ")
		WinGetPos, x, y, w, h, % "ahk_id "vars.hwnd.settings.name
		If (name = "searches")
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
	Else If (check = "universal_bind")
	{
		input := LLK_ControlGet(cHWND)
		GuiControl, % (input != settings.searchstrings.universal_hotkey ? "-" : "+") "Hidden", % vars.hwnd.settings.universal_save
		GuiControl, % (input != settings.searchstrings.universal_hotkey ? "-" : "+") "Hidden", % vars.hwnd.settings.universal_save_bar
	}
	Else If (check = "universal_save")
	{
		input := Trim(LLK_ControlGet(vars.hwnd.settings.universal_bind), " ")
		If !Blank(input) && !Hotkeys_Convert(input)
		{
			LLK_ToolTip(Lang_Trans("m_hotkeys_error"),,,,, "Red")
			Return
		}
		Hotkey, IfWinActive, ahk_group poe_ahk_window
		If !Blank(settings.searchstrings.universal_hotkey)
			Hotkey, % Hotkeys_Convert(settings.searchstrings.universal_hotkey), String_Universal, Off
		If !Blank(input)
			Hotkey, % Hotkeys_Convert(settings.searchstrings.universal_hotkey := input), String_Universal, On
		IniWrite, % """" input """", % "ini" vars.poe_version "\search-strings.ini", universal_search-strings, hotkey_
		GuiControl, +Hidden, % vars.hwnd.settings.universal_save
		GuiControl, +Hidden, % vars.hwnd.settings.universal_save_bar
	}
	Else LLK_ToolTip("no action")
}

Settings_stash()
{
	local
	global vars, settings

	GUI := "settings_menu" vars.settings.GUI_toggle, x_anchor := vars.settings.x_anchor

	Gui, %GUI%: Add, Text, % "Section x" x_anchor " y" vars.settings.ySelection " Border BackgroundTrans gSettings_stash2 HWNDhwnd" (settings.features.stash ? " cLime" : " cGray"), % " " Lang_Trans("global_enable") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.enable := hwnd, vars.hwnd.help_tooltips["settings_stash enable"] := hwnd1

	Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans HWNDhwnd gURL cAqua", % " wiki page "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.URLs := {}, vars.URLs[hwnd] := "https://github.com/Lailloken/Exile-UI/wiki/Stash‐Ninja", vars.hwnd.help_tooltips["settings_website"] := hwnd1

	If !settings.features.stash
		Return

	Gui, %GUI%: Font, underline bold
	Gui, %GUI%: Add, Text, % "Section xs y+" vars.settings.spacing " h" settings.general.fHeight " 0x200", % Lang_Trans("global_general")
	Gui, %GUI%: Add, Button, % "xp yp wp hp Hidden Default HWNDhwnd gSettings_stash2", OK
	Gui, %GUI%: Font, norm
	vars.hwnd.settings.apply_button := hwnd

	Gui, %GUI%: Add, Text, % "Section xs Border BackgroundTrans", % " " Lang_Trans("global_league") . Lang_Trans("global_colon") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border Background404040 cBlack", 100
	Gui, %GUI%: Add, Text, % "ys x+-1 HWNDhwnd cLime Border BackgroundTrans gSettings_stash2", % " " Lang_Trans("global_league_" settings.general.league.1) " " Lang_Trans("global_league_" settings.general.league[vars.poe_version ? 3 : 4]) " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.league_select := hwnd, vars.hwnd.help_tooltips["settings_league selection other"] := hwnd1

	If vars.client.stream
	{
		Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans", % " " Lang_Trans("global_hotkey") " "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border Background404040 cBlack", 100
		Gui, %GUI%: Font, % "s" settings.general.fSize - 4
		Gui, %GUI%: Add, Text, % "ys x+-1 w" settings.general.fWidth * 6 " hp Border BackgroundTrans HWNDhwnd"
		Gui, %GUI%: Add, Edit, % "xp yp wp hp Border HWNDhwnd cBlack gSettings_stash2", % settings.stash.hotkey
		Gui, %GUI%: Font, % "s" settings.general.fSize
		vars.hwnd.settings.hotkey := vars.hwnd.help_tooltips["settings_stash hotkey"] := hwnd
	}

	Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans HWNDhwnd gSettings_stash2" (settings.stash.history ? " cLime" : " cGray"), % " " Lang_Trans("m_stash_pricehistory") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.history := hwnd, vars.hwnd.help_tooltips["settings_stash history"] := hwnd1

	Gui, %GUI%: Add, Text, % "Section xs Border BackgroundTrans HWNDhwnd gSettings_stash2" (settings.stash.use_global ? " cLime" : " cGray"), % " " Lang_Trans("m_stash_globalprofiles") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.use_global := hwnd, vars.hwnd.help_tooltips["settings_stash global profiles"] := hwnd1

	If settings.stash.use_global
		Settings_stash_profiles(GUI, "global")

	Gui, %GUI%: Font, % "bold underline cWhite s" settings.general.fSize
	Gui, %GUI%: Add, Text, % "Section xs x" x_anchor " y+" vars.settings.spacing " h" settings.general.fHeight " 0x200", % Lang_Trans("global_ui")
	Gui, %GUI%: Font, norm

	Gui, %GUI%: Add, Text, % "Section xs Border BackgroundTrans", % " " Lang_Trans("global_font") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border Background404040 cBlack", 100
	Gui, %GUI%: Add, Text, % "ys x+-1 Center Border BackgroundTrans gSettings_stash2 HWNDhwnd w"settings.general.fWidth*2, % "–"
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.font_minus := hwnd, vars.hwnd.help_tooltips["settings_font-size|"] := hwnd1

	Gui, %GUI%: Add, Text, % "ys x+-1 Center Border BackgroundTrans gSettings_stash2 HWNDhwnd w"settings.general.fWidth*3, % settings.stash.fSize
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.font_reset := hwnd, vars.hwnd.help_tooltips["settings_font-size||"] := hwnd1

	Gui, %GUI%: Add, Text, % "ys x+-1 Center Border BackgroundTrans gSettings_stash2 HWNDhwnd w"settings.general.fWidth*2, % "+"
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.font_plus := hwnd, vars.hwnd.help_tooltips["settings_font-size|||"] := hwnd1

	For key, val in settings.stash
		If IsObject(val) && val.bookmarking
		{
			bookmarks_enabled := 1
			Break
		}

	Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans", % " " Lang_Trans("stash_pricetags") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border Background404040 cBlack", 100
	colors := settings.stash.colors.Clone()

	Loop 3
	{
		If (A_Index = 2) || (A_Index = 3) && !bookmarks_enabled
			Continue
		color1 := colors[A_Index * 2 - 1], color2 := colors[A_Index * 2]
		Gui, %GUI%: Add, Text, % "Section " (A_Index = 3 ? "xs y+-1" : "ys x+-1") " Border Center HWNDhwndtext BackgroundTrans c" color1, % " 69.42 "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border BackgroundBlack HWNDhwndback c" color2, 100
		Gui, %GUI%: Add, Text, % "ys x+-1 w" settings.general.fWidth " hp Border BackgroundTrans gSettings_stash2 HWNDhwnd00"
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border BackgroundBlack HWNDhwnd01 c" color1, 100
		Gui, %GUI%: Add, Text, % "ys x+-1 w" settings.general.fWidth " hp Border BackgroundTrans gSettings_stash2 HWNDhwnd10"
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border BackgroundBlack HWNDhwnd11 c" color2, 100
		vars.hwnd.settings["color_" A_Index * 2 - 1] := hwnd00, vars.hwnd.settings["color_" A_Index * 2 - 1 "_panel"] := hwnd01, vars.hwnd.settings["color_" A_Index * 2 - 1 "_text"] := hwndtext
		vars.hwnd.settings["color_" A_Index * 2] := hwnd10, vars.hwnd.settings["color_" A_Index * 2 "_panel"] := hwnd11, vars.hwnd.settings["color_" A_Index * 2 "_text"] := hwndback
		vars.hwnd.help_tooltips["settings_generic color double" handle] := hwnd01, vars.hwnd.help_tooltips["settings_generic color double1" handle] := hwnd11
		vars.hwnd.help_tooltips["settings_stash color tag" A_Index] := hwndback, handle .= "|"
	}

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "Section xs x" x_anchor " y+" vars.settings.spacing, % Lang_Trans("m_stash_tabs")
	Gui, %GUI%: Font, norm
	Gui, %GUI%: Add, Pic, % "ys BackgroundTrans HWNDhwnd hp w-1", % "HBitmap:*" vars.pics.global.help

	vars.hwnd.help_tooltips["settings_stash config"] := hwnd
	If WinExist("ahk_id " vars.hwnd.stash.main) && vars.stash.active
		vars.settings.selected_tab := vars.stash.active

	Gui, %GUI%: Add, Text, % "Section xs Center Border BackgroundTrans", % " " Lang_Trans("m_stash_active") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border Background404040 cBlack", 100
	Gui, %GUI%: Add, Text, % "ys x+-1 Center Border BackgroundTrans c" (vars.settings.selected_tab ? "Lime" : "FF8000"), % " " (vars.settings.selected_tab ? Lang_Trans("m_stash_" vars.settings.selected_tab) : Lang_Trans("global_none")) " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border Background404040 cBlack", 100

	If !vars.settings.selected_tab
		Return

	tab := vars.settings.selected_tab
	Gui, %GUI%: Add, Text, % "Section xs Border BackgroundTrans", % " " Lang_Trans("m_stash_grid") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd0 Background404040 cBlack", 100
	Gui, %GUI%: Add, Text, % "ys yp x+-1 HWNDhwnd gSettings_stash2 Center Border BackgroundTrans w" settings.general.fWidth * 2, % "–"
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd01 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	Gui, %GUI%: Add, Text, % "ys yp x+-1 HWNDhwnd2 gSettings_stash2 Center Border BackgroundTrans w" settings.general.fWidth * 3, % settings.stash[tab].gap
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd02 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	Gui, %GUI%: Add, Text, % "ys yp x+-1 HWNDhwnd3 gSettings_stash2 Center Border BackgroundTrans w" settings.general.fWidth * 2, % "+"
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd03 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.help_tooltips["settings_stash gap"] := hwnd0, vars.hwnd.help_tooltips["settings_stash gap|"] := hwnd01, vars.hwnd.help_tooltips["settings_stash gap||"] := hwnd02, vars.hwnd.help_tooltips["settings_stash gap|||"] := hwnd03
	vars.hwnd.settings["gap-_" tab] := hwnd, vars.hwnd.settings["gap0_" tab] := hwnd2, vars.hwnd.settings["gap+_" tab] := hwnd3

	Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans HWNDhwnd gSettings_stash2" (settings.stash[vars.stash.active].in_folder ? " cLime" : " cGray"), % " " Lang_Trans("m_stash_infolder") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings["infolder_" tab] := hwnd, vars.hwnd.help_tooltips["settings_stash in folder"] := hwnd1

	Gui, %GUI%: Add, Text, % "ys HWNDhwnd Border BackgroundTrans gSettings_stash2" (settings.stash[vars.stash.active].bookmarking ? " cLime" : " cGray"), % " " Lang_Trans("m_stash_bookmarking") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings["bookmarking_" tab] := hwnd, vars.hwnd.help_tooltips["settings_stash bookmarking"] := hwnd1

	If settings.stash.use_global
		Return
	Settings_stash_profiles(GUI, tab)
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
		IniWrite, % (settings.features.stash := !settings.features.stash), % "ini" vars.poe_version "\config.ini", features, enable stash-ninja
		If !settings.features.stash
			Stash_Close()
		Settings_menu("stash-ninja")
	}
	Else If (check = "league_select")
		Settings_menu("general")
	Else If (check = "hotkey")
	{
		GuiControl, +cRed, % cHWND
		GuiControl, movedraw, % cHWND
	}
	Else If (check = "apply_button")
	{
		ControlGetFocus, hwnd, % "ahk_id " vars.hwnd.settings.main
		ControlGet, hwnd, HWND,, % hwnd
		If !InStr(vars.hwnd.settings.hotkey, hwnd)
		{
			in_progress := 0
			Return
		}
		If (hwnd = vars.hwnd.settings.min_trade)
		{
			input := LLK_ControlGet(vars.hwnd.settings.min_trade)
			IniWrite, % (settings.stash.min_trade := !input ? "" : input), % "ini" vars.poe_version "\stash-ninja.ini", settings, minimum trade value
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
				IniWrite, % """" input0 """", % "ini" vars.poe_version "\stash-ninja.ini", settings, hotkey
				GuiControl, +cBlack, % vars.hwnd.settings.hotkey
				GuiControl, movedraw, % vars.hwnd.settings.hotkey
			}
			in_progress := 0
			Return
		}
	}
	Else If InStr(check, "enable_")
	{
		IniWrite, % (settings.stash[control].enable := LLK_ControlGet(cHWND)), % "ini" vars.poe_version "\stash-ninja.ini", % control, enable
		If !settings.stash[control].enable && WinExist("ahk_id " vars.hwnd.stash.main)
			Stash_Close()
		Settings_menu("stash-ninja")
	}
	Else If (check = "history")
	{
		IniWrite, % (settings.stash.history := !settings.stash.history), % "ini" vars.poe_version "\stash-ninja.ini", settings, enable price history
		GuiControl, % "+c" (settings.stash.history ? "Lime" : "Gray"), % cHWND
		GuiControl, % "movedraw", % cHWND
	}
	Else If (check = "use_global")
	{
		IniWrite, % (settings.stash.use_global := !settings.stash.use_global), % "ini" vars.poe_version "\stash-ninja.ini", settings, use global profiles
		Settings_menu()
		If WinExist("ahk_id " vars.hwnd.stash.main)
			Stash(vars.stash.active)
	}
	Else If (check = "exalt")
		IniWrite, % (settings.stash.show_exalt := LLK_ControlGet(cHWND)), % "ini" vars.poe_version "\stash-ninja.ini", settings, show exalt conversion
	Else If (check = "min_trade")
	{
		GuiControl, +cRed, % cHWND
		GuiControl, movedraw, % cHWND
	}
	Else If (check = "autoprofiles")
	{
		IniWrite, % (settings.stash.autoprofiles := LLK_ControlGet(cHWND)), % "ini" vars.poe_version "\stash-ninja.ini", settings, enable trade-value profiles
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
		IniWrite, % settings.stash.fSize, % "ini" vars.poe_version "\stash-ninja.ini", settings, font-size
		Init_stash("font")
	}
	Else If InStr(check, "color_")
	{
		color := (vars.system.click = 1) ? RGB_Picker(settings.stash.colors[control]) : (InStr("135", control) ? "000000" : (control = 2) ? "00CC00" : (control = 4) ? "FF8000" : "00CCCC")
		If Blank(color)
		{
			in_progress := 0
			Return
		}
		GuiControl, % "+c" color, % vars.hwnd.settings["color_" control "_panel"]
		GuiControl, % "+c" color, % vars.hwnd.settings["color_" control "_text"]
		GuiControl, % "movedraw", % vars.hwnd.settings["color_" control "_text"]
		IniWrite, % (settings.stash.colors[control] := color), % "ini" vars.poe_version "\stash-ninja.ini", UI, % (InStr("135", control) ? "text" : "background") " color" (control > 2 ? Ceil(control/2) : "")
	}
	Else If InStr(check, "gap")
	{
		If InStr(check, "-") && (settings.stash[control].gap = 0)
		{
			in_progress := 0
			Return
		}
		If InStr(check, "0")
			settings.stash[control].gap := vars.stash.tabs[control].2
		Else settings.stash[control].gap += InStr(check, "-") ? -1 : 1
		IniWrite, % settings.stash[control].gap, % "ini" vars.poe_version "\stash-ninja.ini", % control, gap
		GuiControl, Text, % vars.hwnd.settings["gap0_" control], % settings.stash[control].gap
		Init_stash("gap")
	}
	Else If InStr(check, "infolder_")
	{
		groups := (vars.poe_version ? [["currency1"], ["delirium"], ["essences"], ["ritual"], ["runes1", "runes2", "soulcores", "idols"], ["fragments"], ["abyss"], ["expedition"], ["breach"]]
			: [["fragments", "scarabs", "betrayal"], ["currency1", "currency2", "currency3"], ["delve"], ["blight"], ["delirium"], ["essences"], ["ultimatum"]])
		gCheck := LLK_HasVal(groups, control,,,, 1)

		prev := settings.stash[control].in_folder
		For index, tab in groups[gCheck]
			IniWrite, % (settings.stash[tab].in_folder := !prev), % "ini" vars.poe_version "\stash-ninja.ini", % tab, tab is in folder
		GuiControl, % "+c" (settings.stash[control].in_folder ? "Lime" : "Gray"), % cHWND
		GuiControl, % "movedraw", % cHWND
		Init_stash(1)
	}
	Else If InStr(check, "bookmarking")
	{
		IniWrite, % (settings.stash[vars.stash.active].bookmarking := !settings.stash[vars.stash.active].bookmarking), % "ini" vars.poe_version "\stash-ninja.ini", % vars.stash.active, bookmarking
		Settings_menu()
	}
	Else If InStr(check, "limits")
	{
		types := {"bot": 1, "top": 2, "cur": 3}
		input := StrReplace(LLK_ControlGet(cHWND), ",", "."), lIndex := SubStr(check, 7, 1), lType := types[SubStr(check, 8, 3)], tab := control, currencies := ["c", "e", "d", "%"]
		If (SubStr(input, 1, 1) = "." || SubStr(input, 0) = ".") || InStr(input, "+")
			input := "invalid"
		array := (tab = "global" ? settings.stash.global_profile : settings.stash[tab].limits)
		If Blank(input)
			settings.stash[tab].limits0[lIndex][lType] := array[lIndex][lType] := "", input := "null"
		Else
		{
			lTop := array[lIndex].2, lBot := array[lIndex].1
			If (lType < 3) && !IsNumber(input) || (lType = 1 && !Blank(lTop) && input > lTop) || (lType = 2 && !Blank(lBot) && input < lBot)
			|| (lType = 3) && !InStr("c" (vars.poe_version ? "e" : "") "d%", input)
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
			settings.stash[tab].limits0[lIndex][lType] := array[lIndex][lType] := input
			While InStr(array[lIndex][lType], ".") && InStr(".0", SubStr(array[lIndex][lType], 0))
				input := settings.stash[tab].limits0[lIndex][lType] := array[lIndex][lType] := SubStr(array[lIndex][lType], 1, -1)
		}
		IniWrite, % input, % "ini" vars.poe_version "\stash-ninja.ini", % (tab = "global" ? "global profiles" : tab), % "limit " lIndex " " SubStr(check, 8, 3)
	}
	Else If InStr(check, "test")
		Stash(vars.settings.selected_stash, 1)
	Else LLK_ToolTip("no action")

	For index, val in ["limits", "gap", "color_", "font_", "history", "folder", "bookmarking_"]
		If InStr(check, val) && WinExist("ahk_id " vars.hwnd.stash.main)
			Stash("refresh", (val = "gap") ? 1 : 0)
	in_progress := 0
}

Settings_stash_profiles(GUI_name, tab)
{
	local
	global vars, settings

	If (tab = "global")
		Gui, %GUI_name%: Add, Text, % "Section xs y+0 w2 h" vars.settings.line1 " Border HWNDhwnd_brace"

	Gui, %GUI_name%: Add, Text, % "Section " (tab = "global" ? "ys y+0" : "xs x" vars.settings.x_anchor), % Lang_Trans("m_stash_limits")
	Gui, %GUI_name%: Add, Pic, % "ys HWNDhwnd hp w-1", % "HBitmap:*" vars.pics.global.help
	Gui, %GUI_name%: Font, % "s" settings.general.fSize - 4 " cBlack"
	vars.hwnd.help_tooltips["settings_stash limits"] := hwnd, currencies := ["c", "e", "d", "%"]
	Loop 5
	{
		style := (A_Index != 5) && settings.stash.bulk_trade && settings.stash.min_trade && settings.stash.autoprofiles ? " Disabled" : ""
		If style
			Gui, %GUI_name%: Add, Edit, % (A_Index = 1 ? "xs" : "ys x+" settings.general.fWidth/2) " Border Section Center w" settings.stash.fWidth * 2 " h" settings.stash.fHeight . style, % A_Index
		Else
		{
			Gui, %GUI_name%: Add, Text, % (A_Index = 1 ? "xs" : "ys x+" settings.general.fWidth/2) " Section cWhite 0x200 Border BackgroundTrans Center w" settings.stash.fWidth * 2 " h" settings.stash.fHeight, % A_Index
			Gui, %GUI_name%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd Background404040 cBlack", 100
		}

		array := (tab = "global" ? settings.stash.global_profile[A_Index] : settings.stash[tab].limits[A_Index]), vars.hwnd.help_tooltips["settings_stash profiles" handle] := hwnd
		Gui, %GUI_name%: Add, Text, % "xs y+-1 wp hp Border BackgroundTrans" style
		Gui, %GUI_name%: Add, Edit, % "xp yp wp hp Border Center HWNDhwnd2 gSettings_stash2 Limit1 wp hp" style, % currencies[array.3]
		Gui, %GUI_name%: Add, Text, % "Section ys x+-1 w" settings.general.fWidth * 4 " hp Border BackgroundTrans" style
		Gui, %GUI_name%: Add, Edit, % "xp yp wp hp Border Center HWNDhwnd gSettings_stash2 Limit" style, % array.2
		Gui, %GUI_name%: Add, Text, % "xs y+-1 wp hp Border BackgroundTrans" style
		Gui, %GUI_name%: Add, Edit, % "xp yp wp hp Border Center HWNDhwnd1 Limit gSettings_stash2 wp hp" style, % array.1
		vars.hwnd.settings["limits" A_Index "top_" tab] := hwnd, vars.hwnd.settings["limits" A_Index "bot_" tab] := hwnd1, vars.hwnd.settings["limits" A_Index "cur_" tab] := hwnd2, handle .= "|"
		vars.hwnd.help_tooltips["settings_stash currencies" handle] := hwnd2, vars.hwnd.help_tooltips["settings_stash top" handle] := hwnd, vars.hwnd.help_tooltips["settings_stash bot" handle] := hwnd1
	}

	If (tab != "global")
		Return
	Gui, %GUI_name%: Add, Text, % "Section xs x" vars.settings.x_anchor " w" settings.general.fWidth * 25 " h2 Border HWNDhwnd"
	GuiControl, movedraw, % hwnd_brace, % "h" LLK_ControlGetPos(hwnd, "y") - LLK_ControlGetPos(hwnd_brace, "y")
}

Settings_statlas()
{
	local
	global vars, settings

	GUI := "settings_menu" vars.settings.GUI_toggle, x_anchor := vars.settings.x_anchor

	Gui, %GUI%: Add, Text, % "Section x" x_anchor " y" vars.settings.ySelection " Border BackgroundTrans gSettings_statlas2 HWNDhwnd" (settings.features.statlas ? " cLime" : " cGray"), % " " Lang_Trans("global_enable") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.enable := hwnd, vars.hwnd.help_tooltips["settings_statlas enable"] := hwnd1

	Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans HWNDhwnd gURL cAqua", % " wiki page "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.URLs := {}, vars.URLs[hwnd] := "https://github.com/Lailloken/Exile-UI/wiki/Statlas", vars.hwnd.help_tooltips["settings_website"] := hwnd1

	If !settings.features.statlas
		Return

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "Section xs Center y+"vars.settings.spacing, % Lang_Trans("global_general")
	Gui, %GUI%: Font, norm

	Gui, %GUI%: Add, Text, % "Section xs Border BackgroundTrans", % " " Lang_Trans("global_font") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border Background404040 cBlack", 100
	Gui, %GUI%: Add, Text, % "ys x+-1 Center Border BackgroundTrans gSettings_statlas2 HWNDhwnd w"settings.general.fWidth*2, % "–"
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.font_minus := hwnd, vars.hwnd.help_tooltips["settings_font-size|"] := hwnd1

	Gui, %GUI%: Add, Text, % "ys x+-1 Center Border BackgroundTrans gSettings_statlas2 HWNDhwnd w"settings.general.fWidth*3, % settings.statlas.fSize
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.font_reset := hwnd, vars.hwnd.help_tooltips["settings_font-size||"] := hwnd1

	Gui, %GUI%: Add, Text, % "ys x+-1 Center Border BackgroundTrans gSettings_statlas2 HWNDhwnd w"settings.general.fWidth*2, % "+"
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.font_plus := hwnd, vars.hwnd.help_tooltips["settings_font-size|||"] := hwnd1

	Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans HWNDhwnd gSettings_statlas2" (settings.statlas.maptracker ? " cLime" : " cGray"), % " " Lang_Trans("ms_mapping tracker") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.maptracker := hwnd, vars.hwnd.help_tooltips["settings_statlas maptracker"] := hwnd1

	Gui, %GUI%: Add, Text, % "Section xs Border BackgroundTrans HWNDhwnd gSettings_statlas2" (settings.statlas.debug ? " cLime" : " cGray"), % " " Lang_Trans("global_troubleshoot") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.debug := hwnd, vars.hwnd.help_tooltips["settings_statlas troubleshoot"] := hwnd1
}

Settings_statlas2(cHWND)
{
	local
	global vars, settings

	check := LLK_HasVal(vars.hwnd.settings, cHWND), control := SubStr(check, InStr(check, "_") + 1)
	If !InStr(check, "font_")
		KeyWait, LButton

	If (check = "enable")
	{
		IniWrite, % (settings.features.statlas := !settings.features.statlas), % "ini" vars.poe_version "\config.ini", features, enable statlas
		Settings_menu("statlas")
	}
	Else If (check = "maptracker")
	{
		IniWrite, % (settings.statlas.maptracker := !settings.statlas.maptracker), % "ini" vars.poe_version "\statlas.ini", settings, include map-tracker data
		GuiControl, % "+c" (settings.statlas.maptracker ? "Lime" : "Gray"), % cHWND
		GuiControl, % "movedraw", % cHWND
	}
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
	Else If (check = "debug")
	{
		IniWrite, % (settings.statlas.debug := !settings.statlas.debug), % "ini" vars.poe_version "\statlas.ini", settings, enable trouble-shooting
		GuiControl, % "+c" (settings.statlas.debug ? "Lime" : "Gray"), % cHWND
		GuiControl, % "movedraw", % cHWND
	}
	Else LLK_ToolTip("no action")
}

Settings_TLDR()
{
	local
	global vars, settings
	static fSize, wHotkey, wShared, wExclusive, wStyle

	GUI := "settings_menu" vars.settings.GUI_toggle, x_anchor := vars.settings.x_anchor, margin := vars.settings.line1, shared := settings.TLDR.hotkey_shared
	Gui, %GUI%: Add, Text, % "Section x" x_anchor " y" vars.settings.ySelection " Border BackgroundTrans" (vars.client.h <= 720 ? "" : " gSettings_TLDR2") " HWNDhwnd" (settings.features.TLDR ? " cLime" : " cGray"), % " " Lang_Trans("global_enable") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.enable := hwnd, vars.hwnd.help_tooltips["settings_TLDR enable"] := hwnd1

	Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans HWNDhwnd gURL cAqua", % " wiki page "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.URLs := {}, vars.URLs[hwnd] := "https://github.com/Lailloken/Exile-UI/wiki/TLDR‐Tooltips", vars.hwnd.help_tooltips["settings_website"] := hwnd1

	If (vars.client.h <= 720)
	{
		Gui, %GUI%: Add, Text, % "xs Section cRed w" settings.general.fWidth * vars.settings.min_width " y+" vars.settings.spacing, % Lang_Trans("m_ocr_unsupported")
		Return
	}
	If !settings.features.TLDR
		Return

	Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans HWNDhwnd gURL cAqua", % " ahk: key list "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.URLs[hwnd] := "https://www.autohotkey.com/docs/v1/KeyList.htm", vars.hwnd.help_tooltips["settings_website|"] := hwnd1

	If (settings.general.lang_client != "english") && !vars.client.stream
	{
		Settings_unsupported()
		Return
	}

	If (fSize != settings.general.fSize)
	{
		fSize := settings.general.fSize
		LLK_PanelDimensions([Lang_Trans("ms_hotkeys") . Lang_Trans("global_colon"), Lang_Trans("global_save")], fSize, wHotkey, hHotkey)
		LLK_PanelDimensions([Lang_Trans("global_shared"), Lang_Trans("global_separate")], fSize, wShared, hShared), wShared := Max(wShared, 8*settings.general.fWidth)
		LLK_PanelDimensions([Lang_Trans("m_hotkeys_exclusive")], fSize, wExclusive, hExclusive)
		LLK_PanelDimensions([Lang_Trans("global_style") " 7", Lang_Trans("global_regular")], fSize, wStyle, hStyle)
	}
	If !settings.TLDR.hotkey_shared && !Blank(settings.TLDR.hotkey)
		wHotkey1 := Max(wHotkey, wExclusive)
	Else wHotkey1 := wHotkey

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "xs Section y+"vars.settings.spacing, % Lang_Trans("global_general")
	Gui, %GUI%: Font, norm

	Gui, %GUI%: Add, Text, % "Hidden Section xs w" wHotkey1 . (shared ? " h" 2* settings.general.fHeight - 1 " 0x200" : "") " Center Border BackgroundTrans gSettings_TLDR2 cRed HWNDhwnd", % Lang_Trans("global_save")
	Gui, %GUI%: Add, Progress, % "Hidden Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.hotkey_save := hwnd, vars.hwnd.settings.hotkey_save_bar := hwnd1

	Gui, %GUI%: Add, Text, % "xp yp wp hp Center Border BackgroundTrans" (shared ? " 0x200" : ""), % Lang_Trans("ms_hotkeys") . Lang_Trans("global_colon")
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border Background404040 cBlack", 100

	If !shared && !Blank(settings.TLDR.hotkey)
	{
		Gui, %GUI%: Add, Text, % "xp y+-1 wp hp Center Border BackgroundTrans gSettings_TLDR2 HWNDhwnd" (settings.TLDR.hotkey_block ? " cLime" : " cGray"), % Lang_Trans("m_hotkeys_exclusive")
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings.hotkey_block := hwnd, vars.hwnd.help_tooltips["settings_hotkeys omniblock"] := hwnd1
	}

	Gui, %GUI%: Add, Text, % "ys x+-1 w" wShared " Center Border BackgroundTrans gSettings_TLDR2 HWNDhwnd" (shared ? " cLime" : ""), % Lang_Trans("global_shared")
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	Gui, %GUI%: Font, % "s" settings.general.fSize - 4
	Gui, %GUI%: Add, Text, % "xp y+-1 w" (shared ? 2*wShared - 1 : wShared) " hp Border BackgroundTrans"
	Gui, %GUI%: Add, Edit, % "xp yp wp hp Center Border HWNDhwnd2 cBlack gSettings_TLDR2", % (shared ? settings.TLDR.z_hotkey : settings.TLDR.hotkey)
	Gui, %GUI%: Font, % "s" settings.general.fSize
	vars.hwnd.settings.hotkey_shared := hwnd, vars.hwnd.help_tooltips["settings_TLDR hotkey shared"] := hwnd1, vars.hwnd.settings.hotkey := vars.hwnd.help_tooltips["settings_TLDR " (shared ? "z " : "") "hotkey"] := hwnd2

	Gui, %GUI%: Add, Text, % "ys " (shared ? "xp+" wShared - 1 : "x+-1") " w" wShared " Center Border BackgroundTrans gSettings_TLDR2 HWNDhwnd" (shared ? "" : " cLime"), % Lang_Trans("global_separate")
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.hotkey_separate := hwnd, vars.hwnd.help_tooltips["settings_TLDR hotkey separate"] := hwnd1
	If !shared
	{
		Gui, %GUI%: Font, % "s" settings.general.fSize - 4
		Gui, %GUI%: Add, Text, % "xp y+-1 w" wShared " hp Border BackgroundTrans"
		Gui, %GUI%: Add, Edit, % "xp yp wp hp Center Border HWNDhwnd cBlack gSettings_TLDR2", % settings.TLDR.z_hotkey
		Gui, %GUI%: Font, % "s" settings.general.fSize
		vars.hwnd.settings.z_hotkey := vars.hwnd.help_tooltips["settings_TLDR z hotkey"] := hwnd
	}

	Gui, %GUI%: Add, Text, % "Section xs Center Border BackgroundTrans gSettings_TLDR2 HWNDhwnd" (settings.TLDR.debug ? " cLime" : " cGray"), % " " Lang_Trans("global_troubleshoot") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.debug := hwnd, vars.hwnd.help_tooltips["settings_TLDR debug"] := hwnd1

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "Section xs y+" vars.settings.spacing, % Lang_Trans("global_ui")
	Gui, %GUI%: Font, norm

	Gui, %GUI%: Add, Text, % "xs Section Border BackgroundTrans", % " " Lang_Trans("global_font") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border Background404040 cBlack", 100
	Gui, %GUI%: Add, Text, % "ys x+-1 w"settings.general.fWidth*2 " Center Border BackgroundTrans gSettings_TLDR2 HWNDhwnd", % "–"
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.font_minus := hwnd, vars.hwnd.help_tooltips["settings_font-size|"] := hwnd1
	Gui, %GUI%: Add, Text, % "ys x+-1 w"settings.general.fWidth*3 " Center Border BackgroundTrans gSettings_TLDR2 HWNDhwnd", % settings.TLDR.fSize
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.font_reset := hwnd, vars.hwnd.help_tooltips["settings_font-size||"] := hwnd1
	Gui, %GUI%: Add, Text, % "ys x+-1 w"settings.general.fWidth*2 " Center Border BackgroundTrans gSettings_TLDR2 HWNDhwnd", % "+"
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.font_plus := hwnd, vars.hwnd.help_tooltips["settings_font-size|||"] := hwnd1
	Gui, %GUI%: Add, Text, % "xs Section", % Lang_Trans("m_iteminfo_highlight")
	Gui, %GUI%: Add, Pic, % "ys hp w-1 HWNDhwnd", % "HBitmap:*" vars.pics.global.help
	vars.hwnd.help_tooltips["settings_TLDR colors"] := hwnd

	For index, array in settings.TLDR.colors
	{
		Gui, %GUI%: Add, Text, % (InStr("14", A_Index) ? "xs Section" : "ys x+" settings.general.fWidth / 2) " Border Center HWNDhwndtext BackgroundTrans c" array.1 " w" wStyle, % (index = 0 ? Lang_Trans("global_regular") : Lang_Trans("global_style") " " index)
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border BackgroundBlack HWNDhwndback c" array.2, 100
		Gui, %GUI%: Add, Text, % "ys x+-1 w" settings.general.fWidth " hp Border BackgroundTrans gSettings_TLDR2 HWNDhwnd00"
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border BackgroundBlack HWNDhwnd01 c" array.1, 100
		Gui, %GUI%: Add, Text, % "ys x+-1 w" settings.general.fWidth " hp Border BackgroundTrans gSettings_TLDR2 HWNDhwnd10"
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border BackgroundBlack HWNDhwnd11 c" array.2, 100
		vars.hwnd.settings["color_" index "1"] := hwnd00, vars.hwnd.settings["color_" index "_panel1"] := hwnd01, vars.hwnd.settings["color_" index "_text1"] := hwndtext
		vars.hwnd.settings["color_" index "2"] := hwnd10, vars.hwnd.settings["color_" index "_panel2"] := hwnd11, vars.hwnd.settings["color_" index "_text2"] := hwndback
		vars.hwnd.help_tooltips["settings_generic color double" handle] := hwnd01, vars.hwnd.help_tooltips["settings_generic color double1" handle] := hwnd11, handle .= "|"
	}
}

Settings_TLDR2(cHWND)
{
	local
	global vars, settings
	static compat_text

	check := LLK_HasVal(vars.hwnd.settings, cHWND), control := SubStr(check, InStr(check, "_") + 1)
	If !InStr(check, "font_")
	{
		KeyWait, LButton
		KeyWait, ENTER
	}

	Switch check
	{
		Case "enable":
			IniWrite, % (settings.features.TLDR := !settings.features.TLDR), ini\config.ini, Features, enable tldr-tooltips
			If !Blank(settings.TLDR.hotkey)
			{
				Hotkey, IfWinActive, ahk_group poe_ahk_window
				Hotkey, % "*" (settings.TLDR.hotkey_block ? "" : "~") . Hotkeys_Convert(settings.TLDR.hotkey), TLDR, % (settings.features.TLDR ? "On" : "Off")
			}
			If WinExist("ahk_id " vars.hwnd.TLDR.main)
				TLDR_Close()
			Settings_menu("tldr-tooltips")

		Case "debug":
			IniWrite, % (settings.TLDR.debug := !settings.TLDR.debug), ini\TLDR.ini, settings, enable debug
			GuiControl, % "+c" (settings.TLDR.debug ? "Lime" : "Gray"), % cHWND
			GuiControl, % "movedraw", % cHWND

		Case "hotkey":
			input := LLK_ControlGet(cHWND), setting := settings.TLDR[settings.TLDR.hotkey_shared ? "z_hotkey" : "hotkey"]
			GuiControl, % (input != setting ? "-" : "+") "Hidden", % vars.hwnd.settings.hotkey_save
			GuiControl, % (input != setting ? "-" : "+") "Hidden", % vars.hwnd.settings.hotkey_save_bar

		Case "z_hotkey":
			input := LLK_ControlGet(cHWND)
			If (StrLen(input) != 1)
				Loop, Parse, % "+!^#"
					input := StrReplace(input, A_LoopField)

			If Blank(input)
				IniWrite, % """""", % "ini" vars.poe_version "\TLDR.ini", settings, toggle highlighting hotkey
			Else If GetKeyVK(input)
			{
				settings.TLDR.z_hotkey := input
				IniWrite, % input, ini\TLDR.ini, settings, toggle highlighting hotkey
				GuiControl, +cBlack, % cHWND
			}
			Else GuiControl, +cRed, % cHWND

			GuiControl, movedraw, % cHWND

		Case "hotkey_save":
			input := LLK_ControlGet(vars.hwnd.settings.hotkey), input_check := input
			If (StrLen(input) != 1)
				Loop, Parse, % "+!^#"
					input_check := StrReplace(input_check, A_LoopField)

			If Blank(input_check) || !GetKeyVK(input_check)
			{
				WinGetPos, x, y, w, h, % "ahk_id "vars.hwnd.settings.hotkey
				LLK_ToolTip(Lang_Trans("m_hotkeys_error"),, x, y + h,, "red")
				Return
			}

			shared := settings.TLDR.hotkey_shared
			Hotkey, If, WinActive("ahk_id " vars.hwnd.poe_client) || WinActive("ahk_id " vars.hwnd.TLDR.main)
			If (shared && !Blank(settings.TLDR.z_hotkey) || !shared && !Blank(settings.TLDR.hotkey))
				Hotkey, % "*" (!shared && settings.TLDR.hotkey_block ? "" : "~") . Hotkeys_Convert(settings.TLDR[shared ? "z_hotkey" : "hotkey"]), TLDR_Hotkey, Off

			IniWrite, % """" (settings.TLDR[shared ? "z_hotkey" : "hotkey"] := input) """", ini\TLDR.ini, settings, % (shared ? "toggle highlighting hotkey" : "hotkey")
			settings.TLDR[(shared ? "z_hotkey" : "hotkey") "_single"] := input_check
			Hotkey, % "*" (!shared && settings.TLDR.hotkey_block ? "" : "~") . Hotkeys_Convert(settings.TLDR[shared ? "z_hotkey" : "hotkey"]), TLDR_Hotkey
			Settings_menu("tldr-tooltips")

		Case "hotkey_block":
			Hotkey, If, WinActive("ahk_id " vars.hwnd.poe_client) || WinActive("ahk_id " vars.hwnd.TLDR.main)
			Hotkey, % "*" (settings.TLDR.hotkey_block ? "" : "~") . Hotkeys_Convert(settings.TLDR.hotkey), TLDR_Hotkey, Off
			IniWrite, % (settings.TLDR.hotkey_block := !settings.TLDR.hotkey_block), ini\TLDR.ini, settings, block native key-function
			Hotkey, % "*" (settings.TLDR.hotkey_block ? "" : "~") . Hotkeys_Convert(settings.TLDR.hotkey), TLDR_Hotkey, On
			GuiControl, % "+c" (settings.TLDR.hotkey_block ? "Lime" : "Gray"), % cHWND
			GuiControl, % "movedraw", % cHWND

		Default:
			If RegexMatch(check, "i)hotkey_(shared|separate)")
			{
				type := (InStr(check, "shared") ? "shared" : "separate")
				If (type = "shared") && settings.TLDR.hotkey_shared || (type = "separate") && !settings.TLDR.hotkey_shared
					Return
				If !Blank(settings.TLDR.hotkey) || !Blank(settings.TLDR.z_hotkey)
					Hotkey, If, WinActive("ahk_id " vars.hwnd.poe_client) || WinActive("ahk_id " vars.hwnd.TLDR.main)

				If !Blank(settings.TLDR.hotkey)
					Hotkey, % "*" (settings.TLDR.hotkey_block ? "" : "~") . Hotkeys_Convert(settings.TLDR.hotkey), TLDR_Hotkey, % (type = "shared" ? "Off" : "On")
				If !Blank(settings.TLDR.z_hotkey)
					Hotkey, % "*~" . Hotkeys_Convert(settings.TLDR.z_hotkey), TLDR_Hotkey, % (type = "shared" ? "On" : "Off")

				IniWrite, % (settings.TLDR.hotkey_shared := (InStr(check, "shared") ? 1 : 0)), % "ini" vars.poe_version "\TLDR.ini", settings, shared hotkeys
				Settings_menu("tldr-tooltips")
			}
			Else If InStr(check, "font")
			{
				While GetKeyState("LButton", "P")
				{
					If (control = "reset")
						settings.TLDR.fSize := settings.general.fSize
					Else settings.TLDR.fSize += (control = "minus") ? -1 : 1, settings.TLDR.fSize := (settings.TLDR.fSize < 6) ? 6 : settings.TLDR.fSize
					GuiControl, text, % vars.hwnd.settings.font_reset, % settings.TLDR.fSize
					Sleep 150
				}
				IniWrite, % settings.TLDR.fSize, ini\TLDR.ini, settings, font-size
				LLK_FontDimensions(settings.TLDR.fSize, height, width), settings.TLDR.fWidth := width, settings.TLDR.fHeight := height
			}
			Else If InStr(check, "color_")
			{
				pattern := SubStr(control, 1, 1), type := SubStr(control, 2, 1)
				color := (vars.system.click = 1) ? RGB_Picker(settings.TLDR.colors[pattern][type]) : settings.TLDR.dColors[pattern][type]
				If !Blank(color)
				{
					settings.TLDR.colors[pattern][type] := color
					IniWrite, % settings.TLDR.colors[pattern].1 "," settings.TLDR.colors[pattern].2, ini\TLDR.ini, UI, % "pattern " pattern
					Loop, 2
					{
						GuiControl, % "+c" settings.TLDR.colors[pattern][A_Index], % vars.hwnd.settings["color_" pattern "_text" A_Index]
						GuiControl, % "movedraw", % vars.hwnd.settings["color_" pattern "_text" A_Index]
						GuiControl, % "+c" settings.TLDR.colors[pattern][A_Index], % vars.hwnd.settings["color_" pattern "_panel" A_Index]
						GuiControl, % "movedraw", % vars.hwnd.settings["color_" pattern "_panel" A_Index]
					}
				}
			}
			Else LLK_ToolTip("no action: " check)

			If (InStr(check, "color_") || InStr(check, "font")) && vars.hwnd.TLDR.main && WinExist("ahk_id " vars.hwnd.TLDR.main)
				mode := vars.TLDR.last, TLDR%mode%()
	}
}

Settings_unsupported()
{
	local
	global vars, settings

	GUI := "settings_menu" vars.settings.GUI_toggle
	Gui, %GUI%: Font, norm
	Gui, %GUI%: Add, Text, % "xs Section y+"vars.settings.spacing, % "this feature is not available on clients`nwith an unsupported language.`n`nit will be available once a language-`npack for the current language has been`ninstalled.`n`nthese packs have to be created by the`ncommunity. to find out if there are any`nfor your language or how to`ncreate one, click the link below.`n"
	Gui, %GUI%: Font, norm
	Gui, %GUI%: Add, Link, % "Section xs", <a href="https://github.com/Lailloken/Exile-UI/discussions/categories/translations-localization">exile ui discussions: translations</a>
}

Settings_updater()
{
	local
	global vars, settings, json
	static fSize, wCurrent, wNotification

	If (fSize != settings.general.fSize)
	{
		fSize := settings.general.fSize
		LLK_PanelDimensions([Lang_Trans("m_updater_version", 2), Lang_Trans("m_updater_version", 3)], fSize, wCurrent, height)
		LLK_PanelDimensions([Lang_Trans("global_notification"), Lang_Trans("m_updater_autocheck")], fSize, wNotification, height)
	}

	If settings.general.dev
		vars.news.file := json.Load(LLK_FileRead("data\announcements.json"))
	GUI := "settings_menu" vars.settings.GUI_toggle, slop := settings.general.slop, stamp := LLK_StringRemove(vars.news.file.messages.1.1.stamp, ":, ,-"), cButtons := settings.general.cButtons, slop := settings.general.slop
	fWidth := settings.general.fWidth, fHeight := settings.general.fHeight, xMargin := vars.settings.xMargin
	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "Section x" vars.settings.x_anchor " y" vars.settings.ySelection " BackgroundTrans", % Lang_Trans("ms_news") . Lang_Trans("global_colon")
	Gui, %GUI%: Font, norm

	Gui_Label(GUI, "Section xs ", " " LLK_TimeSince(stamp, A_NowUTC) " ",,, [slop, 0, slop, 0])
	Gui_Label(GUI, "ys x+0", " " vars.news.file.messages.1.1.topic " ",, "hwnd.settings.news_latest",,,, "000000")
	Gui_Label(GUI, "ys x+0 gSettings_updater2", " " Lang_Trans("global_read") " ",, "hwnd.settings.news_read", [0, slop, 0, slop],,, cButtons)
	
	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "Section xs y+" vars.settings.spacing " BackgroundTrans", % Lang_Trans("m_updater_version")
	Gui, %GUI%: Font, norm

	width := (StrLen(vars.updater.version.2) > 6 || StrLen(vars.updater.latest.2) > 6 ? 6 : 5)
	Gui_Label(GUI, "Section xs w" wCurrent " Right", Lang_Trans("m_updater_version", 2) " ",,, [slop, 0, 0, 0])
	Gui_Label(GUI, "ys x+0 w" width*fWidth, " " vars.updater.version.2,,, [0, slop, 0, 0],,, 0)
	Gui, %GUI%: Add, Text, % "Hidden ys x+0 w" settings.general.fHeight " h" settings.general.fHeight

	If (enabled := (settings.updater.update_check || settings.general.dev))
		Gui_Label(GUI, "ys w" wNotification " Center gSettings_updater2", Lang_Trans("m_updater_autocheck"), "settings_updater check", "hwnd.settings.update_check", [slop, slop, 0, 0],,, cButtons, !settings.general.dev)

	color := vars.updater.skip && (vars.updater.latest.1 = vars.updater.skip) ? " cYellow" : (IsNumber(vars.updater.latest.1) && vars.updater.latest.1 > vars.updater.version.1) ? " cLime" : ""
	Gui_Label(GUI, "Section xs y+0 w" wCurrent " Right" color, Lang_Trans("m_updater_version", 3) " ",,, [0, 0, slop, 0])
	Gui_Label(GUI, "ys x+0 w" width*fWidth . color, " " vars.updater.latest.2,,,,,, 0)

	Gui, %GUI%: Add, Pic, % "ys x+2 yp+2 hp-4 w-1 Center BackgroundTrans HWNDhwnd", % "HBitmap:*" vars.pics.global.reload
	Gui_Label(GUI, "xp-2 yp-2 w" fHeight " gSettings_updater2",, "settings_updater refresh", "hwnd.settings.update_refresh", [0, slop, 0, slop]), vars.hwnd.help_tooltips["settings_updater refresh|"] := hwnd

	Gui_Label(GUI, "ys w" wNotification " Center gSettings_updater2", Lang_Trans(enabled ? "global_notification" : "m_updater_autocheck"), "settings_updater " (enabled ? "notification" : "check"), "hwnd.settings." (enabled ? "notification" : "update_check"), (!enabled ? slop : [0, 0, slop, slop]),,, cButtons, (enabled && settings.updater.notify))

	If settings.general.dev || GetKeyState("Shift", "P") && GetKeyState("CTRL", "P")
		Gui_Label(GUI, "Section xs gSettings_updater2", " get dev build ",, "hwnd.settings.get_dev", slop,,, cButtons).back, button := 1
	Else If settings.general.dev || GetKeyState("CTRL", "P")
		Gui_Label(GUI, "Section xs gSettings_updater2", " get hotfix ", "settings_updater hotfix unlisted", "hwnd.settings.get_hotfix", slop,,, cButtons), button := 1

	If IsNumber(vars.updater.latest.1) && (vars.updater.latest.1 > vars.updater.version.1) && (vars.updater.latest.1 != vars.updater.skip)
	{
		Gui_Label(GUI, (button ? "ys" : "Section xs") " gSettings_updater2", " " Lang_Trans("m_updater_skip") " ", "settings_updater skip", "hwnd.settings.skip", slop,,, cButtons)
		latest := vars.updater.latest.2, latest := InStr(latest, "hotfix") ? SubStr(latest, 1, InStr(latest, " (hotfix") - 1) : latest
		Gui_Label(GUI, "ys gSettings_updater2 cLime", " " Lang_Trans("global_restart") " ", "settings_updater changelog " latest "|", "hwnd.settings.restart_install2", slop,,, cButtons)
	}

	If IsNumber(vars.updater.latest.1) && IsObject(vars.updater.changelog)
	{
		Gui, %GUI%: Font, underline bold
		Gui, %GUI%: Add, Text, % "Section xs y+" vars.settings.spacing " BackgroundTrans", % Lang_Trans("m_updater_recent")
		Gui, %GUI%: Font, % "norm s" settings.general.fSize - 2

		features := {"0major changes": []}, remove := []
		For iVersion, aVersion in vars.updater.changelog
			For iLine, vLine in aVersion
			{
				If (iLine = 1)
					version := vLine.1, date := ""
				Else If (iLine = 2)
					date := vLine
				Else If (check := InStr(vLine, ":"))
					feature := SubStr(vLine, 1, check - 1), change := SubStr(vLine, check + 2)
				Else change := vLine, feature := ""

				If InStr(vLine, "/highlight")
					features["0major changes"].Push((feature ? feature ":" : "") . (date ? " " version " (" date ")" : "") "`n" change)
				If date
					change := version " (" date ")`n" change
				If !feature || (iLine < 3)
					Continue

				If !IsObject(features[feature])
					features[feature] := []
				features[feature].Push(change)
			}

		For key in vars.help.settings
			If InStr(key, "recentchanges")
				remove.Push(key)
		For iRemove, kRemove in remove
			vars.help.settings.Delete(kRemove)

		For key, array in features
		{
			vars.help.settings["recentchanges " (key := StrReplace(key, 0))] := array.Clone(), outer := A_Index
			While !Blank(vars.help.settings["recentchanges " key].6)
				vars.help.settings["recentchanges " key].RemoveAt(6)
			Loop 2
			{
				style := (A_Index = 2 ? "Section xs" : "ys x+" settings.general.fWidth/2) . (RegExMatch(key, "i)major.changes|new.feature") ? " cFF8000" : "")
				hwnd := Gui_Label(GUI, style, " " StrReplace(key, "&", "&&") " ", "settings_recentchanges " key,, slop)
				ControlGetPos, xControl, yControl, wControl, hControl,, % "ahk_id " hwnd.back
				If (xControl + wControl <= vars.settings.x_anchor + settings.general.fWidth * vars.settings.min_width * 1.33)
					Break
				Else
				{
					GuiControl, +Hidden, % hwnd.text
					GuiControl, +Hidden, % hwnd.back
				}
			}
		}

		Gui, %GUI%: Font, % "underline bold s" settings.general.fSize
		Gui, %GUI%: Add, Text, % "Section xs y+" vars.settings.spacing " BackgroundTrans", % Lang_Trans("m_updater_versions")
		added := {}, selected := vars.updater.selected, selected_sub := SubStr(selected, InStr(selected, ".",, 0) + 1)
		Gui, %GUI%: Font, norm
		Gui, %GUI%: Add, Pic, % "ys hp w-1 HWNDhwnd BackgroundTrans", % "HBitmap:*" vars.pics.global.help
		vars.hwnd.help_tooltips["settings_updater versions"] := hwnd

		For index, val in vars.updater.changelog
		{
			major := SubStr(val.1.1, 1, 5)
			If !added[major]
				If (index >= 4)
					Continue
				Else Gui_Label(GUI, (!added.Count() ? "Section xs" : "ys") " w" 4*fWidth " Center", major,,, [slop, 0, slop, 0],, (InStr(selected, major) ? "insert 00FFFF" : ""))

			minor := SubStr(val.1.2, -1) + 0, color := (selected = major . minor ? " cAqua" : (val.1.3 ? " cFF8000" : ""))
			Gui_Label(GUI, "ys x+0 w" 2.5*fWidth " gSettings_updater2 Center" color, minor, "settings_updater changelog " major . minor, "hwnd.settings.versionselect_" StrReplace(major, ".", ",") . minor, (minor = 0 ? [0, slop, 0, slop] : ""),, (InStr(selected, major) ? "insert 00FFFF" : ""), cButtons), added[major] := 1
		}
	}

	If vars.updater.selected
	{
		Gui_Label(GUI, "Section xs gSettings_updater2 cAqua", " " Lang_Trans("global_restart", 2) " ", "settings_updater restart", "hwnd.settings.restart_install", slop,, "insert 00FFFF", cButtons).back
		Gui_Label(GUI, "ys gSettings_updater2 cAqua", " " Lang_Trans("m_updater_changelog") " ", "settings_updater full changelog", "hwnd.settings.fullchangelog_" StrReplace(vars.updater.selected, ".", ","), slop,, "insert 00FFFF", cButtons)
	}

	If IsNumber(vars.update.1) && (vars.update.1 < 0)
	{
		Gui, %GUI%: Font, bold underline
		Gui, %GUI%: Add, Text, % "Section xs cRed y+"vars.settings.spacing " BackgroundTrans", % Lang_Trans("m_updater_failed")
		Gui, %GUI%: Font, norm

		If InStr("126", StrReplace(vars.update.1, "-"))
			Gui, %GUI%: Add, Text, % "Section xs w" settings.general.fWidth * vars.settings.min_width " BackgroundTrans", % Lang_Trans("m_updater_error1") "`n`n" Lang_Trans("m_updater_error1", 2)
		Else If (vars.update.1 = -4)
			Gui, %GUI%: Add, Text, % "Section xs w" settings.general.fWidth * vars.settings.min_width " BackgroundTrans", % Lang_Trans("m_updater_error2") " " Lang_Trans("m_updater_error2", 2) "`n`n" Lang_Trans("m_updater_error2", 3)
		Else If (vars.update.1 = -3)
			Gui, %GUI%: Add, Text, % "Section xs w" settings.general.fWidth * vars.settings.min_width " BackgroundTrans", % Lang_Trans("m_updater_error3")
		Else If InStr("5", StrReplace(vars.update.1, "-"))
			Gui, %GUI%: Add, Text, % "Section xs w" settings.general.fWidth * vars.settings.min_width " BackgroundTrans", % Lang_Trans("m_updater_error4") " " Lang_Trans("m_updater_error2", 2) "`n`n" Lang_Trans("m_updater_error2", 3)

		If InStr("35", StrReplace(vars.update.1, "-"))
			Gui_Label(GUI, "Section xs gSettings_updater2", " " Lang_Trans("m_updater_manual") " ", "settings_updater manual", "hwnd.settings.manual", slop,,, cButtons)
			, Gui_Label(GUI, "ys gSettings_updater2", " " Lang_Trans("m_updater_manual", 2) " ", "settings_updater github", "hwnd.settings.github", slop,,, cButtons)
	}

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "Section xs y+"vars.settings.spacing " BackgroundTrans", % Lang_Trans("m_updater_github")
	Gui, %GUI%: Font, norm

	Gui_Label(GUI, "ys gSettings_updater2", " " Lang_Trans("m_updater_github", 2) " ",, "hwnd.settings.githubpage_main", slop,,, cButtons)
	Gui_Label(GUI, "ys gSettings_updater2", " " Lang_Trans("m_updater_github", 3) " ",, "hwnd.settings.releases_page",  slop,,, cButtons)
}

Settings_updater2(cHWND := "")
{
	local
	global vars, settings, Json
	static in_progress, refresh_tick

	If in_progress
		Return
	check := LLK_HasVal(vars.hwnd.settings, cHWND), control := SubStr(check, InStr(check, "_") + 1)
	If !InStr(check, "skip")
		KeyWait, LButton

	If (check = "news_read")
		Settings_menu("news")
	Else If InStr(check, "githubpage_")
		Run, % "https://github.com/Lailloken/Exile-UI/tree/"control
	Else If (check = "releases_page")
		Run, % "https://github.com/Lailloken/Exile-UI/releases"
	Else If (check = "update_check")
	{
		IniWrite, % (settings.updater.update_check := !settings.updater.update_check), ini\config.ini, settings, update auto-check
		If !settings.updater.update_check
			IniWrite, % (settings.updater.notify := 0), ini\config.ini, settings, update notification
		Settings_menu()
	}
	Else If (check = "update_refresh")
	{
		If vars.updater.latest.2 && (A_TickCount < refresh_tick + 10000 && !settings.general.dev)
			Return
		in_progress := 1, UpdateCheck(1), in_progress := 0, refresh_tick := A_TickCount, Settings_menu("updater")
	}
	Else If InStr(check, "versionselect_")
	{
		vars.updater.selected := StrReplace(control, ",", ".")
		Settings_menu("updater")
	}
	Else If InStr(check, "fullchangelog_")
		Run, % "https://github.com/Lailloken/Exile-UI/releases/tag/v" StrReplace(control, ",", ".")
	Else If InStr(check, "get_")
	{
		If settings.general.dev
			Return
		IniWrite, % control, ini\config.ini, versions, apply update
		Reload
		ExitApp
	}
	Else If InStr(check, "restart_install")
	{
		If InStr(check, 2)
			latest := vars.updater.latest.2, vars.updater.selected := InStr(latest, "hotfix") ? SubStr(latest, 1, InStr(latest, " (hotfix") - 1) : latest
		If !settings.general.dev || LLK_Progress(vars.hwnd.settings.restart_bar, "LButton")
		{
			IniWrite, % vars.updater.selected, ini\config.ini, versions, apply update
			Reload
			ExitApp
		}
	}
	Else If (check = "manual")
	{
		in_progress := 1
		UrlDownloadToFile, % "https://github.com/Lailloken/Exile-UI/archive/refs/tags/v" vars.update.2 ".zip", % "update\update_" vars.updater.target_version.2 ".zip"
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
		Run, % "https://github.com/Lailloken/Exile-UI/archive/refs/tags/v" vars.update.2 ".zip"
		Run, explore %A_ScriptDir%
		ExitApp
	}
	Else If (check = "skip")
	{
		If (vars.system.click = 1) && LLK_Progress(vars.hwnd.settings.skip_bar, "LButton")
		{
			vars.updater.skip := vars.updater.latest.1, vars.update := [0]
			IniWrite, % vars.updater.latest.1, ini\config.ini, versions, skip
			Settings_menu("updater")
		}
	}
	Else If (check = "notification")
	{
		If (vars.system.click = 2)
			Settings_menu("notifications")
		Else
		{
			IniWrite, % (settings.updater.notify := !settings.updater.notify), ini\config.ini, settings, update notification
			GuiControl, % "+c" (settings.updater.notify ? "Lime" : "Gray"), % cHWND
			GuiControl, % "movedraw", % cHWND
		}
	}
	Else LLK_ToolTip("no action")
}

Settings_CharTracking(mode, wEdits := "", yCoord := 0)
{
	local
	global vars, settings
	static fSize, wChar, wChar2

	If (fSize != settings.general.fSize)
	{
		fSize := settings.general.fSize
		LLK_PanelDimensions([Lang_Trans("m_general_character"), Lang_Trans("global_info")], fSize, wChar, hChar)
		LLK_PanelDimensions([Lang_Trans("m_general_character"), Lang_Trans("global_league"), Lang_Trans("global_info")], fSize, wChar2, hChar2)
	}

	GUI := "settings_menu" vars.settings.GUI_toggle, margin := settings.general.fWidth/4, profile := settings.leveltracker.profile, x_anchor := vars.settings.x_anchor, line1 := vars.settings.line1
	char := settings.leveltracker["guide" profile].info.character, fHeight := settings.general.fHeight, slop := settings.general.slop, build := settings.maptracker.character, radius := settings.general.radius
	cButtons := settings.general.cButtons, cButtons2 := settings.general.cButtons2
	If (mode = "general")
		color := " " (vars.log.level ? "cLime" : (settings.general.character ? "cYellow" : "cFF8000"))
	Else color := " " (vars.log.level && settings.general.character = char ? "cLime" : (char ? "cYellow" : "cFF8000"))

	wEdits := (!wEdits ? settings.general.fWidth2 * 15 : wEdits - (mode = "general" ? wChar2 : wChar))
	If (valid_char := (mode = "general" && vars.log.level || mode = "leveltracker" && vars.log.level && settings.general.character = char))
		LLK_PanelDimensions([vars.log.character_class " (" vars.log.level ")"], settings.general.fSize - 4, wClass, hClass), wEdits := Max(wEdits, wClass)

	style := (mode = "general" ? "xs x" x_anchor . (yCoord ? " y" yCoord + line1 : " y+" line1) : "ys x+" vars.settings.xMargin//2)
	Gui_Label(GUI, "Section " style " w" (mode = "general" ? wChar2 : wChar) . (valid_char ? " h" 2*fHeight " 0x200" : "") " Center" color
		, Lang_Trans("m_general_character"), "settings_" (mode = "general" ? "active character status" : "leveltracker character status"),, [slop, 0, (mode = "general" && slop && (!build || !valid_char)), 0], radius)

	Gui_Label(GUI, "ys x+0 w" wEdits,, "settings_" (mode = "general" ? "active character" : "leveltracker character info"),, (mode = "general" && !settings.general.character || mode = "leveltracker" && !char ? [0, slop, 0, ( mode = "general" ? slop : 0)] : ""),,, "0x50" cButtons2)

	Gui, %GUI%: Font, % "s" settings.general.fSize - (mode = "general" ? 2 : 4)
	char_text := (mode = "general" ? settings.general.character : settings.leveltracker["guide" profile].info.character)
	Gui, %GUI%: Add, Edit, % "xp yp wp hp cBlack HWNDhwnd1 LowerCase gSettings_CharTracking2", % char_text
	If valid_char
		Gui_Label(GUI, "xs xp y+0 wp hp 0x200", " " Lang_Trans("system_parenthesis",, [vars.log.level]) " " vars.log.character_class, "settings_ascendancy",,,,, 0)
	Gui, %GUI%: Font, % "s" settings.general.fSize
	vars.hwnd.settings.charinfo := hwnd1
	ControlGetPos, xEdit1, yEdit1, wEdit1, hEdit1,, ahk_id %hwnd1%

	If (mode = "general" && settings.general.character || mode = "leveltracker" && char)
	{
		Gui, %GUI%: Add, Pic, % "ys x+4 " (valid_char ? "y" yEdit1 + 1 + fHeight//2 : "yp+2") " w" fHeight - 4 " h-1 BackgroundTrans HWNDhwnd1", % "HBitmap:*" vars.pics.global.reload
		Gui_Label(GUI, "xp-4 y" yEdit1 " w" fHeight + 3 + (fHeight//10) . (valid_char ? " h" 2*fHeight : "") " gSettings_CharTracking2",, "settings_active character whois|", ["hwnd.settings.refresh_class", "_bar"], [0, slop, 0, slop], radius,, (valid_char ? cButtons : ""))
		vars.hwnd.settings.refresh_class_pic := vars.hwnd.help_tooltips["settings_active character whois"] := hwnd1, reload_button := 1
	}

	If vars.log.level && settings.features.maptracker && settings.maptracker.character || (mode = "leveltracker")
	{
		Gui_Label(GUI, "Section xs y+0 w" (mode = "leveltracker" ? wChar : wChar2) " Center", Lang_Trans("global_info"),,, [0, 0, slop, 0], radius)
		Gui, %GUI%: Font, % "s"settings.general.fSize - 2
		build_text := (mode = "general" ? settings.general.build : settings.leveltracker["guide" profile].info.name)
		Gui_Label(GUI, "ys x+0 w" wEdits " h" fHeight - 2,, "settings_" (mode = "general" ? "active build" : "leveltracker profile name"),, [0, 0, 0, slop],,, "0x50" cButtons2)
		Gui, %GUI%: Add, Edit, % "xp yp wp hp cBlack HWNDhwnd1 LowerCase gSettings_CharTracking2", % build_text
		Gui, %GUI%: Font, % "s" settings.general.fSize
		vars.hwnd.settings.buildinfo := hwnd1
		ControlGetPos, xEdit2, yEdit2, wEdit2, hEdit2,, ahk_id %hwnd1%
	}
	Else yEdit2 := yEdit1, hEdit2 := hEdit1, no_info := 1

	height := (no_info && valid_char ?  2*fHeight - 3 : yEdit2 + hEdit2 - yEdit1 - 2)
	Gui, %GUI%: Add, Pic, % "Hidden ys x" xEdit1 + wEdit1 + 4 . (valid_char || mode = "leveltracker" ? " y" yEdit1 - fHeight//2 + height//2 : " yp+2") " w" fHeight - 4 " h-1 BackgroundTrans HWNDhwnd1", % "HBitmap:*" vars.pics.global.checkmark
	Gui_Label(GUI, "Hidden xp-4 y" yEdit1 " w" fHeight + 3 + (fHeight//10) " h" height " gSettings_CharTracking2",,, ["hwnd.settings.save_buildinfo", "_bar"], [0, slop, 0, slop], radius,, (valid_char || mode = "leveltracker" ? cButtons : ""))
	vars.hwnd.settings.save_buildinfo_pic := hwnd1
	Gui, %GUI%: Add, Text, % "yp x+-1 w1 hp BackgroundTrans"
}

Settings_CharTracking2(cHWND)
{
	local
	global vars, settings
	static char_wait

	check := LLK_HasVal(vars.hwnd.settings, cHWND), control := SubStr(check, InStr(check, "_") + 1)
	If char_wait
		Return
	char_wait := 1, active := vars.settings.active

	If (check = "refresh_class")
	{
		KeyWait, LButton
		KeyWait, RButton
		WinActivate, % "ahk_id " vars.hwnd.poe_client
		WinWaitActive, % "ahk_id " vars.hwnd.poe_client
		Clipboard := "/whois " LLK_ControlGet(vars.hwnd.settings.charinfo)
		ClipWait, 0.1
		SendInput, {Enter}
		Sleep, 100
		SendInput, ^{a}^{v}{Enter}
		Sleep, 100
		Clipboard := ""
	}
	Else If (check = "charinfo" || check = "buildinfo")
	{
		charinfo := LLK_ControlGet(vars.hwnd.settings.charinfo), buildinfo := LLK_ControlGet(vars.hwnd.settings.buildinfo), profile := settings.leveltracker.profile
		If (active = "leveling tracker" && charinfo . buildinfo != settings.leveltracker["guide" profile].info.character . settings.leveltracker["guide" profile].info.name)
		|| (active = "general" && charinfo . buildinfo != settings.general.character . settings.general.build)
		{
			GuiControl, % "-Hidden", % vars.hwnd.settings.save_buildinfo
			GuiControl, % "-Hidden", % vars.hwnd.settings.save_buildinfo_bar
			GuiControl, % "-Hidden", % vars.hwnd.settings.save_buildinfo_pic
			GuiControl, % "+Hidden", % vars.hwnd.settings.refresh_class
			GuiControl, % "+Hidden", % vars.hwnd.settings.refresh_class_pic
			GuiControl, % "+Hidden", % vars.hwnd.settings.refresh_class_bar
		}
		Else
		{
			GuiControl, % "+Hidden", % vars.hwnd.settings.save_buildinfo
			GuiControl, % "+Hidden", % vars.hwnd.settings.save_buildinfo_bar
			GuiControl, % "+Hidden", % vars.hwnd.settings.save_buildinfo_pic
			GuiControl, % "-Hidden", % vars.hwnd.settings.refresh_class
			GuiControl, % "-Hidden", % vars.hwnd.settings.refresh_class_pic
			GuiControl, % "-Hidden", % vars.hwnd.settings.refresh_class_bar
		}
	}
	Else If (check = "save_buildinfo" || cHWND = "refresh")
		bla := 1
	Else LLK_ToolTip("no action")

	If (check = "save_buildinfo" || check = "refresh_class")
	{
		charinfo := Trim(LLK_ControlGet(vars.hwnd.settings.charinfo), " "), buildinfo := Trim(LLK_ControlGet(vars.hwnd.settings.buildinfo), " "), profile := settings.leveltracker.profile
		If (active = "leveling tracker")
		{
			IniWrite, % """" (settings.leveltracker["guide" profile].info.character := charinfo) """", % "ini" vars.poe_version "\leveling guide" profile ".ini", info, character
			IniWrite, % """" (settings.leveltracker["guide" profile].info.name := buildinfo) """", % "ini" vars.poe_version "\leveling guide" profile ".ini", info, name
			vars.leveltracker.characters[(profile ? profile : 1)] := {"character": charinfo, "build": buildinfo}
		}
		IniWrite, % """" (settings.general.character := charinfo) """", % "ini" vars.poe_version "\config.ini", settings, active character
		IniWrite, % """" (settings.general.build := (Blank(charinfo) ? "" : buildinfo)) """", % "ini" vars.poe_version "\config.ini", settings, active build
	}

	If (check = "save_buildinfo" || cHWND = "refresh" || check = "refresh_class")
	{
		Init_log("refresh")
		If WinExist("ahk_id " vars.hwnd.geartracker.main)
			Geartracker_GUI()
		Else If settings.leveltracker.geartracker && vars.hwnd.geartracker.main
			Geartracker_GUI("refresh")
		If LLK_Overlay(vars.hwnd.leveltracker.main, "check")
			Leveltracker_Progress()
		If settings.features.maptracker && settings.maptracker.character
			Maptracker_GUI()
		If (check != "refresh_class")
			Settings_menu(active)
	}
	char_wait := 0
}

Settings_LeagueSelection(ByRef yCoord, ByRef width)
{
	local
	global vars, settings
	static fSize, wLeague, widths, widths_count

	leagues := vars.leagues, league := settings.general.league, slop := settings.general.slop, radius := settings.general.radius, x_anchor := vars.settings.x_anchor, cButtons := settings.general.cButtons
	objects := [leagues, leagues[league.1], leagues[league.1][league.2], leagues[league.1][league.2][league.3], leagues[league.1][league.2][league.3][league.4]], cButtons2 := settings.general.cButtons2
	fHeight := settings.general.fHeight

	If (fSize != settings.general.fSize) || (widths_count != objects[(vars.poe_version ? 3 : 4)].Count())
	{
		fSize := settings.general.fSize, widths := []
		LLK_PanelDimensions([Lang_Trans("m_general_character"), Lang_Trans("global_league")], fSize, wLeague, hLeague)
	}
	widths_count := objects[(vars.poe_version ? 3 : 4)].Count()

	GUI := "settings_menu" vars.settings.GUI_toggle, margin := settings.general.fWidth/4
	hwnd := Gui_Label(GUI, "Section xs x" x_anchor " w" wLeague " h" settings.general.fHeight * vars.leagues.Count() - 2 " 0x200 Center", Lang_Trans("global_league") , "settings_league selection",, [slop, 0, slop, 0], radius), handle := "|"
	ControlGetPos, xFirst, yFirst, wFirst, hFirst,, % "ahk_id " hwnd.back

	Gui, %GUI%: Font, % "s" fSize - 2
	Loop, % (vars.poe_version ? 3 : 4)
	{
		outer := A_Index
		If Blank(widths[outer])
		{
			dimensions := []
			For key in objects[outer]
				dimensions.Push(Lang_Trans("global_league_" key))
			LLK_PanelDimensions(dimensions, fSize - 2, width, height), widths[outer] := width
		}
		For key in objects[outer]
			Gui_Label(GUI, (A_Index = 1 ? "Section ys x+0" : "xs y+0") " w" widths[outer] " h" settings.general.fHeight - 2 " 0x200 Center gSettings_LeagueSelection2" (key = league[outer] ? " cLime" : ""), Lang_Trans("global_league_" key), "settings_league selection" handle, "hwnd.settings.leagueselect_" outer "|" key, [0, 0, (slop && count_prev && A_Index = objects[outer].Count() && A_Index > count_prev ? 1 : 0), slop && objects[outer + 1].Count() && (A_Index = objects[outer].Count() && objects[outer].Count() > objects[outer + 1].Count())],,, cButtons)
			, handle .= "|", count := A_Index
		count_prev := count
	}

	height := settings.general.fHeight * count
	Gui, %GUI%: Add, Pic, % "ys x+4 " (count > 1 ? "y" yFirst + (count - 1) + (count - 1) * settings.general.fHeight/2 : "yp+2") " w" settings.general.fHeight - 4 " h-1 BackgroundTrans HWNDhwnd1", % "HBitmap:*" vars.pics.global.reload
	vars.hwnd.help_tooltips["settings_league update"] := hwnd1
	hwnd := Gui_Label(GUI, "xp-4 y" yFirst " w" fHeight + 3 + (fHeight//10) " h" height - 2 " gSettings_LeagueSelection2",, "settings_league update|", "hwnd.settings.league_update", [0, slop, 0, slop], radius,, (count > 1 ?cButtons : ""))
	yCoord := yFirst + Max(hFirst, height), width := LLK_ControlGetPos(hwnd.back).x - xFirst
	Gui, %GUI%: Font, % "s" fSize
}

Settings_LeagueSelection2(cHWND := "")
{
	local
	global vars, settings, json

	check := LLK_HasVal(vars.hwnd.settings, cHWND), control := SubStr(check, InStr(check, "_") + 1)
	KeyWait, LButton
	If InStr(check, "leagueselect_")
	{
		control := StrSplit(control, "|"), settings.general.league[control.1] := control.2, league := settings.general.league
		target := (vars.poe_version ? vars.leagues[league.1][league.2][league.3] : vars.leagues[league.1][league.2][league.3][league.4])
		If !target
			Loop, % (vars.poe_version ? 3 : 4)
				If (A_Index != control.1)
					settings.general.league[A_Index] := settings.general.league0[A_Index]

		For index, val in settings.general.league
			string .= (string ? "|" : "") val
		IniWrite, % """" string """", % "ini" vars.poe_version "\config.ini", settings, league
		Stash_PriceFetch("flush"), vars.economy := {}
		If WinExist("ahk_id " vars.hwnd.stash.main)
			Stash("refresh")
		If WinExist("ahk_id " vars.hwnd.async.main)
			AsyncTrade()
		If WinExist("ahk_id " vars.hwnd.exchange.main)
			Exchange()
		If WinExist("ahk_id " vars.hwnd.lootfilter.main)
			Lootfilter_Editor()
		Settings_menu()
	}
	Else If (check = "league_update")
	{
		KeyWait, LButton
		FileDelete, % "data\global\league update.json"
		UrlDownloadToFile, % "https://raw.githubusercontent.com/Lailloken/Exile-UI/refs/heads/misc/leagues" StrReplace(vars.poe_version, " ", "%20") ".json", % "data\global\league update.json"
		If ErrorLevel || !FileExist("data\global\league update.json")
		{
			LLK_ToolTip(Lang_Trans("global_fail"),,,,, "Red")
			Return
		}
		Try file_check := json.Load(LLK_FileRead("data\global\league update.json", 1))

		If !IsObject(file_check)
		{
			LLK_ToolTip(Lang_Trans("global_fail"),,,,, "Red")
			FileDelete, % "data\global\league update.json"
			Return
		}
		FileMove, % "data\global\league update.json", % "data\global\leagues" vars.poe_version ".json", 1
		vars.leagues := json.Load(LLK_FileRead("data\global\leagues" vars.poe_version ".json", 1))
		league := settings.general.league
		If vars.poe_version && !vars.leagues[league.1][league.2][league.3] || !vars.poe_version && !vars.leagues[league.1][league.2][league.3][league.4]
			settings.general.league := settings.general.league0.Clone(), Stash_PriceFetch("flush")
		Settings_menu(), LLK_ToolTip(Lang_Trans("global_success"),,,,, "Lime")
	}
	Else LLK_ToolTip("no action")
}

Settings_WriteTest(cHWND := "")
{
	local
	global vars, settings
	static running

	If running
		Return
	running := 1, HWND_bar := vars.hwnd.settings.bar_writetest, yes := Lang_Trans("m_permission_yes"), no := Lang_Trans("m_permission_no"), unknown := Lang_Trans("m_permission_unknown")
	GuiControl, % "+cGreen", % HWND_bar
	FileRemoveDir, data\write-test\, 1
	If FileExist("data\write-test\")
	{
		running := 0
		Gui_MsgBox("write-test error",, [Lang_Trans("m_permission_error"), Lang_Trans("m_permission_error", 2)])
		Run, explore %A_WorkingDir%\data\
		Return
	}
	status .= Lang_Trans("m_permission_admin") " " (A_IsAdmin ? yes : no) "`n"
	FileCreateDir, data\write-test\
	GuiControl,, % HWND_bar, 100
	sleep, 250
	status .= Lang_Trans("m_permission_folder", 1) " " (FileExist("data\write-test\") ? yes : no) "`n", folder_creation := FileExist("data\write-test\") ? 1 : 0

	FileAppend,, data\write-test.ini
	GuiControl,, % HWND_bar, 200
	sleep, 250
	status .= Lang_Trans("m_permission_ini", 1) " " (FileExist("data\write-test.ini") ? yes : no) "`n", ini_creation := FileExist("data\write-test.ini") ? 1 : 0

	IniWrite, 1, data\write-test.ini, write-test, test
	GuiControl,, % HWND_bar, 300
	sleep, 250
	IniRead, ini_test, data\write-test.ini, write-test, test, 0
	status .= Lang_Trans("m_permission_ini", 2) " " (ini_test ? yes : no) "`n"

	pWriteTest := Gdip_BitmapFromScreen("0|0|100|100"), Gdip_SaveBitmapToFile(pWriteTest, "data\write-test.bmp", 100), Gdip_DisposeImage(pWriteTest)
	GuiControl,, % HWND_bar, 400
	sleep, 250
	status .= Lang_Trans("m_permission_image", 1) " " (FileExist("data\write-test.bmp") ? yes : no) "`n", img_creation := FileExist("data\write-test.bmp") ? 1 : 0

	If folder_creation
	{
		FileRemoveDir, data\write-test\
		sleep, 250
		status .= Lang_Trans("m_permission_folder", 2) " " (!FileExist("data\write-test\") ? yes : no) "`n"
	}
	Else status .= Lang_Trans("m_permission_folder", 2) " " unknown "`n"
	GuiControl,, % HWND_bar, 500

	If ini_creation
	{
		FileDelete, data\write-test.ini
		sleep, 250
		status .= Lang_Trans("m_permission_ini", 3) " " (!FileExist("data\write-test.ini") ? yes : no) "`n"
	}
	Else status .= Lang_Trans("m_permission_ini", 3) " " unknown "`n"
	GuiControl,, % HWND_bar, 600

	If img_creation
	{
		FileDelete, data\write-test.bmp
		sleep, 250
		status .= Lang_Trans("m_permission_image", 2) " " (!FileExist("data\write-test.bmp") ? yes : no)
	}
	Else status .= Lang_Trans("m_permission_image", 2) " " unknown
	GuiControl,, % HWND_bar, 700

	If !A_IsAdmin
		status .= "`n(color:aqua)" Lang_Trans("m_permission_restart") 

	If Gui_MsgBox("write-test results", Lang_Trans("m_permission_header"), StrSplit(status, "`n", " "),, (!A_IsAdmin ? ["yes", "no"] : "")) && !A_IsAdmin
	{
		IniWrite, % vars.settings.active, % "ini" vars.poe_version "\config.ini", Versions, reload settings
		Run *RunAs "%A_AhkPath%" /restart "%A_ScriptFullPath%"
		ExitApp
	}
	GuiControl,, % HWND_bar, % (running := 0)
}
