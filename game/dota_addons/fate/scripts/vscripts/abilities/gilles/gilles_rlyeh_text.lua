gilles_rlyeh_text_open = class({})
gilles_rlyeh_text_close = class({})
modifier_gilles_rlyeh_text_window = class({})

LinkLuaModifier("modifier_gilles_rlyeh_text_window", "abilities/gilles/gilles_rlyeh_text", LUA_MODIFIER_MOTION_NONE)

function gilles_rlyeh_text_open:OnUpgrade()
    local hCaster = self:GetCaster()
    
    hCaster:FindAbilityByName("gilles_torment"):SetLevel(self:GetLevel())
    hCaster:FindAbilityByName("gilles_smother"):SetLevel(self:GetLevel())
    hCaster:FindAbilityByName("gilles_hysteria"):SetLevel(self:GetLevel())
    hCaster:FindAbilityByName("gilles_grief"):SetLevel(self:GetLevel())
    hCaster:FindAbilityByName("gilles_misery"):SetLevel(self:GetLevel())
end

function gilles_rlyeh_text_open:OnSpellStart()
    local hCaster = self:GetCaster()
    if hCaster:HasModifier("modifier_gilles_combo_window") then 
        hCaster:RemoveModifierByName("modifier_gilles_combo_window")
    end
    
    hCaster:AddNewModifier(hCaster, self, "modifier_gilles_rlyeh_text_window", {})

    if hCaster.IsDemonicHordeAcquired then 
        hCaster:SwapAbilities("gilles_torment", "gilles_summon_jellyfish_upgrade", true, false)
    else
        hCaster:SwapAbilities("gilles_torment", "gilles_summon_jellyfish", true, false)
    end

    hCaster:SwapAbilities("gilles_smother", "gilles_rlyeh_text_open", true, false)

    if hCaster.IsSunkenCityAcquired then 
        hCaster:SwapAbilities("gilles_hysteria", "gilles_cthulhu_favour_upgrade", true, false)
    else
        hCaster:SwapAbilities("gilles_hysteria", "gilles_cthulhu_favour", true, false)
    end

    if hCaster.IsOuterGodAcquired then 
        hCaster:SwapAbilities("gilles_grief", "gilles_prelati_spellbook_upgrade", true, false)
    else
        hCaster:SwapAbilities("gilles_grief", "gilles_prelati_spellbook", true, false)
    end

    if hCaster.IsEyeOfArtAcquired then 
        hCaster:SwapAbilities("gilles_rlyeh_text_close", "gilles_eye_for_art_passive", true, false)
    else
        hCaster:SwapAbilities("gilles_rlyeh_text_close", "fate_empty1", true, false)
    end

    if hCaster.IsAbyssalConnectionAcquired then 
        hCaster:SwapAbilities("gilles_misery", "gilles_abyssal_contract_upgrade", true, false)
    else
        hCaster:SwapAbilities("gilles_misery", "gilles_abyssal_contract", true, false)
    end
end

function gilles_rlyeh_text_close:OnSpellStart()
    local hCaster = self:GetCaster()

    hCaster:RemoveModifierByName("modifier_gilles_rlyeh_text_window")

    if hCaster.IsDemonicHordeAcquired then 
        hCaster:SwapAbilities("gilles_torment", "gilles_summon_jellyfish_upgrade", false, true)
    else
        hCaster:SwapAbilities("gilles_torment", "gilles_summon_jellyfish", false, true)
    end

    hCaster:SwapAbilities("gilles_smother", "gilles_rlyeh_text_open", false, true)

    if hCaster.IsSunkenCityAcquired then 
        hCaster:SwapAbilities("gilles_hysteria", "gilles_cthulhu_favour_upgrade", false, true)
    else
        hCaster:SwapAbilities("gilles_hysteria", "gilles_cthulhu_favour", false, true)
    end

    if hCaster.IsOuterGodAcquired then 
        hCaster:SwapAbilities("gilles_grief", "gilles_prelati_spellbook_upgrade", false, true)
    else
        hCaster:SwapAbilities("gilles_grief", "gilles_prelati_spellbook", false, true)
    end

    if hCaster.IsEyeOfArtAcquired then 
        hCaster:SwapAbilities("gilles_rlyeh_text_close", "gilles_eye_for_art_passive", false, true)
    else
        hCaster:SwapAbilities("gilles_rlyeh_text_close", "fate_empty1", false, true)
    end

    if hCaster.IsAbyssalConnectionAcquired then 
        hCaster:SwapAbilities("gilles_misery", "gilles_abyssal_contract_upgrade", false, true)
    else
        hCaster:SwapAbilities("gilles_misery", "gilles_abyssal_contract", false, true)
    end
end

function modifier_gilles_rlyeh_text_window:OnCreated()
    local hCaster = self:GetCaster()

    
end

function modifier_gilles_rlyeh_text_window:OnDestroy()
    local hCaster = self:GetCaster()

    
end

function modifier_gilles_rlyeh_text_window:IsHidden()
    return true 
end 

function modifier_gilles_rlyeh_text_window:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT
end