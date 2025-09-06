--bztcrb08 - Battlezone Total Command - The Red Brigade - 8/8 - PUNISHING THE BLACK DOGS
assert(load(assert(LoadFile("_requirefix.lua")),"_requirefix.lua"))();
TCC = require("TC_Core")
MisnNum = 42;
--DECLARE variables --f-friend, e-enemy, atk-attack, rcy-recycler, etc...
local index = 0
local index2 = 0
local indexadd = 0
local indexadd2 = 0
local x = {
	FIRST = true,
	getiton = false, 
	MCAcheck = false, 
	player = nil, 
	mytank = nil, 
	skillsetting = 0,
	easy = 0, 
	medium = 1, 
	hard = 2,	
	pos = {}, 
	pos2 = {}, 
	waittime = 99999.9, 
	audio1 = nil, 
	audio2 = nil, 
	audio6 = nil, 
	audio7 = nil, 
	camfov = 60,  --185 default
	userfov = 90,  --seed
	cnslcmdvalue = 0, 
	camplay = 0, 
	camheight = 3000, 
	fscv = {}, 
	playfail = {0,0,0}, 
	spine = 0, 
	edrp = nil, 
	ercyprotect = false, --bds recy stuff
	ercytime = 99999.9,	
	savstate = 0, 
	savtime = 99999.9, 
	foundsav = false, 
	foundsav2 = false, 
	romtank = nil, --Romeski stuff
	romstate = 0, 
	romfree = false, 
	sav = {}, --sav rom guards
	hitbyplayerrom = 0, 
	hitbyplayerercy = 0, 
	hitbyplayersav1 = 0, 
	hitbyplayetime = 99999.9, 
	casualty = 0, 
	randompick = 0, 
	randomlast = 0, 
	ercyhp = 10000000,
	ercyhit = 0,
	ercy = nil, 
	efac = nil, 
	earm = nil, 
	ecom = nil, 
	ebay = nil, 
	etrn = nil, 
	etec = nil, 
	ehqr = nil, 
	esld = nil, 
	epwr = {}, 
	egun = {}, 
	frcy = nil, 
	ffac = nil, 
	farm = nil,	 
	ftnk = {}, 
	escv = {}, --escv stuff
	escvstate = {0, 0}, 
	escvbuildtime = {99999.9, 99999.9}, 
	eturtime = 99999.9, --eturret
	eturlength = 20,
	etur = {}, 
	eturlife = {}, 
	eturcool = {}, 
	eturallow = {}, 
	etursecs = {}, 
	etursecsadd = {}, 
	epattime = 99999.9, --patrol
	epatsecs = 0.0, 
	epatlength = 4, 
	epat = {}, 
	epatcool = {}, 
	epatallow = {}, 
	wreckstate = 0, --daywrecker stuff
	wrecktime = 99999.9, 
	wrecktrgt = {},
	wreckbomb = nil, 
	wreckname = "apdwrka", 
	wrecknotify = 0, 
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
--PATHS: promeski, epretreat, eprcy, epgrcy, epfac, epgfac, eppwr1-8, epcom, epbay, eptrn, eptec, ephqr, epsld, epgun1-13, epgun66, eptur1-20, ppatrol1-2, epmin1-2, stage1-2, epsavwait, epdef1-4

function InitialSetup()
	SetAutoGroupUnits(true)
	
	local odfpreload = {
		"svrecyrb08", "svrecyrb07", "svfactrb07", "svtank", "svhtnk", "bvdrop", "bbrecy_close", "bvturr", "apcamrs"
	}
	for k,v in pairs(odfpreload) do
		PreloadODF(v)
	end
	
	x.mytank = GetHandle("mytank")
	x.edrp = GetHandle("edrp")
	x.frcy = GetHandle("frcy")
	x.ffac = GetHandle("ffac")
	x.ftnk[1] = GetHandle("ftnk1")
	x.ftnk[2] = GetHandle("ftnk2")
	x.ercy = GetHandle("ercy")
	x.efac = GetHandle("efac")
	x.earm = GetHandle("earm")
	x.ecom = GetHandle("ecom")
	x.ebay = GetHandle("ebay")
	x.etrn = GetHandle("etrn")
	x.etec = GetHandle("etec")
	x.ehqr = GetHandle("ehqr")
	x.esld = GetHandle("esld")
	for index = 1, 8 do 
		x.epwr[index] = GetHandle(("epwr%d"):format(index))
	end
	for index = 3, 8 do
		x.escv[index] = GetHandle(("escv%d"):format(index))
	end
	Ally(1, 4) --don't let 1 AI attack 4
	Ally(4, 1) --4	bds recy 
	Ally(5, 4) --don't have AI in-fight
	Ally(4, 5)
	Ally(1, 2)
	Ally(2, 1) --2 Romeski
	Ally(2, 3) 
	Ally(2, 5) --romeski won't distract by 5
	Ally(3, 2) --3 romeski Fury guard
	Ally(3, 5) --fury won't distract by 5
	Ally(1, 3)
	Ally(3, 1)
	Ally(3, 4) --no fury atk ercy
	Ally(4, 3)
	Ally(4, 8)
	Ally(8, 4) --8 seperate endpoint bds enemy
	Ally(5, 8)
	Ally(8, 5)
	Ally(6, 7)
	Ally(7, 6)
	SetTeamColor(2, 100, 150, 200)
	SetTeamColor(3, 10, 20, 60)  
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
	TCC.Load(coreData);

	if x.romstate == 1 then
		UnAlly(3, 2)
	end
	if x.romstate >= 2 and x.romstate <= 3 then
		Ally(3, 2)
	end
	if x.romstate >= 4 then
		Ally(3, 4)
		UnAlly(1, 3)
		UnAlly(3, 1)
		UnAlly(3, 2)
		UnAlly(2, 3)
		UnAlly(1, 4)
		UnAlly(4, 1)
	end
	if x.romstate == 100 then
		Ally(1, 3)
		Ally(2, 3)
		Ally(3, 1)
		Ally(3, 2)
	end
	if x.spine >= 9 then
	UnAlly(6, 7)
		UnAlly(7, 6)
	end
end

function PostTargetChangedCallback(Craft, PreviousTarget, CurrentTarget)
	TCC.PostTargetChangedCallback(Craft, PreviousTarget, CurrentTarget);
end

function AddObject(h)  
	--FIND CCA SAV
	if IsOdf(h, "svhtnk:1") and x.savtime > GetTime() and x.savstate == 0 then
		x.foundsav = false
		x.foundsav2 = false
		for indexadd = 1, 6 do
			if not x.foundsav and (x.sav[indexadd] == nil or not IsAlive(x.sav[indexadd])) then
				for indexadd2 = 1, 6 do
					if not x.foundsav2 and h ~= x.sav[indexadd2] then
						x.sav[indexadd] = h
						x.foundsav = true
						x.foundsav2 = true
						SetLabel(x.sav[indexadd], ("sav %d"):format(indexadd))
					end
				end
			end
		end
	elseif x.savtime < GetTime() then
		x.savstate = 1
		x.savtime = 99999.9
	end
	
	--Get 1st player extractor to trig TAR
	if (not IsAlive(x.fscv[1]) or x.fscv == nil) and IsOdf(h, "sbscav") then
		if GetTeamNum(h) == 1 then --not necessary but would be useful for multi-teams
			x.fscv[1] = h
		end
	end
	
	if (not IsAlive(x.farm) or x.farm == nil) and (IsOdf(h, "svarmo:1") or IsOdf(h, "sbarmo")) then
		x.farm = h
	elseif (not IsAlive(x.ffac) or x.ffac == nil) and (IsOdf(h, "svfact:1") or IsOdf(h, "sbfact")) then
		x.ffac = h
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
		for index = 1, 4 do
			if x.fpwr[index] == nil or not IsAlive(x.fpwr[index]) then
				x.fpwr[index] = h
				break
			end
		end
	end
	
	for indexadd = 1, x.fartlength do --new artillery? 
		if (not IsAlive(x.fart[indexadd]) or x.fart[indexadd] == nil) and IsOdf(h, "svartl:1") then
			x.fart[indexadd] = h
		end
	end
	
	--get daywrecker for highlight
	if (not IsAlive(x.wreckbomb) or x.wreckbomb == nil) and IsOdf(h, x.wreckname) then
		if GetTeamNum(h) == 5 then
			x.wreckbomb = h --get handle to launched daywrecker
		end
	end
	TCC.AddObject(h);
end

-- [MC] Only Fury bolt buddies on player team can deal any meaningful damage.
function PreOrdnanceHit(shooterHandle, victimHandle,  OrdnanceTeam, OrdnanceODF)
	if (x.spine <= 3) then
		
		if (OrdnanceTeam == GetTeamNum(x.player) and victimHandle == x.ercy) then

			if (OrdnanceODF == "obolta_a.odf") then
				Damage(victimHandle, shooterHandle, GetMaxHealth(x.ercy) * 0.05);
				if (x.ercyhit < 20) then 
					x.ercyhit = 0;
				end
			else
				if (x.ercyhit < 20) then 
					x.ercyhit = x.ercyhit + 1;
				elseif (x.ercyhit == 20) then
					AddObjective("\nThe Recycler appears to be shielded by a powerful energy field. \nYou'll need the Fury's Bolt Buddy weaponry to damage it.", "CYAN");
					x.ercyhit = 21;
				end
			end
		end
	end
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
	TCC.Update()

	-- Make recycler effectively invulnerable unless fury is attacking
	if (x.FIRST) then
		
		if (x.ercy) then -- swap the health values
			local hp = GetMaxHealth(x.ercy);
			SetMaxHealth(x.ercy, x.ercyhp);
			SetCurHealth(x.ercy, x.ercyhp);
			PrintConsoleMessage("Recycler new HP: "..GetMaxHealth(x.ercy));
			x.ercyhp = hp;
			x.FIRST = false;
		end
	end

	--START THE MISSION BASICS
	if x.spine == 0 then
		x.pos = GetTransform(x.mytank)
		RemoveObject(x.mytank)
		x.mytank = BuildObject("svtank", 1, x.pos)
		x.pos2 = GetTransform(x.edrp)
		RemoveObject(x.edrp)
		SetAsUser(x.mytank, 1)
		RemoveObject(x.player)
		x.player = GetPlayerHandle()
		x.pos = GetTransform(x.frcy)
		RemoveObject(x.frcy)
		x.frcy = BuildObject("svrecyrb08", 1, x.pos)
		SetGroup(x.frcy, 0)
		x.pos = GetTransform(x.ffac)
		RemoveObject(x.ffac)
		x.ffac = BuildObject("svfact", 1, x.pos)
		SetGroup(x.ffac, 1)
		for index = 1, 2 do
			x.pos = GetTransform(x.ftnk[index])
			RemoveObject(x.ftnk[index])
			x.ftnk[index] = BuildObject("svtank", 1, x.pos)
			SetGroup(x.ftnk[index], 2)
			SetSkill(x.ftnk[index], 2)
		end
		x.epattime = GetTime() + 180.0
		for index = 1, x.epatlength do --init epat
			x.epatcool[index] = GetTime()
			x.epatallow[index] = true
		end
		for index = 1, x.eturlength do --init tur
			x.eturtime = GetTime()
			x.eturcool[index] = GetTime()
			x.eturallow[index] = true
			x.eturlife[index] = 0
			x.etursecs[index] = 0.0
			x.etursecsadd[index] = 0.0
		end
		for index = 1, 12 do --13 avail
			x.egun[index] = BuildObject("bbgtow", 5, ("epgun%d"):format(index))
			SetSkill(x.egun[index], x.skillsetting)
		end--]]
		SetScrap(1, 40)
		x.audio1 = AudioMessage("tcrb0800.wav") --INTRO - wonder if missing. Rid ourselves BDog. Now Fury avail
		x.hitbyplayertime = GetTime() + 2.0
		x.spine = 1
	end

	--SEND OBJECTIVE MESSAGE
	if x.spine == 1 and IsAudioMessageDone(x.audio1) then
		ClearObjectives()
		AddObjective("tcrb0801.txt")
		x.spine = 2
	end
	
	--START UP REGULAR ATTACKS IF 1 SCV IS DEPLOYED
	if x.spine == 2 and IsAlive(x.fscv[1]) then
		for index = 1, x.ewartotal do --init WARCODE
			x.ewardeclare = true
			x.ewarrior[index] = {} --"rows"
			x.ewartrgt[index] = nil
			for index2 = 1, 10 do --10 per wave max avail
				x.ewarrior[index][index2] = nil --"columns", init (handle in this case)
			end
			x.ewarstate[index] = 1
			x.ewartime[1] = GetTime() + 240.0 --recy
			x.ewartime[2] = GetTime() + 300.0 --fact
			x.ewartime[3] = GetTime() + 360.0 --armo
			x.ewartime[4] = GetTime() + 420.0 --base
			x.ewartimecool[index] = 240.0
			x.ewartimeadd[index] = 10.0
			x.ewarabort[index] = 99999.9
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
		x.wrecktime = GetTime() + 420.0 --init daywrk
		for index = 1, 2 do --init scavs
			x.escvstate[index] = 1
			x.escvbuildtime[index] = GetTime()
		end
		x.spine = 3
	end
	
	--START RETREAT PHASE PACK UP BDS RECYCLER
	if x.spine <= 3 and IsAlive(x.ercy) and (GetCurHealth(x.ercy) < math.floor(GetMaxHealth(x.ercy) * 0.5)) then
		
		SetMaxHealth(x.ercy, x.ercyhp);
		SetCurHealth(x.ercy, x.ercyhp);
		x.playfail[1] = 9 --no fail by frcy loss
		x.epattime = 99999.9
		x.eturtime = 99999.9
		x.ewardeclare = false
		x.ekillarttime = 99999.9
		x.escvbuildtime[1] = 99999.9
		x.escvbuildtime[2] = 99999.9
		x.earttime = 99999.9
		x.wrecktime = 99999.9
		x.pos = GetTransform(x.ercy)
		RemoveObject(x.ercy)
		x.ercy = BuildObject("bbrecy_close", 4, x.pos) --loop anim runs automatic
		x.savtime = GetTime() + 5.0
		x.waittime = GetTime() + 5.0
		x.spine = 4
	end
	
	--NOTIFY PLAYER and SEND ROMESKI
	if x.spine == 4 and x.waittime < GetTime() then
		--AudioMessage("tcrb0801.wav") --BDog AMUF on move. intercept it at nav beacon.
		--AudioMessage("tcrb0802.wav") --Recy retreating. will drop nav. watch real man fight
		--AudioMessage("tcrb0807.wav") --I will assume control of Furies
		--AudioMessage("tcrb0815.wav") --Eb - Satellite says recy retreat. Come see how a real man fights
		x.audio1 = AudioMessage("tcrb0816.wav") --Ea –Rom rcy retreat. I control fury. Come C how a man fights 
		x.pos = GetTransform(x.ercy)
		RemoveObject(x.ercy)
		x.ercy = BuildObject("bvrecy", 4, x.pos)
		SetSkill(x.ercy, x.skillsetting)
		SetObjectiveName(x.ercy, "BDS Recycler")
		SetObjectiveOn(x.ercy)
		Retreat(x.ercy, "epretreat")
		x.ercyprotect = true
		x.romtank = BuildObject("svtank", 2, "promeski")
		SetSkill(x.romtank, x.skillsetting)
		SetObjectiveName(x.romtank, "Romeski")
		SetObjectiveOn(x.romtank)
		Attack(x.romtank, x.ercy)
		x.romstate = 1
		x.edrp = BuildObject("bvdrop", 0, x.pos2)
		SetAnimation(x.edrp, "open", 1)
		SetObjectiveName(x.edrp, "BDS Dropship")
		SetObjectiveOn(x.edrp)
		Attack(x.mytank, x.romtank)
    Damage(x.egun[1], 8000) --so won't be
    Damage(x.egun[4], 8000) --in recy's way
    Damage(x.etur[14], 8000) --tired of killing it manually
		x.spine = x.spine + 1
	end
	
	--GIVE ORDER TO NOT INTERFERE WITH ROMESKI
	if x.spine == 5 and IsAudioMessageDone(x.audio1) then
		ClearObjectives()
		AddObjective("tcrb0802.txt")
		AddObjective("tcrb0802b.txt", "YELLOW")
		AddObjective("SAVE", "DKGREY")
		x.spine = x.spine + 1
	end
	
	--VICTORY TOUR - DOES ROMESKI BRAG
	if x.spine == 6 and not IsAlive(x.ercy) then
		x.romstate = 100 --stop romeski stuff
		for index = 1, 6 do
			if IsAlive(x.sav[index]) then
				Retreat(x.sav[index], "promeski")
			end
		end
		SetObjectiveOff(x.edrp)
		Ally(1, 3)
		Ally(2, 3)
		Ally(3, 1)
		Ally(3, 2)
		if IsAlive(x.romtank) then
			SetCurHealth(x.romtank, 50000)
			AudioMessage("tcrb0803.wav") --SUCCEED 1a – karnov BDog recy has been annihilated.
			x.audio7 = AudioMessage("tcrb0808.wav") --SUCCEED 1b – Romeski Fortunate I assume control when I did.
			ClearObjectives()
			AddObjective("tcrb0806.txt", "GREEN")
			x.playwin = 1
		else
			x.audio7 = AudioMessage("tcrb0814.wav") --SUCCEED 2 - You will assume command against rest of Amers
			ClearObjectives()
			AddObjective("tcrb0807.txt", "GREEN")
		end
		for index = 1, 25 do --build for camera seq
			x.sav[index] = BuildObject("svhtnk", 6, ("psav%d"):format(index))
		end
		RemoveObject(x.sav[5])
		x.sav[5] = BuildObject("svhtnk", 7, "psav5")
		RemoveObject(x.sav[6])
		x.sav[6] = BuildObject("svhtnk", 7, "psav6")
		RemoveObject(x.sav[13])
		x.sav[13] = BuildObject("svhtnk", 7, "psav13")
		RemoveObject(x.sav[18])
		x.sav[18] = BuildObject("svhtnk", 7, "psav18")
		RemoveObject(x.sav[23])
		x.sav[23] = BuildObject("svhtnk", 7, "psav23")
		x.MCAcheck = true
		x.spine = x.spine + 1
	end
	
	--SETUP CINERACTIVE
	if x.spine == 7 and IsAudioMessageDone(x.audio7) then
		for index = 1, 10 do
			Goto(x.sav[index], ("pend%d"):format(index))
		end
		for index = 11, 20 do
			Goto(x.sav[index], ("pend%d"):format(index-10))
		end
		for index = 21, 25 do
			Goto(x.sav[index], ("pend%d"):format(index-20))
		end
		x.cnslcmdvalue = IFace_GetInteger("options.audio.music") --get "music" volume value of player instance
		x.waittime = GetTime() + 1.0
		x.spine = x.spine + 1
	end
	
	--START THE CINERACTIVE
	if x.spine == 8 and (x.audio1 == nil or IsAudioMessageDone(x.audio1)) and (x.audio2 == nil or IsAudioMessageDone(x.audio2)) and	x.waittime < GetTime() then
		IFace_ConsoleCmd("options.audio.music 5") --adjust player "music" volume instance
		x.audio7 = AudioMessage("tcrb0820.wav") --19.86s
		x.camheight = 500
    x.userfov = IFace_GetInteger("options.graphics.defaultfov")
    CameraReady()
    IFace_SetInteger("options.graphics.defaultfov", x.camfov)
		x.camplay = 1
		SetTeamColor(6, 150, 140, 130)
		SetTeamColor(7, 150, 140, 130)
		x.waittime = GetTime() + 12.0
		x.spine = x.spine + 1
	end
	
	--WATCH THE GLORIOUS CCA FORCES ... OH SHIT
	if x.spine == 9 and x.waittime < GetTime() then
		UnAlly(6, 7)
		UnAlly(7, 6)
		SetTeamColor(7, 5, 10, 20)
		--defectors
		Attack(x.sav[5], x.sav[4])
		Attack(x.sav[6], x.sav[2])
		Attack(x.sav[13], x.sav[8])
		Attack(x.sav[18], x.sav[14])
		Attack(x.sav[23], x.sav[17])
		--main group
		Attack(x.sav[1], x.sav[5])
		Attack(x.sav[2], x.sav[5])
		SetCurHealth(x.sav[3], 50000) --for camera
		Attack(x.sav[3], x.sav[5])
		Attack(x.sav[4], x.sav[5])
		Attack(x.sav[7], x.sav[6])
		Attack(x.sav[8], x.sav[6])
		Attack(x.sav[9], x.sav[6])
		Attack(x.sav[10], x.sav[6])
		Attack(x.sav[11], x.sav[13])
		Attack(x.sav[12], x.sav[13])
		Attack(x.sav[14], x.sav[13])
		Attack(x.sav[15], x.sav[13])
		Attack(x.sav[16], x.sav[18])
		Attack(x.sav[17], x.sav[18])
		Attack(x.sav[19], x.sav[18])
		Attack(x.sav[20], x.sav[18])
		Attack(x.sav[21], x.sav[23])
		Attack(x.sav[22], x.sav[23])
		Attack(x.sav[24], x.sav[23])
		x.spine = x.spine + 1
	end
	
	--STOP CAMERA AND RESET MUSIC VOLUME
	if x.spine == 10 and IsAudioMessageDone(x.audio7) then
		IFace_ConsoleCmd(("options.audio.music %d"):format(x.cnslcmdvalue)) --return player "music volume" to previous setting
		x.waittime = GetTime() + 1.0
		x.spine = x.spine + 1
	end
	
	--SUCCEED MISSION
	if x.spine == 11 and x.waittime < GetTime() then
    CameraFinish()
    IFace_SetInteger("options.graphics.defaultfov", x.userfov)
		if x.playwin == 1 then
			TCC.SucceedMission(GetTime(), "tcrb08w1.des") --winner winner winner
		else
			TCC.SucceedMission(GetTime(), "tcrb08w2.des") --winner winner winner
		end
		x.spine = x.spine + 1
	end
	----------END MAIN SPINE ----------
	
	--SPAWN PROTECT BDS RECY TILL AWAY FROM BASE
	if x.ercyprotect then
		if IsAlive(x.ercy) and GetDistance(x.ercy, "eprcy") <= 500 then
			SetCurHealth(x.ercy, GetMaxHealth(x.ercy))
		else
			x.ercyprotect = false
		end
	end
	
	--FURY PHASE, CLEAR OUT FRCY AND FFAC AND CLEAR PLAYER IF FURY
	if x.savstate == 1 then --SET FROM ADDOBJECT FUNCITON
		if IsAlive(x.frcy) then --prevent player from building more savs
			x.pos = GetTransform(x.frcy)
			if IsOdf(x.frcy, "sbrecyrb08") then
				RemoveObject(x.frcy)
				x.frcy = BuildObject("sbrecyrb07", 1, x.pos) --savless recy
			else
				RemoveObject(x.frcy)
				x.frcy = BuildObject("svrecyrb07", 1, x.pos) --savless muf
			end
		end
		if IsAlive(x.ffac) then --prevent player from building more savs
			x.pos = GetTransform(x.ffac)
			if IsOdf(x.ffac, "sbfact") then
				RemoveObject(x.ffac)
				x.ffac = BuildObject("sbfactrb07", 1, x.pos) --savless factory
			else
				RemoveObject(x.ffac)
				x.ffac = BuildObject("svfactrb07", 1, x.pos) --savless amuf
			end
		end
		x.waittime = GetTime() + 2.0
		x.savstate = x.savstate + 1
  --DESTROY PLAYER FURY if necessary [MC] Ugh. I wish I could destroy this part...
	elseif x.savstate == 2 and x.waittime < GetTime() then
		x.player = GetPlayerHandle()--make sure player can't be a fury during romeski phase
			for index = 1, 6 do
			if IsAlive(x.sav[index]) and IsPlayer(x.sav[index]) then  --could try svhtnk:1 but trying other first if IsOdf(x.player, "svhtnk") then
				AudioMessage("alertpulse.wav")
				AddObjective("\nSAV not responding. Bailout Initiated.", "LAVACOLOR")
				x.pos = GetTransform(x.player)
				x.mytank = BuildObject("sspilo", 1,  x.pos)
				SetVelocity(x.mytank, SetVector(0.0, 20.0, 0.0))
				SetAsUser(x.mytank, 1)
				x.player = GetPlayerHandle()  --2nd time if run
				Damage(x.sav[index], GetMaxHealth(x.sav[index])+10)  --SWIOTCHED TO SAV[#]   -->>THIS DOES NOT WORK>> EjectPilot(x.player) neither does hopout fnc
				break
			end
		end

		x.waittime = GetTime() + 1.0
		x.savstate = x.savstate + 1
	--BUILD FURY IF NOT TAKEN FROM PLAYER
	elseif x.savstate == 3 and x.waittime < GetTime() then
		for index = 1, 6 do
			if IsAlive(x.sav[index]) and not IsPlayer(x.sav[index]) and not HasPilot(x.sav[index]) then
				AddPilotByHandle(x.sav[index])
			end
		end
		for index = 1, 6 do
			if not IsAlive(x.sav[index]) then
				x.sav[index] = BuildObject("svhtnk", 3, "promeski")
				SetSkill(x.sav[index], x.skillsetting)
			end
			if IsAlive(x.sav[index]) and GetTeamNum(x.sav[index]) == 1 then
				TCC.SetTeamNum(x.sav[index], 3)
			end
			SetObjectiveName(x.sav[index], ("CCA Fury %d"):format(index))
		end
		RemoveObject(x.sav[1]) --make sure FURY 1 is near romeski
		x.sav[1] = BuildObject("svhtnk", 3, "promeski")
		SetSkill(x.sav[1], x.skillsetting)
		SetObjectiveName(x.sav[1], "CCA Fury 1")
		Follow(x.sav[1], x.romtank)
		Goto(x.sav[2], "epsavwait")
		Goto(x.sav[3], "epsavwait")
		Goto(x.sav[4], "epsavwait")
  		Goto(x.sav[5], "promeski2")
		Goto(x.sav[6], "promeski3")
		for index = 1, x.ekillartlength do
			Damage(x.ekillart[index], 3000)
		end
		x.savstate = 100
	end
	
	--ROMESKI PHASE --GUARDS TURN BAD
	if x.romstate == 1 and not x.ercyprotect and GetCurHealth(x.ercy) < math.floor(GetMaxHealth(x.ercy) * 0.9) then
		AudioMessage("tcrb0805.wav") --aa - Strange readings from hybrid ships, abnormal response
		UnAlly(3, 2)
    if IsAlive(x.sav[1]) and IsAlive(x.romtank) then
      Attack(x.sav[1], x.romtank)
    end
		x.waittime = GetTime() + 4.0
		x.romstate = x.romstate + 1 
	--ROMESKI GUARDS TURN GOOD
	elseif x.romstate == 2 and x.waittime < GetTime() then
		--AudioMessage("tcrb0806.wav") --NOT USED - Any fool could see no abnormality. Can’t issue orders
		--AudioMessage("tcrb0811.wav") --NOT USED - Any fool could see no abnormality. continue mission
		AudioMessage("tcrb0818.wav") --ab - Any fool could see no abnormality in our weapons
		Ally(3, 2)
    if IsAlive(x.romtank) then
      SetCurHealth(x.romtank, GetMaxHealth(x.romtank))
    end
    if IsAlive(x.sav[2]) and IsAlive(x.player) then
      Follow(x.sav[2], x.player)
    end
		x.romstate = x.romstate + 1 
	--ROMESKI TEMP NO DAMAGE FROM FURY
  elseif x.romstate == 3 and x.waittime < GetTime() then
    if IsAlive(x.sav[1]) and IsAlive(x.romtank) then
      Follow(x.sav[1], x.romtank)
      SetCurHealth(x.romtank, GetMaxHealth(x.romtank))
    end
		if IsAlive(x.ercy) and GetCurHealth(x.ercy) < math.floor(GetMaxHealth(x.ercy) * 0.4) then
			x.romstate = x.romstate + 1
		end
	--ROMESKI GUARDS TURN BAD PERMANENTLY
	elseif x.romstate == 4 then
		x.audio2 = AudioMessage("tcrb0813.wav") --This does not look good comrades
    if IsAlive(x.romtank) then
      SetCurAmmo(x.romtank, GetMaxAmmo(x.romtank))
    end
		Ally(3, 4)
		UnAlly(1, 3)
		UnAlly(3, 1)
		UnAlly(3, 2)
		UnAlly(2, 3)
		UnAlly(1, 4)
		UnAlly(4, 1)
    for index = 1, 6 do
      if IsAlive(x.sav[index]) then
        SetCurHealth(x.sav[index], math.floor(GetMaxHealth(x.sav[index]) * 0.4))
      end
    end
    if IsAlive(x.sav[1]) and IsAlive(x.romtank) then
      Attack(x.sav[1], x.romtank)
    end
    if IsAlive(x.sav[2]) and IsAlive(x.player) then
      Attack(x.sav[2], x.player)
    end
    if IsAlive(x.frcy) then
      if IsAlive(x.sav[3]) then
        Attack(x.sav[3], x.frcy)
      end
      if IsAlive(x.sav[4]) then
        Attack(x.sav[4], x.frcy)
      end
      if IsAlive(x.sav[5]) then
        Attack(x.sav[5], x.frcy)
      end
    else
      if IsAlive(x.sav[3]) then
        Goto(x.sav[3], "promeski")
      end
      if IsAlive(x.sav[4]) then
        Goto(x.sav[4], "promeski")
      end
      if IsAlive(x.sav[5]) then
        Goto(x.sav[5], "promeski")
      end
    end
		if x.skillsetting > x.easy and IsAlive(x.romtank) then
			SetCurHealth(x.romtank, GetMaxHealth(x.romtank))
		end
		x.romstate = x.romstate + 1	
	--ROMESKI CALLS FOR HELP
	elseif x.romstate == 5 and IsAudioMessageDone(x.audio2) then
		--AudioMessage("tcrb0809.wav") --NOT USED - What’s that?	
		x.audio2 = AudioMessage("tcrb0810.wav") --Protect me from them my friend (Fury?)
		ClearObjectives()
		AddObjective("tcrb0803.txt", "LAVA")
    if IsAlive(x.romtank) then
      SetCurHealth(x.romtank, GetMaxHealth(x.romtank))
    end
    x.romfree = true
		x.romstate = x.romstate + 1 
	--ROMESKI HEAVILY DAMAGED
	elseif x.romstate == 6 and (not IsAlive(x.romtank) or (GetCurHealth(x.romtank) <= (GetMaxHealth(x.romtank)*0.1))) then
		x.audio2 = AudioMessage("tcrb0817.wav") --This unfortunate
		x.romstate = x.romstate + 1	
	end
	
	--ROMESKI DEAD - keep separate
	if x.playfail[2] < 0 and x.romstate > 0 and x.romstate < 9 and not IsAlive(x.romtank) and IsAlive(x.ercy) then
		x.romfree = true
		x.audio2 = AudioMessage("tcrb0812.wav") --aaarrrggghhh
		ClearObjectives()
		AddObjective("tcrb0804.txt")
		x.romstate = 9
	end
	
	--SHOT BY PLAYER SETUP FOR MISSION FAIL
	if not x.romfree and IsAlive(x.romtank) then
		--ROMESKI
		if ((GetTime() - GetLastFriendShot(x.romtank)) < 0.7) and x.hitbyplayertime < GetTime() then
			if x.player == GetWhoShotMe(x.romtank) then --for when the shooter is a fury
				AudioMessage("tcrb0819b.wav") --MODIFIED SHORT - How dare you fire upon me.
				x.hitbyplayerrom = x.hitbyplayerrom + 1
				if x.hitbyplayerrom == 3 then
					x.playfail[2] = 1
				end
			end
			x.hitbyplayertime = GetTime() + 1.0
		end
		
		--BDS RECY
		if ((GetTime() - GetLastFriendShot(x.ercy)) < 0.7) and x.hitbyplayertime < GetTime() and not x.ercyprotect then
			if x.player == GetWhoShotMe(x.ercy)  then --for when the shooter is a fury
				AudioMessage("tcrb0819c.wav") --SHORT-SHORT-SHORT How dare you fire.
				x.hitbyplayerercy = x.hitbyplayerercy + 1
				if x.hitbyplayerercy == 3 then
					x.playfail[3] = 1
				end
			end
			x.hitbyplayertime = GetTime() + 1.0
		end
		
		--SAV 1
		if ((GetTime() - GetLastFriendShot(x.sav[1])) < 0.7) and x.hitbyplayertime < GetTime() then
			AudioMessage("tcrb0819c.wav") --SHORT-SHORT-SHORT How dare you fire.
			x.hitbyplayersav1 = x.hitbyplayersav1 + 1
			if x.hitbyplayersav1 == 3 then
				x.playfail[3] = 1
			end
			x.hitbyplayertime = GetTime() + 1.0
		end
	end
	
	--ROMESKI CAN'T CLOSE THE DEAL
	if not x.romfree and IsAlive(x.romtank) and IsAlive(x.ercy) and GetDistance(x.ercy, "epretreat") < 500 then
		AudioMessage("alertpulse.wav")
		ClearObjectives()
		AddObjective("tcrb0805.txt", "CYAN")
		x.romfree = true
	end 
	
	--RUN THE CAMERA ON THE SAV SQUAD
	if x.camplay == 1 and IsAlive(x.sav[3]) then
		CameraPath("pcam0", x.camheight, 3500, x.sav[3]) --pcam0 straight --pcam1 endloop
		x.camheight = x.camheight + 30
	end
	
	--AI GROUP TURRETS
	if x.eturtime < GetTime() and IsAlive(x.ercy) then
		for index = 1, x.eturlength do
			if not IsAlive(x.etur[index]) and not x.eturallow[index] and x.eturlife[index] < 4 then
				x.etursecs[index] = x.etursecs[index] + x.etursecsadd[index]
				x.eturcool[index] = GetTime() + 180.0 + x.etursecs[index]
				x.eturallow[index] = true
			end
			if x.eturallow[index] and x.eturcool[index] < GetTime() then
				x.etur[index] = BuildObject("bvturr", 5, GetPositionNear("epgrcy", 0, 16, 32)) --grpspwn
				Goto(x.etur[index], ("eptur%d"):format(index))
				SetSkill(x.etur[index], x.skillsetting)
				SetObjectiveName(x.etur[index], ("Badger %d"):format(index))
				x.eturlife[index] = x.eturlife[index] + 1
				x.etursecsadd[index] = x.etursecsadd[index] + 60.0
				x.eturallow[index] = false
			end
		end
	end

	--AI PATROLS GENERIC
	if x.epattime < GetTime() and IsAlive(x.efac) then
		for index = 1, x.epatlength do
			if not IsAlive(x.epat[index]) and not x.epatallow[index] then
				x.epatcool[index] = GetTime() + 300.0
				x.epatallow[index] = true
			end
			if x.epatallow[index] and x.epatcool[index] < GetTime() then
				while x.randompick == x.randomlast do --random the random
					x.randompick = math.floor(GetRandomFloat(1.0, 12.0))
				end
				x.randomlast = x.randompick
				if x.randompick == 1 or x.randompick == 5 or x.randompick == 9 then
					x.epat[index] = BuildObject("bvscout", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
				elseif x.randompick == 2 or x.randompick == 6 or x.randompick == 10 then
					x.epat[index] = BuildObject("bvmbike", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
				elseif x.randompick == 3 or x.randompick == 7 or x.randompick == 11 then
					x.epat[index] = BuildObject("bvmisl", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
				else --4, 8, 12
					x.epat[index] = BuildObject("bvtank", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
				end
			end
			if index % 2 == 0 then
				Patrol(x.epat[index], "ppatrol2")
			else
				Patrol(x.epat[index], "ppatrol1")
			end
			SetSkill(x.epat[index], x.skillsetting)
			x.epatallow[index] = false
		end
		x.epattime = GetTime() + 30.0
	end
	
	--AI DAYWRECKER ATTACK
	if x.wreckstate == 0 and IsAlive(x.earm) and IsAlive(x.etec) and x.wrecktime < GetTime() and GetMaxScrap(5) >= 80 then
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
	
	--WARCODE --special no efac stop
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
					else --wave 5
						x.ewarsize[index] = 10
					end
					x.ewarstate[index] = x.ewarstate[index] + 1
				end
				--BUILD FORCE
				if x.ewarstate[index] == 2 then
					for index2 = 1, x.ewarsize[index] do
						if index < 4 then --THIS MISISON ONLY, SPECIAL BASE ATTACK BELOW
							while x.randompick == x.randomlast do --random the random
								x.randompick = math.floor(GetRandomFloat(1.0, 18.0))
							end
							x.randomlast = x.randompick
							if x.randompick == 1 or x.randompick == 7 or x.randompick == 13 then
								x.ewarrior[index][index2] = BuildObject("bvscout", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
								if x.ewarwave[index] == 3 or x.ewarwave[index] == 4 then
									GiveWeapon(x.ewarrior[index][index2], "gchana_c") --"glasea_c")
								end
							elseif x.randompick == 2 or x.randompick == 8 or x.randompick == 14 then
								x.ewarrior[index][index2] = BuildObject("bvmbike", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
								if x.ewarwave[index] == 2 or x.ewarwave[index] == 4 then
									GiveWeapon(x.ewarrior[index][index2], "gstbva_c")
								end
							elseif x.randompick == 3 or x.randompick == 9 or x.randompick == 15 then
								x.ewarrior[index][index2] = BuildObject("bvmisl", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
								if x.ewarwave[index] == 3 or x.ewarwave[index] == 5 then
									GiveWeapon(x.ewarrior[index][index2], "gfafma_c")
								end
							elseif x.randompick == 4 or x.randompick == 10 or x.randompick == 16 then
								x.ewarrior[index][index2] = BuildObject("bvtank", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
								if x.ewarwave[index] == 4 or x.ewarwave[index] == 5 then
									GiveWeapon(x.ewarrior[index][index2], "gstbva_c") --salvo since super def on bvtank
								end
							elseif x.randompick == 5 or x.randompick == 11 or x.randompick == 17 then
								x.ewarrior[index][index2] = BuildObject("bvrckt", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
								if x.ewarwave[index] == 3 or x.ewarwave[index] == 5 then
									GiveWeapon(x.ewarrior[index][index2], "gshdwa_a") --salvo rckt
								end
							else --6	12	18
								if x.ewarwave[index] > 2 then
									x.ewarrior[index][index2] = BuildObject("bvwalk", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
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
								else
									x.ewarrior[index][index2] = BuildObject("bvtank", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
								end
							end
						else
							if index2 % 2 == 0 then --avoid some bunching
								x.ewarrior[index][index2] = BuildObject("bvartl",	5, "epgfac")
							else
								x.ewarrior[index][index2] = BuildObject("bvartl",	5, "epgrcy")
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
						if IsAlive(x.ewarrior[index][index2]) and GetDistance(x.ewarrior[index][index2], ("stage%d"):format(x.ewarmeet[index]), 5) < 100 and GetTeamNum(x.ewarrior[index][index2]) ~= 1 then
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
						x.ewartimecool[index] = x.ewartimecool[index] + x.ewartimeadd[index]
						x.ewartime[index] = GetTime() + x.ewartimecool[index]
						if x.ewarwave[index] == 5 then --extra time after last wave to "ease up"
							x.ewartime[index] = GetTime() + x.ewartimecool[index] + 120.0
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
		
		if not IsAlive(x.efac) then
			x.ewardeclare = false
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
	
	--AI SCAVS FOR LOOKS
	if IsAlive(x.ercy) then
		if GetScrap(5) > 39 and not x.wreckbank then --so don't interfere with daywrecker
			SetScrap(5, (GetMaxScrap(5) - 40))
		end
		for index = 1, 2 do
			if x.escvstate[index] == 1 and not IsAlive(x.escv[index]) then
				x.escvbuildtime[index] = GetTime() + 120.0
				x.escvstate[index] = 2
			elseif x.escvstate[index] == 2 and x.escvbuildtime[index] < GetTime() then
				x.escv[index] = BuildObject("bvscav", 5, GetPositionNear("epgrcy", 0, 16, 32)) --grpspwn
				x.escvbuildtime[index] = 99999.9
				x.escvstate[index] = 1
			end
		end
	end
	
	--CHECK STATUS OF MCA ----------------------------------
	if not x.MCAcheck then
		if x.playfail[1] == 0 and not IsAlive(x.frcy) then --frecy killed
			ClearObjectives()
			AddObjective("tcrb0808.txt", "RED")
			x.audio6 = AudioMessage("tcrb0611.wav") --NIO - FAIL
			x.spine = 666
			x.playfail[1] = 1
		elseif x.playfail[1] == 1 and IsAudioMessageDone(x.audio6) then
			TCC.FailMission(GetTime(), "tcrb08f1.des") --LOSER LOSER LOSER
			x.MCAcheck = true
		end
		
		if x.playfail[2] == 1 and not x.romfree then --shot romeski too many times
			ClearObjectives()
			AddObjective("tcrb0809.txt", "RED")
			x.audio6 = AudioMessage("tcrb0819d.wav") --Inform Karnov
			x.spine = 666
			x.playfail[2] = 2
		elseif x.playfail[2] == 2 and IsAudioMessageDone(x.audio6) then
			TCC.FailMission(GetTime(), "tcrb08f2.des") --LOSER LOSER LOSER
			x.MCAcheck = true
		end
		
		if x.playfail[3] == 1 then --shot w/out permission too many times
			ClearObjectives()
			AddObjective("tcrb0810.txt", "RED")
			x.audio6 = AudioMessage("tcrb0819d.wav") --Inform Karnov
			x.spine = 666
			x.playfail[3] = 2
		elseif x.playfail[3] == 2 and IsAudioMessageDone(x.audio6) then
			TCC.FailMission(GetTime(), "tcrb08f3.des") --LOSER LOSER LOSER
			x.MCAcheck = true
		end
		
		if IsAlive(x.ercy) and GetDistance(x.ercy, "epretreat") < 150 then --BDS recycler escaped
			SetCurHealth(x.ercy, 30000)
			AudioMessage("tcrb0109.wav") --FAIL – A1 Recy escaped
			AudioMessage("tcrb0111.wav") --FAIL – A2 You failed 
			ClearObjectives()
			AddObjective("tcrb0811.txt", "RED")
			TCC.FailMission(GetTime() + 20.0, "tcrb08f4.des") --LOSER LOSER LOSER
			x.spine = 666
			x.MCAcheck = true
		end
    
    if x.playfail[1] < 9 and not IsAlive(x.ercy) then  --killed BDS recy too soon (damaged and hit with Daywrecker)
      ClearObjectives()
			AddObjective("You robbed Romeski of his glory!", "RED")
      AddObjective("Heavily damage but do not destroy the Recycler.", "RED")
      TCC.FailMission(GetTime() + 5.0, "tcrb08f3.des") --LOSER LOSER LOSER
      x.spine = 666
			x.MCAcheck = true
    end
	end
end
--[[END OF SCRIPT]]