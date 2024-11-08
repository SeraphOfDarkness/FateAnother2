Fate_Grail_Loot = Fate_Grail_Loot or class({})
modifier_loot_aura = class({})

LinkLuaModifier("modifier_loot_aura", "fate_loot_grail", LUA_MODIFIER_MOTION_NONE)

GRAIL_COOLDOWN = 1200
GRAIL_COOLDOWN_COUNTER = 1200
TIMER_BEFORE_DROP = 30
LOOTZONE = 600
CAPTURE_TIME = 30
MANA_REWARD = 10
HP_REWARD = 6
MINIMUM_PROGRESS = 1
BONUS_PROGRESS = 0.1

function Fate_Grail_Loot:constructor()
	self.grail_cooldown = GRAIL_COOLDOWN or 1200
	self.grail_cooldown_counter = GRAIL_COOLDOWN_COUNTER or 1200
	self.timer_before_drop = TIMER_BEFORE_DROP
	if IsInToolsMode() then 
		self.grail_cooldown = 10
		self.grail_cooldown_counter = 10
		self.timer_before_drop = 10
	end
	self.Is_grail_claim = false
	self.black_grail_perc = 0
	self.grail_drop_loc_1 = Vector(960, 6250, 257)
	self.grail_drop_loc_2 = Vector(600, 2150, 285)
	self.grail_drop_loc_3 = Vector(607, -1300, 257)

end

function Fate_Grail_Loot:StartTimer()
	CreateUITimer("Draw Round Grail", self.grail_cooldown_counter, "drawloot_cooldown_timer")
	Timers:CreateTimer(function()
		if self.grail_cooldown_counter <= 0 then 
			self.grail_cooldown_counter = 0
			return nil 
		end

		self.grail_cooldown_counter = self.grail_cooldown_counter - 1
		--print('fate grail loot cooldown: ' .. self.grail_cooldown_counter .. 'seconds.')
		return 1 		
	end)
end

function Fate_Grail_Loot:IsGrailReady()
	if self.grail_cooldown_counter > 0 then 
		--print('fate grail loot is not ready, need ' .. self.grail_cooldown_counter .. 'seconds.')
		return false 
	end
	--print('fate grail loot is ready')
	return true 
end

function Fate_Grail_Loot:StartGrailDrop()

	--Start timer  + particle
	CreateUITimer("Grail Drop In", self.timer_before_drop, "drawloot_timer")

	local random = RandomInt(1, 3)
	--print('random = ' .. random)
	local grail_loc = self.grail_drop_loc_1-- random location of grail drop
	if random == 2 then 
		grail_loc = self.grail_drop_loc_2
	elseif random == 3 then 
		grail_loc = self.grail_drop_loc_3
	end

	self.holy_grail_sky = ParticleManager:CreateParticle("particles/custom/generic/holy_grail_sky_edge2.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(self.holy_grail_sky, 0, grail_loc + Vector(0,0,500))

	for i=2, 3 do
		AddFOWViewer(i, grail_loc, LOOTZONE, self.timer_before_drop, false) -- add vision of where grail drop
	end

	Timers:CreateTimer(self.timer_before_drop - 2, function() -- random grail type + change particle color 
		local random_grail = RandomInt(1, 100) 
		if random_grail <= self.black_grail_perc then 
			self.grail_drop = "black" -- black and ded
		else 
			self.grail_drop = "good"
		end
	end)

	Timers:CreateTimer(self.timer_before_drop, function()
		if self.grail_drop == "black" then 


		else
			self:SpawnLootZone(grail_loc)
		end
		self:constructor()
		self:StartTimer()
	end)
end

function Fate_Grail_Loot:SpawnLootZone(vLoc)

	ParticleManager:DestroyParticle(self.holy_grail_sky, true)
	ParticleManager:ReleaseParticleIndex(self.holy_grail_sky)

	if ServerTables:GetTableValue("GameState", "state") ~= "FATE_ROUND_ONGOING" then 
		return 
	end

	self.holy_grail_dummy = CreateUnitByName("dummy_unit", vLoc, false, nil, nil, 5)
    self.holy_grail_dummy:FindAbilityByName("dummy_unit_passive"):SetLevel(1)
    self.holy_grail_dummy:SetAbsOrigin(vLoc)
    self.holy_grail_dummy:AddNewModifier(self.holy_grail_dummy, nil, "modifier_kill", {Duration = 120 - self.timer_before_drop})
    self.holy_grail_dummy:AddNewModifier(self.holy_grail_dummy, nil, "modifier_loot_aura", {Duration = 120 - self.timer_before_drop})

end

function Fate_Grail_Loot:ClearEffect()

	--self.grail_cooldown = GRAIL_COOLDOWN
	--self.grail_cooldown_counter = GRAIL_COOLDOWN_COUNTER
	--self.timer_before_drop = TIMER_BEFORE_DROP

	if IsValidEntity(self.holy_grail_dummy) and not self.holy_grail_dummy:IsNull() then 
		self.holy_grail_dummy:ForceKill(false)
	end
	self.Is_grail_claim = false

	--self:StartTimer()
end

----------------

function modifier_loot_aura:IsHidden() return false end
function modifier_loot_aura:IsDebuff() return false end
function modifier_loot_aura:IsPurgable() return false end
function modifier_loot_aura:RemoveOnDeath() return true end
function modifier_loot_aura:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end
function modifier_loot_aura:OnCreated(table)
	self.parent = self:GetParent()
	self.vLoc = GetGroundPosition(self.parent:GetAbsOrigin(), self.parent) 
	self.progress_tick = 0.1
	self.max_time = CAPTURE_TIME or 30
	self.progress_percent_person = 1
	self.radius = LOOTZONE
	self.grail_claim = false

	self.base_loc = self.vLoc + Vector(0,0,5)
	self.progress_loc = self.vLoc + Vector(0,0,7)
	self.spectator_loc = self.vLoc + Vector(0,0,6)
	self.color_rgb_team = Vector(1,255,1)
	self.color_rgb_enemy = Vector(255,1,1)

	self.left_team_progress = 0
	self.rigth_team_progress = 0
	self.left_team = nil
	self.right_team = nil
	self.current_team_progress = 0

	local player0_hero = PlayerResource:GetPlayer(0):GetAssignedHero()
	local round = ServerTables:GetTableValue("Score", "round")
	local player0_spawn = (player0_hero:GetTeamNumber() + round) % 2

	if player0_spawn == 1 then 
		self.left_team = player0_hero:GetTeamNumber()
		if self.left_team == 2 then 
			self.right_team = 3
		else
			self.right_team = 2
		end
	else
		self.right_team = player0_hero:GetTeamNumber()
		if self.right_team == 2 then 
			self.left_team = 3
		else
			self.left_team = 2
		end
	end

	self.FOW1 = AddFOWViewer(2, self.base_loc, self.radius, self:GetDuration(), false) 
	self.FOW2 = AddFOWViewer(3, self.base_loc, self.radius, self:GetDuration(), false)

	self.holy_grail_dummy_fx = ParticleManager:CreateParticle("particles/custom/generic/holy_grail_dummy.vpcf", PATTACH_WORLDORIGIN, self.parent)
	ParticleManager:SetParticleControl(self.holy_grail_dummy_fx, 0, self.base_loc)

	self.base_fx = ParticleManager:CreateParticle("particles/custom/generic/fate_loot_box_base.vpcf", PATTACH_WORLDORIGIN, self.parent)
	ParticleManager:SetParticleControl(self.base_fx, 0, self.base_loc) -- location
	ParticleManager:SetParticleControl(self.base_fx, 1, Vector(self.radius,0,0)) -- radius

	self:StartIntervalThink(self.progress_tick)
end

function modifier_loot_aura:OnIntervalThink()

	local left_team_count = 0
	local right_team_count = 0
	local leftplayers = {}
	local rightplayers = {}

	local hero_detect = FindUnitsInRadius(self.parent:GetTeam(), self.base_loc, nil, self.radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
	for k,v in pairs (hero_detect) do 
		if v:IsRealHero() and not v:IsIllusion() then 

			if v:GetTeamNumber() == self.left_team then 
				left_team_count = left_team_count + 1
				table.insert(leftplayers, v) 
			elseif v:GetTeamNumber() == self.right_team then 
				right_team_count = right_team_count + 1 
				table.insert(rightplayers, v) 
			end
		end
	end

	self:UpdateProgress(left_team_count, right_team_count, leftplayers, rightplayers)
end

function modifier_loot_aura:UpdateProgress(iLeftTeamCount, iRightTeamCount, tLeftplayers, tRightplayers)

	local diff = iLeftTeamCount - iRightTeamCount
	if diff > 1 then 
		diff = MINIMUM_PROGRESS + (diff * BONUS_PROGRESS)
	end
	--print('left side count ' .. iLeftTeamCount)
	--print('right side count ' .. iRightTeamCount)

	if diff > 0 then -- left side has more ppl 
		--self:CalculateProgress(math.abs(diff), self.left_team_progress, self.left_team, self.rigth_team_progress, self.right_team)
		if self.left_team_progress > 0 then 
			self.left_team_progress = self.left_team_progress + (diff * self.progress_percent_person)
			self.current_team_progress = self.left_team
		else
			if self.current_team_progress == 0 then 
				self.current_team_progress = self.left_team
				self.left_team_progress = self.left_team_progress + (diff * self.progress_percent_person)
			else
				self.rigth_team_progress = self.rigth_team_progress - (diff * self.progress_percent_person)
				self.current_team_progress = self.right_team
			end
		end
	elseif diff < 0 then
		--self:CalculateProgress(math.abs(diff), self.rigth_team_progress, self.right_team, self.left_team_progress, self.left_team)
		if self.rigth_team_progress > 0 then 
			self.rigth_team_progress = self.rigth_team_progress + (-diff * self.progress_percent_person)
			self.current_team_progress = self.right_team
		else
			if self.current_team_progress == 0 then 
				self.current_team_progress = self.right_team
				self.rigth_team_progress = self.rigth_team_progress + (-diff * self.progress_percent_person)
			else
				self.left_team_progress = self.left_team_progress - (-diff * self.progress_percent_person)
				self.current_team_progress = self.left_team
			end
		end
	else
		if iLeftTeamCount == 0 and iRightTeamCount == 0 then 
			self.left_team_progress = math.max(self.left_team_progress - self.progress_percent_person, 0)
			self.rigth_team_progress = math.max(self.rigth_team_progress - self.progress_percent_person, 0)
		end
	end

	self:UpdateProgressFX(self.left_team_progress, self.rigth_team_progress, self.current_team_progress)
	--print('current team progress: ' .. self.current_team_progress)
	if self.left_team_progress >= 100 and self.grail_claim == false then 
		self:GrantReward(self.left_team, tLeftplayers)
	elseif self.rigth_team_progress >= 100 and self.grail_claim == false then 
		self:GrantReward(self.right_team, tRightplayers)
	end
end

function modifier_loot_aura:GrantReward(iTeam, tInsidePlayers)
	--if iTeamProgressPercent >= 100 then 
		LoopOverPlayers(function(player, playerID, playerHero)
	    	--print("looping through " .. playerHero:GetName())
	        if playerHero:GetTeamNumber() == iTeam and player and playerHero then
	        	playerHero.MasterUnit:Heal(HP_REWARD, playerHero)
                playerHero.MasterUnit:GiveMana(MANA_REWARD)
                playerHero.MasterUnit2:Heal(HP_REWARD, playerHero)
                playerHero.MasterUnit2:GiveMana(MANA_REWARD)
	        end
	    end)
	    tInsidePlayers[1].ShardAmount = (tInsidePlayers[1].ShardAmount or 0) + 1
	    tInsidePlayers[1].ServStat:onConGrail()
        local statTable = CreateTemporaryStatTable(tInsidePlayers[1])
        CustomGameEventManager:Send_ServerToPlayer( tInsidePlayers[1]:GetPlayerOwner(), "servant_stats_updated", statTable )

	    GameRules:SendCustomMessage("#Fate_Get_Grail_Drop" .. iTeam-1, 0, 0)
	    ParticleManager:DestroyParticle(self.base_fx, true)
		ParticleManager:ReleaseParticleIndex(self.base_fx) 
		ParticleManager:DestroyParticle(self.holy_grail_dummy_fx, true)
		ParticleManager:ReleaseParticleIndex(self.holy_grail_dummy_fx)
		self:Destroy()

		Fate_Grail_Loot:ClearEffect()
		
		self.grail_claim = true
	--end
end
-- paticle progress 
--  max ring 100% = Vector(15,0,0)
--  1% = 1500 / 1
--  50% = 1500 / 50
--  100% = 1500 / 100
function modifier_loot_aura:UpdateProgressFX(iLeftProgress, iRightProgress, iTeamProgress)
	
	if iLeftProgress == 0 and iRightProgress == 0 or iTeamProgress == nil then 
		self.current_team_progress = 0 -- reset current team progress
		return nil 
	end

	--print('Left team progress: ' .. iLeftProgress)
	--print('Right team progress: ' .. iRightProgress)

	local progress_fx_name = "particles/custom/generic/fate_loot_box_progress_left.vpcf"
	local color_rgb = Vector(1,1,1)
	local progress_perc = iLeftProgress

	if iRightProgress >= 1 then
		progress_fx_name = "particles/custom/generic/fate_loot_box_progress_right.vpcf"
		progress_perc = iRightProgress
	end

	local progress_fx = {}

	for i = 2,3 do -- make diff color for each team
		if i == iTeamProgress then 
			color_rgb = self.color_rgb_team
		else
			color_rgb = self.color_rgb_enemy
		end
		progress_fx[i] = ParticleManager:CreateParticleForTeam(progress_fx_name, PATTACH_CUSTOMORIGIN, self.parent, i)
		ParticleManager:SetParticleControl(progress_fx[i], 0, self.progress_loc) 				-- center
		ParticleManager:SetParticleControl(progress_fx[i], 1, Vector(1500/math.min(progress_perc,100),0,0)) 	-- progress
		ParticleManager:SetParticleControl(progress_fx[i], 2, Vector(self.radius,0,0)) 			-- radius
		ParticleManager:SetParticleControl(progress_fx[i], 3, color_rgb)						-- color
	end

	local spectator_progress_fx = ParticleManager:CreateParticle(progress_fx_name, PATTACH_CUSTOMORIGIN, self.parent)
	ParticleManager:SetParticleControl(spectator_progress_fx, 0, self.spectator_loc) 				
	ParticleManager:SetParticleControl(spectator_progress_fx, 1, Vector(1500/math.min(progress_perc,100),0,0)) 	
	ParticleManager:SetParticleControl(spectator_progress_fx, 2, Vector(self.radius,0,0)) 			
	ParticleManager:SetParticleControl(spectator_progress_fx, 3, self.color_rgb_enemy)					

	Timers:CreateTimer(0.1, function()
		ParticleManager:DestroyParticle(progress_fx[2], true)
		ParticleManager:DestroyParticle(progress_fx[3], true)
		ParticleManager:DestroyParticle(spectator_progress_fx, true)
		ParticleManager:ReleaseParticleIndex(progress_fx[2])
		ParticleManager:ReleaseParticleIndex(progress_fx[3])
		ParticleManager:ReleaseParticleIndex(spectator_progress_fx)
	end)
end

function modifier_loot_aura:OnDestroy()
	self:GetParent():ForceKill(false)
	RemoveFOWViewer(2, self.FOW1)
	RemoveFOWViewer(3, self.FOW2)
end





