--bztcss12 - Battlezone Total Command - Stars and Stripes - 12/17 - TOTAL DESTRUCTION
assert(load(assert(LoadFile("_requirefix.lua")),"_requirefix.lua"))();
TCC = require("TC_Core")
MisnNum = 46;
--DECLARE variables --f-friend, e-enemy, atk-attack, rcy-recycler, etc...
local index = 0
local index2 = 0
local indexadd = 0
local x = {
	FIRST = true,
--	rep = require("_MCModule");
	MCAcheck = false, 
	player = nil, 
	mytank = nil, 
	skillsetting = 0,
	easy = 0, 
	medium = 1, 
	hard = 2, 
	pos = {}, 
	waittime = 99999.9, 
	audio1 = nil, 
	camfov = 60,  --185 default
	userfov = 90,  --seed
	spine = 0, 
	casualty = 0, 
	randompick = 0, 
	randomlast = 0, 
	eartstate = 0, --artilery atk vars
	earttime = 99999.9, 
	eartaborttime = 99999.9, 
	eart = {}, 
	eartlength = 2,	
	eartshooter = nil,
	gotshooter = false, 
	slidestate = 0, --slide vars
	slideafter = false, 
	slidecomplete = false, 
	fpkgstate = 0, --package vars
	fpkgtime = 99999.9, 
	fpkg = nil,
	pool = {}, 
	efac = nil, --no ercy
	earm = nil, 
	ebnk = nil, 
	ebay = nil, 
	esil = {}, 
	frcy = nil, 
	ffac = nil, 
	farm = nil,	 
	fgrp = {}, 
	epvalt = nil, 
	epvaltpos = {}, 
	wreckstate = 0, --daywrecker
	wrecktime = 99999.9, 
	wrecktrgt = {},
	wreckbomb = nil, 
	wreckname = "apdwrks", 
	wreckbank = false, --have 2
	wrecknotify = 0, 
	wreckstart = false, 
	emintime = 99999.9, --eminelayers
	eminlife = {}, 
	emingo = {}, 
	emin = {}, 
	emincool = {}, 
	eminallow = {},	
	eturtime = 99999.9, --eturret
	eturlength = 14,
	etur = {}, 
	eturcool = {}, 
	eturallow = {}, 
	eturlife = {}, 
	epattime = 99999.9, --patrols
	epatlength = 8, 
	epat = {}, 
	epatcool = {}, 
	epatallow = {}, 
	epatlife = {}, 
	fpwr = {nil, nil, nil, nil}, 
	fcom = nil, 
	fbay = nil, 
	ftrn = nil, 
	ftec = nil, 
	fhqr = nil, 
	fsld = nil, 
	fartlength = 100, --fart killers
	fart = {}, 
	ekillarttime = 99999.9,
	ekillartlength = 4, 
	ekillart = {}, 
	ekillartcool = {}, 
	ekillartallow = {}, 
	ekillarttarget = nil, 
	ekillartmarch = false, 
	escv = {}, --scav stuff
	escvlength = 2, 
	wreckbank = false, --have 2
	escvbuildtime = {}, 
	escvstate = {}, 
	ewardeclare = false, --WARCODE --1 recy, 2 fact, 3 armo, 4 base 
	ewartotal = 4, 
	ewarrior = {}, 
	ewartrgt = {}, 
	ewartime = {},
	ewartimecool = {},
	ewartimeadd = {},
	ewarabort = {}, 
	ewarstate = {}, 
	ewarsize = {}, 
	ewarwave = {}, 
	ewarwavemax = {}, 
	ewarwavereset = {}, 
	ewarmeet = {}, 
	weappick = 0, 
	weaplast = 0, 
	LAST = true
}
--PATHS: fprcy, fpg1-8, epalt (no epgrcy or epgfac), eptur0-14(21 avail), x.epart1-2, ppatrol1-7, fppkg, stage1-2

function InitialSetup()
	SetAutoGroupUnits(true)
	
	local odfpreload = {
		"avrecyss12", "avscout", "avmbike", "avtank", "avturr", "avhtnk", "epvalt00", "epvalt01", "apdwrks", "svscav", 
		"svturr", "svscout", "svmbike", "svmisl", "svtank", "svrckt", "svwalk", "svstnk", "svartl", "svmine", "apcamra"
	}
	for k,v in pairs(odfpreload) do
		PreloadODF(v)
	end
	
	x.mytank = GetHandle("mytank")
	x.frcy = GetHandle("frcy")
	for index = 1, 8 do
		x.fgrp[index] = GetHandle(("fgrp%d"):format(index))
	end
	x.efac = GetHandle("efac")
	x.earm = GetHandle("earm")
	x.ebnk = GetHandle("ebnk")
	x.ebay = GetHandle("ebay")
	x.etrn = GetHandle("etrn")
	x.etec = GetHandle("etec")
	for index = 1, 6 do --silos
		x.esil[index] = GetHandle(("escup%d"):format(index))
	end
	x.epvalt = GetHandle("epvalt00")
	Ally(1, 2) --1 player
	Ally(2, 1) --2 vault
	Ally(5, 2) --5 enemy
	Ally(2, 5)
	SetColorFade(6.0, 0.5, "BLACK")
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
	if (not IsAlive(x.farm) or x.farm == nil) and (IsOdf(h, "avarmoss12:1") or IsOdf(h, "abarmoss12")) then
		x.farm = RepObject(h);
		h = x.farm;
	elseif (not IsAlive(x.ffac) or x.ffac == nil) and (IsOdf(h, "avfactss12:1") or IsOdf(h, "abfactss12")) then
		x.ffac = h
	elseif (not IsAlive(x.fsld) or x.fsld == nil) and IsOdf(h, "abshld") then
		x.fsld = h
	elseif (not IsAlive(x.fhqr) or x.fhqr == nil) and IsOdf(h, "abhqtr") then
		x.fhqr = h
	elseif (not IsAlive(x.ftec) or x.ftec == nil) and IsOdf(h, "abtcen") then
		x.ftec = h
	elseif (not IsAlive(x.ftrn) or x.ftrn == nil) and IsOdf(h, "abtrain") then
		x.ftrn = h
	elseif (not IsAlive(x.fbay) or x.fbay == nil) and IsOdf(h, "absbay") then
		x.fbay = h
	elseif (not IsAlive(x.fcom) or x.fcom == nil) and IsOdf(h, "abcbun") then
		x.fcom = h
	elseif IsOdf(h, "abpgen0") then
		for indexadd = 1, 4 do
			if x.fpwr[indexadd] == nil or not IsAlive(x.fpwr[indexadd]) then
				x.fpwr[indexadd] = h;
				break
			end
		end
	elseif (IsAlive(h) or IsPlayer(h)) then
		ReplaceStabber(h);
	end
	
	--get friendly artil
	if (IsOdf(h, "avartl:1")) then
		table.insert(x.fart, h);
	end
	--[[
	for indexadd = 1, x.fartlength do --new artillery? 
		if (not IsAlive(x.fart[indexadd]) or x.fart[indexadd] == nil) and IsOdf(h, "avartl:1") then
			x.fart[indexadd] = h
		end
	end
	]]--
	--get daywrecker for highlight
	if (not IsAlive(x.wreckbomb) or x.wreckbomb == nil) and IsOdf(h, x.wreckname) then 
		if GetTeamNum(h) == 5 then
			x.wreckbomb = h --get handle to launched daywrecker
		end
	end
	TCC.AddObject(h)
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
	TCC.Update()
	
	--[[TEST CUTSCENE	
	if x.spine == 0 then 
		x.epvaltpos = GetTransform(x.epvalt)
		RemoveObject(x.epvalt)
		RemoveObject(x.ebay)
		RemoveObject(x.ebnk)
		x.slidetime = GetTime() + 6.0
		x.spine = 1000
	end--]]

	--START THE MISSION BASICS
	if x.spine == 0 then
		for index = 1, 2 do
			x.pos = GetTransform(x.fgrp[index])
			RemoveObject(x.fgrp[index])
			x.fgrp[index] = BuildObject("avscout", 1, x.pos)
			x.pos = GetTransform(x.fgrp[index+2])
			RemoveObject(x.fgrp[index+2])
			x.fgrp[index+2] = BuildObject("avmbike", 1, x.pos)
			x.pos = GetTransform(x.fgrp[index+4])
			RemoveObject(x.fgrp[index+4])
			x.fgrp[index+4] = BuildObject("avtank", 1, x.pos)
			x.pos = GetTransform(x.fgrp[index+6])
			RemoveObject(x.fgrp[index+6])
			x.fgrp[index+6] = BuildObject("avturr", 1, x.pos)
		end
		for index = 1, 6 do
			SetGroup(x.fgrp[index], 0)
		end
		SetGroup(x.fgrp[7], 5)
		SetGroup(x.fgrp[8], 5)
		x.pos = GetTransform(x.frcy)
		RemoveObject(x.frcy)
		x.frcy = BuildObject("avrecyss12", 1, x.pos)
		x.pos = GetTransform(x.mytank)
		RemoveObject(x.mytank)
		x.mytank = BuildObject("avtank", 1, x.pos)
		SetAsUser(x.mytank, 1)
		RemoveObject(x.player)
		x.player = GetPlayerHandle()
		x.epvaltpos = GetTransform(x.epvalt)
		RemoveObject(x.epvalt)
		x.epattime = GetTime() + 180.0
		for index = 1, x.epatlength do --init epat
			x.epatcool[index] = GetTime()
			x.epatallow[index] = true
			x.epatlife[index] = 0
		end
		x.eturtime = GetTime()
		for index = 1, x.eturlength do --init etur
			x.eturcool[index] = GetTime()
			x.eturallow[index] = true
			x.eturlife[index] = 0
		end
		for index = 1, x.ewartotal do --init WARCODE
			x.ewardeclare = true
			x.ewarrior[index] = {} --"rows"
			for index2 = 1, 10 do --10 per wave max avail
				x.ewarrior[index][index2] = nil --"columns", init (handle in this case)
			end
			x.ewartrgt[index] = nil
			x.ewarstate[index] = 1
			x.ewartime[1] = GetTime() + 60.0 --recy
			x.ewartime[2] = GetTime() + 90.0 --fact
			x.ewartime[3] = GetTime() + 120.0 --armo
			x.ewartime[4] = GetTime() + 150.0 --base
			x.ewartimecool[index] = 240.0
			x.ewartimeadd[index] = 5.0
			x.ewarabort[index] = 99999.9
			x.ewarsize[index] = 0
			x.ewarwave[index] = 0
			x.ewarwavemax[index] = 5
			x.ewarwavereset[index] = 2
			x.ewarmeet[index] = 2
		end
		for index = 1, x.escvlength do --init escv
			x.escvbuildtime[index] = GetTime()
			x.escvstate[index] = 1
		end
		for index = 1, x.ekillartlength do --init ekillart
			x.ekillarttime = GetTime()
			x.ekillart[index] = nil 
			x.ekillartcool[index] = 99999.9 
			x.ekillartallow[index] = false
		end
		x.emintime = GetTime() --init emine
		x.eminlife[1] = 0
		x.eminlife[2] = 0
		x.earttime = GetTime() + 600.0
		x.waittime = GetTime() + 1800.0 --30min --FOR LANDSLIDE
		SetScrap(1, 40)
		x.audio1 = AudioMessage("tcss1200.wav") --INTRO - Lib and Free on to Titan. Justice orbit. Texas 2U
		x.spine = x.spine + 1
	end

	--SEND OBJECTIVE MESSAGE
	if x.spine == 1 and IsAudioMessageDone(x.audio1) then
		ClearObjectives()
		AddObjective("tcss1200.txt")
		x.spine = x.spine + 1
	end
	----------END MAIN SPINE ----------

	--CCA ARTILLERY ATTACK FRCY 
	if x.eartstate == 0 and IsAlive(x.ffac) and IsOdf(x.ffac, "abfactss12") then
		x.eartstate = x.eartstate + 1
	elseif x.eartstate == 1 and IsAlive(x.ebay) and IsAlive(x.ebnk) and x.earttime < GetTime() then
		for index = 1, x.eartlength do
			x.gotshooter = false
			x.eart[index] = BuildObject("svartl", 5, "epalt")
			SetSkill(x.eart[index], x.skillsetting)
			--SetObjectiveName(x.eart[index],("Cannoneer %d"):format(index))
			Goto(x.eart[index], ("epart%d"):format(index))
			x.eartaborttime = GetTime() + 720.0
		end
		x.eartstate = x.eartstate + 1
	elseif x.eartstate == 2 then
		for index = 1, x.eartlength do
			if GetDistance(x.eart[index], ("epart%d"):format(index)) < 20 then
				Attack(x.eart[1], x.frcy)
				Attack(x.eart[2], x.frcy)
				x.eartstate = x.eartstate + 1
				break
			end
		end
	elseif x.eartstate == 3 then
		if not x.gotshooter then
			x.eartshooter = GetWhoShotMe(x.frcy)
			for index = 1, x.eartlength do
				if x.eartshooter == x.eart[index] then
					if GetDistance(x.frcy, "fprcy") <= 200 then
						AudioMessage("tcss1202.wav") --Grz1. Sov artillery attacking from plateau
					else
						AudioMessage("tcss1206.wav") --Grz1. Sov artillery attacking -NO plateau
					end
					x.eartaborttime = 99999.9
					x.gotshooter = true
				end
			end
		end
		
		for index = 1, x.eartlength do
			if not IsAlive(x.eart[index]) then
				x.casualty = x.casualty + 1
			end
		end
		if x.casualty == x.eartlength then
			for index = 1, 12 do
				x.randompick = math.floor(GetRandomFloat(1.0, 9.0))
			end
			if x.randompick == 1 or x.randompick == 4 or x.randompick == 7 then
				x.earttime = GetTime() + 480.0
			elseif x.randompick == 2 or x.randompick == 5 or x.randompick == 8 then
				x.earttime = GetTime() + 360.0
			else
				x.earttime = GetTime() + 240.0
			end
			x.eartstate = 1 --reset to 1
		end
		x.casualty = 0
	end
	
	--ABORT ARTIL IF NECESSARY
	if x.eartaborttime < GetTime() or (x.eartstate > 1 and not IsAlive(x.eart[1]) and not IsAlive(x.eart[2])) then
		for index = 1, x.eartlength do
			x.eart[index] = nil
		end
		x.gotshooter = false
		x.earttime = GetTime() + 30.0
		x.eartaborttime = 99999.9
		x.eartstate = 0
	end

	--DELIVER THE PACKAGE
	if x.fpkgstate == 0 and (not IsAlive(x.esil[1]) or not IsAlive(x.esil[3]) or not IsAlive(x.esil[5])) then
		x.fpkgtime = GetTime() + 120.0
		x.fpkgstate = x.fpkgstate + 1
	elseif x.fpkgstate == 1 and x.fpkgtime < GetTime() then
		x.fpkg = BuildObject("avhtnk", 2, "fppkg")
		KillPilot(x.fpkg)
		SetObjectiveName(x.fpkg, "Special Package")
		SetObjectiveOn(x.fpkg)
		AudioMessage("alertpulse.wav")
		ClearObjectives()
		AddObjective("tcss1200.txt")
		AddObjective("	")
		AddObjective("tcss1203.txt", "ALLYBLUE")
		x.fpkgstate = x.fpkgstate + 1
	elseif x.fpkgstate == 2 and IsAlive(x.fpkg) and GetDistance(x.player, x.fpkg) < 30 then
		SetObjectiveName(x.fpkg, GetODFString(x.fpkg, "GameObjectClass", "unitName")) --in case vehicle given is changed
		SetObjectiveOff(x.fpkg)
		ClearObjectives()
		AddObjective("tcss1200.txt")
		x.fpkgstate = x.fpkgstate + 1
	end

	--ICE SLIDE CINEMATIC
	if x.slidestate == 0 and (not IsAlive(x.ebnk) or not IsAlive(x.ebay) or not IsAlive(x.esil[2]) or not IsAlive(x.esil[4]) or not IsAlive(x.esil[6])) then
		x.waittime = GetTime() + 120.0
		x.slidestate = x.slidestate + 1 
	elseif x.slidestate == 1 and x.waittime < GetTime() then
		x.epvalt = BuildObject("epvalt00", 0, x.epvaltpos)
		StartEarthQuake(80) --80 good solid quake
		x.waittime = GetTime() + 10.0
		x.slidestate = x.slidestate + 1 
	elseif x.slidestate == 2 and x.waittime < GetTime() and IsCraftButNotPerson(x.player) then
		SetCurHealth(x.player, GetMaxHealth(x.player))
		StopEarthQuake()
		StartSoundEffect("xcollapse.wav")  
		SetAnimation(x.epvalt, "landslide", 1)
    x.userfov = IFace_GetInteger("options.graphics.defaultfov")
    CameraReady()
    IFace_SetInteger("options.graphics.defaultfov", x.camfov)
		x.waittime = GetTime() + 10.0
		x.slidestate = x.slidestate + 1
	elseif x.slidestate == 3 and CameraPath("pcam1", 5000, 750, x.epvalt) then --(x.waittime < GetTime() or CameraCancelled()) then
    CameraFinish()
    IFace_SetInteger("options.graphics.defaultfov", x.userfov)
		x.pos = GetTransform(x.epvalt)
		RemoveObject(x.epvalt)
		x.epvalt = BuildObject("epvalt01", 2, x.pos) --2 so will be blue
		ClearObjectives()
		AddObjective("tcss1204.txt", "YELLOW", 10.0)
		SetObjectiveOn(x.epvalt)
		SetObjectiveName(x.epvalt, "Cthonian Ruin")
		x.waittime = GetTime() + 11.0
		x.slidestate = x.slidestate + 1
	elseif x.slidestate == 4 and x.waittime < GetTime() then
		SetObjectiveOff(x.epvalt)
		TCC.SetTeamNum(x.epvalt, 0)
		ClearObjectives()
		AddObjective("tcss1200.txt")
		if x.fpkgstate == 2 then
			AddObjective("tcss1203.txt", "ALLYBLUE")
		end
		x.slidecomplete = true --see MCA section
		x.slidestate = x.slidestate + 1
	end

	--CCA GROUP TURRET GENERIC
	if x.eturtime < GetTime() then
		for index = 1, x.eturlength do
			if not IsAlive(x.etur[index]) and not x.eturallow[index] and x.eturlife[index] < 3 then
				x.eturcool[index] = GetTime() + 180.0
				x.eturallow[index] = true
			end
			if x.eturallow[index] and x.eturcool[index] < GetTime() then
				x.etur[index] = BuildObject("svturr", 5, "epalt")
				SetSkill(x.etur[index], x.skillsetting)
				--SetObjectiveName(x.etur[index], ("Adder %d"):format(index))
				Goto(x.etur[index], ("eptur%d"):format(index)) --path pt doesn't work
				x.eturallow[index] = false
				x.eturlife[index] = x.eturlife[index] + 1
			end
		end
		x.eturtime = GetTime() + 30.0
	end

	--CCA GROUP SCOUT PATROLS ------SPECIAL SIZE------------------------
	if x.epattime < GetTime() then
		for index = 1, x.epatlength do
			if not IsAlive(x.epat[index]) and not x.epatallow[index] and x.epatlife[index] < 6 then
				x.epatcool[index] = GetTime() + 300.0
				x.epatallow[index] = true
			end
			if x.epatallow[index] and x.epatcool[index] < GetTime() then
				if index == 1 then
					x.epat[index] = BuildObject("svscout", 5, "epalt")
					Patrol(x.epat[index], "ppatrol1")
				elseif index == 2 then
					x.epat[index] = BuildObject("svmbike", 5, "epalt")
					Patrol(x.epat[index], "ppatrol2")
				elseif index == 3 then
					x.epat[index] = BuildObject("svmisl", 5, "epalt")
					Patrol(x.epat[index], "ppatrol3")
				elseif index == 4 then
					x.epat[index] = BuildObject("svtank", 5, "epalt")
					Patrol(x.epat[index], "ppatrol4")
				elseif index == 5 then
					x.epat[index] = BuildObject("svtank", 5, "epalt")
					Patrol(x.epat[index], "ppatrol5")
				elseif index == 6 then
					x.epat[index] = BuildObject("svmisl", 5, "epalt")
					Patrol(x.epat[index], "ppatrol6")
				elseif index == 7 then --patrol Comm Tower
					x.epat[index] = BuildObject("svtank", 5, "epalt")
					Patrol(x.epat[index], "ppatrol7")
				elseif index == 8 then --patrol Comm Tower
					x.epat[index] = BuildObject("svtank", 5, "epalt")
					Patrol(x.epat[index], "ppatrol8")
				end
				SetSkill(x.epat[index], x.skillsetting)
				--SetObjectiveName(x.epat[index], ("Patrol %d"):format(index))
				x.epatlife[index] = x.epatlife[index] + 1
				x.epatallow[index] = false
			end
		end
		x.epattime = GetTime() + 30.0
	end
	
	--WARCODE --special this mission no fac replace
	if x.ewardeclare then
		for index = 1, x.ewartotal do	
			if x.ewartime[index] < GetTime() then 
			--SET WAVE NUMBER AND BUILD SIZE
				if x.ewarstate[index] == 1 then
					x.ewarwave[index] = x.ewarwave[index] + 1
					if x.ewarwave[index] > x.ewarwavemax[index] then
						x.ewarwave[index] = x.ewarwavereset[index]
					end
					if x.ewarwave[index] == 1 then
						x.ewarsize[index] = 2
					elseif x.ewarwave[index] == 2 then
						x.ewarsize[index] = 3
					elseif x.ewarwave[index] == 3 then
						x.ewarsize[index] = 4
					elseif x.ewarwave[index] == 4 then
						x.ewarsize[index] = 6
					else --5
						x.ewarsize[index] = 8
					end
					x.ewarstate[index] = x.ewarstate[index] + 1
				end
				
				--BUILD FORCE
				if x.ewarstate[index] == 2 then
					for index2 = 1, x.ewarsize[index] do
						while x.randompick == x.randomlast do --random the random
							x.randompick = math.floor(GetRandomFloat(1.0, 18.0))
						end
						x.randomlast = x.randompick
						if x.randompick == 1 or x.randompick == 8 or x.randompick == 15 then
							x.ewarrior[index][index2] = BuildObject("svscout", 5, GetPositionNear("epalt", 0, 16, 32)) --grpspwn
							if x.ewarwave[index] == 3 or x.ewarwave[index] == 4 then
								GiveWeapon(x.ewarrior[index][index2], "gcarba_c") --"glasea_c")
							end
						elseif x.randompick == 2 or x.randompick == 9 or x.randompick == 16 then
							x.ewarrior[index][index2] = BuildObject("svmbike", 5, GetPositionNear("epalt", 0, 16, 32)) --grpspwn
							if x.ewarwave[index] == 2 or x.ewarwave[index] == 4 then
								GiveWeapon(x.ewarrior[index][index2], "gstbva_c")
							end
						elseif x.randompick == 3 or x.randompick == 10 or x.randompick == 17 then
							x.ewarrior[index][index2] = BuildObject("svmisl", 5, GetPositionNear("epalt", 0, 16, 32)) --grpspwn
							if x.ewarwave[index] == 3 or x.ewarwave[index] == 5 then
								GiveWeapon(x.ewarrior[index][index2], "gfafma_c")
							end
						elseif x.randompick == 4 or x.randompick == 11 or x.randompick == 14 or x.randompick == 18 then
							x.ewarrior[index][index2] = BuildObject("svtank", 5, GetPositionNear("epalt", 0, 16, 32)) --grpspwn
							if x.ewarwave[index] == 4 or x.ewarwave[index] == 5 then
								GiveWeapon(x.ewarrior[index][index2], "gstbsa_c")
							end
						elseif x.randompick == 5 or x.randompick == 12 then
							x.ewarrior[index][index2] = BuildObject("svrckt", 5, GetPositionNear("epalt", 0, 16, 32)) --grpspwn
							if x.ewarwave[index] == 3 or x.ewarwave[index] == 5 then
								GiveWeapon(x.ewarrior[index][index2], "gshdwa_a") --salvo rckt
							end
						elseif x.randompick == 6 or x.randompick == 13 then
							if x.ewarwave[index] == 3 or x.ewarwave[index] == 5 and IsAlive(x.ebnk) then
								x.ewarrior[index][index2] = BuildObject("svwalk", 5, GetPositionNear("epalt", 0, 16, 32)) --grpspwn
								while x.weappick == x.weaplast do --random the random
									x.weappick = math.floor(GetRandomFloat(1.0, 12.0))
								end
								x.weaplast = x.weappick
								if x.weappick == 1 or x.weappick == 5 or x.weappick == 9 then
									GiveWeapon(x.ewarrior[index][index2], "gblsta_a")
								elseif x.weappick == 2 or x.weappick == 6 or x.weappick == 10 then
									GiveWeapon(x.ewarrior[index][index2], "gflsha_a")
								elseif x.weappick == 3 or x.weappick == 7 or x.weappick == 11 then
									GiveWeapon(x.ewarrior[index][index2], "gstbva_a")
								else
									GiveWeapon(x.ewarrior[index][index2], "gstbta_a")
								end
							else --too hard if comes in very first or second wave
								x.ewarrior[index][index2] = BuildObject("svtank", 5, GetPositionNear("epalt", 0, 16, 32)) --grpspwn
							end
						else --7
							if x.ewarwave[index] == 4 or x.ewarwave[index] == 5 and (GetMaxScrap(5) >= 80) then
								x.ewarrior[index][index2] = BuildObject("svstnk", 5, "epalt")
								while x.weappick == x.weaplast do --random the random
									x.weappick = math.floor(GetRandomFloat(1.0, 12.0))
								end
								x.weaplast = x.weappick
								if x.weappick == 1 or x.weappick == 5 or x.weappick == 9 then
									GiveWeapon(x.ewarrior[index][index2], "gstbpa_a") --pulse stab default
								elseif x.weappick == 2 or x.weappick == 6 or x.weappick == 10 then
									GiveWeapon(x.ewarrior[index][index2], "gblsta_a") --blast
								elseif x.weappick == 3 or x.weappick == 7 or x.weappick == 11 then
									GiveWeapon(x.ewarrior[index][index2], "gstbaa_a") --at stab (tag can OP)
								else
									GiveWeapon(x.ewarrior[index][index2], "gstbsa_a") --super (stilleto OP)
								end
							else --too hard if comes in very first or second wave
								x.ewarrior[index][index2] = BuildObject("svtank", 5, GetPositionNear("epalt", 0, 16, 32)) --grpspwn
							end
						end
						SetSkill(x.ewarrior[index][index2], x.skillsetting)
						if index2 % 3 == 0 then
							SetSkill(x.ewarrior[index][index2], x.skillsetting+1)
						end
					end
					x.ewarabort[index] = GetTime() + 360.0 --here first in case stage goes wrong
					x.ewarstate[index] = x.ewarstate[index] + 1
				end
				
				--GIVE MARCHING ORDERS
				if x.ewarstate[index] == 3 then
					if x.ewarmeet[index] == 2 then
						x.ewarmeet[index] = 1
					else
						x.ewarmeet[index] = 2
					end
					for index2 = 1, x.ewarsize[index] do
						if IsAlive(x.ewarrior[index][index2]) then
							Goto(x.ewarrior[index][index2], ("stage%d"):format(x.ewarmeet[index]))
						end
					end
					x.ewarstate[index] = x.ewarstate[index] + 1
				end
				
				--A UNIT AT STAGE PT
				if x.ewarstate[index] == 4 then
					for index2 = 1, x.ewarsize[index] do
						if IsAlive(x.ewarrior[index][index2]) and (GetDistance(x.ewarrior[index][index2], ("stage%d"):format(x.ewarmeet[index])) < 100) and GetTeamNum(x.ewarrior[index][index2]) ~= 1 then
							x.ewarstate[index] = x.ewarstate[index] + 1
							break
						end
					end
				end
				
				--GIVE ATTACK ORDER
				if x.ewarstate[index] == 5 then
					for index2 = 1, x.ewarsize[index] do
						if IsAlive(x.ewarrior[index][index2]) and GetTeamNum(x.ewarrior[index][index2]) ~= 1 then
							if index == 1 then
								if IsAlive(x.frcy) then
									x.ewartrgt[index] = x.frcy
								elseif IsAlive(x.ffac) then
									x.ewartrgt[index] = x.ffac
								elseif IsAlive(x.farm) then
									x.ewartrgt[index] = x.farm
								else
									x.ewartrgt[index] = x.player
								end
								--SetObjectiveName(x.ewarrior[index][index2], ("Recy Killer %d"):format(index2))
							elseif index == 2 then
								if IsAlive(x.ffac) then
									x.ewartrgt[index] = x.ffac
								elseif IsAlive(x.farm) then
									x.ewartrgt[index] = x.farm
								elseif IsAlive(x.frcy) then
									x.ewartrgt[index] = x.frcy
								else
									x.ewartrgt[index] = x.player
								end
								--SetObjectiveName(x.ewarrior[index][index2], ("Fact Killer %d"):format(index2))
							elseif index == 3 then
								if IsAlive(x.farm) then
									x.ewartrgt[index] = x.farm
								elseif IsAlive(x.ffac) then
									x.ewartrgt[index] = x.ffac
								elseif IsAlive(x.frcy) then
									x.ewartrgt[index] = x.frcy
								else
									x.ewartrgt[index] = x.player
								end
								--SetObjectiveName(x.ewarrior[index][index2], ("Armo Killer %d"):format(index2))
							elseif index == 4 then
								if IsAlive(x.fsld) then
									x.ewartrgt[index] = x.fsld
								elseif IsAlive(x.fhqr) then
									x.ewartrgt[index] = x.fhqr
								elseif IsAlive(x.ftec) then
									x.ewartrgt[index] = x.ftec
								elseif IsAlive(x.ftrn) then
									x.ewartrgt[index] = x.ftrn
								elseif IsAlive(x.fbay) then
									x.ewartrgt[index] = x.fbay
								elseif IsAlive(x.fcom) then
									x.ewartrgt[index] = x.fcom
								elseif IsAlive(x.fpwr[4]) then
									x.ewartrgt[index] = x.fpwr[4]
								elseif IsAlive(x.fpwr[3]) then
									x.ewartrgt[index] = x.fpwr[3]
								elseif IsAlive(x.fpwr[2]) then
									x.ewartrgt[index] = x.fpwr[2]
								elseif IsAlive(x.fpwr[1]) then
									x.ewartrgt[index] = x.fpwr[1]
								elseif IsAlive(x.farm) then
									x.ewartrgt[index] = x.farm
								elseif IsAlive(x.ffac) then
									x.ewartrgt[index] = x.ffac
								elseif IsAlive(x.frcy) then
									x.ewartrgt[index] = x.frcy
								else
									x.ewartrgt[index] = x.player
								end
								--SetObjectiveName(x.ewarrior[index][index2], ("Kill Base %d"):format(index2))
							else --safety call --shouldn't ever run
								x.ewartrgt[index] = x.player
								--SetObjectiveName(x.ewarrior[index][index2], ("Mass Assassin %d"):format(index2))
							end
							Attack(x.ewarrior[index][index2], x.ewartrgt[index])
							x.ewarabort[index] = x.ewartime[index] + 420.0
						end
					end
					x.ewarstate[index] = x.ewarstate[index] + 1
				end
				
				--CHECK CASUALTY AND RESET
				if x.ewarstate[index] == 6 then
					for index2 = 1, x.ewarsize[index] do
						if not IsAlive(x.ewarrior[index][index2]) or (IsAlive(x.ewarrior[index][index2]) and GetTeamNum(x.ewarrior[index][index2]) == 1) then
							x.casualty = x.casualty + 1
						end
					end
					if x.casualty >= math.floor(x.ewarsize[index] * 0.8) then
						x.ewarabort[index] = 99999.9
						x.ewartime[index] = GetTime() + x.ewartimecool[index] + x.ewartimeadd[index]
						if x.ewarwave[index] == 5 then --extra time after last wave to "ease up"
							x.ewartime[index] = GetTime() + x.ewartimecool[index] + x.ewartimeadd[index] + 120.0
						end
						x.ewarstate[index] = 1 --RESET
					end
					x.casualty = 0
					
					if not IsAlive(x.ewartrgt[index]) then --if orig target gone, then find new one
						if IsAlive(x.frcy) then
							x.ewartrgt[index] = x.frcy
						elseif IsAlive(x.ffac) then
							x.ewartrgt[index] = x.ffac
						elseif IsAlive(x.farm) then
							x.ewartrgt[index] = x.farm
						else
							x.ewartrgt[index] = x.player
						end
						for index2 = 1, x.ewarsize[index] do
							if IsAlive(x.ewarrior[index][index2]) and GetTeamNum(x.ewarrior[index][index2]) ~= 1 then
								Attack(x.ewarrior[index][index2], x.ewartrgt[index])
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
			end
		end
	end--WARCODE END
	
	--AI ARTILLERY ASSASSIN

	
	if x.ekillarttime < GetTime() and IsAlive(x.efac) then
		for index = 1, x.ekillartlength do
			if (not IsAlive(x.ekillart[index]) or (IsAlive(x.ekillart[index]) and GetTeamNum(x.ekillart[index]) == 1)) and not x.ekillartallow[index] then
				x.ekillartcool[index] = GetTime() + 120.0
				x.ekillartallow[index] = true
			end
			if x.ekillartallow[index] and x.ekillartcool[index] < GetTime() and GetDistance(x.player, "epgfac") > 300 then
				x.ekillart[index] = BuildObject("svtank", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
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
			x.ekillartmarch = false
			x.ekillarttime = GetTime() + 180.0 --give time for attack
		end
	end
	
	--START DAYWRECKER BASE ON PLAYER FACTORY
	if not x.wreckstart and IsAlive(x.ffac) then
		x.wrecktime = GetTime() + 300.0
		x.wreckstart = true
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
		elseif x.skillsetting == x.hard and GetDistance(x.wreckbomb, x.wrecktrgt) < 200 then
			x.wrecknotify = 1
		end
		if x.wrecknotify == 1 then
      TCC.SetTeamNum(x.wreckbomb, 5)
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
			x.wrecktime = GetTime() + 480.0 --MORE TIME SINCE ARTIL ATTACK TOO
		elseif x.randompick == 2 or x.randompick == 5 or x.randompick == 8 then
			x.wrecktime = GetTime() + 420.0
		else
			x.wrecktime = GetTime() + 360.0
		end
		x.wreckstate = 0 --reset
	end

	--SPECIAL NO ERCY USE EFAC - BUILD CCA SCAVS FOR LOOKS (like orig had scavs)
	if IsAlive(x.efac) then
		if GetScrap(5) > 39 and not x.wreckbank then --don't interfere with daywrecker
			SetScrap(5, (GetMaxScrap(5) - 40))
		end
		for index = 1, x.escvlength do
			if x.escvstate[index] == 1 and not IsAlive(x.escv[index]) then
				x.escvbuildtime[index] = GetTime() + 180.0
				x.escvstate[index] = 2
			elseif x.escvstate[index] == 2 and x.escvbuildtime[index] < GetTime() then
				x.escv[index] = BuildObject("svscav", 5, "epalt")
				x.escvstate[index] = 1
			end
		end
	end

	--CCA MINELAYER SQUAD
	if x.emintime < GetTime() then
		for index = 1, 2 do
			if (not IsAlive(x.emin[index]) or (IsAlive(x.emin[index]) and GetTeamNum(x.emin[index]) == 1)) and not x.eminallow[index] and x.eminlife[index] < 4 then
				x.emincool[index] = GetTime() + 240.0
				x.eminallow[index] = true
			end
			
			if x.eminallow[index] and x.emincool[index] < GetTime() then
				x.emin[index] = BuildObject("svmine", 5, "epalt")
				SetSkill(x.emin[index], x.skillsetting)
				SetObjectiveName(x.emin[index], ("Molotov %d"):format(index))
				Goto(x.emin[index], ("epmin%d"):format(index)) --resend orders
				x.eminlife[index] = x.eminlife[index] + 1
				x.emingo[index] = true
				x.eminallow[index] = false
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

	--CHECK STATUS OF MCA
	if not x.MCAcheck then
		if not IsAlive(x.frcy) then --frecy killed
			AudioMessage("tcss1204.wav") --FAIL - Recy Texas lost
			ClearObjectives()
			AddObjective("tcss1201.txt", "RED") --Texas lost mission failed
			TCC.FailMission(GetTime() + 7.0, "tcss12f1.des") --LOSER LOSER LOSER
			x.MCAcheck = true
		end
		
		if x.slidestate == 0 and not x.slideforce and not IsAlive(x.efac) and not IsAlive(x.ebnk) and not IsAlive(x.ebay)
		and not IsAlive(x.escv1) and not IsAlive(x.escv2) and not IsAlive(x.escv3) and not IsAlive(x.escv4) and not IsAlive(x.escv5) and not IsAlive(x.escv6) then
			--if by some miracle, player kills CCA in less than 25min then run quake cineractive before mission success.
			x.waittime = GetTime() --turn on landslide
			x.slideforce = true
		end
		
		if x.slidecomplete and not IsAlive(x.efac) and not IsAlive(x.ebnk) and not IsAlive(x.ebay)
		and not IsAlive(x.esil[1]) and not IsAlive(x.esil[2]) and not IsAlive(x.esil[3]) and not IsAlive(x.esil[4]) and not IsAlive(x.esil[5]) and not IsAlive(x.esil[6]) then
			--use message from tcss05 mission
			AudioMessage("tcss0549.wav") --SUCCESS - Good job cmd. Transport in route
			ClearObjectives()
			AddObjective("tcss1202.txt", "GREEN") --CCA Recycler and factory destroyed.
			TCC.SucceedMission(GetTime() + 7.0, "tcss12w1.des") --WINNER WINNER WINNER
			x.MCAcheck = true
		end
	end--]]
end
--[[END OF SCRIPT]]