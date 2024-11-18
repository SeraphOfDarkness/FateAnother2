ereshkigal_attribute_territory = class({})

function ereshkigal_attribute_territory:OnSpellStart()
	local caster = self:GetCaster()
	local ply = caster:GetPlayerOwner()
	local hero = caster:GetPlayerOwner():GetAssignedHero()

	if not MasterCannotUpgrade(hero, caster, self, hero.IsTerritoryAcquired) then

		if hero:HasModifier("modifier_ereshkigal_combo_window") then
			hero:RemoveModifierByName("modifier_ereshkigal_combo_window")
		end

		hero.IsTerritoryAcquired = true

		if hero.IsUnderworldAcquired then 
			UpgradeAttribute(hero, 'ereshkigal_r_upgrade_2', 'ereshkigal_r_upgrade_3', true)
			hero.RSkill = "ereshkigal_r_upgrade_3"
		else
			UpgradeAttribute(hero, 'ereshkigal_r', 'ereshkigal_r_upgrade_1', true)
			hero.RSkill = "ereshkigal_r_upgrade_1"
		end
		
		--hero:SwapAbilities("fate_empty1", "ereshkigal_f", false, true)
		--hero.FSkill = "ereshkigal_f"

		NonResetAbility(hero)
		-- Set master 1's mana 
		local master = hero.MasterUnit
		master:SetMana(master:GetMana() - self:GetManaCost(self:GetLevel()))
	end
end

ereshkigal_attribute_divine = class({})

LinkLuaModifier("modifier_goddess_of_death_passive", "abilities/ereshkigal/ereshkigal_d", LUA_MODIFIER_MOTION_NONE)

function ereshkigal_attribute_divine:OnSpellStart()
	local caster = self:GetCaster()
	local ply = caster:GetPlayerOwner()
	local hero = caster:GetPlayerOwner():GetAssignedHero()

	if not MasterCannotUpgrade(hero, caster, self, hero.IsDivineAcquired) then
		hero.IsDivineAcquired = true

		if hero.IsCrownAcquired then 
			UpgradeAttribute(hero, 'ereshkigal_d_upgrade_2', 'ereshkigal_d_upgrade_3', true)
			hero.DSkill = "ereshkigal_d_upgrade_3"
		else
			UpgradeAttribute(hero, 'ereshkigal_d', 'ereshkigal_d_upgrade_1', true)
			hero.DSkill = "ereshkigal_d_upgrade_1"
		end

		hero:RemoveModifierByName('modifier_goddess_of_death_passive')
		hero:AddNewModifier(hero, hero:FindAbilityByName(hero.DSkill), "modifier_goddess_of_death_passive", {})

		NonResetAbility(hero)
		-- Set master 1's mana 
		local master = hero.MasterUnit
		master:SetMana(master:GetMana() - self:GetManaCost(self:GetLevel()))
	end
end

ereshkigal_attribute_crown = class({})

function ereshkigal_attribute_crown:OnSpellStart()
	local caster = self:GetCaster()
	local ply = caster:GetPlayerOwner()
	local hero = caster:GetPlayerOwner():GetAssignedHero()

	if not MasterCannotUpgrade(hero, caster, self, hero.IsCrownAcquired) then

		hero.IsCrownAcquired = true

		if hero.IsManaBurstAcquired then 
			UpgradeAttribute(hero, 'ereshkigal_w_upgrade_1', 'ereshkigal_w_upgrade_3', true)
			hero.WSkill = "ereshkigal_w_upgrade_3"
		else
			UpgradeAttribute(hero, 'ereshkigal_w', 'ereshkigal_w_upgrade_2', true)
			hero.WSkill = "ereshkigal_w_upgrade_2"
		end

		if hero.IsDivineAcquired then 
			UpgradeAttribute(hero, 'ereshkigal_d_upgrade_1', 'ereshkigal_d_upgrade_3', true)
			hero.DSkill = "ereshkigal_d_upgrade_3"
		else
			UpgradeAttribute(hero, 'ereshkigal_d', 'ereshkigal_d_upgrade_2', true)
			hero.DSkill = "ereshkigal_d_upgrade_2"
		end

		hero:RemoveModifierByName('modifier_goddess_of_death_passive')
		hero:AddNewModifier(hero, hero:FindAbilityByName(hero.DSkill), "modifier_goddess_of_death_passive", {})

		NonResetAbility(hero)
		-- Set master 1's mana 
		local master = hero.MasterUnit
		master:SetMana(master:GetMana() - self:GetManaCost(self:GetLevel()))
	end
end

ereshkigal_attribute_mana_burst = class({})

function ereshkigal_attribute_mana_burst:OnSpellStart()
	local caster = self:GetCaster()
	local ply = caster:GetPlayerOwner()
	local hero = caster:GetPlayerOwner():GetAssignedHero()

	if not MasterCannotUpgrade(hero, caster, self, hero.IsManaBurstAcquired) then

		hero.IsManaBurstAcquired = true

		UpgradeAttribute(hero, 'ereshkigal_q', 'ereshkigal_q_upgrade', true)
		hero.QSkill = "ereshkigal_q_upgrade"

		if hero.IsCrownAcquired then 
			UpgradeAttribute(hero, 'ereshkigal_w_upgrade_2', 'ereshkigal_w_upgrade_3', true)
			hero.WSkill = "ereshkigal_w_upgrade_3"
		else
			UpgradeAttribute(hero, 'ereshkigal_w', 'ereshkigal_w_upgrade_1', true)
			hero.WSkill = "ereshkigal_w_upgrade_1"
		end

		if hero.IsUnderworldAcquired then 
			UpgradeAttribute(hero, 'ereshkigal_e_upgrade_2', 'ereshkigal_e_upgrade_3', true)
			hero.ESkill = "ereshkigal_e_upgrade_3"
		else
			UpgradeAttribute(hero, 'ereshkigal_e', 'ereshkigal_e_upgrade_1', true)
			hero.ESkill = "ereshkigal_e_upgrade_1"
		end

		NonResetAbility(hero)
		-- Set master 1's mana 
		local master = hero.MasterUnit
		master:SetMana(master:GetMana() - self:GetManaCost(self:GetLevel()))
	end
end

ereshkigal_attribute_underworld = class({})

function ereshkigal_attribute_underworld:OnSpellStart()
	local caster = self:GetCaster()
	local ply = caster:GetPlayerOwner()
	local hero = caster:GetPlayerOwner():GetAssignedHero()

	if not MasterCannotUpgrade(hero, caster, self, hero.IsUnderworldAcquired) then

		if hero:HasModifier("modifier_ereshkigal_combo_window") then
			hero:RemoveModifierByName("modifier_ereshkigal_combo_window")
		end

		hero.IsUnderworldAcquired = true

		if hero.IsManaBurstAcquired then 
			UpgradeAttribute(hero, 'ereshkigal_e_upgrade_1', 'ereshkigal_e_upgrade_3', true)
			hero.ESkill = "ereshkigal_e_upgrade_3"
		else
			UpgradeAttribute(hero, 'ereshkigal_e', 'ereshkigal_e_upgrade_2', true)
			hero.ESkill = "ereshkigal_e_upgrade_2"
		end

		if hero.IsTerritoryAcquired then 
			UpgradeAttribute(hero, 'ereshkigal_r_upgrade_1', 'ereshkigal_r_upgrade_3', true)
			hero.RSkill = "ereshkigal_r_upgrade_3"
		else
			UpgradeAttribute(hero, 'ereshkigal_r', 'ereshkigal_r_upgrade_2', true)
			hero.RSkill = "ereshkigal_r_upgrade_2"
		end

		NonResetAbility(hero)
		-- Set master 1's mana 
		local master = hero.MasterUnit
		master:SetMana(master:GetMana() - self:GetManaCost(self:GetLevel()))
	end
end

