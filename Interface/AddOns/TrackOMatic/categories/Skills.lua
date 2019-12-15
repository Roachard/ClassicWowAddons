local L = LibStub("AceLocale-3.0"):GetLocale("TrackOMatic", true);

local GATHER_CUTOFFRED = 15;
local GATHER_CUTOFFGRAY = 0;

--========================================
-- Update a profession bar
--========================================
function TrackOMatic_SetSkillBar(data)

    TrackOMatic_Skill_ExpandAllForUpdate();

    -- retrieve skill info
    local skillIndex, skillName = TrackOMatic_Skill_GetSkillIndex(data.id, true);
    if (skillIndex == nil) then
        return;
    end
    local skillName, header, isExpanded, skillRank, numTempPoints, skillModifier, skillMaxRank, isAbandonable, stepCost, rankCost, minLevel, skillCostType, skillDescription = GetSkillLineInfo(skillIndex);
    
    TrackOMatic_Skill_RecollapseHeaders();
    
    -- store the base rank and apply temp points
    local skillRankStart = skillRank;
    skillRank = skillRank + numTempPoints;

    -- update the bar
    local max, value, color, label, levelLabel, tooltipTitle, tooltipText, skillMod;
    local isGlowing = false;

    label = skillName;
    tooltipTitle = "";
    tooltipText = "";
    skillMod = 0;
    
    if (skillMaxRank == 1) then
        max = 1;
        value = 1;
        color = {r = 0.5, g = 0.5, b = 0.5};
        levelLabel = "";
    else
        max = skillMaxRank;
        value = skillRankStart;
        color = {r = 0, g = 0, b = 1};
        if (skillModifier == 0) then
            levelLabel = skillRank .. "/" .. skillMaxRank;
        else
            local tcolor = RED_FONT_COLOR_CODE;
            if (skillModifier > 0) then
                tcolor = GREEN_FONT_COLOR_CODE .. "+";
            end
            levelLabel = skillRank .. " (" .. tcolor .. skillModifier .. FONT_COLOR_CODE_CLOSE .. ")/" .. skillMaxRank;
        end
    end
    
    tooltipTitle = skillName .. " " .. skillRank;
    if (TrackOMatic_Skill_IsProfession(skillName)) then
        if (TrackOMatic_Skill_NewProfessionRankAvailable(skillName, skillRankStart, skillMaxRank, UnitLevel("player")) or TrackOMatic.DebugMode.ProfessionTest) then
            if (TRACKOMATIC_VARS['config']['profession_glow']) then
                isGlowing = true;
            end
            tooltipText = "|cff00ff00" .. L["PROFESSION_NEW_RANK_AVAILABLE"] .. "|r\n";
        end
        
        if (skillName == L["SKINNING"]) then
            local mobLevel, mobBoss = TrackOMatic_Skill_GetSkinnableCreatureLevel(skillRank + skillModifier);
            if (mobBoss) then
                tooltipText = tooltipText .. "\n" .. L["ABLE_TO_SKIN_BOSS_MOBS"];
            else
                tooltipText = tooltipText .. "\n" .. string.format(L["ABLE_TO_SKIN_LEVEL_MOBS"], mobLevel);
            end
        elseif ((skillName == L["MINING"]) or (skillName == L["HERBALISM"])) then
            tooltipText = tooltipText .. "\n" .. L["ABLE_TO_GATHER_NODES"] .. "\n\n" .. TrackOMatic_GetGatherables(skillName, skillRank + skillModifier);
        end
    elseif (TrackOMatic_Skill_IsWeaponSkill(skillName)) then
        -- skill deficiency
        local wmax = (UnitLevel("player") * 5);
        local targetLvl = wmax;
        if (UnitExists("target")) then
            targetLvl = (UnitLevel("target") * 5);
        end

        if ((skillRank + skillModifier) <= wmax) then
            local skillDeficiency = (wmax - (skillRank + skillModifier));
            if (skillDeficiency > 0) then
                tooltipText = tooltipText .. "|cffff0000" .. skillDeficiency .. " skill deficiency|r\n";
            end
        end
        tooltipText = tooltipText .. TrackOMatic_Skill_WeaponSkillDetails(UnitExists("target"), (skillRank + skillModifier), targetLvl);
        
        --if ((skillRank + skillModifier) <= wmax) then
        --    local skillDeficiency = (wmax - (skillRank + skillModifier));
        --    local belowTarget = (targetLvl - (skillRank + skillModifier));
        --    if (skillDeficiency > 0) then
        --        tooltipText = tooltipText .. "|cffff0000" .. skillDeficiency .. " skill deficiency|r\n";
        --    end
        --    tooltipText = tooltipText .. "\n|cffffffffAgainst equal level targets:|r\n";
        --    local enemyParry = 0;
        --    local baseMiss = 0;
        --    if (belowTarget > 10) then
        --        baseMiss = (6 + ((belowTarget - 10) * 0.4));
        --        enemyParry = (6 + ((belowTarget - 10) * 0.4));
        --    else
        --        baseMiss = (5 + (belowTarget * 0.1));
        --        enemyParry = (5 + (belowTarget * 0.1));
        --    end
        --    local baseCrit = math.max(0, (5 - (belowTarget * 0.4)));
        --    local enemyBlock = (5 + (belowTarget * 0.1));
        --    local enemyDodge = (5 + (belowTarget * 0.1));
        --    tooltipText = tooltipText .. "Base Miss chance: " .. baseMiss .. "%\n";
        --    tooltipText = tooltipText .. "Base Critical chance: " .. baseCrit .. "%\n";
        --    tooltipText = tooltipText .. "Base enemy Dodge chance: " .. enemyDodge .. "%\n";
        --    tooltipText = tooltipText .. "Base enemy Parry chance: ~" .. enemyParry .. "%\n";
        --    tooltipText = tooltipText .. "Base enemy Block chance: " .. enemyBlock .. "%\n";
        --    local overallHit = 100 - (enemyDodge + enemyParry + baseMiss);
        --    tooltipText = tooltipText .. "Overall chance to hit: " .. overallHit .. "%\n";
        --else
        --    local skillExcess = (skillRank + skillModifier) - wmax;
        --    tooltipText = tooltipText .. "\n|cffffffffAgainst equal level targets:|r\n";
        --    tooltipText = tooltipText .. "Base Miss chance: " .. math.max(0, (5 - (skillExcess * 0.4))) .. "%\n";
        --    tooltipText = tooltipText .. "Base Critical chance: " .. (5 + (skillExcess * 0.4)) .. "%\n";
        --    tooltipText = tooltipText .. "Base enemy Dodge chance: " .. math.max(0, (5 - (skillExcess * 0.4))) .. "%\n";
        --    tooltipText = tooltipText .. "Base enemy Parry chance: " .. math.max(0, (5 - (skillExcess * 0.4))) .. "%\n";
        --    tooltipText = tooltipText .. "Base enemy Block chance: " .. math.max(0, (5 - (skillExcess * 0.4))) .. "%\n";
        --end
    elseif (skillName == "Defense") then
        local dmax = (UnitLevel("player") * 5);
        if ((skillRank + skillModifier) > dmax) then
            local defExcess = ((skillRank + skillModifier) - dmax);
            tooltipText = tooltipText .. "\n|cffffffffAgainst equal level targets:|r\n";
            tooltipText = tooltipText .. "Base Miss chance: " .. (5 + (defExcess * 0.04)) .. "%\n";
            tooltipText = tooltipText .. "Base Dodge chance: " .. (5 + (defExcess * 0.04)) .. "%\n";
            tooltipText = tooltipText .. "Base Parry chance (before DR): " .. (5 + (defExcess * 0.04)) .. "%\n";
            tooltipText = tooltipText .. "Base Block chance: " .. (5 + (defExcess * 0.04)) .. "%\n";
            tooltipText = tooltipText .. "Enemy Critical chance: " .. math.max(0, (5 - (defExcess * 0.04))) .. "%\n";
        else
            local deficiency = (dmax - (skillRank + skillModifier));
            if (deficiency > 0) then
                tooltipText = tooltipText .. "|cffff0000" .. deficiency .. " skill deficiency|r\n";
            end
            tooltipText = tooltipText .. "\n|cffffffffAgainst equal level targets (PvE):|r\n";
            tooltipText = tooltipText .. "Base Miss chance: " .. math.max(0, (5 - (deficiency * 0.04))) .. "%\n";
            tooltipText = tooltipText .. "Base Dodge chance: " .. math.max(0, (5 - (deficiency * 0.04))) .. "%\n";
            tooltipText = tooltipText .. "Base Parry chance (before DR): " .. math.max(0, (5 - (deficiency * 0.04))) .. "%\n";
            tooltipText = tooltipText .. "Base Block chance: " .. math.max(0, (5 - (deficiency * 0.04))) .. "%\n";
            tooltipText = tooltipText .. "Enemy Critical chance: " .. (5 + (deficiency * 0.04)) .. "%\n";
        end
    end

    return value, max, color, label, levelLabel, tooltipTitle, tooltipText, skillName, nil, nil, isGlowing;

end

function TrackOMatic_Skill_WeaponSkillDetails(hasTarget, skillLevel, targetLevel)
    local result = string.format(L["CRITICAL_CHANCE"], (math.floor(GetCritChance() * 100) / 100) .. "%");
    
    if (skillLevel < targetLevel) then
--        local belowTarget = targetLevel - skillLevel;
--        local enemyParry = 0;
--        local baseMiss = 0;
--        if (belowTarget > 10) then
--            baseMiss = (6 + ((belowTarget - 10) * 0.4));
--            enemyParry = (6 + ((belowTarget - 10) * 0.4));
--        else
--            baseMiss = (5 + (belowTarget * 0.1));
--            enemyParry = (5 + (belowTarget * 0.1));
--        end
--        local reducedCrit = (belowTarget * 0.4);
--        local enemyBlock = (5 + (belowTarget * 0.1));
--        local enemyDodge = (5 + (belowTarget * 0.1));
--        local overallHit = 100 - (enemyDodge + enemyParry + baseMiss);
--        result = result .. "Reduced Critical chance: " .. reducedCrit .. "%\n";
--        result = result .. "Base Miss chance: " .. baseMiss .. "%\n";
--        result = result .. "Base enemy Dodge chance: " .. enemyDodge .. "%\n";
--        result = result .. "Base enemy Parry chance: ~" .. enemyParry .. "%\n";
--        result = result .. "Base enemy Block chance: " .. enemyBlock .. "%\n";
--        result = result .. "Overall chance to hit: " .. overallHit .. "%\n";
    else
        local skillExcess = skillLevel - targetLevel;
--        local baseMiss = math.max(0, (5 - (skillExcess * 0.4)));
--        local enemyParry = math.max(0, (5 - (skillExcess * 0.4)));
--        local baseCrit = (5 + (skillExcess * 0.4));
--        local enemyBlock = math.max(0, (5 - (skillExcess * 0.4)));
--        local enemyDodge = math.max(0, (5 - (skillExcess * 0.4)));
--        local overallHit = 100 - (enemyDodge + enemyParry + baseMiss);
--        result = result .. "Increased Critical chance: " .. (skillExcess * 0.4) .. "%\n";
--        result = result .. "Base Miss chance: " .. math.max(0, (5 - (skillExcess * 0.4))) .. "%\n";
--        result = result .. "Base enemy Dodge chance: " .. math.max(0, (5 - (skillExcess * 0.4))) .. "%\n";
--        result = result .. "Base enemy Parry chance: " .. math.max(0, (5 - (skillExcess * 0.4))) .. "%\n";
--        result = result .. "Base enemy Block chance: " .. math.max(0, (5 - (skillExcess * 0.4))) .. "%\n";
--        result = result .. "Overall chance to hit: " .. overallHit .. "%\n";

        if (hasTarget) then
            result = result .. "\n\n|cffffffff" .. L["AGAINST_CURRENT_TARGET"] .. "|r\n";
        else
            result = result .. "\n\n|cffffffff" .. L["AGAINST_EQUAL_TARGETS"] .. "|r\n";
        end
        result = result .. "|cff00ff00" .. string.format(L["INCREASED_HIT_CHANCE"], (skillExcess * 0.4) .. "%");
    end
    return result;
end

--========================================
-- Get profession info by name
--========================================
function TrackOMatic_Skill_GetSkillIndex(name, doNotExpandOrCollapse)
    if (not doNotExpandOrCollapse) then TrackOMatic_Skill_ExpandAllForUpdate(); end
    local numLines = GetNumSkillLines();
    local skillName, header, isExpanded, skillRank, numTempPoints, skillModifier, skillMaxRank, isAbandonable, stepCost, rankCost, minLevel, skillCostType, skillDescription;

    for i = 1, numLines, 1 do
        skillName, header, isExpanded, skillRank, numTempPoints, skillModifier, skillMaxRank, isAbandonable, stepCost, rankCost, minLevel, skillCostType, skillDescription = GetSkillLineInfo(i);
        if ((not header) and (skillMaxRank > 1)) then
            if (string.sub(string.lower(skillName), 0, string.len(name)) == string.lower(name)) then
                if (not doNotExpandOrCollapse) then TrackOMatic_Skill_RecollapseHeaders(); end
                return i, skillName;
            end
        end
    end
    if (not doNotExpandOrCollapse) then TrackOMatic_Skill_RecollapseHeaders(); end
    return nil;
end

--========================================
-- Add a profession to the tracker
--========================================
function TrackOMatic_Skill_AddSkill(name)

    if (string.len(name or "") < 1) then return; end

    local skillIndex, skillName = TrackOMatic_Skill_GetSkillIndex(name);

    if (skillIndex == nil) then
        return;
    end

    if (TrackOMatic_AddToCategory("skill", {id = skillName})) then
        TrackOMatic_Message(string.format(L["TRACKER_ADD_SKILL"], skillName));
    end

end

--========================================
-- Remove a profession from the tracker
--========================================
function TrackOMatic_Skill_RemoveSkill(index, isSilent)
    local data = TrackOMatic_RemoveFromCategory("skill", index);
    if ((not isSilent) and data) then
        TrackOMatic_Message(string.format(L["TRACKER_REMOVE_SKILL"], data.id));
    end
end

--========================================
-- Handler for clicking the button on
-- the skill detail frame
--========================================
function TrackOMatic_AddSkillButton_OnClick()
    TrackOMatic_Skill_AddSkill(SkillDetailStatusBarSkillName:GetText());
end

--========================================
-- Returns whether the given skill name
-- is a weapon skill
--========================================
function TrackOMatic_Skill_IsWeaponSkill(skillName)
    local weaponSkills =  {
        L["1H_AXES"], L["2H_AXES"],
        L["1H_MACES"], L["2H_MACES"],
        L["1H_SWORDS"], L["2H_SWORDS"],
        L["POLEARMS"], L["STAVES"],
        L["DAGGERS"], L["FIST_WEAPONS"],
        L["BOWS"], L["GUNS"],
        L["CROSSBOWS"], L["WANDS"],
        L["UNARMED"], L["THROWN"],
    };

    for id, name in pairs(weaponSkills) do
        if (skillName == name) then
            return true;
        end
    end
    return false;
end

--========================================
-- Returns whether the given skill name
-- is any profession
--========================================
function TrackOMatic_Skill_IsProfession(skillName)
    local profs = { L["ALCHEMY"], L["BLACKSMITHING"], L["LEATHERWORKING"], L["TAILORING"], L["ENCHANTING"], L["ENGINEERING"], L["COOKING"], L["FIRST_AID"], L["MINING"], L["HERBALISM"], L["SKINNING"], L["FISHING"] };
    for id, name in pairs(profs) do
        if (skillName == name) then
            return true;
        end
    end
    return false;
end

--========================================
-- Returns whether the given skill name
-- is a production profession
--========================================
function TrackOMatic_Skill_IsProductionProfession(skillName)
    local profs = { L["ALCHEMY"], L["BLACKSMITHING"], L["LEATHERWORKING"], L["TAILORING"], L["ENCHANTING"], L["ENGINEERING"], L["COOKING"], L["FIRST_AID"] };
    for id, name in pairs(profs) do
        if (skillName == name) then
            return true;
        end
    end
    return false;
end

--========================================
-- Returns whether the given skill name
-- is a gathering profession
--========================================
function TrackOMatic_Skill_IsGatheringProfession(skillName)
    local profs = { L["MINING"], L["HERBALISM"], L["SKINNING"] };
    for id, name in pairs(profs) do
        if (skillName == name) then
            return true;
        end
    end
    return false;
end

--========================================
-- Returns whether a new profession rank
-- is available based on name, current
-- skill level, and player level
--========================================
function TrackOMatic_Skill_NewProfessionRankAvailable(skillName, skillLevel, skillMaxLevel, playerLevel)
    local i;
    local reqLevels = { 0, 0, 0 };
    if (TrackOMatic_Skill_IsProductionProfession(skillName)) then
        reqLevels = { 10, 20, 35 };
    elseif (TrackOMatic_Skill_IsGatheringProfession(skillName)) then
        reqLevels = { 0, 10, 25 };
    elseif (skillName == L["FISHING"]) then
        reqLevels = { 10, 10, 10 };
    end
    
    for i = 1, 3 do
        if ((skillMaxLevel == (i * 75)) and (skillLevel >= ((i * 75) - 25))) then
            if (playerLevel >= reqLevels[i]) then
                return true;
            end
        end
    end
    return false;
end

--========================================
-- Get the maximum level of creature able
-- to be skinned at a specified skill lvl
--========================================
function TrackOMatic_Skill_GetSkinnableCreatureLevel(skillLevel)
    local isBoss = false;
    local level = 0;
    if (skillLevel >= 100) then
        level = math.floor(skillLevel / 5);
    else
        level = math.floor(skillLevel / 10) + 10;
    end
    if (level == 63) then isBoss = true; end
    return min(62, level), isBoss;
end

--========================================
-- Generate a 'gatherable node' list for
-- mining and herbalism
--========================================
function TrackOMatic_GetGatherables(profession, skillLevel)

    local nodes = {
        [L["MINING"]] = {
            {name = L["MINING_NODE_COPPER"], minSkill = 0},    -- skill is 0 otherwise it'd change colors one skill level late
            {name = L["MINING_NODE_TIN"], minSkill = 65, turnsYellow = 100},
            {name = L["MINING_NODE_SILVER"], minSkill = 75},
            {name = L["MINING_NODE_IRON"], minSkill = 125},
            {name = L["MINING_NODE_GOLD"], minSkill = 155},
            {name = L["MINING_NODE_MITHRIL"], minSkill = 175},
            {name = L["MINING_NODE_TRUESILVER"], minSkill = 230},
            {name = L["MINING_NODE_DARK_IRON"], minSkill = 230},
            {name = L["MINING_NODE_SMALL_THORIUM"], minSkill = 245},
            {name = L["MINING_NODE_RICH_THORIUM"], minSkill = 275},
        },
        [L["HERBALISM"]] = {
            {name = L["HERB_PEACEBLOOM"], minSkill = 0},       -- see copper
            {name = L["HERB_SILVERLEAF"], minSkill = 0},       -- ...
            {name = L["HERB_EARTHROOT"], minSkill = 15},
            {name = L["HERB_MAGEROYAL"], minSkill = 50},
            {name = L["HERB_BRIARTHORN"], minSkill = 70},
            {name = L["HERB_STRANGLEKELP"], minSkill = 85},
            {name = L["HERB_BRUISEWEED"], minSkill = 100},
            {name = L["HERB_WILD_STEELBLOOM"], minSkill = 115},
            {name = L["HERB_GRAVE_MOSS"], minSkill = 120},
            {name = L["HERB_KINGSBLOOD"], minSkill = 125},
            {name = L["HERB_LIFEROOT"], minSkill = 150},
            {name = L["HERB_FADELEAF"], minSkill = 160},
            {name = L["HERB_GOLDTHORN"], minSkill = 170},
            {name = L["HERB_KHADGARS_WHISKER"], minSkill = 185},
            {name = L["HERB_WINTERSBITE"], minSkill = 195},
            {name = L["HERB_FIREBLOOM"], minSkill = 205},
            {name = L["HERB_PURPLE_LOTUS"], minSkill = 210},
            {name = L["HERB_ARTHAS_TEARS"], minSkill = 220},
            {name = L["HERB_SUNGRASS"], minSkill = 230},
            {name = L["HERB_BLINDWEED"], minSkill = 235},
            {name = L["HERB_GHOST_MUSHROOM"], minSkill = 245},
            {name = L["HERB_GROMSBLOOD"], minSkill = 250},
            {name = L["HERB_GOLDEN_SANSAM"], minSkill = 260},
            {name = L["HERB_DREAMFOIL"], minSkill = 270},
            {name = L["HERB_MOUNTAIN_SILVERSAGE"], minSkill = 280},
            {name = L["HERB_PLAGUEBLOOM"], minSkill = 285},
            {name = L["HERB_ICECAP"], minSkill = 290},
            {name = L["HERB_BLACK_LOTUS"], minSkill = 300},
        },
    };

    local list = "";
    local cutoffLow = "";
    local cutoffHigh = "";
    local redCount = 0;

    local index, entry;
    if (nodes[profession]) then
        for index, entry in pairs(nodes[profession]) do
            local skip = false;
            local reqLevel = "";
            -- below the required skill to gather the node
            if ((skillLevel < entry.minSkill) and TRACKOMATIC_VARS['config']['gather_exclude_high']) then
                if (redCount < 1) then
                    redCount = redCount + 1;
                else
                    if ((GATHER_CUTOFFRED < 1) or ((entry.minSkill - skillLevel > GATHER_CUTOFFRED) and (GATHER_CUTOFFRED > 0))) then
                        cutoffHigh = "\n|cffff0000...|r";
                        skip = true;
                    end
                end
            elseif (((GATHER_CUTOFFGRAY > 0) and (skillLevel - (entry.minSkill + 100) >= GATHER_CUTOFFGRAY)) and TRACKOMATIC_VARS['config']['gather_exclude_low']) then
                cutoffLow = "|cffa0a0a0...|r\n";
                skip = true;
            end
            if (not skip) then
                local turnsYellow = entry.minSkill + 25;
                if (entry.turnsYellow) then
                    turnsYellow = entry.turnsYellow;
                end
                if (list ~= "") then list = list .. "\n"; end
                if (skillLevel < entry.minSkill) then
                    reqLevel = " " .. TrackOMatic_GetSkillColor(entry.minSkill, entry.minSkill, turnsYellow) .. "(" .. entry.minSkill .. ")|r";
                else
                    if (TRACKOMATIC_VARS['config']['advanced_gather_tooltips']) then
                        if (skillLevel < turnsYellow) then
                            reqLevel = " " .. TrackOMatic_GetSkillColor(turnsYellow, entry.minSkill, turnsYellow) .. "(" .. turnsYellow .. ")|r";
                        else
                            if (skillLevel < turnsYellow + 25) then
                                reqLevel = " " .. TrackOMatic_GetSkillColor(turnsYellow + 25, entry.minSkill, turnsYellow) .. "(" .. (turnsYellow + 25) .. ")|r";
                            else
                                if (skillLevel < turnsYellow + 75) then
                                    reqLevel = " " .. TrackOMatic_GetSkillColor(turnsYellow + 75, entry.minSkill, turnsYellow) .. "(" .. (turnsYellow + 75) .. ")|r";
                                end
                            end
                        end
                    end
                end
                list = list .. TrackOMatic_GetSkillColor(skillLevel, entry.minSkill, turnsYellow) .. entry.name .. "|r" .. reqLevel;
            end
        end
    end

    return cutoffLow .. list .. cutoffHigh;

end

--========================================
-- Get the color of a gatherable node
-- by skill level
--========================================
function TrackOMatic_GetSkillColor(level, required, turnsYellow)

    if (not turnsYellow) then
        turnsYellow = required + 25;
    end

    if (level >= (turnsYellow + 75)) then
        return "|cffa0a0a0";
    else
        if (level >= (turnsYellow + 25)) then
            return "|cff00ff00";
        else
            if (level >= turnsYellow) then
                return "|cffffff00";
            else
                if (level >= required) then
                    return "|cffffa000";
                else
                    return "|cffff0000";
                end
            end
        end
    end

end


local collapsedHeaders = {};

local function _countCollapsedHeaders()
    local count = 0;
    local __;
    for __ in pairs(collapsedHeaders) do
        count = count + 1;
    end
    return count;
end

--========================================
-- Stores and expands collapsed headers
-- for bar updates
--========================================
function TrackOMatic_Skill_ExpandAllForUpdate()
    local count = _countCollapsedHeaders();
    if (count > 0) then return; end
    local numLines = GetNumSkillLines();
    local skillName, header, isExpanded;
    collapsedHeaders = {};
    local i;
    for i = 1, numLines, 1 do
        skillName, header, isExpanded = GetSkillLineInfo(i);
        if (header) then
            if (not isExpanded) then
                collapsedHeaders[skillName] = true;
            end
        end
    end
    local count = _countCollapsedHeaders();
    if (count > 0) then
        i = 1;
        while (true) do
            if (i > GetNumSkillLines()) then break; end
            skillName, header, isExpanded = GetSkillLineInfo(i);
            if (header and not isExpanded) then
                ExpandSkillHeader(i);
                --print("Expanded skill header " .. skillName);
            end
            i = i + 1;
        end
    end
end

--========================================
-- Re-collapses temporarily expanded
-- headers after performing queries
--========================================
function TrackOMatic_Skill_RecollapseHeaders()
    local count = _countCollapsedHeaders();
    if (count < 1) then return; end
    local i = 1;
    while (true) do
        if (i > GetNumSkillLines()) then break; end
        skillName, header, isExpanded = GetSkillLineInfo(i);
        if (header and isExpanded and collapsedHeaders[skillName]) then
            CollapseSkillHeader(i);
            --print("Recollapsed skill header " .. skillName);
        end
        i = i + 1;
    end
    collapsedHeaders = {};
end
