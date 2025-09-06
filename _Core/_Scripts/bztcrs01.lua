--bztcrs01 - Battlezone Total Command - Red Storm - 1/8 - NEW KIDS ON THE BLOCK
assert(load(assert(LoadFile("_requirefix.lua")),"_requirefix.lua"))();
TCC = require("TC_Core")
MisnNum = 12;
--DECLARE variables --f-friend, e-enemy, atk-attack, rcy-recycler, etc..., 
local index = 1
local x = {
	FIRST = true,
	spine = 0,
	getiton = false, 
	MCAcheck = false,
	waittime = 99999.9,
	player = nil, 
	mytank = nil, 
	skillsetting = 0,
	pos = {}, 
	audio1 = nil, 
	audio6 = nil, 
	fnav = {}, 
	failslow = 0, 
	failtime = 99999.9, 
	bombtime = 99999.9, 
	camstate = 0, 
  camfov = 60,  --185 default
	userfov = 90,  --seed
	cargo = {}, --1box 2bomb 3relic 4nuke
	eatk = {}, 
	eatkstate = 0, 
	ercy = nil,
	efac = nil,
	earm = nil,
	ebay = nil, 
	ecom = nil, 
	ecomstate = 0,
	etec = nil, 
	etrn = nil,
	egun = {}, 
	ehng = nil,
	ehqr = nil, 
	epwr = {}, 
	epat = {}, 
	etug = {}, 
	etugstate = 0, 
	epilo = {}, --cca pilots
	epilostate = 0, 
	epilospawn = {},	
	spawnrange = 0, 
	eprx = {}, 
	escv = {}, 
	etur = {}, 
	eturb = {}, --cliff set
	fally = {}, 
	farm = nil,
	fdrp = nil,
	fgrp = {},
	ftec = nil,
	fpwr1 = nil,
	frcy = nil,
	fscv = {}, 
	failescort = 0, 
	loosenukes = 0, 
	notsafe = false, 
	casualty = 0, 
	ekillfrcytime = 99999.9, 
	ekillfrcybuild = false, 
	ekillfrcylength = 0, 
	ekillfrcy = {}, 
	ekillfrcybuild = false, 
	ekillfrcyreset = false, 
	ekillfrcywave = 0, 
	ekillfrcymarch = false, 
	ekillfrcymeet = 0, 
	ekillfrcythereyet = false, 
	ekillfrcythereyet2 = false,
	LAST = true
}
--Paths: fnav1-2, epilo1-40, pbomb, prelic, petug1-4, fpgrp1-2, fally1-6, fpmeet, pgate, fpsafe90, fpsafe180, epeast, epwest, pcam1, fparm, fprcy, fppwr1, fphqr, pool1-2, eprcy, epfac, eparm, epcom, epbay, eptrn, eptec, eppwr1-8, epgun1-12, eptur1-4, ppatrol1-6, theline, theline2, ccabase (no longer used, but did work of insidearea)

function InitialSetup()
	SetAutoGroupUnits(true)
	
	local odfpreload = {
		"kspilors01", "kvarmors01", "kvrecyrs01", "kbtcen", "kbpgen0", "kbscav", "kvhtnk", "olyrelicprtl", "oproxars01", "abnukeprop00", 
		"sbpgen0", "svturr", "svscout", "svmbike",	"svmisl", "svtank", "svrckt", "svtug", "sbhangrs01", "sspilors01", "sbcrat00rs01", "apdwqka", "apcamrk"
	}
	for k,v in pairs(odfpreload) do
		PreloadODF(v)
	end

	x.fdrp = GetHandle("fdrp")
	x.mytank = GetHandle("mytank")
	x.frcy = GetHandle("frcy")
	x.farm = GetHandle("farm")
	x.ftec = GetHandle("fhqr")
	x.fpwr = GetHandle("fpwr")
	x.ercy = GetHandle("ercy")
	x.efac = GetHandle("efac")
	x.earm = GetHandle("earm")
	x.ehng = GetHandle("ehng")
	x.ecom = GetHandle("ecom")
	x.ebay = GetHandle("ebay")
	x.etrn = GetHandle("etrn")
	x.etec = GetHandle("etec")
	for index = 1, 12 do
		x.egun[index] = GetHandle(("egun%d"):format(index))
	end
	for index = 1, 5 do
		x.escv[index] = GetHandle(("escv%d"):format(index))
	end
	for index = 1, 60 do
		x.epilo[index] = GetHandle(("epilo%d"):format(index))
	end
	for index = 1, 10 do
		x.eturb[index] = GetHandle(("eturb%d"):format(index))
	end
	for index = 1, 13 do
		x.eprx[index] = GetHandle(("eprx%d"):format(index))
	end
	for index = 1, 4 do
		x.epat[index] = GetHandle(("epat%d"):format(index))
	end
	--All this ally stuff b/c perceived team doesn't work as expected with preplaced units, or BuildObject spawned units.
	--Which really ticks me off b/c I don't get to use the well-working insidearea function.
	Ally(1, 4) --4 Cth artifact
	Ally(4, 1) --4 Cth artifact
	Ally(2, 4)
	Ally(4, 2)
	Ally(1, 2) --2 CRA diversion force
	Ally(2, 1) --2 CRA diversion force
	Ally(7, 1) --7 CCA conversion for player tug ... 
	Ally(1, 7) 
	for index = 4, 7 do
		Ally(index, 4)
		Ally(index, 5)
		Ally(index, 6)
		Ally(index, 7)
	end
	SetTeamColor(2, 20, 60, 100)  
	SetColorFade(6.0, 0.5, "BLACK")
	TCC.Init()
end


function Start()
	TCC.SetBonusGoal("scrapused");
	TCC.Start();
end

function Save()
return
	index, x, TCC.Save()
end

function Load(a, c, coreData)
	index = a;
	x = c;
	TCC.Load(coreData)
end

function AddObject(h)
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

function Update()
	x.player = GetPlayerHandle() --EVERY PASS SO IF PLAYER CHANGES VEHICLES
	x.skillsetting = IFace_GetInteger("options.play.difficulty")
	TCC.Update()
	
	--SETUP MISSION BASICS
	if x.spine == 0 then
		audio1 = AudioMessage("tcrs0101.wav") --Welcome Gany. CCA here. Inspect hangar to N. Snipers out.
		x.pos = GetTransform(x.mytank)
		RemoveObject(x.mytank)
		x.mytank = BuildObject("kspilors01", 1, x.pos) --doing special pilot
		SetAsUser(x.mytank, 1)
		RemoveObject(x.player)
		x.player = GetPlayerHandle()
		for index = 1, 8 do
			x.epwr[index] = BuildObject("sbpgen0", 5, ("eppwr%d"):format(index))
		end
		x.pos = GetTransform(x.ehng)
		RemoveObject(x.ehng)
		x.ehng = BuildObject("sbhangrs01", 5, x.pos) --MAKE SURE IS RIGHT ODF
		x.epat[5] = BuildObject("svscout", 5, "ppatrol3")
		x.epat[6] = BuildObject("svscout", 5, "ppatrol4")
		x.epat[7] = BuildObject("svscout", 5, "ppatrol5")
		x.epat[8] = BuildObject("svscout", 5, "ppatrol6")
		for index = 1, 10 do --cuz that's in orig
			GiveWeapon(x.egun[index], "gstbsa_a")
		end
		for index = 1, 10 do --ridge turrets
			x.pos = GetTransform(x.eturb[index])
			RemoveObject(x.eturb[index])
			x.eturb[index] = BuildObject("svturr", 5, x.pos)
			SetSkill(x.eturb[index], x.skillsetting)
		end
		for index = 1, 13 do --build proxmines
			x.pos = GetTransform(x.eprx[index])
			RemoveObject(x.eprx[index])
			x.eprx[index] = BuildObject("oproxars01", 5, x.pos) --std prox w/ long lifespan
		end
		for index = 1, 4 do --base patrols for preplaced units
			if IsAlive(x.epat[index]) then
				SetSkill(x.epat[index], x.skillsetting)
				if index % 2 == 0 then
					Patrol(x.epat[index], "ppatrol1")
				else
					Patrol(x.epat[index], "ppatrol2")
				end
			end
		end
		for index = 5, 8 do --patrols snip eject skill
			SetCanSnipe(x.epat[index], 0)
			SetEjectRatio(x.epat[index], 0.0)
			SetSkill(x.epat[index], x.skillsetting)
			Patrol(x.epat[index], ("ppatrol%d"):format(index-2)) --MINUS 2
		end
		for index = 1, 60 do --init sniper spawn
			x.epilospawn[index] = 0
		end
		TCC.SetTeamNum(x.fdrp, 0) --so root doesn't show on radar
		StartEarthQuake(10.0)
		--script error--x.spawnrange = IFace_ConsoleCmd("sky.visibilityrange") + 50
		--causes crash--x.spawnrange = IFace_GetInteger("sky.visibilityRange") + 50	
		x.spawnrange = 400 --350 visibility range in map
		x.waittime = GetTime() + 4.0
		x.spine = x.spine + 1
	end

	--HOVERING - MAKE QUAKE BIGGER
	if x.spine == 1 and x.waittime < GetTime() then
		UpdateEarthQuake(30.0)
		x.waittime = GetTime() + 3.0
		x.spine = x.spine + 1
	end

	--OPEN DROPSHIP DOORS
	if x.spine == 2 and x.waittime < GetTime() then
		SetAnimation(x.fdrp, "open", 1)
		UpdateEarthQuake(10.0) --MAKE SMALLER AGAIN
		ClearObjectives()
		AddObjective("tcrs0100.txt", "ALLYBLUE")
		AddObjective("Caution: \n-Movement restricted by special equipment.\n-Limited time before CCA realizes your presence.", "YELLOW")
		UpdateEarthQuake(5.0)
		x.fnav = BuildObject("apcamrk", 1, "fnav1")
		SetObjectiveName(x.fnav, "Dropzone")
		SetObjectiveOn(x.fnav)
		StartSoundEffect("dropdoor.wav")
		x.waittime = GetTime() + 5.0
		x.spine = x.spine + 1
	end
	
	--CHECK IF PLAYER HAS LEFT DROPSHIP
	if x.spine == 3 and x.waittime < GetTime() then
		x.player = GetPlayerHandle()
		if not IsAlive(x.fdrp) or (GetDistance(x.player, x.fdrp) > 80) then
			StopEarthQuake()
			x.epilostate = 1
			SetObjectiveName(x.ehng, "Research Hangar")
			SetObjectiveOn(x.ehng)
			AddObjective(" ")
			AddObjective("tcrs0101.txt")  
			x.failtime = GetTime() + 901.0
			StartCockpitTimer(900, 600, 120)
			x.failslow = 1
			x.waittime = GetTime() + 1.0
			x.spine = x.spine + 1
		end
	end
	
	--DROPSHIP TAKEOFF
	if x.spine == 4 and x.waittime < GetTime() then
		SetAnimation(x.fdrp, "takeoff", 1)
		StartSoundEffect("dropleav.wav", x.fdrp)
		x.waittime = GetTime() + 15.0
		x.spine = x.spine + 1
	end

	--REMOVE DROPSHIP
	if x.spine == 5 and x.waittime < GetTime() then
		RemoveObject(x.fdrp)
		if IsAlive(x.fnav) then
			RemoveObject(x.fnav) --this is the dropzone nav
		end
		x.spine = x.spine + 1
	end
	
	--HAS PLAYER GOTTEN TO HANGAR
	if x.spine == 6 and IsAlive(x.player) and IsAlive(x.ehng) and GetDistance(x.player, x.ehng) < 300 then 
		StopCockpitTimer() 
		HideCockpitTimer()
		x.failtime = 99999.9
		x.failslow = 0
    ClearObjectives()
		AddObjective("tcrs0101.txt")
    AddObjective("Do not destroy any buildings.", "YELLOW")
		x.spine = x.spine + 1
	end
	
	--HAS CCA HANGAR BEEN INSPECTED
	if x.spine == 7 and IsAlive(x.ehng) and IsInfo("sbhangrs01") then
		SetObjectiveOff(x.ehng)
		ClearObjectives()
		AddObjective("tcrs0101.txt", "GREEN")
		if x.epilostate == 1 then --not really needed since have distance check to ehng
			x.epilostate = 2
		end--
		x.audio1 = AudioMessage("tcrs0102.wav") --Most interesting. Get away. Take same route out as in.
		x.spine = x.spine + 1
	end
	
	--POST HANG START OFF SCAVS PAUSE
	if x.spine == 8 and IsAudioMessageDone(x.audio1) then
		x.waittime = GetTime() + 10.0
		x.spine = x.spine + 1
	end
	
	--ECOM AUDIO AND BUILD FRIENDLY STUFF
	if x.spine == 9 and x.waittime < GetTime() then
		x.audio1 = AudioMessage("tcrs0103.wav") --Change of plan. Will take tech. Destroy comm tower.
		x.fscv[1] = BuildObject("kbscav", 1, "pool1")
		x.fscv[2] = BuildObject("kbscav", 1, "pool2")
		x.farm = BuildObject("kbarmors01", 1, "fparm")
		x.frcy = BuildObject("kvrecyrs01", 1, "fprcy")
		Goto(x.frcy, "fprcy")
		x.fpwr = BuildObject("kbpgen0", 1, "fppwr1")
		x.ftec = BuildObject("kbtcen", 1, "fphqr") --SWAPPED OUT HQTR
		x.epilostate = 1 --restart epilo
		x.spine = x.spine + 1
	end
	
	--ORDER TO KILL ECOM
	if x.spine == 10 and IsAudioMessageDone(x.audio1) then
		AudioMessage("tcrs0104.wav") --Armory available ofr deployment.
		AddObjective(" ")
		AddObjective("tcrs0102.txt")
		x.ecomstate = 1
		x.spine = x.spine + 1
	end
	
	--GIVE SCRAP ONCE CAPACITY ACHIEVED
	if x.spine == 11 and IsOdf(x.fscv[1], "kbscav") and IsOdf(x.fscv[2], "kbscav") then
		SetObjectiveOn(x.ecom)
		AddScrap(1, 80) --just enough to build the daywrecker
		AddScrap(5, 40)
		x.spine = x.spine + 1
	end
	
	--IF ECOM DEAD ORDER TO FRCY
	if x.spine == 12 and not IsAlive(x.ecom) then
		AudioMessage("tcrs0105.wav") --Well done Mjr. Make haste and return to Recy.
		ClearObjectives()
		AddObjective("tcrs0101.txt", "GREEN")
		AddObjective(" ")
		AddObjective("tcrs0102.txt", "GREEN")
		AddObjective(" ")
		AddObjective("tcrs0103.txt")
		x.ecomstate = 2
    --[[when activates, it targets one of the pilots, can't figure out why, but am keeping for future reference
    for index = 1, 60 do
			if IsAlive(x.epilo[index]) then
				Attack(x.player, x.epilo[index])
			end
		end--]]
    SetObjectiveOn(x.frcy)
		x.spine = x.spine + 1
	end
	
	--START UP THE ATTACKS
	if x.spine == 13 and GetDistance(x.player, x.frcy) < 300 then
    SetObjectiveOff(x.frcy)
    Stop(x.frcy, 0)
		ClearObjectives()
		AddObjective("tcrs0101.txt", "GREEN")
		AddObjective(" ")
		AddObjective("tcrs0102.txt", "GREEN")
		AddObjective(" ")
		AddObjective("tcrs0103.txt", "GREEN")
		AddObjective(" ")
		AddObjective("tcrs0104.txt")
		AddObjective(" ")
		AddObjective("SAVE", "DKGREY")
		x.ekillfrcytime = GetTime()
		x.eatkstate = 1
		x.spine = x.spine + 1
	end
	
	--BUILD ETUG AND HAVE IT PICKUP CARGO
	if x.spine == 14 and x.etugstate == 1 then --etugstate start on 5th attack wave
		ClearObjectives()
		AddObjective("tcrs0101.txt", "GREEN")
		AddObjective(" ")
		AddObjective("tcrs0102.txt", "GREEN")
		AddObjective(" ")
		AddObjective("tcrs0103.txt", "GREEN")
		AddObjective(" ")
		AddObjective("tcrs0104.txt", "GREEN")
		x.etug = BuildObject("svtug", 5, "petug1")
		x.cargo[1] = BuildObject("sbcrat00rs01", 0, "petug2")
		Pickup(x.etug, x.cargo[1])
		x.etugstate = 2
		for index = 1, 60 do --kill epilot if any left
			Damage(x.epilo[index], 200)
		end
		x.spine = x.spine + 1
	end
	
	--ETUG HAS CARGO, SEND OFF, BUILD ESCORT, NOTE TO PLAYER
	if x.spine == 15 and x.etug == GetTug(x.cargo[1]) then	
		Retreat(x.etug, x.ercy)
		x.eatk[1] = BuildObject("svscout", 5, "petug3")
		SetSkill(x.eatk[1], x.skillsetting)
		Defend2(x.eatk[1], x.etug)
		x.eatk[2] = BuildObject("svscout", 5, "petug4")
		SetSkill(x.eatk[2], x.skillsetting)
		Defend2(x.eatk[2], x.etug)
		x.spine = x.spine + 1
	end	
	
	--ETUG PLAYER ORDER
	if x.spine == 16 then
		x.fnav = BuildObject("apcamrk", 1, "fnav2")
		SetObjectiveName(x.fnav, "Intercept Tug")
		AudioMessage("tcrs0106.wav") --A Russian tug in quad. Get to NAV, and SNIPE tug.
		SetObjectiveOn(x.etug)
		ClearObjectives()
		AddObjective("tcrs0105.txt")
		x.spine = x.spine + 1
	end
	
	--ETUG NOW IS PLAYER
	if x.spine == 17 and IsAlive(x.player) and IsOdf(x.player, "svtug") then
		SetObjectiveOff(x.etug)
		ClearObjectives()
		AddObjective("tcrs0105.txt", "GREEN")
		AddObjective(" ")
		AddObjective("tcrs0106.txt")
		RemoveObject(x.fnav)
		x.etugstate = 3
    for index = 1, 60 do  --safety call
      if IsAlive(x.epilo[index]) then 
        Damage(x.epilo[index], (GetCurHealth(x.epilo[index]) + 5))
      end
    end
		x.spine = x.spine + 1
	end

	--MESSAGE AT RTB
	if x.spine == 18 and IsAlive(x.player) and IsAlive(x.frcy) and GetDistance(x.player, x.frcy) < 64 then
		AudioMessage("tcrs0107.wav") --(At recy) Take tug to CCA base. Leave nuke. Two fight esc
		ClearObjectives()
		AddObjective("tcrs0105.txt", "GREEN")
		AddObjective(" ")
		AddObjective("tcrs0106.txt", "GREEN")
		AddObjective(" ")
		AddObjective("tcrs0107.txt")
		x.fgrp[1] = BuildObject("svscout", 1, "fpgrp1")
		SetSkill(x.fgrp[1], x.skillsetting)
		Follow(x.fgrp[1], x.player, 0)
		x.fgrp[2] = BuildObject("svscout", 1, "fpgrp2")
		SetSkill(x.fgrp[2], x.skillsetting)
		Follow(x.fgrp[2], x.player, 0)
		x.failescort = 1
		x.cargo[2] = BuildObject("abnukeprop00", 4, "pbomb")
		SetObjectiveName(x.cargo[2], "Mini-Nuke")
		SetObjectiveOn(x.cargo[2])
		x.spine = x.spine + 1
	end
	
	--PICKUP BOMB, SEND ON WAY
	if x.spine == 19 and x.player == GetTug(x.cargo[2]) then 
		x.ekillfrcytime = GetTime() --unpause for final attacks
		SetObjectiveOff(x.cargo[2])
		ClearObjectives()
		AddObjective("tcrs0107.txt", "GREEN")
		AddObjective(" ")
		AddObjective("tcrs0108.txt")
		AddObjective(" ")
		AddObjective("tcrs0108b.txt")
		x.cargo[3] = BuildObject("olyrelicprtl", 4, "prelic")
		SetObjectiveName(x.cargo[3], "Cthonian Artifact")
		SetObjectiveOn(x.cargo[3])
		x.loosenukes = 1
		x.spine = x.spine + 1
	end
	
	--TUG AT FIRST LINE OF DEFENSE
	if x.spine == 20 and GetDistance(x.player, "pgate") < 150 then
		if GetDistance(x.fgrp[1], x.player) < 100 and GetDistance(x.fgrp[2], x.player) < 100 then
			AudioMessage("tcrs0109.wav") --Diversion attack underway.
			ClearObjectives()
			AddObjective("tcrs0108.txt", "GREEN")
			AddObjective(" ")
			AddObjective("tcrs0108b.txt")
			x.ekillfrcytime = 99999.9 --stop frcy attacks
			x.eatkstate = 2 --SEND IN DIVERSION ATTACK
			for index = 1, 10 do --switch some 5 to 7
				TCC.SetTeamNum(x.egun[index], 7)
			end
			TCC.SetTeamNum(x.ercy, 7)
			TCC.SetTeamNum(x.efac, 7)
			TCC.SetTeamNum(x.earm, 7)
			TCC.SetTeamNum(x.etrn, 7)
			TCC.SetTeamNum(x.etec, 7)
			TCC.SetTeamNum(x.ehng, 7)
      TCC.SetTeamNum(x.ebay, 7)
			TCC.SetTeamNum(x.escv[5], 7)
			for index = 1, 4 do
				TCC.SetTeamNum(x.etur[index], 7)
				TCC.SetTeamNum(x.epat[index], 7)
			end
			for index = 1, 8 do
				TCC.SetTeamNum(x.epwr[index], 7)
			end
			x.failescort = 4 --don't worry about escorts
			x.spine = x.spine + 1
		elseif not IsAlive(x.fgrp[1]) or not IsAlive(x.fgrp[2]) or (GetDistance(x.fgrp[1], x.player) > 100) or (GetDistance(x.fgrp[2], x.player) > 100) then
			x.failescort = 2
		end
	end
	
	--PICKUP ARTIFACT
	if x.spine == 21 and x.player == GetTug(x.cargo[3]) then 
		x.loosenukes = 2 --note nuke placed and don't pick back up
		ClearObjectives()
		AddObjective("tcrs0108b.txt", "GREEN")
		AddObjective("	")
		AddObjective("tcrs0109.txt")
		x.fnav = BuildObject("apcamrk", 1, "fpsafe90") --USING 90 SECS	ALT: "fpsafe180"
		SetObjectiveName(x.fnav, "Safe Distance")
		SetObjectiveOn(x.fnav)
		AudioMessage("alertpulse.wav")
		StartCockpitTimer(90, 45, 15)
		x.bombtime = GetTime() + 90.5 --USING 90 SECS
		x.spine = x.spine + 1
	end
	
	--ONE LAST SAFETY CHECK
	if x.spine == 22 and not x.notsafe and x.bombtime <= GetTime() then
		x.waittime = GetTime() + 1.0 --let MCAcheck run one last time
		x.spine = x.spine + 1
	end
	
	--IF PLAYER SAFE GIVE FINAL MESSAGES
	if x.spine == 23 and x.waittime < GetTime() then
		AudioMessage("tcrs0110.wav") --SUCCEED - Shield your eyes major. (nuke explode)
		ClearObjectives()
		AddObjective("tcrs0109.txt", "GREEN")
		StopCockpitTimer()
		HideCockpitTimer()
		x.MCAcheck = true
		x.waittime = GetTime() + 1.0
		x.spine = x.spine + 1
	end
	
	--SAFE WHITEOUT
	if x.spine == 24 and x.waittime < GetTime() then
		SetColorFade(6.0, 1.0, "WHITE")
		x.waittime = GetTime() + 1.0
		x.spine = x.spine + 1
	end
	
	--START CAMERA BEFORE DETONATION
	if x.spine == 25 and x.waittime < GetTime() then
    x.userfov = IFace_GetInteger("options.graphics.defaultfov")
    CameraReady()
    IFace_SetInteger("options.graphics.defaultfov", x.camfov)
		x.camstate = 1
		x.waittime = GetTime() + 3.0
		x.spine = x.spine + 1
	end
	
	--PLACE BOMB, GIVE TIME TO WATCH EXPLOSION
	if x.spine == 26 and x.waittime < GetTime() then
		x.cargo[4] = BuildObject("apdwqka", 1, x.cargo[2]) --detonates immediately
		x.waittime = GetTime() + 7.0
		x.spine = x.spine + 1
	end
	
	--SUCCEED MSSION	
	if x.spine == 27 and x.waittime < GetTime() then
    CameraFinish()
    IFace_SetInteger("options.graphics.defaultfov", x.userfov)
		TCC.SucceedMission(GetTime(), "tcrs01w.des") --winner winner winner
		x.spine = x.spine + 1
	end
	----------END MAIN SPINE ----------
	
	--SPAWN CCA GUARDS
	if x.epilostate == 1 then
		for index = 1, 10 do --main EAST squads
			--attackers 1-10
			if x.epilospawn[index] == 0 then
				x.pos = GetTransform(x.epilo[index])
				RemoveObject(x.epilo[index])
				x.epilo[index] = BuildObject("sspilors01", 6, x.pos) --diff team so doesn't retreat to recy
				SetSkill(x.epilo[index], x.skillsetting + 1) --pilo need help
				Attack(x.epilo[index], x.player)  
				--SetObjectiveName(x.epilo[index], ("%d atkr"):format(index))
				--SetObjectiveOn(x.epilo[index])
				x.epilospawn[index] = 1
			end
			
			--waiters 11-20
			if x.epilospawn[index+10] == 0 and GetDistance(x.player, x.epilo[index+10]) < x.spawnrange then --50 + 350 visibilityrange in map
				x.pos = GetTransform(x.epilo[index+10])
				RemoveObject(x.epilo[index+10])
				x.epilo[index+10] = BuildObject("sspilors01", 6, x.pos)
				SetSkill(x.epilo[index+10], x.skillsetting + 1) --pilo need help
				Attack(x.epilo[index+10], x.player)
				--SetObjectiveName(x.epilo[index+10], ("%d wait"):format(index+10))
				--SetObjectiveOn(x.epilo[index+10])
				x.epilospawn[index+10] = 1
			end
			
			--snipers 21-30
			if x.epilospawn[index+20] == 0 and GetDistance(x.player, x.epilo[index+20]) < x.spawnrange then
				x.pos = GetTransform(x.epilo[index+20])
				RemoveObject(x.epilo[index+20])
				x.epilo[index+20] = BuildObject("sspilors01", 6, x.pos)
				SetSkill(x.epilo[index+20], 3) --sniper need help
				SetWeaponMask(x.epilo[index+20], 10)
				Deploy(x.epilo[index+20])
				FireAt(x.epilo[index+20], x.player, true) --so will deploy to snip right away, and will shoot player at long range
				x.epilospawn[index+20] = 1
				--SetObjectiveName(x.epilo[index+20], ("%d snip"):format(index+20))
				--SetObjectiveOn(x.epilo[index+20])
			elseif x.epilospawn[index+20] == 1 and IsAlive(x.epilo[index+20]) and GetCurLocalAmmo(x.epilo[index+20], 2) < 1 then --NEED TO SWITCH TO LOCAL B/C SNIPE NOW LOCAL
				SetCurLocalAmmo(x.epilo[index+20], 3, 2) --so can snipe faster
			end
			
			--westside 31-40
			if x.epilospawn[index+30] == 0 and GetDistance(x.player, x.epilo[index+30]) < x.spawnrange then
				x.pos = GetTransform(x.epilo[index+30])
				RemoveObject(x.epilo[index+30])
				x.epilo[index+30] = BuildObject("sspilors01", 6, x.pos)
				SetSkill(x.epilo[index+30], x.skillsetting + 1) --pilo need help
				--SetObjectiveName(x.epilo[index+30], ("%d west"):format(index+30))
				--SetObjectiveOn(x.epilo[index+30])
				x.epilospawn[index+30] = 1
			end
			
			--theline 41-50
			if x.epilospawn[index+40] == 0 and GetDistance(x.player, "theline", index) < x.spawnrange then
				x.epilo[index+40] = BuildObject("sspilors01", 6, "theline", index)
				SetSkill(x.epilo[index+40], x.skillsetting + 1) --pilo need help
				Attack(x.epilo[index+40], x.player)
				--SetObjectiveName(x.epilo[index+40], ("%d line"):format(index+40))
				--SetObjectiveOn(x.epilo[index+40])
				x.epilospawn[index+40] = 1
			end
			
			--theline2 51-60
			if x.epilospawn[index+50] == 0 and GetDistance(x.player, "theline2", index) < x.spawnrange then
				x.epilo[index+50] = BuildObject("sspilors01", 6, "theline2", index)
				SetSkill(x.epilo[index+50], x.skillsetting + 1) --pilo need help
				Attack(x.epilo[index+50], x.player)
				--SetObjectiveName(x.epilo[index+50], ("%d line2"):format(index+50))
				--SetObjectiveOn(x.epilo[index+50])
				x.epilospawn[index+50] = 1
			end
		end
	elseif x.epilostate == 2 then --or GetDistance(x.player, x.ehng) < 450 then
		for index = 1, 10 do
			if IsAlive(x.epilo[index]) then
				Goto(x.epilo[index], "theline", index)
			end
			if IsAlive(x.epilo[index+10]) then
				Goto(x.epilo[index+10], "theline", index)
			end
			if IsAlive(x.epilo[index+40]) then
				Goto(x.epilo[index+40], "theline", index)
			end
			if IsAlive(x.epilo[index+50]) then
				Goto(x.epilo[index+50], "theline", index)
			end
		end--]]
		x.epilostate = 0 --pause
	end
	
	--CCA GROUP KILL FRIENDLY RECYCLER 
	if x.eatkstate >= 1 and x.eatkstate < 666 and x.ekillfrcytime < GetTime() then
		if not x.ekillfrcybuild then
			for index = 1, x.ekillfrcylength do
				if not IsAlive(x.ekillfrcy[index]) then
					x.casualty = x.casualty + 1
				end
			end
			
			if x.casualty < math.floor(x.ekillfrcylength	* 0.8) then
				x.casualty = 0
			elseif not x.ekillfrcyreset then
				x.casualty = 0
				x.ekillfrcybuild = true
				x.ekillfrcyreset = true
				x.ekillfrcywave = x.ekillfrcywave + 1
				if x.ekillfrcywave > 6 then
					x.ekillfrcywave = 6
				end
				
				if x.ekillfrcywave == 1 then
					x.ekillfrcylength = 4
				elseif x.ekillfrcywave == 2 then
					x.ekillfrcylength = 8
				elseif x.ekillfrcywave == 3 then
					x.ekillfrcylength = 12 --16
				elseif x.ekillfrcywave == 4 then
					x.ekillfrcylength = 16 --24
				elseif x.ekillfrcywave == 5 then
					x.ekillfrcylength = 20 --24 --32 was killing frcy
					x.etugstate = 1
				elseif x.ekillfrcywave == 6 then
					x.ekillfrcylength = 24
				end
			end
		end
		
		if x.ekillfrcybuild then
			for index = 1, x.ekillfrcylength do
				while x.randompick == x.randomlast do --random the random
					x.randompick = math.floor(GetRandomFloat(1.0,8.0))
				end
				x.randomlast = x.randompick
				
				if x.randompick == 1 or x.randompick == 2 then
					x.ekillfrcy[index] = BuildObject("svmbike", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
				elseif x.randompick == 3 or x.randompick == 4 then
					x.ekillfrcy[index] = BuildObject("svmisl", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
				elseif x.randompick == 5 or x.randompick == 6 then
					x.ekillfrcy[index] = BuildObject("svtank", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
				elseif x.randompick == 7 or x.randompick == 8 then
					x.ekillfrcy[index] = BuildObject("svrckt", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
				end
				SetSkill(x.ekillfrcy[index], x.skillsetting)
			end
			x.ekillfrcymarch = true
			x.ekillfrcyreset = false
			x.ekillfrcybuild = false
		end
		
		if x.ekillfrcymarch then
			if x.ekillfrcymeet == 0 then
				x.ekillfrcymeet = 1
			else
				x.ekillfrcymeet = 0
			end
			
			for index = 1, x.ekillfrcylength do
				if IsAlive(x.ekillfrcy[index]) then
					if x.ekillfrcymeet == 0 or x.ekillfrcymeet == 1 then --nother lazy misn spcl hack of prev stuff
						if index % 2 == 0 then
							Goto(x.ekillfrcy[index], "epeast")
						else
							Goto(x.ekillfrcy[index], "epwest")
						end
					end
				end
			end
			
			x.ekillfrcymarch = false
			x.ekillfrcythereyet = true
			x.ekillfrcythereyet2 = false
		end
		
		if x.ekillfrcythereyet then
			for index = 1, x.ekillfrcylength do
				if IsAlive(x.ekillfrcy[index]) and (GetDistance(x.ekillfrcy[index], "epeast") < 20 or GetDistance(x.ekillfrcy[index], "epwest") < 20) then
					x.ekillfrcythereyet = false
					x.ekillfrcythereyet2 = true
				end
			end
		end
		
		if x.ekillfrcythereyet2 then
			for index = 1, x.ekillfrcylength do
				if IsAlive(x.ekillfrcy[index]) then
					if IsAlive(x.frcy) then
						Attack(x.ekillfrcy[index], x.frcy)
					elseif IsAlive(x.farm) then
						Attack(x.ekillfrcy[index], x.farm)
					elseif IsAlive(x.ftec) then
						Attack(x.ekillfrcy[index], x.ftec)
					end
					x.ekillfrcytime = GetTime() + 90.0
					if x.ekillfrcywave == 5 and x.etugstate == 1 then
						x.ekillfrcytime = 99999.9 --pause
					end
				end
			end
		end
	end
	
	--SEND IN DIVERSION ATTACK
	if x.eatkstate == 2 then
		for index = 1, 6 do
			if not IsAlive(x.fally[index]) then
				x.fally[index] = BuildObject("kvhtnk", 2, ("fally%d"):format(index))
				SetSkill(x.fally[index], 3)
				Patrol(x.fally[index], "epgrcy") --not attack
			end
		end
	end
	
	--CCA TURRET CANYON GROUP
	if x.eatkstate < 2 then
		for index = 1, 4 do
			if not IsAlive(x.etur[index]) then
				x.etur[index] = BuildObject("svturr", 5, GetPositionNear("epgrcy", 0, 16, 32)) --grpspwn
				SetSkill(x.etur[index], x.skillsetting)
				Goto(x.etur[index], ("eptur%d"):format(index))
			end
		end
	end
	
	--KEEP ECOM ALIVE UNTIL DAY WRECKER HITS
	if IsAlive(x.ecom) then
		SetCurHealth(x.ecom, (GetMaxHealth(x.ecom) - 20)) --ensure DWHE will destroy though
	end
	
	--RUN THE CCA BASE EXPLOSION CAMERA
	if x.camstate == 1 then
		CameraObject(x.ehng, 30, 60, -230, x.ehng)
	end
	
	--CHECK STATUS OF MCA ----------------------------------
	if not x.MCAcheck then	 --whooboy, thar's lots-o-ways to screw this one up
		--CCA tug escaped
		if x.etugstate == 2 and IsAlive(x.etug) and GetDistance(x.etug, "pgate") < 100 then
			AudioMessage("tcrs0111.wav") --FAIL - generic for all instances.
			ClearObjectives()
			AddObjective("tcrs0110.txt", "RED") --You did not recover the CCA tug. MISSION FAILED!
			TCC.FailMission(GetTime() + 10.0, "tcrs01f1.des") --LOSER LOSER LOSER
			x.spine = 666
			x.MCAcheck = true
		end
		
		--CCA tug destoyed before snipe
		if x.etugstate >= 2 and not IsAround(x.etug) then --IsAround so player can snipe
			AudioMessage("tcrs0111.wav") --FAIL - generic for all instances.
			ClearObjectives()
			AddObjective("tcrs0111.txt", "RED") --You destroyed the CCA tug. MISSION FAILED!
			TCC.FailMission(GetTime() + 10.0, "tcrs01f2.des") --LOSER LOSER LOSER
			x.spine = 666
			x.MCAcheck = true
		end
		
		--no escorts when re-entering CCA base
		if x.failescort == 2 then
			x.audio6 = AudioMessage("tcrs0108.wav") --RUS - Caller Epsilon where is escort. CRA - Try your Russian
			ClearObjectives()
			x.failescort = 3
			x.spine = 666
		elseif x.failescort == 3 and IsAudioMessageDone(x.audio6) then
			AddObjective("tcrs0112.txt", "RED") --Without the Flanker escorts, your deception was discovered. MISSION FAILED!
			TCC.FailMission(GetTime() + 5.0, "tcrs01f3.des") --LOSER LOSER LOSER
			x.MCAcheck = true
		end
		
		--escorts killed before CCA base arrival
		if x.failescort == 1 and (not IsAlive(x.fgrp[1]) or not IsAlive(x.fgrp[2])) then
			AudioMessage("alertpulse.wav")
			ClearObjectives()
			AddObjective("tcrs0112.txt", "RED") --Without the Flanker escorts, your deception was discovered. MISSION FAILED!
			TCC.FailMission(GetTime() + 5.0, "tcrs01f3.des") --LOSER LOSER LOSER
			x.MCAcheck = true
		end
		
		--recycler dead
		if x.ecomstate >= 1 and x.failescort < 1 and not IsAlive(x.frcy) then
			AudioMessage("tcrs0111.wav") --FAIL - generic for all instances.
			ClearObjectives()
			AddObjective("tcrs0113.txt", "RED") --You lost your Recycler.	MISSION FAILED!
			TCC.FailMission(GetTime() + 10.0, "tcrs01f4.des") --LOSER LOSER LOSER
			x.spine = 666
			x.MCAcheck = true
		end
		
		--caught in nuke blast
		if x.etugstate >= 3 and x.bombtime < GetTime() and (GetDistance(x.ehng, "fpsafe90") > (GetDistance(x.player, x.ehng) + 32)) then
			x.notsafe = true --caught in blast
			AudioMessage("xemt2.wav")
			SetColorFade(20.0, 0.1, "WHITE")
			TCC.FailMission(GetTime() + 1.0, "tcrs01f5.des") --LOSER LOSER LOSER
			x.spine = 666
			x.MCAcheck = true
		end
		
		--destroyed other CCA building too soon
		if not x.notsafe and (not IsAlive(x.ercy) or not IsAlive(x.efac) or not IsAlive(x.earm)
			or not IsAlive(x.ehng) or not IsAlive(x.etrn) or not IsAlive(x.etec) or not IsAlive(x.ebay)
			or not IsAlive(x.epwr[1]) or not IsAlive(x.epwr[2]) or not IsAlive(x.epwr[3]) or not IsAlive(x.epwr[4]) 
			or not IsAlive(x.epwr[5]) or not IsAlive(x.epwr[6]) or not IsAlive(x.epwr[7]) or not IsAlive(x.epwr[8])) then
			AudioMessage("tcrs0111.wav") --FAIL - generic for all instances.
			ClearObjectives()
			AddObjective("tcrs0114.txt", "RED") --You were not authorized to destroy other CCA facilities.	MISSION FAILED!
			TCC.FailMission(GetTime() + 10.0, "tcrs01f6.des") --LOSER LOSER LOSER
			x.spine = 666
			x.MCAcheck = true
		end
		
		--didn't destroy cca comm tower
		if x.ecomstate == 1 and IsAlive(x.ecom) and IsAlive(x.player) and GetDistance(x.player, x.ecom) > 1600 then 
			AudioMessage("tcrs0111.wav") --FAIL - generic for all instances.
			ClearObjectives()
			AddObjective("tcrs0115.txt", "RED") --You failed to destroy the CCA comm tower before leaving their base.	MISSION FAILED!
			TCC.FailMission(GetTime() + 10.0, "tcrs01f7.des") --LOSER LOSER LOSER
			x.spine = 666
			x.MCAcheck = true
		end
		
		--loose nuke in wrong place
		if (x.loosenukes == 1 and ((IsAlive(x.cargo[2]) and not GetTug(x.cargo[2]) and GetDistance(x.cargo[2], x.ehng) > 64) or not IsAlive(x.cargo[2]))) 
		or (x.loosenukes == 2 and x.player == GetTug(x.cargo[2])) then
			--AudioMessage("alertpulse.wav")
			ClearObjectives()
			AddObjective("tcrs0116.txt", "RED") --You dropped the nuke. RUN!!!!
			AudioMessage("xemt2.wav")
			SetColorFade(20.0, 0.25, "WHITE")
			TCC.FailMission(GetTime() + 3.0, "tcrs01f8.des") --LOSER LOSER LOSER
			x.spine = 666
			x.MCAcheck = true
		end
		
		--nuke destroyed before detonate OR artifact destroyed
		if not x.notsafe and x.loosenukes >= 1 and (not IsAlive(x.cargo[2]) or not IsAlive(x.cargo[3])) then
			ClearObjectives()
			AddObjective("tcrs0117.txt", "RED") --Critical mission asset destroyed.	MISSION FAILED!
			TCC.FailMission(GetTime() + 3.0, "tcrs01f9.des") --LOSER LOSER LOSER
			x.spine = 666
			x.MCAcheck = true
		end
		
		--player fails by time to get to hangar
		if x.failslow == 1 and x.failtime < GetTime() then
			AudioMessage("alertpulse.wav")
			ClearObjectives()
			AddObjective("tcrs0118.txt", "RED") --CCA knows you're here. Base on full alert.	MISSION FAILED!
			TCC.FailMission(GetTime() + 3.0, "tcrs01f10.des") --LOSER LOSER LOSER
			x.spine = 666
			x.MCAcheck = true
		end
	end
end
function ObjectSniped(p, k) --NEEDED IF PLAYER SNIPED WHILE IN VEHICLE
	if p == x.player then
		SetColorFade(20.0, 0.5, "DKRED")
		ClearObjectives()
		AddObjective("tcrs0817.txt", "RED")
		AudioMessage("alertpulse.wav")
		TCC.FailMission(GetTime() + 3.0, "tcrs08f10.des") --LOSER LOSER LOSER
		MCAcheck = true
		x.spine = 666
	end
end
--[[END OF SCRIPT]]