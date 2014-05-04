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


