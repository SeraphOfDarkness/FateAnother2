/** @noSelfInFile **/
import { BaseModifier, registerModifier } from "./dota_ts_adapter"

//======================================================================================================================
// Skill Slot Checker
//======================================================================================================================
export function InitSkillSlotChecker(Caster: CDOTA_BaseNPC, OriSkillStr: string, TargetSkillStr: string, Timeout: number, 
                                     SwapBackIfCasted ?: boolean): void
{
    if (!IsServer() || Caster.HasModifier(Modifier_Skill_Slot_Checker.name))
    {
        return;
    }

    const OriSkill = Caster.FindAbilityByName(OriSkillStr);
    const TargetSkill = Caster.FindAbilityByName(TargetSkillStr);
    const ModifierSkillSlotChecker = Caster.AddNewModifier(Caster, undefined, Modifier_Skill_Slot_Checker.name, 
                                     {duration : Timeout}) as Modifier_Skill_Slot_Checker;
    ModifierSkillSlotChecker.OriSkill = OriSkill;
    ModifierSkillSlotChecker.TargetSkill = TargetSkill;
    ModifierSkillSlotChecker.OriSkillIndex = OriSkill?.GetAbilityIndex()!;
    ModifierSkillSlotChecker.SwapBackIfCasted = SwapBackIfCasted ?? true;
    Caster.SwapAbilities(OriSkillStr, TargetSkillStr, false, true);
}

@registerModifier()
export class Modifier_Skill_Slot_Checker extends BaseModifier
{
    OriSkill : CDOTABaseAbility | undefined;
    TargetSkill : CDOTABaseAbility | undefined;
    OriSkillIndex : number = 0;
    SwapBackIfCasted : boolean = true;

    override OnAbilityFullyCast(event: ModifierAbilityEvent): void
    {
        if (!IsServer())
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
            this.GetParent().SwapAbilities(this.OriSkill?.GetName()!, this.TargetSkill?.GetName()!, true, false);
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

    const ModifierComboSequence = Caster.AddNewModifier(Caster, undefined, Modifier_Combo_Sequence.name, 
                                  {duration: Timeout}) as Modifier_Combo_Sequence;
    ModifierComboSequence.SkillsSequence = SkillsSequence;
    ModifierComboSequence.OriSkillStr = OriSkillStr;
    ModifierComboSequence.ComboSkillStr = ComboSkillStr;
}

@registerModifier()
export class Modifier_Combo_Sequence extends BaseModifier
{
    SkillsSequence: string[] | undefined;
    OriSkillStr: string | undefined;
    ComboSkillStr: string | undefined;

    override OnAbilityFullyCast(event: ModifierAbilityEvent): void
    {
        if (!IsServer())
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
            const Caster = this.GetCaster()!;
            InitSkillSlotChecker(Caster, this.OriSkillStr!, this.ComboSkillStr!, this.GetRemainingTime(), true);
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
