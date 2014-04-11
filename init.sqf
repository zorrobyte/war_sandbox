#ifndef execNow
#define execNow call compile preprocessfilelinenumbers
#endif

execNow "core\init.sqf";
execNow "ambience\init.sqf";
execNow "support\init.sqf";
execNow "enemy\init.sqf";

execNow "init-custom.sqf";

diag_log format["WS Initialisation Completed", time];

//debug
Z_Debug = true;
//nul = [true,"ran",(10+random 40),10,west,1,random 0.8] execVM "scripts\ws_assassins.sqf";


