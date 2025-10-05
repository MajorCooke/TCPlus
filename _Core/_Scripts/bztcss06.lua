--bztcss06 - Battlezone Total Command - Stars and Stripes - 6/17 - BEHIND ENEMY LINES
assert(load(assert(LoadFile("_requirefix.lua")),"_requirefix.lua"))();
TCC = require("TC_Core")
MisnNum = 10;
--DECLARE variables --p-path, f-friend, e-enemy, atk-attack, rcy-recycler
local index = 0
local index2 = 0
local indexadd = 0
local x = {
	FIRST = true, --uh MUST HAVE REORDERED VARS AT SOME POINT, POOR ORDER NOW
	spine = 0,	
	getiton = false, 
	MCAcheck = false, 
	player = nil, 
	mytank = nil, 
	skillsetting = 0,
	easy = 0, 
	medium = 1, 
	hard = 2, 
	audio1 = nil, 
	waittime = 99999.9, 
	pos = {}, 
	casualty = 0,	
	randompick = 0, 
	randomlast = 0, 
	free_player = false,
	controls = {braccel = 0, strafe = 0, jump = 0, deploy = 0, eject = 0, abandon = 0, fire = 0}, 
	outofship = false, 
	dontkillmebro = false, 
  frcygiven = false, 
	allyno = false, 
	allymet = false, 
	bailed = false, 
	gotrazorpilot = false, 
	erun1 = nil, --runner stuff
	erun2 = nil, 
	erunner = nil, 
	erunspn = 0, 
	eruntime = 99999.9, 
	eruntime2 = 99999.9, 
	erunwaittime = 99999.9, 
	erunassign = false, 
	erunsent = false, 
	erunhome = false, 
	efactime = 99999.9, 
	efacreset = false, 
	killcheater = false, 
	gotobailout = false, 
	callplayed = false, 
	tripalarm = false, 
	easn = {}, 
	easnstate = 0, 
	easntime = 99999.9, 
	eg1time = 99999.9, 
	alarmtime = 99999.9, 
	epattime = 99999.9, 
	epattimeadd = 0.0, --special init 0.0
	eturtime = 99999.9, 
	calltime = 99999.9, 
	earttime = 99999.9, 
	fnav = nil, 
	frcy = nil, 
	ffac = nil, 
	farm = nil,
	fcom = nil, 
	fbay = nil, 
	ftrn = nil, 
	ftec = nil, 
	fhqr = nil, 
	fsld = nil, 
	fpwr = {nil, nil, nil, nil},	
	fgrp = {}, 
	fsil1 = nil, 
	fally = {}, 
	fdrp = {}, 
	ercy = nil, 
	efac = nil, 
	earm = nil, 
	ecom = nil, 
	etrn = nil, 
	egun1 = nil, 
	egun2 = nil, 
	etnk = {}, 
	holder = {},	
	epa = nil, 
	eg1 = nil, 
	eg2 = nil, 
	audioalarm = nil, 
	epil = nil, 
	eart = {}, 
	etur = {}, 
	epat = {}, 
	callme = nil, 
	epilcount = 0, 
	epilcount2 = 0, 
	eturlength = 19,
	eturlife = {}, 
	epatlength = 6, 
	call_state = 0, 
	obj_state = 0,
	escv = {}, --scav stuff
	escvlength = 2, 
	wreckbank = false, --have 2
	escvbuildtime = {}, 
	escvstate = {}, 
	fartlength = 10, --fart killers
	fart = {}, 
	ekillarttime = 99999.9,
	ekillartlength = 4, 
	ekillart = {}, 
	ekillartcool = {}, 
	ekillartallow = {}, 
	ekillarttarget = nil, 
	ekillartmarch = false, 
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
--PATHS: pmytank, fprcy, fpfac, eprcy, epfac, eptur0-17, epgrcy, epgfac, fpnav0-8, ppatrol1-6, fpgrp0-4, fpally1-3, pbail, eptnk1-4, epcom, epbar, epg0-1, epa1-5, epfacs1, epfacs2, epfacs3, epfacs4, fptur1, fptur2, fparm, stage1-2(0-1), prun1, prun2, prun3, prun4

function InitialSetup()
	SetAutoGroupUnits(true)
	
	local odfpreload = {
		"avrecyss06", "avfactss06", "avarmoss06", "avtank", "avmisl", "avturr", "avscout", "stayput", "apcamra", "radjam"
	}
	for k,v in pairs(odfpreload) do
		PreloadODF(v)
	end
	
	x.fdrp[1] = GetHandle("fdrp1")
	x.fdrp[2] = GetHandle("fdrp2")
	x.farm = GetHandle("farm")
	for index = 1, 4 do
		x.fgrp[index] = GetHandle(("fgrp%d"):format(index))
	end
	x.mytank = GetHandle("mytank")
	x.ercy = GetHandle("ercy")
	x.efac = GetHandle("efac")
	x.earm = GetHandle("earm")
	x.ecom = GetHandle("ecom")
	x.etrn = GetHandle("etrn")
	x.egun1 = GetHandle("egun1")
	x.egun2 = GetHandle("egun2")
	Ally(5, 6)
	Ally(6, 5) --6 CCA radar group
	Ally(1, 4)
	Ally(4, 1) --4 eldridge 6th Plt
	SetTeamColor(6, 80, 80, 20)
	--SetTeamColor(4, 50, 150, 255) --x.eldridge 6th Plt	
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

local replaced = false;
function AddObject(h)
	if (replaced) then replaced = false; return; end;
	if (GetTeamNum(h) == 1) then
		if (IsType(h, "abarmo")) then
			x.farm = h
		elseif (IsType(h, "abfact")) then
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
		elseif IsOdf(h, "abpgen1") then
			for indexadd = 1, 4 do
				if x.fpwr[indexadd] == nil or not IsAlive(x.fpwr[indexadd]) then
					x.fpwr[indexadd] = h
					break
				end
			end
		end
		
		for indexadd = 1, x.fartlength do --new artillery? 
			if (not IsAlive(x.fart[indexadd]) or x.fart[indexadd] == nil) and IsOdf(h, "avartl:1") then
				x.fart[indexadd] = h
			end
		end
	end
	if not x.gotrazorpilot and IsOdf(h, "aspilo") then  --remove ejecting razor pilot
		if GetTeamNum(h) == 4 then
      x.fgrp[10] = h
			x.gotrazorpilot = true
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

	--START THE MISSION BASICS
	if x.spine == 0 then
		x.pos = GetTransform(x.mytank)
		RemoveObject(x.mytank)
		x.mytank = BuildObject("avmisl", 1, x.pos)
		x.pos = GetTransform(x.fgrp[1])
		RemoveObject(x.fgrp[1])
		x.fgrp[1] = BuildObject("avscout", 1, x.pos)
		x.pos = GetTransform(x.fgrp[2])
		RemoveObject(x.fgrp[2])
		x.fgrp[2] = BuildObject("avtank", 1, x.pos)
		x.pos = GetTransform(x.fgrp[3])
		RemoveObject(x.fgrp[3])
		x.fgrp[3] = BuildObject("avturr", 4, x.pos) --joins team 1 later
		x.pos = GetTransform(x.fgrp[4])
		RemoveObject(x.fgrp[4])
		x.fgrp[4] = BuildObject("avturr", 4, x.pos) --joins team 1 later
		x.pos = GetTransform(x.farm)
		RemoveObject(x.farm)
		x.farm = BuildObject("avarmoss06", 4, x.pos) --joins team 1 later
		x.fgrp[5] = BuildObject("svturr", 5, "epa1")  --was epa
		RemovePilot(x.fgrp[5])
		x.fgrp[6] = BuildObject("svturr", 5, "epa2")
		RemovePilot(x.fgrp[6])
		x.fgrp[7] = BuildObject("svtank", 5, "epa3")
		RemovePilot(x.fgrp[7])
		x.fgrp[8] = BuildObject("svtank", 5, "epa4")
		RemovePilot(x.fgrp[8])
		x.fgrp[9] = BuildObject("svscout", 5, "epa5")
		RemovePilot(x.fgrp[9])
		SetAsUser(x.mytank, 1)
		RemoveObject(x.player)
		x.player = GetPlayerHandle()
		SetGroup(x.fgrp[1], 0)
		SetGroup(x.fgrp[2], 0)
		for index = 1, 4 do
			SetSkill(x.fgrp[index], x.skillsetting)
			Stop(x.fgrp[index])
		end
		Stop(x.farm)
		for index = 1, x.eturlength do
			x.etur[index] = BuildObject("svturr", 5, ("eptur%d"):format(index))
			SetSkill(x.etur[index], x.skillsetting)
			x.eturlife[index] = 0
		end
		x.calltime = GetTime() + 2.0
		x.call_state = 1
		x.spine = x.spine + 1
	end

	--DROPSHIP LANDING SEQUENCE - START QUAKE FOR FLYING EFFECT
	if x.spine == 1 then
		for index = 1, 2 do
			for index2 = 1, 10 do
				StopEmitter(x.fdrp[index], index2)
			end
		end
		for index = 1, 4 do
			x.holder[index] = BuildObject("stayput", 0, x.fgrp[index]) --fdrp1 dropship 1
		end
		x.holder[5] = BuildObject("stayput", 0, x.farm) --fdrp2 dropship 2
    x.holder[6] = BuildObject("radjam", 5, x.player)
		x.holder[7] = BuildObject("stayput", 0, x.player) --fdrp1 dropship 1
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
		for index = 1, 6 do --not player yet
			RemoveObject(x.holder[index])
		end
		x.waittime = GetTime() + 5.0
		x.spine = x.spine + 1
	end
	
	--HOLD INPUTS UNTIL DOORS ARE FULLY OPEN
	if x.spine == 5 then
		if x.waittime < GetTime() then
			Goto(x.farm, "fpgrp0", 1)
			for index = 1, 4 do
				Goto(x.fgrp[index], ("fpgrp%d"):format(index))
			end
			x.waittime = GetTime() + 1.0
			x.spine = x.spine + 1
		end
	end

	--GIVE PLAYER CONTROL OF THEIR AVATAR
	if x.spine == 6 and x.waittime < GetTime() then
		x.fsil1 = BuildObject("absilo", 1, "fpsil1") --off-map scrap storage, removed when recy received
		SetScrap(1, 20)
		RemoveObject(x.holder[7])
		x.free_player = true
		x.easntime = GetTime()
		x.eg1time = GetTime()
		x.spine = x.spine + 1
	end
	
	--CHECK IF PLAYER HAS LEFT DROPSHIP
	if x.spine == 7 then
		x.player = GetPlayerHandle()
		if IsCraftButNotPerson(x.player) and GetDistance(x.player, x.fdrp[1]) > 60 then
			for index = 1, 2 do
				TCC.SetTeamNum(x.fgrp[index], 1) --give player control of tanks
			end
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
		x.waittime = GetTime() + 1.0
		x.spine = x.spine + 1
	end

	--DROPSHIP 2 TAKEOFF
	if x.spine == 9 and x.waittime < GetTime() then
		SetAnimation(x.fdrp[2], "takeoff", 1)
		StartSoundEffect("dropleav.wav", x.fdrp[2])
		x.waittime = GetTime() + 24.0
		x.spine = x.spine + 1
	end

	--REMOVE DROPSHIPS
	if x.spine == 10 and x.waittime < GetTime() then
		RemoveObject(x.fdrp[1])
		RemoveObject(x.fdrp[2])
		x.spine = x.spine + 1
	end
	
	--DEPLOY ARMORY AND TURRETS
	if x.spine == 11 then
		if IsAlive(x.farm) and GetDistance(x.farm, "fparm") < 20 then
			AudioMessage("emdotcox.wav")
			ClearObjectives()
			AddObjective("Rendezvous with Cmd. Eldridge and the 6th Platoon.") --"tcss0600.txt")
			x.fnav = BuildObject("apcamra", 1, "fpnav0")
			SetObjectiveName(x.fnav, "Rendevous")
			SetObjectiveOn(x.fnav)
			Dropoff(x.farm, "fparm", 0) --"dropoff point path" must be different from path unit followed to get to it
			for index = 1, 4 do
				Stop(x.fgrp[index], 0) --0 gives player control
			end
      TCC.SetTeamNum(x.farm, 1)
      TCC.SetTeamNum(x.fgrp[3], 1)
			SetGroup(x.fgrp[3], 5)
      TCC.SetTeamNum(x.fgrp[4], 1)
			SetGroup(x.fgrp[4], 5)
      x.spine = x.spine + 1
		end
	end
	
	--HAS PLAYER REACHED ELDRIDGE AND GIVE ALLIES
	if x.spine == 12 then
		if not x.allyno and GetDistance(x.player, "fpnav0") < 250 then
			x.fally[1] = BuildObject("avtank", 4, "fpally1")
			x.fally[2] = BuildObject("avscout", 4, "fpally2")
			x.fally[3] = BuildObject("avmisl", 4, "fpally3")
			for index = 1, 3 do
				SetSkill(x.fally[index], x.skillsetting)
				LookAt(x.fally[index], x.player, 0)
			end
			x.allyno = true
		end
		if not x.allymet and GetDistance(x.player, "fpnav0") < 150 then
			x.calltime = GetTime()
			x.call_state = 2
			for index = 1, 3 do
				TCC.SetTeamNum(x.fally[index], 1)
				SetGroup(x.fally[index], 0)
			end
			SetObjectiveOff(x.fnav)
			RemoveObject(x.fnav)
			x.fnav = BuildObject("apcamra", 1, "fpnav1")
			SetObjectiveName(x.fnav, "CCA outpost")
			SetObjectiveOn(x.fnav)
			x.allymet = true
			x.easnstate = 1
			x.easntime = 99999.9
			x.eruntime = GetTime() --Start Runners
      x.dontkillmebro = true
			x.spine = x.spine + 1
		end
	end

	--HAS PLAYER GONE TO NAV AND ENCOUNTERED GUN TOWERS
	if x.spine == 13 and GetDistance(x.player, "fpnav1") < 150 then
		x.calltime = GetTime()
		x.call_state = 3
		x.waittime = GetTime() + 20.0
		x.eruntime = 99999.9
		x.eruntime2 = 99999.9
		if IsAlive(x.easn[1]) then
			Goto(x.easn[1], "fpnav1")
		elseif IsAlive(x.easn[2]) then
			Goto(x.easn[2], "fpnav1")
		elseif IsAlive(x.erun1) and x.erun1 ~= x.erunner then
			Goto(x.erun1, "fpnav1")
		elseif IsAlive(x.erun2) and x.erun2 ~= x.erunner then
			Goto(x.erun2, "fpnav1")
		end
		x.spine = x.spine + 1
	end

	--BUILD ALLY RAZOR AND SEND MEETUP ORDER
	if x.spine == 14 and x.waittime < GetTime() then
		x.calltime = GetTime()
		x.call_state = 4
		x.fally[1] = BuildObject("avscout", 4, "pbail")
		SetCanSnipe(x.fally[1], 0)
		SetCurHealth(x.fally[1], 99999)
		SetObjectiveName(x.fally[1], "Razor 1")
		SetObjectiveOn(x.fally[1])
		RemoveObject(x.fnav)
		if IsAlive(x.erunner) and GetDistance(x.erunner, x.ecom) < 130 then
			RemoveObject(x.erunner)
		end
		x.spine = x.spine + 1
	end

	--IF MEET RAZOR THEN PLAY MESSAGE
	if x.spine == 15 and GetDistance(x.player, "pbail") < 50 then
		x.calltime = GetTime()
		x.call_state = 5
		LookAt(x.fally[1], x.ecom, 0)
		x.spine = x.spine + 1
	end

	--BAILOUT RAZOR PILOT
	if x.spine == 16 and x.gotobailout then
		x.calltime = GetTime()
		x.call_state = 6
		SetObjectiveOff(x.fally[1])
		EjectPilot(x.fally[1])
		x.alarmtime = GetTime() + 5.0
		x.bailed = true
		x.spine = x.spine + 1
	end

	--TURN CCA COMM TOWER "ON"
	if x.spine == 17 and x.alarmtime < GetTime() then
		SetObjectiveOn(x.ecom)
		if IsAlive(x.erunner) then
			RemoveObject(x.erunner)
		end
		x.spine = x.spine + 1
	end
  
	--GIVE ORDER TO DESTROY TOWER
	if x.spine == 18 and IsAlive(x.ecom) and GetDistance(x.player, x.ecom) < 150 then
		x.calltime = GetTime()
		x.call_state = 7
		x.spine = x.spine + 1
	end

	--IF RADAR DOWN SEND RECY AND SETUP FINAL BATTLE
	if x.spine == 19 and not IsAlive(x.ecom) then
		x.killcheater = true
		x.calltime = GetTime() + 2.0
		x.call_state = 8
		x.waittime = GetTime() + 3.0 --need pause to grab audio
		x.spine = x.spine + 1
	end
	
	--CONTINUE SETUP FOR FINAL BATTLE
	if x.spine == 20 and x.waittime < GetTime() and IsAudioMessageDone(x.callme) then
		x.frcy = BuildObject("avrecyss06", 1, "fprcy")
		SetSkill(x.frcy, x.skillsetting)
		LookAt(x.frcy, x.ercy, 0)
		SetGroup(x.frcy, 8)
		x.ffac = BuildObject("avfactss06", 1, "fpfac")
		SetSkill(x.ffac, x.skillsetting)
		LookAt(x.ffac, x.efac, 0)
		SetGroup(x.ffac, 9)
		x.fally[1] = BuildObject("avtank", 1, "fprcy")
		x.fally[2] = BuildObject("avscout", 1, "fprcy")
		x.fally[3] = BuildObject("avmisl", 1, "fpfac")
		for index = 1, 3 do
			SetSkill(x.fally[index], x.skillsetting)
			SetGroup(x.fally[index], 0)
		end
		x.fnav = BuildObject("apcamra", 1, "fpnav3")
		SetObjectiveName(x.fnav, "NSDF Base")
		x.fnav = BuildObject("apcamra", 1, "fpnav4")
		SetObjectiveName(x.fnav, "CCA Base")
		x.fnav = BuildObject("apcamra", 1, "fpnav5")
		SetObjectiveName(x.fnav, "NE pool")
		x.fnav = BuildObject("apcamra", 1, "fpnav6")
		SetObjectiveName(x.fnav, "SE pool")
		x.fnav = BuildObject("apcamra", 1, "fpnav7")
		SetObjectiveName(x.fnav, "W pool")
		x.fnav = BuildObject("apcamra", 1, "fpnav8")
		SetObjectiveName(x.fnav, "flat terrain") 
		RemoveObject(x.fsil1)
		SetScrap(1, 40)
		SetScrap(5, 40)
		x.eg1time = 99999.9
		x.alarmtime = 99999.9
		x.frcygiven = true
    for index = 5, 9 do
      if IsAround(x.fgrp[index]) and HasPilot(x.fgrp[index]) and GetTeamNum(x.fgrp[index]) == 5 then
        Attack(x.fgrp[index], x.frcy)
      end
    end
		x.spine = x.spine + 1
	end

	--LET PLAYER DEPLOY RECY BEFORE ATTACK
	if x.spine == 21 and IsOdf(x.frcy, "abrecyss06") then
		AudioMessage("emdotcox.wav")
		ClearObjectives()
		AddObjective("Destroy the CCA Recycler and Factory before they re-establish their communications system.")
		AddObjective("\n\nBuild a Comm Tower and use Skyeye (4) to give precise orders to units over long distances.", "CYAN")
		for index = 1, x.ewartotal do --init WARCODE
			x.ewardeclare = true
			x.ewarrior[index] = {} --"rows"
			for index2 = 1, 10 do --10 per wave max avail
				x.ewarrior[index][index2] = nil --"columns", init (handle in this case)
			end
			x.ewartrgt[index] = nil
			x.ewarstate[index] = 1
			x.ewartime[1] = GetTime() + 180.0 --recy
			x.ewartime[2] = GetTime() + 220.0 --240.0 --fact
			x.ewartime[3] = GetTime() + 260.0 --300.0 --armo
			x.ewartime[4] = GetTime() + 300.0 --360.0 --base
			x.ewartimecool[index] = 300.0
			x.ewartimeadd[index] = 0.0
			x.ewarabort[index] = 99999.9
			x.ewarsize[index] = 0
			x.ewarwave[index] = 0
			x.ewarwavemax[index] = 5
			x.ewarwavereset[index] = 2
			x.ewarmeet[index] = 2
		end
		for index = 1, x.escvlength do --init escv
			x.escvbuildtime[index] = GetTime()
			x.escvstate[index] = 1
		end
		for index = 1, x.ekillartlength do --init ekillart
			x.ekillarttime = GetTime()
			x.ekillart[index] = nil 
			x.ekillartcool[index] = 99999.9 
			x.ekillartallow[index] = false
		end
		if not x.tripalarm or not x.erunhome then
			x.epattime = GetTime() + 240.0
		end
		x.spine = x.spine + 1
	end
	
	--CCA BASE DESTROYED MISSION SUCCESS
	if x.spine == 22 and not IsAlive(x.ercy) and not IsAlive(x.efac) then
		x.calltime = GetTime() + 2.0
		x.call_state = 10
		TCC.SucceedMission(GetTime() + 10.0, "tcss06w1.des") --WINNER WINNER WINNER
		x.spine = 666
		x.MCAcheck = true
	end
	----------END MAIN SPINE ----------

	--ENSURE PLAYER CAN'T DO ANYTHING WHILE IN DROPSHIP
	if not x.free_player then
		x.controls = {braccel = 0, strafe = 0, jump = 0, deploy = 0, eject = 0, abandon = 0, fire = 0}
		SetControls(x.player, x.controls)
	end

	--CCA INIT GROUP ARMORY
	if x.eg1time < GetTime() then
		if not IsAlive(x.eg1) and not IsAlive(x.eg2) then
			x.eg1 = BuildObject("svscout", 5, "epg1")
			SetSkill(x.eg1, x.skillsetting)
			x.eg2 = BuildObject("svscout", 5, "epg1")
			SetSkill(x.eg2, x.skillsetting)
		end
		if x.eg1time < GetTime() then
			if IsAlive(x.farm) and not IsPlayer(x.eg1) and not IsPlayer(x.eg2) then
				Attack(x.eg1, x.farm)
				Attack(x.eg2, x.farm)
			else
				x.player = GetPlayerHandle()
				Attack(x.eg1, x.player)
				Attack(x.eg2, x.player)
			end
			x.eg1time = GetTime() + 60.0
		end
	end

	--CCA INIT GROUP ASSASSIN
	if x.easnstate == 0 and (GetDistance(x.player, "fparm") < 200 or x.easntime < GetTime()) then
		if not IsAlive(x.easn[1]) and not IsAlive(x.easn[2]) then
			for index = 1, 2 do 
				x.easn[index] = BuildObject("svscout", 6, "epg0")
				SetSkill(x.easn[index], x.skillsetting)
				SetObjectiveName(x.easn[index], ("Assassain %d"):format(index))
				x.player = GetPlayerHandle()
			end
			for index = 1, 2 do
				if IsAlive(x.easn[index]) and not IsPlayer(x.easn[index]) then
					Attack(x.easn[index], x.player)
				end
			end
		end
		x.easntime = GetTime() + 30.0
	end

	--CCA RUNNER GROUP
	if not x.getiton then
		if x.eruntime < GetTime() then
			if not IsAlive(x.erun1) and not IsAlive(x.erun2) then
				x.erunner = nil
				x.erunassign = false
				x.eruntime2 = GetTime()
				if x.erunspn < 2 then
					x.erun1 = BuildObject("svscout", 6, "prun1")
					x.erun2 = BuildObject("svscout", 6, "prun2")
					x.erunspn = x.erunspn + 1
				elseif GetDistance(x.player, "fpnav1") > 600 then
					x.erun1 = BuildObject("svscout", 6, "prun3")
					x.erun2 = BuildObject("svscout", 6, "prun4")
				end
				SetSkill(x.erun1, x.skillsetting)
				SetSkill(x.erun2, x.skillsetting)
			end
			
			if not x.erunassign then
				x.player = GetPlayerHandle()
				if IsAlive(x.erun1) and GetDistance(x.erun1, x.player) > 150 and not IsPlayer(x.erun1) then
          Retreat(x.erun1, x.player) --wierd, but correct
        else
          Attack(x.erun1, x.player)
        end
        if IsAlive(x.erun2) and GetDistance(x.erun2, x.player) > 150 and not IsPlayer(x.erun2) then
					Retreat(x.erun2, x.player) --wierd, but correct
				else
					Attack(x.erun2, x.player)
				end
			end
			x.eruntime = GetTime() + 2.0
		end

		if x.eruntime2 < GetTime() then
			if not x.erunassign then
				if IsAlive(x.erun1) and GetCurHealth(x.erun1) < math.floor(GetMaxHealth(x.erun1) * 0.2) then
					x.erunner = x.erun2
				elseif IsAlive(x.erun2) and GetCurHealth(x.erun2) < math.floor(GetMaxHealth(x.erun2) * 0.2) then
					x.erunner = x.erun1
				end
			end

			if not x.erunsent and IsAlive(x.erunner) then
				Goto(x.erunner, "fpnav1", 0)
				AudioMessage("tcss0605.wav") --One of 'ems making a break for it sir.
				SetObjectiveName(x.erunner, "Runner")
				SetObjectiveOn(x.erunner)
				x.eruntime = 99999.9
				x.erunassign = true
				x.erunsent = true
			end

			if GetDistance(x.erunner, "fpnav1") < 50 then --give not quite so straight
				Goto(x.erunner, "epcom", 0)
			end

			if x.erunassign and x.erunsent and not IsAlive(x.erunner) then
				AudioMessage("tcss0606.wav") --That got'em
				x.erunner = nil
				x.eruntime = GetTime()
				x.eruntime2 = 99999.9
				x.erunassign = false
				x.erunsent = false
			end

			if x.erunsent and GetDistance(x.erunner, "gatekeeper") < 80 then
				x.tripalarm = true
				AudioMessage("tcss0608.wav") --alarm SOUND at CCA radar base.
				AudioMessage("tcss0607.wav") --Ah a runners gotten bck to base. The heat's on now.
				for index = 1, 4 do
					x.etnk[index] = BuildObject("svtank", 6, ("eptnk%d"):format(index))
					SetSkill(x.etnk[index], x.skillsetting)
					Goto(x.etnk[index], ("eptnk%d"):format(index), 0)
				end
				x.epattime = GetTime()
				x.erunhome = true
				if IsAlive(x.erunner) then
					RemoveObject(x.erunner)
				end
				x.eruntime = 99999.9
				x.eruntime2 = 99999.9
				x.erunassign = false
				x.erunsent = false
			end
		end
	end

	--IF ALARM TRIPPED EARLY SEND OUT CCA REINFORCEMENTS
	if not x.bailed and not x.tripalarm and ((GetDistance(x.player,"gatekeeper") < 100) or (IsAlive(x.egun1) and (GetDistance(x.egun1, GetNearestEnemy(x.egun1, 0, 0, 450)) < 50)) or (IsAlive(x.egun2) and GetDistance(x.egun2, GetNearestEnemy(x.egun2, 0, 0, 450) < 50))) then
		AudioMessage("tcss0608.wav") --x.alarm SOUND at CCA radar base.
		if GetDistance(x.player, x.egun1) < 80 or GetDistance(x.player, x.egun2) < 80 then
			AudioMessage("tcss0610.wav") --Cmd you've set off alarm. They're on to us.
		else
			AudioMessage("tcss0609.wav") --I've tripped the outpost alarm, they're on to us.
		end

		for index = 1, 4 do 
			x.etnk[index] = BuildObject("svtank", 6, ("eptnk%d"):format(index))
			SetSkill(x.etnk[index], x.skillsetting)
			Goto(x.etnk[index], ("eptnk%d"):format(index), 0)
		end
		x.epattime = GetTime()
		x.tripalarm = true
	end

	--ATTEMPT TO KILL PLAYER IF THEY GO IN FROM THE ENTRANCE
	if not x.killcheater then
		if x.bailed and IsAlive(x.ecom) and GetCurHealth(x.ecom) == GetMaxHealth(x.ecom) and GetDistance(x.player, "gatekeepr") < 60 then
			AudioMessage("tcss0608.wav") --x.alarm SOUND at CCA radar base.
			Attack(x.egun1, x.player, 0)
			Attack(x.egun2, x.player, 0)
			x.bailed = false
		end

		if not x.bailed and GetDistance(x.player, x.ecom) < 100 and GetCurHealth(x.ecom) == GetMaxHealth(x.ecom) then
			for index = 1, 4 do
				x.etnk[index] = BuildObject("svscout", 6, ("epa%d"):format(index))
				SetSkill(x.etnk[index], x.skillsetting)
				Attack(x.etnk[index], x.player)
				SetCurHealth(x.etnk[index], 3000)
			end
			x.etnk[4] = BuildObject("sspilo", 5, "epa1")
			SetSkill(x.etnk[4], x.skillsetting)
			x.etnk[5] = BuildObject("sspilo", 5, "epa2")
			SetSkill(x.etnk[5], x.skillsetting)
			x.killcheater = true
			AudioMessage("tcss0608.wav") --x.alarm SOUND at CCA radar base.
			ClearObjectives()
			AddObjective("tcss0612.txt", "RED")
			SetMaxHealth(x.ercy, 20000)
			SetCurHealth(x.ercy, 20000)
			SetMaxHealth(x.efac, 20000)
			SetCurHealth(x.efac, 20000)
			SetMaxHealth(x.earm, 20000)
			SetCurHealth(x.earm, 20000)
			x.allyno = true
			x.allymet = true
			x.alarmtime = GetTime() + 5.0
			x.bailed = true
			RemoveObject(x.fally[1])
			x.spine = 15
		end
	end

	--PLAY ALARM IF RADAR ARRAY DAMAGED AND SPAWN CCA PILOT
	if x.alarmtime < GetTime() and IsAlive(x.ecom) then
		x.tripalarm = true

		if (IsAlive(x.ecom) and GetCurHealth(x.ecom) < GetMaxHealth(x.ecom)) or (IsAlive(x.etrn) and GetCurHealth(x.etrn) < GetMaxHealth(x.etrn)) then
			x.audioalarm = AudioMessage("tcss0608.wav") --alarm SOUND at CCA radar base.
			x.alarmtime = GetTime() + 6.0
		end

		if IsAlive(x.etrn) and x.epilcount < 3
		and ((GetCurHealth(x.ecom) < math.floor(GetMaxHealth(x.ecom) * 0.2)) or (GetCurHealth(x.ecom) < math.floor(GetMaxHealth(x.ecom) * 0.4)) 
		or (GetCurHealth(x.ecom) < math.floor(GetMaxHealth(x.ecom) * 0.6)) or (GetCurHealth(x.ecom) < math.floor(GetMaxHealth(x.ecom) * 0.8))) then
			x.epil = BuildObject("sspilo", 5, "epbar")
			SetSkill(x.epil, x.skillsetting)
			x.epilcount = x.epilcount + 1
		end

		if IsAlive(x.etrn) and x.epilcount2 < 2 
		and ((GetCurHealth(x.etrn) < math.floor(GetMaxHealth(x.etrn) * 0.3)) or (GetCurHealth(x.etrn) < math.floor(GetMaxHealth(x.etrn) * 0.7))) then
			x.epil = BuildObject("sspilo", 5, "epbar")
			SetSkill(x.epil, x.skillsetting)
			x.epilcount2 = x.epilcount2 + 1
		end
    
    for index = 5, 9 do
      if IsAround(x.fgrp[index]) and HasPilot(x.fgrp[index]) and GetTeamNum(x.fgrp[index]) == 5 then
        Defend2(x.fgrp[index], x.ecom)
      end
    end
	end

	--CCA GROUP TURRET GENERIC
	if x.eturtime < GetTime() then
		for index = 1, x.eturlength do
			if not IsAlive(x.etur[index]) and x.eturlife[index] < 2 then
				x.etur[index] = BuildObject("svturr", 5, GetPositionNear("epgrcy", 0, 16, 32)) --grpspwn
				SetSkill(x.etur[index], x.skillsetting)
				Goto(x.etur[index], ("eptur%d"):format(index))
				x.eturlife[index] = x.efturlife[index] + 1
			end
		end
		x.eturtime = GetTime() + 240.0 --360.0
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
						x.ewarsize[index] = 6
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
						if not IsAlive(x.efac) then
							x.randompick = 1
						end
						if x.randompick == 1 or x.randompick == 6 or x.randompick == 11 then
							x.ewarrior[index][index2] = BuildObject("svscout", 5, GetPositionNear("epgrcy", 0, 16, 32)) --grpspwn
						elseif x.randompick == 2 or x.randompick == 7 or x.randompick == 12 then
							x.ewarrior[index][index2] = BuildObject("svmbike", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
							if x.ewarwave[index] == 2 or x.ewarwave[index] == 4 then
								GiveWeapon(x.ewarrior[index][index2], "gstbva_c")
							end
						elseif x.randompick == 3 or x.randompick == 8 or x.randompick == 13 then
							x.ewarrior[index][index2] = BuildObject("svmisl", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
						elseif x.randompick == 4 or x.randompick == 9 or x.randompick == 14 then
							x.ewarrior[index][index2] = BuildObject("svtank", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
							if x.ewarwave[index] == 4 or x.ewarwave[index] == 5 then
								GiveWeapon(x.ewarrior[index][index2], "gstbsa_c")
							end
						elseif x.randompick == 5 or x.randompick == 10 then
							x.ewarrior[index][index2] = BuildObject("svrckt", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
						end
						SetSkill(x.ewarrior[index][index2], x.skillsetting)
						if index2 % 3 == 0 then
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
						if IsAlive(x.ewarrior[index][index2]) and GetDistance(x.ewarrior[index][index2], ("stage%d"):format(x.ewarmeet[index]), 1) < 100 and GetTeamNum(x.ewarrior[index][index2]) ~= 1 then
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
		
		if not IsAlive(x.efac) then
			x.ewardeclare = false
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
				x.ekillart[index] = BuildObject("svtank", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
				SetSkill(x.ekillart[index], x.skillsetting)
				--SetObjectiveName(x.ekillart[index], "Artl Killer")
				--[[if IsAlive(x.ercy) then
					Defend2(x.ekillart[index], x.ercy)
				else
					Defend2(x.ekillart[index], x.efac)
				end--]]
				Goto(x.ekillart[index], "fpnav4") --THIS MISSION ONLY
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

	--CCA GROUP SCOUT PATROLS --special added simple time add for recheck
	if x.epattime < GetTime() then
		for index = 1, x.epatlength do
			if not IsAlive(x.epat[index]) then
				x.epat[index] = BuildObject("svscout", 5, ("ppatrol%d"):format(index))
				Patrol(x.epat[index], ("ppatrol%d"):format(index))
				SetSkill(x.epat[index], x.skillsetting)
				--SetObjectiveName(x.epat[index], ("Patrol %d"):format(index))
			end
		end
		x.epattimeadd = x.epattimeadd + 30.0
		x.epattime = GetTime() + 180.0 + x.epattimeadd --extra time since OA time limit
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
				x.escv[index] = BuildObject("svscav", 5, GetPositionNear("epgrcy", 0, 16, 32)) --grpspwn
				x.escvstate[index] = 1
			end
		end
	end

	--CCA REBUILD FACTORY
	if not x.efacreset and not IsAlive(x.efac) then
		x.efactime = GetTime() + 240.0
		x.efacreset = true
	elseif x.efacreset and x.efactime < GetTime() and not IsAlive(x.efac) and IsAlive(x.ercy) and (GetDistance(x.player, "epfac") > 350) then
		x.efac = BuildObject("sbfact", 5, "epfac")
		x.efacreset = false
	end

	--CALL CENTER - DU U SPEK INGESH?
	if x.calltime < GetTime() then
		if not x.callplayed then
			if x.call_state == 1 then
				x.callme = AudioMessage("tcss0600.wav") --INTRO - take out comm outpost to N. Connct w/ x.eldrdg at nav1
			elseif x.call_state == 2 then
				x.callme = AudioMessage("tcss0601.wav") --Cmd. x.eldr at disposal. Rzr 1 drop camera. Watch for CCA Runners
			elseif x.call_state == 3 then
				x.callme = AudioMessage("tcss0616.wav") --Cmd, won't make past gtows. Find another way in.
			elseif x.call_state == 4 then
				x.callme = AudioMessage("tcss0602.wav") --Rzr, work up to peak. Will drop a nav at my location to get in.
			elseif x.call_state == 5 then
				x.callme = AudioMessage("tcss0618.wav") --Rzr1 - Volc radio interfere. Follow me, I'm going in.
				AddObjective("	")
				AddObjective("tcss0605.txt", "GREEN") --Razor 1 met.
			elseif x.call_state == 6 then
				x.callme = AudioMessage("tcss0615.wav") --Yeeeehhhhaaawww
			elseif x.call_state == 7 then
				x.callme = AudioMessage("hush01.wav") --1 second silence --No shit, really, 1 second of silence.
			elseif x.call_state == 8 then
				x.callme = AudioMessage("tcss0614.wav") --Radar down, rendv w/ Utah. Kill CCA Recy. SEE NAV BEACON.
			elseif x.call_state == 9 then
				x.callme = AudioMessage("tcss0612.wav") --FAIL - Utah recy lost.
			elseif x.call_state == 10 then
				x.callme = AudioMessage("tcss0613.wav") --SUCCEED - Excellent work. You a shining star.
			end
			x.obj_state = x.call_state --set obj before reset x.call_state
			x.callplayed = true
		end
		x.call_state = 0

		if IsAudioMessageDone(x.callme) and x.obj_state ~= 0 then
			ClearObjectives()
			if x.obj_state == 1 then
				AddObjective("Oversee deployment of armory and turrets.")
				--AddObjective("tcss0600.txt") --Go West.	Deploy Armory and Badgers.	Rendezvous with Cmd. Eldridge and the 6th Platoon.	Destroy the CCA Radar Tower.
			elseif x.obj_state == 2 then
				AddObjective("tcss0601.txt") --Go to CCA outpost nav. Destroy any CCA Runners before that can return and x.call for reinforcements.
			elseif x.obj_state == 3 then
				AddObjective("tcss0602.txt", "GREEN") --CCA outpost entrance found.
				AddObjective("	")
				AddObjective("tcss0603.txt") --Find a way in that bypasses the Gun Towers.
			elseif x.obj_state == 4 then
				AddObjective("tcss0604.txt") --Meet up with Razor 1 and infiltrate the CCA outpost.
			elseif x.obj_state == 5 then
				x.gotobailout = true
			elseif x.obj_state == 6 then
				AddObjective("tcss0606.txt") --Accelerate toward the East: W Before going over clelseiff, bail out : CTRL B Activate rocketpack and fly over the wall into the CCA outpost : C
			elseif x.obj_state == 7 then
				AddObjective("tcss0607.txt") --Find a way, and destroy the CCA Radar Tower.
			elseif x.obj_state == 8 then
				AddObjective("tcss0608.txt") --Go to nav NSDF Base, deploy the Utah, and build a base. New units and structurers are available for production.
				AddObjective("	")
				AddObjective("tcss0609.txt") --DESTROY THE CCA BASE.
			elseif x.obj_state == 9 then
				AddObjective("tcss0611.txt", "RED") --The Utah has been destroyed.MISSION FAILEDnot 
			elseif x.obj_state == 10 then
				AddObjective("tcss0610.txt", "GREEN") --CCA base destroyed. MISSION SUCCESFUL.
			end
			x.obj_state = 0 --reset after display
			x.calltime = 99999.9
			x.callplayed = false
		end
	end
	
	--CHECK STATUS OF MISSION-CRITICAL ASSETS (MCA)
	if not x.MCAcheck then    
		if x.frcygiven and not IsAlive(x.frcy) then --lost recycler
			x.calltime = GetTime() + 2.0
			x.call_state = 9
			TCC.FailMission(GetTime() + 10.0, "tcss06f1.des") --LOSER LOSER LOSER
			x.spine = 666
			x.MCAcheck = true
		end
		
		if not x.dontkillmebro and not IsAlive(x.farm) then 
      ClearObjectives()
      AddObjective("Keep SLF/armory alive until Eldridge has been met.\nMISSION FAILED!", "RED")
			TCC.FailMission(GetTime() + 5.0, "tcss06f1.des") --LOSER LOSER LOSER
			x.spine = 666
			x.MCAcheck = true
		end
	end
  
  --RAZOR 1 LIVES  --put at end since so much, and help ensure no save file mess up
  if x.casualty == 0 and x.gotrazorpilot and IsAlive(x.ecom) then  --x.fgrp[10] to pilot in AddObject() now, instead of removing him
    SetObjectiveName(x.fgrp[10], "Razor 1 Pilot")
    SetObjectiveOn(x.fgrp[10])
    SetSkill(x.fgrp[10], x.skillsetting+1)
    TCC.SetTeamNum(x.fgrp[10], 1)
    x.waittime = GetTime() + 3.0  --4.0 kinda long
    x.casualty = x.casualty + 1
  elseif x.casualty == 1 and IsAlive(x.fgrp[10]) and IsAlive(x.ecom) and x.waittime < GetTime() then  --kick the tires and light the fires
    SetWeaponMask(x.fgrp[10], 00100)  --for jetpack only
    SetTarget(x.fgrp[10], x.ecom)  --REALLY? (highlights for player too, tried different things to turn back off but didn't work)
    FireAt(x.fgrp[10], x.ecom)  --Yes, really, "fire" jetpack at comm tower. (After 6 other methods, this only one I got to work.)
    x.waittime = GetTime() + 4.0
    x.casualty = x.casualty + 1
  elseif x.casualty == 2 and IsAlive(x.fgrp[10]) and IsAlive(x.ecom) and x.waittime < GetTime() then  --get over the wall ... by any means necessary
    --B/c he would always go west, jetpack doesn't last long enough and setavoidtype 0 doesn't help to make him go east toward wall, so...
    --It's not cheating if you don't get caught, so forget you read the following line
    SetVelocity(x.fgrp[10], SetVector(75.0, 50.0, 0.0))  --world vector  --lol, x=200 shot him across map
    SetWeaponMask(x.fgrp[10], 00001)  --return to gun
    x.casualty = x.casualty + 1
  elseif x.casualty == 3 and IsAlive(x.fgrp[10]) and GetDistance(x.fgrp[10], x.ecom) < 100 then  --whoa there cowboy
    SetVelocity(x.fgrp[10], SetVector(0.0, 0.0, 0.0))  --world vector
    x.casualty = x.casualty + 1
  elseif x.casualty == 4 and IsAlive(x.fgrp[10]) and IsAlive(x.ecom) and IsAlive(x.player) then  --stop, just stop
    if GetDistance(x.player, x.ecom) > 150 then
      Stop(x.fgrp[10])  --repeatedly, so he won't attack anything
    else
      Follow(x.fgrp[10], x.player, 0)
      x.casualty = x.casualty + 1
    end
  elseif x.casualty == 5 and IsAlive(x.player) and IsCraftButNotPerson(x.player) then  --goto vehicle area
    if IsAlive(x.fgrp[10]) then
      Goto(x.fgrp[10], "epa5", 0)  --he often gets killed by MG Tower if goes to any closer path
    end
    x.casualty = x.casualty + 1
  elseif x.casualty == 6 and not IsAlive(x.frcy) then  --tell me what to do
    for index = 5, 9 do  --(very) minor chance another player pilot could trigger this
      if IsAlive(x.fgrp[index]) and GetTeamNum(x.fgrp[index]) == 1 and not IsPlayer(x.fgrp[index]) then
        AudioMessage("avfighvj.wav")  --Razor here  --stole from Herp
        AudioMessage("avfighv2.wav")  --let me at'em
        Retreat(x.fgrp[index], x.player, 0)  --make sure "new" Razor 1 goes to player
        x.casualty = 0
        break
      elseif not IsAlive(x.ecom) then --and not IsAlive(x.fgrp[10]) then
        x.casualty = 0
        break
      end
    end
  end
  
  --HARD RESET
  if not x.MCAcheck and not IsAlive(x.frcy) and x.gotrazorpilot and x.casualty > 1 and x.casualty < 6 and (x.fgrp[10] == nil or not IsAlive(x.fgrp[10])) then
    AudioMessage("emdotcox.wav")
    AddObjective("Razor 1 didn't make it.", "DKRED", 4.0)
    x.casualty = 0
  end
end
--END OF SCRIPT