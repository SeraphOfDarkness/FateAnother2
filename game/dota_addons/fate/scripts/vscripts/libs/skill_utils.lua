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
    if not IsServer() or Caster:HasModifier(____exports.Modifier_Skill_Slot_Checker.name) then
        return
    end
    local OriSkill = Caster:FindAbilityByName(OriSkillStr)
    local TargetSkill = Caster:FindAbilityByName(TargetSkillStr)
    local ModifierSkillSlotChecker = Caster:AddNewModifier(Caster, nil, ____exports.Modifier_Skill_Slot_Checker.name, {duration = Timeout})
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
____exports.Modifier_Skill_Slot_Checker = __TS__Class()
local Modifier_Skill_Slot_Checker = ____exports.Modifier_Skill_Slot_Checker
Modifier_Skill_Slot_Checker.name = "Modifier_Skill_Slot_Checker"
__TS__ClassExtends(Modifier_Skill_Slot_Checker, BaseModifier)
function Modifier_Skill_Slot_Checker.prototype.____constructor(self, ...)
    BaseModifier.prototype.____constructor(self, ...)
    self.OriSkillIndex = 0
    self.SwapBackIfCasted = true
end
function Modifier_Skill_Slot_Checker.prototype.OnAbilityFullyCast(self, event)
    if not IsServer() then
        return
    end
    if event.ability == self.TargetSkill and self.SwapBackIfCasted then
        self:Destroy()
    end
end
function Modifier_Skill_Slot_Checker.prototype.OnDestroy(self)
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
function Modifier_Skill_Slot_Checker.prototype.DeclareFunctions(self)
    return {MODIFIER_EVENT_ON_ABILITY_FULLY_CAST}
end
function Modifier_Skill_Slot_Checker.prototype.IsHidden(self)
    return true
end
function Modifier_Skill_Slot_Checker.prototype.IsPurgable(self)
    return false
end
function Modifier_Skill_Slot_Checker.prototype.IsPurgeException(self)
    return false
end
function Modifier_Skill_Slot_Checker.prototype.RemoveOnDeath(self)
    return false
end
Modifier_Skill_Slot_Checker = __TS__Decorate(
    {registerModifier(nil)},
    Modifier_Skill_Slot_Checker
)
____exports.Modifier_Skill_Slot_Checker = Modifier_Skill_Slot_Checker
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
    local ModifierComboSequence = Caster:AddNewModifier(Caster, nil, ____exports.Modifier_Combo_Sequence.name, {duration = Timeout})
    ModifierComboSequence.SkillsSequence = SkillsSequence
    ModifierComboSequence.OriSkillStr = OriSkillStr
    ModifierComboSequence.ComboSkillStr = ComboSkillStr
end
____exports.Modifier_Combo_Sequence = __TS__Class()
local Modifier_Combo_Sequence = ____exports.Modifier_Combo_Sequence
Modifier_Combo_Sequence.name = "Modifier_Combo_Sequence"
__TS__ClassExtends(Modifier_Combo_Sequence, BaseModifier)
function Modifier_Combo_Sequence.prototype.OnAbilityFullyCast(self, event)
    if not IsServer() then
        return
    end
    local StackCount = self:GetStackCount()
    if event.ability:GetName() == self.SkillsSequence[StackCount + 1] then
        self:IncrementStackCount()
    else
        self:Destroy()
    end
end
function Modifier_Combo_Sequence.prototype.OnStackCountChanged(self, stackCount)
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
function Modifier_Combo_Sequence.prototype.DeclareFunctions(self)
    return {MODIFIER_EVENT_ON_ABILITY_FULLY_CAST}
end
function Modifier_Combo_Sequence.prototype.IsHidden(self)
    return false
end
function Modifier_Combo_Sequence.prototype.IsPurgable(self)
    return false
end
function Modifier_Combo_Sequence.prototype.IsPurgeException(self)
    return false
end
function Modifier_Combo_Sequence.prototype.RemoveOnDeath(self)
    return false
end
function Modifier_Combo_Sequence.prototype.GetTexture(self)
    return "custom/utils/ComboSequence"
end
Modifier_Combo_Sequence = __TS__Decorate(
    {registerModifier(nil)},
    Modifier_Combo_Sequence
)
____exports.Modifier_Combo_Sequence = Modifier_Combo_Sequence
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
return ____exports
