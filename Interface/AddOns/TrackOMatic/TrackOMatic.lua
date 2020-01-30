local L = LibStub("AceLocale-3.0"):GetLocale("TrackOMatic", true);
local media = LibStub("LibSharedMedia-3.0");

TRACKOMATIC_CATEGORIES = {
    ["rep"] =       {
        title = L["HEADER_REPUTATION"],
        update = TrackOMatic_SetRepBar,
        remove = TrackOMatic_RemoveRep,
        getName = TrackOMatic_GetReputationBarTitle,
        suppressAlert = TrackOMatic_SuppressReputationAlert,
    },
    ["skill"] =     {
        title = L["HEADER_SKILLS"],
        update = TrackOMatic_SetSkillBar,
        remove = TrackOMatic_Skill_RemoveSkill,
        getName = TrackOMatic_GetSkillBarTitle,
        suppressAlert = TrackOMatic_SuppressSkillAlert,
    },
    ["misc"] =      {
        title = L["HEADER_MISC"],
        update = TrackOMatic_SetMiscBar,
        remove = TrackOMatic_RemoveMisc,
        getName = TrackOMatic_GetMiscLabel,
        suppressAlert = TrackOMatic_SuppressMiscInfoAlert,
    },
    ["player"] =    {
        title = L["HEADER_PLAYER"],
        update = TrackOMatic_SetPlayerBar,
        remove = TrackOMatic_RemovePlayer,
        getName = TrackOMatic_GetPlayerLabel,
        suppressAlert = TrackOMatic_SuppressPlayerInfoAlert,
    },
    ["item"] =      {
        title = L["HEADER_ITEMS"],
        update = TrackOMatic_SetItemBar,
        remove = TrackOMatic_RemoveItem,
        getName = TrackOMatic_GetItemBarTitle,
        suppressAlert = TrackOMatic_SuppressItemAlert,
    },
    ["pet"] =       {
        title = L["HEADER_PET"],
        update = TrackOMatic_HunterPet_SetBar,
        remove = TrackOMatic_HunterPet_RemoveBar,
        getName = TrackOMatic_HunterPet_GetLabel,
        suppressAlert = TrackOMatic_HunterPet_SuppressAlert,
    },
    ["plugin"] =    {
        title = L["HEADER_PLUGINS"],               
        update = TrackOMatic_SetPluginBar,      
        remove = TrackOMatic_RemovePlugin,              
        getName = TrackOMatic_GetPluginBarTitle,
        suppressAlert = TrackOMatic_SuppressPluginAlert,
    },
};

-- some basic settings
local TRACKER_CENTER_X = -1;
local NUM_BARS = 0;
local NUM_HEADERS = 0;
local MAX_BARS_PER_CATEGORY = 20;
local TRACKER_BUILT = false;

TRACKOMATIC_VARS = {};

local CLEARING_CATEGORY = "";
local GLOW_VALUE = 20;
local GLOW_DIR = 1;
local GLOWING_BARS = {};
local UPDATE_TIMER = 0;
local UPDATE_INTERVAL = 0.5;
local lastCriteriaUpdate = 0;
local LAST_UPDATE_ELAPSED = 0;
local IS_READY = false;
local HOOKS = {};
local _T;
local QUEUE_UPDATE_ON_DEMAND = false;
local JUST_UPDATED = false;
local LAST_UPDATE_ON_DEMAND = 0;
local UPDATE_INTERVALS = {
    [0] = 1,
    [1] = 0.5,
    [2] = 0.25,
    [3] = 0.1,
    [4] = 0.05,
};

StaticPopupDialogs["TRACKOMATIC_CATEGORY_FULL"] = {
    text = L["MESSAGE_CATEGORY_FULL"],
    button1 = OKAY,
    timeout = 0,
    hideOnEscape = 1,
    whileDead = 1,
};

StaticPopupDialogs["TRACKOMATIC_ALREADY_TRACKED"] = {
    text = L["MESSAGE_ALREADY_TRACKED"],
    button1 = OKAY,
    timeout = 0,
    hideOnEscape = 1,
    whileDead = 1,
};

StaticPopupDialogs["TRACKOMATIC_INVALID_GOAL"] = {
    text = L["MESSAGE_INVALID_GOAL"],
    button1 = OKAY,
    timeout = 0,
    hideOnEscape = 1,
    showAlert = 1,
    whileDead = 1,
};

StaticPopupDialogs["TRACKOMATIC_CONFIRM_CLEAR_CATEGORY"] = {
    text = L["CONFIRM_CLEAR_CATEGORY"],
    button1 = YES,
    button2 = NO,
    OnAccept = function(self) TrackOMatic_AcceptCategoryClear(); end,
    timeout = 0,
    hideOnEscape = 1,
    whileDead = 1,
};

StaticPopupDialogs["TRACKOMATIC_CONFIRM_CLEAR_ALL"] = {
    text = L["CONFIRM_CLEAR_ALL"],
    button1 = YES,
    button2 = NO,
    OnAccept = function(self) TrackOMatic_AcceptTrackerClear(); end,
    timeout = 0,
    hideOnEscape = 1,
    whileDead = 1,
};

StaticPopupDialogs["TRACKOMATIC_CONFIRM_DELETE_TEMPLATE"] = {
    text = L["CONFIRM_DELETE_TEMPLATE"],
    button1 = YES,
    button2 = NO,
    OnAccept = function(self) TrackOMatic_DeleteTemplate(TrackOMatic.TEMPLATE_TO_DELETE); end,
    timeout = 0,
    hideOnEscape = 1,
    whileDead = 1,
};

StaticPopupDialogs["TRACKOMATIC_CONFIRM_SAVE_TEMPLATE"] = {
    text = L["CONFIRM_SAVE_TEMPLATE"],
    button1 = YES,
    button2 = NO,
    OnAccept = function(self) TrackOMatic_SaveTemplateAs(TrackOMatic.TEMPLATE_TO_SAVE); end,
    timeout = 0,
    hideOnEscape = 1,
    whileDead = 1,
};

StaticPopupDialogs["TRACKOMATIC_CONFIRM_LOAD_TEMPLATE"] = {
    text = L["CONFIRM_LOAD_TEMPLATE"],
    button1 = YES,
    button2 = NO,
    OnAccept = function(self) TrackOMatic_LoadTemplate(TrackOMatic.TEMPLATE_TO_LOAD); end,
    timeout = 0,
    hideOnEscape = 1,
    whileDead = 1,
};

StaticPopupDialogs["TRACKOMATIC_CREATE_NEW_TEMPLATE"] = {
    text = L["ENTER_TEMPLATE_NAME"],
    hasEditBox = true,
    button1 = ACCEPT,
    button2 = CANCEL,
    OnAccept = function(self) TrackOMatic_SaveTemplateAs(self.editBox:GetText()); end,
    timeout = 0,
    hideOnEscape = 1,
    whileDead = 1,
};

StaticPopupDialogs["TRACKOMATIC_TRACK_ITEM"] = {
    text = L["TRACK_ITEM_PROMPT"],
    button1 = OKAY,
    timeout = 0,
    hideOnEscape = 1,
    whileDead = 1,
};

--========================================
-- Initial load routine
--========================================
function TrackOMatic_OnLoad(self)
    self.Version = GetAddOnMetadata("TrackOMatic", "Version");
    self.VersionID = 10101;
    self.PluginCompatibility = 0x89f;
    self.IsBeingDragged = false;
    self.AutoHide = false;
    self.Profile = "";
    self.SessionStart = GetTime();
    self.AutoUpdateEnabled = true;
    self.ItemLinkCache = {};
    self.DebugMode = {
        Enabled = false,
        ColorTest = false,
    };
    self.Plugins = {};
    self.BadPlugins = {};
    self.StartingGold = 0;

    --self.registry = {
    --    id = "TrackOMatic",
    --    builtIn = 1,
    --    version = TrackOMatic.Version,
    --    menuText = L["ADDON_TITLE"],
    --    tooltipTitle = "Track-O-Matic Tooltip title";
    --    tooltipTextFunction = "TrackOMatic_TEST",
    --    buttonTextFunction = "TrackOMatic_TEST",
    --};
    
    -- register events
    self:RegisterEvent("ADDON_LOADED");

    self:RegisterEvent("UPDATE_EXHAUSTION");                -- player -> xp             updates as player rests, enters/leaves rested state
    self:RegisterEvent("PLAYER_XP_UPDATE");                 -- player -> xp             updates xp/grind
    self:RegisterEvent("CHAT_MSG_COMBAT_XP_GAIN");          -- player -> xp/grind       updates when gaining xp
    self:RegisterEvent("PLAYER_LEVEL_UP");                  -- player -> xp/grind       updates when leveling up
    self:RegisterEvent("CHAT_MSG_SYSTEM");                  -- player -> grind          updates on quest completion
    self:RegisterEvent("PLAYER_MONEY");                     -- player -> gold           updates on gold gain/loss
    self:RegisterEvent("CHAT_MSG_COMBAT_HONOR_GAIN");       -- player -> honor          updates when awarded honor and on honorable kills
    self:RegisterEvent("PLAYER_PVP_KILLS_CHANGED");         -- player -> honor          updates estimated honor
    self:RegisterEvent("PLAYER_PVP_RANK_CHANGED");          -- player -> honor          updates estimated honor
    self:RegisterEvent("CHAT_MSG_SKILL");                   -- skill                    updates on skill increase
    self:RegisterEvent("LEARNED_SPELL_IN_TAB");             -- skill                    updates when learning new profession rank
    self:RegisterEvent("SKILL_LINES_CHANGED");              -- skill                    helps update when there's a change in professions
    self:RegisterEvent("SPELLS_CHANGED");                   -- skill                    ^
    self:RegisterEvent("UPDATE_FACTION");                   -- reputation               updates reputation
    --self:RegisterEvent("CURRENCY_DISPLAY_UPDATE");          -- currency                 updates currency
    --self:RegisterEvent("CRITERIA_UPDATE");                  -- achievements
    --self:RegisterEvent("TRACKED_ACHIEVEMENT_UPDATE");       -- achievements
    self:RegisterEvent("PLAYER_ENTERING_WORLD");

    media:Register("statusbar", "BantoBar", "Interface\\AddOns\\TrackOMatic\\textures\\BantoBar");
    media:Register("statusbar", "Frost", "Interface\\AddOns\\TrackOMatic\\textures\\Frost");
    media:Register("statusbar", "Healbot", "Interface\\AddOns\\TrackOMatic\\textures\\HealBot");
    media:Register("statusbar", "LiteStep", "Interface\\AddOns\\TrackOMatic\\textures\\LiteStep");
    media:Register("statusbar", "Minimalist", "Interface\\AddOns\\TrackOMatic\\textures\\Minimalist");
    media:Register("statusbar", "Rocks", "Interface\\AddOns\\TrackOMatic\\textures\\Rocks");
    media:Register("statusbar", "Runes", "Interface\\AddOns\\TrackOMatic\\textures\\Runes");
    media:Register("statusbar", "Xeon", "Interface\\AddOns\\TrackOMatic\\textures\\Xeon");

    hooksecurefunc("ContainerFrameItemButton_OnModifiedClick", TrackOMatic_OnItemClick);
    --TrackOMatic_HookAchievementFrame();

    SLASH_TRACKOMATIC1 = "/tom";
    SlashCmdList["TRACKOMATIC"] = TrackOMatic_CommandHandler;

    -- modify the reputation and currency detail frames to fit the new buttons
    TrackOMatic_HookReputationDetailFrame()
    --TokenFramePopup:SetHeight(130);

    LoadAddOn("TrackOMatic_PluginDebugConsole");
    
end

--========================================
-- Event triggers
--========================================
function TrackOMatic_OnEvent(self, event, ...)

    local arg1 = ...;

    if (event == "ADDON_LOADED") then
        if (arg1 == "TrackOMatic") then
            TrackOMatic_Setup();
        elseif (arg1 == "Blizzard_AchievementUI") then
            TrackOMatic_HookAchievementFrame();
        end
    elseif (event == "CHAT_MSG_COMBAT_XP_GAIN") then
        TrackOMatic_UpdateGrindInfo(arg1);
    elseif (event == "CHAT_MSG_SYSTEM") then
        TrackOMatic_UpdateQuestInfo(arg1);
    elseif (event == "PLAYER_LEVEL_UP") then
        TRACKOMATIC_GRIND['mobs_killed'] = 0;
        TRACKOMATIC_GRIND['avg_units'] = 1;
        TRACKOMATIC_GRIND['xp_gained'] = TRACKOMATIC_GRIND['xp_per_kill'];
        TRACKOMATIC_GRIND['mobs_remaining'] = math.ceil((UnitXPMax("player") - UnitXP("player")) / TRACKOMATIC_GRIND['xp_per_kill']);
        TRACKOMATIC_QUEST['quests_completed'] = 0;
        TRACKOMATIC_QUEST['avg_units'] = 1;
        TRACKOMATIC_QUEST['xp_gained'] = TRACKOMATIC_QUEST['xp_per_quest'];
        if (TRACKOMATIC_QUEST['xp_per_quest'] > 0) then
            TRACKOMATIC_QUEST['quests_remaining'] = math.ceil((UnitXPMax("player") - UnitXP("player")) / TRACKOMATIC_QUEST['xp_per_quest']);
        end
    elseif (event == "PLAYER_ENTERING_WORLD") then
        TrackOMatic_PostSetup();
        QUEUE_UPDATE_ON_DEMAND = true;
    elseif ((event == "LEARNED_SPELL_IN_TAB") or (event == "SKILL_LINES_CHANGED") or (event == "SPELLS_CHANGED")) then
        --TrackOMatic_UpdateProfessions();
    else
        -- assume the event triggers tracker updating
        QUEUE_UPDATE_ON_DEMAND = true;
    end
    
    TrackOMatic_Plugin_OnEvent(event, ...);

end

--========================================
-- Basic update routine
--========================================
function TrackOMatic_OnUpdate(self, elapsed)

    if (QUEUE_UPDATE_ON_DEMAND and (not JUST_UPDATED) and ((GetTime() - LAST_UPDATE_ON_DEMAND) > 0.2)) then
        LAST_UPDATE_ON_DEMAND = GetTime();
        TrackOMatic_UpdateTracker(1);
    elseif (TrackOMatic.AutoUpdateEnabled == true) then
        UPDATE_TIMER = UPDATE_TIMER - elapsed;
        if (UPDATE_TIMER <= 0) then
            UPDATE_TIMER = UPDATE_INTERVAL;
            TrackOMatic_UpdateTracker(1);
        end
    end
    
    QUEUE_UPDATE_ON_DEMAND = false;
    JUST_UPDATED = false;

    TrackOMatic_UpdateGlow(elapsed);
    
    if (TrackOMatic.AutoHide) then
        local mx, my = GetCursorPosition();
        mx = mx / UIParent:GetScale();
        my = my / UIParent:GetScale();
        local tx, ty, tw, th = TrackOMatic:GetRect();
        
        local alpha = self:GetAlpha();
        local fadespeed = (elapsed * 3);
        if (((mx >= tx) and (mx < tx + tw) and (my >= ty) and (my < ty + th)) or TrackOMatic.IsBeingDragged) then
            if (alpha < 1) then
                self:SetAlpha(math.min(1, alpha + fadespeed));
            end
        else
            if (alpha > 0) then
                self:SetAlpha(math.max(0, alpha - fadespeed));
            end
        end
    end

end

--========================================
-- Main setup routine
--========================================
function TrackOMatic_Setup()

    TrackOMatic.Profile = GetRealmName() .. "." .. UnitName("player");

    TrackOMatic_LoadSettings();

    -- set up text strings
    TrackOMatic_AddReputationButton:SetText(L["BUTTON_ADD"]);
    TrackOMatic_AddSkillButton:SetText(L["BUTTON_ADD"]);
    --TrackOMatic_AddCurrencyButton:SetText(L["BUTTON_ADD"]);
    --PrimaryProfession1TrackButton:SetText(L["BUTTON_ADD"]);
    --PrimaryProfession2TrackButton:SetText(L["BUTTON_ADD"]);

    TrackOMatic_GoalInputPrompt:SetText(L["ENTER_GOAL_PROMPT"]);
    TrackOMatic_GoalInputItemText:SetText("");
    TrackOMatic_GoalInputOKButton:SetText(L["BUTTON_OK"]);

    -- lock/unlock the tracker based on setting from last session
    if (TRACKOMATIC_VARS[TrackOMatic.Profile]['locked']) then
        TrackOMatic:EnableMouse(0);
    else
        TrackOMatic:EnableMouse(1);
    end
    if (TRACKOMATIC_VARS[TrackOMatic.Profile]['visible']) then
        TrackOMatic:Show();
    else
        TrackOMatic:Hide();
    end

    TrackOMatic_InitMainMenu();

    TrackOMatic_SetScale(TRACKOMATIC_VARS[TrackOMatic.Profile]['scale']);

    TrackOMatic_SetupGlowRuleInput();

    TrackOMatic_InitializeModules();
end

function TrackOMatic_PostSetup()
    if (IS_READY) then return; end
    IS_READY = true;
    if (TRACKOMATIC_VARS['config']['show_load_message']) then
        TrackOMatic_Message(string.format(L["LOADED_MESSAGE"], TrackOMatic.Version));
        local pluginCount = TrackOMatic_GetNumRegisteredPlugins();
        if (pluginCount > 0) then
            TrackOMatic_Message(string.format(L["PLUGINS_REGISTERED"], pluginCount));
        end
        local badPluginCount = TrackOMatic_GetNumFailedPlugins();
        if (badPluginCount > 0) then
            TrackOMatic_Message("|cffff0000" .. string.format(L["PLUGINS_REG_FAILED"], badPluginCount));
        end
    end
    TrackOMatic_Startup();
end

--========================================
-- Set up defaults for specified profile
--========================================
function TrackOMatic_LoadSettings()

    local version = (tonumber(TrackOMatic_CheckSetting("version", TrackOMatic.VersionID)) or 0);
    if (version < TrackOMatic.VersionID) then
        --TrackOMatic_Upgrade_10005(version);
        --TrackOMatic_Upgrade_10404(version);
        --TrackOMatic_Upgrade_10800(version);
        --TrackOMatic_Upgrade_11000(version);
    end
    TRACKOMATIC_VARS['config']['version'] = TrackOMatic.VersionID;
    TrackOMatic_CheckSetting("texture", "Minimalist");
    TrackOMatic_CheckSetting("gold_glow_negative", true);
    TrackOMatic_CheckSetting("show_lowest_durability", false);
    TrackOMatic_CheckSetting("item_default_glow", true);
    TrackOMatic_CheckSetting("item_custom_glow", true);
    TrackOMatic_CheckSetting("advanced_gather_tooltips", true);
    TrackOMatic_CheckSetting("profession_glow", true);
    TrackOMatic_CheckSetting("gather_exclude_low", true);
    TrackOMatic_CheckSetting("gather_exclude_high", true);
    TrackOMatic_CheckSetting("durability_glow_broken", true);
    TrackOMatic_CheckSetting("rep_gain_display", 1);
    TrackOMatic_CheckSetting("reverse_leveling_bars", false);
    TrackOMatic_CheckSetting("show_load_message", false);
    TrackOMatic_CheckSetting("mob_grind_estimation_mode", 0);
    TrackOMatic_CheckSetting("show_alert_boxes", true);
    local upd = TrackOMatic_CheckSetting("update_interval", 1);

    TrackOMatic_CheckProfileSetting("width", 75);
    TrackOMatic_CheckProfileSetting("enable_glows", true);
    TrackOMatic_CheckProfileSetting("locked", false);
    TrackOMatic_CheckProfileSetting("visible", true);
    TrackOMatic_CheckProfileSetting("mouseover_autohide", false);
    TrackOMatic_CheckProfileSetting("growth", 0);
    TrackOMatic_CheckProfileSetting("scale", 1);
    TrackOMatic_CheckProfileSetting("show_quantity_items", true);
    TrackOMatic_CheckProfileSetting("show_quantity_currency", true);
    TrackOMatic_CheckProfileSetting("show_percent_items", true);
    TrackOMatic_CheckProfileSetting("show_percent_currency", true);
    TrackOMatic_CheckProfileSetting("hide_category_headers", false);
    
    if ((upd < 0) or (upd > 4)) then
        TRACKOMATIC_VARS['config']['update_interval'] = 1;
    end
    UPDATE_INTERVAL = UPDATE_INTERVALS[TRACKOMATIC_VARS['config']['update_interval']];

    if (not TRACKOMATIC_VARS['templates']) then
        TRACKOMATIC_VARS['templates'] = {};
    end
    
    -- initialize category table and fields
    if ((not TRACKOMATIC_VARS[TrackOMatic.Profile]['categories']) or (forceifset)) then
        TRACKOMATIC_VARS[TrackOMatic.Profile]['categories'] = {};
        
        local defTplId = TrackOMatic_GetDefaultTemplate();
        if (defTplId) then
            TrackOMatic_LoadTemplate(defTplId);
        end
    end
    table.sort(TRACKOMATIC_CATEGORIES, function(a, b) return a.title < b.title; end);
    for id, info in pairs(TRACKOMATIC_CATEGORIES) do
        if (not TRACKOMATIC_VARS[TrackOMatic.Profile]['categories'][id]) then
            TRACKOMATIC_VARS[TrackOMatic.Profile]['categories'][id] = {
                collapsed = false,
                entries = {},
            };
        end
    end
    -- initialize saved plugin data table
    if (not TRACKOMATIC_VARS[TrackOMatic.Profile]['plugin_data']) then
        TRACKOMATIC_VARS[TrackOMatic.Profile]['plugin_data'] = {};
    end
    
    TrackOMatic.AutoHide = TRACKOMATIC_VARS[TrackOMatic.Profile]['mouseover_autohide'];
    if (TrackOMatic.AutoHide) then
        TrackOMatic:SetAlpha(0);
    end

end

--========================================
-- Check configuration setting, and
-- initialize with default value if not
-- present
--========================================
function TrackOMatic_CheckSetting(field, defaultValue)

    -- make sure the config array is present
    if (not TRACKOMATIC_VARS['config']) then
	    TRACKOMATIC_VARS['config'] = {};
	end

	if (TRACKOMATIC_VARS['config'][field] == nil) then
	    TRACKOMATIC_VARS['config'][field] = defaultValue;
	end
    return TRACKOMATIC_VARS['config'][field];
end

--========================================
-- Check character-specific setting, and
-- initialize with default value if not
-- present
--========================================
function TrackOMatic_CheckProfileSetting(field, defaultValue)

    -- make sure the config array is present
    if (not TRACKOMATIC_VARS[TrackOMatic.Profile]) then
	    TRACKOMATIC_VARS[TrackOMatic.Profile] = {};
	end

	if (TRACKOMATIC_VARS[TrackOMatic.Profile][field] == nil) then
	    TRACKOMATIC_VARS[TrackOMatic.Profile][field] = defaultValue;
	end
    return TRACKOMATIC_VARS[TrackOMatic.Profile][field];
end

--========================================
-- Complete reset
--========================================
function TrackOMatic_Reset()

    TRACKOMATIC_VARS[TrackOMatic.Profile] = {};
    TrackOMatic_LoadSettings();
    TrackOMatic_BuildTracker();
    TrackOMatic:EnableMouse(1);

end

--========================================
-- Lock the tracker in place
--========================================
function TrackOMatic_LockWindow(isSilent)

    if (not TRACKOMATIC_VARS[TrackOMatic.Profile]['locked']) then
        TrackOMatic:EnableMouse(0);
        TRACKOMATIC_VARS[TrackOMatic.Profile]['locked'] = true;
        if (not isSilent) then
            TrackOMatic_Message(L["MESSAGE_POSITION_LOCKED"]);
        end
        TrackOMatic_BuildTracker();
    end

end

--========================================
-- Unlock the tracker's position
--========================================
function TrackOMatic_UnlockWindow(isSilent)

    if (TRACKOMATIC_VARS[TrackOMatic.Profile]['locked']) then
        TrackOMatic:EnableMouse(1);
        TRACKOMATIC_VARS[TrackOMatic.Profile]['locked'] = false;
        if (not isSilent) then
            TrackOMatic_Message(L["MESSAGE_POSITION_UNLOCKED"]);
        end
        TrackOMatic_BuildTracker();
    end

end

--========================================
-- Set the tracker's visible state
--========================================
function TrackOMatic_SetVisible(visible, isSilent)
    if (visible) then
        TRACKOMATIC_VARS[TrackOMatic.Profile]['visible'] = true;
        TrackOMatic:Show();
        if (not isSilent) then
            TrackOMatic_Message(L["MESSAGE_TRACKER_SHOWN"]);
        end
    else
        TRACKOMATIC_VARS[TrackOMatic.Profile]['visible'] = false;
        TrackOMatic:Hide();
        if (not isSilent) then
            TrackOMatic_Message(L["MESSAGE_TRACKER_HIDDEN"]);
        end
    end
end

--========================================
-- Enable/disable the mouseover autohide
-- functionality
--========================================
function TrackOMatic_SetAutoHide(value)
    if (value) then
        TRACKOMATIC_VARS[TrackOMatic.Profile]['mouseover_autohide'] = true;
        TrackOMatic.AutoHide = true;
        TrackOMatic_Message(L["MESSAGE_AUTOHIDE_ENABLED"]);
    else
        TRACKOMATIC_VARS[TrackOMatic.Profile]['mouseover_autohide'] = false;
        TrackOMatic.AutoHide = false;
        TrackOMatic:SetAlpha(1);
        TrackOMatic_Message(L["MESSAGE_AUTOHIDE_DISABLED"]);
    end
end

--========================================
-- Set the tracker's scale
--========================================
function TrackOMatic_SetScale(value)
    value = math.max(70, math.min(150, (value * 100))) / 100;
    TRACKOMATIC_VARS[TrackOMatic.Profile]['scale'] = value;
    TrackOMatic:SetScale(value);
    CloseDropDownMenus();
end

--========================================
-- Set the tracker's width
--========================================
function TrackOMatic_SetWidth(value)
    value = math.max(75, math.min(125, value));
    TRACKOMATIC_VARS[TrackOMatic.Profile]['width'] = value;
    TrackOMatic_BuildTracker();
end

--========================================
-- Update the tracker
--========================================
function TrackOMatic_UpdateTracker(force, srcEvent)

    -- if the addon isn't ready, do nothing
    if (not IS_READY) then
        return;
    end

    if (force == nil) then force = 0; end
    
    if (force == 0) then
        QUEUE_UPDATE_ON_DEMAND = true;
        return;
    end

    local startTime = debugprofilestop();
    
    UPDATE_TIMER = UPDATE_INTERVAL;     -- reset the auto update interval timer

    GLOWING_BARS = {};

    if (not TRACKER_BUILT) then
        TrackOMatic_BuildTracker();
    end

    local bar;

    if (NUM_BARS > 0) then
        for i = 1, NUM_BARS, 1 do
            bar = _G["TrackOMatic_Bar" .. i];
            -- don't auto-update achievement bars; too much slow-down
            if ((bar.cat ~= "ach") or (force > 0)) then
            
                --if (bar.cat == "ach") then TrackOMatic_Message("bar.cat: " .. bar.cat .. " / srcEvent: " .. (srcEvent or "<none>") .. " / force: " .. tostring(force or 0)); end
                    
                if (bar.data and TRACKOMATIC_CATEGORIES[bar.cat]) then
                    TrackOMatic_UpdateBar(TRACKOMATIC_CATEGORIES[bar.cat].update, bar, bar.data);
                end
            end
        end
    end

    local endTime = debugprofilestop();
    LAST_UPDATE_ELAPSED = endTime - startTime;
    if (TrackOMatic.DebugMode.Enabled) then
        TrackOMatic_Header1Label:SetText("|cff00ff00Upd " .. string.format("%.5f", LAST_UPDATE_ELAPSED) .. " ms");
    end
    
    JUST_UPDATED = true;
end

--========================================
-- Rebuild tracker window, when a bar is
-- added or removed, or a category is
-- expanded or collapsed.
--========================================
function TrackOMatic_BuildTracker()

    local catFrame;
    local bar;
    local barIndex = 1;
    local catIndex = 1;
    local lastRow;
    local trackerWidth = 310 * (TRACKOMATIC_VARS[TrackOMatic.Profile]['width'] / 100);

    GLOWING_BARS = {};

    TrackOMatic:SetWidth(trackerWidth);

    if (NUM_BARS > 0) then
        for i = 1, NUM_BARS, 1 do
            _G["TrackOMatic_Bar" .. i]:Hide();
        end
    end
    if (NUM_HEADERS > 0) then
        for i = 1, NUM_HEADERS, 1 do
            _G["TrackOMatic_Header" .. i]:Hide();
        end
    end

    table.sort(TRACKOMATIC_VARS[TrackOMatic.Profile]['categories'], function(a, b) return a.order < b.order; end);

    local catOrder = TrackOMatic_GetCategoryOrder();

    local barsToShow = 0;
    for index, id in pairs(catOrder) do
        barsToShow = barsToShow + table.maxn(TRACKOMATIC_VARS[TrackOMatic.Profile]['categories'][id].entries or {});
    end

    -- set up the default "Track-O-Matic" header (when there's no bars being tracked or if category headers are turned off)
    catIndex = 1;
    if (not _G["TrackOMatic_Header" .. catIndex]) then
        catFrame = CreateFrame("Frame", "TrackOMatic_Header" .. catIndex, TrackOMatic, "TrackOMatic_HeaderTemplate");
    else
        catFrame = _G["TrackOMatic_Header" .. catIndex];
    end
    catFrame:SetPoint("TOPLEFT", TrackOMatic, "TOPLEFT", 0, 0);
    catFrame:SetWidth(trackerWidth);
    catFrame:Show();
    catFrame.cat = "";
    catFrame.id = catIndex;
    catFrame.toggle = TrackOMatic_ToggleUngroupedCategories;
    TrackOMatic_SetupHeader(catFrame, L["ADDON_TITLE"], TRACKOMATIC_VARS[TrackOMatic.Profile]['categories'].collapseAll, (barsToShow > 0), true);

    NUM_HEADERS = 1;
    lastRow = "TrackOMatic_Header" .. catIndex;

    NUM_BARS = 0;
    if ((not TRACKOMATIC_VARS[TrackOMatic.Profile]['hide_category_headers']) or (not TRACKOMATIC_VARS[TrackOMatic.Profile]['categories'].collapseAll)) then
        for index, id in pairs(catOrder) do
            local info = TRACKOMATIC_CATEGORIES[id];
            if (TRACKOMATIC_VARS[TrackOMatic.Profile]['categories'][id]) then
                if (table.maxn(TRACKOMATIC_VARS[TrackOMatic.Profile]['categories'][id].entries) > 0) then
                    if (not TRACKOMATIC_VARS[TrackOMatic.Profile]['hide_category_headers']) then
                        if (not _G["TrackOMatic_Header" .. catIndex]) then
                            catFrame = CreateFrame("Frame", "TrackOMatic_Header" .. catIndex, TrackOMatic, "TrackOMatic_HeaderTemplate");
                        else
                            catFrame = _G["TrackOMatic_Header" .. catIndex];
                        end

                        TrackOMatic_SetupHeader(catFrame, info.title, TRACKOMATIC_VARS[TrackOMatic.Profile]['categories'][id].collapsed, true, (catIndex == 1));

                        if (catIndex > 1) then
                            catFrame:SetPoint("TOP", lastRow, "BOTTOM", 0, 0);
                        else
                            catFrame:SetPoint("TOPLEFT", TrackOMatic, "TOPLEFT", 0, 0);
                        end
                        catFrame:Show();
                        catFrame:SetWidth(trackerWidth);
                        catFrame.cat = id;
                        catFrame.id = catIndex;
                        catFrame.toggle = TrackOMatic_ToggleCategory;

                        lastRow = "TrackOMatic_Header" .. catIndex;
                        NUM_HEADERS = catIndex;
                        catIndex = catIndex + 1;
                    end

                    local collapsed = false;
                    if (not TRACKOMATIC_VARS[TrackOMatic.Profile]['hide_category_headers']) then
                        collapsed = TRACKOMATIC_VARS[TrackOMatic.Profile]['categories'][id].collapsed;
                    end

                    if (not collapsed) then
                        for index, data in pairs(TRACKOMATIC_VARS[TrackOMatic.Profile]['categories'][id].entries) do
                            if (not _G["TrackOMatic_Bar" .. barIndex]) then
                                bar = CreateFrame("StatusBar", "TrackOMatic_Bar" .. barIndex, TrackOMatic, "TrackOMatic_BarTemplate");
                            else
                                bar = _G["TrackOMatic_Bar" .. barIndex];
                            end
                            bar:Show();
                            bar:SetPoint("TOP", lastRow, "BOTTOM", 0, 0);
                            bar:SetWidth(trackerWidth);
                            local tex = media:Fetch("statusbar", TRACKOMATIC_VARS['config']['texture']);
                            bar:SetStatusBarTexture(tex);
                            _G[bar:GetName() .. "Background"]:SetTexture(tex);
                            bar.cat = id;
                            bar.data = data;
                            bar.index = index;
                            bar.menu = {};
                            bar.click = nil;
                            TrackOMatic_UpdateBar(info.update, bar, data);
                            lastRow = "TrackOMatic_Bar" .. barIndex;
                            barIndex = barIndex + 1;
                            NUM_BARS = NUM_BARS + 1;
                        end
                    end
                end
            end
        end
    end

    TrackOMatic:SetHeight((NUM_HEADERS + NUM_BARS) * 15);

    TRACKER_BUILT = true;
    TrackOMatic_UpdateTracker(2);

    CloseDropDownMenus();

end

--========================================
-- Set up a category header bar
--========================================
function TrackOMatic_SetupHeader(header, label, isCollapsed, allowCollapse, showOptions)
    local hdrClick = _G[header:GetName() .. "Click"];
    local hdrLabel = _G[header:GetName() .. "Label"];
    local collapseButton = _G[header:GetName() .. "CollapseButton"];
    local expandButton = _G[header:GetName() .. "ExpandButton"];
    local lockButton = _G[header:GetName() .. "LockButton"];
    local unlockButton = _G[header:GetName() .. "UnlockButton"]; 
    local menuButton = _G[header:GetName() .. "TrackButton"]; 
    local hideButton = _G[header:GetName() .. "HideButton"];
    hdrClick:ClearAllPoints();
    hdrClick:RegisterForDrag("LeftButton");
    hdrLabel:SetText(label);
    hdrLabel:ClearAllPoints();

    if (allowCollapse) then
        if (isCollapsed) then
            collapseButton:Hide();
            expandButton:Show();
        else
            collapseButton:Show();
            expandButton:Hide();
        end
        hdrClick:SetPoint("TOPLEFT", header, "TOPLEFT", 15, 0);
        hdrLabel:SetPoint("TOPLEFT", header, "TOPLEFT", 20, -3);
    else
        collapseButton:Hide();
        expandButton:Hide();
        hdrClick:SetPoint("TOPLEFT", header, "TOPLEFT", 0, 0);
        hdrLabel:SetPoint("TOPLEFT", header, "TOPLEFT", 5, -3);
    end

    if (showOptions) then
        if (TRACKOMATIC_VARS[TrackOMatic.Profile]['locked']) then
            lockButton:Hide();
            unlockButton:Show();
        else
            lockButton:Show();
            unlockButton:Hide();
        end
        menuButton:Show();
        hideButton:Show();
        lockButton.tooltip = L["TOOLTIP_LOCK_TRACKER"];
        unlockButton.tooltip = L["TOOLTIP_UNLOCK_TRACKER"];
        menuButton.tooltip = L["TOOLTIP_OPTIONS_BUTTON"];
        hideButton.tooltip = L["TOOLTIP_HIDE_BUTTON"];
        hdrClick:SetPoint("BOTTOMRIGHT", header, "BOTTOMRIGHT", -45, 0);
    else
        lockButton:Hide();
        unlockButton:Hide();
        menuButton:Hide();
        hideButton:Hide();
        hdrClick:SetPoint("BOTTOMRIGHT", header, "BOTTOMRIGHT", 0, 0);
    end
end

--========================================
-- Header click handler
--========================================
function TrackOMatic_HeaderClick(header, button)
    if ((button == "RightButton") and (NUM_BARS > 0) and (not TRACKOMATIC_VARS[TrackOMatic.Profile]['hide_category_headers'])) then
        local menu = {{ text = TRACKOMATIC_CATEGORIES[header.cat].title, isTitle = true, notCheckable = true }};
        if (header.id > 1) then
            table.insert(menu, {text = L["BARMENU_MOVE_UP"], notCheckable = true, func = function() TrackOMatic_MoveCategoryUp(header.cat); end});
        end
        if (header.id < NUM_HEADERS) then
            table.insert(menu, {text = L["BARMENU_MOVE_DOWN"], notCheckable = true, func = function() TrackOMatic_MoveCategoryDown(header.cat); end});
        end
        table.insert(menu, { text = L["BARMENU_REMOVE"], notCheckable = true, func = function() TrackOMatic_ClearCategory(header.cat); end });
        EasyMenu(menu, TrackOMatic_TrackerMenu, _G[header:GetName() .. "MenuAnchor"], 0, 0, "MENU", 1);
    end
end

--========================================
-- Bar click handler
--========================================
function TrackOMatic_BarClick(bar, button)
    if (IsShiftKeyDown() and IsControlKeyDown()) then
        TrackOMatic_RemoveEntry(bar.cat, bar.index);
    else
        if (button == "RightButton") then
            local menu = {{ text = (bar.menuTitle or L["UNDEFINED"]), isTitle = true, notCheckable = true }};
            if (bar.menu) then
                for index, data in pairs(bar.menu) do
                    table.insert(menu, data);
                end
            end
            if (TrackOMatic_EntryCanMoveUp(bar.cat, bar.index)) then
                table.insert(menu, { text = L["BARMENU_MOVE_UP"], notCheckable = true, func = function() TrackOMatic_MoveEntryUp(bar.cat, bar.index); end });
            end
            if (TrackOMatic_EntryCanMoveDown(bar.cat, bar.index)) then
                table.insert(menu, { text = L["BARMENU_MOVE_DOWN"], notCheckable = true, func = function() TrackOMatic_MoveEntryDown(bar.cat, bar.index); end });
            end
            table.insert(menu, { text = L["BARMENU_REMOVE"], notCheckable = true, func = function() TrackOMatic_RemoveEntry(bar.cat, bar.index); end });
            EasyMenu(menu, TrackOMatic_TrackerMenu, _G[bar:GetName() .. "MenuAnchor"], 0, 0, "MENU", 1);
        else
            if (bar.click) then
                bar.click();
            end
        end
    end
end

--========================================
-- Set a bar's tooltip
--========================================
function TrackOMatic_SetBarTooltip(self)

    if (self.tooltip) then
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
        GameTooltip:SetText(self.tooltip, 1, 1, 1);
        if (self.subtip ~= "") then
            GameTooltip:AddLine(self.subtip);
        end
        GameTooltip:Show();
    end

end

--========================================
-- Remove a bar from the tracker
--========================================
function TrackOMatic_RemoveEntry(category, id)
    if (TRACKOMATIC_CATEGORIES[category]) then
        local ok, err = pcall(TRACKOMATIC_CATEGORIES[category].remove, id);
        if (not ok) then
            TrackOMatic_Message(L["ERROR_REMOVING_BAR"]);
            -- todo: error logging
        end
    end
end

--========================================
-- Retrieve the data for the specified
-- bar
--========================================
function TrackOMatic_GetData(category, id)
    return (TRACKOMATIC_VARS[TrackOMatic.Profile]['categories'][category].entries[id] or nil);
end

--========================================
-- Update a bar's texture
--========================================
function TrackOMatic_UpdateStatusBarTexture(bar)

    local barValue = bar:GetValue();
    local barMin, barMax = bar:GetMinMaxValues();

    bar:GetStatusBarTexture():SetTexCoord(0, barValue / math.max(1, barMax), 0, 1);

end

--========================================
-- Outputs status message to chat window
--========================================
function TrackOMatic_Message(text)
    DEFAULT_CHAT_FRAME:AddMessage("|cff40c040<" .. L["ADDON_TITLE"] .. ">|cffffffff " .. text, 1, 1, 1);
end

--========================================
-- Shows the currency/item goal input box
--========================================
function TrackOMatic_ShowGoalInput(itemText, func)

    TrackOMatic_GoalInputItemText:SetText(itemText);
    TrackOMatic_GoalInputEditBox:SetText("");
    TrackOMatic_GoalInputBox.acceptFunc = func;
    TrackOMatic_GoalInputBox:Show();

end

--========================================
-- Triggered when hitting "accept" on the
-- currency/item goal input box
--========================================
function TrackOMatic_GoalInputAccept()
    if (TrackOMatic_GoalInputEditBox:GetText() ~= "") then
        TrackOMatic_GoalInputBox.acceptFunc(TrackOMatic_GoalInputEditBox:GetText());
        TrackOMatic_GoalInputBox:Hide();
    end
end

--==================================================
-- Handler for clicking the expand/collapse buttons
-- on a category header
--==================================================
function TrackOMatic_Category_OnExpandOrCollapse(header)
    if (header.toggle) then
        header.toggle(header);
    end
end

--==================================================
-- Collapses/expands a category
--==================================================
function TrackOMatic_ToggleCategory(header)
    if (header.cat) then
        if (TRACKOMATIC_VARS[TrackOMatic.Profile]['categories'][header.cat].collapsed) then
            TRACKOMATIC_VARS[TrackOMatic.Profile]['categories'][header.cat].collapsed = false;
        else
            TRACKOMATIC_VARS[TrackOMatic.Profile]['categories'][header.cat].collapsed = true;
        end
        TrackOMatic_BuildTracker();
    end
end

--==================================================
-- Collapses/expands all categories (when headers
-- are turned off)
--==================================================
function TrackOMatic_ToggleUngroupedCategories(header)
    if (TRACKOMATIC_VARS[TrackOMatic.Profile]['categories'].collapseAll) then
        TRACKOMATIC_VARS[TrackOMatic.Profile]['categories'].collapseAll = false;
    else
        TRACKOMATIC_VARS[TrackOMatic.Profile]['categories'].collapseAll = true;
    end
    TrackOMatic_BuildTracker();
end

--==================================================
-- Adds an entry to a category
--==================================================
function TrackOMatic_AddToCategory(id, data)

    local watched = false;

    if (TRACKOMATIC_VARS[TrackOMatic.Profile]['categories'][id]) then
        for index, entry in pairs(TRACKOMATIC_VARS[TrackOMatic.Profile]['categories'][id].entries) do
            if (entry.id == data.id) then
                watched = true;
            end
        end
    else
        TRACKOMATIC_VARS[TrackOMatic.Profile]['categories'][id] = {collapsed = false, entries = {}};
    end
    if (watched) then
        StaticPopup_Show("TRACKOMATIC_ALREADY_TRACKED");
        return false;
    end
    slot = table.maxn(TRACKOMATIC_VARS[TrackOMatic.Profile]['categories'][id].entries) + 1;
    if (slot > MAX_BARS_PER_CATEGORY) then
        StaticPopup_Show("TRACKOMATIC_CATEGORY_FULL");
        return false;
    end
    TRACKOMATIC_VARS[TrackOMatic.Profile]['categories'][id].entries[slot] = data;
    TrackOMatic_BuildTracker();
    return true;
end

--==================================================
-- Removes an entry from a category
--==================================================
function TrackOMatic_RemoveFromCategory(category, index)
    if (not TRACKOMATIC_VARS[TrackOMatic.Profile]['categories'][category]) then
        return nil;
    end
    if (not TRACKOMATIC_VARS[TrackOMatic.Profile]['categories'][category].entries[index]) then
        return nil;
    end
    local data = TRACKOMATIC_VARS[TrackOMatic.Profile]['categories'][category].entries[index];
    table.remove(TRACKOMATIC_VARS[TrackOMatic.Profile]['categories'][category].entries, index);
    TrackOMatic_BuildTracker();
    return data;
end

--==================================================
-- Returns if there is an entry with the specified
-- id currently tracked within a category
--==================================================
function TrackOMatic_IsTracked(category, id, isPlugin)
    for i, cat in pairs(TRACKOMATIC_VARS[TrackOMatic.Profile]['categories']) do
        if (((i == "plugin") and isPlugin) or (i == (category or ""))) then
            if (cat.entries) then
                for index, data in pairs(cat.entries) do
                    if (data.id == id) then
                        if ((not isPlugin) == (not data.isPlugin)) then
                            return true;
                        end
                    end
                end
            end
        end
    end
    return false;
end

--==================================================
-- Returns if a category is empty
--==================================================
function TrackOMatic_CategoryIsEmpty(category)

    if (TRACKOMATIC_VARS[TrackOMatic.Profile]['categories'][category]) then
        if (TRACKOMATIC_VARS[TrackOMatic.Profile]['categories'][category].entries) then
            if (table.maxn(TRACKOMATIC_VARS[TrackOMatic.Profile]['categories'][category].entries) > 0) then
                return false;
            end
        end
    end
    return true;
end

--==================================================
-- Initiate clearing a category
--==================================================
function TrackOMatic_ClearCategory(category, noPopup)
    CLEARING_CATEGORY = category;
    if (noPopup) then
        TrackOMatic_AcceptCategoryClear();
    else
        StaticPopup_Show("TRACKOMATIC_CONFIRM_CLEAR_CATEGORY");
    end
end

--==================================================
-- Clears a category
--==================================================
function TrackOMatic_AcceptCategoryClear()
    if (TRACKOMATIC_VARS[TrackOMatic.Profile]['categories'][CLEARING_CATEGORY]) then
        TRACKOMATIC_VARS[TrackOMatic.Profile]['categories'][CLEARING_CATEGORY].entries = {};
        TrackOMatic_BuildTracker();
        TrackOMatic_Message(string.format(L["TRACKER_CATEGORY_CLEARED"], TRACKOMATIC_CATEGORIES[CLEARING_CATEGORY].title));
    end
end

--==================================================
-- Initiate clearing all categories
--==================================================
function TrackOMatic_ClearTracker(noPopup)
    if (noPopup) then
        TrackOMatic_AcceptTrackerClear();
    else
        StaticPopup_Show("TRACKOMATIC_CONFIRM_CLEAR_ALL");
    end
end

--==================================================
-- Clears all categories
--==================================================
function TrackOMatic_AcceptTrackerClear()
    local _i, _cat;
    for _i, _cat in pairs(TRACKOMATIC_VARS[TrackOMatic.Profile]['categories']) do
        TRACKOMATIC_VARS[TrackOMatic.Profile]['categories'][_i].entries = {};
    end
    TrackOMatic_BuildTracker();
    TrackOMatic_Message(L["TRACKER_ALL_CATEGORIES_CLEARED"]);
end

--==================================================
-- Returns if an entry can be moved up within a
-- category
--==================================================
function TrackOMatic_EntryCanMoveUp(category, index)
    if (index > 1) then
        return true;
    end
    return false;
end

--==================================================
-- Returns if an entry can be moved down within a
-- category
--==================================================
function TrackOMatic_EntryCanMoveDown(category, index)
    if (index < (table.maxn(TRACKOMATIC_VARS[TrackOMatic.Profile]['categories'][category].entries))) then
        return true;
    end
    return false;
end

--==================================================
-- Moves an entry up within a category
--==================================================
function TrackOMatic_MoveEntryUp(category, index)
    if (not TRACKOMATIC_VARS[TrackOMatic.Profile]['categories'][category].entries[index]) then return; end
    if (not TrackOMatic_EntryCanMoveUp(category, index)) then return; end
    local data = TRACKOMATIC_VARS[TrackOMatic.Profile]['categories'][category].entries[index];
    table.remove(TRACKOMATIC_VARS[TrackOMatic.Profile]['categories'][category].entries, index);
    table.insert(TRACKOMATIC_VARS[TrackOMatic.Profile]['categories'][category].entries, index - 1, data);
    TrackOMatic_BuildTracker();
end

--==================================================
-- Moves an entry down within a category
--==================================================
function TrackOMatic_MoveEntryDown(category, index)
    if (not TRACKOMATIC_VARS[TrackOMatic.Profile]['categories'][category].entries[index]) then return; end
    if (not TrackOMatic_EntryCanMoveDown(category, index)) then return; end
    local data = TRACKOMATIC_VARS[TrackOMatic.Profile]['categories'][category].entries[index];
    local data2 = TRACKOMATIC_VARS[TrackOMatic.Profile]['categories'][category].entries[index + 1];
    TRACKOMATIC_VARS[TrackOMatic.Profile]['categories'][category].entries[index + 1] = data;
    TRACKOMATIC_VARS[TrackOMatic.Profile]['categories'][category].entries[index] = data2;
    TrackOMatic_BuildTracker();
end

--==================================================
-- Sets categories to automatically sort
-- alphabetically (the categories themselves, not
-- the entries within) CURRENTLY UNUSED
--==================================================
function TrackOMatic_Autosort_Alphabetical()

    TRACKOMATIC_VARS[TrackOMatic.Profile]['autosort_cat'] = 1;
    TrackOMatic_GetCategoryOrder();
    TrackOMatic_BuildTracker();

end

--==================================================
-- Updates the current category order on the
-- tracker
--==================================================
function TrackOMatic_GetCategoryOrder()

    local cats = {};
    
    if (TRACKOMATIC_VARS[TrackOMatic.Profile]) then
    
        for id, info in pairs(TRACKOMATIC_CATEGORIES) do
            if (TRACKOMATIC_VARS[TrackOMatic.Profile]['categories']) then
                if (TRACKOMATIC_VARS[TrackOMatic.Profile]['categories'][id]) then
                    if (table.maxn(TRACKOMATIC_VARS[TrackOMatic.Profile]['categories'][id].entries) > 0) then
                        table.insert(cats, id);
                    end
                end
            end
        end
        if (TRACKOMATIC_VARS[TrackOMatic.Profile]['autosort_cat'] == 1) then
            table.sort(cats, function(a, b) return TRACKOMATIC_CATEGORIES[a].title < TRACKOMATIC_CATEGORIES[b].title; end);
        else
            table.sort(cats, function(a, b) return (TRACKOMATIC_VARS[TrackOMatic.Profile]['categories'][a].order or 0) < (TRACKOMATIC_VARS[TrackOMatic.Profile]['categories'][b].order or 0) end);
        end
        for id, info in pairs(TRACKOMATIC_CATEGORIES) do
            if (TRACKOMATIC_VARS[TrackOMatic.Profile]['categories']) then
                if (TRACKOMATIC_VARS[TrackOMatic.Profile]['categories'][id]) then
                    if (table.maxn(TRACKOMATIC_VARS[TrackOMatic.Profile]['categories'][id].entries) == 0) then
                        table.insert(cats, id);
                    end
                end
            end
        end
        for index, id in pairs(cats) do
            TRACKOMATIC_VARS[TrackOMatic.Profile]['categories'][id].order = index;
        end
        
    end

    return cats;

end

--==================================================
-- Moves a category up on the tracker
--==================================================
function TrackOMatic_MoveCategoryUp(category)
    local order = TrackOMatic_GetCategoryOrder();
    local catIndex;
    for index, id in pairs(order) do
        if (id == category) then
            catIndex = index;
        end
    end
    if (catIndex > 1) then
        table.remove(order, catIndex);
        table.insert(order, catIndex - 1, category);
    end
    for index, id in pairs(order) do
        TRACKOMATIC_VARS[TrackOMatic.Profile]['categories'][id].order = index;
    end
    TRACKOMATIC_VARS[TrackOMatic.Profile]['autosort_cat'] = 0;
    TrackOMatic_BuildTracker();
end

--==================================================
-- Moves a category down on the tracker
--==================================================
function TrackOMatic_MoveCategoryDown(category)
    local order = TrackOMatic_GetCategoryOrder();
    local catIndex;
    for index, id in pairs(order) do
        if (id == category) then
            catIndex = index;
        end
    end
    if (catIndex < NUM_HEADERS) then
        table.remove(order, catIndex);
        table.insert(order, catIndex + 1, category);
    end
    for index, id in pairs(order) do
        TRACKOMATIC_VARS[TrackOMatic.Profile]['categories'][id].order = index;
    end
    TRACKOMATIC_VARS[TrackOMatic.Profile]['autosort_cat'] = 0;
    TrackOMatic_BuildTracker();
end

--==================================================
-- Command handler (/tom)
--==================================================
function TrackOMatic_CommandHandler(cmd)

    if (string.lower(cmd) == "hide") then
        TrackOMatic_SetVisible(false);
    elseif (string.lower(cmd) == "show") then
        TrackOMatic_SetVisible(true);
    elseif (string.lower(cmd) == "debug") then
        TrackOMatic.DebugMode.Enabled = (not TrackOMatic.DebugMode.Enabled);
        if (TrackOMatic.DebugMode.Enabled) then
            TrackOMatic_Message("Debug mode enabled.");
        else
            TrackOMatic_Message("Debug mode disabled.");
        end
        TrackOMatic_BuildTracker();
    else
        TrackOMatic_OpenMainConfig();
    end

end

--========================================
-- Create a common menu item for bars
--========================================
function TrackOMatic_CommonMenuItem(id, func, ...)
    if (id == "CHANGE_GOAL") then
        local itemName = ...;
        return {text = L["BARMENU_CHANGE_GOAL"], notCheckable = true, func = function() TrackOMatic_ShowGoalInput(itemName, function(value) func(value); end); end};
    elseif (id == "RESET_SESSION") then
        return {text = L["BARMENU_RESET_SESSION"], notCheckable = true, func = function() func(); end};
    end
    return nil;
end

--========================================
-- Updates a bar using the specified
-- function
--========================================
function TrackOMatic_UpdateBar(func, bar, data)

    if ((not bar) or (not func)) then return; end
    
    local startTime = debugprofilestop();
    
    local ok, value, max, color, label, levelLabel, tooltipTitle, tooltipText, menuTitle, menu, clickFunc, isGlowing, glowColor, alertText;
    if (data.isPlugin) then
        --value, max, color, label, levelLabel, tooltipTitle, tooltipText, menuTitle, menu, clickFunc, isGlowing, glowColor, alertText = TrackOMatic_SetPluginBar(data);
        ok, value, max, color, label, levelLabel, tooltipTitle, tooltipText, menuTitle, menu, clickFunc, isGlowing, glowColor, alertText = pcall(TrackOMatic_SetPluginBar, data);
    else
        ok, value, max, color, label, levelLabel, tooltipTitle, tooltipText, menuTitle, menu, clickFunc, isGlowing, glowColor, alertText = pcall(func, data);
    end
    
    local startTime2 = debugprofilestop();
    
    if (ok) then
        bar.click = clickFunc;
        bar.menu = menu;
        bar.menuTitle = menuTitle;

        if ((value == nil) or (not max) or (not color) or (not label) or (not levelLabel)) then
            value = 1;
            max = 1;
            color = color or {r = 0.5, g = 0.5, b = 0.5};
            label = label or "";
            levelLabel = levelLabel or "";
            isGlowing = false;
        end

        if (((alertText or "") ~= "") and TRACKOMATIC_VARS['config']['show_alert_boxes']) then
            TrackOMatic_ShowAlertBox(bar, alertText);
        else
            TrackOMatic_HideAlertBox(bar);
        end

    else
    
        local esi = string.find(value, "AddOns", 1, true);
        if (esi) then esi = esi + 7; end
        local errSub = string.sub(value, esi or 0);
    
        color = {r = 1, g = 0, b = 0};
        label = L["ERROR"];
        levelLabel = "";
        tooltipTitle = L["AN_ERROR_HAS_OCCURRED"];
        tooltipText = errSub;
        isGlowing = true;
        value = 1;
        max = 1;
        bar.click = function() print(tooltipText); end
        bar.menu = nil;
        bar.menuTitle = L["ERROR"];
        
    end
    
    if (TrackOMatic.DebugMode.Enabled and TrackOMatic.DebugMode.ColorTest) then
        value = 1;
        max = 1;
    end
    
    bar:SetMinMaxValues(0, max);
    bar:SetValue(value);
    bar:SetStatusBarColor(color.r, color.g, color.b);
    _G[bar:GetName() .. "Label"]:SetText(label);
    _G[bar:GetName() .. "Level"]:SetText(levelLabel);
    _G[bar:GetName() .. "Click"].tooltip = tooltipTitle;
    if (isGlowing and TRACKOMATIC_VARS[TrackOMatic.Profile]['enable_glows']) then
        _G[bar:GetName() .. "ClickGlow"]:Show();
        bar.isGlowing = true;
        bar.glowColor = glowColor or {r = 1, g = 1, b = 0};
        GLOWING_BARS[bar:GetName()] = true;
    else
        _G[bar:GetName() .. "ClickGlow"]:Hide();
        bar.isGlowing = false;
    end
    local endTime = debugprofilestop();
    if (TrackOMatic.DebugMode.Enabled) then
        tooltipText = tooltipText .. "\n\n|cff00ff00Func: " .. (startTime2 - startTime) .. " ms\nUpd: " .. (endTime - startTime2) .. " ms";
    end
    
    _G[bar:GetName() .. "Click"].subtip = tooltipText;
    TrackOMatic_UpdateStatusBarTexture(bar);

end

--========================================
-- Animates glowing bar borders
--========================================
function TrackOMatic_UpdateGlow(elapsed)

    if (GLOW_DIR == 1) then
        GLOW_VALUE = GLOW_VALUE + (elapsed * 75);
    else
        GLOW_VALUE = GLOW_VALUE - (elapsed * 75);
    end
    if (GLOW_VALUE > 100) then
        GLOW_VALUE = 100 - (GLOW_VALUE - 100);
        GLOW_DIR = 0;
    elseif (GLOW_VALUE < 20) then
        GLOW_VALUE = 20 + (20 - GLOW_VALUE);
        GLOW_DIR = 1;
    end

    for barId, isGlowing in pairs(GLOWING_BARS) do
        if (isGlowing) then
            local bar = _G[barId];
            if (bar) then
                local glow = _G[barId .. "ClickGlow"];
                if (glow) then
                    glow:SetVertexColor(bar.glowColor.r, bar.glowColor.g, bar.glowColor.b, (GLOW_VALUE / 100));
                end
            end
        end
    end
    
end

--========================================
-- Outputs text to any valid debug
-- console(s)
--========================================
function TrackOMatic_DebugLog(text)
    TrackOMatic_RunHooks("PLUGIN_LOGGER", text);
end

--========================================
-- Unused? Not even really sure what I
-- was trying to do here...
--========================================
function TrackOMatic_CheckTrackerPosition()
    local tcx = TrackOMatic:GetCenter();
    local ucx = UIParent:GetCenter();
    if (tcx ~= TRACKER_CENTER_X) then
        if (((tcx > ucx) and (TRACKER_CENTER_X <= ucx)) or ((tcx <= ucx) and (TRACKER_CENTER_X > ucx))) then
            TrackOMatic_UpdateTracker(2);
        end
    end
end

--========================================
-- Suppresses the current alert for the
-- specified bar
--========================================
function TrackOMatic_SuppressAlert(bar)

    local data = TrackOMatic_GetData(bar.cat, bar.index);
    if (data) then

        if (data.isPlugin) then
            TrackOMatic_SuppressPluginAlert(data);
        else
            if (TRACKOMATIC_CATEGORIES[bar.cat]) then
                if (TRACKOMATIC_CATEGORIES[bar.cat].suppressAlert) then
                    TRACKOMATIC_CATEGORIES[bar.cat].suppressAlert(data);
                end
            end
        end

    end

end

--========================================
-- Displays an alert box on the
-- specified bar
--========================================
function TrackOMatic_ShowAlertBox(bar, text)

    local side = 0;
    if (TrackOMatic:GetCenter() > UIParent:GetCenter()) then
        side = 1;
    end

    local alertBox = _G[bar:GetName() .. "AlertBox"];
    if (alertBox) then
        local t = _G[alertBox:GetName() .. "Text"];
        t:SetText(text);
        alertBox:SetWidth(t:GetStringWidth() + 40);
        alertBox:SetHeight(t:GetStringHeight() + 20);
        -- reposition alert box and show appropriate arrow
        if (side == 0) then
            alertBox:ClearAllPoints();
            alertBox:SetPoint("TOPLEFT", bar, "TOPRIGHT", 8, 3);
            _G[alertBox:GetName() .. "ArrowLeft"]:Show();
            _G[alertBox:GetName() .. "ArrowRight"]:Hide();
        else
            alertBox:ClearAllPoints();
            alertBox:SetPoint("TOPRIGHT", bar, "TOPLEFT", -8, 3);
            _G[alertBox:GetName() .. "ArrowLeft"]:Hide();
            _G[alertBox:GetName() .. "ArrowRight"]:Show();
        end
        alertBox:Show();
    end

end

--========================================
-- Hides any alert box associated with
-- the specified bar
--========================================
function TrackOMatic_HideAlertBox(bar)
    local alertBox = _G[bar:GetName() .. "AlertBox"];
    if (alertBox) then
        alertBox:Hide();
    end
end

--========================================
-- Changes the automatic update interval
--========================================
function TrackOMatic_SetUpdateInterval(index)
    if ((index < 0) or (index > #UPDATE_INTERVALS)) then return; end
    TRACKOMATIC_VARS['config']['update_interval'] = index;
    UPDATE_INTERVAL = UPDATE_INTERVALS[index];
    CloseDropDownMenus();
end

function TrackOMatic_Startup()
    TrackOMatic.StartingGold = GetMoney();
    local __, plugin;
    for __, plugin in pairs(TrackOMatic.Plugins) do
        if (plugin.onStartup) then
            plugin.onStartup();
        end
    end
end
