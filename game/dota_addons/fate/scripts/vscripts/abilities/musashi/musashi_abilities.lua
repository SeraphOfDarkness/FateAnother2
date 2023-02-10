local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local __TS__Decorate = ____lualib.__TS__Decorate
local __TS__AsyncAwaiter = ____lualib.__TS__AsyncAwaiter
local __TS__Await = ____lualib.__TS__Await
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["10"] = 1,["11"] = 1,["12"] = 1,["13"] = 1,["14"] = 1,["15"] = 2,["16"] = 2,["17"] = 7,["18"] = 8,["19"] = 7,["20"] = 8,["22"] = 8,["23"] = 10,["24"] = 11,["25"] = 7,["26"] = 15,["27"] = 17,["28"] = 18,["29"] = 19,["30"] = 20,["31"] = 15,["32"] = 23,["33"] = 25,["35"] = 25,["37"] = 26,["39"] = 26,["41"] = 23,["42"] = 8,["43"] = 7,["44"] = 8,["46"] = 8,["47"] = 30,["48"] = 31,["49"] = 30,["50"] = 31,["52"] = 31,["53"] = 33,["54"] = 34,["55"] = 35,["56"] = 39,["57"] = 40,["58"] = 30,["59"] = 42,["60"] = 44,["61"] = 44,["62"] = 45,["63"] = 45,["64"] = 47,["67"] = 52,["68"] = 53,["69"] = 42,["70"] = 56,["71"] = 58,["72"] = 56,["73"] = 61,["74"] = 63,["75"] = 63,["76"] = 65,["77"] = 66,["78"] = 67,["80"] = 70,["81"] = 71,["82"] = 72,["83"] = 73,["84"] = 73,["85"] = 73,["86"] = 73,["87"] = 73,["88"] = 73,["89"] = 73,["90"] = 73,["91"] = 73,["92"] = 76,["93"] = 76,["94"] = 76,["95"] = 76,["96"] = 76,["97"] = 76,["98"] = 76,["99"] = 76,["100"] = 76,["101"] = 78,["102"] = 78,["103"] = 78,["104"] = 78,["105"] = 78,["106"] = 78,["107"] = 78,["108"] = 78,["109"] = 79,["110"] = 79,["111"] = 79,["112"] = 79,["113"] = 79,["114"] = 79,["115"] = 79,["116"] = 79,["117"] = 80,["118"] = 80,["119"] = 80,["120"] = 80,["121"] = 80,["122"] = 80,["123"] = 80,["124"] = 80,["125"] = 61,["126"] = 83,["127"] = 85,["128"] = 83,["129"] = 88,["130"] = 90,["131"] = 88,["132"] = 93,["133"] = 95,["134"] = 93,["135"] = 98,["136"] = 100,["137"] = 98,["138"] = 103,["139"] = 105,["140"] = 103,["141"] = 31,["142"] = 30,["143"] = 31,["145"] = 31,["146"] = 112,["147"] = 113,["148"] = 112,["149"] = 113,["151"] = 113,["152"] = 115,["153"] = 116,["154"] = 112,["155"] = 120,["156"] = 122,["157"] = 123,["158"] = 124,["160"] = 124,["162"] = 125,["163"] = 120,["164"] = 128,["165"] = 130,["167"] = 130,["169"] = 131,["171"] = 131,["173"] = 128,["174"] = 113,["175"] = 112,["176"] = 113,["178"] = 113,["179"] = 135,["180"] = 136,["181"] = 135,["182"] = 136,["184"] = 136,["185"] = 138,["186"] = 139,["187"] = 143,["188"] = 135,["189"] = 145,["190"] = 147,["191"] = 147,["192"] = 149,["195"] = 154,["196"] = 155,["197"] = 145,["198"] = 158,["199"] = 160,["200"] = 158,["201"] = 163,["202"] = 165,["203"] = 165,["204"] = 167,["205"] = 168,["206"] = 169,["207"] = 170,["208"] = 170,["209"] = 170,["210"] = 170,["211"] = 170,["212"] = 170,["213"] = 170,["214"] = 170,["216"] = 174,["217"] = 175,["218"] = 175,["219"] = 175,["220"] = 175,["221"] = 175,["222"] = 175,["223"] = 175,["224"] = 175,["225"] = 175,["226"] = 177,["227"] = 177,["228"] = 177,["229"] = 177,["230"] = 177,["231"] = 177,["232"] = 177,["233"] = 177,["235"] = 180,["236"] = 181,["237"] = 181,["238"] = 181,["239"] = 181,["240"] = 181,["241"] = 181,["242"] = 181,["243"] = 181,["244"] = 163,["245"] = 184,["246"] = 186,["247"] = 184,["248"] = 189,["249"] = 191,["250"] = 189,["251"] = 136,["252"] = 135,["253"] = 136,["255"] = 136,["256"] = 198,["257"] = 199,["258"] = 198,["259"] = 199,["261"] = 199,["262"] = 201,["263"] = 202,["264"] = 204,["265"] = 210,["266"] = 211,["267"] = 212,["268"] = 213,["269"] = 198,["270"] = 215,["271"] = 217,["272"] = 218,["273"] = 219,["274"] = 220,["275"] = 221,["276"] = 222,["278"] = 222,["280"] = 223,["281"] = 215,["282"] = 226,["283"] = 228,["285"] = 228,["287"] = 226,["288"] = 231,["289"] = 233,["290"] = 234,["292"] = 234,["294"] = 235,["295"] = 236,["296"] = 237,["297"] = 231,["298"] = 240,["299"] = 242,["300"] = 244,["301"] = 245,["302"] = 247,["303"] = 247,["304"] = 247,["305"] = 247,["306"] = 247,["307"] = 247,["308"] = 247,["309"] = 247,["310"] = 247,["311"] = 247,["312"] = 247,["313"] = 247,["314"] = 247,["315"] = 250,["316"] = 252,["317"] = 254,["318"] = 254,["319"] = 254,["320"] = 254,["321"] = 254,["322"] = 254,["323"] = 252,["325"] = 265,["326"] = 266,["327"] = 266,["328"] = 268,["329"] = 270,["330"] = 272,["331"] = 274,["332"] = 274,["333"] = 274,["334"] = 274,["335"] = 274,["336"] = 274,["337"] = 272,["339"] = 285,["341"] = 288,["343"] = 291,["344"] = 240,["345"] = 294,["346"] = 296,["347"] = 297,["348"] = 299,["349"] = 301,["351"] = 301,["354"] = 305,["356"] = 305,["359"] = 294,["360"] = 309,["361"] = 311,["362"] = 311,["363"] = 313,["364"] = 314,["366"] = 316,["367"] = 318,["370"] = 320,["371"] = 321,["375"] = 324,["378"] = 326,["379"] = 327,["383"] = 330,["386"] = 332,["387"] = 333,["391"] = 336,["394"] = 338,["395"] = 339,["400"] = 344,["401"] = 345,["402"] = 346,["403"] = 347,["404"] = 347,["405"] = 347,["406"] = 347,["407"] = 347,["408"] = 348,["409"] = 348,["410"] = 348,["411"] = 348,["412"] = 348,["413"] = 349,["415"] = 353,["416"] = 354,["417"] = 355,["418"] = 355,["419"] = 355,["420"] = 355,["421"] = 355,["422"] = 356,["423"] = 356,["424"] = 356,["425"] = 356,["426"] = 356,["428"] = 309,["429"] = 360,["430"] = 362,["432"] = 362,["434"] = 360,["435"] = 365,["436"] = 367,["437"] = 365,["438"] = 199,["439"] = 198,["440"] = 199,["442"] = 199,["443"] = 374,["444"] = 375,["445"] = 374,["446"] = 375,["447"] = 380,["448"] = 382,["449"] = 383,["450"] = 383,["451"] = 383,["452"] = 383,["453"] = 383,["454"] = 383,["455"] = 383,["456"] = 383,["457"] = 384,["458"] = 385,["459"] = 386,["460"] = 380,["461"] = 389,["463"] = 391,["465"] = 391,["467"] = 392,["468"] = 393,["470"] = 393,["473"] = 389,["474"] = 375,["475"] = 374,["476"] = 375,["478"] = 375,["479"] = 397,["480"] = 398,["481"] = 397,["482"] = 398,["483"] = 400,["484"] = 402,["485"] = 403,["486"] = 403,["487"] = 403,["488"] = 403,["489"] = 403,["490"] = 403,["491"] = 403,["492"] = 403,["493"] = 413,["494"] = 400,["495"] = 416,["496"] = 418,["497"] = 416,["498"] = 421,["499"] = 423,["500"] = 421,["501"] = 426,["502"] = 428,["503"] = 426,["504"] = 431,["505"] = 433,["506"] = 431,["507"] = 398,["508"] = 397,["509"] = 398,["511"] = 398});
local ____exports = {}
local ____dota_ts_adapter = require("tslib.dota_ts_adapter")
local BaseAbility = ____dota_ts_adapter.BaseAbility
local BaseModifier = ____dota_ts_adapter.BaseModifier
local registerAbility = ____dota_ts_adapter.registerAbility
local registerModifier = ____dota_ts_adapter.registerModifier
local ____sleep_timer = require("tslib.sleep_timer")
local Sleep = ____sleep_timer.Sleep
____exports.musashi_dai_go_sei = __TS__Class()
local musashi_dai_go_sei = ____exports.musashi_dai_go_sei
musashi_dai_go_sei.name = "musashi_dai_go_sei"
__TS__ClassExtends(musashi_dai_go_sei, BaseAbility)
function musashi_dai_go_sei.prototype.____constructor(self, ...)
    BaseAbility.prototype.____constructor(self, ...)
    self.SoundVoiceline = "antimage_anti_cast_01"
    self.SoundSfx = "musashi_dai_go_sei_sfx"
end
function musashi_dai_go_sei.prototype.OnSpellStart(self)
    self.Caster = self:GetCaster()
    local BuffDuration = self:GetSpecialValueFor("BuffDuration")
    self.Caster:AddNewModifier(self.Caster, self, ____exports.musashi_modifier_dai_go_sei.name, {duration = BuffDuration})
    self:PlaySound()
end
function musashi_dai_go_sei.prototype.PlaySound(self)
    local ____opt_0 = self.Caster
    if ____opt_0 ~= nil then
        ____opt_0:EmitSound(self.SoundVoiceline)
    end
    local ____opt_2 = self.Caster
    if ____opt_2 ~= nil then
        ____opt_2:EmitSound(self.SoundSfx)
    end
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
    self.ParticleStr = "particles/custom/musashi/musashi_dai_go_sei_basic.vpcf"
    self.BlueOrbParticleStr = "particles/custom/musashi/musashi_dai_go_sei_blueorb_basic.vpcf"
    self.RedOrbParticleStr = "particles/custom/musashi/musashi_dai_go_sei_redorb_basic.vpcf"
    self.BonusDmg = 0
    self.BonusAtkSpeed = 0
end
function musashi_modifier_dai_go_sei.prototype.OnCreated(self)
    local ____opt_4 = self:GetAbility()
    self.BonusDmg = ____opt_4 and ____opt_4:GetSpecialValueFor("BonusDmg")
    local ____opt_6 = self:GetAbility()
    self.BonusAtkSpeed = ____opt_6 and ____opt_6:GetSpecialValueFor("BonusAtkSpeed")
    if not IsServer() then
        return
    end
    self.Caster = self:GetCaster()
    self:CreateParticle()
end
function musashi_modifier_dai_go_sei.prototype.OnRefresh(self)
    self:OnCreated()
end
function musashi_modifier_dai_go_sei.prototype.CreateParticle(self)
    local ____opt_8 = self.Caster
    if ____opt_8 and ____opt_8:HasModifier("modifier_ascended") then
        self.ParticleStr = "particles/custom/musashi/musashi_dai_go_sei_unique.vpcf"
        self.BlueOrbParticleStr = "particles/custom/musashi/musashi_dai_go_sei_blueorb_unique.vpcf"
        self.RedOrbParticleStr = "particles/custom/musashi/musashi_dai_go_sei_redorb_unique.vpcf"
    end
    local BuffParticle = ParticleManager:CreateParticle(self.ParticleStr, PATTACH_OVERHEAD_FOLLOW, self.Caster)
    local BlueOrbParticle = ParticleManager:CreateParticle(self.BlueOrbParticleStr, PATTACH_POINT_FOLLOW, self.Caster)
    local RedOrbParticle = ParticleManager:CreateParticle(self.RedOrbParticleStr, PATTACH_POINT_FOLLOW, self.Caster)
    ParticleManager:SetParticleControlEnt(
        BlueOrbParticle,
        1,
        self.Caster,
        PATTACH_POINT_FOLLOW,
        "attach_attack2",
        Vector(0, 0, 0),
        false
    )
    ParticleManager:SetParticleControlEnt(
        RedOrbParticle,
        1,
        self.Caster,
        PATTACH_POINT_FOLLOW,
        "attach_attack1",
        Vector(0, 0, 0),
        false
    )
    self:AddParticle(
        BuffParticle,
        false,
        false,
        -1,
        false,
        false
    )
    self:AddParticle(
        BlueOrbParticle,
        false,
        false,
        -1,
        false,
        false
    )
    self:AddParticle(
        RedOrbParticle,
        false,
        false,
        -1,
        false,
        false
    )
end
function musashi_modifier_dai_go_sei.prototype.DeclareFunctions(self)
    return {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE, MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}
end
function musashi_modifier_dai_go_sei.prototype.GetModifierPreAttack_BonusDamage(self)
    return self.BonusDmg
end
function musashi_modifier_dai_go_sei.prototype.GetModifierAttackSpeedBonus_Constant(self)
    return self.BonusAtkSpeed
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
    self.SoundVoiceline = "antimage_anti_cast_02"
    self.SoundSfx = "musashi_tengan_sfx"
end
function musashi_tengan.prototype.OnSpellStart(self)
    self.Caster = self:GetCaster()
    local BuffDuration = self:GetSpecialValueFor("BuffDuration")
    local ____opt_10 = self.Caster
    if ____opt_10 ~= nil then
        ____opt_10:AddNewModifier(self.Caster, self, ____exports.musashi_modifier_tengan.name, {duration = BuffDuration})
    end
    self:PlaySound()
end
function musashi_tengan.prototype.PlaySound(self)
    local ____opt_12 = self.Caster
    if ____opt_12 ~= nil then
        ____opt_12:EmitSound(self.SoundVoiceline)
    end
    local ____opt_14 = self.Caster
    if ____opt_14 ~= nil then
        ____opt_14:EmitSound(self.SoundSfx)
    end
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
    self.ParticleStr = "particles/custom/musashi/musashi_tengan_basic.vpcf"
    self.OverheadParticleStr = "particles/custom/musashi/musashi_tengan_overhead_basic.vpcf"
    self.BonusDmg = 0
end
function musashi_modifier_tengan.prototype.OnCreated(self)
    local ____opt_16 = self:GetAbility()
    self.BonusDmg = ____opt_16 and ____opt_16:GetSpecialValueFor("BonusDmg")
    if not IsServer() then
        return
    end
    self.Caster = self:GetParent()
    self:CreateParticle()
end
function musashi_modifier_tengan.prototype.OnRefresh(self)
    self:OnCreated()
end
function musashi_modifier_tengan.prototype.CreateParticle(self)
    local ____opt_18 = self.Caster
    if ____opt_18 and ____opt_18:HasModifier("modifier_ascended") then
        self.ParticleStr = "particles/custom/musashi/musashi_tengan_unique.vpcf"
        self.OverheadParticleStr = "particles/custom/musashi/musashi_tengan_overhead_unique.vpcf"
        local OverheadParticle = ParticleManager:CreateParticle(self.OverheadParticleStr, PATTACH_OVERHEAD_FOLLOW, self.Caster)
        self:AddParticle(
            OverheadParticle,
            false,
            false,
            -1,
            false,
            false
        )
    else
        local OverheadParticle = ParticleManager:CreateParticle(self.OverheadParticleStr, PATTACH_OVERHEAD_FOLLOW, self.Caster)
        ParticleManager:SetParticleControlEnt(
            OverheadParticle,
            10,
            self.Caster,
            PATTACH_OVERHEAD_FOLLOW,
            "attach_hitloc",
            Vector(0, 0, 0),
            false
        )
        self:AddParticle(
            OverheadParticle,
            false,
            false,
            -1,
            false,
            false
        )
    end
    local BuffParticle = ParticleManager:CreateParticle(self.ParticleStr, PATTACH_POINT_FOLLOW, self.Caster)
    self:AddParticle(
        BuffParticle,
        false,
        false,
        -1,
        false,
        false
    )
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
    self.SoundVoiceline = "antimage_anti_cast_03"
    self.SoundSfx = "musashi_niou_kurikara_sfx"
    self.BasicAoeParticle = "particles/custom/musashi/musashi_niou_kurikara_basic.vpcf"
    self.TargetAoe = Vector(0, 0, 0)
    self.Interval = 0
    self.SlashCount = 0
    self.DmgPerSlash = 0
end
function musashi_niou_kurikara.prototype.OnAbilityPhaseStart(self)
    self.Caster = self:GetCaster()
    self.NiouSkill = self.Caster:FindAbilityByName(____exports.musashi_niou.name)
    self.NiouSkill:CastAbility()
    self.Niou = self.NiouSkill.Niou
    self.TargetAoe = self:GetCursorPosition()
    local ____opt_20 = self.Niou
    if ____opt_20 ~= nil then
        ____opt_20:FaceTowards(self.TargetAoe)
    end
    return true
end
function musashi_niou_kurikara.prototype.OnAbilityPhaseInterrupted(self)
    local ____opt_22 = self.NiouSkill
    if ____opt_22 ~= nil then
        ____opt_22:DestroyNiou(0)
    end
end
function musashi_niou_kurikara.prototype.OnSpellStart(self)
    self.DmgPerSlash = self:GetSpecialValueFor("DmgPerSlash")
    local ____opt_24 = self.Niou
    if ____opt_24 ~= nil then
        ____opt_24:StartGestureWithPlaybackRate(ACT_DOTA_CHANNEL_ABILITY_1, 1.1)
    end
    self.Interval = 0.5
    EmitGlobalSound(self.SoundVoiceline)
    self.SlashCount = self.SlashCount + 1
end
function musashi_niou_kurikara.prototype.OnChannelThink(self, interval)
    if self.Interval >= 0.5 and self.SlashCount < 5 then
        EmitSoundOnLocationWithCaster(self.TargetAoe, self.SoundSfx, self.Caster)
        self:CreateParticle()
        local ____FindUnitsInRadius_28 = FindUnitsInRadius
        local ____opt_26 = self.Caster
        local Targets = ____FindUnitsInRadius_28(
            ____opt_26 and ____opt_26:GetTeam(),
            self.TargetAoe,
            nil,
            self:GetAOERadius(),
            self:GetAbilityTargetTeam(),
            self:GetAbilityTargetType(),
            self:GetAbilityTargetFlags(),
            FIND_ANY_ORDER,
            false
        )
        for ____, Iterator in ipairs(Targets) do
            ApplyDamage({
                victim = Iterator,
                attacker = self.Caster,
                damage = self.DmgPerSlash,
                damage_type = self:GetAbilityDamageType(),
                damage_flags = DOTA_DAMAGE_FLAG_NONE,
                ability = self
            })
        end
        self.SlashCount = self.SlashCount + 1
        local ____opt_29 = self.Caster
        local ModifierTengan = ____opt_29 and ____opt_29:FindModifierByName(____exports.musashi_modifier_tengan.name)
        if self.SlashCount == 5 and ModifierTengan then
            for ____, Iterator in ipairs(Targets) do
                ApplyDamage({
                    victim = Iterator,
                    attacker = self.Caster,
                    damage = ModifierTengan.BonusDmg,
                    damage_type = DAMAGE_TYPE_PURE,
                    damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
                    ability = self
                })
            end
            ModifierTengan:Destroy()
        end
        self.Interval = 0
    end
    self.Interval = self.Interval + interval
end
function musashi_niou_kurikara.prototype.OnChannelFinish(self, interrupted)
    self.SlashCount = 0
    self.Interval = 0
    if interrupted then
        local ____opt_31 = self.NiouSkill
        if ____opt_31 ~= nil then
            ____opt_31:DestroyNiou(0)
        end
    else
        local ____opt_33 = self.NiouSkill
        if ____opt_33 ~= nil then
            ____opt_33:DestroyNiou(1)
        end
    end
end
function musashi_niou_kurikara.prototype.CreateParticle(self)
    local ____opt_35 = self.Caster
    if ____opt_35 and ____opt_35:HasModifier("modifier_ascended") then
        local AoeParticleStr = ""
        local CrackParticleStr = ""
        repeat
            local ____switch39 = self.SlashCount
            local ____cond39 = ____switch39 == 1
            if ____cond39 then
                do
                    AoeParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_earth.vpcf"
                    CrackParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_earth_crack.vpcf"
                    break
                end
            end
            ____cond39 = ____cond39 or ____switch39 == 2
            if ____cond39 then
                do
                    AoeParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_water.vpcf"
                    CrackParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_earth_crack.vpcf"
                    break
                end
            end
            ____cond39 = ____cond39 or ____switch39 == 3
            if ____cond39 then
                do
                    AoeParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_fire.vpcf"
                    CrackParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_fire_crack.vpcf"
                    break
                end
            end
            ____cond39 = ____cond39 or ____switch39 == 4
            if ____cond39 then
                do
                    AoeParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_wind.vpcf"
                    CrackParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_wind_crack.vpcf"
                    break
                end
            end
        until true
        local AoeParticle = ParticleManager:CreateParticle(AoeParticleStr, PATTACH_WORLDORIGIN, self.Caster)
        local CrackParticle = ParticleManager:CreateParticle(CrackParticleStr, PATTACH_WORLDORIGIN, self.Caster)
        ParticleManager:SetParticleControl(AoeParticle, 0, self.TargetAoe)
        ParticleManager:SetParticleControl(
            AoeParticle,
            1,
            Vector(0, 0, 0)
        )
        ParticleManager:SetParticleControl(
            AoeParticle,
            12,
            Vector(400, 0, 0)
        )
        ParticleManager:SetParticleControl(CrackParticle, 0, self.TargetAoe)
    else
        local AoeParticle = ParticleManager:CreateParticle(self.BasicAoeParticle, PATTACH_WORLDORIGIN, self.Caster)
        ParticleManager:SetParticleControl(AoeParticle, 0, self.TargetAoe)
        ParticleManager:SetParticleControl(
            AoeParticle,
            1,
            Vector(1.5, 0, 0)
        )
        ParticleManager:SetParticleControl(
            AoeParticle,
            2,
            Vector(400, 0, 0)
        )
    end
end
function musashi_niou_kurikara.prototype.OnUpgrade(self)
    local ____opt_37 = self.NiouSkill
    if ____opt_37 ~= nil then
        ____opt_37:SetLevel(self:GetLevel())
    end
end
function musashi_niou_kurikara.prototype.GetAOERadius(self)
    return self:GetSpecialValueFor("Radius")
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
function musashi_niou.prototype.OnSpellStart(self)
    self.Caster = self:GetCaster()
    self.Niou = CreateUnitByName(
        "musashi_niou",
        self.Caster:GetAbsOrigin(),
        false,
        self.Caster,
        self.Caster,
        self.Caster:GetTeam()
    )
    local ModelScale = self:GetSpecialValueFor("ModelScale")
    self.Niou:SetModelScale(ModelScale)
    self.Niou:AddNewModifier(self.Niou, self, ____exports.musashi_modifier_niou.name, {undefined = undefined})
end
function musashi_niou.prototype.DestroyNiou(self, delay)
    return __TS__AsyncAwaiter(function(____awaiter_resolve)
        local ____opt_39 = self.Niou
        if ____opt_39 ~= nil then
            ____opt_39:ForceKill(false)
        end
        Sleep(nil, delay)
        local ____opt_41 = self.Niou
        if ____opt_41 ~= nil then
            ____opt_41:Destroy()
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
