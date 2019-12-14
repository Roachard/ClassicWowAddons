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
L["New"] = true
L["Old"] = true
L["Perhaps"] = true

elseif locale == 'deDE' then
--[[Translation missing --]]
--[[ L["New"] = "New"--]] 
--[[Translation missing --]]
--[[ L["Old"] = "Old"--]] 
--[[Translation missing --]]
--[[ L["Perhaps"] = "Perhaps"--]] 

elseif locale == 'esES' then
--[[Translation missing --]]
--[[ L["New"] = "New"--]] 
--[[Translation missing --]]
--[[ L["Old"] = "Old"--]] 
--[[Translation missing --]]
--[[ L["Perhaps"] = "Perhaps"--]] 

elseif locale == 'esMX' then
--[[Translation missing --]]
--[[ L["New"] = "New"--]] 
--[[Translation missing --]]
--[[ L["Old"] = "Old"--]] 
--[[Translation missing --]]
--[[ L["Perhaps"] = "Perhaps"--]] 

elseif locale == 'frFR' then
--[[Translation missing --]]
--[[ L["New"] = "New"--]] 
--[[Translation missing --]]
--[[ L["Old"] = "Old"--]] 
--[[Translation missing --]]
--[[ L["Perhaps"] = "Perhaps"--]] 

elseif locale == 'itIT' then
--[[Translation missing --]]
--[[ L["New"] = "New"--]] 
--[[Translation missing --]]
--[[ L["Old"] = "Old"--]] 
--[[Translation missing --]]
--[[ L["Perhaps"] = "Perhaps"--]] 

elseif locale == 'koKR' then
--[[Translation missing --]]
--[[ L["New"] = "New"--]] 
--[[Translation missing --]]
--[[ L["Old"] = "Old"--]] 
--[[Translation missing --]]
--[[ L["Perhaps"] = "Perhaps"--]] 

elseif locale == 'ptBR' then
--[[Translation missing --]]
--[[ L["New"] = "New"--]] 
--[[Translation missing --]]
--[[ L["Old"] = "Old"--]] 
--[[Translation missing --]]
--[[ L["Perhaps"] = "Perhaps"--]] 

elseif locale == 'ruRU' then
--[[Translation missing --]]
--[[ L["New"] = "New"--]] 
--[[Translation missing --]]
--[[ L["Old"] = "Old"--]] 
--[[Translation missing --]]
--[[ L["Perhaps"] = "Perhaps"--]] 

elseif locale == 'zhCN' then
L["New"] = "新"
L["Old"] = "旧"
L["Perhaps"] = "可能"

elseif locale == 'zhTW' then
--[[Translation missing --]]
--[[ L["New"] = "New"--]] 
--[[Translation missing --]]
--[[ L["Old"] = "Old"--]] 
--[[Translation missing --]]
--[[ L["Perhaps"] = "Perhaps"--]] 

end
