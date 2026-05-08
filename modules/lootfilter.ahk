Init_Lootfilter()
{
	local
	global vars, settings

	If !FileExist("ini" vars.poe_version "\lootfilter.ini")
		IniWrite, % settings.general.fSize, % "ini" vars.poe_version "\lootfilter.ini", settings, font-size

	If !IsObject(vars.lootfilter)
		vars.lootfilter := {"search": [""], "modifications": {}, "modifications_pending": []
		, "xPos": [vars.monitor.x + vars.client.x + vars.client.w - Floor(vars.client.h * 0.6155), vars.monitor.x + vars.client.x + Floor(vars.client.h * 0.6155)]
		, "yPos": [vars.monitor.y + vars.client.y + vars.client.h*0.53, vars.monitor.y + vars.client.y + vars.client.h*0.17]}
		, settings.lootfilter := {}, vars.lootfilter.search.0 := 1, vars.lootfilter_tester := {}, vars.lootfilter.modifications_pending.0 := ""

	ini := IniBatchRead("ini" vars.poe_version "\lootfilter.ini")
	settings.lootfilter.fSize := !Blank(check := ini.settings["font-size"]) ? check : settings.general.fSize
	LLK_FontDimensions(settings.lootfilter.fSize, font_height, font_width), settings.lootfilter.fHeight := font_height, settings.lootfilter.fWidth := font_width
	LLK_FontDimensions(settings.lootfilter.fSize - 2, font_height, font_width), settings.lootfilter.fHeight2 := font_height, settings.lootfilter.fWidth2 := font_width

	settings.lootfilter.active_filter := !Blank(check := ini.settings["active filter"]) ? check : ""
	settings.lootfilter.profile := !Blank(check := ini.settings.profile) ? check : 1
	settings.lootfilter.color_background_default := "324F6C", settings.lootfilter.color_accent_default := "282840"
	settings.lootfilter.color_background := !Blank(check := ini.UI["background color"]) ? check : settings.lootfilter.color_background_default
	settings.lootfilter.color_accent := !Blank(check := ini.UI["accent color"]) ? check : settings.lootfilter.color_accent_default
	settings.lootfilter.modifier_key := !Blank(check := ini.settings["modifier key"]) ? check : "alt"

	settings.lootfilter.defaults := defaults := {"opacity": {"minimum": 100, "medium": 150, "maximum": 255}, "size": {"minimum": 25, "medium": 35, "maximum": 45}}
	settings.lootfilter.opacity_minimum := !Blank(check := ini.UI["minimum opacity"]) ? check : defaults.opacity.minimum
	settings.lootfilter.opacity_medium := !Blank(check := ini.UI["medium opacity"]) ? check : defaults.opacity.medium
	settings.lootfilter.opacity_maximum := !Blank(check := ini.UI["maximum opacity"]) ? check : defaults.opacity.maximum
	settings.lootfilter.size_minimum := !Blank(check := ini.UI["minimum size"]) ? check : defaults.size.minimum
	settings.lootfilter.size_medium := !Blank(check := ini.UI["medium size"]) ? check : defaults.size.medium
	settings.lootfilter.size_maximum := !Blank(check := ini.UI["maximum size"]) ? check : defaults.size.maximum
}

Lootfilter_Clipboard()
{
	local
	global vars, settings

	item := vars.omnikey.item
	If !(item.itembase . item.name)
	{
		LLK_ToolTip(Lang_Trans("global_match"),,,,, "FF8000")
		Return
	}
	search := StrReplace(vars.omnikey.clipboard, "`r`n", "`n"), search := StrReplace(search, " (augmented)")
	sIndex := vars.lootfilter.search.0, current_search := (IsObject(vars.lootfilter.search[sIndex]) ? vars.lootfilter.search[sIndex].clipboard : vars.lootfilter.search[sIndex])
	If (search != current_search)
		vars.lootfilter.search.RemoveAt(sIndex + (current_search ? 1 : 0), 9999), vars.lootfilter.search.Push({"clipboard": search, "item": vars.omnikey.item.Clone()}), vars.lootfilter.search.0 += (current_search ? 1 : 0)
	Lootfilter_Editor("clipboard")
}

Lootfilter_Customize(cHWND := "")
{
	local
	global vars, settings

	check := LLK_HasVal(vars.hwnd.lootfilter, cHWND), control := Substr(check, InStr(check, "_") + 1), profile := settings.lootfilter.profile
	For index, object in vars.lootfilter.modifications_pending
		If (object.action = "presentation") && (object.type = vars.lootfilter.last_type && object.tier = vars.lootfilter.last_tier)
		{
			target_index := index
			Break
		}
	KeyWait, LButton
	KeyWait, RButton
	Switch
	{
		Case InStr(check, "globalsetting_"):
		indexes := {"visual": -1, "gem": -11, "map": -21, "strand": -31, "economy1": -101, "economy2": -102, "economy3": -103, "economy4": -104}
		If !vars.poe_version
			types := {"gem": "gems > generic", "map": "maps", "strand": "gear > memorystrand", "economy1": "currency", "economy2": "divination", "economy3": "currency > essence"}
		Else types := {"gem": "gems > uncut", "economy1": "currency", "economy3": "currency > essence", "economy4": "sockets > general"}
		params := StrSplit(control, "|"), setting := params.1, type := params.2, iTarget := indexes[setting]

		If params.3
			input := (params.3 = "off" ? 0 : (params.3 = "on" ? 1 : settings.lootfilter[params.2 "_" params.3]))
		Else input := LLK_ControlGet(cHWND)

		current := LLK_CloneObject(IsObject(vars.lootfilter.modifications_pending[iTarget]) ? vars.lootfilter.modifications_pending[iTarget] : vars.lootfilter.modifications["profile" profile][iTarget])
		If (economy := InStr(control, "economy"))
		{
			input := LLK_ControlGet(vars.hwnd.lootfilter["cutoff_" type]), input := (input = "" ? 0 : Trim(StrReplace(input, ",", "."), " ")), input := (SubStr(input, 1, 1) = "." ? "0" input : input)
			If !Blank(input) && (input != 0) && (!IsObject(modifications := Lootfilter_Economy(type, input)) || !modifications.Count())
			{
				LLK_ToolTip(Lang_Trans((modifications = -1 ? "global_errorname" : (!modifications.Count() ? "lootfilter_lowcutoff" : "async_pricefailed")), (modifications = -1 ? 2 : 1)), 2,,,, "FF8000")
				Return 
			}
		}

		If !economy && (input = current.modifications[type] || !input && !current.modifications[type]) || economy && !input && !current.action
			Return

		If current.Count()
		{
			vars.lootfilter.modifications_pending[iTarget] := current.Clone()
			If input
			{
				If (current.modifications.toggle = "off")
					vars.lootfilter.modifications_pending[iTarget].modifications := {}
				If !economy
					vars.lootfilter.modifications_pending[iTarget].modifications[type] := input
				Else vars.lootfilter.modifications_pending[iTarget].modifications := modifications, vars.lootfilter.modifications_pending[iTarget].action := "economy|" input
				reset := (RegexMatch(setting, "i)map|economy") ? 1 : 0)
			}
			Else
			{
				If economy
					vars.lootfilter.modifications_pending[iTarget].modifications := "", vars.lootfilter.modifications_pending[iTarget].action := "economy|"
				Else If vars.lootfilter.modifications_pending[iTarget].modifications[type]
					vars.lootfilter.modifications_pending[iTarget].modifications.Delete(type)
				If !vars.lootfilter.modifications_pending[iTarget].modifications.Count()
					vars.lootfilter.modifications_pending[iTarget].modifications := {"toggle": "off"}
				reset := 1
			}
		}
		Else vars.lootfilter.modifications_pending[iTarget] := {"action": (economy ? "economy|" input : "global " setting "s"), "modifications": (economy ? modifications : {(type): input}), "type": types[setting]}

		If economy && (vars.lootfilter.modifications_pending[iTarget].modifications.toggle = "off") && !vars.lootfilter.modifications["profile" profile][iTarget].modifications.Count()
			match := 1
		Else For kSetting, array in (!vars.poe_version ? {"gem": ["quality", "level"], "map": ["tier"], "strand": ["strands high", "strands"], "visual": ["size", "opacity"]}
			: {"gem": ["skilllevel", "spiritlevel", "supportlevel"], "visual": ["size", "opacity"]})
			If (setting = kSetting)
			{
				match := 1
				For index, val in array
					match *= (vars.lootfilter.modifications_pending[iTarget].modifications[val] = vars.lootfilter.modifications["profile" profile][iTarget].modifications[val])
				Break
			}

		If match
			vars.lootfilter.modifications_pending.Delete(iTarget), reset := 1

		If reset
		{
			Lootfilter_Load("init_" settings.lootfilter.active_filter)
			For index, object in vars.lootfilter.modifications_pending
				If !InStr(object.action, "economy") && (object.modifications.toggle != "off") && (warning := Lootfilter_Modify(object))
					vars.lootfilter.modifications_pending[index].warning := warning
		}
		Else If (warning := Lootfilter_Modify(vars.lootfilter.modifications_pending[iTarget]))
			vars.lootfilter.modifications_pending[iTarget].warning := warning
		;######################################################
		Case InStr(check, "customize_size"):
		size := settings.lootfilter["size_" SubStr(check, InStr(check, "|") + 1)]
		If !target_index
			object := {"action": "presentation", "type": vars.lootfilter.last_type, "tier": vars.lootfilter.last_tier, "modifications": {"SetFontSize": size}}, vars.lootfilter.modifications_pending.Push(object)
		Else vars.lootfilter.modifications_pending[target_index].modifications.SetFontSize := size, object := vars.lootfilter.modifications_pending[target_index]
		Lootfilter_Modify(object)
		;######################################################
		Case InStr(check, "customize_opacity"):
		opacity := settings.lootfilter["opacity_" SubStr(check, InStr(check, "|") + 1)]
		If !target_index
			object := {"action": "presentation", "type": vars.lootfilter.last_type, "tier": vars.lootfilter.last_tier, "modifications": {}}, vars.lootfilter.modifications_pending.Push(object)
			, target_index := vars.lootfilter.modifications_pending.MaxIndex()

		object := vars.lootfilter.modifications_pending[target_index]
		If !object.modifications.SetBackgroundColor
			object.modifications.SetBackgroundColor := ["", "", "", opacity]
		Else object.modifications.SetBackgroundColor.4 := opacity
		Lootfilter_Modify(object)
		;######################################################
		Case (check = "customize_memorystrands"):
		If ((input := LLK_ControlGet(cHWND)) = vars.lootfilter.last_style.memorystrands)
			Return
		If !target_index
			object := {"action": "presentation", "type": vars.lootfilter.last_type, "tier": vars.lootfilter.last_tier, "modifications": {"MemoryStrands": input}}, vars.lootfilter.modifications_pending.Push(object)
		Else vars.lootfilter.modifications_pending[target_index].modifications.MemoryStrands := input, object := vars.lootfilter.modifications_pending[target_index]
		Lootfilter_Modify(object)
		;######################################################
		Case InStr(check, "customize_"):
		If (vars.system.click = 1)
		{
			RGB := RGB_Picker(vars.lootfilter.last_style["Set" control "Color"])
			If Blank(RGB)
				Return
		}
		Else
		{
			For iChunk, vChunk in vars.lootfilter.active_filter.stock
				If (vChunk.type && vChunk.type = vars.lootfilter.last_type) && (vChunk.tier && vChunk.tier = vars.lootfilter.last_tier)
					For iLine, vLine in vChunk.lines
						For key, val in vLine
							If InStr(key, "Set" control "Color")
								RGB := RGB_Convert(val)
			If Blank(RGB)
			{
				LLK_ToolTip(Lang_Trans("global_match"),,,,, "FF8000")
				Return
			}
		}

		If !target_index
			object := {"action": "presentation", "type": vars.lootfilter.last_type, "tier": vars.lootfilter.last_tier, "modifications": {}}, vars.lootfilter.modifications_pending.Push(object)
			, target_index := vars.lootfilter.modifications_pending.MaxIndex()

		object := vars.lootfilter.modifications_pending[target_index]
		If !object.modifications["Set" control "Color"]
			object.modifications["Set" control "Color"] := RGB_Convert(RGB), object.modifications["Set" control "Color"].4 := ""
		Else
			For index, val in RGB_Convert(RGB)
				object.modifications["Set" control "Color"][index] := val
		Lootfilter_Modify(object)
		;######################################################
		Case InStr(check, "toggle_"):
		parse := Trim(SubStr(check, InStr(check, "|")), " |"), parse := StrSplit(parse, "|", " "), type := parse.1, tier := parse.2, toggle := SubStr(control, 1, InStr(control, "|") - 1)
		For index, object in vars.lootfilter.modifications_pending
			If (object.action = "presentation") && (object.type = type) && (object.tier = tier)
			{
				If (vars.lootfilter.modifications_pending[index].modifications.visibility = toggle)
					Return
				vars.lootfilter.modifications_pending[index].modifications.visibility := toggle, check := 1, Lootfilter_Modify(vars.lootfilter.modifications_pending[index])
				vars.lootfilter.modifications_pending[index].modifications.Delete("visibility")
				If !vars.lootfilter.modifications_pending[index].modifications.Count()
					vars.lootfilter.modifications_pending.RemoveAt(index)
				Break
			}
		If (check != 1)
			For index, chunk in vars.lootfilter.active_filter.final
				If (chunk.type = type && chunk.tier = tier)
				{
					If RegExMatch(chunk.lines.1, "i)^.{0,2}" toggle)
						Return
					Break
				}
		If (check != 1)
			object := {"action": "presentation", "type": type, "tier": tier, "modifications": {"visibility": toggle}}, vars.lootfilter.modifications_pending.Push(object), Lootfilter_Modify(object)
		;######################################################
		Case InStr(check, "movetier_newtier|"):
		target_chunk := SubStr(control, InStr(control, "|") + 1), count := 0
		While LLK_Haskey(vars.lootfilter.structure[vars.lootfilter.last_type], "exui_hide" (count ? count : ""),,,, 1)
			count += 1
		object := {"action": "newtier", "type": vars.lootfilter.last_type, "tier": "exui_hide" (count ? count : ""), "modifications": {"newtier": vars.lootfilter.last_item}}
		If (warning := Lootfilter_Modify(object))
			object.warning := warning
		vars.lootfilter.modifications_pending.Push(object), vars.lootfilter.search.Pop(), vars.lootfilter.search.0 -= 1
		;######################################################
		Case InStr(check, "movetier_"):
		If (vars.system.click = 2)
		{
			GuiControl,, % vars.hwnd.lootfilter.search_edit, % "type: """ vars.lootfilter.last_type """, tier: """ control """"
			Lootfilter_Editor("search")
			Return
		}
		Else If (control = vars.lootfilter.last_tier)
			Return
		object := {"action": "movetier", "type": vars.lootfilter.last_type, "tier": control, "modifications": {"movetier": vars.lootfilter.last_item}}
		If (warning := Lootfilter_Modify(object))
			object.warning := warning
		vars.lootfilter.modifications_pending.Push(object), vars.lootfilter.search.Pop(), vars.lootfilter.search.0 -= 1
		;######################################################
		Case check:
		LLK_ToolTip("no action")
		Return
	}
	Lootfilter_Editor()
}

Lootfilter_Dump()
{
	local
	global vars, settings

	For index, val in vars.lootfilter.active_filter.final
	{
		If !IsObject(val)
			dump .= (dump ? "`n`n" : "") . val
		Else
		{
			For index2, line in val.lines
				If !IsObject(line)
					dump .= (index2 = 1 ? "`n`n" : "`n") line
				Else
					For key, line2 in line
						dump .= "`n" key " " line2
		}
	}
	new_file := FileOpen(vars.system.config_folder "\FilterSpoon.filter", "w", "UTF-8-RAW")
	new_file.Write(dump "`n"), new_file.Close()
}

Lootfilter_Economy(type, input)
{
	local
	global vars, settings
	static types := {"currency": "currency", "divcards": "divination", "essences": "currency > essence", "socketables": "sockets > general"}

	If !IsNumber(input)
		Return -1

	Economy_Update(type), modifications := []
	If (vars.economy[type].timestamp.2 = "failed")
		Return 0

	For item, price in vars.economy[type]
		If !(item := vars.economy.names[item]) || !LLK_HasVal(vars.lootfilter.active_filter.structure[types[type]], """" item """", 1,,, 1)
			Continue
		Else If (price < input)
			modifications.Push({"action": (modifications.Count() ? "movetier" : "newtier"), "type": types[type], "tier": "exui_hide", "modifications": {(modifications.Count() ? "movetier" : "newtier"): item}})

	Return modifications
}

Lootfilter_Editor(cHWND := "")
{
	local
	global vars, settings, json
	static toggle := 0, fSize, wLabels, wExpand, hItems, hItems2, wSyncApply, wShowHide, wQualityLevel, wMapTier, wStrands, wOff, wApplyUpdate
	, background, collapsed_tiers := {}, collapsed_types := {}, last_chunk, modbox_div := 40

	If (cHWND = "close")
	{
		LLK_Overlay(vars.hwnd.lootfilter.main, "destroy"), vars.hwnd.lootfilter := ""
		Return
	}

	check := LLK_HasVal(vars.hwnd.lootfilter, cHWND), control := SubStr(check, InStr(check, "_") + 1), profile := settings.lootfilter.profile
	If check
	{
		KeyWait, LButton
		If !InStr(check, "modification_")
			KeyWait, RButton
	}

	Switch
	{
		Case (check = "list_reload"):
		Lootfilter_Load("refresh", (vars.system.click = 2 && settings.general.dev ? 1 : 0))
		;######################################################
		Case (check = "filter_select"):
		input := LLK_ControlGet(cHWND), input := SubStr(input, 1, InStr(input, " (") - 1)
		If !input || (settings.lootfilter.active_filter = input)
			Return
		Else If (vars.system.click = 1)
		{
			If settings.lootfilter.active_filter
				vars.lootfilter.update_applied := 1
			IniWrite, % """" (settings.lootfilter.active_filter := input) """", % "ini" vars.poe_version "\lootfilter.ini", settings, active filter
			Lootfilter_Load("init_" input)
		}
		Else If (vars.system.click = 2)
		{
			file_name := vars.lootfilter.filters_list[input].1
			FileDelete, % vars.system.config_folder "\OnlineFilters\" file_name
			vars.lootfilter.filters_list.Delete(input)
		}
		;######################################################
		Case InStr(check, "profile_"):
		If (control = profile)
			Return
		IniWrite, % (profile := settings.lootfilter.profile := control), % "ini" vars.poe_version "\lootfilter.ini", settings, profile
		If settings.lootfilter.active_filter
			Lootfilter_Load("init_" settings.lootfilter.active_filter), vars.lootfilter.update_applied := 1
		;######################################################
		Case (check = "cancel"):
		vars.lootfilter.modifications_pending := [], vars.lootfilter.modifications_pending.0 := "", Lootfilter_Load("init_" settings.lootfilter.active_filter)
		;######################################################
		Case (check = "filter_apply"):
		For index, val in vars.lootfilter.modifications_pending
			If IsObject(val) && (val.modifications.toggle != "off")
			{
				If (index > 0)
					vars.lootfilter.modifications["profile" profile].Push(val)
				IniWrite, % """" json.dump(val) """", % "ini" vars.poe_version "\lootfilter.ini", % "modifications - profile " profile, % (index < 0 ? index : vars.lootfilter.modifications["profile" profile].MaxIndex())
			}
			Else If (val.modifications.toggle = "off")
				IniDelete, % "ini" vars.poe_version "\lootfilter.ini", % "modifications - profile " profile, % index

		vars.lootfilter.modifications_pending := [], vars.lootfilter.modifications_pending.0 := ""
		Lootfilter_Load("init_" settings.lootfilter.active_filter)
		Lootfilter_Dump()
		Clipboard := "/itemfilter FilterSpoon"
		WinActivate, % "ahk_id " vars.hwnd.poe_client
		WinWaitActive, % "ahk_id " vars.hwnd.poe_client,, 2
		If ErrorLevel
		{
			LLK_ToolTip(Lang_Trans("global_errorpaste"), 2,,,, "Red")
			Return
		}
		SendInput, {ENTER}
		Sleep 100
		SendInput, ^{a}^{v}{ENTER}
		vars.lootfilter.update_applied := 0
		;######################################################
		Case (check = "update_check"):
		Clipboard := "/itemfilter " settings.lootfilter.active_filter
		WinActivate, % "ahk_id " vars.hwnd.poe_client
		WinWaitActive, % "ahk_id " vars.hwnd.poe_client,, 2
		If ErrorLevel
		{
			LLK_ToolTip(Lang_Trans("global_errorpaste"), 2,,,, "Red")
			Return
		}
		SendInput, {ENTER}
		Sleep 100
		SendInput, ^{a}^{v}{ENTER}
		vars.lootfilter.update_pending := [vars.lootfilter.filters_list[settings.lootfilter.active_filter].1, A_TickCount]
		Return
		;######################################################
		Case (check = "search_ok" || cHWND = "search"):
		input := Trim(LLK_ControlGet(vars.hwnd.lootfilter.search_edit), " ,")
		If !Blank(input) && (input != vars.lootfilter.search[vars.lootfilter.search.0])
			vars.lootfilter.search.RemoveAt(vars.lootfilter.search.0 + 1, 9999), vars.lootfilter.search.Push(input), vars.lootfilter.search.0 += 1
		Else Return
		;######################################################
		Case (check = "search_reset") || (cHWND = "home"):
		new_search := ["", "", ""]
		ControlFocus,, % "ahk_id " vars.hwnd.lootfilter.search_edit
		;######################################################
		Case InStr(check, "searchhistory_") || InStr(cHWND, "searchhistory_"):
		control := (InStr(cHWND, "searchhistory_") ? SubStr(cHWND, InStr(cHWND, "_") + 1) : control)
		If (control = "minus" && vars.lootfilter.search.0 = 1) || (control = "plus" && vars.lootfilter.search.0 = Max(vars.lootfilter.search.Count() - 1, 1))
			Return
		vars.lootfilter.search.0 += (control = "minus" ? -1 : 1)
		;######################################################
		Case (check = "collapse_history"):
		vars.lootfilter.collapse_history := !vars.lootfilter.collapse_history
		;######################################################
		Case InStr(check, "economy_"):
		new_search := StrSplit(control, "|")
		;######################################################
		Case InStr(check, "browsesetting_"):
		If InStr("visuals,economy", control)
		{
			Settings_menu(control = "visuals" ? "filterspoon" : "general")
			Return
		}
		Else new_search := [control]
		;######################################################
		Case InStr(check, "modification_"):
		If (vars.system.click = 1) && control
		{
			data := (!InStr(control, "pending") ? vars.lootfilter.modifications["profile" profile] : vars.lootfilter.modifications_pending), control := StrReplace(control, "pending")
			new_search := [data[control].type, StrReplace(data[control].tier, "_", ".")]
		}
		Else If !LLK_Progress(vars.hwnd.lootfilter[check "_bar"], "RButton",,, 500)
			Return
		Else
		{
			If InStr(control, "pending")
			{
				Loop, Parse, control
					If IsNumber(A_LoopField)
						iMod .= A_LoopField
				vars.lootfilter.modifications_pending.RemoveAt(iMod + 1, 9999)
			}
			Else Loop, % vars.lootfilter.modifications["profile" profile].Length()
				If (A_Index > control)
					IniDelete, % "ini" vars.poe_version "\lootfilter.ini", % "modifications - profile " profile, % A_Index

			If !InStr(control, "pending")
				vars.lootfilter.modifications_pending.RemoveAt(1, 9999)
			skip_reapply := (control = vars.lootfilter.modifications["profile" profile].Length() ? 1 : 0)
			Lootfilter_Load("init_" settings.lootfilter.active_filter)

			If InStr(control, "pending") || skip_reapply
			{
				Loop, % Abs(vars.lootfilter.modifications_pending.MinIndex())
					If IsObject(object := vars.lootfilter.modifications_pending[-A_Index])
						Lootfilter_Modify(object)
				Loop, % vars.lootfilter.modifications_pending.Length()
					If IsObject(object := vars.lootfilter.modifications_pending[A_Index])
						Lootfilter_Modify(object)
			}
			Else
			{
				Lootfilter_Dump()
				Clipboard := "/itemfilter FilterSpoon"
				WinActivate, % "ahk_id " vars.hwnd.poe_client
				WinWaitActive, % "ahk_id " vars.hwnd.poe_client,, 2
				If ErrorLevel
				{
					error := "paste"
					vars.lootfilter.update_applied := 1
				}
				Else
				{
					SendInput, {ENTER}
					Sleep 100
					SendInput, ^{a}^{v}{ENTER}
				}
			}
		}
		;######################################################
		Case InStr(check, "searchtype_"):
		If (vars.system.click = 2)
			new_search := [Trim(control, "|")]
		Else collapsed_types[Trim(control, "|")] := !collapsed_types[Trim(control, "|")]
		;######################################################
		Case InStr(check, "searchtier_"):
		pTier := Trim(SubStr(control, 1, InStr(control, "_type") - 1), "|"), pType := Trim(SubStr(control, InStr(control, "_type") + 5), "|")
		If (vars.system.click = 2)
			new_search := [StrReplace(pType, "_", "."), StrReplace(pTier, "_", ".")]
		Else collapsed_tiers[pType "|" pTier] := !collapsed_tiers[pType "|" pTier]
		;######################################################
		Case InStr(check, "itemtext_"):
		new_search := StrSplit(Trim(control, "|"), "|", " ")
		If (vars.system.click = 2)
			new_search := ["", "", new_search.3]
		;######################################################
		Case (check = "uncollapse"):
		collapsed_tiers := {}, collapsed_types := {}
		;######################################################
		Case check:
		LLK_ToolTip("no action")
		Return
	}

	If new_search
	{
		parse := (new_search.1 ? "type: """ new_search.1 """" : "")
		parse .= (new_search.2 ? (new_search.1 ? ", " : "") "tier: """ new_search.2 """" : "")
		parse .= (new_search.3 ? (new_search.1 || new_search.2 ? ", " : "") """" new_search.3 """" : "")
		If (parse != vars.lootfilter.search[vars.lootfilter.search.0])
		{
			vars.lootfilter.search.RemoveAt(vars.lootfilter.search.0 + 1, 9999), vars.lootfilter.search.Push(parse), vars.lootfilter.search.0 += 1
			If new_search.1
				collapsed_types[new_search.1] := 0
			If new_search.2
				collapsed_tiers[new_search.1 "|" new_search.2] := 0
		}
		Else Return
	}

	If (fSize != settings.lootfilter.fSize)
	{
		LLK_FontDimensions((fSize := settings.lootfilter.fSize), height, width), settings.lootfilter.fWidth := width, settings.lootfilter.fHeight := height
		LLK_FontDimensions(fSize - 2, height, width), settings.lootfilter.fWidth2 := width, settings.lootfilter.fHeight2 := height
		LLK_FontDimensions(fSize - 4, height, width), settings.lootfilter.fWidth3 := width, settings.lootfilter.fHeight3 := height
		hItems := settings.lootfilter.fHeight2 * 1.3, hItems2 := settings.lootfilter.fHeight3 * 1.3
		LLK_PanelDimensions([Lang_Trans("global_search"), Lang_Trans("lootfilter_basefilter")], fSize, wLabels, hLabels,,, 0)
		LLK_PanelDimensions([Lang_Trans("global_sync"), Lang_Trans("global_apply"), Lang_Trans("global_cancel")], fSize, wSyncApply, hSyncApply)
		LLK_PanelDimensions([Lang_Trans("global_expand")], fSize - 2, wExpand, hExpand)
		LLK_PanelDimensions([Lang_Trans("global_show"), Lang_Trans("global_hide")], fSize - 2, wShowHide, hShowHide)
		If !vars.poe_version
			LLK_PanelDimensions([Lang_Trans("lootfilter_minquality"), Lang_Trans("lootfilter_minlevel")], fSize - 2, wQualityLevel, hQualityLevel)
		Else LLK_PanelDimensions([Lang_Trans("lootfilter_minskilllevel"), Lang_Trans("lootfilter_minspiritlevel"), Lang_Trans("lootfilter_minsupportlevel")], fSize - 2, wQualityLevel, hQualityLevel)
		LLK_PanelDimensions([Lang_Trans("lootfilter_mintier")], fSize - 2, wMapTier, hMapTier)
		LLK_PanelDimensions([Lang_Trans("global_high"), Lang_Trans("global_minimum")], fSize - 2, wStrands, hStrands)
		LLK_PanelDimensions([Lang_Trans("global_off")], fSize - 2, wOff, hOff)
		LLK_PanelDimensions([Lang_Trans("global_update"), Lang_Trans("global_apply")], fSize - 2, wApplyUpdate, hApplyUpdate)
	}

	toggle := !toggle, GUI := vars.lootfilter.GUI := "lootfilter_editor" toggle, margin := settings.lootfilter.fWidth//2
	Gui, %GUI%: New, % "-DPIScale +LastFound -Caption +AlwaysOnTop +ToolWindow +Border +E0x02000000 +E0x00080000 HWNDhwnd_editor", LLK-UI: lootfilter editor
	Gui, %GUI%: Font, % "s" settings.lootfilter.fSize " cWhite", % vars.system.font
	Gui, %GUI%: Margin, % margin, % margin
	Gui, %GUI%: Color, % (accent_color := settings.lootfilter.color_accent)

	hwnd_old := vars.hwnd.lootfilter.main, vars.hwnd.lootfilter := {"main": hwnd_editor}, hMax := 0
	Gui, %GUI%: Font, % "s" settings.lootfilter.fSize - 4
	Gui, %GUI%: Add, DDL, % "Hidden", % "bla"

	Gui, %GUI%: Font, % "s" settings.lootfilter.fSize
	Gui, %GUI%: Add, Text, % "Section xp yp" (settings.lootfilter.active_filter ? " w" wLabels : "") " hp 0x200 Right BackgroundTrans", % Lang_Trans("lootfilter_basefilter")

	If !vars.lootfilter.filters_list.Count()
		If (Lootfilter_Load("init") = 0)
		{
			LLK_Overlay(hwnd_old, "destroy"), vars.hwnd.lootfilter := ""
			Gui, %GUI%: Destroy
			MsgBox, 4,, % Lang_Trans("lootfilter_duplicatefiles") "`n" Lang_Trans("lootfilter_duplicatefiles", 2) "`n`n" Lang_Trans("lootfilter_duplicatefiles", 3)
			IfMsgBox, Yes
			{
				Run, % vars.system.config_folder "\OnlineFilters"
				Run, % "https://www.pathofexile.com/my-account/item-filters"
			}
			Return
		}

	For key, val in vars.lootfilter.filters_list
	{
		label := LLK_StringCase(key) " (" LLK_TimeSince(val.2, A_Now) ")"
		ddl .= (ddl ? "|" : "") . label . (key = settings.lootfilter.active_filter ? "||" : "")
	}
	wDDL := 40 * settings.lootfilter.fWidth, profile := settings.lootfilter.profile, wProfiles := Round(1.5 * settings.lootfilter.fWidth)
	show_apply := (vars.lootfilter.update_applied || vars.lootfilter.modifications_pending.Count() > 1)

	While !Mod(3 * wProfiles - 2, 2)
		wProfiles += 1
	Gui, %GUI%: Font, % "s" settings.lootfilter.fSize - 4
	Gui, %GUI%: Add, DDL, % "ys w" wDDL " HWNDhwnd gLootfilter_Editor" (show_apply ? " Disabled" : ""), % StrReplace(ddl, "|||", "||")
	vars.hwnd.lootfilter.filter_select := hwnd, vars.hwnd.help_tooltips["lootfilter_filter select"] := (vars.lootfilter.modifications_pending.Count() > 1 ? "" : hwnd)
	Gui, %GUI%: Font, % "s" settings.lootfilter.fSize - 2

	Gui, %GUI%: Add, Pic, % "ys x+0 hp-2 w-1 Border gLootfilter_Editor HWNDhwnd", % "HBitmap:*" vars.pics.global.reload
	vars.hwnd.lootfilter.list_reload := vars.hwnd.help_tooltips["lootfilter_list reload"] := hwnd

	If settings.lootfilter.active_filter
		Loop 3
		{
			Gui, %GUI%: Add, Text, % "ys x+" (A_Index = 1 ? margin : -1) " w" wProfiles " hp Center Border 0x200 HWNDhwnd" (show_apply ? " cGray" : " gLootfilter_Editor" (A_Index = profile ? " cLime" : "")), % A_Index
			vars.hwnd.lootfilter["profile_" A_Index] := vars.hwnd.help_tooltips["lootfilter_profiles" handle_profiles] := hwnd, handle_profiles .= "|"
		}
	Gui, %GUI%: Font, % "s" settings.lootfilter.fSize

	If Blank(active_filter := settings.lootfilter.active_filter)
	{
		cPos := LLK_ControlGetPos(hwnd), wMax := cPos.xMax
		Gosub, Label_Show
		Return
	}
	search := vars.lootfilter.search
	Gui, %GUI%: Add, Text, % "ys hp Border Center gLootfilter_Editor BackgroundTrans HWNDhwnd1 cWhite w" wSyncApply . (show_apply ? "" : " Hidden"), % Lang_Trans("global_apply")
	Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp HWNDhwnd2 Border Background" accent_color " c" accent_color . (show_apply ? "" : " Hidden"), 100
	vars.hwnd.lootfilter.filter_apply := hwnd1, vars.hwnd.lootfilter.filter_apply_bar := vars.hwnd.help_tooltips["lootfilter_filter apply " (vars.lootfilter.update_applied ? "update" : "modifications")] := hwnd2

	Gui, %GUI%: Add, Text, % "xp yp wp hp Border gLootfilter_Editor Center HWNDhwnd3 w" wSyncApply . (show_apply ? " Hidden" : ""), % Lang_Trans("global_sync")
	vars.hwnd.lootfilter.update_check := vars.hwnd.help_tooltips["lootfilter_update check"] := hwnd3

	cPos := LLK_ControlGetPos(hwnd3), wMax := cPos.xMax, diffs := [], wModbox := (wMax - margin - 1) // modbox_div, tier_view := item_view := 0
	If !(item_view := RegexMatch(search[vars.lootfilter.search.0], "i)type:."".*"",.tier:."".*"",.*""$"))
		tier_view := RegexMatch(search[vars.lootfilter.search.0], "i)type:."".*"",.tier:."".*""$")

	offset := wMax - margin - 1 - (wModbox * modbox_div - (modbox_div - 1)), modboxes := modbox_div, any_view := item_view + tier_view
	While (offset >= wModbox - 1)
		offset -= (wModbox - 1), modboxes += 1

	Gui, %GUI%: Add, Text, % "Section xs hp Right BackgroundTrans w" wLabels, % Lang_Trans("global_search")
	Gui, %GUI%: Font, % "s" settings.lootfilter.fSize - 4
	clip_mode := IsObject(search[vars.lootfilter.search.0]), history := (vars.lootfilter.search.Count() - 1 > 1)
	Gui, %GUI%: Add, Edit, % "ys w" wDDL " cBlack HWNDhwnd hp" (clip_mode ? " Disabled" : ""), % (clip_mode ? Lang_Trans("lootfilter_ingameitem") : search[Max(1, vars.lootfilter.search.0)])
	vars.hwnd.lootfilter.search_edit := vars.hwnd.help_tooltips["lootfilter_search field"] := hwnd
	Gui, %GUI%: Font, % "s" settings.lootfilter.fSize
	Gui, %GUI%: Add, Pic, % "ys x+0 hp-2 w-1 Border gLootfilter_Editor HWNDhwnd1", % "HBitmap:*" vars.pics.global.home
	Gui, %GUI%: Add, Button, % "xp yp wp hp HWNDhwnd2 gLootfilter_Editor Hidden Default" (clip_mode ? " Disabled" : ""), a
	vars.hwnd.lootfilter.search_reset := vars.hwnd.help_tooltips["lootfilter_home button"] := hwnd1
	vars.hwnd.lootfilter.search_ok := hwnd2

	Gui, %GUI%: Add, Text, % "ys w" Ceil((3 * wProfiles - 2)/2) " hp 0x200 Border Center HWNDhwnd" (history ? " gLootfilter_Editor" : "") . (search.0 < 2 || !history ? " cGray" : ""), % "<"
	vars.hwnd.lootfilter.searchhistory_minus := vars.hwnd.help_tooltips["lootfilter_search history"] := hwnd
	Gui, %GUI%: Add, Text, % "ys x+-1 w" Ceil((3 * wProfiles - 2)/2) " hp 0x200 Border Center HWNDhwnd1" (history ? " gLootfilter_Editor" : "") . (search.0 = search.Count() - 1 || !history ? " cGray" : ""), % ">"
	vars.hwnd.lootfilter.searchhistory_plus := vars.hwnd.help_tooltips["lootfilter_search history|"] := hwnd1

	If (vars.lootfilter.modifications_pending.Count() > 1)
	{
		Gui, %GUI%: Add, Text, % "ys w" wSyncApply " hp Border Center gLootfilter_Editor HWNDhwnd", % Lang_Trans("global_cancel")
		vars.hwnd.lootfilter.cancel := vars.hwnd.help_tooltips["lootfilter_cancel"] := hwnd
	}

	If (modifications := vars.lootfilter.modifications["profile" profile].Count() - 1 + vars.lootfilter.modifications_pending.Count() - 1)
	{
		Gui, %GUI%: Font, % "s" settings.lootfilter.fSize - (vars.lootfilter.collapse_history ? 4 : 2)
		Gui, %GUI%: Add, Text, % "Section xs Center Border gLootfilter_Editor HWNDhwnd w" wMax - margin - 1, % Lang_Trans("lootfilter_modhistory")
		vars.hwnd.lootfilter.collapse_history := vars.hwnd.help_tooltips["lootfilter_modhistory"] := hwnd, count := 0

		If !vars.lootfilter.collapse_history
		{
			dummy_array := vars.lootfilter.modifications["profile" profile].Clone(), dummy_array0 := []
			For index, val in vars.lootfilter.modifications_pending
				If (index < 0)
					dummy_array[index] := val.Clone()

			For outer in [1, 2]
				For index, object in (outer = 1 ? dummy_array : vars.lootfilter.modifications_pending)
					If (outer = 1 || index > 0) && (IsObject(object) || !index)
						Loop 2
						{
							background := (outer = 2 && object.warning ? "FF0000" : (RegexMatch(object.action, "i)global\s|economy") ? "Fuchsia" : "Black"))
							If (index < 0) && IsObject(vars.lootfilter.modifications_pending[index])
								color := (vars.lootfilter.modifications_pending[index].warning ? "FF8000" : "Yellow")
							Else color := (outer = 1 && object.warning ? "FF8000" : (outer = 1 ? (!index ? "White" : "Green") : "Yellow"))
							style := (A_Index = 2 ? "Section xs y+-1" : (!count ? "Section xs x" margin + (modifications + 1 > modboxes ? Floor(offset/2) : 0) : "ys x+-1")), count += 1
							Gui, %GUI%: Add, Text, % style " Border BackgroundTrans" (index < 0 ? "" : " gLootfilter_Editor") " HWNDhwnd w" wModbox " h" wModbox
							Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border Background" background " Range0-500 Vertical HWNDhwnd1 c" color, 500
							If (LLK_ControlGetPos(hwnd1).xMax <= wMax)
							{
								index := (outer = 2 ? "pending" : "") . index
								vars.hwnd.lootfilter["modification_" index] := hwnd, vars.hwnd.lootfilter["modification_" index "_bar"] := vars.hwnd.help_tooltips["lootfilter_dummy" index] := hwnd1
								Break
							}
							Else
								For index, val in ["", 1]
									GuiControl, +Hidden, % hwnd%val%
						}
		}
		Gui, %GUI%: Font, % "s" settings.lootfilter.fSize
	}

	cPos := LLK_ControlGetPos(hwnd), tiers := {}, background_color := settings.lootfilter.color_background
	If !search[vars.lootfilter.search.0]
	{
		Gui, %GUI%: Font, % "s" settings.lootfilter.fSize - 2
		Gui, %GUI%: Add, Text, % "Section xs Center BackgroundTrans Border HWNDhwnd w" wMax - margin - 1, % Lang_Trans("lootfilter_globalsetting", 2)
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border BackgroundBlack c" background_color, 100
		wSettings := (wMax - 3*margin)//3, league := settings.general.league.1 " " settings.general.league[(vars.poe_version ? 3 : 4)]
		;######################################################
		Gui, %GUI%: Add, Text, % "Section xs Border Center HWNDhwnd gLootfilter_Editor w" wSettings * 2 + margin, % Lang_Trans("lootfilter_economy", 2) " " league
		vars.hwnd.lootfilter["browsesetting_economy"] := vars.hwnd.help_tooltips["lootfilter_global setting economy"] := hwnd
		labels := [Lang_Trans("lootfilter_currency"), Lang_Trans("lootfilter_divcards"), Lang_Trans("lootfilter_essences"), Lang_Trans("lootfilter_socketables")]
		For index, val in [["currency", "currency"], ["divcards", "divination"], ["essences", "currency > essence"], ["socketables", "sockets > general"]]
		{
			If vars.poe_version && (index = 2) || !vars.poe_version && (index = 4)
				Continue

			If IsObject(vars.lootfilter.modifications_pending[-101 - (index - 1)])
				oCurrent := vars.lootfilter.modifications_pending[-101 - (index - 1)]
			Else oCurrent := vars.lootfilter.modifications["profile" profile][-101 - (index - 1)]

			available := vars.lootfilter.active_filter.structure.HasKey(val.2)
			wLabel := wSettings * 2 + margin - settings.lootfilter.fWidth2 * 4 - wApplyUpdate
			style := (!available ? " cFF8000 BackgroundTrans" : (oCurrent.action && !oCurrent.modifications.toggle ? " cLime gLootfilter_Editor" : " BackgroundTrans" (oCurrent.modifications.toggle ? " cYellow" : "")))
			Gui, %GUI%: Add, Text, % "xs y+-1 Border HWNDhwnd w" wLabel . style, % " " labels[index]
			vars.hwnd.lootfilter["economy_" val.2 "|exui_hide"] := hwnd
			If Blank(oCurrent.action) || oCurrent.modifications.toggle || !available
				Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border BackgroundBlack c" background_color, 100
			Else vars.hwnd.help_tooltips["lootfilter_section browse" handle_tooltip] := hwnd

			Gui, %GUI%: Font, % "s" settings.lootfilter.fSize - 4
			Gui, %GUI%: Add, Edit, % "ys yp x+0 hp HWNDhwnd cBlack Center Limit5 w" settings.lootfilter.fWidth2 * 4, % (oCurrent.modifications.Count() ? StrSplit(oCurrent.action, "|").2 : "")
			vars.hwnd.lootfilter["cutoff_" val.1] := vars.hwnd.help_tooltips["lootfilter_economy cut-offs" vars.poe_version . handle_tooltip] := hwnd
			Gui, %GUI%: Font, % "s" settings.lootfilter.fSize - 2
			Gui, %GUI%: Add, Text, % "ys yp Center Border x+0 gLootfilter_Customize HWNDhwnd w" wApplyUpdate, % Lang_Trans("global_" ((oCurrent.modifications.Count() && !oCurrent.modifications.toggle ? "update" : "apply")))
			vars.hwnd.lootfilter["globalsetting_economy" index "|" val.1] := hwnd, handle_tooltip .= "|"
		}
		cPos := LLK_ControlGetPos(hwnd), hMax := Max(hMax, cPos.yMax)
		;######################################################
		Gui, %GUI%: Add, Text, % "Section ys x" wMax - wSettings - 1 " Border Center HWNDhwnd gLootfilter_Editor w" wSettings . (collapsed ? " BackgroundTrans" : ""), % Lang_Trans("lootfilter_visuals")
		vars.hwnd.lootfilter["browsesetting_visuals"] := vars.hwnd.help_tooltips["lootfilter_global setting visuals"] := hwnd

		If IsObject(vars.lootfilter.modifications_pending[-1])
			visuals := vars.lootfilter.modifications_pending[-1]
		Else visuals := vars.lootfilter.modifications["profile" profile][-1]

		For index, val in ["size", "opacity"]
		{
			value := (visuals.modifications[val] ? visuals.modifications[val] : 0), label := StrReplace(Lang_Trans("global_" val), Lang_Trans("global_colon"))
			Gui, %GUI%: Add, Text, % "xs y+-1 Border BackgroundTrans w" wSettings - 3 * settings.lootfilter.fHeight2 - wOff + 4 . (visuals.modifications[val] ? " cLime" : ""), % " " label
			Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border BackgroundBlack c" background_color, 100
			Gui, %GUI%: Add, Text, % "ys yp hp x+-1 w" wOff " Border Center gLootfilter_Customize HWNDhwnd" (!visuals.modifications[val] ? " cLime" : ""), % Lang_Trans("global_off")
			vars.hwnd.lootfilter["globalsetting_visual|" val "|off"] := vars.hwnd.help_tooltips["lootfilter_global setting visuals toggles" handle_visuals] := hwnd, handle_visuals .= "|"
			For key, scale in {"i": "minimum", "ii": "medium", "iii": "maximum"}
			{
				Gui, %GUI%: Add, Text, % "yp hp x+-1 w" settings.lootfilter.fHeight2 " Border Center HWNDhwnd gLootfilter_Customize" (value = settings.lootfilter[val "_" scale] ? " cLime" : ""), % key
				vars.hwnd.lootfilter["globalsetting_visual|" val "|" scale] := vars.hwnd.help_tooltips["lootfilter_global setting visuals toggles" handle_visuals] := hwnd, handle_visuals .= "|"
			}
		}
		cPos := LLK_ControlGetPos(hwnd), hMax := Max(hMax, cPos.yMax), style := "Section xs x" margin " y" hMax + margin - 1
		;######################################################
		If !vars.poe_version
		{
			available := vars.lootfilter.active_filter.structure.HasKey("maps")
			Gui, %GUI%: Add, Text, % style " Border Center HWNDhwnd w" wSettings . (available ? " gLootfilter_Editor" : " cFF8000"), % Lang_Trans("lootfilter_maps")
			vars.hwnd.lootfilter["browsesetting_maps"] := vars.hwnd.help_tooltips["lootfilter_global setting " (!available ? "unavailable" : "maps")] := hwnd

			If IsObject(vars.lootfilter.modifications_pending[-21])
				maps := vars.lootfilter.modifications_pending[-21]
			Else maps := vars.lootfilter.modifications["profile" profile][-21]

			value := (maps.modifications.tier ? maps.modifications.tier : 0)
			Gui, %GUI%: Add, Text, % "xs y+-1 Border BackgroundTrans w" wMapTier . (maps.modifications.tier ? " cLime" : ""), % " " Lang_Trans("lootfilter_mintier")
			Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border BackgroundBlack c" background_color, 100
			Gui, %GUI%: Add, Slider, % "yp x+-1 hp Border gLootfilter_Customize Center Range0-17 NoTicks ToolTip HWNDhwnd w" wSettings - wMapTier + 1, % value
			vars.hwnd.lootfilter["globalsetting_map|tier"] := vars.hwnd.help_tooltips["lootfilter_global setting maps toggles"] := hwnd
			style := "Section ys x" wSettings + 2*margin 
		}
		;######################################################
		available := vars.lootfilter.active_filter.structure.HasKey(!vars.poe_version ? "gems > generic" : "gems > uncut")
		Gui, %GUI%: Add, Text, % style " Border Center HWNDhwnd w" wSettings . (available ? " gLootfilter_Editor" : " cFF8000"), % Lang_Trans("lootfilter_gems", vars.poe_version)
		vars.hwnd.lootfilter["browsesetting_" (!vars.poe_version ? "gems > generic" : "gems > uncut")] := vars.hwnd.help_tooltips["lootfilter_global setting " (!available ? "unavailable||" : "gems" vars.poe_version)] := hwnd

		If IsObject(vars.lootfilter.modifications_pending[-11])
			gems := vars.lootfilter.modifications_pending[-11]
		Else gems := vars.lootfilter.modifications["profile" profile][-11]

		For index, val in (!vars.poe_version ? ["quality", "level"] : ["skilllevel", "spiritlevel", "supportlevel"])
		{
			value := (gems.modifications[val] ? gems.modifications[val] : 0)
			Gui, %GUI%: Add, Text, % "xs y+-1 Border BackgroundTrans w" wQualityLevel . (gems.modifications[val] ? " cLime" : ""), % " " Lang_Trans("lootfilter_min" val)
			Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border BackgroundBlack c" background_color, 100
			Gui, %GUI%: Add, Slider, % "yp x+-1 hp Border gLootfilter_Customize Center Range" (!vars.poe_version ? "0-2" (index = 1 ? 4 : 2) : (index < 3 ? "0-20" : "0-5")) " NoTicks ToolTip HWNDhwnd w" wSettings - wQualityLevel + 1, % value
			vars.hwnd.lootfilter["globalsetting_gem|" val] := vars.hwnd.help_tooltips["lootfilter_global setting gems toggles" vars.poe_version . (index = 2 ? "|" : (index = 3 ? "||" : ""))] := hwnd
			cPos := LLK_ControlGetPos(hwnd), hMax := Max(hMax, cPos.yMax)
		}
		;######################################################
		If !vars.poe_version
		{
			available := vars.lootfilter.active_filter.structure.HasKey("gear > memorystrand")
			Gui, %GUI%: Add, Text, % "Section ys x" wMax - wSettings - 1 " Border Center HWNDhwnd gLootfilter_Editor w" wSettings . (available ? " gLootfilter_Editor" : " cFF8000"), % Lang_Trans("global_memorystrands")
			vars.hwnd.lootfilter["browsesetting_gear > memorystrand"] := vars.hwnd.help_tooltips["lootfilter_global setting " (!available ? "unavailable|" : "strands")] := hwnd

			If IsObject(vars.lootfilter.modifications_pending[-31])
				strands := vars.lootfilter.modifications_pending[-31]
			Else strands := vars.lootfilter.modifications["profile" profile][-31]

			For index, val in ["strands high", "strands"]
			{
				value := (strands.modifications[val] ? strands.modifications[val] : 0), label := Lang_Trans("global_" (index = 1 ? "high" : "minimum"))
				Gui, %GUI%: Add, Text, % "xs y+-1 Border BackgroundTrans w" wStrands . (strands.modifications[val] ? " cLime" : ""), % " " label
				Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border BackgroundBlack c" background_color, 100
				Gui, %GUI%: Add, Slider, % "yp x+-1 hp Border gLootfilter_Customize Center Range0-101 NoTicks ToolTip HWNDhwnd w" wSettings - wStrands + 1, % value
				vars.hwnd.lootfilter["globalsetting_strand|" val] := vars.hwnd.help_tooltips["lootfilter_global setting strands toggles" (index = 2 ? "|" : "")] := hwnd
			}
			cPos := LLK_ControlGetPos(hwnd), hMax := Max(hMax, cPos.yMax)
		}
		Gosub, Label_Show
		Return
	}
	Else
		For outerouter in [1, 2]
		{
			If (outerouter = 2)
				LLK_PanelDimensions(tiers, settings.lootfilter.fSize - 4, wTiers, hTiers,,,,, 1)
			For iChunk, vChunk in vars.lootfilter.active_filter.final
			{
				style := yFirst := ""
				If !IsObject(vChunk)
					Continue
				Else
					If LLK_HasVal(vChunk.lines, "Continue", 1, 1,, 1) || (SubStr(vChunk.lines.1, 1, 1) = "#")
						Continue
					Else style := Lootfilter_Match(vChunk), type := vChunk.type, tier := vChunk.tier

				If !style.matches.Count() || RegexMatch(vChunk.tier, "i)^rest") && !LLK_HasKey(vChunk.lines, "basetype ==", 1,,, 1)
					Continue
				vars.lootfilter.last_style := style.Clone(), last_style := vars.lootfilter.last_style
				vars.lootfilter.last_type := type, vars.lootfilter.last_tier := tier

				If (outerouter = 1)
				{
					tiers[tier] := 1
					If clip_mode && !style.multimatches
						Break
					Continue
				}

				If (type != prev_type)
				{
					Gui, %GUI%: Font, % "s" settings.lootfilter.fSize - (collapsed_types[type] ? 4 : 2)
					If !prev_type && !any_view
					{
						Gui, %GUI%: Add, Text, % "Section xs x" margin " Border Center BackgroundTrans gLootfilter_Editor HWNDhwnd Hidden w" Max(wTiers, wExpand), % Lang_Trans("global_expand")
						Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border BackgroundAqua HWNDhwnd1 Hidden c" accent_color, 100
						vars.hwnd.lootfilter.uncollapse := hwnd, vars.hwnd.lootfilter.uncollapse_bar := vars.hwnd.help_tooltips["lootfilter_expand"] := hwnd1
						Gui, %GUI%: Add, Text, % "Section xp yp Center Border gLootfilter_Editor HWNDhwnd_typeheader w" wMax - margin - 1, % type
					}
					Else Gui, %GUI%: Add, Text, % "Section xs x" margin " Center Border gLootfilter_Editor HWNDhwnd_typeheader w" wMax - margin - 1, % type
					Gui, %GUI%: Font, % "s" settings.lootfilter.fSize
					searchtype_handle := ""
					While vars.hwnd.lootfilter["searchtype_" type . searchtype_handle]
						searchtype_handle .= "|"
					vars.hwnd.lootfilter["searchtype_" type . searchtype_handle] := hwnd_typeheader
					vars.hwnd.lootfilter["typeheader" typeheader_handle] := vars.hwnd.help_tooltips["lootfilter_types" typeheader_handle] := hwnd_typeheader, typeheader_handle .= "|"
					cPos := LLK_ControlGetPos(hwnd_typeheader)
				}
				If collapsed_types[type]
				{
					prev_type := type
					GuiControl, -Hidden, % vars.hwnd.lootfilter.uncollapse
					GuiControl, -Hidden, % vars.hwnd.lootfilter.uncollapse_bar
					Continue
				}

				If style.matches.Count()
				{
					Gui, %GUI%: Font, % "s" settings.lootfilter.fSize - 4
					Gui, %GUI%: Add, Text, % "Section xs x" margin " y+" margin+1 " w2 h10 HWNDhwnd_tierbrace" (collapsed_tiers[type "|" tier] ? " Hidden" : "")
					Gui, %GUI%: Add, Text, % "Section xp yp-1 Border 0x200 HWNDhwnd_tier gLootfilter_Editor w" wTiers . (collapsed_tiers[type "|" tier] ? " BackgroundTrans" : ""), % " " vChunk.tier
					searchtier_handle := "", last_chunk := vars.lootfilter.last_chunk := iChunk
					While vars.hwnd.lootfilter["searchtier_" tier "_type" type . searchtier_handle]
						searchtier_handle .= "|"
					vars.hwnd.lootfilter["searchtier_" tier "_type" type . searchtier_handle] := vars.hwnd.help_tooltips["lootfilter_tiers" handle_tiers] := hwnd_tier, handle_tiers .= "|"

					If collapsed_tiers[type "|" tier]
					{
						prev_type := type, cPos := LLK_ControlGetPos(hwnd_tier)
						GuiControl, -Hidden, % vars.hwnd.lootfilter.uncollapse
						GuiControl, -Hidden, % vars.hwnd.lootfilter.uncollapse_bar
						Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border BackgroundAqua HWNDhwnd_bar c" accent_color, 100
						vars.hwnd.help_tooltips["lootfilter_tiers" StrReplace(handle_tiers, "|",,, 1)] := hwnd_bar
						If clip_mode && !style.multimatches
							Break 2
						Continue
					}
					If !any_view
					{
						Gui, %GUI%: Add, Text, % "ys Border HWNDhwnd_show gLootfilter_Customize c" ((show := RegexMatch(vChunk.lines.1, "i)^.{0,2}show")) ? "Lime" : "Gray"), % " " Lang_Trans("global_show") " "
						Gui, %GUI%: Add, Text, % "ys x+-1 Border HWNDhwnd_hide gLootfilter_Customize c" (!show ? "Lime" : "Gray"), % " " Lang_Trans("global_hide") " "
						vars.hwnd.lootfilter["toggle_Show|" type "|" tier] := vars.hwnd.help_tooltips["lootfilter_rule hideshow" handle_showhide] := hwnd_show
						vars.hwnd.lootfilter["toggle_Hide|" type "|" tier] := vars.hwnd.help_tooltips["lootfilter_rule hideshow" handle_showhide "|"] := hwnd_hide, handle_showhide .= "||"

						tags := [], campaign := 0
						For iLine, oLine in vChunk.lines
							For kLine, vLine in oLine
								If InStr(kLine, "memorystrands")
									tags.Push(" " Lang_Trans("global_memorystrands", 2) " >= " vLine " ")
								Else If !vars.poe_version && RegexMatch(Trim(kLine, " `t") " " vLine, "i)arealevel\s(1|<=.[1-6]\d{0,1}|>= 2)")
								|| vars.poe_version && RegexMatch(Trim(kLine, " `t") " " vLine, "i)arealevel\s(1|<=.([1-9]|[1-5]\d|6[0-4])|>= 2)$")
									campaign := 1
								Else If RegexMatch(kLine, "i)arealevel|gemlevel|quality|transfiguredgem")
									tags.Push(" " LLK_StringCase(Trim(LLK_StringReplace(kLine, [["gemlevel", "level"], ["arealevel", "area"]]), " `t") (vLine != "true" ? " " vLine : "")) " ")
						If campaign
						{
							Loop, % tags.Count()
								If campaign && InStr(tags[tags.Count() - (A_Index - 1)], "arealevel")
									tags.RemoveAt(tags.Count() - (A_Index - 1))
							tags.Push(" " Lang_Trans("global_campaign") " ")
						}

						For index, val in tags
						{
							Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans", % val
							Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border BackgroundCCCC00 c" background_color, 100
						}
					}

					If vChunk.global
					{
						Gui, %GUI%: Add, Text, % "ys Border BackgroundTrans", % " " Lang_Trans("global_global") " "
						Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border BackgroundFuchsia c" background_color, 100
					}
					Gui, %GUI%: Font, % "s" settings.lootfilter.fSize - 2
				}

				If RegexMatch(vChunk.lines.1, "i)^.{0,2}hide")
					Gui, %GUI%: Font, strike

				If style.basetype
				{
					For index, basetype in StrSplit(StrReplace(style.basetype, """ """, """|"""), "|", " """)
					{
						If (index = 1)
							style.basetype := {}
						style.basetype[basetype] := 1
					}
					For item in style.matches
						style.basetype.Delete(StrReplace(item, """"))
				}

				For outer_tier, tag in (!style.meta_search && !item_view && style.basetype.Count() ? ["", 2] : [""])
				{
					If (A_Index = 2)
					{
						Gui, %GUI%: Font, % "s" settings.lootfilter.fSize - 4
						Gui, %GUI%: Add, Text, % "xs x" margin + 2 " h2 w" 10*margin
					}

					For item in (outer_tier = 1 ? style.matches : style.basetype)
					{
						outer := A_Index, vars.lootfilter.last_item := StrReplace(item, """")
						Loop 2
						{
							label := (style.stacksize ? style.stacksize "x " : "") . Trim(LLK_StringReplace(item, [[" support", " Supp."], ["awakened ", "Awake. "], [" essence of ", " | "]]), " """) . (style.maptier && !clip_mode ? " (Tier " style.maptier ")" : "")
							label := StrReplace(label, " support", " Supp")
							Gui, %GUI%: Add, Text, % (outer = 1 ? (outer_tier = 2 ? "Section xs" : "Section xs x" 2*margin + 2) : (A_Index = 2 ? "Section xs" : "ys")) " BackgroundTrans gLootfilter_Editor HWNDhwnd1 0x200 h" hItems%tag% " c" style.settextcolor, % " " label " "
							Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp HWNDhwnd2 Background" style.setbordercolor " c" style.setbackgroundcolor, 100
							cPos := LLK_ControlGetPos(hwnd1), yFirst := (outer + A_Index = 2 ? cPos.y - margin - 1 : yFirst)
							If (cPos.xMax <= wMax)
								Break
							Else
								Loop 2
								{
									GuiControl, +Hidden, % hwnd%A_Index%
									If break && (A_Index = 2)
										Break 3
								}
						}
						If (cPos.yMax >= vars.monitor.h * 0.89) || tier_view && (cPos.yMax >= vars.monitor.h * 0.84)
							break := 1
						vars.hwnd.lootfilter["itemtext_" type "|" tier "|" Trim(item, " """) . handle_items] := hwnd1, handle_items .= "|"
					}
				}
				Gui, %GUI%: Font, % "norm s" settings.lootfilter.fSize - 2
				prev_type := type

				Gui, %GUI%: Add, Text, % "Section xs x" margin " w" 10*margin " h2 HWNDhwnd"
				cPos := LLK_ControlGetPos(hwnd)
				If style.matches.Count()
					GuiControl, movedraw, % hwnd_tierbrace, % "h" cPos.y - LLK_ControlGetPos(hwnd_tier).y - 1

				If break || clip_mode && !style.multimatches
					break
			}
		}

	If break
	{
		Gui, %GUI%: Font, % "bold s" settings.lootfilter.fSize - 4
		Gui, %GUI%: Add, Text, % "Section xs x" margin " Border cRed Center BackgroundTrans HWNDhwnd w" wMax - margin - 1, % Lang_Trans("global_match", 3)
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border BackgroundRed cWhite", 100
		cPos := LLK_ControlGetPos(hwnd)
		Gui, %GUI%: Font, % "norm s" settings.lootfilter.fSize
	}

	If typeheader_handle && (tier_view || item_view && LLK_HasKey(vars.lootfilter.last_style, "basetype", 1))
	{
		Gui, %GUI%: Font, % "s" settings.lootfilter.fSize - 2
		Gui, %GUI%: Add, Text, % "Section xs x" margin " Border BackgroundTrans Center HWNDhwnd w" wMax - margin - 1, % Lang_Trans("lootfilter_selections", (tier_view ? 1 : 2))
		Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border Background" accent_color " c" background_color, 100

		If tier_view
		{
			show := RegExMatch(vars.lootfilter.active_filter.final[last_chunk].lines.1, "i)^.{0,2}show")
			Gui, %GUI%: Add, Text, % "Section HWNDhwnd gLootfilter_Customize xs x" margin " Center Border w" wShowHide " c" (show ? "Lime" : "Gray"), % Lang_Trans("global_show")
			Gui, %GUI%: Add, Text, % "ys x+-1 HWNDhwnd1 gLootfilter_Customize Border Center c" (show ? "Gray" : "Lime"), % " " Lang_Trans("global_hide") " "
			vars.hwnd.lootfilter["toggle_Show|" vars.lootfilter.last_type "|" vars.lootfilter.last_tier] := hwnd
			vars.hwnd.lootfilter["toggle_Hide|" vars.lootfilter.last_type "|" vars.lootfilter.last_tier] := hwnd1

			Gui, %GUI%: Add, Text, % "ys hp Border BackgroundTrans", % " " StrReplace(Lang_Trans("global_color", 2), Lang_Trans("global_colon")) " "
			Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border Background" accent_color " c" background_color, 100
			For index, val in ["Text", "Border", "Background"]
			{
				Gui, %GUI%: Add, Text, % "ys hp x+-1 Border BackgroundTrans HWNDhwnd gLootfilter_Customize w" Floor(settings.lootfilter.fHeight2 * 0.65)
				Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd1 Background" accent_color " c" last_style["set" val "color"], 100
				vars.hwnd.lootfilter["customize_" val] := hwnd, vars.hwnd.lootfilter["customize_" val "_bar"] := vars.hwnd.help_tooltips["lootfilter_color " val] := hwnd1
			}

			For iLine, vLine in vars.lootfilter.active_filter.final[last_chunk].lines
				For key, val in vLine
					If InStr(key, "backgroundcolor")
						opacity := StrSplit(val, " ")
					Else If InStr(key, "fontsize")
						size := val
			opacity := (Blank(opacity.4) ? 255 : opacity.4), size := (!size ? 32 : size), handle := ""

			For index, type in ["size", "opacity"]
			{
				Gui, %GUI%: Add, Text, % "ys hp Border BackgroundTrans", % " " StrReplace(Lang_Trans("global_" type), Lang_Trans("global_colon")) " "
				Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border Background" accent_color " c" background_color, 100
				For key, val in {"i": "minimum", "ii": "medium", "iii": "maximum"}
				{
					Gui, %GUI%: Add, Text, % "ys hp x+-1 Border Center HWNDhwnd gLootfilter_Customize w" settings.lootfilter.fHeight2 . (%type% = settings.lootfilter[type "_" val] ? " cLime" : ""), % key
					vars.hwnd.lootfilter["customize_" type "|" val] := vars.hwnd.help_tooltips["lootfilter_" type . handle] := hwnd, handle .= "|"
				}
			}

			If last_style.memorystrands
			{
				Gui, %GUI%: Add, Text, % "ys hp Border BackgroundTrans HWNDhwnd", % " " Lang_Trans("global_memorystrands", 2) " "
				Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border Background" accent_color " c" background_color, 100
				;Gui, %GUI%: Add, Text, % "ys x+-1 hp Border Center BackgroundTrans HWNDhwnd w" settings.lootfilter.fWidth2 * 3, % last_style.memorystrands
				;Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border Background" accent_color " c" background_color, 100
				Gui, %GUI%: Add, Slider, % "ys x+-1 hp Border Range1-100 Center NoTicks Tooltip HWNDhwnd1 BackgroundTrans gLootfilter_Customize w" wMax - LLK_ControlGetPos(hwnd).xMax + 1, % last_style.memorystrands
				vars.hwnd.lootfilter.customize_MemoryStrands_text := hwnd, vars.hwnd.lootfilter.customize_MemoryStrands := hwnd1
			}

			For iLine, oLine in vars.lootfilter.active_filter.final[last_chunk].lines
				For kLine, vLine in oLine
					If RegexMatch(kLine, "i)arealevel|gemlevel|transfiguredgem|rarity|itemlevel")
						Loop 2
						{
							If !hwnd_condition
								Gui, %GUI%: Add, Progress, % "Disabled Section xs x" 5*margin " h3 w" wMax - 9*margin - 1 " Background" accent_color " c606060", 100
							kLine .= (InStr(kLine, "rarity") ? Lang_Trans("global_colon") : ""), kLine := (InStr(kLine, "itemlevel") ? StrReplace(kLine, "itemlevel", "ilvl") : kLine)
							vLine := (InStr(kLine, "rarity") ? StrReplace(vLine, " ", "/") : vLine)
							Gui, %GUI%: Add, Text, % (!hwnd_condition || A_Index = 2 ? "Section xs x" margin : "ys") " Border BackgroundTrans HWNDhwnd", % " " LLK_StringCase(Trim(kLine, " `t") (vLine != "true" ? " " vLine : "")) " "
							Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd_condition BackgroundCCCC00 c" background_color, 100
							If (LLK_ControlGetPos(hwnd).xMax <= wMax)
								Break
							Else
							{
								GuiControl, +Hidden, % hwnd
								GuiControl, +Hidden, % hwnd_condition
							}
						}

		}
		Else If item_view
		{
			Gui, %GUI%: Add, Text, % "Section xs x" margin " 0x200 BackgroundTrans HWNDhwnd", % Lang_Trans("lootfilter_movetier")
			style := vars.lootfilter.last_style.Clone(), style_defaults := {"setbackgroundcolor": "000000", "setbordercolor": "000000", "settextcolor": "BEB287"}, count := 0
			oLast_chunk := vars.lootfilter.active_filter.final[last_chunk], strand_check := 0

			For iChunk, vChunk in vars.lootfilter.active_filter.final
				If (vChunk.type = vars.lootfilter.last_type) && !RegExMatch(vChunk.lines.1, "i)^.{0,2}#") && !LLK_HasVal(vChunk.lines, "Continue", 1, 1) && LLK_HasKey(vChunk.lines, "basetype ==", 1,,, 1)
				{
					For key, val in style_defaults
						style[key] := val

					For outer in [1, 2]
						For iLine, oLine in (outer = 1 ? oLast_chunk.lines : vChunk.lines)
							For kLine, vLine in oLine
								If !RegExMatch(kLine, "i)^.{0,2}(set|play|minimap|basetype|disable)") && (!(iMatch := LLK_HasKey((outer = 2 ? oLast_chunk.lines : vChunk.lines), kLine,,,, 1))
								|| (outer = 2 && oLast_chunk.lines[iMatch][kLine] != vLine || outer = 1 && vChunk.lines[iMatch][kLine] != vLine))
									Continue 4

					For iLine, oLine in vChunk.lines
						For kLine, vLine in oLine
							If RegExMatch(kLine, "i)^.{0,2}set.*color")
								style[Trim(kLine, " `t")] := RGB_Convert(vLine)
							Else If InStr(kLine, "memorystrands")
								strand_check := 1

					If (hidden := RegExMatch(vChunk.lines.1, "i)^.{0,2}hide"))
					{
						Gui, %GUI%: Font, strike
						hide_check := 1
					}
					Loop 2
					{
						label := (style.stacksize ? style.stacksize "x " : "") . Trim(LLK_StringReplace(vars.lootfilter.last_item, [[" support", " Supp."], ["Awakened ", "Awake. "]]), " """)
						label .= (style.maptier && !clip_mode ? " (Tier " style.maptier ")" : "")
						Gui, %GUI%: Add, Text, % (A_Index = 2 || !count ? "Section xs x" margin . (count ? " y" cPos.yMax + margin - 1 : "") : "ys") " BackgroundTrans gLootfilter_Customize HWNDhwnd 0x200 h" hItems " c" style.settextcolor, % " " label " "
						Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp HWNDhwnd1 Background" style.setbordercolor " c" style.setbackgroundcolor, 100
						cPos := LLK_ControlGetPos(hwnd)
						If (cPos.xMax <= wMax)
							Break
						Else
							For index, val in ["", 1]
								GuiControl, +Hidden, % hwnd%val%
					}
					If (vChunk.tier = vars.lootfilter.last_tier)
						Gui, %GUI%: Add, Progress, % "Disabled xp yp-2 wp hp+4 BackgroundWhite cBlack", 100
					Gui, %GUI%: Font, norm
					vars.hwnd.lootfilter["movetier_" vChunk.tier] := hwnd, vars.hwnd.help_tooltips["lootfilter_tier " vChunk.tier] := hwnd1, count += 1, last_movetier := iChunk
				}

			If count && !hide_check && !strand_check
			{
				Loop 2
				{
					Gui, %GUI%: Font, strike
					Gui, %GUI%: Add, Text, % (A_Index = 2 ? "Section xs x" margin : "ys") " BackgroundTrans gLootfilter_Customize HWNDhwnd 0x200 h" hItems " c" style_defaults.settextcolor, % " " Lang_Trans("lootfilter_newtier") " "
					Gui, %GUI%: Add, Progress, % "Disabled xp yp wp hp HWNDhwnd1 BackgroundRed c" style_defaults.setbackgroundcolor, 100
					cPos := LLK_ControlGetPos(hwnd)
					If (cPos.xMax <= wMax)
						Break
					Else
						For index, val in ["", 1]
							GuiControl, +Hidden, % hwnd%val%
				}
				vars.hwnd.lootfilter["movetier_newtier|" last_movetier] := hwnd
			}
		}
		Gui, %GUI%: Font, % "norm s" settings.lootfilter.fSize
		cPos := LLK_ControlGetPos(hwnd)
	}

	Label_Show:
	Gui, %GUI%: Margin, 0, 0
	Gui, %GUI%: Add, Progress, % "Disabled Background" settings.lootfilter.color_background " x0 y0 w" wMax + margin - 1 " h" Max(cPos.yMax, hMax) + margin - 1, 0

	Gui, %GUI%: Show, % "NA AutoSize x10000 y10000"
	WinGetPos,,, width, height, ahk_id %hwnd_editor%

	xPos := vars.client.x + vars.client.w - width, yPos := vars.client.y + vars.client.h * 0.53 - height
	Gui_CheckBounds(xPos, yPos, width, height)
	Gui, %GUI%: Show, % "NA x" xPos " y" yPos
	LLK_Overlay(hwnd_editor, "show",, GUI), LLK_Overlay(hwnd_old, "destroy")

	If (error = "paste")
		LLK_ToolTip(Lang_Trans("global_errorpaste"), 2,,,, "Red")
	Return
}

Lootfilter_Load(mode := "", dev_check := 0)
{
	local
	global vars, settings, json

	config_folder := SubStr(vars.system.config, 1, InStr(vars.system.config, "\",, 0) - 1)
	If !FileExist(config_folder "\FilterSpoon.filter")
	{
		new_file := FileOpen(config_folder "\FilterSpoon.filter", "w", "UTF-8-RAW"), new_file.Close()
		If !FileExist(config_folder "\FilterSpoon_tester.filter")
			new_file := FileOpen(config_folder "\FilterSpoon_tester.filter", "w", "UTF-8-RAW"), new_file.Close()
		MsgBox, 4096, % Lang_Trans("ms_filterspoon") ": " Lang_Trans("global_setup"), % Lang_Trans("lootfilter_presetup") "`n`n" Lang_Trans("lootfilter_presetup", 2)
	}

	If !IsObject(vars.lootfilter.filters_list) || (mode = "refresh")
		vars.lootfilter.filters_list := {}

	file := (InStr(mode, "_") ? SubStr(mode, InStr(mode, "_") + 1) : "")
	If file
		file := [file, vars.lootfilter.filters_list[file].1], vars.lootfilter.filters_list.Delete(file.1)

	Loop, Files, % config_folder "\OnlineFilters\" file.2 "*"
	{
		FileGetTime, last_update
		raw := LLK_FileRead(A_LoopFilePath, 1), raw := StrReplace(raw, "`r`n", "`n"), name := ""
		If !InStr(raw, "# NeverSink's Indepth Loot Filter")
			Continue
		Loop, Parse, raw, `n, % " `r"
			If InStr(A_LoopField, "#name:")
			{
				name := SubStr(A_LoopField, InStr(A_LoopField, ":") + 1)
				Break
			}
		If name
			If vars.lootfilter.filters_list[name]
				Return (vars.lootfilter.filters_list := 0)
			Else vars.lootfilter.filters_list[name] := [A_LoopFileName, last_update]

		If (mode = "refresh")
			Continue

		If name && (name = settings.lootfilter.active_filter)
		{
			vars.lootfilter.active_filter := {"stock": [], "final": []}, filter := vars.lootfilter.active_filter.stock, filter2 := vars.lootfilter.active_filter.final

			While InStr(raw, "`n`n")
				chunk := SubStr(raw, 1, (check := InStr(raw, "`n`n")) - 1), raw := SubStr(raw, check + 2), filter.Push(chunk), filter2.Push(chunk)
			filter.Push(raw), filter2.Push(raw)

			For index, val in filter
				If RegexMatch(val, "i)^.{0,2}(show|hide|FilterBlade:.Conditional.Entry)")
				{
					If InStr(val, "# FilterBlade: Conditional Entry")
					{
						find_type := 1
						While !InStr(filter[index + find_type], "$type->")
							find_type += 1
						If InStr((chunk := filter[index + find_type]), "$type->")
							find_type := SubStr(chunk, InStr(chunk, "$type->") + 7), find_type := SubStr(find_type, 1, InStr(find_type, " ") - 1)
						Else find_type := "filterblade"
						val := StrReplace(val, "# FilterBlade: Conditional Entry`n"), val := StrReplace(val, "`n", " # $type->" find_type " $tier->conditional`n",, 1)
					}
					filter[index] := {"lines": StrSplit(val, "`n")}, filter2[index] := {"lines": StrSplit(val, "`n")}
					For index2, line in filter[index].lines
					{
						If (index2 = 1)
						{
							type := tier := ""
							Loop, Parse, line, % " "
								If InStr(A_LoopField, "type") && !type
									type := SubStr(A_LoopField, InStr(A_LoopField, ">") + 1), type := StrReplace(type, "->", " > ")
								Else If InStr(A_LoopField, "tier") && !tier
									tier := SubStr(A_LoopField, InStr(A_LoopField, ">") + 1), tier := StrReplace(tier, "->", " > ")
							filter[index].type := type, filter[index].tier := tier, filter2[index].type := type, filter2[index].tier := tier
							Continue
						}
						split := StrSplit(line, " "), split.1 := (InStr(split.1, "`t") ? split.1 : (InStr(split.1, "#") ? StrReplace(split.1, "#", "#`t",, 1) : "`t" split.1))
						If RegexMatch(split.2, "i)=|>|<")
							filter[index].lines[index2] := {(split.1 " " split.2): SubStr(line, InStr(line, " ",,, 2) + 1)}, filter2[index].lines[index2] := {(split.1 " " split.2): SubStr(line, InStr(line, " ",,, 2) + 1)}
						Else If InStr(line, " ")
							filter[index].lines[index2] := {(split.1): SubStr(line, InStr(line, " ",,, 1) + 1)}, filter2[index].lines[index2] := {(split.1): SubStr(line, InStr(line, " ",,, 1) + 1)}
					}
				}

			profile := settings.lootfilter.profile, ini := IniBatchRead("ini" vars.poe_version "\lootfilter.ini", "modifications - profile " profile)
			vars.lootfilter.modifications["profile" profile] := [], vars.lootfilter.modifications["profile" profile].0 := ""
			For key, val in ini["modifications - profile " profile]
				vars.lootfilter.modifications["profile" profile][key] := json.load(val)

			Lootfilter_LoadStructure()
			For index, object in vars.lootfilter.modifications_pending
				If InStr(object.action, "economy") && (warning := Lootfilter_Modify(object))
					vars.lootfilter.modifications_pending[index].warning := warning

			For index, object in vars.lootfilter.modifications["profile" profile]
				If !(InStr(object.action, "economy") && vars.lootfilter.modifications_pending[index].action)
				&& (index < 0 && vars.lootfilter.modifications_pending[index].modifications.toggle != "off" || index > 0) && (warning := Lootfilter_Modify(object))
					vars.lootfilter.modifications["profile" profile][index].warning := warning
		}
	}
	If !Blank(settings.lootfilter.active_filter) && !vars.lootfilter.filters_list[settings.lootfilter.active_filter]
		IniWrite, % """" (settings.lootfilter.active_filter := "") """", % "ini" vars.poe_version "\lootfilter.ini", settings, active filter

	If dev_check && settings.general.dev
	{
		count := 0
		For index, chunk in vars.lootfilter.active_filter.stock
			If IsObject(chunk)
				Lootfilter_Match(chunk, dev_check), count += 1
		MsgBox, % count
	}
	Return 1
}

Lootfilter_LoadStructure()
{
	local
	global vars, settings

	vars.lootfilter.active_filter.structure := {}, structure := vars.lootfilter.active_filter.structure
	For index, val in vars.lootfilter.active_filter.final
		If IsObject(val) && !LLK_HasVal(val.lines, "Continue", 1, 1) && !RegexMatch(val.lines.1, "i)^.{0,2}#")
		{
			type := val.type, tier := val.tier, basetype := ""
			If settings.general.dev && !(type || tier)
			{
				MsgBox, % "block with missing type/tier: " index
				Continue
			}
			If !IsObject(structure[type])
				structure[type] := []
			If settings.general.dev && LLK_HasKey(structure[type], tier,,,, 1)
			{
				MsgBox, % "duplicate tier in type """ type """"
				Continue
			}
			For iLine, oLine in val.lines
				For kLine, vLine in oLine
					If InStr(kLine, "basetype")
						basetype := vLine
			structure[type].Push({"tier": tier, "basetypes": basetype})
		}
}

Lootfilter_Match(array, dev_check := 0)
{
	local
	global vars, settings, db
	static vaal_uniques := {"Apep's Supremacy": 1, "Atziri's Acuity": 1, "Atziri's Contempt": 1, "Atziri's Disdain": 1, "Atziri's Rule": 1, "Atziri's Splendour": 1, "Atziri's Step": 1, "Belly of the Beast": 1, "Bloodbarrier": 1
	, "Constricting Command": 1, "Cornathaum": 1, "Corona of the Red Sun": 1, "Coward's Legacy": 1, "Demon Stitcher": 1, "Doryani's Prototype": 1, "Dream Fragments": 1, "Drillneck": 1, "Glimpse of Chaos": 1, "Greed's Embrace": 1
	, "Hateforge": 1, "Idle Hands": 1, "Mahuxotl's Machination": 1, "Mask of the Stitched Demon": 1, "Plaguefinger": 1, "Powertread": 1, "Quatl's Molt": 1, "Quecholli": 1, "Rathpith Globe": 1, "Rearguard": 1, "Redflare Conduit": 1
	, "Rise of the Phoenix": 1, "Saitha's Spear": 1, "Seed of Cataclysm": 1, "Serpent's Egg": 1, "Serpent's Lesson": 1, "Shackles of the Wretched": 1, "Snakebite": 1, "Snakepit": 1, "Soul Mantle": 1, "Soul Tether": 1
	, "Tetzlapokal's Desire": 1, "The Adorned": 1, "The Covenant": 1, "The Flesh Poppet": 1, "The Vertex": 1, "Zerphi's Genesis": 1, "Zerphi's Serape": 1}

	object := {"matches": {}, "setbackgroundcolor": "0 0 0 255", "setbordercolor": "0 0 0 255", "settextcolor": "190 178 135 255"}, search := vars.lootfilter.search[vars.lootfilter.search.0]
	For index, line in array.lines
		If IsObject(line)
			For key, val in line
				key := Trim(key, " `t=><"), object[key] := val

	For key, val in object
		If InStr(key, "color")
			object[key] := RGB_Convert(val)

	meta_search := (InStr(search, ":") ? 1 : 0), parse := StrSplit(StrReplace(search, ", ", ","), ",")
	For index, val in parse
		If !Blank(val)
			meta_search *= InStr(val, ":")
	object.meta_search := meta_search

	If dev_check
		search := {}

	If !IsObject(search)
		Loop, Parse, % StrReplace(search, ", ", ","), % ","
		{
			If InStr(A_LoopField, ":")
			{
				parse := StrSplit(A_LoopField, ":", " ")
				If !RegExMatch("""" array[parse.1] """", "i)" parse.2) && !RegexMatch(object[parse.1], "i)" parse.2)
					Return
			}

			For index, val in StrSplit(StrReplace(object.basetype, """ """, """|"""), "|", " ")
				If RegExMatch(val, "i)" A_LoopField) || meta_search && InStr(A_LoopField, ":")
					object.matches[val] := 1

			If !object.basetype
				For index, val in StrSplit(StrReplace(object.class, """ """, """|"""), "|", " ")
					If RegExMatch(val, "i)" A_LoopField) || meta_search && InStr(A_LoopField, ":")
						object.matches[val] := 1

			If !object.basetype && !object.class && meta_search && InStr(A_LoopField, ":")
				object.matches["any item"] := 1
		}
	Else
	{
		basename := search.item[(search.item.itembase ? "itembase" : "name")], item_class := search.item.class
		For index, val in array.lines
			If IsObject(val)
				For key, value in val
				{
					parse := StrSplit(Trim(key, "# `t"), " "), key := parse.1, operator := parse.2
					Switch ;messy, many cases can be merged
					{
					Case RegexMatch(key, "i)basetype|class"):
						%key% := 0
						For index, type in StrSplit(StrReplace(value, """ """, """|"""), "|", " """)
							If (key = "basetype") && (operator = "==" && basename = type || !operator && (InStr(basename, type) || type = "vaal" && InStr(search.clipboard, "---`n" type))) || (key = "class") && (operator = "==" && item_class = type || !operator && InStr(item_class, type))
							{
								%key% := (type = "vaal" ? "Vaal " (basename ? basename : "Gem") : type)
								Break
							}
						If !%key% && !dev_check
							Return
					Case RegexMatch(key, "i)^(mirrored|corrupted)$"):
						%key% := 0
						If (!(check := InStr(search.clipboard, "`n" key "`n")) && (value = "true") || check && (value = "false")) && !dev_check
							Return
						%key% := 1
					Case (key = "linkedsockets"):
						links := 0, sockets_item := SubStr(search.clipboard, (check := InStr(search.clipboard, "`nsockets: ")) + 1), sockets_item := SubStr(sockets_item, 1, InStr(sockets_item, "`n") - 1)
						If (!check || !RegexMatch(sockets_item, "i)(.-){" value - 1 ",}")) && !dev_check
							Return
						links := 1
					Case (key = "zanamemory"):
						If !InStr(search.clipboard, "Area is Influenced by the Originator") && !dev_check
							Return
					Case (key = "hasinfluence"):
						influence := 0, influences := {"shaper": "shaper", "elder": "elder", "warlord": "drox", "hunter": "al-hezmin", "redeemer": "veritania", "crusader": "baran"}
						For index, type in StrSplit(value, " ", " """)
							If InStr(search.clipboard, "`n" StrReplace(type, """") " item`n") || (object.class = """maps""") && RegexMatch(search.clipboard, "i)\n(map.contains.|area.is.influenced.by.the.)" influences[type])
							{
								influence := 1
								Break
							}
						If !influence && !dev_check
							Return
					Case RegexMatch(key, "i)^has(searing|eater).*implicit$"):
						eaterexarch := 0
						If !RegexMatch(search.clipboard, "i)\n\{." (InStr(key, "searing") ? "searing" : "eater") ".*implicit.*\}\n") && !dev_check
							Return
						eaterexarch := 1
					Case (key = "itemlevel"):
						ilvl := 0
						If (operator = ">=" && search.item.ilvl < value || operator = "<=" && search.item.ilvl > value) && !dev_check
							Return
						ilvl := 1
					Case (key = "rarity"):
						rarity := 0
						For index, type in StrSplit(value, " ")
							If type && InStr(search.clipboard, "`nrarity: " StrReplace(type, """") "`n")
							{
								rarity := 1
								Break
							}
						If !rarity && !dev_check
							Return
					Case (key = "identified"):
						IDed := 0
						If ((check := InStr(search.clipboard, "`nunidentified`n")) && (value = "true") || !check && (value = "false")) && !dev_check
							Return
						IDed := 1
					Case (key = "quality"):
						quality := 0, quality_item := (search.item.quality ? search.item.quality : 0)
						If (operator = ">=" && quality_item < value || operator = "<=" && quality_item > value || !operator && quality_item != value) && !dev_check
							Return
						quality := 1
					Case (key = "fractureditem"):
						fractured := 0
						If ((check := InStr(search.clipboard, "`nfractured item`n")) && (value = "false") || !check && (value = "true")) && !dev_check
							Return
						fractured := 1
					Case (key = "memorystrands"):
						memstrands := 0, memstrands_item := Trim(SubStr(search.clipboard, InStr(search.clipboard, "`nmemory strands:") + 17), " `n"), memstrands_item := SubStr(memstrands_item, 1, InStr(memstrands_item, "`n") - 1)
						If (!InStr(search.clipboard, "memory strands:") || (memstrands_item < value)) && !dev_check
							Return
						memstrands := 1
					Case (key = "imbued"):
						imbued := 0
						If (!(check := InStr(search.clipboard, "`nimbued`n")) && (value = "true") || check && (value = "false")) && !dev_check
							Return
						imbued := 1
					Case (key = "synthesiseditem"):
						synth := 0
						If (!(check := InStr(search.clipboard, "`nsynthesised item`n")) && (value = "true") || check && (value = "false")) && !dev_check
							Return
						synth := 1
					Case (key = "anyenchantment"):
						anyenchantment := 0
						If (!(check := InStr(search.clipboard, " (enchant)")) && (value = "true") || check && (value = "false")) && !dev_check
							Return
						anyenchantment := 1
					Case (key = "hascruciblepassivetree"):
						hascruciblepassivetree := 0
						If (!(check := InStr(search.clipboard, " (crucible)")) && (value = "true") || check && (value = "false")) && !dev_check
							Return
						hascruciblepassivetree := 1
					Case (key = "sockets"):
						sockets := 0, sockets_item := search.item.sockets, oSockets := {}
						If !(check := InStr(search.clipboard, "`nsockets: ")) && !dev_check
							Return
						socket_text := SubStr(search.clipboard, check + 10), socket_text := SubStr(socket_text, 1, InStr(socket_text, "`n") - 1)
						If IsNumber(value) && (operator = ">=" && sockets_item < value || operator = "<" && sockets_item >= value) && !dev_check
							Return
						Else If !IsNumber(value) && !dev_check
						{
							Loop, Parse, value
								If !IsNumber(A_LoopField)
									oSockets[A_LoopField] := (!oSockets[A_LoopField] ? 1 : oSockets[A_LoopField] + 1)
							For kSocket, vSocket in oSockets
								If !InStr(socket_text, kSocket,,, vSocket)
									Return
						}
						sockets := 1
					Case (key = "gemlevel"):
						gemlevel := 0
						If !vars.poe_version
							gemlevel_item := SubStr(search.clipboard, (check := InStr(search.clipboard, "`nlevel: ") + 8))
							, gemlevel_item := ((check1 := InStr(gemlevel_item, "(")) ? SubStr(gemlevel_item, 1, check1 - 2) : SubStr(gemlevel_item, 1, InStr(gemlevel_item, "`n") - 1))
						Else gemlevel_item := SubStr(search.clipboard, (check := InStr(search.clipboard, " (level ") + 8))
							, gemlevel_item := SubStr(gemlevel_item, 1, InStr(gemlevel_item, ")") - 1)

						If (!check || !IsNumber(gemlevel_item) || (operator = ">=" && gemlevel_item < value) || (operator = "<=" && gemlevel_item > value) || (!operator && gemlevel_item != value)) && !dev_check
							Return
						gemlevel := value
					Case (key = "transfiguredgem"):
						transfigured := 0
						If (!(check := InStr(search.clipboard, "`ntransfigured`n")) && (value = "true") || check && (value = "false")) && !dev_check
							Return
						transfigured := 1
					Case (key = "replica"):
						replica := 0
						If (!(check := InStr(search.clipboard, "`nreplica ")) && (value = "true") || check && (value = "false")) && !dev_check
							Return
						replica := 1
					Case (key = "foulborn"):
						foulborn := 0
						If (!(check := InStr(search.clipboard, "`nfoulborn ")) && (value = "true") || check && (value = "false")) && !dev_check
							Return
						foulborn := 1
					Case (key = "uberblightedmap"):
						blight_ravaged := 0
						If (!(check := InStr(search.clipboard, "`nblight-ravaged map ")) && (value = "true") || check && (value = "false")) && !dev_check
							Return
						blight_ravaged := 1
					Case (key = "blightedmap"):
						blight := 0
						If (!(check := InStr(search.clipboard, "`nblighted map ")) && (value = "true") || check && (value = "false")) && !dev_check
							Return
						blight := 1
					Case (key = "maptier"):
						maptier := 0, maptier_item := SubStr(search.clipboard, (check := InStr(search.clipboard, "map (tier")) + 10), maptier_item := SubStr(maptier_item, 1, InStr(maptier_item, ")") - 1)
						If (!check || (operator = ">=" && maptier_item < value) || (operator = "<=" && maptier_item > value) || (!operator && maptier_item != value)) && !dev_check
							Return
						maptier := 1
					Case (key = "hasimplicitmod"):
						implicit := 0
						If !InStr(search.clipboard, " (implicit)") && !dev_check
							Return
						implicit := 1
					Case (key = "stacksize"):
						stacksize := 0, stack := search.item.stack
						If (operator = ">=" && stack < value || operator = "<=" && stack > value) && !dev_check
							Return
						stacksize := 1
					Case (key = "hasexplicitmod"):
						explicit := 0, count := 0, count_condition := (IsNumber(SubStr(operator, 0)) ? SubStr(operator, 0) : 0)
						For iExplicit, vExplicit in StrSplit(StrReplace(value, """ """, """|"""), "|", " ")
							count += (InStr(search.clipboard, vExplicit) ? 1 : 0)
						If (InStr(operator, ">=") && (count < count_condition) || !operator && !count || (!operator && count != count_condition)) && !dev_check
							Return
						explicit := 1
					Case (key = "enchantmentpassivenum"):
						passivenum := 0, passivenum_item := SubStr(search.clipboard, (check := RegexMatch(search.clipboard, "i)\nadds.\d{1,2}.passive.skills")) + 1), passivenum_item2 := ""
						passivenum_item := SubStr(passivenum_item, 1, InStr(passivenum_item, "`n") - 1)
						Loop, Parse, passivenum_item
							If IsNumber(A_LoopField)
								passivenum_item2 .= A_LoopField
						If (!check || (operator = ">=" && passivenum_item2 < value) || (operator = "<=" && passivenum_item2 > value) || (!operator && passivenum_item2 != value)) && !dev_check
							Return
						passivenum := 1
					Case (key = "socketgroup"):
						socketgroup := 0, sockets_item := SubStr(search.clipboard, (check := InStr(search.clipboard, "`nsockets: ")) + 1), sockets_item := SubStr(sockets_item, 1, InStr(sockets_item, "`n") - 1)
						sockets_item := SubStr(sockets_item, InStr(sockets_item, ":") + 2), sockets_item := Trim(StrReplace(sockets_item, "-"), " "), value := StrReplace(value, """"), count := 0, oGroup := {}
						Loop, Parse, value
							oGroup[A_LoopField] := (!oGroup[A_LoopField] ? 1 : oGroup[A_LoopField] + 1)
						For index, group in StrSplit(sockets_item, " ", " ")
						{
							If (StrLen(group) >= StrLen(value))
							{
								socketgroup := 1
								For kSocket, vSocket in oGroup
									socketgroup *= InStr(group, kSocket,,, vSocket)
							}
						}
						If !socketgroup && !dev_check
							Return
					Case (key = "corruptedmods"):
						corruptedmods := count := 0
						While InStr(search.clipboard, "Corruption Implicit Modifier",,, count + 1)
							count += 1
						If (!value && count || (operator = ">=" && count < value) || (operator = "<=" && count > value) || (!operator && count != value)) && !dev_check
							Return
						corruptedmods := 1
					Case (key = "twicecorrupted"):
						If !InStr(search.clipboard, "---`ncorrupted")
							Return
						object.multimatches := 1
					Case (key = "UnidentifiedItemTier"):
						unidentifiedtier := 0, unidtier_item := InStr(search.clipboard, "---`nunidentified ("), unidtier_item := (!unidtier_item ? 0 : SubStr(search.clipboard, unidtier_item + 20, 1))
						If (operator = ">=" && unidtier_item < value || operator = "<=" && unidtier_item > value || !operator && unidtier_item != value) && !dev_check
							Return
						unidentifiedtier := 1
					Case RegexMatch(key, "i)^base(evasion|energyshield|armour)"):
						%key% := 0
						If !IsObject(db.item_bases)
							DB_Load("item_bases")
						defense := StrReplace(key, "base"), defense := (defense = "evasion" ? "EV" : (defense = "armour" ? "AR" : "ES"))
						For kClass, oClass in db.item_bases
							If oClass.HasKey(basename)
							{
								defense_value := (oClass[basename][defense] ? oClass[basename][defense] : 0)
								If (operator = ">" && defense_value < value || operator = "<" && defense_value > value || !operator && defense_value != value) && !dev_check
									Return
								%key% := 1
								Break
							}
					Case (key = "waystonetier"):
						waystonetier := 0, waystonetier_item := SubStr(search.clipboard, (check := InStr(search.clipboard, "waystone (tier")) + 15), waystonetier_item := SubStr(waystonetier_item, 1, InStr(waystonetier_item, ")") - 1)
						If (!check || (operator = ">=" && waystonetier_item < value) || (operator = "<=" && waystonetier_item > value) || (!operator && waystonetier_item != value)) && !dev_check
							Return
						waystonetier := 1
					Case (key = "hasvaaluniquemod"):
						hasvaaluniquemod := 0
						If !InStr(search.clipboard, "{ Vaal Unique Modifier") && !dev_check
							Return
						hasvaaluniquemod := 1
					Case (key = "isvaalunique"):
						isvaalunique := 0
						If !vaal_uniques[basename]
							Return
						isvaalunique := 1
					Case (key = "alwaysshow"):
						Return
					Case RegexMatch(key, "i)^(set|play|minimap|disabledropsound)"):
					Case (key = "enchantmentpassivenode"):
						If !dev_check
							Return
					Case (key = "arealevel"):
						;lvl := vars.log.arealevel
						;If (operator = ">=" && lvl < value) || (operator = ">" && lvl <= value) || (operator = "<=" && lvl > value) || (operator = "<" && lvl >= value) || (!operator && lvl != value)
						;	Return
						object.multimatches := 1
					Case (key = "basedefencepercentile"):
					Case (key = "droplevel"):
					Case (key = "width"):
					Case (key = "height"):
					Case settings.general.dev:
						MsgBox, % "unknown filter condition:`n!" (Clipboard := LLK_StringCase(key)) "!"
					}
				}

		If basetype
			object.matches[basetype] := 1
		Else If class || mirrored || corrupted || links || ilvl || influence || eaterexarch || rarity || IDed || quality || fractured || memstrands || imbued || synth || anyenchantment || hascruciblepassivetree || sockets || gemlevel
		|| transfigured || replica || foulborn || blight_ravaged || blight || maptier || implicit || stacksize || explicit || passivenum || socketgroup || corruptedmods || unidentifiedtier || baseevasion || baseenergyshield
		|| basearmour || waystonetier || hasvaaluniquemod || isvaalunique
			object.matches[basename] := 1
	}

	If object.matches.Count()
		Return object
}

Lootfilter_Modify(object, global := 0)
{
	local
	global vars, settings

	removed := added := empty_tier := presentation := maptier_count := strand_count := 0
	If InStr(object.action, "tier")
		If (object.action = "movetier") && !LLK_HasVal(vars.lootfilter.active_filter.structure[object.type], object.tier,,,, 1)
			Return "`n- target tier no longer exists (item wasn't moved)"
		Else If !LLK_HasVal(vars.lootfilter.active_filter.structure[object.type], """" object.modifications[object.action] """", 1,,, 1)
			Return "`n- item is no longer in type """ object.type """ (item wasn't moved)"

	If (object.modifications.toggle != "off")
		Switch object.action
		{
			Case "global gems":
			If !vars.lootfilter.active_filter.structure.HasKey(object.type)
				Return "`n- type """ object.type """ doesn't exist anymore (global setting cannot be applied)"
			Else If !vars.poe_version && (!LLK_HasVal(vars.lootfilter.active_filter.structure[object.type], "qt", 1,,, 1) || !LLK_HasVal(vars.lootfilter.active_filter.structure[object.type], "lt", 1,,, 1))
			|| vars.poe_version && (!LLK_HasVal(vars.lootfilter.active_filter.structure[object.type], "spirit19", 1,,, 1) || !LLK_HasVal(vars.lootfilter.active_filter.structure[object.type], "skill19", 1,,, 1)
				|| !LLK_HasVal(vars.lootfilter.active_filter.structure[object.type], "supportcampaign", 1,,, 1) || !LLK_HasVal(vars.lootfilter.active_filter.structure[object.type], "exhide", 1,,, 1))
				Return "`n- type """ object.type """ has changed in structure (global setting cannot be applied)"
			;######################################################
			Case "global maps":
			If !vars.lootfilter.active_filter.structure.HasKey(object.type)
				Return "`n- type """ object.type """ doesn't exist anymore (global setting cannot be applied)"
			Else
			{
				For index, val in vars.lootfilter.active_filter.structure[object.type]
					If RegexMatch(val.tier, "i)^maps_._t\d{1,2}$")
						maptier_count += 1
				If (maptier_count != 16)
					Return "`n- type """ object.type """ has changed in structure (global setting cannot be applied)"
			}
			;######################################################
			Case "global strands":
			If !vars.lootfilter.active_filter.structure.HasKey(object.type)
				Return "`n- type """ object.type """ doesn't exist anymore (global setting cannot be applied)"
			Else
			{
				For index, val in vars.lootfilter.active_filter.structure[object.type]
					If RegExMatch(val.tier, "i)high$|^(?!.*(fractured|high|veiled)).*$")
						strand_count += 1
				If !strand_count
					Return "`n- type """ object.type """ has changed in structure (global setting cannot be applied)"
			}
			;######################################################
			Default:
			If InStr(object.action, "economy") && !vars.lootfilter.active_filter.structure.HasKey(object.type)
				Return "`n- type """ object.type """ doesn't exist anymore (global setting cannot be applied)"
		}

	If InStr(object.action, "economy")
	{
		For iMod, oMod in object.modifications
			Lootfilter_Modify(oMod, 1)
		Return
	}

	If (object.action = "newtier") && vars.lootfilter.active_filter.structure[object.type].HasKey("exui_hide")
		object.action := "movetier", object.modifications.movetier := object.modifications.newtier, object.modifications.Delete("newtier")

	pending := vars.lootfilter.modifications_pending
	For iChunk, vChunk in vars.lootfilter.active_filter.final
		Switch
		{
			Case !IsObject(vChunk) || (object.modifications.toggle = "off") || RegexMatch(vChunk.lines.1, "i)^.{0,2}#"):
			Continue
			;######################################################
			Case (object.action = "global visuals"):
			If (object.modifications.opacity) && !LLK_HasKey(vChunk.lines, "setbackgroundcolor", 1,,, 1)
				key_name := (LLK_HasKey(vChunk.lines, "`t", 1,,, 1) ? "`t" : "") "SetBackgroundColor", iMax := vars.lootfilter.active_filter.final[iChunk].lines.MaxIndex()
				, vars.lootfilter.active_filter.final[iChunk].lines.InsertAt(iMax, {(key_name): "0 0 0 255"})

			For iLine, oLine in vChunk.lines
				For kLine, vLine in oLine
				{
					If object.modifications.size && InStr(kLine, "fontsize") && (!IsObject(pending[-1]) || !Blank(pending[-1].modifications.size))
						vars.lootfilter.active_filter.final[iChunk].lines[iLine][kLine] := object.modifications.size
					Else If object.modifications.opacity && InStr(kLine, "backgroundcolor") && (!IsObject(pending[-1]) || !Blank(pending[-1].modifications.opacity))
						parse := StrSplit(vLine, " "), parse.4 := object.modifications.opacity, vars.lootfilter.active_filter.final[iChunk].lines[iLine][kLine] := LLK_ArrayDump(parse, " ")
				}
			;######################################################
			Case (object.action = "global strands") && (vChunk.type && object.type = vChunk.type):
			If object.modifications["strands high"] && (!IsObject(pending[-31]) || !Blank(pending[-31].modifications["strands high"])) && RegexMatch(vChunk.tier, "i)high$")
			{
				For iLine, oLine in vChunk.lines
					For kLine, vLine in oLine
						If InStr(kLine, "memorystrand")
							vars.lootfilter.active_filter.final[iChunk].lines[iLine][kLine] := object.modifications["strands high"], vars.lootfilter.active_filter.final[iChunk].global := 1
			}
			Else If object.modifications.strands && (!IsObject(pending[-31]) || !Blank(pending[-31].modifications.strands)) && !RegexMatch(vChunk.tier, "i)(fractured|veiled|high)$")
				For iLine, oLine in vChunk.lines
					For kLine, vLine in oLine
						If InStr(kLine, "memorystrand")
							vars.lootfilter.active_filter.final[iChunk].lines[iLine][kLine] := object.modifications.strands, vars.lootfilter.active_filter.final[iChunk].global := 1
			;######################################################
			Case (object.action = "global maps") && (vChunk.type && object.type = vChunk.type):
			If (!IsObject(pending[-21]) || !Blank(pending[-21].modifications.tier)) && RegexMatch(vChunk.tier, "i)^maps_._t\d{1,2}$")
			{
				tier := SubStr(vChunk.tier, (IsNumber(SubStr(vChunk.tier, -1)) ? -1 : 0))
				If (tier < object.modifications.tier) && !RegExMatch(vars.lootfilter.active_filter.final[iChunk].lines.1, "i)^.{0,2}hide")
					vars.lootfilter.active_filter.final[iChunk].lines.1 := StrReplace(vChunk.lines.1, "show", "Hide",, 1), vars.lootfilter.active_filter.final[iChunk].global := 1
				Else If (tier >= object.modifications.tier) && !RegExMatch(vars.lootfilter.active_filter.final[iChunk].lines.1, "i)^.{0,2}show")
					vars.lootfilter.active_filter.final[iChunk].lines.1 := StrReplace(vChunk.lines.1, "hide", "Show",, 1), vars.lootfilter.active_filter.final[iChunk].global := 1
			}
			;######################################################
			Case (object.action = "global gems") && (vChunk.type && object.type = vChunk.type):
			If !vars.poe_version
				If object.modifications.quality && (!IsObject(pending[-11]) || !Blank(pending[-11].modifications.quality)) && RegExMatch(vChunk.tier, "i)^qt1")
				|| object.modifications.level && (!IsObject(pending[-11]) || !Blank(pending[-11].modifications.level)) && RegExMatch(vChunk.tier, "i)^lt1")
				{
					If !RegExMatch(vars.lootfilter.active_filter.final[iChunk].lines.1, "i)^.{0,2}show")
						vars.lootfilter.active_filter.final[iChunk].lines.1 := StrReplace(vChunk.lines.1, "hide", "Show",, 1)
					For iLine, oLine in vChunk.lines
						For kLine, vLine in oLine
							If object.modifications.quality && InStr(kLine, "quality")
								vars.lootfilter.active_filter.final[iChunk].lines[iLine][kLine] := object.modifications.quality
							Else If object.modifications.level && InStr(kLine, "level")
								vars.lootfilter.active_filter.final[iChunk].lines[iLine][kLine] := object.modifications.level
					vars.lootfilter.active_filter.final[iChunk].global := 1
				}
				Else If (object.modifications.quality && (!IsObject(pending[-11]) || !Blank(pending[-11].modifications.quality)) && RegExMatch(vChunk.tier, "i)^qt\d")
					|| object.modifications.level && (!IsObject(pending[-11]) || !Blank(pending[-11].modifications.level)) && RegExMatch(vChunk.tier, "i)^lt\d"))
				&& !RegExMatch(vars.lootfilter.active_filter.final[iChunk].lines.1, "i)^.{0,2}hide")
					vars.lootfilter.active_filter.final[iChunk].lines.1 := StrReplace(vChunk.lines.1, "show", "Hide",, 1), vars.lootfilter.active_filter.final[iChunk].global := 1

			If vars.poe_version
				For iType, vType in ["skill", "spirit", "support"]
					If (iType < 3 && vChunk.tier = vType "19" || iType = 3 && vChunk.tier = vType "campaign") && object.modifications[vType "level"] && (!IsObject(pending[-11]) || !Blank(pending[-11].modifications[vType "level"]))
					{
						If !RegExMatch(vars.lootfilter.active_filter.final[iChunk].lines.1, "i)^.{0,2}show")
							vars.lootfilter.active_filter.final[iChunk].lines.1 := StrReplace(vChunk.lines.1, "hide", "Show",, 1)
						If (iTarget := LLK_HasKey(vChunk.lines, "gemlevel", 1,,, 1))
							vars.lootfilter.active_filter.final[iChunk].lines.RemoveAt(iTarget), vars.lootfilter.active_filter.final[iChunk].lines.InsertAt(iTarget, {"`tGemLevel >=": object.modifications[vType "level"]})
						Else vars.lootfilter.active_filter.final[iChunk].lines.InsertAt(2, {"`tGemLevel >=": object.modifications[vType "level"]})
						If (iTarget := LLK_HasKey(vChunk.lines, "arealevel", 1,,, 1))
							vars.lootfilter.active_filter.final[iChunk].lines.RemoveAt(iTarget)
						vars.lootfilter.active_filter.final[iChunk].global := 1
					}
					Else If object.modifications[vType "level"] && !InStr(vChunk.tier, "20") && !(iType < 3 && vChunk.tier = vType "19" || iType = 3 && vChunk.tier = vType "campaign")
					&& InStr(vChunk.tier, vType) && RegexMatch(vChunk.lines.1, "i)^.{0,2}show")
						vars.lootfilter.active_filter.final[iChunk].lines.1 := StrReplace(vars.lootfilter.active_filter.final[iChunk].lines.1, "Show", "Hide",, 1), vars.lootfilter.active_filter.final[iChunk].global := 1
			;######################################################
			Case (object.action = "presentation") && (vChunk.type && object.type = vChunk.type) && (vChunk.tier && object.tier = vChunk.tier):
			For kCustomization, vCustomization in object.modifications
				If (kCustomization = "visibility")
					current := vars.lootfilter.active_filter.final[iChunk].lines.1, vars.lootfilter.active_filter.final[iChunk].lines.1 := StrReplace(current, (vCustomization = "Show" ? "Hide" : "Show"), vCustomization,, 1), presentation := 1
				Else
				{
					If (kCustomization = "setbackgroundcolor") && !LLK_HasKey(vChunk.lines, kCustomization, 1,,, 1)
						key_name := (LLK_HasKey(vChunk.lines, "`t", 1,,, 1) ? "`t" : "") . kCustomization, iMax := vars.lootfilter.active_filter.final[iChunk].lines.MaxIndex()
						, vars.lootfilter.active_filter.final[iChunk].lines.InsertAt(iMax, {(key_name): "0 0 0 255"})
					If !LLK_HasKey(vChunk.lines, kCustomization, 1,,, 1)
						key_name := (LLK_HasKey(vChunk.lines, "`t", 1,,, 1) ? "`t" : "") . kCustomization
						, vars.lootfilter.active_filter.final[iChunk].lines.Push({(key_name): (IsObject(vCustomization) ? LLK_ArrayDump(vCustomization) : vCustomization)}), presentation := 1
					Else
						For iLine, vLine in vChunk.lines
							For kLine, string in vLine
								If InStr(kLine, kCustomization)
								{
									parse := StrSplit(string, " ")
									For index, val in vCustomization
										If !Blank(val)
											parse[index] := val
									vars.lootfilter.active_filter.final[iChunk].lines[iLine][kLine] := (IsObject(vCustomization) ? LLK_ArrayDump(parse) : vCustomization), presentation := 1
								}
				}
			Break
			;######################################################
			Case (object.action = "newtier") && !new_tier && (vChunk.type = object.type) && (vars.lootfilter.active_filter.final[iChunk + 1].type != object.type) && (vars.lootfilter.active_filter.final[iChunk + 2].type != object.type):
			lookback := 0, lines := []
			While RegExMatch(vars.lootfilter.active_filter.final[iChunk - lookback].lines.1, "i)^.{0,2}#|tier->rest")
				lookback += 1
			lines0 := vars.lootfilter.active_filter.final[iChunk - lookback].lines.Clone()

			For index, oLine in lines0
				If (index = 1)
					lines.Push("Hide # $type->" StrReplace(object.type, " > ", "->") " $tier->" StrReplace(object.tier, " > ", "->"))
				Else If !IsObject(oLine)
					lines.Push(oLine)
				Else
					For key, val in oLine
						If !RegExMatch(key, "i)^.{0,2}(play|minimap)")
							key := (InStr(key, "`t") ? "" : "`t") key, lines.Push({(key): val})

			If !LLK_HasKey(lines, "border", 1,,, 1)
				lines.InsertAt(lines.MaxIndex(), {"`tSetBorderColor": "255 0 0 255"})

			For index, oLine in lines
				For key, val in oLine
					If InStr(key, "border")
						lines[index][key] := "255 0 0 255"
					Else If InStr(key, "background")
						lines[index][key] := "0 0 0 255"
					Else If InStr(key, "textcolor")
						lines[index][key] := "190 178 135 255"
					Else If InStr(key, "fontsize")
						lines[index][key] := settings.lootfilter.size_medium
					Else If InStr(key, "basetype")
						lines[index][key] := """" object.modifications.newtier """"
			
			If !LLK_HasKey(lines, "basetype", 1,,, 1)
				iTarget := LLK_HasKey(lines, "class", 1,,, 1), lines.InsertAt(iTarget + 1, {"`tBaseType ==": """" object.modifications.newtier """"})
			If !LLK_HasKey(lines, "disabledropsound", 1,,, 1)
				lines.Push({"`tDisableDropSound": "True"})

			vars.lootfilter.active_filter.final.InsertAt(iChunk - lookback + 1, {"type": object.type, "tier": object.tier, "lines": lines, "global": global}), new_tier := 1
			vars.lootfilter.active_filter.structure[object.type].Push({"tier": object.tier, "basetypes": """" object.modifications.newtier """"})
			;######################################################
			Case InStr(object.action, "tier") && (vChunk.type && vChunk.type = object.type):
				For iLine, vLine in vChunk.lines
					For key, val in vLine
						If InStr(val, """" object.modifications[object.action] """") && (vChunk.tier != object.tier)
						{
							val := StrReplace(val, """" object.modifications[object.action] """"), val := Trim(StrReplace(val, "  ", " "), " "), removed := 1
							If val
							{
								vars.lootfilter.active_filter.final[iChunk].lines[iLine][key] := val, iTarget := LLK_HasVal(vars.lootfilter.active_filter.structure[object.type], vChunk.tier,,,, 1)
								If iTarget
									vars.lootfilter.active_filter.structure[object.type][iTarget].basetypes := val
							}
							Else
							{
								remove .= (remove ? "," : "") iChunk, empty_tier := vChunk.tier, iTarget := LLK_HasVal(vars.lootfilter.active_filter.structure[object.type], vChunk.tier,,,, 1)
								If iTarget
									vars.lootfilter.active_filter.structure[object.type].RemoveAt(iTarget)
							}
						}
						Else If (object.action = "movetier") && (vChunk.tier && vChunk.tier = object.tier) && InStr(key, "basetype") && !InStr(val, """" object.modifications.movetier """")
						{
							vars.lootfilter.active_filter.final[iChunk].lines[iLine][key] .= " """ object.modifications.movetier """", added := 1
							iTarget := LLK_HasVal(vars.lootfilter.active_filter.structure[object.type], vChunk.tier,,,, 1)
							If iTarget
								vars.lootfilter.active_filter.structure[object.type][iTarget].basetypes .= " """ object.modifications.movetier """"
						}
		}

	Sort, remove, % "N R D,"
	Loop, Parse, remove, % ","
		vars.lootfilter.active_filter.final.RemoveAt(A_LoopField)

	If (object.action = "presentation") && !presentation
		warning .= "`n- couldn't find the tier """ object.tier """ (modification wasn't applied)"
	Else If InStr(object.action, "tier")
	{
		If empty_tier
			warning .= "`n- original tier """ empty_tier """ didn't have any basetypes left after the move (it had to be deleted)"
		If !removed
			warning .= "`n- item wasn't moved from any tier (not found, or didn't have to be moved)"
		If (object.action = "movetier") && !added
			warning .= "`n- item wasn't added to """ object.tier """ (tier doesn't exist, or already has the item)"
	}
	Return warning
}

Lootfilter_TesterDump()
{
	local
	global vars, settings

	tester := vars.lootfilter_tester, size := settings.lootfilter["size_" tester.size], opacity := settings.lootfilter["opacity_" tester.opacity]
	dump := "Show`nBaseType == ""Orb of Transmutation""`nSetFontSize " size "`nSetTextColor 255 0 0 255`nSetBorderColor 255 0 0 255`nSetBackgroundColor 255 255 255 " opacity "`n`n"
	dump .= "Show`nBaseType == ""Scroll of Wisdom""`nSetFontSize " size "`nSetTextColor 0 0 0 255`nSetBorderColor 0 0 0 255`nSetBackgroundColor 240 90 35 " opacity "`n`n"
	dump .= "Show`nBaseType == ""Orb of Augmentation""`nSetFontSize " size "`nSetTextColor 190 178 135 255`nSetBorderColor 190 178 135 255`nSetBackgroundColor 0 0 0 " opacity "`n`n"
	dump .= "Show`nBaseType == ""Blacksmith's Whetstone""`nSetFontSize " size "`nSetTextColor 255 255 255 255`nSetBorderColor 255 255 255 255`nSetBackgroundColor 240 90 35 " opacity "`n`n"
	dump .= "Show`nBaseType == ""Armourer's Scrap""`nSetFontSize " size "`nSetTextColor 0 0 0 255`nSetBorderColor 0 0 0 255`nSetBackgroundColor 249 150 25 " opacity "`n`n"

	new_file := FileOpen(vars.system.config_folder "\FilterSpoon_tester.filter", "w", "UTF-8-RAW")
	new_file.Write(dump), new_file.Close()
}
