local L = LibStub("AceLocale-3.0"):GetLocale("TrackOMatic", true);
local media = LibStub("LibSharedMedia-3.0");

local CONFIG_SHOWN = false;
local CURRENT_TIP = 0;
local STORE_NEW = {};

local TIPS = {
    "REMOVE_BAR", "RESET_SESSION", "RIGHT_CLICK_BAR", "SORT_CATEGORIES",
    "CLEAR_CATEGORIES", "CHANGE_GOAL", "TRACK_REPUTATION", "TRACK_ITEM",
    "TRACK_PROFESSION", "REPUTATION_DETAILS",
    "GOLD_BAR", "MAIN_MENU", "LOCK_BUTTON", "EXPAND_CATEGORIES"
};

function TrackOMatic_OpenMainConfig()
    InterfaceOptionsFrame_OpenToCategory(TrackOMaticConfigContainer);
    InterfaceOptionsFrame_OpenToCategory(TrackOMaticConfigContainer);
end

--==================================================
-- Set up the configuration frame
--==================================================
function TrackOMatic_Config_OnLoad(self)

    self.name = L["ADDON_TITLE"];
    self.okay = function(self) TrackOMatic_Config_Okay(); end;
    self.cancel = function(self) TrackOMatic_Config_Cancel(); end;
    self.refresh = function(self) TrackOMatic_Config_Refresh(); end;
    self.default = function(self) TrackOMatic_Config_SetDefaults(); end;
    InterfaceOptions_AddCategory(self);

    TrackOMaticConfigTitle:SetText(string.format(L["VERSION_TEXT"], "|cffffffffv" .. TrackOMatic.Version));

    -- ********** Frame Options **********

    TrackOMaticConfig_GeneralContainerTitle:SetText(L["CONFIG_GENERAL"]);
    TrackOMaticConfig_GeneralOptions_ShowText:SetText(L["OPTION_SHOW_TRACKER"]);

    TrackOMaticConfig_GeneralOptions_HeadersText:SetText(L["OPTION_HIDE_HEADERS"]);
    TrackOMaticConfig_GeneralOptions_Headers.tooltip = L["OPTION_HIDE_HEADERS"];
    TrackOMaticConfig_GeneralOptions_Headers.subTooltip = L["OPTION_HIDE_HEADERS_TOOLTIP"];

    TrackOMaticConfig_GeneralOptions_GlowsText:SetText(L["OPTION_ENABLE_GLOWS"]);
    TrackOMaticConfig_GeneralOptions_Glows.tooltip = L["OPTION_ENABLE_GLOWS"];
    TrackOMaticConfig_GeneralOptions_Glows.subTooltip = L["OPTION_ENABLE_GLOWS_TOOLTIP"];

    TrackOMaticConfig_GeneralOptions_LoadMessageText:SetText(L["OPTION_SHOW_LOAD_MESSAGE"]);
    TrackOMaticConfig_GeneralOptions_LoadMessage.tooltip = L["OPTION_SHOW_LOAD_MESSAGE"];
    TrackOMaticConfig_GeneralOptions_LoadMessage.subTooltip = L["OPTION_SHOW_LOAD_MESSAGE_TOOLTIP"];

    TrackOMaticConfig_GeneralOptions_AlertsText:SetText(L["OPTION_ENABLE_ALERTS"]);
    TrackOMaticConfig_GeneralOptions_Alerts.tooltip = L["OPTION_ENABLE_ALERTS"];
    TrackOMaticConfig_GeneralOptions_Alerts.subTooltip = L["OPTION_ENABLE_ALERTS_TOOLTIP"];

    TrackOMaticConfig_GeneralOptions_Width:SetMinMaxValues(75, 125);
    TrackOMaticConfig_GeneralOptions_Width:SetValueStep(5);
    TrackOMaticConfig_GeneralOptions_Width.tooltip = L["OPTION_WIDTH_LABEL"];
    TrackOMaticConfig_GeneralOptions_Width.subTooltip = L["OPTION_WIDTH_TOOLTIP"];

    TrackOMaticConfig_GeneralOptions_Scale:SetMinMaxValues(7, 15);
    TrackOMaticConfig_GeneralOptions_Scale:SetValueStep(1);
    TrackOMaticConfig_GeneralOptions_Scale.tooltip = L["OPTION_SCALE_LABEL"];
    TrackOMaticConfig_GeneralOptions_Scale.subTooltip = L["OPTION_SCALE_TOOLTIP"];

    TrackOMaticConfig_GeneralOptions_TextureLabel:SetText(L["OPTION_BAR_TEXTURE"]);
    TrackOMaticConfig_GeneralOptions_Texture.tooltip = L["OPTION_BAR_TEXTURE"];
    TrackOMaticConfig_GeneralOptions_Texture.subTooltip = L["OPTION_BAR_TEXTURE_TOOLTIP"];
    TrackOMaticConfig_GeneralOptions_Texture.tooltipAbove = true;

    -- ********** Player Info Options **********

    TrackOMaticConfig_PlayerContainerTitle:SetText(L["CONFIG_PLAYER_BARS"]);
    TrackOMaticConfig_PlayerOptions_GoldBarLabel:SetText(L["OPTION_GOLD_BAR"]);
    TrackOMaticConfig_PlayerOptions_GoldGlowText:SetText(L["OPTION_GOLD_LOST_GLOW"]);
    TrackOMaticConfig_PlayerOptions_GoldGlow.tooltip = L["OPTION_GOLD_LOST_GLOW_TOOLTIP"];
    TrackOMaticConfig_PlayerOptions_DurabilityBarLabel:SetText(L["OPTION_DURABILITY_BAR"]);
    TrackOMaticConfig_PlayerOptions_DurabilityGlowText:SetText(L["OPTION_DURABILITY_GLOW"]);
    TrackOMaticConfig_PlayerOptions_DurabilityGlow.tooltip = L["OPTION_DURABILITY_GLOW_TOOLTIP"];
    TrackOMaticConfig_PlayerOptions_LevelingBarLabel:SetText(L["OPTION_LEVELING_BARS"]);
    TrackOMaticConfig_PlayerOptions_ReverseLevelingText:SetText(L["OPTION_REVERSE_LEVELING_BARS"]);
    TrackOMaticConfig_PlayerOptions_ReverseLeveling.tooltip = L["OPTION_REVERSE_LEVELING_BARS_TOOLTIP"];
    TrackOMaticConfig_PlayerOptions_EstimationMethodLabel:SetText(L["OPTION_ESTIMATION_MODE"]);

    -- build the tooltip for the Kills to Level Up estimation method dropdown
    local emt = string.gsub(L["OPTION_ESTIMATION_MODE_TOOLTIP"], "{$r}", "|cff00ff00" .. L["ESTIMATION_MODE_SMART_AVERAGE"] .. "|r");

    optionDetails = L["ESTIMATION_MODE_SMART_AVERAGE_DESC"] .. "\n\n" .. L["ESTIMATION_MODE_AVERAGE_DESC"] .. "\n\n" .. L["ESTIMATION_MODE_LAST_KILL_DESC"];
    emt = string.gsub(emt, "{$s}", optionDetails);

    TrackOMaticConfig_PlayerOptions_EstimationMethod.tooltip = L["OPTION_ESTIMATION_MODE"];
    TrackOMaticConfig_PlayerOptions_EstimationMethod.subTooltip = emt;
    TrackOMaticConfig_PlayerOptions_EstimationMethod.tooltipAbove = true;

    -- ********** Item Tracker Options **********

    TrackOMaticConfig_ItemContainerTitle:SetText(L["CONFIG_ITEM_BARS"]);
    TrackOMaticConfig_ItemOptions_QuantityText:SetText(L["OPTION_SHOW_QUANTITY"]);
    TrackOMaticConfig_ItemOptions_Quantity.tooltip = L["OPTION_SHOW_QUANTITY_TOOLTIP"];
    TrackOMaticConfig_ItemOptions_PercentText:SetText(L["OPTION_SHOW_PERCENT"]);
    TrackOMaticConfig_ItemOptions_Percent.tooltip = L["OPTION_SHOW_PERCENT_TOOLTIP"];
    TrackOMaticConfig_ItemOptions_DefaultGlowText:SetText(L["OPTION_DEFAULT_GLOW"]);
    TrackOMaticConfig_ItemOptions_DefaultGlow.tooltip = L["OPTION_ITEM_DEFAULT_GLOW_TOOLTIP"];
    TrackOMaticConfig_ItemOptions_CustomGlowText:SetText(L["OPTION_CUSTOM_GLOW"]);
    TrackOMaticConfig_ItemOptions_CustomGlow.tooltip = L["OPTION_ITEM_CUSTOM_GLOW_TOOLTIP"];

    -- ********** Professtion Tracker Options **********

    TrackOMaticConfig_ProfessionContainerTitle:SetText(L["CONFIG_PROFESSION_BARS"]);
    TrackOMaticConfig_ProfessionOptions_GlowText:SetText(L["OPTION_PROFESSION_GLOW"]);
    TrackOMaticConfig_ProfessionOptions_Glow.tooltip = L["OPTION_PROFESSION_GLOW_TOOLTIP"];

    -- ********** Reputation Tracker Options **********

    TrackOMaticConfig_ReputationContainerTitle:SetText(L["CONFIG_REPUTATION_BARS"]);
    TrackOMaticConfig_ReputationOptions_DisplayLabel:SetText(L["OPTION_REP_GAIN_DISPLAY"]);
    TrackOMaticConfig_ReputationOptions_Display.tooltip = L["OPTION_REP_GAIN_DISPLAY"];
    TrackOMaticConfig_ReputationOptions_Display.subTooltip = L["OPTION_REP_GAIN_DISPLAY_TOOLTIP"];
    TrackOMaticConfig_ReputationOptions_Display.tooltipAbove = true;

    -- ********** Initialize Dropdowns **********

    UIDropDownMenu_Initialize(TrackOMaticConfig_GeneralOptions_Texture, TrackOMatic_Config_InitTextureSelect);
    UIDropDownMenu_SetWidth(TrackOMaticConfig_GeneralOptions_Texture, 225);
    UIDropDownMenu_JustifyText(TrackOMaticConfig_GeneralOptions_Texture, "LEFT");

    UIDropDownMenu_Initialize(TrackOMaticConfig_PlayerOptions_EstimationMethod, TrackOMatic_Config_InitEstimationSelect);
    UIDropDownMenu_SetWidth(TrackOMaticConfig_PlayerOptions_EstimationMethod, 180);
    UIDropDownMenu_JustifyText(TrackOMaticConfig_PlayerOptions_EstimationMethod, "LEFT");

    UIDropDownMenu_Initialize(TrackOMaticConfig_ReputationOptions_Display, TrackOMatic_Config_InitRepDisplaySelect);
    UIDropDownMenu_SetWidth(TrackOMaticConfig_ReputationOptions_Display, 180);
    UIDropDownMenu_JustifyText(TrackOMaticConfig_ReputationOptions_Display, "LEFT");

end

--==================================================
-- Handle when the configuration is opened
--==================================================
function TrackOMatic_Config_OnOpen()
    if (CONFIG_SHOWN == true) then return; end
    TrackOMatic_Config_StoreCurrentSettings();
    TrackOMatic_Config_ShowTip();
    CONFIG_SHOWN = true;
end

--==================================================
-- Show currently saved settings on the config
-- frame
--==================================================
function TrackOMatic_Config_Refresh()
    TrackOMatic_Config_OnOpen();

    TrackOMaticConfig_GeneralOptions_Show:SetChecked(TRACKOMATIC_VARS[TrackOMatic.Profile]['visible']);
    TrackOMaticConfig_GeneralOptions_Headers:SetChecked(TRACKOMATIC_VARS[TrackOMatic.Profile]['hide_category_headers']);
    TrackOMaticConfig_GeneralOptions_Glows:SetChecked(TRACKOMATIC_VARS[TrackOMatic.Profile]['enable_glows']);
    TrackOMaticConfig_GeneralOptions_LoadMessage:SetChecked(TRACKOMATIC_VARS['config']['show_load_message']);
    TrackOMaticConfig_GeneralOptions_Alerts:SetChecked(TRACKOMATIC_VARS['config']['show_alert_boxes']);
    TrackOMaticConfig_GeneralOptions_Scale:SetValue(math.floor(TRACKOMATIC_VARS[TrackOMatic.Profile]['scale'] * 10));
    TrackOMaticConfig_GeneralOptions_Width:SetValue(math.floor(TRACKOMATIC_VARS[TrackOMatic.Profile]['width'] / 5) * 5);
    ToggleDropDownMenu(1, nil, TrackOMaticConfig_GeneralOptions_Texture, "TrackOMaticConfig_GeneralOptions_Texture", 0, 0);
    UIDropDownMenu_SetSelectedValue(TrackOMaticConfig_GeneralOptions_Texture, TRACKOMATIC_VARS['config']['texture']);
    ToggleDropDownMenu(1, nil, TrackOMaticConfig_GeneralOptions_Texture, "TrackOMaticConfig_GeneralOptions_Texture", 0, 0);
    
    TrackOMaticConfig_PlayerOptions_GoldGlow:SetChecked(TRACKOMATIC_VARS['config']['gold_glow_negative']);
    TrackOMaticConfig_PlayerOptions_DurabilityGlow:SetChecked(TRACKOMATIC_VARS['config']['durability_glow_broken']);
    TrackOMaticConfig_PlayerOptions_ReverseLeveling:SetChecked(TRACKOMATIC_VARS['config']['reverse_leveling_bars']);
    ToggleDropDownMenu(1, nil, TrackOMaticConfig_PlayerOptions_EstimationMethod, "TrackOMaticConfig_PlayerOptions_EstimationMethod", 0, 0);
    UIDropDownMenu_SetSelectedValue(TrackOMaticConfig_PlayerOptions_EstimationMethod, TRACKOMATIC_VARS['config']['mob_grind_estimation_mode']);
    ToggleDropDownMenu(1, nil, TrackOMaticConfig_PlayerOptions_EstimationMethod, "TrackOMaticConfig_PlayerOptions_EstimationMethod", 0, 0);

    TrackOMaticConfig_ItemOptions_Quantity:SetChecked(TRACKOMATIC_VARS[TrackOMatic.Profile]['show_quantity_items']);
    TrackOMaticConfig_ItemOptions_Percent:SetChecked(TRACKOMATIC_VARS[TrackOMatic.Profile]['show_percent_items']);
    TrackOMaticConfig_ItemOptions_DefaultGlow:SetChecked(TRACKOMATIC_VARS['config']['item_default_glow']);
    TrackOMaticConfig_ItemOptions_CustomGlow:SetChecked(TRACKOMATIC_VARS['config']['item_custom_glow']);

    TrackOMaticConfig_ProfessionOptions_Glow:SetChecked(TRACKOMATIC_VARS['config']['profession_glow']);

    ToggleDropDownMenu(1, nil, TrackOMaticConfig_ReputationOptions_Display, "TrackOMaticConfig_ReputationOptions_Display", 0, 0);
    UIDropDownMenu_SetSelectedValue(TrackOMaticConfig_ReputationOptions_Display, TRACKOMATIC_VARS['config']['rep_gain_display']);
    ToggleDropDownMenu(1, nil, TrackOMaticConfig_ReputationOptions_Display, "TrackOMaticConfig_ReputationOptions_Display", 0, 0);
end

--==================================================
-- Store current settings to restore if the user
-- presses cancel
--==================================================
function TrackOMatic_Config_StoreCurrentSettings()
    STORE_NEW = {
        visible = TRACKOMATIC_VARS[TrackOMatic.Profile]['visible'],
        hideHeaders = TRACKOMATIC_VARS[TrackOMatic.Profile]['hide_category_headers'],
        enableGlows = TRACKOMATIC_VARS[TrackOMatic.Profile]['enable_glows'],
        loadMessage = TRACKOMATIC_VARS['config']['show_load_message'],
        showAlerts = TRACKOMATIC_VARS['config']['show_alert_boxes'],
        scale = TRACKOMATIC_VARS[TrackOMatic.Profile]['scale'],
        width = TRACKOMATIC_VARS[TrackOMatic.Profile]['width'],
        barTexture = TRACKOMATIC_VARS['config']['texture'],
        
        goldGlow = TRACKOMATIC_VARS['config']['gold_glow_negative'],
        durabilityLowest = TRACKOMATIC_VARS['config']['show_lowest_durability'],
        durabilityGlow = TRACKOMATIC_VARS['config']['durability_glow_broken'],
        reverseLeveling = TRACKOMATIC_VARS['config']['reverse_leveling_bars'],
        estimationMethod = TRACKOMATIC_VARS['config']['mob_grind_estimation_mode'],
        itemQuantity = TRACKOMATIC_VARS[TrackOMatic.Profile]['show_quantity_items'],
        itemPercent = TRACKOMATIC_VARS[TrackOMatic.Profile]['show_percent_items'],
        itemDefaultGlow = TRACKOMATIC_VARS['config']['item_default_glow'],
        itemCustomGlow = TRACKOMATIC_VARS['config']['item_custom_glow'],
        --currencyQuantity = TRACKOMATIC_VARS[TrackOMatic.Profile]['show_quantity_currency'],
        --currencyPercent = TRACKOMATIC_VARS[TrackOMatic.Profile]['show_percent_currency'],
        --currencyDefaultGlow = TRACKOMATIC_VARS['config']['currency_default_glow'],
        professionGlow = TRACKOMATIC_VARS['config']['profession_glow'],
        repDisplay = TRACKOMATIC_VARS['config']['rep_gain_display'],
    };
end

--==================================================
-- Handle clicking the Okay button
--==================================================
function TrackOMatic_Config_Okay()
    TRACKOMATIC_VARS[TrackOMatic.Profile]['visible'] = STORE_NEW.visible;
    TRACKOMATIC_VARS[TrackOMatic.Profile]['hide_category_headers'] = STORE_NEW.hideHeaders;
    TRACKOMATIC_VARS[TrackOMatic.Profile]['enable_glows'] = STORE_NEW.enableGlows;
    TRACKOMATIC_VARS['config']['show_load_message'] = STORE_NEW.loadMessage;
    TRACKOMATIC_VARS['config']['show_alert_boxes'] = STORE_NEW.showAlerts;
    --TRACKOMATIC_VARS[TrackOMatic.Profile]['scale'] = STORE_NEW.scale;
    --TRACKOMATIC_VARS[TrackOMatic.Profile]['width'] = STORE_NEW.width;
    --TRACKOMATIC_VARS['config']['texture'] = STORE_NEW.barTexture;
    TRACKOMATIC_VARS['config']['gold_glow_negative'] = STORE_NEW.goldGlow;
    TRACKOMATIC_VARS['config']['show_lowest_durability'] = STORE_NEW.durabilityLowest;
    TRACKOMATIC_VARS['config']['durability_glow_broken'] = STORE_NEW.durabilityGlow;
    TRACKOMATIC_VARS['config']['reverse_leveling_bars'] = STORE_NEW.reverseLeveling;
    TRACKOMATIC_VARS['config']['mob_grind_estimation_mode'] = STORE_NEW.estimationMethod;
    TRACKOMATIC_VARS[TrackOMatic.Profile]['show_quantity_items'] = STORE_NEW.itemQuantity;
    TRACKOMATIC_VARS[TrackOMatic.Profile]['show_percent_items'] = STORE_NEW.itemPercent;
    TRACKOMATIC_VARS['config']['item_default_glow'] = STORE_NEW.itemDefaultGlow;
    TRACKOMATIC_VARS['config']['item_custom_glow'] = STORE_NEW.itemCustomGlow;
    --TRACKOMATIC_VARS[TrackOMatic.Profile]['show_quantity_currency'] = STORE_NEW.currencyQuantity;
    --TRACKOMATIC_VARS[TrackOMatic.Profile]['show_percent_currency'] = STORE_NEW.currencyPercent;
    --TRACKOMATIC_VARS['config']['currency_default_glow'] = STORE_NEW.currencyDefaultGlow;
    TRACKOMATIC_VARS['config']['profession_glow'] = STORE_NEW.professionGlow;
    TRACKOMATIC_VARS['config']['rep_gain_display'] = STORE_NEW.repDisplay;
    TrackOMatic_SetScale(TRACKOMATIC_VARS[TrackOMatic.Profile]['scale']);
    TrackOMatic_SetWidth(TRACKOMATIC_VARS[TrackOMatic.Profile]['width']);
    TrackOMatic_Config_SetTexture(TRACKOMATIC_VARS['config']['texture']);
    TrackOMatic_BuildTracker();
    CONFIG_SHOWN = false;
end

--==================================================
-- Handle clicking the Cancel button; restore
-- all settings to their previous values
--==================================================
function TrackOMatic_Config_Cancel()
    TrackOMatic_SetScale(STORE_NEW.scale);
    TrackOMatic_SetWidth(STORE_NEW.width);
    TrackOMatic_Config_SetTexture(STORE_NEW.barTexture);
    TrackOMatic_BuildTracker();
    CONFIG_SHOWN = false;
end

--==================================================
-- Handle clicking the Defaults button; restore
-- all settings to their default values
--==================================================
function TrackOMatic_Config_SetDefaults()
    TrackOMatic_SetVisible(true, true);
    TRACKOMATIC_VARS[TrackOMatic.Profile]['hide_category_headers'] = false;
    TRACKOMATIC_VARS[TrackOMatic.Profile]['enable_glows'] = true;
    TRACKOMATIC_VARS['config']['show_load_message'] = false;
    TRACKOMATIC_VARS['config']['show_alert_boxes'] = true;
    TrackOMatic_SetScale(1);
    TrackOMatic_SetWidth(75);
    TrackOMatic_Config_SetTexture("Minimalist");
    TRACKOMATIC_VARS['config']['gold_glow_negative'] = true;
    TRACKOMATIC_VARS['config']['show_lowest_durability'] = false;
    TRACKOMATIC_VARS['config']['durability_glow_broken'] = true;
    TRACKOMATIC_VARS['config']['reverse_leveling_bars'] = false;
    TRACKOMATIC_VARS['config']['mob_grind_estimation_mode'] = 0;

    TRACKOMATIC_VARS[TrackOMatic.Profile]['show_quantity_items'] = true;
    TRACKOMATIC_VARS[TrackOMatic.Profile]['show_percent_items'] = true;
    TRACKOMATIC_VARS['config']['item_default_glow'] = true;
    TRACKOMATIC_VARS['config']['item_custom_glow'] = true;

    TRACKOMATIC_VARS[TrackOMatic.Profile]['show_quantity_currency'] = true;
    TRACKOMATIC_VARS[TrackOMatic.Profile]['show_percent_currency'] = true;
    TRACKOMATIC_VARS['config']['currency_default_glow'] = true;

    TRACKOMATIC_VARS['config']['profession_glow'] = true;

    TRACKOMATIC_VARS['config']['rep_gain_display'] = 1;

    TrackOMatic_Config_StoreCurrentSettings();
    TrackOMatic_Config_Refresh();
    TrackOMatic_BuildTracker();
end

--==================================================
-- Handle clicking on an option (checkboxes,
-- buttons, etc)
--==================================================
function TrackOMatic_Config_OnClickOption(self, id)
    if (id == 1) then
        TrackOMatic_SetVisible(self:GetChecked(), true);
    elseif (id == 2) then
        if (self:GetChecked()) then
            TRACKOMATIC_VARS[TrackOMatic.Profile]['hide_category_headers'] = true;
        else
            TRACKOMATIC_VARS[TrackOMatic.Profile]['hide_category_headers'] = false;
        end
        TrackOMatic_BuildTracker();
    elseif (id == 3) then
        if (self:GetChecked()) then
            TRACKOMATIC_VARS[TrackOMatic.Profile]['enable_glows'] = true;
        else
            TRACKOMATIC_VARS[TrackOMatic.Profile]['enable_glows'] = false;
        end
        TrackOMatic_UpdateTracker(1);
    elseif (id == 4) then
        if (self:GetChecked()) then
            TRACKOMATIC_VARS['config']['show_load_message'] = true;
        else
            TRACKOMATIC_VARS['config']['show_load_message'] = false;
        end
    elseif (id == 5) then
        if (self:GetChecked()) then
            TRACKOMATIC_VARS['config']['show_alert_boxes'] = true;
        else
            TRACKOMATIC_VARS['config']['show_alert_boxes'] = false;
        end
        TrackOMatic_UpdateTracker(1);

    -- player options
    elseif (id == 13) then
        if (self:GetChecked()) then
            TRACKOMATIC_VARS['config']['gold_glow_negative'] = true;
        else
            TRACKOMATIC_VARS['config']['gold_glow_negative'] = false;
        end
        TrackOMatic_UpdateTracker(1);
    elseif (id == 14) then
        if (self:GetChecked()) then
            TRACKOMATIC_VARS['config']['show_lowest_durability'] = true;
        else
            TRACKOMATIC_VARS['config']['show_lowest_durability'] = false;
        end
        TrackOMatic_UpdateTracker(1);
    elseif (id == 15) then
        if (self:GetChecked()) then
            TRACKOMATIC_VARS['config']['durability_glow_broken'] = true;
        else
            TRACKOMATIC_VARS['config']['durability_glow_broken'] = false;
        end
        TrackOMatic_UpdateTracker(1);
    elseif (id == 16) then
        if (self:GetChecked()) then
            TRACKOMATIC_VARS['config']['reverse_leveling_bars'] = true;
        else
            TRACKOMATIC_VARS['config']['reverse_leveling_bars'] = false;
        end
        TrackOMatic_UpdateTracker(1);

    -- item options
    elseif (id == 20) then
        if (self:GetChecked()) then
            TRACKOMATIC_VARS[TrackOMatic.Profile]['show_quantity_items'] = true;
        else
            TRACKOMATIC_VARS[TrackOMatic.Profile]['show_quantity_items'] = false;
        end
        TrackOMatic_UpdateTracker(1);
    elseif (id == 21) then
        if (self:GetChecked()) then
            TRACKOMATIC_VARS[TrackOMatic.Profile]['show_percent_items'] = true;
        else
            TRACKOMATIC_VARS[TrackOMatic.Profile]['show_percent_items'] = false;
        end
        TrackOMatic_UpdateTracker(1);
    elseif (id == 22) then
        if (self:GetChecked()) then
            TRACKOMATIC_VARS['config']['item_default_glow'] = true;
        else
            TRACKOMATIC_VARS['config']['item_default_glow'] = false;
        end
        TrackOMatic_UpdateTracker(1);
    elseif (id == 23) then
        if (self:GetChecked()) then
            TRACKOMATIC_VARS['config']['item_custom_glow'] = true;
        else
            TRACKOMATIC_VARS['config']['item_custom_glow'] = false;
        end
        TrackOMatic_UpdateTracker(1);

    -- currency options
    elseif (id == 30) then
        if (self:GetChecked()) then
            TRACKOMATIC_VARS[TrackOMatic.Profile]['show_quantity_currency'] = true;
        else
            TRACKOMATIC_VARS[TrackOMatic.Profile]['show_quantity_currency'] = false;
        end
        TrackOMatic_UpdateTracker(1);
    elseif (id == 31) then
        if (self:GetChecked()) then
            TRACKOMATIC_VARS[TrackOMatic.Profile]['show_percent_currency'] = true;
        else
            TRACKOMATIC_VARS[TrackOMatic.Profile]['show_percent_currency'] = false;
        end
        TrackOMatic_UpdateTracker(1);
    elseif (id == 32) then
        if (self:GetChecked()) then
            TRACKOMATIC_VARS['config']['currency_default_glow'] = true;
        else
            TRACKOMATIC_VARS['config']['currency_default_glow'] = false;
        end
        TrackOMatic_UpdateTracker(1);

    -- profession options
    --elseif (id == 40) then
    --    if (self:GetChecked()) then
    --        TRACKOMATIC_VARS['config']['advanced_gather_tooltips'] = true;
    --    else
    --        TRACKOMATIC_VARS['config']['advanced_gather_tooltips'] = false;
    --    end
    --    TrackOMatic_UpdateTracker(1);
    elseif (id == 41) then
        if (self:GetChecked()) then
            TRACKOMATIC_VARS['config']['profession_glow'] = true;
        else
            TRACKOMATIC_VARS['config']['profession_glow'] = false;
        end
        TrackOMatic_UpdateTracker(1);
    --elseif (id == 42) then
    --    if (self:GetChecked()) then
    --        TRACKOMATIC_VARS['config']['gather_exclude_low'] = true;
    --    else
    --        TRACKOMATIC_VARS['config']['gather_exclude_low'] = false;
    --    end
    --    TrackOMatic_UpdateTracker(1);
    --elseif (id == 43) then
    --    if (self:GetChecked()) then
    --        TRACKOMATIC_VARS['config']['gather_exclude_high'] = true;
    --    else
    --        TRACKOMATIC_VARS['config']['gather_exclude_high'] = false;
    --    end
    --    TrackOMatic_UpdateTracker(1);
    end
end

--==================================================
-- Handle changes in a SLIDER's value
--==================================================
function TrackOMatic_Config_OnSliderChanged(self, id)
    local newValue = 0;
    if (not self._onsetting) then
        self._onsetting = true;
        self:SetValue(self:GetValue());
        newValue = math.floor(self:GetValue());
        self._onsetting = false;
    else return end
    if (id == 1) then
        TrackOMatic_SetScale(newValue / 10);
        TrackOMatic_Config_UpdateSliderText(self, string.format(L["OPTION_SCALE"], (newValue * 10) .. "%"));
    elseif (id == 2) then
        local widthPercent = newValue; --(75 + (value * 5));
        TrackOMatic_SetWidth(widthPercent);
        TrackOMatic_Config_UpdateSliderText(self, string.format(L["OPTION_WIDTH"], widthPercent .. "%"));
    end
end

--========================================
-- Slider text update for value changes
--========================================
function TrackOMatic_Config_UpdateSliderText(slider, text)
    _G[slider:GetName() .. "Text1"]:SetText(text);
end

--========================================
-- Shows tip text at the bottom of the
-- config frame
--========================================
function TrackOMatic_Config_ShowTip(id)
    CURRENT_TIP = id or math.random(1, table.maxn(TIPS));
    TrackOMaticConfig_Tip:SetText("|cffffffff" .. L["TIP"] .. "|r " .. L["TIP_" .. TIPS[CURRENT_TIP]]);
end

--========================================
-- Handle clicking previous tip button
--========================================
function TrackOMatic_Config_PreviousTip()
    if (CURRENT_TIP > 1) then
        CURRENT_TIP = CURRENT_TIP - 1;
    else
        CURRENT_TIP = table.maxn(TIPS);
    end
    TrackOMatic_Config_ShowTip(CURRENT_TIP);
end

--========================================
-- Handle clicking previous tip button
--========================================
function TrackOMatic_Config_NextTip()
    if (CURRENT_TIP < table.maxn(TIPS)) then
        CURRENT_TIP = CURRENT_TIP + 1;
    else
        CURRENT_TIP = 1;
    end
    TrackOMatic_Config_ShowTip(CURRENT_TIP);
end

--========================================
-- Initialize texture selection dropdown
--========================================
function TrackOMatic_Config_InitTextureSelect()
    local textures = media:HashTable("statusbar");
    local tex2 = {};
    for name, path in pairs(textures) do
        table.insert(tex2, {name = name, path = path});
    end
    table.sort(tex2, function(a, b) return a.name < b.name; end);
    for index, data in pairs(tex2) do
        UIDropDownMenu_AddButton({text = data.name, value = data.name, func = function() TrackOMatic_Config_SetTexture(data.name); end});
    end
end

--========================================
-- Initialize Kills to Level Up
-- estimation method dropdown
--========================================
function TrackOMatic_Config_InitEstimationSelect()
    UIDropDownMenu_AddButton({text = L["ESTIMATION_MODE_SMART_AVERAGE"], value = 0, func = function() TrackOMatic_Config_SetEstimationMethod(0); end});
    UIDropDownMenu_AddButton({text = L["ESTIMATION_MODE_AVERAGE"], value = 1, func = function() TrackOMatic_Config_SetEstimationMethod(1); end});
    UIDropDownMenu_AddButton({text = L["ESTIMATION_MODE_LAST_KILL"], value = 2, func = function() TrackOMatic_Config_SetEstimationMethod(2); end});
end

--========================================
-- Initialize reputation display type
-- dropdown
--========================================
function TrackOMatic_Config_InitRepDisplaySelect()
    UIDropDownMenu_AddButton({text = L["OPTION_REP_GAIN_NONE"], value = 0, func = function() TrackOMatic_Config_SetRepDetail(0); end});
    UIDropDownMenu_AddButton({text = L["OPTION_REP_GAIN_PER_HOUR"], value = 1, func = function() TrackOMatic_Config_SetRepDetail(1); end});
    UIDropDownMenu_AddButton({text = L["OPTION_REP_GAIN_TIME_UNTIL_LEVEL"], value = 2, func = function() TrackOMatic_Config_SetRepDetail(2); end});
    UIDropDownMenu_AddButton({text = L["OPTION_REP_GAIN_TIME_UNTIL_EXALTED"], value = 3, func = function() TrackOMatic_Config_SetRepDetail(3); end});
end

--========================================
-- Dropdown button handler
--========================================
function TrackOMatic_Config_DropDown_OnClick(self)
    ToggleDropDownMenu(1, nil, self, self:GetName(), 0, 0);
end

--========================================
-- Texture change
--========================================
function TrackOMatic_Config_SetTexture(id)
    TRACKOMATIC_VARS['config']['texture'] = id;
    UIDropDownMenu_SetSelectedValue(TrackOMaticConfig_GeneralOptions_Texture, TRACKOMATIC_VARS['config']['texture']);
    TrackOMatic_BuildTracker();
end

--========================================
-- Change estimation method for Kills to
-- Level Up bar
--========================================
function TrackOMatic_Config_SetEstimationMethod(value)
    TRACKOMATIC_VARS['config']['mob_grind_estimation_mode'] = value;
    UIDropDownMenu_SetSelectedValue(TrackOMaticConfig_PlayerOptions_EstimationMethod, TRACKOMATIC_VARS['config']['mob_grind_estimation_mode']);
    TrackOMatic_UpdateTracker(1);
end

--========================================
-- OnEnter handler for options
--========================================
function TrackOMatic_Config_Option_OnEnter(self)
	if (self.tooltip) then
        GameTooltip:SetOwner(self, "ANCHOR_NONE");
        if (self.tooltipAbove) then
            GameTooltip:SetPoint("BOTTOMLEFT", self:GetName(), "TOPLEFT", -10, 4);
        else
            GameTooltip:SetPoint("TOPLEFT", self:GetName(), "BOTTOMLEFT", -10, -4);
        end
        GameTooltip:SetText(self.tooltip, 1, 1, 1);
        if (self.subTooltip) then
            GameTooltip:AddLine(self.subTooltip);
        end
        GameTooltip:Show();
	end
end

--========================================
-- Change reputation detail type
--========================================
function TrackOMatic_Config_SetRepDetail(id)
    TRACKOMATIC_VARS['config']['rep_gain_display'] = id;
    UIDropDownMenu_SetSelectedValue(TrackOMaticConfig_ReputationOptions_Display, TRACKOMATIC_VARS['config']['rep_gain_display']);
    TrackOMatic_UpdateTracker(1);
end
