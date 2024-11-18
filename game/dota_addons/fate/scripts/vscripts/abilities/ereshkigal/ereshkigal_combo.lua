
ereshkigal_combo = class({})
ereshkigal_combo_target = class({})
modifier_ereshkigal_combo_tele = class({})
modifier_ereshkigal_combo_cast = class({})
modifier_ereshkigal_combo_vision = class({})
modifier_ereshkigal_combo_cooldown = class({})
LinkLuaModifier("modifier_ereshkigal_combo_tele", "abilities/ereshkigal/ereshkigal_combo", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ereshkigal_combo_cast", "abilities/ereshkigal/ereshkigal_combo", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ereshkigal_combo_vision", "abilities/ereshkigal/ereshkigal_combo", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ereshkigal_combo_cooldown", "abilities/ereshkigal/ereshkigal_combo", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ereshkigal_self", "abilities/ereshkigal/ereshkigal_r", LUA_MODIFIER_MOTION_NONE)

function ereshkigal_combo:GetBehavior()
	if self:GetCaster():IsRealHero() then 
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_MOVEMENT + DOTA_ABILITY_BEHAVIOR_HIDDEN
	else
		return DOTA_ABILITY_BEHAVIOR_PASSIVE
	end
end

function ereshkigal_combo:GetManaCost(iLevel)
	if self:GetCaster():IsRealHero() then 
		return 800
	else
		return 0
	end
end

function ereshkigal_combo:CastFilterResult()
	local caster = self:GetCaster()
	if caster:GetAbsOrigin().y < -2000 then
	    return UF_FAIL_CUSTOM
	else
	    return UF_SUCESS
	end
end

function ereshkigal_combo:GetCustomCastError()
	return "#Inside_Reality_Marble"
end

function ereshkigal_combo:UseSoul()

	local ereshkigal_d = self.caster:FindAbilityByName(self.caster.DSkill)

	local soul_stack = self.caster:GetModifierStackCount("modifier_ereshkigal_soul", self.caster) or 0 

	ereshkigal_d:CollectSoul(-soul_stack)
	
	return soul_stack
end

function ereshkigal_combo:OnSpellStart()
	self.caster = self:GetCaster()
	self.origin = self.caster:GetAbsOrigin()
	self.player = self.caster:GetPlayerOwner()
	local masterCombo = self.caster.MasterUnit2:FindAbilityByName("ereshkigal_combo")
	masterCombo:EndCooldown()
	masterCombo:StartCooldown(self:GetCooldown(1))
	self.caster:RemoveModifierByName("modifier_ereshkigal_combo_window")
	self.caster:AddNewModifier(self.caster, self, "modifier_ereshkigal_combo_cooldown", {duration = self:GetCooldown(1)})

	self.ereshkigal_r = self.caster:FindAbilityByName(self.caster.RSkill)
	self.ereshkigal_r:StartCooldown(self.ereshkigal_r:GetCooldown(self.ereshkigal_r:GetLevel()))

	self.aoe = self:GetSpecialValueFor("aoe")
	self.damage = self:GetSpecialValueFor("damage")
	self.soul_damage = self:GetSpecialValueFor("soul_damage")
	self.root = self:GetSpecialValueFor("root")
	self.revoke = self:GetSpecialValueFor("revoke")
	self.total_soul = self:UseSoul()
	self.bonus_damage = self.soul_damage * self.total_soul
	self.beam = self.caster:FindAbilityByName("ereshkigal_combo_target")
	--self.lightning_charge = 2
	self.hell_loc = Vector(0,2000,256)

	self.base_camera = Convars:GetInt("dota_camera_distance") or 1900
    self.bonus_camera = 100
    self.current_camera = Convars:GetInt("dota_camera_distance") or 1900

    self.total_spikesfx = 12
    self.spikesfx_count = 1
    local spikesfx = {}

	giveUnitDataDrivenModifier(self.caster, self.caster, "pause_sealdisabled", self:GetSpecialValueFor("delay_before_tele") + 0.1)
	self.caster:AddNewModifier(self.caster, self, "modifier_ereshkigal_combo_tele", {duration = self:GetSpecialValueFor("delay_before_tele")})
	EmitGlobalSound("Ereshkigal.Combo_1")
	--self.warp_cicle = ParticleManager:CreateParticle("", PATTACH_CUSTOMORIGIN, self.caster)
	--ParticleManager:SetParticleControl(self.warp_cicle, 0, self.caster:GetAbsOrigin())	

	--EmitGlobalSound("Ishtar.ComboStart")

	Timers:CreateTimer(self:GetSpecialValueFor("delay_before_tele"), function()
		self.caster:RemoveModifierByName("modifier_ereshkigal_combo_tele")
		self.caster:AddNewModifier(self.caster, self, "modifier_ereshkigal_self", {duration = self:GetSpecialValueFor("cast") + 5})

		if self.caster:IsAlive() then 
			
			--[[for i=2, 13 do
				if self.caster:GetTeamNumber() ~= i then
					AddFOWViewer(i, self.hell_loc, 1000, self:GetSpecialValueFor("cast"), false)
				end
			end]]
			AddFOWViewer(self.caster:GetTeamNumber(), Vector(0,2000,1000), 10000, self:GetSpecialValueFor("reveal"), false)
			self.channel_dummy = self.caster:FindAbilityByName("ereshkigal_combo_dummy")
			self.channel_dummy:SetChanneling(true)
			
			--EmitGlobalSound("Ishtar.ComboTeleport")
			--self.caster:SetOrigin(self.hell_loc)
			self.caster:AddEffects(EF_NODRAW)

			giveUnitDataDrivenModifier(self.caster, self.caster, "jump_pause", self:GetSpecialValueFor("cast"))
			self.caster:AddNewModifier(self.caster, self, "modifier_ereshkigal_combo_cast", {duration = self:GetSpecialValueFor("cast") + 0.5})
			self.caster:AddNewModifier(self.caster, self, "modifier_ereshkigal_combo_vision", {duration = self:GetSpecialValueFor("reveal")})
			StartAnimation(self.caster, {duration=self:GetSpecialValueFor("reveal") - 0.5, activity=ACT_DOTA_CAST_ABILITY_6, rate=1.0})
			Timers:CreateTimer(0.1, function()
				self:ZoomOut()
				--self.hand_fx1 = ParticleManager:CreateParticle("particles/ishtar/ishtar-r/ishtar_hand_yellow_buff.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.caster)
				--ParticleManager:SetParticleControlEnt(self.hand_fx1, 0, self.caster, PATTACH_POINT_FOLLOW, "attach_attack1", self.caster:GetAbsOrigin() + Vector(0,0,50), false)
				--ParticleManager:SetParticleControlEnt(self.hand_fx1, 1, self.caster, PATTACH_POINT_FOLLOW, "attach_attack1", self.caster:GetAbsOrigin() + Vector(0,0,50), false)
			end)
			Timers:CreateTimer(2, function()
				EmitGlobalSound("Ereshkigal.Combo_2")
			end)
			--[[Timers:CreateTimer(self.lightning_charge, function()
				EmitGlobalSound("Ishtar.Combo2")
				ParticleManager:DestroyParticle(self.hand_fx1, true)
				ParticleManager:ReleaseParticleIndex(self.hand_fx1)
				StartAnimation(self.caster, {duration=self:GetSpecialValueFor("cast") - self.lightning_charge + 0.5, activity=ACT_DOTA_CAST_ABILITY_5, rate=1.0})
				self.charge_fx1 = ParticleManager:CreateParticle("particles/ishtar/ishtar-r/r_cast_gather.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
				ParticleManager:SetParticleControl(self.charge_fx1, 0, self.caster:GetAbsOrigin())
				self.charge_fx2 = ParticleManager:CreateParticle("particles/ishtar/ishtar-r/r_cast_gather2.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
				ParticleManager:SetParticleControl(self.charge_fx2, 0, self.caster:GetAbsOrigin())
				self.charge_arrow_fx = ParticleManager:CreateParticle("particles/ishtar/ishtar-r/r_combo_model.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.caster)
				ParticleManager:SetParticleControlEnt(self.charge_arrow_fx, 3, self.caster, PATTACH_POINT_FOLLOW, "attach_arrow", self.caster:GetAbsOrigin(), false)
				self.ring_fx = ParticleManager:CreateParticle("particles/ishtar/ishtar_combo/ishtar_combo_ring.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.caster)
				ParticleManager:SetParticleControlEnt(self.ring_fx, 1, self.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", self.caster:GetAbsOrigin(), false)
			end)]]
			Timers:CreateTimer(self:GetSpecialValueFor("reveal") + 0.5, function() 
				self.target_loc = self.beam.target_loc or self.beam:GetTargetLoc(self.caster) 
				if self.target_loc.y < -2000 then 
					self.target_loc = self.beam:GetTargetLoc(self.caster)
				end
				self.ereshkigal_r:CreatePseudoMarble(self.target_loc)
				EmitGlobalSound("Ereshkigal.Combo_2")
				--EmitGlobalSound("Ishtar.RComboChargeSFXOuter")
				--FreezeAnimation(self.caster)

				local LightningPillarFX = ParticleManager:CreateParticle("particles/custom/ereshkigal/ereshkigal_kur_spike.vpcf", PATTACH_CUSTOMORIGIN, self.caster)
				ParticleManager:SetParticleControl(LightningPillarFX, 0, self.target_loc)
				ParticleManager:SetParticleControl(LightningPillarFX, 1, self.target_loc)
				ParticleManager:SetParticleControl(LightningPillarFX, 3, Vector(self.aoe - 150,self.aoe - 150,-100))
				ParticleManager:SetParticleControl(LightningPillarFX, 4, Vector(-self.aoe + 150,-self.aoe + 150,-100))

				Timers:CreateTimer(1.5, function()
					ParticleManager:DestroyParticle(LightningPillarFX, true)
					ParticleManager:ReleaseParticleIndex(LightningPillarFX)
				end)

			end)
			--[[Timers:CreateTimer(4.5, function()
				ParticleManager:DestroyParticle(self.charge_fx1, true)
				ParticleManager:ReleaseParticleIndex(self.charge_fx1)
				ParticleManager:DestroyParticle(self.charge_fx2, true)
				ParticleManager:ReleaseParticleIndex(self.charge_fx2)
				ParticleManager:DestroyParticle(self.charge_arrow_fx, true)
				ParticleManager:ReleaseParticleIndex(self.charge_arrow_fx)
				ParticleManager:DestroyParticle(self.ring_fx, true)
				ParticleManager:ReleaseParticleIndex(self.ring_fx)
				EmitGlobalSound("Ishtar.ComboLaunch")
				UnfreezeAnimation(self.caster)
				Timers:CreateTimer(0.2, function()
					EmitGlobalSound("Ishtar.ComboCharging")
				end)
			end)]]
		end

		Timers:CreateTimer(self:GetSpecialValueFor("cast"), function()
			--if self.caster:IsAlive() then 

				--EmitGlobalSound("Ishtar.ComboJabalLaunch")

				--EmitGlobalSound("Ishtar.Shoot")
				--EmitGlobalSound("Ishtar.ComboShoot")
				--EmitGlobalSound("Ishtar.ComboShoot2")


				--[[self.target_loc = self.beam.target_loc or self.beam:GetTargetLoc(self.caster) 
				if self.target_loc.y < -2000 then 
					self.target_loc = self.beam:GetTargetLoc(self.caster)
				end]]
				

				self.channel_dummy:EndChannel(true)
				self.channel_dummy:SetChanneling(false)

				--self.ereshkigal_r:CreatePseudoMarble(self.target_loc)

				--[[local pcExplosion = ParticleManager:CreateParticle("particles/ishtar/ishtar_combo/impact/ishtar_combo_impact.vpcf", PATTACH_WORLDORIGIN, self.caster)
		    	ParticleManager:SetParticleControl(pcExplosion, 0, self.target_loc + Vector(0,0,50))
		    	ParticleManager:SetParticleControl(pcExplosion, 1, self.target_loc + Vector(0,0,50))
		    	ParticleManager:SetParticleControl(pcExplosion, 3, self.target_loc + Vector(0,0,50))]]

				EmitGlobalSound("Ishtar.ComboImpact1")
				EmitGlobalSound("Ishtar.ComboImpact2")
				EmitGlobalSound("Ishtar.ComboImpact3")
				EmitGlobalSound("Ishtar.ComboImpact4")

				Timers:CreateTimer(0.23, function()
					--EmitGlobalSound("Ishtar.ComboImpactOuter")
					--ParticleManager:DestroyParticle(pcExplosion, false)
					--ParticleManager:ReleaseParticleIndex(pcExplosion)
					--[[local origin = self:GetOriginLoc()
					self.portal_in_fx2 = ParticleManager:CreateParticle("particles/econ/items/underlord/underlord_2021_immortal/underlord_2021_immortal_darkrift_end_lensflare.vpcf", PATTACH_CUSTOMORIGIN, self.caster)
					ParticleManager:SetParticleControl(self.portal_in_fx2, 2, self.caster:GetOrigin())	
					self.portal_out_fx2 = ParticleManager:CreateParticle("particles/econ/items/underlord/underlord_2021_immortal/underlord_2021_immortal_darkrift_end_lensflare.vpcf", PATTACH_CUSTOMORIGIN, self.caster)
					ParticleManager:SetParticleControl(self.portal_out_fx2, 2, origin)	]]
				end)

				local target_area = FindUnitsInRadius(self.caster:GetTeam(), self.target_loc, nil, self.aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
				for k,v in pairs(target_area) do 
					if IsValidEntity(v) and not v:IsNull() and v:IsAlive() then 
						giveUnitDataDrivenModifier(self.caster, v, "revoked", self.revoke)
						giveUnitDataDrivenModifier(self.caster, v, "rooted", self.root)
						DoDamage(self.caster, v, self.damage + self.bonus_damage, DAMAGE_TYPE_MAGICAL, 0, self, false)
						spikesfx[self.spikesfx_count] = ParticleManager:CreateParticle("particles/custom/ereshkigal/ereshkigal_combo_pillar.vpcf", PATTACH_CUSTOMORIGIN, self.caster)
						ParticleManager:SetParticleControl(spikesfx[self.spikesfx_count], 0, v:GetAbsOrigin())	
						self.spikesfx_count = self.spikesfx_count + 1
					end
				end

				for i = self.spikesfx_count, self.total_spikesfx do 
					spikesfx[i] = ParticleManager:CreateParticle("particles/custom/ereshkigal/ereshkigal_combo_pillar.vpcf", PATTACH_CUSTOMORIGIN, self.caster)
					ParticleManager:SetParticleControl(spikesfx[i], 0, self.target_loc + RandomVector(self.aoe - 200))	
				end

				Timers:CreateTimer(0.5, function()
					--EmitGlobalSound("Ishtar.ComboTeleport")
					self:ZoomIn()
					self.caster:RemoveEffects(EF_NODRAW)
						--self.caster:SetAbsOrigin(self:GetOriginLoc())
					--FindClearSpaceForUnit(self.caster,self:GetOriginLoc(), true)
					self.caster:AddNewModifier(self.caster, nil, "modifier_camera_follow", {duration = 1.0})
				end)

				Timers:CreateTimer(1, function()
					for i = 1, self.total_spikesfx do 
						ParticleManager:DestroyParticle(spikesfx[i], true)
						ParticleManager:ReleaseParticleIndex(spikesfx[i])
					end
				end)
			--end


		end)
	end)

end

if IsServer() then
	function ereshkigal_combo:ZoomOut()
		local count_tick = 0
	    local max_tick = 10

	    if not string.match(GetMapName(), "fate_elim") then return end
	    if self.CameraTimerDown ~= nil then 
	        Timers:RemoveTimer(self.CameraTimerDown)
	        self.CameraTimerDown = nil
	    end

	    if self.caster:IsAlive() then 
	        self.CameraTimerUp = Timers:CreateTimer(function()
	            if not self.caster:IsAlive() then 
	                CustomGameEventManager:Send_ServerToPlayer( self.player, "cam_distance", {camera= self.base_camera} )
	                return nil 
	            end
	            if count_tick == max_tick then 
	                return nil 
	            end
	            self.current_camera = math.min(self.current_camera + self.bonus_camera, 1900 + (max_tick * self.bonus_camera))
	            CustomGameEventManager:Send_ServerToPlayer( self.player, "cam_distance", {camera= self.current_camera} )
	            count_tick = count_tick + 1
	            return 0.033
	        end)
	    else
	        CustomGameEventManager:Send_ServerToPlayer( self.player, "cam_distance", {camera= self.base_camera} )
	    end

	end

	function ereshkigal_combo:ZoomIn()
		local count_tick = 0
	    local max_tick = 10

	    if not string.match(GetMapName(), "fate_elim") then return end
	    if self.CameraTimerUp ~= nil then 
	        Timers:RemoveTimer(self.CameraTimerUp)
	        self.CameraTimerUp = nil
	    end

	    if self.caster:IsAlive() then 
	        self.CameraTimerDown = Timers:CreateTimer(function()
	            if not self.caster:IsAlive() then 
	                CustomGameEventManager:Send_ServerToPlayer( self.player, "cam_distance", {camera= self.base_camera} )
	                return nil 
	            end
	            if count_tick == max_tick then 
	                return nil 
	            end
	            self.current_camera = math.max(self.current_camera - self.bonus_camera, 1900)
	            CustomGameEventManager:Send_ServerToPlayer( self.player, "cam_distance", {camera= self.current_camera} )
	            count_tick = count_tick + 1
	            return 0.033
	        end)
	    else
	        CustomGameEventManager:Send_ServerToPlayer( self.player, "cam_distance", {camera= self.base_camera} )
	    end

	end
end

function ereshkigal_combo:GetOriginLoc()
	return self.origin
end

-------------------------------------

function ereshkigal_combo_target:GetCastAnimation()
	return nil 
end

function ereshkigal_combo_target:CastFilterResultLocation(hLocation)
	if IsServer() then
		local caster = self:GetCaster()
		if IsServer() and not IsInSameRealm(caster:GetAbsOrigin(), hLocation) then
		    return UF_FAIL_CUSTOM
		else
		    return UF_SUCESS
		end
	end
end

function ereshkigal_combo_target:GetCustomCastErrorLocation(hLocation)
	return "#Cannot_Target_Reality_Marble"
end

function ereshkigal_combo_target:GetAOERadius()
	return 800
end

function ereshkigal_combo_target:OnSpellStart()
	print('combo beam actived')
	self.caster = self:GetCaster()
	self.target_loc = self:GetCursorPosition()
	self:SetTargetLoc(self.target_loc)
	--print('combo loc ' .. self.target_loc)
end

function ereshkigal_combo_target:GetCastRange(vLocation, hTarget)
	return 15000
end

function ereshkigal_combo_target:SetTargetLoc(vLocation)
	self.caster.combo_loc = vLocation
	self.caster:RemoveModifierByName("modifier_ereshkigal_combo_vision")
	print('register combo location')
end

function ereshkigal_combo_target:GetTargetLoc(hCaster)
	if hCaster.combo_loc == nil then 
		local enemies_hero = FindUnitsInRadius(hCaster:GetTeam(), Vector(0,0,0), nil, 10000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		local i = 1
		while i <= #enemies_hero do
			if IsValidEntity(enemies_hero[i]) and not enemies_hero[i]:IsNull() then
				if enemies_hero[i]:GetAbsOrigin().y < 2000 or not enemies_hero[i]:IsAlive() then 
					table.remove(enemies_hero, i)
					i = i - 1
				end
			end
			i = i + 1
		end
		if #enemies_hero >= 1 then
			local random = RandomInt(1, #enemies_hero)
			hCaster.combo_loc = enemies_hero[random]:GetAbsOrigin()
		else
			hCaster.combo_loc = hCaster:FindAbilityByName(hCaster.ComboSkill):GetOriginLoc()
		end
	end
	return hCaster.combo_loc
end

------------------------------

function modifier_ereshkigal_combo_tele:IsHidden() return true end
function modifier_ereshkigal_combo_tele:IsDebuff() return false end
function modifier_ereshkigal_combo_tele:IsPurgable() return false end
function modifier_ereshkigal_combo_tele:RemoveOnDeath() return true end
function modifier_ereshkigal_combo_tele:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_ereshkigal_combo_tele:CheckState()
	return {[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
			[MODIFIER_STATE_DISARMED] = true,
			[MODIFIER_STATE_MUTED] = true,
			[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
			[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
			[MODIFIER_STATE_SILENCED] = true,}
end

function modifier_ereshkigal_combo_tele:DeclareFunctions()
	return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION}
end

function modifier_ereshkigal_combo_tele:GetOverrideAnimation()
	return ACT_DOTA_RUN 
end

function modifier_ereshkigal_combo_tele:OnCreated(args)
	self.caster = self:GetParent()
end

--------------------------------------

function modifier_ereshkigal_combo_vision:IsHidden() return true end
function modifier_ereshkigal_combo_vision:IsDebuff() return false end
function modifier_ereshkigal_combo_vision:IsPurgable() return false end
function modifier_ereshkigal_combo_vision:RemoveOnDeath() return true end
function modifier_ereshkigal_combo_vision:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

if IsServer() then
	function modifier_ereshkigal_combo_vision:OnCreated(args)
		self.caster = self:GetParent()
		self.caster:SwapAbilities(self.caster.RSkill, "ereshkigal_combo_target", false, true)
	end

	function modifier_ereshkigal_combo_vision:OnDestroy()
		self.caster:SwapAbilities(self.caster.RSkill, "ereshkigal_combo_target", true, false)
	end
end

-------------------------------------------

function modifier_ereshkigal_combo_cast:IsHidden() return false end
function modifier_ereshkigal_combo_cast:IsDebuff() return false end
function modifier_ereshkigal_combo_cast:IsPurgable() return false end
function modifier_ereshkigal_combo_cast:RemoveOnDeath() return true end
function modifier_ereshkigal_combo_cast:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_ereshkigal_combo_cast:CheckState()
	return {[MODIFIER_STATE_INVULNERABLE] = true,
			[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
			[MODIFIER_STATE_DISARMED] = true,
			[MODIFIER_STATE_MUTED] = true,
			[MODIFIER_STATE_UNSELECTABLE] = true,
			[MODIFIER_STATE_FLYING] = true,
			[MODIFIER_STATE_NO_HEALTH_BAR] = true,}
end

function modifier_ereshkigal_combo_cast:OnCreated(args)
	
end

function modifier_ereshkigal_combo_cast:OnDestroy()
	
end

---------------------------------------

function modifier_ereshkigal_combo_cooldown:IsHidden() return false end
function modifier_ereshkigal_combo_cooldown:IsDebuff() return true end
function modifier_ereshkigal_combo_cooldown:IsPurgable() return false end
function modifier_ereshkigal_combo_cooldown:RemoveOnDeath() return false end
function modifier_ereshkigal_combo_cooldown:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end









