private ["_a","_b"];

GL4_Path = "GL4_System\";

[] spawn
{
	waitUntil { !(isNil "GL4_Core") };
	call compile preProcessFile "GL4_Settings\GL4_Core.sqf";

	waitUntil { !(isNil "GL4_Global") };
	call compile preProcessFile "GL4_Settings\GL4_Global.sqf";

	waitUntil { !(isNil "GL4_Local") };
	call compile preProcessFile "GL4_Settings\GL4_Local.sqf";
};

if (isServer) then
{
	_a = allUnits;

	{if ( { (isPlayer _x) } count (units _x) > 0) exitWith {_b = (vehicle _x) } } forEach _a;

	[_b] execVM (GL4_Path+"GL4_System.sqf");
}
else
{
	waitUntil { (player == player) };

	if (player == player) then
	{
		_a = allUnits;

		{if ( { (isPlayer _x) } count (units _x) > 0) exitWith {_b = (vehicle _x) } } forEach _a;

		[_b] execVM (GL4_Path+"GL4_System.sqf");
	};
};
