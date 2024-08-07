LinkLuaModifier("modifier_mordred_shield", "abilities/mordred/mordred_curse_passive", LUA_MODIFIER_MOTION_NONE)

mordred_curse_passive = class({})

function mordred_curse_passive:ShieldCharge()
	local caster = self:GetCaster()
	local ability = self
	local ply = caster:GetPlayerOwner()
	local ShieldAmount = (caster:GetAbilityByIndex(0):GetLevel() + caster:GetAbilityByIndex(1):GetLevel() + caster:FindAbilityByName("mordred_mb_lightning"):GetLevel())*10
	local MaxShield = caster:GetMaxHealth()/4

	caster:AddNewModifier(caster, self, "modifier_mordred_shield", {})
	
	if caster.argosShieldAmount == nil then 
		caster.argosShieldAmount = ShieldAmount
	else
		caster.argosShieldAmount = caster.argosShieldAmount + ShieldAmount
	end
	if caster.argosShieldAmount > MaxShield then
		caster.argosShieldAmount = MaxShield
	end
	caster:SetModifierStackCount("modifier_mordred_shield", caster, caster.argosShieldAmount/10)
	
	-- Create particle
	if caster.argosDurabilityParticleIndex == nil then
		local prev_amount = 0.0
		Timers:CreateTimer( function()
				-- Check if shield still valid
				if caster.argosShieldAmount > 0 and caster:HasModifier( "modifier_mordred_shield" ) then
					-- Check if it should update
					if prev_amount ~= caster.argosShieldAmount then
						-- Change particle
						local digit = 0
						if caster.argosShieldAmount > 999 then
							digit = 4
						elseif caster.argosShieldAmount > 99 then
							digit = 3
						elseif caster.argosShieldAmount > 9 then
							digit = 2
						else
							digit = 1
						end
						if caster.argosDurabilityParticleIndex ~= nil then
							-- Destroy previous
							ParticleManager:DestroyParticle( caster.argosDurabilityParticleIndex, true )
							ParticleManager:ReleaseParticleIndex( caster.argosDurabilityParticleIndex )
						end
						-- Create new one
						caster.argosDurabilityParticleIndex = ParticleManager:CreateParticle( "particles/custom/caster/caster_argos_durability.vpcf", PATTACH_CUSTOMORIGIN, caster )
						ParticleManager:SetParticleControlEnt( caster.argosDurabilityParticleIndex, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_origin", caster:GetAbsOrigin(), true )
						ParticleManager:SetParticleControl( caster.argosDurabilityParticleIndex, 1, Vector( 0, math.floor( caster.argosShieldAmount ), 0 ) )
						ParticleManager:SetParticleControl( caster.argosDurabilityParticleIndex, 2, Vector( 1, digit, 0 ) )
						ParticleManager:SetParticleControl( caster.argosDurabilityParticleIndex, 3, Vector( 100, 100, 255 ) )
						
						prev_amount = caster.argosShieldAmount	
					end
					
					return 0.1
				else
					if caster.argosDurabilityParticleIndex ~= nil then
						ParticleManager:DestroyParticle( caster.argosDurabilityParticleIndex, true )
						ParticleManager:ReleaseParticleIndex( caster.argosDurabilityParticleIndex )
						caster.argosDurabilityParticleIndex = nil
					end
					return nil
				end
			end
		)
	end
end

modifier_mordred_shield = class({})

function modifier_mordred_shield:DeclareFunctions()
	return { MODIFIER_EVENT_ON_TAKEDAMAGE,
			 }
end

function modifier_mordred_shield:OnTakeDamage(args)
	if args.unit ~= self:GetParent() then return end
	local caster = self:GetParent() 
	local currentHealth = caster:GetHealth() 

	-- Create particles
	local onHitParticleIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_templar_assassin/templar_assassin_refract_hit_sphere.vpcf", PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControl( onHitParticleIndex, 2, caster:GetAbsOrigin() )
	
	Timers:CreateTimer( 0.5, function()
			ParticleManager:DestroyParticle( onHitParticleIndex, false )
			ParticleManager:ReleaseParticleIndex( onHitParticleIndex )
		end
	)

	caster.argosShieldAmount = caster.argosShieldAmount - args.damage
	if caster.argosShieldAmount <= 0 then
		if currentHealth + caster.argosShieldAmount <= 0 then
			print("lethal")
		else
			print("argos broken, but not lethal")
			caster:RemoveModifierByName("modifier_mordred_shield")
			caster:SetHealth(currentHealth + args.damage + caster.argosShieldAmount)
			caster.argosShieldAmount = 0
		end
	else
		print("argos not broken, remaining shield : " .. caster.argosShieldAmount)
		caster:SetHealth(currentHealth + args.damage)
		caster:SetModifierStackCount("modifier_mordred_shield", caster, caster.argosShieldAmount/10)
	end
end