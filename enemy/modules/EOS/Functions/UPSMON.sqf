// =========================================================================================================
//  UPSMON - Urban Patrol Script  
//  version 6.0.1  
//
//  Author: Monsada (chs.monsada@gmail.com) 
//		Comunidad Hispana de Simulaci�n: 
//
//		Wiki: http://dev-heaven.net/projects/upsmon/wiki
//		Forum: http://forums.bistudio.com/showthread.php?t=91696
//		Share your missions with upsmon: http://dev-heaven.net/projects/upsmon/boards/86
// ---------------------------------------------------------------------------------------------------------
//  Based on Urban Patrol Script  v2.0.3
//  Author: Kronzky (www.kronzky.info / kronzky@gmail.com)
// ---------------------------------------------------------------------------------------------------------
//  Some little fixes: !Rafalsky (v5.0.8 - 5.0.9)
//  Code improvements: shay_gman(Artillery), Nordin("noveh")
// ---------------------------------------------------------------------------------------------------------

//  Required parameters:
//    unit        = Unit to patrol area (1st argument)
//    markername  = Name of marker that covers the active area. (2nd argument)
//
//	Patrol squad samples: (put in the leader's init field)
//    nul=[this,"area0"] execVM "scripts\upsmon.sqf";
//
//  Defensive squad samples:
//    nul=[this,"area0","nomove"] execVM "scripts\upsmon.sqf";
//
//  Reinforcement
//    nul=[this,"area0","reinforcement:",1] execVM "scripts\UPSMON.sqf";
//      (in trigger call:         KRON_UPS_reinforcement1 = true;
//      (call pos marker mkr1):   KRON_UPS_reinforcement1_pos = getMarkerPos "mkr1";
//
//
//  Optional parameters: _
//    random      = Place unit at random start position.
//    randomdn    = Only use random positions on ground level.
//    randomup    = Only use random positions at top building positions. 
//    min:n/max:n = Create a random number (between min and max) of 'clones'. ("min:",2,"max:",5)
//    init:string = Custom init string for created clones.
//    nomove      = Unit will stay or hide in the near buildings until enemy is spotted.
//    nofollow    = Unit will only follow an enemy within the marker area.(When fight sometimes can go outside)
//    onroad      = Unit will get target destination only on the roads 
//    nosmoke     = Units will not use smoke when s/o wounded or die.
//    delete:n    = Delete dead units after 'n' seconds.
//    nowait      = Do not wait at patrol end points.
//    noslow      = Keep default behaviour of unit (don't change to "safe" and "limited").
//    noai        = Don't use enhanced AI for evasive and flanking manoeuvres.
//    trigger     = Display a message when no more units are left in sector.
//    empty:n     = Consider area empty, even if 'n' units are left.
//    reinforcement  = Makes squad as reinforcement, when alarm KRON_UPS_reinforcement==true this squad will go where enemy were.
//    reinforcement:x  = Makes squad as reinforcement id, when alarm KRON_UPS_reinforcementx==true this squad will go where enemy were.
//    fortify = makes leader order to take positions on nearly buildings at distance 200 meters, squad fortified moves less than "nomove"
//	  aware,combat,stealth,careless defines default behaviour of squad
//    noveh       = the group will not search for transport vehicles (unless in fight and only combat vehicles)
//    noveh2       = the group will not search for transport vehicles (even in fight)
//    nowp  = No waypoints will be created for this squad UNTIL ENEMY DETECTED, this squad will communicate enemies but will not be moved by UPSMON until enemy detected, after that upsmon takes control of squad
//    nowp2 = No waypoints will be created for this squad UNTIL ENEMY DETECTED and damaged, this squad will communicate enemies but will not be moved by UPSMON until enemy detected and damaged, after that upsmon takes control of squad
//	  nowp3	= No waypoints will be created for this squad in any way, this squad will communicate enemies but will not be moved by UPSMON.
//	  ambush	= Ambush squad will not move until in combat, will lay mines if enabled and wait for incoming enemies stealth and ambush when near or discovered.
//	  ambush2	= Ambush squad will not move until in combat, will NOT LAY MINES and wait for incoming enemies stealth and ambush when near or discovered.
//	  ambush:n	= Creates an ambush and wait maximum the specified time n in seconds. you can put 0 seconds for putting mines and go away if combined with "move" for example
//	  ambush2:n = Same as ambush:n but without laying mines.
//    ambushdir: = Set the direction of the threat to the ambush squad ("NORTH","NORTHEAST","SOUTH" etc...)
//    ambushdir2: = Same as ambushdir: but without mines.
//	  respawn = allow squad to respawn when all members are dead and no targets near
//	  respawn:x = allows to define the number of times squad may respawn.
//    showmarker  = Display the area marker.
//    track       = Display a position and destination marker for each unit.

//	spawned = use only with squads created in runtime, this feature will add squad to UPSMON correctly.
//	aware,combat,stealth,careless defines default behaviour of squad

// numbers of Civilians killed by players could be read from the array 'KILLED_CIV_COUNTER' -> [Total, by West, by East, by Res, The Killer]

// SERVER OR HEADLESS CLIENT CHECK
//if (!isServer) exitWith {};
if (!isServer && hasInterface ) exitWith {};

if (isNil("KRON_UPS_INIT")) then {
	KRON_UPS_INIT=0;
};
	
waitUntil {KRON_UPS_INIT==1};

// convert argument list to uppercase
	_UCthis = [];
	for [{_i=0},{_i<count _this},{_i=_i+1}] do {
			_e=_this select _i;
			if (typeName _e=="STRING") then {_e=toUpper(_e)};
			_UCthis set [_i,_e]
		};

	if ((count _this)<2) exitWith {
		if (format["%1",_this]!="INIT") then {hint "UPS: Unit and marker name have to be defined!"};
	};
	
// Postioning
private["_targetX","_targetY","_relTX","_relTY","_relUX","_relUY","_waiting","_pursue","_react","_newpos","_currPos","_orgPos","_targetPos","_attackPos","_flankPos","_avoidPos", "_speedmode"];
private["_dist","_lastdist","_lastmove1","_lastmove2","_gothit", "_supressed" , "_flankdist","_nBuilding","_nBuildingt","_distnbuid","_distnbuidt"];
private["_objsflankPos1","_cntobjs1","_objsflankPos2","_cntobjs2","_targettext","_dir1","_dir2","_dir3","_dd","_timeontarget","_dirf1","_dirf2","_fightmode"
		,"_flankPos2","_cosU","_sinU","_cosT","_sinT","_reinforcement","_reinforcementsent","_target","_targets","_flankdir","_prov","_lastpos","_newtarget","_planta","_nomove"
		,"_newflankAngle","_sharedist" ,"_targetPosOld","_fldest","_grpidx","_grpid","_i","_unitpos","_Behaviour", "_incar", "_inheli" , "_inboat","_gunner","_driver"
		,"_vehicle","_minreact","_lastreact","_CombatMode","_rnd","_GetOutDist","_GetOut","_GetIn_NearestVehicles","_makenewtarget","_index","_wp","_grp","_wptype","_wpformation","_i"
		,"_targetdead","_frontPos","_GetIn","_dist1","_dist2","_dist3","_fldestfront","_fldest2","_bld","_blddist","_bldunitin","_flyInHeight","_fortify","_buildingdist","_rfid","_rfidcalled"
		,"_Mines","_enemytanks","_enemytanksnear","_friendlytanksnear","_mineposition","_enemytanknear","_roads","_timeout","_lastcurrpos","_wait","_countfriends","_side","_SURRENDER","_spawned"
		,"_nowp","_unitsIn","_ambush","_ambushed","_ambushdist","_friendside","_enemyside","_newattackPos","_fixedtargetpos","_NearestEnemy","_targetdist","_cargo","_targetsnear","_landing"
		,"_ambushwait","_membertypes","_respawn","_respawnmax","_lead","_safemode","_vehicles","_dist3","_lastwptype","_template","_unittype","_initstr","_fortifyorig","_nowpType","_ambushtype"
		,"_vehicletypes", "_onroad","_loop2", "_tries2","_targetPosTemp","_sokilled","_sowounded","_nosmoke","_newunit","_rlastpos","_rcurrpos","_jumpers","_isSoldier","_noveh"
		,"_deadBodiesReact","_isdiver","_ambushdir","_retreat","_tpwcas_running"];

_grpid =0;
_exit = false;
_fldest = 0;
_unitpos = "UP";
_vehicle = objnull;
_minreact = KRON_UPS_minreact;
_lastreact = KRON_UPS_minreact;
_rnd = 0.0;
_GetOutDist = 0;
_GetOut=false;
_index = 0;
_wp=[];
_wptype="HOLD";
_wpformation = "VEE";
_targetdead = false;
_GetIn=false;
_dist3 = 0;
_fldestfront = 0;
_fldest2=0;
_bld = objnull;
_flyInHeight = 0;
_rfid = 0;
_rfidcalled = false;
_Mines = 2; // org 1 - ToDo set to 4 ?
_enemytanks = [];
_friendlytanks =[];
_enemytanksnear = false;
_friendlytanksnear = false;
_mineposition = [0,0,0];
_enemytanknear = objnull;
_NearestEnemy = objnull;
_roads = [];
_timeout = 0;
_wait=90;
_countfriends = 0;
_side="";
_friendside=[];
_enemyside=[];
_surrender = 0;
_retreat = 0;
_surrended = false;
_inheli = false;
_spawned = false;
_nowp = false;
_unitsIn = [];
_ambush = false;
_ambushed = false;
_ambushdist = KRON_UPS_ambushdist;
_ambushdir = "";
_deadBodiesreact = R_deadBodiesReact; 
_dist2 = 0;
_targetdist = 10000;
_cargo = [];
_targetsnear = false;
_landing=false;
_ambushwait = 10000;
_membertypes = [];
_vehicletypes =[];
_respawn = false;
_respawnmax = 10000;
_lead=objnull;
_safemode=["CARELESS","SAFE"];
_vehicles = [];
_dist3=0;
_lastwptype = "";
_unittype = "";
_initstr = "";
_fortifyorig= false;
_rlastPos = [0,0,0];
// unit that's moving
_obj = leader (_this select 0); //group or leader

if ( isnil "_obj") exitwith 
{	
	hint format ["Object: %1",_obj];
	diag_log format ["UPSMON: Object for _npc: %1",_obj];
	};
_npc = _obj;


			
if (isnil "_lastcurrpos") then {_lastcurrpos = [0,0,0]};

// give this group a unique index
KRON_UPS_Instances = KRON_UPS_Instances + 1;
_grpid = KRON_UPS_Instances;
_grpidx = format["%1",_grpid];

_grpname = format["%1_%2",(side _npc),_grpidx];
_side = side _npc;


//To not run all at the same time we hope to have as many seconds as id's
_rnd = _grpid;
sleep _rnd ;


_tpwcas_running = if (!isNil "tpwcas_running") then {true} else {false};


// == set "UPSMON_grpid" to units in the group and EH===============================  
	{
		_x setVariable ["UPSMON_grpid", _grpid, false];
		sleep 0.05;
		
		
		if (side _x != civilian) then 
		{//soldiers 
			_x AddEventHandler ["hit", {nul = _this spawn R_SN_EHHIT}];	
			sleep 0.05;	
			_x AddEventHandler ["killed", {nul = _this spawn R_SN_EHKILLED}];	
			sleep 0.05;
			_x addeventhandler ["fired",{_this spawn Aze_SN_EHfired}];
			sleep 0.05;
			_x setvariable ["UPS_Fire",0];
			_x setvariable ["UPS_hear",[false,[0,0,0]]];
			
		}
		else
		{//civ
			if (! isnil "_x") then {
				//_x removeAllEventHandlers "firedNear"; // removed while this may impact other mods !
				sleep 0.05;
				_x AddEventHandler ["firedNear", {nul = _this spawn R_SN_EHFIREDNEAR}];
				sleep 0.05;
				
				//_x removeAllEventHandlers "killed"; // removed while this may impact other mods !
				sleep 0.05;
				_x AddEventHandler ["killed", {nul = _this spawn R_SN_EHKILLEDCIV}];
				sleep 0.05;
			};
		};
	} foreach units _npc;


//if is vehicle will not be in units so must set manually

	if (isnil {_npc getVariable ("UPSMON_grpid")}) then {		
		_npc setVariable ["UPSMON_grpid", _grpid, false];		
		sleep 0.05;
		
		if (side _npc != civilian) then 
		{ //soldiers
			_npc AddEventHandler ["hit", {nul = _this spawn R_SN_EHHIT}];	
			sleep 0.05;
			_npc AddEventHandler ["killed", {nul = _this spawn R_SN_EHKILLED}];	
			sleep 0.05;
			_x addeventhandler ["fired",{_this spawn Aze_SN_EHfired}];
			sleep 0.05;
			_x setvariable ["UPS_Fire",0];
			_x setvariable ["UPS_hear",[false,[0,0,0]]];
	
		}		
		else
		{ //civilian
		//	_npc removeAllEventHandlers "firedNear"; // removed while this may impact other mods !
		//	sleep 0.05;
			_npc AddEventHandler ["firedNear", {nul = _this spawn R_SN_EHFIREDNEAR}];
			sleep 0.05;	
			
			
			
		//	_npc removeAllEventHandlers "killed"; // removed while this may impact other mods !
			sleep 0.05;
			_npc AddEventHandler ["killed", {nul = _this spawn R_SN_EHKILLEDCIV}];
			sleep 0.05;
		};  //=> ; was missing here in previous version!
	};

	//the index will be _grpid  

	
if (KRON_UPS_Debug>0) then {player sidechat format["%1: New instance %2 %3 %4",_grpidx,_npc getVariable ("UPSMON_grpid")]}; 


	




// == get the name of area marker ==============================================
	_areamarker = _this select 1;
	if (isNil ("_areamarker")) exitWith {
		hint "UPS: Area marker not defined.\n(Typo, or name not enclosed in quotation marks?)";
	};	

	// remember center position of area marker
	_centerpos = getMarkerPos _areamarker;
	_centerX = abs(_centerpos select 0);
	_centerY = abs(_centerpos select 1);
	_centerpos = [_centerX,_centerY];

	// show/hide area marker 
	_showmarker = if ("SHOWMARKER" in _UCthis) then {"SHOWMARKER"} else {"HIDEMARKER"};
	if (_showmarker=="HIDEMARKER") then {
		//_areamarker setMarkerCondition "false"; // VBS2
		_areamarker setMarkerPos [-abs(_centerX),-abs(_centerY)];
	};

// is anybody alive in the group?
	_exit = true;

if (KRON_UPS_Debug>0) then {diag_log format["UPSMON - npc [%1] - typename [%2] - typeof [%3] - units [%4]",_npc, typename _npc, typeof _npc, units (group _npc)]; };	
	
	if ( !isNull _npc && { typeName _npc=="OBJECT" } ) then 
	{		
		if (!isNull group _npc) then 
		{
			_npc = ( [_npc,units (group _npc)] call MON_getleader );
		}
		else 
		{
			_vehicles = [_npc,2] call MON_nearestSoldiers;
			if (count _vehicles>0) then {
				_npc = [_vehicles select 0,units (_vehicles select 0)] call MON_getleader;
			};
		};
	}
	else 
	{
		if (count _obj>0) then {
			_npc = [_obj,count _obj] call MON_getleader;			
		};
	};
	
	// set the leader in the vehilce
	if (!(_npc iskindof "Man")) then { 
		if (!isnull(commander _npc) ) then {
			_npc = commander _npc;
		}else{
			if (!isnull(driver _npc) ) then {
				_npc = driver _npc;
			}else{			
				_npc = gunner _npc;	
			};	
		};
		group _npc selectLeader _npc;
	};

// ===============================================	
	if (alive _npc) then {_exit = false;};	
	if (KRON_UPS_Debug>0 && _exit) then {player sidechat format["%1 There is no alive members %1 %2 %3",_grpidx,typename _npc,typeof _npc, count units _npc]};	

	
	// exit if something went wrong during initialization (or if unit is on roof)
	if (_exit) exitWith {
		if (KRON_UPS_DEBUG>0) then {hint "Initialization aborted"};
	};



// remember the original group members, so we can later find a new leader, in case he dies
	_members = units _npc;
	KRON_UPS_Total = KRON_UPS_Total + (count _members);

//Fills member soldier types
	_vehicles = [];
	{	
		if (vehicle _x != _x ) then {
			_vehicles = _vehicles - [vehicle _x];
			_vehicles = _vehicles + [vehicle _x];
		};	
		_membertypes = _membertypes + [typeof _x];
	} foreach _members;

//Fills member vehicle types
	{
		_vehicletypes = _vehicletypes + [typeof _x];
	} foreach _vehicles;

// what type of "vehicle" is _npc ?
	_isman = "Man" countType [ vehicle _npc]>0;
	_iscar = "LandVehicle" countType [vehicle _npc]>0;
	_isboat = "Ship" countType [vehicle _npc]>0;
	_isplane = "Air" countType [vehicle _npc]>0;
	_isdiver = ["diver", (typeOf (leader _npc))] call BIS_fnc_inString;
	
	//diag_log format ["UPSMON diver: %1: %2", typeOf (leader _npc), ['diver', (typeOf (leader _npc))] call BIS_fnc_inString];

// we just have to brute-force it for now, and declare *everyone* an enemy who isn't a civilian // ToDo rewrite using getFriend
	_isSoldier = _side != civilian;

	_friends=[];
	_enemies=[];	
	_sharedenemy=0;

	if (_isSoldier) then {
		switch (_side) do {
		case west:
			{ 	_sharedenemy=0; 
				_friendside = [west];
				_enemyside = [east];				
			};
		case east:
			{  _sharedenemy=1; 
				_friendside = [east];
				_enemyside = [west];
			};
		case resistance:
			{ 
			 _sharedenemy=2; 
			 _enemyside = KRON_UPS_Res_enemy;
			 
				if (!(east in _enemyside)) then {	
					_friendside = [east];
				}; 
				if (!(west in _enemyside)) then {
					_friendside = [west];
				};			 
			};
		};
	};
	
	if (_side in KRON_UPS_Res_enemy) then {
		_enemyside = _enemyside + [resistance];
	}else {
		_friendside = _friendside + [resistance];	
	};
	sleep .05;

//Sets min units alive for surrender
if !( _side == civilian ) then 
{ 
	_surrender = call (compile format ["KRON_UPS_%1_SURRENDER",_side]); 
	_retreat = call (compile format ["KRON_UPS_%1_SURRENDER",_side]); 
};

	
	// Tanks friendlys are contabiliced
{
	if ( side _x in _friendside && ( _x iskindof "Tank"  || _x iskindof "Wheeled_APC" )) then {
		_friendlytanks = _friendlytanks + [_x];
	};
}foreach vehicles;	

// global unit variable to externally influence script 
//call compile format ["KRON_UPS_%1=1",_npcname];

// X/Y range of target area
_areasize = getMarkerSize _areamarker;
_rangeX = _areasize select 0;
_rangeY = _areasize select 1;
_area = abs((_rangeX * _rangeY) ^ 0.5);
// marker orientation (needed as negative value!)
_areadir = (markerDir _areamarker) * -1;


// store some trig calculations
_cosdir=cos(_areadir);
_sindir=sin(_areadir);

// minimum distance of new target position
_mindist=(_rangeX^2+_rangeY^2)/3;
if (_rangeX==0) exitWith {
	hint format["UPS: Cannot patrol Sector: %1\nArea Marker doesn't exist",_areamarker]; 
};

// remember the original mode & speed
_orgMode = behaviour _npc;
_orgSpeed = speedmode _npc;

// set first target to current position (so we'll generate a new one right away)
_currPos = getpos _npc;
_orgPos = _currPos;
_orgDir = getDir _npc;
_orgWatch=[_currPos,50,_orgDir] call KRON_relPos; 
_lastpos = _currPos;

_avoidPos = [0,0];
_flankPos = [0,0];
_attackPos = [0,0];
_newattackPos = [0,0];
_fixedtargetpos = [0,0];
_frontPos = [0,0];
_dirf1 = 0;_dirf2=0;_flankPos2=[0,0];
_dist = 10000;
_lastdist = 0;
_lastmove1 = 0;
_lastmove2 = 0;
_maxmove=0;
_moved=0;

_damm=0;
_dammchg=0;
_lastdamm = 0;
_timeontarget = 0;

_fightmode = "walk";
_fm=0;
_gothit = false;
_pursue = false;
_hitPos=[0,0,0];
_react = 0;
_lastknown = 0;
_opfknowval = 0;

_sin0=1;
_sin90=1; _cos90=0;
_sin270=-1; _cos270=0;
_targetX =0; _targetY=0; 
_relTX=0;_relTY=0;
_relUX=0;_relUY=0;
_supressed = false;
_flankdist=0;
_nBuilding=nil;
_nBuildingt =nil;
_speedmode=_orgSpeed;
_distnbuid = 0;
_distnbuidt = 0;
_objsflankPos1 =  [];
_cntobjs1 = 0;
_objsflankPos2 =  [];
_cntobjs2 = 0;
_targettext ="";
_dir1 =0;_dir2=0;_dir3=0;_dd=0;
_timeontarget=0;
_reinforcement ="";
_reinforcementsent = false;
_target = objnull;
_newtarget=objnull;
_flankdir=0; //1 tendencia a flankpos1, 2 tendencia a flankpos2
_prov=0;
_targets=[];
_planta=0; //Indice de plantas en edificios
_newflankAngle = 0;
_closeenough = KRON_UPS_closeenough;
_closenoughV = KRON_UPS_closeenoughV; 
_gunner = objnull;
_driver = objnull;
_fortify = false;
_buildingdist= 25;//Distance to search buildings near
_Behaviour = _orgMode; 
_grp = grpnull;
_grp = group _npc;
_template = 0;
_nowpType = 1;
_ambushtype = 1;
_rstuckControl = 0;
_makenewtarget=true;



// set target tolerance high for choppers & planes
if (_isplane) then {_closeenough = KRON_UPS_closeenough * 2};

// ***************************************** optional arguments *****************************************

// wait at patrol end points
_pause = if ("NOWAIT" in _UCthis) then {"NOWAIT"} else {"WAIT"};
// don't move until an enemy is spotted
_nomove  = if ("NOMOVE" in _UCthis) then {"NOMOVE"} else {"MOVE"};

//fortify group in near places
	_fortify= if ("FORTIFY" in _UCthis) then {true} else {false};
	_fortifyorig = _fortify;
	if (_fortify) then {
		_nomove="NOMOVE";
		_minreact = KRON_UPS_minreact * 3;
		_buildingdist = _buildingdist * 2;
		_makenewtarget = false;
		_wait = 3000;
		// _nowp = true;
	};

// create _targerpoint on the roads only (by this group)
	_onroad = if ("ONROAD" in _UCthis) then {true} else {false};
// do not use smoke (by this group)
	_nosmoke = if ("NOSMOKE" in _UCthis) then {true} else {false};
// do not search for vehicles (unless in fight and combat vehicles)
_noveh = if ("NOVEH" in _UCthis || "NOVEH2" in _UCthis) then {true} else {false};	
_noveh2 = if ("NOVEH2" in _UCthis) then {true} else {false};	// Ajout
	

// don't make waypoints
	_nowp = if ("NOWP" in _UCthis) then {true} else {false};
	_nowp = if ("NOWP2" in _UCthis) then {true} else {_nowp};
	_nowp = if ("NOWP3" in _UCthis) then {true} else {_nowp};
	_nowpType = if ("NOWP2" in _UCthis) then {2} else {_nowpType};
	_nowpType = if ("NOWP3" in _UCthis) then {3} else {_nowpType};
	
//Ambush squad will no move until in combat or so close enemy
	_ambush= if (("AMBUSH" in _UCthis) || ("AMBUSHDIR:" in _UCthis) || ("AMBUSH2" in _UCthis) || ("AMBUSHDIR2:" in _UCthis)) then {true} else {false};
	_ambushwait = ["AMBUSH:",_ambushwait,_UCthis] call KRON_UPSgetArg;
	_ambushwait = ["AMBUSH2:",_ambushwait,_UCthis] call KRON_UPSgetArg;
	_ambushdir = ["AMBUSHDIR:",_ambushdir,_UCthis] call KRON_UPSgetArg; // Ajout
	_ambushdir = ["AMBUSHDIR2:",_ambushdir,_UCthis] call KRON_UPSgetArg; // Ajout
	_ambushType = if ("AMBUSH2" in _UCthis) then {2} else {_ambushType};
	_ambushType = if ("AMBUSHDIR2:" in _UCthis) then {2} else {_ambushType}; // Ajout
	_ambushType = if ("AMBUSH2:" in _UCthis) then {2} else {_ambushType};
	

// respawn
	_respawn = if ("RESPAWN" in _UCthis) then {true} else {false};
	_respawn = if ("RESPAWN:" in _UCthis) then {true} else {_respawn};
	_respawnmax = ["RESPAWN:",_respawnmax,_UCthis] call KRON_UPSgetArg;
	if (!_respawn) then {_respawnmax = 0};

// any init strings?
	_initstr = ["INIT:","",_UCthis] call KRON_UPSgetArg;

// don't follow outside of marker area
	_nofollow = if ("NOFOLLOW" in _UCthis) then {"NOFOLLOW"} else {"FOLLOW"};
// share enemy info 
	_shareinfo = if ("NOSHARE" in _UCthis) then {"NOSHARE"} else {"SHARE"};
// "area cleared" trigger activator
	_areatrigger = if ("TRIGGER" in _UCthis) then {"TRIGGER"} else {if ("NOTRIGGER" in _UCthis) then {"NOTRIGGER"} else {"SILENTTRIGGER"}};

	// suppress fight behaviour
	if ("NOAI" in _UCthis) then {_isSoldier=false};

	// adjust cycle delay 
	_cycle = ["CYCLE:",KRON_UPS_Cycle,_UCthis] call KRON_UPSgetArg;
	_currcycle=_cycle;

	//spawned for squads created in runtime
	_spawned= if ("SPAWNED" in _UCthis) then {true} else {false};
	if (_spawned) then {
		if (KRON_UPS_Debug>0) then {player sidechat format["%1: squad has been spawned, respawns %2",_grpidx,_respawnmax]}; 	
		switch (side _npc) do {
			case west:
			{ 	KRON_AllWest=KRON_AllWest + units _npc; 
			};
			case east:
			{  	KRON_AllEast=KRON_AllEast + units _npc; };
			case resistance:
			{  	
				KRON_AllRes=KRON_AllRes + units _npc; 
				if (east in KRON_UPS_Res_enemy ) then {	
					KRON_UPS_East_enemies = KRON_UPS_East_enemies+units _npc;
				} else {
					KRON_UPS_East_friends = KRON_UPS_East_friends+units _npc;
				}; 
				if (west in KRON_UPS_Res_enemy ) then {
					KRON_UPS_West_enemies = KRON_UPS_West_enemies+units _npc;
				} else {
					KRON_UPS_West_friends = KRON_UPS_West_friends+units _npc;
				};				
			};		
		};
		call (compile format ["KRON_UPS_%1_Total = KRON_UPS_%1_Total + count (units _npc)",side _npc]); 	
	
		_vehicletypes = ["VEHTYPE:",_vehicletypes,_UCthis] call KRON_UPSgetArg; 
	
	};

// set drop units at random positions
	_initpos = "ORIGINAL";
	if ("RANDOM" in _UCthis) then {_initpos = "RANDOM"};
	if ("RANDOMUP" in _UCthis) then {_initpos = "RANDOMUP"}; 
	if ("RANDOMDN" in _UCthis) then {_initpos = "RANDOMDN"}; 
	// don't position groups or vehicles on rooftops
	if ((_initpos!="ORIGINAL") && ((!_isman) || (count _members)>1)) then {_initpos="RANDOMDN"};
	
	// set behaviour modes (or not)
	_orgMode = "SAFE";
	if ("CARELESS" in _UCthis) then {_orgMode = "CARELESS"}; 
	if ("AWARE" in _UCthis) then {_orgMode = "AWARE"}; 
	if ("COMBAT" in _UCthis) then {_orgMode = "COMBAT"}; 
	if ("STEALTH" in _UCthis) then {_orgMode = "STEALTH"}; 

// set original beahviour	
	if (!_isSoldier) then {
		_Behaviour = "CARELESS";
	} else {		
		_Behaviour = _orgMode; 
	};
	_npc setbehaviour _Behaviour;
		

// set initial speed
	_noslow = if ("NOSLOW" in _UCthis) then {"NOSLOW"} else {"SLOW"};
	if (_noslow!="NOSLOW") then {
		_orgSpeed = "limited";
	} else {	
		_orgSpeed = "FULL";	
	}; 
	_speedmode = _orgSpeed;
	_npc setspeedmode _speedmode;

// set If enemy detected reinforcements will be sent REIN1
	_reinforcement= if ("REINFORCEMENT" in _UCthis) then {"REINFORCEMENT"} else {"NOREINFORCEMENT"}; //rein_yes
	_rfid = ["REINFORCEMENT:",0,_UCthis] call KRON_UPSgetArg; // rein_#

	if (_rfid>0) then {
		_reinforcement="REINFORCEMENT";
		if (KRON_UPS_Debug>0) then {hintsilent format["%1: reinforcement group %2",_grpidx,_rfid,_rfidcalled,_reinforcement]}; 	
	};

//set Is a template for spawn module?
	_template = ["TEMPLATE:",_template,_UCthis] call KRON_UPSgetArg;
	//Fills template array for spawn
	if (_template > 0 && !_spawned) then {
		KRON_UPS_TEMPLATES = KRON_UPS_TEMPLATES + ( [[_template]+[_side]+[_membertypes]+[_vehicletypes]] );
		//if (KRON_UPS_Debug>0) then {diag_log format["%1 Adding TEMPLATE %2 _spawned %3",_grpidx,_template,_spawned]};	
		//if (KRON_UPS_Debug>0) then {player globalchat format["KRON_UPS_TEMPLATES %1",count KRON_UPS_TEMPLATES]};		
	};

// make start position random 
	if (_initpos!="ORIGINAL") then {
		// find a random position (try a max of 20 positions)
		_try=0;
		_bld=0;
		_bldpos=0;
		while {_try<20} do {
			_currPos=[_centerX,_centerY,_rangeX,_rangeY,_cosdir,_sindir,_areadir] call KRON_randomPos;
			_posinfo=[_currPos] call KRON_PosInfo3;
			// _posinfo: [0,0]=no house near, [obj,-1]=house near, but no roof positions, [obj,pos]=house near, with roof pos
			_bld=_posinfo select 0;
			_bldpos=_posinfo select 1;
			if (_isplane || _isboat || _isDiver || !(surfaceiswater _currPos)) then {
				if (((_initpos=="RANDOM") || (_initpos=="RANDOMUP")) && (_bldpos>0)) then {_try=99};
				if (((_initpos=="RANDOM") || (_initpos=="RANDOMDN")) && (_bldpos==0)) then {_try=99};
			};
			_try=_try+1;
			sleep .01;
		};
		
		if (_bldpos==0) then 
		{
			{ //man
				if (vehicle _x == _x) then 
				{
					_x setpos _currPos;	
				};
			} foreach units _npc; 
			
			sleep .5;			
			{ // vehicles
				_targetpos = _currPos findEmptyPosition [10, 100];
				sleep .4;						
				if (count _targetpos <= 0) then {_targetpos = _currpos};
				_x setPos _targetpos;
			} foreach _vehicles;
		} 
		else 
		{
		// put the unit on top of a building
			_npc setPos (_bld buildingPos _bldpos); 
			_currPos = getPos _npc;
			_nowp=true; // don't move if on roof		
		};
	};

// track unit ======================================================================================
	_track = 	if (("TRACK" in _UCthis) || (KRON_UPS_Debug>0)) then {"TRACK"} else {"NOTRACK"};
	_trackername = "";
	_destname = "";
	if (_track=="TRACK") then {
		_track = "TRACK";
		_trackername=format["trk_%1",_grpidx];
		_markerobj = createMarker[_trackername,[0,0]];
		_markerobj setMarkerShape "ICON";
		//_markertype = if (isClass(configFile >> "cfgMarkers" >> "WTF_Dot")) then {"WTF_DOT"} else {"mil_DOT"};
		_markertype = "mil_dot";
		
		_trackername setMarkerType _markertype;
		_markercolor = switch (side _npc) do {
			case west: {"ColorGreen"};
			case east: {"ColorRed"};
			case resistance: {"ColorBlue"};
			default {"ColorBlack"};
		};
		_trackername setMarkerColor _markercolor;
		_trackername setMarkerText format["%1",_grpidx];
		_trackername setmarkerpos _currPos; 
		
		_destname=format["dest_%1",_grpidx];
		_markerobj = createMarker[_destname,[0,0]];
		_markerobj setMarkerShape "ICON";
		//_markertype = if (isClass(configFile >> "cfgMarkers" >> "WTF_Flag")) then {"WTF_FLAG"} else {"FLAG"};
		_markertype = "mil_objective";
		
		_destname setMarkerType _markertype;
		_destname setMarkerColor _markercolor;
		_destname setMarkerText format["%1",_grpidx];
		_destname setMarkerSize [.5,.5];
	};	


// delete dead units ==============================================================================
	_deletedead = ["DELETE:",0,_UCthis] call KRON_UPSgetArg;
	if (_deletedead>0) then {
		{
			_x addEventHandler['killed',format["[_this select 0,%1] spawn KRON_deleteDead",_deletedead]];
			sleep 0.01;
		}forEach _members;
	};

// how many group clones? =========================================================================
// TBD: add to global side arrays?
	_mincopies = ["MIN:",0,_UCthis] call KRON_UPSgetArg;
	_maxcopies = ["MAX:",0,_UCthis] call KRON_UPSgetArg;
	if (_mincopies>_maxcopies) then {_maxcopies=_mincopies};
	if (_maxcopies>140) exitWith {hint "Cannot create more than 140 groups!"};
	if (_maxcopies>0) then {
		_copies=_mincopies+random (_maxcopies-_mincopies);	

	// create the clones
		for "_grpcnt" from 1 to _copies do {
			// copy groups
			if (isNil ("KRON_grpindex")) then {KRON_grpindex = 0}; 
			KRON_grpindex = KRON_grpindex+1;
			// copy group leader
			_unittype = typeof _npc;
			// make the clones civilians
			// use random Civilian models for single unit groups
			if ((_unittype=="Civilian") && (count _members==1)) then {_rnd=1+round(random 20); if (_rnd>1) then {_unittype=format["Civilian%1",_rnd]}};
			

			_grp=createGroup side _npc;
			_lead = _grp createUnit [_unittype, getpos _npc, [], 0, "form"];
			_lead setVehicleVarName format["l%1",KRON_grpindex];
			call compile format["l%1=_lead",KRON_grpindex];
			_lead setBehaviour _orgMode;
			_lead setSpeedmode _orgSpeed;
			_lead setSkill skill _npc;
			[[netid _lead, _initstr], "KRON_fnc_setVehicleInit", true, true] spawn BIS_fnc_MP; // ToDo check persistent 'true'
			[_lead] join _grp;
			_grp selectLeader _lead;
			// copy team members (skip the leader)
			_i=0;
			{
				_i=_i+1;
				if (_i>1) then {
					_newunit = _grp createUnit [typeof _x, getpos _x, [],0,"form"];
					_newunit setBehaviour _orgMode;
					_newunit setSpeedMode _orgSpeed;
					_newunit setSkill skill _x;
					[[netid _lead, _initstr], "KRON_fnc_setVehicleInit", true, true] spawn BIS_fnc_MP;
					[_newunit] join _grp;
				};
			} foreach _members;
			nul=[_lead,_areamarker,_pause,_noslow,_nomove,_nofollow,_initpos,_track,_showmarker,_shareinfo,"DELETE:",_deletedead] execVM "enemy\modules\EOS\Functions\UPSMON.sqf";
			//sleep .05;
		};	
		sleep .05;
	};


// units that can be left for area to be "cleared" =============================================================================================
	_zoneempty = ["EMPTY:",0,_UCthis] call KRON_UPSgetArg;

// create area trigger =========================================================================================================================
	if (_areatrigger!="NOTRIGGER") then {
		_trgside = switch (side _npc) do { case west: {"WEST"}; case east: {"EAST"}; case resistance: {"GUER"}; case civilian: {"CIV"};};
		//_trgside = switch (side _npc) do { case west: {"EAST"}; case east: {"WEST"}; case resistance: {"ANY"}; case civilian: {"ANY"};};
		_trgname="KRON_Trig_"+_trgside+"_"+_areamarker;
		_flgname="KRON_Cleared_"+_areamarker;
		// has the trigger been created already?
		KRON_TRGFlag=-1;
		call compile format["%1=false",_flgname];
		call compile format["KRON_TRGFlag='%1'",_trgname];
		if (isNil ("KRON_TRGFlag")) then 
//		if !(isNil {_trgname} ) then // ToDo if this code should replace 2 lines above
//		{
//			call compile format["{KRON_TRGFlag=%1};",_trgname];
//		};
//		if ( KRON_TRGFlag == -1 ) then 
		{
			// trigger doesn't exist yet, so create one (make it a bit bigger than the marker, to catch path finding 'excursions' and flanking moves)
			call compile format["%1=createTrigger['EmptyDetector',_centerpos]",_trgname];
			call compile format["%1 setTriggerArea[_rangeX*1.5,_rangeY*1.5,markerDir _areamarker,true]",_trgname];
			call compile format["%1 setTriggerActivation[_trgside,'PRESENT',true]",_trgname];
			call compile format["%1 setEffectCondition 'true'",_trgname];
			call compile format["%1 setTriggerTimeout [5,7,10,true]",_trgname];
			if (_areatrigger!="SILENTTRIGGER") then {
				call compile format["%1 setTriggerStatements['count thislist<=%6', 'titletext [''SECTOR <%2> LIMPIO'',''PLAIN''];''%2'' setmarkerpos [-%4,-%5];%3=true;', 'titletext [''SECTOR <%2> HA SIDO REOCUPADO'',''PLAIN''];''%2'' setmarkerpos [%4,%5];%3=false;']", _trgname,_areamarker,_flgname,_centerX,_centerY,_zoneempty];
				
			} else {
				call compile format["%1 setTriggerStatements['count thislist<=%3', '%2=true;', '%2=false;']", _trgname,_flgname,_zoneempty];
			};
		};
		sleep .05;
	};

//If a soldier has a useful building takes about ======================================================================================================================		
	if ( _nomove=="NOMOVE") then {			
			sleep 1;
			_unitsIn = [_grpid,_npc,150] call MON_GetIn_NearestStatic;		
			if ( count _unitsIn > 0 ) then { sleep 10};
			[_npc, _buildingdist,false,_wait,true] spawn MON_moveNearestBuildings;
		};	

// init done
	_newpos = false;
	_targetPos = [0,0,0];//_currPos;
	_targettext ="_currPos";
	_swimming = false;
	_waiting = if (_nomove=="NOMOVE") then {9999} else {0};
	_sharedist = if (_nomove=="NOMOVE") then {KRON_UPS_sharedist} else {KRON_UPS_sharedist*1.5};


//Gets position of waypoint if no targetpos
	if (format ["%1", _targetPos] == "[0,0,0]") then {
		_index = (count waypoints _grp) - 1;	
		_wp = [_grp,_index];
		_targetPos = waypointPosition _wp;
		if (([_currpos,_targetPos] call KRON_distancePosSqr)<= 20) then {_targetPos = [0,0,0];};
	};

// ***********************************************************************************************************
// ************************************************ MAIN LOOP ************************************************
// ***********************************************************************************************************
_loop=true;

scopeName "main"; 
while {_loop} do 
{
	//if (KRON_UPS_Debug>0) then {player sidechat format["%1: _cycle=%2 _currcycle=%3 _react=%4 _waiting=%5",_grpidx,_cycle,_currcycle,_react,_waiting]}; 
	
	if (isnil "_react") then {_react = 0}; 
	_timeontarget=_timeontarget+_currcycle;
	_react=_react+_currcycle;	
	_waiting = _waiting - _currcycle;
	_lastreact = _lastreact + _currcycle;
	_newpos = false;			

	_sokilled = false;
	_sowounded = false;
	_gothit = false;
	_Supstate = random 100 < 40;

	
	
	// Variable check if Unit is HIT / WOUNDED / KILLED ===========================================================================
	// CHECK IF did anybody in the group got hit or die? 
	
	If (!_tpwcas_running) then 
	{
		if (group _npc in R_GOTHIT_ARRAY || group _npc in R_GOTKILL_ARRAY) then
		{
			_gothit = true;
			
			if (group _npc in R_GOTHIT_ARRAY) then
			{
				_sowounded = true;
			}
			else
			{
				_sokilled = true;
				R_GOTKILL_ARRAY = R_GOTKILL_ARRAY - [group _npc];
			};
			R_GOTHIT_ARRAY = R_GOTHIT_ARRAY - [group _npc];
		};
	} 
	else 
	{
		_Supstate = [_npc] call Aze_supstatestatus; 
		if (_Supstate >= 2) then
		{
			_gothit = true;
		};
		
		if (group _npc in R_GOTHIT_ARRAY || group _npc in R_GOTKILL_ARRAY) then
		{
			_gothit = true;
			
			if (group _npc in R_GOTHIT_ARRAY) then
			{
				_sowounded = true;
			}
			else
			{
				_sokilled = true;
				R_GOTKILL_ARRAY = R_GOTKILL_ARRAY - [group _npc];
			};
			R_GOTHIT_ARRAY = R_GOTHIT_ARRAY - [group _npc];
		};
	};	
	

	
	// EXIT FROM LOOP ===================================================================
	// nobody left alive, exit routine
	if (count _members==0) then 
	{
		_exit=true;
	} 
	else 
	{
		// did the leader die?
		_npc = [_npc,_members] call MON_getleader;							
		if (!alive _npc || !canmove _npc || isplayer _npc ) exitwith {_exit=true;};	
	};
		
	//exits from loop
	if (_exit) exitwith {};
	
	//===================================================================
	
	//Checks if surrender is enabled
	If ( KRON_UPS_SURRENDER 
		&& { !(isNull _target) } 
		&& { alive _target } 
		&& { _gothit } 
		&& { _npc == vehicle (_npc) } 
		&& { alive _npc } 
		&& { morale _npc < -1.1 } 
		&& { ((random 100) <= _surrender)} 
	   ) then
	{
		_alliednear = [_npc] call Aze_checkallied; 
		If (_target distance _npc < 150 && !_alliednear) then {
		
			// _surrended = call (compile format ["KRON_UPS_%1_SURRENDED",_side]);
			_surrended = true;
		};		
	};
	
	//If surrended exits from script
	if (_surrended) exitwith {	
		{
			[_x] spawn MON_surrender;
		}foreach _members;
		
		if (KRON_UPS_Debug>0) then {_npc globalchat format["%1: %2 SURRENDED",_grpidx,_side]};		
	};
	
	//Assign the current leader of the group in the array of group leaders
	// KRON_NPCs set [_grpid,_npc];
	If (!(_npc in KRON_NPCs)) then {KRON_NPCs = KRON_NPCs + [_npc];};
	

	// current position
	_currPos = getpos _npc; _currX = _currPos select 0; _currY = _currPos select 1;
	if (_track=="TRACK" || KRON_UPS_Debug>0) then { _trackername setmarkerpos _currPos; };
	
	
	// if the AI is a civilian we don't have to bother checking for enemy encounters
	if ( _isSoldier && !_exit) then 
	{
		_pursue=false;
		//_Behaviour = Behaviour _npc;
				
		//Variables to see if the leader is in a vehicle		
		_incar = "LandVehicle" countType [vehicle (_npc)]>0;
		_inheli = "Air" countType [vehicle (_npc)]>0;
		_inboat = "Ship" countType [vehicle (_npc)]>0;			
	
		//If the group is strengthened and the enemies have been detected are sent to target
		if (_rfid > 0 ) then 
		{
			_rfidcalled = call (compile format ["KRON_UPS_reinforcement%1",_rfid]); // will be TRUE when variable in triger will be true.
			if (isnil "_rfidcalled") then {_rfidcalled=false};	
			_fixedtargetPos = call (compile format ["KRON_UPS_reinforcement%1_pos",_rfid]); // will be position os setfix target of sending reinforcement
			if (isnil "_fixedtargetPos") then {
				_fixedtargetPos=[0,0];
			}else{
				_fixedtargetPos =  [abs(_fixedtargetPos select 0),abs(_fixedtargetPos select 1)];			
				_target = objnull;
			};															
		};
		sleep .01;
		
		//Reinforcement control
		if (_reinforcement=="REINFORCEMENT") then {
			// (global call  OR id call) AND !send yet
			if ( (KRON_UPS_reinforcement || _rfidcalled) && (!_reinforcementsent)) then {				
				_reinforcementsent=true;
				_fortify = false;
				_minreact = KRON_UPS_minreact;
				_buildingdist = 60;			
				_react = _react + 100;		
				_waiting = -1;					
				if (format ["%1",_fixedtargetPos] != "[0,0]") then {_nowp = false};	
				if (KRON_UPS_Debug>0) then {player sidechat format["%1 called for reinforcement %2",_grpidx,_fixedtargetPos]};	
			} else {
				// !(global or id call) AND send
				if ( !(KRON_UPS_reinforcement || _rfidcalled) && (_reinforcementsent)) then {
					_fixedtargetPos = [0,0];
					_attackPos = [0,0];
					_fortify = _fortifyorig;
					_reinforcementsent=false;
					if (_rfid > 0 ) then {
						call (compile format ["KRON_UPS_reinforcement%1_pos = [0,0]",_rfid]);
						call (compile format ["KRON_UPS_reinforcement%1 = false",_rfid]);
					};
					if (KRON_UPS_Debug>0) then {player sidechat format["%1 reinforcement canceled",_grpidx]};	
				};
			};
		};		
			
//*********************************************************************************************************************
// 											ACQUISITION OF TARGET 	
//*********************************************************************************************************************		
		
		//Gets targets from radio
		_targets = call (compile format ["KRON_targets%1",_sharedenemy]);		
		
		// if (KRON_UPS_Debug>0) then {player globalchat format["targets from global upsmon: %1",_targets]};	//!R
				
		//Reveal targets found by members to leader
		{
			//_NearestEnemy = assignedTarget _x;
			//if (KRON_UPS_Debug>0) then {player globalchat format["Nearest Enemy %1, know about %2",_NearestEnemy,_x knowsabout _NearestEnemy]}; //!R
			_NearestEnemy = _x findnearestenemy _x;
			if (_x knowsabout _NearestEnemy > R_knowsAboutEnemy && (_npc knowsabout _NearestEnemy <= R_knowsAboutEnemy || count _targets <= 0 )) then 	{		
				
				if (_npc knowsabout _NearestEnemy <= R_knowsAboutEnemy ) then 	{		 
					_npc reveal _NearestEnemy;
					if (KRON_UPS_Debug>0) then {player globalchat format["%1: %2 reveals target %3 to leader",_grpidx,typeof _x, typeof _NearestEnemy]}; 	
				};
				
				//If no targets adds this
				if (count _targets <= 0) then {
					//_target = _NearestEnemy;
					_targets = _targets + [_NearestEnemy];					
					_NearestEnemy setvariable ["UPSMON_lastknownpos", position _NearestEnemy, false];						
					//if (KRON_UPS_Debug>0) then {player globalchat format["%1: %3 added to targets",_grpidx,typeof _x, typeof _target]}; 						
				};
			};
		} foreach units (group _npc);			
		

		//if no target but _npc knows enemy then this is _target
		if (isNull (_target)) then {
			{	
				if ((_npc knowsabout _x > R_knowsAboutEnemy) && (alive _x) && (canmove _x)) then {
					_target =_x;
					if (!isNull (_target)) exitWith{};
				};							
			} foreach _targets;
		};
		
		//Resets distance to target
		_dist = 10000;
		
		if (isNull(_target) && !alive _target) then
		{
			if ((_npc getvariable "UPS_Hear") select 0) then
			{
			
				_newattackPos = (_npc getvariable "UPS_Hear") select 1;			
			
				if ( !isnil "_newattackPos" ) then {
					_attackPos=_newattackPos;	
					//Gets distance to target known pos
					_dist = ([_currpos,_attackPos] call KRON_distancePosSqr);				
				};
			};
		};		
		
		//Gets  current known position of target and distance
		if ( !isNull (_target) && alive _target ) then {
			_newattackPos = _target getvariable ("UPSMON_lastknownpos");			
			
			if ( !isnil "_newattackPos" ) then {
				_attackPos=_newattackPos;	
				//Gets distance to target known pos
				_dist = ([_currpos,_attackPos] call KRON_distancePosSqr);				
			};
		};	
		
		
		
		//Initialization for geting new targets
		//If the current target is dead or no prior knowledge is cleaned
		if (isNull (_target) || !alive _target || !canmove _target ) then {
			_lastknown = 0;
			_opfknowval = 0; 
			_target = objnull;			 	
		};			
		
		_newtarget = _target;	
		

		if ((_shareinfo=="SHARE")) then {			
			
			//Requests for radio the enemy's position, if it is within the range of acts
			if ((KRON_UPS_comradio == 2)) then
			{	
				_targetsnear = false;			
							
				//I we have a close target alive do not search another
				if (!alive _target || { !canmove _target } || { _dist > _closeenough } ) then {					
					{															
						 if ( !isnull _x && { canmove _x } && { alive _x } ) then 
						 {													
							_newattackPos = _x getvariable ("UPSMON_lastknownpos");		
	
							if (  !isnil "_newattackPos" ) then 
							{	
								_dist3 = ([_currpos,_newattackPos] call KRON_distancePosSqr);	
															
								//Sets if near targets to begin warning
								// _dist3 <= (_closeenough + KRON_UPS_safedist)
								IF ( _dist3 <= _closeenough) then { _targetsnear = true };				
								
								//Sets new target
								if ( ( isnull (_newtarget) || captive _newtarget|| !alive _newtarget|| !canmove _newtarget || _dist3 < _dist ) 								
									&& ( _dist3 <= _sharedist || _reinforcementsent )
									&& ( !(_x iskindof "Air") || (_x iskindof "Air" && _isplane ))
									&& ( !(_x iskindof "Ship") || (_x iskindof "Ship" && _isboat ))
									&& ( _x emptyPositions "Gunner" == 0 && _x emptyPositions "Driver" == 0 
									|| (!isnull (gunner _x) && canmove (gunner _x))
									|| (!isnull (driver _x) && canmove (driver _x))) 	
									) then 
								{
									_newtarget = _x;				
									_opfknowval = _npc knowsabout _x; 
									_dist = _dist3;			
									if (_dist < _closeenough) exitWith {};	
								};	
							};
						};					
					} foreach _targets;
					sleep 0.5;
				};
			};				
					
			//If you change the target changed direction flanking initialize
			if ( !isNull (_newtarget) && alive _newtarget && canmove _newtarget && (_newtarget != _target || isNull (_target)) ) then {
				_timeontarget = 0;
				_targetdead = false;
				_flankdir= if (random 100 <= 10) then {0} else {_flankdir};	
				_target = _newtarget;			
			};						
		};		
	
	// use smoke when hit or s/o killed	
	if (!_nosmoke) then {
		{	
			//when hit
			if (_sowounded && random 100 < R_USE_SMOKE_wounded && _dist > (_closeenough/2)) then {
				nul = [_x,_target] spawn MON_throw_grenade;
				// if (KRON_UPS_Debug>0) then {player sidechat format["%1: We got wounded smoking!",_grpidx]}; 
			};
			
			//when die
			if (_sokilled && random 100 < R_USE_SMOKE_killed && _dist > (_closeenough/2)) then {
				nul = [_x,_target] spawn MON_throw_grenade;
				//if (KRON_UPS_Debug>0) then {player sidechat format["%1: We got killed one, smoking!",_grpidx]}; 
			};
		sleep 0.1;	
		} foreach _members;
	};
	
	
		
		//Gets  current known position of target and distance
		if ( !isNull (_target) && alive _target ) then {
			//Enemy detected
			if (_fightmode != "fight" ) then {
				_fightmode = "fight";
				_npc setCombatMode "RED";  // !R  // ToDo check impact of "YELLOW"
				_react = KRON_UPS_react;
				if (KRON_UPS_Debug>0) then {player sidechat format["%1: Enemy detected %2",_grpidx, typeof _target]}; 	
				
				if (_nowpType == 1) then {
					nul = [_npc] call R_FN_deleteObsoleteWaypoints;
					_nowp = false;
				};
			};	

		// If night and there no flare then launch flare
		
		
		If ( KRON_UPS_ARTILLERY 
			&& { !(isNull _target) } 
			&& { KRON_UPS_Night } 
			&& { !(FlareInTheAir) } 
			&& { !(_ambush) } 
			&& !_supressed
			&& { (call (compile format ["KRON_UPS_ARTILLERY_%1_FIRE",_side])) } 
		   ) then
		{
			_artillerysideunits = call (compile format ["KRON_UPS_ARTILLERY_%1_UNITS",_side]);
	
			If (count _artillerysideunits > 0 ) then 
			{
					_arti = _artillerysideunits select 0;

					if (KRON_UPS_Debug>0) then {player sidechat format ["Arti: %1",_arti];};
					[_arti,"FLARE",_target] spawn Aze_artilleryTarget;
			};
		};
			_newattackPos = _target getvariable ("UPSMON_lastknownpos");
			
			if ( !isnil "_newattackPos" ) then {
				_attackPos=_newattackPos;	
				//Gets distance to target known pos
				_dist = ([_currpos,_attackPos] call KRON_distancePosSqr);	
				//Looks at target known pos
				_members glanceAt _attackPos;	// lookat						 				
			};
		};

			//If use statics are enabled leader searches for static weapons near or fire artillery.
			// Tanks enemies are contabiliced
			
				_enemytanksnear = false;	
				{
					if ( ("Tank" countType [_x] > 0 || "Wheeled_APC" countType [_x] >0 
						|| "Tank" countType [vehicle _x] > 0 || "Wheeled_APC" countType [vehicle _x] >0 ) 
						&& alive _x && canMove _x && _npc distance _x <= _closeenough + KRON_UPS_safedist )
						exitwith { _enemytanksnear = true; _enemytanknear = _x;};																					
				} foreach _targets;
				
			if ( _enemytanksnear && { !(isnull _enemytanknear) } && { alive _enemytanknear } && !_supressed) then 
			{};
			
			if ( KRON_UPS_useMines && _Mines > 0 && !_supressed) then 
			{
				
				//If use mines are enabled and enemy armors near and no friendly armor put mine.
				if ( _enemytanksnear && { !(isnull _enemytanknear) } && { alive _enemytanknear } ) then 
				{
					_friendlytanksnear = false;
					{
						if (!( alive _x && canMove _x)) then {_friendlytanks = _friendlytanks - [_x]};
						if (alive _x && canMove _x && _npc distance _x <= _closeenough + KRON_UPS_safedist ) exitwith { _friendlytanksnear = true;}; 
					}foreach _friendlytanks;

					// if group has no AT weapon make them hide
					
					
					if (!_friendlytanksnear && random(100)<30 ) then 
					{
						_dir1 = [_currPos,position _enemytanknear] call KRON_getDirPos;
						_mineposition = [position _npc,_dir1, 25] call MON_GetPos2D;	
						_roads = _mineposition nearroads 50;
						if (count _roads > 0) then {_mineposition = position (_roads select 0);};
						if ([_npc,_mineposition] call MON_CreateMine) then 
						{
							_Mines = _Mines -1;
							if (KRON_UPS_Debug>0) then {player sidechat format["%1: %3 puting mine for %2",_grpidx,typeof _enemytanknear, side _npc]}; 									
						};													
					};				
				};
			};

			
		If (KRON_UPS_ARTILLERY 
			&& { _enemytanksnear } 
			&& { !(isnull _enemytanknear) }
			&& { alive _enemytanknear } 
			&& { !(_ambush) 
			&& !_supressed
			&& morale _npc > -0.5} 
		   ) then
		{	
			_artillerysideunits = call (compile format ["KRON_UPS_ARTILLERY_%1_UNITS",_side]);

			If (count _artillerysideunits > 0) then 
			{
				_arti = _artillerysideunits select 0;
				if (KRON_UPS_Debug>0) then {player sidechat format ["Arti: %1",_arti];};
				[_arti,"HE",_enemytanknear] spawn Aze_artilleryTarget;
			};
		};			

		// If the group is in inferiority call artillery
		_nbrTargets = count _targets;
		_nbrgrp = count units group _npc;
	
		If ( 
			KRON_UPS_ARTILLERY
			&& ( ((_nbrTargets * 1.5) > _nbrgrp)) 
			&& { morale _npc > -0.5 }
			&& { _gothit }
			&& { !(_ambush) } 
			&& !_supressed
			&& { (call (compile format ["KRON_UPS_ARTILLERY_%1_FIRE",_side])) } 
		   ) then
		{
		_artillerysideunits = call (compile format ["KRON_UPS_ARTILLERY_%1_UNITS",_side]);

			If (count _artillerysideunits > 0) then 
			{
					_targetarti = _targets select 0;
					_arti = _artillerysideunits select 0;
					if (KRON_UPS_Debug>0) then {player sidechat format ["Arti: %1",_arti];};
					[_arti,"HE",_targetarti] spawn Aze_artilleryTarget;
			};
		};	
		
		
		//If the enemy has moved away from the radio coverage is not a reinforcement sent we will have lost track
		if ( !isnull(_target) && { _dist < 15 } && { _fightmode != "walk" } && { _npc knowsabout _target < R_knowsAboutEnemy } ) then 
		{			
			//If squad is near last position and no target clear position of target
			if (KRON_UPS_Debug>0) then {player sidechat format["%1: Target lost",_grpidx]}; 				
			_fightmode="walk";
			_speedmode = _orgSpeed;			
			_target = objnull;
			_Behaviour = _orgMode;					
			_waiting = -1;	
			_unitpos = "Middle";			
			_pursue=false;
			_targetdead	= true;
			_makenewtarget = true; //Go back to the original position		
		};			
		
		//If knowledge of the target increases accelerate the reaction
		if (_opfknowval>_lastknown ) then 
		{
			_react = _react + 20;
		};	
		if (isnil "_react") then {_react = 60}; 
		// if spotted an enemy or got shot, so start pursuit, if in combat and exceed time to react or movecompleted
		if (!_ambushed && !_supressed && { (_fightmode != "walk") } && ((_react >= KRON_UPS_react && { _lastreact >=_minreact } ) || { moveToCompleted _npc } ) ) then 
		{			
			_pursue=true;
		};
		
		

//**********************************************************************************************************************
// 										END ACQUISITION OF TARGET 	
//**********************************************************************************************************************	

		
		//Ambush ==========================================================================================================
		if (_ambush && !_ambushed) then {
			_ambushed = true;
			_nowp = true;
			_currcycle = 2;		
			(group _npc) setFormation "LINE";
			(group _npc) setBehaviour "STEALTH";	// In stead of "AWERE" -> will make AI go prone and look for cover
			(group _npc) setSpeedMode "FULL";
			(group _npc) setCombatMode "BLUE";
			_vdir = []; // Ajout
			_npcdir= 0;
			sleep 10;
			_ambushdist = 100;
			
			{		
				_x setUnitPos "DOWN";			
				// _x stop true;
				dostop _x;
				_x disableAI "MOVE";
			} foreach units _npc;
			
			If (_ambushdir != "") then 
			{
				switch (_ambushdir) do {
					case "NORTH": {_vdir = [0,1,0];_npcdir = 0;};
					case "NORTHEAST":{_vdir = [0.842,0.788,0];_npcdir = 40;};
					case "EAST": {_vdir = [1,0,0];_npcdir = 90;};
					case "SOUTHEAST": {_vdir = [0.842,-0.788,0];_npcdir = 140;};
					case "SOUTH": {_vdir = [0,-1,0];_npcdir = 180;};
					case "SOUTHWEST": {_vdir = [-0.842,-0.788,0];_npcdir = 220;};
					case "WEST": {_vdir = [-1,0,0];_npcdir = 270;};
					case "NORTHWEST": {_vdir = [-0.842,0.788,0];_npcdir = 320;};
				};
			};	
			
			If ("gdtStratisforestpine" == surfaceType getPosATL player) then {_ambushdist = 75;};
			If ((count(nearestobjects [_npc,["house","building"],50]) > 5)) then {_ambushdist = 18;};
			
			if ("AMBUSHDIST:" in _UCthis) then {_ambusdist = ["AMBUSHDIST:",0,_UCthis] call KRON_UPSgetArg;}; // ajout
			
			//Puts a mine if near road
			if ( KRON_UPS_useMines && _ambushType == 1 ) then 
			{	
				
				if (KRON_UPS_Debug>0) then {player sidechat format["%1: Putting mine for ambush",_grpidx]}; 	
				if (KRON_UPS_Debug>0) then {diag_log format["UPSMON %1: Putting mine for ambush",_grpidx]}; 	
				_npc setBehaviour "careless";
				_dir1 = getDir _npc;
				If (_ambushdir != "") then {_dir1 = _npcdir;};
				sleep 1;
				_mineposition = [position _npc,_dir1, _ambushdist] call MON_GetPos2D;					
				//_mineposition = [position _npc,_dir1, (KRON_UPS_ambushdist)] call MON_GetPos2D;
				_roads = _mineposition nearRoads 10; // org value 40 - ToDo check KRON_UPS_ambushdist value
				If (count _roads > 0) then {_roads = _mineposition nearRoads 75;};
				
				_soldier = _npc;
				if ((count units _npc) > 1) then {_soldier = (units _npc) select 1;};
				
		if (KRON_UPS_Debug>0) then {player sidechat format["%1: Roads #:%2 Soldier:%3",_grpidx, (count _roads),_soldier]}; 
		if (KRON_UPS_Debug>0) then {diag_log format["%1: Roads #:%2 Soldier:%3",_grpidx, (count _roads),_soldier]}; 
				
				while {_Mines > 0} do
				{
					// waituntil {unitready _soldier};
					_i = 0;
					// if (KRON_UPS_Debug>0) then {player sidechat format["%1 Current Roads #:%2 _Mines:%3",_grpidx, (count _roads),_Mines]}; 
					if (count _roads > 0) then 
					{
						// _rnd = floor (random (count _roads));
						_rnd = _roads select 0;
						_mineposition = position (_rnd);
						_roads = _roads - [_rnd];
						// _mineposition = position (_roads select 0);
						if ([_soldier,_mineposition] call MON_CreateMine) then {_Mines = _Mines -1; _i = 1;};
					} 
					else 
					{
						_mineposition = [position _npc,_dir1, _ambushdist*2 + random 20] call MON_GetPos2D;				
						if (_Mines > 0 && [_soldier,_mineposition] call MON_CreateMine) then {_Mines = _Mines -1;};	
					
						_mineposition = [position _npc,_dir1, (_ambushdist*2) + random 20] call MON_GetPos2D;				
						if (_Mines > 0 && [_soldier,_mineposition] call MON_CreateMine) then {_Mines = _Mines -1;};			
					};

					if (KRON_UPS_Debug>0) then {diag_log format["UPSMON %1: mines left: [%2]",_grpidx, _Mines]};
					
					sleep 0.1;
					if (_i != 1) then {_Mines = _Mines -1;}; //in case no mine was set
					If (_gothit) exitwith {};
				};
				
				_npc setBehaviour "SAFE";			
				// sleep 30;		// ToDo check 10 or 20
				// (((expectedDestination _soldier) select 2) == "FORMATION PLANNED")
					waituntil {!(alive _soldier) || (_soldier distance _npc <=5) || !canstand _soldier};
					_soldier setUnitPos "DOWN";
				//{	
				//	if (!stopped _x) then {
				//		_x domove position _npc;
				//		waituntil {moveToCompleted _x || moveToFailed _x || !alive _x || !canmove _x || _x distance _npc <= 5};
				//	};
				//}foreach units _npc;
				
					if (KRON_UPS_Debug>0) then {hint format ["Dir NPC : %1",_vdir]};
			};				
		
	
			// did the leader die?					
			_npc = [_npc,_members] call MON_getleader;							
			if (!alive _npc || !canmove _npc || isplayer _npc ) exitwith {_exit=true;};		

			_npc setBehaviour "AWARE";
			// _grp setFormation (KRON_UPS_groupFormation select (floor random count KRON_UPS_groupFormation));
			// _grp setFormation "LINE"; // ToDo check impact
			If ((count(nearestobjects [_npc,["house","building"],50]) > 5)) then 
			{
			{_x enableAI "MOVE";} foreach units _npc;
			[_npc,50,false,9999,true] spawn MON_moveNearestBuildings;
			} 
			else 
			{
			[units group _npc,_vdir] spawn UPS_fnc_find_cover;
			_npc setBehaviour "STEALTH";
			};
			
			sleep 4;
			// {		
			//	[_x,"Auto"] spawn MON_setUnitPos;			
			//	sleep 0.5;
			//	_x stop true;	
				// _x setUnitPos "";	// ToDo check double set DOWN?				
			// }foreach units _npc;		

			(group _npc) setformdir _npcdir;
			_pursue = false;
		};	// end of ambush mine
		

		
	
		
		//Ambush enemy is nearly aproach
		//_ambushdist = 50;		
		// replaced _target by _NearestEnemy
		if (_ambush) then {
			// _prov = ((_ambushdist*2 - (_npc distance _NearestEnemy))*3) - 40;
			//if (KRON_UPS_Debug>0) then {player sidechat format["%1:%6 _ambushdist=%5 last=%2 dist=%3 prov=%4",_grpidx,_lastdist,_npc distance _target,_prov,_ambushdist,typeof _target]}; 			
			if ((_gothit  || _reinforcementsent || time > _ambushwait)
					||((!isNull (_NearestEnemy) && "Air" countType [_NearestEnemy]<=0) 
						&& ((_npc distance _NearestEnemy <= (_ambushdist*2))
						))
				) then { 
				
				sleep ((random 1) + 1); // let the enemy then get in the area 
				
				if (KRON_UPS_Debug>0) then {player sidechat format["%1: FIREEEEEEEEE!!!",_grpidx]};
				_nowp = false;		
				_ambush = false;
				_ambushed = false;
				_currcycle = _cycle;
				{
					// _x stop false;
					_x enableAI "MOVE";
					_x setUnitPos "Auto"; // ToDo check org value "Middle";					
				} foreach _members;
				_npc setBehaviour "COMBAT";
				_npc setCombatMode "RED";
								
				//No engage yet
				_pursue = false;
			};
			
			//Sets distance to target
			_lastdist = _npc distance _NearestEnemy;			
		}; 
		
		//END Ambush ==========================================================================================================
			
		//if (KRON_UPS_Debug>0) then {player sidechat format["%1: _nowp=%2 in vehicle=%3 _inheli=%4 _npc=%5",_grpidx,_nowp,vehicle (_npc) ,_inheli,typeof _npc ]}; 	
		
		//If in vehicle take driver if not controlled by user
		if (alive _npc && !_nowp) then 
		{
			if (!_isman || (vehicle (_npc) != _npc && !_inboat && !(vehicle (_npc) iskindof "StaticWeapon"))) then { 						
				
				//If new target is close enough getout vehicle (not heli)	
				_unitsin = [];

				if (!_inheli) then { 						
					if (_fightmode == "walk") then {
						_GetOutDist =  _area / 20;
					}else{
						If (vehicle _npc iskindof "TANK" || vehicle _npc iskindof "Wheeled_APC_F") then
						{
							_GetOutDist =  _closeenough  * ((random .4) + 0.6);
						}
						else
						{
							_GetOutDist =  _closenoughV  * ((random .4) + 0.6);
						};
					};
					 
					  // ToDo check if obsolete
					_lastcurposcheck = false;
					if (!isnil "_lastcurrpos") then {
						if (_lastcurrpos select 0 == _currpos select 0 && _lastcurrpos select 1 == _currpos select 1 && moveToFailed (vehicle (_npc))) then {
							_lastcurposcheck = true;
						};
					};
					//-------------------------
					
					
					
					//If near target or stuck getout of vehicle and lock or gothit exits inmediately

					if 
					( 
						_gothit 
						|| { _dist <= _closeenough * 1.5 }
						|| { ( 
								_lastcurrpos select 0 == _currpos select 0
								&& { _lastcurrpos select 1 == _currpos select 1 } 
								&& { moveToFailed (vehicle (_npc)) } 
							  ) } 
						|| { moveToCompleted (vehicle (_npc)) }
					) 
					then 
					{
						_GetOutDist = 2000; // 10000
					};
					//if (KRON_UPS_Debug>0) then {player sidechat format["%1: vehicle=%2 _npc=%3",_grpidx,vehicle (_npc) ,typeof _npc ]};
					
					_unitsin = [_npc] call R_FN_allUnitsInCargo; // return units in cargo in all vehs used by the group
					
					private ["_handle1"];
					_handle1 = [_npc,_targetpos,_GetOutDist] spawn R_SN_GetOutDist;	// getout if as close as _GetOutDist to the target
					_timeout = time + 10;	
					waitUntil {scriptDone _handle1 || time > _timeout};
							
				}
				else 
				{
					_GetOutDist = 0; 					
				};
				
				
				
				// if there was getout of the cargo
				if (count _unitsin > 0) then {					
					//if (KRON_UPS_Debug>0) then {player sidechat format["%1: Geting out of vehicle, dist=%2 atdist=%3 _area=%4",_grpidx,([_currpos,_targetpos] call KRON_distancePosSqr),_GetOutDist,_area]}; 											
					_timeout = time + 7;	
					{ 
						waituntil {vehicle _x == _x || !canmove _x || !alive _x || time > _timeout || movetofailed _x  }; 
					} foreach _unitsin;			
					
					
					// did the leader die?
					_npc = [_npc,_members] call MON_getleader;							
					if (!alive _npc || !canmove _npc || isplayer _npc ) exitwith {_exit=true;};	
					
					if (_fightmode == "fight" || _gothit) then {			
						_npc setBehaviour "COMBAT";		// AWARE																
						_groupOne = group _npc;
						_groupOne setFormation "DIAMOND";							
						nul = [_npc,30] spawn MON_move;													
					};
					
					sleep 0.2;
					// select leader outside of vehicle
					{
						if (alive _x && canmove _x) exitwith {group _x selectLeader _x; _npc = _x};
					} foreach _unitsin;
							
					
					
					if (_fightmode == "fight") then 
					{	
						_pursue = true;
					}
					else
					{						
						_pursue = false;	
						_makenewtarget=true;
					};						
				};	
			};									
		};	


		//If under attack or increasing knowledge speeds up the response and regain control of the AI
		if (_gothit) then 
		{ 
			_react = if (!_supressed) then {_react + 30};
			if (_fightmode != "walk") then 
			{
				if (_nowpType != 3) then 
				{
					nul = [_npc] call R_FN_deleteObsoleteWaypoints;
					_nowp = false; 
				};
			};
		};			
		if (isnil "_react") then {_react = 0}; 
		//If there is no objective order is canceled persecution
		if ((isNull (_target) || !alive _target )) then {
			_pursue=false;	
			
			if (_gothit && { !_fortify } && { !_nowp } && count _targets == 0) then 
			{ 
				if ((_fightmode == "walk")) then 
				{
					//It could be a sniper, better be alert and move in case			
					_Behaviour =  "COMBAT";	
					_speedmode = "FULL";	
					_unitpos = "DOWN";				
					_gothit = false;				
					_makenewtarget = true;
					_waiting = -1;
					if ((random 100 < 15) && !_nosmoke) then {	
						nul= [_npc,_target] spawn MON_throw_grenade;
					};					
					if (KRON_UPS_Debug>0) then {player sidechat format["%1: Have been damaged moving",_grpidx,_makenewtarget]}; 
				}
				else 
				{
					if ((count _targets <= 0 && { _react >= KRON_UPS_react } && { _lastreact >=_minreact } ) || _sowounded) then 
					{										
						//We shoot and we have no target, we move from position								
						if (KRON_UPS_Debug>0) then {diag_log format["UPSMON: group %1 Under fire by unknown target, moving to newpos",_grpidx]}; 
						//Covers the group with a smoke grenade
						if (!_supressed  && { !_nosmoke } && { (random 100 < 30) } ) then  // ToDo verify impact org value "100 < 80"
						{	
							nul= [_npc,_target] spawn MON_throw_grenade;
						};									
						_gothit = false; 
						_makenewtarget = true;		
						_waiting = -1;				
						_pause="NOWAIT";				
						_speedmode = "FULL";				
						_unitpos = "middle";		
						_Behaviour = "AWARE";							
					} 
					else 
					{				
						if (_lastreact >=_minreact && { !_targetdead } ) then 
						{
							_targetdead = true;
							_pursue = true;
							//We have run out of targets continue to search				
							if (KRON_UPS_Debug>0) then {player sidechat format["%1: Target defeated, searching",_grpidx]}; 						
						};	
					};					
				};
			};
		};		

		//If no fixed target check if current target is available
		if (format ["%1",_fixedtargetPos] != "[0,0]") then 
		{	
			//If fixed target check if close enough or near enemy and gothit
			if (([_currpos,_fixedtargetpos] call KRON_distancePosSqr) <= _closeenough || (_dist <= _closeenough && _gothit)) then 
			{		
				_fixedtargetPos = [0,0]; 
			} 
			else 
			{		
				_pursue = false;
				_attackPos=_fixedtargetPos;
				if (_react >= KRON_UPS_react && _lastreact >=_minreact) then 
				{
					_makenewtarget = true;
					_unitpos = "UP";
					_speed = "NORMAL";
				};				
			};
		};	
		
		
		
		
		
		//If captive or surrended do not pursue
		if ( isnil "_attackPos") then {_pursue = false;};
		if ( captive _target || format ["%1", _attackPos] == "[0,0]") then {_pursue = false;};
			
		//If no waypoint do not move
		if (_nowp) then 
		{
			_makenewtarget = false;
			_pursue = false;
		};	
		
		if (_inheli) then {
			_heli = vehicle _npc;  // ToDo check if this is indeed heli an not AI himself
			if (!isnil "_heli") then 
			{
				_landing = _heli getVariable "UPSMON_landing";
				if (isnil ("_landing")) then {_landing=false;};
				if (_landing) then {	
					_pursue = false;
				};
			};
		};		
		sleep 0.5;
		
// **********************************************************************************************************************
//   								PURSUE: CHASE BEGINS THE LENS
// **********************************************************************************************************************
		
		if (_pursue) then 
		{		
			if (KRON_UPS_Debug>0) then {diag_log format["UPSMON: Group %1 is in pursue",_grpidx]}; 
		
			_pursue = false;
			_newpos = true; 	
			_react = 0;		
			_lastreact = 0;
			_timeontarget = 0; 		
			_makenewtarget = false;			
			_fm = 1;
			//Cancel supress effect when reaction time
			_supressed = false;		

			// did the leader die?
			_npc = [_npc,_members] call MON_getleader;							
			if (!alive _npc || { !canmove _npc } || { isplayer _npc } ) exitwith {_exit=true;};				
		
			// get position of spotted unit in player group, and watch that spot
			_targetPos = _attackPos;		
			_targetX = _targetPos select 0; _targetY = _targetPos select 1;
			_currPos = getpos _npc;									

			 // also go into "combat mode"		
			_pause="NOWAIT";
			_waiting=0;			
			
			// angle from unit to target
			_dir1 = [_currPos,_targetPos] call KRON_getDirPos;
			//_npc dowatch [_targetPos select 0, _targetPos select 1, (_targetPos select 2) +1];
			//_dir1 = getdir _npc;
			// angle from target to unit (reverse direction)
			_dir2 = (_dir1+180) mod 360;
			
			if ( _dist > _closeenough/2) then {
				_result = [_npc,_dir2,_targetPos,_flankdir] call Aze_Flank;

				_targetPos = _result select 0;
				_targettext = _result select 1; 
				_flankdir =_result select 2;			
			};
			
			
			//Establish the type of waypoint
			//DESTROY has worse behavior with and sometimes do not move
			_wptype = "MOVE";					
			
			//Set speed and combat mode 
			(group _npc) enableAttack false; 
			_rnd = random 100;			
			if ( _dist <= _closeenough ) then {
				//If we are so close we prioritize discretion fire
				if ( _dist <= _closeenough/2 ) then {	
					//Close combat modeo
					_speedmode = "FULL";	
					_wpformation = "LINE";
					If (vehicle _npc != _npc) then {_wpformation = "VEE";};
					_unitpos = if (morale _npc < 0 && _gothit) then {"Down"} else {"Middle"};	 //"Middle" 
					_react = _react + KRON_UPS_react / 2;
					_minreact = KRON_UPS_minreact / 2;
					if ((_nomove == "NOMOVE") && !_reinforcementsent) then {		
						//Defensive combat						
						_Behaviour =  "COMBAT"; 
						_wptype = "HOLD";
						_npc setCombatMode "RED";
					} else {
						 // _rnd < 80
						if (morale _npc <= 0 && _gothit) then {           
							_Behaviour =  "COMBAT";
						} else {
							_Behaviour =  "STEALTH"; // ToDo check impact "STEALTH"; 
						};	
						_wptype = "SAD"; // MOVE
						_npc setCombatMode "RED";							
					};
					
				_targetPos = _attackPos;
				_targettext = "_attackPos"; 
				_flankdir =0;
				
				} else {
					//If the troop has the role of not moving tend to keep the position	
					_speedmode = "NORMAL";  
					_wpformation = "WEDGE"; //or WEDGE	// ToDo check if WEDGE should be prefered
					If (vehicle _npc != _npc) then {_wpformation = "VEE";};
					_unitpos = "Middle";	
					_minreact = KRON_UPS_minreact / 1.5;					
					if ((_nomove == "NOMOVE" && _rnd < 50) && !_reinforcementsent) then {		
						//Combate defensivo							
						_Behaviour =  "COMBAT"; 
						_wptype = "HOLD";						
					} else {
							// _rnd = 80
						if (morale _npc <= 0 && _gothit) then {
							_Behaviour =  "COMBAT";
						} else {
							_Behaviour =  "STEALTH";
						};	
						_wptype = "MOVE";
						_npc setCombatMode "YELLOW";
					};														
				};								
			} else	{	
				
				if (_dist <= (_closeenough + KRON_UPS_safedist)) then {
					_speedmode = "NORMAL";
					_wpformation = "WEDGE";							
					_unitpos = if (_rnd < 90) then {"UP"} else {"middle"};					
					_minreact = KRON_UPS_minreact;
					if ((_nomove=="NOMOVE" && _rnd < 75)  && !_reinforcementsent) then {
						//Combate defensivo
						_Behaviour =  "AWARE"; 	//AWARE
						_wptype = "HOLD";							
					} else {	
						//Movimiento con precauci�n (m�s r�pido)				
						_Behaviour =  "AWARE"; 		
						_wptype = "MOVE";
						_npc setCombatMode "YELLOW";
					};										
				} else {
					//In May distance of radio patrol act..
					if (( _dist <  KRON_UPS_sharedist )) then {
						//Platoon from the target must move fast and to the point
						_Behaviour =  "SAFE"; 
						_speedmode = "LIMITED";
						_unitpos = "UP";		
						_minreact = KRON_UPS_minreact * 2;										
						if ((_nomove=="NOMOVE" && _rnd < 95) && !_reinforcementsent) then {
							_wptype = "HOLD";						
							_wpformation = "DIAMOND";							
						} else {					
							_wptype = "MOVE";	
							_wpformation = "COLUMN";						
						};
					} else {
						//Platoon very far from the goal if not move nomove role
						_Behaviour =  "SAFE"; 
						_speedmode = "LIMITED";
						_unitpos = "UP";
						_minreact = KRON_UPS_minreact * 3;
						
						if (((_nomove=="NOMOVE") || (_nomove=="MOVE" && _rnd < 70)) && { !_reinforcementsent } ) then {
							_wptype = "HOLD";						
							_wpformation = "DIAMOND";
						}else{					
							_wptype = "MOVE";	
							_wpformation = "COLUMN";  //COLUMN						
						};						
					};
				};	
			};	


			
			// did the leader die?
			_npc = [_npc,_members] call MON_getleader;							
			if (!alive _npc || { !canmove _npc } || { isplayer _npc } ) exitwith {_exit=true;};	
		
			//If leader is in vehicle will move in  anyway
			if (vehicle _npc != _npc || { !_isman } ) then 
			{
				_wptype = "MOVE";
				_Behaviour =  "AWARE"; 
				if ( _inheli ) then {
					_speedmode = "FULL";	
					_unitpos = "UP"; 
					_targetPos = _AttackPos;
				};
			};			
		

		//Establecemos el target
			KRON_targetsPos set [_grpid,_targetPos];
			sleep 0.01;					
			
				
			//Si es unidad de refuerzo siempre acosar� al enemigo
			if (_reinforcementsent) then {
				_wptype="MOVE";
				_newpos=true; 
				_makenewtarget = false;
			};			
						
			if (_nofollow=="NOFOLLOW" && _wptype != "HOLD") then {

				_targetPos = [_targetPos,_centerpos,_rangeX,_rangeY,_areadir] call KRON_stayInside;
				_targetdist = [_currPos,_targetPos] call KRON_distancePosSqr;
				if ( _targetdist <= 3 ) then 
				{
					_wptype="HOLD";
				};
			};
			
			if (_wptype == "HOLD") then {
				_targetPos = _currPos;	_targettext ="_currPos";
			};			
			
			//Is updated with the latest value, changing the target
			_lastknown = _opfknowval; 
				
			//If for whatever reason cancels the new position should make clear the parameters that go into pursuit
			if  (!_newpos) then {
				//If the unit has decided to maintain position but is being attacked is being suppressed, should have the opportunity to react
				_newpos = _gothit;
				
				if  (!_newpos) then {
					_targetPos=_lastpos;
					if (KRON_UPS_Debug>0) then {player sidechat format["%1 Mantaining orders %2",_grpidx,_nomove]};	
				};
			};			
			if (KRON_UPS_Debug>=1) then {
				"avoid" setmarkerpos _avoidPos; "flank" setmarkerpos _flankPos; _destname setMarkerPos _targetPos;							
			};	
			
			//Always keep the brackets fortified position
			if (_fortify) then {_wptype = "HOLD"; _targetPos = [0,0,0]};
			
		};	//END PURSUE				
	sleep 0.1;
	}; //((_isSoldier) && ((count _enemies)>0)
	
	
// **********************************************************************************************************************
//   								NO NEWS
// **********************************************************************************************************************
	if !(_newpos) then {
		// did the leader die?
		_npc = [_npc,_members] call MON_getleader;							
		if (!alive _npc || !canmove _npc || isplayer _npc ) exitwith {_exit=true;};		
		
		// calculate new distance
		// if we're waiting at a waypoint, no calculating necessary	
		_currpos = getpos _npc;	
		
		
		
		//Sets behaviour of squad if nearly changes of target
		if (_targetsnear) then{
			if (( toUpper(_Behaviour) IN _safemode) && _isSoldier) then {				
				_Behaviour = "AWARE";
				_npc setBehaviour _Behaviour;	
			};						
		};	
		
		
		
		//If in safe mode if find dead bodies change behaviour
		if ((toUpper(_Behaviour) IN _safemode) && _deadBodiesReact)then {
			_unitsin = [_npc,_buildingdist] call MON_deadbodies;
			_firenear = [_npc] call Aze_checkfire;

			if (count _unitsin > 0 || _firenear) then { 
				if (!_isSoldier) then {
					_npc setSpeedMode "FULL";					
				} else {
					if (!_gothit) then {
						_Behaviour =  "AWARE";
					} else {
						_Behaviour =  "COMBAT";
					};	
					_react = _react + 30;
					_npc setBehaviour _Behaviour;
					if (KRON_UPS_Debug>0) then {player sidechat format["%1 dead bodies found! set %2",_grpidx,_Behaviour, count _targets]};	
				}; 
			};
		};
		
		if (isNil "_lastcurrpos") then
		{
			_lastcurrpos = [0,0];
		};
		
		//Stuck control
		if (!_nowp 
			&& { alive _npc } 
			&& { canmove _npc } 
			&& { _wptype == "MOVE" } 
			&& { _timeontarget >= 60 } 
			&& { _lastcurrpos select 0 == _currpos select 0 } 
			&& { _lastcurrpos select 1 == _currpos select 1 } 
			) then 
		{
			[_npc] call MON_cancelstop;	
			_makenewtarget = true;
			if (KRON_UPS_Debug>0) then {player sidechat format["%1 stucked, moving",_grpidx]};	
			if (KRON_UPS_Debug>0) then {diag_log format["%1 stuck for %2 seconds - trying to move again",_grpidx, _timeontarget]};	
		};
		
		_lastpos = _targetPos;
		_lastcurrpos = _currpos; //sets last currpos for avoiding stuk				
			
		if (_waiting<0) then {
			//Gets distance to targetpos
			_targetdist = [_currPos,_targetPos] call KRON_distancePosSqr;	
			
			//It assesses whether it has exceeded the maximum waiting time and the objective is already shot to return to the starting position.		
			if (_fightmode!="walk") then {
				if (_timeontarget > KRON_UPS_alerttime 
						&& { count _targets <= 0 } 
						&& { ( isNull (_target) || !alive (_target) || captive _target) } 
					) then 
				{
					_pursue = false;
					_gothit = false;
					_targetdead	= true;		
					_fightmode = "walk";
					_speedmode = _orgSpeed;						
					_targetPos = _currPos;
					_reinforcementsent = false;
					_target = objnull;
					_fixedtargetPos = [0,0];			
					_Behaviour = _orgMode;					
					_waiting = -1;	
					_unitpos = "UP";	
					_wpformation = "COLUMN";						

					KRON_UPS_reinforcement = false; //there is no threat
					if (_rfid > 0 ) then {
						call (compile format ["KRON_UPS_reinforcement%1 = false;",_rfid]);
					};
					
					{[_x,"AUTO"] spawn MON_setUnitPos;}	foreach units _npc;	
					_npc setBehaviour _orgMode;									
					
					if (KRON_UPS_Debug>0) then {player sidechat format["%1 Without objectives, leaving combat mode",_grpidx]};	
				};
			};	

			
			//if (KRON_UPS_Debug>0) then {player globalchat format["%1  _targetdist %2  atdist=%3 dist=%4",_grpidx, _targetdist, _area/8,_dist]};	
			// if not in combat and we're either close enough, seem to be stuck, or are getting damaged, so find a new target 
			if (!_nowp && (!_gothit) && (!_swimming) && (_fightmode == "walk") && (( _targetdist <= (_area/4) || moveToFailed _npc) && (_timeontarget > KRON_UPS_maxwaiting))) then {
				_makenewtarget=true;
				_unitpos = "UP";
				_Behaviour = _orgMode;
			};
			
			If (IsNull _Target && count _Targets <= 0 && !_gothit) then
			{
				_unitpos = "UP";
				_Behaviour = _orgMode;
			};

			// make new target
			if (_makenewtarget) then 
			{			
				_gothit = false;
				_react = 0;		
				_lastreact = 0;	
				_makenewtarget = false;				
				_timeontarget = 0;
				_wptype = "MOVE";
				
				if (format ["%1",_fixedtargetPos] !="[0,0]") then {	
					_targetPos = _fixedtargetPos; _targettext ="Reinforcement";					
				} else {				
					
					if ((_nomove=="NOMOVE") && (_timeontarget>KRON_UPS_alerttime)) then {
					if (KRON_UPS_Debug>0) then {player sidechat format["nomove: %1",_nomove]};	
						if (([_currPos,_orgPos] call KRON_distancePosSqr)<_closeenough) then {
							_newpos = false;
							_wptype = "HOLD";
							_waiting = 9999;
							if (_fortify) then {
								_minreact = KRON_UPS_minreact * 3;
								_buildingdist = _buildingdist * 2;
								_wait = 3000;								
							};							
						} else {
							_targetPos=_orgPos; _targettext ="_orgPos";
						};
					} 
					else 
					{						
						//rStuckControl !R					
						_rcurrPos = getpos _npc;
						if (_rlastPos select 0 == _rcurrPos select 0 && { _rlastPos select 1 == _rcurrPos select 1 } ) then 
						{
							if (KRON_UPS_Debug>0) then {player sidechat format["%1 !RstuckControl try to move",_grpidx]};						
							if (vehicle _npc != _npc) then 
							{
								_rstuckControl = _rstuckControl + 1;
								if (_rstuckControl > 1) then 
								{
									_jumpers = crew (vehicle _npc);
									{
										_x spawn MON_doGetOut;	
										sleep 0.5;
									} forEach _jumpers;
								} 
								else 
								{
									nul = [vehicle _npc, 25] spawn MON_domove;
								}
							}
							else 
							{
								nul = [_npc, 25] spawn MON_domove;
							};
						}
						else 
						{
							_rstuckControl = 0;
						};					
						_rlastPos = _rcurrPos;
						
						// re-read marker position/size
						_centerpos = getMarkerPos _areamarker; _centerX = abs(_centerpos select 0); _centerY = abs(_centerpos select 1);
						_centerpos = [_centerX,_centerY];
						_areasize = getMarkerSize _areamarker; _rangeX = _areasize select 0; _rangeY = _areasize select 1;
						_areadir = (markerDir _areamarker) * -1;
						
						// find a new target that's not too close to the current position
						_targetPos=_currPos; _targettext ="newTarget";
						_tries=0;
						
						while {((([_currPos,_targetPos] call KRON_distancePosSqr) < _mindist)) && (_tries<50)} do 
						{
							_tries=_tries+1;
							// generate new target position
							_targetPos = [_centerX,_centerY,_rangeX,_rangeY,_cosdir,_sindir,_areadir] call KRON_randomPos;

							_loop2=FALSE;
							// boat or plane
							// if (KRON_UPS_Debug>0) then {player sidechat format["%1, type: %2",_npc, typeOf _npc]}; sleep 4;
							// if (KRON_UPS_Debug>0) then {player sidechat format["%1 isplane",_isplane]}; sleep 4;
							if ((vehicle _npc iskindof "AIR") || _isboat || _isDiver) then 
							{
								// boat
								if (_isboat) then 
								{
									_tries2=0; 
									while {(!_loop2) && (_tries2 <50)} do 
									{
										_tries2=_tries2+1;
										_targetPosTemp = [_centerX,_centerY,_rangeX,_rangeY,_cosdir,_sindir,_areadir] call KRON_randomPos;
										if (surfaceIsWater _targetPosTemp) then {
											_targetPos = _targetPosTemp; 
											_loop2 = TRUE;
											// if (KRON_UPS_Debug>0) then {player sidechat format["%1 Boat just got new targetPos",_grpidx]};
											};
										sleep 0.05;
									};								
								// plane or diver
								} 
								else 
								{
									_targetPos = [_centerX,_centerY,_rangeX,_rangeY,_cosdir,_sindir,_areadir] call KRON_randomPos;
									// if (KRON_UPS_Debug>0) then {player sidechat format["%1 Plane just got new targetPos",_grpidx]};										
								};
							
							// man or car							
							} 							
							else 
							{ 
								// "_onroad"	
								if (_onroad || (vehicle _npc iskindof "LandVehicle")) then 
								{
									_tries2=0; 
									while {(!_loop2) && (_tries2 <100)} do {
										_tries2=_tries2+1;
										
										_targetPosTemp = [_centerX,_centerY,_rangeX,_rangeY,_cosdir,_sindir,_areadir] call KRON_randomPos;
										_roads = (_targetPosTemp nearRoads 50); 
										if ((count _roads) > 0) then {
											_targetPosTemp = getpos (_roads select 0);
											_targetPos = _targetPosTemp;
											_loop2 = TRUE;
										// if (KRON_UPS_Debug>0) then {player sidechat format["%1 Onroad just got new targetPos",_grpidx]};	
										};	
										sleep 0.05;	
									};	
								// any place on ground
								}
								else 
								{								
									_tries2=0; 
									while {(!_loop2) && (_tries2 <100)} do 
									{
										_tries2=_tries2+1;
										_targetPosTemp = [_centerX,_centerY,_rangeX,_rangeY,_cosdir,_sindir,_areadir] call KRON_randomPos;
										if (!surfaceIsWater _targetPosTemp) then 
										{
											_targetPos = _targetPosTemp; 
											_loop2 = TRUE;																			
											if (KRON_UPS_Debug>0) then {diag_log format["UPSMON: %1 Man just got new TP %2, %3",_grpidx,_targetPos,_tries2]};											
										};
										sleep 0.05;	
									};								
								};
							};
						};						
					};
				};
				sleep 0.05;

				
				// distance to target position		
				_avoidPos = [0,0]; _flankPos = [0,0]; _attackPos = [0,0];	_frontPos = [0,0];			
				_fm=0;				
				_newpos=true;								
			};
		};			
	};	

	// if in water, get right back out of it again
	if (surfaceIsWater _currPos) then 
	{
		if (_isman && { !_swimming } && { !_isDiver } ) then 
		{
			_drydist=999;
			// look around, to find a dry spot
			for [{_a=0}, {_a<=270}, {_a=_a+90}] do 
			{
				_dp=[_currPos,30,_a] call KRON_relPos; 
				if !(surfaceIsWater _dp) then {_targetPos=_dp};				
			};
			_newpos=true; 
			_swimming=true;
		};
	}
	else 
	{
		_swimming=false;
	};

	sleep 0.5;


// **********************************************************************************************************************
//   								NEWPOS:	SE	EJECUTA		LA	ORDEN 	DE 	MOVIMIENTO
// **********************************************************************************************************************
//	if (KRON_UPS_Debug>0) then {player sidechat format["%1 rea=%2 wai=%3 tim=%4 tg=%5 %6",_grpidx,_react,_waiting,_timeontarget,typeof _target,alive _target]};							

	if ((_waiting<=0) && { _newpos }) then 
	{		
			// did the leader die?			
		_npc = [_npc,_members] call MON_getleader;									
		if (!alive _npc || { !canmove _npc } || { isplayer _npc } ) exitwith {_exit=true;};	
		
		_currPos = getpos _npc;		
		_newpos = false;
		_waiting = -1; 	
		_swimming=false;			
		_GetIn_NearestVehicles = false;	
		
		//Gets distance to targetpos
		_targetdist = [_currPos,_targetPos] call KRON_distancePosSqr;		
	
		//If gothit and not in vehicle
		if (_gothit && { _npc == vehicle (_npc) } && { alive _npc } ) then 
		{	
			If (_tpwcas_running) then {
			_Supstate = [_npc] call Aze_supstatestatus;
			If (_Supstate == 3) then {_supressed = true} else {_supressed = false};
			} else {If (_Supstate) then {_supressed = true} else {_supressed = false};};
			
			
			//Unidad suprimida		
			if ((_supressed || morale _npc < -0.7) && _wptype != "HOLD") then
			{				
				if (KRON_UPS_Debug>0) then {diag_log format["UPSMON: gothit: group %1 supressed by fire",_grpidx]};											
				
				//The unit is deleted, delete the current waypoint						
				_targetPos = _currPos;	
				_targettext ="SUPRESSED";
				_wptype = "HOLD";
			
				//Prone
				{
					//Motion vanishes
					if ( _x iskindof "Man" && { canmove _x } && { alive _x } ) then 
					{																		
						if ( (random 100)<40 || (primaryWeapon _x ) in KRON_UPS_MG_WEAPONS ) then 
						{
							[_x,"Down",20] spawn MON_setUnitPosTime;			
						}
						else
						{
							[_x,"AUTO"] spawn MON_setUnitPos;
						};												
					};
					//sleep 0.01;
				} foreach units _npc;
				};
												
				//All Retreat!!
				// ((random 100)<=60 && { morale _npc < 0 } )
				If ( 
					KRON_UPS_RETREAT 
					&& ((random 100)<= _retreat)
					&& (morale _npc < -0.8)
					&& !_supressed 
				   ) then
				{
				
					// angle from unit to target
					_dir1 = [_currPos,_targetPos] call KRON_getDirPos;
					// angle from target to unit (reverse direction)
					_dir2 = (_dir1+180) mod 360;
					
					_result = [_npc,_dir2,_attackPos] call Aze_Retreat;

					_targetPos = _result select 0;
					_targettext = _result select 1; 
					_flankdir = 0;
					
					_artillerysideunits = call (compile format ["KRON_UPS_ARTILLERY_%1_UNITS",_side]);

					If (KRON_UPS_ARTILLERY && (call (compile format ["KRON_UPS_ARTILLERY_%1_FIRE",_side])) && count _artillerysideunits > 0) then 
					{
						_arti = _artillerysideunits select 0;
						if (KRON_UPS_Debug>0) then {player sidechat format ["Arti: %1",_arti];};
						[_arti,"WP",_target,_npc] spawn Aze_artilleryTarget;
					};
				
				
					//{_x setbehaviour "CARELESS"; _x allowfleeing 1;} foreach units group _npc; => diabled while too many AI fleeing
					// New Code:
					If (_npc distance _target >= 200) then 
					{
						{
							_x setbehaviour "CARELESS"; 
							_x allowfleeing 1;
						} foreach units group _npc;
					} 
					else 
					{
						{
							_x setbehaviour "AWARE"; 
							_x allowfleeing 1;
						} foreach units group _npc;
					};
					// end new code
					
					if (!_newpos && KRON_UPS_Debug>0) then {player sidechat format["%1 All Retreat!!!",_grpidx]};						
				};
			 
			if ((random 100) < 15 && { _targettext == "_avoidPos" } && { !_nosmoke } ) then 
			{	
				[_npc,_target] call MON_throw_grenade;
			};
			sleep 0.5;				
		};
				
		// did the leader die?
		_npc = [_npc,_members] call MON_getleader;	
		if (!alive _npc || { !canmove _npc } || { isplayer _npc } ) exitwith {_exit=true;};	
		
		//If you have not been removed progress continue
		if (alive _npc) then 
		{
			_currPos = getpos _npc;
			
			if ( _wptype == "MOVE") then 
			{
				//Try to avoid stucked soldiers out of vehicles
				if ( _npc == vehicle _npc) then {
					{
						if (alive _x && canmove _x) then {
							//[_x] spawn MON_cancelstop;
							[_x] dofollow _npc;
						};
					} foreach _members;
				};
				//sleep 0.05;	
				
				if (KRON_UPS_Debug>0) then {diag_log format["UPSMON - group %1 looking for vehicles: [%2] - [%3] - [%4] - [%5] - [%6]",_grpidx, _dist, !_gothit,( _targetdist >= ( KRON_UPS_searchVehicledist )), _isSoldier,!_noveh]};		
				
				
				//Search for vehicle			
				if ((!_gothit 
				&& ( _targetdist >= ( KRON_UPS_searchVehicledist ))) 
				&& _isSoldier 
				&& !_noveh) then 
				{							
					if ( ( vehicle _npc == _npc ) && ( _dist > _closeenough ) ) then 
					{						
						_unitsIn = [_grpid,_npc] call MON_GetIn_NearestVehicles;		
					
						if (KRON_UPS_Debug>0) then {diag_log format["UPSMON - group %1 looking for vehicles to travel %2 m - unitsIn: [%3]",_grpidx, _dist, count _unitsIn]};					
						
						if ( count _unitsIn > 0) then 
						{	
							_GetIn_NearestVehicles = true;
							_speedmode = "FULL";	
							_unitpos = "AUTO";	
							_npc setbehaviour "SAFE";
							_npc setspeedmode "FULL";
							_timeout = time + 60;
							
							_vehicle = objnull;
							_vehicles = [];
							{ 
								waitUntil { (vehicle _x != _x) || { time > _timeout } || { moveToFailed _x } || { !canMove _x } || { !canStand _x } || { !alive _x } }; 
								
								if ( vehicle _x != _x && (isnull _vehicle || _vehicle != vehicle _x)) then 
								{
									_vehicle = vehicle _x ;
									_vehicles = _vehicles + [_vehicle]
								};								
							} foreach _unitsIn;
							//sleep 1;							
							
							{
								_vehicle = _x;
								_cargo = _vehicle getVariable ("UPSMON_cargo");
								if ( isNil("_cargo")) then {_cargo = [];};	
								_cargo orderGetIn true;
								
								//Wait for other groups to getin								
								{ 
									waituntil { (vehicle _x != _x) || { time > _timeout } || { movetofailed _x } || { !canmove _x } || { !canstand _x } || { !alive _x } }; 
								} foreach _cargo;	
								
								//Starts gunner control
								nul = [_vehicle] spawn MON_Gunnercontrol;
								sleep 0.1;
								// nul = [_x,30] spawn MON_domove; //!R just little kick to make sure it moves
							} foreach _vehicles;
							
							//Checks if leader has dead in the mean time
							_npc = [_npc,_members] call MON_getleader;							
							if (!alive _npc || { !canmove _npc } ) exitwith {_exit=true;};	

							
							if ( "Air" countType [vehicle (_npc)]>0) then 
							{											
								_rnd = (random 2) * 0.1;
								_flyInHeight = round(KRON_UPS_flyInHeight * (0.9 + _rnd));
								vehicle _npc flyInHeight _flyInHeight;
								
								//If you just enter the helicopter landing site is defined
								if (_GetIn_NearestVehicles) then { 
									_GetOutDist = round(((KRON_UPS_paradropdist )  * (random 100) / 100 ) + 150);
									
									[vehicle _npc, _TargetPos, _GetOutDist, 90] spawn MON_doParadrop; // org _flyInHeight shay_gman changed from MON_doParadrop to MON_landHely
									sleep 1;
									//Execute control stuck for helys
									[vehicle _npc] spawn MON_HeliStuckcontrol;
									if (KRON_UPS_Debug>0 ) then {player sidechat format["%1: flyingheiht=%2 paradrop at dist=%3",_grpidx, _flyInHeight, _GetOutDist,_rnd]}; 
								};				
							};							
						};					
					};
				};
			};	
			sleep 0.05;	

			
			//Get in combat vehicles
			if (_isSoldier 
			&& (!_GetIn_NearestVehicles ) 
			&& ( _fightmode != "walk" ) 
			&& !_noveh2) then 
			{					
				_dist2 = _dist / 4;
				if ( _dist2 <= 100 || !_gothit) then {
					_unitsIn = [];					
					_unitsIn = [_grpid,_npc,_dist2,false] call MON_GetIn_NearestCombat;	
					_timeout = time + (_dist2/2);
				
					if ( count _unitsIn > 0) then {							
						if (KRON_UPS_Debug>0 ) then {player sidechat format["%1: Geting in combat vehicle targetdist=%2",_grpidx,_npc distance _target]}; 																						
						_npc setbehaviour "SAFE";
						_npc setspeedmode "FULL";						
						
						{ 
							waituntil {vehicle _x != _x || !canmove _x || !canstand _x || !alive _x || time > _timeout || movetofailed _x}; 
						}foreach _unitsIn;
						
						// did the leader die?
						_npc = [_npc,_members] call MON_getleader;							
						if (!alive _npc || !canmove _npc || isplayer _npc ) exitwith {_exit=true;};								
						
						//Return to combat mode
						_npc setbehaviour _Behaviour;
						_npc setformation "COLUMN";
						_timeout = time + 150;
						{ 
							waituntil {vehicle _x != _x || !canmove _x || !alive _x || time > _timeout || movetofailed _x}; 
						}foreach _unitsIn;
						
						{								
							if ( vehicle _x  iskindof "Air") then {
								//moving hely for avoiding stuck
								if (driver vehicle _x == _x) then {
									_vehicle = vehicle (_x);									
									nul = [_vehicle,1000] spawn MON_domove;	
									//Execute control stuck for helys
									[_vehicle] spawn MON_HeliStuckcontrol;
									if (KRON_UPS_Debug>0 ) then {diag_log format["UPSMON %1: Getting in combat vehicle - distance: %2 m",_grpidx,_npc distance _target]}; 	
								};									
							};
							
							if (driver vehicle _x == _x) then {
								//Starts gunner control
								nul = [vehicle _x] spawn MON_Gunnercontrol;								
							};
						sleep 0.01;
						} foreach _unitsIn;									
					};	
					
				};
			};
			
			
			
			sleep 0.05;
			// did the leader die?
			_npc = [_npc,_members] call MON_getleader;							
			if (!alive _npc || !canmove _npc || isplayer _npc ) exitwith {_exit=true;};		
			
			//If use statics are enabled leader searches for static weapons near.
			if ((KRON_UPS_useStatics && { (vehicle _npc == _npc) } && { !_GetIn_NearestVehicles } && { _isSoldier } ) && { ((_wptype == "HOLD" && (random 100) < 80) || (_wptype != "HOLD" && (random 100) < 40)) } ) then 
			{
				 _unitsIn = [_grpid,_npc,_buildingdist] call MON_GetIn_NearestStatic;			
				
				if ( count _unitsIn > 0) then {									
					_npc setbehaviour "SAFE";
					_npc setspeedmode "FULL";					
					_timeout = time + 60;
					
					{ 
						waituntil {vehicle _x != _x || { time > _timeout } || { movetofailed _x } || { !canmove _x } || { !alive _x } }; 
					} foreach _unitsIn;
					
				};
				sleep 0.05;
			};		
			// did the leader die?
			_npc = [_npc,_members] call MON_getleader;							
			if (!alive _npc || !canmove _npc || isplayer _npc ) exitwith {_exit=true;};		
			
			//Check for Static weapon
			If (_fortify 
			&& (_gothit)
			&& vehicle _npc == _npc
			&& _wptype == "HOLD" 
			&& morale _npc >= -0.5) then
			{
			_unitsIn = [_grpid,_npc,150] call MON_GetIn_NearestStatic;
			if ( count _unitsIn > 0 ) then { sleep 10};
			};
			
			//Buildings usage.
			if (!_GetIn_NearestVehicles) then {
			
				if ( _wptype == "HOLD" 
				&& vehicle _npc == _npc 
				&& _fortify
				&& morale _npc < -0.6) then 
				{	
					_bldnpc = [];
					_bldnpc = nearestobjects [_npc,["house","building"], 7];
					if (count _bldnpc > 0) then {
					_bldnpc = _bldnpc select 0;
					If (damage _bldnpc > 0.7) then 
					{
						//_nowp = false;
						if (!isNil "tpwcas_running") then {{_x setvariable ["tpwcas_cover", 0];} foreach units group _npc;};
						if (KRON_UPS_Debug>0) then {player sidechat format["%1: Moving to nearest buildings",_grpidx]};						
						// [_npc,_buildingdist,false,_wait,true] spawn MON_moveNearestBuildings;
					};
					};
				} else {				
					//If we are close enough patrol in buildings for searching enemies
					if (_wptype != "HOLD" 
					&& vehicle _npc == _npc 
					&& ((random 100) < 90)
					&& _npc == vehicle _npc) then 
					{
						if (isNull _target && _dist <= (_closeenough) && _gothit) then 
						{
							[_npc,_buildingdist,true,70,false] spawn MON_moveNearestBuildings;
						};
						If (!isNull _target && ([_target] call Aze_Inbuilding) && _npc distance _target <= 150 && morale _npc > -0.6 && !_supressed) then 
						{
							_bldtarget = nearestobjects [_target,["house","building"], 7];
							_bldtarget = _bldtarget select 0;	
							_bldpostarget = [_bldtarget, 15] call BIS_fnc_buildingPositions;
							
							_cntobjs1 = floor ((count units _npc) /2);
							If (_cntobjs1 >=3) then {
							_attacksquad = [];
							{							
								if (_x iskindof "Man" && _x == _npc && unitReady _x && canmove _x && alive _x && vehicle _x == _x && _i < _cntobjs1) then
								{
								_attacksquad = _attacksquad + [_x];
								_i = _i + 1;						
								};
							} foreach  units _npc;	
			
							{
							[_x,_bldtarget,_bldpostarget] spawn MON_patrolBuilding;
							} foreach _attacksquad;
							
							{Dostop _x; _x Dowatch _bldtarget; _x suppressfor 15;} foreach ((units _npc) - [_attacksquad]);
							
							(group _npc) enableAttack true;
							};
						};
						if (morale _npc < -0.6 && morale _npc > -0.8 && (behaviour _npc == "AWARE" || behaviour _npc == "COMBAT")) then 
						{
							[_npc,25,false,500,true] spawn MON_moveNearestBuildings;
						};						
					};		
				};
				sleep 0.05;	
				
				
			};			
			
			// did the leader die?
			_npc = [_npc,_members] call MON_getleader;							
			if (!alive _npc || !canmove _npc || isplayer _npc ) exitwith {_exit=true;};			
		
			if (isnull _grp || _grp != group _npc) then {
				_grp = group _npc;
			};			
							
			
			_index = currentWaypoint _grp;	
			
			//If the waypoing is different than it has or is different from what we set hold
			IF (_wptype != "HOLD" || _lastwptype != _wptype) then {														
				//Has not completed or are waypoints
				//_index = 1 Waypoint by default, not use.	
				if ( _index == 1 || _index > count waypoints _grp && !isnull _grp) then {		
					_wp = _grp addWaypoint [_targetPos, 0];									
					_index = _wp select 1;															
					// if (KRON_UPS_Debug>0) then {player sidechat format["%1: created wp %2 index %3",_grpidx,_wp, _index]}; 						
				} else {					
					_wp = [_grp,_index];
					// if (KRON_UPS_Debug>0) then {player globalchat format["%1: not created wp %2 index %3 %4",_grpidx,_wp, _index,_targetPos]}; 
				};				
			};				
			
			// _wp = [_grp,_index];
			
			
			
			// if iscar the run fast if targetpost is far.
			if ((!_gothit && _targetdist >= (_closeenough * 1.5)) && (vehicle _npc != _npc)) then {
					_speedmode = "FULL";
				//} else { 
					// _speedmode = _orgSpeed;																		
				};
			
			
			
			//We define the parameters of the new waypoint				
			_wp  setWaypointType _wptype;						
			_wp  setWaypointPosition [_targetPos, 0];					
			_wp  setWaypointFormation _wpformation;		
			_wp  setWaypointSpeed _speedmode;	
			_lastwptype = _wptype;						 				
			
			 
			
				//If you have more than 1 waypoints delete the obsolete		
				{	
					if ( _x select 1 < _index ) then {
						deleteWaypoint _x;
					};					
				sleep 0.05;
				} foreach waypoints _grp;		
			
							
			//if (KRON_UPS_Debug>0) then {diag_log format["%1: waypoints %2 %3 %4 %5",_grpidx,count waypoints _grp, _grp, group _npc, group (leader _npc)]}; 											
			
			//Sets behaviour
			if (toupper(behaviour _npc) != toupper (_Behaviour)) then {
				_npc setBehaviour _Behaviour;	
			};						
			
			//Refresh position vector
			KRON_targetsPos set [_grpid,_targetPos];								
		
			//Although there are predefined type of movement to a small percentage will vary on an individual level
			//{
			//	if ((random 100)<95 
			//	&& _x == vehicle _x 
			//	&& _x iskindof "Man" 
			//	&& !((primaryWeapon _x ) in KRON_UPS_MG_WEAPONS)) then 
			//	{
			//		nul = [_x,_unitpos] spawn MON_setUnitPos;
			//	}else{
			//		nul = [_x,"AUTO"] spawn MON_setUnitPos;
			//	};
			//} foreach units _npc;	

			
			//If closeenough will leave some soldiers doing supress fire
			if (!(vehicle _npc iskindof "LandVehicle") && !_inheli && !_inboat && _dist <= _closeenough && morale _npc > -0.7) then {
				
				
				{
				if (!canStand _x || ((primaryWeapon _x ) in KRON_UPS_MG_WEAPONS) || (vehicle _x == _x && _x iskindof "Man" && (random 100) < 50))  then {					
				dostop _x; 
				_x suppressFor 15;
				};		
				} forEach units group _npc;
				(group _npc) enableAttack true;
				
			//if (_fortify) then {
				//{
				//if (!canStand _x  || vehicle _x == _x && _x iskindof "Man" && !_supressed)  then {					
				//_x setunitpos "Middle";
				//dostop _x; 
				//_x suppressFor 15;
				//};		
				//} forEach units group _npc;
			//};
													
			};
			
			if ((vehicle _npc iskindof "LandVehicle") && !_inheli && !_inboat && _dist <= _closeenough) then {
		
				Dostop vehicle _npc;
				vehicle _npc suppressFor 15;
				(group _npc) enableAttack true;
			};
			
		};
	
		_gothit = false;	
		
		
		//if (KRON_UPS_Debug>0) then {player sidechat format["%1: %2 %3 %4 %5 %6 %7 %8 %9 %10",_grpidx, _wptype, _targettext,_dist, _speedmode, _unitpos, _Behaviour, _wpformation,_fightmode,count waypoints _grp];};											
	};

	if (_track=="TRACK") then { 
		switch (_fm) do {
			case 1: 
				{_destname setmarkerSize [.4,.4]};
			case 2: 
				{_destname setmarkerSize [.6,.6]};
			default
				{_destname setmarkerSize [.5,.5]};
		};
		_destname setMarkerPos _targetPos;				

	};
	
	
	
	
	//If in hely calculations must done faster
	if (_isplane || _inheli) then {
		_currcycle = _cycle/2;
		_flyInHeight = KRON_UPS_flyInHeight;
		vehicle _npc flyInHeight _flyInHeight;					
				
	};

	if ((_exit) || (isNil("_npc"))) then 
	{
		_loop=false;
	} 
	else 
	{
		// slowly increase the cycle duration after an incident
		sleep _currcycle;
	};	
	
}; //while {_loop}


		if (KRON_UPS_Debug>0) then {hint format["%1 exiting mainloop",_grpidx]};	

		//Limpiamos variables globales de este grupo
		KRON_targetsPos set [_grpid,[0,0]];
		// KRON_NPCs set [_grpid,objnull];
		KRON_UPS_Exited=KRON_UPS_Exited+1;

		if (_track=="TRACK") then {
			//_trackername setMarkerType "Dot";
			_trackername setMarkerType "Empty";
			_destname setMarkerType "Empty";
		};

		//Gets dist from orinal pos
		if (!isnull _target) then {
			_dist = ([_orgpos,position _target] call KRON_distancePosSqr);	
		};
		// if (KRON_UPS_Debug>0) then {player sidechat format["%1 _dist=%2 _closeenough=%3",_grpidx,_dist,_closeenough]};	

		//does respawn of group =====================================================================================================
		if (_respawn && _respawnmax > 0 &&  !_surrended  && _dist > _closeenough) then {
			if (KRON_UPS_Debug>0) then {player sidechat format["%1 doing respawn",_grpidx]};	

			// copy group leader
			_unittype = _membertypes select 0;

			// make the clones civilians
			// use random Civilian models for single unit groups
			if ((_unittype=="Civilian") && (count _members==1)) then {_rnd=1+round(random 20); if (_rnd>1) then {_unittype=format["Civilian%1",_rnd]}};
			
			_grp=createGroup _side;
			_lead = _grp createUnit [_unittype, _orgpos, [], 0, "form"];
			[[netid _lead, _initstr], "KRON_fnc_setVehicleInit", true, true] spawn BIS_fnc_MP;
			[_lead] join _grp;
			_grp selectLeader _lead;
				
			// copy team members (skip the leader)
			_i=0;
			{
				_i=_i+1;
				if (_i>1) then {
					_newunit = _grp createUnit [_x, _orgpos, [],0,"form"];
					[[netid _newunit, _initstr], "KRON_fnc_setVehicleInit", true, true] spawn BIS_fnc_MP;
					[_newunit] join _grp;
					sleep 0.1;
				};
			} foreach _membertypes;
			
			
			if ( _lead == vehicle _lead) then {
					{
						if (alive _x && canmove _x) then {
							[_x] dofollow _lead;
						};
					sleep 0.1;
					} foreach units _lead;
			};
			
			{				
				_targetpos = _orgpos findEmptyPosition [10, 200];
				sleep .4;
				if (count _targetpos <= 0) then {_targetpos = _orgpos};
				//if (KRON_UPS_Debug>0) then {player globalchat format["%1 create vehicle _newpos %2 ",_x,_targetpos]};	
				_newunit = _x createvehicle (_targetpos);											
			} foreach _vehicletypes;		
			
			
			//if (KRON_UPS_Debug>0) then {player globalchat format["%1 _vehicletypes: %2",_grpidx, _vehicletypes]};
	
			//Set new parameters
			if (!_spawned) then { 
				
				_UCthis = _UCthis + ["SPAWNED"]; 		
			
				if ((count _vehicletypes) > 0) then {
						_UCthis = _UCthis + ["VEHTYPE:"] + ["dummyveh"];	
				};
			};	
				
			
			_UCthis set [0,_lead];
			_respawnmax = _respawnmax - 1;
			_UCthis =  ["RESPAWN:",_respawnmax,_UCthis] call KRON_UPSsetArg;
			sleep 0.1;
			_UCthis =  ["VEHTYPE:",_vehicletypes,_UCthis] call KRON_UPSsetArg;
			
			
			// if (KRON_UPS_Debug>0) then {player globalchat format["%1 _UCthis: %2",_grpidx,_UCthis]};	
			//Exec UPSMON script			
			_UCthis SPAWN UPSMON;
			sleep 0.1;
		};	

		_friends=nil;
		_enemies=nil;
		_enemytanks = nil;
		_friendlytanks = nil;
		_roads = nil;
		_targets = nil;
		_members = nil;
		_membertypes = nil;
		_UCthis = nil;

		if (!alive _npc) then {
			deleteGroup _grp;
		};