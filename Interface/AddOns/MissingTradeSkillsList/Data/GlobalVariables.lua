-------------------------------------------
-- Creates all global variables for DATA --
-------------------------------------------

-- Holds all the data filled by the data luas
MTSL_DATA = {
    -- Primary Professions (no skinning, herbalism because they don't have a tradeskillframe)
    ["Alchemy"] = {},
    ["Blacksmithing"] = {},
    ["Enchanting"] = {},		-- craft
    ["Engineering"] = {},
    ["Leatherworking"] = {},
    ["Mining"] = {},
    ["Tailoring"] = {},
    -- Secundary professions (no fishing because it doesn't have atradeskillframe)
    ["Cooking"] = {},
    ["First Aid"] = {},
    -- all game items/objects we need in 1 array
    ["Objects"] = {},
    ["NPCs"] = {},
    ["Quests"] = {},
    -- Each profession has 4 levels to learn (1-75, 75-150, 150-225, 225-300)
    TRADESKILL_LEVELS = 4,
    -- Counters keeping track of total amount of items  (counted at start addon)
    AMOUNT_ITEMS = {},
    -- Counters keeping track of total amount of skill  (counted at start addon)
    AMOUNT_SKILLS = {},
    -- holds counters for how many skills can be learned up the current content phase (counted at start addon)
    AMOUNT_SKILLS_CURRENT_PHASE = {},
}