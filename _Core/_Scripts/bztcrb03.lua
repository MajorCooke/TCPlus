--bztcrb03 - Battlezone Total Command - The Red Brigade - 3/8 - THE EVIL BATTLION
assert(load(assert(LoadFile("_requirefix.lua")),"_requirefix.lua"))();
TCC = require("TC_Core")
MisnNum = 28;
--DECLARE variables --f-friend, e-enemy, atk-attack, rcy-recycler, etc..., 
local index = 1
local index2 = 1
local x = {
	FIRST = true,
	spine = 0,
	getiton = false, 
	MCAcheck = false,
	waittime = 99999.9,
	player = nil, 
	mytank = nil, 
	skillsetting = 0,
	easy = 0, 
	medium = 1, 
	hard = 2, --tried 1-3, in 185, 3 didn't seem to make any difference, 
	pos = {}, 
	audio1 = nil, 
	casualty = 0, 
	fnav = {},
	fgrp = {},
	ftur = {}, 
	free_player = false, --dropship
	controls = {braccel = 0, strafe = 0, jump = 0, deploy = 0, eject = 0, abandon = 0, fire = 0},	
	fdrp = {}, 
	holder = {}, 
	failtime = 99999.9, 
	whine = 0, 
	whinetime = 99999.9, 
	ercy = nil,
	epat = {}, 
	epatstate = 0, 
	egun = {}, 
	egundead = 0, 
	egundeadtime = 99999.9, 
	eatk = {}, --patrol
	eatkgun = {}, --if gun tower killed
	eatkreturn = {}, --return atk after ercy dead
	eatkcut = {}, --cutoff force
	proxmine = {}, 
	etur = {}, 
	eart = {}, 
	gutcheck = 0, 
	gotgatl = false,
	LAST = true
}
--Paths: ftur1-4, fpmeet1-2, fnav1-2, epgfac, bdstrig1-3, ppatrol1-3, epcut1-4, pcutoff, pmine1-30, epend

function InitialSetup()
	SetAutoGroupUnits(true)
	
	local odfpreload = {
		"bvartl", "bvturr", "bvrecy", "bvscout", "bvmbike", "bvmisl", "bvtank", "bvrckt",	
		"svturr", "svrckt", "ggatls_c", "ggrens", "grktps", "oproxa", "stayput", "apcamrs", "radjam"
	}
	for k,v in pairs(odfpreload) do
		PreloadODF(v)
	end

	x.ercy = GetHandle("ercy")
	x.fdrp[1] = GetHandle("fdrp1")
	x.fdrp[2] = GetHandle("fdrp2")
	x.mytank = GetHandle("mytank")
	x.egun[1] = GetHandle("egun1")
	x.egun[2] = GetHandle("egun2")
	for index = 1, 10 do
		x.fgrp[index] = GetHandle(("fgrp%d"):format(index))
	end
	for index = 1, 4 do
		x.ftur[index] = GetHandle(("ftur%d"):format(index))
	end
	Ally(1, 4)
	Ally(4, 1) --4 turrets
	SetColorFade(6.0, 0.5, "BLACK")
	TCC.Init();
end

function Start()
	TCC.Start();
end
function Save()
	return
	index, index2, x, TCC.Save()
end

function Load(a, b, c, coreData)
	index = a;
	index2 = b;
	x = c;
	TCC.Load(coreData)
end

function DeleteObject(h)
	TCC.DeleteObject(h);
end

function ObjectKilled(DeadObjectHandle, KillersHandle)
	return TCC.ObjectKilled(DeadObjectHandle, KillersHandle);
end

function PreSnipe(world, shooter, victim, OrdTeam, OrdODF)
	return TCC.PreSnipe(world, shooter, victim, OrdTeam, OrdODF);
end

function PreGetIn(world, pilot, craft)
	return TCC.PreGetIn(world, pilot, craft);
end

function PrePickupPowerup(world, who, item)
	return TCC.PrePickupPowerup(world, who, item);
end

function PostTargetChangedCallback(craft, prev, cur)
	TCC.PostTargetChangedCallback(craft, prev, cur);
end

function Update()
	x.player = GetPlayerHandle() --EVERY PASS SO IF PLAYER CHANGES VEHICLES
	x.skillsetting = IFace_GetInteger("options.play.difficulty")
	TCC.Update();
	--Set up mission basics
	if x.spine == 0 then
		x.pos = GetTransform(x.mytank)
		RemoveObject(x.mytank)
		x.mytank = BuildObject("svrckt", 1, x.pos)
		SetCurAmmo(x.mytank, 6000)
		SetAsUser(x.mytank, 1)
		RemoveObject(x.player)
		x.player = GetPlayerHandle()
		for index = 1, 10 do
			x.etur[index] = BuildObject("bvturr", 5, ("eptur%d"):format(index))
			SetSkill(x.etur[index], x.skillsetting)
		end
		for index = 1, 4 do
			x.pos = GetTransform(x.ftur[index])
			RemoveObject(x.ftur[index])
			x.ftur[index] = BuildObject("svturr", 4, x.pos)
			SetSkill(x.ftur[index], x.skillsetting)
			x.eart[index] = BuildObject("bvartl", 5, ("epart%d"):format(index))
			--DUMB ARTILLERY SetSkill(x.eart[index], x.skillsetting)
		end
		for index = 1, 6 do
			x.pos = GetTransform(x.fgrp[index])
			RemoveObject(x.fgrp[index])
			x.fgrp[index] = BuildObject("svrckt", 1, x.pos)
			SetSkill(x.fgrp[index], x.skillsetting)
		end
		for index = 7, 8 do
			x.pos = GetTransform(x.fgrp[index])
			RemoveObject(x.fgrp[index])
			if x.skillsetting >= x.medium then
				x.fgrp[index] = BuildObject("svrckt", 1, x.pos)
				SetSkill(x.fgrp[index], x.skillsetting)
			end
		end
		for index = 9, 10 do
			x.pos = GetTransform(x.fgrp[index])
			RemoveObject(x.fgrp[index])
			if x.skillsetting >= x.hard then
				x.fgrp[index] = BuildObject("svrckt", 1, x.pos)
				SetSkill(x.fgrp[index], x.skillsetting)
			end
		end
		for index = 1, 3 do
			x.epat[index] = {}
			for index2 = 1, 5 do
				x.epat[index][index2] = nil
			end
		end
		AudioMessage("tcrb0301.wav") --INTRO - BDogs atking 6th Battalion. Kill recy w/ gren. Avoid detc
		x.spine = x.spine + 1
	end

	--DROPSHIP LANDING SEQUENCE - START QUAKE FOR FLYING EFFECT
	if x.spine == 1 then
		for index = 1, 2 do
			for index2 = 1, 4 do --CCA dropship 4 emits
				StopEmitter(x.fdrp[index], index2)
			end
		end
		for index = 1, 10 do
			Stop(x.fgrp[index])
			x.holder[index] = BuildObject("stayput", 0, x.fgrp[index])
		end
		for index = 11, 14 do
			Stop(x.ftur[index])
			x.holder[index] = BuildObject("stayput", 0, x.ftur[index])
		end
    x.holder[15] = BuildObject("radjam", 5, x.player)
		x.holder[16] = BuildObject("stayput", 0, x.player) --fdrp1 dropship 1
		StartEarthQuake(10.0)
		x.waittime = GetTime() + 4.0
		x.spine = x.spine + 1
	end

	--LANDING - MAKE QUAKE BIGGERR
	if x.spine == 2 and x.waittime < GetTime() then
		UpdateEarthQuake(50.0)
		x.waittime = GetTime() + 3.0
		x.spine = x.spine + 1
	end
	
	--HAVE LANDED - STOP QUAKE
	if x.spine == 3 and x.waittime < GetTime() then
		StopEarthQuake()
		x.waittime = GetTime() + 2.0
		x.spine = x.spine + 1
	end

	--OPEN DROPSHIP DOORS, REMOVE HOLDERS
	if x.spine == 4 and x.waittime < GetTime() then
		StartSoundEffect("dropdoor.wav")
		SetAnimation(x.fdrp[1], "open", 1)
		SetAnimation(x.fdrp[2], "open", 1)
		for index = 1, 15 do
			RemoveObject(x.holder[index])
		end
		x.waittime = GetTime() + 5.0
		x.spine = x.spine + 1
	end
	
	--DOORS FULLY OPEN, GIVE MOVE ORDER
	if x.spine == 5 and x.waittime < GetTime() then
		for index = 1, 4 do
			Goto(x.ftur[index], ("fptur%d"):format(index), 0)
		end
		x.waittime = GetTime() + 5.0
		x.spine = x.spine + 1
	end
	
	--SPECIAL SPECIAL ------WAIT FOR TURR TO MOVE BEFORE REST
	if x.spine == 6 and x.waittime < GetTime() then
		for index = 1, 5 do
			Goto(x.fgrp[index], "fpmeet1", 0)
			SetGroup(x.fgrp[index], 0)
		end
		for index = 6, 10 do
			Goto(x.fgrp[index], "fpmeet2", 0)
			SetGroup(x.fgrp[index], 1)
		end
		x.waittime = GetTime() + 1.0
		x.spine = x.spine + 1
	end

	--GIVE PLAYER CONTROL OF THEIR AVATAR
	if x.spine == 7 and x.waittime < GetTime() then
		RemoveObject(x.holder[16])  --8?
		x.free_player = true
		x.spine = x.spine + 1
	end
	
	--CHECK IF PLAYER HAS LEFT DROPSHIP --DROPSHIPS REMAIN
	if x.spine == 8 then
		x.player = GetPlayerHandle()
		if IsCraftButNotPerson(x.player) and GetDistance(x.player, x.fdrp[1]) > 60 then
			x.fnav = BuildObject("apcamrs", 1, "fnav1")
			SetObjectiveName(x.fnav, "Dustoff")
			x.fnav = BuildObject("apcamrs", 1, "fnav2")
			SetObjectiveName(x.fnav, "BDS Outpost")
			ClearObjectives()
			AddObjective("tcrb0301.txt")  
			x.failtime = GetTime() + 361.0
			StartCockpitTimer(360, 180, 90)
			x.whinetime = GetTime() + 80.0 
			x.spine = x.spine + 1
		end
	end

	--ACTIVATE GUTCHECK
	if x.spine == 9 and IsAlive(x.fdrp[1]) and GetDistance(x.player, "fnav1") > 200 and GetDistance(x.player, x.fdrp[1]) > 200 then
		x.gutcheck = 1
		x.spine = x.spine + 1
	end
	
	--BDS RECYCLER KILLED
	if x.spine == 10 and not IsAlive(x.ercy) then --erecy killed
		AudioMessage("tcrb0302.wav") --BDogs pulling back. Get back to base quick before cut off	
		ClearObjectives()
		AddObjective("tcrb0305.txt", "GREEN")
		AddObjective("tcrb0306.txt")
		x.failtime = 99999.9
		StopCockpitTimer()
		HideCockpitTimer()
		for index = 1, 30 do --prox mines
			x.proxmine[index] = BuildObject("oproxa", 5, ("pmine%d"):format(index))
		end
		for index = 1, 3 do
			x.eatkreturn[index] = BuildObject("bvtank", 5, ("bdstrig%d"):format(index))
			SetSkill(x.eatkreturn[index], x.skillsetting)
		end
		x.eatkcut[1] = BuildObject("bvmbike", 5, "epcut1")
		x.eatkcut[2] = BuildObject("bvmisl", 5, "epcut2")
		x.eatkcut[3] = BuildObject("bvtank", 5, "epcut3")
		x.eatkcut[4] = BuildObject("bvrckt", 5, "epcut4")
		for index = 1, 4 do
			SetSkill(x.eatkcut[index], x.skillsetting)
			Patrol(x.eatkcut[index], "pcutoff")
		end
		x.waittime = GetTime() + 6.0
		x.whine = 3
		x.gutcheck = 3
		x.spine = x.spine + 1
	end
	
	--RTB OBJECTIVE
	if x.spine == 11 and x.waittime < GetTime() then
		ClearObjectives()
		AddObjective("tcrb0302.txt")
		x.spine = x.spine + 1
	end
	
	--PLAYER BACK AT DZ, SUCCEED MISSION
	if x.spine == 12 and GetDistance(x.player, "fnav1") < 100 then
		AudioMessage("tcrb0303.wav") --SUCCEED - Gen impress with my performance
		ClearObjectives()
		AddObjective("tcrb0302.txt", "GREEN")
		TCC.SucceedMission(GetTime() + 11.0, "tcrb03w1.des") --WINNER WINNER WINNER
		x.spine = x.spine + 1
		x.MCAcheck = true
	end
	----------END MAIN SPINE ----------
	
	--ENSURE PLAYER CAN'T DO ANYTHING WHILE IN DROPSHIP ----------------------------
	if not x.free_player then
		x.controls = {braccel = 0, strafe = 0, jump = 0, deploy = 0, eject = 0, abandon = 0, fire = 0}
		SetControls(x.player, x.controls)
	end
	
	--GIVE PLAYER PILOT DIFFERENT GUN (has to be done like this)
	if not x.gotgatl and IsPerson(x.player) then
		GiveWeapon(x.player, "ggatls_c")
		GiveWeapon(x.player, "grktps") --"ggrens")
		x.gotgatl = true
	end
	
	--WHY DON'T YOU WHINE SOME MORE SNOWFLAKE
	if x.whine < 3 and x.whinetime < GetTime() then
		if x.whine == 0 then
			AudioMessage("tcrb0307.wav") --Bdogs atck 6ht. Hurry to help and kill recy.
		elseif x.whine == 1 then
			AudioMessage("tcrb0308.wav") --6th doesn't have much scrap or time.
		elseif x.whine == 2 then
			AudioMessage("tcrb0309.wav") --6th running low on ammo help them 
		end
		x.whine = x.whine + 1
		x.whinetime = GetTime() + 90.0
	end
	
	--BDS BUILD ATTACK IF A GUN TOWER IS KILLED
	if x.egundead == 0 and (not IsAlive(x.egun[1]) or not IsAlive(x.egun[2])) then
		x.eatkgun[1] = BuildObject("bvscout", 5, "epgfac", 1)
		x.eatkgun[2] = BuildObject("bvrckt", 5, "epgfac", 2)
		x.eatkgun[3] = BuildObject("bvtank", 5, "epgfac", 3)
		x.eatkgun[4] = BuildObject("bvmisl", 5, "epgfac", 4)
		x.eatkgun[5] = BuildObject("bvmbike", 5, "epgfac", 5)
		for index = 1, 5 do
			SetSkill(x.eatkgun[index], x.skillsetting)
		end
		x.egundeadtime = GetTime() + 15.0
		x.egundead = x.egundead + 1
	end
	
	--(RE)SEND BDS ATTACK IF GUNTOWER IS KILLED
	if x.egundead == 1 and x.egundeadtime < GetTime() then
		AudioMessage("tcrb0310.wav") --Welcome Red glad you could crash. BDog dest bmbers (Bdog)
		x.egundead = 2
	elseif x.egundead == 2 and x.egundeadtime < GetTime() then
		for index = 1, 5 do
			if IsAlive(x.eatkgun[index]) then
				if IsAlive(x.fgrp[index]) then
					Attack(x.eatkgun[index], x.fgrp[index])
				elseif IsAlive(x.fgrp[index+5]) then
					Attack(x.eatkgun[index], x.fgrp[index+5])
				else
					Attack(x.eatkgun[index], x.player)
				end
			end
		end
		x.egundeadtime = GetTime() + 60.0
	end
	
	--BDS TRIGGERED PATROLS
	if x.epatstate == 0 then
		for index = 1, 3 do
			if not x.epatsent and GetDistance(x.player, ("bdstrig%d"):format(index)) < 200 then
				x.epatstate = x.epatstate + 1
			end
		end
	elseif x.epatstate == 1 then
		AudioMessage("tcrb0311.wav") --An Amer unit is coming your way. Avoid detection.
		x.epat[1][1] = BuildObject("bvtank", 5, "ppatrol1")
		x.epat[1][2] = BuildObject("bvmbike", 5, "ppatrol1")
		x.epat[1][3] = BuildObject("bvmisl", 5, "ppatrol1")
		x.epat[1][4] = BuildObject("bvtank", 5, "ppatrol1")
		x.epat[1][5] = BuildObject("bvmbike", 5, "ppatrol1")
		x.epat[2][1] = BuildObject("bvtank", 5, "ppatrol2")
		x.epat[2][2] = BuildObject("bvmbike", 5, "ppatrol2")
		x.epat[2][3] = BuildObject("bvmisl", 5, "ppatrol2")
		x.epat[2][4] = BuildObject("bvtank", 5, "ppatrol2")
		x.epat[2][5] = BuildObject("bvmbike", 5, "ppatrol2")
		x.epat[3][1] = BuildObject("bvtank", 5, "ppatrol3")
		x.epat[3][2] = BuildObject("bvmbike", 5, "ppatrol3")
		x.epat[3][3] = BuildObject("bvmisl", 5, "ppatrol3")
		x.epat[3][4] = BuildObject("bvtank", 5, "ppatrol3")
		x.epat[3][5] = BuildObject("bvmbike", 5, "ppatrol3")
		for index = 1, 3 do
			for index2 = 1, 5 do 
				SetSkill(x.epat[index][index2], x.skillsetting)
				Patrol(x.epat[index][index2], ("ppatrol%d"):format(index))
			end
		end
		x.epatstate = x.epatstate + 1
	elseif x.epatstate == 2 then
		for index = 1, 3 do
			for index2 = 1, 5 do
				if IsAlive(x.epat[index][index2]) and GetDistance(x.epat[index][index2], "epend") < 100 then
					RemoveObject(x.epat[index][index2])
				end
			end
		end
		for index = 1, 3 do
			for index2 = 1, 5 do
				if not IsAlive(x.epat[index][index2]) then
						x.casualty = x.casualty + 1
				end
			end
		end
		if x.casualty == 15 then
			x.epatstate = x.epatstate + 1
		end
		x.casualty = 0
	end
	
	--CHECK STATUS OF MCA ----------------------------------
	if not x.MCAcheck then	 
		if IsAlive(x.ercy) and x.failtime < GetTime() then --out of time
			AudioMessage("tcrb0304.wav") --FAIL - Bdogs destroy the 6th btln 
			ClearObjectives()
			AddObjective("tcrb0304.txt", "RED")
			TCC.FailMission(GetTime() + 10.0, "tcrb03f1.des") --LOSER LOSER LOSER
			x.spine = 666
			x.MCAcheck = true
		end
		
		if x.gutcheck == 1 and GetDistance(x.player, "fnav1") < 195 and IsAlive(x.ercy) then --coward run --stupid fail cond, but in orig version
			AudioMessage("tcrb0305.wav") --You go wrong way
			x.gutcheck = 2
		elseif x.gutcheck == 2 and IsAlive(x.ercy) and ((GetDistance(x.player, "fnav1") < 50) or (GetDistance(x.player, x.fdrp[1]) < 70) or (GetDistance(x.player, x.fdrp[2]) < 70)) then
			AudioMessage("tcrb0306.wav") --FAIL - you are coward
			ClearObjectives()
			AddObjective("tcrb0303.txt", "RED")
			TCC.FailMission(GetTime() + 14.0, "tcrb03f2.des") --LOSER LOSER LOSER
			x.spine = 666
			x.MCAcheck = true
		end
    
    if not IsAlive(x.fdrp[1]) or not IsAlive(x.fdrp[2]) then
      AddObjective("TRAITOR", "RED")
      TCC.FailMission(GetTime() + 4.0, "tcrb03f2.des") --LOSER LOSER LOSER
			x.spine = 666
			x.MCAcheck = true
		end
	end
end
--[[END OF SCRIPT]]