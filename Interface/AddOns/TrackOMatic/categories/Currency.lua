local L = LibStub("AceLocale-3.0"):GetLocale("TrackOMatic", true);

local questIconNormal = "|TInterface\\GossipFrame\\AvailableQuestIcon:0:0:0:0|t";
local questIconDaily = "|TInterface\\GossipFrame\\DailyQuestIcon:0:0:0:0|t";

--========================================
-- Add currency with the specified
-- goal amount
--========================================
function TrackOMatic_AddCurrency(id, goalCount)

    local name = GetCurrencyInfo(id);

    -- makes sure the specified currency id is valid
    if (not name) then
        TrackOMatic_Message(string.format(L["INVALID_CURRENCY_ID"], id));
        return;
    end

    goalCount = TrackOMatic_StrToInt(goalCount);
    -- makes sure the goal value entered is a number and that number is greater than 0
    if (goalCount < 1) then
        StaticPopup_Show("TRACKOMATIC_INVALID_GOAL");
        return;
    end

    if (TrackOMatic_AddToCategory("currency", {id = id, goal = goalCount})) then
        TrackOMatic_Message(string.format(L["TRACKER_ADD_CURRENCY"], name));
    end

end

--========================================
-- Update a currency bar
--========================================
function TrackOMatic_SetCurrencyBar(data)

    local label, max, value, color;
    local levelLabel = "";
    local tooltipTitle = "";
    local tooltipText = "";
    local menu = {};
    local menuTitle = "";
    local isGlowing = false;

    local name, currentAmount, texture, earnedThisWeek, weeklyCap, totalCap, isDiscovered = GetCurrencyInfo(data.id);

    local playerLevel = UnitLevel("player");

    if (name) then
        -- set some values
        label = "|T" .. texture .. ":14:14:0:-1|t " .. name;
        max = data.goal;
        value = currentAmount;
        local playerFaction = UnitFactionGroup("player");
        color = { r = 0.6, g = 0.5, b = 0.2 };

        tooltipTitle = name;
        tooltipText = string.format(L["CURRENT_AMOUNT"], BreakUpLargeNumbers(currentAmount)) .. "\n";
        tooltipText = tooltipText .. string.format(L["GOAL_AMOUNT"], BreakUpLargeNumbers(data.goal)) .. "\n";

        -- "x until goal" line
        if (currentAmount < max) then
            tooltipText = tooltipText .. "|cffff8000" .. string.format(L["UNTIL_GOAL"], BreakUpLargeNumbers(max - currentAmount)) .. "|r";
        else
            if (currentAmount > max) then
                tooltipText = tooltipText .. "|cff00ff00" .. string.format(L["PAST_GOAL"], BreakUpLargeNumbers(currentAmount - max)) .. "|r";
            else
                tooltipText = tooltipText .. "|cff00ff00" .. L["GOAL_REACHED"] .. "|r";
            end
        end

        local generalInfo = {};
        local dungeonFinderInfo = {};
        local conversionInfo = {};

        local currencyDetails = "";
        -- farming calculator for darkmoon tickets
        if (data.id == 515) then
            if (value < max) then
                local needBlankLine = false;
                if (not IsQuestFlaggedCompleted(29433)) then
                    table.insert(generalInfo, questIconNormal .. L["DARKMOON_INCOMPLETE_TEST_YOUR_STRENGTH"]);
                    needBlankLine = true;
                end
                if (not IsQuestFlaggedCompleted(33354)) then
                    table.insert(generalInfo, questIconNormal .. L["DARKMOON_INCOMPLETE_MOONFANG_PELT"]);
                    needBlankLine = true;
                end
                if (needBlankLine) then table.insert(generalInfo, ""); end
                table.insert(generalInfo, questIconNormal .. L["DARKMOON_PROFESSION_QUEST_SETS"] .. ": " .. math.ceil((max - value) / 20));
                table.insert(generalInfo, questIconNormal .. L["DARKMOON_ARTIFACT_SETS"] .. ": " .. math.ceil((max - value) / 80));
                table.insert(generalInfo, questIconDaily .. L["DARKMOON_GAMES_COLLECTIVE"] .. ": " .. math.ceil((max - value) / 6));
                table.insert(generalInfo, L["DARKMOON_MONTHS"] .. ": " .. math.ceil((max - value) / 281));
            end
        end

        if (#generalInfo > 0) then
            for i, d in pairs(generalInfo) do
                currencyDetails = currencyDetails .. d .. "\n";
            end
        end
        if (#dungeonFinderInfo > 0) then
            if (currencyDetails ~= "") then currencyDetails = currencyDetails .. "\n" .. L["DUNGEON_FINDER"] .. "\n"; end
            for i, d in pairs(dungeonFinderInfo) do
                currencyDetails = currencyDetails .. "   " .. d .. "\n";
            end
        end
        if (#conversionInfo > 0) then
            if (currencyDetails ~= "") then currencyDetails = currencyDetails .. "\n"; end
            for i, d in pairs(conversionInfo) do
                currencyDetails = currencyDetails .. "|cff20a0ff" .. d .. "\n";
            end
        end
        if (string.sub(currencyDetails, -1) == "\n") then currencyDetails = string.sub(currencyDetails, 1, string.len(currencyDetails) - 1); end

        if (currencyDetails ~= "") then
            tooltipText = tooltipText .. "\n\n" .. currencyDetails;
        end

        if (TRACKOMATIC_VARS[TrackOMatic.Profile]['show_quantity_currency']) then
            levelLabel = value .. "/" .. max;
        end
        if (TRACKOMATIC_VARS[TrackOMatic.Profile]['show_percent_currency']) then
            levelLabel = levelLabel .. " (" .. math.floor((value / max) * 100) .. "%)";
        end

        menuTitle = name;
        menu = {
            TrackOMatic_CommonMenuItem("CHANGE_GOAL", function(value) TrackOMatic_ChangeCurrencyGoal(data.id, value); end, name),
        };

        if (TRACKOMATIC_VARS['config']['currency_default_glow'] and (value >= max)) then
            isGlowing = true;
        end

    else
        max = 1;
        value = 1;
        color = {r = 0.5, g = 0.5, b = 0.5};
        label = L["UNDEFINED"];
    end

    return value, max, color, label, levelLabel, tooltipTitle, tooltipText, menuTitle, menu, nil, isGlowing;
end

--========================================
-- Removes a currency from the tracker
--========================================
function TrackOMatic_RemoveCurrency(index, isSilent)
    local data = TrackOMatic_RemoveFromCategory("currency", index);
    if ((not isSilent) and data) then
        if (data.isPlugin) then
            if (data.name) then TrackOMatic_Message(string.format(L["TRACKER_REMOVE_PLUGIN"], data.name)); end
        else
            local name = GetCurrencyInfo(data.id);
            TrackOMatic_Message(string.format(L["TRACKER_REMOVE_CURRENCY"], (name or L["UNDEFINED"])));
        end
    end
end

--========================================
-- Changes a currency goal
--========================================
function TrackOMatic_ChangeCurrencyGoal(id, value)
    for index, entry in pairs(TRACKOMATIC_VARS[TrackOMatic.Profile]['categories']['currency'].entries) do
        if (entry.id == id) then
            value = TrackOMatic_StrToInt(value);
            if (value > 0) then
                TRACKOMATIC_VARS[TrackOMatic.Profile]['categories']['currency'].entries[index].goal = value;
                TrackOMatic_Message(string.format(L["CURRENCY_GOAL_CHANGED"], GetCurrencyInfo(id), value));
            else
                StaticPopup_Show("TRACKOMATIC_INVALID_GOAL");
                return;
            end
        end
    end
    TrackOMatic_UpdateTracker(1);
end


--========================================
-- Handler for clicking the add button
-- on the currency tab
--========================================
function TrackOMatic_AddCurrencyButton_OnClick(self)
    local name = TokenFrame.selectedToken;
    local id = TrackOMatic_GetCurrencyID(name);
    if (id) then
        TrackOMatic_ShowGoalInput(name, function(value) TrackOMatic_AddCurrency(id, value); end);
    else
        TrackOMatic_Message("|cffff0000" .. string.format(L["CURRENCY_ERROR"], name));
    end
end

--========================================
-- Retrieve the ID of the specified
-- currency
--========================================
function TrackOMatic_GetCurrencyID(name)

    for i = 1, 2000, 1 do
        local crName, currentAmount, texture, earnedThisWeek, weeklyCap, totalCap, isDiscovered = GetCurrencyInfo(i);
        if (crName == name) then
            return i;
        end
    end

    return nil;

end

function TrackOMatic_ConvertFromCurrencyString(currencyName, amount)
    local cvFrom = L["CONVERT_FROM_CURRENCY"];
    cvFrom = string.gsub(cvFrom, "{$a}", "|cffffffff" .. amount .. "|r");
    cvFrom = string.gsub(cvFrom, "{$c}", "|cffffffff" .. currencyName .. "|r");
    return cvFrom;
end

function TrackOMatic_CalculateJusticeGain(current, maxValue, baseGain)
    local multiplier = 1;
    return math.max(0, math.ceil((maxValue - current) / math.floor(baseGain * multiplier)));
end
