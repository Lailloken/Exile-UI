Init_exchange()
{
	local
	global vars, settings, json

	If FileExist("ini" vars.poe_version "\exchange.ini") ;delete file with incorrect/placeholder name
		FileDelete, % "ini" vars.poe_version "\exchange.ini"

	If !FileExist("ini" vars.poe_version "\vaal street.ini")
		IniWrite, % "", % "ini" vars.poe_version "\vaal street.ini", settings

	If !IsObject(vars.exchange)
		vars.exchange := {"date": 0, "inventory": 0, "multiplier": 1, "ratio_lock": 0, "transactions": {}}, vars.pics.exchange := {}, vars.pics.exchange_trades := {}

	If !IsObject(vars.async)
		vars.async := {"conversions": {}}, vars.pics.async := {}

	If !IsObject(settings.exchange)
		settings.exchange := {}
	If !IsObject(settings.async)
		settings.async := {}

	ini := IniBatchRead("ini" vars.poe_version "\vaal street.ini")
	settings.exchange.fSize := !Blank(check := ini.settings["font-size"]) ? check : settings.general.fSize
	LLK_FontDimensions(settings.exchange.fSize, font_height, font_width), settings.exchange.fWidth := font_width, settings.exchange.fHeight := font_height
	settings.exchange.graphs := !Blank(check := ini.settings["show graphs"]) ? check : 0
	settings.exchange.chaos_div := !Blank(check := ini.settings["chaos-div ratio"]) ? check : ""
	settings.exchange.exalt_div := !Blank(check := ini.settings["exalt-div ratio"]) ? check : ""

	settings.async.fSize := !Blank(check := ini["settings async trade"]["font-size"]) ? check : settings.general.fSize
	LLK_FontDimensions(settings.async.fSize, font_height, font_width), settings.async.fWidth := font_width, settings.async.fHeight := font_height
	settings.async.fSize2 := settings.async.fSize - 2
	LLK_FontDimensions(settings.async.fSize2, font_height, font_width), settings.async.fWidth2 := font_width, settings.async.fHeight2 := font_height
	settings.async.sorting_sell := !Blank(check := ini["settings async trade"]["sorting (sell)"]) ? check : ""
	settings.async.sorting_buy := !Blank(check := ini["settings async trade"]["sorting (buy)"]) ? check : "age"
	settings.async.filter_sell := ""
	settings.async.filter_buy := !Blank(check := ini["settings async trade"]["filter (buy)"]) ? check : "all"
	settings.async.show_name := !Blank(check := ini["settings async trade"]["show full name"]) ? check : 0
	settings.async.minchange := !Blank(check := ini["settings async trade"]["minimum price change"]) ? check : 10

	vars.async.currencies := {"chaos": "chaos", "exalted": "exalted", "transmut": "transmute", "aug": "aug", "regal": "regal"}

	If FileExist("ini" vars.poe_version "\vaal street log.ini")
	{
		ini2 := IniBatchRead("ini" vars.poe_version "\vaal street log.ini"), vars.exchange.transactions := {}
		For key, val in ini2
		{
			date := SubStr(key, 1, InStr(key, ",") - 1), time := SubStr(key, InStr(key, ",") + 2)
			If !IsObject(vars.exchange.transactions[date])
				vars.exchange.transactions[date] := []

			object := json.Load(val.transaction), object.time := time
			vars.exchange.transactions[date].Push(object)
		}
	}

	If FileExist("ini" vars.poe_version "\async trade.ini")
	{
		ini2 := IniBatchRead("ini" vars.poe_version "\async trade.ini")
		For key, object in ini2
		{
			If !object.league || object.sold
				Continue
			object_new := {"prices": [], "timestamp": SubStr(key, 1, InStr(key, " ") - 1), "name": SubStr(key, InStr(key, " ") + 1)}
			For key1, val in object
				If InStr(key1, "price ")
					object_new.prices.Push(StrSplit(SubStr(key1, InStr(key1, " ") + 1) " " val, " "))
				Else If (key1 != "type")
					object_new[key1] := val

			If !IsObject(vars.async[object.league])
				vars.async[object.league] := {"buy": {}, "sell": {}}
			vars.async[object.league][object.type][key] := object_new
		}
	}
}

AsyncTrade(cHWND := "", hotkey := "")
{
	local
	global vars, settings
	static toggle := 0, fSize, listings
	
	check := LLK_HasVal(vars.hwnd.async, cHWND), control := SubStr(check, InStr(check, "_") + 1), league := settings.general.league.1 " " settings.general.league[(vars.poe_version ? 3 : 4)]
	If !IsObject(vars.async[league])
		vars.async[league] := {"buy": {}, "sell": {}}

	If (cHWND = "close")
	{
		LLK_Overlay(vars.hwnd.async.main, "destroy")
		vars.hwnd.async := ""
		Return
	}
	Else If (cHWND = "hide")
	{
		LLK_Overlay(vars.hwnd.async.main, "hide"), hwnd := vars.hwnd.async.main, vars.hwnd.async.main := ""
		KeyWait, ALT
		vars.hwnd.async.main := hwnd, LLK_Overlay(vars.hwnd.async.main, "show")
		Return
	}
	Else If RegExMatch(cHWND, "i)buy|sell")
		vars.async.mode := cHWND
	Else If InStr(check, "sort_")
	{
		KeyWait, LButton
		mode := vars.async.mode
		input := (settings.async["sorting_" mode] = "price" && InStr(control, "price") ? "price_asc" : (settings.async["sorting_" mode] = "price_asc" && InStr(control, "price") ? "price" : StrReplace(control, "|")))
		input := StrReplace(input, "agetotal")
		IniWrite, % (settings.async["sorting_" mode] := input), % "ini" vars.poe_version "\vaal street.ini", settings async trade, % "sorting (" mode ")"
	}
	Else If InStr(check, "listing_")
	{
		If LLK_Progress(vars.hwnd.async[check "_bar"], "RButton")
		{
			target := listings[control].timestamp " " listings[control].name
			vars.async[league][vars.async.mode].Delete(target)
			IniDelete, % "ini" vars.poe_version "\async trade.ini", % target
		}
		Else If (vars.system.click = 2) || (vars.system.click = 1 && vars.async.mode = "buy")
			Return
		Else
		{
			GuiControl, +cLime, % vars.hwnd.async[check "_bar"]
			If LLK_Progress(vars.hwnd.async[check "_bar"], "LButton")
			{
				target := listings[control].timestamp " " listings[control].name, vars.async[league].sell[target].sold := 1
				IniWrite, 1, % "ini" vars.poe_version "\async trade.ini", % target, sold
			}
			Else
			{
				GuiControl, +cRed, % vars.hwnd.async[check "_bar"]
				target := listings[control], regex := (target.rarity = "magic" ? """" StrReplace(target.name, target.itembase, ".*") """" : """" target.name """"), regex := StrReplace(StrReplace(regex, ".* ", ".*"), " .*", ".*")
				regex := regex " """ target.prices[target.prices.MaxIndex()].2 " " target.prices[target.prices.MaxIndex()].3 """"
				For string, replace in {"perfect-": "p.*-", "greater-": "g.*-"}
					regex := StrReplace(regex, string, replace)
				Clipboard := "", Clipboard := regex
				ClipWait, 0.1
				KeyWait, LButton
				WinActivate, % "ahk_id " vars.hwnd.poe_client
				WinWaitActive, % "ahk_id " vars.hwnd.poe_client
				SendInput, ^{f}
				Sleep 100
				SendInput, ^{a}^{v}
				Return
			}
		}
	}
	Else If (check = "league_select")
	{
		KeyWait, LButton
		Settings_menu("general")
		Return
	}
	Else If InStr(check, "filter_")
	{
		KeyWait, LButton
		IniWrite, % (settings.async["filter_" vars.async.mode] := control), % "ini" vars.poe_version "\vaal street.ini", settings async trade, % "filter (" vars.async.mode ")"
	}
	Else If InStr(check, "font_")
	{
		While GetKeyState("LButton", "P")
		{
			If (control = "reset")
				settings.async.fSize := settings.general.fSize
			Else settings.async.fSize += (control = "plus" ? 1 : (control = "minus" && settings.async.fSize > 6 ? -1 : 0))
			GuiControl, Text, % vars.hwnd.async.font_reset, % settings.async.fSize
			Sleep 150
		}
		IniWrite, % settings.async.fSize, % "ini" vars.poe_version "\vaal street.ini", settings async trade, font-size
		LLK_FontDimensions(settings.async.fSize, font_height, font_width), settings.async.fWidth := font_width, settings.async.fHeight := font_height
		LLK_FontDimensions((settings.async.fSize2 := settings.async.fSize - 2), font_height, font_width), settings.async.fWidth2 := font_width, settings.async.fHeight2 := font_height
		For key, HBitmap in vars.pics.async
			DeleteObject(HBitmap)
		vars.pics.async := {}
	}
	Else If cHWND
	{
		LLK_ToolTip("no action")
		Return
	}

	toggle := !toggle, GUI_name := "async" toggle, margin := settings.async.fWidth//2, listings0 := {}, listings := [], mode := vars.async.mode
	Gui, %GUI_name%: New, % "-DPIScale +LastFound -Caption +AlwaysOnTop +ToolWindow +Border +E0x02000000 +E0x00080000 HWNDhwnd_async", LLK-UI: async trade
	Gui, %GUI_name%: Font, % "s" settings.async.fSize " cWhite", % vars.system.font
	Gui, %GUI_name%: Margin, % margin, % margin
	Gui, %GUI_name%: Color, % "Black"

	hwnd_old := vars.hwnd.async.main, vars.hwnd.async := {"main": hwnd_async}
	Gui, %GUI_name%: Add, Text, % "Section BackgroundTrans", % Lang_Trans("global_font") " "
	Gui, %GUI_name%: Add, Text, % "ys x+0 gAsyncTrade Border Center HWNDhwnd w" settings.async.fWidth*2, % "–"
	vars.hwnd.async.font_minus := hwnd, vars.hwnd.help_tooltips["async_font-size"] := hwnd
	Gui, %GUI_name%: Add, Text, % "ys x+" settings.async.fwidth / 4 " gAsyncTrade Border Center HWNDhwnd", % " " settings.async.fSize " "
	vars.hwnd.async.font_reset := hwnd, vars.hwnd.help_tooltips["async_font-size|"] := hwnd
	Gui, %GUI_name%: Add, Text, % "ys wp x+" settings.async.fwidth / 4 " gAsyncTrade Border Center HWNDhwnd w"settings.async.fWidth*2, % "+"
	vars.hwnd.async.font_plus := hwnd, vars.hwnd.help_tooltips["async_font-size||"] := hwnd

	Gui, %GUI_name%: Add, Text, % "ys cAqua Border gAsyncTrade HWNDhwnd", % " " Lang_Trans("global_league_" settings.general.league.1) " " Lang_Trans("global_league_" settings.general.league[vars.poe_version ? 3 : 4]) " "
	vars.hwnd.async.league_select := hwnd

	sorting := settings.async["sorting_" mode]
	If InStr(sorting, "price")
	{
		UpdateConversions()
		If (vars.async.conversions.timestamp.2 = "failed")
			unavailable := 1, sorting := settings.async["sorting_" mode] := ""
	}

	If unavailable
	{
		Gui, %GUI_name%: Font, % "s" settings.async.fSize2
		Gui, %GUI_name%: Add, Text, % "Section xs cFF8000", % Lang_Trans("async_pricefailed")
		Gui, %GUI_name%: Add, Text, % "Section xs cFF8000", % Lang_Trans("async_pricefailed", 2)
		Gui, %GUI_name%: Font, % "s" settings.async.fSize
	}

	Gui, %GUI_name%: Font, bold underline
	Gui, %GUI_name%: Add, Text, % "Section xs", % Lang_Trans("async_listheader", (mode = "buy" ? 2 : 1))
	Gui, %GUI_name%: Font, norm
	Gui, %GUI_name%: Add, Pic, % "ys hp w-1 HWNDhwnd", % "HBitmap:*" vars.pics.global.help
	vars.hwnd.help_tooltips["async_list " vars.async.mode] := hwnd

	If !IsObject(vars.async[league])
		vars.async[league] := {"buy": {}, "sell": {}}

	If (mode = "buy") && vars.async[league][mode].Count()
	{
		Gui, %GUI_name%: Font, % "s" settings.async.fSize2
		Gui, %GUI_name%: Add, Text, % "Section xs", % Lang_Trans("global_filter") . Lang_Trans("global_colon")
		filters := ["m", "m", "m"]
		For index, val in [5, 10, 15]
		{
			color := (settings.async.filter_buy = val "|" filters[index] ? "Lime" : "White")
			Gui, %GUI_name%: Add, Text, % "ys Border HWNDhwnd gAsyncTrade c" color, % " " val . SubStr(Lang_Trans("global_timeunits", 1), 1, 1) " "
			vars.hwnd.async["filter_" val "|" filters[index]] := hwnd
		}
		Gui, %GUI_name%: Add, Text, % "ys Border HWNDhwnd gAsyncTrade c" (settings.async.filter_buy = "all" ? "Lime" : "White"), % " " Lang_Trans("global_all") " "
		vars.hwnd.async["filter_all"] := hwnd
		Gui, %GUI_name%: Font, % "s" settings.async.fSize
	}

	vars.async.dIcon := dIcon := settings.async.fHeight*2 - 4, filter := settings.async["filter_" mode], filter := (filter = "all" ? filter : StrSplit(filter, "|"))
	If !vars.async[league][mode].Count()
		Gui, %GUI_name%: Add, Text, % "Section xs", % Lang_Trans("async_nolist", (mode = "buy" ? 2 : 1))
	Else
	{
		For kLog, object in vars.async[league][mode]
		{
			If object.sold
				Continue
			If (mode = "buy") && (filter != "all")
			{
				elapsed := LLK_TimeElapsed(object.timestamp, filter.2)
				If (elapsed > filter.1)
					Continue
			}
			If InStr(sorting, "price")
				prefix := Format("{:012}", StrReplace(Round(object.prices[object.prices.MaxIndex()].2 * vars.async.conversions[object.prices[object.prices.MaxIndex()].3], 2), "."))
			Else If (sorting = "age")
				prefix := object.prices[object.prices.MaxIndex()].1
			key := (prefix ? prefix " " : "") . object.timestamp " " object.name, listings0[key] := object
		}

		For key, object in listings0
			If !(mode = "buy" && sorting = "age") && RegExMatch(settings.async["sorting_" mode], "price_asc|^age") || !settings.async["sorting_" mode]
				listings.Push(object)
			Else listings.InsertAt(1, object)

		For iListing, object in listings
		{
			name := object.name
			timestamp0 := object.timestamp, elapsed0 := elapsed1 := A_NowUTC, unit0 := unit1 := 1, price := object.prices[object.prices.MaxIndex()]
			timestamp1 := price.1, currency := currency0 := price.3, price := price.2

			EnvSub, elapsed0, timestamp0, minutes
			EnvSub, elapsed1, timestamp1, minutes
			For index, val0 in [0, 1]
				For index, val in [60, 24, 7]
					If (elapsed%val0% >= val)
						elapsed%val0% := Round(elapsed%val0% / val, 1), unit%val0% += 2
					Else Break

			For key, val in vars.async.currencies
				If InStr(currency, key)
				{
					currency := val
					Break
				}
			elapsed0 := StrReplace(elapsed0, ".0"), elapsed1 := StrReplace(elapsed1, ".0")
			elapsed0 := (elapsed0 >= 10 ? Round(elapsed0) : elapsed0), elapsed1 := (elapsed1 >= 10 ? Round(elapsed1) : elapsed1)
			color := (object.rarity = "rare" ? "FFE155" : (object.rarity = "unique" ? "FF8111" : (object.rarity = "magic" ? "7B98FF" : "White")))

			Gui, %GUI_name%: Font, % "bold s" settings.async.fSize2
			Gui, %GUI_name%: Add, Text, % "Section BackgroundTrans gAsyncTrade Right HWNDhwnd xs w" dIcon " h" dIcon, % (InStr(currency0, "greater-") ? "ii" : (InStr(currency0, "perfect-") ? "iii" : ""))
			vars.hwnd.async["sort_price" handle_price] := hwnd, handle_price .= "|"
			ControlGetPos, xIcon, yIcon, wIcon, hIcon,, ahk_id %hwnd%

			If (mode = "sell") && (yIcon + hIcon >= vars.monitor.h) || (mode = "buy") && (yIcon + hIcon >= vars.client.h * 0.7)
			{
				GuiControl, +Hidden, % hwnd
				Break
			}

			Gui, %GUI_name%: Add, Text, % "xp wp BackgroundTrans Right y+-" settings.async.fHeight2 - 3 . (InStr(sorting, "price") ? " cLime" : ""), % price
			Gui, %GUI_name%: Font, % "norm s" settings.async.fSize

			If !vars.pics.async[currency]
				vars.pics.async[currency] := LLK_ImageCache("img\GUI\currency\" currency . vars.poe_version ".png",, dIcon)
			Gui, %GUI_name%: Add, Pic, % "x" xIcon " y" yIcon, % "HBitmap:*" vars.pics.async[currency]

			Gui, %GUI_name%: Add, Progress, % "Disabled yp x+0 BackgroundBlack cRed Vertical Range0-500 HWNDhwnd w" margin*2 " h" dIcon, 0
			vars.hwnd.async["listing_" iListing "_bar"] := hwnd

			If object.itembase
				itembase := (!RegExMatch(object.rarity, "i)magic|unique") || object.rarity = "unique" && settings.async.show_name ? " | " (object.itembase) : "")
			Else itembase := ""
			label := (!settings.async.show_name && object.rarity != "unique" ? LLK_StringCase(object.itembase ? object.itembase : name) : name . itembase)
			Gui, %GUI_name%: Add, Text, % "ys xp+" margin*2 " gAsyncTrade BackgroundTrans HWNDhwnd c" color, % label
			vars.hwnd.async["listing_" iListing] := hwnd

			age_same := (elapsed0 = elapsed1 && unit0 = unit1 ? 1 : 0)
			Gui, %GUI_name%: Add, Text, % "xp gAsyncTrade HWNDhwnd y+0" (sorting = "age" || !sorting && age_same ? " cLime" : ""), % elapsed1 " " Lang_Trans("global_timeunits", unit1 + (elapsed1 != 1 ? 1 : 0))
			vars.hwnd.async["sort_age" handle_age] := hwnd, handle_age .= "|"
			If !age_same
			{
				Gui, %GUI_name%: Add, Text, % "yp x+0", % " / "
				Gui, %GUI_name%: Add, Text, % "yp gAsyncTrade HWNDhwnd x+0" (!sorting ? " cLime" : ""), % elapsed0 " " Lang_Trans("global_timeunits", unit0 + (elapsed0 != 1 ? 1 : 0))
				vars.hwnd.async["sort_agetotal" handle_agetotal] := hwnd, handle_agetotal .= "|"
			}
		}
	}

	xPos := (vars.async.mode = "sell" ? vars.client.x + Round(vars.client.h * 0.615) : vars.client.x + vars.client.w/2 + Floor(vars.client.h/90))
	yPos := (vars.async.mode = "sell" ? vars.client.y : Round(vars.client.h * (vars.poe_version ? 0.12 : 0.164)))
	Gui, %GUI_name%: Show, % "NA AutoSize x" xPos " y" yPos
	LLK_Overlay(hwnd_async, "show",, GUI_name), LLK_Overlay(hwnd_old, "destroy")
}

AsyncTrade2(mode := "")
{
	local
	global vars, settings
	static toggle := 0, existing_item_prev, price_prev
	
	item := vars.omnikey.item, timestamp := A_NowUTC, check := LLK_HasVal(vars.hwnd.async_pricing, mode), control := SubStr(check, InStr(check, "_") + 1)
	league := settings.general.league.1 " " settings.general.league[(vars.poe_version ? 3 : 4)], alt_currency := (vars.poe_version ? "exalted" : "chaos")
	If InStr(check, "setprice")
	{
		Clipboard := "", Clipboard := control
		ClipWait, 0.1
		WinActivate, % "ahk_id " vars.hwnd.poe_client
		WinWaitActive, % "ahk_id " vars.hwnd.poe_client
		SendInput, ^{a}^{v}
		KeyWait, LButton
		If (vars.general.cMouse = mode)
		{
			currency := SubStr(price_prev, InStr(price_prev, " ") + 1), timestamp := A_NowUTC
			If !InStr(check, "alt")
				SendInput, {ENTER}
			Else currency := (vars.poe_version ? "exalted" : "chaos")

			If existing_item_prev
			{
				vars.async[league].sell[existing_item_prev].prices.Push([timestamp, control, currency])
				IniWrite, % """" control " " currency """", % "ini" vars.poe_version "\async trade.ini", % existing_item_prev, % "price " timestamp
				AsyncTrade("sell")
			}
		}
		Else SendInput, {ESC}
		LLK_Overlay(vars.hwnd.async_pricing.main, "destroy"), vars.hwnd.async_pricing := ""
		Return
	}
	Else If (mode = "close")
	{
		LLK_Overlay(vars.hwnd.async_pricing.main, "destroy"), vars.hwnd.async_pricing := ""
		Return
	}
	Else If (mode = "sell" || mode = "buy")
	{
		price := SubStr(Clipboard, InStr(Clipboard, "note:") + 11), price := RTrim(price, " `n`r"), array := StrSplit(price, " ")
		If !RegExMatch(price, "\d") || InStr(price, "offer") || (array.1 = 1 && array.2 = alt_currency)
		{
			LLK_ToolTip(Lang_Trans("global_error"),,,,, "Red")
			Return
		}
		item_text := RTrim(SubStr(Clipboard, 1, InStr(Clipboard, "`n---",, 0) - 1), " `n`r"), , price_prev := price

		If (mode = "sell")
		{
			For key, object in vars.async[league].sell
			{
				If object.sold
					Continue
				price0 := object.prices[object.prices.MaxIndex()].2 " " object.prices[object.prices.MaxIndex()].3
				If InStr(key, item.name) && (item.itembase && item.itembase = object.itembase) && (item.ilvl && item.ilvl = object.ilvl) && (price = price0)
				{
					existing_item := key
					Break
				}
			}
			KeyWait, % vars.omnikey.hotkey, T0.5
			omni1 := ErrorLevel
			If !Blank(vars.omnikey.hotkey2)
				KeyWait, % vars.omnikey.hotkey2, T0.5
			longpress := (omni1 || ErrorLevel ? 1 : 0)
		}
		
		If longpress && existing_item
		{
			LLK_ToolTip(Lang_Trans("async_listing", 2),,,,, "Yellow")
			Return
		}
		Else If longpress || (mode = "buy")
		{
			key := timestamp " " LLK_StringCase(item.name), clip := StrReplace(StrReplace(item_text, "`r", "(r)"), "`n", "(n)")
			object := {"prices": [StrSplit(timestamp " " price, " ")], "itembase": LLK_StringCase(item.itembase), "ilvl": item.ilvl, "rarity": LLK_StringCase(item.rarity), "timestamp": timestamp
				, "name": LLK_StringCase(item.name), "clipboard": clip, "league": league}
			vars.async[league][mode][key] := object
			IniWrite, % "itembase=""" LLK_StringCase(item.itembase) """`nilvl=""" item.ilvl """`nrarity=""" LLK_StringCase(item.rarity) """`ntype=""" mode """`nclipboard=""" clip """`nleague=""" league """`nprice " timestamp "=""" price """", % "ini" vars.poe_version "\async trade.ini", % key
			AsyncTrade(), LLK_ToolTip(Lang_Trans("async_listing"),,,,, "Lime")
			Return
		}

		SendInput, {RButton}
		toggle := !toggle, GUI_name := "async_pricing" toggle, margin := settings.async.fWidth//2
		Gui, %GUI_name%: New, % "-DPIScale +LastFound -Caption +AlwaysOnTop +ToolWindow +Border +E0x02000000 +E0x00080000 HWNDhwnd_pricing", LLK-UI: async pricing
		Gui, %GUI_name%: Font, % "bold underline s" settings.async.fSize " cWhite", % vars.system.font
		Gui, %GUI_name%: Margin, % margin, % margin
		Gui, %GUI_name%: Color, % "Black"

		hwnd_old := vars.hwnd.async_pricing.main, vars.hwnd.async_pricing := {"main": hwnd_pricing}, dIcon := vars.async.dIcon
		If existing_item
		{
			item := vars.async[league].sell[existing_item], count := item.prices.Count(), existing_item_prev := existing_item
			If (item.prices.1.3 != item.prices[item.prices.MaxIndex()].3)
				UpdateConversions()
			If (item.prices.1.3 = item.prices[item.prices.MaxIndex()].3)
				price_diff := Round((item.prices[item.prices.MaxIndex()].2 / item.prices.1.2) * 100 - 100, 1)
			Else If (converted1 := vars.async.conversions[item.prices.1.3]) && (converted2 := vars.async.conversions[item.prices[item.prices.MaxIndex()].3])
				price_diff := Round(((item.prices[item.prices.MaxIndex()].2 * converted2) / (item.prices.1.2 * converted1)) * 100 - 100, 1)
			Else price_diff := ""
			Gui, %GUI_name%: Add, Text, % "Section", % Lang_Trans("async_history") . (count > 1 ? (price_diff ? " " price_diff "%" : "") : "")
			Gui, %GUI_name%: Font, % "norm s" settings.async.fSize2
			For iPrice, array in item.prices
			{
				elapsed := A_NowUTC, unit := 1
				EnvSub, elapsed, % array.1, minutes
				For index, val in [60, 24, 7]
					If (elapsed >= val)
						elapsed := Round(elapsed / val, 1), unit += 2
					Else Break
				elapsed := StrReplace((elapsed >= 10 ? Round(elapsed) : elapsed), ".0")
				Gui, %GUI_name%: Add, Text, % "Section Center " (iPrice = 1 ? "xs" : "ys") " w" dIcon, % elapsed . SubStr(Lang_Trans("global_timeunits", unit + (elapsed != 1 ? 1 : 0)), 1, 1)

				Gui, %GUI_name%: Font, % "bold"
				Gui, %GUI_name%: Add, Text, % "xs y+0 BackgroundTrans Right HWNDhwnd w" dIcon " h" dIcon, % (InStr(array.3, "greater-") ? "ii" : (InStr(array.3, "perfect-") ? "iii" : ""))
				ControlGetPos, xIcon, yIcon, wIcon, hIcon,, ahk_id %hwnd%
				Gui, %GUI_name%: Add, Text, % "xp wp BackgroundTrans Right y+-" settings.async.fHeight2 - 3, % array.2
				Gui, %GUI_name%: Font, % "norm"

				currency := array.3
				For key, val in vars.async.currencies
					If InStr(currency, key)
					{
						currency := val
						Break
					}

				If !vars.pics.async[currency]
					vars.pics.async[currency] := LLK_ImageCache("img\GUI\currency\" currency . vars.poe_version ".png",, dIcon)
				Gui, %GUI_name%: Add, Pic, % "x" xIcon " y" yIcon, % "HBitmap:*" vars.pics.async[currency]
			}
		}
		Else existing_item_prev := ""
		Gui, %GUI_name%: Font, % "bold underline s" settings.async.fSize
		Gui, %GUI_name%: Add, Text, % "Section" (!existing_item ? "" : " x" margin " y+" margin), % Lang_Trans("async_adjust")
		Gui, %GUI_name%: Font, norm

		price0 := StrSplit(price, " "), minchange := settings.async.minchange, currency := price0.2, vars.async.button1 := {}
		Gui, %GUI_name%: Font, % "s" settings.async.fSize2
		For outer in [1, 2]
		{
			loop := (outer = 1 ? price0.1 : Round(price0.1 * vars.async.conversions[currency])), options := []
			If (loop = 1) || (outer = 2) && !offer_alt
			{
				If (price0.2 != alt_currency)
				{
					If (loop = 1)
						UpdateConversions()
					offer_alt := 1
				}
				Continue
			}

			If offer_alt
				currency := alt_currency

			If (outer = 2) && (vars.async.conversions.timestamp.2 = "failed")
			{
				Gui, %GUI_name%: Add, Text, % "Section xs HWNDhwnd cFF8000", % Lang_Trans("async_pricefailed")
				Gui, %GUI_name%: Add, Text, % "Section xs cFF8000", % Lang_Trans("async_pricefailed", 3)
				If !options.Count()
				{
					ControlGetPos, x, y, w, h,, ahk_id %hwnd%
					vars.async.button1 := {"x": x, "y": y}
				}
				Break
			}

			For key, val in vars.async.currencies
				If InStr(currency, key)
				{
					currency_icon := val
					Break
				}
			If !vars.pics.async[currency_icon]
				vars.pics.async[currency_icon] := LLK_ImageCache("img\GUI\currency\" currency_icon . vars.poe_version ".png",, dIcon)

			Loop, % loop
				If !options.Count()
				{
					price_diff := 100 * (1 - ((loop - A_Index) / loop)), price_diff1 := 100 * (1 - ((loop - A_Index + 1) / loop))
					If (price_diff >= minchange)
					{
						If !price_diff1 || (Abs(minchange - price_diff) < Abs(minchange - price_diff1))
							options[A_Index] := loop - A_Index, last_diff := price_diff
						Else options[A_Index - 1] := loop - A_Index + 1, last_diff := price_diff1

						If (last_diff >= 2*minchange)
							UpdateConversions(), offer_alt := (price0.1 < price0.1 * vars.async.conversions[currency] ? 1 : 0)
						last_diff := last_diff // 5 * 5
					}
				}
				Else If (options.Count() = 5) || (A_Index = loop)
					Break
				Else 
				{
					price_diff := 100 * (1 - ((loop - A_Index) / loop)), price_diff1 := 100 * (1 - ((loop - A_Index + 1) / loop))
					If (price_diff >= last_diff + 5)
					{
						If (Abs(last_diff + 5 - price_diff) <= Abs(last_diff + 5 - price_diff1)) || options[A_Index - 1]
							options[A_Index] := loop - A_Index, last_diff0 := price_diff // 5 * 5
						Else options[A_Index - 1] := loop - A_Index + 1, last_diff0 := price_diff1 // 5 * 5
						last_diff := (last_diff0 = last_diff ? last_diff0 + 5 : last_diff0)
					}
				}

			For index, val in options
			{
				Gui, %GUI_name%: Add, Text, % (A_Index = 1 ? "Section xs" : "ys") " Border Center gAsyncTrade2 HWNDhwnd w" dIcon - 2 " h" dIcon - 2, % val "`n" Round(100 * (1 - val / loop)) "%"
				vars.hwnd.async_pricing["setprice" (outer = 2 ? "alt" : "") "_" val] := hwnd
				If (A_Index = 1 && outer = 1) || (A_Index = 1 && outer = 2 && !vars.async.button1.Count())
				{
					ControlGetPos, x, y, w, h,, ahk_id %hwnd%
					vars.async.button1 := {"x": x, "y": y}
				}
			}
			If options.Count() && offer_alt
			{
				Gui, %GUI_name%: Font, % "bold"
				Gui, %GUI_name%: Add, Text, % "ys x+0 Right BackgroundTrans w" dIcon " h" dIcon, % (InStr(currency, "greater-") ? "ii" : (InStr(currency, "perfect-") ? "iii" : ""))
				Gui, %GUI_name%: Add, Pic, % "xp yp wp hp", % "HBitmap:*" vars.pics.async[currency_icon]
				Gui, %GUI_name%: Font, % "norm"
			}
		}

		Gui, %GUI_name%: Show, % "NA x10000 y10000"
		WinGetPos, x, y, w, h, ahk_id %hwnd_pricing%
		button1 := vars.async.button1, xPos := vars.general.xMouse - (button1.x + dIcon//2), yPos := vars.general.yMouse - (button1.y + dIcon//2), Gui_CheckBounds(xPos, yPos, w, h)
		Gui, %GUI_name%: Show, % "NA x" xPos " y" yPos
		LLK_Overlay(hwnd_pricing, "show",, GUI_name), LLK_Overlay(hwnd_old, "destroy")
	}
}

Exchange(cHWND := "", hotkey := "")
{
	local
	global vars, settings
	static toggle := 0, fSize, wEdits, hEdits, wait, wHighCurrLow, stats, wRatio

	If wait
		Return

	league := settings.general.league
	If cHWND && InStr("open, close", cHWND) && WinExist("ahk_id " vars.hwnd.exchange.main)
	{
		LLK_Overlay(vars.hwnd.exchange.main, "destroy")
		vars.hwnd.exchange := "", vars.exchange.selected_currency := ""
		Return
	}
	Else If (cHWND = "hide")
	{
		WinSet, TransColor, Purple 0, % "ahk_id " (hwnd := vars.hwnd.exchange.main)
		WinActivate, % "ahk_id " vars.hwnd.poe_client
		vars.hwnd.exchange.main := ""
		KeyWait, ALT
		WinWaitActive, % "ahk_id " vars.hwnd.poe_client
		vars.hwnd.exchange.main := hwnd
		WinSet, TransColor, Purple 255, % "ahk_id " vars.hwnd.exchange.main
		Return
	}
	Else If InStr(cHWND, "hotkey")
	{
		selection := LLK_HasVal(vars.hwnd.exchange, vars.general.cMouse)
		If !selection || !InStr("edit1, edit2, ratio", selection)
			Return

		step := GetKeyState("Shift", "P") ? 10 : 1
		If InStr(selection, "ratio")
		{
			vars.exchange.multiplier += (hotkey = "WheelUp" ? step : -step), vars.exchange.multiplier := (vars.exchange.multiplier < 1 ? 1 : vars.exchange.multiplier)
			GuiControl, -g, % vars.hwnd.exchange.edit1
			GuiControl, -g, % vars.hwnd.exchange.edit2
			GuiControl,, % vars.hwnd.exchange.edit1, % vars.exchange.multiplier * vars.exchange.amount1
			GuiControl,, % vars.hwnd.exchange.edit2, % vars.exchange.multiplier * vars.exchange.amount2
			GuiControl, +gExchange, % vars.hwnd.exchange.edit1
			GuiControl, +gExchange, % vars.hwnd.exchange.edit2
		}
		Else
		{
			input := Round(LLK_ControlGet(vars.hwnd.exchange[selection]) + (hotkey = "WheelUp" ? step : -step)), input := (input < 1 ? 1 : input)
			GuiControl,, % vars.hwnd.exchange[selection], % input
		}
		Return
	}

	check := LLK_HasVal(vars.hwnd.exchange, cHWND), control := SubStr(check, InStr(check, "_") + 1)
	If InStr(check, "edit")
	{
		edit1 := StrReplace(LLK_ControlGet(vars.hwnd.exchange.edit1), ",", "."), edit2 := StrReplace(LLK_ControlGet(vars.hwnd.exchange.edit2), ",", ".")
		If (SubStr(%check%, 0) = ".") || !IsNumber(%check%)
			Return
		vars.exchange.multiplier := 1

		If InStr(%check%, ".")
		{
			count := 1, check2 := (check = "edit1" ? "edit2" : "edit1")
			While (Round(count * %check%) != (count * %check%))
				If (count = 101)
					Break
				Else count += 1
			If (count = 101)
			{
				WinGetPos, xEdit, yEdit, wEdit, hEdit, % "ahk_id " vars.hwnd.exchange[check]
				LLK_ToolTip(Lang_Trans("global_errorname", 2), 2, xEdit + wEdit/2, yEdit + hEdit,, "Red",,,, 1)
				Return
			}
			GuiControl, -g, % vars.hwnd.exchange.edit1
			GuiControl, -g, % vars.hwnd.exchange.edit2
			GuiControl,, % vars.hwnd.exchange[check], % (%check% := Round(count * %check%))
			GuiControl,, % vars.hwnd.exchange[(check = "edit1" ? "edit2" : "edit1")], % (%check2% := count)
			GuiControl, +gExchange, % vars.hwnd.exchange.edit1
			GuiControl, +gExchange, % vars.hwnd.exchange.edit2
		}

		If (lock := vars.exchange.ratio_lock)
		{
			Loop 2
				GuiControl, -g, % vars.hwnd.exchange["edit" A_Index]
			GuiControl,, % vars.hwnd.exchange["edit" (InStr(check, 1) ? 2 : 1)], % Round((InStr(check, 1) ? edit1 / vars.exchange.ratio : edit2 * vars.exchange.ratio))
			Loop 2
				GuiControl, +gExchange, % vars.hwnd.exchange["edit" A_Index]
			edit1 := LLK_ControlGet(vars.hwnd.exchange.edit1), edit2 := LLK_ControlGet(vars.hwnd.exchange.edit2)
		}
		vars.exchange.amount1 := edit1, vars.exchange.amount2 := edit2, vars.exchange.multiplier := 1

		value1 := Round(edit1 / Min(edit1, edit2), Mod(edit1, Min(edit1, edit2)) ? 2 : 0)
		value2 := Round(edit2 / Min(edit1, edit2), Mod(edit2, Min(edit1, edit2)) ? 2 : 0)
		GuiControl, Text, % vars.hwnd.exchange["ratio_text" (lock ? "2" : "")], % value1 " : " value2
		GuiControl, % "+c" (edit1 / Min(edit1, edit2) != value1 || edit2 / Min(edit1, edit2) != value2 ? "FF8000" : "White"), % vars.hwnd.exchange["ratio_text" (lock ? "2" : "")]
		Return
	}
	Else If (check = "league_select")
	{
		KeyWait, LButton
		Settings_menu("general")
		Return
	}
	Else If InStr(check, "day_")
	{
		ControlFocus,, % "ahk_id " vars.hwnd.exchange.ratio_text
		KeyWait, LButton
		date := SubStr(control, InStr(control, "_") + 1), index := SubStr(control, 1, InStr(control, "_") - 1)

		If LLK_Progress(vars.hwnd.exchange["day_" index "_bar"], "RButton")
		{
			For index0, object in vars.exchange.transactions[date]
			{
				timestamp := date ", " object.time, DeleteObject(vars.pics.exchange_trades[timestamp]), vars.pics.exchange_trades.Delete(timestamp)
				IniDelete, % "ini" vars.poe_version "\vaal street log.ini", % timestamp
				FileDelete, % "img\GUI\vaal street" vars.poe_version "\" timestamp ".jpg"
			}
			vars.exchange.transactions.Delete(date), vars.exchange.date := (vars.exchange.date = index ? "" : vars.exchange.date)

			If vars.pics.exchange_trades.graph_week
				DeleteObject(vars.pics.exchange_trades.graph_week), vars.pics.exchange_trades.graph_week := ""
		}
		Else If (vars.system.click = 2)
			Return
		Else vars.exchange.date := index

		If vars.pics.exchange_trades.graph_day
			DeleteObject(vars.pics.exchange_trades.graph_day), vars.pics.exchange_trades.graph_day := ""
	}
	Else If InStr(check, "trade_")
	{
		ControlFocus,, % "ahk_id " vars.hwnd.exchange.ratio_text
		If LLK_Progress(vars.hwnd.exchange[check "_bar"], "RButton")
		{
			FileDelete, % "img\GUI\vaal street" vars.poe_version "\" control ".jpg"
			date := SubStr(control, 1, InStr(control, ",") - 1), time := SubStr(control, InStr(control, ",") + 2)
			DeleteObject(vars.pics.exchange_trades[control]), vars.pics.exchange_trades.Delete(control)
			vars.exchange.transactions[date].RemoveAt(LLK_HasVal(vars.exchange.transactions[date], time,,,, 1))
			If !vars.exchange.transactions[date].Count()
				vars.exchange.transactions.Delete(date)
			IniDelete, % "ini" vars.poe_version "\vaal street log.ini", % control

			If vars.pics.exchange_trades.graph_day
				DeleteObject(vars.pics.exchange_trades.graph_day), vars.pics.exchange_trades.graph_day := ""
			If vars.pics.exchange_trades.graph_week
				DeleteObject(vars.pics.exchange_trades.graph_week), vars.pics.exchange_trades.graph_week := ""
		}
		Else Return
	}
	Else If RegexMatch(check, "i)(chaos|exalt)_div")
	{
		IniWrite, % (input := settings.exchange[check] := LLK_ControlGet(cHWND)), % "ini" vars.poe_version "\vaal street.ini", settings, % StrReplace(check, "_", "-") " ratio"
		If !input && InStr(check, SubStr(vars.exchange.selected_currency, 1, -1))
		{
			GuiControl,, % vars.hwnd.exchange[vars.exchange.selected_currency "_bar"], 0
			vars.exchange.selected_currency := ""
		}
		Return
	}
	Else If (check = "ratio_text" || cHWND = "lock")
	{
		If (check = "ratio_text") && !(vars.exchange.amount1 * vars.exchange.amount2)
		{
			LLK_ToolTip(Lang_Trans("global_errorname"),,,,, "Red")
			Return
		}
		lock := vars.exchange.ratio_lock := !vars.exchange.ratio_lock
		GuiControl, % "+Background" (lock ? "Lime" : "Black"), % vars.hwnd.exchange.ratio
		GuiControl, % (lock ? "-" : "+") "Hidden", % vars.hwnd.exchange.ratio2

		edit1 := vars.exchange.amount1, edit2 := vars.exchange.amount2
		value1 := Round(edit1 / Min(edit1, edit2), Mod(edit1, Min(edit1, edit2)) ? 2 : 0)
		value2 := Round(edit2 / Min(edit1, edit2), Mod(edit2, Min(edit1, edit2)) ? 2 : 0)
		vars.exchange.ratio := value1 / value2
		GuiControl, % "Text", % vars.hwnd.exchange.ratio_text2, % value1 " : " value2
		GuiControl, % (lock ? "-" : "+") "Hidden", % vars.hwnd.exchange.ratio_text2
		GuiControl, % "+c" (edit1 / Min(edit1, edit2) != value1 || edit2 / Min(edit1, edit2) != value2 ? "FF8000" : "White"), % vars.hwnd.exchange.ratio_text2

		If !lock
			GuiControl,, % vars.hwnd.exchange.edit1, % LLK_ControlGet(vars.hwnd.exchange.edit1)
		Return
	}
	Else If RegExMatch(check, "i)chaos|divine|exalt")
	{
		If RegexMatch(check, "i)chaos|exalt")
		{
			UpdateConversions()
			If (vars.async.conversions.timestamp.2 = "failed")
			{
				GuiControl, -Hidden, % vars.hwnd.exchange.chaos_div
				If vars.poe_version
					GuiControl, -Hidden, % vars.hwnd.exchange.exalt_div
			}
		}
		If InStr(check, "chaos") && !settings.exchange.chaos_div || InStr(check, "exalt") && !settings.exchange.exalt_div
		{
			WinGetPos, x, y, w, h, % "ahk_id " vars.hwnd.exchange[(InStr(check, "chaos") ? "chaos" : "exalt") "_div"]
			LLK_ToolTip("<- " Lang_Trans("exchange_chaos_div"), 1.5, x + w, y,, "Red")
			Return
		}
		selection := vars.exchange.selected_currency := (vars.exchange.selected_currency = check) ? "" : check
		For key, val in vars.hwnd.exchange
			If InStr(key, "_bar")
				GuiControl,, % val, % (selection && InStr(key, selection) ? 100 : 0)
		Return
	}
	Else If check
	{
		LLK_ToolTip("no action")
		Return
	}

	wait := 1
	toggle := !toggle, GUI_name := "exchange" toggle, wBoxes := vars.client.h * 0.069, hBoxes := vars.client.h/40, gBoxes := vars.client.h * 0.1
	xOrder := vars.client.h * 0.0375, wOrder := vars.client.h * 0.1625, hOrder := xOrder, wUI := vars.client.h * 0.725, hIcons := Ceil(vars.client.h * 0.03611111)
	While Mod(hIcons, 2)
		hIcons += 1
	Gui, %GUI_name%: New, % "-DPIScale +LastFound -Caption +AlwaysOnTop +ToolWindow +E0x02000000 +E0x00080000 HWNDhwnd_exchange", LLK-UI: vaal street
	Gui, %GUI_name%: Font, % "s" settings.exchange.fSize + 2 " cWhite", % vars.system.font
	Gui, %GUI_name%: Margin, 0, 0
	Gui, %GUI_name%: Color, % "Purple"
	WinSet, TransColor, Purple

	hwnd_old := vars.hwnd.exchange.main, transactions := vars.exchange.transactions
	vars.hwnd.exchange := {"main": hwnd_exchange}, wUI2 := Round(0.95 * (vars.client.w / 2 - vars.client.h * 0.3625))
	If (fSize != settings.exchange.fSize)
	{
		fSize := settings.exchange.fSize
		If vars.pics.exchange_trades.graph_day
			DeleteObject(vars.pics.exchange_trades.graph_day), vars.pics.exchange_trades.graph_day := ""
		If vars.pics.exchange_trades.graph_week
			DeleteObject(vars.pics.exchange_trades.graph_week), vars.pics.exchange_trades.graph_week := ""

		LLK_PanelDimensions([Lang_Trans("m_clone_performance", 3), Lang_Trans("m_clone_performance", 5), Lang_Trans("global_last")], fSize, wHighCurrLow, hHighCurrLow)
		LLK_PanelDimensions(["7777.77 : 1"], fSize + 2, wRatio, hRatio)
		Gui, %GUI_name%: Add, Edit, % "x0 y0 Hidden R1 Limit Center cBlack HWNDhwnd", 7777
		ControlGetPos,,, wEdits, hEdits,, ahk_id %hwnd%
	}

	If !vars.pics.exchange.chaos
		vars.pics.exchange.chaos := LLK_ImageCache("img\GUI\currency\chaos" vars.poe_version ".png", hIcons - 2), vars.pics.exchange.divine := LLK_ImageCache("img\GUI\currency\divine" vars.poe_version ".png", hIcons - 2)
		, vars.pics.exchange.exalt := LLK_ImageCache("img\GUI\currency\exalted" vars.poe_version ".png", hIcons - 2)

	dates := []
	For date, object in vars.exchange.transactions
	{
		dates.Push({"date": date, "object": object})
		If (dates.Count() > 7)
			dates.RemoveAt(1)
	}

	wDays := Round(wUI2 / 7), wUI2 := wDays * 7 - 6
	If !vars.pixels.inventory && dates.Count()
	{
		date_selection := (vars.exchange.date ? vars.exchange.date : dates.MaxIndex())
		Gui, %GUI_name%: Font, % "s" settings.exchange.fSize
		If (dates.Count() < 7)
		{
			Gui, %GUI_name%: Add, Text, % "Section x0 y0 BackgroundTrans Border w" (7 - dates.Count()) * wDays - (7 - dates.Count() - 1)
			Gui, %GUI_name%: Add, Progress, % "Disabled xp yp wp hp BackgroundBlack", 0
		}

		For index, day in dates
		{
			color := (date_selection = index ? " cAqua": ""), date := LLK_StringCase(LLK_FormatTime(StrReplace(day.date, "-"), "MMM d")), selected_date := (date_selection = index ? date : selected_date)
			Gui, %GUI_name%: Add, Text, % (index = 1 && dates.Count() = 7 ? "Section x0 y0" : "ys x+-1") " BackgroundTrans -Wrap Center Border gExchange HWNDhwnd w" wDays " h" settings.exchange.fHeight . color, % date
			Gui, %GUI_name%: Add, Progress, % "Disabled xp yp wp hp BackgroundBlack cRed Vertical Border Range0-500 HWNDhwnd1", 0
			vars.hwnd.exchange["day_" index "_" day.date] := hwnd, vars.hwnd.exchange["day_" index "_bar"] := hwnd1
		}

		Gui, %GUI_name%: Add, Pic, % "ys x+-1 Border BackgroundTrans hp-2 w-1 HWNDhwnd", % "HBitmap:*" vars.pics.global.help
		Gui %GUI_name%: Add, Progress, % "Disabled xp yp wp hp BackgroundBlack HWNDhwnd", 0
		vars.hwnd.help_tooltips["exchange_logs"] := hwnd, hCustom := Round(settings.exchange.fHeight * 2)

		If IsObject(dates[date_selection])
		{
			trades := [], day := dates[date_selection], graph := [], balance := min := max := 0
			For index1, transaction in day.object
			{
				trades.InsertAt(1, day.date ", " transaction.time), currency := SubStr(transaction.type, 1, -1)
				amount := transaction.amount * (InStr(transaction.type, "1") ? 1 : -1), graph.Push(amount)
				balance += amount, min := (balance < min ? balance : min), max := (balance > max ? balance : max)
			}
			balance := (balance >= 0 ? "+" : "") . Round(balance, 1), min := (min >= 0 ? "+" : "") . Round(min, 1), max := max := (max >= 0 ? "+" : "") . Round(max, 1)

			If !settings.exchange.graphs
			{
				Gui, %GUI_name%: Add, Text, % "Section xs y+0 BackgroundTrans Border Center w" wUI2, % Lang_Trans("global_trade", 2) . Lang_Trans("global_colon") " " trades.Count() ", " Lang_Trans("m_clone_performance", 5)
				. Lang_Trans("global_colon") " " max ", " Lang_Trans("global_last") . Lang_Trans("global_colon") " " balance ", " Lang_Trans("m_clone_performance", 3) Lang_Trans("global_colon") " " min
				Gui, %GUI_name%: Add, Progress, % "Disabled xp yp wp hp BackgroundBlack", 0
			}

			For iTrades, timestamp in trades
				If FileExist(file := "img\GUI\vaal street" vars.poe_version "\" timestamp ".jpg")
				{
					If !vars.pics.exchange_trades[timestamp]
						vars.pics.exchange_trades[timestamp] := LLK_ImageCache(file, wUI2 - 2)
					Gui, %GUI_name%: Add, Pic, % "xs x0 y+" (!added && !settings.exchange.graphs ? 0 : -1) " BackgroundTrans Border HWNDhwnd gExchange", % "HBitmap:*" vars.pics.exchange_trades[timestamp]
					Gui, %GUI_name%: Add, Progress, % "Disabled x+-1 yp+1 hp-2 w" settings.exchange.fWidth " BackgroundPurple cRed Range0-500 Vertical HWNDhwnd1", 0
					vars.hwnd.exchange["trade_" timestamp] := hwnd, vars.hwnd.exchange["trade_" timestamp "_bar"] := hwnd1, added := 1
					ControlGetPos, xLast, yLast, wLast, hLast,, ahk_id %hwnd1%
					If (yLast + hLast*2 >= vars.client.h * 0.79)
						Break
				}
		}
	}

	xCalc := (transactions.Count() ? wUI/2 + wUI2 - hIcons * (vars.poe_version ? 3 : 2) : wUI/2 - hIcons * (vars.poe_version ? 3 : 2)) - wRatio/2 - wEdits, vars.exchange.wTooltip := wUI
	Gui, %GUI_name%: Add, Pic, % "Section x" xCalc " y0 BackgroundTrans Border HWNDhwnd gExchange", % "HBitmap:*" vars.pics.exchange.chaos
	Gui, %GUI_name%: Add, Progress, % "Disabled xp yp wp hp BackgroundBlack cGreen HWNDhwnd1", 0
	Gui, %GUI_name%: Add, Pic, % "ys BackgroundTrans Border HWNDhwnd2 gExchange", % "HBitmap:*" vars.pics.exchange.divine
	Gui, %GUI_name%: Add, Progress, % "Disabled xp yp wp hp BackgroundBlack cGreen HWNDhwnd3", 0
	vars.hwnd.exchange.chaos1 := hwnd, vars.hwnd.exchange.chaos1_bar := hwnd1, vars.hwnd.exchange.divine1 := hwnd2, vars.hwnd.exchange.divine1_bar := hwnd3
	vars.hwnd.help_tooltips["exchange_currency icons"] := hwnd1, vars.hwnd.help_tooltips["exchange_currency icons|"] := hwnd3
	If vars.poe_version
	{
		Gui, %GUI_name%: Add, Pic, % "ys BackgroundTrans Border HWNDhwnd4 gExchange", % "HBitmap:*" vars.pics.exchange.exalt
		Gui, %GUI_name%: Add, Progress, % "Disabled xp yp wp hp BackgroundBlack cGreen HWNDhwnd5", 0
		vars.hwnd.exchange.exalt1 := hwnd4, vars.hwnd.exchange.exalt1_bar := vars.hwnd.help_tooltips["exchange_currency icons||"] := hwnd5
	}

	Gui, %GUI_name%: Font, % "s" settings.exchange.fSize + 2
	Gui, %GUI_name%: Add, Edit, % "ys R1 Limit Center cBlack HWNDhwnd gExchange w" wEdits, 0
	Gui, %GUI_name%: Add, Text, % "ys hp 0x200 Center Border gExchange HWNDhwnd1 BackgroundTrans cFF8000 w" wRatio, % "0 : 0"
	Gui, %GUI_name%: Add, Progress, % "Disabled xp yp wp hp Border HWNDhwnd3 BackgroundBlack cBlack", 100
	Gui, %GUI_name%: Font, % "s" settings.exchange.fSize - 2
	Gui, %GUI_name%: Add, Text, % "xp y+-1 wp hp 0x200 Center cLime Border BackgroundTrans gExchange HWNDhwnd6", % Lang_Trans("global_league_" league.1) " " Lang_Trans("global_league_" league[(vars.poe_version ? 3 : 4)])
	Gui, %GUI_name%: Add, Progress, % "Disabled xp yp wp hp BackgroundBlack", 0
	Gui, %GUI_name%: Font, % "s" settings.exchange.fSize + 2
	Gui, %GUI_name%: Add, Text, % "xp y+-1 wp hp Hidden 0x200 Center Border HWNDhwnd4 BackgroundTrans"
	Gui, %GUI_name%: Add, Progress, % "Disabled xp yp wp hp Hidden HWNDhwnd5 BackgroundBlack cBlack", 100
	Gui, %GUI_name%: Add, Edit, % "ys R1 Limit Center cBlack HWNDhwnd2 gExchange w" wEdits, 0
	vars.hwnd.exchange.edit1 := hwnd, vars.hwnd.exchange.ratio_text := hwnd1, vars.hwnd.exchange.ratio := hwnd3, vars.hwnd.exchange.edit2 := hwnd2
	vars.hwnd.exchange.ratio_text2 := hwnd4, vars.hwnd.exchange.ratio2 := hwnd5, vars.hwnd.exchange.league_select := hwnd6
	vars.hwnd.help_tooltips["exchange_edit fields"] := hwnd, vars.hwnd.help_tooltips["exchange_edit fields|"] := hwnd2, vars.hwnd.help_tooltips["exchange_ratio"] := hwnd3, vars.hwnd.help_tooltips["exchange_ratio 2"] := hwnd5

	If vars.poe_version
	{
		Gui, %GUI_name%: Add, Pic, % "ys BackgroundTrans Border HWNDhwnd4 gExchange", % "HBitmap:*" vars.pics.exchange.exalt
		Gui, %GUI_name%: Add, Progress, % "Disabled xp yp wp hp BackgroundBlack cGreen HWNDhwnd5", 0
		vars.hwnd.exchange.exalt2 := hwnd4, vars.hwnd.exchange.exalt2_bar := vars.hwnd.help_tooltips["exchange_currency icons|||"] := hwnd5
	}
	Gui, %GUI_name%: Add, Pic, % "ys BackgroundTrans Border HWNDhwnd gExchange", % "HBitmap:*" vars.pics.exchange.divine
	Gui, %GUI_name%: Add, Progress, % "Disabled xp yp wp hp BackgroundBlack cFF8000 HWNDhwnd1", 0
	Gui, %GUI_name%: Add, Pic, % "ys BackgroundTrans Border HWNDhwnd2 gExchange", % "HBitmap:*" vars.pics.exchange.chaos
	Gui, %GUI_name%: Add, Progress, % "Disabled xp yp wp hp BackgroundBlack cFF8000 HWNDhwnd3", 0
	vars.hwnd.exchange.chaos2 := hwnd2, vars.hwnd.exchange.chaos2_bar := hwnd3, vars.hwnd.exchange.divine2 := hwnd, vars.hwnd.exchange.divine2_bar := hwnd1
	vars.hwnd.help_tooltips["exchange_currency icons||||"] := hwnd1, vars.hwnd.help_tooltips["exchange_currency icons|||||"] := hwnd3

	ControlGetPos, xChaos1, yChaos1, wChaos1, hChaos1,, % "ahk_id " vars.hwnd.exchange.chaos1
	Gui, %GUI_name%: Font, % "s" settings.exchange.fSize - 2
	hidden := (vars.async.conversions.timestamp.2 = "failed" && RegExMatch(vars.exchange.selected_currency, "i)exalt|chaos") ? "" : " Hidden")
	Gui, %GUI_name%: Add, Edit, % "x" xChaos1 " y" yChaos1 + hChaos1 " Number r1 gExchange HWNDhwnd cBlack Center w" hIcons * 1.5 . hidden, % settings.exchange.chaos_div
	vars.hwnd.help_tooltips["exchange_chaos-div"] := vars.hwnd.exchange.chaos_div := hwnd
	If vars.poe_version
	{
		Gui, %GUI_name%: Add, Edit, % "x+0 yp Number r1 gExchange HWNDhwnd1 cBlack Center w" hIcons * 1.5 . hidden, % settings.exchange.exalt_div
		vars.hwnd.help_tooltips["exchange_exalt-div"] := vars.hwnd.exchange.exalt_div := hwnd1
	}
	Gui, %GUI_name%: Font, % "s" settings.exchange.fSize
	

	Gui, %GUI_name%: Add, Text, % "Section Border Hidden x" (transactions.Count() ? wUI2 : 0) + vars.client.h * 0.2444 " y" vars.client.h * 0.1069 " HWNDhwnd w" wBoxes " h" hBoxes
	Gui, %GUI_name%: Add, Text, % "xp-1 yp-1 wp+2 hp+2 Border Hidden"
	Gui, %GUI_name%: Add, Text, % "ys x+" gBoxes - 1 " Border Hidden HWNDhwnd1 h" hBoxes " w" wBoxes
	Gui, %GUI_name%: Add, Text, % "xp-1 yp-1 wp+2 hp+2 Border Hidden"
	Gui, %GUI_name%: Add, Text, % "Section x" (transactions.Count() ? wUI2 : 0) + vars.client.h * 0.2819 " y" vars.client.h * 0.176 " w" wOrder " h" hOrder " Border Hidden HWNDhwnd2"
	Gui, %GUI_name%: Add, Text, % "xp-1 yp-1 wp+2 hp+2 Border Hidden"
	vars.hwnd.exchange.amount1 := hwnd, vars.hwnd.exchange.amount2 := hwnd1, vars.hwnd.exchange.order := hwnd2

	If !vars.pixels.inventory && dates.Count() && settings.exchange.graphs
	{
		trades := [], day := dates[date_selection], graph := [], balance := min := max := 0
		For index1, transaction in day.object
		{
			trades.InsertAt(1, day.date ", " transaction.time), currency := SubStr(transaction.type, 1, -1)
			amount := transaction.amount * (InStr(transaction.type, "1") ? 1 : -1), graph.Push(amount)
			balance += amount, min := (balance < min ? balance : min), max := (balance > max ? balance : max)
		}
		balance := (balance >= 0 ? "+" : "") . Round(balance, 1), min := (min >= 0 ? "+" : "") . Round(min, 1), max := max := (max >= 0 ? "+" : "") . Round(max, 1)

		Gui, %GUI_name%: Add, Text, % "Section Border BackgroundTrans x" wUI2 + wUI " y0 w" wUI2, % " " selected_date . Lang_Trans("global_colon")
		Gui, %GUI_name%: Add, Progress, % "Disabled xp yp wp hp BackgroundBlack", 0

		LLK_PanelDimensions(["+77777.0"], settings.exchange.fSize, wHighCurrLow2, hHighCurrLow2), w := wUI2 - wHighCurrLow - wHighCurrLow2
		If !vars.pics.exchange_trades.graph_day
			vars.pics.exchange_trades.graph_day := Gui_CreateGraph(w, hCustom * 4 - 5, graph, "008000")

		Gui, %GUI_name%: Add, Pic, % "Section xs y+-1 BackgroundTrans Border HWNDhwnd", % "HBitmap:*" vars.pics.exchange_trades.graph_day
		Gui, %GUI_name%: Add, Text, % "Section ys x+-1 BackgroundTrans Border 0x200 Center w" wHighCurrLow + wHighCurrLow2 - 1 " h" hCustom, % Lang_Trans("global_trade", 2) . Lang_Trans("global_colon") " " trades.Count()
		Gui, %GUI_name%: Add, Text, % "Section xs y+-1 BackgroundTrans Border 0x200 Center w" wHighCurrLow " h" hCustom, % Lang_Trans("m_clone_performance", 5)
		Gui, %GUI_name%: Add, Text, % "ys x+-1 BackgroundTrans Border 0x200 Right w" wHighCurrLow2 " h" hCustom, % max " "
		Gui, %GUI_name%: Add, Text, % "Section xs y+-1 BackgroundTrans Border 0x200 Center w" wHighCurrLow " h" hCustom, % Lang_Trans("global_last")
		Gui, %GUI_name%: Add, Text, % "ys x+-1 yp BackgroundTrans Border 0x200 Right w" wHighCurrLow2 " h" hCustom, % balance " "
		Gui, %GUI_name%: Add, Text, % "Section xs y+-1 BackgroundTrans Border 0x200 Center w" wHighCurrLow " h" hCustom, % Lang_Trans("m_clone_performance", 3)
		Gui, %GUI_name%: Add, Text, % "ys x+-1 yp BackgroundTrans Border 0x200 Right w" wHighCurrLow2 " h" hCustom, % min " "
		Gui, %GUI_name%: Add, Progress, % "Disabled Section x" wUI2 + wUI + w " y" settings.exchange.fHeight - 1 " w" wHighCurrLow + wHighCurrLow2 - 1 " h" hCustom * 4 - 3 " BackgroundBlack", 0

		If !vars.pics.exchange_trades.graph_week
			vars.pics.exchange_trades.graph_week := Exchange_CandleGraph(w, hCustom * 4 - 5, dates, stats)

		Gui, %GUI_name%: Add, Progress, % "Disabled Section xs x" wUI2 + wUI " y+0 w" wUI2 " h4 Background606060", 0
		Gui, %GUI_name%: Add, Text, % "Section xs y+0 w" wUI2 " BackgroundTrans Border", % " " Lang_Trans("exchange_7days") . Lang_Trans("global_colon")
		Gui, %GUI_name%: Add, Progress, % "Disabled xp yp wp hp BackgroundBlack", 0
		Gui, %GUI_name%: Add, Pic, % "Section xs y+-1 BackgroundTrans Border HWNDhwnd", % "HBitmap:*" vars.pics.exchange_trades.graph_week
		ControlGetPos, xWeek, yWeek, wWeek, hWeek,, ahk_id %hwnd%

		Gui, %GUI_name%: Add, Text, % "Section ys x+-1 BackgroundTrans Border 0x200 Center w" wHighCurrLow + wHighCurrLow2 - 1 " h" hCustom, % Lang_Trans("global_trade", 2) . Lang_Trans("global_colon") " " stats.trades
		Gui, %GUI_name%: Add, Text, % "Section xs y+-1 BackgroundTrans Border 0x200 Center w" wHighCurrLow " h" hCustom, % Lang_Trans("m_clone_performance", 5)
		Gui, %GUI_name%: Add, Text, % "ys x+-1 BackgroundTrans Border 0x200 Right w" wHighCurrLow2 " h" hCustom, % stats.max " "
		Gui, %GUI_name%: Add, Text, % "Section xs y+-1 BackgroundTrans Border 0x200 Center w" wHighCurrLow " h" hCustom, % Lang_Trans("global_last")
		Gui, %GUI_name%: Add, Text, % "ys x+-1 yp BackgroundTrans Border 0x200 Right w" wHighCurrLow2 " h" hCustom, % stats.balance " "
		Gui, %GUI_name%: Add, Text, % "Section xs y+-1 BackgroundTrans Border 0x200 Center w" wHighCurrLow " h" hCustom, % Lang_Trans("m_clone_performance", 3)
		Gui, %GUI_name%: Add, Text, % "ys x+-1 yp BackgroundTrans Border 0x200 Right w" wHighCurrLow2 " h" hCustom, % stats.min " "
		Gui, %GUI_name%: Add, Progress, % "Disabled Section x" wUI2 + wUI + w " y" yWeek " w" wHighCurrLow + wHighCurrLow2 - 1 " h" hCustom * 4 - 3 " BackgroundBlack", 0
	}

	Gui, %GUI_name%: Show, % "NA x10000 y10000"
	WinGetPos,,, wWin, hWin, ahk_id %hwnd_exchange%
	Gui, %GUI_name%: Show, % "NA x" vars.client.x + vars.client.w/2 - wUI/2 - (vars.pixels.inventory ? vars.client.h * 0.3083 : 0) - (transactions.Count() ? wUI2 : 0) " y" vars.client.y + vars.client.h * 0.1055

	vars.exchange.inventory := vars.pixels.inventory, vars.exchange.coords := {}
	LLK_Overlay(hwnd_exchange, "show",, GUI_name), LLK_Overlay(hwnd_old, "destroy")

	Loop 3
	{
		key := (A_Index = 3 ? "order" : "amount" A_Index)
		WinGetPos, x, y, w, h, % "ahk_id " vars.hwnd.exchange[key]
		vars.exchange.coords[key] := [x, x + w, y, y + h]
	}

	vars.exchange.coords.screenshot := [vars.client.w/2 - wUI/2 + vars.client.h * 0.03125 - (vars.pixels.inventory ? vars.client.h * 0.3083 : 0), Ceil(vars.client.h * 0.206), vars.client.h * 0.6625, Ceil(vars.client.h * 0.033)]
	wait := 0
}

Exchange2(hotkey)
{
	local
	global vars, settings, json

	box := Exchange_coords()
	If !InStr("amount1, amount2, order", box) || (box = "order" && hotkey = "Space")
		Return

	KeyWait, % hotkey
	If !Exchange_coords() || !WinActive("ahk_id " vars.hwnd.poe_client) && !WinActive("ahk_id " vars.hwnd.exchange.main) ;prevent coincidental activation when dragging a window that happens to be in that spot
		Return
	If (box = "order")
	{
		If (selection := vars.exchange.selected_currency) && (LLK_ControlGet(vars.hwnd.exchange.edit1) * LLK_ControlGet(vars.hwnd.exchange.edit1))
		{
			date := LLK_FormatTime("YYYYMMDDHH24MI", "yyyy-MM-dd"), time := LLK_FormatTime("YYYYMMDDHH24MI", "HH.mm.ss")
			amount := LLK_ControlGet(vars.hwnd.exchange["edit" (InStr(selection, "1") ? 1 : 2)])
			amount := (InStr(selection, "chaos") ? Round(amount/settings.exchange.chaos_div, 2) : (InStr(selection, "exalt") ? Round(amount/settings.exchange.exalt_div, 2) : amount))
			If !IsObject(vars.exchange.transactions[date])
				vars.exchange.transactions[date] := []
			vars.exchange.transactions[date].Push({"amount": amount, "time": time, "type": (selection := StrReplace(selection, "chaos", "divine"))})
			vars.exchange.selected_currency := ""
			IniWrite, % """" json.dump({"amount": amount, "type": selection}) """", % "ini" vars.poe_version "\vaal street log.ini", % date ", " time, transaction

			pBitmap := Gdip_BitmapFromHWND(vars.hwnd.poe_client, 1), screenshot := vars.exchange.coords.screenshot
			If settings.general.blackbars
				pBitmap_copy := Gdip_CloneBitmapArea(pBitmap, vars.client.x - vars.monitor.x, 0, vars.client.w, vars.client.h,, 1), Gdip_DisposeImage(pBitmap), pBitmap := pBitmap_copy
			pCrop := Gdip_CloneBitmapArea(pBitmap, screenshot.1, screenshot.2, screenshot.3, screenshot.4,, 1)
			If !FileExist((folder := "img\GUI\vaal street" vars.poe_version))
				FileCreateDir, % folder
			Gdip_SaveBitmapToFile(pCrop, folder . "\" date ", " time ".jpg", 85)
			Gdip_DisposeBitmap(pBitmap), Gdip_DisposeBitmap(pCrop)

			If vars.pics.exchange_trades.graph_day
				DeleteObject(vars.pics.exchange_trades.graph_day), vars.pics.exchange_trades.graph_day := ""
			If vars.pics.exchange_trades.graph_week
				DeleteObject(vars.pics.exchange_trades.graph_week), vars.pics.exchange_trades.graph_week := ""

			Exchange()
			If (vars.settings.active = "exchange")
				Settings_menu("exchange")
			Return
		}
		Else If selection
			GuiControl,, % vars.hwnd.exchange[selection "_bar"], 0

		If vars.exchange.ratio_lock
			Exchange("lock")
		GuiControl,, % vars.hwnd.exchange.edit1, 0
		GuiControl,, % vars.hwnd.exchange.edit2, 0
	}
	Else If (hotkey = "LButton")
	{
		If vars.exchange.ratio_lock
			Exchange("lock")
		Clipboard := ""
		Sleep 50
		SendInput, ^{a}^{c}
		ClipWait, 0.1
		If IsNumber(Clipboard)
			GuiControl,, % vars.hwnd.exchange["edit" (box = "amount1" ? 1 : 2)], % Clipboard
	}
	Else If (hotkey = "Space")
	{
		If vars.exchange.ratio_lock
			Exchange("lock")
		vars.exchange.multiplier := 1
		Click
		SendInput, ^{a}{DEL}{Enter}
		GuiControl,, % vars.hwnd.exchange["edit" (box = "amount1" ? 1 : 2)], % 0
	}
	Else If (hotkey = "RButton")
	{
		Clipboard := LLK_ControlGet(vars.hwnd.exchange["edit" (box = "amount1" ? 1 : 2)])
		ClipWait, 0.1
		If IsNumber(Clipboard)
			SendInput, % "^{a}" Clipboard
		Sleep 100
		Clipboard := ""
	}
}

Exchange_CandleGraph(width, height, data, ByRef stats)
{
	local
	global vars, settings
	static brush, pen

	wPen := Ceil(height/80), stats := {}
	If !IsObject(brush)
		brush := {"black": Gdip_BrushCreateSolid(0xFF000000), "green": Gdip_BrushCreateSolid(0xFF008000), "orange": Gdip_BrushCreateSolid(0xFFCC6600)}
		, pen := {"baseline": Gdip_CreatePen(0xFFFFFFFF, 1), "green": Gdip_CreatePen(0xFF008000, 2), "orange": Gdip_CreatePen(0xFFCC6600, 2)}

	hbmBitmap := CreateDIBSection(width, height), hdcBitmap := CreateCompatibleDC(), obmBitmap := SelectObject(hdcBitmap, hbmBitmap), gBitmap := Gdip_GraphicsFromHDC(hdcBitmap)
	Gdip_FillRectangle(gBitmap, brush.black, 0, 0, width, height)

	wMargins := Round(width/40), hMargins := Round(height/20), width2 := width - 2*wMargins, height2 := height - 2*hMargins
	balance := low := high := min := max := trades := 0, candles := []

	For index, val in data
	{
		open := (index = 1) ? 0 : close
		For index1, trade in val.object
		{
			If (index1 = 1)
				low := high := balance
			balance += trade.amount * (InStr(trade.type, "2") ? -1 : 1), low := (balance < low ? balance : low), high := (balance > high ? balance : high)
			min := (balance < min ? balance : min), max := (balance > max ? balance : max)
			trades += 1
		}
		close := Round(balance, 2)
		candles.Push({"open": open, "close": close, "low": low, "high": high})
	}

	wDay := Floor(width2/7)
	While Mod(wDay, 6)
		wDay -= 1
	wCandle := wDay * 4/6

	xScale := Floor(width2 / graph.Count()), yScale := Round(height2 / (max + Abs(min)), 4)
	baseline := hMargins + max * yScale
	Gdip_DrawCurve(gBitmap, pen.baseline, [wMargins, baseline, width - wMargins, baseline])
	For index, candle in candles
	{
		color := (candle.open <= candle.close ? "green" : "orange")
		xBody := wMargins + (index - 1) * wDay + wDay/4, xWick := xBody + wCandle/2
		yBody1 := Min(baseline - candle.open * yScale, baseline - candle.close * yScale), yBody2 := Abs((baseline - candle.open * yScale) - (baseline - candle.close * yScale))
		Gdip_DrawCurve(gBitmap, pen[color], [xWick, Ceil(baseline - candle.high * yScale), xWick, Floor(baseline - candle.low * yScale)], 0)
		Gdip_FillRectangle(gBitmap, brush[color], xBody, yBody1, wCandle, yBody2)
	}

	stats := {"balance": (balance >= 0 ? "+" : "") . Round(balance, 1), "min": (min >= 0 ? "+" : "") . Round(min, 1), "max": (max >= 0 ? "+" : "") . Round(max, 1), "trades": trades}
	SelectObject(hdcBitmap, obmBitmap), DeleteDC(hdcBitmap), Gdip_DeleteGraphics(gBitmap)
	Return hbmBitmap
}

Exchange_coords()
{
	local
	global vars, settings

	If LLK_IsBetween(vars.general.xMouse, vars.exchange.coords.amount1.1, vars.exchange.coords.amount1.2) && LLK_IsBetween(vars.general.yMouse, vars.exchange.coords.amount1.3, vars.exchange.coords.amount1.4)
		Return "amount1"
	Else If LLK_IsBetween(vars.general.xMouse, vars.exchange.coords.amount2.1, vars.exchange.coords.amount2.2) && LLK_IsBetween(vars.general.yMouse, vars.exchange.coords.amount2.3, vars.exchange.coords.amount2.4)
		Return "amount2"
	Else If LLK_IsBetween(vars.general.xMouse, vars.exchange.coords.order.1, vars.exchange.coords.order.2) && LLK_IsBetween(vars.general.yMouse, vars.exchange.coords.order.3, vars.exchange.coords.order.4)
		Return "order"
}

UpdateConversions()
{
	local
	global vars, settings

	timestamp := vars.async.conversions.timestamp, league := settings.general.league.Clone(), league := (vars.poe_version ? vars.leagues[league.1].trade[league.3] : vars.leagues[league.1].trade.normal[league.4])
	If (timestamp.2 != "failed" && (!IsNumber(timestamp) || LLK_TimeElapsed(timestamp) > 60)) || (timestamp.2 = "failed" && LLK_TimeElapsed(timestamp.1) > 15)
	{
		If !IsNumber(vars.stash.currency.timestamp) || (vars.stash.currency.league != league) || (LLK_TimeElapsed(vars.stash.currency.timestamp) > 60)
			success := Stash_PriceFetch("currency")
		If success || IsNumber(vars.stash.currency.timestamp) && (LLK_TimeElapsed(vars.stash.currency.timestamp) <= 60)
		{
			vars.async.conversions := {}, ini := IniBatchRead("data\global\[stash-ninja] prices" vars.poe_version ".ini", "currency")
			For key, val in ini.currency
				If !InStr(key, "_trend")
					vars.async.conversions[key] := StrSplit(val, ",", " ")[(vars.poe_version ? 2 : 1)]
			If vars.poe_version
				vars.async.conversions.exalted := 1
			Else vars.async.conversions.chaos := 1

			IniWrite, % (settings.exchange.chaos_div := Round(StrSplit(ini.currency.divine, ",", " ").1)), % "ini" vars.poe_version "\vaal street.ini", settings, chaos-div ratio
			IniWrite, % (settings.exchange.exalt_div := Round(StrSplit(ini.currency.divine, ",", " ").2)), % "ini" vars.poe_version "\vaal street.ini", settings, exalt-div ratio
		}
		Else If !success
			vars.async.conversions := {"timestamp": [A_NowUTC, "failed"]}
	}
}
