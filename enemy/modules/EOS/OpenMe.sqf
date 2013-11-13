EOS_Patrol = compile preprocessfilelinenumbers "enemy\modules\EOS\Functions\shk_patrol.sqf";EOS_Spawn = compile preprocessfilelinenumbers "enemy\modules\EOS\EOS\EOS_Launch.sqf";EOS_LightVeh = compile preprocessfilelinenumbers "enemy\modules\EOS\SpawnUnits\Spawn_Vehicle.sqf";EOS_spawnPatrol = compile preprocessfilelinenumbers "enemy\modules\EOS\SpawnUnits\Spawn_Infantry.sqf";EOS_spawnStatic = compile preprocessfilelinenumbers "enemy\modules\EOS\SpawnUnits\Spawn_Static.sqf";callHouseScript = compile preprocessFileLineNumbers "enemy\modules\EOS\Functions\SHK_buildingpos.sqf";EOS_FILLCARGO = compile preprocessFileLineNumbers "enemy\modules\EOS\Functions\EOS_Fill_Cargo.sqf";Bastion_Spawn=compile preprocessfilelinenumbers "enemy\modules\EOS\Bastion\b_launch.sqf";EOS_Armour = compile preprocessfilelinenumbers "enemy\modules\EOS\SpawnUnits\Spawn_Armour.sqf";EOS_unit= compile preprocessfilelinenumbers "enemy\modules\EOS\EOS_UnitPools.sqf";EOS_debug= compile preprocessfilelinenumbers "enemy\modules\EOS\Functions\EOS_debugMarker.sqf";EOS_Deactivate= compile preprocessfilelinenumbers "enemy\modules\EOS\Functions\EOS_deactivate.sqf";onplayerConnected {[] execVM "enemy\modules\EOS\Functions\EOS_Markers.sqf";};
IF (isnil "server")then{hint "YOU MUST PLACE A GAME LOGIC NAMED SERVER!";};
// EOS 1.9 by BangaBob 
//
// GROUP SIZES
// 0 = 0
// 1 = 2,4
// 2 = 4,8
// 3 = 8,12
// 4 = 12,16
// 5 = 16,20
//
// EXAMPLE CALL - EOS
// null = [["m1"],[1,2],[2,1],[1,4],[2,0],[0,1,1],[0,0,300]] call EOS_Spawn;
// null=[["M1","M2","M3"],[HOUSE GROUPS,SIZE OF GROUPS],[PATROL GROUPS,SIZE OF GROUPS],[LIGHT VEHICLES,SIZE OF CARGO],[ARMOURED VEHICLES,SIZE OF GROUPS],[STATIC VEHICLES,HELICOPTERS,SIZE OF HELICOPTER CARGO],[SIDE,MARKERTYPE,DISTANCE]] call EOS_Spawn;
//
// EXAMPLE CALL - BASTION
// null=[["m1"],[1,1],[1,1],[1,1],[1,1],[2,0,25]] call Bastion_Spawn;
// null=[["M1","M2","M3"],[PATROL GROUPS,SIZE OF GROUPS],[LIGHT VEHICLES,SIZE OF CARGO],[ARMOURED VEHICLES,SIZE OF GROUPS],[HELICOPTERS,SIZE OF HELICOPTER CARGO],[SIDE,MARKERTYPE,DISTANCE]] call Bastion_Spawn;
////////////////////////////////////////////////////////////////////////////////////////////

//[HOUSE GROUPS,SIZE OF GROUPS],[PATROL GROUPS,SIZE OF GROUPS],[LIGHT VEHICLES,SIZE OF CARGO],[ARMOURED VEHICLES,SIZE OF GROUPS],[STATIC VEHICLES,HELICOPTERS,SIZE OF HELICOPTER CARGO],[SIDE,MARKERTYPE,DISTANCE]]
waitUntil {ztowninit==1};
{[[_x],[0,0],[2,2],[0,0],[0,0],[0,0,0],[0,0,250,EAST]] call EOS_Spawn} forEach ztowns;
{[[_x],[0,0],[2,2],[1,1],[0,0],[0,0,0],[0,0,250,EAST]] call EOS_Spawn} forEach ztownm;
{[[_x],[0,0],[3,3],[3,3],[2,2],[0,0,0],[0,0,250,EAST]] call EOS_Spawn} forEach ztownl;
