modifier_gawain_heat = class({})

LinkLuaModifier("modifier_gawain_heat_stack", "abilities/gawain/modifiers/modifier_gawain_heat_stack", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_kots_trigger", "abilities/gawain/modifiers/modifier_kots_trigger", LUA_MODIFIER_MOTION_NONE)

if IsServer() then
	function modifier_gawain_heat:OnCreated(args)
		self.BurnDamage = args.BurnDamage
	  	self.AttackSpeed = args.AttackSpeed
	  	self.StackDamage = args.StackDamage
	  	self.Radius = args.Radius

	  	self.AttackCount = 0
	  	self.TriggerCount = 1
	  	
	  	self:StartIntervalThink(0.2)
	end

	function modifier_gawain_heat:OnRefresh(args)
		self:OnCreated(args)
	end

	--function modifier_gawain_heat:OnDestroy()
		--self:GetParent():StopSound("Hero_EmberSpirit.FlameGuard.Loop")
	--end

	function modifier_gawain_heat:OnIntervalThink()	
		local caster = self:GetCaster()

		if caster ~= nil then
			local targets = FindUnitsInRadius(caster:GetTeam(), caster:GetOrigin(), nil, self.Radius , DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
			for k,v in pairs(targets) do
				if caster.IsBeltAcquired then
					v:AddNewModifier(caster, self:GetAbility(), "modifier_gawain_heat_stack", { Duration = 3.0 })
				end
								
		        DoDamage(caster, v, self.BurnDamage * 0.2, DAMAGE_TYPE_MAGICAL, 0, self:GetAbility(), false)
		    end
		end
	end

	function modifier_gawain_heat:OnAttackLanded(args)
		local caster = self:GetParent()
		local target = args.target

		if caster ~= args.attacker then return end
		local modifier = target:FindModifierByName("modifier_gawain_heat_stack")
		local damage = self.StackDamage
		local stacks = 0

		if modifier then
			stacks = modifier:GetStackCount()
		end

		damage = damage + (damage * stacks)
		DoDamage(caster, target, damage, DAMAGE_TYPE_PHYSICAL, 0, self:GetAbility(), false)

		self.AttackCount = self.AttackCount + 1

		if target:IsAlive() then
			modifier = target:AddNewModifier(caster, self:GetAbility(), "modifier_gawain_heat_stack", { Duration = 3.0 })

			if self.AttackCount >= (5 * self.TriggerCount) and caster.KotsAcquired then
				self.TriggerCount = self.TriggerCount + 1
				self.AttackCount = 0
				caster:AddNewModifier(caster, self:GetAbility(), "modifier_kots_trigger", { Duration = 3.0 })
				target:AddNewModifier(caster, target, "modifier_stunned", {Duration = 1.0 })
				caster:EmitSound("Gawain_Trigger" .. math.random(1,2))
			end
		end
	end

end

function modifier_gawain_heat:DeclareFunctions()
	local Funcs = {	MODIFIER_EVENT_ON_ATTACK_LANDED,
					MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT }

	return Funcs
end



function modifier_gawain_heat:GetModifierAttackSpeedBonus_Constant()
	return self.AttackSpeed
end

function modifier_gawain_heat:IsHidden()
	return false
end

function modifier_gawain_heat:IsPurgable()
	return false
end

function modifier_gawain_heat:IsDebuff()
	return false
end

function modifier_gawain_heat:RemoveOnDeath()
	return true
end

function modifier_gawain_heat:GetAttributes()
  return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_gawain_heat:GetEffectName()
	return "particles/units/heroes/hero_ember_spirit/ember_spirit_flameguard.vpcf"
end

function modifier_gawain_heat:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_gawain_heat:GetTexture()
	return "custom/gawain_meltdown"
end
