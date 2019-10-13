local L = LibStub("AceLocale-3.0"):GetLocale("TrackOMatic", true);

local PET_INFO_IDS = {
    ["xp"] = L["PET_INFO_XP"],
    ["happiness"] = L["PET_INFO_HAPPINESS"],
    ["grind"] = L["PET_INFO_KILLS_TO_LEVEL"],
    ["timetolevel"] = L["PLAYER_INFO_TIME_TO_LEVEL"],
};

-- initialize kills to level data
TRACKOMATIC_PET_GRIND = {
    ["mobs_killed"] = 0;
    ["xp_gained"] = 0;
    ["xp_per_kill"] = 0;
    ["mobs_remaining"] = 0;
    ["avg_units"] = 0;
    ["last_kill_xp"] = 0;
};

local XP_SESSION_START_TIME = 0;
local XP_SESSION_START_XP = 0;

local happinessLabels = { L["UNHAPPY"], L["CONTENT"], L["HAPPY"] };
local happinessBarColors = { { r = 1, g = 0, b = 0 }, { r = 1, g = 0.875, b = 0 }, { r = 0, g = 0.75, b = 0 } }

--========================================
-- Update a player info bar
--========================================
function TrackOMatic_HunterPet_SetBar(data)

    local value, max, color, label, levelLabel, tooltipTitle, tooltipText, menuTitle, clickFunc;

    tooltipTitle = "";
    tooltipText = "";

    local menu = {};
    local isGlowing = false;
    local glowColor = {r = 1, g = 1, b = 0};

    -- ==================== Experience Bar ==================== --
    if (data.id == "xp") then
        local happiness = TrackOMatic_HunterPet_GetPetInfo();
    
        tooltipTitle = L["XP_TOOLTIP"];
        if (happiness) then
            label = string.format(L["XP_LEVEL"], UnitLevel("pet"));

            -- gray out the bar if the pet is level capped
            if (UnitLevel("pet") == TrackOMatic_GetLevelCap()) then
                max = 1;
                value = 1;
                color = {r = 0.5, g = 0.5, b = 0.5};
                levelLabel = L["MAX_LEVEL"];
                tooltipText = L["PET_IS_AT_MAX_LEVEL"];
            else
                max = math.max(1, UnitXPMax("pet"));
                value = UnitXP("pet");
                levelLabel = (math.floor((value / max) * 10000) / 100) .. "%";
                tooltipText = string.format(L["CURRENT_XP"], BreakUpLargeNumbers(value) .. " / " .. BreakUpLargeNumbers(max)) .. " (" .. (math.floor((value / max) * 10000) / 100) .. "%)\n";
                tooltipText = tooltipText .. string.format(L["XP_TO_LEVEL"], BreakUpLargeNumbers(max - value)) .. " (" .. (math.floor(((max - value) / max) * 10000) / 100) .. "%)";
                color = {r = 0.5, g = 0, b = 0.5};
            end
        else
            label = L["XP_NO_PET"];
            max = 1;
            value = 1;
            levelLabel = "";
            tooltipText = L["NO_PET"];
        end

        menuTitle = L["PET_INFO_XP"];

    -- ==================== Mob Grinding Bar ==================== --
    elseif (data.id == "grind") then
        -- set default label
        label = L["KILLS_UNTIL_LEVEL_UP"];
        -- check if level capped
        if (UnitLevel("pet") == TrackOMatic_GetLevelCap()) then
            levelLabel = L["MAX_LEVEL"];
            max = 1;
            value = 1;
            color = {r = 0.5, g = 0.5, b = 0.5};
            tooltipTitle = string.format(L["KILLS_UNTIL_LEVEL_UP_TOOLTIP"], "N/A");
            tooltipText = L["PET_IS_AT_MAX_LEVEL"];
        else
            color = {r = 1, g = 0.4, b = 0}
            -- if there is calculated info
            if ((TRACKOMATIC_PET_GRIND['xp_per_kill'] > 0) and (TRACKOMATIC_PET_GRIND['last_kill_xp'] > 0)) then
                local avg = (TRACKOMATIC_PET_GRIND['xp_per_kill'] + TRACKOMATIC_PET_GRIND['last_kill_xp']) / 2;
                local xp = UnitXP("pet");
                local xpMax = UnitXPMax("pet");
                -- smart average
                if (TRACKOMATIC_VARS['config']['mob_grind_estimation_mode'] == 0) then
                    TRACKOMATIC_PET_GRIND['mobs_remaining'] = math.ceil((xpMax - xp) / avg);
                -- basic average
                elseif (TRACKOMATIC_VARS['config']['mob_grind_estimation_mode'] == 1) then
                    TRACKOMATIC_PET_GRIND['mobs_remaining'] = math.ceil((xpMax - xp) / TRACKOMATIC_PET_GRIND['xp_per_kill']);
                -- last kill only
                elseif (TRACKOMATIC_VARS['config']['mob_grind_estimation_mode'] == 2) then
                    TRACKOMATIC_PET_GRIND['mobs_remaining'] = math.ceil((xpMax - xp) / TRACKOMATIC_PET_GRIND['last_kill_xp']);
                end
                max = TRACKOMATIC_PET_GRIND['mobs_killed'] + TRACKOMATIC_PET_GRIND['mobs_remaining'];
                if (TRACKOMATIC_VARS['config']['reverse_leveling_bars']) then
                    value = TRACKOMATIC_PET_GRIND['mobs_remaining'];
                else
                    value = TRACKOMATIC_PET_GRIND['mobs_killed'];
                end
                levelLabel = TRACKOMATIC_PET_GRIND['mobs_remaining'] .. " (" .. string.format(L["KILLS_TO_LEVEL_MOBS_KILLED"], TRACKOMATIC_PET_GRIND['mobs_killed']) .. ")";
                tooltipTitle = string.format(L["KILLS_UNTIL_LEVEL_UP_TOOLTIP"], TRACKOMATIC_PET_GRIND['mobs_remaining']);
                tooltipText = string.format(L["XP_LAST_KILL"], TRACKOMATIC_PET_GRIND['last_kill_xp']) .. "\n" ..
                              string.format(L["XP_PER_KILL"], (math.floor(TRACKOMATIC_PET_GRIND['xp_per_kill'] * 100) / 100)) .. "\n" ..
                              string.format(L["XP_TO_LEVEL"], (xpMax - xp)) .. " (" .. (math.floor(((xpMax - xp) / math.max(1, xpMax)) * 10000) / 100) .. "%)";
            -- no xp from kills = no calculations
            else
                max = 1;
                value = 0;
                levelLabel = "N/A (" .. string.format(L["KILLS_TO_LEVEL_MOBS_KILLED"], 0) .. ")";
                tooltipTitle = string.format(L["KILLS_UNTIL_LEVEL_UP_TOOLTIP"], "N/A");
                tooltipText = L["KILLS_TO_LEVEL_NO_INFO"];
            end
        end

        clickFunc = TrackOMatic_HunterPet_ClickGrindBar;
        menuTitle = L["PLAYER_INFO_KILLS_TO_LEVEL"];
        menu = {
            TrackOMatic_CommonMenuItem("RESET_SESSION", TrackOMatic_HunterPet_ResetKillSession),
        };
        
    elseif (data.id == "happiness") then
    
        local happiness, damagePercent, loyaltyRate, loyaltyText = TrackOMatic_HunterPet_GetPetInfo();
    
        label = L["PET_INFO_HAPPINESS"];
        tooltipTitle = L["PET_INFO_HAPPINESS"];
        if (happiness) then
            levelLabel = happinessLabels[happiness];
            tooltipText = loyaltyText .. "\n\n" .. string.format(L["HAPPINESS_TOOLTIP"], happinessLabels[happiness]) .. "\n" ..
                            string.format(L["HAPPINESS_DAMAGE"], damagePercent .. "%") .. "\n" ..
                            (loyaltyRate > 0 and L["GAINING_LOYALTY"] or "|cffff0000" .. L["LOSING_LOYALTY"] .. "|r");
                            
            max = 3;
            value = happiness;
            color = happinessBarColors[happiness];
            isGlowing = ((happiness < 2) or (loyaltyRate < 0));
        else
            levelLabel = "";
            tooltipText = L["NO_PET"];
            
            max = 1;
            value = 1;
            color = {r = 0.5, g = 0.5, b = 0.5};
            isGlowing = false;
        end
        menuTitle = L["PET_INFO_HAPPINESS"];
        
    else
        max = 1;
        value = 1;
        color = {r = 0.5, g = 0.5, b = 0.5};
        label = L["UNDEFINED"];
    end

    return value, max, color, label, levelLabel, tooltipTitle, tooltipText, menuTitle, menu, clickFunc, isGlowing, glowColor;
end

--========================================
-- Add an entry to the hunter pet info
-- category
--========================================
function TrackOMatic_HunterPet_AddBar(id, isPlugin)
    if (isPlugin) then
        TrackOMatic_AddPlugin(id, "pet");
    else
        if (not PET_INFO_IDS[id]) then
            return;
        end
        if (TrackOMatic_AddToCategory("pet", {id = id, isPlugin = isPlugin})) then
            TrackOMatic_Message(string.format(L["TRACKER_ADD_PET"], TrackOMatic_HunterPet_GetLabel(id)));
        end
    end
end

--========================================
-- Remove a hunter pet info bar
--========================================
function TrackOMatic_HunterPet_RemoveBar(index, isSilent)
    local data = TrackOMatic_RemoveFromCategory("pet", index);
    if ((not isSilent) and data) then
        local name;
        if (data.isPlugin) then
            name = data.name;
        else
            name = TrackOMatic_HunterPet_GetLabel(data.id);
        end
        if (name) then
            TrackOMatic_Message(string.format(L["TRACKER_REMOVE_PET"], name));
        end
    end
end

--========================================
-- Return a localized label for the
-- specified player info item
--========================================
function TrackOMatic_HunterPet_GetLabel(id)

    if (PET_INFO_IDS[id]) then
        return PET_INFO_IDS[id];
    end
    return L["UNDEFINED"];

end

--========================================
-- Update Kills to Level Up
--========================================
function TrackOMatic_HunterPet_UpdateGrindInfo(info)
    local xpg;
    for expgain in string.gmatch(info, L["KILL_XP_MATCH"]) do
        xpg = expgain;
    end
    if (not xpg) then
        return;
    end
    xpg = xpg + 0;
    if (xpg > 0) then
        TRACKOMATIC_PET_GRIND['mobs_killed'] = TRACKOMATIC_PET_GRIND['mobs_killed'] + 1;
        TRACKOMATIC_PET_GRIND['avg_units'] = TRACKOMATIC_PET_GRIND['avg_units'] + 1;
        TRACKOMATIC_PET_GRIND['xp_gained'] = TRACKOMATIC_PET_GRIND['xp_gained'] + xpg;
        TRACKOMATIC_PET_GRIND['xp_per_kill'] = TRACKOMATIC_PET_GRIND['xp_gained'] / TRACKOMATIC_PET_GRIND['avg_units'];
        TRACKOMATIC_PET_GRIND['last_kill_xp'] = xpg;
    end
end


--========================================
-- Handler for clicking the Kills to
-- Level Up bar
--========================================
function TrackOMatic_HunterPet_ClickGrindBar()
    if (IsShiftKeyDown()) then
    end
end

--========================================
-- Resets the Kills to Level Up session
--========================================
function TrackOMatic_HunterPet_ResetKillSession()
    TRACKOMATIC_PET_GRIND['mobs_killed'] = 0;
    TRACKOMATIC_PET_GRIND['xp_gained'] = 0;
    TRACKOMATIC_PET_GRIND['avg_units'] = 0;
    TRACKOMATIC_PET_GRIND['xp_per_kill'] = 0;
    TRACKOMATIC_PET_GRIND['mobs_remaining'] = 0;
    TrackOMatic_UpdateTracker(1);
    TrackOMatic_Message(L["MESSAGE_GRIND_SESSION_RESET"]);
end

function TrackOMatic_HunterPet_GetPetInfo()
    local happiness, damagePercent, loyaltyRate = GetPetHappiness();
    local loyaltyText = GetPetLoyalty();
    
    if (TrackOMatic.DebugMode.HunterPet) then
        return TrackOMatic.DebugMode.HunterPet.Happiness or happiness, TrackOMatic.DebugMode.HunterPet.DamagePercent or damagePercent, TrackOMatic.DebugMode.HunterPet.LoyaltyRate or loyaltyRate, TrackOMatic.DebugMode.HunterPet.LoyaltyText or loyaltyText;
    else
        return happiness, damagePercent, loyaltyRate, loyaltyText;
    end
end

function TrackOMatic_HunterPet_Debug_SetHappiness(value)
    local happiness, damagePercent, loyaltyRate = GetPetHappiness();
    local loyaltyText = GetPetLoyalty();
    if (not TrackOMatic.DebugMode.HunterPet) then
        TrackOMatic.DebugMode.HunterPet = {};
    end
    value = math.max(1, math.min(3, value));
    TrackOMatic.DebugMode.HunterPet.Happiness = value;
    TrackOMatic.DebugMode.HunterPet.DamagePercent = (value + 2) * 25;
    TrackOMatic.DebugMode.HunterPet.LoyaltyRate = loyaltyRate or 0;
    TrackOMatic.DebugMode.HunterPet.LoyaltyText = loyaltyText or "(Loyalty Level 1) Rebellious";
end

function TrackOMatic_HunterPet_Debug_SetLoyaltyRate(value)
    local happiness, damagePercent, loyaltyRate = GetPetHappiness();
    local loyaltyText = GetPetLoyalty();
    if (not TrackOMatic.DebugMode.HunterPet) then
        TrackOMatic.DebugMode.HunterPet = {};
    end
    TrackOMatic.DebugMode.HunterPet.Happiness = TrackOMatic.DebugMode.HunterPet.Happiness or happiness;
    --TrackOMatic.DebugMode.HunterPet.DamagePercent = { 75, 100, 125 }[value];
    TrackOMatic.DebugMode.HunterPet.LoyaltyRate = value or loyaltyRate;
    TrackOMatic.DebugMode.HunterPet.LoyaltyText = loyaltyText or "(Loyalty Level 1) Rebellious";
end
