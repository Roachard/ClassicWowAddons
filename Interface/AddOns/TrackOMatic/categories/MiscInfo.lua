local L = LibStub("AceLocale-3.0"):GetLocale("TrackOMatic", true);

--========================================
-- Update a misc. info bar
--========================================
function TrackOMatic_SetMiscBar(data)

    local value, max, color, label, levelLabel, tooltipTitle, tooltipText, menuTitle, clickFunc;

    tooltipTitle = "";
    tooltipText = "";

    local menu = {};
    local isGlowing = false;
    local glowColor = {r = 1, g = 1, b = 0};

    -- ==================== Experience Bar ==================== --
    if (data.id == "placeholder") then
        -- set default label and tooltip title
        label = "Placeholder";
        tooltipTitle = "Placeholder - tooltip";

        max = 1;
        value = 1;
        color = {r = 0.5, g = 0.5, b = 0.5};
        levelLabel = "10/10";
        tooltipText = "Something will go here eventually...?";

        menuTitle = "Placeholder - menu";

    else
        max = 1;
        value = 1;
        color = {r = 0.5, g = 0.5, b = 0.5};
        label = L["UNDEFINED"];
    end

    return value, max, color, label, levelLabel, tooltipTitle, tooltipText, menuTitle, menu, clickFunc, isGlowing, glowColor;
end

--========================================
-- Add an entry to the misc. info
-- category
--========================================
function TrackOMatic_AddMisc(id, isPlugin)
    if (isPlugin) then
        TrackOMatic_AddPlugin(id, "misc");
    else
        local miscInfos = {
            --["xp"] = 1,
            --["grind"] = 1,
            --["quest"] = 1,
            --["gold"] = 1,
            --["durability"] = 1,
        };
        if (not miscInfos[id]) then
            return;
        end
        if (TrackOMatic_AddToCategory("misc", {id = id, isPlugin = isPlugin})) then
            TrackOMatic_Message(string.format(L["TRACKER_ADD_MISC"], TrackOMatic_GetMiscLabel(id)));
        end
    end
end

--========================================
-- Remove a misc. info bar
--========================================
function TrackOMatic_RemoveMisc(index, isSilent)
    local data = TrackOMatic_RemoveFromCategory("misc", index);
    if ((not isSilent) and data) then
        local name;
        if (data.isPlugin) then
            name = data.name;
        else
            name = TrackOMatic_GetMiscLabel(data.id);
        end
        if (name) then
            TrackOMatic_Message(string.format(L["TRACKER_REMOVE_MISC"], name));
        end
    end
end

--========================================
-- Return a localized label for the
-- specified misc. info item
--========================================
function TrackOMatic_GetMiscLabel(id)

    --if (string.lower(id) == "xp") then
    --    return L["MISC_INFO_XP"];
    --elseif (string.lower(id) == "grind") then
    --    return L["MISC_INFO_KILLS_TO_LEVEL"];
    --elseif (string.lower(id) == "quest") then
    --    return L["MISC_INFO_QUESTS_TO_LEVEL"];
    --elseif (string.lower(id) == "gold") then
    --    return L["MISC_INFO_GOLD"];
    --elseif (string.lower(id) == "durability") then
    --    return L["MISC_INFO_DURABILITY"];
    --end
    
    -- space for rent
    
    return L["UNDEFINED"];

end
