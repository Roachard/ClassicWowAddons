------------------------------------------------------------------
-- Name: ToggleButton											--
-- Description: Contains all functionality for the togglebutton --
------------------------------------------------------------------
MTSLUI_TOGGLE_BUTTON = MTSL_TOOLS:CopyObject(MTSLUI_BASE_FRAME)

MTSLUI_TOGGLE_BUTTON.FRAME_WITDH = 60
MTSLUI_TOGGLE_BUTTON.FRAME_HEIGHT = 20

---------------------------------------------------------------------------------------
-- Initialises the togglebutton
---------------------------------------------------------------------------------------
function MTSLUI_TOGGLE_BUTTON:Initialise()
	self.ui_frame = MTSLUI_TOOLS:CreateBaseFrame("Button", "MTSLUI_ToggleButton", nil, "UIPanelButtonTemplate", self.FRAME_WITDH, self.FRAME_HEIGHT)
	self.ui_frame:SetText("MTSL")
	self.ui_frame:SetScript("OnClick", function ()
		MTSLUI_MISSING_TRADESKILLS_FRAME:Toggle()
	end)
	-- Hide by default after creating
	self:Hide()
end

---------------------------------------------------------------------------------------
-- Swaps to Craft Mode
---------------------------------------------------------------------------------------
function MTSLUI_TOGGLE_BUTTON:SwapToCraftMode()
	if CraftFrame then
		self:ReanchorToNewParent(CraftFrame)
	end
end

---------------------------------------------------------------------------------------
-- Swaps to TradeSkill Mode
---------------------------------------------------------------------------------------
function MTSLUI_TOGGLE_BUTTON:SwapToTradeSkillMode()
	if TradeSkillFrame then
		self:ReanchorToNewParent(TradeSkillFrame)
	end
end

---------------------------------------------------------------------------------------
-- Reanchors the toggle button to the craft or tradeskill window
--
-- @parent_frame		Object			The parentframe to hook MTSL button to
---------------------------------------------------------------------------------------
function MTSLUI_TOGGLE_BUTTON:ReanchorToNewParent(parent_frame)
	-- gaps to default BLizzard UI
	local gap_left = -33
	local gap_top = -13
	-- Overwrite parenttframe of Blizzard UI to Skillet-Classic addon if installed
	if SkilletFrame then
		parent_frame = SkilletFrame
		gap_left = 0
		gap_top = 0
	end
	if parent_frame ~= nil then
		self.ui_frame:SetParent(parent_frame)
		self.ui_frame:SetPoint("BOTTOMRIGHT", parent_frame, "TOPRIGHT", gap_left, gap_top)
		-- clear any current selection of the craftskill window
		MTSLUI_MISSING_TRADESKILLS_FRAME:NoSkillSelected()
	end
end
