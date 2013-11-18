// ////////////////////////////////////////////////////////////////////////////
// GL4 v.1.0
// ////////////////////////////////////////////////////////////////////////////
// Artillery FX Functions
// By =\SNKMAN/=
// ////////////////////////////////////////////////////////////////////////////

GL4_Artillery_FX_F = [

	// ////////////////////////////////////////////////////////////////////////////
	// Artillery FX Function #0
	// ////////////////////////////////////////////////////////////////////////////
	// Artillery FX
	// Script by =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{private ["_a","_b"];

	_a = _this select 0;

	if (GL4_Local select 23) then
	{
		[_a] call (GL4_Artillery_FX_F select 1);
	};

	if (GL4_Local select 80) then
	{
		[_a] spawn (GL4_Artillery_FX_F select 2);
	};

	},

	// ////////////////////////////////////////////////////////////////////////////
	// Artillery FX Function #1
	// ////////////////////////////////////////////////////////////////////////////
	// Artillery FX
	// Script by =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{private ["_a","_b"];

	_a = _this select 0;

	if (floor (random 100) < (GL4_Local select 27) ) then
	{
		_b = (GL4_Resource select 19) call GL4_Random_Select_F;

		_a say _b;
	};

	},

	// ////////////////////////////////////////////////////////////////////////////
	// Artillery FX Function #2
	// ////////////////////////////////////////////////////////////////////////////
	// Artillery FX
	// Script by =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{private ["_a","_b","_c","_d"];

	_a = _this select 0;

	_b = getNumber (configFile >> "CfgAmmo" >> (typeOf _a) >> "hit");

	_c = getPos _a;

	while { !(isNull _a) } do
	{
		_c = getPos _a;

		sleep 0.01;
	};

	_d = (GL4_Artillery_FX select 0);

	_d setPos [ (_c select 0), (_c select 1), 0]; 

	if (GL4_Local select 36) then
	{
		[_b, _d] call (GL4_Shell_FX_F select 2);
	};

	if (GL4_Local select 81) then
	{
		[_d] spawn (GL4_Artillery_FX_F select 3);
	};

	},

	// ////////////////////////////////////////////////////////////////////////////
	// Artillery FX Function #3
	// ////////////////////////////////////////////////////////////////////////////
	// Artillery FX
	// Script by =\SNKMAN/=
	// ////////////////////////////////////////////////////////////////////////////
	{private ["_a","_b","_c","_d"];

	_a = _this select 0;

	_b = (_a distance player);

	if (_b < 100) then
	{
		_c = getDir player;

		_d = 15 * 15 / _b;

		while { ( (_d > 0) && (alive player) ) } do
		{
			player setDir _c + (random 10 - random 10);

			_d = _d - 1;

			sleep 0.01 + (random 0.03);
		};

		player setDir _c;
	};

	}
];