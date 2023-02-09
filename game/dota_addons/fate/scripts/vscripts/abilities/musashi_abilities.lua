local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local __TS__Decorate = ____lualib.__TS__Decorate
local __TS__AsyncAwaiter = ____lualib.__TS__AsyncAwaiter
local __TS__Await = ____lualib.__TS__Await
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["10"] = 1,["11"] = 1,["12"] = 1,["13"] = 1,["14"] = 1,["15"] = 2,["16"] = 2,["17"] = 8,["18"] = 9,["19"] = 8,["20"] = 9,["22"] = 9,["23"] = 11,["24"] = 12,["25"] = 8,["26"] = 15,["27"] = 17,["28"] = 18,["29"] = 19,["30"] = 20,["31"] = 15,["32"] = 23,["33"] = 25,["34"] = 26,["35"] = 23,["36"] = 9,["37"] = 8,["38"] = 9,["40"] = 9,["41"] = 30,["42"] = 31,["43"] = 30,["44"] = 31,["46"] = 31,["47"] = 33,["48"] = 34,["49"] = 35,["50"] = 37,["51"] = 38,["52"] = 30,["53"] = 43,["54"] = 45,["55"] = 46,["56"] = 47,["57"] = 48,["58"] = 49,["59"] = 43,["60"] = 52,["61"] = 54,["62"] = 55,["63"] = 56,["64"] = 52,["65"] = 59,["66"] = 61,["67"] = 61,["68"] = 63,["69"] = 64,["70"] = 65,["72"] = 68,["73"] = 69,["74"] = 70,["75"] = 71,["76"] = 71,["77"] = 71,["78"] = 71,["79"] = 71,["80"] = 71,["81"] = 71,["82"] = 71,["83"] = 71,["84"] = 73,["85"] = 73,["86"] = 73,["87"] = 73,["88"] = 73,["89"] = 73,["90"] = 73,["91"] = 73,["92"] = 73,["93"] = 59,["94"] = 77,["95"] = 79,["96"] = 77,["97"] = 82,["98"] = 84,["99"] = 82,["100"] = 87,["101"] = 89,["102"] = 87,["103"] = 92,["104"] = 94,["105"] = 92,["106"] = 97,["107"] = 99,["108"] = 97,["109"] = 31,["110"] = 30,["111"] = 31,["113"] = 31,["114"] = 106,["115"] = 107,["116"] = 106,["117"] = 107,["119"] = 107,["120"] = 109,["121"] = 110,["122"] = 106,["123"] = 113,["124"] = 115,["125"] = 116,["126"] = 117,["127"] = 118,["128"] = 113,["129"] = 121,["130"] = 123,["131"] = 124,["132"] = 121,["133"] = 107,["134"] = 106,["135"] = 107,["137"] = 107,["138"] = 128,["139"] = 129,["140"] = 128,["141"] = 129,["143"] = 129,["144"] = 131,["145"] = 132,["146"] = 134,["147"] = 128,["148"] = 138,["149"] = 140,["150"] = 141,["151"] = 142,["152"] = 143,["153"] = 138,["154"] = 146,["155"] = 148,["156"] = 149,["157"] = 146,["158"] = 152,["159"] = 154,["160"] = 154,["161"] = 156,["162"] = 157,["164"] = 160,["165"] = 161,["166"] = 163,["167"] = 163,["168"] = 165,["169"] = 165,["170"] = 165,["171"] = 165,["172"] = 165,["173"] = 165,["174"] = 165,["175"] = 165,["176"] = 165,["178"] = 152,["179"] = 170,["180"] = 172,["181"] = 170,["182"] = 175,["183"] = 177,["184"] = 175,["185"] = 129,["186"] = 128,["187"] = 129,["189"] = 129,["190"] = 184,["191"] = 185,["192"] = 184,["193"] = 185,["195"] = 185,["196"] = 187,["197"] = 188,["198"] = 194,["199"] = 195,["200"] = 196,["201"] = 184,["202"] = 198,["203"] = 200,["204"] = 201,["205"] = 202,["206"] = 202,["207"] = 202,["208"] = 202,["209"] = 203,["210"] = 204,["211"] = 205,["213"] = 205,["215"] = 206,["216"] = 198,["217"] = 209,["218"] = 211,["220"] = 211,["222"] = 209,["223"] = 214,["224"] = 229,["225"] = 230,["226"] = 231,["228"] = 231,["230"] = 232,["231"] = 214,["232"] = 235,["233"] = 237,["234"] = 239,["235"] = 241,["236"] = 242,["237"] = 244,["238"] = 244,["239"] = 244,["240"] = 244,["241"] = 244,["242"] = 244,["243"] = 244,["244"] = 244,["245"] = 244,["246"] = 244,["247"] = 244,["248"] = 248,["249"] = 250,["250"] = 252,["251"] = 252,["252"] = 252,["253"] = 252,["254"] = 252,["255"] = 252,["256"] = 250,["258"] = 263,["259"] = 264,["260"] = 266,["261"] = 268,["262"] = 270,["263"] = 272,["264"] = 272,["265"] = 272,["266"] = 272,["267"] = 272,["268"] = 272,["269"] = 270,["271"] = 283,["273"] = 286,["275"] = 289,["277"] = 235,["278"] = 293,["279"] = 295,["280"] = 296,["281"] = 298,["282"] = 300,["284"] = 300,["287"] = 304,["289"] = 304,["292"] = 293,["293"] = 308,["294"] = 310,["295"] = 308,["296"] = 330,["297"] = 332,["299"] = 332,["301"] = 330,["302"] = 335,["303"] = 337,["304"] = 335,["305"] = 185,["306"] = 184,["307"] = 185,["309"] = 185,["310"] = 344,["311"] = 345,["312"] = 344,["313"] = 345,["314"] = 349,["315"] = 351,["316"] = 352,["317"] = 349,["318"] = 355,["319"] = 357,["320"] = 358,["321"] = 358,["322"] = 358,["323"] = 358,["324"] = 358,["325"] = 358,["326"] = 358,["327"] = 358,["328"] = 359,["329"] = 360,["330"] = 361,["331"] = 355,["332"] = 364,["334"] = 366,["336"] = 366,["338"] = 367,["339"] = 368,["341"] = 368,["344"] = 364,["345"] = 345,["346"] = 344,["347"] = 345,["349"] = 345,["350"] = 372,["351"] = 373,["352"] = 372,["353"] = 373,["354"] = 375,["355"] = 377,["356"] = 378,["357"] = 378,["358"] = 378,["359"] = 378,["360"] = 378,["361"] = 378,["362"] = 378,["363"] = 378,["364"] = 388,["365"] = 375,["366"] = 391,["367"] = 393,["368"] = 391,["369"] = 396,["370"] = 398,["371"] = 396,["372"] = 401,["373"] = 403,["374"] = 401,["375"] = 406,["376"] = 408,["377"] = 406,["378"] = 373,["379"] = 372,["380"] = 373,["382"] = 373});
local ____exports = {}
local ____dota_ts_adapter = require("lib.dota_ts_adapter")
local BaseAbility = ____dota_ts_adapter.BaseAbility
local BaseModifier = ____dota_ts_adapter.BaseModifier
local registerAbility = ____dota_ts_adapter.registerAbility
local registerModifier = ____dota_ts_adapter.registerModifier
local ____sleep_timer = require("lib.sleep_timer")
local Sleep = ____sleep_timer.Sleep
____exports.musashi_dai_go_sei = __TS__Class()
local musashi_dai_go_sei = ____exports.musashi_dai_go_sei
musashi_dai_go_sei.name = "musashi_dai_go_sei"
__TS__ClassExtends(musashi_dai_go_sei, BaseAbility)
function musashi_dai_go_sei.prototype.____constructor(self, ...)
    BaseAbility.prototype.____constructor(self, ...)
    self.sound_voiceline = "antimage_anti_cast_01"
    self.sound_sfx = "musashi_dai_go_sei_sfx"
end
function musashi_dai_go_sei.prototype.OnSpellStart(self)
    self.caster = self:GetCaster()
    local buff_duration = self:GetSpecialValueFor("buff_duration")
    self.caster:AddNewModifier(self.caster, self, ____exports.musashi_modifier_dai_go_sei.name, {duration = buff_duration})
    self:PlaySound()
end
function musashi_dai_go_sei.prototype.PlaySound(self)
    EmitSoundOn(self.sound_voiceline, self.caster)
    EmitSoundOn(self.sound_sfx, self.caster)
end
musashi_dai_go_sei = __TS__Decorate(
    {registerAbility(nil)},
    musashi_dai_go_sei
)
____exports.musashi_dai_go_sei = musashi_dai_go_sei
____exports.musashi_modifier_dai_go_sei = __TS__Class()
local musashi_modifier_dai_go_sei = ____exports.musashi_modifier_dai_go_sei
musashi_modifier_dai_go_sei.name = "musashi_modifier_dai_go_sei"
__TS__ClassExtends(musashi_modifier_dai_go_sei, BaseModifier)
function musashi_modifier_dai_go_sei.prototype.____constructor(self, ...)
    BaseModifier.prototype.____constructor(self, ...)
    self.particlestr = "particles/custom/musashi/musashi_dai_go_sei_basic.vpcf"
    self.blueorbparticlestr = "particles/custom/musashi/musashi_dai_go_sei_blueorb_basic.vpcf"
    self.redorbparticlestr = "particles/custom/musashi/musashi_dai_go_sei_redorb_basic.vpcf"
    self.bonus_atkspeed = 0
    self.bonus_damage = 0
end
function musashi_modifier_dai_go_sei.prototype.OnCreated(self)
    local ability = self:GetAbility()
    self.caster = self:GetParent()
    self.bonus_atkspeed = ability and ability:GetSpecialValueFor("bonus_atkspeed") or 0
    self.bonus_damage = ability and ability:GetSpecialValueFor("bonus_damage") or 0
    self:CreateParticle()
end
function musashi_modifier_dai_go_sei.prototype.OnDestroy(self)
    ParticleManager:DestroyParticle(self.buffparticle, false)
    ParticleManager:DestroyParticle(self.blueorbparticle, false)
    ParticleManager:DestroyParticle(self.redorbparticle, false)
end
function musashi_modifier_dai_go_sei.prototype.CreateParticle(self)
    local ____opt_4 = self.caster
    if ____opt_4 and ____opt_4:HasModifier("modifier_alternate_01") then
        self.particlestr = "particles/custom/musashi/musashi_dai_go_sei_unique.vpcf"
        self.blueorbparticlestr = "particles/custom/musashi/musashi_dai_go_sei_blueorb_unique.vpcf"
        self.redorbparticlestr = "particles/custom/musashi/musashi_dai_go_sei_redorb_unique.vpcf"
    end
    self.buffparticle = ParticleManager:CreateParticle(self.particlestr, PATTACH_OVERHEAD_FOLLOW, self.caster)
    self.blueorbparticle = ParticleManager:CreateParticle(self.blueorbparticlestr, PATTACH_POINT_FOLLOW, self.caster)
    self.redorbparticle = ParticleManager:CreateParticle(self.redorbparticlestr, PATTACH_POINT_FOLLOW, self.caster)
    ParticleManager:SetParticleControlEnt(
        self.blueorbparticle,
        1,
        self.caster,
        PATTACH_POINT_FOLLOW,
        "attach_attack2",
        Vector(0, 0, 0),
        false
    )
    ParticleManager:SetParticleControlEnt(
        self.redorbparticle,
        1,
        self.caster,
        PATTACH_POINT_FOLLOW,
        "attach_attack1",
        Vector(0, 0, 0),
        false
    )
end
function musashi_modifier_dai_go_sei.prototype.DeclareFunctions(self)
    return {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE}
end
function musashi_modifier_dai_go_sei.prototype.GetModifierAttackSpeedBonus_Constant(self)
    return self.bonus_atkspeed
end
function musashi_modifier_dai_go_sei.prototype.GetModifierPreAttack_BonusDamage(self)
    return self.bonus_damage
end
function musashi_modifier_dai_go_sei.prototype.IsPurgable(self)
    return false
end
function musashi_modifier_dai_go_sei.prototype.IsPurgeException(self)
    return false
end
musashi_modifier_dai_go_sei = __TS__Decorate(
    {registerModifier(nil)},
    musashi_modifier_dai_go_sei
)
____exports.musashi_modifier_dai_go_sei = musashi_modifier_dai_go_sei
____exports.musashi_tengan = __TS__Class()
local musashi_tengan = ____exports.musashi_tengan
musashi_tengan.name = "musashi_tengan"
__TS__ClassExtends(musashi_tengan, BaseAbility)
function musashi_tengan.prototype.____constructor(self, ...)
    BaseAbility.prototype.____constructor(self, ...)
    self.sound_voiceline = "antimage_anti_cast_02"
    self.sound_sfx = "musashi_tengan_sfx"
end
function musashi_tengan.prototype.OnSpellStart(self)
    self.caster = self:GetCaster()
    local buff_duration = self:GetSpecialValueFor("buff_duration")
    self.caster:AddNewModifier(self.caster, self, ____exports.musashi_modifier_tengan.name, {duration = buff_duration})
    self:PlaySound()
end
function musashi_tengan.prototype.PlaySound(self)
    EmitGlobalSound(self.sound_voiceline)
    EmitSoundOn(self.sound_sfx, self.caster)
end
musashi_tengan = __TS__Decorate(
    {registerAbility(nil)},
    musashi_tengan
)
____exports.musashi_tengan = musashi_tengan
____exports.musashi_modifier_tengan = __TS__Class()
local musashi_modifier_tengan = ____exports.musashi_modifier_tengan
musashi_modifier_tengan.name = "musashi_modifier_tengan"
__TS__ClassExtends(musashi_modifier_tengan, BaseModifier)
function musashi_modifier_tengan.prototype.____constructor(self, ...)
    BaseModifier.prototype.____constructor(self, ...)
    self.particlestr = "particles/custom/musashi/musashi_tengan_basic.vpcf"
    self.overheadparticlestr = "particles/custom/musashi/musashi_tengan_overhead_basic.vpcf"
    self.bonus_damage = 0
end
function musashi_modifier_tengan.prototype.OnCreated(self)
    local ability = self:GetAbility()
    self.caster = self:GetParent()
    self.bonus_damage = ability and ability:GetSpecialValueFor("bonus_damage") or 0
    self:CreateParticle()
end
function musashi_modifier_tengan.prototype.OnDestroy(self)
    ParticleManager:DestroyParticle(self.buffparticle, false)
    ParticleManager:DestroyParticle(self.overheadparticle, false)
end
function musashi_modifier_tengan.prototype.CreateParticle(self)
    local ____opt_8 = self.caster
    if ____opt_8 and ____opt_8:HasModifier("modifier_alternate_01") then
        self.particlestr = "particles/custom/musashi/musashi_tengan_unique.vpcf"
        self.overheadparticlestr = "particles/custom/musashi/musashi_tengan_overhead_unique.vpcf"
    end
    self.buffparticle = ParticleManager:CreateParticle(self.particlestr, PATTACH_POINT_FOLLOW, self.caster)
    self.overheadparticle = ParticleManager:CreateParticle(self.overheadparticlestr, PATTACH_OVERHEAD_FOLLOW, self.caster)
    local ____opt_10 = self.caster
    if not (____opt_10 and ____opt_10:HasModifier("modifier_alternate_01")) then
        ParticleManager:SetParticleControlEnt(
            self.overheadparticle,
            10,
            self.caster,
            PATTACH_OVERHEAD_FOLLOW,
            "attach_hitloc",
            Vector(0, 0, 0),
            false
        )
    end
end
function musashi_modifier_tengan.prototype.IsPurgable(self)
    return false
end
function musashi_modifier_tengan.prototype.IsPurgeException(self)
    return false
end
musashi_modifier_tengan = __TS__Decorate(
    {registerModifier(nil)},
    musashi_modifier_tengan
)
____exports.musashi_modifier_tengan = musashi_modifier_tengan
____exports.musashi_niou_kurikara = __TS__Class()
local musashi_niou_kurikara = ____exports.musashi_niou_kurikara
musashi_niou_kurikara.name = "musashi_niou_kurikara"
__TS__ClassExtends(musashi_niou_kurikara, BaseAbility)
function musashi_niou_kurikara.prototype.____constructor(self, ...)
    BaseAbility.prototype.____constructor(self, ...)
    self.sound_voiceline = "antimage_anti_cast_03"
    self.sound_sfx = "musashi_niou_kurikara_sfx"
    self.interval = 0
    self.slash_count = 0
    self.dmg_per_slash = 0
end
function musashi_niou_kurikara.prototype.OnAbilityPhaseStart(self)
    self.caster = self:GetCaster()
    self.niou_skill = self.caster:FindAbilityByName(____exports.musashi_niou.name)
    self.caster:CastAbilityImmediately(
        self.niou_skill,
        self.caster:GetEntityIndex()
    )
    self.niou = self.niou_skill.niou
    self.targetaoe = self:GetCursorPosition()
    local ____opt_12 = self.niou
    if ____opt_12 ~= nil then
        ____opt_12:FaceTowards(self.targetaoe)
    end
    return true
end
function musashi_niou_kurikara.prototype.OnAbilityPhaseInterrupted(self)
    local ____opt_14 = self.niou_skill
    if ____opt_14 ~= nil then
        ____opt_14:DestroyNiou(0)
    end
end
function musashi_niou_kurikara.prototype.OnSpellStart(self)
    EmitGlobalSound(self.sound_voiceline)
    self.dmg_per_slash = self:GetSpecialValueFor("dmg_per_slash")
    local ____opt_16 = self.niou
    if ____opt_16 ~= nil then
        ____opt_16:StartGesture(ACT_DOTA_CHANNEL_ABILITY_1)
    end
    self.interval = self.interval + 0.5
end
function musashi_niou_kurikara.prototype.OnChannelThink(self, interval)
    if self.caster and self.targetaoe then
        if self.interval >= 0.5 and self.slash_count < 5 then
            EmitSoundOnLocationWithCaster(self.targetaoe, self.sound_sfx, self.caster)
            self:CreateParticle(self.slash_count)
            local targets = FindUnitsInRadius(
                self.caster:GetTeam(),
                self.targetaoe,
                nil,
                self:GetAOERadius(),
                self:GetAbilityTargetTeam(),
                self:GetAbilityType(),
                self:GetAbilityTargetFlags(),
                FIND_ANY_ORDER,
                false
            )
            for ____, iterator in ipairs(targets) do
                ApplyDamage({
                    victim = iterator,
                    attacker = self.caster,
                    damage = self.dmg_per_slash,
                    damage_type = DAMAGE_TYPE_MAGICAL,
                    damage_flags = DOTA_DAMAGE_FLAG_NONE,
                    ability = self
                })
            end
            self.slash_count = self.slash_count + 1
            local modifier_tengan = self.caster:FindModifierByName(____exports.musashi_modifier_tengan.name)
            if self.slash_count == 4 and modifier_tengan then
                for ____, iterator in ipairs(targets) do
                    ApplyDamage({
                        victim = iterator,
                        attacker = self.caster,
                        damage = modifier_tengan.bonus_damage,
                        damage_type = DAMAGE_TYPE_PURE,
                        damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
                        ability = self
                    })
                end
                modifier_tengan:Destroy()
            end
            self.interval = 0
        end
        self.interval = self.interval + interval
    end
end
function musashi_niou_kurikara.prototype.OnChannelFinish(self, interrupted)
    self.slash_count = 0
    self.interval = 0
    if interrupted then
        local ____opt_18 = self.niou_skill
        if ____opt_18 ~= nil then
            ____opt_18:DestroyNiou(0)
        end
    else
        local ____opt_20 = self.niou_skill
        if ____opt_20 ~= nil then
            ____opt_20:DestroyNiou(1)
        end
    end
end
function musashi_niou_kurikara.prototype.CreateParticle(self, slash_count)
    print(slash_count)
end
function musashi_niou_kurikara.prototype.OnUpgrade(self)
    local ____opt_22 = self.niou_skill
    if ____opt_22 ~= nil then
        ____opt_22:SetLevel(self:GetLevel())
    end
end
function musashi_niou_kurikara.prototype.GetAOERadius(self)
    return self:GetSpecialValueFor("radius")
end
musashi_niou_kurikara = __TS__Decorate(
    {registerAbility(nil)},
    musashi_niou_kurikara
)
____exports.musashi_niou_kurikara = musashi_niou_kurikara
____exports.musashi_niou = __TS__Class()
local musashi_niou = ____exports.musashi_niou
musashi_niou.name = "musashi_niou"
__TS__ClassExtends(musashi_niou, BaseAbility)
function musashi_niou.prototype.OnAbilityPhaseStart(self)
    self:DestroyNiou(0)
    return true
end
function musashi_niou.prototype.OnSpellStart(self)
    local caster = self:GetCaster()
    self.niou = CreateUnitByName(
        "musashi_niou",
        caster:GetAbsOrigin(),
        false,
        caster,
        caster,
        caster:GetTeam()
    )
    local model_scale = self:GetSpecialValueFor("model_scale")
    self.niou:SetModelScale(model_scale)
    self.niou:AddNewModifier(self.niou, self, ____exports.musashi_modifier_niou.name, nil)
end
function musashi_niou.prototype.DestroyNiou(self, delay)
    return __TS__AsyncAwaiter(function(____awaiter_resolve)
        local ____opt_24 = self.niou
        if ____opt_24 ~= nil then
            ____opt_24:ForceKill(false)
        end
        __TS__Await(Sleep(nil, delay))
        local ____opt_26 = self.niou
        if ____opt_26 ~= nil then
            ____opt_26:Destroy()
        end
    end)
end
musashi_niou = __TS__Decorate(
    {registerAbility(nil)},
    musashi_niou
)
____exports.musashi_niou = musashi_niou
____exports.musashi_modifier_niou = __TS__Class()
local musashi_modifier_niou = ____exports.musashi_modifier_niou
musashi_modifier_niou.name = "musashi_modifier_niou"
__TS__ClassExtends(musashi_modifier_niou, BaseModifier)
function musashi_modifier_niou.prototype.CheckState(self)
    local modifiertable = {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,
        [MODIFIER_STATE_UNTARGETABLE] = true,
        [MODIFIER_STATE_UNSELECTABLE] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_NOT_ON_MINIMAP] = true
    }
    return modifiertable
end
function musashi_modifier_niou.prototype.IsHidden(self)
    return true
end
function musashi_modifier_niou.prototype.IsPermanent(self)
    return true
end
function musashi_modifier_niou.prototype.IsPurgable(self)
    return false
end
function musashi_modifier_niou.prototype.IsPurgeException(self)
    return false
end
musashi_modifier_niou = __TS__Decorate(
    {registerModifier(nil)},
    musashi_modifier_niou
)
____exports.musashi_modifier_niou = musashi_modifier_niou
return ____exports
