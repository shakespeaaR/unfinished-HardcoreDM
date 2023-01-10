//Joinscreen Textdraws

new Text:HDM_JoinScreenBG,
    Text:HDM_JoinScreenName,
    Text:HDM_JoinScreenNewsBG,
    PlayerText:HDM_JoinScreenPlay[MAX_PLAYERS],
    PlayerText:HDM_JoinScreenExit[MAX_PLAYERS],
    PlayerText:HDM_JoinScreenNews[MAX_PLAYERS];

//PlayerHud Textdraws

new Text:TD_Reports;

new PlayerText:PTD_CarInfo[MAX_PLAYERS],
    PlayerText:PTD_KillStreak[MAX_PLAYERS],
    PlayerText:PTD_AreaIn[MAX_PLAYERS],
    PlayerText:PTD_CarInfoModel[MAX_PLAYERS],
    PlayerText:PTD_Horseshoe[MAX_PLAYERS],
    PlayerText:PTD_StatsBG[MAX_PLAYERS],
    PlayerText:PTD_StatsPlayer[MAX_PLAYERS],
    PlayerText:PTD_PlayerStatsText[MAX_PLAYERS],
    PlayerText:PTD_DeathKill[MAX_PLAYERS],
    PlayerText:PTD_CountDown[MAX_PLAYERS],
    PlayerText:PTD_SpecBox[MAX_PLAYERS],
    PlayerText:PTD_SpecInfo[MAX_PLAYERS],
    PlayerText:PTD_SpecPlayerInfo[MAX_PLAYERS];
	


//GlobalTD
new Text:HDM_BarinfoBG;
new Text:HDM_PlayersActive;
new Text:HDM_ActiveActivityBG;
new Text:HDM_GangControl;
new Text:HDM_GangControl1;
new Text:HDM_GangControl2;
new Text:HDM_GangControl3;
new Text:HDM_BarInfo2BG;
new Text:HDM_BarAreainfo;
new Text:HDM_GMInfo;
new Text:HDM_BarTimeData;
new Text:HDM_GangInfoBG;
new Text:HDM_AnnBG;
new Text:HDM_AnnTXT;
new Text:HDM_AnnAutor;
new Text:HDM_SniperDropInfo;
new Text:HDM_GangwarBar;
new Text:HDM_GangwarBarInfo;
new Text:HDM_GangWarStartArenaBG;
new Text:HDM_GangWarStartArenaBG2;
new Text:HDM_GangWarStartArenaInfo;
new Text:HDM_GangWarPointsRoundsBG;
new Text:HDM_GangWarPointsRounds;
new Text:HDM_GangWarInfoBar;
new Text:HDM_GangWarInfoG1;
new Text:HDM_GangWarInfoG2;
new Text:HDM_GangWarArenaInfo;
new Text:HDM_GangWarInstructions;
new Text:HDM_GWScoreBoardBG;
new Text:HDM_GWScoreBoardArena;
new Text:HDM_GWScoreBoardG1;
new Text:HDM_GWScoreBoardG2;
new Text:HDM_GWScoreBoardG1Info;
new Text:HDM_GWScoreBoardG2Info;
new Text:HDM_GWScoreBoardEndInfo;
new Text:HDM_FinalBoardBG;
new Text:HDM_FinalBoardTitle;
new Text:HDM_FinalBoardGang1;
new Text:HDM_FinalBoardGang2;
new Text:HDM_FinalBoardG1Info;
new Text:HDM_FinalBoardG2Info;
new Text:HDM_FinalBoardArenasList;
new Text:HDM_FinalBoardArenas;
new Text:HDM_FinalBoardG1Pinfo;
new Text:HDM_FinalBoardG2Pinfo;
new Text:HDM_FinalBoardTimeDate;
new Text:HDM_FinalBoardG1Points;
new Text:HDM_FinalBoardG2Points;
new Text:HDM_FinalBoardResult;

//PlayerTD
new PlayerText:HDM_GangWarTeamInfo[MAX_PLAYERS];
new PlayerText:HDM_GangInfoKillstreak[MAX_PLAYERS];
new PlayerText:HDM_BarPlayer[MAX_PLAYERS];
new PlayerText:HDM_PlayerStats[MAX_PLAYERS];
new PlayerText:HDM_BarPlayerFPSPINGPACKET[MAX_PLAYERS];
new PlayerText:HDM_PlayerArenaInfo[MAX_PLAYERS];
new PlayerText:HDM_GangControlPlayer[MAX_PLAYERS];
new PlayerText:HDM_AimInfo[MAX_PLAYERS];
new PlayerText:HDM_SniperDropPlayer[MAX_PLAYERS];
new PlayerText:HDM_SniperKills[MAX_PLAYERS];
new PlayerText:HDM_GWPlayerStats[MAX_PLAYERS];
//Display

destroyPlayerHUD(&playerid)
{

    PlayerTextDrawDestroy(playerid, HDM_BarPlayer[playerid]);
	PlayerTextDrawDestroy(playerid, HDM_PlayerStats[playerid]);
	PlayerTextDrawDestroy(playerid, HDM_PlayerArenaInfo[playerid]);
	PlayerTextDrawDestroy(playerid, HDM_GangControlPlayer[playerid]);
	PlayerTextDrawDestroy(playerid, HDM_BarPlayerFPSPINGPACKET[playerid]);
    PlayerTextDrawDestroy(playerid, PTD_CarInfo[playerid]);
    PlayerTextDrawDestroy(playerid, PTD_KillStreak[playerid]);
    PlayerTextDrawDestroy(playerid, PTD_CarInfoModel[playerid]);
    PlayerTextDrawDestroy(playerid, HDM_JoinScreenPlay[playerid]);
    PlayerTextDrawDestroy(playerid, HDM_JoinScreenExit[playerid]);
    PlayerTextDrawDestroy(playerid, HDM_JoinScreenNews[playerid]);
    PlayerTextDrawDestroy(playerid, PTD_Horseshoe[playerid]);
    PlayerTextDrawDestroy(playerid, PTD_StatsBG[playerid]);
    PlayerTextDrawDestroy(playerid, PTD_StatsPlayer[playerid]);
    PlayerTextDrawDestroy(playerid, PTD_PlayerStatsText[playerid]);
    PlayerTextDrawDestroy(playerid, PTD_DeathKill[playerid]);
    PlayerTextDrawDestroy(playerid, PTD_CountDown[playerid]);
    PlayerTextDrawDestroy(playerid, PTD_SpecBox[playerid]);
	PlayerTextDrawDestroy(playerid, PTD_SpecInfo[playerid]);
	PlayerTextDrawDestroy(playerid, PTD_SpecPlayerInfo[playerid]);
    PlayerTextDrawDestroy(playerid, HDM_GangInfoKillstreak[playerid]);
	PlayerTextDrawDestroy(playerid, HDM_AimInfo[playerid]);
	PlayerTextDrawDestroy(playerid, HDM_SniperDropPlayer[playerid]);
	PlayerTextDrawDestroy(playerid, HDM_SniperKills[playerid]);
	PlayerTextDrawDestroy(playerid, HDM_GangWarTeamInfo[playerid]);
	PlayerTextDrawDestroy(playerid, HDM_GWPlayerStats[playerid]);


}

destroyGlobal()
{
    TextDrawDestroy(HDM_GMInfo);
    TextDrawDestroy(HDM_BarinfoBG);
    TextDrawDestroy(HDM_BarInfo2BG);
	TextDrawDestroy(HDM_BarTimeData);
	TextDrawDestroy(HDM_BarAreainfo);
	TextDrawDestroy(HDM_ActiveActivityBG);
	TextDrawDestroy(HDM_GangControl);
	TextDrawDestroy(HDM_GangControl1);
	TextDrawDestroy(HDM_GangControl2);
	TextDrawDestroy(HDM_GangControl3);
    TextDrawDestroy(TD_Reports);
    TextDrawDestroy(HDM_JoinScreenBG);
    TextDrawDestroy(HDM_JoinScreenName);
    TextDrawDestroy(HDM_JoinScreenNewsBG);
    TextDrawDestroy(HDM_GangInfoBG);
	TextDrawDestroy(HDM_AnnBG);
	TextDrawDestroy(HDM_AnnTXT);
	TextDrawDestroy(HDM_AnnAutor);
	TextDrawDestroy(HDM_SniperDropInfo);
	TextDrawDestroy(HDM_GangwarBar);
	TextDrawDestroy(HDM_GangwarBarInfo);
	TextDrawDestroy(HDM_GangWarStartArenaBG);
	TextDrawDestroy(HDM_GangWarStartArenaBG2);
	TextDrawDestroy(HDM_GangWarStartArenaInfo);
	TextDrawDestroy(HDM_GangWarPointsRoundsBG);
	TextDrawDestroy(HDM_GangWarPointsRounds);
	TextDrawDestroy(HDM_GangWarInfoBar);
	TextDrawDestroy(HDM_GangWarInfoG1);
	TextDrawDestroy(HDM_GangWarInfoG2);
	TextDrawDestroy(HDM_GangWarArenaInfo);
	TextDrawDestroy(HDM_GangWarInstructions);
	TextDrawDestroy(HDM_GWScoreBoardBG);
	TextDrawDestroy(HDM_GWScoreBoardArena);
	TextDrawDestroy(HDM_GWScoreBoardG1);
	TextDrawDestroy(HDM_GWScoreBoardG2);
	TextDrawDestroy(HDM_GWScoreBoardG1Info);
	TextDrawDestroy(HDM_GWScoreBoardG2Info);
	TextDrawDestroy(HDM_GWScoreBoardEndInfo);
	TextDrawDestroy(HDM_FinalBoardBG);
	TextDrawDestroy(HDM_FinalBoardTitle);
	TextDrawDestroy(HDM_FinalBoardGang1);
	TextDrawDestroy(HDM_FinalBoardGang2);
	TextDrawDestroy(HDM_FinalBoardG1Info);
	TextDrawDestroy(HDM_FinalBoardG2Info);
	TextDrawDestroy(HDM_FinalBoardArenasList);
	TextDrawDestroy(HDM_FinalBoardArenas);
	TextDrawDestroy(HDM_FinalBoardG1Pinfo);
	TextDrawDestroy(HDM_FinalBoardG2Pinfo);
	TextDrawDestroy(HDM_FinalBoardTimeDate);
	TextDrawDestroy(HDM_FinalBoardG1Points);
	TextDrawDestroy(HDM_FinalBoardG2Points);
	TextDrawDestroy(HDM_FinalBoardResult);

}


showStartArena(&playerid)
{
	TextDrawShowForPlayer(playerid, HDM_GangWarStartArenaBG);
	TextDrawShowForPlayer(playerid, HDM_GangWarStartArenaBG2);
	TextDrawShowForPlayer(playerid, HDM_GangWarStartArenaInfo);
}

showGangWarInfo(&playerid){
	TextDrawShowForPlayer(playerid, HDM_GangWarPointsRoundsBG);
	TextDrawShowForPlayer(playerid, HDM_GangWarPointsRounds);
	TextDrawShowForPlayer(playerid, HDM_GangWarInfoBar);
	TextDrawShowForPlayer(playerid, HDM_GangWarInfoG1);
	TextDrawShowForPlayer(playerid, HDM_GangWarInfoG2);
	TextDrawShowForPlayer(playerid, HDM_GangWarArenaInfo);
	PlayerTextDrawShow(playerid, HDM_BarPlayerFPSPINGPACKET[playerid]);
	PlayerTextDrawShow(playerid, HDM_GWPlayerStats[playerid]);
	TextDrawShowForPlayer(playerid, HDM_BarInfo2BG);
	TextDrawShowForPlayer(playerid, HDM_BarTimeData);
	PlayerTextDrawShow(playerid, HDM_GangWarTeamInfo[playerid]);
}

showFinalResult(&playerid)
{
	TextDrawShowForPlayer(playerid, HDM_FinalBoardBG);
	TextDrawShowForPlayer(playerid, HDM_FinalBoardTitle);
	TextDrawShowForPlayer(playerid, HDM_FinalBoardGang1);
	TextDrawShowForPlayer(playerid, HDM_FinalBoardGang2);
	TextDrawShowForPlayer(playerid, HDM_FinalBoardG1Info);
	TextDrawShowForPlayer(playerid, HDM_FinalBoardG2Info);
	TextDrawShowForPlayer(playerid, HDM_FinalBoardArenasList);
	TextDrawShowForPlayer(playerid, HDM_FinalBoardArenas);
	TextDrawShowForPlayer(playerid, HDM_FinalBoardG1Pinfo);
	TextDrawShowForPlayer(playerid, HDM_FinalBoardG2Pinfo);
	TextDrawShowForPlayer(playerid, HDM_FinalBoardTimeDate);
	TextDrawShowForPlayer(playerid, HDM_FinalBoardG1Points);
	TextDrawShowForPlayer(playerid, HDM_FinalBoardG2Points);
	TextDrawShowForPlayer(playerid, HDM_FinalBoardResult);
}

hideFinalResult(&playerid)
{
	TextDrawHideForPlayer(playerid, HDM_FinalBoardBG);
	TextDrawHideForPlayer(playerid, HDM_FinalBoardTitle);
	TextDrawHideForPlayer(playerid, HDM_FinalBoardGang1);
	TextDrawHideForPlayer(playerid, HDM_FinalBoardGang2);
	TextDrawHideForPlayer(playerid, HDM_FinalBoardG1Info);
	TextDrawHideForPlayer(playerid, HDM_FinalBoardG2Info);
	TextDrawHideForPlayer(playerid, HDM_FinalBoardArenasList);
	TextDrawHideForPlayer(playerid, HDM_FinalBoardArenas);
	TextDrawHideForPlayer(playerid, HDM_FinalBoardG1Pinfo);
	TextDrawHideForPlayer(playerid, HDM_FinalBoardG2Pinfo);
	TextDrawHideForPlayer(playerid, HDM_FinalBoardTimeDate);
	TextDrawHideForPlayer(playerid, HDM_FinalBoardG1Points);
	TextDrawHideForPlayer(playerid, HDM_FinalBoardG2Points);
	TextDrawHideForPlayer(playerid, HDM_FinalBoardResult);
}

showGangWarInstr(&playerid)
{
	TextDrawShowForPlayer(playerid, HDM_GangWarInstructions);
}

hideGangWarInstr(&playerid)
{
	TextDrawHideForPlayer(playerid, HDM_GangWarInstructions);
}

hideStartArena(&playerid)
{
	TextDrawHideForPlayer(playerid, HDM_GangWarStartArenaBG);
	TextDrawHideForPlayer(playerid, HDM_GangWarStartArenaBG2);
	TextDrawHideForPlayer(playerid, HDM_GangWarStartArenaInfo);
}

hideGangWarInfo(&playerid){
	TextDrawHideForPlayer(playerid, HDM_GangWarPointsRoundsBG);
	TextDrawHideForPlayer(playerid, HDM_GangWarPointsRounds);
	TextDrawHideForPlayer(playerid, HDM_GangWarInfoBar);
	TextDrawHideForPlayer(playerid, HDM_GangWarInfoG1);
	TextDrawHideForPlayer(playerid, HDM_GangWarInfoG2);
	TextDrawHideForPlayer(playerid, HDM_GangWarArenaInfo);
	PlayerTextDrawHide(playerid, HDM_BarPlayerFPSPINGPACKET[playerid]);
	PlayerTextDrawHide(playerid, HDM_GWPlayerStats[playerid]);
	TextDrawHideForPlayer(playerid, HDM_BarInfo2BG);
	TextDrawHideForPlayer(playerid, HDM_BarTimeData);
	PlayerTextDrawHide(playerid, HDM_GangWarTeamInfo[playerid]);
}

showJoinScreen(&playerid){
    TextDrawShowForPlayer(playerid, HDM_JoinScreenNewsBG);
	TextDrawShowForPlayer(playerid, HDM_JoinScreenName);
    PlayerTextDrawShow(playerid, HDM_JoinScreenNews[playerid]);
}

showCountDown(&playerid)
{
    PlayerTextDrawShow(playerid, PTD_CountDown[playerid]);
}

hideCountDown(&playerid)
{
    PlayerTextDrawHide(playerid, PTD_CountDown[playerid]);
}

showAnnounce()
{
	TextDrawShowForAll(HDM_AnnBG);
	TextDrawShowForAll(HDM_AnnTXT);
	TextDrawShowForAll(HDM_AnnAutor);
}

hideAnnounce()
{
	TextDrawHideForAll(HDM_AnnBG);
	TextDrawHideForAll(HDM_AnnTXT);
	TextDrawHideForAll(HDM_AnnAutor);
}

showCarInfo(&playerid){
    PlayerTextDrawShow(playerid, PTD_CarInfo[playerid]);
    PlayerTextDrawShow(playerid, PTD_CarInfoModel[playerid]);
}

hideCarInfo(&playerid){
    PlayerTextDrawHide(playerid, PTD_CarInfo[playerid]);
    PlayerTextDrawHide(playerid, PTD_CarInfoModel[playerid]);
}

showReports(&playerid){
    TextDrawShowForPlayer(playerid, TD_Reports);
}

showKillDeath(&playerid){
    PlayerTextDrawShow(playerid, PTD_DeathKill[playerid]);
}

hideKillDeath(&playerid){
    PlayerTextDrawHide(playerid, PTD_DeathKill[playerid]);
}

hideReports(&playerid){
    TextDrawHideForPlayer(playerid, TD_Reports);
}

showSpecPlayerInfo(&playerid)
{
    PlayerTextDrawShow(playerid, PTD_SpecBox[playerid]);
	PlayerTextDrawShow(playerid, PTD_SpecInfo[playerid]);
	PlayerTextDrawShow(playerid, PTD_SpecPlayerInfo[playerid]);
}

hideSpecPlayerInfo(&playerid)
{
    PlayerTextDrawHide(playerid, PTD_SpecBox[playerid]);
	PlayerTextDrawHide(playerid, PTD_SpecInfo[playerid]);
	PlayerTextDrawHide(playerid, PTD_SpecPlayerInfo[playerid]);   
}

hideJoinScreen(&playerid){
    TextDrawHideForPlayer(playerid, HDM_JoinScreenName);
    TextDrawHideForPlayer(playerid, HDM_JoinScreenNewsBG);
    PlayerTextDrawHide(playerid, HDM_JoinScreenNews[playerid]);
}

showBanScreen(&playerid){
    TextDrawShowForPlayer(playerid, HDM_JoinScreenNewsBG);
	TextDrawShowForPlayer(playerid, HDM_JoinScreenName);
    PlayerTextDrawShow(playerid, HDM_JoinScreenNews[playerid]);
}


showPlayerHud(&playerid){
	TextDrawShowForPlayer(playerid, HDM_BarinfoBG);
	TextDrawShowForPlayer(playerid, HDM_PlayersActive);
	TextDrawShowForPlayer(playerid, HDM_ActiveActivityBG);
	TextDrawShowForPlayer(playerid, HDM_BarInfo2BG);
	TextDrawShowForPlayer(playerid, HDM_BarAreainfo);
	TextDrawShowForPlayer(playerid, HDM_GMInfo);
	TextDrawShowForPlayer(playerid, HDM_BarTimeData);
    TextDrawShowForPlayer(playerid, HDM_GangInfoBG);

	PlayerTextDrawShow(playerid, HDM_BarPlayer[playerid]);
	PlayerTextDrawShow(playerid, HDM_PlayerStats[playerid]);
	//PlayerTextDrawShow(playerid, HDM_PlayerArenaInfo[playerid]);
	PlayerTextDrawShow(playerid, HDM_BarPlayerFPSPINGPACKET[playerid]);
    PlayerTextDrawShow(playerid, HDM_GangInfoKillstreak[playerid]);
    
}

showGangControl(&playerid){
    
    TextDrawShowForPlayer(playerid, HDM_GangControl);
	TextDrawShowForPlayer(playerid, HDM_GangControl1);
	TextDrawShowForPlayer(playerid, HDM_GangControl2);
	TextDrawShowForPlayer(playerid, HDM_GangControl3);
    PlayerTextDrawShow(playerid, HDM_GangControlPlayer[playerid]);

}

showScoreBoardRound(&playerid)
{
	TextDrawShowForPlayer(playerid, HDM_GWScoreBoardBG);
	TextDrawShowForPlayer(playerid, HDM_GWScoreBoardArena);
	TextDrawShowForPlayer(playerid, HDM_GWScoreBoardG1);
	TextDrawShowForPlayer(playerid, HDM_GWScoreBoardG2);
	TextDrawShowForPlayer(playerid, HDM_GWScoreBoardG1Info);
	TextDrawShowForPlayer(playerid, HDM_GWScoreBoardG2Info);
	TextDrawShowForPlayer(playerid, HDM_GWScoreBoardEndInfo);
}

hideScoreBoardRound(&playerid)
{
	TextDrawHideForPlayer(playerid, HDM_GWScoreBoardBG);
	TextDrawHideForPlayer(playerid, HDM_GWScoreBoardArena);
	TextDrawHideForPlayer(playerid, HDM_GWScoreBoardG1);
	TextDrawHideForPlayer(playerid, HDM_GWScoreBoardG2);
	TextDrawHideForPlayer(playerid, HDM_GWScoreBoardG1Info);
	TextDrawHideForPlayer(playerid, HDM_GWScoreBoardG2Info);
	TextDrawHideForPlayer(playerid, HDM_GWScoreBoardEndInfo);
}

showSniperInfo(&playerid)
{
	PlayerTextDrawShow(playerid, HDM_SniperDropPlayer[playerid]);
	PlayerTextDrawShow(playerid, HDM_SniperKills[playerid]);
}

hideSniperInfo(&playerid)
{
	PlayerTextDrawHide(playerid, HDM_SniperDropPlayer[playerid]);
	PlayerTextDrawHide(playerid, HDM_SniperKills[playerid]);
}

showArenaInfo(&playerid)
{
	PlayerTextDrawShow(playerid, HDM_PlayerArenaInfo[playerid]);
}

hideArenaInfo(&playerid)
{
	PlayerTextDrawHide(playerid, HDM_PlayerArenaInfo[playerid]);   
}

hideGangControl(&playerid){
    
	TextDrawHideForPlayer(playerid, HDM_GangControl);
	TextDrawHideForPlayer(playerid, HDM_GangControl1);
	TextDrawHideForPlayer(playerid, HDM_GangControl2);
	TextDrawHideForPlayer(playerid, HDM_GangControl3);
    PlayerTextDrawHide(playerid, HDM_GangControlPlayer[playerid]);

}

showHorseshoe(&playerid){
     PlayerTextDrawShow(playerid, PTD_Horseshoe[playerid]);
}

hideHorseshoe(&playerid){
    PlayerTextDrawHide(playerid, PTD_Horseshoe[playerid]);
}


showKillStreak(&playerid){
    PlayerTextDrawShow(playerid, PTD_KillStreak[playerid]);
}

hideKillStreak(&playerid){
    PlayerTextDrawHide(playerid, PTD_KillStreak[playerid]);

}

hidePlayerHud(&playerid){
	TextDrawHideForPlayer(playerid, HDM_BarinfoBG);
	TextDrawHideForPlayer(playerid, HDM_PlayersActive);
	TextDrawHideForPlayer(playerid, HDM_ActiveActivityBG);
	TextDrawHideForPlayer(playerid, HDM_BarInfo2BG);
	TextDrawHideForPlayer(playerid, HDM_BarAreainfo);
	TextDrawHideForPlayer(playerid, HDM_GMInfo);
	TextDrawHideForPlayer(playerid, HDM_BarTimeData);
    TextDrawHideForPlayer(playerid, HDM_GangInfoBG);

	PlayerTextDrawHide(playerid, HDM_BarPlayer[playerid]);
	PlayerTextDrawHide(playerid, HDM_PlayerStats[playerid]);
	PlayerTextDrawHide(playerid, HDM_PlayerArenaInfo[playerid]);
	PlayerTextDrawHide(playerid, HDM_BarPlayerFPSPINGPACKET[playerid]);
    PlayerTextDrawHide(playerid, HDM_GangInfoKillstreak[playerid]);

}



//Player Textdraws
createPlayerTextDraws(&playerid){

    HDM_JoinScreenNews[playerid] = CreatePlayerTextDraw(playerid, 319.000000, 165.000000, "Welcome on HardcoreDM Server~n~Login or register account and join the hardest ever DM Server");
    PlayerTextDrawFont(playerid, HDM_JoinScreenNews[playerid], 1);
    PlayerTextDrawLetterSize(playerid, HDM_JoinScreenNews[playerid], 0.250000, 0.999997);
    PlayerTextDrawTextSize(playerid, HDM_JoinScreenNews[playerid], 505.000000, 460.000000);
    PlayerTextDrawSetOutline(playerid, HDM_JoinScreenNews[playerid], 1);
    PlayerTextDrawSetShadow(playerid, HDM_JoinScreenNews[playerid], 0);
    PlayerTextDrawAlignment(playerid, HDM_JoinScreenNews[playerid], 2);
    PlayerTextDrawColor(playerid, HDM_JoinScreenNews[playerid], -1);
    PlayerTextDrawBackgroundColor(playerid, HDM_JoinScreenNews[playerid], 255);
    PlayerTextDrawBoxColor(playerid, HDM_JoinScreenNews[playerid], -251);
    PlayerTextDrawUseBox(playerid, HDM_JoinScreenNews[playerid], 0);
    PlayerTextDrawSetProportional(playerid, HDM_JoinScreenNews[playerid], 1);
    PlayerTextDrawSetSelectable(playerid, HDM_JoinScreenNews[playerid], 0);

    PTD_CarInfoModel[playerid] = CreatePlayerTextDraw(playerid, 402.000000, 262.000000, " ");
    PlayerTextDrawFont(playerid, PTD_CarInfoModel[playerid], 5);
    PlayerTextDrawLetterSize(playerid, PTD_CarInfoModel[playerid], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, PTD_CarInfoModel[playerid], 112.500000, 150.000000);
    PlayerTextDrawSetOutline(playerid, PTD_CarInfoModel[playerid], 0);
    PlayerTextDrawSetShadow(playerid, PTD_CarInfoModel[playerid], 0);
    PlayerTextDrawAlignment(playerid, PTD_CarInfoModel[playerid], 1);
    PlayerTextDrawColor(playerid, PTD_CarInfoModel[playerid], -1);
    PlayerTextDrawBackgroundColor(playerid, PTD_CarInfoModel[playerid], 0);
    PlayerTextDrawBoxColor(playerid, PTD_CarInfoModel[playerid], 255);
    PlayerTextDrawUseBox(playerid, PTD_CarInfoModel[playerid], 0);
    PlayerTextDrawSetProportional(playerid, PTD_CarInfoModel[playerid], 1);
    PlayerTextDrawSetSelectable(playerid, PTD_CarInfoModel[playerid], 0);
    PlayerTextDrawSetPreviewModel(playerid, PTD_CarInfoModel[playerid], 0);
    PlayerTextDrawSetPreviewRot(playerid, PTD_CarInfoModel[playerid], -7.000000, 0.000000, -32.000000, 1.069999);
    PlayerTextDrawSetPreviewVehCol(playerid, PTD_CarInfoModel[playerid], 6, 6);

    PTD_CarInfo[playerid] = CreatePlayerTextDraw(playerid, 455.000000, 366.000000, "Speed: 999 km/h~n~Health: 100 HP");
    PlayerTextDrawFont(playerid, PTD_CarInfo[playerid], 1);
    PlayerTextDrawLetterSize(playerid, PTD_CarInfo[playerid], 0.200000, 0.800000);
    PlayerTextDrawTextSize(playerid, PTD_CarInfo[playerid], 400.000000, 90.000000);
    PlayerTextDrawSetOutline(playerid, PTD_CarInfo[playerid], 0);
    PlayerTextDrawSetShadow(playerid, PTD_CarInfo[playerid], 1);
    PlayerTextDrawAlignment(playerid, PTD_CarInfo[playerid], 2);
    PlayerTextDrawColor(playerid, PTD_CarInfo[playerid], -1);
    PlayerTextDrawBackgroundColor(playerid, PTD_CarInfo[playerid], 255);
    PlayerTextDrawBoxColor(playerid, PTD_CarInfo[playerid], 50);
    PlayerTextDrawUseBox(playerid, PTD_CarInfo[playerid], 0);
    PlayerTextDrawSetProportional(playerid, PTD_CarInfo[playerid], 1);
    PlayerTextDrawSetSelectable(playerid, PTD_CarInfo[playerid], 0);

    PTD_KillStreak[playerid] = CreatePlayerTextDraw(playerid, 320.000000, 40.000000, "_");
    PlayerTextDrawFont(playerid, PTD_KillStreak[playerid], 1);
    PlayerTextDrawLetterSize(playerid, PTD_KillStreak[playerid], 0.599999, 2.200000);
    PlayerTextDrawTextSize(playerid, PTD_KillStreak[playerid], 400.000000, 360.000000);
    PlayerTextDrawSetOutline(playerid, PTD_KillStreak[playerid], 0);
    PlayerTextDrawSetShadow(playerid, PTD_KillStreak[playerid], 1);
    PlayerTextDrawAlignment(playerid, PTD_KillStreak[playerid], 2);
    PlayerTextDrawColor(playerid, PTD_KillStreak[playerid], -1);
    PlayerTextDrawBackgroundColor(playerid, PTD_KillStreak[playerid], 255);
    PlayerTextDrawBoxColor(playerid, PTD_KillStreak[playerid], 50);
    PlayerTextDrawUseBox(playerid, PTD_KillStreak[playerid], 0);
    PlayerTextDrawSetProportional(playerid, PTD_KillStreak[playerid], 1);
    PlayerTextDrawSetSelectable(playerid, PTD_KillStreak[playerid], 0);

    PTD_AreaIn[playerid] = CreatePlayerTextDraw(playerid, 320.000000, 200.000000, "_");
    PlayerTextDrawFont(playerid, PTD_AreaIn[playerid], 1);
    PlayerTextDrawLetterSize(playerid, PTD_AreaIn[playerid], 0.599999, 2.200000);
    PlayerTextDrawTextSize(playerid, PTD_AreaIn[playerid], 400.000000, 360.000000);
    PlayerTextDrawSetOutline(playerid, PTD_AreaIn[playerid], 0);
    PlayerTextDrawSetShadow(playerid, PTD_AreaIn[playerid], 1);
    PlayerTextDrawAlignment(playerid, PTD_AreaIn[playerid], 2);
    PlayerTextDrawColor(playerid, PTD_AreaIn[playerid], -1);
    PlayerTextDrawBackgroundColor(playerid, PTD_AreaIn[playerid], 255);
    PlayerTextDrawBoxColor(playerid, PTD_AreaIn[playerid], 50);
    PlayerTextDrawUseBox(playerid, PTD_AreaIn[playerid], 0);
    PlayerTextDrawSetProportional(playerid, PTD_AreaIn[playerid], 1);
    PlayerTextDrawSetSelectable(playerid, PTD_AreaIn[playerid], 0);

    HDM_JoinScreenPlay[playerid] = CreatePlayerTextDraw(playerid, 220.000000, 305.000000, "PLAY");
    PlayerTextDrawFont(playerid, HDM_JoinScreenPlay[playerid], 1);
    PlayerTextDrawLetterSize(playerid, HDM_JoinScreenPlay[playerid], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, HDM_JoinScreenPlay[playerid], 34.500000, 22.000000);
    PlayerTextDrawSetOutline(playerid, HDM_JoinScreenPlay[playerid], 1);
    PlayerTextDrawSetShadow(playerid, HDM_JoinScreenPlay[playerid], 0);
    PlayerTextDrawAlignment(playerid, HDM_JoinScreenPlay[playerid], 2);
    PlayerTextDrawColor(playerid, HDM_JoinScreenPlay[playerid], -1);
    PlayerTextDrawBackgroundColor(playerid, HDM_JoinScreenPlay[playerid], 255);
    PlayerTextDrawBoxColor(playerid, HDM_JoinScreenPlay[playerid], 50);
    PlayerTextDrawUseBox(playerid, HDM_JoinScreenPlay[playerid], 0);
    PlayerTextDrawSetProportional(playerid, HDM_JoinScreenPlay[playerid], 1);
    PlayerTextDrawSetSelectable(playerid, HDM_JoinScreenPlay[playerid], 1);

    HDM_JoinScreenExit[playerid] = CreatePlayerTextDraw(playerid, 420.000000, 305.000000, "EXIT");
    PlayerTextDrawFont(playerid, HDM_JoinScreenExit[playerid], 1);
    PlayerTextDrawLetterSize(playerid, HDM_JoinScreenExit[playerid], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, HDM_JoinScreenExit[playerid], 34.500000, 22.000000);
    PlayerTextDrawSetOutline(playerid, HDM_JoinScreenExit[playerid], 1);
    PlayerTextDrawSetShadow(playerid, HDM_JoinScreenExit[playerid], 0);
    PlayerTextDrawAlignment(playerid, HDM_JoinScreenExit[playerid], 2);
    PlayerTextDrawColor(playerid, HDM_JoinScreenExit[playerid], -1);
    PlayerTextDrawBackgroundColor(playerid, HDM_JoinScreenExit[playerid], 255);
    PlayerTextDrawBoxColor(playerid, HDM_JoinScreenExit[playerid], 50);
    PlayerTextDrawUseBox(playerid, HDM_JoinScreenExit[playerid], 0);
    PlayerTextDrawSetProportional(playerid, HDM_JoinScreenExit[playerid], 1);
    PlayerTextDrawSetSelectable(playerid, HDM_JoinScreenExit[playerid], 1);

    PTD_Horseshoe[playerid] = CreatePlayerTextDraw(playerid, 569.000000, 300.000000, "_");
    PlayerTextDrawFont(playerid, PTD_Horseshoe[playerid], 5);
    PlayerTextDrawLetterSize(playerid, PTD_Horseshoe[playerid], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, PTD_Horseshoe[playerid], 38.500000, 52.000000);
    PlayerTextDrawSetOutline(playerid, PTD_Horseshoe[playerid], 1);
    PlayerTextDrawSetShadow(playerid, PTD_Horseshoe[playerid], 0);
    PlayerTextDrawAlignment(playerid, PTD_Horseshoe[playerid], 1);
    PlayerTextDrawColor(playerid, PTD_Horseshoe[playerid], -741092353);
    PlayerTextDrawBackgroundColor(playerid, PTD_Horseshoe[playerid], 0);
    PlayerTextDrawBoxColor(playerid, PTD_Horseshoe[playerid], 0);
    PlayerTextDrawUseBox(playerid, PTD_Horseshoe[playerid], 0);
    PlayerTextDrawSetProportional(playerid, PTD_Horseshoe[playerid], 1);
    PlayerTextDrawSetSelectable(playerid, PTD_Horseshoe[playerid], 0);
    PlayerTextDrawSetPreviewModel(playerid, PTD_Horseshoe[playerid], 954);
    PlayerTextDrawSetPreviewRot(playerid, PTD_Horseshoe[playerid], 0.000000, 0.000000, 0.000000, 1.000000);
    PlayerTextDrawSetPreviewVehCol(playerid, PTD_Horseshoe[playerid], 1, 1);

    PTD_DeathKill[playerid] = CreatePlayerTextDraw(playerid, 460.000000, 300.000000, "_");
	PlayerTextDrawFont(playerid, PTD_DeathKill[playerid], 1);
	PlayerTextDrawLetterSize(playerid, PTD_DeathKill[playerid], 0.200000, 0.899999);
	PlayerTextDrawTextSize(playerid, PTD_DeathKill[playerid], 435.000000, 167.000000);
	PlayerTextDrawSetOutline(playerid, PTD_DeathKill[playerid], 0);
	PlayerTextDrawSetShadow(playerid, PTD_DeathKill[playerid], 1);
	PlayerTextDrawAlignment(playerid, PTD_DeathKill[playerid], 2);
	PlayerTextDrawColor(playerid, PTD_DeathKill[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, PTD_DeathKill[playerid], 255);
	PlayerTextDrawBoxColor(playerid, PTD_DeathKill[playerid], 50);
	PlayerTextDrawUseBox(playerid, PTD_DeathKill[playerid], 0);
	PlayerTextDrawSetProportional(playerid, PTD_DeathKill[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, PTD_DeathKill[playerid], 0);

    PTD_CountDown[playerid] = CreatePlayerTextDraw(playerid, 320.000000, 85.000000, "_");
	PlayerTextDrawFont(playerid, PTD_CountDown[playerid], 1);
	PlayerTextDrawLetterSize(playerid, PTD_CountDown[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, PTD_CountDown[playerid], 406.000000, 39.500000);
	PlayerTextDrawSetOutline(playerid, PTD_CountDown[playerid], 0);
	PlayerTextDrawSetShadow(playerid, PTD_CountDown[playerid], 1);
	PlayerTextDrawAlignment(playerid, PTD_CountDown[playerid], 2);
	PlayerTextDrawColor(playerid, PTD_CountDown[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, PTD_CountDown[playerid], 255);
	PlayerTextDrawBoxColor(playerid, PTD_CountDown[playerid], 50);
	PlayerTextDrawUseBox(playerid, PTD_CountDown[playerid], 0);
	PlayerTextDrawSetProportional(playerid, PTD_CountDown[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, PTD_CountDown[playerid], 0);

    PTD_SpecBox[playerid] = CreatePlayerTextDraw(playerid, 66.000000, 255.000000, "LD_POKE:CD9S");
	PlayerTextDrawFont(playerid, PTD_SpecBox[playerid], 4);
	PlayerTextDrawLetterSize(playerid, PTD_SpecBox[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, PTD_SpecBox[playerid], 133.000000, 61.000000);
	PlayerTextDrawSetOutline(playerid, PTD_SpecBox[playerid], 1);
	PlayerTextDrawSetShadow(playerid, PTD_SpecBox[playerid], 0);
	PlayerTextDrawAlignment(playerid, PTD_SpecBox[playerid], 2);
	PlayerTextDrawColor(playerid, PTD_SpecBox[playerid], 185);
	PlayerTextDrawBackgroundColor(playerid, PTD_SpecBox[playerid], 255);
	PlayerTextDrawBoxColor(playerid, PTD_SpecBox[playerid], 50);
	PlayerTextDrawUseBox(playerid, PTD_SpecBox[playerid], 0);
	PlayerTextDrawSetProportional(playerid, PTD_SpecBox[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, PTD_SpecBox[playerid], 0);

	PTD_SpecInfo[playerid] = CreatePlayerTextDraw(playerid, 132.000000, 261.000000, "_");
	PlayerTextDrawFont(playerid, PTD_SpecInfo[playerid], 1);
	PlayerTextDrawLetterSize(playerid, PTD_SpecInfo[playerid], 0.150000, 0.899999);
	PlayerTextDrawTextSize(playerid, PTD_SpecInfo[playerid], 105.000000, 153.000000);
	PlayerTextDrawSetOutline(playerid, PTD_SpecInfo[playerid], 0);
	PlayerTextDrawSetShadow(playerid, PTD_SpecInfo[playerid], 1);
	PlayerTextDrawAlignment(playerid, PTD_SpecInfo[playerid], 2);
	PlayerTextDrawColor(playerid, PTD_SpecInfo[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, PTD_SpecInfo[playerid], 255);
	PlayerTextDrawBoxColor(playerid, PTD_SpecInfo[playerid], 50);
	PlayerTextDrawUseBox(playerid, PTD_SpecInfo[playerid], 0);
	PlayerTextDrawSetProportional(playerid, PTD_SpecInfo[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, PTD_SpecInfo[playerid], 0);

	PTD_SpecPlayerInfo[playerid] = CreatePlayerTextDraw(playerid, 132.000000, 276.000000, "_");
	PlayerTextDrawFont(playerid, PTD_SpecPlayerInfo[playerid], 1);
	PlayerTextDrawLetterSize(playerid, PTD_SpecPlayerInfo[playerid], 0.150000, 0.899999);
	PlayerTextDrawTextSize(playerid, PTD_SpecPlayerInfo[playerid], 105.000000, 153.000000);
	PlayerTextDrawSetOutline(playerid, PTD_SpecPlayerInfo[playerid], 0);
	PlayerTextDrawSetShadow(playerid, PTD_SpecPlayerInfo[playerid], 1);
	PlayerTextDrawAlignment(playerid, PTD_SpecPlayerInfo[playerid], 2);
	PlayerTextDrawColor(playerid, PTD_SpecPlayerInfo[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, PTD_SpecPlayerInfo[playerid], 255);
	PlayerTextDrawBoxColor(playerid, PTD_SpecPlayerInfo[playerid], 50);
	PlayerTextDrawUseBox(playerid, PTD_SpecPlayerInfo[playerid], 0);
	PlayerTextDrawSetProportional(playerid, PTD_SpecPlayerInfo[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, PTD_SpecPlayerInfo[playerid], 0);
    
    //updated td

    HDM_BarPlayer[playerid] = CreatePlayerTextDraw(playerid, 111.000000, 435.700012, "SHAKE [ID:69] 9999/29999 LVL: 69 Gang: Virtual Masters");
	PlayerTextDrawFont(playerid, HDM_BarPlayer[playerid], 1);
	PlayerTextDrawLetterSize(playerid, HDM_BarPlayer[playerid], 0.150000, 0.800000);
	PlayerTextDrawTextSize(playerid, HDM_BarPlayer[playerid], 450.000000, 220.000000);
	PlayerTextDrawSetOutline(playerid, HDM_BarPlayer[playerid], 0);
	PlayerTextDrawSetShadow(playerid, HDM_BarPlayer[playerid], 0);
	PlayerTextDrawAlignment(playerid, HDM_BarPlayer[playerid], 2);
	PlayerTextDrawColor(playerid, HDM_BarPlayer[playerid], -2686721);
	PlayerTextDrawBackgroundColor(playerid, HDM_BarPlayer[playerid], 255);
	PlayerTextDrawBoxColor(playerid, HDM_BarPlayer[playerid], 255);
	PlayerTextDrawUseBox(playerid, HDM_BarPlayer[playerid], 0);
	PlayerTextDrawSetProportional(playerid, HDM_BarPlayer[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, HDM_BarPlayer[playerid], 0);

	HDM_PlayerStats[playerid] = CreatePlayerTextDraw(playerid, 319.000000, 435.700012, "Kills: 9999 Deaths: 9999 Ratio: 9.99");
	PlayerTextDrawFont(playerid, HDM_PlayerStats[playerid], 1);
	PlayerTextDrawLetterSize(playerid, HDM_PlayerStats[playerid], 0.150000, 0.800000);
	PlayerTextDrawTextSize(playerid, HDM_PlayerStats[playerid], 440.000000, 154.500000);
	PlayerTextDrawSetOutline(playerid, HDM_PlayerStats[playerid], 0);
	PlayerTextDrawSetShadow(playerid, HDM_PlayerStats[playerid], 0);
	PlayerTextDrawAlignment(playerid, HDM_PlayerStats[playerid], 2);
	PlayerTextDrawColor(playerid, HDM_PlayerStats[playerid], -2686721);
	PlayerTextDrawBackgroundColor(playerid, HDM_PlayerStats[playerid], 255);
	PlayerTextDrawBoxColor(playerid, HDM_PlayerStats[playerid], 255);
	PlayerTextDrawUseBox(playerid, HDM_PlayerStats[playerid], 0);
	PlayerTextDrawSetProportional(playerid, HDM_PlayerStats[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, HDM_PlayerStats[playerid], 0);

	HDM_PlayerArenaInfo[playerid] = CreatePlayerTextDraw(playerid, 590.000000, 360.000000, "Arena Onede~n~~n~Kills: 999~n~Deaths: 999~n~Ratio: 9.99");
	PlayerTextDrawFont(playerid, HDM_PlayerArenaInfo[playerid], 1);
	PlayerTextDrawLetterSize(playerid, HDM_PlayerArenaInfo[playerid], 0.150000, 0.800000);
	PlayerTextDrawTextSize(playerid, HDM_PlayerArenaInfo[playerid], 400.000000, 72.500000);
	PlayerTextDrawSetOutline(playerid, HDM_PlayerArenaInfo[playerid], 0);
	PlayerTextDrawSetShadow(playerid, HDM_PlayerArenaInfo[playerid], 0);
	PlayerTextDrawAlignment(playerid, HDM_PlayerArenaInfo[playerid], 2);
	PlayerTextDrawColor(playerid, HDM_PlayerArenaInfo[playerid], -2686721);
	PlayerTextDrawBackgroundColor(playerid, HDM_PlayerArenaInfo[playerid], 255);
	PlayerTextDrawBoxColor(playerid, HDM_PlayerArenaInfo[playerid], 50);
	PlayerTextDrawUseBox(playerid, HDM_PlayerArenaInfo[playerid], 0);
	PlayerTextDrawSetProportional(playerid, HDM_PlayerArenaInfo[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, HDM_PlayerArenaInfo[playerid], 0);

	HDM_GangControlPlayer[playerid] = CreatePlayerTextDraw(playerid, 590.000000, 395.700012, "Your Gang: 69696");
	PlayerTextDrawFont(playerid, HDM_GangControlPlayer[playerid], 1);
	PlayerTextDrawLetterSize(playerid, HDM_GangControlPlayer[playerid], 0.150000, 0.800000);
	PlayerTextDrawTextSize(playerid, HDM_GangControlPlayer[playerid], 440.000000, 212.000000);
	PlayerTextDrawSetOutline(playerid, HDM_GangControlPlayer[playerid], 0);
	PlayerTextDrawSetShadow(playerid, HDM_GangControlPlayer[playerid], 0);
	PlayerTextDrawAlignment(playerid, HDM_GangControlPlayer[playerid], 2);
	PlayerTextDrawColor(playerid, HDM_GangControlPlayer[playerid], -2686721);
	PlayerTextDrawBackgroundColor(playerid, HDM_GangControlPlayer[playerid], 255);
	PlayerTextDrawBoxColor(playerid, HDM_GangControlPlayer[playerid], 255);
	PlayerTextDrawUseBox(playerid, HDM_GangControlPlayer[playerid], 0);
	PlayerTextDrawSetProportional(playerid, HDM_GangControlPlayer[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, HDM_GangControlPlayer[playerid], 0);

	HDM_BarPlayerFPSPINGPACKET[playerid] = CreatePlayerTextDraw(playerid, 575.000000, 3.000000, "On area: 69 AFK:69 /onede: 69 /sawn: 69");
	PlayerTextDrawFont(playerid, HDM_BarPlayerFPSPINGPACKET[playerid], 1);
	PlayerTextDrawLetterSize(playerid, HDM_BarPlayerFPSPINGPACKET[playerid], 0.150000, 0.800000);
	PlayerTextDrawTextSize(playerid, HDM_BarPlayerFPSPINGPACKET[playerid], 440.000000, 212.000000);
	PlayerTextDrawSetOutline(playerid, HDM_BarPlayerFPSPINGPACKET[playerid], 0);
	PlayerTextDrawSetShadow(playerid, HDM_BarPlayerFPSPINGPACKET[playerid], 0);
	PlayerTextDrawAlignment(playerid, HDM_BarPlayerFPSPINGPACKET[playerid], 2);
	PlayerTextDrawColor(playerid, HDM_BarPlayerFPSPINGPACKET[playerid], -2686721);
	PlayerTextDrawBackgroundColor(playerid, HDM_BarPlayerFPSPINGPACKET[playerid], 255);
	PlayerTextDrawBoxColor(playerid, HDM_BarPlayerFPSPINGPACKET[playerid], 255);
	PlayerTextDrawUseBox(playerid, HDM_BarPlayerFPSPINGPACKET[playerid], 0);
	PlayerTextDrawSetProportional(playerid, HDM_BarPlayerFPSPINGPACKET[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, HDM_BarPlayerFPSPINGPACKET[playerid], 0);

    HDM_GangInfoKillstreak[playerid] = CreatePlayerTextDraw(playerid, 558.000000, 102.000000, "Virtual Masters [vM][ID:69]~n~Gangpoints: 6969696~n~~n~Killstreak: 10");
	PlayerTextDrawFont(playerid, HDM_GangInfoKillstreak[playerid], 1);
	PlayerTextDrawLetterSize(playerid, HDM_GangInfoKillstreak[playerid], 0.150000, 0.800000);
	PlayerTextDrawTextSize(playerid, HDM_GangInfoKillstreak[playerid], 398.500000, 95.000000);
	PlayerTextDrawSetOutline(playerid, HDM_GangInfoKillstreak[playerid], 0);
	PlayerTextDrawSetShadow(playerid, HDM_GangInfoKillstreak[playerid], 1);
	PlayerTextDrawAlignment(playerid, HDM_GangInfoKillstreak[playerid], 2);
	PlayerTextDrawColor(playerid, HDM_GangInfoKillstreak[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, HDM_GangInfoKillstreak[playerid], 255);
	PlayerTextDrawBoxColor(playerid, HDM_GangInfoKillstreak[playerid], -1962934222);
	PlayerTextDrawUseBox(playerid, HDM_GangInfoKillstreak[playerid], 0);
	PlayerTextDrawSetProportional(playerid, HDM_GangInfoKillstreak[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, HDM_GangInfoKillstreak[playerid], 0);

	HDM_AimInfo[playerid] = CreatePlayerTextDraw(playerid, 443.000000, 145.000000, "~y~Nickname ID:0~n~FPS: 102~n~Ping: 69~n~Packet:0.00");
	PlayerTextDrawFont(playerid, HDM_AimInfo[playerid], 1);
	PlayerTextDrawLetterSize(playerid, HDM_AimInfo[playerid], 0.129999, 0.699999);
	PlayerTextDrawTextSize(playerid, HDM_AimInfo[playerid], 400.000000, 100.000000);
	PlayerTextDrawSetOutline(playerid, HDM_AimInfo[playerid], 0);
	PlayerTextDrawSetShadow(playerid, HDM_AimInfo[playerid], 1);
	PlayerTextDrawAlignment(playerid, HDM_AimInfo[playerid], 2);
	PlayerTextDrawColor(playerid, HDM_AimInfo[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, HDM_AimInfo[playerid], 255);
	PlayerTextDrawBoxColor(playerid, HDM_AimInfo[playerid], 50);
	PlayerTextDrawUseBox(playerid, HDM_AimInfo[playerid], 0);
	PlayerTextDrawSetProportional(playerid, HDM_AimInfo[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, HDM_AimInfo[playerid], 0);

	HDM_SniperDropPlayer[playerid] = CreatePlayerTextDraw(playerid, 509.000000, 295.000000, "TextDraw");
	PlayerTextDrawFont(playerid, HDM_SniperDropPlayer[playerid], 5);
	PlayerTextDrawLetterSize(playerid, HDM_SniperDropPlayer[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, HDM_SniperDropPlayer[playerid], 50.000000, 50.000000);
	PlayerTextDrawSetOutline(playerid, HDM_SniperDropPlayer[playerid], 1);
	PlayerTextDrawSetShadow(playerid, HDM_SniperDropPlayer[playerid], 0);
	PlayerTextDrawAlignment(playerid, HDM_SniperDropPlayer[playerid], 1);
	PlayerTextDrawColor(playerid, HDM_SniperDropPlayer[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, HDM_SniperDropPlayer[playerid], 0);
	PlayerTextDrawBoxColor(playerid, HDM_SniperDropPlayer[playerid], 50);
	PlayerTextDrawUseBox(playerid, HDM_SniperDropPlayer[playerid], 1);
	PlayerTextDrawSetProportional(playerid, HDM_SniperDropPlayer[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, HDM_SniperDropPlayer[playerid], 0);
	PlayerTextDrawSetPreviewModel(playerid, HDM_SniperDropPlayer[playerid], 358);
	PlayerTextDrawSetPreviewRot(playerid, HDM_SniperDropPlayer[playerid], 2.000000, 30.000000, -120.000000, 0.839999);
	PlayerTextDrawSetPreviewVehCol(playerid, HDM_SniperDropPlayer[playerid], 1, 1);

	HDM_SniperKills[playerid] = CreatePlayerTextDraw(playerid, 526.000000, 346.700012, "Sniper Kills: ~y~0");
	PlayerTextDrawFont(playerid, HDM_SniperKills[playerid], 1);
	PlayerTextDrawLetterSize(playerid, HDM_SniperKills[playerid], 0.150000, 0.800000);
	PlayerTextDrawTextSize(playerid, HDM_SniperKills[playerid], 404.000000, 97.000000);
	PlayerTextDrawSetOutline(playerid, HDM_SniperKills[playerid], 0);
	PlayerTextDrawSetShadow(playerid, HDM_SniperKills[playerid], 1);
	PlayerTextDrawAlignment(playerid, HDM_SniperKills[playerid], 2);
	PlayerTextDrawColor(playerid, HDM_SniperKills[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, HDM_SniperKills[playerid], 255);
	PlayerTextDrawBoxColor(playerid, HDM_SniperKills[playerid], 180);
	PlayerTextDrawUseBox(playerid, HDM_SniperKills[playerid], 0);
	PlayerTextDrawSetProportional(playerid, HDM_SniperKills[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, HDM_SniperKills[playerid], 0);

	HDM_GangWarTeamInfo[playerid] = CreatePlayerTextDraw(playerid, 11.000000, 285.000000, "_");
	PlayerTextDrawFont(playerid, HDM_GangWarTeamInfo[playerid], 1);
	PlayerTextDrawLetterSize(playerid, HDM_GangWarTeamInfo[playerid], 0.150000, 0.699998);
	PlayerTextDrawTextSize(playerid, HDM_GangWarTeamInfo[playerid], 130.000000, 124.500000);
	PlayerTextDrawSetOutline(playerid, HDM_GangWarTeamInfo[playerid], 0);
	PlayerTextDrawSetShadow(playerid, HDM_GangWarTeamInfo[playerid], 1);
	PlayerTextDrawAlignment(playerid, HDM_GangWarTeamInfo[playerid], 1);
	PlayerTextDrawColor(playerid, HDM_GangWarTeamInfo[playerid], -1962934017);
	PlayerTextDrawBackgroundColor(playerid, HDM_GangWarTeamInfo[playerid], 255);
	PlayerTextDrawBoxColor(playerid, HDM_GangWarTeamInfo[playerid], 50);
	PlayerTextDrawUseBox(playerid, HDM_GangWarTeamInfo[playerid], 0);
	PlayerTextDrawSetProportional(playerid, HDM_GangWarTeamInfo[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, HDM_GangWarTeamInfo[playerid], 0);

	HDM_GWPlayerStats[playerid] = CreatePlayerTextDraw(playerid, 610.000000, 380.000000, "GANGNAME~n~NickName~n~kills~n~deaths~n~DMG:");
	PlayerTextDrawFont(playerid, HDM_GWPlayerStats[playerid], 1);
	PlayerTextDrawLetterSize(playerid, HDM_GWPlayerStats[playerid], 0.150000, 0.699999);
	PlayerTextDrawTextSize(playerid, HDM_GWPlayerStats[playerid], 400.000000, 53.500000);
	PlayerTextDrawSetOutline(playerid, HDM_GWPlayerStats[playerid], 0);
	PlayerTextDrawSetShadow(playerid, HDM_GWPlayerStats[playerid], 1);
	PlayerTextDrawAlignment(playerid, HDM_GWPlayerStats[playerid], 2);
	PlayerTextDrawColor(playerid, HDM_GWPlayerStats[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, HDM_GWPlayerStats[playerid], 255);
	PlayerTextDrawBoxColor(playerid, HDM_GWPlayerStats[playerid], 16711730);
	PlayerTextDrawUseBox(playerid, HDM_GWPlayerStats[playerid], 0);
	PlayerTextDrawSetProportional(playerid, HDM_GWPlayerStats[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, HDM_GWPlayerStats[playerid], 0);

}

    //Textdraws
createGlobalTextDraws(){

	HDM_JoinScreenBG = TextDrawCreate(-3.000000, -3.000000, "LD_CARD:cd9s");
	TextDrawFont(HDM_JoinScreenBG, 4);
	TextDrawLetterSize(HDM_JoinScreenBG, 0.600000, 2.000000);
	TextDrawTextSize(HDM_JoinScreenBG, 647.000000, 457.000000);
	TextDrawSetOutline(HDM_JoinScreenBG, 1);
	TextDrawSetShadow(HDM_JoinScreenBG, 0);
	TextDrawAlignment(HDM_JoinScreenBG, 1);
	TextDrawColor(HDM_JoinScreenBG, 255);
	TextDrawBackgroundColor(HDM_JoinScreenBG, 255);
   	TextDrawBoxColor(HDM_JoinScreenBG, 50);
   	TextDrawUseBox(HDM_JoinScreenBG, 1);
   	TextDrawSetProportional(HDM_JoinScreenBG, 1);
   	TextDrawSetSelectable(HDM_JoinScreenBG, 0);

	HDM_JoinScreenName = TextDrawCreate(320.000000, 100.000000, "HardcoreDM");
	TextDrawFont(HDM_JoinScreenName, 2);
	TextDrawLetterSize(HDM_JoinScreenName, 1.500000, 5.000000);
	TextDrawTextSize(HDM_JoinScreenName, 400.000000, 17.000000);
	TextDrawSetOutline(HDM_JoinScreenName, 1);
	TextDrawSetShadow(HDM_JoinScreenName, 0);
	TextDrawAlignment(HDM_JoinScreenName, 2);
	TextDrawColor(HDM_JoinScreenName, 255);
	TextDrawBackgroundColor(HDM_JoinScreenName, -1);
	TextDrawBoxColor(HDM_JoinScreenName, 50);
	TextDrawUseBox(HDM_JoinScreenName, 0);
	TextDrawSetProportional(HDM_JoinScreenName, 1);
	TextDrawSetSelectable(HDM_JoinScreenName, 0);
	

	HDM_JoinScreenNewsBG = TextDrawCreate(319.000000, 144.000000, "_");
	TextDrawFont(HDM_JoinScreenNewsBG, 1);
	TextDrawLetterSize(HDM_JoinScreenNewsBG, 0.600000, 22.000000);
	TextDrawTextSize(HDM_JoinScreenNewsBG, 505.000000, 460.000000);
	TextDrawSetOutline(HDM_JoinScreenNewsBG, 1);
	TextDrawSetShadow(HDM_JoinScreenNewsBG, 0);
	TextDrawAlignment(HDM_JoinScreenNewsBG, 2);
	TextDrawColor(HDM_JoinScreenNewsBG, -1);
	TextDrawBackgroundColor(HDM_JoinScreenNewsBG, 255);
	TextDrawBoxColor(HDM_JoinScreenNewsBG, 180);
	TextDrawUseBox(HDM_JoinScreenNewsBG, 1);
	TextDrawSetProportional(HDM_JoinScreenNewsBG, 1);
	TextDrawSetSelectable(HDM_JoinScreenNewsBG, 0);

    TD_Reports = TextDrawCreate(190.000000, 357.000000, "~y~Sometimes I stagger even myself with my genius.");
    TextDrawFont(TD_Reports, 1);
    TextDrawLetterSize(TD_Reports, 0.150000, 0.699999);
    TextDrawTextSize(TD_Reports, 400.000000, 165.500000);
    TextDrawSetOutline(TD_Reports, 1);
    TextDrawSetShadow(TD_Reports, 0);
    TextDrawAlignment(TD_Reports, 2);
    TextDrawColor(TD_Reports, -764862721);
    TextDrawBackgroundColor(TD_Reports, 255);
    TextDrawBoxColor(TD_Reports, 50);
    TextDrawUseBox(TD_Reports, 0);
    TextDrawSetProportional(TD_Reports, 1);
    TextDrawSetSelectable(TD_Reports, 0);

    //UPDATED TD
	HDM_BarinfoBG = TextDrawCreate(319.000000, 433.700012, "_");
	TextDrawFont(HDM_BarinfoBG, 1);
	TextDrawLetterSize(HDM_BarinfoBG, 0.595833, 1.399999);
	TextDrawTextSize(HDM_BarinfoBG, 450.000000, 640.000000);
	TextDrawSetOutline(HDM_BarinfoBG, 1);
	TextDrawSetShadow(HDM_BarinfoBG, 0);
	TextDrawAlignment(HDM_BarinfoBG, 2);
	TextDrawColor(HDM_BarinfoBG, -1);
	TextDrawBackgroundColor(HDM_BarinfoBG, 255);
	TextDrawBoxColor(HDM_BarinfoBG, 180);
	TextDrawUseBox(HDM_BarinfoBG, 1);
	TextDrawSetProportional(HDM_BarinfoBG, 1);
	TextDrawSetSelectable(HDM_BarinfoBG, 0);

	HDM_BarInfo2BG = TextDrawCreate(542.500000, 0.000000, "_");
	TextDrawFont(HDM_BarInfo2BG, 1);
	TextDrawLetterSize(HDM_BarInfo2BG, 0.595833, 1.399999);
	TextDrawTextSize(HDM_BarInfo2BG, 275.000000, 186.500000);
	TextDrawSetOutline(HDM_BarInfo2BG, 1);
	TextDrawSetShadow(HDM_BarInfo2BG, 0);
	TextDrawAlignment(HDM_BarInfo2BG, 2);
	TextDrawColor(HDM_BarInfo2BG, -1);
	TextDrawBackgroundColor(HDM_BarInfo2BG, 255);
	TextDrawBoxColor(HDM_BarInfo2BG, 180);
	TextDrawUseBox(HDM_BarInfo2BG, 1);
	TextDrawSetProportional(HDM_BarInfo2BG, 1);
	TextDrawSetSelectable(HDM_BarInfo2BG, 0);

	HDM_ActiveActivityBG = TextDrawCreate(590.000000, 356.700012, "_");
	TextDrawFont(HDM_ActiveActivityBG, 1);
	TextDrawLetterSize(HDM_ActiveActivityBG, 0.595833, 5.650002);
	TextDrawTextSize(HDM_ActiveActivityBG, 0.000000, 83.000000);
	TextDrawSetOutline(HDM_ActiveActivityBG, 1);
	TextDrawSetShadow(HDM_ActiveActivityBG, 0);
	TextDrawAlignment(HDM_ActiveActivityBG, 2);
	TextDrawColor(HDM_ActiveActivityBG, -1);
	TextDrawBackgroundColor(HDM_ActiveActivityBG, 255);
	TextDrawBoxColor(HDM_ActiveActivityBG, 180);
	TextDrawUseBox(HDM_ActiveActivityBG, 1);
	TextDrawSetProportional(HDM_ActiveActivityBG, 1);
	TextDrawSetSelectable(HDM_ActiveActivityBG, 0);
	
	HDM_GangInfoBG = TextDrawCreate(558.000000, 100.700012, "_");
	TextDrawFont(HDM_GangInfoBG, 1);
	TextDrawLetterSize(HDM_GangInfoBG, 0.000000, 3.399994);
	TextDrawTextSize(HDM_GangInfoBG, 0.000000, 96.000000);
	TextDrawSetOutline(HDM_GangInfoBG, 1);
	TextDrawSetShadow(HDM_GangInfoBG, 0);
	TextDrawAlignment(HDM_GangInfoBG, 2);
	TextDrawColor(HDM_GangInfoBG, -1);
	TextDrawBackgroundColor(HDM_GangInfoBG, 255);
	TextDrawBoxColor(HDM_GangInfoBG, 180);
	TextDrawUseBox(HDM_GangInfoBG, 1);
	TextDrawSetProportional(HDM_GangInfoBG, 1);
	TextDrawSetSelectable(HDM_GangInfoBG, 0);

	HDM_AnnBG = TextDrawCreate(106.000000, 225.000000, "_");
	TextDrawFont(HDM_AnnBG, 1);
	TextDrawLetterSize(HDM_AnnBG, 0.600000, 4.099998);
	TextDrawTextSize(HDM_AnnBG, 398.500000, 180.000000);
	TextDrawSetOutline(HDM_AnnBG, 1);
	TextDrawSetShadow(HDM_AnnBG, 0);
	TextDrawAlignment(HDM_AnnBG, 2);
	TextDrawColor(HDM_AnnBG, -1);
	TextDrawBackgroundColor(HDM_AnnBG, 255);
	TextDrawBoxColor(HDM_AnnBG, 180);
	TextDrawUseBox(HDM_AnnBG, 1);
	TextDrawSetProportional(HDM_AnnBG, 1);
	TextDrawSetSelectable(HDM_AnnBG, 0);

	HDM_GangControl = TextDrawCreate(590.000000, 359.700012, "~y~Owned by:");
	TextDrawFont(HDM_GangControl, 1);
	TextDrawLetterSize(HDM_GangControl, 0.150000, 0.800000);
	TextDrawTextSize(HDM_GangControl, 440.000000, 212.000000);
	TextDrawSetOutline(HDM_GangControl, 1);
	TextDrawSetShadow(HDM_GangControl, 0);
	TextDrawAlignment(HDM_GangControl, 2);
	TextDrawColor(HDM_GangControl, -2686721);
	TextDrawBackgroundColor(HDM_GangControl, 255);
	TextDrawBoxColor(HDM_GangControl, 255);
	TextDrawUseBox(HDM_GangControl, 0);
	TextDrawSetProportional(HDM_GangControl, 1);
	TextDrawSetSelectable(HDM_GangControl, 0);

	HDM_GangControl1 = TextDrawCreate(590.000000, 368.700012, "_");
	TextDrawFont(HDM_GangControl1, 1);
	TextDrawLetterSize(HDM_GangControl1, 0.150000, 0.800000);
	TextDrawTextSize(HDM_GangControl1, 440.000000, 212.000000);
	TextDrawSetOutline(HDM_GangControl1, 1);
	TextDrawSetShadow(HDM_GangControl1, 0);
	TextDrawAlignment(HDM_GangControl1, 2);
	TextDrawColor(HDM_GangControl1, -1);
	TextDrawBackgroundColor(HDM_GangControl1, 255);
	TextDrawBoxColor(HDM_GangControl1, 255);
	TextDrawUseBox(HDM_GangControl1, 0);
	TextDrawSetProportional(HDM_GangControl1, 1);
	TextDrawSetSelectable(HDM_GangControl1, 0);

	HDM_GangControl2 = TextDrawCreate(590.000000, 377.700012, "_");
	TextDrawFont(HDM_GangControl2, 1);
	TextDrawLetterSize(HDM_GangControl2, 0.150000, 0.800000);
	TextDrawTextSize(HDM_GangControl2, 440.000000, 212.000000);
	TextDrawSetOutline(HDM_GangControl2, 1);
	TextDrawSetShadow(HDM_GangControl2, 0);
	TextDrawAlignment(HDM_GangControl2, 2);
	TextDrawColor(HDM_GangControl2, -1);
	TextDrawBackgroundColor(HDM_GangControl2, 255);
	TextDrawBoxColor(HDM_GangControl2, 255);
	TextDrawUseBox(HDM_GangControl2, 0);
	TextDrawSetProportional(HDM_GangControl2, 1);
	TextDrawSetSelectable(HDM_GangControl2, 0);

	HDM_GangControl3 = TextDrawCreate(590.000000, 386.700012, "_");
	TextDrawFont(HDM_GangControl3, 1);
	TextDrawLetterSize(HDM_GangControl3, 0.150000, 0.800000);
	TextDrawTextSize(HDM_GangControl3, 440.000000, 212.000000);
	TextDrawSetOutline(HDM_GangControl3, 1);
	TextDrawSetShadow(HDM_GangControl3, 0);
	TextDrawAlignment(HDM_GangControl3, 2);
	TextDrawColor(HDM_GangControl3, -1);
	TextDrawBackgroundColor(HDM_GangControl3, 255);
	TextDrawBoxColor(HDM_GangControl3, 255);
	TextDrawUseBox(HDM_GangControl3, 0);
	TextDrawSetProportional(HDM_GangControl3, 1);
	TextDrawSetSelectable(HDM_GangControl3, 0);

    HDM_PlayersActive = TextDrawCreate(539.000000, 435.700012, "On area: 69 AFK:69 /onede: 69 /sawn: 69");
	TextDrawFont(HDM_PlayersActive, 1);
	TextDrawLetterSize(HDM_PlayersActive, 0.150000, 0.800000);
	TextDrawTextSize(HDM_PlayersActive, 440.000000, 212.000000);
	TextDrawSetOutline(HDM_PlayersActive, 0);
	TextDrawSetShadow(HDM_PlayersActive, 0);
	TextDrawAlignment(HDM_PlayersActive, 2);
	TextDrawColor(HDM_PlayersActive, -2686721);
	TextDrawBackgroundColor(HDM_PlayersActive, 255);
	TextDrawBoxColor(HDM_PlayersActive, 255);
	TextDrawUseBox(HDM_PlayersActive, 0);
	TextDrawSetProportional(HDM_PlayersActive, 1);
	TextDrawSetSelectable(HDM_PlayersActive, 0);

	HDM_BarAreainfo = TextDrawCreate(319.000000, 423.200012, "Kills: 9999 Deaths: 9999 Ratio: 9.99");
	TextDrawFont(HDM_BarAreainfo, 1);
	TextDrawLetterSize(HDM_BarAreainfo, 0.150000, 0.800000);
	TextDrawTextSize(HDM_BarAreainfo, 440.000000, 184.500000);
	TextDrawSetOutline(HDM_BarAreainfo, 0);
	TextDrawSetShadow(HDM_BarAreainfo, 0);
	TextDrawAlignment(HDM_BarAreainfo, 2);
	TextDrawColor(HDM_BarAreainfo, -2686721);
	TextDrawBackgroundColor(HDM_BarAreainfo, 255);
	TextDrawBoxColor(HDM_BarAreainfo, 180);
	TextDrawUseBox(HDM_BarAreainfo, 1);
	TextDrawSetProportional(HDM_BarAreainfo, 1);
	TextDrawSetSelectable(HDM_BarAreainfo, 0);

	HDM_BarTimeData = TextDrawCreate(480.000000, 3.000000, "00:00 00/00/0000");
	TextDrawFont(HDM_BarTimeData, 1);
	TextDrawLetterSize(HDM_BarTimeData, 0.150000, 0.800000);
	TextDrawTextSize(HDM_BarTimeData, 440.000000, 212.000000);
	TextDrawSetOutline(HDM_BarTimeData, 0);
	TextDrawSetShadow(HDM_BarTimeData, 0);
	TextDrawAlignment(HDM_BarTimeData, 2);
	TextDrawColor(HDM_BarTimeData, -2686721);
	TextDrawBackgroundColor(HDM_BarTimeData, 255);
	TextDrawBoxColor(HDM_BarTimeData, 255);
	TextDrawUseBox(HDM_BarTimeData, 0);
	TextDrawSetProportional(HDM_BarTimeData, 1);
	TextDrawSetSelectable(HDM_BarTimeData, 0);

	HDM_GMInfo = TextDrawCreate(320.000000, 18.000000, "HardcoreDM ver. 0.10b Beta");
	TextDrawFont(HDM_GMInfo, 1);
	TextDrawLetterSize(HDM_GMInfo, 0.150000, 0.800000);
	TextDrawTextSize(HDM_GMInfo, 400.000000, 320.000000);
	TextDrawSetOutline(HDM_GMInfo, 0);
	TextDrawSetShadow(HDM_GMInfo, 0);
	TextDrawAlignment(HDM_GMInfo, 2);
	TextDrawColor(HDM_GMInfo, -156);
	TextDrawBackgroundColor(HDM_GMInfo, 255);
	TextDrawBoxColor(HDM_GMInfo, 50);
	TextDrawUseBox(HDM_GMInfo, 0);
	TextDrawSetProportional(HDM_GMInfo, 1);
	TextDrawSetSelectable(HDM_GMInfo, 0);

	HDM_AnnTXT = TextDrawCreate(106.000000, 225.000000, "Announce:~n~Jakis tekst ogloszenie, krotkiego nie chce a tak to nuda i tak.");
	TextDrawFont(HDM_AnnTXT, 1);
	TextDrawLetterSize(HDM_AnnTXT, 0.150000, 0.800000);
	TextDrawTextSize(HDM_AnnTXT, 398.500000, 180.000000);
	TextDrawSetOutline(HDM_AnnTXT, 0);
	TextDrawSetShadow(HDM_AnnTXT, 0);
	TextDrawAlignment(HDM_AnnTXT, 2);
	TextDrawColor(HDM_AnnTXT, -1);
	TextDrawBackgroundColor(HDM_AnnTXT, 255);
	TextDrawBoxColor(HDM_AnnTXT, 180);
	TextDrawUseBox(HDM_AnnTXT, 0);
	TextDrawSetProportional(HDM_AnnTXT, 1);
	TextDrawSetSelectable(HDM_AnnTXT, 0);

	HDM_AnnAutor = TextDrawCreate(16.000000, 254.000000, "Jakis tekst ogloszenia");
	TextDrawFont(HDM_AnnAutor, 1);
	TextDrawLetterSize(HDM_AnnAutor, 0.150000, 0.800000);
	TextDrawTextSize(HDM_AnnAutor, 127.000000, 11.000000);
	TextDrawSetOutline(HDM_AnnAutor, 0);
	TextDrawSetShadow(HDM_AnnAutor, 0);
	TextDrawAlignment(HDM_AnnAutor, 1);
	TextDrawColor(HDM_AnnAutor, -1);
	TextDrawBackgroundColor(HDM_AnnAutor, 255);
	TextDrawBoxColor(HDM_AnnAutor, 180);
	TextDrawUseBox(HDM_AnnAutor, 0);
	TextDrawSetProportional(HDM_AnnAutor, 1);
	TextDrawSetSelectable(HDM_AnnAutor, 0);

	HDM_SniperDropInfo = TextDrawCreate(320.000000, 412.700012, "Sniper Drop ends in: 00:00");
	TextDrawFont(HDM_SniperDropInfo, 1);
	TextDrawLetterSize(HDM_SniperDropInfo, 0.150000, 0.800000);
	TextDrawTextSize(HDM_SniperDropInfo, 404.000000, 97.000000);
	TextDrawSetOutline(HDM_SniperDropInfo, 0);
	TextDrawSetShadow(HDM_SniperDropInfo, 0);
	TextDrawAlignment(HDM_SniperDropInfo, 2);
	TextDrawColor(HDM_SniperDropInfo, -1);
	TextDrawBackgroundColor(HDM_SniperDropInfo, 255);
	TextDrawBoxColor(HDM_SniperDropInfo, 180);
	TextDrawUseBox(HDM_SniperDropInfo, 1);
	TextDrawSetProportional(HDM_SniperDropInfo, 1);
	TextDrawSetSelectable(HDM_SniperDropInfo, 0);

	HDM_GangWarStartArenaBG = TextDrawCreate(-1.000000, 390.000000, "ld_card:cd9s");
	TextDrawFont(HDM_GangWarStartArenaBG, 4);
	TextDrawLetterSize(HDM_GangWarStartArenaBG, 0.600000, 2.000000);
	TextDrawTextSize(HDM_GangWarStartArenaBG, 641.500000, 107.000000);
	TextDrawSetOutline(HDM_GangWarStartArenaBG, 1);
	TextDrawSetShadow(HDM_GangWarStartArenaBG, 0);
	TextDrawAlignment(HDM_GangWarStartArenaBG, 1);
	TextDrawColor(HDM_GangWarStartArenaBG, 255);
	TextDrawBackgroundColor(HDM_GangWarStartArenaBG, 255);
	TextDrawBoxColor(HDM_GangWarStartArenaBG, 50);
	TextDrawUseBox(HDM_GangWarStartArenaBG, 1);
	TextDrawSetProportional(HDM_GangWarStartArenaBG, 1);
	TextDrawSetSelectable(HDM_GangWarStartArenaBG, 0);

	HDM_GangWarStartArenaBG2 = TextDrawCreate(-1.000000, -43.000000, "ld_card:cd9s");
	TextDrawFont(HDM_GangWarStartArenaBG2, 4);
	TextDrawLetterSize(HDM_GangWarStartArenaBG2, 0.600000, 2.000000);
	TextDrawTextSize(HDM_GangWarStartArenaBG2, 641.500000, 107.000000);
	TextDrawSetOutline(HDM_GangWarStartArenaBG2, 1);
	TextDrawSetShadow(HDM_GangWarStartArenaBG2, 0);
	TextDrawAlignment(HDM_GangWarStartArenaBG2, 1);
	TextDrawColor(HDM_GangWarStartArenaBG2, 255);
	TextDrawBackgroundColor(HDM_GangWarStartArenaBG2, 255);
	TextDrawBoxColor(HDM_GangWarStartArenaBG2, 50);
	TextDrawUseBox(HDM_GangWarStartArenaBG2, 1);
	TextDrawSetProportional(HDM_GangWarStartArenaBG2, 1);
	TextDrawSetSelectable(HDM_GangWarStartArenaBG2, 0);

	HDM_GangWarStartArenaInfo = TextDrawCreate(493.000000, 375.000000, "Starting Arena 69...");
	TextDrawFont(HDM_GangWarStartArenaInfo, 1);
	TextDrawLetterSize(HDM_GangWarStartArenaInfo, 0.300000, 1.500000);
	TextDrawTextSize(HDM_GangWarStartArenaInfo, 400.000000, 139.500000);
	TextDrawSetOutline(HDM_GangWarStartArenaInfo, 0);
	TextDrawSetShadow(HDM_GangWarStartArenaInfo, 1);
	TextDrawAlignment(HDM_GangWarStartArenaInfo, 2);
	TextDrawColor(HDM_GangWarStartArenaInfo, -1);
	TextDrawBackgroundColor(HDM_GangWarStartArenaInfo, 255);
	TextDrawBoxColor(HDM_GangWarStartArenaInfo, 255);
	TextDrawUseBox(HDM_GangWarStartArenaInfo, 1);
	TextDrawSetProportional(HDM_GangWarStartArenaInfo, 1);
	TextDrawSetSelectable(HDM_GangWarStartArenaInfo, 0);

	HDM_GangWarPointsRoundsBG = TextDrawCreate(554.000000, 102.000000, "_");
	TextDrawFont(HDM_GangWarPointsRoundsBG, 1);
	TextDrawLetterSize(HDM_GangWarPointsRoundsBG, 0.600000, 2.599998);
	TextDrawTextSize(HDM_GangWarPointsRoundsBG, 400.000000, 100.000000);
	TextDrawSetOutline(HDM_GangWarPointsRoundsBG, 1);
	TextDrawSetShadow(HDM_GangWarPointsRoundsBG, 0);
	TextDrawAlignment(HDM_GangWarPointsRoundsBG, 2);
	TextDrawColor(HDM_GangWarPointsRoundsBG, -1);
	TextDrawBackgroundColor(HDM_GangWarPointsRoundsBG, 255);
	TextDrawBoxColor(HDM_GangWarPointsRoundsBG, 180);
	TextDrawUseBox(HDM_GangWarPointsRoundsBG, 1);
	TextDrawSetProportional(HDM_GangWarPointsRoundsBG, 1);
	TextDrawSetSelectable(HDM_GangWarPointsRoundsBG, 0);

	HDM_GangWarPointsRounds = TextDrawCreate(554.000000, 106.000000, "HWK ~y~99:99 ~w~RMS~n~Round ~y~1/6");
	TextDrawFont(HDM_GangWarPointsRounds, 1);
	TextDrawLetterSize(HDM_GangWarPointsRounds, 0.200000, 0.800000);
	TextDrawTextSize(HDM_GangWarPointsRounds, 400.000000, 100.000000);
	TextDrawSetOutline(HDM_GangWarPointsRounds, 0);
	TextDrawSetShadow(HDM_GangWarPointsRounds, 1);
	TextDrawAlignment(HDM_GangWarPointsRounds, 2);
	TextDrawColor(HDM_GangWarPointsRounds, -1);
	TextDrawBackgroundColor(HDM_GangWarPointsRounds, 255);
	TextDrawBoxColor(HDM_GangWarPointsRounds, 180);
	TextDrawUseBox(HDM_GangWarPointsRounds, 0);
	TextDrawSetProportional(HDM_GangWarPointsRounds, 1);
	TextDrawSetSelectable(HDM_GangWarPointsRounds, 0);

	HDM_GangWarInfoBar = TextDrawCreate(321.000000, 429.000000, "_");
	TextDrawFont(HDM_GangWarInfoBar, 0);
	TextDrawLetterSize(HDM_GangWarInfoBar, 0.600000, 2.599998);
	TextDrawTextSize(HDM_GangWarInfoBar, 400.000000, 640.000000);
	TextDrawSetOutline(HDM_GangWarInfoBar, 1);
	TextDrawSetShadow(HDM_GangWarInfoBar, 0);
	TextDrawAlignment(HDM_GangWarInfoBar, 2);
	TextDrawColor(HDM_GangWarInfoBar, -1);
	TextDrawBackgroundColor(HDM_GangWarInfoBar, 255);
	TextDrawBoxColor(HDM_GangWarInfoBar, 180);
	TextDrawUseBox(HDM_GangWarInfoBar, 1);
	TextDrawSetProportional(HDM_GangWarInfoBar, 1);
	TextDrawSetSelectable(HDM_GangWarInfoBar, 0);

	HDM_GangWarInfoG1 = TextDrawCreate(145.000000, 430.000000, "HWK (4) 800");
	TextDrawFont(HDM_GangWarInfoG1, 1);
	TextDrawLetterSize(HDM_GangWarInfoG1, 0.299998, 1.499999);
	TextDrawTextSize(HDM_GangWarInfoG1, 400.000000, 145.500000);
	TextDrawSetOutline(HDM_GangWarInfoG1, 0);
	TextDrawSetShadow(HDM_GangWarInfoG1, 1);
	TextDrawAlignment(HDM_GangWarInfoG1, 2);
	TextDrawColor(HDM_GangWarInfoG1, -1962934017);
	TextDrawBackgroundColor(HDM_GangWarInfoG1, 255);
	TextDrawBoxColor(HDM_GangWarInfoG1, 180);
	TextDrawUseBox(HDM_GangWarInfoG1, 0);
	TextDrawSetProportional(HDM_GangWarInfoG1, 1);
	TextDrawSetSelectable(HDM_GangWarInfoG1, 0);

	HDM_GangWarInfoG2 = TextDrawCreate(505.000000, 430.000000, "HWK (4) 800");
	TextDrawFont(HDM_GangWarInfoG2, 1);
	TextDrawLetterSize(HDM_GangWarInfoG2, 0.299998, 1.499999);
	TextDrawTextSize(HDM_GangWarInfoG2, 400.000000, 145.500000);
	TextDrawSetOutline(HDM_GangWarInfoG2, 0);
	TextDrawSetShadow(HDM_GangWarInfoG2, 1);
	TextDrawAlignment(HDM_GangWarInfoG2, 2);
	TextDrawColor(HDM_GangWarInfoG2, 35839);
	TextDrawBackgroundColor(HDM_GangWarInfoG2, 255);
	TextDrawBoxColor(HDM_GangWarInfoG2, 180);
	TextDrawUseBox(HDM_GangWarInfoG2, 0);
	TextDrawSetProportional(HDM_GangWarInfoG2, 1);
	TextDrawSetSelectable(HDM_GangWarInfoG2, 0);

	HDM_GangWarArenaInfo = TextDrawCreate(321.000000, 430.000000, "~y~Lobby");
	TextDrawFont(HDM_GangWarArenaInfo, 1);
	TextDrawLetterSize(HDM_GangWarArenaInfo, 0.299998, 1.499999);
	TextDrawTextSize(HDM_GangWarArenaInfo, 400.000000, 145.500000);
	TextDrawSetOutline(HDM_GangWarArenaInfo, 0);
	TextDrawSetShadow(HDM_GangWarArenaInfo, 1);
	TextDrawAlignment(HDM_GangWarArenaInfo, 2);
	TextDrawColor(HDM_GangWarArenaInfo, -1);
	TextDrawBackgroundColor(HDM_GangWarArenaInfo, 255);
	TextDrawBoxColor(HDM_GangWarArenaInfo, 180);
	TextDrawUseBox(HDM_GangWarArenaInfo, 0);
	TextDrawSetProportional(HDM_GangWarArenaInfo, 1);
	TextDrawSetSelectable(HDM_GangWarArenaInfo, 0);

	HDM_GangWarInstructions = TextDrawCreate(319.000000, 330.000000, "LOADING DATA...");
	TextDrawFont(HDM_GangWarInstructions, 1);
	TextDrawLetterSize(HDM_GangWarInstructions, 0.150000, 0.699998);
	TextDrawTextSize(HDM_GangWarInstructions, 400.000000, 199.000000);
	TextDrawSetOutline(HDM_GangWarInstructions, 0);
	TextDrawSetShadow(HDM_GangWarInstructions, 1);
	TextDrawAlignment(HDM_GangWarInstructions, 2);
	TextDrawColor(HDM_GangWarInstructions, -1);
	TextDrawBackgroundColor(HDM_GangWarInstructions, 255);
	TextDrawBoxColor(HDM_GangWarInstructions, 180);
	TextDrawUseBox(HDM_GangWarInstructions, 1);
	TextDrawSetProportional(HDM_GangWarInstructions, 1);
	TextDrawSetSelectable(HDM_GangWarInstructions, 0);

	HDM_GWScoreBoardBG = TextDrawCreate(172.000000, 105.000000, "ld_card:cd9s");
	TextDrawFont(HDM_GWScoreBoardBG, 4);
	TextDrawLetterSize(HDM_GWScoreBoardBG, 0.600000, 2.000000);
	TextDrawTextSize(HDM_GWScoreBoardBG, 290.000000, 147.500000);
	TextDrawSetOutline(HDM_GWScoreBoardBG, 1);
	TextDrawSetShadow(HDM_GWScoreBoardBG, 0);
	TextDrawAlignment(HDM_GWScoreBoardBG, 2);
	TextDrawColor(HDM_GWScoreBoardBG, 180);
	TextDrawBackgroundColor(HDM_GWScoreBoardBG, 255);
	TextDrawBoxColor(HDM_GWScoreBoardBG, 50);
	TextDrawUseBox(HDM_GWScoreBoardBG, 1);
	TextDrawSetProportional(HDM_GWScoreBoardBG, 1);
	TextDrawSetSelectable(HDM_GWScoreBoardBG, 0);

	HDM_GWScoreBoardArena = TextDrawCreate(320.000000, 110.000000, "~y~Arena 69");
	TextDrawFont(HDM_GWScoreBoardArena, 1);
	TextDrawLetterSize(HDM_GWScoreBoardArena, 0.400000, 1.700000);
	TextDrawTextSize(HDM_GWScoreBoardArena, 400.000000, 132.000000);
	TextDrawSetOutline(HDM_GWScoreBoardArena, 0);
	TextDrawSetShadow(HDM_GWScoreBoardArena, 1);
	TextDrawAlignment(HDM_GWScoreBoardArena, 2);
	TextDrawColor(HDM_GWScoreBoardArena, -1);
	TextDrawBackgroundColor(HDM_GWScoreBoardArena, 255);
	TextDrawBoxColor(HDM_GWScoreBoardArena, -16777166);
	TextDrawUseBox(HDM_GWScoreBoardArena, 0);
	TextDrawSetProportional(HDM_GWScoreBoardArena, 1);
	TextDrawSetSelectable(HDM_GWScoreBoardArena, 0);

	HDM_GWScoreBoardG1 = TextDrawCreate(247.000000, 125.000000, "Gang 1");
	TextDrawFont(HDM_GWScoreBoardG1, 1);
	TextDrawLetterSize(HDM_GWScoreBoardG1, 0.400000, 1.700000);
	TextDrawTextSize(HDM_GWScoreBoardG1, 400.000000, 132.000000);
	TextDrawSetOutline(HDM_GWScoreBoardG1, 0);
	TextDrawSetShadow(HDM_GWScoreBoardG1, 1);
	TextDrawAlignment(HDM_GWScoreBoardG1, 2);
	TextDrawColor(HDM_GWScoreBoardG1, -16776961);
	TextDrawBackgroundColor(HDM_GWScoreBoardG1, 255);
	TextDrawBoxColor(HDM_GWScoreBoardG1, -16777166);
	TextDrawUseBox(HDM_GWScoreBoardG1, 0);
	TextDrawSetProportional(HDM_GWScoreBoardG1, 1);
	TextDrawSetSelectable(HDM_GWScoreBoardG1, 0);

	HDM_GWScoreBoardG2 = TextDrawCreate(387.000000, 125.000000, "Gang 2");
	TextDrawFont(HDM_GWScoreBoardG2, 1);
	TextDrawLetterSize(HDM_GWScoreBoardG2, 0.400000, 1.700000);
	TextDrawTextSize(HDM_GWScoreBoardG2, 400.000000, 132.000000);
	TextDrawSetOutline(HDM_GWScoreBoardG2, 0);
	TextDrawSetShadow(HDM_GWScoreBoardG2, 1);
	TextDrawAlignment(HDM_GWScoreBoardG2, 2);
	TextDrawColor(HDM_GWScoreBoardG2, 65535);
	TextDrawBackgroundColor(HDM_GWScoreBoardG2, 255);
	TextDrawBoxColor(HDM_GWScoreBoardG2, 35634);
	TextDrawUseBox(HDM_GWScoreBoardG2, 0);
	TextDrawSetProportional(HDM_GWScoreBoardG2, 1);
	TextDrawSetSelectable(HDM_GWScoreBoardG2, 0);

	HDM_GWScoreBoardG1Info = TextDrawCreate(247.000000, 145.000000, "Nickname           Kills       DMG~n~~n~~n~~n~~n~~n~");
	TextDrawFont(HDM_GWScoreBoardG1Info, 1);
	TextDrawLetterSize(HDM_GWScoreBoardG1Info, 0.200000, 1.000000);
	TextDrawTextSize(HDM_GWScoreBoardG1Info, 400.000000, 132.000000);
	TextDrawSetOutline(HDM_GWScoreBoardG1Info, 0);
	TextDrawSetShadow(HDM_GWScoreBoardG1Info, 1);
	TextDrawAlignment(HDM_GWScoreBoardG1Info, 2);
	TextDrawColor(HDM_GWScoreBoardG1Info, -16776961);
	TextDrawBackgroundColor(HDM_GWScoreBoardG1Info, 255);
	TextDrawBoxColor(HDM_GWScoreBoardG1Info, -16777166);
	TextDrawUseBox(HDM_GWScoreBoardG1Info, 1);
	TextDrawSetProportional(HDM_GWScoreBoardG1Info, 1);
	TextDrawSetSelectable(HDM_GWScoreBoardG1Info, 0);

	HDM_GWScoreBoardG2Info = TextDrawCreate(387.000000, 145.000000, "DMG       Kills           Nickname~n~~n~~n~~n~~n~~n~");
	TextDrawFont(HDM_GWScoreBoardG2Info, 1);
	TextDrawLetterSize(HDM_GWScoreBoardG2Info, 0.200000, 1.000000);
	TextDrawTextSize(HDM_GWScoreBoardG2Info, 400.000000, 132.000000);
	TextDrawSetOutline(HDM_GWScoreBoardG2Info, 0);
	TextDrawSetShadow(HDM_GWScoreBoardG2Info, 1);
	TextDrawAlignment(HDM_GWScoreBoardG2Info, 2);
	TextDrawColor(HDM_GWScoreBoardG2Info, 65535);
	TextDrawBackgroundColor(HDM_GWScoreBoardG2Info, 255);
	TextDrawBoxColor(HDM_GWScoreBoardG2Info, 65330);
	TextDrawUseBox(HDM_GWScoreBoardG2Info, 1);
	TextDrawSetProportional(HDM_GWScoreBoardG2Info, 1);
	TextDrawSetSelectable(HDM_GWScoreBoardG2Info, 0);

	HDM_GWScoreBoardEndInfo = TextDrawCreate(320.000000, 210.000000, "Gangname Wins this round!");
	TextDrawFont(HDM_GWScoreBoardEndInfo, 1);
	TextDrawLetterSize(HDM_GWScoreBoardEndInfo, 0.400000, 1.700000);
	TextDrawTextSize(HDM_GWScoreBoardEndInfo, 400.000000, 249.000000);
	TextDrawSetOutline(HDM_GWScoreBoardEndInfo, 0);
	TextDrawSetShadow(HDM_GWScoreBoardEndInfo, 1);
	TextDrawAlignment(HDM_GWScoreBoardEndInfo, 2);
	TextDrawColor(HDM_GWScoreBoardEndInfo, -16776961);
	TextDrawBackgroundColor(HDM_GWScoreBoardEndInfo, 255);
	TextDrawBoxColor(HDM_GWScoreBoardEndInfo, -16777166);
	TextDrawUseBox(HDM_GWScoreBoardEndInfo, 0);
	TextDrawSetProportional(HDM_GWScoreBoardEndInfo, 1);
	TextDrawSetSelectable(HDM_GWScoreBoardEndInfo, 0);

	HDM_FinalBoardBG = TextDrawCreate(173.000000, 105.000000, "ld_card:cd9s");
	TextDrawFont(HDM_FinalBoardBG, 4);
	TextDrawLetterSize(HDM_FinalBoardBG, 0.600000, 2.000000);
	TextDrawTextSize(HDM_FinalBoardBG, 290.000000, 197.000000);
	TextDrawSetOutline(HDM_FinalBoardBG, 1);
	TextDrawSetShadow(HDM_FinalBoardBG, 0);
	TextDrawAlignment(HDM_FinalBoardBG, 2);
	TextDrawColor(HDM_FinalBoardBG, 180);
	TextDrawBackgroundColor(HDM_FinalBoardBG, 255);
	TextDrawBoxColor(HDM_FinalBoardBG, 50);
	TextDrawUseBox(HDM_FinalBoardBG, 1);
	TextDrawSetProportional(HDM_FinalBoardBG, 1);
	TextDrawSetSelectable(HDM_FinalBoardBG, 0);

	HDM_FinalBoardTitle = TextDrawCreate(320.000000, 104.000000, "~y~Final Result");
	TextDrawFont(HDM_FinalBoardTitle, 1);
	TextDrawLetterSize(HDM_FinalBoardTitle, 0.400000, 1.700000);
	TextDrawTextSize(HDM_FinalBoardTitle, 400.000000, 132.000000);
	TextDrawSetOutline(HDM_FinalBoardTitle, 0);
	TextDrawSetShadow(HDM_FinalBoardTitle, 1);
	TextDrawAlignment(HDM_FinalBoardTitle, 2);
	TextDrawColor(HDM_FinalBoardTitle, -1);
	TextDrawBackgroundColor(HDM_FinalBoardTitle, 255);
	TextDrawBoxColor(HDM_FinalBoardTitle, -16777166);
	TextDrawUseBox(HDM_FinalBoardTitle, 0);
	TextDrawSetProportional(HDM_FinalBoardTitle, 1);
	TextDrawSetSelectable(HDM_FinalBoardTitle, 0);

	HDM_FinalBoardGang1 = TextDrawCreate(225.000000, 125.000000, "Gang 1");
	TextDrawFont(HDM_FinalBoardGang1, 1);
	TextDrawLetterSize(HDM_FinalBoardGang1, 0.300000, 1.250000);
	TextDrawTextSize(HDM_FinalBoardGang1, 400.000000, 132.000000);
	TextDrawSetOutline(HDM_FinalBoardGang1, 0);
	TextDrawSetShadow(HDM_FinalBoardGang1, 1);
	TextDrawAlignment(HDM_FinalBoardGang1, 2);
	TextDrawColor(HDM_FinalBoardGang1, -16776961);
	TextDrawBackgroundColor(HDM_FinalBoardGang1, 255);
	TextDrawBoxColor(HDM_FinalBoardGang1, -16777166);
	TextDrawUseBox(HDM_FinalBoardGang1, 0);
	TextDrawSetProportional(HDM_FinalBoardGang1, 1);
	TextDrawSetSelectable(HDM_FinalBoardGang1, 0);

	HDM_FinalBoardGang2 = TextDrawCreate(411.000000, 125.000000, "Gang 2");
	TextDrawFont(HDM_FinalBoardGang2, 1);
	TextDrawLetterSize(HDM_FinalBoardGang2, 0.300000, 1.250000);
	TextDrawTextSize(HDM_FinalBoardGang2, 400.000000, 132.000000);
	TextDrawSetOutline(HDM_FinalBoardGang2, 0);
	TextDrawSetShadow(HDM_FinalBoardGang2, 1);
	TextDrawAlignment(HDM_FinalBoardGang2, 2);
	TextDrawColor(HDM_FinalBoardGang2, 65535);
	TextDrawBackgroundColor(HDM_FinalBoardGang2, 255);
	TextDrawBoxColor(HDM_FinalBoardGang2, 35634);
	TextDrawUseBox(HDM_FinalBoardGang2, 0);
	TextDrawSetProportional(HDM_FinalBoardGang2, 1);
	TextDrawSetSelectable(HDM_FinalBoardGang2, 0);

	HDM_FinalBoardG1Info = TextDrawCreate(225.000000, 140.000000, "Win~n~Win~n~Win~n~Win~n~Win~n~Win~n~");
	TextDrawFont(HDM_FinalBoardG1Info, 1);
	TextDrawLetterSize(HDM_FinalBoardG1Info, 0.200000, 1.000000);
	TextDrawTextSize(HDM_FinalBoardG1Info, 400.000000, 80.000000);
	TextDrawSetOutline(HDM_FinalBoardG1Info, 0);
	TextDrawSetShadow(HDM_FinalBoardG1Info, 1);
	TextDrawAlignment(HDM_FinalBoardG1Info, 2);
	TextDrawColor(HDM_FinalBoardG1Info, -16776961);
	TextDrawBackgroundColor(HDM_FinalBoardG1Info, 255);
	TextDrawBoxColor(HDM_FinalBoardG1Info, -16777166);
	TextDrawUseBox(HDM_FinalBoardG1Info, 1);
	TextDrawSetProportional(HDM_FinalBoardG1Info, 1);
	TextDrawSetSelectable(HDM_FinalBoardG1Info, 0);

	HDM_FinalBoardG2Info = TextDrawCreate(411.000000, 140.000000, "Lose~n~Lose~n~Lose~n~Lose~n~Lose~n~Lose~n~");
	TextDrawFont(HDM_FinalBoardG2Info, 1);
	TextDrawLetterSize(HDM_FinalBoardG2Info, 0.200000, 1.000000);
	TextDrawTextSize(HDM_FinalBoardG2Info, 400.000000, 80.000000);
	TextDrawSetOutline(HDM_FinalBoardG2Info, 0);
	TextDrawSetShadow(HDM_FinalBoardG2Info, 1);
	TextDrawAlignment(HDM_FinalBoardG2Info, 2);
	TextDrawColor(HDM_FinalBoardG2Info, 65535);
	TextDrawBackgroundColor(HDM_FinalBoardG2Info, 255);
	TextDrawBoxColor(HDM_FinalBoardG2Info, 65330);
	TextDrawUseBox(HDM_FinalBoardG2Info, 1);
	TextDrawSetProportional(HDM_FinalBoardG2Info, 1);
	TextDrawSetSelectable(HDM_FinalBoardG2Info, 0);

	HDM_FinalBoardArenasList = TextDrawCreate(320.000000, 140.000000, "Arena 69~n~Arena 69~n~Arena 69~n~Arena 69~n~Arena 69~n~Arena 69~n~");
	TextDrawFont(HDM_FinalBoardArenasList, 1);
	TextDrawLetterSize(HDM_FinalBoardArenasList, 0.200000, 1.000000);
	TextDrawTextSize(HDM_FinalBoardArenasList, 400.000000, 80.000000);
	TextDrawSetOutline(HDM_FinalBoardArenasList, 0);
	TextDrawSetShadow(HDM_FinalBoardArenasList, 1);
	TextDrawAlignment(HDM_FinalBoardArenasList, 2);
	TextDrawColor(HDM_FinalBoardArenasList, 9109759);
	TextDrawBackgroundColor(HDM_FinalBoardArenasList, 255);
	TextDrawBoxColor(HDM_FinalBoardArenasList, 9109554);
	TextDrawUseBox(HDM_FinalBoardArenasList, 1);
	TextDrawSetProportional(HDM_FinalBoardArenasList, 1);
	TextDrawSetSelectable(HDM_FinalBoardArenasList, 0);

	HDM_FinalBoardArenas = TextDrawCreate(320.000000, 125.000000, "~y~Arenas");
	TextDrawFont(HDM_FinalBoardArenas, 1);
	TextDrawLetterSize(HDM_FinalBoardArenas, 0.300000, 1.250000);
	TextDrawTextSize(HDM_FinalBoardArenas, 400.000000, 132.000000);
	TextDrawSetOutline(HDM_FinalBoardArenas, 0);
	TextDrawSetShadow(HDM_FinalBoardArenas, 1);
	TextDrawAlignment(HDM_FinalBoardArenas, 2);
	TextDrawColor(HDM_FinalBoardArenas, 9109759);
	TextDrawBackgroundColor(HDM_FinalBoardArenas, 255);
	TextDrawBoxColor(HDM_FinalBoardArenas, -16777166);
	TextDrawUseBox(HDM_FinalBoardArenas, 0);
	TextDrawSetProportional(HDM_FinalBoardArenas, 1);
	TextDrawSetSelectable(HDM_FinalBoardArenas, 0);

	HDM_FinalBoardG1Pinfo = TextDrawCreate(247.000000, 223.000000, "Nickname     Kills     Deaths     DMG");
	TextDrawFont(HDM_FinalBoardG1Pinfo, 1);
	TextDrawLetterSize(HDM_FinalBoardG1Pinfo, 0.200000, 1.000000);
	TextDrawTextSize(HDM_FinalBoardG1Pinfo, 400.000000, 137.500000);
	TextDrawSetOutline(HDM_FinalBoardG1Pinfo, 0);
	TextDrawSetShadow(HDM_FinalBoardG1Pinfo, 1);
	TextDrawAlignment(HDM_FinalBoardG1Pinfo, 2);
	TextDrawColor(HDM_FinalBoardG1Pinfo, -16776961);
	TextDrawBackgroundColor(HDM_FinalBoardG1Pinfo, 255);
	TextDrawBoxColor(HDM_FinalBoardG1Pinfo, -16777166);
	TextDrawUseBox(HDM_FinalBoardG1Pinfo, 1);
	TextDrawSetProportional(HDM_FinalBoardG1Pinfo, 1);
	TextDrawSetSelectable(HDM_FinalBoardG1Pinfo, 0);

	HDM_FinalBoardG2Pinfo = TextDrawCreate(388.000000, 223.000000, "Nickname     Kills     Deaths     DMG");
	TextDrawFont(HDM_FinalBoardG2Pinfo, 1);
	TextDrawLetterSize(HDM_FinalBoardG2Pinfo, 0.200000, 1.000000);
	TextDrawTextSize(HDM_FinalBoardG2Pinfo, 400.000000, 137.500000);
	TextDrawSetOutline(HDM_FinalBoardG2Pinfo, 0);
	TextDrawSetShadow(HDM_FinalBoardG2Pinfo, 1);
	TextDrawAlignment(HDM_FinalBoardG2Pinfo, 2);
	TextDrawColor(HDM_FinalBoardG2Pinfo, 65535);
	TextDrawBackgroundColor(HDM_FinalBoardG2Pinfo, 255);
	TextDrawBoxColor(HDM_FinalBoardG2Pinfo, 65330);
	TextDrawUseBox(HDM_FinalBoardG2Pinfo, 1);
	TextDrawSetProportional(HDM_FinalBoardG2Pinfo, 1);
	TextDrawSetSelectable(HDM_FinalBoardG2Pinfo, 0);

	HDM_FinalBoardTimeDate = TextDrawCreate(320.000000, 291.000000, "Time: 22:37  Date: 02/07/2022");
	TextDrawFont(HDM_FinalBoardTimeDate, 1);
	TextDrawLetterSize(HDM_FinalBoardTimeDate, 0.200000, 1.000000);
	TextDrawTextSize(HDM_FinalBoardTimeDate, 400.000000, 137.500000);
	TextDrawSetOutline(HDM_FinalBoardTimeDate, 0);
	TextDrawSetShadow(HDM_FinalBoardTimeDate, 1);
	TextDrawAlignment(HDM_FinalBoardTimeDate, 2);
	TextDrawColor(HDM_FinalBoardTimeDate, -1);
	TextDrawBackgroundColor(HDM_FinalBoardTimeDate, 255);
	TextDrawBoxColor(HDM_FinalBoardTimeDate, 9109554);
	TextDrawUseBox(HDM_FinalBoardTimeDate, 1);
	TextDrawSetProportional(HDM_FinalBoardTimeDate, 1);
	TextDrawSetSelectable(HDM_FinalBoardTimeDate, 0);

	HDM_FinalBoardG1Points = TextDrawCreate(225.000000, 198.000000, "6");
	TextDrawFont(HDM_FinalBoardG1Points, 1);
	TextDrawLetterSize(HDM_FinalBoardG1Points, 0.300000, 1.250000);
	TextDrawTextSize(HDM_FinalBoardG1Points, 400.000000, 132.000000);
	TextDrawSetOutline(HDM_FinalBoardG1Points, 0);
	TextDrawSetShadow(HDM_FinalBoardG1Points, 1);
	TextDrawAlignment(HDM_FinalBoardG1Points, 2);
	TextDrawColor(HDM_FinalBoardG1Points, -16776961);
	TextDrawBackgroundColor(HDM_FinalBoardG1Points, 255);
	TextDrawBoxColor(HDM_FinalBoardG1Points, -16777166);
	TextDrawUseBox(HDM_FinalBoardG1Points, 0);
	TextDrawSetProportional(HDM_FinalBoardG1Points, 1);
	TextDrawSetSelectable(HDM_FinalBoardG1Points, 0);

	HDM_FinalBoardG2Points = TextDrawCreate(411.000000, 198.000000, "0");
	TextDrawFont(HDM_FinalBoardG2Points, 1);
	TextDrawLetterSize(HDM_FinalBoardG2Points, 0.300000, 1.250000);
	TextDrawTextSize(HDM_FinalBoardG2Points, 400.000000, 132.000000);
	TextDrawSetOutline(HDM_FinalBoardG2Points, 0);
	TextDrawSetShadow(HDM_FinalBoardG2Points, 1);
	TextDrawAlignment(HDM_FinalBoardG2Points, 2);
	TextDrawColor(HDM_FinalBoardG2Points, 65535);
	TextDrawBackgroundColor(HDM_FinalBoardG2Points, 255);
	TextDrawBoxColor(HDM_FinalBoardG2Points, 35634);
	TextDrawUseBox(HDM_FinalBoardG2Points, 0);
	TextDrawSetProportional(HDM_FinalBoardG2Points, 1);
	TextDrawSetSelectable(HDM_FinalBoardG2Points, 0);

	HDM_FinalBoardResult = TextDrawCreate(320.000000, 206.000000, "Gangname wins this Gangwar");
	TextDrawFont(HDM_FinalBoardResult, 1);
	TextDrawLetterSize(HDM_FinalBoardResult, 0.300000, 1.250000);
	TextDrawTextSize(HDM_FinalBoardResult, 400.000000, 190.000000);
	TextDrawSetOutline(HDM_FinalBoardResult, 0);
	TextDrawSetShadow(HDM_FinalBoardResult, 1);
	TextDrawAlignment(HDM_FinalBoardResult, 2);
	TextDrawColor(HDM_FinalBoardResult, 9109759);
	TextDrawBackgroundColor(HDM_FinalBoardResult, 255);
	TextDrawBoxColor(HDM_FinalBoardResult, -16777166);
	TextDrawUseBox(HDM_FinalBoardResult, 0);
	TextDrawSetProportional(HDM_FinalBoardResult, 1);
	TextDrawSetSelectable(HDM_FinalBoardResult, 0);
}
