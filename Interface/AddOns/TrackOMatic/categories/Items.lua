local L = LibStub("AceLocale-3.0"):GetLocale("TrackOMatic", true);

TRACKOMATIC_MAX_ITEM_SUGGESTIONS = 10;

local _T;

StaticPopupDialogs["TRACKOMATIC_ITEM_NOT_FOUND"] = {
    text = L["ITEM_NOT_FOUND"],
    button1 = OKAY,
    timeout = 0,
    hideOnEscape = 1,
    showAlert = 1,
};

--========================================
-- Add an item to the tracker with the
-- specified goal count
--========================================
function TrackOMatic_AddItem(name, goalCount)

    goalCount = TrackOMatic_StrToInt(goalCount);
    -- makes sure the goal value entered is a number and that number is greater than 0
    if (goalCount < 1) then
        StaticPopup_Show("TRACKOMATIC_INVALID_GOAL");
        return;
    end

    local itemToWatch, itemWatchColor = TrackOMatic_MatchItemData(name);

    if (not itemToWatch) then
        StaticPopup_Show("TRACKOMATIC_ITEM_NOT_FOUND");
        return;
    end

    if (TrackOMatic_AddToCategory("item", {id = itemToWatch, goal = goalCount, color = itemWatchColor})) then
        TrackOMatic_Message(string.format(L["TRACKER_ADD_ITEM"], "|c" .. itemWatchColor .. "[" .. itemToWatch .. "]|r"));
    end

end

--========================================
-- Update an item bar
--========================================
function TrackOMatic_SetItemBar(data)

    local max, value, color, tooltipTitle, tooltiptext;
    local includeBank = false;

    -- set some values
    local numInBags = GetItemCount(data.id);
    local numInBagsAndBank = GetItemCount(data.id, true);
    local numInBank = (numInBagsAndBank - numInBags);

    max = data.goal;
    if (data.includeBank) then
        value = numInBagsAndBank;
    else
        value = numInBags;
    end
    color = TrackOMatic_ColorHexToRGB(data.color, 0.9);

    tooltipTitle = "|c" .. data.color .. "[" .. data.id .. "]|r";
    tooltipText = string.format(L["CURRENT_AMOUNT"], value) .. "\n";
    tooltipText = tooltipText .. string.format(L["GOAL_AMOUNT"], BreakUpLargeNumbers(data.goal)) .. "\n";
    if (value < max) then
        tooltipText = tooltipText .. "|cffff8000" .. string.format(L["UNTIL_GOAL"], BreakUpLargeNumbers(max - value)) .. "|r";
    else
        if (value > max) then
            tooltipText = tooltipText .. "|cff00ff00" .. string.format(L["PAST_GOAL"], BreakUpLargeNumbers(value - max)) .. "|r";
        else
            tooltipText = tooltipText .. "|cff00ff00" .. L["GOAL_REACHED"] .. "|r";
        end
    end
    if (data.includeBank) then
        tooltipText = tooltipText .. "\n";
        if (numInBank > 0) then
            tooltipText = tooltipText .. "\n" .. string.format(L["ITEM_TOOLTIP_INCLUDING_BANK"], "|cffffffff" .. numInBank .. "|r") .. "\n" ..
                                        string.format(L["ITEM_TOOLTIP_BAG_COUNT"], "|cffffffff" .. numInBags .. "|r");
        else
            tooltipText = tooltipText .. "\n" .. string.format(L["ITEM_TOOLTIP_BAG_COUNT"], "|cffffffff" .. numInBags .. "|r") .. "\n" ..
                                        "|cffa0a0a0" .. string.format(L["ITEM_NONE_IN_BANK"]) .. "|r";
        end
    end

    local levelLabel = "";
    if (TRACKOMATIC_VARS[TrackOMatic.Profile]['show_quantity_items']) then
        levelLabel = value .. "/" .. max;
    end
    if (TRACKOMATIC_VARS[TrackOMatic.Profile]['show_percent_items']) then
        levelLabel = levelLabel .. " (" .. math.floor((value / max) * 100) .. "%)";
    end

    local menu = {
        TrackOMatic_CommonMenuItem("CHANGE_GOAL", function(value) TrackOMatic_ChangeItemGoal(data.id, value); end, "|c" .. data.color .. "[" .. data.id .. "]"),
        {text = L["BARMENU_CUSTOM_GLOW"], notCheckable = true, func = function() TrackOMatic_SetupCustomGlow("item", data); end},
        {text = L["ITEM_MENU_INCLUDE_BANK"], checked = data.includeBank, func = function() TrackOMatic_ToggleItemBankInclusion(data.id); end},
    };
    if (data.customGlow) then
        table.insert(menu, {text = L["BARMENU_REMOVE_CUSTOM_GLOW"], notCheckable = true, func = function() TrackOMatic_RemoveCustomGlow("item", data.id); end});
        --if (TrackOMatic.DebugMode.Enabled) then
            local thresholdTypes = { "GLOW_RULE_CONDITION_VALUE_ABOVE", "GLOW_RULE_CONDITION_VALUE_BELOW", "GLOW_RULE_CONDITION_PERCENT_ABOVE", "GLOW_RULE_CONDITION_PERCENT_BELOW" };
            tooltipText = tooltipText .. "\n\n|cff00a0a0" .. L["CUSTOM_GLOW_SET"] .. "\n" .. L[thresholdTypes[(data.customGlow['threshold_type'] or 0) + 1]] .. " " .. (data.customGlow['threshold_value'] or max) .. "|r";
        --end
    end

    return value, max, color, data.id, levelLabel, tooltipTitle, tooltipText, data.id, menu, nil, TrackOMatic_IsItemGlowing(value, max, data.customGlow);

end

--========================================
-- Remove an item bar from the tracker
--========================================
function TrackOMatic_RemoveItem(index, isSilent)
    local data = TrackOMatic_RemoveFromCategory("item", index);
    if ((not isSilent) and data) then
        if (data.isPlugin) then
            if (data.name) then TrackOMatic_Message(string.format(L["TRACKER_REMOVE_PLUGIN"], data.name)); end
        else
            TrackOMatic_Message(string.format(L["TRACKER_REMOVE_ITEM"], "|c" .. data.color .. "[" .. data.id .. "]|r"));
        end
    end
end

--========================================
-- Handler for Ctrl+Alt+Clicking on an
-- item in the player's bags
--========================================
function TrackOMatic_OnItemClick(self, button)

    local bagId = self:GetParent():GetID();
    local slotId = self:GetID();
    local itemId = GetContainerItemID(bagId, slotId);
    local itemLink = GetContainerItemLink(bagId, slotId);

    --if ((not HandleModifiedItemClick(bagId, slotId)) and (not IsModifiedClick("SOCKETITEM")) and (not IsModifiedClick("SPLITSTACK")) and (IsAltKeyDown()) and (IsControlKeyDown()) and (itemId)) then
    --
    --    local itemLink = GetContainerItemLink(bagId, slotId);
    --    if (itemLink) then
    --        local itemColor, linkInfo, itemName = string.match(itemLink, "|c(.*)|H(.*)|h%[(.+)%]|h")
    --        TrackOMatic_ShowGoalInput("|c" .. itemColor .. "[" .. itemName .. "]", function(value) TrackOMatic_AddItem(itemName, value); end);
    --    end
    --
    --end

    if ((not IsModifiedClick("CHATLINK")) and (not IsModifiedClick("SOCKETITEM")) and (not IsModifiedClick("SPLITSTACK")) and (IsAltKeyDown()) and (IsControlKeyDown()) and (itemId)) then    
        local itemLink = GetContainerItemLink(bagId, slotId);
        if (itemLink) then
            local itemColor, linkInfo, itemName = string.match(itemLink, "|c(.*)|H(.*)|h%[(.+)%]|h")
            TrackOMatic_ShowGoalInput("|c" .. itemColor .. "[" .. itemName .. "]", function(value) TrackOMatic_AddItem(itemName, value); end);
        end
    end

end

--========================================
-- Change the goal count for an item
--========================================
function TrackOMatic_ChangeItemGoal(itemName, value)

    for index, entry in pairs(TRACKOMATIC_VARS[TrackOMatic.Profile]['categories']['item'].entries) do
        if (entry.id == itemName) then
            value = TrackOMatic_StrToInt(value);
            if (value > 0) then
                TRACKOMATIC_VARS[TrackOMatic.Profile]['categories']['item'].entries[index].goal = value;
                TrackOMatic_Message(string.format(L["ITEM_GOAL_CHANGED"], "|c" .. entry.color .. "[" .. entry.id .. "]|r", value));
            else
                StaticPopup_Show("TRACKOMATIC_INVALID_GOAL");
                return;
            end
        end
    end
    TrackOMatic_UpdateTracker(1);

end

function TrackOMatic_ToggleItemBankInclusion(itemName)

    for index, entry in pairs(TRACKOMATIC_VARS[TrackOMatic.Profile]['categories']['item'].entries) do
        if (entry.id == itemName) then
            local value = true;
            if (TRACKOMATIC_VARS[TrackOMatic.Profile]['categories']['item'].entries[index]['includeBank']) then
                TRACKOMATIC_VARS[TrackOMatic.Profile]['categories']['item'].entries[index]['includeBank'] = false;
                TrackOMatic_Message(string.format(L["ITEM_COUNT_INCLUDE_BANK_OFF"], "|c" .. entry.color .. "[" .. entry.id .. "]|r", value));
            else
                TRACKOMATIC_VARS[TrackOMatic.Profile]['categories']['item'].entries[index]['includeBank'] = true;
                TrackOMatic_Message(string.format(L["ITEM_COUNT_INCLUDE_BANK_ON"], "|c" .. entry.color .. "[" .. entry.id .. "]|r", value));
            end
        end
    end
    TrackOMatic_UpdateTracker(1);

end

--========================================
-- Update the item search suggestions
-- dropdown
--========================================
function TrackOMatic_UpdateItemSearch()

    if (true) then return; end

    local numSugg = 0;
    local suggestions = {};
    local search = string.trim(TrackOMatic_ItemSearchEditBox:GetText());
    local menu = {};
    local showSuggestions = false;

    if (string.len(search) > 0) then
        for index, data in pairs(TRACKOMATIC_ITEM_CACHE) do
            if (numSugg < TRACKOMATIC_MAX_ITEM_SUGGESTIONS) then
                if (string.lower(string.sub(data.name, 1, string.len(search))) == string.lower(search)) then
                    local _T, _T, _T, colorHex = GetItemQualityColor(data.quality)
                    table.insert(suggestions, data.name);
                    table.insert(menu, {text = "|c" .. colorHex .. data.name, value = data.name, func = function() TrackOMatic_ItemSearchEditBox:SetText(data.name); end, notCheckable = true});
                    numSugg = numSugg + 1;
                end
            end
        end
    end

    if (numSugg > 1) then
        showSuggestions = true;
    elseif (numSugg == 1) then
        if (string.len(search) ~= string.len(suggestions[1])) then
            showSuggestions = true;
        end
    end

    if (showSuggestions) then
        EasyMenu(menu, TrackOMatic_TrackerMenu, TrackOMatic_ItemSearchEditBox, 0, 0, "MENU");
    else
        CloseDropDownMenus();
    end
end

--========================================
-- Handler for accepting the item search
--========================================
function TrackOMatic_ItemSearchAccept()

    local search = string.trim(TrackOMatic_ItemSearchEditBox:GetText());

    if (string.len(search) > 0) then
        TrackOMatic_ItemSearch:Hide();
        local theItemName, theItemColor = TrackOMatic_MatchItemData(search);
        if (theItemName) then
            TrackOMatic_ShowGoalInput("|c" .. theItemColor .. "[" .. theItemName .. "]", function(value) TrackOMatic_AddItem(theItemName, value); end);
            CloseDropDownMenus();
        end
    end

end

--========================================
-- Confirm an item name is valid by
-- searching the player's inventory or
-- the item cache
--========================================
function TrackOMatic_MatchItemData(search)
    --local bagList = {[0] = -4, [1] = 0, [2] = 1, [3] = 2, [4] = 3, [5] = 4 };
    --local bagID, itemFound, itemLink, itemColor, linkInfo, itemName;

    ---- search inventory for the item to track
    --for bagIndex = 0, 5, 1 do
    --    bagID = bagList[bagIndex];
    --    slotsInBag = GetContainerNumSlots(bagID);
    --    for slotID = 1, slotsInBag, 1 do
    --        if (not itemFound) then
    --            itemLink = GetContainerItemLink(bagID, slotID);
    --            if (itemLink) then
    --                itemColor, linkInfo, itemName = string.match(itemLink, "|c(.*)|H(.*)|h%[(.+)%]|h")
    --                if (string.lower(string.sub(itemName, 1, string.len(search))) == string.lower(search)) then
    --                    return itemName, itemColor;
    --                end
    --            end
    --        end
    --    end
    --end
    ---- failing inventory search, search item index
    --if (not itemFound) then
    --    for index, data in pairs(TRACKOMATIC_ITEM_CACHE) do
    --        if (string.lower(string.sub(data.name, 1, string.len(search))) == string.lower(search)) then
    --            local hexColor = select(4, GetItemQualityColor(data.quality));
    --            return data.name, hexColor;
    --        end
    --    end
    --end
    local itemName, itemLink = GetItemInfo(search);
    if ((not itemName) or (not itemLink)) then return nil; end
    local itemColor, linkInfo, linkName = string.match(itemLink, "|c(.*)|H(.*)|h%[(.+)%]|h");
    return itemName, itemColor;
end

--========================================
-- Return whether an item bar is glowing
-- based on bar value and glow rules
--========================================
function TrackOMatic_IsItemGlowing(value, max, customRules)
    if (customRules) then
        local thresholdType = customRules['threshold_type'] or 0;
        local thresholdValue = customRules['threshold_value'] or max;
        local percent = math.floor((value / max) * 100);
        -- value greater than or equal to
        if (thresholdType == 0) then
            if (value >= thresholdValue) then
                return true;
            end
        -- value less than or equal to
        elseif (thresholdType == 1) then
            if (value <= thresholdValue) then
                return true;
            end
        -- percent value greater than or equal to
        elseif (thresholdType == 2) then
            if (percent >= thresholdValue) then
                return true;
            end
        -- percent value less than or equal to
        elseif (thresholdType == 3) then
            if (percent <= thresholdValue) then
                return true;
            end
        end
    else
        if (value >= max) then
            return true;
        end
    end
    return false;
end

function TrackOMatic_RemoveCustomGlow(category, id)
    if (TRACKOMATIC_VARS[TrackOMatic.Profile]['categories'][category]) then
        for index, data in pairs(TRACKOMATIC_VARS[TrackOMatic.Profile]['categories'][category].entries) do
            if (data.id == id) then
                TRACKOMATIC_VARS[TrackOMatic.Profile]['categories'][category].entries[index].customGlow = nil;
            end
        end
    end
    TrackOMatic_UpdateTracker(1);
end
