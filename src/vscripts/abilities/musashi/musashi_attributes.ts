/** @noSelfInFile **/
import { GetMaster1, InitSkillSlotChecker } from "@libs/skill_utils";
import { BaseAbility, BaseModifier, registerAbility, registerModifier } from "libs/dota_ts_adapter";
import * as musashi_ability from "./musashi_abilities";
import { BaseVectorAbility } from "@libs/vector_targeting_interface";

//======================================================================================================================
// Miyamoto Musashi - Attribute 1 - Battle Continuation
//======================================================================================================================
@registerAbility()
export class musashi_attributes_battle_continuation extends BaseAbility
{
    override OnSpellStart(): void
    {
        const Master2 = this.GetCaster();
        const Hero = Master2.GetPlayerOwner().GetAssignedHero();
        const Master1 = GetMaster1(Master2)!;
        Master1.SetMana(Master1.GetMana() - this.GetManaCost(-1));
        Hero.AddNewModifier(Master2, this, musashi_attribute_battle_continuation.name, {undefined});
    }
}

@registerModifier()
export class musashi_attribute_battle_continuation extends BaseModifier
{
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

    override RemoveOnDeath(): boolean
    {
        return false;
    }

    override IsHidden(): boolean
    {
        return true;
    }
}

//======================================================================================================================
// Miyamoto Musashi - Attribute 2 - Improve Tengan
//======================================================================================================================
@registerAbility()
export class musashi_attributes_improve_tengan extends BaseAbility
{
    override OnSpellStart(): void
    {
        const Master2 = this.GetCaster();
        const Hero = Master2.GetPlayerOwner().GetAssignedHero();
        const Master1 = GetMaster1(Master2)!;
        Master1.SetMana(Master1.GetMana() - this.GetManaCost(-1));
        Hero.AddNewModifier(Master2, this, musashi_attribute_improve_tengan.name, {undefined});
        InitSkillSlotChecker(Hero, musashi_ability.musashi_tengan.name, musashi_ability.musashi_tenma_gogan.name, 0.03);
    }
}

@registerModifier()
export class musashi_attribute_improve_tengan extends BaseModifier
{
    Caster: CDOTA_BaseNPC | undefined;

    override OnCreated(): void
    {
        this.Caster = this.GetParent();
        const TenganChargeCounter = this.Caster?.FindModifierByName(musashi_ability.musashi_modifier_tengan_chargecounter.name);
        TenganChargeCounter?.ForceRefresh();
    }

    override GetModifierOverrideAbilitySpecial(event: ModifierOverrideAbilitySpecialEvent): 0 | 1
    {
        const Tengan = this.Caster?.FindAbilityByName(musashi_ability.musashi_tengan.name);

        if (event.ability === Tengan)
        {
            if (event.ability_special_value === "BonusPureDmgPerAgi" || event.ability_special_value === "MaxCharges" || 
                event.ability_special_value === "RechargeTime")
            {
                return 1;
            }
        }

        return 0;
    }

    override GetModifierOverrideAbilitySpecialValue(event: ModifierOverrideAbilitySpecialEvent): number
    {
        const Ability = this.GetAbility();

        if (event.ability_special_value === "BonusPureDmgPerAgi")
        {
            return Ability?.GetSpecialValueFor("BonusPureDmgPerAgi")!;
        }
        else if (event.ability_special_value === "MaxCharges")
        {
            return Ability?.GetSpecialValueFor("MaxCharges")!;
        }
        else if (event.ability_special_value === "RechargeTime")
        {
            return Ability?.GetSpecialValueFor("RechargeTime")!;
        }

        return 0;
    }

    override DeclareFunctions(): ModifierFunction[]
    {
        return [ModifierFunction.OVERRIDE_ABILITY_SPECIAL, ModifierFunction.OVERRIDE_ABILITY_SPECIAL_VALUE];
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

    override RemoveOnDeath(): boolean
    {
        return false;
    }

    override IsHidden(): boolean
    {
        return true;
    }
}

//======================================================================================================================
// Miyamoto Musashi - Attribute 3 - Gorin No Sho
//======================================================================================================================
@registerAbility()
export class musashi_attributes_gorin_no_sho extends BaseAbility
{
    override OnSpellStart(): void
    {
        const Master2 = this.GetCaster();
        const Hero = Master2.GetPlayerOwner().GetAssignedHero();
        const Master1 = GetMaster1(Master2)!;
        Master1.SetMana(Master1.GetMana() - this.GetManaCost(-1));
        Hero.AddNewModifier(Master2, this, musashi_attribute_gorin_no_sho.name, {undefined});
    }
}

@registerModifier()
export class musashi_attribute_gorin_no_sho extends BaseModifier
{
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

    override RemoveOnDeath(): boolean
    {
        return false;
    }

    override IsHidden(): boolean
    {
        return true;
    }
}

//======================================================================================================================
// Miyamoto Musashi - Attribute 4 - Mukyuu
//======================================================================================================================
@registerAbility()
export class musashi_attributes_mukyuu extends BaseAbility
{
    override OnSpellStart(): void
    {
        const Master2 = this.GetCaster();
        const Hero = Master2.GetPlayerOwner().GetAssignedHero();
        const Master1 = GetMaster1(Master2)!;
        Master1.SetMana(Master1.GetMana() - this.GetManaCost(-1));
        Hero.SwapAbilities(musashi_ability.musashi_mukyuu.name, "fate_empty1", true, false);
        Hero.AddNewModifier(Master2, this, musashi_attribute_mukyuu.name, {undefined});
    }
}

@registerModifier()
export class musashi_attribute_mukyuu extends BaseModifier
{
    override GetModifierOverrideAbilitySpecial(event: ModifierOverrideAbilitySpecialEvent): 0 | 1
    {
        const Caster = this.GetParent();
        const Ability = Caster.FindAbilityByName(musashi_ability.musashi_niou_kurikara.name);

        if (event.ability === Ability)
        {
            if (event.ability_special_value === "DmgReducWhileChannel" || event.ability_special_value === "DmgReducFinishChannel" ||
                event.ability_special_value === "BuffDuration")
            {
                return 1;
            }
        }

        return 0;
    }

    override GetModifierOverrideAbilitySpecialValue(event: ModifierOverrideAbilitySpecialEvent): number
    {
        const Ability = this.GetAbility();

        if (event.ability_special_value === "DmgReducWhileChannel")
        {
            return Ability?.GetSpecialValueFor("DmgReducWhileChannel")!;
        }
        else if (event.ability_special_value === "DmgReducFinishChannel")
        {
            return Ability?.GetSpecialValueFor("DmgReducFinishChannel")!;
        }
        else if (event.ability_special_value === "BuffDuration")
        {
            return Ability?.GetSpecialValueFor("BuffDuration")!;
        }

        return 0;
    }

    override DeclareFunctions(): ModifierFunction[]
    {
        return [ModifierFunction.OVERRIDE_ABILITY_SPECIAL, ModifierFunction.OVERRIDE_ABILITY_SPECIAL_VALUE];
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

    override RemoveOnDeath(): boolean
    {
        return false;
    }

    override IsHidden(): boolean
    {
        return true;
    }
}

//======================================================================================================================
// Miyamoto Musashi - Attribute 5 - Niten Ichiryuu
//======================================================================================================================
@registerAbility()
export class musashi_attributes_niten_ichiryuu extends BaseAbility
{
    override OnSpellStart(): void
    {
        const Master2 = this.GetCaster();
        const Hero = Master2.GetPlayerOwner().GetAssignedHero();
        const Master1 = GetMaster1(Master2)!;
        Master1.SetMana(Master1.GetMana() - this.GetManaCost(-1));
        Hero.AddNewModifier(Master2, this, musashi_attribute_niten_ichiryuu.name, {undefined});
    }
}

@registerModifier()
export class musashi_attribute_niten_ichiryuu extends BaseModifier
{
    DaiGoSei: CDOTABaseAbility | undefined;
    GanryuuJima: BaseVectorAbility | undefined;

    override OnCreated(): void
    {
        const Caster = this.GetParent();
        this.DaiGoSei = Caster.FindAbilityByName(musashi_ability.musashi_dai_go_sei.name);
        this.GanryuuJima = Caster.FindAbilityByName(musashi_ability.musashi_ganryuu_jima.name) as musashi_ability.musashi_ganryuu_jima;
        this.GanryuuJima.UpdateVectorValues();
    }

    override GetModifierOverrideAbilitySpecial(event: ModifierOverrideAbilitySpecialEvent): 0 | 1
    {
        if (event.ability === this.DaiGoSei)
        {
            if (event.ability_special_value === "HitsRequired" || event.ability_special_value === "CriticalDmg")
            {
                return 1;
            }
        }
        else if (event.ability === this.GanryuuJima)
        {
            if (event.ability_special_value === "SlashRange" || event.ability_special_value === "SlashRadius" ||
                event.ability_special_value === "BonusDmgPerAgi")
            {
                return 1;
            }
        }

        return 0;
    }

    override GetModifierOverrideAbilitySpecialValue(event: ModifierOverrideAbilitySpecialEvent): number
    {
        const Ability = this.GetAbility();

        if (event.ability === this.DaiGoSei)
        {
            if (event.ability_special_value === "HitsRequired")
            {
                return Ability?.GetSpecialValueFor("HitsRequired")!;
            }
            else if (event.ability_special_value === "CriticalDmg")
            {
                return Ability?.GetSpecialValueFor("CriticalDmg")!;
            }
        }
        else if (event.ability === this.GanryuuJima)
        {
            if (event.ability_special_value === "SlashRange")
            {
                return Ability?.GetSpecialValueFor("SlashRange")!;
            }
            else if (event.ability_special_value === "SlashRadius")
            {
                return Ability?.GetSpecialValueFor("SlashRadius")!;
            }
            else if (event.ability_special_value === "BonusDmgPerAgi")
            {
                return Ability?.GetSpecialValueFor("BonusDmgPerAgi")!;
            }
        }

        return 0;
    }

    override DeclareFunctions(): ModifierFunction[]
    {
        return [ModifierFunction.OVERRIDE_ABILITY_SPECIAL, ModifierFunction.OVERRIDE_ABILITY_SPECIAL_VALUE];
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

    override RemoveOnDeath(): boolean
    {
        return false;
    }

    override IsHidden(): boolean
    {
        return true;
    }
}