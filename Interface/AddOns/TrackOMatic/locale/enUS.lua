local L = LibStub("AceLocale-3.0"):NewLocale("TrackOMatic", "enUS", true)

if L then

-- general strings
L["LOADED_MESSAGE"] = "Version %s loaded. Type |cffffff00/tom|r to configure.";
L["ADDON_TITLE"] = "Track-O-Matic";
L["VERSION_TEXT"] = "Track-O-Matic |cffa335ee[Classic Edition]|r %s";
L["BUTTON_OK"] = "OK";
L["BUTTON_ADD"] = "Add to Track-O-Matic";
L["TRACK_PROFESSION_TOOLTIP"] = "Click to add this profession to Track-O-Matic.";
L["UNDEFINED"] = "Undefined";
L["NEWER_VERSION"] = "A newer version is available: %s";
L["ERROR"] = "Error";
L["AN_ERROR_HAS_OCCURRED"] = "An error has occurred";
L["N/A"] = "N/A";

-- popup window & chat frame feedback messages
L["ENTER_GOAL_PROMPT"] = "Please enter a goal amount to track for the following item:";
L["MESSAGE_POSITION_UNLOCKED"] = "Tracker position unlocked.";
L["MESSAGE_POSITION_LOCKED"] = "Tracker position locked.";
L["MESSAGE_TRACKER_HIDDEN"] = "Tracker hidden. Type |cffffff00/tom show|r to show again.";
L["MESSAGE_TRACKER_SHOWN"] = "Now showing tracker.";
L["MESSAGE_AUTOHIDE_ENABLED"] = "Mouse-over auto-hide enabled.";
L["MESSAGE_AUTOHIDE_DISABLED"] = "Mouse-over auto-hide disabled.";
L["MESSAGE_CATEGORY_FULL"] = "You cannot add any more bars to that category.";
L["MESSAGE_ALREADY_TRACKED"] = "That item is already being tracked.";
L["MESSAGE_INVALID_GOAL"] = "Invalid target quantity entered. Please enter a number greater than zero.";
L["MESSAGE_GOLD_SESSION_RESET"] = "Gold session reset.";
L["MESSAGE_GRIND_SESSION_RESET"] = "Kills to Level session reset.";
L["MESSAGE_QUEST_SESSION_RESET"] = "Quests to Level session reset.";
L["MESSAGE_REP_SESSION_RESET"] = "Reputation gain session reset for |cffffc080%s|r.";
L["CONFIRM_CLEAR_CATEGORY"] = "Do you want to clear all items in this category from the tracker?";
L["CONFIRM_CLEAR_ALL"] = "Do you want to clear all items in all categories from the tracker?";
L["CURRENCY_ERROR"] = "Unable to retrieve currency ID for %s.";
L["INVALID_CURRENCY_ID"] = "Invalid currency ID: %s";
L["AUTO_DB_UPDATE"] = "Performing upgrade maintenance on saved variables (%s)";
L["ERROR_REMOVING_BAR"] = "An error occurred while removing a bar from the tracker.";

-- config frame
L["VERSION_UP_TO_DATE"] = "Up to date";
L["VERSION_STATUS"] = "Version status: %s";
L["CONFIG_NEWER_VERSION"] = "Newer version available: |cffffffff%s"
L["CONFIG_GENERAL"] = "General Settings";
L["OPTION_SHOW_TRACKER"] = "Show Tracker";
L["OPTION_LOCK_TRACKER"] = "Lock Tracker";
L["OPTION_LOCK_TRACKER_TOOLTIP"] = "Enable to lock the tracker's position on\nthe screen so it can't be moved.";
L["OPTION_HIDE_HEADERS"] = "Hide Category Headers";
L["OPTION_HIDE_HEADERS_TOOLTIP"] = "If enabled, individual category headers\nwill not be shown and all bars will be\ngrouped together.";
L["OPTION_ENABLE_GLOWS"] = "Enable Glowing Borders";
L["OPTION_ENABLE_GLOWS_TOOLTIP"] = "Enables ALL glowing\nborder effects for all bars.";
L["OPTION_SHOW_LOAD_MESSAGE"] = "Show Loading Messages";
L["OPTION_SHOW_LOAD_MESSAGE_TOOLTIP"] = "If enabled, messages indicating when Track-O-Matic\nand its plugins are loaded/registered will be\ndisplayed on the chat frame when logging in.";
L["OPTION_ENABLE_ALERTS"] = "Enable Alert Boxes";
L["OPTION_ENABLE_ALERTS_TOOLTIP"] = "Allows alert boxes to be displayed to the side of the tracker.\nUncheck to disable ALL alert boxes from being shown.";
L["OPTION_SCALE"] = "Scale: %s";
L["OPTION_SCALE_LABEL"] = "Frame Scale";
L["OPTION_SCALE_TOOLTIP"] = "The overall scale of the tracker window. This\noption affects bar/header height, and text size.";
L["OPTION_WIDTH"] = "Width: %s";
L["OPTION_WIDTH_LABEL"] = "Frame Width";
L["OPTION_WIDTH_TOOLTIP"] = "Sets the width of the tracker. This option only\naffects the width of bars, and does not affect\nbar height, or text size.";
L["OPTION_BAR_TEXTURE"] = "Bar Texture";
L["OPTION_BAR_TEXTURE_TOOLTIP"] = "Select the texture to use for tracker bars.";
L["CONFIG_PLAYER_BARS"] = "Player Info Bars";
L["OPTION_GOLD_BAR"] = "Gold Tracker";
L["OPTION_GOLD_LOST_GLOW"] = "Glow when negative";
L["OPTION_GOLD_LOST_GLOW_TOOLTIP"] = "If enabled, the Gold bar will glow when\ngold has been lost in the current session.";
L["OPTION_DURABILITY_BAR"] = "Equipment Durability";
L["OPTION_SHOW_LOWEST_DURABILITY"] = "Show lowest item";
L["OPTION_SHOW_LOWEST_DURABILITY_TOOLTIP"] = "Enable to show the item with the lowest\ndurability percentage (in other words, the\nmost broken equipped item).";
L["OPTION_DURABILITY_GLOW"] = "Glow on broken item";
L["OPTION_DURABILITY_GLOW_TOOLTIP"] = "If enabled, the durability bar will glow\nwhen one or more equipped items\nare down to zero durability.";
L["OPTION_LEVELING_BARS"] = "Kills/Quests Until Level Up";
L["OPTION_REVERSE_LEVELING_BARS"] = "Reverse growth direction";
L["OPTION_REVERSE_LEVELING_BARS_TOOLTIP"] = "If enabled, the Kills/Quests Until Level Up\nbars will progress from full to empty\ninstead of empty to full.";
L["OPTION_ESTIMATION_MODE"] = "Kills to Level Up Calculation Method";
L["OPTION_ESTIMATION_MODE_TOOLTIP"] = "Select how the Kills to Level Up bar will\ncalculate remaining mobs.\n\n{$s}\n\n|cffffffffRecommended:|r {$r}";
L["ESTIMATION_MODE_SMART_AVERAGE"] = "Smart Average";
L["ESTIMATION_MODE_SMART_AVERAGE_DESC"] = "|cffffffffSmart Average:|r Same as Average, but the calculation\nwill also average with the XP gained from your most\nrecent kill. The estimated value will more accurately\nreflect changes in XP per kill without\nfluctuating as severely.";
L["ESTIMATION_MODE_AVERAGE"] = "Average";
L["ESTIMATION_MODE_AVERAGE_DESC"] = "|cffffffffAverage:|r Estimates remaining mob kills to level up using\nan average of XP gained from all mobs killed over the\ncurrent session. The estimation will not be affected as\nmuch by large changes in XP per kill.";
L["ESTIMATION_MODE_LAST_KILL"] = "Last Kill";
L["ESTIMATION_MODE_LAST_KILL_DESC"] = "|cffffffffLast Kill:|r Estimates remaining mob kills to level up using\nonly the XP gained from your most recent kill. The\nestimated value will fluctuate greatly when killing mobs\nthat grant varying amounts of XP.";
L["CONFIG_ITEM_BARS"] = "Item Bars";
L["OPTION_SHOW_PERCENT"] = "Show percentages";
L["OPTION_SHOW_PERCENT_TOOLTIP"] = "If enabled, bars will show a percentage\nof their current value out of their maximum.";
L["OPTION_SHOW_QUANTITY"] = "Show current/goal";
L["OPTION_SHOW_QUANTITY_TOOLTIP"] = "If enabled, bars will show the current and\nmaximum value of the item they are tracking.";
L["OPTION_DEFAULT_GLOW"] = "Enable glow at 100%";
L["OPTION_ITEM_DEFAULT_GLOW_TOOLTIP"] = "If enabled, item bars will glow\nwhen their goal is reached.";
L["OPTION_CUSTOM_GLOW"] = "Enable custom glow";
L["OPTION_ITEM_CUSTOM_GLOW_TOOLTIP"] = "If enabled, item bars will glow\nwhen custom thresholds are met.";
L["CONFIG_CURRENCY_BARS"] = "Currency Bars";
L["OPTION_CURRENCY_DEFAULT_GLOW_TOOLTIP"] = "If enabled, currency bars will glow\nwhen their goal is reached.";
L["CONFIG_PROFESSION_BARS"] = "Profession Bars";
L["OPTION_PROFESSION_GLOW"] = "Glow when next rank available";
L["OPTION_PROFESSION_GLOW_TOOLTIP"] = "If enabled, profession bars will glow\nwhen your skill level is high enough\nto learn the next rank.";
L["CONFIG_REPUTATION_BARS"] = "Reputation Bars";
L["OPTION_REP_GAIN_DISPLAY"] = "Reputation Gain Detail To Show";
L["OPTION_REP_GAIN_NONE"] = "None";
L["OPTION_REP_GAIN_PER_HOUR"] = "Earned per hour";
L["OPTION_REP_GAIN_TIME_UNTIL_LEVEL"] = "Time until next level";
L["OPTION_REP_GAIN_TIME_UNTIL_EXALTED"] = "Time until exalted";
L["OPTION_REP_GAIN_DISPLAY_TOOLTIP"] = "Select what information to show on\nreputation bars in addition to current\nreputation value.";

-- config: plugins
L["PLUGINS"] = "Plugins";
L["INSTALLED_PLUGINS"] = "Installed Plugins";
L["NO_PLUGINS_INSTALLED"] = "No plugins installed";
L["PLUGIN_INTERFACE_VERSION"] = "Plugin interface ID: |cffffffff%s";

-- tips
L["TIP"] = "Tip:";
L["TIP_REMOVE_BAR"] = "<Ctrl><Shift>Left-click a bar to quickly remove it from the tracker.";
L["TIP_RESET_SESSION"] = "Some bars, such as the gold tracker, track data by session. You can reset the bar's session by right-clicking the bar and selecting \"Reset Session\".";
L["TIP_RIGHT_CLICK_BAR"] = "Right-click a bar for relevant options.";
L["TIP_SORT_CATEGORIES"] = "Categories can be rearranged by right-clicking the category header and selecting \"Move Up\" or \"Move Down\".";
L["TIP_CLEAR_CATEGORIES"] = "Entire catagories can be removed from the tracker at once by right clicking their header and selecting \"Remove\".";
L["TIP_CHANGE_GOAL"] = "You can change the goal amount for items by right-clicking the bar and selecting \"Change Goal\".";
L["TIP_TRACK_REPUTATION"] = "You can track your reputation with a faction by selecting the reputation in your character's Reputation tab and clicking the \"Add to Track-O-Matic\" button.";
L["TIP_TRACK_ITEM"] = "You can track an item by <Ctrl><Alt>Left-clicking an item in your bags.";
L["TIP_TRACK_PROFESSION"] = "You can track any skill by selecting a skill in the Skills frame and clicking the \"Add to Track-O-Matic\" button in the lower panel.";
L["TIP_REPUTATION_DETAILS"] = "Some reputation bar tooltips can show how many mobs you need to kill or how many of an item you need to turn in to reach the next level.";
L["TIP_GOLD_BAR"] = "The Gold tracker shows how much gold you've gained or lost in the current session. The bar appears green when you've gained gold or red when you've lost gold.";
L["TIP_MAIN_MENU"] = "Click the magnifying glass icon on the tracker for tracking options.";
L["TIP_LOCK_BUTTON"] = "Click the lock button on the tracker to lock or unlock the tracker's position. The icon indicates the tracker's current state.";
L["TIP_EXPAND_CATEGORIES"] = "You can collapse and expand categories by clicking the +/- button next to the category's name.";

-- main tracker menu
L["MENU_ADD_TRACKER"] = "Add Tracker";
L["MENU_TRACK_REPUTATION"] = "Track Reputation...";
L["MENU_TRACK_SKILL"] = "Track Skill...";
L["MENU_TRACK_PLAYER"] = "Track Player Info";
L["MENU_TRACK_PET"] = "Track Pet Info";
L["MENU_TRACK_MISC"] = "Track Misc. Info";
L["MENU_TRACK_PLUGIN"] = "Track Plugin";
L["MENU_TRACK_ITEM"] = "Track Item...";
L["MENU_TRACK_EVENTTRIGGER"] = "Track Event/Trigger";
L["MENU_CLEAR_CATEGORY"] = "Clear Category";
L["MENU_CLEAR_ALL"] = "Clear All";
L["MENU_TEMPLATES"] = "Templates";
L["MENU_TEMPLATE_CREATENEW"] = "Create New...";
L["MENU_TEMPLATE_LOAD"] = "Load";
L["MENU_TEMPLATE_SAVE"] = "Save";
L["MENU_TEMPLATE_DELETE"] = "Delete";
L["MENU_TEMPLATE_SETDEFAULT"] = "Set as Default";
L["MENU_SHOW_MOUSEOVER"] = "Show on Mouseover";
L["MENU_CONFIGURE"] = "Configure...";
L["MENU_UPDATE_INTERVAL"] = "Update Interval";
L["MENU_UPDATE_INTERVAL_1"] = "1 sec";
L["MENU_UPDATE_INTERVAL_2"] = "1/2 sec";
L["MENU_UPDATE_INTERVAL_3"] = "1/4 sec";
L["MENU_UPDATE_INTERVAL_4"] = "1/10 sec";
L["MENU_UPDATE_INTERVAL_5"] = "1/20 sec";

-- item/currency goal
L["CURRENT_AMOUNT"] = "Current: %s";
L["GOAL_AMOUNT"] = "Goal: %s";
L["UNTIL_GOAL"] = "%s until goal";
L["GOAL_REACHED"] = "Goal reached";
L["PAST_GOAL"] = "%s past goal";
L["CUSTOM_GLOW_SET"] = "Custom glow rule set:";

-- bar right-click menu
L["BARMENU_CHANGE_GOAL"] = "Change Goal...";
L["BARMENU_RESET_SESSION"] = "Reset Session";
L["BARMENU_MOVE_UP"] = "Move Up";
L["BARMENU_MOVE_DOWN"] = "Move Down";
L["BARMENU_REMOVE"] = "Remove";
L["BARMENU_CUSTOM_GLOW"] = "Setup Custom Glow Rule...";
L["BARMENU_REMOVE_CUSTOM_GLOW"] = "Remove Custom Glow Rule";

-- tooltips
L["TOOLTIP_OPTIONS_BUTTON"] = "Click for options";
L["TOOLTIP_LOCK_TRACKER"] = "Lock tracker position";
L["TOOLTIP_UNLOCK_TRACKER"] = "Unlock tracker position";
L["TOOLTIP_HIDE_BUTTON"] = "Click to hide tracker";

-- category headers
L["HEADER_REPUTATION"] = "Reputation";
L["HEADER_SKILLS"] = "Skills";
L["HEADER_MISC"] = "Misc. Info";
L["HEADER_ITEMS"] = "Items";
L["HEADER_PLUGINS"] = "Plugins";
L["HEADER_PLAYER"] = "Player Info";
L["HEADER_EVENT_TRIGGERS"] = "Event/Triggers";
L["HEADER_PET"] = "Pet";

-- template messages
L["TEMPLATE_SAVED_AS"] = "Template |cffffc080%s|r saved.";
L["TEMPLATE_LOADED"] = "Template |cffffc080%s|r loaded.";
L["TEMPLATE_DELETED"] = "Template |cffffc080%s|r deleted.";
L["CONFIRM_DELETE_TEMPLATE"] = "Are you sure you want to delete this template?";
L["CONFIRM_SAVE_TEMPLATE"] = "Are you sure you want to overwrite this template?";
L["CONFIRM_LOAD_TEMPLATE"] = "Load this template? Your current tracker setup will be overwritten.";
L["TEMPLATE_DEFAULT"] = "(default)";
L["DEFAULT_TEMPLATE_SET"] = "Template |cffffc080%s|r set as default.";
L["ENTER_TEMPLATE_NAME"] = "Enter a name for the new template.";

-- entry add/remove feedback messages
L["TRACKER_ADD_REP"] = "Now tracking reputation with |cffffc080%s|r.";
L["TRACKER_REMOVE_REP"] = "No longer tracking reputation with |cffffc080%s|r.";
L["TRACKER_ADD_MISC"] = "Now tracking information for |cffffc080%s|r.";
L["TRACKER_REMOVE_MISC"] = "No longer tracking information for |cffffc080%s|r.";
L["TRACKER_ADD_PLAYER"] = "Now tracking information for |cffffc080%s|r.";
L["TRACKER_REMOVE_PLAYER"] = "No longer tracking information for |cffffc080%s|r.";
L["TRACKER_ADD_PET"] = "Now tracking information for |cffffc080%s|r.";
L["TRACKER_REMOVE_PET"] = "No longer tracking information for |cffffc080%s|r.";
L["TRACKER_ADD_ITEM"] = "Now tracking inventory count for item %s.";
L["TRACKER_REMOVE_ITEM"] = "No longer tracking inventory count for item %s.";
L["TRACKER_ADD_SKILL"] = "Now tracking your skill in |cffffc080%s|r.";
L["TRACKER_REMOVE_SKILL"] = "No longer tracking your skill in |cffffc080%s|r.";
L["TRACKER_ADD_PLUGIN"] = "Now tracking data for plugin |cffffc080%s|r.";
L["TRACKER_REMOVE_PLUGIN"] = "No longer tracking data for plugin |cffffc080%s|r.";
L["TRACKER_ADD_EVENTTRIGGER"] = "Now tracking event/trigger |cffffc080%s|r.";
L["TRACKER_REMOVE_EVENTTRIGGER"] = "No longer tracking event/trigger |cffffc080%s|r.";
L["TRACKER_CATEGORY_CLEARED"] = "No longer tracking any information for |cffffc080%s|r.";
L["TRACKER_ALL_CATEGORIES_CLEARED"] = "All categories cleared.";

-- plugin-related messages
L["PLUGIN_NOT_REGISTERED"] = "Plugin not registered.";
L["REGISTERED_PLUGIN"] = "Registered plugin |cffffc080%s|r.";
L["INCOMPATIBLE"] = "Incompatible";
L["BY"] = "by %s";
L["MISSING_PLUGIN"] = "Missing Plugin";
L["MISSING_PLUGIN_TOOLTIP"] = "This plugin is not loaded.";
L["NOT_LOADED"] = "Not Loaded";
L["PLUGINS_REGISTERED"] = "%d plugin(s) registered.";
L["PLUGINS_REG_FAILED"] = "Failed registering %d plugin(s)!";

L["PLUGIN_DBG_REGISTERING"] = "Registering...";
L["PLUGIN_DBG_ERR_NONAME"] = "Plugin name not supplied to %s";
L["PLUGIN_DBG_ERR_NOVERSION"] = "Version information not present in plugin TOC";
L["PLUGIN_DBG_ERR_NOAUTHOR"] = "Author information not present in plugin TOC";
L["PLUGIN_DBG_ERR_INCOMPATIBLE"] = "Invalid compatibility flag supplied to %s";
L["PLUGIN_DBG_ERR_NAMECONFLICT"] = "Plugin name/ID conflict with existing plugin: %s";
L["PLUGIN_DBG_REGSUCCESS"] = "Registration successful.";

-- player info labels
L["PLAYER_INFO_XP"] = "Experience";
L["PLAYER_INFO_KILLS_TO_LEVEL"] = "Kills to Level";
L["PLAYER_INFO_QUESTS_TO_LEVEL"] = "Quests to Level";
L["PLAYER_INFO_GOLD"] = "Gold";
L["PLAYER_INFO_DURABILITY"] = "Equipment Durability";
L["PLAYER_INFO_HONOR"] = "Honor";
L["PLAYER_INFO_TIME_TO_LEVEL"] = "Time to Level Up";
L["PLAYER_INFO_ITEM_LEVEL"] = "Item Level";
L["PLAYER_INFO_ITEM_LEVEL_EQUIPPED"] = "Item Level (Equipped)";
L["HONOR_RANK"] = "%s (Rank %d)";
L["HONOR_NO_RANK"] = "No PvP Rank";
L["PROGRESS_TO_NEXT_RANK"] = "%d%% to next rank";
L["HONORABLE_KILLS"] = "Honorable Kills: %s";
L["DISHONORABLE_KILLS"] = "Honorable Kills: %s";
L["HIGHEST_RANK"] = "Highest Rank: %s";
L["ITEM_LEVEL_EQUIPPED_ONLY"] = "Equipped Items Only";
L["ITEM_LEVEL_TOOLTIP"] = "Item Level %s";

-- hunter pet labels
L["PET_INFO_XP"] = "Pet Experience";
L["PET_INFO_HAPPINESS"] = "Happiness";
L["PET_INFO_KILLS_TO_LEVEL"] = "Kills to Level";

-- kills to level up
L["KILLS_UNTIL_LEVEL_UP"] = "Kills until Level Up";
L["KILLS_UNTIL_LEVEL_UP_TOOLTIP"] = "Estimated kills until Level Up: %s";
L["XP_PER_KILL"] = "%s XP per kill (average)";
L["KILLS_TO_LEVEL_NO_INFO"] = "No information available.\nCalculations will be made when you kill enemies that grant XP.";
L["KILLS_TO_LEVEL_MOBS_KILLED"] = "%d killed";
L["XP_LAST_KILL"] = "Last Kill: %d XP";

-- quests to level up
L["QUESTS_UNTIL_LEVEL_UP"] = "Quests until Level Up";
L["QUESTS_UNTIL_LEVEL_UP_TOOLTIP"] = "Estimated quests until Level Up: %s";
L["XP_PER_QUEST"] = "%s XP per quest (average)";
L["QUESTS_TO_LEVEL_NO_INFO"] = "No information available.\nCalculations will be made when you complete quests that grant XP.";
L["QUESTS_TO_LEVEL_COMPLETED"] = "%d completed";

-- time to level up
L["XP_GAINED"] = "XP gained this session: %s";
L["XP_PER_HOUR"] = "XP/hour this session: %s";
L["TIME_PLAYED_SESSION"] = "Time played this session: %s";
L["TIME_PLAYED_LEVEL"] = "Time played this level: %s";
L["TIME_TO_LEVEL"] = "Time to level: %s";

-- hunter pet info
L["UNHAPPY"] = "Unhappy";
L["CONTENT"] = "Content";
L["HAPPY"] = "Happy";
L["HAPPINESS_TOOLTIP"] = "Your pet is %s";
L["HAPPINESS_DAMAGE"] = "Doing %s damage";
L["LOSING_LOYALTY"] = "Losing loyalty";
L["GAINING_LOYALTY"] = "Gaining loyalty";
L["NO_PET"] = "You do not have an active pet";
L["XP_NO_PET"] = "XP - No Pet";

-- experience
L["XP_TOOLTIP"] = "Experience (XP)";
L["XP_LEVEL"] = "XP - Level %d";
L["MAX_LEVEL"] = "Max level";
L["YOU_ARE_AT_MAX_LEVEL"] = "You are at maximum level.";
L["PET_IS_AT_MAX_LEVEL"] = "Your pet is at maximum level.";
L["CURRENT_XP"] = "Current: %s";
L["XP_TO_LEVEL"] = "XP to level: %s";
L["RESTED"] = "Rested";
L["RESTED_AMOUNT"] = "Rested: %s";
L["FULLY_RESTED"] = "Fully rested";
L["KILL_XP_MATCH"] = "dies, you gain (%d+) experience";
L["XP_GAIN_DISABLED"] = "XP gain is currently disabled";
L["DISABLED"] = "Disabled";

-- equipment durability
L["EQUIPPED_ITEM_DURABILITY"] = "Equipped Item Durability";
L["AVERAGE_DURABILITY"] = "Average Durability";
L["LOWEST_DURABILITY"] = "Lowest Item Durability";
L["DURA_HEAD"] = "Head: %s";
L["DURA_SHOULDER"] = "Shoulder: %s";
L["DURA_CHEST"] = "Chest: %s";
L["DURA_WRIST"] = "Wrist: %s";
L["DURA_HANDS"] = "Hands: %s";
L["DURA_WAIST"] = "Waist: %s";
L["DURA_LEGS"] = "Legs: %s";
L["DURA_FEET"] = "Feet: %s";
L["DURA_MAINHAND"] = "Main Hand: %s";
L["DURA_OFFHAND"] = "Off Hand: %s";
L["DURA_RANGED"] = "Ranged: %s";
L["BREAKING_ITEMS"] = "%s item(s) in need of repair";
L["SHOW_AVERAGE"] = "Show Average";
L["SHOW_LOWEST"] = "Show Lowest";
L["NO_DURABILITY_EQUIPPED"] = "No items with limited durability equipped";

-- gold tracker
L["GOLD"] = "Gold";
L["CURRENT_GOLD"] = "Current Gold Held: %s";
L["GOLD_SESSION_START"] = "Session start: %s";
L["EARNED_THIS_SESSION"] = "Earned this session: %s";
L["LOST_THIS_SESSION"] = "Lost this session: %s";

-- skills
L["MINING"] = "Mining";
L["SKINNING"] = "Skinning";
L["HERBALISM"] = "Herbalism";
L["TAILORING"] = "Tailoring";
L["LEATHERWORKING"] = "Leatherworking";
L["BLACKSMITHING"] = "Blacksmithing";
L["ENCHANTING"] = "Enchanting";
L["ENGINEERING"] = "Engineering";
L["ALCHEMY"] = "Alchemy";
L["FIRST_AID"] = "First Aid";
L["FISHING"] = "Fishing";
L["COOKING"] = "Cooking";
L["PROFESSION_NEW_RANK_AVAILABLE"] = "See profession trainer to learn next rank";
L["1H_AXES"] = "Axes";
L["2H_AXES"] = "Two-Handed Axes";
L["1H_MACES"] = "Maces";
L["2H_MACES"] = "Two-Handed Maces";
L["1H_SWORDS"] = "Swords";
L["2H_SWORDS"] = "Two-Handed Swords";
L["POLEARMS"] = "Polearms";
L["STAVES"] = "Staves";
L["DAGGERS"] = "Daggers";
L["FIST_WEAPONS"] = "Fist Weapons";
L["GUNS"] = "Guns";
L["BOWS"] = "Bows";
L["CROSSBOWS"] = "Crossbows";
L["WANDS"] = "Wands";
L["UNARMED"] = "Unarmed";
L["THROWN"] = "Thrown";
L["AGAINST_CURRENT_TARGET"] = "Against current target:";
L["AGAINST_EQUAL_TARGETS"] = "Against equal level targets:";
L["CRITICAL_CHANCE"] = "Critical strike chance: %s";
L["INCREASED_HIT_CHANCE"] = "Increased hit chance: %s";
L["ABLE_TO_SKIN_LEVEL_MOBS"] = "Able to skin creatures up to level %s";
L["ABLE_TO_SKIN_BOSS_MOBS"] = "Able to skin boss-level creatures";
L["ABLE_TO_GATHER_NODES"] = "Able to gather the following nodes:";

L["MINING_NODE_COPPER"] = "Copper";
L["MINING_NODE_TIN"] = "Tin";
L["MINING_NODE_SILVER"] = "Silver";
L["MINING_NODE_IRON"] = "Iron";
L["MINING_NODE_GOLD"] = "Gold";
L["MINING_NODE_MITHRIL"] = "Mithril";
L["MINING_NODE_TRUESILVER"] = "Truesilver";
L["MINING_NODE_DARK_IRON"] = "Dark Iron";
L["MINING_NODE_SMALL_THORIUM"] = "Small Thorium";
L["MINING_NODE_RICH_THORIUM"] = "Rich Thorium";

L["HERB_PEACEBLOOM"] = "Peacebloom";
L["HERB_SILVERLEAF"] = "Silverleaf";
L["HERB_EARTHROOT"] = "Earthroot";
L["HERB_MAGEROYAL"] = "Mageroyal";
L["HERB_BRIARTHORN"] = "Briarthorn";
L["HERB_STRANGLEKELP"] = "Stranglekelp";
L["HERB_BRUISEWEED"] = "Bruiseweed";
L["HERB_WILD_STEELBLOOM"] = "Wild Steelbloom";
L["HERB_GRAVE_MOSS"] = "Grave Moss";
L["HERB_KINGSBLOOD"] = "Kingsblood";
L["HERB_LIFEROOT"] = "Liferoot";
L["HERB_FADELEAF"] = "Fadeleaf";
L["HERB_GOLDTHORN"] = "Goldthorn";
L["HERB_KHADGARS_WHISKER"] = "Khadgar's Whisker";
L["HERB_WINTERSBITE"] = "Wintersbite";
L["HERB_FIREBLOOM"] = "Firebloom";
L["HERB_PURPLE_LOTUS"] = "Purple Lotus";
L["HERB_ARTHAS_TEARS"] = "Arthas' Tears";
L["HERB_SUNGRASS"] = "Sungrass";
L["HERB_BLINDWEED"] = "Blindweed";
L["HERB_GHOST_MUSHROOM"] = "Ghost Mushroom";
L["HERB_GROMSBLOOD"] = "Gromsblood";
L["HERB_GOLDEN_SANSAM"] = "Golden Sansam";
L["HERB_DREAMFOIL"] = "Dreamfoil";
L["HERB_MOUNTAIN_SILVERSAGE"] = "Mountain Silversage";
L["HERB_PLAGUEBLOOM"] = "Plaguebloom";
L["HERB_ICECAP"] = "Icecap";
L["HERB_BLACK_LOTUS"] = "Black Lotus";

-- item tracking
L["TRACK_ITEM_PROMPT"] = "Hold Ctrl+Alt and click on an item in your inventory, bank, void storage, etc. to add it to the tracker.";
L["ITEM_NOT_FOUND"] = "Unable to find a matching item in inventory. To track an item, you must already have have at least one of the item in your inventory.";
L["ITEM_GOAL_CHANGED"] = "Goal for item %s changed to |cffffc080%d|r.";
L["ITEM_MENU_INCLUDE_BANK"] = "Include items stored in bank";
L["ITEM_COUNT_INCLUDE_BANK_ON"] = "Item count for %s will now include items stored in your bank.";
L["ITEM_COUNT_INCLUDE_BANK_OFF"] = "Item count for %s will no longer include items stored in your bank.";
L["ITEM_TOOLTIP_INCLUDING_BANK"] = "Including %s stored in bank";
L["ITEM_TOOLTIP_BAG_COUNT"] = "%s held in bags";
L["ITEM_NONE_IN_BANK"] = "None stored in bank";

-- faction-related strings
L["TIME_UNTIL_STANDING"] = "Time until %s";
L["UNTIL_STANDING"] = "Until %s:";
L["MOB_KILLS"] = "Mob kills";
L["TURNINS"] = "Turn-ins:";
L["DAILIES_SET"] = "Rounds of daily quests";
L["DAILY_QUESTS"] = "Daily quests";
L["INCLUDES_ARGENT_DAWN_VALOR_TOKEN"] = "Includes gains from |cff00ff00[Argent Dawn Valor Token]|r awarded from turn-ins";
L["REPUTATION_UNTIL_STANDING"] = "Reputation until %s: %s";
L["REPUTATION_PER_HOUR"] = "Reputation earned per hour: %s";
L["REPUTATION_THIS_SESSION"] = "Reputation earned this session: %s";
L["STANDING_WITH_FACTION"] = "%s with %s";
L["DUNGEON_KILLS_NON_TRIVIAL"] = "Dungeon Kills (level-appropriate)";
L["BOSS_KILLS_NON_TRIVIAL"] = "Dungeon Boss Kills (level-appropriate)";
L["QUEST_ARGENTDAWN_REPEAT1"] = "Annals of the Silver Hand";
L["QUEST_ARGENTDAWN_REPEAT2"] = "Aberrations of Bone";
L["DO_EPL_QUESTS"] = "Complete quests in Eastern Plaguelands to unlock repeatable quests.";
L["CANNOT_GAIN_REP"] = "Reputation cannot be gained with this faction.";
L["DARKMOON_QUESTS_ANY"] = "Single Artifacts/Games/Quests";
L["DARKMOON_ARTIFACT_SETS"] = "Sets of Darkmoon Artifacts";
L["DARKMOON_GAMES_COLLECTIVE"] = "Days of games (combined)";
L["DARKMOON_MONTHS"] = "Full weeks of Darkmoon Faire";
L["SILITHYST_TURNIN"] = "Silithyst Dust";
L["GOLD_DONATIONS"] = "Donate gold";
L["DAILY_DUNGEON_BONUS"] = "Daily Dungeons";

-- item names (for rep turnins)
L["ITEM_NUMBER"] = "Item #%s";

-- mob names (kills for rep)
L["MOB_BOOTY_BAY_BRUISER"] = "Booty Bay Bruiser";

-- event/triggers

-- custom glow rule input
L["SETUP_CUSTOM_GLOW_RULE"] = "Setup Custom Glow Rule";
L["CONDITION"] = "Condition";
L["GLOW_RULE_CONDITION_PERCENT_BELOW"] = "% value is at or below";
L["GLOW_RULE_CONDITION_PERCENT_ABOVE"] = "% value is at or above";
L["GLOW_RULE_CONDITION_VALUE_BELOW"] = "Value is at or below";
L["GLOW_RULE_CONDITION_VALUE_ABOVE"] = "Value is at or above";

-- Bag Space module
L["BAG_SPACE"] = "Bag Space";
L["FREE_BAG_SPACE"] = "Free Bag Space";
L["INCLUDE_PROFESSION_BAGS"] = "Include profession bags";
L["INVERT_FILL_MODE"] = "Invert fill mode (show free space)";
L["BAR_LABEL_FREE_SPACE"] = "Bag Space (Free)";
L["BAR_LABEL_USED_SPACE"] = "Bag Space (Used)";
L["OUT_OF_BAG_SPACE"] = "You are out of bag space.";
L["LOW_BAG_SPACE"] = "You are running low on bag space.";
L["TOOLTIP_SLOTS_FREE"] = "{$slotsFree} of {$totalSlots} slots free";
L["TOOLTIP_PROFESSION_BAGS_IGNORED"] = "(Profession bags ignored)";

-- ***** About page strings *****
L["ABOUT"] = "About";
L["LABEL_AUTHOR"] = "Author";
L["LABEL_EMAIL"] = "Email";
L["LABEL_HOSTS"] = "Download Site(s)";

L["COPYRIGHT"] = "©2012-2019, All rights reserved.";

end
