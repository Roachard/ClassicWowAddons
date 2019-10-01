--------------------------------------------
-- Creates all global variables for LOGIC --
--------------------------------------------

-- Holds information on the opened trade skill
-- Contains following info once loaded from player
-- 		NAME,
-- 		SKILL_LEVEL,
-- 		MAX_LEVEL,
-- 		AMOUNT_LEARNED,
-- 		AMOUNT_MISSING,
-- 		MISSING_SKILLS,	-- holds the ids of the missing skills
-- 		SPELLID_HIGHEST_KNOWN_RANK, -- holds the id of the spell of the highest known rank (Apprentice, Journeyman, Expert or Artisan)
MTSL_CURRENT_TRADESKILL = {}

-- Use seperate variable to link to the missing skills
-- We dont want to save full info of each skill with the char, ids will do
MTSL_MISSING_TRADESKILLS = {}

-- Hols the curent phase of the content patches on live servers
MTSL_CURRENT_PHASE = 1
-- Hols the max phase of game to ever be released on live servers
MTSL_MAX_PHASE = 6

-- array holding all reputation levels
MTSL_REPUTATION_LEVELS = {
    ["Unknown"] = 0,
    ["Hated"] = 1,
    ["Hostile"] = 2,
    ["Unfriendly"] = 3,
    ["Neutral"] = 4,
    ["Friendly"] = 5,
    ["Honored"] = 6,
    ["Revered"] = 7,
    ["Exalted"] = 8
}

MTSL_NAME_PROFESSIONS = {
    "Alchemy",
    "Blacksmithing",
    "Enchanting",
    "Engineering",
    "Leatherworking",
    "Mining",
    "Tailoring",
    "Cooking",
    "First Aid"
}