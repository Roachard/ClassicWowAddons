-----------------------------------------
-- Contains all functions for a player --
-----------------------------------------

-- Shared/saved variable
MTSL_PLAYERS = {}

-- Holds info about the current logged in player
-- Contains following info once loaded from data
--		NAME,
--		FACTION,
--		REALM,
--		XP_LEVEL,
--		TRADESKILLS = {}
MTSL_CURRENT_PLAYER = {}

MTSL_LOGIC_PLAYER = {
    ---------------------------------------------------------------------------------------
    -- Loads the saved data of the logged in player or creates a new save
    -- Triggerd by game event "PLAYER_LOGIN"
    ---------------------------------------------------------------------------------------
    LoadPlayer = function (self)
        local name = UnitName("player")
        local realm = GetRealmName()
        local faction = UnitFactionGroup("player")
        local xp_level = UnitLevel("player")

        if name == nil or realm == nil or
                faction == nil or xp_level == nil then
            print(MTSLUI_FONTS.COLORS.TEXT.ERROR .. "MTSL - Could not load player info! Try reloading this addon")
        end

        local current_player = MTSL_PLAYERS[realm]
        -- Realm not yet registered so create it
        if current_player == nil then
            MTSL_PLAYERS[realm] = {}
            -- Realm exists, so see if we have saved the char already
        else
            current_player = MTSL_PLAYERS[realm][name]
        end

        -- Player not found on realm, so save him
        if current_player == nil then
            -- Not found so create a new one
            current_player = {
                NAME = name,
                REALM = realm,
                FACTION = faction,
                XP_LEVEL = xp_level,
                TRADESKILLS = {},
            }
            -- Get additional player info to save
            print(MTSLUI_FONTS.COLORS.TEXT.WARNING .. "MTSL: Saving new player. Please open all profession windows to save skills")
            -- new player added so sort the table (first the realms, then for new realm, sort by name
            MTSL_PLAYERS[realm][name] = current_player
            table.sort(MTSL_PLAYERS, function(a, b) return a < b end)
            table.sort(MTSL_PLAYERS[realm], function(a, b) return a.name < b.name end)
        else
            print(MTSLUI_FONTS.COLORS.TEXT.SUCCESS .. "MTSL: Player " .. current_player.NAME .. " (" .. current_player.XP_LEVEL .. ", " .. current_player.FACTION .. ") on " .. current_player.REALM .. " loaded")
        end
        -- set the loaded or created player as current one
        MTSL_CURRENT_PLAYER = current_player
        -- Update faction & xp_level, just in case
        MTSL_CURRENT_PLAYER.XP_LEVEL = xp_level
        MTSL_CURRENT_PLAYER.FACTION = faction
    end,

    ------------------------------------------------------------------------------------------------
    -- Removes a character from the saved data
    --
    -- @name        String      The name of the character
    -- @realm       String      The name of the realm
    ------------------------------------------------------------------------------------------------
    RemoveCharacter = function(self, name, realm)
        MTSL_LOGIC_SAVED_VARIABLES:RemoveCharacter(name, realm)
    end,

    ------------------------------------------------------------------------------------------------
    -- Returns the number of characters
    --
    -- returns 	Number		The number of chars (on that realm)
    ------------------------------------------------------------------------------------------------
    CountPlayers = function(self)
        local amount = 0
        for k, realm in pairs(MTSL_PLAYERS) do
            amount = amount + self:CountPlayersOnRealm(k)
        end

        return amount
    end,

    ------------------------------------------------------------------------------------------------
    -- Returns the number of characters
    --
    -- @realm	String 		The name of the realm
    --
    -- returns 	Number		The number of chars on that realm
    ------------------------------------------------------------------------------------------------
    CountPlayersOnRealm = function(self, realm)
        return MTSL_TOOLS:CountItemsInNamedArray(MTSL_PLAYERS[realm])
    end,

    ------------------------------------------------------------------------------------------------
    -- Converts old savedvariables using PRIMARY and SECONDARY to new layout
    ------------------------------------------------------------------------------------------------
    ConvertSavedData = function(self)
        if MTSL_PLAYERS ~= nil and MTSL_PLAYERS ~= {} then
            -- loop realms
            for a, b in pairs(MTSL_PLAYERS) do
                -- loop players
                for c, d in pairs(b) do
                    -- move the primary to an index
                    if d.TRADESKILLS.PRIMARY ~= nil and d.TRADESKILLS.PRIMARY ~= 0 and d.TRADESKILLS.PRIMARY.NAME ~= nil then
                        -- dont move/copy if poisons
                        if d.TRADESKILLS.PRIMARY.NAME ~= "Poisons" then
                            d.TRADESKILLS[d.TRADESKILLS.PRIMARY.NAME] = self:CopyObject(d.TRADESKILLS.PRIMARY)
                        end
                    end
                    d.TRADESKILLS.PRIMARY = nil
                    -- move the secondary to an index
                    if d.TRADESKILLS.SECONDARY ~= nil and TRADESKILLS.SECONDARY ~= 0 and d.TRADESKILLS.SECONDARY.NAME ~= nil then
                        -- dont move/copy if poisons
                        if d.TRADESKILLS.SECONDARY.NAME ~= "Poisons" then
                            d.TRADESKILLS[d.TRADESKILLS.SECONDARY.NAME] = self:CopyObject(d.TRADESKILLS.SECONDARY)
                        end
                    end
                    d.TRADESKILLS.SECONDARY = nil
                    -- change the uppercasing and name of first aid and cooking
                    if d.TRADESKILLS.COOKING ~= nil and TRADESKILLS.COOKING ~= 0 then
                        d.TRADESKILLS["Cooking"] = self:CopyObject(d.TRADESKILLS.COOKING)
                    end
                    d.TRADESKILLS.COOKING = nil
                    if d.TRADESKILLS.FIRST_AID ~= nil and TRADESKILLS.FIRST_AID ~= 0 then
                        d.TRADESKILLS["First Aid"] = self:CopyObject(d.TRADESKILLS.FIRST_AID)
                    end
                    d.TRADESKILLS.FIRST_AID = nil
                end
            end
        end
    end,
}