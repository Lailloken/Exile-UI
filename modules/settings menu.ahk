Settings_actdecoder()
{
	local
	global vars, settings

	GUI := "settings_menu" vars.settings.GUI_toggle, x_anchor := vars.settings.x_anchor

	Gui, %GUI%: Add, Text, % "Section x" x_anchor " y" vars.settings.ySelection " Border BackgroundTrans gSettings_actdecoder2 HWNDhwnd" (settings.features.actdecoder ? " cLime" : " cGray"), % " " Lang_Trans("global_enable") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.enable := hwnd, vars.hwnd.help_tooltips["settings_actdecoder enable"] := hwnd1

	Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans HWNDhwnd gURL cAqua", % " wiki page "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.URLs := {}, vars.URLs[hwnd] := "https://github.com/Lailloken/Exile-UI/wiki/Act‐Decoder", vars.hwnd.help_tooltips["settings_website"] := hwnd1

	If !settings.features.actdecoder
	{
		Gui, %Gui%: Add, Text, % "xs y+-1 h1 w" settings.general.fWidth * vars.settings.min_width
		Return
	}

	Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans HWNDhwnd gURL cAqua", % " ahk: key list "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.URLs[hwnd] := "https://www.autohotkey.com/docs/v1/KeyList.htm", vars.hwnd.help_tooltips["settings_website|"] := hwnd1

	FileDelete, % "img\GUI\act-decoder\Exile-UI*"
	Loop, Files, % "img\GUI\act-decoder\Exile-UI*", D
		FileRemoveDir, % A_LoopFilePath, 1

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "Section xs y+" vars.settings.spacing, % Lang_Trans("m_actdecoder_download")
	Gui, %GUI%: Font, norm

	If !vars.actdecoder.file_list.Count() || vars.actdecoder.updater.available
	{
		If FileExist("img\GUI\act-decoder\Exile-UI*")
		{
			Gui, %GUI%: Add, Text, % "Section xs cFF8000", % Lang_Trans("m_actdecoder_leftover")
			Gui, %GUI%: Add, Text, % "Section xs Border BackgroundTrans HWNDhwnd gSettings_actdecoder2", % " " Lang_Trans("global_openfolder") " "
			Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
			vars.hwnd.settings.open_folder := hwnd, vars.hwnd.help_tooltips["settings_actdecoder folder"] := hwnd1
			Return
		}
		Else If !vars.actdecoder.file_list.Count()
			Gui, %GUI%: Add, Text, % "Section xs cFF8000", % Lang_Trans("m_actdecoder_download", 2)
		Else Gui, %GUI%: Add, Text, % "Section xs h" settings.general.fHeight " cLime", % Lang_Trans("global_update", 2)

		If vars.actdecoder.updater.check.requires && (vars.actdecoder.updater.check.requires > vars.actdecoder.tool_version)
			Gui, %GUI%: Add, Text, % "Section xs y+0 hp cFF8000", % Lang_Trans("m_actdecoder_required")
		Else
		{
			Gui, %GUI%: Add, Text, % "Section xs Border BackgroundTrans HWNDhwnd gSettings_actdecoder2", % " " Lang_Trans("global_download") " "
			Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
			vars.hwnd.settings.dload_layouts := hwnd
		}

		If !vars.actdecoder.file_list.Count()
			Return
	}
	Else If Blank(vars.actdecoder.updater.last) || (LLK_TimeElapsed(vars.actdecoder.updater.last, "seconds") >= 60)
	{
		Gui, %GUI%: Add, Text, % "Section xs Border BackgroundTrans HWNDhwnd gSettings_actdecoder2", % " " Lang_Trans("global_update", 3) " "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings.dload_check := hwnd
	}
	Else
	{
		If (vars.actdecoder.updater.check = "failed")
			Gui, %GUI%: Add, Text, % "Section xs h" settings.general.fHeight " cFF8000", % Lang_Trans("m_actdecoder_failed")
		Else If (vars.actdecoder.updater.check.version = vars.actdecoder.version)
			Gui, %GUI%: Add, Text, % "Section xs h" settings.general.fHeight " cLime", % Lang_Trans("m_actdecoder_success")
	}

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "Section xs y+" vars.settings.spacing, % Lang_Trans("global_general")
	Gui, %GUI%: Font, norm

	Gui, %GUI%: Add, Text, % "Section xs Border HWNDhwnd2", % " " Lang_Trans("global_hotkey", 2) " "
	Gui, %GUI%: Add, Text, % "Hidden xp yp wp hp Border BackgroundTrans Center cRed gSettings_actdecoder2 HWNDhwnd1", % Lang_Trans("global_save")
	Gui, %GUI%: Add, Progress, % "Disabled Hidden xp yp wp hp Border HWNDhwnd3 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	Gui, %GUI%: Font, % "s" settings.general.fSize - 4
	Gui, %GUI%: Add, Text, % "xs y+-1 wp hp Border BackgroundTrans"
	Gui, %GUI%: Add, Edit, % "xp yp wp hp Border cBlack Center gSettings_actdecoder2 HWNDhwnd", % settings.actdecoder.hotkey
	Gui, %GUI%: Font, % "s" settings.general.fSize
	vars.hwnd.help_tooltips["settings_hotkeys formatting"] := vars.hwnd.settings.hotkey := hwnd, vars.hwnd.settings.hotkey_label := vars.hwnd.help_tooltips["settings_actdecoder hotkey"] := hwnd2
	vars.hwnd.settings.hotkey_save := hwnd1, vars.hwnd.settings.hotkey_save_bar := hwnd3

	LLK_PanelDimensions([Lang_Trans("global_opacity"), Lang_Trans("global_zoom")], settings.general.fSize, width, height)
	Gui, %GUI%: Add, Text, % "Section ys Border HWNDhwnd Right w" width, % Lang_Trans("global_opacity") " "
	vars.hwnd.help_tooltips["settings_actdecoder layouts opacity"] := hwnd
	Gui, %GUI%: Add, Text, % "ys x+-1 gSettings_actdecoder2 Center Border BackgroundTrans HWNDhwnd w" settings.general.fWidth * 2, % "–"
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings["zonesopac_minus"] := hwnd, vars.hwnd.help_tooltips["settings_actdecoder layouts opacity|"] := hwnd1
	Gui, %GUI%: Add, Text, % "ys x+-1 Center Border BackgroundTrans HWNDhwnd w" settings.general.fWidth * 3, % settings.actdecoder.trans_zones
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings["zonesopac_text"] := hwnd, vars.hwnd.help_tooltips["settings_actdecoder layouts opacity||"] := hwnd1
	Gui, %GUI%: Add, Text, % "ys x+-1 Center Border BackgroundTrans HWNDhwnd gSettings_actdecoder2 w" settings.general.fWidth * 2, % "+"
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings["zonesopac_plus"] := hwnd, vars.hwnd.help_tooltips["settings_actdecoder layouts opacity|||"] := hwnd1

	Gui, %GUI%: Add, Text, % "Section xs y+-1 Border HWNDhwnd Right w" width, % Lang_Trans("global_zoom") " "
	vars.hwnd.help_tooltips["settings_actdecoder layouts locked zoom"] := hwnd
	Gui, %GUI%: Add, Text, % "ys x+-1 gSettings_actdecoder2 Center Border BackgroundTrans HWNDhwnd w" settings.general.fWidth * 2, % "–"
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings["zoneszoom_minus"] := hwnd, vars.hwnd.help_tooltips["settings_actdecoder layouts locked zoom|"] := hwnd1
	Gui, %GUI%: Add, Text, % "ys x+-1 Center Border BackgroundTrans HWNDhwnd w" settings.general.fWidth * 3, % settings.actdecoder.sLayouts1
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings["zoneszoom_text"] := hwnd, vars.hwnd.help_tooltips["settings_actdecoder layouts locked zoom||"] := hwnd1
	Gui, %GUI%: Add, Text, % "ys x+-1 Center Border BackgroundTrans HWNDhwnd gSettings_actdecoder2 w" settings.general.fWidth * 2, % "+"
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings["zoneszoom_plus"] := hwnd, vars.hwnd.help_tooltips["settings_actdecoder layouts locked zoom|||"] := hwnd1

	If !Blank(settings.actdecoder.xLayouts . settings.actdecoder.yLayouts)
	{
		Gui, %GUI%: Add, Text, % "Section xs x" x_anchor " Border BackgroundTrans HWNDhwnd gSettings_actdecoder2", % " " Lang_Trans("global_reset") " "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border Range0-500 Vertical HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 500
		vars.hwnd.settings.reset_position := hwnd, vars.hwnd.settings.reset_position_bar := vars.hwnd.help_tooltips["settings_actdecoder position reset"] := hwnd1
	}

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "Section xs x" x_anchor " y+" vars.settings.spacing, % Lang_Trans("global_credits") . Lang_Trans("global_colon")
	Gui, %GUI%: Font, norm

	If !vars.poe_version
	{
		Gui, %GUI%: Add, Link, % "Section xs", % ">> CyclonDefinitiv's "
		Gui, %GUI%: Add, Link, % "ys x+0 HWNDhwnd", <a href="https://www.definitivguide.com/">layout guide</a>
		vars.hwnd.help_tooltips["settings_website||"] := hwnd
		Gui, %GUI%: Add, Text, % "Section xs", % ">> lailloken (compilation && editing)"
	}
	Else
	{
		Gui, %GUI%: Add, Text, % "Section xs", % ">> poe 2 campaign codex discord"
		Gui, %GUI%: Add, Text, % "Section xs", % ">> lailloken (compilation && editing)"
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
		If (vars.system.click = 1) && LLK_Progress(vars.hwnd.settings.reset_position_bar, "LButton",,, 500, "Red", vars.settings.cButtons)
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

Settings_addons()
{
	local
	global vars, settings, db
	static fSize

	GUI := "settings_menu" vars.settings.GUI_toggle, x_anchor := vars.settings.x_anchor

	Gui, %GUI%: Add, Text, % "Section x" x_anchor " y" vars.settings.ySelection " Border BackgroundTrans gSettings_addons2 HWNDhwnd" (settings.features.addons ? " cLime" : " cGray"), % " " Lang_Trans("global_enable") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.enable := hwnd, vars.hwnd.help_tooltips["settings_addons enable"] := hwnd1

	Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans HWNDhwnd gURL cAqua", % " wiki page "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.URLs := {}, vars.URLs[hwnd] := "https://github.com/Lailloken/Exile-UI/wiki/Enchant-Finder", vars.hwnd.help_tooltips["settings_website"] := hwnd1

	If !settings.features.addons
	{
		Gui, %Gui%: Add, Text, % "Hidden Section xs y+" vars.settings.spacing " w" settings.general.fWidth * vars.settings.min_width " HWNDhwnd cRed", % Lang_Trans("m_addons_failed")
		Gui, %Gui%: Add, Text, % "xs y+-1 h1 wp"
		vars.hwnd.settings.addons_failed := hwnd
		Return
	}

	If (fSize != settings.general.fSize)
	{
		fSize := settings.general.fSize
		For key, hbm in vars.pics.settings_addons
			DeleteObject(hbm)
		vars.pics.settings_addons := {}
	}

	Gui, %GUI%: Add, Text, % "Section xs w" settings.general.fWidth * vars.settings.min_width " cFF8000", % Lang_Trans("m_addons_warning")
	Gui, %GUI%: Add, Text, % "Section xs Border BackgroundTrans gSettings_addons2 HWNDhwnd", % " " Lang_Trans("global_import") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.import := hwnd, vars.hwnd.help_tooltips["settings_addons import"] := hwnd1

	Gui, %GUI%: Add, Text, % "Hidden ys Border BackgroundTrans gSettings_addons2 HWNDhwnd cRed", % " " Lang_Trans("global_restart") " "
	Gui, %GUI%: Add, Progress, % "Hidden Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.restart := hwnd, vars.hwnd.settings.restart_bar := hwnd1
	
	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "Section xs y+" vars.settings.spacing, % Lang_Trans("m_addons_list")
	Gui, %GUI%: Font, norm

	For key, val in vars.addons.list
	{
		vars.addons.list[key].enabled_provisional := val.enabled
		Gui, %GUI%: Add, Text, % "Section xs Border BackgroundTrans gSettings_addons2 HWNDhwnd" (val.enabled ? " cLime" : " cGray"), % " " Lang_Trans("global_enable") " "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings["enable_" key] := hwnd

		Gui, %GUI%: Add, Text, % "ys x+" settings.general.fHeight//5 " Border BackgroundTrans gSettings_addons2 HWNDhwnd", % " x "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Range0-500 Vertical Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 500
		vars.hwnd.settings["delete_" key] := hwnd, vars.hwnd.settings["delete_" key "_bar"] := vars.hwnd.help_tooltips["settings_addons delete" handle] := hwnd1

		If !vars.pics.settings_addons.settings
			vars.pics.settings_addons.settings := LLK_ImageCache("img\GUI\settings\general.png",, settings.general.fHeight - 2)
		Gui, %GUI%: Add, Pic, % "ys x+" settings.general.fHeight//5 " Border BackgroundTrans gSettings_addons2 HWNDhwnd", % "HBitmap:*" vars.pics.settings_addons.settings
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings["settings_" key] := hwnd, vars.hwnd.help_tooltips["settings_addons settings" handle] := hwnd1, handle .= "|"

		Gui, %GUI%: Add, Text, % "ys x+" settings.general.fHeight//5 " Border BackgroundTrans gSettings_addons2 HWNDhwnd", % " ? "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Range0-500 Vertical Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 500
		vars.hwnd.settings["info_" key] := hwnd, vars.hwnd.help_tooltips["settings_addons about" handle] := hwnd1

		Gui, %GUI%: Add, Text, % "ys hp c" (val.enabled ? "White" : "Gray"), % key
	}
}

Settings_addons2(cHWND)
{
	local
	global vars, settings

	check := LLK_HasVal(vars.hwnd.settings, cHWND), control := SubStr(check, InStr(check, "_") + 1)
	If !RegexMatch(check, "i)info_|delete_")
		KeyWait, LButton

	Switch
	{
		Case (check = "enable"):
		If !settings.features.addons
		{
			MsgBox, 4, Exile UI, % Lang_Trans("m_addons_warning", 2)
			IfMsgBox Yes
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
		IniWrite, % (settings.features.addons := !settings.features.addons), % "ini" vars.poe_version "\config.ini", features, enable add-ons
		Settings_menu()

		Case InStr(check, "enable_"):
		vars.addons.list[control].enabled_provisional := !vars.addons.list[control].enabled_provisional
		GuiControl, % "+c" (vars.addons.list[control].enabled_provisional ? "Lime" : "Gray"), % cHWND
		GuiControl, % "movedraw", % cHWND
		For key, val in vars.addons.list
			If (val.enabled != val.enabled_provisional)
				modified := 1

		GuiControl, % (modified ? "-" : "+") "Hidden", % vars.hwnd.settings.restart
		GuiControl, % (modified ? "-" : "+") "Hidden", % vars.hwnd.settings.restart_bar

		Case InStr(check, "delete_"):
		If (vars.system.click = 1) && LLK_Progress(vars.hwnd.settings[check "_bar"], "LButton",,, 500, "Red", vars.settings.cButtons)
			Sleep 1
		Else Return

		Case InStr(check, "settings_"):
		Settings_menu("addons_" control)

		Case InStr(check, "info_"):
		info := vars.addons.list[control].info
		For index, val in info.creators
			creators .= (creators ? ", " : "") . val.name
		text := Lang_Trans("global_info") . Lang_Trans("global_colon") "`n" LLK_StringCase(info.description) "`n`n" Lang_Trans("global_credits") . Lang_Trans("global_colon") "`n" creators
		LLK_ToolTip(text, 0,,, "addons_info",,,,, 1,, 1, settings.general.fWidth * 20)
		KeyWait, LButton
		LLK_Overlay(vars.hwnd.tooltip_addons_info, "destroy")

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
	{
		Gui, %Gui%: Add, Text, % "xs y+-1 h1 w" settings.general.fWidth * vars.settings.min_width
		Return
	}

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "Section xs Center y+"vars.settings.spacing, % Lang_Trans("global_ui")
	Gui, %GUI%: Font, norm

	Gui, %GUI%: Add, Text, % "xs Section Border HWNDhwnd0", % " " Lang_Trans("global_font") " "
	Gui, %GUI%: Add, Text, % "ys x+-1 Center Border BackgroundTrans gSettings_anoints2 HWNDhwnd w"settings.general.fWidth*2, % "–"
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.help_tooltips["settings_font-size"] := hwnd0, vars.hwnd.settings.font_minus := hwnd, vars.hwnd.help_tooltips["settings_font-size|"] := hwnd1
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

	GUI := "settings_menu" vars.settings.GUI_toggle, x_anchor := vars.settings.x_anchor

	Gui, %GUI%: Add, Text, % "Section x" x_anchor " y" vars.settings.ySelection " Border BackgroundTrans gSettings_betrayal2 HWNDhwnd" (settings.features.betrayal ? " cLime" : " cGray"), % " " Lang_Trans("global_enable") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.enable := hwnd, vars.hwnd.help_tooltips["settings_betrayal enable"] := hwnd1

	Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans HWNDhwnd gURL cAqua", % " wiki page "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.URLs := {}, vars.URLs[hwnd] := "https://github.com/Lailloken/Exile-UI/wiki/Betrayal-Info", vars.hwnd.help_tooltips["settings_website"] := hwnd1

	If !settings.features.betrayal
	{
		Gui, %Gui%: Add, Text, % "xs y+-1 h1 w" settings.general.fWidth * vars.settings.min_width
		Return
	}

	Gui, %GUI%: Font, % "underline bold"
	Gui, %GUI%: Add, Text, % "xs Section y+"vars.settings.spacing, % Lang_Trans("global_general")
	Gui, %GUI%: Font, % "norm"

	Gui, %GUI%: Add, Text, % "xs Section Border BackgroundTrans gSettings_betrayal2 HWNDhwnd" (settings.betrayal.ruthless ? " cLime" : " cGray"), % " " Lang_Trans("global_league_ruthless") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.ruthless := hwnd, vars.hwnd.help_tooltips["settings_betrayal ruthless"] := hwnd1

	Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans gSettings_betrayal2 HWNDhwnd", % " " Lang_Trans("global_imgfolder") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.folder := hwnd, vars.hwnd.help_tooltips["settings_betrayal folder"] := hwnd1

	Gui, %GUI%: Font, % "underline bold"
	Gui, %GUI%: Add, Text, % "xs Section y+"vars.settings.spacing " h" settings.general.fHeight " 0x200", % Lang_Trans("global_ui")
	Gui, %GUI%: Font, % "norm"

	Gui, %GUI%: Add, Text, % "Section xs Border HWNDhwnd0", % " " Lang_Trans("global_font") " "
	Gui, %GUI%: Add, Text, % "ys x+-1 Center HWNDhwnd gSettings_betrayal2 Border BackgroundTrans w"settings.general.fWidth*2, % "–"
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.mFont := hwnd, vars.hwnd.help_tooltips["settings_font-size"] := hwnd0, vars.hwnd.help_tooltips["settings_font-size|"] := hwnd1

	Gui, %GUI%: Add, Text, % "ys x+-1 Center HWNDhwnd gSettings_betrayal2 Border BackgroundTrans w"settings.general.fWidth*3, % settings.betrayal.fSize
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.rFont := hwnd, vars.hwnd.help_tooltips["settings_font-size||"] := hwnd1

	Gui, %GUI%: Add, Text, % "ys x+-1 Center HWNDhwnd gSettings_betrayal2 Border BackgroundTrans w"settings.general.fWidth*2, % "+"
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.pFont := hwnd, vars.hwnd.help_tooltips["settings_font-size|||"] := hwnd1

	Gui, %GUI%: Add, Text, % "Section xs Border HWNDhwnd", % " " Lang_Trans("m_betrayal_colors") " "
	vars.hwnd.help_tooltips["settings_betrayal colors"] := hwnd
	Loop 3
	{
		Gui, %GUI%: Add, Text, % "ys x+-1 Center HWNDhwnd gSettings_betrayal2 Border BackgroundTrans c"settings.betrayal.colors[A_Index], % " t" A_Index " "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings["tier"A_Index] := hwnd, vars.hwnd.help_tooltips["settings_betrayal color"handle] := hwnd1, handle .= "|"
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
		Gui, %GUI%: Add, Text, % pos " Border BackgroundTrans gSettings_betrayal2 HWNDhwnd w"width, % " " Lang_Trans("betrayal_" member)
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings[member] := hwnd
		ControlGetPos, xLast, yLast, wLast, hLast,, ahk_id %hwnd%
		yMax := (yLast + hLast > yMax) ? yLast + hLast : yMax
	}

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "Section xs x" vars.settings.x_anchor " Center y" yMax + vars.settings.spacing, % Lang_Trans("global_databaseinfo") . Lang_Trans("global_colon")
	Gui, %GUI%: Font, norm
	Gui, %GUI%: Add, Text, % "Section xs Center", % Lang_Trans("global_current") . Lang_Trans("global_colon") " " vars.betrayal.timestamp " "
	Gui, %GUI%: Add, Pic, % "ys x+0 hp-2 w-1 Border BackgroundTrans HWNDhwnd gSettings_betrayal2", % "HBitmap:*" vars.pics.global.reload
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.update := hwnd, vars.hwnd.help_tooltips["settings_betrayal update"] := hwnd1
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
	Else If (check = "ruthless")
	{
		IniWrite, % (settings.betrayal.ruthless := !settings.betrayal.ruthless), ini\betrayal info.ini, settings, ruthless
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
	static fSize, wDDL

	GUI := "settings_menu" vars.settings.GUI_toggle, Init_cheatsheets(), x_anchor := vars.settings.x_anchor

	Gui, %GUI%: Add, Text, % "Section x" x_anchor " y" vars.settings.ySelection " Border BackgroundTrans gSettings_cheatsheets2 HWNDhwnd" (settings.features.cheatsheets ? " cLime" : " cGray"), % " " Lang_Trans("global_enable") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.enable := hwnd, vars.hwnd.help_tooltips["settings_cheatsheets enable"] := hwnd1

	Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans HWNDhwnd gURL cAqua", % " wiki page "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.URLs := {}, vars.URLs[hwnd] := "https://github.com/Lailloken/Exile-UI/wiki/Cheat-sheet-Overlay-Toolkit", vars.hwnd.help_tooltips["settings_website"] := hwnd1

	If !settings.features.cheatsheets
	{
		Gui, %Gui%: Add, Text, % "xs y+-1 h1 w" settings.general.fWidth * vars.settings.min_width
		Return
	}

	If (fSize != settings.general.fSize)
	{
		fSize := settings.general.fSize
		LLK_PanelDimensions([Lang_Trans("m_cheat_images"), Lang_Trans("m_cheat_app"), Lang_Trans("m_cheat_advanced")], fSize - 2, wDDL, hDDL)
	}

	Gui, %GUI%: Font, % "underline bold"
	Gui, %GUI%: Add, Text, % "xs Section y+"vars.settings.spacing, % Lang_Trans("m_cheat_hotkeys")
	Gui, %GUI%: Font, % "norm"

	Gui, %GUI%: Add, Text, % "xs Section Border HWNDhwnd0", % " " Lang_Trans("m_cheat_modifier") " "
	LLK_PanelDimensions([Lang_Trans("global_alt"), Lang_Trans("global_ctrl")], settings.general.fSize, wAlt, hAlt)
	For index, val in ["alt", "ctrl"]
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

		Gui, %GUI%: Add, Text, % "xs Section Border HWNDhwnd0", % " " Lang_Trans("global_font") " "
		Gui, %GUI%: Add, Text, % "ys x+-1 Center HWNDhwnd Border BackgroundTrans gSettings_cheatsheets2 w"settings.general.fWidth*2, % "–"
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.help_tooltips["settings_font-size"] := hwnd0, vars.hwnd.settings.font_minus := hwnd, vars.hwnd.help_tooltips["settings_font-size|"] := hwnd1
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
	Gui, %GUI%: Add, Text, % "Section xs Border HWNDhwnd0", % " " Lang_Trans("global_type") " "
	Gui, %GUI%: Font, % "s" settings.general.fSize - 2

	DDL := [Lang_Trans("m_cheat_images"), Lang_Trans("m_cheat_app"), Lang_Trans("m_cheat_advanced")]
	Gui, %GUI%: Add, Text, % "ys x+-1 w" wDDL " hp 0x200 Center Border BackgroundTrans HWNDhwnd gSettings_cheatsheets2", % DDL.1
	vars.ddl.cheatsheet_type := {"cHWND": hwnd, "current": Lang_Trans("m_cheat_images"), "list": DDL.Clone(), "fSize": settings.general.fSize - 2, "color": vars.settings.cButtons}
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	Gui, %GUI%: Add, Button, % "Hidden xp yp wp hp Default HWNDhwnd2 gSettings_cheatsheets2", ok
	vars.hwnd.help_tooltips["settings_cheatsheets types"] := hwnd0, vars.hwnd.settings.type := hwnd, vars.hwnd.help_tooltips["settings_cheatsheets types|"] := hwnd1, vars.hwnd.settings.add := hwnd2
	Gui, %GUI%: Font, % "s"settings.general.fSize

	Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans", % " " Lang_Trans("global_name") " "
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
		WinGetPos, xControl, yControl, wControl, hControl, % "ahk_id " cHWND
		If Blank(input := Gui_DropDownList(vars.ddl.cheatsheet_type, [xControl, yControl, wControl, hControl], "Center"))
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
	static fSize, wDock, wDock2, wResolution, wPosition, wFiller, wTaskbar, wSplit

	GUI := "settings_menu" vars.settings.GUI_toggle, x_anchor := vars.settings.x_anchor, vars.settings.borderless_provisional := vars.client.borderless
	
	Gui, %GUI%: Add, Text, % "Section x" x_anchor " y" vars.settings.ySelection " Border BackgroundTrans HWNDhwnd gURL cAqua", % " wiki && setup guide "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.URLs := {}, vars.URLs[hwnd] := "https://github.com/Lailloken/Exile-UI/wiki", vars.hwnd.help_tooltips["settings_website"] := hwnd1

	If (fSize != settings.general.fSize)
	{
		fSize := settings.general.fSize
		LLK_PanelDimensions([Lang_Trans("m_general_resolution", 2), (vars.client.fullscreen = "false" ? Lang_Trans("m_general_borderless", 2) : "")], fSize, wResolution, hResolution)
		LLK_PanelDimensions([Lang_Trans("m_general_position")], fSize, wPosition, hPosition)
		LLK_PanelDimensions([Lang_Trans("m_general_posleft"), Lang_Trans("m_general_poscenter"), Lang_Trans("m_general_posright")], fSize, wDock, hDock)
		LLK_PanelDimensions([Lang_Trans("m_general_postop"), Lang_Trans("m_general_poscenter"), Lang_Trans("m_general_posbottom"), Lang_Trans("m_general_postaskbar")], fSize, wDock2, hDock2)
		LLK_PanelDimensions([Lang_Trans("m_general_screenfiller")], fSize, wFiller, hFiller)
		LLK_PanelDimensions([Lang_Trans("m_general_postaskbar")], fSize, wTaskbar, hTaskbar)
		LLK_PanelDimensions([Lang_Trans("m_general_screenfiller", 2)], fSize, wSplit, hSplit)

		If (wResolution < settings.general.fWidth * 8 - 1)
			wResolution := settings.general.fWidth * 8 - 1
		Else While !Mod(wResolution, 2)
			wResolution += 1

		If (wPosition < wDock + wDock2 - 1)
			wPosition := wDock + wDock2 - 1
		Else 
		{
			wDock := wDock2 := Max(wDock, wDock2)
			While !Mod(wPosition, 2) || (wPosition < wDock * 2 - 1)
				wPosition += 1
			While (wDock * 2 - 1 < wPosition)
				wDock := wDock2 := wDock + 1
		}
	}

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "Section xs y+" vars.settings.spacing, % Lang_Trans("m_general_client", 2)
	Gui, %GUI%: Font, norm

	Gui, %GUI%: Add, Text, % "ys cLime", % "path of exile " (vars.poe_version ? 2 : 1)
	If vars.client.stream
		Return
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

	Gui, %GUI%: Add, Text, % "xs Section", % Lang_Trans("m_general_logfile")
	red := Min(255, Max(0, vars.log.file_size - 100)), green := 255 - red, rgb := (red < 10 ? "0" : "") . Format("{:X}", red) . (green < 10 ? "0" : "") . Format("{:X}", green) "00"
	Gui, %GUI%: Add, Text, % "ys HWNDhwnd x+0 BackgroundTrans c" rgb, % " " vars.log.file_size " mb / " vars.log.access_time " ms "
	If !vars.pics.global.folder
		vars.pics.global.folder := LLK_ImageCache("img\GUI\folder.png")
	Gui, %GUI%: Add, Pic, % "ys x+0 hp w-1 Border BackgroundTrans gSettings_client2 HWNDhwnd2", % "HBitmap:*" vars.pics.global.folder
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd3 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.help_tooltips["settings_logfile"] := hwnd
	vars.hwnd.settings.logfolder := hwnd2, vars.hwnd.help_tooltips["settings_logfolder"] := hwnd3

	Gui, %GUI%: Add, Text, % "Section xs Border", % " " Lang_Trans("m_general_input", 2) " "
	For index, val in ["keyboard", "controller"]
	{
		Gui, %GUI%: Add, Text, % "ys x+-1 HWNDhwnd gSettings_client2 BackgroundTrans Border" (settings.general.input_method = index ? " cLime" : ""), % " " Lang_Trans("global_" val) " "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp HWNDhwnd1 Border Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings["inputmethod_" index] := hwnd, vars.hwnd.help_tooltips["settings_input method " index] := hwnd1
	}

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "xs Section y+"vars.settings.spacing, % Lang_Trans("m_general_client")
	Gui, %GUI%: Font, norm
	Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans HWNDhwnd Hidden cRed gSettings_client2", % " " Lang_Trans("global_restart", 2) " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp HWNDhwnd1 Hidden Border Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	Gui, %GUI%: Add, Text, % "yp x+0 w1 hp"
	vars.hwnd.settings.apply := hwnd, vars.hwnd.settings.apply_bar := hwnd1

	Gui, %GUI%: Add, Text, % "Section xs w" wResolution " Center Border HWNDhwnd", % " " Lang_Trans("m_general_resolution", 2) " "
	vars.hwnd.help_tooltips["settings_force resolution"] := hwnd

	If (vars.client.fullscreen = "true")
	{
		temp_fSize := settings.general.fSize
		Gui, %GUI%: Add, Text, % "xp y+-1 w" Ceil(wResolution/2) " 0x200 Center Border HWNDhwnd", % vars.monitor.w
		vars.hwnd.settings.custom_width := hwnd, vars.hwnd.help_tooltips["settings_force resolution|"] := hwnd
	}
	Else
	{
		Gui, %GUI%: Font, % "s" (temp_fSize := settings.general.fSize - 4)
		Gui, %GUI%: Add, Text, % "xp y+-1 w" Ceil(wResolution/2) " hp Border BackgroundTrans"
		Gui, %GUI%: Add, Edit, % "xp yp wp hp Border Limit4 Number Center cBlack gSettings_client2 HWNDhwnd", % vars.client.w0
		vars.hwnd.settings.custom_width := hwnd, vars.hwnd.help_tooltips["settings_force resolution||"] := hwnd
	}

	If vars.general.safe_mode
		vars.general.available_resolutions := StrReplace(vars.general.available_resolutions, vars.monitor.h "|")
	Gui, %GUI%: Add, Text, % "x+-1 yp wp hp 0x200 Border BackgroundTrans Center gSettings_client2 HWNDhwnd", % vars.client.h
	vars.ddl.custom_resolution := {"cHWND": hwnd, "current": vars.client.h, "list": StrSplit(Trim(vars.general.available_resolutions, "|"), "|", " "), "fSize": temp_fSize, "color": vars.settings.cButtons}
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.custom_resolution := hwnd, vars.hwnd.help_tooltips["settings_force resolution|||"] := hwnd1
	Gui, %GUI%: Font, % "s"settings.general.fSize

	If (vars.client.fullscreen = "true")
	{
		Gui, %GUI%: Add, Text, % "ys x+-1 w" settings.general.fWidth * (StrLen(Lang_Trans("global_reset", 2)) + 1) " h" settings.general.fHeight * 2 - 1 " 0x200 BackgroundTrans Border Center HWNDhwnd gSettings_client2", % Lang_Trans("global_reset", 2)
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Vertical HWNDhwnd1 Border Range0-500 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 500
		vars.hwnd.settings.reset_resolution := hwnd, vars.hwnd.settings.reset_resolution_bar := vars.hwnd.help_tooltips["settings_reset resolution"] := hwnd1
	}

	If vars.general.safe_mode
		Return

	WinGetPos,,, wCheck, hCheck, ahk_group poe_window
	If (wCheck < vars.monitor.w || hCheck < vars.monitor.h)
	{
		Gui, %GUI%: Add, Text, % "ys w" wPosition " Border Center HWNDhwnd", % Lang_Trans("m_general_position")
		vars.hwnd.help_tooltips["settings_window position"] := hwnd

		If (wCheck < vars.monitor.w)
		{
			DDL := []
			For index, val in ["left", "center", "right"]
				DDL.Push(Lang_Trans("m_general_pos" val))
			Gui, %GUI%: Add, Text, % "xp y+-1 w" wDock " hp 0x200 Border BackgroundTrans Center gSettings_client2 HWNDhwnd", % DDL[vars.client.docked]
			vars.ddl.dock := {"cHWND": hwnd, "current": DDL[vars.client.docked], "list": DDL.Clone(), "fSize": fSize, "color": vars.settings.cButtons}
			Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
			vars.hwnd.settings.dock := hwnd
		}
		Else Gui, %GUI%: Add, Text, % "xp y+-1 w" wDock " hp Center Border HWNDhwnd1", % Lang_Trans("m_general_poscenter")
		vars.hwnd.help_tooltips["settings_window position|"] := hwnd1

		If (hCheck < vars.monitor.h)
		{
			DDL := []
			For index, val in ["top", "center", "bottom", "taskbar"]
				DDL.Push(Lang_Trans("m_general_pos" val))
			Gui, %GUI%: Add, Text, % "x+-1 yp w" wDock2 " hp 0x200 Border BackgroundTrans Center gSettings_client2 HWNDhwnd", % DDL[vars.client.docked2]
			vars.ddl.dock2 := {"cHWND": hwnd, "current": DDL[vars.client.docked2], "list": DDL.Clone(), "fSize": fSize, "color": vars.settings.cButtons}
			Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
			vars.hwnd.settings.dock2 := hwnd, vars.hwnd.help_tooltips["settings_window position||"] := hwnd1
		}
		Else Gui, %GUI%: Add, Text, % "x+-1 yp w" wDock2 " hp Border"

		If (vars.client.fullscreen = "false")
		{
			Gui, %GUI%: Add, Text, % "Section xs w" wResolution " Center Border BackgroundTrans gSettings_client2 HWNDhwnd" (vars.client.borderless ? " cLime" : " cGray"), % Lang_Trans("m_general_borderless", 2)
			Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
			vars.hwnd.settings.remove_borders := hwnd, vars.hwnd.help_tooltips["settings_window borders"] := hwnd1
		}
	}

	If settings.general.FillerAvailable
	{
		width := (settings.general.ClientFillerTaskbar && (vars.client.w < vars.monitor.w) ? Max(wFiller, wTaskbar + wSplit - 1) : Max(wFiller, wTaskbar))
		Gui, %GUI%: Add, Text, % (vars.client.fullscreen = "false" ? "ys" : "Section xs") " w" width " Center Border BackgroundTrans HWNDhwnd gSettings_client2 " (settings.general.ClientFiller ? " cLime" : " cGray"), % Lang_Trans("m_general_screenfiller")
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings.ClientFiller := hwnd, vars.hwnd.help_tooltips["settings_client filler"] := hwnd1

		width := (settings.general.ClientFillerTaskbar && (vars.client.w < vars.monitor.w) ? "wp-" wSplit - 1 : "wp")
		Gui, %GUI%: Add, Text, % "xp y+-1 " width " Center Border BackgroundTrans HWNDhwnd gSettings_client2 " (settings.general.ClientFillerTaskbar ? " cLime" : " cGray") . (settings.general.ClientFiller ? "" : " Hidden"), % Lang_Trans("m_general_postaskbar")
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons . (settings.general.ClientFiller ? "" : " Hidden"), 100
		vars.hwnd.settings.ClientFillerTaskbar := hwnd, vars.hwnd.help_tooltips["settings_client filler taskbar"] := hwnd1

		If settings.general.ClientFillerTaskbar && (vars.client.w < vars.monitor.w)
		{
			Gui, %GUI%: Add, Text, % "x+-1 yp w" wSplit " Center Border BackgroundTrans gSettings_client2 HWNDhwnd" (settings.general.ClientFillersplit ? " cLime" : " cGray"), % Lang_Trans("m_general_screenfiller", 2)
			Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
			vars.hwnd.settings.ClientFillerSplit := hwnd, vars.hwnd.help_tooltips["settings_client filler split"] := hwnd1
		}
	}

	If (vars.client.h0 / vars.client.w0 < (5/12))
	{
		settings.general.blackbars := LLK_IniRead("ini" vars.poe_version "\config.ini", "Settings", "black-bar compensation", 0)
		Gui, %GUI%: Add, Checkbox, % "Section xs 0x400 BackgroundTrans gSettings_client2 HWNDhwnd Center Checked"settings.general.blackbars, % Lang_Trans("m_general_blackbars")
		vars.hwnd.settings.blackbars := vars.hwnd.help_tooltips["settings_black bars"] := hwnd
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
		If vars.hwnd.settings.blackbars
			IniWrite, % LLK_ControlGet(vars.hwnd.settings.blackbars), % "ini" vars.poe_version "\config.ini", Settings, black-bar compensation
		IniWrite, % vars.settings.active, % "ini" vars.poe_version "\config.ini", Versions, reload settings
		Reload
		ExitApp

		Case RegexMatch(check, "i)custom_(width|resolution)|dock2{0,1}$|blackbars"):
		WinGetPos, xControl, yControl, wControl, hControl, % "ahk_id " cHWND
		If InStr("custom_resolution,dock2", check)
			If Blank(input := Gui_DropDownList(vars.ddl[check], [xControl, yControl, wControl, hControl], "Center"))
				Return
		GuiControl, -Hidden, % vars.hwnd.settings.apply
		GuiControl, -Hidden, % vars.hwnd.settings.apply_bar

		Case (check = "reset_resolution"):
		If (vars.system.click = 1) && LLK_Progress(vars.hwnd.settings.reset_resolution_bar, "LButton",,, 500, "Red", vars.settings.cButtons)
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

	wMax := settings.general.fWidth * (vars.cloneframes.list.Count() = 1 ? 32 : 20)
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
	Gui, %GUI%: Add, Text, % "ys x+" settings.general.fWidth/2 " 0x200 hp Border Center HWNDhwnd w"settings.general.fWidth*2, 5
	;Gui, %GUI%: Add, UpDown, % "ys hp Disabled range0-5 gSettings_cloneframes2 HWNDhwnd", 5
	vars.hwnd.settings.opacity := vars.cloneframes.scroll.opacity := vars.hwnd.help_tooltips["settings_cloneframes scroll||||||||"] := hwnd

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
		WinGetPos, xControl, yControl, wControl, hControl, % "ahk_id " cHWND
		If Blank(input := Gui_DropDownList(vars.ddl[check], [xControl, yControl, wControl, hControl], "Center", 1)) || IsObject(input) && Blank(input.1 . input.2)
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

	LLK_PanelDimensions(dimensions, settings.general.fSize - 2, width, height), columns := 4
	GUI := "settings_menu" vars.settings.GUI_toggle, x_anchor := vars.settings.x_anchor

	Gui, %GUI%: Add, Text, % "Section x" x_anchor " y" vars.settings.ySelection " Border BackgroundTrans HWNDhwnd gURL cAqua", % " how to donate "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.URLs := {}, vars.URLs[hwnd] := "https://github.com/Lailloken/Exile-UI/discussions/407", vars.hwnd.help_tooltips["settings_donations howto"] := hwnd1

	Gui, %GUI%: Add, Text, % "Section xs y+" vars.settings.spacing, special thanks to these exiles who help me stay sane:
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

		Gui, %GUI%: Add, Text, % "Section ys y+0 Border HWNDhwnd0", % " " Lang_Trans("global_font") " "
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
			Gui, %GUI%: Add, Text, % "Section xs Border", % " " Lang_Trans("maptracker_logs") " " count " " Lang_Trans("global_day", (count > 1 ? 2 : 1)) ", " count1 " " Lang_Trans("global_trade", (count1 > 1 ? 2 : 1)) " "
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

		Gui, %GUI%: Add, Text, % "Section ys y+0 Border HWNDhwnd", % " " Lang_Trans("m_async_minchange") " "
		Gui, %GUI%: Add, Slider, % "xs y+-1 hp Border gSettings_exchange2 HWNDhwnd1 NoTicks ToolTip Center Range5-50 wp-" settings.general.fWidth*4 - 1, % settings.async.minchange
		Gui, %GUI%: Add, Text, % "ys yp x+-1 Border HWNDhwnd2 Center w" settings.general.fWidth*4, % settings.async.minchange "%"
		vars.hwnd.settings.minchange := vars.hwnd.help_tooltips["settings_exchange async minchange||"] := hwnd1, vars.hwnd.settings.minchange_label := vars.hwnd.help_tooltips["settings_exchange async minchange|"] := hwnd2
		vars.hwnd.help_tooltips["settings_exchange async minchange"] := hwnd

		Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans gSettings_exchange2 HWNDhwnd" (settings.async.show_name ? " cLime" : " cGray"), % " " Lang_Trans("m_async_name") " "
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
	If !RegexMatch(check, "i)font_|logs_delete")
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
		IniWrite, % (settings.async.minchange := LLK_ControlGet(cHWND)), % "ini" vars.poe_version "\vaal street.ini", settings async trade, minimum price change
		GuiControl, Text, % vars.hwnd.settings.minchange_label, % settings.async.minchange "%"
		ControlFocus,, % "ahk_id " vars.hwnd.settings.async_name
	}
	Else LLK_ToolTip("no action")
}

Settings_general()
{
	local
	global vars, settings
	static fSize, wOnOff, wLanguage

	GUI := "settings_menu" vars.settings.GUI_toggle, x_anchor := vars.settings.x_anchor

	Gui, %GUI%: Add, Text, % "Section x" x_anchor " y" vars.settings.ySelection " Border BackgroundTrans HWNDhwnd gURL cAqua", % " wiki && setup guide "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.URLs := {}, vars.URLs[hwnd] := "https://github.com/Lailloken/Exile-UI/wiki", vars.hwnd.help_tooltips["settings_website"] := hwnd1

	If (fSize != settings.general.fSize)
	{
		fSize := settings.general.fSize
		LLK_PanelDimensions([Lang_Trans("global_on"), Lang_Trans("global_off")], fSize, wOnOff, hOnOff)
		LLK_PanelDimensions([Lang_Trans("m_general_language"), Lang_Trans("global_font")], fSize, wLanguage, hLanguage)
	}

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "xs Section y+" vars.settings.spacing, % Lang_Trans("m_general_settings") ;. (settings.general.dev ? " h" settings.general.fHeight : "")
	Gui, %GUI%: Font, norm

	If settings.general.dev
	{
		Gui, %GUI%: Add, Text, % "ys hp Border BackgroundTrans Hidden gSettings_general2 HWNDhwnd" (settings.general.dev_env ? " cLime" : " cGray"), % " dev branch "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border Hidden HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings.dev_env := hwnd
	}

	multi := vars.general.MultiThreading
	Gui, %GUI%: Add, Text, % "Section xs Border", % " " Lang_Trans("global_multithreading", 3) " "
	Gui, %GUI%: Add, Text, % "ys x+-1 Border BackgroundTrans gSettings_general2 HWNDhwnd" (!settings.general.multithread_off && !multi ? " cFF8000" : (multi ? " cLime" : "")), % " " Lang_Trans("global_multithreading") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.threads_0 := hwnd, vars.hwnd.help_tooltips["settings_multi-threading multi" (!settings.general.multithread_off && !multi ? " failed" : "")] := hwnd1

	Gui, %GUI%: Add, Text, % "ys x+-1 Border BackgroundTrans gSettings_general2 HWNDhwnd" (settings.general.multithread_off ? " cLime" : ""), % " " Lang_Trans("global_multithreading", 2) " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.threads_1 := hwnd, vars.hwnd.help_tooltips["settings_multi-threading single"] := hwnd1

	Gui, %GUI%: Add, Text, % "ys Border", % " " Lang_Trans("m_general_autoclose") " "
	Gui, %GUI%: Font, % "s"settings.general.fsize - 4
	Gui, %GUI%: Add, Text, % "ys x+1 yp+1 w" 3 * settings.general.fWidth - 2 " hp-2 Border BackgroundTrans"
	Gui, %GUI%: Add, Edit, % "xp yp wp hp Border cBlack Number gSettings_general2 Center Limit2 HWNDhwnd", % settings.general.kill.2
	Gui, %GUI%: Add, Progress, % "Disabled xp-1 yp-1 wp+2 hp+2 HWNDhwnd0 Background" (settings.general.kill.2 ? "Lime" : "606060"), 0
	vars.hwnd.settings.kill_timeout := vars.hwnd.help_tooltips["settings_kill time"] := hwnd, vars.hwnd.settings.kill_timeout0 := hwnd0
	Gui, %GUI%: Font, % "s"settings.general.fsize

	If !vars.poe_version
	{
		Gui, %GUI%: Add, Text, % "xs Section Border BackgroundTrans HWNDhwnd gSettings_general2" (settings.features.browser ? " cLime" : " cGray"), % " " Lang_Trans("m_general_browser") " "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings.browser := hwnd, vars.hwnd.help_tooltips["settings_browser features"] := hwnd1
	}
	Gui, %GUI%: Add, Text, % (!vars.poe_version ? "ys" : "Section xs") " Border BackgroundTrans HWNDhwnd gSettings_general2" (settings.general.capslock ? " cLime" : " cGray"), % " " Lang_Trans("m_general_capslock") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.capslock := hwnd, vars.hwnd.help_tooltips["settings_capslock toggling"] := hwnd1

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "xs Section y+"vars.settings.spacing, % Lang_Trans("m_general_charleague")
	Gui, %GUI%: Font, norm
	If vars.log.file_location
		Settings_CharTracking("general")
	Settings_LeagueSelection(yCoord)

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "Section x" vars.settings.x_anchor " y" yCoord + vars.settings.spacing, % Lang_Trans("global_ui")
	Gui, %GUI%: Font, norm

	check := ""
	Loop, Files, data\*, R
		If (A_LoopFileName = "client.txt")
			parse := StrReplace(StrReplace(A_LoopFilePath, "data\"), "\client.txt"), check .= parse "|"
	If (lang_check := (settings.general.dev || LLK_InStrCount(check, "|") > 1))
	{
		Gui, %GUI%: Font, % "s"settings.general.fSize - 4
		Gui, %GUI%: Add, DDL, % "Hidden xs w" wLanguage, test
		Gui, %GUI%: Font, % "s"settings.general.fSize

		Gui, %GUI%: Add, Text, % "Section xp yp w" wLanguage " hp Right Border HWNDhwnd00", % Lang_Trans("m_general_language") " "
		Gui, %GUI%: Font, % "s"settings.general.fSize - 4
		Gui, %GUI%: Add, Text, % "ys x+-1 w" settings.general.fWidth * 7 - 2 " hp Border BackgroundTrans"
		Gui, %GUI%: Add, DDL, % "xp yp wp HWNDhwnd0 gSettings_general2", % StrReplace(check, settings.general.lang, settings.general.lang "|")
		Gui, %GUI%: Font, % "s"settings.general.fSize
		Gui, %GUI%: Add, Text, % "ys hp HWNDhwnd Border", % " " Lang_Trans("global_credits") " "
		vars.hwnd.help_tooltips["settings_lang language"] := vars.hwnd.settings.language := hwnd0, vars.hwnd.help_tooltips["settings_lang translators"] := hwnd, vars.hwnd.help_tooltips["settings_lang language|"] := hwnd00
	}

	Gui, %GUI%: Add, Text, % "Section xs" (lang_check ? " w" wLanguage " Right" : "") " HWNDhwnd Border", % (lang_check ? "" : " ") Lang_Trans("global_font") " "
	vars.hwnd.help_tooltips["settings_font-size"] := hwnd
	Gui, %GUI%: Add, Text, % "ys x+-1 gSettings_general2 Border BackgroundTrans Center HWNDhwnd w"settings.general.fWidth*2, % "–"
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.font_minus := hwnd, vars.hwnd.help_tooltips["settings_font-size|"] := hwnd1
	Gui, %GUI%: Add, Text, % "x+-1 ys w" settings.general.fWidth * 3 " gSettings_general2 Border BackgroundTrans Center HWNDhwnd", % settings.general.fSize
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.font_reset := hwnd, vars.hwnd.help_tooltips["settings_font-size||"] := hwnd1
	Gui, %GUI%: Add, Text, % "wp x+-1 ys gSettings_general2 Border BackgroundTrans Center HWNDhwnd w"settings.general.fWidth*2, % "+"
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.font_plus := hwnd, vars.hwnd.help_tooltips["settings_font-size|||"] := hwnd1

	Gui, %GUI%: Add, Text, % "ys Border gSettings_general2 Center HWNDhwnd", % " " Lang_Trans("m_general_menuwidget") " "
	vars.hwnd.help_tooltips["settings_font-size||||"] := hwnd
	Gui, %GUI%: Add, Text, % "ys x+-1 gSettings_general2 Border BackgroundTrans Center HWNDhwnd w" settings.general.fWidth * 2, % "–"
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.toolbar_minus := hwnd, vars.hwnd.help_tooltips["settings_font-size|||||"] := hwnd1
	Gui, %GUI%: Add, Text, % "x+-1 ys gSettings_general2 Border BackgroundTrans Center HWNDhwnd w" settings.general.fWidth * 3, % " " settings.general.sMenu " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.toolbar_reset := hwnd, vars.hwnd.help_tooltips["settings_font-size||||||"] := hwnd1
	Gui, %GUI%: Add, Text, % "x+-1 ys gSettings_general2 Border BackgroundTrans Center HWNDhwnd w" settings.general.fWidth * 2, % "+"
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.toolbar_plus := hwnd, vars.hwnd.help_tooltips["settings_font-size|||||||"] := hwnd1

	Gui, %GUI%: Add, Text, % "Section xs Border BackgroundTrans HWNDhwnd gSettings_general2" (settings.general.animations ? " cLime" : " cGray"), % " " Lang_Trans("global_animations") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.animations := hwnd, vars.hwnd.help_tooltips["settings_animations"] := hwnd1

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "xs Section BackgroundTrans HWNDhwnd y+"vars.settings.spacing, % Lang_Trans("m_general_permissions")
	vars.hwnd.settings.permissions_test := hwnd
	Gui, %GUI%: Add, Pic, % "ys hp w-1 BackgroundTrans HWNDhwnd0", % "HBitmap:*" vars.pics.global.help
	Gui, %GUI%: Font, norm
	Gui, %GUI%: Add, Text, % "xs Section BackgroundTrans Border gSettings_WriteTest", % " " Lang_Trans("m_general_start") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border Range0-700 HWNDhwnd Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 700
	Gui, %GUI%: Add, Text, % "ys BackgroundTrans Border gSettings_WriteTest HWNDhwnd1", % " " Lang_Trans("m_general_admin") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.help_tooltips["settings_write permissions"] := hwnd0, vars.hwnd.settings.bar_writetest := hwnd, vars.hwnd.settings.writetest := hwnd1
}

Settings_general2(cHWND := "")
{
	local
	global vars, settings
	static char_wait

	check := LLK_HasVal(vars.hwnd.settings, cHWND), control := SubStr(check, InStr(check, "_") + 1), update := vars.update
	If !RegExMatch(check, "i)winbar|font_|toolbar_")
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
					Sleep 8
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
			input := LLK_ControlGet(cHWND), input := (StrLen(input) > 1 ? LTrim(input, "0") : input)
			IniWrite, % (settings.general.kill.1 := Blank(input) ? 0 : input), % "ini\config.ini", Settings, kill script		;these are still split into 2 for back-compat
			IniWrite, % (settings.general.kill.2 := Blank(input) ? 0 : input), % "ini\config.ini", Settings, kill-timeout
			GuiControl, % "+Background" (input ? "Lime" : "606060"), % vars.hwnd.settings.kill_timeout0
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
			IniWrite, % LLK_ControlGet(vars.hwnd.settings.language), % "ini" vars.poe_version "\config.ini", settings, language
			IniWrite, % vars.settings.active, % "ini" vars.poe_version "\config.ini", Versions, reload settings
			Reload
			ExitApp
		Default:
			If InStr(check, "threads_")
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
				LLK_FontDimensions(settings.general.fSize, font_height, font_width), settings.general.fheight := font_height, settings.general.fwidth := font_width
				LLK_FontDimensions(settings.general.fSize - 4, font_height, font_width), settings.general.fheight2 := font_height, settings.general.fwidth2 := font_width
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
			Else LLK_ToolTip("no action")
	}
}

Settings_hotkeys()
{
	local
	global vars, settings
	static fSize, wHotkeys, wHotkeys2, wMovekey, wCtrl

	If (fSize != settings.general.fSize)
	{
		fSize := settings.general.fSize
		LLK_PanelDimensions([Lang_Trans("m_hotkeys_omnikey_new"), Lang_Trans("m_hotkeys_widget"), Lang_Trans("m_hotkeys_menukey"), Lang_Trans("m_hotkeys_restartkey")], fSize, wHotkeys, hHotkeys)
		LLK_PanelDimensions([StrReplace(Lang_Trans("m_hotkeys_omnikey_new"), Lang_Trans("global_colon")) " 2" Lang_Trans("global_colon") " "], fSize, wHotkeys2, hHotkeys2)
		LLK_PanelDimensions([Lang_Trans("m_hotkeys_movekey")], fSize, wMovekey, hMovekey)
		LLK_PanelDimensions([Lang_Trans("global_ctrl"), Lang_Trans("global_alt")], fSize, wCtrl, hCtrl)
	}

	GUI := "settings_menu" vars.settings.GUI_toggle, x_anchor := vars.settings.x_anchor, wEdits := Max(2 * wCtrl - 1, settings.general.fWidth * 7)
	vars.settings.tabblock_provisional := settings.hotkeys.tabblock, vars.settings.emergencykey_ctrl_provisional := settings.hotkeys.emergencykey_ctrl, vars.settings.emergencykey_alt_provisional := settings.hotkeys.emergencykey_alt
	
	Gui, %GUI%: Add, Text, % "Section x" x_anchor " y" vars.settings.ySelection " Border BackgroundTrans HWNDhwnd gURL cAqua", % " ahk: key list "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.URLs := {}, vars.URLs[hwnd] := "https://www.autohotkey.com/docs/v1/KeyList.htm", vars.hwnd.help_tooltips["settings_website"] := hwnd1

	Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans HWNDhwnd gURL cAqua", % " ahk: formatting "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.URLs[hwnd] := "https://www.autohotkey.com/docs/v1/Hotkeys.htm", vars.hwnd.help_tooltips["settings_website|"] := hwnd1

	If !vars.client.stream || settings.features.leveltracker
	{
		Gui, %GUI%: Font, bold underline
		Gui, %GUI%: Add, Text, % "xs Section y+"vars.settings.spacing, % Lang_Trans("m_hotkeys_settings")
		Gui, %GUI%: Add, Pic, % "ys hp w-1 BackgroundTrans HWNDhwnd0", % "HBitmap:*" vars.pics.global.help
		Gui, %GUI%: Font, norm
		vars.hwnd.help_tooltips["settings_hotkeys ingame-keybinds"] := hwnd0
	}

	If !vars.client.stream && !vars.poe_version
	{
		Gui, %GUI%: Add, Checkbox, % "xs Section HWNDhwnd 0x400 gSettings_hotkeys2 Checked"settings.hotkeys.rebound_alt, % Lang_Trans("m_hotkeys_descriptions")
		vars.hwnd.settings.rebound_alt := hwnd
		If settings.hotkeys.rebound_alt
		{
			Gui, %GUI%: Add, Text, % "xs Section xp+" settings.general.fWidth * 1.5 " h" settings.general.fHeight, % Lang_Trans("m_hotkeys_descriptions", 2)
			Gui, %GUI%: font, % "s"settings.general.fSize - 4
			Gui, %GUI%: Add, Text, % "ys x+" settings.general.fWidth/2 " w" wEdits " hp BackgroundTrans Border"
			Gui, %GUI%: Add, Edit, % "xp yp wp hp Border gSettings_hotkeys2 HWNDhwnd cBlack", % settings.hotkeys.item_descriptions
			vars.hwnd.settings.item_descriptions := vars.hwnd.help_tooltips["settings_hotkeys formatting|"] := hwnd
			Gui, %GUI%: font, % "s"settings.general.fSize
		}
	}
	If !vars.client.stream
	{
		Gui, %GUI%: Add, Checkbox, % "xs Section x" x_anchor " HWNDhwnd 0x400 gSettings_hotkeys2 Checked" settings.hotkeys.rebound_c . (settings.hotkeys.rebound_c ? " cAqua" : ""), % Lang_Trans("m_hotkeys_ckey")
		vars.hwnd.settings.rebound_c := hwnd
	}

	If (settings.features.leveltracker * settings.leveltracker.fade * settings.leveltracker.fade_hover)
	{
		Gui, %GUI%: Add, Text, % "Section xs x" x_anchor " w" Max(wMovekey, wHotkeys, (settings.hotkeys.rebound_c ? wHotkeys2 : 0)) " Right Border HWNDhwnd1", % Lang_Trans("m_hotkeys_movekey") " "
		Gui, %GUI%: Font, % "s"settings.general.fSize - 4
		Gui, %GUI%: Add, Text, % "ys x+-1 hp BackgroundTrans Border w" wEdits
		Gui, %GUI%: Add, Edit, % "xp yp wp hp Border gSettings_hotkeys2 HWNDhwnd cBlack", % settings.hotkeys.movekey
		;Gui, %GUI%: Add, Pic, % "ys hp w-1 BackgroundTrans HWNDhwnd1", % "HBitmap:*" vars.pics.global.help
		vars.hwnd.settings.movekey := vars.hwnd.help_tooltips["settings_hotkeys formatting||"] := hwnd, vars.hwnd.help_tooltips["settings_hotkeys movekey"] := hwnd1, movekey := 1
		Gui, %GUI%: font, % "s"settings.general.fSize
	}

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "xs Section y+"vars.settings.spacing " x" x_anchor, % Lang_Trans("m_hotkeys_settings", 2)
	Gui, %GUI%: Font, norm

	Gui, %GUI%: Add, Text, % "ys Hidden Border BackgroundTrans gSettings_hotkeys2 cRed HWNDhwnd", % " " Lang_Trans("global_restart", 2) " "
	Gui, %GUI%: Add, Progress, % "Disabled Hidden xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	Gui, %GUI%: Add, Text, % "xp yp wp hp BackgroundTrans", % ""
	vars.hwnd.settings.apply := hwnd, vars.hwnd.settings.apply_bar := hwnd1

	Gui, %GUI%: Add, Text, % "Section xs w" (settings.hotkeys.rebound_c ? Max(wHotkeys, wHotkeys2, (movekey ? wMovekey : 0)) : Max(wHotkeys, (movekey ? wMovekey : 0))) " Right Border HWNDhwnd", % Lang_Trans("m_hotkeys_omnikey_new") " "
	;Gui, %GUI%: Add, Pic, % "ys hp w-1 BackgroundTrans HWNDhwnd", % "HBitmap:*" vars.pics.global.help
	vars.hwnd.help_tooltips["settings_hotkeys omnikey-info"] := hwnd

	Gui, %GUI%: Font, % "s" settings.general.fSize - 4
	Gui, %GUI%: Add, Text, % "ys x+-1 w" wEdits " hp Border BackgroundTrans"
	Gui, %GUI%: Add, Edit, % "xp yp wp hp Border cBlack HWNDhwnd gSettings_hotkeys2", % settings.hotkeys.omnikey
	Gui, %GUI%: Font, % "s" settings.general.fSize
	Gui, %GUI%: Add, Text, % "ys x+-1 Border HWNDhwnd1 cFF8000", % " " Lang_Trans("m_hotkeys_exclusive") " "
	vars.hwnd.settings.omnikey := vars.hwnd.help_tooltips["settings_hotkeys formatting|||"] := hwnd, vars.hwnd.help_tooltips["settings_hotkeys omniblock"] := hwnd1
	ControlGetPos, xEdit,, wEdit,,, % "ahk_id " hwnd
	;Gui, %GUI%: Add, Progress, % "Disabled Section xs cWhite h1 w" xEdit + wEdit - x_anchor - 1, 100

	If settings.hotkeys.rebound_c
	{
		Gui, %GUI%: Add, Text, % "Section xs w" Max(wHotkeys, wHotkeys2, (movekey ? wMovekey : 0)) " Right Border HWNDhwnd" (settings.hotkeys.rebound_c ? " cAqua" : ""), % StrReplace(Lang_Trans("m_hotkeys_omnikey_new"), Lang_Trans("global_colon")) " 2" Lang_Trans("global_colon") " "
		;Gui, %GUI%: Add, Pic, % "ys hp w-1 BackgroundTrans HWNDhwnd", % "HBitmap:*" vars.pics.global.help
		vars.hwnd.help_tooltips["settings_hotkeys omnikey2"] := hwnd

		Gui, %GUI%: Font, % "s" settings.general.fSize - 4
		Gui, %GUI%: Add, Text, % "ys x+-1 w" wEdits " hp Border BackgroundTrans"
		Gui, %GUI%: Add, Edit, % "xp yp wp hp Border cBlack HWNDhwnd gSettings_hotkeys2", % settings.hotkeys.omnikey2
		vars.hwnd.settings.omnikey2 := vars.hwnd.help_tooltips["settings_hotkeys formatting||||"] := hwnd
		Gui, %GUI%: Font, % "s" settings.general.fSize
		Gui, %GUI%: Add, Text, % "ys x+-1 Border HWNDhwnd cFF8000", % " " Lang_Trans("m_hotkeys_exclusive") " "
		vars.hwnd.help_tooltips["settings_hotkeys omniblock|"] := hwnd
		;Gui, %GUI%: Add, Progress, % "Disabled Section xs cWhite h1 w" xEdit + wEdit - x_anchor - 1, 100
	}

	Gui, %GUI%: Add, Text, % "Section xs w" (settings.hotkeys.rebound_c ? Max(wHotkeys, wHotkeys2, (movekey ? wMovekey : 0)) : Max(wHotkeys, (movekey ? wMovekey : 0))) " Right Border HWNDhwnd", % Lang_Trans("m_hotkeys_widget") " "
	;Gui, %GUI%: Add, Pic, % "ys hp w-1 BackgroundTrans HWNDhwnd", % "HBitmap:*" vars.pics.global.help
	vars.hwnd.help_tooltips["settings_hotkeys tab"] := hwnd

	Gui, %GUI%: Font, % "s"settings.general.fSize - 4
	Gui, %GUI%: Add, Text, % "ys x+-1 w" wEdits " hp Border BackgroundTrans"
	Gui, %GUI%: Add, Edit, % "xp yp wp hp Border cBlack HWNDhwnd gSettings_hotkeys2", % settings.hotkeys.tab
	vars.hwnd.settings.tab := vars.hwnd.help_tooltips["settings_hotkeys formatting|||||"] := hwnd
	Gui, %GUI%: Font, % "s"settings.general.fSize
	Gui, %GUI%: Add, Text, % "ys x+-1 Border BackgroundTrans HWNDhwnd gSettings_hotkeys2" (vars.settings.tabblock_provisional ? " cLime" : " cGray"), % " " Lang_Trans("m_hotkeys_exclusive") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.tabblock := hwnd, vars.hwnd.help_tooltips["settings_hotkeys omniblock||"] := hwnd1
	;Gui, %GUI%: Add, Progress, % "Disabled Section xs cWhite h1 w" xEdit + wEdit - x_anchor - 1, 100

	Gui, %GUI%: Add, Text, % "Section xs w" (settings.hotkeys.rebound_c ? Max(wHotkeys, wHotkeys2, (movekey ? wMovekey : 0)) : Max(wHotkeys, (movekey ? wMovekey : 0))) " Right Border HWNDhwnd", % Lang_Trans("m_hotkeys_menukey") " "
	;Gui, %GUI%: Add, Pic, % "ys hp w-1 BackgroundTrans HWNDhwnd", % "HBitmap:*" vars.pics.global.help
	vars.hwnd.help_tooltips["settings_hotkeys menu-widget alternative"] := hwnd
	Gui, %GUI%: Font, % "s" settings.general.fSize - 4
	Gui, %GUI%: Add, Text, % "ys x+-1 w" wEdits " hp Border BackgroundTrans"
	Gui, %GUI%: Add, Edit, % "xp yp wp hp Border HWNDhwnd gSettings_hotkeys2 cBlack", % settings.hotkeys.menuwidget
	vars.hwnd.settings.menuwidget := vars.hwnd.help_tooltips["settings_hotkeys formatting||||||"] := hwnd
	Gui, %GUI%: Font, % "s"settings.general.fSize

	Gui, %GUI%: Add, Text, % "Section xs w" (settings.hotkeys.rebound_c ? Max(wHotkeys, wHotkeys2, (movekey ? wMovekey : 0)) : Max(wHotkeys, (movekey ? wMovekey : 0))) " h" settings.general.fHeight * 2 - 1 " 0x200 Right Border HWNDhwnd", % Lang_Trans("m_hotkeys_restartkey") " "
	;Gui, %GUI%: Add, Pic, % "ys hp w-1 BackgroundTrans HWNDhwnd", % "HBitmap:*" vars.pics.global.help
	vars.hwnd.help_tooltips["settings_hotkeys restart"] := hwnd
	For index, val in ["ctrl", "alt"]
	{
		Gui, %GUI%: Add, Text, % (index = 1 ? "Section " : "") "ys x+-1 w" (index = 1 ? wCtrl : wEdits - wCtrl + 1) " Center Border BackgroundTrans gSettings_hotkeys2 HWNDhwnd" (settings.hotkeys["emergencykey_" val] ? " cLime" : " cGray"), % Lang_Trans("global_" val)
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings["emergencykey_" val] := hwnd, vars.hwnd.help_tooltips["settings_hotkeys modifiers" handle] := hwnd1, handle .= "|"
	}
	Gui, %GUI%: Font, % "s" settings.general.fSize - 4
	Gui, %GUI%: Add, Text, % "xs y+-1 w" wEdits " hp Border BackgroundTrans"
	Gui, %GUI%: Add, Edit, % "xp yp wp hp Border HWNDhwnd gSettings_hotkeys2 cBlack", % settings.hotkeys.emergencykey
	vars.hwnd.settings.emergencykey := vars.hwnd.help_tooltips["settings_hotkeys formatting|||||||"] := hwnd
}

Settings_hotkeys2(cHWND)
{
	local
	global vars, settings

	check := LLK_HasVal(vars.hwnd.settings, cHWND), keycheck := {}
	If (check = 0)
		check := A_GuiControl

	settings.hotkeys.item_descriptions := LLK_ControlGet(vars.hwnd.settings.item_descriptions)

	settings.hotkeys.omnikey := LLK_ControlGet(vars.hwnd.settings.omnikey)
	settings.hotkeys.omnikey2 := LLK_ControlGet(vars.hwnd.settings.omnikey2)
	settings.hotkeys.tab := LLK_ControlGet(vars.hwnd.settings.tab), settings.hotkeys.tabblock := vars.settings.tabblock_provisional
	settings.hotkeys.emergencykey := LLK_ControlGet(vars.hwnd.settings.emergencykey)
	settings.hotkeys.emergencykey_ctrl := vars.settings.emergencykey_ctrl_provisional, settings.hotkeys.emergencykey_alt := vars.settings.emergencykey_alt_provisional

	Switch check
	{
		Case "rebound_alt":
			settings.hotkeys.rebound_alt := LLK_ControlGet(cHWND)
			Settings_menu("hotkeys", 1)
		Case "rebound_c":
			settings.hotkeys.rebound_c := LLK_ControlGet(cHWND)
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
			For index, val in ["item_descriptions", "omnikey", "omnikey2", "tab", "emergencykey", "movekey", "menuwidget"]
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
			IniWrite, % """" LLK_ControlGet(vars.hwnd.settings.rebound_alt) """", % "ini" vars.poe_version "\hotkeys.ini", settings, advanced item-info rebound
			IniWrite, % """" LLK_ControlGet(vars.hwnd.settings.item_descriptions) """", % "ini" vars.poe_version "\hotkeys.ini", hotkeys, item-descriptions key
			IniWrite, % """" LLK_ControlGet(vars.hwnd.settings.rebound_c) """", % "ini" vars.poe_version "\hotkeys.ini", settings, c-key rebound

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
	{
		Gui, %Gui%: Add, Text, % "xs y+-1 h1 w" settings.general.fWidth * vars.settings.min_width
		Return
	}

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

	Gui, %GUI%: Add, Text, % "Section xs w" wActive " Border Right HWNDhwnd0", % Lang_Trans("global_active") " "
	Loop 5
	{
		Gui, %GUI%: Add, Text, % "ys x+-1 w" settings.general.fWidth*2 " Center Border BackgroundTrans HWNDhwnd gSettings_iteminfo2 c" (settings.iteminfo.profile = A_Index ? "Lime" : "White"), % A_Index
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.help_tooltips["settings_iteminfo profiles"] := hwnd0, handle .= "|", vars.hwnd.settings["profile_" A_Index] := hwnd, vars.hwnd.help_tooltips["settings_iteminfo profiles" handle] := hwnd1
	}

	Gui, %GUI%: Add, Text, % "xs y+-1 w" wActive " Border Right HWNDhwnd0", % Lang_Trans("global_name") " "
	Gui, %GUI%: Add, Text, % "yp x+-1 Border BackgroundTrans w" settings.general.fWidth * 10 - 4
	Gui, %GUI%: Font, % "s" settings.general.fSize - 4
	Gui, %GUI%: Add, Edit, % "xp yp wp hp Border cBlack gSettings_iteminfo2 HWNDhwnd", % settings.iteminfo["profile_name" profile]
	Gui, %GUI%: Add, Button, % "Hidden xp yp wp hp Default HWNDhwnd1 gSettings_iteminfo2", ok
	Gui, %GUI%: Font, % "s" settings.general.fSize
	vars.hwnd.settings.profile_name := vars.hwnd.help_tooltips["settings_iteminfo profile name"] := hwnd, vars.hwnd.help_tooltips["settings_iteminfo profile name|"] := hwnd0, vars.hwnd.settings.ok_button := hwnd1

	Gui, %GUI%: Add, Text, % "ys w" wReset " Center Border HWNDhwnd0", % Lang_Trans("m_iteminfo_profiles", 3)
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

	Gui, %GUI%: Add, Text, % "xs w" wActivation " Section Border Right", % Lang_Trans("global_activation") " "
	Gui, %Gui%: Add, Text, % "ys x+-1 Border BackgroundTrans HWNDhwnd gSettings_iteminfo2" (settings.iteminfo.activation = "toggle" ? " cLime" : ""), % " " Lang_Trans("global_toggle") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.activation_toggle := hwnd, vars.hwnd.help_tooltips["settings_iteminfo toggle"] := hwnd1

	Gui, %Gui%: Add, Text, % "ys x+-1 Border BackgroundTrans HWNDhwnd gSettings_iteminfo2" (settings.iteminfo.activation = "hold" ? " cLime" : ""), % " " Lang_Trans("global_hold") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.activation_hold := hwnd, vars.hwnd.help_tooltips["settings_iteminfo hold"] := hwnd1

	Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans gSettings_iteminfo2 HWNDhwnd" (settings.iteminfo.trigger ? " cLime" : " cGray"), % " " Lang_Trans("global_shiftclick") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.trigger := hwnd, vars.hwnd.help_tooltips["settings_iteminfo shift-click"] := hwnd1

	If vars.poe_version
	{
		Gui, %GUI%: Add, Text, % "Section xs w" wActivation " Border Right", % Lang_Trans("m_iteminfo_modbars") " "
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
	Else Gui, %GUI%: Add, Text, % "Section xs w" wActivation " Border Right", % Lang_Trans("m_iteminfo_modbars") " "

	Gui, %GUI%: Add, Text, % "ys" (vars.poe_version ? "" : " x+-1") " Border BackgroundTrans gSettings_iteminfo2 HWNDhwnd" (settings.iteminfo.modrolls ? " cLime" : " cGray"), % " " Lang_Trans("global_hide", 2) " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.modrolls := hwnd, vars.hwnd.help_tooltips["settings_iteminfo modrolls"] := hwnd1

	Gui, %GUI%: Add, Text, % "Section xs w" wActivation " Border Right", % Lang_Trans("m_iteminfo_affixinfo") " "
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

	Gui, %GUI%: Add, Text, % "Section xs Border BackgroundTrans HWNDhwnd0", % " " Lang_Trans("global_font") " "
	Gui, %GUI%: Add, Text, % "ys x+-1 Center gSettings_iteminfo2 Border BackgroundTrans HWNDhwnd w"settings.general.fWidth*2, % "–"
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.help_tooltips["settings_font-size"] := hwnd0, vars.hwnd.settings.font_minus := hwnd, vars.hwnd.help_tooltips["settings_font-size|"] := hwnd1

	Gui, %GUI%: Add, Text, % "ys x+-1 Center gSettings_iteminfo2 Border BackgroundTrans HWNDhwnd w"settings.general.fWidth*3, % settings.iteminfo.fSize
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.font_reset := hwnd, vars.hwnd.help_tooltips["settings_font-size||"] := hwnd1

	Gui, %GUI%: Add, Text, % "ys x+-1 Center gSettings_iteminfo2 Border BackgroundTrans HWNDhwnd w"settings.general.fWidth*2, % "+"
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.font_plus := hwnd, vars.hwnd.help_tooltips["settings_font-size|||"] := hwnd1

	Loop 2
	{
		Gui, %GUI%: Add, Text, % (A_Index = 1 ? "Section xs" : "ys") " Border HWNDhwnd0", % " " (A_Index = 1 ? Lang_Trans("global_global") : Lang_Trans("m_iteminfo_iclass")) " "
		Gui, %GUI%: Add, Text, % "ys x+-1 w" settings.general.fWidth//2 " Border BackgroundTrans gSettings_iteminfo2 HWNDhwnd"
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border BackgroundBlack HWNDhwnd2 c" settings.iteminfo.colors_marking[A_Index + A_Index//2], 100
		Gui, %GUI%: Add, Text, % "ys x+-1 Border BackgroundTrans gSettings_iteminfo2 HWNDhwnd3 w" settings.general.fWidth//2
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border BackgroundBlack HWNDhwnd4 c" settings.iteminfo.colors_marking[A_Index + A_Index//2 + 1], 100
		vars.hwnd.settings["marking_desired" (A_Index = 1 ? "" : "_class")] := hwnd, vars.hwnd.settings["marking_desired" (A_Index = 1 ? "" : "_class") "_bar"] := hwnd2
		vars.hwnd.settings["marking_undesired" (A_Index = 1 ? "" : "_class")] := hwnd3, vars.hwnd.settings["marking_undesired" (A_Index = 1 ? "" : "_class") "_bar"] := hwnd4
		vars.hwnd.help_tooltips["settings_iteminfo marking " (A_Index = 1 ? "global" : "class")] := hwnd0
		vars.hwnd.help_tooltips["settings_iteminfo marking " (A_Index = 1 ? "global" : "class") "|"] := hwnd2, vars.hwnd.help_tooltips["settings_iteminfo marking " (A_Index = 1 ? "global" : "class") "||"] := hwnd4
	}

	Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans gSettings_iteminfo2 HWNDhwnd" (settings.iteminfo.override ? " cLime" : " cGray"), % " " Lang_Trans("m_iteminfo_overridetier") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.override := hwnd, vars.hwnd.help_tooltips["settings_iteminfo override"] := hwnd1

	Loop 8
	{
		parse := (A_Index = 1 ? 7 : A_Index - 2)
		If (A_Index = 1)
			Gui, %GUI%: Add, Text, % "Section xs w" wTier " Right Border HWNDhwnd0", % Lang_Trans("global_tier") . Lang_Trans("global_colon") " "
		Gui, %GUI%: Add, Text, % "ys x+-1 w" settings.general.fWidth*3 " cBlack Center Border BackgroundTrans gSettings_iteminfo2 HWNDhwnd", % (A_Index = 1 ? Lang_Trans("m_iteminfo_fractured") : (A_Index = 2 ? "#" : parse))
		vars.hwnd.help_tooltips["settings_iteminfo item-tier"] := hwnd0, vars.hwnd.settings["tier_"parse] := hwnd, handle := (A_Index = 1) ? "|" : handle "|"
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd BackgroundBlack c" settings.iteminfo.colors_tier[parse], 100
		vars.hwnd.settings["tierbar_"parse] := vars.hwnd.help_tooltips["settings_iteminfo item-tier" handle] := hwnd
	}

	If (settings.iteminfo.affixinfo = 2)
		Loop 8
		{
			If (A_Index = 1)
				Gui, %GUI%: Add, Text, % "Section xs w" wTier " Right Border HWNDhwnd00", % Lang_Trans("global_ilvl") . Lang_Trans("global_colon") " "
			color := (settings.iteminfo.colors_ilvl[A_Index] = "ffffff") && (A_Index = 1) ? "Red" : "Black", vars.hwnd.help_tooltips["settings_iteminfo item-level"] := hwnd00, handle := (A_Index = 1) ? "|" : handle "|"
			Gui, %GUI%: Add, Text, % "ys x+-1 w" settings.general.fWidth*3 " c" color " Border Center BackgroundTrans gSettings_iteminfo2 HWNDhwnd0", % settings.iteminfo.ilevels[A_Index]
			Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd BackgroundBlack c"settings.iteminfo.colors_ilvl[A_Index], 100
			vars.hwnd.settings["ilvl_"A_Index] := hwnd0, vars.hwnd.settings["ilvlbar_"A_Index] := vars.hwnd.help_tooltips["settings_iteminfo item-level"handle] := hwnd
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
	static fSize, wImport, wEdit, wLeague, wReset, wPob, wOptionals, wChar, DDL, wDDL

	GUI := "settings_menu" vars.settings.GUI_toggle, x_anchor := vars.settings.x_anchor, margin := Round(settings.general.fWidth/4)

	Gui, %GUI%: Add, Text, % "Section x" x_anchor " y" vars.settings.ySelection " Border BackgroundTrans gSettings_leveltracker2 HWNDhwnd" (settings.features.leveltracker ? " cLime" : " cGray"), % " " Lang_Trans("global_enable") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.enable := hwnd, vars.hwnd.help_tooltips["settings_leveltracker enable"] := hwnd1

	Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans HWNDhwnd gURL cAqua", % " wiki page "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.URLs := {}, vars.URLs[hwnd] := "https://github.com/Lailloken/Exile-UI/wiki/Act‐Tracker", vars.hwnd.help_tooltips["settings_website"] := hwnd1

	If !settings.features.leveltracker
	{
		Gui, %Gui%: Add, Text, % "xs y+-1 h1 w" settings.general.fWidth * vars.settings.min_width
		Return
	}

	If !IsObject(db.leveltracker)
		DB_Load("leveltracker")

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "xs Section y+"vars.settings.spacing, % Lang_Trans("global_general")
	Gui, %GUI%: Font, norm
	Gui, %GUI%: Add, Button, % "ys Hidden hp Default gSettings_leveltracker2 HWNDhwnd w" settings.general.fWidth, ok
	vars.hwnd.settings.apply_button := hwnd

	If !vars.client.stream
	{
		Gui, %GUI%: Add, Text, % "xs Section Border BackgroundTrans gSettings_leveltracker2 HWNDhwnd" (settings.leveltracker.timer ? " cLime" : " cGray"), % " " Lang_Trans("m_lvltracker_timer") " "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings.timer := hwnd, vars.hwnd.help_tooltips["settings_leveltracker timer"] := hwnd1
	}
	Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans gSettings_leveltracker2 HWNDhwnd" (settings.leveltracker.fade ? " cLime": " cGray"), % " " Lang_Trans("m_lvltracker_fadeout") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.fade := hwnd, vars.hwnd.help_tooltips["settings_leveltracker fade-timer"] := hwnd1

	If settings.leveltracker.fade
	{
		Gui, %GUI%: Font, % "s"settings.general.fSize - 4
		Gui, %GUI%: Add, Text, % "ys x+-1 hp Border BackgroundTrans w" settings.general.fWidth*2
		Gui, %GUI%: Add, Edit, % "xp yp wp hp Border cBlack Center gSettings_leveltracker2 Limit1 Number HWNDhwnd", % !settings.leveltracker.fadetime ? 0 : Round(settings.leveltracker.fadetime/1000)
		Gui, %GUI%: Font, % "s"settings.general.fSize
		vars.hwnd.settings.fadetime := hwnd, vars.hwnd.help_tooltips["settings_leveltracker fade-timer|"] := hwnd

		Gui, %GUI%: Add, Text, % "ys x+-1 Border BackgroundTrans gSettings_leveltracker2 HWNDhwnd" (settings.leveltracker.fade_hover ? " cLime" : " cGray"), % " " Lang_Trans("m_lvltracker_fadeout", 2) " "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings.fade_hover := hwnd, vars.hwnd.help_tooltips["settings_leveltracker fade mouse"] := hwnd1
	}

	Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans gSettings_leveltracker2 HWNDhwnd" (settings.leveltracker.recommend ? " cLime" : " cGray"), % " " Lang_Trans("m_lvltracker_lvltips") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.recommend := hwnd, vars.hwnd.help_tooltips["settings_leveltracker recommendation"] := hwnd1

	Gui, %GUI%: Add, Text, % (settings.leveltracker.fade ? "Section xs" : "ys") " Border BackgroundTrans HWNDhwnd gSettings_leveltracker2" (settings.leveltracker.autotrack ? " cLime" : " cGray"), % " " Lang_Trans("m_lvltracker_autotracking") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.autotrack := hwnd, vars.hwnd.help_tooltips["settings_leveltracker auto tracking"] := hwnd1

	If !vars.client.stream && !vars.poe_version
	{
		Gui, %GUI%: Add, Text, % (!settings.leveltracker.fade ? "Section xs" : "ys") " Border BackgroundTrans gSettings_leveltracker2 HWNDhwnd" (settings.leveltracker.geartracker ? " cLime" : " cGray"), % " " Lang_Trans("m_lvltracker_gear") " "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings.geartracker := hwnd, vars.hwnd.help_tooltips["settings_leveltracker geartracker"] := hwnd1
	}

	line_break := (!vars.poe_version && settings.leveltracker.fade || vars.poe_version && !settings.leveltracker.fade)
	Gui, %GUI%: Add, Text, % "Section " (line_break ? "xs" : "ys") " Border BackgroundTrans Center gSettings_leveltracker2 HWNDhwnd" (settings.leveltracker.hotkeys ? " cLime w" settings.general.fWidth * 16 - 3  : " cGray"), % " " Lang_Trans("m_lvltracker_pagehotkeys") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.hotkeys_enable := hwnd, vars.hwnd.help_tooltips["settings_leveltracker hotkeys enable"] := hwnd1

	If settings.leveltracker.hotkeys
	{
		width := settings.general.fWidth * 6
		Gui, %GUI%: Font, % "s" settings.general.fSize - 4
		Gui, %GUI%: Add, Text, % "xs y+-1 w" width " hp Border BackgroundTrans"
		Gui, %GUI%: Add, Edit, % "xp yp wp hp Border Right cBlack HWNDhwnd1 gSettings_leveltracker2", % settings.leveltracker.hotkey_1
		Gui, %GUI%: Font, % "s" settings.general.fSize
		Gui, %GUI%: Add, Text, % "yp x+-1 w" settings.general.fWidth * 2 " hp Center 0x200 BackgroundTrans Border", % "<"
		Gui, %GUI%: Add, Text, % "yp x+-1 wp hp Center 0x200 BackgroundTrans Border", % ">"
		Gui, %GUI%: Font, % "s" settings.general.fSize - 4
		Gui, %GUI%: Add, Text, % "yp x+-1 w" width " hp Border BackgroundTrans"
		Gui, %GUI%: Add, Edit, % "xp yp wp hp Border cBlack HWNDhwnd2 Limit gSettings_leveltracker2", % settings.leveltracker.hotkey_2
		Gui, %GUI%: Font, % "s" settings.general.fSize
		vars.hwnd.settings.hotkey_1 := vars.hwnd.help_tooltips["settings_leveltracker hotkeys"] := hwnd1, vars.hwnd.settings.hotkey_2 := vars.hwnd.help_tooltips["settings_leveltracker hotkeys|"] := hwnd2
	}

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "Section xs x" x_anchor " yp+" settings.general.fHeight + vars.settings.spacing, % Lang_Trans("m_lvltracker_guide")
	Gui, %GUI%: Font, norm

	files := [0, 0, 0, 0, 0, 0, 0, 0, 0], handle := ""
	Loop, Files, % "ini" vars.poe_version "\leveling guide*.ini"
		index := SubStr(StrReplace(A_LoopFileName, ".ini"), 0), index := IsNumber(index) ? index : 1, files[index] := 1, max_index := (index > max_index ? index : max_index)

	Loop, % max_index
	{
		color := (!files[A_Index] ? " cLime" : (settings.leveltracker.profile = (A_Index = 1 ? "" : A_Index) ? " cLime" : ""))
		If !files[A_Index]
			Gui, %GUI%: Font, % "bold s" settings.general.fSize + 4
		Gui, %GUI%: Add, Text, % "ys x+" margin * (A_Index = 1 ? 2 : 1) " Center Border 0x200 BackgroundTrans HWNDhwnd gSettings_leveltracker2 w" settings.general.fWidth * 2 " h" settings.general.fHeight . color, % files[A_Index] ? A_Index : "+"
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border Range0-500 HWNDhwnd1 Vertical Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 500
		If !files[A_Index]
			Gui, %GUI%: Font, % "norm s" settings.general.fSize
		index := (A_Index = 1 ? "" : A_Index), vars.hwnd.settings["profile" index "_bar"] := hwnd1
		vars.hwnd.settings["profile" index] := hwnd, vars.hwnd.settings["profile" index "|"] := vars.hwnd.help_tooltips["settings_leveltracker profile " (files[A_Index] ? "select" : "create") . handle] := hwnd1, handle .= "|"
	}

	If (max_index != 9)
	{
		If max_index
			Gui, %GUI%: Font, % "bold s" settings.general.fSize + 4
		Gui, %GUI%: Add, Text, % "ys x+" margin * (!max_index ? 2 : 1) " Center Border 0x200 cLime BackgroundTrans HWNDhwnd gSettings_leveltracker2" (max_index ? " w" settings.general.fWidth * 2 : "") " h" settings.general.fHeight, % (!max_index ? " " Lang_Trans("global_load") " " : "+")
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings["profile" max_index + 1] := hwnd, vars.hwnd.help_tooltips["settings_leveltracker profile create" handle] := hwnd1
		Gui, %GUI%: Font, % "norm s" settings.general.fSize
	}

	Gui, %GUI%: Add, Pic, % "ys hp w-1 HWNDhwnd", % "HBitmap:*" vars.pics.global.help
	vars.hwnd.help_tooltips["settings_leveltracker guide info"] := hwnd

	handle := "", bandits := ["none", "alira", "kraityn", "oak"], profile := settings.leveltracker.profile, files := 0
	If (fSize != settings.general.fSize)
	{
		fSize := settings.general.fSize
		LLK_PanelDimensions([Lang_Trans("global_import")], fSize, wImport, hImport)
		LLK_PanelDimensions([Lang_Trans("global_edit")], fSize, wEdit, hEdit)
		LLK_PanelDimensions([Lang_Trans("m_lvltracker_leaguestart")], fSize, wLeague, hLeague)
		If (wLeague > wEdit + wImport + margin)
			wEdit := wLeague - wImport - margin
		Else wLeague := wEdit + wImport + margin

		LLK_PanelDimensions([Lang_Trans("global_reset")], fSize, wReset, hReset)
		LLK_PanelDimensions(["pob"], fSize, wPob, hPob)
		LLK_PanelDimensions([Lang_Trans("m_lvltracker_optionals")], fSize, wOptionals, hOptionals)
		If (wOptionals > wReset + wPob + margin)
			wPob := wOptionals - wReset - margin
		Else wOptionals := wReset + wPob + margin

		DDL := [Lang_Trans("global_none"), Lang_Trans("m_lvltracker_bandits"), Lang_Trans("m_lvltracker_bandits", 2), Lang_Trans("m_lvltracker_bandits", 3)]
		LLK_PanelDimensions(DDL, fSize, wDDL, hDDL)
	}

	If max_index
	{
		Gui, %GUI%: Add, Text, % "Section xs Center Border BackgroundTrans gSettings_leveltracker2 HWNDhwnd w" wImport, % Lang_Trans("global_import")
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings["import"] := hwnd, vars.hwnd.help_tooltips["settings_leveltracker import"] := hwnd1

		Gui, %GUI%: Add, Text, % "ys x+" margin " Center Border BackgroundTrans gSettings_leveltracker2 HWNDhwnd w" wEdit, % Lang_Trans("global_edit")
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings["editprofile"] := hwnd, vars.hwnd.help_tooltips["settings_leveltracker editor"] := hwnd1

		Gui, %GUI%: Add, Text, % "ys x+" margin " Center Border BackgroundTrans gSettings_leveltracker2 HWNDhwnd w" wReset, % Lang_Trans("global_reset")
		color := (settings.leveltracker["guide" profile].info.custom ? "FF8000" : vars.settings.cButtons2)
		Gui, %GUI%: Add, Progress, % "xp yp wp hp Border Disabled HWNDhwnd1 Vertical Range0-500 Background" color " c" vars.settings.cButtons, 500
		vars.hwnd.settings["reset"] := hwnd, vars.hwnd.settings.resetbar := vars.hwnd.help_tooltips["settings_leveltracker reset" (settings.leveltracker["guide" profile].info.custom ? " custom" : "")] := hwnd1

		If vars.leveltracker["pob" profile].Count()
		{
			Gui, %GUI%: Add, Text, % "ys x+" margin " Center BackgroundTrans cLime Border gSettings_leveltracker2 HWNDhwnd w" wPob, % "pob"
			Gui, %GUI%: Add, Progress, % "xp yp wp hp Border Disabled Vertical HWNDhwnd1 range0-500 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 500
			vars.hwnd.settings["pobpreview"] := hwnd, vars.hwnd.settings["pobpreview_bar"] := vars.hwnd.help_tooltips["settings_leveltracker pob preview"] := hwnd1
		}

		If !vars.poe_version
		{
			current_bandit := LLK_HasVal(bandits, settings.leveltracker["guide" profile].info.bandit), current_bandit := Lang_Trans((current_bandit = 1 ? "global_none" : "m_lvltracker_bandits"), Max(1, current_bandit - 1))
			Gui, %Gui%: Add, Text, % "ys x+" margin " hp Center Border", % " " Lang_Trans("m_lvltracker_bandit") . Lang_Trans("global_colon") " "
			Gui, %GUI%: Add, Text, % "x+-1 yp w" wDDL " hp 0x200 Border BackgroundTrans Center gSettings_leveltracker2 HWNDhwnd cLime", % current_bandit
			vars.ddl.bandit := {"cHWND": hwnd, "current": current_bandit, "list": DDL.Clone(), "fSize": settings.general.fSize, "color": vars.settings.cButtons}
			Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
			vars.hwnd.settings.bandit := hwnd, vars.hwnd.help_tooltips["settings_leveltracker bandit"] := hwnd1
		}

		Gui, %GUI%: Add, Text, % "Section xs y+" margin " Border BackgroundTrans gSettings_leveltracker2 HWNDhwnd c" (settings.leveltracker["guide" profile].info.leaguestart ? "Lime" : "Gray") " w" wLeague
		, % " " Lang_Trans("m_lvltracker_leaguestart")
		Gui, %GUI%: Add, Progress, % "xp yp wp hp Border Disabled Vertical HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings["leaguestart"] := hwnd, vars.hwnd.help_tooltips["settings_leveltracker leaguestart"] := hwnd1

		Gui, %GUI%: Add, Text, % "ys x+" margin " Border BackgroundTrans gSettings_leveltracker2 HWNDhwnd c" (settings.leveltracker["guide" profile].info.optionals ? "Lime" : "Gray") " w" wOptionals
		, % " " Lang_Trans("m_lvltracker_optionals")
		Gui, %GUI%: Add, Progress, % "xp yp wp hp Border Disabled Vertical HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings.optionals := hwnd, vars.hwnd.help_tooltips["settings_leveltracker optionals"] := hwnd1
		ControlGetPos, xOptionals,, wOptionals,,, ahk_id %hwnd%

		If !vars.poe_version
			If vars.leveltracker["pob" profile].gems.Count()
			{
				custom_gems := (settings.leveltracker["guide" profile].info.gems && vars.leveltracker["PoB" profile].vendors.Count())
				Gui, %GUI%: Add, Text, % "ys x+" margin " Border hp BackgroundTrans gSettings_leveltracker2 HWNDhwnd c" (settings.leveltracker["guide" profile].info.gems ? "Lime" : "Gray"), % " " Lang_Trans("m_lvltracker_gemquests") " "
				Gui, %GUI%: Add, Progress, % "Disabled xp+1 yp+1 wp-2 hp-2 HWNDhwnd1 Background" (custom_gems ? "FF8000" : vars.settings.cButtons2) " c" vars.settings.cButtons, 100
				vars.hwnd.settings.gems := hwnd, vars.hwnd.help_tooltips["settings_leveltracker gems"] := hwnd1
				hidden := (settings.leveltracker["guide" profile].info.gems ? "" : " Hidden")
				
				Gui, %GUI%: Add, Text, % "ys x+-1 Border BackgroundTrans gSettings_leveltracker2 HWNDhwnd c" (settings.leveltracker["guide" profile].info.gems_all ? "Lime" : "Gray") . hidden, % " " Lang_Trans("global_all") " "
				Gui, %GUI%: Add, Progress, % "xp yp wp hp Border Disabled Vertical HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons . hidden, 100
				vars.hwnd.settings.gems_all := hwnd, vars.hwnd.settings.gems_all_bar := vars.hwnd.help_tooltips["settings_leveltracker gems all"] := hwnd1
			}
			Else
			{
				Gui, %GUI%: Add, Text, % "ys x+" margin " Border hp BackgroundTrans gSettings_leveltracker2 HWNDhwnd c" (settings.leveltracker["guide" profile].info.gems_all ? "Lime" : "Gray"), % " " Lang_Trans("m_lvltracker_gemquests") " "
				Gui, %GUI%: Add, Progress, % "xp yp wp hp Border Disabled Vertical HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
				vars.hwnd.settings.gems_all := hwnd, vars.hwnd.settings.gems_all_bar := vars.hwnd.help_tooltips["settings_leveltracker gems all"] := hwnd1
			}

		Settings_CharTracking("leveltracker", xOptionals + wOptionals - x_anchor)

		Gui, %GUI%: Font, underline bold
		Gui, %GUI%: Add, Text, % "xs x" x_anchor " y+" vars.settings.spacing " Section BackgroundTrans", % Lang_Trans("global_ui")
		Gui, %GUI%: Font, norm

		Gui, %GUI%: Add, Text, % "xs Section Border HWNDhwnd0", % " " Lang_Trans("global_font") " "
		Gui, %GUI%: Add, Text, % "ys x+-1 Center gSettings_leveltracker2 Border BackgroundTrans HWNDhwnd w"settings.general.fWidth*2, % "–"
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.help_tooltips["settings_font-size"] := hwnd0, vars.hwnd.settings.font_minus := hwnd, vars.hwnd.help_tooltips["settings_font-size|"] := hwnd1
		Gui, %GUI%: Add, Text, % "ys x+-1 Center gSettings_leveltracker2 Border BackgroundTrans HWNDhwnd w"settings.general.fWidth*3, % settings.leveltracker.fSize
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings.font_reset := hwnd, vars.hwnd.help_tooltips["settings_font-size||"] := hwnd1
		Gui, %GUI%: Add, Text, % "ys x+-1 Center gSettings_leveltracker2 Border BackgroundTrans HWNDhwnd w"settings.general.fWidth*2, % "+"
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings.font_plus := hwnd, vars.hwnd.help_tooltips["settings_font-size|||"] := hwnd1

		Gui, %GUI%: Add, Text, % "ys Border", % " " Lang_Trans("global_opacity") " "
		Loop 5
		{
			Gui, %GUI%: Add, Text, % "ys x+-1 Center gSettings_leveltracker2 Border BackgroundTrans HWNDhwnd w" settings.general.fWidth * 2 (settings.leveltracker.trans = A_Index ? " cLime" : ""), % A_Index
			Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
			vars.hwnd.settings["opac_" A_Index] := hwnd
		}

		Gui, %GUI%: Font, bold underline
		Gui, %GUI%: Add, Text, % "xs Section x" x_anchor " y+" vars.settings.spacing, % Lang_Trans("m_lvltracker_poboverlays")
		Gui, %GUI%: Font, norm
		Gui, %GUI%: Add, Picture, % "ys BackgroundTrans hp HWNDhwnd0 w-1", % "HBitmap:*" vars.pics.global.help
		vars.hwnd.help_tooltips["settings_leveltracker skilltree-info"] := hwnd0

		If !settings.leveltracker.pobmanual && FileExist("data\global\[leveltracker] tree" vars.poe_version " *.json")
		{
			Gui, %GUI%: Add, Text, % "ys Center Border BackgroundTrans gSettings_leveltracker2 HWNDhwnd", % " " Lang_Trans("m_lvltracker_treeclear") " "
			Gui, %GUI%: Add, Progress, % "xp yp wp hp Disabled Border HWNDhwnd1 Vertical Range0-500 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 500
			vars.hwnd.settings.treeclear := hwnd, vars.hwnd.help_tooltips["settings_leveltracker skilltree clear"] := vars.hwnd.settings.treeclear_bar := hwnd1
		}

		Gui, %GUI%: Add, Checkbox, % "xs Section gSettings_leveltracker2 0x400 HWNDhwnd Checked" settings.leveltracker.gemlinksToggle, % Lang_Trans("m_lvltracker_pobgems")
		vars.hwnd.settings.pobgems := vars.hwnd.help_tooltips["settings_leveltracker pob gems"] := hwnd
		Gui, %GUI%: Add, Checkbox, % "xs Section gSettings_leveltracker2 0x400 HWNDhwnd Checked" settings.leveltracker.pobmanual, % Lang_Trans("m_lvltracker_pobmanual")
		vars.hwnd.settings.pobmanual := vars.hwnd.help_tooltips["settings_leveltracker pob manual"] := hwnd

		If settings.leveltracker.pobmanual
		{
			Gui, %GUI%: Add, Checkbox, % "xs Section gSettings_leveltracker2 0x400 HWNDhwnd Checked"settings.leveltracker.pob, % Lang_Trans("m_lvltracker_pob")
			vars.hwnd.settings.pob := vars.hwnd.help_tooltips["settings_leveltracker pob"] := hwnd
			Gui, %GUI%: Add, Text, % "xs Section gSettings_leveltracker2 Border HWNDhwnd", % " " Lang_Trans("m_lvltracker_screencap") " "
			vars.hwnd.settings.screencap := vars.hwnd.help_tooltips["settings_leveltracker screen-cap menu"] := hwnd
			Gui, %GUI%: Add, Text, % "ys x+" margin " gSettings_leveltracker2 Border HWNDhwnd", % " " Lang_Trans("global_imgfolder") " "
			vars.hwnd.settings.folder := vars.hwnd.help_tooltips["settings_leveltracker folder"] := hwnd
		}
		Else
		{
			Gui, %GUI%: Add, Text, % "Section xs h" settings.general.fHeight, % Lang_Trans("m_lvltracker_treehotkey")
			Gui, %GUI%: Font, % "s" settings.general.fSize - 4
			Gui, %GUI%: Add, Text, % "ys w" settings.general.fWidth * 10 " hp Border BackgroundTrans" 
			Gui, %GUI%: Add, Edit, % "xp yp wp hp Border gSettings_leveltracker2 cBlack HWNDhwnd", % settings.leveltracker.tree_hotkey
			vars.hwnd.settings.tree_hotkey := vars.hwnd.help_tooltips["settings_leveltracker tree hotkey"] := hwnd
			Gui, %GUI%: Font, % "s" settings.general.fSize
			Gui, %GUI%: Add, Text, % "ys hp Border cRed 0x200 gSettings_leveltracker2 Hidden HWNDhwnd1", % " " Lang_Trans("global_save") " "
			vars.hwnd.settings.tree_hotkey_save := hwnd1
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
			GuiControl, % "-Hidden", % vars.hwnd.settings.tree_hotkey_save
		Else GuiControl, % "+Hidden", % vars.hwnd.settings.tree_hotkey_save
		GuiControl, % "movedraw", % vars.hwnd.settings.tree_hotkey_save
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
		IniWrite, % (settings.leveltracker.gemlinksToggle := LLK_ControlGet(cHWND)), % "ini" vars.poe_version "\leveling tracker.ini", settings, toggle gem-links
	Else If (check = "pobmanual")
	{
		IniWrite, % (settings.leveltracker.pobmanual := LLK_ControlGet(cHWND)), % "ini" vars.poe_version "\leveling tracker.ini", settings, manual pob-screencap
		Settings_menu("leveling tracker")
	}
	Else If (check = "pob")
		IniWrite, % (settings.leveltracker.pob := LLK_ControlGet(cHWND)), % "ini" vars.poe_version "\leveling tracker.ini", settings, enable pob-screencap
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
		GuiControl, % "+c" (input ? "Lime" : "Gray"), % cHWND
		GuiControl, % "movedraw", % cHWND
		GuiControl, % "+Background" (input && vars.leveltracker["PoB" profile].vendors.Count() ? "FF8000" : vars.settings.cButtons2), % vars.hwnd.help_tooltips["settings_leveltracker gems"]

		GuiControl, % (input ? "-" : "+") "Hidden", % vars.hwnd.settings.gems_all
		GuiControl, % (input ? "-" : "+") "Hidden", % vars.hwnd.settings.gems_all_bar
		GuiControl, % "+cGray", % vars.hwnd.settings.gems_all
		GuiControl, % "movedraw", % vars.hwnd.settings.gems_all
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
		WinGetPos, xControl, yControl, wControl, hControl, % "ahk_id " cHWND
		If Blank(input := Gui_DropDownList(vars.ddl.bandit, [xControl, yControl, wControl, hControl], "Center", 1)) || IsObject(input) && Blank(input.1 . input.2)
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
		LLK_FontDimensions(settings.leveltracker.fSize, height, width), settings.leveltracker.fHeight := height, settings.leveltracker.fWidth := width
		LLK_FontDimensions(settings.leveltracker.fSize - 2, height, width), settings.leveltracker.fHeight2 := height, settings.leveltracker.fWidth2 := width
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
	{
		Gui, %Gui%: Add, Text, % "xs y+-1 h1 w" settings.general.fWidth * vars.settings.min_width
		Return
	}

	If (fSize != settings.general.fSize)
	{
		fSize := settings.general.fSize
		LLK_PanelDimensions([Lang_Trans("global_ctrl"), Lang_Trans("global_alt")], fSize, wALT, hALT)
		LLK_PanelDimensions([Lang_Trans("global_size") . Lang_Trans("global_colon"), Lang_Trans("global_opacity"), Lang_Trans("global_volume") . Lang_Trans("global_colon"), Lang_Trans("global_sound", 2) . Lang_Trans("global_colon"), Lang_Trans("global_test"), Lang_Trans("global_restore")], fSize, wSize, hSize)
	}

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "xs Section y+" vars.settings.spacing, % Lang_Trans("global_general")
	Gui, %GUI%: Font, norm
	

	Gui, %GUI%: Add, Text, % "xs Section Border HWNDhwnd", % " " Lang_Trans("m_cheat_modifier") " "
	For index, val in ["alt", "ctrl"]
	{
		Gui, %GUI%: Add, Text, % "ys x+-1 Border BackgroundTrans Center gSettings_lootfilter2 HWNDhwnd" index " c" (settings.lootfilter.modifier_key = val ? "Lime" : "White") " w" wALT, % Lang_Trans("global_" val)
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd_bar" index " Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	}
	vars.hwnd.help_tooltips["settings_lootfilter modifier keys"] := hwnd
	vars.hwnd.settings.modifierkey_alt := hwnd1, vars.hwnd.help_tooltips["settings_lootfilter modifier keys|"] := hwnd_bar1
	vars.hwnd.settings.modifierkey_ctrl := hwnd2, vars.hwnd.help_tooltips["settings_lootfilter modifier keys||"] := hwnd_bar2

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "xs Section y+" vars.settings.spacing, % Lang_Trans("global_ui")
	Gui, %GUI%: Font, norm

	Gui, %GUI%: Add, Text, % "xs Section Border HWNDhwnd", % " " Lang_Trans("global_font") " "
	vars.hwnd.help_tooltips["settings_font-size"] := hwnd
	Gui, %GUI%: Add, Text, % "ys x+-1 gSettings_lootfilter2 Border BackgroundTrans Center HWNDhwnd w" settings.general.fWidth*2, % "–"
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.font_minus := hwnd, vars.hwnd.help_tooltips["settings_font-size|"] := hwnd1

	Gui, %GUI%: Add, Text, % "x+-1 ys Border BackgroundTrans Center gSettings_lootfilter2 HWNDhwnd w" settings.general.fWidth*3, % settings.lootfilter.fSize
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.font_reset := hwnd, vars.hwnd.help_tooltips["settings_font-size||"] := hwnd1

	Gui, %GUI%: Add, Text, % "wp x+-1 ys gSettings_lootfilter2 Border BackgroundTrans Center HWNDhwnd w" settings.general.fWidth*2, % "+"
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.font_plus := hwnd, vars.hwnd.help_tooltips["settings_font-size|||"] := hwnd1

	Gui, %GUI%: Add, Text, % "ys Border HWNDhwnd", % " " Lang_Trans("m_lootfilter_colors") " "
	vars.hwnd.help_tooltips["settings_lootfilter colors"] := hwnd
	Gui, %GUI%: Add, Text, % "ys x+-1 w" settings.general.fWidth * 1.5 " Border BackgroundTrans gSettings_lootfilter2 HWNDhwnd"
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border BackgroundBlack HWNDhwnd1 c" settings.lootfilter.color_background, 100
	Gui, %GUI%: Add, Text, % "ys x+-1 w" settings.general.fWidth * 1.5 " Border BackgroundTrans gSettings_lootfilter2 HWNDhwnd2"
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border BackgroundBlack HWNDhwnd3 c" settings.lootfilter.color_accent, 100
	vars.hwnd.settings.color_background := hwnd, vars.hwnd.settings.color_background_bar := vars.hwnd.help_tooltips["settings_generic color"] := hwnd1
	vars.hwnd.settings.color_accent := hwnd2, vars.hwnd.settings.color_accent_bar := vars.hwnd.help_tooltips["settings_generic color|"] := hwnd3

	If !settings.lootfilter.active_filter || !vars.lootfilter.filters_list.Count()
		Return

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
	tester := vars.lootfilter_tester, types := ["size", "opacity", "volume"], ranges := {"size": "10-45", "opacity": "50-255", "volume": "0-300"}

	For outer, type in types
	{
		Gui, %GUI%: Add, Text, % "Section xs Right Border w" wSize, % StrReplace(Lang_Trans("global_" type), Lang_Trans("global_colon")) . Lang_Trans("global_colon") " "
		For key, val in {"i": "minimum", "ii": "medium", "iii": "maximum"}
		{
			label := Lang_Trans("global_" val, 2) . Lang_Trans("global_colon") " " settings.lootfilter[type "_" val]
			Gui, %GUI%: Add, Text, % "ys x+-1 Center Border gSettings_lootfilter2 HWNDhwnd w" settings.general.fHeight . (val = vars.lootfilter_tester[type] ? " cLime" : ""), % key
			vars.hwnd.settings[type "preset_" val] := vars.hwnd.help_tooltips["settings_lootfilter filter-tester presets" preset_handle] := hwnd, preset_handle .= "|"
		}
		Gui, %GUI%: Add, Slider, % "ys x+-1 hp Center NoTicks Range" ranges[type] " ToolTip Border gSettings_lootfilter2 HWNDhwnd w" 9 * settings.general.fHeight, % settings.lootfilter[type "_" tester[type]]
		Gui, %GUI%: Add, Text, % "ys x+-1 hp Border 0x200 HWNDhwnd1 gSettings_lootfilter2", % " " Lang_Trans("global_reset") " "
		vars.hwnd.settings[type "value"] := hwnd, vars.hwnd.settings["reset_" type] := hwnd1
	}

	cReset := LLK_ControlGetPos(hwnd1), DDL := []
	If !settings.lootfilter.sound_tags.HasKey(tester.sound)
		vars.lootfilter_tester.sound := LLK_HasVal(settings.lootfilter.sound_tags, tester.sound)
	vars.lootfilter_tester.sound_index := settings.lootfilter.sound_tags[tester.sound]

	For outer in [1, 2]
		For key, val in settings.lootfilter.sound_tags
			If (outer = 1) && !IsNumber(key) || (outer = 2) && IsNumber(key)
				DDL.Push(key)
		
	Loop, Parse, ddl, % "|"
		If (A_LoopField = vars.lootfilter_tester.sound)
			choice := A_Index

	Gui, %GUI%: Add, Text, % "Section xs Right Border w" wSize, % Lang_Trans("global_sound", 2) . Lang_Trans("global_colon") " "
	Gui, %GUI%: Font, % "s" settings.general.fSize - 2
	LLK_PanelDimensions(DDL, fSize - 2, wDDL, hDDL)

	Gui, %GUI%: Add, Text, % "ys x+-1 w" wDDL " hp Border BackgroundTrans gSettings_lootfilter2 HWNDhwnd cLime", % " " vars.lootfilter_tester.sound
	vars.ddl.sound_pick := {"cHWND": hwnd, "current": vars.lootfilter_tester.sound, "fSize": fSize - 2, "list": DDL.Clone(), "color": vars.settings.cButtons}
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	cDDL := LLK_ControlGetPos(hwnd)

	Gui, %GUI%: Font, % "s" settings.general.fSize - 4
	Gui, %GUI%: Add, Edit, % "ys x+0 hp Border Limit16 cBlack gSettings_lootfilter2 HWNDhwnd1 w" cReset.xMax - cDDL.xMax, % (IsNumber(vars.lootfilter_tester.sound) ? "" : vars.lootfilter_tester.sound)
	Gui, %GUI%: Add, Button, % "xp hp Hidden Default gSettings_lootfilter2 HWNDhwnd2", a
	vars.hwnd.settings.sound_pick := vars.hwnd.help_tooltips["settings_lootfilter filter-tester sounds"] := hwnd
	vars.hwnd.settings.sound_tag := vars.hwnd.help_tooltips["settings_lootfilter filter-tester sound tags"] := hwnd1, vars.hwnd.settings.sound_ok := hwnd2

	Gui, %GUI%: Font, % "s" settings.general.fSize
	Gui, %GUI%: Add, Text, % "Section xs y+" vars.settings.spacing " Center Border HWNDhwnd gSettings_lootfilter2 w" wSize, % Lang_Trans("global_test")
	Gui, %GUI%: Add, Text, % "Section xs wp Border Center HWNDhwnd1 gSettings_lootfilter2 BackgroundTrans", % Lang_Trans("global_restore")
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd2 BackgroundBlack cBlack", 100
	vars.hwnd.settings.tester_test := vars.hwnd.help_tooltips["settings_lootfilter filter-tester apply"] := hwnd
	vars.hwnd.settings.tester_restore := hwnd1, vars.hwnd.settings.tester_restore_bar := vars.hwnd.help_tooltips["settings_lootfilter filter-tester restore"] := hwnd2
}

Settings_lootfilter2(cHWND := "")
{
	local
	global vars, settings

	check := LLK_HasVal(vars.hwnd.settings, cHWND), control := SubStr(check, InStr(check, "_") + 1)
	If !RegExMatch(check, "i)font_")
	{
		KeyWait, LButton
		KeyWait, RButton
	}
	If (check = "sound_pick")
	{
		WinGetPos, xControl, yControl, wControl, hControl, % "ahk_id " cHWND
		If Blank(input := Gui_DropDownList(vars.ddl[check], [xControl, yControl, wControl, hControl]))
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
		type := SubStr(check, 1, InStr(check, "value") - 1), input := LLK_ControlGet(cHWND)
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
				GuiControl, % "+cBlack +BackgroundBlack", % vars.hwnd.settings.tester_restore_bar
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

	If (fSize != settings.general.fSize)
	{
		fSize := settings.general.fSize
		LLK_PanelDimensions([Lang_Trans("global_hotkey"), Lang_Trans("global_save")], fSize, wHotkey, hHotkey)
		LLK_PanelDimensions([Lang_Trans("m_macros_fasttravel"), Lang_Trans("m_macros_custom")], fSize, wHeader, hHeader,,, 0,,, "underline bold")
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
	Gui, %GUI%: Add, Text, % "Section xs Border HWNDhwnd", % " " Lang_Trans("m_general_menuwidget") " "
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
	Gui, %GUI%: Add, Text, % "Section xs y+"vars.settings.spacing " h" settings.general.fHeight " 0x200", % Lang_Trans("m_macros_fasttravel")
	Gui, %GUI%: Font, norm

	xPos := x_anchor + settings.general.fWidth + wHeader
	Gui, %GUI%: Add, Text, % "ys x" xPos " Right Border HWNDhwnd0 w" wHotkey, % Lang_Trans("global_hotkey") " "
	Gui, %GUI%: Add, Text, % "Hidden xp yp wp hp Border BackgroundTrans Center cRed gSettings_macros2 HWNDhwnd1", % Lang_Trans("global_save")
	Gui, %GUI%: Add, Progress, % "Disabled Hidden xp yp wp hp Border HWNDhwnd2 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	Gui, %GUI%: Font, % "s" settings.general.fSize - 4
	Gui, %GUI%: Add, Text, % "ys x+-1 w" settings.general.fWidth * 6 " hp Border BackgroundTrans"
	Gui, %GUI%: Add, Edit, % "xp yp wp hp Border HWNDhwnd gSettings_macros2 cBlack", % settings.macros.hotkey_fasttravel
	Gui, %GUI%: Font, % "s" settings.general.fSize
	vars.hwnd.settings.hotkey_fasttravel_label := vars.hwnd.help_tooltips["settings_macros fast-travel"] := hwnd0, vars.hwnd.settings.hotkey_fasttravel := vars.hwnd.help_tooltips["settings_macros hotkeys"] := hwnd
	vars.hwnd.settings.hotkeysave_fasttravel := hwnd1, vars.hwnd.settings.hotkeysave_fasttravel_bar := hwnd2

	If (settings.macros.sMenu != sMenu)
	{
		For key, hbm in vars.pics.settings_macros
			DeleteObject(hbm)
		vars.pics.settings_macros := {}, sMenu := settings.macros.sMenu
	}

	height := 4 * settings.macros.wMenu
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

	Gui, %GUI%: Add, Text, % "ys x" xPos " Border Right HWNDhwnd0 w" wHotkey, % Lang_Trans("global_hotkey") " "
	Gui, %GUI%: Add, Text, % "Hidden xp yp wp hp Border Center BackgroundTrans cRed gSettings_macros2 HWNDhwnd1", % " " Lang_Trans("global_save") " "
	Gui, %GUI%: Add, Progress, % "Hidden Disabled xp yp wp hp Border HWNDhwnd2 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	Gui, %GUI%: Font, % "s" settings.general.fSize - 4
	Gui, %GUI%: Add, Text, % "ys x+-1 w" settings.general.fWidth * 6 " hp Border BackgroundTrans"
	Gui, %GUI%: Add, Edit, % "xp yp wp hp Border HWNDhwnd gSettings_macros2 cBlack", % settings.macros.hotkey_custommacros
	Gui, %GUI%: Font, % "s" settings.general.fSize
	vars.hwnd.settings.hotkey_custommacros := vars.hwnd.help_tooltips["settings_macros hotkeys|"] := hwnd, vars.hwnd.settings.hotkey_custommacros_label := vars.hwnd.help_tooltips["settings_macros custom"] :=  hwnd0
	vars.hwnd.settings["hotkeysave_custommacros"] := hwnd1, vars.hwnd.settings.hotkeysave_custommacros_bar := hwnd2
	wEdit := wHeader + wHotkey - settings.general.fHeight - 2*margin + 3*settings.general.fWidth - 1

	Loop 9
	{
		Gui, %GUI%: Add, Text, % "Section xs w" settings.general.fHeight " Center HWNDhwnd0 Border BackgroundTrans gSettings_macros2", % A_Index - 1
		enabled := (settings.macros["enable_" A_Index - 1] && (!Blank(settings.macros["label_" A_Index - 1]) || A_Index = 1) && !Blank(settings.macros["command_" A_Index - 1]) ? 1 : 0)
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd01 Background" (enabled ? "Lime" : "Black") " c" vars.settings.cButtons, 100
		Gui, %GUI%: Font, % "s" settings.general.fSize - 4
		Gui, %GUI%: Add, Text, % "ys w" settings.general.fwidth * 4 " hp Border BackgroundTrans"
		Gui, %GUI%: Add, Edit, % "xp yp wp hp Border cBlack HWNDhwnd Limit3 gSettings_macros2" (A_Index = 1 ? " Disabled" : ""), % settings.macros["label_" A_Index - 1]
		Gui, %GUI%: Add, Text, % "ys w" wEdit " hp Border BackgroundTrans"
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
			GuiControl, % "+Background" (settings.macros["enable_" control] ? "Lime" : "Black"), % vars.hwnd.settings["enable_" control "_bar"]

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
	{
		Gui, %Gui%: Add, Text, % "xs y+-1 h1 w" settings.general.fWidth * vars.settings.min_width
		Return
	}

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

	Gui, %GUI%: Add, Text, % "xs Section Right Border", % " " Lang_Trans("global_activation") " "
	Gui, %Gui%: Add, Text, % "ys x+-1 Border BackgroundTrans HWNDhwnd gSettings_mapinfo2" (settings.mapinfo.activation = "toggle" ? " cLime" : ""), % " " Lang_Trans("global_toggle") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.activation_toggle := hwnd, vars.hwnd.help_tooltips["settings_mapinfo toggle"] := hwnd1

	Gui, %Gui%: Add, Text, % "ys x+-1 Border BackgroundTrans HWNDhwnd gSettings_mapinfo2" (settings.mapinfo.activation = "hold" ? " cLime" : ""), % " " Lang_Trans("global_hold") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.activation_hold := hwnd, vars.hwnd.help_tooltips["settings_mapinfo hold"] := hwnd1

	Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans gSettings_mapinfo2 HWNDhwnd" (settings.mapinfo.trigger ? " cLime" : " cGray"), % " " Lang_Trans("global_shiftclick") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.shiftclick := hwnd, vars.hwnd.help_tooltips["settings_mapinfo shift-click"] := hwnd1

	Gui, %GUI%: Add, Text, % "Section xs Border Right", % " " Lang_Trans("global_position") . Lang_Trans("global_colon") " "
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
	Gui, %GUI%: Add, Text, % "Section xs" (vars.poe_version ? "" : " w" wFont) " Right Border HWNDhwnd0", % (vars.poe_version ? " " : "") Lang_Trans("global_font") " "
	Gui, %GUI%: Add, Text, % "ys x+-1 Center Border BackgroundTrans gSettings_mapinfo2 HWNDhwnd w"settings.general.fWidth*2, % "–"
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.help_tooltips["settings_font-size"] := hwnd0, vars.hwnd.settings.font_minus := hwnd, vars.hwnd.help_tooltips["settings_font-size|"] := hwnd1

	Gui, %GUI%: Add, Text, % "ys x+-1 Center Border BackgroundTrans gSettings_mapinfo2 HWNDhwnd w"settings.general.fWidth*3, % settings.mapinfo.fSize
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.font_reset := hwnd, vars.hwnd.help_tooltips["settings_font-size||"] := hwnd1

	Gui, %GUI%: Add, Text, % "ys x+-1 Center Border BackgroundTrans gSettings_mapinfo2 HWNDhwnd w"settings.general.fWidth*2, % "+"
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.font_plus := hwnd, vars.hwnd.help_tooltips["settings_font-size|||"] := hwnd1, handle := ""

	Gui, %GUI%: Add, Text, % "ys w" wMapmods " Right Border HWNDhwnd", % Lang_Trans("m_mapinfo_mapmods") " "
	vars.hwnd.help_tooltips["settings_mapinfo mapmod colors"] := hwnd

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
		Gui, %GUI%: Add, Progress, % "xp yp wp hp HWNDhwnd11 Border BackgroundBlack c" settings.mapinfo.roll_colors.2, 100
		Gui, %GUI%: Add, Text, % "ys x+-1 w" settings.general.fWidth " BackgroundTrans gSettings_mapinfo2 HWNDhwnd2 Border", % " "
		Gui, %GUI%: Add, Progress, % "xp yp wp hp HWNDhwnd21 Border BackgroundBlack c" settings.mapinfo.roll_colors.1, % 100
		Gui, %GUI%: Add, Text, % "ys x+-1 w" settings.general.fWidth " BackgroundTrans gSettings_mapinfo2 HWNDhwnd3 Border", % " "
		Gui, %GUI%: Add, Progress, % "xp yp wp hp HWNDhwnd31 Border BackgroundBlack c" settings.mapinfo.roll_colors.2, % 100
		Loop 3
			vars.hwnd.help_tooltips["settings_mapinfo roll colors" handle] := hwnd%A_Index%1, handle .= "|"
		vars.hwnd.settings.rollcolor_text := hwnd1, vars.hwnd.settings.rollcolor_back := hwnd11
		vars.hwnd.settings.rollcolor_1 := hwnd2, vars.hwnd.settings.rollcolor_11 := hwnd21
		vars.hwnd.settings.rollcolor_2 := hwnd3, vars.hwnd.settings.rollcolor_21 := hwnd31, handle := ""
	}

	If !vars.poe_version
	{
		Gui, %GUI%: Add, Text, % "ys x" x_anchor + wFont + settings.general.fWidth * 7 - 3 + margin " w" wMapmods " Right Border HWNDhwnd", % Lang_Trans("m_mapinfo_logbooks") " "
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
		For index, val in ["quantity", "rarity", "pack size", "maps", "scarabs", "currency", "waystones"]
		{
			If vars.poe_version && LLK_IsBetween(index, 4, 6) || !vars.poe_version && (index = 7)
				Continue
			Gui, %GUI%: Add, Text, % (A_Index = 1 ? "xs Section" : "ys x+" settings.general.fWidth//2) " Center HWNDhwnd Border w" settings.general.fWidth * 2, % Lang_Trans("maps_stats", A_Index + 1)
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
	Gui, %GUI%: Add, Progress, % "Disabled Range0-500 Vertical xp yp wp hp HWNDhwnd2 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 500
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
				Gui, %GUI%: Add, Text, % style " Border Center HWNDhwnd c" color, % " " text " "
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
			WinGetPos, xControl, yControl, wControl, hControl, % "ahk_id " cHWND
			input := Gui_DropDownList(vars.ddl.mapinfo_position, [xControl, yControl, wControl, hControl], "Center", 1)
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
	{
		Gui, %Gui%: Add, Text, % "xs y+-1 h1 w" settings.general.fWidth * vars.settings.min_width
		Return
	}
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

	Gui, %GUI%: Add, Text, % "Section xs Border HWNDhwnd0", % " " Lang_Trans("global_panelsize") " "
	Gui, %GUI%: Add, Text, % "ys x+-1 w"settings.general.fWidth*2 " Center gSettings_maptracker2 Border BackgroundTrans HWNDhwnd", % "–"
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.help_tooltips["settings_font-size"] := hwnd0, vars.hwnd.settings.font_minus := hwnd, vars.hwnd.help_tooltips["settings_font-size|"] := hwnd1

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
	Gui, %GUI%: Add, Text, % "ys x+0 Border BackgroundTrans gSettings_maptracker2 HWNDhwnd" (settings.maptracker.kills ? " cLime" : " cGray"), % " " Lang_Trans("m_maptracker_kills") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.kills := hwnd, vars.hwnd.help_tooltips["settings_maptracker kill-tracker"] := hwnd1
	
	Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans gSettings_maptracker2 HWNDhwnd" (!settings.features.mapinfo ? " cFF8000" : (settings.maptracker.mapinfo ? " cLime" : " cGray")), % " " Lang_Trans("ms_map-info") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.mapinfo := hwnd, vars.hwnd.help_tooltips["settings_maptracker mapinfo"] := hwnd1

	Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans gSettings_maptracker2 HWNDhwnd" (settings.maptracker.sidecontent ? " cLime" : " cGray"), % " " Lang_Trans("m_maptracker_sidearea") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.sidecontent := hwnd, vars.hwnd.help_tooltips["settings_maptracker side-content"] := hwnd1

	If !vars.poe_version
	{
		Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans gSettings_maptracker2 HWNDhwnd" (settings.maptracker.loot ? " cLime" : " cGray"), % " " Lang_Trans("m_maptracker_loot") " "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings.loot := hwnd, vars.hwnd.help_tooltips["settings_maptracker loot-tracker"] := hwnd1
	}

	;Gui, %GUI%: Add, Text, % "Section xs w" wMaps - 2 " h" settings.general.fHeight " Right BackgroundTrans 0x200"
	Gui, %GUI%: Add, Text, % "Section xs y+" settings.general.fWidth " Border BackgroundTrans gSettings_maptracker2 HWNDhwnd" (settings.maptracker.mechanics ? " cLime" : " cGray"), % " " Lang_Trans("m_maptracker_mapcontent") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.mechanics := hwnd, vars.hwnd.help_tooltips["settings_maptracker mechanics"] := hwnd1

	If settings.maptracker.mechanics
	{
		added := 0
		Gui, %GUI%: Add, Text, % "xs y+-2 w" wMaps - 2 " h2 Border"
		Gui, %GUI%: Add, Text, % "xs y+0 w2 h" vars.settings.line1 + 1 " Border HWNDhwnd_brace"
		For mechanic, type in vars.maptracker.mechanics
		{
			If type
				Continue
			added += 1, color := (settings.maptracker[mechanic] ? " cLime" : " cGray")
			Gui, %GUI%: Add, Text, % (added = 1 ? "Section xs x+" vars.settings.xMargin " y+-1" : "ys") " Border BackgroundTrans gSettings_maptracker2 HWNDhwnd" color, % " " Lang_Trans("mechanic_" mechanic) " "
			Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
			vars.hwnd.settings["mechanic_"mechanic] := hwnd, vars.hwnd.help_tooltips["settings_maptracker dialoguemechanic"handle] := hwnd1, handle .= "|"
		}

		If !vars.poe_version
			Gui, %GUI%: Add, Text, % "xs x" x_anchor " w" settings.general.fWidth * 20 " h2 Border"
		Gui, %GUI%: Add, Text, % "Section" (!added ? " xs x+" vars.settings.xMargin " y+-1" : " xs") " Border HWNDhwnd", % " " Lang_Trans("m_maptracker_dialogue") " "
		vars.hwnd.help_tooltips["settings_maptracker dialogue tracking"] := hwnd, added := 0, ingame_dialogs := vars.maptracker.dialog := InStr(LLK_FileRead(vars.system.config), "output_all_dialogue_to_chat=true") ? 1 : 0
		For mechanic, type in vars.maptracker.mechanics
		{
			If (type != 1)
				Continue
			added += 1, color := (!ingame_dialogs ? " cRed" : settings.maptracker[mechanic] ? " cLime" : " cGray")
			Gui, %GUI%: Add, Text, % (RegexMatch(added, "^(3|7|11)$") ? "Section xs" : "ys") " Border BackgroundTrans gSettings_maptracker2 HWNDhwnd" color, % " " Lang_Trans("mechanic_" mechanic) " "
			Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
			vars.hwnd.settings["mechanic_"mechanic] := hwnd, vars.hwnd.help_tooltips["settings_maptracker dialoguemechanic"handle] := hwnd1, handle .= "|"
		}

		Gui, %GUI%: Add, Text, % "xs x" x_anchor " w" settings.general.fWidth * 20 " h2 Border"
		Gui, %GUI%: Add, Text, % "Section xs Border HWNDhwnd", % " " Lang_Trans("m_maptracker_screen") " "
		vars.hwnd.help_tooltips["settings_maptracker screen tracking"] := hwnd, handle := "", added := 0
		For mechanic, type in vars.maptracker.mechanics
		{
			If (type != 2)
				Continue
			added += 1, color := !FileExist("img\Recognition ("vars.client.h "p)\Mapping Tracker\"mechanic . vars.poe_version ".bmp") ? "red" : settings.maptracker[mechanic] ? " cLime" : " cGray"
			Gui, %GUI%: Add, Text, % (RegexMatch(added, "^(3|7|11)$") ? "Section xs" : "ys") " Border BackgroundTrans gSettings_maptracker2 HWNDhwnd c" color, % " " Lang_Trans("mechanic_" mechanic) " "
			Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
			vars.hwnd.settings["screenmechanic_"mechanic] := hwnd, vars.hwnd.help_tooltips["settings_maptracker screenmechanic"handle] := hwnd1, handle .= "|"
		}

		Gui, %GUI%: Add, Text, % "xs x" x_anchor " w" settings.general.fWidth * 20 " h2 Border HWNDhwnd"
		Gui, %GUI%: Add, Text, % "Section xs Border", % " " Lang_Trans("m_maptracker_portalreminder") " "
		Gui, %GUI%: Add, Text, % "ys x+-1 w" wOn " Center Border BackgroundTrans gSettings_maptracker2 HWNDhwnd" (settings.maptracker.portal_reminder ? " cLime" : " cGray"), % Lang_Trans("global_" (settings.maptracker.portal_reminder ? "on" : "off"))
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings.portal_reminder := hwnd, vars.hwnd.help_tooltips["settings_maptracker portal reminder"] := hwnd1, handle := ""

		If settings.maptracker.portal_reminder
		{
			Gui, %GUI%: Add, Text, % "ys Border HWNDhwnd0", % " " Lang_Trans("global_hotkey") " "
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
	static toggle := 0, fSize, section_width, dIcon

	If vars.settings.wait
		Return
	Else If WinExist("ahk_id " vars.hwnd.cheatsheet_menu.main) || WinExist("ahk_id " vars.hwnd.searchstrings_menu.main) || WinExist("ahk_id "vars.hwnd.leveltracker_screencap.main)
	|| WinExist("ahk_id " vars.hwnd.leveltracker_editor.main) || WinExist("ahk_id " vars.hwnd.leveltracker_gempickups.main)
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
			vars.settings := {"sections": ["general", "client", "hotkeys", "screen-checks", "news", "updater", "donations", "actdecoder", "leveling tracker", "addons", "betrayal-info", "macros", "cheat-sheets", "clone-frames", "anoints", "filterspoon", "item-info", "map-info", "mapping tracker", "minor qol tools", "sanctum", "search-strings", "stash-ninja", "tldr-tooltips", "exchange"], "sections2": []}
		Else vars.settings := {"sections": ["general", "client", "hotkeys", "screen-checks", "news", "updater", "donations", "actdecoder", "leveling tracker", "addons", "macros", "cheat-sheets", "clone-frames", "anoints", "filterspoon", "item-info", "map-info", "mapping tracker", "minor qol tools", "runeshaping", "search-strings", "sanctum", "stash-ninja", "statlas", "exchange"], "sections2": []}
		For index, val in vars.settings.sections
			vars.settings.sections2.Push(Lang_Trans("ms_" val, (vars.poe_version && val = "sanctum") ? 2 : 1))
		vars.settings.cButtons := "202040", vars.settings.cButtons2 := "353570", vars.settings.min_width := 30
	}

	If InStr(section, "addons_")
		sub_section := SubStr(section, InStr(section, "_") + 1), section := "addons"

	If !Blank(LLK_HasVal(vars.hwnd.settings, section))
	{
		section := LLK_HasVal(vars.hwnd.settings, section)
		KeyWait, LButton
	}

	If (mode != 1) && (vars.settings.active = "hotkeys") && (section != "hotkeys")
		Init_hotkeys()

	vars.settings.xMargin := Round(settings.general.fWidth*0.75), vars.settings.yMargin := settings.general.fHeight*0.15, vars.settings.line1 := Round(settings.general.fHeight/4)
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

	If (fSize != settings.general.fSize)
	{
		LLK_PanelDimensions(vars.settings.sections2, settings.general.fSize, section_width, height)
		While Mod(section_width + 3, 4)
			section_width += 1
		For key, hbm in vars.pics.settings
			DeleteObject(hbm)
		If ((section_width + 3)/4 < Round(settings.general.fHeight * 1.5))
			section_width := Round(settings.general.fHeight * 1.5) * 4 - 3, dIcon := Round(settings.general.fHeight * 1.5)
		Else dIcon := (section_width + 3)/4
		vars.pics.settings := {}, fSize := settings.general.fSize, vars.pics.settings.selection_general := LLK_ImageCache("img\GUI\settings\general.png", dIcon)
	}

	Gui, %GUI_name%: Font, % "s" settings.general.fSize
	Gui, %GUI_name%: Add, Text, % "Section xs x-1 y+-1 BackgroundTrans Border gSettings_menu HWNDhwnd w" dIcon " h" dIcon . (!vars.general.safe_mode ? "" : " Hidden")
	Gui, %GUI_name%: Add, Pic, % "xp yp BackgroundTrans" (!vars.general.safe_mode ? "" : " Hidden"), % "HBitmap:*" vars.pics.settings.selection_general
	Gui, %GUI_name%: Add, Progress, % "xp yp wp hp Border Disabled HWNDhwnd1 BackgroundBlack cBlack" (!vars.general.safe_mode ? "" : " Hidden"), 100
	ControlGetPos, x, y,,,, ahk_id %hwnd%
	vars.hwnd.settings.general := hwnd, vars.settings.xSelection := x, vars.settings.ySelection := y + vars.settings.line1, vars.settings.wSelection := section_width
	vars.hwnd.settings["background_general"] := vars.hwnd.help_tooltips["settings_selection general"] := hwnd1, vars.settings.x_anchor := vars.settings.xSelection + vars.settings.wSelection + vars.settings.xMargin
	feature_check := {"actdecoder": "actdecoder", "betrayal-info": "betrayal", "cheat-sheets": "cheatsheets", "leveling tracker": "leveltracker", "mapping tracker": "maptracker", "map-info": "mapinfo", "tldr-tooltips": "OCR", "sanctum": "sanctum", "stash-ninja": "stash", "filterspoon" : "lootfilter", "item-info": "iteminfo", "statlas": "statlas", "anoints": "anoints", "addons": "addons", "runeshaping": "runeshaping"}
	feature_check2 := {"item-info": 1, "mapping tracker": 1, "map-info": 1, "statlas": 1, "runeshaping": 1}

	If !vars.general.buggy_resolutions.HasKey(vars.client.h) && !vars.general.safe_mode
		For index, val in vars.settings.sections
		{
			If (val = "general") || (val = "screen-checks") && !IsNumber(vars.pixelsearch.gamescreen.x1) || !vars.log.file_location && InStr("mapping tracker, actdecoder", val)
			|| vars.client.stream && InStr("item-info, map-info, filterspoon", val) || (val = "addons") && !FileExist("add-ons")
				Continue
			color := (val = "updater" && IsNumber(vars.update.1) && vars.update.1 < 0) ? " cRed" : (val = "updater" && IsNumber(vars.update.1) && vars.update.1 > 0) ? " cLime" : ""
			color := feature_check[val] && !settings.features[feature_check[val]] || (val = "clone-frames") && !vars.cloneframes.enabled || (val = "search-strings") && !vars.searchstrings.enabled || (val = "minor qol tools") && !(settings.qol.alarm + settings.qol.lab + settings.qol.notepad + settings.qol.mapevents) ? " cGray" : color, color := feature_check2[val] && (settings.general.lang_client = "unknown") ? " cGray" : color
			color := (val = "donations" ? " cCCCC00" : (val = "news" && vars.news.unread ? " cLime" : color))
			color := (val = "macros" ? (!Blank(settings.macros.hotkey_fasttravel) || !Blank(settings.macros.hotkey_custommacros) ? " cWhite" : " cGray") : color)
			color := (val = "exchange" && !(settings.features.exchange + settings.features.async) ? " cGray" : color)
			If (val = "cheat-sheets")
				For sheet, object in vars.cheatsheets.list
					If object.version && (sheet_check := LLK_HasVal(vars.cheatsheets.samples, sheet, 1,,, 1)) && (object.version < vars.cheatsheets.samples[sheet_check].version)
						color := " cLime"

			If !main_section && FileExist("img\GUI\settings\" val "*")
			{
				If !vars.pics.settings[val]
					vars.pics.settings[val] := LLK_ImageCache("img\GUI\settings\" val . (val = "client" ? vars.poe_version : "") ".png", dIcon)
				Gui, %GUI_name%: Add, Text, % (A_Index = 5 ? "Section xs y+-1" : "ys x+-1") " BackgroundTrans Border gSettings_menu HWNDhwnd w" dIcon " h" dIcon
				Gui, %GUI_name%: Add, Pic, % "xp yp BackgroundTrans", % "HBitmap:*" vars.pics.settings[val]
			}
			Else Gui, %GUI_name%: Add, Text, % "Section xs y+-1 BackgroundTrans Border gSettings_menu HWNDhwnd 0x200 w" section_width " h" settings.general.fHeight*1.1 . color, % " " Lang_Trans("ms_" val, (vars.poe_version && val = "sanctum") ? 2 : 1)
			Gui, %GUI_name%: Add, Progress, % "xp yp wp hp Border Disabled HWNDhwnd1 Background" (val = "client" && settings.general.lang_client = "unknown" ? "Red" : "Black") " cBlack", 100
			vars.hwnd.settings[val] := hwnd, vars.hwnd.settings["background_"val] := hwnd1
			If !main_section
				vars.hwnd.help_tooltips["settings_selection " val] := hwnd1
			If (val = "donations")
			{
				Gui, %GUI_name%: Add, Text, % "ys x+-1 BackgroundTrans Border w" dIcon " h" dIcon
				Gui, %GUI_name%: Add, Text, % "Section xs y+-1 BackgroundTrans Border w" section_width " h" Round(settings.general.fWidth * 0.6), 0
				Gui, %GUI_name%: Add, Progress, % "Disabled xp yp wp hp Border BackgroundBlack c646464", 100
				main_section := 1
			}
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
	GuiControl, % "+c" vars.settings.cButtons, % vars.hwnd.settings["background_"vars.settings.active]
	GuiControl, % "+Background" vars.settings.cButtons2, % vars.hwnd.settings["background_"vars.settings.active]

	If vars.settings.active0 && (vars.settings.active0 != vars.settings.active) ;remove highlight from previously-selected section
	{
		GuiControl, +cBlack, % vars.hwnd.settings["background_"vars.settings.active0]
		GuiControl, +BackgroundBlack, % vars.hwnd.settings["background_"vars.settings.active0]
	}

	vars.settings.active0 := section
	Settings_ScreenChecksValid() ;check if 'screen-checks' section needs to be highlighted red

	;Gui, %GUI_name%: Add, Text, % "BackgroundTrans x" vars.settings.x_anchor " y" vars.settings.ySelection " w" settings.general.fWidth * vars.settings.min_width " h1"
	Settings_menu2(section, mode, sub_section)
	Gui, %GUI_name%: Margin, % vars.settings.xMargin, -1
	Gui, %GUI_name%: Add, Text, % "Section xs x" vars.settings.x_anchor " y+0 w1 h" vars.settings.line1
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
	Sleep 50

	If (vars.settings.x != "") && (vars.settings.y != "")
	{
		vars.settings.x := (vars.settings.x + w > vars.monitor.x + vars.monitor.w) ? vars.monitor.x + vars.monitor.w - w - 1 : vars.settings.x
		vars.settings.y := (vars.settings.y + h > vars.monitor.y + vars.monitor.h) ? vars.monitor.y + vars.monitor.h - h : vars.settings.y
		Gui, %GUI_name%: Show, % "NA x"vars.settings.x " y"vars.settings.y " w"w - 1 " h"h - 2
	}
	Else
	{
		vars.settings.x := vars.monitor.x + vars.monitor.w/2 - w/2
		vars.settings.y := vars.monitor.y + vars.monitor.h/2 - h/2
		Gui, %GUI_name%: Show, % "NA x" vars.settings.x " y" vars.settings.y " w"w - 1 " h"h - 2
	}

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
			Else Settings_addons()
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
		Case "exchange":
			Settings_exchange()
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

	GUI := "settings_menu" vars.settings.GUI_toggle, x_anchor := vars.settings.x_anchor, margin := settings.general.fWidth//2, news := vars.news
	Gui, %GUI%: Add, Text, % "Section x" x_anchor " y" vars.settings.ySelection, % Lang_Trans("m_news_recent")
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
		Gui, %GUI%: Add, Text, % "Section xs y+" margin * 2 . color, % Trim((days ? days "d, " : "") . (hours ? hours "h" : "") . (days ? "" : (hours ? ", " : "") . (now ? now "m" : "")), " ,") " ago: " topic
		Gui, %GUI%: Font, norm

		For index, line in array
			If (index != 1)
			{
				Gui, %GUI%: Add, Pic, % "Section xs y+" margin, % "HBitmap:*" vars.pics.news.bullet
				Gui, %GUI%: Add, Text, % "ys x+0 w" settings.general.fWidth * 35, % line
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

Settings_OCR()
{
	local
	global vars, settings

	GUI := "settings_menu" vars.settings.GUI_toggle, x_anchor := vars.settings.x_anchor
	Gui, %GUI%: Add, Link, % "Section x" x_anchor " y" vars.settings.ySelection, <a href="https://github.com/Lailloken/Exile-UI/wiki/TLDR‐Tooltips">wiki page</a>
	Gui, %GUI%: Add, Link, % "ys x+" settings.general.fWidth, <a href="https://www.autohotkey.com/docs/v1/KeyList.htm">ahk: key list</a>
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

	Gui, %GUI%: Add, Checkbox, % "xs Section gSettings_OCR2 HWNDhwnd 0x400 Checked" settings.features.ocr " y+"vars.settings.spacing . (!settings.OCR.allow ? " cRed" : ""), % Lang_Trans("m_ocr_enable")
	vars.hwnd.settings.enable := vars.hwnd.help_tooltips["settings_ocr " (settings.OCR.allow ? "enable" : "compatibility")] := hwnd

	If !settings.features.ocr
		Return

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "xs Section y+"vars.settings.spacing, % Lang_Trans("global_general")
	Gui, %GUI%: Font, norm
	Gui, %GUI%: Add, Text, % "ys Border HWNDhwnd1 gSettings_OCR2 cRed Hidden", % " " Lang_Trans("global_restart") " "

	Gui, %GUI%: Add, Text, % "xs Section HWNDhwnd", % Lang_Trans("m_ocr_hotkey")
	Gui, %GUI%: Font, % "s" settings.general.fSize - 4
	Gui, %GUI%: Add, Edit, % "ys hp Border HWNDhwnd0 cBlack gSettings_OCR2 w" settings.general.fWidth * 10, % settings.OCR.z_hotkey
	Gui, %GUI%: Font, % "s" settings.general.fSize
	Gui, %GUI%: Add, Text, % "xs Section HWNDhwnd", % Lang_Trans("global_hotkey")
	Gui, %GUI%: Font, % "s" settings.general.fSize - 4
	Gui, %GUI%: Add, Edit, % "ys hp Border HWNDhwnd cBlack gSettings_OCR2 w" settings.general.fWidth * 10, % settings.OCR.hotkey
	Gui, %GUI%: Font, % "s" settings.general.fSize

	Gui, %GUI%: Add, Checkbox, % "ys HWNDhwnd3 gSettings_OCR2 0x400 Checked" settings.OCR.hotkey_block, % Lang_Trans("m_hotkeys_exclusive")
	Gui, %GUI%: Add, Checkbox, % "xs Section HWNDhwnd2 gSettings_OCR2 0x400 Checked" settings.OCR.debug, % Lang_Trans("m_ocr_debug")
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

			IniWrite, % (input := settings.features.ocr := LLK_ControlGet(cHWND)), ini\config.ini, Features, enable ocr
			If !Blank(settings.OCR.hotkey)
			{
				Hotkey, IfWinActive, ahk_group poe_ahk_window
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
	static fSize, wFont, wDuration, wList, wPosition

	GUI := "settings_menu" vars.settings.GUI_toggle, x_anchor := vars.settings.x_anchor, yMax := 0

	If (fSize != settings.general.fSize)
	{
		fSize := settings.general.fSize
		LLK_PanelDimensions([Lang_Trans("global_font")], fSize, wFont, hFont)
		LLK_PanelDimensions([Lang_Trans("global_position") . Lang_Trans("global_colon")], fSize, wPosition, hPosition)
		LLK_PanelDimensions([Lang_Trans("global_duration") . Lang_Trans("global_colon")], fSize, wDuration, hDuration)
		dimensions := []
		For index, val in settings.mapevents.event_list
			dimensions.Push(Lang_Trans("mechanic_" val))
		LLK_PanelDimensions(dimensions, fSize, wList, hList)
	}
	wPanel := (settings.qol.mapevents ? Max(wFont, wPosition) : wFont)
	If (wDuration > wPanel + settings.general.fWidth * 7 - 2)
		wPanel := wDuration - (settings.general.fWidth * 7 - 2)
	Else wDuration1 := wPanel + settings.general.fWidth * 7 - 2

	Gui, %GUI%: Add, Text, % "Section x" x_anchor " y" vars.settings.ySelection " Border BackgroundTrans HWNDhwnd gURL cAqua", % " wiki page "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.URLs := {}, vars.URLs[hwnd] := "https://github.com/Lailloken/Exile-UI/wiki/Minor-Features", vars.hwnd.help_tooltips["settings_website"] := hwnd1

	Gui, %GUI%: Add, Text, % "Section xs y+" vars.settings.spacing " Border BackgroundTrans gSettings_qol2 HWNDhwnd" (settings.qol.alarm ? " cLime" : " cGray"), % " " Lang_Trans("global_enable") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	Gui, %GUI%: Add, Text, % "ys x+" settings.general.fWidth/2 " hp 0x200 HWNDhwnd0" (settings.qol.alarm ? "" : " cGray"), % StrReplace(Lang_Trans("m_qol_alarm"), Lang_Trans("global_colon"))
	vars.hwnd.help_tooltips["settings_alarm enable"] := hwnd1, vars.hwnd.settings.enable_alarm := hwnd, vars.hwnd.help_tooltips["settings_alarm enable|"] := hwnd0

	If settings.qol.alarm
	{
		Gui, %GUI%: Add, Text, % "Section xs y+0 w2 h" vars.settings.line1 " Border HWNDhwnd_brace"

		Gui, %GUI%: Add, Text, % "Section ys yp+" vars.settings.line1 " w" wPanel " Border Right HWNDhwnd0", % Lang_Trans("global_font") " "
		Gui, %GUI%: Add, Text, % "ys x+-1 HWNDhwnd Border BackgroundTrans Center gSettings_qol2 w"settings.general.fWidth*2, % "–"
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.help_tooltips["settings_font-size"] := hwnd0, vars.hwnd.settings.alarmfont_minus := hwnd, vars.hwnd.help_tooltips["settings_font-size|"] := hwnd1

		Gui, %GUI%: Add, Text, % "ys x+-1 HWNDhwnd Border BackgroundTrans Center gSettings_qol2 w"settings.general.fWidth*3, % settings.alarm.fSize
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings.alarmfont_reset := hwnd, vars.hwnd.help_tooltips["settings_font-size||"] := hwnd1

		Gui, %GUI%: Add, Text, % "ys x+-1 HWNDhwnd Border BackgroundTrans Center gSettings_qol2 w"settings.general.fWidth*2, % "+"
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings.alarmfont_plus := hwnd, vars.hwnd.help_tooltips["settings_font-size|||"] := hwnd1

		Gui, %GUI%: Add, Text, % "ys Border", % " " Lang_Trans("global_color", 2) " "
		Gui, %GUI%: Add, Text, % "ys x+-1 BackgroundTrans Border HWNDhwnd gSettings_qol2", % "  "
		Gui, %GUI%: Add, Progress, % "xp yp wp hp Border Disabled BackgroundBlack HWNDhwnd1 c" settings.alarm.color, 100
		vars.hwnd.settings.color_alarm := hwnd, vars.hwnd.settings.color_alarm_bar := vars.hwnd.help_tooltips["settings_generic color double"] := hwnd1

		Gui, %GUI%: Add, Text, % "ys x+-1 BackgroundTrans Border HWNDhwnd gSettings_qol2", % "  "
		Gui, %GUI%: Add, Progress, % "xp yp wp hp Border Disabled BackgroundBlack HWNDhwnd1 c" settings.alarm.color1, 100
		vars.hwnd.settings.color_alarm1 := hwnd, vars.hwnd.settings.color_alarm1_bar := vars.hwnd.help_tooltips["settings_generic color double1"] := hwnd1

		Gui, %GUI%: Add, Text, % "Section xs x" x_anchor " w" settings.general.fWidth * 20 " h2 Border HWNDhwnd"
		GuiControl, movedraw, % hwnd_brace, % "h" LLK_ControlGetPos(hwnd, "y") - LLK_ControlGetPos(hwnd_brace, "y")
	}

	If !vars.poe_version && !vars.client.stream
	{
		Gui, %GUI%: Add, Text, % "Section xs y+" vars.settings.spacing " Border BackgroundTrans gSettings_qol2 HWNDhwnd" (settings.qol.mapevents ? " cLime" : " cGray"), % " " Lang_Trans("global_enable") " "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		Gui, %GUI%: Add, Text, % "ys x+" settings.general.fWidth/2 " hp 0x200 HWNDhwnd0" (settings.qol.mapevents ? "" : " cGray"), % StrReplace(Lang_Trans("m_qol_map_events"), Lang_Trans("global_colon"))
		vars.hwnd.help_tooltips["settings_map-events enable"] := hwnd0, vars.hwnd.settings.enable_mapevents := hwnd, vars.hwnd.help_tooltips["settings_map-events enable|"] := hwnd1

		If settings.qol.mapevents
		{
			Gui, %GUI%: Add, Text, % "Section xs y+0 w2 h" vars.settings.line1 " Border HWNDhwnd_brace"

			Gui, %GUI%: Add, Text, % "Section ys yp+" vars.settings.line1 " w" wPanel " Right Border HWNDhwnd0", % Lang_Trans("global_font") " "
			Gui, %GUI%: Add, Text, % "ys x+-1 HWNDhwnd Border BackgroundTrans Center gSettings_qol2 w"settings.general.fWidth*2, % "–"
			Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
			vars.hwnd.help_tooltips["settings_font-size||||"] := hwnd0, vars.hwnd.settings.mapeventsfont_minus := hwnd, vars.hwnd.help_tooltips["settings_font-size|||||"] := hwnd1

			Gui, %GUI%: Add, Text, % "ys x+-1 HWNDhwnd Border BackgroundTrans Center gSettings_qol2 w"settings.general.fWidth*3, % settings.mapevents.fSize
			Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
			vars.hwnd.settings.mapeventsfont_reset := hwnd, vars.hwnd.help_tooltips["settings_font-size||||||"] := hwnd1

			Gui, %GUI%: Add, Text, % "ys x+-1 HWNDhwnd Border BackgroundTrans Center gSettings_qol2 w"settings.general.fWidth*2, % "+"
			Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
			vars.hwnd.settings.mapeventsfont_plus := hwnd, vars.hwnd.help_tooltips["settings_font-size|||||||"] := hwnd1, DDL := []

			Gui, %GUI%: Add, Text, % "xs y+-1 w" wPanel " Right Border HWNDhwnd0", % Lang_Trans("global_position") . Lang_Trans("global_colon") " "
			For index, val in ["top", "bottom", "left", "right"]
				DDL.Push(Lang_Trans("m_general_pos" val))
			Gui, %GUI%: Font, % "s" fSize - 2
			Gui, %GUI%: Add, Text, % "ys x+-1 yp w" settings.general.fWidth * 7 - 2 " hp 0x200 Center Border BackgroundTrans HWNDhwnd gSettings_qol2", % DDL[settings.mapevents.position]
			vars.ddl.position_mapevents := {"cHWND": hwnd, "current": DDL[settings.mapevents.position], "list": DDL.Clone(), "color": vars.settings.cButtons, "fSize": fSize - 2}
			Gui, %GUI%: Font, % "s" fSize
			Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
			vars.hwnd.settings.position_mapevents := hwnd, vars.hwnd.help_tooltips["settings_map-events position"] := hwnd0, vars.hwnd.help_tooltips["settings_map-events position|"] := hwnd1

			Gui, %GUI%: Add, Text, % "xs w" wDuration1 " Border Center", % Lang_Trans("global_duration") . Lang_Trans("global_colon")
			Gui, %GUI%: Add, Slider, % "xs xp y+-1 w" wDuration1 - settings.general.fWidth * 3 + 1 " hp Border HWNDhwnd ToolTip gSettings_qol2 NoTicks Center Range3-10", % settings.mapevents.duration
			Gui, %GUI%: Add, Text, % "ys yp x+-1 w" settings.general.fWidth * 3 " hp Center Border HWNDhwnd1", % settings.mapevents.duration
			vars.hwnd.settings.duration_mapevents := hwnd, vars.hwnd.settings.duration_mapevents_label := hwnd1

			mechanics := {}
			For index, val in settings.mapevents.event_list
				mechanics[Lang_Trans("mechanic_" val)] := val

			handle := "|", cLast := LLK_ControlGetPos(hwnd), yMax := cLast.y + cLast.h
			For key, val in mechanics
			{
				Gui, %GUI%: Add, Text, % "Section " (A_Index = 1 ? "ys" : "xs") " w" wList " HWNDhwnd Border BackgroundTrans gSettings_qol2 c" (settings.mapevents[val] ? "Lime" : "Gray"), % " " key
				Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
				vars.hwnd.settings["mapevents_enable_" val] := hwnd, vars.hwnd.help_tooltips["settings_map-events enable event" handle] := hwnd1

				Gui, %GUI%: Add, Text, % "ys x+-1 BackgroundTrans Border HWNDhwnd gSettings_qol2", % "  "
				Gui, %GUI%: Add, Progress, % "xp yp wp hp Border Disabled BackgroundBlack HWNDhwnd1 c" settings.mapevents["color_" val], 100
				vars.hwnd.settings["color_mapevents_" val] := hwnd, vars.hwnd.settings["color_mapevents_" val "_bar"] := vars.hwnd.help_tooltips["settings_generic color double" handle] := hwnd1
				Gui, %GUI%: Add, Text, % "ys x+-1 BackgroundTrans Border HWNDhwnd gSettings_qol2", % "  "
				Gui, %GUI%: Add, Progress, % "xp yp wp hp Border Disabled BackgroundBlack HWNDhwnd1 c" settings.mapevents["color1_" val], 100
				vars.hwnd.settings["color_mapevents1_" val] := hwnd, vars.hwnd.settings["color_mapevents1_" val "_bar"] := vars.hwnd.help_tooltips["settings_generic color double1" handle] := hwnd1, handle .= "|"
			}

			Gui, %GUI%: Add, Text, % "Section xs x" x_anchor " y" Max(LLK_ControlGetPos(vars.hwnd.settings.duration_mapevents_label).yMax, LLK_ControlGetPos(hwnd1).yMax) - 1 + vars.settings.line1 " w" settings.general.fWidth * 20 " h2 Border HWNDhwnd"
			GuiControl, movedraw, % hwnd_brace, % "h" Max(LLK_ControlGetPos(hwnd, "y"), LLK_ControlGetPos(vars.hwnd.settings.duration_mapevents_label).yMax) - LLK_ControlGetPos(hwnd_brace, "y")
		}
	}

	cLast := LLK_ControlGetPos(hwnd), yMax := Max(yMax, cLast.y + cLast.h)
	Gui, %GUI%: Add, Text, % "Section xs x" x_anchor " y" yMax + vars.settings.spacing " Border BackgroundTrans gSettings_qol2 HWNDhwnd" (settings.qol.notepad ? " cLime" : " cGray"), % " " Lang_Trans("global_enable") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	Gui, %GUI%: Add, Text, % "ys x+" settings.general.fWidth/2 " hp 0x200 HWNDhwnd0" (settings.qol.notepad ? "" : " cGray"), % StrReplace(Lang_Trans("m_qol_notepad"), Lang_Trans("global_colon"))
	vars.hwnd.help_tooltips["settings_notepad enable"] := hwnd0, vars.hwnd.settings.enable_notepad := hwnd, vars.hwnd.help_tooltips["settings_notepad enable|"] := hwnd1

	If settings.qol.notepad
	{
		Gui, %GUI%: Add, Text, % "Section xs y+0 w2 h" vars.settings.line1 " Border HWNDhwnd_brace"

		Gui, %GUI%: Add, Text, % "Section ys yp+" vars.settings.line1 " w" wPanel " Border Right Section HWNDhwnd0", % Lang_Trans("global_font") " "
		Gui, %GUI%: Add, Text, % "ys x+-1 HWNDhwnd Border BackgroundTrans Center gSettings_qol2 w"settings.general.fWidth*2, % "–"
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.help_tooltips["settings_font-size||||||||"] := hwnd0, vars.hwnd.settings.notepadfont_minus := hwnd, vars.hwnd.help_tooltips["settings_font-size|||||||||"] := hwnd1

		Gui, %GUI%: Add, Text, % "ys x+-1 HWNDhwnd Border BackgroundTrans Center gSettings_qol2 w"settings.general.fWidth*3, % settings.notepad.fSize
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings.notepadfont_reset := hwnd, vars.hwnd.help_tooltips["settings_font-size||||||||||"] := hwnd1

		Gui, %GUI%: Add, Text, % "ys x+-1 HWNDhwnd Border BackgroundTrans Center gSettings_qol2 w"settings.general.fWidth*2, % "+"
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings.notepadfont_plus := hwnd, vars.hwnd.help_tooltips["settings_font-size|||||||||||"] := hwnd1

		Gui, %GUI%: Add, Text, % "ys Border HWNDhwnd", % " " Lang_Trans("m_qol_widgetcolor") " "
		vars.hwnd.help_tooltips["settings_notepad default color"] := hwnd
		Gui, %GUI%: Add, Text, % "ys x+-1 BackgroundTrans Border HWNDhwnd gSettings_qol2", % "  "
		Gui, %GUI%: Add, Progress, % "xp yp wp hp Border Disabled BackgroundBlack HWNDhwnd1 c" settings.notepad.color, 100
		vars.hwnd.settings.color_notepad := hwnd, vars.hwnd.settings.color_notepad_bar := vars.hwnd.help_tooltips["settings_generic color double|" handle] := hwnd1

		Gui, %GUI%: Add, Text, % "ys x+-1 BackgroundTrans Border HWNDhwnd gSettings_qol2", % "  "
		Gui, %GUI%: Add, Progress, % "xp yp wp hp Border Disabled BackgroundBlack HWNDhwnd1 c" settings.notepad.color1, 100
		vars.hwnd.settings.color_notepad1 := hwnd, vars.hwnd.settings.color_notepad1_bar := vars.hwnd.help_tooltips["settings_generic color double1|" handle] := hwnd1

		Gui, %GUI%: Add, Text, % "Section xs Border HWNDhwnd", % " " Lang_Trans("m_qol_widget") " "
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

	If vars.client.stream || vars.poe_version
		Return

	Gui, %GUI%: Add, Text, % "Section xs y+" vars.settings.spacing " Border BackgroundTrans gSettings_qol2 HWNDhwnd" (settings.general.lang_client = "unknown" ? " cGray" : (settings.qol.lab ? " cLime" : " cGray")), % " " Lang_Trans("global_enable") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	Gui, %GUI%: Add, Text, % "ys x+" settings.general.fWidth/2 " hp 0x200 HWNDhwnd0" (settings.general.lang_client = "unknown" || !settings.qol.lab ? " cGray" : ""), % StrReplace(Lang_Trans("m_qol_lab"), Lang_Trans("global_colon"))
	If (settings.general.lang_client = "unknown")
		vars.hwnd.help_tooltips["settings_lang incompatible"] := hwnd0, vars.hwnd.settings.enable_lab := hwnd, vars.hwnd.help_tooltips["settings_lang incompatible|"] := hwnd1
	Else vars.hwnd.help_tooltips["settings_lab enable"] := hwnd0, vars.hwnd.settings.enable_lab := hwnd, vars.hwnd.help_tooltips["settings_lab enable|"] := hwnd1
}

Settings_qol2(cHWND)
{
	local
	global vars, settings

	check := LLK_HasVal(vars.hwnd.settings, cHWND), control := SubStr(check, InStr(check, "_") + 1), control1 := SubStr(check, 1, InStr(check, "_") - 1)
	If !InStr(check, "font_")
		KeyWait, LButton

	If InStr(check, "mapevents_enable_")
	{
		control := SubStr(control, InStr(control, "_") + 1)
		If (vars.system.click = 2)
		{
			MapEvent(control)
			Return
		}
		IniWrite, % (settings.mapevents[control] := !settings.mapevents[control]), % "ini" vars.poe_version "\qol tools.ini", % "mapevents", % "enable " control
		GuiControl, % "+c" (settings.mapevents[control] ? "Lime" : "Gray"), % cHWND
		GuiControl, % "movedraw", % cHWND
	}
	Else If InStr(check, "color_mapevents")
	{
		event := SubStr(control, InStr(control, "_") + 1)
		If (vars.system.click = 1)
			rgb := RGB_Picker(settings.mapevents["color" (InStr(check, "1") ? "1" : "") "_" event])
		If (vars.system.click = 1) && Blank(rgb)
			Return
		Else If (vars.system.click = 2)
			rgb := (InStr(check, "1") ? "FFFFFF" : "FF0000")

		IniWrite, % """" (settings.mapevents["color" (InStr(check, "1") ? "1" : "") "_" event] := rgb) """", % "ini" vars.poe_version "\qol tools.ini", % "mapevents", % (InStr(check, "1") ? "background-color " : "text-color ") . event
		GuiControl, % "+c" rgb, % vars.hwnd.settings[check "_bar"]
		GuiControl, movedraw, % vars.hwnd.settings[check "_bar"]
	}
	Else If InStr(check, "enable_")
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
	Else If InStr(check, "duration_")
	{
		IniWrite, % (settings.mapevents.duration := LLK_ControlGet(cHWND)), % "ini" vars.poe_version "\qol tools.ini", % control, duration
		GuiControl, Text, % vars.hwnd.settings.duration_mapevents_label, % settings.mapevents.duration
	}
	Else If InStr(check, "position_")
	{
		WinGetPos, xControl, yControl, wControl, hControl, % "ahk_id " cHWND
		If Blank(input := Gui_DropDownList(vars.ddl[check], [xControl, yControl, wControl, hControl], "Center", 1)) || IsObject(input) && Blank(input.1 . input.2)
			Return
		vars.ddl[check].current := input.1
		IniWrite, % (settings.mapevents.position := input.2), % "ini" vars.poe_version "\qol tools.ini", % control, position
	}
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
		GuiControl, +cLime, % vars.hwnd.settings[control1 "opac_" settings[control1].trans]
		GuiControl, movedraw, % vars.hwnd.settings[control1 "opac_" settings[control1].trans]
		If (control1 = "notepad") && vars.hwnd.notepad_widgets.Count()
			For key, val in vars.hwnd.notepad_widgets
				WinSet, Transparent, % (key = "notepad_reminder_feature") ? 250 : 50 * settings.notepad.trans, % "ahk_id "val
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
	{
		Gui, %Gui%: Add, Text, % "xs y+-1 h1 w" settings.general.fWidth * vars.settings.min_width
		Return
	}

	If (fSize != settings.general.fSize)
	{
		fSize := settings.general.fSize
		LLK_PanelDimensions([Lang_Trans("global_on"), Lang_Trans("global_off")], fSize, wOnOff, hOnOff)
	}

	Gui, %GUI%: Font, underline bold
	Gui, %GUI%: Add, Text, % "xs Section y+" vars.settings.spacing, % Lang_Trans("global_general")
	Gui, %GUI%: Font, norm

	Gui, %GUI%: Add, Text, % "Section xs Border", % " " Lang_Trans("global_league") . Lang_Trans("global_colon") " "
	Gui, %GUI%: Add, Text, % "ys x+-1 HWNDhwnd cLime Border BackgroundTrans gSettings_runeshaping2", % " " Lang_Trans("global_league_" settings.general.league.1) " " Lang_Trans("global_league_" settings.general.league[vars.poe_version ? 3 : 4]) " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp HWNDhwnd1 Border Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.league_select := hwnd, vars.hwnd.help_tooltips["settings_league selection other"] := hwnd1

	Gui, %GUI%: Add, Text, % "ys Border", % " " Lang_Trans("global_hold_ctrl") " "
	Gui, %GUI%: Add, Text, % "ys x+-1 w" wOnOff " Border BackgroundTrans HWNDhwnd Center gSettings_runeshaping2" (settings.runeshaping.hold_ctrl ? " cLime" : " cGray"), % Lang_Trans("global_" (settings.runeshaping.hold_ctrl ? "on" : "off"))
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.hold_ctrl := hwnd, vars.hwnd.help_tooltips["settings_runeshaping hold ctrl"] := hwnd1

	Gui, %GUI%: Add, Text, % "Section xs Border BackgroundTrans HWNDhwnd gSettings_runeshaping2" (settings.runeshaping.debug ? " cLime" : " cGray"), % " " Lang_Trans("global_troubleshoot") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.debug := hwnd, vars.hwnd.help_tooltips["settings_runeshaping debug"] := hwnd1

	If settings.runeshaping.debug
	{
		Gui, %GUI%: Add, Text, % "Section xs y+0 w2 h" vars.settings.line1 " Border HWNDhwnd_brace"
		Gui, %GUI%: Add, Text, % "Section ys y+0 w" settings.general.fWidth * 36 - 2 " Center Border HWNDhwnd", % Lang_Trans("m_runeshaping_correction")
		Gui, %GUI%: Font, % "s" settings.general.fSize - 4
		vars.hwnd.help_tooltips["settings_runeshaping dictionary"] := hwnd

		Gui, %GUI%: Add, Button, % "Hidden ys hp Default HWNDhwnd gSettings_runeshaping2", ok
		vars.hwnd.settings.ok := hwnd, count := 0

		For index, array in (settings.runeshaping.autocorrect.Count() ? settings.runeshaping.autocorrect : [["", ""]])
			Loop, % (index = settings.runeshaping.autocorrect.MaxIndex() && settings.runeshaping.autocorrect.Count() ? 2 : 1)
			{
				Gui, %GUI%: Add, Text, % "Section xs y+-1 w" settings.general.fWidth * 2 " hp Center 0x200 Border BackgroundTrans", % count + 1
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

	Gui, %GUI%: Add, Text, % "xs Section Border", % " " Lang_Trans("global_font") " "
	Gui, %GUI%: Add, Text, % "ys x+-1 Center Border BackgroundTrans gSettings_runeshaping2 HWNDhwnd w"settings.general.fWidth*2, % "–"
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp HWNDhwnd1 Border Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.help_tooltips["settings_font-size"] := hwnd0, vars.hwnd.settings.font_minus := hwnd, vars.hwnd.help_tooltips["settings_font-size|"] := hwnd1

	Gui, %GUI%: Add, Text, % "ys x+-1 Center Border BackgroundTrans gSettings_runeshaping2 HWNDhwnd w"settings.general.fWidth*3, % settings.runeshaping.fSize
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp HWNDhwnd1 Border Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.font_reset := hwnd, vars.hwnd.help_tooltips["settings_font-size||"] := hwnd1

	Gui, %GUI%: Add, Text, % "ys x+-1 Center Border BackgroundTrans gSettings_runeshaping2 HWNDhwnd w"settings.general.fWidth*2, % "+"
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp HWNDhwnd1 Border Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.font_plus := hwnd, vars.hwnd.help_tooltips["settings_font-size|||"] := hwnd1

	Gui, %GUI%: Add, Text, % "ys Border", % " " Lang_Trans("global_color", 2) " "
	For index, val in ["high", "stack", "unknown"]
	{
		Gui, %GUI%: Add, Text, % "ys x+-1 w" settings.general.fWidth * 1.5 " gSettings_runeshaping2 hp Border BackgroundTrans HWNDhwnd"
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
	{
		Gui, %Gui%: Add, Text, % "xs y+-1 h1 w" settings.general.fWidth * vars.settings.min_width
		Return
	}

	Gui, %GUI%: Font, underline bold
	Gui, %GUI%: Add, Text, % "xs Section y+" vars.settings.spacing, % Lang_Trans("global_general")
	Gui, %GUI%: Font, norm

	Gui, %GUI%: Add, Text, % "Section xs Border", % " " Lang_Trans("global_font") " "
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

	GUI := "settings_menu" vars.settings.GUI_toggle, x_anchor := vars.settings.x_anchor

	Gui, %GUI%: Add, Text, % "Section x" x_anchor " y" vars.settings.ySelection " Border BackgroundTrans HWNDhwnd gURL cAqua", % " wiki page "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.URLs := {}, vars.URLs[hwnd] := "https://github.com/Lailloken/Exile-UI/wiki/Screen-checks", vars.hwnd.help_tooltips["settings_website"] := hwnd1

	For key in (active_pixel := Settings_ScreenChecksValid("pixel").1)
	{
		If !header_pixel
		{
			Gui, %GUI%: Font, % "underline bold"
			Gui, %GUI%: Add, Text, % "xs Section y+"vars.settings.spacing, % Lang_Trans("m_screen_pixel")
			Gui, %GUI%: Add, Pic, % "ys hp w-1 BackgroundTrans HWNDhwnd", % "HBitmap:*" vars.pics.global.help
			Gui, %GUI%: Font, % "norm"
			vars.hwnd.help_tooltips["settings_screenchecks pixel-about"] := hwnd, header_pixel := 1
		}
		Gui, %GUI%: Add, Text, % "xs Section Border BackgroundTrans gSettings_screenchecks2 HWNDhwnd", % " " Lang_Trans("global_info") " "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings["info_"key] := hwnd, vars.hwnd.help_tooltips["settings_screenchecks pixel-info"handle] := hwnd1
		Gui, %GUI%: Add, Text, % "ys x+"settings.general.fWidth/4 " Border BackgroundTrans gSettings_screenchecks2 HWNDhwnd"(!vars.pixelsearch[key].color1 ? " cRed" : ""), % " " Lang_Trans("global_calibrate") " "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings["cPixel_"key] := hwnd, vars.hwnd.help_tooltips["settings_screenchecks pixel-calibration"handle] := hwnd1
		Gui, %GUI%: Add, Text, % "ys x+"settings.general.fWidth/4 " Border BackgroundTrans gSettings_screenchecks2 HWNDhwnd", % " " Lang_Trans("global_test") " "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings["tPixel_"key] := hwnd, vars.hwnd.help_tooltips["settings_screenchecks pixel-test"handle] := hwnd1, handle .= "|"
		Gui, %GUI%: Add, Text, % "ys hp 0x200", % Lang_Trans((key = "inventory" ? "global_" : "m_screen_") key)
	}

	If vars.client.stream && active_pixel.Count()
	{
		Gui, %GUI%: Add, Text, % "Section xs Border", % " " Lang_Trans("global_variance") . Lang_Trans("global_colon") " "
		Gui, %GUI%: Font, % "s" settings.general.fSize - 4
		Gui, %GUI%: Add, Text, % "ys x+-1 w" settings.general.fWidth * 4 " hp Border BackgroundTrans"
		Gui, %GUI%: Add, Edit, % "xp yp wp hp Border Number Limit3 cBlack gSettings_screenchecks2 HWNDhwnd", % vars.pixelsearch.variation
		Gui, %GUI%: Font, % "s" settings.general.fSize
		Gui, %GUI%: Add, Pic, % "ys hp w-1 HWNDhwnd1", % "HBitmap:*" vars.pics.global.help
		vars.hwnd.help_tooltips["settings_screenchecks variance"] := hwnd1, vars.hwnd.settings.variance_pixel := vars.hwnd.help_tooltips["settings_screenchecks variance input"] := hwnd
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
		Gui, %GUI%: Add, Text, % "xs Section Border BackgroundTrans gSettings_screenchecks2 HWNDhwnd", % " " Lang_Trans("global_info") " "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings["info_"key] := hwnd, vars.hwnd.help_tooltips["settings_screenchecks image-info"handle] := hwnd1
		Gui, %GUI%: Add, Text, % "ys x+"settings.general.fWidth/4 " Border BackgroundTrans gSettings_screenchecks2 HWNDhwnd" (!FileExist("img\Recognition (" vars.client.h "p)\GUI\" key . vars.poe_version ".bmp") ? " cRed" : ""), % " " Lang_Trans("global_calibrate") " "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings["cImage_"key] := hwnd, vars.hwnd.help_tooltips["settings_screenchecks image-calibration"handle] := hwnd1
		Gui, %GUI%: Add, Text, % "ys x+"settings.general.fWidth/4 " Border BackgroundTrans gSettings_screenchecks2 HWNDhwnd" (Blank(vars.imagesearch[key].x1) ? " cRed" : ""), % " " Lang_Trans("global_test") " "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings["tImage_"key] := hwnd, vars.hwnd.help_tooltips["settings_screenchecks image-test"handle] := hwnd1, handle .= "|"
		Gui, %GUI%: Add, Text, % "ys hp 0x200", % Lang_Trans((RegExMatch(key, "i)sanctum|async|runeshaping") ? "m_screen_" : (key = "betrayal" ? "mechanic_" : "global_")) key, (key = "sanctum" ? vars.poe_version : ""))
	}

	If active_image.Count()
	{
		Gui, %GUI%: Font, norm
		Gui, %GUI%: Add, Text, % "xs Section Center Border BackgroundTrans gSettings_screenchecks2 HWNDhwnd", % " " Lang_Trans("global_imgfolder") " "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings.folder := hwnd, vars.hwnd.help_tooltips["settings_screenchecks folder"] := hwnd1

		If vars.client.stream
		{
			Gui, %GUI%: Add, Text, % "Section xs Border", % " " Lang_Trans("global_variance") . Lang_Trans("global_colon") " "
			Gui, %GUI%: Font, % "s" settings.general.fSize - 4
			Gui, %GUI%: Add, Text, % "ys x+-1 w" settings.general.fWidth * 4 " hp Border BackgroundTrans"
			Gui, %GUI%: Add, Edit, % "xp yp wp hp Border Number Limit3 cBlack gSettings_screenchecks2 HWNDhwnd", % vars.imagesearch.variation
			Gui, %GUI%: Font, % "s" settings.general.fSize
			Gui, %GUI%: Add, Pic, % "ys hp w-1 HWNDhwnd1", % "HBitmap:*" vars.pics.global.help
			vars.hwnd.help_tooltips["settings_screenchecks variance|"] := hwnd1, vars.hwnd.settings.variance_image := vars.hwnd.help_tooltips["settings_screenchecks variance input|"] := hwnd
		}
	}
	Else If !(active_pixel.Count() + active_image.Count())
		Gui, %GUI%: Add, Text, % "Section xs cLime y+" vars.settings.spacing " w" settings.general.fWidth * 35, % Lang_Trans("m_screen_inactive")
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
			Continue
		Else valid *= !Blank(vars.imagesearch[key].x1) && FileExist("img\Recognition (" vars.client.h "p)\GUI\" key . vars.poe_version ".bmp") ? 1 : 0, active_image[key] := 1

	If (type = "image")
		Return [active_image, valid]

	GuiControl, % "+Background" (!valid ? "CC0000" : "Black"), % vars.hwnd.settings["background_screen-checks"]
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
		Gui, %GUI%: Add, Progress, % "xp yp wp hp Disabled range0-500 Vertical HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 500
		vars.hwnd.settings["del_"string] := hwnd, vars.hwnd.settings["delbar_"string] := vars.hwnd.help_tooltips["settings_searchstrings delete"handle] := hwnd1

		Gui, %GUI%: Add, Text, % "ys x+" settings.general.fWidth/4 " Border BackgroundTrans gSettings_searchstrings2 HWNDhwnd", % " " Lang_Trans("global_copy") " "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings["copy_" string] := hwnd, vars.hwnd.help_tooltips["settings_searchstrings copy" handle] := hwnd1, handle .= "|"
	}

	Gui, %GUI%: Add, Text, % "Section xs Border HWNDhwnd0", % " " Lang_Trans("m_search_add") " "
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
	Gui, %GUI%: Add, Text, % "xp yp wp hp Right Border HWNDhwnd0", % Lang_Trans("global_hotkey") " "
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
	{
		Gui, %Gui%: Add, Text, % "xs y+-1 h1 w" settings.general.fWidth * vars.settings.min_width
		Return
	}

	If !settings.features.stash
		Return

	Gui, %GUI%: Font, underline bold
	Gui, %GUI%: Add, Text, % "Section xs y+" vars.settings.spacing " h" settings.general.fHeight " 0x200", % Lang_Trans("global_general")
	Gui, %GUI%: Add, Button, % "xp yp wp hp Hidden Default HWNDhwnd gSettings_stash2", OK
	Gui, %GUI%: Font, norm
	vars.hwnd.settings.apply_button := hwnd

	Gui, %GUI%: Add, Text, % "Section xs Border", % " " Lang_Trans("global_league") . Lang_Trans("global_colon") " "
	Gui, %GUI%: Add, Text, % "ys x+-1 HWNDhwnd cLime Border BackgroundTrans gSettings_stash2", % " " Lang_Trans("global_league_" settings.general.league.1) " " Lang_Trans("global_league_" settings.general.league[vars.poe_version ? 3 : 4]) " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.league_select := hwnd, vars.hwnd.help_tooltips["settings_league selection other"] := hwnd1

	If vars.client.stream
	{
		Gui, %GUI%: Add, Text, % "ys Border", % " " Lang_Trans("global_hotkey") " "
		Gui, %GUI%: Font, % "s" settings.general.fSize - 4
		Gui, %GUI%: Add, Text, % "ys x+-1 w" settings.general.fWidth * 6 " hp Border BackgroundTrans HWNDhwnd"
		Gui, %GUI%: Add, Edit, % "xp yp wp hp Border HWNDhwnd cBlack gSettings_stash2", % settings.stash.hotkey
		Gui, %GUI%: Font, % "s" settings.general.fSize
		vars.hwnd.settings.hotkey := vars.hwnd.help_tooltips["settings_stash hotkey"] := hwnd
	}

	Gui, %GUI%: Add, Text, % "Section xs Border BackgroundTrans HWNDhwnd gSettings_stash2" (settings.stash.use_global ? " cLime" : " cGray"), % " " Lang_Trans("m_stash_globalprofiles") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.use_global := hwnd, vars.hwnd.help_tooltips["settings_stash global profiles"] := hwnd1

	Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans HWNDhwnd gSettings_stash2" (settings.stash.history ? " cLime" : " cGray"), % " " Lang_Trans("m_stash_pricehistory") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.history := hwnd, vars.hwnd.help_tooltips["settings_stash history"] := hwnd1

	If settings.stash.use_global
		Settings_stash_profiles(GUI, "global")

	Gui, %GUI%: Font, % "bold underline cWhite s" settings.general.fSize
	Gui, %GUI%: Add, Text, % "Section xs x" x_anchor " y+" vars.settings.spacing " h" settings.general.fHeight " 0x200", % Lang_Trans("global_ui")
	Gui, %GUI%: Font, norm

	Gui, %GUI%: Add, Text, % "Section xs Border HWNDhwnd0", % " " Lang_Trans("global_font") " "
	Gui, %GUI%: Add, Text, % "ys x+-1 Center Border BackgroundTrans gSettings_stash2 HWNDhwnd w"settings.general.fWidth*2, % "–"
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.help_tooltips["settings_font-size"] := hwnd0, vars.hwnd.settings.font_minus := hwnd, vars.hwnd.help_tooltips["settings_font-size|"] := hwnd1

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

	Gui, %GUI%: Add, Text, % (bookmarks_enabled ? "Section xs" : "ys") " Border", % " " Lang_Trans("stash_pricetags") " "
	colors := settings.stash.colors.Clone()

	Loop 3
	{
		If (A_Index = 2) || (A_Index = 3) && !bookmarks_enabled
			Continue
		color1 := colors[A_Index * 2 - 1], color2 := colors[A_Index * 2]
		Gui, %GUI%: Add, Text, % "ys x+-1 Border Center HWNDhwndtext BackgroundTrans c" color1, % " 69.42 "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border BackgroundBlack HWNDhwndback c" color2, 100
		Gui, %GUI%: Add, Text, % "ys x+-1 Border BackgroundTrans gSettings_stash2 HWNDhwnd00", % "  "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border BackgroundBlack HWNDhwnd01 c" color1, 100
		Gui, %GUI%: Add, Text, % "ys x+-1 Border BackgroundTrans gSettings_stash2 HWNDhwnd10", % "  "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border BackgroundBlack HWNDhwnd11 c" color2, 100
		vars.hwnd.settings["color_" A_Index * 2 - 1] := hwnd00, vars.hwnd.settings["color_" A_Index * 2 - 1 "_panel"] := hwnd01, vars.hwnd.settings["color_" A_Index * 2 - 1 "_text"] := hwndtext
		vars.hwnd.settings["color_" A_Index * 2] := hwnd10, vars.hwnd.settings["color_" A_Index * 2 "_panel"] := hwnd11, vars.hwnd.settings["color_" A_Index * 2 "_text"] := hwndback
		vars.hwnd.help_tooltips["settings_generic color double" handle] := hwnd01, vars.hwnd.help_tooltips["settings_generic color double1" handle] := hwnd11
		vars.hwnd.help_tooltips["settings_stash color tag" A_Index] := hwndback, handle .= "|"
	}

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "xs Section y+" vars.settings.spacing, % Lang_Trans("m_stash_tabs")
	Gui, %GUI%: Font, norm
	Gui, %GUI%: Add, Pic, % "ys BackgroundTrans HWNDhwnd hp w-1", % "HBitmap:*" vars.pics.global.help

	vars.hwnd.help_tooltips["settings_stash config"] := hwnd
	If WinExist("ahk_id " vars.hwnd.stash.main) && vars.stash.active
		vars.settings.selected_tab := vars.stash.active

	Gui, %GUI%: Add, Text, % "Section xs Center Border", % " " Lang_Trans("m_stash_active") " "
	Gui, %GUI%: Add, Text, % "ys x+-1 Center Border c" (vars.settings.selected_tab ? "Lime" : "FF8000"), % " " (vars.settings.selected_tab ? Lang_Trans("m_stash_" vars.settings.selected_tab) : Lang_Trans("global_none")) " "
	If !vars.settings.selected_tab
		Return

	tab := vars.settings.selected_tab
	Gui, %GUI%: Add, Text, % "Section xs Border HWNDhwnd0", % " " Lang_Trans("m_stash_grid") " "
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
		Else Gui, %GUI_name%: Add, Text, % (A_Index = 1 ? "xs" : "ys x+" settings.general.fWidth/2) " Section HWNDhwnd cWhite 0x200 Border Center w" settings.stash.fWidth * 2 " h" settings.stash.fHeight, % A_Index

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
	{
		Gui, %Gui%: Add, Text, % "xs y+-1 h1 w" settings.general.fWidth * vars.settings.min_width
		Return
	}

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "Section xs Center y+"vars.settings.spacing, % Lang_Trans("global_general")
	Gui, %GUI%: Font, norm

	Gui, %GUI%: Add, Text, % "xs Border Section HWNDhwnd0", % " " Lang_Trans("global_font") " "
	Gui, %GUI%: Add, Text, % "ys x+-1 Center Border BackgroundTrans gSettings_statlas2 HWNDhwnd w"settings.general.fWidth*2, % "–"
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.help_tooltips["settings_font-size"] := hwnd0, vars.hwnd.settings.font_minus := hwnd, vars.hwnd.help_tooltips["settings_font-size|"] := hwnd1

	Gui, %GUI%: Add, Text, % "ys x+-1 Center Border BackgroundTrans gSettings_statlas2 HWNDhwnd w"settings.general.fWidth*3, % settings.statlas.fSize
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.font_reset := hwnd, vars.hwnd.help_tooltips["settings_font-size||"] := hwnd1

	Gui, %GUI%: Add, Text, % "ys x+-1 Center Border BackgroundTrans gSettings_statlas2 HWNDhwnd w"settings.general.fWidth*2, % "+"
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.font_plus := hwnd, vars.hwnd.help_tooltips["settings_font-size|||"] := hwnd1

	Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans HWNDhwnd gSettings_statlas2" (settings.statlas.maptracker ? " cLime" : " cGray"), % " " Lang_Trans("ms_mapping tracker") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.maptracker := hwnd, vars.hwnd.help_tooltips["settings_statlas maptracker"] := hwnd1
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
	Gui, %GUI%: Add, Link, % "Section xs", <a href="https://github.com/Lailloken/Exile-UI/discussions/categories/translations-localization">exile ui discussions: translations</a>
}

Settings_updater()
{
	local
	global vars, settings
	static fSize, wCurrent

	If (fSize != settings.general.fSize)
	{
		fSize := settings.general.fSize
		LLK_PanelDimensions([Lang_Trans("m_updater_version", 2), Lang_Trans("m_updater_version", 3)], fSize, wCurrent, height)
	}

	GUI := "settings_menu" vars.settings.GUI_toggle
	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "Section x" vars.settings.x_anchor " y" vars.settings.ySelection, % Lang_Trans("m_updater_version")
	Gui, %GUI%: Font, norm
	Gui, %GUI%: Add, Pic, % "ys hp w-1 Center Border BackgroundTrans HWNDhwnd gSettings_updater2", % "HBitmap:*" vars.pics.global.reload
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.update_refresh := hwnd, vars.hwnd.help_tooltips["settings_updater refresh"] := hwnd1

	Gui, %GUI%: Add, Text, % "ys x+-1 Border BackgroundTrans HWNDhwnd gSettings_updater2" (settings.updater.update_check ? " cLime" : " cGray"), % " " Lang_Trans("global_auto") " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.update_check := hwnd, vars.hwnd.help_tooltips["settings_updater check"] := hwnd1

	Gui, %GUI%: Add, Text, % "Section xs w" wCurrent " Right Border", % Lang_Trans("m_updater_version", 2) " "
	Gui, %GUI%: Add, Text, % "ys x+-1 w" settings.general.fWidth * 5 " Center Border HWNDhwnd", % vars.updater.version.2
	ControlGetPos, x,,,,, ahk_id %hwnd%

	If settings.general.dev || GetKeyState("Shift", "P") && GetKeyState("CTRL", "P")
	{
		Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans HWNDhwnd gSettings_updater2", % " get dev build "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings.get_dev := hwnd, vars.hwnd.settings.get_dev_bar := hwnd1
	}
	Else If settings.general.dev || GetKeyState("CTRL", "P")
	{
		Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans HWNDhwnd gSettings_updater2", % " get hotfix "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings.get_hotfix := hwnd, vars.hwnd.help_tooltips["settings_updater hotfix unlisted"] := hwnd1
	}

	color := vars.updater.skip && (vars.updater.latest.1 = vars.updater.skip) ? " cYellow" : (IsNumber(vars.updater.latest.1) && vars.updater.latest.1 > vars.updater.version.1) ? " cLime" : ""
	Gui, %GUI%: Add, Text, % "Section xs y+-1 w" wCurrent " Right Border" color, % Lang_Trans("m_updater_version", 3) " "
	Gui, %GUI%: Add, Text, % "ys x+-1 w" settings.general.fWidth * 5 " Center Border hp" color, % vars.updater.latest.2

	If IsNumber(vars.updater.latest.1) && (vars.updater.latest.1 > vars.updater.version.1) && (vars.updater.latest.1 != vars.updater.skip)
	{
		Gui, %GUI%: Add, Text, % "Section xs Border Center BackgroundTrans gSettings_updater2 HWNDhwnd", % " " Lang_Trans("m_updater_skip") " "
		Gui, %GUI%: Add, Progress, % "xp yp wp hp Disabled Border range0-500 HWNDhwnd0 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 500
		vars.hwnd.settings.skip := hwnd, vars.hwnd.settings.skip_bar := vars.hwnd.help_tooltips["settings_updater skip"] := hwnd0

		Gui, %GUI%: Add, Text, % "ys Border Center BackgroundTrans gSettings_updater2 HWNDhwnd", % " " Lang_Trans("global_restart") " "
		Gui, %GUI%: Add, Progress, % "xp yp wp hp Disabled Border HWNDhwnd0 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		latest := vars.updater.latest.2, latest := InStr(latest, "hotfix") ? SubStr(latest, 1, InStr(latest, " (hotfix") - 1) : latest
		vars.hwnd.settings.restart_install2 := hwnd, vars.hwnd.help_tooltips["settings_updater changelog " latest "|"] := hwnd0
	}

	If IsNumber(vars.updater.latest.1) && IsObject(vars.updater.changelog)
	{
		Gui, %GUI%: Font, underline bold
		Gui, %GUI%: Add, Text, % "Section xs y+" vars.settings.spacing, % Lang_Trans("m_updater_recent")
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
				Gui, %GUI%: Add, Text, % (outer = 1 || A_Index = 2 ? "Section xs" : "ys x+" settings.general.fWidth/2) " Border HWNDhwnd" (RegExMatch(key, "i)major.changes|new.feature") ? " cFF8000" : ""), % " " StrReplace(key, "&", "&&") " "
				vars.hwnd.help_tooltips["settings_recentchanges " key] := hwnd
				ControlGetPos, xControl, yControl, wControl, hControl,, % "ahk_id " hwnd
				If (xControl + wControl <= vars.settings.x_anchor + settings.general.fWidth * 34)
					Break
				Else GuiControl, +Hidden, % hwnd
			}
		}

		Gui, %GUI%: Font, % "underline bold s" settings.general.fSize
		Gui, %GUI%: Add, Text, % "Section xs y+" vars.settings.spacing, % Lang_Trans("m_updater_versions")
		added := {}, selected := vars.updater.selected, selected_sub := SubStr(selected, InStr(selected, ".",, 0) + 1)
		Gui, %GUI%: Font, norm
		Gui, %GUI%: Add, Pic, % "ys hp w-1 HWNDhwnd", % "HBitmap:*" vars.pics.global.help
		vars.hwnd.help_tooltips["settings_updater versions"] := hwnd

		For index, val in vars.updater.changelog
		{
			major := SubStr(val.1.1, 1, 5)
			If !added[major]
				If (index >= 4)
					Continue
				Else Gui, %GUI%: Add, Text, % "Section xs w" settings.general.fWidth * 4 " Center Border", % major

			minor := SubStr(val.1.2, -1) + 0, color := (selected = major . minor) ? " cFuchsia" : val.1.3 ? " cFF8000" : ""
			Gui, %GUI%: Add, Text, % "ys x+" settings.general.fWidth/2 " Border BackgroundTrans HWNDhwnd gSettings_updater2 Center w" settings.general.fWidth * 2 . color, % minor
			Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
			vars.hwnd.settings["versionselect_" major . minor] := hwnd, vars.hwnd.help_tooltips["settings_updater changelog " major . minor] := hwnd1, added[major] := 1
		}
	}

	If vars.updater.selected
	{
		Gui, %GUI%: Add, Text, % "ys Border Center BackgroundTrans gSettings_updater2 HWNDhwnd cFuchsia", % " " Lang_Trans("global_restart", 2) " "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border range0-500 HWNDhwnd0 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 500
		vars.hwnd.settings.restart_install := hwnd, vars.hwnd.settings.restart_bar := vars.hwnd.help_tooltips["settings_updater restart"] := hwnd0

		Gui, %GUI%: Add, Text, % "Section xs Border Center BackgroundTrans gSettings_updater2 HWNDhwnd00", % " " Lang_Trans("m_updater_changelog") " "
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd01 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings["fullchangelog_" vars.updater.selected] := hwnd00, vars.hwnd.help_tooltips["settings_updater full changelog"] := hwnd01
	}

	If IsNumber(vars.update.1) && (vars.update.1 < 0)
	{
		Gui, %GUI%: Font, bold underline
		Gui, %GUI%: Add, Text, % "Section xs cRed y+"vars.settings.spacing, % Lang_Trans("m_updater_failed")
		Gui, %GUI%: Font, norm

		If InStr("126", StrReplace(vars.update.1, "-"))
			Gui, %GUI%: Add, Text, % "Section xs w" settings.general.fWidth * vars.settings.min_width, % Lang_Trans("m_updater_error1") "`n`n" Lang_Trans("m_updater_error1", 2)
		Else If (vars.update.1 = -4)
			Gui, %GUI%: Add, Text, % "Section xs w" settings.general.fWidth * vars.settings.min_width, % Lang_Trans("m_updater_error2") " " Lang_Trans("m_updater_error2", 2) "`n`n" Lang_Trans("m_updater_error2", 3)
		Else If (vars.update.1 = -3)
			Gui, %GUI%: Add, Text, % "Section xs w" settings.general.fWidth * vars.settings.min_width, % Lang_Trans("m_updater_error3")
		Else If InStr("5", StrReplace(vars.update.1, "-"))
			Gui, %GUI%: Add, Text, % "Section xs w" settings.general.fWidth * vars.settings.min_width, % Lang_Trans("m_updater_error4") " " Lang_Trans("m_updater_error2", 2) "`n`n" Lang_Trans("m_updater_error2", 3)

		If InStr("35", StrReplace(vars.update.1, "-"))
		{
			Gui, %GUI%: Add, Text, % "Section xs Center Border BackgroundTrans HWNDmanual gSettings_updater2", % " " Lang_Trans("m_updater_manual") " "
			Gui, %GUI%: Add, Progress, % "xp yp wp hp Border HWNDbar range0-10 BackgroundBlack cGreen", 0
			Gui, %GUI%: Add, Text, % "ys Center Border HWNDgithub gSettings_updater2", % " " Lang_Trans("m_updater_manual", 2) " "
			vars.hwnd.settings.manual := manual, vars.hwnd.settings.manual_bar := vars.hwnd.help_tooltips["settings_updater manual"] := bar, vars.hwnd.settings.github := vars.hwnd.help_tooltips["settings_updater github"] := github
		}
	}

	Gui, %GUI%: Font, bold underline
	Gui, %GUI%: Add, Text, % "Section xs y+"vars.settings.spacing, % Lang_Trans("m_updater_github")
	Gui, %GUI%: Font, norm
	Gui, %GUI%: Add, Text, % "Section xs Center Border BackgroundTrans HWNDpage gSettings_updater2", % " " Lang_Trans("m_updater_github", 2) " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	Gui, %GUI%: Add, Text, % "ys Center Border BackgroundTrans HWNDreleases gSettings_updater2", % " " Lang_Trans("m_updater_github", 3) " "
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
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
		Run, % "https://github.com/Lailloken/Exile-UI/tree/"control
	Else If (check = "releases_page")
		Run, % "https://github.com/Lailloken/Exile-UI/releases"
	Else If (check = "update_check")
	{
		IniWrite, % (settings.updater.update_check := !settings.updater.update_check), ini\config.ini, settings, update auto-check
		GuiControl, % "+c" (settings.updater.update_check ? "Lime" : "Gray"), % cHWND
		GuiControl, % "movedraw", % cHWND
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
		Run, % "https://github.com/Lailloken/Exile-UI/releases/tag/v" control
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
		If !settings.general.dev || LLK_Progress(vars.hwnd.settings.restart_bar, "LButton",,, 500)
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
		If (vars.system.click = 1) && LLK_Progress(vars.hwnd.settings.skip_bar, "LButton",,, 500, "Red", vars.settings.cButtons)
		{
			vars.updater.skip := vars.updater.latest.1, vars.update := [0]
			IniWrite, % vars.updater.latest.1, ini\config.ini, versions, skip
			Settings_menu("updater")
		}
	}
	Else LLK_ToolTip("no action")
}

Settings_CharTracking(mode, wEdits := "")
{
	local
	global vars, settings
	static fSize, wChar, wChar2

	If (fSize != settings.general.fSize)
	{
		fSize := settings.general.fSize
		LLK_PanelDimensions([Lang_Trans("m_general_character") . Lang_Trans("global_colon"), Lang_Trans("global_info") . Lang_Trans("global_colon")], fSize, wChar, hChar)
		LLK_PanelDimensions([Lang_Trans("m_general_character") . Lang_Trans("global_colon"), Lang_Trans("global_league") . Lang_Trans("global_colon"), Lang_Trans("global_info") . Lang_Trans("global_colon")], fSize, wChar2, hChar2)
	}

	GUI := "settings_menu" vars.settings.GUI_toggle, margin := settings.general.fWidth/4, profile := settings.leveltracker.profile
	char := settings.leveltracker["guide" profile].info.character
	If (mode = "general")
		color := " " (vars.log.level ? "cLime" : (settings.general.character ? "cYellow" : "cFF8000"))
	Else color := " " (vars.log.level && settings.general.character = char ? "cLime" : (char ? "cYellow" : "cFF8000"))

	wEdits := (!wEdits ? settings.general.fWidth2 * 18 : wEdits - wChar), valid_char := (mode = "general" && vars.log.level || mode = "leveltracker" && vars.log.level && settings.general.character = char)
	If valid_char
		LLK_PanelDimensions([vars.log.character_class " (" vars.log.level ")"], settings.general.fSize - 4, wClass, hClass), wEdits := Max(wEdits, wClass)

	Gui, %GUI%: Add, Text, % "Section xs y+" vars.settings.line1 " w" (mode = "general" ? wChar2 : wChar) . (valid_char ? " h" 2*settings.general.fHeight - 1 " 0x200" : "") " Border Right HWNDhwnd" color, % Lang_Trans("m_general_character") . Lang_Trans("global_colon") " "
	Gui, %GUI%: Font, % "s" settings.general.fSize - 4
	char_text := (mode = "general" ? settings.general.character : settings.leveltracker["guide" profile].info.character)
	Gui, %GUI%: Add, Text, % "Section ys x+-1 w" wEdits " h" settings.general.fHeight " Border BackgroundTrans"
	Gui, %GUI%: Add, Edit, % "xp yp wp hp Border cBlack HWNDhwnd1 LowerCase gSettings_CharTracking2", % char_text
	If valid_char
	{
		Gui, %GUI%: Font, % "s" settings.general.fSize - 4
		Gui, %GUI%: Add, Text, % "xs y+-1 w" wEdits " hp HWNDhwnd0 Border 0x200", % " " vars.log.character_class " (" vars.log.level ")"
		vars.hwnd.settings.class_text := vars.hwnd.help_tooltips["settings_ascendancy"] := hwnd0
	}
	Gui, %GUI%: Font, % "s" settings.general.fSize
	vars.hwnd.help_tooltips["settings_" (mode = "general" ? "active character status" : "leveltracker character status")] := hwnd
	vars.hwnd.settings.charinfo := vars.hwnd.help_tooltips["settings_" (mode = "general" ? "active character" : "leveltracker character info")] := hwnd1
	ControlGetPos, xEdit1, yEdit1, wEdit1, hEdit1,, ahk_id %hwnd1%

	If (mode = "general" && settings.general.character || mode = "leveltracker" && char)
	{
		Gui, %GUI%: Add, Text, % "ys x+-1 w" settings.general.fHeight " h" (valid_char ? 2*settings.general.fHeight - 1 : settings.general.fHeight) " Border BackgroundTrans HWNDhwnd00 gSettings_CharTracking2"
		Gui, %GUI%: Add, Pic, % "xp yp+" (valid_char ? settings.general.fHeight/2 : 0) " wp h-1 BackgroundTrans HWNDhwnd01", % "HBitmap:*" vars.pics.global.reload
		Gui, %GUI%: Add, Progress, % "Disabled xp y" LLK_ControlGetPos(hwnd00, "y") - 1 " w" settings.general.fHeight " h" (valid_char ? 2*settings.general.fHeight - 1 : "p") " HWNDhwnd1 Border Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
		vars.hwnd.settings.refresh_class := hwnd00, vars.hwnd.settings.refresh_class_pic := vars.hwnd.help_tooltips["settings_active character whois"] := hwnd01
		vars.hwnd.settings.refresh_class_bar := vars.hwnd.help_tooltips["settings_active character whois|"] := hwnd1
	}

	If vars.log.level && settings.features.maptracker && settings.maptracker.character || (mode = "leveltracker")
	{
		Gui, %GUI%: Add, Text, % "Section xs x" vars.settings.x_anchor " y+-1 Border Right HWNDhwnd w" (mode = "leveltracker" ? wChar : wChar2), % Lang_Trans("global_info") . Lang_Trans("global_colon") " "
		Gui, %GUI%: Font, % "s"settings.general.fSize - 4
		build_text := (mode = "general" ? settings.general.build : settings.leveltracker["guide" profile].info.name)
		Gui, %GUI%: Add, Text, % "ys x+-1 hp Border BackgroundTrans w" wEdits
		Gui, %GUI%: Add, Edit, % "xp yp wp hp Border cBlack HWNDhwnd1 LowerCase gSettings_CharTracking2 w" wEdits, % build_text
		Gui, %GUI%: Font, % "s" settings.general.fSize
		vars.hwnd.help_tooltips["settings_" (mode = "general" ? "active build" : "leveltracker profile name")] := vars.hwnd.settings.buildinfo := hwnd1
		ControlGetPos, xEdit2, yEdit2, wEdit2, hEdit2,, ahk_id %hwnd1%
	}
	Else yEdit2 := yEdit1, hEdit2 := hEdit1

	Gui, %GUI%: Add, Text, % "Hidden ys x" xEdit1 + wEdit1 - 2 " y" yEdit1 - 1 " h" yEdit2 + hEdit2 - yEdit1 " Border BackgroundTrans 0x200 cRed HWNDhwnd gSettings_CharTracking2", % " " Lang_Trans("global_save") " "
	Gui, %GUI%: Add, Progress, % "Hidden Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.save_buildinfo := hwnd, vars.hwnd.settings.save_buildinfo_bar := hwnd1
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
			GuiControl, % "+Hidden", % vars.hwnd.settings.refresh_class
			GuiControl, % "+Hidden", % vars.hwnd.settings.refresh_class_pic
			GuiControl, % "+Hidden", % vars.hwnd.settings.refresh_class_bar
		}
		Else
		{
			GuiControl, % "+Hidden", % vars.hwnd.settings.save_buildinfo
			GuiControl, % "+Hidden", % vars.hwnd.settings.save_buildinfo_bar
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

Settings_LeagueSelection(ByRef yCoord)
{
	local
	global vars, settings
	static fSize, wLeague, widths, widths_count

	leagues := vars.leagues, league := settings.general.league
	objects := [leagues, leagues[league.1], leagues[league.1][league.2], leagues[league.1][league.2][league.3], leagues[league.1][league.2][league.3][league.4]]

	If (fSize != settings.general.fSize) || (widths_count != objects[(vars.poe_version ? 3 : 4)].Count())
	{
		fSize := settings.general.fSize, widths := []
		LLK_PanelDimensions([Lang_Trans("m_general_character") . Lang_Trans("global_colon"), Lang_Trans("global_league") . Lang_Trans("global_colon")], fSize, wLeague, hLeague)
	}
	widths_count := objects[(vars.poe_version ? 3 : 4)].Count()

	GUI := "settings_menu" vars.settings.GUI_toggle, margin := settings.general.fWidth/4, yMax := 0
	Gui, %GUI%: Add, Text, % "Section xs x" vars.settings.x_anchor " Border 0x200 Right HWNDhwnd w" wLeague " h" (hPanel := settings.general.fHeight * vars.leagues.Count() - 1), % Lang_Trans("global_league") . Lang_Trans("global_colon") " "
	ControlGetPos, xFirst, yFirst, wFirst, hFirst,, ahk_id %hwnd%
	vars.hwnd.help_tooltips["settings_league selection"] := hwnd, yCoord := yFirst + hFirst, handle := "|"

	Loop, % (vars.poe_version ? 3 : 4)
	{
		outer := A_Index
		If Blank(widths[outer])
		{
			dimensions := []
			For key in objects[outer]
				dimensions.Push(Lang_Trans("global_league_" key))
			LLK_PanelDimensions(dimensions, settings.general.fSize, width, height), widths[outer] := width
		}
		For key in objects[outer]
		{
			color := (key = league[outer] ? " cLime" : "")
			Gui, %GUI%: Add, Text, % (A_Index = 1 ? "Section ys x+-1" : "xs y+-1") " Border BackgroundTrans Center HWNDhwnd gSettings_LeagueSelection2 w" widths[outer] . color, % Lang_Trans("global_league_" key)
			Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
			vars.hwnd.settings["leagueselect_" outer "|" key] := hwnd, vars.hwnd.help_tooltips["settings_league selection" handle] := hwnd1, handle .= "|"
		}
	}

	count := (vars.poe_version ? vars.leagues.sc.trade.Count() : vars.leagues.sc.trade.normal.Count()), height := settings.general.fHeight * count - (count - 1)
	Gui, %GUI%: Add, Text, % "ys x+-1 w" settings.general.fHeight " h" height " BackgroundTrans Border gSettings_LeagueSelection2 HWNDhwnd"
	Gui, %GUI%: Add, Pic, % (count > 1 ? "xp+1 yp+" (count - 1) * settings.general.fHeight//2 " wp-2 h-1" : "xp+1 yp+1 wp-2 hp-2") " BackgroundTrans HWNDhwnd1", % "HBitmap:*" vars.pics.global.reload
	Gui, %GUI%: Add, Progress, % "Disabled xp-1 y" yFirst - 1 " w" settings.general.fHeight " h" height " Border HWNDhwnd2 Background" vars.settings.cButtons2 " c" vars.settings.cButtons, 100
	vars.hwnd.settings.league_update := hwnd, vars.hwnd.help_tooltips["settings_league update"] := hwnd1, vars.hwnd.help_tooltips["settings_league update|"] := hwnd2
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

	If (cHWND = vars.hwnd.settings.writetest)
	{
		IniWrite, % vars.settings.active, % "ini" vars.poe_version "\config.ini", Versions, reload settings
		Run *RunAs "%A_AhkPath%" /restart "%A_ScriptFullPath%"
		ExitApp
	}

	If running
		Return
	running := 1, HWND_bar := vars.hwnd.settings.bar_writetest, yes := Lang_Trans("m_permission_yes"), no := Lang_Trans("m_permission_no"), unknown := Lang_Trans("m_permission_unknown")
	GuiControl, % "+cGreen", % HWND_bar
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
	GuiControl, % "+c" vars.settings.cButtons, % HWND_bar
	running := 0
}
