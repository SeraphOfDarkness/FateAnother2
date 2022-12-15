gilgamesh_enkidu = class({})
modifier_gilgamesh_combo_window = class({})

LinkLuaModifier("modifier_enkidu_hold", "abilities/gilgamesh/modifiers/modifier_enkidu_hold", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gilgamesh_combo_window", "abilities/gilgamesh/gilgamesh_enkidu", LUA_MODIFIER_MOTION_NONE)

function gilgamesh_enkidu:CastFilterResultTarget(hTarget)
	local filter = UnitFilter(hTarget, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, self:GetCaster():GetTeamNumber())
	
	return filter
end

function gilgamesh_enkidu:GetCastRange(vLocation, hTarget)
	return self:GetSpecialValueFor("cast_range")
end

function gilgamesh_enkidu:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	
	caster:EmitSound("Gilgamesh_Enkidu_2")

	local stopOrder = {
 		UnitIndex = target:entindex(), 
 		OrderType = DOTA_UNIT_ORDER_STOP
 	}

 	ExecuteOrderFromTable(stopOrder) 
 	if IsDivineServant(target) then
 		target:AddNewModifier(caster, self, "modifier_enkidu_hold", { Duration = self:GetSpecialValueFor("duration") + 0.5 })
 	else
		target:AddNewModifier(caster, self, "modifier_enkidu_hold", { Duration = self:GetSpecialValueFor("duration") })
 	end

 	if caster:GetStrength() >= 29.1 and caster:GetAgility() >= 29.1 and caster:GetIntellect() >= 29.1 then
 		if caster:FindAbilityByName("gilgamesh_combo_final_hour"):IsCooldownReady() then
 			caster:AddNewModifier(caster, self, "modifier_gilgamesh_combo_window", { Duration = 3 })
 		end 		
	end
end

if IsServer() then 
	function modifier_gilgamesh_combo_window:OnCreated(args)
		local caster = self:GetParent()
		caster:SwapAbilities("gilgamesh_combo_final_hour", "gilgamesh_gram", true, false)
	end

	function modifier_gilgamesh_combo_window:OnDestroy()
		local caster = self:GetParent()
		caster:SwapAbilities("gilgamesh_combo_final_hour", "gilgamesh_gram", false, true)
	end
end


function modifier_gilgamesh_combo_window:IsHidden()
	return true
end

function modifier_gilgamesh_combo_window:RemoveOnDeath()
	return true 
end