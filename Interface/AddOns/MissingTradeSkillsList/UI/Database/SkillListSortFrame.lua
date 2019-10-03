----------------------------------------------------------
-- Name: SkillListFrame									--
-- Description: Shows all the skills for one profession --
-- Parent Frame: DatabaseFrame							--
----------------------------------------------------------

MTSLDBUI_SKILL_LIST_SORT_FRAME = {
    -- Keeps the current created frame
    ui_frame,
    -- width of the frame
    FRAME_WIDTH = 345,
    -- height of the frame
    FRAME_HEIGHT = 45,
    -- keep track of current sort mehod (1 = name (default), 2 = level)
    current_sort = 1,
    -- keep the current continent and zone we filter
    current_cont,
    current_zone,
    phases = {},
    -- keeps track of current phase used for filtering
    current_phase,
    -- labels for "Current phase"
    labels_phase = {
        ["English"] = "Phase",
        ["French"] = "Phase",
        ["German"] = "Phase",
        ["Russian"] = "фаза",
        ["Korean"] = "단계",
        ["Chinese"] = "相",
        ["Spanish"] = "Fase",
        ["Portuguese"] = "Estágio",
    },
    labels_current = {
        ["English"] = "Current",
        ["French"] = "Actuel",
        ["German"] = "Aktuell",
        ["Russian"] = "актуальный",
        ["Korean"] = "현행의",
        ["Chinese"] = "现实",
        ["Spanish"] = "Actual",
        ["Portuguese"] = "Atual",
    },
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
        self.ui_frame:SetPoint("TOPLEFT", MTSLDBUI_PROFESSION_LIST_FRAME.ui_frame, "TOPRIGHT", 0, -10)
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
        self.ui_frame.sort_by_text = MTSLUI_TOOLS:CreateLabel(self.ui_frame, MTSLUI_LOCALES_LABELS["sort"][MTSLUI_CURRENT_LANGUAGE], 5, 0, "NORMAL", "TOPLEFT")
        self.ui_frame.sort_drop_down = CreateFrame("Frame", "MTSLDBUI_SKILL_LIST_SORT_FRAME_DD_SORTING", self.ui_frame, "UIDropDownMenuTemplate")
        self.ui_frame.sort_drop_down:SetPoint("TOPLEFT", self.ui_frame.sort_by_text, "TOPRIGHT", -10, 9)
        self.ui_frame.sort_drop_down.initialize = self.CreateDropDownSorting
        UIDropDownMenu_SetWidth(self.ui_frame.sort_drop_down, 70)
        UIDropDownMenu_SetText(self.ui_frame.sort_drop_down, MTSLUI_LOCALES_LABELS["name"][MTSLUI_CURRENT_LANGUAGE])
        -- available phases
        self.phases = {
            {
                ["name"] = MTSLUI_LOCALES_LABELS["current"][MTSLUI_CURRENT_LANGUAGE] .. " (" .. MTSL_CURRENT_PHASE .. ")",
                ["id"] = 1,
            },
            {
                ["name"] = MTSLUI_LOCALES_LABELS["any"][MTSLUI_CURRENT_LANGUAGE],
                ["id"] = 2,
            }
        }
        -- default select the "current" phase
        self.current_phase = MTSL_CURRENT_PHASE
        -- create a filter for content phase
        self.ui_frame.phase_text = MTSLUI_TOOLS:CreateLabel(self.ui_frame, self.labels_phase[MTSLUI_CURRENT_LANGUAGE], 192, 0, "NORMAL", "TOPLEFT")
        self.ui_frame.phase_drop_down = CreateFrame("Frame", "MTSLDBUI_SKILL_LIST_SORT_FRAME_DD_PHASES", self.ui_frame, "UIDropDownMenuTemplate")
        self.ui_frame.phase_drop_down:SetPoint("TOPLEFT", self.ui_frame.phase_text, "TOPRIGHT", -10, 9)
        self.ui_frame.phase_drop_down.initialize = self.CreateDropDownPhases
        UIDropDownMenu_SetWidth(self.ui_frame.phase_drop_down, 95)
        UIDropDownMenu_SetText(self.ui_frame.phase_drop_down, self.phases[self.current_phase]["name"])
        self:LoadContinentsAndZones()
        self.current_cont_zone = 0
        -- create a filter for the zones
        self.ui_frame.zone_text = MTSLUI_TOOLS:CreateLabel(self.ui_frame, MTSLUI_LOCALES_LABELS["zone"][MTSLUI_CURRENT_LANGUAGE], 5, 3, "NORMAL", "BOTTOMLEFT")
        -- Continent (Too many zones too show just all)
        self.ui_frame.cont_zone_drop_down = CreateFrame("Frame", "MTSLDBUI_SKILL_LIST_SORT_FRAME_DD_CONTZONES", self.ui_frame, "UIDropDownMenuTemplate")
        self.ui_frame.cont_zone_drop_down:SetPoint("TOPLEFT", self.ui_frame.zone_text, "TOPRIGHT", -6, 9)
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

        local contintents = MTSL_LOGIC_WORLD:GetContinents()
        for _, c in pairs(contintents) do
            local new_cont = {
                ["name"] = c.name[MTSLUI_CURRENT_LANGUAGE],
                ["sub_values"] = {},
            }
            local zones_in_cont = MTSL_LOGIC_WORLD:GetZonesInContinentById(c.id)
            for _, z in pairs(zones_in_cont) do
                local new_zone = {
                    ["name"] = z.name[MTSLUI_CURRENT_LANGUAGE],
                    ["id"] = z.id,
                }
                table.insert(new_cont["sub_values"], new_zone)
            end
            table.insert(self.cont_zones, new_cont)
        end
    end,

    ----------------------------------------------------------------------------------------------------------
    -- Intialises drop down for sorting
    ----------------------------------------------------------------------------------------------------------
    CreateDropDownSorting = function(self, level)
        MTSLUI_TOOLS:FillDropDown(level, MTSLDBUI_SKILL_LIST_SORT_FRAME.sorts, MTSLDBUI_SKILL_LIST_SORT_FRAME.ChangeSortHandler)
    end,

    ----------------------------------------------------------------------------------------------------------
    -- Intialises drop down for phases
    ----------------------------------------------------------------------------------------------------------
    CreateDropDownPhases = function(self, level)
        MTSLUI_TOOLS:FillDropDown(level, MTSLDBUI_SKILL_LIST_SORT_FRAME.phases, MTSLDBUI_SKILL_LIST_SORT_FRAME.ChangePhaseHandler)
    end,

    ----------------------------------------------------------------------------------------------------------
    -- Intialises drop down for continents/zones
    ----------------------------------------------------------------------------------------------------------
    CreateDropDownContinentsAndZones = function(self, level)
        -- update the current zone
        MTSLDBUI_SKILL_LIST_SORT_FRAME:LoadContinentsAndZones()
        MTSLUI_TOOLS:FillDropDown(level, MTSLDBUI_SKILL_LIST_SORT_FRAME.cont_zones, MTSLDBUI_SKILL_LIST_SORT_FRAME.ChangeContinentZoneHandler)
    end,

    --------------------------------------------------------------------------------------
    -- Handles DropDown Change event after changing the sorting
    ----------------------------------------------------------------------------------------------------------
    ChangeSortHandler = function(value, text)
        if value ~= nil then
            MTSLDBUI_SKILL_LIST_SORT_FRAME:ChangeSorting(value, text)
        end
    end,

    ChangeSorting = function(self, value, text)
        self.current_sort = value
        UIDropDownMenu_SetText(self.ui_frame.sort_drop_down, text)
        -- Sort the list if we may
        MTSLDBUI_SKILL_LIST_FRAME:SortSkills(value)
    end,

    ----------------------------------------------------------------------------------------------------------
    -- Handles DropDown Change event after changing the continent & zone
    ----------------------------------------------------------------------------------------------------------
    ChangeContinentZoneHandler = function(value, text)
        if value ~= nil and value ~= MTSLDBUI_SKILL_LIST_SORT_FRAME.current_cont_zone then
            MTSLDBUI_SKILL_LIST_SORT_FRAME:ChangeContinentZone(value, text)
        end
    end,

    ChangeContinentZone = function(self, id, text)
        self.current_cont_zone = id
        UIDropDownMenu_SetText(self.ui_frame.cont_zone_drop_down, text)
        -- Sort the list if we may
        MTSLDBUI_SKILL_LIST_FRAME:ChangeZone(id)
    end,

    ----------------------------------------------------------------------------------------------------------
    -- Handles DropDown Change event after changing the phases
    ----------------------------------------------------------------------------------------------------------
    ChangePhaseHandler = function(value, text)
        if value ~= nil and value ~= MTSLDBUI_SKILL_LIST_SORT_FRAME.current_phase then
            MTSLDBUI_SKILL_LIST_SORT_FRAME:ChangePhase(value, text)
        end
    end,

    ChangePhase = function(self, id, text)
        self.current_phase = id
        UIDropDownMenu_SetText(self.ui_frame.phase_drop_down, text)
        -- change filter to new phase
        local phase = MTSL_CURRENT_PHASE
        if id > 1 then
            phase = MTSL_MAX_PHASE
        end
        -- Update the list and filter out the wrong phase itemsz
        MTSLDBUI_SKILL_LIST_FRAME:ChangePhase(phase)
    end,
}