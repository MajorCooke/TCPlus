--bztcbd02 - Battlezone Total Command - Rise of the Black Dogs - 2/10 - PREPARATIONS
assert(load(assert(LoadFile("_requirefix.lua")),"_requirefix.lua"))();
TCC = require("TC_Core")
MisnNum = 4;
local index = 0
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
	hard = 2, --tried 1-3, in 185, 3 didn't seem to make any difference,
	pos = {}, 
	audio1 = nil, 
	audio6 = nil, 
	fnav = {},	
	casualty = 0,
	repel = nil, 
	scrap = nil, 
	fullforce = false, 
	gotrcy = 0, 
	gotscv = 0, 
	gottur = 0, 
	gotprd = 0, 
	gotfac = 0, 
	gotarm = 0, 
	gotcom = 0,	 --removed tank build req
	gotcbb = 0, 
	gotnsd = 0, 
	callmake = false, 
	callstate = 0, 
	frcy = nil, 
	ffac = nil, 
	farm = nil, 
	fcom = nil, 
	fscv = {}, 
	ftur = {}, 
	fgrp = {}, --begin spawn tanks
	ftnk = {}, --required build tanks
	ercy = nil, 
	efac = nil, 
	etur = {}, 
	egun = {}, 
	eatk = {}, 
	eatkstate = 0, 
	etnkstate = 0, --AIP stuff
	etnktime = 99999.9, 
	etnkcount = 0, 
	etnk = {}, 
	etnklength = 0, 
	camstate = 0, 
	camtime = 99999.9, 
	camfov = 60,  --185 default
	userfov = 90,  --seed
	fullforcetime = 99999.9, 
	LAST = true
}
--PATHS: pmytank, fpgrp(0-6), fprcy, fpnav1, pscrap(0-50), epatk(0-16), eptur1-6, epgrcy, epgfac, 

function InitialSetup()
	SetAutoGroupUnits(true)
		
	local odfpreload = {
		"bvrecybd02", "nvscout", "nvmbike", "nvmisl", "nvtank", "bvtank", "repelenemy400", "npscrx", "apcamrb" 
	}
	for k,v in pairs(odfpreload) do
		PreloadODF(v)
	end
	
	x.ercy = GetHandle("ercy")
	x.efac = GetHandle("efac")
	x.egun[1] = GetHandle("egun1")
	x.egun[2] = GetHandle("egun2")
	x.frcy = GetHandle("frcy")
	
	SetColorFade(6.0, 0.5, "BLACK")
	TCC.InitialSetup();
end

function Save()
	return
	index, indexadd, x, TCC.Save()
end

function Load(a, b, c, coreData)
	index = a;
	indexadd = b;
	x = c;
	TCC.Load(coreData);
end

function Start()
	TCC.Start();
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

function AddObject(h)
	--CHECK IF STUFF BUILT
	if not x.fullforce then	 
	--SCAV BUILT
		if IsOdf(h, "bvscav:1") then
			for indexadd = 1, 2 do
				if not IsAlive(x.fscv[indexadd]) then
					x.fscv[indexadd] = h
					break
				end
			end
		end
		
		--TURR BUILT
		if IsOdf(h, "bvturr:1") then
			for indexadd = 1, 3 do
				if not IsAlive(x.ftur[indexadd]) then
					x.ftur[indexadd] = h
					break
				end
			end
		end
		
		--FACT BUILT
		if x.gotfac == 0 and IsType(h, "bbfact") and not IsAlive(x.ffac) then
			x.ffac = h
		end
		
		--ARMO BUILT
		if x.gotarm == 0 and IsType(h, "bbarmo") and not IsAlive(x.farm) then
			x.farm = h
		end
		
		--CBUN BUILT
		if x.gotcom ==0 and IsType(h, "bbcbun") and not IsAlive(x.fcom) then
			x.fcom = h
		end
		--REMOVED COMBAT UNIT BUILD REQ
	end
	TCC.AddObject(h);
end

function Update()
	x.player = GetPlayerHandle() --EVERY PASS SO IF PLAYER CHANGES VEHICLES
	x.skillsetting = IFace_GetInteger("options.play.difficulty")
	TCC.Update();
	--START THE MISSION BASICS
	if x.spine == 0 then
		x.repel = BuildObject("repelenemy400", 5, GetPositionNear("epgrcy", 0, 16, 32)) --grpspwn
		x.audio1 = AudioMessage("tcbd0201.wav") --Cobra One you'll be mostly defending in this mission. 
		AddObjective("\n\nRESOURCES ARE LIMITED\nfollow objectives closely until base is built.", "LAVACOLOR")
		--AddObjective("tcbd0201.txt")
		x.mytank = BuildObject("bvtank", 1, "pmytank")
		SetAsUser(x.mytank, 1)
		RemoveObject(x.player)
		x.player = GetPlayerHandle()
		for index = 1, 2 do
			x.fgrp[index] = BuildObject("bvtank", 1, "fpgrp", index)
			SetSkill(x.fgrp[index], 3)
			SetGroup(x.fgrp[index], 0)
		end
		x.frcy = BuildObject("bvrecybd02", 1, "fprcy")
		SetGroup(x.frcy, 1)
		for index = 1, 6 do 
			x.etur[index] = BuildObject("mvturr", 5, "eptur", index)
			SetSkill(x.etur[index], x.skillsetting)
		end
		for index = 1, 50 do
			x.scrap = BuildObject("npscrx", 0, "pscrap", index)
		end
		SetScrap(1, 80)
		--x.callmake = true
		x.eatklength = 2
    x.waittime = GetTime() + 8.0
		x.spine = x.spine + 1	
	end
  
  --START UP CALL CENTER
  if x.spine == 1 and x.waittime < GetTime() then
    x.callmake = true
		x.spine = x.spine + 1	
	end
	
	--ALL FORCES BUILT
	if x.spine == 2 and x.fullforce then
		x.audio1 = AudioMessage("tcbd0202.wav") --We believe the soviets are building a base of their own. You must destroy the base before it becomes too great a threat.
		RemoveObject(x.repel)
		x.spine = x.spine + 1
	end
	
	--ORDER ATTACK CCA
	if x.spine == 3 and IsAudioMessageDone(x.audio1) then
		x.callmake = true
		x.fnav[1] = BuildObject("apcamra", 1, "fpnav1")
		SetObjectiveName(x.fnav[1], "CBB base")
		x.eatkstate = 2
		x.eatklength = 7
		x.eatktime = GetTime()
		x.spine = x.spine + 1
	end
	
	--PREP COUNTERATTACK
	if x.spine == 4 and ((not IsAlive(x.egun[1]) and not IsAlive(x.egun[2])) or (IsAlive(x.ercy) and (GetCurHealth(x.ercy) < math.floor(GetMaxHealth(x.ercy) * 0.8))) or (GetCurHealth(x.efac) < math.floor(GetMaxHealth(x.efac) * 0.8))) then
		x.etnkstate = 1
		x.etnktime = GetTime()
		x.waittime = GetTime() + 6.0
		x.spine = x.spine + 1
	end
	
	--START AIP CAMERA
	if x.spine == 5 and x.waittime < GetTime() then
		for index = 1, 20 do  --weaken since player will be in camera
			if IsAlive(x.eatk[index]) then
				if IsAlive(x.eatk[index]) and GetCurHealth(x.eatk[index]) > math.floor(GetMaxHealth(x.eatk[index]) * 0.3) then
					SetCurHealth(x.eatk[index], math.floor(GetMaxHealth(x.eatk[index]) * 0.3))
				end
			end
		end 
		x.camstate = 1
    x.userfov = IFace_GetInteger("options.graphics.defaultfov")
    CameraReady()
    IFace_SetInteger("options.graphics.defaultfov", x.camfov)
		x.audio1 = AudioMessage("tcbd0203.wav") --Am assist Sov, attack force incoming. Destroy it.
		x.spine = x.spine + 1
	end
	
	--AFTER CAMERA
	if x.spine == 6 and IsAudioMessageDone(x.audio1) then
		x.camstate = 0
    CameraFinish()
    IFace_SetInteger("options.graphics.defaultfov", x.userfov)
		x.callmake = true
		x.spine = x.spine + 1
	end
	
	--WAIT FOR CALL CENTER UPDATE
	if x.spine == 7 and x.gotcbb == 1 and x.gotnsd == 1 then
		AudioMessage("tcbd0204.wav")
		x.MCAcheck = true
		x.waittime = GetTime() + 2.0
		x.spine = x.spine + 1
	end
	
	--MISSION SUCCESS
	if x.spine == 8 and x.waittime < GetTime() then
		AddObjective("\n\nEnemy forces defeated.\n\nMISSION COMPLETE!", "GREEN")
		TCC.SucceedMission(GetTime() + 8.0, "tcbd02w.des") --WINNER WINNER WINNER
		x.spine = 666
	end
	----------END MAIN SPINE ----------
	
	--CHECK ON BUILD REQUIREMENTS
	if not x.fullforce then
		--RECY DEPLOYED
		if x.gotrcy == 0 and IsAlive(x.frcy) and IsOdf(x.frcy, "bbrecybd02") then
			x.gotrcy = 1
			x.eatkstate = 1 --init attack
			x.callmake = true
		end
		
		--ALL SCAVS EXIST
		if x.gotscv == 0 then
			for indexadd = 1, 2 do
				if IsAlive(x.fscv[indexadd]) then
					x.casualty = x.casualty + 1
				end
			end
			if x.casualty == 2 then
				x.gotscv = 1
				x.eatkstate = 1
				x.callmake = true
			end
			x.casualty = 0
		end
		
		--ALL TURRS EXIST
		if x.gottur == 0 then
			for indexadd = 1, 3 do
				if IsAlive(x.ftur[indexadd]) then
					x.casualty = x.casualty + 1
				end
			end
			if x.casualty == 3 then
				x.gottur = 1
				x.eatkstate = 1
				x.callmake = true
			end
			x.casualty = 0
		end
		
		--ALL PRODUCTION EXISTS
		if x.gotprd == 0 then
			if x.gotfac == 0 and IsAlive(x.ffac) then --GOT FACT
				x.gotfac = 1
			end
			if x.gotarm == 0 and IsAlive(x.farm) then --GOT ARMO
				x.gotarm = 1
			end
			if x.gotfac == 1 and x.gotarm == 1 then
				x.eatkstate = 1
				x.callmake = true
				x.gotprd = 1
			end
		end
		
		--COM BUILT
		if x.gotcom == 0 and IsAlive(x.fcom) and x.gotprd == 1 then
			x.gotcom = 1
			x.eatkstate = 1
			x.callmake = true
		end
		--REMOVED COMBAT UNIT BUILD REQ
	end
	
	--CALL CENTER
	if not x.fullforce and x.callmake then
		StartSoundEffect("emdotcox.wav")
		ClearObjectives()
		
		if x.gotrcy == 0 then
			AddObjective("-Deploy Recycler.")
		elseif x.gotrcy > 0 then
			AddObjective("-Deploy Recycler.", "GREEN")
			x.callstate = 1
		end

		if x.gotscv == 0 and x.callstate == 1 then
			AddObjective("-Build 2 Scavengers.")
		elseif x.gotscv > 0 then
			AddObjective("-Build 2 Scavengers.", "GREEN")
			x.callstate = 2
		end
		
		if x.gottur == 0 and x.callstate == 2 then 
			AddObjective("-Build 3 Badgers.")
		elseif x.gottur == 1 then
			AddObjective("-Build 3 Badgers.", "GREEN")
			x.callstate = 3
		end
		
		if x.gotprd == 0 and x.callstate == 3 then
			AddObjective("-Build an AMUF and SLF from Recycler Production Units(cheaper)\n-Deploy to Factory and Armory.")
		elseif x.gotprd == 1 then
			AddObjective("-Build an AMUF and SLF from Recycler\n-Deploy to Factory and Armory.", "GREEN")
			x.callstate = 4
		end
		
		if x.gotcom == 0 and x.callstate == 4 then 
			AddObjective("-Build a Heaval and construct a Solar Power and a Comm Tower.")
		elseif x.gotcom == 1 then
			AddObjective("-Build a Heaval and construct a Solar Power and a Comm Tower.", "GREEN")
			x.fullforce = true
			x.fullforcetime = GetTime() + 9.0
		end
		
		x.callmake = false
		
	elseif x.fullforce and x.callmake and x.fullforcetime < GetTime() then
		StartSoundEffect("emdotcox.wav")
		ClearObjectives()
		
		if x.gotcbb == 0 then
			AddObjective("Destroy the CBB Recycler at Nav 1.")
		elseif x.gotcbb == 1 then
			AddObjective("Destroy the CBB Recycler at Nav 1.", "GREEN")
		end
		
		if x.gotnsd == 0 and x.etnkstate == 1 then
			AddObjective("\nDestroy rogue NSDF attack waves.")
		elseif x.gotnsd == 1 then
			AddObjective("\nDestroy rogue NSDF attack waves.", "GREEN")
		end
		x.callmake = false
	end
	
	--PROGRESSION ATTACKS
	if x.eatkstate == 1 then
		for index = 1, x.eatklength do
			if index % 3 == 0 then
				x.eatk[index] = BuildObject("mvtank", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
			elseif index % 2 == 0 then
				x.eatk[index] = BuildObject("mvmbike", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
			else
				x.eatk[index] = BuildObject("mvscout", 5, GetPositionNear("epgrcy", 0, 16, 32)) --grpspwn
			end
			SetSkill(x.eatk[index], x.skillsetting)
			Attack(x.eatk[index], x.frcy)
		end
		x.eatklength = x.eatklength + 1
		if x.eatklength > 5 then
			x.eatklength = 5
		end
		x.eatkstate = 0
	end
	
	--REGULAR ATTACKS
	if x.eatkstate == 2 and x.eatktime < GetTime() and IsAlive(x.efac) then
		for index = 1, x.eatklength do
			if index % 5 == 0 then
				x.eatk[index] = BuildObject("mvrckt", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
			elseif index % 4 == 0 then
				x.eatk[index] = BuildObject("mvtank", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
			elseif index % 3 == 0 then
				x.eatk[index] = BuildObject("mvmisl", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
			elseif index % 2 == 0 then
				x.eatk[index] = BuildObject("mvmbike", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
			else
				x.eatk[index] = BuildObject("mvscout", 5, GetPositionNear("epgrcy", 0, 16, 32)) --grpspwn
			end
			SetSkill(x.eatk[index], x.skillsetting)
			Attack(x.eatk[index], x.frcy)
		end
		x.eatklength = x.eatklength + 1
		if x.eatklength > 20 then
			x.eatklength = 20
		end
		x.eatktime = GetTime() + 240.0
	end
	
	--AIP ATTACKS
	if x.etnkstate == 1 and x.etnktime < GetTime() and x.etnkcount < 4 then
		x.etnklength = 10
		x.etnktime = GetTime() + 120.0
		for index = 1, x.etnklength do
			if index % 4 == 0 then
				x.etnk[index] = BuildObject("nvmisl", 5, "epatk", index)  --better with individ GetPositionNear("epatk", 0, 8, 32))
			elseif index % 3 == 0 then
				x.etnk[index] = BuildObject("nvtank", 5, "epatk", index)
			elseif index % 2 == 0 then
				x.etnk[index] = BuildObject("nvmbike", 5, "epatk", index)
			else
				x.etnk[index] = BuildObject("nvscout", 5, "epatk", index)
			end
			SetSkill(x.etnk[index], x.skillsetting)
			Attack(x.etnk[index], x.frcy)
		end
		x.etnkcount = x.etnkcount + 1
	end
	
	--CAMERA ON ROGUE NSDF ATTACK
	if x.camstate == 1 then
		CameraPath("pcam1", 2000, 1000, x.etnk[2])
	end
	
	--ERCY DEAD
	if x.gotcbb == 0 and not IsAlive(x.ercy) and not IsAlive(x.efac) then
		x.gotcbb = 1
		x.callmake = true
	end
	
	--ROGUE NSDF DEAD
	if x.etnkstate == 1 and x.etnkcount == 4 then
		for index = 1, x.etnklength do
			if not IsAlive(x.etnk[index]) then
				x.casualty = x.casualty + 1
			end
		end
		if x.casualty == x.etnklength then
			x.gotnsd = 1
			x.etnkstate = 2
			x.callmake = true
		end
		x.casualty = 0
	end
	
	--CHECK STATUS OF MCA 
	if not x.MCAcheck then	 
		if not IsAlive(x.frcy) then --lost recycler
			AudioMessage("alertpulse.wav")
			ClearObjectives()
			AddObjective("Recycler destroyed.\n\nMISSION FAILED!", "RED")
			TCC.FailMission(GetTime() + 4.0, "tcbd02f1.des") --LOSER LOSER LOSER
			x.spine = 666
			x.MCAcheck = true
		end
		
		if not x.fullforce and ((x.gotscv == 0 and x.gottur == 1) or (x.gottur == 0 and (IsAlive(x.ffac) or IsAlive(x.farm))) or (IsAlive(x.fcom) and (not IsAlive(x.ffac) or not IsAlive(x.farm)))) then
			AudioMessage("alertpulse.wav")
			ClearObjectives()
			AddObjective("Failed to follow objectives in assigned order.\n\nMISSION FAILED!", "RED")
			TCC.FailMission(GetTime() + 6.0, "tcbd02f2.des") --LOSER LOSER LOSER
			x.spine = 666
			x.MCAcheck = true
		end
	end
end
--[[END OF SCRIPT]]