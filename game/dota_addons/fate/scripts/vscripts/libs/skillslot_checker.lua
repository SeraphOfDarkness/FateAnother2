local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local __TS__Decorate = ____lualib.__TS__Decorate
local ____exports = {}
require("libs.dota_ts_adapter")
local ____dota_ts_adapter = require("libs.dota_ts_adapter")
local BaseModifier = ____dota_ts_adapter.BaseModifier
local registerModifier = ____dota_ts_adapter.registerModifier
function ____exports.SkillSlotChecker(self, Caster, OriSkillStr, TargetSkillStr, Timeout, SwapBackIfCasted)
    local OriSkill = Caster:FindAbilityByName(OriSkillStr)
    local TargetSkill = Caster:FindAbilityByName(TargetSkillStr)
    local CheckerBuff = Caster:AddNewModifier(Caster, OriSkill, ____exports.Modifier_Skill_Slot_Checker.name, {duration = Timeout})
    CheckerBuff.OriSkill = OriSkill
    CheckerBuff.TargetSkill = TargetSkill
    CheckerBuff.OriSkillIndex = OriSkill and OriSkill:GetAbilityIndex()
    local ____SwapBackIfCasted_2 = SwapBackIfCasted
    if ____SwapBackIfCasted_2 == nil then
        ____SwapBackIfCasted_2 = true
    end
    CheckerBuff.SwapBackIfCasted = ____SwapBackIfCasted_2
    Caster:SwapAbilities(OriSkillStr, TargetSkillStr, false, true)
    CheckerBuff:StartIntervalThink(0.1)
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
function Modifier_Skill_Slot_Checker.prototype.OnIntervalThink(self)
    if not IsServer() then
        return
    end
    if self.SwapBackIfCasted then
        local ____opt_3 = self.TargetSkill
        if not (____opt_3 and ____opt_3:IsCooldownReady()) then
            self:Destroy()
        end
    end
end
function Modifier_Skill_Slot_Checker.prototype.OnDestroy(self)
    if not IsServer() then
        return
    end
    local ____self_9 = self:GetParent()
    local ____self_9_FindAbilityByName_10 = ____self_9.FindAbilityByName
    local ____opt_7 = self.OriSkill
    local ____opt_5 = ____self_9_FindAbilityByName_10(
        ____self_9,
        ____opt_7 and ____opt_7:GetName()
    )
    local CurrentSkillIndex = ____opt_5 and ____opt_5:GetAbilityIndex()
    if CurrentSkillIndex ~= self.OriSkillIndex then
        local ____self_16 = self:GetParent()
        local ____self_16_SwapAbilities_17 = ____self_16.SwapAbilities
        local ____opt_11 = self.OriSkill
        local ____temp_15 = ____opt_11 and ____opt_11:GetName()
        local ____opt_13 = self.TargetSkill
        ____self_16_SwapAbilities_17(
            ____self_16,
            ____temp_15,
            ____opt_13 and ____opt_13:GetName(),
            true,
            false
        )
    end
end
function Modifier_Skill_Slot_Checker.prototype.IsHidden(self)
    return true
end
Modifier_Skill_Slot_Checker = __TS__Decorate(
    {registerModifier(nil)},
    Modifier_Skill_Slot_Checker
)
____exports.Modifier_Skill_Slot_Checker = Modifier_Skill_Slot_Checker
return ____exports
