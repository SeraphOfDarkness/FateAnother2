/** @noSelfInFile **/
import { BaseModifier, registerModifier } from "./dota_ts_adapter"

//======================================================================================================================
// Skill Slot Checker
//======================================================================================================================
export function InitSkillSlotChecker(Caster: CDOTA_BaseNPC, OriSkillStr: string, TargetSkillStr: string, Timeout: number, 
                                     SwapBackIfCasted ?: boolean): void
{
    if (!IsServer())
    {
        return;
    }

    const OriSkill = Caster.FindAbilityByName(OriSkillStr);
    const TargetSkill = Caster.FindAbilityByName(TargetSkillStr);
    const CurrentInstances = Caster.FindAllModifiersByName(modifier_skill_slot_checker.name);
    const CurrentInstance = CurrentInstances.find(Instance => Instance.GetAbility()?.GetName() === OriSkillStr);

    if (CurrentInstance)
    {
        CurrentInstance.Destroy();
    }
    
    const ModifierSkillSlotChecker = Caster.AddNewModifier(Caster, OriSkill, modifier_skill_slot_checker.name, 
                                     {duration : Timeout}) as modifier_skill_slot_checker;
    ModifierSkillSlotChecker.OriSkill = OriSkill;
    ModifierSkillSlotChecker.TargetSkill = TargetSkill;
    ModifierSkillSlotChecker.OriSkillIndex = OriSkill?.GetAbilityIndex()!;
    ModifierSkillSlotChecker.SwapBackIfCasted = SwapBackIfCasted ?? true;
    Caster.SwapAbilities(OriSkillStr, TargetSkillStr, false, true);
}

@registerModifier()
export class modifier_skill_slot_checker extends BaseModifier
{
    OriSkill : CDOTABaseAbility | undefined;
    TargetSkill : CDOTABaseAbility | undefined;
    OriSkillIndex : number = 0;
    SwapBackIfCasted : boolean = true;

    override OnAbilityFullyCast(event: ModifierAbilityEvent): void
    {
        if (!IsServer() || event.unit != this.GetCaster())
        {
            return;
        }

        if (event.ability === this.TargetSkill && this.SwapBackIfCasted)
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

        const CurrentSkillIndex = this.OriSkill?.GetAbilityIndex();

        if (CurrentSkillIndex != this.OriSkillIndex)
        {
            this.GetCaster()?.SwapAbilities(this.OriSkill?.GetName()!, this.TargetSkill?.GetName()!, true, false);
        }
    }

    override DeclareFunctions(): ModifierFunction[]
    {
        return [ModifierFunction.ON_ABILITY_FULLY_CAST];
    }

    override IsHidden(): boolean
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

    override RemoveOnDeath(): boolean
    {
        return false;
    }

    override GetAttributes(): ModifierAttribute
    {
        return ModifierAttribute.MULTIPLE;
    }
}

//======================================================================================================================
// Combo Stats Checker
//======================================================================================================================
export function CheckComboStatsFulfilled(Caster: CDOTA_BaseNPC): boolean
{
    if (!IsServer())
    {
        return false;
    }

    const Hero = Caster as CDOTA_BaseNPC_Hero;
    const StatsRequired = 25;
    const CurrentStr = Hero.GetStrength();
    const CurrentAgi = Hero.GetAgility();
    const CurrentInt = Hero.GetIntellect();

    if (CurrentStr >= StatsRequired && CurrentAgi >= StatsRequired && CurrentInt >= StatsRequired)
    {
        return true;
    }

    return false;
}

//======================================================================================================================
// Combo Sequence Checker
//======================================================================================================================
export function InitComboSequenceChecker(Caster: CDOTA_BaseNPC, SkillsSequence: string[], OriSkillStr: string, 
                                         ComboSkillStr: string, Timeout: number): void
{
    if (!IsServer())
    {
        return;
    }

    const OriSkill = Caster.FindAbilityByName(OriSkillStr);
    const ModifierComboSequence = Caster.AddNewModifier(Caster, OriSkill, modifier_combo_sequence.name, 
                                  {duration: Timeout}) as modifier_combo_sequence;
    ModifierComboSequence.SkillsSequence = SkillsSequence;
    ModifierComboSequence.OriSkillStr = OriSkillStr;
    ModifierComboSequence.ComboSkillStr = ComboSkillStr;
}

@registerModifier()
export class modifier_combo_sequence extends BaseModifier
{
    Caster: CDOTA_BaseNPC | undefined;
    Abilities: CDOTABaseAbility[] = [];

    SkillsSequence: string[] | undefined;
    OriSkillStr: string | undefined;
    ComboSkillStr: string | undefined;

    override OnCreated(): void
    {
        if (!IsServer())
        {
            return;
        }

        this.Caster = this.GetCaster();
        const AbilityCount = this.Caster?.GetAbilityCount()!;

        for (let i = 0; i < AbilityCount; ++i)
        {
            const Ability = this.Caster?.GetAbilityByIndex(i)!;
            this.Abilities?.push(Ability);
        }
    }

    override OnAbilityFullyCast(event: ModifierAbilityEvent): void
    {
        if (!IsServer() || event.unit != this.Caster)
        {
            return;
        }

        const AbilityIndex = this.Abilities?.indexOf(event.ability);
        
        if (AbilityIndex === -1)
        {
            return;
        }
        
        const StackCount = this.GetStackCount();

        if (event.ability.GetName() === this.SkillsSequence![StackCount])
        {
            this.IncrementStackCount();
        }
        else
        {
            this.Destroy();
        }
    }

    override OnStackCountChanged(stackCount: number): void
    {
        if (!IsServer())
        {
            return;
        }

        if (stackCount === this.SkillsSequence?.length! - 1)
        {
            InitSkillSlotChecker(this.Caster!, this.OriSkillStr!, this.ComboSkillStr!, this.GetRemainingTime(), true);
        }
    }

    override DeclareFunctions(): ModifierFunction[]
    {
        return [ModifierFunction.ON_ABILITY_FULLY_CAST];
    }

    override IsHidden(): boolean
    {
        return false;
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

    override GetTexture(): string
    {
        return "custom/utils/ComboSequence";
    }
}

//======================================================================================================================
// Get Master1
//======================================================================================================================
export function GetMaster1(Master2: CDOTA_BaseNPC): CDOTA_BaseNPC | undefined
{
    if (!IsServer())
    {
        return;
    }

    const TargetFlags = UnitTargetFlags.INVULNERABLE + UnitTargetFlags.PLAYER_CONTROLLED;
    const Units = FindUnitsInRadius(Master2.GetTeam(), Master2.GetAbsOrigin(), undefined, 400, UnitTargetTeam.FRIENDLY, 
                                    UnitTargetType.ALL, TargetFlags, FindOrder.CLOSEST, false);
    return Units.find(Unit => Unit.GetUnitName() === "master_1" && Unit.GetPlayerOwner() === Master2.GetPlayerOwner());
}

//======================================================================================================================
// Apply SA when hero revived
//======================================================================================================================
export function ApplySaWhenRevived(Master2: CDOTA_BaseNPC, AttributeAbility: CDOTABaseAbility, AttributeModifier: string): void
{
    if (!IsServer())
    {
        return;
    }

    const ModifierHeroAliveChecker = Master2.AddNewModifier(Master2, AttributeAbility, modifier_hero_alive_checker.name, {undefined}) as 
                                     modifier_hero_alive_checker;
    ModifierHeroAliveChecker.AttributeAbility = AttributeAbility;
    ModifierHeroAliveChecker.AttributeModifier = AttributeModifier;
}

@registerModifier()
export class modifier_hero_alive_checker extends BaseModifier
{
    Master2: CDOTA_BaseNPC | undefined;
    Hero: CDOTA_BaseNPC | undefined;
    AttributeAbility: CDOTABaseAbility | undefined;
    AttributeModifier: string = "";
    
    override OnCreated(): void
    {
        if (!IsServer())
        {
            return;
        }

        this.Master2 = this.GetCaster();
        this.Hero = this.Master2?.GetPlayerOwner().GetAssignedHero();
        this.StartIntervalThink(0.1);
    }

    override OnIntervalThink(): void
    {
        if (!IsServer())
        {
            return;
        }

        if (this.Hero?.IsAlive())
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

        this.Hero?.AddNewModifier(this.Master2, this.AttributeAbility, this.AttributeModifier, {undefined});
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

    override IsPermanent(): boolean
    {
        return true;
    }

    override GetAttributes(): ModifierAttribute
    {
        return ModifierAttribute.MULTIPLE;
    }
}