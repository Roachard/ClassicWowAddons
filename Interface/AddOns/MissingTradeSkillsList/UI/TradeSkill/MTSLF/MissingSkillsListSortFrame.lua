----------------------------------------------------------
-- Name: SkillListFrame									--
-- Description: Shows all the skills for one profession --
-- Parent Frame: DatabaseFrame							--
----------------------------------------------------------

MTSLUI_MTSLF_MISSING_SKILLS_LIST_SORT_FRAME = {
    -- Keeps the current created frame
    ui_frame,
    -- width of the frame
    FRAME_WIDTH = 345,
    -- height of the frame
    FRAME_HEIGHT = 28,
    -- keep track of current sort mehod (1 = name (default), 2 = level)
    current_sort = 1,
    -- keep the current continent and zone we filter
    current_cont,
    current_zone,
    phases = {},
    -- keeps track of current phase used for filtering
    current_phase,
    cont_zones = {},
    current_cont_zone,

    ----------------------------------------------------------------------------------------------------------
    -- Intialises the MissingSkillsListFrame
    --
    -- @parent_frame		Frame		The parent frame
    ----------------------------------------------------------------------------------------------------------
    Initialise = function(self, parent_frame)
        -- create the container frame
        self.ui_frame = MTSLUI_TOOLS:CreateBaseFrame("Frame", "", parent_frame, nil, self.FRAME_WIDTH, self.FRAME_HEIGHT, false)
        -- position under TitleFrame and right of ProfessionListFrame
        self.ui_frame:SetPoint("TOPLEFT", MTSLUI_MISSING_TRADESKILLS_FRAME.ui_frame, "TOPLEFT", 3, -30)
        self:LoadContinentsAndZones()
        self.current_cont_zone = 0
        -- create a filter for the zones
        self.ui_frame.zone_text = MTSLUI_TOOLS:CreateLabel(self.ui_frame, MTSLUI_LOCALES_LABELS["zone"][MTSLUI_CURRENT_LANGUAGE], 5, 3, "NORMAL", "BOTTOMLEFT")
        -- Continent (Too many zones too show just all)
        self.ui_frame.cont_zone_drop_down = CreateFrame("Frame", "MTSLDBUI_SKILL_LIST_SORT_FRAME_DD_CONTZONES", self.ui_frame, "UIDropDownMenuTemplate")
        self.ui_frame.cont_zone_drop_down:SetPoint("TOPLEFT", self.ui_frame.zone_text, "TOPRIGHT", -5, 11)
        self.ui_frame.cont_zone_drop_down.initialize = self.CreateDropDownContinentsAndZones
        UIDropDownMenu_SetWidth(self.ui_frame.cont_zone_drop_down, 280)
        UIDropDownMenu_SetText(self.ui_frame.cont_zone_drop_down, MTSLUI_LOCALES_LABELS["any"][MTSLUI_CURRENT_LANGUAGE])
    end,

    LoadContinentsAndZones = function(self)
        -- build the arrays with contintents and zones
        self.cont_zones = {
            {
                ["name"] = MTSLUI_LOCALES_LABELS["any"][MTSLUI_CURRENT_LANGUAGE],
                ["id"] = 0,
            },
        }

        -- only add current zone if possible (gives trouble while changing zones or not zone not triggering on load)
        local current_zone_name = GetRealZoneText()
        local current_zone = MTSL_LOGIC_WORLD:GetZoneByName(current_zone_name)
        if current_zone ~= nil then
            local zone_filter = {
                ["name"] = MTSLUI_LOCALES_LABELS["current"][MTSLUI_CURRENT_LANGUAGE] .. " (" .. current_zone_name .. ")",
                ["id"] = current_zone.id,
            }
            table.insert(self.cont_zones, zone_filter)
        end
    end,

    ----------------------------------------------------------------------------------------------------------
    -- Intialises drop down for continents/zones
    ----------------------------------------------------------------------------------------------------------
    CreateDropDownContinentsAndZones = function(self, level)
        -- update the current zone
        MTSLUI_MTSLF_MISSING_SKILLS_LIST_SORT_FRAME:LoadContinentsAndZones()
        MTSLUI_TOOLS:FillDropDown(level, MTSLUI_MTSLF_MISSING_SKILLS_LIST_SORT_FRAME.cont_zones, MTSLUI_MTSLF_MISSING_SKILLS_LIST_SORT_FRAME.ChangeContinentZoneHandler)
    end,

    ----------------------------------------------------------------------------------------------------------
    -- Handles DropDown Change event after changing the continent & zone
    ----------------------------------------------------------------------------------------------------------
    ChangeContinentZoneHandler = function(value, text)
        if value ~= nil and value ~= MTSLUI_MTSLF_MISSING_SKILLS_LIST_SORT_FRAME.current_cont_zone then
            MTSLUI_MTSLF_MISSING_SKILLS_LIST_SORT_FRAME:ChangeContinentZone(value, text)
        end
    end,

    ChangeContinentZone = function(self, id, text)
        self.current_cont_zone = id
        UIDropDownMenu_SetText(self.ui_frame.cont_zone_drop_down, text)
        -- Sort the list if we may
        MTSLUI_MTSLF_MISSING_SKILLS_LIST_FRAME:ChangeZone(id)
    end,
}