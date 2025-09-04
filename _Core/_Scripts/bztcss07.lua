--bztcss07 - Battlezone Total Command - Stars and Stripes - 7/17 - A NASTY SURPRISE
assert(load(assert(LoadFile("_requirefix.lua")),"_requirefix.lua"))();
TCC = require("TC_Core")
MisnNum = 11;
--DECLARE variables --p-path, f-friend, e-enemy, atk-attack, rcy-recycler
local index = 0
local index2 = 0
local indexadd = 0
local x = {
	FIRST = true,	
	foldmehere = false, 
	MCAcheck = false, 
	player = nil, 
	mytank = nil, 
	skillsetting = 0,
	easy = 0, 
	medium = 1, 
	hard = 2,	
	audio1 = nil, 
	audio2 = nil, 
	fnav = nil, 
	waittime = 99999.9, 
	pos = {},	
	spine = 0,	
	casualty = 0, 
	camstate = 0, 
  camfov = 60,  --185 default
	userfov = 90,  --seed
	randompick = 0, 
	randomlast = 0, 
	weappick = 0, --weapon random choice
	weaplast = 0, 
	repel1 = nil, 
	repel2 = nil, 
	repel3 = nil, 
	efacreset = false, 
	sendattacks = false, 
	ewlke = nil, --golem stuff
	ewlkw = nil,
	ewlkaliveeast = false, 
	ewlkalivewest = false,
	etnk = {},	
	ewlkmet = false, 
	ccakilled = false, 
	alldone = false, 
	efactime = 99999.9, 
	calltime = 99999.9, 
	ercy = nil, 
	efac = nil, 
	relfound = false, --relic stuff
	relfoundother = false, 
	relfoundstyx = false, 
	hcere = nil, 
	freestuff = {}, 
	freestuffstate = {}, 
	fally = {}, 
	pool = nil, 
	frcy = nil, 
	ffac = nil, 
	farm = nil, 
	fcon = nil, 
	fcom = nil, 
	fbay = nil, 
	ftrn = nil, 
	ftec = nil, 
	fhqr = nil, 
	fsld = nil, 
	fpwr = {nil, nil, nil, nil}, 
	eturtime = 99999.9, --eturret
	eturlength = 18,
	etur = {}, 
	eturlife = {}, 
	eturcool = {}, 
	eturallow = {}, 
	etursecs = {}, 
	etursecsadd = {}, 
	epattime = 99999.9, --epatrols
	epatlength = 4, 
	epat = {}, 
  epatlife = {}, 
	epatcool = {}, 
	epatallow = {},	
	epatsecs = {}, 
	escv = {}, --scav stuff
	escvlength = 2, 
	wreckbank = false, --have 2
	escvbuildtime = {}, 
	escvstate = {}, 
	fartlength = 10, --fart killers
	fart = {}, 
	ekillarttime = 99999.9,
	ekillartlength = 4, 
	ekillart = {}, 
  ekillartlife = {}, 
	ekillartcool = {}, 
	ekillartallow = {}, 
	ekillarttarget = nil, 
	ekillartmarch = false, 
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
	LAST = true
}
--PATHS: pmytank, fprcy, fpcon, eprcy, epfac, eptur0-17, epgrcy, epgfac, fpnav1-3, ppatrol1-4, prepel1-3, stage1-2

function InitialSetup()
	SetAutoGroupUnits(true)
	
	local odfpreload = {
		"avrecyss07", "abrecyss07", "avfactss07", "avarmoss07", "avconsss07", "avtank", "avturr", "abpgen1", "abcbun", "abgtow", 
		"svwalk", "svturr", "dummy00", "hadpgenprop", "hadgtowss07a", "hadgtowss07b", "hadcbun", "hadpgen", "apcamra"
	}
	for k,v in pairs(odfpreload) do
		PreloadODF(v)
	end
	
	x.mytank = GetHandle("mytank")
	x.frcy = GetHandle("frcy")
	for index = 1, 10 do
		x.fally[index] = GetHandle(("fally%d"):format(index))
	end
	--x.pool = GetHandle("pool4")
	x.ercy = GetHandle("ercy")
	x.efac = GetHandle("efac")
	x.earm = GetHandle("earm")
	x.hcere = GetHandle("hcere")
	x.freestuff[1] = GetHandle("hart1") --well crap, need unique odf for ID scan
	x.freestuff[2] = GetHandle("hart2")
	x.freestuff[3] = GetHandle("hart3")
	x.freestuff[4] = GetHandle("hpwr")
	x.freestuff[5] = GetHandle("hgun1")
	x.freestuff[6] = GetHandle("hgun2")
	x.freestuff[7] = GetHandle("hcom")  
	x.etnk[1] = GetHandle("etnk1")
	x.etnk[2] = GetHandle("etnk2")
	Ally(1, 4)
	Ally(4, 1)
	--SetTeamColor(4, 125, 50, 0)
	SetTeamColor(4, 50, 150, 255) --eldridge 6th Plt	SAME AS SS04
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
	if (not IsAlive(x.farm) or x.farm == nil) and (IsOdf(h, "avarmoss07:1") or IsOdf(h, "abarmoss07")) then
		x.farm = h
	elseif (not IsAlive(x.ffac) or x.ffac == nil) and (IsOdf(h, "avfactss07:1") or IsOdf(h, "abfactss07")) then
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
	elseif IsOdf(h, "abpgen1") then
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
		x.pos = GetTransform(x.mytank)
		RemoveObject(x.mytank)
		x.mytank = BuildObject("avtank", 1, x.pos) --"pmytank")
		SetAsUser(x.mytank, 1)
		RemoveObject(x.player)
		x.player = GetPlayerHandle()
		x.pos = GetTransform(x.frcy)
		RemoveObject(x.frcy)
		x.frcy = BuildObject("avrecyss07", 1, x.pos) 
		x.pos = GetTransform(x.fally[1])
		RemoveObject(x.fally[1])
		x.fally[1] = BuildObject("avconsss07", 1, x.pos)
		x.pos = GetTransform(x.fally[2])
		RemoveObject(x.fally[2])
		x.fally[2] = BuildObject("avscav", 1, x.pos)
		x.pos = GetTransform(x.fally[3])
		RemoveObject(x.fally[3])
		x.fally[3] = BuildObject("avscav", 1, x.pos)
		x.pos = GetTransform(x.fally[4])
		RemoveObject(x.fally[4])
		if x.skillsetting >= x.medium then
			x.fally[4] = BuildObject("avturr", 1, x.pos)
		end
		x.pos = GetTransform(x.fally[5])
		RemoveObject(x.fally[5])
		if x.skillsetting == x.hard then
			x.fally[5] = BuildObject("avturr", 1, x.pos)
		end
		x.pos = GetTransform(x.fally[6])
		RemoveObject(x.fally[6])
		x.fally[6] = BuildObject("abrecyss07", 4, x.pos) 
		x.pos = GetTransform(x.fally[7])
		RemoveObject(x.fally[7])
		x.fally[7] = BuildObject("abpgen1", 4, x.pos)
		x.pos = GetTransform(x.fally[8])
		RemoveObject(x.fally[8])
		x.fally[8] = BuildObject("abpgen1", 4, x.pos) --still need camera object ("abcbun", 4, x.pos) --shows too much of enemy base
		x.pos = GetTransform(x.fally[9])
		RemoveObject(x.fally[9])
		x.fally[9] = BuildObject("abgtow", 4, x.pos)
		x.pos = GetTransform(x.fally[10])
		RemoveObject(x.fally[10])
		x.fally[10] = BuildObject("dummy00", 0, x.pos)
		x.fnav = BuildObject("apcamra", 1, "fpnav1")
		SetObjectiveName(x.fnav, "Deploy Zone")
		x.fnav = BuildObject("apcamra", 1, "fpnav2")
		SetObjectiveName(x.fnav, "CCA Base")
		x.fnav = BuildObject("apcamra", 1, "fpnav3")
		SetObjectiveName(x.fnav, "Colorado Base")
		--[[for index = 1, x.eturlength do
			x.etur[index] = BuildObject("svturr", 5, ("eptur%d"):format(index))
			SetSkill(x.etur[index], x.skillsetting)
			SetObjectiveName(x.etur[index], ("Turret %d"):format(index))
		end--]]
		for index = 1, x.eturlength do --init tur
			x.eturlength = 18 --just keepin it contained
			x.eturtime = GetTime()
			x.eturcool[index] = GetTime()
			x.eturallow[index] = true
			x.eturlife[index] = 0
			x.etursecs[index] = 0.0
			x.etursecsadd[index] = 0.0
		end
		for index = 1, 7 do
			x.freestuffstate[index] = 0
		end
		x.repel1 = BuildObject("repelenemy400", 5, "prepel1")
		x.repel2 = BuildObject("repelenemy400", 5, "prepel2")
		x.repel3 = BuildObject("repelenemy400", 5, "prepel3")
		SetScrap(1, 40)
		x.spine = x.spine + 1
		x.waittime = GetTime() + 2.0
	end

	--1ST AUDIO MESSAGE
	if x.spine == 1 and x.waittime < GetTime() then
		x.audio1 = AudioMessage("tcss0700.wav") --INTRO - U in N. eld in W w/COL. apc atk nav 3. CCA nav 2. NAV1??		
		x.spine = x.spine + 1
	end

	--1ST OBJECTIVE
	if x.spine == 2 and IsAudioMessageDone(x.audio1) then
		ClearObjectives()
		AddObjective("tcss0700.txt")
		x.spine = x.spine + 1
	end

	--LET PLAYER DEPLOY RECYCLER BEFORE CONTINUING
	if x.spine == 3 and IsOdf(x.frcy, "abrecyss07") then
		x.waittime = GetTime() + 20.0
		x.spine = x.spine + 1
	end

	--MESSAGE --Uh, Justic, this is eldrg. Mod fghtr resist. Do CCA know here?
	if x.spine == 4 and x.waittime < GetTime() then
		AudioMessage("tcss0717.wav") --Uh, Justice, this is x.eldrg. Mod fghtr resist. Do CCA know here?
		x.waittime = GetTime() + 25.0
		x.spine = x.spine + 1
	end
	
	--START COLORADO ATTACK
	if x.spine == 5 and x.waittime < GetTime() then
		for index = 1, 2 do
			x.pos = GetTransform(x.etnk[index])
			RemoveObject(x.etnk[index])
			x.etnk[index] = BuildObject("svwalk", 5, x.pos)
			Attack(x.etnk[index], x.fally[6])
		end
		SetCurHealth(x.fally[6], math.floor(GetMaxHealth(x.fally[6]) * 0.85)) --make it go quicker
		SetCurHealth(x.fally[9], math.floor(GetMaxHealth(x.fally[9]) * 0.85))
		x.waittime = GetTime() + 10.0
		x.spine = x.spine + 1
	end

	--CAMERA READY - MESSAGE --eld - Justice we under attack
	if x.spine == 6 and x.waittime < GetTime() then
		AudioMessage("tcss0701.wav") --eld - Justice, we under attack
		AudioMessage("tcss0703.wav") --Colorado, restate last message.
		RemoveObject(x.fnav)
		x.camstate = 1
    x.userfov = IFace_GetInteger("options.graphics.defaultfov")
    CameraReady()
    IFace_SetInteger("options.graphics.defaultfov", x.camfov)
		x.waittime = GetTime() + 20.0
		x.spine = x.spine + 1
	end

	--MESSAGE --eld - Under attack by ship of unkown config
	if x.spine == 7 and x.waittime < GetTime() then
		AudioMessage("tcss0702.wav") --eld - Under attack by ship of unkown config
		x.spine = x.spine + 1
	end
	
	--RELOAD GOLEMS
	if x.spine == 8 and not IsAlive(x.fally[9]) then
		SetCurAmmo(x.etnk[1], GetMaxAmmo(x.etnk[1]))
		SetCurAmmo(x.etnk[2], GetMaxAmmo(x.etnk[2]))
		x.spine = x.spine + 1
	end

	--MESSAGE --Static, aaarrgghh
	if x.spine == 9 and (not IsAlive(x.fally[6]) or GetCurHealth(x.fally[6]) < math.floor(GetMaxHealth(x.fally[6]) * 0.1)) then
		AudioMessage("tcss0704.wav") --Static, aaarrgghh
		x.spine = x.spine + 1
	end
	
	--CAMERA FINISH - ELD RECY DEAD
	if x.spine == 10 and not IsAlive(x.fally[6]) then
		x.camstate = 0
    CameraFinish()
    IFace_SetInteger("options.graphics.defaultfov", x.userfov)
		for index = 6, 10 do
			Damage(x.fally[index], 20000)
		end
		RemoveObject(x.etnk[1])
		RemoveObject(x.etnk[2])
		x.waittime = GetTime() + 10.0
		x.spine = x.spine + 1
	end

	--MESSAGE --Grz1, Col lost. Standby for Skyeye recon
	if x.spine == 11 and x.waittime < GetTime() then
		AudioMessage("tcss0705.wav") --Grz1, Col lost. Standby for Skyeye recon
		x.waittime = GetTime() + 30.0
		x.spine = x.spine + 1
	end

	--MESSAGE --Griz1, Colo dead. U on own. Amass force and atk CCA base.
	if x.spine == 12 and x.waittime < GetTime() then
		AudioMessage("tcss0710.wav") --Griz1, Colo dead. U on own. Amass force and atk CCA base.
		ClearObjectives()
		AddObjective("tcss0701.txt")
		for index = 1, x.epatlength do --init epat
			x.epattime = GetTime() --just keep it here
			x.epatcool[index] = GetTime()
			x.epatallow[index] = true
			x.epatsecs[index] = 0.0
			x.epatlife[index] = 0
		end
		x.waittime = GetTime() + 20.0
		x.spine = x.spine + 1
	end

	--MESSAGE --I'm picking up something big
	if x.spine == 13 and x.waittime < GetTime() then
		AudioMessage("tcss0706.wav") --I'm picking up something big
		x.waittime = GetTime() + 30.0
		x.spine = x.spine + 1
	end

	--PICK WHICH WALKER GETS BUILT FIRST & remove x.repel1-3
	if x.spine == 14 and x.waittime < GetTime() then
		if GetDistance(x.player, "stage1") <= (GetDistance(x.player, "stage2")-150) then
			AudioMessage("tcss0709.wav") --OPT B1 - Skyeye is picking up unID obj to East.
			x.ewlke = BuildObject("svwalk", 5, "stage1")
			SetSkill(x.ewlke, x.skillsetting)
			SetObjectiveName(x.ewlke, "Unknown Alpha")
			SetObjectiveOn(x.ewlke)
			Attack(x.ewlke, x.frcy)
			x.ewlkaliveeast = true
		else
			AudioMessage("tcss0708.wav") --OPT A1 - Skyeye is picking up unID obj to West.
			x.ewlkw = BuildObject("svwalk", 5, "stage2")
			SetSkill(x.ewlkw, x.skillsetting)
			SetObjectiveName(x.ewlkw, "Unknown Alpha")
			SetObjectiveOn(x.ewlkw)
			Attack(x.ewlkw, x.frcy)
			x.ewlkalivewest = true
		end
		RemoveObject(x.repel1)
		RemoveObject(x.repel2)
		RemoveObject(x.repel3)
		x.waittime = GetTime() + 10.0
		x.spine = x.spine + 1
	end

	--MESSAGE --Cmd, Skyeye can't match config with known CCA. Be cautious.
	if x.spine == 15 and x.waittime < GetTime() then
		AudioMessage("tcss0707.wav") --Cmd, Skyeye can't match config with known CCA. Be cautious.
		x.spine = x.spine + 1
	end

	--BUILD THE SECOND WALKER - START TIMERS AI ATTACKS
	if x.spine == 16 then
		if (IsAlive(x.ewlke) and GetDistance(x.ewlke, x.frcy) < 400) or (not IsAlive(x.ewlke) and x.ewlkaliveeast) then
			x.ewlkw = BuildObject("svwalk", 5, "stage2")
			SetSkill(x.ewlkw, x.skillsetting)
			SetObjectiveName(x.ewlkw, "Unknown Beta")
			SetObjectiveOn(x.ewlkw)
			Attack(x.ewlkw, x.frcy)
			AudioMessage("tcss0712.wav") --OPT B2 - I'm picking up another one to the West
			x.sendattacks = true
		end
		
		if (IsAlive(x.ewlkw) and GetDistance(x.ewlkw, x.frcy) < 400) or (not IsAlive(x.ewlkw) and x.ewlkalivewest) then
			x.ewlke = BuildObject("svwalk", 5, "stage1")
			SetSkill(x.ewlke, x.skillsetting)
			SetObjectiveName(x.ewlke, "Unknown Beta")
			SetObjectiveOn(x.ewlke)
			Attack(x.ewlke, x.frcy)
			AudioMessage("tcss0711.wav") --OPT A2 - I'm picking up another one to the East
			x.sendattacks = true
		end
		
		if x.sendattacks then
			x.eturtime = GetTime()
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
			for index = 1, x.ewartotal do --init WARCODE
				x.ewardeclare = true
				x.ewarrior[index] = {} --"rows"
				for index2 = 1, 10 do --10 per wave max avail
					x.ewarrior[index][index2] = nil --"columns", init (handle in this case)
				end
				x.ewartrgt[index] = nil
				x.ewarstate[index] = 1
				x.ewartime[1] = GetTime() + 60.0 --time for first attack
				x.ewartime[2] = GetTime() + 120.0
				x.ewartime[3] = GetTime() + 180.0
				x.ewartime[4] = GetTime() + 240.0
				x.ewartimecool[index] = 300.0
				x.ewartimeadd[index] = 0.0
				x.ewarabort[index] = 99999.9
				x.ewarabortallow[index] = false
				x.ewarsize[index] = 0
				x.ewarwave[index] = 0
				x.ewarwavemax[index] = 5
				x.ewarwavereset[index] = 2
				x.ewarmeet[index] = 2
			end
			x.spine = x.spine + 1
		end
	end
	----------END MAIN SPINE ----------
	
	--CAMERA COLORADO DESTROYED
	if x.camstate == 1 then
		CameraObject(x.fally[10], 0, 20, 15, x.etnk[1])
		SetCurHealth(x.etnk[1], GetMaxHealth(x.etnk[1]))
		SetCurHealth(x.etnk[2], GetMaxHealth(x.etnk[2]))
	end

	--HAS PLAYER OR TEAM HAD FIRST ENCOUNTER WITH A WALKER
	if not x.ewlkmet then
		x.player = GetPlayerHandle()
		if (IsAlive(x.ewlke) and (IsWithin(x.ewlke, x.player, 150) or IsWithin(x.ewlke, x.frcy, 250))) 
		or (IsAlive(x.ewlkw) and (IsWithin(x.ewlkw, x.player, 150) or IsWithin(x.ewlkw, x.frcy, 250))) then
			AudioMessage("tcss0716.wav") --Pull out Cmd. What the sam hill is that?
			x.ewlkmet = true
		end
		if not IsAlive(x.ewlke) and not IsAlive(x.ewlkw) and x.sendattacks then
			x.ewlkmet = true
		end
	end

	--PLAYER FOUND ARTIL FIRST TIME
	if not x.relfound and (
		(x.freestuffstate[1] == 0 and GetDistance(x.player, x.freestuff[1]) < 100) or 
		(x.freestuffstate[2] == 0 and GetDistance(x.player, x.freestuff[2]) < 100) or 
		(x.freestuffstate[3] == 0 and GetDistance(x.player, x.freestuff[3]) < 100))then
		AudioMessage("tcss0722.wav") --Cmd. We see what you C. Area has more. but take out CCA
		x.relfound = true
	end
	
	--PLAYER FOUND ARTIL FIRST BUT AFTER CCA DESTRUCTION
	if not x.relfoundstyx and not x.relfoundother and (
		(x.freestuffstate[1] == 0 and GetDistance(x.player, x.freestuff[1]) < 100) or 
		(x.freestuffstate[2] == 0 and GetDistance(x.player, x.freestuff[2]) < 100) or 
		(x.freestuffstate[3] == 0 and GetDistance(x.player, x.freestuff[3]) < 100)) and 
		(not IsAlive(x.ercy) and not IsAlive(x.efac)) then
		x.audio2 = AudioMessage("tcss0721.wav") --That's not it. They are larger. Continue searching.
		--AddObjective("	")
		--AddObjective("tcss0702.txt")
		x.relfoundother = true
	end
		
	--PLAYER FOUND CEREBUS
	if not x.relfoundstyx and GetDistance(x.player, x.hcere) < 150 then
		x.audio2 = AudioMessage("tcss0719.wav") --Grz1, you found Styx. Walking machine from ruins. Finish msn
		AddObjective("	")
		AddObjective("tcss0705.txt", "GREEN")
		x.relfoundstyx = true
	end

	--HAND OUT FREE STUFF TO THE CURIOUS
	if not x.foldmehere then
		if IsInfo("yvcatass07") and (x.freestuffstate[1] == 0 or x.freestuffstate[2] == 0 or x.freestuffstate[3] == 0) then
      if x.freestuffstate[1] == 0 and IsAlive(x.freestuff[1]) and GetDistance(x.player, x.freestuff[1]) < 200 then
				index = 1
			elseif x.freestuffstate[2] == 0 and IsAlive(x.freestuff[2]) and GetDistance(x.player, x.freestuff[2]) < 200 then
				index = 2
			elseif x.freestuffstate[3] == 0 and IsAlive(x.freestuff[3]) and GetDistance(x.player, x.freestuff[3]) < 200 then
				index = 3
			end
			if index > 0 then
				SetObjectiveName(x.freestuff[index], "Catapult art")
				SetTeamNum(x.freestuff[index], 1)
				SetGroup(x.freestuff[index], 9)
				SetSkill(x.freestuff[index], x.skillsetting)
				x.freestuffstate[index] = 1
			end
			index = 0
		end
		
		if IsInfo("hadpgenprop") and x.freestuffstate[4] == 0 then --pgen
			x.pos = GetTransform(x.freestuff[4], x.pos)
			RemoveObject(x.freestuff[4])
			x.freestuff[4] = BuildObject("hadpgen", 1, x.pos)
			x.freestuffstate[4] = 1
		end
		
		if IsInfo("hadgtowss07a") and x.freestuffstate[5] == 0 then --gtow1
			x.pos = GetTransform(x.freestuff[5], x.pos) --have to replace so that powercost is used
			RemoveObject(x.freestuff[5])
			x.freestuff[5] = BuildObject("hadgtow", 1, x.pos)
			x.freestuffstate[5] = 1
		end
		
		if IsInfo("hadgtowss07b") and x.freestuffstate[6] == 0 then --gtow2
			x.pos = GetTransform(x.freestuff[6], x.pos) --have to replace so that powercost is used
			RemoveObject(x.freestuff[6])
			x.freestuff[6] = BuildObject("hadgtow", 1, x.pos)
			x.freestuffstate[6] = 1
			x.freestuffstate[6] = 1
		end
		
		if IsInfo("hadcbun") and x.freestuffstate[7] == 0 then --cbun
			x.pos = GetTransform(x.freestuff[7], x.pos) --have to replace so that powercost is used
			RemoveObject(x.freestuff[7])
			x.freestuff[7] = BuildObject("hadcbun", 1, x.pos)
			x.freestuffstate[7] = 1
			x.freestuffstate[7] = 1
		end
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
						x.ewarsize[index] = 4  --3
					elseif x.ewarwave[index] == 3 then
						x.ewarsize[index] = 5  --4
					elseif x.ewarwave[index] == 4 then
						x.ewarsize[index] = 7  --5
					else --x.ewarwave[index] == 5 then
						x.ewarsize[index] = 8  --6
					end
					x.ewarstate[index] = x.ewarstate[index] + 1
				end
			
				--BUILD FORCE
				if x.ewarstate[index] == 2 then
					for index2 = 1, x.ewarsize[index] do
						while x.randompick == x.randomlast do --random the random
							x.randompick = math.floor(GetRandomFloat(1.0, 18.0)) --single 0-n inclusive, or double n1-nx inclusive
						end
						x.randomlast = x.randompick
						if not IsAlive(x.efac) then
							x.randompick = 1
						end
						if x.randompick == 1 or x.randompick == 7 or x.randompick == 13 then
							x.ewarrior[index][index2] = BuildObject("svscout", 5, GetPositionNear("epgrcy", 0, 16, 32)) --grpspwn
							if x.ewarwave[index] == 3 or x.ewarwave[index] == 4 then
								GiveWeapon(x.ewarrior[index][index2], "glasea_c")
							end
						elseif x.randompick == 2 or x.randompick == 8 or x.randompick == 14 then
							x.ewarrior[index][index2] = BuildObject("svmbike", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
							if x.ewarwave[index] == 2 or x.ewarwave[index] == 4 then
								GiveWeapon(x.ewarrior[index][index2], "gstbva_c")
							end
						elseif x.randompick == 3 or x.randompick == 9 or x.randompick == 15 then
							x.ewarrior[index][index2] = BuildObject("svmisl", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
							if x.ewarwave[index] == 3 or x.ewarwave[index] == 5 then
								GiveWeapon(x.ewarrior[index][index2], "gfafma_c")
							end
						elseif x.randompick == 4 or x.randompick == 10 or x.randompick == 16 then
							x.ewarrior[index][index2] = BuildObject("svtank", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
							if x.ewarwave[index] == 4 or x.ewarwave[index] == 5 then
								GiveWeapon(x.ewarrior[index][index2], "gstbsa_c")
							end
						elseif x.randompick == 5 or x.randompick == 11 or x.randompick == 17 then
							x.ewarrior[index][index2] = BuildObject("svrckt", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
							if x.ewarwave[index] == 3 or x.ewarwave[index] == 5 then
								GiveWeapon(x.ewarrior[index][index2], "gshdwa_a") --salvo rckt
							end
						else --6 12 18
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
							if not x.ewarabortallow[index] then
								x.ewarabort[index] = x.ewartime[index] + 420.0
								x.ewarabortallow[index] = true
							end
						end
						Attack(x.ewarrior[index][index2], x.ewartrgt[index])
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
						x.ewartimeadd[index] = x.ewartimeadd[index] + 10.0 --slow attacks so player has time for counterattack
						x.ewartime[index] = GetTime() + x.ewartimecool[index] + x.ewartimeadd[index]
						if x.ewarwave[index] == 5 then --extra time after last wave to "ease up"
							x.ewartime[index] = GetTime() + x.ewartimecool[index] + x.ewartimeadd[index] + 120.0
						end
						x.ewarabortallow[index] = false
						x.ewarstate[index] = 1 --RESET
					elseif not IsAlive(x.ewartrgt[index]) then --some alive and need new target
						x.ewarstate[index] = 5
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
	
	--AI GROUP TURRETS
	if x.eturtime < GetTime() and IsAlive(x.ercy) then
		for index = 1, x.eturlength do
			if not IsAlive(x.etur[index]) and not x.eturallow[index] and x.eturlife[index] < 3 then
				x.etursecs[index] = x.etursecs[index] + x.etursecsadd[index]
				x.eturcool[index] = GetTime() + 180.0 + x.etursecs[index]
				x.eturallow[index] = true
			end
			if x.eturallow[index] and x.eturcool[index] < GetTime() then
				x.etur[index] = BuildObject("svturr", 5, GetPositionNear("epgrcy", 0, 16, 32)) --grpspwn
				Goto(x.etur[index], ("eptur%d"):format(index))
				SetSkill(x.etur[index], x.skillsetting)
				--SetObjectiveName(x.etur[index], ("PAK %d"):format(index))
				x.eturlife[index] = x.eturlife[index] + 1
				x.etursecsadd[index] = x.etursecsadd[index] + 60.0
				x.eturallow[index] = false
			end
		end
	end

	--AI GROUP PATROLS --minute extension add
	if x.epattime < GetTime() and IsAlive(x.efac) then
		for index = 1, x.epatlength do
			if not IsAlive(x.epat[index]) and not x.epatallow[index] and x.epatlife[index] < 7 then
				x.epatsecs[index] = x.epatsecs[index] + 60.0
				x.epatcool[index] = GetTime() + 240.0 + x.epatsecs[index]
				x.epatallow[index] = true
			end
			if x.epatallow[index] and x.epatcool[index] < GetTime() then				
				while x.randompick == x.randomlast do --random the random
					x.randompick = math.floor(GetRandomFloat(1.0, 9.0))
				end
				x.randomlast = x.randompick
				if x.randompick == 1 or x.randompick == 4 or x.randompick == 7 then
					x.epat[index] = BuildObject("svscout", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
				elseif x.randompick == 2 or x.randompick == 5 or x.randompick == 8 then
					x.epat[index] = BuildObject("svmbike", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
				else
					x.epat[index] = BuildObject("svtank", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
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
				x.epatlife[index] = x.epatlife[index] + 1
				x.epatallow[index] = false
			end
		end
		x.epattime = GetTime() + 30.0
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

	--CCA REBUILD FACTORY
	if x.efactime < GetTime() then
		if not x.efacreset and IsAlive(x.ercy) and not IsAlive(x.efac) then
			x.efactime = GetTime() + 240.0
			x.efacreset = true
		end
		if x.efactime < GetTime() and not IsAlive(x.efac) and IsAlive(x.ercy) and (GetDistance(x.player, "epfac") > 300) then
			x.efac = BuildObject("sbfact", 5, "epfac")
			x.efacreset = false
		end
	end

	--CHECK STATUS OF MISSION-CRITICAL ASSETS (MCA then
	if not x.MCAcheck then
		if not IsAlive(x.frcy) then
			AudioMessage("tcss0723.wav") --FAIL - Utah lost.
			FailMission(GetTime() + 10.0, "tcss07f1.des") --LOSER LOSER LOSER
			x.spine = 666
			x.MCAcheck = true
		end
		
		if not x.ccakilled and not x.relfoundstyx and not IsAlive(x.ercy) and not IsAlive(x.efac) then
			x.calltime = GetTime() + 2.0
			x.ccakilled = true
		elseif x.ccakilled and x.calltime < GetTime() then
			ClearObjectives()
			AddObjective("tcss0703.txt", "GREEN")
			AddObjective("	")
			AddObjective("tcss0702.txt")
			AudioMessage("tcss0720.wav") --SUCCEED - Well done. Search ruins north of CCA base.
			x.calltime = 99999.9
		end
		
		if not x.alldone and x.relfoundstyx and not IsAlive(x.ercy) and not IsAlive(x.efac) then
			x.alldone = true
		end
		
		if x.alldone and IsAudioMessageDone(x.audio2) then
			ClearObjectives()
			AddObjective("tcss0703.txt", "GREEN")
			AddObjective("	")
			AddObjective("tcss0702.txt", "GREEN")
			AddObjective("	")
			AddObjective("tcss0704.txt", "GREEN")
			AudioMessage("tcss0718.wav") --SUCCEED - Well done, standby, CCA escape. We airlift U to them.
			AudioMessage("tcss0726.wav") --Corb - On it sir. Grz1, will relay coord to you now.
			SucceedMission(GetTime() + 24.0, "tcss07w1.des") --WINNER WINNER WINNER
			x.spine = 666
			x.MCAcheck = true
		end
	end
end
--[[END OF SCRIPT]]