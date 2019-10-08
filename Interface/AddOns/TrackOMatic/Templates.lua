local L = LibStub("AceLocale-3.0"):GetLocale("TrackOMatic", true);

function TrackOMatic_SaveTemplateAs(templateName)

    if (not templateName) then return; end
    templateName = string.trim(templateName);
    if (string.len(templateName) < 1) then return; end

    TRACKOMATIC_VARS['templates'][templateName] = {["categories"] = {}};

    for i, cat in pairs(TRACKOMATIC_VARS[TrackOMatic.Profile]['categories']) do
        TRACKOMATIC_VARS['templates'][templateName]['categories'][i] = {collapsed = cat.collapsed, order = cat.order, entries = {}};
        if (cat.entries) then
            for index, data in pairs(cat.entries) do
                TRACKOMATIC_VARS['templates'][templateName]['categories'][i].entries[index] = {};
                for key, value in pairs(data) do
                    TRACKOMATIC_VARS['templates'][templateName]['categories'][i].entries[index][key] = value;
                end
            end
        end
    end

    TrackOMatic_Message(string.format(L["TEMPLATE_SAVED_AS"], templateName));
    CloseDropDownMenus();
    
end

function TrackOMatic_LoadTemplate(templateName)
    -- make sure the template exists
    if (not TRACKOMATIC_VARS['templates'][templateName]) then return; end
    -- get the template
    local template = TRACKOMATIC_VARS['templates'][templateName];
    -- clear the current profile
    TRACKOMATIC_VARS[TrackOMatic.Profile]['categories'] = {};
    -- iterate through the template, populating the profile entries
    for i, cat in pairs(template['categories']) do
        TRACKOMATIC_VARS[TrackOMatic.Profile]['categories'][i] = {collapsed = cat.collapsed, order = cat.order, entries = {}};
        if (cat.entries) then
            for index, data in pairs(cat.entries) do
                TRACKOMATIC_VARS[TrackOMatic.Profile]['categories'][i].entries[index] = {};
                for key, value in pairs(data) do
                    TRACKOMATIC_VARS[TrackOMatic.Profile]['categories'][i].entries[index][key] = value;
                end
            end
        end
    end
    -- rebuild the tracker
    TrackOMatic_BuildTracker();
    TrackOMatic_Message(string.format(L["TEMPLATE_LOADED"], templateName));
    CloseDropDownMenus();
end

function TrackOMatic_DeleteTemplate(templateName)
    if (not TRACKOMATIC_VARS['templates'][templateName]) then return; end
    TRACKOMATIC_VARS['templates'][templateName] = nil;
    TrackOMatic_Message(string.format(L["TEMPLATE_DELETED"], templateName));
    CloseDropDownMenus();
end

function TrackOMatic_SetDefaultTemplate(templateName)
    local hasDefault = false;
    local id, data;
    for id, data in pairs(TRACKOMATIC_VARS['templates']) do
        if (id == templateName) then
            data.isDefault = true;
            TrackOMatic_Message(string.format(L["DEFAULT_TEMPLATE_SET"], id));
        else
            data.isDefault = false;
        end
    end
    CloseDropDownMenus();
end

function TrackOMatic_ToggleDefaultTemplate(templateName)
    local hasDefault = false;
    local id, data;
    for id, data in pairs(TRACKOMATIC_VARS['templates']) do
        if (id == templateName) then
            if (data.isDefault) then
                data.isDefault = false;
            else
                data.isDefault = true;
                TrackOMatic_Message(string.format(L["DEFAULT_TEMPLATE_SET"], id));
            end
        else
            data.isDefault = false;
        end
    end
    CloseDropDownMenus();
end

function TrackOMatic_LoadTemplatePrompt(templateName)
    TrackOMatic.TEMPLATE_TO_LOAD = templateName;
    StaticPopup_Show("TRACKOMATIC_CONFIRM_LOAD_TEMPLATE");
end

function TrackOMatic_DeleteTemplatePrompt(templateName)
    TrackOMatic.TEMPLATE_TO_DELETE = templateName;
    StaticPopup_Show("TRACKOMATIC_CONFIRM_DELETE_TEMPLATE");
end

function TrackOMatic_SaveTemplatePrompt(templateName)
    TrackOMatic.TEMPLATE_TO_SAVE = templateName;
    StaticPopup_Show("TRACKOMATIC_CONFIRM_SAVE_TEMPLATE");
end

function TrackOMatic_GetDefaultTemplate()
    local id, data;
    for id, data in pairs(TRACKOMATIC_VARS['templates']) do
        if (data.isDefault) then return id; end
    end
    return nil;
end

function TrackOMatic_GetMenuTemplateList()

    menuList = {};

    for id, data in pairs(TRACKOMATIC_VARS['templates']) do
        local label = id;
        if (data.isDefault) then
            label = label .. " |cff00ff00" .. L["TEMPLATE_DEFAULT"] .. "|r";
        end
        local item = { text = label, hasArrow = true, checked = data.isDefault,
            menuList = {
                { text = L["MENU_TEMPLATE_LOAD"], notCheckable = true, func = function() TrackOMatic_LoadTemplatePrompt(id); end },
                { text = L["MENU_TEMPLATE_SAVE"], notCheckable = true, func = function() TrackOMatic_SaveTemplatePrompt(id); end },
                { text = L["MENU_TEMPLATE_DELETE"], notCheckable = true, func = function() TrackOMatic_DeleteTemplatePrompt(id); end },
                { text = L["MENU_TEMPLATE_SETDEFAULT"], notCheckable = true, func = function() TrackOMatic_ToggleDefaultTemplate(id); end },
            },
        };
        table.insert(menuList, item);
    end
    table.sort(menuList, function(a, b) return (a.text < b.text); end);
    
    table.insert(menuList, { text = L["MENU_TEMPLATE_CREATENEW"], notCheckable = true, func = function() StaticPopup_Show("TRACKOMATIC_CREATE_NEW_TEMPLATE"); end });

    return menuList;

end
