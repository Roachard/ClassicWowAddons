local L = LibStub("AceLocale-3.0"):GetLocale("TrackOMatic", true);

local ABOUT = {
    author = "Germbread (Deathwing-US, Whitemane-US)",
    email = GetAddOnMetadata("TrackOMatic", "X-Email"),
    hosts = {
        "https://www.curseforge.com/wow/addons",
        "https://www.curseforge.com/wow/addons/track-o-matic",
    },
};

local CONFIG_SHOWN = false;

--========================================
-- Setting up the config frame
--========================================
function TrackOMaticConfig_About_OnLoad(self)
    self.name = L["ABOUT"];
    self.parent = L["ADDON_TITLE"];
    self.okay = function(self) TrackOMaticConfig_About_OnClose(); end;
    self.cancel = function(self) TrackOMaticConfig_About_OnClose(); end;
    self.refresh = function(self) TrackOMaticConfig_About_OnRefresh(); end;
    InterfaceOptions_AddCategory(self);

    TrackOMaticConfigAboutTitle:SetText(string.format(L["VERSION_TEXT"], "|cffffffffv" .. TrackOMatic.Version));
    TrackOMaticConfigAboutAuthor:SetText(L["LABEL_AUTHOR"] .. ": |cffffffff" .. ABOUT.author);
    TrackOMaticConfigAboutEmail:SetText(L["LABEL_EMAIL"] .. ": |cffffffff" .. ABOUT.email);
    TrackOMaticConfigAboutURLs:SetText(L["LABEL_HOSTS"] .. ":");
end

--========================================
-- Refresh
--========================================
function TrackOMaticConfig_About_OnRefresh()
    if (CONFIG_SHOWN) then return; end

    for i = 1, table.maxn(ABOUT.hosts), 1 do
        local fontString = _G["TrackOMaticConfigAbout_SiteList" .. i];
        if (not fontString) then
            fontString = TrackOMaticConfigAbout:CreateFontString("TrackOMaticConfigAbout_SiteList" .. i, "ARTWORK", "GameFontHighlight");
        end
        fontString:ClearAllPoints();
        fontString:SetPoint("TOPLEFT", TrackOMaticConfigAbout, "TOPLEFT", 60, -(145 + (i * 20)));
        fontString:SetText(ABOUT.hosts[i]);
    end

    CONFIG_SHOWN = true;
end

--========================================
-- Closing the window
--========================================
function TrackOMaticConfig_About_OnClose()
    CONFIG_SHOWN = false;
end
