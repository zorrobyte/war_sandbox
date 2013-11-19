// ////////////////////////////////////////////////////////////////////////////
// GL4 v.1.1.83 Global Settings
// ////////////////////////////////////////////////////////////////////////////
// The GL4 Global settings are stored in the global array GL4_Global.
// You can change settings of GL4 by editing the GL4_Global array.
// For each custom setting uncomment remove the "//" in front of the respective line and modify the value.
// GL4_Global set [ Index, Value ];
// In multiplayer all GL4_Global settings are used and synchronized by the server.
// ////////////////////////////////////////////////////////////////////////////

  /* Legend:

   1.) Enemy A.I. Enhancement:
       * Reinforcement Request
       * Artillery
       * Airstrike
       * Behaviours ( Combat )
       * Behaviours ( Idle )
       * Advancing ( Smoke and Weapons )
       * Suppressed Fire
       * Difficult ( Skill and Skill Types )
       * Surrender
       * Simulate Dead

   2.) Enemy A.I. Debug:
       * Array
       * Marker

   3.) Friendly A.I. Enhancement:
       * Recruit
       * Advancing and Suppressed Fire

   4.) System Enhancement:
       * Get In
       * Body Remove
       * Re-Initialize
  */

  // ==============================================================
  // 1.) GL4 Enemy A.I. Enhancement:
  // ==============================================================

    // ==============================================================
    // GL4 Enemy A.I. Reinforcement Request:
    // ==============================================================
    // Choose False to disable the enemy A.I. reinforcement feature.
    // True / False, default is True
      // GL4_Global set [0, False];

      // Enemy A.I. Reinforcement Groups:
      // Choose how many enemy A.I. groups can be requested as reinforcement at the same time.
      // 0 - 30, default is 3
        // GL4_Global set [1, 3];

      // Enemy A.I. Reinforcement Units:
      // Choose how many enemy A.I. units need to be requested as reinforcement at the same time.
      // 0 - 30, default is 3
        // GL4_Global set [2, 10];

      // Enemy A.I. Reinforcement Request Knows About:
      // Choose how much enemy A.I. must know about a enemy to set alert and request reinforcement.
      // Note: The lower this value the faster enemy A.I. will request reinforcement.
      // 0 - 3, default is 0.30
        // GL4_Global set [3, 0.30];

      // Enemy A.I. Reinforcement Courage:
      // Choose the enemy A.I. courage.
      // The lower this value the faster enemy A.I. will request reinforcement.
      // Note: If this value was set to 0.10 then enemy A.I. will request reinforcement even if they are not overmatched.
      // Note: If this value was set to 0.50 or 0.80 then enemy A.I. will only request reinforcement if they are really overmatched.
      // 0.01 - 1.00, default is 0.10
        // GL4_Global set [4, 0.10];

      // Enemy A.I. Reinforcement Behaviour: ( Idle )
      // Choose the enemy A.I. idle behaviour.
      // Note: Thouse behaviours are used by enemy A.I. which was requested as reinforcement and without enemy contact.
      // Info: [ ["FORMATION"], ["SPEEDMODE"], ["BEHAVIOUR"], ["COMBATMODE"] ]
        // GL4_Global set [5, [ ["COLUMN","LINE"], ["NORMAL","NORMAL","FULL","FULL"], ["SAFE","SAFE","AWARE","AWARE"], ["WHITE","WHITE","YELLOW","YELLOW"] ] ];

      // Enemy A.I. Reinforcement Behaviour: ( Combat )
      // Choose the enemy A.I. combat behaviour.
      // Note: Thouse behaviours are used by enemy A.I. which was requested as reinforcement and with enemy contact.
      // Info: [ ["FORMATION"], ["SPEEDMODE"], ["BEHAVIOUR"], ["COMBATMODE"] ]
        // GL4_Global set [6, [ ["COLUMN","WEDGE","VEE","LINE","FILE","DIAMOND"], ["NORMAL","NORMAL","FULL","FULL"], ["AWARE","AWARE","COMBAT","COMBAT"], ["YELLOW","YELLOW","RED","RED"] ] ];

      // Enemy A.I. Reinforcement Distance:
      // Choose the distance in which enemy A.I. should be able to request reinforcement.
      // Note: Enemy A.I. which had spotted a enemy will be able to request reinforcement which is within the given range.
      // Example: If enemy A.I. which do not use a vehicle had spotted a enemy then they will be able to request reinforcement which is within a range of 3000 meters to their position.
      // Example: If enemy A.I. which use a tank had spotted a enemy then they will be able to request reinforcement which is within a range of 10000 meters to their position.
      // 0 - 50000, default is [ ["Man", 3000], ["Car", 7000], ["Tank", 10000], ["Air", 30000], ["Ship", 30000] ]
        // GL4_Global set [7, [ ["Man", 3000], ["Car", 7000], ["Tank", 10000], ["Air", 30000], ["Ship", 30000] ] ];

      // Enemy A.I. Reinforcement Delay:
      // Choose how fast enemy A.I. should be able to request reinforcement.
      // Note: If this value is set too high and enemy A.I. was killed within this time then it may can be that the enemy A.I. had no chance to request reinforcement.
      // 0 - 30, default is 5 seconds
        // GL4_Global set [8, 5];

    // ==============================================================
    // GL4 Enemy A.I. Artillery:
    // ==============================================================
    // Choose if enemy A.I. should be able to request artillery.
    // True / False, default is True
      // GL4_Global set [9, False];

      // Enemy A.I. Artillery Request Ranks:
      // Choose which enemy A.I. ranks are allowed to request artillery.
      // Available Ranks: PRIVATE | CORPORAL | SERGEANT | LIEUTENANT | CAPTAIN | MAJOR | COLONEL
      // Default: ["SERGEANT","LIEUTENANT","CAPTAIN","MAJOR","COLONEL"]
        // GL4_Global set [10, ["SERGEANT","LIEUTENANT","CAPTAIN","MAJOR","COLONEL"] ];

      // Enemy A.I. Artillery Chance:
      // Choose the chance of how enemy A.I. should be able to request artillery.
      // 0 - 100, default is 50%
        // GL4_Global set [11, 50];

      // Enemy A.I. Artillery Ammo:
      // Choose which type of ammo enemy A.I. artillery should use.
      // Available ammo classes: "Sh_82mm_AMOS", "Sh_120_HE", "Sh_120_SABOT", "Sh_122_HE", "Sh_125_HE", "Sh_125_SABOT", "Bomb", "Grenade"
      // Default: "Sh_125_HE"
        // GL4_Global set [12, "Sh_82mm_AMOS"];

    // ==============================================================
    // GL4 Enemy A.I. Airstrike:
    // ==============================================================
    // Choose if enemy A.I. should be able to request airstrike.
    // True / False, default is True
      // GL4_Global set [13, False];

      // Enemy A.I. Airstrike Request Ranks:
      // Choose which enemy A.I. ranks are allowed to request airstrike.
      // Available Ranks: PRIVATE | CORPORAL | SERGEANT | LIEUTENANT | CAPTAIN | MAJOR | COLONEL
      // Default: ["SERGEANT","LIEUTENANT","CAPTAIN","MAJOR","COLONEL"]
        // GL4_Global set [14, ["SERGEANT","LIEUTENANT","CAPTAIN","MAJOR","COLONEL"] ];

      // Enemy A.I. Airstrike Chance:
      // Choose the chance of how enemy A.I. should be able to request airstrike.
      // 0 - 100, default is 50%
        // GL4_Global set [15, 50];

      // Enemy A.I. Airstrike Ammo:
      // Choose which type of ammo enemy A.I. airstrike should use.
      // Available ammo classes: "B_25mm_HE", "Bo_GBU12_LGB", "M_Sidewinder_AA", "M_R73_AA", "Sh_82mm_AMOS", "B_30mm_HE", "M_Ch29_AT", "B_30mmA10_AP", "M_Maverick_AT", "R_Hydra_HE" 
      // Default: "Sh_82mm_AMOS"
         GL4_Global set [16, "Bo_GBU12_LGB_MI10"];

    // ==============================================================
    // GL4 Enemy A.I. Behaviours ( Combat )
    // ==============================================================

      // GL4 Enemy A.I. House Search:
      // Choose if enemy A.I. should be able to search houses.
      // True / False, default is True
        // GL4_Global set [17, False];

      // GL4 Enemy A.I. Car Weapon:
      // Choose if enemy A.I. should be able to search and mount cars with weapon.
      // True / False, default is True
        // GL4_Global set [18, False];

      // GL4 Enemy A.I. Helicopter Paradrop:
      // Choose if enemy A.I. should be able to paradrop.
      // True / False, default is True
        // GL4_Global set [19, False];

      // GL4 Enemy A.I. Helicopter Behaviour:
      // Choose the chance of how enemy A.I. should react after the crew of a helicopter was ejected.
      // Note: High value means that the helicopter will retread to his original position.
      //       Low value means that the helicopter will stay and randomly scout the area.
      // 0 - 100, default is 75%
        // GL4_Global set [20, 75];

      // GL4 Enemy A.I. Helicopter Extraction:
      // Choose if enemy A.I. should be able to fly a extraction.
      // True / False, default is True
        // GL4_Global set [21, False];

      // GL4 Enemy A.I. Smoke Man:
      // Choose if enemy A.I. without vehicle should be able to use smoke for cover.
      // True / False, default is True
        // GL4_Global set [22, False];

      // GL4 Enemy A.I. Smoke Vehicle:
      // Choose if enemy A.I. with vehicle should be able to use smoke for cover.
      // True / False, default is True
        // GL4_Global set [23, False];

      // GL4 Enemy A.I. Flares:
      // Choose if enemy A.I. should be able to use flares at night.
      // True / False, default is True
        // GL4_Global set [24, False];

      // GL4 Enemy A.I. Combat Tactics:
      // Choose if enemy A.I. should be able to split the group into several smaller groups to advance from several directions.
      // True / False, default is True
        // GL4_Global set [25, False];

      // GL4 Enemy A.I. Rearm:
      // Choose if enemy A.I. should be able to rearm if they are running out of ammo.
      // True / False, default is True
        // GL4_Global set [26, False];

    // ==============================================================
    // GL4 Enemy A.I. Behaviours ( Idle )
    // ==============================================================

      // GL4 Enemy A.I. Idle:
      // Choose if enemy A.I. should use the Human A.I. feature.
      // True / False, default is True
        // GL4_Global set [27, False];

      // GL4 Enemy A.I. Garrison:
      // Choose if enemy A.I should be able to garrison buildings.
      // True / False, default is True
        // GL4_Global set [28, False];

      // GL4 Enemy A.I. Static Weapons:
      // Choose if enemy A.I. should be able to mount empty static weapons.
      // True / False, default is True
        // GL4_Global set [29, False];

      // GL4 Enemy A.I. Body Detect:
      // Choose if enemy A.I. should be able to detected dead bodys.
      // True / False, default is True
        // GL4_Global set [30, False];

      // GL4 Enemy A.I. Detection:
      // Choose if enemy A.I. should be able to hear and react if a vehicle was exploded nearby.
      // True / False, default is True
        // GL4_Global set [31, False];

    // ==============================================================
    // GL4 Enemy A.I. Advancing:
    // ==============================================================
    // Choose if enemy A.I. should be able to hear and react to gunfire.
    // True / False, default is True
      // GL4_Global set [32, False];

      // Enemy A.I. Advancing Smoke: ( New )
      // ==============================================================
      // Choose which smoke shells/grenades can be detected by enemy A.I.
      // Smoke shells/grenades listed in this array can be detected by enemy A.I. within a range of 100 meters.
      // Default: ["SmokeShell","SmokeShellYellow","SmokeShellRed","SmokeShellGreen","SmokeShellPurple","SmokeShellBlue","SmokeShellOrange","G_40mm_Smoke","G_40mm_SmokeRed","G_40mm_SmokeGreen","G_40mm_SmokeYellow"]
        // GL4_Global set [33, (GL4_Global select 33) + [] ];

      // Enemy A.I. Advancing Smoke Distance:
      // Choose in which range enemy A.I. should react to dropped smoke shells/grenades.
      // Note: This value set how close smoke shells/grenades have to be dropped within the enemy A.I. position.
      // Warning: Do not set this value higher then 100 meters else enemy A.I. will react to smoke shells/grenades even if it was dropped more then 100 meters away from their position.
      // 0 - 100, default is 100 meters
        // GL4_Global set [34, 100];

      // Enemy A.I. Advancing Weapons:
      // ==============================================================
      // Choose which weapons and ammo should be heared by enemy A.I. within wich range.
      // Note: Weapons which are not listed in thouse arrays can heared by enemy A.I. from the "Rifle Distance" distance.

      // Weapons and Ammo listed in this array can heared by enemy A.I. within a range of 15 meters.
      // Default: ["M4A1SD","MP5SD","M9SD","MakarovSD","B_556x45_SD","B_556x45_SD"]
        // GL4_Global set [35, (GL4_Global select 35) + [] ];

      // Muzzles and Ammo listed in this array can heared by enemy A.I. within a range of 50 meters.
      // Default: ["M203Muzzle","GP25Muzzle","G_40mm_HE"]
        // GL4_Global set [36, (GL4_Global select 36) + [] ];

      // Weapons and Ammo listed in this array can heared by enemy A.I. within a range of 300 meters.
      // Default: ["launch_B_Titan_short_F","launch_B_Titan_F","launch_I_Titan_short_F","launch_RPG32_F","launch_Titan_F","M9","Makarov","B_9x19_Ball","R_launch_B_Titan_short_F_AT","launch_Titan_short_F"]
        // GL4_Global set [37, (GL4_Global select 37) + [] ];

      // Enemy A.I. Advancing Suppressed Weapons Distance:
      // Choose in which range enemy A.I. can hear suppressed "M9SD/MP5SD/M4A1SD/MakarovSD" weapons.
      // 0 - 100, default is 15 meters
        // GL4_Global set [38, 15];

      // Enemy A.I. Advancing Grenade Launcher Distance:
      // Choose in which range enemy A.I. can hear Grenade Launcher "M16A2GL/M4GLAK74GL" weapons.
      // 0 - 300, default is 50 meters
        // GL4_Global set [39, 50];

      // Enemy A.I. Advancing Pistoles and Rocket Launcher Distance:
      // Choose in which range enemy A.I. can hear Pistoles/Rocket Launcher "M9/Makarov/launch_B_Titan_short_F/launch_B_Titan_F/launch_RPG32_F" weapons.
      // 0 - 500, default is 300 meters
        // GL4_Global set [40, 300];

      // Enemy A.I. Advancing Rifle Distance:
      // Choose in which range enemy A.I. can hear Rifles/Assault Rifles "M16A2/M16A4/M4AIM/M4A1/AK74" weapons.
      // 0 - 1500, default is 600 meters
        // GL4_Global set [41, 600];

    // ==============================================================
    // GL4 Enemy A.I. Suppressive Fire:
    // ==============================================================
    // Choose if enemy A.I. should react to suppressive fire.
    // True / False, default is True
      // GL4_Global set [42, False];

      // Enemy A.I. Suppressive Fire Bullets Rate:
      // Choose how fast ( in which rate of time ) the bullets must be fired to suppress enemy A.I.
      // 0 - 0.50, default is 0.20 seconds
        // GL4_Global set [43, 0.20];

      // Enemy A.I. Suppressive Fire Bullets Requied:
      // Choose how many bullets must be fired within the given "Fire Bullets Rate" to suppress enemy A.I.
      // 0 - 30, default is 6 bullets
        // GL4_Global set [44, 6];

    // ==============================================================
    // GL4 Enemy A.I. Difficult Level:
    // ==============================================================
    // True / False, default is True
      // GL4_Global set [45, False];

      // Enemy A.I. Difficult Level Fixed:
      // Choose the difficult level of the enemy A.I.
      // Note: The higher this value the more skilled enemy A.I. will be.
      // 0 - 1, default is 0.10
        // GL4_Global set [46, 0.10];

      // Enemy A.I. Difficult Level Random:
      // Choose the random difficult level of the enemy A.I.
      // Note: This value will randomly increase the "Fixed" value given above.
      // 0 - 1, default is 0.20
        // GL4_Global set [47, 0.20];

      // GL4 Enemy A.I. Difficult Skill Types:
      // ==============================================================
      // Choose the difficult "Skill Types" of the enemy A.I.
      // The difficult "Skill Types" set many abilitys of the enemy A.I. to the given level.
      // Note: If the array contains only one value then this value will be used as "Fixed" value without any modification.
      // Note: If the array contains two values then the first value in the array will be randomly increased by the second value.

      // Enemy A.I. Difficult "Aiming Accuracy" Skill Type:
      // Choose the "Aiming Accuracy" of the enemy A.I.
      // [0.1, 0.1] - [1.0, 1.0], default is [0.35, 0.15]
        // (GL4_Global select 48) set [0, [0.35, 0.15] ];

      // Enemy A.I. Difficult "Aiming Shake" Skill Type:
      // Choose the "Aiming Shake" of the enemy A.I.
      // [0.1, 0.1] - [1.0, 1.0], default is [0.50, 0.35]
        // (GL4_Global select 48) set [1, [0.50, 0.35] ];

      // Enemy A.I. Difficult "Aiming Speed" Skill Type:
      // Choose the "Aiming Speed" of the enemy A.I.
      // [0.1, 0.1] - [1.0, 1.0], default is [0.50, 0.35]
        // (GL4_Global select 48) set [2, [0.50, 0.35] ];

      // Enemy A.I. Difficult "Endurance" Skill Type:
      // Choose the "Endurance" of the enemy A.I.
      // [0.1, 0.1] - [1.0, 1.0], default is [1]
        // (GL4_Global select 48) set [3, [1] ];

      // Enemy A.I. Difficult "Spot Distance" Skill Type:
      // Choose the "Spot Distance" of the enemy A.I.
      // [0.1, 0.1] - [1.0, 1.0], default is [1]
        // (GL4_Global select 48) set [4, [1] ];

      // Enemy A.I. Difficult "Spot Time" Skill Type:
      // Choose the "Spot Time" of the enemy A.I.
      // [0.1, 0.1] - [1.0, 1.0], default is [0.35, 0.15]
        // (GL4_Global select 48) set [5, [0.35, 0.15] ];

      // Enemy A.I. Difficult "Courage" Skill Type:
      // Choose the "Courage" of the enemy A.I.
      // [0.1, 0.1] - [1.0, 1.0], default is [0.75, 0.25]
        // (GL4_Global select 48) set [6, [0.75, 0.25] ];

      // Enemy A.I. Difficult "Reload Speed" Skill Type:
      // Choose the "Reload Speed" of the enemy A.I.
      // [0.1, 0.1] - [1.0, 1.0], default is [0.70]
        // (GL4_Global select 48) set [7, [0.70] ];

      // Enemy A.I. Difficult "Commanding" Skill Type:
      // [0.1, 0.1] - [1.0, 1.0], default is [1]
        // (GL4_Global select 48) set [8, [1] ];

      // Enemy A.I. Difficult "General" Skill Type:
      // [0.1, 0.1] - [1.0, 1.0], default is 1]
        // (GL4_Global select 48) set [9, [1] ];

      // GL4 Enemy A.I. Difficult "Class and Rank" Skill Types: ( New )
      // ==============================================================
      // Choose the difficult "Skill Types" of specific enemy A.I. classes and ranks.
         GL4_Global set [49, call compile preprocessFile "enemy\modules\GL4_Settings\GL4_Skill_Types.sqf" ];

    // ==============================================================
    // GL4 Enemy A.I. Surrender:
    // ==============================================================
    // Choose if enemy A.I. should be able to surrender if they are fleeing.
    // True / False, default is True
      // GL4_Global set [50, False];

      // Enemy A.I. Surrender Courage Fixed:
      // Choose the enemy A.I. surrender courage.
      // Note: The higher this value the higher the chance that enemy A.I. will surrender.
      // 0 - 1, default is 0.1
        // GL4_Global set [51, 0.1];

      // Enemy A.I. Surrender Courage Random:
      // Choose the random enemy A.I. surrender courage.
      // Note: This value will randomly increase the "Fixed" value given above.
      // 0 - 1, default is 0.5
        // GL4_Global set [52, 0.5];

      // Enemy A.I. Surrender Rank Chance:
      // Choose the chance of how fast enemy A.I. with a specific rank should be able to surrender.
      // 0 - 100, default is PRIVATE: 70% | CORPORAL: 60% | SERGEANT: 50% | LIEUTENANT: 40% | CAPTAIN: 30% | MAJOR: 20% | Colonel: 10%
        // GL4_Global set [53, [70, 60, 50, 40, 30, 20, 10] ];

      // Enemy A.I. Surrender Group Size:
      // Choose how much units of a enemy A.I. group must be alive till a unit of the enemy A.I. group will think about surrendering.
      // 1 - 10, default is 3
        // GL4_Global set [54, 3];

      // Enemy A.I. Surrender Friendly Nearby:
      // Choose how much friendly A.I. units have to be nearby that the unit will not surrender.
      // Note: If there are more friendly A.I. units nearby like set here then the unit will not surrender.
      // 0 - 100, default is 5
        // GL4_Global set [55, 5];

      // Enemy A.I. Surrender Captive Player:
      // Choose how many captives each player can capture at the same time.
      // 0 - 10, default is 3
        // GL4_Global set [56, 3];

      // Enemy A.I. Surrender Fleeing Chance:
      // Choose the chance of how enemy A.I. which already was captured by a player will try fleeing.
      // 0 - 100, default is 5%
        // GL4_Global set [57, 5];

    // ==============================================================
    // GL4 Enemy A.I. Simulate Dead: ( New )
    // ==============================================================
    // Choose if enemy A.I. should be able to simulate dead if no friendly A.I. is nearby.
    // True / False, default is True
      // GL4_Global set [58, False];

      // Enemy A.I. Simulate Dead Chance:
      // Choose the chance of how enemy A.I. should simulate dead.
      // 0 - 100, default is 15%
        // GL4_Global set [59, 15];

      // Enemy A.I. Simulate Dead Friendly Nearby:
      // Choose how much friendly A.I. units have to be nearby that the unit will not simulate dead.
      // Note: If there are more friendly A.I. units nearby like set here then the unit will not simulate dead.
      // 0 - 100, default is 5
        // GL4_Global set [60, 5];

  // ==============================================================
  // 2.) GL4 Enemy A.I. Debug:
  // ==============================================================

    // GL4 Enemy A.I. Array:
    // ==============================================================
    // Choose if the "Array" debug should be used.
    // Note: This debug shows the most important enemy A.I. arrays.
    // True / False, default is False
       GL4_Global set [61, True];

    // GL4 Enemy A.I. Map Marker:
    // ==============================================================
    // Choose if the "Map Marker" debug should be used.
    // Note: This debug creates a map marker for each enemy A.I. group.
    // True / False, default is True
      // GL4_Global set [62, False];

      // Enemy A.I. Map Marker Type:
      // Choose which "Map Marker Type" should be used.
      // Note: Choose True to enable millitary markers.
      // "Dot", "Arrow", "Select", "Destroy" / True, default is True
      //   GL4_Global set [63, "Mil_Dot"];

  // ==============================================================
  // 3.) GL4 Friendly A.I. Enhancement:
  // ==============================================================

    // GL4 Friendly A.I. Recruit:
    // ==============================================================
    // Choose if friendly A.I.can be recruited by a player.
    // True / False, default is True
      // GL4_Global set [64, False];

      // Friendly A.I. Recruit Ranks:
      // Choose which ranks are allowed to recruit friendly A.I. beside the group leader.
      // Available Ranks: PRIVATE | CORPORAL | SERGEANT | LIEUTENANT | CAPTAIN | MAJOR | COLONEL
      // Default: ["SERGEANT","LIEUTENANT","CAPTAIN","MAJOR","COLONEL"]
        // GL4_Global set [65, ["SERGEANT","LIEUTENANT","CAPTAIN","MAJOR","COLONEL"] ];

    // GL4 Friendly A.I. Advancing and Suppressed: ( New )
    // ==============================================================
    // Choose if friendly A.I. should be able to use the "Advancing" and "Suppressed" feature.
    // Note: This feature gives friendly A.I. the ability to suppress enemy A.I. and make enemy A.I. hear gunfire from friendly A.I.
    // True / False, default is False
      // GL4_Global set [66, True];

  // ==============================================================
  // 4.) GL4 System Enhancement:
  // ==============================================================

    // GL4 Get In:
    // ==============================================================
    // Choose if A.I. which is within 10 meters to a empty vehicle should mount the vehicle at mission start.
    // Note: This feature was made to overcome the assignment with the "moveInDriver", "moveInGunner" and "moveInCarog" command.
    // True / False, default is True
      // GL4_Global set [67, False];

    // GL4 Body Remove:
    // ==============================================================
    // Choose if dead A.I. should be removed after a specific amount of dead bodys was reached or if players are in a specific range to the dead A.I.
    // True / False, default is True
      // GL4_Global set [68, False];

    // GL4 Re-Initialize:
    // ==============================================================
    // Choose which classes should be re-initialized.
    // Note: The re-initialize is used to initialize units and vehicles which was created ( spawned ) after a mission was started.
    // ["Class","Class"], default is ["Man","Car","Tank","Air"]
       GL4_Global set [69, ["Man","Car","Tank","Air","StaticMortar"] ];