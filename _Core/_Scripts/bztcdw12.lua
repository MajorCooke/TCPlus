--bztcdw12 - Battlezone Total Command - Dogs of War - 12/15 - MEANWHILE, BACK AT THE RANCH ...
assert(load(assert(LoadFile("_requirefix.lua")),"_requirefix.lua"))();
TCC = require("TC_Core")
MisnNum = 47;
local index = 0
local index2 = 0
local x = {
	FIRST = true, 	
	MisnNum = 47,
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
	randompick = 0, 
	randomlast = 0,
	casualty = 0, 
	fgrp = {}, 
	fgrpgroup = 0, 
	fprt = nil, 
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
	fstwr = {},
	fstwrstate = {0,0,0,0}, 
	ercy = nil, 
	efac = nil, 
	earm = nil, 
	ecom = nil, 
	ebay = nil, 
	etrn = nil, 
	etec = nil, 
	ehqr = nil, 
	esld = nil, 
	eatk = {}, --shield attack
	eatkpt = 0, 
	eatkdeclare = false,
	eturtime = 99999.9, --eturret
	eturlength = 4,
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
	fartlength = 100, --fart killers
	fart = {}, 
	ekillarttime = 99999.9,
	ekillartlength = 4, 
	ekillart = {}, 
	ekillartcool = {}, 
	ekillartallow = {}, 
	ekillarttarget = nil, 
	ekillartmarch = false, 
	escv = {}, --scav stuff
	escvlength = 2, 
	wreckbank = false, --have 2
	escvbuildtime = {}, 
	escvstate = {}, 
	--no daywrecker this mission
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
--PATHS: pcam1, eptur1-4, epatk(0-4), fprcy, epgrcy, epfac, epgfac, stage1-2, pscrap(0-75), ppatrol1-4

function InitialSetup()
	SetAutoGroupUnits(true)
		
	local odfpreload = {
		"kvscout", "kvmbike", "kvmisl", "kvtank", "kvrckt", "kvhtnk", "kvwalk", "kvturr",
		"bvrecy0", "bvscout", "bvtank", "bvhtnk", "bvstnk", "npscrx", "apcamrb" 
	}
	for k,v in pairs(odfpreload) do
		PreloadODF(v)
	end
	
	x.ercy = GetHandle("ercy")
	x.efac = GetHandle("efac")
	x.earm = GetHandle("earm")
	x.ecom = GetHandle("ecom")
	x.ebay = GetHandle("ebay")
	x.etrn = GetHandle("etrn")
	x.etec = GetHandle("etec")
	x.ehqr = GetHandle("ehqr")
	x.esld = GetHandle("esld")
	for index = 1, 4 do
		x.fstwr[index] = GetHandle(("fsld%d"):format(index))
	end
	x.fprt = GetHandle("fprt")
	x.fbay = GetHandle("fbay")
	x.farm = GetHandle("farm")
	x.mytank = GetHandle("mytank")
	for index = 1, 20 do
		x.fgrp[index] = GetHandle(("fgrp%d"):format(index))
	end
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
	--SPECIAL THIS MISSION USE PORTAL INSTEAD OF SHIELD 
	if (not IsAlive(x.farm) or x.farm == nil) and IsOdf(h, "bvarmo:1") or IsOdf(h, "bbarmo") then
		x.farm = RepObject(h,TCC.MissionNumber());
		h = x.farm;
	elseif (not IsAlive(x.ffac) or x.ffac == nil) and IsOdf(h, "bvfact:1") or IsOdf(h, "bbfact") then
		x.ffac = h
	elseif (not IsAlive(x.fprt) or x.fprt == nil) and IsOdf(h, "bbshld") then
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
	elseif IsOdf(h, "bbpgen2") then
		for indexadd = 1, 4 do
			if x.fpwr[indexadd] == nil or not IsAlive(x.fpwr[indexadd]) then
				x.fpwr[indexadd] = h
				break
			end
		end
	elseif (IsAlive(h) or IsPlayer(h)) then
		ReplaceStabber(h);
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
		x.dummypos2 = GetTransform(h)
		x.gotdummy2 = true
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
		StopEmitter(x.fprt, 1)
		for index = 1, 4 do
			SetObjectiveOn(x.fstwr[index])
		end
		SetObjectiveOn(x.fprt)
		for index = 1, 5 do 
			x.fgrp[index] = GetHandle(("fgrp%d"):format(index))
			x.pos = GetTransform(x.fgrp[index])
			RemoveObject(x.fgrp[index])
			x.fgrp[index] = BuildObject("bvtank", 1, x.pos)
			SetGroup(x.fgrp[index], x.fgrpgroup)
			SetSkill(x.fgrp[index], 2)
			x.fgrp[index+5] = GetHandle(("fgrp%d"):format(index+5))
			x.pos = GetTransform(x.fgrp[index+5])
			RemoveObject(x.fgrp[index+5])
			x.fgrp[index+5] = BuildObject("bvmisl", 1, x.pos)
			SetGroup(x.fgrp[index+5], x.fgrpgroup)
			SetSkill(x.fgrp[index+5], 2)
			x.fgrp[index+10] = GetHandle(("fgrp%d"):format(index+10))
			x.pos = GetTransform(x.fgrp[index+10])
			RemoveObject(x.fgrp[index+10])
			x.fgrp[index+10] = BuildObject("bvstnk", 1, x.pos)
			SetGroup(x.fgrp[index+10], x.fgrpgroup)
			SetSkill(x.fgrp[index+10], 2)
			x.fgrp[index+15] = GetHandle(("fgrp%d"):format(index+15))
			x.pos = GetTransform(x.fgrp[index+15])
			RemoveObject(x.fgrp[index+15])
			x.fgrp[index+15] = BuildObject("bvrckt", 1, x.pos)
			SetGroup(x.fgrp[index+15], x.fgrpgroup)
			SetSkill(x.fgrp[index+15], 2)
			x.fgrpgroup = x.fgrpgroup + 1
		end
		x.mytank = GetHandle("mytank")
		x.pos = GetTransform(x.mytank)
		RemoveObject(x.mytank)
		x.mytank = BuildObject("bvtank", 1, x.pos)
		GiveWeapon(x.mytank, "gpopg1a")
		SetAsUser(x.mytank, 1)
		RemoveObject(x.player)
		x.player = GetPlayerHandle()
		if x.skillsetting <= x.medium then --keep some challenge
			RemoveObject(x.fgrp[4])
			RemoveObject(x.fgrp[8])
			RemoveObject(x.fgrp[12])
			RemoveObject(x.fgrp[16])
			RemoveObject(x.fgrp[20])
		end
		if x.skillsetting == x.easy then --keep some challenge
			RemoveObject(x.fgrp[3])
			RemoveObject(x.fgrp[7])
			RemoveObject(x.fgrp[11])
			RemoveObject(x.fgrp[15])
			RemoveObject(x.fgrp[19])
		end
		for index = 1, 75 do
			x.fnav[1] = BuildObject("npscrx", 0, "pscrap", index)
		end
		x.ewartotal = 1 --init SHIELD ATTACK WARCODE
		for index = 1, x.ewartotal do
			x.eatkdeclare = true --<<<<<<
			x.ewarrior[index] = {} --"rows"
			x.ewarriorplan[index] = {} --"rows"
			x.ewarriortime[index] = {} --"rows"
			x.ewartrgt[index] = {} --"rows"
			for index2 = 1, 16 do
				x.ewarrior[index][index2] = nil --"columns", init (handle in this case)
				x.ewarriorplan[index][index2] = 0
				x.ewarriortime[index][index2] = 99999.9
				x.ewartrgt[index][index2] = nil
			end
			x.ewarstate[index] = 1
			x.ewartime[1] = GetTime() + 30.0 --just one group
			x.ewartimecool[index] = 40.0
			x.ewartimeadd[index] = 0.0
			x.ewarabortset[index] = false
			x.ewarabort[index] = 99999.9
			x.ewarsize[index] = 0
			x.ewarwave[index] = 0
			x.ewarwavemax[index] = 5
			x.ewarwavereset[index] = 2
			x.ewarmeet[index] = 2
		end
		x.audio1 = AudioMessage("tcdw1201.wav") --Sgt, have to get Bdogs and Harris back. Shld up. Protect men.
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
		AddObjective("tcdw1201.txt")
		x.fnav[1] = BuildObject("apcamrb", 1, "fpnav1")
		SetObjectiveName(x.fnav[1], "Repair and Supply")
		x.fnav[2] = BuildObject("apcamrb", 1, "fpnav2")
		SetObjectiveName(x.fnav[2], "Defend Portal")
		x.eatkstate = 1
		for index = 1, x.eturlength do --init tur
			x.eturtime = GetTime() + 180.0
			x.eturcool[index] = GetTime()
			x.eturallow[index] = true
			x.etursecs[index] = 0.0
		end
		for index = 1, x.epatlength do --init epat
			x.epattime = GetTime()
			x.epatcool[index] = GetTime()
			x.epatallow[index] = true
			x.epatsecs[index] = 0.0
		end
		x.spine = x.spine + 1
	end
	
	--RECYCLER TO PLAYER
	if x.spine == 2 and x.frcystate == 1 and x.waittime < GetTime() then
		AudioMessage("portalx.wav")
		AudioMessage("tcdw1202.wav") --Oh yeah, back home to roost. Now where are those commie bastards.
		ClearObjectives()
		AddObjective("tcdw1201.txt", "GREEN")
		AddObjective("	")
		AddObjective("tcdw1202.txt")
		x.frcy = BuildObject("bvrecy0", 1, x.dummypos)
		SetVelocity(x.frcy, (SetVector(50.0, 0.0, 0.0)))
		Goto(x.frcy, "fprcy", 0)
		SetScrap(1, 40)
		x.frcystate = 2
		SetObjectiveOff(x.fstwr[1])
		SetObjectiveOff(x.fstwr[2])
		SetObjectiveOff(x.fstwr[3])
		SetObjectiveOff(x.fstwr[4])
		SetObjectiveOff(x.fprt)
		x.eatkdeclare = false
		x.waittime = GetTime() + 60.0
		x.spine = x.spine + 1
	end
	
	--START UP MAIN WARCODE
	if x.spine == 3 and x.waittime < GetTime() then
		for index = 1, x.escvlength do --init escv
			x.escvbuildtime[index] = GetTime()
			x.escvstate[index] = 1
		end
		StopEmitter(x.fprt, 1)
		for index = 1, x.ekillartlength do --init ekillart
			x.ekillarttime = GetTime()
			x.ekillart[index] = nil 
			x.ekillartcool[index] = 99999.9 
			x.ekillartallow[index] = false
		end
		x.ewartotal = 4 --INIT WARCODE
		for index = 1, x.ewartotal do 
			x.randompick = 0
			x.randomlast = 0
			x.ewardeclare = true
			x.ewarrior[index] = {} --"rows"
			x.ewarriorplan[index] = {} --"rows"
			x.ewarriortime[index] = {} --"rows"
			x.ewartrgt[index] = {} --"rows"
			x.ewarpos[index] = {}
			for index2 = 1, 10 do
				x.ewarrior[index][index2] = nil --"columns", init (handle in this case)
				x.ewarriorplan[index][index2] = 0
				x.ewarriortime[index][index2] = 99999.9
				x.ewartrgt[index][index2] = nil
				x.ewarpos[index][index2] = 0
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
			x.ewarwave[index] = 0
			x.ewarwavemax[index] = 5
			x.ewarwavereset[index] = 2
			x.ewarmeet[index] = 2
		end
		x.spine = x.spine + 1
	end
	
	--MISSION SUCCESS
	if x.spine == 4 and not IsAlive(x.ercy) and not IsAlive(x.efac) and not IsAlive(x.earm) then
		AudioMessage("tcdw1203.wav") --SUCCEED - Good job Sgt. no doubt reward for combat under stress.
		ClearObjectives()
		AddObjective("tcdw1202.txt", "GREEN")
		AddObjective("\n\nMISSION COMPLETE", "GREEN")
		TCC.SucceedMission(GetTime() + 8.0, "tcdw12w.des") --WINNER WINNER WINNER
		x.MCAcheck = true
		x.spine = x.spine + 1
	end
	----------END MAIN SPINE ----------
	
	--CAMERA 1 ON PORTAL
	if x.camstate == 1 then
		CameraPath("pcam1", 3000, 3010, x.fprt)
	end
	
	--SHIELD HEALTH NOTIFICATION
	for index = 1, 4 do
		if x.fstwrstate[index] < 2 and not IsAlive(x.fstwr[index]) then
			x.fstwrstate[index] = 2
		end
		if x.fstwrstate[index] == 0 and IsAlive(x.fstwr[index]) and GetCurHealth(x.fstwr[index]) < math.floor(GetMaxHealth(x.fstwr[index]) * 0.25) then
			if index == 1 then
				AudioMessage("tcdw1205.wav") --CPU - SW shield integrity at 25%
			elseif index == 2 then
				AudioMessage("tcdw1206.wav") --CPU - NW shield integrity at 25%
			elseif index == 3 then
				AudioMessage("tcdw1207.wav") --CPU - NE shield integrity at 25%
			elseif index == 4 then
				AudioMessage("tcdw1208.wav") --CPU - SE shield integrity at 25%
			end
			x.fstwrstate[index] = 1
		end
		if x.fstwrstate[index] == 1 and IsAlive(x.fstwr[index]) and GetCurHealth(x.fstwr[index]) > math.floor(GetMaxHealth(x.fstwr[index]) * 0.5) then
			x.fstwrstate[index] = 0 --reset at 50% health
		end
	end
	
	--SHIELD HEALTH DISPLAY
	if IsAlive(x.fprt) then
		if IsAlive(x.fstwr[1]) then
			SetObjectiveName(x.fstwr[1], ("SW shld %d"):format(GetCurHealth(x.fstwr[1])/GetMaxHealth(x.fstwr[1]) * 100))
		end
		if IsAlive(x.fstwr[2]) then
			SetObjectiveName(x.fstwr[2], ("NW shld %d"):format(GetCurHealth(x.fstwr[2])/GetMaxHealth(x.fstwr[2]) * 100))
		end
		if IsAlive(x.fstwr[3]) then
			SetObjectiveName(x.fstwr[3], ("NE shld %d"):format(GetCurHealth(x.fstwr[3])/GetMaxHealth(x.fstwr[3]) * 100))
		end
		if IsAlive(x.fstwr[4]) then
			SetObjectiveName(x.fstwr[4], ("SE shld %d"):format(GetCurHealth(x.fstwr[4])/GetMaxHealth(x.fstwr[4]) * 100))
		end
		if IsAlive(x.fprt) then
			SetObjectiveName(x.fprt, ("Portal %d"):format(GetCurHealth(x.fprt)/GetMaxHealth(x.fprt) * 100))
		end
	end
	
	--SHIELD ATTACK WARCODE - NOT FOR REGULAR ATTACKS
	if x.eatkdeclare then
		if x.ewartime[1] < GetTime() then 
			--SET WAVE NUMBER
			if x.ewarstate[1] == 1 then	
				x.ewarwave[1] = x.ewarwave[1] + 1
				--SET WAVE SIZE
				if x.ewarwave[1] == 1 or x.ewarwave[1] == 2 then
					x.ewarsize[1] = 6
				elseif x.ewarwave[1] == 3 or x.ewarwave[1] == 4 then
					x.ewarsize[1] = 8
				elseif x.ewarwave[1] == 5 or x.ewarwave[1] == 6 then
					x.ewarsize[1] = 10
				end
				for index = 1, 8 do --pick spawn location
					while x.randompick == x.randomlast do --random the random
						x.randompick = math.floor(GetRandomFloat(1.0, 12.0))
					end
				end
				x.randomlast = x.randompick
				if x.randompick == 1 or x.randompick == 5 or x.randompick == 9 then
					x.eatkpt = 1
				elseif x.randompick == 2 or x.randompick == 6 or x.randompick == 10 then
					x.eatkpt = 2
				elseif x.randompick == 3 or x.randompick == 7 or x.randompick == 11 then
					x.eatkpt = 3
				else
					x.eatkpt = 4
				end
				x.ewarstate[1] = x.ewarstate[1] + 1
			--BUILD FORCE
			elseif x.ewarstate[1] == 2 then
				for index2 = 1, x.ewarsize[1] do
					while x.randompick == x.randomlast do --random the random
						x.randompick = math.floor(GetRandomFloat(1.0, 15.0))
					end
					x.randomlast = x.randompick
					if x.randompick == 1 or x.randompick == 7 or x.randompick == 12 then
						x.ewarrior[1][index2] = BuildObject("kvmbike", 5, "epatk", x.eatkpt)
						 if x.ewarwave[index] == 2 or x.ewarwave[index] == 4 then
							GiveWeapon(x.ewarrior[1][index2], "gstbva_c")
						end
					elseif x.randompick == 2 or x.randompick == 8 or x.randompick == 13 then
						x.ewarrior[1][index2] = BuildObject("kvmisl", 5, "epatk", x.eatkpt)
						if x.ewarwave[index] == 3 or x.ewarwave[index] == 5 then
							GiveWeapon(x.ewarrior[1][index2], "grktba_c", 1)
						end
					elseif x.randompick == 3 or x.randompick == 9 or x.randompick == 14 then
						x.ewarrior[1][index2] = BuildObject("kvtank", 5, "epatk", x.eatkpt)
						if x.ewarwave[index] == 4 or x.ewarwave[index] == 5 then
							GiveWeapon(x.ewarrior[1][index2], "gflsha_c")
						end
					elseif x.randompick == 4 or x.randompick == 10 or x.randompick == 15 then
						x.ewarrior[1][index2] = BuildObject("kvrckt", 5, "epatk", x.eatkpt)
						if x.ewarwave[index] == 3 or x.ewarwave[index] == 5 then
							GiveWeapon(x.ewarrior[1][index2], "gshdwa_a") --salvo rckt
						end
					elseif x.randompick == 5 or x.randompick == 11 then
						x.ewarrior[1][index2] = BuildObject("kvhtnk", 5, "epatk", x.eatkpt)
						if x.ewarwave[1] == 2 or x.ewarwave[index] == 4 then
							GiveWeapon(x.ewarrior[1][index2], "gstbva_c")
						end
					else
						x.ewarrior[1][index2] = BuildObject("kvwalk", 5, "epatk", x.eatkpt)
						while x.weappick == x.weaplast do --random the random
							x.weappick = math.floor(GetRandomFloat(1.0, 12.0))
						end
						x.weaplast = x.weappick
						if x.weappick == 1 or x.weappick == 5 or x.weappick == 9 then
							GiveWeapon(x.ewarrior[1][index2], "gblsta_a")
						elseif x.weappick == 2 or x.weappick == 6 or x.weappick == 10 then
							GiveWeapon(x.ewarrior[1][index2], "gflsha_a")
						elseif x.weappick == 3 or x.weappick == 7 or x.weappick == 11 then
							GiveWeapon(x.ewarrior[1][index2], "gstbva_a")
						end
					end
					SetSkill(x.ewarrior[1][index2], x.skillsetting)
					x.ewartrgt[1][index2] = nil
				end
				x.ewarabort[1] = GetTime() + 300.0 --here first in case stage goes wrong
				x.ewarstate[1] = x.ewarstate[1] + 1
			--GIVE ATTACK ORDER AND CONDUCT UNIT BATTLE
			elseif x.ewarstate[1] == 3 then
				for index2 = 1, x.ewarsize[1] do
					if IsAlive(x.ewarrior[1][index2]) and (not IsAlive(x.ewartrgt[1][index2]) or x.ewartrgt[1][index2] == nil) then
						if IsAlive(x.fstwr[1]) then
							x.ewartrgt[1][index2] = x.fstwr[1]
						elseif IsAlive(x.fstwr[2]) then
							x.ewartrgt[1][index2] = x.fstwr[2]
						elseif IsAlive(x.fstwr[3]) then
							x.ewartrgt[1][index2] = x.fstwr[3]
						elseif IsAlive(x.fstwr[4]) then
							x.ewartrgt[1][index2] = x.fstwr[4]
						elseif IsAlive(x.fprt) then
							x.ewartrgt[1][index2] = x.fprt
						else
							x.ewartrgt[1][index2] = x.player
						end
						if not x.ewarabortset[1] then
							x.ewarabort[1] = x.ewartime[1] + 300.0
							x.ewarabortset[1] = true
						end
						x.ewarriortime[1][index2] = GetTime()
					end
					--GIVE ATTACK every 30 seconds
					if x.ewarriortime[1][index2] < GetTime() and IsAlive(x.ewarrior[1][index2]) and IsAlive(x.ewartrgt[1][index2])then
						Attack(x.ewarrior[1][index2], x.ewartrgt[1][index2])
						x.ewarriortime[1][index2] = GetTime() + 30.0
					end
					--CHECK IF SQUAD MEMBER DEAD
					if not IsAlive(x.ewarrior[1][index2]) then
						x.ewartrgt[1][index2] = nil
						x.casualty = x.casualty + 1
					end
				end
				--DO CASUALTY COUNT
				if x.casualty >= math.floor(x.ewarsize[1] * 0.8) then --reset attack group
					x.ewarabort[1] = 99999.9
					x.ewartime[1] = GetTime() + x.ewartimecool[1]
					x.ewarstate[1] = 1 --RESET
					x.ewarabortset[index] = false
					if x.ewarwave[1] == 6 then --end after this wave
						x.eatkdeclare = false
						x.waittime = GetTime() + 20.0
						x.frcystate = 1
						StartEmitter(x.fprt, 1)
					end
				end
				x.casualty = 0
			end
			
			--ABORT AND RESET IF NEEDED
			if x.ewarabort[1] < GetTime() then
				x.ewartime[1] = GetTime()
				x.ewarstate[1] = 1 --RESET
				x.ewarabort[1] = 99999.9
				x.ewarabortset[1] = false
			end
		end
	end--shield attack end
	
	--AI GROUP TURRETS
	if x.eturtime < GetTime() and IsAlive(x.ercy) then
		for index = 1, x.eturlength do
			if not IsAlive(x.etur[index]) and not x.eturallow[index] then
				x.etursecs[index] = x.etursecs[index] + 60.0
				x.eturcool[index] = GetTime() + 180.0 + x.etursecs[index]
				x.eturallow[index] = true
			end
			if x.eturallow[index] and x.eturcool[index] < GetTime() then
				x.etur[index] = BuildObject("kvturr", 5, GetPositionNear("epgrcy", 0, 16, 32)) --grpspwn
				Goto(x.etur[index], ("eptur%d"):format(index))
				SetSkill(x.etur[index], x.skillsetting)
				SetObjectiveName(x.etur[index], ("Adder %d"):format(index))
				x.eturallow[index] = false
			end
		end
	end

	--AI GROUP PATROLS
	if x.epattime < GetTime() and IsAlive(x.efac) then
		for index = 1, x.epatlength do
			if not IsAlive(x.epat[index]) and not x.epatallow[index] then
				x.epatsecs[index] = x.epatsecs[index] + 60.0
				x.epatcool[index] = GetTime() + 240.0 + x.epatsecs[index]
				x.epatallow[index] = true
			end
			
			if x.epatallow[index] and x.epatcool[index] < GetTime() then
				if index == 1 then
					x.epat[index] = BuildObject("kvtank", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
					Patrol(x.epat[index], "ppatrol1")
				elseif index == 2 then
					x.epat[index] = BuildObject("kvmbike", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
					Patrol(x.epat[index], "ppatrol2")
				elseif index == 3 then
					x.epat[index] = BuildObject("kvmisl", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
					Patrol(x.epat[index], "ppatrol3")
				elseif index == 4 then
					x.epat[index] = BuildObject("kvtank", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
					Patrol(x.epat[index], "ppatrol4")
				elseif index == 5 then
					x.epat[index] = BuildObject("kvtank", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
					Patrol(x.epat[index], "ppatrol4") --offset
				elseif index == 6 then
					x.epat[index] = BuildObject("kvmbike", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
					Patrol(x.epat[index], "ppatrol1")
				elseif index == 7 then
					x.epat[index] = BuildObject("kvmisl", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
					Patrol(x.epat[index], "ppatrol2")
				elseif index == 8 then
					x.epat[index] = BuildObject("kvtank", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
					Patrol(x.epat[index], "ppatrol3")
				end
				SetSkill(x.epat[index], x.skillsetting)
				--SetObjectiveName(x.epat[index], ("Patrol %d"):format(index))
				x.epatallow[index] = false
			end
		end
		x.epattime = GetTime() + 30.0
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
	
	--WARCODE W/ CLOAKING --SPECIAL NO SHLD USES PRTL
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
						if index == 1 then
							x.ewarsize[index] = 4
						elseif index == 2 then
							x.ewarsize[index] = 4
						elseif index == 3 then
							x.ewarsize[index] = 3
						elseif index == 4 then
							x.ewarsize[index] = 3
						else
							x.ewarsize[index] = 2
						end
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
							x.ewarsize[index] = 8
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
							x.ewarsize[index] = 10
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
							x.randompick = math.floor(GetRandomFloat(1.0, 20.0))
						end
						x.randomlast = x.randompick
						if not IsAlive(x.efac) and IsAlive(x.ercy) then
							x.ewarrior[index][index2] = BuildObject("kvscout", 5, GetPositionNear("epgrcy", 0, 16, 32)) --grpspwn
							x.randompick = 0
						elseif IsAlive(x.efac) then
							if x.randompick == 1 or x.randompick == 7 or x.randompick == 13 or x.randompick == 16 or x.randompick == 19 then
								x.ewarrior[index][index2] = BuildObject("kvmbike", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
								if x.ewarwave[index] == 2 or x.ewarwave[index] == 4 then
									GiveWeapon(x.ewarrior[index][index2], "gstbva_c")
								end
							elseif x.randompick == 2 or x.randompick == 8 or x.randompick == 14 or x.randompick == 17 or x.randompick == 20 then
								x.ewarrior[index][index2] = BuildObject("kvmisl", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
								if x.ewarwave[index] == 3 or x.ewarwave[index] == 5 then
									GiveWeapon(x.ewarrior[index][index2], "grktba_c", 1)
								end
							elseif x.randompick == 3 or x.randompick == 9 or x.randompick == 15 or x.randompick == 18 then
								x.ewarrior[index][index2] = BuildObject("kvtank", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
								if x.ewarwave[index] == 4 or x.ewarwave[index] == 5 then
									GiveWeapon(x.ewarrior[index][index2], "gflsha_c")
								end
							elseif x.randompick == 4 or x.randompick == 10 then
								x.ewarrior[index][index2] = BuildObject("kvrckt", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
								if x.ewarwave[index] == 3 or x.ewarwave[index] == 5 then
									GiveWeapon(x.ewarrior[index][index2], "gshdwa_a") --salvo rckt
								end
							elseif x.randompick == 5 or x.randompick == 11 then
								x.ewarrior[index][index2] = BuildObject("kvhtnk", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
								if x.ewarwave[index] == 2 or x.ewarwave[index] == 4 then
									GiveWeapon(x.ewarrior[index][index2], "gstbva_c")
								end
							else --6, 12
								if x.ewarwave[index] >= 2 then
									x.ewarrior[index][index2] = BuildObject("kvwalk", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
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
								else --too x.hard if comes in very first or second wave
									x.ewarrior[index][index2] = BuildObject("kvtank", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
								end
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
							Retreat(x.ewarrior[index][index2], ("stage%d"):format(x.ewarmeet[index]))
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
					if x.casualty >= math.floor(x.ewarsize[index] * 0.8) then --reset attack group
						x.ewarabort[index] = 99999.9
						x.ewartime[index] = GetTime() + x.ewartimecool[index] + x.ewartimeadd[index]
						if x.ewarwave[index] == 5 then --extra 120s after max wave to "ease up"
							x.ewartime[index] = GetTime() + x.ewartimecool[index] + x.ewartimeadd[index] + 120.0
						end
						x.ewarstate[index] = 1 --RESET
						x.ewarabortset[index] = false
						
						for index2 = 1, x.ewarsize[index] do
							if IsAlive(x.ewarrior[index][index2]) and GetTeamNum(x.ewarrior[index][index2]) ~= 1 then
								SetCommand(x.ewarrior[index][index2], 48)
							end
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
	elseif x.efacstate == 1 and GetDistance(x.player, "epfac") > 420 and x.efactime < GetTime() and IsAlive(x.ercy) then
		x.efac = BuildObject("kbfact", 5, "epfac")
		x.efacstate = 0
	end
	
	--AI ARTILLERY ASSASSIN
	if x.ekillarttime < GetTime() and IsAlive(x.efac) then
		for index = 1, x.ekillartlength do
			if (not IsAlive(x.ekillart[index]) or (IsAlive(x.ekillart[index]) and GetTeamNum(x.ekillart[index]) == 1)) and not x.ekillartallow[index] then
				x.ekillartcool[index] = GetTime() + 180.0
				x.ekillartallow[index] = true
			end
			if x.ekillartallow[index] and x.ekillartcool[index] < GetTime() and IsAlive(x.player) and GetDistance(x.player, "epgfac") > 300 then
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
		--Portal Destroyed 
		if not IsAlive(x.fprt) then
			AudioMessage("tcdw1204.wav") --FAIL - Cmdr stranded out there
			ClearObjectives()
			AddObjective("Pegasus Portal destroyed.\n\nMISSION FAILED!", "RED")
			TCC.FailMission(GetTime() + 18.0, "tcdw12f1.des")
			x.spine = 666
			x.MCAcheck = true
		end
		
		--Recycler destroyed
		if x.frcystate >= 2 and not IsAlive(x.frcy) then
			AudioMessage("tcdw1106.wav") --RECY - need help - lost --REUSE FROM DW12
			ClearObjectives()
			AddObjective("Recycler destroyed.\n\nMISSION FAILED!", "RED")
			TCC.FailMission(GetTime() + 5.0, "tcdw12f2.des") --LOSER LOSER LOSER
			x.MCAcheck = true
			x.spine = 666
		end
	end
end
--[[END OF SCRIPT]]