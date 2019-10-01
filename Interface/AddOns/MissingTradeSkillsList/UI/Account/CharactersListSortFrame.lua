----------------------------------------------------------
-- Name: SkillListFrame									--
-- Description: Shows all the skills for one profession --
-- Parent Frame: DatabaseFrame							--
----------------------------------------------------------

MTSLACCUI_CHARACTERS_LIST_SORT_FRAME = {
    -- Keeps the current created frame
    ui_frame,
    -- width of the frame
    FRAME_WIDTH = 305,
    -- height of the frame
    FRAME_HEIGHT = 30,

    ----------------------------------------------------------------------------------------------------------
    -- Intialises the MissingSkillsListFrame
    --
    -- @parent_frame		Frame		The parent frame
    ----------------------------------------------------------------------------------------------------------
    Initialise = function(self, parent_frame)
        -- create the container frame
        self.ui_frame = MTSLUI_TOOLS:CreateBaseFrame("Frame", "", parent_frame, nil, self.FRAME_WIDTH, self.FRAME_HEIGHT, false)
        -- position under TitleFrame and right of ProfessionListFrame
        self.ui_frame:SetPoint("TOPLEFT", MTSLACCUI_TITLE_FRAME.ui_frame, "BOTTOMLEFT", 4, -5)
        self.sorts = {
            {
                ["name"] = MTSLUI_LOCALES_LABELS["name"][MTSLUI_CURRENT_LANGUAGE],
                ["id"] = 1,
            },
            {
                ["name"] = MTSLUI_LOCALES_LABELS["realm"][MTSLUI_CURRENT_LANGUAGE],
                ["id"] = 2,
            }
        }
        -- create a filter for sorting
        -- create the sort frame with text and 2 buttons
        self.ui_frame.sort_by_text = MTSLUI_TOOLS:CreateLabel(self.ui_frame, MTSLUI_LOCALES_LABELS["sort"][MTSLUI_CURRENT_LANGUAGE], 5, 0, "NORMAL", "TOPLEFT")
        self.ui_frame.sort_drop_down = CreateFrame("Frame", "MTSLDBUI_SKILL_LIST_SORT_FRAME_DD_SORTING", self.ui_frame, "UIDropDownMenuTemplate")
        self.ui_frame.sort_drop_down:SetPoint("TOPLEFT", self.ui_frame.sort_by_text, "TOPRIGHT", -10, 9)
        self.ui_frame.sort_drop_down.initialize = self.CreateDropDownSorting
        UIDropDownMenu_SetWidth(self.ui_frame.sort_drop_down, 100)
        UIDropDownMenu_SetText(self.ui_frame.sort_drop_down, MTSLUI_LOCALES_LABELS["realm"][MTSLUI_CURRENT_LANGUAGE])
    end,

    ----------------------------------------------------------------------------------------------------------
    -- Intialises drop down for sorting
    ----------------------------------------------------------------------------------------------------------
    CreateDropDownSorting = function(self, level)
        MTSLUI_TOOLS:FillDropDown(level, MTSLACCUI_CHARACTERS_LIST_SORT_FRAME.sorts, MTSLACCUI_CHARACTERS_LIST_SORT_FRAME.ChangeSortHandler)
    end,

    --------------------------------------------------------------------------------------
    -- Handles DropDown Change event after changing the sorting
    ----------------------------------------------------------------------------------------------------------
    ChangeSortHandler = function(value, text)
        if value ~= nil then
            MTSLACCUI_CHARACTERS_LIST_SORT_FRAME:ChangeSorting(value, text)
        end
    end,

    ChangeSorting = function(self, value, text)
        self.current_sort = value
        UIDropDownMenu_SetText(self.ui_frame.sort_drop_down, text)
        MTSLACCUI_CHARACTERS_LIST_FRAME:SortPlayers(value)
    end,
}