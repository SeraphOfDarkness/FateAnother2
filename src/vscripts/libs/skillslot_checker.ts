import "./dota_ts_adapter"
import { BaseModifier, registerModifier } from "./dota_ts_adapter"

export function SkillSlotChecker(Caster : CDOTA_BaseNPC, OriSkillStr : string, TargetSkillStr: string, Timeout: number, SwapBackIfCasted ?: boolean): void
{
    const OriSkill = Caster.FindAbilityByName(OriSkillStr);
    const TargetSkill = Caster.FindAbilityByName(TargetSkillStr);
    const CheckerBuff = Caster.AddNewModifier(Caster, OriSkill, Modifier_Skill_Slot_Checker.name, {duration : Timeout}) as Modifier_Skill_Slot_Checker;

    CheckerBuff.OriSkill = OriSkill;
    CheckerBuff.TargetSkill = TargetSkill;
    CheckerBuff.OriSkillIndex = OriSkill?.GetAbilityIndex()!;
    CheckerBuff.SwapBackIfCasted = SwapBackIfCasted ?? true;
    Caster.SwapAbilities(OriSkillStr, TargetSkillStr, false, true);
    CheckerBuff.StartIntervalThink(0.1);
}

@registerModifier()
export class Modifier_Skill_Slot_Checker extends BaseModifier
{
    OriSkill : CDOTABaseAbility | undefined;
    TargetSkill : CDOTABaseAbility | undefined;
    OriSkillIndex : number = 0;
    SwapBackIfCasted : boolean = true;

    override OnIntervalThink(): void
    {
        if (!IsServer())
        {
            return;
        }

        if (this.SwapBackIfCasted)
        {
            if (!this.TargetSkill?.IsCooldownReady())
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

        const CurrentSkillIndex = this.GetParent().FindAbilityByName(this.OriSkill?.GetName()!)?.GetAbilityIndex();

        if (CurrentSkillIndex != this.OriSkillIndex)
        {
            this.GetParent().SwapAbilities(this.OriSkill?.GetName()!, this.TargetSkill?.GetName()!, true, false);
        }
    }

    override IsHidden(): boolean
    {
        return true;
    }
}