---InstanceResetAnnouncer---
--Novaspark-Firemaw EU (classic) / Venomisto-Frostmourne OCE (retail).
--https://www.curseforge.com/members/venomisto/projectsd
--Simple instance reset announce to party/raid chat if you are the group leader.
--This is very basic with not much fail to reset checking.
--Reset fails seem to almost never happen, even if someone is inside it still resets the group instance.

local function sendOutput(msg)
	if UnitIsGroupLeader("player") then
		if IsInRaid() then
  			SendChatMessage(msg, "RAID");
  		elseif IsInGroup() then
  			SendChatMessage(msg, "PARTY");
  		end
  	end
end

local function resetAnnounce()
	if not UnitIsGroupLeader("player") then
		return;
	end
  	sendOutput("<重置所有副本>");
end

hooksecurefunc("ResetInstances", resetAnnounce)

local f = CreateFrame("Frame")
f:RegisterEvent("CHAT_MSG_SYSTEM")
f:SetScript('OnEvent', function(self, event, msg)
	if (string.match(msg, string.gsub(INSTANCE_RESET_SUCCESS, "%%s", ".+"))) then
		sendOutput(msg);
	elseif (string.match(msg, string.gsub(INSTANCE_RESET_FAILED, "%%s", ".+"))) then
		local instance = string.match(msg, string.gsub(INSTANCE_RESET_FAILED, "%%s", "(.+)"));
		sendOutput(instance .. " 已重置, 但仍有玩家在旧副本.");
	elseif (string.match(msg, string.gsub(INSTANCE_RESET_FAILED_ZONING, "%%s", ".+"))) then
		local instance = string.match(msg, string.gsub(INSTANCE_RESET_FAILED, "%%s", "(.+)"));
		sendOutput(msg);
	elseif (string.match(msg, string.gsub(INSTANCE_RESET_FAILED_OFFLINE, "%%s", ".+"))) then
		local instance = string.match(msg, string.gsub(INSTANCE_RESET_FAILED, "%%s", "(.+)"));
		sendOutput(msg);
	end
end)

--Gloabl strings
--INSTANCE_RESET_FAILED = "Cannot reset %s.  There are players still inside the instance.";
--INSTANCE_RESET_FAILED_OFFLINE = "Cannot reset %s.  There are players offline in your party.";
--INSTANCE_RESET_FAILED_ZONING = "Cannot reset %s.  There are players in your party attempting to zone into an instance.";
--INSTANCE_RESET_SUCCESS = "%s has been reset.";