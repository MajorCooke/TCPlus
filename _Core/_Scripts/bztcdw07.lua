--bztcdw07 - Battlezone Total Command - Dogs of War - 7/15 - TERRA INCOGNITA
assert(load(assert(LoadFile("_requirefix.lua")),"_requirefix.lua"))();
TCC = require("TC_Core")
MisnNum = 38;
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
	hard = 2, --tried 1-3, in 185, 3 didn't seem to make any difference, 
	pos = {}, 
	audio1 = nil, 
	audio6 = nil, 
	fnav = {}, 
	casualty = 0, 
	randompick = 0, 
	randomlast = 0, 
	efacstate = 0, 
	convoystate = 0, --AI convoy
	convoylength = 0, 
	convoytime = 99999.9, 
	convoywarn = 0, 
	convoyearly = false, 
	convoydone = false, 
	convoyunit = {}, 
	ercy = nil, --AI buildings
	efac = nil, 
	efacpos = nil, 
	earm = nil, 
	ebay = nil, 
	etrn = nil, 
	etec = nil, 
	ehqr = nil, 
	esld = nil, 
	egun = {}, 
	epwr = {},
	escv = {}, --escavs
	escvlength = 6, 
	escvstage = {}, 
	escvtime = {}, 
	eartatktime = 99999.9, --eartillery
	eartatk = {}, 
	eartatklength = 0, 
	eartatkmeet = 2, --so will goto "1" 1st
	eartatkallow = false, 
	eartatkmarch = false, 
	eartatkthereyet = false, 
	eartatktarget = 99999.9, 
	emintime = 99999.9, --eminelayers
	eminlength = 0, 
	emingo = {}, 
	emin = {}, 
	emincool = {}, 
	eminallow = {},	
	eminlife = {}, 
	eturtime = 99999.9, --eturret
	eturlength = 0,
	etur = {}, 
	eturcool = {}, 
	eturallow = {}, 
	etursecs = {}, 
	epattime = 99999.9, --epatrols
	epatlength = 4, 
	epat = {}, 
	epatcool = {}, 
	epatallow = {},	
	epatsecs = {}, 
	wreckstate = 0, --daywrecker
	wrecktime = 99999.9, 
	wrecktrgt = {},
	wreckbomb = nil, 
	wreckname = "apdwrkk", 
	wreckbank = false, --have 2
	wrecknotify = 0, 
	fgrp = {}, --fbase stuff
	frcy = nil, 
	ffac = nil, 
	farm = nil, 
	fpwr = {nil, nil, nil, nil},
	fcom = nil,
	fbay = nil,
	ftrn = nil,
	ftec = nil,
	fhqr = nil,
	fsld = nil, 
	fartlength = 10, --fart killers
	fart = {}, 
	ekillarttime = 99999.9, 
	ekillartlength = 4, 
	ekillart = {}, 
	ekillartcool = {}, 
	ekillartallow = {}, 
	ekillarttarget = nil, 
	ekillartmarch = false, 
	ewardeclare = false, --WARCODE
	ewartotal = 4, --1 recy, 2 fact, 3 armo, 4 base 
	ewarrior = {}, 
	ewartime = {},
	ewartimecool = {},
	ewartimeadd = {},
	ewarabortset = {}, 
	ewarabort = {}, 
	ewarstate = {}, 
	ewarsize = {}, 
	ewarwave = {}, 
	ewarwavemax = {}, 
	ewarwavereset = {}, 
	ewarmeet = {}, 
	ewarriortime = {},
	ewarriorplan = {}, 
	ewartrgt = {}, 
	ewarpos = {}, 
	LAST = true
}
--PATHS: ppatrol1-4, eptur(0-20), epmin1-2, stage1-4, pscrap(0-120), eprcy, epgrcy, epfac, epgfac, epconvoy, fbasearea, ebasearea, fpnav1(at fbay)

function InitialSetup()
	SetAutoGroupUnits(true)
		
	local odfpreload = {
		"kvscout", "kvmbike", "kvmisl", "kvtank", "kvrckt", "kvwalk", "kvhtnk", "kvturr", "kvmine", "kvartl", "npscrx", "apcamrb" 
	}
	for k,v in pairs(odfpreload) do
		PreloadODF(v)
	end
		
	x.mytank = GetHandle("mytank")
	x.frcy = GetHandle("frcy")
	x.fhqr = GetHandle("fhqr")
	x.ftec = GetHandle("ftec")
	x.ftrn = GetHandle("ftrn")
	x.fbay = GetHandle("fbay")
	for index = 1, 4 do
		x.fgrp[index] = GetHandle(("fgrp%d"):format(index))
	end
	x.ercy = GetHandle("ercy")
	x.efac = GetHandle("efac")
	x.earm = GetHandle("earm")
	x.ecom = GetHandle("ecom")
	x.ebay = GetHandle("ebay")
	x.etrn = GetHandle("etrn")
	x.etec = GetHandle("etec")
	x.ehqr = GetHandle("ehqr")
	x.esld = GetHandle("esld")
	for index = 3, 6 do --deployed escvs
		x.escv[index] = GetHandle(("escv%d"):format(index))
	end	
	SetColorFade(6.0, 0.5, "BLACK")
	TCC.Update();
	TCC.Init()
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
	--get player base buildings for later attack
	if (not IsAlive(x.farm) or x.farm == nil) and (IsOdf(h, "bvarmo:1") or IsOdf(h, "bbarmo")) then
		x.farm = h
	elseif (not IsAlive(x.ffac) or x.ffac == nil) and (IsOdf(h, "bvfactdw07:1") or IsOdf(h, "bbfactdw07")) then
		x.ffac = h
	elseif (not IsAlive(x.fsld) or x.fsld == nil) and IsOdf(h, "bbshld") then
		x.fsld = h
	elseif (not IsAlive(x.fhqr) or x.fhqr == nil) and IsOdf(h, "bbhqtr") then
		x.fhqr = h
	elseif (not IsAlive(x.ftec) or x.ftec == nil) and IsOdf(h, "bbtcen") then
		x.ftec = h
	elseif (not IsAlive(x.ftrn) or x.ftrn == nil) and IsOdf(h, "bbtrain") then
		x.ftrn = h
	elseif (not IsAlive(x.fbay) or x.fbay == nil) and IsOdf(h, "bbsbay") then
		x.fbay = h
	elseif (not IsAlive(x.fcom) or x.fcom == nil) and IsOdf(h, "bbcbun") then
		x.fcom = h
	elseif IsOdf(h, "bbpgen2") then
		for index = 1, 4 do
			if x.fpwr[index] == nil or not IsAlive(x.fpwr[index]) then
				x.fpwr[index] = h
				break
			end
		end
	end
	
	--GIVE NEW GRIZZLIES POPGUNS
	if IsOdf(h, "bvtank:1") then
		GiveWeapon(h, "gpopg1a")
	end
	
	--get daywrecker for highlight
	if (not IsAlive(x.wreckbomb) or x.wreckbomb == nil) and IsOdf(h, x.wreckname) then 
		if GetTeamNum(h) == 5 then
			x.wreckbomb = h --get handle to launched daywrecker
		end
	end
	
	for indexadd = 1, x.fartlength do --new artillery? 
		if (not IsAlive(x.fart[indexadd]) or x.fart[indexadd] == nil) and IsOdf(h, "bvartl:1") then
			x.fart[indexadd] = h
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
		GiveWeapon(x.mytank, "gpopg1a")
		GiveWeapon(x.fgrp[1], "gpopg1a")
		SetAsUser(x.mytank, 1)
		RemoveObject(x.player)
		x.player = GetPlayerHandle()
		SetTeamNum(x.player, 1)--JUST IN CASE
		SetObjectiveName(x.frcy, "Outpost 1")
		x.fnav[1] = BuildObject("apcamrb", 1, "fpnav1")
		SetObjectiveName(x.fnav[1], "Repair")
		x.fnav[1] = BuildObject("apcamrb", 1, "epconvoy")
		SetObjectiveName(x.fnav[1], "CRA Base")
		SetScrap(1, 40)
		x.efacpos = GetTransform(x.efac)
		x.waittime = GetTime() + 2.0
		x.spine = x.spine + 1	
	end
	
	--FIRST AUDIO
	if x.spine == 1 and x.waittime < GetTime() then
		x.audio1 = AudioMessage("tcdw0700.wav") --combo 1-3
		for index = 1, 120 do
			x.fnav[1] = BuildObject("npscrx", 0, "pscrap", index)
		end
		x.spine = x.spine + 1
	end
	
	--GIVE FIRST OBJECTIVE
	if x.spine == 2 and IsAudioMessageDone(x.audio1) then
		ClearObjectives()
		AddObjective("tcdw0701.txt")
		x.waittime = GetTime() + 240.0
		x.spine = x.spine + 1
	end
	
	--SEND CRA CONVOY
	if x.spine == 3 and (x.waittime < GetTime() or x.convoyearly) then
		x.convoyearly = true --if not already true
		x.convoytime = GetTime()
		x.convoylength = 30 
		x.convoystate = 1
		x.eturlength = 20
		for index = 1, x.eturlength do --init tur
			x.eturtime = GetTime() + 180.0
			x.eturcool[index] = GetTime()
			x.eturallow[index] = true
			x.etursecs[index] = 0.0
		end
		x.spine = x.spine + 1
	end
	
	--CONVOY DONE (PASSED OR ATTACKING)
	if x.spine == 4 and x.convoydone then
		x.emintime = GetTime() --init mines
		x.eminlength = 2
		x.eminlife[1] = 0
		x.eminlife[2] = 0
		for index = 1, x.epatlength do --init epat
			x.epattime = GetTime()
			x.epatcool[index] = GetTime()
			x.epatallow[index] = true
			x.epatsecs[index] = 0.0
		end
		x.waittime = GetTime() + 60.0
		x.spine = x.spine + 1
	end
	
	--START UP WARCODE
	if x.spine == 5 and x.waittime < GetTime() then
		AudioMessage("tcdw0704.wav") --Lt. have go ahead to destroy the Chinese base.
		ClearObjectives()
		AddObjective("tcdw0704.txt")
		AddObjective("SAVE", "DKGREY")
		x.escv[1] = nil --init scavs
		x.escv[2] = nil
		x.escvlength = 6
		for index = 1, x.ekillartlength do --init ekillart
			x.ekillarttime = GetTime()
			x.ekillart[index] = nil 
			x.ekillartcool[index] = 99999.9 
			x.ekillartallow[index] = false
		end
		for index = 1, x.escvlength do
			x.escvstage[index] = 1 
			x.escvtime[index] = GetTime()
		end
		for index = 1, x.ewartotal do --init WARCODE
			x.ewardeclare = true
			x.ewarrior[index] = {} --"rows"
			x.ewarriorplan[index] = {} --"rows"
			x.ewarriortime[index] = {} --"rows"
			x.ewartrgt[index] = {} --"rows"
			x.ewarpos[index] = {}
			for index2 = 1, 10 do --10 per wave max avail
				x.ewarrior[index][index2] = nil --"columns", init (handle in this case)
				x.ewarriorplan[index][index2] = 0
				x.ewarriortime[index][index2] = 99999.9
				x.ewartrgt[index][index2] = nil
				x.ewarpos[index][index2] = 0
			end
			x.ewarstate[index] = 1
			x.ewartime[1] = GetTime() + 30.0 --recy
			x.ewartime[2] = GetTime() + 60.0 --fact
			x.ewartime[3] = GetTime() + 90.0 --armo
			x.ewartime[4] = GetTime() + 120.0 --base
			x.ewartimecool[index] = 240.0
			x.ewartimeadd[index] = 0.0
			x.ewarabortset[index] = false
			x.ewarabort[index] = 99999.9
			x.ewarsize[index] = 0
			x.ewarwave[index] = 0
			x.ewarwavemax[index] = 5
			x.ewarwavereset[index] = 2
			x.ewarmeet[index] = 2
		end
		x.waittime = GetTime() + 180.0
		x.spine = x.spine + 1
	end
	
	--INIT ARTIL AND DAYWRECK ATTACK
	if x.spine == 6 and x.waittime < GetTime() then
		if x.skillsetting == x.easy then
			x.eartatktime = GetTime() + 180.0
			x.wrecktime = GetTime() + 240.0
		elseif x.skillsetting == x.medium then
			x.eartatktime = GetTime() + 120.0
			x.wrecktime = GetTime() + 180.0
		else
			x.eartatktime = GetTime() + 60.0
			x.wrecktime = GetTime() + 120.0
		end 
		x.spine = x.spine + 1
	end

	--MISSION SUCCESS
	if x.spine == 7 and not IsAlive(x.ercy) and not IsAlive(x.efac) and not IsAlive(x.earm) and not IsAlive(x.ecom) 
	and not IsAlive(x.ebay) and not IsAlive(x.etrn) and not IsAlive(x.etec) and not IsAlive(x.ehqr) and not IsAlive(x.esld) then
		AudioMessage("win.wav")
		AudioMessage("tcdw0705.wav") --modded from 0605
		ClearObjectives()
		AddObjective("tcdw0704.txt", "GREEN")
		AddObjective("\n\nMISSION COMPLETE", "GREEN")
		SucceedMission(GetTime() + 8.0, "tcdw07w.des") --WINNER WINNER WINNER
		x.MCAcheck = true
		x.spine = 666
	end
	----------END MAIN SPINE ----------

	--TOO CLOSE TO CRA BASE ENTRANCE TOO SOON	
	if not x.convoyearly then
		for index = 1, 4 do
			if GetDistance(x.fgrp[index], "epconvoy") < 150 then
				x.convoyearly = true
				break
			end
		end
		if GetDistance(x.player, "epconvoy") < 150 then
			x.convoyearly = true
		end 
	end
	
	--CRA CONVOY
	if x.convoystate == 1 and x.convoytime < GetTime() then
		for index = 1, x.convoylength do --build convoy, and send out
			if not IsAlive(x.convoyunit[index]) then
				x.convoyunit[index] = BuildObject("kvhtnk", 5, "epconvoy")
				SetSkill(x.convoyunit[index], x.skillsetting)
				Goto(x.convoyunit[index], "epconvoy")
				x.convoytime = GetTime() + 2.0
				if index == 3 then 
					AudioMessage("alertpulse.wav")
					AddObjective("	")
					AddObjective("tcdw0702.txt", "ALLYBLUE") --convoy coming
				end
				break
			end
		end
		if IsAlive(x.convoyunit[x.convoylength]) then
			x.convoywarn = 1
			x.convoystate = x.convoystate + 1
		end
	elseif x.convoystate == 2 then --too close to convoy, spotted, kill frcy 
		if x.convoystate == 2 then
			for index = 1, x.convoylength do
				x.fgrp[1] = GetNearestEnemy(x.convoyunit[index])
				if (GetDistance(x.convoyunit[index], x.fgrp[1]) < 120) or (GetCurHealth(x.convoyunit[index]) < math.floor(GetMaxHealth(x.convoyunit[index]) * 0.95)) then
					for index2 = 1, x.convoylength do
						Attack(x.convoyunit[index2], x.frcy)
					end
					x.convoywarn = 2
					AudioMessage("alertpulse.wav")
					ClearObjectives()
					AddObjective("tcdw0702.txt", "RED")
					AddObjective(" ")
					AddObjective("tcdw0703.txt", "YELLOW")
					x.convoydone = true
					x.convoystate = 666
					break
				end
			end
		end
		if x.convoystate == 2 then --has convoy safely passed through
			for index = 1, x.convoylength do
				if not IsInsideArea("edge_path", x.convoyunit[index]) or not IsAlive(x.convoyunit[index]) then
					x.casualty = x.casualty + 1
				end
			end
			if x.casualty >= math.floor(x.convoylength * 0.75) then
				for index = 1, x.convoylength do
					RemoveObject(x.convoyunit[index])
				end
				AudioMessage("emdotcox.wav")
				ClearObjectives()
				AddObjective("CRA convoy has cleared Outpost 1.", "GREEN")
				AddObjective("\n\nStandby for new orders.")
				x.convoywarn = 2
				x.convoydone = true
				x.convoystate = x.convoystate + 1
			end
			x.casualty = 0
		end
	end
	
	--WARN CONVOY AT BASE
	if x.convoywarn == 1 and x.convoystate < 666 then
		for index = 1, x.convoylength do
			if IsInsideArea("ewarnarea", x.convoyunit[index]) then
				AudioMessage("alertpulse.wav")
				AddObjective("\n\nCRA CONVOY NEARING OUTPOST 1", "YELLOW")
				x.convoywarn = 2
				break
			end
		end
	end
	
	--AI DAYWRECKER ATTACK --will stop if no earm, or no etec, or not enought scrap capacity (silos)
	if x.wreckstate == 0 and x.wrecktime < GetTime() and IsAlive(x.etec) and IsAlive(x.earm) and GetMaxScrap(5) >= 80 then	
		if GetScrap(5) < 80 then 
			SetScrap(5, 80) --gotta have money
		end
		x.wreckbank = true
		while x.randompick == x.randomlast do --random the random
			x.randompick = math.floor(GetRandomFloat(1.0, 12.0))
		end
		x.randomlast = x.randompick
		if IsAlive(x.ffac) and (x.randompick == 1 or x.randompick == 5 or x.randompick == 8 or x.randompick == 12) then
			x.wrecktrgt = GetPosition(x.ffac)
		elseif IsAlive(x.frcy) and (x.randompick == 2 or x.randompick == 6 or x.randompick == 9) then
			x.wrecktrgt = GetPosition(x.frcy)
		elseif IsAlive(x.fbay) and (x.randompick == 3 or x.randompick == 7 or x.randompick == 10) then
			x.wrecktrgt = GetPosition(x.fbay)
		else --4, 11
			x.wrecktrgt = GetPosition(x.player)
		end
		SetCommand(x.earm, 22, 1, 0, 0, x.wreckname) --build (don't use "Build" func)   
		x.wreckstate = x.wreckstate + 1
	elseif x.wreckstate == 1 and IsAlive(x.earm) then
		SetCommand(x.earm, 8, 1, 0, x.wrecktrgt, 0) --dropoff (don't use "Dropoff" func)
		x.wreckstate = x.wreckstate + 1
	elseif x.wreckstate == 2 and IsAlive(x.wreckbomb) then
		x.wreckbank = false --reset for scavs
		if x.skillsetting == x.easy and GetDistance(x.wreckbomb, x.wrecktrgt) < 400 then
			x.wrecknotify = 1
		elseif x.skillsetting == x.medium and GetDistance(x.wreckbomb, x.wrecktrgt) < 300 then
			x.wrecknotify = 1
		elseif x.skillsetting >= x.hard and GetDistance(x.wreckbomb, x.wrecktrgt) < 200 then
			x.wrecknotify = 1
		end
		if x.wrecknotify == 1 then
      SetTeamNum(x.wreckbomb, 5)
			SetObjectiveOn(x.wreckbomb)
			AudioMessage("alertpulse.wav")
			x.wrecknotify = 0
			x.wreckstate = x.wreckstate + 1
		end
	elseif x.wreckstate == 3 and not IsAlive(x.wreckbomb) then		
		for index = 1, 12 do
			x.randompick = math.floor(GetRandomFloat(1.0, 9.0))
		end
		if x.randompick == 1 or x.randompick == 4 or x.randompick == 7 then
			x.wrecktime = GetTime() + 420.0
		elseif x.randompick == 2 or x.randompick == 5 or x.randompick == 8 then
			x.wrecktime = GetTime() + 300.0
		else
			x.wrecktime = GetTime() + 180.0
		end
		x.wreckstate = 0 --reset
	end
	
	--AI GROUP ARTILLERY
	if x.eartatktime < GetTime() and IsAlive(x.efac) and IsAlive(x.ebay) then		
		if not x.eartatkallow then
			if x.skillsetting == x.easy then
				x.eartatklength = 4
			elseif x.skillsetting == x.medium then
				x.eartatklength = 6
			else
				x.eartatklength = 8
			end
			for index = 1, x.eartatklength do
				x.eartatk[index] = BuildObject("kvartl", 5, GetPositionNear("epgfac", 0, 16, 32))
				SetSkill(x.eartatk[index], x.skillsetting)
			end
			x.eartatkmarch = true
			x.eartatkallow = true
		end
		
		if x.eartatkmarch then --alternate
			if x.eartatkmeet == 2 then
				x.eartatkmeet = 1
			else
				x.eartatkmeet = 2
			end
			for index = 1, x.eartatklength do
				if IsAlive(x.eartatk[index]) then
					if x.eartatkmeet == 1 then
						Retreat(x.eartatk[index], "stage1")
					else
						Retreat(x.eartatk[index], "stage2")
					end
				end
			end
			x.eartatkthereyet = true
			x.eartatkmarch = false
		end
		
		if x.eartatkthereyet then --eart at stage pt
			for index = 1, x.eartatklength do
				if IsAlive(x.eartatk[index]) and ((x.eartatkmeet == 1 and (GetDistance(x.eartatk[index], "stage1", 5) < 50)) or (x.eartatkmeet == 2 and (GetDistance(x.eartatk[index], "stage2", 5) < 50))) then
					x.eartatkthereyet = false
					x.eartatktarget = GetTime()
					break
				end
			end
		end
		
		if x.eartatktarget < GetTime() then --pick eart target
			for index = 1, x.eartatklength do
				if IsAlive(x.eartatk[index]) and IsAlive(x.fsld) then --not in mission 022820
					Attack(x.eartatk[index], x.fsld)
				elseif IsAlive(x.eartatk[index]) and IsAlive(x.fhqr) then
					Attack(x.eartatk[index], x.fhqr)
				elseif IsAlive(x.eartatk[index]) and IsAlive(x.ftec) then
					Attack(x.eartatk[index], x.ftec)
				elseif IsAlive(x.eartatk[index]) and IsAlive(x.ftrn) then
					Attack(x.eartatk[index], x.ftrn)
				elseif IsAlive(x.eartatk[index]) and IsAlive(x.fbay) then
					Attack(x.eartatk[index], x.fbay)
				elseif IsAlive(x.eartatk[index]) and IsAlive(x.fcom) then
					Attack(x.eartatk[index], x.fcom)
				elseif IsAlive(x.eartatk[index]) and IsAlive(x.farm) then
					Attack(x.eartatk[index], x.farm)
				elseif IsAlive(x.eartatk[index]) and IsAlive(x.ffac) then
					Attack(x.eartatk[index], x.ffac)
				else
					Attack(x.eartatk[index], x.frcy)
				end
			end
			x.eartatktarget = GetTime() + 30.0
		end
		
		if x.eartatkallow then
			for index = 1, x.eartatklength do
				if not IsAlive(x.eartatk[index]) then
					x.casualty = x.casualty + 1
				end
			end
			if x.casualty >= math.floor(x.eartatklength * 0.8) then
				for index = 1, 12 do
					x.randompick = math.floor(GetRandomFloat(1.0, 9.0))
				end
				if x.randompick == 1 or x.randompick == 4 or x.randompick == 7 then
					x.eartatktime = GetTime() + 300.0
				elseif x.randompick == 2 or x.randompick == 5 or x.randompick == 8 then
					x.eartatktime = GetTime() + 240.0
				else
					x.eartatktime = GetTime() + 180.0
				end
				x.eartatktarget = 99999.9
				x.eartatkallow = false
			end
			x.casualty = 0
		end
	end
	
	--AI GROUP TURRETS
	if x.eturtime < GetTime() and IsAlive(x.ercy) then
		for index = 1, x.eturlength do
			if not IsAlive(x.etur[index]) and not x.eturallow[index] then
				x.etursecs[index] = x.etursecs[index] + 60.0
				x.eturcool[index] = GetTime() + 180.0 + x.etursecs[index]
				x.eturallow[index] = true
			end
			if x.eturallow[index] and x.eturcool[index] < GetTime() then
				x.etur[index] = BuildObject("kvturr", 5, GetPositionNear("epgrcy", 0, 16, 32)) --grpspwn
				Goto(x.etur[index], ("eptur%d"):format(index))
				SetSkill(x.etur[index], x.skillsetting)
				SetObjectiveName(x.etur[index], ("Adder %d"):format(index))
				x.eturallow[index] = false
			end
		end
	end

	--AI GROUP PATROLS
	if x.epattime < GetTime() and IsAlive(x.efac) then
		for index = 1, x.epatlength do
			if not IsAlive(x.epat[index]) and not x.epatallow[index] then
				x.epatsecs[index] = x.epatsecs[index] + 60.0
				x.epatcool[index] = GetTime() + 240.0 + x.epatsecs[index]
				x.epatallow[index] = true
			end
			
			if x.epatallow[index] and x.epatcool[index] < GetTime() then
				while x.randompick == x.randomlast do --random the random
					x.randompick = math.floor(GetRandomFloat(1.0, 15.0))
				end
				x.randomlast = x.randompick
				if IsAlive(x.efac) then
					if x.randompick == 1 or x.randompick == 6 or x.randompick == 11 then
						x.epat[index] = BuildObject("kvscout", 5, GetPositionNear("epgrcy", 0, 16, 32)) --grpspwn
					elseif x.randompick == 2 or x.randompick == 7 or x.randompick == 12 then
						x.epat[index] = BuildObject("kvmbike", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
					elseif x.randompick == 3 or x.randompick == 8 or x.randompick == 13 then
						x.epat[index] = BuildObject("kvmisl", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
					elseif x.randompick == 4 or x.randompick == 9 or x.randompick == 14 then
						x.epat[index] = BuildObject("kvtank", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
					else
						x.epat[index] = BuildObject("kvrckt", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
					end
				elseif IsAlive(x.ercy) then
					x.epat[index] = BuildObject("kvscout", 5, GetPositionNear("epgrcy", 0, 16, 32)) --grpspwn
				end
				if index == 1 or index == 6 then
					Patrol(x.epat[index], "ppatrol1")
				elseif index == 2 or index == 7 then
					Patrol(x.epat[index], "ppatrol2")
				elseif index == 3 or index == 8 then
					Patrol(x.epat[index], "ppatrol3")
				elseif index == 4 or index == 5 then
					Patrol(x.epat[index], "ppatrol4")
				end
				SetSkill(x.epat[index], x.skillsetting)
				--SetObjectiveName(x.epat[index], ("Patrol %d"):format(index))
				x.epatallow[index] = false
			end
		end
		x.epattime = GetTime() + 30.0
	end
	
	--WARCODE W/ CLOAKING
	if x.ewardeclare then
		for index = 1, x.ewartotal do	
			if x.ewartime[index] < GetTime() then 
				--SET WAVE NUMBER AND BUILD SIZE
				if x.ewarstate[index] == 1 then	
					x.ewarwave[index] = x.ewarwave[index] + 1
					if x.ewarwave[index] > x.ewarwavemax[index] then
						x.ewarwave[index] = x.ewarwavereset[index]
					end
					--SET WAVE SIZE
					if x.ewarwave[index] == 1 then
						if index == 1 then
							x.ewarsize[index] = 2
						elseif index == 2 then
							x.ewarsize[index] = 2
						elseif index == 3 then
							x.ewarsize[index] = 2
						elseif index == 4 then
							x.ewarsize[index] = 2
						else
							x.ewarsize[index] = 1
						end
					elseif x.ewarwave[index] == 2 then
						if index == 1 then
							x.ewarsize[index] = 4
						elseif index == 2 then
							x.ewarsize[index] = 4
						elseif index == 3 then
							x.ewarsize[index] = 3
						elseif index == 4 then
							x.ewarsize[index] = 3
						else
							x.ewarsize[index] = 2
						end
					elseif x.ewarwave[index] == 3 then
						if index == 1 then
							x.ewarsize[index] = 6
						elseif index == 2 then
							x.ewarsize[index] = 6
						elseif index == 3 then
							x.ewarsize[index] = 4
						elseif index == 4 then
							x.ewarsize[index] = 4
						else
							x.ewarsize[index] = 3
						end
					elseif x.ewarwave[index] == 4 then
						if index == 1 then
							x.ewarsize[index] = 8
						elseif index == 2 then
							x.ewarsize[index] = 8
						elseif index == 3 then
							x.ewarsize[index] = 6
						elseif index == 4 then
							x.ewarsize[index] = 5
						else
							x.ewarsize[index] = 4
						end 
					else --x.ewarwave[index] == 5 then
						if index == 1 then
							x.ewarsize[index] = 10
						elseif index == 2 then
							x.ewarsize[index] = 10
						elseif index == 3 then
							x.ewarsize[index] = 6
						elseif index == 4 then
							x.ewarsize[index] = 6
						else
							x.ewarsize[index] = 5
						end
					end
					x.ewarstate[index] = x.ewarstate[index] + 1
				--BUILD FORCE
				elseif x.ewarstate[index] == 2 then
					for index2 = 1, x.ewarsize[index] do
						while x.randompick == x.randomlast do --random the random
							x.randompick = math.floor(GetRandomFloat(1.0, 15.0))
						end
						x.randomlast = x.randompick
						if not IsAlive(x.efac) and IsAlive(x.ercy) then
							x.randompick = 1
						end
            if not IsAlive(x.efac) and not IsAlive(x.ercy) then
              x.randompick = 100
            end
						if x.randompick == 1 or x.randompick == 6 or x.randompick == 11 then
							x.ewarrior[index][index2] = BuildObject("kvscout", 5, GetPositionNear("epgrcy", 0, 16, 32)) --grpspwn
							if x.ewarwave[index] == 3 or x.ewarwave[index] == 4 then
								GiveWeapon(x.ewarrior[index][index2], "glasea_c")
							end
						elseif x.randompick == 2 or x.randompick == 7 or x.randompick == 12 then
							x.ewarrior[index][index2] = BuildObject("kvmbike", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
							if x.ewarwave[index] == 2 or x.ewarwave[index] == 4 then
								GiveWeapon(x.ewarrior[index][index2], "gstbva_c")
							end
						elseif x.randompick == 3 or x.randompick == 8 or x.randompick == 13 then
							x.ewarrior[index][index2] = BuildObject("kvmisl", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
							if x.ewarwave[index] == 3 or x.ewarwave[index] == 5 then
								GiveWeapon(x.ewarrior[index][index2], "gfafma_c")
							end
						elseif x.randompick == 4 or x.randompick == 9 or x.randompick == 14 then
							x.ewarrior[index][index2] = BuildObject("kvtank", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
							if x.ewarwave[index] == 4 or x.ewarwave[index] == 5 then
								GiveWeapon(x.ewarrior[index][index2], "gstbsa_c")
							end
						else--x.randompick == 5 or x.randompick == 10 then
							x.ewarrior[index][index2] = BuildObject("kvrckt", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
							if x.ewarwave[index] == 3 or x.ewarwave[index] == 5 then
								GiveWeapon(x.ewarrior[index][index2], "gshdwa_a") --salvo rckt
							end
						end
            if IsAlive(x.ewarrior[index][index2]) then
              SetSkill(x.ewarrior[index][index2], x.skillsetting)
              if index2 % 3 == 0 then
                SetSkill(x.ewarrior[index][index2], x.skillsetting+1)
              end
              SetCommand(x.ewarrior[index][index2], 47)
              x.ewartrgt[index][index2] = nil
            end
					end
					x.ewarabort[index] = GetTime() + 360.0 --here first in case stage goes wrong
					x.ewarstate[index] = x.ewarstate[index] + 1
				--GIVE MARCHING ORDERS
				elseif x.ewarstate[index] == 3 then
					if x.ewarmeet[index] == 2 then
						x.ewarmeet[index] = 1
					else
						x.ewarmeet[index] = 2
					end
					for index2 = 1, x.ewarsize[index] do
						if IsAlive(x.ewarrior[index][index2]) then
							if (index == 1 and IsInsideArea("ebasearea", x.frcy)) 
							or (index == 2 and IsInsideArea("ebasearea", x.ffac))
							or (index == 3 and IsInsideArea("ebasearea", x.farm)) then
								Retreat(x.ewarrior[index][index2], "stage4")
								x.ewarmeet[index] = 4
							elseif (index == 1 and not IsInsideArea("fbasearea", x.frcy)) 
							or (index == 2 and not IsInsideArea("fbasearea", x.ffac))
							or (index == 3 and not IsInsideArea("fbasearea", x.farm)) then
								Retreat(x.ewarrior[index][index2], "stage3")
								x.ewarmeet[index] = 3
							elseif x.ewarmeet[index] == 1 then
								Retreat(x.ewarrior[index][index2], "stage1")
							else
								Retreat(x.ewarrior[index][index2], "stage2")
							end
						end
					end
					x.ewarstate[index] = x.ewarstate[index] + 1
				--A UNIT AT STAGE PT
				elseif x.ewarstate[index] == 4 then
					for index2 = 1, x.ewarsize[index] do
						if IsAlive(x.ewarrior[index][index2]) and GetTeamNum(x.ewarrior[index][index2]) ~= 1 
						and ((x.ewarmeet[index] == 1 and GetDistance(x.ewarrior[index][index2], "stage1", 5) < 50) 
							or (x.ewarmeet[index] == 2 and GetDistance(x.ewarrior[index][index2], "stage2", 5) < 50)
							or (x.ewarmeet[index] == 3 and GetDistance(x.ewarrior[index][index2], "stage3", 3) < 50)
							or (x.ewarmeet[index] == 4 and GetDistance(x.ewarrior[index][index2], "stage4") < 50)) then
							x.ewarstate[index] = x.ewarstate[index] + 1
							break
						end
					end
				--GIVE ATTACK ORDER AND CONDUCT UNIT BATTLE
				elseif x.ewarstate[index] == 5 then
					for index2 = 1, x.ewarsize[index] do
						--PICK TARGET FOR EACH ATTACKER
						if IsAlive(x.ewarrior[index][index2]) and GetTeamNum(x.ewarrior[index][index2]) ~= 1 and (not IsAlive(x.ewartrgt[index][index2]) or x.ewartrgt[index][index2] == nil) then
							if index == 1 then
								if IsAlive(x.frcy) then
									x.ewartrgt[index][index2] = x.frcy
								elseif IsAlive(x.ffac) then
									x.ewartrgt[index][index2] = x.ffac
								elseif IsAlive(x.farm) then
									 x.ewartrgt[index][index2] = x.farm
								else
									x.ewartrgt[index][index2] = x.player
								end
								--SetObjectiveName(x.ewarrior[index][index2], ("%d Recy Killer %d"):format(x.ewarwave[index], index2))
								--SetObjectiveOn(x.ewarrior[index][index2])
							elseif index == 2 then
								if IsAlive(x.ffac) then
									x.ewartrgt[index][index2] = x.ffac
								elseif IsAlive(x.farm) then
									x.ewartrgt[index][index2] = x.farm
								elseif IsAlive(x.frcy) then
									x.ewartrgt[index][index2] = x.frcy
								else
									x.ewartrgt[index][index2] = x.player
								end
								--SetObjectiveName(x.ewarrior[index][index2], ("%d Fact Killer %d"):format(x.ewarwave[index], index2))
								--SetObjectiveOn(x.ewarrior[index][index2])
							elseif index == 3 then
								if IsAlive(x.farm) then
									x.ewartrgt[index][index2] = x.farm
								elseif IsAlive(x.ffac) then
									x.ewartrgt[index][index2] = x.ffac
								elseif IsAlive(x.frcy) then
									x.ewartrgt[index][index2] = x.frcy
								else
									x.ewartrgt[index][index2] = x.player
								end
								--SetObjectiveName(x.ewarrior[index][index2], ("%d Armo Killer %d"):format(x.ewarwave[index], index2))
								--SetObjectiveOn(x.ewarrior[index][index2])
							elseif index == 4 then
								if IsAlive(x.fsld) then
									x.ewartrgt[index][index2] = x.fsld
								elseif IsAlive(x.fhqr) then
									x.ewartrgt[index][index2] = x.fhqr
								elseif IsAlive(x.ftec) then
									x.ewartrgt[index][index2] = x.ftec
								elseif IsAlive(x.ftrn) then
									x.ewartrgt[index][index2] = x.ftrn
								elseif IsAlive(x.fbay) then
									x.ewartrgt[index][index2] = x.fbay
								elseif IsAlive(x.fcom) then
									x.ewartrgt[index][index2] = x.fcom
								elseif IsAlive(x.fpwr[4]) then
									x.ewartrgt[index][index2] = x.fpwr[4]
								elseif IsAlive(x.fpwr[3]) then
									x.ewartrgt[index][index2] = x.fpwr[3]
								elseif IsAlive(x.fpwr[2]) then
									x.ewartrgt[index][index2] = x.fpwr[2]
								elseif IsAlive(x.fpwr[1]) then
									x.ewartrgt[index][index2] = x.fpwr[1]
								elseif IsAlive(x.farm) then
									x.ewartrgt[index][index2] = x.farm
								elseif IsAlive(x.ffac) then
									x.ewartrgt[index][index2] = x.ffac
								elseif IsAlive(x.frcy) then
									x.ewartrgt[index][index2] = x.frcy
								else
									x.ewartrgt[index][index2] = x.player
								end
								--SetObjectiveName(x.ewarrior[index][index2], ("%d Base Killer %d"):format(x.ewarwave[index], index2))
								--SetObjectiveOn(x.ewarrior[index][index2])
							else --safety call, shouldn't ever run
								x.ewartrgt[index][index2] = x.player
								--SetObjectiveName(x.ewarrior[index][index2], ("%d Assn Killer %d"):format(x.ewarwave[index], index2))
								--SetObjectiveOn(x.ewarrior[index][index2])
							end
							x.ewarpos[index][index2] = GetPosition(x.ewartrgt[index][index2])  --When used on non-cloak units (other campaigns) makes very difficult, so only for cloaked stuff.
							if not x.ewarabortset[index] then
								x.ewarabort[index] = x.ewartime[index] + 420.0
								x.ewarabortset[index] = true
							end
							x.ewarriortime[index][index2] = GetTime() + 1.0
							x.ewarriorplan[index][index2] = 1
						end
						--GIVE ATTACK (MULTIPLE "ATTACK" USED SO IF 1ST TARGET IS KILLED, WILL ATTACK NEXT TARGET)
						if x.ewarriorplan[index][index2] == 1 and IsAlive(x.ewarrior[index][index2]) and x.ewarriortime[index][index2] < GetTime() then
							Retreat(x.ewarrior[index][index2], x.ewarpos[index][index2])
							x.ewarriorplan[index][index2] = x.ewarriorplan[index][index2] + 1
						end
						--CHECK TARGET STATUS, LOCATION, AND DECLOAK
						if x.ewarriorplan[index][index2] == 2 and GetDistance(x.ewarrior[index][index2], x.ewarpos[index][index2]) < 130 then
              Attack(x.ewarrior[index][index2], x.ewartrgt[index][index2])
							SetCommand(x.ewarrior[index][index2], 48)
							x.ewarriortime[index][index2] = GetTime() + 1.0
							x.ewarriorplan[index][index2] = x.ewarriorplan[index][index2] + 1
						end
						--COMMIT TO ATTACK IF TARGET STILL EXISTS						
						if x.ewarriorplan[index][index2] == 3 and IsAlive(x.ewarrior[index][index2]) and GetTeamNum(x.ewarrior[index][index2]) ~= 1 and x.ewarriortime[index][index2] < GetTime() then
							if not IsAlive(x.ewartrgt[index][index2]) and IsAlive(x.frcy) then  --pick alt target if orig is dead
								x.ewartrgt[index][index2] = x.frcy
							elseif not IsAlive(x.ewartrgt[index][index2]) and not IsAlive(x.frcy) then
								x.ewartrgt[index][index2] = x.player
							end
							Attack(x.ewarrior[index][index2], x.ewartrgt[index][index2])
							x.ewarriortime[index][index2] = GetTime() + 60.0
							x.ewarriorplan[index][index2] = x.ewarriorplan[index][index2] + 1
						end
						--FORCE STRAGGLERS TO UNCLOAK
						if x.ewarriorplan[index][index2] == 4 and IsAlive(x.ewarrior[index][index2]) and GetTeamNum(x.ewarrior[index][index2]) ~= 1 and x.ewarriortime[index][index2] < GetTime() then
							SetCommand(x.ewarrior[index][index2], 48)
							x.ewarriortime[index][index2] = GetTime() + 1.0
							x.ewarriorplan[index][index2] = 3 --HARD RESET TO 3
						end

						--CHECK IF SQUAD MEMBER DEAD
						if not IsAlive(x.ewarrior[index][index2]) or (IsAlive(x.ewarrior[index][index2]) and GetTeamNum(x.ewarrior[index][index2]) == 1) then
							x.ewarriortime[index][index2] = 99999.9
							x.ewartrgt[index][index2] = nil
							x.ewarriorplan[index][index2] = 0
							x.casualty = x.casualty + 1
						end
					end
					
					--DO CASUALTY COUNT
					if x.casualty >= math.floor(x.ewarsize[index] * 0.8) then --reset attack group
						for index2 = 1, x.ewarsize[index] do
							if IsAlive(x.ewarrior[index][index2]) then
								SetCommand(x.ewarrior[index][index2], 48)
							end
						end
						x.ewarabort[index] = 99999.9
						x.ewartime[index] = GetTime() + x.ewartimecool[index] + x.ewartimeadd[index]
						if x.ewarwave[index] == 5 then --extra 120s after max wave to "ease up"
							x.ewartime[index] = GetTime() + x.ewartimecool[index] + x.ewartimeadd[index] + 120.0
						end
						x.ewarstate[index] = 1 --RESET
						x.ewarabortset[index] = false
					end
					x.casualty = 0
					--may be redundant b/c of above change
					for index2 = 1, x.ewarsize[index] do --DIFFERENT B/C EACH UNIT HAS UNIQUE TARGET CALL
						if not IsAlive(x.ewartrgt[index][index2]) then --if orig target gone, then find new one
							if IsAlive(x.frcy) then
								x.ewartrgt[index][index2] = x.frcy
							elseif IsAlive(x.ffac) then
								x.ewartrgt[index][index2] = x.ffac
							elseif IsAlive(x.farm) then
								x.ewartrgt[index][index2] = x.farm
							else
								x.ewartrgt[index][index2] = x.player
							end
							if IsAlive(x.ewarrior[index][index2]) and GetTeamNum(x.ewarrior[index][index2]) ~= 1 then
								Attack(x.ewarrior[index][index2], x.ewartrgt[index][index2])
							end
						end
					end
				end
			end
			
			--ABORT AND RESET IF NEEDED
			if x.ewarabort[index] < GetTime() then
				x.ewartime[index] = GetTime()
				x.ewarstate[index] = 1 --RESET
				x.ewarabort[index] = 99999.9
				x.ewarabortset[index] = false
			end
		end
	end--WARCODE END
	
	--REBUILD AI FACTORY
	if x.efacstate == 0 and not IsAlive(x.efac) then
		x.efactime = GetTime() + 120.0
		x.efacstate = 1
	elseif x.efacstate == 1 and GetDistance(x.player, "epfac") > 420 and x.efactime < GetTime() and IsAlive(x.ercy) then
		x.efac = BuildObject("kbfact", 5, x.efacpos)
		x.efacstate = 0
	end

	--AI GROUP MINELAYERS (limited lives)
	if x.emintime < GetTime() and IsAlive(x.efac) then
		for index = 1, x.eminlength do
			if (not IsAlive(x.emin[index]) or (IsAlive(x.emin[index]) and GetTeamNum(x.emin[index]) == 1)) and not x.eminallow[index] and x.eminlife[index] < 4 then
				x.emincool[index] = GetTime() + 300.0
				x.eminallow[index] = true
			end
			
			if x.eminallow[index] and x.emincool[index] < GetTime() then
				x.emin[index] = BuildObject("kvmine", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
				SetVelocity(x.emin[index], (SetVector(0.0, 0.0, 50.0)))
				SetSkill(x.emin[index], x.skillsetting)
				--SetObjectiveName(x.emin[index], ("Khan %d"):format(index))
				Goto(x.emin[index], ("epmin%d"):format(index)) --resend orders
				x.emingo[index] = true
				x.eminallow[index] = false
				x.eminlife[index] = x.eminlife[index] + 1
				x.emintime = GetTime() + 120.0
			end
			
			if IsAlive(x.emin[index]) and GetCurAmmo(x.emin[index]) <= math.floor(GetMaxAmmo(x.emin[index]) * 0.5) and GetTeamNum(x.emin[index]) ~= 1 then
				SetCurAmmo(x.emin[index], GetMaxAmmo(x.emin[index]))
				Goto(x.emin[index], ("epmin%d"):format(index)) --resend orders
				x.emingo[index] = true
			end
			
			if x.emingo[index] and GetDistance(x.emin[index], ("epmin%d"):format(index)) < 30 and GetTeamNum(x.emin[index]) ~= 1 then
				Mine(x.emin[index], ("epmin%d"):format(index))
				x.emingo[index] = false
			end
		end
	end
	
	--AI GROUP SCAVS 
	if IsAlive(x.ercy) then
		if GetScrap(5) > 39 and not x.wreckbank then --so don't interfere with daywrecker
			SetScrap(5, (GetMaxScrap(5) - 40))
		end
		for index = 1, x.escvlength do
			if x.escvstage[index] == 1 and not IsAlive(x.escv[index]) then
				x.escvtime[index] = GetTime() + 240.0
				x.escvstage[index] = 2
			elseif x.escvstage[index] == 2 and x.escvtime[index] < GetTime() then
				x.escv[index] = BuildObject("kvscav", 5, GetPositionNear("epgrcy", 0, 16, 32)) --grpspwn
				x.escvstage[index] = 1
			end
		end
	end
	
	--AI ARTILLERY ASSASSIN
	if x.ekillarttime < GetTime() and IsAlive(x.efac) then
		for index = 1, x.ekillartlength do
			if (not IsAlive(x.ekillart[index]) or (IsAlive(x.ekillart[index]) and GetTeamNum(x.ekillart[index]) == 1)) and not x.ekillartallow[index] then
				x.ekillartcool[index] = GetTime() + 120.0
				x.ekillartallow[index] = true
			end
			if x.ekillartallow[index] and x.ekillartcool[index] < GetTime() and GetDistance(x.player, "epgfac") > 300 then
				x.ekillart[index] = BuildObject("kvtank", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
				SetSkill(x.ekillart[index], x.skillsetting)
				--SetObjectiveName(x.ekillart[index], "Artl Killer")
				if IsAlive(x.ercy) then
					Defend2(x.ekillart[index], x.ercy)
				else
					Defend2(x.ekillart[index], x.efac)
				end
				x.ekillartallow[index] = false
			end
		end
		for index = 1, x.fartlength do
			if IsAlive(x.fart[index]) and GetDistance(x.fart[index], x.ercy) < 600 then
				x.ekillarttarget = x.fart[index]
				x.ekillartmarch = true
				break
			end
		end
		if x.ekillartmarch then
			for index = 1, x.ekillartlength do
        if IsAlive(x.ekillart[index]) and GetTeamNum(x.ekillart[index]) ~= 1 then
          Attack(x.ekillart[index], x.ekillarttarget)
        end
			end
			x.ekillarttime = GetTime() + 180.0 --give time for attack
			x.ekillartmarch = false
		end
	end
	
	--CHECK STATUS OF MCA 
	if not x.MCAcheck then
		if not IsAlive(x.frcy) and x.spine < 666 then --production lost
			x.audio6 = AudioMessage("tcdw0312.wav") --FAIL - recy lost
			ClearObjectives()
			AddObjective("Recycler destroyed.\n\nMISSION FAILED!", "RED")
			x.spine = 666
		end
		
		if x.spine == 666 and IsAudioMessageDone(x.audio6) then
			FailMission(GetTime(), "tcdw07f1.des") --LOSER LOSER LOSER
			x.MCAcheck = true
		end
	end
end
--[[END OF SCRIPT]]