--bztcrb07 - Battlezone Total Command - The Red Brigade - 7/8 - RECLAIM OUR BASE
assert(load(assert(LoadFile("_requirefix.lua")),"_requirefix.lua"))();
TCC = require("TC_Core")
MisnNum = 39;
local index = 1
local index2 = 1
local x = {
	FIRST = true,
	getiton = false, 
	MCAcheck = false,
	audio = {}, 
	audio6 = nil, 
	audio7 = nil, 
	camfov = 60,  --185 default
	userfov = 90,  --seed
	playfail = {false, false, false}, 
	mytank = nil, 
	skillsetting = 0, 
	easy = 0, 
	medium = 1, 
	hard = 2, 
	spine = 0,
	waittime = 99999.9,
	pos = {}, 
	player = nil, 
	casualty = 0, 
	randompick = 0, 
	randomlast = 0, 
	frcy = nil, 
	ffac = nil, 
	ffacalt = nil, 
	fgrp = {}, 
	fsil = {}, 
	fpwr1 = nil, --diff from fpwr table
	fpwr2 = nil, --diff from fpwr table
	fcom = nil, 
	fbay = nil, 
	fgun1 = nil, 
	fgun2 = nil, 
	ercy = nil, 
	efac = nil, 
	efacstate = 0, 
	efactime = 99999.9, 
	etrn = nil, 
	etec = nil, 
	ecom = nil, 
	ebay = nil, 
	epwr = {}, 
	egun = {}, 
	eatk = {}, 
	edef = {}, --defense stuff
	edefstate = 0, 
	edeftime = 99999.9, 
	ejail = nil, 
	escv = {}, 
	escvmark = false, 
	crownmsg = 0, 
	crownshow = false, 
	crownstate = 0, 
	crowntime = 99999.9,	
	fcrown = nil, 
	fescort = nil,	
	fescortcloser = false, 
	fescorthurt = false, 
	fpilo = {}, --pilot engineer stuff
	fpilomarch = false, 
	fpilomarchtime = 99999.9, 
	fpilosent = 0, 
	fpiloall = 0, 
	fpilocount = 0, 
	fpiloaboard = 0, 
	fpilodead = 0, 
	fpilogone = 0, 
	fpilostate = {0, 0, 0},	 
	factshow = false, 
	factstate = 0,
	facttime = 99999.9, 
	ffacother = false, 
	recyshow = false, 
	recystate = 0, 
	recywait = 99999.9, 
	rescuestate = 0, 
	scavstate = 0, 
	scavtime = 99999.9, 
	silofound = false,
	hotpursuit = 0, 
	servpod = {}, 
	fally = {}, 
	fallytime = 99999.9, 
	attackstate = {0,0,0,0,0,0,0}, 
	eturtime = 99999.9, 
	eturlength = 4,
	etur = {}, 
	eturcool = {}, 
	eturallow = {}, 
	epattime = 99999.9, 
	epatlength = 4, 
	epat = {}, 
	epatcool = {}, 
	epatallow = {}, 
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
	escv = {}, --escv
	escvbuildtime = 99999.9,
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
	LAST = true
}
--PATHS: fspn1-3, fpfac, fpgrp1-6, fpserv1-8, epjail, epatk1, eprcy, epgrcy, epfac, epgfac, stage1-2, eppwr1-5, epgun1-9, epscav1-2, eptur1-4, eptrn, eptec, epcom, epbay, ppod0-2

function InitialSetup()
	SetAutoGroupUnits(true)
	
	local odfpreload = {
		"svfactrb07", "svapc", "svtank", "svscav", "svturr", "apservb", "apservs", "apmdmga", 
		"bvturr", "bvscout", "bvmbike", "bvmisl", "bvtank", "bvrckt", "apcamrs"
	}
	for k,v in pairs(odfpreload) do
		PreloadODF(v)
	end
	
	x.mytank = GetHandle("mytank")
	x.fescort = GetHandle("fescort")
	x.frcy = GetHandle("frcy")
	x.fsil = GetHandle("fsil")
	x.fbay = GetHandle("fbay")
	x.fcom = GetHandle("fcom")
	x.fgun1 = GetHandle("fgun1")
	x.fgun2 = GetHandle("fgun2")
	x.fpwr1 = GetHandle("fpwr1")
	x.fpwr2 = GetHandle("fpwr2")
	x.fcrown = GetHandle("crown")
	x.ejail = GetHandle("ejail")
	x.ercy = GetHandle("ercy")
	x.etrn = GetHandle("etrn")
	x.etec = GetHandle("etec")
	x.ebay = GetHandle("ebay")
	x.ecom = GetHandle("ecom")
	x.etur[5] = GetHandle("etur5")
	x.etur[6] = GetHandle("etur6")
	x.etur[7] = GetHandle("etur7")
	x.etur[8] = GetHandle("etur8")
	for index = 4, 9 do
		x.egun[index] = GetHandle(("egun%d"):format(index))
	end
	for index = 1, 5 do
		x.escv[index] = GetHandle(("escv%d"):format(index))
	end
	Ally(1, 4)
	Ally(4, 1) --4 engineers	
	SetTeamColor(4, 200, 200, 0) 
	SetColorFade(6.0, 0.5, "BLACK")
	TCC.Init()
end

function Start()
	TCC.Start();
end
function Save()
	return
	index, index2, x, TCC.Save()
end

function Load(a, b, c, coreData)
	index = a;
	index2 = b;
	x = c;
	TCC.Load(coreData)
  --[[for index = 1, 3 do
    if IsAlive(x.fpilo[index]) then
      Ally(4, 5)
      x.fpilostate[index] = 1
    end
  end--]]
end

function AddObject(h)
	--Get a standard ffac
	if not x.ffacother and GetTeamNum(x.ffacalt) == 0 and (IsOdf(h, "svfactrb07:1") or IsOdf(h, "sbfactrb07:1") or IsOdf(h, "svfactrb05:1") or IsOdf(h, "sbfactrb05:1")) then
		if GetTeamNum(h) == 1 then
			x.ffac = h
			x.ffacother = true
		end
	end
	
	if (not IsAlive(x.farm) or x.farm == nil) and (IsOdf(h, "svarmorb07:1") or IsOdf(h, "sbarmorb07")) then
		x.farm = h
	elseif (not IsAlive(x.ffac) or x.ffac == nil) and (IsOdf(h, "svfactrb07:1") or IsOdf(h, "sbfactrb07") or IsOdf(h, "svfactrb05:1") or IsOdf(h, "sbfactrb05:1")) then
		x.ffac = h --rb07 builds scouts, found one, rb05 no scouts
	elseif (not IsAlive(x.fsld) or x.fsld == nil) and IsOdf(h, "sbshld") then
		x.fsld = h
	elseif (not IsAlive(x.fhqr) or x.fhqr == nil) and IsOdf(h, "sbhqtr") then
		x.fhqr = h
	elseif (not IsAlive(x.ftec) or x.ftec == nil) and IsOdf(h, "sbtcen") then
		x.ftec = h
	elseif (not IsAlive(x.ftrn) or x.ftrn == nil) and IsOdf(h, "sbtrain") then
		x.ftrn = h
	elseif (not IsAlive(x.fbay) or x.fbay == nil) and IsOdf(h, "sbsbay") then
		x.fbay = h
	elseif (not IsAlive(x.fcom) or x.fcom == nil) and IsOdf(h, "sbcbun") then
		x.fcom = h
	elseif IsOdf(h, "sbpgen2") then
		for indexadd = 1, 4 do
			if x.fpwr[indexadd] == nil or not IsAlive(x.fpwr[indexadd]) then
				x.fpwr[indexadd] = h
				break
			end
		end
	end
	
	for indexadd = 1, x.fartlength do --new artillery? 
		if (not IsAlive(x.fart[indexadd]) or x.fart[indexadd] == nil) and IsOdf(h, "svartl:1") then
			x.fart[indexadd] = h
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

	--SET UP MISSION BASICS
	if x.spine == 0 then
		x.audio1 = AudioMessage("tcrb0700.wav") --INTRO - Stolen recy, cap 3 engineers, destroy jail.
		x.pos = GetTransform(x.mytank)
		RemoveObject(x.mytank)
		x.mytank = BuildObject("svtank", 1, x.pos)
		SetAsUser(x.mytank, 1)
		RemoveObject(x.player)
		x.player = GetPlayerHandle()
		x.pos = GetTransform(x.fescort)
		RemoveObject(x.fescort)
		x.fescort = BuildObject("svapc", 1, x.pos)
		x.pos = GetTransform(x.etur[5])
		RemoveObject(x.etur[5])
		x.etur[5] = BuildObject("bvturr", 5, x.pos) 
		x.pos = GetTransform(x.etur[6])
		RemoveObject(x.etur[6])
		x.etur[6] = BuildObject("bvturr", 5, x.pos) 
		x.pos = GetTransform(x.etur[7])
		RemoveObject(x.etur[7])
		if x.skillsetting < x.medium then
			x.etur[7] = BuildObject("bvturr", 5, x.pos) 
		end
		x.pos = GetTransform(x.etur[8])
		RemoveObject(x.etur[8])
		if x.skillsetting < x.hard then
			x.etur[8] = BuildObject("bvturr", 5, x.pos)
		end
		x.pos = GetTransform(x.frcy)
		RemoveObject(x.frcy)
		x.frcy = BuildObject("svrecyrb07", 0, x.pos) 
		x.pos = GetTransform(x.ercy)
		RemoveObject(x.ercy)
		x.ercy = BuildObject("bbrecy2", 5, x.pos)
		SetSkill(x.fescort, x.skillsetting)
		SetObjectiveName(x.fescort, "Rescue APC")
		SetLabel(x.fescort, "fescort")
		SetObjectiveOn(x.fescort)
		SetSkill(x.frcy, x.skillsetting)
		SetSkill(x.ercy, x.skillsetting)
		SetObjectiveName(x.ejail, "JAIL")
		SetObjectiveOn(x.ejail)
		for index = 1, 6 do  --post release: now 9 avail
			x.epwr[index] = BuildObject("bbpgen2", 5, ("eppwr%d"):format(index))
      SetMaxHealth(x.epwr[index], 6000)  --post release: buffup
      SetCurHealth(x.epwr[index], 6000)  --post release: buffup
		end
		x.ffacalt = BuildObject("svfactrb07", 0, "fpfac")
		SetSkill(x.ffacalt, x.skillsetting)
		x.scavtime = GetTime() + 10.0
		x.escvbuildtime = GetTime()
		x.edeftime = GetTime() + 300.0
		x.efacstate = 2 --this mission need unused setting
		for index = 1, x.eturlength do --init etur
			x.eturtime = GetTime() + 60.0
			x.eturcool[index] = GetTime()
			x.eturallow[index] = true
		end
		for index = 1, x.ewartotal do --init WARCODE
			x.ewardeclare = true
			x.ewarrior[index] = {} --"rows"
			for index2 = 1, 10 do --10 per wave max avail
				x.ewarrior[index][index2] = nil --"columns", init (handle in this case)
			end
			x.ewartrgt[index] = nil
			x.ewarstate[index] = 1
			x.ewartime[1] = 99999.9 --recy --these start later
			x.ewartime[2] = 99999.9 --fact
			x.ewartime[3] = 99999.9 --armo
			x.ewartime[4] = 99999.9 --base
			x.ewartimecool[index] = 240.0 --easier
			x.ewartimeadd[index] = 0.0
			x.ewarabort[index] = 99999.9
			x.ewarsize[index] = 0
			x.ewarwave[index] = 0
			x.ewarwavemax[index] = 5
			x.ewarwavereset[index] = 2
			x.ewarmeet[index] = 2
		end
		x.spine = x.spine + 1
	end

	--GIVE 1ST OBJECTIVE
	if x.spine == 1 and IsAudioMessageDone(x.audio1) then
		ClearObjectives()
		AddObjective("tcrb0701.txt")
		if x.skillsetting >= x.easy then --since player has to face mg tower
			x.servpod[1] = BuildObject("apservb", 5, "ppod0")
		end
		if x.skillsetting >= x.medium then
			x.servpod[2] = BuildObject("apservb", 5, "ppod1")
		end
		if x.skillsetting >= x.hard then
			x.servpod[3] = BuildObject("apservb", 5, "ppod2")
		end
		x.spine = x.spine + 1
	end

	--IS PLAYER AT JAIL
	if x.spine == 2	and IsAlive(x.player) and IsAlive(x.ejail) and GetDistance(x.player, x.ejail) < 150 then
		AudioMessage("tcrb0722.wav") --There’s the prison move us in before destroying
		x.spine = x.spine + 1
	end
	
	--NOTE COMPLETED PRIMARY MISSION GOALS
	if x.spine == 3 and not IsAlive(x.ercy) and (GetTeamNum(x.frcy) == 1 or ((IsAlive(x.ffacalt) and GetTeamNum(x.ffacalt) == 1) or (IsAlive(x.ffac) and GetTeamNum(x.ffac) == 1))) then
		ClearObjectives()
		AddObjective("tcrb0707.txt", "GREEN")
		x.audio7 = AudioMessage("tcrb0712.wav") --SUCCEED - have tied things up nicely
		x.spine = x.spine + 1
	end
	
	--SUCCEED MISSION
	if x.spine == 4 and IsAudioMessageDone(x.audio7) then
		TCC.SucceedMission(GetTime(), "tcrb07w1.des") --winner winner winner
		x.spine = x.spine + 1
	end
	----------END MAIN SPINE ----------
	
	--SEND OUT BDS SCAVS
	if x.scavstate == 0 and x.scavtime < GetTime() then
		x.escv[6] = BuildObject("bvscav", 5, GetPositionNear("epgrcy", 0, 16, 32)) --grpspwn
		Goto(x.escv[6], "epscrap1")
		x.escv[7] = BuildObject("bvscav", 5, GetPositionNear("epgrcy", 0, 16, 32)) --grpspwn
		Goto(x.escv[7], "epscrap2")
		x.scavstate = 1
	end
	
	--BDS DEFENSE UNITS
	if x.edefstate == 0 and ((x.rescuestate >= 3 and not IsAlive(x.eatk[1]) and not IsAlive(x.eatk[2]) and x.edeftime < GetTime()) 
	or (x.scavstate > 0 and x.scavstate < 3 and IsAlive(x.ejail) and ((GetCurHealth(x.escv[6]) < math.floor(GetMaxHealth(x.escv[6]) * 0.90)) or (GetCurHealth(x.escv[7]) < (math.floor(GetMaxHealth(x.escv[7]) * 0.90)))))
	or (GetCurHealth(x.ercy)  	< math.floor(GetMaxHealth(x.ercy) * 0.90))
	or (GetCurHealth(x.epwr[1]) < math.floor(GetMaxHealth(x.epwr[1]) * 0.90)) 
	or (GetCurHealth(x.epwr[2]) < math.floor(GetMaxHealth(x.epwr[2]) * 0.90)) 
	or (GetCurHealth(x.epwr[3]) < math.floor(GetMaxHealth(x.epwr[3]) * 0.90)) 
	or (GetCurHealth(x.epwr[4]) < math.floor(GetMaxHealth(x.epwr[4]) * 0.90)) 
	or (GetCurHealth(x.epwr[5]) < math.floor(GetMaxHealth(x.epwr[5]) * 0.90)) 
	or (x.edeftime < GetTime() and IsAlive(x.ejail))) then --ugly, but it works
		for index = 1, 2 do
			x.edef[index] = BuildObject("bvscout", 5, GetPositionNear("epgrcy", 0, 16, 32)) --grpspwn
			Attack(x.edef[index], x.player)
		end
		x.edefstate = x.edefstate + 1
	end
	
	--IF JAIL GONE AND APC TOO FAR AWAY
	if not x.fescortcloser and not IsAlive(x.ejail) and GetDistance(x.fescort, "epjail") > 100 then
		AudioMessage("tcrb0710.wav") --The jail is down. Move me (APC) closer.
		x.fescortcloser = true
	end
	
	--IF JAIL GONE PAUSE FOR A SEC
	if x.rescuestate == 0 and not IsAlive(x.ejail) then
		x.eatk[1] = BuildObject("bvscout", 5, GetPositionNear("epgrcy", 0, 16, 32)) --grpspwn
		SetObjectiveName(x.eatk[1], "Sgt Rosco")
		x.eatk[2] = BuildObject("bvscout", 5, GetPositionNear("epgrcy", 0, 16, 32)) --grpspwn
		SetObjectiveName(x.eatk[2], "Pvt Enos")
		x.waittime = GetTime() + 1.0
		x.rescuestate = x.rescuestate + 1
	end
	
	--BUILD ENGINEER PILOTS
	if x.rescuestate == 1 and x.waittime < GetTime() then
		for index = 1, 3 do
			x.fpilo[index] = BuildObject("sspilo", 4, ("fspn%d"):format(index))
			Ally(4, 5) --so they don't wander off shooting
			x.fpilostate[index] = 1
		end
		x.rescuestate = x.rescuestate + 1
	end
	
	--IF JAIL GONE AND APC CLOSE ENOUGH START RESCUE - (dumped the camera sequence)
	if x.rescuestate == 2 and not IsAlive(x.ejail) and IsAlive(x.fescort) and GetDistance(x.fescort, "epjail") < 70 then
		x.fescortcloser = true
		Stop(x.fescort)
		LookAt(x.fescort, x.frcy) --prevent spinning - keep player control
		x.fpilomarch = true
		x.fpilomarchtime = GetTime() + 1.0
		x.rescuestate = x.rescuestate + 1
	end
	
	--MARCH ENGINEERS TO APC
	if x.fpilomarch and x.fpilomarchtime < GetTime() then
		if x.fpilosent == 0 and IsAlive(x.fpilo[1]) then
			Goto(x.fpilo[1], x.fescort)
			x.fpilomarchtime = GetTime() + 4.0
			x.fpilosent = x.fpilosent + 1
		elseif x.fpilosent == 1 and IsAlive(x.fpilo[2]) then
			Goto(x.fpilo[2], x.fescort)
			x.fpilomarchtime = GetTime() + 4.0
			x.fpilosent = x.fpilosent + 1
		elseif x.fpilosent == 2 and IsAlive(x.fpilo[3]) then
			Goto(x.fpilo[3], x.fescort)
			x.fpilomarchtime = 99999.9
			x.fpilosent = x.fpilosent + 1
			x.fpilomarch = false
		end
	end
	
	--CHECK IF PILOTS ONBOARD
	if x.fpiloall == 0 and x.rescuestate > 1	then
		for index = 1, 3 do 
			if IsAlive(x.fpilo[index]) and GetDistance(x.fpilo[index], x.fescort) < 10 then
				RemoveObject(x.fpilo[index])
				x.fpilostate[index] = 2
				x.fpilocount = x.fpilocount + 1				
				if x.fpilocount == 1 and x.fpiloaboard == 0 then
					AudioMessage("tcrb0701.wav") --NIO - First engineer report comrade
					x.fpiloaboard = x.fpiloaboard + 1
				elseif x.fpilocount == 2 and x.fpiloaboard == 1 then
					AudioMessage("tcrb0726.wav") --NIO - 2nd engineer aboard comrade
					x.fpiloaboard = x.fpiloaboard + 1
				elseif x.fpilocount == 3 and x.fpiloaboard == 2 then
					AudioMessage("tcrb0702.wav") --Engineer aboard comrade
					x.fpiloaboard = x.fpiloaboard + 1
				end
			end
			
			--ARE ALL PILOTS GONE
			if not IsAlive(x.fpilo[index]) and x.fpilostate[index] >= 1 then
				x.fpilogone = x.fpilogone + 1
			end
			if x.fpilogone == 3 then
				x.fpiloall = 1
			end
			
			--WERE ALL PILOTS KILLED
			if not IsAlive(x.fpilo[index]) and x.fpilostate[index] == 1 then
				x.fpilodead = x.fpilodead + 1
			end
			if x.fpilodead == 3 then
				x.fpiloall = 666
			end
		end
		
		x.fpilogone = 0 --reset for next for pass
		x.fpilodead = 0 --reset for next for pass
		
		--NOTIFY HOW MANY RESCUED
		if x.fpiloall == 1 then
			if x.fpilocount == 3 then
				AudioMessage("tcrb0704.wav") --We got all three men sir
			elseif x.fpilocount == 2 then
				AudioMessage("tcrb0705.wav") --Only two comrades made it commander. We must go.
			elseif x.fpilocount == 1 then
				AudioMessage("tcrb0706.wav") --We only saved one man comrade. Let’s get out of here.
			end
			x.fpiloall = 2
		end
	end
	
	--GOT ENGINEERS, and AFTERWARD
	if x.rescuestate == 3 and x.fpiloall > 0 then
		UnAlly(4,5)
		Follow(x.fescort, x.player, 0) --Return to player
		if x.fpilocount == 3 then
			AudioMessage("tcrb0717.wav") --APC All engineers onboard. AMUF SE. Get him on it. Get back recy.
		elseif x.fpilocount == 2 then
			AudioMessage("tcrb0718.wav") --APC only 2 engineers. Get to AMUF. Also get Recy back
		elseif x.fpilocount == 1 then
			AudioMessage("tcrb0708.wav") --This APC, only one man onboard. Factory in SE. Get recy online.
		end
		ClearObjectives()
		AddObjective("tcrb0702.txt") --silo
		AddObjective(" ") --blank line
		AddObjective("tcrb0703.txt") --factory
		AddObjective(" ") --blank line
		AddObjective("tcrb0705.txt") --recy
		--SetObjectiveOn(x.frcy)
		x.edeftime = GetTime() + 20.0
		x.rescuestate = x.rescuestate + 1
	elseif x.rescuestate == 4 and GetDistance(x.player, "epjail") > 300 then
		AudioMessage("tcrb0724.wav") --Good work. Reinforce have been delayed. Destroy BDog on your own
		x.rescuestate = x.rescuestate + 1
	elseif x.rescuestate == 5 and GetDistance(x.player, "epjail") > 800 and GetDistance(x.fescort, "epjail") > 800 then
		x.egun[1] = BuildObject("bbgtow", 5, "epgun1")
		x.egun[2] = BuildObject("bbgtow", 5, "epgun2")
		x.efac = BuildObject("bbfact", 5, "epfac")
		x.efacstate = 0 --init efac replacement
		x.rescuestate = x.rescuestate + 1
	elseif x.rescuestate == 6 and x.fpilocount == 0 then
		SetObjectiveOff(x.fescort)
		x.rescuestate = x.rescuestate + 1
	end
	
	--HOT PURSUIT
	if x.hotpursuit < 2 then
		if x.hotpursuit == 0 and IsAlive(x.fpilo[1]) then
			SetObjectiveOn(x.eatk[1])
			SetObjectiveOn(x.eatk[2])
			Attack(x.eatk[1], x.fescort)
			Goto(x.eatk[2], "epjail")
			x.hotpursuit = 1
		elseif x.hotpursuit == 1 and x.fpiloall > 0 then
			Attack(x.eatk[1], x.fescort)
			Attack(x.eatk[2], x.fescort)
			x.hotpursuit = 2
		end
	end
	
	--APC TAKING DAMAGE
	if not x.fescorthurt and IsAlive(x.fescort) and (GetCurHealth(x.fescort) < math.floor(GetMaxHealth(x.fescort) * 0.7)) then 
		AudioMessage("tcrb0723.wav") --APC taking heavy damage. Get us out of here.
		x.fescorthurt = true
	elseif x.fescorthurt and x.fpilocount > 0 and IsAlive(x.fescort) and (GetCurHealth(x.fescort) > math.floor(GetMaxHealth(x.fescort) * 0.9)) then
		x.fescorthurt = false --reset
	end
	
	--FOUND OLD BASE
	if not x.silofound and GetDistance(x.player, x.fsil) < 150 then
		AudioMessage("tcrb0720.wav") --That abandoned scrap silo
		ClearObjectives()
		if GetTeamNum(x.ffacalt) == 0 then
			AddObjective("tcrb0703.txt") --factory
			AddObjective(" ") --blank line
		end
		if GetTeamNum(x.frcy) == 0 then
			AddObjective("tcrb0705.txt") --recy
		end
		x.fpwr1 = BuildObject("sbpgen2", 1, "pfpwr1")  --post release: spawn here
		x.fpwr2 = BuildObject("sbpgen2", 1, "pfpwr2")  --post release: spawn here
		x.pos = GetTransform(x.fbay)
		RemoveObject(x.fbay)
		x.fbay = BuildObject("sbsbay", 1, x.pos)
		x.pos = GetTransform(x.fcom)
		RemoveObject(x.fcom)
		x.fcom = BuildObject("sbcbun", 1, x.pos)
		x.pos = GetTransform(x.fsil)
		RemoveObject(x.fsil)
		x.fsil = BuildObject("sbscup", 1, x.pos)
		x.silofound = true
	end
	
	--FOUND FACTORY
	if x.factstate == 0 and x.fpilocount > 0 and GetDistance(x.fescort, x.ffacalt) < 40 then
		x.fpilocount = x.fpilocount - 1
		Stop(x.fescort)
		LookAt(x.fescort, x.ffacalt)
		x.facttime = GetTime() + 1.0
		x.factshow = true --might be dangerous if edef1/2 alive, but risk it...
    x.userfov = IFace_GetInteger("options.graphics.defaultfov")
    CameraReady() --...plyaer can cancel camera if needed
    IFace_SetInteger("options.graphics.defaultfov", x.camfov)
		x.factstate = x.factstate + 1
	elseif x.factstate == 1 and x.facttime < GetTime() then
		x.fpilo[1] = BuildObject("sspilo", 4, x.fescort)
    SetCurHealth(x.fpilo[1], 50000) 
		Goto(x.fpilo[1], x.ffacalt)
		x.factstate = x.factstate + 1
	elseif x.factstate == 2 and GetDistance(x.fpilo[1], x.ffacalt) < 16 then
		RemoveObject(x.fpilo[1])
		x.facttime = GetTime() + 3.0
		x.factstate = x.factstate + 1
	elseif x.factstate == 3 and x.facttime < GetTime() then
		if x.crownmsg == 0 and x.fpilocount > 0 then
			--x.audio1 = AudioMessage("tcrb0714.wav") --Have secured the unit factory. Supply in devils crown.
			x.audio1 = AudioMessage("tcrb0714a.wav") --Have secured the unit factory. (first bit only)
			if x.fpilocount > 1 then
				x.audio1 = AudioMessage("tcrb0714b.wav") --Supply in devils crown. (second part only)
			end
			x.crownmsg = 2 --found factory before crown
		elseif x.crownmsg == 1 and x.fpilocount > 0 then
			x.audio1 = AudioMessage("tcrb0709.wav") --Secured unit factory. Codes to supply depot found earlier.
		elseif x.fpilocount == 0 then
			x.audio1 = AudioMessage("tcrb0709b.wav") --Secured unit factory. -modified file
		end
		x.factstate = x.factstate + 1
	elseif x.factstate == 4 and IsAudioMessageDone(x.audio1) then
		Follow(x.fescort, x.player, 0) --return to player
		x.pos = GetTransform(x.ffacalt) --cuz simple teamnum switch didn't work
		RemoveObject(x.ffacalt)
		x.ffacalt = BuildObject("svfactrb07", 1, x.pos)
		if not x.ffacother then
			x.ffac = x.ffacalt
			x.ffacother = true
		end
		x.fgrp[5] = BuildObject("svscav", 1, "fpgrp5")
		SetGroup(x.fgrp[5], 3)
		Goto(x.fgrp[5], "fpgrp5", 0)
		x.fgrp[6] = BuildObject("svscav", 1, "fpgrp6")
		SetGroup(x.fgrp[6], 3)
		Goto(x.fgrp[6], "fpgrp6", 0)
		x.fgrp[7] = BuildObject("svturr", 1, "fpgrp7")
		SetGroup(x.fgrp[7], 4)
		Goto(x.fgrp[7], "fpgrp7", 0)
		x.fgrp[8] = BuildObject("svturr", 1, "fpgrp8")
		SetGroup(x.fgrp[8], 4)
		Goto(x.fgrp[8], "fpgrp8", 0)
		ClearObjectives()
		if not x.silofound then
			AddObjective("tcrb0702.txt") --silo
			AddObjective(" ") --blank line
		end
		if x.fpilocount > 0 and GetTeamNum(x.frcy) == 0 then
			AddObjective("tcrb0705.txt") --recy
			AddObjective(" ") --blank line
		end
		if x.fpilocount > 0 and IsAlive(x.fcrown) and GetTeamNum(x.fcrown) == 0 then
			AddObjective("tcrb0704.txt") --crown
		end
		x.factstate = x.factstate + 1
	elseif x.factstate == 5 and IsAlive(x.ffac) and IsOdf(x.ffac, "sbfactrb07") then
		x.edef[1] = BuildObject("bvtank", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
		Attack(x.edef[1], x.ffac)
		x.edef[2] = BuildObject("bvtank", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
		Attack(x.edef[2], x.ffac)
		x.factstate = x.factstate + 1
	end
	
	--CAMERA FACTORY
	if x.factshow and IsAlive(x.fescort) and IsAlive(x.ffacalt) then
		CameraObject(x.fescort, 0, 20, -40, x.ffacalt) --in meters
		if CameraCancelled() or (x.factstate >= 4 and IsAudioMessageDone(x.audio1)) then
    CameraFinish()
    IFace_SetInteger("options.graphics.defaultfov", x.userfov)
			x.factshow = false
		end
  elseif x.factshow and (not IsAlive(x.fescort) or not IsAlive(x.ffacalt)) then
    CameraFinish()
    IFace_SetInteger("options.graphics.defaultfov", x.userfov)
    x.factshow = false
	end
	
	--FOUND DEVIL CROWN
	if x.crownstate == 0 and GetDistance(x.player, x.fcrown) < 100 then
		if GetTeamNum(x.ffacalt) == 0 then
			AudioMessage("tcrb0715.wav") --You have stumbled on abandoned supply depot (devil's crown.)
		elseif not IsAlive(x.ffacalt) and GetTeamNum(x.ffac) == 1 then
			x.crownmsg = 1 --got factory first
		end
		x.crownstate = x.crownstate + 1
	elseif x.crownstate == 1 and x.factstate >= 3 and IsAlive(x.fescort) and GetDistance(x.fescort, x.fcrown) < 50 and (x.fpilocount == 2 or (x.recystate > 3 and x.fpilocount == 1))then --don't waste LAST pilot on crown if not have recy
		x.fpilocount = x.fpilocount - 1
		Stop(x.fescort)
		LookAt(x.fescort, x.fcrown) --prevent spinning
		x.crowntime = GetTime() + 1.0
		if not IsAlive(x.edef[1]) and not IsAlive(x.edef[2]) then
			x.crownshow = true
      x.userfov = IFace_GetInteger("options.graphics.defaultfov")
      CameraReady()
      IFace_SetInteger("options.graphics.defaultfov", x.camfov)
		end
		x.crownstate = x.crownstate + 1
	elseif x.crownstate == 2 and x.crowntime < GetTime() then
		x.fpilo[1] = BuildObject("sspilo", 4, x.fescort)
    SetCurHealth(x.fpilo[1], 50000)
		Goto(x.fpilo[1], x.fcrown)
		x.crownstate = x.crownstate + 1
	elseif x.crownstate == 3 and GetDistance(x.fpilo[1], x.fcrown) < 30 then
		RemoveObject(x.fpilo[1])
		x.crowntime = GetTime() + 3.0
		x.crownstate = x.crownstate + 1
	elseif x.crownstate == 4 then
		x.audio1 = AudioMessage("tcrb0707.wav") --Have reactivated power to depot. Some men are coming out.
		--below b/c sometimes TCC.SetTeamNum doesn't fully work
		x.pos = GetTransform(x.fcrown)
		RemoveObject(x.fcrown)
		x.fcrown = BuildObject("sbhang", 1, x.pos)
		x.pos = GetTransform(x.fgun1)
		RemoveObject(x.fgun1)
		x.fgun1 = BuildObject("sbgtow", 1, x.pos)
		x.pos = GetTransform(x.fgun2)
		RemoveObject(x.fgun2)
		x.fgun2 = BuildObject("sbgtow", 1, x.pos)
		Follow(x.fescort, x.player, 0)
		x.crownstate = x.crownstate + 1
	elseif x.crownstate == 5 and IsAudioMessageDone(x.audio1) then
		AudioMessage("tcrb0721.wav") --This is Pak 1. wingman and two scavs are at your disposal.
		x.fgrp[1] = BuildObject("svturr", 1, "fpgrp1") 
		SetGroup(x.fgrp[1], 5)
		x.fgrp[2] = BuildObject("svturr", 1, "fpgrp2") 
		SetGroup(x.fgrp[2], 5)
		x.fgrp[3] = BuildObject("svscav", 1, "fpgrp3") 
		SetGroup(x.fgrp[3], 6)
		x.fgrp[4] = BuildObject("svscav", 1, "fpgrp4") 
		SetGroup(x.fgrp[4], 6)
		for index = 1, 5 do
			x.fstuff = BuildObject("apservs", 0, ("fpserv%d"):format(index))
		end
		for index = 6, 8 do
			x.fstuff = BuildObject("apmdmga", 0, ("fpserv%d"):format(index))
		end
		x.eatk[1] = BuildObject("bvtank", 5, "epatk1")
		Attack(x.eatk[1], x.fescort)
		x.eatk[2] = BuildObject("bvscout", 5, "epatk1")
		Attack(x.eatk[2], x.fescort)
		x.eatk[3] = BuildObject("bvmisl", 5, "epatk1")
		Attack(x.eatk[3], x.player)
		x.eatk[4] = BuildObject("bvmbike", 5, "epatk1")
		Attack(x.eatk[4], x.player)
		ClearObjectives()
		if not x.silofound then
			AddObjective("tcrb0702.txt") --silo
			AddObjective(" ") --blank line
		end
		if x.fpilocount > 0 and GetTeamNum(x.frcy) == 0 then
			AddObjective("tcrb0705.txt") --recy
		end
		if x.fpilocount == 0 then
			AddObjective("tcrb0706.txt", "ALLYBLUE") --kill bds recy
		end
		x.crownstate = x.crownstate + 1
	end
	
	--CAMERA DEVIL CROWN
	if x.crownshow and IsAlive(x.fescort) and IsAlive(x.fcrown) then
		CameraObject(x.fescort, 5, 10, -20, x.fcrown) --in meters 
		if CameraCancelled() or (x.crownstate >= 5 and IsAudioMessageDone(x.audio1)) then
      CameraFinish()
      IFace_SetInteger("options.graphics.defaultfov", x.userfov)
			x.crownshow = false
		end
  elseif x.crownshow and (not IsAlive(x.fescort) or not IsAlive(x.fcrown)) then
    CameraFinish()
    IFace_SetInteger("options.graphics.defaultfov", x.userfov)
    x.crownshow = false
	end
	
	--RETRIEVE RECYCLER
	if x.recystate == 0 and x.fpilocount > 0 and IsAlive(x.fescort) and IsAlive(x.frcy) and GetDistance(x.fescort, x.frcy) < 70 then
		x.fpilocount = x.fpilocount - 1
		Stop(x.fescort)
		LookAt(x.fescort, x.frcy)
		x.recystate = x.recystate + 1
	elseif x.recystate == 1 then
		x.fpilo[1] = BuildObject("sspilo", 4, x.fescort)
    SetCurHealth(x.fpilo[1], 50000)
		Goto(x.fpilo[1], x.frcy)
		if not IsAlive(x.edef[1]) and not IsAlive(x.edef[2]) then
			x.recyshow = true
      x.userfov = IFace_GetInteger("options.graphics.defaultfov")
      CameraReady()
      IFace_SetInteger("options.graphics.defaultfov", x.camfov)
		end
		x.recystate = x.recystate + 1
	elseif x.recystate == 2 and GetDistance(x.fpilo[1], x.frcy) < 30 then
		RemoveObject(x.fpilo[1])
		x.recywait = GetTime() + 3.0
		x.recystate = x.recystate + 1
	elseif x.recystate == 3 and x.recywait < GetTime() then
		x.audio1 = AudioMessage("tcrb0727.wav") --I have reactivated our recycler.
		x.recystate = x.recystate + 1
	elseif x.recystate == 4 and IsAudioMessageDone(x.audio1) then
    if x.recyshow then --safety check
    CameraFinish()--repeated from below to be safe
    IFace_SetInteger("options.graphics.defaultfov", x.userfov)
      x.recyshow = false  --repeated from below to be safe
    end
		Follow(x.fescort, x.player, 0) --return to player
		SetObjectiveOff(x.frcy) --next couple of lines does this anyway
		x.pos = GetTransform(x.frcy)
		RemoveObject(x.frcy)
		x.frcy = BuildObject("svrecyrb07", 1, x.pos)
		x.recystate = x.recystate + 1
	elseif x.recystate == 5 then
		ClearObjectives()
		if not x.silofound then
			AddObjective("tcrb0702.txt") --silo
			AddObjective(" ") --blank line
		end
		if GetTeamNum(x.ffacalt) == 0 then
			AddObjective("tcrb0703.txt") --factory
			AddObjective(" ") --blank line
		end
		if x.crownstate == 0 and x.factstate > 1 then
			AddObjective("tcrb0704.txt") --crown
			AddObjective(" ") --blank line
		end
		if IsAlive(x.ercy) then
			AddObjective("tcrb0706.txt", "ALLYBLUE") --kill bds recy
		end
		x.recystate = x.recystate + 1
	elseif x.recystate == 6 and (GetDistance(x.frcy, "fprcy") > 400 or GetDistance(x.player, "fprcy") > 300) then
		x.edef[1] = BuildObject("bbgtow", 5, "fprcy")
		x.recystate = x.recystate + 1
	elseif x.recystate == 7 and IsOdf(x.frcy, "sbrecyrb07") then	
		x.edef[1] = BuildObject("bvmbike", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
		Attack(x.edef[1], x.frcy)
		x.edef[2] = BuildObject("bvmbike", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
		Attack(x.edef[2], x.frcy)
		x.recystate = x.recystate + 1
	end
	
	--CAMERA RECYCLER
	if x.recyshow and IsAlive(x.fescort) and IsAlive(x.frcy) then
		CameraObject(x.fescort, 0, 20, -40, x.frcy) --in meters
		if CameraCancelled() or not IsAlive(x.fescort) or not IsAlive(x.frcy) or (x.recystate >= 4 and IsAudioMessageDone(x.audio1)) or (IsAlive(x.eatk[1]) or IsAlive(x.eatk[2])) then
    CameraFinish()
    IFace_SetInteger("options.graphics.defaultfov", x.userfov)
			x.recyshow = false
		end
  elseif x.recyshow and (not IsAlive(x.fescort) or not IsAlive(x.frcy)) then
    CameraFinish()
    IFace_SetInteger("options.graphics.defaultfov", x.userfov)
    x.recyshow = false
	end
	
	--TURN ON ENEMY EXTRACTORS
	if not x.escvmark and (IsAlive(x.ffacalt) and GetTeamNum(x.ffacalt) == 1) or (IsAlive(x.ffacalt) and GetTeamNum(x.ffacalt) == 1) or (GetTeamNum(x.frcy) == 1) then
		for index = 1, 2 do
			if IsAlive(x.escv[index]) then
				SetObjectiveOn(x.escv1)
			end
		end
		x.escvmark = true
	end
	
	--START UP ATTACKS--KEEP ATTACKSTATE 7
	if not x.getiton then
		if x.attackstate[1] == 0 and IsOdf(x.frcy, "sbrecyrb07") then
			x.ewartime[1] = GetTime() --recy
			for index = 1, x.ekillartlength do --init ekillart
				x.ekillarttime = GetTime()
				x.ekillart[index] = nil 
				x.ekillartcool[index] = 99999.9 
				x.ekillartallow[index] = false
			end
			x.attackstate[1] = 1
		end
		if x.attackstate[2] == 0 and IsOdf(x.ffac, "sbfactrb07") then
			x.ewartime[2] = GetTime() + 480.0 --fact
			x.attackstate[2] = 1
		end
		if x.attackstate[3] == 0 and IsAlive(x.farm) then
			x.ewartime[3] = GetTime() + 30.0 --armo
			x.attackstate[3] = 1
		end
		if x.attackstate[4] == 0 and (IsOdf(x.frcy, "sbrecyrb07") or IsOdf(x.ffac, "sbfactrb07")) then
			x.ewartime[4] = GetTime() + 600.0 --base
			x.attackstate[4] = 1
		end
		if x.attackstate[5] == 0 and IsAlive(x.efac) then
			x.ekillarttime = GetTime() + 180.0
			x.attackstate[5] = 1
		end
		if x.attackstate[6] == 0 and (GetTeamNum(x.frcy) == 1 or GetTeamNum(x.ffac) == 1) then
			x.epattime = GetTime() + 180.0
			for index = 1, x.epatlength do --init epat
				x.epatcool[index] = GetTime()
				x.epatallow[index] = true
				x.attackstate[6] = 1
			end
		end
		if x.attackstate[7] == 0 and ((GetTeamNum(x.frcy) == 1 or GetTeamNum(x.ffac) == 1 or GetTeamNum(x.ffacalt) == 1) or (x.fpiloall > 0 and x.fpilocount == 0)) then
			x.fallytime = GetTime() + 20.0
			x.attackstate[7] = 1
		elseif x.attackstate[7] == 1 and x.fallytime < GetTime() then
			for index = 1, 4 do
				x.fally[index] = BuildObject("svtank", 1, ("fpally%d"):format(index))
				SetGroup(x.fally[index], 9)
				Goto(x.fally[index], ("fpally%d"):format(index), 0)
			end
			AudioMessage("alertpulse.wav")
			AudioMessage("tcss1507.wav") --An armor assault company is on the way
			x.attackstate[7] = 2
		end 
	end
	
	--BDS GROUP TURRET GENERIC ----------------------------------
	if x.eturtime < GetTime() then
		for index = 1, x.eturlength do
			if not IsAlive(x.etur[index]) and not x.eturallow[index] then
				x.eturcool[index] = GetTime() + 360.0
				x.eturallow[index] = true
			end
			
			if x.eturallow[index] and x.eturcool[index] < GetTime() then
				x.etur[index] = BuildObject("bvturr", 5, GetPositionNear("epgrcy", 0, 16, 32)) --grpspwn
				SetObjectiveName(x.etur[index], ("Badger %d"):format(index))
				Goto(x.etur[index], ("eptur%d"):format(index))
				x.eturallow[index] = false
			end
		end
		x.eturtime = GetTime() + 60.0
	end

	--BDS GROUP SCOUT PATROLS ------SPECIAL SIZE------------------------
	if x.epattime < GetTime() then
		for index = 1, x.epatlength do
			if not IsAlive(x.epat[index]) and not x.epatallow[index] then
				x.epatcool[index] = GetTime() + 300.0
				x.epatallow[index] = true
			end
			
			if x.epatallow[index] and x.epatcool[index] < GetTime() then
				while x.randompick == x.randomlast do --random the random
					x.randompick = math.floor(GetRandomFloat(1.0, 15.0))
				end
				x.randomlast = x.randompick
				if x.randompick == 1 or x.randompick == 6 or x.randompick == 11 then
					x.epat[index] = BuildObject("bvscout", 5, ("ppatrol%d"):format(index))
				elseif x.randompick == 2 or x.randompick == 7 or x.randompick == 12 then
					x.epat[index] = BuildObject("bvmbike", 5, ("ppatrol%d"):format(index))
				elseif x.randompick == 3 or x.randompick == 8 or x.randompick == 13 then
					x.epat[index] = BuildObject("bvmisl", 5, ("ppatrol%d"):format(index))
				elseif x.randompick == 4 or x.randompick == 9 or x.randompick == 14 then
					x.epat[index] = BuildObject("bvtank", 5, ("ppatrol%d"):format(index))
				else
					x.epat[index] = BuildObject("bvrckt", 5, ("ppatrol%d"):format(index))
				end
				Patrol(x.epat[index], ("ppatrol%d"):format(index))
				--SetObjectiveName(x.epat[index], ("Patrol %d"):format(index))
				x.epatallow[index] = false
			end
		end
		x.epattime = GetTime() + 30.0
	end
	
	--WARCODE (non-AIP or temp AIP replacement)
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
						x.ewarsize[index] = 5
					else --x.ewarwave[index] == 5 then
						x.ewarsize[index] = 6
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
						if not IsAlive(x.efac) then
							x.randompick = 1
						end
						if x.randompick == 1 or x.randompick == 8 or x.randompick == 15 then
							x.ewarrior[index][index2] = BuildObject("bvscout", 5, GetPositionNear("epgrcy", 0, 16, 32)) --grpspwn
							if x.ewarwave[index] == 3 or x.ewarwave[index] == 4 then
								GiveWeapon(x.ewarrior[index][index2], "glasea_c")
							end
						elseif x.randompick == 2 or x.randompick == 9 or x.randompick == 16 then
							x.ewarrior[index][index2] = BuildObject("bvmbike", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
							if x.ewarwave[index] == 2 or x.ewarwave[index] == 4 then
								GiveWeapon(x.ewarrior[index][index2], "gstbva_c")
							end
						elseif x.randompick == 3 or x.randompick == 10 or x.randompick == 17 then
							x.ewarrior[index][index2] = BuildObject("bvmisl", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
							if x.ewarwave[index] == 3 or x.ewarwave[index] == 5 then
								GiveWeapon(x.ewarrior[index][index2], "gfafma_c")
							end
						elseif x.randompick == 4 or x.randompick == 11 or x.randompick == 18 then
							x.ewarrior[index][index2] = BuildObject("bvtank", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
							if x.ewarwave[index] == 4 or x.ewarwave[index] == 5 then
								GiveWeapon(x.ewarrior[index][index2], "gstbsa_c")
							end
						elseif x.randompick == 5 or x.randompick == 12 then
							x.ewarrior[index][index2] = BuildObject("bvrckt", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
							if x.ewarwave[index] == 3 or x.ewarwave[index] == 5 then
								GiveWeapon(x.ewarrior[index][index2], "gshdwa_a") --salvo rckt
							end
						else
							if x.ewarwave[index] > 3 then
								x.ewarrior[index][index2] = BuildObject("bvwalk", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
							else
								x.ewarrior[index][index2] = BuildObject("bvscout", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
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
						if IsAlive(x.ewarrior[index][index2]) and GetDistance(x.ewarrior[index][index2], ("stage%d"):format(x.ewarmeet[index])) < 100 and GetTeamNum(x.ewarrior[index][index2]) ~= 1 then
							x.ewarstate[index] = x.ewarstate[index] + 1
							break
						end
					end
				end
			
				--GIVE ATTACK ORDER
				if x.ewarstate[index] == 5 then
					for index2 = 1, x.ewarsize[index] do
						if IsAlive(x.ewarrior[index][index2]) then
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
				x.ekillart[index] = BuildObject("bvtank", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
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

	--BUILD BDS SCAVS FOR LOOKS ----SPECIAL THIS MISSION SEE INDEX NUMBERS
	if IsAlive(x.ercy) then
		if GetScrap(5) > 39 then
			SetScrap(5, 0) --so they'll keep collecting scrap
		end
		for index = 6, 7 do
			if not IsAlive(x.escv[index]) and x.escvbuildtime < GetTime() then
				x.escv[index] = BuildObject("bvscav", 5, GetPositionNear("epgrcy", 0, 16, 32)) --grpspwn
				x.escvbuildtime = GetTime() + 120.0
			end
		end
	end
	
	--REBUILD AI FACTORY
	if x.efacstate == 0 and not IsAlive(x.efac) and IsAlive(x.ercy) then
		x.efactime = GetTime() + 120.0
		x.efacstate = 1
	elseif x.efacstate == 1 and GetDistance(x.player, "epfac") > 600 and x.efactime < GetTime() and IsAlive(x.ercy) then
		x.efac = BuildObject("bbfact", 5, "epfac")
		x.efacstate = 0
	end
	
	--CHECK STATUS OF MCA
	if not x.MCAcheck then	
		if not x.playfail[1] and not x.playfail[2] and not x.playfail[3] and x.fpiloall == 666 then --all engineers killed
			StopAudioMessage(x.audio1)
			ClearObjectives()
			AddObjective("tcrb0708.txt", "RED") --REUSE FROM OTHER MISSION
			x.audio6 = AudioMessage("tcrb0711.wav") --FAIL - lost all our comrades
			x.playfail[1] = true
			x.spine = 666
			x.MCAcheck = true
		end
		
		if not x.playfail[1] and not x.playfail[2] and not x.playfail[3] and not IsAlive(x.fescort) and x.recystate < 3 then --GetTeamNum(x.frcy) == 0 then
			StopAudioMessage(x.audio1)
			ClearObjectives()
			AddObjective("tcrb0709.txt", "RED")
			x.audio6 = AudioMessage("tcrb0716.wav") --FAIL - lost APC
			x.playfail[2] = true
			x.spine = 666
			x.MCAcheck = true
		end
		
		if not x.playfail[1] and not x.playfail[2] and not x.playfail[3] and not IsAlive(x.frcy) then --frecy killed
			StopAudioMessage(x.audio1)
			ClearObjectives()
			AddObjective("tcrb0710.txt", "RED")
			x.audio6 = AudioMessage("tcrb0507.wav") --Generic Recycler dest, will b sent 2 siberia
			x.playfail[3] = true
			x.spine = 666
			x.MCAcheck = true
		end
	end
	
	--FAIL THE MISSION
	if not x.getiton then
		if x.playfail[1] and IsAudioMessageDone(x.audio6) then 
			TCC.FailMission(GetTime(), "tcrb07f1.des") --LOSER LOSER LOSER
			x.getiton = true
		end
		if x.playfail[2] and IsAudioMessageDone(x.audio6) then
			TCC.FailMission(GetTime(), "tcrb07f2.des") --LOSER LOSER LOSER
			x.getiton = true
		end
		if x.playfail[3] and IsAudioMessageDone(x.audio6) then
			TCC.FailMission(GetTime(), "tcrb07f3.des") --LOSER LOSER LOSER
			x.getiton = true
		end
	end
end
--[[END OF SCRIPT]]