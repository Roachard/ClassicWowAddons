local L = LibStub("AceLocale-3.0"):GetLocale("TrackOMatic", true);

local BAR_CAT;
local BAR_ID;

local SELECTED_TYPE = 0;
local SELECTED_VALUE = 0;

function TrackOMatic_SetupCustomGlow(category, data)

    BAR_CAT = category;
    BAR_ID = data.id;
    
    if (data.customGlow) then
        SELECTED_TYPE = (data.customGlow['threshold_type'] or 0);
        SELECTED_VALUE = (data.customGlow['threshold_value'] or 0);
    else
        SELECTED_TYPE = 0;
        SELECTED_VALUE = data.goal or 0;
    end
    
    TrackOMatic_GlowRuleInput:Show();
    TrackOMatic_GlowRuleInput_SetDefaultCondition();

end

function TrackOMatic_SetupGlowRuleInput()

    TrackOMatic_GlowRuleInputHeader:SetText(L["SETUP_CUSTOM_GLOW_RULE"]);

    TrackOMatic_GlowRuleInputConditionLabel:SetText(L["CONDITION"]);
    UIDropDownMenu_Initialize(TrackOMatic_GlowRuleInput_Condition, TrackOMatic_GlowRuleInput_InitConditionSelect);
    UIDropDownMenu_SetWidth(TrackOMatic_GlowRuleInput_Condition, 150);
    UIDropDownMenu_JustifyText(TrackOMatic_GlowRuleInput_Condition, "LEFT");

end

function TrackOMatic_GlowRuleInput_InitConditionSelect()
    UIDropDownMenu_AddButton({ text = L["GLOW_RULE_CONDITION_VALUE_ABOVE"], value = 0, func = function()   TrackOMatic_GlowRuleInput_SetSelectedCondition(0); end });
    UIDropDownMenu_AddButton({ text = L["GLOW_RULE_CONDITION_VALUE_BELOW"], value = 1, func = function()   TrackOMatic_GlowRuleInput_SetSelectedCondition(1); end });
    UIDropDownMenu_AddButton({ text = L["GLOW_RULE_CONDITION_PERCENT_ABOVE"], value = 2, func = function() TrackOMatic_GlowRuleInput_SetSelectedCondition(2); end });
    UIDropDownMenu_AddButton({ text = L["GLOW_RULE_CONDITION_PERCENT_BELOW"], value = 3, func = function() TrackOMatic_GlowRuleInput_SetSelectedCondition(3); end });
end

function TrackOMatic_GlowRuleInput_OnDropDownClick(self)
    ToggleDropDownMenu(1, nil, self, self:GetName(), 0, 0);
end

function TrackOMatic_GlowRuleInput_SetDefaultCondition()
    ToggleDropDownMenu(1, nil, TrackOMatic_GlowRuleInput_Condition, "TrackOMatic_GlowRuleInput_Condition", 0, 0);
    UIDropDownMenu_SetSelectedValue(TrackOMatic_GlowRuleInput_Condition, SELECTED_TYPE);
    ToggleDropDownMenu(1, nil, TrackOMatic_GlowRuleInput_Condition, "TrackOMatic_GlowRuleInput_Condition", 0, 0);
    TrackOMatic_GlowRuleInput_Threshold:SetText(SELECTED_VALUE);
end

function TrackOMatic_GlowRuleInput_SetSelectedCondition(value)
    UIDropDownMenu_SetSelectedValue(TrackOMatic_GlowRuleInput_Condition, value);
end

function TrackOMatic_GlowRuleInput_OnSubmit()

    if (BAR_CAT and BAR_ID) then
        if (TRACKOMATIC_VARS[TrackOMatic.Profile]['categories'][BAR_CAT]) then
            for index, data in pairs(TRACKOMATIC_VARS[TrackOMatic.Profile]['categories'][BAR_CAT].entries) do
                if (data.id == BAR_ID) then
                    TRACKOMATIC_VARS[TrackOMatic.Profile]['categories'][BAR_CAT].entries[index].customGlow = {
                        ['threshold_type'] = UIDropDownMenu_GetSelectedValue(TrackOMatic_GlowRuleInput_Condition),
                        ['threshold_value'] = (tonumber(TrackOMatic_GlowRuleInput_Threshold:GetText()) or 0),
                    };
                end
            end
        end
    end

    TrackOMatic_GlowRuleInput:Hide();
    TrackOMatic_UpdateTracker(1);

end
