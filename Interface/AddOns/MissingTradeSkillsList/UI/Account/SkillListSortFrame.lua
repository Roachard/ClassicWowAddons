----------------------------------------------------------
-- Name: SkillListFrame									--
-- Description: Shows all the skills for one profession --
-- Parent Frame: DatabaseFrame							--
----------------------------------------------------------

MTSLACCUI_SKILL_LIST_SORT_FRAME = {
    -- Keeps the current created frame
    ui_frame,
    -- width of the frame
    FRAME_WIDTH = 345,
    -- height of the frame
    FRAME_HEIGHT = 45,
    -- keep track of current sort mehod (1 = name (default), 2 = level)
    current_sort = 1,
    -- Filtering active (flag indicating if changing drop downs has effect, default 0)
    filtering_active = 0,

    ----------------------------------------------------------------------------------------------------------
    -- Intialises the MissingSkillsListFrame
    --
    -- @parent_frame		Frame		The parent frame
    ----------------------------------------------------------------------------------------------------------
    Initialise = function(self, parent_frame)
        -- create the container frame
        self.ui_frame = MTSLUI_TOOLS:CreateBaseFrame("Frame", "", parent_frame, nil, self.FRAME_WIDTH, self.FRAME_HEIGHT, false)
        -- position under TitleFrame and right of ProfessionListFrame
        self.ui_frame:SetPoint("TOPLEFT", MTSLACCUI_PROFESSION_LIST_FRAME.ui_frame, "TOPRIGHT", 0, 0)
        self.sorts = {
            {
                ["name"] = MTSLUI_LOCALES_LABELS["name"][MTSLUI_CURRENT_LANGUAGE],
                ["id"] = 1,
            },
            {
                ["name"] = MTSLUI_LOCALES_LABELS["level"][MTSLUI_CURRENT_LANGUAGE],
                ["id"] = 2,
            }
        }
        -- create a filter for sorting
        -- create the sort frame with text and 2 buttons
        self.ui_frame.sort_by_text = MTSLUI_TOOLS:CreateLabel(self.ui_frame, MTSLUI_LOCALES_LABELS["sort"][MTSLUI_CURRENT_LANGUAGE], 6, -4, "NORMAL", "TOPLEFT")
        self.ui_frame.sort_drop_down = CreateFrame("Frame", "MTSLACCUI_SKILL_LIST_SORT_FRAME_DD_SORTING", self.ui_frame, "UIDropDownMenuTemplate")
        self.ui_frame.sort_drop_down:SetPoint("TOPLEFT", self.ui_frame.sort_by_text, "TOPRIGHT", -10, 10)
        self.ui_frame.sort_drop_down.initialize = self.CreateDropDownSorting
        UIDropDownMenu_SetWidth(self.ui_frame.sort_drop_down, 100)
        UIDropDownMenu_SetText(self.ui_frame.sort_drop_down, MTSLUI_LOCALES_LABELS["name"][MTSLUI_CURRENT_LANGUAGE])
    end,
    ----------------------------------------------------------------------------------------------------------
    -- Intialises drop down for sorting
    ----------------------------------------------------------------------------------------------------------
    CreateDropDownSorting = function(self, level)
        MTSLUI_TOOLS:FillDropDown(level, MTSLACCUI_SKILL_LIST_SORT_FRAME.sorts, MTSLACCUI_SKILL_LIST_SORT_FRAME.ChangeSortHandler)
    end,

    --------------------
    --------------------------------------------------------------------------------------
    -- Handles DropDown Change event after changing the sorting
    ----------------------------------------------------------------------------------------------------------
    ChangeSortHandler = function(value, text)
        if value ~= nil then
            MTSLACCUI_SKILL_LIST_SORT_FRAME:ChangeSorting(value, text)
        end
    end,

    ChangeSorting = function(self, value, text)
        self.current_sort = value
        UIDropDownMenu_SetText(self.ui_frame.sort_drop_down, text)
        -- Sort the list if we may
        if self:IsFilteringEnabled() then
            MTSLACCUI_SKILL_LIST_FRAME:SortSkills(value)
        end
    end,

    ----------------------------------------------------------------------------------------------------------
    -- Shows if the filtering is enabled
    ----------------------------------------------------------------------------------------------------------
    IsFilteringEnabled = function (self)
        return self.filtering_active == 1
    end,


    ----------------------------------------------------------------------------------------------------------
    -- Enable the filtering
    ----------------------------------------------------------------------------------------------------------
    EnableFiltering = function (self)
        self.filtering_active = 1
    end,

    ----------------------------------------------------------------------------------------------------------
    -- Disable the filtering
    ----------------------------------------------------------------------------------------------------------
    DisableFiltering = function (self)
        self.filtering_active = 0
    end,
}