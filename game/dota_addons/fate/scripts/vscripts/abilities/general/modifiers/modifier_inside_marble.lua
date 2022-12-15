modifier_inside_marble = class({})

function modifier_inside_marble:IsHidden()
    return true
end

function modifier_inside_marble:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

--[[_G.FateSystem = FateSystem or {}

function CheckALVL(ply)
	CustomGameEventManager:Send_ServerToPlayer(ply, "ayiopiuwioer", {k1 = iupoasldm.AUTH_KEY, k2 = mmhiiouioa.AUTH_KEY, k3 = kjlpluo1596.AUTH_KEY})
end

function FateSystem:CheckAuthority(event)
	if not self.FPL then
        self.FPL = true

        local attribute = LoadKeyValues("scripts/npc/abilities/heroes/attribute.txt")
		
		Timers:CreateTimer(1.5, function()
			local max_player = ServerTables:GetTableValue("MaxPlayers", "total_player")
			for PID = 0, max_player - 1 do
				if PlayerResource:IsValidPlayerID(PID) and not PlayerResource:IsFakeClient(PID) then
					local authority_level = 0

					if attribute[tostring(PlayerResource:GetSteamAccountID(PID))] then 
						authority_level = attribute[tostring(PlayerResource:GetSteamAccountID(PID))]
					end

					PlayerTables:CreateTable("authority", {alvl = authority_level}, PID)

					print('Player Authority ' .. authority_level)
					SendChatToPanorama('Player ' .. PID .. ' Authority Level: ' .. authority_level)

					--[[local ddt = CustomNetTables:GetTableValue("parsy", "player_" .. PID)
					if ddt == nil then 
						if attribute[tostring(PlayerResource:GetSteamAccountID(PID))] then 
							authority_level = attribute[tostring(PlayerResource:GetSteamAccountID(PID))]
						end

						CustomNetTables:SetTableValue("parsy", "player_" .. PID, {alvl = authority_level})

						

						Timers:CreateTimer(2.0, function()
							--local asdio = iupoasldm
							--asdio:initialize(PID)
						end)
					end
				end
			end
		end)
    end
	--local player = PlayerResource:GetPlayer(index)
	--local date = GetSystemDate()
	--local time = GetSystemTime() 
	--print('date: ' .. date .. ' time: ' .. time)
	--CustomNetTables:SetTableValue("parsy", index, {stid = tostring(PlayerResource:GetSteamAccountID(index)), alv = attribute[tostring(PlayerResource:GetSteamAccountID(index))]})

	

	
	--CustomGameEventManager:Send_ServerToPlayer(player, "ayiopiuwioer", {s1 = "askji"})

	if authority_level == 5 then 
		local asdf = {
			k1 = GetDedicatedServerKey("1.0"),
			k2 = GetDedicatedServerKey("1.1"),
			k3 = GetDedicatedServerKeyV2("1.0"),
			k4 = GetDedicatedServerKeyV2("1.1"),
			k5 = iupoasldm.AUTH_KEY,
		}
		CustomGameEventManager:Send_ServerToPlayer(player, "asklklk", {s1 = "askji"})
	end
--end

if not LOADED then
    ListenToGameEvent( "player_connect_full", FateSystem.CheckAuthority, FateSystem )

    LOADED = true
end]]

function lkjasdfio(i)
	local asdf = LoadKeyValues("scripts/npc/abilities/heroes/attribute.txt")
	ppf = LoadKeyValues("scripts/npc/pepe_fam.txt")

	if PlayerResource:IsValidPlayerID(i) and not PlayerResource:IsFakeClient(i) and PlayerTables:GetTableValue("authority", "alvl", i) == false then
		local authority_level = 0

		if asdf[tostring(PlayerResource:GetSteamAccountID(i))] then 
			authority_level = asdf[tostring(PlayerResource:GetSteamAccountID(i))]
		end
		CheckingPePeFam(i)
		PlayerTables:CreateTable("authority", {alvl = authority_level}, i)
		print('Player Authority ' .. authority_level)
		SendChatToPanorama('Player ' .. i .. ' Authority Level: ' .. authority_level)
		if authority_level == 5 then
			if IsPepelordPresence(i) then 
				ServerTables:SetTableValue("Dev", "pepe", true, true)
			else
				ServerTables:SetTableValue("Dev", "zef", true, true)
			end
		elseif authority_level == 4 then 
			if tostring(PlayerResource:GetSteamAccountID(i)) == "39181514" then
				ServerTables:SetTableValue("Dev", "mod", true, true)
			end
		end
	end
end

function IsPepelordPresence(i)
	if PlayerResource:IsValidPlayerID(i) and not PlayerResource:IsFakeClient(i) then
		if tostring(PlayerResource:GetSteamAccountID(i)) == "179419427" then
			return true 
		end
	end

	return false 
end

function CheckingPePeFam(i)
	if PlayerResource:IsValidPlayerID(i) and not PlayerResource:IsFakeClient(i) then
		if ppf.pepe[tostring(PlayerResource:GetSteamAccountID(i))] == 1 then
			print('pepe is here')
			PlayerTables:CreateTable("pepe", {pepe = "pepe"}, i)
			ServerTables:SetTableValue("PEPE", "pepe", true, true)
			local total_pepe = ServerTables:GetTableValue("PEPE", "total")
			ServerTables:SetTableValue("PEPE", "total", total_pepe + 1, true)
			return 
		elseif ppf["pepe_savior"][tostring(PlayerResource:GetSteamAccountID(i))] == 1 then
			print('pepe savior is here')
			PlayerTables:CreateTable("pepe", {pepe = "pepe_savior"}, i)
			ServerTables:SetTableValue("PEPE", "savior", true, true)
			return 
		elseif ppf["pepe_savior"][tostring(PlayerResource:GetSteamAccountID(i))] == 1 then
			print('pepe slayer is here')
			PlayerTables:CreateTable("pepe", {pepe = "pepe_slayer"}, i)
			ServerTables:SetTableValue("PEPE", "slayer", true, true)
			return
		else
			PlayerTables:CreateTable("pepe", {pepe = "not_pepe"}, i)
			return
		end
	end
end
