EOS_Spawn = compile preprocessfilelinenumbers "enemy\modules\EOS\core\eos_launch.sqf";Bastion_Spawn=compile preprocessfilelinenumbers "enemy\modules\EOS\core\b_launch.sqf";null=[] execVM "enemy\modules\EOS\core\spawn_fnc.sqf";onplayerConnected {[] execVM "enemy\modules\EOS\Functions\EOS_Markers.sqf";};
/* EOS 1.98 by BangaBob 
GROUP SIZES
 0 = 1
 1 = 2,4
 2 = 4,8
 3 = 8,12
 4 = 12,16
 5 = 16,20

EXAMPLE CALL - EOS
 null = [["MARKERNAME","MARKERNAME2"],[2,1,70],[0,1],[1,2,30],[2,60],[2],[1,0,10],[1,0,250,WEST]] call EOS_Spawn;
 null=[["M1","M2","M3"],[HOUSE GROUPS,SIZE OF GROUPS,PROBABILITY],[PATROL GROUPS,SIZE OF GROUPS,PROBABILITY],[LIGHT VEHICLES,SIZE OF CARGO,PROBABILITY],[ARMOURED VEHICLES,PROBABILITY], [STATIC VEHICLES,PROBABILITY],[HELICOPTERS,SIZE OF HELICOPTER CARGO,PROBABILITY],[FACTION,MARKERTYPE,DISTANCE,SIDE,HEIGHTLIMIT,DEBUG]] call EOS_Spawn;

EXAMPLE CALL - BASTION
 null = [["BAS_zone_1"],[3,1],[2,1],[2],[0,0],[0,0,EAST,false,false],[10,2,120,TRUE,TRUE]] call Bastion_Spawn;
 null=[["M1","M2","M3"],[PATROL GROUPS,SIZE OF GROUPS],[LIGHT VEHICLES,SIZE OF CARGO],[ARMOURED VEHICLES],[HELICOPTERS,SIZE OF HELICOPTER CARGO],[FACTION,MARKERTYPE,SIDE,HEIGHTLIMIT,DEBUG],[INITIAL PAUSE, NUMBER OF WAVES, DELAY BETWEEN WAVES, INTEGRATE EOS, SHOW HINTS]] call Bastion_Spawn;
*/
VictoryColor="colorGreen";	// Colour of marker after completion
hostileColor="colorRed";	// Default colour when enemies active
bastionColor="colorOrange";	// Colour for bastion marker
EOS_DAMAGE_MULTIPLIER=1;	// 1 is default
EOS_KILLCOUNTER=true;		// Counts killed units

//null = [["BAS_zone_1"],[0,1],[0,2],[0],[1,2],[0,0,EAST,TRUE],[0,2,120,TRUE,FALSE]] call Bastion_Spawn;
/*
waitUntil {!isNil "ztowninit"};
{[[_x],[1,1,50],[1,2,50],[1,1,50],[1,50],[2,100],[0,0],[0,0,1000,EAST,TRUE,TRUE]] call EOS_Spawn} count ztowns;
{[[_x],[1,1,50],[1,2,50],[1,1,50],[1,50],[2,100],[0,0],[0,0,1000,EAST,TRUE,TRUE]] call EOS_Spawn} count ztownm;
{[[_x],[1,1,50],[1,2,50],[1,1,50],[1,50],[2,100],[0,0],[0,0,1000,EAST,TRUE,TRUE]] call EOS_Spawn} count ztownl;*/