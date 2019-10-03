------------------------------------------------------------------
-- Name: ConfigFrame										    --
-- Description: Set values of user options        				--
-- Parent Frame: OptionsMenuFrame              					--
------------------------------------------------------------------

MTSLOPTUI_CONFIG_FRAME = {
    FRAME_HEIGHT = 240,
    MARGIN_LEFT = 25,
    MARGIN_RIGHT = 275,
    split_mode,

    ---------------------------------------------------------------------------------------
    -- Initialises the titleframe
    ----------------------------------------------------------------------------------------
    Initialise = function (self, parent_frame)
        self.FRAME_WIDTH = MTSLUI_OPTIONS_MENU_FRAME.FRAME_WIDTH
        self.ui_frame = MTSLUI_TOOLS:CreateBaseFrame("Frame", "MTSLOPTUI_SaveFrame", parent_frame, nil, self.FRAME_WIDTH, self.FRAME_HEIGHT, false)
        -- below title frame
        self.ui_frame:SetPoint("TOPLEFT", parent_frame, "BOTTOMLEFT", 0, 0)
        -- Orientation
        self.orientations = {
            {
                ["name"] = MTSLUI_LOCALES_LABELS["vertical"][MTSLUI_CURRENT_LANGUAGE],
                ["id"] = 1,
            },
            {
                ["name"] = MTSLUI_LOCALES_LABELS["horizontal"][MTSLUI_CURRENT_LANGUAGE],
                ["id"] = 2,
            }
        }
        -- create a filter for sorting
        -- create the sort frame with text and 2 buttons
        self.ui_frame.orientation_text = MTSLUI_TOOLS:CreateLabel(self.ui_frame, "MTSL Split (Only on main frame!)", self.MARGIN_LEFT, -15, "NORMAL", "TOPLEFT")
        self.ui_frame.orientation_drop_down = CreateFrame("Frame", "MTSLOPTUI_CONFIG_FRAME_DD_ORIENTATION", self.ui_frame, "UIDropDownMenuTemplate")
        self.ui_frame.orientation_drop_down:SetPoint("TOPLEFT", self.ui_frame, "TOPLEFT", self.MARGIN_RIGHT, -8)
        self.ui_frame.orientation_drop_down.initialize = self.CreateDropDownOrientation
        UIDropDownMenu_SetWidth(self.ui_frame.orientation_drop_down, 200)
        UIDropDownMenu_SetText(self.ui_frame.orientation_drop_down, MTSLUI_LOCALES_LABELS[string.lower(MTSLUI_SAVED_VARIABLES:GetSplitMode())][MTSLUI_CURRENT_LANGUAGE])
        -- Fonts
        self.fonts = {
            {
                ["name"] = "2002",
                ["id"] = 1,
            },
            {
                ["name"] = "Arial Narrow",
                ["id"] = 2,
            },
            {
                ["name"] = "Arkai",
                ["id"] = 3,
            },
            {
                ["name"] = "Friz Quadrata",
                ["id"] = 4,
            },
            {
                ["name"] = "Morpheus",
                ["id"] = 5,
            },
            {
                ["name"] = "Skurri",
                ["id"] = 6,
            },
        }
        --skurri.ttf
        --ARIALN.ttf
        --MORPHEUS.ttf
        --FRIZQT__.ttf
        --ARKai_T.ttf
        --2002.ttf
        -- build list of realms
        -- create a filter for sorting
        -- create the sort frame with text and 2 buttons
        self.ui_frame.fonts_text = MTSLUI_TOOLS:CreateLabel(self.ui_frame, "Font (Not yet working!)", self.MARGIN_LEFT, -49, "NORMAL", "TOPLEFT")
        self.ui_frame.fonts_drop_down = CreateFrame("Frame", "MTSLOPTUI_CONFIG_FRAME_DD_FONTS", self.ui_frame, "UIDropDownMenuTemplate")
        self.ui_frame.fonts_drop_down:SetPoint("TOPLEFT", self.ui_frame, "TOPLEFT", self.MARGIN_RIGHT, -40)
        self.ui_frame.fonts_drop_down.initialize = self.CreateDropDownFonts
        UIDropDownMenu_SetWidth(self.ui_frame.fonts_drop_down, 200)
        UIDropDownMenu_SetText(self.ui_frame.fonts_drop_down, "Friz Quadrata")
        -- Scale UI
        self.ui_frame.slider_main_text = MTSLUI_TOOLS:CreateLabel(self.ui_frame, "UI Scale MTSL frame", self.MARGIN_LEFT, -90, "NORMAL", "TOPLEFT")
        self.slider_main = MTSL_TOOLS:CopyObject(MTSLUI_HORIZONTAL_SLIDER)
        self.slider_main:Initialise(self.ui_frame, MTSLUI_SAVED_VARIABLES:GetScale("MTSL"))
        self.slider_main.ui_frame:SetPoint("TOPLEFT", self.ui_frame, "TOPLEFT", self.MARGIN_RIGHT + 7, -70)

        self.ui_frame.slider_account_text = MTSLUI_TOOLS:CreateLabel(self.ui_frame, "UI Scale Account explorer", self.MARGIN_LEFT, -130, "NORMAL", "TOPLEFT")
        self.slider_account = MTSL_TOOLS:CopyObject(MTSLUI_HORIZONTAL_SLIDER)
        self.slider_account:Initialise(self.ui_frame, MTSLUI_SAVED_VARIABLES:GetScale("ACCOUNT"))
        self.slider_account.ui_frame:SetPoint("TOPLEFT", self.ui_frame, "TOPLEFT", self.MARGIN_RIGHT + 7, -110)

        self.ui_frame.slider_database_text = MTSLUI_TOOLS:CreateLabel(self.ui_frame, "UI Scale Database Explorer", self.MARGIN_LEFT, -170, "NORMAL", "TOPLEFT")
        self.slider_database = MTSL_TOOLS:CopyObject(MTSLUI_HORIZONTAL_SLIDER)
        self.slider_database:Initialise(self.ui_frame, MTSLUI_SAVED_VARIABLES:GetScale("DATABASE"))
        self.slider_database.ui_frame:SetPoint("TOPLEFT", self.ui_frame, "TOPLEFT", self.MARGIN_RIGHT + 7, -150)

        self.ui_frame.slider_options_text = MTSLUI_TOOLS:CreateLabel(self.ui_frame, "UI Scale Options menu", self.MARGIN_LEFT, -210, "NORMAL", "TOPLEFT")
        self.slider_options = MTSL_TOOLS:CopyObject(MTSLUI_HORIZONTAL_SLIDER)
        self.slider_options:Initialise(self.ui_frame, MTSLUI_SAVED_VARIABLES:GetScale("OPTIONSMENU"))
        self.slider_options.ui_frame:SetPoint("TOPLEFT", self.ui_frame, "TOPLEFT", self.MARGIN_RIGHT + 7, -190)
    end,

    ----------------------------------------------------------------------------------------------------------
    -- Intialises drop down for split orientation
    ----------------------------------------------------------------------------------------------------------
    CreateDropDownOrientation = function(self, level)
        MTSLUI_TOOLS:FillDropDown(level, MTSLOPTUI_CONFIG_FRAME.orientations, MTSLOPTUI_CONFIG_FRAME.ChangeOrientationHandler)
    end,

    --------------------------------------------------------------------------------------
    -- Handles DropDown Change event after changing the sorting
    ----------------------------------------------------------------------------------------------------------
    ChangeOrientationHandler = function(value, text)
        if value == 1 then
            MTSLOPTUI_CONFIG_FRAME.split_mode = "Vertical"
        else
            MTSLOPTUI_CONFIG_FRAME.split_mode = "Horizontal"
        end
        UIDropDownMenu_SetText(MTSLOPTUI_CONFIG_FRAME.ui_frame.orientation_drop_down, text)
    end,

    ----------------------------------------------------------------------------------------------------------
    -- Intialises drop down for fonts
    ----------------------------------------------------------------------------------------------------------
    CreateDropDownFonts = function(self, level)
        MTSLUI_TOOLS:FillDropDown(level, MTSLOPTUI_CONFIG_FRAME.fonts, MTSLOPTUI_CONFIG_FRAME.ChangeFontsHandler)
    end,

    --------------------------------------------------------------------------------------
    -- Handles DropDown Change event after changing the sorting
    ----------------------------------------------------------------------------------------------------------
    ChangeFontsHandler = function(value, text)
        UIDropDownMenu_SetText(MTSLOPTUI_CONFIG_FRAME.ui_frame.fonts_drop_down, text)
    end,

    Save = function(self)
        MTSLUI_SAVED_VARIABLES:SetSplitMode(self.split_mode)
        local scales = {
            MTSL = self.slider_main:GetActualSliderValue(),
            ACCOUNT = self.slider_account:GetActualSliderValue(),
            DATABASE = self.slider_database:GetActualSliderValue(),
            OPTIONSMENU = self.slider_options:GetActualSliderValue(),
        }
        MTSLUI_SAVED_VARIABLES:SetScales(scales)
    end,
}