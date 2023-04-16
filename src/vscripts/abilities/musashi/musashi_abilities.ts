/** @noSelfInFile **/

import { BaseAbility, BaseModifier, registerAbility, registerModifier} from "@libs/dota_ts_adapter";
import { CheckComboStatsFulfilled, InitComboSequenceChecker, InitSkillSlotChecker } from "@libs/skill_utils";
import { Sleep } from "@libs/sleep_timer";
import { BaseVectorAbility } from "@libs/vector_targeting_interface";

//======================================================================================================================
// Miyamoto Musashi: Skill 1: Accel Turn (Q)
//======================================================================================================================
@registerAbility()
export class musashi_accel_turn extends BaseAbility
{
    readonly SoundVoiceline: string = "antimage_anti_ability_manavoid_07";
    readonly SoundSfx: string = "musashi_accel_turn_sfx";

    Caster: CDOTA_BaseNPC | undefined;

    Damage: number = 0;
    DmgType: DamageTypes | undefined;
    DmgFlag: DamageFlag | undefined;

    override OnSpellStart(): void
    {
        this.Caster = this.GetCaster();
        this.Caster.AddNewModifier(this.Caster, this, musashi_modifier_accel_turn.name, {undefined});
        this.SetDamageParameters();
        this.CreateProjectile();
        this.PlaySound();
    }

    SetDamageParameters(): void
    {
        this.Damage = this.GetSpecialValueFor("Damage");
        this.DmgType = this.GetAbilityDamageType();
        this.DmgFlag = DamageFlag.NONE;
    }

    CreateProjectile(): void
    {
        let ParticleStr = "particles/custom/musashi/musashi_accel_turn_basic.vpcf";

        if (this.Caster?.HasModifier("modifier_ascended"))
        {
            ParticleStr = "particles/custom/musashi/musashi_accel_turn_unique.vpcf";
        }

        const Direction = this.Caster?.GetForwardVector().__unm()!;

        ProjectileManager.CreateLinearProjectile
        (
            {
                EffectName: ParticleStr,
                Ability: this,
                Source: this.Caster!,
                vSpawnOrigin: this.Caster?.GetAbsOrigin()!,
                vVelocity: (Direction * this.GetSpecialValueFor("ProjectileSpeed")) as Vector,
                fDistance: this.GetSpecialValueFor("Range"),
                fStartRadius: this.GetSpecialValueFor("ProjectileRadius"),
                fEndRadius: this.GetSpecialValueFor("ProjectileRadius"),
                iUnitTargetTeam: this.GetAbilityTargetTeam(),
                iUnitTargetFlags: this.GetAbilityTargetFlags(),
                iUnitTargetType: this.GetAbilityTargetType(),
            }
        )
    }
    
    override OnProjectileHit(target: CDOTA_BaseNPC): boolean | void
    {
        if (!IsServer())
        {
            return;
        }

        DoDamage(this.Caster!, target, this.Damage, this.DmgType!, this.DmgFlag!, this, false);
    }

    PlaySound(): void
    {
        this.Caster?.EmitSound(this.SoundVoiceline);
        this.Caster?.EmitSound(this.SoundSfx);
    }

    override GetCastRange(): number
    {
        if (IsServer())
        {
            return 0;
        }
        else
        {
            return this.GetSpecialValueFor("Range");
        }
    }
}

@registerModifier()
export class musashi_modifier_accel_turn extends BaseModifier
{
    Caster: CDOTA_BaseNPC | undefined;
    Ability: CDOTABaseAbility | undefined;

    Direction: Vector = Vector(0, 0, 0);
    UnitsTravelled: number = 0;
    DashRange: number = 0;
    DashSpeed: number = 0;

    override OnCreated(): void
    {
        if (!IsServer())
        {
            return;
        }

        this.Caster = this.GetCaster()!;
        this.Ability = this.GetAbility();
        this.Direction = this.Ability?.GetForwardVector().__unm()!;
        this.DashRange = this.Ability?.GetSpecialValueFor("Range")!;
        this.DashSpeed = this.Ability?.GetSpecialValueFor("DashSpeed")!;
        ProjectileManager.ProjectileDodge(this.Caster);
        this.StartIntervalThink(0.03);
    }

    override OnIntervalThink(): void
    {
        if (!IsServer())
        {
            return;
        }

        this.Caster?.SetForwardVector(this.Direction);
        const CurrentOrigin = this.Caster?.GetAbsOrigin()!;
        const NewPosition = (CurrentOrigin + (this.Caster?.GetForwardVector()! * this.DashSpeed)) as Vector;
        this.UnitsTravelled += ((NewPosition - CurrentOrigin) as Vector).Length2D();
        this.Caster?.SetAbsOrigin(NewPosition);

        if (this.UnitsTravelled >= this.DashRange)
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

        this.Caster?.SetForwardVector(this.Caster.GetAbsOrigin().Normalized());
        FindClearSpaceForUnit(this.Caster!, this.Caster?.GetAbsOrigin()!, true);
    }

    override DeclareFunctions(): ModifierFunction[]
    {
        return [ModifierFunction.OVERRIDE_ANIMATION, ModifierFunction.OVERRIDE_ANIMATION_RATE];
    }

    override GetOverrideAnimation(): GameActivity
    {
        return GameActivity.DOTA_OVERRIDE_ABILITY_1;
    }

    override GetOverrideAnimationRate(): number
    {
        return 2;
    }

    override CheckState(): Partial<Record<ModifierState, boolean>>
    {
        const ModifierTable = 
        {
            [ModifierState.FLYING_FOR_PATHING_PURPOSES_ONLY]: true,
            [ModifierState.COMMAND_RESTRICTED]: true,
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
}

//======================================================================================================================
// Miyamoto Musashi: Skill 2: Dai Go Sei (W)
//======================================================================================================================
@registerAbility()
export class musashi_dai_go_sei extends BaseAbility
{
    readonly SoundVoiceline: string = "antimage_anti_cast_01";
    readonly SoundSfx: string = "musashi_dai_go_sei_sfx";

    Caster: CDOTA_BaseNPC | undefined;
    Victim: CDOTA_BaseNPC | undefined;

    override OnSpellStart(): void
    {
        this.Caster = this.GetCaster();
        this.Victim = this.GetCursorTarget()!;
        const BuffDuration = this.GetSpecialValueFor("BuffDuration");
        const StunDuration = this.GetSpecialValueFor("StunDuration");
        this.Caster?.AddNewModifier(this.Caster, this, musashi_modifier_dai_go_sei.name, {duration: BuffDuration});
        this.Caster?.SetAbsOrigin(this.Victim?.GetAbsOrigin());
        FindClearSpaceForUnit(this.Caster!, this.Caster?.GetAbsOrigin()!, true);
        this.Victim.AddNewModifier(this.Caster, this, "modifier_stunned", {duration: StunDuration});
        this.DealDamage();
        this.PlaySound();
    }

    DealDamage(): void
    {
        const Damage = this.GetSpecialValueFor("Damage");
        const Radius = this.GetSpecialValueFor("Radius");
        let DmgType = DamageTypes.MAGICAL;
        let DmgFlag = DamageFlag.NONE;
        const Targets = FindUnitsInRadius(this.Caster?.GetTeam()!, this.Victim?.GetAbsOrigin()!, undefined, Radius, 
                                          this.GetAbilityTargetTeam(), this.GetAbilityTargetType(), this.GetAbilityTargetFlags(), 
                                          FindOrder.ANY, false);

        if (this.Victim?.IsHero() && this.Victim.IsRealHero())
        {
            DmgType = DamageTypes.PURE;
            DmgFlag = DamageFlag.NO_SPELL_AMPLIFICATION;
        }

        for (const Iterator of Targets) 
        {
            DoDamage(this.Caster!, Iterator, Damage, DmgType, DmgFlag, this, false);    
        }
    }

    PlaySound(): void
    {
        this.Caster?.EmitSound(this.SoundVoiceline);
        this.Caster?.EmitSound(this.SoundSfx);
    }

    override GetIntrinsicModifierName(): string
    {
        return musashi_modifier_dai_go_sei_hits_counter.name;
    }
}

@registerModifier()
export class musashi_modifier_dai_go_sei_hits_counter extends BaseModifier
{
    Caster: CDOTA_BaseNPC | undefined;
    Ability: CDOTABaseAbility | undefined;

    HitsRequired: number = 0;

    override OnCreated(): void
    {
        if (!IsServer())
        {
            return;
        }

        this.Caster = this.GetCaster();
        this.Ability = this.GetAbility();
        this.HitsRequired = this.Ability?.GetSpecialValueFor("HitsRequired")!;
    }

    override OnRefresh(): void
    {
        if (!IsServer())
        {
            return;
        }

        this.OnCreated();
    }

    override OnAttackLanded(event: ModifierAttackEvent): void
    {
        if (!IsServer() || event.attacker !== this.Caster)
        {
            return;
        }

        if (event.target.IsHero() && event.target.IsRealHero())
        {
            if (this.GetStackCount() < this.HitsRequired)
            {
                this.IncrementStackCount();
            }
        }
    }

    override OnStackCountChanged(stackCount: number): void
    {
        if (!IsServer())
        {
            return;
        }

        if (stackCount === this.HitsRequired - 1)
        {
            InitSkillSlotChecker(this.Caster!, musashi_dai_go_sei.name, musashi_dai_go_sei_wave.name, 5);
            this.SetStackCount(0);
        }
    }

    override DeclareFunctions(): ModifierFunction[]
    {
        return [ModifierFunction.ON_ATTACK_LANDED];
    }

    override IsPurgable(): boolean
    {
        return false;
    }

    override IsPurgeException(): boolean
    {
        return false;
    }

    override IsPermanent(): boolean
    {
        return true;
    }

    override IsHidden(): boolean
    {
        if (this.GetStackCount() === 0)
        {
            return true;
        }

        return false;
    }
}

@registerModifier()
export class musashi_modifier_dai_go_sei extends BaseModifier
{
    Caster: CDOTA_BaseNPC | undefined;
    Ability: CDOTABaseAbility | undefined;

    BonusAtkDmg!: number;
    BonusAtkSpeed!: number;

    override OnCreated(): void
    {
        if (!IsServer())
        {
            return;
        }

        this.Caster = this.GetCaster();
        this.Ability = this.GetAbility();
        this.BonusAtkDmg = this.Ability?.GetSpecialValueFor("BonusAtkDmg")!;
        this.BonusAtkSpeed = this.Ability?.GetSpecialValueFor("BonusAtkSpeed")!;
        const ModifierTengan = this.Caster?.FindModifierByName(musashi_modifier_tengan.name) as musashi_modifier_tengan;
        this.BonusAtkDmg += ModifierTengan?.TenganBonus ?? 0;
        this.BonusAtkSpeed += ModifierTengan?.TenganBonus ?? 0;
        this.SetHasCustomTransmitterData(true);
        this.CreateParticle();
    }

    override OnRefresh(): void
    {
        if (!IsServer())
        {
            return;
        }

        this.OnCreated();
        this.SendBuffRefreshToClients();
    }
    
    AddCustomTransmitterData()
    {
        const data = 
        {
            BonusDmg: this.BonusAtkDmg, 
            BonusAtkSpeed: this.BonusAtkSpeed,
        };
        
        return data;
    }

    HandleCustomTransmitterData(data: ReturnType<this["AddCustomTransmitterData"]>): void
    {
        this.BonusAtkDmg = data.BonusDmg;
        this.BonusAtkSpeed = data.BonusAtkSpeed;
    }

    CreateParticle(): void
    {
        let ParticleStr = "particles/custom/musashi/musashi_dai_go_sei_basic.vpcf";
        let BlueOrbParticleStr = "particles/custom/musashi/musashi_dai_go_sei_blueorb_basic.vpcf";
        let RedOrbParticleStr = "particles/custom/musashi/musashi_dai_go_sei_redorb_basic.vpcf";

        if (this.Caster?.HasModifier("modifier_ascended"))
        {
            ParticleStr = "particles/custom/musashi/musashi_dai_go_sei_unique.vpcf";
            BlueOrbParticleStr = "particles/custom/musashi/musashi_dai_go_sei_blueorb_unique.vpcf";
            RedOrbParticleStr = "particles/custom/musashi/musashi_dai_go_sei_redorb_unique.vpcf";
        }

        const Particle = ParticleManager.CreateParticle(ParticleStr, ParticleAttachment.OVERHEAD_FOLLOW, this.Caster);
        const BlueOrbParticle = ParticleManager.CreateParticle(BlueOrbParticleStr, ParticleAttachment.POINT_FOLLOW, this.Caster);
        const RedOrbParticle = ParticleManager.CreateParticle(RedOrbParticleStr, ParticleAttachment.POINT_FOLLOW, this.Caster);
        ParticleManager.SetParticleControlEnt(BlueOrbParticle, 1, this.Caster!, ParticleAttachment.POINT_FOLLOW, "attach_attack2",
                                              Vector(0, 0, 0), false);
        ParticleManager.SetParticleControlEnt(RedOrbParticle, 1, this.Caster!, ParticleAttachment.POINT_FOLLOW, "attach_attack1",
                                              Vector(0, 0, 0), false);

        this.AddParticle(Particle, false, false, -1, false, false);
        this.AddParticle(BlueOrbParticle, false, false, -1, false, false);
        this.AddParticle(RedOrbParticle, false, false, -1, false, false);
    }
    
    override DeclareFunctions(): ModifierFunction[]
    {
        return [ModifierFunction.PREATTACK_BONUS_DAMAGE, ModifierFunction.ATTACKSPEED_BONUS_CONSTANT];
    }

    override GetModifierPreAttack_BonusDamage(): number
    {
        return this.BonusAtkDmg;
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
// Miyamoto Musashi: Skill 3: Niou Kurikara (E)
//======================================================================================================================
@registerAbility()
export class musashi_niou_kurikara extends BaseAbility
{
    readonly SoundVoiceline: string = "antimage_anti_cast_03";

    Caster: CDOTA_BaseNPC | undefined;
    NiouSkill: musashi_niou | undefined;
    Niou: CDOTA_BaseNPC | undefined;

    Interval: number = 0;
    SlashCount: number = 0;

    override OnAbilityPhaseStart(): boolean
    {
        this.Caster = this.GetCaster();
        this.NiouSkill = this.Caster.FindAbilityByName(musashi_niou.name) as musashi_niou;
        this.Caster.CastAbilityImmediately(this.NiouSkill, this.Caster.GetEntityIndex());
        this.Niou = this.NiouSkill.Niou;
        this.Niou?.FaceTowards(this.GetCursorPosition());
        return true;
    }

    override OnAbilityPhaseInterrupted(): void
    {
        this.NiouSkill?.DestroyNiou(0);
    }

    override OnSpellStart(): void
    {
        this.Caster?.AddNewModifier(this.Caster, this, musashi_modifier_niou_kurikara_slashing.name, {duration: 1.5});
        this.Niou?.StartGestureWithPlaybackRate(GameActivity.DOTA_CHANNEL_ABILITY_1, 1.1);

        if (!this.Caster?.HasModifier(musashi_modifier_ishana_daitenshou.name))
        {
            this.Caster?.EmitSound(this.SoundVoiceline);
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

@registerModifier()
export class musashi_modifier_niou_kurikara_slashing extends BaseModifier
{
    readonly SoundSfx: string = "musashi_niou_kurikara_sfx";

    Caster: CDOTA_BaseNPC | undefined;
    Ability: CDOTABaseAbility | undefined;

    TargetPoint: Vector = Vector(0, 0, 0);
    SlashCount: number = 0;

    override OnCreated(): void
    {
        if (!IsServer())
        {
            return;
        }

        this.Caster = this.GetCaster();
        this.Ability = this.GetAbility();
        this.TargetPoint = this.Ability?.GetCursorPosition()!;
        giveUnitDataDrivenModifier(this.Caster!, this.Caster!, "pause_sealdisabled", 1.5);
        this.IncrementStackCount();
        this.StartIntervalThink(0.5);
    }

    override OnIntervalThink(): void
    {
        if (!IsServer())
        {
            return;
        }

        this.IncrementStackCount();
    }

    override OnStackCountChanged(): void
    {
        if (!IsServer())
        {
            return;
        }

        this.DealDamage();
        this.CreateParticle();
        EmitSoundOnLocationWithCaster(this.TargetPoint, this.SoundSfx, this.Caster!);
    }

    override OnDestroy(): void
    {
        if (!IsServer())
        {
            return;
        }

        const NiouSkill = this.Caster?.FindAbilityByName(musashi_niou.name) as musashi_niou;
        NiouSkill.DestroyNiou(1);
        const BuffDuration = this.Ability?.GetSpecialValueFor("BuffDuration");
        this.Caster?.AddNewModifier(this.Caster, this.Ability, musashi_modifier_niou_kurikara_postslashing_buff.name, {duration: BuffDuration});
        const ModifierIshanaDaitenshou = this.Caster?.FindModifierByName(musashi_modifier_ishana_daitenshou.name);
        ModifierIshanaDaitenshou?.IncrementStackCount();
    }

    DealDamage(): void
    {
        ++this.SlashCount;
        const Damage = this.Ability?.GetSpecialValueFor("DmgPerSlash")!;
        let DmgType = this.Ability?.GetAbilityDamageType()!;
        let TargetFlags = this.Ability?.GetAbilityTargetFlags()!;
        let DmgFlag = DamageFlag.NONE;
        let Targets;

        if (this.Caster?.HasModifier(musashi_modifier_tenma_gogan.name) || this.Caster?.HasModifier(musashi_modifier_ishana_daitenshou.name))
        {
            DmgType = DamageTypes.PURE;
            DmgFlag = DamageFlag.NO_SPELL_AMPLIFICATION + DamageFlag.BYPASSES_INVULNERABILITY + DamageFlag.HPLOSS;
            TargetFlags = UnitTargetFlags.MAGIC_IMMUNE_ENEMIES;
        }

        const HasGorinNoSho = this.Caster?.HasModifier("musashi_attribute_gorin_no_sho");
        Targets = FindUnitsInRadius(this.Caster?.GetTeam()!, this.TargetPoint, undefined, this.Ability?.GetAOERadius()!, 
                                    this.Ability?.GetAbilityTargetTeam()!, this.Ability?.GetAbilityTargetType()!, TargetFlags,
                                    FindOrder.ANY, false);

        for (const Iterator of Targets) 
        {
            if (HasGorinNoSho)
            {
                this.ApplyElementalDebuffs(Iterator);
            }
            
            DoDamage(this.Caster!, Iterator, Damage, DmgType, DmgFlag, this.Ability!, false);
        }

        const ModifierTengan = this.Caster?.FindModifierByName(musashi_modifier_tengan.name) as musashi_modifier_tengan;

        if (this.SlashCount === 4 && ModifierTengan)
        { 
            DmgType = DamageTypes.PURE;
            DmgFlag = DamageFlag.NO_SPELL_AMPLIFICATION;
            TargetFlags = UnitTargetFlags.MAGIC_IMMUNE_ENEMIES;
            Targets = FindUnitsInRadius(this.Caster?.GetTeam()!, this.TargetPoint, undefined, this.Ability?.GetAOERadius()!, 
                                        this.Ability?.GetAbilityTargetTeam()!, this.Ability?.GetAbilityTargetType()!, TargetFlags,
                                        FindOrder.ANY, false);

            for (const Iterator of Targets) 
            {
                DoDamage(this.Caster!, Iterator, ModifierTengan.BonusDmg, DmgType, DmgFlag, this.Ability!, false);
            }

            const ModifierTenmaGogan = this.Caster?.FindModifierByName(musashi_modifier_tenma_gogan.name);
            ModifierTengan.Destroy();
            ModifierTenmaGogan?.Destroy();
        }
    }

    ApplyElementalDebuffs(Target: CDOTA_BaseNPC): void
    {
        const GorinNoSho = this.Caster?.FindModifierByName("musashi_attribute_gorin_no_sho");
        const AttributeAbility = GorinNoSho?.GetAbility();

        switch(this.SlashCount)
        {
            case 1: //earth
            {   
                const DebuffDuration = AttributeAbility?.GetSpecialValueFor("DebuffDuration");
                Target.AddNewModifier(this.Caster, AttributeAbility, musashi_modifier_earth_debuff.name, {duration: DebuffDuration});
                break;
            }
            case 2: //water
            {
                const DebuffDuration = AttributeAbility?.GetSpecialValueFor("DebuffDuration");
                Target.AddNewModifier(this.Caster, AttributeAbility, musashi_modifier_water_debuff.name, {duration: DebuffDuration});
                break;
            }
            case 3: //fire
            {
                const DebuffDuration = AttributeAbility?.GetSpecialValueFor("FireBurnDuration");
                Target.AddNewModifier(this.Caster, AttributeAbility, musashi_modifier_fire_debuff.name, {duration: DebuffDuration});
                break;
            }
            case 4: //wind
            {
                const DebuffDuration = AttributeAbility?.GetSpecialValueFor("WindDuration");
                Target.AddNewModifier(this.Caster, AttributeAbility, musashi_modifier_wind_debuff.name, {duration: DebuffDuration});
                break;
            }
        }
    }

    CreateParticle(): void
    {
        if (this.Caster?.HasModifier("modifier_ascended"))
        {
            let AoeParticleStr = "";
            let CrackParticleStr = "";

            switch (this.SlashCount)
            {
                case 1: //earth
                {
                    AoeParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_earth.vpcf";
                    CrackParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_earth_crack.vpcf";
                    break;                
                }
                case 2: //water
                {
                    AoeParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_water.vpcf";
                    CrackParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_water_crack.vpcf";
                    break;    
                }
                case 3: //fire
                {
                    AoeParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_fire.vpcf";
                    CrackParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_fire_crack.vpcf";
                    break;    
                }
                case 4: //wind
                {
                    AoeParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_wind.vpcf";
                    CrackParticleStr = "particles/custom/musashi/musashi_niou_kurikara_unique_wind_crack.vpcf";
                    break;    
                }
            }

            const AoeParticle = ParticleManager.CreateParticle(AoeParticleStr, ParticleAttachment.WORLDORIGIN, this.Caster);
            const CrackParticle = ParticleManager.CreateParticle(CrackParticleStr, ParticleAttachment.WORLDORIGIN, this.Caster);
            ParticleManager.SetParticleControl(CrackParticle, 0, this.TargetPoint);
            ParticleManager.SetParticleControl(AoeParticle, 0, this.TargetPoint);
            ParticleManager.SetParticleControl(AoeParticle, 1, Vector(1.5, 0, 0));
            ParticleManager.SetParticleControl(AoeParticle, 12, Vector(this.Ability?.GetAOERadius(), 0, 0));
            
        }
        else
        {
            const AoeParticleStr = "particles/custom/musashi/musashi_niou_kurikara_basic.vpcf";
            const AoeParticle = ParticleManager.CreateParticle(AoeParticleStr, ParticleAttachment.WORLDORIGIN, this.Caster);
            ParticleManager.SetParticleControl(AoeParticle, 0, this.TargetPoint);
            ParticleManager.SetParticleControl(AoeParticle, 1, Vector(1.5, 0, 0));
            ParticleManager.SetParticleControl(AoeParticle, 2, Vector(this.Ability?.GetAOERadius(), 0, 0));
        }
    }

    override GetModifierIncomingDamage_Percentage(): number
    {
        return this.GetAbility()?.GetSpecialValueFor("DmgReduceWhileSlashing")!;
    }

    override DeclareFunctions(): ModifierFunction[]
    {
        return [ModifierFunction.INCOMING_DAMAGE_PERCENTAGE, ModifierFunction.OVERRIDE_ANIMATION, ModifierFunction.OVERRIDE_ANIMATION_RATE];
    }

    override GetOverrideAnimation(): GameActivity
    {
        return GameActivity.DOTA_CHANNEL_ABILITY_1;
    }

    override GetOverrideAnimationRate(): number
    {
        return 0.5;
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
// Miyamoto Musashi: Skill 3: Niou Kurikara (ELEMENTAL DEBUFFS)
//======================================================================================================================
@registerModifier()
export class musashi_modifier_earth_debuff extends BaseModifier
{
    override OnCreated(): void
    {
        if (!IsServer())
        {
            return;
        }
    }

    override DeclareFunctions(): ModifierFunction[]
    {
        return [ModifierFunction.MOVESPEED_BONUS_PERCENTAGE];
    }

    override GetModifierMoveSpeedBonus_Percentage(): number
    {
        return this.GetAbility()?.GetSpecialValueFor("EarthSlow")!;
    }
}

@registerModifier()
export class musashi_modifier_water_debuff extends BaseModifier
{
    Caster: CDOTA_BaseNPC | undefined;
    Attribute: CDOTABaseAbility | undefined;
    Victim: CDOTA_BaseNPC | undefined;

    TargetPoint: Vector = Vector(0, 0, 0);
    PushSpeed: number = 0;

    override OnCreated(): void
    {
        if (!IsServer())
        {
            return;
        }

        this.Caster = this.GetCaster();
        this.Victim = this.GetParent();
        this.Attribute = this.GetAbility();
        const ModifierNiouKurikara = this.Caster?.FindModifierByName(musashi_modifier_niou_kurikara_slashing.name) as 
                                     musashi_modifier_niou_kurikara_slashing;
        this.TargetPoint = ModifierNiouKurikara.TargetPoint;
        this.PushSpeed = this.Attribute?.GetSpecialValueFor("PushSpeed")!;
        this.Victim?.AddNewModifier(this.Caster, this.Attribute, "modifier_rooted", {duration: 1});
        giveUnitDataDrivenModifier(this.Caster!, this.Victim, "locked", this.GetDuration());
        this.StartIntervalThink(0.03);
    }

    override OnIntervalThink(): void
    {
        if (!IsServer())
        {
            return;
        }
        
        const CurrentOrigin = this.Victim?.GetAbsOrigin()!;
        const ForwardVector = ((this.TargetPoint - CurrentOrigin) as Vector).Normalized();
        this.Victim?.SetForwardVector(ForwardVector);
        const NewPosition = (CurrentOrigin + (this.Victim?.GetForwardVector()! * this.PushSpeed)) as Vector;
        this.Victim?.SetAbsOrigin(NewPosition);
        const VictimEntity = Entities.FindByNameWithin(undefined, this.Victim?.GetName()!, this.TargetPoint, this.PushSpeed);

        if (VictimEntity)
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

        this.Victim?.SetForwardVector(this.Victim.GetAbsOrigin().Normalized());
        FindClearSpaceForUnit(this.Victim!, this.Victim?.GetAbsOrigin()!, true);
    }

    override CheckState(): Partial<Record<ModifierState, boolean>>
    {
        const ModifierTable = 
        {
            [ModifierState.FLYING_FOR_PATHING_PURPOSES_ONLY]: true,
        }

        return ModifierTable;
    }
}

@registerModifier()
export class musashi_modifier_fire_debuff extends BaseModifier
{
    Caster: CDOTA_BaseNPC | undefined;
    Ability: CDOTABaseAbility | undefined;

    Victim: CDOTA_BaseNPC | undefined;

    Damage: number = 0;
    DmgType: DamageTypes | undefined;
    DmgFlag: DamageFlag | undefined;

    override OnCreated(): void
    {
        if (!IsServer())
        {
            return;
        }

        this.Caster = this.GetCaster();
        this.Victim = this.GetParent();
        this.Ability = this.GetAbility();
        const DebuffDuration = this.Ability?.GetSpecialValueFor("DebuffDuration")!;
        this.Damage = this.Ability?.GetSpecialValueFor("FireBurnDmgPerSec")!;
        this.DmgType = DamageTypes.MAGICAL;
        this.DmgFlag = DamageFlag.NONE;
        this.StartIntervalThink(DebuffDuration);
        this.CreateParticle();
    }

    override OnIntervalThink(): void
    {
        if (!IsServer())
        {
            return;
        }

        DoDamage(this.Caster!, this.Victim!, this.Damage, this.DmgType!, this.DmgFlag!, this.Ability!, false);
    }

    CreateParticle(): void
    {
        let ParticleStr = "particles/custom/musashi/musashi_niou_kurikara_fire_debuff_basic.vpcf";

        if (this.Caster?.HasModifier("modifier_ascended"))
        {
            ParticleStr = "particles/custom/musashi/musashi_niou_kurikara_fire_debuff_unique.vpcf";
        }

        const Particle = ParticleManager.CreateParticle(ParticleStr, ParticleAttachment.POINT_FOLLOW, this.Victim);
        this.AddParticle(Particle, false, false, -1, false, false);
    }

    override GetModifierIncomingDamage_Percentage(): number
    {
        return this.Ability?.GetSpecialValueFor("FireIncreaseDmgTaken")!;
    }

    override DeclareFunctions(): ModifierFunction[]
    {
        return [ModifierFunction.INCOMING_DAMAGE_PERCENTAGE];
    }
}

@registerModifier()
export class musashi_modifier_wind_debuff extends BaseModifier
{
    override CheckState(): Partial<Record<ModifierState, boolean>>
    {
        const ModifierTable = 
        {
            [ModifierState.STUNNED]: true,
        }

        return ModifierTable;
    }

    override IsStunDebuff(): boolean
    {
        return true;
    }
}

//======================================================================================================================
// Miyamoto Musashi: Skill 3: Niou Kurikara (DAMAGE REDUCTION BUFFS)
//======================================================================================================================
@registerModifier()
export class musashi_modifier_niou_kurikara_postslashing_buff extends BaseModifier
{
    override OnCreated(): void
    {
        if (!IsServer())
        {
            return;
        }
    }

    override GetModifierIncomingDamage_Percentage(): number
    {
        return this.GetAbility()?.GetSpecialValueFor("DmgReducePostSlashing")!;
    }

    override DeclareFunctions(): ModifierFunction[]
    {
        return [ModifierFunction.INCOMING_DAMAGE_PERCENTAGE];
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
// Miyamoto Musashi: Skill 4: Tengan (W)
//======================================================================================================================
@registerAbility()
export class musashi_tengan extends BaseAbility
{
    readonly SoundVoiceline: string = "antimage_anti_cast_02";
    readonly SoundSfx: string = "musashi_tengan_sfx";

    Caster: CDOTA_BaseNPC | undefined;
    ChargeCounter: musashi_modifier_tengan_chargecounter | undefined;

    override OnAbilityPhaseStart(): boolean
    {
        if (IsServer())
        {
            this.Caster = this.GetCaster();
            this.ChargeCounter = this.Caster.FindModifierByName(musashi_modifier_tengan_chargecounter.name) as musashi_modifier_tengan_chargecounter;

            if (CheckComboStatsFulfilled(this.Caster) && !this.Caster.HasModifier(musashi_modifier_ishana_daitenshou_cooldown.name))
            {
                const SkillsSequence = [musashi_tengan.name, musashi_dai_go_sei.name];
                InitComboSequenceChecker(this.Caster, SkillsSequence, musashi_ganryuu_jima.name, musashi_ishana_daitenshou.name, 5);
            }

            if (this.ChargeCounter.GetStackCount() > 0)
            {
                return true;
            }
        }

        return false;
    }
    
    override OnSpellStart(): void
    {
        const BuffDuration = this.GetSpecialValueFor("BuffDuration");
        const RechargeTime = this.GetSpecialValueFor("RechargeTime");
        this.Caster?.AddNewModifier(this.Caster, this, musashi_modifier_tengan.name, {duration: BuffDuration});
        this.ChargeCounter?.RechargeTimer.push(RechargeTime);
        
        if (this.ChargeCounter?.GetStackCount() === this.GetSpecialValueFor("MaxCharges") && 
            this.Caster?.HasModifier("musashi_attribute_improve_tengan"))
        {
            InitSkillSlotChecker(this.Caster, musashi_tengan.name, musashi_tenma_gogan.name, 2);
        }

        this.ChargeCounter?.DecrementStackCount();
        this.PlaySound();
    }

    PlaySound(): void
    {
        this.Caster?.EmitSound(this.SoundVoiceline);
        this.Caster?.EmitSound(this.SoundSfx);
    }

    override GetIntrinsicModifierName(): string
    {
        return musashi_modifier_tengan_chargecounter.name;
    }
}

@registerModifier()
export class musashi_modifier_tengan_chargecounter extends BaseModifier
{
    Ability: CDOTABaseAbility | undefined;
    RechargeTimer: number[] = []; 

    override OnCreated(): void
    {
        if (!IsServer())
        {
            return;
        }

        this.Ability = this.GetAbility();
        const MaxCharges = this.Ability?.GetSpecialValueFor("MaxCharges")!;
        this.SetStackCount(MaxCharges);
        this.StartIntervalThink(1);
    }

    override OnRefresh(): void
    {
        if (!IsServer())
        {
            return;
        }

        this.OnCreated();
    }

    override OnStackCountChanged(): void
    {
        if (!IsServer())
        {
            return;
        }

        if (this.GetStackCount() === 0)
        {
            this.Ability?.StartCooldown(this.RechargeTimer[0] ?? 0);
        }
        else
        {
            this.Ability?.EndCooldown();
        }
    }

    override OnIntervalThink(): void
    {
        if (!IsServer() || this.RechargeTimer.length === 0)
        {
            return;
        }

        for (let i = 0; i < this.RechargeTimer.length; ++i)
        {
            --this.RechargeTimer[i];
        }

        if (this.RechargeTimer[0] === 0)
        {
            this.RechargeTimer.shift();
            this.IncrementStackCount();
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

    override IsPermanent(): boolean
    {
        return true;
    }
}

@registerModifier()
export class musashi_modifier_tengan extends BaseModifier
{
    Caster: CDOTA_BaseNPC | undefined;

    BonusDmg: number = 0;
    TenganBonus: number = 0;

    override OnCreated(): void
    {
        if (!IsServer())
        {
            return;
        }

        this.Caster = this.GetCaster();
        const Ability = this.GetAbility();
        const BaseDmg = Ability?.GetSpecialValueFor("BaseDmg")!;
        const BonusDmgPerAgi = Ability?.GetSpecialValueFor("BonusDmgPerAgi")!;
        this.TenganBonus = Ability?.GetSpecialValueFor("TenganBonus")!;
        this.BonusDmg = BaseDmg + ((this.Caster as CDOTA_BaseNPC_Hero).GetAgility() * BonusDmgPerAgi);
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
            const ParticleStr = "particles/custom/musashi/musashi_tengan_unique.vpcf";
            const OverheadParticleStr = "particles/custom/musashi/musashi_tengan_overhead_unique.vpcf";
            const Particle = ParticleManager.CreateParticle(ParticleStr, ParticleAttachment.POINT_FOLLOW, this.Caster);
            const OverheadParticle = ParticleManager.CreateParticle(OverheadParticleStr, ParticleAttachment.OVERHEAD_FOLLOW, this.Caster);
            this.AddParticle(Particle, false, false, -1, false, false);
            this.AddParticle(OverheadParticle, false, false, -1, false, false);
        }
        else 
        {
            const ParticleStr = "particles/custom/musashi/musashi_tengan_basic.vpcf";
            const OverheadParticleStr = "particles/custom/musashi/musashi_tengan_overhead_basic.vpcf";
            const Particle = ParticleManager.CreateParticle(ParticleStr, ParticleAttachment.POINT_FOLLOW, this.Caster);
            const OverheadParticle = ParticleManager.CreateParticle(OverheadParticleStr, ParticleAttachment.OVERHEAD_FOLLOW, this.Caster);
            ParticleManager.SetParticleControlEnt(OverheadParticle, 10, this.Caster!, ParticleAttachment.OVERHEAD_FOLLOW, 
                                                  "attach_hitloc", Vector(0, 0, 0), false);
            this.AddParticle(Particle, false, false, -1, false, false);
            this.AddParticle(OverheadParticle, false, false, -1, false, false);
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
}

//======================================================================================================================
// Miyamoto Musashi : Skill 6 : Ganryuu Jima (R)
//======================================================================================================================
@registerAbility()
export class musashi_ganryuu_jima extends BaseAbility implements BaseVectorAbility
{
    readonly SoundVoiceline: string = "antimage_anti_ability_manavoid_01";

    Caster: CDOTA_BaseNPC | undefined;

    DashPosition: Vector = Vector(0, 0, 0);
    SlashPosition: Vector = Vector(0, 0, 0);
    SecondSlashPosition: Vector = Vector(0, 0, 0);

    OnVectorCastStart(vStartLocation: Vector, vDirection: Vector): void
    {   
        this.Caster = this.GetCaster();
        this.SetVector(vStartLocation, vDirection);
        const ModifierGanryuuJima = this.Caster?.AddNewModifier(this.Caster, this, musashi_modifier_ganryuu_jima.name, {duration: 10});
        ModifierGanryuuJima?.IncrementStackCount();
        EmitGlobalSound(this.SoundVoiceline);
    }

    SetVector(vStartLocation: Vector, vDirection: Vector): void
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
            if (this.Caster?.HasModifier("musashi_attribute_niten_ichiryuu"))
            {
                return 1000;
            }
            else
            {
                return this.GetSpecialValueFor("SlashRange");
            }
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
        return this.SecondSlashPosition;
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
    Caster: CDOTA_BaseNPC | undefined;
    GanryuuJima: musashi_ganryuu_jima | undefined;
    
    DashPosition: Vector = Vector(0, 0, 0);
    SlashPosition: Vector = Vector(0, 0, 0);
    SecondSlashPosition: Vector = Vector(0, 0, 0);

    override OnCreated(): void
    {
        if (!IsServer())
        {
            return;
        }

        this.Caster = this.GetCaster();
        this.GanryuuJima = this.GetAbility() as musashi_ganryuu_jima;
        this.DashPosition = this.GanryuuJima.DashPosition;
        this.SlashPosition = this.GanryuuJima.SlashPosition;
        this.SecondSlashPosition = this.GanryuuJima.SecondSlashPosition;
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
                const DashBuff = this.Caster?.AddNewModifier(this.Caster, this.GanryuuJima, musashi_modifier_ganryuu_jima_dash.name,
                                                             {undefined}) as musashi_modifier_ganryuu_jima_dash;
                DashBuff.TargetPoint = Position;
                DashBuff.TargetPoint.z = this.Caster?.GetAbsOrigin().z!;
                DashBuff.NormalizedTargetPoint = ((DashBuff.TargetPoint - this.Caster?.GetAbsOrigin()!) as Vector).Normalized();
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

        if (stackCount === 1 || stackCount === 2)
        {
            const SlashBuff = this.Caster?.AddNewModifier(this.Caster, this.GanryuuJima, musashi_modifier_ganryuu_jima_slash.name, 
                              {undefined}) as musashi_modifier_ganryuu_jima_slash;
            SlashBuff.TargetPoint = Position;
            SlashBuff.StartIntervalThink(0.03);
        }
    }

    override OnDestroy(): void
    {
        if (!IsServer())
        {
            return;
        }

        this.Caster?.SetForwardVector(this.Caster.GetAbsOrigin().Normalized());
        this.Caster?.StartGesture(GameActivity.DOTA_CAST_ABILITY_1);
        FindClearSpaceForUnit(this.Caster!, this.Caster?.GetAbsOrigin()!, true);
        
        const ModifierTengan = this.Caster?.FindModifierByName(musashi_modifier_tengan.name);
        ModifierTengan?.Destroy();
        const ModifierTenmaGogan = this.Caster?.FindModifierByName(musashi_modifier_tenma_gogan.name);

        if (ModifierTenmaGogan)
        {
            this.GanryuuJima?.EndCooldown();
            this.Caster?.GiveMana(this.GanryuuJima?.GetManaCost(-1)!);
            ModifierTenmaGogan?.IncrementStackCount();
        }
    }

    override CheckState(): Partial<Record<ModifierState, boolean>>
    {
        const ModifierTable = 
        {
            [ModifierState.INVULNERABLE]: true,
            [ModifierState.UNSELECTABLE]: true,
            [ModifierState.UNTARGETABLE]: true,
            [ModifierState.NO_HEALTH_BAR]: true,
            [ModifierState.FLYING_FOR_PATHING_PURPOSES_ONLY]: true,
            [ModifierState.COMMAND_RESTRICTED]: true,
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
}

@registerModifier()
export class musashi_modifier_ganryuu_jima_dash extends BaseModifier
{
    TargetPoint: Vector = Vector(0, 0, 0);
    NormalizedTargetPoint: Vector = Vector(0, 0, 0);

    Caster: CDOTA_BaseNPC | undefined;
    Ability: CDOTABaseAbility | undefined;

    SlashRange: number = 0;
    UnitsTravelled: number = 0;
    DashSpeed: number = 0;

    override OnCreated(): void
    {
        if (!IsServer())
        {
            return;
        }

        this.Caster = this.GetCaster();
        this.Ability = this.GetAbility();
        this.SlashRange = this.Ability?.GetSpecialValueFor("SlashRange")!;
        this.DashSpeed = this.Ability?.GetSpecialValueFor("DashSpeed")!;
    }

    override OnIntervalThink(): void
    {
        if (!IsServer())
        {
            return;
        }

        this.Caster?.SetForwardVector(this.NormalizedTargetPoint);
        const CurrentOrigin = this.Caster?.GetAbsOrigin()!;
        const NewPosition = (CurrentOrigin + (this.Caster?.GetForwardVector()! * this.DashSpeed)) as Vector;
        this.UnitsTravelled += ((NewPosition - CurrentOrigin) as Vector).Length2D();
        this.Caster?.SetAbsOrigin(NewPosition);
        const Musashi = Entities.FindByNameWithin(undefined, this.Caster?.GetName()!, this.TargetPoint, this.DashSpeed);

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

        const ModifierGanryuuJima = this.Caster?.FindModifierByName(musashi_modifier_ganryuu_jima.name);
        ModifierGanryuuJima?.IncrementStackCount();
    }

    override DeclareFunctions(): ModifierFunction[]
    {
        return [ModifierFunction.OVERRIDE_ANIMATION, ModifierFunction.OVERRIDE_ANIMATION_RATE];
    }

    override GetOverrideAnimation(): GameActivity
    {
        return GameActivity.DOTA_OVERRIDE_ABILITY_1;
    }

    override GetOverrideAnimationRate(): number
    {
        return 2;
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
export class musashi_modifier_ganryuu_jima_slash extends BaseModifier
{
    readonly SoundSfx: string = "musashi_ganryuu_jima_sfx";

    Caster: CDOTA_BaseNPC | undefined;
    Ability: CDOTABaseAbility | undefined;

    TargetPoint: Vector = Vector(0, 0, 0);
    StartPosition: Vector = Vector(0, 0, 0);
    EndPosition: Vector = Vector(0, 0, 0);

    SlashRange: number = 0;
    UnitsTravelled: number = 0;
    DashSpeed: number = 0;

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
        this.DashSpeed = this.Ability?.GetSpecialValueFor("DashSpeed")!;
        this.Caster?.EmitSound(this.SoundSfx);
    }

    override OnIntervalThink(): void
    {
        if (!IsServer())
        {
            return;
        }

        this.Caster?.SetForwardVector(this.TargetPoint);
        const CurrentOrigin = this.Caster?.GetAbsOrigin()!;
        const NewPosition = (CurrentOrigin + (this.Caster?.GetForwardVector()! * this.DashSpeed)) as Vector;
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
        this.DealDamage();
        this.CreateParticle();
        const ModifierGanryuuJima = this.Caster?.FindModifierByName(musashi_modifier_ganryuu_jima.name);
        ModifierGanryuuJima?.IncrementStackCount();
    }
    
    DealDamage(): void
    {
        const DmgPerSlash = this.Ability?.GetSpecialValueFor("DmgPerSlash")!;
        const BonusDmgPerAgi = this.Ability?.GetSpecialValueFor("BonusDmgPerAgi");
        const Damage = DmgPerSlash + ((this.Caster as CDOTA_BaseNPC_Hero).GetAgility() * BonusDmgPerAgi!);
        const DmgType = this.Ability?.GetAbilityDamageType()!;
        const DmgFlag = DamageFlag.NONE;
        const Targets = FindUnitsInLine(this.Caster?.GetTeam()!, this.StartPosition, this.EndPosition, undefined, 
                                        this.Ability?.GetSpecialValueFor("SlashRadius")!, this.Ability?.GetAbilityTargetTeam()!,
                                        this.Ability?.GetAbilityTargetType()!, this.Ability?.GetAbilityTargetFlags()!);
        
        for (const Iterator of Targets) 
        {
            DoDamage(this.Caster!, Iterator, Damage, DmgType, DmgFlag, this.Ability!, false);
        }

        if (this.Caster?.HasModifier(musashi_modifier_tengan.name))
        {
            const DmgDelay = this.Ability?.GetSpecialValueFor("DebuffDmgDelay");
            const TargetFlags = UnitTargetFlags.MAGIC_IMMUNE_ENEMIES;
            const Targets = FindUnitsInLine(this.Caster.GetTeam(), this.StartPosition, this.EndPosition, undefined, 
                            this.Ability?.GetSpecialValueFor("SlashRadius")!, this.Ability?.GetAbilityTargetTeam()!, 
                            this.Ability?.GetAbilityTargetType()!, TargetFlags);

            for (const Iterator of Targets) 
            {
                Iterator.AddNewModifier(this.Caster, this.Ability, musashi_modifier_ganryuu_jima_debuff.name, {duration: DmgDelay});
            }
        }
    }

    CreateParticle(): void
    {
        let ParticleStr = "particles/custom/musashi/musashi_ganryuu_jima_basic.vpcf";

        if (this.Caster?.HasModifier("modifier_ascended"))
        {
            ParticleStr = "particles/custom/musashi/musashi_ganryuu_jima_unique.vpcf";
        }

        const Particle = ParticleManager.CreateParticle(ParticleStr, ParticleAttachment.WORLDORIGIN, this.Caster);
        ParticleManager.SetParticleControl(Particle, 0, this.StartPosition);
        ParticleManager.SetParticleControl(Particle, 1, this.EndPosition);
    }

    override DeclareFunctions(): ModifierFunction[]
    {
        return [ModifierFunction.OVERRIDE_ANIMATION, ModifierFunction.OVERRIDE_ANIMATION_RATE];
    }

    override GetOverrideAnimation(): GameActivity
    {
        return GameActivity.DOTA_OVERRIDE_ABILITY_2;
    }

    override GetOverrideAnimationRate(): number
    {
        return 4;
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
    Caster: CDOTA_BaseNPC | undefined;
    BonusDmg: number = 0;

    override OnCreated(): void
    {
        if (!IsServer())
        {
            return;
        }

        this.Caster = this.GetCaster();
        const ModifierTengan = this.Caster?.FindModifierByName(musashi_modifier_tengan.name) as musashi_modifier_tengan;
        this.BonusDmg = ModifierTengan.BonusDmg;
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

        this.DealDamage();
    }

    DealDamage(): void
    {
        const Victim = this.GetParent();
        const DmgType = DamageTypes.PURE;
        const DmgFlag = DamageFlag.NO_SPELL_AMPLIFICATION;
        DoDamage(this.Caster!, Victim, this.BonusDmg, DmgType, DmgFlag, this.GetAbility()!, false);
    }

    CreateParticle(): void
    {
        let ParticleStr = "particles/custom/musashi/musashi_ganryuu_jima_debuff_basic.vpcf";

        if (this.Caster?.HasModifier("modifier_ascended"))
        {
            ParticleStr = "particles/custom/musashi/musashi_ganryuu_jima_debuff_unique.vpcf";
        }

        const Particle = ParticleManager.CreateParticle(ParticleStr, ParticleAttachment.POINT_FOLLOW, this.Caster);
        this.AddParticle(Particle, false, false, -1, false, false);
    }

    override IsDebuff(): boolean
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
// Miyamoto Musashi: Skill 7: Mukyuu (D)
//======================================================================================================================
@registerAbility()
export class musashi_mukyuu extends BaseAbility
{
    readonly SoundVoiceline: string = "antimage_anti_ability_manavoid_03";
    readonly SoundSfx: string = "musashi_mukyuu_sfx";

    Caster: CDOTA_BaseNPC | undefined;

    override OnSpellStart(): void
    {
        this.Caster = this.GetCaster();
        const BuffDuration = this.GetSpecialValueFor("BuffDuration");
        this.Caster.AddNewModifier(this.Caster, this, musashi_modifier_mukyuu.name, {duration: BuffDuration});
        InitSkillSlotChecker(this.Caster, musashi_mukyuu.name, musashi_tengen_no_hana.name, 5, false);
        this.PlaySound();
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
    Caster: CDOTA_BaseNPC | undefined;

    override OnCreated(): void
    {
        if (!IsServer())
        {
            return;
        }

        this.Caster = this.GetCaster();
        this.CreateParticle();
    }

    CreateParticle(): void
    {
        if (this.Caster?.HasModifier("modifier_ascended"))
        {
            const ParticleStr = "particles/custom/musashi/musashi_mukyuu_unique.vpcf";
            const Particle = ParticleManager.CreateParticle(ParticleStr, ParticleAttachment.POINT_FOLLOW, this.Caster);
            ParticleManager.SetParticleControlEnt(Particle, 1, this.Caster, ParticleAttachment.POINT_FOLLOW, "attach_hitloc",
                                                  Vector(0, 0, 0), false);
            this.AddParticle(Particle, false, false, -1, false, false);
        }
        else
        {
            const ParticleStr = "particles/custom/musashi/musashi_mukyuu_basic.vpcf";
            const Particle = ParticleManager.CreateParticle(ParticleStr, ParticleAttachment.POINT_FOLLOW, this.Caster);
            ParticleManager.SetParticleControlEnt(Particle, 0, this.Caster!, ParticleAttachment.POINT_FOLLOW, "attach_hitloc",
                                                  Vector(0, 0, 0), false);
            ParticleManager.SetParticleControl(Particle, 1, Vector(150, 0, 0));
            this.AddParticle(Particle, false, false, -1, false, false);
        }
    }

    override CheckState(): Partial<Record<ModifierState, boolean>>
    {
        const ModifierTable = 
        {
            [ModifierState.INVULNERABLE]: true,
            [ModifierState.MAGIC_IMMUNE]: true,
            [ModifierState.UNTARGETABLE]: true,
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
}

//======================================================================================================================
// Miyamoto Musashi : Skill 8 : Tenma Gogan (SA)
//======================================================================================================================
@registerAbility()
export class musashi_tenma_gogan extends BaseAbility
{
    readonly SoundVoiceline: string = "antimage_anti_ability_manavoid_05";
    readonly SoundSfx: string = "musashi_tengan_sfx";

    Caster: CDOTA_BaseNPC | undefined;

    override OnSpellStart(): void
    {
        this.Caster = this.GetCaster();
        const BuffDuration = this.GetSpecialValueFor("BuffDuration");
        this.Caster?.AddNewModifier(this.Caster, this, musashi_modifier_tenma_gogan.name, {duration: BuffDuration});
        this.PlaySound();
    }

    PlaySound(): void
    {
        this.Caster?.EmitSound(this.SoundVoiceline);
        this.Caster?.EmitSound(this.SoundSfx);
    }
}

@registerModifier()
export class musashi_modifier_tenma_gogan extends BaseModifier
{
    Caster: CDOTA_BaseNPC | undefined;

    override OnCreated(): void
    {
        if (!IsServer())
        {
            return;
        }

        this.Caster = this.GetCaster();
        const ChargeCounter = this.Caster?.FindModifierByName(musashi_modifier_tengan_chargecounter.name);
        const Tengan = this.Caster?.FindAbilityByName(musashi_tengan.name);
        ChargeCounter?.SetStackCount(0);
        ChargeCounter?.StartIntervalThink(-1);
        Tengan?.StartCooldown(9999);
        this.CreateParticle();
    }

    override OnStackCountChanged(stackCount: number): void
    {
        if (!IsServer())
        {
            return;
        }

        switch (stackCount)
        {
            case 1:
            {
                this.Destroy();
            }
        }
    }

    override OnDestroy(): void
    {
        if (!IsServer())
        {
            return;
        }

        const Ability = this.GetAbility();
        const DebuffDuration = Ability?.GetSpecialValueFor("DebuffDuration");
        this.Caster?.AddNewModifier(this.Caster, Ability, musashi_modifier_tenma_gogan_debuff.name, {duration: DebuffDuration});
    }

    CreateParticle(): void
    {
        let ParticleStr = "particles/custom/musashi/musashi_tenma_gogan_basic.vpcf";
        const BodyParticleStr = "particles/custom/musashi/musashi_tenma_gogan_body.vpcf";

        if (this.Caster?.HasModifier("modifier_ascended"))
        {
            ParticleStr = "particles/custom/musashi/musashi_tenma_gogan_unique.vpcf";
        }

        const Particle = ParticleManager.CreateParticle(ParticleStr, ParticleAttachment.POINT_FOLLOW, this.Caster);
        const BodyParticle = ParticleManager.CreateParticle(BodyParticleStr, ParticleAttachment.POINT_FOLLOW, this.Caster);
        this.AddParticle(Particle, false, false, -1, false, false);
        this.AddParticle(BodyParticle, false, false, -1, false, false);
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
export class musashi_modifier_tenma_gogan_debuff extends BaseModifier
{
    override OnCreated(): void
    {
        if (!IsServer())
        {
            return;
        }

        const Caster = this.GetCaster();
        const DebuffDuration = this.GetDuration();
        giveUnitDataDrivenModifier(Caster!, Caster!, "pause_sealdisabled", DebuffDuration);
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

    override IsStunDebuff(): boolean
    {
        return true;
    }
}

//======================================================================================================================
// Miyamoto Musashi : Skill 9 : Tengen No Hana (F)
//======================================================================================================================
@registerAbility()
export class musashi_tengen_no_hana extends BaseAbility
{
    override OnSpellStart(): void
    {
        const Caster = this.GetCaster();
        const ModifierTengenNoHana = Caster.FindModifierByName(musashi_modifier_tengen_no_hana.name);

        if (ModifierTengenNoHana)
        {
            ModifierTengenNoHana.Destroy();
            return;
        }

        const BuffDuration = this.GetSpecialValueFor("BuffDuration");
        Caster.AddNewModifier(Caster, this, musashi_modifier_tengen_no_hana.name, {duration: BuffDuration});
    }
}

@registerModifier()
export class musashi_modifier_tengen_no_hana extends BaseModifier
{
    readonly SoundVoiceline: string = "antimage_anti_ability_manavoid_02";
    readonly SoundSfx: string = "musashi_tengen_no_hana_sfx";

    Caster: CDOTA_BaseNPC | undefined;
    Ability: CDOTABaseAbility | undefined;

    Percentage: number = 0;
    Radius: number = 0;

    override OnCreated(): void
    {
        if (!IsServer())
        {
            return;
        }

        this.Caster = this.GetCaster();
        this.Ability = this.GetAbility();
        this.Radius = this.Ability?.GetSpecialValueFor("Radius")!;
        const RampUpInterval = this.Ability?.GetSpecialValueFor("RampUpInterval")!;
        this.StartIntervalThink(RampUpInterval);
        this.CreateParticle();
        this.Caster?.EmitSound(this.SoundSfx);
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
                this.Percentage = this.Ability?.GetSpecialValueFor("1SecPercentage")!;
                break;
            }
            case 1:
            {
                this.Percentage = this.Ability?.GetSpecialValueFor("2SecPercentage")!;
                break;
            }
            case 2:
            {
                this.Percentage = this.Ability?.GetSpecialValueFor("FullPercentage")!;
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

        if (this.Caster?.HasModifier(musashi_modifier_niou_kurikara_slashing.name) || 
            this.Caster?.HasModifier(musashi_modifier_ganryuu_jima.name))
        {
            return;
        }

        this.Percentage = this.Percentage / 100;
        this.Caster?.StartGesture(GameActivity.DOTA_CAST_ABILITY_1);
        this.DealDamage();
        this.CreateAoeParticle();
        this.Caster?.EmitSound(this.SoundVoiceline);
        this.Ability?.SetHidden(true);
    }

    DealDamage(): void
    {
        const FullDamage = this.Ability?.GetSpecialValueFor("FullDamage")!;
        const DmgType = this.Ability?.GetAbilityDamageType()!;
        const DmgFlag = DamageFlag.NONE;
        const Damage = this.Percentage * FullDamage;
        const StunDuration = this.Ability?.GetSpecialValueFor("StunDuration")! * this.Percentage;
        const Targets = FindUnitsInRadius(this.Caster?.GetTeam()!, this.Caster?.GetAbsOrigin()!, undefined, this.Radius, 
                                          this.Ability?.GetAbilityTargetTeam()!, this.Ability?.GetAbilityTargetType()!, 
                                          this.Ability?.GetAbilityTargetFlags()!, FindOrder.ANY, false);
        
        for (const Iterator of Targets) 
        {
            DoDamage(this.Caster!, Iterator, Damage, DmgType, DmgFlag, this.Ability!, false);
            Iterator.AddNewModifier(this.Caster, this.Ability, "modifier_stunned", {duration: StunDuration});
        }
    }

    CreateParticle(): void
    {
        let ParticleStr = "particles/custom/musashi/musashi_tengen_no_hana_basic.vpcf";

        if (this.Caster?.HasModifier("modifier_ascended"))
        {
            ParticleStr = "particles/custom/musashi/musashi_tengen_no_hana_unique1.vpcf";

            if (this.Caster.HasModifier(musashi_modifier_battle_continuation_active.name))
            {
                ParticleStr = "particles/custom/musashi/musashi_tengen_no_hana_unique2.vpcf"
            }
        }

        const Particle = ParticleManager.CreateParticle(ParticleStr, ParticleAttachment.OVERHEAD_FOLLOW, this.Caster);
        this.AddParticle(Particle, false, false, -1, false, false);
    }

    CreateAoeParticle(): void
    {
        let ParticleStr = "particles/custom/musashi/musashi_tengen_no_hana_aoe_basic.vpcf";
        let MarkerParticleStr = "particles/custom/musashi/musashi_tengen_no_hana_aoemarker_basic.vpcf";

        if (this.Caster?.HasModifier("modifier_ascended"))
        {
            ParticleStr = "particles/custom/musashi/musashi_tengen_no_hana_aoe_unique1.vpcf";
            MarkerParticleStr = "particles/custom/musashi/musashi_tengen_no_hana_aoemarker_unique1.vpcf";

            if (this.Caster.HasModifier(musashi_modifier_battle_continuation_active.name)) 
            {
                ParticleStr = "particles/custom/musashi/musashi_tengen_no_hana_aoe_unique2.vpcf";
                MarkerParticleStr = "particles/custom/musashi/musashi_tengen_no_hana_aoemarker_unique2.vpcf"; 
            }
        }

        const Particle = ParticleManager.CreateParticle(ParticleStr, ParticleAttachment.WORLDORIGIN, this.Caster);
        const MarkerParticle = ParticleManager.CreateParticle(MarkerParticleStr, ParticleAttachment.WORLDORIGIN, this.Caster);
        ParticleManager.SetParticleControl(Particle, 0, this.Caster?.GetAbsOrigin()!);
        ParticleManager.SetParticleControl(Particle, 2, Vector(this.Radius, this.Radius, this.Radius));
        ParticleManager.SetParticleControl(MarkerParticle, 0, this.Caster?.GetAbsOrigin()!);
        ParticleManager.SetParticleControl(MarkerParticle, 2, Vector(this.Radius, this.Radius, this.Radius));
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
// Miyamoto Musashi : Skill 10 : Battle Continuation (SA)
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
    Caster: CDOTA_BaseNPC | undefined;
    Ability: CDOTABaseAbility | undefined;

    override OnCreated(): void
    {
        if (!IsServer())
        {
            return;
        }

        this.Caster = this.GetCaster();
        this.Ability = this.GetAbility();
    }

    override OnTakeDamage(event: ModifierInstanceEvent): void
    {
        if (!IsServer() || event.unit !== this.Caster)
        {
            return;
        }

        const DmgThreshold = this.Ability?.GetSpecialValueFor("DmgThreshold")!;

        if (!this.Caster.HasModifier("musashi_attribute_battle_continuation") || 
            this.Caster.HasModifier(musashi_modifier_battle_continuation_cooldown.name) || 
            this.Caster.HasModifier(musashi_modifier_tenma_gogan_debuff.name) || 
            event.damage >= DmgThreshold || !IsRevivePossible(this.Caster))
        {
            return;
        }

        if (this.Caster.GetHealth() <= 0)
        {
            const BuffDuration = this.Ability?.GetSpecialValueFor("BuffDuration");
            this.Caster.SetHealth(1);
            this.Caster.AddNewModifier(this.Caster, this.Ability, musashi_modifier_battle_continuation_active.name, {duration: BuffDuration});
            this.Caster.AddNewModifier(this.Caster, this.Ability, musashi_modifier_battle_continuation_cooldown.name, {duration: this.Ability?.GetCooldown(1)});
            this.Ability?.UseResources(true, false, true);
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

    override IsPermanent(): boolean
    {
        return true;
    }

    override IsHidden(): boolean
    {
        return true;
    }

    override RemoveOnDeath(): boolean
    {
        return false;
    }
}

@registerModifier()
export class musashi_modifier_battle_continuation_active extends BaseModifier
{
    readonly SoundVoiceline: string = "antimage_anti_ability_manavoid_04";
    readonly SoundSfx: string = "musashi_battle_continuation_sfx";

    Caster: CDOTA_BaseNPC | undefined;

    override OnCreated(): void
    {
        if (!IsServer())
        {
            return;
        }

        this.Caster = this.GetCaster();
        const TengenNoHana = this.Caster?.FindAbilityByName(musashi_tengen_no_hana.name)!;
        this.Caster?.CastAbilityImmediately(TengenNoHana, this.Caster.GetEntityIndex());
        ProjectileManager.ProjectileDodge(this.Caster!);
        this.Caster?.Purge(false, true, false, false, false);
        this.CreateParticle();
        this.PlaySound();
    }

    PlaySound(): void
    {
        this.Caster?.EmitSound(this.SoundVoiceline);
        this.Caster?.EmitSound(this.SoundSfx);
    }

    CreateParticle(): void
    {
        let ParticleStr = "particles/custom/musashi/musashi_battle_continuation_basic.vpcf";

        if (this.Caster?.HasModifier("modifier_ascended"))
        {
            ParticleStr = "particles/custom/musashi/musashi_battle_continuation_unique.vpcf";
        }

        const Particle = ParticleManager.CreateParticle(ParticleStr, ParticleAttachment.POINT_FOLLOW, this.Caster);
        ParticleManager.SetParticleControlEnt(Particle, 5, this.Caster!, ParticleAttachment.POINT_FOLLOW, "attach_hitloc",
                                              Vector(0, 0, 0), false);
        this.AddParticle(Particle, false, false, -1, false, false);
    }

    override DeclareFunctions(): ModifierFunction[]
    {
        return [ModifierFunction.MIN_HEALTH, ModifierFunction.DISABLE_HEALING];
    }

    override GetMinHealth(): number
    {
        return 1;
    }

    override GetDisableHealing(): 0 | 1
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
export class musashi_modifier_battle_continuation_cooldown extends BaseModifier
{
    override OnCreated(): void
    {
        if (!IsServer())
        {
            return;
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

    override RemoveOnDeath(): boolean
    {
        return false;
    }

    override IsDebuff(): boolean
    {
        return true;
    }
}

//======================================================================================================================
// Miyamoto Musashi: Skill 11: Niou (Innate)
//======================================================================================================================
@registerAbility()
export class musashi_niou extends BaseAbility
{
    Niou: CDOTA_BaseNPC | undefined;

    override OnSpellStart(): void
    {
        const Caster = this.GetCaster();
        this.Niou = CreateUnitByName("musashi_niou", Caster.GetAbsOrigin(), false, Caster, Caster, Caster.GetTeam());
        let ModelScale = this.GetSpecialValueFor("ModelScale");

        if (Caster.HasModifier(musashi_modifier_ishana_daitenshou.name))
        {
            ModelScale = 6;
        }
        
        this.Niou.SetModelScale(ModelScale);
        this.Niou.AddNewModifier(this.Niou, this, musashi_modifier_niou.name, {undefined});
    }

    async DestroyNiou(delay: number): Promise<void>
    {
        this.Niou?.ForceKill(false);
        await Sleep(delay);
        this.Niou?.Destroy();
    }
}

@registerModifier()
export class musashi_modifier_niou extends BaseModifier
{
    override OnCreated(): void
    {
        if (!IsServer())
        {
            return;
        }
    }

    override CheckState(): Partial<Record<ModifierState, boolean>>
    {
        const ModifierTable = 
        {
            [ModifierState.INVULNERABLE]: true,
            [ModifierState.MAGIC_IMMUNE]: true,
            [ModifierState.UNSELECTABLE]: true,
            [ModifierState.UNTARGETABLE]: true,
            [ModifierState.NO_HEALTH_BAR]: true,
            [ModifierState.NO_UNIT_COLLISION]: true,
            [ModifierState.NOT_ON_MINIMAP]: true,
            [ModifierState.COMMAND_RESTRICTED]: true,
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

    override IsPermanent(): boolean
    {
        return true;
    }

    override IsHidden(): boolean
    {
        return true;
    }
}

//======================================================================================================================
// Miyamoto Musashi: Skill 12: Dai Go Sei Wave (Innate W)
//======================================================================================================================
@registerAbility()
export class musashi_dai_go_sei_wave extends BaseAbility
{
    readonly SoundVoiceline: string = "antimage_anti_ability_manavoid_08";
    readonly SoundSfx: string = "musashi_dai_go_sei_wave_sfx";

    Caster: CDOTA_BaseNPC | undefined;

    Damage: number = 0;
    DmgType: DamageTypes | undefined;
    DmgFlag: DamageFlag | undefined;

    override OnSpellStart(): void
    {
        this.Caster = this.GetCaster();
        this.SetDamageParameters();
        this.CreateProjectile();
        this.PlaySound();
    }

    SetDamageParameters(): void
    {
        this.Damage = this.GetSpecialValueFor("Damage");
        this.DmgType = this.GetAbilityDamageType();
        this.DmgFlag = DamageFlag.NONE;
    }

    CreateProjectile(): void
    {
        let ParticleStr = "particles/custom/musashi/musashi_dai_go_sei_wave_basic.vpcf";

        if (this.Caster?.HasModifier("modifier_ascended"))
        {
            ParticleStr = "particles/custom/musashi/musashi_dai_go_sei_wave_unique.vpcf";
        }

        const Direction = ((this.GetCursorTarget()?.GetAbsOrigin()! - this.Caster?.GetAbsOrigin()!) as Vector).Normalized();

        ProjectileManager.CreateLinearProjectile
        (
            {
                EffectName: ParticleStr,
                Ability: this,
                Source: this.Caster!,
                vSpawnOrigin: this.Caster?.GetAbsOrigin()!,
                vVelocity: (Direction * this.GetSpecialValueFor("ProjectileSpeed")) as Vector,
                fDistance: this.GetSpecialValueFor("Range"),
                fStartRadius: this.GetSpecialValueFor("ProjectileRadius"),
                fEndRadius: this.GetSpecialValueFor("ProjectileRadius"),
                iUnitTargetTeam: this.GetAbilityTargetTeam(),
                iUnitTargetFlags: this.GetAbilityTargetFlags(),
                iUnitTargetType: this.GetAbilityTargetType(),
            }
        )
    }
    
    override OnProjectileHit(target: CDOTA_BaseNPC): boolean | void
    {
        if (!IsServer())
        {
            return;
        }

        DoDamage(this.Caster!, target!, this.Damage, this.DmgType!, this.DmgFlag!, this, false);
    }

    PlaySound(): void
    {
        this.Caster?.EmitSound(this.SoundVoiceline);
        this.Caster?.EmitSound(this.SoundSfx);
    }

    override GetIntrinsicModifierName(): string
    {
        return musashi_modifier_dai_go_sei_wave_counter.name;
    }
}

@registerModifier()
export class musashi_modifier_dai_go_sei_wave_counter extends BaseModifier
{
    Caster: CDOTA_BaseNPC | undefined;
    Ability: CDOTABaseAbility | undefined;

    override OnCreated(): void
    {
        if (!IsServer())
        {
            return;
        }

        this.Caster = this.GetCaster();
        this.Ability = this.GetAbility();
        this.IncrementStackCount();
    }

    override OnStackCountChanged(stackCount: number): void
    {
        if (!IsServer())
        {
            return;
        }

        this.Ability?.SetLevel(stackCount + 1);
        this.StartIntervalThink(10);
    }

    override OnIntervalThink(): void
    {
        if (!IsServer())
        {
            return;
        }

        this.StartIntervalThink(-1);
        this.SetStackCount(0);
        this.IncrementStackCount();
    }

    override OnAbilityFullyCast(event: ModifierAbilityEvent): void
    {
        if (!IsServer() || event.unit !== this.Caster || event.ability !== this.Ability)
        {
            return;
        }

        if (this.GetStackCount() < 5)
        {
            this.IncrementStackCount();
        }
    }

    override GetModifierOverrideAbilitySpecialValue(event: ModifierOverrideAbilitySpecialEvent): number
    {
        const DaiGoSei = this.Caster?.FindAbilityByName(musashi_dai_go_sei.name);

        if (event.ability_special_value === "Damage")
        {
            const BaseDmg = this.Ability?.GetSpecialValueFor("BaseDamage")!;
            const BonusDmgFromAtkDmg = this.Ability?.GetSpecialValueFor("BonusDmgFromAtkDmg")!;
            const BonusDmgFromWBuff = this.Ability?.GetSpecialValueFor("BonusDmgFromWBuff")!;
            const Damage = BaseDmg + BonusDmgFromAtkDmg + BonusDmgFromWBuff;

            return Damage;
        }
        else if (event.ability_special_value === "BaseDamage")
        {
            const AbilityLevel = DaiGoSei?.GetLevel()!;
            return 100 * AbilityLevel;
        }
        else if (event.ability_special_value === "BonusDmgFromAtkDmg")
        {
            return this.Caster?.GetDamageMax()!;
        }
        else if (event.ability_special_value === "BonusDmgFromWBuff")
        {
            if (this.Caster?.HasModifier(musashi_modifier_dai_go_sei.name))
            {
                const BonusAtkDmg = DaiGoSei?.GetSpecialValueFor("BonusAtkDmg")!;
                return 2 * BonusAtkDmg;
            }
        }
        
        return 0;
    }

    override GetModifierOverrideAbilitySpecial(event: ModifierOverrideAbilitySpecialEvent): 0 | 1
    {
        if (event.ability === this.Ability)
        {
            if (event.ability_special_value === "Damage" || event.ability_special_value === "BaseDamage" ||
                event.ability_special_value === "BonusDmgFromAtkDmg" || event.ability_special_value === "BonusDmgFromWBuff")
            {
                return 1;
            }
        }

        return 0;
    }

    override DeclareFunctions(): ModifierFunction[]
    {
        return [ModifierFunction.ON_ABILITY_FULLY_CAST, ModifierFunction.OVERRIDE_ABILITY_SPECIAL_VALUE, ModifierFunction.OVERRIDE_ABILITY_SPECIAL];
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
        if (this.GetStackCount() <= 1)
        {
            return true;
        }

        return false;
    }

    override IsPermanent(): boolean
    {
        return true;
    }
}

//======================================================================================================================
// Miyamoto Musashi : Combo Skill : Ishana Daitenshou
//======================================================================================================================
@registerAbility()
export class musashi_ishana_daitenshou extends BaseAbility
{
    readonly SoundVoiceline: string = "antimage_anti_ability_manavoid_06";
    readonly SoundBgm: string = "musashi_ishana_daitenshou_bgm";

    override OnSpellStart(): void
    {
        const Caster = this.GetCaster();
        const NiouKurikara = Caster.FindAbilityByName(musashi_niou_kurikara.name);
        NiouKurikara?.EndCooldown();
        Caster.GiveMana(NiouKurikara?.GetManaCost(-1)!);
        Caster.AddNewModifier(Caster, this, musashi_modifier_ishana_daitenshou.name, {duration: 10});
        Caster.AddNewModifier(Caster, this, musashi_modifier_ishana_daitenshou_cooldown.name, {duration: this.GetCooldown(1)});
        this.PlaySound();
    }
    
    PlaySound(): void
    {
        EmitGlobalSound(this.SoundVoiceline);
        EmitGlobalSound(this.SoundBgm);
    }
}

@registerModifier()
export class musashi_modifier_ishana_daitenshou extends BaseModifier
{
    Caster: CDOTA_BaseNPC | undefined;
    Ability: CDOTABaseAbility | undefined;

    Victim: CDOTA_BaseNPC | undefined;
    MarkerPosition: Vector = Vector(0, 0, 0);
    StartPosition: Vector = Vector(0, 0, 0);
    SearchRadius: number = 0;

    override OnCreated(): void
    {
        if (!IsServer())
        {
            return;
        }

        this.Caster = this.GetCaster();
        this.Ability = this.GetAbility();
        this.Victim = this.Ability?.GetCursorTarget();
        this.StartPosition = this.Caster?.GetAbsOrigin()!;
        this.MarkerPosition = this.Victim?.GetAbsOrigin()!;
        const NiouKurikara = this.Caster?.FindAbilityByName(musashi_niou_kurikara.name)!;
        this.Caster?.CastAbilityOnPosition(this.MarkerPosition, NiouKurikara, this.Caster.GetEntityIndex());
        this.SearchRadius = this.Ability?.GetSpecialValueFor("SearchRadius")!;
        this.CreateParticle();
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
                const VictimEntity = Entities.FindByNameWithin(undefined, this.Victim?.GetName()!, this.MarkerPosition, this.SearchRadius);

                if (VictimEntity && this.Victim?.IsAlive())
                {
                    this.Caster?.AddNewModifier(this.Caster, this.Ability, musashi_modifier_ishana_daitenshou_dash.name, {undefined});
                }
                else
                {
                    this.Destroy();
                }

                break;
            }
            case 1:
            {
                this.Caster?.AddNewModifier(this.Caster, this.Ability, musashi_modifier_ishana_daitenshou_slash.name, {undefined});
                break;
            }
            case 2:
            {
                this.Destroy();
                break;
            }
        }
    }

    CreateParticle(): void
    {
        let MarkerParticleStr = "particles/custom/musashi/musashi_ishana_daitenshou_marker_basic.vpcf";
        let SwordParticleStr = "particles/custom/musashi/musashi_ishana_daitenshou_sword_basic.vpcf";
        let BodyParticleStr = "particles/custom/musashi/musashi_ishana_daitenshou_body_basic.vpcf";

        if (this.Caster?.HasModifier("modifier_ascended"))
        {
            MarkerParticleStr = "particles/custom/musashi/musashi_ishana_daitenshou_marker_unique.vpcf";
            SwordParticleStr = "particles/custom/musashi/musashi_ishana_daitenshou_sword_unique.vpcf";
            BodyParticleStr = "particles/custom/musashi/musashi_ishana_daitenshou_body_unique.vpcf";
        }

        const MarkerParticle = ParticleManager.CreateParticle(MarkerParticleStr, ParticleAttachment.WORLDORIGIN, this.Caster);
        const SwordParticle = ParticleManager.CreateParticle(SwordParticleStr, ParticleAttachment.POINT_FOLLOW, this.Caster);
        const BodyParticle = ParticleManager.CreateParticle(BodyParticleStr, ParticleAttachment.POINT_FOLLOW, this.Caster);
        ParticleManager.SetParticleControl(MarkerParticle, 0, this.MarkerPosition);
        ParticleManager.SetParticleControlEnt(SwordParticle, 0, this.Caster!, ParticleAttachment.POINT_FOLLOW, "attach_attack1",
                                              Vector(0, 0, 0), false);
        this.AddParticle(MarkerParticle, false, false, -1, false, false);
        this.AddParticle(SwordParticle, false, false, -1, false, false);
        this.AddParticle(BodyParticle, false, false, -1, false, false);
    }

    override CheckState(): Partial<Record<ModifierState, boolean>>
    {
        const ModifierTable = 
        {
            [ModifierState.INVULNERABLE]: true,
            [ModifierState.MAGIC_IMMUNE]: true,
            [ModifierState.UNSELECTABLE]: true,
            [ModifierState.UNTARGETABLE]: true,
            [ModifierState.NO_HEALTH_BAR]: true,
            [ModifierState.FLYING_FOR_PATHING_PURPOSES_ONLY]: true,
            [ModifierState.COMMAND_RESTRICTED]: true,
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
}

@registerModifier()
export class musashi_modifier_ishana_daitenshou_dash extends BaseModifier
{
    Caster: CDOTA_BaseNPC | undefined;
    Victim: CDOTA_BaseNPC | undefined;
    ModifierIshanaDaitenshou: musashi_modifier_ishana_daitenshou | undefined;
    DashSpeed: number = 0;

    override OnCreated(): void
    {
        if (!IsServer())
        {
            return;
        }

        this.Caster = this.GetCaster();
        this.DashSpeed = this.GetAbility()?.GetSpecialValueFor("DashSpeed")!;
        this.ModifierIshanaDaitenshou = this.Caster?.FindModifierByName(musashi_modifier_ishana_daitenshou.name) as musashi_modifier_ishana_daitenshou;
        this.Victim = this.ModifierIshanaDaitenshou.Victim;
        this.StartIntervalThink(0.03);
    }

    override OnIntervalThink(): void
    {
        if (!IsServer())
        {
            return;
        }

        const CasterAbsOrigin = this.Caster?.GetAbsOrigin()!;
        const VictimAbsOrigin = this.Victim?.GetAbsOrigin()!;
        const Direction = ((VictimAbsOrigin - CasterAbsOrigin) as Vector).Normalized();
        this.Caster?.SetForwardVector(Direction);
        const NewPosition = (CasterAbsOrigin + (this.Caster?.GetForwardVector()! * this.DashSpeed)) as Vector;
        this.Caster?.SetAbsOrigin(NewPosition);
        const Musashi = Entities.FindByNameWithin(undefined, this.Caster?.GetName()!, VictimAbsOrigin, this.DashSpeed);

        if (Musashi)
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

        this.ModifierIshanaDaitenshou?.IncrementStackCount();
        this.Caster?.SetForwardVector(this.Caster.GetAbsOrigin().Normalized());
        FindClearSpaceForUnit(this.Caster!, this.Caster?.GetAbsOrigin()!, true);
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
export class musashi_modifier_ishana_daitenshou_slash extends BaseModifier
{
    readonly SoundSfx: string = "musashi_ishana_daitenshou_sfx";

    Caster: CDOTA_BaseNPC | undefined;
    Ability: CDOTABaseAbility | undefined;

    ModifierIshanaDaitenshou: musashi_modifier_ishana_daitenshou | undefined;
    Victim: CDOTA_BaseNPC | undefined;
    SlashCount: number = 0;
    QuickSlashCount: number = 0;
    
    override OnCreated(): void
    {
        if (!IsServer())
        {
            return;
        }

        this.Caster = this.GetCaster();
        this.Ability = this.GetAbility();
        this.ModifierIshanaDaitenshou = this.Caster?.FindModifierByName(musashi_modifier_ishana_daitenshou.name) as musashi_modifier_ishana_daitenshou;
        this.Victim = this.ModifierIshanaDaitenshou.Victim;
        const QuickSlashInterval = this.Ability?.GetSpecialValueFor("QuickSlashInterval")!;
        this.QuickSlashCount = this.Ability?.GetSpecialValueFor("QuickSlashCount")!;
        this.StartIntervalThink(QuickSlashInterval);
        EmitGlobalSound(this.SoundSfx);
    }

    override OnIntervalThink(): void
    {
        if (!IsServer())
        {
            return;
        }

        if (this.SlashCount < this.QuickSlashCount)
        {
            this.DealDamage();
            ++this.SlashCount;
        }
        else
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

        this.PerformFinalSlash();
        this.ModifierIshanaDaitenshou?.IncrementStackCount();
    }

    DealDamage(): void
    {
        const QuickSlashMaxHpPercent = this.Ability?.GetSpecialValueFor("QuickSlashMaxHpPercent")! / 100;
        const Damage = this.Victim?.GetMaxHealth()! * QuickSlashMaxHpPercent;
        const DmgType = this.Ability?.GetAbilityDamageType()!;
        const DmgFlag = DamageFlag.NO_SPELL_AMPLIFICATION + DamageFlag.BYPASSES_INVULNERABILITY + DamageFlag.HPLOSS;
        
        ApplyDamage
        (
            {
                victim: this.Victim!,
                attacker: this.Caster!,
                damage: Damage,
                damage_type: DmgType,
                damage_flags: DmgFlag,
                ability: this.Ability!,
            }
        )
    }

    async PerformFinalSlash(): Promise<void>
    {
        const FinalSlashDmgDelay = this.Ability?.GetSpecialValueFor("FinalSlashDmgDelay")!;
        await Sleep(FinalSlashDmgDelay);
        const FinalSlashMaxHpPercent = this.Ability?.GetSpecialValueFor("FinalSlashMaxHpPercent")! / 100;
        const ExecuteThresholdPercent = this.Ability?.GetSpecialValueFor("ExecuteThresholdPercent")!;
        const Damage = this.Victim?.GetMaxHealth()! * FinalSlashMaxHpPercent;
        const DmgType = this.Ability?.GetAbilityDamageType()!;
        const DmgFlag = DamageFlag.NO_SPELL_AMPLIFICATION + DamageFlag.BYPASSES_INVULNERABILITY + DamageFlag.HPLOSS;

        ApplyDamage
        (
            {
                victim: this.Victim!,
                attacker: this.Caster!,
                damage: Damage,
                damage_type: DmgType,
                damage_flags: DmgFlag,
                ability: this.Ability!,
            }
        )

        this.CreateParticle();
        const CurrentHealth = this.Victim?.GetHealthPercent()!;
        
        if (CurrentHealth <= ExecuteThresholdPercent)
        {
            this.Victim?.Kill(this.Ability, this.Caster);
        }
        else
        {
            const CurrentHealthPercent = this.Victim?.GetHealthPercent()!;
            this.Victim?.AddNewModifier(this.Caster, this.Ability, musashi_modifier_ishana_daitenshou_debuff.name, {undefined});
            const NewHealth = this.Victim?.GetMaxHealth()! * CurrentHealthPercent / 100;
            this.Victim?.SetHealth(NewHealth);
        }
    }

    CreateParticle(): void
    {
        let ParticleStr = "particles/custom/musashi/musashi_ishana_daitenshou_slash_basic.vpcf";
        const StartPosition = this.ModifierIshanaDaitenshou?.StartPosition!;
        const EndPosition = this.Caster?.GetAbsOrigin()!;

        if (this.Caster?.HasModifier("modifier_ascended"))
        {
            ParticleStr = "particles/custom/musashi/musashi_ishana_daitenshou_slash_unique.vpcf";
            const PetalsParticleStr = "particles/custom/musashi/musashi_ishana_daitenshou_petals_unique.vpcf";
            const PetalsParticle = ParticleManager.CreateParticle(PetalsParticleStr, ParticleAttachment.WORLDORIGIN, this.Caster);
            ParticleManager.SetParticleControl(PetalsParticle, 0, EndPosition);
            ParticleManager.SetParticleControl(PetalsParticle, 2, EndPosition);
            ParticleManager.SetParticleControl(PetalsParticle, 3, StartPosition);
        }

        const Particle = ParticleManager.CreateParticle(ParticleStr, ParticleAttachment.WORLDORIGIN, this.Caster);
        ParticleManager.SetParticleControl(Particle, 0, StartPosition);
        ParticleManager.SetParticleControl(Particle, 1, EndPosition);
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
export class musashi_modifier_ishana_daitenshou_debuff extends BaseModifier
{
    override OnCreated(): void
    {
        if (!IsServer())
        {
            return;
        }
    }

    override GetModifierExtraHealthPercentage(): number
    {
        return this.GetAbility()?.GetSpecialValueFor("MaxHpReductionPercent")!;
    }

    override GetModifierIncomingDamage_Percentage(): number
    {
        return this.GetAbility()?.GetSpecialValueFor("ExtraIncomingDmgPercent")!;
    }

    override DeclareFunctions(): ModifierFunction[]
    {
        return [ModifierFunction.EXTRA_HEALTH_PERCENTAGE, ModifierFunction.INCOMING_DAMAGE_PERCENTAGE];
    }

    override IsPurgable(): boolean
    {
        return false;
    }
    
    override IsPurgeException(): boolean
    {
        return false;
    }

    override RemoveOnDeath(): boolean
    {
        return true;
    }
}

@registerModifier()
export class musashi_modifier_ishana_daitenshou_cooldown extends BaseModifier
{
    override OnCreated(): void
    {
        if (!IsServer())
        {
            return;
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

    override IsDebuff(): boolean
    {
        return true;
    }

    override RemoveOnDeath(): boolean
    {
        return false;
    }
}
