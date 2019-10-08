-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

local _, TSM = ...
local General = TSM.MainUI.Settings.Tooltip:NewPackage("General")
local L = TSM.L
local private = { operationModules = {} }



-- ============================================================================
-- Module Functions
-- ============================================================================

function General.OnInitialize()
	TSM.MainUI.Settings.Tooltip.RegisterTooltipPage(L["Main Settings"], private.GetTooltipSettingsFrame)
end



-- ============================================================================
-- Tooltip Settings UI
-- ============================================================================

function private.GetTooltipSettingsFrame()
	TSM.UI.AnalyticsRecordPathChange("main", "settings", "tooltips", "main")
	wipe(private.operationModules)
	for _, moduleName in TSM.Operations.ModuleIterator() do
		tinsert(private.operationModules, moduleName)
	end
	return TSMAPI_FOUR.UI.NewElement("ScrollFrame", "tooltipSettings")
		:SetStyle("padding.left", 12)
		:SetStyle("padding.right", 12)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "header")
			:SetStyle("height", 20)
			:SetStyle("margin.bottom", 16)
			:SetStyle("font", TSM.UI.Fonts.MontserratBold)
			:SetStyle("fontHeight", 16)
			:SetStyle("textColor", "#ffffff")
			:SetText(L["General Options"])
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "toggleRow")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 20)
			:SetStyle("margin.bottom", 24)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "label")
				:SetStyle("margin.right", 8)
				:SetStyle("autoWidth", true)
				:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
				:SetStyle("fontHeight", 12)
				:SetText(L["Enable TSM Tooltips"])
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("ToggleOnOff", "enableToggle")
				:SetSettingInfo(TSM.db.global.tooltipOptions, "enabled")
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Spacer", "spacer"))
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "labelRow1")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 18)
			:SetStyle("margin.bottom", 4)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "priceFormatLabel")
				:SetStyle("margin.right", 16)
				:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
				:SetStyle("fontHeight", 14)
				:SetStyle("textColor", "#ffffff")
				:SetText(L["Tooltip Price Format"])
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "modifierLabel")
				:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
				:SetStyle("fontHeight", 14)
				:SetStyle("textColor", "#ffffff")
				:SetText(L["Show on Modifier"])
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "dropdownRow1")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 26)
			:SetStyle("margin.bottom", 16)
			:AddChild(TSMAPI_FOUR.UI.NewElement("SelectionDropdown", "priceFormatDropdown")
				:SetStyle("margin.right", 16)
				:AddItem(format(L["Coins (%s)"], TSM.Money.ToString(3451267, nil, "OPT_ICON")), "icon")
				:AddItem(format(L["Text (%s)"], TSM.Money.ToString(3451267)), "text")
				:SetSettingInfo(TSM.db.global.tooltipOptions, "tooltipPriceFormat")
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("SelectionDropdown", "modifierDropdown")
				:AddItem(L["None (Always Show)"], "none")
				:AddItem(ALT_KEY, "alt")
				:AddItem(CTRL_KEY, "ctrl")
				:SetSettingInfo(TSM.db.global.tooltipOptions, "tooltipShowModifier")
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "labelRow2")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 18)
			:SetStyle("margin.bottom", 4)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "inventoryLabel")
				:SetStyle("margin.right", 16)
				:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
				:SetStyle("fontHeight", 14)
				:SetStyle("textColor", "#ffffff")
				:SetText(L["Inventory Tooltip Format"])
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("Text", "operationLabel")
				:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
				:SetStyle("fontHeight", 14)
				:SetStyle("textColor", "#ffffff")
				:SetText(L["Display Operation Names"])
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Frame", "dropdownRow2")
			:SetLayout("HORIZONTAL")
			:SetStyle("height", 26)
			:SetStyle("margin.bottom", 16)
			:AddChild(TSMAPI_FOUR.UI.NewElement("SelectionDropdown", "inventoryDropdown")
				:SetStyle("margin.right", 16)
				:AddItem(L["None"], "none")
				:AddItem(L["Simple"], "simple")
				:AddItem(L["Full"], "full")
				:SetSettingInfo(TSM.db.global.tooltipOptions, "inventoryTooltipFormat")
			)
			:AddChild(TSMAPI_FOUR.UI.NewElement("MultiselectionDropdown", "operationDropdown")
				:SetHintText(NO)
				:SetItems(private.operationModules, private.operationModules)
				:SetSettingInfo(TSM.db.global.tooltipOptions, "operationTooltips")
			)
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Checkbox", "embedCheckbox")
			:SetStyle("height", 24)
			:SetStyle("margin.left", -5)
			:SetStyle("margin.bottom", 4)
			:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
			:SetStyle("fontHeight", 12)
			:SetText(L["Embed TSM tooltips"])
			:SetSettingInfo(TSM.db.global.tooltipOptions, "embeddedTooltip")
		)
		:AddChild(TSMAPI_FOUR.UI.NewElement("Checkbox", "groupCheckbox")
			:SetStyle("height", 24)
			:SetStyle("margin.left", -5)
			:SetStyle("margin.bottom", 4)
			:SetStyle("font", TSM.UI.Fonts.MontserratMedium)
			:SetStyle("fontHeight", 12)
			:SetText(L["Display group name"])
			:SetSettingInfo(TSM.db.global.tooltipOptions, "groupNameTooltip")
		)
		:AddChild(TSM.MainUI.Settings.Tooltip.CreateCheckbox(L["Display vendor buy price"], TSM.db.global.tooltipOptions, "vendorBuyTooltip"))
		:AddChild(TSM.MainUI.Settings.Tooltip.CreateCheckbox(L["Display vendor sell price"], TSM.db.global.tooltipOptions, "vendorSellTooltip"))
end
