cu_chulain_battle_continuation = class({})
cu_chulain_battle_continuation_upgrade_1 = class({})
cu_chulain_battle_continuation_upgrade_2 = class({})
cu_chulain_battle_continuation_upgrade_3 = class({})
modifier_cu_battle_continuation = class({})
modifier_cu_battle_continuation_cooldown = class({})
modifier_cu_battle_continuation_active = class({})
modifier_cu_ath_ngabla = class({})
modifier_cu_ath_ngabla_enemy = class({})
modifier_lancer_trap = class({})

LinkLuaModifier("modifier_cu_battle_continuation", "abilities/cu_chulain/cu_chulain_battle_continuation", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cu_battle_continuation_cooldown", "abilities/cu_chulain/cu_chulain_battle_continuation", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cu_battle_continuation_active", "abilities/cu_chulain/cu_chulain_battle_continuation", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cu_ath_ngabla", "abilities/cu_chulain/cu_chulain_battle_continuation", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cu_ath_ngabla_enemy", "abilities/cu_chulain/cu_chulain_battle_continuation", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lancer_trap", "abilities/cu_chulain/cu_chulain_battle_continuation", LUA_MODIFIER_MOTION_NONE)

function cubcwrapper(abil)
	function abil:GetAbilityTextureName()
		if self:GetCaster():HasModifier("modifier_alternate_04") or self:GetCaster():HasModifier("modifier_alternate_05") then 
			return "custom/yukina/yukina_battle_continuation"
		else
			return "custom/cu_chulain/cu_chulain_battle_continuation"
		end
	end

	function abil:GetIntrinsicModifierName()
		return "modifier_cu_battle_continuation"
	end
end

cubcwrapper(cu_chulain_battle_continuation)
cubcwrapper(cu_chulain_battle_continuation_upgrade_1)
cubcwrapper(cu_chulain_battle_continuation_upgrade_2)
cubcwrapper(cu_chulain_battle_continuation_upgrade_3)

--------------------

function modifier_cu_battle_continuation:IsDebuff() return false end
function modifier_cu_battle_continuation:IsPurgable() return false end
function modifier_cu_battle_continuation:IsPassive() return true end
function modifier_cu_battle_continuation:RemoveOnDeath() return false end
function modifier_cu_battle_continuation:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end
function modifier_cu_battle_continuation:DeclareFunctions()
	return { MODIFIER_EVENT_ON_TAKEDAMAGE }
end
if IsServer() then
	function modifier_cu_battle_continuation:OnTakeDamage(args)
		if args.unit ~= self:GetParent() then return end
		local ability = self:GetAbility()
		local caster = self:GetParent()

		if args.damage < ability:GetSpecialValueFor("max_damage") 
			and caster:GetHealth() <= 0 
			and not caster:HasModifier("modifier_cu_battle_continuation_cooldown") 
			and IsRevivePossible(caster)
			then

			caster:SetHealth(ability:GetSpecialValueFor("revive_health") )

			if not caster:HasModifier("modifier_cu_battle_continuation_active") then
				HardCleanse(caster)
				if caster:HasModifier("modifier_alternate_04") or caster:HasModifier("modifier_alternate_05") then 
					caster:EmitSound("Yukina_BC")
				else
					caster:EmitSound("Cu_Battlecont")
				end
				caster:AddNewModifier(caster, ability, "modifier_cu_battle_continuation_active", { Duration = ability:GetSpecialValueFor("active_dur") })
				local reviveFx = ParticleManager:CreateParticle("particles/items_fx/aegis_respawn.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
				ParticleManager:SetParticleControl(reviveFx, 3, caster:GetAbsOrigin())

				Timers:CreateTimer( ability:GetSpecialValueFor("active_dur"), function()
					ParticleManager:DestroyParticle( reviveFx, false )
				end)

				if caster.IsCelticRuneAcquired then  
					caster:FindAbilityByName("cu_chulain_relentless_spear_upgrade"):ApplyRuneFerocity(ability:GetSpecialValueFor("ath_duration"))
					caster:FindAbilityByName("cu_chulain_piercing_spear_upgrade"):ApplyRuneAccel(ability:GetSpecialValueFor("ath_duration"))
					caster:FindAbilityByName("cu_chulain_claw_upgrade"):ApplyRuneCombat(ability:GetSpecialValueFor("ath_duration"))
					caster:AddNewModifier(caster, ability, "modifier_cu_ath_ngabla", { Duration = ability:GetSpecialValueFor("ath_duration") })
					ResetAbilities(caster)
					args.attacker:AddNewModifier(caster, ability, "modifier_cu_ath_ngabla_enemy", { Duration = ability:GetSpecialValueFor("ath_duration") })
				end
			end
		end
	end
end
function modifier_cu_battle_continuation:IsHidden() 
	if self:GetParent():HasModifier("modifier_cu_battle_continuation_active") or self:GetParent():HasModifier("modifier_cu_battle_continuation_cooldown") then
		return true 
	else
		return false 
	end
end

------------------------------

function modifier_cu_battle_continuation_active:IsHidden() return false end
function modifier_cu_battle_continuation_active:IsDebuff() return false end
function modifier_cu_battle_continuation_active:IsPurgable() return false end
function modifier_cu_battle_continuation_active:RemoveOnDeath() return false end
function modifier_cu_battle_continuation_active:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

if IsServer() then 
	function modifier_cu_battle_continuation_active:OnCreated(args)
		self.caster = self:GetParent()
		self.ability = self:GetAbility()
		self:StartIntervalThink(FrameTime())
	end

	function modifier_cu_battle_continuation_active:OnIntervalThink()
		self.caster:SetHealth(self.ability:GetSpecialValueFor("revive_health"))
	end

	function modifier_cu_battle_continuation_active:OnDestroy()
		self.caster:AddNewModifier(self.caster, self.ability, "modifier_cu_battle_continuation_cooldown", { Duration = self.ability:GetCooldown(1) })
		self.ability:StartCooldown(self.ability:GetCooldown(1))
		
		if self:GetParent().IsCelticRuneAcquired then
			if self.caster :IsAlive() then
				local lancertrap = CreateUnitByName("lancer_trap", self.caster:GetAbsOrigin(), true, self.caster , self.caster , self.caster:GetTeamNumber())
				self.trap_dur = 20
				lancertrap:AddNewModifier(self.caster, self.ability, "modifier_kill", {Duration = self.trap_dur + 1})
				Timers:CreateTimer(1.0, function()
					if IsValidEntity(lancertrap) and not lancertrap:IsNull() and lancertrap:IsAlive() then
						lancertrap:AddNewModifier(self.caster, self.ability, "modifier_lancer_trap", {Duration = self.trap_dur})
					end
					return
				end)
			else
				local targets = FindUnitsInRadius(self.caster:GetTeam(), self.caster:GetAbsOrigin(), nil, self.ability:GetSpecialValueFor("rune_fire_radius")
		            , DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
				for k,v in pairs(targets) do
					DoDamage(self.caster, v, self.ability:GetSpecialValueFor("rune_fire_dmg"), DAMAGE_TYPE_MAGICAL, 0, self, false)
					if IsValidEntity(v) and not v:IsNull() and v:IsAlive() then
				        if not IsImmuneToCC(v) then
				        	v:AddNewModifier(self.caster, self.ability, "modifier_stunned", {Duration = self.ability:GetSpecialValueFor("rune_fire_stun")})
				        end
				    end
				end
				local trapFX = ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/templar_assassin_trap_explode.vpcf", PATTACH_CUSTOMORIGIN, self.caster)
				ParticleManager:SetParticleControl(trapFX, 0, trap_mark)

				self.caster:EmitSound("Hero_TemplarAssassin.Trap.Cast")

				Timers:CreateTimer(2, function()
					ParticleManager:DestroyParticle(trapFX, false )
					ParticleManager:ReleaseParticleIndex(trapFX)
				end)
			end
		end
	end
end

--------------------------------

function modifier_cu_battle_continuation_cooldown:IsHidden() return false end
function modifier_cu_battle_continuation_cooldown:IsDebuff() return true end
function modifier_cu_battle_continuation_cooldown:IsPurgable() return false end
function modifier_cu_battle_continuation_cooldown:RemoveOnDeath() return false end
function modifier_cu_battle_continuation_cooldown:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT
end

-------------------------------------

function modifier_cu_ath_ngabla:IsHidden() return false end
function modifier_cu_ath_ngabla:IsDebuff() return false end
function modifier_cu_ath_ngabla:IsPurgable() return false end
function modifier_cu_ath_ngabla:RemoveOnDeath() return false end
function modifier_cu_ath_ngabla:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end
function modifier_cu_ath_ngabla:GetTexture()
	return "custom/cu_chulain/cu_chulain_ath_ngabla"
end
function modifier_cu_ath_ngabla:GetEffectName()
	return "particles/custom/lancer/lancer_rune_ath.vpcf"
end
function modifier_cu_ath_ngabla:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

-------------------

function modifier_cu_ath_ngabla_enemy:IsHidden() return false end
function modifier_cu_ath_ngabla_enemy:IsDebuff() return true end
function modifier_cu_ath_ngabla_enemy:IsPurgable() return false end
function modifier_cu_ath_ngabla_enemy:RemoveOnDeath() return true end
function modifier_cu_ath_ngabla_enemy:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end
function modifier_cu_ath_ngabla_enemy:GetTexture()
	return "custom/cu_chulain/cu_chulain_ath_ngabla"
end 
function modifier_cu_ath_ngabla_enemy:GetEffectName()
	return "particles/econ/items/omniknight/omni_crimson_witness_2021/omniknight_crimson_witness_2021_degen_aura_debuff.vpcf"
end
function modifier_cu_ath_ngabla_enemy:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_cu_ath_ngabla_enemy:DeclareFunctions()
	return { MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
end
function modifier_cu_ath_ngabla_enemy:GetModifierIncomingDamage_Percentage(keys)
	if keys.attacker:HasModifier("modifier_cu_ath_ngabla") then
		return self:GetAbility():GetSpecialValueFor("ath_enemy")
	else
		return 0
	end
end

--------------- 

function modifier_lancer_trap:IsHidden() return false end
function modifier_lancer_trap:IsDebuff() return false end
function modifier_lancer_trap:IsPurgable() return false end
function modifier_lancer_trap:RemoveOnDeath() return true end
function modifier_lancer_trap:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

if IsServer() then 
	function modifier_lancer_trap:OnCreated(args)
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.trap = self:GetParent()
		self.radius = self.ability:GetSpecialValueFor("rune_fire_radius")
		self.stun = self.ability:GetSpecialValueFor("rune_fire_stun")
		self.damage = self.ability:GetSpecialValueFor("rune_fire_dmg")
		self:StartIntervalThink(1.0)
	end

	function modifier_lancer_trap:OnIntervalThink()
		local targets = FindUnitsInRadius(self.caster:GetTeam(), self.trap:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		if #targets > 0 then
			for i = 1, #targets do
				if IsValidEntity(targets[i]) and not targets[i]:IsNull() and not IsImmuneToCC(targets[i]) then
					targets[i]:AddNewModifier(self.caster, self.ability, "modifier_stunned", { Duration = self.stun })
				end
				DoDamage(self.caster, targets[i], self.damage, DAMAGE_TYPE_MAGICAL, 0, self.ability, false)
			end

			local trapFX = ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/templar_assassin_trap_explode.vpcf", PATTACH_CUSTOMORIGIN, self.trap)
			ParticleManager:SetParticleControl(trapFX, 0, self.trap:GetAbsOrigin())

			self.trap:EmitSound("Hero_TemplarAssassin.Trap.Explode")
			self:Destroy()

			Timers:CreateTimer(2, function()
				ParticleManager:DestroyParticle(trapFX, false )
				ParticleManager:ReleaseParticleIndex(trapFX)
			end)
		end
	end

	function modifier_lancer_trap:OnDestroy()
		self.trap:ForceKill(true)
	end
end



