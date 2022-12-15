

var playerId = Players.GetLocalPlayer();
var globalContext = $.GetContextPanel();

globalContext.SetHasClass("Hidden", true);
var innate_skill = 0;
var skill_1 = 0;
var skill_2 = 0;
var skill_3 = 0;
var skill_4 = 0;
var combo = 0;
var SA = 0;
var FateTutorialBoard = globalContext.FindChildTraverse('FateTutorialBoard');
var Page1 = FateTutorialBoard.FindChild('Page1');
var Page2 = FateTutorialBoard.FindChild('Page2');
var Page3 = FateTutorialBoard.FindChild('Page3');
var Page4 = FateTutorialBoard.FindChild('Page4');
var Page5 = FateTutorialBoard.FindChild('Page5');
var Page6 = FateTutorialBoard.FindChild('Page6');
var Page7 = FateTutorialBoard.FindChild('Page7');
var Page8 = FateTutorialBoard.FindChild('Page8');
var Page9 = FateTutorialBoard.FindChild('Page9');
var Page10 = FateTutorialBoard.FindChild('Page10');
var Page11 = FateTutorialBoard.FindChild('Page11');
var Page12 = FateTutorialBoard.FindChild('Page12');
var Page13 = FateTutorialBoard.FindChild('Page13');
var Page14 = FateTutorialBoard.FindChild('Page14');
var Page15 = FateTutorialBoard.FindChild('Page15');
var Page16 = FateTutorialBoard.FindChild('Page16');
var Page17 = FateTutorialBoard.FindChild('Page17');
var Page18 = FateTutorialBoard.FindChild('Page18');
var Page19 = FateTutorialBoard.FindChild('Page19');
var Page20 = FateTutorialBoard.FindChild('Page20');
var Page21 = FateTutorialBoard.FindChild('Page21');
var Page22 = FateTutorialBoard.FindChild('Page22');
var Page23 = FateTutorialBoard.FindChild('Page23');
var Page24 = FateTutorialBoard.FindChild('Page24');
var Page25 = FateTutorialBoard.FindChild('Page25');
var Page26 = FateTutorialBoard.FindChild('Page26');
var Page27 = FateTutorialBoard.FindChild('Page27');
var Page28 = FateTutorialBoard.FindChild('Page28');
var Page29 = FateTutorialBoard.FindChild('Page29');
var Page30 = FateTutorialBoard.FindChild('Page30');
var Page31 = FateTutorialBoard.FindChild('Page31');
var Page32 = FateTutorialBoard.FindChild('Page32');
var Page33 = FateTutorialBoard.FindChild('Page33');
var Page34 = FateTutorialBoard.FindChild('Page34');
var Page35 = FateTutorialBoard.FindChild('Page35');
var Page36 = FateTutorialBoard.FindChild('Page36');
var Page37 = FateTutorialBoard.FindChild('Page37');
var Page38 = FateTutorialBoard.FindChild('Page38');
var Page39 = FateTutorialBoard.FindChild('Page39');
var Page40 = FateTutorialBoard.FindChild('Page40');
var Page41 = FateTutorialBoard.FindChild('Page41');
var Page42 = FateTutorialBoard.FindChild('Page42');
var Page43 = FateTutorialBoard.FindChild('Page43');
var Page44 = FateTutorialBoard.FindChild('Page44');
var Page45 = FateTutorialBoard.FindChild('Page45');
var Page46 = FateTutorialBoard.FindChild('Page46');
var Page47 = FateTutorialBoard.FindChild('Page47');
var Page48 = FateTutorialBoard.FindChild('Page48');
var heroname = Players.GetPlayerSelectedHero(playerId);
var servant = null;
var questID = null;
var ability_1 = null;
var ability_2 = null;
var ability_3 = null;
var ability_4 = null;
var ability_5 = null;
var ability_6 = null;
var directory = "url('file://{images}/spellicons/";

function AddSkillDescribe(TEXT)
{
    var panel = $.CreatePanel('Panel', $('#Skills'), '' );
    panel.BLoadLayoutSnippet('skill');
    var skilll = panel.FindChildTraverse('Skill');
    skilll.style["background-image"] = directory + TEXT + "_png.vtex')";
    //panel.FindChildTraverse('SkillText').text = "#Next" ;
    //panel.FindChildTraverse('SkillDesText').text = "#" + TEXT + "_des";
    

    //$.Msg(name)
    //var skillname = name.FindChildTraverse('SkillText');
    
    //skillname.text = "Skill 10"
}

function DeleteSkill(skill)
{
    skill.DeleteAsync(0)
}

function page1next()
{
    Page1.visible = false;
    Page2.visible = true;
}

function page2back()
{
    Page1.visible = true;
    Page2.visible = false;
}

function page2next()
{
    Page2.visible = false;
    Page3.visible = true;
}

function page3back()
{
    Page2.visible = true;
    Page3.visible = false;
}

function page3next()
{
    Page3.visible = false;
    Page4.visible = true;

    var skillI1 = Page4.FindChildTraverse('SkillI1Img');
    skillI1.style["background-image"] = directory + ability_4 + "_png.vtex')";

    var skillI2 = Page4.FindChildTraverse('SkillI2Img');
    skillI2.style["background-image"] = directory + ability_5 + "_png.vtex')";
    //if (innate_skill < 2) {
    //    AddSkillDescribe(ability_4);
    //    AddSkillDescribe(ability_5);
    //    innate_skill = 2;
    //};
}

function page4back()
{
    Page3.visible = true;
    Page4.visible = false;
}

function page4next()
{
    Page4.visible = false;
    Page5.visible = true;
    if (servant == 'npc_dota_hero_legion_commander') {
        var skill1 = Page5.FindChildTraverse("Skill1");
        skill1.FindChildTraverse("Skill1Img").style["background-image"] = directory + ability_1 + "_png.vtex')";
    };
}

function page5back()
{
    Page4.visible = true;
    Page5.visible = false;
}

function page5next()
{
    Page5.visible = false;
    Page6.visible = true;
}

function page6back()
{
    Page5.visible = true;
    Page6.visible = false;
}

function page6next()
{
    Page5.visible = false;
    Page6.visible = false;
    globalContext.visible = false;
    FateTutorialBoard.visible = false;
    $.Msg(questID);
    
    var hero = Players.GetPlayerHeroEntityIndex(playerId);
    $.Msg(hero);
    var tutorial_data = {playerId: playerId, servant: hero, questID: questID};
    GameEvents.SendCustomGameEventToServer("tutorial_fate_quest", tutorial_data);
    $.Msg(tutorial_data);
}

function page7next()
{
    Page7.visible = false;
    Page8.visible = true;
}

function page8back()
{
    Page7.visible = true;
    Page8.visible = false;
}

function page8next()
{
    Page7.visible = false;
    Page8.visible = false;
    globalContext.visible = false;
    FateTutorialBoard.visible = false;
    $.Msg(questID);
    
    var hero = Players.GetPlayerHeroEntityIndex(playerId);
    $.Msg(hero);
    var tutorial_data = {playerId: playerId, servant: hero, questID: questID};
    GameEvents.SendCustomGameEventToServer("tutorial_fate_quest", tutorial_data);
    $.Msg(tutorial_data);
}

function page9next()
{
    Page9.visible = false;
    Page10.visible = true;
}

function page10back()
{
    Page9.visible = true;
    Page10.visible = false;
}

function page10next()
{
    Page9.visible = false;
    Page10.visible = false;
    globalContext.visible = false;
    FateTutorialBoard.visible = false;
    $.Msg(questID);

    var hero = Players.GetPlayerHeroEntityIndex(playerId);
    $.Msg(hero);
    var tutorial_data = {playerId: playerId, servant: hero, questID: questID};
    GameEvents.SendCustomGameEventToServer("tutorial_fate_quest", tutorial_data);
    $.Msg(tutorial_data);
}

function page11next()
{
    Page11.visible = false;
    Page12.visible = true;
}

function page12back()
{
    Page11.visible = true;
    Page12.visible = false;
}

function page12next()
{
    Page11.visible = false;
    Page12.visible = false;
    globalContext.visible = false;
    FateTutorialBoard.visible = false;
    $.Msg(questID);

    var hero = Players.GetPlayerHeroEntityIndex(playerId);
    $.Msg(hero);
    var tutorial_data = {playerId: playerId, servant: hero, questID: questID};
    GameEvents.SendCustomGameEventToServer("tutorial_fate_quest", tutorial_data);
    $.Msg(tutorial_data);
}

function page13next()
{
    Page13.visible = false;
    Page14.visible = true;
}

function page14back()
{
    Page13.visible = true;
    Page14.visible = false;
}

function page14next()
{
    Page14.visible = false;
    Page15.visible = true;
}

function page15back()
{
    Page14.visible = true;
    Page15.visible = false;
}

function page15next()
{
    Page15.visible = false;
    Page16.visible = true;
}

function page16back()
{
    Page15.visible = true;
    Page16.visible = false;
}

function page16next()
{
    Page15.visible = false;
    Page16.visible = false;
    globalContext.visible = false;
    FateTutorialBoard.visible = false;
    $.Msg(questID);

    var hero = Players.GetPlayerHeroEntityIndex(playerId);
    $.Msg(hero);
    var tutorial_data = {playerId: playerId, servant: hero, questID: questID};
    GameEvents.SendCustomGameEventToServer("tutorial_fate_quest", tutorial_data);
    $.Msg(tutorial_data);
}

function page17next()
{
    Page17.visible = false;
    Page18.visible = true;
}

function page18back()
{
    Page17.visible = true;
    Page18.visible = false;
}

function page18next()
{
    Page18.visible = false;
    Page19.visible = true;
}

function page19back()
{
    Page18.visible = true;
    Page19.visible = false;
}

function page19next()
{
    Page19.visible = false;
    Page20.visible = true;
}

function page20back()
{
    Page19.visible = true;
    Page20.visible = false;
}

function page20next()
{
    Page19.visible = false;
    Page20.visible = false;
    globalContext.visible = false;
    FateTutorialBoard.visible = false;
    $.Msg(questID);

    var hero = Players.GetPlayerHeroEntityIndex(playerId);
    $.Msg(hero);
    var tutorial_data = {playerId: playerId, servant: hero, questID: questID};
    GameEvents.SendCustomGameEventToServer("tutorial_fate_quest", tutorial_data);
    $.Msg(tutorial_data);
}

function page21next()
{
    Page21.visible = false;
    Page22.visible = true;
}

function page22back()
{
    Page21.visible = true;
    Page22.visible = false;
}

function page22next()
{
    Page22.visible = false;
    Page23.visible = true;
}

function page23back()
{
    Page22.visible = true;
    Page23.visible = false;
}

function page23next()
{
    Page23.visible = false;
    Page24.visible = true;
}

function page24back()
{
    Page23.visible = true;
    Page24.visible = false;
}

function page24next()
{
    Page24.visible = false;
    Page25.visible = true;
}

function page25back()
{
    Page24.visible = true;
    Page25.visible = false;
}

function page25next()
{
    Page24.visible = false;
    Page25.visible = false;
    globalContext.visible = false;
    FateTutorialBoard.visible = false;
    $.Msg(questID);

    var hero = Players.GetPlayerHeroEntityIndex(playerId);
    $.Msg(hero);
    var tutorial_data = {playerId: playerId, servant: hero, questID: questID};
    GameEvents.SendCustomGameEventToServer("tutorial_fate_quest", tutorial_data);
    $.Msg(tutorial_data);
}

function page26next()
{
    Page26.visible = false;
    Page27.visible = true;
}

function page27back()
{
    Page26.visible = true;
    Page27.visible = false;
}

function page27next()
{
    Page26.visible = false;
    Page27.visible = false;
    globalContext.visible = false;
    FateTutorialBoard.visible = false;
    $.Msg(questID);

    var hero = Players.GetPlayerHeroEntityIndex(playerId);
    $.Msg(hero);
    var tutorial_data = {playerId: playerId, servant: hero, questID: questID};
    GameEvents.SendCustomGameEventToServer("tutorial_fate_quest", tutorial_data);
    $.Msg(tutorial_data);
}

function page28next()
{
    Page28.visible = false;
    Page29.visible = true;
}

function page29back()
{
    Page28.visible = true;
    Page29.visible = false;
}

function page29next()
{
    Page28.visible = false;
    Page29.visible = false;
    globalContext.visible = false;
    FateTutorialBoard.visible = false;
    $.Msg(questID);

    var hero = Players.GetPlayerHeroEntityIndex(playerId);
    $.Msg(hero);
    var tutorial_data = {playerId: playerId, servant: hero, questID: questID};
    GameEvents.SendCustomGameEventToServer("tutorial_fate_quest", tutorial_data);
    $.Msg(tutorial_data);
}

function page30next()
{
    Page30.visible = false;
    Page31.visible = true;
}

function page31back()
{
    Page30.visible = true;
    Page31.visible = false;
}

function page31next()
{
    Page30.visible = false;
    Page31.visible = false;
    globalContext.visible = false;
    FateTutorialBoard.visible = false;
    $.Msg(questID);

    var hero = Players.GetPlayerHeroEntityIndex(playerId);
    $.Msg(hero);
    var tutorial_data = {playerId: playerId, servant: hero, questID: questID};
    GameEvents.SendCustomGameEventToServer("tutorial_fate_quest", tutorial_data);
    $.Msg(tutorial_data);
}

function page32next()
{
    Page32.visible = false;
    Page33.visible = true;
}

function page33back()
{
    Page32.visible = true;
    Page33.visible = false;
}

function page33next()
{
    Page33.visible = false;
    Page34.visible = true;
}

function page34back()
{
    Page33.visible = true;
    Page34.visible = false;
}

function page34next()
{
    Page33.visible = false;
    Page34.visible = false;
    globalContext.visible = false;
    FateTutorialBoard.visible = false;
    $.Msg(questID);

    var hero = Players.GetPlayerHeroEntityIndex(playerId);
    $.Msg(hero);
    var tutorial_data = {playerId: playerId, servant: hero, questID: questID};
    GameEvents.SendCustomGameEventToServer("tutorial_fate_quest", tutorial_data);
    $.Msg(tutorial_data);
}

function page35next()
{
    Page35.visible = false;
    Page36.visible = true;
}

function page36back()
{
    Page35.visible = true;
    Page36.visible = false;
}

function page36next()
{
    Page35.visible = false;
    Page36.visible = false;
    globalContext.visible = false;
    FateTutorialBoard.visible = false;
    $.Msg(questID);

    var hero = Players.GetPlayerHeroEntityIndex(playerId);
    $.Msg(hero);
    var tutorial_data = {playerId: playerId, servant: hero, questID: questID};
    GameEvents.SendCustomGameEventToServer("tutorial_fate_quest", tutorial_data);
    $.Msg(tutorial_data);
}

function page37next()
{
    Page37.visible = false;
    Page38.visible = true;
}

function page38back()
{
    Page37.visible = true;
    Page38.visible = false;
}

function page38next()
{
    Page37.visible = false;
    Page38.visible = false;
    globalContext.visible = false;
    FateTutorialBoard.visible = false;
    $.Msg(questID);

    var hero = Players.GetPlayerHeroEntityIndex(playerId);
    $.Msg(hero);
    var tutorial_data = {playerId: playerId, servant: hero, questID: questID};
    GameEvents.SendCustomGameEventToServer("tutorial_fate_quest", tutorial_data);
    $.Msg(tutorial_data);
}

function page39next()
{
    Page39.visible = false;
    Page40.visible = true;
}

function page40back()
{
    Page39.visible = true;
    Page40.visible = false;
}

function page40next()
{
    Page39.visible = false;
    Page40.visible = false;
    globalContext.visible = false;
    FateTutorialBoard.visible = false;
    $.Msg(questID);

    var hero = Players.GetPlayerHeroEntityIndex(playerId);
    $.Msg(hero);
    var tutorial_data = {playerId: playerId, servant: hero, questID: questID};
    GameEvents.SendCustomGameEventToServer("tutorial_fate_quest", tutorial_data);
    $.Msg(tutorial_data);
}

function page41next()
{
    Page41.visible = false;
    Page42.visible = true;
}

function page42back()
{
    Page41.visible = true;
    Page42.visible = false;
}

function page42next()
{
    Page42.visible = false;
    Page43.visible = true;
}

function page43back()
{
    Page42.visible = true;
    Page43.visible = false;
}

function page43next()
{
    Page43.visible = false;
    Page44.visible = true;
}

function page44back()
{
    Page43.visible = true;
    Page44.visible = false;
}

function page44next()
{
    Page43.visible = false;
    Page44.visible = false;
    globalContext.visible = false;
    FateTutorialBoard.visible = false;
    $.Msg(questID);

    var hero = Players.GetPlayerHeroEntityIndex(playerId);
    $.Msg(hero);
    var tutorial_data = {playerId: playerId, servant: hero, questID: questID};
    GameEvents.SendCustomGameEventToServer("tutorial_fate_quest", tutorial_data);
    $.Msg(tutorial_data);
}

function page45next()
{
    Page45.visible = false;
    Page46.visible = true;
}

function page46back()
{
    Page45.visible = true;
    Page46.visible = false;
}

function page46next()
{
    Page46.visible = false;
    Page47.visible = true;
}

function page47back()
{
    Page46.visible = true;
    Page47.visible = false;
}

function page47next()
{
    Page47.visible = false;
    Page48.visible = true;
}

function page48back()
{
    Page47.visible = true;
    Page48.visible = false;
}

function page48next()
{
    Page47.visible = false;
    Page48.visible = false;
    globalContext.visible = false;
    FateTutorialBoard.visible = false;
    $.Msg(questID);

    var hero = Players.GetPlayerHeroEntityIndex(playerId);
    $.Msg(hero);
    var tutorial_data = {playerId: playerId, servant: hero, questID: questID};
    GameEvents.SendCustomGameEventToServer("tutorial_fate_quest", tutorial_data);
    $.Msg(tutorial_data);
}

(function(){

    globalContext.visible = false;
    FateTutorialBoard.visible = false;
    Page1.visible = false;
    Page2.visible = false;
    Page3.visible = false;
    Page4.visible = false;
    Page5.visible = false;
    Page6.visible = false;
    Page7.visible = false;
    Page8.visible = false;
    Page9.visible = false;
    Page10.visible = false;
    Page11.visible = false;
    Page12.visible = false;
    Page13.visible = false;
    Page14.visible = false;
    Page15.visible = false;
    Page16.visible = false;
    Page17.visible = false;
    Page18.visible = false;
    Page19.visible = false;
    Page20.visible = false;
    Page21.visible = false;
    Page22.visible = false;
    Page23.visible = false;
    Page24.visible = false;
    Page25.visible = false;
    Page26.visible = false;
    Page27.visible = false;
    Page28.visible = false;
    Page29.visible = false;
    Page30.visible = false;
    Page31.visible = false;
    Page32.visible = false;
    Page33.visible = false;
    Page34.visible = false;
    Page35.visible = false;
    Page36.visible = false;
    Page37.visible = false;
    Page38.visible = false;
    Page39.visible = false;
    Page40.visible = false;
    Page41.visible = false;
    Page42.visible = false;
    Page43.visible = false;
    Page44.visible = false;
    Page45.visible = false;
    Page46.visible = false;
    Page47.visible = false;
    Page48.visible = false;

    this.HeroListener = CustomNetTables.SubscribeNetTableListener("tutorial", function(table, tableKey, data) {
        if (tableKey == "hero")  {
            $.Msg(data[1]);
            servant = data[1];
            $.Msg(servant);
            //if  (data[1] == "npc_dota_hero_legion_commander") {
            //    globalContext.visible = true;
            //    FateTutorialBoard.visible = true;
            //    Page1.visible = true;
            //};
        };
    });
    this.AbilityListener = CustomNetTables.SubscribeNetTableListener("tutorial", function(table, tableKey, data) {
        if (tableKey == "ability") {
            $.Msg(data);
            ability_1 = data[1];
            ability_2 = data[2];
            ability_3 = data[3];
            ability_4 = data[4];
            ability_5 = data[5];
            ability_6 = data[6];
        };
    });
    this.PageListener = CustomNetTables.SubscribeNetTableListener("tutorial", function(table, tableKey, data) {
        if (tableKey == "page")  {
            $.Msg(data);
            if  (data["page"] == 1) {
                globalContext.visible = true;
                FateTutorialBoard.visible = true;
                Page1.visible = true;
            };
            if  (data["page"] == 7) {
                globalContext.visible = true;
                FateTutorialBoard.visible = true;
                Page7.visible = true;
                if (servant == 'npc_dota_hero_legion_commander') {
                    var skill2 = Page7.FindChildTraverse("Skill2");
                    skill2.FindChildTraverse("Skill2Img").style["background-image"] = directory + ability_2 + "_png.vtex')";
                };
            };
            if  (data["page"] == 9) {
                globalContext.visible = true;
                FateTutorialBoard.visible = true;
                Page9.visible = true;
                if (servant == 'npc_dota_hero_legion_commander') {
                    var skill3 = Page9.FindChildTraverse("Skill3");
                    skill3.FindChildTraverse("Skill3Img").style["background-image"] = directory + ability_3 + "_png.vtex')";
                };
            };
            if  (data["page"] == 11) {
                globalContext.visible = true;
                FateTutorialBoard.visible = true;
                Page11.visible = true;
                if (servant == 'npc_dota_hero_legion_commander') {
                    var skill4 = Page11.FindChildTraverse("Skill4");
                    skill4.FindChildTraverse("Skill4Img").style["background-image"] = directory + ability_6 + "_png.vtex')";
                };
            };
            if  (data["page"] == 13) {
                globalContext.visible = true;
                FateTutorialBoard.visible = true;
                Page13.visible = true;
            };
            if  (data["page"] == 17) {
                globalContext.visible = true;
                FateTutorialBoard.visible = true;
                Page17.visible = true;
            };
            if  (data["page"] == 21) {
                globalContext.visible = true;
                FateTutorialBoard.visible = true;
                Page21.visible = true;
            };
            if  (data["page"] == 26) {
                globalContext.visible = true;
                FateTutorialBoard.visible = true;
                Page26.visible = true;
            };
            if  (data["page"] == 28) {
                globalContext.visible = true;
                FateTutorialBoard.visible = true;
                Page28.visible = true;
            };
            if  (data["page"] == 30) {
                globalContext.visible = true;
                FateTutorialBoard.visible = true;
                Page30.visible = true;
            };
            if  (data["page"] == 32) {
                globalContext.visible = true;
                FateTutorialBoard.visible = true;
                Page32.visible = true;
            };
            if  (data["page"] == 35) {
                globalContext.visible = true;
                FateTutorialBoard.visible = true;
                Page35.visible = true;
            };
            if  (data["page"] == 37) {
                globalContext.visible = true;
                FateTutorialBoard.visible = true;
                Page37.visible = true;
            };
            if  (data["page"] == 39) {
                globalContext.visible = true;
                FateTutorialBoard.visible = true;
                Page39.visible = true;
            };
            if  (data["page"] == 41) {
                globalContext.visible = true;
                FateTutorialBoard.visible = true;
                Page41.visible = true;
            };
            if  (data["page"] == 45) {
                globalContext.visible = true;
                FateTutorialBoard.visible = true;
                Page45.visible = true;
            };
        };
    });

    this.QuestListener = CustomNetTables.SubscribeNetTableListener("tutorial", function(table, tableKey, data) {
        if (tableKey == "questID")  {
            $.Msg(data);
            questID = data["questID"] +1;    
        };
    });


    
    


})();