--bztcdw11 - Battlezone Total Command - Dogs of War - 11/15 - STRANDED
assert(load(assert(LoadFile("_requirefix.lua")),"_requirefix.lua"))();
TCC = require("TC_Core")
MisnNum = 44;
--DECLARE variables --f-friend, e-enemy, atk-attack, rcy-recycler, etc...,
local index = 0
local index2 = 0
local x = {
	FIRST = true, 	
	spine = 0, 
	waittime = 99999.9, 
	MCAcheck = false, 
	player = nil, 
	mytank = nil, 
	skillsetting = 0, 
	pos = {}, 
	audio1 = nil, 
	audio6 = nil,
	camfov = 60,  --185 default
	userfov = 90,  --seed
	fnav = {},	
	randompick = 0, 
	randomlast = 0,
	playerstate = 0, 
	casualty = 0, 
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
	frcypos = {}, 
	fgrp = {}, 
	fsct = {}, 
	fsrv = {}, 
	fapc = nil, 
	fapcstate = 0, 
	fapchealth = 0, 
	fpilot = nil, 
	epilot = {}, 
	epilotlength = 0, 
	eprtstate = 0, 
	boomstate = 0, 
	boomtime = 99999.9, 
	freestuff = {}, --free stuff
	eatk = {}, --cra attack
	easnlength = 0, --6 avail
	easnstate = 0,	
	egun = {}, --cra bases
	epwr = {}, 
	etur = {}, 
	eprt = nil, 
	ewardeclare = false, --WARCODE SPECIAL DW11
	ewarmax = 0, --special for dw11
	ewartotal = 4, --1 recy, 2 fact, 3 armo, 4 base 
	ewarrior = {}, 
	ewartime = {},
	ewartimecool = {},
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
--PATHS: pcam1, epgun3-6, eppwr3-6, eptur3-6, epgrd(0-16), epatk(0-20), epwlk(0-4), prcyrun(0-8), epgfac(0-20), stage1-2, , eppil(0-5), pscrap(0-120)

function InitialSetup()
	SetAutoGroupUnits(true)
		
	local odfpreload = {
		"kspilo", "kssold", "kbpgen2", "kbgtow", "kvscout", "kvmbike", "kvmisl", "kvtank", "kvrckt", "kvhtnk", "kvwalk", "kvturr", "kbprtl", 
		"bvrecydw11", "bvapc", "bvscout", "bvmbike", "bvmisl", "bvtank", "bvrckt", "bvstnk", "bvserv", "npscrx", "apdwrka", "apdwqka", "apcamrb" 
	}
	for k,v in pairs(odfpreload) do
		PreloadODF(v)
	end
	
	x.eprt = GetHandle("eprt")
	x.freestuff[1] = GetHandle("pega1")
	x.freestuff[2] = GetHandle("pega2")
	Ally(1, 2)
	Ally(2, 1) --2 is frcy while captured
	for index = 2, 8 do
		Ally(index, 2)
		Ally(index, 3)
		Ally(index, 4)
		Ally(index, 5)
		Ally(index, 6)
		Ally(index, 7)
		Ally(index, 8)
	end
	SetColorFade(6.0, 0.5, "BLACK")
	TCC.Init();
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
local replaced = false;
function AddObject(h)
	if (replaced) then 	replaced = false;	return; 	end;
	--get player base buildings for later attack
	if (not IsAlive(x.farm) or x.farm == nil) and IsType(h, "bbarmo") then
		h, replaced = RepObject(h);
		x.farm = h;
	elseif (not IsAlive(x.ffac) or x.ffac == nil) and IsOdf(h, "bbfact") then
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
		for indexadd = 1, 4 do
			if x.fpwr[indexadd] == nil or not IsAlive(x.fpwr[indexadd]) then
				x.fpwr[indexadd] = h
				break
			end
		end
	elseif IsAlive(h) or IsPlayer(h) then
		ReplaceStabber(h)
	end

	
	--get aperture dummy00
	if not x.gotdummy and IsOdf(h, "dummy00") then
		x.dummy = h
		x.dummypos = GetTransform(h)
		x.gotdummy = true
	end
	
	--get ramp dummyprtl
	if not x.gotdummy2 and IsOdf(h, "dummyprtl") then
		x.dummy2 = h
		x.dummypos2 = GetTransform(h)
		x.gotdummy2 = true
	end

	if (x.spine > 5 and GetRace(h) ~= "b") then
		SetEjectRatio(h, 0.0); --[MC] annoying pilots
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
		for index = 1, 3 do
			x.fgrp[index] = GetHandle(("fgrp%d"):format(index))
			x.pos = GetTransform(x.fgrp[index])
			RemoveObject(x.fgrp[index])
			x.fgrp[index] = BuildObject("bvstnk", 1, x.pos)
			SetGroup(x.fgrp[index], 0)
			SetSkill(x.fgrp[index], 3)
		end
		for index = 4, 6 do
			x.fgrp[index] = GetHandle(("fgrp%d"):format(index))
			x.pos = GetTransform(x.fgrp[index])
			RemoveObject(x.fgrp[index])
			x.fgrp[index] = BuildObject("bvtank", 1, x.pos)
			SetGroup(x.fgrp[index], 0)
			SetSkill(x.fgrp[index], 3)
			GiveWeapon(x.fgrp[index], "gstbra_c")
		end
		for index = 7, 8 do --REMOVE DUMMIES, OTHERWISE DON'T USE EXTRA VEHICLES
			x.fgrp[index] = GetHandle(("fgrp%d"):format(index))
			x.pos = GetTransform(x.fgrp[index])
			RemoveObject(x.fgrp[index])
			--[[if IFace_GetInteger("options.play.difficulty") < 2 then
				x.fgrp[index] = BuildObject("bvstnk", 1, x.pos)
				SetGroup(x.fgrp[index], 0)
				SetSkill(x.fgrp[index], 3)
			end--]]
		end
		for index = 9, 10 do
			x.fgrp[index] = GetHandle(("fgrp%d"):format(index))
			x.pos = GetTransform(x.fgrp[index])
			RemoveObject(x.fgrp[index])
			--[[if IFace_GetInteger("options.play.difficulty") == 0 then
				x.fgrp[index] = BuildObject("bvtank", 1, x.pos)
				SetGroup(x.fgrp[index], 0)
				SetSkill(x.fgrp[index], 3)
				GiveWeapon(x.fgrp[index], "gstbra_c")
			end--]]
		end
		for index = 1, 3 do
			x.fsrv[index] = GetHandle(("fsrv%d"):format(index))
			x.pos = GetTransform(x.fsrv[index])
			RemoveObject(x.fsrv[index])
			x.fsrv[index] = BuildObject("bvserv", 1, x.pos)
			SetGroup(x.fsrv[index], 4)
			SetSkill(x.fsrv[index], 3)
		end
		x.fapc = GetHandle("fapc")
		x.pos = GetTransform(x.fapc)
		RemoveObject(x.fapc)
		x.fapc = BuildObject("bvapc", 1, x.pos)
		SetGroup(x.fapc, 3)
		SetSkill(x.fsrv[index], 3)
		for index = 1, 2 do
			x.fsct[index] = GetHandle(("fsct%d"):format(index))
			x.pos = GetTransform(x.fsct[index])
			RemoveObject(x.fsct[index])
			x.fsct[index] = BuildObject("bvscout", 2, x.pos)
			SetSkill(x.fsct[index], 3)
			SetCurHealth(x.fsct[index], 5000) --make super scout like original
			SetCurAmmo(x.fsct[index], 5000)
			Defend2(x.fsct[index], x.fapc)
		end
		x.mytank = GetHandle("mytank")
		x.pos = GetTransform(x.mytank)
		RemoveObject(x.mytank)
		x.mytank = BuildObject("bvtank", 1, x.pos)
		GiveWeapon(x.mytank, "gpopg1a")
		SetAsUser(x.mytank, 1) --high # is player, NOT MYTANK
		RemoveObject(x.player)
		x.player = GetPlayerHandle()
		x.frcy = BuildObject("bvrecydw11", 2, "fprcy")
		x.waittime = GetTime() + 3.0 --keep up here
		for index = 3, 6 do --Build each base
			x.egun[index] = BuildObject("kbgtow", index, ("epgun%d"):format(index))
			x.epwr[index] = BuildObject("kbpgen2", index, ("eppwr%d"):format(index))
		end
		x.etur[1] = BuildObject("kvturr", 5, "eptur3")
		x.etur[2] = BuildObject("kvturr", 5, "eptur4")
		x.etur[3] = BuildObject("kvturr", 5, "eptur5")
		x.etur[4] = BuildObject("kvturr", 5, "eptur6")
		x.eatk[1] = BuildObject("kvscout", 5, "epgrd", 1)
		x.eatk[2] = BuildObject("kvmbike", 5, "epgrd", 5)
		x.eatk[3] = BuildObject("kvscout", 5, "epgrd", 9)
		x.eatk[4] = BuildObject("kvscout", 5, "epgrd", 13)
		x.eatk[5] = BuildObject("kvmbike", 5, "epgrd", 2)
		x.eatk[6] = BuildObject("kvmbike", 5, "epgrd", 6)
		x.eatk[7] = BuildObject("kvmbike", 5, "epgrd", 10)
		x.eatk[8] = BuildObject("kvmbike", 5, "epgrd", 14)
		x.eatk[9] = BuildObject("kvmisl", 5, "epgrd", 3)
		x.eatk[10] = BuildObject("kvrckt", 5, "epgrd", 7)
		x.eatk[11] = BuildObject("kvmisl", 5, "epgrd", 11)
		x.eatk[12] = BuildObject("kvrckt", 5, "epgrd", 15)
		x.eatk[13] = BuildObject("kvtank", 5, "epgrd", 4)
		x.eatk[14] = BuildObject("kvtank", 5, "epgrd", 8)
		x.eatk[15] = BuildObject("kvtank", 5, "epgrd", 12)
		x.eatk[16] = BuildObject("kvtank", 5, "epgrd", 16)
		for index = 1, 70 do
			x.fnav[1] = BuildObject("npscrx", 0, "pscrap", index)
		end
    KillPilot(x.freestuff[1])
    KillPilot(x.freestuff[2])
    RemoveObject(x.freestuff[1]) --yvpega was fun, ..
    RemoveObject(x.freestuff[2]) --but threw off mission when used by player
		x.spine = x.spine + 1
	end
	
	--START CAMERA
	if x.spine == 1 and x.waittime < GetTime() then
		x.audio1 = AudioMessage("tcdw1101.wav") --Try to recapture the Recy. Chinese control portal.
		x.camstate = 1
    x.userfov = IFace_GetInteger("options.graphics.defaultfov")
    CameraReady()
    IFace_SetInteger("options.graphics.defaultfov", x.camfov)
		x.spine = x.spine + 1
	end
	
	--GIVE FIRST OBJECTIVE
	if x.spine == 2 and IsAudioMessageDone(x.audio1) then
		x.camstate = 0
    CameraFinish()
    IFace_SetInteger("options.graphics.defaultfov", x.userfov)
		ClearObjectives()
		AddObjective("tcdw1101.txt")
		SetObjectiveOn(x.frcy)
		x.spine = x.spine + 1
	end
	
	--APC AT RECY
	if x.spine == 3 and IsAlive(x.fapc) and IsAlive(x.frcy) and GetDistance(x.fapc, x.frcy) < 120 then
		Stop(x.fapc, 0)
		x.fpilot = BuildObject("bspilo", 1, x.fapc)
		SetVelocity(x.fpilot, (SetVector(0.0, 0.0, 10.0)))
		SetObjectiveName(x.fpilot, "Engineer")
		SetObjectiveOn(x.fpilot)
		Goto(x.fpilot, x.frcy)
		x.fapcstate = 1
		x.waittime = GetTime() + 3.0
		x.spine = x.spine + 1
	end
	
	--IT'S A TRAP! (with Adm. Ackbar voice)
	-- [MC] Not anymore. Try challenging the player through *better* means next time.
	if x.spine == 4 and x.waittime < GetTime() then
		x.epilotlength = 4 --removed diff sizing
		--[[
		for index = 1, x.epilotlength do
			x.epilot[index] = BuildObject("kspilo", 5, "eppil", index)
			SetSkill(x.epilot[index], 3)
			Attack(x.epilot[index], x.fpilot)
		end
		AudioMessage("alertpulse.wav")
		AddObjective("\n\nProtect the Engineer!", "YELLOW")
		]]
		x.spine = x.spine + 1
	end
	
	--RECY HAS PILOT - SWITCH CRA PILOT TO SOLDIER
	-- [MC] No.
	if x.spine == 5 and IsAlive(x.frcy) and IsAround(x.fpilot) and GetDistance(x.fpilot, x.frcy) < 15 then
		RemoveObject(x.fpilot)
		--[[
		for index = 1, x.epilotlength do --they won't kill it, but it'll look neat
			if IsAlive(x.epilot[index]) then
				x.pos = GetTransform(x.epilot[index])
				RemoveObject(x.epilot[index])
				x.epilot[index] = BuildObject("kssold", 5, x.pos)
				SetSkill(x.epilot[index], 3)
				Attack(x.epilot[index], x.frcy)
			end
		end
		]]
		x.fapcstate = 2
		x.waittime = GetTime() + 6.0
		x.spine = x.spine + 1
	end
	
	--RECY RUN
	if x.spine == 6 and IsAlive(x.frcy) and x.waittime < GetTime() then
		x.fapcstate = 3
		AudioMessage("tcdw1102.wav") --APC - I'm in LT. now let’s get out of here.
		TCC.SetTeamNum(x.frcy, 1)
		SetPerceivedTeam(x.frcy, 1) --make double sure they hate frcy
		Goto(x.frcy, "prcyrun")
		Follow(x.fapc, x.frcy, 0)
		x.eatk[1] = BuildObject("kvmbike", 5, "epwlk", 1)
		Attack(x.eatk[1], x.frcy)
		x.eatk[2] = BuildObject("kvmbike", 5, "epwlk", 2)
		Attack(x.eatk[2], x.frcy)
		x.eatk[3] = BuildObject("kvwalk", 5, "epwlk", 3)
		Attack(x.eatk[3], x.frcy)
		x.eatk[4] = BuildObject("kvwalk", 5, "epwlk", 4)
		Attack(x.eatk[4], x.frcy)
		--x.eatk[5] = BuildObject("kvwalk", 5, "epwlk", 5)
		--Attack(x.eatk[5], x.frcy)
		x.spine = x.spine + 1
	end
	
	--RECY TO PLAYER, START WARCODE
	if x.spine == 7 and IsAlive(x.frcy) and GetDistance(x.frcy, "prcyrun", 8) < 16 then
		SetGroup(x.frcy, 7) --Defend(x.frcy, 0) --acts as a deploy command on a recy
		Stop(x.frcy, 0)
		for index = 1, 2 do
			TCC.SetTeamNum(x.fsct[index], 1)
			SetGroup(x.fsct[index], 3)
			Defend(x.fsct[index], 0)
		end
		AudioMessage("emdotcox.wav")
		ClearObjectives()
		AddObjective("tcdw1101.txt",	"GREEN")
		x.waittime = GetTime() + 4.0
		--special dw11
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
			x.ewartime[1] = GetTime() + 60.0 --recy
			x.ewartime[2] = GetTime() + 120.0 --fact
			x.ewartime[3] = GetTime() + 180.0 --armo
			x.ewartime[4] = GetTime() + 240.0 --base
			x.ewarmeet[index] = 2
			x.ewartimecool[index] = 120.0
			x.ewarabortset[index] = false
			x.ewarabort[index] = 99999.9
			x.ewarsize[index] = 0
			x.ewarwave[index] = 0
			x.ewarwavemax[index] = 5
			x.ewarwavereset[index] = 2
		end
		x.spine = x.spine + 1
	end
	
	--GIVE PLAYER DEFEND RECYCLER ORDER
	if x.spine == 8 and x.waittime < GetTime() then
		ClearObjectives()
		AddObjective("tcdw1102.txt")
		x.spine = x.spine + 1
	end
	
	--GIVE PLAYER SCRAP - b/c doesn't always work higher up
	if x.spine == 9 and IsAlive(x.frcy) and IsOdf(x.frcy, "bbrecydw11") then
		SetScrap(1, 40)
		x.spine = x.spine + 1
	end
	
	--CRA RETREAT MESSAGES
	if x.spine == 10 and x.boomstate == 1 and x.waittime < GetTime() then
		AudioMessage("tcdw1107.wav") --CRA - come in destroy Pegasus as you leave
		AudioMessage("tcdw1108.wav") --CRA - orders received and understood
		x.audio1 = AudioMessage("tcdw1109.wav") --CRA - initiate standing order Lima Romeo 7
		ClearObjectives()
		AddObjective("tcdw1102.txt", "GREEN")
		x.spine = x.spine + 1
	end
	
	--GIVE FINAL ORDER AND START CLOCK
	if x.spine == 11 and IsAudioMessageDone(x.audio1) then
		AudioMessage("tcdw1112.wav") --Get to the portal. Chinese bomb incoming. Get all out of there
		ClearObjectives()
		AddObjective("tcdw1103.txt", "YELLOW")
		x.fnav[1] = BuildObject("apcamrb", 1, x.eprt)
		SetObjectiveName(x.fnav[1], "RETREAT TO PORTAL")
		SetObjectiveOn(x.fnav[1])
		x.waittime = GetTime() + 10.0
		x.spine = x.spine + 1
	end
	
	--IS RECYCLER BACK TO VEHICLE
	if x.spine == 12 and (x.waittime < GetTime() or (IsAlive(x.frcy) and IsOdf(x.frcy, "bvrecydw11"))) then
		StartCockpitTimer(240, 60, 30)
		x.boomtime = GetTime() + 242.0
		x.easnstate = 1
		x.waittime = GetTime() + 90.0
		x.spine = x.spine + 1
	end
	
	--RECYCLER AT SAFE DISTANCE
	if x.spine == 13 and x.boomtime > GetTime() and IsAlive(x.player) and IsAlive(x.frcy) and IsAlive(x.eprt) and GetDistance(x.frcy, x.eprt) < 1111 then
		ClearObjectives()
		AddObjective("tcdw1103.txt", "GREEN")
		StopCockpitTimer()
		HideCockpitTimer()
		x.boomtime = 99999.9
		SetCurHealth(x.player, 200000)
		SetCurHealth(x.frcy, 200000)
		x.waittime = GetTime() + 3.0
		x.camstate = 2
    x.userfov = IFace_GetInteger("options.graphics.defaultfov")
    CameraReady()
    IFace_SetInteger("options.graphics.defaultfov", x.camfov)
		x.MCAcheck = true
		x.spine = x.spine + 1
	end
	
	--TOSS BOMB
	if x.spine == 14 and x.waittime < GetTime() and IsAlive(x.player) then
		ClearObjectives()
		x.audio1 = AudioMessage("tcdw1110.wav") --CPU - Destruct sequence activated
		x.fnav[2] = BuildObject("apdwqka", 0, x.dummy)
		SetVelocity(x.fnav[2], (SetVector(0.0, -10.0, 0.0)))
		x.eprtstate = 1
		x.spine = x.spine + 1
	end
	
	--BLOW UP PORTAL
	if x.spine == 15 and IsAudioMessageDone(x.audio1) and IsAlive(x.player) then
		Damage(x.eprt, 60000)
		x.waittime = GetTime() + 4.0
		x.spine = x.spine + 1
	end
	
	--FINAL MESSAGE
	if x.spine == 16 and x.waittime < GetTime() and IsAlive(x.player) then
		x.audio1 = AudioMessage("tcdw1111.wav") --SUCCEED - Oh sweet Jesus, we're trapped
		x.spine = x.spine + 1
	end

	--MISSION SUCCESS
	if x.spine == 17 and IsAudioMessageDone(x.audio1) and IsAlive(x.player) then
    CameraFinish()
    IFace_SetInteger("options.graphics.defaultfov", x.userfov)
		TCC.SucceedMission(GetTime() + 1.0, "tcdw11w.des") --WINNER WINNER WINNER
		x.spine = 666
	end
	----------END MAIN SPINE ----------
	
	--CAMERA 1-2
	if x.camstate == 1 then
		CameraPath("pcam1", 3000, 3000, x.frcy)
	elseif x.camstate == 2 then
		CameraObject(x.dummy2, 0, 20, 250, x.dummy2)
	end
	
	--CRA RECY ASSASSIN W/ CLOAKING
	if x.easnstate == 1 and x.waittime < GetTime() then
		x.easnlength = 4
		for index = 1, x.easnlength do
			x.eatk[index] = BuildObject("kvtank", 5, "epgfac", index)
			SetSkill(x.eatk[index], x.skillsetting)
			SetCommand(x.eatk[index], 47)
		end
		x.easnstate = x.easnstate + 1
	elseif x.easnstate == 2 then
		for index = 1, x.easnlength do
			Retreat(x.eatk[index], x.frcy)
		end
		x.easnstate = x.easnstate + 1
	elseif x.easnstate == 3 then
		for index = 1, x.easnlength do
			if GetDistance(x.eatk[index], x.frcy) < 150 then
				for index2 = 1, x.easnlength do 
					SetCommand(x.eatk[index2], 48)
				end
				x.easnstate = x.easnstate + 1
				break
			end
		end
	elseif x.easnstate == 4 then
		for index = 1, x.easnlength do
			Attack(x.eatk[index], x.frcy)
		end
	end
	
	--WARCODE W/ CLOAKING & REMOTE PATH SPAWNED AT SPECIFIED POINT
	if x.ewardeclare then
		for index = 1, x.ewartotal do	
			if x.ewartime[index] < GetTime() then 
				--SET WAVE NUMBER
				if x.ewarstate[index] == 1 then	
					x.ewarwave[index] = x.ewarwave[index] + 1
					--SET WAVE SIZE --DW11 SPECIAL all index same warsize
					if x.ewarwave[index] == 1 then
						x.ewarsize[index] = 3
					elseif x.ewarwave[index] == 2 then
						x.ewarsize[index] = 4
					elseif x.ewarwave[index] == 3 then
						x.ewarsize[index] = 5
					elseif x.ewarwave[index] == 4 then
						x.ewarsize[index] = 6
					elseif x.ewarwave[index] == 5 then
						x.ewarsize[index] = 7
					elseif x.ewarwave[index] == 6 then
						x.ewarsize[index] = 8
					end
					x.ewarstate[index] = x.ewarstate[index] + 1
				--BUILD FORCE
				elseif x.ewarstate[index] == 2 then
					for index2 = 1, x.ewarsize[index] do
						while x.randompick == x.randomlast do --random the random
							x.randompick = math.floor(GetRandomFloat(1.0, 18.0))
						end
						x.randomlast = x.randompick
						if x.randompick == 1 or x.randompick == 7 or x.randompick == 13 then
							x.ewarrior[index][index2] = BuildObject("kvscout", 5, "epgfac", x.randompick)
							if x.ewarwave[index] == 3 or x.ewarwave[index] == 4 then
								GiveWeapon(x.ewarrior[index][index2], "gchana_c")
							end
						elseif x.randompick == 2 or x.randompick == 8 or x.randompick == 14 then
							x.ewarrior[index][index2] = BuildObject("kvmbike", 5, "epgfac", x.randompick)
							if x.ewarwave[index] == 2 or x.ewarwave[index] == 4 then
								GiveWeapon(x.ewarrior[index][index2], "gstbra_c")
							end
						elseif x.randompick == 3 or x.randompick == 9 or x.randompick == 15 then
							x.ewarrior[index][index2] = BuildObject("kvmisl", 5, "epgfac", x.randompick)
							if x.ewarwave[index] == 3 or x.ewarwave[index] == 5 then
								GiveWeapon(x.ewarrior[index][index2], "gfafma_c")
							end
						elseif x.randompick == 4 or x.randompick == 10 or x.randompick == 16 then
							x.ewarrior[index][index2] = BuildObject("kvtank", 5, "epgfac", x.randompick)
						elseif x.randompick == 5 or x.randompick == 11 or x.randompick == 17 then
								x.ewarrior[index][index2] = BuildObject("kvrckt", 5, "epgfac", x.randompick)
							if x.ewarwave[index] == 3 or x.ewarwave[index] == 5 then
								GiveWeapon(x.ewarrior[index][index2], "gshdwa_a") --salvo rckt
							end
						else
							x.ewarrior[index][index2] = BuildObject("kvhtnk", 5, "epgfac", x.randompick)
						end
						SetSkill(x.ewarrior[index][index2], x.skillsetting)
						if index2 % 3 == 0 then
							SetSkill(x.ewarrior[index][index2], x.skillsetting+1)
						end
						SetCommand(x.ewarrior[index][index2], 47)
						x.ewartrgt[index][index2] = nil
					end
					x.ewarabort[index] = GetTime() + 420.0 --here first in case stage goes wrong
					x.ewarstate[index] = x.ewarstate[index] + 1
				--ORDER TO STAGE PT
				elseif x.ewarstate[index] == 3 then
					if x.ewarmeet[index] == 1 then
						x.ewarmeet[index] = 2
					else
						x.ewarmeet[index] = 1
					end
					for index2 = 1, x.ewarsize[index] do
						if IsAlive(x.ewarrior[index][index2]) then
							Retreat(x.ewarrior[index][index2], ("stage%d"):format(x.ewarmeet[index]))
						end
					end
					x.ewarstate[index] = x.ewarstate[index] + 1
				--A UNIT AT STAGE PT
				elseif x.ewarstate[index] == 4 then
					for index2 = 1, x.ewarsize[index] do
						if IsAlive(x.ewarrior[index][index2]) and GetDistance(x.ewarrior[index][index2], ("stage%d"):format(x.ewarmeet[index])) < 50 then
							x.ewarstate[index] = x.ewarstate[index] + 1
							break
						end
					end
				--CONDUCT UNIT BATTLE
				elseif x.ewarstate[index] == 5 then
					for index2 = 1, x.ewarsize[index] do
						--PICK TARGET FOR EACH ATTACKER
						if IsAlive(x.ewarrior[index][index2]) and (not IsAlive(x.ewartrgt[index][index2]) or x.ewartrgt[index][index2] == nil) then
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
							x.ewarpos[index][index2] = GetPosition(x.ewartrgt[index][index2])
							if not x.ewarabortset[index] then
								x.ewarabort[index] = GetTime() + 420.0
								x.ewarabortset[index] = true
							end
							x.ewarriortime[index][index2] = GetTime() + 1.0
							x.ewarriorplan[index][index2] = 1 --hardcode for reset
						end
						--GIVE RETREAT to target (to ensure arrival) --move from stage pt to target. Attack later.
						if x.ewarriorplan[index][index2] == 1 and IsAlive(x.ewarrior[index][index2]) and x.ewarriortime[index][index2] < GetTime() then
							Retreat(x.ewarrior[index][index2], x.ewarpos[index][index2])
							x.ewarriorplan[index][index2] = x.ewarriorplan[index][index2] + 1
						end
						--CHECK TARGET STATUS, LOCATION, AND DECLOAK
						if x.ewarriorplan[index][index2] == 2 and IsAlive(x.ewarrior[index][index2]) and GetDistance(x.ewarrior[index][index2], x.ewarpos[index][index2]) < 130 then
							SetCommand(x.ewarrior[index][index2], 48)
							x.ewarriortime[index][index2] = GetTime() + 1.0
							x.ewarriorplan[index][index2] = x.ewarriorplan[index][index2] + 1
						end
						--COMMIT TO ATTACK IF TARGET STILL EXISTS
						if x.ewarriorplan[index][index2] == 3 and IsAlive(x.ewarrior[index][index2]) and GetTeamNum(x.ewarrior[index][index2]) ~= 1 and x.ewarriortime[index][index2] < GetTime() then
							if not IsAlive(x.ewartrgt[index][index2]) and IsAlive(x.frcy) then
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
              Attack(x.ewarrior[index][index2], x.ewartrgt[index][index2])
							SetCommand(x.ewarrior[index][index2], 48)
							x.ewarriortime[index][index2] = GetTime() + 1.0
							x.ewarriorplan[index][index2] = 3 --HARD RESET TO 3
						end
						--CHECK IF SQUAD MEMBER DEAD
						if not IsAlive(x.ewarrior[index][index2]) then
							x.ewarriortime[index][index2] = 99999.9
							x.ewartrgt[index][index2] = nil
							x.ewarriorplan[index][index2] = 0
							x.casualty = x.casualty + 1
						end
					end
					
					--DO CASUALTY COUNT --SPECIAL DW11
					if x.casualty >= math.floor(x.ewarsize[index] * 0.8) then --reset attack group
						x.ewarabortset[index] = false
						x.ewarabort[index] = 99999.9
						x.ewartime[index] = GetTime() + x.ewartimecool[index]
						if x.ewarwave[index] == 6 then --SPECIAL DW11
							x.ewartime[index] = 99999.9
							x.ewarmax = x.ewarmax + 1
							if x.ewarmax >= 4 then
								x.boomstate = 1
								x.waittime = GetTime() + 5.0
								x.ewardeclare = false --shut it down
							end
						end
						x.ewarstate[index] = 1 --RESET
						x.ewarabortset[index] = false
						
						for index2 = 1, x.ewarsize[index] do
							SetCommand(x.ewarrior[index][index2], 48)
						end
					end
					x.casualty = 0
					
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
							if IsAlive(x.ewarrior[index][index2]) and not IsPlayer(x.ewarrior[index][index2]) then
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

	--CHECK STATUS OF MCA 
	if not x.MCAcheck then
		--APC in trouble or KILLED
		if x.fapcstate == 0 then
			if x.fapchealth == 0 and GetCurHealth(x.fapc) < math.floor(GetMaxHealth(x.fapc) * 0.8) then
				AudioMessage("tcdw1103.wav") --APC - We're in trouble here LT
				x.fapchealth = 1
			elseif x.fapchealth == 1 and GetCurHealth(x.fapc) < math.floor(GetMaxHealth(x.fapc) * 0.5) then
				AudioMessage("tcdw1104.wav") --APC - I don't know how much more we can take LT
				x.fapchealth = 2
			elseif x.fapchealth == 2 and GetCurHealth(x.fapc) < math.floor(GetMaxHealth(x.fapc) * 0.1) then
				AudioMessage("tcdw1105.wav") --APC - going down - lost
				x.fapchealth = 3
			elseif x.fapchealth == 3 and not IsAlive(x.fapc) then
				ClearObjectives()
				AddObjective("APC Destroyed.\n\nMISSION FAILED!", "RED")
				TCC.FailMission(GetTime() + 4.0, "tcdw11f1.des") --LOSER LOSER LOSER
				x.MCAcheck = true
				x.spine = 666
			end
		end
		
		--Recycler destroyed by cra
		if not IsAlive(x.frcy) then
			AudioMessage("tcdw1106.wav") --RECY - need help - lost
			ClearObjectives()
			AddObjective("Recycler destroyed.\n\nMISSION FAILED!", "RED")
			TCC.FailMission(GetTime() + 7.0, "tcdw11f2.des") --LOSER LOSER LOSER
			x.MCAcheck = true
			x.spine = 666
		end
		
		--Engineer killed --from original fail debrief
		if x.fapcstate == 1 and not IsAlive(x.fpilot) then
			AudioMessage("alertpulse.wav")
			ClearObjectives()
			AddObjective("Engineer killed.\n\nMISSION FAILED!", "RED")
			TCC.FailMission(GetTime() + 5.0, "tcdw11f3.des") --LOSER LOSER LOSER
			x.MCAcheck = true
			x.spine = 666
		end
		
		--Recycler destroyed in blast
		if x.boomstate == 1 and x.boomtime < GetTime() then
			x.fnav[2] = BuildObject("apdwrka", 5, x.frcy)
			AudioMessage("xemt2.wav")
			Damage(x.frcy, 1000)
			SetColorFade(15.0, 0.25, "WHITE")
			ClearObjectives()
			AddObjective("Recycler caught in blast.\n\nMISSION FAILED!", "RED")
			TCC.FailMission(GetTime() + 4.0, "tcdw11f4.des") --LOSER LOSER LOSER
			x.spine = 666
			x.MCAcheck = true
		end
		
		--Portal Destroyed for some stupid reason --from original fail debrief
		if x.eprtstate == 0 and not IsAlive(x.eprt) then
			AudioMessage("alertpulse.wav")
			ClearObjectives()
			AudioMessage("Pegasus Portal destroyed.\n\nMISSION FAILED!", "RED")
			TCC.FailMission(GetTime() + 4.0, "tcdw11f5.des")
			x.spine = 666
			x.MCAcheck = true
		end
	end
end
--[[END OF SCRIPT]]