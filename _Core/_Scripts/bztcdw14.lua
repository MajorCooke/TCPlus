--bztcdw14 - Battlezone Total Command - Dogs of War - 14/15 - LIFELINE
assert(load(assert(LoadFile("_requirefix.lua")),"_requirefix.lua"))();
TCC = require("TC_Core")
MisnNum = 52;
local index = 0
local index2 = 0
local indexadd = 0
local x = {
	FIRST = true, 
	MisnNum = 52,
	spine = 0, 
	waittime = 99999.9, 
	MCAcheck = false, 
	player = nil, 
	mytank = nil, 
	skillsetting = 0,
	easy = 0, 
	medium = 1, 
	hard = 2,
	pos = {}, 
	audio1 = nil, 
	audio6 = nil, 
	camfov = 60,  --185 default
	userfov = 90,  --seed
	fnav = {},	
	casualty = 0,
	randompick = 0, 
	randomlast = 0, 
	efacstate = 0, --Rebuild factory
	efactime = 99999.9, 
	rampstate = 0, --Ramp Stuff
	ramp = nil, 
	ramppos = {}, 
	lock1 = nil,	
	repel1 = nil, 
	convoystate = 0, --AI convoy
	convoylength = 0, 
	eapc = nil, 
	eatk = {}, 
	esil = nil, 
	ercy = nil, --AI buildings
	efac = nil, 
	earm = nil, 
	ebay = nil, 
	etrn = nil, 
	etec = nil, 
	ehqr = nil, 
	esld = nil, 
	egun = {}, 
	epwr = {},
	ewlkatktime = 99999.9, --walkers
	ewlkatktimeadd = 0.0, 
	ewlkresendtime = 99999.9, 
	ewlkatk = {}, 
	ewlkatklength = 0, 
	ewlkatkmeet = 2, --so will goto "1" 1st
	ewlkatkallow = false,	
	ewlkatkmarch = false, 
	ewlkatkthereyet = false, 
	ewlkatktarget = false, 
	eartatktime = 99999.9, --eartillery
	eartatk = {}, 
	eartatklength = 0, 
	eartatkmeet = 2, --so will goto "1" 1st
	eartatkallow = false, 
	eartatkmarch = false, 
	eartatkthereyet = false, 
	eartatktarget = 99999.9, 
	emintime = 99999.9, --eminelayers
	eminlength = 2, 
	emingo = {}, 
	emin = {}, 
	emincool = {}, 
	eminallow = {},	
	eminlife = {}, 
	eturtime = 99999.9, --eturret
	eturlength = 20,	
	etur = {}, 
	eturlife = {}, 
	eturcool = {}, 
	eturallow = {}, 
	etursecs = {}, 
	etursecsadd = {}, 
	epattime = 99999.9, --epatrols
	epatlength = 4, 
	epat = {}, 
	epatlife = {}, 
	epatcool = {}, 
	epatallow = {},	
	epatsecs = {}, 
	escv = {}, --scav stuff
	escvlength = 2, 
	wreckbank = false, --have 2
	escvbuildtime = {}, 
	escvstate = {}, 
	wreckstate = 0, --daywrecker
	wrecktime = 99999.9, 
	wrecktrgt = {},
	wreckbomb = nil, 
	wreckname = "apdwrkk", 
	wreckbank = false, --have 2
	wrecknotify = 0, 
	fgrp = {}, --fbase stuff
	frcy = nil, 
	ffac = nil, 
	farm = nil, 
	fpwr = {nil, nil, nil, nil}, 
	fcom = nil,
	fbay = nil,
	ftrn = nil,
	ftec = nil,
	fhqr = nil,
	fsld = nil, 
	fartlength = 100, --fart killers
	fart = {}, 
	ekillarttime = 99999.9,
	ekillartlength = 4, 
	ekillart = {}, 
	ekillartcool = {}, 
	ekillartallow = {}, 
	ekillarttarget = nil, 
	ekillartmarch = false, 
	ewardeclare = false, --WARCODE
	ewartotal = 4, --1 recy, 2 fact, 3 armo, 4 base 
	ewarrior = {}, 
	ewartime = {},
	ewartimecool = {},
	ewartimeadd = {},
	ewarabortset = {}, 
	ewarabort = {}, 
	ewarstate = {}, 
	ewarsize = {}, 
	ewarwave = {}, 
	ewarwavemax = {}, 
	ewarwavereset = {}, 
	ewarmeet = {}, 
	ewarriortime = {},
	ewarriorplan = {}, 
	ewartrgt = {}, 
	ewarpos = {}, 
	weappick = 0, 
	weaplast = 0, 
	LAST = true
}
--PATHS: fprcy, fpgrp1-8, pmytank, ppatrol1-4, eptur1-20, epmin1-2, stage1-4, ebasearea, pscrap(0-120), eprcy, epgrcy, epfac, epgfac, epapc, epwarn, epbolt(0-20), epbolt2(0-36), epart(0-30)

function InitialSetup()
	SetAutoGroupUnits(true)
		
	local odfpreload = {
		"kvscout", "kvmbike", "kvmisl", "kvtank", "kvrckt", "kvhtnk", "kvartl",	"kvwalk", "kvapc", "kvapcdw14", 
		"bvrecy0", "bvtank", "bvturr", "gpopg1a", "olybolt2", "apdwrka", "npscrx", "apcamrb" 
	}
	for k,v in pairs(odfpreload) do
		PreloadODF(v)
	end
	
	x.mytank = GetHandle("mytank")
	x.ramp = GetHandle("ramp")
	x.lock1 = GetHandle("lock1")
	x.lock2 = GetHandle("lock2")
	x.esil = GetHandle("esil")
	x.ercy = GetHandle("ercy")
	x.efac = GetHandle("efac")
	x.earm = GetHandle("earm")
	x.etec = GetHandle("etec")
	x.ehqr = GetHandle("ehqr")
	x.ebay = GetHandle("ebay")
	x.etrn = GetHandle("etrn")
	for index = 3, 6 do --deployed escvs
		x.escv[index] = GetHandle(("escv%d"):format(index))
	end
	SetColorFade(6.0, 0.5, "BLACK")
	TCC.Init();
end

function Start()
	TCC.Start();
end
function Save()
	return
	index, index2, indexadd, x, TCC.Save()
end

function Load(a, b, c, d, coreData)
	index = a;
	index2 = b;
	indexadd = c;
	x = d;
	TCC.Load(coreData)
end

function AddObject(h)
	--get player base buildings for later attack
	if (not IsAlive(x.farm) or x.farm == nil) and (IsOdf(h, "bvarmo:1") or IsOdf(h, "bbarmo")) then
		x.farm = RepObject(h);
		h = x.farm;
	elseif (not IsAlive(x.ffac) or x.ffac == nil) and (IsOdf(h, "bvfact:1") or IsOdf(h, "bbfact")) then
		x.ffac = h
	elseif (not IsAlive(x.fsld) or x.fsld == nil) and IsOdf(h, "bbshld") then
		x.fsld = h
	elseif (not IsAlive(x.fhqr) or x.fhqr == nil) and IsOdf(h, "bbhqtr") then
		x.fhqr = h
	elseif (not IsAlive(x.ftec) or x.ftec == nil) and IsOdf(h, "bbtcen") then
		x.ftec = h
	elseif (not IsAlive(x.ftrn) or x.ftrn == nil) and IsOdf(h, "bbtrain") then
		x.ftrn = h
	elseif (not IsAlive(x.fbay) or x.fbay == nil) and IsOdf(h, "bbsbay") then
		x.fbay = h
	elseif (not IsAlive(x.fcom) or x.fcom == nil) and IsOdf(h, "bbcbun") then
		x.fcom = h
	elseif IsOdf(h, "bbpgen0") then
		for indexadd = 1, 4 do
			if x.fpwr[indexadd] == nil or not IsAlive(x.fpwr[indexadd]) then
				x.fpwr[indexadd] = h
				break
			end
		end
	else
		ReplaceStabber(h);
	end
	
	--get daywrecker for highlight
	if (not IsAlive(x.wreckbomb) or x.wreckbomb == nil) and IsOdf(h, "apdwrkk") then 
		if GetTeamNum(h) == 5 then
			x.wreckbomb = h --get handle to launched daywrecker
		end
	end
	
	for indexadd = 1, x.fartlength do --new artillery? 
		if (not IsAlive(x.fart[indexadd]) or x.fart[indexadd] == nil) and IsOdf(h, "kvartl:1") then
			x.fart[indexadd] = h
		end
	end
	TCC.AddObject(h);
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
	--START THE MISSION BASICS
	if x.spine == 0 then
		x.audio1 = AudioMessage("tcdw1401.wav") --to S is last CRA base. Take it out. Heavily mined and gtows
		x.frcy = BuildObject("bvrecy0", 1, "fprcy")
		Goto(x.frcy, "fprcy", 0)
		SetGroup(x.frcy, 2)
		for index = 1, 4 do
			x.pos = GetTransform(x.fgrp[index])
			RemoveObject(x.fgrp[index])
			x.fgrp[index] = BuildObject("bvtank", 1, ("fpgrp%d"):format(index))
			GiveWeapon(x.fgrp[index], "gpopg1a")
			Goto(x.fgrp[index], ("fpgrp%d"):format(index), 0)
			SetGroup(x.fgrp[index], 0)
			x.fgrp[index+4] = BuildObject("bvturr", 1, ("fpgrp%d"):format(index+4))
			Goto(x.fgrp[index+4], ("fpgrp%d"):format(index+4), 0)
			SetGroup(x.fgrp[index+4], 5)
		end
		x.pos = GetTransform(x.mytank)
		RemoveObject(x.mytank)
		x.mytank = BuildObject("bvtank", 1, x.pos)
		LookAt(x.mytank, x.frcy, 0)
		for index = 1, x.ekillartlength do --init ekillart
			x.ekillarttime = GetTime()
			x.ekillart[index] = nil 
			x.ekillartcool[index] = 99999.9 
			x.ekillartallow[index] = false
		end
		for index = 1, x.ewartotal do --init WARCODE
			x.ewardeclare = true
			x.ewarrior[index] = {} --"rows"
			x.ewarriorplan[index] = {} --"rows"
			x.ewarriortime[index] = {} --"rows"
			x.ewartrgt[index] = {} --"rows"
			x.ewarpos[index] = {}
			for index2 = 1, 10 do --10 per wave max avail
				x.ewarrior[index][index2] = nil --"columns", init (handle in this case)
				x.ewarriorplan[index][index2] = 0
				x.ewarriortime[index][index2] = 99999.9
				x.ewartrgt[index][index2] = nil
				x.ewarpos[index][index2] = 0
			end
			x.ewarstate[index] = 1
			x.ewartime[1] = GetTime() + 1.0 --recy
			x.ewartime[2] = GetTime() + 30.0 --fact
			x.ewartime[3] = GetTime() + 60.0 --armo
			x.ewartime[4] = GetTime() + 90.0 --base
			x.ewartimecool[index] = 240.0
			x.ewartimeadd[index] = 5.0
			x.ewarabortset[index] = false
			x.ewarabort[index] = 99999.9
			x.ewarsize[index] = 0
			x.ewarwave[index] = 0
			x.ewarwavemax[index] = 5
			x.ewarwavereset[index] = 2
			x.ewarmeet[index] = 2
		end 
		x.camstate = 1
    x.userfov = IFace_GetInteger("options.graphics.defaultfov")
    CameraReady()
    IFace_SetInteger("options.graphics.defaultfov", x.camfov)
		x.spine = x.spine + 1	
	end
	
	--GIVE FIRST OBJECTIVE
	if x.spine == 1 and (IsAudioMessageDone(x.audio1) or CameraCancelled()) then
		x.pos = GetTransform(x.mytank)
		RemoveObject(x.mytank)
		x.mytank = BuildObject("bvtank", 1, x.pos)
		GiveWeapon(x.mytank, "gpopg1a")
		SetAsUser(x.mytank, 1)
		RemoveObject(x.player)
		x.player = GetPlayerHandle()
		TCC.SetTeamNum(x.player, 1)--JUST IN CASE
		x.camstate = 0
    CameraFinish()
    IFace_SetInteger("options.graphics.defaultfov", x.userfov)
		x.ramppos = GetTransform(x.ramp) --init ramp
		RemoveObject(x.ramp)
		ClearObjectives()
		AddObjective("tcdw1401.txt")
		SetScrap(1, 40)
		for index = 1, x.escvlength do --init escv
			x.escvbuildtime[index] = GetTime()
			x.escvstate[index] = 1
		end
		for index = 1, 13 do --olyboltmines
			x.fnav[index] = BuildObject("olybolt2", 5, "epbolt", index)
		end
		for index = 1, 35 do --olyboltmines hills
			x.fnav[index] = BuildObject("olybolt2", 5, "epbolt2", index)
		end
		for index = 1, 20 do
			x.fnav[index] = BuildObject("kvartl", 5, "epart", index)
		end
		x.eturlength = 20 --init tur
		for index = 1, x.eturlength do
			x.eturtime = GetTime()
			x.eturcool[index] = GetTime()
			x.eturallow[index] = true
			x.eturlife[index] = 0
			x.etursecs[index] = 0.0
			x.etursecsadd[index] = 0.0
		end
		for index = 1, 120 do
			x.fnav[index] = BuildObject("npscrx", 0, "pscrap", index)
		end
		x.repel1 = BuildObject("repelenemy100", 5, x.lock1)
		SetObjectiveName(x.lock1, "Ramp Lock")
		x.waittime = GetTime() + 240.0
		x.spine = x.spine + 1
	end
	
	--ANNOUNCE AND SETUP CONVOY TIME
	if x.spine == 2 and x.waittime < GetTime() then
		AudioMessage("tcdw1402.wav") --Skyeye report incoming (China) APC. Stop apc
		x.waittime = GetTime() + 600.0
		x.convoylength = 4
		x.convoystate = 1
		x.ewlkatktime = GetTime()
		x.spine = x.spine + 1
	end
	
	--SEND CRA CONVOY
	if x.spine == 3 and x.waittime < GetTime() then
		AudioMessage("tcdw1403.wav") --Apc is close now Lt. Take it out at earliest opportunity.
		ClearObjectives()
		AddObjective("tcdw1402.txt")
		x.eapc = BuildObject("kvapcdw14", 5, "epapc")
		Goto(x.eapc, "epapc")
		SetObjectiveOn(x.eapc)
		for index = 1, x.convoylength do
			x.eatk[index] = BuildObject("kvtank", 5, "epapc")
			Defend2(x.eatk[index], x.eapc)
		end
		for index = 1, x.epatlength do --init epat
			x.epattime = GetTime()
			x.epatcool[index] = GetTime()
			x.epatallow[index] = true
			x.epatsecs[index] = 0.0
			x.epatlife[index] = 0
		end
		x.spine = x.spine + 1
	end
	
	--CONVOY STATES
	if x.spine == 4 then
		if x.convoystate == 1 and IsAlive(x.eapc) and GetDistance(x.eapc, "epwarn") < 100 then
			AudioMessage("tcdw1404.wav") --Uh, Lt, apc is too close for comfort.
			x.convoystate = 2
		end
		if not IsAlive(x.eapc) then
			x.convoystate = 3 --to turn off apc escape fail
			SetObjectiveOff(x.eapc)
			AudioMessage("tcdw1405.wav") --Good work, now finish job and take out recy.
			ClearObjectives()
			AddObjective("tcdw1402.txt", "GREEN")
			AddObjective("	")
			AddObjective("tcdw1403.txt")
			for index = 1, x.convoylength do
				if IsAlive(x.eatk[index]) then
					Attack(x.eatk[index], x.player)
				end
			end
			x.spine = x.spine + 1
		end
	end
	
	--SEND ARTIL AND DAYWRECK ATTACK
	if x.spine == 5 then
		if x.skillsetting == x.easy then
			x.eartatktime = GetTime() + 120.0
			x.wrecktime = GetTime() + 240.0
		elseif x.skillsetting == x.medium then
			x.eartatktime = GetTime() + 90.0
			x.wrecktime = GetTime() + 210.0
		else
			x.eartatktime = GetTime() + 60.0
			x.wrecktime = GetTime() + 180.0
		end 
		x.emintime = GetTime() --init mines
		x.eminlength = 2
		x.eminlife[1] = 0
		x.eminlife[2] = 0
		x.spine = x.spine + 1
	end

	--MISSION SUCCESS
	if x.spine == 6 and not IsAlive(x.ercy) and not IsAlive(x.efac) and not IsAlive(x.earm) then
		AudioMessage("tcdw1406.wav") --SUCCEED - That was last Chinese recy on Ganymede
		ClearObjectives()
		AddObjective("tcdw1403.txt", "GREEN")
		AddObjective("\n\nMISSION COMPLETE", "GREEN")
		TCC.SucceedMission(GetTime() + 8.0, "tcdw14w.des") --WINNER WINNER WINNER
		x.MCAcheck = true
		x.spine = 888
	end
	----------END MAIN SPINE ----------
	
	--CAMERA 1 WATCH FRCY
	if x.camstate == 1 then
		CameraObject(x.mytank, 0, 10, -35, x.frcy)
	end
	
	--YOU SHALL NOT PASS (unless you've destroyed the lock, in which case, come on in, kick your shoes off, sit a spell)
	--Pass-through tunnel ramp to upper fortress would've been cooler, but AI pathing over tunnels was crap so did ramp.
	if x.rampstate == 0 and not IsAlive(x.ehqr) then
		AudioMessage("alertpulse.wav")
		AddObjective("\nDestroy the lock control to activate the access ramp.", "CYAN")
		RemoveObject(x.repel1)
		SetObjectiveOn(x.lock1)
		x.rampstate = 1
	elseif x.rampstate == 1 and not IsAlive(x.lock1) then
		x.ramp = BuildObject("gnyfortramp", 0, x.ramppos)
		AudioMessage("emdotcox.wav")
		x.rampstate = 2
	elseif x.rampstate == 2 then 
		--KEEP RAMP, NOW BUILDING RemoveObject(x.ramp)
		ClearObjectives()
		AddObjective("\nAccess ramp available.", "ALLYBLUE")
		AddObjective("	")
		AddObjective("tcdw1403.txt")
		x.rampstate = 3
	end
	
	--AI DAYWRECKER ATTACK --will stop if no earm, or no etec, or not enought scrap capacity (silos)
	if x.wreckstate == 0 and x.wrecktime < GetTime() and IsAlive(x.etec) and IsAlive(x.earm) and GetMaxScrap(5) >= 80 then	
		if GetScrap(5) < 80 then 
			SetScrap(5, 80) --gotta have money
		end
		x.wreckbank = true
		while x.randompick == x.randomlast do --random the random
			x.randompick = math.floor(GetRandomFloat(1.0, 12.0))
		end
		x.randomlast = x.randompick
		if IsAlive(x.ffac) and (x.randompick == 1 or x.randompick == 5 or x.randompick == 8 or x.randompick == 12) then
			x.wrecktrgt = GetPosition(x.ffac)
		elseif IsAlive(x.frcy) and (x.randompick == 2 or x.randompick == 6 or x.randompick == 9) then
			x.wrecktrgt = GetPosition(x.frcy)
		elseif IsAlive(x.fbay) and (x.randompick == 3 or x.randompick == 7 or x.randompick == 10) then
			x.wrecktrgt = GetPosition(x.fbay)
		else --4, 11
			x.wrecktrgt = GetPosition(x.player)
		end
		SetCommand(x.earm, 22, 1, 0, 0, x.wreckname) --build (don't use "Build" func)   
		x.wreckstate = x.wreckstate + 1
	elseif x.wreckstate == 1 and IsAlive(x.earm) then
		SetCommand(x.earm, 8, 1, 0, x.wrecktrgt, 0) --dropoff (don't use "Dropoff" func)
		x.wreckstate = x.wreckstate + 1
	elseif x.wreckstate == 2 and IsAlive(x.wreckbomb) then
		x.wreckbank = false --reset for scavs
		if x.skillsetting == x.easy and GetDistance(x.wreckbomb, x.wrecktrgt) < 400 then
			x.wrecknotify = 1
		elseif x.skillsetting == x.medium and GetDistance(x.wreckbomb, x.wrecktrgt) < 300 then
			x.wrecknotify = 1
		elseif x.skillsetting == x.hard and GetDistance(x.wreckbomb, x.wrecktrgt) < 200 then
			x.wrecknotify = 1
		end
		if x.wrecknotify == 1 then
      TCC.SetTeamNum(x.wreckbomb, 5)
			SetObjectiveOn(x.wreckbomb)
			AudioMessage("alertpulse.wav")
			x.wrecknotify = 0
			x.wreckstate = x.wreckstate + 1
		end
	elseif x.wreckstate == 3 and not IsAlive(x.wreckbomb) then		
		for index = 1, 12 do
			x.randompick = math.floor(GetRandomFloat(1.0, 9.0))
		end
		if x.randompick == 1 or x.randompick == 4 or x.randompick == 7 then
			x.wrecktime = GetTime() + 600.0
		elseif x.randompick == 2 or x.randompick == 5 or x.randompick == 8 then
			x.wrecktime = GetTime() + 420.0
		else
			x.wrecktime = GetTime() + 300.0
		end
		x.wreckstate = 0 --reset
	end
	
	--AI GROUP WALKERS
	if x.ewlkatktime < GetTime() and IsAlive(x.efac) and IsAlive(x.etec) then		
		if not x.ewlkatkallow then
			x.ewlkatklength = 4
			for index = 1, x.ewlkatklength do
				if index % 2 == 0 then --so don't bunch quite as bad
					x.ewlkatk[index] = BuildObject("kvwalk", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
				else
					x.ewlkatk[index] = BuildObject("kvwalk", 5, GetPositionNear("epgrcy", 0, 16, 32)) --grpspwn
				end 
				while x.weappick == x.weaplast do
					x.weappick = math.floor(GetRandomFloat(1.0, 12.0))
				end
				x.weaplast = x.weappick
				--DON'T USE FOR OTHER UNITS (UNIQUE UNIT NAME)
				if x.weappick == 1 or x.weappick == 5 or x.weappick == 9 then
					GiveWeapon(x.ewlkatk[index], "gblsta_a")
				elseif x.weappick == 2 or x.weappick == 6 or x.weappick == 10 then
					GiveWeapon(x.ewlkatk[index], "gflsha_a")
				elseif x.weappick == 3 or x.weappick == 7 or x.weappick == 11 then
					GiveWeapon(x.ewlkatk[index], "gstbva_a")
				else
					GiveWeapon(x.ewlkatk[index], "gstbta_a")
				end
				SetSkill(x.ewlkatk[index], x.skillsetting)
			end
			x.ewlkatkmarch = true
			x.ewlkatkallow = true
		end
		
		if x.ewlkatkmarch then
			if x.ewlkatkmeet == 2 then
				x.ewlkatkmeet = 1
			else
				x.ewlkatkmeet = 2
			end
			for index = 1, x.ewlkatklength do
				if IsAlive(x.ewlkatk[index]) then
					if IsInsideArea("ebasearea", x.frcy) then
						Goto(x.ewlkatk[index], "stage4")
						x.ewlkatkmeet = 4
					elseif x.ewlkatkmeet == 1 then
						Goto(x.ewlkatk[index], "stage1")
					else
						Goto(x.ewlkatk[index], "stage2")
					end
				end
			end
			x.ewlkatkthereyet = true
			x.ewlkatktarget = false
			x.ewlkatkmarch = false
		end
		
		if x.ewlkatkthereyet then
			for index = 1, x.ewlkatklength do
				if IsAlive(x.ewlkatk[index]) 
				and ((x.ewlkatkmeet == 1 and (GetDistance(x.ewlkatk[index], "stage1", 20) < 70)) 
				or (x.ewlkatkmeet == 2 and (GetDistance(x.ewlkatk[index], "stage2", 20) < 70))
				or (x.ewlkatkmeet == 4	and (GetDistance(x.ewlkatk[index], "stage4", 7) < 70)))then
					x.ewlkatkthereyet = false
					x.ewlkatktarget = true
					break
				end
			end
			x.ewlkresendtime = GetTime()
		end
		
		if x.ewlkatktarget and x.ewlkresendtime < GetTime() then
			for index = 1, x.ewlkatklength do
				if IsAlive(x.ewlkatk[index]) then
					SetCurAmmo(x.ewlkatk[index], GetMaxAmmo(x.ewlkatk[index]))
					Goto(x.ewlkatk[index], x.frcy) --let walker do what it wants
				end
			end
			x.ewlkresendtime = GetTime() + 60.0
			x.ewlkatktarget = false
		end
		
		if x.ewlkatkallow then
			for index = 1, x.ewlkatklength do
				if not IsAlive(x.ewlkatk[index]) then
					x.casualty = x.casualty + 1
				end
			end
			
			if x.casualty >= math.floor(x.ewlkatklength * 0.8) then
				if x.skillsetting == x.easy then
					x.ewlkatktime = GetTime() + 420.0
				elseif x.skillsetting == x.medium then
					x.ewlkatktime = GetTime() + 360.0
				else
					x.ewlkatktime = GetTime() + 300.0
				end
				x.ewlkatktimeadd = x.ewlkatktimeadd + 60.0
				x.ewlkatkallow = false
			end
			x.casualty = 0
		end
	end
	
	--AI GROUP ARTILLERY
	if x.eartatktime < GetTime() and IsAlive(x.efac) and IsAlive(x.ebay) then		
		if not x.eartatkallow then
			x.eartatklength = 6 --remove skillbased length (4 6 8)
			for index = 1, x.eartatklength do
        x.eartatk[index] = BuildObject("kvartl", 5, GetPositionNear("epgfac", 0, 16, 32))
				SetSkill(x.eartatk[index], x.skillsetting)
			end
			x.eartatkmarch = true
			x.eartatkallow = true
		end
		
		if x.eartatkmarch then --alternate
			if x.eartatkmeet == 2 then
				x.eartatkmeet = 1
			else
				x.eartatkmeet = 2
			end
			for index = 1, x.eartatklength do
				if IsAlive(x.eartatk[index]) then
					if x.eartatkmeet == 1 then
						Retreat(x.eartatk[index], "stage1")
					else
						Retreat(x.eartatk[index], "stage2")
					end
				end
			end
			x.eartatkthereyet = true
			x.eartatkmarch = false
		end
		
		if x.eartatkthereyet then
			for index = 1, x.eartatklength do
				if IsAlive(x.eartatk[index]) 
				and ((x.eartatkmeet == 1 and (GetDistance(x.eartatk[index], "stage1", 20) < 50)) 
				or (x.eartatkmeet == 2 and (GetDistance(x.eartatk[index], "stage2", 20) < 50))) then
					x.eartatkthereyet = false
					x.eartatktarget = GetTime()
					break
				end
			end
		end
		
		if x.eartatktarget < GetTime() then
			for index = 1, x.eartatklength do
				if IsAlive(x.eartatk[index]) and IsAlive(x.fsld) then
					Attack(x.eartatk[index], x.fsld)
				elseif IsAlive(x.eartatk[index]) and IsAlive(x.fhqr) then
					Attack(x.eartatk[index], x.fhqr)
				elseif IsAlive(x.eartatk[index]) and IsAlive(x.ftec) then
					Attack(x.eartatk[index], x.ftec)
				elseif IsAlive(x.eartatk[index]) and IsAlive(x.ftrn) then
					Attack(x.eartatk[index], x.ftrn)
				elseif IsAlive(x.eartatk[index]) and IsAlive(x.fbay) then
					Attack(x.eartatk[index], x.fbay)
				elseif IsAlive(x.eartatk[index]) and IsAlive(x.fcom) then
					Attack(x.eartatk[index], x.fcom)
				elseif IsAlive(x.eartatk[index]) and IsAlive(x.fpwr[4]) then
					Attack(x.eartatk[index], x.fpwr[4])
				elseif IsAlive(x.eartatk[index]) and IsAlive(x.fpwr[3]) then
					Attack(x.eartatk[index], x.fpwr[3])
				elseif IsAlive(x.eartatk[index]) and IsAlive(x.fpwr[2]) then
					Attack(x.eartatk[index], x.fpwr[2])
				elseif IsAlive(x.eartatk[index]) and IsAlive(x.fpwr[1]) then
					Attack(x.eartatk[index], x.fpwr[1])
				elseif IsAlive(x.eartatk[index]) and IsAlive(x.farm) then
					Attack(x.eartatk[index], x.farm)
				elseif IsAlive(x.eartatk[index]) and IsAlive(x.ffac) then
					Attack(x.eartatk[index], x.ffac)
				elseif IsAlive(x.eartatk[index]) and IsAlive(x.frcy) then
					Attack(x.eartatk[index], x.frcy)
				end
			end
			x.eartatktarget = GetTime() + 30.0
		end
		
		if x.eartatkallow then
			for index = 1, x.eartatklength do
				if not IsAlive(x.eartatk[index]) then
					x.casualty = x.casualty + 1
				end
			end
			if x.casualty >= math.floor(x.eartatklength * 0.8) then
				if x.skillsetting == x.easy then
					x.eartatktime = GetTime() + 390.0
				elseif x.skillsetting == x.medium then
					x.eartatktime = GetTime() + 330.0
				else
					x.eartatktime = GetTime() + 300.0
				end
				x.eartatktarget = 99999.9
				x.eartatkallow = false
			end
			x.casualty = 0
		end
	end
	
	--AI GROUP TURRETS --special this mission
	if x.eturtime < GetTime() and IsAlive(x.ercy) and IsAlive(x.etrn) then
		for index = 1, x.eturlength do
			if not IsAlive(x.etur[index]) and not x.eturallow[index] and x.eturlife[index] < 3 then
				x.etursecs[index] = x.etursecs[index] + x.etursecsadd[index]
				x.eturcool[index] = GetTime() + 180.0 + x.etursecs[index]
				x.eturallow[index] = true
			end
			if x.eturallow[index] and x.eturcool[index] < GetTime() then
				x.etur[index] = BuildObject("kvturr", 5, GetPositionNear("epgrcy", 0, 16, 32)) --grpspwn
				Goto(x.etur[index], ("eptur%d"):format(index))
				SetSkill(x.etur[index], x.skillsetting)
				--SetObjectiveName(x.etur[index], ("Adder %d"):format(index))
				x.eturlife[index] = x.eturlife[index] + 1
				x.etursecsadd[index] = x.etursecsadd[index] + 60.0
				x.eturallow[index] = false
			end
		end
	end

	--AI GROUP PATROLS --extension add
	if x.epattime < GetTime() and IsAlive(x.efac) and IsAlive(x.etrn) then
		for index = 1, x.epatlength do
			if not IsAlive(x.epat[index]) and not x.epatallow[index] and x.epatlife[index] < 4 then
				x.epatsecs[index] = x.epatsecs[index] + 10.0
				x.epatcool[index] = GetTime() + 240.0 + x.epatsecs[index]
				x.epatallow[index] = true
			end
			if x.epatallow[index] and x.epatcool[index] < GetTime() then				
				while x.randompick == x.randomlast do --random the random
					x.randompick = math.floor(GetRandomFloat(1.0, 9.0))
				end
				x.randomlast = x.randompick
				if x.randompick == 1 or x.randompick == 4 or x.randompick == 7 then
					x.epat[index] = BuildObject("kvmbike", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
				elseif x.randompick == 2 or x.randompick == 5 or x.randompick == 8 then
					x.epat[index] = BuildObject("kvmisl", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
				else
					x.epat[index] = BuildObject("kvtank", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
				end
				if index == 1 or index == 6 then
					Patrol(x.epat[index], "ppatrol1")
				elseif index == 2 or index == 7 then
					Patrol(x.epat[index], "ppatrol2")
				elseif index == 3 or index == 8 then
					Patrol(x.epat[index], "ppatrol3")
				elseif index == 4 or index == 5 then
					Patrol(x.epat[index], "ppatrol4")
				end
				SetSkill(x.epat[index], x.skillsetting)
				--SetObjectiveName(x.epat[index], ("Patrol %d"):format(index))
				x.epatlife[index] = x.epatlife[index] + 1
				x.epatallow[index] = false
			end
		end
		x.epattime = GetTime() + 30.0
	end
	
	--WARCODE W/ CLOAKING --special DW14
	if x.ewardeclare then
		for index = 1, x.ewartotal do	
			if x.ewartime[index] < GetTime() then 
				--SET WAVE NUMBER AND BUILD SIZE
				if x.ewarstate[index] == 1 then	
					x.ewarwave[index] = x.ewarwave[index] + 1
					if x.ewarwave[index] > x.ewarwavemax[index] then
						x.ewarwave[index] = x.ewarwavereset[index]
					end
					--SET WAVE SIZE
					if x.ewarwave[index] == 1 then
						x.ewarsize[index] = 2
					elseif x.ewarwave[index] == 2 then
						x.ewarsize[index] = 4
					elseif x.ewarwave[index] == 3 then
						if index == 1 then
							x.ewarsize[index] = 6
						elseif index == 2 then
							x.ewarsize[index] = 6
						elseif index == 3 then
							x.ewarsize[index] = 4
						elseif index == 4 then
							x.ewarsize[index] = 4
						else
							x.ewarsize[index] = 3
						end
					elseif x.ewarwave[index] == 4 then
						if index == 1 then
							x.ewarsize[index] = 8
						elseif index == 2 then
							x.ewarsize[index] = 7
						elseif index == 3 then
							x.ewarsize[index] = 6
						elseif index == 4 then
							x.ewarsize[index] = 5
						else
							x.ewarsize[index] = 4
						end 
					else --x.ewarwave[index] == 5 then
						if index == 1 then
							x.ewarsize[index] = 10
						elseif index == 2 then
							x.ewarsize[index] = 8
						elseif index == 3 then
							x.ewarsize[index] = 6
						elseif index == 4 then
							x.ewarsize[index] = 6
						else
							x.ewarsize[index] = 5
						end
					end
					x.ewarstate[index] = x.ewarstate[index] + 1
				--BUILD FORCE
				elseif x.ewarstate[index] == 2 then
					for index2 = 1, x.ewarsize[index] do
						while x.randompick == x.randomlast do --random the random
							x.randompick = math.floor(GetRandomFloat(1.0, 18.0))
						end
						x.randomlast = x.randompick
						if not IsAlive(x.efac) then
							x.randompick = 1
						end
						if x.randompick == 1 or x.randompick == 7 or x.randompick == 13 then
							x.ewarrior[index][index2] = BuildObject("kvscout", 5, GetPositionNear("epgrcy", 0, 16, 32)) --grpspwn
							if x.ewarwave[index] == 3 or x.ewarwave[index] == 4 then
								GiveWeapon(x.ewarrior[index][index2], "glasea_c")
							end
						elseif x.randompick == 2 or x.randompick == 8 or x.randompick == 14 then
							x.ewarrior[index][index2] = BuildObject("kvmbike", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
							if x.ewarwave[index] == 2 or x.ewarwave[index] == 4 then
								GiveWeapon(x.ewarrior[index][index2], "gstbva_c")
							end
						elseif x.randompick == 3 or x.randompick == 9 or x.randompick == 15 then
							x.ewarrior[index][index2] = BuildObject("kvmisl", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
							if x.ewarwave[index] == 3 or x.ewarwave[index] == 5 then
								GiveWeapon(x.ewarrior[index][index2], "gfafma_c")
							end
						elseif x.randompick == 4 or x.randompick == 10 or x.randompick == 16 then
							x.ewarrior[index][index2] = BuildObject("kvtank", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
							if x.ewarwave[index] == 4 or x.ewarwave[index] == 5 then
								GiveWeapon(x.ewarrior[index][index2], "gstbsa_c")
							end
						elseif x.randompick == 5 or x.randompick == 11 or x.randompick == 17 then
							x.ewarrior[index][index2] = BuildObject("kvrckt", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
							if x.ewarwave[index] == 3 or x.ewarwave[index] == 5 then
								GiveWeapon(x.ewarrior[index][index2], "gshdwa_a") --salvo rckt
							end
						else --6, 12, 18
							if x.ewarwave[index] > 1 then
								x.ewarrior[index][index2] = BuildObject("kvhtnk", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
							else
								x.ewarrior[index][index2] = BuildObject("kvtank", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
							end
						end
						SetSkill(x.ewarrior[index][index2], x.skillsetting)
						SetCommand(x.ewarrior[index][index2], 47)
						x.ewartrgt[index][index2] = nil
					end
					x.ewarabort[index] = GetTime() + 360.0 --here first in case stage goes wrong
					x.ewarstate[index] = x.ewarstate[index] + 1
				--GIVE MARCHING ORDERS
				elseif x.ewarstate[index] == 3 then
					if x.ewarmeet[index] == 2 then
						x.ewarmeet[index] = 1
					else
						x.ewarmeet[index] = 2
					end
					for index2 = 1, x.ewarsize[index] do
						if IsAlive(x.ewarrior[index][index2]) then
							if x.ewarmeet[index] == 2 and ((index == 1 and IsInsideArea("ebasearea", x.frcy)) 
							or (index == 2 and IsInsideArea("ebasearea", x.ffac))
							or (index == 3 and IsInsideArea("ebasearea", x.farm))) then
								Retreat(x.ewarrior[index][index2], "stage4")
								x.ewarmeet[index] = 4
							elseif x.ewarmeet[index] == 1 and ((index == 1 and IsInsideArea("ebasearea", x.frcy)) 
							or (index == 2 and IsInsideArea("ebasearea", x.ffac))
							or (index == 3 and IsInsideArea("ebasearea", x.farm))) then
								Retreat(x.ewarrior[index][index2], "stage3")
								x.ewarmeet[index] = 3
							elseif x.ewarmeet[index] == 1 then
								Retreat(x.ewarrior[index][index2], "stage1")
							else
								Retreat(x.ewarrior[index][index2], "stage2")
							end
						end
					end
					x.ewarstate[index] = x.ewarstate[index] + 1
				--A UNIT AT STAGE PT
				elseif x.ewarstate[index] == 4 then
					for index2 = 1, x.ewarsize[index] do
						if IsAlive(x.ewarrior[index][index2]) 
						and ((x.ewarmeet[index] == 1 and GetDistance(x.ewarrior[index][index2], "stage1", 20) < 50) 
							or (x.ewarmeet[index] == 2 and GetDistance(x.ewarrior[index][index2], "stage2", 20) < 50)
							or (x.ewarmeet[index] == 3 and GetDistance(x.ewarrior[index][index2], "stage3", 7) < 50)
							or (x.ewarmeet[index] == 4 and GetDistance(x.ewarrior[index][index2], "stage4", 7) < 50)) then
							x.ewarstate[index] = x.ewarstate[index] + 1
							break
						end
					end
				--CONDUCT UNIT BATTLE
				elseif x.ewarstate[index] == 5 then
					--PICK TARGET FOR EACH ATTACKER
					for index2 = 1, x.ewarsize[index] do
						if IsAlive(x.ewarrior[index][index2]) and (not IsAlive(x.ewartrgt[index][index2]) or x.ewartrgt[index][index2] == nil) then
							if index == 1 then
								if IsAlive(x.frcy) then
									x.ewartrgt[index][index2] = x.frcy
								elseif IsAlive(x.ffac) then
									x.ewartrgt[index][index2] = x.ffac
								elseif IsAlive(x.farm) then
									 x.ewartrgt[index][index2] = x.farm
								else
									x.ewartrgt[index][index2] = x.player
								end
								--SetObjectiveName(x.ewarrior[index][index2], ("%d Recy Killer %d"):format(x.ewarwave[index], index2))
								--SetObjectiveOn(x.ewarrior[index][index2])
							elseif index == 2 then
								if IsAlive(x.ffac) then
									x.ewartrgt[index][index2] = x.ffac
								elseif IsAlive(x.farm) then
									x.ewartrgt[index][index2] = x.farm
								elseif IsAlive(x.frcy) then
									x.ewartrgt[index][index2] = x.frcy
								else
									x.ewartrgt[index][index2] = x.player
								end
								--SetObjectiveName(x.ewarrior[index][index2], ("%d Fact Killer %d"):format(x.ewarwave[index], index2))
								--SetObjectiveOn(x.ewarrior[index][index2])
							elseif index == 3 then
								if IsAlive(x.farm) then
									x.ewartrgt[index][index2] = x.farm
								elseif IsAlive(x.ffac) then
									x.ewartrgt[index][index2] = x.ffac
								elseif IsAlive(x.frcy) then
									x.ewartrgt[index][index2] = x.frcy
								else
									x.ewartrgt[index][index2] = x.player
								end
								--SetObjectiveName(x.ewarrior[index][index2], ("%d Armo Killer %d"):format(x.ewarwave[index], index2))
								--SetObjectiveOn(x.ewarrior[index][index2])
							elseif index == 4 then
								if IsAlive(x.fsld) then
									x.ewartrgt[index][index2] = x.fsld
								elseif IsAlive(x.fhqr) then
									x.ewartrgt[index][index2] = x.fhqr
								elseif IsAlive(x.ftec) then
									x.ewartrgt[index][index2] = x.ftec
								elseif IsAlive(x.ftrn) then
									x.ewartrgt[index][index2] = x.ftrn
								elseif IsAlive(x.fbay) then
									x.ewartrgt[index][index2] = x.fbay
								elseif IsAlive(x.fcom) then
									x.ewartrgt[index][index2] = x.fcom
								elseif IsAlive(x.fpwr[4]) then
									x.ewartrgt[index][index2] = x.fpwr[4]
								elseif IsAlive(x.fpwr[3]) then
									x.ewartrgt[index][index2] = x.fpwr[3]
								elseif IsAlive(x.fpwr[2]) then
									x.ewartrgt[index][index2] = x.fpwr[2]
								elseif IsAlive(x.fpwr[1]) then
									x.ewartrgt[index][index2] = x.fpwr[1]
								elseif IsAlive(x.farm) then
									x.ewartrgt[index][index2] = x.farm
								elseif IsAlive(x.ffac) then
									x.ewartrgt[index][index2] = x.ffac
								elseif IsAlive(x.frcy) then
									x.ewartrgt[index][index2] = x.frcy
								else
									x.ewartrgt[index][index2] = x.player
								end
								--SetObjectiveName(x.ewarrior[index][index2], ("%d Base Killer %d"):format(x.ewarwave[index], index2))
								--SetObjectiveOn(x.ewarrior[index][index2])
							else --safety call, shouldn't ever run
								x.ewartrgt[index][index2] = x.player
								--SetObjectiveName(x.ewarrior[index][index2], ("%d Assn Killer %d"):format(x.ewarwave[index], index2))
								--SetObjectiveOn(x.ewarrior[index][index2])
							end
							x.ewarpos[index][index2] = GetPosition(x.ewartrgt[index][index2])
							if not x.ewarabortset[index] then
								x.ewarabort[index] = x.ewartime[index] + 420.0
								x.ewarabortset[index] = true
							end
							x.ewarriortime[index][index2] = GetTime() + 1.0
							x.ewarriorplan[index][index2] = 1
						end
						--GIVE ATTACK (MULTIPLE "ATTACK" USED SO IF 1ST TARGET IS KILLED, WILL ATTACK NEXT TARGET)
						if x.ewarriorplan[index][index2] == 1 and IsAlive(x.ewarrior[index][index2]) and x.ewarriortime[index][index2] < GetTime() then
							Retreat(x.ewarrior[index][index2], x.ewarpos[index][index2])
							x.ewarriorplan[index][index2] = x.ewarriorplan[index][index2] + 1
						end
						--CHECK TARGET STATUS, LOCATION, AND DECLOAK
						if x.ewarriorplan[index][index2] == 2 and IsAlive(x.ewarrior[index][index2]) and GetDistance(x.ewarrior[index][index2], x.ewarpos[index][index2]) < 130 then
              Attack(x.ewarrior[index][index2], x.ewartrgt[index][index2])
							SetCommand(x.ewarrior[index][index2], 48)
							x.ewarriortime[index][index2] = GetTime() + 2.0 --increase to ensure full update
							x.ewarriorplan[index][index2] = x.ewarriorplan[index][index2] + 1
						end
						--COMMIT TO ATTACK IF TARGET STILL EXISTS
						if x.ewarriorplan[index][index2] == 3 and IsAlive(x.ewarrior[index][index2]) and x.ewarriortime[index][index2] < GetTime() and GetTeamNum(x.ewarrior[index][index2]) ~= 1 then
							if not IsAlive(x.ewartrgt[index][index2]) and IsAlive(x.frcy) then
								x.ewartrgt[index][index2] = x.frcy
							elseif not IsAlive(x.ewartrgt[index][index2]) and not IsAlive(x.frcy) then
								x.ewartrgt[index][index2] = x.player
							end
							Attack(x.ewarrior[index][index2], x.ewartrgt[index][index2])
							x.ewarriortime[index][index2] = GetTime() + 30.0
						end
						--CHECK IF SQUAD MEMBER DEAD
						if not IsAlive(x.ewarrior[index][index2]) or (IsAlive(x.ewarrior[index][index2]) and GetTeamNum(x.ewarrior[index][index2]) == 1) then
							x.ewarriortime[index][index2] = 99999.9
							x.ewartrgt[index][index2] = nil
							x.ewarriorplan[index][index2] = 0
							x.casualty = x.casualty + 1
						end
					end
					
					--DO CASUALTY COUNT
					if x.casualty >= math.floor(x.ewarsize[index] * 0.8) then --reset attack group
						x.ewarabort[index] = 99999.9
						x.ewartimeadd[index] = x.ewartimeadd[index] + 5.0
						x.ewartime[index] = GetTime() + x.ewartimecool[index] + x.ewartimeadd[index]
						if x.ewarwave[index] == 5 then --extra 120s after max wave to "ease up"
							x.ewartime[index] = GetTime() + x.ewartimecool[index] + x.ewartimeadd[index] + 120.0
						end
						x.ewarstate[index] = 1 --RESET
						x.ewarabortset[index] = false
						for index2 = 1, x.ewarsize[index] do --DIFFERENT B/C EACH UNIT HAS UNIQUE TARGET CALL
							Goto(x.ewarrior[index][index2], x.frcy)
							SetCommand(x.ewarrior[index][index2], 48)
						end
					end
					x.casualty = 0
				end
			end
			
			--ABORT AND RESET IF NEEDED
			if x.ewarabort[index] < GetTime() then
				x.ewartime[index] = GetTime()
				x.ewarstate[index] = 1 --RESET
				x.ewarabort[index] = 99999.9
				x.ewarabortset[index] = false
			end
		end
	end--WARCODE END
	
	--REBUILD AI FACTORY
	if x.efacstate == 0 and not IsAlive(x.efac) and IsAlive(x.ercy) then
		x.efactime = GetTime() + 120.0
		x.efacstate = 1
	elseif x.efacstate == 1 and GetDistance(x.player, "epfac") > 420 and x.efactime < GetTime() then
		x.efac = BuildObject("kbfact", 5, "epfac")
		x.efacstate = 0
	end

	--AI GROUP MINELAYERS (limited lives)
	if x.emintime < GetTime() and IsAlive(x.efac) then
		for index = 1, x.eminlength do
			if (not IsAlive(x.emin[index]) or (IsAlive(x.emin[index]) and GetTeamNum(x.emin[index]) == 1)) and not x.eminallow[index] and x.eminlife[index] < 2 then
				x.emincool[index] = GetTime() + 300.0
				x.eminallow[index] = true
			end
			
			if x.eminallow[index] and x.emincool[index] < GetTime() then
				x.emin[index] = BuildObject("kvmine", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
				SetSkill(x.emin[index], x.skillsetting)
				--SetObjectiveName(x.emin[index], ("Khan %d"):format(index))
				Goto(x.emin[index], ("epmin%d"):format(index)) --resend orders
				x.emingo[index] = true
				x.eminallow[index] = false
				x.eminlife[index] = x.eminlife[index] + 1
				--x.emintime = GetTime() + 120.0
			end
			
			if IsAlive(x.emin[index]) and GetCurAmmo(x.emin[index]) <= math.floor(GetMaxAmmo(x.emin[index]) * 0.5) and GetTeamNum(x.emin[index]) ~= 1 then
				SetCurAmmo(x.emin[index], GetMaxAmmo(x.emin[index]))
				Goto(x.emin[index], ("epmin%d"):format(index)) --resend orders
				x.emingo[index] = true
			end
			
			if x.emingo[index] and GetDistance(x.emin[index], ("epmin%d"):format(index)) < 30 and GetTeamNum(x.emin[index]) ~= 1 then
				Mine(x.emin[index], ("epmin%d"):format(index))
				x.emingo[index] = false
			end
		end
	end
	
	--AI GROUP SCAVENGERS
	if IsAlive(x.ercy) then
		if GetScrap(5) > 39 and not x.wreckbank then --don't interfere with daywrecker
			SetScrap(5, (GetMaxScrap(5) - 40))
		end
		for index = 1, x.escvlength do
			if x.escvstate[index] == 1 and not IsAlive(x.escv[index]) then
				x.escvbuildtime[index] = GetTime() + 180.0
				x.escvstate[index] = 2
			elseif x.escvstate[index] == 2 and x.escvbuildtime[index] < GetTime() then
				x.escv[index] = BuildObject("kvscav", 5, GetPositionNear("epgrcy", 0, 16, 32)) --grpspwn
				x.escvstate[index] = 1
			end
		end
	end
	
	--AI ARTILLERY ASSASSIN
	if x.ekillarttime < GetTime() and IsAlive(x.efac) then
		for index = 1, x.ekillartlength do
			if not IsAlive(x.ekillart[index]) and not x.ekillartallow[index] then
				x.ekillartcool[index] = GetTime() + 120.0
				x.ekillartallow[index] = true
			end
			if x.ekillartallow[index] and x.ekillartcool[index] < GetTime() and GetDistance(x.player, "epgfac") > 300 then
				x.ekillart[index] = BuildObject("kvtank", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
				SetSkill(x.ekillart[index], x.skillsetting)
				--SetObjectiveName(x.ekillart[index], "Artl Killer")
				if IsAlive(x.ercy) then
					Defend2(x.ekillart[index], x.ercy)
				else
					Defend2(x.ekillart[index], x.efac)
				end
				x.ekillartallow[index] = false
			end
		end
		for index = 1, x.fartlength do
			if IsAlive(x.fart[index]) and GetDistance(x.fart[index], x.ercy) < 600 then
				x.ekillarttarget = x.fart[index]
				x.ekillartmarch = true
				break
			end
		end
		if x.ekillartmarch then
			for index = 1, x.ekillartlength do
        if IsAlive(x.ekillart[index]) and GetTeamNum(x.ekillart[index]) ~= 1 then
          Attack(x.ekillart[index], x.ekillarttarget)
        end
			end
			x.ekillarttime = GetTime() + 180.0 --give time for attack
			x.ekillartmarch = false
		end
	end

	--CHECK STATUS OF MCA 
	if not x.MCAcheck then		
		if x.convoystate == 2 and IsAlive(x.eapc) and IsInsideArea("ebasearea", x.eapc) then
			AudioMessage("tcdw1407.wav") --FAIL - the apc got through
			ClearObjectives()
			AddObjective("CRA APC got through.\n\nMISSION FAILED!", "RED")
			TCC.FailMission(GetTime() + 11.0, "tcdw14f1.des") --LOSER LOSER LOSER
			x.spine = 666
			x.MCAcheck = true
		end
		
		if not IsAlive(x.frcy) then --production lost
			AudioMessage("tcdw1408.wav") --FAIL - lost recy -generic against CRA
			ClearObjectives()
			AddObjective("Recycler destroyed.\n\nMISSION FAILED!", "RED")
			TCC.FailMission(GetTime() + 11.0, "tcdw14f2.des") --LOSER LOSER LOSER
			x.spine = 666
			x.MCAcheck = true
		end
	end
end
--[[END OF SCRIPT]]