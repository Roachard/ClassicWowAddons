local L = LibStub("AceLocale-3.0"):GetLocale("TrackOMatic", true);

local function owlcatStoneProgress(state, label)
    if (state) then
        return "|cff00ff00" .. label .. "|r";
    else
        return "|cff808080" .. label .. "|r";
    end
end

local eventTriggerIds = {
    --["0001"] = L["EVT_BURNING_PLATE"],
    --["0002"] = L["EVT_FEATHER_OF_THE_MOONSPIRIT"],
};

--========================================
-- Update an event/trigger bar
--========================================
function TrackOMatic_SetEventTriggerBar(data)

    local value, max, color, label, levelLabel, tooltipTitle, tooltipText, menuTitle, clickFunc;

    tooltipTitle = "";
    tooltipText = "";

    local menu = {};
    local isGlowing = false;
    local glowColor = {r = 1, g = 1, b = 0};

    -- ==================== Burning Plate of the Worldbreaker ==================== --
    --if (data.id == "0001") then
    --    -- set default label and tooltip title
    --    label = L["EVT_BURNING_PLATE"];
    --    tooltipTitle = L["EVT_BURNING_PLATE"];
    --    tooltipText = L["BURNING_PLATE_DESCRIPTION"] .. "\n\n";
    --
    --    local bpAvailable = IsQuestFlaggedCompleted(44311);
    --    local bpDenied = IsQuestFlaggedCompleted(44312);
    --    
    --    max = 1;
    --    value = 1;
    --    if (bpDenied == true) then
    --        color = {r = 1, g = 0, b = 0};
    --        tooltipText = tooltipText .. L["TRY_AGAIN_TOMORROW"];
    --    elseif (bpAvailable == true) then
    --        color = {r = 0, g = 1, b = 0};
    --        tooltipText = tooltipText .. L["SHIELD_AVAILABLE"];
    --        isGlowing = true;
    --    else
    --        value = 0;
    --        color = {r = 0.5, g = 0.5, b = 0.5};
    --        tooltipText = tooltipText .. L["GO_TO_NELTHARIONS_VAULT"];
    --    end
    --    levelLabel = "";
    --
    --    menuTitle = L["EVT_BURNING_PLATE"];
    --
    ---- ==================== Feather of the Moonspirit ==================== --
    --elseif (data.id == "0002") then
    --    -- set default label and tooltip title
    --    label = L["EVT_FEATHER_OF_THE_MOONSPIRIT"];
    --    tooltipTitle = L["EVT_FEATHER_OF_THE_MOONSPIRIT"];
    --    tooltipText = L["FEATHER_OF_THE_MOONSPIRIT_DESCRIPTION"] .. "\n\n";
    --
    --    local dreamwayRoll = IsQuestFlaggedCompleted(44326);
    --    local feralasStatueUp = IsQuestFlaggedCompleted(44327);
    --    local hinterlandsStatueUp = IsQuestFlaggedCompleted(44328);
    --    local duskwoodStatueUp = IsQuestFlaggedCompleted(44329);
    --    local duskwoodStatueTouched = IsQuestFlaggedCompleted(44330);
    --    local feralasStatueTouched = IsQuestFlaggedCompleted(44331);
    --    local hinterlandsStatueTouched = IsQuestFlaggedCompleted(44332);
    --    
    --    max = 1;
    --    value = 0;
    --    if (dreamwayRoll == true) then
    --        if (feralasStatueUp or hinterlandsStatueUp or duskwoodStatueUp) then
    --            value = 0;
    --            max = 3;
    --            isGlowing = false;
    --            color = {r = 0, g = 1, b = 0};
    --            tooltipText = tooltipText .. owlcatStoneProgress(duskwoodStatueTouched, L["DUSKWOOD_STONE_TOUCHED"]) .. "\n";
    --            tooltipText = tooltipText .. owlcatStoneProgress(feralasStatueTouched, L["FERALAS_STONE_TOUCHED"]) .. "\n";
    --            tooltipText = tooltipText .. owlcatStoneProgress(hinterlandsStatueTouched, L["HINTERLANDS_STONE_TOUCHED"]) .. "\n";
    --            if (feralasStatueTouched) then
    --                value = value + 1;
    --            elseif (feralasStatueUp) then
    --                isGlowing = true;
    --                tooltipText = tooltipText .. "\n" .. L["GO_TO_FERALAS"];
    --            end
    --            if (hinterlandsStatueTouched) then
    --                value = value + 1;
    --            elseif (hinterlandsStatueUp) then
    --                isGlowing = true;
    --                tooltipText = tooltipText .. "\n" .. L["GO_TO_HINTERLANDS"];
    --            end
    --            if (duskwoodStatueTouched) then
    --                value = value + 1;
    --            elseif (duskwoodStatueUp) then
    --                isGlowing = true;
    --                tooltipText = tooltipText .. "\n" .. L["GO_TO_DUSKWOOD"];
    --            end
    --        else
    --            value = 1;
    --            color = {r = 1, g = 0, b = 0};
    --            tooltipText = tooltipText .. L["TRY_AGAIN_TOMORROW"];
    --        end
    --    else
    --        value = 0;
    --        color = {r = 0.5, g = 0.5, b = 0.5};
    --        tooltipText = tooltipText .. L["TELEPORT_TO_DREAMWAY"];
    --    end
    --    levelLabel = "";
    --
    --    menuTitle = L["EVT_FEATHER_OF_THE_MOONSPIRIT"];
    --
    --else
        max = 1;
        value = 1;
        color = {r = 0.5, g = 0.5, b = 0.5};
        label = L["UNDEFINED"];
    --end

    return value, max, color, label, levelLabel, tooltipTitle, tooltipText, menuTitle, menu, clickFunc, isGlowing, glowColor;
end

--========================================
-- Add an entry to the event/trigger
-- category
--========================================
function TrackOMatic_AddEventTrigger(id)
    if (not eventTriggerIds[id]) then
        return;
    end
    if (TrackOMatic_AddToCategory("eventtrigger", {id = id})) then
        TrackOMatic_Message(string.format(L["TRACKER_ADD_EVENTTRIGGER"], eventTriggerIds[id]));
    end
end

--========================================
-- Remove an event/trigger bar
--========================================
function TrackOMatic_RemoveEventTrigger(index, isSilent)
    local data = TrackOMatic_RemoveFromCategory("eventtrigger", index);
    if ((not isSilent) and data) then
        if (data.isPlugin) then
            if (data.name) then TrackOMatic_Message(string.format(L["TRACKER_REMOVE_PLUGIN"], data.name)); end
        else
            if (eventTriggerIds[data.id]) then
                local name = TrackOMatic_GetEventTriggerLabel(data.id);
                TrackOMatic_Message(string.format(L["TRACKER_REMOVE_EVENTTRIGGER"], name));
            end
        end
    end
end

function TrackOMatic_SuppressEventTriggerAlert(data)
    if (data.id == "0001") then
    end
end
