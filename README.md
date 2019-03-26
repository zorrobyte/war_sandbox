Description:
US forces have been stationed in Stratis with the objective of clearing out the REDFOR occupation in areas of strategic importance. Papa Bear will inform BLUFOR of cleared areas by sending intel to your map.

Objective:
Clear out each red square so the map goes blue. Note: You may encounter enemy en-route, stay frosty!


Features:
CBA_A3 REQUIRED for some features, serveradmin: run on server. Players shouldn't need to run CBA to play.

Built upon MSO: As one of the MSO developers I have based DWS off of the MSO framework for a majority of features If anything, DWS is a testbed for MSO where tested changes are backported.

Stability: I have tested this mission on a Dedicated Server without crashing for up to 8 hours with high playercount. I believe AI local to server causes crashes; however you may notice clients will crash out from time to time as AI is buggy by default and will take out the executable on which it is ran.

Team Killer Lock System: Teamkillers get blackscreen and controls locked, at higher TK levels the player is forced to wait until the point they must ALT+F4 from the game.

Insurgency style checkered squares over urban areas: Red=Enemy or unscouted; Green=Clear.


Installation:
Either copy .pbo file into MPMissions folder in the Arma3 directory or copy editable files into the missions folder under documents.


WIP:
Sidemission module


Bugs/Notes:
NG V1 is a test release, I walked away from Arma 3 after putting in 400 hours into DWS due to burnout. I'm back for BETA, report bugs!

I now have GIT
https://bitbucket.org/zorrobyte/dws

Report bugs here
https://bitbucket.org/zorrobyte/dws/issues?status=new&status=open


Changelog:
NG v2
Hotfix for undefined errors from latest patch
Disabled ambient Air/Sea for now
Updated INS_revive
Updated EOS


NG v1 
Rebase for Arma 3 BETA.
New assets and gameplay.
Now fully built upon the MSO framework.

v28 update
In response to reports of issues of antishoot not working after respawn and stuttering for certain users; I have compiled three different versions dependent on your intended server environment.
v28 - Stock "hybridHC" w/ antishoot fix
v28HC - Specialized for HC, will not spawn enemy without HC present w/ antishoot fix, no caching
V28noHC - Specialized for no HC, no HC slot w/ antishoot fix

v28
- Mission actually ends when AI less than 15
- MP JIP Fasttime
- Dynamic house lighting
- tweaked base layout and slots
- added enemy AI chopper patrols
- VAS updated
- tweaked BTC revive

v25
- Completely rewrote mission from the ground up. Cleaned up a lot of code, added briefings, added mission end if AI < 15, new UPSMON enemypop method and caching, hybrid headlessclient mode and much more!

v19-v24
- Dev versions, not released

v18 hotfix
- Repacked and added HC no HC versions to clear confusion, delete old versions

v18
- Completely fixed shotfire at base script, added HC slot if servers wish to use it (how-to coming soon, follow MSO's WiKi), added/updated Tonic's Gear Dialog, deletes items in ground every ~5 mins and other changes.

v15-v17
- Dev versions

v14
- Fixed numerous bugs, too many to list. Added new features

v07-v13
- Dev versions, not released (yes, been working on it a LOT)

v06
- Optimized, now getting 30+ server FPS. No more ammobox script, for now (issues)

v02-v05
- Dev versions, not released

v01
- First release


License:
You are free to use my work provided you attribute credit to the original authors and redistribute derivatives of work under the same licence. Please see:
This work is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.

This licence may not cover included works from other authors such as: BTC Revive, [KH]Jman's base layout, MSO (they use an Apache Licence, Focht's insurgency style markers. Please check the URLs in the Credits section for applicable licence, if any.

I have used and redistributed included works by other authors in good faith for the benefit of the Arma community. If an issue may arise from the distribution of this software, please email the author at zorrobyte(at)taw(dot)net.

Attribution may be granted by placing or adding to a "credits.txt" file within any distributed files (in the compiled PBO or with the PBO in the archive) and displaying the author name and URL (if applicable) of the original works.

You are granted the ability to mirror or redistribute this file as you see fit.


Credits & Thanks:
- [KH]Jman for his Air Calvary mission for base layout
- Focht for his Seize ground mission for the insurgency style markers
- TAW_Tonic (the original creator of Wasteland) for scripting support, bulletshot base protection, BTC JIP fix and cuppycakes
- BTC for his revive script
- MSO Team for the MSO framework


Forum topic:
- Armaholic forums
- BI forums



- Community Base addons A3 [BETA] 
