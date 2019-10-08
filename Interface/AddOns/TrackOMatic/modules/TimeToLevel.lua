local L = LibStub("AceLocale-3.0"):GetLocale("TrackOMatic", true);
local PLUGIN;

local session = {
    Started = false;
    StartTime = 0,
    LastLevel = 0,
    LastXP = 0,
    AccumXP = 0,
    TotalXP = 0,
    LevelStartTime = 0,
    LevelStartXP = 0,
    PredictedLevelUpTime = 0,
    LastRecalc = 0,
};

function TrackOMatic_TimeToLevel_Initialize()
    PLUGIN:SetCategory("player");
    PLUGIN:SetOnStartup(TrackOMatic_TimeToLevel_OnStartup);
    PLUGIN:SetOnUpdate(TrackOMatic_TimeToLevel_OnUpdate);
    PLUGIN:SetOnEvent(TrackOMatic_TimeToLevel_OnEvent);
end

function TrackOMatic_TimeToLevel_OnStartup()
    TrackOMatic_TimeToLevel_StartSession();
end

function TrackOMatic_TimeToLevel_StartSession()
    if (not session.Started) then
        session.Started = true;
        session.StartTime = GetTime();
        session.LevelStartTime = GetTime();
        session.LastXP = UnitXP("player");
        session.LastLevel = UnitLevel("player");
        session.LevelStartXP = UnitXP("player");
        session.AccumXP = 0;
        session.TotalXP = 0;
    end
end

function TrackOMatic_TimeToLevel_OnUpdate()

    local label = L["PLAYER_INFO_TIME_TO_LEVEL"];
    local valueText = "";
    local value = 0;
    local max = 1;
    local tooltipText = "";
    local color = { r = 0, g = 1, b = 0.5 };
    local tooltipTitle = L["PLAYER_INFO_TIME_TO_LEVEL"];

    if (UnitLevel("player") == TrackOMatic_GetLevelCap()) then
        value = 1;
        tooltipText = L["YOU_ARE_AT_MAX_LEVEL"];
        color = { r = 0.5, g = 0.5, b = 0.5 };
        valueText = L["MAX_LEVEL"];
    else
        if (session.TotalXP > 0) then
            -- basic calculation from xp per hour
            local totalHoursPlayed = (GetTime() - session.StartTime) / 3600;
            local levelHoursPlayed = (GetTime() - session.LevelStartTime) / 3600;
            local xpPerHour = math.floor(session.TotalXP / totalHoursPlayed);
            local xpRemaining = UnitXPMax("player") - UnitXP("player");
            local hoursToLevel = xpRemaining / math.max(1, xpPerHour);
            local basic = (levelHoursPlayed + hoursToLevel) * 3600;
            -- get the precalculated predicted time of leveling up (recalculate if it's been at least a minute since last xp update)
            if ((GetTime() - session.LastRecalc) >= 60) then
                TrackOMatic_TimeToLevel_RecalculatePrediction();
            end
            local predicted = (session.PredictedLevelUpTime - session.LevelStartTime) * 1.25;
            -- set the bar values
            max = math.max(1, math.max(math.floor(predicted), math.floor(basic)));
            value = math.min(max, math.floor(GetTime() - session.LevelStartTime));
            valueText = TrackOMatic_TimeToLevel_CalcTimeDisplay((max - value) / 3600);
            if (TRACKOMATIC_VARS['config']['reverse_leveling_bars']) then
                value = max - value;
            end
            
            tooltipText = string.format(L["XP_TO_LEVEL"], BreakUpLargeNumbers(xpRemaining));
            tooltipText = tooltipText .. "\n\n" .. string.format(L["XP_PER_HOUR"], BreakUpLargeNumbers(xpPerHour));
            tooltipText = tooltipText .. "\n" .. string.format(L["XP_GAINED"], BreakUpLargeNumbers(session.TotalXP));
            tooltipText = tooltipText .. "\n\n" .. string.format(L["TIME_PLAYED_SESSION"], TrackOMatic_TimeToLevel_CalcTimeDisplay(totalHoursPlayed));
            tooltipText = tooltipText .. "\n" .. string.format(L["TIME_PLAYED_LEVEL"], TrackOMatic_TimeToLevel_CalcTimeDisplay(levelHoursPlayed));
            tooltipText = tooltipText .. "\n" .. string.format(L["TIME_TO_LEVEL"], TrackOMatic_TimeToLevel_CalcTimeDisplay(hoursToLevel));
        else
            valueText = L["N/A"];
        end
    end

    
    return value, max, color, label, valueText, tooltipTitle, tooltipText, nil, false;
end

function TrackOMatic_TimeToLevel_OnEvent(event, ...)
    if (event == "PLAYER_ENTERING_WOIRLD") then
        TrackOMatic_TimeToLevel_StartSession();
    elseif (event == "PLAYER_XP_UPDATE") then
        local unit = ...;
        if (unit == "player") then
            TrackOMatic_TimeToLevel_StartSession();
            local xp = UnitXP("player");
            local xpgain = xp - session.LastXP;
            if (xpgain < 0) then xpgain = 0; end
            session.LastXP = xp;
            session.TotalXP = (xp - session.LevelStartXP) + session.AccumXP;
            TrackOMatic_TimeToLevel_RecalculatePrediction();
        end
    elseif (event == "PLAYER_LEVEL_UP") then
        session.AccumXP = session.AccumXP + UnitXPMax("player") - session.LevelStartXP;
        session.LevelStartXP = 0;
        session.LevelStartTime = GetTime();
        TrackOMatic_TimeToLevel_RecalculatePrediction();
    end
end

function TrackOMatic_TimeToLevel_RecalculatePrediction()
    local totalHoursPlayed = (GetTime() - session.StartTime) / 3600;
    local xpPerHour = math.floor(session.TotalXP / totalHoursPlayed);
    local xpRemaining = UnitXPMax("player") - UnitXP("player");
    local hoursToLevel = xpRemaining / math.max(1, xpPerHour);
    session.PredictedLevelUpTime = GetTime() + (hoursToLevel * 3600);
    session.LastRecalc = GetTime();
end

function TrackOMatic_TimeToLevel_CalcTimeDisplay(hoursToLevel)
    local hours = math.floor(hoursToLevel);
    local minutes = math.floor(hoursToLevel * 60) % 60;
    local seconds = math.floor(hoursToLevel * 3600) % 60;
    return hours .. "h " .. minutes .. "m " .. seconds .. "s";
end

PLUGIN = TrackOMatic_CreateModule("_TimeToLevel", "Time to Level", TrackOMatic_TimeToLevel_Initialize);
