local L = LibStub("AceLocale-3.0"):GetLocale("TrackOMatic", true);

local oldProfRanks = {
    {reqLevel = 5, maxSkill = 75},
    {reqLevel = 20, maxSkill = 150},
    {reqLevel = 20, maxSkill = 225},
    {reqLevel = 35, maxSkill = 300},
    {reqLevel = 50, maxSkill = 375},
    {reqLevel = 65, maxSkill = 450},
    {reqLevel = 75, maxSkill = 525},
    {reqLevel = 80, maxSkill = 600},
    {reqLevel = 90, maxSkill = 700},
    {reqLevel = 98, maxSkill = 800},
};

local profExpacSpellIDs = {
    [171] = {264213, 264220, 264243, 264245, 264247, 264250},   -- alchemy
    [164] = {264436, 264438, 264440, 264442, 264444, 264446},   -- blacksmithing
    [185] = {264634, 264636, 264638, 264640, 264642, 264644},   -- cooking
    [333] = {264460, 264462, 264464, 264467, 264469, 264471},   -- enchanting
    [202] = {264479, 264481, 264483, 264485, 264487, 264490},   -- engineering
    [356] = {271656, 271658, 271660, 271662, 271664, 271672},   -- fishing
    [773] = {264496, 264498, 264500, 264502, 264504, 264506},   -- inscription
    [755] = {264534, 264537, 264539, 264542, 264544, 264546},   -- jewelcrafting
    [165] = {264579, 264581, 264583, 264585, 264588, 264590},   -- leatherworking
    [197] = {264618, 264620, 264622, 264624, 264626, 264628},   -- tailoring
    -- herbalism, mining and skinning don't have spells for their expansion ranks? none that work, anyway...
};

local pandariaTrainerLocations = {
    [171] = "DAWNS_BLOSSOM",            -- alchemy
    [164] = "VALE_OF_ETERNAL_BLOSSOMS", -- blacksmithing
    [185] = "DAWNS_BLOSSOM",            -- cooking
    [333] = "DAWNS_BLOSSOM",            -- enchanting
    [202] = "VALLEY_OF_FOUR_WINDS",     -- engineering
    [356] = "FACTION_CAPITALS",         -- fishing
    [182] = "JADE_FOREST",              -- herbalism
    [773] = "GREENSTONE_VILLAGE",       -- inscription
    [755] = "GREENSTONE_VILLAGE",       -- jewelcrafting
    [165] = "GRUMMLE_BAZAAR",           -- leatherworking
    [186] = "JADE_FOREST",              -- mining
    [197] = "SILKEN_FIELDS",            -- tailoring
    [393] = "JADE_FOREST",              -- skinning
};

--========================================
-- Add a profession to the tracker
--========================================
function TrackOMatic_AddProfession(index)

    local profName, _, _, _, _, _, profSkillLine = GetProfessionInfo(index);
    if (not profName) then return; end

    if (TrackOMatic_AddToCategory("skill", {id = profSkillLine})) then
        TrackOMatic_Message(string.format(L["TRACKER_ADD_PROFESSION"], profName));
    end

end

--========================================
-- Update a profession bar
--========================================
function TrackOMatic_SetProfBar(data)

    local profName, profIcon, profSkillLevel, profMaxSkill, profNumAbilities, profSpellOffset, profSkillLine, profSkillModifier = TrackOMatic_GetProfessionInfo(data.id);
    if (not profName) then return; end

    -- update the bar
    local max, value, color, label, levelLabel, tooltipTitle, tooltipText, skillMod;

    label = profName;
    tooltipTitle = "";
    tooltipText = "";
    skillMod = 0;

    max = profMaxSkill;
    value = profSkillLevel;
    color = {r = 0, g = 0, b = 1};

    skillMod = profSkillLevel + profSkillModifier;

    if (profSkillModifier == 0) then
        levelLabel = profSkillLevel .. "/" .. profMaxSkill;
        tooltipTitle = profName .. " " .. profSkillLevel;
    else
        local color = RED_FONT_COLOR_CODE;
        if (profSkillModifier > 0) then
            color = GREEN_FONT_COLOR_CODE .. "+";
        end
        levelLabel = profSkillLevel .. "/" .. profMaxSkill .. " (" .. color .. profSkillModifier .. FONT_COLOR_CODE_CLOSE .. " = " .. skillMod .. ")";
        tooltipTitle = profName .. " " .. skillMod .. " (" .. profSkillLevel .. color .. profSkillModifier .. FONT_COLOR_CODE_CLOSE .. ")";
    end

    local newRankAvailable, newRankText = TrackOMatic_NewProfessionRankAvailable(profSkillLine, profName, profMaxSkill);

    if (newRankAvailable) then
        tooltipText = newRankText;
    end

    return value, max, color, label, levelLabel, tooltipTitle, tooltipText, profName, nil, nil, newRankAvailable;

end

--========================================
-- Get profession info by name
--========================================
--function TrackOMatic_GetProfessionInfo(name)
--    -- retrieve profession indexes
--    local prof1, prof2, archaeology, fishing, cooking = GetProfessions();
--    -- convert to an array
--    profArray = {prof1, prof2, archaeology, fishing, cooking};
--
--    for i = 1, 5, 1 do
--        if (profArray[i]) then
--            local profName, profIcon, profSkillLevel, profMaxSkill, profNumAbilities, profSpelloffset, profSkillLine, profSkillModifier = GetProfessionInfo(profArray[i]);
--            if (string.sub(string.lower(profName), 0, string.len(name)) == string.lower(name)) then
--                return profArray[i], profName, profIcon, profSkillLevel, profMaxSkill, profNumAbilities, profSpelloffset, profSkillLine, profSkillModifier;
--            end
--        end
--    end
--    return nil;
--end

--========================================
-- Remove a profession from the tracker
--========================================
function TrackOMatic_RemoveSkill(index, isSilent)
    local data = TrackOMatic_RemoveFromCategory("skill", index);
    if ((not isSilent) and data) then
        if (data.isPlugin) then
            if (data.name) then TrackOMatic_Message(string.format(L["TRACKER_REMOVE_PLUGIN"], data.name)); end
        else
            local profName = TrackOMatic_GetProfessionInfo(data.id);
            if (profName) then TrackOMatic_Message(string.format(L["TRACKER_REMOVE_PROFESSION"], profName)); end
        end
    end
end

--========================================
-- Wrapper for GetProfessionInfo using
-- the skill ID as the reference point
--========================================
local function getProfTable(...)
    local i;
    local result = {};
    local count = select('#', ...);
    for i = 1, count do
        local v = select(i, ...);
        if (v) then table.insert(result, v); end
    end
    return result;
end

function TrackOMatic_GetProfessionInfo(skillID)
    local profTable = getProfTable(GetProfessions());
    local i;
    local found = false;
    for i = 1, #profTable do
        profName, profIcon, profSkillLevel, profMaxSkill, profNumAbilities, profSpellOffset, profSkillLine, profSkillModifier = GetProfessionInfo(profTable[i]);
        if (profSkillLine == skillID) then
            found = true;
            break;
        end
    end
    if (not found) then return nil; end
    return profName, profIcon, profSkillLevel, profMaxSkill, profNumAbilities, profSpellOffset, profSkillLine, profSkillModifier;
end

--========================================
-- Update the professions tab of the
-- spellbook
--========================================
function TrackOMatic_UpdateProfessions()
    local prim1, prim2, arch, fishing, cooking = GetProfessions();
    TrackOMatic_UpdateProfessionButton(PrimaryProfession1TrackButton, prim1);
    TrackOMatic_UpdateProfessionButton(PrimaryProfession2TrackButton, prim2);
    TrackOMatic_UpdateProfessionButton(SecondaryProfession1TrackButton, cooking);
    TrackOMatic_UpdateProfessionButton(SecondaryProfession2TrackButton, fishing);
    TrackOMatic_UpdateProfessionButton(SecondaryProfession3TrackButton, arch);
    TrackOMatic_UpdateTracker(1);
end

--========================================
-- Update a button on the professions
-- tab of the spellbook
--========================================
function TrackOMatic_UpdateProfessionButton(button, index)
    if (index) then
        button:Show();
        button.profIndex = index;
    else
        button:Hide();
        button.profIndex = 0;
    end
end

--========================================
-- Handler for hovering over a button on
-- the professions tab of the spellbook
--========================================
function TrackOMatic_AddProfessionButton_OnEnter(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
    GameTooltip:SetText(L["TRACK_PROFESSION_TOOLTIP"], 1, 1, 1);
    GameTooltip:Show();
end

--========================================
-- Return whether a profession bar is
-- glowing based on current skill
--========================================
local function addExpansionProfessionTip(level, reqLevel, spellId, stringId, profName, locName)
    if (reqLevel < 1) then return ""; end
    if ((level >= reqLevel) and not IsSpellKnown(spellId)) then
        --return "\n|cff00ff00" .. string.format(L["LEARN_" .. stringId .. "_PROFESSION"], profName) .. "|r";
        return "\n|cff00ff00" .. TrackOMatic_FormatString(L["LEARN_" .. stringId .. "_PROFESSION"], { ["prof"] = profName, ["loc"] = locName }) .. "|r";
    end
    return "";
end

function TrackOMatic_NewProfessionRankAvailable(skillID, profName, maxSkill)

    local playerLevel = UnitLevel("player");
    
    local tipText = "";
    local newRank = false;
    
    -- archaology still uses the old ranking system
    if (skillID == 794) then
        local i;
        for i = 1, (#oldProfRanks - 1) do
            if (maxSkill == oldProfRanks[i].maxSkill) then
                if (playerLevel >= oldProfRanks[i + 1].reqLevel) then
                    tipText = tipText .. "\n|cff00ff00" .. L["PROFESSION_NEW_RANK_AVAILABLE"] .. "|r";
                end
                break;
            end
        end
    -- everything else uses the new expansion-based system
    elseif (profExpacSpellIDs[skillID]) then
        local draenorLevel = 0;
        local legionLevel = 100;
        local outlandLocation = L["LOCATION_SHATTRATH"];
        local northrendLocation = L["LOCATION_DALARAN_NORTHREND"];
        local cataclysmLocation = L["LOCATION_FACTION_CAPITALS"];
        local draenorLocation = "";
        local pandariaLocation = L["LOCATION_" .. pandariaTrainerLocations[skillID]];
        local legionLocation = L["LOCATION_DALARAN_BROKEN_ISLES"];
        -- legion cooking can just be learned from the trainer @ 98, instead of a quest @ 100 like the others
        if (skillID == 185) then
            legionLevel = 98;
        -- fishing ranks can be learned from pretty much any trainer, including draenor and legion
        elseif (skillID == 356) then
            outlandLocation = L["LOCATION_FACTION_CAPITALS"];
            northrendLocation = L["LOCATION_FACTION_CAPITALS"];
            draenorLocation = L["LOCATION_FACTION_CAPITALS"];
            draenorLevel = 88;
            legionLocation = L["LOCATION_FACTION_CAPITALS"];
            legionLevel = 98;
        end
        local spellArr = profExpacSpellIDs[skillID];
        tipText = tipText .. addExpansionProfessionTip(playerLevel, 58, spellArr[1], "OUTLAND", profName, outlandLocation);
        tipText = tipText .. addExpansionProfessionTip(playerLevel, 58, spellArr[2], "NORTHREND", profName, northrendLocation);
        tipText = tipText .. addExpansionProfessionTip(playerLevel, 78, spellArr[3], "CATACLYSM", profName, cataclysmLocation);
        tipText = tipText .. addExpansionProfessionTip(playerLevel, 78, spellArr[4], "PANDARIA", profName, pandariaLocation);
        tipText = tipText .. addExpansionProfessionTip(playerLevel, draenorLevel, spellArr[5], "DRAENOR", profName, draenorLocation);
        tipText = tipText .. addExpansionProfessionTip(playerLevel, legionLevel, spellArr[6], "LEGION", profName, legionLocation);
    end

    if (tipText ~= "") then
        return true, tipText;
    end
    return false;

end

--========================================
-- Return the current profession cap
-- based on the account's expansion level
--========================================
--function TrackOMatic_GetProfessionCap()
--
--    local exp = GetAccountExpansionLevel();
--    local max = #oldProfessionCaps;
--    local idx = math.min(exp, max);
--
--    return oldProfessionCaps[idx];
--
--end

function TrackOMatic_ProfTest(name)
    local i;
    local result = {};
    for i = 1, 300000 do
        local spellName = GetSpellInfo(i);
        if (spellName == name) then table.insert(result, i .. " " .. tostring(IsSpellKnown(i))); end
    end
    return result;
end
