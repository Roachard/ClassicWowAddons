local _, ADDONSELF = ...

local L = setmetatable({}, {
    __index = function(table, key)
        if key then
            table[key] = tostring(key)
        end
        return tostring(key)
    end,
})


ADDONSELF.L = L

local locale = GetLocale()

if locale == 'enUs' then
L["Cannot find battleground %s"] = true
L["New"] = true
L["Old"] = true
L["Perhaps"] = true
L["Quick select"] = true
L["TITLE"] = "Battle Info"
L["TOC_NOTES"] = "Enrich your battleground information. Feedback: farmer1992@gmail.com"

elseif locale == 'deDE' then
--[[Translation missing --]]
--[[ L["Cannot find battleground %s"] = "Cannot find battleground %s"--]] 
--[[Translation missing --]]
--[[ L["New"] = "New"--]] 
--[[Translation missing --]]
--[[ L["Old"] = "Old"--]] 
--[[Translation missing --]]
--[[ L["Perhaps"] = "Perhaps"--]] 
--[[Translation missing --]]
--[[ L["Quick select"] = "Quick select"--]] 
--[[Translation missing --]]
--[[ L["TITLE"] = "Battle Info"--]] 
--[[Translation missing --]]
--[[ L["TOC_NOTES"] = "Enrich your battleground information. Feedback: farmer1992@gmail.com"--]] 

elseif locale == 'esES' then
--[[Translation missing --]]
--[[ L["Cannot find battleground %s"] = "Cannot find battleground %s"--]] 
--[[Translation missing --]]
--[[ L["New"] = "New"--]] 
--[[Translation missing --]]
--[[ L["Old"] = "Old"--]] 
--[[Translation missing --]]
--[[ L["Perhaps"] = "Perhaps"--]] 
--[[Translation missing --]]
--[[ L["Quick select"] = "Quick select"--]] 
--[[Translation missing --]]
--[[ L["TITLE"] = "Battle Info"--]] 
--[[Translation missing --]]
--[[ L["TOC_NOTES"] = "Enrich your battleground information. Feedback: farmer1992@gmail.com"--]] 

elseif locale == 'esMX' then
--[[Translation missing --]]
--[[ L["Cannot find battleground %s"] = "Cannot find battleground %s"--]] 
--[[Translation missing --]]
--[[ L["New"] = "New"--]] 
--[[Translation missing --]]
--[[ L["Old"] = "Old"--]] 
--[[Translation missing --]]
--[[ L["Perhaps"] = "Perhaps"--]] 
--[[Translation missing --]]
--[[ L["Quick select"] = "Quick select"--]] 
--[[Translation missing --]]
--[[ L["TITLE"] = "Battle Info"--]] 
--[[Translation missing --]]
--[[ L["TOC_NOTES"] = "Enrich your battleground information. Feedback: farmer1992@gmail.com"--]] 

elseif locale == 'frFR' then
--[[Translation missing --]]
--[[ L["Cannot find battleground %s"] = "Cannot find battleground %s"--]] 
--[[Translation missing --]]
--[[ L["New"] = "New"--]] 
--[[Translation missing --]]
--[[ L["Old"] = "Old"--]] 
--[[Translation missing --]]
--[[ L["Perhaps"] = "Perhaps"--]] 
--[[Translation missing --]]
--[[ L["Quick select"] = "Quick select"--]] 
--[[Translation missing --]]
--[[ L["TITLE"] = "Battle Info"--]] 
--[[Translation missing --]]
--[[ L["TOC_NOTES"] = "Enrich your battleground information. Feedback: farmer1992@gmail.com"--]] 

elseif locale == 'itIT' then
--[[Translation missing --]]
--[[ L["Cannot find battleground %s"] = "Cannot find battleground %s"--]] 
--[[Translation missing --]]
--[[ L["New"] = "New"--]] 
--[[Translation missing --]]
--[[ L["Old"] = "Old"--]] 
--[[Translation missing --]]
--[[ L["Perhaps"] = "Perhaps"--]] 
--[[Translation missing --]]
--[[ L["Quick select"] = "Quick select"--]] 
--[[Translation missing --]]
--[[ L["TITLE"] = "Battle Info"--]] 
--[[Translation missing --]]
--[[ L["TOC_NOTES"] = "Enrich your battleground information. Feedback: farmer1992@gmail.com"--]] 

elseif locale == 'koKR' then
--[[Translation missing --]]
--[[ L["Cannot find battleground %s"] = "Cannot find battleground %s"--]] 
--[[Translation missing --]]
--[[ L["New"] = "New"--]] 
--[[Translation missing --]]
--[[ L["Old"] = "Old"--]] 
--[[Translation missing --]]
--[[ L["Perhaps"] = "Perhaps"--]] 
--[[Translation missing --]]
--[[ L["Quick select"] = "Quick select"--]] 
--[[Translation missing --]]
--[[ L["TITLE"] = "Battle Info"--]] 
--[[Translation missing --]]
--[[ L["TOC_NOTES"] = "Enrich your battleground information. Feedback: farmer1992@gmail.com"--]] 

elseif locale == 'ptBR' then
--[[Translation missing --]]
--[[ L["Cannot find battleground %s"] = "Cannot find battleground %s"--]] 
--[[Translation missing --]]
--[[ L["New"] = "New"--]] 
--[[Translation missing --]]
--[[ L["Old"] = "Old"--]] 
--[[Translation missing --]]
--[[ L["Perhaps"] = "Perhaps"--]] 
--[[Translation missing --]]
--[[ L["Quick select"] = "Quick select"--]] 
--[[Translation missing --]]
--[[ L["TITLE"] = "Battle Info"--]] 
--[[Translation missing --]]
--[[ L["TOC_NOTES"] = "Enrich your battleground information. Feedback: farmer1992@gmail.com"--]] 

elseif locale == 'ruRU' then
--[[Translation missing --]]
--[[ L["Cannot find battleground %s"] = "Cannot find battleground %s"--]] 
--[[Translation missing --]]
--[[ L["New"] = "New"--]] 
--[[Translation missing --]]
--[[ L["Old"] = "Old"--]] 
--[[Translation missing --]]
--[[ L["Perhaps"] = "Perhaps"--]] 
--[[Translation missing --]]
--[[ L["Quick select"] = "Quick select"--]] 
--[[Translation missing --]]
--[[ L["TITLE"] = "Battle Info"--]] 
--[[Translation missing --]]
--[[ L["TOC_NOTES"] = "Enrich your battleground information. Feedback: farmer1992@gmail.com"--]] 

elseif locale == 'zhCN' then
L["Cannot find battleground %s"] = "找不到战场 %s"
L["New"] = "新"
L["Old"] = "旧"
L["Perhaps"] = "可能"
L["Quick select"] = "快速选择"
L["TITLE"] = "BattleInfo 战场助手"
L["TOC_NOTES"] = "战场信息增强. 反馈: farmer1992@gmail.com"

elseif locale == 'zhTW' then
--[[Translation missing --]]
--[[ L["Cannot find battleground %s"] = "Cannot find battleground %s"--]] 
--[[Translation missing --]]
--[[ L["New"] = "New"--]] 
--[[Translation missing --]]
--[[ L["Old"] = "Old"--]] 
--[[Translation missing --]]
--[[ L["Perhaps"] = "Perhaps"--]] 
--[[Translation missing --]]
--[[ L["Quick select"] = "Quick select"--]] 
--[[Translation missing --]]
--[[ L["TITLE"] = "Battle Info"--]] 
--[[Translation missing --]]
--[[ L["TOC_NOTES"] = "Enrich your battleground information. Feedback: farmer1992@gmail.com"--]] 

end
