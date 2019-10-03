------------------------------------------------------
-- Contains all functions for addon/saved variables --
------------------------------------------------------
----------------------------------
-- Creates all saved variables --
----------------------------------
MTSLUI_PLAYER = {
    UI_SCALE = {
        MTSL,
        ACCOUNT,
        DATABASE,
        OPTIONSMENU,
    },
    SPLIT_MODE,
    FONT,
}

MTSLUI_SAVED_VARIABLES = {
    DEFAULT_UI_SCALE = "1.00",

    -- Try and load the values from saved files
    Initialise = function(self)
        -- reset all if not found (first time)
        if MTSLUI_PLAYER == nil then
            print(MTSLUI_FONTS.COLORS.TEXT.WARNING .. "MTSL: All saved variables have been reset to default values!")
            MTSLUI_PLAYER = {}
            MTSLUI_PLAYER.UI_SCALE = {}
            MTSLUI_PLAYER.UI_SCALE.MTSL = self.DEFAULT_UI_SCALE
            MTSLUI_PLAYER.UI_SCALE.ACCOUNT = self.DEFAULT_UI_SCALE
            MTSLUI_PLAYER.UI_SCALE.DATABASE = self.DEFAULT_UI_SCALE
            MTSLUI_PLAYER.UI_SCALE.OPTIONSMENU = self.DEFAULT_UI_SCALE
            MTSLUI_PLAYER.SPLIT_MODE = "Vertical"
            MTSLUI_PLAYER.FONT = "Default"
        else
            -- only reset the scale
            if MTSLUI_PLAYER.UI_SCALE == nil then
                MTSLUI_PLAYER.UI_SCALE = {}
                MTSLUI_PLAYER.UI_SCALE.MTSL = self.DEFAULT_UI_SCALE
                MTSLUI_PLAYER.UI_SCALE.ACCOUNT = self.DEFAULT_UI_SCALE
                MTSLUI_PLAYER.UI_SCALE.DATABASE = self.DEFAULT_UI_SCALE
                MTSLUI_PLAYER.UI_SCALE.OPTIONSMENU = self.DEFAULT_UI_SCALE
            else
                if MTSLUI_PLAYER.UI_SCALE.MTSL == nil then
                    MTSLUI_PLAYER.UI_SCALE.MTSL = self.DEFAULT_UI_SCALE
                end
                if MTSLUI_PLAYER.UI_SCALE.ACCOUNT == nil then
                    MTSLUI_PLAYER.UI_SCALE.ACCOUNT = self.DEFAULT_UI_SCALE
                end
                if MTSLUI_PLAYER.UI_SCALE.DATABASE == nil then
                    MTSLUI_PLAYER.UI_SCALE.DATABASE = self.DEFAULT_UI_SCALE
                end
                if MTSLUI_PLAYER.UI_SCALE.OPTIONSMENU == nil then
                    MTSLUI_PLAYER.UI_SCALE.OPTIONSMENU = self.DEFAULT_UI_SCALE
                end
            end
            if MTSLUI_PLAYER.SPLIT_MODE ~= "Vertical" and MTSLUI_PLAYER.SPLIT_MODE ~= "Horizontal" then
                MTSLUI_PLAYER.SPLIT_MODE = "Vertical"
            end
            -- todo: add check for font, ignored for now
            if MTSLUI_PLAYER.FONT ~= "Default" then
                MTSLUI_PLAYER.FONT = "Default"
            end
        end
    end,

    ------------------------------------------------------------------------------------------------
    -- Reset the content of the savedvariable to have a "clean" install
    ------------------------------------------------------------------------------------------------
    ResetSavedVariables = function(self)
        MTSLUI_PLAYER = nil
        self:Initialise()
        self:LoadSavedSplitMode()
        self:LoadSavedUIScales()
    end,

    ------------------------------------------------------------------------------------------------
    -- Load the saved splitmode from saved variable
    ------------------------------------------------------------------------------------------------
    LoadSavedSplitMode = function(self)
        if MTSLUI_PLAYER == nil then
            self:ResetSavedVariables()
        else
            if MTSLUI_PLAYER.SPLIT_MODE ~= "Vertical" and MTSLUI_PLAYER.SPLIT_MODE ~= "Horizontal" then
                MTSLUI_PLAYER.SPLIT_MODE = "Vertical"
                print(MTSLUI_FONTS.COLORS.TEXT.ERROR .. "MTSL: Splitmode was reset to Vertical")
                else
                -- adjust the frames according to saved variable
                if MTSLUI_PLAYER.SPLIT_MODE == "Vertical" then
                    MTSLUI_MISSING_TRADESKILLS_FRAME:SwapToVerticalMode()
                else
                    MTSLUI_MISSING_TRADESKILLS_FRAME:SwapToHorizontalMode()
                end
            end
        end
    end,

    ------------------------------------------------------------------------------------------------
    -- Load the saved scales from saved variable
    ------------------------------------------------------------------------------------------------
    LoadSavedUIScales = function(self)
        if MTSLUI_PLAYER == nil then
            self:ResetSavedVariables()
        else
            -- convert old to new also
            if MTSLUI_PLAYER.UI_SCALE == nil then
                MTSLUI_PLAYER.UI_SCALE = {}
                MTSLUI_PLAYER.UI_SCALE.MTSL = self.DEFAULT_UI_SCALE
                MTSLUI_PLAYER.UI_SCALE.ACCOUNT = self.DEFAULT_UI_SCALE
                MTSLUI_PLAYER.UI_SCALE.DATABASE = self.DEFAULT_UI_SCALE
                MTSLUI_PLAYER.UI_SCALE.OPTIONSMENU = self.DEFAULT_UI_SCALE
                print(MTSLUI_FONTS.COLORS.TEXT.WARNING .. "MTSL: All UI scales were reset to 1.0!")
            else
                if  MTSLUI_PLAYER.UI_SCALE.MTSL == nil or tonumber(MTSLUI_PLAYER.UI_SCALE.MTSL) < 0.5 or tonumber(MTSLUI_PLAYER.UI_SCALE.MTSL) > 1.25 then
                    MTSLUI_PLAYER.UI_SCALE.MTSL = self.DEFAULT_UI_SCALE
                    print(MTSLUI_FONTS.COLORS.TEXT.ERROR .. "MTSL: MTSL UI scale was reset to 1.0!")
                end
                if MTSLUI_PLAYER.UI_SCALE.ACCOUNT == nil or tonumber(MTSLUI_PLAYER.UI_SCALE.ACCOUNT) < 0.5 or tonumber(MTSLUI_PLAYER.UI_SCALE.ACCOUNT) > 1.25 then
                    MTSLUI_PLAYER.UI_SCALE.ACCOUNT = self.DEFAULT_UI_SCALE
                    print(MTSLUI_FONTS.COLORS.TEXT.ERROR .. "MTSL: Account explorer UI scale was reset to 1.0!")
                end
                if MTSLUI_PLAYER.UI_SCALE.DATABASE == nil or tonumber(MTSLUI_PLAYER.UI_SCALE.DATABASE) < 0.5 or tonumber(MTSLUI_PLAYER.UI_SCALE.DATABASE) > 1.25 then
                    MTSLUI_PLAYER.UI_SCALE.DATABASE = self.DEFAULT_UI_SCALE
                    print(MTSLUI_FONTS.COLORS.TEXT.ERROR .. "MTSL: Database explorer UI scale was reset to 1.0!")
                end
                if MTSLUI_PLAYER.UI_SCALE.OPTIONSMENU == nil or tonumber(MTSLUI_PLAYER.UI_SCALE.OPTIONSMENU) < 0.5 or tonumber(MTSLUI_PLAYER.UI_SCALE.OPTIONSMENU) > 1.25 then
                    MTSLUI_PLAYER.UI_SCALE.OPTIONSMENU = self.DEFAULT_UI_SCALE
                    print(MTSLUI_FONTS.COLORS.TEXT.ERROR .. "MTSL: Options menu UI scale was reset to 1.0!")
                end
            end
            MTSLUI_MISSING_TRADESKILLS_FRAME.ui_frame:SetScale(tonumber(MTSLUI_PLAYER.UI_SCALE.MTSL))
            MTSLACCUI_ACCOUNT_FRAME.ui_frame:SetScale(tonumber(MTSLUI_PLAYER.UI_SCALE.ACCOUNT))
            MTSLDBUI_DATABASE_FRAME.ui_frame:SetScale(tonumber(MTSLUI_PLAYER.UI_SCALE.DATABASE))
            MTSLUI_OPTIONS_MENU_FRAME.ui_frame:SetScale(tonumber(MTSLUI_PLAYER.UI_SCALE.OPTIONSMENU))
        end
    end,

    ------------------------------------------------------------------------------------------------
    -- Set splitmode
    ------------------------------------------------------------------------------------------------
    SetSplitMode = function(self, split_mode)
        -- only update splitmode if valid or needed
        if split_mode == "Vertical" or split_mode == "Horizontal" and MTSLUI_PLAYER.SPLIT_MODE ~= split_mode then
            MTSLUI_PLAYER.SPLIT_MODE = split_mode
            -- adjust the frames according to saved variable
            if split_mode == "Vertical" then
                MTSLUI_MISSING_TRADESKILLS_FRAME:SwapToVerticalMode()
            else
                MTSLUI_MISSING_TRADESKILLS_FRAME:SwapToHorizontalMode()
            end
        end
    end,


    ------------------------------------------------------------------------------------------------
    -- Get splitmode
    ------------------------------------------------------------------------------------------------
    GetSplitMode = function(self)
        return MTSLUI_PLAYER.SPLIT_MODE
    end,

    LoadSavedFont = function(self)

    end,

    ------------------------------------------------------------------------------------------------
    -- Scales the UI of the addon
    --
    -- @scale			Number			The number for UI scale (must be > 0.5 and < 1.25)
    ------------------------------------------------------------------------------------------------
    SetScales = function(self, scales)
        if scales.MTSL ~= nil and tonumber(scales.MTSL) ~= tonumber(MTSLUI_PLAYER.UI_SCALE.MTSL) then
            MTSLUI_PLAYER.UI_SCALE.MTSL = scales.MTSL
            MTSLUI_MISSING_TRADESKILLS_FRAME.ui_frame:SetScale(tonumber(MTSLUI_PLAYER.UI_SCALE.MTSL))
        end
        if scales.ACCOUNT ~= nil and tonumber(scales.ACCOUNT) ~= tonumber(MTSLUI_PLAYER.UI_SCALE.ACCOUNT) then
            MTSLUI_PLAYER.UI_SCALE.ACCOUNT = scales.ACCOUNT
            MTSLACCUI_ACCOUNT_FRAME.ui_frame:SetScale(tonumber(MTSLUI_PLAYER.UI_SCALE.ACCOUNT))
        end
        if scales.DATABASE ~= nil and tonumber(scales.DATABASE) ~= tonumber(MTSLUI_PLAYER.UI_SCALE.DATABASE) then
            MTSLUI_PLAYER.UI_SCALE.DATABASE = scales.DATABASE
            MTSLDBUI_DATABASE_FRAME.ui_frame:SetScale(tonumber(MTSLUI_PLAYER.UI_SCALE.DATABASE))
        end
        if scales.OPTIONSMENU ~= nil and tonumber(scales.OPTIONSMENU) ~= tonumber(MTSLUI_PLAYER.UI_SCALE.OPTIONSMENU) then
            MTSLUI_PLAYER.UI_SCALE.OPTIONSMENU = scales.OPTIONSMENU
            MTSLUI_OPTIONS_MENU_FRAME.ui_frame:SetScale(tonumber(MTSLUI_PLAYER.UI_SCALE.OPTIONSMENU))
        end
    end,

    ------------------------------------------------------------------------------------------------
    -- Gets he scale of the UI of the addon
    --
    -- return			Number			The number for UI scale (will be > 0.5 and < 1.25)
    ------------------------------------------------------------------------------------------------
    GetScale = function(self, name)
        -- fresh addon started, so save the players scale
        for k, v in pairs(MTSLUI_PLAYER.UI_SCALE) do
            if k == name then
                return v
            end
        end
        -- return default if not found
        return self.DEFAULT_SCALE
    end
}