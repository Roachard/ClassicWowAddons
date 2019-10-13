TRACKOMATIC_INTERFACES = {};

TRACKOMATIC_API = {};
TRACKOMATIC_API.__index = TRACKOMATIC_API;

local L = LibStub("AceLocale-3.0"):GetLocale("TrackOMatic", true);


function TrackOMatic_AddHook(interface, func)
    if (not TRACKOMATIC_INTERFACES[interface]) then
        TRACKOMATIC_INTERFACES[interface] = {};
    end
    table.insert(TRACKOMATIC_INTERFACES[interface], func);
end

function TrackOMatic_RunHooks(interface, ...)
    if (TRACKOMATIC_INTERFACES[interface]) then
        for i, f in pairs(TRACKOMATIC_INTERFACES[interface]) do
            f(...);
        end
    end
end


-- ******************** Main Plugin API ********************

function TrackOMatic_GetPluginAPI(pluginId, compatFlags, name)
    local api = {};
    setmetatable(api, TRACKOMATIC_API);
    api.pluginId = pluginId;
    api:DebugLog(L["PLUGIN_DBG_REGISTERING"]);
    api.compatibilityFlags = compatFlags;
    local err = false;
    local errDetail = "";
    -- make sure name is supplied (old plugins will break here)
    local name = name;
    if (not name) then
        err = true;
        errDetail = string.format(L["PLUGIN_DBG_ERR_NONAME"], "|cffffc080TrackOMatic_GetPluginAPI|r");
        api:DebugLog(errDetail);
    end
    api.name = name or pluginId;
    -- make sure Version metadata is present
    local ver = GetAddOnMetadata(pluginId, "Version");
    if (not ver) then
        err = true;
        errDetail = L["PLUGIN_DBG_ERR_NOVERSION"];
        api:DebugLog(errDetail);
    end
    api.version = ver or "";
    -- make sure Author metadata is present
    local author = GetAddOnMetadata(pluginId, "Author");
    if (not author) then
        err = true;
        errDetail = L["PLUGIN_DBG_ERR_NOAUTHOR"];
        api:DebugLog(errDetail);
    end
    api.author = author or "";
    -- check for name dupe/conflict
    if (TrackOMatic.Plugins[pluginId]) then
        err = true;
        errDetail = string.format(L["PLUGIN_DBG_ERR_NAMECONFLICT"], pluginId);
        api:DebugLog(errDetail);
    end
    -- continue with setup
    api.registered = false;
    if (api:IsCompatible() and (not err)) then
        api.messageColor = {r = 1, g = 1, b = 1};
        api.registered = true;
        api:DebugLog("|cff00ff00" .. L["PLUGIN_DBG_REGSUCCESS"]);
        TrackOMatic.Plugins[pluginId] = api;
    else
        local failReason = L["INCOMPATIBLE"];
        --TrackOMatic_Message("|cffff0000" .. string.format(L["PLUGIN_REG_FAIL"], pluginId));
        if (err) then
            if (errDetail ~= "") then failReason = errDetail; end
        else
            api:DebugLog(string.format(L["PLUGIN_DBG_ERR_INCOMPATIBLE"], "|cffffc080TrackOMatic_GetPluginAPI|r"));
            --TrackOMatic_Message("|cffff0000" .. string.format(L["PLUGIN_REG_FAIL_DETAIL"], api.name, L["INCOMPATIBLE"]));
        end
        TrackOMatic.BadPlugins[pluginId] = {id = pluginId, name = api.name, version = api.version, author = api.author, why = failReason};
    end
    return api;
end

function TRACKOMATIC_API:UpdateTracker()
    if (not self.registered) then return; end
    TrackOMatic_UpdateTracker();
end

function TRACKOMATIC_API:RebuildTracker()
    if (not self.registered) then return; end
    TrackOMatic_BuildTracker();
end

-- ******************** System Functions ********************

function TRACKOMATIC_API:IsCompatible()
    if (self.compatibilityFlags) then
        if (bit.band(self.compatibilityFlags, TrackOMatic.PluginCompatibility) == self.compatibilityFlags) then
            return true;
        end
    end
    return false;
end

function TRACKOMATIC_API:DebugLog(text)
    TrackOMatic_DebugLog("|cffffa050[" .. self.pluginId .. "]|r " .. text)
end

-- ******************** Display Functions ********************

function TRACKOMATIC_API:SetCategory(category)
    if (self.registered) then
        if (TRACKOMATIC_CATEGORIES[category]) then
            self.category = category;
            TrackOMatic.Plugins[self.pluginId].category = category;
            return true;
        --else
        --    TRACKOMATIC_CATEGORIES[category] = {
        --        title = category,
        --        update = TrackOMatic_SetPluginBar,      
        --        remove = function(index, isSilent) TrackOMatic_RemovePluginCustomCategory(category, index, isSilent); end,
        --        getName = TrackOMatic_GetPluginBarTitle,
        --        suppressAlert = TrackOMatic_SuppressPluginAlert,
        --    };
        --    self.category = category;
        --    TrackOMatic.Plugins[self.pluginId].category = category;
        --    return true;
        end
    end
    return false;
end

function TRACKOMATIC_API:SetMessageColor(r, g, b)
    if (not self.registered) then return; end
    if (self.isInternal) then return; end
    if (r and g and b) then
        self.messageColor = {r = r, g = g, b = b};
    end
end

function TRACKOMATIC_API:Message(text)
    if (not self.registered) then return; end
    if (self.isInternal) then
        TrackOMatic_Message(text);
    else
        DEFAULT_CHAT_FRAME:AddMessage(TrackOMatic_ColorRGBToHex(self.messageColor) .. "<" .. self.name .. ">|r " .. text);
    end
end

function TRACKOMATIC_API:IsTracked()
    for idx, tbl in pairs(TRACKOMATIC_VARS[TrackOMatic.Profile]['categories']) do
        if (tbl.entries) then
            for eidx, eval in pairs(tbl.entries) do
                if ((eval.id == self.pluginId) and eval.isPlugin) then
                    return true;
                end
            end
        end
    end
    return false;
end

function TRACKOMATIC_API:AddToTracker()
    TrackOMatic_AddPlugin(self.pluginId);
end

function TRACKOMATIC_API:RemoveFromTracker(isSilent)
    local i, cat, index, data;
    for i, cat in pairs(TRACKOMATIC_VARS[TrackOMatic.Profile]['categories']) do
        if (cat.entries) then
            for index, data in pairs(cat.entries) do
                if (data.isPlugin and (data.id == self.pluginId)) then
                    TrackOMatic_RemovePlugin(index, isSilent);
                    return;
                end
            end
        end
    end
end

-- ******************** Hooking Functions ********************

function TRACKOMATIC_API:SetOnUpdate(func)
    if (self.registered) then
        if (func) then
            if (type(func) == "function") then
                self.onUpdate = func;
                return true;
            end
        end
    end
    return false;
end

function TRACKOMATIC_API:SetOnClick(func)
    if (self.registered) then
        if (func) then
            if (type(func) == "function") then
                self.onClick = func;
                return true;
            end
        end
    end
    return false;
end

function TRACKOMATIC_API:SetOnAdd(func)
    if (self.registered) then
        if (func) then
            if (type(func) == "function") then
                self.onAdd = func;
                return true;
            end
        end
    end
    return false;
end

function TRACKOMATIC_API:SetOnRemove(func)
    if (self.registered) then
        if (func) then
            if (type(func) == "function") then
                self.onRemove = func;
                return true;
            end
        end
    end
    return false;
end

function TRACKOMATIC_API:SetOnResetSession(func)
    if (self.registered) then
        if (func) then
            if (type(func) == "function") then
                self.onResetSession = func;
                return true;
            end
        end
    end
    return false;
end

function TRACKOMATIC_API:SetOnSuppressAlert(func)
    if (self.registered) then
        if (func) then
            if (type(func) == "function") then
                self.onSuppressAlert = func;
                return true;
            end
        end
    end
    return false;
end

function TRACKOMATIC_API:SetOnStartup(func)
    if (self.registered) then
        if (func) then
            if (type(func) == "function") then
                self.onStartup = func;
                return true;
            end
        end
    end
    return false;
end

function TRACKOMATIC_API:SetOnEvent(func)
    if (self.registered) then
        if (func) then
            if (type(func) == "function") then
                self.onEvent = func;
                return true;
            end
        end
    end
    return false;
end

function TRACKOMATIC_API:RegisterEvent(event)
    TrackOMatic:RegisterEvent(event);
end

-- ******************** Data Functions ********************

function TRACKOMATIC_API:SetData(key, value)
    if (not self.registered) then return; end
    if (type(key) ~= "string") then return; end
    if (not TRACKOMATIC_VARS[TrackOMatic.Profile]['plugin_data'][self.pluginId]) then
        TRACKOMATIC_VARS[TrackOMatic.Profile]['plugin_data'][self.pluginId] = {};
    end
    TRACKOMATIC_VARS[TrackOMatic.Profile]['plugin_data'][self.pluginId][key] = value;
end

function TRACKOMATIC_API:GetData()
    if (not self.registered) then return {}; end
    return (TRACKOMATIC_VARS[TrackOMatic.Profile]['plugin_data'][self.pluginId] or {});
end

function TRACKOMATIC_API:GetValue(key)
    if (self.registered) then 
        if (TRACKOMATIC_VARS[TrackOMatic.Profile]['plugin_data'][self.pluginId]) then
            return TRACKOMATIC_VARS[TrackOMatic.Profile]['plugin_data'][self.pluginId][key];
        end
    end
    return nil;
end

function TRACKOMATIC_API:GetUserGoal()
    return math.max(0, (self:GetValue("goal") or 0));
end

function TRACKOMATIC_API:SetUserGoal(value)
    self:SetData("goal", math.max(0, value));
    TrackOMatic_UpdateTracker(1);
end

function TRACKOMATIC_API:SetRequiresGoal(value)
    self.requiresGoal = value;
end

-- ******************** Menu Functions ********************

function TRACKOMATIC_API:ChangeGoalMenuItem(itemName)
    if (not self.registered) then return nil; end
    return TrackOMatic_CommonMenuItem("CHANGE_GOAL", function(v) self:SetUserGoal(v); end, itemName);
end

function TRACKOMATIC_API:ResetSessionMenuItem()
    local f;
    if (self.onResetSession) then
        f = self.onResetSession;
    else
        f = function() end;
    end
    return TrackOMatic_CommonMenuItem("RESET_SESSION", f);
end

-- ******************** Module Functions ********************

function TrackOMatic_CreateModule(moduleId, moduleName, initFunc)
    local newModule = {};
    setmetatable(newModule, TRACKOMATIC_API);
    newModule.pluginId = moduleId;
    newModule.name = moduleName;
    newModule.isInternal = true;
    newModule.initFunc = initFunc;
    newModule.registered = true;
    TrackOMatic.Plugins[moduleId] = newModule;
    return newModule;
end

function TrackOMatic_InitializeModules()
    local __, mod;
    for __, mod in pairs(TrackOMatic.Plugins) do
        if (mod.isInternal) then
            if (mod.initFunc) then
                mod.initFunc();
            end
        end
    end
end
