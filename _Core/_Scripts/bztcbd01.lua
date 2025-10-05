--bztcbd01 - Battlezone Total Command - Rise of the Black Dogs - 1/10 - GRAB THE SCIENTISTS
assert(load(assert(LoadFile("_requirefix.lua")),"_requirefix.lua"))();
TCC = require("TC_Core")
MisnNum = 3;
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
	easy = 0, 
	medium = 1, 
	hard = 2, --tried 1-3, in 185, 3 didn't seem to make any difference,
	pos = {}, 
	audio1 = nil, 
	audio6 = nil, 
	fnav = {},	
	casualty = 0,
	fgrp = {},
	repel = {}, 
	servpod = nil, 
	ehqr = nil, 
	ecom = nil, 
	etec = nil, 
	etrn = nil, 
	etrn2 = nil, 
	etnk = {}, 
	etur = {}, 
	epwr = {}, 
	eatk = {}, 
	eatkretreat = 0, 
	erelic = nil, 
	commstate = 0, 
	commtime = 99999.9, 
	commdone = false, 
	camstate = 0, 
	camtime = 99999.9,
	camfov = 60,  --185 default
	userfov = 90,  --seed
	panx = 0, 
	pany = 0, 
	panz = 0, 
	LAST = true
}
--PATHS: pmytank, fpgrp(0-10), fpnav1-4, epatk1-5, eptnk(0-16), eptur(0-16), pretreat, pserv

function InitialSetup()
	SetAutoGroupUnits(true)
		
	local odfpreload = {
		"mvscout", "mvrckt", "mvturr", "mvapc", "mbtrain", "nvtank", "nvtug", "bvtank", "bvrckt", "hadrelic07", "apservm", "repelenemy400", "apcamrb" 
	}
	for k,v in pairs(odfpreload) do
		PreloadODF(v)
	end
	
	x.ehqr = GetHandle("ehqr")
	x.ecom = GetHandle("ecom")
	x.etec = GetHandle("etec")
	x.etrn = GetHandle("etrn")
	x.etrn2 = GetHandle("etrn2")
	for index = 1, 12 do
		x.epwr[index] = GetHandle(("epwr%d"):format(index))
	end
	
	for index = 5, 7 do
		for index2 = 5, 7 do
			Ally(index, index2)
		end
	end
	SetColorFade(6.0, 0.5, "BLACK")
	TCC.InitialSetup();
end

function PostRun()
	TCC.PostRun();
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

function Start()
	TCC.Start();
end

function AddObject(h)
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
		x.audio1 = AudioMessage("tcbd0101.wav") --goto 1 id hq tower
		x.mytank = BuildObject("bvtank", 1, "pmytank")
		GiveWeapon(x.mytank, "gchana_c")
		SetAsUser(x.mytank, 1)
		RemoveObject(x.player)
		x.player = GetPlayerHandle()
		for index = 1, 5 do
			x.fgrp[index] = BuildObject("bvtank", 1, "fpgrp", index)
			GiveWeapon(x.fgrp[index], "gchana_c")
			SetSkill(x.fgrp[index], 3)
			SetGroup(x.fgrp[index], 0)
			if x.skillsetting >= x.medium then
				x.fgrp[index+5] = BuildObject("bvtank", 1, "fpgrp", index+5)
				GiveWeapon(x.fgrp[index+5], "gchana_c")
				SetSkill(x.fgrp[index+5], 3)
				SetGroup(x.fgrp[index+5], 1)
			end
			x.fgrp[index+10] = BuildObject("bvrckt", 1, "fpgrp", index+10)
			SetSkill(x.fgrp[index+10], 3)
			SetGroup(x.fgrp[index+10], 0)
			if x.skillsetting == x.hard then
				x.fgrp[index+15] = BuildObject("bvrckt", 1, "fpgrp", index+15)
				SetSkill(x.fgrp[index+15], 3)
				SetGroup(x.fgrp[index+15], 1)
			end
		end
		x.eatk[6] = BuildObject("mvapc", 5, "epatk6")
		for index = 1, 24 do
			x.servpod = BuildObject("apservm", 0, "pserv", index)
		end
		x.pos = GetTransform(x.etrn)
		RemoveObject(x.etrn)
		x.etrn = BuildObject("mbtrain", 5, x.pos)
		x.pos = GetTransform(x.etrn2)
		RemoveObject(x.etrn2)
		x.etrn2 = BuildObject("mbtrain", 5, x.pos)
		--all 16 was too difficult
		x.etur[3] = BuildObject("mvturr", 5, "eptur", 3)
		x.etur[4] = BuildObject("mvturr", 5, "eptur", 4)
		x.etur[7] = BuildObject("mvturr", 5, "eptur", 7)
		x.etur[8] = BuildObject("mvturr", 5, "eptur", 8)
		x.etur[11] = BuildObject("mvturr", 5, "eptur", 11)
		x.etur[12] = BuildObject("mvturr", 5, "eptur", 12)
		x.etur[15] = BuildObject("mvturr", 5, "eptur", 15)
		x.etur[16] = BuildObject("mvturr", 5, "eptur", 16)
		for index = 3, 16 do 
			SetSkill(x.etur[index], x.skillsetting)
		end
		for index = 1, 4 do
			x.etnk[index] = BuildObject("mvscout", 5, "eptnk", index)
			SetSkill(x.etnk[index], x.skillsetting)
		end
		x.panx = 30
		x.pany = 30
		x.panz = 200
		x.camstate = 1
	x.userfov = IFace_GetInteger("options.graphics.defaultfov")
	CameraReady()
	IFace_SetInteger("options.graphics.defaultfov", x.camfov)
		x.spine = x.spine + 1	
	end
	
	--GIVE FIRST OBJECTIVE
	if x.spine == 1 and (CameraCancelled() or IsAudioMessageDone(x.audio1)) then
		x.camstate = 0
	CameraFinish()
	IFace_SetInteger("options.graphics.defaultfov", x.userfov)
		ClearObjectives()
		AddObjective("tcbd0101.txt")
		x.fnav[1] = BuildObject("apcamrb", 1, "fpnav1")
		SetObjectiveName(x.fnav[1], "Nav 1 Get Data")
		SetObjectiveOn(x.fnav[1])
		x.repel[1] = BuildObject("repelenemy400", 5, x.epwr[1])
		x.repel[2] = BuildObject("repelenemy400", 5, x.epwr[5])
		x.repel[3] = BuildObject("repelenemy400", 5, x.etec)
		x.spine = x.spine + 1
	end
	
	--START COMM TOWER
	if x.spine == 2 then
		if x.commstate == 0 and IsAlive(x.player) and IsAlive(x.ecom) and GetDistance(x.player, x.ecom) <= 40 then
			AudioMessage("tcss1101.wav") --Init comm uplink. Computer
			x.commtime = GetTime() + 20.0
			x.waittime = GetTime() + 2.0
			x.commstate = 1
		end
		
		if x.commstate == 1 and IsAlive(x.player) and IsAlive(x.ecom) and GetDistance(x.player, x.ecom) > 40 then
			AudioMessage("tcss1103.wav") --Comm uplink lost Computer
			x.commstate = 0
		end
		
		if x.commstate == 1 and x.commtime < GetTime() then
			x.audio1 = AudioMessage("tcss1104.wav") --data intercept complete. Computer
			x.waittime = 99999.9
			x.commstate = 2
			x.spine = x.spine + 1
		end
		
		if x.commstate == 1 and x.waittime < GetTime() then
			StartSoundEffect("tcss1112.wav") --scanning sound
			x.waittime = GetTime() + 2.0
		end
	end
	
	--END COMM, NEXT OBJECTIVE
	if x.spine == 3 and IsAudioMessageDone(x.audio1) then
		x.audio1 = AudioMessage("tcbd0102.wav") --goto nav2 kill solar
		ClearObjectives()
		AddObjective("tcbd0101.txt", "GREEN")
		AddObjective("	")
		AddObjective("tcbd0102.txt")
		RemoveObject(x.fnav[1])
		x.fnav[2] = BuildObject("apcamrb", 1, "fpnav2")
		SetObjectiveName(x.fnav[2], "Nav 2 Solar 1")
		SetObjectiveOn(x.fnav[2])
		RemoveObject(x.repel[1])
		x.etnk[5] = BuildObject("mvscout", 5, "eptnk", 5)
		x.etnk[6] = BuildObject("mvscout", 5, "eptnk", 6)
		x.etnk[7] = BuildObject("mvrckt", 5, "eptnk", 7)
		x.etnk[8] = BuildObject("mvrckt", 5, "eptnk", 8)
		for index = 5, 8 do
			SetSkill(x.etnk[index], x.skillsetting)
		end
		x.commdone = true
		x.spine = x.spine + 1
	end
	
	--DESTROY SOLAR ARRAY 1
	if x.spine == 4 and IsAudioMessageDone(x.audio1) then
		for index = 1, 4 do
			if not IsAlive(x.epwr[index]) then
				x.casualty = x.casualty + 1
			end
		end
		
		if x.casualty == 4 then
			x.audio1 = AudioMessage("tcbd0103.wav") --goto nav3 kill solar
			ClearObjectives()
			AddObjective("tcbd0102.txt", "GREEN")
			AddObjective("	")
			AddObjective("tcbd0103.txt")
			RemoveObject(x.fnav[2])
			x.fnav[3] = BuildObject("apcamrb", 1, "fpnav3")
			SetObjectiveName(x.fnav[3], "Nav 3 Solar 2")
			SetObjectiveOn(x.fnav[3])
			RemoveObject(x.repel[2])
			x.etnk[9] = BuildObject("mvscout", 5, "eptnk", 9)
			x.etnk[10] = BuildObject("mvscout", 5, "eptnk", 10)
			x.etnk[11] = BuildObject("mvrckt", 5, "eptnk", 11)
			x.etnk[12] = BuildObject("mvrckt", 5, "eptnk", 12)
			for index = 9, 12 do
				SetSkill(x.etnk[index], x.skillsetting)
			end
			x.spine = x.spine + 1
		end
		x.casualty = 0
	end
	
	--DESTROY SOLAR ARRAY 2
	if x.spine == 5 then
		for index = 5, 8 do
			if not IsAlive(x.epwr[index]) then
				x.casualty = x.casualty + 1
			end
		end
		
		if x.casualty == 4 then
			for index = 1, 4 do
				x.eatk[index] = BuildObject("nvtank", 5, ("epatk%d"):format(index))
				LookAt(x.eatk[index], x.etec)
			end
			x.eatk[5] = BuildObject("nvtug", 5, "epatk5")
			x.erelic = BuildObject("hadrelic07", 5, "epatk5")
			Pickup(x.eatk[5], x.erelic)
			for index = 13, 16 do
				x.etnk[index] = BuildObject("mvscout", 5, "eptnk", index)
				SetSkill(x.etnk[index], x.skillsetting)
			end
			x.audio1 = AudioMessage("tcbd0104.wav") --power down, standby
			ClearObjectives()
			AddObjective("tcbd0103.txt", "GREEN")
			x.spine = x.spine + 1
		end
		x.casualty = 0
	end
	
	--START AIP CAM
	if x.spine == 6 and IsAudioMessageDone(x.audio1) then
		for index = 1, 5 do
			Goto(x.eatk[index], ("epatk%d"):format(index))
		end
		x.audio1 = AudioMessage("tcbd0105.wav") --goto tcen kill am
		x.camstate = 2
	x.userfov = IFace_GetInteger("options.graphics.defaultfov")
	CameraReady()
	IFace_SetInteger("options.graphics.defaultfov", x.camfov)
		x.spine = x.spine + 1
	end
	
	--AFTER CAMERA
	if x.spine == 7 and (IsAudioMessageDone(x.audio1) or CameraCancelled()) then
		x.camstate = 0
	CameraFinish()
	IFace_SetInteger("options.graphics.defaultfov", x.userfov)
		ClearObjectives()
		AddObjective("tcbd0104.txt")
		RemoveObject(x.fnav[3])
		x.fnav[4] = BuildObject("apcamrb", 1, "fpnav4")
		SetObjectiveName(x.fnav[4], "Nav 4 Soviet Base")
		SetObjectiveOn(x.fnav[4])
		RemoveObject(x.repel[3])
		x.spine = x.spine + 1
	end
	
	--MISSION SUCCESS --CCA DEAD, AIP DEAD
	if x.spine == 8 and not IsAlive(x.ehqr) and not IsAlive(x.etrn) and not IsAlive(x.etrn2) then
		TCC.SetTeamNum(x.etec, 1)
		for index = 1, 4 do
			if not IsAlive(x.eatk[index]) then
				x.casualty = x.casualty + 1
			end
		end
		if x.casualty >= 2 then
			x.MCAcheck = true
			AudioMessage("tcbd0106.wav")
			ClearObjectives()
			AddObjective("tcbd0104.txt", "GREEN")
			AddObjective("\n\nMISSION COMPLETE!", "GREEN")
			RemoveObject(x.fnav[4])
			TCC.SucceedMission(GetTime() + 11.0, "tcbd01w.des") --WINNER WINNER WINNER
			x.spine = 666
		end
	end
	----------END MAIN SPINE ----------
	
	--CAMERA CCA 1
	if x.camstate == 1 then
		CameraObject(x.ecom, x.panx, x.pany, x.panz, x.ecom)
		x.panx = x.panx - 0.02
		x.pany = x.pany - 0.02
		x.panz = x.panz - 0.1
	end
	
	--CAMERA TCEN TO TUG
	if x.camstate == 2 then
		CameraObject(x.etec, -80, 20, -70, x.eatk[5])
	end

	--APC RETREAT
	if x.eatkretreat == 0 and IsAlive(x.player) and IsAlive(x.etec) and GetDistance(x.player, x.etec) < 300 then
		Goto(x.eatk[5], "epretreat")
		SetObjectiveName(x.erelic, "Artifact")
		SetObjectiveOn(x.erelic)
		Goto(x.eatk[6], "epretreat")
		SetObjectiveName(x.eatk[6], "Scientists")
		SetObjectiveOn(x.eatk[6])
		for index = 1, 4 do
	  if IsAlive(x.eatk[index]) and GetTeamNum(x.eatk[index]) > 1 then
		SetSkill(x.eatk[index], x.skillsetting)
		Attack(x.eatk[index], x.player)
	  end
		end
		x.eatkretreat = 1
	elseif x.eatkretreat == 1 and ((IsAlive(x.eatk[5]) and GetDistance(x.eatk[5], "epretreat", 3) < 100) or (IsAlive(x.eatk[6]) and GetDistance(x.eatk[6], "epretreat", 3) < 100)) then
		RemoveObject(x.erelic)
		RemoveObject(x.eatk[5])
		RemoveObject(x.eatk[6])
		x.eatkretreat = 2
	end
	
	--CHECK STATUS OF MCA 
	if not x.MCAcheck then	 
		if not x.commdone and not IsAlive(x.ecom) then --Tower destroyed early
			ClearObjectives()
			AddObjective("tcbd0101.txt", "RED")
			AddObjective("\n\nMISSION FAILED!", "RED")
			TCC.FailMission(GetTime() + 4.0, "tcbd01f1.des") --LOSER LOSER LOSER
			x.spine = 666
			x.MCAcheck = true
		end
		
		if not IsAlive(x.etec) then --Destroyed CBB tech center
			ClearObjectives()
			AddObjective("tcbd0104.txt", "RED")
			AddObjective("\n\nMISSION FAILED!", "RED")
			TCC.FailMission(GetTime() + 4.0, "tcbd01f1.des") --LOSER LOSER LOSER
			x.spine = 666
			x.MCAcheck = true
		end
	end
end
--[[END OF SCRIPT]]