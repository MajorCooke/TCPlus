--bztcss09 - Battlezone Total Command - Stars and Stripes - 9/17 - THE RACE IS ON
assert(load(assert(LoadFile("_requirefix.lua")),"_requirefix.lua"))();
TCC = require("TC_Core")
MisnNum = 24;
--DECLARE variables --f-friend, e-enemy, atk-attack, rcy-recycler, etc...
local index = 0
local index2 = 0
local indexadd = 0
local x = {
	FIRST = true, 
	MCAcheck = false,	
	player = nil, 
	mytank = nil, 
	spine = 0, 
	casualty = 0, 
	randompick = 0, 
	randomlast = 0,	
	skillsetting = 0,
	easy = 0, 
	medium = 1, 
	hard = 2, --tried 1-3, in 185, 3 didn't seem to make any difference, 
	waittime = 99999.9, 
	audio1 = nil, 
	pos = {}, 
	gotcone = false, 
	scraphave = false, 
	scrapfree = 0, 
	relicexists = false, 
	reliciscargo = false, 
	etughasrelic = false, 
	relicfound = false, 
	ercydead = false, 
	ehqrfound = 0, 
	free_player = false,	
	controls = {braccel = 0, strafe = 0, jump = 0, deploy = 0, eject = 0, abandon = 0, fire = 0}, 
	etugallow = false, --etug
	etug = nil, 
	etuglooptime = 99999.9, 
	etugwaitallow = 99999.9, 
	etugwaitftug = 99999.9, 
	etugcargotime = 99999.9, 
	eescorttime = 99999.9, --escort
	eescortwait = 99999.9, 
	eescortcool = {}, 
	eescortallow = {}, 
	eescort = {}, 
	eescortlife = {}, 
	eescortlength = 4,
	efactime = 99999.9, --rebuild efac
	efacreset = false, 
	efacpos = {}, 
	ercy = nil, 
	efac = nil, 
	earm = nil, 
	ebay = nil, 
	ecom = nil, 
	etrn = nil, 
	etec = nil, 
	ehqr = nil, 
	esld = nil, 
	epad = nil, 
	frcy = nil, 
	ffac = nil, 
	farm = nil, 
	fpwr = {nil, nil, nil, nil}, 
	fhqr = nil, 
	ftec = nil, 
	ftrn = nil, 
	fbay = nil, 
	fcom = nil, 
	fhqr = nil, 
	fsld = nil, 
	fnav1 = nil, 
	fdrp = {}, 
	fgrp = {}, 
	holder = {}, 
	relic = nil, 
	ftugtarget = nil, 
	tuggy = nil, 
	volcano = nil, 
	eturtime = 99999.9, --turrets
	eturlength = 20, 
	etur = {}, 
	eturcool = {}, 
	eturallow = {}, 
	eturlife = {}, 
	earttime = 99999.9, --artil
	eartlength = 9, 
	eart = {}, 
	eartcool = {},
	eartallow = {}, 
	eartlife = {}, 
	epattime = 99999.9, --patrol
	epatlength = 4,
	epat = {},
	epatcool = {}, 
	epatallow = {}, 
	wreckstate = 0, --daywrecker
	wrecktime = 99999.9, 
	wrecktrgt = {},
	wreckbomb = nil, 
	wreckname = "apdwrks", 
	wreckbank = false, --have 2
	wrecknotify = 0, 
	fartlength = 10, --fart killers
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
	--wreckbank = false, --have 2
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
--PATHS: fnav1-3, eprel, fpmeet1, epgrcy, epgfac, epfac, eptur0-19, epart0-7, ppatrol1-4, eppad, stage1-2

function InitialSetup()
	SetAutoGroupUnits(true)
	
	local odfpreload = {
		"avturr", "avscout", "avmbike",	"avmisl", "avtank", "avrckt", "avrecyss09", "gflsha_c", 
		"sblpad2", "sbcone1", "hadrelic01", "svturr", "svtug", "svartl", "stayput", "apcamra", "radjam"
	}
	for k,v in pairs(odfpreload) do
		PreloadODF(v)
	end
	
	x.fdrp[1] = GetHandle("fdrp1")
	x.fdrp[2] = GetHandle("fdrp2")
	x.frcy = GetHandle("frcy")
	x.mytank = GetHandle("mytank")
	x.fgrp[1] = GetHandle("fgrp1")
	x.fgrp[2] = GetHandle("fgrp2")
	x.fgrp[3] = GetHandle("fgrp3")
	x.fgrp[4] = GetHandle("fgrp4")
	x.ercy = GetHandle("ercy")
	x.efac = GetHandle("efac")
	x.earm = GetHandle("earm")
	x.etec = GetHandle("etec")
	x.epad = GetHandle("epad")
	x.ehqr = GetHandle("ehqr")
	x.volcano = GetHandle("volcano1")
	Ally(1, 4)
	Ally(4, 1) --4 Fury relic
	Ally(5, 4)
	Ally(4, 5)
	Ally(6, 4)
	Ally(4, 6)
	Ally(5, 6) --5 AI enemy
	Ally(6, 5) --6 player/ftug assassin
	SetTeamColor(6, 20, 40, 100) --assassin	
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
	--CHECK FOR MISSION SPECIFIC FACTORY AND ARMORY
	if (not IsAlive(x.farm) or x.farm == nil) and (IsOdf(h, "avarmo:1") or IsOdf(h, "abarmo")) then
		x.farm = h
	elseif (not IsAlive(x.ffac) or x.ffac == nil) and (IsOdf(h, "avfactss09:1") or IsOdf(h, "abfactss09")) then
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
				x.fpwr[indexadd] = h
				break
			end
		end
	end
	for indexadd = 1, x.fartlength do --new artillery? 
		if (not IsAlive(x.fart[indexadd]) or x.fart[indexadd] == nil) and IsOdf(h, "avartl:1") then
			x.fart[indexadd] = h
		end
	end
	
	--get daywrecker for highlight
	if (not IsAlive(x.wreckbomb) or x.wreckbomb == nil) and IsOdf(h, x.wreckname) then 
		if GetTeamNum(h) == 5 then
			x.wreckbomb = h --get handle to launched daywrecker
		end
	end
	
	if not x.gotcone and IsOdf(h, "sbcone1") then
		x.ecne = h
		x.gotcone = true
	end
	
	if not x.scraphave and IsOdf(h, "avscav") then
		x.scrapfree = 0
		x.scraphave = true
	end
	
	if not x.scraphave and IsOdf(h, "abscav:1") then
		x.scrapfree = 0
		x.scraphave = true
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

	if x.spine == 0 then
		x.pos = GetTransform(x.mytank)
		RemoveObject(x.mytank)
		x.mytank = BuildObject("avtank", 1, x.pos)
		x.pos = GetTransform(x.fgrp[1])
		RemoveObject(x.fgrp[1])
		x.fgrp[1] = BuildObject("avscout", 1, x.pos)
		x.pos = GetTransform(x.fgrp[2])
		RemoveObject(x.fgrp[2])
		x.fgrp[2] = BuildObject("avtank", 1, x.pos)
		x.pos = GetTransform(x.fgrp[3])
		RemoveObject(x.fgrp[3])
		x.fgrp[3] = BuildObject("avmisl", 1, x.pos)
		x.pos = GetTransform(x.fgrp[4])
		RemoveObject(x.fgrp[4])
		x.fgrp[4] = BuildObject("avrckt", 1, x.pos)
		x.pos = GetTransform(x.frcy)
		RemoveObject(x.frcy)
		x.frcy = BuildObject("avrecyss09", 1, x.pos)
		GiveWeapon(x.mytank, "gflsha_c")
		SetAsUser(x.mytank, 1)
		RemoveObject(x.player)
		x.player = GetPlayerHandle()
		Stop(x.frcy) --Prevent player giving orders in dropship
		for index = 1, 4 do
			SetSkill(x.fgrp[index], x.skillsetting)
			Stop(x.fgrp[index])
			SetGroup(x.fgrp[index], 0)
		end
		SetGroup(x.frcy, 1)
		x.fnav1 = BuildObject("apcamra", 1, "fpnav1")
		SetObjectiveName(x.fnav1, "Artifact")
		x.fnav1 = BuildObject("apcamra", 1, "fpnav2")
		SetObjectiveName(x.fnav1, "CCA Base")
		x.fnav1 = BuildObject("apcamra", 1, "fpnav3")
		SetObjectiveName(x.fnav1, "Dropzone")
		x.relic = BuildObject("hadrelic01", 0, "eprel") --start neutral
		x.relicexists = true --just use it
		x.pos = GetTransform(x.epad)
		RemoveObject(x.epad)
		x.epad = BuildObject("sblpad2", 5,	x.pos)
		x.epattime = GetTime() + 180.0
		for index = 1, x.epatlength do --init epat
			x.epatcool[index] = GetTime()
			x.epatallow[index] = true
		end
		x.eturtime = GetTime()
		for index = 1, x.eturlength do --init etur
			x.eturcool[index] = GetTime()
			x.eturallow[index] = true
			x.eturlife[index] = 0
		end
		x.earttime = GetTime()
		for index = 1, x.eartlength do --init eart
			x.eartcool[index] = GetTime()
			x.eartallow[index] = true
			x.eartlife[index] = 0
		end
		x.eescorttime = GetTime() + 60.0
		x.eescortwait = 20.0 --add time
		x.eescortlength = 2
		for index = 1, x.eescortlength do --init eescort
			x.eescortcool[index] = GetTime() + 120.0
			x.eescortallow[index] = true
			x.eescortlife[index] = 0
		end
		x.efactime = GetTime() + 240.0 --init efac
		x.efacpos = GetTransform(x.efac)
		x.audio1 = AudioMessage("tcss0900.wav") --23 INTRO - We on Io same time as Sov. get Fury x.relic back to base Devon and Miller getting theirs
		x.pos = GetTransform(x.volcano)
		RemoveObject(x.volcano)
		x.volcano = BuildObject("lavaspout", 0, x.pos)
		x.spine = x.spine + 1
	end

	--DROPSHIP LANDING SEQUENCE - START QUAKE FOR FLYING EFFECT
	if x.spine == 1 then
		for index = 1, 2 do
			for index2 = 1, 10 do
				StopEmitter(x.fdrp[index], index2)
			end
		end
		x.holder[1] = BuildObject("stayput", 0, x.fgrp[1]) --fdrp1 dropship 1
		x.holder[2] = BuildObject("stayput", 0, x.fgrp[2])
		x.holder[3] = BuildObject("stayput", 0, x.fgrp[3])
		x.holder[4] = BuildObject("stayput", 0, x.fgrp[4])
		x.holder[5] = BuildObject("stayput", 0, x.frcy) --fdrp2 dropship 2
    x.holder[6] = BuildObject("radjam", 5, x.player)
		x.holder[7] = BuildObject("stayput", 0, x.player) --fdrp1 dropship 1
		StartEarthQuake(10.0)
		x.waittime = GetTime() + 8.0
		x.spine = x.spine + 1
	end

	--LANDING - MAKE QUAKE BIGGERR
	if x.spine == 2 and x.waittime < GetTime() then
		UpdateEarthQuake(50.0)
		x.waittime = GetTime() + 3.0
		x.spine = x.spine + 1
	end
	
	--HAVE LANDED - STOP QUAKE
	if x.spine == 3 and x.waittime < GetTime() then
		StopEarthQuake()
		x.waittime = GetTime() + 2.0
		x.spine = x.spine + 1
	end

	--OPEN DROPSHIP DOORS, REMOVE HOLDERS
	if x.spine == 4 and x.waittime < GetTime() then
		StartSoundEffect("dropdoor.wav")
		SetAnimation(x.fdrp[1], "open", 1)
		SetAnimation(x.fdrp[2], "open", 1)
		for index = 1, 6 do --player is later
			RemoveObject(x.holder[index])
		end
		x.waittime = GetTime() + 5.0
		x.spine = x.spine + 1
	end
	
	--DOORS FULLY OPEN, GIVE MOVE ORDER
	if x.spine == 5 and x.waittime < GetTime() then
		Goto(x.frcy, "fprcy", 0)
		for index = 1, 4 do
			Goto(x.fgrp[index], "fpmeet1", 0)
		end
		x.waittime = GetTime() + 1.0
		x.spine = x.spine + 1
	end

	--GIVE PLAYER CONTROL OF THEIR AVATAR
	if x.spine == 6 and x.waittime < GetTime() then
		RemoveObject(x.holder[7])
		x.free_player = true
		x.spine = x.spine + 1
	end
	
	--CHECK IF PLAYER HAS LEFT DROPSHIP
	if x.spine == 7 then
		x.player = GetPlayerHandle()
		if IsCraftButNotPerson(x.player) and GetDistance(x.player, x.fdrp[1]) > 60 then
			SetScrap(1, 40)
			ClearObjectives()
			AddObjective("tcss0900.txt")
			x.spine = x.spine + 1
		end
	end

	--DROPSHIP 1 TAKEOFF
	if x.spine == 8 then
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
	if x.spine == 9 and x.waittime < GetTime() then
		for index = 1, 10 do
			StartEmitter(x.fdrp[2], index)
		end
		SetAnimation(x.fdrp[2], "takeoff", 1)
		StartSoundEffect("dropleav.wav", x.fdrp[2])
		x.waittime = GetTime() + 18.0
		x.spine = x.spine + 1
	end

	--REMOVE DROPSHIPS
	if x.spine == 10 and x.waittime < GetTime() then
		RemoveObject(x.fdrp[1])
		RemoveObject(x.fdrp[2])
		x.waittime = GetTime() + 30.0 --delay for tug, let esc get there first
		x.spine = x.spine + 1
	end

	--SEND CCA TUG
	if x.spine == 11 and x.waittime < GetTime() then
		x.etuglooptime = GetTime() --start tug
		x.etugcargotime = GetTime() --init this
		x.spine = x.spine + 1
	end

	--IS ARTIFACT AT RECYCLER OR IF ALIVE, AT NAV ARTIFACT
	if x.spine == 12 and IsAlive(x.relic) and ((IsAlive(x.frcy) and GetDistance(x.relic, x.frcy) < 64) or (IsAlive(x.fnav1) and GetDistance(x.relic, "fpnav3") < 20)) then
		AudioMessage("tcss0901.wav") --10 SUCCEED - Lets get off this rock.
		ClearObjectives()
		AddObjective("tcss0901.txt", "GREEN")
	--NOPE YOU DON'T WIN - TIME TO DO SOMETHING TO MAKE THIS MISSION WORTH PLAYING
		for index = 1, x.ewartotal do --init WARCODE
			x.ewardeclare = true
			x.ewarrior[index] = {} --"rows"
			for index2 = 1, 10 do --10 per wave max avail
				x.ewarrior[index][index2] = nil --"columns", init (handle in this case)
			end
			x.ewartrgt[index] = nil
			x.ewarstate[index] = 1
			x.ewartime[1] = GetTime() + 120.0 --recy
			x.ewartime[2] = GetTime() + 180.0 --fact
			x.ewartime[3] = GetTime() + 240.0 --armo
			x.ewartime[4] = GetTime() + 300.0 --base
			x.ewartimecool[index] = 240.0
			x.ewartimeadd[index] = 0.0
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
		x.eescortwait = 180.0 --added time
		x.wrecktime = GetTime() + 360.0
		x.waittime = GetTime() + 20.0
		x.spine = x.spine + 1
	end

	--MESSAGE JUSTICE UNDER ATTACK
	if x.spine == 13 and x.waittime < GetTime() then
		AudioMessage("alertpulse.wav")
		ClearObjectives()
		AddObjective("tcss0902.txt", "LAVACOLOR")
		x.waittime = GetTime() + 10.0
		x.spine = x.spine + 1
	end

	--MESSAGE HOLD OFF CCA
	if x.spine == 14 and x.waittime < GetTime() then
		AudioMessage("alertpulse.wav")
		AddObjective("	")
		AddObjective("tcss0903.txt", "YELLOW")
		if not x.scraphave and GetScrap(1) < 25 then
			AddScrap(1, 20)
			x.scraphave = true
		end
		x.spine = x.spine + 1
	end

	--IF CCA RCY DEAD AND WAIT DONE	...
	if x.spine == 15 and x.ercydead and x.waittime < GetTime() then
		AudioMessage("alertpulse.wav")
		ClearObjectives()
		AddObjective("tcss0909.txt", "YELLOW")
		x.spine = x.spine + 1
	end

	--... relic AT RECY, AND etug NOT CARRYING IT, THEN U B A WIENER			
	if x.spine == 16 and IsAlive(x.frcy) and IsAlive(x.relic) and GetDistance(x.relic, x.frcy) < 100 and (not IsAlive(x.etug) or (IsAlive(x.etug) and not HasCargo(x.etug))) then
		x.MCAcheck = true
		ClearObjectives()
		AddObjective("tcss0904.txt", "CYAN")
		AddObjective("\n\nMISSION COMPLETE!", "GREEN")
		SucceedMission(GetTime() + 10.0, "tcss09w1.des") --WINNER WINNER WINNER
		x.spine = x.spine + 1
	end
	----------END MAIN SPINE ----------

	--ENSURE PLAYER CAN'T DO ANYTHING WHILE IN DROPSHIP
	if not x.free_player then
		x.controls = {braccel = 0, strafe = 0, jump = 0, deploy = 0, eject = 0, abandon = 0, fire = 0}
		SetControls(x.player, x.controls)
	end
	
	--CCA FIELD HEADQUARTERS JAMMER INFORM PLAYER (first appear in SS, but not 1st in chrono campaign)
	if x.ehqrfound == 0 and x.spine > 12 and IsAlive(x.ehqr) and GetDistance(x.player, x.ehqr) < 350 then
		AddObjective("	")
		AddObjective("tcss0910.txt", "ALLYBLUE")
		SetObjectiveOn(x.ehqr)
		x.ehqrfound = x.ehqrfound + 1
	elseif x.ehqrfound == 1 and IsAlive(x.ehqr) and GetDistance(x.player, x.ehqr) > 400 then
		SetObjectiveOff(x.ehqr)
		x.ehqrfound = x.ehqrfound + 1
	end
	
	--TURN RELIC ON FIRST TIME
	if not x.relicfound and (GetDistance(x.relic, x.player) < 150 or (IsAlive(x.etug) and GetDistance(x.relic, x.etug) < 150)) then
		SetTeamNum(x.relic, 4)
		SetObjectiveOn(x.relic)
		x.relicfound = true
	end
	
	--KEEP RELIC ON WHEN NOT CARRIED BY ETUG
	if x.relicfound and not x.etughasrelic then
		SetObjectiveOn(x.relic)
	end

	--IS RELIC CARGO, AND IF SO, WHO HAS IT?
	if x.relicexists then --for collapse just use it
		if not IsAlive(x.tuggy) or x.tuggy == nil then
			x.reliciscargo = false
			if x.relicfound then
				x.etughasrelic = false --to turn relic back on
			end
		end
		
		--which team has cargo
		if not x.reliciscargo then	
			x.tuggy = GetTug(x.relic)
			if IsAlive(x.tuggy) then
				if GetTeamNum(x.tuggy) == 1 then
					x.ftugtarget = x.tuggy
					AudioMessage("tcss0319.wav") --4 W/20 Hover tug 1 has cargo
					AudioMessage("tcss0320.wav") --3 W/19 voice says Hover tug reports obj secured
				elseif GetTeamNum(x.tuggy) == 5 then
					Goto(x.etug, "eppad")
					AudioMessage("tcss0905.wav") --5 CCA has x.relic and going back to base.
					SetObjectiveOff(x.relic) --turn relic off for smart reticle target etug
					SetObjectiveName(x.etug, "Destroy Tug")
					SetObjectiveOn(x.etug)
					x.etughasrelic = true
				end
				x.reliciscargo = true
			end
		end
		
		--whoops, ftug drops relic ... no really its the tug's fault ... I swarz
		if GetTeamNum(x.tuggy) == 1 and not HasCargo(x.ftugtarget) then 
			x.ftugtarget = nil
			x.tuggy = nil
		end
	end

	--RUN THE CCA TRACTOR TUG
	if x.etuglooptime < GetTime() then
		if not IsAlive(x.etug) and not x.etugallow then
			if IsAlive(x.frcy) and IsAlive(x.relic) and GetDistance(x.relic, x.frcy) > 600 then
				x.etugwaitallow = GetTime() + 60.0
			else
				x.etugwaitallow = GetTime() + 30.0
			end
			x.etugallow = true
		end
		
		if x.etugwaitallow < GetTime() and x.etugallow and not IsAlive(x.etug) then
			x.etug = BuildObject("svtug", 5, "epgrcy")
			SetCanSnipe(x.etug, 0)
			x.etughasrelic = false --to turn relic back on
			x.etugallow = false
		end

		--If ftugtarget alive, have etug follow in case ftugtarget is killed
		if IsAlive(x.ftugtarget) and IsAlive(x.etug) and not HasCargo(x.etug) and x.etugwaitftug < GetTime() then
			Goto(x.etug, x.ftugtarget)
			x.etugwaitftug = GetTime() + 5.0
		end

		--Otherwise assume etug can pick up relic, and have it do so
		if IsAlive(x.etug) and not HasCargo(x.etug) and x.etugcargotime < GetTime() then
			Pickup(x.etug, x.relic)
			x.etugcargotime = GetTime() + 5.0
		end
	end

	--CCA RELIC ESCORT GROUP	
	if x.eescorttime < GetTime() then
		for index = 1, x.eescortlength do
			if not IsAlive(x.eescort[index]) and not x.eescortallow[index] and x.eescortlife[index] < 10 then
				x.eescortcool[index] = GetTime() + x.eescortwait
				x.eescortallow[index] = true
			end
			
			if x.eescortallow[index] and x.eescortcool[index] < GetTime() then
				x.eescort[index] = BuildObject("svtank", 6, GetPositionNear("epgfac", 0, 16, 32))  --"epgfac")
				SetSkill(x.eescort[index], x.skillsetting)
				SetObjectiveName(x.eescort[index], ("Escort %d"):format(index))
				x.eescortlife[index] = x.eescortlife[index] + 1
				x.eescortallow[index] = false
			end
			
			if not x.eescortallow[index] and x.eescorttime < GetTime() then
				if not IsAlive(x.ftugtarget) and IsAlive(x.eescort[index]) and GetTeamNum(x.eescort[index]) ~= 1  then
					Defend2(x.eescort[index], x.relic)
				elseif IsAlive(x.eescort[index]) and GetTeamNum(x.eescort[index]) ~= 1  then
					Attack(x.eescort[index], x.ftugtarget)
				end
			end
		end
		x.eescorttime = GetTime() + 30.0
	end
	
	--AI DAYWRECKER ATTACK
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
			x.wrecktime = GetTime() + 540.0  --480.0
		elseif x.randompick == 2 or x.randompick == 5 or x.randompick == 8 then
			x.wrecktime = GetTime() + 420.0  --360.0
		else
			x.wrecktime = GetTime() + 300.0  --240.0
		end
		x.wreckstate = 0 --reset
	end

	--CCA GROUP TURRET GENERIC
	if x.eturtime < GetTime() then
		for index = 1, x.eturlength do
			if not IsAlive(x.etur[index]) and not x.eturallow[index] and x.eturlife[index] < 3 then
				x.eturcool[index] = GetTime() + 360.0
				x.eturallow[index] = true
			end
			if x.eturallow[index] and x.eturcool[index] < GetTime() then
				x.etur[index] = BuildObject("svturr", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
				--SetObjectiveName(x.etur[index], ("Pak %d"):format(index))
				Goto(x.etur[index], ("eptur%d"):format(index))
				x.eturlife[index] = x.eturlife[index] + 1
				x.eturallow[index] = false
			end
		end
		x.eturtime = GetTime() + 30.0
	end

	--CCA GROUP ARTILLERY GENERIC
	if x.earttime < GetTime() then
		for index = 1, x.eartlength do
			if not IsAlive(x.eart[index]) and not x.eartallow[index] and x.eartlife[index] < 3 then
				x.eartcool[index] = GetTime() + 480.0
				x.eartallow[index] = true
			end
			if x.eartallow[index] and x.eartcool[index] < GetTime() then
				x.eart[index] = BuildObject("svartl", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
				SetSkill(x.eart[index], x.skillsetting)
				--SetObjectiveName(x.eart[index], ("Cannoneer %d"):format(index))
				Goto(x.eart[index], ("epart%d"):format(index))
				x.eartlife[index] = x.eartlife[index] + 1
				x.eartallow[index] = false
			end
		end
		x.earttime = GetTime() + 30.0
	end
	
	--CCA GROUP SCOUT PATROLS
	if x.epattime < GetTime() then
		for index = 1, x.epatlength do
			if not IsAlive(x.epat[index]) and not x.epatallow[index] then
				x.epatcool[index] = GetTime() + 360.0
				x.epatallow[index] = true
			end
			
			if x.epatallow[index] and x.epatcool[index] < GetTime() then
				if index == 1 then
					x.epat[index] = BuildObject("svscout", 5, ("ppatrol%d"):format(index))
				elseif index == 2 then
					x.epat[index] = BuildObject("svmbike", 5, ("ppatrol%d"):format(index))
				elseif index == 3 then
					x.epat[index] = BuildObject("svmisl", 5, ("ppatrol%d"):format(index))
				elseif index == 4 then
					x.epat[index] = BuildObject("svtank", 5, ("ppatrol%d"):format(index))
				end
				SetSkill(x.epat[index], x.skillsetting)
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
						x.ewarsize[index] = 5
					elseif x.ewarwave[index] == 4 then
						x.ewarsize[index] = 7
					else --x.ewarwave[index] == 5 then
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
						if not IsAlive(x.efac) then
							x.randompick = 1
						end
						if x.randompick == 1 or x.randompick == 8 or x.randompick == 13 then
							x.ewarrior[index][index2] = BuildObject("svscout", 5, GetPositionNear("epgrcy", 0, 16, 32)) --grpspwn
							if x.ewarwave[index] == 3 or x.ewarwave[index] == 4 then
								GiveWeapon(x.ewarrior[index][index2], "glasea_c")
							end
						elseif x.randompick == 2 or x.randompick == 9 or x.randompick == 14 then
							x.ewarrior[index][index2] = BuildObject("svmbike", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
							if x.ewarwave[index] == 2 or x.ewarwave[index] == 4 then
								GiveWeapon(x.ewarrior[index][index2], "gstbva_c")
							end
						elseif x.randompick == 3 or x.randompick == 10 or x.randompick == 15 then
							x.ewarrior[index][index2] = BuildObject("svmisl", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
							if x.ewarwave[index] == 3 or x.ewarwave[index] == 5 then
								GiveWeapon(x.ewarrior[index][index2], "gfafma_c")
							end
						elseif x.randompick == 4 or x.randompick == 11 or x.randompick == 16 then
							x.ewarrior[index][index2] = BuildObject("svtank", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
							if x.ewarwave[index] == 4 or x.ewarwave[index] == 5 then
								GiveWeapon(x.ewarrior[index][index2], "gstbsa_c")
							end
						elseif x.randompick == 5 or x.randompick == 12 or x.randompick == 17 then
							x.ewarrior[index][index2] = BuildObject("svrckt", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
							if x.ewarwave[index] == 3 or x.ewarwave[index] == 5 then
								GiveWeapon(x.ewarrior[index][index2], "gshdwa_a") --salvo rckt
							end
						elseif x.randompick == 6 then
							x.ewarrior[index][index2] = BuildObject("svartl", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
						else --7, 18
							x.ewarrior[index][index2] = BuildObject("svwalk", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
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
						end
						SetSkill(x.ewarrior[index][index2], x.skillsetting)
						--[[if index2 % 3 == 0 then
							SetSkill(x.ewarrior[index][index2], x.skillsetting+1)
						end--]]
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
	
	--CCA REBUILD FACTORY
	if x.efactime < GetTime() then
		if not x.efacreset and not IsAlive(x.efac) then
			x.efactime = GetTime() + 240.0
			x.efacreset = true
		end
		if x.efactime < GetTime() and not IsAlive(x.efac) and IsAlive(x.ercy) and (GetDistance(x.player, x.efacpos) > 400) then
			x.efac = BuildObject("sbfact", 5, x.efacpos) --"epfac")
			x.efacreset = false
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
			x.ekillarttime = GetTime() + 180.0 --give time for attack
			x.ekillartmarch = false
		end
	end
	
	--AI GROUP SCAVENGERS
	if IsAlive(x.ercy) then
		if GetScrap(5) > 39 and not x.wreckbank then --don't interfere with daywrecker
			SetScrap(5, (GetMaxScrap(5) - 40))
		end
		for index = 1, x.escvlength do
			if x.escvstate[index] == 1 and not IsAlive(x.escv[index]) then
				x.escvbuildtime[index] = GetTime() + 180.0
				x.escvstate[index] = 2
			elseif x.escvstate[index] == 2 and x.escvbuildtime[index] < GetTime() then
				x.escv[index] = BuildObject("svscav", 5, GetPositionNear("epgrcy", 0, 16, 32)) --grpspwn
				x.escvstate[index] = 1
			end
		end
	end

	--CHECK STATUS OF MCA
	if not x.MCAcheck then
		if GetDistance(x.relic, "eppad") < 64 then --CCA got relic
			AudioMessage("tcss0902.wav") --9 FAIL - CCA has relic
			FailMission(GetTime() + 10.0, "tcss09f1.des") --LOSER LOSER LOSER
			ClearObjectives()
			AddObjective("tcss0905.txt", "RED") --CCA captured relic. Mission FAILED.
			x.spine = 666
			x.MCAcheck = true
		end

		if not IsAlive(x.relic) then --fury relic destroyed
			AudioMessage("tcss0903.wav") --5 FAIL - relic destroyed
			FailMission(GetTime() + 7.0, "tcss09f2.des") --LOSER LOSER LOSER
			ClearObjectives()
			AddObjective("tcss0906.txt", "RED") --CCA captured relic. Mission FAILED.
			x.spine = 666
			x.MCAcheck = true
		end

		if not IsAlive(x.frcy) then --frecy killed
			AudioMessage("tcss0904.wav") --8 FAIL - Wyom lost
			ClearObjectives()
			AddObjective("tcss0907.txt", "RED") --CCA captured relic. Mission FAILED.
			FailMission(GetTime() + 10.0, "tcss09f3.des") --LOSER LOSER LOSER
			x.spine = 666
			x.MCAcheck = true
		end

		if not x.ercydead and not IsAlive(x.ercy) and not IsAlive(x.efac) then
			AudioMessage("killedccarcygriz1.wav")
			ClearObjectives()
			AddObjective("tcss0908.txt", "GREEN") --CCA Recycler destroyed.
			x.waittime = GetTime() + 4.0 --SET UP WAITTIME FOR MISSION END CASES
			x.ercydead = true --SPECIAL
		end
	end
end
--[[END OF SCRIPT]]