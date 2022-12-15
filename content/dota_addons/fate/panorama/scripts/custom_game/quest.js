/**
 * Created by JoBoDo on 9/24/2017.
 */

var softHidden = 'soft-hidden';
var bPlayerSubscribed = false;

var localPlayer = Players.GetLocalPlayer();
var globalContext = $.GetContextPanel();

var PlayerTables = GameUI.CustomUIConfig().PlayerTables;

var MiniQuestPanel = globalContext.FindChildTraverse('MiniQuestPanel');
var MiniQuestHeader = globalContext.FindChildTraverse('MiniQuestHeader');
var MiniQuestsHolder = globalContext.FindChildTraverse('MiniQuestsHolder');
var MiniQuestLock = globalContext.FindChildTraverse('MiniQuestLock');

var FullscreenUnderlay = globalContext.FindChildTraverse('Underlay');
var AllQuestsPanel = globalContext.FindChildTraverse('AllQuestsPanel');
var SelectedQuestsHolder = AllQuestsPanel.FindChildTraverse('SelectedQuestsHolder');

var AbandonWarning = globalContext.FindChildTraverse('AbandonWarning');

var quests = {
    active: {},
    available: {},
    completed: {},
    repeatable: {},
};

var btnActiveTab = AllQuestsPanel.FindChildTraverse('ActiveQuestsTabButton');
btnActiveTab.status = 'active';
var btnAvailableTab = AllQuestsPanel.FindChildTraverse('AvailableQuestsTabButton');
btnAvailableTab.status = 'available';
var btnCompletedTab = AllQuestsPanel.FindChildTraverse('CompletedQuestsTabButton');
btnCompletedTab.status = 'completed';
var btnRepeatableTab = AllQuestsPanel.FindChildTraverse('RepeatableQuestsTabButton');
btnRepeatableTab.status = 'repeatable';

var selectedTab;

function isEmptyObject(obj){
    for(var prop in obj) {
        if (Object.prototype.hasOwnProperty.call(obj, prop)) {
            return false;
        }
    }
    return true;
}

function getObjSize(obj) {
    var size = 0, key;
    for (key in obj) {
        if (obj.hasOwnProperty(key)) size++;
    }
    return size;
};

function GetImagePath(imageName){
    return "file://{images}/custom_game/dialogue/" + imageName + ".png"
};


function onQuestShow()
{
    FullscreenUnderlay.visible = true;
    AllQuestsPanel.visible = true;
};

function onQuestHide()
{
    FullscreenUnderlay.visible = true;
    AllQuestsPanel.visible = false;
}

function onCloseButton()
{
    onQuestHide();
};

function QuestsUpdate(tableName, changes, deletions)
{
    var status = tableName.split('_')[2];

    if(! selectedTab){
        ChangeTab(btnActiveTab);
    }

    if(!isEmptyObject(changes)){
        $.Each(changes, function(questData, questID){

            //First we update the data
            if(! quests[status][questID]){
                quests[status][questID] = {
                    data: questData
                };
            }else{
                quests[status][questID].data = questData;
            }

            //Then we use the data to set up the mini panel (top-right)
            if(status == 'active'){
                if(! quests[status][questID].panel){
                    CreateQuestMiniPanel(questID, questData, status)
                }else{
                    UpdateQuestMiniPanel(questID, questData, status)
                }
            }

            //then we use the data to set up  the main panel (center-screen)
            if(selectedTab.status == status){
                if(! quests[status][questID].mainPanel){
                    CreateQuestMainPanel(questID, questData)
                }else{
                    UpdateQuestMainPanel(questID, questData)
                }
            }

        });
    }
    if(!isEmptyObject(deletions)){
        $.Each(deletions, function(questData, questID){
            DeleteQuest(questID, status);
        })
    }


};

function RefreshQuestsList(status){
    //var panel = quests[questID.toString()];
    //panel.DeleteAsync(0);
    QuestsList.RemoveAndDeleteChildren();

    $.Each(quests[status], function(questData, questID){
        CreateQuestInsert()
    });
}

var main_quests = [1011,1014,1015,1013,1023,1024,1025,1026,1027,1028,1029,1031,1030,1111,1102,1103,1104,1133,1105,1106,1142,1156,1157,1109,1110, 1136, 1149]
function CreateQuestMiniPanel(questID, questData, status)
{

    var panel = $.CreatePanel('Panel', MiniQuestsHolder, 'quest_' + questID);
    panel.BLoadLayoutSnippet('mini-quest-insert');
    panel.questID = questID;
    quests[status][questID].panel = panel;

    if (main_quests.indexOf(questID) >= 0){
        panel.AddClass('main-story');
    }

    panel.FindChildTraverse('AbandonButton').SetPanelEvent('onactivate', function(){
        AttemptAbandonQuest(questID);
    });

    UpdateQuestMiniPanel(questID, questData, status);
    ToggleTrackedQuest(questID, true)
};

function AttemptAbandonQuest(questID)
{
    var questName = quests['active'][questID].data.details.name || 'unknown';
    var warningText = "Do you wish to abandon this quest?";

    AbandonWarning.FindChildTraverse('AbandonText').text = $.Localize(warningText);
    AbandonWarning.FindChildTraverse('QuestName').text = $.Localize(questName);

    var AbandonConfirm = AbandonWarning.FindChildTraverse('AbandonConfirm');
    var AbandonDeny = AbandonWarning.FindChildTraverse('AbandonDeny');

    var clearEvents = function(){
        AbandonConfirm.ClearPanelEvent('onactivate');
        AbandonDeny.ClearPanelEvent('onactivate');
        AbandonWarning.visible = false;
    };
    clearEvents();

    AbandonConfirm.SetPanelEvent('onactivate', function(){
        GameEvents.SendCustomGameEventToServer('abandon_quest', {questID: questID});
        clearEvents();
    });

    AbandonWarning.FindChildTraverse('AbandonDeny').SetPanelEvent('onactivate', function(){
        clearEvents();
    });


    AbandonWarning.visible = true;
}

function ToggleTrackedQuest(questID, bTrackQuest){
    if(!quests['active'][questID]){
        return false;
    }
    if(!quests['active'][questID].tracked){
        quests['active'][questID].tracked = false; //set to false because it's about to be flipped;
    }

    quests['active'][questID].tracked = bTrackQuest || ! quests['active'][questID].tracked;

    if (quests['active'][questID].panel){
        quests['active'][questID].panel.visible = quests['active'][questID].tracked;
    }
}

//

function UpdateQuestMiniPanel(questID, questData, status)
{

    var panel = quests[status][questID].panel;
    if(!panel){
        return false;
    }
    //set name on quest
    var NamePanel = panel.FindChildTraverse('QuestName');
    var name = questData.details.name;
    if(name){
        NamePanel.text = $.Localize(name);
        NamePanel.SetHasClass(softHidden, false);
    }else{
        NamePanel.SetHasClass(softHidden, true);
    }

    //set description on quest
    var DescPanel = panel.FindChildTraverse('QuestDescription');
    if(questData.stageDescriptions){

        var size = getObjSize(questData.stageDescriptions);

        var desc = questData.stageDescriptions[size.toString()];
        if(desc){
            DescPanel.text = $.Localize(desc);
            DescPanel.SetHasClass(softHidden, false);

            //Do we want to check to change the size of the description?
        }else{
            DescPanel.SetHasClass(softHidden, true);
        }
    }else{
        DescPanel.SetHasClass(softHidden, true);
    }


    //set typeIcon of quest
    var IconImage = panel.FindChildTraverse('QuestTypeImage');
    var icon = questData.details.typeIcon;
    if(icon){
        IconImage.SetImage(GetImagePath(icon));
        IconImage.SetHasClass(softHidden, false);
    }else{
        IconImage.SetHasClass(softHidden, true);
    }


    //set portrait of quest
    var PortraitImage = panel.FindChildTraverse('PortraitImage');
    var portrait = questData.details.portrait;
    if(portrait){
        PortraitImage.SetImage(GetImagePath(portrait));
        PortraitImage.SetHasClass(softHidden, false);
    }else{
        PortraitImage.SetHasClass(softHidden, true);
    }

    //Keep track of tasks that receive updates, so we can know when the task no longer exists and can be deleted
    var updatedTasks = {}
    if(panel.tasks){
        $.Each(panel.tasks, function(taskPanel, taskIndex){
            updatedTasks[taskIndex] = false
        });
    }

    //set tasks of quest
    if(questData.tasks){
        $.Each(questData.tasks, function(task, taskIndex){
            panel.tasks = panel.tasks || {};
            if(! panel.tasks[taskIndex]){
                CreateTaskInsert(panel, taskIndex, task);
            }else{
                UpdateTaskInsert(panel, taskIndex, task);
            }
            updatedTasks[taskIndex] = true
        })
    }

    $.Each(updatedTasks, function(bUpdated, taskIndex){
        if(bUpdated == false){
            DeleteTaskInsert(panel, taskIndex);
        }
    });
};

function CreateTaskInsert(questPanel, taskIndex, taskInfo)
{
    var TaskPanel = questPanel.FindChildTraverse('TaskPanel');
    var panel = $.CreatePanel('Panel', TaskPanel, 'task_' + taskIndex);
    panel.BLoadLayoutSnippet('task-insert');

    questPanel.tasks[taskIndex] = panel;
    UpdateTaskInsert(questPanel, taskIndex, taskInfo)
};

function UpdateTaskInsert(questPanel, taskIndex, taskInfo)
{

    var panel = questPanel.tasks[taskIndex];

    var taskObjectText;
    if(taskInfo.taskObject && taskInfo.taskObject.length > 0){
        taskObjectText = $.Localize(taskInfo.taskObject);
    }

    var taskNumText;
    if(taskInfo.taskNumber){
        taskNumText = $.Localize(taskInfo.taskNumber);
    }

    var TaskObject = panel.FindChildTraverse('TaskObject');
    if(taskObjectText){
        TaskObject.text = $.Localize(taskObjectText);
    }

    if(taskNumText){
        panel.FindChildTraverse('TaskObjectNumber').text = taskNumText;
        panel.FindChildTraverse('TaskObjectNumber').visible = true;
    }else{
        panel.FindChildTraverse('TaskObjectNumber').visible = false;
    }

    panel.SetHasClass('completed', (taskInfo.completed == 1));
};

function DeleteTaskInsert(questPanel, taskIndex){
    var panel = questPanel.tasks[taskIndex];
    panel.DeleteAsync(0);
    delete questPanel.tasks[taskIndex];
}

function DeleteQuest(questID, status)
{
    var quest = quests[status][questID];

    if(!quest){
        return;
    }


    if(quest.panel){
        quest.panel.DeleteAsync(0);
    }
    if(quest.mainPanel){
        quest.mainPanel.DeleteAsync(0);
    }

    delete quests[status][questID];
};

function ToggleCompletedQuests(bool)
{
    if(!bool){
        FullscreenUnderlay.visible = ! FullscreenUnderlay.visible;
        AllQuestsPanel.visible = ! AllQuestsPanel.visible;
    }else{
        FullscreenUnderlay.visible = bool
        AllQuestsPanel.visible = bool
    }
}

function CreateQuestMainPanel(questID, questData)
{

    var panel = $.CreatePanel('Panel', SelectedQuestsHolder, "main_quest"+questID);
    panel.BLoadLayoutSnippet('main-quest-insert');
    panel.questID = questID;

    var bActiveQuestsShown = selectedTab.status == 'active';

    var TrackQuestToggle = panel.FindChildTraverse('TrackQuestToggle');

    TrackQuestToggle.SetHasClass(softHidden, ! bActiveQuestsShown);
    TrackQuestToggle.checked = true;

    if(bActiveQuestsShown){
        TrackQuestToggle.SetPanelEvent('onactivate', function(){
            ToggleTrackedQuest(questID);
        })
    }

    quests[selectedTab.status][questID].mainPanel = panel;

    UpdateQuestMainPanel(questID, questData);
}

function UpdateQuestMainPanel(questID, questData){

    var panel = quests[selectedTab.status][questID].mainPanel;

    var portrait = questData.details.portrait;
    if(portrait){
        panel.FindChildTraverse('ThePortraitImage').SetImage(GetImagePath(portrait));
    }


    panel.FindChildTraverse('TheQuestName').text = $.Localize(questData.details.name);
    panel.FindChildTraverse('TheQuestDescription').text = $.Localize(questData.details.description || "");

    var stagePanel = panel.FindChildTraverse('StageDescriptions');
    stagePanel.RemoveAndDeleteChildren();

    if(questData.stageDescriptions){
        var lastDesc = '';
        var indexDecrement = 0;

        $.Each(questData.stageDescriptions,function(description, index){
            if(lastDesc.toLowerCase() != description.toLowerCase()){
                var label = $.CreatePanel('Label', stagePanel, "description_"+index);
                label.text = (index - indexDecrement) + ' : ' + $.Localize(description);
                lastDesc = description;
            }else{
                indexDecrement += 1;
            }
        })
    }
}



function ChangeTab(newSelectedTab){

    var previousStatus;

    if(selectedTab){
        previousStatus = selectedTab.status;
        selectedTab.SetHasClass('selected', false);
    }
    selectedTab = newSelectedTab;

    selectedTab.SetHasClass('selected', true);

    //todo: May be better to just set their height/width to 0 instead of removing
    $.Each(SelectedQuestsHolder.Children(), function(panel){
        var questID = panel.questID;
        panel.DeleteAsync(0);
        if(previousStatus){
            delete quests[previousStatus][questID].mainPanel
        }
    });


    var status = selectedTab.status;
    $.Each(quests[status], function(quest, questID){
        if(quest && quest.data){
            CreateQuestMainPanel(questID, quest.data)
        }
    })
};

(function(){
    MiniQuestPanel.visible = true;
    AllQuestsPanel.visible = false;


    FullscreenUnderlay.visible = false;
    AbandonWarning.visible = false;
    

    GameUI.UIPositioning.SetupDrag(MiniQuestHeader, MiniQuestPanel, globalContext);

    //SetupDragEventHandlers(MiniQuestHeader, MiniQuestPanel);
    MiniQuestsHolder.RemoveAndDeleteChildren();



    btnActiveTab.ClearPanelEvent('onactivate');
    btnActiveTab.SetPanelEvent('onactivate', function(){
        ChangeTab(btnActiveTab);
    });

    btnAvailableTab.ClearPanelEvent('onactivate');
    btnAvailableTab.SetPanelEvent('onactivate', function(){
       ChangeTab(btnAvailableTab);
    });

    btnCompletedTab.ClearPanelEvent('onactivate');
    btnCompletedTab.SetPanelEvent('onactivate', function(){
        ChangeTab(btnCompletedTab);
    });

    btnRepeatableTab.ClearPanelEvent('onactivate');
    btnRepeatableTab.SetPanelEvent('onactivate', function(){
        ChangeTab(btnRepeatableTab);
    });



    GameEvents.Subscribe("quests_subscribe_pt", function(args){
        if(bPlayerSubscribed == true){
            return;
        }

        $.Each(args, function(tableName){
            PlayerTables.SubscribeNetTableListener(tableName, QuestsUpdate);
            var tables = PlayerTables.GetAllTableValues(tableName);
            QuestsUpdate(tableName, tables, {})
        });
        bPlayerSubscribed = true;
    });
    GameEvents.SendCustomGameEventToServer('request_pt_subs', {});

    GameEvents.Subscribe("quest_show", onQuestShow);
    GameEvents.Subscribe("quest_hide", onQuestHide);

    GameUI.ToggleQuests = function(){
        MiniQuestPanel.visible = ! MiniQuestPanel.visible;
    }
    
})();