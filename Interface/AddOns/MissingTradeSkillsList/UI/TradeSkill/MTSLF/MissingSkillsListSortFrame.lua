----------------------------------------------------------
-- Name: SkillListFrame									--
-- Description: Shows all the skills for one profession --
-- Parent Frame: DatabaseFrame							--
----------------------------------------------------------

MTSLUI_MTSLF_MISSING_SKILLS_LIST_SORT_FRAME = {
    -- Keeps the current created frame
    ui_frame,
    -- width of the frame
    FRAME_WIDTH_VERTICAL = 345,
    FRAME_WIDTH_HORIZONTAL = 512,
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
    continents = {},
    zones_in_continent = {},
    current_available_zones = {},
    current_contintent_id,
    current_zone_id,
    -- widhts of the drops downs according to layout
    VERTICAL_WIDTH_DD = 152,
    HORIZONTAL_WIDTH_DD = 235,
    ----------------------------------------------------------------------------------------------------------
    -- Intialises the MissingSkillsListFrame
    --
    -- @parent_frame		Frame		The parent frame
    ----------------------------------------------------------------------------------------------------------
    Initialise = function(self, parent_frame)
        -- create the container frame
        self.ui_frame = MTSLUI_TOOLS:CreateBaseFrame("Frame", "", parent_frame, nil, self.FRAME_WIDTH_VERTICAL, self.FRAME_HEIGHT, false)
        -- position under TitleFrame and right of ProfessionListFrame
        self.ui_frame:SetPoint("TOPLEFT", parent_frame, "BOTTOMLEFT", 0, 0)
        self:BuildContinentsAndZones()
        -- Continent more split up with types as well, to reduce number of items shown
        self.ui_frame.continent_drop_down = CreateFrame("Frame", "MTSLDBUI_SKILL_LIST_SORT_FRAME_DD_CONTINENTS", self.ui_frame, "UIDropDownMenuTemplate")
        self.ui_frame.continent_drop_down:SetPoint("TOPLEFT", self.ui_frame, "TOPLEFT", -15, 0)
        self.ui_frame.continent_drop_down.initialize = self.CreateDropDownContinents
        UIDropDownMenu_SetWidth(self.ui_frame.continent_drop_down, 150)
        UIDropDownMenu_SetText(self.ui_frame.continent_drop_down, MTSLUI_LOCALES_LABELS["any"][MTSLUI_CURRENT_LANGUAGE])

        -- default contintent "any" so no need for sub zone to show
        self.ui_frame.zone_drop_down = CreateFrame("Frame", "MTSLDBUI_SKILL_LIST_SORT_FRAME_DD_ZONES", self.ui_frame, "UIDropDownMenuTemplate")
        self.ui_frame.zone_drop_down:SetPoint("TOPLEFT", self.ui_frame.continent_drop_down, "TOPRIGHT", -30, 0)
        self.ui_frame.zone_drop_down.initialize = self.CreateDropDownZones
        UIDropDownMenu_SetWidth(self.ui_frame.zone_drop_down, 150)
        UIDropDownMenu_SetText(self.ui_frame.zone_drop_down, "")
    end,

    BuildContinentsAndZones = function(self)
        self:BuildContinents()
        self:BuildZones()
    end,

    BuildContinents = function(self)
        -- build the arrays with contintents and zones
        self.continents = {
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
                -- make id negative for filter later on
                ["id"] = (-1 * current_zone.id),
            }
            table.insert(self.continents, zone_filter)
        end
        -- add each type of "continent
        for k, v in pairs(MTSL_DATA["continents"]) do
            local new_continent = {
                ["name"] = v["name"][MTSLUI_CURRENT_LANGUAGE],
                ["id"] = v.id,
            }
            table.insert(self.continents, new_continent)
        end
        -- auto select "any" as continent
        if self.current_contintent_id == nil  then
            self.current_contintent_id = 0
        end
    end,

    BuildZones = function(self)
        -- build the arrays with contintents and zones
        self.zones_in_continent = {}

        -- add each zone of current "continent unless its "Any" or "Current location"
        for k, c in pairs(MTSL_DATA["continents"]) do
            self.zones_in_continent[c.id] = {}
            for l, z in pairs(MTSL_LOGIC_WORLD:GetZonesInContinentById(c.id)) do
                local new_zone = {
                    ["name"] = z["name"][MTSLUI_CURRENT_LANGUAGE],
                    ["id"] = z.id,
                }
                table.insert(self.zones_in_continent[c.id], new_zone)
            end
            -- sort alfabethical
            table.sort(self.zones_in_continent[c.id], function(a, b) return a.name < b.name end)
        end
    end,

    ----------------------------------------------------------------------------------------------------------
    -- Intialises drop down for continents/zones
    ----------------------------------------------------------------------------------------------------------
    CreateDropDownContinents = function(self, level)
        MTSLUI_TOOLS:FillDropDown(level, MTSLUI_MTSLF_MISSING_SKILLS_LIST_SORT_FRAME.continents, MTSLUI_MTSLF_MISSING_SKILLS_LIST_SORT_FRAME.ChangeContinentHandler)
    end,

    ----------------------------------------------------------------------------------------------------------
    -- Handles DropDown Change event after changing the continent
    ----------------------------------------------------------------------------------------------------------
    ChangeContinentHandler = function(value, text)
        if value ~= nil and value ~= MTSLUI_MTSLF_MISSING_SKILLS_LIST_SORT_FRAME.current_contintent_id then
            MTSLUI_MTSLF_MISSING_SKILLS_LIST_SORT_FRAME:ChangeContinent(value, text)
        end
    end,

    ChangeContinent = function(self, id, text)
        -- do not set continent id if id < 0
        if id >= 0 then
            self.current_contintent_id = id
        -- selected current zone so trigger changezone
        else
            self.current_contintent_id = nil
            -- revert negative id to positive
            self.current_zone_id = math.abs(id)
            MTSLUI_MTSLF_MISSING_SKILLS_LIST_FRAME:ChangeZone(self.current_zone_id)
        end
        UIDropDownMenu_SetText(self.ui_frame.continent_drop_down, text)

        -- Update the drop down with available zones for this continent
        self.current_available_zones = self.zones_in_continent[id]
        if self.current_available_zones == nil then
            self.current_available_zones = {}
        end
        self:CreateDropDownZones(1)
        -- auto select first zone in the continent if possible
        if id > 0 then
            local key, zone = next(self.current_available_zones)
            UIDropDownMenu_SetText(self.ui_frame.zone_drop_down, zone.name)
            MTSLUI_MTSLF_MISSING_SKILLS_LIST_FRAME:ChangeZone(zone.id)
        else
            UIDropDownMenu_SetText(self.ui_frame.zone_drop_down, "")
        end
    end,

    ----------------------------------------------------------------------------------------------------------
    -- Intialises drop down for zones
    ----------------------------------------------------------------------------------------------------------
    CreateDropDownZones = function(self, level)
        MTSLUI_TOOLS:FillDropDown(level, MTSLUI_MTSLF_MISSING_SKILLS_LIST_SORT_FRAME.current_available_zones, MTSLUI_MTSLF_MISSING_SKILLS_LIST_SORT_FRAME.ChangeZoneHandler)
    end,

    ----------------------------------------------------------------------------------------------------------
    -- Handles DropDown Change event after changing the zone
    ----------------------------------------------------------------------------------------------------------
    ChangeZoneHandler = function(value, text)
        if value ~= nil and value ~= MTSLUI_MTSLF_MISSING_SKILLS_LIST_SORT_FRAME.current_zone_id then
            MTSLUI_MTSLF_MISSING_SKILLS_LIST_SORT_FRAME:ChangeZone(value, text)
        end
    end,

    ChangeZone = function(self, id, text)
        self.current_zone_id = id
        UIDropDownMenu_SetText(self.ui_frame.zone_drop_down, text)
        -- Sort the list if we may
        MTSLUI_MTSLF_MISSING_SKILLS_LIST_FRAME:ChangeZone(id)
    end,

    -- Switch to vertical split layout
    ResizeToVerticalMode = function(self)
        self.ui_frame:SetWidth(self.FRAME_WIDTH_VERTICAL)
        UIDropDownMenu_SetWidth(self.ui_frame.continent_drop_down, self.VERTICAL_WIDTH_DD)
        UIDropDownMenu_SetWidth(self.ui_frame.zone_drop_down, self.VERTICAL_WIDTH_DD)
    end,

    -- Switch to horizontal split layout
    ResizeToHorizontalMode = function(self)
        self.ui_frame:SetWidth(self.FRAME_WIDTH_HORIZONTAL)
        UIDropDownMenu_SetWidth(self.ui_frame.continent_drop_down, self.HORIZONTAL_WIDTH_DD)
        UIDropDownMenu_SetWidth(self.ui_frame.zone_drop_down, self.HORIZONTAL_WIDTH_DD)
    end,
}