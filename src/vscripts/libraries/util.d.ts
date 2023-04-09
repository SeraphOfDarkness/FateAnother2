/** @noSelfInFile */
declare function giveUnitDataDrivenModifier(Caster: CDOTA_BaseNPC, Target: CDOTA_BaseNPC, ModifierName: string, Duration: number):void;
declare function DoDamage(Caster: CDOTA_BaseNPC, Target: CDOTA_BaseNPC, Damage: number, DmgType: DamageTypes, 
                          DmgFlag: DamageFlag, Ability: CDOTABaseAbility, IsLoop: boolean): void;
declare function IsRevivePossible(Caster: CDOTA_BaseNPC): boolean;