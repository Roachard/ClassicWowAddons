------------------------------------------------------------------
-- Name: ProgressBar											--
-- Description: Contains all functionality for the progressbar	--
-- Parent Frame: MissingTradeSkillsListFrame					--
------------------------------------------------------------------

MTSLUI_MTSLF_PROGRESSBAR = {
    ui_frame,
    FRAME_WIDTH_VERTICAL = 855,
    FRAME_HEIGHT = 24,
    FRAME_WIDTH_HORIZONTAL = 510,

    ----------------------------------------------------------------------------------------------------------
    -- Intialises  the progressbar
    ----------------------------------------------------------------------------------------------------------
    Initialise = function (self, parent_frame)
        self.ui_frame = MTSLUI_TOOLS:CreateBaseFrame("Frame", "MTSLUI_MTSLF_ProgressBar", parent_frame, nil, self.FRAME_WIDTH_VERTICAL, self.FRAME_HEIGHT)
        -- Position at bottom of MissingTradeSkillsListFrame
        self.ui_frame:SetPoint("TOPRIGHT", MTSLUI_MTSLF_DETAILS_SELECTED_SKILL_FRAME.ui_frame, "BOTTOMRIGHT", 2, 0)
        local text = MTSLUI_FONTS.COLORS.TEXT.TITLE .. MTSLUI_LOCALES_LABELS["missing skills"][MTSLUI_CURRENT_LANGUAGE]
        self.ui_frame.text = MTSLUI_TOOLS:CreateLabel(self.ui_frame, text, 5, 0, "SMALL", "LEFT")

        self.ui_frame.progressbar = MTSL_TOOLS:CopyObject(MTSLUI_PROGRESSBAR)
        -- Update the parent frame & position of the generic progressbar
        self.ui_frame.progressbar:Initialise(self.ui_frame, "MTSLUI_MTSLF_ProgressBar", self.FRAME_WIDTH_VERTICAL - 150, self.FRAME_HEIGHT, 148)
    end,

    ----------------------------------------------------------------------------------------------------------
    -- Updates the values shown on the progressbar
    --
    -- @skills_learned		number		The amount of skills learned for the current tradeskill
    -- @max_skills			number		The maximum amount of skills to be learned for the current tradeskill
    ----------------------------------------------------------------------------------------------------------
    UpdateStatusbar = function (self, skills_learned, max_skills)
        self.ui_frame.progressbar:UpdateStatusbar(1, max_skills, skills_learned)
    end,

    -- Switch to vertical split layout
    ResizeToVerticalMode = function(self)
        -- no need for height cause its same in both modes
        self.ui_frame:SetWidth(self.FRAME_WIDTH_VERTICAL)
        -- resize the progressbar
        self.ui_frame.progressbar:ResizeFrame(self.FRAME_WIDTH_VERTICAL - 150, self.FRAME_HEIGHT)
    end,

    -- Switch to horizontal split layout
    ResizeToHorizontalMode = function(self)
        -- no need for height cause its same in both modes
        self.ui_frame:SetWidth(self.FRAME_WIDTH_HORIZONTAL)
        -- resize the progressbar
        self.ui_frame.progressbar:ResizeFrame(self.FRAME_WIDTH_HORIZONTAL - 150, self.FRAME_HEIGHT)
    end,
}