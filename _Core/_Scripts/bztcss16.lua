--bztcss16 - Battlezone Total Command - Stars and Stripes - 16/17 - TAPPING THE CORE
assert(load(assert(LoadFile("_requirefix.lua")),"_requirefix.lua"))();
TCC = require("TC_Core")
MisnNum = 57;
--DECLARE variables --f-friend, e-enemy, atk-attack, rcy-recycler, etc..., 
local index = 1
local index2 = 1
local indexadd = 1
local x = {
	FIRST = true, 
	MCAcheck = false,
	waittime = 99999.9,
	player = nil, 
	mytank = nil, 
	skillsetting = 0,	
	spine = 0,
	casualty = 0,
	randompick = 0, 
	randomlast = 0, 
	pos = {}, 
	fnav1 = nil,
	audio1 = nil,	
	holder = {}, 
	free_player = false, 
	controls = {braccel = 0, strafe = 0, jump = 0, deploy = 0, eject = 0, abandon = 0, fire = 0}, 
	fallystart = false, --fally stuff
	fallyhold = false, 
	fallytotal = 0, 
	fallytime = 99999.9, 
	fallytimeadd = 0.0, 
	fallycamtime = 99999.9,
	fallymovetime = 99999.9,
	fallycam = 0, 
	fallyspawn = 0, 
	fally = {}, 
	fallytrgt = 0, 
	faction = "x", 
	frenemy = nil,
	camstop = 0, --camera
	camplay = 0, 
	camtime = 99999.9, 
	camobj = {}, 
  camfov = 60,  --185 default
	userfov = 90,  --seed
	counter = 0, 
	efac = {}, 
	spawnloc = 0, 
	efaccandie = false, 
	egun = {}, 
	epwr = {}, --wind power
	epwrdead = {0,0,0,0,0,0,0}, 
	egeo = {}, --geotherm power
	egeohurt = false, 
	eatk = {},
	fdrp = {}, 
	frcy = nil,
	ffac = nil,
	farm = nil, 
	ftnk = {}, 
	emintime = 99999.9, --eminelayers
	emin = {}, 
	emingo = {}, 
	emincool = {}, 
	eminallow = {},
	eminlife = {}, 
	eturtime = 99999.9, --eturrets, 
	eturlength = 17,
	etur = {}, 
	eturcool = {}, 
	eturallow = {},
	eturlife = {}, 
	epattime = 99999.9, --epatrols
	epatlength = 6, 
	epatlife = {}, 
	epat = {}, 
	epatcool = {}, 
	epatallow = {}, 
	eguardtime = 99999.9, --eguard base defender
	eguardlength = 4, 
	eguardlife = {}, 
	eguard = {}, 
	eguardcool = {}, 
	eguardallow = {}, 
	eblttime = 99999.9, --eboltmine
	ebltallgone = false, 
	ebltlength = 142,
	eblt = {}, 
	efaccount = 0, --factory camera
	edeftime = 99999.9, --defender of tower
	edefa = {}, 
	edefb = {}, 
	edefc = {}, 
  freestuff = {}, 
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
	ewarstate = {}, 
	ewarsize = {}, 
	ewarwave = {}, 
	ewarwavemax = {}, 
	ewarwavereset = {}, 
	ewarmeet = {}, 
	LAST = true
}
--PATHS: fpnav1-2, epgrcy, epgfac, eptur1-10, epgun1-24, ppatrol1-3, pblt142(0-142+), stage1-2, fally1-3(0-3), pcamobj1-2

function InitialSetup()
	SetAutoGroupUnits(true)
	
	local odfpreload = {
		"npscrx", 
		"svwalk", "svstnk", "svhtnk", "bvstnk", "bvhtnk", "bvwalk", "kvwalk", "kvhtnk", "mvstnk", "mvhtnk", "mvwalk", 
		"yvscout", "yvmbike", "yvmisl", "yvtank", "yvrckt",	"yvartl", "yvturr", "ybgtow",	"olybolt2", "stayput", "apcamra", "radjam"
	}
	for k,v in pairs(odfpreload) do
		PreloadODF(v)
	end
	
	x.mytank = GetHandle("mytank")
	for index = 1, 4 do
		x.egeo[index] = GetHandle(("egeo%d"):format(index))
		x.efac[index] = GetHandle(("efac%d"):format(index))
	end
	for index = 1, 7 do
		x.epwr[index] = GetHandle(("epwr%d"):format(index))
	end
	x.fdrp[1] = GetHandle("fdrp1")
	x.fdrp[2] = GetHandle("fdrp2")
	x.fdrp[3] = GetHandle("fdrp3")
	x.frcy = GetHandle("frcy")
	x.ffac = GetHandle("ffac")
	for index = 1, 6 do
		x.ftnk[index] = GetHandle(("ftnk%d"):format(index))
	end
  x.freestuff[1] = GetHandle("pega1")
  x.freestuff[2] = GetHandle("pega2")
  x.freestuff[3] = GetHandle("pega3")
	SetColorFade(6.0, 0.5, "BLACK")
	TCC.InitialSetup();
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
local replaced = false;
function AddObject(h)
	if (replaced) then replaced = false; return; end;
	if (GetTeamNum(h) == 1) then
		if (IsType(h, "bbarmo")) then
			h, replaced = RepObject(h);
			x.farm = h
		elseif (IsODF(h, "bbfact")) then
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
		elseif IsOdf(h, "bbpgen0") then
			for indexadd = 1, 4 do
				if x.fpwr[indexadd] == nil or not IsAlive(x.fpwr[indexadd]) then
					x.fpwr[indexadd] = h
					break
				end
			end
		elseif (IsCraftButNotPerson(h)) then
			ReplaceStabber(h);
		end
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
		x.pos = GetTransform(x.mytank)
		RemoveObject(x.mytank)
		x.mytank = BuildObject("bvtank", 1, x.pos)  
		x.pos = GetTransform(x.frcy)
		RemoveObject(x.frcy)
		x.frcy = BuildObject("bvrecy", 1, x.pos)
		SetGroup(x.frcy, 1) --being specific
		x.pos = GetTransform(x.ffac)
		RemoveObject(x.ffac)
		x.ffac = BuildObject("bvfact", 1, x.pos)
		SetGroup(x.ffac, 2) --being specific
		x.pos = GetTransform(x.ftnk[1])
		RemoveObject(x.ftnk[1])
		x.ftnk[1] = BuildObject("bvscout", 1, x.pos)  
		x.pos = GetTransform(x.ftnk[2])
		RemoveObject(x.ftnk[2])
		x.ftnk[2] = BuildObject("bvmbike", 1, x.pos)
		x.pos = GetTransform(x.ftnk[3])
		RemoveObject(x.ftnk[3])
		x.ftnk[3] = BuildObject("bvmisl", 1, x.pos)
		x.pos = GetTransform(x.ftnk[4])
		RemoveObject(x.ftnk[4])
		x.ftnk[4] = BuildObject("bvtank", 1, x.pos)  	
		x.pos = GetTransform(x.ftnk[5])
		RemoveObject(x.ftnk[5])
		x.ftnk[5] = BuildObject("bvturr", 1, x.pos)
		x.pos = GetTransform(x.ftnk[6])
		RemoveObject(x.ftnk[6])
		x.ftnk[6] = BuildObject("bvturr", 1, x.pos)
		SetAsUser(x.mytank, 1)
		RemoveObject(x.player)
		x.player = GetPlayerHandle()
		SetSkill(x.frcy, x.skillsetting)
		SetSkill(x.ffac, x.skillsetting)
		SetGroup(x.ftnk[1], 0)  
		SetGroup(x.ftnk[2], 0)
		SetGroup(x.ftnk[3], 0)  	
		SetGroup(x.ftnk[4], 0)
		SetGroup(x.ftnk[5], 5)
		SetGroup(x.ftnk[6], 5)  
		for index = 1, 6 do
			SetSkill(x.ftnk[index], x.skillsetting)
		end
		x.fnav1 = BuildObject("apcamra", 1, "fpnav1")
		SetObjectiveName(x.fnav1, "NSDF base")
		x.fnav1 = BuildObject("apcamra", 1, "fpnav2")
		SetObjectiveName(x.fnav1, "FURY base")
		for index = 1, x.ebltlength do
			x.eblt[index] = BuildObject("olybolt2", 5, "pblt142", index)
		end
		x.eblttime = GetTime() --init eblt
		for index = 1, 24 do
			x.egun[index] = BuildObject("ybgtow", 5, ("epgun%d"):format(index))
		end
		--[[
		RemoveObject(x.egun[1]) --make easier
		RemoveObject(x.egun[3]) --make easier
		RemoveObject(x.egun[5]) --make easier
		RemoveObject(x.egun[7]) --make easier
		RemoveObject(x.egun[9]) --make easier
		RemoveObject(x.egun[11]) --make easier
		RemoveObject(x.egun[13]) --make easier
		]]
		x.edeftime = GetTime() + 15.0 --let base cam run first
		for index = 1, x.eguardlength do --init eguard		
			x.eguardtime = GetTime() + 420.0
			x.eguardtime = GetTime() + 420.0
			x.eguardlife[index] = 0 
			x.eguard[index] = nil
			x.eguardcool[index] = GetTime() + 120.0
			x.eguardallow[index] = false
		end
		for index = 1, x.epatlength do --init epat
			x.epattime = GetTime() + 60.0
			x.epatcool[index] = GetTime()
			x.epatallow[index] = true
			x.epatlife[index] = 0
		end
		for index = 1, x.eturlength do --init etur
			x.eturtime = GetTime() + 60.0
			x.eturcool[index] = GetTime()
			x.eturallow[index] = true
			x.eturlife[index] = 0
		end
		x.emintime = GetTime() + 60.0 --init emin
		for index = 1, 2 do --init emin
			x.emincool[index] = GetTime()
			x.eminallow[index] = true
			x.eminlife[index] = 0
		end
		x.fallytimeadd = 0.0
		if x.skillsetting == 0 then
			x.fallytimeadd = 120.0
		elseif x.skillsetting == 1 then
			x.fallytimeadd = 60.0
		end
		SetScrap(1, 40)
    KillPilot(x.freestuff[1])
    KillPilot(x.freestuff[2])
    KillPilot(x.freestuff[3])
		x.spine = x.spine + 1
	end

	--DROPSHIP LANDING SEQUENCE - NO QUAKE LANDING
	if x.spine == 1 then
		for index = 1, 3 do
			for index2 = 1, 10 do
				StopEmitter(x.fdrp[index], index2)
			end
		end
		for index = 1, 6 do
			x.holder[index] = BuildObject("stayput", 0, x.ftnk[index])
		end
		x.holder[7] = BuildObject("stayput", 0, x.player) --fdrp1 dropship 1
		x.holder[8] = BuildObject("stayput", 0, x.ffac) --fdrp3 dropship 2
		x.holder[9] = BuildObject("stayput", 0, x.frcy) --fdrp2 dropship 3
    x.holder[10] = BuildObject("radjam", 5, x.player)
		Stop(x.ffac) --no ordering in dropship
		Stop(x.frcy)
		for index = 1, 6 do
			Stop(x.ftnk[index])
		end
		x.waittime = GetTime() + 3.0
		x.audio1 = AudioMessage("tcss1601.wav") --INTRO - Fact a nav 1. protect by minefield. Take out power plant
		x.camtime = GetTime() + 11.5 --Fury base segment
    x.userfov = IFace_GetInteger("options.graphics.defaultfov")
    CameraReady()
    IFace_SetInteger("options.graphics.defaultfov", x.camfov)
		x.spine = x.spine + 1
	end

	--OPEN DROPSHIP DOORS, REMOVE HOLDERS
	if x.spine == 2 and x.camstop == 3 and x.waittime < GetTime() then
		StartSoundEffect("dropdoor.wav")
		for index = 1, 4 do
			SetAnimation(x.fdrp[index], "open", 1)
		end
		for index = 1, 10 do
			RemoveObject(x.holder[index])
		end
		x.waittime = GetTime() + 4.0
		x.spine = x.spine + 1
	end
	
	--DOORS FULLY OPEN, GIVE MOVE ORDER
	if x.spine == 3 and x.waittime < GetTime() then
		Goto(x.frcy, "fpmeet3", 0)
		Goto(x.ffac, "fpmeet2", 0)
		Goto(x.ftnk[5], "fptur1", 0)
		Goto(x.ftnk[6], "fptur2", 0)
		for index = 1, 4 do
			Goto(x.ftnk[index], "fpmeet1", 0)
		end
		
		x.waittime = GetTime() + 2.0
		x.spine = x.spine + 1
	end

	--GIVE PLAYER CONTROL OF THEIR AVATAR
	if x.spine == 4 and x.waittime < GetTime() then
		x.free_player = true
		x.spine = x.spine + 1
	end
	
	--CHECK IF PLAYER HAS LEFT DROPSHIP
	if x.spine == 5 then
		x.player = GetPlayerHandle()
		if IsCraftButNotPerson(x.player) and GetDistance(x.player, x.fdrp[1]) > 60 then
			TCC.SetTeamNum(x.frcy, 1)
			TCC.SetTeamNum(x.ffac, 1)
			local tn = GetTeamNum(x.frcy);
			SetScrap(tn, GetMaxScrap(tn));
			x.waittime = GetTime() + 2.0
			x.spine = x.spine + 1
		end
	end
	
	--DROPSHIPS TAKEOFF
	if x.spine == 6 and x.waittime < GetTime() then
		for index = 1, 4 do
			for index2 = 1, 10 do
				StartEmitter(x.fdrp[index], index2)
			end
			SetAnimation(x.fdrp[index], "takeoff", 1)
			StartSoundEffect("dropleav.wav", x.fdrp[index])
		end
		ClearObjectives() --GIVE OBJECTIVE AND TURN ON POWER GENERATORS
		AddObjective("tcss1601.txt")
		for index = 1, 8 do
			SetObjectiveName(x.epwr[index], ("Power %d"):format(index))
			SetObjectiveOn(x.epwr[index])
		end
		x.waittime = GetTime() + 15.0
		x.spine = x.spine + 1
	end
	
	--REMOVE DROPSHIPS
	if x.spine == 7 and x.waittime < GetTime() then
		for index = 1, 4 do
			RemoveObject(x.fdrp[index])
		end
    x.ftnk[1] = BuildObject("yvrckt", 5, "epgfac1")  --reuse var name
    SetSkill(x.ftnk[1], x.skillsetting)
    Attack(x.ftnk[1], x.frcy)
		x.spine = x.spine + 1
	end
	
	--START UP ATTACKS
	if x.spine == 8 and IsAlive(x.frcy) and IsOdf(x.frcy, "bvrecy") then
		for index = 1, x.ewartotal do --init WARCODE
			x.ewardeclare = true
			x.ewarrior[index] = {} --"rows"
			x.ewartrgt[index] = nil
			for index2 = 1, 12 do --12 per wave max avail
				x.ewarrior[index][index2] = nil --"columns", init (handle in this case)
			end
			x.ewarstate[index] = 1
			x.ewartime[1] = GetTime() + 240.0 --recy
			x.ewartime[2] = GetTime() + 300.0 --fact
			x.ewartime[3] = GetTime() + 360.0 --armo
			x.ewartime[4] = GetTime() + 420.0 --base
			x.ewartimecool[index] = 240.0
			x.ewartimeadd[index] = 0.0
			x.ewarabort[index] = 99999.9
			x.ewarsize[index] = 0
			x.ewarwave[index] = 0
			x.ewarwavemax[index] = 5
			x.ewarwavereset[index] = 2
			x.ewarmeet[index] = 2
		end
		--Below works, but unless done properly within code context for each place in each script used, could generate another quicksave when loading a quicksave. 
		--So have decided to leave out b/c at this point would be a huge pita to implement and test for all the scripts (which already exist).
		--AudioMessage("quicksavesfx.wav") 
		--IFace_ConsoleCmd("game.quicksave", true)
		x.spine = x.spine + 1
	end

	--CHECK ON POWER TOWERS
	if x.spine == 9 then
		for index = 1, 7 do
			if not IsAlive(x.epwr[index]) then
				x.casualty = x.casualty + 1
			end
			if x.epwrdead[index] == 0 and not IsAlive(x.epwr[index]) then
				--see earlier note, these will generate another on load
				--AudioMessage("quicksavesfx.wav")
				--IFace_ConsoleCmd("game.quicksave", true)
				x.epwrdead[index] = 1
			end
		end
		if x.casualty == 7 then --setup camera to watch mines blowup
			x.edeftime = 99999.9
			x.fallyhold = true --stop fally spawn
			x.fallycam = 6 --make sure fally cam doesn't try to run
			x.ebltallgone = true --don't allow rebuild
			x.waittime = GetTime() + 2.0
			x.spine = x.spine + 1
		end
		x.casualty = 0
	end
	
	--AFTER 2 SECONDS, SETUP CAMERA
	if x.spine == 10 and x.waittime < GetTime() then
		x.camobj[1] = BuildObject("npscrx", 0, "pcamobj1") --for boltmines
		x.camobj[2] = BuildObject("npscrx", 0, "pcamobj2")
		x.camstop = 3 --just to be sure
		x.camplay = 9
		x.camtime = GetTime() + 4.0
    x.userfov = IFace_GetInteger("options.graphics.defaultfov")
    CameraReady()
    IFace_SetInteger("options.graphics.defaultfov", x.camfov)
		x.waittime = GetTime() + 1.0
		x.spine = x.spine + 1
	end
	
	--BLOWUP MINEFIELD
	if x.spine == 11 and x.waittime < GetTime() then
		for index = 1, x.ebltlength do
			if IsAlive(x.eblt[index]) and x.counter < x.ebltlength then
				Damage(x.eblt[index], (GetMaxHealth(x.eblt[index])+500))
				x.counter = x.counter + 1
				x.waittime = GetTime()
				break
			end
		end
		if x.counter == x.ebltlength then
			x.spine = x.spine + 1
		end
	end
	
	--GIVE ORDER TO ATTACK FURY BASE
	if x.spine == 12 and (x.camtime < GetTime() or CameraCancelled()) then
    CameraFinish()
    IFace_SetInteger("options.graphics.defaultfov", x.userfov)
		x.camstop = 4
		x.camplay = 10
		x.camtime = 99999.9
		RemoveObject(x.camobj[1])
		RemoveObject(x.camobj[2])
		ClearObjectives()
		AddObjective("tcss1601.txt", "GREEN")
		AddObjective("	")
		AddObjective("tcss1602.txt")
		AudioMessage("tcss1610.wav") --Excellent work, now proceed with assault on the factory.
		for index = 1, 4 do
			SetObjectiveName(x.egeo[index], ("Geothermal %d"):format(index))
			SetObjectiveOn(x.egeo[index])
		end
		x.spine = x.spine + 1
	end
	
	--ARE CHICKEN GENERATORS DEAD
	if x.spine == 13 then
		for index = 1, 4 do
			if not IsAlive(x.egeo[index]) then
				x.casualty = x.casualty + 1
			end
		end
		if not x.egeohurt and x.casualty == 2 then
			AudioMessage("tcss1602.wav") --Power levels at Fury fact critical. Look like explosion soon.
			x.egeohurt = true
		end
		if x.casualty == 4 then
			x.player = GetPlayerHandle()
			SetCurHealth(x.player, 10000)
			AudioMessage("tcss1603.wav") --Get out Cmd. Its going to blow.
			x.eturtime = 99999.9
			x.ewardeclare = false --HARD STOP
			x.eguardtime = 99999.9
			x.epattime = 99999.9
			x.emintime = 99999.9
			x.MCAcheck = true
			x.waittime = GetTime() + 2.0
			x.spine = x.spine + 1
		else
			x.casualty = 0
		end
	end 
	
	--BLOWUP GTOWS AND SETUP FOR FACTORY BLOWUP CAMERA
	if x.spine == 14 and x.waittime < GetTime() then
		for index = 1, 20 do
			if IsAlive(x.egun[index]) then
				Damage(x.egun[index], GetMaxHealth(x.egun[index])+10)
			end
		end
		x.waittime = GetTime() + 1.0
		x.efaccandie = true
		x.camobj[3] = BuildObject("npscrx", 0, "pcamobj3")
		x.camobj[4] = BuildObject("npscrx", 0, "pcamobj4")
		x.camstop = 5
		x.camplay = 11
		x.camtime = GetTime() + 8.0
    x.userfov = IFace_GetInteger("options.graphics.defaultfov")
    CameraReady()
    IFace_SetInteger("options.graphics.defaultfov", x.camfov)
		x.spine = x.spine + 1
	end
	
	--BLOWUP FURY FACTORIES
	if x.spine == 15 then
		if (x.waittime < GetTime()) and (x.efaccount < 4) then
      x.efaccount = x.efaccount + 1
			if IsAlive(x.efac[x.efaccount]) then
				Damage(x.efac[x.efaccount], (GetMaxHealth(x.efac[x.efaccount])+100))
			end
			x.waittime = GetTime() + 2.0
		end
		if x.efaccount >= 4 then
			x.spine = x.spine + 1
		end
	end
	
	--SUCCEED MISSION
	if x.spine == 16 and x.camstop == 6 then
		AudioMessage("tcss1609.wav") --6+ SUCCESS - Good job. You've achieved the impossible.
		ClearObjectives()
		AddObjective("tcss1603.txt", "GREEN") --Geotherm destroyed
		TCC.SucceedMission(GetTime() + 10.0, "tcss16w1.des") --WINNER WINNER WINNER
		x.spine = x.spine + 1
	end
	----------END MAIN SPINE ----------

	--ENSURE PLAYER CAN'T DO ANYTHING WHILE IN DROPSHIP
	if not x.free_player then
		x.controls = {braccel = 0, strafe = 0, jump = 0, deploy = 0, eject = 0, abandon = 0, fire = 0}
		SetControls(x.player, x.controls)
	end

	--RUN CAMERA 1A ON FURY BASE
	if x.camplay == 0 then
		CameraPath("pcam0", 3500, 2800, x.egeo[2])
		if x.camtime < GetTime() or CameraCancelled() then
			x.camplay = x.camplay + 1
			x.camstop = 1
			x.camtime = GetTime() + 2.0 --reset for pgens
		end
	end

	--RUN CAMERA 1B ON WIND PGENS
	if x.camstop == 1 and x.camplay > 0 and x.camplay < 8 then
		CameraPath(("pcam%d"):format(x.camplay), 3000, 1200, x.epwr[x.camplay])
		if x.camtime < GetTime() then
			x.camtime = GetTime() + 2.0
			x.camplay = x.camplay + 1
			if x.camplay == 8 then
				x.camstop = 2
			end
		end
	end

	--STOP CAMERA 1B by PLAYER or by TIME DONE
	if x.camstop == 2 or CameraCancelled() then
		CameraFinish()
		x.waittime = GetTime() + 2.0 --for dropship
		x.camstop = 3
		IFace_SetInteger("options.graphics.defaultfov", x.userfov)
	end
	
	--RUN CAMERA ON BOLTMINE DESTRUCTION
	if x.camstop == 3 and x.camplay == 9 then
		CameraObject(x.camobj[1], 0, 1, 0, x.camobj[2])
	end
	
	--RUN CAMERA ON FURY FACTORY BLOWUP
	if x.camstop == 5 and x.camplay == 11 then
		CameraObject(x.camobj[3], 0, 30, 0, x.camobj[4])
		if x.camtime < GetTime() or CameraCancelled() then
      CameraFinish()
      IFace_SetInteger("options.graphics.defaultfov", x.userfov)
			RemoveObject(x.camobj[3])
			RemoveObject(x.camobj[4])
			x.camstop = 6
		end
	end
	
	--KEEP FURY FACTORIES ALIVE
	if not x.efaccandie then
		for index = 1, 4 do
			if IsAlive(x.efac[index]) and GetCurHealth(x.efac[index]) < (GetMaxHealth(x.efac[index]) * 0.9) then
				SetCurHealth(x.efac[index], GetMaxHealth(x.efac[index]))
			end
		end
	end
	
	--ALLIED REINFORCEMENTS START
	if not x.fallystart and IsOdf(x.frcy, "bvrecy") then
		x.fallytime = GetTime() + 300.0
		x.fallystart = true
	end

	--ALLIED REINFORCEMENTS PICK
	if not x.fallyhold and x.fallytotal < 11 and x.fallytime < GetTime() then
		x.fallytotal = x.fallytotal + 1
		while x.randompick == x.randomlast do --select random spawn location
			x.randompick = math.floor(GetRandomFloat(1.0,3.0))
		end
		x.fallyspawn = x.randompick
		x.randomlast = x.randompick
		while x.randompick == x.randomlast do --faction choice
			x.randomfloat = GetRandomFloat(1.0, 4.0)
			x.randompick = math.floor(x.randomfloat)
		end
		x.randomlast = x.randompick
		if x.randompick == 1 then
			x.faction = "b"
		elseif x.randompick == 2 then
			x.faction = "m"
		elseif x.randompick == 3 then
			x.faction = "k"
		else
			x.faction = "s"
		end
		--6 spawn points avail
		if x.faction == "k" then --cuz no kvStnk
			x.fally[1] = BuildObject(("kvhtnk"):format(x.faction), 1, ("fally%d"):format(x.fallyspawn), 1)
		else
			x.fally[1] = BuildObject(("%svstnk"):format(x.faction), 1, ("fally%d"):format(x.fallyspawn), 1)
		end
		x.fally[2] = BuildObject(("%svhtnk"):format(x.faction), 1, ("fally%d"):format(x.fallyspawn), 2)
		x.fally[3] = BuildObject(("%svwalk"):format(x.faction), 1, ("fally%d"):format(x.fallyspawn), 3)
		if x.faction == "k" then --cuz no kvStnk
			x.fally[4] = BuildObject(("kvhtnk"):format(x.faction), 1, ("fally%d"):format(x.fallyspawn), 4)
		else
			x.fally[4] = BuildObject(("%svstnk"):format(x.faction), 1, ("fally%d"):format(x.fallyspawn), 4)
		end
    if x.skillsetting >= 1 then
      x.fally[5] = BuildObject(("%svhtnk"):format(x.faction), 1, ("fally%d"):format(x.fallyspawn), 5)
    end
    if x.skillsetting >= 2 then
      x.fally[6] = BuildObject(("%svwalk"):format(x.faction), 1, ("fally%d"):format(x.fallyspawn), 6)
    end
		for index = 1, 6 do
      if IsAlive(x.fally[index]) then
        SetSkill(x.fally[index], x.skillsetting)
        SetGroup(x.fally[index], 9)
        if x.fallyspawn == 1 then
          x.fallytrgt = 1
        elseif x.fallyspawn == 2 then
          x.fallytrgt = 3
        elseif x.fallyspawn == 3 then
          x.fallytrgt = 5
        end
        if IsAlive(x.epwr[x.fallytrgt]) then
          Attack(x.fally[index], x.epwr[x.fallytrgt], 0)
        elseif IsAlive(x.epwr[x.fallytrgt+1]) then
          Attack(x.fally[index], x.epwr[x.fallytrgt+1], 0)
        elseif x.fallyspawn == 3 and IsAlive(x.epwr[7]) then --special for tower 7
          Attack(x.fally[index], x.epwr[x.fallytrgt+2], 0)
        else
          Goto(x.fally[index], x.frcy, 0)
        end
      end
		end
		for index = 1, 12 do
			x.randompick = math.floor(GetRandomFloat(1.0, 9.0))
		end
		if x.randompick == 1 or x.randompick == 4 or x.randompick == 7 then
			x.fallytime = GetTime() + x.fallytimeadd + 660.0 --11
		elseif x.randompick == 2 or x.randompick == 5 or x.randompick == 8 then
			x.fallytime = GetTime() + x.fallytimeadd + 480.0 --8
		else
			x.fallytime = GetTime() + x.fallytimeadd + 300.0 --5
		end
		x.fallymovetime = GetTime() + 4.0 --give time to move
	end

	--CHECK SAFE TO RUN FALLY CAMERA
	if x.fallycam == 0 and x.fallymovetime < GetTime() then
		x.player = GetPlayerHandle()
		if IsAlive(x.player) then --in case player dies b4 check is done
			x.frenemy = GetNearestEnemy(x.player, 1, 1, 200)
			if GetDistance(x.player, x.frenemy) > 150 and not x.fallycamhold then
				x.fallycam = 1
				x.fallycamtime = GetTime() + 3.0
			end
			x.fallymovetime = 99999.9
			AudioMessage("tcss1611.wav") --reinforce incoming - modded tcss1116.wav
		end
	end

	--RUN FALLY CAMERA
	if x.fallycam == 1 then
			x.fallycamtime = 99999.9
			x.fallycam = 0
--		end
	end
	
	--FURY BOLTMINE REBUILD IF KILLED AND KEEP CHICKEN PGEN ALIVE
	if not x.ebltallgone and x.eblttime < GetTime() then
		for index = 1, x.ebltlength do
			if not IsAlive(x.eblt[index]) then
				x.eblt[index] = BuildObject("olybolt2", 5, "pblt142", index)
			end
		end
		for index = 1, 4 do --keep rear pgens alive for now
			SetCurHealth(x.egeo[index], GetMaxHealth(x.egeo[index]))
		end
		x.eblttime = GetTime() + 15.0
	end
	
	--FURY TOWER DEFENDER
	if x.edeftime < GetTime() then	
		for index = 1, 7 do
			if IsAlive(x.epwr[index]) and not IsAlive(x.edefa[index]) then
				x.edefa[index] = BuildObject("yvartl", 5, "epgfac2")
				GiveWeapon(x.edefa[index], "gsldda")
				SetSkill(x.edefa[index], x.skillsetting)
				Defend2(x.edefa[index], x.epwr[index])
			elseif not IsAlive(x.epwr[index]) and IsAlive(x.edefa[index]) then
				Defend(x.edefa[index])
			end
			--[[MAKE A LIL EASIER  
			if IsAlive(x.epwr[index]) and not IsAlive(x.edefb[index]) then
				x.edefb[index] = BuildObject("yvartl", 5, "epgfac3")
				GiveWeapon(x.edefb[index], "gsldda")
				SetSkill(x.edefb[index], x.skillsetting)
				Defend2(x.edefb[index], x.epwr[index])
			elseif not IsAlive(x.epwr[index]) and IsAlive(x.edefa[index]) then
				Defend(x.edefb[index])
			end--]]
			if IsAlive(x.epwr[index]) and not IsAlive(x.edefc[index]) then
				x.edefc[index] = BuildObject("yvrckt", 5, "epgfac4")
				GiveWeapon(x.edefc[index], "gsldda")
				SetSkill(x.edefc[index], x.skillsetting)
				Defend2(x.edefc[index], x.epwr[index])
			elseif not IsAlive(x.epwr[index]) and IsAlive(x.edefa[index]) then
				Defend(x.edefc[index])
			end
		end
		x.edeftime = GetTime() + 60.0
	end
	
	--FURY GROUP TURRET GENERIC
	if x.eturtime < GetTime() then
		for index = 1, x.eturlength do
			if not IsAlive(x.etur[index]) and not x.eturallow[index] and x.eturlife[index] < 2 then
				x.eturcool[index] = GetTime() + 420.0
				x.eturallow[index] = true
			end
			if x.eturallow[index] and x.eturcool[index] < GetTime() then
				x.etur[index] = BuildObject("yvturr", 5, "epgfac1")
				GiveWeapon(x.etur[index], "gsldda")
				SetSkill(x.etur[index], x.skillsetting)
				--SetObjectiveName(x.etur[index], ("Teucer %d"):format(index))
				Goto(x.etur[index], ("eptur%d"):format(index))
				x.eturallow[index] = false
				x.eturlife[index] = x.eturlife[index] + 1
			end
		end
		x.eturtime = GetTime() + 60.0
	end

	--FURY GROUP SCOUT PATROLS 
	if x.epattime < GetTime() then
		for index = 1, x.epatlength do
			if not IsAlive(x.epat[index]) and not x.epatallow[index] and x.epatlife[index] < 3 then
				x.epatcool[index] = GetTime() + 300.0
				x.epatallow[index] = true
			end
			if x.epatallow[index] and x.epatcool[index] < GetTime() then
				while x.randompick == x.randomlast do --random the random
					x.randompick = math.floor(GetRandomFloat(1.0, 12.0))
				end
				x.randomlast = x.randompick
				if x.randompick == 1 or x.randompick == 5 or x.randompick == 9 then
					x.epat[index] = BuildObject("yvmbike", 5, "epgfac2")
					GiveWeapon(x.epat[index], "gsldda")
				elseif x.randompick == 2 or x.randompick == 6 or x.randompick == 10 then
					x.epat[index] = BuildObject("yvmisl", 5, "epgfac2")
				elseif x.randompick == 3 or x.randompick == 7 or x.randompick == 11 then
					x.epat[index] = BuildObject("yvtank", 5, "epgfac2")
				else --4, 8, 12
					x.epat[index] = BuildObject("yvartl", 5, "epgfac2")  
					GiveWeapon(x.epat[index], "gsldda")
				end
				SetSkill(x.epat[index], x.skillsetting)
				if index <= x.epatlength/2 then
					Patrol(x.epat[index], ("ppatrol%d"):format(index))
				else
					Patrol(x.epat[index], ("ppatrol%d"):format(index-3))
				end
				--SetObjectiveName(x.epat[index], ("Patrol %d"):format(index))
				x.epatlife[index] = x.epatlife[index] + 1
				x.epatallow[index] = false
			end
		end
		x.epattime = GetTime() + 360.0
	end
	
	--WARCODE --no recy all facs
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
						if index == 1 then
							x.ewarsize[index] = 4
						else
							x.ewarsize[index] = 2
						end
					elseif x.ewarwave[index] == 2 then
						if index == 1 then
							x.ewarsize[index] = 6
						else
							x.ewarsize[index] = 3
						end
					elseif x.ewarwave[index] == 3 then
						if index == 1 then
							x.ewarsize[index] = 8
						else
							x.ewarsize[index] = 4
						end
					elseif x.ewarwave[index] == 4 then
						if index == 1 then
							x.ewarsize[index] = 10
						else
							x.ewarsize[index] = 5
						end 
					else --x.ewarwave[index] == 5 then
						if index == 1 then
							x.ewarsize[index] = 12
						else
							x.ewarsize[index] = 6
						end
					end
					x.ewarstate[index] = x.ewarstate[index] + 1
				end
				
				--BUILD FORCE
				if x.ewarstate[index] == 2 then
					for index2 = 1, x.ewarsize[index] do
						while x.randompick == x.randomlast do --random the random
							x.randompick = math.floor(GetRandomFloat(1.0, 21.0))
						end
						x.randomlast = x.randompick
						x.spawnloc = x.spawnloc + 1
						if x.spawnloc == 5 then
							x.spawnloc = 1
						end
						if x.randompick == 1 or x.randompick == 8 or x.randompick == 15 then
							x.ewarrior[index][index2] = BuildObject("yvscout", 5, ("epgfac%d"):format(x.spawnloc)) --"epgfac4")
						elseif x.randompick == 2 or x.randompick == 9 or x.randompick == 16 then
							x.ewarrior[index][index2] = BuildObject("yvmbike", 5, ("epgfac%d"):format(x.spawnloc)) --"epgfac3")
						elseif x.randompick == 3 or x.randompick == 10 or x.randompick == 17 then
							x.ewarrior[index][index2] = BuildObject("yvmisl", 5, ("epgfac%d"):format(x.spawnloc)) --"epgfac2")
								if x.ewarwave[index] == 2 or x.ewarwave[index] == 4 then
									GiveWeapon(x.ewarrior[index][index2], "gshdwa_c") --shadower
								end
						elseif x.randompick == 4 or x.randompick == 11 or x.randompick == 18 then
							x.ewarrior[index][index2] = BuildObject("yvtank", 5, ("epgfac%d"):format(x.spawnloc)) --"epgfac1")
								if x.ewarwave[index] == 3 or x.ewarwave[index] == 5 then
									GiveWeapon(x.ewarrior[index][index2], "gflsha_c")
								end
						elseif x.randompick == 5 or x.randompick == 12 or x.randompick == 19 then
							x.ewarrior[index][index2] = BuildObject("yvrckt", 5, ("epgfac%d"):format(x.spawnloc)) --"epgfac3")
							while x.weappick == x.weaplast do --random the random
								x.weappick = math.floor(GetRandomFloat(1.0, 12.0))
							end
							x.weaplast = x.weappick
							if x.weappick == 1 or x.weappick == 5 or x.weappick == 9 then
								GiveWeapon(x.ewarrior[index][index2], "gfplsy_a")  --"gblsta_a")
							elseif x.weappick == 2 or x.weappick == 6 or x.weappick == 10 then
								GiveWeapon(x.ewarrior[index][index2], "gflsha_a")
							elseif x.weappick == 3 or x.weappick == 7 or x.weappick == 11 then
								GiveWeapon(x.ewarrior[index][index2], "gstbva_a")
							end --if outside random, then stick with default weapons
						elseif x.randompick == 6 or x.randompick == 13	or x.randompick == 20 then
							x.ewarrior[index][index2] = BuildObject("yvartl", 5, ("epgfac%d"):format(x.spawnloc)) --"epgfac2")
						else --7, 14, 21
							x.ewarrior[index][index2] = BuildObject("yvwalk", 5, ("epgfac%d"):format(x.spawnloc)) --"epgfac1")
							while x.weappick == x.weaplast do --random the random
								x.weappick = math.floor(GetRandomFloat(1.0, 12.0))
							end
							x.weaplast = x.weappick
							if x.weappick == 1 or x.weappick == 5 or x.weappick == 9 then
								GiveWeapon(x.ewarrior[index][index2], "gfplsy_a")
							elseif x.weappick == 2 or x.weappick == 6 or x.weappick == 10 then
								GiveWeapon(x.ewarrior[index][index2], "gflsha_a")
							elseif x.weappick == 3 or x.weappick == 7 or x.weappick == 11 then
								GiveWeapon(x.ewarrior[index][index2], "gstbva_a")
							end --if outside random, then stick with default weapons
						end
            if index2 % 2 == 0 then
							SetSkill(x.ewarrior[index][index2], x.skillsetting+1)
            else
              SetSkill(x.ewarrior[index][index2], x.skillsetting)
						end
					end
					x.spawnloc = 0
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
						if IsAlive(x.ewarrior[index][index2]) then --pick stage location
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
								--SetObjectiveName(x.ewarrior[index][index2], ("Kill Player %d"):format(index2))
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
						if x.ewartimeadd[index] < 60.0 then
							x.ewartimeadd[index] = x.ewartimeadd[index] + 5.0
						end
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

	--GEO-THERMAL POWER GUARDIANS
	if x.eguardtime < GetTime() then
		for index = 1, x.eguardlength do
			if (not IsAlive(x.eguard[index]) or (IsAlive(x.eguard[index]) and GetTeamNum(x.eguard[index]) == 1)) and not x.eguardallow[index] and x.eguardlife[index] < 4 then
				x.eguardcool[index] = GetTime() + 120.0
				x.eguardallow[index] = true
			end
			if x.eguardallow[index] and x.eguardcool[index] < GetTime() then
				x.eguard[index] = BuildObject("yvtank", 5, "epgfac2")
				SetSkill(x.eguard[index], x.skillsetting)
				if IsAlive(x.egeo[index]) then
					Defend2(x.eguard[index], x.egeo[index])
				else
					for index2 = 1, 4 do
						if IsAlive(x.egeo[index2]) then
							Defend2(x.eguard[index], x.egeo[index2])
							break
						end
					end
				end
				--SetObjectiveName(x.eguard[index], ("Guardian %d"):format(index))
				x.eguardlife[index] = x.eguardlife[index] + 1
				x.eguardallow[index] = false
			end
		end
		x.eguardtime = GetTime() + 120.0
	end

	--FURY MINELAYER SQUAD
	if x.emintime < GetTime() then
		for index = 1, 2 do
			if (not IsAlive(x.emin[index]) or (IsAlive(x.emin[index]) and GetTeamNum(x.emin[index]) == 1)) and not x.eminallow[index] and x.eminlife[index] < 3 then
				x.emincool[index] = GetTime() + 300.0
				x.eminallow[index] = true
			end
			if x.eminallow[index] and x.emincool[index] < GetTime() then
				x.emin[index] = BuildObject("yvmine", 5, "epgfac3")
				GiveWeapon(x.epat[index], "gsldda")
				SetSkill(x.emin[index], x.skillsetting)
				SetObjectiveName(x.emin[index], ("Sporio %d"):format(index))
				Goto(x.emin[index], ("epmin%d"):format(index)) --resend orders
				x.emingo[index] = true
				x.eminallow[index] = false
				x.emintime = GetTime() + 120.0
				x.eminlife[index] = x.eminlife[index] + 1
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
			AudioMessage("tcss1604.wav") --FAIL - Recy Texas lost 
			ClearObjectives()
			AddObjective("tcss1604.txt", "RED") --Texas lost mission failed
			TCC.FailMission(GetTime() + 12.0, "tcss16f1.des") --LOSER LOSER LOSER
			x.spine = 666
			x.MCAcheck = true
		end
	end
end
--[[END OF SCRIPT]]