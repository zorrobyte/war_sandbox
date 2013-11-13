//Init Admin Actions
[player] call compile preprocessFileLineNumbers "core\modules\adminActions\main.sqf";
//Exec zTownMgr
[]execVM "core\modules\z_townmgr\main.sqf";