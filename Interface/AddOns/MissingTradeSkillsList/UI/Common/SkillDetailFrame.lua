-------------------------------------------------------
-- Name: SkillDetailFrame							 --
-- Description: Shows the detail of a selected skill --
-- Parent Frame: MissingTradeSkillsListFrame		 --
-------------------------------------------------------

MTSLUI_SKILL_DETAIL_FRAME = {
    ui_frame,
    -- array holding all labels shown on this panel, for easy acces later
    labels = {
        name = {},
        min_skill = {},
        requires_xp = {},
        requires_rep = {},
        requires_spec = {},
        holiday = {},
        special_action = {},
        price = {},
        type = {},
        source = {},
        sources = {},
        alt_type ={},
        alt_source = {},
        alt_sources = {},
    },
    sources = {
        main = {
            npcs = {},
            objects = {},
            items = {},
        },
        alt = {
            npcs = {},
            objects = {},
            items = {},
        },
    },
    -- width of the frame
    FRAME_WIDTH = 515,
    -- height of the frame
    FRAME_HEIGHT = 440,
    -- height of the primary sources frame
    FRAME_SOURCES_HEIGHT = 305,
    -- shows up to 17 sources
    MAX_SOURCES_SHOWN_PRIMARY = 17,
    -- height of the frame with alternative source
    FRAME_ALT_SOURCES_HEIGHT = 135,
    -- shows up to 7 alternative sources
    MAX_SOURCES_SHOWN_SECONDARY = 7,
    -- save the texts for the tooltips
    tooltip_skill_name,
    tooltip_source_name,
    tooltip_alt_source_,name,

    ----------------------------------------------------------------------------------------------------------
    -- Intialises the DetailsSelectedSkillFrame
    --
    -- @parent_frame		Frame		The parent frame
    ----------------------------------------------------------------------------------------------------------
    Initialise = function (self, parent_frame, frame_name)
        -- make local copy of this instance to hook the events too
        local event_class = self
        -- create the frame
        self.ui_frame = MTSLUI_TOOLS:CreateBaseFrame("Frame", frame_name, parent_frame, nil, self.FRAME_WIDTH, self.FRAME_HEIGHT, true)
        --  Black background
        self.ui_frame:SetBackdropColor(0,0,0,1)
        -- Add the Texts/Strings to the frame
        local text_label_left = 10
        local text_label_right = 130
        local text_label_top = -8
        local text_gap = 16
        -- Labels to show "name: <name>"
        self.labels.name.title = MTSLUI_TOOLS:CreateLabel(self.ui_frame, MTSLUI_LOCALES_LABELS["name"][MTSLUI_CURRENT_LANGUAGE], text_label_left, text_label_top, "LABEL", "TOPLEFT")
        self.labels.name.value = MTSLUI_TOOLS:CreateLabel(self.ui_frame, "-", text_label_right, text_label_top, "TEXT", "TOPLEFT")
        -- create a frame to hover over and show the tooltip
        self.labels.name.tooltip_frame = MTSLUI_TOOLS:CreateBaseFrame("Frame", "", self.ui_frame, nil, 300, text_gap + 5, false)
        self.labels.name.tooltip_frame:SetPoint("TOPLEFT", self.ui_frame, "TOPLEFT", text_label_right - 5, -2)
        self.labels.name.tooltip_frame:SetScript("OnEnter", function() event_class:ToolTipShowSkillName() end)
        self.labels.name.tooltip_frame:SetScript("OnLeave", function() _G.GameTooltip:Hide() end)
        text_label_top = text_label_top - text_gap
        -- Labels to show "Required skill: <min skill>"
        self.labels.min_skill.title = MTSLUI_TOOLS:CreateLabel(self.ui_frame, MTSLUI_LOCALES_LABELS["needs skill level"][MTSLUI_CURRENT_LANGUAGE], text_label_left, text_label_top, "LABEL", "TOPLEFT")
        self.labels.min_skill.value = MTSLUI_TOOLS:CreateLabel(self.ui_frame, "-", text_label_right, text_label_top, "TEXT", "TOPLEFT")
        text_label_top = text_label_top - text_gap
        -- Labels to show "Required XP level: <xp level>"
        self.labels.requires_xp.title = MTSLUI_TOOLS:CreateLabel(self.ui_frame, MTSLUI_LOCALES_LABELS["needs XP level"][MTSLUI_CURRENT_LANGUAGE], text_label_left, text_label_top, "LABEL", "TOPLEFT")
        self.labels.requires_xp.value = MTSLUI_TOOLS:CreateLabel(self.ui_frame, "-", text_label_right, text_label_top, "TEXT", "TOPLEFT")
        text_label_top = text_label_top - text_gap
        -- Labels to show "Required reputation: <reputation>"
        self.labels.requires_rep.title = MTSLUI_TOOLS:CreateLabel(self.ui_frame, MTSLUI_LOCALES_LABELS["needs reputation"][MTSLUI_CURRENT_LANGUAGE], text_label_left, text_label_top, "LABEL", "TOPLEFT")
        self.labels.requires_rep.value = MTSLUI_TOOLS:CreateLabel(self.ui_frame, "-", text_label_right, text_label_top, "TEXT", "TOPLEFT")
        text_label_top = text_label_top - text_gap
        -- Labels to show "Required reputation: <reputation>"
        self.labels.requires_spec.title = MTSLUI_TOOLS:CreateLabel(self.ui_frame, MTSLUI_LOCALES_LABELS["needs specialization"][MTSLUI_CURRENT_LANGUAGE], text_label_left, text_label_top, "LABEL", "TOPLEFT")
        self.labels.requires_spec.value = MTSLUI_TOOLS:CreateLabel(self.ui_frame, "-", text_label_right, text_label_top, "TEXT", "TOPLEFT")
        text_label_top = text_label_top - text_gap
        -- Labels to show "Holiday <holiday>"
        self.labels.holiday.title = MTSLUI_TOOLS:CreateLabel(self.ui_frame, MTSLUI_LOCALES_LABELS["holiday"][MTSLUI_CURRENT_LANGUAGE], text_label_left, text_label_top, "LABEL", "TOPLEFT")
        self.labels.holiday.value = MTSLUI_TOOLS:CreateLabel(self.ui_frame, "-", text_label_right, text_label_top, "TEXT", "TOPLEFT")
        text_label_top = text_label_top - text_gap
        -- Labels to show "Special action <special action>"
        self.labels.special_action.title = MTSLUI_TOOLS:CreateLabel(self.ui_frame, MTSLUI_LOCALES_LABELS["special action"][MTSLUI_CURRENT_LANGUAGE], text_label_left, text_label_top, "LABEL", "TOPLEFT")
        self.labels.special_action.value = MTSLUI_TOOLS:CreateLabel(self.ui_frame, "-", text_label_right, text_label_top, "TEXT", "TOPLEFT")
        text_label_top = text_label_top - text_gap
        -- Labels to show "Price: <price>"
        self.labels.price.title = MTSLUI_TOOLS:CreateLabel(self.ui_frame, MTSLUI_LOCALES_LABELS["price"][MTSLUI_CURRENT_LANGUAGE], text_label_left, text_label_top, "LABEL", "TOPLEFT")
        self.labels.price.value = MTSLUI_TOOLS:CreateLabel(self.ui_frame, "-", text_label_right, text_label_top, "TEXT", "TOPLEFT")
        text_label_top = text_label_top - text_gap
        -- Labels to show "Learned from: <type>"
        self.labels.type.title = MTSLUI_TOOLS:CreateLabel(self.ui_frame, MTSLUI_LOCALES_LABELS["learned from"][MTSLUI_CURRENT_LANGUAGE], text_label_left, text_label_top, "LABEL", "TOPLEFT")
        self.labels.type.value = MTSLUI_TOOLS:CreateLabel(self.ui_frame, "-", text_label_right, text_label_top, "TEXT", "TOPLEFT")
        -- create a frame to hover over and show the tooltip
        self.labels.type.tooltip_frame = MTSLUI_TOOLS:CreateBaseFrame("Frame", "", self.ui_frame, nil, 300, text_gap + 5, false)
        self.labels.type.tooltip_frame_point_x = text_label_right - 5
        self.labels.type.tooltip_frame_point_y = text_label_top + 5
        self.labels.type.tooltip_frame:SetPoint("TOPLEFT", self.ui_frame, "TOPLEFT", self.labels.type.tooltip_frame_point_x, self.labels.type.tooltip_frame_point_y)
        self.labels.type.tooltip_frame:SetScript("OnEnter", function() event_class:ToolTipShowSourceName() end)
        self.labels.type.tooltip_frame:SetScript("OnLeave", function() _G.GameTooltip:Hide() end)
        text_label_top = text_label_top - text_gap
        self.labels.source.title = MTSLUI_TOOLS:CreateLabel(self.ui_frame, MTSLUI_LOCALES_LABELS["obtained from"][MTSLUI_CURRENT_LANGUAGE], text_label_left, text_label_top, "LABEL", "TOPLEFT")
        self.labels.source.value = MTSLUI_TOOLS:CreateLabel(self.ui_frame, "-", text_label_right, text_label_top, "TEXT", "TOPLEFT")
        text_label_top = text_label_top - text_gap
        -- Labels to show "Trained by: <trainers> or Sold by: <vendors> or Dropped by: <mobs> or Obtained from: <quest>"
        self.labels.sources.title = MTSLUI_TOOLS:CreateLabel(self.ui_frame, MTSLUI_LOCALES_LABELS["learned from"][MTSLUI_CURRENT_LANGUAGE], text_label_left, text_label_top, "LABEL", "TOPLEFT")
        self.labels.sources.title:Hide()
        -- Create a frame to hold the labels
        self.labels.sources.ui_frame = MTSLUI_TOOLS:CreateBaseFrame("Frame", "", self.ui_frame, nil, self.FRAME_WIDTH - 107, self.FRAME_SOURCES_HEIGHT, false)
        -- position under MissingSkillsListui_frameand above ProgressBar
        self.labels.sources.ui_frame:SetPoint("TOPLEFT", self.ui_frame, "TOPLEFT", text_label_right - 10, text_label_top + 8)
        -- we have MAX_SOURCES_SHOWN we can show at same time
        self.labels.sources.values = {}
        text_label_top = -8
        text_label_right = 10
        -- Create the labels for sources
        for i=1,self.MAX_SOURCES_SHOWN_PRIMARY do
            local string_sources_content = MTSLUI_TOOLS:CreateLabel(self.labels.sources.ui_frame, i, text_label_right, text_label_top, "TEXT", "TOPLEFT")
            text_label_top = text_label_top - text_gap
            table.insert(self.labels.sources.values, string_sources_content)
        end
        -- add on click for tom tom integration
        self.labels.sources.ui_frame:SetScript("OnMouseUp", function() event_class:AddTomTomWayPointPrimarySource() end)
        -- hide on creation
        self.labels.sources.ui_frame:Show()
        text_label_right = 130
        text_label_top = text_label_top + 2
        self.labels.alt_type.title = MTSLUI_TOOLS:CreateLabel(self.ui_frame, MTSLUI_LOCALES_LABELS["also learned from"][MTSLUI_CURRENT_LANGUAGE], text_label_left, text_label_top, "LABEL", "TOPLEFT")
        self.labels.alt_type.value = MTSLUI_TOOLS:CreateLabel(self.ui_frame, "-", text_label_right, text_label_top, "TEXT", "TOPLEFT")
        -- create a frame to hover over and show the tooltip
        self.labels.alt_type.tooltip_frame = MTSLUI_TOOLS:CreateBaseFrame("Frame", "", self.ui_frame, nil, 300, text_gap + 5, false)
        self.labels.alt_type.tooltip_frame_point_x = text_label_right - 5
        self.labels.alt_type.tooltip_frame_point_y = text_label_top + 5
        self.labels.alt_type.tooltip_frame:SetPoint("TOPLEFT", self.ui_frame, "TOPLEFT", self.labels.alt_type.tooltip_frame_point_x, self.labels.alt_type.tooltip_frame_point_y)
        self.labels.alt_type.tooltip_frame:SetScript("OnEnter", function() event_class:ToolTipShowAltSourceName() end)
        self.labels.alt_type.tooltip_frame:SetScript("OnLeave", function() _G.GameTooltip:Hide() end)
        text_label_top = text_label_top - text_gap
        self.labels.alt_source.title = MTSLUI_TOOLS:CreateLabel(self.ui_frame, MTSLUI_LOCALES_LABELS["obtained from"][MTSLUI_CURRENT_LANGUAGE], text_label_left, text_label_top, "LABEL", "TOPLEFT")
        self.labels.alt_source.value = MTSLUI_TOOLS:CreateLabel(self.ui_frame, "-", text_label_right, text_label_top, "TEXT", "TOPLEFT")
        text_label_top = text_label_top - text_gap
        -- Labels to show "Trained by: <trainers> or Sold by: <vendors> or Dropped by: <mobs> or Obtained from: <quest>"
        self.labels.alt_sources.title = MTSLUI_TOOLS:CreateLabel(self.ui_frame, MTSLUI_LOCALES_LABELS["also learned from"][MTSLUI_CURRENT_LANGUAGE], text_label_left, text_label_top, "LABEL", "TOPLEFT")
        -- Create a frame to show the alternative sources
        self.labels.alt_sources.ui_frame = MTSLUI_TOOLS:CreateBaseFrame("Frame", "", self.ui_frame, nil, self.FRAME_WIDTH - 118, self.FRAME_ALT_SOURCES_HEIGHT, false)
        -- position halfway from the frame with primary sources
        self.labels.alt_sources.ui_frame:SetPoint("BOTTOMRIGHT", self.ui_frame, "BOTTOMRIGHT", -2, -2)
        -- hide on creation
        self.labels.alt_sources.ui_frame:Show()
        self.labels.alt_sources.values = {}
        text_label_top = -5
        text_label_right = 15
        -- Create the labels for sources
        for i=1,self.MAX_SOURCES_SHOWN_SECONDARY do
            local string_sources_content = MTSLUI_TOOLS:CreateLabel(self.labels.alt_sources.ui_frame, i .. " alt", text_label_right, text_label_top, "TEXT", "TOPLEFT")
            text_label_top = text_label_top - text_gap
            table.insert(self.labels.alt_sources.values, string_sources_content)
        end
        -- add on click for tom tom integration
        self.labels.alt_sources.ui_frame:SetScript("OnMouseUp", function() event_class:AddTomTomWayPointSecondarySource() end)
    end,

    -- Tries to add a way point to the map for the clicked NPC
    AddTomTomWayPointPrimarySource = function(self)
        -- Calculate the clicked Y coordinate based on the used scale
        local x, y = GetCursorPosition()
        local s = self.labels.sources.ui_frame:GetEffectiveScale()
        x, y = x/s, y/s;
        local top = self.labels.sources.ui_frame:GetTop()
        -- calculate how many labels we passed from top coordinate
        local text_gap = 16
        local label_number = 0
        while top > y and label_number < self.MAX_SOURCES_SHOWN_PRIMARY do
            top = top - text_gap
            label_number = label_number + 1
        end
        -- Check if the label is visable
        if label_number <= self.MAX_SOURCES_SHOWN_PRIMARY and self.labels.sources.values[label_number]:IsVisible() then
            MTSLUI_TOOLS:CreateWayPoint(self.labels.sources.values[label_number]:GetText(), self.labels.name.value:GetText())
        end
    end,

    -- Tries to add a way point to the map for the clicked NPC of an alternative source
    AddTomTomWayPointSecondarySource = function(self)
        -- Calculate the clicked Y coordinate based on the used scale
        local x, y = GetCursorPosition()
        local s = self.labels.alt_sources.ui_frame:GetEffectiveScale()
        x, y = x/s, y/s;
        local top = self.labels.alt_sources.ui_frame:GetTop()
        -- calculate how many labels we passed from top coordinate
        local text_gap = 16
        local label_number = 0
        while top > y and label_number < self.MAX_SOURCES_SHOWN_SECONDARY do
            top = top - text_gap
            label_number = label_number + 1
        end
        -- Check if the label is visable
        if label_number <= self.MAX_SOURCES_SHOWN_SECONDARY and self.labels.alt_sources.values[label_number]:IsVisible() then
            MTSLUI_TOOLS:CreateWayPoint(self.labels.alt_sources.values[label_number]:GetText(), self.labels.name.value:GetText())
        end
    end,

    -- Show the tooltip for the skill/item on top of the detail skill frame
    ToolTipShow = function(self, parent_frame, text)
        if text ~= nil then
            local GameTooltip = _G.GameTooltip
            GameTooltip:SetOwner(parent_frame, "ANCHOR_CURSOR")
            GameTooltip:ClearLines()
            GameTooltip:SetHyperlink(text)
            GameTooltip:Show()
        end
    end,

    ToolTipShowSkillName = function(self)
        self:ToolTipShow(self.labels.name.tooltip_frame, self.tooltip_skill_name)
    end,

    ToolTipShowSourceName = function(self)
        self:ToolTipShow(self.labels.name.tooltip_frame, self.tooltip_source_name)
    end,


    ToolTipShowAltSourceName = function(self)
        self:ToolTipShow(self.labels.name.tooltip_frame, self.tooltip_alt_source_name)
    end,

    HideTooltipFrameShowSourceName = function(self)
        self.tooltip_source_name = nil
        self.labels.type.tooltip_frame:SetPoint("TOPLEFT", self.ui_frame, "TOPLEFT", self.labels.type.tooltip_frame_point_x, self.labels.type.tooltip_frame_point_y)
    end,

    HideTooltipFrameShowAltSourceName = function(self)
        self.tooltip_alt_source_name = nil
        self.labels.alt_type.tooltip_frame:SetPoint("TOPLEFT", self.ui_frame, "TOPLEFT", self.labels.alt_type.tooltip_frame_point_x, self.labels.alt_type.tooltip_frame_point_y)
    end,

    ---------------------------------------------------------------------------
    -- Show the frame when no skill is selected so empty labels
    ---------------------------------------------------------------------------
    ShowNoSkillSelected = function(self)
        self.labels.name.value:SetText("-")
        self.labels.min_skill.value:SetText("-")
        self.labels.requires_xp.value:SetText("-")
        self.labels.requires_rep.value:SetText("-")
        self.labels.holiday.value:SetText("-")
        self.labels.special_action.value:SetText("-")
        self.labels.price.value:SetText("-")
        self.labels.type.value:SetText("-")
        self.labels.source.value:SetText("-")
        self.labels.sources.title:SetText(MTSLUI_FONTS.COLORS.TEXT.TITLE .. MTSLUI_LOCALES_LABELS["learned from"][MTSLUI_CURRENT_LANGUAGE])
        self.labels.sources.title:Hide()
        self.labels.sources.ui_frame:Hide()
        self.labels.alt_type.title:SetText(MTSLUI_FONTS.COLORS.TEXT.TITLE .. MTSLUI_LOCALES_LABELS["also learned from"][MTSLUI_CURRENT_LANGUAGE])
        self.labels.alt_type.title:Hide()
        self.labels.alt_type.value:SetText("-")
        self.labels.alt_type.value:Hide()
        self.labels.alt_source.title:Hide()
        self.labels.alt_source.value:SetText("-")
        self.labels.alt_source.value:Hide()
        self.labels.alt_sources.title:SetText(MTSLUI_FONTS.COLORS.TEXT.TITLE .. MTSLUI_LOCALES_LABELS["learned from"][MTSLUI_CURRENT_LANGUAGE])
        self.labels.alt_sources.title:Hide()
        self.labels.alt_sources.ui_frame:Hide()
        -- hide the tooltips
        self:HideTooltipFrameShowSourceName()
        self:HideTooltipFrameShowAltSourceName()
    end,

    ---------------------------------------------------------------------------
    -- Show the details of a skill (based on its type)
    --
    -- @skill		MTSL_DATA	The skill of which the information must be shown
    ---------------------------------------------------------------------------
    ShowDetailsOfSkill = function(self, skill, profession_name, current_xp_level, current_skill_level)
        self:ShowNoSkillSelected()
        if skill ~= nil then
            -- Generic labelsetting for every type
            self.labels.name.value:SetText(MTSLUI_FONTS.COLORS.TEXT.NORMAL .. skill["name"][MTSLUI_CURRENT_LANGUAGE])
            self:SetRequiredSkillLevel(skill.min_skill, current_skill_level)
            -- Set minimum xp level
            self:SetRequiredXPLevel(skill.min_xp_level, current_xp_level)
            self:SetRequiredReputationWithFaction(skill.reputation)
            self:SetRequiredSpecialization(profession_name, skill.specialization)
            self:SetRequiredSpecialAction(skill.special_action)
            -- clear the price
            self.labels.price.value:SetText(MTSLUI_FONTS.COLORS.TEXT.NORMAL .. "-")

            -- Default show only primary source
            self.labels.sources.title:Show()
            self.labels.sources.ui_frame:Show()

            if skill.item ~= nil then
                self:ShowDetailsOfSkillTypeItem(skill.item, profession_name, current_xp_level, 0, 0)
            elseif skill.trainers ~= nil then
                self:ShowDetailsOfSkillTypeTrainer(skill.trainers)
            elseif skill.quests ~= nil then
                self:ShowDetailsOfSkillTypeQuest(skill.quests, profession_name, current_xp_level, 0, 0)
            elseif skill.object ~= nil then
                self:ShowDetailsOfSkillTypeObject(skill.object, 0, 0)
            -- no sources (special action only)
            else
                self.labels.type.value:SetText(MTSLUI_FONTS.COLORS.TEXT.NORMAL .. MTSLUI_LOCALES_LABELS["special action"][MTSLUI_CURRENT_LANGUAGE])
                self.labels.source.title:Hide()
                self.labels.source.value:Hide()
                self.labels.sources.title:Hide()
                self.labels.sources.ui_frame:Hide()
            end
            self.ui_frame:Show()
            -- Update the text for the tooltips
            self.tooltip_skill_name = "spell:"..skill.id
            -- TODO UPDATE: Update the Character Screen
            -- MTSLDBUI_CHARS_SELECTED_SKILL_FRAME:RefreshUI(profession_name, skill.id)
        end
    end,

    ----------------------------------------------------------------------------
    -- Show the details of a minimum skill level required
    --
    -- @min_skill	            Number	    The minimum skill level required to learn the skill
    -- @current_skill_level     Number      The current skill level of the player
    ----------------------------------------------------------------------------
    SetRequiredSkillLevel = function(self, min_skill, current_skill_level)
        if min_skill == nil or min_skill <= 0  then
            self.labels.min_skill.value:SetText(MTSLUI_FONTS.COLORS.TEXT.NORMAL .. "-")
        elseif current_skill_level == nil or current_skill_level <= 0 then
            self.labels.min_skill.value:SetText(MTSLUI_FONTS.COLORS.AVAILABLE.ALL .. min_skill)
        elseif min_skill <= current_skill_level then
            self.labels.min_skill.value:SetText(MTSLUI_FONTS.COLORS.AVAILABLE.YES .. min_skill)
        else
            self.labels.min_skill.value:SetText(MTSLUI_FONTS.COLORS.AVAILABLE.NO .. min_skill)
        end
    end,

    ----------------------------------------------------------------------------
    -- Show the details of a minimum XP level required
    --
    -- @min_xp_level	    Number	    The minimum XP level required to learn the skill
    -- @current_xp_level    Number      The current XP level of the player
    ----------------------------------------------------------------------------
    SetRequiredXPLevel = function (self, min_xp_level, current_xp_level)
        -- Check if we need certain XP level to learn
        if min_xp_level == nil or min_xp_level <= 0 then
            self.labels.requires_xp.value:SetText(MTSLUI_FONTS.COLORS.TEXT.NORMAL .. "-")
        elseif current_xp_level == nil or current_xp_level <= 0 then
            self.labels.requires_xp.value:SetText(MTSLUI_FONTS.COLORS.AVAILABLE.ALL .. min_xp_level)
        elseif min_xp_level <= current_xp_level then
            self.labels.requires_xp.value:SetText(MTSLUI_FONTS.COLORS.AVAILABLE.YES .. min_xp_level)
        else
            self.labels.requires_xp.value:SetText(MTSLUI_FONTS.COLORS.AVAILABLE.NO .. min_xp_level)
        end
    end,

    ----------------------------------------------------------------------------
    -- Show the details of a minimum reputation level required with a faction
    --
    -- @reputation	object	Contains reputation.faction & reputation.level
    ----------------------------------------------------------------------------
    SetRequiredReputationWithFaction = function(self, reputation)
        -- Check if require reputation to acquire
        if reputation ~= nil then
            local faction = MTSL_LOGIC_FACTION_REPUTATION:GetFactionNameById(reputation.faction_id)
            local level = MTSL_LOGIC_FACTION_REPUTATION:GetReputationLevelById(reputation.level_id)
        -- TODO COMPARE CURRENT PLAYER HIS FACTION
            self.labels.requires_rep.value:SetText(MTSLUI_FONTS.COLORS.TEXT.NORMAL .. faction .. " [" .. level .. "]")
        else
            self.labels.requires_rep.value:SetText(MTSLUI_FONTS.COLORS.TEXT.NORMAL .. "-")
        end
    end,

    ----------------------------------------------------------------------------
    -- Show the details of a specialization required for the skill
    --
    -- @profession_name         String      The name of the profession
    -- @rspecialisation 	    Number      The number of the specialisation
    ----------------------------------------------------------------------------
    SetRequiredSpecialization = function(self, profession_name, specialization)
        -- Check if require specialization to acquire
        if specialization ~= nil and specialization > 0 then
            local name_spec = MTSL_LOGIC_PROFESSION:GetNameSpecialization(profession_name, specialization)
            -- global database so show neutral color
            if self.current_xp_level == nil or self.current_xp_level <= 0 then
                self.labels.requires_spec.value:SetText(MTSLUI_FONTS.COLORS.AVAILABLE.ALL .. name_spec)
            -- check if player knows the specialisation by using its spellid
            elseif IsSpellKnown(specialization) then
                self.labels.requires_spec.value:SetText(MTSLUI_FONTS.COLORS.AVAILABLE.YES .. name_spec)
            else
                self.labels.requires_spec.value:SetText(MTSLUI_FONTS.COLORS.AVAILABLE.NO .. name_spec)
            end
        else
            self.labels.requires_spec.value:SetText(MTSLUI_FONTS.COLORS.TEXT.NORMAL .. "-")
        end
    end,

    ----------------------------------------------------------------------------
    -- Show the details of a holiday event required for the skill
    --
    -- @holiday         Number      The id of the holiday
    ----------------------------------------------------------------------------
    SetRequiresHoliday = function(self, holiday_id)
        local holiday = MTSL_TOOLS:GetItemFromArrayByKeyValue(MTSL_DATA["holidays"], "id", holiday_id)
        -- if holiday is required
        if holiday ~= nil then
            self.labels.holiday.value:SetText(MTSLUI_FONTS.COLORS.TEXT.NORMAL .. holiday["name"][MTSLUI_CURRENT_LANGUAGE])
        else
            self.labels.holiday.value:SetText(MTSLUI_FONTS.COLORS.TEXT.NORMAL .. "-")
        end
    end,

    ----------------------------------------------------------------------------
    -- Show the details of a special action required for the skill
    --
    -- @special_action         String      The special actiion
    ----------------------------------------------------------------------------
    SetRequiredSpecialAction = function(self, special_action)
        local current_special_action = self.labels.special_action.value:GetText()

        -- if special action is required
        if special_action ~= nil then
            -- add to current special action or overwrite "-"
            if current_special_action == "-" then
                current_special_action = MTSLUI_FONTS.COLORS.TEXT.NORMAL .. special_action[MTSLUI_CURRENT_LANGUAGE]
            else
                current_special_action = current_special_action .. " " .. MTSLUI_FONTS.COLORS.TEXT.NORMAL .. special_action[MTSLUI_CURRENT_LANGUAGE]
            end
            self.labels.special_action.value:SetText(current_special_action)
        -- dont overwrite current special action
        elseif current_special_action == nil or current_special_action == "" then
            self.labels.special_action.value:SetText(MTSLUI_FONTS.COLORS.TEXT.NORMAL .. "-")
        end
    end,

    ---------------------------------------------------------------------------------------------------
    -- Show the details of a skill learned from trainer
    --
    -- @trainers_info		MTSLDATA	Contains the price from trainer and list of souces with npc ids
    ----------------------------------------------------------------------------------------------------
    ShowDetailsOfSkillTypeTrainer = function(self, trainers_info)
        self.labels.price.value:SetText(MTSL_TOOLS:GetNumberAsMoneyString(trainers_info.price))
        self.labels.type.value:SetText(MTSLUI_FONTS.COLORS.TEXT.NORMAL .. MTSLUI_LOCALES_LABELS["trainer"][MTSLUI_CURRENT_LANGUAGE])
        self.labels.source.value:SetText(MTSLUI_FONTS.COLORS.TEXT.NORMAL .. MTSLUI_LOCALES_LABELS["trainer"][MTSLUI_CURRENT_LANGUAGE])
        -- Labels to show "Trained by: <trainer>"
        self.labels.sources.title:SetText(MTSLUI_FONTS.COLORS.TEXT.TITLE .. MTSLUI_LOCALES_LABELS["trained by"][MTSLUI_CURRENT_LANGUAGE])
        -- Get all "available" trainers for the player
        local trainers = MTSL_LOGIC_PLAYER_NPC:GetNpcsByIds(trainers_info.sources)
        -- Show all the npcs
        self:ShowDetailsOfNpcs(trainers, 0)
        -- hide the tooltips
        self:HideTooltipFrameShowSourceName()
        self:HideTooltipFrameShowAltSourceName()
    end,

    ---------------------------------------------------------------------------------------------------------
    -- Show the details of a skill learned from quest
    --
    -- @quest_id				Number	    The id of the quest to show
    -- @profession_name         String      The name of the profession
    -- @current_xp_level        Number      The current XP level of the player
    -- @is_alternative_source	Number	    Indicates if quest is primary (=0) or secondary (=1) source for skill
    -- @is_primary_type	        Number	    Indicates if quest is primary (=0) or secondary (=1) type for skill
    ----------------------------------------------------------------------------------------------------------
    ShowDetailsOfSkillTypeQuest = function(self, quest_ids, profession_name, current_xp_level, is_alternative_source, is_primary_type)
        if is_alternative_source == 1 then
            self.labels.alt_sources.title:Show()
            self.labels.alt_type.title:Show()
            self.labels.alt_type.value:Show()
            self.labels.alt_source.title:Show()
            self.labels.alt_source.value:Show()
        end

        local quest = MTSL_LOGIC_QUEST:GetQuestByIds(quest_ids)
        if is_alternative_source == 0 then
            self.labels.sources.title:SetText(MTSLUI_FONTS.COLORS.TEXT.TITLE .. MTSLUI_LOCALES_LABELS["started by"][MTSLUI_CURRENT_LANGUAGE])
        else
            self.labels.alt_sources.title:SetText(MTSLUI_FONTS.COLORS.TEXT.TITLE .. MTSLUI_LOCALES_LABELS["started by"][MTSLUI_CURRENT_LANGUAGE])
        end
        -- check if quest is availbe to us
        if quest ~= nil then
            self:SetSourceType(MTSLUI_FONTS.COLORS.TEXT.NORMAL .. MTSLUI_LOCALES_LABELS["quest"][MTSLUI_CURRENT_LANGUAGE] .. " : " .. quest["name"][MTSLUI_CURRENT_LANGUAGE], is_alternative_source, is_primary_type)
            -- show xp level requirements if any
            self:SetRequiredXPLevel(quest.min_xp_level, current_xp_level)
            self:SetRequiredSpecialAction(quest.special_action)
            -- show the npcs as sources that start it if any
            local amount_npcs = MTSL_TOOLS:CountItemsInArray(quest.npcs)
            local amount_items = MTSL_TOOLS:CountItemsInArray(quest.items)

            -- Can only be 1 source
            if amount_npcs > 0 then
                -- Get the npcs the player can interact with
                local questgivers = MTSL_LOGIC_PLAYER_NPC:GetNpcsByIds(quest.npcs)
                self:ShowDetailsOfNpcs(questgivers, is_alternative_source)
                -- hide the tooltip since it does not start from an item
                if is_alternative_source == 0 then
                    self:HideTooltipFrameShowSourceName()
                else
                    self:HideTooltipFrameShowAltSourceName()
                end
            else
                self:ShowDetailsOfNpcs({nil}, is_alternative_source)
            end
            -- show the items as sources
            if amount_items > 0 then
                local items = MTSL_LOGIC_ITEM_OBJECT:GetItemsForProfessionByIds(quest.items, profession_name)
                self:ShowDetailsOfItems(items, is_alternative_source)
                -- update the corresponding tooltip to show info on the item
                if is_alternative_source == 0  then
                    self.tooltip_source_name = "item:" .. quest.items[1].id
                else
                    self.tooltip_alt_source_name  = "item:" ..  quest.items[1].id
                end
            end
            -- show the objects
            if quest.objects ~= nil then
                local objects = MTSL_LOGIC_ITEM_OBJECT:GetObjectsByIds(quest.objects)
                self:ShowDetailsOfObjects(objects, is_alternative_source, 1)
            end
            -- hide source labels if none
            if amount_npcs <= 0 and amount_items <= 0 and quest.objects == nil then
                if is_alternative_source == 0 then
                    self.labels.sources.title:Hide()
                    self.labels.sources.ui_frame:Hide()
                else
                    self.labels.alt_sources.title:Hide()
                    self.labels.alt_sources.ui_frame:Hide()
                end
            end
        -- not available for our faction
        else
            self:SetSourceType(MTSLUI_FONTS.COLORS.TEXT.NORMAL .. MTSLUI_LOCALES_LABELS["quest"][MTSLUI_CURRENT_LANGUAGE], is_alternative_source, is_primary_type)
            self:ShowDetailsOfNpcs(quest, is_alternative_source)
        end
    end,

    ---------------------------------------------------------------------------------------------------
    -- Show the details of a skill learned from an object
    --
    -- @oject_id		number  	The id of the source object
    -- @is_alternative_source	Number	    Indicates if quest is primary (=0) or secondary (=1) source for skill
    -- @is_primary_type	        Number	    Indicates if quest is primary (=0) or secondary (=1) type for skill
    ----------------------------------------------------------------------------------------------------
    ShowDetailsOfSkillTypeObject = function (self, oject_id, is_alternative_source, is_primary_type)
        local object = MTSL_LOGIC_ITEM_OBJECT:GetObjectById(oject_id)
        self:SetSourceType(MTSLUI_FONTS.COLORS.TEXT.NORMAL .. object["name"][MTSLUI_CURRENT_LANGUAGE], is_alternative_source, is_primary_type)
        local objects = { object }
        self:ShowDetailsOfObjects(objects, is_alternative_source)
    end,

    ---------------------------------------------------------------------------------------------------
    -- Show the details of a skill learned from a recipe
    --
    -- @item_id		number	The id of the item to show
    -- @profession_name         String      The name of the profession
    -- @current_xp_level        Number      The current XP level of the player
    -- @is_alternative_source	Number	    Indicates if quest is primary (=0) or secondary (=1) source for skill
    -- @is_primary_type	        Number	    Indicates if quest is primary (=0) or secondary (=1) type for skill
    ----------------------------------------------------------------------------------------------------
    ShowDetailsOfSkillTypeItem = function(self, item_id, profession_name, current_xp_level, is_alternative_source, is_primary_type)
        local item = MTSL_LOGIC_ITEM_OBJECT:GetItemForProfessionById(item_id, profession_name)
        if item  == nil then
            print(MTSLUI_FONTS.COLORS.TEXT.ERROR .. "MTSL - Count not find item with id " .. item_id .. " for profession " .. profession_name .. ". Please report this bug!")
        else
            self:SetRequiredXPLevel(item.min_xp_level)
            self:SetRequiredReputationWithFaction(item.reputation)
            self:SetRequiresHoliday(item.holiday)
            self:SetSourceType(MTSLUI_FONTS:GetTextColorByItemQuality(item.quality) .. item["name"][MTSLUI_CURRENT_LANGUAGE], is_alternative_source, is_primary_type)

            -- Check the amount for each source possible
            local has_vendors = 0
            if item.vendors ~= nil then
                has_vendors = 1
            end
            local has_quests = 0
            if item.quests ~= nil then
                has_quests = 1
            end
            local has_drops = 0
            if item.drops ~= nil then
                has_drops = 1
            end
            local has_objects = 0
            if item.objects ~= nil then
                has_objects = 1
            end

            local amount_sources = has_drops + has_vendors + has_quests + has_objects
            -- hide labels and sources if no sources (when only special action)
            if amount_sources <= 0 then
                self.labels.sources.title:Hide()
                self.labels.sources.ui_frame:Hide()
                self.labels.alt_sources.title:Hide()
                self.labels.alt_sources.ui_frame:Hide()
                self.labels.alt_type.title:Hide()
                self.labels.alt_type.value:Hide()
                self:HideTooltipFrameShowSourceName()
                self:HideTooltipFrameShowAltSourceName()
            else
                -- check if we have more then 1 source to activate the split
                if amount_sources > 1 then
                    -- adjust the height of the source frames to split situation
                    self.labels.alt_sources.title:Show()
                    self.labels.alt_type.title:Show()
                    self.labels.alt_type.value:Show()
                else
                    self:HideTooltipFrameShowAltSourceName()
                end

                -- obtained from vendors
                if has_vendors > 0 then
                    self:SetSourceType(MTSLUI_FONTS.COLORS.TEXT.NORMAL .. MTSLUI_LOCALES_LABELS["vendor"][MTSLUI_CURRENT_LANGUAGE], is_alternative_source, 1)
                    self.tooltip_source_name = "item:" .. item_id
                    self.labels.sources.title:SetText(MTSLUI_FONTS.COLORS.TEXT.TITLE .. MTSLUI_LOCALES_LABELS["sold by"][MTSLUI_CURRENT_LANGUAGE])
                    self.labels.price.value:SetText(MTSL_TOOLS:GetNumberAsMoneyString(item.vendors.price))
                    -- Get all "available" vendors for the player
                    local vendors = MTSL_LOGIC_PLAYER_NPC:GetNpcsByIds(item.vendors.sources)
                    self:ShowDetailsOfNpcs(vendors, 0)
                end
                -- Obtained from a quest
                if has_quests > 0 then
                    -- primary source since no vendors
                    if has_vendors <= 0 then
                        self:ShowDetailsOfSkillTypeQuest(item.quests, profession_name, current_xp_level, 0, 1)
                        self.tooltip_source_name = "item:" .. item_id
                    else
                        -- also set the recipe as alternative source item
                        self:SetSourceType(MTSLUI_FONTS:GetTextColorByItemQuality(item.quality) .. item["name"][MTSLUI_CURRENT_LANGUAGE], 1, is_primary_type)
                        self:ShowDetailsOfSkillTypeQuest(item.quests, profession_name, current_xp_level, 1, 1)
                        self.tooltip_alt_source_name  = "item:" .. item_id
                    end
                end
                -- Obtained as drop of a mob or range of mobs
                if has_drops > 0 then
                    -- primary source since no vendors or quests
                    if has_vendors <= 0 and has_quests <= 0 then
                        self:SetSourceType(MTSLUI_FONTS.COLORS.TEXT.NORMAL .. MTSLUI_LOCALES_LABELS["mobs"][MTSLUI_CURRENT_LANGUAGE], is_alternative_source, 1)
                        self.labels.sources.title:SetText(MTSLUI_FONTS.COLORS.TEXT.TITLE .. MTSLUI_LOCALES_LABELS["dropped by"][MTSLUI_CURRENT_LANGUAGE])
                        -- check if drop of mob or world drops
                        if item.drops.mobs_range ~= nil then
                            self:ShowWorldDropSources(item.drops.mobs_range.min_xp_level, item.drops.mobs_range.max_xp_level, 0)
                        else
                            local mobs = MTSL_LOGIC_PLAYER_NPC:GetMobsByIds(item.drops.mobs)
                            self:ShowDetailsOfNpcs(mobs, 0)
                        end
                        self.tooltip_source_name = "item:" .. item_id
                    -- alternative/secundary source
                    else
                        -- also set the recipe as alternative source item
                        self:SetSourceType(MTSLUI_FONTS:GetTextColorByItemQuality(item.quality) .. item["name"][MTSLUI_CURRENT_LANGUAGE], 1, is_primary_type)
                        self:SetSourceType(MTSLUI_FONTS.COLORS.TEXT.NORMAL .. MTSLUI_LOCALES_LABELS["mobs"][MTSLUI_CURRENT_LANGUAGE], is_alternative_source, 1)
                        self.labels.alt_sources.title:SetText(MTSLUI_FONTS.COLORS.TEXT.TITLE .. MTSLUI_LOCALES_LABELS["dropped by"][MTSLUI_CURRENT_LANGUAGE])
                        -- check if drop of mob or world drops
                        if item.drops.mobs_range ~= nil then
                            self:ShowWorldDropSources(item.drops.mobs_range.min_xp_level, item.drops.mobs_range.max_xp_level, 1)
                        else
                            local mobs = MTSL_LOGIC_PLAYER_NPC:GetMobsByIds(item.drops.mobs)
                            self:ShowDetailsOfNpcs(mobs, 1)
                        end
                        self.tooltip_alt_source_name  = "item:" .. item_id
                    end
                end
                -- Obtained by interacting with an object
                if has_objects > 0 then
                    -- primary source since no vendors or quests or drops
                    if has_vendors <= 0 and has_quests <= 0 and has_drops <= 0 then
                        self:ShowDetailsOfObjects(item.objects, 0)
                    else
                        -- also set the recipe as alternative source item
                        self:SetSourceType(MTSLUI_FONTS:GetTextColorByItemQuality(item.quality) .. item["name"][MTSLUI_CURRENT_LANGUAGE], 1, is_primary_type)
                        self:ShowDetailsOfObjects(item.objects, 1)
                    end
                end
            end
        end
    end,

    ---------------------------------------------------------------------------------------------------
    -- Show the source type of a skill
    --
    -- @text                    String      The text to show for the type
    -- @is_alternative_source	Number	    Indicates if quest is primary (=0) or secondary (=1) source for skill
    -- @is_primary_type	        Number	    Indicates if quest is primary (=0) or secondary (=1) type for skill
    ----------------------------------------------------------------------------------------------------
    SetSourceType = function(self, text, is_alternative_source, is_primary_type)
        if is_alternative_source == 0 then
            if is_primary_type == 0 then
                self.labels.type.value:SetText(text)
            else
                self.labels.source.value:SetText(text)
            end
        else
            if is_primary_type == 0 then
                self.labels.alt_type.value:SetText(text)
            else
                self.labels.alt_source.value:SetText(text)
            end
        end
    end,

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
        self.ui_frame:Show()
    end,

    ---------------------------------------------------------------------------
    -- Show the details of a list of npcs as sources
    --
    -- @npcs			        Array		The list of npcs
    -- @is_alternative_source	Number		Indicating if primary (=0) or secondary (=1) source
    ---------------------------------------------------------------------------
    ShowDetailsOfNpcs = function(self, npcs, is_alternative_source)
        -- Count amount of trainers
        local npcs_amount = MTSL_TOOLS:CountItemsInArray(npcs)
        local labels_sources = self.labels.sources
        local amount_labels = self.MAX_SOURCES_SHOWN_PRIMARY
        -- take secondary source labels
        if is_alternative_source == 1 then
            labels_sources = self.labels.alt_sources
            amount_labels = self.MAX_SOURCES_SHOWN_SECONDARY
        end
        labels_sources.ui_frame:Show()
        -- Not obtainable for this faction
        if npcs_amount <= 0 then
            labels_sources.values[1]:SetText(MTSLUI_FONTS.COLORS.TEXT.NORMAL .. MTSLUI_LOCALES_LABELS["not available faction"][MTSLUI_CURRENT_LANGUAGE])
            labels_sources.values[1]:Show()
            -- Hide the other labels
            for i=2,amount_labels do
                labels_sources.values[i]:Hide()
            end
        else
            -- Show the npcs
            for i=1,amount_labels do
                if npcs[i] ~= nil then
                    local text = ""
                    -- show level of mob/npc if known
                    if npcs[i].xp_level ~= nil and npcs[i].xp_level ~= "" and npcs[i].xp_level ~= 0 then
                        text = "[" .. npcs[i].xp_level["min"]
                        -- show range of levels if needed
                        if npcs[i].xp_level["min"] ~= npcs[i].xp_level["max"] then
                            text = text .. "-" .. npcs[i].xp_level["max"]
                        end
                        -- add a + for elite
                        if npcs[i].xp_level.is_elite == 1 then
                            text = text .. "+"
                        end
                        --end the text
                        text = text .. "] "
                    else
                        text = text .. "[-] "
                    end
                    -- add name & zone
                    text = text .. npcs[i]["name"][MTSLUI_CURRENT_LANGUAGE] .. " - " ..  MTSL_LOGIC_WORLD:GetZoneNameById(npcs[i].zone_id)
                    -- add coords if known
                    if npcs[i].location ~= nil and npcs[i].location.x ~= "-" and
                            npcs[i].location.x ~= "" then
                        text = text .. " (" .. npcs[i].location.x ..", " .. npcs[i].location.y ..")"
                    end
                    -- Check if require reputation to interact with npc
                    if npcs[i].reputation ~= nil then
                        text = text .. " [".. npcs[i].reputation.faction .. " - " .. npcs[i].reputation.level .. "]"
                    end
                    -- Check if special action is required to interact with npc
                    if npcs[i].special_action ~= nil then
                        text = text .. " [".. npcs[i].special_action[MTSLUI_CURRENT_LANGUAGE] .. "]"
                    end

                    labels_sources.values[i]:SetText(MTSLUI_FONTS.COLORS.TEXT.NORMAL .. text)
                    labels_sources.values[i]:Show()
                else
                    labels_sources.values[i]:Hide()
                end
            end
        end
    end,

    ---------------------------------------------------------------------------
    -- Show the labels of the world drop in the main list
    --
    -- @min_level	            Number      The minimum level of the mobs
    -- @max_level	            Number      The maximum level of the mobs
    -- @is_alternative_source	Number		Indicating if primary (=0) or secondary (=1) source
    ---------------------------------------------------------------------------
    ShowWorldDropSources = function(self, min_level, max_level, is_alternative_source)
        local label_sources = self.labels.sources
        local amount_labels = self.MAX_SOURCES_SHOWN_PRIMARY
        if is_alternative_source == 1  then
            label_sources = self.labels.alt_sources
            amount_labels = self.MAX_SOURCES_SHOWN_SECONDARY
        end
        label_sources.ui_frame:Show()
        local text = MTSLUI_LOCALES_LABELS["worldwide drop"][MTSLUI_CURRENT_LANGUAGE] .. min_level .. MTSLUI_LOCALES_LABELS["to"][MTSLUI_CURRENT_LANGUAGE] .. max_level .. MTSLUI_LOCALES_LABELS["worldwide drop rest"][MTSLUI_CURRENT_LANGUAGE]
        label_sources.values[1]:SetText(MTSLUI_FONTS.COLORS.TEXT.NORMAL .. text)
        label_sources.values[1]:Show()
        for i=2,amount_labels do
            label_sources.values[i]:Hide()
        end
    end,

    ---------------------------------------------------------------------------
    -- Show the details of a list of items as sources
    --
    -- @items			Array		The list of items
    -- @is_alternative_source	Number		Indicating if primary (=0) or secondary (=1) source
    ---------------------------------------------------------------------------
    ShowDetailsOfItems = function(self, items, is_alternative_source)
        local labels_sources = self.labels.sources
        local amount_labels = self.MAX_SOURCES_SHOWN_PRIMARY
        -- take secondary source labels
        if is_alternative_source == 1 then
            labels_sources = self.labels.alt_sources
            amount_labels = self.MAX_SOURCES_SHOWN_SECONDARY
        end
        labels_sources.ui_frame:Show()
        for i=1, amount_labels do
            if items[i] ~= nil then
                local location =  MTSL_LOGIC_WORLD:GetZoneNameById(items[i].zone_id)
                local text = "[" .. MTSLUI_LOCALES_LABELS["item"][MTSLUI_CURRENT_LANGUAGE] .. "] " .. items[i]["name"][MTSLUI_CURRENT_LANGUAGE]
                if location ~= "" then
                    text = text  .. " - " .. location
                end
                -- add coords if known
                if items[i].location ~= nil and items[i].location.x ~= "-" and
                        items[i].location.x ~= "" then
                    text = text .. " (" .. items[i].location.x ..", " .. items[i].location.y ..")"
                end
                labels_sources.values[i]:SetText(MTSLUI_FONTS.COLORS.TEXT.NORMAL .. text)
                labels_sources.values[i]:Show()
            else
                labels_sources.values[i]:Hide()
            end
        end
    end,

    ---------------------------------------------------------------------------
    -- Show the labels of the visible objects in the main list
    --
    -- @objects			Array		The list of objects
    -- @is_alternative_source	Number		Indicating if primary (=0) or secondary (=1) source
    ---------------------------------------------------------------------------
    ShowDetailsOfObjects = function(self, objects, is_alternative_source)
        local labels_sources = self.labels.sources
        local amount_labels = self.MAX_SOURCES_SHOWN_PRIMARY
        -- take secondary source labels
        if is_alternative_source == 1 then
            labels_sources = self.labels.alt_sources
            amount_labels = self.MAX_SOURCES_SHOWN_SECONDARY
        end
        labels_sources.ui_frame:Show()
        for i=1, amount_labels do
            if objects[i] ~= nil then
                local text =  "[" .. MTSLUI_LOCALES_LABELS["object"][MTSLUI_CURRENT_LANGUAGE] .. "] " .. objects[i]["name"][MTSLUI_CURRENT_LANGUAGE] .. " - " ..  MTSL_LOGIC_WORLD:GetZoneNameById(objects[i].zone_id)
                -- add coords if known
                if objects[i].location ~= nil and objects[i].location.x ~= "-" and
                        objects[i].location.x ~= "" then
                    text = text .. " (" .. objects[i].location.x ..", " .. objects[i].location.y ..")"
                end
                labels_sources.values[i]:SetText(MTSLUI_FONTS.COLORS.TEXT.NORMAL .. text)
                labels_sources.values[i]:Show()
            else
                labels_sources.values[i]:Hide()
            end
        end
    end,
}