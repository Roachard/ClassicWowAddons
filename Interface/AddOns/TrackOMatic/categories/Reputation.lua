local L = LibStub("AceLocale-3.0"):GetLocale("TrackOMatic", true);

local TRACKOMATIC_MAX_REP = {
    [8] = 999,
    [7] = 21000,
    [6] = 12000,
    [5] = 6000,
    [4] = 3000,
    [3] = 3000,
    [2] = 3000,
    [1] = 36000
};
local TRACKOMATIC_TOTAL_REP = 84999;

-- tables for calculating rep per hour per faction
local TRACKOMATIC_STARTING_REP = {};
local TRACKOMATIC_REP_FIRSTUPDATE = {};
local REP_SESSIONS = {};

local questIconNormal = "|TInterface\\GossipFrame\\AvailableQuestIcon:0:0:0:0|t";
local questIconDaily = "|TInterface\\GossipFrame\\DailyQuestIcon:0:0:0:0|t";

local _T;

local HOOKS = {};

local FACTION_STANDING_LABELS = {
    [1] = FACTION_STANDING_LABEL1,
    [2] = FACTION_STANDING_LABEL2,
    [3] = FACTION_STANDING_LABEL3,
    [4] = FACTION_STANDING_LABEL4,
    [5] = FACTION_STANDING_LABEL5,
    [6] = FACTION_STANDING_LABEL6,
    [7] = FACTION_STANDING_LABEL7,
    [8] = FACTION_STANDING_LABEL8,
    [9] = FACTION_STANDING_LABEL8,
};

--========================================
-- Add a reputation to the tracker
--========================================
function TrackOMatic_AddRep(name)

    local repID, repName = TrackOMatic_GetRepID(name);

    if ((not repID) or (not repName)) then
        return;
    end

    if (TrackOMatic_AddToCategory("rep", {id = repID})) then
        TrackOMatic_Message(string.format(L["TRACKER_ADD_REP"], repName));
    end

end

--========================================
-- Update a reputation bar
--========================================
function TrackOMatic_SetRepBar(data)

    local value, max, color, label, levelLabel, tooltipTitle;
    local isGlowing = false;
    local tooltipText = "";
    local menu = {};
    local repIndex = 0;

    -- retrieve the faction info
    --local repID, factName = TrackOMatic_GetRepID(data.id);
    --if (repIndex == nil) then
    --    return;
    --end
    local repName, repDesc, standingID, bottomValue, topValue, earnedValue, atWarWith, canToggleAtWar, header, isCollapsed, hasRep, isWatched, isChild, factionID, hasBonusRepGain, canBeLFGBonus = GetFactionInfoByID(data.id);
    if (repName and factionID) then
        local factionStanding, nextStanding, maxStanding, repToExalted;

        -- handle rep earn rate
        local repPerHour, timeToExalted, timeToNextLevel = 0, 0, 0;
        local earnedThisSession = 0;

        -- session earning info
        if (REP_SESSIONS[repName] == nil) then
            REP_SESSIONS[repName] = { start = earnedValue, firstUpdate = 0 };
            repPerHour = 0;
        else
            earnedThisSession = (earnedValue - REP_SESSIONS[repName].start);
            if (REP_SESSIONS[repName].firstUpdate == 0) then
                REP_SESSIONS[repName].firstUpdate = GetTime();
                repPerHour = earnedThisSession / (math.max(1, (GetTime() - TrackOMatic.SessionStart)) / 3600);
            else
                repPerHour = earnedThisSession / (math.max(1, (GetTime() - REP_SESSIONS[repName].firstUpdate)) / 3600);
            end
        end
        repPerHour = math.floor(repPerHour)

        -- set some basic values
        factionStanding = FACTION_STANDING_LABELS[standingID];
        nextStanding = FACTION_STANDING_LABELS[standingID + 1];
        maxStanding = FACTION_STANDING_LABEL8;
        repToExalted = TrackOMatic_GetRepToExalted(standingID);
        
        -- setup the bar
        max = topValue - bottomValue;
        value = earnedValue - bottomValue;
        label = repName .. " - " .. factionStanding;
        tooltipTitle = string.format(L["STANDING_WITH_FACTION"], factionStanding, repName);
        tooltipText = "";

        -- below-exalted tooltip info
        local extendedInfo = "";
        if (standingID < 8) then
            if (TRACKOMATIC_REPUTATION_DATA[factionID]) then
                if (TRACKOMATIC_REPUTATION_DATA[factionID].noGain) then
                    extendedInfo = "\n|cffff0000" .. L["CANNOT_GAIN_REP"] .. "|r";
                else
                    if (hasBonusRepGain) then
                        extendedInfo = "|cff00ff00" .. L["REPUTATION_BONUS_UNLOCKED"] .. "\n";
                    end
                    extendedInfo = extendedInfo .. "\n|cff00ff00" .. string.format(L["UNTIL_STANDING"], nextStanding) .. "|r\n";
                    extendedInfo = extendedInfo .. TrackOMatic_DisplayReputationData(TRACKOMATIC_REPUTATION_DATA[factionID], standingID, (max - value), 0, hasBonusRepGain);
                    if (standingID < 7) then
                        extendedInfo = extendedInfo .. "\n\n|cff00ff00" .. string.format(L["UNTIL_STANDING"], maxStanding) .. "|r\n";
                        extendedInfo = extendedInfo .. TrackOMatic_DisplayReputationData(TRACKOMATIC_REPUTATION_DATA[factionID], standingID, (repToExalted - value), 0, hasBonusRepGain);
                    end
                end
            end
        end
        if (extendedInfo ~= "") then
            tooltipText = tooltipText .. extendedInfo .. "\n";
        end

        -- paragon bar
        --if (paragonValue) then
        --    value = paragonValue;
        --    max = paragonThreshold;
        --    label = "|TInterface\\COMMON\\ReputationStar:0:0:0:0:32:32:0:16:0:16:255:255:255|t " .. string.format(L["REPUTATION_PARAGON"], repName);
        --    levelLabel = value .. "/" .. max;
        --    tooltipTitle = string.format(L["REPUTATION_PARAGON"], repName);
        ---- exalted bar
        --elseif (standingID == 8) then
        --    max = 1;
        --    value = 1;
        --    levelLabel = "";
        --    isGlowing = true;
        ---- anything below exalted and not paragon
        --else
            levelLabel = value .. "/" .. max;
            tooltipText = tooltipText .. "\n|cff20a0ff" .. string.format(L["REPUTATION_UNTIL_STANDING"], nextStanding, BreakUpLargeNumbers(max - value));
            if (standingID < 7) then
                tooltipText = tooltipText .. "\n|cff20a0ff" .. string.format(L["REPUTATION_UNTIL_STANDING"], maxStanding, BreakUpLargeNumbers(repToExalted - value));
            end
        --end

        -- add session earning info to tooltip
        --if (not paragonValue and (standingID < 8)) then
            if (earnedThisSession > 0) then tooltipText = tooltipText .. "\n|cff20a0ff" .. string.format(L["REPUTATION_THIS_SESSION"], (earnedValue - REP_SESSIONS[repName].start)); end
            if (repPerHour > 0) then
                tooltipText = tooltipText .. "\n|cff20a0ff" .. string.format(L["REPUTATION_PER_HOUR"], repPerHour);

                timeToNextLevel = ((max - value) / repPerHour) * 3600;
                tooltipText = tooltipText .. "\n\n" .. string.format(L["TIME_UNTIL_STANDING"], nextStanding) .. ": " .. TrackOMatic_TimeCounter(timeToNextLevel);

                if (standingID < 8) then
                    timeToExalted = ((repToExalted - value) / repPerHour) * 3600;
                    if (standingID < 7) then
                        tooltipText = tooltipText .. "\n" .. string.format(L["TIME_UNTIL_STANDING"], maxStanding) .. ": " .. TrackOMatic_TimeCounter(timeToExalted);
                    end
                end

                -- show earned per hour on bar
                if (TRACKOMATIC_VARS['config']['rep_gain_display'] == 1) then
                    levelLabel = levelLabel .. " (" .. repPerHour .. "/hr)";
                -- time until next level
                elseif ((TRACKOMATIC_VARS['config']['rep_gain_display'] == 2) and (standingID < 8)) then
                    levelLabel = levelLabel .. " (" .. TrackOMatic_TimeCounter(timeToNextLevel, true) .. ")";
                -- time until exalted
                elseif ((TRACKOMATIC_VARS['config']['rep_gain_display'] == 3) and (standingID < 8)) then
                    levelLabel = levelLabel .. " (" .. TrackOMatic_TimeCounter(timeToExalted, true) .. ")";
                end
            else
                tooltipText = tooltipText .. "\n|cff20a0ff" .. string.format(L["REPUTATION_PER_HOUR"], "N/A");
            end
        --end

        menu = {
            TrackOMatic_CommonMenuItem("RESET_SESSION", function() TrackOMatic_ReputationResetSession(repName); end),
        };

        color = FACTION_BAR_COLORS[standingID];
        
    else
    
        return;
    
        --label = string.format(L["UNDEFINED"]);
        --max = 1;
        --value = 1;
        --color = {r = 0.5, g = 0.5, b = 0.5};
        
    end
    
    return value, max, color, label, levelLabel, tooltipTitle, tooltipText, repName, menu, nil, isGlowing;
end

--========================================
-- Remove a reputation from the tracker
--========================================
function TrackOMatic_RemoveRep(index, isSilent)
    local data = TrackOMatic_RemoveFromCategory("rep", index);
    if ((not isSilent) and data) then
        if (data.isPlugin) then
            if (data.name) then TrackOMatic_Message(string.format(L["TRACKER_REMOVE_PLUGIN"], data.name)); end
        else
            local repName = GetFactionInfoByID(data.id);
            if (repName) then TrackOMatic_Message(string.format(L["TRACKER_REMOVE_REP"], repName)); end
        end
    end
end

--========================================
-- Get a reputation's index by name
--========================================
function TrackOMatic_GetRepID(name)
    local numLines = GetNumFactions();
    
    for i = 1, numLines, 1 do
        local repName, repDesc, standingID, bottomValue, topValue, earnedValue, atWarWith, canToggleAtWar, header, isCollapsed, hasRep, isWatched, isChild, factionID = GetFactionInfo(i);
        if (hasRep or (not header)) then
            --if (string.find(string.lower(repName), string.lower(name)) ~= nil) then
            if (string.sub(string.lower(repName), 0, string.len(name)) == string.lower(name)) then
                return factionID, repName;
            end
        end
    end
    return nil;
end

--function TrackOMatic_GetRepNameByID(id)
--    --local numLines = GetNumFactions();
--    --
--    --for i = 1, numLines, 1 do
--    --    local repName, repDesc, standingID, bottomValue, topValue, earnedValue, atWarWith, canToggleAtWar, header, isCollapsed, hasRep, isWatched = GetFactionInfo(i);
--    --    if (hasRep or (not header)) then
--    --        --if (string.find(string.lower(repName), string.lower(name)) ~= nil) then
--    --        if (string.sub(string.lower(repName), 0, string.len(name)) == string.lower(name)) then
--    --            return i, repName;
--    --        end
--    --    end
--    --end
--    local name = GetFactionInfoByID(id);
--    if (name) then return id, name; end
--    
--    return nil;
--end

--========================================
-- Generate a turn-in entry for rep
-- tooltips
--========================================
function TrackOMatic_GetRepTurninInfo(itemId, numItemPerTurnin, repPerTurnin, repNeeded, gainMult)

    -- calculate the character's rep gain multiplier (factor in buffs like human racial, guild perks)
    local _T, questRepMod = TrackOMatic_GetReputationMultipliers();
    local gainMult = (gainMult or 1) - 1;
    -- get final rep per turnin
    local modifiedRepPerTurnin = math.floor(repPerTurnin * (questRepMod + gainMult));
    local hasItems, itemsNeeded, turninStatusColor;
    -- total number of turnins needed to reach next level
    local turninCount = math.ceil(repNeeded / modifiedRepPerTurnin);

    -- get item link from id, format an empty item string if no link found
    local itemLink = TrackOMatic_GetItemLink(itemId);
    hasItems = GetItemCount(itemLink);
    if (not itemLink) then
        itemLink = "|cffff0000[" .. string.format(L["ITEM_NUMBER"], itemId) .. "]|r";
    end

    -- how many turnins worth the character has, and how many items needed to reach next level
    local hasTurnins = math.floor(hasItems / numItemPerTurnin);
    itemsNeeded = (numItemPerTurnin * turninCount);

    -- color turnin count (white if has enough items to reach next level, gray if not)
    if (hasItems >= itemsNeeded) then
        turninStatusColor = "ffffffff";
    else
        turninStatusColor = "ff808080";
    end

    -- format multiplier text
    local itemMult = "";
    if (numItemPerTurnin > 1) then
        itemMult = "|cff00a000x" .. numItemPerTurnin;
    end

    return itemLink .. itemMult .. "|r: " .. turninCount .. " |c" .. turninStatusColor .. "(" .. hasItems .. "/" .. itemsNeeded .. ")|r";

end

--========================================
-- Get total reputation required to
-- reach exalted from current standing
--========================================
function TrackOMatic_GetRepToExalted(standingID)

    local totalToExalted = 0;
    if (standingID < 8) then
        for i = standingID, 7, 1 do
            totalToExalted = totalToExalted + TRACKOMATIC_MAX_REP[i];
        end
    end
    return totalToExalted;

end

--========================================
-- Handler for clicking the button on
-- the reputation detail frame
--========================================
function TrackOMatic_AddRepButton_OnClick(self)
    TrackOMatic_AddRep(ReputationDetailFactionName:GetText());
end

--========================================
-- Calculate GLOBAL reputation gain
-- modifiers (human racial, etc)
--========================================
function TrackOMatic_GetReputationMultipliers()

    local kbonus = 0;
    local qbonus = 0;

    if (TrackOMatic_UnitHasAura("player", L["BUFF_WOW7THANNIVERSARY"])) then
        kbonus = kbonus + 7;
    end

    local race, raceEn = UnitRace("player");
    if (raceEn == "Human") then
        kbonus = kbonus + 10;
        qbonus = qbonus + 10;
    end

    return (100 + kbonus) / 100, (100 + qbonus) / 100;

end

--========================================
-- Generate a counter for mob kills
-- needed to gain a specified amount of
-- reputation
--========================================
function TrackOMatic_ReputationMobKillCounter(repPerKill, repNeeded, gainMult)

    local killRepMod = TrackOMatic_GetReputationMultipliers();
    local gainMult = (gainMult or 1) - 1;
    repPerKill = math.floor(repPerKill * (killRepMod + gainMult));

    local kills = "??";
    if (repPerKill > 0) then
        kills = math.ceil(repNeeded / repPerKill);
    end

    return string.format(L["MOB_KILLS"], kills);

end

--========================================
-- Generate a counter for a quest-based
-- source of reputation in order to gain
-- a specified amount
--========================================
function TrackOMatic_ReputationQuestCounter(label, repGain, repNeeded, questIconType, gainMult)

    local _T, questMod = TrackOMatic_GetReputationMultipliers();
    local gainMult = (gainMult or 1) - 1;
    repGain = math.floor(repGain * (questMod + gainMult));

    questIconType = (questIconType or 0);
    local label = label;
    if (questIconType == 1) then
        label = questIconNormal .. " " .. label;
    elseif (questIconType == 2) then
        label = questIconDaily .. " " .. label;
    end

    return label .. ": " .. (math.ceil(repNeeded / repGain));
    
end

--========================================
-- Generate a counter for a gold
-- donation-based source of reputation in
-- order to gain a specified amount
--========================================
function TrackOMatic_ReputationDonationCounter(label, repGain, repNeeded, donationAmount, isDaily, gainMult)

    local _T, questMod = TrackOMatic_GetReputationMultipliers();
    local gainMult = (gainMult or 1) - 1;
    repGain = math.floor(repGain * (questMod + gainMult));
    
    local label = label;
    if (isDaily) then
        label = questIconDaily .. " " .. label;
    end

    return label .. ": " .. TrackOMatic_FormatStringMoney(math.ceil(repNeeded / repGain) * donationAmount);

end

function TrackOMatic_ReputationResetSession(name)
    if (TRACKOMATIC_REP_FIRSTUPDATE[name] or TRACKOMATIC_STARTING_REP[name]) then
        TRACKOMATIC_REP_FIRSTUPDATE[name] = nil;
        TRACKOMATIC_STARTING_REP[name] = nil;
        TrackOMatic_Message(string.format(L["MESSAGE_REP_SESSION_RESET"], name));
        TrackOMatic_UpdateTracker(1);
    end
end

function TrackOMatic_DisplayReputationData(data, standing, remainingRep, level, hasBonus)
    local out = "";
    level = level or 0;
    local bonusPercent = (data.bonusGainPrecent or 100);
    local bonusMult = (1 + (bonusPercent / 100));
    local actualMult = 1;
    if (hasBonus) then
        actualMult = bonusMult;
    end
    for index, entry in pairs(data) do
        local line = "";
        if ((standing >= (entry.minStanding or 0)) and (standing <= (entry.maxStanding or 8))) then
            -- determine what text to show on this line
            if (entry.text) then
                if ((entry.repGain or 0) > 0) then
                    if (entry.isGoldDonation) then
                        line = TrackOMatic_ReputationDonationCounter(entry.text, (entry.repGain or 0), remainingRep, (entry.moneyRequired or 0), entry.isDaily, actualMult);
                    else
                        local qicon = 0;
                        if (entry.isQuest) then
                            qicon = 1;
                            if (entry.isDaily) then qicon = 2; end
                        end
                        line = TrackOMatic_ReputationQuestCounter(entry.text, (entry.repGain or 0), remainingRep, qicon, actualMult);
                    end
                else
                    line = entry.text;
                end
            elseif (entry.itemId) then
                line = TrackOMatic_GetRepTurninInfo(entry.itemId, entry.itemCount or 1, entry.repGain or 0, remainingRep, actualMult);
            end
            -- start new line
            if ((out ~= "") or (level > 0)) then out = out .. "\n"; end
            -- add text with level indentation
            out = out .. string.rep("   ", level + 1) .. line;
            -- cycle through subitems, if any
            if (entry.subItems) then
                out = out .. TrackOMatic_DisplayReputationData(entry.subItems, standing, remainingRep, level + 1, hasBonus);
            end
        end
    end
    return out;
end

function TrackOMatic_HookReputationDetailFrame()

    HOOKS["ReputationFrame_Update"] = ReputationFrame_Update;
    ReputationFrame_Update = TrackOMatic_Hook_ReputationFrame_Update;

end

function TrackOMatic_Hook_ReputationFrame_Update(...)

    HOOKS["ReputationFrame_Update"](...);

    local height = 203;
    --if (ReputationDetailLFGBonusReputationCheckBox:IsVisible()) then height = height + 22; end
    ReputationDetailFrame:SetHeight(height + 35);

end
