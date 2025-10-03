--bztcdw15 - Battlezone Total Command - Dogs of War - 15/15 - THE BEST LAID PLANS
assert(load(assert(LoadFile("_requirefix.lua")),"_requirefix.lua"))();
TCC = require("TC_Core")
MisnNum = 54;
local index = 1
local x = {
	FIRST = true, 	
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
	casualty = 0,
	randompick = 0, 
	randomlast = 0,
	fgrp = {},
	epad = nil, 
	ecne = nil, 
	gotcone = false, 
	eatk = {}, 
	eatkstate = 0, 
	eatkcount = 0, 
	locationpick = {0,0,0,0}, 
	eatksize = 0, 
	eatkdone = false, 
	boomstate = 0, 
	boomtime = 99999.9, 
	camtime = 99999.9, 
	camstate = 0, 
	gany = nil, 
	duke = nil, 
	fcam0 = nil, 
	fcam = {}, --1-4 tanks
	panx = 0, 
	pany = 0, 
	panz = 0,
	failstate = 0, 
	warntime = 99999.9, 
	cnslcmdvalue = 0, 
	LAST = true
}
--PATHS: pmytank, fptnk(0-16), epatk1-8(0-16), eppad, pcam0, pgany, pgany2, pduke1, pcam1-5, pcam21-25, psafe

function InitialSetup()
	SetAutoGroupUnits(true)
		
	local odfpreload = {
		"kvscout", "kvmbike", "kvmisl", "kvtank", "kvrckt", "kvhtnk", "kvapc",	"kvtug", 
		"bvscout", "bvmbike", "bvmisl", "bvtank", "bvrckt", "bvstnk", "bvserv", "bvduke", 
		"apdwqka2", "dummy00", "gpopg1a", "kblpad2", "kbcone1", "apcamrb" 
	}
	for k,v in pairs(odfpreload) do
		PreloadODF(v)
	end
	
	x.epad = GetHandle("epad")
	x.ecne = GetHandle("ecne")
	x.fcam0 = GetHandle("pcam0")
	x.gany = GetHandle("gany")
	for index = 1, 16 do
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
	index, x, TCC.Save()
end

function Load(a, c, coreData)
	index = a;
	x = c;
	TCC.Load(coreData)
end

function AddObject(h)
	if not x.gotcone and IsOdf(h, "kbcone1") then
		x.ecne = h
		x.gotcone = true
	end
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
	TCC.Update();

	local pt = GetTeamNum(x.player);
	for i, unit in pairs(x.eatk) do
		if ((IsAlive(unit) or IsPlayer(unit) or not HasPilot(unit)) and GetTeamNum(unit) == pt) then
			SetObjectiveOff(unit);
			x.eatk[i] = nil;
			break;
		end
	end

	--[[Test Camera Sequence
	if x.spine == 0 then
		x.spine = 5
		x.boomstate = 1
		x.mytank = BuildObject("bvtank", 1, "psafe")
		SetAsUser(x.mytank, 1)
		RemoveObject(x.player)
		x.player = GetPlayerHandle()
		x.pos = GetTransform(x.epad)
		RemoveObject(x.epad)
		x.epad = BuildObject("kblpad2", 5, x.pos)
		x.MCAcheck = true
	end--]]

	--START THE MISSION BASICS
	if x.spine == 0 then
		x.audio1 = AudioMessage("tcdw1501.wav") --Chin head to trans from all directions
		x.mytank = BuildObject("bvtank", 1, "pmytank")
		GiveWeapon(x.mytank, "gchana_c")
		GiveWeapon(x.mytank, "gpopg1a")
		SetAsUser(x.mytank, 1)
		RemoveObject(x.player)
		x.player = GetPlayerHandle()
		x.fgrp[1] = BuildObject("bvscout", 1, "fptnk", 1)
		GiveWeapon(x.fgrp[1], "gchana_c")
		x.fgrp[2] = BuildObject("bvscout", 1, "fptnk", 2)
		GiveWeapon(x.fgrp[2], "gchana_c")
		x.fgrp[3] = BuildObject("bvstnk", 1, "fptnk", 3)
		x.fgrp[4] = BuildObject("bvstnk", 1, "fptnk", 4)
		x.fgrp[5] = BuildObject("bvtank", 1, "fptnk", 5)
		GiveWeapon(x.fgrp[5], "gchana_c")
		GiveWeapon(x.fgrp[5], "gpopg1a")
		x.fgrp[6] = BuildObject("bvtank", 1, "fptnk", 6)
		GiveWeapon(x.fgrp[6], "gchana_c")
		GiveWeapon(x.fgrp[6], "gpopg1a")
		x.fgrp[7] = BuildObject("bvrckt", 1, "fptnk", 7)
		x.fgrp[8] = BuildObject("bvrckt", 1, "fptnk", 8)
		x.fgrp[9] = BuildObject("bvtank", 1, "fptnk", 9)
			GiveWeapon(x.fgrp[9], "gchana_c")
			GiveWeapon(x.fgrp[9], "gpopg1a")
			x.fgrp[10] = BuildObject("bvtank", 1, "fptnk", 10)
			GiveWeapon(x.fgrp[10], "gchana_c")
			GiveWeapon(x.fgrp[10], "gpopg1a")
		if x.skillsetting >= x.medium then
			x.fgrp[11] = BuildObject("bvstnk", 1, "fptnk", 11)
			x.fgrp[12] = BuildObject("bvstnk", 1, "fptnk", 12)
		end
		if x.skillsetting >= x.hard then
			x.fgrp[13] = BuildObject("bvrckt", 1, "fptnk", 13)
			x.fgrp[14] = BuildObject("bvrckt", 1, "fptnk", 14)
		end
		--24 SPAWN PTS TOTAL AVAILABLE
		for index = 1, 14 do
			SetSkill(x.fgrp[index], 3)
			if index %2 == 0 then
				SetGroup(x.fgrp[index], 1)
			else
				SetGroup(x.fgrp[index], 0)
			end
		end
		for index = 15, 19 do
			x.fgrp[index] = BuildObject("bvserv", 1, "fptnk", index)
			SetSkill(x.fgrp[index], 3)
			SetGroup(x.fgrp[index], 2)
		end
		x.pos = GetTransform(x.epad)
		RemoveObject(x.epad)
		x.epad = BuildObject("kblpad2", 5, x.pos)
		x.warntime = GetTime()
		x.spine = x.spine + 1	
	end
	
	--GIVE FIRST OBJECTIVE
	if x.spine == 1 and IsAudioMessageDone(x.audio1) then
		ClearObjectives()
		AddObjective("tcdw1501.txt")
		x.waittime = GetTime() + 10.0
		x.spine = x.spine + 1
	end
	
	--SEND THE ESCAPE GROUPS
	if x.spine == 2 and x.waittime < GetTime() then
		x.waittime = GetTime()
		x.eatkstate = 1
		x.spine = x.spine + 1
	end
	
	--ESCAPE GROUPS DEAD
	if x.spine == 3 and x.eatkdone then
		x.audio1 = AudioMessage("tcdw1507.wav") --Ok Lt. that's the last. Get safe distance. We're gonna nuke em.
		x.spine = x.spine + 1
	end
	
	--START THE SAFE DISTANCE CLOCK
	if x.spine == 4 and IsAudioMessageDone(x.audio1) then
		ClearObjectives()
		AddObjective("tcdw1501.txt", "GREEN")
		AddObjective("\n\nIncoming nuclear strike on launchpad.", "YELLOW")
		AddObjective("\n\nEVACUATE THE BATTLEZONE", "CYAN")
		StartCockpitTimer(35, 15, 7)
		x.boomtime = GetTime() + 35.0
		x.boomstate = 1
		x.spine = x.spine + 1
	end

	--START VICTORY TOUR
	if x.spine == 5 and x.boomstate == 1 and x.boomtime > GetTime() and GetDistance(x.player, "eppad") >= 1000 then
		x.boomtime = 99999.9
		x.boomstate = 2
		x.MCAcheck = true
		x.audio1 = AudioMessage("tcdw1513.wav") --SUCCEED - CPU - Minimum safe distance reached.
		x.cnslcmdvalue = IFace_GetInteger("options.audio.music") --get "music" volume value of player instance
		StopCockpitTimer()
		x.spine = x.spine + 1
	end
	
	--CAMERA INIT SETUP
	if x.spine == 6 and IsAudioMessageDone(x.audio1) then
		IFace_ConsoleCmd("options.audio.music 5") --adjust player "music" volume instance
		HideCockpitTimer()
		x.audio1 = AudioMessage("tcdw1599.wav")
		ClearObjectives()
		for index = 1, 16 do
			RemoveObject(x.fgrp[index])
		end
		x.mytank = BuildObject("bvtank", 1, "psafe")
		SetAsUser(x.mytank, 1)
		RemoveObject(x.player)
		x.player = GetPlayerHandle()
		x.camtime = GetTime() + 7.0 --rocket to gany time
		SetAnimation(x.gany, "flyby", 1)
		x.panx = 0
		x.pany = 111 --110
		x.camstate = 1
    x.userfov = IFace_GetInteger("options.graphics.defaultfov")
    CameraReady()
    IFace_SetInteger("options.graphics.defaultfov", x.camfov)
		x.spine = x.spine + 1
	end

	--CAMERA ROCKET TO GANY
	if x.spine == 7 then
		if x.camtime > GetTime() then
			CameraObject(x.fcam0, x.panx, x.pany, 2, x.gany) --height is stardome radius
			x.panx = x.panx - 0.02 --minus
			x.pany = x.pany + 0.1
		else --prep three tanks
			for index = 1, 4 do
				x.fcam[index] = BuildObject("bvtank", 1, ("pcam%d"):format(index))
				Retreat(x.fcam[index], ("pcam%d"):format(index))
			end
			Damage(x.fcam[4], math.floor(GetMaxHealth(x.fcam[4]) * 0.9))
			x.fcam0 = BuildObject("dummy00", 0, "pcam5")
			x.camtime = GetTime() + 9.0 --three tanks time
			x.duke = BuildObject("bvduke", 0, "pduke")
			Retreat(x.duke, "pduke")
			x.spine = x.spine + 1
		end
	end
	
	--CAMERA ON THREE TANKS
	if x.spine == 8 then
		if x.camtime > GetTime() then
			CameraObject(x.fcam0, -20, 0, -100, x.fcam[4])
		else --prep duke nuke
			x.panx = -10
			x.pany = 10
			x.panz = -5
			x.camtime = GetTime() + 4.0 --duke time
			x.spine = x.spine + 1
		end
	end
	
	--CAMERA ON DUKE
	if x.spine == 9 then
		if x.camtime > GetTime() then
			CameraObject(x.duke, x.panx, x.pany, x.panz, x.duke)
			x.panx = x.panx - 0.1
			x.pany = x.pany - 0.08
			x.panz = x.panz + 0.04
		else --prep base explode
			x.pos = GetTransform(x.epad)
			x.fcam0 = BuildObject("dummy00", 0, x.pos)
			x.fcam[1] = BuildObject("apdwqka", 1, x.epad)
			x.camtime = GetTime() + 4.0 --base explode time
			x.fcam[4] = BuildObject("bvtank", 1, "pcam21")
			Retreat(x.fcam[4], "pcam21")
			x.spine = x.spine + 1
		end
	end
	
	--CAMERA ON BASE EXPLOSION
	if x.spine == 10 then
		if x.camtime > GetTime() then
			CameraObject(x.fcam0, -20,50,300, x.fcam0)
		else
			Damage(x.fcam[4], (GetMaxHealth(x.fcam[4]) * 0.9))
			x.fcam0 = BuildObject("dummy00", 0, "pcam23")
			x.camtime = GetTime() + 1.5 --build kill tank time
			x.spine = x.spine + 1
		end
	end
	
	--CAMERA ON TANK BOMB
	if x.spine == 11 then
		if x.camtime > GetTime() then
			CameraObject(x.fcam0, 10, 10, -40, x.fcam[4]) --0 20 -30
		else
			x.fgrp[2] = BuildObject("apdwqka2", 1, "pcam22")
			x.pos = GetTransform(x.fcam[4])
			x.fcam[5] = BuildObject("dummy00", 0, x.pos)
			x.camtime = GetTime() + 6.5 --watch tank die time
			x.spine = x.spine + 1
		end
	end
	
	--CAMERA ON TANK DEATH
	if x.spine == 12 then
		if x.camtime > GetTime() then
			CameraObject(x.fcam0, 10, 10, -40, x.fcam[5]) --0 20 -30
		else
			x.spine = x.spine + 1
		end
	end
	
	--MISSION SUCCESS	
	if x.spine == 13 then
    CameraFinish()
    IFace_SetInteger("options.graphics.defaultfov", x.userfov)
		IFace_ConsoleCmd(("options.audio.music %d"):format(x.cnslcmdvalue)) --return player "music volume" to previous setting
		TCC.SucceedMission(GetTime() + 1.0, "tcdw15w.des") --WINNER WINNER WINNER
		x.spine = 666
	end
	----------END MAIN SPINE ----------
	
	--AI ESCAPE - PICK SPAWN LOCATIONS
	if x.eatkstate == 1 and x.waittime < GetTime() and x.eatkcount < 4 then
		x.eatkcount = x.eatkcount + 1
		while x.locationpick[x.eatkcount] == 0 do
			x.randompick = math.floor(GetRandomFloat(1.0, 4.0))
			if x.randompick ~= x.locationpick[1] and x.randompick ~= x.locationpick[2] and x.randompick ~= x.locationpick[3] and x.randompick ~= x.locationpick[4] then
				 x.locationpick[x.eatkcount] = x.randompick
			end
		end
		x.eatkstate = x.eatkstate + 1
	end
	
	--AI ESCAPE - BUILD AND SEND FORCE --dumped random unit --wasn't helpful, and makes script shorter
	if x.eatkstate == 2 then
		if x.locationpick[x.eatkcount] == 1 then
			AudioMessage("tcdw1504.wav") --There's a whole squad to the North. Don't let them get there.
			x.eatk[1] = BuildObject("kvscout", 5, "epatk1", 1)
			x.eatk[2] = BuildObject("kvmbike", 5, "epatk1", 2)
			x.eatk[3] = BuildObject("kvmisl", 5, "epatk1", 3)
			x.eatk[4] = BuildObject("kvtank", 5, "epatk1", 4)
			x.eatk[5] = BuildObject("kvrckt", 5, "epatk1", 5)
			x.eatk[6] = BuildObject("kvhtnk", 5, "epatk1", 6)
			x.eatk[7] = BuildObject("kvapc", 5, "epatk1", 7)
			x.eatk[8] = BuildObject("kvtug", 5, "epatk1", 8)
			x.eatk[9] = BuildObject("kvscout", 5, "epatk1", 9)
			x.eatk[10] = BuildObject("kvtank", 5, "epatk1", 10)
			x.eatksize = 10
		elseif x.locationpick[x.eatkcount] == 2 then
			AudioMessage("tcdw1505.wav") --There's a dozen tanks to the East. Get there fast.
			x.eatk[1] = BuildObject("kvscout", 5, "epatk2", 1)
			x.eatk[2] = BuildObject("kvmbike", 5, "epatk2", 2)
			x.eatk[3] = BuildObject("kvmisl", 5, "epatk2", 3)
			x.eatk[4] = BuildObject("kvtank", 5, "epatk2", 4)
			x.eatk[5] = BuildObject("kvrckt", 5, "epatk2", 5)
			x.eatk[6] = BuildObject("kvhtnk", 5, "epatk2", 6)
			x.eatk[7] = BuildObject("kvapc", 5, "epatk2", 7)
			x.eatk[8] = BuildObject("kvtug", 5, "epatk2", 8)
			x.eatk[9] = BuildObject("kvscout", 5, "epatk2", 9)
			x.eatk[10] = BuildObject("kvtank", 5, "epatk2", 10)
			x.eatk[11] = BuildObject("kvmisl", 5, "epatk2", 11)
			x.eatk[12] = BuildObject("kvtank", 5, "epatk2", 12)
			x.eatksize = 12
		elseif x.locationpick[x.eatkcount] == 3 then
			AudioMessage("tcdw1503.wav") --Chinese units to the South
			x.eatk[1] = BuildObject("kvscout", 5, "epatk3", 1)
			x.eatk[2] = BuildObject("kvmbike", 5, "epatk3", 2)
			x.eatk[3] = BuildObject("kvmisl", 5, "epatk3", 3)
			x.eatk[4] = BuildObject("kvtank", 5, "epatk3", 4)
			x.eatk[5] = BuildObject("kvrckt", 5, "epatk3", 5)
			x.eatk[6] = BuildObject("kvhtnk", 5, "epatk3", 6)
			x.eatk[7] = BuildObject("kvtank", 5, "epatk7", 1) --DIFF SPAWN
			x.eatksize = 7
		else
			AudioMessage("tcdw1502.wav") --There's one setting coords (WEST)
			x.eatk[1] = BuildObject("kvscout", 5, "epatk4", 1)
			x.eatk[2] = BuildObject("kvmbike", 5, "epatk4", 2)
			x.eatk[3] = BuildObject("kvmisl", 5, "epatk4", 3)
			x.eatk[4] = BuildObject("kvtank", 5, "epatk4", 4)
			x.eatk[5] = BuildObject("kvrckt", 5, "epatk5", 1) --DIFF SPAWN
			x.eatksize = 5
		end
		for index = 1, x.eatksize do
			SetEjectRatio(x.eatk[index], 0.0)
			SetSkill(x.eatk[index], x.skillsetting)
			SetObjectiveOn(x.eatk[index])
			Goto(x.eatk[index], "eppad")
		end
		x.eatkstate = x.eatkstate + 1
	end
	
	--AI ESCAPE - CASUALTY AND RESET
	if x.eatkstate == 3 then
		for index = 1, x.eatksize do
			if not IsAlive(x.eatk[index]) then
				x.casualty = x.casualty + 1
			end
		end
		if x.casualty >= x.eatksize then
      if x.skillsetting == x.easy then  --pause between groups
        x.waittime = GetTime() + 40.0
      elseif x.skillsetting == x.medium then
        x.waittime = GetTime() + 50.0
      else
        x.waittime = GetTime() + 60.0
      end
			if x.eatkcount < 4 then
				x.eatkstate = 1
			else
				x.eatkstate = 4
			end
		end
		x.casualty = 0
	end
	
	--AI ESCAPE - FINAL GROUP
	if x.eatkstate == 4 and x.waittime < GetTime() then
		AudioMessage("tcdw1506.wav") --Looks like the survivors are making a run for it.
		x.eatk[1] = BuildObject("kvtank", 5, "epatk5", 1)
		x.eatk[2] = BuildObject("kvtank", 5, "epatk6", 1)
		x.eatk[3] = BuildObject("kvtank", 5, "epatk7", 1)
		x.eatk[4] = BuildObject("kvtank", 5, "epatk8", 1)
		x.eatksize = 4
		for index = 1, 4 do
			SetEjectRatio(x.eatk[index], 0.0) --don't distract wingman
			SetSkill(x.eatk[index], x.skillsetting)
			SetObjectiveOn(x.eatk[index])
			Goto(x.eatk[index], "eppad")
		end
		x.eatkstate = x.eatkstate + 1
	end
	
	--AI ESCAPE - FINAL CASUALTY
	if x.eatkstate == 5 then
		for index = 1, x.eatksize do
			if not IsAlive(x.eatk[index]) then
				x.casualty = x.casualty + 1
			end
		end
		if x.casualty >= x.eatksize then
			x.eatkstate = x.eatkstate + 1
			x.eatkdone = true
		end
		x.casualty = 0
	end
	
	--WARN IF TOO CLOSE TO LPAD
	if x.boomstate == 0 and x.warntime < GetTime() and GetDistance(x.player, "eppad") < 300 then
		AudioMessage("tcdw1510.wav") --I think you should keep away from that sir. (launchpad)
		x.warntime = GetTime() + 90.0
	end
	
	--CHECK STATUS OF MCA 
	if not x.MCAcheck then	 
		--CRA escaped part 1
		if x.failstate == 0 then 
			for index = 1, 12 do
				if IsAlive(x.eatk[index]) and GetDistance(x.eatk[index], "eppad") < 80 then --IsInsideArea("ebasearea", x.eatk[index]) then
					x.audio6 = AudioMessage("tcdw1511.wav") --p1 FAIL - the transport is taking off.
					x.spine = 666
					x.failstate = 1
					break
				end
			end
		end
		
		--CRA escaped part 2
		if x.failstate == 1 and IsAudioMessageDone(x.audio6) then 
			AudioMessage("tcdw1512.wav") --p2 FAIL - you are relieved.
			ClearObjectives()
			AddObjective("tcdw1501.txt", "RED")
			AddObjective("\n\nMISSION FAILED!", "RED")
			TCC.FailMission(GetTime() + 8.0, "tcdw15f1.des") --LOSER LOSER LOSER
			x.MCAcheck = true
		end
		
		--Caught in blast
		if x.failstate == 0 and x.boomstate == 1 and x.boomtime < GetTime() then
			SetColorFade(20.0, 0.1, "WHITE")
			AudioMessage("xemt2.wav")
			TCC.FailMission(GetTime() + 2.0, "tcdw15f2.des") --LOSER LOSER LOSER
			x.spine = 666
			x.MCAcheck = true
		end
		
		--Blowed up lpad w/out permission  --might happen on easy
		if x.failstate == 0 and x.boomstate == 0 and x.gotcone and (not IsAlive(x.epad) or not IsAlive(x.ecne)) then
			SetColorFade(20.0, 0.1, "WHITE")
			AudioMessage("xemt2.wav")
			TCC.FailMission(GetTime() + 2.0, "tcdw15f2.des") --LOSER LOSER LOSER
			x.spine = 666
			x.MCAcheck = true
		end
	end
end
--[[END OF SCRIPT]]