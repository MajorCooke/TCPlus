--bztcdw04 - Battlezone Total Command - Dogs of War - 4/15 - WOLF IN SHEEP'S CLOTHING
assert(load(assert(LoadFile("_requirefix.lua")),"_requirefix.lua"))();
TCC = require("TC_Core")
MisnNum = 34;
--DECLARE variables --p-path, f-friend, e-enemy, atk-attack, rcy-recycler
local index = 0
local x = {
	FIRST = true,	
	spine = 0,	
	MCAcheck = false, 
	player = nil, 
	mytank = nil, 
	skillsetting = 0,
	easy = 0, 
	medium = 1, 
	hard = 2, --tried 1-3, in 185, 3 didn't seem to make any difference, 
	audio1 = nil, 
	audio6 = nil, 
	waittime = 99999.9, 
	pos = {}, 
	casualty = 0, 
	fnav = {}, 
	camfov = 60,  --185 default
	userfov = 90,  --seed
	ftug = nil, 
	pdrop = 0, 
	fgrp = {}, 
	fgrpstate = 0, 
	fgrptime = 99999.9, 
	pursuitstate = 0, 
	pursuittime = 99999.9, 
	etur = {}, 
	eatk = {}, 
	easn = {}, --sep out from eatk
	easncount = 0,
	escv = {}, 
	relic = nil, 
	failstate = {}, 
	cam1 = nil, 
	camstate = 0, 
	camspeed = 0, 
	dummy = nil, 
	gotdummy = false, 
	fdrp = nil, 
	ercy = nil, 
	efac = nil, 
	ecom = nil, 
	etec = nil, 
	eprt = nil, 
	LAST = true
}
--PATHS: pmytank, pcam0(0-3), pcam1, pcam2, epatk, eptur(0-6), fpnav, epscav, pscavroute, proutearea, penter, fpgrp(0-10), pscrap, pbase1-2, pbasearea, safespace, ppatrol1-6

function InitialSetup()
		SetAutoGroupUnits(true)
	
	local odfpreload = {
		"bspilo", "bvscout", "bvmbike",	"bvmisl",	"bvtank",	"bvrckt", "bvdrop", "kvscout", "kvmbike", "kvmisl", "kvtank", "kvrckt", "kvwalk", "kvturr", "kvscav", "npscrx", "apcamrb" 
	}
	for k,v in pairs(odfpreload) do
		PreloadODF(v)
	end
	
	x.mytank = GetHandle("mytank")
	x.relic = GetHandle("relic")
	x.ftug = GetHandle("ftug")
	x.ercy = GetHandle("ercy")
	x.efac = GetHandle("efac")
	x.eprt = GetHandle("eprt")
	x.ecom = GetHandle("ecom")
	x.etec = GetHandle("etec")
	Ally(1, 4)
	Ally(4, 1) --4 cam pilot and nav cams
	Ally(1, 2)
	Ally(2, 1) --2 bds attack
	Ally(5, 4) --so these ..
	Ally(4, 5) --...don't interact
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
	if not x.gotdummy and IsOdf(h, "dummy00") then
		x.dummy = h
		x.gotdummy = true
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
		for index = 1, 6 do
			x.etur[index] = BuildObject("kvturr", 5, "eptur", index)
		end
		for index = 1, 60 do
			x.fnav[1] = BuildObject("npscrx", 0, "pscrap", index)
		end
		x.audio1 = AudioMessage("tcdw0401.wav") --Will have to place nav by hand at regular intervals
		for index = 1, 7 do
			x.failstate[index] = 0
		end
		x.mytank = BuildObject("bspilo", 4, "pcam0")
		Goto(x.mytank, "pcam0")
		x.pdrop = 1 --nav cam drop pt
		x.camspeed = 1 --safety re-init
		x.camstate = 1
    x.userfov = IFace_GetInteger("options.graphics.defaultfov")
    CameraReady()
    IFace_SetInteger("options.graphics.defaultfov", x.camfov)
		x.spine = x.spine + 1
	end
	
	--CAMERA START 2 PORTAL
	if x.spine == 1 and (IsAudioMessageDone(x.audio1) or CameraCancelled()) then
		RemoveObject(x.mytank) --the inital pilot
		x.cam1 = BuildObject("abdummy", 0, "pcam2")
		x.camstate = 2
		x.audio1 = AudioMessage("tcdw0402.wav") --What was that (saw portal)
		x.waittime = GetTime() --seed
		x.spine = x.spine + 1
	end
	
	--CAM 2 PORTAL SCOUTS
	if x.spine == 2 and IsAudioMessageDone(x.audio1) and x.waittime < GetTime() then
		x.pos = GetTransform(x.dummy)
		for index = 7, 8 do
			if not IsAlive(x.eatk[index]) then
				StartSoundEffect("portalx.wav")
				x.eatk[index] = BuildObject("kvscout", 5, x.pos) 
				SetVelocity(x.eatk[index], (SetVector(0.0, 0.0, 50.0))) --"kick out" vehicle, don't just "drop"
				Patrol(x.eatk[index], ("pbase%d"):format(index-6))
				x.waittime = GetTime() + 4.0
				break --don't build second right away
			end
		end
		if IsAlive(x.eatk[8]) and x.waittime < GetTime() then
			x.spine = x.spine + 1
		end
	end
	
	--CAMERA START 2 TIMER FOR PORTAL SCOUTS
	if x.spine == 3 then
		x.audio1 = AudioMessage("tcdw0403.wav") --We see it Lt. Commandeer a scav a get a closer look.
		x.spine = x.spine + 1
	end
	
	--GIVE PLAYER 1ST OBJECTIVE
	if x.spine == 4 and IsAudioMessageDone(x.audio1) then
		x.camstate = 0
    CameraFinish()
    IFace_SetInteger("options.graphics.defaultfov", x.userfov)
		SetColorFade(6.0, 0.5, "BLACK")
		RemoveObject(x.cam1)
		x.mytank = BuildObject("bspilo", 1, "pmytank")
		SetAsUser(x.mytank, 1)
		RemoveObject(x.player)
		x.player = GetPlayerHandle()
		SetTeamNum(x.player, 1)--JUST IN CASE
		for index = 1, 3 do
			x.escv[index] = BuildObject("kvscav", 5, "epscav", index)
			--Player is always "7"	SetObjectiveName(x.escv[index], ("Monkey %d"):format(index))
			SetObjectiveOn(x.escv[index])
			SetCommand(x.escv[index], 20) --20 = CMD_SCAVENGE
		end
		KillPilot(x.ftug) --ox tug inside cra base
		x.failstate[1] = 1 --scav
		x.failstate[7] = 1 --base
		x.eatk[1] = BuildObject("kvscout", 5, "ppatrol1")
		x.eatk[2] = BuildObject("kvmbike", 5, "ppatrol2")
		x.eatk[3] = BuildObject("kvmisl", 5, "ppatrol3")
		x.eatk[4] = BuildObject("kvtank", 5, "ppatrol4")
		x.eatk[5] = BuildObject("kvwalk", 5, "ppatrol3")
		x.eatk[6] = BuildObject("kvwalk", 5, "ppatrol4")
		for index = 1, 6 do
			Patrol(x.eatk[index], ("ppatrol%d"):format(index))
		end
		SetObjectiveName(x.eprt, "ID UNKNOWN")
		AddObjective("tcdw0401.txt")
		x.spine = x.spine + 1
	end
	
	--PLAYER IN SCAVENGER
	if x.spine == 5 and IsOdf(x.player, "kvscav") then
		AudioMessage("tcdw0410.wav") --Command says follow those scavs. They might find way into base.
		ClearObjectives()
		AddObjective("tcdw0401.txt", "GREEN")
		AddObjective("	")
		AddObjective("tcdw0402.txt")
		for index = 1, 3 do
			SetObjectiveOff(x.escv[index])
		end
		for index = 1, 3 do
			x.player = GetPlayerHandle()
			if x.escv[index] ~= x.player then
				Goto(x.escv[index], "pscavroute")
			end
		end
		x.failstate[4] = 1 --in scav on
		x.failstate[7] = 0 --base off
		x.spine = x.spine + 1
	end
	
	--PLAYER INSIDE CRA BASE
	if x.spine == 6 and IsAlive(x.player) and GetDistance(x.player, "penter") < 100 then
		ClearObjectives()
		AddObjective("tcdw0402.txt", "GREEN")
		AddObjective("	")
		AddObjective("tcdw0403.txt")
		SetObjectiveOn(x.eprt)
		x.failstate[4] = 0 --in scav off
		x.spine = x.spine + 1
	end
	
	--PLAYER IDed PORTAL
	if x.spine == 7 and IsInfo("kbprtl") then
		x.audio1 = AudioMessage("tcdw0404.wav") --Use the scav as cover to snoop around. You have 1 MINUTE.
		ClearObjectives()
		AddObjective("tcdw0403.txt", "GREEN")
		AddObjective("	")
		AddObjective("tcdw0404.txt")
		SetObjectiveOff(x.eprt)
		SetObjectiveName(x.eprt, "Pegasus Portal")
		x.spine = x.spine + 1
	end
	
	--START FAIL TIMER
	if x.spine == 8 and IsAudioMessageDone(x.audio1) then
		AddObjective("	")
		AddObjective("tcdw0405.txt", "YELLOW")
		--tenser w/out timer StartCockpitTimer(60, 30, 15)
		x.waittime = GetTime() + 80.0
		x.failstate[6] = 1 --time on
		x.spine = x.spine + 1
	end
	
	--PLAYER IDed RELIC
	if x.spine == 9 and IsAlive(x.relic) and IsInfo("hadrelic06") then
		--StopCockpitTimer()
		--HideCockpitTimer()
		AudioMessage("tcdw0407.wav") --That looks fascinating. Can you bring it to us?
		ClearObjectives()
		AddObjective("tcdw0404.txt", "GREEN")
		AddObjective("	") --skip 05 green
		AddObjective("tcdw0406.txt")
		x.failstate[1] = 0 --off so player can exit scav
		x.failstate[6] = 0 --time off
		x.spine = x.spine + 1
	end
	
	--PLAYER PICKED UP RELIC
	if x.spine == 10 and IsAlive(x.relic) and IsAlive(x.player) and GetTug(x.relic) == x.player then
		ClearObjectives()
		AddObjective("tcdw0406.txt", "GREEN")
		AddObjective("	")
		AddObjective("tcdw0407.txt", "YELLOW")
		x.fnav = BuildObject("apcamrb", 1, "fpnav")
		SetObjectiveName(x.fnav, "Dropzone")
		SetObjectiveOn(x.fnav)
		x.fgrpstate = 1
		x.fgrptime = GetTime()
		x.failstate[5] = 1 --safespace on
		x.spine = x.spine + 1
	end
	
	--PLAYER CLEAR TO MOVE
	if x.spine == 11 then
		for index = 1, 10 do
			if IsAlive(x.fgrp[index]) and IsAlive(x.ecom) and GetDistance(x.fgrp[index], x.ecom) < 300 then
				ClearObjectives()
				AddObjective("tcdw0407.txt", "GREEN")
				AddObjective("	")
				AddObjective("tcdw0408.txt")
				x.failstate[5] = 0 --safespace off
				x.spine = x.spine + 1
				break
			end
		end
		x.failstate[8] = 1 --escape via entrance
	end
	
	--PLAYER AT EXIT(ENTRANCE)
	if x.spine == 12 and IsAlive(x.player) and GetDistance(x.player, "penter") < 100 then
		x.failstate[8] = 0
		x.pursuitstate = 1
		x.spine = x.spine + 1
	end
	
	--CALL IN DROPSHIP
	if x.spine == 13 and IsAlive(x.relic) and GetDistance(x.relic, "fpnav") < 500 then
		x.fdrp = BuildObject("bvdrop", 0, "fpnav")
		SetAnimation(x.fdrp, "land", 1)
		x.spine = x.spine + 1
	end
	
	--DROPSHIP OPEN
	if x.spine == 14 and IsAlive(x.relic) and GetDistance(x.relic, "fpnav") < 150 then
		SetAnimation(x.fdrp, "open", 1)
		x.spine = x.spine + 1
	end
	
	--RELIC AT NAV BEACON
	if x.spine == 15 and IsAlive(x.relic) and GetDistance(x.relic, "fpnav") < 70 then
		x.audio1 = AudioMessage("tcdw0408.wav") --SUCCEED - Good work LT. Our researchers analyzing the data now.
		ClearObjectives()
		AddObjective("tcdw0408.txt", "GREEN")
		AddObjective("\n\nMISSION COMPLETE!", "GREEN")
		x.MCAcheck = true
		x.spine = x.spine + 1
	end
	
	--SUCCEED MISSION
	if x.spine == 16 and IsAudioMessageDone(x.audio1) then
		SucceedMission(GetTime(), "tcdw04w.des")
		x.spine = 666
	end
	----------END MAIN SPINE ----------
	
	--CAMERA 1 WATCH BDS PILOT DROP NAV CAMS
	if x.camstate == 1 then
		CameraPath("pcam1", 600, x.camspeed, x.mytank)  
		x.camspeed = x.camspeed + 3
	end
	
	--CAM 1 DROP NAV CAMERAS
	if x.camstate == 1 and IsAlive(x.mytank) and GetDistance(x.mytank, "pcam0", x.pdrop) < 5 then
		x.fnav[x.pdrop] = BuildObject("apcamrb", 4, "pcam0", x.pdrop)
		x.pdrop = x.pdrop + 1
	end
	
	--CAMERA 2 WATCH PORTAL
	if x.camstate == 2 then
		CameraObject(x.dummy, 25, -15, 120, x.dummy)
	end
	
	--BDS ATTACK
	if x.fgrpstate == 1 then
		for index = 1, 10 do
			if not IsAlive(x.fgrp[index]) then
				if index % 2 == 0 then
					x.fgrp[index] = BuildObject("bvrckt", 2, "fpgrp", index)
				else
					x.fgrp[index] = BuildObject("bvtank", 2, "fpgrp", index)
				end
				SetSkill(x.fgrp[index], 3) --make sure they can fight
			end
		end
		x.fgrpstate = 2
	elseif x.fgrpstate == 2 and x.fgrptime < GetTime() then
		for index = 1, 10 do
			if IsAlive(x.ecom) then
				Attack(x.fgrp[index], x.ecom)
			elseif IsAlive(x.etec) then
				Attack(x.fgrp[index], x.etec)
			elseif IsAlive(x.ebay) then
				Attack(x.fgrp[index], x.ebay)
			elseif IsAlive(x.efac) then
				Attack(x.fgrp[index], x.efac) 
			elseif IsAlive(x.ercy) then
				Attack(x.fgrp[index], x.ercy)
			elseif IsAlive(x.eprt) then
				Attack(x.fgrp[index], x.eprt)
			end
		end
		x.fgrptime = GetTime() + 15.0
		x.fgrpstate = 1
	end
	
	--PLAYER ESCAPE PURSUIT
	if x.pursuitstate == 1 then
		x.fgrp[11] = BuildObject("bvscout", 1, "fpgrp", 11)
		x.fgrp[12] = BuildObject("bvmbike", 1, "fpgrp", 12)
		x.fgrp[13] = BuildObject("bvmisl", 1, "fpgrp", 13)
		x.fgrp[14] = BuildObject("bvtank", 1, "fpgrp", 14)
		x.fgrp[15] = BuildObject("bvstnk", 1, "fpgrp", 15)
		x.fgrp[16] = BuildObject("bvrckt", 1, "fpgrp", 16)
		for index = 11, 16 do
			SetGroup(x.fgrp[index], 0)
			SetSkill(x.fgrp[index], x.skillsetting)
			Follow(x.fgrp[index], x.player, 0)
		end
		x.pursuittime = GetTime() + 2.0 --let player get out of base
		x.pursuitstate = x.pursuitstate + 1
	elseif x.pursuitstate == 2 and x.pursuittime < GetTime() then
		AudioMessage("alertpulse.wav")
		ClearObjectives()
		AddObjective("tcdw0408.txt")
		AddObjective("\n\nCRA Assassins coming after you!", "YELLOW")
		AddObjective("\n\nBDS escort under your command.", "CYAN")
		x.pursuittime = GetTime() + 25.0 --let player get out of base
		x.pursuitstate = x.pursuitstate + 1
	elseif x.pursuitstate == 3 and x.pursuittime < GetTime() then
		x.player = GetPlayerHandle() --to be safe
		SetPerceivedTeam(x.player, 1) --kill'em
		SetTeamNum(x.ftug, 1) --kill'em for sure
		if IsAlive(x.eatk[7]) then
			Attack(x.eatk[7], x.ftug)
		end
		if IsAlive(x.eatk[8]) then
			Attack(x.eatk[8], x.ftug)
		end
		x.pursuittime = GetTime()
		x.pursuitstate = x.pursuitstate + 1
	elseif x.pursuitstate == 4 and x.pursuittime < GetTime() then
		x.easncount = x.easncount + 1 --need init here
		if x.easncount % 2 == 0 then
			x.easn[x.easncount] = BuildObject("kvtank", 5, "epatk")
		else
			x.easn[x.easncount] = BuildObject("kvscout", 5, "epatk")
		end
		SetSkill(x.easn[x.easncount], x.skillsetting)
		SetObjectiveName(x.easn[x.easncount], ("Assassin %d"):format(x.easncount))
		--SetObjectiveOn(x.easn[x.easncount])
		Attack(x.easn[x.easncount], x.ftug)
		x.pursuittime = GetTime() + 16.0
		if x.skillsetting == x.medium then --mo time since 
			x.pursuittime = GetTime() + 19.0 --harder to kill
		elseif x.skillsetting == x.hard then --higher level
			x.pursuittime = GetTime() + 21.0 --difficulty
		end
	end
	
	--KEEP ESCV COLLECTING SCRAP
	if x.failstate[1] == 1 and GetScrap(5) > 60 then
		SetScrap(5, 60)
	end

	--CHECK STATUS OF MISSION-CRITICAL ASSETS (MCA)
	if not x.MCAcheck then		
		if x.failstate[1] == 1 and ((not IsAlive(x.escv[1]) and not IsAlive(x.escv[2])) or 
		(not IsAlive(x.escv[2]) and not IsAlive(x.escv[3])) or (not IsAlive(x.escv[1]) and not IsAlive(x.escv[3]))) then
			x.audio6 = AudioMessage("tcdw0409.wav") --FAIL? - Careful LT. There aren't many of those (tug/relic LOST?)
			ClearObjectives()
			AddObjective("Only snipe and commandeer one scavenger.\n\nMISSION FAILED!", "RED")
			FailMission(GetTime() + 6.0, "tcdw04f1.des") --LOSER LOSER LOSER
			x.spine = 666
			x.MCAcheck = true
		end
		
		if not IsAlive(x.relic) then --no need for failstate[2] 
			x.audio6 = AudioMessage("tcdw0409.wav") --FAIL? - Careful LT. There aren't many of those (tug/relic LOST?)
			ClearObjectives()
			AddObjective("You allowed a Cthonian artifact to be destroyed.\n\nMISSION FAILED!", "RED")
			FailMission(GetTime() + 6.0, "tcdw04f2.des") --LOSER LOSER LOSER
			x.spine = 666
			x.MCAcheck = true
		end
		
		if not IsAround(x.ftug) then --no need for failstate[3]
			x.audio6 = AudioMessage("tcdw0409.wav") --FAIL? - Careful LT. There aren't many of those (tug/relic LOST?)
			ClearObjectives()
			AddObjective("That tug was required to complete the mission.\n\nMISSION FAILED!", "RED")
			FailMission(GetTime() + 6.0, "tcdw04f3.des") --LOSER LOSER LOSER
			x.spine = 666
			x.MCAcheck = true
		end
		
		if x.failstate[4] == 1 and (not IsInsideArea("proutearea", x.player) or IsOdf(x.player, "bspilo")) then
			AudioMessage("tcdw0405.wav") --Scav 7 execute standing order Alpha 12
			x.audio6 = AudioMessage("tcdw0406.wav") --All units, scav 7 is not responding. execute std order Tango17
			ClearObjectives()
			AddObjective("You have been caught trying to infiltrate the CRA base.\n\nMISSION FAILED!", "RED")
			x.spine = 666
			x.failstate[4] = 2
		end
		
		if x.failstate[4] == 2 and IsAudioMessageDone(x.audio6) then
			x.MCAcheck = true
			FailMission(GetTime(), "tcdw04f4.des") --LOSER LOSER LOSER
		end
		
		if x.failstate[5] == 1 and not IsInsideArea("safespace", x.player) then
			AudioMessage("alertpulse.wav")
			ClearObjectives()
			AddObjective("You have been caught trying to escape.\n\nMISSION FAILED!", "RED")
			x.spine = 666
			x.MCAcheck = true
			FailMission(GetTime() + 4.0, "tcdw04f5.des") --LOSER LOSER LOSER
		end
		
		if x.failstate[6] == 1 and x.waittime < GetTime()then
			AudioMessage("tcdw0405.wav") --Scav 7 execute standing order Alpha 12
			x.audio6 = AudioMessage("tcdw0406.wav") --All units, scav 7 is not responding. execute std order Tango17
			ClearObjectives()
			AddObjective("You've run out of time.\n\nMISSION FAILED!", "RED")
			x.spine = 666
			x.failstate[6] = 2
		end
		
		if x.failstate[6] == 2 and IsAudioMessageDone(x.audio6) then
			x.MCAcheck = true
			FailMission(GetTime(), "tcdw04f6.des") --LOSER LOSER LOSER
		end
		
		if (x.failstate[7] == 1 and IsOdf(x.player, "bspilo") and IsInsideArea("pbasearea", x.player)) 
		or (x.fgrpstate == 0 and IsAlive(x.relic) and not IsInsideArea("safespace", x.relic)) then 
			AudioMessage("alertpulse.wav")
			ClearObjectives()
			AddObjective("You have been caught infiltrating the base.\n\nMISSION FAILED!", "RED")
			x.spine = 666
			x.MCAcheck = true
			FailMission(GetTime() + 4.0, "tcdw04f7.des") --LOSER LOSER LOSER
		end
		
		if x.failstate[8] == 1 and not IsInsideArea("pbasearea", x.player) then
			AudioMessage("alertpulse.wav")
			ClearObjectives()
			AddObjective("You have been caught trying to escape.\n\nMISSION FAILED!", "RED")
			x.spine = 666
			x.MCAcheck = true
			FailMission(GetTime() + 4.0, "tcdw04f5.des") --LOSER LOSER LOSER
		end
	end
end
--[[END OF SCRIPT]]