------------------------------------------------------
-- Contains all functions for addon/saved variables --
------------------------------------------------------
----------------------------------
-- Creates all saved variables --
----------------------------------
MTSLUI_SCALE = nil

MTSLUI_SAVED_VARIABLES = {
    ------------------------------------------------------------------------------------------------
    -- Reset the content of the savedvariable to have a "clean" install
    ------------------------------------------------------------------------------------------------
    ResetSavedVariables = function(self)
        MTSLUI_SCALE = 0.7
    end,

    ------------------------------------------------------------------------------------------------
    -- Scales the UI of the addon
    --
    -- @scale			Number			The number for UI scale (must be > 0.5 and < 1.25)
    ------------------------------------------------------------------------------------------------
    SetScale = function(self, scale)
        if scale == nil or scale < 0.5 or scale > 1.25 then
            print(MTSLUI_FONTS.COLORS.TEXT.ERROR .. "MTSL: scale must be a number between 0.5 and 1.25")
        else
            -- save the scale for next session
            MTSLUI_SCALE = scale
            -- rescale the main UI components/frames
            -- NO need to rescale MTSLUI_MISSING_TRADESKILLS_FRAME, it inherits scale from MTSLUI_TOGGLE_BUTTON
            MTSLDBUI_DATABASE_FRAME.ui_frame:SetScale(scale)
            MTSLACCUI_DATABASE_FRAME.ui_frame:SetScale(scale)
        end
    end,

    ------------------------------------------------------------------------------------------------
    -- Gets he scale of the UI of the addon
    --
    -- return			Number			The number for UI scale (will be > 0.5 and < 1.25)
    ------------------------------------------------------------------------------------------------
    GetScale = function(self)
        -- fresh addon started, so save the players scale
        if MTSLUI_SCALE == nil then
            -- save the default scale
            MTSLUI_SCALE = 0.7
            print(MTSLUI_FONTS.COLORS.TEXT.ERROR .. "MTSL: scale has been reset to default value (" .. MTSLUI_SCALE .. ")")
        end
        return MTSLUI_SCALE
    end,
}