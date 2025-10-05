--bztcdw01 - Battlezone Total Command - Dogs of War - 1/15 - CLOSE TARGET WRECKY
assert(load(assert(LoadFile("_requirefix.lua")),"_requirefix.lua"))();
TCC = require("TC_Core")
MisnNum = 29;
--DECLARE variables --p-path, f-friend, e-enemy, atk-attack, rcy-recycler
local index = 0
local index2 = 0
local indexadd = 0
local x = {
	FIRST = true,	
	spine = 0,	
	getiton = false, 
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
	camfov = 60,  --185 default
	userfov = 90,  --seed
	casualty = 0, 
	free_player = false, --dropship
	controls = {braccel = 0, strafe = 0, jump = 0, deploy = 0, eject = 0, abandon = 0, fire = 0}, 
	outofship = false, 
	fnav = {}, 
	frcy = nil, 
	fgrp = {}, 
	fdrp = {}, 
	fscv = {}, 
	eatk = {}, 
	eatklength = 0,	
	holder = {},
	camstate = 0, 
	failstate = 0, 
	failtime = 99999.9, 
	gotfscv = false, 
	LAST = true
}
--PATHS: fpnav1-2, epatk(0-10), pscrap

function InitialSetup()
	SetAutoGroupUnits(true)

	local odfpreload = {
		"bvrecydw01", "bvtank", "bvmbike", "kvscout", "kvmbike", "kvmisl", "kvtank", "npscrx", "stayput", "apcamrb"
	}
	for k,v in pairs(odfpreload) do
		PreloadODF(v)
	end
	
	x.fdrp[1] = GetHandle("fdrp1")
	x.fdrp[2] = GetHandle("fdrp2")
	x.frcy = GetHandle("frcy")
	x.mytank = GetHandle("mytank")
	for index = 1, 2 do
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
	if not x.gotfscv and IsOdf(h, "bvscav:1") then
		for indexadd = 1, 2 do
			if (x.fscv[indexadd] == nil or not IsAlive(x.fscv[indexadd])) and h ~= x.fscv[indexadd] then
				x.fscv[indexadd] = h
				break
			end
		end
	end
	TCC.AddObject(h);
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

function PreDamage(curWorld, h, DamageType, pContext, value, base, armor, shield, owner, source, SelfDamage, FriendlyFireDamage)
	return TCC.PreDamage(curWorld, h, DamageType, pContext, value, base, armor, shield, owner, source, SelfDamage, FriendlyFireDamage);
end

function Update()
	x.player = GetPlayerHandle() --EVERY PASS SO IF PLAYER CHANGES VEHICLES
	x.skillsetting = IFace_GetInteger("options.play.difficulty")
	TCC.Update();
	--START THE MISSION BASICS
	if x.spine == 0 then
		x.pos = GetTransform(x.mytank)
		RemoveObject(x.mytank)
		x.mytank = BuildObject("bvtank", 1, x.pos)
		SetAsUser(x.mytank, 1)
		RemoveObject(x.player)
		x.player = GetPlayerHandle()
		x.pos = GetTransform(x.fgrp[1])
		RemoveObject(x.fgrp[1])
		x.fgrp[1] = BuildObject("bvmbike", 1, x.pos)
		SetGroup(x.fgrp[1], 0)
		x.pos = GetTransform(x.fgrp[2])
		RemoveObject(x.fgrp[2])
		x.fgrp[2] = BuildObject("bvmbike", 1, x.pos)
		SetGroup(x.fgrp[2], 0)
		x.pos = GetTransform(x.fgrp[3])
		x.pos = GetTransform(x.frcy)
		RemoveObject(x.frcy)
		x.frcy = BuildObject("bvrecydw01", 1, x.pos)
		for index = 1, 10 do --seed
			x.eatk[index] = nil
		end
		SetSkill(x.fgrp[1], x.skillsetting)
		Stop(x.fgrp[1], 0)
		SetSkill(x.fgrp[2], x.skillsetting)
		Stop(x.fgrp[2], 0)
		SetSkill(x.fgrp[3], x.skillsetting)
		Stop(x.fgrp[3], 0)
		SetSkill(x.fgrp[4], x.skillsetting)
		Stop(x.fgrp[4], 0)
		Stop(x.frcy, 0)
		x.camstate = 1
    x.userfov = IFace_GetInteger("options.graphics.defaultfov")
    CameraReady()
    IFace_SetInteger("options.graphics.defaultfov", x.camfov)
		x.spine = x.spine + 1
	end

	--DROPSHIP LANDING SEQUENCE - START QUAKE FOR FLYING EFFECT
	if x.spine == 1 then
		for index = 1, 2 do
			for index2 = 1, 10 do
				StopEmitter(x.fdrp[index], index2)
			end
		end
		x.holder[1] = BuildObject("stayput", 0, x.player) --fdrp1 dropship 1
		x.holder[2] = BuildObject("stayput", 0, x.frcy) --fdrp2 dropship 2
		x.holder[3] = BuildObject("stayput", 0, x.fgrp[1]) --fdrp1 dropship 1
		x.holder[4] = BuildObject("stayput", 0, x.fgrp[2]) --fdrp1 dropship 1
		x.holder[5] = BuildObject("stayput", 0, x.fgrp[3]) --fdrp1 dropship 1
		x.holder[6] = BuildObject("stayput", 0, x.fgrp[4]) --fdrp1 dropship 1
		x.waittime = GetTime() + 3.0
		x.spine = x.spine + 1
	end

	--OPEN DROPSHIP DOORS, REMOVE HOLDERS
	if x.spine == 2 and x.waittime < GetTime() then
		StartSoundEffect("dropdoor.wav")
		SetAnimation(x.fdrp[1], "open", 1)
		SetAnimation(x.fdrp[2], "open", 1)
		RemoveObject(x.holder[2])
		RemoveObject(x.holder[3])
		RemoveObject(x.holder[4])
		RemoveObject(x.holder[5])
		RemoveObject(x.holder[6])
		x.waittime = GetTime() + 5.0
		x.spine = x.spine + 1
	end

	--HOLD INPUTS UNTIL DOORS ARE FULLY OPEN
	if x.spine == 3 and x.waittime < GetTime() then
		Goto(x.frcy, "fprcy", 0)
		Goto(x.fgrp[1], "fpgrp1", 0)
		Goto(x.fgrp[2], "fpgrp2", 0)
		Goto(x.fgrp[3], "fpgrp1", 0)
		Goto(x.fgrp[4], "fpgrp2", 0)
		x.waittime = GetTime() + 5.0
		x.spine = x.spine + 1
	end
	
	--GIVE 1ST AUDIO
	if x.spine == 4 and x.waittime < GetTime() then
		x.audio1 = AudioMessage("tcdw0101.wav") --build base send out recon patrol suspect Russians
		x.spine = x.spine + 1
	end

	--GIVE player CONTROL OF THEIR AVATAR
	if x.spine == 5 and IsAudioMessageDone(x.audio1) then
		x.camstate = 0
    CameraFinish()
    IFace_SetInteger("options.graphics.defaultfov", x.userfov)
		SetColorFade(6.0, 0.5, "BLACK")
		SetScrap(1, 40)
		RemoveObject(x.holder[1])
		x.fnav[1] = BuildObject("apcamrb", 1, "fpnav1")
		SetObjectiveName(x.fnav[1], "Deploy Area")
		x.free_player = true
		for index = 1, 30 do --40 do
			x.fnav[3] = BuildObject("npscrx", 0, "pscrap30", index) --"pscrap40"
		end
		x.spine = x.spine + 1
	end

	--CHECK IF PLAYER HAS LEFT DROPSHIP
	if x.spine == 6 then
		x.player = GetPlayerHandle()
		if IsCraftButNotPerson(x.player) and GetDistance(x.player, x.fdrp[1]) > 64 then
			ClearObjectives()
			AddObjective("tcdw0101.txt")
			x.spine = x.spine + 1
		end
	end

	--DROPSHIP 1 TAKEOFF
	if x.spine == 7 then
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
		SetAnimation(x.fdrp[2], "takeoff", 1)
		StartSoundEffect("dropleav.wav", x.fdrp[2])
		x.waittime = GetTime() + 15.0
		x.spine = x.spine + 1
	end

	--REMOVE DROPSHIPS
	if x.spine == 9 and x.waittime < GetTime() then
		RemoveObject(x.fdrp[1])
		RemoveObject(x.fdrp[2])
		if x.skillsetting == x.easy then
			x.failtime = GetTime() + 60.0
		elseif x.skillsetting == x.medium then
			x.failtime = GetTime() + 50.0
		else
			x.failtime = GetTime() + 40.0
		end
		x.failstate = 1
		x.spine = x.spine + 1
	end

	--IS RECYCLER DEPLOYED
	if x.spine == 10 and IsAlive(x.frcy) and IsOdf(x.frcy, "bbrecydw01") then
		x.failtime = 99999.9
		x.failstate = 0
		if x.audio6 ~= nil and not IsAudioMessageDone(x.audio6) then
			StopAudioMessage(x.audio6) --stop warning if playing
		end
		ClearObjectives()
		AddObjective("tcdw0101.txt", "GREEN")
		AddObjective("	")
		AddObjective("tcdw0102.txt")
		if x.skillsetting == x.easy then
			x.waittime = GetTime() + 130.0
		elseif x.skillsetting == x.medium then
			x.waittime = GetTime() + 120.0
		else
			x.waittime = GetTime() + 110.0
		end
		x.spine = x.spine + 1
	end

	--ORDER TO NAV CAM, CRA SPAWN AND CLOAK
	if x.spine == 11 and x.waittime < GetTime() then
		x.audio1 = AudioMessage("tcdw0102.wav") --HQ do you copy. Getting readings. Nav dropped - investigate
		x.fnav[2] = BuildObject("apcamrb", 1, "fpnav2")
		SetObjectiveName(x.fnav[2], "INVESTIGATE")
		SetObjectiveOn(x.fnav[2])
		x.eatk[1] = BuildObject("kvscout", 5, "epatk", 1) --removed difficulty sizing
		x.eatk[2] = BuildObject("kvscout", 5, "epatk", 2)
		x.eatk[3] = BuildObject("kvscout", 5, "epatk", 3)
		x.eatk[4] = BuildObject("kvscout", 5, "epatk", 4)
		x.eatk[5] = BuildObject("kvscout", 5, "epatk", 1)
		x.eatklength = 5
		for index = 1, x.eatklength do
			SetSkill(x.eatk[index], x.skillsetting)
			SetCommand(x.eatk[index], 47) --47 = CMD_MORPH_SETDEPLOYED // For morphtanks
		end
		x.spine = x.spine + 1
	end

	--GIVE NAV OBJECTIVE
	if x.spine == 12 and IsAudioMessageDone(x.audio1) then
		ClearObjectives()
		AddObjective("tcdw0102.txt", "GREEN")
		AddObjective("	")
		AddObjective("tcdw0103.txt")
		x.failstate = 3
		if x.skillsetting == x.easy then
			x.failtime = GetTime() + 60.0
		elseif x.skillsetting == x.medium then
			x.failtime = GetTime() + 55.0
		else
			x.failtime = GetTime() + 45.0
		end
		x.spine = x.spine + 1
	end

	--CRA SEND OUT
	if x.spine == 13 and IsAlive(x.player) and GetDistance(x.player, "fpnav2") <= 300 then
		for index = 1, x.eatklength do
			Retreat(x.eatk[index], "fpnav2")
		end
		x.spine = x.spine + 1
	end
	
	--PLAYER AT NAV, BEGIN CAMERA 2
	if x.spine == 14 and IsAlive(x.player) and GetDistance(x.player, "fpnav2") <= 200 then
		if x.audio6 ~= nil and not IsAudioMessageDone(x.audio6) then
			StopAudioMessage(x.audio6) --stop warning if playing
		end
		x.camstate = 2
    x.userfov = IFace_GetInteger("options.graphics.defaultfov")
    CameraReady()
    IFace_SetInteger("options.graphics.defaultfov", x.camfov)
		x.failtime = 99999.9
		x.failstate = 0
		ClearObjectives()
		AddObjective("tcdw0103.txt", "GREEN")
		SetObjectiveOff(x.fnav[2])
		x.spine = x.spine + 1
	end

	--CRA DECLOAK
	if x.spine == 15 then
		for index = 1, x.eatklength do
			if GetDistance(x.eatk[index], "fpnav2") < 150 then
				for index2 = 1, x.eatklength do
					SetCommand(x.eatk[index2], 48) --48 = CMD_MORPH_SETUNDEPLOYED // For morphtanks
				end
				x.waittime = GetTime() + 1.0
				x.spine = x.spine + 1
				break
			end
		end
	end

	--CRA ATTACK INIT
	if x.spine == 16 and x.waittime < GetTime() then
		x.audio1 = AudioMessage("tcdw0103.wav") --What hell. Where they from. Get back and defend recy.
		x.gotfscv = true
		
		Attack(x.eatk[1], x.player)
		
		if IsAlive(x.eatk[2]) and IsAlive(x.fscv[1]) then
			Attack(x.eatk[2], x.fscv[1])
		elseif IsAlive(x.eatk[2]) and IsAlive(x.fscv[2]) then
			Attack(x.eatk[2], x.fscv[2])
		else
			Attack(x.eatk[2], x.player)
		end
		
		if IsAlive(x.eatk[3]) and IsAlive(x.fscv[2]) then
			Attack(x.eatk[3], x.fscv[2])
		elseif IsAlive(x.eatk[3]) and IsAlive(x.fgrp[1]) then
			Attack(x.eatk[3], x.fgrp[1])
		else
			Attack(x.eatk[3], x.player)
		end
		
		if IsAlive(x.eatk[4]) and IsAlive(x.fgrp[2]) then
			Attack(x.eatk[4], x.fgrp[2])
		elseif IsAlive(x.eatk[4]) and IsAlive(x.fscv[2]) then
			Attack(x.eatk[4], x.fscv[2])
		else
			Attack(x.eatk[4], x.player)
		end
		
		if IsAlive(x.eatk[5]) and IsAlive(x.fgrp[1]) then
			Attack(x.eatk[5], x.fgrp[1])
		elseif IsAlive(x.eatk[5]) and IsAlive(x.fgrp[2]) then
			Attack(x.eatk[5], x.fgrp[2])
		else
			Attack(x.eatk[5], x.player)
		end
		x.spine = x.spine + 1
	end

	--LET PLAYER FIGHT
	if x.spine == 17 and (IsAudioMessageDone(x.audio1) or x.camstate == 0) then
		x.camstate = 0
    CameraFinish()
    IFace_SetInteger("options.graphics.defaultfov", x.userfov)
		ClearObjectives()
		AddObjective("tcdw0104.txt")
		if x.skillsetting == x.easy then
			x.waittime = GetTime() + 50.0
		elseif x.skillsetting == x.medium then
			x.waittime = GetTime() + 40.0
		else
			x.waittime = GetTime() + 30.0
		end
		x.spine = x.spine + 1
	end
	
	--CRA SPAWN AND CLOAK 2
	if x.spine == 18 and x.waittime < GetTime() then
		for index = 1, x.eatklength do
			Attack(x.eatk[index], x.frcy)
		end
		x.eatk[6] = BuildObject("kvscout", 5, "epatk", 6) --removed difficulty sizing
		x.eatk[7] = BuildObject("kvscout", 5, "epatk", 8)
		x.eatk[8] = BuildObject("kvscout", 5, "epatk", 10)
		x.eatk[9] = BuildObject("kvscout", 5, "epatk", 7)
		x.eatk[10] = BuildObject("kvscout", 5, "epatk", 9)
		x.eatk[11] = BuildObject("kvtank", 5, "epatk", 11)
		x.eatk[12] = BuildObject("kvtank", 5, "epatk", 12)
		x.eatk[13] = BuildObject("kvtank", 5, "epatk", 13)
		x.eatklength = 8
		for index = 1, x.eatklength do
			SetSkill(x.eatk[index+5], x.skillsetting)
			SetCommand(x.eatk[index+5], 47) --47 = CMD_MORPH_SETDEPLOYED // For morphtanks
		end
		x.waittime = GetTime() + 1.0
		x.spine = x.spine + 1
	end
	
	--CRA SEND OUT 2
	if x.spine == 19 and x.waittime < GetTime() then
		for index = 1, x.eatklength do
			Retreat(x.eatk[index+5], x.frcy)
		end
		x.spine = x.spine + 1
	end
	
	--CRA DECLOAK 2
	if x.spine == 20 then
		for index = 6, (5 + x.eatklength) do
			if IsAlive(x.eatk[index]) and IsAlive(x.frcy) and GetDistance(x.eatk[index], x.frcy) < 150 then
				for index2 = 6, (5 + x.eatklength) do
					SetCommand(x.eatk[index2], 48) --48 = CMD_MORPH_SETUNDEPLOYED // For morphtanks
				end
				x.waittime = GetTime() + 1.0
				x.spine = x.spine + 1
				break
			end
		end
	end
	
	--CRA ATTACK 2
	if x.spine == 21 and x.waittime < GetTime() then
		for index = 1, 12 do --12 max ai units
			if IsAlive(x.eatk[index]) then
				Attack(x.eatk[index], x.frcy)
			end
		end
		x.spine = x.spine + 1
	end
	
	--CRA CHECK DEAD
	if x.spine == 22 then
		for index = 1, 12 do --12 max ai units
			if not IsAlive(x.eatk[index]) or x.eatk[index] == nil then
				x.casualty = x.casualty + 1
			end
		end
		if x.casualty >= 12 then --12 max ai units
			x.MCAcheck = true
			x.waittime = GetTime() + 2.0
			x.spine = x.spine + 1
		end
		x.casualty = 0
	end

	--VICTORY TOUR
	if x.spine == 23 and x.waittime < GetTime() then
		x.audio1 = AudioMessage("tcdw0104.wav") --SUCCEED - Cmd says pull out
		ClearObjectives()
		AddObjective("tcdw0105.txt", "GREEN")
		x.spine = x.spine + 1
	end
	
	--SUCCEED MISSION
	if x.spine == 24 and IsAudioMessageDone(x.audio1) then
		TCC.SucceedMission(GetTime() + 1.0, "tcdw01w.des")
		x.spine = 666
	end
	----------END MAIN SPINE ----------

	--ENSURE player CAN'T DO ANYTHING WHILE IN DROPSHIP
	if not x.free_player then
		x.controls = {braccel = 0, strafe = 0, jump = 0, deploy = 0, eject = 0, abandon = 0, fire = 0}
		SetControls(x.player, x.controls)
	end
	
	--CAMERA 1 WATCH RECYCLER
	if x.camstate == 1 then
		CameraObject(x.frcy, -40, 20, 120, x.frcy)
	end
	
	--CAMERA 2 WATCH EATK1
	if x.camstate == 2 and (IsAlive(x.eatk[1]) or (GetCurHealth(x.player) > math.floor(GetMaxHealth(x.player) * 0.8))) then
		CameraObject(x.eatk[1], -20, 10, 60, x.eatk[1])
	elseif x.camstate == 2 and (not IsAlive(x.eatk[1]) or (GetCurHealth(x.player) <= math.floor(GetMaxHealth(x.player) * 0.5))) then
		x.camstate = 0
    CameraFinish()
    IFace_SetInteger("options.graphics.defaultfov", x.userfov)
	end

	--CHECK STATUS OF MISSION-CRITICAL ASSETS (MCA)
	if not x.MCAcheck then
		if not IsAlive(x.frcy) then --lost recycler
			AudioMessage("tcdw0105.wav") --5.6 FAIL - lost recy
			ClearObjectives()
			AddObjective("tcdw0106.txt", "RED")
			TCC.FailMission(GetTime() + 7.0, "tcdw01f1.des") --LOSER LOSER LOSER
			x.spine = 666
			x.MCAcheck = true
		end
		
		if x.failstate == 1 and x.failtime < GetTime() then --didn't deploy recy in time
			x.audio6 = AudioMessage("tcdw0108.wav") --Why haven't you deployed recycler
			if x.skillsetting == x.easy then
				x.failtime = GetTime() + 65.0
			elseif x.skillsetting == x.medium then
				x.failtime = GetTime() + 55.0
			else
				x.failtime = GetTime() + 45.0
			end
			x.failstate = 2
		elseif x.failstate == 2 and x.failtime < GetTime() then
			AudioMessage("tcdw0109.wav") --FAIL - fail to deploy recy??
			ClearObjectives()
			AddObjective("tcdw0101.txt", "RED")
			AddObjective("\n\nMISSION FAILED!", "RED")
			TCC.FailMission(GetTime() + 11.0, "tcdw01f2.des")
			x.spine = 666
			x.MCAcheck = true
		end
		
		if x.failstate == 3 and x.failtime < GetTime() then --didn't investigate in time
			x.audio6 = AudioMessage("tcdw0106.wav") --I wasn't clear. Go investigate nav now!
			if x.skillsetting == x.easy then
				x.failtime = GetTime() + 75.0
			elseif x.skillsetting == x.medium then
				x.failtime = GetTime() + 60.0
			else
				x.failtime = GetTime() + 45.0
			end
			x.failstate = 4
		elseif x.failstate == 4 and x.failtime < GetTime() then
			x.audio6 = AudioMessage("tcdw0107.wav") --FAIL - fail to investigate nav
			ClearObjectives()
			AddObjective("tcdw0103.txt", "RED")
			AddObjective("\n\nMISSION FAILED!", "RED")
			TCC.FailMission(GetTime() + 11.0, "tcdw01f3.des")
			x.spine = 666
			x.MCAcheck = true
		end 
	end
end
--[[END OF SCRIPT]]