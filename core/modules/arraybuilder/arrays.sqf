// Zonekiller's Array Builder

// Script by Zonekiller  -- http://zonekiller.ath.cx --    -- zonekiller@live.com.au --

//Factions to add

_fractionW = ["BIS_US","USMC"];
_fractionE = ["BIS_TK","RU"];
_fractionG = ["BIS_TK_GUE","GUE"];
_fractionC = ["BIS_TK_CIV"];

// Men to add

_allowedmenclass = ["Man"];

// Men not to add

_forbidedmenclass = ["FR_Base","USMC_LHD_Crew_Base"];

// Vehicles to add
_allowedvehicleclass = ["Helicopter","LandVehicle","Ship"];

// Vehicles not to add

_forbidedvehicleclass = ["CruiseMissile1","WarfareBMGNest_M240_base","WarfareBMGNest_PK_Base","StaticSEARCHLight","ParachuteBase"];

// List of the Arrays it will make
//-----------------------------------

westvehicles = [];
eastvehicles = [];
guervehicles = [];
civvehicles = [];

SoldierW = [];
SoldierE = [];
SoldierG = [];
SoldierC = [];

westammo = [];
eastammo = [];
guerammo = [];
civammo = [];

//--------------------------------

_FactionsArray = _fractionW + _fractionE + _fractionG + _fractionC;
extra_addons = [];
_AddonArray = [];

// Gets the list of all Addons and Objects that belong to them;

_CfgPatches = configFile >> "CfgPatches";

		for "_i" from 1 to ((count _CfgPatches) - 1) do 
		{
		_Patch = _CfgPatches select _i;

			if ((isClass _Patch) && ((((getarray(_Patch select 0))select 0) isKindOf "AIR") or (((getarray(_Patch select 0))select 0) isKindOf "SHIP") or (((getarray

(_Patch select 0))select 0) isKindOf "LandVehicle") or (((getarray(_Patch select 0))select 0) isKindOf "MAN"))) then
			{
				if ((count getarray((_Patch) select 0)) > 0) then {_AddonArray = _AddonArray + [[(configName _Patch),getarray((_Patch) select 0)]]};
			};

		};


// Gets all Objects in the game 
	
_CfgVehicles = configFile >> "CfgVehicles";

for "_i" from 1 to ((count _CfgVehicles) - 1) do 
{
	_Vehicle = _CfgVehicles select _i;

	if ((isClass _Vehicle) && ((getnumber(_Vehicle >> "scope")) == 2) && !((configName _Vehicle) isKindOf "Building") && !((configName _Vehicle) isKindOf "Thing")) then 
	{

	_go = 0;

		{if ((configName _Vehicle) isKindOf _x) exitwith {_go = 1;

		{if ((configName _Vehicle) isKindOf _x) exitwith {_go = 0}} foreach _forbidedmenclass;		
		
		// Makes 4 Arrays of men from the factions

			if (_go == 1) then		
			{
				if (getText(_Vehicle >> "faction") in _fractionW) then {SoldierW = SoldierW + [configName _Vehicle]};
				if (getText(_Vehicle >> "faction") in _fractionE) then {SoldierE = SoldierE + [configName _Vehicle]};
				if (getText(_Vehicle >> "faction") in _fractionG) then {SoldierG = SoldierG + [configName _Vehicle]};
				if (getText(_Vehicle >> "faction") in _fractionC) then {SoldierC = SoldierC + [configName _Vehicle]};
					
				_ammo = [[(getarray(_Vehicle >> "weapons")) - ["NVGoggles","itemGPS","Throw","Put","ItemMap","ItemCompass","ItemWatch","ItemRadio"],(getarray

(_Vehicle >> "magazines"))]];

				if (getText(_Vehicle >> "faction") in _fractionw) then {westammo = westammo + _ammo};
				if (getText(_Vehicle >> "faction") in _fractionE) then {eastammo = eastammo + _ammo};
				if (getText(_Vehicle >> "faction") in _fractionG) then {guerammo = guerammo + _ammo};
				if (getText(_Vehicle >> "faction") in _fractionC) then {civammo = civammo + _ammo};

				// Adds a list of Men Addons which be needed

				if (getText(_Vehicle >> "faction") in _FactionsArray) then 
				{
					{if (((configName _Vehicle) in (_x select 1)) && !((_x select 0) in extra_addons)) then {extra_addons = extra_addons + [(_x select 0)]}} 

foreach _AddonArray;
				};


			};

		_go = 0;			

		}} foreach _allowedmenclass;


			
		{if ((configName _Vehicle) isKindOf _x) then {_go = 1;
	
		{if ((configName _Vehicle) isKindOf _x) exitwith {_go = 0}} foreach _forbidedvehicleclass;

		// Makes 4 Arrays of Vehicles from the factions

			if (_go == 1) then		
			{
				if (getText(_Vehicle >> "faction") in _fractionW) then {westvehicles = westvehicles + [configName _Vehicle]};
				if (getText(_Vehicle >> "faction") in _fractionE) then {eastvehicles = eastvehicles + [configName _Vehicle]};
				if (getText(_Vehicle >> "faction") in _fractionG) then {guervehicles = guervehicles + [configName _Vehicle]};
				if (getText(_Vehicle >> "faction") in _fractionC) then {civvehicles = civvehicles + [configName _Vehicle]};

				// Adds a list of Vehicle Addons which be needed

				if (getText(_Vehicle >> "faction") in _FactionsArray) then 
				{
					{if (((configName _Vehicle) in (_x select 1)) && !((_x select 0) in extra_addons)) then {extra_addons = extra_addons + [(_x select 0)]}} 

foreach _AddonArray;
				};		

	

		 	};

		_go = 0;

		}} foreach _allowedvehicleclass;
	};
};

// Loads the Addons to the mission and makes them public

publicVariable "extra_addons";

{activateAddons [_x]} foreach extra_addons;

// Change extra_addons to any of the Arrays and paste them to notepad
 
copyToClipboard str(extra_addons);


hint "done";