--bztcbd06 - Battlezone Total Command - Rise of the Black Dogs - 6/10 - EVACUATE VENUS
assert(load(assert(LoadFile("_requirefix.lua")),"_requirefix.lua"))();
TCC = require("TC_Core")
MisnNum = 20;
local index = 0
local indexadd = 0
local x = {
	FIRST = true, 	
	spine = 0, 
	waittime = 99999.9, 
	MCAcheck = false, 
	player = nil, 
	mytank = nil, 
	skillsetting = 0,
	pos = {}, 
	audio1 = nil, 
	fnav = {},	
	casualty = 0,
	randompick = 0, 
	randomlast = 0,
	fgrp = {}, --1-12 tnk, 13-16 srv
	fgrpstate = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}, 
	fgrptime = {99999.9,99999.9,99999.9,99999.9,99999.9,99999.9,99999.9,99999.9,99999.9,99999.9,99999.9,99999.9,99999.9,99999.9,99999.9,99999.9}, 
	fapc = {},	
	fapcstate = {}, 
	fpilo = {}, 
	fpilostate = {}, 
	fally = nil, --defector
	fallystate = 0, 
	fdrp = nil, 
	fpad = nil, 
	ercy = nil, 
	efac = nil, 
	ehng = nil, 
	eatk = {}, 
	easn = {}, 
	easnstate = 0, 
	easntime = 99999.9, 
	etur = {}, 
	pool = nil, 
	LAST = true
}
--PATHS: pmytank, fpgrp(0-12), epmine(0-50), eptur(0-38), fpapc1-2, pool, fppilo(0-16), fpnav1-3, fppark1-2, fpally, epasn1-4(0-4), defectarea, walkerarea, stage1(0-2), epdefasn(0-4)

function InitialSetup()
	SetAutoGroupUnits(true)
		
	local odfpreload = {
		"mvscout", "mvmbike", "mvmisl", "mvtank", "mvrckt", "mvturr", "mvwalk", "oproxars04", "scrfld4g", 
		"bvscout", "bvmbike", "bvmisl", "bvtank", "bvrckt", "bspilo", "bvdrop", "avapcfake", "apserv", "ablpad", "apcamrb" 
	}
	for k,v in pairs(odfpreload) do
		PreloadODF(v)
	end
	
	x.fdrp = GetHandle("fdrp")
	x.ercy = GetHandle("ercy")
	x.efac = GetHandle("efac")
	x.ehng = GetHandle("ehng")
	x.fpad = GetHandle("fpad")
	Ally(1, 4)
	Ally(4, 1)
	SetColorFade(6.0, 0.5, "BLACK")
	TCC.InitialSetup();
end

function Start()
	TCC.Start();
end

function Save()
	return
	index, indexadd, x, TCC.Save()
end

function Load(a, b, c, coreData)
	index = a;
	indexadd = b;
	x = c;
	TCC.Load(coreData)
end

function AddObject(h)
	for indexadd = 1, 16 do --leave no man behind
		if x.fgrpstate[indexadd] == 0 and IsPerson(x.fgrp[indexadd]) then
			x.fgrptime[indexadd] = GetTime() + 20.0 --in case pilot hopout
			x.fgrpstate[indexadd] = 1
		elseif x.fgrpstate[indexadd] == 1 and x.fgrptime[indexadd] < GetTime and IsPerson(x.fgrp[indexadd]) then
			Retreat(x.fgrp[indexadd], "fpnav2")
			x.fgrpstate[indexadd] = 2
		elseif x.fgrpstate[indexadd] == 1 and x.fgrptime[indexadd] < GetTime and IsCraftButNotPerson(x.fgrp[indexadd]) then
			x.fgrpstate[indexadd] = 0
		end
	end
	TCC.AddObject(h);
end

function DeleteObject(h)
	TCC.DeleteObject(h);
end

function ObjectKilled(DeadObjectHandle, KillersHandle)
	TCC.ObjectKilled(DeadObjectHandle, KillersHandle);
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
	--START THE MISSION BASICS
	if x.spine == 0 then
		x.audio1 = AudioMessage("tcbd0601.wav") --escort apc, pickup bdog soldiers
		x.mytank = BuildObject("bvtank", 1, "pmytank")
		GiveWeapon(x.mytank, "gchana_c")
		SetAsUser(x.mytank, 1)
		RemoveObject(x.player)
		x.player = GetPlayerHandle()
		x.pos = GetTransform(x.fpad)
		RemoveObject(x.fpad)
		x.fpad = BuildObject("ablpad", 1, x.pos)
		for index = 1, 3 do --12 units player
			x.fgrp[index] = BuildObject("bvmbike", 1, "fpgrp", index)
			GiveWeapon(x.fgrp[index], "gfafma_c")
			SetSkill(x.fgrp[index], 3)
			SetGroup(x.fgrp[index], 0)
			x.fgrp[index+3] = BuildObject("bvmisl", 1, "fpgrp", index+3)
			SetSkill(x.fgrp[index+3], 3)
			SetGroup(x.fgrp[index+3], 0)
			x.fgrp[index+6] = BuildObject("bvtank", 1, "fpgrp", index+6)
			GiveWeapon(x.fgrp[index+6], "gchana_c")
			SetSkill(x.fgrp[index+6], 3)
			SetGroup(x.fgrp[index+6], 1)
			x.fgrp[index+9] = BuildObject("bvrckt", 1, "fpgrp", index+9)
			SetSkill(x.fgrp[index+9], 3)
			SetGroup(x.fgrp[index+9], 1)
		end
		for index = 1, 2 do --apcs
			x.fapc[index] = BuildObject("avapcfake", 4, ("fpapc%d"):format(index))
      SetObjectiveName(x.fapc[index], ("RESCUE APC %d"):format(index))
			Goto(x.fapc[index], ("fpapc%d"):format(index))
			x.fapcstate[index] = 0
		end
		for index = 13, 16 do --service
			x.fgrp[index] = BuildObject("avserv", 4, "fpapc1")
			Follow(x.fgrp[index], x.fapc[2])
		end
		for index = 1, 50 do --mines
			x.emine = BuildObject("oproxars04", 5, "epmine", index)
		end
		for index = 1, 38 do --turrets
			x.etur[index] = BuildObject("mvturr", 5, "eptur", index)
			SetSkill(x.etur[index], x.skillsetting)
		end
		x.pos = GetTransform(x.fdrp)
		RemoveObject(x.fdrp)
		x.easnstate = 1
		x.easntime = GetTime()
		x.spine = x.spine + 1
	end
	
	--GIVE FIRST OBJECTIVE
	if x.spine == 1 and IsAudioMessageDone(x.audio1) then
		AddObjective("tcbd0601.txt")
		x.fnav[1] = BuildObject("apcamrb", 1, "fpnav1")
		SetObjectiveName(x.fnav[1], "Black Dogs Base")
		SetObjectiveOn(x.fnav[1])
		for index = 1, 2 do
			SetTeamNum(x.fapc[index], 1)
			SetGroup(x.fapc[index], 5)
			Defend(x.fapc[index], 0)
		end
		for index = 13, 16 do
			SetTeamNum(x.fgrp[index], 1)
			SetGroup(x.fgrp[index], 4)
			Follow(x.fgrp[index], x.fapc[1], 0)
		end
		x.pool = BuildObject("scrfld4g", 0, "pool")
		x.spine = x.spine + 1
	end
	
	--SPAWN PILOTS
	if x.spine == 2 and ((IsAlive(x.player) and GetDistance(x.player, "fpnav1") < 300) or (IsAlive(x.fapc[1]) and GetDistance(x.fapc[1], "fpnav1") < 300) or (IsAlive(x.fapc[2]) and GetDistance(x.fapc[2], "fpnav1") < 300)) then
		for index = 1, 16 do --pilots
			x.fpilo[index] = BuildObject("bspilo", 1, "fppilo", index)
			x.fpilostate[index] = 0
		end
		x.spine = x.spine + 1
	end

	--SEND APC TO PARK POINT
	if x.spine == 3 and ((IsAlive(x.fapc[1]) and GetDistance(x.fapc[1], "fpnav1") < 100) or (IsAlive(x.fapc[2]) and GetDistance(x.fapc[2], "fpnav1") < 100)) then
		Goto(x.fapc[1], "fppark1", 0)
		Goto(x.fapc[2], "fppark2", 0)
		x.spine = x.spine + 1
	end
	
	--APC PARKED
	if x.spine == 4 then
		for index = 1, 2 do
			if x.fapcstate[index] == 0 and IsAlive(x.fapc[index]) and GetDistance(x.fapc[index], ("fppark%d"):format(index)) < 40 then
				Stop(x.fapc[index], 0)
				x.fapcstate[index] = 1
			end
		end
		if x.fapcstate[1] == 1 and x.fapcstate[2] == 1 then
			AudioMessage("tcss1309.wav") --We're begin evac. Ready to move in 30 seconds.
			RemoveObject(x.fnav[1])
			x.spine = x.spine + 1
		end
	end
	
	--SOLDIERS TO APC
	if x.spine == 5 then
		for index = 1, 8 do
      if IsAlive(x.fpilo[index]) then
        Retreat(x.fpilo[index], x.fapc[1])
      end
      if IsAlive(x.fpilo[index+8]) then
        Retreat(x.fpilo[index+8], x.fapc[2])
      end
		end
		x.spine = x.spine + 1
	end
	
	--SOLDIERS ABOARD, MOVE OUT
	if x.spine == 6 then
		for index = 1, 8 do
			if IsAlive(x.fpilo[index]) and IsAlive(x.fapc[1]) and GetDistance(x.fpilo[index], x.fapc[1]) < 10 then
				RemoveObject(x.fpilo[index])
			end
			if IsAlive(x.fpilo[index+8]) and IsAlive(x.fapc[2]) and GetDistance(x.fpilo[index+8], x.fapc[2]) < 10 then
				RemoveObject(x.fpilo[index+8])
			end 
		end
		for index = 1, 16 do
			if not IsAround(x.fpilo[index]) then
				x.casualty = x.casualty + 1
			end
		end
		if x.casualty == 16 then
			Goto(x.fapc[1], "fppark1", 0)
			Goto(x.fapc[2], "fppark2", 0)
			AudioMessage("tcbd0602.wav") --goto rendevous beacon
			ClearObjectives()
			AddObjective("tcbd0601.txt", "GREEN")
			AddObjective("	")
			AddObjective("tcbd0602.txt")
			x.fnav[2] = BuildObject("apcamrb", 1, "fpnav2")
			SetObjectiveName(x.fnav[2], "Rendevous Zone")
			SetObjectiveOn(x.fnav[2])
			x.spine = x.spine + 1
		end
		x.casualty = 0
	end
	
	--DEFECTOR NOTIFICATION
	if x.spine == 7 and ((IsAlive(x.player) and IsInsideArea("defectarea", x.player)) or (IsAlive(x.fapc[1]) and IsInsideArea("defectarea", x.fapc[1])) or (IsAlive(x.fapc[2]) and IsInsideArea("defectarea", x.fapc[2]))) then
		x.audio1 = AudioMessage("tcbd0603.wav") --retrieve soviet defector
		x.spine = x.spine + 1
	end
	
	--DEFECTOR OBJECTIVE
	if x.spine == 8 and IsAudioMessageDone(x.audio1) then
		AddObjective("\n\nExtract the Crimson Bears defector.", "ALLYBLUE")
		SetObjectiveOff(x.fnav[2])
		x.fnav[3] = BuildObject("apcamrb", 1, "fpnav3")
		SetObjectiveName(x.fnav[3], "Grab Defector")
		SetObjectiveOn(x.fnav[3])
		x.spine = x.spine + 1
	end
	
	--DEFECTOR SPAWN
	if x.spine == 9 and ((IsAlive(x.player) and GetDistance(x.player, "fpnav3") < 100) or (IsAlive(x.fapc[1]) and GetDistance(x.fapc[1], "fpnav3") < 100) or (IsAlive(x.fapc[2]) and GetDistance(x.fapc[2], "fpnav3") < 100)) then
		x.fally = BuildObject("mspilo", 4, "fpally")
		x.fallystate = 1
		x.spine = x.spine + 1
	end
	
	--DEFECTOR STOP AND RETRIEVE
	if x.spine == 10 and ((IsAlive(x.fapc[1]) and GetDistance(x.fapc[1], "fpnav3") < 40) or (IsAlive(x.fapc[2]) and GetDistance(x.fapc[2], "fpnav3") < 40)) then
		Stop(x.fapc[1])
		Stop(x.fapc[2])
		RemoveObject(x.fnav[3])
		SetObjectiveName(x.fally, "Defector")
		SetObjectiveOn(x.fally)
		if IsAlive(x.fally) and IsAlive(x.fapc[1]) and IsAlive(x.fapc[2]) and (GetDistance(x.fally, x.fapc[1]) < GetDistance(x.fally, x.fapc[2])) then
			Retreat(x.fally, x.fapc[1])
		else
			Retreat(x.fally, x.fapc[2])
		end
		for index = 1, 4 do
			x.easn[3] = BuildObject("mspilo", 5, "epdefasn", index)
			Attack(x.easn[3], x.fally)
		end
		x.spine = x.spine + 1
	end
	
	--DEFECTOR PICKED UP
	if x.spine == 11 and IsAlive(x.fally) and ((IsAlive(x.fapc[1]) and GetDistance(x.fally, x.fapc[1]) < 10) or (IsAlive(x.fapc[2]) and GetDistance(x.fally, x.fapc[2]) < 10)) then
		x.fallystate = 0
		RemoveObject(x.fally)
		x.audio1 = AudioMessage("tcbd0602.wav") --goto rendevous beacon
		ClearObjectives()
		AddObjective("Crimson Bears defector picked up.", "GREEN")
		AddObjective("	")
		AddObjective("tcbd0602.txt")
		if not IsAlive(x.fnav[2]) then
			x.fnav[2] = BuildObject("apcamrb", 1, "fpnav2")
		end
		SetObjectiveName(x.fnav[2], "Pickup Zone")
		SetObjectiveOn(x.fnav[2])
		Defend(x.fapc[1], 0)
		Defend(x.fapc[2], 0)
		x.spine = x.spine + 1
	end
	
	--SPAWN WALKERS
	if x.spine == 12 and ((IsAlive(x.player) and IsInsideArea("walkerarea", x.player)) or (IsAlive(x.fapc[1]) and IsInsideArea("walkerarea", x.fapc[1])) or (IsAlive(x.fapc[2]) and IsInsideArea("walkerarea", x.fapc[2]))) then
		for index = 1, 2 do
			x.easn[index+4] = BuildObject("mvwalk", 5, "epasn5", index)
			SetSkill(x.easn[index+4], x.skillsetting)
			Attack(x.easn[index+4], x.fapc[index])
		end
		x.spine = x.spine + 1
	end
	
	--DROPSHIP SPAWN
	if x.spine == 13 and IsAlive(x.player) and GetDistance(x.player, "fpnav2") < 600 then
		x.fdrp = BuildObject("bvdrop", 0, x.pos)
		for index = 1, 10 do
			StopEmitter(x.fdrp, index)
		end
		x.spine = x.spine + 1
	end
	
	--DROPSHIP OPEN (skip landing anim since short sight range)
	if x.spine == 14 and ((IsAlive(x.player) and GetDistance(x.player, "fpnav2") < 200) or (IsAlive(x.fapc[1]) and GetDistance(x.fapc[1], "fpnav2") < 200) or (IsAlive(x.fapc[2]) and GetDistance(x.fapc[2], "fpnav2") < 200)) then
		SetAnimation(x.fdrp, "open", 1)
		x.spine = x.spine + 1
	end
	
	--MISSION SUCCESS
	if x.spine == 15 and (IsAlive(x.fapc[1]) and GetDistance(x.fapc[1], "fpnav2") < 100) and (IsAlive(x.fapc[2]) and GetDistance(x.fapc[2], "fpnav2") < 100) then
		AudioMessage("tcbd0604.wav") --congrates bdog saved
		ClearObjectives()
		AddObjective("tcbd0602.txt", "GREEN")
		AddObjective("\n\nMISSION COMPLETE!", "GREEN")
		SucceedMission(GetTime() + 10.0, "tcbd06w.des") --WINNER WINNER WINNER
		x.spine = 666
		x.MCAcheck = true
	end
	----------END MAIN SPINE ----------
	
	--AI ASSASSIN
	if x.easnstate == 1 and x.easntime < GetTime() and not IsAlive(x.easn[1]) and not IsAlive(x.easn[2]) then
		for index = 1, 2 do
			while x.randompick == x.randomlast do --random the random
				x.randompick = math.floor(GetRandomFloat(1.0, 15.0))
			end
			x.randomlast = x.randompick
			if IsAlive(x.ercy) and (x.randompick == 1 or x.randompick == 6 or x.randompick == 10 or x.randompick == 14) then
				x.easn[index] = BuildObject("mvscout", 5, GetPositionNear("epgrcy", 0, 16, 32)) --grpspwn
			elseif IsAlive(x.efac) and (x.randompick == 2 or x.randompick == 7 or x.randompick == 11 or x.randompick == 15) then
				x.easn[index] = BuildObject("mvmbike", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
			elseif IsAlive(x.efac) and (x.randompick == 3 or x.randompick == 8 or x.randompick == 12) then
				x.easn[index] = BuildObject("mvmisl", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
			elseif IsAlive(x.efac) and (x.randompick == 4 or x.randompick == 9 or x.randompick == 13) then
				x.easn[index] = BuildObject("mvtank", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
			else
				x.easn[index] = BuildObject("mvrckt", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
			end
			SetSkill(x.easn[index], x.skillsetting)
			Goto(x.easn[index], "stage1")
		end
		x.easnstate = 2
	elseif x.easnstate == 2 and ((IsAlive(x.easn[1]) and GetDistance(x.easn[1], "stage1", 2) < 20) or (IsAlive(x.easn[2]) and GetDistance(x.easn[2], "stage1", 2) < 20)) then
		Attack(x.easn[1], x.fapc[1])
		Attack(x.easn[2], x.fapc[2])
		x.easntime = GetTime() + 50.0
		x.easnstate = 1
	end
	
	--CHECK STATUS OF MCA 
	if not x.MCAcheck then	
		if not IsAlive(x.fapc[1]) or not IsAlive(x.fapc[2]) then
			x.easnstate = 100
			AudioMessage("alertpulse.wav")
			ClearObjectives()
			AddObjective("An APC has been lost.\n\nCBB reinforcements incoming.\n\nMISSION FAILED!", "RED")
			FailMission(GetTime() + 5.0, "tcbd06f1.des") --LOSER LOSER LOSER
			x.spine = 666
			x.MCAcheck = true
		end
		
		if x.fallystate == 1 and not IsAlive(x.fally) then
			AudioMessage("alertpulse.wav")
			ClearObjectives()
			AddObjective("Defector killed.\n\nCBB reinforcements incoming.\n\nMISSION FAILED!", "RED")
			FailMission(GetTime() + 5.0, "tcbd06f2.des") --LOSER LOSER LOSER
			x.spine = 666
			x.MCAcheck = true
		end
	end
end
--[[END OF SCRIPT]]