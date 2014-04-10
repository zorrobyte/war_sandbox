//undoc: nearbyLocations nearbyLocations = nearestLocations [getPos player, //["Strategic","StrongpointArea","FlatArea","FlatAreaCity","FlatAreaCitySmall","CityCenter","Airport","NameM//arine","NameCityCapital","NameCity","NameVillage","NameLocal","Hill","ViewPoint","RockArea","BorderCrossin//g","VegetationBroadleaf","VegetationFir","VegetationPalm","VegetationVineyard"], 1000000];

if (!isServer) exitWith {};
_towns = nearestLocations [getArray(configFile >> "CfgWorlds" >> worldName >> "centerPosition"), ["NameVillage"], 25000];

_center = createCenter sideLogic;
_group = createGroup _center;


ztowns = [];
{
    _pos = position _x;
	_logic = _group createUnit ["LOGIC",_pos , [], 0, ""];
	_logic synchronizeObjectsAdd [RydBBa_SAL];
	_logic synchronizeObjectsAdd [RydBBb_SAL];
	_logic setVariable ["AreaValue",5];
    _m = createMarker [format ["mrk%1",random 100000],_pos];
//	ztowns = ztowns + [_m];
	ztowns set [count ztowns,_m];
    _m setMarkerShape "ELLIPSE";
    _m setMarkerSize [100,100];
    _m setMarkerBrush "Solid";
    _m setMarkerAlpha 0.5;
    _m setMarkerColor "ColorRed";
} forEach _towns;
_towns = nearestLocations [getArray(configFile >> "CfgWorlds" >> worldName >> "centerPosition"), ["NameCity"], 25000];
ztownm = [];
{
    _pos = position _x;
	_logic = _group createUnit ["LOGIC",_pos , [], 0, ""];
	_logic synchronizeObjectsAdd [RydBBa_SAL];
	_logic synchronizeObjectsAdd [RydBBb_SAL];
	_logic setVariable ["AreaValue",10];
    _m = createMarker [format ["mrk%1",random 100000],_pos];
//	ztownm = ztownm + [_m];
	ztownm set [count ztownm,_m];
    _m setMarkerShape "ELLIPSE";
    _m setMarkerSize [200,200];
    _m setMarkerBrush "Solid";
    _m setMarkerAlpha 0.5;
    _m setMarkerColor "ColorRed";
} forEach _towns;
_towns = nearestLocations [getArray(configFile >> "CfgWorlds" >> worldName >> "centerPosition"), ["NameCityCapital"], 25000];
ztownl = [];
{
    _pos = position _x;
	_logic = _group createUnit ["LOGIC",_pos , [], 0, ""];
	_logic synchronizeObjectsAdd [RydBBa_SAL];
	_logic synchronizeObjectsAdd [RydBBb_SAL];
	_logic setVariable ["AreaValue",15];
    _m = createMarker [format ["mrk%1",random 100000],_pos];
//	ztownl = ztownl + [_m];
	ztownl set [count ztownl,_m];
    _m setMarkerShape "ELLIPSE";
    _m setMarkerSize [300,300];
    _m setMarkerBrush "Solid";
    _m setMarkerAlpha 0.5;
    _m setMarkerColor "ColorRed";
} forEach _towns;
//TESTING
_towns = nearestLocations [getArray(configFile >> "CfgWorlds" >> worldName >> "centerPosition"), ["Airport"], 25000];
ztownz = [];
{
    _pos = position _x;
    _m = createMarker [format ["mrk%1",random 100000],_pos];
//	ztownz = ztownz + [_m];
	ztownz set [count ztownz,_m];
    _m setMarkerShape "ELLIPSE";
    _m setMarkerSize [300,300];
    _m setMarkerBrush "Solid";
    _m setMarkerAlpha 0.5;
    _m setMarkerColor "ColorBlue";
} forEach _towns;
ztowninit = 1;

//{[[_x],[1,1],[1,1],[0,0],[0,0],[0,0,0],[4,0,250,EAST]] call EOS_Spawn} forEach ztownmgr;