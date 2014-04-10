
_HQ = _this select 0;

_HQ setVariable ["leaderHQ",(leader _HQ)];

_HQ setVariable ["RydHQ_Cyclecount",0];
_cycleC = 0;

if (isNil ("RydHQD_MAtt")) then {RydHQD_MAtt = false};
_HQ setVariable ["RydHQ_MAtt",RydHQD_MAtt];
if ((isNil ("RydHQD_Personality")) or not (_HQ getVariable ["RydHQ_MAtt",false])) then {RydHQD_Personality = "OTHER"};
_HQ setVariable ["RydHQ_Personality",RydHQD_Personality];

if (isNil ("RydHQD_Recklessness")) then {RydHQD_Recklessness = 0.5};
_HQ setVariable ["RydHQ_Recklessness",RydHQD_Recklessness];
if (isNil ("RydHQD_Consistency")) then {RydHQD_Consistency = 0.5};
_HQ setVariable ["RydHQ_Consistency",RydHQD_Consistency];
if (isNil ("RydHQD_Activity")) then {RydHQD_Activity = 0.5};
_HQ setVariable ["RydHQ_Activity",RydHQD_Activity];
if (isNil ("RydHQD_Reflex")) then {RydHQD_Reflex = 0.5};
_HQ setVariable ["RydHQ_Reflex",RydHQD_Reflex];
if (isNil ("RydHQD_Circumspection")) then {RydHQD_Circumspection = 0.5};
_HQ setVariable ["RydHQ_Circumspection",RydHQD_Circumspection];
if (isNil ("RydHQD_Fineness")) then {RydHQD_Fineness = 0.5};
_HQ setVariable ["RydHQ_Fineness",RydHQD_Fineness];

[_HQ] call HAL_Personality;

[[_HQ],HAL_LHQ] call RYD_Spawn;

if (isNil ("RydHQD_Boxed")) then {RydHQD_Boxed = []};
_HQ setVariable ["RydHQ_Boxed",RydHQD_Boxed];

if (isNil ("RydHQD_AmmoBoxes")) then 
	{
	RydHQD_AmmoBoxes = [];

	if not (isNil "RydHQD_AmmoDepot") then 
		{
		_rds = (triggerArea RydHQD_AmmoDepot) select 0;
		RydHQD_AmmoBoxes = (getPosATL RydHQD_AmmoDepot) nearObjects ["ReammoBox_F",_rds]
		}
	};
	
_HQ setVariable ["RydHQ_AmmoBoxes",RydHQD_AmmoBoxes];

_specFor_class = RHQ_SpecFor + 
	[
	] - RHQs_SpecFor;

_recon_class = RHQ_Recon + 
	[
	"O_recon_exp_F",
	"O_recon_F",
	"O_recon_JTAC_F",
	"O_recon_LAT_F",
	"O_recon_M_F",
	"O_recon_medic_F",
	"O_recon_TL_F",
	"B_recon_exp_F",
	"B_recon_F",
	"B_recon_JTAC_F",
	"B_recon_LAT_F",
	"B_recon_M_F",
	"B_recon_medic_F",
	"B_recon_TL_F",
	"I_UAV_AI",
	"O_UAV_AI",
	"B_UAV_AI",
	"I_UAV_01_F",
	"I_UAV_02_CAS_F",
	"I_UAV_02_F",
	"I_UGV_01_F",
	"I_UGV_01_rcws_F",
	"O_UAV_01_F",
	"O_UAV_02_CAS_F",
	"O_UAV_02_F",
	"O_UGV_01_F",
	"O_UGV_01_rcws_F",
	"B_UAV_01_F",
	"B_UAV_02_CAS_F",
	"B_UAV_02_F",
	"B_UGV_01_F",
	"B_UGV_01_rcws_F"
	] - RHQs_Recon;
	
_FO_class = RHQ_FO + 
	[
	"I_Spotter_F",
	"O_spotter_F",
	"B_spotter_F",
	"O_recon_JTAC_F",
	"B_recon_JTAC_F"
	] - RHQs_FO;
	
_snipers_class = RHQ_Snipers + 
	[
	"I_Sniper_F",
	"O_sniper_F",
	"B_sniper_F",
	"I_Soldier_M_F",
	"O_soldier_M_F",
	"B_G_Soldier_M_F",
	"B_soldier_M_F",
	"O_recon_M_F",
	"B_recon_M_F",
	"O_soldierU_M_F"
	] - RHQs_Snipers;
	
_ATinf_class = RHQ_ATInf + 
	[
	"I_Soldier_AT_F",
	"I_Soldier_LAT_F",
	"O_Soldier_AT_F",
	"O_Soldier_LAT_F",
	"B_soldier_AT_F",
	"B_soldier_LAT_F",
	"B_G_Soldier_LAT_F",
	"O_soldierU_AT_F",
	"O_soldierU_LAT_F",
	"O_recon_LAT_F",
	"B_CTRG_soldier_GL_LAT_F",
	"B_recon_LAT_F"
	] - RHQs_ATInf;
	
_AAinf_class = RHQ_AAInf + 
	[
	"I_Soldier_AA_F",
	"B_soldier_AA_F",
	"O_Soldier_AA_F",
	"O_APC_Tracked_02_AA_F",
	"B_APC_Tracked_01_AA_F",
	"O_soldierU_AA_F"
	] - RHQs_AAInf;

_Inf_class = RHQ_Inf + 
	[
	"I_crew_F",
	"I_engineer_F",
	"I_helicrew_F",
	"I_helipilot_F",
	"I_medic_F",
	"I_officer_F",
	"I_pilot_F",
	"I_Soldier_A_F",
	"I_Soldier_AA_F",
	"I_Soldier_AR_F",
	"I_Soldier_AT_F",
	"I_Soldier_exp_F",
	"I_soldier_F",
	"I_Soldier_GL_F",
	"I_Soldier_LAT_F",
	"I_Soldier_lite_F",
	"I_Soldier_M_F",
	"I_Soldier_repair_F",
	"I_Soldier_SL_F",
	"I_Soldier_TL_F",
	"I_soldier_UAV_F",
	"O_crew_F",
	"O_engineer_F",
	"O_helicrew_F",
	"O_helipilot_F",
	"O_medic_F",
	"O_officer_F",
	"O_Pilot_F",
	"O_Soldier_A_F",
	"O_Soldier_AA_F",
	"O_Soldier_AR_F",
	"O_Soldier_AT_F",
	"O_soldier_exp_F",
	"O_Soldier_F",
	"O_Soldier_GL_F",
	"O_Soldier_LAT_F",
	"O_Soldier_lite_F",
	"O_soldier_M_F",
	"O_soldier_PG_F",
	"O_soldier_repair_F",
	"O_Soldier_SL_F",
	"O_Soldier_TL_F",
	"O_soldier_UAV_F",
	"B_G_engineer_F",
	"B_G_medic_F",
	"B_G_officer_F",
	"B_G_Soldier_A_F",
	"B_G_Soldier_AR_F",
	"B_G_Soldier_exp_F",
	"B_G_Soldier_F",
	"B_G_Soldier_GL_F",
	"B_G_Soldier_LAT_F",
	"B_G_Soldier_lite_F",
	"B_G_Soldier_M_F",
	"B_G_Soldier_SL_F",
	"B_G_Soldier_TL_F",
	"B_crew_F",
	"B_engineer_F",
	"B_helicrew_F",
	"B_Helipilot_F",
	"B_medic_F",
	"B_officer_F",
	"B_Pilot_F",
	"B_Soldier_A_F",
	"B_soldier_AA_F",
	"B_soldier_AR_F",
	"B_soldier_AT_F",
	"B_soldier_exp_F",
	"B_Soldier_F",
	"B_Soldier_GL_F",
	"B_soldier_LAT_F",
	"B_Soldier_lite_F",
	"B_soldier_M_F",
	"B_soldier_PG_F",
	"B_soldier_repair_F",
	"B_Soldier_SL_F",
	"B_Soldier_TL_F",
	"B_soldier_UAV_F",
	"O_recon_exp_F",
	"O_recon_F",
	"O_recon_JTAC_F",
	"O_recon_LAT_F",
	"O_recon_M_F",
	"O_recon_medic_F",
	"O_recon_TL_F",
	"B_recon_exp_F",
	"B_recon_F",
	"B_recon_JTAC_F",
	"B_recon_LAT_F",
	"B_recon_M_F",
	"B_recon_medic_F",
	"B_recon_TL_F",
	"I_Sniper_F",
	"I_Spotter_F",
	"O_sniper_F",
	"O_spotter_F",
	"B_sniper_F",
	"B_spotter_F",
	"O_engineer_U_F",
	"O_soldierU_A_F",
	"O_soldierU_AA_F",
	"O_soldierU_AAA_F",
	"O_soldierU_AAR_F",
	"O_soldierU_AAT_F",
	"O_soldierU_AR_F",
	"O_soldierU_AT_F",
	"O_soldierU_exp_F",
	"O_soldierU_F",
	"O_SoldierU_GL_F",
	"O_soldierU_LAT_F",
	"O_soldierU_M_F",
	"O_soldierU_medic_F",
	"O_soldierU_repair_F",
	"O_SoldierU_SL_F",
	"O_soldierU_TL_F",
	"I_Soldier_AAA_F",
	"I_Soldier_AAR_F",
	"I_Soldier_AAT_F",
	"I_support_AMG_F",
	"I_support_AMort_F",
	"I_support_GMG_F",
	"I_support_MG_F",
	"I_support_Mort_F",
	"O_Soldier_AAA_F",
	"O_Soldier_AAR_F",
	"O_Soldier_AAT_F",
	"O_support_AMG_F",
	"O_support_AMort_F",
	"O_support_GMG_F",
	"O_support_MG_F",
	"O_support_Mort_F",
	"B_soldier_AAA_F",
	"B_soldier_AAR_F",
	"B_soldier_AAT_F",
	"B_support_AMG_F",
	"B_support_AMort_F",
	"B_support_GMG_F",
	"B_support_MG_F",
	"B_support_Mort_F",
	"I_diver_exp_F",
	"I_diver_F",
	"I_diver_TL_F",
	"O_diver_exp_F",
	"O_diver_F",
	"O_diver_TL_F",
	"B_diver_exp_F",
	"B_diver_F",
	"B_diver_TL_F",
	"I_Story_Colonel_F",
	"O_Story_CEO_F",
	"O_Story_Colonel_F",
	"I_G_Story_Protagonist_F",
	"B_Competitor_F",
	"B_RangeMaster_F",
	"B_Story_Colonel_F",
	"B_Story_Engineer_F",
	"B_Story_Pilot_F",
	"B_Story_Protagonist_F",
	"B_Story_SF_Captain_F",
	"B_Story_Tank_Commander_F",
	"B_CTRG_soldier_engineer_exp_F",
	"B_CTRG_soldier_M_medic_F",
	"B_CTRG_soldier_AR_A_F",
	"B_CTRG_soldier_GL_LAT_F",
	"I_G_Story_SF_Captain_F",
	"I_G_resistanceCommander_F",
	"I_G_resistanceLeader_F"
	] - RHQs_Inf;
	
_Art_class = RHQ_Art + 
	[
	"B_MBT_01_arty_F",
	"O_MBT_02_arty_F",
	"B_MBT_01_mlrs_F",
	"I_Mortar_01_F",
	"O_Mortar_01_F",
	"B_G_Mortar_01_F",
	"B_Mortar_01_F"
	] - RHQs_Art;
	
_HArmor_class = RHQ_HArmor + 
	[
	"B_MBT_01_cannon_F",
	"B_MBT_01_TUSK_F",
	"O_MBT_02_cannon_F",
	"I_MBT_03_cannon_F"
	] - RHQs_HArmor;
	
_MArmor_class = RHQ_MArmor + 
	[
	] - RHQs_MArmor;

_LArmor_class = RHQ_LArmor + 
	[
	"I_APC_Wheeled_03_cannon_F",
	"O_APC_Tracked_02_AA_F",
	"O_APC_Tracked_02_cannon_F",
	"O_APC_Wheeled_02_rcws_F",
	"B_APC_Tracked_01_AA_F",
	"B_APC_Tracked_01_rcws_F",
	"B_APC_Wheeled_01_cannon_F",
	"I_APC_tracked_03_cannon_F"
	] - RHQs_LArmor;
	
_LArmorAT_class = RHQ_LArmorAT + 
	[
	"B_APC_Wheeled_01_cannon_F",
	"I_APC_Wheeled_03_cannon_F",
	"O_APC_Tracked_02_cannon_F",
	"I_APC_tracked_03_cannon_F"
	] - RHQs_LArmorAT;

_Cars_class = RHQ_Cars + 
	[
	"I_MRAP_03_F",
	"I_MRAP_03_gmg_F",
	"I_MRAP_03_hmg_F",
	"I_Quadbike_01_F",
	"I_Truck_02_covered_F",
	"I_Truck_02_transport_F",
	"O_MRAP_02_F",
	"O_MRAP_02_gmg_F",
	"O_MRAP_02_hmg_F",
	"O_Quadbike_01_F",
	"O_Truck_02_covered_F",
	"O_Truck_02_transport_F",
	"O_Truck_03_device_F",
	"O_Truck_03_transport_F",
	"O_Truck_03_covered_F",
	"B_G_Offroad_01_armed_F",
	"B_G_Offroad_01_F",
	"B_G_Quadbike_01_F",
	"B_G_Van_01_transport_F",
	"B_MRAP_01_F",
	"B_MRAP_01_gmg_F",
	"B_MRAP_01_hmg_F",
	"B_Quadbike_01_F",
	"B_Truck_01_box_F",
	"B_Truck_01_covered_F",
	"B_Truck_01_mover_F",
	"B_Truck_01_transport_F",
	"I_Truck_02_ammo_F",
	"I_Truck_02_box_F",
	"I_Truck_02_fuel_F",
	"I_Truck_02_medical_F",
	"O_Truck_02_Ammo_F",
	"O_Truck_02_box_F",
	"O_Truck_02_fuel_F",
	"O_Truck_02_medical_F",
	"B_G_Van_01_fuel_F",
	"B_Truck_01_ammo_F",
	"B_Truck_01_Repair_F",
	"B_Truck_01_fuel_F",
	"B_Truck_01_medical_F",
	"O_Truck_03_ammo_F",
	"O_Truck_03_fuel_F",
	"O_Truck_03_medical_F",
	"O_Truck_03_repair_F",
	"I_UGV_01_F",
	"I_UGV_01_rcws_F",
	"O_UGV_01_F",
	"O_UGV_01_rcws_F",
	"B_UGV_01_F",
	"B_UGV_01_rcws_F"
	] - RHQs_Cars;
	
_Air_class = RHQ_Air + 
	[
	"I_Heli_Transport_02_F",
	"I_Plane_Fighter_03_AA_F",
	"I_Plane_Fighter_03_CAS_F",
	"B_Plane_CAS_01_F",
	"O_Plane_CAS_02_F",
	"O_Heli_Attack_02_black_F",
	"O_Heli_Attack_02_F",
	"O_Heli_Light_02_F",
	"O_Heli_Light_02_unarmed_F",
	"B_Heli_Attack_01_F",
	"B_Heli_Light_01_armed_F",
	"B_Heli_Light_01_F",
	"B_Heli_Transport_01_camo_F",
	"B_Heli_Transport_01_F",
	"I_UAV_AI",
	"O_UAV_AI",
	"B_UAV_AI",
	"I_UAV_01_F",
	"I_UAV_02_CAS_F",
	"I_UAV_02_F",
	"O_UAV_01_F",
	"O_UAV_02_CAS_F",
	"O_UAV_02_F",
	"B_UAV_01_F",
	"B_UAV_02_CAS_F",
	"B_UAV_02_F",
	"I_Heli_light_03_F",
	"I_Heli_light_03_unarmed_F"
	] - RHQs_Air;
	
_BAir_class = RHQ_BAir + 
	[
	"I_Plane_Fighter_03_CAS_F",
	"B_Plane_CAS_01_F",
	"O_Plane_CAS_02_F"
	] - RHQs_BAir;
	
_RAir_class = RHQ_RAir + 
	[
	"I_UAV_01_F",
	"I_UAV_02_CAS_F",
	"I_UAV_02_F",
	"O_UAV_01_F",
	"O_UAV_02_CAS_F",
	"O_UAV_02_F",
	"B_UAV_01_F",
	"B_UAV_02_CAS_F",
	"B_UAV_02_F"
	] - RHQs_RAir;
	
_NCAir_class = RHQ_NCAir + 
	[
	"I_Heli_Transport_02_F",
	"O_Heli_Light_02_unarmed_F",
	"B_Heli_Light_01_F",
	"B_Heli_Transport_01_camo_F",
	"B_Heli_Transport_01_F",
	"I_Heli_light_03_unarmed_F",
	"I_UAV_01_F",
	"I_UAV_02_F",
	"O_UAV_01_F",
	"O_UAV_02_F",
	"B_UAV_01_F",
	"B_UAV_02_F"	
	] - RHQs_NCAir;

_Naval_class = RHQ_Naval + 
	[
	"I_Boat_Armed_01_minigun_F",
	"I_Boat_Transport_01_F",
	"O_Boat_Armed_01_hmg_F",
	"O_Boat_Transport_01_F",
	"O_Lifeboat",
	"B_G_Boat_Transport_01_F",
	"B_Boat_Armed_01_minigun_F",
	"B_Boat_Transport_01_F",
	"B_Lifeboat",
	"I_SDV_01_F",
	"O_SDV_01_F",
	"B_SDV_01_F"	
	] - RHQs_Naval;

_Static_class = RHQ_Static + 
	[
	"I_GMG_01_A_F",
	"I_GMG_01_F",
	"I_GMG_01_high_F",
	"I_HMG_01_A_F",
	"I_HMG_01_F",
	"I_HMG_01_high_F",
	"I_Mortar_01_F",
	"I_static_AA_F",
	"I_static_AT_F",
	"O_GMG_01_A_F",
	"O_GMG_01_F",
	"O_GMG_01_high_F",
	"O_HMG_01_A_F",
	"O_HMG_01_F",
	"O_HMG_01_high_F",
	"O_Mortar_01_F",
	"O_static_AA_F",
	"O_static_AT_F",
	"B_G_Mortar_01_F",
	"B_GMG_01_A_F",
	"B_GMG_01_F",
	"B_GMG_01_high_F",
	"B_HMG_01_A_F",
	"B_HMG_01_F",
	"B_HMG_01_high_F",
	"B_Mortar_01_F",
	"B_static_AA_F",
	"B_static_AT_F"
	] - RHQs_Static;
	
_StaticAA_class = RHQ_StaticAA + 
	[
	"I_static_AA_F",
	"O_static_AA_F",
	"B_static_AA_F"
	] - RHQs_StaticAA;
	
_StaticAT_class = RHQ_StaticAT + 
	[
	"I_static_AT_F",
	"O_static_AT_F",
	"B_static_AT_F"
	] - RHQs_StaticAT;
	
_Support_class = RHQ_Support + 
	[
	"I_Truck_02_ammo_F",
	"I_Truck_02_box_F",
	"I_Truck_02_fuel_F",
	"I_Truck_02_medical_F",
	"O_Truck_02_Ammo_F",
	"O_Truck_02_box_F",
	"O_Truck_02_fuel_F",
	"O_Truck_02_medical_F",
	"O_Truck_03_ammo_F",
	"O_Truck_03_fuel_F",
	"O_Truck_03_medical_F",
	"O_Truck_03_repair_F",
	"B_G_Van_01_fuel_F",
	"B_APC_Tracked_01_CRV_F",
	"B_Truck_01_ammo_F",
	"B_Truck_01_Repair_F",
	"B_Truck_01_fuel_F",
	"B_Truck_01_medical_F"
	] - RHQs_Support;
	
_Cargo_class = RHQ_Cargo + 
	[
	"I_Heli_Transport_02_F",
	"O_Heli_Attack_02_black_F",
	"O_Heli_Attack_02_F",
	"O_Heli_Light_02_F",
	"O_Heli_Light_02_unarmed_F",
	"B_Heli_Light_01_F",
	"B_Heli_Transport_01_camo_F",
	"B_Heli_Transport_01_F",
	"I_Truck_02_medical_F",
	"O_Truck_02_medical_F",
	"B_Truck_01_medical_F",
	"O_Truck_03_medical_F",
	"I_Boat_Armed_01_minigun_F",
	"I_Boat_Transport_01_F",
	"O_Boat_Armed_01_hmg_F",
	"O_Boat_Transport_01_F",
	"O_Lifeboat",
	"B_G_Boat_Transport_01_F",
	"B_Boat_Armed_01_minigun_F",
	"B_Boat_Transport_01_F",
	"B_Lifeboat",
	"I_SDV_01_F",
	"O_SDV_01_F",
	"B_SDV_01_F",
	"B_MBT_01_cannon_F",
	"I_APC_Wheeled_03_cannon_F",
	"O_APC_Tracked_02_cannon_F",
	"O_APC_Wheeled_02_rcws_F",
	"B_APC_Tracked_01_rcws_F",
	"B_APC_Wheeled_01_cannon_F",
	"I_MRAP_03_F",
	"I_MRAP_03_gmg_F",
	"I_MRAP_03_hmg_F",
	"I_Quadbike_01_F",
	"I_Truck_02_covered_F",
	"I_Truck_02_transport_F",
	"O_MRAP_02_F",
	"O_MRAP_02_gmg_F",
	"O_MRAP_02_hmg_F",
	"O_Quadbike_01_F",
	"O_Truck_02_covered_F",
	"O_Truck_02_transport_F",
	"O_Truck_03_device_F",
	"O_Truck_03_transport_F",
	"O_Truck_03_covered_F",
	"B_G_Offroad_01_armed_F",
	"B_G_Offroad_01_F",
	"B_G_Quadbike_01_F",
	"B_G_Van_01_transport_F",
	"B_MRAP_01_F",
	"B_MRAP_01_gmg_F",
	"B_MRAP_01_hmg_F",
	"B_Quadbike_01_F",
	"B_Truck_01_box_F",
	"B_Truck_01_covered_F",
	"B_Truck_01_mover_F",
	"B_Truck_01_transport_F",
	"I_Heli_light_03_F",
	"I_Heli_light_03_unarmed_F",
	"I_APC_tracked_03_cannon_F"	
	] - RHQs_Cargo;
	
_NCCargo_class = RHQ_NCCargo + 
	[
	"I_Heli_Transport_02_F",
	"O_Heli_Light_02_unarmed_F",
	"B_Heli_Light_01_F",
	"B_Heli_Transport_01_camo_F",
	"B_Heli_Transport_01_F",
	"I_Heli_light_03_unarmed_F",
	"I_Truck_02_medical_F",
	"O_Truck_02_medical_F",
	"B_Truck_01_medical_F",
	"O_Truck_03_medical_F",
	"I_Boat_Transport_01_F",
	"O_Boat_Transport_01_F",
	"O_Lifeboat",
	"B_G_Boat_Transport_01_F",
	"B_Boat_Transport_01_F",
	"B_Lifeboat",
	"I_MRAP_03_F",
	"I_Quadbike_01_F",
	"I_Truck_02_covered_F",
	"I_Truck_02_transport_F",
	"O_MRAP_02_F",
	"O_Quadbike_01_F",
	"O_Truck_02_covered_F",
	"O_Truck_02_transport_F",
	"O_Truck_03_device_F",
	"O_Truck_03_transport_F",
	"O_Truck_03_covered_F",
	"B_G_Offroad_01_F",
	"B_G_Quadbike_01_F",
	"B_G_Van_01_transport_F",
	"B_MRAP_01_F",
	"B_Quadbike_01_F",
	"B_Truck_01_box_F",
	"B_Truck_01_covered_F",
	"B_Truck_01_mover_F",
	"B_Truck_01_transport_F"	
	] - RHQs_NCCargo;
	
_Crew_class = RHQ_Crew + 
	[
	"I_crew_F",
	"I_helicrew_F",
	"I_helipilot_F",
	"I_pilot_F",
	"O_crew_F",
	"O_helicrew_F",
	"O_helipilot_F",
	"O_Pilot_F",
	"B_crew_F",
	"B_helicrew_F",
	"B_Helipilot_F",
	"B_Pilot_F",
	"B_Story_Pilot_F"
	] - RHQs_Crew;
	
_Other_class = RHQ_Other + 
	[
	"I_UAV_AI",
	"O_UAV_AI",
	"B_UAV_AI"	
	];
		
_NCrewInf_class = _Inf_class - _Crew_class;
_Cargo_class = _Cargo_class - (_Support_class - ["MH60S"]);

_HQ setVariable ["RydHQ_NCVeh",_NCCargo_class + (_Support_class - ["MH60S"])];

_HQ setVariable ["RydHQ_ReconDone",false];
_HQ setVariable ["RydHQ_DefDone",false];
_HQ setVariable ["RydHQ_ReconStage",1];
_HQ setVariable ["RydHQ_ReconStage2",1];
_HQ setVariable ["RydHQ_AirInDef",[]];

_KnEnPos = [];

if (isNil ("RydHQD_Excluded")) then {RydHQD_Excluded = []};
_HQ setVariable ["RydHQ_Excluded",RydHQD_Excluded];
if (isNil ("RydHQD_Fast")) then {RydHQD_Fast = false};
_HQ setVariable ["RydHQ_Fast",RydHQD_Fast];
if (isNil ("RydHQD_ExInfo")) then {RydHQD_ExInfo = false};
_HQ setVariable ["RydHQ_ExInfo",RydHQD_ExInfo];
if (isNil ("RydHQD_ObjHoldTime")) then {RydHQD_ObjHoldTime = 600};
_HQ setVariable ["RydHQ_ObjHoldTime",RydHQD_ObjHoldTime];
if (isNil "RydHQD_NObj") then {RydHQD_NObj = 1};
_HQ setVariable ["RydHQ_NObj",RydHQD_NObj];

_HQ setVariable ["RydHQ_Init",true];

_HQ setVariable ["RydHQ_Inertia",0];
_HQ setVariable ["RydHQ_Morale",0];
_HQ setVariable ["RydHQ_CInitial",0];
_HQ setVariable ["RydHQ_CLast",0];
_HQ setVariable ["RydHQ_CCurrent",0];
_HQ setVariable ["RydHQ_CIMoraleC",0];
_HQ setVariable ["RydHQ_CLMoraleC",0];
_HQ setVariable ["RydHQ_Surrender",false];

_HQ setVariable ["RydHQ_FirstEMark",true];
_HQ setVariable ["RydHQ_LastE",0];
_HQ setVariable ["RydHQ_FlankingInit",false];
_HQ setVariable ["RydHQ_FlankingDone",false];
_HQ setVariable ["RydHQ_Progress",0];

_HQ setVariable ["RydHQ_AAthreat",[]];
_HQ setVariable ["RydHQ_ATthreat",[]];
_HQ setVariable ["RydHQ_Airthreat",[]];
_HQ setVariable ["RydHQ_Exhausted",[]];

if (isNil ("RydHQD_SupportWP")) then {RydHQD_SupportWP = false};
	
_HQ setVariable ["RydHQ_SupportWP",RydHQD_SupportWP];

_lastHQ = _HQ getVariable ["leaderHQ",objNull];
_OLmpl = 0;
_cycleCap = 0;
_firstMC = 0; 
_wp = [];
_lastReset = 0;
_HQlPos = [-10,-10,0];
_cInitial = 0;

while {true} do
	{
	if (isNull _HQ) exitWith {RydxHQ_AllHQ = RydxHQ_AllHQ - [_HQ]};
	if (({alive _x} count (units _HQ)) == 0) exitWith {RydxHQ_AllHQ = RydxHQ_AllHQ - [_HQ]};
	if (_HQ getVariable ["RydHQ_Surrender",false]) exitWith {RydxHQ_AllHQ = RydxHQ_AllHQ - [_HQ]};
	
	if not (_HQ getVariable ["RydHQ_Fast",false]) then 
		{
		waituntil 
			{
			sleep 0.1;
			((({(_x getVariable ["RydHQ_Pending",false])} count RydxHQ_AllHQ) == 0) or (_HQ getVariable ["RydHQ_KIA",false]))
			}
		};
		
	if (_HQ getVariable ["RydHQ_KIA",false]) exitWith {RydxHQ_AllHQ = RydxHQ_AllHQ - [_HQ]};
	
	_HQ setVariable ["RydHQ_Pending",true];

	if (_cycleC > 1) then
		{
		if not (_lastHQ == (_HQ getVariable ["leaderHQ",objNull])) then {sleep (60 + (random 60))};
		};
		
	if (_HQ getVariable ["RydHQ_KIA",false]) exitWith {RydxHQ_AllHQ = RydxHQ_AllHQ - [_HQ]};
	_lastHQ = (leader _HQ);
	
	_HQ setVariable ["RydHQ_Cyclecount",_cycleC + 1];
	_cycleC = _HQ getVariable ["RydHQ_Cyclecount",1];
	
	_SpecFor = [];
	_recon = [];
	_FO = [];
	_snipers = [];
	_ATinf = [];
	_AAinf = [];
	_Inf = [];
	_Art = [];
	_HArmor = [];
	_MArmor = [];
	_LArmor = [];
	_LArmorAT = [];
	_Cars = [];
	_Air = [];
	_BAir = [];
	_RAir = [];
	_NCAir = [];
	_Naval = [];
	_Static = [];
	_StaticAA = [];
	_StaticAT = [];
	_Support = [];
	_Cargo = [];
	_NCCargo = [];
	_Other = [];
	_Crew = [];
	_NCrewInf = [];

	_SpecForG = [];
	_reconG = [];
	_FOG = [];
	_snipersG = [];
	_ATinfG = [];
	_AAinfG = [];
	_InfG = [];
	_ArtG = [];
	_HArmorG = [];
	_MArmorG = [];
	_LArmorG = [];
	_LArmorATG = [];
	_CarsG = [];
	_AirG = [];
	_BAirG = [];
	_RAirG = [];
	_NCAirG = [];
	_NavalG = [];
	_StaticG = [];
	_StaticAAG = [];
	_StaticATG = [];
	_SupportG = [];
	_CargoG = [];
	_NCCargoG = [];
	_OtherG = [];
	_CrewG = [];
	_NCrewInfG = [];

	_EnSpecFor = [];
	_Enrecon = [];
	_EnFO = [];
	_Ensnipers = [];
	_EnATinf = [];
	_EnAAinf = [];
	_EnInf = [];
	_EnArt = [];
	_EnHArmor = [];
	_EnMArmor = [];
	_EnLArmor = [];
	_EnLArmorAT = [];
	_EnCars = [];
	_EnAir = [];
	_EnBAir = [];
	_EnRAir = [];
	_EnNCAir = [];
	_EnNaval = [];
	_EnStatic = [];
	_EnStaticAA = [];
	_EnStaticAT = [];
	_EnSupport = [];
	_EnCargo = [];
	_EnNCCargo = [];
	_EnOther = [];
	_EnCrew = [];
	_EnNCrewInf = [];

	_EnSpecForG = [];
	_EnreconG = [];
	_EnFOG = [];
	_EnsnipersG = [];
	_EnATinfG = [];
	_EnAAinfG = [];
	_EnInfG = [];
	_EnArtG = [];
	_EnHArmorG = [];
	_EnMArmorG = [];
	_EnLArmorG = [];
	_EnLArmorATG = [];
	_EnCarsG = [];
	_EnAirG = [];
	_EnBAirG = [];
	_EnRAirG = [];
	_EnNCAirG = [];
	_EnNavalG = [];
	_EnStaticG = [];
	_EnStaticAAG = [];
	_EnStaticATG = [];
	_EnSupportG = [];
	_EnCargoG = [];
	_EnNCCargoG = [];
	_EnOtherG = [];
	_EnCrewG = [];
	_EnNCrewInfG = [];

	_HQ setVariable ["RydHQ_LastE",count (_HQ getVariable ["RydHQ_KnEnemies",[]])];
	_HQ setVariable ["RydHQ_LastFriends",_HQ getVariable ["RydHQ_Friends",[]]];
	
	if (isNil "RydHQD_Garrison") then {RydHQD_Garrison = []};
	_HQ setVariable ["RydHQ_Garrison",RydHQD_Garrison];
	
	if (isNil ("RydHQD_NoAirCargo")) then {RydHQD_NoAirCargo = false};
	_HQ setVariable ["RydHQ_NoAirCargo",RydHQD_NoAirCargo];
	if (isNil ("RydHQD_NoLandCargo")) then {RydHQD_NoLandCargo = false};
	_HQ setVariable ["RydHQ_NoLandCargo",RydHQD_NoLandCargo];
	if (isNil ("RydHQD_LastFriends")) then {RydHQD_LastFriends = []};
	_HQ setVariable ["RydHQ_LastFriends",RydHQD_LastFriends];
	if (isNil ("RydHQD_CargoFind")) then {RydHQD_CargoFind = 0};
	_HQ setVariable ["RydHQ_CargoFind",RydHQD_CargoFind];
	if (isNil ("RydHQD_Subordinated")) then {RydHQD_Subordinated = []};
	_HQ setVariable ["RydHQ_Subordinated",RydHQD_Subordinated];
	if (isNil ("RydHQD_Included")) then {RydHQD_Included = []};
	_HQ setVariable ["RydHQ_Included",RydHQD_Included];
	if (isNil ("RydHQD_ExcludedG")) then {RydHQD_ExcludedG = []};
	_HQ setVariable ["RydHQ_ExcludedG",RydHQD_ExcludedG];
	if (isNil ("RydHQD_SubAll")) then {RydHQD_SubAll = true};
	_HQ setVariable ["RydHQ_SubAll",RydHQD_SubAll];
	if (isNil ("RydHQD_SubSynchro")) then {RydHQD_SubSynchro = false};
	_HQ setVariable ["RydHQ_SubSynchro",RydHQD_SubSynchro];
	if (isNil ("RydHQD_SubNamed")) then {RydHQD_SubNamed = false};
	_HQ setVariable ["RydHQ_SubNamed",RydHQD_SubNamed];
	if (isNil ("RydHQD_SubZero")) then {RydHQD_SubZero = false};
	_HQ setVariable ["RydHQ_SubZero",RydHQD_SubZero];
	if (isNil ("RydHQD_ReSynchro")) then {RydHQD_ReSynchro = true};
	_HQ setVariable ["RydHQ_ReSynchro",RydHQD_ReSynchro];
	if (isNil ("RydHQD_NameLimit")) then {RydHQD_NameLimit = 100};
	_HQ setVariable ["RydHQ_NameLimit",RydHQD_NameLimit];
	if (isNil ("RydHQD_Surr")) then {RydHQD_Surr = false};
	_HQ setVariable ["RydHQ_Surr",RydHQD_Surr];
	if (isNil ("RydHQD_NoRecon")) then {RydHQD_NoRecon = []};
	_HQ setVariable ["RydHQ_NoRecon",RydHQD_NoRecon];
	if (isNil ("RydHQD_NoAttack")) then {RydHQD_NoAttack = []};
	_HQ setVariable ["RydHQ_NoAttack",RydHQD_NoAttack];
	if (isNil ("RydHQD_CargoOnly")) then {RydHQD_CargoOnly = []};
	_HQ setVariable ["RydHQ_CargoOnly",RydHQD_CargoOnly];
	if (isNil ("RydHQD_NoCargo")) then {RydHQD_NoCargo = []};
	_HQ setVariable ["RydHQ_NoCargo",RydHQD_NoCargo];
	if (isNil ("RydHQD_NoFlank")) then {RydHQD_NoFlank = []};
	_HQ setVariable ["RydHQ_NoFlank",RydHQD_NoFlank];
	if (isNil ("RydHQD_NoDef")) then {RydHQD_NoDef = []};
	_HQ setVariable ["RydHQ_NoDef",RydHQD_NoDef];
	if (isNil ("RydHQD_FirstToFight")) then {RydHQD_FirstToFight = []};
	_HQ setVariable ["RydHQ_FirstToFight",RydHQD_FirstToFight];
	if (isNil ("RydHQD_VoiceComm")) then {RydHQD_VoiceComm = true};
	_HQ setVariable ["RydHQ_VoiceComm",RydHQD_VoiceComm];
	if (isNil ("RydHQD_FrontA")) then {RydHQD_Front = false};
	_HQ setVariable ["RydHQ_FrontA",RydHQD_Front];
	if (isNil ("RydHQD_LRelocating")) then {RydHQD_LRelocating = false};
	_HQ setVariable ["RydHQ_LRelocating",RydHQD_LRelocating];
	if (isNil ("RydHQD_Flee")) then {RydHQD_Flee = true};
	_HQ setVariable ["RydHQ_Flee",RydHQD_Flee];
	if (isNil ("RydHQD_GarrR")) then {RydHQD_GarrR = 500};
	_HQ setVariable ["RydHQ_GarrR",RydHQD_GarrR];
	if (isNil ("RydHQD_Rush")) then {RydHQD_Rush = false};
	_HQ setVariable ["RydHQ_Rush",RydHQD_Rush];
	if (isNil ("RydHQD_GarrVehAb")) then {RydHQD_GarrVehAb = false};
	_HQ setVariable ["RydHQ_GarrVehAb",RydHQD_GarrVehAb];
	if (isNil ("RydHQD_DefendObjectives")) then {RydHQD_DefendObjectives = 4};
	_HQ setVariable ["RydHQ_DefendObjectives",RydHQD_DefendObjectives];
	if (isNil ("RydHQD_DefSpot")) then {RydHQD_DefSpot = []};
	_HQ setVariable ["RydHQ_DefSpot",RydHQD_DefSpot];
	if (isNil ("RydHQD_RecDefSpot")) then {RydHQD_RecDefSpot = []};
	_HQ setVariable ["RydHQ_RecDefSpot",RydHQD_RecDefSpot];
	if (isNil "RydHQD_Flare") then {RydHQD_Flare = true};
	_HQ setVariable ["RydHQ_Flare",RydHQD_Flare];
	if (isNil "RydHQD_Smoke") then {RydHQD_Smoke = true};
	_HQ setVariable ["RydHQ_Smoke",RydHQD_Smoke];
	if (isNil "RydHQD_NoRec") then {RydHQD_NoRec = 1};
	_HQ setVariable ["RydHQ_NoRec",RydHQD_NoRec];
	if (isNil "RydHQD_RapidCapt") then {RydHQD_RapidCapt = 10};
	_HQ setVariable ["RydHQ_RapidCapt",RydHQD_RapidCapt];
	if (isNil "RydHQD_Muu") then {RydHQD_Muu = 1};
	_HQ setVariable ["RydHQ_Muu",RydHQD_Muu];
	if (isNil "RydHQD_ArtyShells") then {RydHQD_ArtyShells = 1};
	_HQ setVariable ["RydHQ_ArtyShells",RydHQD_ArtyShells];
	if (isNil "RydHQD_Withdraw") then {RydHQD_Withdraw = 1};
	_HQ setVariable ["RydHQ_Withdraw",RydHQD_Withdraw];
	if (isNil "RydHQD_Berserk") then {RydHQD_Berserk = false};
	_HQ setVariable ["RydHQ_Berserk",RydHQD_Berserk];
	if (isNil "RydHQD_IDChance") then {RydHQD_IDChance = 100};
	_HQ setVariable ["RydHQ_IDChance",RydHQD_IDChance];
	if (isNil "RydHQD_RDChance") then {RydHQD_RDChance = 100};
	_HQ setVariable ["RydHQ_RDChance",RydHQD_RDChance];
	if (isNil "RydHQD_SDChance") then {RydHQD_SDChance = 100};
	_HQ setVariable ["RydHQ_SDChance",RydHQD_SDChance];
	if (isNil "RydHQD_AmmoDrop") then {RydHQD_AmmoDrop = []};
	_HQ setVariable ["RydHQ_AmmoDrop",RydHQD_AmmoDrop];
	if (isNil "RydHQD_SFTargets") then {RydHQD_SFTargets = []};
	_HQ setVariable ["RydHQ_SFTargets",RydHQD_SFTargets];
	if (isNil "RydHQD_LZ") then {RydHQD_LZ = false};
	_HQ setVariable ["RydHQ_LZ",RydHQD_LZ];
	if (isNil "RydHQD_SFBodyGuard") then {RydHQD_SFBodyGuard = []};
	_HQ setVariable ["RydHQ_SFBodyGuard",RydHQD_SFBodyGuard];
	if (isNil "RydHQD_DynForm") then {RydHQD_DynForm = false};
	_HQ setVariable ["RydHQ_DynForm",RydHQD_DynForm];
	if (isNil "RydHQD_UnlimitedCapt") then {RydHQD_UnlimitedCapt = false};
	_HQ setVariable ["RydHQ_UnlimitedCapt",RydHQD_UnlimitedCapt];
	if (isNil "RydHQD_CaptLimit") then {RydHQD_CaptLimit = 10};
	_HQ setVariable ["RydHQ_CaptLimit",RydHQD_CaptLimit];
	if (isNil "RydHQD_GetHQInside") then {RydHQD_GetHQInside = false};
	_HQ setVariable ["RydHQ_GetHQInside",RydHQD_GetHQInside];
	if (isNil "RydHQD_WA") then {RydHQD_WA = true};
	_HQ setVariable ["RydHQ_WA",RydHQD_WA];
	
	if (isNil ("RydHQD_ResetNow")) then {RydHQD_ResetNow = false};
	_HQ setVariable ["RydHQ_ResetNow",RydHQD_ResetNow];
	if (isNil ("RydHQD_ResetOnDemand")) then {RydHQD_ResetOnDemand = false};
	_HQ setVariable ["RydHQ_ResetOnDemand",RydHQD_ResetOnDemand];
	if (isNil ("RydHQD_ResetTime")) then {RydHQD_ResetTime = 600};
	_HQ setVariable ["RydHQ_ResetTime",RydHQD_ResetTime];
	if (isNil ("RydHQD_Combining")) then {RydHQD_Combining = false};
	_HQ setVariable ["RydHQ_Combining",RydHQD_Combining];
	if (isNil ("RydHQD_ObjRadius1")) then {RydHQD_ObjRadius1 = 300};
	_HQ setVariable ["RydHQ_ObjRadius1",RydHQD_ObjRadius1];
	if (isNil ("RydHQD_ObjRadius2")) then {RydHQD_ObjRadius2 = 500};
	_HQ setVariable ["RydHQ_ObjRadius2",RydHQD_ObjRadius2];
	if (isNil ("RydHQD_KnowTL")) then {RydHQD_KnowTL = true};
	_HQ setVariable ["RydHQ_KnowTL",RydHQD_KnowTL];
	
	if (isNil ("RydHQD_SMed")) then {RydHQD_SMed = true};
	_HQ setVariable ["RydHQ_SMed",RydHQD_SMed];
	if (isNil ("RydHQD_ExMedic")) then {RydHQD_ExMedic = []};
	_HQ setVariable ["RydHQ_ExMedic",RydHQD_ExMedic];
	if (isNil ("RydHQD_MedPoints")) then {RydHQD_MedPoints = []};
	_HQ setVariable ["RydHQ_MedPoints",RydHQD_MedPoints];
	if (isNil ("RydHQD_SupportedG")) then {RydHQD_SupportedG = []};
	_HQ setVariable ["RydHQ_SupportedG",RydHQD_SupportedG];
	
	if (isNil ("RydHQD_SFuel")) then {RydHQD_SFuel = true};
	_HQ setVariable ["RydHQ_SFuel",RydHQD_SFuel];
	if (isNil ("RydHQD_ExRefuel")) then {RydHQD_ExRefuel = []};
	_HQ setVariable ["RydHQ_ExRefuel",RydHQD_ExRefuel];
	if (isNil ("RydHQD_FuelPoints")) then {RydHQD_FuelPoints = []};
	_HQ setVariable ["RydHQ_FuelPoints",RydHQD_FuelPoints];
	if (isNil ("RydHQD_FSupportedG")) then {RydHQD_FSupportedG = []};
	_HQ setVariable ["RydHQ_FSupportedG",RydHQD_FSupportedG];
	
	if (isNil ("RydHQD_SAmmo")) then {RydHQD_SAmmo = true};
	_HQ setVariable ["RydHQ_SAmmo",RydHQD_SAmmo];
	if (isNil ("RydHQD_ExReammo")) then {RydHQD_ExReammo = []};
	_HQ setVariable ["RydHQ_ExReammo",RydHQD_ExReammo];
	if (isNil ("RydHQD_AmmoPoints")) then {RydHQD_AmmoPoints = []};
	_HQ setVariable ["RydHQ_AmmoPoints",RydHQD_AmmoPoints];
	if (isNil ("RydHQD_ASupportedG")) then {RydHQD_ASupportedG = []};
	_HQ setVariable ["RydHQ_ASupportedG",RydHQD_ASupportedG];
	
	if (isNil ("RydHQD_SRep")) then {RydHQD_SRep = true};
	_HQ setVariable ["RydHQ_SRep",RydHQD_SRep];
	if (isNil ("RydHQD_ExRepair")) then {RydHQD_ExRepair = []};
	_HQ setVariable ["RydHQ_ExRepair",RydHQD_ExRepair];
	if (isNil ("RydHQD_RepPoints")) then {RydHQD_RepPoints = []};
	_HQ setVariable ["RydHQ_RepPoints",RydHQD_RepPoints];
	if (isNil ("RydHQD_RSupportedG")) then {RydHQD_RSupportedG = []};
	_HQ setVariable ["RydHQ_RSupportedG",RydHQD_RSupportedG];
	
	if (isNil "RydHQD_AirDist") then {RydHQD_AirDist = 4000};
	_HQ setVariable ["RydHQ_AirDist",RydHQD_AirDist];
	
	if (isNil ("RydHQD_CommDelay")) then {RydHQD_CommDelay = 1};
	_HQ setVariable ["RydHQ_CommDelay",RydHQD_CommDelay];
	if (isNil ("RydHQD_Order")) then {RydHQD_Order = "ATTACK"};
	_HQ setVariable ["RydHQ_Order",RydHQD_Order];
	if (isNil ("RydHQD_ReconReserve")) then {RydHQD_ReconReserve = (0.3 * (0.5 + (_HQ getVariable ["RydHQ_Circumspection",0.5])))};
	_HQ setVariable ["RydHQ_ReconReserve",RydHQD_ReconReserve];
	if (isNil ("RydHQD_Exhausted")) then {RydHQD_Exhausted = []};
	_HQ setVariable ["RydHQ_Exhausted",RydHQD_Exhausted];
	if (isNil ("RydHQD_AttackReserve")) then {RydHQD_AttackReserve = (0.5 * (0.5 + ((_HQ getVariable ["RydHQ_Circumspection",0.5])/1.5)))};
	_HQ setVariable ["RydHQ_AttackReserve",RydHQD_AttackReserve];
	if (isNil ("RydHQD_IdleOrd")) then {RydHQD_IdleOrd = true};
	_HQ setVariable ["RydHQ_IdleOrd",RydHQD_IdleOrd];
	if (isNil "RydHQD_IdleDecoy") then {RydHQD_IdleDecoy = objNull};
	_HQ setVariable ["RydHQ_IdleDecoy",RydHQD_IdleDecoy]; 
	if (isNil "RydHQD_SupportDecoy") then {RydHQD_SupportDecoy = objNull};
	_HQ setVariable ["RydHQ_SupportDecoy",RydHQD_SupportDecoy]; 
	if (isNil "RydHQD_RestDecoy") then {RydHQD_RestDecoy = objNull};
	_HQ setVariable ["RydHQ_RestDecoy",RydHQD_RestDecoy]; 
	if (isNil "RydHQD_Sec1") then {RydHQD_Sec1 = objNull};
	_HQ setVariable ["RydHQ_Sec1",RydHQD_Sec1]; 
	if (isNil "RydHQD_Sec2") then {RydHQD_Sec2 = objNull};
	_HQ setVariable ["RydHQ_Sec2",RydHQD_Sec2];
	
	if (isNil "RydHQD_Debug") then {RydHQD_Debug = false};
	_HQ setVariable ["RydHQ_Debug",RydHQD_Debug]; 
	if (isNil "RydHQD_DebugII") then {RydHQD_DebugII = false};
	_HQ setVariable ["RydHQ_DebugII",RydHQD_DebugII];
	
	if (isNil "RydHQD_AlwaysKnownU") then {RydHQD_AlwaysKnownU = []};
	_HQ setVariable ["RydHQ_AlwaysKnownU",RydHQD_AlwaysKnownU]; 
	if (isNil "RydHQD_AlwaysUnKnownU") then {RydHQD_AlwaysUnKnownU = []};
	_HQ setVariable ["RydHQ_AlwaysUnKnownU",RydHQD_AlwaysUnKnownU]; 
	
	if (isNil "RydHQD_AOnly") then {RydHQD_AOnly = []};
	_HQ setVariable ["RydHQ_AOnly",RydHQD_AOnly]; 
	if (isNil "RydHQD_ROnly") then {RydHQD_ROnly = []};
	_HQ setVariable ["RydHQ_ROnly",RydHQD_ROnly];
	
	if (isNil "RydHQD_AirEvac") then {RydHQD_AirEvac = false};
	_HQ setVariable ["RydHQ_AirEvac",RydHQD_AirEvac];  
	
	if (isNil "RydHQD_AAO") then {RydHQD_AAO = false};
	_HQ setVariable ["RydHQ_AAO",RydHQD_AAO]; 
	if (isNil "RydHQD_ForceAAO") then {RydHQD_ForceAAO = false};
	_HQ setVariable ["RydHQ_ForceAAO",RydHQD_ForceAAO];
	
	if (isNil "RydHQD_Taken") then {RydHQD_Taken = []};
	_HQ setVariable ["RydHQ_Taken",RydHQD_Taken]; 
	
	if (isNil "RydHQD_EBDoctrine") then {RydHQD_EBDoctrine = false};
	_HQ setVariable ["RydHQ_EBDoctrine",RydHQD_EBDoctrine]; 
	if (isNil "RydHQD_ForceEBDoctrine") then {RydHQD_ForceEBDoctrine = false};
	_HQ setVariable ["RydHQ_ForceEBDoctrine",RydHQD_ForceEBDoctrine]; 
	
 	_HQ setVariable ["RydHQ_Obj1",RydHQD_Obj1];
	_HQ setVariable ["RydHQ_Obj2",RydHQD_Obj2];
	_HQ setVariable ["RydHQ_Obj3",RydHQD_Obj3];
	_HQ setVariable ["RydHQ_Obj4",RydHQD_Obj4];
	
	_objectives = [RydHQD_Obj1,RydHQD_Obj2,RydHQD_Obj3,RydHQD_Obj4];
	
	_HQ setVariable ["RydHQ_Objectives",_objectives];
	
	_listed = _HQ getVariable "BBProgress";

	if (isNil "_listed") then
		{
		_midX = 0;
		_midY = 0;
		
		_notTaken = _objectives - (_HQ getVariable ["RydHQ_Taken",[]]);
		
		_nTc = count _notTaken;
		
		if (_nTc < 1) then 
			{
			_notTaken = _objectives;
			_nTc = 4
			};
		
			{
			_pos = getPosATL _x;
			_midX = _midX + (_pos select 0);
			_midY = _midY + (_pos select 1);
			}
		foreach _notTaken;
			
		_HQ setVariable ["RydHQ_EyeOfBattle",[_midX/_nTc,_midY/_nTc,0]];
		};
				
	if not (isNil "RydHQD_DefFrontL") then {_HQ setVariable ["RydHQ_DefFrontL",RydHQD_DefFrontL]};
	if not (isNil "RydHQD_DefFront1") then {_HQ setVariable ["RydHQ_DefFront1",RydHQD_DefFront1]};
	if not (isNil "RydHQD_DefFront2") then {_HQ setVariable ["RydHQ_DefFront2",RydHQD_DefFront2]};
	if not (isNil "RydHQD_DefFront3") then {_HQ setVariable ["RydHQ_DefFront3",RydHQD_DefFront3]};
	if not (isNil "RydHQD_DefFront4") then {_HQ setVariable ["RydHQ_DefFront4",RydHQD_DefFront4]};
	
	_civF = ["CIV_F","CIV","CIV_RU","BIS_TK_CIV","BIS_CIV_special"];
	if not (isNil ("RydHQD_CivF")) then {_civF = RydHQD_CivF};
	_HQ setVariable ["RydHQ_CivF",_civF];
	
	if (isNil ("RydHQD_Def")) then {RydHQD_Def = []};
	_HQ setVariable ["RydHQ_Def",RydHQD_Def];
	
	_nObj = _HQ getVariable ["RydHQ_NObj",1];

	switch (_nObj) do
		{
		case (1) : {_HQ setVariable ["RydHQ_Obj",RydHQD_Obj1]};
		case (2) : {_HQ setVariable ["RydHQ_Obj",RydHQD_Obj2]};
		case (3) : {_HQ setVariable ["RydHQ_Obj",RydHQD_Obj3]};
		default {_HQ setVariable ["RydHQ_Obj",RydHQD_Obj4]};
		};
		
	call RYD_StatusQuo;
	};