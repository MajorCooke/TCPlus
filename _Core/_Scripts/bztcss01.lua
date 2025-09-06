--bztcss01 Battlezone Total Command: Stars and Stripes - 1/17 RED ARRIVAL
assert(load(assert(LoadFile("_requirefix.lua")),"_requirefix.lua"))();
TCC = require("TC_Core")
MisnNum = 1;
--INITIALIZE VARIABLES --f-friend e-enemy p-path atk-attack scv-scavenger rcy-recycler tnk-tank cam-camera
local good = false --see note on "good" variable in spine 0 --"stock game protected" variable
local x = {
	FIRST = true,
	eatk2bresend = 99999.9,
	player = nil, 
	mytank = nil, 
	skillsetting = 0, 
	easy = 0, 
	medium = 1, 
	hard = 2, --tried 1-3, in 185, 3 didn't seem to make any difference, 
	audio1 = nil,
	spine = 0,
	pos = {}, 
	randompick = 0, --not as necessary in this script ...
	randomlast = 0, --... more important for larger groups	 
	gotfscv1 = false,
	gohome = false, 
	eatk1allow = false,
	eatk1mark = false,
	MCAcheck = false,
	eatk1hold = false,
	eatk1bhold = false,
	eatk2hold = false,
	eatk2bhold = false,
	waitbool = false, 
	waittime = 99999.9, 
	waitfail = 99999.9,
	camtime = 99999.9, 
	camspeed = 2900.0, 
	camfov = 60,  --185 default
	userfov = 90,  --seed
	eatk1time = 99999.9,
	eatk1btime = 99999.9,
	eatk2time = 99999.9,
	eatk2btime = 99999.9,
	eatk1resend = 99999.9,
	eatk1bresend = 99999.9,
	eatk2resend = 99999.9,
	fcam0 = nil, 
	fcam1 = nil,
	frcy = nil,
	fbay = nil,
	fcom = nil,
	ftec = nil,
	fscv1 = nil, 
	fscv1safe = false,
	fscv2 = nil,
	fscv2mca = false,
	fscv2safe = false, 
	flnd = nil,
	eatk1 = nil,
	eatk2 = nil,
	eatk1b = nil,
	eatk2b = nil,
	scrapnav = nil,
	pilot = nil,
	eatk2count = 0,
	eatk2bcount = 0, 
	labelcount = 0, 
	LAST = true
}
--PATHS: pplayer, plndr, fprcy, fpscv1, fpscv2, area1, epatk1, epatk1b, epatk2, cam1, cam2, fpspwn1-5 not used, plogostart
	
function InitialSetup()
	SetAutoGroupUnits(true)
	
	local odfpreload = {
		"avtank", "svscoutss01", "svmbikess01", "sspilo", "aspilo", "bztclogocox", "apcamra"
	}
	for k,v in pairs(odfpreload) do
		PreloadODF(v)
	end
	
	x.frcy = GetHandle("frcy")
	x.fbay = GetHandle("fbay")
	x.fcom = GetHandle("fcom")
	x.ftec = GetHandle("ftec")
	x.flnd = GetHandle("flnd")
	x.mytank = GetHandle("mytank")
	x.eatk1 = GetHandle("bztclogo")
	SetTeamColor(2, 50, 100, 200);
	SetTeamColor(6, 150, 20, 10);
	Ally(1, 2)
	Ally(2, 1)
	Ally(5, 6)
	Ally(6, 5)  
	SetColorFade(6.0, 0.5, "BLACK")
	TCC.Init()
end

function Save()
	return
	x, TCC.Save();
end

function Load(a, coreData)
	x = a;
	TCC.Load(coreData)
end

function AddObject(h)  
	if IsOdf(h, "sspilo") then
		RemoveObject(h)
	end
	
	if not x.gotfscv1 and IsOdf(h, "avscavss1:1") then
		if x.fscv1 == nil then --THE :1 IS TEAM NUMBER FOR VEHICLES
			x.fscv1 = h
			x.labelcount = x.labelcount + 1
			SetLabel(x.fscv1, ("fscv%d"):format(x.labelcount))
			SetObjectiveName(x.fscv1, "Escort")
			SetObjectiveOn(x.fscv1)
			x.gotfscv1 = true
		end
	end
	TCC.AddObject(h)
end

function Start()
	TCC.Start();
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
	
	--SETUP INITIAL MISSION ELEMENTS
	if x.spine == 0 then
		x.pos = GetTransform(x.mytank)
		RemoveObject(x.mytank)
		x.mytank = BuildObject("aspilo", 1, x.pos)
		x.fcam1 = BuildObject("avtank", 1, "cam1")
		SetAsUser(x.mytank, 1)
		RemoveObject(x.player)
		x.player = GetPlayerHandle()
		RemovePilot(x.flnd)
		Goto(x.fcam1, "camalt") --"cam1")
		x.audio1 = AudioMessage("tcss0101.wav") --Monologue
		x.waittime = GetTime() + 15.0
		x.camtime = GetTime() + 40.0
		x.waitbool = true
		x.pos = GetTransform(x.eatk1)
		RemoveObject(x.eatk1)
			good = false --from stock isdf14. true allows access to Scion missions branch. For BZTC don't won't scion, so keep false.
		x.userfov = IFace_GetInteger("options.graphics.defaultfov")
		CameraReady()
		IFace_SetInteger("options.graphics.defaultfov", x.camfov)
			x.spine = x.spine + 1
	end

	--RUN THE INTRO CINERACTIVE
	if x.spine == 1 then
		--CameraPath("cam2", 1500, x.camspeed, x.fcam1) --2900
		--x.camspeed = x.camspeed + 0.5 --0.4 --0.3 --0.2
		CameraObject(x.fcam1, 40, 10, -10, x.fcam1) --well this works just as well
		if GetDistance(x.fcam1, "plogostart") < 72 then
			x.eatk1 = BuildObject("bztclogocox", 0, x.pos)
			x.spine = x.spine + 1
		end
	end
  
  --REMEMBER MY NAME ... my mod's name, and I wanted to do a text model
	if x.spine == 2 then
		CameraObject(x.eatk1, 0, 16, 130, x.eatk1)
		if CameraCancelled() or IsAudioMessageDone(x.audio1) then
			CameraFinish()
			IFace_SetInteger("options.graphics.defaultfov", x.userfov)
			RemoveObject(x.fcam1)
			RemoveObject(x.eatk1)
			x.waittime = GetTime() + 2.0
			SetColorFade(6.0, 0.5, "BLACK")
			SetScrap(1, 24)
			x.waitbool = false
			x.spine = x.spine + 1
		end
	end

	--SETUP MISSION AFTER CINERACTIVE
	if x.spine == 3 and x.waittime < GetTime() then
		SetObjectiveName(x.frcy, "Outpost 3")
		SetObjectiveOn(x.frcy)
		x.audio1 = AudioMessage("tcss0102.wav") --Build scav, collect scrap
		x.scrapnav = BuildObject("apcamra", 1, "area1")
		SetObjectiveName(x.scrapnav, "Bio-Metal Field")
		SetObjectiveOn(x.scrapnav)
		x.fcam1 = BuildObject("aptecha", 0, "pwpn1")
		x.fcam1 = BuildObject("appopga", 0, "pwpn2")
		x.spine = x.spine + 1
	end

	--GIVE PRIMARY MISSION OBJECTIVE
	if x.spine == 4 and IsAudioMessageDone(x.audio1) then
		ClearObjectives()
		AddObjective("tcss0101.txt")
		x.spine = x.spine + 1
	end

	--IF PLAYER BUILDS FIRST SCAVENGER, WAIT A FEW SECS 
	if x.spine == 5 and x.gotfscv1 then
		x.waittime = GetTime() + 3.0
		x.spine = x.spine + 1
	end

	--THEN SEND FSCV1 OFF AUTOMATICALLY
	if x.spine == 6 and x.waittime < GetTime() then
		Goto(x.fscv1, "area1", 0) --0 x.Player control - 1 Take control from x.Player.
		x.spine = x.spine + 1
	end

	--HAS SCAVENGER ARRIVED AT SCRAP FIELD
	if x.spine == 7 and IsAlive(x.fscv1) and GetDistance(x.fscv1, "area1") < 200 then
		if GetMaxScrap(1) > 4 then --haha - don't get to meet quoata by blowing up your units
			SetScrap(1, 0)
		end
		AudioMessage("tcss0103.wav") --Un-ID vehc approach from SW
		x.eatk1allow = true
		x.spine = x.spine + 1
	end

	--CHECK IF SCRAP QUOTA HAS BEEN MET
	if x.spine == 8 and IsAlive(x.fscv1) and GetDistance(x.fscv1, x.frcy) > 300 then
		if (IsAlive(x.fscv1) and (GetCurHealth(x.fscv1) <= (GetMaxHealth(x.fscv1) * 0.5)) and (GetScrap(1) > 40)) or (IsAlive(x.player) and GetCurHealth(x.player) <= (GetMaxHealth(x.player) * 0.3)) then
			x.gohome = true
		elseif GetScrap(1) >= 70 then
			x.gohome = true
		end
		if x.gohome then
			x.audio1 = AudioMessage("tcss0104.wav") --Cmd you hvy outnumber protect scv proceed outpost 3
			Goto(x.fscv1, "fpscv1", 0)
			if IsAlive(x.scrapnav) then
				SetObjectiveOff(x.scrapnav)
				RemoveObject(x.scrapnav)
			end
			x.spine = x.spine + 1
		end
	end

	--GIVE NEXT MISSION OBJECTIVE
	if x.spine == 9 and IsAudioMessageDone(x.audio1) then
		ClearObjectives()
		AddObjective("tcss0101.txt", "GREEN")
		AddObjective("	")
		AddObjective("tcss0102.txt") --YELLOW)
		x.spine = x.spine + 1
	end

	--SCRAP COLLECTED, NOW GET SCAV 1 HOME AND START UP SCAV 2
	if x.spine == 10 and IsAlive(x.fscv1) and GetDistance(x.fscv1, "fpscv1") < 100 then
		SetCurHealth(x.fscv1, GetMaxHealth(x.fscv1))
		SetObjectiveOff(x.fscv1)
		x.audio1 = AudioMessage("tcss0105.wav") --Unfort we have another scav that is threatened
		x.fscv2 = BuildObject("avscavss1", 2, "fpscv2")--create x.fscv2 on team 2 and send to fpscv1
		Goto(x.fscv2, "fpscv1")
		x.fscv1safe = true
		x.eatk1allow = false
		x.fscv2mca = true
		x.spine = x.spine + 1
	end

	--GIVE NEXT MISSION OBJECTIVE
	if x.spine == 11 and IsAudioMessageDone(x.audio1) then
		ClearObjectives()
		AddObjective("tcss0102.txt", "GREEN")
		AddObjective("	")
		AddObjective("tcss0103.txt", "YELLOW")
		SetObjectiveOn(x.fscv2)
		SetObjectiveName(x.fscv2, "Rescue")
		x.eatk2allow = true
		x.waittime = GetTime() + 15.0
		if x.skillsetting == x.medium then
			x.waittime = GetTime() + 10.0
		elseif x.skillsetting == x.hard then
			x.waittime = GetTime() + 5.0
		end
		x.spine = x.spine + 1
	end

	--BIG LOOP TO MAKE SURE 2ND SCAV MAKES IT HOME
	if x.spine == 12 and IsAlive(x.fscv2) and GetDistance(x.fscv2, "fpscv1") < 100 then
		AddHealth(x.fscv2, 10000)
		SetObjectiveOff(x.fscv2)
		AudioMessage("tcss0106.wav") --Vech of soviet orign bypase outpost 3 on to EN1
		TCC.SucceedMission(GetTime() + 12.0, "tcss01w.des") --WINNER WINNER WINNER
		ClearObjectives()
		AddObjective("tcss0103.txt", "GREEN")
		AddObjective("	")
		AddObjective("tcss0104.txt", "GREEN")
		x.fscv2safe = true
		x.eatk2allow = false
		x.fscv2mca = false
		x.spine = 666
	end
	----------END MAIN SPINE ----------

	--SENDING ENEMY 1 UNITL 1ST SCAV GETS HOME
	if (x.eatk1allow) then
		if (not IsAlive(x.eatk1) and not x.eatk1hold) then
			x.eatk1time = GetTime() + 18.0
			if (x.eskillsetting == 1) then 
				x.eatk1time = GetTime() + 15.0
			elseif (x.eskillsetting == 2) then 
				x.eatk1time = GetTime() + 12.0
			end
			if (not x.eatkhold) then --for 1st attack only
				x.eatktime = GetTime() --+ 5.0
			end
			x.eatk1hold = true
		end
		
		if x.eatk1time < GetTime() then
			x.eatk1 = BuildObject("svscoutss01", 5, "epatk1")
			SetSkill(x.eatk1, x.skillsetting)
			if not x.eatk1mark then --mark first fighter like orig
				SetObjectiveName(x.eatk1, "Unknown Contact")
				SetObjectiveOn(x.eatk1)
				x.eatk1mark = true
			else
				SetObjectiveName(x.eatk1, "Scav Killer") --hide "Flanker" initially
			end
			x.eatk1time = 99999.9
			x.eatk1resend = GetTime()
			x.eatk1hold = false
		end
		
		if IsAlive(x.eatk1) and x.eatk1resend < GetTime() then
			if not IsPlayer(x.eatk1) then
				Attack(x.eatk1, x.fscv1)
			end
			x.eatk1resend = GetTime() + 10.0
		end
		
		--ASSASSIN 1
		if not IsAlive(x.eatk1b) and not x.eatk1bhold then
			x.eatk1btime = GetTime() + 30.0 --25.0 
			if x.eskillsetting == 1 then
				x.eatk1btime = GetTime() + 25.0 --20.0
			elseif x.eskillsetting == 2 then
				x.eatk1btime = GetTime() + 20.0 --15.0
			end
			x.eatk1bhold = true
		end
		
		if x.eatk1btime < GetTime() then
			while x.randompick == x.randomlast do --random the random
				x.randompick = math.floor(GetRandomFloat(1.0, 7.0))
			end
			x.randomlast = x.randompick
			if x.randompick % 2 ~= 0 then
				x.eatk1b = BuildObject("svscoutss01", 6, "epatk1b")
			else
				x.eatk1b = BuildObject("svmbikess01", 6, "epatk1b")
			end
			SetSkill(x.eatk1b, x.skillsetting)
			SetObjectiveName(x.eatk1b, "Assassin")
			x.eatk1btime = 99999.9
			x.eatk1bresend = GetTime()
			x.eatk1bhold = false
		end
		
		if IsAlive(x.eatk1b) and x.eatk1bresend < GetTime() then
			if not IsPlayer(x.eatk1b) then
				Attack(x.eatk1b, x.player)
			end
			x.eatk1bresend = GetTime() + 10.0
		end
	end
	
	--SENDING ENEMY 2 UNITL 2nd SCAV GETS HOME
	if x.eatk2allow and x.waittime < GetTime() then
		if not IsAlive(x.eatk2) then
			if x.eatk2count == 0 then
				x.eatk2 = BuildObject("svscoutss01", 5, "fpscv2")
			elseif x.eatk2count == 1 then
				x.eatk2 = BuildObject("svmbikess01", 5, "fpscv2")
			else
				x.eatk2 = BuildObject("svscoutss01", 5, "epatk2b")
			end
			SetSkill(x.eatk2, x.skillsetting)
			SetObjectiveName(x.eatk1, "Scav Killer")
			x.eatk2resend = GetTime()
			x.eatk2count = x.eatk2count + 1
		end
		
		if IsAlive(x.eatk2) and x.eatk2resend < GetTime() then
			if not IsPlayer(x.eatk2) then
				Attack(x.eatk2, x.fscv2)
			end
			x.eatk2resend = GetTime() + 10.0
		end
		
		--ASSASSIN 2
		if not IsAlive(x.eatk2b) then
			x.eatk2b = BuildObject("svmbikess01", 6, "epatk2b")
			SetSkill(x.eatk2b, x.skillsetting)
			SetObjectiveName(x.eatk2b, "Assassin")
			x.eatk2bresend = GetTime()
		end
		
		if IsAlive(x.eatk2b) and x.eatk2bresend < GetTime() then
			if not IsPlayer(x.eatk2b) then
				Attack(x.eatk2b, x.player)
			end
			x.eatk2bresend = GetTime() + 10.0
		end
	end

	--CHECK STATUS OF MISSION-CRITICAL ASSETS (MCA)
	if not x.MCAcheck then
		if (not IsAlive(x.fscv1) and x.gotfscv1 and not x.fscv1safe) or (x.fscv2mca and not IsAlive(x.fscv2))then --lose a scav?
			AudioMessage("tcss0107.wav") --FAIL - scav lost
			TCC.FailMission(GetTime() + 8.0, "tcss01f1.des") --LOSER LOSER LOSER
			ClearObjectives()
			AddObjective("tcss0105.txt", "RED")
			x.MCAcheck = true
		end
		
		if not IsAlive(x.frcy) then --frcy lost
			AudioMessage("failrecygencowav") --6s Gen Col Generic Recycler lost.
			TCC.FailMission(GetTime() + 7.0, "tcss01f2.des") --LOSER LOSER LOSER
			ClearObjectives()
			AddObjective("tcss0106.txt", "RED") --Your Recycler was destroyed. MISSION FAILEDnot
			x.MCAcheck = true
		end
		
		if not IsAlive(x.fbay) or not IsAlive(x.fcom) or not IsAlive(x.ftec) then --MCA lost --DON'T BLOW UP YOUR OWN BASE (FOR SCRAP)
			TCC.FailMission(GetTime() + 4.0, "tcss01f3.des") --LOSER LOSER LOSER
			ClearObjectives()
			AddObjective("tcss0107.txt", "RED") --You lost a mission-critical asset. MISSION FAILED
			x.MCAcheck = true
		end
		
		if not x.waitbool and not x.gotfscv1 and GetScrap(1) < 20 then --You can't be trusted with a budget
			x.waitfail = GetTime() + 15.0 --IF spent on scav, wait for it to exist to stop fail
			x.waitbool = true
		end
		
		if not x.gotfscv1 and x.waitfail < GetTime() then
			TCC.FailMission(GetTime() + 4.0, "tcss01f4.des") --LOSER LOSER LOSER
			ClearObjectives()
			AddObjective("tcss0108.txt", "RED")
			x.MCAcheck = true
		end
	end
end
--[[END OF SCRIPT]]