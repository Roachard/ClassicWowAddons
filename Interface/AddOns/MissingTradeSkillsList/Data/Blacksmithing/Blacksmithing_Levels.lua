--------------------------
-- Levels Blacksmithing --
--------------------------
MTSL_DATA["Blacksmithing"]["levels"] = {
	{
		["trainers"] = {
			["price"] = 10,
			["sources"] = {
				514,
				957,
				1241,
				1383,
				2836,
				2998,
				3136,
				3174,
				3355,
				3478,
				3557,
				4258,
				4596,
				4605,
				5511,
				6299,
				10266,
				10276,
				10277,
				10278,
			},
		},
		["name"] = {
			["German"] = MTSLUI_LOCALES_PROFESSION_RANKS["German"]["Apprentice"] .. " " .. MTSLUI_LOCALES_PROFESSIONS["German"]["Blacksmithing"],
			["Spanish"] = MTSLUI_LOCALES_PROFESSION_RANKS["Spanish"]["Apprentice"] .. " " .. MTSLUI_LOCALES_PROFESSIONS["Spanish"]["Blacksmithing"],
			["Russian"] = MTSLUI_LOCALES_PROFESSION_RANKS["Russian"]["Apprentice"] .. " " .. MTSLUI_LOCALES_PROFESSIONS["Russian"]["Blacksmithing"],
			["Portuguese"] = MTSLUI_LOCALES_PROFESSION_RANKS["Portuguese"]["Apprentice"] .. " " .. MTSLUI_LOCALES_PROFESSIONS["Portuguese"]["Blacksmithing"],
			["French"] = MTSLUI_LOCALES_PROFESSION_RANKS["French"]["Apprentice"] .. " " .. MTSLUI_LOCALES_PROFESSIONS["French"]["Blacksmithing"],
			["English"] = MTSLUI_LOCALES_PROFESSION_RANKS["English"]["Apprentice"] .. " " .. MTSLUI_LOCALES_PROFESSIONS["English"]["Blacksmithing"],
			["Korean"] = MTSLUI_LOCALES_PROFESSION_RANKS["Korean"]["Apprentice"] .. " " .. MTSLUI_LOCALES_PROFESSIONS["Korean"]["Blacksmithing"],
			["Chinese"] = MTSLUI_LOCALES_PROFESSION_RANKS["Chinese"]["Apprentice"] .. " " .. MTSLUI_LOCALES_PROFESSIONS["Chinese"]["Blacksmithing"],
			["Mexican"] = MTSLUI_LOCALES_PROFESSION_RANKS["Mexican"]["Apprentice"] .. " " .. MTSLUI_LOCALES_PROFESSIONS["Mexican"]["Blacksmithing"],
		},
		["min_skill"] = 0,
		["id"] = 2018,
		["max_skill"] = 75,
		["rank"] = 1,
		["min_xp_level"] = 5,
	},
	{
		["trainers"] = {
			["price"] = 500,
			["sources"] = {
				1383,
				2836,
				2998,
				3136,
				3355,
				3478,
				4258,
				4596,
				5511,
				10276,
			},
		},
		["name"] = {
			["German"] = MTSLUI_LOCALES_PROFESSION_RANKS["German"]["Journeyman"] .. " " .. MTSLUI_LOCALES_PROFESSIONS["German"]["Blacksmithing"],
			["Spanish"] = MTSLUI_LOCALES_PROFESSION_RANKS["Spanish"]["Journeyman"] .. " " .. MTSLUI_LOCALES_PROFESSIONS["Spanish"]["Blacksmithing"],
			["Russian"] = MTSLUI_LOCALES_PROFESSION_RANKS["Russian"]["Journeyman"] .. " " .. MTSLUI_LOCALES_PROFESSIONS["Russian"]["Blacksmithing"],
			["Portuguese"] = MTSLUI_LOCALES_PROFESSION_RANKS["Portuguese"]["Journeyman"] .. " " .. MTSLUI_LOCALES_PROFESSIONS["Portuguese"]["Blacksmithing"],
			["French"] = MTSLUI_LOCALES_PROFESSION_RANKS["French"]["Journeyman"] .. " " .. MTSLUI_LOCALES_PROFESSIONS["French"]["Blacksmithing"],
			["English"] = MTSLUI_LOCALES_PROFESSION_RANKS["English"]["Journeyman"] .. " " .. MTSLUI_LOCALES_PROFESSIONS["English"]["Blacksmithing"],
			["Korean"] = MTSLUI_LOCALES_PROFESSION_RANKS["Korean"]["Journeyman"] .. " " .. MTSLUI_LOCALES_PROFESSIONS["Korean"]["Blacksmithing"],
			["Chinese"] = MTSLUI_LOCALES_PROFESSION_RANKS["Chinese"]["Journeyman"] .. " " .. MTSLUI_LOCALES_PROFESSIONS["Chinese"]["Blacksmithing"],
			["Mexican"] = MTSLUI_LOCALES_PROFESSION_RANKS["Mexican"]["Apprentice"] .. " " .. MTSLUI_LOCALES_PROFESSIONS["Mexican"]["Blacksmithing"],
		},
		["min_skill"] = 50,
		["id"] = 3100,
		["max_skill"] = 150,
		["rank"] = 2,
		["min_xp_level"] = 10,
	},
	{
		["trainers"] = {
			["price"] = 5000,
			["sources"] = {
				2836,
				3355,
				4258,
			},
		},
		["name"] = {
			["German"] = MTSLUI_LOCALES_PROFESSION_RANKS["German"]["Expert"] .. " " .. MTSLUI_LOCALES_PROFESSIONS["German"]["Blacksmithing"],
			["Spanish"] = MTSLUI_LOCALES_PROFESSION_RANKS["Spanish"]["Expert"] .. " " .. MTSLUI_LOCALES_PROFESSIONS["Spanish"]["Blacksmithing"],
			["Russian"] = MTSLUI_LOCALES_PROFESSION_RANKS["Russian"]["Expert"] .. " " .. MTSLUI_LOCALES_PROFESSIONS["Russian"]["Blacksmithing"],
			["Portuguese"] = MTSLUI_LOCALES_PROFESSION_RANKS["Portuguese"]["Expert"] .. " " .. MTSLUI_LOCALES_PROFESSIONS["Portuguese"]["Blacksmithing"],
			["French"] = MTSLUI_LOCALES_PROFESSION_RANKS["French"]["Expert"] .. " " .. MTSLUI_LOCALES_PROFESSIONS["French"]["Blacksmithing"],
			["English"] = MTSLUI_LOCALES_PROFESSION_RANKS["English"]["Expert"] .. " " .. MTSLUI_LOCALES_PROFESSIONS["English"]["Blacksmithing"],
			["Korean"] = MTSLUI_LOCALES_PROFESSION_RANKS["Korean"]["Expert"] .. " " .. MTSLUI_LOCALES_PROFESSIONS["Korean"]["Blacksmithing"],
			["Chinese"] = MTSLUI_LOCALES_PROFESSION_RANKS["Chinese"]["Expert"] .. " " .. MTSLUI_LOCALES_PROFESSIONS["Chinese"]["Blacksmithing"],
			["Mexican"] = MTSLUI_LOCALES_PROFESSION_RANKS["Mexican"]["Expert"] .. " " .. MTSLUI_LOCALES_PROFESSIONS["Mexican"]["Blacksmithing"],
		},
		["min_skill"] = 125,
		["id"] = 3538,
		["max_skill"] = 225,
		["rank"] = 3,
		["min_xp_level"] = 20,
	},
	{
		["min_xp_level"] = 35,
		["trainers"] = {
			["price"] = 50000,
			["sources"] = {
				2836,
			},
		},
		["name"] = {
			["German"] = MTSLUI_LOCALES_PROFESSION_RANKS["German"]["Artisan"] .. " " .. MTSLUI_LOCALES_PROFESSIONS["German"]["Blacksmithing"],
			["Spanish"] = MTSLUI_LOCALES_PROFESSION_RANKS["Spanish"]["Artisan"] .. " " .. MTSLUI_LOCALES_PROFESSIONS["Spanish"]["Blacksmithing"],
			["Russian"] = MTSLUI_LOCALES_PROFESSION_RANKS["Russian"]["Artisan"] .. " " .. MTSLUI_LOCALES_PROFESSIONS["Russian"]["Blacksmithing"],
			["Portuguese"] = MTSLUI_LOCALES_PROFESSION_RANKS["Portuguese"]["Artisan"] .. " " .. MTSLUI_LOCALES_PROFESSIONS["Portuguese"]["Blacksmithing"],
			["French"] = MTSLUI_LOCALES_PROFESSION_RANKS["French"]["Artisan"] .. " " .. MTSLUI_LOCALES_PROFESSIONS["French"]["Blacksmithing"],
			["English"] = MTSLUI_LOCALES_PROFESSION_RANKS["English"]["Artisan"] .. " " .. MTSLUI_LOCALES_PROFESSIONS["English"]["Blacksmithing"],
			["Korean"] = MTSLUI_LOCALES_PROFESSION_RANKS["Korean"]["Artisan"] .. " " .. MTSLUI_LOCALES_PROFESSIONS["Korean"]["Blacksmithing"],
			["Chinese"] = MTSLUI_LOCALES_PROFESSION_RANKS["Chinese"]["Artisan"] .. " " .. MTSLUI_LOCALES_PROFESSIONS["Chinese"]["Blacksmithing"],
			["Mexican"] = MTSLUI_LOCALES_PROFESSION_RANKS["Mexican"]["Artisan"] .. " " .. MTSLUI_LOCALES_PROFESSIONS["Mexican"]["Blacksmithing"],
		},
		["min_skill"] = 200,
		["id"] = 9785,
		["max_skill"] = 300,
		["rank"] = 4,
		["min_xp_level"] = 35,
	},
}