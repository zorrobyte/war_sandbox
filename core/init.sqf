//Init Admin Actions
[player] call compile preprocessFileLineNumbers "core\modules\adminActions\main.sqf";
//Exec zTownMgr
[]execVM "core\modules\z_townmgr\main.sqf";
//[1000]execFSM "core\modules\z_cache\fpsManager.fsm";
[] execVM "core\modules\dmz_cleanup\DMZ_delete.sqf";