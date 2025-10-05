--bztcdw05 - Battlezone Total Command - Dogs of War - 5/15 - ACHILLES HEEL
assert(load(assert(LoadFile("_requirefix.lua")),"_requirefix.lua"))();
TCC = require("TC_Core")
MisnNum = 35;
local index = 0
local index2 = 0
local indexadd = 0
local x = {
	FIRST = true, 	
	spine = 0, 
	waittime = 99999.9, 
	MCAcheck = false, 
	player = nil, 
	mytank = nil, 
	skillsetting = 0,
	easy = 0, 
	medium = 1, 
	hard = 2, --tried 1-3, in 185, 3 didn't seem to make any difference, 
	pos = {}, 
	audio1 = nil, 
	fnav = {},	
	casualty = 0,
	camfov = 60,  --185 default
	userfov = 90,  --seed
	randompick = 0, 
	randomlast = 0,
	victory = false, 
	dummy = nil, --portal dummies
	gotdummy = false, 
	dummypos = {}, 
	dummy2 = nil, 
	gotdummy2 = false, 
	extlives = false, 
	escapegrp = {}, --escape
	escapestate = 0, 
	escapetime = 99999.9, 
	esneakattack = 0, --sneak attack
	esneak = {}, 
	esneaklength = 10, 
	esneakwarn = false, 
	poolall = 0, --bio-metal pool mark
	poolmark = {false, false, false, false, false, false}, 
	pooltank = nil, 
	poolobject = {}, 
	eprt = nil, --cra buildings
	ebay = nil, 
	etrn = nil, 
	etec = nil, 
	ehqr = nil, 
	esld = nil, 
	egun = {}, 
	epwr = {},
	emintime = 99999.9, --eminelayers
	eminlength = 0, 
	emingo = {}, 
	emin = {}, 
	emincool = {}, 
	eminallow = {},	
	eminlife = {}, 
	eturtime = 99999.9, --eturret
	eturlength = 0,
	etur = {}, 
	eturcool = {}, 
	eturallow = {}, 
	eturlife = {}, 
	epattime = 99999.9, --epatrols
	epatlength = 4, 
	epat = {}, 
	epatcool = {}, 
	epatallow = {},	
	fgrp = {}, 
	frcy = nil, 
	frcydeploy = 0, 
	ffac = nil, 
	farm = nil, 
	fpwr = {nil, nil, nil, nil}, 
	fcom = nil,
	fbay = nil,
	ftrn = nil,
	ftec = nil,
	fhqr = nil,
	fsld = nil, 
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
	LAST = true
}
--PATHS: fprcy, fpgrp1-4, pdropoff, fpnav[0-5), stage1-2, ppatrol1-4, epg(0-10), epmin1-2, pportal, epgrp(0-4), eptur1-16, stage1-2, pscrap(0-145), eppwr(0-12)

function InitialSetup()
	SetAutoGroupUnits(true)
	
	local odfpreload = {
		"bvrecydw05", "kvscout", "kvmbike", "kvmisl", "kvtank", "kvrckt", "kvwalk", "kvhtnk", "kvturr", "kvmine", "bvtank", "npscrx", "apdwqka", "apcamrb" 
	}
	for k,v in pairs(odfpreload) do
		PreloadODF(v)
	end
	
	x.mytank = GetHandle("mytank")
	x.frcy = GetHandle("frcy")
	for index = 1, 6 do
		x.fgrp[index] = GetHandle(("fgrp%d"):format(index))
	end
	x.ebay = GetHandle("ebay")
	x.etrn = GetHandle("etrn")
	x.etec = GetHandle("etec")
	x.ehqr = GetHandle("ehqr")
	x.esld = GetHandle("esld")
	x.eprt = GetHandle("eprt")
	for index = 1, 12 do 
		x.epwr[index] = GetHandle(("epwr%d"):format(index))
	end
	for index = 1, 24 do --11-19 portal guard
		x.egun[index] = GetHandle(("egun%d"):format(index))
	end
	Ally(5, 6)
	Ally(6, 5)
	SetTeamColor(6, 30, 30, 50)
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
	if (not IsAlive(x.farm) or x.farm == nil) and (IsOdf(h, "bvarmodw05:1") or IsOdf(h, "bbarmodw05")) then
		x.farm = h
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
	elseif IsOdf(h, "bbpgen1") then
		for indexadd = 1, 4 do
			if x.fpwr[indexadd] == nil or not IsAlive(x.fpwr[indexadd]) then
				x.fpwr[indexadd] = h
				break
			end
		end
	end
	
	--no ercy, and loose enemy pilots are annoying
	if (GetRace(h) == "k") then
		SetEjectRatio(h, 0);
	end
	
	--get aperture dummy00
	if not x.gotdummy and IsOdf(h, "dummy00") then
		x.dummy = h
		x.dummypos = GetTransform(h)
		x.gotdummy = true
	end
	
	--get ramp dummyprtl
	if not x.gotdummy2 and IsOdf(h, "dummyprtl") then
		x.dummy2 = h
		x.gotdummy2 = true
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

function PreDamage(curWorld, h, DamageType, pContext, value, base, armor, shield, owner, source, SelfDamage, FriendlyFireDamage)
	return TCC.PreDamage(curWorld, h, DamageType, pContext, value, base, armor, shield, owner, source, SelfDamage, FriendlyFireDamage);
end

function Update()
	x.player = GetPlayerHandle() --EVERY PASS SO IF PLAYER CHANGES VEHICLES
	x.skillsetting = IFace_GetInteger("options.play.difficulty")
	TCC.Update();
	--START THE MISSION BASICS
	if x.spine == 0 then
		x.audio1 = AudioMessage("tcdw0501.wav") --Looks like we hit right place. Build up strike and atk CRA base.
		Goto(x.frcy, "fprcy", 0)
		for index = 1, 6 do
			Goto(x.fgrp[index], ("fpgrp%d"):format(index), 0)
		end
		x.frcydeploy = 1
		SetGroup(x.fgrp[1], 0)
		SetGroup(x.fgrp[2], 0)
		SetGroup(x.fgrp[3], 5) --turret
		SetGroup(x.fgrp[4], 5) --turret
		SetGroup(x.fgrp[5], 0)
		SetGroup(x.fgrp[6], 0)
		SetGroup(x.frcy, 1)
		for index = 2, 5 do
			x.poolobject[index] = BuildObject("apcamrb", 5, "fpnav", index)
		end
		for index = 11, 24 do
			TCC.SetTeamNum(x.egun[index], 6)
		end
		for index = 9, 12 do
			TCC.SetTeamNum(x.epwr[index], 6)
		end
		x.eturlength = 16
		LookAt(x.mytank, x.frcy, 0)
		x.camstate = 1
    x.userfov = IFace_GetInteger("options.graphics.defaultfov")
    CameraReady()
    IFace_SetInteger("options.graphics.defaultfov", x.camfov)
		x.spine = x.spine + 1
	end
	
	--GIVE FIRST OBJECTIVE, SEND PATROLS
	if x.spine == 1 and IsAlive(x.frcy) and IsOdf(x.frcy, "bbrecydw05") then
		x.camstate = 0
    CameraFinish()
    IFace_SetInteger("options.graphics.defaultfov", x.userfov)
		SetColorFade(6.0, 0.5, "BLACK")
		x.pos = GetTransform(x.mytank)
		RemoveObject(x.mytank)
		x.fgrp[7] = BuildObject("bvtank", 1, x.pos)
		SetAsUser(x.fgrp[7], 1)
		RemoveObject(x.player)
		x.player = GetPlayerHandle()
		TCC.SetTeamNum(x.player, 1)--JUST IN CASE
		StartSoundEffect("emdotcox.wav")
		ClearObjectives()
		AddObjective("tcdw0501.txt")
		AddObjective("	")
		AddObjective("tcdw0502.txt", "YELLOW")
		x.emintime = GetTime()
		x.eminlength = 2
		x.eminlife[1] = 0
		x.eminlife[2] = 0
		x.fnav[1] = BuildObject("apcamrb", 1, "fpnav", 1)
		SetObjectiveName(x.fnav[1], "BDS base")
		SetScrap(1, 40)
		x.waittime = GetTime() + 540.0
		x.spine = x.spine + 1		
	end
	
	--START UP WARCODE
	if x.spine == 2 and x.waittime < GetTime() then
		AudioMessage("tcdw0502.wav") --I don't like this LT. Where are they?
		ClearObjectives()
		AddObjective("Watch for CRA. Defend Recycler", "LAVACOLOR")
		x.esneakattack = 1
		x.eturtime = GetTime() + 60.0
		for index = 1, x.eturlength do
			x.eturcool[index] = GetTime()
			x.eturallow[index] = true
			x.eturlife[index] = 0
		end
		x.epattime = GetTime() + 60.0
		for index = 1, x.epatlength do
			x.epatcool[index] = GetTime()
			x.epatallow[index] = true
		end
		for index = 1, x.ewartotal do --init WARCODE
			x.ewardeclare = true
			x.ewarrior[index] = {} --"rows"
			x.ewarriorplan[index] = {} --"rows"
			x.ewarriortime[index] = {} --"rows"
			x.ewartrgt[index] = {} --"rows"
			for index2 = 1, 10 do --10 per wave max avail
				x.ewarrior[index][index2] = nil --"columns", init (handle in this case)
				x.ewarriorplan[index][index2] = 0
				x.ewarriortime[index][index2] = 99999.9
				x.ewartrgt[index][index2] = nil
			end
			x.ewarstate[index] = 1
			x.ewartime[1] = GetTime() + 120.0 --recy
			x.ewartime[2] = GetTime() + 150.0 --fact
			x.ewartime[3] = GetTime() + 180.0 --armo
			x.ewartime[4] = GetTime() + 210.0 --base
			x.ewarmeet[index] = 2
			x.ewartimecool[index] = 180.0
			x.ewartimeadd[index] = 0.0
			x.ewarabortset[index] = false
			x.ewarabort[index] = 99999.9
			x.ewarsize[index] = 0
			x.ewarwave[index] = 0
			x.ewarwavemax[index] = 5
			x.ewarwavereset[index] = 2
		end
		x.spine = x.spine + 1
	end

	--CRA DEAD
	if x.spine == 3 
	and not IsAlive(x.ecom) and not IsAlive(x.ebay) and not IsAlive(x.etrn) and not IsAlive(x.etec) and not IsAlive(x.ehqr) and not IsAlive(x.esld) 
	and not IsAlive(x.epwr[1]) and not IsAlive(x.epwr[2]) and not IsAlive(x.epwr[3]) and not IsAlive(x.epwr[4]) 
	and not IsAlive(x.epwr[5]) and not IsAlive(x.epwr[6]) and not IsAlive(x.epwr[7]) and not IsAlive(x.epwr[8])
	and not IsAlive(x.egun[1]) and not IsAlive(x.egun[2]) and not IsAlive(x.egun[3]) and not IsAlive(x.egun[4]) and not IsAlive(x.egun[5]) 
	and not IsAlive(x.egun[6]) and not IsAlive(x.egun[7]) and not IsAlive(x.egun[8]) and not IsAlive(x.egun[9]) and not IsAlive(x.egun[10]) then
		x.MCAcheck = true
		StartSoundEffect("emdotcox.wav")
		ClearObjectives()
		AddObjective("tcdw0501.txt", "GREEN")
		x.escapegrp[1] = BuildObject("kvscout", 6, "epgrp", 1)
		x.escapegrp[2] = BuildObject("kvmbike", 6, "epgrp", 2)
		x.escapegrp[3] = BuildObject("kvtank", 6, "epgrp", 3)
		x.escapegrp[4] = BuildObject("kvmisl", 6, "epgrp", 4)
		x.ewardeclare = false --turn off AI attacks
		x.eturtime = 99999.9
		x.epattime = 99999.9
		x.emintime = 99999.9
		x.waittime = GetTime() + 3.0
		x.spine = x.spine + 1
	end
	
	--SETUP CAMERA 2A
	if x.spine == 4 and x.waittime < GetTime() then
		ClearObjectives()
		x.audio1 = AudioMessage("tcdw0504.wav") --Reading EM pulse from portal. No telling what might be coming.
		IFace_ConsoleCmd("sky.fogrange 200 300", 1) --so can see better
		Ally(1, 5)
		Ally(1, 6)
		Ally(5, 1)
		Ally(6, 1)
		x.camstate = 2
    x.userfov = IFace_GetInteger("options.graphics.defaultfov")
    CameraReady()
    IFace_SetInteger("options.graphics.defaultfov", x.camfov)
		x.spine = x.spine + 1
	end
	
	--SETUP CAMERA 2B
	if x.spine == 5 and IsAudioMessageDone(x.audio1) then
		x.audio1 = AudioMessage("tcdw0505.wav") --Wait a minute. Nothing coming through. They're retreating.
		x.escapestate = 1
		x.spine = x.spine + 1
	end
	
	--SUCCEED MISSION
	if x.spine == 6 and x.victory then
    CameraFinish()
    IFace_SetInteger("options.graphics.defaultfov", x.userfov)
		TCC.SucceedMission(GetTime(), "tcdw05w.des") --WINNER WINNER WINNER
		x.spine = 666
	end
	----------END MAIN SPINE ----------
	
	--SPOT OUT THE BIO-METAL POOLS for this one
	if x.poolall < 4 then
		for index = 2, 5 do
			if not x.poolmark[index] then
				x.pooltank = GetNearestEnemy(x.poolobject[index], 0, 0, 450.0) --values less than 450 max, don't work
				if IsAlive(x.pooltank) and GetDistance(x.pooltank, x.poolobject[index]) < 350 then
					--StartSoundEffect("pow_done.wav") --decent short
					StartSoundEffect("emspintrim.wav") --world zoom 6s plus long silence keep as 
					RemoveObject(x.poolobject[index])
					x.fnav[index] = BuildObject("apcamrb", 1, "fpnav", index) --ibnav not camera
					SetObjectiveName(x.fnav[index], "Bio-metal pool")
					SetObjectiveOn(x.fnav[index])
					x.poolmark[index] = true
					x.poolall = x.poolall + 1
				end
				x.pooltank = nil
			end
		end
	end
	
	--DEPLOY RECYCLER, SPAWN SCRAP AND TURRETS
	if x.frcydeploy < 4 then
		if x.frcydeploy == 1 then
			Goto(x.frcy, "fprcy", 0)
			x.frcydeploy = 2
		elseif x.frcydeploy == 2 then
			for index = 1, 145 do
				x.escapegrp[1] = BuildObject("npscrx", 0, "pscrap", index)
			end
			x.frcydeploy = 3
		elseif x.frcydeploy == 3 and GetDistance(x.frcy, "pdropoff") < 40 then
			Dropoff(x.frcy, "pdropoff")
			x.frcydeploy = 4
		end
	end
	
	--CAMERA 1 WATCH FRCY
	if x.camstate == 1 then
		CameraObject(x.mytank, 0, 10, -30, x.frcy)
	end
	
	--CAMERA 2 PORTAL
	if x.camstate == 2 then
		CameraObject(x.dummy, 0, 40, 250, x.dummy)
	end
	
	--CRA SNEAK ATTACK OVERALL
	if x.esneakattack == 1 then
		x.esneak[1] = BuildObject("kvscout", 5, x.dummypos)
		x.esneak[2] = BuildObject("kvmbike", 5, x.dummypos)
		x.esneak[3] = BuildObject("kvmisl", 5, x.dummypos)
		x.esneak[4] = BuildObject("kvtank", 5, x.dummypos)
		x.esneak[5] = BuildObject("kvrckt", 5, x.dummypos)
		x.esneak[6] = BuildObject("kvscout", 5, x.dummypos)
		x.esneak[7] = BuildObject("kvmbike", 5, x.dummypos)
		x.esneak[8] = BuildObject("kvmisl", 5, x.dummypos)
		--x.esneak[9] = BuildObject("kvtank", 5, x.dummypos)
		--x.esneak[10] = BuildObject("kvrckt", 5, x.dummypos)
		x.esneaklength = 8 --AGAIN SINCE I KEEP CHANGING IT
		for index = 1, x.esneaklength do
			SetVelocity(x.esneak[index], SetVector(0.0, 0.0, 50.0))
			SetSkill(x.esneak[index], x.skillsetting)
			SetCommand(x.esneak[index], 47)
		end
		x.esneakattack = x.esneakattack + 1
	elseif x.esneakattack == 2 then
		for index = 1, x.esneaklength do
			Retreat(x.esneak[index], x.frcy)
		end
		x.esneakattack = x.esneakattack + 1
	elseif x.esneakattack == 3 then
		for index = 1, x.esneaklength do
			if IsAlive(x.esneak[index]) and GetDistance(x.esneak[index], x.frcy) < 100 then
				x.esneakattack = x.esneakattack + 1
				break
			end
		end
	elseif x.esneakattack == 4 then
		for index = 1, x.esneaklength do
			SetCommand(x.esneak[index], 48)
			if not x.esneakwarn then
				AudioMessage("tcdw0503.wav") --Oohoo pay dirt. Time for some action.
				x.esneakwarn = true
				x.esneakattack = x.esneakattack + 1
			end
		end
	elseif x.esneakattack == 5 then
		for index = 1, x.esneaklength do
			Attack(x.esneak[index], x.frcy)
		end
		x.esneakattack = x.esneakattack + 1
	elseif x.esneakattack == 6 then
		for index = 1, x.esneaklength do
			if not IsAlive(x.esneak[index]) then
				x.casualty = x.casualty + 1
			end
		end
		if x.casualty == x.esneaklength then
			ClearObjectives()
			AddObjective("tcdw0501.txt")
			AddObjective("	")
			AddObjective("tcdw0502.txt", "YELLOW")
			x.esneakattack = x.esneakattack + 1
		end
		x.casualty = 0
	end
	
	--CRA ESCAPE AND PORTAL BOOM
	if x.escapestate == 1 then
		--JIC, MOVE PLAYER AWAY FROM COMING EXPLOSION
		x.mytank = BuildObject("bvtank", 1, "pmytank")
		SetAsUser(x.mytank, 1)
		RemoveObject(x.player)
		x.player = GetPlayerHandle()
		Retreat(x.escapegrp[1], "pportal", 1) --1 MIGHT BE PATH POINT ?
		x.escapetime = GetTime() + 1.0
		x.escapestate = x.escapestate + 1
	elseif x.escapestate == 2 and x.escapetime < GetTime() then
		Retreat(x.escapegrp[2], "pportal")
		x.escapetime = GetTime() + 1.0
		x.escapestate = x.escapestate + 1
	elseif x.escapestate == 3 and x.escapetime < GetTime() then
		Retreat(x.escapegrp[3], "pportal")
		x.escapetime = GetTime() + 1.0
		x.escapestate = x.escapestate + 1
	elseif x.escapestate == 4 and x.escapetime < GetTime() then
		Retreat(x.escapegrp[4], "pportal")
		x.escapetime = GetTime() + 1.0
		x.escapestate = x.escapestate + 1
	elseif x.escapestate == 5 then
		for index = 1, 4 do 
			if IsAlive(x.escapegrp[index]) and GetDistance(x.escapegrp[index], x.dummy2) < 20 then
				AudioMessage("portalx.wav")
				RemoveObject(x.escapegrp[index])
			end
		end
		if not IsAlive(x.escapegrp[1]) and not IsAlive(x.escapegrp[2]) and not IsAlive(x.escapegrp[3]) and not IsAlive(x.escapegrp[4]) then
			x.audio1 = AudioMessage("tcdw0506.wav") --SUCCEED - Congrats. We follow once control the Pegasus.
			x.escapestate = x.escapestate + 1
		end
	elseif x.escapestate == 6 and IsAudioMessageDone(x.audio1) then
		x.escapetime = GetTime() + 2.0
		x.escapestate = x.escapestate + 1
	elseif x.escapestate == 7 and x.escapetime < GetTime() then
		x.audio1 = AudioMessage("svfighvj.wav") --filfthy amers
		x.escapestate = x.escapestate + 1
	elseif x.escapestate == 8 and IsAudioMessageDone(x.audio1) then
		AudioMessage("portalx.wav")
		x.fgrp[1] = BuildObject("apdwqka", 0, x.dummy)
		SetVelocity(x.fgrp[1], (SetVector(0.0, 0.0, 20.0)))
		x.escapetime = GetTime() + 2.0
		x.escapestate = x.escapestate + 1
	elseif x.escapestate == 9 and x.escapetime < GetTime() then
		StopEmitter(x.eprt, 5) --"shutdown" portal
		x.escapetime = GetTime() + 2.0
		x.escapestate = x.escapestate + 1
	elseif x.escapestate == 10 and x.escapetime < GetTime() then
		Damage(x.eprt, 60000)
		x.escapetime = GetTime() + 8.0
		x.escapestate = x.escapestate + 1
	elseif x.escapestate == 11 and x.escapetime < GetTime() then
		x.victory = true
		x.escapestate = x.escapestate + 1
	end
	
	--CRA GROUP TURRET PORTAL SPAWNED
	if x.eturtime < GetTime() then
		for index = 1, x.eturlength do
			if not IsAlive(x.etur[index]) and not x.eturallow[index] and x.eturlife[index] < 3 then
				x.eturcool[index] = GetTime() + 180.0
				x.eturallow[index] = true
			end
			if x.eturallow[index] and x.eturcool[index] < GetTime() then
				x.etur[index] = BuildObject("kvturr", 5, x.dummypos)
				SetVelocity(x.etur[index], SetVector(0.0, 0.0, 50.0))
				SetSkill(x.etur[index], x.skillsetting)
				--SetObjectiveName(x.etur[index], ("Adder %d"):format(index))
				Goto(x.etur[index], ("eptur%d"):format(index)) --path pt doesn't work
				x.eturallow[index] = false
				x.eturlife[index] = x.eturlife[index] + 1
			end
		end
		x.eturtime = GetTime() + 30.0
	end

	--CRA GROUP SCOUT PATROLS
	if x.epattime < GetTime() then
		for index = 1, x.epatlength do
			if not IsAlive(x.epat[index]) and not x.epatallow[index] then
				x.epatcool[index] = GetTime() + 120.0
				x.epatallow[index] = true
			end
			
			if x.epatallow[index] and x.epatcool[index] < GetTime() then
				while x.randompick == x.randomlast do --random the random
					x.randompick = math.floor(GetRandomFloat(1.0, 15.0))
				end
				x.randomlast = x.randompick
				if x.randompick == 1 or x.randompick == 6 or x.randompick == 11 then
					x.epat[index] = BuildObject("kvscout", 5, x.dummypos)
				elseif x.randompick == 2 or x.randompick == 7 or x.randompick == 12 then
					x.epat[index] = BuildObject("kvmbike", 5, x.dummypos)
				elseif x.randompick == 3 or x.randompick == 8 or x.randompick == 13 then
					x.epat[index] = BuildObject("kvmisl", 5, x.dummypos)
				elseif x.randompick == 4 or x.randompick == 9 or x.randompick == 14 or x.randompick == 15 then
					x.epat[index] = BuildObject("kvtank", 5, x.dummypos)
				else --5, 10
					x.epat[index] = BuildObject("kvrckt", 5, x.dummypos)
				end
				SetVelocity(x.epat[index], SetVector(0.0, 0.0, 50.0))
				SetSkill(x.epat[index], x.skillsetting)
				Patrol(x.epat[index], ("ppatrol%d"):format(index))
				--SetObjectiveName(x.epat[index], ("Patrol %d"):format(index))
				x.epatallow[index] = false
			end
		end
		x.epattime = GetTime() + 30.0
	end
	
	--WARCODE special CLOAKING & PORTAL SPAWNED
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
						x.ewarsize[index] = 3
					elseif x.ewarwave[index] == 3 then
						x.ewarsize[index] = 4
					elseif x.ewarwave[index] == 4 then
						x.ewarsize[index] = 6
					else --x.ewarwave[index] == 5 then
						x.ewarsize[index] = 8
					end
					x.ewarstate[index] = x.ewarstate[index] + 1
				--BUILD FORCE
				elseif x.ewarstate[index] == 2 then
					for index2 = 1, x.ewarsize[index] do
						while x.randompick == x.randomlast do --random the random
							x.randompick = math.floor(GetRandomFloat(1.0, 18.0))
						end
						x.randomlast = x.randompick
						if x.randompick == 1 or x.randompick == 8 or x.randompick == 15 then
							x.ewarrior[index][index2] = BuildObject("kvscout", 5, x.dummypos)
							if x.ewarwave[index] == 3 or x.ewarwave[index] == 4 then
								GiveWeapon(x.ewarrior[index][index2], "glasea_c")
							end
						elseif x.randompick == 2 or x.randompick == 9 or x.randompick == 16 then
							x.ewarrior[index][index2] = BuildObject("kvmbike", 5, x.dummypos)
							if x.ewarwave[index] == 2 or x.ewarwave[index] == 4 then
								GiveWeapon(x.ewarrior[index][index2], "gstbva_c")
							end
						elseif x.randompick == 3 or x.randompick == 10 or x.randompick == 17 then
							x.ewarrior[index][index2] = BuildObject("kvmisl", 5, x.dummypos)
							if x.ewarwave[index] == 3 or x.ewarwave[index] == 5 then
								GiveWeapon(x.ewarrior[index][index2], "gfafma_c")
							end
						elseif x.randompick == 4 or x.randompick == 11 or x.randompick == 18 then
							x.ewarrior[index][index2] = BuildObject("kvtank", 5, x.dummypos)
						elseif x.randompick == 5 or x.randompick == 12 then
							x.ewarrior[index][index2] = BuildObject("kvrckt", 5, x.dummypos)
							if x.ewarwave[index] == 3 or x.ewarwave[index] == 5 then
								GiveWeapon(x.ewarrior[index][index2], "gshdwa_a") --salvo rckt
							end
						elseif x.randompick == 6 or x.randompick == 13 then
							x.ewarrior[index][index2] = BuildObject("kvhtnk", 5, x.dummypos)
						else --7, 14
							if x.ewarwave[index] == 1 then --tank 1st, walk rest
								x.ewarrior[index][index2] = BuildObject("kvtank", 5, x.dummypos)
							else
								x.ewarrior[index][index2] = BuildObject("kvwalk", 5, x.dummypos)
							end
						end
						SetVelocity(x.ewarrior[index][index2], SetVector(0.0, 0.0, 50.0))
						SetSkill(x.ewarrior[index][index2], x.skillsetting)
						if index2 % 3 == 0 then
							SetSkill(x.ewarrior[index][index2], x.skillsetting+1)
						end
						SetCommand(x.ewarrior[index][index2], 47)
						--x.ewartrgt[index][index2] = nil
					end
					x.ewarabort[index] = GetTime() + 360.0 --here first in case stage goes wrong
					x.ewarstate[index] = x.ewarstate[index] + 1
				--GIVE MARCHING ORDERS
				elseif x.ewarstate[index] == 3 then
					if x.ewarmeet[index] == 1 then
						x.ewarmeet[index] = 2
					else
						x.ewarmeet[index] = 1
					end
					for index2 = 1, x.ewarsize[index] do
						if IsAlive(x.ewarrior[index][index2]) then
							Retreat(x.ewarrior[index][index2], ("stage%d"):format(x.ewarmeet[index]))
							if IsOdf(x.ewarrior[index][index2], "kvwalk") then --need to defend self since no cloak, oddly only TRO mission where this is necessary
								Goto(x.ewarrior[index][index2], ("stage%d"):format(x.ewarmeet[index]))
							end
						end
					end
					x.ewarstate[index] = x.ewarstate[index] + 1
				--A UNIT AT STAGE PT
				elseif x.ewarstate[index] == 4 then
					for index2 = 1, x.ewarsize[index] do
						if IsAlive(x.ewarrior[index][index2]) and GetDistance(x.ewarrior[index][index2], ("stage%d"):format(x.ewarmeet[index])) < 50 then
							x.ewarstate[index] = x.ewarstate[index] + 1
							break
						end
					end
				--PICK TARGET FOR EACH ATTACKER
				elseif x.ewarstate[index] == 5 then
					for index2 = 1, x.ewarsize[index] do
						if IsAlive(x.ewarrior[index][index2]) then
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
							if not x.ewarabortset[index] then
								x.ewarabort[index] = GetTime() + 420.0
								x.ewarabortset[index] = true
							end
							x.ewarriortime[index][index2] = GetTime() + 1.0
							x.ewarriorplan[index][index2] = 1
						end
					end
					x.ewarstate[index] = x.ewarstate[index] + 1
				--ATTACK PROCESSES
				elseif x.ewarstate[index] == 6 then	
					for index2 = 1, x.ewarsize[index] do
						--GIVE ATTACK (MULTIPLE "ATTACK" USED SO IF 1ST TARGET IS KILLED, WILL ATTACK NEXT TARGET)
						if x.ewarriorplan[index][index2] == 1 and IsAlive(x.ewarrior[index][index2]) and IsAlive(x.ewartrgt[index][index2]) and x.ewarriortime[index][index2] < GetTime() then
							Retreat(x.ewarrior[index][index2], x.ewartrgt[index][index2])
              if IsOdf(x.ewarrior[index][index2], "kvwalk") then --no retreat if walker
								Attack(x.ewarrior[index][index2], x.ewartrgt[index][index2])
							end
							x.ewarriorplan[index][index2] = x.ewarriorplan[index][index2] + 1
						end
						--CHECK TARGET STATUS, LOCATION, AND DECLOAK
						if x.ewarriorplan[index][index2] == 2 and IsAlive(x.ewartrgt[index][index2]) and GetDistance(x.ewarrior[index][index2], x.ewartrgt[index][index2]) < 150 then
              Attack(x.ewarrior[index][index2], x.ewartrgt[index][index2])  --extra Attack, see if this helps
							SetCommand(x.ewarrior[index][index2], 48)
							x.ewarriortime[index][index2] = GetTime() + 1.0
							x.ewarriorplan[index][index2] = x.ewarriorplan[index][index2] + 1
						end
						--COMMIT TO ATTACK IF TARGET STILL EXISTS
						if x.ewarriorplan[index][index2] == 3 and IsAlive(x.ewarrior[index][index2]) and IsAlive(x.ewartrgt[index][index2]) and x.ewarriortime[index][index2] < GetTime() then
							Attack(x.ewarrior[index][index2], x.ewartrgt[index][index2])
							x.ewarriortime[index][index2] = GetTime() + 30.0
							x.ewarriorplan[index][index2] = x.ewarriorplan[index][index2] + 1
						end
						--FORCE STRAGGLERS TO UNCLOAK
						if x.ewarriorplan[index][index2] == 4 and IsAlive(x.ewarrior[index][index2]) and x.ewarriortime[index][index2] < GetTime() then
							SetCommand(x.ewarrior[index][index2], 48)
							x.ewarriortime[index][index2] = GetTime()
							x.ewarriorplan[index][index2] = 3 --HARD RESET TO 3
						end
						
						--CHECK IF SQUAD MEMBER DEAD
						if not IsAlive(x.ewarrior[index][index2]) then
							x.ewarriortime[index][index2] = 99999.9
							x.ewartrgt[index][index2] = nil
							x.ewarriorplan[index][index2] = 0
							x.casualty = x.casualty + 1
						end
					end
					--DO CASUALTY COUNT
					if x.casualty >= math.floor(x.ewarsize[index] * 0.7) then --reset attack group
						for index2 = 1, x.ewarsize[index] do
							if IsAlive(x.ewarrior[index][index2]) then
								SetCommand(x.ewarrior[index][index2], 48)
							end
						end
						x.ewarabort[index] = 99999.9
						x.ewartimeadd[index] = x.ewartimeadd[index] + 5.0
						x.ewartime[index] = GetTime() + x.ewartimecool[index] + x.ewartimeadd[index]
						if x.ewarwave[index] == 5 then --extra 120s after max wave to "ease up"
							x.ewartime[index] = GetTime() + x.ewartimecool[index] + x.ewartimeadd[index] + 120.0
						end
						x.ewarstate[index] = 1 --RESET
						x.ewarabortset[index] = false
					end
					x.casualty = 0
				end
				
				for index2 = 1, x.ewarsize[index] do --DIFFERENT B/C EACH UNIT HAS UNIQUE TARGET CALL
					if not IsAlive(x.ewartrgt[index][index2]) then --if orig target gone, then find new one
						if IsAlive(x.frcy) then
							x.ewartrgt[index][index2] = x.frcy
						elseif IsAlive(x.ffac) then
							x.ewartrgt[index][index2] = x.ffac
						elseif IsAlive(x.farm) then
							x.ewartrgt[index][index2] = x.farm
						else
							x.ewartrgt[index][index2] = x.player
						end
						if IsAlive(x.ewarrior[index][index2]) then
							Attack(x.ewarrior[index][index2], x.ewartrgt[index][index2])
						end
					end
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

	--CRA MINELAYER SQUAD PORTAL SPAWNED
	if x.emintime < GetTime() then
		for index = 1, x.eminlength do
			if (not IsAlive(x.emin[index]) or (IsAlive(x.emin[index]) and GetTeamNum(x.emin[index]) == 1)) and not x.eminallow[index] and x.eminlife[index] < 3 then
				x.emincool[index] = GetTime() + 300.0
				x.eminallow[index] = true
			end
			
			if x.eminallow[index] and x.emincool[index] < GetTime() then
				x.emin[index] = BuildObject("kvmine", 5, x.dummypos)
				SetVelocity(x.emin[index], SetVector(0.0, 0.0, 50.0))
				SetSkill(x.emin[index], x.skillsetting)
				--SetObjectiveName(x.emin[index], ("Molotov %d"):format(index))
				Goto(x.emin[index], ("epmin%d"):format(index)) --resend orders
				x.emingo[index] = true
				x.eminallow[index] = false
				x.eminlife[index] = x.eminlife[index] + 1
			end
			
			if IsAlive(x.emin[index]) and GetCurAmmo(x.emin[index]) <= math.floor(GetMaxAmmo(x.emin[index]) * 0.25) and GetTeamNum(x.emin[index]) ~= 1 then
				SetCurAmmo(x.emin[index], GetMaxAmmo(x.emin[index]))
				Goto(x.emin[index], ("epmin%d"):format(index)) --resend orders
				x.emingo[index] = true
			end
			
			if x.emingo[index] and GetDistance(x.emin[index], ("epmin%d"):format(index)) < 30 and GetTeamNum(x.emin[index]) ~= 1 then
				Mine(x.emin[index], ("epmin%d"):format(index), 0, 1)
				x.emingo[index] = false
			end
		end
		--x.emintime = GetTime() + 120.0 --recheck whole every 2 min
	end

	--CHECK STATUS OF MCA 
	if not x.MCAcheck then
		if not IsAlive(x.frcy) then --production lost
			AudioMessage("tcdw0507.wav") --FAIL - Mission was crucial (why lost?)
			ClearObjectives()
			AddObjective("Recycler destroyed.\n\nMISSION FAILED!", "RED")
			TCC.FailMission(GetTime() + 7.0, "tcdw05f1.des") --LOSER LOSER LOSER
			x.MCAcheck = true
		end
		
		if not IsAlive(x.eprt) then --portal killed early
			AudioMessage("tcdw0507.wav") --FAIL - Mission was crucial (why lost?)
			ClearObjectives()
			AddObjective("tcdw0502.txt", "RED")
			AddObjective("\n\nMISSION FAILED!", "RED")
			TCC.FailMission(GetTime() + 7.0, "tcdw05f2.des") --LOSER LOSER LOSER
			x.MCAcheck = true
		end
	end
end
--[[END OF SCRIPT]]