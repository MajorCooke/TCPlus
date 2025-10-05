--bztcdw06 - Battlezone Total Command - Dogs of War - 6/15 - BLITZKRIEG
assert(load(assert(LoadFile("_requirefix.lua")),"_requirefix.lua"))();
TCC = require("TC_Core")
MisnNum = 37;
local index = 0
local index2 = 0
local index3 = 0
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
	camfov = 60,  --185 default
	userfov = 90,  --seed
	randompick = 0, 
	randomlast = 0,
	dummy = nil, --portal dummies
	dummypos = {}, 
	gotdummy = false, 
	dummy2 = nil, 
	gotdummy2 = false,	
	camstate = 0, 
	camdistance = 600, 
	safespace = 0, 
	killem = false, 
	timesup = 99999.9, 
	diversionstate = 0, 
	spawn = {}, --spawn object transform
	ptnorth = nil, --obj for spawn
	ptsouth = nil, --obj for spawn
	devildead = 0, 
	servdead = 0, 
	basedead = false, 
	frcywave = false, 
	waveout = false, 
	multiplier = 1, 
	easntime = 99999.9, 
	easnstate = 0, 
	eatk = {}, 
	ediv = {}, 
	edivlength = 0, 
	eprt = nil, 
	epwr = {}, 
	ecom = nil, 
	egun = {}, 
	etrn = nil, 
	fext1 = nil, 
	fext2 = nil, 
	fapc = nil, 
	fapcstate = 0, 
	fgrp = {}, 
	fgrpgun = {}, 
	frec = nil, 
	frcy = nil, 
	frcystate = 0, 
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
	ewarriortime = {},
	ewartrgt = {},
	LAST = true
}
--PATHS: fprcy, fpgrp(0-17), pscrap(0-130), ptnorth, ptsouth, epatk(0-6), epdiv(0-12), pcam1-2, ebase

function InitialSetup()
	SetAutoGroupUnits(true)
	
	local odfpreload = {
		"kvscout", "kvmbike", "kvmisl", "kvtank", "kvrckt", "kvhtnk", "kvturr", "bvstnk", "bvserv", "bvrecy0", "npscrx", "apcamrb" 
	}
	for k,v in pairs(odfpreload) do
		PreloadODF(v)
	end
	
	x.mytank = GetHandle("mytank")
	--B/C OF 2.185, USE PREPLACED DUMMIES TO OPEN CELLS TO BUILD PLAYER BASE LATER
	x.ecom = GetHandle("ecom")
	x.etrn = GetHandle("etrn")
	x.eprt = GetHandle("eprt")
	for index = 1, 3 do 
		x.epwr[index] = GetHandle(("epwr%d"):format(index))
	end
	for index = 1, 5 do
		x.egun[index] = GetHandle(("egun%d"):format(index))
	end
	Ally(5, 6)
	Ally(6, 5)
	SetTeamColor(6, 30, 70, 30)  
	SetColorFade(6.0, 0.5, "BLACK")
	TCC.Init();
end

function Start()
	TCC.Start();
end
function Save()
	return
	index, index2, index3, indexadd, x, TCC.Save()
end

function Load(a, b, c, d, e, coreData)
	index = a;
	index2 = b;
	index3 = c;
	indexadd = d;
	x = e;
	TCC.Load(coreData)
end

function AddObject(h)
	--get player base buildings for later attack
	if (not IsAlive(x.farm) or x.farm == nil) and (IsOdf(h, "bvarmo:1") or IsOdf(h, "bbarmo")) then
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
	elseif IsOdf(h, "bbpgen0") then
		for indexadd = 1, 4 do
			if x.fpwr[indexadd] == nil or not IsAlive(x.fpwr[indexadd]) then
				x.fpwr[indexadd] = h
				break
			end
		end
	end
	
	--give factory-built red devils super stabbers
	if IsOdf(h, "bvstnk:1") then
		for index = 1, 11 do
			if (not IsAlive(x.fgrpgun[index]) or x.fgrpgun[index] == nil) then
				x.fgrpgun[index] = h
				GiveWeapon(x.fgrpgun[index], "gstbsa_c", 1)
			end
		end
	end
	
	--no ercy, and loose enemy pilots are annoying
	if (GetRace(h) == "k") then
		SetEjectRatio(h, 0);
	end
	
	--get apc for portal
	if IsOdf(h, "bvapc:1") and (not IsAlive(x.fapc) or x.facp == nil) and x.fapcstate < 1 then
		x.fapc = h
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
	
	--Get first 2 simultaneously alive deployed scavengers
	if IsOdf(h, "bbscav") and (not IsAlive(x.fext1) or x.fext1 == nil) and h ~= x.fext2 then
		x.fext1 = h
	elseif IsOdf(h, "bbscav") and (not IsAlive(x.fext2) or x.fext2 == nil) and h ~= x.fext1 then
		x.fext2 = h
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
		-- [MC] Make the portal neutral so idiots dont attack it, and make it indestructible.
		TCC.SetTeamNum(x.eprt, 0); 
		SetMaxHealth(x.eprt, 0);
		SetCurHealth(x.eprt, 0);
		x.audio1 = AudioMessage("tcdw0601.wav") --Must control portal. Wait for diversion then assault.
		SetAsUser(x.mytank, 1)
		RemoveObject(x.player)
		x.player = GetPlayerHandle()
		TCC.SetTeamNum(x.player, 1)--JUST IN CASE
		for index = 1, 3 do
			x.pos = GetTransform(x.epwr[index])
			RemoveObject(x.epwr[index])
			x.epwr[index] = BuildObject("kbpgen0", 5, x.pos)
		end
		for index = 3, 5 do --1, 2 preplaced portal flash towers
			x.pos = GetTransform(x.egun[index])
			RemoveObject(x.egun[index])
			x.egun[index] = BuildObject("kbgtow", 5, x.pos)
		end
		x.pos = GetTransform(x.ecom)
		RemoveObject(x.ecom)
		x.ecom = BuildObject("kbcbun", 5, x.pos)
		x.pos = GetTransform(x.etrn)
		RemoveObject(x.etrn)
		x.etrn = BuildObject("kbtrain", 5, x.pos)
		for index = 1, 10 do 
			x.fgrp[index] = BuildObject("bvstnk", 1, "fpgrp", index)
			LookAt(x.fgrp[index], x.ecom, 0)
			if index % 2 == 0 then
				SetGroup(x.fgrp[index], 1)
			else
				SetGroup(x.fgrp[index], 0)
			end
			SetSkill(x.fgrp[index], x.skillsetting)
			GiveWeapon(x.fgrp[index], "gstbsa_c")
		end
		x.fgrp[11] = x.mytank
		GiveWeapon(x.fgrp[11], "gstbsa_c")
		for index = 12, 17 do 
			x.fgrp[index] = BuildObject("bvserv", 1, "fpgrp", index)
			LookAt(x.fgrp[index], x.ecom, 0)
			SetGroup(x.fgrp[index], 4)
		end
		x.eatk[1] = BuildObject("kvscout", 5, "epatk", 1)
		x.eatk[2] = BuildObject("kvtank", 5, "epatk", 2) 
		x.eatk[3] = BuildObject("kvscout", 5, "epatk", 3)
		x.eatk[4] = BuildObject("kvtank", 5, "epatk", 4) 
		x.eatk[5] = BuildObject("kvscout", 5, "epatk", 5)
		--x.eatk[6] = BuildObject("kvtank", 5, "epatk", 6) 
		for index = 1, 5 do --6 do
			LookAt(x.eatk[index], x.ecom, 0)
			SetSkill(x.eatk[index], x.skillsetting)
		end
		x.fnav[1] = BuildObject("apcamrb", 0, "fprcy")
		x.edivlength = 12
		for index = 1, x.edivlength do
			x.ediv[index] = BuildObject("kvtank", 5, "epdiv", index)
			SetSkill(x.eatk[index], x.skillsetting)
			LookAt(x.ediv[index], x.fnav[1])
		end 
		x.camstate = 1
    x.userfov = IFace_GetInteger("options.graphics.defaultfov")
    CameraReady()
    IFace_SetInteger("options.graphics.defaultfov", x.camfov)
		x.spine = x.spine + 1
	end
	
	--GIVE FIRST OBJECTIVE
	if x.spine == 1 and x.camstate == 0 then --(x.camstate == 0 or CameraCancelled()) then
		x.camstate = 0 --because
    CameraFinish()
    IFace_SetInteger("options.graphics.defaultfov", x.userfov)
		SetColorFade(6.0, 0.5, "BLACK")
		StartSoundEffect("emdotcox.wav")
		AddObjective("tcdw0601.txt")
		AddObjective("	")
		AddObjective("tcdw0604.txt", "CYAN")
		for index = 12, 17 do --set serv to follow a wingman
			Follow(x.fgrp[index], x.fgrp[index-11], 0)
		end
		x.waittime = GetTime() + 20.0
		for index = 1, 6 do 
			Defend(x.eatk[index], 0)
		end
		RemoveObject(x.fnav[1]) --ediv lookat
		x.spine = x.spine + 1
	end
	
	--NOTIFY DIVERSION INCOMING
	if x.spine == 2 and x.waittime < GetTime() then
		x.ptnorth = BuildObject("dummy00", 0, "ptnorth")
		x.ptsouth = BuildObject("dummy00", 0, "ptsouth")
		if x.safespace == 0 then
			x.audio1 = AudioMessage("tcdw0602.wav") --Delta 3 is go. I say again
		end
		x.spine = x.spine + 1
	end
	
	--START DIVERSION CAMERA
	if x.spine == 3 then
		if x.diversionstate == 3 and x.safespace == 1 then
			x.spine = x.spine + 1
		elseif x.diversionstate == 0 and IsAudioMessageDone(x.audio1) then
			x.diversionstate = 1
			x.camstate = 3
      x.userfov = IFace_GetInteger("options.graphics.defaultfov")
      CameraReady()
      IFace_SetInteger("options.graphics.defaultfov", x.camfov)
			x.waittime = GetTime() + 17.0
			x.spine = x.spine + 1
		end
	end
	
	--CLEAR TO ATTACK
	if x.spine == 4 and (x.safespace == 1 or x.camstate == 33) then
		if x.camstate == 33 then
			x.camstate = 0
      CameraFinish()
      IFace_SetInteger("options.graphics.defaultfov", x.userfov)
			x.safespace = 1
		end
		StartSoundEffect("emdotcox.wav")
		ClearObjectives()
		AddObjective("tcdw0602.txt")
		AddObjective("	")
		AddObjective("tcdw0603.txt", "YELLOW")
		AddObjective("\n\n3 minutes to destroy base.", "YELLOW")
		StartCockpitTimer(180, 180, 90)
		x.timesup = GetTime() + 180.0
		x.spine = x.spine + 1
	end
	
	--CRA BASE DEAD, PAUSE
	if x.spine == 5 and not IsAlive(x.ecom) and not IsAlive(x.etrn) and not IsAlive(x.esld) 
	and not IsAlive(x.epwr[1]) and not IsAlive(x.epwr[2]) and not IsAlive(x.epwr[3]) and not IsAlive(x.epwr[4]) 
	and not IsAlive(x.egun[1]) and not IsAlive(x.egun[2]) and not IsAlive(x.egun[3]) 
	and not IsAlive(x.egun[4]) and not IsAlive(x.egun[5]) and not IsAlive(x.egun[6]) then
		StartSoundEffect("emdotcox.wav")
		ClearObjectives()
		AddObjective("tcdw0601.txt", "GREEN")
		AddObjective("	")
		AddObjective("tcdw0605.txt")
		x.timesup = 99999.9
		StopCockpitTimer()
		HideCockpitTimer()
		x.waittime = GetTime() + 40.0
		x.basedead = true
		x.spine = x.spine + 1
	end
	
	--START UP WARCODE
	if x.spine == 6 and x.waittime < GetTime() then
		for index = 1, x.ewartotal do --init WARCODE
			x.ewardeclare = true
			x.ewarrior[index] = {} --"rows"
			x.ewarriortime[index] = {} --"rows"
			x.ewartrgt[index] = {} --"rows"
			for index2 = 1, 10 do --10 per wave max avail
				x.ewarrior[index][index2] = nil --"columns", init (handle in this case)
				x.ewarriortime[index][index2] = 99999.9
				x.ewartrgt[index][index2] = nil
			end
			x.ewarstate[index] = 1
			x.ewartime[1] = GetTime() + 10.0 --recy
			x.ewartime[2] = GetTime() + 60.0 --fact
			x.ewartime[3] = GetTime() + 120.0 --armo
			x.ewartime[4] = GetTime() + 3600.0 --base
			x.ewartimecool[index] = 120.0
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
	
	--SEND RECYCLER THROUGH PLAYER DEPLOYMENT
	if x.spine == 7 then
		if x.frcystate == 1 then
			x.frec = BuildObject("bvrecy0", 1, "fprcy")
			Goto(x.frec, "ebase") --hold player control
			x.fgrp[1] = BuildObject("bvscout", 1, "fprcy")
			x.fgrp[2] = BuildObject("bvmbike", 1, "fprcy")
			x.fgrp[3] = BuildObject("bvmisl", 1, "fprcy")
			x.fgrp[4] = BuildObject("bvtank", 1, "fprcy")
			x.fgrp[5] = BuildObject("bvrckt", 1, "fprcy")
			x.fgrp[6] = BuildObject("bvstnk", 1, "fprcy")
			for index = 1, 6 do
				Defend2(x.fgrp[index], x.frec)
			end
			x.frcystate = x.frcystate + 1
		elseif x.frcystate == 2 and IsAlive(x.frec) and GetDistance(x.frec, "ebase") < 800 then
			AudioMessage("tcdw0603.wav") --Dispatching Recy to help. Should arrive shortly.
			x.frcystate = x.frcystate + 1
		elseif x.frcystate == 3 and IsAlive(x.frec) and GetDistance(x.frec, "ebase") < 600 then
			SetObjectiveOn(x.frec)
			Goto(x.frec, "ebase", 0) --give player control
			SetGroup(x.frec, 5)
			for index = 1, 6 do
				Defend2(x.fgrp[index], x.frec, 0)
				SetGroup(x.fgrp[index], 6)
			end
			for index = 1, 130 do
				x.fnav[1] = BuildObject("npscrx", 0, "pscrap", index)
			end
			StartSoundEffect("emdotcox.wav")
			ClearObjectives()
			AddObjective("tcdw0605.txt", "GREEN")
			AddObjective("	")
			AddObjective("Deploy Recycler and build a base.")
			x.frcystate = x.frcystate + 1
		elseif x.frcystate == 4 and IsAlive(x.frec) and IsOdf(x.frec, "bbrecy0") then
			SetScrap(1, 40)
			SetObjectiveOff(x.frec)
			x.frcy = x.frec
			x.waittime = GetTime() + 210.0
			x.frcystate = x.frcystate + 1
			x.spine = x.spine + 1
		end
	end
	
	--ACTIVATE MULTIPLIER
	if x.spine == 8 and x.waittime < GetTime() then
		x.multiplier = 2
		x.spine = x.spine + 1
	end
	
	--PLAYER HAS 2 SIMUL EXTRACTORS --this could allow player to build huge force with one ext, but also no point in apc order without having two extractors
	if x.spine == 9 and IsAlive(x.fext1) and IsAlive(x.fext2) then
		x.waittime = GetTime() + 30.0
		x.spine = x.spine + 1
	end
	
	--GIVE APC ORDER
	if x.spine == 10 and x.waittime < GetTime() then
		AudioMessage("tcdw0604.wav") --More orders. Build APC. Get portal reprogrammed.
		ClearObjectives()
		AddObjective("Deploy Recycler and build a base.", "GREEN")
		AddObjective("	")
		AddObjective("tcdw0606.txt")
		x.spine = x.spine + 1
	end
	
	--APC STUFF
	if x.spine == 11 then
		if IsAlive(x.fapc) and x.fapcstate == 0 then
			SetObjectiveName(x.fapc, "Electronic Warfare Team")
			SetObjectiveOn(x.fapc)
			StartSoundEffect("emdotcox.wav")
			ClearObjectives()
			AddObjective("tcdw0606.txt", "GREEN")
			AddObjective("	")
			AddObjective("tcdw0607.txt")
			SetObjectiveName(x.dummy2, "Portal Entrance")
			SetObjectiveOn(x.dummy2)
			x.easnstate = 1
			x.easntime = GetTime()
			x.fapcstate = x.fapcstate + 1
		end
		
		if x.fapcstate == 1 and IsAlive(x.fapc) and GetDistance(x.fapc, x.dummy2) < 80 then
			SetCurHealth(x.fapc, 30000)
			Goto(x.fapc, x.dummy2, 1) --take away control
			SetObjectiveOff(x.fapc)
			SetObjectiveOff(x.dummy2)
			x.camstate = 4
      x.userfov = IFace_GetInteger("options.graphics.defaultfov")
      CameraReady()
      IFace_SetInteger("options.graphics.defaultfov", x.camfov)
			x.fapcstate = x.fapcstate + 1
		elseif x.fapcstate == 2 and IsAlive(x.fapc) and GetDistance(x.fapc, x.dummy2) < 20 then
			AudioMessage("portalx.wav")
			RemoveObject(x.fapc)
			x.waittime = GetTime() + 3.0
			x.fapcstate = x.fapcstate + 1
		elseif x.fapcstate == 3 and x.waittime < GetTime() then
			x.camstate = 0
      CameraFinish()
      IFace_SetInteger("options.graphics.defaultfov", x.userfov)
			StartSoundEffect("emdotcox.wav")
			ClearObjectives()
			AddObjective("tcdw0607.txt", "GREEN")
			AddObjective("\n\nDefend base while the portal is reprogrammed.")
			x.waittime = GetTime() + 300.0
			x.multiplier = 3 --UP THE MULTIPLIER
			x.fapcstate = x.fapcstate + 1
			x.spine = x.spine + 1
		elseif x.fapcstate == 1 and not IsAlive(x.fapc) then
			StartSoundEffect("emdotcox.wav")
			ClearObjectives()
			AddObjective("tcdw0606.txt") --rebuild apc
			x.fapcstate = 0
		end
	end
	
	--START VICTORY TOUR
	if x.spine == 12 and x.waittime < GetTime() then
		x.audio1 = AudioMessage("tcdw0608.wav") --APC - work done now opens a mile from Chinese. snds bad, use it tho
		ClearObjectives()
		AddObjective("tcdw0608.txt", "GREEN")
		x.MCAcheck = true
		x.spine = x.spine + 1
	end
	
	--CONTINUE VICTORY TOUR
	if x.spine == 13 and IsAudioMessageDone(x.audio1) then
		x.audio1 = AudioMessage("tcdw0605.wav") --SUCCEED - Excellent work. Get back to HQ.
		x.spine = x.spine + 1
	end
	
	--SUCCEED MISSION
	if x.spine == 14 and IsAudioMessageDone(x.audio1) then
		TCC.SucceedMission(GetTime() + 0.5, "tcdw06w.des") --WINNER WINNER WINNER
		x.spine = 666
	end
	----------END MAIN SPINE ----------

	--CAMERA 1 CRA BASE INTRO
	if x.camstate == 1 and CameraPath("pcam1", 2000, 3500, x.ecom) then
		x.camstate = 2
	end
	
	--CAMERA 2 PORTAL
	if x.camstate == 2 and CameraPath("pcam2", 2000, 4500, x.eprt) then
		x.camstate = 0
	end
	
	--CAMERA 3 DIVERSION
	if x.camstate == 3 then
		CameraObject(x.dummy, 0, 10, x.camdistance, x.dummy2)
		x.camdistance = x.camdistance - 1
		if x.waittime < GetTime() then
			x.camstate = 33 --33 correct
		end
	end
	
	--CAMERA 4 APC ENTERS PEGASUS PORTAL
	if x.camstate == 4 and CameraObject(x.dummy, 0, 10, 100, x.dummy2) then
		x.camstate = 0
	end
	
	--CALM DOWN SPARKY (shouldn't run if player follows orders)
	if x.diversionstate == 0 and x.safespace == 0 then
		if IsAlive(x.player) and not IsInsideArea("safespace", x.player) then
			x.killem = true
		elseif x.safeback then
			for index = 1, 10 do
				if IsAlive(x.fgrp[index]) and not IsInsideArea("safespace", x.fgrp[index]) then
          x.killem = true
          break
				end
			end
		end
		
		if x.killem then
			Attack(x.ediv[1], x.player)
			Attack(x.ediv[2], x.player)
			for index = 3, x.edivlength do
				Attack(x.ediv[index], x.fgrp[index])
			end
			x.diversionstate = 3
			x.safespace = 1
			x.killem = false
		end
	end
	
	--DIVERSION STUFF
	if x.diversionstate == 1 then
		for index = 1, x.edivlength do
			Retreat(x.ediv[index], "fprcy")
		end
		x.diversionstate = 2
	elseif x.diversionstate == 2 then
		for index = 1, x.edivlength do
			if IsAlive(x.ediv[index]) and GetDistance(x.ediv[index], "fprcy") < 64 then
				for index2 = 1, x.edivlength do
					RemoveObject(x.ediv[index2])
				end
				x.diversionstate = 3
				break
			end
		end
	end
	
	--APC ASSASSIN
	if x.easnstate == 1 and x.easntime < GetTime() then
		for index = 1, 4 do
			if not IsAlive(x.ediv[index]) then
				StartSoundEffect("portalx.wav", x.dummy)
				x.ediv[index] = BuildObject("kvscout", 5, x.dummypos)
				SetVelocity(x.ediv[index], (SetVector(-50.0, 0.0, 0.0))) --setvector is xyz world, ought be xyz handle
				SetSkill(x.ediv[index], x.skillsetting)
				SetObjectiveName(x.ediv[index], "Assassin")
				SetObjectiveOn(x.ediv[index])
				Attack(x.ediv[index], x.fapc)
			end
		end
		x.easnstate = x.easnstate + 1
	elseif x.easnstate == 2 and not IsAlive(x.fapc) then
		for index = 1, 4 do
			if IsAlive(x.ediv[index]) then
				SetObjectiveOff(x.ediv[index])
				Retreat(x.ediv[index], x.dummy2)
				if GetDistance(x.ediv[index], x.dummy2) < 30 then
					RemoveObject(x.ediv[index])
				end
			end
			
			if not IsAlive(x.ediv[index]) then
				x.casualty = x.casualty + 1
			end
		end
		
		if x.casualty == 4 then
			x.easnstate = 0
			x.easntime = 99999.9
		end
		x.casualty = 0
	elseif x.easnstate == 2 and IsAlive(x.fapc) then
		x.easnstate = 1
		x.easntime = GetTime() + 5.0
	end
	
	--KEEP APC AND PLAYER ALIVE
	if x.fapcstate >= 2 and x.fapcstate < 4 then
		if IsAlive(x.fapc) then
			SetCurHealth(x.fapc, 30000)
		end
		SetCurHealth(x.player, GetMaxHealth(x.player))
	end
	
	--WARCODE - SPECIAL DW06 ONLY	- NO CLOAK, WILL MAKE TOO HARD AND DRAG OUT MISSION
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
						x.ewarsize[index] = 2 * x.multiplier
					elseif x.ewarwave[index] == 2 then
						x.ewarsize[index] = 2 * x.multiplier
					elseif x.ewarwave[index] == 3 then
						x.ewarsize[index] = 3 * x.multiplier
					elseif x.ewarwave[index] == 4 then
						x.ewarsize[index] = 4 * x.multiplier
					else --x.ewarwave[index] == 5 then
						x.ewarsize[index] = 5 * x.multiplier
					end
					x.ewarstate[index] = x.ewarstate[index] + 1
				--BUILD FORCE
				elseif x.ewarstate[index] == 2 then
					--get spawn location
					while x.randompick == x.randomlast do
						x.randompick = math.floor(GetRandomFloat(1.0, 12.0))
					end
					x.randomlast = x.randompick
					if x.randompick == 1 or x.randompick == 5 or x.randompick == 9 then
						x.spawn = GetTransform(x.ptnorth)
					elseif x.randompick == 2 or x.randompick == 6 or x.randompick == 10 then
						x.spawn = GetTransform(x.ptsouth)
					else
						x.spawn = GetTransform(x.dummy)
					end
					--start spawning AI units
					for index2 = 1, x.ewarsize[index] do
						while x.randompick == x.randomlast do --random the random
							x.randomfloat = GetRandomFloat(1.0, 12.0) --single 0-n inclusive, or double n1-nx inclusive
							x.randompick = math.floor(x.randomfloat)
						end
						x.randomlast = x.randompick
						if x.spawn == x.dummypos then 
							StartSoundEffect("portalx.wav", x.spawn)
						end
						if x.randompick == 1 or x.randompick == 5 or x.randompick == 9 then
							x.ewarrior[index][index2] = BuildObject("kvscout", 5, x.spawn)
						elseif x.randompick == 2 or x.randompick == 6 or x.randompick == 10 then
							x.ewarrior[index][index2] = BuildObject("kvmbike", 5, x.spawn)
						elseif x.randompick == 3 or x.randompick == 7 or x.randompick == 11 then
							x.ewarrior[index][index2] = BuildObject("kvmisl", 5, x.spawn)
						else--if x.randompick == 4 or x.randompick == 8 or x.randompick == 12 then
							x.ewarrior[index][index2] = BuildObject("kvtank", 5, x.spawn)
						end
						SetVelocity(x.ewarrior[index][index2], (SetVector(-50.0, 0.0, 0.0))) --setvector is xyz world, ought be xyz handle
						SetSkill(x.ewarrior[index][index2], x.skillsetting)
						if index2 % 3 == 0 then
							SetSkill(x.ewarrior[index][index2], x.skillsetting+1)
						end
						x.ewartrgt[index][index2] = nil
						Goto(x.ewarrior[index][index2], "ebase")
					end
					x.ewarabort[index] = GetTime() + 300.0 --here first in case stage goes wrong
					x.ewarstate[index] = x.ewarstate[index] + 1
				--GIVE ATTACK ORDER AND CONDUCT UNIT BATTLE
				elseif x.ewarstate[index] == 3 then
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
									for index3 = 1, 11 do 
										if IsAlive(x.fgrp[index3]) then
											x.ewartrgt[index][index2] = x.fgrp[index3]
											break
										end
									end
									if not IsAlive(x.ewartrgt[index][index2]) then
										x.ewartrgt[index][index2] = x.player
									end
								end
							elseif index == 2 then
								if IsAlive(x.ffac) then
									x.ewartrgt[index][index2] = x.ffac
								elseif IsAlive(x.farm) then
									x.ewartrgt[index][index2] = x.farm
								elseif IsAlive(x.frcy) then
									x.ewartrgt[index][index2] = x.frcy
								else
									for index3 = 1, 11 do 
										if IsAlive(x.fgrp[index3]) then
											x.ewartrgt[index][index2] = x.fgrp[index3]
											break
										end
									end
									if not IsAlive(x.ewartrgt[index][index2]) then
										x.ewartrgt[index][index2] = x.player
									end
								end
							elseif index == 3 then
								if IsAlive(x.farm) then
									x.ewartrgt[index][index2] = x.farm
								elseif IsAlive(x.ffac) then
									x.ewartrgt[index][index2] = x.ffac
								elseif IsAlive(x.frcy) then
									x.ewartrgt[index][index2] = x.frcy
								else
									for index3 = 1, 11 do 
										if IsAlive(x.fgrp[index3]) then
											x.ewartrgt[index][index2] = x.fgrp[index3]
											break
										end
									end
									if not IsAlive(x.ewartrgt[index][index2]) then
										x.ewartrgt[index][index2] = x.player
									end
								end
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
									for index3 = 1, 11 do 
										if IsAlive(x.fgrp[index3]) then
											x.ewartrgt[index][index2] = x.fgrp[index3]
											break
										end
									end
									if not IsAlive(x.ewartrgt[index][index2]) then
										x.ewartrgt[index][index2] = x.player
									end
								end
							else --shouldn't ever run
								x.ewartrgt[index][index2] = x.player
							end
							if not x.ewarabortset[index] then
								x.ewarabort[index] = x.ewartime[index] + 300.0
								x.ewarabortset[index] = true
							end
							x.ewarriortime[index][index2] = GetTime()
						end
						--GIVE ATTACK
						if x.ewarriortime[index][index2] < GetTime() and IsAlive(x.ewarrior[index][index2]) and IsAlive(x.ewartrgt[index][index2])then
							Attack(x.ewarrior[index][index2], x.ewartrgt[index][index2])
							x.ewarriortime[index][index2] = GetTime() + 30.0
						end
						--CHECK IF SQUAD MEMBER DEAD
						if not IsAlive(x.ewarrior[index][index2]) then
							x.ewartrgt[index][index2] = nil
							x.casualty = x.casualty + 1
						end
					end
					
					--DO CASUALTY COUNT AND CALC FOR FREC ARRIVAL
					if x.casualty >= math.floor(x.ewarsize[index] * 0.8) then --reset attack group
						x.ewarabort[index] = 99999.9
						x.ewartime[index] = GetTime() + x.ewartimecool[index] + x.ewartimeadd[index]
						if not x.frcywave and x.ewarwave[3] == 3 then
							x.waveout = true
							x.frcystate = 1
							x.ewartime[1] = GetTime() + 120.0
							x.ewartime[2] = GetTime() + 120.0
							x.ewartime[3] = GetTime() + 120.0
							x.ewartime[4] = GetTime() + 240.0
							x.frcywave = true
						end
						if x.ewarwave[index] == 5 then --extra 120s after max wave to "ease up"
							x.ewartime[index] = GetTime() + x.ewartimecool[index] + x.ewartimeadd[index] + 60.0
						end
						x.ewarstate[index] = 1 --RESET
						x.ewarabortset[index] = false
					end
					x.casualty = 0
					
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
						for index2 = 1, x.ewarsize[index] do
							if IsAlive(x.ewarrior[index][index2]) then
								Attack(x.ewarrior[index][index2], x.ewartrgt[index][index2])
							end
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
	
	--CHECK STATUS OF MCA 
	if not x.MCAcheck then --red devil squad dead too soon		
		if x.timesup < GetTime() then --failed by time
			StopCockpitTimer()
			AudioMessage("tcdw0606.wav") --FAIL – 10 Lost portal control -time fail
			ClearObjectives()
			AddObjective("tcdw0602.txt", "RED")
			AddObjective("	")
			AddObjective("tcdw0604.txt", "RED")
			AddObjective("\n\nMISSION FAILED!", "RED")
			TCC.FailMission(GetTime() + 10.0, "tcdw06f1.des") --LOSER LOSER LOSER
			x.MCAcheck = true
			x.spine = 666
		end
		
		if not IsAlive(x.eprt) then --portal killed
			AudioMessage("tcdw0607.wav") --FAIL – 13 Lt. pull back. Ah Jesus, RTB. Wrld of hurt LT.
			ClearObjectives()
			AddObjective("tcdw0603.txt", "RED")
			AddObjective("\n\nMISSION FAILED!", "RED")
			TCC.FailMission(GetTime() + 13.0, "tcdw06f2.des") --LOSER LOSER LOSER
			x.MCAcheck = true
			x.spine = 666
		end
		
		if x.frcystate > 2 and not IsAlive(x.frec) then --NEEDS TO BE 2 KEEP 
			AudioMessage("tcdw0607.wav") --FAIL – 13 Lt. pull back. Ah Jesus, RTB. Wrld of hurt LT.
			ClearObjectives()
			AddObjective("Recycler destroyed.\n\nMISSION FAILED!", "RED")
			TCC.FailMission(GetTime() + 13.0, "tcdw06f3.des") --LOSER LOSER LOSER
			x.MCAcheck = true
			x.spine = 666
		end
		
		if x.frcystate < 1 then --lost too many wingman
			for index = 1, 11 do
				if not IsAround(x.fgrp[index]) then
					x.devildead = x.devildead + 1
				end
			end
			
			for index = 12, 17 do 
				if not IsAlive(x.fgrp[index]) then
					x.servdead = x.servdead + 1
				end
			end
			
			if x.devildead == 10 or x.servdead == 6 or (not x.waveout and x.devildead >= 8 and x.servdead >= 4) or (not x.basedead and x.devildead >= 6) then 
				StopCockpitTimer()
				AudioMessage("tcdw0606.wav") --FAIL – 10 Lost portal control -time fail
				ClearObjectives()
				AddObjective("tcdw0609.txt", "RED")
				TCC.FailMission(GetTime() + 10.0, "tcdw06f4.des") --LOSER LOSER LOSER
				x.MCAcheck = true
				x.spine = 666
			end 
			x.devildead = 0
			x.servdead = 0
		end
	end
end
--[[END OF SCRIPT]]