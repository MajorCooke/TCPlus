--bztcss14 - Battlezone Total Command - Stars and Stripes - 14/17 - UNITED WE FIGHT, UNITED WE DIE
assert(load(assert(LoadFile("_requirefix.lua")), "_requirefix.lua"))();
TCC = require("TC_Core")
MisnNum = 50;
--require("_MCFunctions");
local index = 0
local index2 = 0
local x = {
	FIRST = true,
	MCAcheck = false, 
	player = nil, 
	mytank = nil, 
	skillsetting = 0, 
	spine = 0, 
	casualty = 0, 
	randompick = 0, 
	randomlast = 0, 
	fnav = nil,	
	audio1 = nil,
	waittime = 99999.9, 
	camplay = false, 
  camfov = 60,  --185 default
	userfov = 90,  --seed
	ccamet = false, 
	fbrecypresent = false, 
	tartstate = 0, 
	tarttime = 99999.9, 
	tart = nil, 
	tartatk = {}, 
	tartcount = 0, 
	bankscrap = false, 
	winner = false, 
	allyTime = 99999.9, 
	ccaposttime = 99999.9, 
	siloposttime = 99999.9, 
	wintime = 99999.9, 
	gotextract = false, 
	sil1 = nil, 
	sil2 = nil, 
	sil3 = nil, 
	ypilo = nil, 
	frcy = nil, 
	ffac = nil, 
	farm = nil, 
	fcon = nil, 
	ftnk = {}, 
	point = 0, 
	silothree = 0, 
	allymeet = 0, 
	allycase = 0, 
	banknote = 0, 
	eturtime = 99999.9, --eturret
	eturlength = 6,
	etur = {}, 
	eturcool = {}, 
	eturallow = {}, 
	eturlife = {}, 
	epattime = 99999.9,	 --patrols
	epatlength = 4, 
	epat = {}, 
	epatallow = {}, 
	epatcool = {}, 
	fpwr = {nil, nil, nil, nil}, 
	fhqr = nil, 
	ftec = nil, 
	ftrn = nil, 
	fbay = nil, 
	fcom = nil, 
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
--PATHS: pmytank, fprcy, fpcon, fpg0-2, fnav0-5, eptur1-6, cca1-3, nsd1-3, ppatrol1-4, epmeet1-2, epgtart

function InitialSetup()
	SetAutoGroupUnits(true)
	
	local odfpreload = {
		"avrecyss14", "avconsss14", "avscout", "avmbike", "avmisl", "avtank", "avrckt", 
		"yvscout", "yvmbike", "yvmisl", "yvrckt", "yvartl", "yvturr",
		"svscout", "svmbike", "svmisl", "svtank", "svrckt", "apcamra"
	}
	for k,v in pairs(odfpreload) do
		PreloadODF(v)
	end
	
	x.tart = GetHandle("tart")  
	SetColorFade(6.0, 0.5, "BLACK")
	TCC.InitialSetup();
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
end

function AddObject(h)  
	if not x.gotextract and IsOdf(h, "abscav") then
		x.gotextract = true
	end
	
	if x.silothree == 0 then
		if IsOdf(h, "abscav") then --See if player has 3 abscav at once
			if not IsAlive(x.sil1) and h ~= x.sil2 and h ~= x.sil3 then
				x.sil1 = h
			elseif not IsAlive(x.sil2) and h ~= x.sil1 and h ~= x.sil3 then
				x.sil2 = h
			elseif not IsAlive(x.sil3) and h ~= x.sil1 and h ~= x.sil2 then
				x.sil3 = h
			end
		end
		
		if IsAlive(x.sil1) and IsAlive(x.sil2) and IsAlive(x.sil3) then
			x.silothree = 1
		end
	end

	--check when x.player builds base buildings for AI attacks
	if (IsCraftButNotPerson(h) or IsBuilding(h)) then
		h = RepObject(h);
	end
	if (not IsAlive(x.farm) or x.farm == nil) and (IsOdf(h, "avarmo") or IsOdf(h, "abarmo")) then
		x.farm = h;
	elseif (not IsAlive(x.ffac) or x.ffac == nil) and (IsOdf(h, "avfactss14:1") or IsOdf(h, "abfactss14")) then
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
	elseif IsOdf(h, "abpgen2") then
		for indexadd = 1, 4 do
			if x.fpwr[indexadd] == nil or not IsAlive(x.fpwr[indexadd]) then
				x.fpwr[indexadd] = h
				break
			end
		end
	elseif (IsAlive(h) or IsPlayer(h)) then
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
function Update()
	x.player = GetPlayerHandle() --EVERY PASS SO IF PLAYER CHANGES VEHICLES
	x.skillsetting = IFace_GetInteger("options.play.difficulty")
	TCC.Update();
	--Start THE MISSION BASICS
	if x.spine == 0 then
		x.audio1 = AudioMessage("tcss1401.wav") --INTRO - Gather scrap
		AddObjective("tcss1401.txt")
		x.frcy = BuildObject("avrecyss14", 1, "fprcy")
		x.fcon = BuildObject("avconsss14", 1, "fpcon")
		x.ftnk[1] = BuildObject("svmisl", 0, "cca1")
		x.ftnk[2] = BuildObject("svtank", 0, "cca2")
		x.ftnk[3] = BuildObject("svtank", 0, "cca3")
		x.mytank = BuildObject("avrckt", 1, "pmytank")
		GiveWeapon(x.mytank, "gminia_a")
		GiveWeapon(x.mytank, "gstbsa_a")
		GiveWeapon(x.mytank, "gsanda_a")
		SetAsUser(x.mytank, 1)
		RemoveObject(x.player)
		x.player = GetPlayerHandle()
		SetSkill(x.frcy, x.skillsetting)
		SetGroup(x.frcy, 3)
		SetSkill(x.fcon, x.skillsetting)
		SetGroup(x.fcon, 8)
		x.fnav = BuildObject("apcamra", 1, "fnav0")
		SetObjectiveName(x.fnav, "ALPHA Outpost")
		x.fnav = BuildObject("apcamra", 1, "fnav1")
		SetObjectiveName(x.fnav, "NE pool")
		x.fnav = BuildObject("apcamra", 1, "fnav2")
		SetObjectiveName(x.fnav, "NW pool")
		x.fnav = BuildObject("apcamra", 1, "fnav4")
		SetObjectiveName(x.fnav, "SE pool")
		x.fnav = BuildObject("apcamra", 1, "fnav3")
		SetObjectiveName(x.fnav, "SW pool")
		x.fnav = BuildObject("apcamra", 1, "fnav5")
		SetObjectiveName(x.fnav, "BRAVO")
		SetObjectiveOn(x.fnav)
		for index = 1, 3 do
			SetSkill(x.ftnk[index], x.skillsetting)
			LookAt(x.ftnk[index], x.fnav)
		end
		Goto(x.frcy, "fprcy", 0) --gotta go there anyway...
		Follow(x.fcon, x.frcy, 0) --...so make life easier
		SetScrap(1, 40)
		x.spine = x.spine + 1
	end

	--prep cutscene
	if x.spine == 1 and IsAudioMessageDone(x.audio1) then
		for index = 1, 3 do
			Goto(x.ftnk[index], "cca1", 0)
		end
		x.waittime = GetTime() + 2.0
		x.spine = x.spine + 1
	end

	--play cca tank movie
	if x.spine == 2 and x.waittime < GetTime() then
		AudioMessage("tcss1402.wav") --Remnant 11th work battalion will join at nav Bravo. Get 75 scrap
		x.camtime = GetTime() + 12.0
    x.userfov = IFace_GetInteger("options.graphics.defaultfov")
    CameraReady()
    IFace_SetInteger("options.graphics.defaultfov", x.camfov)
		x.spine = x.spine + 1
	end
	
	--Beauty cam CCA tank
	if x.spine == 3 then
		CameraObject(x.ftnk[2], -40, 20, 40, x.ftnk[2]) --in meters
		AddHealth(x.player, 5)
		if x.camtime < GetTime() or CameraCancelled() then
      CameraFinish()
      IFace_SetInteger("options.graphics.defaultfov", x.userfov)
			x.camtime = 99999.9
			ClearObjectives()
			AddObjective("tcss1412.txt")
			x.spine = x.spine + 1
		end
	end
	
	--FBRECY START ALLY AND ATTACK COUNTDOWN
	if x.spine == 4 and IsAlive(x.frcy) and IsOdf(x.frcy, "abrecyss14") then
		ClearObjectives()
		AddObjective("tcss1402.txt")
		x.fnav = BuildObject("yvartl", 5, "epmeet1")
		SetEjectRatio(x.fnav, 0.0)
		SetSkill(x.fnav, x.skillsetting)
		Attack(x.fnav, x.frcy) --lil' more spice
		x.allyTime = GetTime() + 120.0
		x.waittime = GetTime() + 300.0
		x.spine = x.spine + 1
	end
	
	--DEPLOY FIRST SCAV BEFORE REAL ATTACKS
	if x.spine == 5 and (x.gotextract or x.waittime < GetTime()) then
		for index = 1, x.epatlength do --init epat
			x.epattime = GetTime() + 180.0
			x.epatcool[index] = GetTime()
			x.epatallow[index] = true
		end
		for index = 1, x.eturlength do --init etur
			x.eturtime = GetTime() + 120.0
			x.eturcool[index] = GetTime()
			x.eturallow[index] = true
			x.eturlife[index] = 0
		end
		for index = 1, x.ewartotal do --init WARCODE
			x.ewardeclare = true
			x.ewarrior[index] = {} --"rows"
			x.ewartrgt[index] = nil
			for index2 = 1, 10 do --10 per wave max avail
				x.ewarrior[index][index2] = nil --"columns", init (handle in this case)
			end
			x.ewarstate[index] = 1
			x.ewartime[1] = GetTime() + 300.0 --recy
			x.ewartime[2] = GetTime() + 360.0 --fact
			x.ewartime[3] = GetTime() + 420.0 --armo
			x.ewartime[4] = GetTime() + 480.0 --base
			x.ewartimecool[index] = 240.0
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
	----------END MAIN SPINE ----------

	--CCA forces met
	if not x.ccamet then
		if GetDistance(x.player, "fnav5") < 100 or GetDistance(x.player, x.ftnk[1]) < 100 then
			AudioMessage("tcss1403.wav") --My comrades await your orders soviet
			for index = 1, 3 do
				TCC.SetTeamNum(x.ftnk[index], 1)
				SetGroup(x.ftnk[index], 0)
			end
			if IsAlive(x.fnav) then
				SetObjectiveOff(x.fnav)
				RemoveObject(x.fnav)
			end
			ClearObjectives()
			AddObjective("tcss1412.txt", "GREEN")
			x.ccaposttime = GetTime() + 3.0
			x.ccamet = true
		end
	end

	--Repost the mission objectives
	if x.ccaposttime < GetTime() then
		ClearObjectives()
		AddObjective("Deploy the Texas at ALPHA Outpost")
		x.ccaposttime = 99999.9
		x.fnav = BuildObject("yvrckt", 5, "fnav1")
		SetEjectRatio(x.fnav, 0.0)
		SetSkill(x.fnav, x.skillsetting)
		Attack(x.fnav, x.frcy) --lil' spice
	end

	--MEET WITH ALLIES NSDF OR CCA
	if x.allymeet == 0 and x.allyTime < GetTime() then
		if x.allycase == 0 then
		AudioMessage("tcss1411.wav") --Rendezvous w/ Mass survivors at NW geyser site.
		x.allycase = x.allycase + 1 --seed first increment, all reset to 1 later
		end
		if x.allycase == 1 or x.allycase == 3 then
			x.ftnk[1] = BuildObject("avtank", 0, ("ppatrol%d"):format(x.allycase))
			x.ftnk[2] = BuildObject("avtank", 0, ("ppatrol%d"):format(x.allycase))
			x.ftnk[3] = BuildObject("avrckt", 0, ("ppatrol%d"):format(x.allycase))
			x.ftnk[4] = BuildObject("avrckt", 0, ("ppatrol%d"):format(x.allycase))
			x.fnav = BuildObject("apcamra", 1, ("fnav%d"):format(x.allycase))
			AudioMessage("tcss1420.wav") --COXXON ADDED – Assume full cmd of the NSDF forces
			SetObjectiveName(x.fnav, "Meet NSDF Forces")
			x.allymeet = 1
		else
			x.ftnk[1] = BuildObject("svtank", 0, ("ppatrol%d"):format(x.allycase))
			x.ftnk[2] = BuildObject("svtank", 0, ("ppatrol%d"):format(x.allycase))
			x.ftnk[3] = BuildObject("svrckt", 0, ("ppatrol%d"):format(x.allycase))
			x.ftnk[4] = BuildObject("svrckt", 0, ("ppatrol%d"):format(x.allycase))
			x.fnav = BuildObject("apcamra", 1, ("fnav%d"):format(x.allycase))
			AudioMessage("tcss1419.wav") --COXXON ADDED – Assume full cmd of the Soviet forces
			SetObjectiveName(x.fnav, "Meet CCA Forces")
			x.allymeet = 2
		end
		for index = 1, 4 do
			SetSkill(x.ftnk[index], x.skillsetting)
			Patrol(x.ftnk[index], ("fnav%d"):format(x.allycase), 0)
		end
		SetObjectiveOn(x.fnav)
	end

	--Allied Forces met, set to player team
	if x.allymeet ~= 0 and GetDistance(x.player, ("fnav%d"):format(x.allycase)) < 100 then
		for index = 1, 4 do
			if IsAlive(x.ftnk[index]) then
				TCC.SetTeamNum(x.ftnk[index], 1)
				SetGroup(x.ftnk[index], 9)
			end
		end
		SetObjectiveOff(x.fnav)
		RemoveObject(x.fnav)
		if x.allymeet == 1 then
			AudioMessage("tcss1418.wav") --Good to see you grizzly 1 (NE rendezvous)
		else
			AudioMessage("tcss1403.wav") --My comrades await your oders (soviet)
		end
		x.allycase = x.allycase + 1 --KEEP HERE! for audio and next round
		if x.allycase > 4 then
			x.allycase = 1 --RESET THE WHOLE ALLY THING
		end
		x.allymeet = 0
		x.allyTime = GetTime() + 300.0
	end

	--Tartarus destroyed (keep before main tart stuff) --gonna regret that
	if x.tartcount == 0 and x.tartstate < 666 and not IsAlive(x.tart) then
		x.tarttime = GetTime()
		x.tartstate = 666
	end
	
	--Initial check for tatarus
	if x.tartstate == 0 and GetDistance(x.player, x.tart) < 350 then
		AudioMessage("tcss1413.wav") --Pt1 - Buzz - Uh Cmd. Don't mess with that.
		AudioMessage("tcss1414.wav") --Pt2 - GenC - My thoughts exactly Crpl. Cmd stay clear.
		x.tarttime = GetTime() + 90.0
		x.tartstate = x.tartstate + 1
	--Too close to tartarus, send attack
	elseif x.tartstate == 1 and (x.tarttime < GetTime()) and IsAlive(x.tart) and (GetDistance(x.player, x.tart) < 190) then --Deal w/ it. :)
		x.tartatk[1] = BuildObject("yvrckt", 5, GetPositionNear("epgtart", 0, 16, 32))
		x.tartatk[2] = BuildObject("yvmisl", 5, GetPositionNear("epgtart", 0, 16, 32))
		x.tartatk[3] = BuildObject("yvartl", 5, GetPositionNear("epgtart", 0, 16, 32))
		x.tartatk[4] = BuildObject("yvmbike", 5, GetPositionNear("epgtart", 0, 16, 32))
		for index = 1, 4 do
			SetEjectRatio(x.tartatk[index], 0.0)
			SetSkill(x.tartatk[index], x.skillsetting)
			Attack(x.tartatk[index], x.frcy)
		end
		Attack(x.tartatk[4], x.player)
		AudioMessage("tcss1404.wav") --They're all over the place Cmd.
		x.tarttime = GetTime() + 180.0
	--Good luck
	elseif x.tartstate == 666 and x.tartcount < 8 and x.tarttime < GetTime() then
		x.tartcount = x.tartcount + 1
		x.tartatk[x.tartcount] = BuildObject("yvrckt", 5, GetPositionNear("epgtart", 0, 16, 32))
		SetEjectRatio(x.tartatk[x.tartcount], 0.0)
		SetSkill(x.tartatk[x.tartcount], x.skillsetting)
		Attack(x.tartatk[x.tartcount], x.frcy)
		if x.tartcount == 1 then
			AudioMessage("tcss1404.wav") --They're all over the place Cmd.
		end
		if x.tartcount == 8 then
			x.tartstate = 777
		end
		x.tarttime = GetTime() + 2.0
	end

	--Confirm 3 silos once 
	if x.silothree == 1 then --assigned in ADDOBJECT function at top
		AudioMessage("woohoowin.wav") --woohoo
		AudioMessage("tcss1417.wav") --TY corporeal, lets get on with mission
		ClearObjectives()
		AddObjective("tcss1402.txt", "GREEN")
		AddObjective("tcss1403.txt")
		x.siloposttime = GetTime() + 3.0
		x.silothree = 2
	end

	--Silos built so turn on looker for bankable amount of scrap
	if x.siloposttime < GetTime() then
		ClearObjectives()
		AddObjective("tcss1403.txt")
		x.siloposttime = 99999.9
	end

	--Check for bankable scrap
	if (x.banknote == 7 and GetScrap(1) >= 50) or (x.banknote ~= 8 and GetScrap(1) >= 100) then
		SetScrap(1, 0)
		x.banknote = x.banknote + 1 --do up here
		x.bankscrap = true
	end

	--Call out scrap banked
	if x.bankscrap then
		ClearObjectives()
		AddObjective("tcss1403.txt")
		AudioMessage("armor_up.wav") --hum armored sfx
		if x.banknote == 1 then
			AddObjective("tcss1404.txt", "ALLYBLUE")
		elseif x.banknote == 2 then
			AddObjective("tcss1405.txt", "ALLYBLUE")
		elseif x.banknote == 3 then
			AddObjective("tcss1406.txt", "ALLYBLUE")
		elseif x.banknote == 4 then
			AddObjective("tcss1407.txt", "ALLYBLUE")
			AudioMessage("tcss1405.wav") --40 scrap collected. We should be out soon.
		elseif x.banknote == 5 then
			AddObjective("tcss1408.txt", "ALLYBLUE")
		elseif x.banknote == 6 then
			AddObjective("tcss1409.txt", "ALLYBLUE")
			AudioMessage("tcss1407.wav") --Almost got enough scrap. Stupid vacuum heads. Make scav faster.
		elseif x.banknote == 7 then
			AddObjective("tcss1410.txt", "ALLYBLUE")
		elseif x.banknote == 8 then
			AudioMessage("woohoowin.wav") --woohoo
			AddObjective("tcss1411.txt", "GREEN")
			x.wintime = GetTime() + 4.0
			x.winner = true
		end
		x.bankscrap = false
	end

	--UBA WIENER
	if x.winner and x.wintime < GetTime() then
		AudioMessage("tcss1410.wav") --SUCCEED -	Take battle back at thex.
		ClearObjectives()
		AddObjective("tcss1417.txt", "GREEN") --
		TCC.SucceedMission(GetTime() + 7.0, "tcss14w1.des")
		x.MCAcheck = true
		x.wintime = 99999.9
		x.winner = false
	end

	--FURY GROUP SCOUT PATROLS ----------------------------------
	if x.epattime < GetTime() then
		for index = 1, x.epatlength do
			if not IsAlive(x.epat[index]) and not x.epatallow[index] then
				x.epatcool[index] = GetTime() + 240.0
				x.epatallow[index] = true
			end
			if x.epatallow[index] and x.epatcool[index] < GetTime() then
				if not IsAlive(x.epat[index]) then
					x.epat[index] = BuildObject("yvartl", 5, ("ppatrol%d"):format(index))
					SetEjectRatio(x.epat[index], 0.0)
					SetSkill(x.epat[index], x.skillsetting)
					Patrol(x.epat[index], ("ppatrol%d"):format(index))
					--SetObjectiveName(x.epat[index], ("Patrol %d"):format(index))
					x.epatallow[index] = false
				end
			end
		end
		x.epattime = GetTime() + 30.0
	end
	
	--AI GROUP TURRET GENERIC
	if x.eturtime < GetTime() then
		for index = 1, x.eturlength do
			if not IsAlive(x.etur[index]) and not x.eturallow[index] and x.eturlife[index] < 3 then
				x.eturcool[index] = GetTime() + 180.0
				x.eturallow[index] = true
			end
			if x.eturallow[index] and x.eturcool[index] < GetTime() then
				if index%2 == 0 then
					x.etur[index] = BuildObject("yvturr", 5, "epmeet2")
				else
					x.etur[index] = BuildObject("yvturr", 5, "epmeet1")
				end
				SetEjectRatio(x.etur[index], 0.0)
				SetSkill(x.etur[index], x.skillsetting)
				--SetObjectiveName(x.etur[index], ("Adder %d"):format(index))
				Goto(x.etur[index], ("eptur%d"):format(index))
				x.eturallow[index] = false
				x.eturlife[index] = x.eturlife[index] + 1
			end
		end
		x.eturtime = GetTime() + 30.0
	end
	
	--WARCODE --SPECIAL SS14 - NO STAGE LOCATION MEET
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
						---x.ewarsize[index] = 3
						if index == 1 then
							x.ewarsize[index] = 2
						else
							x.ewarsize[index] = 2
						end
					elseif x.ewarwave[index] == 2 then
						if index == 1 then
							x.ewarsize[index] = 4
						else
							x.ewarsize[index] = 3
						end
					elseif x.ewarwave[index] == 3 then
						if index == 1 then
							x.ewarsize[index] = 6
						else
							x.ewarsize[index] = 4
						end
					elseif x.ewarwave[index] == 4 then
						if index == 1 then
							x.ewarsize[index] = 8
						else
							x.ewarsize[index] = 6
						end 
					else --5
						if index == 1 then
							x.ewarsize[index] = 10
						else
							x.ewarsize[index] = 8
						end 
					end
					--SPECIAL BUILD LOCATION PICK
					while x.randompick == x.randomlast do --random the random
						x.randompick = math.floor(GetRandomFloat(1.0, 8.0))
					end
					x.randomlast = x.randompick
					if x.randompick % 2 ~= 0 then
						x.point = 1
					else
						x.point = 2
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
							x.ewarrior[index][index2] = BuildObject("yvscout", 5, GetPositionNear((("epmeet%d"):format(x.point)), 0, 16, 32))
						elseif x.randompick == 2 or x.randompick == 9 or x.randompick == 16 then
							x.ewarrior[index][index2] = BuildObject("yvmbike", 5, GetPositionNear((("epmeet%d"):format(x.point)), 0, 16, 32))
						elseif x.randompick == 3 or x.randompick == 10 or x.randompick == 17 then
							x.ewarrior[index][index2] = BuildObject("yvmisl", 5, GetPositionNear((("epmeet%d"):format(x.point)), 0, 16, 32))
						elseif x.randompick == 4 or x.randompick == 11 or x.randompick == 18 then
							x.ewarrior[index][index2] = BuildObject("yvrckt", 5, GetPositionNear((("epmeet%d"):format(x.point)), 0, 16, 32))
						else
							x.ewarrior[index][index2] = BuildObject("yvartl", 5, GetPositionNear((("epmeet%d"):format(x.point)), 0, 16, 32))
						end
						SetEjectRatio(x.ewarrior[index][index2], 0.0)
						SetSkill(x.ewarrior[index][index2], x.skillsetting)
						if index2 % 3 == 0 then
							SetSkill(x.ewarrior[index][index2], x.skillsetting+1)
						end
					end
					x.ewarabort[index] = GetTime() + 360.0 --here first in case stage goes wrong
					x.ewarstate[index] = x.ewarstate[index] + 1
				end
				--NO MEET AT STAGE LOCATION
				--GIVE ATTACK ORDER
				if x.ewarstate[index] == 3 then
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
				if x.ewarstate[index] == 4 then
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

	--CHECK STATUS OF MCA ----------------------------------
	if not x.MCAcheck and not IsAlive(x.frcy) then --frecy killed
		x.silothree = 2
		AudioMessage("tcss1409.wav") --FAIL - Recy Texas lost 
		ClearObjectives()
		AddObjective("tcss1415.txt", "RED") --Texas lost mission failed
		TCC.FailMission(GetTime() + 12.0, "tcss14f2.des") --LOSER LOSER LOSER
		x.spine = 666
		x.MCAcheck = true
	end
end
--[[END OF SCRIPT]]