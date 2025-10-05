--bztcrb04 - Battlezone Total Command - The Red Brigade - 4/8 - IO'S BRIDGE
assert(load(assert(LoadFile("_requirefix.lua")),"_requirefix.lua"))();
TCC = require("TC_Core")
MisnNum = 31;
--DECLARE variables --f-friend, e-enemy, atk-attack, rcy-recycler, etc..., 
local index = 1
local indexadd = 1
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
	audio1 = nil, 
	atbridge = 0, 
	ftug = {}, --ally tug stuff 
	ftugstart = false, 
	ftugcount = 0, 
	ftugtime = 99999.9,	
	ftugstate = {},
	ftughome = 0, 
	ftugtotal = 5, 
	frel = {}, --relics
	frelstate = {}, 
	frelcaptured = {},
	freldeadcount = 0, 
	etug = {}, --enemy tugs
	etugstate = {}, 
	etugtime = {}, 
	etugfollowing = {},
	erelcount = 0, 
	frcy = nil,	 --player units
	ffac = nil, 
	farm = nil, 
	fcon = nil,
	fgrp = {},
	ercy = nil, --ai buildings
	efac = nil,
	etur = {}, 
	eart = {}, 
	epattime = 99999.9, --patrols
	epatlength = 8, 
	epat = {}, 
	epatcool = {}, 
	epatallow = {},
	bridgetoofar = false, 
	LAST = true
}
--Paths: eptur1-10, epart1-6, pdef1-pdef8, fptug, fphome, pbridge1-2, ephome1-5, pintercept

function InitialSetup()
	SetAutoGroupUnits(true)
	
	local odfpreload = {
		"svrecyrb04", "svfactrb04", "svarmorb04", "svconsrb04", "svscout", "svtank", "svtug", "svscav", 
		"avscout", "avmbike", "avmisl", "avtank", "avrckt", "avturr", "avartl", "avtug", 
		"fryrelic01", "fryrelic02", "fryrelic03", "fryrelic04", "fryrelic05", "apstbsa", "apcamrs"
	}
	for k,v in pairs(odfpreload) do
		PreloadODF(v)
	end
	
	x.mytank = GetHandle("mytank")
	x.ercy = GetHandle("ercy")
	x.efac = GetHandle("efac")
	x.frcy = GetHandle("frcy")
	x.ffac = GetHandle("ffac")
	x.farm = GetHandle("farm")
	x.fcon = GetHandle("fcon")
	for index = 1, 10 do
		x.fgrp[index] = GetHandle(("fgrp%d"):format(index))
	end
	Ally(1, 4)
	Ally(4, 1) --4 ally tugs
	Ally(1, 3)
	Ally(3, 1) --3 fury relic
	Ally(5, 3)
	Ally(3, 5)
	SetTeamColor(4, 50, 100, 150) --blue
	SetColorFade(6.0, 0.5, "BLACK")
	TCC.Init()
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
	TCC.Update()
	
	--SET UP MISSION BASICS
	if x.spine == 0 then
		x.pos = GetTransform(x.mytank)
		RemoveObject(x.mytank)
		x.mytank = BuildObject("svtank", 1, x.pos)
		SetAsUser(x.mytank, 1)
		RemoveObject(x.player)
		x.player = GetPlayerHandle()
		GiveWeapon(x.mytank, "gstbsa_c")
		x.pos = GetTransform(x.fgrp[1])
		RemoveObject(x.fgrp[1])
		x.fgrp[1] = BuildObject("svscout", 1, x.pos)
		SetGroup(x.fgrp[1], 0)
		x.pos = GetTransform(x.fgrp[2])
		RemoveObject(x.fgrp[2])
		x.fgrp[2] = BuildObject("svscout", 1, x.pos)
		SetGroup(x.fgrp[2], 0)
		x.pos = GetTransform(x.fgrp[3])
		RemoveObject(x.fgrp[3])
		x.fgrp[3] = BuildObject("svscout", 1, x.pos)
		SetGroup(x.fgrp[3], 0)
		x.pos = GetTransform(x.fgrp[4])
		RemoveObject(x.fgrp[4])
		x.fgrp[4] = BuildObject("svtank", 1, x.pos)
		x.pos = GetTransform(x.fgrp[5])
		RemoveObject(x.fgrp[5])
		x.fgrp[5] = BuildObject("svtank", 1, x.pos)
		x.pos = GetTransform(x.fgrp[6])
		RemoveObject(x.fgrp[6])
		x.fgrp[6] = BuildObject("svtank", 1, x.pos)
		for index = 4, 6 do
			GiveWeapon(x.fgrp[index], "gstbsa_c")
			SetGroup(x.fgrp[index], 1)
		end
		x.pos = GetTransform(x.frcy)
		RemoveObject(x.frcy)
		x.frcy = BuildObject("svrecyrb04", 1, x.pos) --if bldg flip abdummy
		x.pos = GetTransform(x.ffac)
		RemoveObject(x.ffac)
		x.ffac = BuildObject("svfactrb04", 1, x.pos) --if bldg flip abdummy
		x.pos = GetTransform(x.farm)
		RemoveObject(x.farm)
		x.farm = BuildObject("svarmorb04", 1, x.pos) --if bldg flip abdummy
		x.pos = GetTransform(x.fgrp[7])
		RemoveObject(x.fgrp[7])
		if x.skillsetting >= x.medium then
			x.fgrp[7] = BuildObject("svtug", 1, x.pos)
			SetGroup(x.fgrp[7], 5)
		end
		x.pos = GetTransform(x.fgrp[8])
		RemoveObject(x.fgrp[8])
		if x.skillsetting >= x.hard then
			x.fgrp[8] = BuildObject("svtug", 1, x.pos)
			SetGroup(x.fgrp[8], 5)
		end
		x.pos = GetTransform(x.fgrp[9])
		RemoveObject(x.fgrp[9])
		x.fgrp[9] = BuildObject("svscav", 1, x.pos)
		SetGroup(x.fgrp[9], 6)
		x.pos = GetTransform(x.fgrp[10])
		RemoveObject(x.fgrp[10])
		x.fgrp[10] = BuildObject("svscav", 1, x.pos)
		SetGroup(x.fgrp[10], 7)
		x.pos = GetTransform(x.fcon)
		RemoveObject(x.fcon)
		x.fcon = BuildObject("svconsrb04", 1, x.pos)
		for index = 1, 10 do
			SetSkill(x.fgrp[index], x.skillsetting)
		end
		SetGroup(x.fcon, 8)
		for index = 1, 6 do --10 avail
			x.etur[index] = BuildObject("avturr", 5, ("eptur%d"):format(index))
			SetSkill(x.etur[index], x.skillsetting)
		end
		for index = 1, 4 do --6 avail
			x.eart[index] = BuildObject("avartl", 5, ("epart%d"):format(index))
			SetSkill(x.eart[index], x.skillsetting)
		end
		for index = 1, x.ftugtotal do --init ftug
			x.ftugstate[index] = 0
			x.frelstate[index] = 0
			x.etugstate[index] = 0
			x.etugtime[index] = 99999.9
			x.etugfollowing[index] = false
			x.frelcaptured[index] = 0
		end
		x.epattime = GetTime() --init epat
		for index = 1, x.epatlength do
			x.epatcool[index] = GetTime()
			x.epatallow[index] = true
		end
		SetScrap(1, 40)
		x.waittime = GetTime() + 5.0
		x.spine = x.spine + 1
	end
	
	--AFTER INITIAL WAIT
	if x.spine == 1 and x.waittime < GetTime() then
		x.audio1 = AudioMessage("tcrb0401b.wav") --ALTERNATE SPLIT INTRO - Def bridge for trans.
		x.waittime = 240.0
		if x.skillsetting == x.medium then --more time on harder difficulties
			x.waittime = GetTime() + 270.0
		elseif x.skillsetting == x.hard then
			x.waittime = GetTime() + 300.0
		end
		x.spine = x.spine + 1
	end

	--START TIMER AND 7MIN COUNTDOWN
	if x.spine == 2 and x.waittime < GetTime() then
		x.audio1 = AudioMessage("tcrb0401c.wav") --ALTERNATE SPLIT INTRO - 1km in 7 minutes
		ClearObjectives()
		AddObjective("tcrb0401.txt")
		StartCockpitTimer(420, 300, 120) --KEEP FOR THIS MISSION
		x.waittime = GetTime() + 420.0
		x.spine = x.spine + 1
	end
	
	--START TUG CONVOY
	if x.spine == 3 and x.waittime < GetTime() then
		StopCockpitTimer()
		HideCockpitTimer()
		x.ftugstart = true
		x.ftugtime = GetTime()
		ClearObjectives()
		AddObjective("tcrb0404.txt", "ALLYBLUE")
		AudioMessage("tcrb0402.wav") --Trans are arriving
		x.waittime = GetTime() + 20.0
		x.spine = x.spine + 1
	end
	
	--START BRIDGE PATROL
	if x.spine == 4 and x.waittime < GetTime() then
		x.bridgetoofar = true
		x.spine = x.spine + 1
	end
	
	--THE FTUGS HAVE ARRIVED
	if x.spine == 5 and x.ftughome >= (x.ftugtotal-1) then
		x.audio1 = AudioMessage("tcrb0407.wav") --SUCCEED - The trans have cleared the pass
		ClearObjectives()
		AddObjective("tcrb0402.txt", "GREEN")
		x.spine = x.spine + 1
	end
	
	--WINNER WINNER WINNER
	if x.spine == 6 and IsAudioMessageDone(x.audio1) then
		TCC.SucceedMission(GetTime(), "tcrb04w1.des")
		x.spine = x.spine + 1
	end
	----------END MAIN SPINE ----------
	
	--BUILD ALLY TUG AND CARGO
	if x.ftugstart and x.ftugcount < x.ftugtotal and x.ftugtime < GetTime() then
		x.ftugcount = x.ftugcount + 1
		x.ftug[x.ftugcount] = BuildObject("svtug", 4, "fptug")
		x.ftugstate[x.ftugcount] = 1 --tug EXISTS
		x.frel[x.ftugcount] = BuildObject(("fryrelic0%d"):format(x.ftugcount), 3, "fptug")
		x.frelstate[x.ftugcount] = 1 --relic EXISTS
		Pickup(x.ftug[x.ftugcount], x.frel[x.ftugcount])
		x.ftugtime = GetTime() + 60.0
	end
	
	--ONCE TUG HAS CARGO, MOVE OUT
	if HasCargo(x.ftug[x.ftugcount]) and x.ftugstate[x.ftugcount] == 1 then
		SetObjectiveName(x.ftug[x.ftugcount], ("Transport %d"):format(x.ftugcount))
		SetObjectiveOn(x.frel[x.ftugcount]) --relic NOT transport
		Goto(x.ftug[x.ftugcount], "fptug")
		x.ftugstate[x.ftugcount] = 2 --tug has cargo and on the move
	end
	
	--REMOVE TUG AND CARGO AT PATH END
	for index = 1, 5 do
		if x.ftugstate[index] == 2 and GetDistance(x.frel[index], "fphome") < 50 then
			AudioMessage("tcrb0404.wav") --A trans has cleared the pass
			x.ftugstate[index] = 3 --tug REMOVED (not killed)
			x.frelstate[index] = 3 --relic REMOVED (not killed)
			RemoveObject(x.frel[index])
			RemoveObject(x.ftug[index])
			if IsAlive(x.etug[index]) then
				Damage(x.etug[index], (GetCurHealth(x.etug[index])+10))
			end
			x.etugstate[index] = 5 --end state, don't use this tug again
			x.ftughome = x.ftughome + 1
		end
	end
	
	--PLAYER ENCOUNTERS END
	if x.atbridge == 0 and GetDistance(x.player, "pbridge1") < 200 then
		AudioMessage("tcrb0408.wav") --That’s the bridge ahead
		x.atbridge = x.atbridge + 1
	elseif x.atbridge == 1 and not IsAlive(x.etur[1]) and not IsAlive(x.etur[2]) and not IsAlive(x.eart[1]) and not IsAlive(x.eart[2]) then
		AudioMessage("tcrb0405.wav") --Bridge seems secure but heavy enemy activity on other side
		x.atbridge = x.atbridge + 1
	end
	
	--PLAYER ON OTHER SIDE OF BRIDGE
	if x.atbridge >= 0 and x.atbridge < 3 and IsAlive(x.player) and GetDistance(x.player, "pbridge2") < 100 then
		AudioMessage("tcrb0409.wav") --There's enemy artil on E plateau and across the bridge
		x.atbridge = x.atbridge + 1
	end
	
	--NOTIFY ALLY TUG KILLED
	if x.ftugstart then 
		for index = 1, 5 do
			if x.ftugstate[index] == 2 and not IsAlive(x.ftug[index]) then
				AudioMessage("tcrb0403.wav") --Trans lost (CHANGED CONTEXT)
				x.ftugstate[index] = 4
			end
		end
	end
	
	--NSDF TUGS TO CAPTURE RELICS
	if x.ftugstart then
		for index = 1, x.ftugtotal do
			--seed tug existence
			if not IsAlive(x.etug[index]) and x.etugstate[index] > 1 and x.etugstate[index] < 5 then
				x.etugstate[index] = 0 --etug doesn't exist
			end
			
			--is nsdf etug allowed, and if so begin countdown
			if (x.etugstate[index] == 0) and (x.frelstate[index] == 1) and not IsAlive(x.ftug[index]) and IsAlive(x.frel[index]) then
				x.etugtime[index] = GetTime() + 30.0 --timing a x.hard call
				x.etugfollowing[index] = true --seed value
				x.etugstate[index] = 1 --etug cooloff time
			end
			
			--Build nsdf etug if time done
			if x.etugstate[index] == 1 and x.etugtime[index] < GetTime() then
				x.etug[index] = BuildObject("avtug", 5, GetPositionNear("epgrcy", 0, 16, 32)) --grpspwn
				SetObjectiveName(x.etug[index], ("Hauler %d"):format(index))
				SetObjectiveOn(x.etug[index])
				x.etugstate[index] = 2 --etug exists
			end
			
			--have nsdf tug pickup object or follow object if picked up by player-built tug
			if x.etugstate[index] == 2 and IsAlive(x.etug[index]) and x.etugfollowing[index] and (GetTug(x.frel[index]) == nil) then
				Pickup(x.etug[index], x.frel[index])
				x.etugfollowing[index] = false
			elseif x.etugstate[index] == 2 and IsAlive(x.etug[index]) and GetTug(x.frel[index]) and not HasCargo(x.etug[index]) and not x.etugfollowing[index] then
				Follow(x.etug[index], x.frel[index])
				x.etugfollowing[index] = true
			end
			
			--if nsdf tug has relic, then RTB
			if x.etugstate[index] == 2 and HasCargo(x.etug[index]) then
				Goto(x.etug[index], ("ephome%d"):format(index))
				x.etugstate[index] = 3 --etug has cargo
			end
			
			--if nsdf tug is in base update etugstate
			if x.etugstate[index] == 3 and GetDistance(x.etug[index], ("ephome%d"):format(index)) < 20 then
				x.etugstate[index] = 4 --etug w/ frel at base
			end
			
			--if a relic is inside the NSDF base note for fail potential
			if x.etugstate[index] == 4 and x.frelcaptured[index] == 0 then
				x.frelcaptured[index] = 1
			elseif x.frelcaptured[index] == 1 and IsAlive(x.frel[index]) and GetDistance(x.frel[index], ("ephome%d"):format(index)) > 100 then
				x.frelcaptured[index] = 0
			end
		end
		
		--DO A COUNT OF ENEMY HELD RELICS
		for index = 1, x.ftugtotal do --KEEP SEPERATE for timing purposes
			if x.frelcaptured[index] == 1 then
				x.erelcount = x.erelcount + 1
			end
		end
	end
	
	--IF PLAYER HAS TO BUILD TUG AND MOVE OUT RELIC
	for index = 1, x.ftugtotal do --same as total num of relics
		if IsAlive(x.frel[index]) and not IsAlive(x.ftug[index]) and GetTug(x.frel[index]) and GetTeamNum(GetTug(x.frel[index])) == 1 and x.ftugstate[index] ~= 2 then
			x.ftug[index] = GetTug(x.frel[index])
			TCC.SetTeamNum(x.ftug[index], 4) --switch from player's to ally team
			SetObjectiveName(x.ftug[index], ("Transport %d"):format(index))
			--SetObjectiveOn(x.ftug[index])
			Goto(x.ftug[index], "fphome", 1) --go to point, not by route
			x.ftugstate[index] = 2 --tug has cargo and on the move (skip 1 in this context)
		end
	end
	
	--NSDF GROUP PATROLS
	if x.epattime < GetTime() and (IsAlive(x.ercy) or IsAlive(x.efac)) then
		for index = 1, x.epatlength do
			if not IsAlive(x.epat[index]) and not x.epatallow[index] then
				x.epatcool[index] = GetTime() + 90.0 --time between individual respawn
				x.epatallow[index] = true
			end
			if x.epatallow[index] and x.epatcool[index] < GetTime() then
				if index == 1 and (IsAlive(x.eart[1]) or IsAlive(x.etur[1])) then
					x.epat[index] = BuildObject("avscout", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
					Patrol(x.epat[index], "ppatrol1")
				elseif index == 2 and (IsAlive(x.eart[1]) or IsAlive(x.etur[1])) then
					x.epat[index] = BuildObject("avtank", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
					Patrol(x.epat[index], "ppatrol1")
				elseif index == 3 and (IsAlive(x.eart[2]) or IsAlive(x.etur[2])) then
					x.epat[index] = BuildObject("avscout", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
					Patrol(x.epat[index], "ppatrol2")
				elseif index == 4 and (IsAlive(x.eart[2]) or IsAlive(x.etur[2])) then
					x.epat[index] = BuildObject("avtank", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
					Patrol(x.epat[index], "ppatrol2")
				elseif index == 5 then
					x.epat[index] = BuildObject("avmisl", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
					Patrol(x.epat[index], "ppatrol3")
				elseif index == 6 then
					x.epat[index] = BuildObject("avmbike", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
					Patrol(x.epat[index], "ppatrol3")
				elseif index == 7 then 
					x.epat[index] = BuildObject("avmisl", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
					Patrol(x.epat[index], "ppatrol4")
				elseif index == 8 then
					x.epat[index] = BuildObject("avmbike", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
					Patrol(x.epat[index], "ppatrol4")
				end
				if IsAlive(x.epat[index]) then
					SetSkill(x.epat[index], x.skillsetting)
				end
				x.epatallow[index] = false
			end
		end
		x.epattime = GetTime() + 30.0 --time between OA checks
	end

	--CHECK STATUS OF MCA
	if not x.MCAcheck then		
	--VALINOV DESTROYED, RECYCLED FROM tcrb01 -meh, won't run unless something stupid happens
		if not IsAlive(x.frcy) then --frecy killed
			AudioMessage("tcrb0112.wav") --FAIL - B1 Recy Valinov lost
			AudioMessage("tcrb0113.wav") --FAIL - B2 need more competent officer
			ClearObjectives()
			AddObjective("tcrb0114.txt", "RED") --The Valinov has been destroyed.	MISSION FAILED!
			TCC.FailMission(GetTime() + 20.0, "tcrb01f02.des") --LOSER LOSER LOSER
			x.spine = 666
			x.MCAcheck = true
		end
		
		if x.ftugstart and x.freldeadcount < 2 then --check if 2 relics destroyed
			for index = 1, 5 do
				if x.frelstate[index] == 1 and not IsAlive(x.frel[index]) then
					x.freldeadcount = x.freldeadcount + 1
				end
			end
		end
		
		if x.erelcount > 1 or x.freldeadcount > 1 or (x.erelcount + x.freldeadcount > 1) then --if relics destroyed or nsdf holds 2 of them at once at base
			AudioMessage("tcrb0406.wav") --FAIL - Convoy is too insecure
			ClearObjectives()
			if x.freldeadcount > 1 then
				AddObjective("tcrb0403.txt", "RED") --too many destroyed
			elseif x.erelcount > 1 then
				AddObjective("tcrb0405.txt", "RED") --too many captured
			else
				AddObjective("tcrb0406.txt", "RED") --too many destroyed and captured
			end
			TCC.FailMission(GetTime() + 10.0, "tcrb04f1.des") --LOSER LOSER LOSER
			x.spine = 666
			x.MCAcheck = true
		end
		x.freldeadcount = 0
		x.erelcount = 0
	end
end
--[[END OF SCRIPT]]