modifier_wesen_cooldown = class({})

function modifier_wesen_cooldown:IsHidden()
	return false 
end

function modifier_wesen_cooldown:RemoveOnDeath()
	return false
end

function modifier_wesen_cooldown:IsDebuff()
	return true 
end

function modifier_wesen_cooldown:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

if kjlpluo1596 == nil then
    kjlpluo1596 = {}

    kjlpluo1596.SERVER_LOCATION = "https://dfaq-a4526-default-rtdb.asia-southeast1.firebasedatabase.app/"
    kjlpluo1596.AUTH_KEY = "Faieklasdi"
    if IsDedicatedServer() then
        kjlpluo1596.AUTH_KEY = GetDedicatedServerKeyV2("1.0")
    end
end  

function kjlpluo1596:initialize(i,v)
	
	if PlayerResource:IsValidPlayerID(i) then
		local lvl = PlayerTables:GetTableValue("authority", "alvl", 0)
		print('Start Data')
		--print('authority lvl ' .. ddt.alvl)
	    if IsInToolsMode() and lvl ~= 5 then 
	    	--print('asdkjk')
	    	return 
	    end

	    if not IsInToolsMode() and Convars:GetBool("sv_cheats") then
	    	--print('cheat')
	    	return 
	    end

	    self.kiuok = LoadKeyValues("scripts/npc/abilities/heroes/hero.txt")
	    self.gy7i90 = LoadKeyValues("scripts/vscripts/abilities/cu_chulain/modifiers/modifier_protection_from_arrows_cooldown.kv")
	    self.old_data = iupoasldm.jyiowe or {}
		--print(self.old_data)
		if PlayerTables:GetTableValue("database", "db", i) == true and ServerTables:GetTableValue("Players", "total_player", i) > 1 then
			print('Start Data Calculate')
			SendChatToPanorama('Player ' .. i .. ': Start Data Calculate')
			self:c48dsq5(i,v)
		end
	end
end

function kjlpluo1596:c48dsq5(pId,victory)
	local htable = PlayerTables:GetAllTableValues("hHero", pId)
	--[[for k,v in pairs(htable) do
		print(k,v)
	end]]
	local hero = htable.hero 
	local skin = htable.skin
	local hhero = EntIndexToHScript(htable.hhero )
	if hhero == nil then 
		SendChatToPanorama('Player ' .. pId .. ': Hero Data Not Found.')
		return
	end
	local hID = self:GetHID(hero)
	local GID = self:GetGameMode()
	self.old_data[pId].IFY.HID[hID].DSK = skin 
	local kiok = self.old_data[pId].STT.gmy[GID]
	local ikuuo = kiok.HID[hID]
	local a778v = kiok.iyp
	local s7v8az = kiok.stye
	local kghyio = ikuuo.iyp
	local ku890 = ikuuo.srpo
	local uiopqwe = ikuuo.stye
	if hhero.ServStat == nil then
		SendChatToPanorama('Player ' .. pId .. ': Statistic Data Not Found.')
		return
	end
	kghyio.tgn = (kghyio.tgn or 0) + 1
	kghyio.twn = (kghyio.twn or 0) + victory
	kghyio.wrp = string.format("%.1f",kghyio.twn / kghyio.tgn * 100)
	uiopqwe.tdc = (uiopqwe.tdc or 0) + (hhero.DeathCount or 0)
	uiopqwe.tdk = (uiopqwe.tdk or 0) + (hhero.ServStat.assist or 0)
	uiopqwe.tkn = (uiopqwe.tkn or 0) + (hhero.ServStat.kill or 0)
	uiopqwe.kda = string.format("%.1f",(uiopqwe.tkn + uiopqwe.tdk ) / uiopqwe.tdc)
	uiopqwe.kd = string.format("%.1f",uiopqwe.tkn / uiopqwe.tdc)
	ku890.tdm = (ku890.tdm or 0) + (hhero.ServStat.damageDealt or 0)
	ku890.tdn = (ku890.tdn or 0) + (hhero.ServStat.tkill or 0)
	ku890.tga = (ku890.tga or 0) + (hhero.ServStat.itemValue or 0)
	ku890.ttk = (ku890.ttk or 0) + (hhero.ServStat.damageTaken or 0)
	ku890.thl = (ku890.thl or 0) + 0
	a778v.tgn = (a778v.tgn or 0) + 1
	a778v.twn = (a778v.twn or 0) + victory
	a778v.wrp = string.format("%.1f",a778v.twn / a778v.tgn * 100)
	s7v8az.tdc = (s7v8az.tdc or 0) + (hhero.DeathCount or 0)
	s7v8az.tdk = (s7v8az.tdk or 0) + (hhero.ServStat.assist or 0)
	s7v8az.tkn = (s7v8az.tkn or 0) + (hhero.ServStat.kill or 0)
	s7v8az.kda = string.format("%.1f",(s7v8az.tkn + s7v8az.tdk ) / s7v8az.tdc)
	s7v8az.kd = string.format("%.1f",s7v8az.tkn / s7v8az.tdc)
	kiok.tgn = (kiok.tgn or 0) + 1
	print('Finish Calculate')
	SendChatToPanorama('Player ' .. pId .. ': Finish Calculation.')
	self:CalCP(pId)
	self:sd57b8(pId)
end

function kjlpluo1596:CalCP(pId)
	local today = GetSystemDate()
	local lasdfi = tostring(self.old_data[pId].LD.LST)
	if today ~= lasdfi then 
		self.old_data[pId].IFY.CRY.CP = self.old_data[pId].IFY.CRY.CP + 100
		self.old_data[pId].LD.LST = today
		self.old_data[pId].LD.ACD = self.old_data[pId].LD.ACD + 1
		SendChatToPanorama('Player ' .. pId .. ' Get 100 CP as 1st game of day')
	end

	self.old_data[pId].LD.TDY = today

	if not GameRules:IsCheatMode() and not IsInToolsMode() and ServerTables:GetTableValue("Players", "total_player") > 1 then
		
		local cp_cap = 500
		local dw = self:SDte(today)
		local dd = self:DDte(today)
		local cpg = self:MSCP()

		if ServerTables:GetTableValue("Dev", "pepe") == true then 
			cpg = cpg + 10 
		end

		if ServerTables:GetTableValue("Dev", "mod") == true then 
			cpg = cpg + 5 
		end

		if PlayerTables:GetTableValue("authority", "alvl", pId) == "pepe" then
			if ServerTables:GetTableValue("PEPE", "savior") == true then 
				cpg = cpg + 10 
			end
		elseif PlayerTables:GetTableValue("authority", "alvl", pId) == "pepe_savior" then
			local pepe = ServerTables:GetTableValue("PEPE", "total") * 2 
			cpg = cpg + pepe
		elseif PlayerTables:GetTableValue("authority", "alvl", pId) == "pepe_slayer" then
			local pepe_kill = ServerTables:GetTableValue("PEPE", "kill") * 2 
			cpg = cpg + math.min(20,pepe_kill)
		end

		if self.old_data[pId].IFY.CRY.WCP == nil then 
			self.old_data[pId].IFY.CRY.WCP = {
				MW = 0,
				SW = 0,
				CP = 0
			}
			self:RSWCP(pId)
		end 

		if dd >= self.old_data[pId].IFY.CRY.WCP.MW and dd <= self.old_data[pId].IFY.CRY.WCP.SW then 
			cpg = math.min(cpg, cp_cap - self.old_data[pId].IFY.CRY.WCP.CP)
			if cpg < 0 then 
				cpg = 0 
				SendChatToPanorama('Player ' .. pId .. ' Get ' ..  cpg .. ' CP due to reaching maximum CP gain')
			else
				SendChatToPanorama('Player ' .. pId .. ' Get ' ..  cpg .. ' CP at this game')
			end
		else
			self:RSWCP(pId)
		end



		self.old_data[pId].IFY.CRY.WCP.CP = math.min(cp_cap, self.old_data[pId].IFY.CRY.WCP.CP + cpg)
		self.old_data[pId].IFY.CRY.CP = self.old_data[pId].IFY.CRY.CP + cpg
	end
end

function kjlpluo1596:MSCP()

	if string.match(GetMapName(), "elim") then 
		return 30
	elseif string.match(GetMapName(), "ffa") then 
		return 10
	elseif string.match(GetMapName(), "tutor") then 
		return 0
	else
		return 20 
	end
end

function kjlpluo1596:RSWCP(pId)
	local today = tostring(GetSystemDate())
	local dw = self:SDte(today)
	--print('week date : ' .. dw)
	local dd = self:DDte(today)
	--print('total date : ' .. dd)
	if dw == 2 then
		self.old_data[pId].IFY.CRY.WCP.MW = dd
		self.old_data[pId].IFY.CRY.WCP.SW = dd + 6 
	elseif dw == 1 then
		self.old_data[pId].IFY.CRY.WCP.MW = dd - 6
		self.old_data[pId].IFY.CRY.WCP.SW = dd 
	else
		self.old_data[pId].IFY.CRY.WCP.MW = dd - dw + 2
		self.old_data[pId].IFY.CRY.WCP.SW = dd - dw + 8 
	end

	self.old_data[pId].IFY.CRY.WCP.CP = 0 
end

function kjlpluo1596:SDte(date)
	local dd = tonumber(string.sub(date, 4, -4))
	local mm = tonumber(string.sub(date, 0, -7))
	local yy = tonumber(string.sub(date, 7)) 

  	local days = { "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat" }

  	local mmx = mm

  	if (mm == 1) then  mmx = 13; yy = yy-1  end
  	if (mm == 2) then  mmx = 14; yy = yy-1  end

  	local val8 = dd + (mmx*2) +  math.floor(((mmx+1)*3)/5)   + yy + math.floor(yy/4)  - math.floor(yy/100)  + math.floor(yy/400) + 2
  	local val9 = math.floor(val8/7)
  	local dw = val8-(val9*7) 

  	if (dw == 0) then
    	dw = 7
  	end
  	--print(dw)
  	return dw --, days[dw]
end

function kjlpluo1596:DDte(date)
	local dd = tonumber(string.sub(date, 4, -4))
	local mm = tonumber(string.sub(date, 0, -7))
	local yy = tonumber(string.sub(date, 7)) 

  	local mmx = mm

  	if (mm == 1) then  mmx = 13; yy = yy-1  end
  	if (mm == 2) then  mmx = 14; yy = yy-1  end

  	local val8 = dd + (mmx*2) +  math.floor(((mmx+1)*3)/5)   + yy + math.floor(yy/4)  - math.floor(yy/100)  + math.floor(yy/400) + 2
  	--print(val8)
  	return val8
end

function kjlpluo1596:GetHID(hero)
	for k,v in pairs (self.kiuok) do 
		if v == hero then 
			return k
		end
	end  
end

function kjlpluo1596:GetGameMode()
	local gmyio = ""
	if _G.DRAFT_MODE == true then
		gmyio = self.gy7i90[GetMapName() .. '_draft']
	else
		gmyio = self.gy7i90[GetMapName()]
	end

	return gmyio
end

function kjlpluo1596:sd57b8(pId,iReloads)
	local asdfuow = asdfuow(pId)
	local encoded = json.encode(self.old_data[pId])

	local request = CreateHTTPRequestScriptVM( "PUT", self.SERVER_LOCATION .. self.AUTH_KEY .. '/ZEVKI/' .. asdfuow .. '.json')
	--print('sending Data')
	SendChatToPanorama('Player ' .. pId .. ': Sending Data')
	--CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(pId), "asklklk", {s1 = 3, s2 = 1, s3 = pId})
	request:SetHTTPRequestRawPostBody("application/json", encoded)

    request:Send( function( hResponse )
        if hResponse.StatusCode == 200 then
           	SendChatToPanorama('Player ' .. pId .. ': Sending Data Success')
        else
        	SendChatToPanorama('Player ' .. pId .. ': Sending Data Failed - Unable to contact server')
        end
    end)
end