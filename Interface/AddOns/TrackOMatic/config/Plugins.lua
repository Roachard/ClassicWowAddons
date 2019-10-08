local L = LibStub("AceLocale-3.0"):GetLocale("TrackOMatic", true);

local CONFIG_SHOWN = false;

function TrackOMatic_ConfigPlugins_OnLoad(self)

    self.name = L["PLUGINS"];
    self.parent = L["ADDON_TITLE"];
    self.refresh = TrackOMatic_ConfigPlugins_OnRefresh;
    self.cancel = TrackOMatic_ConfigPlugins_OnClose;
    self.okay = TrackOMatic_ConfigPlugins_OnClose;
    InterfaceOptions_AddCategory(self);

    TrackOMaticConfigPluginsTitle:SetText(L["ADDON_TITLE"] .. ": " .. L["PLUGINS"]);
    TrackOMaticConfigPluginsInterfaceVersion:SetText(string.format(L["PLUGIN_INTERFACE_VERSION"], TrackOMatic.PluginCompatibility));
    TrackOMaticConfigPluginsListHeader:SetText(L["INSTALLED_PLUGINS"] .. ":");

end

function TrackOMatic_ConfigPlugins_OnRefresh()
    if (CONFIG_SHOWN) then return; end

    local pluginsList = {};
    for id, data in pairs(TrackOMatic.Plugins) do
        if (not data.isInternal) then
            local author = "";
            if (data.author) then
                author = " |cffffff00(" .. string.format(L["BY"], data.author) .. ")|r";
            end
            
            table.insert(pluginsList, data.name .. " [" .. data.version .. "]" .. author);
        end
    end
    for id, data in pairs(TrackOMatic.BadPlugins) do
        local author = "";
        local version = "";
        if (data.author ~= "") then
            author = " |cffffff00(" .. string.format(L["BY"], data.author) .. ")|r";
        end
        if (data.version ~= "") then
            version = " [" .. data.version .. "]";
        end
        table.insert(pluginsList, data.name .. version .. author .. " |cffff0000(" .. data.why .. ")");
    end
    table.sort(pluginsList, function(a, b) return a < b; end);

    if (table.maxn(pluginsList) < 1) then
        table.insert(pluginsList, L["NO_PLUGINS_INSTALLED"]);
    end

    for i = 1, table.maxn(pluginsList), 1 do
        local fontString = _G["TrackOMaticConfigPlugins_List" .. i];
        if (not fontString) then
            fontString = TrackOMaticConfigPlugins:CreateFontString("TrackOMaticConfigPlugins_List" .. i, "ARTWORK", "GameFontHighlightSmall");
        end
        fontString:ClearAllPoints();
        fontString:SetPoint("TOPLEFT", TrackOMaticConfigPlugins, "TOPLEFT", 80, -(80 + (i * 20)));
        fontString:SetText(pluginsList[i]);
    end

    CONFIG_SHOWN = true;
end

function TrackOMatic_ConfigPlugins_OnClose()
    CONFIG_SHOWN = false;
end
