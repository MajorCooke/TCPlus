--bztcrs06 - Battlezone Total Command - Red Storm - 6/8 - OUT THERE SOMEWHERE
assert(load(assert(LoadFile("_requirefix.lua")),"_requirefix.lua"))();
TCC = require("TC_Core")
MisnNum = 22;
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
	fnav = {},	
	casualty = 0,
	randompick = 0, 
	randomlast = 0,
	foldmehere = false, 
	frenemy = false, 
	frcy = nil, 
	ffac = nil, 
	farm = nil,	
	ercy = nil, 
	efac = nil, 
	earm = nil, 
	ebay = nil, 
	etrn = nil, 
	etec = nil, 
	ehqr = nil, 
	esld = nil, 
	egun = {}, 
	esil = {}, 
	epwr = {}, --the special pgens
	etnk = {}, 
	ecrainit = {}, --Faux CRA stuff
	eatkcrastate = 0, 
	eatkcraprotect = false,
	eatkcratime = 99999.9, --cra attacks 
	eatkcraabort = 99999.9, 
	ecrafac = nil,
	eatkcratrgt = nil,
	eatkcra = {},
	cracount = 0, 
	eatkcraengage = {},	
	eatkcratrgttime = {}, 
	eatkcrapos = {},	
	eatkcrago = false, 
	wreckstate = 0, --daywrecker stuff
	wrecktime = 99999.9, 
	wrecktrgt = {},
	wreckbomb = nil, 
	wreckname = "apdwrks", 
	wrecknotify = 0, 
	scrapdone = 0,
	scrap = nil, 
	freestuff = {}, --free stuff
	freestuffstate = {}, 
	freefinder = nil, 
	freestufffound = 0, 
	freevalue = 0, 
	epattime = 99999.9, --epatrols
	epatlength = 4, 
	epat = {}, 
	epatcool = {}, 
	epatallow = {},	
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
	wreckbank = false, --have 2
	escvbuildtime = {}, 
	escvstate = {},	 
	fpwr = {nil, nil, nil, nil}, 
	fcom = nil,
	fbay = nil,
	ftrn = nil,
	ftec = nil,
	fhqr = nil,
	fsld = nil, 
	ewardeclare = false, --WARCODE --1 recy, 2 fact, 3 armo, 4 base 
	ewartotal = 4,
	ewarrior = {}, 
	ewartrgt = {}, 
	ewartime = {},
	ewartimecool = {},
	ewartimeadd = {},
	ewarabort = {}, 
	ewarabortallow = {}, 
	ewarstate = {}, 
	ewarsize = {}, 
	ewarwave = {}, 
	ewarwavemax = {}, 
	ewarwavereset = {}, 
	ewarmeet = {}, 
	ewarpos = {}, 
  ewarallattack = {}, 
	LAST = true
}
--PATHS: epgfac, epgcrafac, stage1-3, ppatrol1-4, epg1-6, epmin1-2, fpnav1-2, fpmeet1-3, ppyra

function InitialSetup()
	SetAutoGroupUnits(true)
		
	local odfpreload = {
		"svscout", "svmbike", "svmisl", "svtank", "svrckt", "svwalk", "svartl", "sbpgen2", "sbgtow", 
		"kvscout", "kvmbike", "kvmisl", "kvtank", "kvrckt", "kvwalk", "kvhtnk", 
		"olybldg00", "olybldgt0", "olybldgx0", "ibnav", "apdwrks", "apcamrk", 
	}
	for k,v in pairs(odfpreload) do
		PreloadODF(v)
	end
		
	x.frcy = GetHandle("frcy")
	x.ffac = GetHandle("ffac")
	x.farm = GetHandle("farm")
	x.ercy = GetHandle("ercy")
	x.efac = GetHandle("efac")
	x.earm = GetHandle("earm")
	x.esil = GetHandle("esil")
	x.ebay = GetHandle("ebay")
	x.etrn = GetHandle("etrn")
	x.etec = GetHandle("etec")
	x.ehqr = GetHandle("ehqr")
	x.esld = GetHandle("esld")
	x.ecrafac = GetHandle("ecrafac")
	x.freestuff[1] = GetHandle("pega1")
	x.freestuff[2] = GetHandle("pega2")
	x.freestuff[3] = GetHandle("pega3")
	x.freestuff[4] = GetHandle("hart1")
	x.freestuff[5] = GetHandle("hart2")
	x.freestuff[6] = GetHandle("hart3")   
	--x.freestuff[7] = GetHandle("olypyra")
	for index = 1, 5 do
		x.epwr[index] = GetHandle(("epwr%d"):format(index))
	end
	for index = 1, 20 do
		x.egun[index] = GetHandle(("egun%d"):format(index))
	end
	for index = 3, 8 do
		Ally(index, 3) --3 fake cra ally
		Ally(index, 4) --4 enemy ai - gate guards, sep power
		Ally(index, 5) --5 std enemy ai
		Ally(index, 6) --6 enemy ai
		Ally(index, 7) --7 enemy ai
		Ally(index, 8) --8 enemy ai
	end
	Ally(1, 2) --pyramid
	Ally(2, 1)
	SetTeamColor(3, 230, 230, 230)
	SetTeamColor(6, 100, 30, 10)
	SetTeamColor(7, 30, 70, 20)
	SetTeamColor(8, 50, 70, 100)
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
  --[[if x.spine >= 0 then
    Ally(1, 3)
		Ally(3, 1)
  end
  if x.frenemy then  --x.eatkcraprotect = false
		UnAlly(1, 3)
		UnAlly(3, 1)
  end--]]
end

function AddObject(h)
	--get player base buildings for later attack
	if (not IsAlive(x.farm) or x.farm == nil) and (IsOdf(h, "kvarmo:1") or IsOdf(h, "kbarmo")) then
		x.farm = h
	elseif (not IsAlive(x.ffac) or x.ffac == nil) and (IsOdf(h, "kvfactrs06:1") or IsOdf(h, "kbfactrs06")) then
		x.ffac = h
	elseif (not IsAlive(x.fsld) or x.fsld == nil) and IsOdf(h, "kbshld") then
		x.fsld = h
	elseif (not IsAlive(x.fhqr) or x.fhqr == nil) and IsOdf(h, "kbhqtr") then
		x.fhqr = h
	elseif (not IsAlive(x.ftec) or x.ftec == nil) and IsOdf(h, "kbtcen") then
		x.ftec = h
	elseif (not IsAlive(x.ftrn) or x.ftrn == nil) and IsOdf(h, "kbtrain") then
		x.ftrn = h
	elseif (not IsAlive(x.fbay) or x.fbay == nil) and IsOdf(h, "kbsbay") then
		x.fbay = h
	elseif (not IsAlive(x.fcom) or x.fcom == nil) and IsOdf(h, "kbcbun") then
		x.fcom = h
	elseif IsOdf(h, "kbpgen2") then
		for indexadd = 1, 4 do
			if x.fpwr[indexadd] == nil or not IsAlive(x.fpwr[indexadd]) then
				x.fpwr[indexadd] = h
				break
			end
		end
	end
	
	--get new player artil for assassin group
	for indexadd = 1, x.fartlength do
		if not IsAlive(x.fart[indexadd]) and IsOdf(h, "kvartl") then
			x.fart[indexadd] = h
		end
	end
	
	--remove ENEMY CRA pilots since no cra recy and CCA to avoid sticking to pyramid.
	if IsOdf(h, "sspilo") or IsOdf(h, "kspilo") then
		if GetTeamNum(h) ~= 1 then
			RemoveObject(h)
		end
	end
	
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

	--START THE MISSION BASICS
	if x.spine == 0 then
		x.audio1 = AudioMessage("tcrs0601.wav") --CCA base near. Once recon finds, you destroy. It has special pgen
		x.mytank = BuildObject("kvhtnk", 1, "pmytank")
		SetAsUser(x.mytank, 1)
		RemoveObject(x.player)
		x.player = GetPlayerHandle()
		x.freestuff[7] = BuildObject("olybldgx0", 0, "ppyra")
		for index = 2, 4 do
			x.pos = GetTransform(x.epwr[index])
			RemoveObject(x.epwr[index])
			x.epwr[index] = BuildObject("sbpgen1rs06", (index+4), x.pos)
		end
		for index = 1, 6 do
			x.pos = GetTransform(x.egun[index])
			RemoveObject(x.egun[index])
			x.egun[index] = BuildObject("sbgtow", 6, x.pos)
			x.pos = GetTransform(x.egun[index+6])
			RemoveObject(x.egun[index+6])
			x.egun[index+6] = BuildObject("sbgtow", 7, x.pos)
			x.pos = GetTransform(x.egun[index+12])
			RemoveObject(x.egun[index+12])
			x.egun[index+12] = BuildObject("sbgtow", 8, x.pos)
		end
		x.pos = GetTransform(x.epwr[5])
		RemoveObject(x.epwr[5])
		x.epwr[5] = BuildObject("sbpgen2", 4, x.pos)
		for index = 19, 20 do
			x.pos = GetTransform(x.egun[index])
			RemoveObject(x.egun[index])
			x.egun[index] = BuildObject("sbgtow", 4, x.pos)
		end
		x.fnav[1] = BuildObject("apcamrk", 1, "fpnav1")
		SetObjectiveName(x.fnav[1], "Deploy Zone")
		for index = 1, 7 do
			x.freestuffstate[index] = 0
		end
		for index = 1, 3 do --create and init multidim array - filled later
			x.ecrainit[index] = {} --"rows"
			for index2 = 1, 3 do
				x.ecrainit[index][index2] = nil --"columns", init value (handle in this case)
			end
		end
		x.epattime = GetTime() + 120.0 --init epat
		for index = 1, x.epatlength do --init epat
			x.epatcool[index] = GetTime()
			x.epatallow[index] = true
		end
		SetScrap(1, 80)
		SetScrap(5, 40)
		Ally(1, 3)
		Ally(3, 1)
		x.spine = x.spine + 1
	end
	
	--GIVE FIRST OBJECTIVE
	if x.spine == 1 and IsAudioMessageDone(x.audio1) then
		ClearObjectives()
		AddObjective("tcrs0601.txt")
		x.waittime = GetTime() + 120.0
		x.spine = x.spine + 1
	end

	--NOTIFIY CCA BASE FOUND 
	if x.spine == 2 and x.waittime < GetTime() then
		x.audio1 = AudioMessage("tcrs0602.wav") --Cmd we have found Russian base. / NAV drop, avenge deaths
		x.spine = x.spine + 1
	end
	
	--MARK CCA BASE
	if x.spine == 3 and IsAudioMessageDone(x.audio1) then
		ClearObjectives()
		AddObjective("tcrs0602.txt")
		AddObjective("	")
		AddObjective("tcrs0603.txt", "YELLOW")
		x.fnav[2] = BuildObject("ibnav", 1, "fpnav2") --nav so player can't "see" base w/out going there
		SetObjectiveName(x.fnav[2], "CCA Base")
		x.waittime = GetTime() + 20.0
		x.spine = x.spine + 1
	end

	--RUSSIAN CHINESE MESSAGE
	if x.spine == 4 and x.waittime < GetTime() then
		AudioMessage("tcrs0603.wav") --(RUS as CRA) - Hello comrades, we help, we ETA 5 min from you
		AudioMessage("tcrs0604.wav") --This will be difficult. You are welcome to join our strike.
		x.waittime = GetTime() + 60.0
		x.spine = x.spine + 1
	end

	--BUILD "FALLY" FORCE
	if x.spine == 5 and x.waittime < GetTime() then
		for index = 1, 3 do
			x.ecrainit[index][1] = BuildObject("kvmisl", 3, ("epg%d"):format(index))
      SetCanSnipe(x.ecrainit[index][1], 0)
			Goto(x.ecrainit[index][1], ("fpmeet%d"):format(index))
			x.ecrainit[index][2] = BuildObject("kvtank", 3, ("epg%d"):format(index))
      SetCanSnipe(x.ecrainit[index][2], 0)
			Goto(x.ecrainit[index][2], ("fpmeet%d"):format(index))
			x.ecrainit[index][3] = BuildObject("kvmbike", 3, ("epg%d"):format(index))
      SetCanSnipe(x.ecrainit[index][3], 0)
			Goto(x.ecrainit[index][3], ("fpmeet%d"):format(index))
		end
		x.frenemy = true
		x.eatkcraprotect = true
		x.spine = x.spine + 1
	end

	--"FALLY" AT BASE
	if x.spine == 6 then
		for index = 1, 3 do
			for index2 = 1, 3 do
				if GetDistance(x.ecrainit[index][index2], ("fpmeet%d"):format(index)) < 80 then
					x.casualty = x.casualty + 1 --used as a counter here
				end
			end
		end
		
		if x.casualty > 6 then
			x.ecracloakstate = 1
		end
		x.casualty = 0
		
		if x.ecracloakstate == 1 then
			for index = 1, 3 do
				for index2 = 1, 3 do
					SetCommand(x.ecrainit[index][index2], 47) --47 = CMD_MORPH_SETDEPLOYED // For morphtanks
				end
			end
			x.waittime = GetTime() + 20.0
			x.spine = x.spine + 1
		end
	end
	
	--START FALLY PATROL
	if x.spine == 7 and x.waittime < GetTime() then
	--for some reason, this works better than using a for loop
		Patrol(x.ecrainit[1][1], "fpatrol1")
		Patrol(x.ecrainit[1][2], "fpatrol1")
		Patrol(x.ecrainit[1][3], "fpatrol1")
		Patrol(x.ecrainit[2][1], "fpatrol2")
		Patrol(x.ecrainit[2][2], "fpatrol2")
		Patrol(x.ecrainit[2][3], "fpatrol2")
		Patrol(x.ecrainit[3][1], "fpatrol3")
		Patrol(x.ecrainit[3][2], "fpatrol3")
		Patrol(x.ecrainit[3][3], "fpatrol3")
		x.waittime = GetTime() + 30.0
		x.spine = x.spine + 1
	end
	
	--SEND INIT CCA ATTACK
	if x.spine == 8 and x.waittime < GetTime() then
		for index = 1, 3 do
			x.etnk[index] = BuildObject("svtank", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
			x.etnk[index+3] = BuildObject("svscout", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
			x.etnk[index+6] = BuildObject("svmisl", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
		end
		for index = 1, 3 do --give orders
			if IsAlive(x.frcy) then
				Attack(x.etnk[index], x.frcy)
			else
				Attack(x.etnk[index], x.player)
			end
			if IsAlive(x.ffac) then
				Attack(x.etnk[index+3], x.ffac)
			else
				Attack(x.etnk[index+3], x.player)
			end
			if IsAlive(x.farm) then
				Attack(x.etnk[index+6], x.farm)
			else
				Attack(x.etnk[index+6], x.player)
			end
		end
		for index = 1, 20 do
			x.randompick = math.floor(GetRandomFloat(1.0, 30.0))
		end
		if x.randompick % 3 == 0 then
			x.waittime = GetTime() + 40.0
		elseif x.randompick % 2 == 0 then
			x.waittime = GetTime() + 50.0
		else
			x.waittime = GetTime() + 60.0
		end
		x.spine = x.spine + 1
	end
	
	--BEGIN FALLY ATTACK
	if x.spine == 9 and x.waittime < GetTime() then
		x.frenemy = true
		x.eatkcraprotect = false
		UnAlly(1, 3)
		UnAlly(3, 1)
		for index = 1, 3 do
			if IsAlive(x.frcy) then
				Attack(x.ecrainit[1][index], x.frcy)
			else
				Attack(x.ecrainit[1][index], x.player)
			end
			if IsAlive(x.ffac) then
				Attack(x.ecrainit[2][index], x.ffac)
			else
				Attack(x.ecrainit[2][index], x.player)
			end
			if IsAlive(x.farm) then
				Attack(x.ecrainit[3][index], x.farm)
			else
				Attack(x.ecrainit[3][index], x.player)
			end
		end
		for index = 1, 3 do
			for index2 = 1, 3 do
				SetSkill(x.ecrainit[index][index2], x.skillsetting) --yup, way down here
				SetCommand(x.ecrainit[index][index2], 48) --48 = CMD_MORPH_SETUNDEPLOYED // For morphtanks
			end
		end
		x.waittime = GetTime() + 4.0
		x.spine = x.spine + 1
	end

	--REALIZE ALLIES ARE ENEMIES
	if x.spine == 10 and x.waittime < GetTime() then
		AudioMessage("tcrs0605.wav") --What going on. Maj, they are Russian, destroy them.
		x.spine = x.spine + 1
	end

	--FALLY DEAD START REGULAR ATTACKS
	if x.spine == 11 then
		for index = 1, 3 do
			for index2 = 1, 3 do
				if not IsAlive(x.ecrainit[index][index2]) then
					x.casualty = x.casualty + 1
				end
			end
		end
		
		if x.casualty >= 7 then
			AudioMessage("tcrs0606.wav") --It seems Rus made use of our fact and units.			
			for index = 1, x.ewartotal do --init WARCODE
				x.ewardeclare = true
				x.ewarrior[index] = {} --"rows"
        x.ewarpos[index] = {}
        x.ewarallattack[index] = 0 
				for index2 = 1, 10 do --10 per wave max avail
					x.ewarrior[index][index2] = nil --"columns", init (handle in this case)
          x.ewarpos[index][index2] = nil
				end
				x.ewartrgt[index] = nil 
				x.ewarstate[index] = 1
				x.ewartime[1] = GetTime() + 60.0 --recy
				x.ewartime[2] = GetTime() + 120.0 --fact
				x.ewartime[3] = GetTime() + 180.0 --armo
				x.ewartime[4] = GetTime() + 240.0 --base
				x.ewartimecool[index] = 180.0
				x.ewartimeadd[index] = 0.0
				x.ewarabort[index] = 99999.9
				x.ewarabortallow[index] = false
				x.ewarsize[index] = 0
				x.ewarwave[index] = 0
				x.ewarwavemax[index] = 5
				x.ewarwavereset[index] = 2
				x.ewarmeet[index] = 2
			end
			for index = 1, x.ekillartlength do --init ekillart
				x.ekillarttime = GetTime()
				x.ekillart[index] = nil 
				x.ekillartcool[index] = 99999.9 
				x.ekillartallow[index] = false
			end
			x.wrecktime = GetTime() + 120.0
			x.eatkcrastate = 1
			x.eatkcratime = GetTime() + 120.0
			x.waittime = GetTime() + 30.0
			x.spine = x.spine + 1
		end
		x.casualty = 0
	end
	
	--NOTIFY CTHONIAN ARTIFACTS
	if x.spine == 12 and x.waittime < GetTime() then
		ClearObjectives()
		AddObjective("tcrs0602b.txt")
		AddObjective("	")
		AddObjective("tcrs0603.txt", "YELLOW")
		AddObjective("	")
		AddObjective("tcrs0604.txt", "ALLYBLUE")
		for index = 1, x.escvlength do --init escv
			x.escvbuildtime[index] = GetTime()
			x.escvstate[index] = 1
		end
		x.spine = x.spine + 1
	end

	--STOP ATTACKS IF ALL AI PRODUCTION BUILDINGS DESTROYED
	if x.spine == 13 and not IsAlive(x.ercy) and not IsAlive(x.efac) and not IsAlive(x.ecrafac) then  --removed armory and adv power gens
		x.ewardeclare = false
		x.epattime = 99999.9
		x.eturtime = 99999.9
		x.ekillarttime = 99999.9
		x.ecratime = 99999.9
		x.wrecktime = 99999.9
		x.bombsaway = false
		x.waittime = GetTime() + 3.0
		x.MCAcheck = true
		x.spine = x.spine + 1
	end
	
	--PRESUCCESS MESSAGE
	if x.spine == 14 and x.waittime < GetTime() then
		x.audio1 = AudioMessage("tcrs0607.wav") --SUCCEED - No more Rus presence on Elysium. RTB Ganymede for Europ
		ClearObjectives()
		AddObjective("tcrs0605.txt", "GREEN")
		x.spine = x.spine + 1
	end
	
	--SUCCEED MISSION
	if x.spine == 15 and IsAudioMessageDone(x.audio1) then
		SucceedMission(GetTime(), "tcrs06w.des") --WINNER WINNER WINNER
		x.spine = 666
	end
	----------END MAIN SPINE ----------
	
	--KEEP FAKE CRA ALLY
	if not x.frenemy then
		Ally(1,3)
		Ally(3,1)
	end
	
	--PROTECT FAKE ALLY FROM EARLY DAMAGE
	if x.eatkcraprotect then
		for index = 1, 3 do
			for index2 = 1, 3 do
				if GetCurHealth(x.ecrainit[index][index2]) < GetMaxHealth(x.ecrainit[index][index2]) then
					SetCurHealth(x.ecrainit[index][index2], GetMaxHealth(x.ecrainit[index][index2]))
				end
			end
		end
	end
	
	--MARK FOUND FREE STUFF
	if x.freestufffound < 8 then
		for index = 1, 7 do
			if x.freestuffstate[index] == 0 then
				x.freefinder = GetNearestVehicle(x.freestuff[index]) --works b/c no nearby enemies
				if GetDistance(x.freefinder, x.freestuff[index]) < 400 and GetTeamNum(x.freefinder) == 1 then
					StartSoundEffect("emspin.wav") --world zoom 6s plus long silence keep as sfx
					SetObjectiveName(x.freestuff[index], "ID Artifact")
					SetObjectiveOn(x.freestuff[index])
					x.freestuffstate[index] = 1
					x.freestufffound = x.freestufffound + 1
				end
			end
		end
		if x.freestufffound == 7 then
			x.freestufffound = 8
		end
	end
	
	--HAND OUT FREE STUFF TO THE CURIOUS - must be unique odfs, unique handle doesn't work as expected
	if not x.foldmehere then --player must be near, not just id from sat view
				if x.freestuffstate[1] == 1 and GetDistance(x.player,x.freestuff[1]) < 150 and IsInfo(x.freestuff[1]) then --pega1
			x.freevalue = 1
		elseif x.freestuffstate[2] == 1 and GetDistance(x.player,x.freestuff[2]) < 150 and IsInfo(x.freestuff[2]) then --pega2
			x.freevalue = 2
		elseif x.freestuffstate[3] == 1 and GetDistance(x.player,x.freestuff[3]) < 150 and IsInfo(x.freestuff[3]) then --pega3
			x.freevalue = 3
		elseif x.freestuffstate[4] == 1 and GetDistance(x.player,x.freestuff[4]) < 150 and IsInfo(x.freestuff[4]) then --hart1
			x.freevalue = 4
		elseif x.freestuffstate[5] == 1 and GetDistance(x.player,x.freestuff[5]) < 150 and IsInfo(x.freestuff[5]) then --hart2
			x.freevalue = 5
		elseif x.freestuffstate[6] == 1 and GetDistance(x.player,x.freestuff[6]) < 150 and IsInfo(x.freestuff[6]) then --hart3
			x.freevalue = 6
		elseif x.freestuffstate[7] == 1 and GetDistance(x.player,x.freestuff[7]) < 200 and IsInfo(x.freestuff[7]) then --olypyra
			x.freevalue = 7
		end
		
		if x.freevalue > 0 then
			SetObjectiveOff(x.freestuff[x.freevalue])
			SetObjectiveName(x.freestuff[x.freevalue], GetODFString(x.freestuff[x.freevalue], "GameObjectClass", "unitName"))
			SetTeamNum(x.freestuff[x.freevalue], 1)
			if x.freevalue ~= 7 then
				SetGroup(x.freestuff[x.freevalue], 6)
				StartSoundEffect("pow_done.wav") --decent short
			end
			if x.freevalue == 7 then
				x.pos = GetTransform(x.freestuff[7])
				RemoveObject(x.freestuff[7])
				x.freestuff[7] = BuildObject("olybldg00", 2, x.pos)
				StartSoundEffect("pow_done.wav") --decent short
			end
			x.freestuffstate[x.freevalue] = 2
			x.freevalue = 0
		end
	end
	
	--AI DAYWRECKER ATTACK
	if x.wreckstate == 0 and x.wrecktime < GetTime() and IsAlive(x.etec) and IsAlive(x.earm) and GetMaxScrap(5) >= 80 then
		if GetScrap(5) < 80 then 
			AddScrap(5, 80) --gotta have money
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
			x.wrecktime = GetTime() + 480.0
		elseif x.randompick == 2 or x.randompick == 5 or x.randompick == 8 then
			x.wrecktime = GetTime() + 360.0
		else
			x.wrecktime = GetTime() + 240.0
		end
		x.wreckstate = 0 --reset
	end

	--CCA GROUP SCOUT PATROLS ----------------------------------
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
					x.epat[index] = BuildObject("svscout", 5, ("ppatrol%d"):format(index))
				elseif x.randompick == 2 or x.randompick == 7 or x.randompick == 12 then
					x.epat[index] = BuildObject("svmbike", 5, ("ppatrol%d"):format(index))
				elseif x.randompick == 3 or x.randompick == 8 or x.randompick == 13 then
					x.epat[index] = BuildObject("svmisl", 5, ("ppatrol%d"):format(index))
				elseif x.randompick == 4 or x.randompick == 9 or x.randompick == 14 then
					x.epat[index] = BuildObject("svtank", 5, ("ppatrol%d"):format(index))
				else
					x.epat[index] = BuildObject("svrckt", 5, ("ppatrol%d"):format(index))
				end
				SetSkill(x.epat[index], x.skillsetting)
				Patrol(x.epat[index], ("ppatrol%d"):format(index))
				--SetObjectiveName(x.epat[index], ("Patrol %d"):format(index))
				x.epatallow[index] = false
			end
		end
		x.epattime = GetTime() + 300.0
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
				x.escv[index] = BuildObject("svscav", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
				x.escvstate[index] = 1
			end
		end
	end

	--WARCODE --SPECIAL WALKER WEIGHTED  --USES EWARPOS TO AVOID WALKERS GETTING STUCK ON PYRAMID (special 400 range to attack)
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
						x.ewarsize[index] = 4
					elseif x.ewarwave[index] == 3 then
						x.ewarsize[index] = 6
					elseif x.ewarwave[index] == 4 then
						x.ewarsize[index] = 8
					else --x.ewarwave[index] == 5 then
						x.ewarsize[index] = 10
					end
					x.ewarstate[index] = x.ewarstate[index] + 1
				end
				
				--BUILD FORCE
				if x.ewarstate[index] == 2 then
					for index2 = 1, x.ewarsize[index] do
						while x.randompick == x.randomlast do --random the random
							x.randompick = math.floor(GetRandomFloat(1.0, 21.0)) --single 0-n inclusive, or double n1-nx inclusive
						end
						x.randomlast = x.randompick
						if not IsAlive(x.efac) then
							x.randompick = 1
						end
						if x.randompick == 1 or x.randompick == 8 or x.randompick == 15 then
							x.ewarrior[index][index2] = BuildObject("svscout", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
							if x.ewarwave[index] == 3 or x.ewarwave[index] == 4 then
								GiveWeapon(x.ewarrior[index][index2], "glasea_c")
							end
						elseif x.randompick == 2 or x.randompick == 9 or x.randompick == 16 then
							x.ewarrior[index][index2] = BuildObject("svmbike", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
							if x.ewarwave[index] == 2 or x.ewarwave[index] == 4 then
								GiveWeapon(x.ewarrior[index][index2], "gstbva_c")
							end
						elseif x.randompick == 3 or x.randompick == 10 or x.randompick == 17 or x.randompick == 20 then
							x.ewarrior[index][index2] = BuildObject("svmisl", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
							if x.ewarwave[index] == 3 or x.ewarwave[index] == 5 then
								GiveWeapon(x.ewarrior[index][index2], "gfafma_c")
							end
						elseif x.randompick == 4 or x.randompick == 11 or x.randompick == 18 or x.randompick == 21 then
							x.ewarrior[index][index2] = BuildObject("svtank", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
							if x.ewarwave[index] == 4 or x.ewarwave[index] == 5 then
								GiveWeapon(x.ewarrior[index][index2], "gstbsa_c")
							end
						elseif x.randompick == 5 or x.randompick == 12 then
							x.ewarrior[index][index2] = BuildObject("svrckt", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
							if x.ewarwave[index] == 3 or x.ewarwave[index] == 5 then
								GiveWeapon(x.ewarrior[index][index2], "gshdwa_a") --salvo rckt
							end
						elseif x.randompick == 6 or x.randompick == 13 then
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
						else --7, 14, 19
							x.ewarrior[index][index2] = BuildObject("svartl", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
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
						if IsAlive(x.ewarrior[index][index2]) and GetDistance(x.ewarrior[index][index2], ("stage%d"):format(x.ewarmeet[index]), 4) < 100 and GetTeamNum(x.ewarrior[index][index2]) ~= 1 then
							x.ewarstate[index] = x.ewarstate[index] + 1
							break
						end
					end
				end
			
				--PICK INITIAL TARGET
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
							x.ewarpos[index][index2] = GetPosition(x.ewartrgt[index])
							if not x.ewarabortallow[index] then
								x.ewarabort[index] = x.ewartime[index] + 420.0
								x.ewarabortallow[index] = true
							end
						end
						Goto(x.ewarrior[index][index2], x.ewarpos[index][index2])
					end
					x.ewarstate[index] = x.ewarstate[index] + 1
				end
				
				--GIVE ATTACK ORDER
				if x.ewarstate[index] == 6 then
          for index2 = 1, x.ewarsize[index] do
            if (x.ewarrior[index][index2]) and GetTeamNum(x.ewarrior[index][index2]) ~= 1 and GetDistance(x.ewarrior[index][index2], x.ewarpos[index][index2]) < 500 then
              if not IsAlive(x.ewartrgt[index]) and IsAlive(x.frcy) then  --do final target check
                x.ewartrgt[index] = x.frcy
              elseif not IsAlive(x.ewartrgt[index]) and not IsAlive(x.frcy) then
                x.ewartrgt[index] = x.player
              end
              x.ewarallattack[index] = 1
            end
          end
          if x.ewarallattack[index] == 1 then
            for index2 = 1, x.ewarsize[index] do
              Attack(x.ewarrior[index][index2], x.ewartrgt[index])
            end
            x.ewarallattack[index] = 0
            x.ewarstate[index] = x.ewarstate[index] + 1
          end
				end
				
				--CHECK CASUALTY AND RESET
				if x.ewarstate[index] == 7 then
					for index2 = 1, x.ewarsize[index] do
						if not IsAlive(x.ewarrior[index][index2]) or (IsAlive(x.ewarrior[index][index2]) and GetTeamNum(x.ewarrior[index][index2]) == 1) then
							x.casualty = x.casualty + 1
						end
					end
					if x.casualty >= math.floor(x.ewarsize[index] * 0.8) then
						x.ewarabort[index] = 99999.9
						x.ewartimeadd[index] = x.ewartimeadd[index] + 10.0 --slow attacks so player has time for counterattack
						x.ewartime[index] = GetTime() + x.ewartimecool[index] + x.ewartimeadd[index]
						if x.ewarwave[index] == 5 then --extra time after last wave to "ease up"
							x.ewartime[index] = GetTime() + x.ewartimecool[index] + x.ewartimeadd[index] + 120.0
						end
						x.ewarabortallow[index] = false
						x.ewarstate[index] = 1 --RESET
            
						for index2 = 1, x.ewarsize[index] do
							if IsAlive(x.ewarrior[index][index2]) and GetTeamNum(x.ewarrior[index][index2]) ~= 1 then
								Attack(x.ewarrior[index][index2], x.frcy)
							end
						end
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
								Attack(x.ewarrior[index][index2], x.frcy)  --x.ewartrgt[index])
							end
						end
					end
				end
			end
			
			--ABORT AND RESET IF NEEDED
			if x.ewarabort[index] < GetTime() then
				for index2 = 1, x.ewarsize[index] do --kill all, 1+ might be stuck on terrain
					if IsAlive(x.ewarrior[index][index2]) then
						Damage(x.ewarrior[index][index2], 20000)
					end
				end
				x.ewartime[index] = GetTime()
				x.ewarstate[index] = 1 --RESET
				x.ewarabort[index] = 99999.9
				x.ewarabortallow[index] = false
			end
		end
	end--WARCODE END
	
	--AI ARTILLERY ASSASSIN
	if x.ekillarttime < GetTime() and IsAlive(x.efac) then
		for index = 1, x.ekillartlength do
			if (not IsAlive(x.ekillart[index]) or (IsAlive(x.ekillart[index]) and GetTeamNum(x.ekillart[index]) == 1)) and not x.ekillartallow[index] then
				x.ekillartcool[index] = 120.0
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
	
	--CHINESE ATTACK --in DW scripts, done more efficiently as WARCODE variant
	if x.eatkcrastate > 0 and IsAlive(x.ecrafac) then
		if x.eatkcrastate == 1 and x.eatkcratime < GetTime() then --build force, set skill, cloak
			x.eatkcra[1] = BuildObject("kvmbike", 3, GetPositionNear("epgcrafac", 0, 16, 32))
			x.eatkcra[2] = BuildObject("kvmisl", 3, GetPositionNear("epgcrafac", 0, 16, 32))
			x.eatkcra[3] = BuildObject("kvtank", 3, GetPositionNear("epgcrafac", 0, 16, 32))
			x.eatkcra[4] = BuildObject("kvrckt", 3, GetPositionNear("epgcrafac", 0, 16, 32))
			x.eatkcra[5] = BuildObject("kvmbike", 3, GetPositionNear("epgcrafac", 0, 16, 32))
			x.eatkcra[6] = BuildObject("kvmisl", 3, GetPositionNear("epgcrafac", 0, 16, 32))
			x.eatkcra[7] = BuildObject("kvtank", 3, GetPositionNear("epgcrafac", 0, 16, 32))
			x.eatkcra[8] = BuildObject("kvrckt", 3, GetPositionNear("epgcrafac", 0, 16, 32))
			x.cracount = 8  --never changes, but just leave variable anyway
			for index = 1, x.cracount do
				x.eatkcraengage[index] = 0
				SetSkill(x.eatkcra[index], x.skillsetting)
				SetCommand(x.eatkcra[index], 47) --47 = CMD_MORPH_SETDEPLOYED // For morphtanks
			end
			x.eatkcraabort = GetTime() + 360.0
			x.eatkcrastate = x.eatkcrastate + 1
		elseif x.eatkcrastate == 2 then --after cmd pause goto stage
			for index = 1, x.cracount do
				Goto(x.eatkcra[index], "stage3")
			end
			x.eatkcrastate = x.eatkcrastate + 1
		elseif x.eatkcrastate == 3 then --count at stage point
			for index = 1, x.cracount do
				if IsAlive(x.eatkcra[index]) and GetDistance(x.eatkcra[index], "stage3", 3) < 100 then
					x.casualty = x.casualty + 1 --COUNT, NOT casualty
				end
			end
			if x.casualty >= 3 then
				x.eatkcrastate = x.eatkcrastate + 1
			end
			x.casualty = 0
		elseif x.eatkcrastate == 4 then --pick and goto target
			if IsAlive(x.ffac) then
				x.eatkcrapos = GetPosition(x.ffac) 
				x.eatkcratrgt = 1
			elseif IsAlive(x.farm) then
				x.eatkcrapos = GetPosition(x.farm)
				x.eatkcratrgt = 2
			elseif IsAlive(x.frcy) then
				x.eatkcrapos = GetPosition(x.frcy)
				x.eatkcratrgt = 3
			else
				x.eatkcrapos = GetPosition(x.player)
				x.eatkcratrgt = 4
			end
			for index = 1, x.cracount do
				Retreat(x.eatkcra[index], x.eatkcrapos)
			end
			x.eatkcrago = true
			x.eatkcrastate = x.eatkcrastate + 1
		elseif x.eatkcrastate == 5 then
			for index = 1, x.cracount do
				if not IsAlive(x.eatkcra[index]) or (IsAlive(x.eatkcra[index]) and GetTeamNum(x.eatkcra[index]) == 1) then
					x.casualty = x.casualty + 1
				end
			end
			if x.casualty >= math.floor(x.cracount * 0.8) then --reset countdown
        for index = 1, x.cracount do
          if IsAlive(x.eatkcra[index]) and GetTeamNum(x.eatkcra[index]) ~= 1 then  --decloak if rest of force destroyed
            SetCommand(x.eatkcra[index], 48) --48 = CMD_MORPH_SETUNDEPLOYED // For morphtanks
          end
        end
				if x.skillsetting == x.easy then
					x.eatkcratime = GetTime() + 300.0
				elseif x.skillsetting == x.medium then
					x.eatkcratime = GetTime() + 240.0
				else
					x.eatkcratime = GetTime() + 180.0
				end
				x.eatkcraabort = 99999.9
				x.eatkcrago = false
				x.eatkcrastate = 1 --set back to 1
			end
			x.casualty = 0
		end
	end
	
	--CRA DECLOAK FOR ATTACK
	if x.eatkcrago then
		for index = 1, x.cracount do
			if x.eatkcraengage[index] == 0 and IsAlive(x.eatkcra[index]) and GetTeamNum(x.eatkcra[index]) ~= 1 and GetDistance(x.eatkcra[index], x.eatkcrapos) < 150 then
        SetIndependence(x.eatkcra[index], 0) --try to ensure follow uncloak order
				SetCommand(x.eatkcra[index], 48) --48 = CMD_MORPH_SETUNDEPLOYED // For morphtanks
				x.eatkcratrgttime[index] = GetTime() + 1.0
				x.eatkcraengage[index] = 1
			end
			--send actual attack
			if x.eatkcraengage[index] == 1 and x.eatkcratrgttime[index] < GetTime() then
				if x.eatkcratrgt == 1 then
					if IsAlive(x.ffac) then 
						Attack(x.eatkcra[index], x.ffac)
					elseif IsAlive(x.farm) then
						Attack(x.eatkcra[index], x.farm)
					elseif IsAlive(x.frcy) then
						Attack(x.eatkcra[index], x.frcy)
					else
						Attack(x.eatkcra[index], x.player)
					end
				elseif x.eatkcratrgt == 2 then
					if IsAlive(x.farm) then 
						Attack(x.eatkcra[index], x.farm)
					elseif IsAlive(x.ffac) then
						Attack(x.eatkcra[index], x.ffac)
					elseif IsAlive(x.frcy) then
						Attack(x.eatkcra[index], x.frcy)
					else
						Attack(x.eatkcra[index], x.player)
					end
				elseif x.eatkcratrgt == 3 and IsAlive(x.frcy) then
					if IsAlive(x.frcy) then 
						Attack(x.eatkcra[index], x.frcy)
					elseif IsAlive(x.ffac) then
						Attack(x.eatkcra[index], x.ffac)
					elseif IsAlive(x.farm) then
						Attack(x.eatkcra[index], x.farm)
					else
						Attack(x.eatkcra[index], x.player)
					end
				else --just player, likely never run
					Attack(x.eatkcra[index], x.player)
				end
				x.eatkcraengage[index] = 2
			end
		end
	end
	
	--CRA FAC DEAD, SHUT IT DOWN
	if x.eatkcrastate > 0 and not IsAlive(x.ecrafac) then
		x.eatkcrastate = 0
		x.eatkcraabort = 99999.9
	end
	
	--CRA ABORT AND RESTART IF NECESSARY
	if x.eatkcraabort < GetTime() then --abort and reset if stage not reached in time
		for index = 1, x.cracount do
      if IsAlive(x.eatkcra[index]) and GetTeamNum(x.eatkcra[index]) ~= 1 then
        SetCommand(x.eatkcra[index], 48) --48 = CMD_MORPH_SETUNDEPLOYED // For morphtanks
      end
		end
		x.eatkcrastate = 1
	end
	
	--CHECK STATUS OF MISSION-CRITICAL ASSETS (MCA)
	if not x.MCAcheck then
		if not IsAlive(x.frcy) then
			AudioMessage("tcrs0206.wav") --FAIL You have failed the Repub, MAJOR, your dishonor knows no bounds
			ClearObjectives()
			AddObjective("tcrs0606.txt", "RED")
			FailMission(GetTime() + 10.0, "tcrs06f1.des") --LOSER LOSER LOSER
			x.spine = 666
			x.MCAcheck = true
		end
	end
end
--[[END OF SCRIPT]]