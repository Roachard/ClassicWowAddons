local L = LibStub("AceLocale-3.0"):GetLocale("TrackOMatic", true);

local HATED = 1;
local HOSTILE = 2;
local UNFRIENDLY = 3;
local NEUTRAL = 4;
local FRIENDLY = 5;
local HONORED = 6;
local REVERED = 7;
local EXALTED = 8;

TRACKOMATIC_REPUTATION_DATA = {

    -- Booty Bay, Gadgetzan, Ratchet & Everlook
    [21] = {
        { text = L["MOB_KILLS"], repGain = 5 },
    },
    [369] = {
        { text = L["MOB_KILLS"], repGain = 5 },
    },
    [577] = {
        { text = L["MOB_KILLS"], repGain = 5 },
    },
    [470] = {
        { text = L["MOB_KILLS"], repGain = 5 },
    },

    -- Cenarion Circle
    [609] = {
        { text = L["MOB_KILLS"], repGain = 10 },
        { text = L["TURNINS"], subItems = {
            { text = L["SILITHYST_TURNIN"], repGain = 20 },
            { itemId = 20404, itemCount = 10, repGain = 500 },
        }},
    },

    -- Alliance & Horde capitals
    --[47] = {
    --    { text = L["TURNINS"], subItems = {
    --        { itemId = 45717, itemCount = 1, repGain = 250 },
    --    }},
    --},
    --[54] = {
    --    { text = L["TURNINS"], subItems = {
    --        { itemId = 45716, itemCount = 1, repGain = 250 },
    --    }},
    --},
    --[68] = {
    --    { text = L["TURNINS"], subItems = {
    --        { itemId = 45723, itemCount = 1, repGain = 250 },
    --    }},
    --},
    --[69] = {
    --    { text = L["TURNINS"], subItems = {
    --        { itemId = 45714, itemCount = 1, repGain = 250 },
    --    }},
    --},
    --[72] = {
    --    { text = L["TURNINS"], subItems = {
    --        { itemId = 45718, itemCount = 1, repGain = 250 },
    --    }},
    --},
    --[76] = {
    --    { text = L["TURNINS"], subItems = {
    --        { itemId = 45719, itemCount = 1, repGain = 250 },
    --    }},
    --},
    --[81] = {
    --    { text = L["TURNINS"], subItems = {
    --        { itemId = 45722, itemCount = 1, repGain = 250 },
    --    }},
    --},
    --[530] = {
    --    { text = L["TURNINS"], subItems = {
    --        { itemId = 45720, itemCount = 1, repGain = 250 },
    --    }},
    --},

    -- Timbermaw Hold
    [576] = {
        { text = L["MOB_KILLS"], repGain = 20 },
        { text = L["TURNINS"], subItems = {
            { itemId = 21377, itemCount = 5, repGain = 2000 },
            { itemId = 21383, itemCount = 5, repGain = 2000 },
        }},
    },

    -- Darkmoon Faire
    [909] = {
        --{ text = L["DARKMOON_QUESTS_ANY"], repGain = 250, isQuest = true },
        --{ text = L["DARKMOON_GAMES_COLLECTIVE"], repGain = 1250, isQuest = true, isDaily = true },
        --{ text = L["TURNINS"], subItems = {
        --    { text = L["DARKMOON_ARTIFACT_SETS"], repGain = 2250, isQuest = true },
        --    { text = L["DARKMOON_PROFESSION_QUEST_SETS"], repGain = 2250, isQuest = true },
        --}},
        --{ text = "" },
        --{ text = L["DARKMOON_MONTHS"], repGain = 12500, isCounter = true },
    },

    -- Brood of Nozdormu
    [910] = {
        { text = L["TURNINS"], subItems = {
            { itemId = 21229, repGain = 500 },
        }},
    },

    -- Bloodsail Buccaneers
    [87] = {
        { text = L["MOB_KILLS"], repGain = 25, subItems = {
            { text = L["MOB_BOOTY_BAY_BRUISER"] },
        }},
    },

    -- Ravenholdt
    [349] = {
        { text = L["MOB_KILLS"], repGain = 5, maxStanding = HONORED },
        { text = L["TURNINS"], subItems = {
            { itemId = 16885, itemCount = 5, repGain = 75 },
        }},
    },

    -- Thorium Brotherhood
    [59] = {
        { text = L["TURNINS"], subItems = {
            { itemId = 17010, itemCount = 1, repGain = 2000 },
            { itemId = 17011, itemCount = 1, repGain = 2000 },
            { itemId = 11382, itemCount = 1, repGain = 2000 },
            { itemId = 17012, itemCount = 2, repGain = 2000 },
            { itemId = 11370, itemCount = 10, repGain = 2000 },
        }},
    },

    -- Argent Dawn
    [529] = {
        { text = L["DO_EPL_QUESTS"], maxStanding = HONORED },
        { text = L["QUEST_ARGENTDAWN_REPEAT1"], repGain = 1000, isQuest = true, isDaily = true, minStanding = REVERED },
        { text = L["QUEST_ARGENTDAWN_REPEAT2"], repGain = 1000, isQuest = true, isDaily = true, minStanding = REVERED },
    },

    -- Wintersaber Trainers
    [589] = {
        { text = L["DAILY_QUESTS"], repGain = 1500, isQuest = true, isDaily = true },
    },

    -- Zandalar Tribe, Shen'dralar, Gelkis Clan Centaur, Magram Clan Centaur
    --[270] = { noGain = true },
    --[809] = { noGain = true },
    --[92] = { noGain = true },
    --[93] = { noGain = true },

};
