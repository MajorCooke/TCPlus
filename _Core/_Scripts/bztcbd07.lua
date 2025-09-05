--bztcbd07 - Battlezone Total Command - Stars and Stripes - 7/10 - RETRIEVE RELICS
assert(load(assert(LoadFile("_requirefix.lua")),"_requirefix.lua"))();
TCC = require("TC_Core")
MisnNum = 23;
local index = 0
local index2 = 0
local x = {
	FIRST = true, 
	MCAcheck = false,	
	spine = 0, 
	casualty = 0, 
	randompick = 0, 
	randomlast = 0,	
	waittime = 99999.9, 
	player = nil, 
	mytank = nil, 
	skillsetting = 0, 
	easy = 0, 
	medium = 1, 
	hard = 2, --tried 1-3, in 185, 3 didn't seem to make any difference,
	audio1 = nil, 
	fnav = {}, 
	free_player = false,	
	controls = {braccel = 0, strafe = 0, jump = 0, deploy = 0, eject = 0, abandon = 0, fire = 0}, 
	relic = {}, 
	relicfound = {false, false},
	relicfoundboth = 0, 
	etugallow = false, 
	etug = {}, 
	etugstate = {1, 1},
	etugwait = {99999.9, 99999.9}, 
	etuglives = {false, false}, 
	etugaddtime = {0.0, 0.0}, --just init here
	eatk = {}, 
	eatklength = 0, 
	eatkstate = {}, 
	eatktime = {}, 
	eatkaddtime = {}, 
	ehqr = nil, 
	etnk = {}, 
	etur = {}, 
	fdrp = {}, 
	fgrp = {}, 
	ftug = {}, 
	ftugstate = false, 
	holder = {}, 
	trapstate = 0, 
	trapwait = 99999.9, 
	traptime = 99999.9, 
	traporder = false, 
	freestuff = nil, 
	freestate = 0, 
	freetime = 99999.9, 
	easn = {}, 
	easnstate = {0, 0}, 
	easntime = {99999.9, 99999.9}, 
	LAST	= true
}
--PATHS: fpnav1-6, prelic1-2, eprcy, epgrcy, eptur(0-8), epatk(0-12) eptnk(0-4), eptrap(0-4), pfreestuff, droparea, ftur1-4, fgrp1-2, fsrv, ftug, epgrd, ebasearea

function InitialSetup()
	SetAutoGroupUnits(true)
	
	local odfpreload = {
		"bvscout", "bvmisl", "bvtank", "bvturr", "bvtug", "bvserv",	
		"svturr", "svtug", "svscout", "svmbike", "svmisl", "svtank", "svrckt", "svstnk", "gpopg1a", "gchana_c", 
		"yvpegars06a", "hadrelic02", "hadrelic03", "nvscout", "nvmbike", "nvmisl", "nvtank", "nvrckt", "stayput", "apcamrb"
	}
	for k,v in pairs(odfpreload) do
		PreloadODF(v)
	end
	
	x.fdrp[1] = GetHandle("fdrp1")
	x.fdrp[2] = GetHandle("fdrp2")
	x.mytank = GetHandle("mytank")
	for index = 1, 16 do
		x.fgrp[index] = GetHandle(("fgrp%d"):format(index))
	end
	x.ftug[1] = GetHandle("ftug1")
	x.ehqr = GetHandle("ehqr")
	x.freestuff = GetHandle("freestuff")
	Ally(1, 4)
	Ally(4, 1) --4 Fury relic
	Ally(5, 4)
	Ally(4, 5)
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

function AddObject(h)  
	if GetRace(h) == "s" then --just too annoying since no ercy
		SetEjectRatio(h, 0.0);
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
		x.audio1 = AudioMessage("tcbd0701.wav") --20s Gen. Col landing on Io in a search for Cthonian relics. Cobra One, recover those relics.
		x.pos = GetTransform(x.mytank)
		RemoveObject(x.mytank)
		x.mytank = BuildObject("bvtank", 1, x.pos)
		GiveWeapon(x.mytank, "gpopg1a")
		GiveWeapon(x.mytank, "gchana_c")
		SetAsUser(x.mytank, 1)
		RemoveObject(x.player)
		x.player = GetPlayerHandle()
		x.pos = GetTransform(x.fgrp[1])
		RemoveObject(x.fgrp[1])
		x.fgrp[1] = BuildObject("bvscout", 1, x.pos)
		x.pos = GetTransform(x.fgrp[2])
		RemoveObject(x.fgrp[2])
		x.fgrp[2] = BuildObject("bvscout", 1, x.pos)
		x.pos = GetTransform(x.fgrp[3])
		RemoveObject(x.fgrp[3])
		x.fgrp[3] = BuildObject("bvmbike", 1, x.pos)
		x.pos = GetTransform(x.fgrp[4])
		RemoveObject(x.fgrp[4])
		x.fgrp[4] = BuildObject("bvmbike", 1, x.pos)
		x.pos = GetTransform(x.fgrp[5])
		RemoveObject(x.fgrp[5])
		x.fgrp[5] = BuildObject("bvmisl", 1, x.pos)
		x.pos = GetTransform(x.fgrp[6])
		RemoveObject(x.fgrp[6])
		x.fgrp[6] = BuildObject("bvmisl", 1, x.pos)
		x.pos = GetTransform(x.fgrp[7])
		RemoveObject(x.fgrp[7])
		x.fgrp[7] = BuildObject("bvtank", 1, x.pos)
		GiveWeapon(x.fgrp[7], "gpopg1a")
		GiveWeapon(x.fgrp[7], "gchana_c")
		x.pos = GetTransform(x.fgrp[8])
		RemoveObject(x.fgrp[8])
		x.fgrp[8] = BuildObject("bvtank", 1, x.pos)
		GiveWeapon(x.fgrp[8], "gpopg1a")
		GiveWeapon(x.fgrp[8], "gchana_c")
		for index = 1, 8 do
			SetSkill(x.fgrp[index], x.skillsetting)
			SetGroup(x.fgrp[index], 0)
			Stop(x.fgrp[index])
		end
		for index = 9, 12 do
			x.pos = GetTransform(x.fgrp[index])
			RemoveObject(x.fgrp[index])
			x.fgrp[index] = BuildObject("bvturr", 1, x.pos)
			SetSkill(x.fgrp[index], x.skillsetting)
			Stop(x.fgrp[index])
		end
		for index = 13, 16 do
			x.pos = GetTransform(x.fgrp[index])
			RemoveObject(x.fgrp[index])
			x.fgrp[index] = BuildObject("bvserv", 1, x.pos)
			Stop(x.fgrp[index])
		end
		for index = 1, 4 do
			SetGroup(x.fgrp[index+12], 4)
			SetGroup(x.fgrp[index+8], 5)
		end
		x.pos = GetTransform(x.ftug[1])
		RemoveObject(x.ftug[1])
		x.ftug[1] = BuildObject("bvtug", 1, x.pos)
		SetGroup(x.ftug[1], 6)
		Stop(x.ftug[1])
		x.relic[1] = BuildObject("hadrelic02", 0, "prelic1") --start neutral
		SetObjectiveName(x.relic[1], "Alpha Relic")
		x.relic[2] = BuildObject("hadrelic03", 0, "prelic2") --start neutral
		SetObjectiveName(x.relic[2], "Beta Relic")
		x.etnk[1] = BuildObject("nvscout", 0, "epgrd", 1) --to avoid spawn pause...
		x.etnk[2] = BuildObject("nvmisl", 0, "epgrd", 2) --will be deleted next update...
		x.etnk[3] = BuildObject("nvmbike", 0, "epgrd", 3)
		x.etnk[4] = BuildObject("nvtank", 0, "epgrd", 4)
		x.etnk[3] = BuildObject("nvrckt", 0, "epgrd", 5)
		x.spine = x.spine + 1
	end

	--DROPSHIP LANDING SEQUENCE - START QUAKE FOR FLYING EFFECT
	if x.spine == 1 then
		for index = 1, 2 do
			for index2 = 1, 10 do
				StopEmitter(x.fdrp[index], index2)
			end
		end
		for index = 1, 16 do
			x.holder[index] = BuildObject("stayput", 0, x.fgrp[index])
		end
		x.holder[17] = BuildObject("stayput", 0, x.ftug[1]) --tug
		x.holder[18] = BuildObject("stayput", 0, x.player) --playa
		StartEarthQuake(10.0)
		x.waittime = GetTime() + 4.0
		x.spine = x.spine + 1
		x.freestuff = BuildObject("yvpegars06a", 0, "pfreestuff")
	end

	--LANDING - MAKE QUAKE BIGGERR
	if x.spine == 2 and x.waittime < GetTime() then
		UpdateEarthQuake(30.0)
		x.waittime = GetTime() + 3.0
		x.spine = x.spine + 1
	end
	
	--HAVE LANDED - STOP QUAKE
	if x.spine == 3 and x.waittime < GetTime() then
		StopEarthQuake()
	--BUILD FORCE
		for index = 1, 12 do
			while x.randompick == x.randomlast do --random the random
				x.randompick = math.floor(GetRandomFloat(1.0, 13.0))
			end
			x.randomlast = x.randompick
			if x.randompick == 1 or x.randompick == 6 or x.randompick == 11 then
				x.eatk[index] = BuildObject("svscout", 5, ("ppatrol%d"):format(index))
			elseif x.randompick == 2 or x.randompick == 7 then
				x.eatk[index] = BuildObject("svmbike", 5, ("ppatrol%d"):format(index))
			elseif x.randompick == 3 or x.randompick == 8 or x.randompick == 12 then
				x.eatk[index] = BuildObject("svmisl", 5, ("ppatrol%d"):format(index))
			elseif x.randompick == 4 or x.randompick == 9 then
				x.eatk[index] = BuildObject("svtank", 5, ("ppatrol%d"):format(index))
			else --5 10 13
				x.eatk[index] = BuildObject("svrckt", 5, ("ppatrol%d"):format(index))
			end
			SetSkill(x.eatk[index], x.skillsetting)
			Patrol(x.eatk[index], ("ppatrol%d"):format(index))
		end
		x.waittime = GetTime() + 2.0
		x.spine = x.spine + 1
	end

	--OPEN DROPSHIP DOORS, REMOVE HOLDERS
	if x.spine == 4 and x.waittime < GetTime() then
		StartSoundEffect("dropdoor.wav")
		SetAnimation(x.fdrp[1], "open", 1)
		SetAnimation(x.fdrp[2], "open", 1)
		for index = 1, 12 do
			x.etur[index] = BuildObject("svturr", 5, "eptur", index)
		end
		x.waittime = GetTime() + 5.0
		x.spine = x.spine + 1
				for index = 1, 2 do --init eatk stuff after a full update (or a bunch of them)
			x.eatk[index] = {}
			x.eatkstate[index] = {}
			x.eatktime[index] = {}
			x.eatkaddtime[index] = {}
			for index2 = 1, 4 do
				x.eatk[index][index2] = nil
				x.eatkstate[index][index2] = 1
				x.eatktime[index][index2] = 99999.9
				x.eatkaddtime[index][index2] = 0.0
			end
		end
	end
	
	--DOORS FULLY OPEN, GIVE MOVE ORDER
	if x.spine == 5 and x.waittime < GetTime() then
		for index = 1, 2 do --player is later
			RemoveObject(x.holder[index])
			Goto(x.fgrp[index], "fgrp1", 0)
			RemoveObject(x.holder[index+2])
			Goto(x.fgrp[index+2], "fgrp2", 0)
			RemoveObject(x.holder[index+4])
			Goto(x.fgrp[index+4], "fgrp1", 0)
			RemoveObject(x.holder[index+6])
			Goto(x.fgrp[index+6], "fgrp2", 0)
		end
		for index = 1, 4 do
			RemoveObject(x.holder[index+8])
			Goto(x.fgrp[index+8], ("ftur%d"):format(index), 0)
			RemoveObject(x.holder[index+12])
			Goto(x.fgrp[index+12], "fsrv", 0)
		end
		RemoveObject(x.holder[17])
		Goto(x.ftug[1], "ftug", 0)
		x.waittime = GetTime() + 2.0
		x.spine = x.spine + 1
		x.etugallow = true
	end

	--GIVE PLAYER CONTROL OF THEIR AVATAR
	if x.spine == 6 and x.waittime < GetTime() then
		RemoveObject(x.holder[18])
		x.free_player = true
		x.spine = x.spine + 1
	end
	
	--CHECK IF PLAYER HAS LEFT DROPSHIP SO DROPSHIP 1 TAKEOFF
	if x.spine == 7 then
		x.player = GetPlayerHandle()
		if IsAlive(x.player) and IsCraftButNotPerson(x.player) and GetDistance(x.player, x.fdrp[1]) > 64 then
			AudioMessage("emdotcox.wav")
			ClearObjectives()
			AddObjective("tcbd0701.txt")
			for index = 1, 2 do
				for index2 = 1, 10 do
					StartEmitter(x.fdrp[index], index2)
				end
			end
			x.waittime = GetTime() + 2.0
			x.spine = x.spine + 1
		end
	end
	
	--LAUNCH DROPSHIPS AFTER PAUSE
	if x.spine == 8 and x.waittime < GetTime() then
		SetAnimation(x.fdrp[1], "takeoff", 1)
		StartSoundEffect("dropleav.wav", x.fdrp[1])
		x.waittime = GetTime() + 2.0
		x.spine = x.spine + 1
	end

	--DROPSHIP 2 TAKEOFF
	if x.spine == 9 and x.waittime < GetTime() and IsAlive(x.ftug[1]) and GetDistance(x.ftug[1], x.fdrp[2]) > 40 then
		SetAnimation(x.fdrp[2], "takeoff", 1)
		StartSoundEffect("dropleav.wav", x.fdrp[2])
		x.fnav[1] = BuildObject("apcamrb", 1, "fpnav1")
		SetObjectiveName(x.fnav[1], "Dropzone")
		x.fnav[2] = BuildObject("apcamrb", 1, "fpnav2")
		SetObjectiveName(x.fnav[2], "Nav Rel 1")
		x.fnav[3] = BuildObject("apcamrb", 1, "fpnav3")
		SetObjectiveName(x.fnav[3], "Nav Rel 2")
		x.waittime = GetTime() + 15.0
		for index = 1, 8 do
			Follow(x.fgrp[index], x.player, 0)
		end
		for index = 13, 16 do
			Follow(x.fgrp[index], x.ftug[1], 0)
		end
		for index = 1, 5 do
			RemoveObject(x.etnk[index]) --just do it
		end
		x.spine = x.spine + 1
	end

	--REMOVE DROPSHIPS
	if x.spine == 10 and x.waittime < GetTime() then
		RemoveObject(x.fdrp[1])
		RemoveObject(x.fdrp[2])
		x.spine = x.spine + 1
	end
	
	--GOT FIRST RELIC
	if x.spine == 11 and ((IsAlive(x.relic[1]) and (GetTug(x.relic[1]) == x.ftug[1])) or (IsAlive(x.relic[2]) and (GetTug(x.relic[2]) == x.ftug[1]))) then
		AudioMessage("emdotcox.wav")
		ClearObjectives()
		AddObjective("tcbd0701.txt")
		AddObjective("	")
		AddObjective("tcbd0702.txt")
		if IsAlive(x.ftug[1]) and IsAlive(x.relic[1]) and IsAlive(x.relic[2]) and (GetDistance(x.ftug[1], x.relic[1]) < GetDistance(x.ftug[1], x.relic[2])) then
			x.relicother = 2 --note opposite relic
		else
			x.relicother = 1
		end
		x.spine = x.spine + 1
	end
	
	--PICKED UP OTHER RELIC
	if x.spine == 12 and IsAlive(x.relic[x.relicother]) and GetTug(x.relic[x.relicother]) == x.ftug[1] then
		AudioMessage("emdotcox.wav")
		ClearObjectives()
		AddObjective("tcbd0701.txt")
		AddObjective("	")
		AddObjective("tcbd0703.txt")
		x.spine = x.spine + 1
	end
	
	--BOTH ARTIFACTS AT RECY, RECHECK DISTRESS BEACON
	if x.spine == 13 and IsAlive(x.relic[1]) and IsAlive(x.relic[2]) and GetDistance(x.relic[1], "fpnav1") < 64 and GetDistance(x.relic[2], "fpnav1") < 64 then -- and not HasCargo(x.etug[1]) and not HasCargo(x.etug[2]) then  --ignore etug alive
		if x.trapstate == 2 then
			x.traporder = true
			x.traptime = GetTime() + 180.0
			AudioMessage("tcbd0711.wav") --ADDED --Cobra One, you still need to investigate the distress call before we can leave.
		end
		x.spine = x.spine + 1
	end
	
	--DISTRESS CLEARED SEND FINAL ATTACK
	if x.spine == 14 and not x.traporder and IsAlive(x.player) and GetDistance(x.player, "fpnav1") < 200 then
		AudioMessage("tcbd0702.wav") --defend relics at all costs. Dropships are on the way.
		ClearObjectives()
		AddObjective("tcbd0701.txt", "YELLOW")
		AddObjective("	")
		AddObjective("tcbd0704.txt")
		x.etugallow = false --stop tug stuff / used by freestuff too
		x.ftugstate = true --even ftug can die
		TCC.SetTeamNum(x.relic[1], 1)
		TCC.SetTeamNum(x.relic[2], 1)
		x.easn[1] = BuildObject("nvscout", 5, "eptnk", 1)
		x.easn[2] = BuildObject("nvtank", 5, "eptnk", 2)
		x.easn[3] = BuildObject("svmisl", 5, "eptnk", 3)
		x.easn[4] = BuildObject("svrckt", 5, "eptnk", 4)
		x.eatklength = 4
		for index = 1, 8 do
			if not IsAlive(x.fgrp[index]) then
				x.casualty = x.casualty + 1
			end
		end
		if x.casualty <= 6 then
			x.easn[5] = BuildObject("svscout", 5, "eptnk", 1)
			x.easn[6] = BuildObject("svtank", 5, "eptnk", 2)
			x.easn[7] = BuildObject("nvmisl", 5, "eptnk", 3)
			x.easn[8] = BuildObject("nvrckt", 5, "eptnk", 4)
			x.eatklength = 8
		end
		if x.casualty <= 4 then
			x.easn[9] = BuildObject("svstnk", 5, "eptnk", 2)
			x.easn[10] = BuildObject("svstnk", 5, "eptnk", 3)
			x.eatklength = 10
		end
		x.casualty = 0
		for index = 1, x.eatklength do
			SetSkill(x.easn[index], x.skillsetting)
			if index % 2 == 0 then
				Attack(x.easn[index], x.relic[2])
			else
				Attack(x.easn[index], x.relic[1])
			end
		end
		x.spine = x.spine + 1
	end
	
	--MISSION SUCCESS
	if x.spine == 15 then
		for index = 1, x.eatklength do
			if not IsAlive(x.easn[index]) or (GetTeamNum(x.easn[index]) == 1)then
				x.casualty = x.casualty + 1
			end
		end
		if x.casualty == x.eatklength then
			x.MCAcheck = true
			AudioMessage("tcbd0708.wav") --ADDED --Good job securing those relics. Dropship is enroute.
			ClearObjectives()
			AddObjective("tcbd0704.txt", "GREEN")
			TCC.SucceedMission(GetTime() + 7.0, "tcbd07w.des") --WINNER WINNER WINNER
			x.spine = x.spine + 1
		end
		x.casualty = 0
	end
	----------END MAIN SPINE ----------

	--ENSURE PLAYER CAN'T DO ANYTHING WHILE IN DROPSHIP
	if not x.free_player then
		x.controls = {braccel = 0, strafe = 0, jump = 0, deploy = 0, eject = 0, abandon = 0, fire = 0}
		SetControls(x.player, x.controls)
	end
	
	--KEEP DROPZONE NAV CAM ALIVE
	if x.spine > 9 and not IsAlive(x.fnav[1]) then
		x.fnav[1] = BuildObject("apcamrb", 1, "fpnav1")
		SetObjectiveName(x.fnav[1], "Dropzone")
	end
	
	--MARK AND GIVE OUT FREESTUFF
	if x.freestate == 0 and x.etugallow and GetTeamNum(x.freestuff) ~= 1 then
		for index = 1, 8 do
			if not IsAlive(x.fgrp[index]) then
				x.casualty = x.casualty + 1
			end
		end
		if x.casualty >= 4 or (x.trapstate >= 3 and x.casualty >= 2 and IsAlive(x.relic[1]) and IsAlive(x.relic[2]) and GetDistance(x.relic[1], "fpnav1") < 64 and GetDistance(x.relic[2], "fpnav1") < 64) then
			x.freestate = x.freestate + 1
			x.freetime = GetTime() + 20.0
		end
		x.casualty = 0
	elseif x.freestate == 1 and x.freetime < GetTime() then
		AudioMessage("tcbd0710.wav") --ADDED --Cobra One, it's not required, but you might want to investigate that strange signal if you get the opportunity.
		AddObjective("\n\nOptional: Investigate Alien Signal")
		x.fnav[6] = BuildObject("apcamrb", 1, "fpnav6")
		SetObjectiveName(x.fnav[6], "Alien Signal")
		SetObjectiveOn(x.fnav[6])
		x.freestate = x.freestate + 1
	elseif x.freestate == 2 and IsInfo("yvpegars06a") then
		TCC.SetTeamNum(x.freestuff, 1)
		SetGroup(x.freestuff, 9)
		Defend(x.freestuff, 0) --give player control
		RemoveObject(x.fnav[6])
		x.freestate = x.freestate + 1
	end
	
	--IT'S A (ANOTHER) TRAP
	if x.trapstate == 0 and ((IsAlive(x.relic[1]) and GetDistance(x.relic[1], "fpnav1") < 500) or (IsAlive(x.relic[2]) and GetDistance(x.relic[2], "fpnav1") < 500)) then
		x.trapwait = GetTime() + 20.0 --little pause so timing seems natural
		x.trapstate = x.trapstate + 1
	elseif x.trapstate == 1 and x.trapwait < GetTime() then
		AudioMessage("tcbd0703.wav") --ADDED –receiving a distress call. Go to the nav beacon immediately and investigate.
		AddObjective("	")
		AddObjective("tcbd0705.txt")
		x.fnav[4] = BuildObject("apcamrb", 1, "fpnav4")
		SetObjectiveName(x.fnav[4], "Distress Beacon")
		SetObjectiveOn(x.fnav[4])
		x.trapstate = x.trapstate + 1
	elseif x.trapstate == 2 and IsAlive(x.player) and GetDistance(x.player, "fpnav4") < 40 then
		x.etnk[1] = BuildObject("nvscout", 5, "eptrap", 1)
		x.etnk[2] = BuildObject("nvmbike", 5, "eptrap", 2)
		x.etnk[3] = BuildObject("nvscout", 5, "eptrap", 3)
		for index = 1, 2 do --3 do
			SetSkill(x.etnk[index], x.skillsetting)
			Attack(x.etnk[index], x.player)
		end
		x.traptime = GetTime() + 2.0
		x.traporder = false
		x.trapstate = x.trapstate + 1
	elseif x.trapstate == 3 and x.traptime < GetTime() then
		AudioMessage("tcbd0704.wav") --ADDED –-It’s another trap from the rogue NSDF. Get out of there Cobra One.
		AddObjective("\n\nRogue NSDF are in the area. Be careful.")
		RemoveObject(x.fnav[4])
		x.traptime = x.traptime + 20.0
		x.trapstate = x.trapstate + 1
	elseif x.trapstate == 4 and x.traptime < GetTime() then
		for index = 1, 3 do
			Attack(x.etnk[index], x.player) --resend order periodically
		end
		x.traptime = GetTime() + 20.0
		if not IsAlive(x.etnk[1]) and not IsAlive(x.etnk[2]) and not IsAlive(x.etnk[3]) then
			x.trapstate = 100
		end
		x.trapstate = x.trapstate + 1
	end
	
	--TURN RELIC ON FIRST TIME
	if x.relicfoundboth < 2 then
		for index = 1, 2 do
			if not x.relicfound[index] and IsAlive(x.relic[index]) and ((IsAlive(x.player) and GetDistance(x.relic[index], x.player) < 100) or (IsAlive(x.etug[index]) and GetDistance(x.relic[index], x.etug[index]) < 50)) then
				TCC.SetTeamNum(x.relic[index], 4)
				SetObjectiveOn(x.relic[index])
				x.relicfound[index] = true
				x.relicfoundboth = x.relicfoundboth + 1
			end
		end
	end
	
	--KEEP RELIC ON WHEN NOT CARRIED BY ETUG
	for index = 1, 2 do
		if x.relicfound[index] and IsAlive(x.relic[index]) and GetTug(x.relic[index]) == nil then
			SetObjectiveOn(x.relic[index])
		elseif x.relicfound[index] and IsAlive(x.relic[index]) and GetTeamNum(GetTug(x.relic[index])) == 5 then
			SetObjectiveOff(x.relic[index])
		end
	end

	--TUG AND ESCORT STUFF
	if x.etugallow then
		for index = 1, 2 do 
			if x.etugstate[index] == 1 and not IsAlive(x.etug[index]) then 
				x.etugaddtime[index] = x.etugaddtime[index] + 15.0 --slow each time
				x.etugwait[index] = GetTime() + x.etugaddtime[index]
				x.etugstate[index] = x.etugstate[index] + 1
			elseif x.etugstate[index] == 2 and IsAlive(x.player) and x.etugwait[index] < GetTime() and GetDistance(x.player, "fpnav5") > 1000 then --and IsAlive(x.ercy) then
				x.etug[index] = BuildObject("svtug", 5, "epgrd")
				SetCanSnipe(x.etug[index], 0)
				Goto(x.etug[index], ("stage%d"):format(index))
				x.etuglives[index] = true
				x.etugstate[index] = x.etugstate[index] + 1
			elseif x.etugstate[index] == 3 and IsAlive(x.etug[index]) and IsAlive(x.relic[index]) and GetDistance(x.etug[index], ("stage%d"):format(index)) < 32 then
				Follow(x.etug[index], x.relic[index])
				x.etugstate[index] = x.etugstate[index] + 1
			elseif x.etugstate[index] == 4 and IsAlive(x.etug[index]) and IsAlive(x.relic[index]) and GetDistance(x.etug[index], x.relic[index]) < 32 and GetTug(x.relic[index]) == nil then
				Pickup(x.etug[index], x.relic[index])
				x.etugstate[index] = x.etugstate[index] + 1
			elseif x.etugstate[index] == 5 and IsAlive(x.etug[index]) and HasCargo(x.etug[index]) then
				if GetDistance(x.etug[index], ("stage%d"):format(index)) < GetDistance(x.etug[index], "fpnav5") then
					Goto(x.etug[index], ("stage%d"):format(index))
					x.etugstate[index] = x.etugstate[index] + 1
				else
					Goto(x.etug[index], "fpnav5")
					x.etugstate[index] = x.etugstate[index] + 2 --skip one
				end
				AudioMessage("tcbd0709.wav") --ADDED --the sov have a relic. get it back
				Goto(x.etug[index], "fpnav5")
				SetObjectiveOn(x.etug[index])
			elseif x.etugstate[index] == 6 and IsAlive(x.etug[index]) and GetDistance(x.etug[index], ("stage%d"):format(index)) < 32 then
				Goto(x.etug[index], "fpnav5")
				x.etugstate[index] = x.etugstate[index] + 1
			elseif x.etugstate[index] == 7 and IsAlive(x.etug[index]) and GetDistance(x.etug[index], "fpnav5") < 32 then
				Stop(x.etug[index])
				x.etugstate[index] = 1 --reset
			end
			
			if x.etuglives[index] and not IsAlive(x.etug[index]) then
				x.etugstate[index] = 1
				x.etuglives[index] = false
			end
		end
		
		if x.skillsetting == x.easy then
			x.eatklength = 5
		elseif x.skillsetting == x.medium then
			x.eatklength = 4
		else
			x.eatklength = 3
		end
		
		for index = 1, 2 do	
			for index2 = 1, x.eatklength do
				if x.eatkstate[index][index2] == 1 and (not IsAlive(x.eatk[index][index2]) or x.eatk[index][index2] == nil) and IsAlive(x.etug[index]) then
					x.eatkaddtime[index][index2] = x.eatkaddtime[index][index2] + 10.0
					x.eatktime[index][index2] = GetTime() + 10.0 + x.eatkaddtime[index][index2]
					x.eatkstate[index][index2] = x.eatkstate[index][index2] + 1
				elseif x.eatkstate[index][index2] == 2 and x.eatktime[index][index2] < GetTime() and IsAlive(x.player) and GetDistance(x.player, "fpnav5") > 1000 then --and IsAlive(x.ercy) then
					if index2 == 1 then
						x.eatk[index][index2] = BuildObject("svscout", 5, GetPositionNear("epgrd", 0, 16, 32)) --grpspwn  --"epgrd")
					elseif index2 == 2 then
						x.eatk[index][index2] = BuildObject("svmbike", 5, GetPositionNear("epgrd", 0, 16, 32)) --grpspwn  --"epgrd")
					else --elseif index2 == 3 then
						x.eatk[index][index2] = BuildObject("svtank", 5, GetPositionNear("epgrd", 0, 16, 32)) --grpspwn  --"epgrd")
					end
					SetSkill(x.eatk[index][index2], x.skillsetting)
					x.eatkstate[index][index2] = x.eatkstate[index][index2] + 1
				elseif x.eatkstate[index][index2] == 3 and x.eatktime[index][index2] < GetTime() then
					if not IsAlive(x.eatk[index][index2]) then
						x.eatkstate[index][index2] = 1 --reset if necessary
					elseif IsAlive(x.eatk[index][index2]) and IsAlive(x.etug[index]) then
						Defend2(x.eatk[index][index2], x.etug[index])
						x.eatktime[index][index2] = GetTime() + 10.0
					elseif IsAlive(x.eatk[index][index2]) and not IsAlive(x.etug[index]) then
						Goto(x.eatk[index][index2], "fpnav5")
						x.eatktime[index][index2] = GetTime() + 10.0
					end
				end
			end
		end 
	end
	
	--ASSASSIN ATTACK FOR FTUG (one time special attack)
	for index = 1, 2 do
		if x.easnstate[index] == 0 and IsAlive(x.relic[index]) and GetTug(x.relic[index]) == x.ftug[1] then
			x.easntime[index] = GetTime() + 10.0
			x.easnstate[index] = 1
		elseif x.easnstate[index] == 1 and x.easntime[index] < GetTime() then
			x.easn[index] = BuildObject("svscout", 5, GetPositionNear("eptnk", 0, 16, 32)) --grpspwn  --"eptnk")
			Attack(x.easn[index], x.ftug[1]) 
			x.easn[index] = BuildObject("svmbike", 5, GetPositionNear("eptnk", 0, 16, 32)) --grpspwn  --"eptnk")
			Attack(x.easn[index], x.ftug[1])
			x.easn[index] = BuildObject("svtank", 5, GetPositionNear("eptnk", 0, 16, 32)) --grpspwn  --"eptnk")
			Attack(x.easn[index], x.ftug[1])
			x.easnstate[index] = 2
		end
	end

	--CHECK STATUS OF MCA ----------------------------------
	if not x.MCAcheck then
		if not x.ftugstate and not IsAlive(x.ftug[1]) then --lost tug
			AudioMessage("tcbd0705.wav") --ADDED –allowed the tug to be destroyed. Retreat to the dropzone.
			ClearObjectives()
			AddObjective("You lost your only Hauler.\n\nMISSION FAILED!", "RED") --"tcbd0701.txt", "RED") --CCA captured relic. Mission FAILED.
			TCC.FailMission(GetTime() + 11.0, "tcbd07f1.des") --LOSER LOSER LOSER
			x.spine = 666
			x.MCAcheck = true
		end
			
		if not IsAlive(x.relic[1]) or not IsAlive(x.relic[2]) then --fury relic destroyed
			AudioMessage("tcbd0707.wav") --ADDED --allowed a relic to be destroyed. Retreat!
			ClearObjectives()
			AddObjective("A relic was destroyed.\n\nMISSION FAILED!", "RED") --("tcbd0704.txt", "RED")
			TCC.FailMission(GetTime() + 7.0, "tcbd07f2.des") --LOSER LOSER LOSER
			x.spine = 666
			x.MCAcheck = true
		end
		
		if GetDistance(x.relic[1], "fpnav5") < 64 and GetDistance(x.relic[2], "fpnav5") < 64 then --CCA captured relics
			AudioMessage("tcbd0706.wav") --ADDED --CCA has captured the relics and will soon have reinforcements. Retreat.
			ClearObjectives()
			AddObjective("The CCA captured the relics.\n\nMISSION FAILED!", "RED") --("tcbd0701.txt", "RED") --CCA captured relic. Mission FAILED.
			TCC.FailMission(GetTime() + 10.0, "tcbd07f3.des") --LOSER LOSER LOSER
			x.spine = 666
			x.MCAcheck = true
		end
		
		if x.traporder and x.traptime < GetTime() then --failed to follow orders
			AudioMessage("alertpulse.wav") 
			ClearObjectives()
			AddObjective("Failed to investigate distress beacon in a timely manner.\n\nMISSION FAILED!", "RED")
			TCC.FailMission(GetTime() + 5.0, "tcbd07f4.des") --LOSER LOSER LOSER
			x.spine = 666
			x.MCAcheck = true
		end
	end
end
--[[END OF SCRIPT]]