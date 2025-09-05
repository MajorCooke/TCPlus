--bztcss15 - Battlezone Total Command - Stars and Stripes - 15/17 - STRIKE AT THE HEART
assert(load(assert(LoadFile("_requirefix.lua")),"_requirefix.lua"))();
TCC = require("TC_Core")
MisnNum = 55;
--DECLARE variables --f-friend, e-enemy, atk-attack, rcy-recycler, etc..., 
local index = 1
local index2 = 1
local indexadd = 1
local x = {
	FIRST = true, 
	getiton = false,
	MCAcheck = false,
	player = nil, 
	mytank = nil, 
	skillsetting = 0,
	easy = 0, 
	medium = 1, 
	hard = 2, --tried 1-3, in 185, 3 didn't seem to make any difference, 
	spine = 0, 
	waittime = 99999.9,
	fnav1 = nil,
	audio1 = nil,	
	audio2 = nil, 
	casualty = 0,
	randompick = 0, 
	randomlast = 0, 
	randomloc = 0, 
	randomlastloc = 0, 
	fallystart = false,
	fallytime = 99999.9,
	fallywaittime = 99999.9,
	fally = {},
	fallylength = 8,
	camplay = false,
	camtime = 99999.9,
  camfov = 60,  --185 default
	userfov = 90,  --seed
	eatk = {},
	missiontime = 99999.9,
	striketime = 99999.9,
	strikemsgreset = 99999.9,
	efacreset = false, 
	efactime = 99999.9, 
	egun = {}, 
	ercy = nil,
	efac = nil,
	earm = nil,
	esil = {}, 
	frcy = nil,
	ffac = nil,
	farm = nil,
	fcon = nil,
	camheight = 3000,
	emintime = 99999.9, --eminelayers
	emin = {}, 
	emingo = {}, 
	emincool = {}, 
	eminallow = {},
	eturtime = 99999.9, --eturrets, 
	eturlength = 6,
	etur = {}, 
	eturcool = {}, 
	eturallow = {},
	epattime = 99999.9,	 --patrols
	epatlength = 4,
	epat = {},
	epatcool = {}, 
	epatallow = {}, 
	wreckstate = 0, --daywrecker
	wrecktime = 99999.9, 
	wrecktrgt = {},
	wreckbomb = nil, 
	wreckname = "apdwrky", 
	wreckbank = false, 
	wrecknotify = 0, 
	eblttime = 99999.9, --eboltmine
	ebltlength = 10,
	eblt = {}, 
	ebltcool = {}, 
	ebltallow = {},
	fpwr = {nil, nil, nil, nil}, 
	fhqr = nil,
	ftec = nil,
	ftrn = nil,
	fbay = nil,
	fcom = nil,
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
	escv = {}, --scav stuff
	escvlength = 2, 
	wreckbank = false, --have 2
	escvbuildtime = {}, 
	escvstate = {}, 
	ewardeclare = false, --WARCODE --1 recy, 2 fact, 3 armo, 4 base 
	ewartotal = 4,
	ewarrior = {}, 
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
	ewartrgt = {}, 
	LAST = true
}
--PATHS: pmytank, fprcy, fpfac, fparm, fpcon, fpg1-8, fpnav1-5, epgrcy, epgfac, eptur1-10, epblt1-10, ppatrol1-3, epeast, epwest, fp1-4(0-3), (fpne1-3, fpse1-3, fpnw1-3, fpsw1-3)

function InitialSetup()
	SetAutoGroupUnits(true)
	
	local odfpreload = {
		"avrecyss15", "avfact", "avarmo", "avconsss15", "avserv", "avscout", "avmbike", "avmisl", 
		"avtank", "avrckt", "avturr", "svscout", "svmbike", "svmisl", "svtank", "svrckt", "svwalk", 
		"svscav", "svtug", "yvrckt", "yvturr", "ybgtow", "apdwrky", "olybolt2", "apcamra", "abarmopl"
	}
	for k,v in pairs(odfpreload) do
		PreloadODF(v)
	end
	
	x.ercy = GetHandle("ercy")
	x.efac = GetHandle("efac")
	x.earm = GetHandle("earm")
	x.etec = GetHandle("etec")
	x.ehqr = GetHandle("ehqr")
	x.esld = GetHandle("esld")
	for index = 1, 4 do
		x.esil[index] = GetHandle(("esil%d"):format(index))
	end
	SetColorFade(6.0, 0.5, "BLACK")
	TCC.InitialSetup();
end

function Start()
	TCC.Start();
end
function Save()
	return
	index, index2, indexadd, x, TCC.Save()
end

function Load(a, b, c, d, coreData)
	index = a
	index2 = b
	indexadd = c
	x = d
	TCC.Load(coreData)
end

function AddObject(h)
	if (not IsAlive(x.farm) or x.farm == nil) and (IsOdf(h, "avarmo:1") or IsOdf(h, "abarmo")) then
		x.farm = RepObject(h);
		h = x.farm;
	elseif (not IsAlive(x.ffac) or x.ffac == nil) and (IsOdf(h, "avfact:1") or IsOdf(h, "abfact")) then
		x.ffac = h
	elseif (not IsAlive(x.fsld) or x.fsld == nil) and IsOdf(h, "abshld") then
		x.fsld = h
	elseif (not IsAlive(x.fhqr) or x.fhqr == nil) and IsOdf(h, "abhqtr") then
		x.fhqr = h
	elseif (not IsAlive(x.ftec) or x.ftec == nil) and IsOdf(h, "abtcen") then
		x.ftec = h
	elseif (not IsAlive(x.ftrn) or x.ftrn == nil) and IsOdf(h, "abtrain") then
		x.ftrn = h
	elseif (not IsAlive(x.fbay) or x.fbay == nil) and IsOdf(h, "absbay") then
		x.fbay = h
	elseif (not IsAlive(x.fcom) or x.fcom == nil) and IsOdf(h, "abcbun") then
		x.fcom = h
	elseif IsOdf(h, "abpgen2") then
		for indexadd = 1, 4 do
			if x.fpwr[indexadd] == nil or not IsAlive(x.fpwr[indexadd]) then
				x.fpwr[indexadd] = h
				break
			end
		end
	else
		ReplaceStabber(h);
	end
	
	for indexadd = 1, x.fartlength do --new artillery? 
		if (not IsAlive(x.fart[indexadd]) or x.fart[indexadd] == nil) and IsOdf(h, "avartl:1") then
			x.fart[indexadd] = h
		end
	end
	
	--get daywrecker for highlight
	if (not IsAlive(x.wreckbomb) or x.wreckbomb == nil) and IsOdf(h, x.wreckname) then 
		if GetTeamNum(h) == 5 then
			x.wreckbomb = h --get handle to launched daywrecker
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
		x.mytank = BuildObject("avtank", 1, "pmytank")
		SetAsUser(x.mytank, 1)
		RemoveObject(x.player)
		x.player = GetPlayerHandle()
		x.frcy = BuildObject("avrecyss15", 1, "fprcy")
		SetGroup(x.frcy, 1)
		x.ffac = BuildObject("avfact", 1, "fpfac")
		SetGroup(x.ffac, 2)
		x.farm = BuildObject("avarmo", 1, "fparm")
		SetGroup(x.farm, 3)
		x.fcon = BuildObject("avconsss15", 1, "fpcon")
		SetGroup(x.fcon, 8)
		x.fally[1] = BuildObject("avtank", 1, "fpg1")
		x.fally[2] = BuildObject("avtank", 1, "fpg2")
		x.fally[3] = BuildObject("avtank", 1, "fpg3")
		x.fally[4] = BuildObject("avmisl", 1, "fpg4")
		x.fally[5] = BuildObject("avtank", 1, "fpg5")
		x.fally[6] = BuildObject("avrckt", 1, "fpg6")
		for index = 1, 6 do
			SetSkill(x.fally[index], x.skillsetting)
			SetGroup(x.fally[index], 0)
		end
		x.fally[7] = BuildObject("avturr", 1, "fpg7")
		SetSkill(x.fally[7], x.skillsetting)
		SetGroup(x.fally[7], 5)
		x.fally[8] = BuildObject("avturr", 1, "fpg8")
		SetSkill(x.fally[8], x.skillsetting)
		SetGroup(x.fally[8], 5)
		x.fally[9] = BuildObject("avserv", 1, "fpg9")
		SetGroup(x.fally[9], 4)
		x.fally[10] = BuildObject("avserv", 1, "fpg10")
		SetGroup(x.fally[10], 4)
		for index = 1, 10 do --clear init units handles for incoming allies
			x.fally[index] = nil
		end
		x.fnav1 = BuildObject("apcamra", 1, "fpnav1")
		SetObjectiveName(x.fnav1, "NSDF base")
		x.fnav1 = BuildObject("apcamra", 1, "fpnav2") --near former CCA base, so local pools would be known
		SetObjectiveName(x.fnav1, "NE pool")
		x.fnav1 = BuildObject("apcamra", 1, "fpnav3")
		SetObjectiveName(x.fnav1, "NW pool")
		x.fnav1 = BuildObject("apcamra", 1, "fpnav4")
		SetObjectiveName(x.fnav1, "SW pool")
		x.fnav1 = BuildObject("apcamra", 1, "fpnav5")
		SetObjectiveName(x.fnav1, "FURY base")
    x.eblttime = GetTime() + 60.0 --init eblt
		for index = 1, x.ebltlength do
			x.eblt[index] = BuildObject("olybolt2", 5, ("epblt%d"):format(index))
		end
		for index = 1, 8 do
			x.egun[index] = BuildObject("ybgtow", 5, ("epgun%d"):format(index))
			SetSkill(x.egun[index], x.skillsetting)
		end
		for index = 1, x.ewartotal do --init WARCODE
			x.ewardeclare = true
			x.ewarrior[index] = {} --"rows"
			x.ewartrgt[index] = nil
			for index2 = 1, 12 do -->>12 per wave max avail
				x.ewarrior[index][index2] = nil --"columns", init (handle in this case)
			end
			x.ewarstate[index] = 1
			x.ewartime[1] = GetTime() + 120.0 --recy
			x.ewartime[2] = GetTime() + 180.0 --fact
			x.ewartime[3] = GetTime() + 240.0 --armo
			x.ewartime[4] = GetTime() + 300.0 --base
			x.ewartimecool[index] = 300.0
			x.ewartimeadd[index] = 0.0
			x.ewarabort[index] = 99999.9
			x.ewarsize[index] = 0
			x.ewarwave[index] = 0
			x.ewarwavemax[index] = 5
			x.ewarwavereset[index] = 2
		end
		for index = 1, x.ekillartlength do --init ekillart
			x.ekillarttime = GetTime()
			x.ekillart[index] = nil 
			x.ekillartcool[index] = 99999.9 
			x.ekillartallow[index] = false
		end
		x.epattime = GetTime() + 60.0 --init epat
		for index = 1, x.escvlength do --init escv
			x.escvbuildtime[index] = GetTime()
			x.escvstate[index] = 1
		end
		for index = 1, x.epatlength do --init epat
			x.epatcool[index] = GetTime()
			x.epatallow[index] = true
		end
		x.eturtime = GetTime() + 60.0 --init etur
		for index = 1, x.eturlength do --init etur
			x.eturcool[index] = GetTime()
			x.eturallow[index] = true
		end
		x.emintime = GetTime() + 60.0 --init emin
		for index = 1, 2 do --init emin
			x.emincool[index] = GetTime()
			x.eminallow[index] = true
		end
		x.striketime = GetTime() + 1200.0 --20min delay
		x.missiontime = GetTime() + 1800.0 --30min first time
		SetScrap(1, 40)
		SetScrap(5, 40)
		AudioMessage("tcss1501.wav") --INTRO - CCA base converted to Fury. Destroy it. Karnov to reinf
		x.audio1 = AudioMessage("tcss1502.wav") --OPT - Force of Cosmo COLONIST Army are rolling. (soviet then
    x.userfov = IFace_GetInteger("options.graphics.defaultfov")
    CameraReady()
    IFace_SetInteger("options.graphics.defaultfov", x.camfov)
		x.spine = x.spine + 1
	end

	--Run start cam, then send init attack
	if x.spine == 1 then
		x.camheight = x.camheight + 30
		CameraPath("pcam1", x.camheight, 4000, x.ercy)
		if IsAudioMessageDone(x.audio1) or CameraCancelled() then
      CameraFinish()
      IFace_SetInteger("options.graphics.defaultfov", x.userfov)
			SetColorFade(6.0, 0.5, "BLACK")
			--AddObjective("tcss1501.txt")
			AddObjective("Establish a base.\n\nDestroy the Fury Recycler and CCA Hangar.\n\nAllied CCA will arrive periodically in group F10.")
			x.eatk[1] = BuildObject("yvrckt", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
			SetSkill(x.eatk[1], x.skillsetting)
			Attack(x.eatk[1], x.frcy)
      x.waittime = GetTime() + 20.0
      x.spine = x.spine + 1
    end
  end
  
  --Send SAV 2 attack
  if x.spine == 2 and x.waittime < GetTime() then
    x.eatk[2] = BuildObject("yvrckt", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
    SetSkill(x.eatk[2], x.skillsetting)
    Attack(x.eatk[2], x.ffac)
    x.waittime = GetTime() + 20.0
    x.spine = x.spine + 1
  end
  
  --Send SAV 3 attack
  if x.spine == 3 and x.waittime < GetTime() then
    x.eatk[3] = BuildObject("yvrckt", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
    SetSkill(x.eatk[3], x.skillsetting)
    Attack(x.eatk[3], x.farm)
    x.wrecktime = GetTime() + 330.0 --init daywrecker
    x.spine = x.spine + 1
	end

	--start the victory tour
	if x.spine == 4 and not IsAlive(x.ercy) and not IsAlive(x.efac) then
		x.audio1 = AudioMessage("tcss1516.wav") --P1 SUCCEED - Congrats Furies fact is destroyed.
		x.missiontime = 99999.9 --Shut it down. Shut it ALL down.
		x.fallytime = 99999.9
		x.eturtime = GetTime() + 60.0
		x.ewardeclare = false
		x.escvbuildtime = 99999.9
		x.epattime = 99999.9
		x.emintime = 99999.9
		x.striketime = 99999.9
		x.strikemsgreset = 99999.9
		x.MCAcheck = true
		x.spine = x.spine + 1
	end

	--continue the victory tour
	if x.spine == 5 and IsAudioMessageDone(x.audio1) then
		ClearObjectives()
		AddObjective("tcss1502.txt", "GREEN")
		AudioMessage("tcss1513.wav") --P1 SUCCEED - They're retreating
		x.audio2 = AudioMessage("tcss1515.wav") --P3 SUCCEED - Group of Fury board trans. Follow them.
		x.spine = x.spine + 1
	end
	
	--end the victory tour - succeed mission
	if x.spine == 6 and IsAudioMessageDone(x.audio2) then
		TCC.SucceedMission(GetTime() + 1.0, "tcss15w1.des") --WINNER WINNER WINNER
		x.spine = x.spine + 1
	end
	----------END MAIN SPINE ----------

	--CCA REINFORCEMENTS START
	if not x.fallystart and IsOdf(x.frcy, "abrecyss15") then
		x.fallytime = GetTime() + 180.0
		x.fallystart = true
	end

	--CCA REINFORCEMENTS PICK
	if x.fallytime < GetTime() then
		while x.randompick == x.randomlast do --random the random
			x.randompick = math.floor(GetRandomFloat(1.0, 10.0))
		end
		x.randomlast = x.randompick
		while x.randomloc == x.randomlastloc do --random the location
			x.randomloc = math.floor(GetRandomFloat(1.0, 4.0))
		end
		x.randomlastloc = x.randomloc
		--[[
		if x.randompick == 1 or x.randompick == 7 or x.randompick == 13 then --Tug group
			AudioMessage("tcss1503.wav") --Units. of worker hauling, and disposal are joining you.
			x.fally[1] = BuildObject("svtug", 1, ("fp%d"):format(x.randomloc), 1)
			x.fally[2] = BuildObject("svtank", 1, ("fp%d"):format(x.randomloc), 2)
			x.fally[3] = BuildObject("svrckt", 1, ("fp%d"):format(x.randomloc), 3)
		]]
		-- [MC] Removed tug group. Decreased random frequency to make walkers spawn a little more often.
		--[[else]]if (x.randompick > 7) then --Scav group
			AudioMessage("tcss1504.wav") --Scrap aux moving to attack
			x.fally[1] = BuildObject("svscav", 1, ("fp%d"):format(x.randomloc), 1)
			x.fally[2] = BuildObject("svmbike", 1, ("fp%d"):format(x.randomloc), 2)
			x.fally[3] = BuildObject("svmbike", 1, ("fp%d"):format(x.randomloc), 3)
		elseif (x.randompick > 5) then --Scout group
			AudioMessage("tcss1506.wav") --A fighter wing is moving in
			x.fally[1] = BuildObject("svscout", 1, ("fp%d"):format(x.randomloc), 1)
			x.fally[2] = BuildObject("svscout", 1, ("fp%d"):format(x.randomloc), 2)
			x.fally[3] = BuildObject("svscout", 1, ("fp%d"):format(x.randomloc), 3)
		elseif (x.randompick > 3) then --Mixed group
			AudioMessage("tcss1505.wav") --A mix patrol is moving to CCA facility
			x.fally[1] = BuildObject("svmisl", 1, ("fp%d"):format(x.randomloc), 1)
			x.fally[2] = BuildObject("svrckt", 1, ("fp%d"):format(x.randomloc), 2)
			x.fally[3] = BuildObject("svtank", 1, ("fp%d"):format(x.randomloc), 3)
		elseif (x.randompick > 1) then --Mixed group 2
			AudioMessage("tcss1507.wav") --An armor assault company is on the way
			x.fally[1] = BuildObject("svmbike", 1, ("fp%d"):format(x.randomloc), 1)
			x.fally[2] = BuildObject("svtank", 1, ("fp%d"):format(x.randomloc), 2)
			x.fally[3] = BuildObject("svrckt", 1, ("fp%d"):format(x.randomloc), 3)
		else
			AudioMessage("tcss1508.wav") --A walker team is moving to attack the base
			x.fally[1] = BuildObject("svwalk", 1, ("fp%d"):format(x.randomloc), 1)
			x.fally[2] = BuildObject("svwalk", 1, ("fp%d"):format(x.randomloc), 2)
			x.fally[3] = BuildObject("svwalk", 1, ("fp%d"):format(x.randomloc), 3)
		end
		for index = 1, x.fallylength do
			SetSkill(x.fally[index], x.skillsetting)
			SetGroup(x.fally[index], 9)
			Patrol(x.fally[index], "epgrcy", 0)
		end
		for index = 1, 12 do
			x.randompick = math.floor(GetRandomFloat(1.0, 9.0))
		end
		if x.randompick == 1 or x.randompick == 4 or x.randompick == 7 then
			x.fallytime = GetTime() + 420.0
		elseif x.randompick == 2 or x.randompick == 5 or x.randompick == 8 then
			x.fallytime = GetTime() + 300.0
		else
			x.fallytime = GetTime() + 180.0
		end
		x.fallywaittime = GetTime() + 2.0 --give time to move
	end
	--[[
	--CHECK SAFE TO RUN FALLY CAMERA
	if x.fallywaittime < GetTime() then
		x.player = GetPlayerHandle()
		if IsAlive(x.player) and GetDistance(x.player, GetNearestEnemy(x.player, 1, 1, 450)) > 250 then
			x.userfov = IFace_GetInteger("options.graphics.defaultfov")
			CameraReady()
			IFace_SetInteger("options.graphics.defaultfov", x.camfov)
			x.camplay = true
			x.camtime = GetTime() + 4.0
			x.fallywaittime = 99999.9
		end
	end

	--RUN FALLY CAMERA
	if x.camplay then
		CameraObject(x.fally[1], -60, 60, 60, x.fally[1]) --in meters
		if x.camtime < GetTime() or CameraCancelled() then
			CameraFinish()
			IFace_SetInteger("options.graphics.defaultfov", x.userfov)
			x.camtime = 99999.9
			x.camplay = false
		end
	end
	
	--REMIND EVERY 10 MIN TO TRY DIFFERENT APPROACH
	if x.missiontime < GetTime() then
		AudioMessage("tcss1511.wav") --Try to strike from more than one approach.
		x.missiontime = GetTime() + 600.0
	end
	--]]
	--THE FURY STRIKES BACK
	if x.striketime < GetTime() and ((not IsAlive(x.egun[1]) and not IsAlive(x.egun[2])) or (not IsAlive(x.egun[3]) and not IsAlive(x.egun[4]))) then --Is an entrance open
		AudioMessage("tcss1509.wav") --The Furies are counterattacking
		AudioMessage("tcss1510.wav") --Protect your base. If Texas lost, it’s over.
		ClearObjectives()
		AddObjective("tcss1504.txt", "YELLOW")
		for index = 1, 5 do
			x.eatk[index] = BuildObject("yvrckt", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
			SetSkill(x.eatk[index], x.skillsetting)
			SetObjectiveName(x.eatk[index], ("Counterstrike %d"):format(index))
			Attack(x.eatk[index], x.frcy)
		end
		GetPlayerHandle(x.player)
		Attack(x.eatk[1], x.player)
		x.strikemsgreset = GetTime() + 20.0
		x.striketime = GetTime() + 300.0
	end

	--RESET OBJECTIVES AFTER COUNTERSTRIKE
	if x.strikemsgreset < GetTime() then
		ClearObjectives()
		AddObjective("tcss1501.txt")
		x.strikemsgreset = 99999.9
	end

	--FURY GROUP BOLT MINE
	if x.eblttime < GetTime() then
		for index = 1, x.ebltlength do
			if not IsAlive(x.eblt[index]) and not x.ebltallow[index] then
				x.ebltcool[index] = GetTime() + 360.0
				x.ebltallow[index] = true
			end
			if x.ebltallow[index] and x.ebltcool[index] < GetTime() and GetDistance(x.player, ("epblt%d"):format(index)) > 300 then
				x.eblt[index] = BuildObject("olybolt2", 5, ("epblt%d"):format(index))
				x.ebltallow[index] = false
			end
		end
		x.eblttime = GetTime() + 60.0
	end
	
	--FURY GROUP TURRET GENERIC
	if x.eturtime < GetTime() then
		for index = 1, x.eturlength do
			if not IsAlive(x.etur[index]) and not x.eturallow[index] then
				x.eturcool[index] = GetTime() + 420.0
				x.eturallow[index] = true
			end
			
			if x.eturallow[index] and x.eturcool[index] < GetTime() and GetDistance(x.player, ("eptur%d"):format(index)) > 300 then
				x.etur[index] = BuildObject("yvturr", 5, GetPositionNear("epgrcy", 0, 16, 32)) --grpspwn
				SetSkill(x.etur[index], x.skillsetting)
				--SetObjectiveName(x.etur[index], ("Teucer %d"):format(index))
				Goto(x.etur[index], ("eptur%d"):format(index))
				x.eturallow[index] = false
			end
		end
		x.eturtime = GetTime() + 60.0
	end

	--FURY GROUP SCOUT PATROLS 
	if x.epattime < GetTime() then
		for index = 1, x.epatlength do
			if not IsAlive(x.epat[index]) and not x.epatallow[index] then
				x.epatcool[index] = GetTime() + 300.0
				x.epatallow[index] = true
			end
			
			if x.epatallow[index] and x.epatcool[index] < GetTime() then
				while x.randompick == x.randomlast do --random the random
					x.randompick = math.floor(GetRandomFloat(1.0, 15.0))
				end
				x.randomlast = x.randompick
				if x.randompick == 1 or x.randompick == 6 or x.randompick == 11 then
					x.epat[index] = BuildObject("yvscout", 5, ("ppatrol%d"):format(index))
				elseif x.randompick == 2 or x.randompick == 7 or x.randompick == 12 then
					x.epat[index] = BuildObject("yvmbike", 5, ("ppatrol%d"):format(index))
				elseif x.randompick == 3 or x.randompick == 8 or x.randompick == 13 then
					x.epat[index] = BuildObject("yvmisl", 5, ("ppatrol%d"):format(index))
				elseif x.randompick == 4 or x.randompick == 9 or x.randompick == 14 then
					x.epat[index] = BuildObject("yvtank", 5, ("ppatrol%d"):format(index))
				else
					x.epat[index] = BuildObject("yvrckt", 5, ("ppatrol%d"):format(index))
				end
				Patrol(x.epat[index], ("ppatrol%d"):format(index))
				SetSkill(x.epat[index], x.skillsetting)
				--SetObjectiveName(x.epat[index], ("Patrol %d"):format(index))
				x.epatallow[index] = false
			end
		end
		x.epattime = GetTime() + 300.0
	end
	
	--AI DAYWRECKER ATTACK --will stop if no earm, etec, or not enought scrap capacity
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
			x.wrecktrgt = GetPosition(x.fcom) --(x.player)
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
			x.wrecktime = GetTime() + 480.0
		elseif x.randompick == 2 or x.randompick == 5 or x.randompick == 8 then
			x.wrecktime = GetTime() + 360.0
		else
			x.wrecktime = GetTime() + 240.0
		end
		x.wreckstate = 0 --reset
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
						if index == 1 then
							x.ewarsize[index] = 4
						elseif index == 2 then
							x.ewarsize[index] = 2
						elseif index == 3 then
							x.ewarsize[index] = 2
						elseif index == 4 then
							x.ewarsize[index] = 2
						else
							x.ewarsize[index] = 2
						end
					elseif x.ewarwave[index] == 2 then
						if index == 1 then
							x.ewarsize[index] = 6
						elseif index == 2 then
							x.ewarsize[index] = 4
						elseif index == 3 then
							x.ewarsize[index] = 2
						elseif index == 4 then
							x.ewarsize[index] = 3
						else
							x.ewarsize[index] = 3
						end
					elseif x.ewarwave[index] == 3 then
						if index == 1 then
							x.ewarsize[index] = 8
						elseif index == 2 then
							x.ewarsize[index] = 6
						elseif index == 3 then
							x.ewarsize[index] = 4
						elseif index == 4 then
							x.ewarsize[index] = 4
						else
							x.ewarsize[index] = 4
						end
					elseif x.ewarwave[index] == 4 then
						if index == 1 then
							x.ewarsize[index] = 10
						elseif index == 2 then
							x.ewarsize[index] = 8
						elseif index == 3 then
							x.ewarsize[index] = 6
						elseif index == 4 then
							x.ewarsize[index] = 5
						else
							x.ewarsize[index] = 5
						end 
					else --x.ewarwave[index] == 5 then
						if index == 1 then
							x.ewarsize[index] = 12
						elseif index == 2 then
							x.ewarsize[index] = 10
						elseif index == 3 then
							x.ewarsize[index] = 8
						elseif index == 4 then
							x.ewarsize[index] = 7
						else
							x.ewarsize[index] = 6
						end
					end
					x.ewarstate[index] = x.ewarstate[index] + 1
				end
				
				--BUILD FORCE
				if x.ewarstate[index] == 2 then
					for index2 = 1, x.ewarsize[index] do
						while x.randompick == x.randomlast do --random the random
							x.randompick = math.floor(GetRandomFloat(1.0, 20.0))  --added 2 more chance (1 yvrckt, 1 yvartl)
						end
						x.randomlast = x.randompick
						if not IsAlive(x.efac) then
							x.randompick = 1
						end
						if x.randompick == 1 or x.randompick == 7 or x.randompick == 13 then
							x.ewarrior[index][index2] = BuildObject("yvscout", 5, GetPositionNear("epgrcy", 0, 16, 32)) --grpspwn
						elseif x.randompick == 2 or x.randompick == 8 or x.randompick == 14 then
							x.ewarrior[index][index2] = BuildObject("yvmbike", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
						elseif x.randompick == 3 or x.randompick == 9 or x.randompick == 15 then
							x.ewarrior[index][index2] = BuildObject("yvmisl", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
						elseif x.randompick == 4 or x.randompick == 10 or x.randompick == 16 then
							x.ewarrior[index][index2] = BuildObject("yvtank", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
						elseif x.randompick == 5 or x.randompick == 11 or x.randompick == 17 or x.randompick == 19 then
							x.ewarrior[index][index2] = BuildObject("yvrckt", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
						else
							x.ewarrior[index][index2] = BuildObject("yvartl", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
						end
						SetSkill(x.ewarrior[index][index2], x.skillsetting)
						if index2 % 2 == 0 then
							SetSkill(x.ewarrior[index][index2], x.skillsetting+1)
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

	--AI ARTILLERY ASSASSIN
	if x.ekillarttime < GetTime() and IsAlive(x.efac) then
		for index = 1, x.ekillartlength do
			if (not IsAlive(x.ekillart[index]) or (IsAlive(x.ekillart[index]) and GetTeamNum(x.ekillart[index]) == 1)) and not x.ekillartallow[index] then
				x.ekillartcool[index] = GetTime() + 120.0
				x.ekillartallow[index] = true
			end
			if x.ekillartallow[index] and x.ekillartcool[index] < GetTime() and GetDistance(x.player, "epgfac") > 300 then
				x.ekillart[index] = BuildObject("yvtank", 5, GetPositionNear("epgfac", 0, 16, 32))
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
			x.ekillartmarch = false
			x.ekillarttime = GetTime() + 180.0 --give time for attack
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
				x.escv[index] = BuildObject("yvscav", 5, GetPositionNear("epgrcy", 0, 16, 32))
				x.escvstate[index] = 1
			end
		end
	end

	--FURY MINELAYER SQUAD
	if x.emintime < GetTime() then
		for index = 1, 2 do
			if (not IsAlive(x.emin[index]) or (IsAlive(x.emin[index]) and GetTeamNum(x.emin[index]) == 1)) and not x.eminallow[index] then
				x.emincool[index] = GetTime() + 180.0
				x.eminallow[index] = true
			end
			
			if x.eminallow[index] and x.emincool[index] < GetTime() then
				x.emin[index] = BuildObject("yvmine", 5, GetPositionNear("epgrcy", 0, 16, 32))
				SetSkill(x.emin[index], x.skillsetting)
				--SetObjectiveName(x.emin[index], ("Sporio %d"):format(index))
				Goto(x.emin[index], ("epmin%d"):format(index))
				x.emingo[index] = true
				x.eminallow[index] = false
				--x.emintime = GetTime() + 120.0
			end
			
			if IsAlive(x.emin[index]) and (GetCurAmmo(x.emin[index]) <= math.floor(GetMaxAmmo(x.emin[index]) * 0.5)) and GetTeamNum(x.emin[index]) ~= 1 then
				SetCurAmmo(x.emin[index], GetMaxAmmo(x.emin[index]))
				Goto(x.emin[index], ("epmin%d"):format(index)) --resend orders
				x.emingo[index] = true
			end
			
			if x.emingo[index] and (GetDistance(x.emin[index], ("epmin%d"):format(index)) < 30) and GetTeamNum(x.emin[index]) ~= 1 then
				Mine(x.emin[index], ("epmin%d"):format(index))
				x.emingo[index] = false
			end
		end
	end

	--CHECK STATUS OF MCA
	if not x.MCAcheck then
		if not IsAlive(x.frcy) then --frecy killed
			AudioMessage("tcss1512.wav") --FAIL - Recy Texas lost 
			ClearObjectives()
			AddObjective("tcss1503.txt", "RED") --Texas lost mission failed
			TCC.FailMission(GetTime() + 12.0, "tcss15f1.des") --LOSER LOSER LOSER
			x.spine = 666
			x.MCAcheck = true
		end
	end
end
--[[END OF SCRIPT]]