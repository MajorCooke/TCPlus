--bztcss08 - Battlezone Total Command - Stars and Stripes - 8/17 - WRANGLING THE FLEEING HERD
assert(load(assert(LoadFile("_requirefix.lua")),"_requirefix.lua"))();
TCC = require("TC_Core")
MisnNum = 13;
--DECLARE variables --p-path, f-friend, e-enemy, atk-attack, rcy-recycler
local index = 0
local indexadd = 0
local x = { --ugh, variables got rearranged
	FIRST = true, 
	MCAcheck = false, 
	player = nil, 
	mytank = nil, 
	waittime = 99999.9, 
	skillsetting = 0,
	spine = 0, 
	fally = false, 
	allartdead = false, 
	relicexists = false, 
	camartl = 0, 
	camstop1 = false, 
	camstop2 = false,
	camplay0 = false, --for 1st camera 
	camplay = {}, --for artl cameras
	camtime = 99999.9,	
  camfov = 60,  --185 default
	userfov = 90,  --seed
	charon = nil, --charon stuff
	charonfound = false, 
	warned = false, 
	warnordertime = 99999.9, 
	charonid = false, 
	whine = false, 
	etursent = false, 
	epatsent = false, 
	ffacdeployed = false, 
	ftugmsgpickup = false, 
	etugmarkonce = false, 
	etugloop = false, 
	etughasrelic = false, 
	easnbuild = false, 
	easnreset = false, 
	ekillffacbuild = false, 
	ekillffacreset = false, 
	ekillffacmarch = false, 
	ekillffacthereyet = false, 
	ekillffacthereyet2 = false, 
	ftugalive = false, 
	ecnvkillffacbuild = false, 
	ecnvkillffacreset = false, 
	order1time = 99999.9, 
	etugwaitftug = 99999.9, 
	etugcargotime = 99999.9, 
	easnbuildtime = 99999.9, 
	easnresendtime = 99999.9, 
	ekillffactime = 99999.9, 
	eturtime = 99999.9, 
	epattime = 99999.9, 
	ecnvturntime = 99999.9, 
	ecnvkillffactime = 99999.9, 
	ercy = nil, 
	efac = nil, 
	earm = nil, 
	epad = nil, 
	ecne = nil, 
	audio1 = nil, 
	farm = nil, 
	ffac = nil, 
	fcon1 = nil, 
	fcon2 = nil, 
	ftur = {}, 
	fscv = {}, 
	fnav = {}, 
	eart = {}, 
	ecnv = {}, 
	esrv = {}, 
	etug = nil, 
	relic = nil, 
	ftug = {}, --keep b/c need for MCA check
	ftugtarget = nil, 
	ftuglength = 20, --surely this is enough
	easn = {}, 
	ekillffac = {}, 
	etur = {}, 
	epat = {}, 
	repel1 = nil, 
	repelart = {},
	eartkilled = 0, 
	ecnvlength = 12, --see: BUILD AND SEND THE CCA CONVOY 
	esrvlength = 3, 
	fscvlength = 7, 
	casualty = 0, 
	ekillffaclength = 8, 
	ekillffacwave = 0, 
	randompick = 0, 
	randomlast = 0, 
	eturlength = 20, 
	epatlength = 4, --5th path exists
	fscvalive = 0, 
	pool = {}, 
	escv = {}, --scav stuff
	escvlength = 2, 
	wreckbank = false, 
	escvbuildtime = {}, 
	escvstate = {}, 
	LAST = true
}
--PATHS: pmytank, fpcam, fparm, fpfac, fpcon, fpscv1, fpmeet, epart1-6, epcam1-6, fpnav1-4, ecnv1-14, eptug, eprel, epconvoy, epturn, epgrcy, epgfac, epmeet, eptur0-19, ppatrol1-4,

function InitialSetup()
	SetAutoGroupUnits(true)
		
	local odfpreload = {
		"svartl", "svscout", "svmbike", "svmisl", "svtank", "svrckt", "svwalk", "svturr", "svtug", "svscav", "sblpad", 
		"avtank", "avfactss08", "avarmoss08", "avconsss08", "avscav", "avturr", "olyrelic02", "apcamra"
	}
	for k,v in pairs(odfpreload) do
		PreloadODF(v)
	end
		
	x.mytank = GetHandle("mytank")
	x.ercy = GetHandle("ercy")
	x.efac = GetHandle("efac")
	x.earm = GetHandle("earm")
	x.epad = GetHandle("epad")
	x.ecne = GetHandle("ecne")
	x.charon = GetHandle("charon")
	for index = 1, 3 do
		x.pool[index] = GetHandle(("pool%d"):format(index))
		x.ftur[index] = GetHandle(("ftur%d"):format(index))
		SetTeamNum(x.ftur[index], 2)
		SetSkill(x.ftur[index], x.skillsetting)
		x.fscv[index] = GetHandle(("fscv%d"):format(index))
		SetTeamNum(x.fscv[index], 2)
	end
	Ally(1, 2) --main friend units
	Ally(1, 4)
	Ally(2, 1)
	Ally(4, 1)
	Ally(4, 5)
	Ally(5, 4)
	Ally(5, 6) --AI enemy
	Ally(6, 5) --x.player ftug assassin
	SetTeamColor(6, 10, 20, 30) --assassin
	SetColorFade(6.0, 0.5, "BLACK")
	TCC.Init()
end


function Start()
	TCC.Start();
end

function Save()
	return
	index, indexadd, x, TCC.Save()
end

function Load(a, b, c, coreData)
	index = a;
	indexadd = b;
	x = c;
	TCC.Load(coreData)
end

function AddObject(h)
	if IsOdf(h, "avtug:1") then
		for indexadd = 1, x.ftuglength do
			if (x.ftug[indexadd] == nil or not IsAlive(x.ftug[indexadd])) then
				x.ftug[indexadd] = h
				SetObjectiveName(x.ftug[indexadd], ("Hauler %d"):format(indexadd))
				break
			end
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
		x.fdrppos = GetTransform(x.fdrp)
		RemoveObject(x.fdrp)
		for index = 1, 3 do
			x.pos = GetTransform(x.pool[index])
			x.fscv[index] = BuildObject("abscup", 2, x.pos)
			x.pos = GetTransform(x.ftur[index])
			RemoveObject(x.ftur[index])
			x.ftur[index] = BuildObject("avturr", 2, x.pos)
			SetSkill(x.ftur[index], x.skillsetting)
		end
		for index = 1, 6 do
			x.eart[index] = GetHandle(("eart%d"):format(index))
			x.repelart[index] = BuildObject("repelenemy100", 5, ("epart%d"):format(index))
		end
		x.waittime = GetTime() + 2.0
		x.camtime = GetTime() + 30.0
		x.camplay0 = true
    x.userfov = IFace_GetInteger("options.graphics.defaultfov")
    CameraReady()
    IFace_SetInteger("options.graphics.defaultfov", x.camfov)
		SetScrap(5, 40)
		x.spine = x.spine + 1
	end

	--START FIRST AUDIO
	if x.spine == 1 and x.waittime < GetTime() then
		AudioMessage("tcss0800.wav") --INTRO - CCA escape to Lpad, S of u. Est base at N1. Hv nu Wlkr
		x.pos = GetTransform(x.epad)
		RemoveObject(x.epad)
		x.epad = BuildObject("sblpad", 5, x.pos)
		x.waittime = GetTime() + 8.0
		x.spine = x.spine + 1
	end

	--BUILD FRIENDLY UNITS
	if x.spine == 2 and x.waittime < GetTime() then --shouldn't need to, but x.fally here bc of cam cancel issue
		x.farm = BuildObject("avarmoss08", 2, "fparm")
		Goto(x.farm, "fparm", 0)
		x.ffac = BuildObject("avfactss08", 2, "fpfac")
		Goto(x.ffac, "fpfac", 0)
		x.fcon1 = BuildObject("avconsss08", 2, "fpcon")
		Follow(x.fcon1, x.ffac, 0) --x.farm, 0)
		x.fcon2 = BuildObject("avconsss08", 2, "fpscv")
		Follow(x.fcon2, x.ffac, 0) --x.farm, 0)
		x.fscv[4] = BuildObject("avscav", 2, "fpscv")
		Follow(x.fscv[4], x.ffac, 0)
		x.fscv[5] = BuildObject("avscav", 2, "fpcon")
		Follow(x.fscv[5], x.ffac, 0)
		x.fscv[6] = BuildObject("avscav", 2, "fparm")
		Follow(x.fscv[6], x.ffac, 0)
		x.fscv[7] = BuildObject("avscav", 2, "fpcon")
		Follow(x.fscv[7], x.ffac, 0)
		x.fally = true
		x.spine = x.spine + 1
	end

	--WAIT FOR FACTORY BUILD ARTILLERY
	if x.spine == 3 and (GetDistance(x.ffac, x.player) < 100 or GetDistance(x.ffac, "fpmeet") < 100) then
		for index = 1, 6 do
			x.pos = GetTransform(x.eart[index])
			RemoveObject(x.eart[index])
			x.eart[index] = BuildObject("svartl", 5, x.pos) --("epart%d"):format(index))
			GiveWeapon(x.eart[index], "gartla", 1) --old Scion artillery... 
			GiveWeapon(x.eart[index], "gartla", 2) --b/c bztc howitzer shoots too far...
			GiveWeapon(x.eart[index], "gartla", 3) --and inital units are...
			GiveWeapon(x.eart[index], "gartla", 4) --in howitz default range...
			SetSkill(x.eart[index], x.skillsetting)
			Deploy(x.eart[index])
		end
		AudioMessage("tcss0805.wav") --19s PtA1 - Factory - U need to take out the artillery.
		x.waittime = GetTime() + 6.0 --x.wait for artillery to deploy before cinematic
		x.spine = x.spine + 1
	end

	--SETUP CAMERA FOR ARTILLERY SCENE
	if x.spine == 4 and x.waittime < GetTime() then
		x.audio1 = AudioMessage("tcss0813.wav") --19s PtA2 - Gen C. goto Nav 1. Use to get to artillery
		x.camtime = GetTime() + 3.0
		x.camartl = x.camartl + 1
    x.userfov = IFace_GetInteger("options.graphics.defaultfov")
    CameraReady()
    IFace_SetInteger("options.graphics.defaultfov", x.camfov)
	--CONTROL OF UNITS GIVEN AT END OF CAMERA
		x.spine = x.spine + 1
	end

	--DISPLAY OBJECTIVES AFTER COLLINS SHUTS UP
	if x.spine == 5 and IsAudioMessageDone(x.audio1) then
		for index = 1, 6 do
			SetObjectiveName(x.eart[index], ("Cannoneer %d"):format (index))
			SetObjectiveOn(x.eart[index])
		end
		ClearObjectives()
		AddObjective("tcss0800.txt")
		x.fnav[1] = BuildObject("apcamra", 1, "fpnav1")
		SetObjectiveName(x.fnav[1], "Artl Run")
		x.fnav[2] = BuildObject("apcamra", 1, "fpnav2")
		SetObjectiveName(x.fnav[2], "Deploy")
		x.spine = x.spine + 1
	end

	--CHECK IF ARTILLERY ARE DEAD (AND SEND ATTACKS) 
	if x.spine == 6 and not x.allartdead then
		for index = 1, 6 do
			if not IsAlive(x.eart[index]) then
				x.eartkilled = x.eartkilled + 1
			end
			if not x.epatsent and x.eartkilled == 4 then
				AudioMessage("tcss0814.wav") --OPT - CCA knows u here. Can kill CCA Rcy, but take out Art 1st
				x.eturtime = GetTime() + 180.0 --no longer artil to guard area so...
				x.epattime = GetTime() + 180.0 --send tur and pat.
				x.epatsent = true
			end
			if x.eartkilled == 6 then
				x.allartdead = true
				x.waittime = GetTime() + 2.0
				x.spine = x.spine + 1
			end
		end
		x.eartkilled = 0
	end
	
	--GIVE ORDER TO DEPLOY FACTORY AND BUILD FORCE
	if x.spine == 7 and x.waittime < GetTime() then
		AudioMessage("tcss0804.wav") --Excellent work. Setup AMUF and prep for CCA convoy
		ClearObjectives()
		AddObjective("tcss0802.txt")
		for index = 1, x.escvlength do --init escv
			x.escvbuildtime[index] = GetTime()
			x.escvstate[index] = 1
		end
		x.waittime = GetTime() + 60.0
		x.spine = x.spine + 1
	end

	--ANNOUNCE CCA 15 MINUTES OUT
	if x.spine == 8 and x.waittime < GetTime() then
		AudioMessage("tcss0801.wav") --Prescot has found Sov convoy. they 15 minutes out from lpad
		x.fnav[3] = BuildObject("apcamra", 1, "fpnav3")
		SetObjectiveName(x.fnav[3], "Convoy Cutoff")
		SetObjectiveOn(x.fnav[3])
		x.fnav[4] = BuildObject("apcamra", 1, "fpnav4")
		SetObjectiveName(x.fnav[4], "CCA Launch Pad")
		SetObjectiveOn(x.fnav[4])
		RemoveObject(x.fnav[1]) --open slot one for player to put nav at supply hangar if they wish
		x.waittime = GetTime() + 600.0
		x.spine = x.spine + 1
	end

	--ANNOUNCE CCA 5 MINUTES OUT
	if x.spine == 9 and x.waittime < GetTime() then
		AudioMessage("tcss0802.wav") --Soviet is 5 minutes from Lpad
		x.waittime = GetTime() + 300.0
		x.spine = x.spine + 1
	end

	--BUILD AND SEND THE CCA CONVOY...
	if x.spine == 10 and x.waittime < GetTime() then
		AudioMessage("tcss0803.wav") --Convoy is approaching now.
		x.ecnv[1] = BuildObject("svscout", 5, "ecnv1")
		x.ecnv[2] = BuildObject("svscout", 5, "ecnv2")
		x.ecnv[3] = BuildObject("svmbike", 5, "ecnv3")
		x.ecnv[4] = BuildObject("svmbike", 5, "ecnv4")
		x.ecnv[5] = BuildObject("svmisl", 5, "ecnv5")
		x.ecnv[6] = BuildObject("svmisl", 5, "ecnv6")
		x.ecnv[7] = BuildObject("svtank", 5, "ecnv7")
		x.ecnv[8] = BuildObject("svtank", 5, "ecnv8")
		x.ecnv[9] = BuildObject("svrckt", 5, "ecnv9")
		x.ecnv[10] = BuildObject("svrckt", 5, "ecnv10")
		x.ecnv[11] = BuildObject("svwalk", 5, "ecnv11")
		x.ecnv[12] = BuildObject("svwalk", 5, "ecnv12") --ecnv13 and ecnv14 avail
		for index = 1, x.ecnvlength do
			SetSkill(x.ecnv[index], x.skillsetting)
			Patrol(x.ecnv[index], "epconvoy")
		end
		x.etug = BuildObject("svtug", 5, "eptug")
		x.relic = BuildObject("olyrelic02", 4, "eprel")
		x.relicexists = true
		x.ecnvturntime = GetTime() + 5.0
		RemoveObject(x.repel1)
		Pickup(x.etug, x.relic)
		x.spine = x.spine + 1
	end

	--...and SEND 1ST CCA TUG ON ITS WAY
	if x.spine == 11 and HasCargo(x.etug) then
		Goto(x.etug, "epconvoy")
		x.etugcargotime = GetTime() + 10.0
		x.waittime = GetTime() + 10.0
		for index = 1, x.esrvlength do
			x.esrv[index] = BuildObject("svserv", 5, "ecnv2")
			SetSkill(x.esrv[index], x.skillsetting)
			Defend2(x.esrv[index], x.etug)
		end
		ClearObjectives()
		AddObjective("tcss0812.txt", "YELLOW")
		x.spine = x.spine + 1
	end

	--MARK TUG AND DATABASE
	if x.spine == 12 and GetDistance(x.relic, "prepel1") < 100 then
		SetObjectiveOn(x.etug)
		SetObjectiveOn(x.relic)
		x.spine = x.spine + 1
	end

	--SET THE MISSION TO SUCCESS AND END
	if x.spine == 13 and IsAlive(x.ftugtarget) and GetTug(x.relic) == x.ftugtarget and GetDistance(x.relic, x.ffac) < 40 then
		AudioMessage("tcss0808.wav") --SUCCEED -	Venus is secure
		AudioMessage("tcss0809.wav") --SUCCEED - GenC - will have scientists find out more on Furies.
		ClearObjectives()
		AddObjective("tcss0806.txt", "GREEN")
		SucceedMission(GetTime() + 14.0, "tcss08w1.des") --WINNER WINNER WINNER
		x.MCAcheck = true
		x.spine = x.spine + 1
	end
	----------END MAIN SPINE ----------

	--RUN CAMERA ON MYTANK
	if x.camplay0 then
		CameraPath("fpcam", 1500, 900, x.mytank)
	end

	--STOP CAMERA 1 by x.player or by TIME DONE
	if not x.camstop1 and (x.camtime < GetTime() or CameraCancelled()) then
    CameraFinish()
    IFace_SetInteger("options.graphics.defaultfov", x.userfov)
		x.camplay0 = false
		x.camstop1 = true
		x.camtime = 99999.9
	end

	--RUN CAMERA ON ARTILLERY
	if x.camartl > 0 and x.camartl < 7 then
		CameraPath(("epcam%d"):format(x.camartl), 3000, 1200, x.eart[x.camartl])
		if x.camtime < GetTime() then
			x.camartl = x.camartl + 1
			x.camtime = GetTime() + 3.0
			if x.camartl > 6 then
				x.camstop2 = true
			end
		end
	end

	--STOP CAMERA 2 BY PLAYER OR TIME DONE
	if x.camstop1 then
		if x.camstop2 or CameraCancelled() then
      CameraFinish()
      IFace_SetInteger("options.graphics.defaultfov", x.userfov)
			x.camstop2 = false
			SetTeamNum(x.farm, 1)
			SetGroup(x.farm, 0)
			SetTeamNum(x.ffac, 1)
			SetGroup(x.ffac, 1)
			SetTeamNum(x.fcon1, 1)
			SetGroup(x.fcon1, 8)
			SetTeamNum(x.fcon2, 1)
			SetGroup(x.fcon2, 9)
			for index = 1, 3 do
				SetTeamNum(x.ftur[index], 1)
				SetGroup(x.ftur[index], 5)
			end
			for index = 1, x.fscvlength do
				SetTeamNum(x.fscv[index], 1)
				SetGroup(x.fscv[index], 7)
			end
      SetObjectiveName(x.charon, "UNKNOWN")
		end
	end

	--HAS PLAYER FOUND CHARON
	if not x.charonfound and GetDistance(x.player, x.charon) < 120 then
		SetObjectiveOn(x.charon)
		AudioMessage("tcss0815.wav") --PtB1 - ID that object pronto
		ClearObjectives()
		AddObjective("tcss0804.txt")
		x.warnordertime = GetTime() + 20.0
		x.warned = true
		x.charonfound = true
	end

	--HAS PLAYER IDED CHARON
	if not x.charonid and IsInfo("hadcharon") and x.order1time > GetTime() then
		AudioMessage("tcss0816.wav") --PtB2 - good place to start your run
		ClearObjectives()
		AddObjective("tcss0800.txt") --PUT THESE BACK IN
		SetObjectiveName(x.charon, "Charon")
		SetObjectiveOff(x.charon)
		for index = 1, 6 do
			RemoveObject(x.repelart[index])
		end
		x.warned = false
		x.charonid = true
	end

	--SEND WARNING IF NOT FOLLOWING ORDERS
	if x.warned and x.warnordertime < GetTime() then
		AddObjective("tcss0805.txt", "YELLOW")
		x.order1time = GetTime() + 30.0
		x.warned = false
	end

	--DON'T LET PLAYER PREBUILD AT DEPLOYZONE NAV2 
	if not x.allartdead then
		if IsAlive(x.ffac) and GetDistance(x.ffac, "fpnav2") < 400 then
			Damage(x.ffac, (GetMaxHealth(x.ffac)+100))
		elseif IsAlive(x.fcon1) and GetDistance(x.fcon1, "fpnav2") < 400 then
			Damage(x.fcon1, (GetMaxHealth(x.fcon1)+100))
		elseif IsAlive(x.fcon2) and GetDistance(x.fcon2, "fpnav2") < 400 then
			Damage(x.fcon2, (GetMaxHealth(x.fcon2)+100))
		elseif IsAlive(x.farm) and GetDistance(x.farm, "fpnav2") < 400 then
			Damage(x.farm, (GetMaxHealth(x.farm)+100))
		end
	end

	--FACTORY DEPLOY TOO SOON MESSAGE but don't fail - probably'll never run
	if not x.allartdead and not x.whine and IsOdf(x.ffac, "abfactss08") then
		AudioMessage("tcss0817.wav") --Why are you building units now?
		x.whine = true
	end

	--HAS PLAYER DEPLOYED THE FACTORY CORRECTLY
	if not x.ffacdeployed and x.allartdead and IsOdf(x.ffac, "abfactss08") then
		ClearObjectives()
		AddObjective("tcss0803.txt")
		x.ekillffactime = GetTime() + 30.0
		x.ffacdeployed = true
	end

	--HIDE FIRST ETUG, THEN TURN ON LATER TUGS WITH RELIC
	if not x.etugmarkonce and x.relicexists and not IsAlive(x.etug) then
		x.etugloop = true
		x.etugmarkonce = true
	end

	--LET PLAYER KNOW A FRIENDLY TUG HAS PICKED UP THE RELIC 
	for index = 1, x.ftuglength do
		if not x.ftugmsgpickup and x.relicexists and IsAlive(x.ftug[index]) and GetTug(x.relic) == x.ftug[index] then
			x.ftugtarget = x.ftug[index]
			AudioMessage("tcss0319.wav") --4 W20 Hover tug 1 has cargo
			AudioMessage("tcss0320.wav") --3 W19 voice says Hover tug reports obj secu"RED"
			SetObjectiveName(x.ftugtarget, "PROTECT TUG")
			SetObjectiveOn(x.ftugtarget)
			x.ftugmsgpickup = true
			break
		end
	end

	--IF TUG WITH RELIC DIES OR DROPS CARGO, RESET FTUG TARGET AND PICKUP MESSAGE
	if not IsAlive(x.ftugtarget) or not HasCargo(x.ftugtarget) then
		x.ftugtarget = nil
		x.ftugmsgpickup = false
	end

	--RUN THE CCA TRACTOR TUG 
	if x.etugloop then
		--BUILD THE CCA ETUG
		if not IsAlive(x.etug) then
			x.etug = BuildObject("svtug", 5, GetPositionNear("epgrcy", 0, 16, 32)) --grpspwn
			x.etughasrelic = false
		end
		
		--IF FTUG HAS THE RELIC, HAVE ETUG FOLLOW TO GET RELIC IF FTUG DIES
		if IsAlive(x.ftugtarget) and HasCargo(x.ftugtarget) and GetNearestObject(x.ftugtarget) == x.relic and
			IsAlive(x.etug) and not HasCargo(x.etug) and x.etugwaitftug < GetTime() then
			Goto(x.etug, x.ftugtarget)
			x.etugwaitftug = GetTime() + 5.0
		end
		
		--OTHERWISE, ASSUME ETUG CAN PICKUP RELIC AND TELL IT TO
		if IsAlive(x.etug) and not HasCargo(x.etug) and x.etugcargotime < GetTime() then
			Pickup(x.etug, x.relic)
			x.etugcargotime = GetTime() + 5.0
		end
		
		--LET PLAYER KNOW CCA TUG HAS THE RELIC
		if not x.etughasrelic and IsAlive(x.etug) and GetTug(x.relic) == x.etug then --HasCargo(x.etug) then
			Goto(x.etug, "epgrcy")
			AudioMessage("tcss0327.wav") --6 CCA tug has x.relic stop it
			SetObjectiveOn(x.etug)
			x.etughasrelic = true
		end
	end

	--CONVOY ATTACKS FACTORY
	if x.relicexists and x.ecnvturntime < GetTime() then
		for index = 1, x.ecnvlength do
			if IsAlive(x.ecnv[index]) and GetTeamNum(x.ecnv[index]) ~= 1 and GetDistance(x.ecnv[index], "epturn") < 32 then
				Attack(x.ecnv[index], x.ffac)
				SetSkill(x.ecnv[index], 3)
			end
		end
		x.ecnvturntime = GetTime() + 3.0
		
		for index = 1, x.ecnvlength do
			if not IsAlive(x.ecnv[index]) or (IsAlive(x.ecnv[index]) and GetTeamNum(x.ecnv[index]) == 1) then
				x.casualty = x.casualty + 1
			end
		end
		
		if not x.ecnvkillffacreset and x.casualty >= math.floor(x.ecnvlength * 0.8) then
			x.ecnvkillffactime = GetTime() --send regular convoy attack
			x.ecnvturntime = 99999.9
		end
		x.casualty = 0
	end

	--CCA CONVOY GROUP KILL FRIENDLY FACTORY
	if x.ecnvkillffactime < GetTime() then
		if not x.ecnvkillffacbuild then
			for index = 1, x.ecnvlength do
				if not IsAlive(x.ecnv[index]) or (IsAlive(x.ecnv[index]) and GetTeamNum(x.ecnv[index]) == 1) then
					x.casualty = x.casualty + 1
				end
			end

			if not x.ecnvkillffacreset and x.casualty >= math.floor(x.ecnvlength * 0.8) then
				x.ecnvkillffacbuild = true
				x.ecnvkillffacreset = true
			end
			x.casualty = 0
		end

		if x.ecnvkillffacbuild then
			x.ecnvlength = 4 --reduce size of recurring convoy attack
			for index = 1, x.ecnvlength do
				while x.randompick == x.randomlast do --random the random
					x.randompick = math.floor(GetRandomFloat(1.0, 12.0))
				end
				x.randomlast = x.randompick
				
				if x.randompick == 1 or x.randompick == 6 or x.randompick == 11 then
					x.ecnv[index] = BuildObject("svscout", 5, GetPositionNear("prepel1", 0, 16, 32)) --grpspwn  --"prepel1")
				elseif x.randompick == 2 or x.randompick == 7 or x.randompick == 12 then
					x.ecnv[index] = BuildObject("svmbike", 5, GetPositionNear("prepel1", 0, 16, 32)) --grpspwn
				elseif x.randompick == 3 or x.randompick == 8 then
					x.ecnv[index] = BuildObject("svmisl", 5, GetPositionNear("prepel1", 0, 16, 32)) --grpspwn
				elseif x.randompick == 4 or x.randompick == 9 then
					x.ecnv[index] = BuildObject("svtank", 5, GetPositionNear("prepel1", 0, 16, 32)) --grpspwn
				else
					x.ecnv[index] = BuildObject("svrckt", 5, GetPositionNear("prepel1", 0, 16, 32)) --grpspwn
				end
				SetSkill(x.ecnv[index], x.skillsetting)
				Attack(x.ecnv[index], x.ffac)
				x.ecnvkillffactime = GetTime() + 60.0
				x.ecnvkillffacreset = false
				x.ecnvkillffacbuild = false
			end
		end
	end

	--RUN THE PLAYER FTUG TARGET ASSASSIN SQUAD
	if x.etugloop then
		if not x.easnbuild then
			for index = 1, 2 do
				if not IsAlive(x.easn[index]) then
					x.casualty = x.casualty + 1
				end
			end
			if x.casualty == 2 and not x.easnreset then
				x.easnbuildtime = GetTime() + 5.0
				x.easnbuild = true
				x.easnreset = true
			end
			x.casualty = 0
		end

		if x.easnbuild and x.easnbuildtime < GetTime() then
			for index = 1, 2 do
				x.easn[index] = BuildObject("svtank", 6, "ecnv1")
				SetSkill(x.easn[index], x.skillsetting)
				SetObjectiveName(x.easn[index], ("Assassin %d"):format(index))
			end
			x.easnresendtime = GetTime()
			x.easnreset = false
			x.easnbuild = false
		end

		if x.easnresendtime < GetTime() then
			for index = 1, 2 do
				if IsAlive(x.easn[index]) then
          x.player = GetPlayerHandle()
					if IsAlive(x.ftugtarget) and GetTeamNum(x.easn[index]) ~= 1 then
						Attack(x.easn[index], x.ftugtarget)
					elseif GetTeamNum(x.easn[index]) ~= 1 then
						Attack(x.easn[index], x.player)
					end
					x.easnresendtime = GetTime() + 7.0
				end
			end
		end
	end

	--CCA GROUP KILL FRIENDLY FACTORY 
	if x.ekillffactime < GetTime() and IsAlive(x.ercy) and IsAlive(x.efac) then
		if not x.ekillffacbuild then
			for index = 1, x.ekillffaclength do
				if not IsAlive(x.ekillffac[index]) or (IsAlive(x.ekillffac[index]) and GetTeamNum(x.ekillffac[index]) == 1) then
					x.casualty = x.casualty + 1
				end
			end

			if not x.ekillffacreset and x.casualty >= math.floor(x.ekillffaclength * 0.8 )then
				x.ekillffacbuild = true
				x.ekillffacreset = true
				x.ekillffacwave = x.ekillffacwave + 1
				if x.ekillffacwave <= 3 then
					x.ekillffaclength = 2
				elseif x.ekillffacwave > 3 and x.ekillffacwave <= 6 then
					x.ekillffaclength = 4
				elseif x.ekillffacwave > 6 and x.ekillffacwave <= 9 then
					x.ekillffaclength = 6
				else
					x.ekillffaclength = 8
				end
			end
			x.casualty = 0
		end

		if x.ekillffacbuild then
			for index = 1, x.ekillffaclength do
				while x.randompick == x.randomlast do --random the random
					x.randompick = math.floor(GetRandomFloat(1.0, 14.0))
				end
				x.randomlast = x.randompick
				
				if x.randompick == 1 or x.randompick == 7 or x.randompick == 11 then
					x.ekillffac[index] = BuildObject("svscout", 5, "egprcy")
				elseif x.randompick == 2 or x.randompick == 8 or x.randompick == 12 then
					x.ekillffac[index] = BuildObject("svmbike", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
				elseif x.randompick == 3 or x.randompick == 9 or x.randompick == 13 then
					x.ekillffac[index] = BuildObject("svmisl", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
				elseif x.randompick == 4 or x.randompick == 10 or x.randompick == 14 then
					x.ekillffac[index] = BuildObject("svtank", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
				elseif x.randompick == 5 then
					x.ekillffac[index] = BuildObject("svrckt", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
				else
					if x.ekillffacwave < 5 then --don't hit with walkers too soon
						x.ekillffac[index] = BuildObject("svtank", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
					else
						x.ekillffac[index] = BuildObject("svwalk", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
					end
				end
				SetSkill(x.ekillffac[index], x.skillsetting)
				Attack(x.ekillffac[index], x.ffac)
				x.ekillffactime = GetTime() + 80.0  --90.0
				x.ekillffacreset = false
				x.ekillffacbuild = false
			end
		end
	end

	--CCA GROUP TURRET GENERIC --old simple style code
	if x.eturtime < GetTime() then
		for index = 1, x.eturlength do
			if not IsAlive(x.etur[index]) then
				x.etur[index] = BuildObject("svturr", 5, GetPositionNear("epgrcy", 0, 16, 32)) --grpspwn
				SetSkill(x.etur[index], x.skillsetting)
				Goto(x.etur[index], ("eptur%d"):format(index))
			end
		end
		x.eturtime = GetTime() + 240.0  --180.0
	end

	--CCA GROUP SCOUT PATROLS --old simple style code
	if x.epattime < GetTime() then
		for index = 1, x.epatlength do
			if not IsAlive(x.epat[index]) then
				x.epat[index] = BuildObject("svscout", 5, ("ppatrol%d"):format(index))
				SetSkill(x.epat[index], x.skillsetting)
				Patrol(x.epat[index], ("ppatrol%d"):format(index))
				--SetObjectiveName(x.epat[index], ("Patrol %d"):format(index))
			end
		end
		x.epattime = GetTime() + 180.0
	end
	
	--AI GROUP SCAVENGERS
	if IsAlive(x.ercy) then
		if GetScrap(5) > 39 and not x.wreckbank then --no daywrecker but leave
			SetScrap(5, 0)
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

	--CHECK STATUS OF MISSION-CRITICAL ASSETS (MCA)
	if not x.MCAcheck then		
		if not x.allartdead and not IsAround(x.mytank) then --lost tank b4 artl killed
			FailMission(GetTime() + 4.0, "tcss08f5.des") --LOSER LOSER LOSER
			ClearObjectives()
			AddObjective("tcss0813.txt", "RED") --MCA fail
			x.spine = 666
			x.MCAcheck = true
		end
		
		if not x.charonid and x.order1time < GetTime() then --failed to follow orders
			AudioMessage("tcss0394.wav") --9 FAIL – time up for follow order orig bz1 0694 copy of ss0594
			FailMission(GetTime() + 11.0, "failordr.des") --LOSER LOSER LOSER
			ClearObjectives()
			AddObjective("failordr.txt", "RED")
			x.spine = 666
			x.MCAcheck = true
		end
		
		if x.relicexists and not IsAlive(x.relic) then --relic destroyed
			AudioMessage("tcss0806.wav") --FAIL - Flight log x.relic destroyed.
			FailMission(GetTime() + 7.0, "tcss08f1.des") --LOSER LOSER LOSER
			ClearObjectives()
			AddObjective("tcss0308.txt", "RED") --The object has been destroyed. Mission FAILED.
			x.spine = 666
			x.MCAcheck = true
		end
		
		if IsAlive(x.relic) and GetDistance(x.relic, x.epad) < 64 then --CCA got relic
			AudioMessage("tcss0807.wav") --FAIL - CCA escaped to lpad
			FailMission(GetTime() + 7.0, "tcss08f2.des") --LOSER LOSER LOSER
			ClearObjectives()
			AddObjective("tcss0309.txt", "RED") --CCA captured relic. Mission FAILED.
			x.spine = 666
			x.MCAcheck = true
		end
		
		if x.fally and not IsAlive(x.ffac) then --Factory destroyed
			AudioMessage("tcss0811.wav") --FAIL - AMUF lost
			FailMission(GetTime() + 6.0, "tcss08f3.des") --LOSER LOSER LOSER
			ClearObjectives()
			AddObjective("tcss0807.txt", "RED") --Your Factory was destroyed. MISSION FAILEDnot 
			x.spine = 666
			x.MCAcheck = true
		end
		
		if x.fally then --lost too many MCA before convoy arrives
			x.fscvalive = 0 --reset
			x.ftugalive = false --reset
			
			for index = 1, x.fscvlength do
				if IsAlive(x.fscv[index]) then
					x.fscvalive = x.fscvalive + 1
				end
			end
			
			for index = 1, x.ftuglength do
				if IsAlive(x.ftug[index]) then
					x.ftugalive = true
				end
			end
			
			if not x.relicexists and x.fscvalive < 3 then
				FailMission(GetTime() + 4.0, "tcss08f4.des") --LOSER LOSER LOSER
				ClearObjectives()
				AddObjective("tcss0808.txt", "RED") --You lost too many scavengers to be able to continue.
				x.spine = 666
				x.MCAcheck = true
			end
			
			if x.relicexists and not x.ftugalive and x.fscvalive < 2 then
				FailMission(GetTime() + 4.0, "tcss08f5.des") --LOSER LOSER LOSER
				ClearObjectives()
				AddObjective("tcss0809.txt", "RED") --MCA fail
				x.spine = 666
				x.MCAcheck = true
			end
			
			if not x.allartdead and not IsAlive(x.fcon1) and not IsAlive(x.fcon2) then
				FailMission(GetTime() + 4.0, "tcss08f5.des") --LOSER LOSER LOSER
				ClearObjectives()
				AddObjective("tcss0810.txt", "RED") --No tug to be able to continue.
				x.spine = 666
				x.MCAcheck = true
			end
		end
		
		if not IsAlive(x.epad) and not IsAlive(x.ftugtarget) then --CCA launch pad destroyed
			AudioMessage("tcss0818.wav") --FAIL - LPad destroyed
			FailMission(GetTime() + 12.0, "tcss08f6.des") --LOSER LOSER LOSER
			ClearObjectives()
			AddObjective("tcss0811.txt", "RED") --You destroyed the CCA launch pad. MISSION FAILED 
			x.spine = 666
			x.MCAcheck = true
		end
		
		if not IsAlive(x.epad) and IsAlive(x.ecne) then --KILL CCA ROCKET WITH LPAD
			Damage(x.ecne, 15000)
		end
	end
end
--[[END OF SCRIPT]]