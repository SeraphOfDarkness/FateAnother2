local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local __TS__Decorate = ____lualib.__TS__Decorate
local __TS__ArrayFind = ____lualib.__TS__ArrayFind
local ____exports = {}
local ____dota_ts_adapter = require("libs.dota_ts_adapter")
local BaseModifier = ____dota_ts_adapter.BaseModifier
local registerModifier = ____dota_ts_adapter.registerModifier
function ____exports.InitSkillSlotChecker(Caster, OriSkillStr, TargetSkillStr, Timeout, SwapBackIfCasted)
    if not IsServer() then
        return
    end
    local OriSkill = Caster:FindAbilityByName(OriSkillStr)
    local TargetSkill = Caster:FindAbilityByName(TargetSkillStr)
    local ModifierSkillSlotChecker = Caster:AddNewModifier(Caster, OriSkill, ____exports.modifier_skill_slot_checker.name, {duration = Timeout})
    ModifierSkillSlotChecker.OriSkill = OriSkill
    ModifierSkillSlotChecker.TargetSkill = TargetSkill
    ModifierSkillSlotChecker.OriSkillIndex = OriSkill and OriSkill:GetAbilityIndex()
    local ____SwapBackIfCasted_2 = SwapBackIfCasted
    if ____SwapBackIfCasted_2 == nil then
        ____SwapBackIfCasted_2 = true
    end
    ModifierSkillSlotChecker.SwapBackIfCasted = ____SwapBackIfCasted_2
    Caster:SwapAbilities(OriSkillStr, TargetSkillStr, false, true)
end
____exports.modifier_skill_slot_checker = __TS__Class()
local modifier_skill_slot_checker = ____exports.modifier_skill_slot_checker
modifier_skill_slot_checker.name = "modifier_skill_slot_checker"
__TS__ClassExtends(modifier_skill_slot_checker, BaseModifier)
function modifier_skill_slot_checker.prototype.____constructor(self, ...)
    BaseModifier.prototype.____constructor(self, ...)
    self.OriSkillIndex = 0
    self.SwapBackIfCasted = true
end
function modifier_skill_slot_checker.prototype.OnAbilityFullyCast(self, event)
    if not IsServer() or event.unit ~= self:GetCaster() then
        return
    end
    if event.ability == self.TargetSkill and self.SwapBackIfCasted then
        self:Destroy()
    end
end
function modifier_skill_slot_checker.prototype.OnDestroy(self)
    if not IsServer() then
        return
    end
    local ____opt_3 = self.OriSkill
    local CurrentSkillIndex = ____opt_3 and ____opt_3:GetAbilityIndex()
    if CurrentSkillIndex ~= self.OriSkillIndex then
        local ____self_10 = self:GetParent()
        local ____self_10_SwapAbilities_11 = ____self_10.SwapAbilities
        local ____opt_5 = self.OriSkill
        local ____temp_9 = ____opt_5 and ____opt_5:GetName()
        local ____opt_7 = self.TargetSkill
        ____self_10_SwapAbilities_11(
            ____self_10,
            ____temp_9,
            ____opt_7 and ____opt_7:GetName(),
            true,
            false
        )
    end
end
function modifier_skill_slot_checker.prototype.DeclareFunctions(self)
    return {MODIFIER_EVENT_ON_ABILITY_FULLY_CAST}
end
function modifier_skill_slot_checker.prototype.IsHidden(self)
    return true
end
function modifier_skill_slot_checker.prototype.IsPurgable(self)
    return false
end
function modifier_skill_slot_checker.prototype.IsPurgeException(self)
    return false
end
function modifier_skill_slot_checker.prototype.RemoveOnDeath(self)
    return false
end
function modifier_skill_slot_checker.prototype.GetAttributes(self)
    return MODIFIER_ATTRIBUTE_MULTIPLE
end
modifier_skill_slot_checker = __TS__Decorate(
    {registerModifier(nil)},
    modifier_skill_slot_checker
)
____exports.modifier_skill_slot_checker = modifier_skill_slot_checker
function ____exports.CheckComboStatsFulfilled(Caster)
    if not IsServer() then
        return false
    end
    local Hero = Caster
    local StatsRequired = 25
    local CurrentStr = Hero:GetStrength()
    local CurrentAgi = Hero:GetAgility()
    local CurrentInt = Hero:GetIntellect()
    if CurrentStr >= StatsRequired and CurrentAgi >= StatsRequired and CurrentInt >= StatsRequired then
        return true
    end
    return false
end
function ____exports.InitComboSequenceChecker(Caster, SkillsSequence, OriSkillStr, ComboSkillStr, Timeout)
    if not IsServer() then
        return
    end
    local ModifierComboSequence = Caster:AddNewModifier(Caster, nil, ____exports.modifier_combo_sequence.name, {duration = Timeout})
    ModifierComboSequence.SkillsSequence = SkillsSequence
    ModifierComboSequence.OriSkillStr = OriSkillStr
    ModifierComboSequence.ComboSkillStr = ComboSkillStr
end
____exports.modifier_combo_sequence = __TS__Class()
local modifier_combo_sequence = ____exports.modifier_combo_sequence
modifier_combo_sequence.name = "modifier_combo_sequence"
__TS__ClassExtends(modifier_combo_sequence, BaseModifier)
function modifier_combo_sequence.prototype.OnAbilityFullyCast(self, event)
    if not IsServer() or event.unit ~= self:GetCaster() then
        return
    end
    local StackCount = self:GetStackCount()
    do
        if event.ability:GetName() == self.SkillsSequence[StackCount + 1] then
            self:IncrementStackCount()
        else
            self:Destroy()
        end
    end
end
function modifier_combo_sequence.prototype.OnStackCountChanged(self, stackCount)
    if not IsServer() then
        return
    end
    local ____stackCount_14 = stackCount
    local ____opt_12 = self.SkillsSequence
    if ____stackCount_14 == (____opt_12 and #____opt_12) - 1 then
        local Caster = self:GetCaster()
        ____exports.InitSkillSlotChecker(
            Caster,
            self.OriSkillStr,
            self.ComboSkillStr,
            self:GetRemainingTime(),
            true
        )
    end
end
function modifier_combo_sequence.prototype.DeclareFunctions(self)
    return {MODIFIER_EVENT_ON_ABILITY_FULLY_CAST}
end
function modifier_combo_sequence.prototype.IsHidden(self)
    return false
end
function modifier_combo_sequence.prototype.IsPurgable(self)
    return false
end
function modifier_combo_sequence.prototype.IsPurgeException(self)
    return false
end
function modifier_combo_sequence.prototype.RemoveOnDeath(self)
    return false
end
function modifier_combo_sequence.prototype.GetTexture(self)
    return "custom/utils/ComboSequence"
end
modifier_combo_sequence = __TS__Decorate(
    {registerModifier(nil)},
    modifier_combo_sequence
)
____exports.modifier_combo_sequence = modifier_combo_sequence
function ____exports.GetMaster1(Master2)
    if not IsServer() then
        return
    end
    local TargetFlags = DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED
    local Units = FindUnitsInRadius(
        Master2:GetTeam(),
        Master2:GetAbsOrigin(),
        nil,
        400,
        DOTA_UNIT_TARGET_TEAM_FRIENDLY,
        DOTA_UNIT_TARGET_ALL,
        TargetFlags,
        FIND_CLOSEST,
        false
    )
    return __TS__ArrayFind(
        Units,
        function(____, Unit) return Unit:GetUnitName() == "master_1" and Unit:GetPlayerOwner() == Master2:GetPlayerOwner() end
    )
end
function ____exports.ApplySaWhenRevived(Master2, AttributeAbility, AttributeModifier)
    if not IsServer() then
        return
    end
    local ModifierHeroAliveChecker = Master2:AddNewModifier(Master2, AttributeAbility, ____exports.modifier_hero_alive_checker.name, {undefined = undefined})
    ModifierHeroAliveChecker.AttributeAbility = AttributeAbility
    ModifierHeroAliveChecker.AttributeModifier = AttributeModifier
end
____exports.modifier_hero_alive_checker = __TS__Class()
local modifier_hero_alive_checker = ____exports.modifier_hero_alive_checker
modifier_hero_alive_checker.name = "modifier_hero_alive_checker"
__TS__ClassExtends(modifier_hero_alive_checker, BaseModifier)
function modifier_hero_alive_checker.prototype.____constructor(self, ...)
    BaseModifier.prototype.____constructor(self, ...)
    self.AttributeModifier = ""
end
function modifier_hero_alive_checker.prototype.OnCreated(self)
    if not IsServer() then
        return
    end
    self.Master2 = self:GetParent()
    self.Hero = self.Master2:GetPlayerOwner():GetAssignedHero()
    self:StartIntervalThink(0.1)
end
function modifier_hero_alive_checker.prototype.OnIntervalThink(self)
    if not IsServer() then
        return
    end
    local ____opt_15 = self.Hero
    if ____opt_15 and ____opt_15:IsAlive() then
        self:Destroy()
    end
end
function modifier_hero_alive_checker.prototype.OnDestroy(self)
    if not IsServer() then
        return
    end
    local ____opt_17 = self.Hero
    if ____opt_17 ~= nil then
        ____opt_17:AddNewModifier(self.Master2, self.AttributeAbility, self.AttributeModifier, {undefined = undefined})
    end
end
function modifier_hero_alive_checker.prototype.IsPurgable(self)
    return false
end
function modifier_hero_alive_checker.prototype.IsPurgeException(self)
    return false
end
function modifier_hero_alive_checker.prototype.IsHidden(self)
    return true
end
function modifier_hero_alive_checker.prototype.IsPermanent(self)
    return true
end
function modifier_hero_alive_checker.prototype.GetAttributes(self)
    return MODIFIER_ATTRIBUTE_MULTIPLE
end
modifier_hero_alive_checker = __TS__Decorate(
    {registerModifier(nil)},
    modifier_hero_alive_checker
)
____exports.modifier_hero_alive_checker = modifier_hero_alive_checker
return ____exports
