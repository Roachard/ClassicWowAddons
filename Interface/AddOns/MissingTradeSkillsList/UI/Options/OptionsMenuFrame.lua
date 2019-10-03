--------------------------------------------------
-- Name: OptionsMenuFrame			            --
-- Description: Shows user configurable options --
--      Font                                    --
--      Scale for each frame                    --
--      Layout MTSL frame                       --
--------------------------------------------------
MTSLUI_OPTIONS_MENU_FRAME = {
    ui_frame = nil,
    -- Addon frame
    FRAME_WIDTH = 600,
    FRAME_HEIGHT = 400,

    ---------------------------------------------------------------------------------------
    -- Hides the frame
    ----------------------------------------------------------------------------------------
    Hide = function (self)
        self.ui_frame:Hide()
    end,

    ---------------------------------------------------------------------------------------
    -- Shows the frame
    ----------------------------------------------------------------------------------------
    Show = function (self)
        -- Make sure any other open windows are closed
        MTSLUI_MISSING_TRADESKILLS_FRAME:Hide()
        MTSLACCUI_ACCOUNT_FRAME:Hide()
        MTSLDBUI_DATABASE_FRAME:Hide()
        -- show the options
        self.ui_frame:Show()
    end,

    ---------------------------------------------------------------------------------------
    -- Toggle the frame
    ----------------------------------------------------------------------------------------
    Toggle = function (self)
        if self:IsShown() then
            self:Hide()
        else
            self:Show()
        end
    end,

    ----------------------------------------------------------------------------------------------------------
    -- Check if frame is shown/visible
    --
    -- returns		boolean      Visibility of the frame
    ----------------------------------------------------------------------------------------------------------
    IsShown = function(self)
        return self.ui_frame:IsVisible()
    end,

    ----------------------------------------------------------------------------------------------------------
    -- Intialises the MissingTradeSkillFrame
    --
    -- @parent_frame		Frame		The parent frame
    ----------------------------------------------------------------------------------------------------------
    Initialise = function(self)
        self.ui_frame = MTSLUI_TOOLS:CreateBaseFrame("Frame", "MTSLUI_Options_Menu_Frame", nil, nil, self.FRAME_WIDTH, self.FRAME_HEIGHT, true)
        -- Set Position to center of screen
        self.ui_frame:SetPoint("CENTER", nil, "CENTER", 0, 0)
        -- Dummy operation to do nothing, discarding the zooming in/out
        self.ui_frame:SetScript("OnMouseWheel", function()
            local x = 1
        end)
        -- add the close button
        self.ui_frame.close_button = MTSLUI_TOOLS:CreateBaseFrame("Button", "", self.ui_frame, "UIPanelButtonTemplate", 24, 24)
        self.ui_frame.close_button:SetText("X")
        -- Set Position to top right of databaseframe
        self.ui_frame.close_button:SetPoint("TOPRIGHT", self.ui_frame, "TOPRIGHT", -2, -2)
        self.ui_frame.close_button:SetScript("OnClick", function()
            MTSLUI_OPTIONS_MENU_FRAME:Hide()
        end)
        self.ui_frame:Hide()
        -- close/hide window on esc
        tinsert(UISpecialFrames, "MTSLUI_Options_Menu_Frame")

        -- initialise the content frames
        MTSLOPTUI_TITLE_FRAME:Initialise(self.ui_frame)
        MTSLOPTUI_CONFIG_FRAME:Initialise(MTSLOPTUI_TITLE_FRAME.ui_frame)
        MTSLOPTUI_SAVE_FRAME:Initialise(MTSLOPTUI_CONFIG_FRAME.ui_frame)
        MTSLOPTUI_RESET_FRAME:Initialise(MTSLOPTUI_SAVE_FRAME.ui_frame)
    end,
}
