--bztcss05 - Battlezone Total Command - Stars and Stripes - 5/17 - ESCAPE FROM MARS
assert(load(assert(LoadFile("_requirefix.lua")),"_requirefix.lua"))();
TCC = require("TC_Core")
MisnNum = 9;
--DECLARE variables --p-path, f-friend, e-enemy, atk-attack, rcy-recycler
local index = 0
local x = {
	FIRST = true,
	getiton = false, 
	MCAcheck = false, 
	pos = {}, 
	waittime = 99999.9, 
	player = nil, 
	mytank = nil, 
	skillsetting = 0,  
	fnav = nil, 
	audio1 = nil, 
	audio2 = nil, 
  camfov = 60,  --185 default
	userfov = 90,  --seed
	spine = 0,	
	casualty = 0, 
	randompick = 0, 
	randomlast = 0, 
	ekillfrcyreset = false, 
	ekillfrcybuild = false, 
	failstate = {false, false, false, false}, 
	frcydeploy = false, 
	check = {false, false, false}, 
	checktimer = {}, 
	ccafound = false, 
	efinalreset = false, 
	efinalbuild = false, 
	runcine2 = false, 
	runcine3 = false, 
	epadclear = false, 
	ecnedone = false, 
	warn1time = 99999.9, 
	warn2time = 99999.9, 
	warn3time = 99999.9, 
	order1time = 99999.9, 
	einitbuilt = false, 
	einittime = 99999.9, 
	einittimecine = 99999.9,
	eblttime = 99999.9, 
	ekillfrcytime = 99999.9, 
	ekillfrcyresendtime = 99999.9, 
	epattime = 99999.9, 
	efinaltime = 99999.9, 
	efinalresendtime = 99999.9, 
	frcy = nil, 
	ercy = nil, 
	efac = nil, 
	epad = nil, 
	ecne = nil, 
	gotcone = false, 
	heph = nil, 
	ftnk = {}, 
	eblt = {}, 
	etur = nil, 
	ekillfrcy = {}, 
	epat = {}, 
	efinal = {}, 
	f5pt = {},	
	e5pt = {}, 
	ekillfrcywave = 0, 
	ebltlength = 31, 
	ekillfrcylength = 20, 
	epatlength = 6, 
	efinallength = 20, 
	camheight = 1500,
	plyrhealth = 3500,
	frcyhealth = 10000,
	dummyobj0 = nil, 
	dummyobj1 = nil,
	dummyfound0 = false, 
	sbconeset = false,
	LAST = true
}
--PATHS: pmytank, eprcy, epfac, pblt0-30, ercyspn, efacspn, eppad, psim1-5, pmis1-5, pcam1-2, fpnav0-1, prepel1, epart1-4, pdust, pdrop, pplt1-10, eptur1-12, ppatrol1-6, notused> fprcy, fpcons, fg1, fg2, eppwr1-4, epg1, proute1, pcams

function InitialSetup()
	SetAutoGroupUnits(true)
	
	local odfpreload = {
		"avrecyss05", "avscout", "avmbike", "avmisl", "avtank", "svscout", "svmbike", "svmisl", "svtank", "svrckt", "svartl", "svturr", "sblpad2", "sbcone1", "sbcone", "avdrop", "apcamra"
	}
	for k,v in pairs(odfpreload) do
		PreloadODF(v)
	end
	
	Ally(1, 2)
	Ally(2, 1) --2 5th platoon
	Ally(5, 6) 
	Ally(6, 5) --6 cca cineractive
	SetTeamColor(2, 150, 150, 20)
	x.looky = GetHandle("looky")
	x.ercy = GetHandle("ercy")
	x.efac = GetHandle("efac")
	x.epad = GetHandle("epad")
	x.heph = GetHandle("heph")  
  for index = 1, 5 do
    x.f5pt[index] = GetHandle(("f5pt%d"):format(index))
    x.e5pt[index] = GetHandle(("e5pt%d"):format(index))
  end
	SetColorFade(6.0, 0.5, "BLACK")
	TCC.Init()
end

function Start()
	TCC.Start();
end

function Save()
	return
	index, x, TCC.Save()
end

function Load(a, c, coreData)
	index = a;
	x = c;
	TCC.Load(coreData)
end

function AddObject(h)
	if IsOdf(h, "aspilo") and GetTeamNum(h) == 2 then
		RemoveObject(h)
	end
	
	if IsOdf(h, "sspilo") and GetTeamNum(h) == 6 then
		RemoveObject(h)
	end
	
	if not x.dummyfound0 and IsOdf(h, "dummy00") then
		x.dummyobj0 = h
		x.dummyfound0 = true
	end
	
	if not x.gotcone and IsOdf(h, "sbcone1") then
		x.ecne = h
		x.gotcone = true
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
	SetCurHealth(x.ercy, GetMaxHealth(x.ercy)) --want to keep these alive
	SetCurHealth(x.efac, GetMaxHealth(x.efac))
	SetCurHealth(x.epad, GetMaxHealth(x.epad))
	TCC.Update()
	
	--START THE MISSION BASICS
	if x.spine == 0 then
    x.pos = GetTransform(x.f5pt[1])
    RemoveObject(x.f5pt[1])
		x.f5pt[1] = BuildObject("avtank", 2, x.pos)  --"psim1")
    x.pos = GetTransform(x.f5pt[2])
    RemoveObject(x.f5pt[2])
		x.f5pt[2] = BuildObject("avscout", 2, x.pos)  --"psim2")
    x.pos = GetTransform(x.f5pt[3])
    RemoveObject(x.f5pt[3])
		x.f5pt[3] = BuildObject("avmbike", 2, x.pos)  --"psim3")
    x.pos = GetTransform(x.f5pt[4])
    RemoveObject(x.f5pt[4])
		x.f5pt[4] = BuildObject("avmisl", 2, x.pos)  --"psim4")
    x.pos = GetTransform(x.f5pt[5])
    RemoveObject(x.f5pt[5])
		x.f5pt[5] = BuildObject("avscout", 2, x.pos)  --"psim5")
    x.pos = GetTransform(x.e5pt[1])
    RemoveObject(x.e5pt[1])
		x.e5pt[1] = BuildObject("svtank", 6, x.pos)  --"pmis1")
    x.pos = GetTransform(x.e5pt[2])
    RemoveObject(x.e5pt[2])
		x.e5pt[2] = BuildObject("svscout", 6, x.pos)  --"pmis2")
    x.pos = GetTransform(x.e5pt[3])
    RemoveObject(x.e5pt[3])
		x.e5pt[3] = BuildObject("svmbike", 6, x.pos)  --"pmis3")
    x.pos = GetTransform(x.e5pt[4])
    RemoveObject(x.e5pt[4])
		x.e5pt[4] = BuildObject("svmisl", 6, x.pos)  --"pmis4")
    x.pos = GetTransform(x.e5pt[1])
    RemoveObject(x.e5pt[5])
		x.e5pt[5] = BuildObject("svscout", 6, x.pos)  --"pmis5")
		x.ftnk[1] = BuildObject("avtank", 1, "fpg1")
		x.ftnk[2] = BuildObject("avtank", 1, "fpg2")
		x.ftnk[3] = BuildObject("avtank", 1, "fpg3")
		x.frcy = BuildObject("avrecyss05", 1, "fprcy")
		x.mytank = BuildObject("avtank", 1, "pmytank")
		SetCurHealth(x.f5pt[1], 15000)  	
		for index = 1, 5 do
			SetCurHealth(x.e5pt[index], 2000)
			Attack(x.f5pt[index], x.e5pt[index],1)
			Attack(x.e5pt[index], x.f5pt[index],1)
		end	
		for index = 1, 6 do 
			x.checktimer[index] = false
		end
		x.audio1 = AudioMessage("tcss0501.wav") --Cmd simms in fight at OlyMons ruins. Esc Wyoming. CCA base N
		for index = 1, 3 do
			SetSkill(x.ftnk[index], x.skillsetting)
			SetGroup(x.ftnk[index],0)
			LookAt(x.ftnk[index], x.looky, 0)
		end
		SetSkill(x.frcy, x.skillsetting)
		SetGroup(x.frcy,1)
		LookAt(x.frcy, x.looky, 0)
		LookAt(x.mytank, x.looky, 0)
    x.userfov = IFace_GetInteger("options.graphics.defaultfov")
    CameraReady()
    IFace_SetInteger("options.graphics.defaultfov", x.camfov)
		x.spine = x.spine + 1
	end

	--RUN THE INTRO CINERACTIVE OF THE 5TH PLATOON
	if x.spine == 1 then
		CameraPath("pcam0", x.camheight, 2200, x.f5pt[1]) --KEEP OUTSIDE OF "NESTED IF LOOP" so that it runs until quit or done
		x.camheight = x.camheight + 10 --camera goes up as it moves
		SetCurHealth(x.f5pt[1], 15000)
		if CameraCancelled() or IsAudioMessageDone(x.audio1) then
      CameraFinish()
      IFace_SetInteger("options.graphics.defaultfov", x.userfov)
			RemoveObject(x.cam1)
			for index = 1, 5 do
				if IsAlive(x.f5pt[index]) then
					RemoveObject(x.f5pt[index])
				end
				if IsAlive(x.e5pt[index]) then
					RemoveObject(x.e5pt[index])
				end
			end
			SetColorFade(6.0, 0.5, "BLACK")
			x.spine = x.spine + 1
		end
	end

	--SETUP MISSION AFTER CINERACTIVE
	if x.spine == 2 then
		SetAsUser(x.mytank, 1)
		RemoveObject(x.player)
		x.player = GetPlayerHandle()
		SetTeamNum(x.player, 1)--JUST IN CASE
		x.pos = GetTransform(x.epad)
		RemoveObject(x.epad)
		x.epad = BuildObject("sblpad2", 5, x.pos)
		SetScrap(1, 40)
		SetScrap(5, 40)
		x.fnav = BuildObject("olylemnosa", 0, "fpnav0")
		SetObjectiveName(x.fnav, "5th Platoon")
		SetObjectiveOn(x.fnav)
		ClearObjectives()
		AddObjective("tcss0500.txt")
		x.epattime = GetTime()
		x.spine = x.spine + 1
	end

	--GO CHECK OUT HEPHESTUS
	if x.spine == 3 and GetDistance(x.player, x.heph) < 650 then
		x.audio1 = AudioMessage("tcss0502.wav") --Cpl Buzz - Skyeye has pickeup obj. Lt Corb send player there.
		SetObjectiveName(x.heph, "Investigate")
		SetObjectiveOn(x.heph)
		ClearObjectives()
		AddObjective("tcss0501.txt")
		x.warn1time = GetTime() + 20.0
		x.order1time = GetTime() + 60.0
		x.failstate[1] = true
		x.spine = x.spine + 1
	end

	--SETUP HEPHESTUS CINERACTIVE
	if x.spine == 4 and GetDistance(x.player, x.heph) < 200 then
		Stop(x.frcy, 0)
		for index = 1, 3 do
		 Stop(x.ftnk[index], 0)
		end
		x.warn1time = 99999.9
		x.order1time = 99999.9
		x.failstate[1] = false
		SetObjectiveOff(x.heph)
		SetObjectiveName(x.heph, "Hephestus") --reset name
		x.audio1 = AudioMessage("tcss0503.wav") --Look at size. Gen, Grz 1 found x.hephestus
		x.camheight = 3000
    x.userfov = IFace_GetInteger("options.graphics.defaultfov")
    CameraReady()
    IFace_SetInteger("options.graphics.defaultfov", x.camfov)
		x.spine = x.spine + 1
	end

	--PLAY HEPHESTUS CINERACTIVE
	if x.spine == 5 then
		CameraPath("pcam1", x.camheight, 3500, x.heph) --KEEP OUTSIDE OF "NESTED IF LOOP" so that it runs until quit or done
		x.camheight = x.camheight + 60
		if CameraCancelled() or IsAudioMessageDone(x.audio1) then
      CameraFinish()
      IFace_SetInteger("options.graphics.defaultfov", x.userfov)
			x.audio1 = AudioMessage("tcss0504.wav") --Gen Col - inspect ship
			ClearObjectives()
			AddObjective("tcss0501.txt", "GREEN")
			AddObjective("	")
			AddObjective("tcss0502.txt") --inspect x.heph with i key
			SetObjectiveOn(x.heph)
			x.warn2time = GetTime() + 20.0
			x.order1time = GetTime() + 30.0
			x.failstate[2] = true
			x.spine = x.spine + 1
		end
	end

	--ID HEPHESTUS
	if x.spine == 6 and IsInfo("olyhephb") and GetDistance(x.player, x.heph) < 300 then --precaution to insure x.player IDs correct x.hephestus
		for index = 1, 3 do
			Follow(x.ftnk[index], x.player, 0)
		end
		SetObjectiveOff(x.heph)
		AudioMessage("tcss0505.wav") --Gen Col - stdby. Goto nav 1. Recon starport.
		AudioMessage("tcss0506.wav") --Buz - But Gen. the 5th."
		x.audio1 = AudioMessage("tcss0507.wav") --GenC - I'm aware., but you have orders Griz 1.
		x.warn2time = 99999.9
		x.order1time = 99999.9
		x.failstate[2] = false
		x.eart1 = BuildObject("svartl", 5, "epart1")  	--"epart3" and "epart4" available
		SetSkill(x.eart1, x.skillsetting)
		x.eart2 = BuildObject("svartl", 5, "epart2")
		SetSkill(x.eart2, x.skillsetting)
		x.etur = BuildObject("svturr", 5, "eptur1") --"eptur3" - "eptur12" available
		SetSkill(x.etur, x.skillsetting)
		x.etur = BuildObject("svturr", 5, "eptur2")
		SetSkill(x.etur, x.skillsetting)
		x.etur = BuildObject("svturr", 5, "eptur6")
		SetSkill(x.etur, x.skillsetting)
		x.etur = BuildObject("svturr", 5, "eptur7")
		SetSkill(x.etur, x.skillsetting)
		x.spine = x.spine + 1
	end

	--ORDER TO STARPORT
	if x.spine == 7 and IsAudioMessageDone(x.audio1) then
		SetObjectiveOff(x.fnav) --turn off 5th plt beacon
		RemoveObject(x.fnav)
		x.fnav = BuildObject("apcamra", 1, "fpnav1")
		SetObjectiveName(x.fnav, "Recon Starport")
		SetObjectiveOn(x.fnav)
		ClearObjectives()
		AddObjective("tcss0502.txt", "GREEN")
		AddObjective("	")
		AddObjective("tcss0503.txt")
		--Goto(x.frcy, "fpnav1", 0)
    Follow(x.frcy, x.player, 0)
    for index = 1, 3 do
      if x.ftnk[index] ~= x.player then
        Follow(x.ftnk[index], x.player, 0)
      end
    end
		x.order1time = GetTime() + 240.0
		x.warn3time = GetTime() + 180.0
		x.failstate[3] = true
		x.spine = x.spine + 1
	end

	--ORDER TO ID BUILDINGS
	if x.spine == 8 and GetDistance(x.player, "fpnav1") < 300 then
		SetObjectiveOff(x.fnav)
		AudioMessage("tcss0508.wav") --Search each struct. Locate flightlog database.
		ClearObjectives()
		AddObjective("tcss0503.txt", "GREEN")
		AddObjective("	")
		AddObjective("tcss0507.txt")
		x.order1time = GetTime() + 240.0
		x.failstate[3] = false
		x.failstate[4] = true
		x.spine = x.spine + 1
	end

	--CHECK PLAYER HAS ID BUILDINGS
	if x.spine == 9 then
		if not x.check[1] and IsInfo("olyomg1") then
			x.check[1] = true
			x.warn3time = 99999.9
		elseif not x.check[2] and IsInfo("olyomg2") then
			x.check[2] = true
			x.warn3time = 99999.9
		elseif not x.check[3] and IsInfo("olyomg3") then
			x.check[3] = true
			x.warn3time = 99999.9
		elseif x.check[1] and x.check[2] and x.check[3] then
			x.order1time = 99999.9
			x.failstate[4] = false
			x.waittime = GetTime() + 3.0
			x.spine = x.spine + 1
		end
	end

	--ORDER TO SETUP BASE
	if x.spine == 10 and x.waittime < GetTime() then
		AudioMessage("tcss0512.wav") --Gen., Cmd Simmns, report CCA retreating to canyn base
		AudioMessage("tcss0513.wav") --GenC - know we here, prtcting fltlog. Build base hold for orders
		ClearObjectives()
		AddObjective("tcss0507.txt", "GREEN")
		AddObjective("	")
		AddObjective("tcss0504.txt")
		x.fnav = BuildObject("apcamra", 1, "ppool1")
		SetObjectiveName(x.fnav, "Bio-Metal pool 1")
		x.fnav = BuildObject("apcamra", 1, "ppool2")
		SetObjectiveName(x.fnav, "Bio-Metal pool 2")
		x.waittime = GetTime() + 360.0
		x.spine = x.spine + 1
	end

	--NOTIFY CCA GOT AWAY WITH LOG AND SETUP LAUNCH CUTSCENE
	if x.spine == 11 and x.waittime < GetTime() then
		x.audio1 = AudioMessage("tcss0514.wav") --Skyeye reports transport is lifting off from CCA
		x.sbconeset = true
		x.camheight = 50.0
		x.spine = x.spine + 1
	end
	
	--LAUNCH CUTSCENE FINAL PREP
	if x.spine == 12 and IsAudioMessageDone(x.audio1) then
		if x.sbconeset then
			x.pos = GetTransform(x.ecne)
			RemoveObject(x.ecne)
			x.ecne = BuildObject("sbcone", 5, x.pos)
			SetAnimation(x.ecne, "launch", 1)
			StartEarthQuake(50)
      x.userfov = IFace_GetInteger("options.graphics.defaultfov")
      CameraReady()
      IFace_SetInteger("options.graphics.defaultfov", x.camfov)
			x.waittime = GetTime() + 14.0
			x.camheight = -50
			x.plyrhealth = GetCurHealth(x.player) --don't let player or frcy take damage...
			x.frcyhealth = GetCurHealth(x.frcy) --...while cineractive is running
			x.fnav = BuildObject("dummy00", 1, "pcams2")
			x.spine = x.spine + 1
		end
	end
	
	--RUN LAUNCH CUTSCENE
	if x.spine == 13 then
		SetCurHealth(x.player, x.plyrhealth)
		SetCurHealth(x.frcy, x.frcyhealth)
		x.camheight = x.camheight + 0.05
		--CameraObject(x.fnav, -50, -50, 0, x.dummyobj1)
		--CameraObject(x.fnav, x.camheight, x.camheight, 30, x.dummyobj1)
		CameraPath("pcams", -30, 1000, x.dummyobj0)
		if CameraCancelled() or x.waittime < GetTime() then
      CameraFinish()
      IFace_SetInteger("options.graphics.defaultfov", x.userfov)
			StopEarthQuake()
			RemoveObject(x.dummyobj0)
			RemoveObject(x.dummyobj1)
			x.ecnedone = true
			RemoveObject(x.ecne)
			RemoveObject(x.fnav)
			x.waittime = GetTime() + 2.0
			x.spine = x.spine + 1
		end
	end

	--ORDER TO RECON CCA LPAD
	if x.spine == 14 and x.waittime < GetTime() then
		x.audio1 = AudioMessage("tcss0528.wav") --Transport has escaped. Recon Lpad. have 9 minutes
		ClearObjectives()
		AddObjective("tcss0504.txt", "DKGREY") --keep up but fade out in dkdrey
		AddObjective("	")
		AddObjective("tcss0505.txt", "CYAN")
		x.spine = x.spine + 1
	end

	--START COCKPIT TIMER FOR RECON SEGMENT
	if x.spine == 15 and IsAudioMessageDone(x.audio1) then
		--SetObjectiveOn(x.epad)
    x.fnav = BuildObject("apcamra", 1, "eptur4")
    SetObjectiveName(x.fnav, "Recon Launch Pad")
    SetObjectiveOn(x.fnav)
		StartCockpitTimer(720, 280, 180) --12M > 720	9M > 540
		HideCockpitTimer() --YES, HIDDEN, OOH THE DRAMA OF NOT KNOWING
		x.checktimer[1] = true
		x.checktimer[2] = true
		x.checktimer[6] = true
		--x.checktimer3-5 are in a later section
		x.spine = x.spine + 1
	end

	--CHECK CCA LPAD RECON AND IF SO, NEW ORDERS
	if x.spine == 16 and IsInfo("sblpad2") then -- and GetDistance(x.player, x.epad) < 200
		x.epadclear = true --okay ya can blow up launchpad if you want to ... though why?
		for index = 1, 6 do
			x.checktimer[index] = false
		end
		StopCockpitTimer()
		HideCockpitTimer()
		--SetObjectiveOff(x.epad)
    SetObjectiveOff(x.fnav)
    RemoveObject(x.fnav)
		AudioMessage("tcss0529.wav") --Gen, Grz1 has recon lpad
		AudioMessage("tcss0547.wav") --OPT - Good job, CCA breaking off. Move forces to dustoff.
		AudioMessage("tcss0530.wav") --Gen - Good work. Get Wyom to dust off site.
		ClearObjectives()
		AddObjective("tcss0505.txt", "GREEN")
		AddObjective("	")
		AddObjective("tcss0506.txt")
		AddObjective("tcss0508.txt", "ALLYBLUE")
		AddObjective("tcss0508b.txt", "YELLOW")
		x.spine = x.spine + 1
	end

	--CHECK PLAYER BACK AT RECYCLER AND IF SO, NEW ORDERS
	if x.spine == 17 and ((IsAlive(x.frcy) and GetDistance(x.player, x.frcy) < 600) or (GetDistance(x.player, "pdust") < 400)) then
		AudioMessage("tcss0531.wav") --3 min before CCA platoon arrives.
		x.ekillfrcytime = 99999.9
    AudioMessage("emdotcox.wav")
    ClearObjectives()
    AddObjective("-CCA reinforcements coming from the South.\n-Upgrade Wyoming and get to Dustoff.\nDefend canyon entrance with guntowers and tanks.")
    StartCockpitTimer(180, 90, 60)
    x.efinaltime = GetTime() + 181.0
		x.spine = x.spine + 1
	end

	--IS FRCY AT THE DUSTOFF SITE
	if x.spine == 18 and IsAlive(x.frcy) and GetDistance(x.frcy, "pdust") <= 100 then
    StopCockpitTimer()
		HideCockpitTimer()
    AudioMessage("emdotcox.wav")
    ClearObjectives()
    AddObjective("Defend Wyoming.\nBig Betty arriving in 6 minutes.")
		x.waittime = GetTime() + 360.0
		x.spine = x.spine + 1
	end

	--IF FRCY STILL AT DUSTOFF, PLAY DROPSHIP LANDING
	if x.spine == 19 and x.waittime < GetTime() and IsAlive(x.frcy) and GetDistance(x.frcy, "pdust") <= 100 then 
		x.ftnk[4] = BuildObject("avdrop", 0, "pdrop")
		SetAnimation(x.ftnk[4], "land", 1)
		x.waittime = GetTime() + 15.0
		x.spine = x.spine + 1
	end

	--SUCCEED MISSION
	if x.spine == 20 and x.waittime < GetTime() then
		x.MCAcheck = true
		SucceedMission(GetTime() + 7.0, "tcss05w1.des") --WINNER WINNER WINNER
		AudioMessage("tcss0549.wav") --SUCCESS - Good job cmd. Transport in route
		ClearObjectives()
		AddObjective("tcss0509.txt", "GREEN")
		x.spine = 666
	end
	----------END MAIN SPINE ----------

	--IMPORTANT THINGS THAT NEED TO RUN ONCE
	if not x.getiton then
		if x.warn1time < GetTime() then --warn Goto hephestus
			AudioMessage("tcss0590.wav") --REMIND - Cmd you have been ordered to recon that object
			x.warn1time = 99999.9
		end
		
		if x.warn2time < GetTime() then --warn inspect hephestus
			AudioMessage("tcss0591.wav") --REMIND - Still waiting 4u to inspect the x.hephestus
			x.warn2time = 99999.9
		end
		
		if x.warn3time < GetTime() then --warn goto starport
			AudioMessage("tcss0595.wav") --Cmd, order to head to nav 1 and recon starport
			x.warn3time = 99999.9
		end
		
		if not x.ccafound and IsAlive(x.eart1) and GetNearestEnemy(x.eart1, 0, 0, 450.0) then --found cca artillery and pool
			AudioMessage("tcss0536.wav") --Picking up scrap field. Radar contact. CCA in scrapfield
			x.ccafound = true
		end
		
		if not x.frcydeploy and IsOdf(x.frcy, "abrecyss05") then
			x.einittime = GetTime() + 20.0
			x.ekillfrcytime = GetTime() --send in attacks on x.player recycler
			x.frcydeploy = true
		end
		
		if not x.einitbuilt and x.einittime < GetTime() then --send initial CCA scout attack
			for index = 1, 3 do
				x.e5pt[index] = BuildObject("svscout", 5, GetPositionNear("pinit1", 0, 16, 32))
				SetSkill(x.e5pt[index], x.skillsetting)
				Goto(x.e5pt[index], "fpnav1")
			end
			x.einittime = GetTime() + 5.0
			x.einitbuilt = true
		end
		
		if x.einittime < GetTime() then
			x.audio2 = AudioMessage("tcss0511.wav") --Cmd, CCA patrol approach from canyon.
			x.runcine2 = true
			x.einittime = 99999.9
			x.einittimecine = GetTime() + 6.0
      x.userfov = IFace_GetInteger("options.graphics.defaultfov")
      CameraReady()
      IFace_SetInteger("options.graphics.defaultfov", x.camfov)
		end
		
		if x.runcine2 then --follow a CCA scout
			CameraObject(x.e5pt[3], -5, 3, -15, x.frcy)
			if CameraCancelled() or x.einittimecine < GetTime() then
        CameraFinish()
        IFace_SetInteger("options.graphics.defaultfov", x.userfov)
				x.runcine2 = false
			end
		end
		
		if x.checktimer[1] and GetCockpitTimer() <= 0 then --if timer ends, fail mission
			for index = 1, 6 do
				x.checktimer[index] = false
			end
			StopCockpitTimer()
			HideCockpitTimer()
			AudioMessage("tcss0535.wav") --Grz1, this cmd Simmns, I arrggghhhhhh
			AudioMessage("tcss0546.wav") --Gen, 5th wiped out. Grz1 has failed to recon Lpad
			AudioMessage("tcss0551.wav") --fail - All personel. Prep evac, except you Griz 1
			FailMission(GetTime() + 21.0, "tcss05f4.des") --LOSER LOSER LOSER - getto and id launchpad
			ClearObjectives()
			AddObjective("tcss0510.txt", "RED")
			x.spine = 666
		end
	end

	--SETUP SIMMONS AND 5TH PLT FINAL CHARGE
	if not x.getiton then
		if x.checktimer[2] and GetCockpitTimer() < 240 and GetDistance(x.player, x.epad) > 500 then
      x.f5pt[11] = GetNearestEnemy(x.player, 1, 1, 450.0) --get seperate, in case not w/in 450
      if IsAlive(x.f5pt[11]) and GetDistance(x.player, x.f5pt[11]) > 150 then--SETUP 5th platoon second cutscene
        x.f5pt[1] = BuildObject("avtank", 2, "pplt1")
        x.f5pt[2] = BuildObject("avscout", 2, "pplt2")
        x.f5pt[3] = BuildObject("avmbike", 2, "pplt3")
        x.f5pt[4] = BuildObject("avtank", 2, "pplt4")
        x.f5pt[5] = BuildObject("avscout", 2, "pplt5")
        x.f5pt[6] = BuildObject("avtank", 2, "pplt6")
        x.f5pt[7] = BuildObject("avscout", 2, "pplt7")
        x.f5pt[8] = BuildObject("avmbike", 2, "pplt8")
        x.f5pt[9] = BuildObject("avtank", 2, "pplt9")
        x.f5pt[10] = BuildObject("avscout", 2, "pplt10")
        for index = 1, 10 do
          Goto(x.f5pt[index], ("pplt%d"):format(index))
        end
        x.plyrhealth = GetCurHealth(x.player) --don't let player or frcy take damage...
        x.frcyhealth = GetCurHealth(x.frcy) --...while cineractive is running
        AudioMessage("tcss0542.wav") --p1 Cmd Sims - You need more time. will hold off CCA
        AudioMessage("tcss0543.wav") --p2 Neg Cnd. - you are too hurt to help
        AudioMessage("tcss0544.wav") --p3 sorry LT. cant do. all units move to atk formation
        x.audio1 = AudioMessage("tcss0545.wav") --p4 simmns comin. Grz1 they won't last long
        x.runcine3 = true
        x.userfov = IFace_GetInteger("options.graphics.defaultfov")
        CameraReady()
        IFace_SetInteger("options.graphics.defaultfov", x.camfov)
        x.checktimer[2] = false
      end
		end
		
		if x.runcine3 then --RUN 5th platoon second cutscene
			SetCurHealth(x.player, x.plyrhealth)
			SetCurHealth(x.frcy, x.frcyhealth)
			CameraObject(x.f5pt[1], -5, 10, -120, x.f5pt[1]) --this seems to be meters?
			
			if CameraCancelled() or IsAudioMessageDone(x.audio1) then
        CameraFinish()
        IFace_SetInteger("options.graphics.defaultfov", x.userfov)
				for index = 1, 10 do
					RemoveObject(x.f5pt[index])
				end
				StopCockpitTimer() --stop old hidden one
				if GetDistance(x.player, x.frcy) > 200 then 
					StartCockpitTimer(360, 180, 120)
				else
					StartCockpitTimer(300, 180, 120) --Visible 5M countdown
				end
				ClearObjectives()
				AddObjective("tcss0505.txt", "LAVACOLOR")
				x.runcine3 = false
				x.checktimer[3] = true
			end
		end
		
		if x.checktimer[3] and GetCockpitTimer() < 240 then
			AudioMessage("tcss0532.wav") --this Cmd Simms. Hurry to Lpad.
			x.checktimer[4] = true
			x.checktimer[3] = false
		end
		
		if x.checktimer[4] and GetCockpitTimer() <180 then
			AudioMessage("tcss0533.wav") --this Cmd Simms. Only a few left. Cant hold much longer
			x.checktimer[5] = true
			x.checktimer[4] = false
		end
		
		if x.checktimer[5] and GetCockpitTimer() <123 then
			AudioMessage("tcss0534.wav") --we making last stand at pass. 2 min left. get to lpad
			x.checktimer[5] = false
		end
		
		if x.checktimer[6] and GetCockpitTimer() < 33 then
			AudioMessage("tcss0548.wav") --OPT - Griz, you have 30 sec to recon lpad.
			x.checktimer[6] = false
		end
	end

	--CCA GROUP killrecylcer---NON-WARCODE VER---------------------------------
	if x.ekillfrcytime < GetTime() then
		if not x.ekillfrcybuild then
			for index = 1, x.ekillfrcylength do --check alive force
				if not IsAlive(x.ekillfrcy[index]) then
					x.casualty = x.casualty + 1
				end
			end
			
			if x.casualty ~= x.ekillfrcylength then
				x.casualty = 0
			elseif not x.ekillfrcyreset then
				x.casualty = 0
				x.ekillfrcybuild = true
				x.ekillfrcytime = GetTime() --right away for this mission
				x.ekillfrcyreset = true
			end
			
			if x.ekillfrcywave == 0 then
				x.ekillfrcylength = 4
			elseif x.ekillfrcywave == 1 then
				x.ekillfrcylength = 8
			elseif x.ekillfrcywave == 2 then
				x.ekillfrcylength = 16
			else
				x.ekillfrcylength = 20
			end
		end
		
		if x.ekillfrcybuild then
			x.ekillfrcywave = x.ekillfrcywave + 1 --keep here
			for index = 1, x.ekillfrcylength do --build force
				while x.randompick == x.randomlast do --random the random
					x.randompick = math.floor(GetRandomFloat(1.0,15.0))
				end
				x.randomlast = x.randompick
				if x.randompick == 1 or x.randompick == 6 or x.randompick == 11 then
					x.ekillfrcy[index] = BuildObject("svscout", 5, GetPositionNear("epgrcy", 0, 16, 32)) --grpspwn
				elseif x.randompick == 2 or x.randompick == 7 or x.randompick == 12 then
					x.ekillfrcy[index] = BuildObject("svmbike", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
				elseif x.randompick == 3 or x.randompick == 8 or x.randompick == 13 then
					x.ekillfrcy[index] = BuildObject("svmisl", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
				elseif x.randompick == 4 or x.randompick == 9 or x.randompick == 14 then
					x.ekillfrcy[index] = BuildObject("svtank", 5, GetPositionNear("epgrcy", 0, 16, 32)) --grpspwn
				else
					x.ekillfrcy[index] = BuildObject("svrckt", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
				end
				SetSkill(x.ekillfrcy[index], x.skillsetting)
				if index % 3 == 0 then
					SetSkill(x.ekillfrcy[index], x.skillsetting+1)
				end
			end
			x.ekillfrcyresendtime = GetTime() --KEEP - seed on newly built squad
			x.casualty = 0
			x.ekillfrcyreset = false
			x.ekillfrcybuild = false
		end

		if x.ekillfrcyresendtime < GetTime() then
			for index = 1, x.ekillfrcylength do
				if IsAlive(x.ekillfrcy[index]) and GetTeamNum(x.ekillfrcy[index]) ~= 1 then
					Attack(x.ekillfrcy[index], x.frcy)
				end
			end
			x.ekillfrcyresendtime = GetTime() + 30.0
		end
	end

	--CCA GROUP SCOUT PATROLS ----------------------------------
	if x.epattime < GetTime() then
		for index = 1, x.epatlength do --check alive force
			if not IsAlive(x.epat[index]) then
				x.epat[index] = BuildObject("svscout", 5, GetPositionNear("epgrcy", 0, 16, 32)) --grpspwn
				SetSkill(x.epat[index], x.skillsetting)
				Patrol(x.epat[index], ("ppatrol%d"):format(index))
			end
		end
		x.epattime = GetTime() + 20.0
	end

	--CCA GROUP final attack ----------------------------------
	if x.efinaltime < GetTime() then
		if not x.efinalbuild then
			for index = 1, x.efinallength do --check alive force
				if not IsAlive(x.efinal[index]) or (IsAlive(x.efinal[index]) and GetTeamNum(x.efinal[index]) == 1) then
					x.casualty = x.casualty + 1
				end
			end
			if x.casualty > (x.efinallength * 0.8) then
				x.efinalbuild = true
				x.efinaltime = GetTime()
				x.efinalreset = true
			end
      x.casualty = 0
		end
		
		if x.efinalbuild then
			for index = 1, x.efinallength do --build force
				while x.randompick == x.randomlast do --random the random
					x.randompick = math.floor(GetRandomFloat(1.0,16.0))
				end
				x.randomlast = x.randompick
				if x.randompick == 1 or x.randompick == 6 or x.randompick == 11 then
					x.efinal[index] = BuildObject("svscout", 5, GetPositionNear("psim1", 0, 16, 32)) --moved from "fpnav0" - change AOA
				elseif x.randompick == 2 or x.randompick == 7 or x.randompick == 12 then
					x.efinal[index] = BuildObject("svmbike", 5, GetPositionNear("psim2", 0, 16, 32))
				elseif x.randompick == 3 or x.randompick == 8 or x.randompick == 13 then
					x.efinal[index] = BuildObject("svmisl", 5, GetPositionNear("psim3", 0, 16, 32))
				elseif x.randompick == 4 or x.randompick == 9 or x.randompick == 14 then
					x.efinal[index] = BuildObject("svtank", 5, GetPositionNear("psim4", 0, 16, 32))
				else
					x.efinal[index] = BuildObject("svrckt", 5, GetPositionNear("psim5", 0, 16, 32))
				end
				SetSkill(x.efinal[index], x.skillsetting)
			end
			x.efinalresendtime = GetTime() --KEEP - seed on newly built squad
			x.casualty = 0
			x.efinalreset = false
			x.efinalbuild = false
		end
		
		if x.efinalresendtime < GetTime() then
			for index = 1, x.efinallength do
				if IsAlive(x.efinal[index]) and GetTeamNum(x.efinal[index]) ~= 1 then
					Attack(x.efinal[index], x.frcy)
				end
			end
			x.efinalresendtime = GetTime() + 30.0
		end
	end
  
  --KEEP DUSTOFF BEACON ALIVE
  if x.epadclear and not IsAlive(x.fnav) then
    x.fnav = BuildObject("apcamra", 1, "pdust")
		SetObjectiveName(x.fnav, "Dustoff")
		SetObjectiveOn(x.fnav)
  end

	--CHECK STATUS OF MISSION-CRITICAL ASSETS (MCA) --------------
	if not x.MCAcheck then
		if not IsAlive(x.frcy) then
			AudioMessage("tcss0553.wav") --fail - Wyoming lost
			FailMission(GetTime() + 6.0, "tcss05f5.des") --LOSER LOSER LOSER
			ClearObjectives()
			AddObjective("failrecycox.txt", "RED") --Your Recycler was destroyed. MISSION FAILED
			x.spine = 666
			x.MCAcheck = true
		end
		
		if not x.epadclear and not IsAlive(x.epad) then --don't blow up the launchpad (before IDing) ya knucklehead
			FailMission(GetTime() + 6.0, "tcss05f7.des")
			ClearObjectives()
			AddObjective("failordr.txt", "RED")
			x.spine = 666
			x.MCAcheck = true
		end
		
		if not x.ecnedone and x.gotcone and not IsAlive(x.ecne) then --don't blow up CCA rocket
			FailMission(GetTime() + 6.0, "tcss05f7.des")
			ClearObjectives()
			AddObjective("failordr.txt", "RED")
			x.spine = 666
			x.MCAcheck = true
		end
		
		if x.order1time < GetTime() then --follow orders soldiernot 
			if x.failstate[1] then
				FailMission(GetTime() + 10.0, "tcss05f1.des") --LOSER LOSER LOSER - goto heph
			elseif x.failstate[2] then
				FailMission(GetTime() + 10.0, "tcss05f2.des") --LOSER LOSER LOSER - id heph
			elseif x.failstate[3] then
				FailMission(GetTime() + 10.0, "tcss05f3.des") --LOSER LOSER LOSER - goto omega
			elseif x.failstate[4] then
				FailMission(GetTime() + 10.0, "tcss05f6.des") --LOSER LOSER LOSER - id omega
			end
			AudioMessage("tcss0594.wav") --failure to perfrom simple order, relieved of cmd
			ClearObjectives()
			AddObjective("failordr.txt", "RED")
			x.spine = 666
			x.MCAcheck = true
		end
	end
end
--END OF SCRIPT