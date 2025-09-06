--bztcbd04 - Battlezone Total Command - Rise of the Black Dogs - 4/10 - THE MAMMOTH PROJECT
assert(load(assert(LoadFile("_requirefix.lua")),"_requirefix.lua"))();
TCC = require("TC_Core")
MisnNum = 8;
local index = 0
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
	fnav = {},	
	casualty = 0,
	fgrp = {},
	servpod = nil, 
	emam = nil, 
	emam2 = nil, 
	epwr = {}, 
	etur = {}, 
	eatk = {}, 
	etnk = {}, 
	eblk = {}, 
	eblklife = {0, 0, 0, 0, 0}, 
	estp = {}, 
	etrptime = {99999.9, 99999.9, 99999.9, 99999.9, 99999.9}, 
	estpstate = {0, 0, 0, 0, 0, 0}, 
	bomb = nil, 
	itsatrap = false, 
	stopplayer = false, 
	dummy = nil, 
	plyrhealth = 0, 
	gotrocket = false, 
	fdrp = nil, 
	fdrppos = {}, 
	repel = nil, 
	camstate = 0, 
	camfov = 60,  --185 default
	userfov = 90,  --seed
	LAST = true
}
--PATHS: pmytank, fpgrp(0-20), fpnav1-3, epatk(0-16), eptnk(0-4), eptur(0-8), craterarea, epblk1-3, epstop1-5, eptrap1-5, pcam1, pledge

function InitialSetup()
	SetAutoGroupUnits(true)
		
	local odfpreload = {
		"sbpgen2", "svscout", "svmbike", "svmisl", "svtank", "svrckt", "svstnk", "svturr", "nvmbike", "nvmisl", "nvtank", "nvrckt", "nvstnk", 
		"grktpa", "grktpa2", "bvmbike", "bvmisl", "bvtank", "bvrckt", "bvdrop", "apservs", "apdwqka2", "dummy00", "repelenemy400", "apcamrb" 
	}
	for k,v in pairs(odfpreload) do
		PreloadODF(v)
	end
	
	x.fdrp = GetHandle("fdrp")
	x.ercy = GetHandle("ercy")
	x.emam = GetHandle("emam")
	x.emam2 = GetHandle("emam2")
	for index = 1, 6 do
		x.epwr[index] = GetHandle(("epwr%d"):format(index))
	end
	SetColorFade(6.0, 0.5, "BLACK")
	TCC.InitialSetup();
end

function Start()
	TCC.Start();
end

function Save()
	return
	index, x, TCC.Save()
end

function Load(a, b, coreData)
	index = a;
	x = b;
	TCC.Load(coreData)
end

function AddObject(h)
	--no ercy, and loose enemy pilots are annoying
	if (IsCraftButNotPerson(h)) then
		SetEjectRatio(h, 0.0);
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
	--START THE MISSION BASICS
	if x.spine == 0 then
		x.audio1 = AudioMessage("tcbd0401.wav") --Cobra One, we're sending you to steal the Mammoth tank prototype.
		x.mytank = BuildObject("bvtank", 1, "pmytank")
		SetAsUser(x.mytank, 1)
		RemoveObject(x.player)
		x.player = GetPlayerHandle()
		GiveWeapon(x.mytank, "gflsha_c");
		GiveWeapon(x.mytank, "gblsta_c_gun");
		for index = 1, 5 do --player force
			x.fgrp[index] = BuildObject("bvmbike", 1, "fpgrp", index)
			SetSkill(x.fgrp[index], 3)
			SetGroup(x.fgrp[index], 0)
			x.fgrp[index+5] = BuildObject("bvmisl", 1, "fpgrp", index+5)
			SetSkill(x.fgrp[index+5], 3)
			SetGroup(x.fgrp[index+5], 1)
			if x.skillsetting >= x.medium then
				x.fgrp[index+10] = BuildObject("bvtank", 1, "fpgrp", index+10)
				SetSkill(x.fgrp[index+10], 3)
				SetGroup(x.fgrp[index+10], 2)
			end
			if x.skillsetting > x.medium then
				x.fgrp[index+15] = BuildObject("bvrckt", 1, "fpgrp", index+15)
				SetSkill(x.fgrp[index+15], 3)
				SetGroup(x.fgrp[index+15], 3)
			end
		end
		for index = 1, 8 do	 --turrets
			x.etur[index] = BuildObject("svturr", 5, "eptur", index)
			SetSkill(x.etur[index], x.skillsetting)
		end
		x.eatk[1] = BuildObject("svtank", 5, "epatk", 1)
		x.eatk[2] = BuildObject("svmisl", 5, "epatk", 2)
		x.eatk[3] = BuildObject("svmbike", 5, "epatk", 3)
		x.eatk[4] = BuildObject("svtank", 5, "epatk", 4)
		x.eatk[5] = BuildObject("svscout", 5, "epatk", 5)
		x.eatk[6] = BuildObject("svscout", 5, "epatk", 6)
		x.eatk[7] = BuildObject("svrckt", 5, "epatk", 7)
		x.eatk[8] = BuildObject("svrckt", 5, "epatk", 8)
		x.eatk[9] = BuildObject("svtank", 5, "epatk", 9)
		x.eatk[10] = BuildObject("svscout", 5, "epatk", 10)
		x.eatk[11] = BuildObject("svmisl", 5, "epatk", 11)
		x.eatk[12] = BuildObject("svmbike", 5, "epatk", 12)
		x.eatk[13] = BuildObject("svrckt", 5, "epatk", 13)
		x.eatk[14] = BuildObject("svmisl", 5, "epatk", 14)
		x.eatk[15] = BuildObject("svscout", 5, "epatk", 15)
		x.eatk[16] = BuildObject("svscout", 5, "epatk", 16)
		x.eatk[17] = BuildObject("svmbike", 5, "epatk", 17)
		x.eatk[18] = BuildObject("svrckt", 5, "epatk", 18)
		x.eatk[19] = BuildObject("svmisl", 5, "epatk", 19)
		x.eatk[20] = BuildObject("svtank", 5, "epatk", 20)
		x.eatk[21] = BuildObject("svscout", 5, "epatk", 21)
		x.eatk[22] = BuildObject("svscout", 5, "epatk", 22)
		for index = 1, 22 do 
			SetSkill(x.eatk[index], x.skillsetting)
		end 
		x.pos = GetTransform(x.emam)
		RemoveObject(x.emam)
		x.emam = BuildObject("svstnk", 5, x.pos)
		x.etnk[1] = BuildObject("nvtank", 5, "eptnk", 1)
		x.etnk[2] = BuildObject("nvmisl", 5, "eptnk", 2)
		x.etnk[3] = BuildObject("nvmbike", 5, "eptnk", 3)
		x.etnk[4] = BuildObject("nvrckt", 5, "eptnk", 4)
		for index = 1, 4 do
			SetSkill(x.etnk[index], x.skillsetting)
			LookAt(x.etnk[index], x.ercy, 0)
		end
		for index = 1, 40 do
			x.servpod = BuildObject("apservs", 0, "pserv", index)
		end
		for index = 1, 6 do
			x.pos = GetTransform(x.epwr[index])
			RemoveObject(x.epwr[index])
			x.epwr[index] = BuildObject("sbpgen2", 5, x.pos)
		end
		x.fdrppos = GetTransform(x.fdrp)
		RemoveObject(x.fdrp)
		x.pos = GetTransform(x.emam2)
		x.repel = BuildObject("repelenemy400", 5, x.pos)
		x.spine = x.spine + 1	
	end
	
	--GIVE FIRST OBJECTIVE
	if x.spine == 1 and IsAudioMessageDone(x.audio1) then
		ClearObjectives()
		AddObjective("tcbd0401.txt")
		x.fnav[1] = BuildObject("apcamrb", 1, "fpnav1")
		SetObjectiveName(x.fnav[1], "Investigate Area")
		SetObjectiveOn(x.fnav[1])
		x.spine = x.spine + 1
	end
	
	--PLAYER NEAR MAMMOTH 1
	if x.spine == 2 and IsAlive(x.player) and GetDistance(x.player, x.emam) < 500 then
		x.audio1 = AudioMessage("tcbd0402.wav") --readings don't match data. tank decoy. IT'S A TRAP
		SetObjectiveOff(x.fnav[1])
		x.dummy = BuildObject("dummy00", 0, "fpnav1")
		x.fnav[4] = BuildObject("dummy00", 0, x.emam)
		x.waittime = GetTime() + 6.0
		x.plyrhealth = GetCurHealth(x.player)
		x.camstate = 1
    x.userfov = IFace_GetInteger("options.graphics.defaultfov")
    CameraReady()
    IFace_SetInteger("options.graphics.defaultfov", x.camfov)
		x.spine = x.spine + 1
	end
	
	--BUILD BOMB
	if x.spine == 3 and x.waittime < GetTime() then
		x.bomb = BuildObject("apdwqka2", 2, x.emam)
		x.waittime = GetTime() + 3.0
		x.spine = x.spine + 1
	end
	
	--ITS A TRAP!
	if x.spine == 4 and x.waittime < GetTime() then
		x.camstate = 0
    CameraFinish()
    IFace_SetInteger("options.graphics.defaultfov", x.userfov)
		RemoveObject(x.dummy)
		RemoveObject(x.fnav[4])
		ClearObjectives()
		AddObjective("tcbd0401.txt", "DKRED")
		AddObjective("	")
		AddObjective("tcbd0402.txt")
		x.pos = GetTransform(x.emam2)
		RemoveObject(x.emam2)
		x.emam2 = BuildObject("svstnk", 5, x.pos)
		for index = 9, 12 do
			x.etur[index] = BuildObject("svturr", 5, ("epblk%d"):format(index-8))
			Goto(x.etur[index], ("epblk%d"):format(index-8))
		end
		x.itsatrap = true
		for index = 1, 5 do 
			x.etrptime[index] = GetTime()
		end
		x.spine = x.spine + 1
	end
	
	--PLAYER ESCAPED TRAP
	if x.spine == 5 and IsAlive(x.player) and not IsInsideArea("craterarea", x.player) then
		RemoveObject(x.repel)
		AudioMessage("tcbd0403.wav") --Good work, still need find Mammoth tank. 
		ClearObjectives()
		AddObjective("tcbd0402.txt", "GREEN")
		AddObjective("	")
		AddObjective("tcbd0403.txt")
		x.fnav[2] = BuildObject("apcamrb", 1, "fpnav2")
		SetObjectiveName(x.fnav[2], "Capture Mammoth")
		SetObjectiveOn(x.fnav[2])
		x.spine = x.spine + 1
	end
	
	--PLAYER NEAR REAL MAMMOTH 2
	if x.spine == 6 and IsAlive(x.player) and IsAlive(x.emam2) and ((GetDistance(x.player, x.emam2) < 500 or GetDistance(x.player, "pledge") < 100)) then
		x.audio1 = AudioMessage("tcbd0405.wav") --ADDED -There are rogue NSDF forces guarding the Mammoth.
		x.plyrhealth = GetCurHealth(x.player)
		x.camstate = 2
    x.userfov = IFace_GetInteger("options.graphics.defaultfov")
    CameraReady()
    IFace_SetInteger("options.graphics.defaultfov", x.camfov)
		x.spine = x.spine + 1
	end
	
	--SEND AIP ATTACK
	if x.spine == 7 and IsAudioMessageDone(x.audio1) then
		x.camstate = 0
    CameraFinish()
    IFace_SetInteger("options.graphics.defaultfov", x.userfov)
		for index = 1, 4 do
			Attack(x.etnk[index], x.player)
		end
		x.spine = x.spine + 1
	end
	
	--PLAYER IN MAMMOTH
	if x.spine == 8 and IsAlive(x.player) and IsOdf(x.player, "svstnk") then
		AudioMessage("tcbd0404.wav") --Excellent job. get that tank to the pickup zone.
		ClearObjectives()
		AddObjective("tcbd0403.txt", "GREEN")
		AddObjective("	")
		AddObjective("tcbd0404.txt")
		SetObjectiveOff(x.fnav[2])
		x.fnav[3] = BuildObject("apcamrb", 1, "fpnav3")
		SetObjectiveName(x.fnav[3], "Escape")
		SetObjectiveOn(x.fnav[3])
		x.stopplayer = true
		x.fdrp = BuildObject("bvdrop", 0, x.fdrppos)
		SetPerceivedTeam(x.player, 1)
		x.spine = x.spine + 1
	end
	
	--RUN DROPSHIP LANDING
	if x.spine == 9 and IsAlive(x.player) and GetDistance(x.player, "fpnav3") < 600 then
		SetAnimation(x.fdrp, "land", 1)
		x.spine = x.spine + 1
	end
	
	--DROPSHIP OPEN
	if x.spine == 10 and IsAlive(x.player) and GetDistance(x.player, "fpnav3") < 200 then
		SetAnimation(x.fdrp, "open", 1)
		x.spine = x.spine + 1
	end
	
	--MISSION SUCCESS
	if x.spine == 11 and IsAlive(x.emam2) and GetDistance(x.emam2, "fpnav3") < 80 then
		x.stopplayer = false
		AudioMessage("emdotcox.wav")
		AudioMessage("win.wav")
		ClearObjectives()
		AddObjective("tcbd0404.txt", "GREEN")
		AddObjective("\n\nMISSION COMPLETE!", "GREEN")
		TCC.SucceedMission(GetTime() + 6.0, "tcbd04w.des") --WINNER WINNER WINNER
		x.MCAcheck = true
		x.spine = 666
	end
	----------END MAIN SPINE ----------
	
	--CAMERA ON MAMMOTH 1 DESTRUCTION
	if x.camstate == 1 then
		CameraObject(x.dummy, 0, 30, 0, x.fnav[4])
		SetCurHealth(x.player, x.plyrhealth)
	end
	
	--CAMERA ON AIP TANK GUARDING MAMMOTH
	if x.camstate == 2 then
		CameraPath("pcam1", 1000, 1000, x.etnk[1])
		x.plyrhealth = GetCurHealth(x.player)
	end
	
	--GIVE AT-RCKT PACK 1st TIME OUT OF TANK
	if not x.gotrocket and IsAlive(x.player) and IsPerson(x.player) then
		GiveWeapon(x.player, "grktpa2")
		x.gotrocket = true
	end
	
	--SEND TRAP FORCE
	if x.itsatrap and IsAlive(x.player) and IsInsideArea("craterarea", x.player) then
		for index = 1, 5 do
			if x.eblklife[index] < 3 and not IsAlive(x.eblk[index]) then
				if index == 5 then
					x.eblk[index] = BuildObject("svrckt", 5, "eptrap", index)
				elseif index == 4 then
					x.eblk[index] = BuildObject("svtank", 5, "eptrap", index)
				elseif index == 3 then
					x.eblk[index] = BuildObject("svmisl", 5, "eptrap", index)
				elseif index == 2 then
					x.eblk[index] = BuildObject("svmbike", 5, "eptrap", index)
				else
					x.eblk[index] = BuildObject("svscout", 5, "eptrap", index)
				end
        SetSkill(x.eblk[index], x.skillsetting)
				x.eblklife[index] = x.eblklife[index] + 1
			end
			if IsAlive(x.eblk[index]) and GetTeamNum(x.eblk[index]) ~= 1 and x.etrptime[index] < GetTime() then
				Attack(x.eblk[index], x.player)
				x.etrptime[index] = GetTime() + 10.0
			end
		end
	end
	
	--SEND AIP FORCE
	if x.stopplayer then
		for index = 1, 5 do --6 avail
			if x.estpstate[index] == 0 and IsAlive(x.player) and GetDistance(x.player, "epstop", index) < 300 then
				if index == 1 then
					x.estp[index] = BuildObject("nvmbike", 5, "epstop", index)
				elseif index == 2 then
					x.estp[index] = BuildObject("nvmisl", 5, "epstop", index)
				elseif index == 3 then
					x.estp[index] = BuildObject("nvtank", 5, "epstop", index)
				elseif index == 4 then
					x.estp[index] = BuildObject("nvrckt", 5, "epstop", index)
				else
					x.estp[index] = BuildObject("nvstnk", 5, "epstop", index)
					if x.skillsetting == x.easy then
						SetMaxHealth(x.estp[index], 8000) 
					elseif x.skillsetting == x.medium then 
						SetMaxHealth(x.estp[index], 6000)
					else
						SetMaxHealth(x.estp[index], 5000) --on hard, almost impossible to beat when higher and no player wingman
					end
				end
				x.estpstate[index] = 1
				SetSkill(x.estp[index], x.skillsetting)
				Attack(x.estp[index], x.player)
			end
		end
	end
	
	--CHECK STATUS OF MCA 
	if not x.MCAcheck then	
		if x.itsatrap and not IsAround(x.emam2) then --Real Mammoth destroyed
			ClearObjectives()
			AddObjective("tcbd0403.txt", "RED")
			AddObjective("\n\nMISSION FAILED!", "RED")
			TCC.FailMission(GetTime() + 4.0, "tcbd04f1.des") --LOSER LOSER LOSER
			x.spine = 666
			x.MCAcheck = true
		end
	end
  
  --REMOVE RPG ONCE PLAYER HAS MAMMOTH
	if x.stopplayer and IsAlive(x.player) and IsPerson(x.player) then
		GiveWeapon(x.player, "gjetpa")
	end
end
--[[END OF SCRIPT]]