_towns = nearestLocations [getArray(configFile >> "CfgWorlds" >> worldName >> "centerPosition"), ["NameVillage"], 25000];
ztowns = [];
{
    _pos = position _x;
    _m = createMarker [format ["mrk%1",random 100000],_pos];
	ztowns = ztowns + [_m];
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
    _m = createMarker [format ["mrk%1",random 100000],_pos];
	ztownm = ztownm + [_m];
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
    _m = createMarker [format ["mrk%1",random 100000],_pos];
	ztownl = ztownl + [_m];
    _m setMarkerShape "ELLIPSE";
    _m setMarkerSize [300,300];
    _m setMarkerBrush "Solid";
    _m setMarkerAlpha 0.5;
    _m setMarkerColor "ColorRed";
} forEach _towns;
ztowninit = 1;

//{[[_x],[1,1],[1,1],[0,0],[0,0],[0,0,0],[4,0,250,EAST]] call EOS_Spawn} forEach ztownmgr;