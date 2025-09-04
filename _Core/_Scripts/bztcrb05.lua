--bztcrb05 - Battlezone Total Command - The Red Brigade - 5/8 - CONTROLLING THE HIGH GROUND
assert(load(assert(LoadFile("_requirefix.lua")),"_requirefix.lua"))();
TCC = require("TC_Core")
MisnNum = 33;
--DECLARE variables --f-friend, e-enemy, atk-attack, rcy-recycler, etc..., 
local index = 1
local index2 = 1
local indexadd = 1
local x = {
	FIRST = true,
	spine = 0,
	MCAcheck = false,
	waittime = 99999.9,
	player = nil, 
	mytank = nil, 
	skillsetting = 0, 
	fnav = {}, 
	pos = {}, 
	audio1 = nil, 
	camfov = 60,  --185 default
	userfov = 90,  --seed
	playfail = false, 
	casualty = 0,
	randompick = 0, 
	randomlast = 0,
	frcy = nil,
	ffac = nil,
	farm = nil,
	fcon = nil,
	fgrp = {},
	fhng = {}, 
	free_player = false, --dropship
	controls = {braccel = 0, strafe = 0, jump = 0, deploy = 0, eject = 0, abandon = 0, fire = 0}, 
	fdrp = {}, 
	holder = {},	
	poolall = 0, --bio-metal pool mark
	poolmark = {false, false, false, false}, 
	pooltank = nil, 
	poolobject = {}, 
	ercy = nil, --ai buildings
	ercylocation = 0, 
	ercylocationold = 0, 
	ercystart = false, 
	ercystate = 0, 
	ercytime = 99999.9, 
	ercyhealth = 0, 
	ercylives = false, 
	etrt = {}, 
	ewlk = {}, 
	eart = {}, 
	epwr = {}, 
	egun = {}, 
	eatkallow = false, 
	eatknotify = false, 
	eatk = {},
	eatkstate = 0, 
	eatkresendtime = 99999.9, 
	eatkcount = 0, 
	eatklength = 0, 
	randomspn = 0, 
	cam1 = false, --cam stuff
	etnk = {}, --base guards
	fpwr = {nil, nil, nil, nil}, 
	fhqr = nil,
	ftec = nil,
	ftrn = nil,
	fbay = nil,
	fcom = nil,
	fhqr = nil,
	fsld = nil, 
	ewardeclare = false, --WARCODE --1 recy, 2 fact, 3 armo, 4 base 
	ewartotal = 4,
	ewarrior = {}, 
	ewartrgt = {}, 
	ewartime = {},
	ewartimecool = {},
	ewartimeadd = {},
	ewarabort = {}, 
	ewarstate = {}, 
	ewarsize = {}, 
	ewarwave = {}, 
	ewarwavemax = {}, 
	ewarwavereset = {}, 
	ewarmeet = {}, 
	LAST = true
}
--Paths: eptrt1-3, epart1-3, epwlk1-3, fpmeet, fnav0-5, pcam1, eprcy1, epgun1_1-4, eppwr1_1-4, eprcy2, epgun2_1-4, eppwr2_1-4, eprcy3, epgun3_1-4, eppwr3_1-4, eprcy4, epgun4_1-4, eppwr4_1-4, espn1_1-10, espn2_1-10, espn3_1-10, espn4_1-10

function InitialSetup()
	SetAutoGroupUnits(true)
	
	local odfpreload = {	
		"svscout", "svmbike", "svmisl", "svtank", "svrckt", "bbrecy", "bvscout", "bvmbike", "bvmisl", "bvtank", 
		"bvrckt", "bvapc", "bvartl", "bvwalk", "bvturr", "bbgtow", "bbpgen2", "gstbsa_c", "stayput", "apcamrs", "radjam"
}
	for k,v in pairs(odfpreload) do
		PreloadODF(v)
	end
	
	x.fdrp[1] = GetHandle("fdrp1")
	x.mytank = GetHandle("mytank")
	x.frcy = GetHandle("frcy")
	x.ffac = GetHandle("ffac")
	x.farm = GetHandle("farm")
	x.fhng = GetHandle("fhng")
	x.fcom = GetHandle("fcom")
	x.fbay = GetHandle("fbay")
	x.ftec = GetHandle("ftec")
	x.ftrn = GetHandle("ftrn")
	for index = 1, 5 do
		x.fgrp[index] = GetHandle(("fgrp%d"):format(index))
	end
	SetColorFade(6.0, 0.5, "BLACK")
	TCC.Init()
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
	if (not IsAlive(x.farm) or x.farm == nil) and (IsOdf(h, "svarmorb05:1") or IsOdf(h, "sbarmorb05")) then
		x.farm = h
	elseif (not IsAlive(x.ffac) or x.ffac == nil) and (IsOdf(h, "svfactrb05:1") or IsOdf(h, "sbfactrb05")) then
		x.ffac = h
	elseif (not IsAlive(x.fsld) or x.fsld == nil) and IsOdf(h, "sbshld") then
		x.fsld = h
	elseif (not IsAlive(x.fhqr) or x.fhqr == nil) and IsOdf(h, "sbhqtr") then
		x.fhqr = h
	elseif (not IsAlive(x.ftec) or x.ftec == nil) and IsOdf(h, "sbtcen") then
		x.ftec = h
	elseif (not IsAlive(x.ftrn) or x.ftrn == nil) and IsOdf(h, "sbtrain") then
		x.ftrn = h
	elseif (not IsAlive(x.fbay) or x.fbay == nil) and IsOdf(h, "sbsbay") then
		x.fbay = h
	elseif (not IsAlive(x.fcom) or x.fcom == nil) and IsOdf(h, "sbcbun") then
		x.fcom = h
	elseif IsOdf(h, "sbpgen2") then
		for indexadd = 1, 4 do
			if x.fpwr[indexadd] == nil or not IsAlive(x.fpwr[indexadd]) then
				x.fpwr[indexadd] = h
				break
			end
		end
	end
	TCC.AddObject(h)
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
	TCC.Update()
	
	--Set up mission basics
	if x.spine == 0 then
		x.pos = GetTransform(x.mytank)
		RemoveObject(x.mytank)
		x.mytank = BuildObject("svtank", 1, x.pos)
		GiveWeapon(x.mytank, "gstbsa_c")
		SetAsUser(x.mytank, 1)
		RemoveObject(x.player)
		x.player = GetPlayerHandle()
		SetTeamNum(x.player, 1)--JUST IN CASE
		x.pos = GetTransform(x.fgrp[1])
		RemoveObject(x.fgrp[1])
		x.fgrp[1] = BuildObject("svscout", 1, x.pos)
		x.pos = GetTransform(x.fgrp[2])
		RemoveObject(x.fgrp[2])
		x.fgrp[2] = BuildObject("svscout", 1, x.pos)
		x.pos = GetTransform(x.fgrp[3])
		RemoveObject(x.fgrp[3])
		x.fgrp[3] = BuildObject("svtank", 1, x.pos)
		x.pos = GetTransform(x.fgrp[4])
		RemoveObject(x.fgrp[4])
		x.fgrp[4] = BuildObject("svtank", 1, x.pos)
		x.pos = GetTransform(x.fgrp[5])
		RemoveObject(x.fgrp[5])
		x.fgrp[5] = BuildObject("svtank", 1, x.pos)
		for index = 1, 5 do
			SetSkill(x.fgrp[index], x.skillsetting)
			SetGroup(x.fgrp[index], 0)
		end
		x.eart[1] = BuildObject("bvartl", 5, "epart1") --epart1-6 avail
		SetSkill(x.eart[1], x.skillsetting)
		x.eart[3] = BuildObject("bvartl", 5, "epart3")
		SetSkill(x.eart[3], x.skillsetting)
		x.eart[4] = BuildObject("bvartl", 5, "epart4")
		SetSkill(x.eart[4], x.skillsetting)
		x.eart[5] = BuildObject("bvartl", 5, "epart5")
		SetSkill(x.eart[5], x.skillsetting)
		x.etrt[1] = BuildObject("bvturr", 5, "eptrt1") --west ridge eptrt1-3
		SetSkill(x.eart[1], x.skillsetting)
		x.etrt[3] = BuildObject("bvturr", 5, "eptrt3") --east ridge --yes 3
		SetSkill(x.etrt[3], x.skillsetting)
		x.ewlk[2] = BuildObject("bvwalk", 5, "epwlk2") --top ridge	epwlk1-3 avail
		SetSkill(x.ewlk[2], x.skillsetting)
		AudioMessage("tcrb0501.wav") --INTRO - Chesti have setup lab. BDogs on ridge above
		--AudioMessage("tcrb0502.wav") --OPT - Snipers atk Chesti. He taken refuge in Recycler
		x.audio1 = AudioMessage("tcrb0503.wav") --Bdogs artillery. Take out secure perim. Lrgr atk on the way
		x.cam1 = true
    x.userfov = IFace_GetInteger("options.graphics.defaultfov")
    CameraReady()
    IFace_SetInteger("options.graphics.defaultfov", x.camfov)
		x.spine = x.spine + 1
	end
	
	--is camera sequence done
	if x.spine == 1 and IsAudioMessageDone(x.audio1) then
    CameraFinish()
    IFace_SetInteger("options.graphics.defaultfov", x.userfov)
		x.cam1 = false
		x.spine = x.spine + 1
	end

	--DROPSHIP LANDING SEQUENCE - START QUAKE FOR FLYING EFFECT
	if x.spine == 2 then
		for index = 1, 4 do --CCA dropship 4 emits
			StopEmitter(x.fdrp[1], index)
		end
		for index = 1, 5 do
			Stop(x.fgrp[index])
			x.holder[index] = BuildObject("stayput", 0, x.fgrp[index]) --fdrp1 dropship 1
		end
    x.holder[6] = BuildObject("radjam", 5, x.player)
		x.holder[7] = BuildObject("stayput", 0, x.player) --fdrp1 dropship 1
		StartEarthQuake(10.0)
		x.waittime = GetTime() + 3.0
		x.spine = x.spine + 1
	end

	--LANDING - MAKE QUAKE BIGGERR
	if x.spine == 3 and x.waittime < GetTime() then
		UpdateEarthQuake(50.0)
		x.waittime = GetTime() + 3.0
		x.spine = x.spine + 1
	end
	
	--HAVE LANDED - STOP QUAKE
	if x.spine == 4 and x.waittime < GetTime() then
		StopEarthQuake()
		x.waittime = GetTime() + 2.0
		x.spine = x.spine + 1
	end

	--OPEN DROPSHIP DOORS, REMOVE HOLDERS
	if x.spine == 5 and x.waittime < GetTime() then
		StartSoundEffect("dropdoor.wav")
		SetAnimation(x.fdrp[1], "open", 1)
		x.waittime = GetTime() + 4.0
		x.spine = x.spine + 1
	end
	
	--DOORS FULLY OPEN, GIVE MOVE ORDER
	if x.spine == 6 and x.waittime < GetTime() then
		for index = 1, 6 do
			RemoveObject(x.holder[index])
			Goto(x.fgrp[index], "fpmeet", 0)
		end
		x.waittime = GetTime() + 2.0
		x.spine = x.spine + 1
	end

	--GIVE PLAYER CONTROL OF THEIR AVATAR
	if x.spine == 7 and x.waittime < GetTime() then
		RemoveObject(x.holder[7])
		x.free_player = true
		x.spine = x.spine + 1
	end
	
	--CHECK IF PLAYER HAS LEFT DROPSHIP
	if x.spine == 8 then
		x.player = GetPlayerHandle()
		if IsCraftButNotPerson(x.player) and GetDistance(x.player, x.fdrp[1]) > 60 then
			ClearObjectives()
			AddObjective("tcrb0501.txt")
			x.fnav[6] = BuildObject("apcamrs", 1, "fnav0") --build 6 at 0
			SetObjectiveName(x.fnav[6], "CCA Base")
			x.spine = x.spine + 1
		end
	end

	--DROPSHIP 1 TAKEOFF
	if x.spine == 9 then
		for index = 1, 10 do
			StartEmitter(x.fdrp[1], index)
		end
		SetAnimation(x.fdrp[1], "takeoff", 1)
		StartSoundEffect("dropleav.wav", x.fdrp[1])
		x.waittime = GetTime() + 15.0
		x.spine = x.spine + 1
	end

	--REMOVE DROPSHIPS
	if x.spine == 10 and x.waittime < GetTime() then
		RemoveObject(x.fdrp[1])
		x.spine = x.spine + 1
	end

	--BDS ARTL GONE, GIVE OBJECTIVE AND PAUSE
	if x.spine == 11 and not IsAlive(x.eart[1]) and not IsAlive(x.eart[2]) and not IsAlive(x.eart[3]) and not IsAlive(x.eart[4]) and not IsAlive(x.eart[5]) and not IsAlive(x.eart[6])then
		AudioMessage("tcrb0504.wav") --Romenski to Karn, I took out artill. Will secure perimeter
		ClearObjectives()
		AddObjective("tcrb0502.txt")
		SetObjectiveName(x.fhng, "Fury Research")
		SetObjectiveOn(x.fhng)
		for index = 1, 5 do
			x.poolobject[index] = BuildObject("apcamrs", 5, ("fnav%d"):format(index))
		end
		SetScrap(1, 40)
		x.waittime = GetTime() + 90.0
		x.spine = x.spine + 1
	end
	
	--START BDS ATTACK
	if x.spine == 12 and x.waittime < GetTime() then
		x.eatkallow = true
		x.eatklength = 7
		x.spine = x.spine + 1
	end
	
	--BUILD BDS RECYCLER
	if x.spine == 13 and x.eatkcount >= 5 then
		x.ercystate = 1 
		x.ercytime = GetTime() 
		x.ercyhealth = GetODFInt("bbrecy.odf", "GameObjectClass", "maxHealth", 0) --need to init
		x.spine = x.spine + 1
	end
	
	--BDS RECYCLER KILLED - WINNER WINNER WINNER
	if x.spine == 14 and x.ercylives and not IsAlive(x.ercy) then 
		x.eatkallow = false
		x.ewardeclare = false
		AudioMessage("tcrb0508.wav") --SUCCEED - pos on Titan assured
		ClearObjectives()
		AddObjective("tcrb0504.txt", "GREEN")
		SucceedMission(GetTime() + 12.0, "tcrb05w1.des") --WINNER WINNER WINNER
		x.spine = 666
		x.MCAcheck = true
	end	
	----------END MAIN SPINE ----------
	
	--RUN CAM 1
	if x.cam1 then
		CameraPath("pcam1", 4200, 2200, x.fhng)
	end
	
	--ENSURE PLAYER CAN'T DO ANYTHING WHILE IN DROPSHIP ----------------------------
	if not x.free_player then
		x.controls = {braccel = 0, strafe = 0, jump = 0, deploy = 0, eject = 0, abandon = 0, fire = 0}
		SetControls(x.player, x.controls)
	end
	
	--SPOT OUT THE BIO-METAL POOLS
	if x.poolall < 5 and x.spine > 11 then
		for index = 1, 5 do
			if not x.poolmark[index] then
				x.pooltank = GetNearestEnemy(x.poolobject[index], 0, 0, 450.0)
				if GetDistance(x.pooltank, ("fnav%d"):format(index)) < 300 then
					RemoveObject(x.poolobject[index])
					StartSoundEffect("emspin.wav") --world zoom 6s plus long silence keep as sfx
					x.fnav[index] = BuildObject("apcamrs", 1, ("fnav%d"):format(index))
					SetObjectiveName(x.fnav[index], "Bio-metal pool")
					SetObjectiveOn(x.fnav[index])
					x.poolmark[index] = true
					x.poolall = x.poolall + 1
				end
				x.pooltank = nil
			end
		end
	end
	
	--RANDOMLY BUILD AND MOVE AI RECYCLER
	if x.ercystate == 1 and x.ercytime < GetTime() and (not x.ercystart or (IsAlive(x.ercy) and GetDistance(x.player, x.ercy) > 600)) then
		x.ewardeclare = false
		if IsAlive(x.ercy) then
			x.ercyhealth = GetCurHealth(x.ercy)
			RemoveObject(x.ercy) --Remove old base
		end
		for index = 1, 4 do
			if IsAlive(x.epwr[index]) then
				RemoveObject(x.epwr[index])
			end
			if IsAlive(x.egun[index]) then
				RemoveObject(x.egun[index])
			end
			if IsAlive(x.etnk[index]) then
				RemoveObject(x.etnk[index])
			end
		end
		if x.ercystart then
			AudioMessage("alertpulse.wav")
			ClearObjectives()
			AddObjective("Enemy Recycler on the move. Standby to reaquire target.", "YELLOW")
		end
		x.ercystart = true
		x.ercylives = false
		x.ercytime = GetTime() + 120.0
		x.ercystate = 2
	elseif x.ercystate == 2 and x.ercytime < GetTime() then
		while x.ercylocation == x.ercylocationold do
			for index = 1, 10 do
				x.ercylocation = math.floor(GetRandomFloat(1.0,4.0))
			end
		end
		x.ercylocationold = x.ercylocation
		x.ercy = BuildObject("bbrecy", 5, ("eprcy%d"):format(x.ercylocation))
		for index = 1, 4 do
			x.epwr[index] = BuildObject("bbpgen2", 5, ("eppwr%d_%d"):format(x.ercylocation, index))
			x.egun[index] = BuildObject("bbgtow", 5, ("epgun%d_%d"):format(x.ercylocation, index))
			x.etnk[index] = BuildObject("bvtank", 5, ("epgun%d_%d"):format(x.ercylocation, index))
			SetSkill(x.etnk[index], 3)
			Defend2(x.etnk[index], x.egun[index])
			x.etnk[index+4] = BuildObject("bvtank", 5, GetPositionNear(("epgun%d_%d"):format(x.ercylocation, index), 0, 16, 32))
			SetSkill(x.etnk[index+4], 3)
			Defend2(x.etnk[index+4], x.ercy)
		end 
		SetObjectiveOn(x.ercy)
		SetCurHealth(x.ercy, x.ercyhealth)
		for index = 1, x.ewartotal do --init WARCODE
			x.ewardeclare = true
			x.ewarrior[index] = {} --"rows"
			for index2 = 1, 10 do --10 per wave max avail
				x.ewarrior[index][index2] = nil --"columns", init (handle in this case)
			end
			x.ewartrgt[index] = nil
			x.ewarstate[index] = 1
			x.ewartime[1] = GetTime() + 10.0 --recy
			x.ewartime[2] = GetTime() + 25.0 --fact
			x.ewartime[3] = GetTime() + 40.0 --armo
			x.ewartime[4] = GetTime() + 55.0 --base
			x.ewartimecool[index] = 60.0
			x.ewartimeadd[index] = 5.0
			x.ewarabort[index] = 99999.9
			x.ewarsize[index] = 0
			x.ewarwave[index] = 0
			x.ewarwavemax[index] = 5
			x.ewarwavereset[index] = 2
			x.ewarmeet[index] = 2
		end
		AudioMessage("tcrb0506.wav") --Orbital sensors have found BDS Recy. Destroy it.
		ClearObjectives()
		AddObjective("tcrb0503.txt")
		AddObjective("	")
		x.ercytime = GetTime() + 600.0
		x.ercystate = 3
		x.ercylives = true
	elseif x.ercystate == 3 and x.ercytime < GetTime() then
		x.ercystate = 1
	end
	
	--BDS RANDOM ATTACK ----------------------------------
	if x.eatkallow then 
		if x.eatkstate == 0 or x.eatkstate == 2 then
			for index = 1, x.eatklength do
				if not IsAlive(x.eatk[index]) then
					x.casualty = x.casualty + 1
				end
			end
			if x.casualty >= x.eatklength - 1 then
				x.eatkstate = 1
				x.eatkbuildtime = GetTime() + 60.0 --90.0
			end
			x.casualty = 0
		end
		
		if x.eatkstate == 1 and x.eatkbuildtime < GetTime() then
			for index = 1, 30 do --random the random
				x.randomspn = math.floor(GetRandomFloat(1.0, 4.0))
			end
			for index = 1, x.eatklength do
				while x.randompick == x.randomlast do --random the random
					x.randompick = math.floor(GetRandomFloat(1.0, 18.0))
				end
				x.randomlast = x.randompick
				if x.randompick == 1 or x.randompick == 6 then
					x.eatk[index] = BuildObject("bvscout", 5, GetPositionNear(("espn%d_%d"):format(x.randomspn, index), 0, 16, 32))
				elseif x.randompick == 2 or x.randompick == 7 or x.randompick == 11 or x.randompick == 15 then
					x.eatk[index] = BuildObject("bvmbike", 5, GetPositionNear(("espn%d_%d"):format(x.randomspn, index), 0, 16, 32))
				elseif x.randompick == 3 or x.randompick == 8 or x.randompick == 12 or x.randompick == 16 then
					x.eatk[index] = BuildObject("bvmisl", 5, GetPositionNear(("espn%d_%d"):format(x.randomspn, index), 0, 16, 32))
				elseif x.randompick == 4 or x.randompick == 9 or x.randompick == 13 or x.randompick == 17 then
					x.eatk[index] = BuildObject("bvtank", 5, GetPositionNear(("espn%d_%d"):format(x.randomspn, index), 0, 16, 32))
				elseif x.randompick == 5 or x.randompick == 10 or x.randompick == 14 then
					x.eatk[index] = BuildObject("bvrckt", 5, GetPositionNear(("espn%d_%d"):format(x.randomspn, index), 0, 16, 32))
				else --18
					x.eatk[index] = BuildObject("bvartl", 5, GetPositionNear(("espn%d_%d"):format(x.randomspn, index), 0, 16, 32))
				end
				SetEjectRatio(x.eatk[index], 0.0)
				SetSkill(x.eatk[index], x.skillsetting)
			end
			x.eatkresendtime = GetTime()
			x.eatkcount = x.eatkcount + 1 --to setup bds recy spawn
			x.eatknotify = true
			x.eatkstate = 2
		end
		
		if x.eatkstate == 2 and x.eatkresendtime < GetTime() then
			for index = 1, x.eatklength do
				Attack(x.eatk[index], x.fhng)
			end
			x.eatkresendtime = GetTime() + 30.0
		end
		
		if x.eatknotify then
			for index = 1, x.eatklength do
				if x.eatknotify and IsAlive(x.eatk[index]) and GetDistance(x.eatk[index], x.fhng) < 700 then
					AudioMessage("tcrb0505.wav") --Incoming NSDF attack wave.
					x.eatknotify = false
				end
			end
		end
	end
	
	--WARCODE (non-AIP or temp AIP replacement)
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
						x.ewarsize[index] = 3
					elseif x.ewarwave[index] == 3 then
						x.ewarsize[index] = 4
					elseif x.ewarwave[index] == 4 then
						x.ewarsize[index] = 5
					else --5
						x.ewarsize[index] = 8
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
						if x.randompick == 1 or x.randompick == 8 or x.randompick == 15 then
							x.ewarrior[index][index2] = BuildObject("bvscout", 5, GetPositionNear(("epgrcy%d"):format(x.ercylocation), 0, 16, 32))
							if x.ewarwave[index] == 3 or x.ewarwave[index] == 4 then
								GiveWeapon(x.ewarrior[index][index2], "glasea_c")
							end
						elseif x.randompick == 2 or x.randompick == 9 or x.randompick == 16 then
							x.ewarrior[index][index2] = BuildObject("bvmbike", 5, GetPositionNear(("epgrcy%d"):format(x.ercylocation), 0, 16, 32))
							if x.ewarwave[index] == 2 or x.ewarwave[index] == 4 then
								GiveWeapon(x.ewarrior[index][index2], "gstbva_c")
							end
						elseif x.randompick == 3 or x.randompick == 10 or x.randompick == 17 then
							x.ewarrior[index][index2] = BuildObject("bvmisl", 5, GetPositionNear(("epgrcy%d"):format(x.ercylocation), 0, 16, 32))
							if x.ewarwave[index] == 3 or x.ewarwave[index] == 5 then
								GiveWeapon(x.ewarrior[index][index2], "gfafma_c")
							end
						elseif x.randompick == 4 or x.randompick == 11 or x.randompick == 18 then
							x.ewarrior[index][index2] = BuildObject("bvtank", 5, GetPositionNear(("epgrcy%d"):format(x.ercylocation), 0, 16, 32))
						elseif x.randompick == 5 or x.randompick == 12 then
							x.ewarrior[index][index2] = BuildObject("bvrckt", 5, GetPositionNear(("epgrcy%d"):format(x.ercylocation), 0, 16, 32))
							if x.ewarwave[index] == 3 or x.ewarwave[index] == 5 then
								GiveWeapon(x.ewarrior[index][index2], "gshdwa_a") --salvo rckt
							end
						elseif x.randompick == 6 or x.randompick == 13 then
							if x.ewarwave[index] == 1 or x.ewarwave[index] == 2 then
								x.ewarrior[index][index2] = BuildObject("bvstnk", 5, GetPositionNear(("epgrcy%d"):format(x.ercylocation), 0, 16, 32))
							end
						else
								x.ewarrior[index][index2] = BuildObject("bvtank", 5, GetPositionNear(("epgrcy%d"):format(x.ercylocation), 0, 16, 32))
						end
						SetEjectRatio(x.ewarrior[index][index2], 0.0)
						if index2 % 3 == 0 then
							SetSkill(x.ewarrior[index][index2], x.skillsetting+1)
						end
						SetSkill(x.ewarrior[index][index2], x.skillsetting)
					end
					x.ewarabort[index] = GetTime() + 360.0 --here first in case stage goes wrong
					x.ewarstate[index] = x.ewarstate[index] + 1
				end
				--NO STAGE POINT
				--GIVE ATTACK ORDER
				if x.ewarstate[index] == 3 then
					for index2 = 1, x.ewarsize[index] do
						if IsAlive(x.ewarrior[index][index2]) then
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
								--SetObjectiveName(x.ewarrior[index][index2], ("Recy Killer %d"):format(index2))
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
								--SetObjectiveName(x.ewarrior[index][index2], ("Fact Killer %d"):format(index2))
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
								--SetObjectiveName(x.ewarrior[index][index2], ("Armo Killer %d"):format(index2))
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
								--SetObjectiveName(x.ewarrior[index][index2], ("Kill Base %d"):format(index2))
							else --safety call --shouldn't ever run
								x.ewartrgt[index] = x.player
								--SetObjectiveName(x.ewarrior[index][index2], ("Mass Assassin %d"):format(index2))
							end
							Attack(x.ewarrior[index][index2], x.ewartrgt[index])
							x.ewarabort[index] = x.ewartime[index] + 420.0
						end
					end
					x.ewarstate[index] = x.ewarstate[index] + 1
				end
				
				--CHECK CASUALTY AND RESET
				if x.ewarstate[index] == 4 then
					for index2 = 1, x.ewarsize[index] do
						if not IsAlive(x.ewarrior[index][index2]) or (IsAlive(x.ewarrior[index][index2]) and GetTeamNum(x.ewarrior[index][index2]) == 1) then
							x.casualty = x.casualty + 1
						end
					end
					if x.casualty >= math.floor(x.ewarsize[index] * 0.8) then
						x.ewarabort[index] = 99999.9
						x.ewartime[index] = GetTime() + x.ewartimecool[index] + x.ewartimeadd[index]
						--NO RELIEF PERIOD THIS MISSION, ADD TO TIME ADD INSTEAD
						x.ewartimeadd[index] = x.ewartimeadd[index] + 5.0
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

	--CHECK STATUS OF MCA ----------------------------------
	if not x.MCAcheck then				
		if not x.playfail and (not IsAlive(x.frcy) or not IsAlive(x.fhng)) then --frecy OR fhng killed
			ClearObjectives()
			if not IsAlive(x.frcy) then
				AddObjective("tcrb0505.txt", "RED")
				x.audio1 = AudioMessage("tcrb0507.wav") --FAIL - lost recy
				x.spine = 666
			else
				AddObjective("tcrb0506.txt", "RED")
				x.audio1 = AudioMessage("tcrb0509add.wav") --ADDED - FAIL - go to siberia
				x.spine = 666
			end
			x.playfail = true
		end
		
		if x.playfail and IsAudioMessageDone(x.audio1) then
			FailMission(GetTime(), "tcrb05f1.des") --LOSER LOSER LOSER
			x.MCAcheck = true
		end
	end
end
--[[END OF SCRIPT]]