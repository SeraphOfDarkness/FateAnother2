local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local __TS__Decorate = ____lualib.__TS__Decorate
local __TS__SparseArrayNew = ____lualib.__TS__SparseArrayNew
local __TS__SparseArrayPush = ____lualib.__TS__SparseArrayPush
local __TS__SparseArraySpread = ____lualib.__TS__SparseArraySpread
local __TS__AsyncAwaiter = ____lualib.__TS__AsyncAwaiter
local __TS__Await = ____lualib.__TS__Await
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["13"] = 1,["14"] = 1,["15"] = 1,["16"] = 1,["17"] = 1,["18"] = 2,["19"] = 2,["20"] = 4,["21"] = 9,["22"] = 10,["23"] = 9,["24"] = 10,["26"] = 10,["27"] = 12,["28"] = 13,["29"] = 9,["30"] = 17,["31"] = 19,["32"] = 20,["33"] = 21,["34"] = 22,["35"] = 17,["36"] = 25,["37"] = 27,["39"] = 27,["41"] = 28,["43"] = 28,["45"] = 25,["46"] = 10,["47"] = 9,["48"] = 10,["50"] = 10,["51"] = 32,["52"] = 33,["53"] = 32,["54"] = 33,["56"] = 33,["57"] = 35,["58"] = 36,["59"] = 37,["60"] = 41,["61"] = 42,["62"] = 32,["63"] = 44,["64"] = 46,["65"] = 46,["66"] = 47,["67"] = 47,["68"] = 49,["71"] = 54,["72"] = 55,["73"] = 44,["74"] = 58,["75"] = 60,["76"] = 58,["77"] = 63,["78"] = 65,["79"] = 65,["80"] = 67,["81"] = 68,["82"] = 69,["84"] = 72,["85"] = 73,["86"] = 74,["87"] = 75,["88"] = 75,["89"] = 75,["90"] = 75,["91"] = 75,["92"] = 75,["93"] = 75,["94"] = 75,["95"] = 75,["96"] = 78,["97"] = 78,["98"] = 78,["99"] = 78,["100"] = 78,["101"] = 78,["102"] = 78,["103"] = 78,["104"] = 78,["105"] = 80,["106"] = 80,["107"] = 80,["108"] = 80,["109"] = 80,["110"] = 80,["111"] = 80,["112"] = 80,["113"] = 81,["114"] = 81,["115"] = 81,["116"] = 81,["117"] = 81,["118"] = 81,["119"] = 81,["120"] = 81,["121"] = 82,["122"] = 82,["123"] = 82,["124"] = 82,["125"] = 82,["126"] = 82,["127"] = 82,["128"] = 82,["129"] = 63,["130"] = 85,["131"] = 87,["132"] = 85,["133"] = 90,["134"] = 92,["135"] = 90,["136"] = 95,["137"] = 97,["138"] = 95,["139"] = 100,["140"] = 102,["141"] = 100,["142"] = 105,["143"] = 107,["144"] = 105,["145"] = 33,["146"] = 32,["147"] = 33,["149"] = 33,["150"] = 114,["151"] = 115,["152"] = 114,["153"] = 115,["155"] = 115,["156"] = 117,["157"] = 118,["158"] = 114,["159"] = 122,["160"] = 124,["161"] = 125,["162"] = 126,["164"] = 126,["166"] = 127,["167"] = 122,["168"] = 130,["169"] = 132,["171"] = 132,["173"] = 133,["175"] = 133,["177"] = 130,["178"] = 115,["179"] = 114,["180"] = 115,["182"] = 115,["183"] = 137,["184"] = 138,["185"] = 137,["186"] = 138,["188"] = 138,["189"] = 140,["190"] = 141,["191"] = 145,["192"] = 137,["193"] = 147,["194"] = 149,["197"] = 154,["198"] = 155,["199"] = 155,["200"] = 156,["201"] = 147,["202"] = 159,["203"] = 161,["206"] = 166,["207"] = 159,["208"] = 169,["209"] = 171,["210"] = 171,["211"] = 173,["212"] = 174,["213"] = 175,["214"] = 176,["215"] = 176,["216"] = 176,["217"] = 176,["218"] = 176,["219"] = 176,["220"] = 176,["221"] = 176,["223"] = 180,["224"] = 181,["225"] = 181,["226"] = 181,["227"] = 181,["228"] = 181,["229"] = 181,["230"] = 181,["231"] = 181,["232"] = 181,["233"] = 183,["234"] = 183,["235"] = 183,["236"] = 183,["237"] = 183,["238"] = 183,["239"] = 183,["240"] = 183,["242"] = 186,["243"] = 187,["244"] = 187,["245"] = 187,["246"] = 187,["247"] = 187,["248"] = 187,["249"] = 187,["250"] = 187,["251"] = 169,["252"] = 190,["253"] = 192,["254"] = 190,["255"] = 195,["256"] = 197,["257"] = 195,["258"] = 138,["259"] = 137,["260"] = 138,["262"] = 138,["263"] = 204,["264"] = 205,["265"] = 204,["266"] = 205,["268"] = 205,["269"] = 207,["270"] = 208,["271"] = 209,["272"] = 215,["273"] = 216,["274"] = 217,["275"] = 218,["276"] = 204,["277"] = 220,["278"] = 222,["279"] = 223,["280"] = 224,["281"] = 225,["282"] = 226,["283"] = 227,["285"] = 227,["287"] = 228,["288"] = 220,["289"] = 231,["290"] = 233,["292"] = 233,["294"] = 231,["295"] = 236,["296"] = 238,["297"] = 239,["299"] = 239,["301"] = 240,["302"] = 241,["303"] = 242,["304"] = 236,["305"] = 245,["306"] = 247,["307"] = 249,["308"] = 250,["309"] = 252,["310"] = 252,["311"] = 252,["312"] = 252,["313"] = 252,["314"] = 252,["315"] = 252,["316"] = 252,["317"] = 252,["318"] = 252,["319"] = 252,["320"] = 252,["321"] = 252,["322"] = 255,["323"] = 257,["324"] = 259,["325"] = 259,["326"] = 259,["327"] = 259,["328"] = 259,["329"] = 259,["330"] = 257,["332"] = 270,["333"] = 271,["334"] = 271,["335"] = 273,["336"] = 275,["337"] = 277,["338"] = 279,["339"] = 279,["340"] = 279,["341"] = 279,["342"] = 279,["343"] = 279,["344"] = 277,["346"] = 290,["348"] = 293,["350"] = 296,["351"] = 245,["352"] = 299,["353"] = 301,["354"] = 302,["355"] = 304,["356"] = 306,["358"] = 306,["361"] = 310,["363"] = 310,["366"] = 299,["367"] = 314,["368"] = 316,["369"] = 316,["370"] = 318,["371"] = 319,["373"] = 321,["374"] = 323,["377"] = 325,["378"] = 326,["382"] = 329,["385"] = 331,["386"] = 332,["390"] = 335,["393"] = 337,["394"] = 338,["398"] = 341,["401"] = 343,["402"] = 344,["407"] = 349,["408"] = 350,["409"] = 351,["410"] = 352,["411"] = 352,["412"] = 352,["413"] = 352,["414"] = 352,["415"] = 353,["416"] = 353,["417"] = 353,["418"] = 353,["419"] = 353,["420"] = 354,["422"] = 358,["423"] = 359,["424"] = 360,["425"] = 360,["426"] = 360,["427"] = 360,["428"] = 360,["429"] = 361,["430"] = 361,["431"] = 361,["432"] = 361,["433"] = 361,["435"] = 314,["436"] = 365,["437"] = 367,["439"] = 367,["441"] = 365,["442"] = 370,["443"] = 372,["444"] = 370,["445"] = 205,["446"] = 204,["447"] = 205,["449"] = 205,["450"] = 379,["451"] = 380,["452"] = 379,["453"] = 380,["455"] = 380,["456"] = 382,["457"] = 386,["458"] = 387,["459"] = 388,["460"] = 379,["461"] = 390,["462"] = 392,["463"] = 393,["464"] = 394,["465"] = 395,["466"] = 396,["467"] = 390,["468"] = 399,["469"] = 401,["470"] = 402,["471"] = 403,["472"] = 399,["473"] = 406,["474"] = 408,["475"] = 410,["477"] = 414,["479"] = 406,["480"] = 418,["481"] = 420,["482"] = 418,["483"] = 423,["484"] = 425,["485"] = 423,["486"] = 428,["487"] = 430,["488"] = 428,["489"] = 433,["490"] = 435,["491"] = 433,["492"] = 438,["493"] = 440,["494"] = 438,["495"] = 443,["496"] = 445,["497"] = 443,["498"] = 448,["499"] = 448,["500"] = 453,["501"] = 455,["502"] = 453,["503"] = 458,["504"] = 460,["505"] = 458,["506"] = 380,["507"] = 379,["508"] = 380,["510"] = 380,["511"] = 464,["512"] = 465,["513"] = 464,["514"] = 465,["516"] = 465,["517"] = 470,["518"] = 471,["519"] = 472,["520"] = 464,["521"] = 474,["522"] = 476,["525"] = 481,["526"] = 482,["527"] = 483,["528"] = 484,["529"] = 485,["530"] = 486,["531"] = 474,["532"] = 489,["533"] = 491,["536"] = 496,["538"] = 498,["539"] = 500,["542"] = 502,["543"] = 503,["544"] = 503,["545"] = 505,["546"] = 506,["547"] = 506,["548"] = 506,["549"] = 507,["550"] = 507,["551"] = 507,["552"] = 508,["554"] = 508,["556"] = 509,["560"] = 512,["563"] = 514,["567"] = 517,["570"] = 519,["574"] = 523,["577"] = 525,["582"] = 530,["583"] = 532,["584"] = 532,["585"] = 534,["586"] = 535,["588"] = 535,["590"] = 536,["592"] = 489,["593"] = 540,["594"] = 542,["597"] = 547,["599"] = 547,["601"] = 548,["603"] = 548,["605"] = 549,["607"] = 549,["609"] = 550,["611"] = 550,["613"] = 551,["614"] = 551,["615"] = 551,["616"] = 551,["617"] = 551,["618"] = 551,["619"] = 551,["620"] = 551,["621"] = 552,["623"] = 552,["625"] = 540,["626"] = 465,["627"] = 464,["628"] = 465,["630"] = 465,["631"] = 556,["632"] = 557,["633"] = 556,["634"] = 557,["636"] = 557,["637"] = 559,["638"] = 560,["639"] = 565,["640"] = 566,["641"] = 567,["642"] = 569,["643"] = 570,["644"] = 556,["645"] = 572,["646"] = 574,["649"] = 579,["650"] = 580,["651"] = 581,["652"] = 582,["653"] = 582,["654"] = 583,["655"] = 572,["656"] = 586,["657"] = 588,["660"] = 593,["662"] = 593,["664"] = 594,["665"] = 594,["666"] = 595,["667"] = 595,["668"] = 596,["669"] = 596,["670"] = 597,["671"] = 598,["673"] = 598,["675"] = 600,["676"] = 602,["678"] = 586,["679"] = 606,["680"] = 608,["683"] = 613,["684"] = 613,["685"] = 614,["686"] = 615,["687"] = 616,["688"] = 616,["689"] = 617,["690"] = 606,["691"] = 620,["692"] = 622,["693"] = 622,["695"] = 622,["696"] = 622,["697"] = 622,["698"] = 622,["700"] = 623,["703"] = 623,["705"] = 623,["708"] = 623,["710"] = 624,["713"] = 624,["715"] = 624,["718"] = 624,["720"] = 622,["721"] = 626,["722"] = 628,["723"] = 632,["724"] = 633,["725"] = 628,["726"] = 630,["727"] = 630,["728"] = 630,["729"] = 630,["730"] = 630,["731"] = 630,["732"] = 628,["733"] = 640,["734"] = 640,["735"] = 642,["736"] = 642,["737"] = 642,["740"] = 642,["742"] = 642,["743"] = 642,["744"] = 642,["745"] = 642,["748"] = 620,["749"] = 647,["750"] = 649,["751"] = 649,["752"] = 651,["754"] = 654,["755"] = 655,["756"] = 656,["757"] = 647,["758"] = 659,["759"] = 661,["760"] = 662,["761"] = 662,["762"] = 662,["763"] = 662,["764"] = 662,["765"] = 662,["766"] = 662,["767"] = 671,["768"] = 659,["769"] = 674,["770"] = 676,["771"] = 674,["772"] = 679,["773"] = 681,["774"] = 679,["775"] = 557,["776"] = 556,["777"] = 557,["779"] = 557,["780"] = 685,["781"] = 686,["782"] = 685,["783"] = 686,["785"] = 686,["786"] = 688,["787"] = 685,["788"] = 693,["789"] = 695,["792"] = 700,["793"] = 701,["794"] = 702,["795"] = 693,["796"] = 705,["797"] = 707,["800"] = 712,["801"] = 712,["802"] = 714,["803"] = 716,["804"] = 716,["805"] = 716,["806"] = 716,["807"] = 716,["808"] = 716,["809"] = 714,["810"] = 705,["811"] = 727,["812"] = 729,["813"] = 729,["814"] = 731,["816"] = 734,["817"] = 735,["818"] = 735,["819"] = 735,["820"] = 735,["821"] = 735,["822"] = 735,["823"] = 735,["824"] = 735,["825"] = 727,["826"] = 738,["827"] = 740,["828"] = 738,["829"] = 743,["830"] = 745,["831"] = 743,["832"] = 686,["833"] = 685,["834"] = 686,["836"] = 686,["837"] = 749,["838"] = 750,["839"] = 749,["840"] = 750,["842"] = 750,["843"] = 752,["844"] = 753,["845"] = 754,["846"] = 759,["847"] = 760,["848"] = 749,["849"] = 762,["850"] = 764,["853"] = 769,["854"] = 770,["855"] = 771,["856"] = 771,["857"] = 772,["858"] = 772,["859"] = 762,["860"] = 775,["861"] = 777,["864"] = 782,["866"] = 782,["868"] = 783,["869"] = 783,["870"] = 784,["871"] = 784,["872"] = 785,["873"] = 785,["874"] = 786,["875"] = 787,["877"] = 787,["879"] = 788,["880"] = 788,["881"] = 788,["882"] = 788,["883"] = 788,["884"] = 788,["885"] = 788,["886"] = 788,["887"] = 788,["888"] = 790,["889"] = 792,["891"] = 775,["892"] = 796,["893"] = 798,["896"] = 803,["897"] = 803,["898"] = 804,["899"] = 804,["901"] = 796,["902"] = 750,["903"] = 749,["904"] = 750,["906"] = 750,["907"] = 811,["908"] = 812,["909"] = 811,["910"] = 812,["911"] = 817,["912"] = 819,["913"] = 820,["914"] = 820,["915"] = 820,["916"] = 820,["917"] = 820,["918"] = 820,["919"] = 820,["920"] = 820,["921"] = 821,["922"] = 822,["923"] = 823,["924"] = 817,["925"] = 826,["927"] = 828,["929"] = 828,["931"] = 829,["932"] = 830,["934"] = 830,["937"] = 826,["938"] = 812,["939"] = 811,["940"] = 812,["942"] = 812,["943"] = 834,["944"] = 835,["945"] = 834,["946"] = 835,["947"] = 837,["948"] = 839,["949"] = 840,["950"] = 840,["951"] = 840,["952"] = 840,["953"] = 840,["954"] = 840,["955"] = 840,["956"] = 840,["957"] = 850,["958"] = 837,["959"] = 853,["960"] = 855,["961"] = 853,["962"] = 858,["963"] = 860,["964"] = 858,["965"] = 863,["966"] = 865,["967"] = 863,["968"] = 868,["969"] = 870,["970"] = 868,["971"] = 835,["972"] = 834,["973"] = 835,["975"] = 835});
local ____exports = {}
local ____dota_ts_adapter = require("tslib.dota_ts_adapter")
local BaseAbility = ____dota_ts_adapter.BaseAbility
local BaseModifier = ____dota_ts_adapter.BaseModifier
local registerAbility = ____dota_ts_adapter.registerAbility
local registerModifier = ____dota_ts_adapter.registerModifier
local ____sleep_timer = require("tslib.sleep_timer")
local Sleep = ____sleep_timer.Sleep
require("libraries.util")
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
    if not IsServer() then
        return
    end
    self.Caster = self:GetCaster()
    local ____opt_16 = self:GetAbility()
    self.BonusDmg = ____opt_16 and ____opt_16:GetSpecialValueFor("BonusDmg")
    self:CreateParticle()
end
function musashi_modifier_tengan.prototype.OnRefresh(self)
    if not IsServer() then
        return
    end
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
            local ____switch40 = self.SlashCount
            local ____cond40 = ____switch40 == 1
            if ____cond40 then
                do
                    AoeParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_earth.vpcf"
                    CrackParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_earth_crack.vpcf"
                    break
                end
            end
            ____cond40 = ____cond40 or ____switch40 == 2
            if ____cond40 then
                do
                    AoeParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_water.vpcf"
                    CrackParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_earth_crack.vpcf"
                    break
                end
            end
            ____cond40 = ____cond40 or ____switch40 == 3
            if ____cond40 then
                do
                    AoeParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_fire.vpcf"
                    CrackParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_fire_crack.vpcf"
                    break
                end
            end
            ____cond40 = ____cond40 or ____switch40 == 4
            if ____cond40 then
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
____exports.musashi_ganryuu_jima = __TS__Class()
local musashi_ganryuu_jima = ____exports.musashi_ganryuu_jima
musashi_ganryuu_jima.name = "musashi_ganryuu_jima"
__TS__ClassExtends(musashi_ganryuu_jima, BaseAbility)
function musashi_ganryuu_jima.prototype.____constructor(self, ...)
    BaseAbility.prototype.____constructor(self, ...)
    self.SoundVoiceline = "antimage_anti_ability_manavoid_01"
    self.DashPosition = Vector(0, 0, 0)
    self.SlashPosition = Vector(0, 0, 0)
    self.SecondSlashPosition = Vector(0, 0, 0)
end
function musashi_ganryuu_jima.prototype.OnVectorCastStart(self, vStartLocation, vDirection)
    self.Caster = self:GetCaster()
    self:SetVector(vStartLocation, vDirection)
    local DashCounter = self.Caster:AddNewModifier(self.Caster, self, ____exports.musashi_modifier_ganryuu_jima.name, {undefined = undefined})
    DashCounter:IncrementStackCount()
    EmitGlobalSound(self.SoundVoiceline)
end
function musashi_ganryuu_jima.prototype.SetVector(self, vStartLocation, vDirection)
    self.DashPosition = vStartLocation
    self.SlashPosition = vDirection
    self.SecondSlashPosition = vDirection:__unm()
end
function musashi_ganryuu_jima.prototype.GetCastRange(self)
    if IsServer() then
        return 0
    else
        return self:GetSpecialValueFor("SlashRange")
    end
end
function musashi_ganryuu_jima.prototype.GetVectorTargetRange(self)
    return self:GetSpecialValueFor("SlashRange")
end
function musashi_ganryuu_jima.prototype.GetVectorTargetStartRadius(self)
    return self:GetSpecialValueFor("SlashRadius")
end
function musashi_ganryuu_jima.prototype.GetVectorTargetEndRadius(self)
    return self:GetSpecialValueFor("SlashRadius")
end
function musashi_ganryuu_jima.prototype.GetVectorPosition(self)
    return self.DashPosition
end
function musashi_ganryuu_jima.prototype.GetVectorDirection(self)
    return self.SlashPosition
end
function musashi_ganryuu_jima.prototype.GetVector2Position(self)
    return self.SlashPosition
end
function musashi_ganryuu_jima.prototype.UpdateVectorValues(self)
end
function musashi_ganryuu_jima.prototype.IsDualVectorDirection(self)
    return false
end
function musashi_ganryuu_jima.prototype.IgnoreVectorArrowWidth(self)
    return false
end
musashi_ganryuu_jima = __TS__Decorate(
    {registerAbility(nil)},
    musashi_ganryuu_jima
)
____exports.musashi_ganryuu_jima = musashi_ganryuu_jima
____exports.musashi_modifier_ganryuu_jima = __TS__Class()
local musashi_modifier_ganryuu_jima = ____exports.musashi_modifier_ganryuu_jima
musashi_modifier_ganryuu_jima.name = "musashi_modifier_ganryuu_jima"
__TS__ClassExtends(musashi_modifier_ganryuu_jima, BaseModifier)
function musashi_modifier_ganryuu_jima.prototype.____constructor(self, ...)
    BaseModifier.prototype.____constructor(self, ...)
    self.DashPosition = Vector(0, 0, 0)
    self.SlashPosition = Vector(0, 0, 0)
    self.SecondSlashPosition = Vector(0, 0, 0)
end
function musashi_modifier_ganryuu_jima.prototype.OnCreated(self)
    if not IsServer() then
        return
    end
    self.Caster = self:GetCaster()
    self.Ganryuu_Jima = self:GetAbility()
    self.DashPosition = self.Ganryuu_Jima.DashPosition
    self.SlashPosition = self.Ganryuu_Jima.SlashPosition
    self.SecondSlashPosition = self.Ganryuu_Jima.SecondSlashPosition
    giveUnitDataDrivenModifier(self.Caster, self.Caster, "pause_sealdisabled", 1.5)
end
function musashi_modifier_ganryuu_jima.prototype.OnStackCountChanged(self, stackCount)
    if not IsServer() then
        return
    end
    local Position = Vector(0, 0, 0)
    repeat
        local ____switch66 = stackCount
        local ____cond66 = ____switch66 == 0
        if ____cond66 then
            do
                Position = self.DashPosition
                local ____opt_39 = self.Caster
                local DashBuff = ____opt_39 and ____opt_39:AddNewModifier(self.Caster, self.Ganryuu_Jima, ____exports.musashi_modifier_ganryuu_jima_dash.name, {undefined = undefined})
                DashBuff.TargetPoint = Position
                local ____DashBuff_TargetPoint_43 = DashBuff.TargetPoint
                local ____opt_41 = self.Caster
                ____DashBuff_TargetPoint_43.z = ____opt_41 and ____opt_41:GetAbsOrigin().z
                local ____DashBuff_TargetPoint_46 = DashBuff.TargetPoint
                local ____opt_44 = self.Caster
                DashBuff.NormalizedTargetPoint = (____DashBuff_TargetPoint_46 - (____opt_44 and ____opt_44:GetAbsOrigin())):Normalized()
                local ____opt_47 = self.Caster
                if ____opt_47 ~= nil then
                    ____opt_47:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_1, 2)
                end
                DashBuff:StartIntervalThink(0.03)
                break
            end
        end
        ____cond66 = ____cond66 or ____switch66 == 1
        if ____cond66 then
            do
                Position = self.SlashPosition
                break
            end
        end
        ____cond66 = ____cond66 or ____switch66 == 2
        if ____cond66 then
            do
                Position = self.SecondSlashPosition
                break
            end
        end
        ____cond66 = ____cond66 or ____switch66 == 3
        if ____cond66 then
            do
                self:Destroy()
                break
            end
        end
    until true
    if stackCount == 1 or stackCount == 2 then
        local ____opt_49 = self.Caster
        local SlashBuff = ____opt_49 and ____opt_49:AddNewModifier(self.Caster, self.Ganryuu_Jima, ____exports.musashi_modifier_ganryuu_jima_slash.name, {undefined = undefined})
        SlashBuff.TargetPoint = Position
        local ____opt_51 = self.Caster
        if ____opt_51 ~= nil then
            ____opt_51:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_2, 2)
        end
        SlashBuff:StartIntervalThink(0.03)
    end
end
function musashi_modifier_ganryuu_jima.prototype.OnDestroy(self)
    if not IsServer() then
        return
    end
    local ____opt_53 = self.Caster
    if ____opt_53 ~= nil then
        ____opt_53:RemoveGesture(ACT_DOTA_CAST_ABILITY_1)
    end
    local ____opt_55 = self.Caster
    if ____opt_55 ~= nil then
        ____opt_55:RemoveGesture(ACT_DOTA_CAST_ABILITY_2)
    end
    local ____opt_57 = self.Caster
    if ____opt_57 ~= nil then
        ____opt_57:StartGesture(ACT_DOTA_CAST_ABILITY_2_END)
    end
    local ____opt_59 = self.Caster
    if ____opt_59 ~= nil then
        ____opt_59:SetForwardVector(self.Caster:GetForwardVector() * 10)
    end
    local ____FindClearSpaceForUnit_64 = FindClearSpaceForUnit
    local ____self_Caster_63 = self.Caster
    local ____opt_61 = self.Caster
    ____FindClearSpaceForUnit_64(
        ____self_Caster_63,
        ____opt_61 and ____opt_61:GetAbsOrigin(),
        true
    )
    local ____opt_65 = self.Caster
    if ____opt_65 ~= nil then
        ____opt_65:AddNewModifier(self.Caster, self.Ganryuu_Jima, "modifier_phase", {duration = 1.5})
    end
end
musashi_modifier_ganryuu_jima = __TS__Decorate(
    {registerModifier(nil)},
    musashi_modifier_ganryuu_jima
)
____exports.musashi_modifier_ganryuu_jima = musashi_modifier_ganryuu_jima
____exports.musashi_modifier_ganryuu_jima_slash = __TS__Class()
local musashi_modifier_ganryuu_jima_slash = ____exports.musashi_modifier_ganryuu_jima_slash
musashi_modifier_ganryuu_jima_slash.name = "musashi_modifier_ganryuu_jima_slash"
__TS__ClassExtends(musashi_modifier_ganryuu_jima_slash, BaseModifier)
function musashi_modifier_ganryuu_jima_slash.prototype.____constructor(self, ...)
    BaseModifier.prototype.____constructor(self, ...)
    self.SoundSfx = "musashi_ganryuu_jima_sfx"
    self.ParticleStr = "particles/custom/musashi/musashi_ganryuu_jima_basic.vpcf"
    self.StartPosition = Vector(0, 0, 0)
    self.EndPosition = Vector(0, 0, 0)
    self.TargetPoint = Vector(0, 0, 0)
    self.SlashRange = 0
    self.UnitsTravelled = 0
end
function musashi_modifier_ganryuu_jima_slash.prototype.OnCreated(self)
    if not IsServer() then
        return
    end
    self.Caster = self:GetCaster()
    self.Ability = self:GetAbility()
    self.StartPosition = self.Caster:GetAbsOrigin()
    local ____opt_67 = self.Ability
    self.SlashRange = ____opt_67 and ____opt_67:GetSpecialValueFor("SlashRange")
    self.Caster:EmitSound(self.SoundSfx)
end
function musashi_modifier_ganryuu_jima_slash.prototype.OnIntervalThink(self)
    if not IsServer() then
        return
    end
    local ____opt_69 = self.Caster
    if ____opt_69 ~= nil then
        ____opt_69:SetForwardVector(self.TargetPoint)
    end
    local ____opt_71 = self.Caster
    local CurrentOrigin = ____opt_71 and ____opt_71:GetAbsOrigin()
    local ____opt_73 = self.Ability
    local DashSpeed = ____opt_73 and ____opt_73:GetSpecialValueFor("DashSpeed")
    local ____opt_75 = self.Caster
    local NewPosition = CurrentOrigin + (____opt_75 and ____opt_75:GetForwardVector()) * DashSpeed
    self.UnitsTravelled = self.UnitsTravelled + (NewPosition - CurrentOrigin):Length2D()
    local ____opt_77 = self.Caster
    if ____opt_77 ~= nil then
        ____opt_77:SetAbsOrigin(NewPosition)
    end
    if self.UnitsTravelled >= self.SlashRange then
        self:Destroy()
    end
end
function musashi_modifier_ganryuu_jima_slash.prototype.OnDestroy(self)
    if not IsServer() then
        return
    end
    local ____opt_79 = self.Caster
    self.EndPosition = ____opt_79 and ____opt_79:GetAbsOrigin()
    self:CreateParticle()
    self:DoDamage()
    local ____opt_81 = self.Caster
    local DashCounter = ____opt_81 and ____opt_81:FindModifierByName(____exports.musashi_modifier_ganryuu_jima.name)
    DashCounter:IncrementStackCount()
end
function musashi_modifier_ganryuu_jima_slash.prototype.DoDamage(self)
    local ____FindUnitsInLine_94 = FindUnitsInLine
    local ____opt_83 = self.Caster
    local ____array_93 = __TS__SparseArrayNew(
        ____opt_83 and ____opt_83:GetTeam(),
        self.StartPosition,
        self.EndPosition,
        nil
    )
    local ____opt_85 = self.Ability
    __TS__SparseArrayPush(
        ____array_93,
        ____opt_85 and ____opt_85:GetSpecialValueFor("SlashRadius")
    )
    local ____opt_87 = self.Ability
    __TS__SparseArrayPush(
        ____array_93,
        ____opt_87 and ____opt_87:GetAbilityTargetTeam()
    )
    local ____opt_89 = self.Ability
    __TS__SparseArrayPush(
        ____array_93,
        ____opt_89 and ____opt_89:GetAbilityTargetType()
    )
    local ____opt_91 = self.Ability
    __TS__SparseArrayPush(
        ____array_93,
        ____opt_91 and ____opt_91:GetAbilityTargetFlags()
    )
    local Targets = ____FindUnitsInLine_94(__TS__SparseArraySpread(____array_93))
    for ____, Iterator in ipairs(Targets) do
        local ____ApplyDamage_98 = ApplyDamage
        local ____self_Caster_97 = self.Caster
        local ____opt_95 = self.Ability
        ____ApplyDamage_98({
            victim = Iterator,
            attacker = ____self_Caster_97,
            damage = ____opt_95 and ____opt_95:GetSpecialValueFor("DmgPerSlash"),
            damage_type = DAMAGE_TYPE_MAGICAL,
            damage_flags = DOTA_DAMAGE_FLAG_NONE,
            ability = self.Ability
        })
        local ____opt_99 = self.Caster
        if ____opt_99 and ____opt_99:HasModifier(____exports.musashi_modifier_tengan.name) then
            local ____Iterator_AddNewModifier_104 = Iterator.AddNewModifier
            local ____array_103 = __TS__SparseArrayNew(self.Caster, self.Ability, ____exports.musashi_modifier_ganryuu_jima_debuff.name)
            local ____opt_101 = self.Ability
            __TS__SparseArrayPush(
                ____array_103,
                {duration = ____opt_101 and ____opt_101:GetSpecialValueFor("DmgDelay")}
            )
            ____Iterator_AddNewModifier_104(
                Iterator,
                __TS__SparseArraySpread(____array_103)
            )
        end
    end
end
function musashi_modifier_ganryuu_jima_slash.prototype.CreateParticle(self)
    local ____opt_105 = self.Caster
    if ____opt_105 and ____opt_105:HasModifier("modifier_ascended") then
        self.ParticleStr = "particles/custom/musashi/musashi_ganryuu_jima_unique.vpcf"
    end
    local ParticleId = ParticleManager:CreateParticle(self.ParticleStr, PATTACH_WORLDORIGIN, self.Caster)
    ParticleManager:SetParticleControl(ParticleId, 0, self.StartPosition)
    ParticleManager:SetParticleControl(ParticleId, 1, self.EndPosition)
end
function musashi_modifier_ganryuu_jima_slash.prototype.CheckState(self)
    local ModifierTable = {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,
        [MODIFIER_STATE_UNTARGETABLE] = true,
        [MODIFIER_STATE_UNSELECTABLE] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true
    }
    return ModifierTable
end
function musashi_modifier_ganryuu_jima_slash.prototype.IsPurgable(self)
    return false
end
function musashi_modifier_ganryuu_jima_slash.prototype.IsPurgeException(self)
    return false
end
musashi_modifier_ganryuu_jima_slash = __TS__Decorate(
    {registerModifier(nil)},
    musashi_modifier_ganryuu_jima_slash
)
____exports.musashi_modifier_ganryuu_jima_slash = musashi_modifier_ganryuu_jima_slash
____exports.musashi_modifier_ganryuu_jima_debuff = __TS__Class()
local musashi_modifier_ganryuu_jima_debuff = ____exports.musashi_modifier_ganryuu_jima_debuff
musashi_modifier_ganryuu_jima_debuff.name = "musashi_modifier_ganryuu_jima_debuff"
__TS__ClassExtends(musashi_modifier_ganryuu_jima_debuff, BaseModifier)
function musashi_modifier_ganryuu_jima_debuff.prototype.____constructor(self, ...)
    BaseModifier.prototype.____constructor(self, ...)
    self.ParticleStr = "particles/custom/musashi/musashi_ganryuu_jima_debuff_basic.vpcf"
end
function musashi_modifier_ganryuu_jima_debuff.prototype.OnCreated(self)
    if not IsServer() then
        return
    end
    self.Caster = self:GetCaster()
    self.Victim = self:GetParent()
    self:CreateParticle()
end
function musashi_modifier_ganryuu_jima_debuff.prototype.OnDestroy(self)
    if not IsServer() then
        return
    end
    local ____opt_107 = self.Caster
    local ModifierTengan = ____opt_107 and ____opt_107:FindModifierByName(____exports.musashi_modifier_tengan.name)
    ApplyDamage({
        victim = self.Victim,
        attacker = self.Caster,
        damage = ModifierTengan.BonusDmg,
        damage_type = DAMAGE_TYPE_PURE,
        damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
        ability = self:GetAbility()
    })
end
function musashi_modifier_ganryuu_jima_debuff.prototype.CreateParticle(self)
    local ____opt_109 = self.Caster
    if ____opt_109 and ____opt_109:HasModifier("modifier_ascended") then
        self.ParticleStr = "particles/custom/musashi/musashi_ganryuu_jima_debuff_unique.vpcf"
    end
    local DebuffParticle = ParticleManager:CreateParticle(self.ParticleStr, PATTACH_POINT_FOLLOW, self.Victim)
    self:AddParticle(
        DebuffParticle,
        false,
        false,
        -1,
        false,
        false
    )
end
function musashi_modifier_ganryuu_jima_debuff.prototype.IsPurgable(self)
    return false
end
function musashi_modifier_ganryuu_jima_debuff.prototype.IsPurgeException(self)
    return false
end
musashi_modifier_ganryuu_jima_debuff = __TS__Decorate(
    {registerModifier(nil)},
    musashi_modifier_ganryuu_jima_debuff
)
____exports.musashi_modifier_ganryuu_jima_debuff = musashi_modifier_ganryuu_jima_debuff
____exports.musashi_modifier_ganryuu_jima_dash = __TS__Class()
local musashi_modifier_ganryuu_jima_dash = ____exports.musashi_modifier_ganryuu_jima_dash
musashi_modifier_ganryuu_jima_dash.name = "musashi_modifier_ganryuu_jima_dash"
__TS__ClassExtends(musashi_modifier_ganryuu_jima_dash, BaseModifier)
function musashi_modifier_ganryuu_jima_dash.prototype.____constructor(self, ...)
    BaseModifier.prototype.____constructor(self, ...)
    self.StartPosition = Vector(0, 0, 0)
    self.TargetPoint = Vector(0, 0, 0)
    self.NormalizedTargetPoint = Vector(0, 0, 0)
    self.SlashRange = 0
    self.UnitsTravelled = 0
end
function musashi_modifier_ganryuu_jima_dash.prototype.OnCreated(self)
    if not IsServer() then
        return
    end
    self.Caster = self:GetCaster()
    self.Ability = self:GetAbility()
    local ____opt_111 = self.Caster
    self.StartPosition = ____opt_111 and ____opt_111:GetAbsOrigin()
    local ____opt_113 = self.Ability
    self.SlashRange = ____opt_113 and ____opt_113:GetSpecialValueFor("SlashRange")
end
function musashi_modifier_ganryuu_jima_dash.prototype.OnIntervalThink(self)
    if not IsServer() then
        return
    end
    local ____opt_115 = self.Caster
    if ____opt_115 ~= nil then
        ____opt_115:SetForwardVector(self.NormalizedTargetPoint)
    end
    local ____opt_117 = self.Caster
    local CurrentOrigin = ____opt_117 and ____opt_117:GetAbsOrigin()
    local ____opt_119 = self.Ability
    local DashSpeed = ____opt_119 and ____opt_119:GetSpecialValueFor("DashSpeed")
    local ____opt_121 = self.Caster
    local NewPosition = CurrentOrigin + (____opt_121 and ____opt_121:GetForwardVector()) * DashSpeed
    self.UnitsTravelled = self.UnitsTravelled + (NewPosition - CurrentOrigin):Length2D()
    local ____opt_123 = self.Caster
    if ____opt_123 ~= nil then
        ____opt_123:SetAbsOrigin(NewPosition)
    end
    local ____Entities_FindByNameWithin_127 = Entities.FindByNameWithin
    local ____opt_125 = self.Caster
    local Musashi = ____Entities_FindByNameWithin_127(
        Entities,
        nil,
        ____opt_125 and ____opt_125:GetName(),
        self.TargetPoint,
        DashSpeed
    )
    if Musashi or self.UnitsTravelled >= self.SlashRange then
        self:Destroy()
    end
end
function musashi_modifier_ganryuu_jima_dash.prototype.OnDestroy(self)
    if not IsServer() then
        return
    end
    local ____opt_128 = self.Caster
    local DashCounter = ____opt_128 and ____opt_128:FindModifierByName(____exports.musashi_modifier_ganryuu_jima.name)
    if DashCounter ~= nil then
        DashCounter:IncrementStackCount()
    end
end
musashi_modifier_ganryuu_jima_dash = __TS__Decorate(
    {registerModifier(nil)},
    musashi_modifier_ganryuu_jima_dash
)
____exports.musashi_modifier_ganryuu_jima_dash = musashi_modifier_ganryuu_jima_dash
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
        local ____opt_132 = self.Niou
        if ____opt_132 ~= nil then
            ____opt_132:ForceKill(false)
        end
        __TS__Await(Sleep(nil, delay))
        local ____opt_134 = self.Niou
        if ____opt_134 ~= nil then
            ____opt_134:Destroy()
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
    local ModifierTable = {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,
        [MODIFIER_STATE_UNTARGETABLE] = true,
        [MODIFIER_STATE_UNSELECTABLE] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_NOT_ON_MINIMAP] = true
    }
    return ModifierTable
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
