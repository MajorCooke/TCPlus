--bztcrs08 - Battlezone Total Command - Red Storm - 8/8 - LIGHT UP AND LET GO
assert(load(assert(LoadFile("_requirefix.lua")),"_requirefix.lua"))();
TCC = require("TC_Core")
MisnNum = 27;
--DECLARE variables --f-friend, e-enemy, atk-attack, rcy-recycler, etc..., 
local index = 1
local index2 = 1
local indexadd = 1
local indexadd2 = 1
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
	pos = {},	
	audio1 = nil, 
	audio6 = nil, 
	fnav = {},
	randompick = 0, 
	randomlast = 0, 
	casualty = 0, 
	cnslcmdvalue = 0, 
	failstate = 0, 
	frcy = nil, 
	ffac = nil, 
	fcon = {}, 
	fally = {},
	fallytime = {}, 
	fallystate = {}, 
	eclkjam = nil, 
	eclkjamdead = false, 
	efac = nil, 
	escv = {}, --scav stuff
	escvlength = 2, 
	wreckbank = false, --have 2
	escvbuildtime = {}, 
	escvstate = {}, 
	etur = {}, --20
	egun = {}, --48
	egunteam = 0, 
	epwr = {}, --1-28
	epad = nil, 
	ecne = nil, 
	ecnedead = false, 
	eapc = {}, --convoy stuff
	eapcstate = 0, 
	eapclive = {}, 
	eapctime = 99999.9,	
	eatk = {},
	epilo = {}, 
	epilostate = {}, 
	emit = {}, 
	ebay = nil, 
	etrn = nil, 
	etec = nil, 
	esld1 = nil, 
	esld2 = nil, 
	ecomcandie = 0, 
	ecom1 = nil, 
	ecom2 = nil, 
	esolar1 = nil, 
	esolar2 = nil, 
	etimertime = 99999.9, 
	etimerstate = 0, 
	camstate = 0, 
	camheight = 300, 
  camfov = 60,  --185 default
	userfov = 90,  --seed
	fcam1 = nil, 
	bdrp = nil, --end cutscene
	brcy = nil, 
	posbdrp = {}, 
	posbrcy = {}, 
	posktnk1 = {}, 
	posktnk2 = {}, 
	posktnk3 = {}, 
	inartl = false, 
	envirostate = 0, 
	envirotime = 99999.9, --environment
	redsun = 200, 
	redamb = 90, 
	redfog = 40,
	fogrng1 = 300,
	fogrng2 = 400, 
	boombool = false, 
	wreckstate = 0, --daywrecker stuff
	wrecktime = 99999.9, 
	wrecktrgt = {},
	wreckbomb = nil, 
	wreckname = "apdwrks", 
	wrecknotify = 0, 
	epattime = 99999.9, --epatrols
	epatlength = 2, 
	epat = {}, 
	epatcool = {}, 
	epatallow = {}, 
	easstime = 99999.9, --eassassins
	easslength = 6, 
	eass = {}, 
	easscool = {}, 
	eassallow = {},
	eassresendtime = 99999.9, 
	ewardeclare = false, --WARCODE --1 recy, 2 fact, 3 armo, 4 base 
	ewartotal = 4, 
	ewarrior = {}, 
	ewartrgt = {}, 
	ewartime = {},
	ewartimecool = {},
	ewartimeadd = {}, --not used in revision
	ewarabort = {}, 
	ewarstate = {}, 
	ewarsize = {}, 
	ewarwave = {}, 
	ewarwavemax = {}, 
	ewarwavereset = {}, 
	ewarmeet = {}, 
	ewaraddskill = 0, 
	weappick = 0, 
	weaplast = 0, 
	fpwr = {nil, nil, nil, nil}, 
	fcom = nil,
	fbay = nil,
	ftrn = nil,
	ftec = nil,
	fhqr = nil,
	fsld = nil,
	LAST = true
}
--Paths:	pmytank, fpnav1-2, fpfally1-2, apcarea0-2, epapc(sep), epapc1-2, eproute, epturn, epapcstop, fortressarea, pcam1-4, fprcy, fpfac, fparm, fpcon, fpscv1-2, epmits, mitsarea1-2, epgfac1-2, stage1-2, epsnip(0-50), epart1-2, eppwr(0-18), stoparea, getoutarea, eptur(0-28), ppatrol1-2, pboom1-3(0-100), bproute, bpdeploy, lowarea, midarea, toparea, ppool3-6(NOT USED)

function InitialSetup()
	SetAutoGroupUnits(true)
	
	local odfpreload = {
		"sspilors01", "svturr", "svscout", "svapcrs08", "svwalk", "svscav", "svstnk", "sbpgen0", "sbgtow", "sblpad2", "sbcone1", 
		"kvtank", "kvrecyrs08a", "kvrecyrs08b", "kvfactrs08a", "kvfactrs08b", "kvconsrs08a", "kvconsrs08b", "kvarmo",	
		"apdwrks", "omitsars08", "olybolt2", "gflarpot22", "oboompot", "dummy00", "bvrecy", "bvdrop", "apcamrk"
	}
	for k,v in pairs(odfpreload) do
		PreloadODF(v)
	end

	--x.mytank = GetHandle("mytank")
	x.ecom1 = GetHandle("ecom1")
	x.ecom2 = GetHandle("ecom2")
	x.esolar1 = GetHandle("solar1")
	x.esolar2 = GetHandle("solar2")
	x.eclkjam = GetHandle("clkjam")
	x.ercy = GetHandle("ercy")
	x.efac = GetHandle("efac")
	x.earm = GetHandle("earm")
	x.eatk[3] = GetHandle("eatk1") --3 golem
	x.eatk[4] = GetHandle("eatk2") --4 golem
	x.ecom = GetHandle("ecom")
	x.ebay = GetHandle("ebay")
	x.etrn = GetHandle("etrn")
	x.etec = GetHandle("etec")
	x.ehqr = GetHandle("ehqr")
	x.esld1 = GetHandle("esld1")
	x.esld2 = GetHandle("esld2")
	x.epad = GetHandle("lpad") --not "epad"
	--x.ecne = GetHandle("ecne")
	x.bdrp = GetHandle("bdrp")
	x.brcy = GetHandle("brcy")
	x.fally[1] = GetHandle("ktnk1")
	x.fally[2] = GetHandle("ktnk2")
	x.fally[3] = GetHandle("ktnk3")
	for index = 1, 48 do
		x.egun[index] = GetHandle(("egun%d"):format(index))
	end
	for index = 2, 9 do
		Ally(index, 2)
		Ally(index, 3)
		Ally(index, 4)
		Ally(index, 5)
		Ally(index, 6)
		Ally(index, 7)
		Ally(index, 8)
		Ally(index, 9)
	end
	SetTeamColor(2, 50, 100, 120)
	SetTeamColor(3, 150, 50, 10)
	SetTeamColor(6, 100, 30, 10)
	SetTeamColor(7, 30, 100, 20)
	SetTeamColor(8, 30, 50, 100)
	SetTeamColor(9, 180, 180, 10)
	SetColorFade(6.0, 0.5, "BLACK")
	TCC.Init()
end

function Start()
	TCC.Start();
end
function Save()
	return
	index, index2, indexadd, indexadd2, x, TCC.Save()
end

function Load(a, b, c, d, e, coreData)
	index = a;
	index2 = b;
	indexadd = c;
	indexadd2 = d;
	x = e;
	TCC.Load(coreData)
end

function AddObject(h)
	--get player base buildings for later attack
	if (not IsAlive(x.farm) or x.farm == nil) and (IsOdf(h, "kvarmo:1") or IsOdf(h, "kbarmo")) then
		x.farm = h
	--SPECIAL FOR RS08 MISSION
	elseif (not IsAlive(x.ffac) or x.ffac == nil) and (IsOdf(h, "kvfactrs08a:1") or IsOdf(h, "kbfactrs08a") or IsOdf(h, "kvfactrs08b:1") or IsOdf(h, "kbfactrs08b")) then
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
	elseif IsOdf(h, "kbpgen0") then
		for index = 1, 4 do
			if x.fpwr[index] == nil or not IsAlive(x.fpwr[index]) then
				x.fpwr[index] = h
				break
			end
		end
	end
	
	--Get new constructor for later replacement
	if not x.eclkjamdead then
		for indexadd = 1, 10 do
			if (not IsAlive(x.fcon[indexadd]) or x.fcon[indexadd] == nil) and IsOdf(h, "kvconsrs08a") then
				for indexadd2 = 1, 10 do
					if h ~= x.fcon[indexadd2] then
						x.fcon[indexadd] = h
					end
				end
			end
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
	
	--[[TEST END CUTSCENE
	if x.spine == 0 then
		x.frcy = BuildObject("avtank", 1, "fpnav1")
		x.posbrcy = GetTransform(x.brcy)
		RemoveObject(x.brcy)
		x.posbdrp = GetTransform(x.bdrp)
		RemoveObject(x.bdrp)
		x.posktnk1 = GetTransform(x.fally[1])
		RemoveObject(x.fally[1])
		x.posktnk2 = GetTransform(x.fally[2])
		RemoveObject(x.fally[2])
		x.posktnk3 = GetTransform(x.fally[3])
		RemoveObject(x.fally[3])
		x.spine = 24
	end--]]
	
	--[[TEST BOOM
	if x.spine == 0 then
		x.mytank = BuildObject("svartl", 1, "epgrcy")
		SetAsUser(x.mytank, 1)
		RemoveObject(x.player)
		x.player = GetPlayerHandle()
		TCC.SetTeamNum(x.player, 1)--JUST IN CASE
		x.spine = 100
	end
	if x.spine == 100 and (IsInsideArea("mitsarea1", x.player) or IsInsideArea("mitsarea2", x.player)) then
		x.waittime = GetTime() + 15.0
		x.spine = 200
	end
	if x.spine == 200 and x.waittime < GetTime() then
		x.boombool = true
		StartEarthQuake(30)
		x.envirotime = GetTime() --turn on enviro change
		x.envirostate = 1
		StartCockpitTimerUp(0, 90, 500)
		x.spine = 300
	end
	if x.spine == 300 and not IsInsideArea("fortressarea", x.player) then
		StartEarthQuake(30)
		x.envirostate = 2
		StopCockpitTimer()
		x.waittime = GetTime() + 60.0
		x.spine = x.spine + 1
	end
	
	if x.spine == 400 and x.waittime < GetTime() then
		x.envirotime = 99999.9
		x.spine = 666
	end--]]
	
	--SETUP MISSION BASICS
	if x.spine == 0 then
		x.audio1 = AudioMessage("tcrs0801.wav") --This is CCA last stand. At base to N. Prod sent to location
		x.mytank = BuildObject("kvtank", 1, "pmytank")
		SetAsUser(x.mytank, 1)
		RemoveObject(x.player)
		x.player = GetPlayerHandle()
		x.posbrcy = GetTransform(x.brcy)
		RemoveObject(x.brcy)
		x.posbdrp = GetTransform(x.bdrp)
		RemoveObject(x.bdrp)
		x.posktnk1 = GetTransform(x.fally[1])
		RemoveObject(x.fally[1])
		x.posktnk2 = GetTransform(x.fally[2])
		RemoveObject(x.fally[2])
		x.posktnk3 = GetTransform(x.fally[3])
		RemoveObject(x.fally[3])
		x.eatk[1] = nil --safety fix
		x.eatk[2] = nil --safety fix
		for index = 3, 4 do --entrance golems
			x.pos = GetTransform(x.eatk[index])
			RemoveObject(x.eatk[index])
			x.eatk[index] = BuildObject("svwalk", 5, x.pos)
		end
		for index = 1, 22 do --build pgens
			if index >= 1 and index <= 7 then
				x.egunteam = 4
			elseif index >= 8 and index <= 10 then
				x.egunteam = 5
			elseif index >= 11 and index <= 12 then
				x.egunteam = 6
			elseif index >= 13 and index <= 14 then
				x.egunteam = 7
			elseif index >= 15 and index <= 18 then
				x.egunteam = 8
			elseif index >= 19 and index <= 22 then
				x.egunteam = 9
			end
			x.epwr[index] = BuildObject("sbpgen0", x.egunteam, "eppwr", index)
		end
		for index = 1, 5 do --create and init multidim array - filled later
			x.eapclive[index] = 0 --init for apc works here
		end
		for index = 1, 8 do
			x.fally[index] = BuildObject("kvtank", 1, "fpfally1", index)
			SetEjectRatio(x.fally[index], 0.0)
			SetCommand(x.fally[index], 47, 0) --47 = CMD_MORPH_SETDEPLOYED // For morphtanks
			x.fallytime[index] = 99999.9 --init
			x.fallystate[index] = 0 --init
		end
		for index = 1, 48 do
			if index >= 1 and index <= 15 then
				x.egunteam = 4
			elseif index >= 16 and index <= 22 then
				x.egunteam = 5
			elseif index >= 23 and index <= 28 then
				x.egunteam = 6
			elseif index >= 29 and index <= 34 then
				x.egunteam = 7
			elseif index >= 35 and index <= 41 then
				x.egunteam = 8
			elseif index >= 42 and index <= 48 then
				x.egunteam = 9
			end
			x.pos = GetTransform(x.egun[index])
			RemoveObject(x.egun[index])
			x.egun[index] = BuildObject("sbgtow", x.egunteam, x.pos)
		end
		x.fally[9] = BuildObject("kvtank", 0, "fpfally2")
		SetCurHealth(x.fally[9], 12000)
		SetCommand(x.fally[9], 47) --47 = CMD_MORPH_SETDEPLOYED // For morphtanks
		x.pos = GetTransform(x.epad)
		RemoveObject(x.epad)
		x.epad = BuildObject("sblpad2", 5, x.pos)
		for index = 3, 6 do
			x.escv[index] = BuildObject("sbscup", 5, ("ppool%d"):format(index))
		end
		x.waittime = GetTime() + 2.0
		x.camstate = 1
    x.userfov = IFace_GetInteger("options.graphics.defaultfov")
    CameraReady()
    IFace_SetInteger("options.graphics.defaultfov", x.camfov)
		x.spine = x.spine + 1
	end
	
	--GIVE FALLY ORDERS, GIVE TOWER WEAPON AND NAME
	if x.spine == 1 and x.waittime < GetTime() then
		Goto(x.fally[9], "pcam2")
		for index = 1, 8 do
			Attack(x.fally[index], x.egun[index], 0)
		end
		if x.LAST then --for collapse
			GiveWeapon(x.egun[1], "gflsha_a")
			GiveWeapon(x.egun[2], "gflsha_a")
			GiveWeapon(x.egun[3], "gstbva_a")
			GiveWeapon(x.egun[4], "gstbva_a")  	
			GiveWeapon(x.egun[5], "gflsha_a")
			GiveWeapon(x.egun[6], "gflsha_a")
			GiveWeapon(x.egun[7], "gstbva_a")
			GiveWeapon(x.egun[8], "gstbva_a") 
			--chain	GiveWeapon(x.egun[9], "ggtows_a")
			--chain	GiveWeapon(x.egun[10], "ggtows_a")
			GiveWeapon(x.egun[11], "gstbva_a")
			GiveWeapon(x.egun[12], "gstbva_a")  	
			GiveWeapon(x.egun[13], "gstbva_a")
			GiveWeapon(x.egun[14], "gstbsa_a")
			GiveWeapon(x.egun[15], "gstbsa_a")
			--chain	GiveWeapon(x.egun[16], "ggtows_a")
			--chain	GiveWeapon(x.egun[17], "ggtows_a")
			GiveWeapon(x.egun[18], "gstbva_a")
			GiveWeapon(x.egun[19], "gstbva_a")
			GiveWeapon(x.egun[20], "gstbva_a")  	
			GiveWeapon(x.egun[21], "gstbsa_a")
			GiveWeapon(x.egun[22], "gstbsa_a")
			GiveWeapon(x.egun[23], "gstbsa_a")
			GiveWeapon(x.egun[24], "gstbsa_a") 
			GiveWeapon(x.egun[25], "gstbsa_a")
			GiveWeapon(x.egun[26], "gstbva_a")
			GiveWeapon(x.egun[27], "gstbva_a")
			GiveWeapon(x.egun[28], "gflsha_a")  	
			GiveWeapon(x.egun[29], "gstbsa_a")
			GiveWeapon(x.egun[30], "gstbsa_a")
			GiveWeapon(x.egun[31], "gstbsa_a")
			GiveWeapon(x.egun[32], "gstbva_a")
			GiveWeapon(x.egun[33], "gstbva_a")
			GiveWeapon(x.egun[34], "gflsha_a") 
			GiveWeapon(x.egun[35], "gstbva_a")
			GiveWeapon(x.egun[36], "gstbva_a")
			GiveWeapon(x.egun[37], "gstbva_a")
			GiveWeapon(x.egun[38], "gflsha_a")  	
			GiveWeapon(x.egun[39], "gflsha_a")
			GiveWeapon(x.egun[40], "gflsha_a") 
			GiveWeapon(x.egun[41], "gstbsa_a")
			GiveWeapon(x.egun[42], "gstbva_a")
			GiveWeapon(x.egun[43], "gstbva_a")
			GiveWeapon(x.egun[44], "gstbva_a") 
			GiveWeapon(x.egun[45], "gflsha_a")
			GiveWeapon(x.egun[46], "gflsha_a")
			GiveWeapon(x.egun[47], "gflsha_a")
			GiveWeapon(x.egun[48], "gstbsa_a") 
			SetObjectiveName(x.egun[1], "Flash Tower")
			SetObjectiveName(x.egun[2], "Flash Tower")
			SetObjectiveName(x.egun[3], "Salvo Stab Tower")
			SetObjectiveName(x.egun[4], "Salvo Stab Tower")  	
			SetObjectiveName(x.egun[5], "Flash Tower")
			SetObjectiveName(x.egun[6], "Flash Tower")
			SetObjectiveName(x.egun[7], "Salvo Stab Tower")
			SetObjectiveName(x.egun[8], "Salvo Stab Tower")
			SetObjectiveName(x.egun[9], "Chain Tower")
			SetObjectiveName(x.egun[10], "Chain Tower")
			SetObjectiveName(x.egun[11], "Salvo Stab Tower")
			SetObjectiveName(x.egun[12], "Salvo Stab Tower")  	
			SetObjectiveName(x.egun[13], "Salvo Stab Tower")
			SetObjectiveName(x.egun[14], "Super Stab Tower")
			SetObjectiveName(x.egun[15], "Super Stab Tower")
			SetObjectiveName(x.egun[16], "Chain Tower")
			SetObjectiveName(x.egun[17], "Chain Tower")
			SetObjectiveName(x.egun[18], "Salvo Stab Tower")
			SetObjectiveName(x.egun[19], "Salvo Stab Tower")
			SetObjectiveName(x.egun[20], "Salvo Stab Tower")  	
			SetObjectiveName(x.egun[21], "Chain Tower")
			SetObjectiveName(x.egun[22], "Chain Tower")
			SetObjectiveName(x.egun[23], "Super Stab Tower")
			SetObjectiveName(x.egun[24], "Salvo Stab Tower") 
			SetObjectiveName(x.egun[25], "Super Stab Tower")
			SetObjectiveName(x.egun[26], "Salvo Stab Tower")
			SetObjectiveName(x.egun[27], "Salvo Stab Tower")
			SetObjectiveName(x.egun[28], "Flash Tower")  	
			SetObjectiveName(x.egun[29], "Super Stab Tower")
			SetObjectiveName(x.egun[30], "Super Stab Tower")
			SetObjectiveName(x.egun[31], "Super Stab Tower")
			SetObjectiveName(x.egun[32], "Salvo Stab Tower")
			SetObjectiveName(x.egun[33], "Salvo Stab Tower")
			SetObjectiveName(x.egun[34], "Flash Tower") 
			SetObjectiveName(x.egun[35], "Salvo Stab Tower")
			SetObjectiveName(x.egun[36], "Salvo Stab Tower")
			SetObjectiveName(x.egun[37], "Salvo Stab Tower")
			SetObjectiveName(x.egun[38], "Flash Tower")  	
			SetObjectiveName(x.egun[39], "Flash Tower")
			SetObjectiveName(x.egun[40], "Flash Tower") 
			SetObjectiveName(x.egun[41], "Super Stab Tower")
			SetObjectiveName(x.egun[42], "Salvo Stab Tower")
			SetObjectiveName(x.egun[43], "Salvo Stab Tower")
			SetObjectiveName(x.egun[44], "Salvo Stab Tower") 
			SetObjectiveName(x.egun[45], "Flash Tower")
			SetObjectiveName(x.egun[46], "Flash Tower")
			SetObjectiveName(x.egun[47], "Flash Tower")
			SetObjectiveName(x.egun[48], "Super Stab Tower")
		end
		x.spine = x.spine + 1
	end
	
	--DECLOAK FALLY
	if x.spine == 2 then	
		for index = 1, 8 do
			if x.fallystate[index] == 0 and GetDistance(x.fally[index], x.egun[index]) < 150 then
				SetCommand(x.fally[index], 48) --48 = CMD_MORPH_SETUNDEPLOYED // For morphtanks
				x.fallytime[index] = GetTime() + 1.0
				x.fallystate[index] = 1
				x.casualty = x.casualty + 1 --COUNT in this instance
			end
		end 
		if x.casualty == 8 then
			x.spine = x.spine + 1
			x.waittime = GetTime() + 12.0
			x.casualty = 0 --COUNT RESET INSIDE
		end
	end
		
	--MSG DEFENSE HEAVY WAIT
	if x.spine == 3 and (x.waittime < GetTime() or CameraCancelled()) then 
    CameraFinish()
    IFace_SetInteger("options.graphics.defaultfov", x.userfov)
		x.camstate = 0
		SetColorFade(6.0, 0.5, "BLACK")
		AudioMessage("tcrs0802.wav") --18s	Defense are too heavy. Need backup. / Stand by
		for index = 1, 9 do --9 will be alive
			RemoveObject(x.fally[index])
		end
		SetCurHealth(x.mytank, 100)
		SetCurAmmo(x.mytank, 50)
		x.fnav[1] = BuildObject("apcamrk", 1, "fpnav1")
		SetObjectiveName(x.fnav[1], "Base")
		x.waittime = GetTime() + 25.0 --audio plus 7s
		x.spine = x.spine + 1
	end

	--NOTIFY CONVOY COMING
	if x.spine == 4 and x.waittime < GetTime() then
		x.audio1 = AudioMessage("tcrs0803.wav") --Convoy coming. Follow to NAV. Steal LAST APC. Bring to base.
		AddObjective("tcrs0801.txt")
		x.fnav[2] = BuildObject("apcamrk", 1, "fpnav2")
		SetObjectiveName(x.fnav[2], "Intercept Convoy")
		SetObjectiveOn(x.fnav[2])
		x.eapctime = GetTime()
		x.spine = x.spine + 1
	end
	
	--BUILD CCA APC CONVOY	
	if x.spine == 5 and IsAudioMessageDone(x.audio1) then
		if x.eapctime < GetTime() then
			for index = 1, 5 do
				if x.eapclive[index] == 0 then
					x.eapc[index] = BuildObject("svapcrs08", 5, "epapc")
					SetObjectiveName(x.eapc[index], ("Revmir %d"):format(index))
					Retreat(x.eapc[index], "eproute")
					x.eapclive[index] = 1
					x.eapctime = 99999.9
					if x.eapclive[1] == 1 and x.eapclive[2] == 0 then
						for index2 = 1, 2 do
							x.eatk[index2] = BuildObject("svscout", 5, ("epapc%d"):format(index2))
							SetCanSnipe(x.eatk[index2], 0)
							Defend2(x.eatk[index2], x.eapc[1])
						end
					end
					break
				end
			end
		end
		for index = 1, 5 do 
			if x.eapclive[index] == 1 and not IsInsideArea("apcarea0", x.eapc[index]) then
				x.eapctime = GetTime()
				x.eapclive[index] = 2
			end
		end
		if IsAlive(x.eapc[5]) then
			x.eapcstate = 1
			x.spine = x.spine + 1
		end
	end
	
	--EAPC[5] SNIPED GIVE ORDERS
	if x.spine == 6 and not HasPilot(x.eapc[5]) then
		ClearObjectives()
		AddObjective("tcrs0801.txt", "GREEN")
		AddObjective("	")
		AddObjective("tcrs0802.txt", "CYAN")
		x.spine = x.spine + 1
	end
	
	--IS PLAYER IN THE APC
	if x.spine == 7 and IsPlayer(x.eapc[5]) then
		ClearObjectives()
		AddObjective("tcrs0802.txt", "CYAN")
		RemoveObject(x.fnav[2])
		Damage(x.mytank, 5000)
		x.eapcstate = 2
		x.spine = x.spine + 1
	end
	
	--EAPC[4] TURN NORTH
	if x.spine == 8 and GetDistance(x.eapc[4], "epturn") <= 32 then
		x.waittime = GetTime() + 15.0
		x.eapcstate = 3
		x.spine = x.spine + 1
	end
	
	--PLAYER EAPC[5] TURN NORTH
	if x.spine == 9 and GetDistance(x.eapc[5], "epturn") <= 32 and IsPlayer(x.eapc[5]) then
		ClearObjectives()
		AddObjective("tcrs0803.txt")
		AudioMessage("pow_done.wav")
		if not IsAlive(x.fnav[1]) then
			x.fnav[1] = BuildObject("apcamrk", 1, "fnav1")
			SetObjectiveName(x.fnav[1], "Base")
		end
		SetObjectiveOn(x.fnav[1])
		x.eapcstate = 4
		x.spine = x.spine + 1
	end
	
	--PLAYER BACK AT BASE
	if x.spine == 10 and GetDistance(x.eapc[5], "fpnav1") <= 24 then
		ClearObjectives()
		AddObjective("tcrs0804.txt")
		x.waittime = GetTime() + 7.0
		x.eapcstate = 5
		x.spine = x.spine + 1
	end 
	
	--PLAYER TO REJOIN CONVOY
	if x.spine == 11 and x.waittime < GetTime() then
		AudioMessage("tcrs0804.wav") --Quick, rejoin convoy. Follow to (CCA) base entrance.
		SetObjectiveOff(x.fnav[1])
		SetObjectiveOn(x.eapc[4])
		ClearObjectives()
		AddObjective("tcrs0805.txt")
		x.eapcstate = 6
		RemoveObject(x.fnav[1])
		x.spine = x.spine + 1
	end 
	
	--PLAYER HAS REJOINED CONVOY
	if x.spine == 12 and GetDistance(x.eapc[5], x.eapc[4]) <= 125 and not IsInsideArea("fortressarea", x.eapc[1]) then
		SetObjectiveOff(x.eapc[4])
		ClearObjectives()
		AddObjective("tcrs0805.txt", "GREEN")
		x.eapcstate = 7
		x.spine = x.spine + 1
	end
	
	--CONVOY AT FORTRESS
	if x.spine == 13 and GetDistance(x.eapc[1], "epapcstop") <= 32 then
		for index = 1, 4 do
			Stop(x.eapc[index])
		end
		for index = 1, 28 do --build turrets in open code
			x.etur[index] = BuildObject("svturr", 5, "eptur", index)
		end
		x.spine = x.spine + 1
	end
	
	--ORDER PLAYER OUT OF APC
	if x.spine == 14 and IsInsideArea("stoparea", x.player) then
		x.mytank = x.eapc[5]
		AudioMessage("tcrs0806.wav") --Leave APC at entrance. Get to a safe distance
		ClearObjectives()
		AddObjective("tcrs0806.txt")
		x.eapcstate = 8
		StartCockpitTimer(20, 10, 5)
		x.waittime = GetTime() + 20.0
		x.spine = x.spine + 1
	end
	
	--PLAYER ORDERED TO RUN
	if x.spine == 15 and IsOdf(x.player, "kspilo") then --not HasPilot(x.eapc[5]) then
		ClearObjectives()
		AddObjective("HOP RUN away from the APC!", "LAVACOLOR")
		x.eapcstate = 9
		x.spine = x.spine + 1
	end
	
	--PLAYER HAS REACHED SAFE DISTANCE
	if x.spine == 16 and x.waittime > GetTime() and not IsInsideArea("getoutarea", x.player) and not IsInsideArea("fortressarea", x.player) then
		StopCockpitTimer()
		HideCockpitTimer()
		x.eapcstate = 10
		x.fcam1 = BuildObject("dummy00", 0, "pcam2")
		x.waittime = GetTime() + 2.0
		x.camstate = 2
    x.userfov = IFace_GetInteger("options.graphics.defaultfov")
    CameraReady()
    IFace_SetInteger("options.graphics.defaultfov", x.camfov)
		x.spine = x.spine + 1
	end
	
	--DESTROY CONVOY AND ENTRANCE STUFF
	if x.spine == 17 and x.waittime < GetTime() then
		x.eapcstate = 11
		x.pos = GetTransform(x.eapc[5])
		Damage(x.eapc[5], 20000)
		Damage(x.eapc[4], 20000)
		x.fally[1] = BuildObject("apdwrka", 1, x.pos) --extra boom
		Damage(x.eapc[3], 20000)
		Damage(x.eapc[2], 20000)
		Damage(x.eapc[1], 20000)
		for index = 1, 4 do
			Damage(x.epwr[index], 20000)
			Damage(x.eatk[index], 20000)
		end
		for index = 1, 8 do
			Damage(x.egun[index], 20000)
		end
		x.waittime = GetTime() + 4.0
		x.spine = x.spine + 1
	end
	
	--CONVOY DONE, BUILD FRECY
	if x.spine == 18 and x.waittime < GetTime() then
    CameraFinish()
    IFace_SetInteger("options.graphics.defaultfov", x.userfov)
		x.camstate = 0
		RemoveObject(x.fcam1)
		x.waittime = 99999.9 --safety reset
		x.eapcstate = 12
		ClearObjectives()
		AddObjective("tcrs0807.txt")
		x.fally[1] = BuildObject("kvscoutnc", 1, "fprcy")
		Goto(x.fally[1], "stoparea", 0)
		SetGroup(x.fally[1], 0)
		x.fally[2] = BuildObject("kvmbikenc", 1, "fpfac")
		Goto(x.fally[2], "stoparea", 0)
		SetGroup(x.fally[2], 0)
		x.fally[3] = BuildObject("kvmislnc", 1, "fparm")
		Goto(x.fally[3], "stoparea", 0)
		SetGroup(x.fally[3], 0)
		x.fally[4] = BuildObject("kvtanknc", 1, "fpcon")
		Goto(x.fally[4], "stoparea", 0)
		SetGroup(x.fally[4], 0)
		x.fally[5] = BuildObject("kvrcktnc", 1, "fpscv1")
		Goto(x.fally[5], "stoparea", 0)
		SetGroup(x.fally[5], 0)
		x.fally[6] = BuildObject("kvhtnknc", 1, "fpscv2")
		Goto(x.fally[6], "stoparea", 0)
		SetGroup(x.fally[6], 0)
		x.fally[1] = BuildObject("kvscav", 1, "fpscv1")
		Goto(x.fally[1], "fpscv1", 0)
		SetGroup(x.fally[1], 6)
		x.fally[2] = BuildObject("kvscav", 1, "fpscv2")
		Goto(x.fally[2], "fpscv2", 0)
		SetGroup(x.fally[2], 7)
		x.fcon[1] = BuildObject("kvconsrs08a", 1, "fpcon")
		Goto(x.fcon[1], "fpcon", 0)
		SetGroup(x.fcon[1], 8)
		x.farm = BuildObject("kvarmo", 1, "fparm")
		Goto(x.farm, "fparm", 0)
		SetGroup(x.farm, 3)
		x.frcy = BuildObject("kvrecyrs08a", 1, "fprcy")
		Goto(x.frcy, "fprcy", 0)
		SetGroup(x.frcy, 1)
		x.ffac = BuildObject("kvfactrs08a", 1, "fpfac")
		Goto(x.ffac, "fpfac", 0)
		SetGroup(x.ffac, 2)
		SetScrap(1, 40)
		--HAS SILO ALREADY SetScrap(5, 40)
    x.waittime = GetTime() + 180.0
		x.spine = x.spine + 1
	end
	
	--GIVE OBJECTIVE ACTIVATE WARCODE
	if x.spine == 19 and ((IsAlive(x.frcy) and IsOdf(x.frcy, "kbrecyrs08a")) or (IsAlive(x.ffac) and IsOdf(x.ffac, "kbfactrs08a")) or (not IsAlive(x.eclkjam)) or (x.waittime < GetTime())) then
		ClearObjectives()
		AddObjective("tcrs0808.txt")
		AddObjective("	")
		AddObjective("tcrs0809.txt", "CYAN")
		for index = 1, 10 do --build mits minefields
			x.emit[index] = BuildObject("omitsars08", 5, "epmits", index)
		end
		x.pos = GetTransform(x.emit[5])
		RemoveObject(x.emit[5])
		x.emit[5] = BuildObject("olybolt2", 5, x.pos)
		x.pos = GetTransform(x.emit[10])
		RemoveObject(x.emit[10])
		x.emit[10] = BuildObject("olybolt2", 5, x.pos)  
		for index = 1, x.escvlength do --init escv
			x.escvbuildtime[index] = GetTime()
			x.escvstate[index] = 1
		end
		for index = 1, 50 do --init snip
			x.epilostate[index] = 0
		end
		x.epattime = GetTime() + 120.0 --init epat
		for index = 1, x.epatlength do --init epat
			x.epatcool[index] = GetTime()
			x.epatallow[index] = true
		end
		x.easstime = GetTime() + 120.0 --init eass
		for index = 1, x.easslength do --init eass
			x.easscool[index] = GetTime()
			x.eassallow[index] = true
		end
		for index = 1, x.ewartotal do --init WARCODE
			x.ewardeclare = true
			x.ewarrior[index] = {} --"rows"
			for index2 = 1, 16 do --16 per wave max avail
				x.ewarrior[index][index2] = nil --"columns", init (handle in this case)
			end
			x.ewarstate[index] = 1
			x.ewartime[1] = GetTime() + 120.0 --recy
			x.ewartime[2] = GetTime() + 240.0 --fact
			x.ewartime[3] = GetTime() + 360.0 --armo
			x.ewartime[4] = GetTime() + 480.0 --base
			x.ewartimecool[index] = 360.0
			x.ewartimeadd[index] = 0.0
			x.ewarabort[index] = 99999.9
			x.ewarsize[index] = 0
			x.ewarwave[index] = 0
			x.ewarwavemax[index] = 5
			x.ewarwavereset[index] = 2
			x.ewarmeet[index] = 2
		end
		x.wrecktime = GetTime() + 420.0
		x.spine = x.spine + 1
	end
	
	--GIVE FINAL OBJECTIVES
	if x.spine == 20 and not IsAlive(x.ercy) and not IsAlive(x.earm) and not IsAlive(x.efac) then
		if IsInsideArea("mitsarea1", x.player) or IsInsideArea("mitsarea2", x.player) then
			AudioMessage("tcrs0807.wav") --Take command of howitzer and destroy the power stations.
			ClearObjectives()
			AddObjective("tcrs0810.txt")
			x.ecomcandie = 1
			SetObjectiveOn(x.esolar1)
			SetObjectiveOn(x.esolar2)
			for index = 1, 2 do
				x.fally[index] = BuildObject("svartl", 5, ("epart%d"):format(index))
				GiveWeapon(x.fally[index], "gartla") --"gmorta") --had changed hwtz range between beta testing, for unrelated purposes, so no longer works on this mission, need different weapon
				KillPilot(x.fally[index])
				SetObjectiveOn(x.fally[index])
			end
			x.spine = x.spine + 1
		end
	end
	
	--KILL COMM TOWERS
	if x.spine == 21	and (not IsAlive(x.ecom1) or not IsAlive(x.ecom2) or not IsAlive(x.esolar1) or not IsAlive(x.esolar2)) then
		AudioMessage("tcrs0808.wav") --Comm towers in these locations. Destroy and leave base asap
		ClearObjectives()
		AddObjective("tcrs0811.txt")
		SetObjectiveOn(x.ecom1)
		SetObjectiveOn(x.ecom2)
		if x.skillsetting == x.easy then
			x.waittime = GetTime() + 300.0
			StartCockpitTimer(300, 120, 60)
		elseif x.skillsetting == x.medium then
			x.waittime = GetTime() + 270.0
			StartCockpitTimer(270, 120, 60)
		else
			x.waittime = GetTime() + 240.0
			StartCockpitTimer(240, 120, 60)
		end
		x.etimerstate = 1
		x.spine = x.spine + 1
	end
	
	--NOTIFY COM DEAD AND STOP TIMER
	if x.spine == 22 and x.waittime > GetTime() and not IsAlive(x.ecom1) and not IsAlive(x.ecom2) and not IsAlive(x.esolar1) and not IsAlive(x.esolar2) then
		x.waittime = GetTime() + 2.0
		x.etimerstate = 2
		StopCockpitTimer()
		HideCockpitTimer()
		ClearObjectives()
		AddObjective("tcrs0811.txt", "GREEN")
		AddObjective("	")
		AddObjective("tcrs0812.txt", "YELLOW")
		AddObjective("	")
		AddObjective("tcrs0813.txt")
		x.spine = x.spine + 1
	end
	
	--START BASE DETONATION
	if x.spine == 23 and x.waittime < GetTime() then
		x.ewardeclare = false --likely not necessary but doesn't hurt
		if IsInsideArea("midarea", x.frcy) then --if player deploy recy in mid level. If Top level U B stoopid in first place
			StartCockpitTimer(270, 120, 60)
			x.waittime = GetTime() + 270.0
		else
			StartCockpitTimer(220, 120, 60)
			x.waittime = GetTime() + 220.0
		end
		if not IsAlive(x.fnav[1]) then
			x.fnav[1] = BuildObject("apcamrk", 1, "fpnav1")
			SetObjectiveName(x.fnav[1], "Base")
		end
		SetObjectiveOn(x.fnav[1])
		x.boombool = true
		StartEarthQuake(30)
		x.envirotime = GetTime() --turn on enviro change
		x.envirostate = 1
		SetCurHealth(x.frcy, GetMaxHealth(x.frcy)) --just in case for flares
		x.spine = x.spine + 1
	end
	
	--PLAYER AT MIN SAFE DIST
	if x.spine == 24 and x.waittime > GetTime() and not IsInsideArea("fortressarea", x.player) and IsAlive(x.frcy) and not IsInsideArea("fortressarea", x.frcy) then
		x.audio1 = AudioMessage("tcrs0809b.wav") --b modified with record scratch SUCCEED - CCA wiped out. Gany now offshore colony or PRC.
		ClearObjectives()
		AddObjective("tcrs0814.txt", "GREEN")
		StopCockpitTimer()
		HideCockpitTimer()
		SetObjectiveOff(x.fnav[1])
		StopEarthQuake()
		x.boombool = false
		x.envirostate = 2
		for index = 1, 85 do --remove flares
			RemoveObject(x.eatk[index])
		end
		for index = 1, 15 do --remove flares
			RemoveObject(x.etur[index])
		end
		x.MCAcheck = true
		x.spine = x.spine + 1
	end
	
	--PREP FINAL CUTSCENE
	if x.spine == 25 and IsAudioMessageDone(x.audio1) then
		x.envirotime = 99999.9
		x.bdrp = BuildObject("bvdrop", 5, x.posbdrp)
		x.brcy = BuildObject("bvrecy", 5, x.posbrcy)
		x.fcam1 = x.brcy
		for index = 1, 10 do
			StopEmitter(x.bdrp, index)
		end
		for index = 1, 86 do
			RemoveObject(x.eatk[index])
		end
		for index = 1, 20 do
			RemoveObject(x.etur[index])
		end
		x.waittime = GetTime() + 1.0
		x.camheight = 1300 --USED AS SPEED IN THIS CASE
		x.cnslcmdvalue = IFace_GetInteger("options.audio.music") --get "music" volume value of player instance
		x.spine = x.spine + 1
	end
	
	--START THE CAMERA
	if x.spine == 26 and x.waittime < GetTime() then
		x.camstate = 3
		IFace_ConsoleCmd("options.audio.music 5") --adjust player "music" volume instance
		x.audio6 = AudioMessage("cdaudiotrack51.ogg")  	
    x.userfov = IFace_GetInteger("options.graphics.defaultfov")
    CameraReady()
    IFace_SetInteger("options.graphics.defaultfov", x.camfov)
		x.spine = x.spine + 1
	end
	
	--DROPSHIP OPEN
	if x.spine == 27 then
		SetAnimation(x.bdrp, "open", 1)
		x.waittime = GetTime() + 5.0
		x.spine = x.spine + 1
	end
	
	--SEND OUT BDOG RECY
	if x.spine == 28 and x.waittime < GetTime() then
		Goto(x.brcy, "bproute")
		x.spine = x.spine + 1
	end
	
	--DROPSHIP CLOSE
	if x.spine == 29 and GetDistance(x.brcy, x.bdrp) > 70 then
		for index = 1, 10 do
			StartEmitter(x.bdrp, index)
		end
		x.fally[1] = BuildObject("kvtank", 1, x.posktnk1)
		x.fally[2] = BuildObject("kvtank", 1, x.posktnk2)
		x.fally[3] = BuildObject("kvtank", 1, x.posktnk3)
		x.waittime = GetTime() + 1.0
		x.spine = x.spine + 1
	end
	
	--DROPSHIP TAKEOFF
	if x.spine == 30 and x.waittime < GetTime() then
		SetAnimation(x.bdrp, "takeoff", 1)
		for index = 1, 3 do
			SetCommand(x.fally[index], 47) --47 = CMD_MORPH_SETDEPLOYED // For morphtanks
		end
		x.spine = x.spine + 1
	end
	
	--BDOG RECY DEPLOY
	if x.spine == 31 and GetDistance(x.brcy, "bpdeploy") < 64 then
		Dropoff(x.brcy, "bpdeploy")
		RemoveObject(x.bdrp)
		x.waittime = GetTime() + 3.0
		x.spine = x.spine + 1
	end
	
	--CRA TANKS GO ORDER
	if x.spine == 32 and x.waittime < GetTime() then
		for index = 1, 3 do
			Goto(x.fally[index], "bpdeploy")
		end
		x.spine = x.spine + 1
	end
	
	--CRA TANKS STOP AT TARGET AREA
	if x.spine == 33 and GetDistance(x.fally[1], "bpdeploy") < 80 then
		for index = 1, 3 do
			Stop(x.fally[index])
		end
		x.waittime = GetTime() + 2.0
		x.spine = x.spine + 1
	end
	
	--CRA TANKS UNCLOAK
	if x.spine == 34 and x.waittime < GetTime() then
		for index = 1, 3 do
			SetCommand(x.fally[index], 48) --48 = CMD_MORPH_SETUNDEPLOYED // For morphtanks
		end
		x.waittime = GetTime() + 1.0
		x.spine = x.spine + 1
	end
	
	--CRA TANKS ATTACK BRCY
	if x.spine == 35 and x.waittime < GetTime() then
		for index = 1, 3 do
			Attack(x.fally[index], x.brcy)
		end
		x.fcam1 = BuildObject("dummy00", 0, "bpdeploy")
		x.spine = x.spine + 1
	end
	
	--RETURN PLAYER OPTIONS MUSIC VOLUME
	if x.spine == 36 and (x.camstate == 4 or IsAudioMessageDone(x.audio6)) then
		IFace_ConsoleCmd(("options.audio.music %d"):format(x.cnslcmdvalue)) --return player "music volume" to previous setting
		x.waittime = GetTime() + 1.0
		x.spine = x.spine + 1
	end
		
	--UBAWINNER 
	if x.spine == 37 and x.waittime < GetTime() then
    CameraFinish()
    IFace_SetInteger("options.graphics.defaultfov", x.userfov)
		TCC.SucceedMission(GetTime(), "tcrs08w.des") --winner winner winner
		x.spine = x.spine + 1
	end
	----------END MAIN SPINE ----------

	--CAMERA INIT ATTACK
	if x.camstate == 1 then
		CameraPath("pcam1", x.camheight, 300, x.fally[9])
		x.camheight = x.camheight + 1
	end

	--CAMERA CONVOY BOOM
	if x.camstate == 2 then
		CameraPath("pcam3", 200, 10, x.fcam1)
	end
	
	--CAMERA BDOG RECY
	if x.camstate == 3 and CameraPath("pcam4", 2200, 1200, x.fcam1) then
		x.camstate = 4
	end
	
	--TURN OFF ARTIL HIGHLIGHT
	if not x.inartl and IsOdf(x.player, "svartl") then
		SetObjectiveOff(x.fally[1])
		SetObjectiveOff(x.fally[2])
		x.inartl = true
	end
	
	--REMOVE MITSMINE FIELD 1-5
	if not IsAlive(x.esolar1) then
		for index = 1, 5 do
			RemoveObject(x.emit[index])
		end
	end
	
	--REMOVE MITSMINE FIELD 6-10 
	if not IsAlive(x.esolar2) then
		for index = 6, 10 do
			RemoveObject(x.emit[index])
		end
	end
	
	--BUILD SNIPERS
	for index = 1, 50 do
		if x.epilostate[index] == 0 and GetDistance(x.player, "epsnip", index) < 400 then --600 visibilityrange in map
			x.epilo[index] = BuildObject("sspilors01", 6, "epsnip", index)
			SetSkill(x.epilo[index], 3) --sniper need help
			SetWeaponMask(x.epilo[index], 10)
			Deploy(x.epilo[index])
			FireAt(x.epilo[index], x.player, true) --so will deploy to snip right away, and will shoot player at long range
			x.epilostate[index] = 1
		elseif x.epilostate[index] == 1 and IsAlive(x.epilo[index]) and GetCurLocalAmmo(x.epilo[index], 2) < 1 then --NEED TO SWITCH TO LOCAL B/C SNIPE NOW LOCAL
			SetCurLocalAmmo(x.epilo[index], 3, 2) --so can snipe faster
			FireAt(x.epilo[index], x.player, true) --so will deploy to snip right away, and will shoot player at long range
		elseif x.epilostate[index] == 1 and not IsAlive(x.epilo[index]) then
			x.epilostate[index] = 2
		end
	end
	
	--RETURN CLOAK - BUILD CLOAK PRODUCTION UNITS
	if not x.eclkjamdead and not IsAlive(x.eclkjam) then
		if IsAlive(x.frcy) then
			x.pos = GetTransform(x.frcy)
			if IsOdf(x.frcy, "kbrecyrs08a") then
				RemoveObject(x.frcy)
				x.frcy = BuildObject("kbrecyrs08b", 1, x.pos)
			else
				RemoveObject(x.frcy)
				x.frcy = BuildObject("kvrecyrs08b", 1, x.pos)
			end
		end
		if IsAlive(x.ffac) then
			x.pos = GetTransform(x.ffac)
			if IsOdf(x.ffac, "kbfactrs08a") then
				RemoveObject(x.ffac)
				x.ffac = BuildObject("kbfactrs08b", 1, x.pos)
			else
				RemoveObject(x.ffac)
				x.ffac = BuildObject("kvfactrs08b", 1, x.pos)
			end
		end
		for index = 1, 10 do
			if IsAlive(x.fcon[index]) then
				x.pos = GetTransform(x.fcon[index])
				RemoveObject(x.fcon[index])
				x.fcon[index] = BuildObject("kvconsrs08b", 1, x.pos)
			end
		end
		if (IsAlive(x.ercy) or IsAlive(x.efac) or IsAlive(x.earm)) then
			ClearObjectives()
			AddObjective("tcrs0808.txt")
			AddObjective("	")
			AddObjective("tcrs0809b.txt", "CYAN") --b - cloak avail
		end
		x.eclkjamdead = true
	end
	
	--KEEP COM AND SOLAR ALIVE TILL PLAYER GETS THERE
	if x.ecomcandie == 0 then
		if GetCurHealth(x.ecom1) < 20000 then
			SetCurHealth(x.ecom1, 20000)
		end
		if GetCurHealth(x.ecom2) < 20000 then
			SetCurHealth(x.ecom2, 20000)
		end
		if GetCurHealth(x.esolar1) < 20000 then
			SetCurHealth(x.esolar1, 20000)
		end
		if GetCurHealth(x.esolar2) < 20000 then
			SetCurHealth(x.esolar2, 20000)
		end
	elseif x.ecomcandie == 1 then
		SetCurHealth(x.esolar1, 3000) --need to be 3k no matter what
		SetCurHealth(x.esolar2, 3000)
		SetCurHealth(x.ecom1, 5000)
		SetCurHealth(x.ecom2, 5000)
		x.ecomcandie = 2
	end
	
	--AI DAYWRECKER ATTACK
	if x.wreckstate == 0 and IsAlive(x.earm) and x.wrecktime < GetTime() and GetMaxScrap(5) >= 80 then
		x.wreckstate = x.wreckstate + 1
	elseif x.wreckstate == 1 and x.wrecktime < GetTime() and IsAlive(x.earm) then
		if GetScrap(5) < 80 then 
			SetScrap(5, 80) --gotta have money
		end
		x.wreckbank = true
		x.wreckstate = x.wreckstate + 1
	elseif x.wreckstate == 2 then
		while x.randompick == x.randomlast do --random the random
			x.randompick = math.floor(GetRandomFloat(1.0,12.0))
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
		x.wrecktime = GetTime() + 1.0
		x.wreckstate = x.wreckstate + 1
	elseif x.wreckstate == 3 and x.wrecktime < GetTime() and IsAlive(x.earm) then
		SetCommand(x.earm, 8, 1, 0, x.wrecktrgt, 0) --dropoff (don't use "Dropoff" func)
		x.wrecktime = 99999.9
		x.wreckstate = x.wreckstate + 1
	elseif x.wreckstate == 4 and IsAlive(x.wreckbomb) then
		x.wreckbank = false --reset for scavs
		
		if x.skillsetting == x.easy and GetDistance(x.wreckbomb, x.wrecktrgt) < 500 then
			x.wrecknotify = 1
		elseif x.skillsetting == x.medium and GetDistance(x.wreckbomb, x.wrecktrgt) < 400 then
			x.wrecknotify = 1
		elseif x.skillsetting >= x.hard and GetDistance(x.wreckbomb, x.wrecktrgt) < 300 then
			x.wrecknotify = 1
		end
		if x.wrecknotify == 1 then
      TCC.SetTeamNum(x.wreckbomb, 5)
			SetObjectiveOn(x.wreckbomb)
			AudioMessage("alertpulse.wav")
			x.wrecknotify = 0
			x.wreckstate = x.wreckstate + 1
		end
	elseif x.wreckstate == 5 and not IsAlive(x.wreckbomb) then		
		for index = 1, 12 do
			x.randompick = math.floor(GetRandomFloat(1.0, 9.0))
		end
		if x.randompick == 1 or x.randompick == 4 or x.randompick == 7 then
			x.wrecktime = GetTime() + 660.0
		elseif x.randompick == 2 or x.randompick == 5 or x.randompick == 8 then
			x.wrecktime = GetTime() + 540.0
		else
			x.wrecktime = GetTime() + 420.0
		end
		x.wreckstate = 0 --reset
	end
	--keep for boom/enviro test]]
	--CHANGE ENVIRONMENT COLORS
	if x.envirotime < GetTime() then
		if x.envirostate == 1 then --Redden environment
			if x.redfog < 250 then --tied to max of all below 250 (not 255)
				x.redfog = x.redfog + 1
				x.redamb = x.redamb + 1
				x.redsun = x.redsun + 1
			end
			if x.fogrng1 < -100 then
				x.fogrng1 = -100
			else
				x.fogrng1 = x.fogrng1 - 8
			end
			if x.fogrng2 < 100 then
				x.fogrng2 = 100
			else
				x.fogrng2 = x.fogrng2 - 8
			end
		elseif x.envirostate == 2 then --retrun enviro to original
			if x.redfog > 40 then --tied to max of all below 250 (not 255)
				x.redfog = x.redfog - 10
				x.redamb = x.redamb - 10
			end
			if x.redsun < 200 then
				x.redsun = 200
			else
				x.redsun = x.redsun - 5
			end
			if x.fogrng1 > 300 then
				x.fogrng1 = 300
			else
				x.fogrng1 = x.fogrng1 + 25
			end
			if x.fogrng2 > 400 then
				x.fogrng2 = 400
			else
				x.fogrng2 = x.fogrng2 + 25
			end
		end
		IFace_ConsoleCmd(("sky.fogcolor %d 20 0"):format(x.redfog), 1) --sky.fogcolor 40 20 0
		IFace_ConsoleCmd(("sky.fogrange %d %d"):format(x.fogrng1, x.fogrng2), 1)
		IFace_ConsoleCmd(("sky.ambientcolor %d 80 70 255"):format(x.redamb), 1) --sky.ambientcolor 45 40 35 (90 80 70)
		IFace_ConsoleCmd(("sun.color %d 180 160 400"):format(x.redsun), 1) --sun.color 200 180 160 400
		x.envirotime = GetTime() + 2.0
	end
	
	--BOOM SPLOSIONS--]]
	if x.boombool then
		while x.randompick == x.randomlast do
			x.randomfloat = GetRandomFloat(1.0, 100.0)
			x.randompick = math.floor(x.randomfloat)
		end
		x.randomlast = x.randompick
		if IsInsideArea("lowarea", x.player) or IsInsideArea("lowarea", x.frcy) then
			x.eatk[index] = BuildObject("oboompot", 0, "pboom1", x.randompick)
		end
		if IsInsideArea("midarea", x.player) or IsInsideArea("midarea", x.frcy) then
			x.eatk[index] = BuildObject("oboompot", 0, "pboom2", x.randompick)
		end
		if IsInsideArea("toparea", x.player) or IsInsideArea("toparea", x.frcy) then
			x.eatk[index] = BuildObject("oboompot", 0, "pboom3", x.randompick)
		end
	end
	
	--CCA GROUP SCOUT PATROLS --SPECIAL SKILL ADD THIS MISSION--------------------------------
	if IsAlive(x.efac) and x.epattime < GetTime() then
		for index = 1, x.epatlength do
			if not IsAlive(x.epat[index]) and not x.epatallow[index] then
				x.epatcool[index] = GetTime() + 300.0
				x.epatallow[index] = true
			end
			
			if x.epatallow[index] and x.epatcool[index] < GetTime() then
				--MODIFIED FOR RS08 - TWO ROUTES MULTIUNITS
				if index % 2 ~= 0 then
					x.epat[index] = BuildObject("svtank", 5, "ppatrol1")
					SetSkill(x.epat[index], x.skillsetting)
					Patrol(x.epat[index], "ppatrol1")
				else
					x.epat[index] = BuildObject("svtank", 5, "ppatrol2")
					SetSkill(x.epat[index], x.skillsetting)
					Patrol(x.epat[index], "ppatrol2")
				end
				--SetObjectiveName(x.epat[index], ("Patrol %d"):format(index))
				x.epatallow[index] = false
			end
		end
		x.epattime = GetTime() + 360.0
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
						if x.randompick == 1 or x.randompick == 8 or x.randompick == 13 or x.randompick == 17 then
							x.ewarrior[index][index2] = BuildObject("svscout", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
							if x.ewarwave[index] == 3 or x.ewarwave[index] == 4 then
								GiveWeapon(x.ewarrior[index][index2], "glasea_c")
							end
						elseif x.randompick == 2 or x.randompick == 9 or x.randompick == 14 or x.randompick == 18 then
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
						elseif x.randompick == 5 or x.randompick == 12 then
							x.ewarrior[index][index2] = BuildObject("svrckt", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
							if x.ewarwave[index] == 3 or x.ewarwave[index] == 5 then
								GiveWeapon(x.ewarrior[index][index2], "gshdwa_a") --salvo rckt
							end
						elseif x.randompick == 6 then
							if x.ewarwave[index] == 1 or x.ewarwave[index] == 2 then
								x.ewarrior[index][index2] = BuildObject("svtank", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
							else --too x.hard if comes in very first or second wave
								x.ewarrior[index][index2] = BuildObject("svstnk", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
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
							end
						else
							if x.ewarwave[index] == 1 or x.ewarwave[index] == 2 then
								x.ewarrior[index][index2] = BuildObject("svtank", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
							else --too x.hard if comes in very first or second wave
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
								Attack(x.ewarrior[index][index2], x.player)
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
		--RS08 ONLY ----no rebuild factory------------------
		if not IsAlive(x.efac) then
			x.ewardeclare = false
		end
	----------------------------------------------------
	end--WARCODE END

  --CCA PLAYER ASSASSIN ----------------------------------
	if IsAlive(x.ercy) and not IsAlive(x.efac) then
		if x.easstime < GetTime() then
			for index = 1, x.easslength do
				if not IsAlive(x.eass[index]) and not x.eassallow[index] then
					x.easscool[index] = GetTime() + 60.0
					x.eassallow[index] = true
				end
			
				if x.eassallow[index] and x.easscool[index] < GetTime() then
					x.eass[index] = BuildObject("svscout", 5, ("epgrcy"):format(index))
					SetSkill(x.eass[index], x.skillsetting)
					SetObjectiveName(x.eass[index], ("Assassin %d"):format(index))
					x.eassresendtime = GetTime()
					x.eassallow[index] = false
				end
			end
			x.easstime = GetTime() + 70.0
		end
		
		if x.eassresendtime < GetTime() then
			for index = 1, x.easslength do
        if IsAlive(x.eass[index]) and GetTeamNum(x.eass[index]) ~= 1 then
          Attack(x.eass[index], x.player)
        end
				x.eassresendtime = GetTime() + 30.0
			end
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
	
	--CHECK STATUS OF MCA ----------------------------------
	if not x.MCAcheck then
		x.player = GetPlayerHandle() --redo this here for this mission
		
		if x.eapcstate < 11 and x.failstate == 0 then --OA for convoy fail
			--destroyed apc 5 or sniped wrong apc or Player entered wrong apc
			if x.eapcstate > 0 and x.eapcstate < 11 and 
			(not IsAround(x.eapc[1]) or not IsAround(x.eapc[2]) or not IsAround(x.eapc[3]) or not IsAround(x.eapc[4]) or not IsAround(x.eapc[5]) or 
			not HasPilot(x.eapc[1]) or not HasPilot(x.eapc[2]) or not HasPilot(x.eapc[3]) or not HasPilot(x.eapc[4]) or 
			IsPlayer(x.eapc[1]) or IsPlayer(x.eapc[2]) or IsPlayer(x.eapc[3]) or IsPlayer(x.eapc[4])) then
				x.failstate = 1
			end
			
			--Player too far from convoy or out of area
			if x.eapcstate > 0 and x.eapcstate < 4 and (GetDistance(x.eapc[5], x.eapc[4]) > 150) or ((IsPlayer(x.eapc[5]) and not IsInsideArea("apcarea1", x.player))) then
				x.failtype = 2
			end
			
			--Player didn't get in apc before convoy turn
			if x.eapcstate > 0 and x.eapcstate < 4 and GetDistance(x.eapc[5], "epturn") < 24 and not IsPlayer(x.eapc[5]) then
				x.failstate = 3
			end
			
			--Player eapc[5] was not at turn in time
			if x.eapcstate == 3 and x.waittime < GetTime() and GetDistance(x.eapc[5], "epturn") > 32 then
				x.failstate = 3
			end
			
			--Player left convoy early
			if x.eapcstate > 0 and x.eapcstate < 4 and not IsInsideArea("apcarea1", x.eapc[5]) then
				x.failstate = 4
			end
			
			--Player didn't wait for APC to be reloaded
			if x.eapcstate == 5 and GetDistance(x.eapc[5], "fpnav1") > 32 then
				x.failstate = 5
			end
			
			--Player didn't rejoin convoy
			if x.eapcstate == 6 and GetDistance(x.eapc[5], x.eapc[4]) > 125 and IsInsideArea("fortressarea", x.eapc[1]) then
				x.failstate = 2
			end
			
			--Player didn't leave apc or re-entered apc
			if (x.eapcstate >= 8 and x.waittime < GetTime() and IsPlayer(x.eapc[5])) or (x.eapcstate == 9 and IsPlayer(x.eapc[5])) then
				x.failstate = 6
			end
			
			--FAIL MISSION B/C CONVOY REASONS
			if x.eapcstate < 10 and x.failstate > 0 then
				AudioMessage("tcrs0805.wav") --FAIL - didn't join convoy
				ClearObjectives()
				if x.failstate == 3 or x.failstate == 4 then
					AddObjective(("tcrs0802.txt"):format(x.failstate), "RED")
				elseif x.failstate == 5 then
					AddObjective(("tcrs0804.txt"):format(x.failstate), "RED")
				else
					AddObjective(("tcrs080%d.txt"):format(x.failstate), "RED")
				end
				AddObjective("	")
				AddObjective("tcrs0816.txt", "RED")
				TCC.FailMission(GetTime() + 10.0, ("tcrs08f%d.des"):format(x.failstate))
				x.MCAcheck = true
				x.spine = 666
			end
			
			--Player caught in the convoy destruction
			if x.eapcstate == 9 and x.waittime < GetTime() then
				SetColorFade(6.0, 1.0, "WHITE")
				AudioMessage("xcar.wav") --("xlands.wav")
				TCC.FailMission(GetTime() + 2.0, ("tcrs08f7.des"):format(x.failstate))
				x.MCAcheck = true
				x.spine = 666
			end
		end --OA for convoy fail
		
		--EAPCSTATE LIST
		if x.LAST then
			--x.eapcstate = 1 --convoy exists
			--x.eapcstate = 2 --player is in correct apc
			--x.eapcstate = 3 --convoy at turn
			--x.eapcstate = 4 --player to leave convoy go to base
			--x.eapcstate = 5 --player at base reload
			--x.eapcstate = 6 --player go rejoin
			--x.eapcstate = 7 --player back with convoy
			--x.eapcstate = 8 --convoy at fortress
			--x.eapcstate = 9 --player out of apc
			--x.eapcstate = 10 --boom
			--x.eapcstate = 11 --convoy done
			--x.eapcstate = 12 --has frcy
		end
		
		--didn't destroy the solars and the comm tows
		if x.etimerstate == 1 and x.waittime < GetTime() and (IsAlive(x.ecom1) or IsAlive(x.ecom2) or IsAlive(x.esolar1) or IsAlive(x.esolar2)) then
			AudioMessage("tcrs0405.wav") --FAIL - Weak feeble. Will be replaced (condition?)
			ClearObjectives()
			AddObjective("tcrs0811.txt", "RED")
			AddObjective("	")
			AddObjective("tcrs0816.txt", "RED")
			TCC.FailMission(GetTime() + 7.0, "tcrs08f8.des") --LOSER LOSER LOSER
			x.MCAcheck = true
			x.spine = 666
		end
			
		--didn't escape fortress destruction
		if x.etimerstate == 2 and x.waittime < GetTime() and (IsInsideArea("fortressarea", x.player) or IsInsideArea("fortressarea", x.frcy)) then
			SetColorFade(6.0, 1.0, "WHITE")
			AudioMessage("xcar.wav") --("xlands.wav")
			TCC.FailMission(GetTime() + 2.0, "tcrs08f7.des") --LOSER LOSER LOSER
			x.MCAcheck = true
			x.spine = 666 
		end
		
		--lost Recycler
		if x.eapcstate >= 12 and not IsAlive(x.frcy) then
			AudioMessage("tcrs0405.wav") --FAIL - Weak feeble. Will be replaced (condition?)
			ClearObjectives()
			AddObjective("tcrs0815.txt", "RED")
			AddObjective("	")
			AddObjective("tcrs0816.txt", "RED")
			TCC.FailMission(GetTime() + 7.0, "tcrs08f9.des") --LOSER LOSER LOSER
			x.MCAcheck = true
			x.spine = 666
		end
	end
end 

function ObjectSniped(p, k) --NEEDED IF PLAYER SNIPED WHILE IN VEHICLE
	if p == x.player then
		SetColorFade(20.0, 0.5, "DKRED")
		ClearObjectives()
		AddObjective("tcrs0817.txt", "RED")
		AudioMessage("alertpulse.wav")
		TCC.FailMission(GetTime() + 3.0, "tcrs08f10.des") --LOSER LOSER LOSER
		MCAcheck = true
		x.spine = 666
	end
end
--[[END OF SCRIPT]]