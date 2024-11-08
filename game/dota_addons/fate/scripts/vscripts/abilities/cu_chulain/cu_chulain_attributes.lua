cu_attribute_improve_battle_continuation = class({})
cu_attribute_death_flight = class({})
cu_attribute_protection_from_arrows = class({})
cu_attribute_the_heartseeker = class({})
cu_attribute_celtic_runes = class({})

function cu_attribute_improve_battle_continuation:OnSpellStart()
	local caster = self:GetCaster()
	local ply = caster:GetPlayerOwner()
	local hero = caster:GetPlayerOwner():GetAssignedHero()

	if not MasterCannotUpgrade(hero, caster, self, hero.IsBCImproved) then
		hero.IsBCImproved = true

		local IsShow = true 

		if hero.IsHeartSeekerAcquired then 
			IsShow = false 
		end

		hero:RemoveModifierByName('modifier_cu_battle_continuation')

		if hero.IsCelticRuneAcquired then 
			UpgradeAttribute(hero, 'cu_chulain_battle_continuation_upgrade_2', 'cu_chulain_battle_continuation_upgrade_3', IsShow)
			if IsShow == true then 
				hero.FSkill = "cu_chulain_battle_continuation_upgrade_3"
			end
			hero:AddNewModifier(hero, hero:FindAbilityByName("cu_chulain_battle_continuation_upgrade_3"), "modifier_cu_battle_continuation", {})
		else
			UpgradeAttribute(hero, 'cu_chulain_battle_continuation', 'cu_chulain_battle_continuation_upgrade_1', IsShow)
			if IsShow == true then 
				hero.FSkill = "cu_chulain_battle_continuation_upgrade_1"
			end
			hero:AddNewModifier(hero, hero:FindAbilityByName("cu_chulain_battle_continuation_upgrade_1") , "modifier_cu_battle_continuation", {})
		end

		
		

		NonResetAbility(hero)

		-- Set master 1's mana 
		local master = hero.MasterUnit
		master:SetMana(master:GetMana() - self:GetManaCost(self:GetLevel()))
	end
end

------------------------------------------

function cu_attribute_death_flight:OnSpellStart()
	local caster = self:GetCaster()
	local ply = caster:GetPlayerOwner()
	local hero = caster:GetPlayerOwner():GetAssignedHero()

	if not MasterCannotUpgrade(hero, caster, self, hero.IsDeathFlightAcquired) then
		hero.IsDeathFlightAcquired = true

		UpgradeAttribute(hero, 'cu_chulain_gae_bolg_jump', 'cu_chulain_gae_bolg_jump_upgrade', true)
		hero.RSkill = "cu_chulain_gae_bolg_jump_upgrade"

		NonResetAbility(hero)

		-- Set master 1's mana 
		local master = hero.MasterUnit
		master:SetMana(master:GetMana() - self:GetManaCost(self:GetLevel()))
	end
end

-----------------------------------

function cu_attribute_protection_from_arrows:OnSpellStart()
	local caster = self:GetCaster()
	local ply = caster:GetPlayerOwner()
	local hero = caster:GetPlayerOwner():GetAssignedHero()

	if not MasterCannotUpgrade(hero, caster, self, hero.IsPFAAcquired) then
		hero.IsPFAAcquired = true

		hero:FindAbilityByName("cu_chulain_protection_from_arrows"):SetLevel(1) 
		hero:SwapAbilities("fate_empty1" , "cu_chulain_protection_from_arrows", false, true)
		hero.DSkill = "cu_chulain_protection_from_arrows"

		NonResetAbility(hero)

		-- Set master 1's mana 
		local master = hero.MasterUnit
		master:SetMana(master:GetMana() - self:GetManaCost(self:GetLevel()))
	end
end

--------------------------------------

function cu_attribute_the_heartseeker:OnSpellStart()
	local caster = self:GetCaster()
	local ply = caster:GetPlayerOwner()
	local hero = caster:GetPlayerOwner():GetAssignedHero()

	if not MasterCannotUpgrade(hero, caster, self, hero.IsHeartSeekerAcquired) then
		hero.IsHeartSeekerAcquired = true

		if hero:HasModifier("modifier_wesen_window") then 
			hero:RemoveModifierByName("modifier_wesen_window")
		end 

		UpgradeAttribute(hero, 'cu_chulain_gae_bolg', 'cu_chulain_gae_bolg_upgrade', true)
		UpgradeAttribute(hero, 'cu_chulain_gae_bolg_combo', 'cu_chulain_gae_bolg_combo_upgrade', false)
		if hero.IsCelticRuneAcquired then 
			hero:SwapAbilities(hero.FSkill , "cu_chulain_claw_upgrade", false, true)
			hero.FSkill = "cu_chulain_claw_upgrade"
		else
			hero:SwapAbilities(hero.FSkill , "cu_chulain_claw", false, true)
			hero.FSkill = "cu_chulain_claw"
		end
		hero.ESkill = "cu_chulain_gae_bolg_upgrade"
		hero.ComboSkill = "cu_chulain_gae_bolg_combo_upgrade"

		NonResetAbility(hero)

		-- Set master 1's mana 
		local master = hero.MasterUnit
		master:SetMana(master:GetMana() - self:GetManaCost(self:GetLevel()))
	end
end

-------------------------------------

function cu_attribute_celtic_runes:OnSpellStart()
	local caster = self:GetCaster()
	local ply = caster:GetPlayerOwner()
	local hero = caster:GetPlayerOwner():GetAssignedHero()

	if not MasterCannotUpgrade(hero, caster, self, hero.IsCelticRuneAcquired) then
		hero.IsCelticRuneAcquired = true

		if hero:HasModifier("modifier_relentless_window") then 
			hero:RemoveModifierByName("modifier_relentless_window")
		end 

		UpgradeAttribute(hero, 'cu_chulain_disengage', 'cu_chulain_disengage_upgrade', true)
		UpgradeAttribute(hero, 'cu_chulain_piercing_spear', 'cu_chulain_piercing_spear_upgrade', true)
		UpgradeAttribute(hero, 'cu_chulain_relentless_spear', 'cu_chulain_relentless_spear_upgrade', false)

		hero.QSkill = "cu_chulain_disengage_upgrade"
		hero.WSkill = "cu_chulain_piercing_spear_upgrade"

		hero:RemoveModifierByName('modifier_cu_battle_continuation')

		if hero.IsHeartSeekerAcquired then 
			UpgradeAttribute(hero, 'cu_chulain_claw', 'cu_chulain_claw_upgrade', true)
			hero.FSkill = "cu_chulain_claw_upgrade"
			if hero.IsBCImproved then 
				UpgradeAttribute(hero, 'cu_chulain_battle_continuation_upgrade_1', 'cu_chulain_battle_continuation_upgrade_3', false)
				hero:AddNewModifier(hero, hero:FindAbilityByName("cu_chulain_battle_continuation_upgrade_3") , "modifier_cu_battle_continuation", {})
			else
				UpgradeAttribute(hero, 'cu_chulain_battle_continuation', 'cu_chulain_battle_continuation_upgrade_2', false)
				hero:AddNewModifier(hero, hero:FindAbilityByName("cu_chulain_battle_continuation_upgrade_2") , "modifier_cu_battle_continuation", {})
			end
		else
			UpgradeAttribute(hero, 'cu_chulain_claw', 'cu_chulain_claw_upgrade', false)
			if hero.IsBCImproved then 
				UpgradeAttribute(hero, 'cu_chulain_battle_continuation_upgrade_1', 'cu_chulain_battle_continuation_upgrade_3', true)
				hero.FSkill = "cu_chulain_battle_continuation_upgrade_3"
				hero:AddNewModifier(hero, hero:FindAbilityByName("cu_chulain_battle_continuation_upgrade_3") , "modifier_cu_battle_continuation", {})
			else
				UpgradeAttribute(hero, 'cu_chulain_battle_continuation', 'cu_chulain_battle_continuation_upgrade_2', true)
				hero.FSkill = "cu_chulain_battle_continuation_upgrade_2"
				hero:AddNewModifier(hero, hero:FindAbilityByName("cu_chulain_battle_continuation_upgrade_2") , "modifier_cu_battle_continuation", {})
			end
		end


		NonResetAbility(hero)

		-- Set master 1's mana 
		local master = hero.MasterUnit
		master:SetMana(master:GetMana() - self:GetManaCost(self:GetLevel()))
	end
end
