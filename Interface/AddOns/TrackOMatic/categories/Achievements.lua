local L = LibStub("AceLocale-3.0"):GetLocale("TrackOMatic", true);

TRACKOMATIC_ACHIEVEMENTFRAME_HOOKED = false;
local TRACKOMATIC_ACHIEVEMENT_PLAYER = 1;
local TRACKOMATIC_ACHIEVEMENT_GUILD = 2;
local TRACKOMATIC_ACHIEVEMENT_ANY = 3;
local achButtonHook;

local _T;

--========================================
-- Adds an achievement to the tracker
--========================================
function TrackOMatic_AddAchievement(achId)

    local id, name = GetAchievementInfo(achId);

    if (not id) then return; end
    if (not TrackOMatic_AchievementIsTrackable(id, TRACKOMATIC_ACHIEVEMENT_PLAYER)) then
        return;
    end

    if (TrackOMatic_AddToCategory("ach", {id = id})) then
        TrackOMatic_Message(string.format(L["TRACKER_ADD_ACHIEVEMENT"], name));
    end

end

--========================================
-- Adds a guild achievement to the
-- tracker
--========================================
function TrackOMatic_AddGuildAchievement(achId)

    local id, name = GetAchievementInfo(achId);

    if (not id) then return; end
    if (not TrackOMatic_AchievementIsTrackable(id, TRACKOMATIC_ACHIEVEMENT_GUILD)) then
        return;
    end

    if (TrackOMatic_AddToCategory("guild_ach", {id = id})) then
        TrackOMatic_Message(string.format(L["TRACKER_ADD_GUILD_ACHIEVEMENT"], name));
    end

end

--========================================
-- Updates achievement/guild achievement
-- bar
--========================================
function TrackOMatic_SetAchievementBar(data)

    local value, max, color, label, levelLabel, tooltipTitle, barIsSet, menuTitle;

    local id, name, points, completed, month, day, year, description, achFlags, image, rewardText, isGuildAch; -- = GetAchievementInfo(data.id);
    id, name, points, completed, month, day, year, description, achFlags = GetAchievementInfo(data.id);
    local criteriaString, criteriaType, criteriaCompleted, quantity, reqQuantity, charName, flags, assetID, quantityString, criteriaID;

    local accountWide = false;
    local tooltipText = "";

    if (id) then
        accountWide = (bit.band(achFlags, ACHIEVEMENT_FLAGS_ACCOUNT) == ACHIEVEMENT_FLAGS_ACCOUNT);
        tooltipTitle = name;

        if (accountWide) then
            label = "|cff20a0ff" .. name;
            tooltipText = "|cff20a0ff" .. L["ACCOUNT_WIDE"] .. "\n";
        else
            label = name;
        end

        if (isGuildAch) then
            local guildName = GetGuildInfo("player") or "???";
            if (completed) then
                tooltipText = tooltipText .. "\n|cff00ff00" .. string.format(ACHIEVEMENT_TOOLTIP_COMPLETE, guildName, month, day, year) .. "|r\n";
            else
                tooltipText = tooltipText .. "\n|cff00ff00" .. string.format(ACHIEVEMENT_TOOLTIP_IN_PROGRESS, guildName) .. "|r";
            end
        else
            if (completed) then
                tooltipText = tooltipText .. "\n|cff00ff00" .. string.format(ACHIEVEMENT_TOOLTIP_COMPLETE, UnitName("player"), month, day, year) .. "|r\n";
            else
                tooltipText = tooltipText .. "\n|cff00ff00" .. string.format(ACHIEVEMENT_TOOLTIP_IN_PROGRESS, UnitName("player")) .. "|r";
            end
        end

        tooltipText = tooltipText .. "\n\n|cffffffff" .. description;

        menuTitle = name;

        for i = 1, GetAchievementNumCriteria(id), 1 do
        --for i = 0, 999, 1 do
            if (not barIsSet) then
                criteriaString, criteriaType, criteriaCompleted, quantity, reqQuantity, charName, flags, assetID, quantityString, criteriaID = GetAchievementCriteriaInfo(id, i);
                if (reqQuantity) then
                    if (bit.band(flags, EVALUATION_TREE_FLAG_PROGRESS_BAR) == EVALUATION_TREE_FLAG_PROGRESS_BAR) then
                        --if ((not barIsSet) or (not completed)) then
                            max = reqQuantity;
                            value = quantity;
                            if (completed) then
                                color = {r = 0.25, g = 0.75, b = 0.25};
                            else
                                color = {r = 0.7, g = 0.6, b = 0};
                            end
                            levelLabel = quantityString;
                            barIsSet = true;
                            
                            --tooltipText = tooltipText .. "\n\nCriteriaID: " .. criteriaID;
                        --end
                    end
                    --barIsSet = true;
                end
            end
        end
    else
        label = "???";
        levelLabel = "";
        color = {r = 0.5, g = 0.5, b = 0.5};
        max = 1;
        value = 1;
        tooltipTitle = "";
        tooltipText = L["TIP_REMOVE_BAR"];
        menuTitle = L["UNDEFINED"];
    end

    return value, max, color, label, levelLabel, tooltipTitle, tooltipText, menuTitle, nil, nil, completed;

end

--========================================
-- Removes an achievement from the
-- tracker
--========================================
function TrackOMatic_RemoveAchievement(index, isSilent)
    local data = TrackOMatic_RemoveFromCategory("ach", index);
    if ((not isSilent) and data) then
        if (data.isPlugin) then
            if (data.name) then TrackOMatic_Message(string.format(L["TRACKER_REMOVE_PLUGIN"], data.name)); end
        else
            local __, name = GetAchievementInfo(data.id);
            if (name) then TrackOMatic_Message(string.format(L["TRACKER_REMOVE_ACHIEVEMENT"], name)); end
        end
    end
end

--========================================
-- Removes a guild achievement from the
-- tracker
--========================================
function TrackOMatic_RemoveGuildAchievement(index, isSilent)
    local data = TrackOMatic_RemoveFromCategory("guild_ach", index);
    if ((not isSilent) and data) then
        local id, name = GetAchievementInfo(data.id);
        if (name) then
            TrackOMatic_Message(string.format(L["TRACKER_REMOVE_GUILD_ACHIEVEMENT"], name));
        end
    end
end

--========================================
-- Hooks the achievement UI
--========================================
function TrackOMatic_HookAchievementFrame()
    if (TRACKOMATIC_ACHIEVEMENTFRAME_HOOKED) then return; end
    if (AchievementFrame) then
        achButtonHook = AchievementButton_DisplayAchievement;
        AchievementButton_DisplayAchievement = TrackOMatic_AchievementButton_DisplayAchievement;
        achButtonHook2 = AchievementButton_OnClick;
        AchievementButton_OnClick = function() end;
        TRACKOMATIC_ACHIEVEMENTFRAME_HOOKED = true;
    end
end

--========================================
-- Sets up the achievement buttons
-- with a new OnClick handler and a
-- point to anchor the popup menu to
--========================================
function TrackOMatic_AchievementButton_DisplayAchievement(button, category, achievement, selectionID)
    local manchor = _G[button:GetName() .. "TrackOMaticMenuAnchor"];
    if (not manchor) then
        manchor = CreateFrame("Frame", button:GetName() .. "TrackOMaticMenuAnchor", button);
        manchor:SetWidth(1);
        manchor:SetHeight(1);
        manchor:ClearAllPoints();
        manchor:SetPoint("TOPRIGHT", button, "TOPRIGHT", 0, 0);
    end
    achButtonHook(button, category, achievement, selectionID);
    if (not button.TOMhooked) then
        button:HookScript("OnClick", TrackOMatic_AchievementButton_OnClick);
        button.TOMhooked = true;
    end
    button:RegisterForClicks("LeftButtonUp", "RightButtonUp");
end

--========================================
-- New OnClick handler for achievement
-- buttons
--========================================
function TrackOMatic_AchievementButton_OnClick(self, button)
    if (button == "LeftButton") then
        achButtonHook2(self, button, down, ignoreModifiers);
    else
        local id, _T, _T, _T, _T, _T, _T, _T, _T, _T, _T, isGuildAch = GetAchievementInfo(self.id);
        local menu = {};
        if (isGuildAch) then
            table.insert(menu, {text = L["BUTTON_ADD"], notCheckable = true, disabled = ((not TrackOMatic_AchievementIsTrackable(self.id, TRACKOMATIC_ACHIEVEMENT_ANY)) or self.completed), func = function() TrackOMatic_AddGuildAchievement(self.id); end});
        else
            table.insert(menu, {text = L["BUTTON_ADD"], notCheckable = true, disabled = ((not TrackOMatic_AchievementIsTrackable(self.id, TRACKOMATIC_ACHIEVEMENT_ANY)) or self.completed), func = function() TrackOMatic_AddAchievement(self.id); end});
        end
        EasyMenu(menu, TrackOMatic_TrackerMenu, _G[self:GetName() .. "TrackOMaticMenuAnchor"], 0, 0, "MENU", 1);
    end
end

--========================================
-- Returns whether or not an achievement
-- is trackable with Track-O-Matic
--========================================
function TrackOMatic_AchievementIsTrackable(achId, type)

    local id, name, points, completed, month, day, year, description, flags, image, rewardText, isGuildAch = GetAchievementInfo(achId);

    if (not id) then return false; end
    if (isGuildAch and (bit.band(type, TRACKOMATIC_ACHIEVEMENT_GUILD) ~= TRACKOMATIC_ACHIEVEMENT_GUILD)) or
        ((not isGuildAch) and (bit.band(type, TRACKOMATIC_ACHIEVEMENT_PLAYER) ~= TRACKOMATIC_ACHIEVEMENT_PLAYER)) then
        return false;
    end

    local criteriaString, criteriaType, completed, quantity, reqQuantity, charName, flags, assetID, quantityString, criteriaID;
	local textStrings, progressBars, metas = 0, 0, 0;

    for i = 1, GetAchievementNumCriteria(id), 1 do
        criteriaString, criteriaType, completed, quantity, reqQuantity, charName, flags, assetID, quantityString, criteriaID = GetAchievementCriteriaInfo(id, i);

        if (criteriaType == CRITERIA_TYPE_ACHIEVEMENT and assetID) then
            metas = metas + 1;
        elseif (bit.band(flags, EVALUATION_TREE_FLAG_PROGRESS_BAR) == EVALUATION_TREE_FLAG_PROGRESS_BAR) then
            progressBars = progressBars + 1;
        else
            textStrings = textStrings + 1;
        end
    end

    -- no progress bars? not trackable.
    if (progressBars < 1) then
        return false;
    end

    return true;

end
