var g_GameConfig = FindCustomUIRoot($.GetContextPanel());
//g_GameConfig.curBGMentindex = 0;
g_GameConfig.curBGMIndex = g_GameConfig.curBGMIndex || 1;
g_GameConfig.nextBGMIndex = g_GameConfig.nextBGMIndex || 1;
g_GameConfig.BGMSchedule = g_GameConfig.BGMSchedule || 0;
var volume = "";
var duration = {
    0: 201,
    1: 186,
    2: 327,
    3: 138,
    4: 149,
    5: 181,
    6: 143,
    7: 184,
    8: 366,
    9: 239,
    10: 141,
    11: 184,
    12: 213,
    13: 150,
    14: 166,
    15: 156,
    16: 173,
    17: 143,
    18: 257
}
g_GameConfig.duration = [186,327,138,149,181,143,184,366,239,141,184,213,180,166,156,173,143,257];
//g_GameConfig.duration = [5,5,5,5,5,5,5,5];
g_GameConfig.bRepeat = false;
g_GameConfig.bIsBGMOn = true;
g_GameConfig.bIsAutoChange = false;

g_GameConfig.bIsConfig1On = false;
g_GameConfig.bIsConfig2On = false;
g_GameConfig.bIsConfig3On = false;
g_GameConfig.bIsConfig4On = false;
g_GameConfig.bIsConfig8On = false;
g_GameConfig.bIsConfig9On = false;
g_GameConfig.bIsConfig11On = false;
g_GameConfig.bIsConfig12On = true;
g_GameConfig.bIsConfig13On = false;

function OnRepeatToggle()
{
    g_GameConfig.bRepeat = !g_GameConfig.bRepeat;
}

function OnDropDownChanged()
{
    if (g_GameConfig.bIsAutoChange == true) {
        return
    }
    $.Msg("Drop Down Change");
    var selection = $("#FateConfigBGMList").GetSelected();
    g_GameConfig.nextBGMIndex = parseInt(selection.id);
    //$.Msg("Next BGM Index: " + selection.id);
    if (g_GameConfig.BGMSchedule != 0) {
        $.CancelScheduled(g_GameConfig.BGMSchedule, {});
    };
    PlayBGM();
}

function PlayBGM()
{
    //if (g_GameConfig.curBGMentindex != 0) {
    Game.StopSound(g_GameConfig.curBGMentindex);
    //}

    g_GameConfig.curBGMIndex = g_GameConfig.nextBGMIndex;

    //if (Game.GameStateIs( DOTA_GameState.DOTA_GAMERULES_STATE_PRE_GAME)) {
    //    g_GameConfig.curBGMIndex = 0;
    //};

    var BGMname = "BGM." + g_GameConfig.curBGMIndex.toString() + volume;
    var BGMduration = duration[g_GameConfig.curBGMIndex]+2;
    var dropPanel = $("#FateConfigBGMList");
    $.Msg("Playing " + BGMname + " for " + BGMduration.toString() + " seconds");

    // Set a flag so that OnDropDownChange() does not run due to SetSelected()
    g_GameConfig.bIsAutoChange = true;
    $.Schedule(0.033, function(){g_GameConfig.bIsAutoChange = false;})

    if (dropPanel) {dropPanel.SetSelected(g_GameConfig.nextBGMIndex)};
    g_GameConfig.curBGMentindex = Game.EmitSound(BGMname);

    g_GameConfig.BGMSchedule = $.Schedule(BGMduration, function() {
        if (g_GameConfig.bIsBGMOn === true){
            if (g_GameConfig.bRepeat == false) {
                g_GameConfig.nextBGMIndex = Math.floor((Math.random() * 17) + 1);
            };
            PlayBGM();
        };
    });
}

function OnVolumeChange()
{
    $.Msg('volume change');
    if (g_GameConfig.bIsBGMOn === true) {
        StopBGM();
    };
    var guage = $( "#FateVolumeGuage" );
    var high = $( "#VolumeButton1" );
    var medium = $( "#VolumeButton2" );
    var off = $( "#VolumeButton3" );
    var numba = $( "#FateVolumeNumba" );
    if (high.checked == true) {
        volume = "";
        guage.style.width = "100%";
        high.style["z-index"] = 3;
        medium.style["z-index"] = 0;
        off.style["z-index"] = 0;
        PlayBGM();
        numba.text = "100";
    } else if (medium.checked == true) {
        volume = "_50";
        guage.style.width = "50%";
        high.style["z-index"] = 3;
        medium.style["z-index"] = 3;
        off.style["z-index"] = 0;
        PlayBGM();
        numba.text = "50";
    } else if (off.checked == true) {
        guage.style.width = "0%";
        high.style["z-index"] = 3;
        medium.style["z-index"] = 3;
        off.style["z-index"] = 3;
        g_GameConfig.bIsBGMOn = false;
        numba.text = "0";
        StopBGM();
    };
}

function StopBGM()
{
    if (g_GameConfig.curBGMentindex != 0) {
        Game.StopSound(g_GameConfig.curBGMentindex);
    }
    if (g_GameConfig.BGMSchedule != 0) {
        //clearTimeout(g_GameConfig.BGMSchedule)
        $.CancelScheduled(g_GameConfig.BGMSchedule, {});
    }
}

function OnIntro(index)
{
    g_GameConfig.nextBGMIndex = index.bgm;
    //$.Msg("Next BGM Index: " + selection.id);
    if (g_GameConfig.BGMSchedule != 0) {
        $.CancelScheduled(g_GameConfig.BGMSchedule, {});
    };
    PlayBGM();
    $.Msg('Game start: change BGM ' + g_GameConfig.nextBGMIndex);
}

(function() {
    GameEvents.Subscribe( "bgm_intro", OnIntro );
    $("#VolumeButton1" ).checked = true;
})();
