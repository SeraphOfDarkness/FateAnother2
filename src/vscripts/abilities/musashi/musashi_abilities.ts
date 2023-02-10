import { BaseAbility, BaseModifier, registerAbility, registerModifier } from "../../tslib/dota_ts_adapter";
import { Sleep } from "../../tslib/sleep_timer";

//======================================================================================================================
// Miyamoto Musashi : Skill 1 : Dai Go Sei (Q)
//======================================================================================================================
@registerAbility()
export class musashi_dai_go_sei extends BaseAbility
{
    readonly SoundVoiceline : string = "antimage_anti_cast_01";
    readonly SoundSfx : string = "musashi_dai_go_sei_sfx";

    Caster : CDOTA_BaseNPC | undefined;

    override OnSpellStart(): void
    {
        this.Caster = this.GetCaster();
        const BuffDuration = this.GetSpecialValueFor("BuffDuration");
        this.Caster.AddNewModifier(this.Caster, this, musashi_modifier_dai_go_sei.name, {duration : BuffDuration});
        this.PlaySound();
    }

    PlaySound(): void
    {
        this.Caster?.EmitSound(this.SoundVoiceline);
        this.Caster?.EmitSound(this.SoundSfx);
    }
}

@registerModifier()
export class musashi_modifier_dai_go_sei extends BaseModifier
{
    ParticleStr : string = "particles/custom/musashi/musashi_dai_go_sei_basic.vpcf";
    BlueOrbParticleStr : string = "particles/custom/musashi/musashi_dai_go_sei_blueorb_basic.vpcf";
    RedOrbParticleStr : string = "particles/custom/musashi/musashi_dai_go_sei_redorb_basic.vpcf";

    Caster : CDOTA_BaseNPC | undefined;

    BonusDmg : number = 0;
    BonusAtkSpeed : number = 0;

    override OnCreated(): void
    {
        this.BonusDmg = this.GetAbility()?.GetSpecialValueFor("BonusDmg")!;
        this.BonusAtkSpeed = this.GetAbility()?.GetSpecialValueFor("BonusAtkSpeed")!;

        if (!IsServer())
        {
            return;
        }

        this.Caster = this.GetCaster();
        this.CreateParticle();
    }

    override OnRefresh(): void
    {
        this.OnCreated();
    }

    CreateParticle(): void
    {
        if (this.Caster?.HasModifier("modifier_ascended"))
        {
            this.ParticleStr = "particles/custom/musashi/musashi_dai_go_sei_unique.vpcf";
            this.BlueOrbParticleStr = "particles/custom/musashi/musashi_dai_go_sei_blueorb_unique.vpcf";
            this.RedOrbParticleStr = "particles/custom/musashi/musashi_dai_go_sei_redorb_unique.vpcf";
        }

        const BuffParticle = ParticleManager.CreateParticle(this.ParticleStr, ParticleAttachment.OVERHEAD_FOLLOW, this.Caster);
        const BlueOrbParticle = ParticleManager.CreateParticle(this.BlueOrbParticleStr, ParticleAttachment.POINT_FOLLOW, this.Caster);
        const RedOrbParticle = ParticleManager.CreateParticle(this.RedOrbParticleStr, ParticleAttachment.POINT_FOLLOW, this.Caster);
        ParticleManager.SetParticleControlEnt(BlueOrbParticle, 1, this.Caster!, ParticleAttachment.POINT_FOLLOW, "attach_attack2",
                                              Vector(0, 0, 0), false);

        ParticleManager.SetParticleControlEnt(RedOrbParticle, 1, this.Caster!, ParticleAttachment.POINT_FOLLOW, "attach_attack1",
                                              Vector(0, 0, 0), false);
        this.AddParticle(BuffParticle, false, false, -1, false, false);
        this.AddParticle(BlueOrbParticle, false, false, -1, false, false);
        this.AddParticle(RedOrbParticle, false, false, -1, false, false);
    }

    override DeclareFunctions(): ModifierFunction[]
    {
        return [ModifierFunction.PREATTACK_BONUS_DAMAGE, ModifierFunction.ATTACKSPEED_BONUS_CONSTANT];
    }

    override GetModifierPreAttack_BonusDamage(): number
    {
        return this.BonusDmg;
    }

    override GetModifierAttackSpeedBonus_Constant(): number
    {
        return this.BonusAtkSpeed;
    }

    override IsPurgable(): boolean
    {
        return false;
    }

    override IsPurgeException(): boolean
    {
        return false;
    }
}

//======================================================================================================================
// Miyamoto Musashi : Skill 2 : Tengan (W)
//======================================================================================================================
@registerAbility()
export class musashi_tengan extends BaseAbility
{
    readonly SoundVoiceline : string = "antimage_anti_cast_02";
    readonly SoundSfx : string = "musashi_tengan_sfx";

    Caster : CDOTA_BaseNPC | undefined;

    override OnSpellStart(): void
    {
        this.Caster = this.GetCaster();
        const BuffDuration = this.GetSpecialValueFor("BuffDuration");
        this.Caster?.AddNewModifier(this.Caster, this, musashi_modifier_tengan.name, {duration : BuffDuration});
        this.PlaySound();
    }

    PlaySound(): void
    {
        this.Caster?.EmitSound(this.SoundVoiceline);
        this.Caster?.EmitSound(this.SoundSfx);
    }
}

@registerModifier()
export class musashi_modifier_tengan extends BaseModifier
{
    ParticleStr : string = "particles/custom/musashi/musashi_tengan_basic.vpcf";
    OverheadParticleStr : string = "particles/custom/musashi/musashi_tengan_overhead_basic.vpcf";

    Caster : CDOTA_BaseNPC | undefined;
    
    BonusDmg : number = 0;

    override OnCreated(): void
    {
        this.BonusDmg = this.GetAbility()?.GetSpecialValueFor("BonusDmg")!;

        if (!IsServer())
        {
            return;
        }

        this.Caster = this.GetParent();
        this.CreateParticle();
    }

    override OnRefresh(): void
    {
        this.OnCreated();
    }

    CreateParticle(): void
    {
        if (this.Caster?.HasModifier("modifier_ascended"))
        {
            this.ParticleStr = "particles/custom/musashi/musashi_tengan_unique.vpcf";
            this.OverheadParticleStr = "particles/custom/musashi/musashi_tengan_overhead_unique.vpcf";
            const OverheadParticle = ParticleManager.CreateParticle(this.OverheadParticleStr, ParticleAttachment.OVERHEAD_FOLLOW, this.Caster);
            this.AddParticle(OverheadParticle, false, false, -1, false, false);
        }
        else
        {
            const OverheadParticle = ParticleManager.CreateParticle(this.OverheadParticleStr, ParticleAttachment.OVERHEAD_FOLLOW, this.Caster);
            ParticleManager.SetParticleControlEnt(OverheadParticle, 10, this.Caster!, ParticleAttachment.OVERHEAD_FOLLOW,
                                                  "attach_hitloc", Vector(0, 0, 0), false);
            this.AddParticle(OverheadParticle, false, false, -1, false, false);
        }

        const BuffParticle = ParticleManager.CreateParticle(this.ParticleStr, ParticleAttachment.POINT_FOLLOW, this.Caster);
        this.AddParticle(BuffParticle, false, false, -1, false, false);
    }

    override IsPurgable(): boolean
    {
        return false;
    }

    override IsPurgeException(): boolean
    {
        return false;
    }
}

//======================================================================================================================
// Miyamoto Musashi : Skill 3 : Niou Kurikara (E)
//======================================================================================================================
@registerAbility()
export class musashi_niou_kurikara extends BaseAbility
{
    readonly SoundVoiceline : string = "antimage_anti_cast_03";
    readonly SoundSfx : string = "musashi_niou_kurikara_sfx";

    readonly BasicAoeParticle : string = "particles/custom/musashi/musashi_niou_kurikara_basic.vpcf";

    Caster : CDOTA_BaseNPC | undefined;
    NiouSkill : musashi_niou | undefined;
    Niou : CDOTA_BaseNPC | undefined;

    TargetAoe : Vector = Vector(0, 0, 0);
    Interval : number = 0;
    SlashCount : number = 0;
    DmgPerSlash : number = 0;

    override OnAbilityPhaseStart(): boolean
    {
        this.Caster = this.GetCaster();
        this.NiouSkill = this.Caster.FindAbilityByName(musashi_niou.name) as musashi_niou;
        this.NiouSkill.CastAbility();
        this.Niou = this.NiouSkill.Niou;
        this.TargetAoe = this.GetCursorPosition();
        this.Niou?.FaceTowards(this.TargetAoe);
        return true;
    }

    override OnAbilityPhaseInterrupted(): void
    {
        this.NiouSkill?.DestroyNiou(0);
    }

    override OnSpellStart(): void
    {
        this.DmgPerSlash = this.GetSpecialValueFor("DmgPerSlash");
        this.Niou?.StartGestureWithPlaybackRate(GameActivity.DOTA_CHANNEL_ABILITY_1, 1.1);
        this.Interval = 0.5;
        EmitGlobalSound(this.SoundVoiceline);
        ++this.SlashCount;
    }

    override OnChannelThink(interval: number): void
    {
        if (this.Interval >= 0.5 && this.SlashCount < 5)
        {
            EmitSoundOnLocationWithCaster(this.TargetAoe, this.SoundSfx, this.Caster!);
            this.CreateParticle();

            const Targets = FindUnitsInRadius(this.Caster?.GetTeam()!, this.TargetAoe, undefined, this.GetAOERadius(), 
                                              this.GetAbilityTargetTeam(), this.GetAbilityTargetType(), this.GetAbilityTargetFlags(),
                                              FindOrder.ANY, false);
            for (const Iterator of Targets) 
            {
                ApplyDamage
                (
                    {
                        victim : Iterator,
                        attacker : this.Caster!,
                        damage : this.DmgPerSlash,
                        damage_type : this.GetAbilityDamageType(),
                        damage_flags : DamageFlag.NONE,
                        ability : this,
                    }
                )
            }

            ++this.SlashCount;
            const ModifierTengan = this.Caster?.FindModifierByName(musashi_modifier_tengan.name) as musashi_modifier_tengan;

            if (this.SlashCount == 5 && ModifierTengan)
            {
                for (const Iterator of Targets) 
                {
                    ApplyDamage
                    (
                        {
                            victim : Iterator,
                            attacker : this.Caster!,
                            damage : ModifierTengan.BonusDmg,
                            damage_type : DamageTypes.PURE,
                            damage_flags : DamageFlag.NO_SPELL_AMPLIFICATION,
                            ability : this,
                        }
                    )
                }

                ModifierTengan.Destroy();
            }

            this.Interval = 0;
        }

        this.Interval += interval;
    }

    override OnChannelFinish(interrupted: boolean): void
    {
        this.SlashCount = 0;
        this.Interval = 0;

        if (interrupted)
        {
            this.NiouSkill?.DestroyNiou(0);
        }
        else
        {
            this.NiouSkill?.DestroyNiou(1);
        }
    }

    CreateParticle() : void
    {
        if (this.Caster?.HasModifier("modifier_ascended"))
        {
            let AoeParticleStr = "";
            let CrackParticleStr = "";

            switch(this.SlashCount)
            {
                case 1:
                {
                    AoeParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_earth.vpcf";
                    CrackParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_earth_crack.vpcf";
                    break;
                }
                case 2:
                {
                    AoeParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_water.vpcf";
                    CrackParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_earth_crack.vpcf";
                    break;
                }
                case 3:
                {
                    AoeParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_fire.vpcf";
                    CrackParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_fire_crack.vpcf";
                    break;
                }
                case 4:
                {
                    AoeParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_wind.vpcf";
                    CrackParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_wind_crack.vpcf";
                    break;
                }
            }

            const AoeParticle = ParticleManager.CreateParticle(AoeParticleStr, ParticleAttachment.WORLDORIGIN, this.Caster);
            const CrackParticle = ParticleManager.CreateParticle(CrackParticleStr, ParticleAttachment.WORLDORIGIN, this.Caster);
            ParticleManager.SetParticleControl(AoeParticle, 0, this.TargetAoe);
            ParticleManager.SetParticleControl(AoeParticle, 1, Vector(0, 0, 0));
            ParticleManager.SetParticleControl(AoeParticle, 12, Vector(400, 0, 0));
            ParticleManager.SetParticleControl(CrackParticle, 0, this.TargetAoe);
        }
        else
        {
            const AoeParticle = ParticleManager.CreateParticle(this.BasicAoeParticle, ParticleAttachment.WORLDORIGIN, this.Caster);
            ParticleManager.SetParticleControl(AoeParticle, 0, this.TargetAoe);
            ParticleManager.SetParticleControl(AoeParticle, 1, Vector(1.5, 0, 0));
            ParticleManager.SetParticleControl(AoeParticle, 2, Vector(400, 0, 0));
        }
    }

    override OnUpgrade(): void
    {
        this.NiouSkill?.SetLevel(this.GetLevel());
    }

    override GetAOERadius(): number
    {
        return this.GetSpecialValueFor("Radius");
    }
}

//======================================================================================================================
// Miyamoto Musashi : Skill 7 : Niou (Auxiliary)
//======================================================================================================================
@registerAbility()
export class musashi_niou extends BaseAbility
{
    Caster : CDOTA_BaseNPC | undefined;
    Niou : CDOTA_BaseNPC | undefined;

    override OnSpellStart(): void
    {
        this.Caster = this.GetCaster();
        this.Niou = CreateUnitByName("musashi_niou", this.Caster.GetAbsOrigin(), false, this.Caster, this.Caster, this.Caster.GetTeam());
        const ModelScale = this.GetSpecialValueFor("ModelScale");
        this.Niou.SetModelScale(ModelScale);
        this.Niou.AddNewModifier(this.Niou, this, musashi_modifier_niou.name, {undefined});
    }

    async DestroyNiou(delay : number): Promise<void>
    {
        this.Niou?.ForceKill(false);
        Sleep(delay);
        this.Niou?.Destroy();
    }
}

@registerModifier()
export class musashi_modifier_niou extends BaseModifier
{
    override CheckState(): Partial<Record<ModifierState, boolean>>
    {
        const modifiertable = 
        {
            [ModifierState.INVULNERABLE] : true,
            [ModifierState.MAGIC_IMMUNE] : true,
            [ModifierState.UNTARGETABLE] : true,
            [ModifierState.UNSELECTABLE] : true,
            [ModifierState.NO_UNIT_COLLISION] : true,
            [ModifierState.NO_HEALTH_BAR] : true,
            [ModifierState.NOT_ON_MINIMAP] : true,
        }

        return modifiertable;
    }

    override IsHidden(): boolean
    {
        return true;
    }

    override IsPermanent(): boolean
    {
        return true;
    }

    override IsPurgable(): boolean
    {
        return false;
    }

    override IsPurgeException(): boolean
    {
        return false;
    }
}