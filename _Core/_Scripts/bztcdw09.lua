--bztcdw09 - Battlezone Total Command - Dogs of War - 9/15 - GRAND THEFT PORTAL
assert(load(assert(LoadFile("_requirefix.lua")),"_requirefix.lua"))();
TCC = require("TC_Core")
MisnNum = 41;
local index = 0
local index2 = 0
local indexadd = 0
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
	fnav = {},	
	randompick = 0, 
	randomlast = 0,
	playerstate = 0, 
	casualty = 0, 
	fgrp = {}, 
	epatstate = {0, 0, 0, 0}, 
	epattime = 99999.9, 
	eatk = {}, 
	eatkstate = {}, 
	eatktime = {},
	epat = {}, 
	etur = {}, 
	esrv = {}, 
	eprt = nil, 
	egrd = {}, 
	gotdummy = false,	 --portal dummies
	gotdummy2 = false, 
	dummy = nil, 
	dummy2 = nil, 
	dummypos = {}, 
	dummypos2 = {}, 
	controls = {braccel = 0, strafe = 0, jump = 0, deploy = 0, eject = 0, abandon = 0, fire = 0},	 
	yetistate = 0, 
	failstate = 0, 
	bigtime = 99999.9, 
	zonelength = 0, --set in attack section
	LAST = true
}
--PATHS: safespace, ppatrol, eptur, zonearea1-8, pz11-13, pz21-23, ... pz81-83

function InitialSetup()
	SetAutoGroupUnits(true)
	
	local odfpreload = {
		"kvscout", "kvmbike", "kvmisl", "kvtank", "kvhtnk", "kvwalk", "kvturr", "bvwalk", "apcamrb" 
	} 
	for k,v in pairs(odfpreload) do
		PreloadODF(v)
	end
		
	x.mytank = GetHandle("mytank")
	x.eprt = GetHandle("eprt")
	x.egun1 = GetHandle("egun1")
	x.egun2 = GetHandle("egun2")
	for index = 1, 5 do --1-4 ai yeti, 5 player yeti
		x.epat[index] = GetHandle(("epat%d"):format(index))
	end
	for index = 1, 4 do
		x.egrd[index] = GetHandle(("egrd%d"):format(index))
	end
	Ally(1, 4)
	Ally(5, 4)
	Ally(4, 1) --4 portal allied to both
	Ally(4, 5)
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
	--get aperture dummy00
	if not x.gotdummy and IsOdf(h, "dummy00") then
		x.dummy = h
		x.dummypos = GetTransform(h)
		x.gotdummy = true
	end
	
	--get ramp dummyprtl
	if not x.gotdummy2 and IsOdf(h, "dummyprtl") then
		x.dummy2 = h
		x.dummypos2 = GetTransform(h)
		x.gotdummy2 = true
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
	--[[used once to make player bspilo, then snipe kvapc, and occupy so can be bspilo while start in kvapc
	if x.spine == 0 then
		x.player = GetPlayerHandle()
		x.fgrp[1] = BuildObject("bvscav", 1, x.player) --editor remove scav after hopout
		SetAsUser(x.fgrp[1], 1)
		RemoveObject(x.player)
		x.player = GetPlayerHandle()
		x.spine = 1
	end--]]
	x.player = GetPlayerHandle() --EVERY PASS SO IF PLAYER CHANGES VEHICLES
	x.skillsetting = IFace_GetInteger("options.play.difficulty")
	TCC.Update();
	--START THE MISSION BASICS
	if x.spine == 0 then
		x.audio1 = AudioMessage("tcdw0901.wav") --Radio silence until portal. On own until portal
		for index = 1, 5 do --1-4 ai yeti, 5 player yeti
			x.epat[index] = GetHandle(("epat%d"):format(index))
			x.pos = GetTransform(x.epat[index])
			RemoveObject(x.epat[index])
			x.epat[index] = BuildObject("kvtank", 0, x.pos)
			SetCanSnipe(x.epat[index], 0)
		end
		for index = 1, 10 do
			x.etur[index] = BuildObject("kvturr", 5, "eptur", index)
		end
		for index = 1, 56, 2 do --just do half
			x.esrv[index] = BuildObject("apservk", 0, "epsrv", index)
		end
		RemovePilot(x.epat[5])
		x.spine = x.spine + 1
	end
	
	--FIRST OBJECTIVE
	if x.spine == 1 and IsAudioMessageDone(x.audio1) then
		ClearObjectives()
		AddObjective("tcdw0901.txt")
		SetObjectiveName(x.epat[5], "Steal Yeti Tank")
		SetObjectiveOn(x.epat[5])
		if x.skillsetting > x.easy then
			GiveWeapon(x.epat[5], "gshdwa_c")
		end
		SetMaxAmmo(x.epat[5], (GetMaxAmmo(x.epat[5]) * 1.2))
		SetCurAmmo(x.epat[5], (GetMaxAmmo(x.epat[5]) * 1.2))
		x.spine = x.spine + 1	
	end
	
	--PLAYER AT TANK
	if x.spine == 2 and IsAlive(x.player) and IsAround(x.epat[5]) and GetDistance(x.player, x.epat[5]) <= 32 then
		ClearObjectives()
		AddObjective("tcdw0901.txt", "GREEN")
		AddObjective("	")
		AddObjective("tcdw0902.txt")
		x.waittime = GetTime() + 5.0
		x.spine = x.spine + 1
	end
	
	--ORDER PLAYER TO UNLOAD (HOPOUT)
	if x.spine == 3 and x.waittime < GetTime() then
		AudioMessage("tcdw0902.wav") --CRA - APC Alpha you may unload.
		ClearObjectives()
		AddObjective("tcdw0902.txt", "GREEN")
		AddObjective("	")
		AddObjective("tcdw0903.txt")
		x.playerstate = 1
		x.waittime = GetTime() + 20.0
		x.spine = x.spine + 1
	end
	
	--PLAYER IS YETI TANK
	if x.spine == 4 and IsAlive(x.player) and IsOdf(x.player, "kvtank") then
		x.playerstate = 2
		for index = 1, 4 do --return snipability
			TCC.SetTeamNum(x.epat[index], 5)
			SetCanSnipe(x.epat[index], 1)
		end
		SetObjectiveOff(x.epat[5])
		ClearObjectives()
		AddObjective("tcdw0903.txt", "GREEN")
		x.waittime = GetTime() + 3.0
		AudioMessage("alertpulse.wav") --alarm SFX
		AddObjective("\n\n>> HQ Pilot ID invalid. Cloak disabled. <<", "LAVACOLOR")
		x.spine = x.spine + 1
	end
	
	--PATROL ORDER TO 1
	if x.spine == 5 and x.waittime < GetTime() then
		for index = 1, 4 do
			if x.epatstate[index] == 0 then
				Patrol(x.epat[index], "ppatrol")
				x.waittime = GetTime() + 2.0
				x.casualty = x.casualty + 1
				if x.casualty == 1 then
					AudioMessage("tcdw0903.wav") --CRA - Squad Bravo proceed to beacon 1 Delta
					ClearObjectives()
					AddObjective("tcdw0904.txt")
					AddObjective("\n\n>> HQ Pilot ID invalid. Cloak disabled. <<", "LAVACOLOR")
					x.fnav[1] = BuildObject("apcamrk", 1, "ppatrol", 2)
					SetObjectiveName(x.fnav[1], "1 Delta")
					SetObjectiveOn(x.fnav[1])
				end
				if x.casualty == 4 then
					x.spine = x.spine + 1
					x.casualty = 0
				end
				x.epatstate[index] = 1
				break
			end
		end
	end
	
	--PATROL ORDER TO 2
	if x.spine == 6 then
		for index = 1, 4 do
			if IsAlive(x.epat[index]) and GetDistance(x.epat[index], "ppatrol", 2) < 20 then
				AudioMessage("tcdw0904.wav") --CRA - Proceed to beacon 2 Delta
				RemoveObject(x.fnav[1])
				x.fnav[2] = BuildObject("apcamrk", 1, "ppatrol", 5)
				SetObjectiveName(x.fnav[2], "2 Delta")
				SetObjectiveOn(x.fnav[2])
				x.spine = x.spine + 1
				break
			end
		end
	end
	
	--PATROL ORDER TO 3
	if x.spine == 7 then
		for index = 1, 4 do
			if IsAlive(x.epat[index]) and GetDistance(x.epat[index], "ppatrol", 5) < 20 then
				AudioMessage("tcdw0905.wav") --5s CRA - Proceed to beacon 3 Delta
				RemoveObject(x.fnav[2])
				x.fnav[3] = BuildObject("apcamrk", 1, "ppatrol", 9)
				SetObjectiveName(x.fnav[3], "3 Delta")
				SetObjectiveOn(x.fnav[3])
				x.waittime = GetTime() + 10.0
				x.spine = x.spine + 1
				break
			end
		end
	end
	
	--ORDERED OUTSIDE OF PATROL PATH
	if x.spine == 8 and x.waittime < GetTime() then
		AudioMessage("tcdw0906.wav") --Damn wrong path. Get to portal now sir.
		ClearObjectives()
		AddObjective("tcdw0905.txt")
		AddObjective("SAVE", "DKGREY")
		SetObjectiveOff(x.fnav[3])
		SetObjectiveOn(x.eprt)
		TCC.SetTeamNum(x.eprt, 4)
		x.spine = x.spine + 1
	end
	
	--AI ATTACK SETUP
	if x.spine == 9 and IsAlive(x.epat[5]) and not IsInsideArea("safespace", x.epat[5]) then
		AudioMessage("tcdw0907.wav") --18s CRA - You have strayed from path. ... All units ... destroy him.
		AddObjective("	")
		AddObjective("tcdw0906.txt", "YELLOW")
		RemoveObject(x.fnav[3])
		x.playerstate = 3
		for index = 1, 8 do --8 zones
			x.eatkstate[index] = 0
			x.eatktime[index] = GetTime()
			x.eatk[index] = {} --"rows"
			for index2 = 1, 4 do --4 max ai per zone
				x.eatk[index][index2] = nil --"columns", init (handle in this case)
			end
		end
    if x.skillsetting == x.easy then  --hope this doesn't make it too easy
      SetMaxHealth(x.epat[5], (GetMaxHealth(x.epat[5]) * 1.25))
      SetCurHealth(x.epat[5], GetMaxHealth(x.epat[5]))
    elseif x.skillsetting == x.medium then
      SetMaxHealth(x.epat[5], (GetMaxHealth(x.epat[5]) * 1.5))
      SetCurHealth(x.epat[5], GetMaxHealth(x.epat[5]))
    elseif x.skillsetting >= x.hard then
      SetMaxHealth(x.epat[5], (GetMaxHealth(x.epat[5]) * 1.75))
      SetCurHealth(x.epat[5], GetMaxHealth(x.epat[5]))
    end
		x.waittime = GetTime() + 10.0
		x.spine = x.spine + 1
	end

	--MARK PLAYER AS ENEMY
	if x.spine == 10 and x.waittime < GetTime() then
		SetPerceivedTeam(x.player, 1)
		for index = 1, 4 do
			SetSkill(x.epat[index], 0) --quanity not quality
			SetSkill(x.egrd[index], 0) --quanity not quality
			x.epatstate[index] = 0 --reset
		end
		x.yetistate = 1 --spaced attacks
		AddObjective("\n\nHURRY, CRA shutting down portal.", "DKRED") --Portal will be shutdown soon.", "DKRED")
		--[[if x.skillsetting == x.easy then
			x.bigtime = GetTime() + 210.0
			StartCockpitTimer(210, 120, 60)
		elseif x.skillsetting == x.medium then
			x.bigtime = GetTime() + 240.0
			StartCockpitTimer(240, 120, 60)
		elseif x.skillsetting >= x.hard then
			x.bigtime = GetTime() + 300.0
			StartCockpitTimer(300, 120, 60)
		end--]]
    x.bigtime = GetTime() + 240.0
    StartCockpitTimer(240, 120, 60)
		x.spine = x.spine + 1
	end
	
	--PLAYER NEAR PORTAL
	if x.spine == 11 and IsAlive(x.epat[5]) and ((IsAlive(x.egun1) and GetDistance(x.epat[5], x.egun1) < 300) or (IsAlive(x.egun2) and GetDistance(x.epat[5], x.egun2) < 300)) then
		AudioMessage("tcdw0908.wav") --Go through portal and get back to HQ asap.
		ClearObjectives()
		AddObjective("Go through portal and get back to HQ asap.")
		x.spine = x.spine + 1
	end
	
	--SUPPORT WALKER 1
	if x.spine == 12 and IsAlive(x.epat[5]) and ((IsAlive(x.egun1) and GetDistance(x.epat[5], x.egun1) < 200) or (IsAlive(x.egun2) and GetDistance(x.epat[5], x.egun2) < 200)) then
		StartSoundEffect("portalx.wav", x.dummy)
		x.fgrp[1] = BuildObject("bvwalk", 1, x.dummypos)
		SetVelocity(x.fgrp[1], (SetVector(50.0, 0.0, 0.0))) --setvector is xyz world, ought be xyz handle
		Attack(x.fgrp[1], x.egun1, 0)
		x.spine = x.spine + 1
	end
	
	--SUPPORT WALKER 2
	if x.spine == 13 and IsAlive(x.epat[5]) and ((IsAlive(x.egun1) and GetDistance(x.epat[5], x.egun1) < 170) or (IsAlive(x.egun2) and GetDistance(x.epat[5], x.egun2) < 170)) then
		StartSoundEffect("portalx.wav", x.dummy)  
		x.fgrp[2] = BuildObject("bvwalk", 1, x.dummypos)
		SetVelocity(x.fgrp[2], (SetVector(50.0, 0.0, 0.0))) --setvector is xyz world, ought be xyz handle
		Attack(x.fgrp[2], x.egun2, 0)
		x.spine = x.spine + 1
	end
	
	--TURN OFF OBJECTIVE HIGHLIGHTS
	if x.spine == 14 and GetDistance(x.epat[5], x.eprt) < 100 then
		SetObjectiveOff(x.eprt)
		for index = 1, 4 do 
			SetObjectiveOff(x.epat[index])
		end
		for index = 1, 8 do
			for index2 = 1, 2 do
				SetObjectiveOff(x.eatk[index][index2])
			end
		end
		x.spine = x.spine + 1
	end
	
	--START THE VICTORY TOUR
	if x.spine == 15 and x.bigtime > GetTime() and IsAround(x.epat[5]) and IsOdf(x.player, "kvtank") and GetDistance(x.epat[5], x.dummy2) < 5 then
		x.bigtime = 99999.9
		StopCockpitTimer()
		HideCockpitTimer()
		StartSoundEffect("portalx.wav")
		x.controls = {braccel = 0, strafe = 0, jump = 0, deploy = 0, eject = 0, abandon = 0, fire = 0}
		SetControls(x.player, x.controls)
		ClearThrust(x.player)
		SetCurHealth(x.player, 30000)
		SetColorFade(20.0, 0.1, "WHITE")
		ClearObjectives()
		AddObjective("tcdw0905.txt", "GREEN")
		AddObjective("\n\nMISSION COMPLETE", "GREEN")
		AudioMessage("win.wav") --whoohoo
		x.waittime = GetTime() + 3.0
		x.MCAcheck = true
		x.spine = x.spine + 1
	end

	--MISSION SUCCESS
	if x.spine == 16 and x.waittime < GetTime() then
		TCC.SucceedMission(GetTime(), "tcdw09w.des") --WINNER WINNER WINNER
		x.spine = 666
	end
	----------END MAIN SPINE ----------
	
	--CLOAK DISABLED FOR ALL PLAYER VEHICLES
	if x.playerstate > 1 and not IsOdf(x.player, "bspilo") then --playerstate so player can undeploy init apc
		x.controls = {deploy = 0}
		SetControls(x.player, x.controls)
	end
	
	--YETI PATROL GROUP
	if x.yetistate == 0 and x.playerstate < 3 then
		for index = 1, 4 do
			if IsAlive(x.epat[index]) and GetWhoShotMe(x.epat[index]) == x.player then
				for index2 = 1, 4 do
					if IsAlive(x.epat[index2]) and GetTeamNum(x.epat[index2]) == 0 then
						TCC.SetTeamNum(x.epat[index2], 5)
					end
					Attack(x.epat[index2], x.player)
				end
				x.yetistate = 2
				break
			end
		end
	elseif x.yetistate == 1 then
		for index = 1, 4 do
			if x.epatstate[index] == 0 and x.waittime < GetTime() then
				Attack(x.epat[index], x.player)
				SetObjectiveOn(x.epat[index])
				x.waittime = GetTime() + 15.0
				if x.skillsetting == x.medium then
					x.waittime = GetTime() + 25.0
				elseif x.skillsetting >= x.hard then
					x.waittime = GetTime() + 30.0
				end
				x.casualty = x.casualty + 1
				if x.casualty == 4 then
					x.yetistate = 2
					x.casualty = 0
				end
				x.epatstate[index] = 1
				break
			end
		end
	end
	
	--KEEP PEGASUS ALIVE
	if GetCurHealth(x.eprt) < GetMaxHealth(x.eprt) then
		SetCurHealth(x.eprt, GetMaxHealth(x.eprt))
	end
	
	--A1 ZONE ATTACKS
	if x.playerstate == 3 then
		x.zonelength = 2 --removed diff based size
		for index = 1, 8 do
			if x.eatkstate[index] == 0 and x.eatktime[index] < GetTime() and not IsAlive(x.eatk[index][index2]) and IsInsideArea(("zonearea%d"):format(index), x.player) then
				for index2 = 1, x.zonelength do
					while x.randompick == x.randomlast do --random the random
						x.randompick = math.floor(GetRandomFloat(1.0, 15.0))
					end
					x.randomlast = x.randompick
					if x.randompick == 1 or x.randompick == 5 or x.randompick == 8 or x.randompick == 11 or x.randompick == 13 or x.randompick == 14 or x.randompick == 15 then --7
						x.eatk[index][index2] = BuildObject("kvscout", 5, ("pz%d%d"):format(index, index2))
					elseif x.randompick == 2 or x.randompick == 6 or x.randompick == 9 or x.randompick == 12 then  --4
						x.eatk[index][index2] = BuildObject("kvmbike", 5, ("pz%d%d"):format(index, index2))
						SetWeaponMask(x.eatk[index][index2], 00001) --too tough with sandbags
					elseif x.randompick == 3 or x.randompick == 7 or x.randompick == 10 then  --3
						x.eatk[index][index2] = BuildObject("kvmisl", 5, ("pz%d%d"):format(index, index2))
						SetWeaponMask(x.eatk[index][index2], 00011)
					else  --1
						x.eatk[index][index2] = BuildObject("kvhtnk", 5, ("pz%d%d"):format(index, index2))
					end --REMOVED WALKER
					SetSkill(x.eatk[index][index2], x.skillsetting)
					if x.skillsetting > x.easy and index2 % 2 == 0 then
						SetSkill(x.eatk[index][index2], (x.skillsetting-1))
					end
					--SetObjectiveOn(x.eatk[index][index2])
					Attack(x.eatk[index][index2], x.player)
					x.eatkstate[index] = 1
				end
			end
			
			if x.eatkstate[index] == 1 and not IsInsideArea(("zonearea%d"):format(index), x.player) then
				for index2 = 1, x.zonelength do
					if not IsAlive(x.eatk[index][index2]) then
						x.casualty = x.casualty + 1
					end
				end
				if x.casualty == x.zonelength then
					x.eatktime[index] = GetTime() + 120.0
					x.eatkstate[index] = 0
				end
				x.casualty = 0
			end
		end
	end
	
	--CHECK STATUS OF MCA 
	if not x.MCAcheck then
		--player is pilot at wrong time or apc destroyed too soon
		if x.failstate == 0 and ((IsOdf(x.player, "bspilo") and (x.playerstate == 0 or x.playerstate == 2)) or (x.playerstate < 3 and not IsAround(x.mytank))) then
			for index = 1, 4 do
				TCC.SetTeamNum(x.epat[index], 5)
				Attack(x.epat[index], x.player)
			end
			ClearObjectives()
			AddObjective("You've been discovered by the Chinese.", "RED")
			x.failstate = 1
		end
		
		--YETI epat[5] DESTROYED
		if x.failstate == 0 and IsAlive(x.player) and not IsAround(x.epat[5]) then
			ClearObjectives()
			AddObjective("Yeti destroyed.", "RED")
			x.failstate = 1
		end
		
		--BIG FAIL TIME
		if x.failstate == 0 and x.bigtime < GetTime() then
			StopEmitter(x.eprt, 1) --"shutdown" portal
			StopEmitter(x.eprt, 2)
			ClearObjectives()
			AddObjective("The Chinese have shutdown the portal. You're trapped.", "RED")
			x.failstate = 1
		end
		
		if x.failstate == 1 then --FAIL MISSION
			AudioMessage("tcdw0909.wav") --8s FAIL - wrld of hurt- modified from a dw06
			AddObjective("\n\nMISSION FAILED!", "RED")
			TCC.FailMission(GetTime() + 8.0, "tcdw09f1.des") --LOSER LOSER LOSER
			x.MCAcheck = true
			x.spine = 666
		end
	end
end
--[[END OF SCRIPT]]