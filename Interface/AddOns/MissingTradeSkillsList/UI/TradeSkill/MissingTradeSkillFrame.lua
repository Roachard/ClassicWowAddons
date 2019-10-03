-----------------------------------------------------------------
-- Name: MissingTradeSkillFrame			                       --
-- Description: The main frame shown next to TradeSkill window --
-----------------------------------------------------------------
MTSLUI_MISSING_TRADESKILLS_FRAME = {
    ui_frame = nil,
    -- Addon frame
    FRAME_WIDTH_VERTICAL_SPLIT = 865,
    FRAME_HEIGHT_VERTICAL_SPLIT = 445,
    -- means the list moves on top, so reduct size here (-345)
    FRAME_WIDTH_HORIZONTAL_SPLIT = 520,
    -- add the height of the new listframe (shows 7 instead of 19 items)
    FRAME_HEIGHT_HORIZONTAL_SPLIT = 628,
    prev_amount_missing = "",
    prev_tradeskill_name = "",

    ----------------------------------------------------------------------------------------------------------
    -- Hides the frame
    ----------------------------------------------------------------------------------------------------------
    Hide = function (self)
        self.ui_frame:Hide()
        -- deselect any button from the list
        MTSLUI_MTSLF_MISSING_SKILLS_LIST_FRAME:DeselectCurrentSkillButton()
        prev_amount_missing = ""
        prev_tradeskill_name = ""
    end,

    ----------------------------------------------------------------------------------------------------------
    -- Shows the frame
    ----------------------------------------------------------------------------------------------------------
    Show = function (self)
        self.ui_frame:Show()
        -- update the UI of the screen
        self:RefreshUI()
    end,

    ----------------------------------------------------------------------------------------------------------
    -- Toggle the frame
    ----------------------------------------------------------------------------------------------------------
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
        self.ui_frame = MTSLUI_TOOLS:CreateBaseFrame("Frame", "MTSLUI_MissingTradeSkillsFrame", MTSLUI_TOGGLE_BUTTON.ui_frame, nil, self.FRAME_WIDTH_VERTICAL_SPLIT, self.FRAME_HEIGHT_VERTICAL_SPLIT, true)
        self.ui_frame:SetBackdropColor(0,0,0,1)
        -- Set Position relative to MTSL button
        self.ui_frame:SetPoint("TOPLEFT", MTSLUI_TOGGLE_BUTTON.ui_frame, "TOPRIGHT", -2, 0)
        -- Dummy operation to do nothing, discarding the zooming in/out
        self.ui_frame:SetScript("OnMouseWheel", function()
            local x = 1
        end)
        self.ui_frame:Hide()

        -- Create the frames inside this frame
        MTSLUI_MTSLF_TITLE_FRAME:Initialise(self.ui_frame)
        MTSLUI_MTSLF_MISSING_SKILLS_LIST_SORT_FRAME:Initialise(MTSLUI_MTSLF_TITLE_FRAME.ui_frame)
        MTSLUI_MTSLF_MISSING_SKILLS_LIST_FRAME:Initialise(MTSLUI_MTSLF_MISSING_SKILLS_LIST_SORT_FRAME.ui_frame)
        MTSLUI_MTSLF_DETAILS_SELECTED_SKILL_FRAME:Initialise(MTSLUI_MTSLF_MISSING_SKILLS_LIST_FRAME.ui_frame)
        MTSLUI_MTSLF_PROGRESSBAR:Initialise(MTSLUI_MTSLF_DETAILS_SELECTED_SKILL_FRAME.ui_frame)
    end,

    ----------------------------------------------------------------------------------------------------------
    -- Swap to Vertical Mode (Default mode, means list left & details right)
    ----------------------------------------------------------------------------------------------------------
    SwapToVerticalMode = function(self)
        -- resize the frames
        self.ui_frame:SetWidth(self.FRAME_WIDTH_VERTICAL_SPLIT)
        self.ui_frame:SetHeight(self.FRAME_HEIGHT_VERTICAL_SPLIT)
        MTSLUI_MTSLF_TITLE_FRAME:ResizeToVerticalMode()
        MTSLUI_MTSLF_MISSING_SKILLS_LIST_SORT_FRAME:ResizeToVerticalMode()
        MTSLUI_MTSLF_MISSING_SKILLS_LIST_FRAME:ResizeToVerticalMode()
        MTSLUI_MTSLF_DETAILS_SELECTED_SKILL_FRAME:ResizeToVerticalMode()
        MTSLUI_MTSLF_PROGRESSBAR:ResizeToVerticalMode()
    end,
    ----------------------------------------------------------------------------------------------------------
    -- Swap to Horizontal Mode (means list on top & details below)
    ----------------------------------------------------------------------------------------------------------
    SwapToHorizontalMode = function(self)
        -- resize the frames where needed
        self.ui_frame:SetWidth(self.FRAME_WIDTH_HORIZONTAL_SPLIT)
        self.ui_frame:SetHeight(self.FRAME_HEIGHT_HORIZONTAL_SPLIT)
        MTSLUI_MTSLF_TITLE_FRAME:ResizeToHorizontalMode()
        MTSLUI_MTSLF_MISSING_SKILLS_LIST_SORT_FRAME:ResizeToHorizontalMode()
        MTSLUI_MTSLF_MISSING_SKILLS_LIST_FRAME:ResizeToHorizontalMode()
        MTSLUI_MTSLF_DETAILS_SELECTED_SKILL_FRAME:ResizeToHorizontalMode()
        MTSLUI_MTSLF_PROGRESSBAR:ResizeToHorizontalMode()
    end,

    ----------------------------------------------------------------------------------------------------------
    -- Refresh the ui of the addon
    ----------------------------------------------------------------------------------------------------------
    RefreshUI = function (self)
        -- only refresh if this window is visible & if we have learend a skill or swapped tradeskill
        if self:IsShown() then
            if self.prev_tradeskill_name ~= MTSL_CURRENT_TRADESKILL.NAME or
                self.prev_amount_missing ~= MTSL_CURRENT_TRADESKILL.AMOUNT_MISSING then
                -- Refresh the UI frame showing the list of skill
                MTSLUI_MTSLF_MISSING_SKILLS_LIST_FRAME:UpdateList()
                -- Update the progressbar on bottom
                local skills_max_amount = MTSL_TOOLS:GetTotalNumberOfAvailableSkills(MTSL_CURRENT_TRADESKILL.NAME, MTSL_CURRENT_PHASE) + MTSL_DATA.TRADESKILL_LEVELS
                MTSLUI_MTSLF_PROGRESSBAR:UpdateStatusbar(MTSL_CURRENT_TRADESKILL.AMOUNT_MISSING, skills_max_amount)
                self:NoSkillSelected()
            end
            self.prev_tradeskill_name = MTSL_CURRENT_TRADESKILL.NAME
            self.prev_amount_missing = MTSL_CURRENT_TRADESKILL.AMOUNT_MISSING
            -- if we miss skills, auto select first one (only do if we dont have one selected)
            if not MTSLUI_MTSLF_MISSING_SKILLS_LIST_FRAME:HasSkillSelected() or not MTSLUI_MTSLF_MISSING_SKILLS_LIST_FRAME:StillMissingSkill() then
                MTSLUI_MTSLF_MISSING_SKILLS_LIST_FRAME:HandleSelectedListItem(1)
            end
        end
    end,

    --------------------------------
    -- When no skill is selected
    -------------------------------
    NoSkillSelected = function (self)
        MTSLUI_MTSLF_MISSING_SKILLS_LIST_FRAME:DeselectCurrentSkillButton()
        MTSLUI_MTSLF_DETAILS_SELECTED_SKILL_FRAME:ShowNoSkillSelected()
    end
}
