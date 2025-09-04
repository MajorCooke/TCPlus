--bztcrb01 - Battlezone Total Command - The Red Brigade - 1/8 - THE GOLEM AMBUSH
assert(load(assert(LoadFile("_requirefix.lua")),"_requirefix.lua"))();
TCC = require("TC_Core")
MisnNum = 15;
--DECLARE variables --f-friend, e-enemy, atk-attack, rcy-recycler, etc..., 
local index = 1
local index2 = 1
local indexadd = 1
local x = {
	FIRST = true,
	spine = 0,
	getiton = false, 
	MCAcheck = false,
	waittime = 99999.9,
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
	randompick = 0, 
	randomlast = 0,
	frcy = nil,
	ffac = nil,
	farm = nil,
	fcon = nil,
	fgrp = {},
	free_player = false, --dropship
	controls = {braccel = 0, strafe = 0, jump = 0, deploy = 0, eject = 0, abandon = 0, fire = 0}, 
	fdrp = {}, 
	holder = {}, 
	ercy = nil, --ai buildings
	efac = nil,
	earm = nil,
	ebay = nil, 
	ecom = nil, 
	etrn = nil, 
	etec = nil, 
	ehqr = nil, 
	esld = nil,	
	egun = {}, 
	esil = {},	 
	fwlk = nil,	 --friend Golem
	fwlkinposition = false, 
	fwlkmet = 0, 
	halfwaythere = false, 
	eatk = {}, --recy escort
	eatkorder = {}, 
	eatkalldead = false, 
	eatkdeadcount = 0, 
	eallyallow = false, --nsdf ally
	eally = {}, 
	eallytime = 99999.9, 
	eallypoint = 0, 
	ercyhurt = false, 
	ercystate = 0, 
	ercyhelptime = 99999.9, 
	eallyresend = 99999.9, 
	efacdead = false, 
	efactime = 99999.9, 
	esilkilled = false, 
	esilcount = 4, 
	number = 0, 
	numcount = 0, 
	apilo = nil, 
	eassallow = false, 
	emintime = 99999.9, --eminelayers
	emin = {}, 
	emingo = {}, 
	emincool = {}, 
	eminallow = {},
	eminelife = {}, 
	eturtime = 99999.9, --eturrets, 
	eturlength = 6,
	eturlife = {}, 
	etur = {}, 
	eturcool = {}, 
	eturallow = {},
	fpwr = {nil, nil, nil, nil}, 
	fhqr = nil,
	ftec = nil,
	ftrn = nil,
	fbay = nil,
	fcom = nil,
	fhqr = nil,
	fsld = nil, 
	ekillarttime = 99999.9, --artl asn
	ekillartlength = 4,
	ekillart = {}, 
	eartkilllife = {}, 
	fartlength = 10,
	fart = {},
	ekillartmarch = false,
	ekillarttarget = nil,
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
--Paths: fnav0-5, fpmeet1, fprcy, fpwlk, eprcy, epgrcy, epfac, epgfac, proute1-3, phalf1-3, pout1-2, stage1-2, pscrap, pscrap1-3 pcutout

function InitialSetup()
	SetAutoGroupUnits(true)
	
	local odfpreload = {
		"svrecyrb01", "svfactrb01", "svconsrb01", "svscout", "svmbike", "svmisl", "svtank", "svrckt", "svwalk", "svturr", 
		"avrecy", "avscout", "avmbike", "avmisl", "avtank", "avrckt",	"gstbsa_c", "stayput", "npscrx", "apcamrs", "radjam"
	}
	for k,v in pairs(odfpreload) do
		PreloadODF(v)
	end
	
	x.efac = GetHandle("efac")
	for index = 1, 4 do
		x.esil[index] = GetHandle(("esil%d"):format(index))
	end
	x.fdrp[1] = GetHandle("fdrp1")
	x.fdrp[2] = GetHandle("fdrp2")
	x.mytank = GetHandle("mytank")
	x.frcy = GetHandle("frcy")
	for index = 1, 6 do
		x.fgrp[index] = GetHandle(("fgrp%d"):format(index))
	end
	Ally(5, 6) --5 ai enemy nsdf
	Ally(6, 5) --6 nsdf ally
	SetTeamColor(6, 150, 100, 50) --flat copper	
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
	if (not IsAlive(x.farm) or x.farm == nil) and (IsOdf(h, "svarmo:1") or IsOdf(h, "sbarmo")) then
		x.farm = h
	elseif (not IsAlive(x.ffac) or x.ffac == nil) and (IsOdf(h, "svfactrb01:1") or IsOdf(h, "sbfactrb01")) then
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
	elseif IsOdf(h, "sbpgen1") then
		for indexadd = 1, 4 do
			if x.fpwr[indexadd] == nil or not IsAlive(x.fpwr[indexadd]) then
				x.fpwr[indexadd] = h
				break
			end
		end
	end
	
	for indexadd = 1, x.fartlength do --new artillery? 
		if (not IsAlive(x.fart[indexadd]) or x.fart[indexadd] == nil) and IsOdf(h, "svartl:1") then
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
	--Set up mission basics
	if x.spine == 0 then
		x.pos = GetTransform(x.mytank)
		RemoveObject(x.mytank)
		x.mytank = BuildObject("svtank", 1, x.pos)
		GiveWeapon(x.mytank, "gstbsa_c")
		SetAsUser(x.mytank, 1)
		RemoveObject(x.player)
		x.player = GetPlayerHandle()
		x.pos = GetTransform(x.fgrp[1])
		RemoveObject(x.fgrp[1])
		x.fgrp[1] = BuildObject("svscout", 1, x.pos)
		x.pos = GetTransform(x.fgrp[2])
		RemoveObject(x.fgrp[2])
		x.fgrp[2] = BuildObject("svmbike", 1, x.pos)
		x.pos = GetTransform(x.fgrp[3])
		RemoveObject(x.fgrp[3])
		x.fgrp[3] = BuildObject("svmisl", 1, x.pos)
		x.pos = GetTransform(x.fgrp[4])
		RemoveObject(x.fgrp[4])
		x.fgrp[4] = BuildObject("svtank", 1, x.pos)
		x.pos = GetTransform(x.fgrp[5])
		RemoveObject(x.fgrp[5])
		x.fgrp[5] = BuildObject("svturr", 1, x.pos)
		x.pos = GetTransform(x.fgrp[6])
		RemoveObject(x.fgrp[6])
		x.fgrp[6] = BuildObject("svturr", 1, x.pos)
		x.pos = GetTransform(x.frcy)
		RemoveObject(x.frcy)
		x.frcy = BuildObject("svrecyrb01", 1, x.pos)
		SetSkill(x.frcy, x.skillsetting)
		for index = 1, 6 do
			SetSkill(x.fgrp[index], x.skillsetting)
		end
		for index = 1, 4 do
			SetGroup(x.fgrp[index], 0)
		end
		SetSkill(x.frcy, x.skillsetting)
		SetGroup(x.fgrp[5], 5)
		SetGroup(x.fgrp[6], 5)
		SetGroup(x.frcy, 4)
		x.ercy = BuildObject("avrecy", 5, GetPositionNear("epgrcy", 0, 16, 32)) --grpspwn
		SetObjectiveName(x.ercy, "COLORADO muf")
		x.eatk[1] = BuildObject("avmbike", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
		x.eatk[2] = BuildObject("avmisl", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
		x.eatk[3] = BuildObject("avtank", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
		x.eatk[4] = BuildObject("avrckt", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
		x.eatk[5] = BuildObject("avmbike", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
		x.eatk[6] = BuildObject("avmisl", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
		x.eatk[7] = BuildObject("avtank", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
		x.eatk[8] = BuildObject("avrckt", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
		x.eatk[9] = BuildObject("avmbike", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
		x.eatk[10] = BuildObject("avmisl", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
		x.eatk[11] = BuildObject("avtank", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
		x.eatk[12] = BuildObject("avrckt", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
		x.eatk[13] = BuildObject("avmisl", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
		x.eatk[14] = BuildObject("avtank", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
		x.eatk[15] = BuildObject("avrckt", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
		for index = 1, 15 do --init this
			x.eatkorder[index] = false
		end
		x.eatk[16] = BuildObject("avturr", 5, "phalf1")
		x.eatk[17] = BuildObject("avturr", 5, "phalf2")
		x.eatk[18] = BuildObject("avturr", 5, "phalf3")
		for index = 1, 18 do
			SetSkill(x.eatk[index], x.skillsetting)
			SetEjectRatio(x.eatk[index], 0.0)
		end
		for index = 1, 3 do --initial spice just cuz
			x.eally[index] = BuildObject("avrckt", 6, "pout1")
			SetEjectRatio(x.eally[index], 0.0)
			SetSkill(x.eally[index], x.skillsetting)
			Attack(x.eally[index], x.frcy)
		end
		x.ercyhelptime = 0.0 --init
		x.audio1 = AudioMessage("tcrb0101.wav") --INTRO - Amer advancing. 3 approaches. move force to ambush
		x.spine = x.spine + 1
	end

	--DROPSHIP LANDING SEQUENCE - START QUAKE FOR FLYING EFFECT
	if x.spine == 1 then
		for index = 1, 2 do
			for index2 = 1, 4 do --CCA dropship 4 emits
				StopEmitter(x.fdrp[index], index2)
			end
		end
		for index = 1, 6 do
			Stop(x.fgrp[index])
			x.holder[index] = BuildObject("stayput", 0, x.fgrp[index]) --fdrp1 dropship 1
		end
		x.holder[7] = BuildObject("stayput", 0, x.frcy) --fdrp2 dropship 2
    x.holder[8] = BuildObject("radjam", 5, x.player)
		x.holder[9] = BuildObject("stayput", 0, x.player) --fdrp1 dropship 1
		Stop(x.frcy) --Prevent player giving orders in dropship
		StartEarthQuake(10.0)
		x.waittime = GetTime() + 8.0
		x.spine = x.spine + 1
	end

	--LANDING - MAKE QUAKE BIGGERR
	if x.spine == 2 and x.waittime < GetTime() then
		UpdateEarthQuake(50.0)
		x.waittime = GetTime() + 3.0
		x.spine = x.spine + 1
	end
	
	--HAVE LANDED - STOP QUAKE
	if x.spine == 3 and x.waittime < GetTime() then
		StopEarthQuake()
		x.waittime = GetTime() + 2.0
		x.spine = x.spine + 1
	end

	--OPEN DROPSHIP DOORS, REMOVE HOLDERS
	if x.spine == 4 and x.waittime < GetTime() then
		StartSoundEffect("dropdoor.wav")
		SetAnimation(x.fdrp[1], "open", 1)
		SetAnimation(x.fdrp[2], "open", 1)
		for index = 1, 8 do --player is later
			RemoveObject(x.holder[index])
		end
		x.waittime = GetTime() + 5.0
		x.spine = x.spine + 1
	end
	
	--DOORS FULLY OPEN, GIVE MOVE ORDER
	if x.spine == 5 and x.waittime < GetTime() then
		Goto(x.frcy, "fprcy", 0)
		for index = 1, 6 do
			Goto(x.fgrp[index], "fpmeet1", 0)
		end
		x.waittime = GetTime() + 1.0
		for index = 1, 100 do
			x.scrap = BuildObject("npscrx", 0, "pscrap", index)
		end
		for index = 1, 20 do
			x.scrap = BuildObject("npscrx", 0, "pscrap1", index)
			x.scrap = BuildObject("npscrx", 0, "pscrap2", index)
			x.scrap = BuildObject("npscrx", 0, "pscrap3", index)
		end
		x.spine = x.spine + 1
	end

	--GIVE PLAYER CONTROL OF THEIR AVATAR
	if x.spine == 6 and x.waittime < GetTime() then
		RemoveObject(x.holder[9])
		x.free_player = true
		x.spine = x.spine + 1
	end
	
	--CHECK IF PLAYER HAS LEFT DROPSHIP
	if x.spine == 7 then
		x.player = GetPlayerHandle()
		if IsCraftButNotPerson(x.player) and GetDistance(x.player, x.fdrp[1]) > 60 then
			SetScrap(1, 40)
			SetScrap(5, 40)
			x.fnav = BuildObject("apcamrs", 1, "fnav0")
			SetObjectiveName(x.fnav, "CCA base")
			x.fnav = BuildObject("apcamrs", 1, "fnav1")
			SetObjectiveName(x.fnav, "Upper Pass")
			x.fnav = BuildObject("apcamrs", 1, "fnav2")
			SetObjectiveName(x.fnav, "Middle Pass")
			x.fnav = BuildObject("apcamrs", 1, "fnav3")
			SetObjectiveName(x.fnav, "Lower Pass")
			x.fnav = BuildObject("apcamrs", 1, "fnav4")
			SetObjectiveName(x.fnav, "Cutoff")
			x.fnav = BuildObject("apcamrs", 1, "fnav5")
			SetObjectiveName(x.fnav, "NSDF base")
			ClearObjectives()
			AddObjective("tcrb0101.txt") --Ambush the American recycler Colorado ... Valanov must survive.
			x.spine = x.spine + 1
		end
	end

	--DROPSHIP 1 TAKEOFF
	if x.spine == 8 then
		for index = 1, 2 do
			for index2 = 1, 10 do
				StartEmitter(x.fdrp[index], index2)
			end
		end
		SetAnimation(x.fdrp[1], "takeoff", 1)
		StartSoundEffect("dropleav.wav", x.fdrp[1])
		x.waittime = GetTime() + 2.0
		x.spine = x.spine + 1
	end

	--DROPSHIP 2 TAKEOFF
	if x.spine == 9 and x.waittime < GetTime() then
		for index = 1, 10 do
			StartEmitter(x.fdrp[2], index)
		end
		SetAnimation(x.fdrp[2], "takeoff", 1)
		StartSoundEffect("dropleav.wav", x.fdrp[2])
		x.waittime = GetTime() + 15.0
		x.spine = x.spine + 1
	end

	--REMOVE DROPSHIPS
	if x.spine == 10 and x.waittime < GetTime() then
		RemoveObject(x.fdrp[1])
		RemoveObject(x.fdrp[2])
		x.spine = x.spine + 1
	end

	--Remove repel, start NSDF turrets
	if x.spine == 11 then
		x.holder[1] = BuildObject("repelenemy200", 5, "phalf1") --go away, come back later
		x.holder[2] = BuildObject("repelenemy200", 5, "phalf2") --go away, come back later
		x.holder[3] = BuildObject("repelenemy200", 5, "phalf3") --go away, come back later
		x.eturtime = GetTime()
		for index = 1, x.eturlength do --init etur
			x.eturcool[index] = GetTime()
			x.eturallow[index] = true
			x.eturlife[index] = 0
		end
		x.emintime = GetTime() + 60.0 --init emin
		for index = 1, 2 do --init emin
			x.emincool[index] = GetTime()
			x.eminallow[index] = true
			x.eminelife[index] = 0
		end
		x.waittime = GetTime() + 240.0 --ercy start time
		x.spine = x.spine + 1
	end

	--Pick route and send nsdf recycler
	if x.spine == 12 and x.waittime < GetTime() then
		while x.numcount < 10 do --give more chances to randomize "number"
			while x.randompick == x.randomlast do --random the random
				x.randompick = math.floor(GetRandomFloat(1.0,9.0))
			end
			x.randomlast = x.randompick
			x.numcount = x.numcount + 1 --end of randomize "number"
		end
		if x.randompick == 1 or x.randompick == 4 or x.randompick == 7 or x.randompick == 9 then
			x.number = 1 --lower
		elseif x.randompick == 2 or x.randompick == 5 or x.randompick == 8 then
			x.number = 2 --middle
		else
			x.number = 3 --upper
		end
		Goto(x.ercy, ("proute%d"):format(x.number)) --send out ercy
		for index = 11, 15 do
			Defend2(x.eatk[index], x.ercy)
		end
		x.waittime = GetTime() + 30.0
		x.spine = x.spine + 1
	end
	
	--Notify NSDF underway and send point group
	if x.spine == 13 and x.waittime < GetTime() then
		AudioMessage("tcrb0125.wav") --Americans are getting underway
		AddObjective("	")
		AddObjective("tcrb0102.txt", "YELLOW") --The American recycler is moving out.
		for index = 1, 10 do --send out point group AFTER recy
			Goto(x.eatk[index], ("proute%d"):format(x.number))
		end
		x.spine = x.spine + 1
	end
	
	--Notify Recycler route
	if x.spine == 14 then
		if GetDistance(x.ercy, "proute1") < 64 then
			AudioMessage("tcrb0115.wav") --Recy enter LOWER pass.
			ClearObjectives()
			AddObjective("tcrb0103.txt", "ALLYBLUE") --The Colorado is taking the Lower pass.	Deploy forces at pass beacon to destroy it.
			x.spine = x.spine + 1
			x.waittime = GetTime() + 5.0
		elseif GetDistance(x.ercy, "proute2") < 64 then
			AudioMessage("tcrb0116.wav") --Recy enter MIDDLE pass.
			ClearObjectives()
			AddObjective("tcrb0104.txt", "ALLYBLUE") --The Colorado is taking the Middle pass.	Deploy forces at pass beacon to destroy it.
			x.spine = x.spine + 1
			x.waittime = GetTime() + 5.0
		elseif GetDistance(x.ercy, "proute3") < 64 then
			AudioMessage("tcrb0117.wav") --Recy enter UPPER pass.
			ClearObjectives()
			AddObjective("tcrb0105.txt", "ALLYBLUE") --The Colorado is taking the Upper pass.	Deploy forces at pass beacon to destroy it.
			x.spine = x.spine + 1
			x.waittime = GetTime() + 3.0
		end
	end
	
	--Move Golem into position and remove repel
	if x.spine == 15 and x.waittime < GetTime() then
		RemoveObject(x.holder[1])
		RemoveObject(x.holder[2])
		RemoveObject(x.holder[3])
		x.fwlk = BuildObject("svwalk", 1, "fpwlk")
		SetSkill(x.fwlk, x.skillsetting)
		SetGroup(x.fwlk, 9)
		Goto(x.fwlk, "fpwlk", 0)
		AudioMessage("emdotcox.wav") --("alertpulse.wav")
		--AddObjective("tcrb0106.txt") --The blockade Golem is on the move.
		x.spine = x.spine + 1
	end
	
	--NSDF BASE DESTROYED SUCCEED MISSION
	if x.spine == 16 and not IsAlive(x.ercy) and not IsAlive(x.efac) and x.efactime < GetTime() then --amuf dead and muf dead
		AudioMessage("tcrb0110.wav") --SUCCESS - Karnov will be pleased
		ClearObjectives()
		AddObjective("tcrb0112.txt", "GREEN") --American base destroyed.	MISSION COMPLETE!
		x.efacdead = true
		SucceedMission(GetTime() + 20.0, "tcrb01w1.des") --WINNER WINNER WINNER
		x.spine = 666
		x.MCAcheck = true
	end
	----------END MAIN SPINE ----------
	
	--ENSURE PLAYER CAN'T DO ANYTHING WHILE IN DROPSHIP ----------------------------
	if not x.free_player then
		x.controls = {braccel = 0, strafe = 0, jump = 0, deploy = 0, eject = 0, abandon = 0, fire = 0}
		SetControls(x.player, x.controls)
	end
	
	--Notify Golem in position
	if not x.fwlkinposition and IsAlive(x.fwlk) and IsAlive(x.ercy) and GetDistance(x.fwlk, "fnav4") < 64 then
		AudioMessage("tcrb0123.wav") --Golem in position
		--AddObjective("tcrb0107.txt") --The blockade Golem has reached the Cutoff point.
		x.fwlkinposition = true
	end
	
	--Golem and nsdf recycler interaction
	if IsAlive(x.fwlk) and IsAlive(x.ercy) and x.fwlkmet < 3 then
		if x.fwlkmet == 0 and (GetDistance(x.ercy, x.fwlk) < 220) then
			Attack(x.fwlk, x.ercy, 0)
			x.fwlkmet = 1
		elseif x.fwlkmet == 1 and (GetDistance(x.ercy, x.fwlk) < 180) then
			x.fwlkmet = 2
		elseif x.fwlkmet == 2 and ((GetDistance(x.ercy, x.fwlk) > 230) or (GetDistance(x.ercy, "eprcy") < 200)) then
			AudioMessage("tcrb0124.wav") --Amer Recy slipped past the Golem and avoid blockade
			x.fwlkmet = 3
		end
	end
	
	--NSDF Recycler proximity to base
	if x.ercystate == 0 and IsAlive(x.ercy) and (GetDistance(x.ercy, "eprcy") > 150) then
		x.ercystate = 1
	elseif x.ercystate == 1 and IsAlive(x.ercy) and (GetDistance(x.ercy, "eprcy") < 150) then
		x.fwlkmet = 3
		AudioMessage("tcrb0106.wav") --Recy back to base. Will be difficult to dest them now.
		ClearObjectives()
		AddObjective("tcrb0109.txt", "YELLOW") --The Colorado has reached the American base.
		AddObjective("tcrb0111.txt") --Destroy the American attack outpost at nav beacon NSDF base.
		Dropoff(x.ercy, "eprcy") --"dropoff path" must be different from path unit used to get to it
		x.ercystate = 2
	elseif x.ercystate == 2 and IsAlive(x.ercy) and IsDeployed(x.ercy) then
		x.fwlkmet = 3
		x.eallyallow = true
		x.ercyhelptime = -60.0 --ensure less time between enemy reinforcements
		x.eallytime = GetTime() + x.ercyhelptime + 420.0 --ai group --sample for later
		x.ercystate = 3
	elseif x.ercystate < 4 and not IsAlive(x.ercy) then
		x.fwlkmet = 3
		AudioMessage("tcrb0105.wav") --Recy dead. Move on to Amer base.
		ClearObjectives()
		AddObjective("tcrb0110.txt", "ALLYBLUE") --The Colorado has been destroyed.
		AddObjective("tcrb0111.txt") --Destroy the American attack outpost at nav beacon NSDF base.
		x.ercyhurt = true
		x.eallyallow = true
		x.eallytime = GetTime() + 420.0 --ai group
		x.ercystate = 5
	end
	
	--Check NSDF Recycler position
	if not x.halfwaythere and not x.ercyhurt and IsAlive(x.ercy) then 
		if GetDistance(x.ercy, "phalf1") < 100 then
			AudioMessage("tcrb0104.wav") --Recy half through LOWER pass.
			x.halfwaythere = true
		elseif GetDistance(x.ercy, "phalf2") < 100 then
			AudioMessage("tcrb0103.wav") --Recy half through MIDDLE pass.
			x.halfwaythere = true
		elseif GetDistance(x.ercy, "phalf3") < 100 then
			AudioMessage("tcrb0102.wav") --Recy half through UPPER pass.
			x.halfwaythere = true
		end
	end
	
	--Check NSDF Recycler damage and if too far from pout1, retreat, otherwise press on
	if not x.ercyhurt and IsAlive(x.ercy) and (GetCurHealth(x.ercy) < math.floor(GetMaxHealth(x.ercy) * 0.8)) and (GetDistance(x.ercy, "pout1") >= 500) then
		Goto(x.ercy, "epgrcy") --NOT eprcy
		AudioMessage("tcrb0114.wav") --Recy fleeing. Finish them off b4 escape.
		ClearObjectives()
		AddObjective("tcrb0108.txt", "YELLOW") --The Colorado is retreating back to the American base.
		x.ercyhurt = true
	end
	
	--NSDF eatk force defend recy or hold ground
	if x.ercystate == 0 and IsAlive(x.ercy) then
		for index = 1, 10 do
			if IsAlive(x.eatk[index]) and not x.eatkorder[index] and GetDistance(x.eatk[index], ("fnav%d"):format(x.number)) < 100 then
				x.eatkorder[index] = true
				if IsAlive(x.ercy) then
					Defend2(x.eatk[index], x.ercy)
				else
					Defend(x.eatk[index])
				end
			end
		end
	end
	
	--Remove excess eatk
	if not x.eatkalldead and (not IsAlive(x.ercy) or IsDeployed(x.ercy)) then
		for index = 1, 15 do --only the first 15
			if IsAlive(x.eatk[index]) and GetDistance(x.eatk[index], "pout1") < 100 then 
				RemoveObject(x.eatk[index])
				if IsAlive(x.eatk[index]) then
					x.eatkdeadcount = x.eatkdeadcount + 1
				end
			end
		end
		if x.eatkdeadcount == 0 then
			x.eatkalldead = true
		end
		x.eatkdeadcount = 0
	end
	
	--NSDF reinforcements
	if x.eallyallow then
		if x.eallytime < GetTime() then
			AudioMessage("tcrb0122.wav") --Amer send units from NW
			x.eallypoint = 2
			if (IsAlive(x.ffac) and GetDistance(x.ffac, "pout1") <= GetDistance(x.ffac, "pout2")) or (GetDistance(x.player, "pout1") <= GetDistance(x.player, "pout2")) then
				x.eallypoint = 1
			end
			x.eally[1] = BuildObject("avscout", 6, ("pout%d"):format(x.eallypoint))
			x.eally[2] = BuildObject("avmbike", 6, ("pout%d"):format(x.eallypoint))
			x.eally[3] = BuildObject("avmisl", 6, ("pout%d"):format(x.eallypoint))
			x.eally[4] = BuildObject("avtank", 6, ("pout%d"):format(x.eallypoint))
			x.eally[5] = BuildObject("avrckt", 6, ("pout%d"):format(x.eallypoint))
			x.eally[6] = BuildObject("avscout", 6, ("pout%d"):format(x.eallypoint))
			x.eally[7] = BuildObject("avmbike", 6, ("pout%d"):format(x.eallypoint))
			x.eally[8] = BuildObject("avmisl", 6, ("pout%d"):format(x.eallypoint))
			x.eally[9] = BuildObject("avtank", 6, ("pout%d"):format(x.eallypoint))
			x.eally[10] = BuildObject("avrckt", 6, ("pout%d"):format(x.eallypoint))  	
			x.eally[11] = BuildObject("avtank", 6, ("pout%d"):format(x.eallypoint))  	
			x.eally[12] = BuildObject("avmisl", 6, ("pout%d"):format(x.eallypoint))  
			for index = 1, 12 do
				SetEjectRatio(x.eally[index], 0.0)
				SetSkill(x.eally[index], x.skillsetting)
			end
			x.eallytime = GetTime() + 600.0 + x.ercyhelptime
			x.eallyresend = GetTime()
		end
		
		if x.eallyresend < GetTime() then
			for index = 1, 5 do
				if IsAlive(x.ffac) and IsAlive(x.eally[index]) and GetTeamNum(x.eally[index]) ~= 1 then
					Attack(x.eally[index], x.ffac)
				elseif IsAlive(x.eally[index]) and GetTeamNum(x.eally[index]) ~= 1 then
					Attack(x.eally[index], x.frcy)
				end
			end
			for index = 6, 10 do
				if IsAlive(x.eally[index]) and GetTeamNum(x.eally[index]) ~= 1 then
					Attack(x.eally[index], x.frcy)
				end
			end
      if IsAlive(x.eally[11]) and GetTeamNum(x.eally[11]) ~= 1 then
        Attack(x.eally[11], x.player)
      end
      if IsAlive(x.eally[12]) and GetTeamNum(x.eally[12]) ~= 1 then
        Attack(x.eally[12], x.player)
      end
			x.eallyresend = GetTime() + 30.0
		end
	end
	
	--If NSDF silos destroyed, increase nsdf ally time
	if not x.esilkilled then
		for index = 1, x.esilcount do
			if not IsAlive(x.esil[index]) then
				x.casualty = x.casualty + 1
			end
		end
		if x.casualty == 2 then
			AudioMessage("tcrb0107.wav") --Silo eliminated.
			x.ercyhelptime = 60.0 --add in a minute between backup
			x.esilkilled = true
		end
		x.casualty = 0
	end
	
	--Start up regular attacks
	if not x.getiton and (not IsAlive(x.ercy) or IsDeployed(x.ercy)) then
		for index = 1, x.ewartotal do --init WARCODE
			x.ewardeclare = true
			x.ewarrior[index] = {} --"rows"
			x.ewartrgt[index] = {}
			for index2 = 1, 10 do --10 per wave max avail
				x.ewarrior[index][index2] = nil --"columns", init (handle in this case)
				x.ewartrgt[index][index2] = nil
			end
			x.ewarstate[index] = 1
			x.ewartime[1] = GetTime() + 30.0 --recy
			x.ewartime[2] = GetTime() + 90.0 --fact
			x.ewartime[3] = GetTime() + 120.0 --armo
			x.ewartime[4] = GetTime() + 150.0 --base
			x.ewartimecool[index] = 240.0
			x.ewartimeadd[index] = 0.0
			x.ewarabort[index] = 99999.9
			x.ewarsize[index] = 0
			x.ewarwave[index] = 0
			x.ewarwavemax[index] = 5
			x.ewarwavereset[index] = 2
			x.ewarmeet[index] = 2
		end
		for index = 1, x.ekillartlength do
			x.ekillarttime = GetTime() + 300.0
			x.eartkilllife[index] = 0
		end
		x.getiton = true
	end
	
	--NSDF GROUP TURRET GENERIC ----------------------------------
	if x.eturtime < GetTime() and IsAlive(x.ercy) then
		for index = 1, x.eturlength do
			if not IsAlive(x.etur[index]) and not x.eturallow[index] and x.eturlife[index] < 3 then
				x.eturcool[index] = GetTime() + 420.0 --ai group
				x.eturallow[index] = true
			end
			if x.eturallow[index] and x.eturcool[index] < GetTime() then
				x.etur[index] = BuildObject("avturr", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
				SetEjectRatio(x.etur[index], 0.0)
				SetSkill(x.etur[index], x.skillsetting)
				SetObjectiveName(x.etur[index], ("Badger %d"):format(index))
				Goto(x.etur[index], ("eptur%d"):format(index))
				x.eturallow[index] = false
				x.eturlife[index] = x.eturlife[index] + 1
			end
		end
		x.eturtime = GetTime() + 60.0
	end
	
	--WARCODE --special no efac, then stop
	if x.ewardeclare then
		for index = 1, x.ewartotal do	
			if x.ewartime[index] < GetTime() then 
			--SET WAVE NUMBER AND BUILD SIZE
				if x.ewarstate[index] == 1 then
					x.ewarwave[index] = x.ewarwave[index] + 1
					if x.ewarwave[index] > x.ewarwavemax[index] then
						x.ewarwave[index] = x.ewarwavereset[index]
					end
					if x.ewarwave[index] == 1 then --KEEP SIZES SIMPLE
						x.ewarsize[index] = 2
					elseif x.ewarwave[index] == 2 then
						x.ewarsize[index] = 2
					elseif x.ewarwave[index] == 3 then
						x.ewarsize[index] = 3
					elseif x.ewarwave[index] == 4 then
						x.ewarsize[index] = 4
					else --x.ewarwave[index] == 5 then
						x.ewarsize[index] = 5
					end
					x.ewarstate[index] = x.ewarstate[index] + 1
				end
				
			--BUILD FORCE
				if x.ewarstate[index] == 2 then
					for index2 = 1, x.ewarsize[index] do
						while x.randompick == x.randomlast do --random the random
							x.randompick = math.floor(GetRandomFloat(1.0, 15.0))
						end
						x.randomlast = x.randompick
						if x.randompick == 1 or x.randompick == 6 or x.randompick == 10 or x.randompick == 14 then
							if IsAlive(x.ercy) then
								x.ewarrior[index][index2] = BuildObject("avscout", 5, GetPositionNear("epgrcy", 0, 16, 32)) --grpspwn
							else
								x.ewarrior[index][index2] = BuildObject("avmbike", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
							end
							if x.ewarwave[index] == 3 or x.ewarwave[index] == 4 then
								GiveWeapon(x.ewarrior[index][index2], "gstbsa_c")
							end
						elseif x.randompick == 2 or x.randompick == 7 or x.randompick == 11 or x.randompick == 15 then
							x.ewarrior[index][index2] = BuildObject("avmbike", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
							if x.ewarwave[index] == 2 or x.ewarwave[index] == 4 then
								GiveWeapon(x.ewarrior[index][index2], "gstbva_c")
							end
						elseif x.randompick == 3 or x.randompick == 8 or x.randompick == 12 then
							x.ewarrior[index][index2] = BuildObject("avmisl", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
							if x.ewarwave[index] == 3 or x.ewarwave[index] == 5 then
								GiveWeapon(x.ewarrior[index][index2], "gfafma_c")
							end
						elseif x.randompick == 4 or x.randompick == 9 or x.randompick == 13 then
							x.ewarrior[index][index2] = BuildObject("avtank", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
							if x.ewarwave[index] == 4 or x.ewarwave[index] == 5 then
								GiveWeapon(x.ewarrior[index][index2], "gstbsa_c")
							end
						else
							x.ewarrior[index][index2] = BuildObject("avrckt", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
							if x.ewarwave[index] == 5 then --make easier
								GiveWeapon(x.ewarrior[index][index2], "gshdwa_a") --salvo rckt
							end
						end
						SetEjectRatio(x.ewarrior[index][index2], 0.0)
						SetSkill(x.ewarrior[index][index2], x.skillsetting)
						--[[meh, used to use this alot, but taking it out	if index2 % 3 == 0 then
							SetSkill(x.ewarrior[index][index2], x.skillsetting+1)
						end--]]
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
									x.ewartrgt[index][index2] = x.frcy
								elseif IsAlive(x.ffac) then
									x.ewartrgt[index][index2] = x.ffac
								elseif IsAlive(x.farm) then
									x.ewartrgt[index][index2] = x.farm
								else
									x.ewartrgt[index][index2] = x.player
								end
								--SetObjectiveName(x.ewarrior[index][index2], ("Recy Killer %d"):format(index2))
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
								--SetObjectiveName(x.ewarrior[index][index2], ("Fact Killer %d"):format(index2))
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
								--SetObjectiveName(x.ewarrior[index][index2], ("Armo Killer %d"):format(index2))
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
								--SetObjectiveName(x.ewarrior[index][index2], ("Kill Base %d"):format(index2))
							else --safety call --shouldn't ever run
								x.ewartrgt[index][index2] = x.player
								--SetObjectiveName(x.ewarrior[index][index2], ("Mass Assassin %d"):format(index2))
							end
							Attack(x.ewarrior[index][index2], x.ewartrgt[index][index2])
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
			end
		end
		
		if not IsAlive(x.efac) then
			x.ewardeclare = false
		end
	end--WARCODE END

	--AI GROUP ARTILLERY ASSASSIN
	if x.ekillarttime < GetTime() and IsAlive(x.efac) then
		for index = 1, x.ekillartlength do
			if not IsAlive(x.ekillart[index]) and x.eartkilllife[index] < 3 then
				x.ekillart[index] = BuildObject("avtank", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
				SetSkill(x.ekillart[index], x.skillsetting)
				--SetObjectiveName(x.ekillart[index], "Artl Killer")
				x.eartkilllife[index] = x.eartkilllife[index] + 1
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
			x.ekillartmarch = false
		end
		x.ekillarttime = GetTime() + 180.0
	end

	--NSDF MINELAYER SQUAD ----------------------------------
	if x.emintime < GetTime() then
		for index = 1, 2 do
			if (not IsAlive(x.emin[index]) or (IsAlive(x.emin[index]) and GetTeamNum(x.emin[index]) == 1)) and not x.eminallow[index] and x.eminelife[index] < 3 then
				x.emincool[index] = GetTime() + 420.0 --ai group
				x.eminallow[index] = true
			end
			
			if x.eminallow[index] and x.emincool[index] < GetTime() then
				x.emin[index] = BuildObject("avmine", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
				SetEjectRatio(x.emin[index], 0.0)
				SetSkill(x.emin[index], x.skillsetting)
				--SetObjectiveName(x.emin[index], ("Unabomber %d"):format(index))
				Goto(x.emin[index], ("epmin%d"):format(index)) --resend orders
				x.emingo[index] = true
				x.eminallow[index] = false
				x.eminelife[index] = x.eminelife[index] + 1
				--x.emintime = GetTime() + 120.0
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
	end

	--CHECK STATUS OF MCA ----------------------------------
	if not x.MCAcheck then		
		if IsAlive(x.ercy) and GetDistance(x.ercy, "pout1") < 64 then --ercy got out
			AudioMessage("tcrb0109.wav") --FAIL – A1 Recy escaped
			AudioMessage("tcrb0111.wav") --FAIL – A2 You failed 
			ClearObjectives()
			AddObjective("tcrb0113.txt", "RED") --The Colorado has escaped.	MISSION FAILED!
			FailMission(GetTime() + 20.0, "tcrb01f1.des") --LOSER LOSER LOSER
			x.spine = 666
			x.MCAcheck = true
		end
		
		if not IsAlive(x.frcy) then --frecy killed
			AudioMessage("tcrb0112.wav") --FAIL - B1 Recy Valinov lost
			AudioMessage("tcrb0113.wav") --FAIL - B2 need more competent officer
			ClearObjectives()
			AddObjective("tcrb0114.txt", "RED") --The Valinov has been destroyed.	MISSION FAILED!
			FailMission(GetTime() + 20.0, "tcrb01f2.des") --LOSER LOSER LOSER
			x.spine = 666
			x.MCAcheck = true
		end
		
		if not x.efacdead and not IsAlive(x.efac) then --amuf dead
			AudioMessage("tcrb0108.wav") --Successfully eliminated Mobile Unit Factory
			x.efacdead = true
			x.efactime = GetTime() + 10.0 --length of msg
		end
	end
end
--[[END OF SCRIPT]]