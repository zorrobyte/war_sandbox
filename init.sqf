//debug
Z_Debug = true;
//Disables saving for mission dev work
enableSaving [false,false];
//Init Admin Actions
[player] call compile preprocessFileLineNumbers "core\modules\adminActions\main.sqf";
//nul = [true,"ran",(10+random 40),10,west,1,random 0.8] execVM "scripts\ws_assassins.sqf";
//Exec zTownMgr
[]execVM "core\modules\z_townmgr\main.sqf";
//Exec EOS
[]execVM "enemy\modules\EOS\OpenMe.sqf";
