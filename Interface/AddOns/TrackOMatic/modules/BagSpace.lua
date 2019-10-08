local L = LibStub("AceLocale-3.0"):GetLocale("TrackOMatic", true);
local PLUGIN;

local SUPPRESS_LEVEL = 0;
local LOW_SPACE_MODE = 0;
local LAST_DISPLAYED_PERCENT = -1;

local LOW_SPACE_PERCENT_THRESHOLD = 5;
local LOW_SPACE_SLOTS_THRESHOLD = 2;

local PROF_BAG_IDS = {
    22246, 30748, 67389, 22248, 22249, 21858, 41598, 54445,     -- enchanting bags
    30745, 67390, 23774, 23775, 60217,                          -- engineering
    30747, 67392, 24270, 70138,                                 -- gem bags
    22250, 67393, 22251, 22252, 38225, 45773, 54446,            -- herb bags
    39489, 67394, 44446, 70136, 116261, 162588,                 -- inscription
    67395, 34482, 34490, 38399, 116259, 95536,                  -- leatherworking
    30746, 67396, 29540, 38347, 70137, 116260,                  -- mining
    60218,                                                      -- tackle boxes
    92747, 130943, 92748,                                       -- cooking bags
};


function TrackOMatic_BagSpace_Initialize()
    PLUGIN:SetCategory("player");
    PLUGIN:SetOnUpdate(TrackOMatic_BagSpace_OnUpdate);
    PLUGIN:SetOnSuppressAlert(TrackOMatic_BagSpace_OnSuppressAlert);
end

local function isProfessionBag(bag)
    if ((bag >= 1) or (bag <= 4)) then
        local id = GetInventoryItemID("player", 19 + bag);
        if (id) then
            for i = 1, table.maxn(PROF_BAG_IDS), 1 do
                if (id == PROF_BAG_IDS[i]) then
                    return true;
                end
            end
        end
    end
    return false;
end

local function getTotalSlots(normalOnly)
    local slots = 0;
    for i = 0, 4, 1 do
        if ((not normalOnly) or (not isProfessionBag(i))) then
            slots = slots + GetContainerNumSlots(i);
        end
    end
    return slots;
end

local function getFreeSlots(normalOnly)
    local slots = 0;
    for i = 0, 4, 1 do
        if ((not normalOnly) or (not isProfessionBag(i))) then
            slots = slots + GetContainerNumFreeSlots(i);
        end
    end
    return slots;
end

local function switchCountMode(oldState)
    PLUGIN:SetData("includeProf", (not oldState));
    PLUGIN:UpdateTracker();
end

local function switchFillMode(oldState)
    PLUGIN:SetData("invertFill", (not oldState));
    PLUGIN:UpdateTracker();
end

function TrackOMatic_BagSpace_OnUpdate()

    local includeProf = PLUGIN:GetValue("includeProf");
    local invertFill = PLUGIN:GetValue("invertFill");

    local numFreeSlots = getFreeSlots(not includeProf);
    local max = math.max(1, getTotalSlots(not includeProf));

    local tooltipTitle = L["FREE_BAG_SPACE"];
    local tooltipText = ExtVendor_FormatString(L["TOOLTIP_SLOTS_FREE"], { ["slotsFree"] = numFreeSlots, ["totalSlots"] = max }); --numFreeSlots .. " of " .. max .. " slots free";
    if (not includeProf) then
        tooltipText = tooltipText .. "\n" .. L["TOOLTIP_PROFESSION_BAGS_IGNORED"];
    end

    local percentFree = math.floor((numFreeSlots / max) * 100);
    local color = {r = (math.min(50, 100 - percentFree) / 50), g = (math.min(50, percentFree) / 50) * 0.75, b = 0};
    local percentShow = percentFree;

    local menu = {
        { text = "Include profession bags", checked = includeProf, func = function() switchCountMode(includeProf); end },
        { text = "Invert Fill Mode (Show Free Space)", checked = invertFill, func = function() switchFillMode(invertFill); end },
    };

    local barLabel = L["BAR_LABEL_FREE_SPACE"];
    local barValue = numFreeSlots;
    if (not invertFill) then
        barLabel = L["BAR_LABEL_USED_SPACE"];
        barValue = max - numFreeSlots;
        percentShow = 100 - percentFree;
    else
        if (numFreeSlots == 0) then
            barValue = max;
        end
    end

    local alertText = "";
    local alertMessageToUse = "";
    local isGlowing = false;
    if ((percentFree <= LOW_SPACE_PERCENT_THRESHOLD) or (numFreeSlots <= LOW_SPACE_SLOTS_THRESHOLD)) then
        if (numFreeSlots == 0) then
            alertMessageToUse = L["OUT_OF_BAG_SPACE"];
            LOW_SPACE_MODE = 2;
        else
            alertMessageToUse = L["LOW_BAG_SPACE"];
            LOW_SPACE_MODE = 1;
        end
        isGlowing = true;
    else
        SUPPRESS_LEVEL = 0;
        LOW_SPACE_MODE = 0;
    end
    SUPPRESS_LEVEL = math.min(LOW_SPACE_MODE, SUPPRESS_LEVEL);
    if (LOW_SPACE_MODE < SUPPRESS_LEVEL) then
        alertText = alertMessageToUse;
    end

    return barValue, max, color, barLabel, barValue .. "/" .. max .. " (" .. percentShow .. "%)", tooltipTitle, tooltipText, menu, isGlowing, nil, alertText;

end

function TrackOMatic_BagSpace_OnSuppressAlert()

    SUPPRESS_LEVEL = LOW_SPACE_MODE;

end

PLUGIN = TrackOMatic_CreateModule("_BagSpace", "Bag Space", TrackOMatic_BagSpace_Initialize);
