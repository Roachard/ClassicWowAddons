local L = LibStub("AceLocale-3.0"):GetLocale("TrackOMatic", true);

--==================================================
-- Initialize the main menu
--==================================================
function TrackOMatic_InitMainMenu()
    CreateFrame("Frame", "TrackOMatic_TrackerMenu", UIParent, "UIDropDownMenuTemplate");
end

--==================================================
-- Handler for clicking the track button
-- (magnifying glass); Displays the main menu
--==================================================
function TrackOMatic_TrackButton_OnClick(self)

    local playerInfoMenu = {
        { text = L["PLAYER_INFO_XP"], disabled = TrackOMatic_IsTracked("player", "xp"), notCheckable = true, func = function() TrackOMatic_AddPlayerInfo("xp"); end },
        { text = L["PLAYER_INFO_KILLS_TO_LEVEL"], disabled = TrackOMatic_IsTracked("player", "grind"), notCheckable = true, func = function() TrackOMatic_AddPlayerInfo("grind"); end },
        { text = L["PLAYER_INFO_QUESTS_TO_LEVEL"], disabled = TrackOMatic_IsTracked("player", "quest"), notCheckable = true, func = function() TrackOMatic_AddPlayerInfo("quest"); end },
        { text = L["PLAYER_INFO_TIME_TO_LEVEL"], disabled = TrackOMatic_IsTracked("player", "_TimeToLevel", true), notCheckable = true, func = function() TrackOMatic_AddPlugin("_TimeToLevel"); end },
        { text = L["PLAYER_INFO_GOLD"], disabled = TrackOMatic_IsTracked("player", "gold"), notCheckable = true, func = function() TrackOMatic_AddPlayerInfo("gold"); end },
        { text = L["PLAYER_INFO_DURABILITY"], disabled = TrackOMatic_IsTracked("player", "durability"), notCheckable = true, func = function() TrackOMatic_AddPlayerInfo("durability"); end },
        { text = L["PLAYER_INFO_HONOR"], disabled = TrackOMatic_IsTracked("player", "honor"), notCheckable = true, func = function() TrackOMatic_AddPlayerInfo("honor"); end },
        { text = L["BAG_SPACE"], disabled = TrackOMatic_IsTracked("player", "_BagSpace", true), notCheckable = true, func = function() TrackOMatic_AddPlugin("_BagSpace"); end },
    };
    table.sort(playerInfoMenu, function(a, b) return (a.text < b.text); end);
    
    local petInfoMenu = {
        { text = L["PET_INFO_XP"], disabled = TrackOMatic_IsTracked("pet", "xp"), notCheckable = true, func = function() TrackOMatic_HunterPet_AddBar("xp"); end },
        --{ text = L["PLAYER_INFO_KILLS_TO_LEVEL"], disabled = TrackOMatic_IsTracked("pet", "grind"), notCheckable = true, func = function() TrackOMatic_HunterPet_AddBar("grind"); end },
        { text = L["PET_INFO_HAPPINESS"], disabled = TrackOMatic_IsTracked("pet", "happiness"), notCheckable = true, func = function() TrackOMatic_HunterPet_AddBar("happiness"); end },
        --{ text = L["PLAYER_INFO_TIME_TO_LEVEL"], disabled = TrackOMatic_IsTracked("player", "_TimeToLevel", true), notCheckable = true, func = function() TrackOMatic_AddPlugin("_TimeToLevel"); end },
    };
    table.sort(petInfoMenu, function(a, b) return (a.text < b.text); end);

    local menu = {
        { text = L["ADDON_TITLE"], isTitle = true, notCheckable = true },
        { text = "Add Tracker", hasArrow = true, notCheckable = true,
            menuList = {
                { text = L["MENU_TRACK_REPUTATION"], notCheckable = true, func = function() ToggleCharacter("ReputationFrame", true); CloseDropDownMenus(); end },
                { text = L["MENU_TRACK_SKILL"], notCheckable = true, func = function() ToggleCharacter("SkillFrame", true); CloseDropDownMenus(); end },
                { text = L["MENU_TRACK_ITEM"], notCheckable = true, func = function() CloseDropDownMenus(); StaticPopup_Show("TRACKOMATIC_TRACK_ITEM"); end },
                { text = L["MENU_TRACK_PLAYER"], hasArrow = true, notCheckable = true, 
                    menuList = playerInfoMenu
                },
                { text = L["MENU_TRACK_PET"], hasArrow = true, notCheckable = true,
                    menuList = petInfoMenu
                },
                { text = L["MENU_TRACK_PLUGIN"], hasArrow = true, notCheckable = true,
                    menuList = TrackOMatic_GetMenuPluginList(),
                },
            },
        },
        { text = L["MENU_CLEAR_CATEGORY"], hasArrow = true, notCheckable = true,
            --menuList = {
            --    { text = L["MENU_CLEAR_ALL"], notCheckable = true, func = function() TrackOMatic_ClearTracker(); end },
            --    { text = "", notClickable = true, notCheckable = true },
            --    { text = L["HEADER_REPUTATION"], notCheckable = true, disabled = TrackOMatic_CategoryIsEmpty("rep"), func = function() TrackOMatic_ClearCategory("rep"); end },
            --    { text = L["HEADER_SKILLS"], notCheckable = true, disabled = TrackOMatic_CategoryIsEmpty("skill"), func = function() TrackOMatic_ClearCategory("skill"); end },
            --    { text = L["HEADER_PLAYER"], notCheckable = true, disabled = TrackOMatic_CategoryIsEmpty("player"), func = function() TrackOMatic_ClearCategory("player"); end },
            --    { text = L["HEADER_ITEMS"], notCheckable = true, disabled = TrackOMatic_CategoryIsEmpty("item"), func = function() TrackOMatic_ClearCategory("item"); end },
            --    { text = L["HEADER_EVENT_TRIGGERS"], notCheckable = true, disabled = TrackOMatic_CategoryIsEmpty("eventtrigger"), func = function() TrackOMatic_ClearCategory("eventtrigger"); end },
            --    { text = L["HEADER_MISC"], notCheckable = true, disabled = TrackOMatic_CategoryIsEmpty("misc"), func = function() TrackOMatic_ClearCategory("misc"); end },
            --    { text = L["HEADER_PLUGINS"], notCheckable = true, disabled = TrackOMatic_CategoryIsEmpty("plugin"), func = function() TrackOMatic_ClearCategory("plugin"); end },
            --},
            menuList = TrackOMatic_MainMenu_ClearCategoryOptions(),
        },
        { text = L["MENU_TEMPLATES"], hasArrow = true, notCheckable = true,
            menuList = TrackOMatic_GetMenuTemplateList(),
        },
        { text = L["MENU_UPDATE_INTERVAL"], hasArrow = true, notCheckable = true,
            menuList = {
                { text = L["MENU_UPDATE_INTERVAL_1"], checked = (TRACKOMATIC_VARS['config']['update_interval'] == 0), func = function() TrackOMatic_SetUpdateInterval(0); end },
                { text = L["MENU_UPDATE_INTERVAL_2"], checked = (TRACKOMATIC_VARS['config']['update_interval'] == 1), func = function() TrackOMatic_SetUpdateInterval(1); end },
                { text = L["MENU_UPDATE_INTERVAL_3"], checked = (TRACKOMATIC_VARS['config']['update_interval'] == 2), func = function() TrackOMatic_SetUpdateInterval(2); end },
                { text = L["MENU_UPDATE_INTERVAL_4"], checked = (TRACKOMATIC_VARS['config']['update_interval'] == 3), func = function() TrackOMatic_SetUpdateInterval(3); end },
                { text = L["MENU_UPDATE_INTERVAL_5"], checked = (TRACKOMATIC_VARS['config']['update_interval'] == 4), func = function() TrackOMatic_SetUpdateInterval(4); end },
            },
        },
        { text = L["MENU_SHOW_MOUSEOVER"], checked = TrackOMatic.AutoHide, func = function() TrackOMatic_SetAutoHide(not TrackOMatic.AutoHide); end },
        { text = "", notClickable = true, notCheckable = true },
        { text = L["MENU_CONFIGURE"], notCheckable = true, func = function() TrackOMatic_OpenMainConfig(); end },
        TrackOMatic_MainMenu_DebugOptions(),
    };

    TrackOMatic_RunHooks("MAIN_MENU", menu);

    EasyMenu(menu, TrackOMatic_TrackerMenu, self, 0, 0, "MENU", 1);
end

function TrackOMatic_MainMenu_ClearCategoryOptions()
    local menuList = {
        { text = L["HEADER_REPUTATION"], notCheckable = true, disabled = TrackOMatic_CategoryIsEmpty("rep"), func = function() TrackOMatic_ClearCategory("rep"); end },
        { text = L["HEADER_SKILLS"], notCheckable = true, disabled = TrackOMatic_CategoryIsEmpty("skill"), func = function() TrackOMatic_ClearCategory("skill"); end },
        { text = L["HEADER_PLAYER"], notCheckable = true, disabled = TrackOMatic_CategoryIsEmpty("player"), func = function() TrackOMatic_ClearCategory("player"); end },
        { text = L["HEADER_PET"], notCheckable = true, disabled = TrackOMatic_CategoryIsEmpty("pet"), func = function() TrackOMatic_ClearCategory("pet"); end },
        { text = L["HEADER_ITEMS"], notCheckable = true, disabled = TrackOMatic_CategoryIsEmpty("item"), func = function() TrackOMatic_ClearCategory("item"); end },
        { text = L["HEADER_EVENT_TRIGGERS"], notCheckable = true, disabled = TrackOMatic_CategoryIsEmpty("eventtrigger"), func = function() TrackOMatic_ClearCategory("eventtrigger"); end },
        { text = L["HEADER_MISC"], notCheckable = true, disabled = TrackOMatic_CategoryIsEmpty("misc"), func = function() TrackOMatic_ClearCategory("misc"); end },
        { text = L["HEADER_PLUGINS"], notCheckable = true, disabled = TrackOMatic_CategoryIsEmpty("plugin"), func = function() TrackOMatic_ClearCategory("plugin"); end },
    };
    local i = 1;
    while (true) do
        if (i > #menuList) then break; end
        if (menuList[i].disabled) then
            table.remove(menuList, i);
        else
            i = i + 1;
        end
    end
    table.sort(menuList, function(a, b) return (a.text < b.text); end);
    local canClearAll = (#menuList > 0);
    if (canClearAll) then table.insert(menuList, { text = "", notClickable = true, notCheckable = true }); end
    table.insert(menuList, { text = (canClearAll and "|cffffff00" or "") .. L["MENU_CLEAR_ALL"], notCheckable = true, disabled = (not canClearAll), func = function() TrackOMatic_ClearTracker(); end });
    
    return menuList;
end

function TrackOMatic_MainMenu_DebugOptions()
    if (not TrackOMatic.DebugMode.Enabled) then return nil; end
    local separator = { text = "", notClickable = true, notCheckable = true };
    local rootItem = { text = "Debugging Options", hasArrow = true, notCheckable = true,
        menuList = {
            { text = "Bar Color Test", checked = TrackOMatic.DebugMode.ColorTest, func = function() TrackOMatic.DebugMode.ColorTest = not TrackOMatic.DebugMode.ColorTest; TrackOMatic_UpdateTracker(); end },
            { text = "Profession Rank Available Test", checked = TrackOMatic.DebugMode.ProfessionTest, func = function() TrackOMatic.DebugMode.ProfessionTest = not TrackOMatic.DebugMode.ProfessionTest; TrackOMatic_UpdateTracker(); end },
            { text = "Hunter Pet", hasArrow = true, notCheckable = true,
                menuList = {
                    { text = "Remove Debug Override", notCheckable = true, func = function() TrackOMatic.DebugMode.HunterPet = nil; end },
                    { text = "Set Happiness", hasArrow = true, notCheckable = true,
                        menuList = {
                            { text = "Unhappy", notCheckable = true, func = function() TrackOMatic_HunterPet_Debug_SetHappiness(1); end },
                            { text = "Content", notCheckable = true, func = function() TrackOMatic_HunterPet_Debug_SetHappiness(2); end },
                            { text = "Happy", notCheckable = true, func = function() TrackOMatic_HunterPet_Debug_SetHappiness(3); end },
                        },
                    },
                    { text = "Set Loyalty Rate", hasArrow = true, notCheckable = true,
                        menuList = {
                            { text = "Losing Loyalty", notCheckable = true, func = function() TrackOMatic_HunterPet_Debug_SetLoyaltyRate(-1); end },
                            { text = "Zero", notCheckable = true, func = function() TrackOMatic_HunterPet_Debug_SetLoyaltyRate(0); end },
                            { text = "Gaining Loyalty", notCheckable = true, func = function() TrackOMatic_HunterPet_Debug_SetLoyaltyRate(1); end },
                        },
                    },
                },
            },
        },
    };
    return separator, rootItem;
end