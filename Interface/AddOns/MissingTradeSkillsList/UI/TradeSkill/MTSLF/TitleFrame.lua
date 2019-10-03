------------------------------------------------------------------
-- Name: TitleFrame											    --
-- Description: The tile frame									--
-- Parent Frame: MissingTradeSkillsListFrame					--
------------------------------------------------------------------

MTSLUI_MTSLF_TITLE_FRAME = {
    FRAME_WIDTH_VERTICAL = 815,
    FRAME_HEIGHT = 20,
    FRAME_WIDTH_HORIZONTAL = 510,

    ---------------------------------------------------------------------------------------
    -- Initialises the titleframe
    ----------------------------------------------------------------------------------------
    Initialise = function (self, parent_frame)
        self.ui_frame = MTSLUI_TOOLS:CreateBaseFrame("Frame", "MTSLUI_MTSLF_TitleFrame", parent_frame, nil, self.FRAME_WIDTH_VERTICAL, self.FRAME_HEIGHT)
        self.ui_frame:SetBackdropColor(1,1,0,1)
        self.ui_frame:SetPoint("TOPLEFT", parent_frame, "TOPLEFT", 5, -5)
        -- Title text
        local title_text = MTSLUI_FONTS.COLORS.TEXT.TITLE ..MTSLUI_ADDON.NAME .. MTSLUI_FONTS.COLORS.TEXT.NORMAL .. " (by " .. MTSLUI_ADDON.AUTHOR .. ") " .. MTSLUI_FONTS.COLORS.TEXT.TITLE  .. "v" .. MTSLUI_ADDON.VERSION
        self.ui_frame.text = MTSLUI_TOOLS:CreateLabel(self.ui_frame, title_text, 0, 0, "LARGE", "CENTER")
    end,

    -- Switch to vertical split layout
    ResizeToVerticalMode = function(self)
        -- no need for height cause its same in both modes
        self.ui_frame:SetWidth(self.FRAME_WIDTH_VERTICAL)
    end,

    -- Switch to horizontal split layout
    ResizeToHorizontalMode = function(self)
        -- no need for height cause its same in both modes
        self.ui_frame:SetWidth(self.FRAME_WIDTH_HORIZONTAL)
    end,
}