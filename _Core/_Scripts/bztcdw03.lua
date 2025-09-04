--bztcdw03 - Battlezone Total Command - Dogs of War - 3/15 - SPILT MILK
assert(load(assert(LoadFile("_requirefix.lua")),"_requirefix.lua"))();
TCC = require("TC_Core")
MisnNum = 32;
--DECLARE variables --p-path, f-friend, e-enemy, atk-attack, rcy-recycler
local index = 0
local index2 = 0
local indexadd = 0
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
	frcy = nil, 
	frcystate = 0, 
	fgrp = {}, 
	etur = {}, 
	eturbuilt = 0, 
	eatk = {}, 
	eatkstate = {}, 
	eatkcloaktime = {}, 
	eatkfrcy = {}, 
	eatkfrcystate = {}, 
	eatkfrcylength = 0, 
	eatkfrcycond = 0, 
	eatklength = 0,	
	camstate = 0, 
	failstate = 0, 
	fapc = nil, 
	fapcstate = 0, 
	fapchealthpercent = 9.99999,
	fapcwhine = false, 
	ambushstate = 0, 
	ambushpoint = 0, 
	cam1 = nil, 
	fguardstate = 0, 
	fguardshooter = nil, 
	allystate = false, 
	LAST = true
}
--PATHS: fpnav1, pscrap(0-60), fprcy, fpapc, pcam1, prcydrop, eptur1(0-6), epatk1(0-14), epatk2(0-7), paid

function InitialSetup()
	SetAutoGroupUnits(true)
	
	local odfpreload = {
		"bvrecydw03", "bbrecydw03", "bvtank", "bvmbike", "bvscoutdw03", "bvstnkdw03", "bvapc", "kvscout", "kvmbike", "kvmisl", "kvtank", "kvrckt", "kvturr", "npscrx", "apcamrb"
	}
	for k,v in pairs(odfpreload) do
		PreloadODF(v)
	end
	
	x.mytank = GetHandle("mytank")
	for index = 1, 4 do
		x.fgrp[index] = GetHandle(("fgrp%d"):format(index))
	end
	Ally(1, 4)
	Ally(4, 1)
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
	index, index2, indexadd, x, TCC.Save()
end

function Load(a, b, c, d, coreData)
	index = a;
	index2 = b;
	indexadd = c;
	x = d;
	TCC.Load(coreData);

	if IsAlive(x.fapc) then
		UnAlly(5, 4)
		UnAlly(4, 5)
	end
end


function AddObject(h)
	if (GetRace(h) == "k") then SetEjectRatio(h, 0);	end
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
		for index = 1, 10 do --seed
			x.eatk[index] = nil
		end
		for index = 1, 60 do
			x.fnav[1] = BuildObject("npscrx", 0, "pscrap", index)
		end
		for index = 1, 16 do
			x.eatkstate[index] = 0
			x.eatkcloaktime[index] = 99999.9
		end
		for index = 1, 4 do
			SetSkill(x.fgrp[index], x.skillsetting)
		end
		x.audio1 = AudioMessage("tcdw0301.wav") --CHar - All units rendezvous at Nav 
		x.failstate = 1
		x.camstate = 1
    x.userfov = IFace_GetInteger("options.graphics.defaultfov")
    CameraReady()
    IFace_SetInteger("options.graphics.defaultfov", x.camfov)
		x.spine = x.spine + 1
	end
	
	--CAMERA START 2
	if x.spine == 1 and (IsAudioMessageDone(x.audio1) or CameraCancelled()) then
		x.cam1 = BuildObject("abdummy", 0, "pcam1")
		x.camstate = 2
		x.audio1 = AudioMessage("tcdw0302.wav") --Roger. My unit is 1km N of there. rendezvous at Nav Delta
		SetAsUser(x.mytank, 1)
		RemoveObject(x.player)
		x.player = GetPlayerHandle()
		x.spine = x.spine + 1
	end
	
	--CAMERAS DONE, SPAWN CRA
	if x.spine == 2 and (IsAudioMessageDone(x.audio1) or CameraCancelled()) then
		x.camstate = 0
    CameraFinish()
    IFace_SetInteger("options.graphics.defaultfov", x.userfov)
		SetColorFade(6.0, 0.5, "BLACK")
		RemoveObject(x.cam1)
		AddObjective("tcdw0301.txt")
		x.eatk[1] = BuildObject("kvscout", 5, "epatk1", 1)
		x.eatk[2] = BuildObject("kvscout", 5, "epatk1", 2)
		x.eatk[3] = BuildObject("kvmbike", 5, "epatk1", 3)
		x.eatk[4] = BuildObject("kvmisl", 5, "epatk1", 4)
		x.eatk[5] = BuildObject("kvtank", 5, "epatk1", 5)
		x.eatk[6] = BuildObject("kvscout", 5, "epatk1", 6)
		x.eatk[7] = BuildObject("kvscout", 5, "epatk1", 7)
		x.eatk[8] = BuildObject("kvmbike", 5, "epatk1", 8)
		x.eatk[9] = BuildObject("kvmisl", 5, "epatk1", 9) --removed diff size 9-10, 11-2
		x.eatk[10] = BuildObject("kvtank", 5, "epatk1", 10)
		x.eatk[11] = BuildObject("kvscout", 5, "epatk1", 11)
		x.eatk[12] = BuildObject("kvtank", 5, "epatk1", 12)
		x.eatklength = 12
		for index = 1, x.eatklength do
			if IsAlive(x.eatk[index]) then
				SetCommand(x.eatk[index], 47) --47 = CMD_MORPH_SETDEPLOYED // For morphtanks
			end
		end
		x.fnav[1] = BuildObject("apcamrb", 1, "fpnav1")
		SetObjectiveName(x.fnav[1], "Delta")
		SetObjectiveOn(x.fnav[1])
		for index = 1, 4 do
			x.fnav[2] = BuildObject("apservk", 0, "paid", index)
		end
		x.spine = x.spine + 1
	end
	
	--GIVE PLAYER FRCY
	if x.spine == 3 and IsAlive(x.player) and IsAlive(x.frcy) and GetDistance(x.player, x.frcy) < 200 then
		AudioMessage("tcdw0306.wav") --(Recy) many are we glad to see you Lt.
		ClearObjectives()
		AddObjective("tcdw0301.txt", "GREEN")
		SetObjectiveOff(x.fnav[1])
		x.pos = GetTransform(x.frcy)
		RemoveObject(x.frcy)
		x.frcy = BuildObject("bbrecydw03", 1, x.pos)
		SetTeamNum(x.fgrp[5], 1)
		SetGroup(x.fgrp[5], 0)
		SetTeamNum(x.fgrp[6], 1)
		SetGroup(x.fgrp[6], 1)
		SetTeamNum(x.fgrp[7], 1)
		SetGroup(x.fgrp[7], 2)
		if x.skillsetting == x.easy then
			x.waittime = GetTime() + 150.0
		elseif x.skillsetting == x.medium then
			x.waittime = GetTime() + 120.0
		else
			x.waittime = GetTime() + 90.0
		end
		x.spine = x.spine + 1
	end
	
	--CRA ATTACKS FRCY
	if x.spine == 4 and x.waittime < GetTime() then
		if x.eatkfrcycond == 0 then
			x.eatkfrcy[1] = BuildObject("kvscout", 5, "epatk2", 1) --removed difficulty size
			x.eatkfrcy[2] = BuildObject("kvmbike", 5, "epatk2", 2)
			x.eatkfrcy[3] = BuildObject("kvmisl", 5, "epatk2", 3)
			x.eatkfrcy[4] = BuildObject("kvtank", 5, "epatk2", 4)
			x.eatkfrcy[5] = BuildObject("kvrckt", 5, "epatk2", 5)
			x.eatkfrcy[6] = BuildObject("kvrckt", 5, "epatk2", 6)
			x.eatkfrcy[7] = BuildObject("kvrckt", 5, "epatk2", 7)
			x.eatkfrcylength = 7
			for index = 1, x.eatkfrcylength do
				SetSkill(x.eatkfrcy[index], x.skillsetting)
				x.eatkfrcystate[index] = 0
			end
			x.eatkfrcycond = x.eatkfrcycond + 1
		elseif x.eatkfrcycond == 1 then
			for index = 1, x.eatkfrcylength do
				if x.eatkfrcystate[index] == 0 then
					SetCommand(x.eatkfrcy[index], 47) --47 = CMD_MORPH_SETDEPLOYED // For morphtanks
					x.eatkfrcystate[index] = 1
				elseif x.eatkfrcystate[index] == 1 then
					Retreat(x.eatkfrcy[index], x.frcy)
					x.eatkfrcystate[index] = x.eatkfrcystate[index] + 1
				elseif x.eatkfrcystate[index] == 2 and IsAlive(x.eatkfrcy[index]) and IsAlive(x.frcy) and GetDistance(x.eatkfrcy[index], x.frcy) < 150 then
					SetCommand(x.eatkfrcy[index], 48) --48 = CMD_MORPH_SETUNDEPLOYED // For morphtanks
					x.eatkfrcystate[index] = x.eatkfrcystate[index] + 1
				elseif x.eatkfrcystate[index] == 3 then
					Attack(x.eatkfrcy[index], x.frcy)
					x.eatkfrcystate[index] = x.eatkfrcystate[index] + 1
				end
			end
		end
		
		for index = 1, x.eatkfrcylength do
			if not IsAlive(x.eatkfrcy[index]) then
				x.casualty = x.casualty + 1
			end
		end
		
		if x.casualty >= 4 then
			for index = 1, x.eatkfrcylength do
				if IsAlive(x.eatkfrcy[index]) then
					SetCommand(x.eatkfrcy[index], 48) --48 = CMD_MORPH_SETUNDEPLOYED // For morphtanks
				end
			end
			x.waittime = GetTime() + 30.0 --removed difficulty timing
			x.spine = x.spine + 1
		end
		x.casualty = 0
	end
	
	--SEND APC
	if x.spine == 5 and x.waittime < GetTime() then
		UnAlly(5, 4)
		UnAlly(4, 5)
		x.fapc = BuildObject("bvapc", 4, "fpapc")
		Goto(x.fapc, "fpapc")
		x.fgrp[7] = BuildObject("bvtank", 4, "fpapc")
		Defend2(x.fgrp[7], x.fapc)
		x.fgrp[8] = BuildObject("bvmisl", 4, "fpapc")
		Defend2(x.fgrp[8], x.fapc)
		x.audio1 = AudioMessage("tcdw0307.wav") --24th lost tanks. Apc coming from south. Protect it.
		AddObjective("SAVE", "DKGREY")
		x.spine = x.spine + 1
	end
	
	--GIVE APC OBJECTIVE CARD
	if x.spine == 6 and IsAudioMessageDone(x.audio1) then
		ClearObjectives() --clear 1st, 3rd is long
		AddObjective("tcdw0303.txt")
		SetObjectiveOn(x.fapc)
		x.fapcstate = 1
		x.ambushstate = 1
		x.ambushpoint = 1 --init
		x.failstate = 2
		x.spine = x.spine + 1
	end

	--APC ARRIVED SAFELY
	if x.spine == 7 and IsAlive(x.fapc) and IsAlive(x.frcy) and GetDistance(x.fapc, x.frcy) < 100 then
		x.audio1 = AudioMessage("tcdw0309.wav") --SUCCEED - Great work now we can org against Chinese.
		ClearObjectives()
		AddObjective("APC and injured personnel rescued.\n\nMISSION COMPLETE!", "GREEN")
		x.spine = x.spine + 1
	end
	
	--SUCCEED MISSION
	if x.spine == 8 and IsAudioMessageDone(x.audio1) then
		SucceedMission(GetTime(), "tcdw03w.des")
		x.spine = 666
	end
	----------END MAIN SPINE ----------
	
	--CAMERA 1 WATCH PLAYER
	if x.camstate == 1 then
		CameraObject(x.mytank, 0, 10, 30, x.mytank) --new front
	end
	
	--CAMERA 2 WATCH FRCY
	if x.camstate == 2 then
		CameraObject(x.cam1, 0, 10, 0, x.frcy)
	end
	
	--FRCY STUFF
	if x.frcystate == 0 then
		x.frcy = BuildObject("bvrecydw03", 4, "fprcy")
		x.fgrp[5] = BuildObject("bvmbike", 4, "fprcy")
		Defend2(x.fgrp[5], x.frcy)
		x.fgrp[6] = BuildObject("bvscout", 4, "fprcy")
		Defend2(x.fgrp[6], x.frcy)
		x.waittime = GetTime() + 5.0
		x.frcystate = x.frcystate + 1
	elseif x.frcystate == 1 and x.waittime < GetTime() then
		Goto(x.frcy, "fprcy")
		x.waittime = GetTime() + 40.0
		x.frcystate = x.frcystate + 1
	elseif x.frcystate == 2 and x.waittime < GetTime() then
		AudioMessage("tcdw0303.wav") --All units we're under attack.
		RemoveObject(x.fgrp[5])
		RemoveObject(x.fgrp[6])
		x.frcystate = x.frcystate + 1
	elseif x.frcystate == 3 and IsAlive(x.frcy) and GetDistance(x.frcy, "prcydrop") < 600 then
		AudioMessage("tcdw0304.wav") --The Recy got through to rendezvous. Meet it there.
		AudioMessage("tcdw0305.wav") --Good call private. Its tooled to build Red Devil LAV
		x.frcystate = x.frcystate + 1
	elseif x.frcystate == 4 and IsAlive(x.frcy) and GetDistance(x.frcy, "prcydrop") < 50 then
		Dropoff(x.frcy, "prcydrop")
		x.frcystate = x.frcystate + 1
	elseif x.frcystate == 5 and IsAlive(x.frcy) and IsOdf(x.frcy, "bbrecydw03") then
		x.fgrp[5] = BuildObject("bvscav", 4, "fpgrp5", 1)
		x.fgrp[6] = BuildObject("bvturr", 4, "fpgrp5", 2)
		x.fgrp[7] = BuildObject("bvturr", 4, "fpgrp5", 3)
		x.frcystate = x.frcystate + 1
	end
	
	--CRA TURRET 1
	if x.eturbuilt == 0 and ((IsAlive(x.frcy) and GetDistance(x.frcy, "prcydrop") < 1000) or (IsAlive(x.player) and GetDistance(x.player, "eptur1", 1) < 800)) then
		for index = 1, 5 do
			x.etur[index] = BuildObject("kvturr", 5, "eptur1", index)
			if IsAlive(x.etur[index]) then
				SetSkill(x.etur[index], x.skillsetting)
        --SetObjectiveOn(x.etur[index])
			end
		end
		x.eturbuilt = 1
	end
	
	--CRA ATTACKS PLAYER
	for index = 1, x.eatklength do
		if x.eatkstate[index] == 0 and IsAlive(x.player) and IsAlive(x.eatk[index]) and GetDistance(x.player, x.eatk[index]) < 300 then
			Attack(x.eatk[index], x.player)
			x.eatkstate[index] = x.eatkstate[index] + 1
		elseif x.eatkstate[index] == 1 and IsAlive(x.player) and IsAlive(x.eatk[index])  and GetDistance(x.player, x.eatk[index]) < 150 then
			SetCommand(x.eatk[index], 48) --48 = CMD_MORPH_SETUNDEPLOYED // For morphtanks
			x.eatkcloaktime[index] = GetTime() + 1.0
			x.eatkstate[index] = x.eatkstate[index] + 1
		elseif x.eatkstate[index] == 2 and IsAlive(x.eatk[index]) and x.eatkcloaktime[index] < GetTime() then
			SetSkill(x.eatk[index], x.skillsetting)
			Attack(x.eatk[index], x.player)
			x.eatkstate[index] = x.eatkstate[index] + 1
		end
	end
	
	--FAPC HEALTH STATUS
	if x.fapcstate == 1 and IsAlive(x.fapc) then
		x.fapchealthpercent = math.floor((GetCurHealth(x.fapc) / GetMaxHealth(x.fapc)) * 100)
		SetObjectiveName(x.fapc, ("Rat Pack %d%%"):format(x.fapchealthpercent))
	end
	
	--FAPC WHINE
	if not x.fapcwhine and x.fapcstate == 1 and IsAlive(x.fapc) and GetCurHealth(x.fapc) < math.floor(GetMaxHealth(x.fapc) * 0.5) then
		AudioMessage("tcdw0308.wav") --APC - we're under attack. Need help fast
		x.fapcwhine = true
	end
	
	--CRA ATTACKS FAPC
	if x.ambushstate == 1 and x.ambushpoint < 6 and IsAlive(x.fapc) and GetDistance(x.fapc, "epambush", x.ambushpoint) < 500 then --AMBUSH START
		x.eatklength = 0  --reset
		x.eatk[1] = BuildObject("kvtank", 5, "epambush", x.ambushpoint)
		x.eatklength = x.eatklength + 1
		if IsAlive(x.fapc) and GetCurHealth(x.fapc) > math.floor(GetMaxHealth(x.fapc) * 0.15) then
			x.eatk[2] = BuildObject("kvscout", 5, "epambush", x.ambushpoint)
			x.eatklength = x.eatklength + 1
		end
		if IsAlive(x.fapc) and GetCurHealth(x.fapc) > math.floor(GetMaxHealth(x.fapc) * 0.6) then
			x.eatk[3] = BuildObject("kvtank", 5, "epambush", x.ambushpoint)
			x.eatklength = x.eatklength + 1
		end
		for index = 1, x.eatklength do
			SetSkill(x.eatk[index], x.skillsetting)
			SetCommand(x.eatk[index], 47) --47 = CMD_MORPH_SETDEPLOYED // For morphtanks
		end
		x.waittime = GetTime() + 1.0
		x.ambushstate = x.ambushstate + 1
	elseif x.ambushstate == 2 and x.waittime < GetTime() then --AMBUSH SEND
		for index = 1, x.eatklength do
			Retreat(x.eatk[index], x.fapc) --ignore other units
		end
		x.ambushstate = x.ambushstate + 1
	elseif x.ambushstate == 3 then 
		for index = 1, x.eatklength do
			if GetDistance(x.eatk[index], x.fapc) < 200 then --AMBUSH UNCLOAK
				for index2 = 1, x.eatklength do
					SetCommand(x.eatk[index2], 48) --48 = CMD_MORPH_SETUNDEPLOYED // For morphtanks
					x.waittime = GetTime() + 1.0
				end
				x.ambushstate = x.ambushstate + 1
				break
			end
		end
	elseif x.ambushstate == 4 and x.waittime < GetTime() then --AMBUSH ATTACK
		for index = 1, x.eatklength do 
			Attack(x.eatk[index], x.fapc)
		end
		x.ambushpoint = x.ambushpoint + 1 --set next location
		x.ambushstate = 1 --reset
	end
	
	--FAPC DEFENDERS
	if x.fapcstate == 1 then
		if x.fguardstate == 0 and IsAlive(x.fapc) then
			x.shooter = GetWhoShotMe(x.fapc)
		end
		if x.fguardstate == 0 and IsAlive(x.shooter) and IsAlive(x.fguardshooter) and GetTeamNum(x.fguardshooter) == 5 then
			if IsAlive(x.fgrp[7]) then
				Attack(x.fgrp[7], x.fguardshooter)
			end
			if IsAlive(x.fgrp[8], x.fguardshooter) then
				Attack(x.fgrp[8], x.fguardshooter)
			end
			x.fguardstate = 1
		end
		if x.fguardstate == 1 and not IsAlive(x.fguardshooter) then
			Defend2(x.fgrp[7], x.fapc)
			Defend2(x.fgrp[8], x.fapc)
			x.fguardstate = 0
		end
	end

	--CHECK STATUS OF MISSION-CRITICAL ASSETS (MCA)
	if not x.MCAcheck then
		if (x.failstate == 1 or x.failstate == 2) and not IsAlive(x.frcy) then --lost recycler
			x.audio6 = AudioMessage("tcdw0312.wav") --FAIL - recy lost
			ClearObjectives()
			AddObjective("Recycler destroyed.\n\nMISSION FAILED!", "RED")
			x.spine = 666
			x.failstate = 10
		elseif x.failstate == 10 and IsAudioMessageDone(x.audio6) then
			x.MCAcheck = true
			FailMission(GetTime() + 1.0, "tcdw03f1.des") --LOSER LOSER LOSER
		end
		
		if x.failstate == 2 and not IsAlive(x.fapc) then --lost APC
			AudioMessage("tcdw0310.wav") --p1 - apc killed aaarrgghhhh
			x.audio6 = AudioMessage("tcdw0311.wav") --p2 FAIL - apc lost
			ClearObjectives()
			--AddObjective("tcdw0303.txt", "RED")
			AddObjective("APC destroyed, personnel lost.\n\nMISSION FAILED!", "RED")
			x.spine = 666
			x.failstate = 20
		elseif x.failstate == 20 and IsAudioMessageDone(x.audio6) then
			x.MCAcheck = true
			FailMission(GetTime() + 1.0, "tcdw03f2.des") --LOSER LOSER LOSER
		end
	end
end
--[[END OF SCRIPT]]