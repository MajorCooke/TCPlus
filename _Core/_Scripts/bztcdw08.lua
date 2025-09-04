--bztcdw08 - Battlezone Total Command - Dogs of War - 8/15 - HOOK, LINE, AND SINKER
assert(load(assert(LoadFile("_requirefix.lua")),"_requirefix.lua"))();
TCC = require("TC_Core")
MisnNum = 40;
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
	pos = {}, 
	audio1 = nil, 
	audio6 = nil, 
	fnav = {},	
	casualty = 0,
	camfov = 60,  --185 default
	userfov = 90,  --seed
	randompick = 0, 
	randomlast = 0,
	efacstate = 0, 
	camstate = 0, --camera
	camadjust = 20, 
	eapc = nil, --cra apc
	eapcstate = 0, 
	eapctime = 99999.9, 
	eprt = nil, 
	gotdummy = false, --portal dummies
	gotdummy2 = false, 
	dummy = nil, 
	dummy2 = nil, 
	dummypos = {}, 
	dummypos2 = {}, 
	controls = {braccel = 0, strafe = 0, jump = 0, deploy = 0, eject = 0, abandon = 0, fire = 0}, 
	fgrp = {}, --fbase stuff
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
	ewardeclare = false, --WARCODE
	ewartotal = 4, --1 recy, 2 fact, 3 armo, 4 base 
	ewarrior = {}, 
	ewartrgt = {}, 
	ewartime = {},
	ewartimecool = {},
	ewartimeadd = {},
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
	ewarsizeadd = 0,	 --dw08
	LAST = true
}
--PATHS: pscrap(0-120), epapc, epretreat

function InitialSetup()
	SetAutoGroupUnits(true)
		
	local odfpreload = {
		"kvscout", "kvmbike", "kvmisl", "kvtank", "kvrckt", "kvhtnk", "kvturr", "kvapc", "npscrx", "stayput", "apcamrb" 
	}
	for k,v in pairs(odfpreload) do
		PreloadODF(v)
	end
		
	x.mytank = GetHandle("mytank")
	x.frcy = GetHandle("frcy")
	x.fhqr = GetHandle("fhqr")
	x.ftec = GetHandle("ftec")
	x.ftrn = GetHandle("ftrn")
	x.fbay = GetHandle("fbay")
	x.fcom = GetHandle("fcom")
	for index = 1, 4 do
		x.fgrp[index] = GetHandle(("fgrp%d"):format(index))
	end
	x.eprt = GetHandle("eprt")
	SetColorFade(6.0, 0.5, "BLACK")
	TCC.Init();
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
	--get player base buildings for later attack
	if (not IsAlive(x.farm) or x.farm == nil) and (IsOdf(h, "bvarmo:1") or IsOdf(h, "bbarmo")) then
		x.farm = h
	elseif (not IsAlive(x.ffac) or x.ffac == nil) and (IsOdf(h, "bvfactdw08:1") or IsOdf(h, "bbfactdw08")) then
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
	end
	
	--no ercy, and loose enemy pilots are annoying
	if (GetRace(h) == "k") then
		SetEjectRatio(h, 0);
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
	TCC.AddObject(h);
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
	TCC.Update();
	--START THE MISSION BASICS
	if x.spine == 0 then
		x.camstate = 1
    x.userfov = IFace_GetInteger("options.graphics.defaultfov")
    CameraReady()
    IFace_SetInteger("options.graphics.defaultfov", x.camfov)
		x.audio1 = AudioMessage("tcdw0801.wav") --Let Chines come through reprogram portal. Then capture their APC.
		x.waittime = GetTime() + 1.0
		x.spine = x.spine + 1
	end
	
	--FIRST AUDIO
	if x.spine == 1 and x.waittime < GetTime() then
		SetAsUser(x.mytank, 1)
		RemoveObject(x.player)
		x.player = GetPlayerHandle()
		x.fnav[1] = BuildObject("apcamrb", 1, "fpnav1")
		SetObjectiveName(x.fnav[1], "Repair")
		x.fnav[1] = BuildObject("apcamrb", 1, "fpnav2")
		SetObjectiveName(x.fnav[1], "CRA Base")
		for index = 1, 120 do
			x.fnav[1] = BuildObject("npscrx", 0, "pscrap", index)
		end
		x.spine = x.spine + 1	
	end
	
	--GIVE FIRST OBJECTIVE
	if x.spine == 2 and (IsAudioMessageDone(x.audio1) or CameraCancelled()) then
    CameraFinish()
    IFace_SetInteger("options.graphics.defaultfov", x.userfov)
		x.camstate = 0
		SetColorFade(6.0, 0.5, "BLACK")
		ClearObjectives()
		AddObjective("tcdw0801.txt")
		x.waittime = GetTime() + 60.0
		x.spine = x.spine + 1
	end
	
	--START CAMERA PORTAL
	if x.spine == 3 and x.waittime < GetTime() then
		x.audio1 = AudioMessage("tcdw0802.wav") --Massive EM at portal. / Incoming attack. Keep them from base.
		x.camstate = 2
    x.userfov = IFace_GetInteger("options.graphics.defaultfov")
    CameraReady()
    IFace_SetInteger("options.graphics.defaultfov", x.camfov)
		x.waittime = GetTime() + 4.0
		x.spine = x.spine + 1
	end
		
	--START UP WARCODE --special faster for DW08 
	if x.spine == 4 and x.waittime < GetTime() then
		for index = 1, x.ewartotal do --init WARCODE
			x.ewardeclare = true
			x.ewarrior[index] = {} --"rows"
			x.ewarriorplan[index] = {} --"rows"
			x.ewarriortime[index] = {} --"rows"
			x.ewartrgt[index] = {} --"rows"
			for index2 = 1, 10 do --10 per wave max avail
				x.ewarrior[index][index2] = nil --"columns", init (handle in this case)
				x.ewarriorplan[index][index2] = 0
				x.ewarriortime[index][index2] = 99999.9
				x.ewartrgt[index][index2] = nil
			end
			x.ewarstate[index] = 1
			x.ewartime[1] = GetTime() + 0.0 --recy
			x.ewartime[2] = GetTime() + 30.0 --fact
			x.ewartime[3] = GetTime() + 60.0 --armo
			x.ewartime[4] = GetTime() + 90.0 --base
			x.ewartimecool[index] = 120.0
			x.ewartimeadd[index] = 0.0
			x.ewarabortset[index] = false
			x.ewarabort[index] = 99999.9
			x.ewarsize[index] = 0
			x.ewarwave[index] = 0
			x.ewarwavemax[index] = 5
			x.ewarwavereset[index] = 2
			x.ewarmeet[index] = 2
		end
		x.spine = x.spine + 1
	end
	
	--SET PAUSE AFTER PORT CINE
	if x.spine == 5 and (IsAudioMessageDone(x.audio1) or CameraCancelled()) then
		x.camstate = 0
    CameraFinish()
    IFace_SetInteger("options.graphics.defaultfov", x.userfov)
		x.waittime = GetTime() + 600.0
		x.spine = x.spine + 1
	end
	
	--SEND EAPC
	if x.spine == 6 and x.waittime < GetTime() then
		AudioMessage("portalx.wav", x.eprt)
		AudioMessage("tcdw0803.wav") --That’s the Chine Engin team. Make sure they succeed.
		ClearObjectives()
		AddObjective("tcdw0801.txt", "GREEN")
		AddObjective("	")
		AddObjective("tcdw0802.txt")
		AddObjective("	")
		AddObjective("tcdw0803.txt", "YELLOW")
		x.eapc = BuildObject("kvapc", 5, x.dummypos)
		SetVelocity(x.eapc, (SetVector(-50.0, 0.0, 0.0))) --setvector is xyz world, ought be xyz handle
		SetObjectiveName(x.eapc, "Engineer APC")
		SetObjectiveOn(x.eapc)
		Goto(x.eapc, "epapc")
		x.eapcstate = 1
		x.spine = x.spine + 1
	end
	
	--START MISSION TIMER
	if x.spine == 7 and IsAlive(x.eapc) and GetDistance(x.eapc, "epapc", 5) < 10 then  --was 5 
		--not needed Stop(x.eapc, 0)
		--StartCockpitTimer(180, 60, 30) --Why was this ever shown anyway? Do it different...
		x.waittime = GetTime() + 181.0
		x.spine = x.spine + 1
	end
	
	--ENGINEERS DONE START SNIPE TIMER
	if x.spine == 8 and x.waittime < GetTime() then
		x.eapcstate = 2
		StartCockpitTimer(60, 30, 15) --...give notice of leave countdown time.
		AudioMessage("tcdw0804.wav") --They done their work. Don't let them get away.
		ClearObjectives()
		AddObjective("tcdw0802.txt", "GREEN")
		AddObjective("	")
		AddObjective("tcdw0803.txt", "YELLOW")
		AddObjective("	")
		AddObjective("tcdw0804.txt")
		x.waittime = GetTime() + 50.0
		x.spine = x.spine + 1
	end
	
	--PLAYER IS APC, GIVE ENTER OBJECTIVE
	if x.spine == 9 and x.eapcstate < 5 and (not IsAliveAndPilot(x.eapc) or (IsAlive(x.player) and IsOdf(x.player, "kvapc"))) then
		x.eapcstate = 6 --stop eapc stuff
		x.waittime = 99999.9 --extra stop
		SetTeamNum(x.eapc, 1) --make target
		StopCockpitTimer()
		HideCockpitTimer()
		ClearObjectives()
		AddObjective("tcdw0804.txt", "GREEN")
		AddObjective("	")
		AddObjective("tcdw0805.txt")
		AddObjective("\nHurry before the CRA realizes what is happening.", "ALLYBLUE")
		StartCockpitTimer(60, 20, 10)
		x.waittime = GetTime() + 60.0
		x.spine = x.spine + 1
	end
	
	--START THE VICTORY TOUR
	if x.spine == 10 and IsAlive(x.player) and IsOdf(x.player, "kvapc") and GetDistance(x.player, x.dummy2) < 5 then
		StopCockpitTimer()
		HideCockpitTimer()
		SetCurHealth(x.eapc, 30000)
		x.controls = {braccel = 0, strafe = 0, jump = 0, deploy = 0, eject = 0, abandon = 0, fire = 0}
		SetControls(x.player, x.controls)
		ClearThrust(x.player) --prob redundent but doesn't hurt
		x.fnav[1] = BuildObject("stayput", 0, x.dummy2) --Can be defeated by jumping through, and doesn't work to spawn on player
		SetColorFade(20.0, 0.1, "WHITE")
		StartSoundEffect("portalx.wav")
		x.audio1 = AudioMessage("tcdw0807.wav") --SUCCEED - now to Elysium undetected
		ClearObjectives()
		AddObjective("tcdw0805.txt", "GREEN", 3.0)
		AddObjective("\n\nMISSION COMPLETE", "GREEN", 3.0)
		x.ewardeclare = false
		x.MCAcheck = true
		x.spine = x.spine + 1
	end
	
	--MISSION SUCCESS
	if x.spine == 11 and IsAudioMessageDone(x.audio1) then
		SucceedMission(GetTime() + 1.0, "tcdw08w.des") --WINNER WINNER WINNER
		x.spine = 666
	end
	----------END MAIN SPINE ----------
	
	--CAMERA 1 INTRO
	if x.camstate == 1 then
		CameraObject(x.mytank, 0, 10, x.camadjust, x.dummy)
		x.camadjust = x.camadjust - 0.25
	end
	
	--CAMERA 2 PORTAL
	if x.camstate == 2 then
		CameraObject(x.dummy, -30 , 20, 130, x.dummy2)
	end
	
	--EAPC RETREAT --setup for mission failure
	if x.eapcstate == 2 and x.waittime < GetTime() then
		SetCommand(x.eapc, 48) --need to tell it do undeploy
		x.eapcstate = 3
	elseif x.eapcstate == 3 and IsAlive(x.eapc) then
		Goto(x.eapc, "epretreat")
		x.eapcstate = 4
	elseif x.eapcstate == 4 and IsAlive(x.eapc) and GetDistance(x.eapc, x.dummy2) < 10 then
		StartSoundEffect("portalx.wav", x.dummy2)
		RemoveObject(x.eapc)
		x.eapcstate = 5
	end
	
	--PREVENT HOPOUT OR EJECT AT THE --VERY--END
	if IsOdf(x.player, "kvapc") and IsAlive(x.eapc) and GetDistance(x.eapc, x.dummy2) < 15 then
		x.controls = {eject = 0, abandon = 0} --{braccel = 0, strafe = 0, jump = 0, deploy = 0, eject = 0, abandon = 0, fire = 0}
		SetControls(x.player, x.controls)
	end
	
	--WARCODE - portal spawn
	if x.ewardeclare then
		for index = 1, x.ewartotal do	
			if x.ewartime[index] < GetTime() then 
				--SET WAVE NUMBER AND BUILD SIZE
				if x.ewarstate[index] == 1 then	
					x.ewarwave[index] = x.ewarwave[index] + 1
					if x.ewarwave[index] > x.ewarwavemax[index] then
						x.ewarwave[index] = x.ewarwavereset[index]
					end
					--SET WAVE SIZE
					if x.ewarwave[index] == 1 then
						x.ewarsize[index] = 4 + x.ewarsizeadd
					elseif x.ewarwave[index] == 2 then
						x.ewarsize[index] = 5 + x.ewarsizeadd
					elseif x.ewarwave[index] == 3 then
						x.ewarsize[index] = 6 + x.ewarsizeadd
					elseif x.ewarwave[index] == 4 then
						x.ewarsize[index] = 7 + x.ewarsizeadd
					else --x.ewarwave[index] == 5 then
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
						StartSoundEffect("portalx.wav", x.dummy2)
						if x.randompick == 1 or x.randompick == 7 or x.randompick == 13 then
							x.ewarrior[index][index2] = BuildObject("kvscout", 5, GetPositionNear(x.dummypos, 0, 8, 14)) --grpspwn
						elseif x.randompick == 2 or x.randompick == 8 or x.randompick == 14 then
							x.ewarrior[index][index2] = BuildObject("kvmbike", 5, x.dummypos)
						elseif x.randompick == 3 or x.randompick == 9 or x.randompick == 15 then
							x.ewarrior[index][index2] = BuildObject("kvmisl", 5, x.dummypos)
						elseif x.randompick == 4 or x.randompick == 10 or x.randompick == 16 then
							x.ewarrior[index][index2] = BuildObject("kvtank", 5, x.dummypos)
						elseif x.randompick == 5 or x.randompick == 11 or x.randompick == 17 then
							x.ewarrior[index][index2] = BuildObject("kvrckt", 5, x.dummypos)
						else
							x.ewarrior[index][index2] = BuildObject("kvrckt", 5, x.dummypos)
						end
						SetVelocity(x.ewarrior[index][index2], (SetVector(-50.0, 0.0, 0.0))) --setvector is xyz world, ought be xyz handle
						SetSkill(x.ewarrior[index][index2], x.skillsetting)
						if x.randompick % 3 == 0 and x.skillsetting < 3 then --make some smarter
							SetSkill(x.ewarrior[index][index2], (x.skillsetting+1))
						end
						x.ewartrgt[index][index2] = nil
					end
					x.ewarabort[index] = GetTime() + 300.0 --here first in case stage goes wrong
					x.ewarstate[index] = x.ewarstate[index] + 1
				--GIVE ATTACK ORDER AND CONDUCT UNIT BATTLE
				elseif x.ewarstate[index] == 3 then
					for index2 = 1, x.ewarsize[index] do
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
							else --shouldn't ever run
								x.ewartrgt[index][index2] = x.player
							end
							if not x.ewarabortset[index] then
								x.ewarabort[index] = x.ewartime[index] + 300.0
								x.ewarabortset[index] = true
							end
							x.ewarriortime[index][index2] = GetTime()
						end
						--GIVE ATTACK
						if x.ewarriortime[index][index2] < GetTime() and IsAlive(x.ewarrior[index][index2]) and IsAlive(x.ewartrgt[index][index2])then
							Attack(x.ewarrior[index][index2], x.ewartrgt[index][index2])
							x.ewarriortime[index][index2] = GetTime() + 30.0
						end
						--CHECK IF SQUAD MEMBER DEAD
						if not IsAlive(x.ewarrior[index][index2]) then
							x.ewartrgt[index][index2] = nil
							x.casualty = x.casualty + 1
						end
					end
					
					--DO CASUALTY COUNT
					if x.casualty >= math.floor(x.ewarsize[index] * 0.8) then --reset attack group
						x.ewarabort[index] = 99999.9
						x.ewartime[index] = GetTime() + x.ewartimecool[index] + x.ewartimeadd[index]
						if x.ewarwave[index] == 5 then --extra time after max wave to "ease up"
							if IsAround(x.eapc) then --reduce big cool if eapc alive
								x.ewartimeadd[index] = -60.0
							end
							x.ewarsizeadd = x.ewarsizeadd + 1
							x.ewartime[index] = GetTime() + x.ewartimecool[index] + x.ewartimeadd[index] + 60.0
						end
						x.ewarstate[index] = 1 --RESET
						x.ewarabortset[index] = false
					end
					x.casualty = 0
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
		if x.eapcstate == 5 then --EAPC ESCAPED
			AudioMessage("tcdw0806.wav") --FAIL - wasting resources -lost Recy(?)
			ClearObjectives()
			AddObjective("CRA APC and Engineering Team ESCAPED.\n\nMISSION FAILED!", "RED")
			FailMission(GetTime() + 10.0, "tcdw08f1.des") --LOSER LOSER LOSER
			x.MCAcheck = true
			x.spine = 666
		end
		
		if ((x.eapcstate > 0 and x.eapcstate < 5) or x.eapcstate == 6) and not IsAround(x.eapc) then --EAPC DESTROYED
			AudioMessage("tcdw0805.wav") --FAIL - lost/killed APC - RTB IO
			ClearObjectives()
			if x.eapcstate == 6 then
				AddObjective("CRA APC destroyed.\n\nMISSION FAILED!", "RED")
			else
				AddObjective("CRA APC and Engineering Team killed.\n\nMISSION FAILED!", "RED")
			end
			FailMission(GetTime() + 14.0, "tcdw08f2.des") --LOSER LOSER LOSER
			x.MCAcheck = true
			x.spine = 666
		end
		
		if x.eapcstate == 6 and x.waittime < GetTime() then --player apc waited to enter the portal
			StopCockpitTimer()
			HideCockpitTimer()
			AudioMessage("alertpulse.wav")
			ClearObjectives()
			AddObjective("You were too slow to enter the portal and were detected by the CRA who closed the exit on Elysium.\n\nMISSION FAILED!", "RED")
			FailMission(GetTime() + 4.0, "tcdw08f6.des") --LOSER LOSER LOSER
			x.MCAcheck = true
			x.spine = 666
		end
		
		if x.eapcstate > 0 and x.eapcstate < 2 and not IsAliveAndPilot(x.eapc) then --EAPC SNIPED EARLY
			AudioMessage("tcdw0805.wav") --FAIL - lost/killed APC - RTB IO
			ClearObjectives()
			AddObjective("CRA APC and Engineering Team killed.\n\nMISSION FAILED!", "RED")
			FailMission(GetTime() + 14.0, "tcdw08f2.des") --LOSER LOSER LOSER
			x.MCAcheck = true
			x.spine = 666
		end
		
		if not IsAlive(x.frcy) then --RECYCLER DESTROYED
			AudioMessage("tcdw0806.wav") --FAIL - wasting resources -lost Recy(?)
			ClearObjectives()
			AddObjective("Recycler destroyed.\n\nMISSION FAILED!", "RED")
			FailMission(GetTime() + 10.0, "tcdw08f3.des") --LOSER LOSER LOSER
			x.MCAcheck = true
			x.spine = 666
		end
		
		if not IsAlive(x.eprt) then --PEGASUS DESTROYED
			AudioMessage("tcdw0806.wav") --FAIL - wasting resources -lost Recy(?)
			ClearObjectives()
			AddObjective("Pegasus Portal destroyed.\n\nMISSION FAILED!", "RED")
			FailMission(GetTime() + 10.0, "tcdw08f4.des") --LOSER LOSER LOSER
			x.MCAcheck = true
			x.spine = 666
		end
		
		if IsAround(x.eapc) and GetTug(x.eapc) then	--USED TUG ON EAPC, some smartarse might try it.
			x.eapcstate = 666
			AudioMessage("tcdw0806.wav") --FAIL - wasting resources -lost Recy(?)
			ClearObjectives()
			AddObjective("-APC notified CRA that it's held by a tug.\n-CRA side of the portal has been blocked.\n\nMISSION FAILED!", "RED")
			FailMission(GetTime() + 10.0, "tcdw08f5.des") --LOSER LOSER LOSER
			x.MCAcheck = true
			x.spine = 666
		end	
	end
end
--[[END OF SCRIPT]]