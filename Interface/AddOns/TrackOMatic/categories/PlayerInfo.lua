local L = LibStub("AceLocale-3.0"):GetLocale("TrackOMatic", true);

local PLAYER_INFO_IDS = {
    ["xp"] = L["PLAYER_INFO_XP"],
    ["grind"] = L["PLAYER_INFO_KILLS_TO_LEVEL"],
    ["quest"] = L["PLAYER_INFO_QUESTS_TO_LEVEL"],
    ["gold"] = L["PLAYER_INFO_GOLD"],
    ["durability"] = L["PLAYER_INFO_DURABILITY"],
    ["honor"] = L["PLAYER_INFO_HONOR"],
    ["timetolevel"] = L["PLAYER_INFO_TIME_TO_LEVEL"],
};

-- initialize kills to level data
TRACKOMATIC_GRIND = {
    ["mobs_killed"] = 0;
    ["xp_gained"] = 0;
    ["xp_per_kill"] = 0;
    ["mobs_remaining"] = 0;
    ["avg_units"] = 0;
    ["last_kill_xp"] = 0;
};
-- initialize quests to level data
TRACKOMATIC_QUEST = {
    ["quests_completed"] = 0;
    ["xp_gained"] = 0;
    ["xp_per_quest"] = 0;
    ["quests_remaining"] = 0;
    ["avg_units"] = 0;
};

TRACKOMATIC_FIRST_MONEY_UPDATE = true;

local XP_SESSION_START_TIME = 0;
local XP_SESSION_START_XP = 0;

--========================================
-- Update a player info bar
--========================================
function TrackOMatic_SetPlayerBar(data)

    local value, max, color, label, levelLabel, tooltipTitle, tooltipText, menuTitle, clickFunc;

    tooltipTitle = "";
    tooltipText = "";

    local menu = {};
    local isGlowing = false;
    local glowColor = {r = 1, g = 1, b = 0};

    -- ==================== Experience Bar ==================== --
    if (data.id == "xp") then
        -- set default label and tooltip title
        label = string.format(L["XP_LEVEL"], UnitLevel("player"));
        tooltipTitle = L["XP_TOOLTIP"];

        -- gray out the bar if the player is level capped
        if (UnitLevel("player") == TrackOMatic_GetLevelCap()) then
            max = 1;
            value = 1;
            color = {r = 0.5, g = 0.5, b = 0.5};
            levelLabel = L["MAX_LEVEL"];
            tooltipText = L["YOU_ARE_AT_MAX_LEVEL"];
        else
            max = math.max(1, UnitXPMax("player"));
            value = UnitXP("player");
            levelLabel = (math.floor((value / max) * 10000) / 100) .. "%";
            tooltipText = string.format(L["CURRENT_XP"], BreakUpLargeNumbers(value) .. " / " .. BreakUpLargeNumbers(max)) .. " (" .. (math.floor((value / max) * 10000) / 100) .. "%)\n";
            tooltipText = tooltipText .. string.format(L["XP_TO_LEVEL"], BreakUpLargeNumbers(UnitXPMax("player") - UnitXP("player"))) .. " (" .. (math.floor(((UnitXPMax("player") - UnitXP("player")) / max) * 10000) / 100) .. "%)";
            local xpStatus = "";
            -- check rested state
            if (GetXPExhaustion()) then
                xpStatus = L["RESTED"];
                color = {r = 0, g = 0.5, b = 1};
                tooltipText = tooltipText .. "\n" .. string.format(L["RESTED_AMOUNT"], BreakUpLargeNumbers(GetXPExhaustion())) .. " (" .. (TrackOMatic_Round((GetXPExhaustion() / max) * 10000) / 100) .. "%)";
                -- rested xp is capped at 150% of the current level's total xp
                if (GetXPExhaustion() == (UnitXPMax("player") * 1.5)) then
                    tooltipText = tooltipText .. "\n|cff00ff00" .. L["FULLY_RESTED"] .. "|r";
                end
            -- not rested
            else
                color = {r = 0.5, g = 0, b = 0.5};
            end
            -- turn bar gray if xp is disabled
            --if (IsXPUserDisabled()) then
            --    xpStatus = L["DISABLED"];
            --    color = {r = 0.5, g = 0.5, b = 0.5};
            --    tooltipText = tooltipText .. "\n\n|cff20a0ff" .. L["XP_GAIN_DISABLED"] .. "|r";
            --end
            if (xpStatus ~= "") then
                label = label .. " (" .. xpStatus .. ")";
            end
        end

        menuTitle = L["PLAYER_INFO_XP"];

    -- ==================== Mob Grinding Bar ==================== --
    elseif (data.id == "grind") then
        -- set default label
        label = L["KILLS_UNTIL_LEVEL_UP"];
        -- check if level capped
        if (UnitLevel("player") == TrackOMatic_GetLevelCap()) then
            levelLabel = L["MAX_LEVEL"];
            max = 1;
            value = 1;
            color = {r = 0.5, g = 0.5, b = 0.5};
            tooltipTitle = string.format(L["KILLS_UNTIL_LEVEL_UP_TOOLTIP"], "N/A");
            tooltipText = L["YOU_ARE_AT_MAX_LEVEL"];
        else
            color = {r = 1, g = 0.4, b = 0}
            -- if there is calculated info
            if ((TRACKOMATIC_GRIND['xp_per_kill'] > 0) and (TRACKOMATIC_GRIND['last_kill_xp'] > 0)) then
                local avg = (TRACKOMATIC_GRIND['xp_per_kill'] + TRACKOMATIC_GRIND['last_kill_xp']) / 2;
                -- smart average
                if (TRACKOMATIC_VARS['config']['mob_grind_estimation_mode'] == 0) then
                    TRACKOMATIC_GRIND['mobs_remaining'] = math.ceil((UnitXPMax("player") - UnitXP("player")) / avg);
                -- basic average
                elseif (TRACKOMATIC_VARS['config']['mob_grind_estimation_mode'] == 1) then
                    TRACKOMATIC_GRIND['mobs_remaining'] = math.ceil((UnitXPMax("player") - UnitXP("player")) / TRACKOMATIC_GRIND['xp_per_kill']);
                -- last kill only
                elseif (TRACKOMATIC_VARS['config']['mob_grind_estimation_mode'] == 2) then
                    TRACKOMATIC_GRIND['mobs_remaining'] = math.ceil((UnitXPMax("player") - UnitXP("player")) / TRACKOMATIC_GRIND['last_kill_xp']);
                end
                max = TRACKOMATIC_GRIND['mobs_killed'] + TRACKOMATIC_GRIND['mobs_remaining'];
                if (TRACKOMATIC_VARS['config']['reverse_leveling_bars']) then
                    value = TRACKOMATIC_GRIND['mobs_remaining'];
                else
                    value = TRACKOMATIC_GRIND['mobs_killed'];
                end
                levelLabel = TRACKOMATIC_GRIND['mobs_remaining'] .. " (" .. string.format(L["KILLS_TO_LEVEL_MOBS_KILLED"], TRACKOMATIC_GRIND['mobs_killed']) .. ")";
                tooltipTitle = string.format(L["KILLS_UNTIL_LEVEL_UP_TOOLTIP"], TRACKOMATIC_GRIND['mobs_remaining']);
                tooltipText = string.format(L["XP_LAST_KILL"], TRACKOMATIC_GRIND['last_kill_xp']) .. "\n" ..
                              string.format(L["XP_PER_KILL"], (math.floor(TRACKOMATIC_GRIND['xp_per_kill'] * 100) / 100)) .. "\n" ..
                              string.format(L["XP_TO_LEVEL"], (UnitXPMax("player") - UnitXP("player"))) .. " (" .. (math.floor(((UnitXPMax("player") - UnitXP("player")) / math.max(1, UnitXPMax("player"))) * 10000) / 100) .. "%)";
            -- no xp from kills = no calculations
            else
                max = 1;
                value = 0;
                levelLabel = "N/A (" .. string.format(L["KILLS_TO_LEVEL_MOBS_KILLED"], 0) .. ")";
                tooltipTitle = string.format(L["KILLS_UNTIL_LEVEL_UP_TOOLTIP"], "N/A");
                tooltipText = L["KILLS_TO_LEVEL_NO_INFO"];
            end
        end

        clickFunc = TrackOMatic_Player_ClickGrindBar;
        menuTitle = L["PLAYER_INFO_KILLS_TO_LEVEL"];
        menu = {
            TrackOMatic_CommonMenuItem("RESET_SESSION", TrackOMatic_ResetKillSession),
        };

    -- ==================== Quest Bar ==================== --
    elseif (data.id == "quest") then
        -- default label
        label = "Quests until Level Up";
        if (UnitLevel("player") == TrackOMatic_GetLevelCap()) then
            levelLabel = L["MAX_LEVEL"];
            max = 1;
            value = 1;
            color = {r = 0.5, g = 0.5, b = 0.5};
            tooltipTitle = string.format(L["QUESTS_UNTIL_LEVEL_UP_TOOLTIP"], "N/A");
            tooltipText = L["YOU_ARE_AT_MAX_LEVEL"];
        else
            color = {r = 0.875, g = 0.75, b = 0}
            if (TRACKOMATIC_QUEST['xp_per_quest'] > 0) then
                TRACKOMATIC_QUEST['quests_remaining'] = math.ceil((UnitXPMax("player") - UnitXP("player")) / TRACKOMATIC_QUEST['xp_per_quest']);
                max = TRACKOMATIC_QUEST['quests_completed'] + TRACKOMATIC_QUEST['quests_remaining'];
                if (TRACKOMATIC_VARS['config']['reverse_leveling_bars']) then
                    value = TRACKOMATIC_QUEST['quests_remaining'];
                else
                    value = TRACKOMATIC_QUEST['quests_completed'];
                end
                levelLabel = TRACKOMATIC_QUEST['quests_remaining'] .. " (" .. string.format(L["QUESTS_TO_LEVEL_COMPLETED"], TRACKOMATIC_QUEST['quests_completed']) .. ")";
                tooltipTitle = string.format(L["QUESTS_UNTIL_LEVEL_UP_TOOLTIP"], TRACKOMATIC_QUEST['quests_remaining']);
                tooltipText = string.format(L["XP_PER_QUEST"], (math.floor(TRACKOMATIC_QUEST['xp_per_quest'] * 100) / 100)) .. "\n"
                tooltipText = tooltipText .. string.format(L["XP_TO_LEVEL"], (UnitXPMax("player") - UnitXP("player"))) .. " (" .. (math.floor(((UnitXPMax("player") - UnitXP("player")) / math.max(1, UnitXPMax("player"))) * 10000) / 100) .. "%)";
            else
                max = 1;
                value = 0;
                levelLabel = "N/A (" .. string.format(L["QUESTS_TO_LEVEL_COMPLETED"], 0) .. ")";
                tooltipTitle = string.format(L["QUESTS_UNTIL_LEVEL_UP_TOOLTIP"], "N/A");
                tooltipText = L["QUESTS_TO_LEVEL_NO_INFO"];
            end
        end

        clickFunc = TrackOMatic_Player_ClickQuestBar;
        menuTitle = L["PLAYER_INFO_QUESTS_TO_LEVEL"];
        menu = {
            TrackOMatic_CommonMenuItem("RESET_SESSION", TrackOMatic_ResetQuestSession),
        };
        
    --elseif (data.id == "timetolevel") then
    --
    --    local plevel = UnitLevel("player");
    --    local xp = UnitXP("player");
    --    local xpmax = UnitXPMax("player");
    --    
    --    local gained = 0;
    --    -- player has leveled up since last update
    --    if (plevel > TrackOMatic.XPSessionLastLevel) then
    --        gained = (TrackOMatic.XPSessionMaxXP - TrackOMatic.XPSessionLastXP) + xp;
    --    elseif (xp > TrackOMatic.XPSessionLastXP) then
    --        gained = xp - TrackOMatic.XPSessionLastXP;
    --    end
    --    if (gained > 0) then TrackOMatic.XPSessionGainedXP = TrackOMatic.XPSessionGainedXP + gained; end
    --    
    --    local xpPerHour = math.floor(TrackOMatic.XPSessionGainedXP / ((GetTime() - TrackOMatic.XPSessionStartTime) / 3600));
    --    
    --    TrackOMatic.XPSessionLastXP = xp;
    --    TrackOMatic.XPSessionMaxXP = xpmax;
    --    TrackOMatic.XPSessionLastLevel = plevel;

    -- ==================== Gold Tracker Bar ==================== --
    elseif (data.id == "gold") then
        local currentMoney = GetMoney();

        tooltipTitle = string.format(L["CURRENT_GOLD"], TrackOMatic_FormatStringMoney(currentMoney));
        tooltipText = string.format(L["GOLD_SESSION_START"], "|cffffffff" .. TrackOMatic_FormatStringMoney(TrackOMatic.StartingGold) .. "|r");

        label = L["GOLD"];
        if (currentMoney > TrackOMatic.StartingGold) then
            color = {r = 0, g = 1, b = 0}
            max = currentMoney;
            value = (currentMoney - TrackOMatic.StartingGold);
            levelLabel = TrackOMatic_FormatStringMoney(currentMoney) .. " (|cff00ff00+" .. TrackOMatic_FormatStringMoney(currentMoney - TrackOMatic.StartingGold, "00ff00") .. "|r)";
            tooltipText = tooltipText .. "\n|cff00ff00" .. string.format(L["EARNED_THIS_SESSION"], "|cffffffff" .. TrackOMatic_FormatStringMoney(currentMoney - TrackOMatic.StartingGold) .. "|r");
        elseif (currentMoney < TrackOMatic.StartingGold) then
            color = {r = 1, g = 0, b = 0}
            max = TrackOMatic.StartingGold;
            value = TrackOMatic.StartingGold - currentMoney;
            levelLabel = TrackOMatic_FormatStringMoney(currentMoney) .. " (|cffffff00-" .. TrackOMatic_FormatStringMoney(TrackOMatic.StartingGold - currentMoney, "ffff00") .. "|r)";
            tooltipText = tooltipText .. "\n|cffff0000" .. string.format(L["LOST_THIS_SESSION"], "|cffffffff" .. TrackOMatic_FormatStringMoney(TrackOMatic.StartingGold - currentMoney) .. "|r");
            if (TRACKOMATIC_VARS['config']['gold_glow_negative']) then
                isGlowing = true;
            end
        else
            color = {r = 0.75, g = 0.75, b = 0.75}
            max = 1;
            value = 0;
            levelLabel = TrackOMatic_FormatStringMoney(currentMoney);
        end

        clickFunc = TrackOMatic_Player_ClickGoldBar;
        menuTitle = L["PLAYER_INFO_GOLD"];
        menu = {
            TrackOMatic_CommonMenuItem("RESET_SESSION", TrackOMatic_Player_ResetGoldSession),
        };

    -- ==================== Equipment Durability Bar ==================== --
    elseif (data.id == "durability") then

        max = 100;
        local averageDura, numEquipped, lowestDura, breakingItems, brokenItems, duraHead, duraShoulder, duraChest, duraWrist, duraHands, duraWaist, duraLegs, duraFeet, duraMainHand, duraOffHand, duraRanged = TrackOMatic_GetDurabilityInfo();

        tooltipTitle = string.format(L["EQUIPPED_ITEM_DURABILITY"], value);
        tooltipText = "";

        if (numEquipped > 0) then
            if (TRACKOMATIC_VARS['config']['show_lowest_durability']) then
                value = lowestDura;
                label = L["LOWEST_DURABILITY"];
            else
                value = averageDura;
                label = L["AVERAGE_DURABILITY"];
            end
            local barValue = value;
            levelLabel = value .. "%";

            color = {r = 0, g = 0.75, b = 0};
            if (brokenItems > 0) then
                color = {r = 1, g = 0.5, b = 0};
                if (TRACKOMATIC_VARS['config']['durability_glow_broken']) then
                    isGlowing = true;
                end
            else
                if (breakingItems > 0) then
                    color = {r = 0.9, g = 0.9, b = 0};
                end
            end
            if (brokenItems + breakingItems > 0) then
                levelLabel = levelLabel .. " |cffffff00(" .. (brokenItems + breakingItems) .. ")";
            end

            tooltipText = L["AVERAGE_DURABILITY"] .. ": " .. averageDura .. "%\n" .. L["LOWEST_DURABILITY"] .. ": " .. lowestDura .. "%\n";
            if (breakingItems + brokenItems > 0) then
                tooltipText = tooltipText .. "|cffff8000" .. string.format(L["BREAKING_ITEMS"], (breakingItems + brokenItems)) .. "|r\n";
            end
            if (duraHead) then
                tooltipText = tooltipText .. "\n" .. string.format(L["DURA_HEAD"], duraHead.text);
            end
            if (duraShoulder) then
                tooltipText = tooltipText .. "\n" .. string.format(L["DURA_SHOULDER"], duraShoulder.text);
            end
            if (duraChest) then
                tooltipText = tooltipText .. "\n" .. string.format(L["DURA_CHEST"], duraChest.text);
            end
            if (duraWrist) then
                tooltipText = tooltipText .. "\n" .. string.format(L["DURA_WRIST"], duraWrist.text);
            end
            if (duraHands) then
                tooltipText = tooltipText .. "\n" .. string.format(L["DURA_HANDS"], duraHands.text);
            end
            if (duraWaist) then
                tooltipText = tooltipText .. "\n" .. string.format(L["DURA_WAIST"], duraWaist.text);
            end
            if (duraLegs) then
                tooltipText = tooltipText .. "\n" .. string.format(L["DURA_LEGS"], duraLegs.text);
            end
            if (duraFeet) then
                tooltipText = tooltipText .. "\n" .. string.format(L["DURA_FEET"], duraFeet.text);
            end
            if (duraMainHand) then
                tooltipText = tooltipText .. "\n" .. string.format(L["DURA_MAINHAND"], duraMainHand.text);
            end
            if (duraOffHand) then
                tooltipText = tooltipText .. "\n" .. string.format(L["DURA_OFFHAND"], duraOffHand.text);
            end
            if (duraRanged) then
                tooltipText = tooltipText .. "\n" .. string.format(L["DURA_RANGED"], duraRanged.text);
            end
            if (value == 0) then
                color = {r = 1, g = 0, b = 0};
                value = 100;
            end
        else
            value = 1;
            max = 1;
            color = {r = 0.5, g = 0.5, b = 0.5};
            levelLabel = "N/A";
            tooltipText = L["NO_DURABILITY_EQUIPPED"];
            if (TRACKOMATIC_VARS['config']['show_lowest_durability']) then
                label = L["LOWEST_DURABILITY"];
            else
                label = L["AVERAGE_DURABILITY"];
            end
        end

        menuTitle = L["PLAYER_INFO_DURABILITY"];
        menu = {
            {text = L["SHOW_AVERAGE"], checked = (not TRACKOMATIC_VARS['config']['show_lowest_durability']), func = function() TrackOMatic_SetDurabilityMode(0); end},
            {text = L["SHOW_LOWEST"], checked = TRACKOMATIC_VARS['config']['show_lowest_durability'], func = function() TrackOMatic_SetDurabilityMode(1); end},
        };
        
    elseif (data.id == "honor") then
    
        local playerFaction = UnitFactionGroup("player");
        --max = math.max(1, UnitHonorMax("player"));
        max = 1;
        value = GetPVPRankProgress(); --UnitHonor("player");
        if (playerFaction == "Alliance") then
            color = {r = 0.3, g = 0.3, b = 1};
        elseif (playerFaction == "Horde") then
            color = {r = 1, g = 0, b = 0};
        end
        
        --local dispPrestige = "N/A";
        --local prestige = UnitPrestige("player");
        --if (prestige > 0) then dispPrestige = prestige; end

        local rankName, rankNumber = GetPVPRankInfo(UnitPVPRank("player"));
        
        local honorLevel = 0; --UnitHonorLevel("player");
        local hks, dks, highestRank = GetPVPLifetimeStats();
        
        label = L["PLAYER_INFO_HONOR"];
        if (rankName) then
            levelLabel = string.format(L["HONOR_RANK"], rankName, rankNumber);
            tooltipText = string.format(L["HONOR_RANK"], rankName, rankNumber);
        else
            levelLabel = L["HONOR_NO_RANK"];
        end
        tooltipTitle = L["PLAYER_INFO_HONOR"];
        tooltipText = tooltipText .. string.format(L["PROGRESS_TO_NEXT_RANK"], floor(value * 100)) .. "\n\n" .. string.format(L["HONORABLE_KILLS"], BreakUpLargeNumbers(hks)) .. "\n" .. string.format(L["HONORABLE_KILLS"], BreakUpLargeNumbers(hks)) .. "\n" .. string.format(L["HIGHEST_RANK"], highestRank);
        menuTitle = L["PLAYER_INFO_HONOR"];
        
    else
        max = 1;
        value = 1;
        color = {r = 0.5, g = 0.5, b = 0.5};
        label = L["UNDEFINED"];
    end

    return value, max, color, label, levelLabel, tooltipTitle, tooltipText, menuTitle, menu, clickFunc, isGlowing, glowColor;
end

--========================================
-- Add an entry to the player info
-- category
--========================================
function TrackOMatic_AddPlayerInfo(id, isPlugin)
    if (isPlugin) then
        TrackOMatic_AddPlugin(id, "player");
    else
        if (not PLAYER_INFO_IDS[id]) then
            return;
        end
        if (TrackOMatic_AddToCategory("player", {id = id, isPlugin = isPlugin})) then
            TrackOMatic_Message(string.format(L["TRACKER_ADD_PLAYER"], TrackOMatic_GetPlayerLabel(id)));
        end
    end
end

--========================================
-- Remove a player info bar
--========================================
function TrackOMatic_RemovePlayer(index, isSilent)
    local data = TrackOMatic_RemoveFromCategory("player", index);
    if ((not isSilent) and data) then
        local name;
        if (data.isPlugin) then
            name = data.name;
        else
            name = TrackOMatic_GetPlayerLabel(data.id);
        end
        if (name) then
            TrackOMatic_Message(string.format(L["TRACKER_REMOVE_PLAYER"], name));
        end
    end
end

--========================================
-- Return a localized label for the
-- specified player info item
--========================================
function TrackOMatic_GetPlayerLabel(id)

    if (PLAYER_INFO_IDS[id]) then
        return PLAYER_INFO_IDS[id];
    end
    return L["UNDEFINED"];

end

--========================================
-- Update Kills to Level Up
--========================================
function TrackOMatic_UpdateGrindInfo(info)
    local xpg;
    for expgain in string.gmatch(info, L["KILL_XP_MATCH"]) do
        xpg = expgain;
    end
    if (not xpg) then
        return;
    end
    xpg = xpg + 0;
    if (xpg > 0) then
        TRACKOMATIC_GRIND['mobs_killed'] = TRACKOMATIC_GRIND['mobs_killed'] + 1;
        TRACKOMATIC_GRIND['avg_units'] = TRACKOMATIC_GRIND['avg_units'] + 1;
        TRACKOMATIC_GRIND['xp_gained'] = TRACKOMATIC_GRIND['xp_gained'] + xpg;
        TRACKOMATIC_GRIND['xp_per_kill'] = TRACKOMATIC_GRIND['xp_gained'] / TRACKOMATIC_GRIND['avg_units'];
        TRACKOMATIC_GRIND['last_kill_xp'] = xpg;
    end
end

--========================================
-- Update Quests to Level Up
--========================================
function TrackOMatic_UpdateQuestInfo(info)
    local xpg;
    for expgain in string.gmatch(info, "Experience gained: (%d+).") do
        xpg = expgain;
    end
    if (not xpg) then
        return;
    end
    xpg = xpg + 0;
    if (xpg > 0) then
        TRACKOMATIC_QUEST['quests_completed'] = TRACKOMATIC_QUEST['quests_completed'] + 1;
        TRACKOMATIC_QUEST['avg_units'] = TRACKOMATIC_QUEST['avg_units'] + 1;
        TRACKOMATIC_QUEST['xp_gained'] = TRACKOMATIC_QUEST['xp_gained'] + xpg;
        TRACKOMATIC_QUEST['xp_per_quest'] = TRACKOMATIC_QUEST['xp_gained'] / TRACKOMATIC_QUEST['avg_units'];
    end
end

--========================================
-- Get character's equipment durability
-- information
--========================================
function TrackOMatic_GetDurabilityInfo()

    local slots = {INVSLOT_HEAD, INVSLOT_SHOULDER, INVSLOT_CHEST, INVSLOT_WRIST, INVSLOT_HAND, INVSLOT_WAIST, INVSLOT_LEGS, INVSLOT_FEET, INVSLOT_MAINHAND, INVSLOT_OFFHAND, INVSLOT_RANGED};
    local duraInfo = {};
    local duraPercent = 0;
    local numItems = 0;
    local breakingItems = 0;
    local brokenItems = 0;
    local lowestItem = 100;

    for index, slot in pairs(slots) do
        local cur, max = GetInventoryItemDurability(slot);
        if (cur and max) then
            numItems = numItems + 1;
            local pct = math.floor((cur / max) * 100);
            if (pct < lowestItem) then
                lowestItem = pct;
            end
            local clr = "|cff00ff00";
            if (pct < 50) then
                clr = "|cffffff00";
                if (pct < 25) then
                    if (cur == 0) then
                        brokenItems = brokenItems + 1;
                        clr = "|cffff0000";
                    else
                        breakingItems = breakingItems + 1;
                        clr = "|cffff8000";
                    end
                end
            end

            duraInfo[index] = {text = clr .. cur .. "/" .. max .. "|r (" .. pct .. "%)", cur = cur, max = max, percent = pct};
            duraPercent = duraPercent + pct;
        else
            duraInfo[index] = false;
        end
    end

    return math.floor(duraPercent / math.max(1, numItems)), numItems, lowestItem, breakingItems, brokenItems, unpack(duraInfo);

end


--========================================
-- Handler for clicking the Kills to
-- Level Up bar
--========================================
function TrackOMatic_Player_ClickGrindBar()
    if (IsShiftKeyDown()) then
    end
end

--========================================
-- Handler for clicking the Quests to
-- Level Up bar
--========================================
function TrackOMatic_Player_ClickQuestBar()
    if (IsShiftKeyDown()) then
    end
end

--========================================
-- Handler for clicking the gold tracker
-- bar
--========================================
function TrackOMatic_Player_ClickGoldBar()
    if (IsShiftKeyDown()) then
        TrackOMatic_Player_ResetGoldSession();
    end
end

--========================================
-- Resets the gold session
--========================================
function TrackOMatic_Player_ResetGoldSession()
    TrackOMatic.StartingGold = GetMoney();
    TrackOMatic_UpdateTracker(1);
    TrackOMatic_Message(L["MESSAGE_GOLD_SESSION_RESET"]);
end

--========================================
-- Resets the Kills to Level Up session
--========================================
function TrackOMatic_ResetKillSession()
    TRACKOMATIC_GRIND['mobs_killed'] = 0;
    TRACKOMATIC_GRIND['xp_gained'] = 0;
    TRACKOMATIC_GRIND['avg_units'] = 0;
    TRACKOMATIC_GRIND['xp_per_kill'] = 0;
    TRACKOMATIC_GRIND['mobs_remaining'] = 0;
    TrackOMatic_UpdateTracker(1);
    TrackOMatic_Message(L["MESSAGE_GRIND_SESSION_RESET"]);
end

--========================================
-- Resets the Quests to Level Up session
--========================================
function TrackOMatic_ResetQuestSession()
    TRACKOMATIC_QUEST['quests_completed'] = 0;
    TRACKOMATIC_QUEST['xp_gained'] = 0;
    TRACKOMATIC_QUEST['avg_units'] = 0;
    TRACKOMATIC_QUEST['xp_per_quest'] = 0;
    TRACKOMATIC_QUEST['quests_remaining'] = 0;
    TrackOMatic_UpdateTracker(1);
    TrackOMatic_Message(L["MESSAGE_QUEST_SESSION_RESET"]);
end

--========================================
-- Switches the durability bar's display
-- type (average/lowest)
--========================================
function TrackOMatic_SetDurabilityMode(mode)
    if (mode == 0) then
        TRACKOMATIC_VARS['config']['show_lowest_durability'] = false;
    elseif (mode == 1) then
        TRACKOMATIC_VARS['config']['show_lowest_durability'] = true;
    end
    TrackOMatic_UpdateTracker(1);
end
