--bztcss02 - Battlezone Total Command - Stars and Stripes - 2/17 - EAGLE'S NEST ONE
assert(load(assert(LoadFile("_requirefix.lua")),"_requirefix.lua"))();
TCC = require("TC_Core")
MisnNum = 2;
--INITIALIZE VARIABLES --f-friend e-enemy p-path atk-attack scv-scavenger rcy-recycler tnk-tank cam-camera
local index = 0
local indexadd = 0
local x = {
	FIRST = true,
	MCAcheck = false, 
	audio1 = nil, 
	player = nil, 
	mytank = nil, 
	skillsetting = 0,
	easy = 0, 
	medium = 1, 
	hard = 2, --tried 1-3, in 185, 3 didn't seem to make any difference, 
	spine = 0, 
	randompick = 0,
	randomlast = 0, 
	casualty = 0, 
	fnav1 = nil, 
	waittime = 99999.9, 
	pos = {}, 
  camfov = 60,  --185 default
	userfov = 90,  --seed
	removestuff = false, 
	montanasent = false, 
	eatk1waveset = false, 
	eatk1built = false, 
	fallyarrive = false, 
	allymet = false, 
	LoopTransportSafe = false, 
	playeratlpad = false, 
	cine1playerstop = false, 
	fapcsent = false, 
	eatkintroRetreatTime = 99999.9, 
	eatk1time = 99999.9, 
	allytime = 99999.9, 
	playeratlpadtime = 99999.9, 
	cine0length = 99999.9, 
	cine1length = 99999.9, 
	cine1part1 = 99999.9, 
	deleteme = nil, 
	frcy = nil, 
	fapc = {}, 
	ftur = {}, 
	fscv = {},
	fmin = {},
	fturlength = 20,
	fscvlength = 10,
	fminlength = 10,
	fallylength = 4, 
	fally = {}, 
	ftrn = nil, 
	fprop = nil, 
	ftwr = nil, 
	fpwr = {}, 
	fbay1 = nil, 
	fbay2 = nil, 
	fbnk = nil,
	fpad = nil, 
	fcne = nil, 
	gotcone = false, 
	eturinit = nil, 
	etur = {}, 
	eatkintro1 = nil, 
	eatkintro2 = nil, 
	eatkintro3 = nil, 
	eatk = {}, 
	eatk1dead = {}, 
	eapc = {}, 
	ercy = nil, 
	efac = nil, 
	esld = {},	
	etnkc1 = nil, 
	etnkc2 = nil, 
	etnk = {}, 
	eatk1wavecount = 0, 
	maxwaves = 5, 
	eatk1length = 20, 
	eapclength = 5,
	etnkstage = 0, 
	LAST = true
}
--Paths: pmytank, epse, eptur1-20, epturbuild(11-20), eprcy, fprcy, epatk1a(SE), epatk1b(E), epse, epapc1-6, fpally(0-4), fpmeet, fpapc1-3, fppickup, fptran, fpplay15, fptrnsafe, eprcy, epfac, epsld1, epsld2, epsld3, epsld4, eptnkc1, eptnkc2, eptnk(0-6), cam1, cam2, cam3, pcampad

function InitialSetup()
	SetAutoGroupUnits(true)
	
	local odfpreload = {
		"avtank", "avscout", "avmbike", "avrecyss02", "ablpad2", "abcone", "abcone1", "svrecy", "sssold", "svfact", "svscout", "svmbike", "svtank", "svapc",	"avscav", "apcamra"
	}
	for k,v in pairs(odfpreload) do
		PreloadODF(v)
	end
	
	x.mytank = GetHandle("mytank")
	x.ftwr = GetHandle("ftwr") --Cmd HQ Tower
	x.fbnk = GetHandle("fbnk") --comm twr
	x.fpwr[1] = GetHandle("fpwr1")
	x.fpwr[2] = GetHandle("fpwr2")
	x.fpwr[3] = GetHandle("fpwr3")
	x.fbay1 = GetHandle("fbay1")
	x.fbay2 = GetHandle("fbay2")
	x.fpad = GetHandle("fpad")
	x.ftrn = GetHandle("ftrn") --barracks(training center)
	Ally(1, 2)
	Ally(1, 3)
	Ally(2, 1)
	Ally(2, 3)
	Ally(3, 1)
	Ally(3, 2)
	Ally(5, 6)
	Ally(6, 5)
	SetTeamColor(2, 130, 120, 50) --Tan
	SetTeamColor(3, 30, 100, 120) --Blue-ish
	SetTeamColor(6, 100, 50, 10)  
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
	if not x.gotcone and IsOdf(h, "abcone1") then
		x.fcne = h
		x.gotcone = true
	end
	
	if not x.removestuff then		
		if IsOdf(h, "avturr:1") then
			for indexadd = 1, x.fturlength do
				if (x.ftur[indexadd] == nil or not IsAlive(x.ftur[indexadd])) then
					x.ftur[indexadd] = h
					break
				end
			end
		end
		
		if IsOdf(h, "avscav:1") then
			for indexadd = 1, x.fscvlength do
				if (x.fscv[indexadd] == nil or not IsAlive(x.fscv[indexadd])) then
					x.fscv[indexadd] = h
					break
				end
			end
		end
		
		if IsOdf(h, "avmine:1") then
			for indexadd = 1, x.fminlength do
				if (x.fmin[indexadd] == nil or not IsAlive(x.fmin[indexadd])) then
					x.fmin[indexadd] = h
					break
				end
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
	
	--[[TEST ENDING CUTSCENE
	if x.spine == 0 then
		AudioMessage("tcss0220.wav") --38s - full ending monologue by Gen. Col
		x.pos = GetTransform(x.fpad)
		RemoveObject(x.fpad)
		x.fpad = BuildObject("ablpad2", 1, x.pos)
		x.frcy = BuildObject("abrecyss02", 1, "fprcy", 1)
		x.waittime = GetTime() + 1.0
		x.MCAcheck = true
		x.spine = 21
	end--]]
	
	--INITIAL SETUP
	if x.spine == 0 then
		x.pos = GetTransform(x.mytank)
		RemoveObject(x.mytank)
		x.mytank = BuildObject("avtank", 1, x.pos)
		SetAsUser(x.mytank, 1)
		RemoveObject(x.player)
		x.player = GetPlayerHandle()
		TCC.SetTeamNum(x.player, 1)--JUST IN CASE
		for index = 1, 10 do
			x.eturinit = BuildObject("svturr", 5, ("eptur%d"):format(index))
			SetEjectRatio(x.eturinit, 0)
			SetSkill(x.eturinit, x.skillsetting)
		end
		SetObjectiveOn(x.ftwr)
		SetCurHealth(x.ftwr, 10000)
		for index = 1, 3 do
			SetObjectiveName(x.fpwr[index], ("Solar %d"):format(index))
			SetObjectiveOn(x.fpwr[index])
		end
		x.pos = GetTransform(x.fpad)
		RemoveObject(x.fpad)
		x.fpad = BuildObject("ablpad2", 1, x.pos)
		x.waittime = GetTime() + 2.0		
		x.spine = x.spine + 1
	end

	--SEND INITIAL CCA ATTACK
	if x.spine == 1 and x.waittime < GetTime() then
		x.audio1 = AudioMessage("tcss0211.wav") --INTRO This Gen collins. CCA coming from SE
		x.eatkintro1 = BuildObject("svscout", 5, GetPositionNear("epse", 0, 16, 32))
		SetEjectRatio(x.eatkintro1, 0)
		SetSkill(x.eatkintro1, x.skillsetting)
		Attack(x.eatkintro1, x.ftwr)
		x.eatkintro2 = BuildObject("svscout", 5, GetPositionNear("epse", 0, 16, 32))
		SetEjectRatio(x.eatkintro2, 0)
		SetSkill(x.eatkintro2, x.skillsetting)
		Attack(x.eatkintro2, x.ftwr)
		x.eatkintro3 = BuildObject("svscout", 6, GetPositionNear("epse", 0, 16, 32))
		SetEjectRatio(x.eatkintro3, 0)
		SetSkill(x.eatkintro3, x.skillsetting)
		Attack(x.eatkintro3, x.player)
		SetObjectiveName(x.eatkintro3, "Assassin")
		x.spine = x.spine + 1
	end

	--ADD FIRST OBJECTIVE
	if x.spine == 2 and IsAudioMessageDone(x.audio1) then
		ClearObjectives()
		AddObjective("tcss0201.txt")
		x.spine = x.spine + 1
	end

	--CHECK ON INIT ATTACK RETREAT
	if x.spine == 3 and (not IsAlive(x.eatkintro1) or not IsAlive(x.eatkintro2)) then
    if IsAliveAndPilot(x.eatkintro1) and GetTeamNum(x.eatkintro1) == 5 then
      Retreat(x.eatkintro1, "epatk1b")
    end
    if IsAliveAndPilot(x.eatkintro2) and GetTeamNum(x.eatkintro2) == 5 then
      Retreat(x.eatkintro2, "epatk1b")
    end
		x.waittime = GetTime() + 2.0
		x.eatkintroRetreatTime = GetTime() + 30.0
		x.spine = x.spine + 1
	end

	--GIVE PLAYER RECYCLER
	if x.spine == 4 and x.waittime < GetTime() and IsAlive(x.ftwr) then
		x.frcy = BuildObject("avrecyss02", 1, "fprcy")
		SetSkill(x.frcy, x.skillsetting)
		SetGroup(x.frcy,0)
		Goto(x.frcy, "fprcy", 0)
		SetObjectiveOn(x.frcy)
		SetScrap(1, 40)
    if x.skillsetting == 1 then
      x.fally[5] = BuildObject("avscav", 1, GetPositionNear("fprcy", 0, 16, 32))
    elseif x.skillsetting == 2 then
      x.fally[5] = BuildObject("avscav", 1, GetPositionNear("fprcy", 0, 16, 32)) 
      x.fally[6] = BuildObject("avscav", 1, GetPositionNear("fprcy", 0, 16, 32))
    end
		x.audio1 = AudioMessage("tcss0212.wav") --Soviet withdraw. Montana on the way. Build defenses
		x.spine = x.spine + 1
	end

	--GIVE NEXT OBJECTIVE CARD
	if x.spine == 5 and IsAudioMessageDone(x.audio1) then
		AddObjective("	")
		AddObjective("tcss0202.txt")
		x.montanasent = true --needed for MCA check
		x.spine = x.spine + 1
	end

	--CHECK ON INIT ATTACK REMOVE RETREAT
	if x.spine == 6 and x.eatkintroRetreatTime < GetTime() then
    if IsAliveAndPilot(x.eatkintro1) and GetTeamNum(x.eatkintro1) == 5 and GetDistance(x.eatkintro1, "epatk1b") < 64 then
      RemoveObject(x.eatkintro1)
    elseif IsAlive(x.eatkintro1) and GetTeamNum(x.eatkintro1) == 5 then
      Attack(x.eatkintro1, x.ftwr)
    end
    if IsAliveAndPilot(x.eatkintro2) and GetTeamNum(x.eatkintro2) == 5 and GetDistance(x.eatkintro2, "epatk1b") < 64 then
      RemoveObject(x.eatkintro2)
    elseif IsAlive(x.eatkintro2) and GetTeamNum(x.eatkintro2) == 5 then
      Attack(x.eatkintro2, x.ftwr)
    end
		x.waittime = GetTime() + 180.0
		x.spine = x.spine + 1
	end

	--LET PLAYER DEPLOY RECYCLER BEFORE ATTACK START
	if x.spine == 7 and IsAlive(x.frcy) and (IsOdf(x.frcy, "abrecyss02") or x.waittime < GetTime()) then
		x.eatk1time = GetTime() + 40.0
		x.spine = x.spine + 1
	end

	--LAUNCH INCREASING ATTACK WAVES --see WARCODE for more refined version in later scripts
	if x.spine == 8 then
		if not x.eatk1built and x.eatk1time < GetTime() then
			if not x.eatk1waveset then
				if x.eatk1wavecount == 0 then
					x.eatk1length = 2
				elseif x.eatk1wavecount == 1 then
					x.eatk1length = 4
				elseif x.eatk1wavecount == 2 then
					x.eatk1length = 8
				elseif x.eatk1wavecount == 3 then
					x.eatk1length = 12
				else
					x.eatk1length = 16
					x.spine = x.spine + 1 --INCREMENT MISSION STATE HERE
				end
				x.eatk1waveset = true
			end
			
			for index = 1, x.eatk1length do
				while x.randompick == x.randomlast do --random the random
					x.randompick = math.floor(GetRandomFloat(1.0,16.0))
				end
				x.randomlast = x.randompick
				if x.randompick == 1 or x.randompick == 9 then
					x.eatk[index] = BuildObject("svscout", 5, GetPositionNear("epatk1a", 0, 16, 32))
					Goto(x.eatk[index], "stage3")
				elseif x.randompick == 2 or x.randompick == 10 then
					x.eatk[index] = BuildObject("svmbike", 5, GetPositionNear("epatk1b", 0, 16, 32))
					Goto(x.eatk[index], "stage4")
				elseif x.randompick == 3 or x.randompick == 11 then
					x.eatk[index] = BuildObject("svmbike", 5, GetPositionNear("epatk1a", 0, 16, 32))
					Goto(x.eatk[index], "stage3")
				elseif x.randompick == 4 or x.randompick == 12 then
					x.eatk[index] = BuildObject("svscout", 5, GetPositionNear("epatk1b", 0, 16, 32))
					Goto(x.eatk[index], "stage4")
				elseif x.randompick == 5 or x.randompick == 13 then
					x.eatk[index] = BuildObject("svscout", 5, GetPositionNear("epse", 0, 16, 32))
					Goto(x.eatk[index], "stage2")
				elseif x.randompick == 6 or x.randompick == 14 then
					x.eatk[index] = BuildObject("svmbike", 5, GetPositionNear("epturbuild", 0, 16, 32))
					Goto(x.eatk[index], "stage1")
				elseif x.randompick == 7 or x.randompick == 15 then
					x.eatk[index] = BuildObject("svmbike", 5, GetPositionNear("epse", 0, 16, 32))
					Goto(x.eatk[index], "stage2")
				else
					x.eatk[index] = BuildObject("svscout", 5, GetPositionNear("epturbuild", 0, 16, 32))
					Goto(x.eatk[index], "stage1")
				end
				SetEjectRatio(x.eatk[index], 0)
				SetSkill(x.eatk[index], x.skillsetting)
				if index % 3 == 0 then
					SetSkill(x.eatk[index], x.skillsetting+1)
				end
				if x.randompick == 1 or x.randompick == 3 or x.randompick == 5 or x.randompick == 7 then
					Attack(x.eatk[index], x.ftwr) --attack command tower
				else
					if IsAlive(x.fpwr[1]) then
						Attack(x.eatk[index], x.fpwr[1])
					elseif IsAlive(x.fpwr[2]) then
						Attack(x.eatk[index], x.fpwr[2])
					elseif IsAlive(x.fpwr[3]) then
						Attack(x.eatk[index], x.fpwr[3])
					else
						Goto(x.eatk[index], "fpmeet")
					end
				end
			end
			x.eatk1built = true--ensure it doesn't run again until all dead
		end
		
		for index = 1, x.eatk1length do --go through squad
			if not IsAlive(x.eatk[index]) then
				x.casualty = x.casualty + 1
			end
		end
		
		if x.eatk1waveset and x.casualty >= math.floor(x.eatk1length * 0.5) then
      for index = 1, x.eatk1length do
        if IsAlive(x.eatk[index]) and GetTeamNum(x.eatk[index]) ~= 1 then
          Goto(x.eatk[index], "fpmeet")
        end
      end
			x.eatk1built = false
			x.eatk1wavecount = x.eatk1wavecount + 1 --INCREMENT FOR NEXT WAVE
			x.eatk1time = GetTime() + 50.0 --ensure proper increment
			x.eatk1waveset = false
		end
		x.casualty = 0
	end

	--REINFORCEMENTS - BUILD AND SEND
	if x.spine == 9 then
		x.fally[1] = BuildObject("avscout", 3, "fpally", 1)
		x.fally[2] = BuildObject("avmbike", 3, "fpally", 2)
		x.fally[3] = BuildObject("avmisl", 3, "fpally", 3)
		x.fally[4] = BuildObject("avtank", 3, "fpally", 4)
		for index = 1, x.fallylength do
			SetSkill(x.fally[index], x.skillsetting)
			Goto(x.fally[index], "fpmeet", 0)
		end
		x.fnav1 = BuildObject("apcamra", 1, "fpmeet")
		SetObjectiveOn(x.fnav1)
		SetObjectiveName(x.fnav1, "Meet Reinforcements")
		AudioMessage("tcss0214.wav") --Meet reinforce at N solar array
		ClearObjectives()
		AddObjective("tcss0201.txt")
		AddObjective("	")
		AddObjective("tcss0201.txt", "GREEN")
		AddObjective("	")
		AddObjective("tcss0203.txt", "CYAN") --Go meet reinforcements
		x.allytime = GetTime() + 40.0
		x.spine = x.spine + 1
	end

	--REINFORCEMENTS - CHECK ON MEETING, FAIL IF NECESSARY
	if x.spine == 10 and not x.allymet then
		if GetDistance(x.player, "fpmeet") < 64 then
			for index = 1, x.fallylength do
				TCC.SetTeamNum(x.fally[index], 1)
				SetGroup(x.fally[index], 9)
			end
			x.allymet = true
			x.allytime = 99999.9
			SetObjectiveOff(x.fnav1)
			RemoveObject(x.fnav1)
			x.waittime = GetTime() + 30.0
      AudioMessage("emdotcox.wav")
			ClearObjectives()
			AddObjective("tcss0203.txt", "GREEN") --Go meet reinforcements
			AddObjective("	")
			AddObjective("tcss0201.txt")
			x.spine = x.spine + 1
		end
		if x.allytime < GetTime() then
			TCC.FailMission(GetTime() + 3.0, "tcss02f3.des") --LOSER LOSER LOSER - reinforcement
			ClearObjectives()
			AddObjective("tcss0203.txt", "RED") --Failed to meet reinforcements. MISSION FAILEDnot
			x.allymet = true
			x.spine = 666
		end
	end

	--SEND APC ATTACK ON FRIENDLY RECYCLER
	if x.spine == 11 and x.waittime < GetTime() then
		for index = 1, x.eapclength do
			if index == 5 then
				x.eapc[index] = BuildObject("svtank", 6, "epapc3")
			else
				x.eapc[index] = BuildObject("svapc", 6, ("epapc%d"):format(index))
			end
			SetEjectRatio(x.eapc[index], 0)
			SetSkill(x.eapc[index], x.skillsetting)
			Attack(x.eapc[index], x.frcy)
		end
		
		--PREP CUTSCENE
		x.fprop = BuildObject("svtank", 0, "eprcy")
		Goto(x.fprop, "eprcy")
		x.ercy = BuildObject("svrecy", 0, "eprcy")
		x.efac = BuildObject("svfact", 0, "epfac")
		for index = 1, 4 do 
			x.esld[index] = BuildObject("sssold", 0, ("epsld%d"):format(index))
			LookAt(x.esld[index], x.fprop, 0)
		end
		x.etnkc1 = BuildObject("svtank", 0, "eptnkc1")
		x.etnkc2 = BuildObject("svtank", 0, "eptnkc2")
		LookAt(x.ercy, x.fprop, 0)
		LookAt(x.efac, x.fprop, 0)  	
		LookAt(x.etnkc1, x.fprop, 0)
		LookAt(x.etnkc2, x.fprop, 0)
		SetObjectiveOff(x.ftwr)
		for index = 1, 3 do
			SetObjectiveOff(x.fpwr[index])
		end
		x.waittime = GetTime() + 60.0
		x.spine = x.spine + 1
	end

	--START THE CCA ARRIVAL CINERACTIVE LEADING TO TRANSPORTS PHASE
	if x.spine == 12 and x.waittime < GetTime() then
		for index = 1, x.eapclength do
			if not IsAlive(x.eapc[index]) then
				x.casualty = x.casualty + 1
			end
		end
		if x.casualty == x.eapclength then
			x.waittime = GetTime() + 20.0
			x.spine = x.spine + 1
		end
		x.casualty = 0
	end

	--SETUP CINERACTIVE 0 - CCA ARRIVAL
	if x.spine == 13 and x.waittime < GetTime() then
		RemoveObject(x.fprop)
		Goto(x.ercy, "eprcy")
		for index = 1, 4 do
			Goto(x.esld[index], ("epsld%d"):format(index))
		end
		Follow(x.efac, x.ercy)
		Follow(x.etnkc1, x.ercy)
		Follow(x.etnkc2, x.ercy)
		x.cine0length = GetTime() + 10.0 --time for fcam1 to get to path end. should be longer than actual travel time.
    x.userfov = IFace_GetInteger("options.graphics.defaultfov")
    CameraReady()
    IFace_SetInteger("options.graphics.defaultfov", x.camfov)
		AudioMessage("tcss0205.wav") --Sat recon sov strike land N and to W full evac of EN1
		x.spine = x.spine + 1
	end

	--PLAY CINERACTIVE 0 - CCA ARRIVAL
	if x.spine == 14 then
		if not x.fapcsent then--BUILD AND SEND TRANSPORTS DOWN PATH TO COMMAND TOWER WHILE CINE IS PLAYING
			for index = 1, 3 do
				x.fapc[index] = BuildObject("avapc", 2, ("fpapc%d"):format(index))
				Goto(x.fapc[index], "fppickup")
			end
			x.fapcsent = true
		end
		--CameraPath("cam1", 1000, 1000, x.ercy)
		CameraObject(x.ercy, 30, 40, 120, x.efac)
		if CameraCancelled() or x.cine0length < GetTime() then
      CameraFinish()
      IFace_SetInteger("options.graphics.defaultfov", x.userfov)
			x.spine = x.spine + 1
		end
	end

	--CLEANUP CINERACTIVE AND FINISH TRANSPORT SETUP
	if x.spine == 15 then
		RemoveObject(x.ercy)
		RemoveObject(x.efac)
		for index = 1, 4 do
			RemoveObject(x.esld[index])
		end
		RemoveObject(x.etnkc1)
		RemoveObject(x.etnkc2)
		for index = 1, 3 do
			SetObjectiveName(x.fapc[index], ("Transport %d"):format(index))
			SetObjectiveOn(x.fapc[index])
		end
		for index = 1, 5 do --PREP CCA BLOCKADE TURRETS
			x.etur[index] = BuildObject("svturr", 5, "epturbuild")
			SetSkill(x.etur[index], x.skillsetting)
			Goto(x.etur[index], ("eptur1%d"):format(index)) --note "1" for 11-15
		end
		ClearObjectives()
		AddObjective("tcss0201.txt", "GREEN")
		AddObjective("	")
		AddObjective("tcss0204b.txt")
		x.spine = x.spine + 1
	end

	--TRANSPORTS STOP AT COMMAND TOWER AND CCA BLOCKADE IS SET UP
	if x.spine == 16 and ((IsAlive(x.fapc[1]) and GetDistance(x.fapc[1], x.ftwr) < 32) or (IsAlive(x.fapc[2]) and GetDistance(x.fapc[2], x.ftwr) < 40) or (IsAlive(x.fapc[3]) and GetDistance(x.fapc[3], x.ftwr) < 48)) then
		for index = 1, 3 do
			Stop(x.fapc[index])
		end
		x.waittime = GetTime() + 10.0
		x.spine = x.spine + 1
	end

	--GIVE TRANSPORTS LOADED MESSAGES
	if x.spine == 17 and x.waittime < GetTime() then
		AudioMessage("tcss0206.wav") --Cmd all person on tran 1 and 2 Esc to North launchpad
		ClearObjectives()
		AddObjective("tcss0204.txt", "YELLOW")
		x.audio1 = AudioMessage("tcss0215.wav") --Take up position in front of tran and look out for CCA blockade
		x.spine = x.spine + 1
	end
	
	--SEND TRANSPORTS DOWN PATH TO LAUNCHPAD, MAKE OTHER MCA SAFE
	if x.spine == 18 and IsAudioMessageDone(x.audio1) then
		for index = 1, 3 do
			Goto(x.fapc[index], "fptran")
		end
		SetObjectiveName(x.fpad, "Launch Pad")
		SetObjectiveOn(x.fpad)
		for index = 1, 3 do
			x.etur[index] = BuildObject("svscout", 5, "epse")
			SetSkill(x.etur[index], x.skillsetting)
			Attack(x.etur[index], x.fapc[index])
		end
		x.MCAcheck = true --Turn off previous IsAlive checks for this mission
		x.spine = x.spine + 1
	end

	--SEE IF TRANSPORTS HAVE ARRIVED AT THE LAUNCHPAD - CAN LOSE ONE OF THEM
	if x.spine == 19 then
		for index = 1, 3 do
			if IsAlive(x.fapc[index]) and GetDistance(x.fapc[index], "fptrnsafe") < 20 then
				x.casualty = x.casualty + 1
			end
		end
		if x.casualty > 0 then --at least 1 apc at pad
			for index = 1, 3 do
				SetCurHealth(x.fapc[index], 30000)
				Stop(x.fapc[index])
				SetObjectiveOff(x.fapc[index])
				if IsAlive(x.etur[index]) then --for extra flankers
					Damage(x.etur[index],5000)
				end
			end
			x.audio1 = AudioMessage("tcss0210.wav") --Nice job. Get to launch pad
			ClearObjectives()
			AddObjective("tcss0204.txt", "GREEN")
			AddObjective("	")
			AddObjective("tcss0205.txt")
			x.playeratlpadtime = GetTime() + 60.0
			x.LoopTransportSafe = true
			x.spine = x.spine + 1
		end
		x.casualty = 0
		--If two transports die then fail mission
		if not x.LoopTransportSafe then
			for index = 1, 3 do
				if not IsAlive(x.fapc[index]) then
					x.casualty = x.casualty + 1
				end
			end
			if x.casualty > 1 then
        Damage(x.fcne, (GetMaxHealth(x.fcne) + 10))
				AudioMessage("tcss0204.wav") --Lost transport FAIL
				TCC.FailMission(GetTime() + 11.0, "tcss02f4.des") --LOSER LOSER LOSER - transport
				ClearObjectives()
				AddObjective("tcss0204.txt", "RED") --Transport was destroyed. MISSION FAILEDnot
				x.LoopTransportSafe = true
				x.spine = 666
			end
			x.casualty = 0
		end
	end

	--MAKE PLAYER GO TO THE LAUNCHPAD so they don't interfere with end cineractive
	if x.spine == 20 and IsAudioMessageDone(x.audio1) and not x.playeratlpad then
		if GetDistance(x.player, "fptrnsafe") <= 64 then
			SetObjectiveOff(x.fpad)
			AudioMessage("tcss0220.wav") --38s - full ending monologue by Gen. Col
			ClearObjectives()
			AddObjective("NSDF forces escaped.\n\nMISSION COMPLETE.", "GREEN", 4.0)
			SetCurHealth(x.player, 20000)
			x.removestuff = true
			x.playeratlpad = true
			x.waittime = GetTime() + 2.0
			x.spine = x.spine + 1
		end
		
		if not x.playeratlpad and x.playeratlpadtime < GetTime() and GetDistance(x.player, "fptrnsafe") > 64 then
			--NO audio message for this one.
			TCC.FailMission(GetTime() + 3.0, "tcss02f5.des") --LOSER LOSER LOSER - Launch Pad late
			ClearObjectives()
			AddObjective("tcss0205.txt", "RED") --Didn't get to Launch Pad in time. MISSION FAILEDnot
			x.playeratlpad = true
			x.spine = 666
		end
	end

	--SETUP ENDING CINERACTIVE
	if x.spine == 21 and x.waittime < GetTime() then
		for index = 1, 5 do
			x.etnk[index] = BuildObject("svtank", 5, "eptnk", index)
			SetCurHealth(x.etnk[index], 50000)
		end
		x.etnkstate = 1
		if IsAlive(x.fpwr[2]) then
			Attack(x.etnk[4], x.fpwr[2])
		else
			Attack(x.etnk[4], x.ftrn)
		end
		if IsAlive(x.fpwr[3]) then
			Attack(x.etnk[5], x.fpwr[3])
		else
			Attack(x.etnk[5], x.ftrn)
		end
		x.pos = GetTransform(x.fcne)
		RemoveObject(x.fcne)
		x.fcne = BuildObject("abcone", 1,	x.pos)
		SetAnimation(x.fcne, "launch", 1)
		x.etnk[6] = BuildObject("svtank", 5, "eptnk", 6)
		SetCurHealth(x.etnk[6], 50000)
		LookAt(x.etnk[6], x.ftwr, 0)
		x.cine1part1 = GetTime() + 10.0 --section for camera switch
		x.cine1length = GetTime() + 42.0 --overall cineractive length
		x.cine1playerstop = true
    x.userfov = IFace_GetInteger("options.graphics.defaultfov")
    CameraReady()
    IFace_SetInteger("options.graphics.defaultfov", x.camfov)
		x.spine = x.spine + 1
	end

	--RUN ENDING CINERACTIVE part 1
	if x.spine == 22 then
		CameraObject(x.fpad, -130, -20, 220, x.fcne)
		if x.cine1part1 < GetTime() then --As 1 ends setup part 2
			x.player = GetPlayerHandle()
			for index = 1, x.fallylength do
				if IsAlive(x.fally[index]) and x.fally[index] ~= x.player then
					RemoveObject(x.fally[index])
				end
			end
			SetCurHealth(x.frcy, 2000) --make sure player sees friend recycler destroyed
			for index = 1, 3 do
				SetCurHealth(x.fpwr[index], 500)
			end
			SetCurHealth(x.fbay1, 500)
			SetCurHealth(x.fbay2, 500)
			SetCurHealth(x.ftrn, 300)
			x.cine1part1 = GetTime() + 15.0
			x.spine = x.spine + 1
		end
	end

	--RUN ENDING CINERACTIVE part 2
	if x.spine == 23 then
		if x.cine1part1 < GetTime() then --As 2 ends setup part 3
      if IsAlive(x.ftwr) then
        Attack(x.etnk[6], x.ftwr)
        SetCurHealth(x.ftwr, 600) --make sure x.player sees friend tower destroyed
      end
			x.spine = x.spine + 1
		end
		CameraObject(x.etnk[1], 10, 10, -40, x.etnk[1])
	end

	--RUN ENDING CINERACTIVE part 3
	if x.spine == 24 then
		if IsAlive(x.ftwr) then
			CameraObject(x.etnk[6], -5, 5, -30, x.etnk[6])
		else	
			CameraObject(x.etnk[6], 0, 0, 30, x.etnk[6])
		end
	end
	----------END MAIN SPINE----------
  
  --STOP ENDING CINERACTIVE and TCC.SucceedMission
	if x.cine1playerstop and (CameraCancelled() or x.cine1length < GetTime()) then
    x.cine1playerstop = false --turn off entire cineractive loop
    CameraFinish()
    IFace_SetInteger("options.graphics.defaultfov", x.userfov)
    TCC.SucceedMission(GetTime(), "tcss02w.des") --WINNER WINNER WINNER
	end
	
	--REMOVE OBJECTS
	if x.removestuff then
		x.player = GetPlayerHandle()
		for index = 1, x.fturlength do
			if IsAlive(x.ftur[index]) and x.ftur[index] ~= x.player then
				RemoveObject(x.ftur[index])
			end
		end
		for index = 1, x.fscvlength do
			if IsAlive(x.fscv[index]) and x.fscv[index] ~= x.player then
				RemoveObject(x.fscv[index])
			end
		end
		for index = 1, x.fminlength do
			if IsAlive(x.fmin[index]) and x.fmin[index] ~= x.player then
				RemoveObject(x.fmin[index])
			end
		end
		for index = 1, x.fallylength do
			if IsAlive(x.fally[index]) and x.fally[index] ~= x.player then
        RemoveObject(x.fally[index])
			end
		end
	end
	
	--HANDLE ETNK BASE ATTACK
	if x.etnkstate == 1 then
		for index = 1, 3 do
			if IsAlive(x.frcy) then
				Attack(x.etnk[index], x.frcy)
			end
		end
		x.etnkstate = x.etnkstate + 1
	elseif x.etnkstate == 2 and not IsAlive(x.frcy) then
		for index = 1, 3 do
			if IsAlive(x.ftrn) then
				Attack(x.etnk[index], x.ftrn)
			end
		end
		x.etnkstate = x.etnkstate + 1
	elseif x.etnkstate == 3 and not IsAlive(x.ftrn) then
		for index = 1, 3 do
			if IsAlive(x.fbay1) then
				Attack(x.etnk[index], x.fbay1)
			end
		end
		x.etnkstate = x.etnkstate + 1
	elseif x.etnkstate == 4 and not IsAlive(x.fbay1) then
		for index = 1, 3 do
			if IsAlive(x.fbay2) then
				Attack(x.etnk[index], x.fbay2)
			end
		end
		x.etnkstate = x.etnkstate + 1
	elseif x.etnkstate == 5 and not IsAlive(x.fbay2) then
		for index = 1, 3 do
			Retreat(x.etnk[index], "fprcy")
		end
		x.etnkstate = x.etnkstate + 1
	end

	--CHECK STATUS OF MISSION-CRITICAL ASSETS (MCA)
	if not x.MCAcheck then
		if x.montanasent and not IsAlive(x.frcy) then --Check Recycler
			AudioMessage("failrecygencol.wav") --6s Gen Col Generic Recycler lost.
			TCC.FailMission(GetTime() + 10.0, "tcss02f0.des") --LOSER LOSER LOSER
			ClearObjectives()
			AddObjective("Montana destroyed.\n\nMISSION FAILED!", "RED") --Your Recycler was destroyed. MISSION FAILED
			x.MCAcheck = true
		end

		if not IsAlive(x.ftwr) then --Check Command Tower
			AudioMessage("tcss0202.wav") --Lost cmd tower FAIL
			TCC.FailMission(GetTime() + 7.0, "tcss02f1.des") --LOSER LOSER LOSER - command tower
			ClearObjectives()
			AddObjective("tcss0201.txt", "RED") --Command Tower was destroyed. MISSION FAILED
			AddObjective("\n\nMISSION FAILED!", "RED")
			x.MCAcheck = true
		end

		if not x.MCAcheck then --Check Solar Arrays - ALL DIE FAIL
			for index = 1, 3 do
				if not IsAlive(x.fpwr[index]) then
					x.casualty = x.casualty + 1
				end
			end
			if x.casualty > 1 then
				AudioMessage("tcss0203.wav") --Lost solar array FAIL
				TCC.FailMission(GetTime() + 7.0, "tcss02f2.des") --LOSER LOSER LOSER - solar array
				ClearObjectives()
				AddObjective("tcss0201.txt", "RED") --Solar Array lost
				AddObjective("\n\nMISSION FAILED!", "RED")
				x.MCAcheck = true
			end
			x.casualty = 0
		end
		
		if x.gotcone and (not IsAlive(x.fpad) or not IsAlive(x.fcne) or not IsAlive(x.fbnk)) then --destroyed lpad or rocket or comm tower
			AudioMessage("alertpusle.wav")
			TCC.FailMission(GetTime() + 4.0, "tcss02f2.des") --LOSER LOSER LOSER - solar array
			ClearObjectives()
			AddObjective("You failed to protect that MCA.\n\nMISSION FAILED!", "RED")
			x.MCAcheck = true
		end
	end
end
--[[END OF SCRIPT]]