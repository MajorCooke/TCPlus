--bztcdw02 - Battlezone Total Command - Dogs of War - 2/15 - HIDDEN ENEMY
assert(load(assert(LoadFile("_requirefix.lua")),"_requirefix.lua"))();
TCC = require("TC_Core")
MisnNum = 30;
--DECLARE variables --p-path, f-friend, e-enemy, atk-attack, rcy-recycler
local index = 0
local indexadd = 0
local x = {
	FIRST = true,	
	spine = 0,	
	getiton = false, 
	MCAcheck = false, 
	player = nil, 
	mytank = nil, 
	skillsetting = 0, 
	audio1 = nil, 
	audio6 = nil, 
	waittime = 99999.9, 
	pos = {}, 
	casualty = 0, 
	camfov = 60,  --185 default
	userfov = 90,  --seed
	fnav = {}, 
	frcy = nil, 
	fscv = {}, 
	gotfscv = false, 
	fsct = {}, 
	gotfsct = false, 
	fgrp = {}, 
	eatk = {}, 
	eatklength = 0, 
	ecloakstate = 0, 
	camstate = 0, 
	failstate = 0, 
	failtime = 99999.9, 
	ambushstate = 0, 
	ambushpoint = 0, 
	frcydead = 0, 
	frcyhealthpercent = 0, 
	LAST = true
}
--PATHS: fpnav1, epatk(0-10), pscrap(0-60), fpretreat, epambush(0-4), fpbreakdown, eprckt(0-4), pkillzone

function InitialSetup()
	SetAutoGroupUnits(true)
	
	local odfpreload = {
		"kvscout", "kvmbike", "kvmisl", "kvtank", "kvrckt", "npscrx", "apcamrb"
	}
	for k,v in pairs(odfpreload) do
		PreloadODF(v)
	end
	
	x.frcy = GetHandle("frcy")
	x.mytank = GetHandle("mytank")
	for index = 1, 5 do
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
	index, indexadd, x, TCC.Save()
end

function Load(a, b, c, coreData)
	index = a;
	indexadd = b;
	x = c;
	TCC.Load(coreData)
end

function AddObject(h)
	if (GetRace(h) == "k") then 
		SetEjectRatio(h, 0.0);
	end
	
	if not x.gotfscv and IsOdf(h, "bvscav:1") then
		for indexadd = 1, 20 do
			if (x.fscv[indexadd] == nil or not IsAlive(x.fscv[indexadd])) and h ~= x.fscv[indexadd] then
				x.fscv[indexadd] = h
				break
			end
		end
	end
	
	if not x.gotsct and IsOdf(h, "bvscout:1") then
		for indexadd = 1, 20 do
			if (x.fsct[indexadd] == nil or not IsAlive(x.fsct[indexadd])) and h ~= x.fsct[indexadd] then
				x.fsct[indexadd] = h
				break
			end
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
		x.audio1 = AudioMessage("tcdw0201.wav") --Confirm Chinese with cloak. Est base quick.
		SetAsUser(x.mytank, 1)
		RemoveObject(x.player)
		x.player = GetPlayerHandle()
		SetSkill(x.fgrp[1], x.skillsetting)
		SetSkill(x.fgrp[2], x.skillsetting)
		SetSkill(x.fgrp[3], x.skillsetting)
		SetSkill(x.fgrp[4], x.skillsetting)
		for index = 1, 10 do --seed
			x.eatk[index] = nil
		end
		for index = 1, 60 do
			x.fnav[3] = BuildObject("npscrx", 0, "pscrap", index)
		end
		SetScrap(1, 40)
		x.spine = x.spine + 1
	end
	
	--SET INITIAL WAIT
	if x.spine == 1 and IsAudioMessageDone(x.audio1) then
		AddObjective("tcdw0201.txt")
		x.waittime = GetTime() + 60.0
		x.spine = x.spine + 1
	end
	
	--CRA SPAWN AND CLOAK 1
	if x.spine == 2 and x.waittime < GetTime() then
		x.eatk[1] = BuildObject("kvscout", 5, "epatk", 1)
		x.eatk[2] = BuildObject("kvscout", 5, "epatk", 2)
		x.eatk[3] = BuildObject("kvscout", 5, "epatk", 3)
		x.eatk[4] = BuildObject("kvscout", 5, "epatk", 4)
		x.eatk[5] = BuildObject("kvmbike", 5, "epatk", 1)
		x.eatk[6] = BuildObject("kvmbike", 5, "epatk", 3)
		x.eatk[7] = BuildObject("kvmbike", 5, "epatk", 2)
		x.eatk[8] = BuildObject("kvmbike", 5, "epatk", 4)
		x.eatk[9] = BuildObject("kvtank", 5, "epatk", 1)
		x.eatk[10] = BuildObject("kvtank", 5, "epatk", 3)
		x.eatklength = 10 --removed skill-based build
		for index = 1, x.eatklength do
			SetSkill(x.eatk[index], x.skillsetting)
			SetCommand(x.eatk[index], 47) --47 = CMD_MORPH_SETDEPLOYED // For morphtanks
		end
		x.waittime = GetTime() + 1.0
		x.spine = x.spine + 1
	end
	
	--CRA SEND OUT
	if x.spine == 3 and x.waittime < GetTime() then
		for index = 1, x.eatklength do
			Retreat(x.eatk[index], x.frcy)
		end
		x.waittime = GetTime() + 6.0
		x.spine = x.spine + 1
	end
	
	--START CAMERA 1
	if x.spine == 4 and x.waittime < GetTime() then
		x.camstate = 1
    x.userfov = IFace_GetInteger("options.graphics.defaultfov")
    CameraReady()
    IFace_SetInteger("options.graphics.defaultfov", x.camfov)
		x.waittime = GetTime() + 4.0
		x.spine = x.spine + 1
	end
	
	--CRA DECLOAK 1
	if x.spine == 5 and x.waittime < GetTime() then
		for index = 1, x.eatklength do
			SetCommand(x.eatk[index], 48) --48 = CMD_MORPH_SETUNDEPLOYED // For morphtanks
		end 
		x.waittime = GetTime() + 1.0
		x.spine = x.spine + 1
	end
	
	--CRA ATTACK INIT
	if x.spine == 6 and x.waittime < GetTime() then
		x.audio1 = AudioMessage("tcdw0202.wav") --Where come from. Multi CRA from SE and SW.
		x.gotfscv = true
		for index = 1, x.eatklength do
			if IsAlive(x.eatk[index]) then
				Attack(x.eatk[index], x.frcy)
			end
		end
		x.spine = x.spine + 1
	end
	
	--END CAMERA 1
	if x.spine == 7 and IsAudioMessageDone(x.audio1) then
		x.camstate = 0
    CameraFinish()
    IFace_SetInteger("options.graphics.defaultfov", x.userfov)
		x.waittime = GetTime() + 10.0
		x.spine = x.spine + 1
	end
	
	--SECOND ORDER
	if x.spine == 8 and x.waittime < GetTime() then
		ClearObjectives()
		AddObjective("tcdw0201.txt", "GREEN")
		AddObjective("	")
		AddObjective("tcdw0202.txt")
		x.spine = x.spine + 1
	end
	
	--IS CRA 1 DEAD
	if x.spine == 9 then
		for index = 1, x.eatklength do
			if not IsAlive(x.eatk[index]) or x.eatk[index] == nil then
				x.casualty = x.casualty + 1
			end
		end
		if x.casualty >= x.eatklength then
			x.waittime = GetTime() + 30.0
			x.spine = x.spine + 1
		elseif x.casualty < x.eatklength and x.waittime < GetTime() then
			x.waittime = GetTime() + 10.0
			for index = 1, 10 do 
				Attack(x.eatk[index], x.frcy)
			end
		end
		x.casualty = 0
	end
	
	--PAUSE BEFORE RETREAT TO BUILD FORCE
	if x.spine == 10 and x.waittime < GetTime() then
		x.waittime = GetTime() + 110.0
		x.spine = x.spine + 1
	end
	
	--CRA SPAWN CLOAK 2
	if x.spine == 11 and x.waittime < GetTime() then
		x.eatk[1] = BuildObject("kvscout", 5, "epatk", 6)
		x.eatk[2] = BuildObject("kvscout", 5, "epatk", 7)
		x.eatk[3] = BuildObject("kvmbike", 5, "epatk", 8)
		x.eatk[4] = BuildObject("kvmisl", 5, "epatk", 9)
		x.eatk[5] = BuildObject("kvtank", 5, "epatk", 10)
		x.eatklength = 5 --removed skill-based builds
		for index = 1, x.eatklength do
			SetSkill(x.eatk[index], x.skillsetting)
			SetCommand(x.eatk[index], 47) --47 = CMD_MORPH_SETDEPLOYED // For morphtanks
		end
		x.waittime = GetTime() + 1.0
		x.spine = x.spine + 1
	end
	
	--CRA SEND OUT 2
	if x.spine == 12 and x.waittime < GetTime() then
		for index = 1, x.eatklength do
			Retreat(x.eatk[index], x.frcy)
		end
		x.waittime = GetTime() + 4.0
		x.spine = x.spine + 1
	end
	
	--CAMERA 2 START AND SWAP FRCY
	if x.spine == 13 and x.waittime < GetTime() then
		AudioMessage("tcdw0204.wav") --We can't hold them off much longer.
		x.audio1 = AudioMessage("tcdw0205.wav") --LT. get out now. Save Recy. Rendezvous at Nav Alpha
		x.camstate = 1
    x.userfov = IFace_GetInteger("options.graphics.defaultfov")
    CameraReady()
    IFace_SetInteger("options.graphics.defaultfov", x.camfov)
		x.pos = GetTransform(x.frcy)
		RemoveObject(x.frcy)
		x.frcy = BuildObject("bvrecy", 1, x.pos)
		x.waittime = GetTime() + 3.0
		x.spine = x.spine + 1
	end
	
	--CRA DECLOAK 2
	if x.spine == 14 then
		for index = 1, x.eatklength do
			SetCommand(x.eatk[index], 48) --48 = CMD_MORPH_SETUNDEPLOYED // For morphtanks
		end
		x.waittime = GetTime() + 1.0
		x.gotfscv = true
		x.gotfsct = true 
		x.spine = x.spine + 1
	end
	
	--END CAMERA, SLIGHT PAUSE BEFORE RETREAT
	if x.spine == 15 and IsAudioMessageDone(x.audio1) then
		x.camstate = 0
    CameraFinish()
    IFace_SetInteger("options.graphics.defaultfov", x.userfov)
		x.waittime = GetTime() + 5.0
		x.spine = x.spine + 1
	end
	
	--RETREAT FRCY 
	if x.spine == 16 and x.waittime < GetTime() then
		Retreat(x.frcy, "fpretreat") --no 0 so player can't access
		ClearObjectives()
		AddObjective("tcdw0203.txt")
		AddObjective("\nSAVE", "DKGREY")
		SetObjectiveOn(x.frcy)
		x.fnav[1] = BuildObject("apcamrb", 1, "fpnav1")
		SetObjectiveName(x.fnav[1], "Extraction")
		SetObjectiveOn(x.fnav[1])
		for index = 1, x.eatklength do
			Attack(x.eatk[index], x.frcy)
		end
		x.ambushpoint = 1
		x.ambushstate = 1
		x.waittime = GetTime() + 3.0
		x.spine = x.spine + 1
	end
	
	--ASSIGN FOLLOWERS - no one gets left behind ... yet
	if x.spine == 17 and x.waittime < GetTime() then 
		if IsAlive(x.frcy) and GetCurHealth(x.frcy) < (GetMaxHealth(x.frcy) * 0.8) then
			SetCurHealth(x.frcy, (GetMaxHealth(x.frcy) * 0.8))
		end
		Follow(x.fgrp[3], x.frcy, 0)
		Follow(x.fgrp[4], x.frcy, 0)
		Follow(x.fgrp[5], x.frcy, 0)
		for index = 1, 20 do
			Follow(x.fscv[index], x.frcy, 0)
		end
		x.spine = x.spine + 1
	end
	
	--FRCY BREAKDOWN
	if x.spine == 18 and IsAlive(x.frcy) and GetDistance(x.frcy, "fpbreakdown") < 50 then
		AudioMessage("tcdw0206.wav") --Recy - propulsion down. Need backup.
		x.fnav[2] = BuildObject("stayput", 0, x.frcy)
		SetMaxHealth(x.fnav[2], 80000)
		SetCurHealth(x.fnav[2], 80000)
		for index = 1, 4 do
			x.eatk[index] = BuildObject("kvrckt", 5, "eprckt", index)
			x.eatk[index+4] = BuildObject("kvrckt", 5, "eprckt", index)
		end
		for index = 1, 8 do
			SetSkill(x.eatk[index], x.skillsetting)
			Defend(x.eatk[index])
			SetCommand(x.eatk[index], 47) --47 = CMD_MORPH_SETDEPLOYED // For morphtanks
		end
		x.waittime = GetTime() + 1.0
		x.spine = x.spine + 1
	end
	
	--CRA BOMBER SEND
	if x.spine == 19 and x.waittime < GetTime() then
		AudioMessage("tcdw0207.wav") --Bomber coming fast from East
		for index = 1, 8 do
			Retreat(x.eatk[index], x.frcy)
		end
		x.spine = x.spine + 1
	end
	
	--CRA RCKT DECLOAK
	if x.spine == 20 and IsAlive(x.frcy) and ((IsAlive(x.eatk[1]) and GetDistance(x.eatk[1], x.frcy) < 200) or (IsAlive(x.eatk[2]) and GetDistance(x.eatk[2], x.frcy) < 200) or (IsAlive(x.eatk[3]) and GetDistance(x.eatk[3], x.frcy) < 200)) then
		AudioMessage("tcdw0209.wav") --SUCCEED - Leave it, save yourself
		ClearObjectives()
		AddObjective("GET AWAY FROM THE RECYCLER, NOW!", "YELLOW")
		x.waittime = GetTime() + 6.0
		x.spine = x.spine + 1
	end
	
	--DECLOAK BOMBER FORCE
	if x.spine == 21 and x.waittime < GetTime() then
		for index = 1, 8 do
			SetCommand(x.eatk[index], 48) --48 = CMD_MORPH_SETUNDEPLOYED // For morphtanks
		end
		x.waittime = GetTime() + 2.0
		x.spine = x.spine + 1
	end
	
	--START RECY DEATH CAMERA
	if x.spine == 22 and x.waittime < GetTime() then
		x.camstate = 2
    x.userfov = IFace_GetInteger("options.graphics.defaultfov")
    CameraReady()
    IFace_SetInteger("options.graphics.defaultfov", x.camfov)
		x.waittime = GetTime() + 3.0
		x.spine = x.spine + 1
	end
	
	--START CRA FRCY ATTACK
	if x.spine == 23 and x.waittime < GetTime() then
		for index = 1, 8 do
			Attack(x.eatk[index], x.frcy)
		end
		for index = 1, 20 do
			if IsAlive(x.fsct[index]) and x.fsct[index] ~= x.player then
				Damage(x.fsct[index], (GetCurHealth(x.fsct[index]) * 0.99))
			end
			if IsAlive(x.fscv[index]) and x.fscv[index] ~= x.player then
				Damage(x.fscv[index], (GetCurHealth(x.fscv[index]) * 0.99))
			end
		end
		for index = 1, 5 do
			if IsAlive(x.fgrp[index]) and x.fgrp[index] ~= x.player then
				Damage(x.fgrp[index], (GetCurHealth(x.fgrp[index]) * 0.99))
			end
		end
		x.failstate = 111
    x.waittime = GetTime() + 15.0
		x.spine = x.spine + 1
	end
	
	--RECYCLER DESTROYED
	if x.spine == 24 and (not IsAlive(x.frcy) or x.waittime < GetTime()) then
    if IsAlive(x.frcy) then
      Damage(x.frcy, (GetCurHealth(x.frcy) + 100))
    end
		x.waittime = GetTime() + 2.0
		x.spine = x.spine + 1
	end
	
	--DID PLAYER ESCAPE (SUCCEED) OR NOT (FAIL)
	if x.spine == 25 and x.waittime < GetTime() then
		x.camstate = 0
    CameraFinish()
    IFace_SetInteger("options.graphics.defaultfov", x.userfov)
		RemoveObject(x.fnav[2])
		if IsAlive(x.player) and GetDistance(x.player, "fpbreakdown") > 120 then
			ClearObjectives()
			AddObjective("tcdw0204.txt", "GREEN")
			x.spine = x.spine + 1
		else
			SetEjectRatio(x.player, 0.0)
			Damage(x.player, 10000)
			FailMission(GetTime() + 2.0, "tcdw02f2.des") --LOSER LOSER LOSER
			x.spine = 666
			x.MCAcheck = true
		end
	end
	
	--SUCCEED MISSION
	if x.spine == 26 and x.waittime < GetTime() then
		SucceedMission(GetTime() + 4.0, "tcdw02w.des")
		x.spine = 666
	end
	----------END MAIN SPINE ----------
	
	--CAMERA 1 WATCH CRA ATTACK
	if x.camstate == 1 then --OBJ MUST BE 1-5, NOT HIGHER
		CameraObject(x.eatk[5], -20, 10, 60, x.eatk[5]) --was -20 10 60 [1]
	end
	
	--CAMERA 2 WATCH FRCY DIE
	if x.camstate == 2 and IsAlive(x.frcy) then
		CameraObject(x.fnav[2], -20, 40, 100, x.frcy)
	elseif x.camstate == 2 and not IsAlive(x.frcy) then
		CameraObject(x.fnav[2], -20, 40, 100, x.fnav[2])
	end
	
	--KEEP HOLDER ALIVE
	if IsAlive(x.fnav[2]) and GetCurHealth(x.fnav[2]) < 70000 then
		SetCurHealth(x.fnav[2], 80000)
	end
	
	--FRCY HEALTH STATUS
	if x.ambushstate > 0 and IsAlive(x.frcy) then
		x.frcyhealthpercent = math.floor((GetCurHealth(x.frcy) / GetMaxHealth(x.frcy)) * 100)
		SetObjectiveName(x.frcy, ("MUF status %d%%"):format(x.frcyhealthpercent))
	end
	
	--CRA AMBUSH FRCY
	if x.ambushstate == 1 and x.ambushpoint < 5 and GetDistance(x.frcy, "epambush", x.ambushpoint) < 410 then --AMBUSH START
		x.eatklength = 2
		--[[x.eatklength = 3
		if IsAlive(x.frcy) and GetCurHealth(x.frcy) <= math.floor(GetMaxHealth(x.frcy) * 0.7) then
			x.eatklength = 2
		elseif IsAlive(x.frcy) and GetCurHealth(x.frcy) <= math.floor(GetMaxHealth(x.frcy) * 0.2) then
			x.eatklength = 1
		end--]]
		for index = 1, x.eatklength do
			if x.ambushpoint == 1 then
				x.eatk[index] = BuildObject("kvscout", 5, "epambush", x.ambushpoint)
			elseif x.ambushpoint == 2 then
				x.eatk[index] = BuildObject("kvmbike", 5, "epambush", x.ambushpoint)
			elseif x.ambushpoint == 3 then
				x.eatk[index] = BuildObject("kvmisl", 5, "epambush", x.ambushpoint)
				GiveWeapon(x.eatk[index], "gfafma_c")
			elseif x.ambushpoint == 4 then
				x.eatk[index] = BuildObject("kvtank", 5, "epambush", x.ambushpoint)
			end
			SetSkill(x.eatk[index], x.skillsetting)
			SetCommand(x.eatk[index], 47) --47 = CMD_MORPH_SETDEPLOYED // For morphtanks
		end
		x.waittime = GetTime() + 1.0
		x.ambushstate = x.ambushstate + 1
	elseif x.ambushstate == 2 and x.waittime < GetTime() then --AMBUSH SEND
		for index = 1, x.eatklength do
			Retreat(x.eatk[index], x.frcy)
		end
		x.ambushstate = x.ambushstate + 1
	elseif x.ambushstate == 3 and IsAlive(x.eatk[1]) and IsAlive(x.frcy) and GetDistance(x.eatk[1], x.frcy) < 170 then --AMBUSH UNCLOAK
		for index = 1, x.eatklength do
			SetCommand(x.eatk[index], 48) --48 = CMD_MORPH_SETUNDEPLOYED // For morphtanks
		end
		x.waittime = GetTime() + 1.0
		x.ambushstate = x.ambushstate + 1
	elseif x.ambushstate == 4 and x.waittime < GetTime() then --AMBUSH ATTACK
		for index = 1, x.eatklength do 
			Attack(x.eatk[index], x.frcy)
		end
		x.ambushpoint = x.ambushpoint + 1 --set next location
		x.ambushstate = 1 --reset
	end

	--CHECK STATUS OF MISSION-CRITICAL ASSETS (MCA)
	if not x.MCAcheck then
		if x.failstate == 0 and not IsAlive(x.frcy) then --lost recycler
			x.audio6 = AudioMessage("tcdw0208.wav") --FAIL - lost recy
			ClearObjectives()
			AddObjective("tcdw0205.txt", "RED")
			x.spine = 666
			x.failstate = 10
		elseif x.failstate == 10 and IsAudioMessageDone(x.audio6) then
			x.MCAcheck = true
			FailMission(GetTime() + 1.0, "tcdw02f1.des") --LOSER LOSER LOSER
		end
	end
end
--[[END OF SCRIPT]]