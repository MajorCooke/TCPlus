--bztcbd10 - Battlezone Total Command - Rise of the Black Dogs - 10/10 PREPARE TO EVACUATE  1185
assert(load(assert(LoadFile("_requirefix.lua")),"_requirefix.lua"))();
TCC = require("TC_Core")
MisnNum = 56;
local index = 0
local index2 = 0
local indexadd = 0
local x = {
	FIRST = true, 	
	MisnNum = 56,
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
	failstate = 0, 
	fnav = {},	
	randompick = 0, 
	randomlast = 0,
	randompickark = 0, 
	randomlastark = 0, 
	casualty = 0, 
	bignumber = 0, 
	fconcount = 20, --init here
	fpadexists = false, 
	fcneexists = false, 
	fapcexists = false, 
	protectmsg = false, 
	clockstate = 0, 
	clockseconds = 0, 
	cam1 = nil, --camera
	camstate = 0, 
	camfov = 60,  --185 default
	userfov = 90,  --seed
	panx = 0.1, 
	pany = 0.1, 
	fcontrgt = nil, 
	gotdummy = false, 
	gotdummy1 = false, 
	gotfpad = false, 
	gotfcne = false, 
	dummy = nil, 
	dummy1 = nil, 
	earth = nil, 
	frcy = nil, 
	ffac = nil, 
	farm = nil, 
	fgrp = {}, 
	fcon = {},
	fscp = {}, 
	fpad = nil, 
	fcne = nil, 
	fapc = {}, 
	fpwr = {nil, nil, nil, nil}, 
	fcom = nil,
	fbay = nil,
	ftrn = nil,
	ftec = nil,
	fhqr = nil,
	fsld = nil, 
	efac = {}, 
	efactory = nil, 
	edom = nil, 
	eark = nil, --arkin
	earktrgt = nil, 
	earkstate = 0, 
	earktime = 99999.9, 
	earkdone = false, 
	randomark = 0, 
	easn = {}, --assassin 
	easnsize = 8, 
	easntrgt = nil, 
	easnstate = 0, 
	easntime = 99999.9, 
	easncool = 99999.9, 
	easnbigtime = 99999.9, 
	fury = {}, --fury
	furytime = 99999.9, 
	furystate = 0, 
	furylength = 0, 
	eturtime = 99999.9, --eturret
	eturlength = 20,
	etur = {}, 
	eturcool = {}, 
	eturallow = {}, 
	etursecs = {}, 
	epattime = 99999.9, --epatrols
	epatlength = 4, 
	epat = {}, 
	epatcool = {}, 
	epatallow = {},	
	epatsecs = {}, 
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
	ewarsizeadd = {}, 
	ewarwave = {}, 
	ewarwavemax = {}, 
	ewarwavereset = {}, 
	ewarmeet = {}, 
	ewartrgt = {},
	weappick = 0, 
	weaplast = 0, 
	LAST = true
}
--PATHS: fpnav1-3, eptur1-20, stage1-2, pscrap(0-160), ppatrol1-4, fpadarea, fpadtest, fpapc(0-3), pfury(0-12), pcon1-4, asnstage1-4

function InitialSetup()
	SetAutoGroupUnits(true)
		
	local odfpreload = {
		"bvrecybd10", "bvconsbd10", "bvscav", "bvmisl", "bvrckt", "bvwalk", "bvtank", "bvturr", "bvapc", "abcone1", "abcone", "ablpadbd10", 
		"nvscout", "nvmbike", "nvmisl", "nvtank", "nvrckt", "nvwalk", "nvstnk", "nvturr", "nvark1", "nvark2", "nvark3", "nvark4", 
		"mvscout", "mvmbike", "mvmisl", "mvtank", "mvrckt", "yvrckt", "yvartl", "npscrx", "dummy00", "dummy01", "apcamrb", "svhtnk"
	}
	for k,v in pairs(odfpreload) do
		PreloadODF(v)
	end
	
	x.cam1 = GetHandle("pcam")
	x.earth = GetHandle("earth")
	x.frcy = GetHandle("frcy")
	x.mytank = GetHandle("mytank")
	x.edom = GetHandle("edome")
	for index = 1, 11 do
		x.fgrp[index] = GetHandle(("fgrp%d"):format(index))
	end
	for index = 1, 4 do
		x.efac[index] = GetHandle(("efac%d"):format(index))
	end
	Ally(1, 4)
	Ally(4, 1)
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
	if (not IsAlive(x.farm) or x.farm == nil) and IsOdf(h, "bvarmo:1") or IsOdf(h, "bbarmo") then
		x.farm = RepObject(h);
		h = x.farm;
	elseif (not IsAlive(x.ffac) or x.ffac == nil) and IsOdf(h, "bvfactbd10:1") or IsOdf(h, "bbfactbd10") then
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

	--new constructor
	for indexadd = 1, x.fconcount do
		if IsOdf(h, "bvconsbd10:1") and (not IsAlive(x.fcon[indexadd]) or x.fcon[indexadd] == nil) then
			x.fcon[indexadd] = h
			break
		end
	end

	--new extractor
	for indexadd = 1, 10 do
		if IsOdf(h, "bbscav") and (not IsAlive(x.fscp[indexadd]) or x.fscp[indexadd] == nil) then
			x.fscp[indexadd] = h
			break
		end
	end

	--get launchpad
	if not x.gotfpad and IsOdf(h, "ablpadbd10") and (not IsAlive(x.fpad) or x.fpad == nil) then
		x.fpad = h
		x.gotfpad = true
	end

	--[[THIS ONLY WORKS IF PREPLACED IN EDITOR camera dummy on ablpadbd10
	if not x.gotdummy and IsOdf(h, "dummy00") and IsAlive(x.fpad) then
		x.dummy = h
		SetLabel(h, "thecamdummy")
		x.gotdummy = true
	end--]]

	--get rocket\n
	if not x.gotfcne and IsOdf(h, "abcone1") and (not IsAlive(x.fcne) or x.fcne == nil) then
		x.fcne = h
		x.gotfcne = true
	end

	--remove pilots since no recy
	local race = GetRace(h);
	if (race == "n" or race == "m" or race == "y") then
		SetEjectRatio(h, 0);
	end
	TCC.AddObject(h)
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
	--[[TEST FINAL CUTSCENE
	if x.spine == 0 then
		x.fpad = BuildObject("ablpadbd10", 1, "fpadtest")
		x.fcne = BuildObject("abcone1", 1, x.dummy1)
		x.waittime = GetTime() + 4.0
		x.spine = 10
	end--]]
	
	--START THE MISSION BASICS
	if x.spine == 0 then
		x.audio1 = AudioMessage("tcbd1001.wav")
		x.pos = GetTransform(x.frcy)
		RemoveObject(x.frcy)
		x.frcy = BuildObject("bvrecybd10", 1, x.pos)
		SetGroup(x.frcy, 2)
		x.pos = GetTransform(x.fgrp[1])
		RemoveObject(x.fgrp[1])
		x.fgrp[1] = BuildObject("bvmisl", 1, x.pos)
		SetGroup(x.fgrp[1], 0)
		x.pos = GetTransform(x.fgrp[2])
		RemoveObject(x.fgrp[2])
		x.fgrp[2] = BuildObject("bvrckt", 1, x.pos)
		SetGroup(x.fgrp[2], 0)
		x.pos = GetTransform(x.fgrp[3])
		RemoveObject(x.fgrp[3])
		x.fgrp[3] = BuildObject("bvwalk", 1, x.pos)
		SetGroup(x.fgrp[3], 1)
		for index = 4, 9 do
			x.pos = GetTransform(x.fgrp[index])
			RemoveObject(x.fgrp[index])
			x.fgrp[index] = BuildObject("bvturr", 1, x.pos)
			SetGroup(x.fgrp[index], 5)
		end
		x.pos = GetTransform(x.fgrp[10])
		RemoveObject(x.fgrp[10])
		x.fgrp[10] = BuildObject("bvscav", 1, x.pos)
		SetGroup(x.fgrp[10], 7)
		x.pos = GetTransform(x.fgrp[11])
		RemoveObject(x.fgrp[11])
		x.fgrp[11] = BuildObject("bvcons", 1, x.pos) --bvconsbd10
		SetGroup(x.fgrp[11], 8)
		x.fcon[1] = x.fgrp[11] --SET 1ST CONS DIRECTLY
		x.pos = GetTransform(x.mytank)
		RemoveObject(x.mytank)
		x.mytank = BuildObject("svhtnk", 1, x.pos);
		SetAsUser(x.mytank, 1);
		RemoveObject(x.player);
		x.player = GetPlayerHandle();

		local newhp = GetMaxHealth(x.mytank) * 2;
		SetMaxHealth(x.mytank, newhp);
		SetCurHealth(x.mytank, newhp);
		SetMaxAmmo(x.mytank, GetMaxAmmo(x.mytank) * 2);

		for index = 1, 160 do
			x.fnav[1] = BuildObject("npscrx", 0, "pscrap", index)
		end
		x.easncool = GetTime()
		for index = 1, x.eturlength do --init tur
			x.etur[index] = BuildObject("nvturr", 5, ("eptur%d"):format(index))
			x.eturtime = GetTime() + 300.0
			x.etursecs[index] = 0.0
			x.eturcool[index] = GetTime()
		end
		for index = 1, x.epatlength do --init epat
			x.epattime = GetTime() + 300.0
			x.epatcool[index] = GetTime()
			x.epatallow[index] = true
			x.epatsecs[index] = 0.0
		end
		x.panx = 500.0
		x.camstate = 1
    x.userfov = IFace_GetInteger("options.graphics.defaultfov")
    CameraReady()
    IFace_SetInteger("options.graphics.defaultfov", x.camfov)
		x.spine = x.spine + 1
	end
	
	--GIVE FIRST OBJECTIVE
	if x.spine == 1 and IsAudioMessageDone(x.audio1) then
		x.camstate = 0
    CameraFinish()
    IFace_SetInteger("options.graphics.defaultfov", x.userfov)
		SetColorFade(6.0, 0.5, "BLACK")
		--AddObjective("tcbd1001.txt")
		x.bignumber = GetODFInt("ablpadbd10.odf", "GameObjectClass", "scrapCost", 666)
		AddObjective(("Deploy scavengers to acquire %d scrap capacity to build a launch pad."):format(x.bignumber))
		x.fnav[1] = BuildObject("apcamrb", 1, "fpnav1")
		SetObjectiveName(x.fnav[1], "BDS base")
		x.fnav[2] = BuildObject("apcamrb", 1, "fpnav2")
		SetObjectiveName(x.fnav[2], "AIP base")
		SetScrap(1, 40)
		x.frcyprotext = true
		for index = 1, x.ewartotal do --INIT WARCODE
			x.ewartotal = 4 
			x.ewardeclare = true
			x.ewarrior[index] = {} --"rows"
			x.ewartrgt[index] = {} --"rows"
			for index2 = 1, 10 do --n should be max number avail
				x.ewarrior[index][index2] = nil --"columns", init (handle in this case)
				x.ewartrgt[index][index2] = nil
			end
			x.ewarstate[index] = 1
			x.ewartime[1] = GetTime() + 120.0 --recy
			x.ewartime[2] = GetTime() + 160.0 --fact
			x.ewartime[3] = GetTime() + 200.0 --armo
			x.ewartime[4] = GetTime() + 240.0 --base
			x.ewartimecool[index] = 240.0
			x.ewartimeadd[index] = 0.0
			x.ewarabortset[index] = false
			x.ewarabort[index] = 99999.9
			x.ewarsize[index] = 0
			x.ewarsizeadd[index] = 0
			x.ewarwave[index] = 0
			x.ewarwavemax[index] = 5
			x.ewarwavereset[index] = 2
			x.ewarmeet[index] = 2
		end
		x.spine = x.spine + 1
	end
	
	--ORDER LPAD
	if x.spine == 2 and GetMaxScrap(1) >= x.bignumber	then
		AudioMessage("tcbd1002.wav")
		ClearObjectives()
		AddObjective("tcbd1001.txt", "GREEN")
		AddObjective("	")
		AddObjective("tcbd1002.txt")
		x.fnav[3] = BuildObject("apcamrb", 1, "fpnav3")
		SetObjectiveName(x.fnav[3], "Build Site")
		SetObjectiveOn(x.fnav[3])
		x.spine = x.spine + 1
	end
	
	--ORDER ROCKET (make sure if spine change to change fnav spine number)
	if x.spine == 3 and IsAlive(x.fpad) then
		x.fpadexists = true
		AudioMessage("tcbd1003.wav")
		ClearObjectives()
		AddObjective("tcbd1002.txt", "GREEN")
		AddObjective("	")
		AddObjective("tcbd1003.txt")
		x.spine = x.spine + 1
	end
	
	--CONE BUILT
	if x.spine == 4 and IsAlive(x.fcne) and IsAlive(x.fpad) then
		x.fcneexists = true
		AudioMessage("tcbd1004.wav")
		ClearObjectives()
		AddObjective("tcbd1003.txt", "GREEN")
		AddObjective("\n\nWait for new orders.")
		x.waittime = GetTime() + 30.0
		x.spine = x.spine + 1
	end
	
	--BUILD APCs
	if x.spine == 5 and x.waittime < GetTime() then
		for index = 1, 3 do
			x.fapc[index] = BuildObject("bvapc", 4, "fpapc", index)
			SetObjectiveName(x.fapc[index], ("VIP apc %d"):format(index))
			SetObjectiveOn(x.fapc[index])
		end
		Retreat(x.fapc[1], x.fpad)
		Follow(x.fapc[2], x.fapc[1])
		Follow(x.fapc[3], x.fapc[2])
		x.fapcexists = true
		x.easnstate = 99
		for index = 1, x.easnsize do
			Retreat(x.easn[index], "fpnav2")
		end
		x.ewardeclare = false
		for index = 1, 4 do
			for index2 = 1, 16 do
				if IsAlive(x.ewarrior[index][index2]) then
					Retreat(x.ewarrior[index][index2], "fpnav2")
				end
			end
		end
		x.earkdone = true
		if IsAlive(x.eark) then
			Retreat(x.eark, "fpnav2")
			SetObjectiveOff(x.eark)
		end
		x.audio1 = AudioMessage("tcbd1005.wav")
		x.spine = x.spine + 1
	end
	
	--PAUSE AFTER AUDIO
	if x.spine == 6 and IsAudioMessageDone(x.audio1) then
		ClearObjectives()
		AddObjective("tcbd1004.txt")
		x.waittime = GetTime() + 30.0
		if x.skillsetting == x.medium then
			x.waittime = GetTime() + 25.0
		elseif x.skillsetting > x.medium then
			x.waittime = GetTime() + 20.0
		end
		x.spine = x.spine + 1
	end
	
	--START FURY ATTACK
	if x.spine == 7 and x.waittime < GetTime() then
		x.furystate = 1
		x.spine = x.spine + 1
	end
	
	--FAPC ARRIVED AT LPAD
	if x.spine == 8 and (IsAlive(x.fapc[1]) and IsAlive(x.fapc[2]) and IsAlive(x.fapc[3]) and IsAlive(x.fpad) and  GetDistance(x.fapc[1], x.fpad) < 64) and (GetDistance(x.fapc[2], x.fpad) < 64) and (GetDistance(x.fapc[2], x.fpad) < 64) then
		x.audio1 = AudioMessage("tcbd1007.wav") 
		ClearObjectives()
		AddObjective("tcbd1004.txt", "GREEN")
		AddObjective("\n\nDestroy any remaining Furies.")
		SetCurHealth(x.fpad, (GetMaxHealth(x.fpad) + 10000))
		x.spine = x.spine + 1
	end
	
	--ARE FURIES CLEARED OUT
	if x.spine == 9 and IsAudioMessageDone(x.audio1) then
		for index = 1, x.furylength do
			if not IsAlive(x.fury[index]) then
				x.casualty = x.casualty + 1
			end
		end
		if x.casualty >= x.furylength then
			ClearObjectives()
			AddObjective("Enemy forces defeated.\n\nPersonnel and rocket ready for liftoff.\n\nMISSION COMPLETE.", "GREEN")
			x.waittime = GetTime() + 5.0
			x.spine = x.spine + 1
		end
		x.casualty = 0
	end
	
	--SETUP ROCKET LAUNCH CAM
	if x.spine == 10 and x.waittime < GetTime() then
		x.fpadexists = false
		x.fcneexists = false
		x.fapcexists = false
		x.pos = GetTransform(x.fcne)
		RemoveObject(x.fcne)
		x.fcne = BuildObject("abcone", 0, x.pos)
		x.MCAcheck = true
		x.camstate = 2
		x.waittime = GetTime() + 10.0
		SetAnimation(x.fcne, "launch", 1)
    x.userfov = IFace_GetInteger("options.graphics.defaultfov")
    CameraReady()
    IFace_SetInteger("options.graphics.defaultfov", x.camfov)
		StartSoundEffect("dropleav.wav", x.fpad)
		x.audio1 = AudioMessage("tcbd1008.wav")
		ClearObjectives()
		x.spine = x.spine + 1
	end
	
	--CHANGE CAMERA TO EARTH
	if x.spine == 11 and x.waittime < GetTime() then
		SetAnimation(x.earth, "flyby", 1)
		x.panx = 0.0
		x.pany = 83.0
		x.camstate = 3
		x.spine = x.spine + 1
	end
	
	--MISSION SUCCESS
	if x.spine == 12 and IsAudioMessageDone(x.audio1) then
    CameraFinish()
    IFace_SetInteger("options.graphics.defaultfov", x.userfov)
    if not IsAlive(x.edom) and not IsAlive(x.efac[1]) and not IsAlive(x.efac[2]) and not IsAlive(x.efac[3]) and not IsAlive(x.efac[4]) then
      TCC.SucceedMission(GetTime(), "tcbd10w2.des") --ARKIN DEAD ALT ENDING
    else
      TCC.SucceedMission(GetTime(), "tcbd10w.des") --WINNER WINNER WINNER
    end
		x.spine = x.spine + 1
	end
	----------END MAIN SPINE ----------
	
	--CAMERA AIP BASE
	if x.camstate == 1 then
		CameraObject(x.edom, x.panx, 50, 200, x.edom) --height is stardome radius
		x.panx = x.panx - 2.0 --minus
	end
	
	--CAMERA ROCKET LAUNCH
	if x.camstate == 2 then
		CameraObject(x.fpad, 0, -20, 250, x.fcne)
	end
	
	--CAMERA ROCKET TO EARTH
	if x.camstate == 3 then
		CameraObject(x.cam1, x.panx, x.pany, 2, x.earth) --height is stardome radius
		x.panx = x.panx - 0.02 --minus
		x.pany = x.pany + 0.05
	end
	
	--CAMERA ON FURIES
	if x.camstate == 4 then --4 is correct
		CameraObject(x.fury[1], 20, -10, 60, x.fury[1])
	end
	
	--KEEP BUILD AREA BEACON ALIVE
	if x.spine == 3 and not IsAlive(x.fnav[3]) and not IsAlive(x.fpad) then
		x.fnav[3] = BuildObject("apcamrb", 1, "fpnav3")
		SetObjectiveName(x.fnav[3], "Build Site")
	end
	
	--ARKIN ATTACK
	if not x.earkdone and IsAlive(x.edom) then
		if x.earkstate == 0 then
			for index = 1, 12 do
				x.randompick = math.floor(GetRandomFloat(1.0, 9.0))
			end
			if x.randompick == 1 or x.randompick == 4 or x.randompick == 7 then
				x.earktime = GetTime() + 540.0
			elseif x.randompick == 2 or x.randompick == 5 or x.randompick == 8 then
				x.earktime = GetTime() + 420.0
			else
				x.earktime = GetTime() + 300.0
			end
			if IsAlive(x.fpad) then
				x.earktime = GetTime() + 90.0
			end
			x.earkstate = x.earkstate + 1
		elseif x.earkstate == 1 and x.earktime < GetTime() then
			while x.randompickark == x.randomlastark do --random the random
				x.randompickark = math.floor(GetRandomFloat(1.0, 12.0))
			end
			x.randomlastark = x.randompickark
			if x.randompickark == 1 or x.randompickark == 5 or x.randompickark == 9 then
				x.eark = BuildObject("nvark1", 5, x.edom)
			elseif x.randompickark == 2 or x.randompickark == 6 or x.randompickark == 10 then
				x.eark = BuildObject("nvark2", 5, x.edom)
			elseif x.randompickark == 3 or x.randompickark == 7 or x.randompickark == 11 then
				x.eark = BuildObject("nvark3", 5, x.edom)
			else
				x.eark = BuildObject("nvark4", 5, x.edom)
			end
			SetSkill(x.eark, x.skillsetting)
			for index = 1, 30 do
				x.randomark = math.floor(GetRandomFloat(1.0, 8.0)) --don't try to hit all
			end
			if IsAlive(x.fpad) then
				x.earktrgt = x.fpad
			elseif IsAlive(x.fscp[x.randomark]) then
				x.earktrgt = x.fscp[x.randomark]
			elseif IsAlive(x.frcy) then
				x.earktrgt = x.frcy
			else
				x.earktrgt = x.player
			end
			Attack(x.eark, x.earktrgt)
			x.earkstate = x.earkstate + 1
		elseif x.earkstate == 2 then
			if IsAlive(x.eark) and GetDistance(x.eark, x.earktrgt) < 800 then
				AudioMessage("tcbd1009.wav")
				SetObjectiveOn(x.eark)
				x.earkstate = x.earkstate + 1
			elseif not IsAlive(x.eark) then
				x.earkstate = 0
			end
		elseif x.earkstate == 3 and ((IsAlive(x.eark) and GetCurHealth(x.eark) < math.floor(GetMaxHealth(x.eark)*0.15)) or not IsAlive(x.earktrgt)) then
			SetCurHealth(x.eark, GetMaxHealth(x.eark))
			SetObjectiveOff(x.eark)
			Retreat(x.eark, "eparkretreat")
			x.earkstate = x.earkstate + 1
		elseif x.earkstate == 4 then
			if (IsAlive(x.eark) and GetDistance(x.eark, x.edom) < 80) or not IsAlive(x.eark) then
				RemoveObject(x.eark)
				x.earkstate = 0
			end
		end
	end
	
	--GET LAUNCHPAD FCONTRGT (separate from assassin and countdown clock)
	if not IsAlive(x.fpad) and not IsAlive(x.fcontrgt) then
		for index = 1, x.fconcount do
			if IsAlive(x.fcon[index]) and IsInsideArea("fpadarea", x.fcon[index]) and IsBusy(x.fcon[index]) and GetBuildClass(x.fcon[index]) == "ablpadbd10" then
				x.fcontrgt = x.fcon[index]
				AudioMessage("tcbd1010.wav")
				break
			end
		end
	end
	
	--GET ROCKET FCONTRGT (for countdown clock)
	if IsAlive(x.fpad) then
		for index = 1, x.fconcount do
			 if IsAlive(x.fcon[index]) and IsInsideArea("fpadarea", x.fcon[index]) and GetCurrentCommand(x.fcon[index]) == 32 then --32=CMD_POWER
				x.fcontrgt = x.fcon[index]
				break
			end
		end
	end

	--ASSASSINATE THE CONSTRUCTOR BUILDING THE LAUNCHPAD.
	if x.easnstate == 0 and x.easncool < GetTime() and IsAlive(x.edom) and (IsAlive(x.fpad) or IsAlive(x.fcontrgt)) then 
		x.easnsize = 4 --while fpad under construction
		if IsAlive(x.fpad) then
			x.easnsize = 8
		end
		for index = 1, x.easnsize do
			if not IsAlive(x.easn[index]) then
				while x.randompick == x.randomlast do --random the random
					x.randompick = math.floor(GetRandomFloat(1.0, 15.0))
				end
				x.randomlast = x.randompick
				if x.randompick == 1 or x.randompick == 6 or x.randompick == 11 then
					x.easn[index] = BuildObject("nvscout", 5, x.edom)
				elseif x.randompick == 2 or x.randompick == 7 or x.randompick == 12 then
					x.easn[index] = BuildObject("nvmbike", 5, x.edom)
				elseif x.randompick == 3 or x.randompick == 8 or x.randompick == 13 then
					x.easn[index] = BuildObject("nvmisl", 5, x.edom)
				elseif x.randompick == 4 or x.randompick == 9 or x.randompick == 14 then
					x.easn[index] = BuildObject("nvtank", 5, x.edom)
				else --5, 10, 15
					x.easn[index] = BuildObject("nvrckt", 5, x.edom)
				end
				SetSkill(x.easn[index], x.skillsetting)
			end
			if IsAlive(x.fpad) then
				Retreat(x.easn[index], "asnstage3")
			elseif IsInsideArea("pcon1", x.fcontrgt) then
				Retreat(x.easn[index], "asnstage1")
			elseif IsInsideArea("pcon2", x.fcontrgt) then
				Retreat(x.easn[index], "asnstage2")
			elseif IsInsideArea("pcon3", x.fcontrgt) then
				Retreat(x.easn[index], "asnstage3")
			elseif IsInsideArea("pcon4", x.fcontrgt) then
				Retreat(x.easn[index], "asnstage4")
			end
			x.easnbigtime = GetTime() + 420.0
		end
		x.easnstate = x.easnstate + 1
	elseif x.easnstate == 1 then --pick and assassinate target
		for index = 1, x.easnsize do
			if IsAlive(x.easn[index]) and GetDistance(x.easn[index], ("asnstage%d"):format(index)) < 30 then
				if IsAlive(x.fpad) then
					x.easntrgt = x.fpad
				else
					x.easntrgt = x.fcontrgt
				end
				for index2 = 1, x.easnsize do
					Attack(x.easn[index2], x.easntrgt)
				end
				x.easnstate = x.easnstate + 1
				break
			end
		end
	elseif x.easnstate == 2 then --if assassin dead or target dead, reset
		for index = 1, x.easnsize do
			if not IsAlive(x.easn[index]) then
				x.casualty = x.casualty + 1
			end
		end
		if (x.casualty >= math.floor(x.easnsize * 0.5)) or not IsAlive(x.easntrgt) then
			x.easnbigtime = 99999.9
			x.easncool = GetTime() + 30.0
			x.easnstate = 0
		end
		x.casualty = 0
	end 
	
	--IF ASSASSIN GOES WRONG
	if x.easnbigtime < GetTime() then
		x.easnstate = 0
		x.easnbigtime = 99999.9
	end
	
	--COUNTDOWN CLOCK. Oh, the drama of knowing.
	--fpad countdown
	if x.clockstate == 0 and IsAlive(x.fcontrgt) and IsInsideArea("fpadarea", x.fcontrgt) and IsBusy(x.fcontrgt) and GetBuildClass(x.fcontrgt) == "ablpadbd10"	then
		x.clockseconds = GetODFInt("ablpadbd10.odf", "GameObjectClass", "buildTime")
		StartCockpitTimer(x.clockseconds, 180, 60)
		x.clockstate = x.clockstate + 1
	elseif x.clockstate == 1 then
		if (not IsAlive(x.fcontrgt) or not IsBusy(x.fcontrgt)) and not IsAlive(x.fpad) then
			StopCockpitTimer()
			HideCockpitTimer()
			x.clockstate = 0 --RESET BACK TO ZERO
		elseif IsAlive(x.fpad) then
			StopCockpitTimer()
			HideCockpitTimer()
			x.clockstate = x.clockstate + 1
		end
	--rocket countdown
	elseif x.clockstate == 2 and IsAlive(x.fpad) and IsInsideArea("fpadarea", x.fcontrgt) and GetCurrentCommand(x.fcontrgt) == 32 then
		x.clockseconds = GetODFInt("abcone1.odf", "GameObjectClass", "buildTime")
		StartCockpitTimer(x.clockseconds, 180, 60)
		x.clockstate = x.clockstate + 1
	elseif x.clockstate == 3 then
		if (not IsAlive(x.fcontrgt) or GetCurrentCommand(x.fcontrgt) ~= 32) and not IsAlive(x.fcne) then
			StopCockpitTimer()
			HideCockpitTimer()
			x.clockstate = 2 --RESET BACK TO TWO
		elseif IsAlive(x.fcne) then
			StopCockpitTimer()
			HideCockpitTimer()
			x.clockstate = x.clockstate + 1
		end
	end
	
	--FURY ASSASSIN FORCE
	if x.furystate == 1 then
		x.fury[1] = BuildObject("yvrckt", 5, "pfury", 1)
		Attack(x.fury[1], x.fapc[1])
		x.fury[2] = BuildObject("yvrckt", 5, "pfury", 2)
		Attack(x.fury[2], x.fapc[2])
		x.fury[3] = BuildObject("yvrckt", 5, "pfury", 3)
		Attack(x.fury[3], x.fapc[3])
		x.fury[4] = BuildObject("yvartl", 5, "pfury", 4)
		Attack(x.fury[4], x.fpad)
		x.fury[5] = BuildObject("yvartl", 5, "pfury", 5)
		Attack(x.fury[5], x.fpad)
		x.fury[6] = BuildObject("yvartl", 5, "pfury", 6)
		Attack(x.fury[6], x.fpad)
		x.fury[7] = BuildObject("yvartl", 5, "pfury", 7)
		Attack(x.fury[7], x.fpad)
		x.fury[8] = BuildObject("yvartl", 5, "pfury", 8)
		Attack(x.fury[8], x.fpad)
		x.fury[9] = BuildObject("yvartl", 5, "pfury", 9)
		Attack(x.fury[9], x.fpad)
		x.furylength = 9
		for index = 1, x.furylength do
			SetSkill(x.fury[index], x.skillsetting)
		end
		x.furytime = GetTime() + 3.0
		x.furystate = x.furystate + 1
	elseif x.furystate == 2 and x.furytime < GetTime() then
		x.audio1 = AudioMessage("tcbd1006.wav")
		x.camstate = 4
    x.userfov = IFace_GetInteger("options.graphics.defaultfov")
    CameraReady()
    IFace_SetInteger("options.graphics.defaultfov", x.camfov)
		x.furystate = x.furystate + 1
	elseif x.furystate == 3 and IsAudioMessageDone(x.audio1) then
		x.camstate = 0
    CameraFinish()
    IFace_SetInteger("options.graphics.defaultfov", x.userfov)
		x.furytime = GetTime() + 30.0
		x.furystate = x.furystate + 1
	elseif x.furystate == 4 and x.furytime < GetTime() then
		x.fury[10] = BuildObject("yvrckt", 5, "pfury", 10)
		SetSkill(x.fury[10], x.skillsetting)
		Attack(x.fury[10], x.fapc[1])
		x.fury[11] = BuildObject("yvrckt", 5, "pfury", 11)
		SetSkill(x.fury[11], x.skillsetting)
		Attack(x.fury[11], x.fapc[2])
		x.fury[12] = BuildObject("yvrckt", 5, "pfury", 12)
		SetSkill(x.fury[12], x.skillsetting)
		Attack(x.fury[12], x.fapc[3])
		x.furylength = 12
		x.furystate = x.furystate + 1
	end

	--IF PLAYER DECIDES TO DESTROY AIP BASE
	if not IsAlive(x.edom) and not IsAlive(x.efac[1]) and not IsAlive(x.efac[2]) and not IsAlive(x.efac[3]) and not IsAlive(x.efac[4]) and not IsAlive(x.fpad) then
		ClearObjectives()
		AddObjective("AIP base destroyed.\n\nMISSION COMPLETE.", "GREEN")
		x.fapcexists = true
		x.earkdone = true
		x.easnstate = 99
		x.easnsize = 8
		for index = 1, x.easnsize do
			if IsAlive(x.easn[index]) then
				Retreat(x.easn[index], "fpnav2")
			end
		end
		x.ewardeclare = false
		for index = 1, 4 do
			for index2 = 1, 16 do
				if IsAlive(x.ewarrior[index][index2]) then
					Retreat(x.ewarrior[index][index2], "fpnav2")
				end
			end
		end
		if IsAlive(x.eark) then
			RemoveObject(x.eark)
		end
		if IsAlive(x.fpad) then
			RemoveObject(x.fpad)
		end
		if IsAlive(x.fcontrgt) then
			RemoveObject(x.fcontrgt)
		end
		x.fpad = BuildObject("ablpad2", 1, "fpadtest")
		x.MCAcheck = true
		x.waittime = GetTime() + 4.0
		x.spine = 10 --BE SURE TO KEEP CORRECT
	end

	--AI GROUP TURRETS
	if x.eturtime < GetTime() then
		for index = 1, x.eturlength do
			if not IsAlive(x.etur[index]) and not x.eturallow[index] then
				x.etursecs[index] = x.etursecs[index] + 60.0
				x.eturcool[index] = GetTime() + 240.0 + x.etursecs[index]
				x.eturallow[index] = true
			end
			if x.eturallow[index] and x.eturcool[index] < GetTime() and IsAlive(x.edom) then
				x.etur[index] = BuildObject("nvturr", 5, x.edom)
				Goto(x.etur[index], ("eptur%d"):format(index))
				SetSkill(x.etur[index], x.skillsetting)
				x.eturallow[index] = false
			end
		end
	end

	--AI GROUP PATROLS
	if x.epattime < GetTime() then
		for index = 1, x.epatlength do
			if not IsAlive(x.epat[index]) and not x.epatallow[index] then
				x.epatsecs[index] = x.epatsecs[index] + 60.0
				x.epatcool[index] = GetTime() + 240.0 + x.epatsecs[index]
				x.epatallow[index] = true
			end
			if x.epatallow[index] and x.epatcool[index] < GetTime() then
				while x.randompick == x.randomlast do --random the random
					x.randompick = math.floor(GetRandomFloat(1.0, 12.0))
				end
				x.randomlast = x.randompick
				if x.randompick == 1 or x.randompick == 5 or x.randompick == 9 then
					if IsAlive(x.efac[2]) then
						x.epat[index] = BuildObject("mvmbike", 5, x.efac[2])
					elseif IsAlive(x.efac[3]) then
						x.epat[index] = BuildObject("mvmbike", 5, x.efac[3])
					elseif IsAlive(x.efac[4]) then
						x.epat[index] = BuildObject("mvmbike", 5, x.efac[4])
					elseif IsAlive(x.efac[1]) then
						x.epat[index] = BuildObject("mvmbike", 5, x.efac[1])
					end
				elseif x.randompick == 2 or x.randompick == 6 or x.randompick == 10 then
					if IsAlive(x.efac[3]) then
						x.epat[index] = BuildObject("mvmisl", 5, x.efac[3])
					elseif IsAlive(x.efac[4]) then
						x.epat[index] = BuildObject("mvmisl", 5, x.efac[4])
					elseif IsAlive(x.efac[1]) then
						x.epat[index] = BuildObject("mvmisl", 5, x.efac[1])
					elseif IsAlive(x.efac[2]) then
						x.epat[index] = BuildObject("mvmisl", 5, x.efac[2])
					end
				elseif x.randompick == 3 or x.randompick == 7 or x.randompick == 11 then
					if IsAlive(x.efac[4]) then
						x.epat[index] = BuildObject("mvtank", 5, x.efac[4])
					elseif IsAlive(x.efac[1]) then
						x.epat[index] = BuildObject("mvtank", 5, x.efac[1])
					elseif IsAlive(x.efac[2]) then
						x.epat[index] = BuildObject("mvtank", 5, x.efac[2])
					elseif IsAlive(x.efac[3]) then
						x.epat[index] = BuildObject("mvtank", 5, x.efac[3])
					end
				else
					if IsAlive(x.efac[1]) then
						x.epat[index] = BuildObject("mvrckt", 5, x.efac[1])
					elseif IsAlive(x.efac[2]) then
						x.epat[index] = BuildObject("mvrckt", 5, x.efac[2])
					elseif IsAlive(x.efac[3]) then
						x.epat[index] = BuildObject("mvrckt", 5, x.efac[3])
					elseif IsAlive(x.efac[4]) then
						x.epat[index] = BuildObject("mvrckt", 5, x.efac[4])
					end
				end
				Patrol(x.epat[index], ("ppatrol%d"):format(index))
				SetSkill(x.epat[index], x.skillsetting)
				x.epatallow[index] = false
			end
		end
		x.epattime = GetTime() + 30.0
	end
	
	--WARCODE --special per garage
	if x.ewardeclare then
		for index = 1, x.ewartotal do	
			if x.ewartime[index] < GetTime() then 
				--SET WAVE NUMBER AND BUILD SIZE
				if x.ewarstate[index] == 1 then
					x.ewarwave[index] = x.ewarwave[index] + 1
					if x.ewarwave[index] > x.ewarwavemax[index] then
						x.ewarwave[index] = x.ewarwavereset[index]
					end
					if x.ewarwave[index] == 1 then
							x.ewarsize[index] = 2
					elseif x.ewarwave[index] == 2 then
							x.ewarsize[index] = 4 --3
					elseif x.ewarwave[index] == 3 then
							x.ewarsize[index] = 6 --4
					elseif x.ewarwave[index] == 4 then
							x.ewarsize[index] = 8 --5
					else --x.ewarwave[index] == 5 then
						--if index == 1 then
							--x.ewarsize[index] = 8
						--else
							x.ewarsize[index] = 10 --6
						--end
					end
					x.ewarstate[index] = x.ewarstate[index] + 1
				end
				
				--BUILD FORCE
				if x.ewarstate[index] == 2 then
					for index2 = 1, x.ewarsize[index] do
						while x.randompick == x.randomlast do --random the random
							x.randompick = math.floor(GetRandomFloat(1.0, 18.0))
						end
						x.randomlast = x.randompick
						if IsAlive(x.efac[1]) then
							x.efactory = x.efac[1]
						elseif IsAlive(x.efac[2]) then
							x.efactory = x.efac[2]
						elseif IsAlive(x.efac[3]) then
							x.efactory = x.efac[3]
						elseif IsAlive(x.efac[4]) then
							x.efactory = x.efac[4]
						end
						if x.randompick == 1 or x.randompick == 8 or x.randompick == 15 then
							x.ewarrior[index][index2] = BuildObject("nvscout", 5, x.efactory)
							if x.ewarwave[index] == 3 or x.ewarwave[index] == 4 then
								GiveWeapon(x.ewarrior[index][index2], "glasea_c")
							end
						elseif x.randompick == 2 or x.randompick == 9 or x.randompick == 16 then
							x.ewarrior[index][index2] = BuildObject("nvmbike", 5, x.efactory)
							if x.ewarwave[index] == 2 or x.ewarwave[index] == 4 then
								GiveWeapon(x.ewarrior[index][index2], "gstbva_c")
							end
						elseif x.randompick == 3 or x.randompick == 10 or x.randompick == 17 then
							x.ewarrior[index][index2] = BuildObject("nvmisl", 5, x.efactory)
							if x.ewarwave[index] == 3 or x.ewarwave[index] == 5 then
								GiveWeapon(x.ewarrior[index][index2], "gfafma_c")
							end
						elseif x.randompick == 4 or x.randompick == 11 or x.randompick == 18 then
							x.ewarrior[index][index2] = BuildObject("nvtank", 5, x.efactory)
							if x.ewarwave[index] == 4 or x.ewarwave[index] == 5 then
								GiveWeapon(x.ewarrior[index][index2], "gstbsa_c")
							end
						elseif x.randompick == 5 or x.randompick == 12 then
							x.ewarrior[index][index2] = BuildObject("nvrckt", 5, x.efactory)
							if x.ewarwave[index] == 3 or x.ewarwave[index] == 5 then
								GiveWeapon(x.ewarrior[index][index2], "gshdwa_a") --salvo rckt
							end
						elseif x.randompick == 6 or x.randompick == 13 then
							if x.ewarwave[index] == 1 or x.ewarwave[index] == 2 then
								x.ewarrior[index][index2] = BuildObject("nvtank", 5, x.efactory)
							else --too x.hard if comes in very first or second wave
								x.ewarrior[index][index2] = BuildObject("nvwalk", 5, x.efactory)
							while x.weappick == x.weaplast do --random the random
								x.weappick = math.floor(GetRandomFloat(1.0, 12.0))
							end
							x.weaplast = x.weappick
							if x.weappick == 1 or x.weappick == 5 or x.weappick == 9 then
								GiveWeapon(x.ewarrior[index][index2], "gblsta_a")
							elseif x.weappick == 2 or x.weappick == 6 or x.weappick == 10 then
								GiveWeapon(x.ewarrior[index][index2], "gflsha_a")
							elseif x.weappick == 3 or x.weappick == 7 or x.weappick == 11 then
								GiveWeapon(x.ewarrior[index][index2], "gstbva_a")
							else
								GiveWeapon(x.ewarrior[index][index2], "gstbta_a")
							end
							end
						else
							if x.ewarwave[index] == 1 or x.ewarwave[index] == 2 then
								x.ewarrior[index][index2] = BuildObject("nvtank", 5, x.efactory)
							else --too x.hard if comes in very first or second wave
								x.ewarrior[index][index2] = BuildObject("nvstnk", 5, x.efactory)
								while x.weappick == x.weaplast do --random the random
									x.weappick = math.floor(GetRandomFloat(1.0, 12.0))
								end
								x.weaplast = x.weappick
								if x.weappick == 1 or x.weappick == 5 or x.weappick == 9 then
									GiveWeapon(x.ewarrior[index][index2], "gblsta_c")
								elseif x.weappick == 2 or x.weappick == 6 or x.weappick == 10 then
									GiveWeapon(x.ewarrior[index][index2], "gflsha_c")
								elseif x.weappick == 3 or x.weappick == 7 or x.weappick == 11 then
									GiveWeapon(x.ewarrior[index][index2], "gstbva_c")
								else
									GiveWeapon(x.ewarrior[index][index2], "gstbta_c")
								end
							end
						end
						SetSkill(x.ewarrior[index][index2], x.skillsetting)
						if index2 % 3 == 0 then
							SetSkill(x.ewarrior[index][index2], x.skillsetting+1)
            else
              SetSkill(x.ewarrior[index][index2], x.skillsetting)
						end
					end
					x.ewarabort[index] = GetTime() + 360.0 --here first in case stage goes wrong
					x.ewarstate[index] = x.ewarstate[index] + 1
				end
				
				--GIVE MARCHING ORDERS
				if x.ewarstate[index] == 3 then
					if x.ewarmeet[index] == 2 then
						x.ewarmeet[index] = 1
					else
						x.ewarmeet[index] = 2
					end
					for index2 = 1, x.ewarsize[index] do
						if IsAlive(x.ewarrior[index][index2]) then
							Goto(x.ewarrior[index][index2], ("stage%d"):format(x.ewarmeet[index]))
						end
					end
					x.ewarstate[index] = x.ewarstate[index] + 1
				end
				
				--A UNIT AT STAGE PT
				if x.ewarstate[index] == 4 then
					for index2 = 1, x.ewarsize[index] do
						if IsAlive(x.ewarrior[index][index2]) and GetDistance(x.ewarrior[index][index2], ("stage%d"):format(x.ewarmeet[index]), 4) < 100 and GetTeamNum(x.ewarrior[index][index2]) ~= 1 then
							x.ewarstate[index] = x.ewarstate[index] + 1
							break
						end
					end
				end
				
				--GIVE ATTACK ORDER
				if x.ewarstate[index] == 5 then
					for index2 = 1, x.ewarsize[index] do
						if IsAlive(x.ewarrior[index][index2]) and GetTeamNum(x.ewarrior[index][index2]) ~= 1 then
							if index == 1 then
								if IsAlive(x.frcy) then
									x.ewartrgt[index] = x.frcy
								elseif IsAlive(x.ffac) then
									x.ewartrgt[index] = x.ffac
								elseif IsAlive(x.farm) then
									x.ewartrgt[index] = x.farm
								else
									x.ewartrgt[index] = x.player
								end
							elseif index == 2 then
								if IsAlive(x.ffac) then
									x.ewartrgt[index] = x.ffac
								elseif IsAlive(x.farm) then
									x.ewartrgt[index] = x.farm
								elseif IsAlive(x.frcy) then
									x.ewartrgt[index] = x.frcy
								else
									x.ewartrgt[index] = x.player
								end
							elseif index == 3 then
								if IsAlive(x.farm) then
									x.ewartrgt[index] = x.farm
								elseif IsAlive(x.ffac) then
									x.ewartrgt[index] = x.ffac
								elseif IsAlive(x.frcy) then
									x.ewartrgt[index] = x.frcy
								else
									x.ewartrgt[index] = x.player
								end
							elseif index == 4 then
								if IsAlive(x.fpad) then
									x.ewartrgt[index] = x.fpad --SPECIAL FOR THIS MISSION
								elseif IsAlive(x.fsld) then
									x.ewartrgt[index] = x.fsld
								elseif IsAlive(x.fhqr) then
									x.ewartrgt[index] = x.fhqr
								elseif IsAlive(x.ftec) then
									x.ewartrgt[index] = x.ftec
								elseif IsAlive(x.ftrn) then
									x.ewartrgt[index] = x.ftrn
								elseif IsAlive(x.fbay) then
									x.ewartrgt[index] = x.fbay
								elseif IsAlive(x.fcom) then
									x.ewartrgt[index] = x.fcom
								elseif IsAlive(x.fpwr[4]) then
									x.ewartrgt[index] = x.fpwr[4]
								elseif IsAlive(x.fpwr[3]) then
									x.ewartrgt[index] = x.fpwr[3]
								elseif IsAlive(x.fpwr[2]) then
									x.ewartrgt[index] = x.fpwr[2]
								elseif IsAlive(x.fpwr[1]) then
									x.ewartrgt[index] = x.fpwr[1]
								elseif IsAlive(x.farm) then
									x.ewartrgt[index] = x.farm
								elseif IsAlive(x.ffac) then
									x.ewartrgt[index] = x.ffac
								elseif IsAlive(x.frcy) then
									x.ewartrgt[index] = x.frcy
								else
									x.ewartrgt[index] = x.player
								end
							else --safety call --shouldn't ever run
								x.ewartrgt[index] = x.player
							end
							Attack(x.ewarrior[index][index2], x.ewartrgt[index])
							x.ewarabort[index] = x.ewartime[index] + 420.0
						end
					end
					x.ewarstate[index] = x.ewarstate[index] + 1
				end
				
				--CHECK CASUALTY AND RESET
				if x.ewarstate[index] == 6 then
					for index2 = 1, x.ewarsize[index] do
						if not IsAlive(x.ewarrior[index][index2]) or (IsAlive(x.ewarrior[index][index2]) and GetTeamNum(x.ewarrior[index][index2]) == 1) then
							x.casualty = x.casualty + 1
						end
					end
					if x.casualty >= math.floor(x.ewarsize[index] * 0.8) then
						x.ewarabort[index] = 99999.9
						x.ewartime[index] = GetTime() + x.ewartimecool[index] + x.ewartimeadd[index]
						if x.ewarwave[index] == 5 then --extra time after last wave to "ease up"
							x.ewartime[index] = GetTime() + x.ewartimecool[index] + x.ewartimeadd[index] + 120.0
						end
						x.ewarstate[index] = 1 --RESET
					end
					x.casualty = 0
					if not IsAlive(x.ewartrgt[index]) then --if orig target gone, then find new one
						if IsAlive(x.frcy) then
							x.ewartrgt[index] = x.frcy
						elseif IsAlive(x.ffac) then
							x.ewartrgt[index] = x.ffac
						elseif IsAlive(x.farm) then
							x.ewartrgt[index] = x.farm
						else
							x.ewartrgt[index] = x.player
						end
						for index2 = 1, x.ewarsize[index] do
							if IsAlive(x.ewarrior[index][index2]) and GetTeamNum(x.ewarrior[index][index2]) ~= 1 then
								Attack(x.ewarrior[index][index2], x.ewartrgt[index])
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
			end
		end
	end--WARCODE END

	--CHECK STATUS OF MCA 
	if not x.MCAcheck then	 
		if x.failstate == 0 and not IsAlive(x.frcy) then --Recycler Destroyed
			x.audio6 = AudioMessage("tcbd1011.wav") --FAIL - lost recy (100 million lost)
			ClearObjectives()
			AddObjective("Recycler destroyed.\n\nMISSION FAILED!", "RED")
			x.spine = 666
			x.failstate = 1
		elseif x.failstate == 1 and IsAudioMessageDone(x.audio6) then
			TCC.FailMission(GetTime() + 1.0, "tcbd10f1.des") --LOSER LOSER LOSER
			x.MCAcheck = true
		end

		if x.failstate == 0 and ((x.fpadexists and not IsAlive(x.fpad)) or (x.fcneexists and not IsAlive(x.fcne))) then --Launcpad or rocket destroyed
			if IsAlive(x.fcne) then
				Damage(x.fcne, (GetMaxHealth(x.fcne)+10))
			end
			if IsAlive(x.fpad) then
				Damage(x.fpad, (GetMaxHealth(x.fpad)+10))
			end
			ClearObjectives()
			AddObjective("Launchpad destroyed.\n\nMISSION FAILED!", "RED")
			x.audio6 = AudioMessage("tcbd1012.wav")
			x.spine = 666
			x.failstate = 2
		elseif x.failstate == 2 and IsAudioMessageDone(x.audio6) then
			TCC.FailMission(GetTime() + 1.0, "tcbd10f2.des") --LOSER LOSER LOSER
			x.MCAcheck = true
		end

		if x.failstate == 0 and x.fapcexists and (not IsAlive(x.fapc[1]) or not IsAlive(x.fapc[2]) or not IsAlive(x.fapc[3])) then --APC destroyed
			x.audio6 = AudioMessage("tcbd1013.wav")
			ClearObjectives()
			AddObjective("APC destroyed\n\nMISSION FAILED!", "RED")
			x.spine = 666
			x.failstate = 3
		elseif x.failstate == 3 and IsAudioMessageDone(x.audio6) then
			TCC.FailMission(GetTime() + 1.0, "tcbd10f3.des") --LOSER LOSER LOSER
			x.MCAcheck = true
		end
	end--]]
end
--[[END OF SCRIPT]]