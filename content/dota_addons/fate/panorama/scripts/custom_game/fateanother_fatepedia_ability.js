var heroes = [
	"npc_dota_hero_legion_commander",
	"npc_dota_hero_spectre",
	"npc_dota_hero_phantom_lancer",
	"npc_dota_hero_ember_spirit",
	"npc_dota_hero_templar_assassin",
	"npc_dota_hero_crystal_maiden",
	"npc_dota_hero_juggernaut",
	"npc_dota_hero_bounty_hunter",
	"npc_dota_hero_doom_bringer",
	"npc_dota_hero_skywrath_mage",
	"npc_dota_hero_vengefulspirit",
	"npc_dota_hero_huskar",
	"npc_dota_hero_sven",
	"npc_dota_hero_shadow_shaman",
	"npc_dota_hero_chen",
	"npc_dota_hero_lina",
	"npc_dota_hero_omniknight",
	"npc_dota_hero_enchantress",
	"npc_dota_hero_bloodseeker",
	"npc_dota_hero_mirana",
	"npc_dota_hero_queenofpain",
	"npc_dota_hero_windrunner",
	"npc_dota_hero_drow_ranger",
	"npc_dota_hero_tidehunter",
	"npc_dota_hero_beastmaster",
	"npc_dota_hero_riki",
	"npc_dota_hero_naga_siren",
	"npc_dota_hero_dark_willow",
	"npc_dota_hero_troll_warlord",
	"npc_dota_hero_monkey_king",
	"npc_dota_hero_tusk",
	"npc_dota_hero_zuus",
	"npc_dota_hero_axe",
	"npc_dota_hero_death_prophet",
	"npc_dota_hero_enigma",
	"npc_dota_hero_night_stalker",
	"npc_dota_hero_disruptor",
	"npc_dota_hero_skeleton_king",
	"npc_dota_hero_necrolyte",
	"npc_dota_hero_sniper",
	"npc_dota_hero_phantom_assassin",
]

var names = [
	"Artoria Pendragon",
	"Artoria Alter",
	"Cu Chulainn",
	"Emiya Shirou",
	"Medusa",
	"Medea",
	"Sasaki Kojiro",
	"Hassan-i-Sabbah",
	"Heracles",
	"Gilgamesh",
	"Angra Mainyu",
	"Diarmuid",
	"Lancelot",
	"Gilles de Rais",
	"Iskandar",
	"Nero Claudius",
	"Gawain",
	"Tamamo no Mae",
	"Li Shuwen",
	"Jeanne d'Arc",
	"Astolfo",
	"Nursery Rhyme",
	"Atalanta",
	"Vlad III",
	"Karna",
	"Jack The Ripper",
	"Chloe von Einzbern",
	"Okita Souji",
	"Francis Drake",
	"Scathach",
	"Mordred",
	"Frankenstein",
	"Lu Bu",
	"Elizabeth Bathory",
	"Amakusa Shirou Tokisada",
	"Edmond Dantes",
	"Zhuge Liang",
	"King Hassan",
	"Hans Christian Andersen",
	"Robin Hood",
	"Semiramis",
]


var abilities = [
	["saber_invisible_air", "saber_caliburn", "saber_avalon", "saber_charisma", "saber_instinct", "saber_excalibur"],
	["saber_alter_derange", "saber_alter_mana_burst", "saber_alter_vortigern", "saber_alter_mana_shroud", "saber_alter_unleashed_ferocity", "saber_alter_excalibur"],
	["lancer_rune_magic", "lancer_relentless_spear", "lancer_gae_bolg", "fate_empty1", "lancer_battle_continuation", "lancer_gae_bolg_jump"],
	["archer_kanshou_byakuya", "archer_broken_phantasm", "archer_crane_wing", "fate_empty1", "archer_clairvoyance", "archer_unlimited_bladeworks_chant"],
	["medusa_nail_swing", "medusa_highspeed", "medusa_breaker_gorgon", "medusa_bloodfort_andromeda", "medusa_mystic_eye", "medusa_bellerophon"],
	["medea_argos", "medea_ancient_magic", "medea_rule_breaker", "medea_territory_creation", "medea_item_construction", "medea_hecatic_graea"],
	["sasaki_gatekeeper", "sasaki_heart_of_harmony", "sasaki_windblade", "sasaki_minds_eye", "fate_empty1", "sasaki_tsubame_gaeshi"],
	["hassan_ambush", "hassan_self_modification", "hassan_snatch_strike", "hassan_dirk", "hassan_presence_concealment", "hassan_zabaniya"],
	["heracles_fissure_strike", "heracles_courage", "heracles_berserk", "fate_empty1", "fate_empty8", "heracles_nine_lives"],
	["gilgamesh_enkidu", "gilgamesh_sword_barrage", "gilgamesh_gate_of_babylon", "gilgamesh_golden_rule", "gilgamesh_gram", "gilgamesh_enuma_elish"],
	["avenger_murderous_instinct", "avenger_tawrich_zarich", "avenger_true_form", "fate_empty1", "avenger_dark_passage", "avenger_verg_avesta"],
	["diarmuid_warriors_charge", "diarmuid_double_spearsmanship", "diarmuid_gae_buidhe", "diarmuid_love_spot", "diarmuid_minds_eye", "diarmuid_gae_dearg" ],
	["lancelot_gatling", "lancelot_double_edge", "lancelot_knight_of_honor", "fate_empty1", "lancelot_eternal_arms_mastership", "lancelot_arondite" ],
	["gilles_summon_jellyfish", "gilles_rlyeh_text_open", "gilles_cthulhu_favour", "gilles_prelati_spellbook", "fate_empty1", "gilles_abyssal_contract"],
	["iskandar_forward", "iskandar_phalanx", "iskandar_gordius_wheel", "iskandar_charisma", "fate_empty1", "iskandar_army_of_the_king"],
	["nero_tres_fontaine_ardent", "nero_gladiusanus_blauserum", "nero_rosa_ichthys", "fate_empty1", "nero_imperial_privilege", "nero_aestus_domus_aurea"],
	["gawain_blade_of_the_devoted", "gawain_light_of_galatine", "gawain_sun_of_galatine", "fate_empty1", "fate_empty8", "gawain_excalibur_galatine"],
	["tamamo_soulstream", "tamamo_subterranean_grasp", "tamamo_mantra", "fate_empty1", "tamamo_curse_charm", "tamamo_amaterasu"],
	["lishuwen_sphere_boundary", "lishuwen_cosmic_orbit", "lishuwen_tiger_strike", "lishuwen_martial_arts", "fate_empty1", "lishuwen_no_second_strike"],
	["jeanne_charisma", "jeanne_purge_the_unjust", "jeanne_gods_resolution", "jeanne_magic_resistance_ex", "jeanne_saint", "jeanne_luminosite_eternelle"],
	["astolfo_hippogriff_vanish", "astolfo_trap_of_argalia", "astolfo_la_black_luna", "fate_empty1", "astolfo_casa_di_logistilla", "astolfo_hippogriff_raid"],
	["nursery_rhyme_white_queens_enigma", "nursery_rhyme_the_plains_of_water", "nursery_rhyme_doppelganger", "nursery_rhyme_shapeshift", "nursery_rhyme_nameless_forest", "nursery_rhyme_queens_glass_game"],
	["atalanta_celestial_arrow", "atalanta_calydonian_hunt", "atalanta_tauropolos", "atalanta_crossing_arcadia" , "fate_empty1", "atalanta_phoebus_catastrophe_barrage"],
	["vlad_rebellious_intent", "vlad_ceremonial_purge", "vlad_cursed_lance", "vlad_transfusion", "vlad_battle_continuation", "vlad_kazikli_bey"],
	["karna_agni", "karna_brahmastra", "karna_brahmastra_kundala", "fate_empty1", "karna_kavacha_kundala", "karna_vasavi_shakti"],
	["jtr_dagger_throw", "jtr_quick_strikes", "jtr_the_mist", "fate_empty1", "jtr_surgery", "jtr_maria_the_ripper"],
	["kuro_kanshou_byakuya", "kuro_calabolg", "kuro_projection", "kuro_sharing_pain", "kuro_clairvoyance", "kuro_triple_link_crane_wing"],
	["okita_shukuchi", "okita_tennen", "okita_hira_seigan", "okita_flag_of_sincerity", "okita_weak_constitution", "okita_sandanzuki"],
	["drake_pistol", "drake_dance_macabre_1", "drake_support_bombard", "drake_military_tactic", "drake_voyager_of_storm", "drake_golden_wild_hunt"],
	["scathach_red_wind", "scathach_spearmanship", "scathach_gae_bolg", "fate_empty1", "scathach_rune_mage", "scathach_gae_bolg_jump"],
	["mordred_slash", "mordred_mana_burst_hit", "mordred_rush", "mordred_pedigree", "mordred_mb_lightning", "mordred_clarent"],
	["fran_lightning_shot", "fran_brutal_smash", "fran_electric_field", "fate_empty1", "fran_galvanism", "fran_blasted_tree"],
	["lubu_circular_blade", "lubu_fallible_bow", "lubu_bravary", "lubu_rebel", "fate_empty1", "lubu_god_force"],
	["bathory_fly", "bathory_tail_slap", "bathory_iron_maiden", "bathory_battle_continuation", "bathory_innocent", "bathory_dragon_cry"],
	["amakusa_set", "amakusa_bombard", "amakusa_god_resolution", "amakusa_black_key_passive", "fate_empty1", "amakusa_right_hand"],
	["edmond_dark_beam", "edmond_shadow_strike", "edmond_thunder", "edmond_lord_of_vengeance", "fate_empty1", "edmond_monte_cristo"],
	["zhuge_liang_laser", "zhuge_liang_strat_command", "zhuge_liang_war_command", "zhuge_liang_alchemist", "zhuge_liang_discern_eye", "zhuge_liang_array"],
	["kinghassan_death_approaching", "kinghassan_dreadful_slash", "kinghassan_evening_bell", "kinghassan_flames_of_gehenna", "fate_empty1", "kinghassan_azrael"],
	["hans_incantation", "hans_nightingale", "hans_masterpiece_open", "fate_empty1", "hans_territory", "hans_biography"],
	["robin_saboteur_open", "robin_paralyzing_arrow", "robin_roots" , "robin_faceless_king" , "robin_clairvoyance", "robin_yew_bow"],
	["semiramis_binding_chains", "semiramis_barrier", "semiramis_beam_bombard" , "semiramis_dual_class" , "fate_empty1", "semiramis_hanging_gardens"]
]

var attributes = [
	["saber_attribute_improve_excalibur", "saber_attribute_improve_instinct", "saber_attribute_strike_air", "saber_attribute_everdistant_utopia", "saber_attribute_chivalry"],
	["saber_alter_attribute_mana_shroud", "saber_alter_attribute_mana_blast","saber_alter_attribute_improve_ferocity","saber_alter_attribute_ultimate_darklight"],
	["lancer_attribute_improve_battle_continuation", "lancer_attribute_protection_from_arrows", "lancer_attribute_death_flight", "lancer_attribute_the_heartseeker","lancer_attribute_celtic_runes"],
	["archer_attribute_eagle_eye","archer_attribute_hrunting","archer_attribute_shroud_of_martin","archer_attribute_improve_projection","archer_attribute_overedge"],
	["medusa_attribute_improve_mystic_eyes", "medusa_attribute_riding", "medusa_attribute_seal", "medusa_attribute_monstrous_strength"],
	["medea_attribute_improve_territory_creation", "medea_attribute_improve_argos", "medea_attribute_witchcraft", "medea_attribute_dagger_of_treachery"],
	["sasaki_attribute_ganryu", "sasaki_attribute_katana_of_the_forgotten", "sasaki_attribute_vitrification", "sasaki_attribute_improve_minds_eye"],
	["hassan_attribute_improve_presence_concealment", "hassan_attribute_protection_from_wind", "hassan_attribute_weakening_venom", "hassan_attribute_shadow_strike", "hassan_attribute_shaytan_arm"],
	["heracles_attribute_eternal_rage", "heracles_attribute_god_hand", "heracles_attribute_reincarnation", "heracles_attribute_mad_enhancement"],
	["gilgamesh_attribute_improve_golden_rule", "gilgamesh_attribute_power_of_sumer", "gilgamesh_attribute_rain_of_swords", "gilgamesh_attribute_sword_of_creation"],
	["avenger_attribute_improve_dark_passage", "avenger_attribute_demon_incarnate", "avenger_attribute_end_of_four_nights", "avenger_attribute_world_evil", "avenger_attribute_avenger"],
	["diarmuid_attribute_improve_love_spot", "diarmuid_attribute_improve_minds_eye", "diarmuid_attribute_golden_rose_of_mortality", "diarmuid_attribute_crimson_rose_of_exorcism","diarmuid_attribute_double_spear_strike"],
	["lancelot_attribute_improve_eternal", "lancelot_attribute_blessing_of_fairy", "lancelot_attribute_improve_knight_of_owner","lancelot_attribute_knight_of_owner_arsenal", "lancelot_attribute_kotl"],
	["gilles_eye_for_art_attribute", "gilles_outer_god_attribute", "gilles_demonic_horde_attribute", "gilles_sunken_city_attribute", "gilles_abyssal_connection_attribute"],
	["iskandar_attribute_improve_charisma", "iskandar_attribute_thundergods_wrath", "iskandar_attribute_via_expugnatio", "iskandar_attribute_bond_beyond_time"],
	["nero_attribute_pari_tenu_blauserum", "nero_attribute_improve_imperial_privilege", "nero_attribute_invictus_spiritus", "nero_attribute_soverigns_glory", "nero_attribute_aestus_estus"],
	["gawain_attribute_blessing_of_fairy", "gawain_attribute_nightless_charisma", "gawain_attribute_numeral_saint", "gawain_attribute_belt", "gawain_attribute_kots"],
	["tamamo_attribute_spirit_theft", "tamamo_attribute_mystic_shackle", "tamamo_attribute_polygamist", "tamamo_attribute_witchcraft", "tamamo_attribute_territory"],
	["lishuwen_attribute_circulatory_shock", "lishuwen_attribute_improve_martial_arts", "lishuwen_attribute_dual_class", "lishuwen_attribute_furious_chain"],
	["jeanne_attribute_identity_discernment", "jeanne_attribute_improve_saint", "jeanne_attribute_punishment", "jeanne_attribute_divine_symbol", "jeanne_attribute_revelation"],
	["astolfo_attribute_riding", "astolfo_attribute_monstrous_strength", "astolfo_attribute_independent_action", "astolfo_attribute_sanity", "astolfo_attribute_deafening_blast"],
	["nursery_rhyme_attribute_forever_together","nursery_rhyme_attribute_nightmare","nursery_rhyme_attribute_reminiscence","nursery_rhyme_attribute_improve_queens_glass_game"],
	["atalanta_attribute_arrows_of_the_big_dipper", "atalanta_attribute_hunters_mark", "atalanta_attribute_crossing_arcadia_plus","atalanta_attribute_calydonian_snipe"],
	["vlad_attribute_innocent_monster", "vlad_attribute_protection_of_faith", "vlad_attribute_improved_impaling", "vlad_attribute_instant_curse", "vlad_attribute_bloodletter"],
	["karna_attribute_poor", "karna_attribute_ucm", "karna_attribute_mana_burst", "karna_attribute_indra"],
	["jtr_attribute_information_erase", "jtr_attribute_mental_pollution", "jtr_attribute_soul_eater", "jtr_attribute_murderer_on_misty_night", "jtr_attribute_holy_mother"],
	["kuro_attribute_overedge", "kuro_attribute_improve_projection", "kuro_attribute_kuro_magic", "kuro_attribute_hrunting", "kuro_attribute_eagle_eye"],
	["okita_attribute_kyokuji", "okita_attribute_persistence", "okita_attribute_peerless", "okita_attribute_mind_eye", "okita_attribute_kiku_ichimonji"],
	["drake_attribute_improve_military_tactic", "drake_attribute_pioneer", "drake_attribute_logbook", "drake_attribute_strengthen_golden_hind"],
	["scathach_attribute_primeval_rune", "scathach_attribute_god_slayer", "scathach_attribute_branch_tonelico", "scathach_attribute_wisdom_of_haunt_ground","scathach_attribute_immortal"],
	["mordred_attribute_curse", "mordred_attribute_bc", "mordred_attribute_pedigree", "mordred_attribute_rampage", "mordred_attribute_overload"],
	["fran_attribute_bridal_chest", "fran_attribute_mad_enhancement", "fran_attribute_overload", "fran_attribute_lament", "fran_attribute_improve_galvanism"],
	["lubu_attribute_houtengageki", "lubu_attribute_mad_enhancement", "lubu_attribute_dragon_tongue", "lubu_attribute_ruthless_warrior", "lubu_attribute_immortal"],
	["bathory_attribute_territory", "bathory_attribute_dragon_breath", "bathory_attribute_mental", "bathory_attribute_sadism_charisma", "bathory_attribute_torture"],
	["amakusa_attribute_left_hand", "amakusa_attribute_identify", "amakusa_attribute_church", "amakusa_attribute_anti_ruler"],
	["edmond_attribute_avenger", "edmond_attribute_determination", "edmond_attribute_wisdom", "edmond_attribute_esperer", "edmond_attribute_improve_monte"],
	["zhuge_liang_attribute_territory", "zhuge_liang_attribute_alchemist", "zhuge_liang_attribute_stratagems", "zhuge_liang_attribute_letter", "zhuge_liang_attribute_discern_eye"],
	["kinghassan_attribute_oldman", "kinghassan_attribute_presence", "kinghassan_attribute_abyss", "kinghassan_attribute_boundary", "kinghassan_attribute_body"],
	["hans_attribute_territory", "hans_attribute_write_thumbelina", "hans_attribute_human_observation", "hans_attribute_refine_nightingale", "hans_attribute_love_letter"],
	["robin_attribute_subversive", "robin_attribute_righteous_thief", "robin_attribute_faceless", "robin_attribute_guerilla", "robin_attribute_taxine"],
	["semiramis_attribute_dual_class", "semiramis_attribute_territory", "semiramis_attribute_absolute", "semiramis_attribute_charmer"]
]

var comboes = [
	"saber_max_excalibur",
	"saber_alter_max_mana_burst",
	"lancer_wesen_gae_bolg",
	"archer_arrow_rain",
	"medusa_bellerophon_2",
	"medea_hecatic_graea_powered",
	"sasaki_hiken_enbu",
	"hassan_combo",
	"heracles_madmans_roar",
	"gilgamesh_max_enuma_elish",
	"avenger_combo_endless_loop",
	"diarmuid_rampant_warrior",
	"lancelot_nuke",
	"gille_larret_de_mort",
	"iskandar_annihilate",
	"nero_laus_saint_claudius",
	"gawain_combo_excalibur_galatine",
	"tamamo_combo",
	"lishuwen_raging_dragon_strike",
	"jeanne_la_pucelle",
	"astolfo_hippogriff_ride",
	"nursery_rhyme_story_for_somebodys_sake",
	"atalanta_phoebus_catastrophe_snipe",
	"vlad_combo",
	"karna_combo_vasavi",
	"jtr_whitechapel",
	"kuro_fake_ubw",
	"okita_zekken",
	"drake_combo_golden_wild_hunt",
	"scathach_combo_gate_of_sky",
	"mordred_mmb_lightning",
	"fran_combo_blasted_tree",
	"lubu_combo_god_force",
	"bathory_combo_fresh_blood",
	"amakusa_twin_arm",
	"edmond_chateau",
	"zhuge_liang_combo",
	"kinghassan_combo",
	"hans_combo",
	"robin_combo",
	"semiramis_combo"
]

var guidelinks = [
	"https://fateanother-ii.fandom.com/wiki/Artoria_Pendragon_(Saber)",
	"https://fateanother-ii.fandom.com/wiki/Artoria_Pendragon_Alter_(Dark_Saber)",
	"https://fateanother-ii.fandom.com/wiki/Cu_Chulainn_(Lancer)",
	"https://fateanother-ii.fandom.com/wiki/Emiya_Shirou_(Archer)",
	"https://fateanother-ii.fandom.com/wiki/Medusa_(Rider)",
	"http://fa-d2.wikia.com/wiki/Caster#Gameplay",
	"http://fa-d2.wikia.com/wiki/False_Assassin#Gameplay",
	"http://fa-d2.wikia.com/wiki/True_Assassin#Gameplay",
	"http://fa-d2.wikia.com/wiki/Berserker#Gameplay",
	"https://fateanother-ii.fandom.com/wiki/Gilgamesh_(Archer)",
	"http://fa-d2.wikia.com/wiki/Avenger#Gameplay",
	"http://fa-d2.wikia.com/wiki/Diarmuid#Gameplay",
	"http://fa-d2.wikia.com/wiki/Lancelot#Gameplay",
	"http://fa-d2.wikia.com/wiki/Gilles_de_Rais#Gameplay",
	"http://fa-d2.wikia.com/wiki/Iskander#Gameplay",
	"http://fa-d2.wikia.com/wiki/Nero#Gameplay",
	"http://fa-d2.wikia.com/wiki/Saber_(Gawain)#Gameplay",
	"http://fa-d2.wikia.com/wiki/Tamamo_no_Mae#Gameplay",
	"http://fa-d2.wikia.com/wiki/Assassin_%28Li_Shu_Wen%29#Gameplay",
	"https://fateanother-ii.fandom.com/wiki/Jeanne_d%27Arc_(Ruler)",
	"http://fa-d2.wikia.com/wiki/Jeanne_d%27Arc#Gameplay",
	"http://fa-d2.wikia.com/wiki/Rider_of_Black#Gameplay",
	"http://fa-d2.wikia.com/wiki/Jeanne_d%27Arc#Gameplay",
	"http://fa-d2.wikia.com/wiki/Jeanne_d%27Arc#Gameplay",
	"http://fa-d2.wikia.com/wiki/Jeanne_d%27Arc#Gameplay",
	"http://fa-d2.wikia.com/wiki/Jeanne_d%27Arc#Gameplay",
	"http://fa-d2.wikia.com/wiki/Jeanne_d%27Arc#Gameplay",
	"http://fa-d2.wikia.com/wiki/Rider_of_Black#Gameplay",   //placeholder for nursery rhyme's page
	"http://fa-d2.wikia.com/wiki/Rider_of_Black#Gameplay",   //placeholder for atalanta's page
	"http://fa-d2.wikia.com/wiki/Rider_of_Black#Gameplay",   //placeholder for atalanta's page
	"t.ly/6nI8",   //placeholder for atalanta's page
	"https://fateanother-ii.fandom.com/wiki/Elizabeth_Bathory",   //placeholder for atalanta's page
	"http://fa-d2.wikia.com/wiki/Rider_of_Black#Gameplay",   //placeholder for atalanta's page
	"t.ly/hSQa",   //placeholder for atalanta's page
	"t.ly/hSQa",   //placeholder for atalanta's page
	"http://fa-d2.wikia.com/wiki/Rider_of_Black#Gameplay",   //placeholder for atalanta's page
	"http://fa-d2.wikia.com/wiki/Rider_of_Black#Gameplay",   //placeholder for atalanta's page
]

function CreateContextAbilityPanel(panel, abilityname)
{
	var abilityPanel = $.CreatePanel("Panel", panel, "");
	abilityPanel.SetAttributeString("ability_name", abilityname);
	abilityPanel.BLoadLayout("file://{resources}/layout/custom_game/fateanother_context_ability.xml", false, false );
}

function OnHeroButtonShowTooltip()
{
    var panel = $.GetContextPanel();
    var name = panel.GetAttributeString("heroname", "");
    $.DispatchEvent('DOTAShowTextTooltip', panel, "#" + name);
}

function OnHeroButtonHideTooltip()
{
    var panel = $.GetContextPanel();
    $.DispatchEvent( 'DOTAHideTextTooltip', panel );
}


function GetIndex(array, object)
{
	for (i=0; i<array.length; i++)
	{
		if (array[i] == object) 
		{
			return i
			
		}
	}
	return -1
}

function GetHeroAbility(hero, index)
{
	var curIndex = GetIndex(heroes, hero);
	var ability_name = abilities[curIndex][index];
	//$.Msg(ability_name);
	return ability_name
}

function GetHeroAttribute(hero, index)
{
	var curIndex = GetIndex(heroes, hero);
	var attribute_name = attributes[curIndex][index];
	//$.Msg(attribute_name);
	return attribute_name
}

function GetHeroCombo(hero)
{
	var curIndex = GetIndex(heroes, hero);
	var combo_name = comboes[curIndex];
	return combo_name
}

function OnHeroButtonPressed() {

    var name = $.GetContextPanel().GetAttributeString("heroname", "");
    var curIndex = GetIndex(heroes, name);
    var parentPanel = $.GetContextPanel().GetParent().GetParent();
    var infoPanel = parentPanel.FindChildInLayoutFile("FatepediaHeroInfoPanel");
    var portraitPanel = parentPanel.FindChildInLayoutFile("FatepediaHeroIntroImage");
    var namePanel = parentPanel.FindChildInLayoutFile("FatepediaHeroName");
    var skillPanel = parentPanel.FindChildInLayoutFile("FatepediaHeroSkillPanel");
    var attrPanel = parentPanel.FindChildInLayoutFile("FatepediaHeroAttrPanel");
    var linkPanel = parentPanel.FindChildInLayoutFile("WikiLink");
    var directory = "url('s2r://panorama/images/custom_game/portrait/";
    //$.Msg(name + " " + curIndex);
    //$.Msg(skillPanel);

    skillPanel.RemoveAndDeleteChildren();
    attrPanel.RemoveAndDeleteChildren();

    infoPanel.visible = true;
	namePanel.text = names[curIndex];
    portraitPanel.style["background-image"] = directory +  heroes[i] + ".png');"; // portrait
	//namePanel.text = "#npc_dota_hero_legion_commander";
 
    // regular abilities
    CreateContextAbilityPanel(skillPanel, abilities[curIndex][3]);
    CreateContextAbilityPanel(skillPanel, abilities[curIndex][4]);
    CreateContextAbilityPanel(skillPanel, abilities[curIndex][0]);
    CreateContextAbilityPanel(skillPanel, abilities[curIndex][1]);
    CreateContextAbilityPanel(skillPanel, abilities[curIndex][2]);
    CreateContextAbilityPanel(skillPanel, abilities[curIndex][5]);
    CreateContextAbilityPanel(skillPanel, comboes[curIndex]);
    // attributes 
	for (i=0; i<attributes[curIndex].length; i++) {
		CreateContextAbilityPanel(attrPanel, attributes[curIndex][i]);
	}
	//linkPanel.text = '<a href="http://www.w3schools.com/html/">Visit our HTML tutorial</a>';
	linkPanel.text = '<a href="' + guidelinks[curIndex] + '">Double click here for hero build and tips!</a>';
	//"&lt;a href=&quot;" + guidelinks[curIndex] + "&quot;&gt;Click here for quick build guide and tips!&lt;/a&gt;";
	//linkPanel.text = "FatepediaSkillContextText" id="WikiLink" text="&lt;a href=&quot;http://fa-d2.wikia.com/wiki/Gilgamesh#MAX_Enuma_Elish_.28Combo.29&quot;&gt;Click here for quick build guide and tips!&lt;a&gt;";
	//linkPanel.html = guidelinks[curIndex];

}

(function () {

})();