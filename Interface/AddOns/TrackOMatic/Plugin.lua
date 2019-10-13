local L = LibStub("AceLocale-3.0"):GetLocale("TrackOMatic", true);

function TrackOMatic_SetPluginBar(data)

    local value, max, color, label, levelLabel, tooltipTitle, tooltipText = 1, 1, {r = 0.5, g = 0.5, b = 0.5}, data.name, "", "", "";
    local isGlowing, glowColor = false, {r = 1, g = 1, b = 0};
    local getGlowColor;
    local menu, clickFunc;
    local alertText = "";
    if (TrackOMatic.Plugins[data.id]) then
        if (TrackOMatic.Plugins[data.id].onUpdate) then
            value, max, color, label, levelLabel, tooltipTitle, tooltipText, barMenu, isGlowing, getGlowColor, alertText = TrackOMatic.Plugins[data.id].onUpdate();
            menu = barMenu;
            if (getGlowColor) then
                glowColor = getGlowColor;
            end
        end
        if (TrackOMatic.Plugins[data.id].onClick) then
            clickFunc = TrackOMatic.Plugins[data.id].onClick;
        end
    else
        tooltipTitle = L["MISSING_PLUGIN"];
        tooltipText = L["MISSING_PLUGIN_TOOLTIP"];
        levelLabel = L["NOT_LOADED"];
    end

    local menuTitle = data.name;

    return value, max, color, label, levelLabel, tooltipTitle, tooltipText, menuTitle, menu, clickFunc, isGlowing, glowColor, alertText;
end

function TrackOMatic_AddPlugin(id)
    if (TrackOMatic.Plugins[id]) then
        local cat = "plugin";
        if (TrackOMatic.Plugins[id].category) then
            if (TRACKOMATIC_CATEGORIES[TrackOMatic.Plugins[id].category]) then
                cat = TrackOMatic.Plugins[id].category;
            end
        end

        if (TrackOMatic.Plugins[id].requiresGoal) then
            TrackOMatic_ShowGoalInput(TrackOMatic.Plugins[id].name, function(value) TrackOMatic_FinishAddPlugin(cat, id, true, value); end);
        else
            TrackOMatic_FinishAddPlugin(cat, id);
        end

    else
        TrackOMatic_Message(L["PLUGIN_NOT_REGISTERED"]);
    end
end

function TrackOMatic_FinishAddPlugin(cat, id, hasGoal, goal)
    if (TrackOMatic_AddToCategory(cat, {id = id, isPlugin = true, name = TrackOMatic.Plugins[id].name})) then
        if (hasGoal) then
            TrackOMatic.Plugins[id]:SetUserGoal(goal);
        end
        if (TrackOMatic.Plugins[id].onAdd) then
            TrackOMatic.Plugins[id].onAdd();
        end
        TrackOMatic_Message(string.format(L["TRACKER_ADD_PLUGIN"], TrackOMatic.Plugins[id].name));
    end
end

function TrackOMatic_RemovePlugin(index, isSilent)
    local data = TrackOMatic_RemoveFromCategory("plugin", index);
    if (data) then
        if (TrackOMatic.Plugins[data.id]) then
            if (TrackOMatic.Plugins[data.id].onRemove) then
                TrackOMatic.Plugins[data.id].onRemove();
            end
        end
        if (not isSilent) then
            TrackOMatic_Message(string.format(L["TRACKER_REMOVE_PLUGIN"], data.name));
        end
    end
end

function TrackOMatic_RemovePluginCustomCategory(category, index, isSilent)
    local data = TrackOMatic_RemoveFromCategory(category, index);
    if (data) then
        if (TrackOMatic.Plugins[data.id]) then
            if (TrackOMatic.Plugins[data.id].onRemove) then
                TrackOMatic.Plugins[data.id].onRemove();
            end
        end
        if (not isSilent) then
            TrackOMatic_Message(string.format(L["TRACKER_REMOVE_PLUGIN"], data.name));
        end
    end
end

function TrackOMatic_GetMenuPluginList()

    menuList = {};

    for id, data in pairs(TrackOMatic.Plugins) do
        if (not data.isInternal) then
            table.insert(menuList, { text = data.name .. " [" .. data.version .. "]", notCheckable = true, disabled = TrackOMatic_IsTracked(data.category, id, true), func = function() TrackOMatic_AddPlugin(id); end });
        end
    end
    table.sort(menuList, function(a, b) return (a.text < b.text); end);

    return menuList;

end

function TrackOMatic_SuppressPluginAlert(data)
    if (TrackOMatic.Plugins[data.id].onSuppressAlert) then
        TrackOMatic.Plugins[data.id].onSuppressAlert();
    end
end

function TrackOMatic_GetNumRegisteredPlugins()
    local count = 0;
    local __, plugin;
    for __, plugin in pairs(TrackOMatic.Plugins) do
        if (not plugin.isInternal) then
            count = count + 1;
        end
    end
    return count;
end

function TrackOMatic_GetNumFailedPlugins()
    local count = 0;
    local __;
    for __ in pairs(TrackOMatic.BadPlugins) do
        count = count + 1;
    end
    return count;
end

function TrackOMatic_Plugin_OnEvent(event, ...)
    local __, plugin;
    for __, plugin in pairs(TrackOMatic.Plugins) do
        if (plugin.onEvent) then
            plugin.onEvent(event, ...);
        end
    end
end
