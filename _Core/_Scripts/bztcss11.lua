--bztcss11 - Battlezone Total Command - Stars and Stripes - 11/17 - FLYING SOLO

--DECLARE variables --f-friend, e-enemy, atk-attack, rcy-recycler, etc...
assert(load(assert(LoadFile("_requirefix.lua")),"_requirefix.lua"))();
TCC = require("TC_Core")
MisnNum = 45;
--local rep = require("_MCModule");
local index = 0
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
	warntime = 99999.9, 
	camfov = 60,  --185 default
	userfov = 90,  --seed
	cam2bstop = false, 
	camplay0 = false,
	camplay2 = false, 
	camplay2b = false, 
	camplay3 = false, 
	camplay3b = false, 
	camplay4 = false, 
	camplay4b = false, 
	camstop1 = false, 
	camstop2 = false, 
	camstop2b = false, 
	check2 = false,
	check2warn = false, 
	check3 = false, 
	check3warn = false, 
	check4 = false, 
	check4warn = false, 
	check5 = false, 
	check5warn = false, 
	checkdone = false, 
	checklist = false, 
	clobberbool = false, 
	datadone = false, 
	datastart = false, 
	datawarn = false, 
	free_player = false, 
	controls = {braccel = 0, strafe = 0, jump = 0, deploy = 0, eject = 0, abandon = 0, fire = 0}, 
	navon1 = false, 
	navon2 = false, 
	outofship = false, 
	pauseomega1 = false, 
	playerisflanker = false, 
	redlinebool = false, 
	redlinecross = false, 
	screwed = false, 
	warnplay = false, 
	warnsend = false, 
	camtime0 = 99999.9, 
	camtime1 = 99999.9, 
	camtime2 = 99999.9, 
	clobberintime = 99999.9, 
	dataattacktime = 99999.9, 
	datapingtime = 99999.9, 
	datatime = 99999.9, 
	easnsend = false, 
	epattime = 99999.9, 
	escvbuildtime = 99999.9, 
	failtime = 99999.9, 
	pausetime = 99999.9, 
	screwedtime = 99999.9, 
	warntimereturn = 99999.9, 
	audio1 = nil, 
	audio2 = nil, 
	audio3 = nil, 
	ercy = nil, 
	efac = nil, 
	earm = nil, 
	ebay = nil, 
	ebnk = nil, 
	ehqr = nil, 
	ehq1 = nil, 
	ehq2 = nil, 
	escv = {}, 
	esil1 = nil, 
	esil2 = nil, 
	esil3 = nil, 
	esil4 = nil, 
	esil5 = nil, 
	esil6 = nil, 
	easn1 = nil, 
	easn2 = nil, 
	eomega1 = nil, 
	epat = {}, 
	etur = {}, 
	emin1 = nil, 
	emin2 = nil, 
	fdrp1 = nil, 
	fnav0 = nil, 
	fnav1 = nil, 
	fnav2 = nil, 
	fnav3 = nil, 
	fnav4 = nil, 
	fnav5 = nil, 
	fnav6 = nil, 
	holder1 = nil, 
	camheight = 300, 
	epatlength = 18, 
	eturlength = 21, 
	redlinelength = 9, 
	warncount = 0, 
	warnlimit = 2,
	LAST = true
}
--PATHS: pmytank, fpnav0-6, eptur0-9, ppatrol0-4, pcam0-3, epart1-4, predline, epmin1-2

function AddObject(h)
	if (IsAlive(h) or IsPlayer(h)) then 
		ReplaceStabber(h);
	end
	TCC.AddObject(h)
end

function InitialSetup()
	SetAutoGroupUnits(true)
	
	local odfpreload = {
		"avtank", "svscout", "svmbike", "svmisl", "svtank", "svartl", "svscav", "svmine", "svturr", "stayput", "avdrop", "gsitea", "apcamra"
	}
	for k,v in pairs(odfpreload) do
		PreloadODF(v)
	end

	x.efac = GetHandle("efac")
	x.ebay = GetHandle("ebay")
	x.etrn = GetHandle("etrn")
	x.ebnk = GetHandle("ebnk") --The comm tower
	x.ehq1 = GetHandle("ehqr1") --msn hqtr 1
	x.ehq2 = GetHandle("ehqr2") --msn hqtr 2
	x.esil1 = GetHandle("escv1")
	x.esil2 = GetHandle("escv2")
	x.esil3 = GetHandle("escv3")
	x.esil4 = GetHandle("escv4")
	x.esil5 = GetHandle("escv5")
	x.esil6 = GetHandle("escv6")
	x.fdrp1 = GetHandle("fdrp1")
	x.mytank = GetHandle("mytank")
	Ally(5, 6) --5 AI enemy
	Ally(6, 5) --6 assassin
	SetTeamColor(0, 110, 220, 100) --assassin	
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
	
	--SETUP THE MISSION BASICS
	if x.spine == 0 then
		x.pos = GetTransform(x.mytank)
		RemoveObject(x.mytank)
		x.mytank = BuildObject("avtank", 1, x.pos)
		for index = 1, x.eturlength do
			x.etur[index] = BuildObject("svturr", 5, ("eptur%d"):format(index))
			SetSkill(x.etur[index], x.skillsetting)
		end
		SetAsUser(x.mytank, 1)
		RemoveObject(x.player)
		x.player = GetPlayerHandle()
		x.fnav0 = BuildObject("apcamra", 1, "fpnav0")
		SetObjectiveName(x.fnav0, "Drop Zone")
		SetObjectiveName(x.ehq1, "Checkpoint 1")
		SetObjectiveName(x.ehq2, "Checkpoint 2")
		for index = 1, x.eturlength do
			SetSkill(x.etur[index], x.skillsetting)
		end
		AudioMessage("tcss1100.wav") --INTRO 48- Take out CCA pilo. Follow patrol route. Find comm tower.
		x.warntime = GetTime()
		x.camtime1 = GetTime() + 17.0
		x.camplay0 = true
    x.userfov = IFace_GetInteger("options.graphics.defaultfov")
    CameraReady()
    IFace_SetInteger("options.graphics.defaultfov", x.camfov)
		x.spine = x.spine + 1
	end

	--DROPSHIP LANDING SEQUENCE - START QUAKE FOR FLYING EFFECT
	if x.spine == 1 and x.camstop1 then
		MaskEmitter(x.fdrp1, 0)
		x.holder1 = BuildObject("stayput", 0, x.player)
		StartEarthQuake(10.0)
		x.waittime = GetTime() + 4.0
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
		SetAnimation(x.fdrp1, "open", 1)
		x.waittime = GetTime() + 5.0
		x.spine = x.spine + 1
	end
	
	--DOORS FULLY OPEN, GIVE MOVE ORDER--GIVE PLAYER CONTROL OF THEIR AVATAR
	if x.spine == 5 and x.waittime < GetTime() then
		RemoveObject(x.holder1)
		x.free_player = true
		x.spine = x.spine + 1
	end
	
	--CHECK IF PLAYER HAS LEFT DROPSHIP
	if x.spine == 6 then
		x.player = GetPlayerHandle()
		if IsCraftButNotPerson(x.player) and GetDistance(x.player, x.fdrp1) > 60 then
			x.spine = x.spine + 1
			--stuff moved from spine 9
			ClearObjectives()
			AddObjective("tcss1100.txt")
			StartCockpitTimer(600, 300, 120)
			x.failtime = GetTime() + 600.0
			x.eomega1 = BuildObject("svscout", 5, "ppatrol0")
			GiveWeapon(x.eomega1, "gsitea")
			SetObjectiveName(x.eomega1, "Omega 1")
			x.pausetime = GetTime()
			SetObjectiveOn(x.ehq1) --hq1
		end
	end

	--DROPSHIP 1 TAKEOFF
	if x.spine == 7 then
		for index = 1, 10 do
			StartEmitter(x.fdrp1, index)
		end
		SetAnimation(x.fdrp1, "takeoff", 1)
		StartSoundEffect("dropleav.wav", x.fdrp1)
		x.waittime = GetTime() + 15.0 --lower to get to give objective sooner
		x.spine = x.spine + 1
	end

	--REMOVE DROPSHIPS
	if x.spine == 8 and x.waittime < GetTime() then
		RemoveObject(x.fdrp1)
		x.spine = x.spine + 1
	end

	--give snip order, setup primary timer, build omega1
	if x.spine == 9 and x.camstop1 then
		--stuff moved to spine 6
		x.spine = x.spine + 1
	end

	--pause after acquire scout, start patrols
	if x.spine == 10 and IsOdf(x.player, "svscout") then
		x.eomega1 = nil --clear out this handle
		x.playerisflanker = true --for MCA status
		x.redlinebool = true
		x.waittime = GetTime() + 2.0
		x.epattime = GetTime()
		x.escvbuildtime = GetTime() + 60.0
		SetObjectiveOff(x.ehq1) --hq1
		x.spine = x.spine + 1
	end

	--give order after acquire scout
	if x.spine == 11 and x.waittime < GetTime() then
		x.audio1 = AudioMessage("tcss1117.wav") --Good start. Now complete the patrol route.
		ClearObjectives()
		AddObjective("tcss1100.txt", "GREEN")
		AddObjective("tcss1107.txt", "ALLYBLUE")
		x.spine = x.spine + 1
	end

	--play audios and start camera 2a
	if x.spine == 12 and IsAudioMessageDone(x.audio1) then
		x.camtime0 = GetTime() + 4.0
		x.camtime2 = GetTime() + 12.0
		x.camplay2 = true
    x.userfov = IFace_GetInteger("options.graphics.defaultfov")
    CameraReady()
    IFace_SetInteger("options.graphics.defaultfov", x.camfov)
		AudioMessage("tcss1118.wav") --1st find Hangar
		AudioMessage("tcss1119.wav") --2nd find Factory
		AudioMessage("tcss1120.wav") --3rd find Silo
		AudioMessage("tcss1121.wav") --Find 2 chkpt towers. ID them, will activate navcams to help
		x.audio1 = AudioMessage("tcss1122.wav") --After patrol route, goto tower. Stay close adn get transmission
		x.spine = x.spine + 1
	end

	--Give primary objective after audios
	if x.spine == 13 and IsAudioMessageDone(x.audio1) then
		ClearObjectives()
		AddObjective("tcss1107.txt", "ALLYBLUE", 2.0)
		AddObjective("tcss1100.txt", "GREEN", 2.0)
		AddObjective("tcss1101.txt", "WHITE", 2.0)
		AddObjective("tcss1102.txt", "WHITE", 2.0)
		AddObjective("tcss1103.txt", "WHITE", 2.0)
		AddObjective("tcss1104.txt", "WHITE", 2.0)
		x.spine = x.spine + 1
	end

	--checks done, so give initial comm tower order 
	if x.spine == 14 and x.checkdone and GetDistance(x.player, x.ebnk) < 100 then
		ClearObjectives()
		AddObjective("tcss1108.txt", "ALLYBLUE")
		x.spine = x.spine + 1
	end

	--Show data done message
	if x.spine == 15 and x.datadone and IsAudioMessageDone(x.audio3) then
		ClearObjectives()
		AddObjective("tcss1108.txt", "GREEN")
		x.waittime = GetTime() + 2.0
		x.spine = x.spine + 1
	end

	--Order back to dropzone and send final attacks
	if x.spine == 16 and x.waittime < GetTime() then
		x.audio1 = AudioMessage("tcss1123.wav") --Excellent work. Get back to nav 1 as fast as you can
		ClearObjectives()
		AddObjective("tcss1105.txt")
		if not IsAlive(x.fnav0) then
			x.fnav0 = BuildObject("apcamra", 1, "fpnav0")
		end
		SetObjectiveName(x.fnav0, "Drop Zone")
		SetObjectiveOn(x.fnav0)
		x.spine = x.spine + 1
	end

	--Send final CCA warning b4 attack
	if x.spine == 17 and IsAudioMessageDone(x.audio1) then
		x.audio1 = AudioMessage("tcss1111.wav") --All units, Omega 1 not respond. Enage and destroy
		TCC.SetTeamNum(x.player, 1)
		x.spine = x.spine + 1
	end

	--Send final attacks
	if x.spine == 18 and IsAudioMessageDone(x.audio1) then
		x.epattime = 99999.9
		x.clobberintime = GetTime()
		x.spine = x.spine + 1
	end
	
	--SUCCEED MISSION
	if x.spine == 19 and GetDistance(x.player, "fpnav0") < 16 then
		Damage(x.easn1, 3000)
		Damage(x.easn2, 3000)
		for index = 1, x.epatlength do
			Damage(x.epat[index], 3000)
		end
		AudioMessage("tcss1116.wav") --SUCCEED - Well done Cmd. Reinforce in motion Cmd.
		ClearObjectives()
		AddObjective("tcss1105.txt", "GREEN")
		TCC.SucceedMission(GetTime() + 6.0, "tcss11w1.des")
		x.spine = x.spine + 1
	end
	----------END MAIN SPINE ----------

	--ENSURE PLAYER CAN'T DO ANYTHING WHILE IN DROPSHIP
	if not x.free_player then
		x.controls = {braccel = 0, strafe = 0, jump = 0, deploy = 0, eject = 0, abandon = 0, fire = 0}
		SetControls(x.player, x.controls)
	end

	--RUN CAMERA ON COMM TOWER ----------------------------------
	if x.camplay0 then
		CameraPath("pcam0", x.camheight, 1600, x.ebnk)
		x.camheight = x.camheight + 50
	end

	--STOP CAMERA 1 by PLAYER or by TIME DONE -----------------------------
	if not x.camstop1 then
		if x.camtime1 < GetTime() or CameraCancelled() then
      CameraFinish()
      IFace_SetInteger("options.graphics.defaultfov", x.userfov)
			x.camplay0 = false
			x.camstop1 = true
		end
	end

	--RUN CAMERA 2A ON CCA OBJECTS ----------------------------------------
	if x.camplay2 then
		CameraPath("pcam1", 2000, 1200, x.ebay)
	end
	if x.camplay3 then
		CameraPath("pcam2", 2000, 1200, x.efac)
	end
	if x.camplay4 then
		CameraPath("pcam3", 2000, 1200, x.esil3)
	end

	--CAMERA 2A TIMINGS ---------------------------------------------------
	if not x.getiton then
		if x.camplay2 and x.camtime0 < GetTime() then
			x.camplay2 = false
			x.camtime0 = GetTime() + 4.0
			x.camplay3 = true
		elseif x.camplay3 and x.camtime0 < GetTime() then
			x.camplay3 = false
			x.camtime0 = GetTime() + 4.0
			x.camplay4 = true
		elseif x.camplay4 and x.camtime0 < GetTime() then
			x.camplay4 = false
			x.camstop2 = true
		end
	end

	--CAMERA 2B TIMINGS ---------------------------------------------------
	if not x.getiton then
		if x.camplay2b and x.camtime0 < GetTime() then
			x.camplay2b = false
			x.camstop2b = true
      CameraFinish()
      IFace_SetInteger("options.graphics.defaultfov", x.userfov)
		elseif x.camplay3b and x.camtime0 < GetTime() then
			x.camplay3b = false
			x.camstop2b = true
      CameraFinish()
      IFace_SetInteger("options.graphics.defaultfov", x.userfov)
		elseif x.camplay4b and x.camtime0 < GetTime() then
			x.camplay4b = false
			x.camstop2b = true
      CameraFinish()
      IFace_SetInteger("options.graphics.defaultfov", x.userfov)
		end

		if x.camplay2b then
			CameraObject(x.player, 1, 10, -30, x.ebay)
		elseif x.camplay3b then
			CameraObject(x.player, 1, 10, -30, x.efac)
		elseif x.camplay4b then
			CameraObject(x.player, 1, 10, -30, x.esil3)
		end
	end

	--STOP CAMERA 2A by PLAYER or by TIME DONE ----------------------------
	if x.camstop1 then
		if x.camstop2 or CameraCancelled() then
      CameraFinish()
      IFace_SetInteger("options.graphics.defaultfov", x.userfov)
			x.camplay2 = false --set these to be safe
			x.camplay3 = false
			x.camstop2 = false
		end
	end

	--STOP CAMERA 2B by PLAYER or by TIME DONE ----------------------------
	if (x.camstop2b and x.camtime0 < GetTime()) or CameraCancelled() then
    CameraFinish()
    IFace_SetInteger("options.graphics.defaultfov", x.userfov)
		x.camplay2b = false --set these to be safe
		x.camplay3b = false
		x.camplay4b = false
		x.camstop2b = false
		x.checklist = true --update the checklist objective window
	end

	--HQ1 CAMERAS ON -----------------------------------------------------
	if not x.navon1 and not x.checkdone and IsInfo("sbhqtrss11") and GetDistance(x.player, x.ehq1) < 200 then
		AudioMessage("tcss1129.wav") --scanning sound (computer then
		x.fnav1 = BuildObject("apcamra", 1, "fpnav1") --x.ehq1 location
		SetObjectiveName(x.fnav1, "HQ Alpha")
		x.fnav6 = BuildObject("apcamra", 1, "fpnav6") --x.ehq2 location
		SetObjectiveName(x.fnav6, "HQ Beta")
		x.navon1 = true
	end

	--HQ2 CAMERAS ON -----------------------------------------------------
	if not x.navon2 and not x.checkdone and IsInfo("sbhqtrss11") and GetDistance(x.player, x.ehq2) < 200 then
		AudioMessage("tcss1129.wav") --scanning sound (computer then
		x.fnav1 = BuildObject("apcamra", 1, "fpnav1") --x.ehq1 location
		SetObjectiveName(x.fnav1, "checkpoint")
		x.fnav2 = BuildObject("apcamra", 1, "fpnav2") --x.ebay location
		SetObjectiveName(x.fnav2, "checkpoint")
		x.fnav3 = BuildObject("apcamra", 1, "fpnav3") --x.efac location
		SetObjectiveName(x.fnav3, "checkpoint")
		x.fnav4 = BuildObject("apcamra", 1, "fpnav4") --x.esil location
		SetObjectiveName(x.fnav4, "checkpoint")
		x.fnav5 = BuildObject("apcamra", 1, "fpnav5") --x.ebnk location
		SetObjectiveName(x.fnav5, "checkpoint")
		x.navon2 = true
	end

	--HQ1 CAMERAS OFF ----------------------------------------------------
	if x.navon1 and not x.checkdone and GetDistance(x.player, x.ehq1) > 300 then
		AudioMessage("tcss1130.wav") --radio on sound (computer then
		RemoveObject(x.fnav1)
		RemoveObject(x.fnav6)
		x.navon1 = false
	end

	--HQ2 CAMERAS OFF ----------------------------------------------------
	if x.navon2 and not x.checkdone and GetDistance(x.player, x.ehq2) > 300 then
		AudioMessage("tcss1130.wav") --radio on sound (computer then
		RemoveObject(x.fnav1)
		RemoveObject(x.fnav2)
		RemoveObject(x.fnav3)
		RemoveObject(x.fnav4)
		RemoveObject(x.fnav5)
		RemoveObject(x.fnav6)
		x.navon2 = false
	end

	--PAUSE OMEGA 1 AT HQ ALPHA ------------------------------------------
	if IsAlive(x.eomega1) and x.pausetime < GetTime() then
		if not x.pauseomega1 and GetDistance(x.eomega1, "fpnav1") < 50 then
			Goto(x.eomega1, "fpnav1") --Put nav point closer to START of route than end.
			x.pausetime = GetTime() + 15.0
			x.pauseomega1 = true
		elseif x.pauseomega1 and IsAlive(x.eomega1) then
			Goto(x.eomega1, "ppatrol0")
			x.pausetime = GetTime() + 15.0
			x.pauseomega1 = false
		end
	end

	--THE CHECKPOINTS ----------------------------------------------------
	if not x.checkdone then
		--check service bay
		if GetDistance(x.player, "fpnav2") < 100 and not x.check2 and not x.check3 and not x.check4 and not x.check5 then
			x.check2 = true
      x.userfov = IFace_GetInteger("options.graphics.defaultfov")
      CameraReady()
      IFace_SetInteger("options.graphics.defaultfov", x.camfov)
			x.camplay2b = true
			x.cam2bstop = true
			x.camtime0 = GetTime() + 4.0
			AudioMessage("tcss1107.wav") --This chk pt 2. All clear Omega 1 (soviet)
			x.warntime = GetTime() + 15.0
			x.warntimereturn = GetTime() + 20.0
		end

		--check factory
		if GetDistance(x.player, "fpnav3") < 100 and x.check2 and not x.check3 and not x.check4 and not x.check5 then
			x.check3 = true
      x.userfov = IFace_GetInteger("options.graphics.defaultfov")
      CameraReady()
      IFace_SetInteger("options.graphics.defaultfov", x.camfov)
			x.camplay3b = true
			x.cam2bstop = true
			x.camtime0 = GetTime() + 4.0
			AudioMessage("tcss1108.wav") --This chk pt 3. All clear Omega 1 (soviet)
			x.warntime = GetTime() + 15.0
			x.warntimereturn = GetTime() + 20.0
		elseif not x.check3 and x.warntime < GetTime() and GetDistance(x.player, "fpnav3") < 100 then
			x.check3warn = true
			x.warnsend = true
		end

		--check silos
		if GetDistance(x.player, "fpnav4") < 100 and x.check2 and x.check3 and not x.check4 and not x.check5 then
			x.check4 = true
      x.userfov = IFace_GetInteger("options.graphics.defaultfov")
      CameraReady()
      IFace_SetInteger("options.graphics.defaultfov", x.camfov)
			x.camplay4b = true
			x.cam2bstop = true
			x.camtime0 = GetTime() + 4.0
			AudioMessage("tcss1109.wav") --This chk pt 4. All clear Omega 1 (soviet)
			x.warntime = GetTime() + 15.0
			x.warntimereturn = GetTime() + 20.0
		elseif not x.check4 and x.warntime < GetTime() and GetDistance(x.player, "fpnav4") < 100 then
			x.check4warn = true
			x.warnsend = true
		end

		--check comm tower
		if GetDistance(x.player, "fpnav5") < 70 and x.check2 and x.check3 and x.check4 and not x.check5 then
			x.check5 = true
			x.checklist = true
			x.audio1 = AudioMessage("tcss1110.wav") --Looks like you found you way Omega 1. Hahaha (soviet)
			x.warntime = GetTime() + 15.0
			x.warntimereturn = GetTime() + 20.0
		elseif not x.check5 and (x.warntime < GetTime()) and (GetDistance(x.player, "fpnav5") < 70) then
			x.check5warn = true
			x.warnsend = true
		end

		--clear other checks to send generic warning
		if x.warnsend then
			x.checklist = true
			x.warnplay = true
			x.warntime = GetTime()
			x.warnsend = false
		end

		--send warnings if out or order, or return to previous cleared checkpoint, increment warncount
		if x.warnplay and x.warntime <= GetTime() then
			if x.warncount < x.warnlimit then
				AudioMessage("tcss1105.wav") --Scout you have chk in out of order (soviet)
			else
				AudioMessage("tcss1114.wav") --Omega 1 chk out of order. Explain yourself. (soviet)
				x.screwedtime = GetTime() + 5.0
				x.checkdone = true
			end

			x.warncount = x.warncount + 1
			x.warntime = GetTime() + 15.0
			x.warntimereturn = GetTime() + 20.0 --don't play second one on return to same location
			x.warnplay = false
		end

		if x.warntimereturn <= GetTime() then
			if (x.check2 and GetDistance(x.player, "fpnav2") < 70) 
			or (x.check3 and GetDistance(x.player, "fpnav3") < 70) 
			or (x.check4 and GetDistance(x.player, "fpnav4") < 70) 
			or (x.check5 and GetDistance(x.player, "fpnav5") < 70) then
			x.warncount = x.warncount + 1
			x.warntime = GetTime() + 15.0
			x.warntimereturn = GetTime() + 20.0 --reset
			AudioMessage("tcss1114.wav") --Omega 1 chk out of order. Explain yourself. (soviet)
			end
		end

		if x.warncount > x.warnlimit then --Third time go to a wrong place with a second return and screwed.
			x.screwedtime = GetTime() + 5.0
			x.checkdone = true
		end

		--update the checklist of objectives - after camera seq if in correct order, or after warn if out of order
		if x.checklist then
			ClearObjectives()
			AddObjective("tcss1107.txt", "ALLYBLUE", 2.0)
			AddObjective("tcss1100.txt", "GREEN", 2.0)
			
			if x.check2 then
				AddObjective("tcss1101.txt", "GREEN", 2.0)
			elseif x.check2warn then
				AddObjective("tcss1101.txt", "YELLOW", 2.0)
			else
				AddObjective("tcss1101.txt", "WHITE", 2.0)
			end
			
			if x.check3 then
				AddObjective("tcss1102.txt", "GREEN", 2.0)
			elseif x.check3warn then
				AddObjective("tcss1102.txt", "YELLOW", 2.0)
			else
				AddObjective("tcss1102.txt", "WHITE", 2.0)
			end
			
			if x.check4 then
				AddObjective("tcss1103.txt", "GREEN", 2.0)
			elseif x.check4warn then
				AddObjective("tcss1103.txt", "YELLOW", 2.0)
			else
				AddObjective("tcss1103.txt", "WHITE", 2.0)
			end
			
			if x.check5 then
				AddObjective("tcss1104.txt", "GREEN", 2.0)
			elseif x.check5warn then
				AddObjective("tcss1104.txt", "YELLOW", 2.0)
			else
				AddObjective("tcss1104.txt", "WHITE", 2.0)
			end

			x.checklist = false
		end

		--all checks cleared cleanly, clearly o'coursely
		if x.check2 and x.check3 and x.check4 and x.check5 then
			x.checkdone = true
		end
	end

	--RETRIEVE THE DATA --------------------------------------------------
	if not x.datadone and x.checkdone and IsAudioMessageDone(x.audio1) then
		--DATA RETRIEVAL START
		if not x.datastart and GetDistance(x.player, x.ebnk) < 40 then
			x.audio2 = AudioMessage("tcss1101.wav") --Init comm uplink. Computer
			ClearObjectives()
			AddObjective("tcss1108.txt", "ALLYBLUE")
			x.datapingtime = GetTime()
			x.datatime = GetTime() + 60.0
			x.dataattacktime = GetTime() + 40.0
			x.datawarn = true
			x.datastart = true
		end

		--DATA RETRIEVAL WARN
		if x.datastart and x.datawarn and GetDistance(x.player, x.ebnk) > 55 then
			x.audio2 = AudioMessage("tcss1102.wav") --Losing comm uplink. Computer
			x.datawarn = false
		end

		--DATA WARN RESET
		if not x.datawarn and GetDistance(x.player, x.ebnk) < 40 then
			x.datawarn = true
		end

		--DATA RETRIEVAL STOP
		if x.datastart and GetDistance(x.player, x.ebnk) > 70 then
			x.audio2 = AudioMessage("tcss1103.wav") --Comm uplink lost Computer
			ClearObjectives()
			AddObjective("tcss1108.txt", "RED")
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
			x.audio3 = AudioMessage("tcss1104.wav") --data intercept complete. Computer
			x.datatime = 99999.9
			x.datapingtime = 99999.9
			StopCockpitTimer()
			HideCockpitTimer()
			x.playerisflanker = false
			x.failtime = 99999.9
			x.screwedtime = 99999.9
			x.datadone = true
		end
	end

	--DATA CCA WARNING --------------------------------------------------
	if x.dataattacktime < GetTime() then
		AudioMessage("tcss1114.wav") --Omega 1 chk out of order. Explain yourself. Soviet
		x.dataattacktime = 99999.9
	end

	--STAY IN TANK and DON'T SCREW UP, OR WILL BE FOUND OUT ------------------------
	if not x.screwed then
		if (x.playerisflanker and IsOdf(x.player, "aspilo")) or x.screwedtime < GetTime() then
			if x.screwedtime < GetTime() then
				AudioMessage("tcss1111.wav") --All units, Omega 1 not respond. Enage and destroy (soviet)
			end
			x.screwedtime = 99999.9 --keep here
			x.clobberintime = GetTime() + 3.0
			x.epattime = GetTime()
			x.screwed = true
		end
	end

	--REDLINE DON'T CROSS --------------------------------------------
	if not x.redlinebool and not x.redlinecross then
		for index = 1, x.redlinelength do
			if GetDistance(x.player, "predline", index) < 200 then
				x.redlinecross = true
			end
		end

		if x.redlinecross then
			x.clobberintime = GetTime() + 3.0
			x.epattime = GetTime()
			x.screwed = true
			x.redlinebool = true
		end
	end

	--CLOBBERIN TIME - SEND PATROLS TO KILL PLAYER ------------------------------
	if x.clobberintime < GetTime() then
		if not x.clobberbool then
			if x.screwed then
				AudioMessage("tcss1128.wav") --FAIL pilot - Your cover is blown cmdr
				ClearObjectives()
				AddObjective("tcss1106.txt", "RED")
			end
			x.playerisflanker = false
			x.redlinebool = true
			x.checkdone = true
			x.clobberbool = true
      CameraFinish()
      IFace_SetInteger("options.graphics.defaultfov", x.userfov)
			x.player = GetPlayerHandle() --re-get x.player so...
			TCC.SetTeamNum(x.player, 1) --...turrets and gtow...
			SetPerceivedTeam(x.player, 1) --... will attack too
			x.easnsend = true
		end

		for index = 1, x.epatlength do --da all gonna kill u
			Attack(x.epat[index], x.player)
		end
		x.clobberintime = GetTime() + 10.0
	end

	--CCA GROUP SCOUT PATROLS ----------------------------------
	if x.epattime < GetTime() then
		for index = 1, x.epatlength do
			if not IsAlive(x.epat[index]) then
				--patrol generic area
				if index == 0 then
					x.epat[index] = BuildObject("svscout", 5, "ppatrol1")
					Patrol(x.epat[index], "ppatrol1")
				elseif index == 1 then
					x.epat[index] = BuildObject("svmbike", 5, "ppatrol2")
					Patrol(x.epat[index], "ppatrol2")
				elseif index == 2 then
					x.epat[index] = BuildObject("svmisl", 5, "ppatrol3")
					Patrol(x.epat[index], "ppatrol3")
				elseif index == 3 then
					x.epat[index] = BuildObject("svtank", 5, "ppatrol4")
					Patrol(x.epat[index], "ppatrol4")
				elseif index == 4 then
					x.epat[index] = BuildObject("svtank", 5, "ppatrol5")
					Patrol(x.epat[index], "ppatrol5")
				elseif index == 5 then
					x.epat[index] = BuildObject("svmisl", 5, "ppatrol6")
					Patrol(x.epat[index], "ppatrol6")
				elseif index == 6 then
					x.epat[index] = BuildObject("svmbike", 5, "ppatrol1")
					Patrol(x.epat[index], "ppatrol1")
				elseif index == 7 then
					x.epat[index] = BuildObject("svscout", 5, "ppatrol2")
					Patrol(x.epat[index], "ppatrol2")
				elseif index == 8 then
					x.epat[index] = BuildObject("svscout", 5, "ppatrol3")
					Patrol(x.epat[index], "ppatrol3")
				elseif index == 9 then
					x.epat[index] = BuildObject("svmbike", 5, "ppatrol4")
					Patrol(x.epat[index], "ppatrol4")
				elseif index == 10 then
					x.epat[index] = BuildObject("svmisl", 5, "ppatrol5")
					Patrol(x.epat[index], "ppatrol5")
				elseif index == 11 then
					x.epat[index] = BuildObject("svtank", 5, "ppatrol6")
					Patrol(x.epat[index], "ppatrol6")
				--patrol Comm Tower
				elseif index == 12 then
					x.epat[index] = BuildObject("svtank", 5, "ppatrol7")
					Patrol(x.epat[index], "ppatrol7")
				elseif index == 13 then
					x.epat[index] = BuildObject("svtank", 5, "ppatrol8")
					Patrol(x.epat[index], "ppatrol8")
				--patrol Artillery
				elseif index == 14 then
					x.epat[index] = BuildObject("svartl", 5, "epart1")
				elseif index == 15 then
					x.epat[index] = BuildObject("svartl", 5, "epart2")
				elseif index == 16 then
					x.epat[index] = BuildObject("svartl", 5, "epart3")
				elseif index == 17 then
					x.epat[index] = BuildObject("svartl", 5, "epart4")
				end
				SetSkill(x.epat[index], x.skillsetting)
			end
		end
		x.epattime = GetTime() + 120.0
	end

	--CCA GROUP SCAVS FOR LOOKS ----------------------------------
	if x.escvbuildtime < GetTime() then
		if GetMaxScrap(5) > 35 then
			SetScrap(5, 0) --so they'll keep collecting scrap
		end

		for index = 1, 2 do
			if not IsAlive(x.escv[index]) then
				x.escv[index] = BuildObject("svscav", 5, x.ercy)
			end
		end
		x.escvbuildtime = GetTime() + 30.0
	end

	--CCA ASSASSIN SQUAD ----------------------------------
	if x.easnsend then
		x.easn1 = BuildObject("svscout", 6, "eptur14") --in case x.player tries to run up SW hill
		SetSkill(x.easn1, x.skillsetting)
		SetObjectiveName(x.easn1, "Assassin 1")
		Attack(x.easn1, x.player)
		x.easn2 = BuildObject("svtank", 6, "fpnav1")
		SetSkill(x.easn1, x.skillsetting)
		SetObjectiveName(x.easn2, "Assassin 2")
		Attack(x.easn2, x.player)
		x.easnsend = false
	end

	--CCA MINELAYER SQUAD ----------------------------------
	if not x.emindone and x.checkdone then
		x.emin1 = BuildObject("svmine", 5, "epmin1")
		Mine(x.emin1, "epmin1", 1)
		x.emin2 = BuildObject("svmine", 5, "epmin2")
		Mine(x.emin2, "epmin2", 1)
		x.emindone = true
	end

	--CHECK STATUS OF MCA ----------------------------------
	if not x.MCAcheck then
		--Fail by tank spotted
		if not IsOdf(x.player, "svscout") and not x.datadone and not x.screwed and not x.clobberbool and GetDistance(x.mytank, GetNearestEnemy(x.mytank, 1, 1, 150)) < 100 then
			ClearObjectives()
			AddObjective("tcss1109.txt", "RED")
			AudioMessage("tcss1113.wav") --FAIL - tank - Your cover is blown. Your tank is out in open.
			TCC.FailMission(GetTime() + 4.0, "tcss11f2.des")
			x.MCAcheck = true
		end

		--Fail by MCA destruction
		if not IsAlive(x.efac) or not IsAlive(x.etrn) or not IsAlive(x.ebay) 
		or not IsAlive(x.ebnk) or not IsAlive(x.ehq1) or not IsAlive(x.ehq2) 
		or not IsAlive(x.esil1) or not IsAlive(x.esil2) or not IsAlive(x.esil3) 
		or not IsAlive(x.esil4) or not IsAlive(x.esil5) or not IsAlive(x.esil6) then
			ClearObjectives()
			AddObjective("tcss1110.txt", "RED")
			TCC.FailMission(GetTime() + 3.0, "tcss11f3.des")
			x.MCAcheck = true
		end

		--Fail by time is up
		if x.failtime < GetTime() then
			ClearObjectives()
			AddObjective("tcss1111.txt", "RED")
			AudioMessage("tcss1115.wav") --FAIL - Time up message lost
			TCC.FailMission(GetTime() + 6.0, "tcss11f1.des")
			x.MCAcheck = true
		end
	end
end
--[[END OF SCRIPT]]