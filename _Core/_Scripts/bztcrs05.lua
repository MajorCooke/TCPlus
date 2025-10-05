--bztcrs05 - Battlezone Total Command - Red Storm - 5/8 - DIRE STRAITS
assert(load(assert(LoadFile("_requirefix.lua")),"_requirefix.lua"))();
TCC = require("TC_Core")
MisnNum = 21;
require("bzccGPNfix");
--DECLARE variables --f-friend, e-enemy, atk-attack, rcy-recycler, etc..., 
local index = 1
local index2 = 1
local GetPositionNear = GetPositionNearPath
local x = {
	FIRST = true, 
	spine = 0, --typical mission vars
	MCAcheck = false, 
	waittime = 99999.9,
	player = nil, 
	mytank = nil, 
	skillsetting = 0,
	easy = 0, 
	medium = 1, 
	hard = 2, --tried 1-3, in 185, 3 didn't seem to make any difference, 
	pos = {},	
	casualty = 0, 
	randompick = 0, 
	randomlast = 0, 
	audio1 = nil,	
	camstate = 0, 
	camtime = 99999.9,	
  camfov = 60,  --185 default
	userfov = 90,  --seed
	fnav = {}, 
	frcy = nil, 
	ffac = nil, 
	farm = nil, 
	fsil = nil, 
	fally = {}, 
	frcylives = false, 
	etug = nil, 
	etnk = {}, 
	egun = {}, 
	epwr = {}, 
	earm = nil, 
	etec = nil, 
	etrn = nil, 
	esil = nil, 
	etuglives = false, 
	tooclose = false, 
	toofar = false, 
	attackstate = 0, 
	wreckstate = 0, --daywrecker stuff
	wreckallow = 0, --this mission
	wrecktime = 99999.9, 
	wrecktrgt = {},
	wreckbomb = nil, 
	wreckname = "apdwrks", 
	wrecknotify = 0, 
	scrapdone = 0,
	scrap = nil, 
	artillerynotified = 0, 
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
--Paths: fprcy, fpfac, fpcon, fpally0-4, fpbay, fpgun1-2, fppwr1-2, fpatrol, fpnav1-2, eptug, eptnk1-2, epalt, ephome, stage1-2, epart1-2, pcollect, pscrap1-2 pharras

function InitialSetup()
	SetAutoGroupUnits(true)
	
	local odfpreload = {
		"kvrecyrs05", "kvfactrs05", "kvconsrs05", "kbpgen1", "kbgtow", "kbsbay", 
		"svscout", "svmbike", "svmisl", "svtank", "svrckt", "svwalk", "svtug", 
		"apdwrka", "npscrx", "apcamrk", x.wreckname,
	}
	for k,v in pairs(odfpreload) do
		PreloadODF(v)
	end

	x.mytank = GetHandle("mytank")
	x.fsil = GetHandle("fsil")
	x.earm = GetHandle("earm")
	x.etrn = GetHandle("etrn") --req. for DW, also causes sspilo to retreat
	x.etec = GetHandle("etec") --need for daywreck
	x.esil = GetHandle("esil")
	x.epwr[1] = GetHandle("epwr1")
	x.epwr[2] = GetHandle("epwr2")
	x.epwr[3] = GetHandle("epwr3")
	for index = 1, 6 do
		x.egun[index] = GetHandle(("egun%d"):format(index))
	end
	Ally(1, 4)
	Ally(4, 1) --4 endgame reinforce group
	Ally(5, 4)
	Ally(4, 5)  
	SetColorFade(6.0, 0.5, "BLACK")
	TCC.Init()
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
	if (not IsAlive(x.farm) or x.farm == nil) and (IsOdf(h, "kvarmo:1") or IsOdf(h, "kbarmo")) then
		x.farm = h
	elseif (not IsAlive(x.ffac) or x.ffac == nil) and (IsOdf(h, "kvfactrs05:1") or IsOdf(h, "kbfactrs05")) then
		x.ffac = h
	elseif (not IsAlive(x.fsld) or x.fsld == nil) and IsOdf(h, "kbshld") then
		x.fsld = h
	elseif (not IsAlive(x.fhqr) or x.fhqr == nil) and IsOdf(h, "kbhqtr") then
		x.fhqr = h
	elseif (not IsAlive(x.ftec) or x.ftec == nil) and IsOdf(h, "kbtcen") then
		x.ftec = h
	elseif (not IsAlive(x.ftrn) or x.ftrn == nil) and IsOdf(h, "kbtrain") then
		x.ftrn = h
	elseif (not IsAlive(x.fbay) or x.fbay == nil) and IsOdf(h, "kbsbay") then
		x.fbay = h
	elseif (not IsAlive(x.fcom) or x.fcom == nil) and IsOdf(h, "kbcbun") then
		x.fcom = h
	elseif IsOdf(h, "kbpgen1") then
		for indexadd = 1, 4 do
			if x.fpwr[indexadd] == nil or not IsAlive(x.fpwr[indexadd]) then
				x.fpwr[indexadd] = h
				break
			end
		end
	end
	
	if (not IsAlive(x.wreckbomb) or x.wreckbomb == nil) and IsOdf(h, x.wreckname) then
		if GetTeamNum(h) == 5 then
			x.wreckbomb = h --get handle to launched daywrecker
		end
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

function PreDamage(curWorld, h, DamageType, pContext, value, base, armor, shield, owner, source, SelfDamage, FriendlyFireDamage)
	return TCC.PreDamage(curWorld, h, DamageType, pContext, value, base, armor, shield, owner, source, SelfDamage, FriendlyFireDamage);
end

function Update()
	x.player = GetPlayerHandle() --EVERY PASS SO IF PLAYER CHANGES VEHICLES
	x.skillsetting = IFace_GetInteger("options.play.difficulty")
	TCC.Update()
	
	--SETUP MISSION BASICS
	if x.spine == 0 then
		x.pos = GetTransform(x.mytank)
		RemoveObject(x.mytank)
		x.mytank = BuildObject("kvscav", 1, x.pos)
		SetAsUser(x.mytank, 1)
		RemoveObject(x.player)
		x.player = GetPlayerHandle()
		AudioMessage("tcrs0501.wav") --Worthless perform on Gany sicken me. Think about it while u scaven
		AddObjective("tcrs0501.txt")
		for index = 1, 60 do
			x.scrap = BuildObject("npscrx", 0, "pscrap1", index)
		end
		x.scrapdone = 1
		x.spine = x.spine + 1
	end
	
	--SEND FPATROL
	if x.spine == 1 and GetScrap(1) > 100 then
		for index = 1, 4 do
			x.fally[index] = BuildObject("kvscout", 1, ("fpally%d"):format(index))
      SetCanSnipe(x.fally[index], 0)
			Goto(x.fally[index], "fpatrol")
		end
		x.spine = x.spine + 1
	end
	
	--SETUP HARASS MESSAGE
	if x.spine == 2 then
		for index = 1, 4 do
			if GetDistance(x.fally[index], "pharras") < 100 then
				AudioMessage("tcrs0502.wav") --Hey, check out the new scav driver - generic harassing
				x.spine = x.spine + 1
				break
			end
		end
	end
	
	--PLAY PATROL DONE MESSAGE
	if x.spine == 3 then
		for index = 1, 4 do
			if GetDistance(x.fally[index], "fpnav1") < 64 then
				AudioMessage("tcrs0503.wav") --Sector 8 sweep complete... comms lost
				x.spine = x.spine + 1
				break
			end
		end
	end	 

	--SETUP LOST PATROL
	if x.spine == 4 then
		for index = 1, 4 do
			if GetDistance(x.fally[index], "fpally0") < 64 then 
				for index2 = 1, 4 do
					RemoveObject(x.fally[index2])
				end
				x.waittime = GetTime() + 10.0
				x.spine = x.spine + 1
				break
			end
		end
	end
	
	--ORDER TO NAV POINT
	if x.spine == 5 and x.waittime < GetTime() then
		x.audio1 = AudioMessage("tcrs0504a.wav") --A version with added pauses: Say again scout 1. Repeat last. Scav 3 you closest goto NAV
		x.spine = x.spine + 1
	end
	
	--GIVE NAV TO PLAYER
	if x.spine == 6 and IsAudioMessageDone(x.audio1) then
		x.fnav[1] = BuildObject("apcamrk", 1, "fpnav1")
		ClearObjectives()
		AddObjective("tcrs0502.txt")
		SetObjectiveName(x.fnav[1], "last known location")
		SetObjectiveOn(x.fnav[1])
		x.scrapdone = 0
		x.spine = x.spine + 1
	end
	
	--BUILD CCA TUG
	if x.spine == 7 and GetDistance(x.player, "fpnav1") < 500 then
		x.fally[1] = BuildObject("kvscout", 0, "fpally0")
		Damage(x.fally[1], 1000)
		x.etug = BuildObject("svtug", 5, "eptug")
    SetCanSnipe(x.etug, 0)
		x.etnk[1] = BuildObject("svscout", 5, "eptnk1")
    SetCanSnipe(x.etnk[1], 0)
		x.etnk[2] = BuildObject("svscout", 5, "eptnk2")
    SetCanSnipe(x.etnk[2], 0)
		x.etuglives = true
		x.spine = x.spine + 1
	end
	
	--IF PLAYER AT NAV, START CAMERA
	if x.spine == 8 and GetDistance(x.player, "fpnav1") < 200 then
		Pickup(x.etug, x.fally[1])
		x.waittime = GetTime() + 13.0
		x.camstate = 1
    x.userfov = IFace_GetInteger("options.graphics.defaultfov")
    CameraReady()
    IFace_SetInteger("options.graphics.defaultfov", x.camfov)
		x.spine = x.spine + 1
	end
	
	--TUG HAS SCOUT
	if x.spine == 9 and x.etug == GetTug(x.fally[1]) then
		Goto(x.etug, "epalt")
		Follow(x.etnk[1], x.etug)
		Follow(x.etnk[2], x.etug)
		x.spine = x.spine + 1
	end
	
	--STOP CAMERA GIVE ORDER
	if x.spine == 10 and (x.waittime < GetTime() or CameraCancelled()) then
    CameraFinish()
    IFace_SetInteger("options.graphics.defaultfov", x.userfov)
		x.camstate = 0
		RemoveObject(x.fnav[1])
		AudioMessage("tcrs0505.wav") --follow that convoy scav 3
		ClearObjectives()
		AddObjective("tcrs0503.txt")
		--SetObjectiveName(x.etug, "Follow Tractor")
		SetObjectiveOn(x.etug)
		x.tooclose = true
		x.toofar = true
		x.spine = x.spine + 1
	end
	
	--SEND BASE ATTACK MESSAGE
	if x.spine == 11 and GetDistance(x.etug, "ephome") < 100 then
		x.audio1 = AudioMessage("tcrs0506.wav") --the base under attack. Scav 3 take cmd, get under control.
		x.fnav[1] = BuildObject("apcamrk", 1, "fpnav2")
		ClearObjectives()
		AddObjective("tcrs0504.txt")
		SetObjectiveName(x.fnav[1], "FOB")
		SetObjectiveOn(x.fnav[1])
		x.tooclose = false
		x.toofar = false
		x.spine = x.spine + 1
	end
	
	--PT1 SIMULATE BASE ATTACK
	if x.spine == 12 and IsAudioMessageDone(x.audio1) then
		AudioMessage("abetty6.wav") --base under attack
		AudioMessage("abetty2.wav") --defensive unit lost
		AudioMessage("abetty3.wav") --offensive unit lost
		AudioMessage("abetty2.wav") --defensive unit lost
		x.audio1 = AudioMessage("abetty11.wav") --power lost
		x.spine = x.spine + 1
	end
	
	--PT2 SIMULATE BASE ATTACK
	if x.spine == 13 and IsAudioMessageDone(x.audio1) then
		SetObjectiveOff(x.etug) --MOVED HERE SO NOT SO IMMEDIATE
		for index = 1, 60 do
			x.scrap = BuildObject("npscrx", 0, "pscrap2", index) --"npscrpcox10"
		end
		AudioMessage("abetty14.wav") --building lost
		AudioMessage("abetty11.wav") --power lost
		AudioMessage("abetty3.wav") --offensive unit lost
		AudioMessage("abetty3.wav") --offensive unit lost
		AudioMessage("abetty14.wav") --building lost
		AudioMessage("abetty11.wav") --power lost
		AudioMessage("abetty14.wav") --building lost
		x.spine = x.spine + 1
	end
	
	--GIVE BASE STUFF TO PLAYER
	if x.spine == 14 and GetDistance(x.player, "fpnav2") < 800 then
		ClearObjectives()
		AddObjective("tcrs0504b.txt")
		x.fgun1 = BuildObject("kbgtow", 1, "fpgun1")
		x.fgun2 = BuildObject("kbgtow", 1, "fpgun2")
		x.fpwr[1] = BuildObject("kbpgen1", 1, "fppwr1")
		x.fpwr[2] = BuildObject("kbpgen1", 1, "fppwr2")
		x.fbay = BuildObject("kbsbay", 1, "fpbay")
		x.frcy = BuildObject("kvrecyrs05", 1, "fprcy")
		Goto(x.frcy, "fpnav2", 0)
		x.ffac = BuildObject("kvfactrs05", 1, "fpfac")
		Goto(x.ffac, "fpnav2", 0)
		x.fcon = BuildObject("kvconsrs05", 1, "fpcon")
		Goto(x.fcon, "fpnav2", 0)
		x.fally[1] = BuildObject("kvmbike", 1, "fpcon")
		x.fally[2] = BuildObject("kvmisl", 1, "fpcon")
		x.fally[3] = BuildObject("kvtank", 1, "fpcon")
		x.fally[4] = BuildObject("kvrckt", 1, "fpcon")
		for index = 1, 4 do
			SetGroup(x.fally[index], 3)
			Follow(x.fally[index], x.frcy, 0)
		end
		x.frcylives = true
		x.spine = x.spine + 1
	end
	
	--START UP THE ATTACKS
	if x.spine == 15 and IsAlive(x.frcy) and IsOdf(x.frcy, "kbrecyrs05") then
		for index = 1, x.ewartotal do --INIT WARCODE
			x.ewartotal = 4 
			x.ewardeclare = true
			x.ewarrior[index] = {} --"rows"
			for index2 = 1, 10 do --n should be max number avail
				x.ewarrior[index][index2] = nil --"columns", init (handle in this case)
			end
			x.ewartrgt[index] = nil
			x.ewarstate[index] = 1
			x.ewartime[1] = GetTime() --recy
			x.ewartime[2] = GetTime() + 60.0 --fact
			x.ewartime[3] = GetTime() + 80.0 --120.0 --armo
			x.ewartime[4] = GetTime() + 100.0 --180.0 --base
			x.ewartimecool[index] = 30.0  --speed up more  --60.0 --120.0
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
	
	--STOP THE ATTACKS
	if x.spine == 16 and x.attackstate == 2 then
		x.wrecktime = 99999.9
		x.wrecktwait = 99999.9
		x.waittime = GetTime() + 180.0
		x.spine = x.spine + 1
	end
	
	--BUILD REINFORCEMENT SQUAD
	if x.spine == 17 and x.waittime < GetTime() then 
		for index = 1, 12 do --init squad existence
			x.fally[index] = nil
		end
		for index = 1, 4 do --build'em
			x.fally[index] = BuildObject("kvmbike", 4, "fprcy")
			x.fally[index+4] = BuildObject("kvmisl", 4, "fpfac")
			x.fally[index+8] = BuildObject("kvtank", 4, "fpcon")
		end
		for index = 1, 12 do --spread out
			if index % 3 == 0 then
				Goto(x.fally[index], "fpnav2")
			elseif index % 2 == 0 then
				Goto(x.fally[index], x.frcy)
			else
				Goto(x.fally[index], x.player)
			end
		end
		AudioMessage("emspintrim.wav")
		AddObjective("	")
		AddObjective("Reinforcements incoming.", "ALLYBLUE")
		x.spine = x.spine + 1
	end
	
	--START VICTORY TOUR
	if x.spine == 18 then
		for index = 1, 12 do
			if IsAlive(x.fally[index]) and GetDistance(x.fally[index], "fpnav2") < 100 then
				x.audio1 = AudioMessage("tcrs0508.wav") --SUCCEED - Good work. HC say you redeemed. Cmd Elysium forces.
				ClearObjectives()
				AddObjective("tcrs0505.txt", "GREEN")
				x.MCAcheck = true
				x.spine = x.spine + 1
				break
			end
		end
	end
	
	--SUCCEED MSSION	
	if x.spine == 19 and IsAudioMessageDone(x.audio1) then
		TCC.SucceedMission(GetTime(), "tcrs05w.des") --winner winner winner
		x.spine = x.spine + 1
	end
	----------END MAIN SPINE ----------
	
	--ETUG CAMERA
	if x.camstate == 1 then
		CameraObject(x.fnav[1], 0, 20, 0, x.etug)
	end

	--REMOVE ETUG CONVOY
	if x.etuglives and IsAlive(x.etug) and GetDistance(x.etug, "epalt") < 100 then
		x.etuglives = false
		RemoveObject(x.fally[1])
		RemoveObject(x.etug)
		RemoveObject(x.etnk[1])
		RemoveObject(x.etnk[2])
	end
	
	--AI DAYWRECKER ATTACK
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
			x.wrecktime = GetTime() + 300.0
		elseif x.randompick == 2 or x.randompick == 5 or x.randompick == 8 then
			x.wrecktime = GetTime() + 240.0
		else
			x.wrecktime = GetTime() + 180.0
		end
		x.wreckstate = 0 --reset
	end

	--WARCODE (non-AIP or temp AIP replacement)
	if x.ewardeclare then
		for index = 1, x.ewartotal do	
			if x.ewartime[index] < GetTime() then 
				--SET WAVE NUMBER AND BUILD SIZE
				if x.ewarstate[index] == 1 and x.attackstate < 2 then --SPECIAL CONTROL RS05
					x.ewarwave[index] = x.ewarwave[index] + 1
					if x.ewarwave[index] > x.ewarwavemax[index] then
						x.ewarwave[index] = x.ewarwavereset[index]
					end
					if x.ewarwave[index] == 1 then
						if index == 1 then
							x.ewarsize[index] = x.ewarsize[index] + 2
						else
							x.ewarsize[index] = 2
						end
					elseif x.ewarwave[index] == 2 then
						if index == 1 then
							x.ewarsize[index] = x.ewarsize[index] + 2
						else
							x.ewarsize[index] = 3
						end
					elseif x.ewarwave[index] == 3 then
						if index == 1 then
							x.ewarsize[index] = x.ewarsize[index] + 2
						else
							x.ewarsize[index] = 4
						end
					elseif x.ewarwave[index] == 4 then
						if index == 1 then
							x.ewarsize[index] = x.ewarsize[index] + 2
						else
							x.ewarsize[index] = 6 --5
						end 
					else --x.ewarwave[index] == 5 then
						if index == 1 then
							x.ewarsize[index] = x.ewarsize[index] + 2
						else
							x.ewarsize[index] = 8 --6
						end
					end
					----------RS05 MISSION ONLY----------
					if x.wreckallow == 0 and x.ewarwave[1] == 3 then
						x.wrecktime = GetTime()
						x.wreckallow = 1
					end
					if x.attackstate == 0 and index == 1 and x.ewarsize[1] >= 6 then
						x.attackstate = 1
					end
					if x.attackstate == 1 then
						if x.skillsetting == x.easy and x.ewarsize[1] >= 10 then
							x.attackstate = 2
						elseif x.skillsetting == x.medium and x.ewarsize[1] >= 13 then
							x.attackstate = 2
						elseif x.skillsetting >= x.hard and x.ewarsize[1] >= 17 then
							x.attackstate = 2
						end
					end
					----------end RS05 MISSION ONLY----------
					x.ewarstate[index] = x.ewarstate[index] + 1
				end
				
				--BUILD FORCE
				if x.ewarstate[index] == 2 then
					if index < 4 then --THIS MISISON ONLY, SPECIAL BASE ATTACK BELOW
						for index2 = 1, x.ewarsize[index] do
							while x.randompick == x.randomlast do --random the random
								x.randompick = math.floor(GetRandomFloat(1.0, 18.0))
							end
							x.randomlast = x.randompick
							if x.randompick == 1 or x.randompick == 7 or x.randompick == 13 then
								x.ewarrior[index][index2] = BuildObject("svscout", 5, GetPositionNear("epalt", 0, 16, 32)) --grpspwn  --"epalt")
								if x.ewarwave[index] == 3 or x.ewarwave[index] == 4 then
									GiveWeapon(x.ewarrior[index][index2], "glasea_c")
								end
							elseif x.randompick == 2 or x.randompick == 8 or x.randompick == 14 then
								x.ewarrior[index][index2] = BuildObject("svmbike", 5, GetPositionNear("epalt", 0, 16, 32)) --grpspwn  --"epalt")
								if x.ewarwave[index] == 2 or x.ewarwave[index] == 4 then
									GiveWeapon(x.ewarrior[index][index2], "gstbva_c")
								end
							elseif x.randompick == 3 or x.randompick == 9 or x.randompick == 15 then
								x.ewarrior[index][index2] = BuildObject("svmisl", 5, GetPositionNear("epalt", 0, 16, 32)) --grpspwn  --"epalt")
								if x.ewarwave[index] == 3 or x.ewarwave[index] == 5 then
									GiveWeapon(x.ewarrior[index][index2], "gfafma_c")
								end
							elseif x.randompick == 4 or x.randompick == 10 or x.randompick == 16 then
								x.ewarrior[index][index2] = BuildObject("svtank", 5, GetPositionNear("epalt", 0, 16, 32)) --grpspwn  --"epalt")
								if x.ewarwave[index] == 4 or x.ewarwave[index] == 5 then
									GiveWeapon(x.ewarrior[index][index2], "gstbsa_c")
								end
							elseif x.randompick == 5 or x.randompick == 11 or x.randompick == 17 then
								x.ewarrior[index][index2] = BuildObject("svrckt", 5, GetPositionNear("epalt", 0, 16, 32)) --grpspwn  --"epalt")
								if x.ewarwave[index] == 3 or x.ewarwave[index] == 5 then
									GiveWeapon(x.ewarrior[index][index2], "gshdwa_a") --salvo rckt
								end
							else
								x.ewarrior[index][index2] = BuildObject("svwalk", 5, GetPositionNear("epalt", 0, 16, 32)) --grpspwn  --"epalt")
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
						end
					else --index >= 4 base attac
						for index2 = 1, 6 do
							if index2 % 2 == 0 then --so don't bunch quite as bad
								x.ewarrior[index][index2] = BuildObject("svartl", 5, GetPositionNear("epart2", 0, 16, 32))
							else
								x.ewarrior[index][index2] = BuildObject("svartl", 5, GetPositionNear("epart1", 0, 16, 32))
							end
						end
					end
					SetSkill(x.ewarrior[index][index2], x.skillsetting)
					if index2 % 3 == 0 then
						SetSkill(x.ewarrior[index][index2], x.skillsetting+1)
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
							Goto(x.ewarrior[index][index2], ("path_%d"):format(x.ewarmeet[index]))  --("stage%d"):format(x.ewarmeet[index]))
						----------RS06 ONLY----------
							if x.artillerynotified == 0 and index == 4 then
								Goto(x.ewarrior[index][index2], "path_2")  --"stage2") --(south west) so western audio runs first in sync
								x.artillerynotified = 1
							end
						end
					end
					x.ewarstate[index] = x.ewarstate[index] + 1
				end
				
				--A UNIT AT STAGE PT
				if x.ewarstate[index] == 4 then
					for index2 = 1, x.ewarsize[index] do
						if IsAlive(x.ewarrior[index][index2]) and GetDistance(x.ewarrior[index][index2], ("stage%d"):format(x.ewarmeet[index])) < 100 and GetTeamNum(x.ewarrior[index][index2]) ~= 1 then
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
								if IsAlive(x.fsld) then
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
                if x.artillerynotified == 1 then
                  AudioMessage("tcrs0507.wav") --We found (Cca) artillery to the West.
                  x.artillerynotified = 2
                end
							else --safety call --shouldn't ever run
								x.ewartrgt[index] = x.player
							end
							Attack(x.ewarrior[index][index2], x.ewartrgt[index])
							if not x.ewarabortset[index] then
								x.ewarabort[index] = x.ewartime[index] + 420.0
								x.ewarabortset[index] = true
							end
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
							x.ewartime[index] = GetTime() + x.ewartimecool[index] + x.ewartimeadd[index] + 30.0
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
							if IsAlive(x.ewarrior[index][index2]) and not IsPlayer(x.ewarrior[index][index2]) then
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
 
	--CHECK STATUS OF MCA ----------------------------------
	if not x.MCAcheck then
		if x.scrapdone == 1 and (not IsInsideArea("pcollect", x.player) or not IsAround(x.mytank)) then --left work early
			AudioMessage("tcrs0509.wav") --FAIL you are imbecile coxxon edit
			ClearObjectives()
			AddObjective("tcrs0501.txt", "RED")
			AddObjective("	")
			AddObjective("tcrs0506.txt", "RED")
			TCC.FailMission(GetTime() + 6.0, "tcrs05f1.des") --loser loser loser
			x.spine = 666
			x.MCAcheck = true
		end
		
		if x.tooclose and IsAlive(x.etug) and GetDistance(x.player, x.etug) < 175 then --too close to cca tug
			AudioMessage("tcrs0509.wav") --FAIL you are imbecile coxxon edit
			ClearObjectives()
			AddObjective("tcrs0503.txt", "RED")
			AddObjective("	")
			AddObjective("tcrs0506.txt", "RED")
			TCC.FailMission(GetTime() + 6.0, "tcrs05f2.des") --loser loser loser
			Attack(x.etnk[1], x.player)
			Attack(x.etnk[2], x.player)
			x.spine = 666
			x.MCAcheck = true
		end
		
		if x.toofar and IsAlive(x.etug) and GetDistance(x.player, x.etug) > 425 then --too far from cca tug
			AudioMessage("tcrs0509.wav") --FAIL you are imbecile coxxon edit
			ClearObjectives()
			AddObjective("tcrs0503.txt", "RED")
			AddObjective("	")
			AddObjective("tcrs0506.txt", "RED")
			TCC.FailMission(GetTime() + 6.0, "tcrs05f3.des") --loser loser loser
			SetObjectiveOff(x.etug)
			x.spine = 666
			x.MCAcheck = true
		end
		
		if x.frcylives and not IsAlive(x.frcy) and not IsAlive(x.ffac) then
			AudioMessage("tcrs0510.wav") --coxxon, Major edit out - FAIL You have failed the Repub, your dishonor knows no bounds
			ClearObjectives()
			AddObjective("tcrs0507.txt", "RED")
			TCC.FailMission(GetTime() + 8.0, "tcrs05f4.des") --loser loser loser
			x.spine = 666
			x.MCAcheck = true
		end
		
		if x.etuglives and (not IsAlive(x.etug) or not IsAlive(x.fally[1])) then --don't mess with tug or scout
			AudioMessage("tcrs0509.wav") --FAIL you are imbecile coxxon edit
			ClearObjectives()
			AddObjective("tcrs0508.txt", "RED")
			TCC.FailMission(GetTime() + 6.0, "tcrs05f5.des") --loser loser loser
			x.spine = 666
			x.MCAcheck = true
		end 
	end
end
--[[END OF SCRIPT]]