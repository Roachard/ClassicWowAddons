local GOLD_AMOUNT_TEXTURE2 = "%s\124TInterface\\MoneyFrame\\UI-GoldIcon:%d:%d:2:0\124t";

--========================================
-- String to integer convertor
--========================================
function TrackOMatic_StrToInt(expression)
    return tonumber(expression) or 0;
end

--==================================================
-- Color hex code to RGB array
--==================================================
function TrackOMatic_ColorHexToRGB(colorHex, adjustMult)

    local hexR = string.sub(colorHex, -6, -5);
    local hexG = string.sub(colorHex, -4, -3);
    local hexB = string.sub(colorHex, -2, -1);

    adjustMult = math.min(1, math.max(0, adjustMult));

    local decR = (tonumber("0x" .. hexR) or 0);
    local decG = (tonumber("0x" .. hexG) or 0);
    local decB = (tonumber("0x" .. hexB) or 0);

    return {r = ((decR / 255) * adjustMult), g = ((decG / 255) * adjustMult), b = ((decB / 255) * adjustMult)};

end

--==================================================
-- Color RGB array to hex code
--==================================================
function TrackOMatic_ColorRGBToHex(rgb)
    local hexR = string.format("%x", math.floor(rgb.r * 255));
    local hexG = string.format("%x", math.floor(rgb.g * 255));
    local hexB = string.format("%x", math.floor(rgb.b * 255));
    return "|cff" .. string.rep("0", math.max(0, 2 - string.len(hexR))) .. hexR .. string.rep("0", math.max(0, 2 - string.len(hexG))) .. hexG .. string.rep("0", math.max(0, 2 - string.len(hexB))) .. hexB;
end

--==================================================
-- Float rounding
--==================================================
function TrackOMatic_Round(num)
    if ((num + 0.5) >= (math.floor(num) + 1)) then
        return (math.floor(num) + 1);
    else
        return math.floor(num);
    end
end

--==================================================
-- Gold text display
--==================================================
function TrackOMatic_FormatStringMoney(amount, defaultColor)

    local amt = TrackOMatic_StrToInt(amount);
    local amtGold = math.floor(amt / 10000);
    local amtSilver = math.floor((amt % 10000) / 100);
    local amtCopper = (amt % 100);
    local dispGold = "";
    local dispSilver = "";
    local dispCopper = "";
    if (defaultColor == nil) then
        defaultColor = "ffffff";
    end

    if (amtGold > 0) then
        dispGold = format(GOLD_AMOUNT_TEXTURE2 .. " ", BreakUpLargeNumbers(amtGold), 0, 0);
    end
    if (amtSilver > 0) then
        dispSilver = format(SILVER_AMOUNT_TEXTURE .. " ", amtSilver, 0, 0);
    end
    if (amtCopper > 0) then
        dispCopper = format(COPPER_AMOUNT_TEXTURE, amtCopper, 0, 0);
    end

    return dispGold .. dispSilver .. dispCopper;

end

--==================================================
-- Returns the player's level cap
--==================================================
function TrackOMatic_GetLevelCap()

    return MAX_PLAYER_LEVEL_TABLE[GetAccountExpansionLevel()];

end

--========================================
-- Check if a unit has a specified
-- buff/debuff
--========================================
function TrackOMatic_UnitHasAura(unit, name)
	for i = 1, 40, 1 do
		auraName = UnitAura(unit, i);
		if (auraName) then
			if (auraName == name) then
				return true;
			end
		end
	end
end

--========================================
-- Create a text-based time counter
--========================================
function TrackOMatic_TimeCounter(time, isCompact)
    local dispHours, dispMinutes, dispSeconds = "", "", "";
    local time2 = math.floor((time or 0));
    local spacing, hSuffix, mSuffix, sSuffix = " ", "h", "m", "s";
    local hDigits, mDigits, sDigits = 1, 1, 1;
    if (isCompact) then
        spacing, hSuffix, mSuffix, sSuffix = "", ":", ":", "";
        sDigits = 2;
    end

    if (time2 >= 3600) then
        dispHours = string.format("%0" .. hDigits .. "d", math.floor(time2 / 3600)) .. hSuffix;
        if (isCompact) then
            mDigits = 2;
        end
    end
    if (time2 >= 60) then
        dispMinutes = string.format("%0" .. mDigits .. "d", math.floor((time2 % 3600) / 60)) .. mSuffix;
    end
    dispSeconds = string.format("%0" .. sDigits .. "d", (time2 % 60)) .. sSuffix;
    return dispHours .. spacing .. dispMinutes .. spacing .. dispSeconds;
end

--========================================
-- Returns the link for an item of the
-- given item ID. Links are cached to
-- avoid multiple server queries per item
--========================================
function TrackOMatic_GetItemLink(itemId)
    if (TrackOMatic.ItemLinkCache[itemId]) then
        return TrackOMatic.ItemLinkCache[itemId];
    end
    local name, link, quality = GetItemInfo(itemId);
    if (name and link) then
        TrackOMatic.ItemLinkCache[itemId] = link;
        return link;
    end
    return nil;
end

--========================================
-- Formats a string, parsing an array of
-- keys into values
--========================================
function TrackOMatic_FormatString(stringToParse, args)
    local key, val;
    local str = stringToParse;
    for key, val in pairs(args) do
        str = string.gsub(str, "{$" .. key .. "}", val);
    end
    return str;
end
