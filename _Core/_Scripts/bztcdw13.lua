--bztcdw13 - Battlezone Total Command - Dogs of War - 13/15 FRUSTRATE THEIR KNAVISH TRICKS
assert(load(assert(LoadFile("_requirefix.lua")),"_requirefix.lua"))();
TCC = require("TC_Core")
MisnNum = 48;
local index = 0
local index2 = 0
local indexadd = 0
local x = {
	FIRST = true, 
	MisnNum = 48,
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
	audio6 = nil, 
	camfov = 60,  --185 default
	userfov = 90,  --seed
	fnav = {},	
	randompick = 0, 
	randomlast = 0,
	casualty = 0, 
	bigtime = 99999.9, 
	fgrp = {}, 
	fscv = {}, 
	fcon = {},	 --silo stuff
	fsilall = false, 
	fsildistance = 50, 
	fsilcontrol = 0, 
	fsil = {}, 
	fsilstate = {0,0,0,0,0,0}, 
	fsilinittime = {99999.9, 99999.9, 99999.9, 99999.9, 99999.9, 99999.9}, 
	fsiltime = {99999.9, 99999.9, 99999.9, 99999.9, 99999.9, 99999.9}, 
	fsilcon = {nil, nil, nil, nil, nil, nil},	
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
	ewlk = {}, 
	ercy = nil, 
	efac = nil, 
	earm = nil, 
	etec = nil, 
	ehqr = nil, 
	easn = {}, --assassin 
	easntime = {99999.9, 99999.9, 99999.9, 99999.9, 99999.9, 99999.9}, 
	escv = {}, 
	eatk = {}, --init silo guard
	eturtime = 99999.9, --eturret
	eturlife = {}, 
	eturlength = 16,
	etur = {}, 
	eturcool = {}, 
	eturallow = {}, 
	etursecs = {}, 
	epattime = 99999.9, --epatrols
	epatlength = 8, 
	epat = {}, 
	epatcool = {}, 
	epatallow = {},	
	epatsecs = {}, 
	wreckstate = 0, --daywrecker
	wrecktime = 99999.9, 
	wrecktrgt = {},
	wreckbomb = nil, 
	wreckname = "apdwrkk", 
	wreckbank = false, 
	wrecknotify = 0, 
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
	ewarsizeadd = {}, 
	ewarwave = {}, 
	ewarwavemax = {}, 
	ewarwavereset = {}, 
	ewarmeet = {}, 
	ewarriortime = {},
	ewarriorplan = {}, 
	ewartrgt = {}, 
	ewarpos = {}, 
	LAST = true
}
--PATHS: pcam1, fpnav1-8, eptur(0-16), epatk(0-12), eprcy, epgrcy, epfac, epgfac, stage1-2, pscrap1-7(0-25), epasn1-6, ppatrol1-4

function InitialSetup()
	SetAutoGroupUnits(true)
		
	local odfpreload = {
		"bvrecy0", "bvmbike", "bvtank", "bvcons0", "bvturr", "bvscav", "npscrx", 
		"kvscout", "kvtank", "kvmisl", "kvhtnk", "kvturr", "kvscav", "kbsilodw13", "apcamrb", x.wreckname,
	}
	for k,v in pairs(odfpreload) do
		PreloadODF(v)
	end
	
	x.ercy = GetHandle("ercy")
	x.efac = GetHandle("efac")
	x.earm = GetHandle("earm")
	x.etec = GetHandle("etec")
	x.ehqr = GetHandle("ehqr")
	x.frcy = GetHandle("frcy")
	x.mytank = GetHandle("mytank")
	for index = 1, 16 do
		x.fgrp[index] = GetHandle(("fgrp%d"):format(index))
	end
	for index = 1, 6 do
		x.fsil[index] = GetHandle(("fsil%d"):format(index))
	end
	for index = 1, 4 do
		x.ewlk[index] = GetHandle(("ewlk%d"):format(index))
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

local replaced = false;
function AddObject(h)
	if (replaced) then 	replaced = false;	return; 	end;

	if (not IsAlive(x.farm) or x.farm == nil) and IsType(h, "bbarmo") then
		h, replaced = RepObject(h);
		x.farm = h;
	elseif (not IsAlive(x.ffac) or x.ffac == nil) and IsType(h, "bbfact") then
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
	elseif IsAlive(h) or IsPlayer(h) then
		ReplaceStabber(h);
	end
	
	--new constructor
	for indexadd = 1, 30 do
		if IsOdf(h, "bvcons0:1") and (not IsAlive(x.fcon[indexadd]) or x.fcon[indexadd] == nil) then
			x.fcon[indexadd] = h
			break
		end
	end
	
	--get daywrecker for highlight
	if (not IsAlive(x.wreckbomb) or x.wreckbomb == nil) and IsOdf(h, x.wreckname) then 
		if GetTeamNum(h) == 5 then
			x.wreckbomb = h --get handle to launched daywrecker
		end
	end
	
	for indexadd = 1, x.fartlength do --new artillery? 
		if (not IsAlive(x.fart[indexadd]) or x.fart[indexadd] == nil) and IsOdf(h, "bvartl:1") then
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

function PreDamage(curWorld, h, DamageType, pContext, value, base, armor, shield, owner, source, SelfDamage, FriendlyFireDamage)
	return TCC.PreDamage(curWorld, h, DamageType, pContext, value, base, armor, shield, owner, source, SelfDamage, FriendlyFireDamage);
end

function Update()
	x.player = GetPlayerHandle() --EVERY PASS SO IF PLAYER CHANGES VEHICLES
	x.skillsetting = IFace_GetInteger("options.play.difficulty")
	TCC.Update();
	--START THE MISSION BASICS
	if x.spine == 0 then
		for index = 1, x.eturlength do 
			x.etur[index] = BuildObject("kvturr", 5, ("eptur%d"):format(index))
			SetSkill(x.etur[index], x.skillsetting)
		end
		for index = 1, 12 do
			x.escv[index] = BuildObject("kvscav", 5, "epscv", index)
			SetCommand(x.escv[index], 20)
			x.eatk[index] = BuildObject("kvtank", 5, "epatk", index)
			SetSkill(x.eatk[index], x.skillsetting)
			Defend2(x.eatk[index], x.escv[index])
		end
		SetGroup(x.frcy, 1)
		for index = 1, 5 do
			x.fgrp[index] = GetHandle(("fgrp%d"):format(index))
			x.pos = GetTransform(x.fgrp[index])
			RemoveObject(x.fgrp[index])
			x.fgrp[index] = BuildObject("bvmbike", 1, x.pos)
			SetGroup(x.fgrp[index], 0)
			SetSkill(x.fgrp[index], 3)
		end
		for index = 6, 10 do
			x.fgrp[index] = GetHandle(("fgrp%d"):format(index))
			x.pos = GetTransform(x.fgrp[index])
			RemoveObject(x.fgrp[index])
			x.fgrp[index] = BuildObject("bvtank", 1, x.pos)
			SetGroup(x.fgrp[index], 0)
			SetSkill(x.fgrp[index], 3)
		end
		if x.skillsetting == x.easy then
			RemoveObject(x.fgrp[5])
			RemoveObject(x.fgrp[10])
		end
		if x.skillsetting <= x.medium then
			RemoveObject(x.fgrp[4])
			RemoveObject(x.fgrp[9])
		end
		for index = 11, 12 do
			x.fgrp[index] = GetHandle(("fgrp%d"):format(index))
			x.pos = GetTransform(x.fgrp[index])
			RemoveObject(x.fgrp[index])
			x.fgrp[index] = BuildObject("bvturr", 1, x.pos)
			SetGroup(x.fgrp[index], 5)
			SetSkill(x.fgrp[index], 3)
		end
		for index = 13, 14 do
			x.fcon[index] = GetHandle(("fgrp%d"):format(index))
			x.pos = GetTransform(x.fcon[index])
			RemoveObject(x.fcon[index])
			x.fcon[index] = BuildObject("bvcons0", 1, x.pos)
			SetGroup(x.fcon[13], 8)
			SetGroup(x.fcon[14], 9)
		end
		for index = 15, 16 do
			x.fscv[index] = GetHandle(("fgrp%d"):format(index))
			x.pos = GetTransform(x.fscv[index])
			RemoveObject(x.fscv[index])
			x.fscv[index] = BuildObject("bvscav", 1, x.pos)
			SetGroup(x.fcon[15], 6)
			SetGroup(x.fcon[16], 7)
		end
		x.mytank = GetHandle("mytank")
		x.pos = GetTransform(x.mytank)
		RemoveObject(x.mytank)
		x.mytank = BuildObject("bvtank", 1, x.pos)
		GiveWeapon(x.mytank, "gpopg1a")
		SetAsUser(x.mytank, 1)
		RemoveObject(x.player)
		x.player = GetPlayerHandle()
		for index = 1, 25 do
			x.fnav[1] = BuildObject("npscrx", 0, "pscrap1", index)
			x.fnav[2] = BuildObject("npscrx", 0, "pscrap2", index)
			x.fnav[3] = BuildObject("npscrx", 0, "pscrap3", index)
			x.fnav[4] = BuildObject("npscrx", 0, "pscrap4", index)
			x.fnav[5] = BuildObject("npscrx", 0, "pscrap5", index)
			x.fnav[6] = BuildObject("npscrx", 0, "pscrap6", index)
			x.fnav[7] = BuildObject("npscrx", 0, "pscrap7", index)
		end
		x.audio1 = AudioMessage("tcdw1301.wav") --CRA collect scrap. Seize supply silos. Use Cons to deconstruct
		x.camstate = 1
    x.userfov = IFace_GetInteger("options.graphics.defaultfov")
    CameraReady()
    IFace_SetInteger("options.graphics.defaultfov", x.camfov)
		x.spine = x.spine + 1
	end
	
	--GIVE FIRST OBJECTIVE
	if x.spine == 1 and (IsAudioMessageDone(x.audio1) or CameraCancelled()) then
		x.camstate = 0
    CameraFinish()
    IFace_SetInteger("options.graphics.defaultfov", x.userfov)
		ClearObjectives()
		--AddObjective("tcdw1301.txt")
		AddObjective(("-Get a Heaval within %dm of each silo to begin capturing it.\n\n-Do NOT destroy uncaptured silos.\n\n-Avoid the CRA base until all 6 silos are captured."):format(x.fsildistance))
		x.fnav[1] = BuildObject("apcamrb", 1, "fpnav1")
		SetObjectiveName(x.fnav[1], "BDS Base")
		for index = 2, 7 do
			x.fnav[index] = BuildObject("apcamrb", 1, ("fpnav%d"):format(index))
			SetObjectiveName(x.fnav[index], ("Silo %d"):format(index-1))
		end
		x.fnav[8] = BuildObject("apcamrb", 1, "fpnav8")
		SetObjectiveName(x.fnav[8], "CRA Base")
		for index = 1, x.eturlength do --init tur
			x.eturtime = GetTime() + 180.0
			x.eturcool[index] = GetTime()
			x.eturallow[index] = false
			x.etursecs[index] = 0.0
			x.eturlife[index] = 0
		end
		for index = 1, x.epatlength do --init epat
			x.epat[index] = nil
			x.epattime = GetTime()
			x.epatcool[index] = GetTime()
			x.epatallow[index] = true
			x.epatsecs[index] = 0.0
		end
		SetScrap(1, 80)
		x.bigtime = GetTime() + 2701.0
		StartCockpitTimer(2700, 1350, 675)
		x.ewartotal = 4 --INIT WARCODE
		for index = 1, x.ewartotal do 
			x.randompick = 0
			x.randomlast = 0
			x.ewardeclare = true
			x.ewarrior[index] = {} --"rows"
			x.ewarriorplan[index] = {} --"rows"
			x.ewarriortime[index] = {} --"rows"
			x.ewartrgt[index] = {} --"rows"
			x.ewarpos[index] = {} --"rows"
			for index2 = 1, 10 do --n should be max number avail
				x.ewarrior[index][index2] = nil --"columns", init (handle in this case)
				x.ewarriorplan[index][index2] = 0
				x.ewarriortime[index][index2] = 99999.9
				x.ewartrgt[index][index2] = nil
				x.ewarpos[index][index2] = 0
			end
			x.ewarstate[index] = 1
			x.ewartime[1] = GetTime() + 180.0 --recy
			x.ewartime[2] = GetTime() + 210.0 --fact
			x.ewartime[3] = GetTime() + 240.0 --armo
			x.ewartime[4] = GetTime() + 270.0 --base
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
	
	--IF HAVE 6 SILOS THEN KILL CRA
	if x.spine == 2 and x.fsilall then
		StopCockpitTimer()
		HideCockpitTimer()
		AudioMessage("tcdw1302.wav") --You have control of all Chinese supply. Now finish them off.
		ClearObjectives()
		--AddObjective("tcdw1301.txt", "GREEN")
		AddObjective("All Silos captured.", "GREEN")
		AddObjective("	")
		AddObjective("tcdw1302.txt")
		for index = 1, 4 do
			SetSkill(x.ewlk[index], x.skillsetting)
		end
		x.wrecktime = GetTime() + 300.0
		for index = 1, x.ekillartlength do --init ekillart
			x.ekillarttime = GetTime()
			x.ekillart[index] = nil 
			x.ekillartcool[index] = 99999.9 
			x.ekillartallow[index] = false
		end
		x.spine = x.spine + 1
	end
	
	--MISSION SUCCESS
	if x.spine == 3 and not IsAlive(x.ercy) and not IsAlive(x.efac) then
		AudioMessage("tcdw1303.wav") --SUCCEED - Well done Lt. Skyeye shows another base for portal.
		ClearObjectives()
		AddObjective("tcdw1302.txt", "GREEN")
		AddObjective("\n\nMISSION COMPLETE", "GREEN")
		TCC.SucceedMission(GetTime() + 10.0, "tcdw13w.des") --WINNER WINNER WINNER
		x.MCAcheck = true
		x.spine = x.spine + 1
	end
	----------END MAIN SPINE ----------
	
	--CAMERA 1 ON PORTAL
	if x.camstate == 1 then
		CameraPath("pcam1", 3000, 3010, x.fsil[3]) --fsil3 in open area
	end
	
	--CAPTURE SILOS
	if not x.fsilall then
		for index = 1, 6 do
			x.fsildistance = 64
			if x.fsilstate[index] == 0 then
				for index2 = 1, 30 do
					if GetDistance(x.fcon[index2], x.fsil[index]) <= x.fsildistance then
						x.fsilcon[index] = x.fcon[index2]
						x.fsilinittime[index] = GetTime()
						x.fsiltime[index] = GetTime() + 60.0
						x.fsilstate[index] = 1
						break
					end
				end
			end
			--Show percentage captured
			if x.fsilstate[index] == 1 and IsAlive(x.fsil[index]) and x.fsiltime[index] > GetTime() and IsAlive(x.fsilcon[index]) then 
				SetObjectiveName(x.fsilcon[index], ("Silo %d capture: %d%%"):format(index, (((GetTime() - x.fsilinittime[index]) / (x.fsiltime[index] - x.fsilinittime[index])) * 100)))
				SetObjectiveOn(x.fsilcon[index])
			end
			--Stop Capture if con moves too far away
			if x.fsilstate[index] == 1 and IsAlive(x.fsil[index]) and (not IsAlive(x.fsilcon[index]) or (IsAlive(x.fsilcon[index]) and GetDistance(x.fsilcon[index], x.fsil[index]) > x.fsildistance)) then
				SetObjectiveName(x.fsilcon[index], "Heaval")
				SetObjectiveOff(x.fsilcon[index])
				x.fsilstate[index] = 0
				x.fsilcon[index] = nil
				x.fsiltime[index] = 99999.9
			end
			--silo captured
			if x.fsilstate[index] == 1 and IsAlive(x.fsil[index]) and x.fsiltime[index] < GetTime() and IsAlive(x.fsilcon[index]) then
				x.pos = GetTransform(x.fsil[index])
				RemoveObject(x.fsil[index])
				x.fsil[index] = BuildObject("kbsilodw13", 1, x.pos)
				SetObjectiveName(x.fsilcon[index], "Heaval")
				SetObjectiveOff(x.fsilcon[index])
				AudioMessage("win.wav")
				x.fsilcon[index] = nil
				SetScrap(1, GetMaxScrap(1)) --fill up - small incentive to keep all silo alive
				x.fsilstate[index] = 2
			end
			--count total captured
			if x.fsilstate[index] == 2 then
				x.casualty = x.casualty + 1
			end
			--build fsilcon assassin
			if x.fsilstate[index] == 1 and IsAround(x.fsilcon[index]) and not IsAlive(x.easn[index]) then
				x.easn[index] = BuildObject("kvtank", 5, "epasn", index)
				SetSkill(x.easn[index], x.skillsetting)
				x.easntime[index] = GetTime()
			end
			--assassin attack
			if x.fsilstate[index] == 1 and x.easntime[index] < GetTime() and IsAround(x.fsilcon[index]) and IsAlive(x.easn[index]) then
				Attack(x.easn[index], x.fsilcon[index])
				x.easntime[index] = GetTime() + 15.0
			end
			--assassin attack player
			if IsAlive(x.easn[index]) and GetTeamNum(x.easn[index]) ~= 1 and x.easntime[index] < GetTime() and ((x.fsilstate[index] == 1 and not IsAlive(x.fsilcon[index])) or (x.fsilstate[index] == 2 and IsAlive(x.easn[index]))) then
				Attack(x.easn[index], x.player)
				x.easntime[index] = GetTime() + 15.0
			end
		end
		--track for warcode attack add
		if x.casualty > x.fsilcontrol then	
			x.fsilcontrol = x.fsilcontrol + 1
		end
		--end capture segment
		if x.casualty == 6 then
			x.fsilall = true
		end
		x.casualty = 0
	end
	
	--AI GROUP TURRETS
	if x.eturtime < GetTime() and IsAlive(x.ercy) then
		for index = 1, x.eturlength do
			if not IsAlive(x.etur[index]) and not x.eturallow[index] and x.eturlife[index] < 2 then
				x.etursecs[index] = x.etursecs[index] + 60.0
				x.eturcool[index] = GetTime() + 240.0 + x.etursecs[index]
				x.eturallow[index] = true
			end
			if x.eturallow[index] and x.eturcool[index] < GetTime() then
				x.etur[index] = BuildObject("kvturr", 5, GetPositionNear("epgrcy", 0, 16, 32)) --grpspwn
				Goto(x.etur[index], ("eptur%d"):format(index))
				SetSkill(x.etur[index], x.skillsetting)
				SetObjectiveName(x.etur[index], ("Adder %d"):format(index))
				x.eturlife[index] = x.eturlife[index] + 1
				x.eturallow[index] = false
			end
		end
	end

	--AI GROUP PATROLS
	if x.epattime < GetTime() and IsAlive(x.efac) then
		for index = 1, x.epatlength do
			if (x.epat[index] == nil or not IsAlive(x.epat[index])) and not x.epatallow[index] then
				x.epatsecs[index] = x.epatsecs[index] + 60.0
				x.epatcool[index] = GetTime() + 240.0 + x.epatsecs[index]
				x.epatallow[index] = true
			end
			
			if x.epatallow[index] and x.epatcool[index] < GetTime() then				
				while x.randompick == x.randomlast do --random the random
					x.randompick = math.floor(GetRandomFloat(1.0, 15.0))
				end
				x.randomlast = x.randompick
				if x.randompick == 1 or x.randompick == 6 or x.randompick == 11 then
					x.epat[index] = BuildObject("kvscout", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
				elseif x.randompick == 2 or x.randompick == 7 or x.randompick == 12 then
					x.epat[index] = BuildObject("kvmbike", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
				elseif x.randompick == 3 or x.randompick == 8 or x.randompick == 13 then
					x.epat[index] = BuildObject("kvmisl", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
				elseif x.randompick == 4 or x.randompick == 9 or x.randompick == 14 then
					x.epat[index] = BuildObject("kvtank", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
				else
					x.epat[index] = BuildObject("kvhtnk", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
				end
				if index == 1 or index == 5 then
					Patrol(x.epat[index], "ppatrol1")
				elseif index == 2 or index == 6 then
					Patrol(x.epat[index], "ppatrol2")
				elseif index == 3 or index == 7 then
					Patrol(x.epat[index], "ppatrol3")
				elseif index == 4 or index == 8 then
					Patrol(x.epat[index], "ppatrol4")
				end
				SetSkill(x.epat[index], x.skillsetting)
				--SetObjectiveName(x.epat[index], ("Patrol %d"):format(index))
				x.epatallow[index] = false
			end
		end
		x.epattime = GetTime() + 30.0
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
			x.wrecktime = GetTime() + 540.0 --MORE TIME SINCE ARTIL ATTACK TOO
		elseif x.randompick == 2 or x.randompick == 5 or x.randompick == 8 then
			x.wrecktime = GetTime() + 420.0
		else
			x.wrecktime = GetTime() + 300.0
		end
		x.wreckstate = 0 --reset
	end
	
	--WARCODE W/ CLOAKING --SPECIAL DW13
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
						x.ewarsize[index] = 2 + x.ewarsizeadd[index]
					elseif x.ewarwave[index] == 2 then
						x.ewarsize[index] = 3 + x.ewarsizeadd[index]
					elseif x.ewarwave[index] == 3 then
						x.ewarsize[index] = 4 + x.ewarsizeadd[index]
					elseif x.ewarwave[index] == 4 then
						x.ewarsize[index] = 5 + x.ewarsizeadd[index]
					else --x.ewarwave[index] == 5 then
						x.ewarsize[index] = 6 + x.ewarsizeadd[index]
					end
					x.ewarstate[index] = x.ewarstate[index] + 1
				--BUILD FORCE
				elseif x.ewarstate[index] == 2 then
					for index2 = 1, x.ewarsize[index] do
						while x.randompick == x.randomlast do --random the random
							x.randompick = math.floor(GetRandomFloat(1.0, 15.0))
						end
						x.randomlast = x.randompick
						if not IsAlive(x.efac) then
							x.randompick = 1
						end
						if x.randompick == 1 or x.randompick == 6 or x.randompick == 11 then
							x.ewarrior[index][index2] = BuildObject("kvscout", 5, GetPositionNear("epgrcy", 0, 16, 32)) --grpspwn
							if x.ewarwave[index] == 3 or x.ewarwave[index] == 4 then
								GiveWeapon(x.ewarrior[index][index2], "gchana_c")
							end
						elseif x.randompick == 2 or x.randompick == 7 or x.randompick == 12 then
							x.ewarrior[index][index2] = BuildObject("kvmbike", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
							if x.ewarwave[index] == 2 or x.ewarwave[index] == 4 then
								GiveWeapon(x.ewarrior[index][index2], "gstbra_c")
							end
						elseif x.randompick == 3 or x.randompick == 8 or x.randompick == 13 then
							x.ewarrior[index][index2] = BuildObject("kvmisl", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
							if x.ewarwave[index] == 3 or x.ewarwave[index] == 5 then
								GiveWeapon(x.ewarrior[index][index2], "gfafma_c")
							end
						elseif x.randompick == 4 or x.randompick == 9 or x.randompick == 14 then
							x.ewarrior[index][index2] = BuildObject("kvtank", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
							if x.ewarwave[index] == 4 or x.ewarwave[index] == 5 then
								GiveWeapon(x.ewarrior[index][index2], "gstbsa_c")
							end
						else--x.randompick == 5 or x.randompick == 10 then
							x.ewarrior[index][index2] = BuildObject("kvrckt", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
							if x.ewarwave[index] == 3 or x.ewarwave[index] == 5 then
								GiveWeapon(x.ewarrior[index][index2], "gshdwa_a") --salvo rckt
							end
						end
						SetSkill(x.ewarrior[index][index2], x.skillsetting)
						if index2 % 3 == 0 then
							SetSkill(x.ewarrior[index][index2], x.skillsetting+1)
						end
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
							Retreat(x.ewarrior[index][index2], ("stage%d"):format(x.ewarmeet[index]))
						end
					end
					x.ewarstate[index] = x.ewarstate[index] + 1
				--A UNIT AT STAGE PT
				elseif x.ewarstate[index] == 4 then
					for index2 = 1, x.ewarsize[index] do
						if IsAlive(x.ewarrior[index][index2]) and GetDistance(x.ewarrior[index][index2], ("stage%d"):format(x.ewarmeet[index])) < 100 then
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
						--SENT TO TARGET POSITION
						if x.ewarriorplan[index][index2] == 1 and IsAlive(x.ewarrior[index][index2]) and x.ewarriortime[index][index2] < GetTime() then
							Retreat(x.ewarrior[index][index2], x.ewarpos[index][index2])
              if IsOdf(x.ewarrior[index][index2], "kvwalk:5") then
                Goto(x.ewarrior[index][index2], x.ewarpos[index][index2])
              end
							x.ewarriorplan[index][index2] = x.ewarriorplan[index][index2] + 1
						end
						--CHECK TARGET STATUS, LOCATION, AND DECLOAK
						if x.ewarriorplan[index][index2] == 2 and IsAlive(x.ewarrior[index][index2]) and GetDistance(x.ewarrior[index][index2], x.ewarpos[index][index2]) < 130 then
              Attack(x.ewarrior[index][index2], x.ewartrgt[index][index2])
							SetCommand(x.ewarrior[index][index2], 48)
							x.ewarriortime[index][index2] = GetTime() + 1.0
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
					if x.casualty >= math.floor(x.ewarsize[index] * 0.8) then
						x.ewarabort[index] = 99999.9
						x.ewartime[index] = GetTime() + x.ewartimecool[index] + x.ewartimeadd[index]
						if x.ewarwave[index] == 5 then --extra 120s after max wave to "ease up"
							x.ewartime[index] = GetTime() + x.ewartimecool[index] + x.ewartimeadd[index] + 120.0
						end
						if not x.fsilall then
							if x.fsilcontrol == 2 then
								x.ewarsizeadd[index] = 2
							elseif x.fsilcontrol == 4 then
								x.ewarsizeadd[index] = 3
							elseif x.fsilcontrol == 6 then
								x.ewarsizeadd[index] = 4
							end
						end
						x.ewarstate[index] = 1 --RESET
						x.ewarabortset[index] = false
						
						for index2 = 1, x.ewarsize[index] do
							SetCommand(x.ewarrior[index][index2], 48)
						end 
					end
					x.casualty = 0
					
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
							if IsAlive(x.ewarrior[index][index2]) and GetTeamNum(x.ewarrior[index][index2]) ~= 1 then
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
	
	--REBUILD AI FACTORY	
	if x.efacstate == 0 and not IsAlive(x.efac) and IsAlive(x.ercy) then
		x.efactime = GetTime() + 120.0
		x.efacstate = 1
	elseif x.efacstate == 1 and x.efactime < GetTime() then
		x.efac = BuildObject("kvfact", 5, GetPositionNear("epgrcy", 0, 16, 32)) --grpspwn
		Goto(x.efac, "epgfac") --goto fac group
		x.efacstate = 2
	elseif x.efacstate == 2 and IsAlive(x.efac) and GetDistance(x.efac, "epgfac") < 20 then
		Dropoff(x.efac, "epfac", 0) --Deploy(x.efac, "epfac")
		x.efacstate = 0
	elseif x.efacstate == 2 and not IsAlive(x.efac) then
		x.efacstate = 0
	end
	
	--AI ARTILLERY ASSASSIN
	if x.ekillarttime < GetTime() and IsAlive(x.efac) then
		for index = 1, x.ekillartlength do
			if (not IsAlive(x.ekillart[index]) or (IsAlive(x.ekillart[index]) and GetTeamNum(x.ekillart[index]) == 1)) and not x.ekillartallow[index] then
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
		--Times up
		if not x.fsilall and x.bigtime < GetTime() then
			AudioMessage("tcdw1305.wav") --FAIL - they started new portal. Retreat, will nuke from orbit
			ClearObjectives()
			AddObjective("You're too late, the CRA has started a new portal.\n\nMISSION FAILED!", "RED")
			TCC.FailMission(GetTime() + 15.0, "tcdw13f1.des") --LOSER LOSER LOSER
			x.MCAcheck = true
			x.spine = 666
		end
		
		--Recycler Destroyed
		if not IsAlive(x.frcy) then
			AudioMessage("tcdw1304.wav") --FAIL - lost recy (100 million lost)
			ClearObjectives()
			AddObjective("Recycler destroyed.\n\nMISSION FAILED!", "RED")
			TCC.FailMission(GetTime() + 17.0, "tcdw13f2.des") --LOSER LOSER LOSER
			x.MCAcheck = true
			x.spine = 666
		end
		
		--Silo Destroyed
		if not x.fsilall then
			for index = 1, 6 do
				if x.fsilstate[index] < 2 and not IsAlive(x.fsil[index]) then
					AudioMessage("tcdw1306.wav") --FAIL - lost a silo
					ClearObjectives()
					AddObjective("A silo was destroyed before being captured.\n\nMISSION FAILED!", "RED")
					TCC.FailMission(GetTime() + 15.0, "tcdw13f3.des")
					x.spine = 666
					x.MCAcheck = true
					break
				end
			end
		end
		
		--Attack CRA base too soon
		if not x.fsilall and IsAlive(GetNearestEnemy(x.ercy, 1, 1, 450)) then
			AudioMessage("tcdw1307.wav") --FAIL - attack CRA base before silo
			ClearObjectives()
			AddObjective("Too close to CRA base too soon.\n\nMISSION FAILED!", "RED")
			TCC.FailMission(GetTime() + 12.0, "tcdw13f4.des")
			x.spine = 666
			x.MCAcheck = true
		end
	end
end
--[[END OF SCRIPT]]