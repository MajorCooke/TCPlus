--bztcbd09 - Battlezone Total Command - Rise of the Black Dogs - 9/10 - CAPTURE THE ARMORY
assert(load(assert(LoadFile("_requirefix.lua")),"_requirefix.lua"))();
TCC = require("TC_Core")
MisnNum = 53;
local index = 0
local x = {
	FIRST = true, 
	MCAcheck = false,	
	spine = 0, 
	casualty = 0, 
	randompick = 0, 
	randomlast = 0,	
	waittime = 99999.9, 
	player = nil, 
	mytank = nil, 
	skillsetting = 0, 
	easy = 0, 
	medium = 1, 
	hard = 2, 
	audio1 = nil, 
	fnav = {}, 
	pos = {},	
	evlt = nil, --VAULT DOOR
	hangar = nil, --HANGAR DOOR
	door = {}, --INTERIOR DOORS
	sarc = nil, --sarcophagus
	fgrp = {}, 
	squadcount = 0, 
	edrp = nil, 
	eatk = {}, 
	eatklength = 0, 
	epat = {}, 
	epatlength = 0, 
	epwr = nil, 
	etnk = {}, --outside guard vault
	etnkstate = 0, 
	etnktime = 99999.9, 
	egun = {}, 
	nark = nil, --Arkin stuff
	ntur = {}, 
	ntnk = {}, --inside vault
	vtnk = {}, --go into vault
	egrd = {}, 
	cam = {}, 
	camstate = 0, 
	camfov = 60,  --185 default
	userfov = 90,  --seed
	failstate = 0, 
	failtime = 99999.9, 
	keepalive = {}, 
	forcelost = false, 
	arkinlives = false, 
	arkstate = 0, 
	ptcount = 0,	
	LAST	= true
}
--PATHS: fpnav1-2, fpgrp(0-24), nptnk(0-8) into vault, ppatrol1-16, eptnk1-8, epart(0-6), eptur(0-6), epwlk(0-6), epsav(0-6), ppatrol1-16, pdummy1-4, parkdias1-4, plook1-4, parkin, parkout, parkdrp, vaultarea1, vaultarea2, tombarea, hangararea

function InitialSetup()
	SetAutoGroupUnits(true)
	
	local odfpreload = {
		"mvturr", "mvscout", "mvmbike", "mvmisl", "mvtank", "mvrckt", "mvstnk", "mvturr", "mvartl", "nbpgen0", 
		"nvturr", "nvscout", "nvmbike", "nvmisl", "nvtank", "nvrckt", "nvwalk", "nvark0", "yvcyc1", "yvpega", 
		"bvscout", "bvmbike", "bvmisl", "bvtank", "bvrckt",	"bvhtnk", "yvrckt", "dummy00", "apcamrb"
	}
	for k,v in pairs(odfpreload) do
		PreloadODF(v)
	end
	
	x.mytank = GetHandle("mytank")
	x.edrp = GetHandle("edrp")
	x.evlt = GetHandle("epvalt02")
	x.hangar = GetHandle("hangar")
	x.sarc = GetHandle("sarc")
	for index = 1, 10 do
		x.door[index] = GetHandle(("door%d"):format(index))
	end
	for index = 1, 8 do
		x.ntur[index] = GetHandle(("ntur%d"):format(index)) --outside tomb
		x.egrd[index] = GetHandle(("egrd%d"):format(index)) --vault 1 and vault 2
	end
	x.nark = GetHandle("nark") --inside tomb
	for index = 1, 12 do
		x.ntnk[index] = GetHandle(("ntnk%d"):format(index)) --inside tomb
	end
	for index = 1, 5 do
		x.egun[index] = GetHandle(("egun%d"):format(index))
	end
	for index = 1, 3 do
		x.cam[index] = GetHandle(("cam%d"):format(index))
	end
	SetColorFade(6.0, 0.5, "BLACK")
	TCC.Init();
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
	local race = GetRace(h);
	if (race == "m" or race == "n" or race == "y") then
		SetEjectRatio(h, 0.0);
	end
--	if IsOdf(h, "mspilo") or IsOdf(h, "nspilo") or IsOdf(h, "yspilo") then
--		RemoveObject(h)
--	end
	TCC.AddObject(h)
end

function Update() 
	x.player = GetPlayerHandle() --EVERY PASS SO IF PLAYER CHANGES VEHICLES
	x.skillsetting = IFace_GetInteger("options.play.difficulty")
	TCC.Update();
	--START THE MISSION BASICS
	if x.spine == 0 then
		x.audio1 = AudioMessage("tcbd0901.wav") --MODIFIED armory disc. go capture it
		x.pos = GetTransform(x.mytank)
		RemoveObject(x.mytank)
		x.mytank = BuildObject("bvtank", 1, x.pos)
		SetAsUser(x.mytank, 1)
		RemoveObject(x.player)
		x.player = GetPlayerHandle()
		x.fgrp[1] = BuildObject("bvmbike", 1, "fpgrp", 1)
		x.fgrp[2] = BuildObject("bvmisl", 1, "fpgrp", 2)
		x.fgrp[3] = BuildObject("bvtank", 1, "fpgrp", 3)
		x.fgrp[4] = BuildObject("bvrckt", 1, "fpgrp", 4)
		x.fgrp[5] = BuildObject("bvhtnk", 1, "fpgrp", 5)
		x.fgrp[6] = BuildObject("bvscout", 1, "fpgrp", 6)
		x.fgrp[7] = BuildObject("bvmisl", 1, "fpgrp", 7)
		x.fgrp[8] = BuildObject("bvtank", 1, "fpgrp", 8)
		x.fgrp[9] = BuildObject("bvrckt", 1, "fpgrp", 9)
		x.fgrp[10] = BuildObject("bvhtnk", 1, "fpgrp", 10)
		x.squadcount = 10
		if x.skillsetting >= x.medium then
			x.fgrp[11] = BuildObject("bvscout", 1, "fpgrp", 11)
			x.fgrp[12] = BuildObject("bvmisl", 1, "fpgrp", 12)
			x.fgrp[13] = BuildObject("bvtank", 1, "fpgrp", 13)
			x.fgrp[14] = BuildObject("bvrckt", 1, "fpgrp", 14)
			x.fgrp[15] = BuildObject("bvhtnk", 1, "fpgrp", 15)
      x.fgrp[16] = BuildObject("bvmbike", 1, "fpgrp", 16)
			x.squadcount = 16
		end
		if x.skillsetting >= x.hard then
			x.fgrp[17] = BuildObject("bvmisl", 1, "fpgrp", 17)
			x.fgrp[18] = BuildObject("bvtank", 1, "fpgrp", 18)
			x.fgrp[19] = BuildObject("bvrckt", 1, "fpgrp", 19)
			x.fgrp[20] = BuildObject("bvhtnk", 1, "fpgrp", 20)
			x.squadcount = 20
		end
		for index = 1, x.squadcount do
			if index %2 == 0 then
				SetGroup(x.fgrp[index], 1)
			else
				SetGroup(x.fgrp[index], 0)
			end
			SetSkill(x.fgrp[index], 3)
			LookAt(x.fgrp[index], x.evlt, 0)
		end
		for index = (x.squadcount+1), (x.squadcount+5) do
			x.fgrp[index] = BuildObject("bvserv", 1, "fpgrp", index+20)
			SetGroup(x.fgrp[index], 4)
			LookAt(x.fgrp[index], x.player, 0)
		end
    x.fgrp[x.squadcount+6] = x.player
		x.eatk[1] = BuildObject("mvartl", 5, "epart", 1)
		x.eatk[2] = BuildObject("mvartl", 5, "epart", 2) --3 and 4 moved
		x.eatk[3] = BuildObject("mvwalk", 5, "epwlk", 1)
		x.eatk[4] = BuildObject("mvwalk", 5, "epwlk", 2)
		x.eatk[5] = BuildObject("mvwalk", 5, "epwlk", 3)
		x.eatk[6] = BuildObject("mvwalk", 5, "epwlk", 4)
		x.eatk[7] = BuildObject("mvturr", 5, "eptur", 1)
		x.eatk[8] = BuildObject("mvturr", 5, "eptur", 2)
		x.eatk[9] = BuildObject("mvturr", 5, "eptur", 3)
		x.eatk[10] = BuildObject("mvturr", 5, "eptur", 4)
		x.eatk[11] = BuildObject("yvrckt", 5, "epsav", 1)
		x.eatk[12] = BuildObject("yvrckt", 5, "epsav", 2)
		x.eatk[13] = BuildObject("mvartl", 5, "epart", 3) --COPIED AND MOVED
		--wahhh too x.hard	x.eatk[1] = BuildObject("mvartl", 5, "epart", 5)
		x.eatk[14] = BuildObject("mvturr", 5, "eptur", 6)
		x.eatk[15] = BuildObject("yvrckt", 5, "epsav", 3)
		x.eatk[16] = BuildObject("yvrckt", 5, "epsav", 4)
		x.eatk[17] = BuildObject("mvartl", 5, "epart", 4) --COPIED AND MOVED
		--wahhh too x.hard	x.eatk[1] = BuildObject("mvartl", 5, "epart", 6)
		x.eatk[18] = BuildObject("mvturr", 5, "eptur", 5)
		x.eatk[19] = BuildObject("yvrckt", 5, "epsav", 5)
		x.eatk[20] = BuildObject("yvrckt", 5, "epsav", 6)
		x.epatlength = 16 --used to be skill based
		for index = 1, x.epatlength do --CBB patrols
			while x.randompick == x.randomlast do --random the random
				x.randompick = math.floor(GetRandomFloat(1.0, 15.0))
			end
			x.randomlast = x.randompick
			if x.randompick == 1 or x.randompick == 7 or x.randompick == 13 then
				x.epat[index] = BuildObject("mvscout", 5, ("ppatrol%d"):format(index))
			elseif x.randompick == 2 or x.randompick == 8 then
				x.epat[index] = BuildObject("mvmbike", 5, ("ppatrol%d"):format(index))
			elseif x.randompick == 3 or x.randompick == 9 or x.randompick == 14 then
				x.epat[index] = BuildObject("mvmisl", 5, ("ppatrol%d"):format(index))
			elseif x.randompick == 4 or x.randompick == 10 then
				x.epat[index] = BuildObject("mvtank", 5, ("ppatrol%d"):format(index))
			elseif x.randompick == 5 or x.randompick == 11 then
				x.epat[index] = BuildObject("mvrckt", 5, ("ppatrol%d"):format(index))
			else --6 12 15
				x.epat[index] = BuildObject("mvstnk", 5, ("ppatrol%d"):format(index))
			end
			SetSkill(x.epat[index], x.skillsetting)
			Patrol(x.epat[index], ("ppatrol%d"):format(index))
		end
		x.epwr = BuildObject("nbpgen0", 5, "eppwr1")
		x.epwr = BuildObject("nbpgen0", 5, "eppwr2")
		for index = 1, 8 do
			x.pos = GetTransform(x.egrd[index])
			RemoveObject(x.egrd[index])
			if index < 5 then
				x.egrd[index] = BuildObject("yvcyc1", 0, x.pos)
			else
				x.egrd[index] = BuildObject("yvpega", 0, x.pos)
			end
			RemovePilot(x.egrd[index])
		end
		x.vtnk[1] = BuildObject("nvscout", 5, "epatk1")
		x.vtnk[2] = BuildObject("nvscout", 5, "epatk2")
		x.vtnk[3] = BuildObject("nvtank", 5, "epatk3")
		x.vtnk[4] = BuildObject("nvtank", 5, "epatk4")
		x.vtnk[5] = BuildObject("nvwalk", 5, "epatk5")
		x.vtnk[6] = BuildObject("nvwalk", 5, "epatk6")
		x.vtnk[7] = BuildObject("nvark0", 5, "epatk7")
		for index = 1, 7 do
			LookAt(x.vtnk[index], x.evlt, 0)
		end
		x.randompick = 0
		x.randomlast = x.randompick
		for index = 1, 8 do
			while x.randompick == x.randomlast do --random the random
				x.randompick = math.floor(GetRandomFloat(1.0, 15.0))
			end
			x.randomlast = x.randompick
			if x.randompick == 1 or x.randompick == 7 or x.randompick == 13 then
				x.etnk[index] = BuildObject("nvscout", 5, ("eptnk%d"):format(index)) --"eptnk", index) --path point was being inconsistent
			elseif x.randompick == 2 or x.randompick == 8 then
				x.etnk[index] = BuildObject("nvmbike", 5, ("eptnk%d"):format(index)) --"eptnk", index)
			elseif x.randompick == 3 or x.randompick == 9 or x.randompick == 14 then
				x.etnk[index] = BuildObject("nvmisl", 5, ("eptnk%d"):format(index)) --"eptnk", index)
			elseif x.randompick == 4 or x.randompick == 10 or x.randompick == 15 then
				x.etnk[index] = BuildObject("nvtank", 5, ("eptnk%d"):format(index)) --"eptnk", index)
			elseif x.randompick == 5 or x.randompick == 11 then
				x.etnk[index] = BuildObject("nvrckt", 5, ("eptnk%d"):format(index)) --"eptnk", index)
			else --6 12
				x.etnk[index] = BuildObject("nvwalk", 5, ("eptnk%d"):format(index)) --"eptnk", index)
			end
			LookAt(x.etnk[index], x.fnav[1], 0)
			SetSkill(x.etnk[index], x.skillsetting)
		end
		for index = 1, 8 do
			x.pos = GetTransform(x.ntur[index])
			RemoveObject(x.ntur[index])
			x.ntur[index] = BuildObject("nvturr", 5, x.pos)
		end
		for index = 1, 3 do --replace visible abdummy w/ inv dumm00 for cam segs
			x.pos = GetTransform(x.cam[index])
			RemoveObject(x.cam[index])
			x.cam[index] = BuildObject("dummy00", 0, x.pos)
		end
		x.spine = x.spine + 1
	end

	--FIRST OBJECTIVE
	if x.spine == 1 and IsAudioMessageDone(x.audio1) then
		AddObjective("tcbd0901.txt") --Locate the AIP base and capture the Cthonian armory.
		x.fnav[1] = BuildObject("apcamrb", 1, "fpnav1")
		SetObjectiveName(x.fnav[1], "Capture the Armory")
		SetObjectiveOn(x.fnav[1])
    if x.skillsetting == x.easy then
      StartCockpitTimer(600, 300, 180)
      x.failtime = GetTime() + 600.0
    elseif x.skillsetting == x.medium then
      StartCockpitTimer(660, 300, 180)
      x.failtime = GetTime() + 660.0
    else
      StartCockpitTimer(720, 300, 180)
      x.failtime = GetTime() + 720.0
    end
		x.failstate = 1
		for index = 1, 4 do
			StopEmitter(x.edrp, index)
		end
		x.spine = x.spine + 1
	end
	
	--START ARKIN CAM
	if x.spine == 2 and IsAlive(x.player) and GetDistance(x.player, "epatk7") < 500 then
		for index = 1, 8 do
			Defend(x.etnk[index], 0)
		end
		for index = 1, x.squadcount+6 do 
			if IsAlive(x.fgrp[index]) then
				x.keepalive[index] = GetCurHealth(x.fgrp[index])
			end
		end
		x.camstate = 1
    x.userfov = IFace_GetInteger("options.graphics.defaultfov")
    CameraReady()
    IFace_SetInteger("options.graphics.defaultfov", x.camfov)
		x.waittime = GetTime() + 2.0
		x.spine = x.spine + 1
	end
	
	--OPEN VAULT DOORS
	if x.spine == 3 and x.waittime < GetTime() then
		AudioMessage("tcbd0902.wav") --ADDED --not good, ark open arm and go inside
		SetAnimation(x.evlt, "open", 1)
		x.waittime = GetTime() + 6.0
		x.spine = x.spine + 1
	end
	
	--SEND ARKIN FORCE INSIDE
	if x.spine == 4 and x.waittime < GetTime() then
		for index = 1, 7 do
			Goto(x.vtnk[index], ("epatk%d"):format(index))
		end
		x.spine = x.spine + 1
	end
	
	--CLOSE DOOR BEHIND ARKIN
	if x.spine == 5 and IsAlive(x.vtnk[7]) and GetDistance(x.vtnk[7], "epatk7", 1) < 15 then
		SetAnimation(x.evlt, "close", 1)
		x.waittime = GetTime() + 2.0
		x.spine = x.spine + 1
	end
	
	--STOP ARKIN CAM
	if x.spine == 6 and x.waittime < GetTime() then
    CameraFinish()
    IFace_SetInteger("options.graphics.defaultfov", x.userfov)
		x.camstate = 0
		for index = 1, 7 do
			RemoveObject(x.vtnk[index])
		end
		x.spine = x.spine + 1
	end
	
	--PLAYER AT VAULT, START ETNK ATTACK
	if x.spine == 7 and GetDistance(x.player, x.evlt) < 300 then
		SetObjectiveOff(x.fnav[1])
		x.etnkstate = 1
		x.etnktime = GetTime()
		x.spine = x.spine + 1
	end
	
	--ETNK GROUP AT ENTRANCE
	if x.spine == 8 then
		if x.etnkstate == 1 and x.etnktime < GetTime() then
			for index = 1, 8 do
				if IsAlive(x.etnk[index]) then
					SetSkill(x.etnk[index], x.skillsetting)
					if IsAlive(x.fgrp[index]) then
						Attack(x.etnk[index], x.fgrp[index])
					elseif IsAlive(x.fgrp[index+10]) then
						Attack(x.etnk[index], x.fgrp[index+10])
					else
						Attack(x.etnk[index], x.player)
					end
				end
			end
			x.etnktime = GetTime() + 15.0
			x.etnkstate = x.etnkstate + 1
		elseif x.etnkstate == 2 then
			for index = 1, 8 do
				if not IsAlive(x.etnk[index]) then
					x.casualty = x.casualty + 1
				end
			end
			if x.casualty < 8 then
				x.etnkstate = 1
			elseif x.casualty >= 8 and not IsAlive(x.egun[1]) then
				x.etnkstate = 3
				x.failstate = 0
				x.failtime = 99999.9
				StopCockpitTimer()
				HideCockpitTimer()
				x.spine = x.spine + 1
			end
			x.casualty = 0
		end
	end
	
	--WAIT TO REOPEN VAULT
	if x.spine == 9 and x.etnkstate == 3 then
		AudioMessage("tcbd0903.wav") --ADDED --standby to reopen door
		x.forcelost = true
		x.waittime = GetTime() + 10.0
		x.spine = x.spine + 1
	end
	
	--OPEN VAULT
	if x.spine == 10 and x.waittime < GetTime() then
		AudioMessage("tcbd0904.wav") --ADDED --door open, go pursue ark
		ClearObjectives()
		AddObjective("tcbd0901.txt", "GREEN") --Locate the AIP base and capture the Cthonian armory.
		AddObjective("	")
		AddObjective("tcbd0902.txt") --Arkin has entered the armory. Pursue him inside.
		AddObjective("\nKeep your forces close to you.", "CYAN")
		SetAnimation(x.evlt, "open", 1)
		x.spine = x.spine + 1
	end
	
	--VAULTAREA1 ENTER
	if x.spine == 11 and IsInsideArea("vaultarea1", x.player) then
		x.audio1 = AudioMessage("tcbd0905.wav") --ADDED	 -cyclops attacking
		x.waittime = GetTime() + 10.0 --2/3 through message
		for index = 1, 20 do --remove excess
			if IsAlive(x.eatk[index]) and GetTeamNum(x.eatk[index]) ~= 1 then
				RemoveObject(x.eatk[index])
			end
		end
		for index = 1, x.epatlength do --remove excess
			if IsAlive(x.epat[index]) and GetTeamNum(x.epat[index]) ~= 1 then
				RemoveObject(x.epat[index])
			end
		end
		for index = 1, 8 do --remove excess
			if IsAlive(x.etnk[index]) and GetTeamNum(x.etnk[index]) ~= 1 then
				RemoveObject(x.etnk[index])
			end
		end
		x.spine = x.spine + 1
	end
	
	--VAULTAREA1 ATTACK
	if x.spine == 12 and x.waittime < GetTime() then --IsAudioMessageDone(x.audio1) then
		for index = 1, 4 do
			AddPilotByHandle(x.egrd[index])
			SetTeamNum(x.egrd[index], 5)
			SetSkill(x.egrd[index], x.skillsetting)
		end
		SetAnimation(x.evlt, "close", 1)
		ClearObjectives()
		AddObjective("tcbd0902.txt", "GREEN")
		AddObjective("	")
		AddObjective("tcbd0903.txt") --Alert, Arkin has activated several automated Cyclops units.
		for index = 1, 5 do
			RemoveObject(x.egun[index])
		end
		for index = 1, 8 do
			RemoveObject(x.ntur[index])
		end
		x.spine = x.spine + 1
	end
	
	--VAULTAREA1 CLEAR
	if x.spine == 13 then
		for index = 1, 4 do
			if IsAlive(x.player) and IsAlive(x.egrd[index]) and GetDistance(x.egrd[index], x.player) > 150 then
				Damage(x.egrd[index], (GetMaxHealth(x.egrd[index])+100))
			end --sometimes they pop to surface
			if not IsAlive(x.egrd[index]) then
				x.casualty = x.casualty + 1
			end
		end
		if x.casualty >= 3 then
			x.waittime = GetTime() + 13.0
			x.spine = x.spine + 1
		end
		x.casualty = 0
	end
	
	--VAULTAREA1 REOPEN
	if x.spine == 14 and x.waittime < GetTime() then
		AudioMessage("tcbd0906.wav") --ADDED --door open, move one
		ClearObjectives()
		AddObjective("tcbd0903.txt", "GREEN")
		AddObjective("\n\nHead south to the next vault.")
		SetAnimation(x.door[10], "open", 1)
		x.spine = x.spine + 1
	end
	
	--VAULTAREA2 ENTER
	if x.spine == 15 and IsInsideArea("vaultarea2", x.player) then
		x.audio1 = AudioMessage("tcbd0907.wav") --ADDED --pegasus attacking
		x.waittime = GetTime() + 6.0
		x.spine = x.spine + 1
	end
	
	--VAULTAREA2 ATTACK
	if x.spine == 16 and x.waittime < GetTime() then --IsAudioMessageDone(x.audio1) then
		for index = 5, 8 do
			AddPilotByHandle(x.egrd[index])
			SetTeamNum(x.egrd[index], 5)
			SetSkill(x.egrd[index], x.skillsetting)
		end
		SetAnimation(x.door[10], "close", 1)
		ClearObjectives()
		AddObjective("tcbd0903.txt", "GREEN") --Alert, Arkin has activated several automated Cyclops units.
		AddObjective("	")
		AddObjective("tcbd0904.txt") --Alert, Arkin has activated several automated Pegasus units.
		x.spine = x.spine + 1
	end
	
	--VAULTAREA2 CLEAR
	if x.spine == 17 then
		for index = 5, 8 do
			if IsAlive(x.player) and IsAlive(x.egrd[index]) and GetDistance(x.egrd[index], x.player) > 150 then
				Damage(x.egrd[index], (GetMaxHealth(x.egrd[index])+100))
			end --sometimes they pop to surface
			if not IsAlive(x.egrd[index]) then
				x.casualty = x.casualty + 1
			end
		end
		if x.casualty >= 3 then
			for index = 1, 4 do
				x.pos = GetTransform(x.ntnk[index])
				RemoveObject(x.ntnk[index])
				x.ntnk[index] = BuildObject("nvscout", 5, x.pos) --1 2 3 4
        SetCanSnipe(x.ntnk[index], 0)
				LookAt(x.ntnk[index], x.sarc, 0)
				x.pos = GetTransform(x.ntnk[index+2])
				RemoveObject(x.ntnk[index+4])
				x.ntnk[index+4] = BuildObject("nvtank", 5, x.pos) --5 6 7 8
        SetCanSnipe(x.ntnk[index+4], 0)
				LookAt(x.ntnk[index+4], x.sarc, 0)
				x.pos = GetTransform(x.ntnk[index+8])
				RemoveObject(x.ntnk[index+8]) 
				x.ntnk[index+8] = BuildObject("nvwalk", 5, x.pos) --9 10 11 12
				LookAt(x.ntnk[index+8], x.sarc, 0)
			end
			x.pos = GetTransform(x.nark)
			RemoveObject(x.nark)
			x.nark = BuildObject("nvark0", 5, x.pos)
      SetCanSnipe(x.nark, 0)
			LookAt(x.nark, x.sarc, 0)
			x.arkinlives = true
			x.waittime = GetTime() + 13.0
			x.spine = x.spine + 1
		end
		x.casualty = 0
	end

	--VAULTAREA2 OPEN
	if x.spine == 18 and x.waittime < GetTime() then
		AudioMessage("tcbd0908.wav") --ADDED --door open, go west to strange reading
		ClearObjectives()
		AddObjective("tcbd0904.txt", "GREEN") --Alert, Arkin has activated several automated Pegasus units.
		AddObjective("\n\nProceed west to the next vault.")
		SetAnimation(x.door[1], "open", 1)
		x.spine = x.spine + 1
	end
	
	--START CAMERA 2 ON SARCOPHAGUS
	if x.spine == 19 and IsAlive(x.player) and IsInsideArea("tombarea", x.player) then
		for index = 1, 12 do
			Defend(x.ntnk[index], 0)
			SetSkill(x.ntnk[index], x.skillsetting)
		end
		for index = 1, (x.squadcount+6) do
			if IsAlive(x.fgrp[index]) then
				Defend(x.fgrp[index], 0)
			end
		end 
		SetAnimation(x.door[1], "close", 1)
		x.camstate = 2
    x.userfov = IFace_GetInteger("options.graphics.defaultfov")
    CameraReady()
    IFace_SetInteger("options.graphics.defaultfov", x.camfov)
		x.waittime = GetTime() + 2.0
		x.spine = x.spine + 1
	end
	
	--SEND ARKIN TO DIAS
	if x.spine == 20 and x.waittime < GetTime() then
		x.audio1 = AudioMessage("tcbd0909.wav") --ADDED --chamber different, there's ark
		for index = 1, 46 do
			if IsAlive(x.fgrp[index]) then
				LookAt(x.fgrp[index], player, 0)
			end
		end
		Goto(x.nark, "parkin", 0)
		x.spine = x.spine + 1
	end
	
	--INFO ON SARCOPHAGUS, START ARKIN WALK AROUND
	if x.spine == 21 and IsAudioMessageDone(x.audio1) then
		x.audio1 = AudioMessage("tcbd0910b.wav") --ADDED --ark exam sarc
		x.arkstate = 1
		x.ptcount = 1
		x.waittime = GetTime()
		x.spine = x.spine + 1
	end
	
	--ARKIN EXAMINES SARCOPHAGUS
	if x.spine == 22 then
		if x.arkstate == 1 and x.waittime < GetTime() and x.ptcount < 5 then
			Goto(x.nark, ("parkdias%d"):format(x.ptcount), 1, 0)
			x.arkstate = 2
		elseif x.arkstate == 2 and GetDistance(x.nark, ("parkdias%d"):format(x.ptcount)) < 3 then
			x.arkstate = 3
		elseif x.arkstate == 3 then --and x.waittime < GetTime() then
			Goto(x.nark, ("plook%d"):format(x.ptcount), 1, 0)
			--well this just doesn't work, he won't look LookAt(x.nark, x.sarc)
			x.ptcount = x.ptcount + 1
			x.waittime = GetTime() + 5.0
			x.arkstate = 1
		end
		if (x.ptcount > 4 and x.waittime < GetTime()) then --IsAudioMessageDone(x.audio1) or 
			x.spine = x.spine + 1
		end
	end
	
	--ARKIN PICKUP SARCOPHAGUS
	if x.spine == 23 then
		Pickup(x.nark, x.sarc)
		x.spine = x.spine + 1
	end
	
	--ARKIN TO HANGAR
	if x.spine == 24 and HasCargo(x.nark) then
		AudioMessage("tcbd0911.wav") --ADDED --ark got sarc, after him
		Goto(x.nark, "parkout")
		SetAnimation(x.door[2], "open", 1)
		x.waittime = GetTime() + 2.0
		x.spine = x.spine + 1
	end
	
	--CAMERA 2 END ... FINALLY
	if x.spine == 25 and x.waittime < GetTime() then
    CameraFinish()
    IFace_SetInteger("options.graphics.defaultfov", x.userfov)
		x.camstate = 0
		ClearObjectives()
		AddObjective("tcbd0905.txt") --Stop Arkin from escaping with Paternus' sarcophagus.
		for index = 1, (x.squadcount+ 6) do
			if IsAlive(x.fgrp[index]) then
				Follow(x.fgrp[index], x.player, 0)
			end
		end
		x.spine = x.spine + 1
	end
	
	--ARKIN SAFE, CLOSE HANGAR ACCESS
	if x.spine == 26 and IsInsideArea("hangararea", x.nark) then
		AudioMessage("tcbd0912.wav") --ADDED --door sealed, kill aip while alt found
		SetAnimation(x.door[2], "close", 1)
		x.waittime = GetTime() + 20.0
		x.spine = x.spine + 1
	end
	
	--OPEN ALT DOOR TO HANGAR
	if x.spine == 27 and x.waittime < GetTime() then
		SetAnimation(x.door[3], "open", 1)
		SetAnimation(x.door[1], "open", 1) --open extra door for units to door 3
		SetAnimation(x.door[8], "open", 1) --open extra door for units to door 3
		AudioMessage("tcbd0913.wav") --ADDED --alt door open
		x.spine = x.spine + 1
	end

	--CAMERA 3 HANGAR START
	if x.spine == 28 and IsInsideArea("hangararea", x.player) then
		x.camstate = 3
    x.userfov = IFace_GetInteger("options.graphics.defaultfov")
    CameraReady()
    IFace_SetInteger("options.graphics.defaultfov", x.camfov)
		for index = 1, 20 do
			Defend(x.fgrp[index], 0)
		end
		x.waittime = GetTime() + 2.0
		x.spine = x.spine + 1
	end
	
	--OPEN HANGAR, ARKIN TO DROPSHIP
	if x.spine == 29 and x.waittime < GetTime() then
		SetAnimation(x.door[1], "close", 1)
		SetAnimation(x.hangar, "open", 1)
		SetAnimation(x.edrp, "open", 1)
		Goto(x.nark, "parkdrp")
		x.spine = x.spine + 1
	end
	
	--LAUNCH DROPSHIP
	if x.spine == 30 and GetDistance(x.nark, x.edrp) < 20 then
		SetAnimation(x.edrp, "launch", 1)
		x.waittime = GetTime() + 5.0
		x.spine = x.spine + 1
	end
	
	--DROPSHIP CONTINUE
	if x.spine == 31 and x.waittime < GetTime() then
		StartSoundEffect("dropleav.wav", x.edrp)
		for index = 1, 4 do
			StartEmitter(x.edrp, index)
		end
		SetAnimation(x.door[3], "close", 1)
		x.arkinlives = false
		x.waittime = GetTime() + 5.0
		x.spine = x.spine + 1
	end
	
	--CAMERA 3 END, OPEN ESCAPE ROUTE, START EARTHQUAKE
	if x.spine == 32 and x.waittime < GetTime() then
		x.camstate = 0
		CameraFinish()
		SetAnimation(x.hangar, "close", 1)
		AudioMessage("tcbd0914.wav") --ADDED --Ark escaped
		for index = 1, (x.squadcount+ 6) do
			if IsAlive(x.fgrp[index]) then
				Follow(x.fgrp[index], x.player, 0)
			end
		end
		ClearObjectives()
		AddObjective("tcbd0905.txt", "ORANGE") --Stop Arkin from escaping with Paternus' sarcophagus.
		SetAnimation(x.door[4], "open", 1)
		SetAnimation(x.evlt, "open", 1)
		StartEarthQuake(10.0)
		RemoveObject(x.sarc)
		RemoveObject(x.nark)
		x.waittime = GetTime() + 5.0
		x.spine = x.spine + 1
	end
	
	--ACTIVATE ESCAPE BEACON, START FAIL CLOCK
	if x.spine == 33 and x.waittime < GetTime() then
		AudioMessage("tcbd0915.wav") --ADDED --self destruct, get out!
		RemoveObject(x.sarc)
		RemoveObject(x.edrp)
		UpdateEarthQuake(20.0)
		x.fnav[2] = BuildObject("apcamrb", 1, "fpnav2")
		SetObjectiveName(x.fnav[2], "Escape")
		SetObjectiveOn(x.fnav[2])
		if IsOdf(x.player, "bvhtnk") then
			StartCockpitTimer(120, 60, 20)
			x.failtime = GetTime() + 121.0
		else
			StartCockpitTimer(90, 60, 20)
			x.failtime = GetTime() + 91.0
		end
		x.failstate = 2
		x.waittime = GetTime() + 15.0
		ClearObjectives()
		AddObjective("tcbd0906.txt") --Get out of the armory tomb before it collapses.
		x.spine = x.spine + 1
	end

	--EARTHQUAKE INCREASE 2
	if x.spine == 34 and x.waittime < GetTime() then
		UpdateEarthQuake(40.0)
		x.waittime = GetTime() + 15.0
		x.spine = x.spine + 1
	end
	
	--EARTHQUAKE INCREASE 3
	if x.spine == 35 and x.waittime < GetTime() then
		UpdateEarthQuake(60.0)
		x.spine = x.spine + 1
	end
	
	--MISSION SUCCESS
	if x.spine == 36 and IsAlive(x.player) and GetDistance(x.player, "fpnav2") < 100 then
		x.failtime = 99999.9
		x.failstate = 0
		StopEarthQuake()
		SetObjectiveOff(x.fnav[2])
		StopCockpitTimer()
		HideCockpitTimer()
	--SetAnimation(x.evlt, "close", 1)
		x.audio1 = AudioMessage("tcbd0916.wav") --ADDED --done all u can. prep for doff
		ClearObjectives()
		AddObjective("tcbd0906.txt", "GREEN")
		AddObjective("\n\nMISSION COMPLETE.", "GREEN")
		x.spine = x.spine + 1
	end
	
	--NO REALLY, I MEAN IT THIS TIME, YOU WIN
	if x.spine == 37 and IsAudioMessageDone(x.audio1) then
		SucceedMission(GetTime() + 1.0, "tcbd09w.des") --WINNER WINNER WINNER
		x.MCAcheck = true
		x.spine = x.spine + 1
	end
	----------END MAIN SPINE ----------
	
	--CAMERA 1 ON ARKIN ENTRANCE
	if x.camstate == 1 then
		CameraObject(x.cam[1], 0, 30, -10, x.edrp)
		for index = 1, x.squadcount+6 do 
			if IsAlive(x.fgrp[index]) then
				SetCurHealth(x.fgrp[index], x.keepalive[index])
			end
		end
	end
	
	--CAMERA 2 ON SARCOPHAGUS
	if x.camstate == 2 then
		CameraObject(x.cam[2], 0, 20, 20, x.sarc)
	end
	
	--CAMERA 3 ON SARCOPHAGUS IN DROPSHIP
	if x.camstate == 3 then
		CameraObject(x.cam[3], 0, 5, 20, x.sarc)
	end
	
	--CHECK STATUS OF MCA ----------------------------------
	if not x.MCAcheck then	 
		if x.arkinlives and (not IsAlive(x.sarc) or not IsAlive(x.nark)) then	 --MCA destroyed
			AudioMessage("alertpulse.wav")
			ClearObjectives()
			AddObjective("You were not authorized to destroy that.\n\nMISSION FAILED!", "RED")
			FailMission(GetTime() + 4.0, "tcbd09f1.des") --LOSER LOSER LOSER
			x.spine = 666
			x.MCAcheck = true
		end
		
		if x.failstate == 1 and x.failtime < GetTime() then	 --didn't get to arkin in time
			AudioMessage("alertpulse.wav")
			ClearObjectives()
			AddObjective("AIP has secured the Armory.\n\nMISSION FAILED!", "RED")
			FailMission(GetTime() + 4.0, "tcbd09f2.des") --LOSER LOSER LOSER
			x.spine = 666
			x.MCAcheck = true
		end
		
		if x.failstate == 2 and x.failtime < GetTime() then	 --didn't escape tomb
			StopCockpitTimer()
			HideCockpitTimer()
			SetColorFade(20.0, 0.1, "WHITE")
			AudioMessage("xemt2.wav")
			FailMission(GetTime() + 2.0, "tcbd09f3.des") --LOSER LOSER LOSER
			x.spine = 666
			x.MCAcheck = true
		end
		
		if not x.forcelost then --lost too many units
			for index = 1, x.squadcount do
				if not IsAlive(x.fgrp[index]) then
					x.casualty = x.casualty + 1
				end
			end
			
			if x.casualty > (math.floor(x.squadcount*0.7))then
				x.forcelost = true
				AudioMessage("alertpulse.wav")
				ClearObjectives()
				AddObjective("Too many wingman lost to continue.\n\nMISSION FAILED!", "RED")
				FailMission(GetTime() + 4.0, "tcbd09f4.des") --LOSER LOSER LOSER
				x.spine = 666
				x.MCAcheck = true
			end
			x.casualty = 0
		end
	end
end
--[[END OF SCRIPT]]