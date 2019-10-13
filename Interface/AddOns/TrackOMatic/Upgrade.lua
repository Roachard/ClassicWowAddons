-- This file will contain functions needed for automatic self-maintenance when upgrading from previous versions.

local L = LibStub("AceLocale-3.0"):GetLocale("TrackOMatic", true);

--========================================
-- This function compares the ids of an
-- old version and a new version, and
-- returns whether the upgrade has
-- crossed a specific version id
--========================================
local function compareVersion(check, oldver, newver)
    if ((oldver < check) and (newver >= check)) then
        return true;
    end
    return false;
end

-- this swaps the old "show category headers" profile settings into "HIDE category headers"
--function TrackOMatic_Upgrade_10005(oldver)
--    if (not compareVersion(10005, oldver, TrackOMatic.VersionID)) then return; end
--    
--    TrackOMatic_Message(string.format(L["AUTO_DB_UPDATE"], 10005));
--    for profile, data in pairs(TRACKOMATIC_VARS) do
--        if ((profile ~= "config") and (profile ~= "templates")) then
--            local showHeaders = (data['show_category_headers'] or true);
--            TRACKOMATIC_VARS[profile]['hide_category_headers'] = (not showHeaders);
--            TRACKOMATIC_VARS[profile]['show_category_headers'] = nil;
--        end
--    end
--end

-- this automatically clears currency bars from previous versions that used string IDs instead of integer IDs
--function TrackOMatic_Upgrade_10404(oldver)
--    if (not compareVersion(10404, oldver, TrackOMatic.VersionID)) then return; end
--
--    TrackOMatic_Message(string.format(L["AUTO_DB_UPDATE"], 10404));
--    for profile, data in pairs(TRACKOMATIC_VARS) do
--        if ((profile ~= "config") and (profile ~= "templates")) then
--            TRACKOMATIC_VARS[profile]['categories']['currency'].entries = {};
--        end
--    end
--end

-- this automatically converts the old misc. info bars to the new player info bars (so the player isn't greeted by a bunch of "Undefined" bars)
--function TrackOMatic_Upgrade_10800(oldver)
--    if (not compareVersion(10800, oldver, TrackOMatic.VersionID)) then return; end
--
--    TrackOMatic_Message(string.format(L["AUTO_DB_UPDATE"], 10800));
--    
--    -- cycle through all profiles
--    for profile, data in pairs(TRACKOMATIC_VARS) do
--        if ((profile ~= "config") and (profile ~= "templates")) then
--        
--            -- initialize the player category if needed
--            if (not TRACKOMATIC_VARS[profile]['categories']['player']) then TRACKOMATIC_VARS[profile]['categories']['player'] = { collapsed = false, entries = {}}; end
--            -- cycle through the categories
--            for cat, catData in pairs(TRACKOMATIC_VARS[profile]['categories']) do
--            
--                -- when we get to the misc category...
--                if (cat == "misc") then
--                    -- ...and if there are bars added to it...
--                    if (table.maxn(catData.entries or {}) > 0) then
--                        -- ...iterate through them...
--                        for index, barData in pairs(TRACKOMATIC_VARS[profile]['categories'][cat].entries) do
--                            -- ...and move them to the player category if they're not a plugin bar
--                            if (not barData.isPlugin) then
--                                TRACKOMATIC_VARS[profile]['categories']['player'].entries[index] = barData;
--                                TRACKOMATIC_VARS[profile]['categories']['misc'].entries[index] = nil;
--                            end
--                        end
--                    end
--                end
--                
--            end
--            
--        end
--    end
--end

-- this automatically clears reputation and profession bars from previous versions that used names instead of IDs
--function TrackOMatic_Upgrade_11000(oldver)
--    if (not compareVersion(11000, oldver, TrackOMatic.VersionID)) then return; end
--    TrackOMatic_Message(string.format(L["AUTO_DB_UPDATE"], 11000));
--    -- cycle through all profiles
--    for profile, data in pairs(TRACKOMATIC_VARS) do
--        if ((profile ~= "config") and (profile ~= "templates")) then
--            TRACKOMATIC_VARS[profile]['categories']['rep'].entries = {};
--            TRACKOMATIC_VARS[profile]['categories']['skill'].entries = {};
--        end
--    end
--end
