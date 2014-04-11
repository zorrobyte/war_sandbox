//DAC Zone Setup
diag_log "waiting for not nil DAC_NewZone";
waitUntil {!isNil "DAC_NewZone"};
waituntil{DAC_NewZone == 0};
_id = 9;
_id = _id + 1;
/*
daczones = [];
{
diag_log "waiting for DAC_NewZone == 0";
waituntil{DAC_NewZone == 0};
_name = format ["z%1",round random 500000];
   [(getMarkerPos _x),200,200,0,0,[(_name),[_id,1,0],[5,2,15,10],[],[],[],[0,0,0,0]]] call DAC_fNewZone;
daczones set [count daczones,_name];
diag_log daczones;
   } foreach ztowns;
*/
daczonem = [];
{
diag_log "waiting for DAC_NewZone == 0";
waituntil{DAC_NewZone == 0};
_name = format ["z%1",round random 500000];
_id = format ["%1",round random 500000];
   [(getMarkerPos _x),500,500,0,0,[(_name),[_id,0,0],[5,2,0,0],[],[],[],[0,0,0,0]]] call DAC_fNewZone;
daczonem set [count daczonem,_name];
diag_log daczonem;
   } foreach ztownm;
   
daczonel = [];
{
diag_log "waiting for DAC_NewZone == 0";
waituntil{DAC_NewZone == 0};
_name = format ["z%1",round random 500000];
_id = format ["%1",round random 500000];
   [(getMarkerPos _x),700,700,0,0,[(_name),[_id,0,0],[5,2,0,0],[5,2,0,0],[5,2,0,0],[1,1,50,0,100,10],[0,0,0,0]]] call DAC_fNewZone;
daczonel set [count daczonel,_name];
diag_log daczonel;
   } foreach ztownl;
   
 /*
   waituntil{DAC_NewZone == 0};
  _f1 = format ["z%1",round random 500]; 
   [(position _x),250,150,0,0,[_f1,[1,0,0],[5,2,50,10],[],[],[],[1,1,1,1]]] call DAC_fNewZone
   
   */