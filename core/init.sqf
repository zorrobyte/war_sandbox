//Init Admin Actions
[player] call compile preprocessFileLineNumbers "core\modules\adminActions\main.sqf";
//Init zTownMgr
[]execVM "core\modules\z_townmgr\main.sqf";
//Init fpsManager
//[1000]execFSM "core\modules\z_cache\fpsManager.fsm";
//Init DMZ Cleanup
[] execVM "core\modules\dmz_cleanup\DMZ_delete.sqf";