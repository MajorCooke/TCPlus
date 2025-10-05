--bztcdw10 - Battlezone Total Command - Dogs of War - 10/15 - THE ENEMY WITHIN
assert(load(assert(LoadFile("_requirefix.lua")),"_requirefix.lua"))();
TCC = require("TC_Core")
MisnNum = 43;
local index = 0
local index2 = 0
local index3 = 0
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
	randompick = 0, 
	randomlast = 0,
	playerstate = 0, 
	casualty = 0, 
	failstate = 0, 
	fgrp = {}, 
	fgrplength = 20, 
	fsct = {}, 
	fsrv = {}, 
	locationpick = {}, --cra base location
	eatk = {}, --cra attack
	eatklength = 0, --6 avail
	eatkstate = {},	
	eatktrgt = {}, 
	eatkuncloak = {}, 
	ercy = {}, --recy and objective stuff
	ercykillcount = 0, 
	ercystate = {}, 
	ercyping = 0, 
	egun1 = {}, --cra bases
	egun2 = {}, 
	egun3 = {}, 
	egun4 = {}, 
	epwr1 = {}, 
	epwr2 = {}, 
	etur1 = {}, 
	etur2 = {}, 
	etur3 = {}, 
	etur4 = {}, 
	ewlk = {}, 
	ewlk2 = {}, 
	easn1 = {},	 --asn stuff
	easn2 = {}, 
	easnstate = {}, 
	eprt = nil, --end cutscene
	eprtpos = {}, 
	frcy = nil, --end cutscene
	frcypos = {}, 
	etnk = {}, --end cutscene
	etnkpos = {}, 
	cracount = 0, 
	--bigtime = 99999.9, 
	LAST = true
}

--PATHS: eprcy1-20, epgun1_1-20, epgun2_1-20, epgun3_1-20, epgun4_1-20, eppwr1_1-20, eppwr2_1-20, eptur1_1-20, eptur2_1-20, eptur3_1-20, eptur4_1-20, epatk1-20(0-6), epwlk1-20, pmytank, prcyrun, NO LONGER USED>> fpgrp(0-50), fpsct(0-4), fpsrv(0-6),

function InitialSetup()
	SetAutoGroupUnits(true)
		
	local odfpreload = {
		"kbrecy", "kbfact", "kbpgen2", "kbgtow", "kbshld", "kvscout", "kvmbike", "kvmisl", "kvtank", "kvrckt", "kvhtnk", "kvserv", 
		"kvwalk", "kvturr", "kbprtl", "bvrecy", "bvtank", "bvstnk", "bvserv", "gstbra_c", "gmdmga", "gpopg1a", "apcamrb"
	}
	for k,v in pairs(odfpreload) do
		PreloadODF(v)
	end
	
	x.frcy = GetHandle("frcy")
	x.eprt = GetHandle("eprt")
	for index = 1, 41 do
		x.fgrp[index] = GetHandle(("fgrp%d"):format(index))
	end
	for index = 1, 6 do
		x.fsrv[index] = GetHandle(("fsrv%d"):format(index))
	end
	for index = 1, 4 do
		x.fsct[index] = GetHandle(("fsct%d"):format(index))
	end
	for index = 1, 6 do --portal tanks
		x.etnk[index] = GetHandle(("etnk%d"):format(index))
	end
	for index = 3, 8 do
		Ally(index, 3)
		Ally(index, 4)
		Ally(index, 5)
		Ally(index, 6)
		Ally(index, 7)
		Ally(index, 8)
	end
	SetColorFade(6.0, 0.5, "BLACK")
	TCC.Init();
end--initial setup END

function Start()
	TCC.Start();
end
function Save()
	return
	index, index2, index3, x, TCC.Save()
end

function Load(a, b, c, d, coreData)
	index = a;
	index2 = b;
	index3 = c;
	x = d;
	TCC.Load(coreData)
end

function AddObject(h)
	if (IsAlive(h) or IsPlayer(h)) then
		ReplaceStabber(h);
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

function PreDamage(curWorld, h, DamageType, pContext, value, base, armor, shield, owner, source, SelfDamage, FriendlyFireDamage)
	return TCC.PreDamage(curWorld, h, DamageType, pContext, value, base, armor, shield, owner, source, SelfDamage, FriendlyFireDamage);
end

function Update()
	x.player = GetPlayerHandle() --EVERY PASS SO IF PLAYER CHANGES VEHICLES
	x.skillsetting = IFace_GetInteger("options.play.difficulty")
	TCC.Update();
	--START THE MISSION BASICS
	if x.spine == 0 then
		x.audio1 = AudioMessage("tcdw1000.wav") --00 REMOVED "forwarded location" --We need to destroy 6 key buildings. Kick some A
		AddObjective("tcdw1002.txt")
		x.pos = GetTransform(x.fgrp[41])
		RemoveObject(x.fgrp[41])
		x.fgrp[41] = BuildObject("bvtank", 1, x.pos)
		SetLabel(x.fgrp[41], "fgrp41")
		GiveWeapon(x.fgrp[41], "gstbra_c")
		GiveWeapon(x.fgrp[41], "gpopg1a")
		SetAsUser(x.fgrp[41], 1) --41 is player, NOT MYTANK
		RemoveObject(x.player)
		x.player = GetPlayerHandle()
		x.eprtpos = GetTransform(x.eprt)
		RemoveObject(x.eprt)
		x.frcypos = GetTransform(x.frcy)
		RemoveObject(x.frcy)
		for index = 1, 6 do --portal tanks
			x.etnkpos[index] = {}
			x.etnkpos[index] = GetTransform(x.etnk[index])
			RemoveObject(x.etnk[index])
		end
		for index = 1, 10 do
			SetSkill(x.fgrp[index], 2)
			GiveWeapon(x.fgrp[index], "gstbra_c")
			GiveWeapon(x.fgrp[index], "gpopg1a")
		end
		for index = 11, 20 do
			SetSkill(x.fgrp[index], 2)
		end
		x.fgrplength = 20
		if x.skillsetting == x.easy then --less tanks to make a little challenging
			for index = 11, x.fgrplength do
				RemoveObject(x.fgrp[index])
			end
			x.fgrplength = 10
		elseif x.skillsetting == x.medium then
			for index = 16, x.fgrplength do
				RemoveObject(x.fgrp[index])
			end
			x.fgrplength = 15
		end
		for index = 3, 8 do
			x.easnstate[index] = 0
		end
		x.waittime = GetTime() + 7.0
		x.spine = x.spine + 1
		--x.spine = 4 --TEST END CAMERA
	end
	
	--BUILD ENEMY BASES
	if x.spine == 1 and x.waittime < GetTime() then
		for index = 1, 8 do --do full 1-8 here
			x.locationpick[index] = 0
			x.ercystate[index] = 0
			x.eatk[index] = {}
			x.eatkstate[index] = 0
			x.eatktrgt[index] = nil 
			x.eatkuncloak[index] = 0
		end
		
	--Pick locations -There's probably a better way to do this, but I'm too lazy to find it AND try to understand it, and I ain't a programmer. This works, so deal.
		while x.locationpick[3] == 0 or x.locationpick[4] == 0 or x.locationpick[5] == 0 
			or x.locationpick[6] == 0 or x.locationpick[7] == 0 or x.locationpick[8] == 0 do
			x.randompick = math.floor(GetRandomFloat(1.0, 18.0)) --19, 20 avail, but too close to start pt
			for index = 3, 8 do --3-8 is team number
				if x.locationpick[index] == 0 then 
					if x.randompick ~= x.locationpick[3] and x.randompick ~= x.locationpick[4] and x.randompick ~= x.locationpick[5] 
					and x.randompick ~= x.locationpick[6] and x.randompick ~= x.locationpick[7] and x.randompick ~= x.locationpick[8] then
						x.locationpick[index] = x.randompick
					end
				end 
			end
		end
		
		for index = 3, 8 do --Build each base
			if index % 2 == 0 then
				x.ercy[index] = BuildObject("kbfact", index, ("eprcy%d"):format(x.locationpick[index]))
				SetLabel(x.ercy[index], ("Factory %d"):format(index))
			else
				x.ercy[index] = BuildObject("kbrecy", index, ("eprcy%d"):format(x.locationpick[index]))
				SetLabel(x.ercy[index], ("Recycler %d"):format(index))
			end
			x.egun1[index] = BuildObject("kbgtow", index, ("epgun1_%d"):format(x.locationpick[index]))
			x.egun2[index] = BuildObject("kbgtow", index, ("epgun2_%d"):format(x.locationpick[index]))
			x.epwr1[index] = BuildObject("kbpgen2", index, ("eppwr1_%d"):format(x.locationpick[index]))
			x.etur1[index] = BuildObject("kvturr", index, ("eptur1_%d"):format(x.locationpick[index]))
			x.etur2[index] = BuildObject("kvturr", index, ("eptur2_%d"):format(x.locationpick[index]))
			x.easn1[index] = BuildObject("kvtank", index, ("eptur3_%d"):format(x.locationpick[index])) --use unused turr path
			x.easn2[index] = BuildObject("kvtank", index, ("eptur4_%d"):format(x.locationpick[index])) --use unused turr path
			SetCommand(x.easn1[index], 47)
			SetCommand(x.easn2[index], 47)
			
			x.eatklength = 6
			for index2 = 1, x.eatklength do --Build units for each base
				while x.randompick == x.randomlast do --random the random
					x.randompick = math.floor(GetRandomFloat(1.0, 18.0))
				end
				x.randomlast = x.randompick
				if x.randompick == 1 or x.randompick == 7 or x.randompick == 12 or x.randompick == 17 then
					x.eatk[index][index2] = BuildObject("kvscout", index, ("epatk%d"):format(x.locationpick[index]), index2)
				elseif x.randompick == 2 or x.randompick == 8 or x.randompick == 13 or x.randompick == 18 then
					x.eatk[index][index2] = BuildObject("kvmbike", index, ("epatk%d"):format(x.locationpick[index]), index2)
				elseif x.randompick == 3 or x.randompick == 9 or x.randompick == 14 then
					x.eatk[index][index2] = BuildObject("kvmisl", index, ("epatk%d"):format(x.locationpick[index]), index2)
				elseif x.randompick == 4	or x.randompick == 10 or x.randompick == 15 then
					x.eatk[index][index2] = BuildObject("kvtank", index, ("epatk%d"):format(x.locationpick[index]), index2)
				elseif x.randompick == 5 or x.randompick == 11 or x.randompick == 16 then
					x.eatk[index][index2] = BuildObject("kvrckt", index, ("epatk%d"):format(x.locationpick[index]), index2)
				else
					x.eatk[index][index2] = BuildObject("kvhtnk", index, ("epatk%d"):format(x.locationpick[index]), index2)
				end
				--set skill later in case player changes difficulty
				SetCommand(x.eatk[index][index2], 47)  
			end
			x.ewlk[index] = BuildObject("kvwalk", index, ("epwlk%d"):format(x.locationpick[index])) --skill set later
			--x.ewlk2[index] = BuildObject("kvwalk", index, ("eppwr2_%d"):format(x.locationpick[index])) --at pwr 2
		end
		x.spine = x.spine + 1
	end
	
	--ACTIVATE OBJECTIVE COUNTER AFTER PAUSE
	if x.spine == 2 and x.waittime < GetTime() then
		x.ercyping = 1 --init
		--x.bigtime = GetTime() + 2700.0
		--StartCockpitTimer(2700, 600, 300)
		x.spine = x.spine + 1
	end
	
	--CRA DEAD
	if x.spine == 3 and x.ercykillcount >= 6 then
		--StopCockpitTimer()
		--HideCockpitTimer()
		x.bigtime = 99999.9
		x.MCAcheck = true
		GetPlayerHandle(x.player)
		SetCurHealth(x.player, 100000)
		x.MCAcheck = true
		x.waittime = GetTime() + 2.0
		x.spine = x.spine + 1
	end
	
	--GIVE RTB MESSAGE
	if x.spine == 4 and x.waittime < GetTime() then
		x.audio1 = AudioMessage("tcdw1002.wav") --Get to dropzone. I'm reading a lot of Chinese activity.
		x.spine = x.spine + 1
	end
	
	--CAM SETUP
	if x.spine == 5 and IsAudioMessageDone(x.audio1) then
		x.frcy = BuildObject("bvrecy", 2, x.frcypos)
		SetCurHealth(x.frcy, 100000)
		x.eprt = BuildObject("kbprtl", 0, x.eprtpos)
		for index = 1, 6 do
			x.etnk[index] = BuildObject("kvtank", 0, x.etnkpos[index])
		end
		for index = 2, 6 do
			SetCommand(x.etnk[index], 47)
		end
		x.waittime = GetTime() + 2.0
		x.spine = x.spine + 1
	end
	
	--CAM 1 AND BEGIN
	if x.spine == 6 and x.waittime < GetTime() then
		ClearObjectives() --for camera
		Goto(x.frcy, "prcyrun")
		TCC.SetTeamNum(x.etnk[1], 5)
		Attack(x.etnk[1], x.frcy)
		x.camstate = 1
    x.userfov = IFace_GetInteger("options.graphics.defaultfov")
    CameraReady()
    IFace_SetInteger("options.graphics.defaultfov", x.camfov)
		SetPosition(x.player, "pmytank") --move player out of harm
		SetCurHealth(x.player, 30000)
		x.waittime = GetTime() + 4.0
		x.spine = x.spine + 1
	end
	
	--CAM 2 SWITCH
	if x.spine == 7 and x.waittime < GetTime() then
		x.camstate = 2
		x.spine = x.spine + 1
	end
	
	--CAM 3 SWITCH AND STOP FRCY AT PORTAL
	if x.spine == 8 and GetDistance(x.frcy, "prcyrun") < 30 then
		Stop(x.frcy)
		Stop(x.etnk[1])
		TCC.SetTeamNum(x.etnk[1], 0)
		TCC.SetTeamNum(x.frcy, 0)
		x.waittime = GetTime() + 2.0
		x.camstate = 3
		x.spine = x.spine + 1
	end
	 
	--CRA AT PORTAL UNCLOAK
	if x.spine == 9 and x.waittime < GetTime() then
		for index = 2, 6 do
			SetCommand(x.etnk[index], 48)
		end
		x.waittime = GetTime() + 1.0
		x.spine = x.spine + 1
	end
	 
	--CRA LOOK AT FRCY
	if x.spine == 10 and x.waittime < GetTime() then
		for index = 2, 6 do
			LookAt(x.etnk[index], x.frcy)
		end
		x.waittime = GetTime() + 5.0
		x.spine = x.spine + 1
	end
	
	--FINAL MESSAGE
	if x.spine == 11 and x.waittime < GetTime() then
		x.audio1 = AudioMessage("tcdw1003.wav") --SUCCEED - Scrub order Lt. Recy has been captured by the Chinese
		x.spine = x.spine + 1
	end

	--MISSION SUCCESS
	if x.spine == 12 and IsAudioMessageDone(x.audio1) then
    CameraFinish()
    IFace_SetInteger("options.graphics.defaultfov", x.userfov)
		TCC.SucceedMission(GetTime() + 1.0, "tcdw10w.des") --WINNER WINNER WINNER
		x.spine = 666
	end
	----------END MAIN SPINE ----------

	--UPDATE THE OBJECTIVES
	if x.ercykillcount < 6 then
		for index = 3, 8 do
			if x.ercystate[index] == 0 and not IsAround(x.ercy[index]) then
				x.ercystate[index] = 1
				x.ercyping = 1
				StartSoundEffect("emdotcox.wav")
				x.ercykillcount = x.ercykillcount + 1
			end
		end
		if x.ercyping == 1 then
			ClearObjectives()
			if x.ercykillcount < 6 then
				AddObjective("tcdw1001.txt", "WHITE", 1.0)
			else
				AddObjective("tcdw1001.txt", "GREEN", 1.0)
			end
			if x.ercystate[3] == 1 then 
				AddObjective("Recycler 1", "GREEN", 1.0) 
			else
				AddObjective("Recycler 1", "WHITE", 1.0)
			end
			if x.ercystate[5] == 1 then
				AddObjective("Recycler 2", "GREEN", 1.0) 
			else
				AddObjective("Recycler 2", "WHITE", 1.0)
			end
			if x.ercystate[7] == 1 then
				AddObjective("Recycler 3", "GREEN", 1.0) 
			else
				AddObjective("Recycler 3", "WHITE", 1.0)
			end
			if x.ercystate[4] == 1 then
				AddObjective("Factory 1", "GREEN", 1.0) 
			else
				AddObjective("Factory 1", "WHITE", 1.0)
			end
			if x.ercystate[6] == 1 then
				AddObjective("Factory 2", "GREEN", 1.0) 
			else
				AddObjective("Factory 2", "WHITE", 1.0)
			end
			if x.ercystate[8] == 1 then 
				AddObjective("Factory 3", "GREEN", 1.0) 
			else
				AddObjective("Factory 3", "WHITE", 1.0)
			end
			if x.ercykillcount == 6 then
				AddObjective("\n\nMISSION COMPLETE.", "GREEN", 1.0)
				x.MCAcheck = true
			end
			x.ercyping = 0
		end
	end
	
	--AI ATTACKS
	for index = 3, 8 do
		if x.eatkstate[index] == 0 and IsAlive(x.ercy[index])then --fgrp in range of cra
			for index2 = 1, x.fgrplength do
				if IsAround(x.fgrp[index2]) and x.fgrp[index2] ~= x.player 
				and ((GetDistance(x.fgrp[index2], x.ercy[index]) < 100 or GetDistance(x.player, x.ercy[index]) < 100) 
				or (GetCurHealth(x.ercy[index]) < (GetMaxHealth(x.ercy[index]) * 0.8))) then
					SetSkill(x.ewlk[index], x.skillsetting) --here if difficulty changed
				--SetSkill(x.ewlk2[index], x.skillsetting) --here if difficulty changed
					for index3 = 1, x.eatklength do
						SetSkill(x.eatk[index][index3], x.skillsetting) --here if difficulty changed
						SetCommand(x.eatk[index][index3], 48)
					end
					x.eatkstate[index] = x.eatkstate[index] + 1
					break
				end
			end
		end
	end
	
	--AI ASSASSIN
	for index = 3, 8 do
		if x.easnstate[index] == 0 and not IsAlive(x.epwr1[index]) then
			SetSkill(x.easn1[index], x.skillsetting)
			Retreat(x.easn1[index], x.player)
			SetSkill(x.easn2[index], x.skillsetting)
			Retreat(x.easn2[index], x.player)
			x.easnstate[index] = x.easnstate[index] + 1
		elseif x.easnstate[index] == 1 and (GetDistance(x.easn1[index], x.player) < 150 or GetDistance(x.easn2[index], x.player) < 150) then
			SetCommand(x.easn1[index], 48)
			SetCommand(x.easn2[index], 48)
			x.easnstate[index] = x.easnstate[index] + 1
		elseif x.easnstate[index] == 2 then
			Attack(x.easn1[index], x.player)
			Attack(x.easn2[index], x.player)
			x.easnstate[index] = x.easnstate[index] + 1
		end
	end
	
	--CAMERA 1-3
	if x.camstate == 1 then
		CameraObject(x.frcy, -30, 10, 80, x.etnk[1])
	elseif x.camstate == 2 then
		CameraObject(x.etnk[1], 15, 5, -30, x.eprt)
	elseif x.camstate == 3 then
		CameraObject(x.frcy, 0, 40, -80, x.etnk[4])
	end
	
	--CHECK STATUS OF MCA 
	if not x.MCAcheck then
		if x.failstate == 0 and x.spine > 1 then
			for index = 3, 8 do
				if not IsAlive(x.ercy[index]) then
					x.cracount = x.cracount + 1
				end
			end
			for index = 1, x.fgrplength do
				if not IsAround(x.fgrp[index]) then --IsAround not IsAlive
					x.casualty = x.casualty + 1
				end
			end
			if x.cracount <= 3 and x.casualty > math.floor(x.fgrplength * 0.7) then
				x.audio6 = AudioMessage("tcdw0806.wav") --REUSE --FAIL - wasting resources -lost Recy(?)
				ClearObjectives()
				AddObjective("Too many wingman lost to continue.\n\nMISSION FAILED!", "RED")
				x.failstate = 1
			end
			x.cracount = 0
			x.casualty = 0
		end
		
		if x.failstate == 0 and x.spine > 1 then --lost all combat
			for index = 3, 8 do
				if not IsAlive(x.ercy[index]) then
					x.cracount = x.cracount + 1
				end
			end
			for index = 1, x.fgrplength do 
				if not IsAround(x.fgrp[index]) then --IsAround not IsAlive
					x.casualty = x.casualty + 1
				end
			end
			if x.cracount < 5 and x.casualty >= math.floor(x.fgrplength * 0.9) then
				x.audio6 = AudioMessage("tcdw0806.wav") --REUSE --FAIL - wasting resources -lost Recy(?)
				ClearObjectives()
				AddObjective("Too many wingman lost to continue.\n\nMISSION FAILED!", "RED")
				x.failstate = 1
			end
			x.cracount = 0
			x.casualty = 0
		end
		
		--[[if x.failstate == 0 and x.spine > 2 and x.bigtime < GetTime() then --lost all combat
			x.audio6 = AudioMessage("alertpulse.wav")
			ClearObjectives()
			AddObjective("CRA reinforcements incoming.\n\nMISSION FAILED!", "RED")
			x.failstate = 1
		end--]]
		
		if x.failstate == 1 and IsAudioMessageDone(x.audio6) then
			TCC.FailMission(GetTime(), "tcdw10f1.des") --LOSER LOSER LOSER
			x.MCAcheck = true
			x.spine = 666
		end
	end
end
--[[END OF SCRIPT]]