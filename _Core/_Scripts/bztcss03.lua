--bztcss03 - Battlezone Total Command - Stars and Stripes - 3/17 - THE RELIC DISCOVERED
assert(load(assert(LoadFile("_requirefix.lua")),"_requirefix.lua"))();
TCC = require("TC_Core")
MisnNum = 5;
--INITIALIZE VARIABLES --f-friend e-enemy p-path atk-attack scv-scavenger rcy-recycler tnk-tank cam-camera
local index = 0
local index2 = 0
local indexadd = 0
local x = {
	FIRST = true,	
	spine = 0,	
	MCAcheck = false, 
	randompick = 0, 
	randomlast = 0, 
	waittime = 99999.9, 
	player = nil, 
	mytank = nil, 
	skillsetting = 0,
	easy = 0, 
	medium = 1, 
	hard = 2, --tried 1-3, in 185, 3 didn't seem to make any difference, 
	audio1 = nil, 
  camfov = 60,  --185 default
	userfov = 90,  --seed
	pos = {}, 
	relicexists = false, 
	eatkbuilt = false, 
	eatkallow = false, 
	free_player = false, 
	controls = {braccel = 0, strafe = 0, jump = 0, deploy = 0, eject = 0, abandon = 0, fire = 0}, 
	msgincoming = false, 
	msgdead = false, 
	relicbegin = false, 
	camrelicrun = false, 
	etugloop = false, 
	etugbuilt = false, 
	etughasrelic = false, 
	ftugmsgpickup = false, 
	warning1 = false, 
	warning2 = false, 
	relicmeetup = false, 
	waitondeadmsg = false, 
	ercydead = false, 
	edrpsent = false, 
	erelgotsize = false, 
	erelreset = false, 
	erelbuild = false, 
	erelbool = false, 
	eatktime = 120.0, 
	eatkresendtime = 180.0, 
	cine1length = 28.0, 
	etugwait = 20.0, 
	warnccatime = 10.0, 
	erelbuildtime = 10.0, 
	ftugmsgexpire = 10.0, 
	msgincoming_time = 99999.9, 
	msgdead_time = 99999.9, 
	escvbuildtime = 99999.9, 
	relrcytime = 99999.9, 
	etugrebuilttime = 99999.9, 
	etugwaitftug = 99999.9, 
	etugcargotime = 99999.9, 
	erelresendtime = 99999.9, 
	ercypos = nil, 
	frcy = nil, 
	ffac = nil, 
	fscv1 = nil,
	fscv2 = nil, 
	fnav1 = nil, 
	fdrp = {}, 
	ftug = {}, 
	ftugtarget = nil, 
	ercy = nil, 
	efac = nil, 
	eatk = {}, 
	escv = {}, 
	etug = nil, 
	etur = {}, 
	erel = {}, 
	edrp = nil, 
	holder = {}, 
	relic = nil, 
	relcam = nil, 
	repel = {},	
	eatklength = 0, 
	eatkwavecount = 0, 
	relicplace = 0, 
	casualty = 0, 
	ftuglength = 20, 
	erellength = 4, 
	easn = {}, --assassin stuff
	easnlength = 1, --more than one, too much
	easnreset = false, 
	easnbuild = false, 
	easngottarget = false, 
	easnbuildtime = 10.0, 
	easnresendtime = 99999.9, 
  playerhealth = 0, 
	LAST = true
}
--PATHS: pmytank, fprcy, fpfac, fprcymeet, fpfacmeet, eprcy, epgrcy, eprear, fpnav1-4, eptur1-20, prelic1-3, pcam1-3

function InitialSetup()
	SetAutoGroupUnits(true)
	
	local odfpreload = {
		"avrecyss03", "avfactss03", "avtankss03", "avscav", "olyrelic01", "repelenemy100", "repelenemy400", 
		"svdrop", "svturr", "svscav", "svscout", "svmbike", "svtank", "stayput", "radjam", "apcamra"
	}
	for k,v in pairs(odfpreload) do
		PreloadODF(v)
	end
	
	x.mytank = GetHandle("mytank")
	x.fdrp[1] = GetHandle("fdrp1")
	x.fdrp[2] = GetHandle("fdrp2")
	x.frcy = GetHandle("frcy")
	x.fscv1 = GetHandle("fscv1")
	x.fscv2 = GetHandle("fscv2")
	x.ercy = GetHandle("ercy")
	x.efac = GetHandle("efac")
	Ally(1, 4)
	Ally(4, 1) --4 Relic
	for index = 4, 7 do
		for index2 = 4, 7 do
			Ally(index, index2)
		end
	end
	SetTeamColor(6, 135, 150, 30) --assassin
	SetTeamColor(7, 180, 130, 30) --relic guards	
	SetColorFade(6.0, 0.5, "BLACK")
	TCC.Init()
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

function Start()
	TCC.Start();
end

function AddObject(h)
	for indexadd = 1, x.ftuglength do
		if IsOdf(h, "avtug:1") and (not IsAlive(x.ftug[indexadd]) or x.ftug[indexadd] == nil) then
			x.ftug[indexadd] = h
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

function Update()
	x.player = GetPlayerHandle() --EVERY PASS SO IF PLAYER CHANGES VEHICLES
	x.skillsetting = IFace_GetInteger("options.play.difficulty")
	TCC.Update()

	--START THE MISSION BASICS --------------------------------------
	if x.spine == 0 then
		x.pos = GetTransform(x.mytank)
		RemoveObject(x.mytank)
		x.mytank = BuildObject("avtankss03", 1, x.pos)
		x.pos = GetTransform(x.fscv1)
		RemoveObject(x.fscv1)
		x.fscv1 = BuildObject("avscav", 1, x.pos)
		x.pos = GetTransform(x.fscv2)
		RemoveObject(x.fscv2)
		x.fscv2 = BuildObject("avscav", 1, x.pos)
		x.pos = GetTransform(x.frcy)
		RemoveObject(x.frcy)
		x.frcy = BuildObject("avrecyss03", 1, x.pos)
		SetAsUser(x.mytank, 1)
		RemoveObject(x.player)
		x.player = GetPlayerHandle()  
		x.fnav1 = BuildObject("apcamra", 1, "fpnav1")
		SetObjectiveName(x.fnav1, "NE deploy")
		x.fnav1 = BuildObject("apcamra", 1, "fpnav2")
		SetObjectiveName(x.fnav1, "NW deploy")
		x.fnav1 = BuildObject("apcamra", 1, "fpnav3")
		SetObjectiveName(x.fnav1, "SW deploy")
		x.fnav1 = BuildObject("apcamra", 1, "fpnav4")
		SetObjectiveName(x.fnav1, "CCA Base")
		for index = 1, 20 do
			x.etur[index] = BuildObject("svturr", 5, ("eptur%d"):format(index))
			SetSkill(x.etur[index], x.skillsetting)
		end
		for index = 1, 3 do
			x.repel[index] = BuildObject("repelenemy400", 5, ("prelic%d"):format(index))
		end
		x.audio1 = AudioMessage("tcss0301.wav") --56s INTRO Gen Col. Mst import mission you face.
		x.ercypos = GetTransform(x.ercy)
		SetScrap(1, 40)
		x.spine = x.spine + 1
	end

	--DROPSHIP LANDING SEQUENCE - START QUAKE FOR FLYING EFFECT
	if x.spine == 1 then
		for index = 1, 2 do
			for index2 = 1, 10 do
				StopEmitter(x.fdrp[index], index2)
			end
		end
		x.holder[1] = BuildObject("stayput", 0, x.frcy)
		x.holder[2] = BuildObject("stayput", 0, x.fscv1)
		x.holder[3] = BuildObject("stayput", 0, x.fscv2)
    x.holder[4] = BuildObject("radjam", 5, x.player)
		x.holder[5] = BuildObject("stayput", 0, x.player) --so doesn't slide b/c quake?
		Stop(x.frcy) --Prevent player giving orders in dropship
		Stop(x.fscv1)
		Stop(x.fscv2)
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
		for index = 1, 4 do --not player yet
			RemoveObject(x.holder[index])
		end
		x.waittime = GetTime() + 5.0
		x.spine = x.spine + 1
	end

	--HOLD INPUTS UNTIL DOORS ARE FULLY OPEN
	if x.spine == 5 and x.waittime < GetTime() then
		Goto(x.frcy, "fprcymeet", 0)
		Goto(x.fscv1, "fpfacmeet", 0)
		Goto(x.fscv2, "fpfacmeet", 0)
		SetGroup(x.frcy, 0)
		SetGroup(x.fscv1,1)
		SetGroup(x.fscv2,1)
		x.waittime = GetTime() + 1.0
		x.spine = x.spine + 1
	end

	--GIVE PLAYER CONTROL OF THEIR AVATAR
	if x.spine == 6 and x.waittime < GetTime() then
		RemoveObject(x.holder[5])
		x.free_player = true
		x.spine = x.spine + 1
	end

	--DROPSHIP 1 TAKEOFF
	if x.spine == 7 and IsCraftButNotPerson(x.player) and GetDistance(x.player, x.fdrp[2]) > 60 then
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
	if x.spine == 8 and x.waittime < GetTime() then
		for index = 1, 10 do
			StartEmitter(x.fdrp[2], index)
		end
		SetAnimation(x.fdrp[2], "takeoff", 1)
		StartSoundEffect("dropleav.wav", x.fdrp[2])
		x.waittime = GetTime() + 24.0
		x.spine = x.spine + 1
	end

	--REMOVE DROPSHIPS
	if x.spine == 9 and x.waittime < GetTime() then
		RemoveObject(x.fdrp[1])
		RemoveObject(x.fdrp[2])
		x.spine = x.spine + 1
	end

	--WAIT FOR GEN COLLINS TO SHUTUP BEFORE DOING ANYTHING ELSE
	if x.spine == 10 and IsAudioMessageDone(x.audio1) then
		ClearObjectives()
		AddObjective("tcss0301.txt")
		x.spine = x.spine + 1
	end

	--ALLOW player TO DEPLOY RECY
	if x.spine == 11 and IsOdf(x.frcy, "abrecyss03") then
		x.eatkallow = true --x.eatk turn on
		x.eatkwavecount = 1 --x.eatk seed case
		x.eatktime = GetTime() + 30.0
		x.escvbuildtime = GetTime()
		x.spine = x.spine + 1
	end

	--START THE RELIC PHASE and ANNOUNCE INVESTIGATE CCA FOR RELIC
	if x.spine == 12 and x.waittime < GetTime() and x.relicbegin then --DETERMINE WHERE TO PLACE THE x.relic BASED ON x.frcy LOCATION
		if GetDistance(x.frcy, "fpnav1") < GetDistance(x.frcy, "fpnav2") and GetDistance(x.frcy, "fpnav1") < GetDistance(x.frcy, "fpnav3") then
			x.relicplace = 1 --frcy at NE - relic straight south
		elseif GetDistance(x.frcy, "fpnav2") < GetDistance(x.frcy, "fpnav1") and GetDistance(x.frcy, "fpnav2") < GetDistance(x.frcy, "fpnav3") then
			x.relicplace = 2 --frcy at NW - relic SSW edge below mountains
		else
			x.relicplace = 3 --frcy at SW - relic straight south
		end
		x.relic = BuildObject("olyrelic01", 4, ("prelic%d"):format(x.relicplace))
		SetObjectiveName(x.relic, "Investigate CCA")
		SetObjectiveOn(x.relic)
		x.relicexists = true --allow MCAcheck for relic
		AudioMessage("tcss0306.wav") --13 Cmd, radar picked up CCA to SW. Nav dropped. Go there.
		AddObjective("	")
		AddObjective("tcss0302.txt", "ALLYBLUE")
		x.mytank = BuildObject("apcamrs", 5, x.relic) --needed for distance check
		x.waittime = GetTime() + 90.0
		for index = 1, 3 do
			RemoveObject(x.repel[index])
			x.repel[index] = BuildObject("repelenemy100", 5, ("prelic%d"):format(index))
		end
		x.warning1 = true --for player to go to relic
		x.spine = x.spine + 1
	end
	
	--SEE IF player HAS GONE TO relic AND PLAY CINERACTIVE
	if x.spine == 13 and (GetDistance(x.player, x.relic) < 300 or (GetDistance(x.relic, GetNearestEnemy(x.mytank, 1, 1, 450)) < 280)) then --setting GNE <450 no longer works
		for index = 1, 3 do
			RemoveObject(x.repel[index])
		end
		RemoveObject(x.mytank)
		SetObjectiveOff(x.relic)
		x.relicmeetup = true --turn off x.warning to go to relic
    x.userfov = IFace_GetInteger("options.graphics.defaultfov")
    CameraReady()
    IFace_SetInteger("options.graphics.defaultfov", x.camfov)
		AudioMessage("tcss0395.wav") --26 0308+0309 relic cineractive Corbin and Collins COXXON
		x.cine1length = x.cine1length + GetTime()
		x.camrelicrun = true
    x.playerhealth = GetMaxHealth(x.player)
		x.spine = x.spine + 1
	end

	--STOP CINERACTIVE BY TIME DONE --------------
	if x.spine == 14 and x.cine1length < GetTime() then --give time for guard to arrive (CameraCancelled() or x.cine1length < GetTime()) then
    CameraFinish()
    IFace_SetInteger("options.graphics.defaultfov", x.userfov)
		x.camrelicrun = false
		ClearObjectives()
		AddObjective("tcss0302.txt", "GREEN")
		AddObjective("	")
		AddObjective("tcss0303.txt")
		x.etugloop = true
		x.etugrebuildtime = GetTime() + 30.0
		x.etugwait = x.etugwait + GetTime()
		x.etugwaitftug = 10.0
		x.etugcargotime = 10.0
		SetObjectiveName(x.relic, "Relic")
		SetObjectiveOn(x.relic)
		x.spine = x.spine + 1
	end

	--SEE IF RELIC HAS MADE IT TO FRIENDLY RECYCLER
	if x.spine == 15 and GetDistance(x.relic, x.frcy) < 64 then
		ClearObjectives()
		AddObjective("tcss0303.txt", "GREEN")
		AddObjective("	")
		AddObjective("tcss0304.txt")
		x.waitondeadmsg = GetTime() + 5.0 --for eatkwavecount 4 or 5
		x.relrcytime = GetTime() + 5.0
		x.spine = x.spine + 1
	end

	--CHECK ENEMY STATUS IN RELATION TO RELIC POSITION AND REDO IF NECESSARY
	if x.spine == 16 and x.relicexists then
		if ((IsAlive(x.ercy) and x.eatkwavecount > 5) or (not IsAlive(x.ercy) and x.eatkwavecount > 4)) and x.waitondeadmsg and GetDistance(x.relic, x.frcy) <= 64 then
			x.waittime = GetTime() + 7.0 --wait for last dead message to run
			x.spine = x.spine + 1
		elseif GetDistance(x.relic, x.frcy) > 64 and x.relrcytime < GetTime() then
			ClearObjectives()
			AddObjective("tcss0311.txt", "YELLOW")
			x.spine = x.spine - 1 --GO BACK TO PREVIOUS spine
		end
	end

	--SET THE MISSION TO SUCCESS AND END
	if x.spine == 17 and x.waittime < GetTime() then
		AudioMessage("tcss0316.wav") --12 SUCCEED Intercept CCA trans to retreat. Prep full landing.
		ClearObjectives()
		AddObjective("tcss0305.txt", "GREEN")
		TCC.SucceedMission(GetTime() + 16.0, "tcss03w1.des") --WINNER WINNER WINNER
		x.spine = x.spine + 1
	end
	----------END MAIN SPINE ----------

	--ENSURE PLAYER CAN'T DO ANYTHING WHILE IN DROPSHIP
	if not x.free_player then
		x.controls = {braccel = 0, strafe = 0, jump = 0, deploy = 0, eject = 0, abandon = 0, fire = 0}
		SetControls(x.player, x.controls)
	end

	--WARN IF TOO CLOSE TO CCA RECYCLER
	if IsAlive(x.ercy) and GetDistance(x.player, x.ercy) < 300 and x.warnccatime < GetTime() then
		AudioMessage("tcss0323.wav") --5 REMIND - don't attack cca base
		x.warnccatime = GetTime() + 180.0
	end

	--LAUNCH INCREASING ATTACK WAVES
	if x.eatkallow then --TURN IT ALL ON OR OFF
		if x.eatktime < GetTime() and not x.eatkbuilt then
			if x.eatkwavecount == 1 then
				x.eatklength = 2
			elseif x.eatkwavecount == 2 then
				x.eatklength = 4
			elseif x.eatkwavecount == 3 then
				x.eatklength = 8
			elseif x.eatkwavecount == 4 then
				x.eatklength = 12
			elseif x.eatkwavecount == 5 then
				x.eatklength = 16
			else
				x.eatklength = 20 --get the relic to your recycler ya lazy bum
			end
			
			for index = 1, x.eatklength do
				while x.randompick == x.randomlast do --random the random
					x.randompick = math.floor(GetRandomFloat(1.0,9.0))
				end
				x.randomlast = x.randompick
				if x.randompick == 1 or x.randompick == 4 or x.randompick == 7 then --or x.randompick == 10 or x.randompick == 13 then
					if x.eatkwavecount == 4 or x.eatkwavecount >= 6 then
						x.eatk[index] = BuildObject("svscout", 5, GetPositionNear("eprear", 0, 16, 32)) --grpspwn
						Goto(x.eatk[index], "stage4", 0)
					elseif IsAlive(x.ercy) then
						x.eatk[index] = BuildObject("svscout", 5, GetPositionNear("epgrcy", 0, 16, 32)) --grpspwn
						Goto(x.eatk[index], "stage1", 0)
					end
				elseif x.randompick == 2 or x.randompick == 5 or x.randompick == 8 then --or x.randompick == 11 or x.randompick == 14 then
					if x.eatkwavecount == 4 or x.eatkwavecount >= 6 then
						x.eatk[index] = BuildObject("svmbike", 5, GetPositionNear("eprear2", 0, 16, 32)) --grpspwn
						Goto(x.eatk[index], "stage5", 0)
					elseif IsAlive(x.ercy) then
						x.eatk[index] = BuildObject("svmbike", 5, GetPositionNear("epgfac1", 0, 16, 32)) --grpspwn
						Goto(x.eatk[index], "stage2", 0)
					end
				else
					if x.eatkwavecount == 4 or x.eatkwavecount >= 6 then
						x.eatk[index] = BuildObject("svtank", 5, GetPositionNear("eprear3", 0, 16, 32)) --grpspwn
						Goto(x.eatk[index], "stage6", 0)
					elseif IsAlive(x.ercy) then
						x.eatk[index] = BuildObject("svtank", 5, GetPositionNear("epgfac2", 0, 16, 32)) --grpspwn
						Goto(x.eatk[index], "stage3", 0)
					end
				end
				SetSkill(x.eatk[index], x.skillsetting)
				if index % 3 == 0 then
					SetSkill(x.eatk[index], x.skillsetting+1)
				end
			end
			x.eatkbuilt = true --ensure it doesn't run again until all dead
			x.eatkresendtime = GetTime()
			x.msgincoming = true
			x.msgincoming_time = GetTime() + 40.0
		end
		
		if x.eatkbuilt and x.eatkresendtime < GetTime() then
			for index = 1, x.eatklength do --go through squad
				if IsAlive(x.eatk[index]) and GetTeamNum(x.eatk[index]) ~= 1 then
          Attack(x.eatk[index], x.frcy)
				end
			end
			x.eatkresendtime = GetTime() + 60.0 --reseed
		end
		
		if x.eatkbuilt then
			for index = 1, x.eatklength do --go through squad
				if not IsAlive(x.eatk[index]) or (IsAlive(x.eatk[index]) and GetTeamNum(x.eatk[index]) == 1) then
					x.casualty = x.casualty + 1
				end
			end
		end
		
		if x.casualty ~= x.eatklength then
			x.casualty = 0 --RESET THIS
		elseif x.casualty >= x.eatklength and x.eatkbuilt then
			if x.eatkwavecount >= 1 then
				x.eatktime = GetTime() + 120.0 --Time between attacks
			end
			if x.eatkwavecount == 3 then
				x.eatktime = GetTime() + 240.0 --FOR WAVE 4
				if x.relicplace == 2 or x.relicplace == 3 then
					x.eatktime = GetTime() + 180.0 --FOR WAVE 4
				end
			end
			x.msgdead = true
			x.msgdead_time = GetTime() + 2.0
			x.casualty = 0 --RESET THIS
			x.eatkbuilt = false
			if x.eatkwavecount < 6 then
				x.eatkwavecount = x.eatkwavecount + 1
			end
		end
	end

	--PLAY MESSAGES FOR INCOMING ATTACK WAVES --------------------------------------
	if x.msgincoming and x.msgincoming_time < GetTime() then
		if x.eatkwavecount == 1 then
			AudioMessage("tcss0302.wav") --2 Income CCA units
		elseif x.eatkwavecount == 2 then
			AudioMessage("tcss0304.wav") --2 CCA approach on attack run.
		elseif x.eatkwavecount == 3 then
			AudioMessage("tcss0310.wav") --2 comes another attack wave.
		elseif x.eatkwavecount == 4 then
			AudioMessage("tcss0312.wav") --4 Watch out. CCA attack approach from REAR.
		elseif (x.eatkwavecount == 5) and IsAlive(x.ercy) then
			AudioMessage("tcss0314.wav") --3 Multiple CCA on attack run
		else
			AudioMessage("tcss0310.wav") --2 comes another attack wave.
		end
		x.msgincoming = false
	end

	--PLAY WAVE DEAD MESSAGE, SETUP TIME FOR NEXT WAVE, INCREMENT NEXT WAVE --------
	if x.msgdead and x.msgdead_time < GetTime() then
		if x.eatkwavecount == 1 then
			AudioMessage("tcss0303.wav") --5 Found us sooner than hoped. Prep for more attack
		elseif x.eatkwavecount == 2 then
			AudioMessage("tcss0305.wav") --3 Whoohoo Attack wave destroyed
		elseif x.eatkwavecount == 3 then
			AudioMessage("tcss0311.wav") --7 Got them Cmd. All attacking units destroyed.
			x.relicbegin = true --turn back on main switch to next case
			if x.skillsetting == x.easy then
				x.waittime = GetTime() + 90.0
			elseif x.skillsetting == x.medium then
				x.waittime = GetTime() + 75.0
			else
				x.waittime = GetTime() + 60.0
			end
		elseif x.eatkwavecount == 4 then
			AudioMessage("tcss0313.wav") --4 Yeah, all enemy units destroyed.
		elseif x.eatkwavecount == 5 then
			AudioMessage("tcss0315.wav") --3 All enemy units destroyed Griz 1.
			x.waitondeadmsg = true
		else
			AudioMessage("tcss0305.wav") --3 Whoohoo Attack wave destroyed
		end
		x.msgdead = false
	end

	--LET PLAYER KNOW A FRIENDLY TUG HAS PICKED UP THE RELIC ----------------------
	for index = 1, x.ftuglength do
		if not x.ftugmsgpickup and x.relicexists and IsAlive(x.relic) and IsAlive(x.frcy) and GetDistance(x.relic, x.frcy) > 150 and
			IsAlive(x.ftug[index]) and HasCargo(x.ftug[index]) and GetNearestObject(x.ftug[index]) == x.relic then
			x.ftugtarget = x.ftug[index]
			AudioMessage("tcss0319.wav") --4 W/20 Hover tug 1 has cargo
			AudioMessage("tcss0320.wav") --3 W/19 voice says Hover tug reports obj secu"RED".
			x.ftugmsgpickup = true
		end
	end

	--IF TUG WITH RELIC DIES OR DROPS CARGO, RESET FTUGTARGET AND PICKUP MESSAGE
	if not IsAlive(x.ftugtarget) or not HasCargo(x.ftugtarget) then
		x.ftugtarget = nil
		x.ftugmsgpickup = false
	end

	--RUN RELIC CCA GUARDS/FTUGTARGET KILL GROUP ----------------------------------
	if x.relicexists then
		if not x.erelgotsize then
			x.erellength = 2
			if x.relicplace >= 2 then
				x.erellength = 3
			end
			x.erelgotsize = true
		end
		if not x.erelbuild then
			for index = 1, x.erellength do
				if (not IsAlive(x.erel[index]) or (IsAlive(x.erel[index]) and GetTeamNum(x.erel[index]) == 1)) and x.casualty < x.erellength then
					x.casualty = x.casualty + 1
				end
			end
			if x.casualty ~= x.erellength then
				x.casualty = 0
			elseif not x.erelreset then
				x.casualty = 0 
				x.erelbuild = true
				x.erelbuildtime = GetTime() + 20.0
				if GetDistance(x.relic, x.ercy) < 500 then
					x.erelbuildtime = GetTime() + 40.0
				end
				x.erelreset = true
			end
		end
		if not x.erelbool then
			x.erelbuildtime = GetTime() --SEED first
			x.erelbool =true
		end
		if x.erelbuild and x.erelbuildtime < GetTime() then
			for index = 1, x.erellength do --build force
				x.erel[index] = BuildObject("svscout", 7, GetPositionNear("epgrcy", 0, 16, 32)) --grpspwn
				SetSkill(x.erel[index], x.skillsetting)
				SetObjectiveName(x.erel[index], "Guard")
			end
			x.erelresendtime = GetTime()
			x.casualty = 0
			x.erelreset = false
			x.erelbuild = false
		end
		if x.erelresendtime < GetTime() then
			for index = 1, x.erellength do
				if IsAlive(x.ftugtarget) and IsAlive(x.erel[index]) and not IsPlayer(x.erel[index]) then
          Attack(x.erel[index], x.ftugtarget)
        elseif IsAlive(x.erel[index]) and not IsPlayer(x.erel[index]) then
          Defend2(x.erel[index], x.relic)
				end
			end
			x.erelresendtime = GetTime() + 10.0
		end
	end

	--RUN THE CCA TRACTOR TUG ----------------------------------------------------
	--BETTER REFINED TUG SCRIPT IN LATER SCRIPTS
	if x.etugloop then
		--BUILD THE CCA etug
		if not IsAlive(x.etug) and x.etugrebuildtime < GetTime() then
			x.etug = BuildObject("svtug", 5, GetPositionNear("epgrcy", 0, 16, 32)) --grpspwn
			SetCanSnipe(x.etug, 0)
			x.etughasrelic = false
			x.etugbuilt = true
		end
		
		if x.etugbuilt and not IsAlive(x.etug) and x.etugrebuildtime < GetTime() then
			x.etugrebuildtime = GetTime() + 10.0
			if x.relicplace == 1 then --not quite so x.hard on player
				x.etugrebuildtime = GetTime() + 30.0
			end
			x.etugbuilt = false
		end

		--IF ftug HAS THE relic, HAVE etug FOLLOW TO GET relic IF ftug DIES
		if IsAlive(x.ftugtarget) and HasCargo(x.ftugtarget) and GetNearestObject(x.ftugtarget) == x.relic and IsAlive(x.etug) and not HasCargo(x.etug) and x.etugwaitftug < GetTime() then
			Goto(x.etug, x.ftugtarget)
			x.etugwaitftug = GetTime() + 5.0
		end

		--OTHERWISE, ASSUME etug CAN PICKUP relic AND TELL IT TO
		if IsAlive(x.etug) and not HasCargo(x.etug) and x.etugcargotime < GetTime() then
			Pickup(x.etug, x.relic)
			x.etugcargotime = GetTime() + 10.0
		end

		--LET player KNOW CCA TUG HAS THE relic
		if not x.etughasrelic and IsAlive(x.etug) and HasCargo(x.etug) then
			Goto(x.etug, "epgrcy")
			AudioMessage("tcss0327.wav") --6 CCA tug has x.relic stop it
			SetObjectiveOn(x.etug)
			SetObjectiveName(x.etug, "CCA TRACTOR")
			x.etughasrelic = true
		end
	end
	
	--RUN THE PLAYER/FTUGTARGET ASSASSIN SQUAD ------------------------------
	if x.etugloop then
		if not x.easnbuild then
			for index = 1, x.easnlength do
				if not IsAlive(x.easn[index]) then
					x.casualty = x.casualty + 1
				end
			end
			if x.casualty ~= x.easnlength then
				x.casualty = 0
			elseif not x.easnreset then
				x.casualty = 0
				x.easnbuildtime = GetTime() + 45.0
				if x.relicplace >= 2 then
					x.easnbuildtime = GetTime() + 30.0
				end
				x.easnbuild = true
				x.easnreset = true
			end
		end
		
		if x.easnbuild and x.easnbuildtime < GetTime() then
			for index = 1, x.easnlength do
				x.easn[index] = BuildObject("svscout", 6, GetPositionNear("epgrcy", 0, 16, 32)) --grpspwn
				SetSkill(x.easn[index], x.skillsetting)
				SetObjectiveName(x.easn[index], "Assassin")
			end
			x.easnresendtime = GetTime()
			x.casualty = 0
			x.easnreset = false
			x.easnbuild = false
		end
		
		if x.easnresendtime < GetTime() then --resend orders if player changes ship
			for index = 1, x.easnlength do
				if IsAlive(x.easn[index]) then
					if not IsPlayer(x.easn[index]) then
            if IsCraftButNotPerson(x.player) then
              Attack(x.easn[index], x.player)
            elseif IsAlive(x.ftugtarget) then
              Attack(x.easn[index], x.ftugtarget)
            else
              Defend2(x.easn[index], x.relic)
            end
          end
					x.easnresendtime = GetTime() + 10.0
					if x.relicplace == 1 then --not quite so x.hard on player
						x.easnresendtime = GetTime() + 20.0
					end
				end
			end
		end
	end

	--BUILD CCA SCAVS FOR LOOKS ----------------------------------------------
	if IsAlive(x.ercy) then
		if GetScrap(5) > 39 then
			SetScrap(5, 0) --so they'll keep collecting scrap
		end
		for index = 1, 2 do
			if not IsAlive(x.escv[index]) and x.escvbuildtime < GetTime() then
				x.escv[index] = BuildObject("svscav", 5, GetPositionNear("epgrcy", 0, 16, 32)) --grpspwn
				x.escvbuildtime = GetTime() + 10.0
			end
		end
	end

	--RUN THE CAMERA AROUND THE CHOSEN RELIC PATH ----------------------------------
	if x.camrelicrun then
		CameraPath(("pcam%d"):format(x.relicplace), 2000, 2000, x.relic)
    SetCurHealth(x.player, x.playerhealth)
	end

	--If CCA RECY DEAD, THEN SEND IN A DROPSHIP TO KEEP GAMEPLAY PLAUSIBLE --------
	if not x.edrpsent and not IsAlive(x.ercy) and GetDistance(x.player, "eprcy") > 400 then
		x.edrp = BuildObject("svdrop_sitopen", 0, x.ercypos)
		x.edrpsent = true
	end

	--CHECK STATUS OF MISSION-CRITICAL ASSETS (MCA) --------------------------------
	if not x.MCAcheck then
		if x.relicexists and GetDistance(x.relic, "epgrcy") < 64 then --CCA got x.relic
			AudioMessage("tcss0335.wav") --19 FAIL	COXXON - combination of 31-34
			TCC.FailMission(GetTime() + 22.0, "tcss03f1.des") --LOSER LOSER LOSER
			ClearObjectives()
			AddObjective("tcss0309.txt", "RED") --CCA captu"RED" relic. Mission FAILED.
			x.spine = 666
			x.MCAcheck = true
		end

		if x.relicexists and not IsAlive(x.relic) then --Check relic status
			AudioMessage("tcss0335.wav") --19 FAIL	COXXON - combination of 31-34
			TCC.FailMission(GetTime() + 22.0, "tcss03f2.des") --LOSER LOSER LOSER
			ClearObjectives()
			AddObjective("tcss0308.txt", "RED") --The object has been destroyed. Mission FAILED.
			x.spine = 666
			x.MCAcheck = true
		end

		if not IsAlive(x.frcy) then --Check Recycler
			AudioMessage("failrecyLtCor.wav") --2s Lt Cor	Generic Recycler lost.
			AudioMessage("tcss0322.wav") --9 FAIL	USE W/21	prep evac
			ClearObjectives()
			AddObjective("failrecycox.txt", "RED") --Your Recycler was destroyed. MISSION FAILED
			TCC.FailMission(GetTime() + 13.0, "tcss03f3.des") --LOSER LOSER LOSER
			x.spine = 666
			x.MCAcheck = true
		end

		if x.warning1 and not x.relicmeetup and x.waittime < GetTime() then --check if player at relic
			AudioMessage("tcss0329.wav") --5 Cmd, still x.waiting on your recon of nav area
			x.waittime = GetTime() + 90.0
			x.warning2 = true
			x.warning1 = false
		end

		if x.warning2 and not x.relicmeetup and x.waittime < GetTime() then --Check if fail to follow orders
			AudioMessage("tcss0394.wav") --9 FAIL	time up for search order orig bz1 0694 copy of ss0594
			TCC.FailMission(GetTime() + 12.0, "tcss03f4.des") --LOSER LOSER LOSER
			x.spine = 666
			x.MCAcheck = true
		end

		if not x.ercydead and not IsAlive(x.ercy) then --Check Enemy Recycler
			AudioMessage("tcss0317.wav") --15 (dest CCA base?) Gen Col rebuke for reckless action.
			AudioMessage("tcss0318.wav") --3 2nd GCol - get back to base and prep attack waves.
			AddObjective("tcss0310.txt", "GREEN") --Destroyed CCA Recycler
			x.ercydead = true
		end
	end
end
--[[END OF SCRIPT]]