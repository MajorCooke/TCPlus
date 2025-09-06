--bztcrs04 - Battlezone Total Command - Red Storm - 4/8 - FROM OUT OF NOWHERE
assert(load(assert(LoadFile("_requirefix.lua")),"_requirefix.lua"))();
TCC = require("TC_Core")
MisnNum = 18;
--DECLARE variables --f-friend, e-enemy, atk-attack, rcy-recycler, etc..., 
local index = 1
local x = {
	FIRST = true,
	spine = 0,
	MCAcheck = false,
	waittime = 99999.9,
	player = nil, 
	mytank = nil, 
	skillsetting = 0,
	easy = 0, 
	medium = 1, 
	hard = 2, --tried 1-3, in 185, 3 didn't seem to make any difference, 
	randompick = 0, 
	randomlast = 0, 
	casualty = 0, 
	pos = {},	
	fnav = {}, 
	audio1 = nil, 
	audio2 = nil,	
	audio6 = nil, 
	camfov = 60,  --185 default
	userfov = 90,  --seed
	camstate = 0, 
	camheight = 2000, 
	camtime = 99999.9, 
	escapetime = 99999.9, 
	failstate = 0, 
	mytanklives = false, 
	jetpackstate = 0, 
	fprt = nil, --portal
	fprtdummy = nil, 
	fprtgotit = false, 
	ffac = nil, 
	frcy = nil, 
	ftur = {}, 
	fpwr = {}, 
	fgun = {}, 
	emine = {},
	door = {}, 
	dummycube1 = nil, 
	marker = 0, --marker stuff
	markerstate = 0, 
	markerlast = 16, 
	markertime = 99999.9, 
	markerdone = 0, 
	coward = 0, 
	cloakcheck = 0, --cloak stuff
	cloakstate = 0, 
	cloakremindtime = 99999.9, 
	cloakfailtime = 99999.9, 
	ccontrols = {deploy = 0}, 
	undeploytime = 99999.9, 
	datastate = 0, --data hack stuff
	datapingtime = 99999.9, 
	datatime = 99999.9, 
	datawarn = false, 
	datastart = false, 
	retreatstate = 0, 
	retreattime = 99999.9, 
	eenter = nil, --entrance ramp for cam1
	esilcpu = nil, 
	ehngcpu = nil, 
	etnk = {}, --interior tanks
	etnktime = 99999.9, 
	etnkclock = 0,
	etnkminus = 0, 
	etnkstate = {},	
	epilot = {}, 
	epildmy = {}, 
	eint = {},
	eintdmy = {}, 
	elazy = nil, 
	efac = nil, 
	ebay = nil, 
	etrn = nil, 
	etec = nil, 
	epwr = {}, 
	etur = {}, 
	egun = {}, 
	eatk = {}, --base attack
	eatktime = 99999.9, 
	easn = {}, --assassins
	easntime = 99999.9, 
	easnbuilt = false, 
	epattime = 99999.9, --epatrols
	epatlength = 6, 
	epat = {}, 
	epatcool = {}, 
	epatallow = {},
	LAST = true
}
--Paths: safepath, minefield, pcam1, pcam2, pcam3, ppatrol1-6, ppatrol7-11(interior tank 6-10), epatk1-6, retreatpath

function InitialSetup()
	SetAutoGroupUnits(true)
	
	local odfpreload = {
		"kspilo", "kvscout", "kvturr", "kvfact", "kvrecy", "kbpgen0", "kbgtow1", "sbtunt1h", "sbtunt1h_loop", "sbdoor10_loop", 
		"sspilo", "svscout", "svtank", "svturr", "sbpgen1", "oproxars04", "dummy00", "apdwqka", "ibnav", "apcamrk"
	}
	for k,v in pairs(odfpreload) do
		PreloadODF(v)
	end

	x.mytank = GetHandle("mytank")
	x.eenter = GetHandle("eenter")
	x.esilcpu = GetHandle("esilcpu")
	x.ehngcpu = GetHandle("ehngcpu")
	x.elazy = GetHandle("elazy")
	x.efac = GetHandle("efac")
	x.ebay = GetHandle("ebay")
	x.etec = GetHandle("etec")
	x.etrn = GetHandle("etrn")
	x.fprt = GetHandle("fprt")
	x.ffac = GetHandle("ffac")
	x.frcy = GetHandle("frcy")
	x.fpwr[1] = GetHandle("fpwr1")
	x.fpwr[2] = GetHandle("fpwr2")
	x.fgun[1] = GetHandle("fgun1")
	x.fgun[2] = GetHandle("fgun2")
	x.dummycube1 = GetHandle("dummycube1")
	for index = 1, 5 do
		x.epwr[index] = GetHandle(("epwr%d"):format(index))
		x.egun[index] = GetHandle(("egun%d"):format(index))
		x.eintdmy[index] = GetHandle(("eint%d"):format(index))
	end
	for index = 1, 12 do --door[1] entrance, door[2] silo, door[3] westpass, door[4] tosilo, door[5] cpu, door[6] bay, door[7] hangar, post silo door[8]-[9], to hangar door[10]-[12] 
		x.door[index] = GetHandle(("door%d"):format(index))
	end
	for index = 1, 10 do
		x.ftur[index] = GetHandle(("ftur%d"):format(index))
	end
	for index = 1, 20 do
		x.etnk[index] = GetHandle(("etnk%d"):format(index))
		x.epildmy[index] = GetHandle(("esld%d"):format(index))
	end
	--Ally(1, 3) --do later 
	Ally(5, 3) --3 dummy object for computer room
	Ally(3, 1)
	Ally(3, 5)
	Ally(1, 4)  
	Ally(4, 1) --4 allied recy, fact, and turrets	
  Ally(1, 6) --for emptye flanker ...
  Ally(5, 6) --so doesn't get killed by CCA patrols when avail to player
	SetColorFade(6.0, 0.5, "BLACK")
	TCC.Init()
end


function Start()
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
  --[[if x.spine >= 14 then
		Ally(1, 3)
	end--]]
end

function AddObject(h)  
	if not x.fprtgotit and IsOdf(h, "dummy00") then
		x.fprtdummy = h
		x.fprtgotit = true
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
	SetPerceivedTeam(x.player, 1)  --try to keep player enemy even if in sniped vehicle
	TCC.Update()
	
	--SETUP MISSION BASICS
	if x.spine == 0 then
		x.audio1 = AudioMessage("tcrs0401.wav") --Running short of BMetal. Nav mark safe path to CCA silo.
		x.pos = GetTransform(x.mytank)
		RemoveObject(x.mytank)
		x.mytank = BuildObject("kvscout", 1, x.pos)
		SetAsUser(x.mytank, 1)
		RemoveObject(x.player)
		x.player = GetPlayerHandle()
		x.pos = GetTransform(x.ffac)
		RemoveObject(x.ffac)
		x.ffac = BuildObject("kvfact", 4, x.pos)
		x.pos = GetTransform(x.frcy)
		RemoveObject(x.frcy)
		x.frcy = BuildObject("kvrecy", 4, x.pos)
		for index = 1, 2 do
			x.pos = GetTransform(x.fpwr[index])
			RemoveObject(x.fpwr[index])
			x.fpwr[index] = BuildObject("kbpgen0", 4, x.pos)
			x.pos = GetTransform(x.fgun[index])
			RemoveObject(x.fgun[index])
			x.fgun[index] = BuildObject("kbgtow1", 4, x.pos)
		end
		for index = 1, 10 do 
			x.pos = GetTransform(x.ftur[index])
			RemoveObject(x.ftur[index])
			x.ftur[index] = BuildObject("kvturr", 4, x.pos)
		end
		for index = 1, 20 do
			x.pos = GetTransform(x.epildmy[index])
			RemoveObject(x.epildmy[index])
			x.epildmy[index] = BuildObject("dummy00", 0, x.pos) --swap visible with invisible dummy for later
		end
		for index = 1, 5 do
			x.pos = GetTransform(x.epwr[index])
			RemoveObject(x.epwr[index])
			x.epwr[index] = BuildObject("sbpgen1", 5, x.pos)
			x.pos = GetTransform(x.eintdmy[index])
			RemoveObject(x.eintdmy[index])
			x.eintdmy[index] = BuildObject("dummy00", 0, x.pos) --swap visible with invisible dummy for later
		end
		x.epattime = GetTime() + 30.0
		for index = 1, x.epatlength do --init epat
			x.epatcool[index] = GetTime()
			x.epatallow[index] = true
		end
		x.undeploytime = GetODFFloat(x.mytank, "DeployableClass", "timeUndeploy", 0.0) --in case odf value is changed
		x.camheight = 2000
		x.camstate = 1
    x.userfov = IFace_GetInteger("options.graphics.defaultfov")
    CameraReady()
    IFace_SetInteger("options.graphics.defaultfov", x.camfov)
		x.spine = x.spine + 1
	end
	
	--START MINEFIELD RUN
	if x.spine == 1 and (IsAudioMessageDone(x.audio1) or CameraCancelled()) then
    CameraFinish()
    IFace_SetInteger("options.graphics.defaultfov", x.userfov)
		x.camstate = 0
		x.audio1 = AudioMessage("tcrs0407.wav") --Follow the safe path we have marked out Mjr.
		for index = 0, 198 do --199 mines... coz
			x.emine[index] = BuildObject("oproxars04", 5, "minefield", index) --use unlimited lifespan mine
		end
		x.marker = 1 --init since can't have "0" index
		x.fnav[x.marker] = BuildObject("ibnav", 4, "safepath", x.marker-1) --4 b/c blue lil' easier to see than yellow
		SetObjectiveName(x.fnav[x.marker], "START")
		SetObjectiveOn(x.fnav[x.marker])
		SetAnimation(x.door[1], "open", 1) --door[1] entrance
		SetAnimation(x.door[2], "open", 1) --door[2] silo
		SetAnimation(x.door[4], "open", 1) --door[4] tosilo
		x.pos = GetTransform(x.egun[5]) --b/c gtow was too x.hard
		RemoveObject(x.egun[5])
		x.egun[5] = BuildObject("svturr", 5, x.pos)
		x.spine = x.spine + 1
	end
	
	--SET THE TIMER
	if x.spine == 2 and IsAudioMessageDone(x.audio1) then
		if x.skillsetting == x.easy then
			StartCockpitTimer(390, 180, 90)
			x.markertime = GetTime() + 392.0
		elseif x.skillsetting == x.medium then
			StartCockpitTimer(380, 180, 90)
			x.markertime = GetTime() + 382.0
		else
			StartCockpitTimer(370, 180, 90)
			x.markertime = GetTime() + 372.0
		end
		x.markerstate = 1
		x.cloakcheck = 1
		x.spine = x.spine + 1
	end
	
	--PLAYER AT LAST MARKER
	if x.spine == 3 and GetDistance(x.player, "safepath", (x.markerlast-1)) < 50 then
		x.markertime = 99999.9
		x.markerdone = 1
		x.mytanklives = true
		x.markerstate = 2
		RemoveObject(x.fnav[x.marker])
		ClearObjectives()
		AddObjective("tcrs0401.txt", "GREEN", 2.0) --Times are cumulative
		AddObjective("\n\nEnter the CCA base and find the Silo control computer", "WHITE", 2.0)
		AddObjective("SAVE", "DKGREY", 2.0)
		StopCockpitTimer()
		HideCockpitTimer()
		for index = 1, 10 do --build vehicle early, will be at ground in cineractive
			x.etnkstate[index] = 0 --init for later attacks
			x.pos = GetTransform(x.etnk[index])
			RemoveObject(x.etnk[index])
			if index >= 1 and index <= 5 then
				x.etnk[index] = BuildObject("svscout", 5, x.pos)
			elseif index >= 6 and index <= 10 then
				x.etnk[index] = BuildObject("svtank", 5, x.pos)
			end
			RemovePilot(x.etnk[index])
		end
		x.spine = x.spine + 1
	end
	
	--SETUP BASE INTERIOR CAMERA
	if x.spine == 4 and GetDistance(x.player, "safepath", (x.markerlast-1)) > 200 then
		for index = 11, 20 do --pilots for empty vehicles
			x.etnkstate[index] = 0 --init for later attacks
			x.pos = GetTransform(x.etnk[index])
			RemoveObject(x.etnk[index])
			x.etnk[index] = BuildObject("sspilo", 5, x.pos)
			GetIn(x.etnk[index], x.etnk[index-10])
		end
		x.camstate = 2
		x.camtime = GetTime() + 8.0
    x.userfov = IFace_GetInteger("options.graphics.defaultfov")
    CameraReady()
    IFace_SetInteger("options.graphics.defaultfov", x.camfov)
		x.spine = x.spine + 1
	end
	
	--FINISH CCA INTERIOR CAMERA
	if x.spine == 5 and ((x.camtime < GetTime()) or CameraCancelled()) then
    CameraFinish()
    IFace_SetInteger("options.graphics.defaultfov", x.userfov)
		x.camstate = 0
		x.cloakfailtime = GetTime() + 5.0
		SetObjectiveOn(x.esilcpu)
		for index = 1, 3 do --silo pilots
			x.pos = GetTransform(x.epildmy[index])
			x.epilot[index] = BuildObject("sspilo", 5, x.pos)
			SetSkill(x.epilot[index], x.skillsetting)
			Defend2(x.epilot[index], x.epildmy[index])
		end
		ClearObjectives()
		AddObjective("tcrs0403.txt")
		x.spine = x.spine + 1
	end

	--PAUSE IF ID COMPRESSION SILO COMPUTER TO READ INFO CARD
	if x.spine == 6 and x.camstate == 0 and IsInfo("sbconsolers04") then
		x.coward = 2
		x.waittime = GetTime() + 2.0
		x.spine = x.spine + 1
	end
	
	--CONFIRM ID, SETUP DOORS, BEGIN FAIL CLOAK
	if x.spine == 7 and x.waittime < GetTime() then
		x.audio1 = AudioMessage("tcrs0404.wav") --CCA stockpile scrap. Now get back to base.
		ClearObjectives()
		AddObjective("tcrs0403.txt", "GREEN")
		SetObjectiveOff(x.esilcpu)
		if x.cloakstate == 0 then
			x.cloakfailtime = GetTime() + 3.0
			x.cloakstate = 1
		end
		x.pos = GetTransform(x.door[2]) --door[2] silo
		RemoveObject(x.door[2])
		x.door[2] = BuildObject("sbdoor10_loop", 0, x.pos)
		x.pos = GetTransform(x.door[5]) --door[5] cpu
		RemoveObject(x.door[5])
		x.door[5] = BuildObject("sbdoor10_loop", 0, x.pos)
		x.spine = x.spine + 1
	end
		
	--A ERROR OBJECTIVE - AND ANIMATE DOORS
	if x.spine == 8 and IsAudioMessageDone(x.audio1) then
		if IsAround(x.mytank) then
			AudioMessage("tcrs0403.wav") --alarm SFX
			AddObjective("tcrs0404a.txt", "YELLOW")
		end
		SetAnimation(x.door[1], "close", 1) --door[1] entrance
		SetAnimation(x.door[3], "open", 1) --door[3] westpass
		SetAnimation(x.door[4], "close", 1) --door[4] tosilo
		SetAnimation(x.door[8], "open", 1)
		SetAnimation(x.door[9], "open", 1)
		x.waittime = GetTime() + 2.0
		x.spine = x.spine + 1
	end
	
	--B ERROR OBJECTIVE
	if x.spine == 9 and x.waittime < GetTime() then
		ClearObjectives()
		if IsAround(x.mytank) then
			AddObjective("tcrs0404a.txt", "YELLOW")
			AddObjective("tcrs0404b.txt", "ORANGE")
		end
		x.waittime = GetTime() + 2.0
		x.spine = x.spine + 1
	end
	
	--C ERROR OBJECTIVE -BUILD INT GROUP
	if x.spine == 10 and x.waittime < GetTime() then
		ClearObjectives()
		if IsAround(x.mytank) then
			AddObjective("tcrs0404a.txt", "YELLOW")
			AddObjective("tcrs0404b.txt", "ORANGE")
			AddObjective("tcrs0404c.txt", "CYAN")
		end
		for index = 1, 5 do
			x.pos = GetTransform(x.eintdmy[index])
			x.eint[index] = BuildObject("svscout", 5, x.pos)
			--Setskill(x.eint[index], x.skillsetting)
			Defend2(x.eint[index], x.eintdmy[index])
		end
		x.waittime = GetTime() + 2.0
		x.spine = x.spine + 1
	end
	
	--D ERROR OBJECTIVE
	if x.spine == 11 and x.waittime < GetTime() then
		ClearObjectives()
		if IsAround(x.mytank) then
			AddObjective("tcrs0404a.txt", "YELLOW")
			AddObjective("tcrs0404b.txt", "ORANGE")
			AddObjective("tcrs0404c.txt", "CYAN")
			AddObjective("tcrs0404d.txt", "PURPLE")
		end
		Attack(x.epilot[1], x.player)
		Attack(x.epilot[2], x.player)
		Attack(x.epilot[3], x.player)
		x.waittime = GetTime() + 2.0
		x.spine = x.spine + 1
	end
	
	--E ERROR OBJECTIVE
	if x.spine == 12 and x.waittime < GetTime() then
		ClearObjectives()
		if IsAround(x.mytank) then
			AddObjective("tcrs0404a.txt", "YELLOW")
			AddObjective("tcrs0404b.txt", "ORANGE")
			AddObjective("tcrs0404c.txt", "CYAN")
			AddObjective("tcrs0404d.txt", "PURPLE")
			AddObjective("tcrs0404e.txt", "LAVACOLOR")
		end
		x.eatktime = GetTime()
		x.waittime = GetTime() + 10.0
		x.spine = x.spine + 1
	end
	
	--NOTIFY PLAYER THE CCA IS ATTACKING
	if x.spine == 13 and x.waittime < GetTime() then
		AudioMessage("tcrs0408.wav") --Retreat through the portal. All units retreat.
		ClearObjectives()
		if IsAround(x.mytank) then
			AddObjective("tcrs0404e.txt", "LAVACOLOR")
			AddObjective("	")
		end
		AddObjective("tcrs0405a.txt") --cca attack, soon retreat
		AddObjective("SAVE", "DKGREY")
		x.waittime = GetTime() + 3.0
		x.spine = x.spine + 1
	end
	
	--TELL PLAYER TO GO TO COMMAND ROOM COMPUTER
	if x.spine == 14 and x.waittime < GetTime() then
		ClearObjectives()
		if IsAround(x.mytank) then
			AddObjective("tcrs0404e.txt", "LAVACOLOR")
			AddObjective("	")
		end
		AddObjective("tcrs0405a.txt", "GREY") --cca attack, soon retreat
		AddObjective("	")
		AddObjective("tcrs0405b.txt") --goto computer
		x.pos = GetTransform(x.dummycube1)
		RemoveObject(x.dummycube1)
		x.dummycube1 = BuildObject("dummy00", 3, x.pos)
		SetObjectiveName(x.dummycube1, "Main Computer")
		SetObjectiveOn(x.dummycube1)
		Ally(1, 3)
		x.etnktime = GetTime() --send garrison to kill player
		for index = 4, 10 do
			x.pos = GetTransform(x.epildmy[index])
			x.epilot[index] = BuildObject("sspilo", 5, x.pos)
			SetSkill(x.epilot[index], x.skillsetting)
			Defend2(x.epilot[index], x.epildmy[index])
		end
		x.spine = x.spine + 1
	end
	
	--PAUSE INTERIOR TANK ATTACK
	if x.spine == 15 and GetDistance(x.player, x.dummycube1) < 30 then
		for index = 4, 10 do
			Attack(x.epilot[index], x.player)
		end
		x.etnktime = GetTime() + 600.0 --pause interior attack
		x.spine = x.spine + 1
	end
	
	--TELL PLAYER TO HOLD POSITION WHILE HACKING, BEGIN DATA RETRIEVAL
	if x.spine == 16 and GetDistance(x.player, x.dummycube1) < 2 then
		ClearObjectives()
		AddObjective("tcrs0405b.txt", "GREEN")
		AddObjective("	")
		AddObjective("tcrs0406.txt") --hack main computer
		x.datastate = 1
		x.spine = x.spine + 1
	end
	
	--PLAYER ARRIVED AT HANGAR BAY
	if x.spine == 17 and x.datastate == 2 and GetDistance(x.player, x.door[6]) < 100 then
		ClearObjectives()
		AddObjective("tcrs0407.txt") --activate the surface doors
		Attack(x.epilot[index], x.player)
		Attack(x.epilot[15], x.player)
		Attack(x.epilot[16], x.player)
		x.spine = x.spine + 1
	end
	
	--OPEN THE POD BAY DOORS HAL
	if x.spine == 18 and IsInfo("sbconsolehng") then
		ClearObjectives()
		AddObjective("tcrs0407.txt", "GREEN") --activate the surface doors
		AddObjective("	")
		AddObjective("tcrs0408.txt", "YELLOW") --Door hack partially successful. Watch your timing and use your rocket pack to escape to the surface while the doors are cycled to open.
		SetObjectiveOff(x.ehngcpu)
		StartSoundEffect("dropdoor.wav")
		x.pos = GetTransform(x.door[7])
		RemoveObject(x.door[7])
		x.door[7] = BuildObject("sbtunt1h_loop", 0, x.pos) --door[7] hangar
		for index = 17, 20 do
			Attack(x.epilot[index], x.player)
		end
		x.spine = x.spine + 1
	end
	
	--PLAYER HAS EXITED THE BASE	
	if x.spine == 19 and GetDistance(x.player, x.door[7]) > 200 then
		x.cloakstate = 5 --just to be safe and not interfere w/ jetpack fail
		x.pos = GetTransform(x.door[7])
		RemoveObject(x.door[7])
		x.door[7] = BuildObject("sbtunt1h", 0, x.pos) --door[7] "CLOSE THE DOOR"
		SetAnimation(x.door[7], "close")
		ClearObjectives()
		AddObjective("tcrs0408.txt", "GREEN") --escaped from CCA base
		AddObjective("	")
		AddObjective("tcrs0409.txt") --RTB to portal
		SetObjectiveOn(x.fprt)
		if x.skillsetting == x.easy then
			StartCockpitTimer(220, 120, 60)
			x.escapetime = GetTime() + 270.0
			x.easntime = GetTime() + 45.0
		elseif x.skillsetting == x.medium then
			StartCockpitTimer(200, 120, 60)
			x.escapetime = GetTime() + 240.0
			x.easntime = GetTime() + 40.0
		else
			StartCockpitTimer(180, 90, 45)
			x.escapetime = GetTime() + 210.0
			x.easntime = GetTime() + 35.0
		end
		for index = 3, 4 do --build here so player doesn't see them spawn
			x.easn[index] = BuildObject("svscout", 5, ("epatk%d"):format(index))
			SetSkill(x.easn[index], x.skillsetting)
			SetObjectiveName(x.easn[index], ("Assassin %d"):format(index-2))
		end
		x.retreatstate = 1 --to watch allies retreat
		x.waittime = GetTime() + 15.0
		x.etnktime = 99999.9
		for index = 1, 10 do 
			if IsAlive(x.etnk[index]) and GetTeamNum(x.etnk[index]) ~= 1 then
				Stop(x.etnk[index])
			end
		end
		x.spine = x.spine + 1
	end
	
	--FAIL JETPACK
	if x.spine == 20 and x.waittime < GetTime() then
		AudioMessage("tcrs0403.wav") --alarm SFX
		ClearObjectives()
		AddObjective(">>>Foreign code detected<<<", "YELLOW")
		AddObjective(">>>Rocket Pack FAILURE<<<", "LAVACOLOR")
		AddObjective("	")
		AddObjective("tcrs0409.txt") --RTB to portal
		x.jetpackstate = 1
		x.waittime = GetTime() + 7.0
		x.spine = x.spine + 1
	end
	
	--OBJECTIFY NAPPING CCA FLANKER
	if x.spine == 21 and x.waittime < GetTime() then
		x.pos = GetTransform(x.elazy)
		RemoveObject(x.elazy)
		x.elazy = BuildObject("svscout", 6, x.pos)
		RemovePilot(x.elazy)
		SetObjectiveName(x.elazy, "Abandoned Flanker")
		SetObjectiveOn(x.elazy)
		AudioMessage("tcrs0403.wav") --alarm SFX
		x.spine = x.spine + 1
	end
	
	--SETUP PORTAL CAMERA
	if x.spine == 22 and GetDistance(x.player, x.fprt) < 120 and x.escapetime > GetTime() then
		x.escapetime = 99999.9
		x.MCAcheck = true
		StopCockpitTimer()
		HideCockpitTimer()
		x.spine = x.spine + 1
	end
		
	--MAKE SURE RECY HAS DEPARTED FIRST
	if x.spine == 23 and not IsAround(x.frcy) then
		AudioMessage("portal02.wav")
		AudioMessage("portalx.wav")
    x.userfov = IFace_GetInteger("options.graphics.defaultfov")
    CameraReady()
    IFace_SetInteger("options.graphics.defaultfov", x.camfov)
		x.spine = x.spine + 1
	end
	
	--SUCCEED MSSION	
	if x.spine == 24 and CameraPath("pcam3", 1000, 3500, x.fprtdummy) then
		TCC.SucceedMission(GetTime(), "tcrs04w.des") --winner winner winner
		x.spine = x.spine + 1
	end
	----------END MAIN SPINE ----------
	
	--TURN ON COWARD --prob overkill but it's in
	if x.coward == 0 and GetDistance(x.player, x.fprt) > 400 then
		x.coward = 1
	end
	
	--CLOAK ACTIVE REMINDER
	if x.cloakstate == 0 and IsAround(x.mytank) and ((x.cloakcheck == 1 and x.markerstate <= 2) or x.cloakremindtime < GetTime()) and not IsDeployed(x.player) then
		ClearObjectives()
		if x.markerstate == 1 then
			if x.markerdone == 0 then
				AddObjective("tcrs0401.txt")
			elseif x.markerdone == 1 then
				AddObjective("tcrs0401.txt", "GREEN")
			end
		else
			AddObjective("tcrs0403.txt")
		end
		AddObjective("	")
		AddObjective("tcrs0402.txt", "YELLOW")
		x.cloakremindtime = GetTime() + 10.0
		x.cloakcheck = 2
	elseif x.cloakstate == 0 and IsAround(x.mytank) and x.cloakcheck == 2 and x.markerstate <= 2 and IsDeployed(x.player) then
		ClearObjectives()
		if x.markerstate == 1 then
			if x.markerdone == 0 then
				AddObjective("tcrs0401.txt")
			elseif x.markerdone == 1 then
				AddObjective("tcrs0401.txt", "GREEN")
			end
		else
			AddObjective("tcrs0403.txt")
		end
		AddObjective("	")
		--AddObjective("tcrs0402.txt", "GREEN")
		AddObjective(">>>CLOAK ACTIVE<<<", "GREEN")
		x.cloakcheck = 1
	end
	
	--MINEFIELD RUN
	if x.markerstate == 1 and GetDistance(x.player, "safepath", x.marker-1) < 50 then
		RemoveObject(x.fnav[x.marker])
		x.marker = x.marker + 1
		x.fnav[x.marker] = BuildObject("ibnav", 4, "safepath",	x.marker-1) --team 4 b/c blue easier to see than yellow
		SetObjectiveName(x.fnav[x.marker], ("GOTO %d"):format(x.marker-1))
		if x.marker == x.markerlast then
			SetObjectiveName(x.fnav[x.marker], "CCA Base Entrance")
		end
		SetObjectiveOn(x.fnav[x.marker])
	end
	
	--CAMERA CCA BASE ENTRANCE
	if x.camstate == 1 then
		CameraPath("pcam1", x.camheight, 1800, x.eenter)
		x.camheight = x.camheight + 5
	end
	
	--CAMERA INSIDE CCA BASE
	if x.camstate == 2 then
		CameraObject(x.egun[1], 10, 10, 10, x.etnk[6])
	end
	
	--FAIL CLOAK
	if IsAround(x.mytank) then --only if mytank exists do the cloak thing
		if x.cloakstate == 0 and x.cloakfailtime < GetTime() and IsOdf(x.player, "kvscout") and not IsDeployed(x.player) then
			x.cloakstate = x.cloakstate + 1
		elseif x.cloakstate == 1 and x.cloakfailtime < GetTime() then
			x.cloakcheck = 0
			x.audio2 = AudioMessage("tcrs0403.wav") --alarm SFX
			x.cloakstate = x.cloakstate + 1
		elseif x.cloakstate == 2 and IsAudioMessageDone(x.audio2) then
			x.audio2 = AudioMessage("tcrs0402.wav") --CPU - core coolant failure. Shutting down cloaking device.
			x.cloakstate = x.cloakstate + 1
		elseif x.cloakstate == 3 and IsOdf(x.player, "kvscout") then
			if IsDeployed(x.player) then --CLOAK ON ALREADY
				x.controls = {deploy = 1}
				SetControls(x.player, x.controls)
				x.cloakfailtime = GetTime() + x.undeploytime --unit undeploy time 
				x.cloakstate = x.cloakstate + 1
			elseif not IsDeployed(x.player) then --CLOAK OFF ALREADY (cuz playa b kray kray)
				x.cloakfailtime = GetTime()
				x.cloakstate = x.cloakstate + 1
			end
			ClearObjectives()
			AddObjective("tcrs0404e.txt", "LAVACOLOR")
		elseif x.cloakstate == 4 and IsOdf(x.player, "kvscout") and x.cloakfailtime < GetTime() then
			x.controls = {deploy = 0} --{braccel = 0, strafe = 0, jump = 0, deploy = 0, eject = 0, abandon = 0, fire = 0}
			SetControls(x.player, x.controls)
		end
	end
	
	--FAIL JETPACK - KEEP OFF
	if x.jetpackstate == 1 and IsPerson(x.player) then
    x.controls = {deploy = 0} --{braccel = 0, strafe = 0, jump = 0, deploy = 0, eject = 0, abandon = 0, fire = 0}
    SetControls(x.player, x.controls)
	end
	
	--RETRIEVE THE DATA --------------------------------------------------
	if x.datastate == 1 then
	--DATA RETRIEVAL START
		if not x.datastart and GetDistance(x.player, x.dummycube1) <= 3 then
			x.audio2 = AudioMessage("tcss1101.wav") --Init comm uplink. Computer
			ClearObjectives()
			AddObjective("tcrs0406.txt", "ALLYBLUE")
			x.datapingtime = GetTime()
			x.datatime = GetTime() + 60.0
			x.datawarn = true
			x.datastart = true
		end
		
	--DATA RETRIEVAL WARN
		if x.datastart and x.datawarn and GetDistance(x.player, x.dummycube1) > 3 then
			x.audio2 = AudioMessage("tcss1102.wav") --Losing comm uplink. Computer
			x.datawarn = false
		end
		
	--DATA WARN RESET
		if not x.datawarn and GetDistance(x.player, x.dummycube1) <= 3 then
			x.datawarn = true
		end
		
	--DATA RETRIEVAL STOP
		if x.datastart and GetDistance(x.player, x.dummycube1) > 6 then
			x.audio2 = AudioMessage("tcss1103.wav") --Comm uplink lost Computer
			x.datatime = 99999.9
			x.datastart = false
			x.datawarn = false
		end
		
	--DATA PULSE SOUND PLAY
		if x.datastart and x.datapingtime < GetTime() and IsAudioMessageDone(x.audio2) then
			StartSoundEffect("tcss1112.wav") --scanning sound
			x.datapingtime = GetTime() + 3.0
		end
		
	--DATA RETRIEVED
		if x.datatime < GetTime() then
			AudioMessage("tcss1104.wav") --data intercept complete. Computer
			x.datatime = 99999.9
			x.datapingtime = 99999.9
			x.datastate = 2
			SetAnimation(x.door[6], "open", 1) --door[6] bay
			SetAnimation(x.door[10], "open", 1)
			SetAnimation(x.door[11], "open", 1)
			SetAnimation(x.door[12], "open", 1)
			SetObjectiveOff(x.dummycube1)
			SetObjectiveOn(x.ehngcpu)
			ClearObjectives()
			AddObjective("tcrs0406.txt", "GREEN") --hack main computer
			AddObjective("	")
			AddObjective("tcrs0407.txt") --go to hangar
			AddObjective("SAVE", "DKGREY") --go to hangar
			for index = 11, 20 do --11-13 cpu2, 14-16 hangar, 17-20 surface
				x.pos = GetTransform(x.epildmy[index])
				RemoveObject(x.epilot[index])
				x.epilot[index] = BuildObject("sspilo", 5, x.pos)
				SetSkill(x.epilot[index], x.skillsetting)
				Defend2(x.epilot[index], x.epildmy[index])
			end
			for index = 11, 13 do
				Attack(x.epilot[index], x.player)
			end
			x.etnktime = GetTime() --resume etnk attack
		end
	end
	
	--CCA GROUP SCOUT PATROLS
	if x.jetpackstate == 0 and x.epattime < GetTime() then
		for index = 1, 6 do
			if not IsAlive(x.epat[index]) and not x.epatallow[index] then
				x.epatcool[index] = GetTime() + 20.0
				x.epatallow[index] = true
			end
			
			if x.epatallow[index] and x.epatcool[index] < GetTime() then
				while x.randompick == x.randomlast do --random the random
					x.randompick = math.floor(GetRandomFloat(1.0, 15.0))
				end
				x.randomlast = x.randompick
				if x.randompick == 1 or x.randompick == 6 or x.randompick == 11 then
					x.epat[index] = BuildObject("svscout", 5, ("ppatrol%d"):format(index))
				elseif x.randompick == 2 or x.randompick == 7 or x.randompick == 12 then
					x.epat[index] = BuildObject("svmbike", 5, ("ppatrol%d"):format(index))
				elseif x.randompick == 3 or x.randompick == 8 or x.randompick == 13 then
					x.epat[index] = BuildObject("svmisl", 5, ("ppatrol%d"):format(index))
				elseif x.randompick == 4 or x.randompick == 9 or x.randompick == 14 then
					x.epat[index] = BuildObject("svtank", 5, ("ppatrol%d"):format(index))
				else
					x.epat[index] = BuildObject("svrckt", 5, ("ppatrol%d"):format(index))
				end
				SetSkill(x.epat[index], x.skillsetting)
				Patrol(x.epat[index], ("ppatrol%d"):format(index))
				x.epatallow[index] = false
			end
		end
		x.epattime = GetTime() + 30.0
	end
	
	--CCA GROUP ETNK INSIDE
	if x.etnktime < GetTime() then
		for index = 1, 10 do
			if x.etnkstate[index] == 0 then
				x.etnkstate[index] = 1
				break
			end
		end
		for index = 1, 5 do --Flankers
			if x.etnkstate[index] == 1 and IsAlive(x.etnk[index]) and GetTeamNum(x.etnk[index]) ~= 1 then
					Attack(x.etnk[index], x.player)
			end
		end
		for index = 6, 10 do --Czar tanks
			if x.etnkstate[index] == 1 and IsAlive(x.etnk[index]) and GetTeamNum(x.etnk[index]) ~= 1 then
				Goto(x.etnk[index], ("ppatrol%d"):format(index+1)) --+1 for correct path
				x.etnkstate[index] = 2
			end
		end
		x.etnkclock = 20.0
		x.etnktime = GetTime() + x.etnkclock - x.etnkminus
		if x.etnkclock <= x.etnkminus then
			x.etnktime = GetTime() + 10.0
		end
		x.etnkminus = x.etnkminus + 2.0
		if x.etnkstate[10] == 1 then
			x.etnktime = GetTime() + 30.0
		end
	end
	
	--CCA GROUP ATTACK FRCY
	if x.eatktime < GetTime() then
		for index = 1, 6 do
			if not IsAlive(x.eatk[index]) then
				x.eatk[index] = BuildObject("svscout", 5, ("epatk%d"):format(index))
				SetSkill(x.eatk[index], x.skillsetting)
			end
		end
		for index = 1, 6 do
			if IsAround(x.frcy) then
				Attack(x.eatk[index], x.frcy)
			elseif IsAround(x.ffac) then
				Attack(x.eatk[index], x.ffac)
			else
				Attack(x.eatk[index], x.player)
			end
		end
		x.eatktime = GetTime() + 20.0
	end
	
	--CCA ASSASSIN
	if x.easntime < GetTime() then--moved build before player can see
		for index = 3, 4 do
			if IsAlive(x.easn[index]) and GetTeamNum(x.easn[index]) ~= 1 then
        Attack(x.easn[index], x.player)
      end
		end
		x.easntime = GetTime() + 10.0
	end
	
	--KEEP RECY AND FAC ALIVE
	if IsAround(x.frcy) then
		SetCurHealth(x.frcy, GetMaxHealth(x.frcy))
		SetCurHealth(x.ffac, GetMaxHealth(x.ffac))
	end
	
	--RETREAT RECY AND FAC
	if x.retreatstate == 1 and GetDistance(x.player, x.fprt) < 400 then
		ClearObjectives()
		AddObjective("Recycler retreating through portal.\n\n", "CYAN")
		AddObjective("tcrs0409.txt") --RTB to portal
		Retreat(x.frcy, "retreatpath")
		x.retreatstate = 2
		--accord to Out There Somewhere, fac stayed on Gany, cap. by CCA
	elseif x.retreatstate == 2 then
		if IsAlive(x.frcy) and GetDistance(x.frcy, x.fprtdummy, 1) < 24 then
			RemoveObject(x.frcy)
			x.retreatstate = 3
		end
	end
 
	--CHECK STATUS OF MCA ----------------------------------
	if not x.MCAcheck then
		if x.mytanklives == false and x.failstate == 0 and x.markerstate == 1 and ((x.markertime < GetTime()) or not IsAround(x.mytank)) then --failed minefield run
			x.audio6 = AudioMessage("tcrs0406.wav") --FAIL - seen better nav in school (time run out/mongoose lost)
			ClearObjectives()
			AddObjective("tcrs0410.txt", "RED")
			x.failstate = 1
			x.spine = 666
		elseif x.failstate == 1 and IsAudioMessageDone(x.audio6) then
			TCC.FailMission(GetTime(), "tcrs04f1.des") --LOSER LOSER LOSER
			x.MCAcheck = true
		end
		
		if x.failstate == 0 and x.escapetime < GetTime() and GetDistance(x.player, x.fprt) > 150 then --missed the evac
			x.audio6 = AudioMessage("tcrs0405.wav") --FAIL - Weak feeble. Will be replaced (condition?)
			ClearObjectives()
			AddObjective("tcrs0411.txt", "RED")
			x.failstate = 2
			x.spine = 666
		elseif x.failstate == 2 then
			x.fnav[1] = BuildObject("apdwqka", 1, x.fprt) --detonates immediately
			x.waittime = GetTime() + 3.0
			x.failstate = 3
		elseif x.failstate == 3 and x.waittime < GetTime() and IsAudioMessageDone(x.audio6) then
			TCC.FailMission(GetTime(), "tcrs04f2.des") --LOSER LOSER LOSER
			x.MCAcheck = true
		end
		
		if x.coward == 1 and GetDistance(x.player, x.fprt) < 400 then --player return to base w/out iding silo
			ClearObjectives()
			AddObjective("tcrs04012.txt", "RED")
			x.MCAcheck = true
			x.spine = 666
			TCC.FailMission(GetTime() + 10.0, "tcrs04f1.des") --LOSER LOSER LOSER
		end
		
		if not IsAlive(x.fprt) and x.failstate < 2 then --so failstate doesn't interfere
			x.audio6 = AudioMessage("tcrs0405.wav") --FAIL - Weak feeble. Will be replaced (condition?)
			AudioMessage("alertpulse.wav")
			ClearObjectives()
			AddObjective("Portal destroyed.\n\nMISSION FAILED!", "RED")
			x.MCAcheck = true
			x.spine = 666
			TCC.FailMission(GetTime() + 10.0, "tcrs04f1.des") --LOSER LOSER LOSER
		end
	end
end
--[[END OF SCRIPT]]