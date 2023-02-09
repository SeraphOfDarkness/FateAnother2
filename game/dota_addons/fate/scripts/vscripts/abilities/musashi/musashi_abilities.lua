local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local __TS__Decorate = ____lualib.__TS__Decorate
local __TS__AsyncAwaiter = ____lualib.__TS__AsyncAwaiter
local __TS__Await = ____lualib.__TS__Await
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["10"] = 1,["11"] = 1,["12"] = 1,["13"] = 1,["14"] = 1,["15"] = 2,["16"] = 2,["17"] = 8,["18"] = 9,["19"] = 8,["20"] = 9,["22"] = 9,["23"] = 11,["24"] = 12,["25"] = 8,["26"] = 15,["27"] = 17,["28"] = 18,["29"] = 19,["30"] = 20,["31"] = 15,["32"] = 23,["33"] = 25,["34"] = 26,["35"] = 23,["36"] = 9,["37"] = 8,["38"] = 9,["40"] = 9,["41"] = 30,["42"] = 31,["43"] = 30,["44"] = 31,["46"] = 31,["47"] = 33,["48"] = 34,["49"] = 35,["50"] = 37,["51"] = 38,["52"] = 30,["53"] = 43,["54"] = 45,["55"] = 46,["56"] = 47,["57"] = 47,["58"] = 47,["60"] = 47,["61"] = 48,["62"] = 48,["63"] = 48,["65"] = 48,["66"] = 49,["67"] = 43,["68"] = 52,["69"] = 54,["70"] = 55,["71"] = 56,["72"] = 52,["73"] = 59,["74"] = 61,["75"] = 61,["76"] = 61,["78"] = 61,["79"] = 63,["80"] = 64,["81"] = 65,["83"] = 68,["84"] = 69,["85"] = 70,["86"] = 71,["87"] = 71,["88"] = 71,["89"] = 71,["90"] = 71,["91"] = 71,["92"] = 71,["93"] = 71,["94"] = 71,["95"] = 73,["96"] = 73,["97"] = 73,["98"] = 73,["99"] = 73,["100"] = 73,["101"] = 73,["102"] = 73,["103"] = 73,["104"] = 59,["105"] = 77,["106"] = 79,["107"] = 77,["108"] = 82,["109"] = 84,["110"] = 82,["111"] = 87,["112"] = 89,["113"] = 87,["114"] = 92,["115"] = 94,["116"] = 92,["117"] = 97,["118"] = 99,["119"] = 97,["120"] = 31,["121"] = 30,["122"] = 31,["124"] = 31,["125"] = 106,["126"] = 107,["127"] = 106,["128"] = 107,["130"] = 107,["131"] = 109,["132"] = 110,["133"] = 106,["134"] = 113,["135"] = 115,["136"] = 116,["137"] = 117,["138"] = 118,["139"] = 113,["140"] = 121,["141"] = 123,["142"] = 124,["143"] = 121,["144"] = 107,["145"] = 106,["146"] = 107,["148"] = 107,["149"] = 128,["150"] = 129,["151"] = 128,["152"] = 129,["154"] = 129,["155"] = 131,["156"] = 132,["157"] = 134,["158"] = 128,["159"] = 138,["160"] = 140,["161"] = 141,["162"] = 142,["163"] = 142,["164"] = 142,["166"] = 142,["167"] = 143,["168"] = 138,["169"] = 146,["170"] = 148,["171"] = 149,["172"] = 146,["173"] = 152,["174"] = 154,["175"] = 154,["176"] = 154,["178"] = 154,["179"] = 156,["180"] = 157,["182"] = 160,["183"] = 161,["184"] = 163,["185"] = 163,["186"] = 163,["188"] = 163,["189"] = 165,["190"] = 165,["191"] = 165,["192"] = 165,["193"] = 165,["194"] = 165,["195"] = 165,["196"] = 165,["197"] = 165,["199"] = 152,["200"] = 170,["201"] = 172,["202"] = 170,["203"] = 175,["204"] = 177,["205"] = 175,["206"] = 129,["207"] = 128,["208"] = 129,["210"] = 129,["211"] = 184,["212"] = 185,["213"] = 184,["214"] = 185,["216"] = 185,["217"] = 187,["218"] = 188,["219"] = 194,["220"] = 195,["221"] = 196,["222"] = 184,["223"] = 198,["224"] = 200,["225"] = 201,["226"] = 202,["227"] = 202,["228"] = 202,["229"] = 202,["230"] = 203,["231"] = 204,["232"] = 205,["233"] = 205,["234"] = 205,["236"] = 206,["237"] = 198,["238"] = 209,["239"] = 211,["240"] = 211,["241"] = 211,["243"] = 209,["244"] = 214,["245"] = 229,["246"] = 230,["247"] = 231,["248"] = 231,["249"] = 231,["251"] = 232,["252"] = 214,["253"] = 235,["254"] = 237,["255"] = 239,["256"] = 241,["257"] = 242,["258"] = 244,["259"] = 244,["260"] = 244,["261"] = 244,["262"] = 244,["263"] = 244,["264"] = 244,["265"] = 244,["266"] = 244,["267"] = 244,["268"] = 244,["269"] = 248,["270"] = 250,["271"] = 252,["272"] = 252,["273"] = 252,["274"] = 252,["275"] = 252,["276"] = 252,["277"] = 250,["279"] = 263,["280"] = 264,["281"] = 266,["282"] = 268,["283"] = 270,["284"] = 272,["285"] = 272,["286"] = 272,["287"] = 272,["288"] = 272,["289"] = 272,["290"] = 270,["292"] = 283,["294"] = 286,["296"] = 289,["298"] = 235,["299"] = 293,["300"] = 295,["301"] = 296,["302"] = 298,["303"] = 300,["304"] = 300,["305"] = 300,["308"] = 304,["309"] = 304,["310"] = 304,["313"] = 293,["314"] = 308,["315"] = 310,["316"] = 308,["317"] = 330,["318"] = 332,["319"] = 332,["320"] = 332,["322"] = 330,["323"] = 335,["324"] = 337,["325"] = 335,["326"] = 185,["327"] = 184,["328"] = 185,["330"] = 185,["331"] = 344,["332"] = 345,["333"] = 344,["334"] = 345,["335"] = 349,["336"] = 351,["337"] = 352,["338"] = 349,["339"] = 355,["340"] = 357,["341"] = 358,["342"] = 358,["343"] = 358,["344"] = 358,["345"] = 358,["346"] = 358,["347"] = 358,["348"] = 358,["349"] = 359,["350"] = 360,["351"] = 361,["352"] = 355,["353"] = 364,["355"] = 366,["356"] = 366,["357"] = 366,["359"] = 367,["360"] = 368,["361"] = 368,["362"] = 368,["365"] = 364,["366"] = 345,["367"] = 344,["368"] = 345,["370"] = 345,["371"] = 372,["372"] = 373,["373"] = 372,["374"] = 373,["375"] = 375,["376"] = 377,["377"] = 378,["378"] = 378,["379"] = 378,["380"] = 378,["381"] = 378,["382"] = 378,["383"] = 378,["384"] = 378,["385"] = 388,["386"] = 375,["387"] = 391,["388"] = 393,["389"] = 391,["390"] = 396,["391"] = 398,["392"] = 396,["393"] = 401,["394"] = 403,["395"] = 401,["396"] = 406,["397"] = 408,["398"] = 406,["399"] = 373,["400"] = 372,["401"] = 373,["403"] = 373});
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
    local ____ability_GetSpecialValueFor_result_0 = ability
    if ____ability_GetSpecialValueFor_result_0 ~= nil then
        ____ability_GetSpecialValueFor_result_0 = ____ability_GetSpecialValueFor_result_0:GetSpecialValueFor("bonus_atkspeed")
    end
    self.bonus_atkspeed = ____ability_GetSpecialValueFor_result_0 or 0
    local ____ability_GetSpecialValueFor_result_2 = ability
    if ____ability_GetSpecialValueFor_result_2 ~= nil then
        ____ability_GetSpecialValueFor_result_2 = ____ability_GetSpecialValueFor_result_2:GetSpecialValueFor("bonus_damage")
    end
    self.bonus_damage = ____ability_GetSpecialValueFor_result_2 or 0
    self:CreateParticle()
end
function musashi_modifier_dai_go_sei.prototype.OnDestroy(self)
    ParticleManager:DestroyParticle(self.buffparticle, false)
    ParticleManager:DestroyParticle(self.blueorbparticle, false)
    ParticleManager:DestroyParticle(self.redorbparticle, false)
end
function musashi_modifier_dai_go_sei.prototype.CreateParticle(self)
    local ____table_caster_HasModifier_result_4 = self.caster
    if ____table_caster_HasModifier_result_4 ~= nil then
        ____table_caster_HasModifier_result_4 = ____table_caster_HasModifier_result_4:HasModifier("modifier_alternate_01")
    end
    if ____table_caster_HasModifier_result_4 then
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
    local ____ability_GetSpecialValueFor_result_6 = ability
    if ____ability_GetSpecialValueFor_result_6 ~= nil then
        ____ability_GetSpecialValueFor_result_6 = ____ability_GetSpecialValueFor_result_6:GetSpecialValueFor("bonus_damage")
    end
    self.bonus_damage = ____ability_GetSpecialValueFor_result_6 or 0
    self:CreateParticle()
end
function musashi_modifier_tengan.prototype.OnDestroy(self)
    ParticleManager:DestroyParticle(self.buffparticle, false)
    ParticleManager:DestroyParticle(self.overheadparticle, false)
end
function musashi_modifier_tengan.prototype.CreateParticle(self)
    local ____table_caster_HasModifier_result_8 = self.caster
    if ____table_caster_HasModifier_result_8 ~= nil then
        ____table_caster_HasModifier_result_8 = ____table_caster_HasModifier_result_8:HasModifier("modifier_alternate_01")
    end
    if ____table_caster_HasModifier_result_8 then
        self.particlestr = "particles/custom/musashi/musashi_tengan_unique.vpcf"
        self.overheadparticlestr = "particles/custom/musashi/musashi_tengan_overhead_unique.vpcf"
    end
    self.buffparticle = ParticleManager:CreateParticle(self.particlestr, PATTACH_POINT_FOLLOW, self.caster)
    self.overheadparticle = ParticleManager:CreateParticle(self.overheadparticlestr, PATTACH_OVERHEAD_FOLLOW, self.caster)
    local ____table_caster_HasModifier_result_10 = self.caster
    if ____table_caster_HasModifier_result_10 ~= nil then
        ____table_caster_HasModifier_result_10 = ____table_caster_HasModifier_result_10:HasModifier("modifier_alternate_01")
    end
    if not ____table_caster_HasModifier_result_10 then
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
    local ____table_niou_FaceTowards_result_12 = self.niou
    if ____table_niou_FaceTowards_result_12 ~= nil then
        ____table_niou_FaceTowards_result_12 = ____table_niou_FaceTowards_result_12:FaceTowards(self.targetaoe)
    end
    return true
end
function musashi_niou_kurikara.prototype.OnAbilityPhaseInterrupted(self)
    local ____table_niou_skill_DestroyNiou_result_14 = self.niou_skill
    if ____table_niou_skill_DestroyNiou_result_14 ~= nil then
        ____table_niou_skill_DestroyNiou_result_14 = ____table_niou_skill_DestroyNiou_result_14:DestroyNiou(0)
    end
end
function musashi_niou_kurikara.prototype.OnSpellStart(self)
    EmitGlobalSound(self.sound_voiceline)
    self.dmg_per_slash = self:GetSpecialValueFor("dmg_per_slash")
    local ____table_niou_StartGesture_result_16 = self.niou
    if ____table_niou_StartGesture_result_16 ~= nil then
        ____table_niou_StartGesture_result_16 = ____table_niou_StartGesture_result_16:StartGesture(ACT_DOTA_CHANNEL_ABILITY_1)
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
        local ____table_niou_skill_DestroyNiou_result_18 = self.niou_skill
        if ____table_niou_skill_DestroyNiou_result_18 ~= nil then
            ____table_niou_skill_DestroyNiou_result_18 = ____table_niou_skill_DestroyNiou_result_18:DestroyNiou(0)
        end
    else
        local ____table_niou_skill_DestroyNiou_result_20 = self.niou_skill
        if ____table_niou_skill_DestroyNiou_result_20 ~= nil then
            ____table_niou_skill_DestroyNiou_result_20 = ____table_niou_skill_DestroyNiou_result_20:DestroyNiou(1)
        end
    end
end
function musashi_niou_kurikara.prototype.CreateParticle(self, slash_count)
    print(slash_count)
end
function musashi_niou_kurikara.prototype.OnUpgrade(self)
    local ____table_niou_skill_SetLevel_result_22 = self.niou_skill
    if ____table_niou_skill_SetLevel_result_22 ~= nil then
        ____table_niou_skill_SetLevel_result_22 = ____table_niou_skill_SetLevel_result_22:SetLevel(self:GetLevel())
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
        local ____table_niou_ForceKill_result_24 = self.niou
        if ____table_niou_ForceKill_result_24 ~= nil then
            ____table_niou_ForceKill_result_24 = ____table_niou_ForceKill_result_24:ForceKill(false)
        end
        __TS__Await(Sleep(nil, delay))
        local ____table_niou_Destroy_result_26 = self.niou
        if ____table_niou_Destroy_result_26 ~= nil then
            ____table_niou_Destroy_result_26 = ____table_niou_Destroy_result_26:Destroy()
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
