import { BaseAbility, BaseModifier, registerAbility, registerModifier } from "../../tslib/dota_ts_adapter";
import { Sleep } from "../../tslib/sleep_timer";
import { BaseVectorAbility } from "../../tslib/vector_targeting_interface";
import "../../libraries/util"

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
    Ability : CDOTABaseAbility | undefined;

    BonusDmg : number = 0;
    BonusAtkSpeed : number = 0;

    override OnCreated(): void
    {
        this.Ability = this.GetAbility();
        this.BonusDmg = this.Ability?.GetSpecialValueFor("BonusDmg")!;
        this.BonusAtkSpeed = this.Ability?.GetSpecialValueFor("BonusAtkSpeed")!;

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
                                              Vector(0, 0, 0), true);

        ParticleManager.SetParticleControlEnt(RedOrbParticle, 1, this.Caster!, ParticleAttachment.POINT_FOLLOW, "attach_attack1",
                                              Vector(0, 0, 0), true);
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
    Ability : CDOTABaseAbility | undefined;
    
    BonusDmg : number = 0;

    override OnCreated(): void
    {
        if (!IsServer())
        {
            return;
        }

        this.Caster = this.GetCaster();
        this.Ability = this.GetAbility();
        this.BonusDmg = this.Ability?.GetSpecialValueFor("BonusDmg")!;
        this.CreateParticle();
    }

    override OnRefresh(): void
    {
        if (!IsServer())
        {
            return;
        }

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
                                                  "attach_hitloc", Vector(0, 0, 0), true);
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
            this.DoDamage();
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

    DoDamage(): void
    {
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
    }

    CreateParticle(): void
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
// Miyamoto Musashi : Skill 4 : Ganryuu Jima (R)
//======================================================================================================================
@registerAbility()
export class musashi_ganryuu_jima extends BaseAbility implements BaseVectorAbility
{
    readonly SoundVoiceline: string = "antimage_anti_ability_manavoid_01";
    
    Caster : CDOTA_BaseNPC | undefined;

    DashPosition : Vector = Vector(0, 0, 0);
    SlashPosition : Vector = Vector(0, 0, 0);
    SecondSlashPosition : Vector = Vector(0, 0, 0);

    OnVectorCastStart(vStartLocation: Vector, vDirection: Vector): void
    {
        this.Caster = this.GetCaster();
        this.SetVector(vStartLocation, vDirection);
        const DashCounter = this.Caster.AddNewModifier(this.Caster, this, musashi_modifier_ganryuu_jima.name, {undefined});
        DashCounter.IncrementStackCount();
        EmitGlobalSound(this.SoundVoiceline);
    }

    SetVector(vStartLocation : Vector, vDirection : Vector): void
    {
        this.DashPosition = vStartLocation;
        this.SlashPosition = vDirection;
        this.SecondSlashPosition = vDirection.__unm();
    }

    override GetCastRange(): number
    {
        if (IsServer())
        {
            return 0;
        }
        else
        {
            return this.GetSpecialValueFor("SlashRange");
        }
    }

    GetVectorTargetRange(): number
    {
        return this.GetSpecialValueFor("SlashRange");
    }

    GetVectorTargetStartRadius(): number
    {
        return this.GetSpecialValueFor("SlashRadius");
    }

    GetVectorTargetEndRadius(): number
    {
        return this.GetSpecialValueFor("SlashRadius");
    }

    GetVectorPosition(): Vector
    {
        return this.DashPosition;
    }

    GetVectorDirection(): Vector
    {
        return this.SlashPosition;
    }

    GetVector2Position(): Vector
    {
        return this.SlashPosition;
    }

    UpdateVectorValues(): void
    {
        
    }

    IsDualVectorDirection(): boolean
    {
        return false;
    }

    IgnoreVectorArrowWidth(): boolean
    {
        return false;
    }
}

@registerModifier()
export class musashi_modifier_ganryuu_jima extends BaseModifier
{
    Caster : CDOTA_BaseNPC | undefined;
    Ganryuu_Jima : musashi_ganryuu_jima | undefined; 

    DashPosition : Vector = Vector(0, 0, 0);
    SlashPosition : Vector = Vector(0, 0, 0);
    SecondSlashPosition : Vector = Vector(0, 0, 0);

    override OnCreated(): void
    {
        if (!IsServer())
        {
            return;
        }

        this.Caster = this.GetCaster();
        this.Ganryuu_Jima = this.GetAbility() as musashi_ganryuu_jima;
        this.DashPosition = this.Ganryuu_Jima.DashPosition;
        this.SlashPosition = this.Ganryuu_Jima.SlashPosition;
        this.SecondSlashPosition = this.Ganryuu_Jima.SecondSlashPosition;
        giveUnitDataDrivenModifier(this.Caster!, this.Caster!, "pause_sealdisabled", 1.5);
    }

    override OnStackCountChanged(stackCount: number): void
    {
        if (!IsServer())
        {
            return;
        }

        let Position = Vector(0, 0, 0);
        
        switch (stackCount)
        {
            case 0:
            {
                Position = this.DashPosition;
                const DashBuff = (this.Caster?.AddNewModifier(this.Caster, this.Ganryuu_Jima, musashi_modifier_ganryuu_jima_dash.name, 
                                 {undefined})) as musashi_modifier_ganryuu_jima_dash;
                DashBuff.TargetPoint = Position;
                DashBuff.TargetPoint.z = this.Caster?.GetAbsOrigin().z!;
                DashBuff.NormalizedTargetPoint = ((DashBuff.TargetPoint - this.Caster?.GetAbsOrigin()!) as Vector).Normalized();
                this.Caster?.StartGestureWithPlaybackRate(GameActivity.DOTA_CAST_ABILITY_1, 2.0);
                DashBuff.StartIntervalThink(0.03);
                break;
            }
            case 1:
            {
                Position = this.SlashPosition;
                break;
            }
            case 2:
            {
                Position = this.SecondSlashPosition;
                break;
            
            }
            case 3:
            {
                this.Destroy();
                break;
            }
        }

        if (stackCount == 1 || stackCount == 2)
        {
            const SlashBuff = (this.Caster?.AddNewModifier(this.Caster, this.Ganryuu_Jima, musashi_modifier_ganryuu_jima_slash.name,
                              {undefined})) as musashi_modifier_ganryuu_jima_slash;
            SlashBuff.TargetPoint = Position;
            this.Caster?.StartGestureWithPlaybackRate(GameActivity.DOTA_CAST_ABILITY_2, 2.0);
            SlashBuff.StartIntervalThink(0.03);
        }
    }

    override OnDestroy(): void
    {
        if (!IsServer())
        {
            return;
        }

        this.Caster?.RemoveGesture(GameActivity.DOTA_CAST_ABILITY_1);
        this.Caster?.RemoveGesture(GameActivity.DOTA_CAST_ABILITY_2);
        this.Caster?.StartGesture(GameActivity.DOTA_CAST_ABILITY_2_END);
        this.Caster?.SetForwardVector((this.Caster.GetForwardVector() * 10) as Vector);
        FindClearSpaceForUnit(this.Caster!, this.Caster?.GetAbsOrigin()!, true);
        this.Caster?.AddNewModifier(this.Caster, this.Ganryuu_Jima, "modifier_phase", {duration : 1.5});
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

@registerModifier()
export class musashi_modifier_ganryuu_jima_slash extends BaseModifier
{
    readonly SoundSfx : string = "musashi_ganryuu_jima_sfx";

    ParticleStr : string = "particles/custom/musashi/musashi_ganryuu_jima_basic.vpcf";

    Caster : CDOTA_BaseNPC | undefined;
    Ability : CDOTABaseAbility | undefined;

    StartPosition : Vector = Vector(0, 0, 0);
    EndPosition : Vector = Vector(0, 0, 0);
    TargetPoint : Vector = Vector(0, 0, 0);

    SlashRange : number = 0;
    UnitsTravelled : number = 0;

    override OnCreated(): void
    {
        if (!IsServer())
        {
            return;
        }

        this.Caster = this.GetCaster()!;
        this.Ability = this.GetAbility();
        this.StartPosition = this.Caster.GetAbsOrigin();
        this.SlashRange = this.Ability?.GetSpecialValueFor("SlashRange")!;
        this.Caster.EmitSound(this.SoundSfx);
    }

    override OnIntervalThink(): void
    {
        if (!IsServer())
        {
            return;
        }

        this.Caster?.SetForwardVector(this.TargetPoint);
        const CurrentOrigin = this.Caster?.GetAbsOrigin()!;
        const DashSpeed = this.Ability?.GetSpecialValueFor("DashSpeed")!;
        const NewPosition = (CurrentOrigin + (this.Caster?.GetForwardVector()! * DashSpeed)) as Vector;
        this.UnitsTravelled += ((NewPosition - CurrentOrigin) as Vector).Length2D();
        this.Caster?.SetAbsOrigin(NewPosition);

        if (this.UnitsTravelled >= this.SlashRange)
        {
            this.Destroy();
        }
    }

    override OnDestroy(): void
    {
        if (!IsServer())
        {
            return;
        }

        this.EndPosition = this.Caster?.GetAbsOrigin()!;
        this.CreateParticle();
        this.DoDamage();
        const DashCounter = this.Caster?.FindModifierByName(musashi_modifier_ganryuu_jima.name)!;
        DashCounter.IncrementStackCount();
    }

    DoDamage(): void
    {
        const Targets = FindUnitsInLine(this.Caster?.GetTeam()!, this.StartPosition, this.EndPosition, undefined, 
                                        this.Ability?.GetSpecialValueFor("SlashRadius")!, this.Ability?.GetAbilityTargetTeam()!,
                                        this.Ability?.GetAbilityTargetType()!, this.Ability?.GetAbilityTargetFlags()!);

        for (const Iterator of Targets) 
        {
            ApplyDamage
            (
                {
                    victim : Iterator,
                    attacker : this.Caster!,
                    damage : this.Ability?.GetSpecialValueFor("DmgPerSlash")!,
                    damage_type : DamageTypes.MAGICAL,
                    damage_flags : DamageFlag.NONE,
                    ability : this.Ability!,
                }
            )

            if (this.Caster?.HasModifier(musashi_modifier_tengan.name))
            {
                Iterator.AddNewModifier(this.Caster, this.Ability, musashi_modifier_ganryuu_jima_debuff.name, {duration : this.Ability?.GetSpecialValueFor("DmgDelay")})
            }
        }
    }

    CreateParticle(): void
    {
        if (this.Caster?.HasModifier("modifier_ascended"))
        {
            this.ParticleStr = "particles/custom/musashi/musashi_ganryuu_jima_unique.vpcf";
        }

        const ParticleId = ParticleManager.CreateParticle(this.ParticleStr, ParticleAttachment.WORLDORIGIN, this.Caster);
        ParticleManager.SetParticleControl(ParticleId, 0, this.StartPosition);
        ParticleManager.SetParticleControl(ParticleId, 1, this.EndPosition);
    }

    override CheckState(): Partial<Record<ModifierState, boolean>>
    {
        const ModifierTable = 
        {
            [ModifierState.INVULNERABLE] : true,
            [ModifierState.MAGIC_IMMUNE] : true,
            [ModifierState.UNTARGETABLE] : true,
            [ModifierState.UNSELECTABLE] : true,
            [ModifierState.NO_UNIT_COLLISION] : true,
            [ModifierState.NO_HEALTH_BAR] : true,
        }
        
        return ModifierTable;
    }

    override IsPurgable(): boolean
    {
        return false;
    }

    override IsPurgeException(): boolean
    {
        return false;
    }

    override IsHidden(): boolean
    {
        return true;
    }
}

@registerModifier()
export class musashi_modifier_ganryuu_jima_debuff extends BaseModifier
{
    ParticleStr : string = "particles/custom/musashi/musashi_ganryuu_jima_debuff_basic.vpcf";

    Caster : CDOTA_BaseNPC | undefined;
    Ability : CDOTABaseAbility | undefined;
    Victim : CDOTA_BaseNPC | undefined;

    override OnCreated(): void
    {
        if (!IsServer())
        {
            return;
        }

        this.Caster = this.GetCaster();
        this.Victim = this.GetParent();
        this.CreateParticle();
    }

    override OnRefresh(): void
    {
        if (!IsServer())
        {
            return;
        }

        this.OnCreated();
    }

    override OnDestroy(): void
    {
        if (!IsServer())
        {
            return;
        }

        this.DoDamage()
    }

    DoDamage(): void
    {
        const ModifierTengan = this.Caster?.FindModifierByName(musashi_modifier_tengan.name) as musashi_modifier_tengan;

        ApplyDamage
        (
            {
                victim : this.Victim!,
                attacker : this.Caster!,
                damage : ModifierTengan.BonusDmg,
                damage_type : DamageTypes.PURE,
                damage_flags : DamageFlag.NO_SPELL_AMPLIFICATION,
                ability : this.Ability!,
            }
        )
    }

    CreateParticle(): void
    {
        if (this.Caster?.HasModifier("modifier_ascended"))
        {
            this.ParticleStr = "particles/custom/musashi/musashi_ganryuu_jima_debuff_unique.vpcf";
        }

        const DebuffParticle = ParticleManager.CreateParticle(this.ParticleStr, ParticleAttachment.POINT_FOLLOW, this.Victim);
        this.AddParticle(DebuffParticle, false, false, -1, false, false);
    }

    override IsPurgable(): boolean
    {
        return false;
    }

    override IsPurgeException(): boolean
    {
        return false;
    }

    override IsDebuff(): boolean
    {
        return true;
    }
}

@registerModifier()
export class musashi_modifier_ganryuu_jima_dash extends BaseModifier
{
    StartPosition : Vector = Vector(0, 0, 0);
    TargetPoint : Vector = Vector(0, 0, 0);
    NormalizedTargetPoint : Vector = Vector(0, 0, 0);

    Caster : CDOTA_BaseNPC | undefined;
    Ability : CDOTABaseAbility | undefined;

    SlashRange : number = 0;
    UnitsTravelled : number = 0;

    override OnCreated(): void
    {
        if (!IsServer())
        {
            return;
        }
        
        this.Caster = this.GetCaster();
        this.Ability = this.GetAbility();
        this.StartPosition = this.Caster?.GetAbsOrigin()!;
        this.SlashRange = this.Ability?.GetSpecialValueFor("SlashRange")!;
    }

    override OnIntervalThink(): void
    {
        if (!IsServer())
        {
            return;
        }

        this.Caster?.SetForwardVector(this.NormalizedTargetPoint);
        const CurrentOrigin = this.Caster?.GetAbsOrigin()!;
        const DashSpeed = this.Ability?.GetSpecialValueFor("DashSpeed")!;
        const NewPosition = (CurrentOrigin + (this.Caster?.GetForwardVector()! * DashSpeed)) as Vector;
        this.UnitsTravelled += ((NewPosition - CurrentOrigin) as Vector).Length2D();
        this.Caster?.SetAbsOrigin(NewPosition);
        const Musashi = Entities.FindByNameWithin(undefined, this.Caster?.GetName()!, this.TargetPoint, DashSpeed);

        if (Musashi || this.UnitsTravelled >= this.SlashRange)
        {
            this.Destroy();
        }
    }

    override OnDestroy(): void
    {
        if (!IsServer())
        {
            return;
        }

        const DashCounter = this.Caster?.FindModifierByName(musashi_modifier_ganryuu_jima.name);
        DashCounter?.IncrementStackCount();
    }

    override IsPurgable(): boolean
    {
        return false;
    }

    override IsPurgeException(): boolean
    {
        return false;
    }

    override IsHidden(): boolean
    {
        return true;
    }
}

//======================================================================================================================
// Miyamoto Musashi : Skill 5 : Niou (Auxiliary)
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
        await Sleep(delay);
        this.Niou?.Destroy();
    }
}

@registerModifier()
export class musashi_modifier_niou extends BaseModifier
{
    override CheckState(): Partial<Record<ModifierState, boolean>>
    {
        const ModifierTable = 
        {
            [ModifierState.INVULNERABLE] : true,
            [ModifierState.MAGIC_IMMUNE] : true,
            [ModifierState.UNTARGETABLE] : true,
            [ModifierState.UNSELECTABLE] : true,
            [ModifierState.NO_UNIT_COLLISION] : true,
            [ModifierState.NO_HEALTH_BAR] : true,
            [ModifierState.NOT_ON_MINIMAP] : true,
        }

        return ModifierTable;
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

//======================================================================================================================
// Miyamoto Musashi : Skill 6 : Tengen No Hana (SA)
//======================================================================================================================
@registerAbility()
export class musashi_tengen_no_hana extends BaseAbility
{
    override OnSpellStart(): void
    {
        const TengenNoHana = this.GetCaster()?.FindModifierByName(musashi_modifier_tengen_no_hana.name);
        const BuffDuration = this.GetSpecialValueFor("BuffDuration");

        if (TengenNoHana)
        {
            TengenNoHana.Destroy();
            return;
        }

        this.GetCaster()?.AddNewModifier(this.GetCaster(), this, musashi_modifier_tengen_no_hana.name, {duration : BuffDuration});
    }
}

@registerModifier()
export class musashi_modifier_tengen_no_hana extends BaseModifier
{
    readonly SoundVoiceline : string = "antimage_anti_ability_manavoid_02";
    readonly SoundSfx : string = "musashi_tengen_no_hana_sfx";

    OverheadParticleStr : string = "particles/custom/musashi/musashi_tengen_no_hana_basic.vpcf";
    AoeParticleStr : string = "particles/custom/musashi/musashi_tengen_no_hana_aoe_basic.vpcf";
    AoeMarkerParticleStr : string = "particles/custom/musashi/musashi_tengen_no_hana_aoemarker_basic.vpcf";
    
    Caster : CDOTA_BaseNPC | undefined;
    Ability : CDOTABaseAbility | undefined;
    DmgOutputPercentage : number = 0;
    Radius : number = 0;

    override OnCreated(): void
    {
        if (!IsServer())
        {
            return;
        }
        
        this.Caster = this.GetCaster();
        this.Ability = this.GetAbility();
        this.Radius = this.Ability?.GetSpecialValueFor("Radius")!;
        this.CreateParticle();
        this.Caster?.EmitSound(this.SoundSfx);
        this.StartIntervalThink(1);
    }

    override OnIntervalThink(): void
    {
        if (!IsServer())
        {
            return;
        }

        this.IncrementStackCount();
    }

    override OnStackCountChanged(stackCount: number): void
    {
        if (!IsServer())
        {
            return;
        }

        switch (stackCount)
        {
            case 0:
            {
                this.DmgOutputPercentage = 0.25;
                break;
            }
            case 1:
            {
                this.DmgOutputPercentage = 0.5;
                break;
            }
            case 2:
            {
                this.DmgOutputPercentage = 1.0;
                this.Destroy();
                break;
            }
        }
    }

    override OnDestroy(): void
    {
        if (!IsServer())
        {
            return;
        }

        this.Caster?.StartGesture(GameActivity.DOTA_CAST_ABILITY_2_END);
        EmitGlobalSound(this.SoundVoiceline);
        this.CreateAoeParticle();
        this.DoDamage();
        this.Caster?.SwapAbilities(musashi_tengen_no_hana.name, musashi_mukyuu.name, false, true);
    }

    DoDamage(): void
    {
        const Targets = FindUnitsInRadius(this.Caster?.GetTeam()!, this.Caster?.GetAbsOrigin()!, undefined, this.Radius,
                                          this.Ability?.GetAbilityTargetTeam()!, this.Ability?.GetAbilityTargetType()!, 
                                          this.Ability?.GetAbilityTargetFlags()!, FindOrder.ANY, false);
        for (const Iterator of Targets) 
        {
            ApplyDamage
            (
                {
                    victim : Iterator,
                    attacker : this.Caster!,
                    damage : this.Ability?.GetSpecialValueFor("Dmg")! * this.DmgOutputPercentage,
                    damage_type : DamageTypes.PURE,
                    damage_flags : DamageFlag.NO_SPELL_AMPLIFICATION,
                    ability : this.Ability!,
                }
            )   
        }
    }

    CreateParticle(): void
    {
        if (this.Caster?.HasModifier("modifier_ascended"))
        {
            this.OverheadParticleStr = "particles/custom/musashi/musashi_tengen_no_hana_unique1.vpcf";
        }

        const OverheadParticle = ParticleManager.CreateParticle(this.OverheadParticleStr, ParticleAttachment.OVERHEAD_FOLLOW, this.Caster);
        this.AddParticle(OverheadParticle, false, false, -1, false, false);
    }

    CreateAoeParticle(): void
    {
        if (this.Caster?.HasModifier("modifier_ascended"))
        {
            this.AoeParticleStr = "particles/custom/musashi/musashi_tengen_no_hana_aoe_unique1.vpcf";
            this.AoeMarkerParticleStr = "particles/custom/musashi/musashi_tengen_no_hana_aoemarker_unique1.vpcf"
        }

        const AoeParticle = ParticleManager.CreateParticle(this.AoeParticleStr, ParticleAttachment.WORLDORIGIN, this.Caster);
        const AoeMarkerParticle = ParticleManager.CreateParticle(this.AoeMarkerParticleStr, ParticleAttachment.WORLDORIGIN, this.Caster);
        ParticleManager.SetParticleControl(AoeParticle, 0, this.Caster?.GetAbsOrigin()!);
        ParticleManager.SetParticleControl(AoeParticle, 2, Vector(this.Radius, this.Radius, this.Radius));
        ParticleManager.SetParticleControl(AoeMarkerParticle, 2, Vector(this.Radius, this.Radius, this.Radius));
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
// Miyamoto Musashi : Skill 7 : Mukyuu (SA)
//======================================================================================================================
@registerAbility()
export class musashi_mukyuu extends BaseAbility
{
    readonly SoundVoiceline : string = "antimage_anti_ability_manavoid_03";
    readonly SoundSfx : string = "musashi_mukyuu_sfx";

    Caster : CDOTA_BaseNPC | undefined;

    override OnSpellStart(): void
    {
        const BuffDuration = this.GetSpecialValueFor("BuffDuration");
        this.Caster = this.GetCaster();
        this.Caster.AddNewModifier(this.Caster, this, musashi_modifier_mukyuu.name, {duration : BuffDuration});
        
        this.PlaySound();
        this.Caster.AddNewModifier(this.Caster, this, musashi_mukyuu_slot_checker.name, {duration : 10});
        this.Caster.SwapAbilities(musashi_mukyuu.name, musashi_tengen_no_hana.name, false, true);
    }

    PlaySound(): void
    {
        this.Caster?.EmitSound(this.SoundVoiceline);
        this.Caster?.EmitSound(this.SoundSfx);
    }
}

@registerModifier()
export class musashi_modifier_mukyuu extends BaseModifier
{
    ParticleStr : string = "particles/custom/musashi/musashi_mukyuu_basic.vpcf";
    
    Caster : CDOTA_BaseNPC | undefined;
    Ability : CDOTABaseAbility | undefined;

    override OnCreated(): void
    {
        if (!IsServer())
        {
            return;
        }

        this.Caster = this.GetCaster();
        this.Ability = this.GetAbility();
        this.CreateParticle();
    }

    override async OnDestroy(): Promise<void>
    {
        if (!IsServer())
        {
            return;
        }

        await Sleep(5);
        this.Caster?.SwapAbilities(musashi_mukyuu.name, musashi_tengen_no_hana.name, true, false);
    }

    CreateParticle(): void
    {
        if (this.Caster?.HasModifier("modifier_ascended"))
        {
            this.ParticleStr = "particles/custom/musashi/musashi_mukyuu_unique.vpcf"
            const ParticleId = ParticleManager.CreateParticle(this.ParticleStr, ParticleAttachment.POINT_FOLLOW, this.Caster);
            ParticleManager.SetParticleControlEnt(ParticleId, 1, this.Caster!, ParticleAttachment.POINT_FOLLOW, "attach_hitloc", 
                                                  Vector(0, 0, 0), true);
            this.AddParticle(ParticleId, false, false, -1, false, false);
        }
        else
        {
            const ParticleId = ParticleManager.CreateParticle(this.ParticleStr, ParticleAttachment.POINT_FOLLOW, this.Caster);
            ParticleManager.SetParticleControlEnt(ParticleId, 0, this.Caster!, ParticleAttachment.POINT_FOLLOW, "attach_hitloc", 
                                                  Vector(0, 0, 0), true);
            ParticleManager.SetParticleControl(ParticleId, 1, Vector(150, 0, 0));
            this.AddParticle(ParticleId, false, false, -1, false, false);
        }        
    }

    override CheckState(): Partial<Record<ModifierState, boolean>>
    {
        const ModifierTable = 
        {
            [ModifierState.INVULNERABLE] : true,
            [ModifierState.MAGIC_IMMUNE] : true,
        }

        return ModifierTable;
    }

    override DeclareFunctions(): ModifierFunction[]
    {
        return [ModifierFunction.ABSOLUTE_NO_DAMAGE_PURE];
    }

    override GetAbsoluteNoDamagePure(): 0 | 1
    {
        return 1;
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

@registerModifier()
export class musashi_mukyuu_slot_checker extends BaseModifier
{
    MukyuuIndex : number = 0;

    override OnCreated(): void
    {
        if (!IsServer())
        {
            return;
        }

        this.MukyuuIndex = this.GetAbility()?.GetAbilityIndex()!;
    }

    override OnDestroy(): void
    {
        if (!IsServer())
        {
            return;
        }

        const MukyuuCurrentIndex = this.GetCaster()?.FindAbilityByName(musashi_mukyuu.name)?.GetAbilityIndex();

        if (MukyuuCurrentIndex != this.MukyuuIndex)
        {
            this.GetCaster()?.SwapAbilities(musashi_mukyuu.name, musashi_tengen_no_hana.name, true, false);
        }
    }

    override IsPurgable(): boolean
    {
        return false;
    }

    override IsPurgeException(): boolean
    {
        return false;
    }

    override IsHidden(): boolean
    {
        return true;
    }
}

//======================================================================================================================
// Miyamoto Musashi : Skill 8 : Battle Continuation (SA)
//======================================================================================================================
@registerAbility()
export class musashi_battle_continuation extends BaseAbility
{
    override GetIntrinsicModifierName(): string
    {
        return musashi_modifier_battle_continuation.name;
    }
}

@registerModifier()
export class musashi_modifier_battle_continuation extends BaseModifier
{
    Caster : CDOTA_BaseNPC | undefined;
    Ability : CDOTABaseAbility | undefined;

    override OnCreated(): void
    {
        if (!IsServer())
        {
            return;
        }

        this.Caster = this.GetCaster();
        this.Ability = this.GetAbility();
    }

    override OnTakeDamage(): void
    {
        if (!IsServer())
        {
            return;
        }

        if (this.Caster?.GetHealth()! <= 0 && this.Ability?.IsCooldownReady())
        {
            
            const BuffDuration = this.Ability?.GetSpecialValueFor("BuffDuration");
            this.Caster?.SetHealth(1);
            this.Caster?.AddNewModifier(this.Caster, this.Ability, musashi_modifier_battle_continuation_active.name, {duration : BuffDuration});
            this.Ability.UseResources(true, false, true);
        }
    }

    override DeclareFunctions(): ModifierFunction[]
    {
        return [ModifierFunction.ON_TAKEDAMAGE];
    }

    override IsPurgable(): boolean
    {
        return false;
    }

    override IsPurgeException(): boolean
    {
        return false;
    }

    override IsHidden(): boolean
    {
        return true;
    }
}

@registerModifier()
export class musashi_modifier_battle_continuation_active extends BaseModifier
{
    readonly SoundVoiceline : string = "antimage_anti_ability_manavoid_04";
    readonly SoundSfx : string = "musashi_battle_continuation_sfx";

    ParticleStr : string = "particles/custom/musashi/musashi_battle_continuation_basic.vpcf";

    Caster : CDOTA_BaseNPC | undefined;
    Ability : CDOTABaseAbility | undefined;

    override OnCreated(): void
    {
        if (!IsServer())
        {
            return;
        }

        this.Caster = this.GetCaster();
        this.Ability = this.GetAbility();
        this.Caster?.Purge(false, true, false, true, false);
        this.PlaySound();
        this.CreateParticle();
    }

    override OnDestroy(): void
    {
        if (!IsServer())
        {
            return;
        }

        this.Caster?.Heal(this.Ability?.GetSpecialValueFor("Heal")!, this.Ability);
    }

    PlaySound(): void
    {
        this.Caster?.EmitSound(this.SoundVoiceline);
        this.Caster?.EmitSound(this.SoundSfx);
    }

    CreateParticle(): void
    {
        if (this.Caster?.HasModifier("modifier_ascended"))
        {
            this.ParticleStr = "particles/custom/musashi/musashi_battle_continuation_unique.vpcf";
        }

        const ParticleId = ParticleManager.CreateParticle(this.ParticleStr, ParticleAttachment.POINT_FOLLOW, this.Caster);
        ParticleManager.SetParticleControlEnt(ParticleId, 5, this.Caster!, ParticleAttachment.POINT_FOLLOW, "attach_hitloc", 
                                              Vector(0, 0, 0), true);
        this.AddParticle(ParticleId, false, false, -1, false, false);
    }

    override DeclareFunctions(): ModifierFunction[]
    {
        return [ModifierFunction.MIN_HEALTH];
    }

    override GetMinHealth(): number
    {
        return 1;
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
