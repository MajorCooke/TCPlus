--bztcrb02 - Battlezone Total Command - The Red Brigade - 2/8 - PRECIOUS CARGO
--WHILE THE GOALS AND AUDIOS ARE THE SAME, THIS VERSION IS A REIMAGINING OF HOW TO PLAY THE ORIGINAL MISSION
--(b/c orig, is too easy to beat b/c script triggers can be avoided)
--DECLARE variables --f-friend, e-enemy, atk-attack, rcy-recycler, etc..., 
assert(load(assert(LoadFile("_requirefix.lua")),"_requirefix.lua"))();
TCC = require("TC_Core")
MisnNum = 17;
local index = 0
local index2 = 0
local index3 = 0
local x = {
	FIRST = true,
	spine = 0,
	getiton = false, 
	MCAcheck = false,
	waittime = 99999.9,
	player = nil, 
	mytank = nil, 
	skillsetting = 0,
	easy = 0, 
	medium = 1, 
	hard = 2, 
	pos = {}, 
	pilot = nil, 
	audio1 = nil, 
	camfov = 60,  --185 default
	userfov = 90,  --seed
	randompick = 0, 
	randomlast = 0, 
	fnav = {},
	fgrp = {}, --CCA mission specific
	fpad = nil, 
	gotcone = false, 
	fcne = nil, 
	fapc = {},
	fapcdead = {false, false, false},
	fapcsafe = {false, false, false},
	fapcarrive = false, 
	eatkencounter = {}, --BDS attacks encounters
	eatkspecial = {0, 0, 0}, --artl, recy, mine spec attacks
	ercyatktooclose = false, 
	eatkstate = {}, --mine section
	eatkcool = {}, --mine section
	eatkfaster = {}, --mine section
	eatk = {},
	ecam = {}, 
	etur = {}, 
	enav = {}, 
	enavfound = {}, 
	enavtime = {99999.9, 99999.9, 99999.9, 99999.9}, --keep
	enavatk = {}, 
	ercy = nil, 
	proxmine = {}, 
	whinetime = 99999.9, 
	whinefail = 0, 
	LAST = true
}

function InitialSetup()
	SetAutoGroupUnits(true)
	
	local odfpreload = {
		"svscout", "svmbike", "svmisl", "svtank", "svrckt", "svapcrb02", "sblpad2", "sbcone1", 
		"bvturr", "bvscout", "bvmbike", "bvmisl", "bvtank", "bvrckt", "bvartl", "bbrecy", 
		"oproxarb02", "gstbsa_c", "gshdwa_c", "apcamrb", "apservb", "apcamrs"
	}
	for k,v in pairs(odfpreload) do
		PreloadODF(v)
	end
	
	x.ercy = GetHandle("ercy")
	x.fpad = GetHandle("fpad")
	x.mytank = GetHandle("mytank")
	for index = 1, 10 do --the player force
		x.fgrp[index] = GetHandle(("fgrp%d"):format(index))
	end
	x.fapc[1] = GetHandle("fapc1")
	x.fapc[2] = GetHandle("fapc2")
	x.fapc[3] = GetHandle("fapc3")
	for index = 1, 11 do 
		x.ecam[index] = GetHandle(("eatk%d"):format(index)) --bds machinima squad
		x.eatkencounter[index] = 0 --number of encounters happens to be same number
	end
	SetColorFade(6.0, 0.5, "BLACK")
	TCC.Init();
end

function Start()
	TCC.Start();
end
function Save()
	return
	index, index2, index3, x, TCC.Save()
end

function Load(a, b, c, d, coreData)
	index = a;
	index2 = b;
	index3 = c;
	x = d;
	TCC.Load(coreData)
end
function AddObject(h)
	if not x.gotcone and IsOdf(h, "sbcone1") then
		x.fcne = h
		x.gotcone = true
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
	--Set up mission basics
	if x.spine == 0 then
		x.pos = GetTransform(x.mytank)
		RemoveObject(x.mytank)
		x.mytank = BuildObject("svtank", 1, x.pos)
		GiveWeapon(x.mytank, "gstbsa_c")
		SetAsUser(x.mytank, 1)
		RemoveObject(x.player)
		x.player = GetPlayerHandle()
		x.pos = GetTransform(x.fgrp[1])
		RemoveObject(x.fgrp[1])
		x.fgrp[1] = BuildObject("svscout", 1, x.pos)
		x.pos = GetTransform(x.fgrp[2])
		RemoveObject(x.fgrp[2])
		x.fgrp[2] = BuildObject("svmbike", 1, x.pos)
		x.pos = GetTransform(x.fgrp[3])
		RemoveObject(x.fgrp[3])
		x.fgrp[3] = BuildObject("svmisl", 1, x.pos)
		x.pos = GetTransform(x.fgrp[4])
		RemoveObject(x.fgrp[4])
		x.fgrp[4] = BuildObject("svtank", 1, x.pos)
		x.pos = GetTransform(x.fgrp[5])
		RemoveObject(x.fgrp[5])
		x.fgrp[5] = BuildObject("svrckt", 1, x.pos)
		x.pos = GetTransform(x.fgrp[6])
		RemoveObject(x.fgrp[6])
		x.fgrp[6] = BuildObject("svscout", 1, x.pos)
		x.pos = GetTransform(x.fgrp[7])
		RemoveObject(x.fgrp[7])
		if x.skillsetting >= x.medium then  --difficulty-based from here
			x.fgrp[7] = BuildObject("svmbike", 1, x.pos)
		end
		x.pos = GetTransform(x.fgrp[8])
		RemoveObject(x.fgrp[8])
		if x.skillsetting >= x.hard then
			x.fgrp[8] = BuildObject("svmisl", 1, x.pos)
		end
		x.pos = GetTransform(x.fgrp[9])
		RemoveObject(x.fgrp[9])
		if x.skillsetting >= x.medium then
			x.fgrp[9] = BuildObject("svtank", 1, x.pos)
		end
		x.pos = GetTransform(x.fgrp[10])
		RemoveObject(x.fgrp[10])
		if x.skillsetting >= x.hard then
			x.fgrp[10] = BuildObject("svrckt", 1, x.pos)
		end
		for index = 1, 10 do 
			SetSkill(x.fgrp[index], x.skillsetting)
		end
		for index = 1, 5 do
			SetGroup(x.fgrp[index], 0)
			SetGroup(x.fgrp[index+5], 1)
		end
		for index = 1, 3 do
			x.pos = GetTransform(x.fapc[index])
			RemoveObject(x.fapc[index])
			x.fapc[index] = BuildObject("svapcrb02", 1, x.pos)
			SetSkill(x.fapc[index], x.skillsetting)
			SetObjectiveName(x.fapc[index], ("Transport %d"):format(index))
			SetGroup(x.fapc[index], 2)
		end
		x.pos = GetTransform(x.fpad)
		RemoveObject(x.fpad)
		x.fpad = BuildObject("sblpad2", 1, x.pos)
		x.audio1 = AudioMessage("tcrb0200.wav") --INTRO - 3 trans with Chestikov, esc to lpad
    x.userfov = IFace_GetInteger("options.graphics.defaultfov")
    CameraReady()
    IFace_SetInteger("options.graphics.defaultfov", x.camfov)
		x.spine = x.spine + 1
	end

	--RUN CAM ON PLAYER, THEN SEND FIRST ATTACK
	if x.spine == 1 and (CameraPath("pcam0", 600, 1200, x.player) or IsAudioMessageDone(x.audio1) or CameraCancelled()) then
		--don't like the above method, b/c it causes the end of camera to hang, but it's shorter code
    CameraFinish()
    IFace_SetInteger("options.graphics.defaultfov", x.userfov)
		SetColorFade(6.0, 0.5, "BLACK")
		AudioMessage("tcrb0202.wav") --Two American units coming from the north
		ClearObjectives()
		AddObjective("tcrb0201.txt")
		AddObjective("tcrb0202.txt")
		AddObjective("tcrb0203.txt")
		x.eatk[1] = BuildObject("bvmbike", 5, "ep1")
		SetEjectRatio(x.eatk[1], 0.0)
		SetSkill(x.eatk[1], x.skillsetting)
		Attack(x.eatk[1], x.fapc[1])
		x.eatk[2] = BuildObject("bvmisl", 5, "ep1")
		SetEjectRatio(x.eatk[2], 0.0)
		SetSkill(x.eatk[2], x.skillsetting)
		Attack(x.eatk[2], x.fapc[2])
		for index = 1, 40 do --prox mines
			x.proxmine[index] = BuildObject("oproxarb02", 5, "pmine", index) --8hr lifespan, more damage
		end
		for index = 1, 16 do --shortcut turrets
			x.etur[index] = BuildObject("bvturr", 5, ("etur%d"):format(index))
			SetEjectRatio(x.etur[index], 0.0)
			SetSkill(x.etur[index], x.skillsetting)
		end
		for index = 1, 4 do --enemy supply cameras seeding
			x.enav[index] = BuildObject("apcamrb", 5, ("enav%d"):format(index))
			x.enavfound[index] = 0
		end
		--build bds camera squad
		x.pos = GetTransform(x.ecam[1])
		RemoveObject(x.ecam[1])
		x.ecam[1] = BuildObject("bvscout", 5, x.pos)
		x.pos = GetTransform(x.ecam[2])
		RemoveObject(x.ecam[2])
		x.ecam[2] = BuildObject("bvmbike", 5, x.pos)
		x.pos = GetTransform(x.ecam[3])
		RemoveObject(x.ecam[3])
		x.ecam[3] = BuildObject("bvmisl", 5, x.pos)
		x.pos = GetTransform(x.ecam[4])
		RemoveObject(x.ecam[4])
		x.ecam[4] = BuildObject("bvtank", 5, x.pos)
		x.pos = GetTransform(x.ecam[5])
		RemoveObject(x.ecam[5])
		x.ecam[5] = BuildObject("bvrckt", 5, x.pos)
		x.pos = GetTransform(x.ecam[6])
		RemoveObject(x.ecam[6])
		x.ecam[6] = BuildObject("bvscout", 5, x.pos)
		x.pos = GetTransform(x.ecam[7])
		RemoveObject(x.ecam[7])
		x.ecam[7] = BuildObject("bvmbike", 5, x.pos)
		x.pos = GetTransform(x.ecam[8])
		RemoveObject(x.ecam[8])
		x.ecam[8] = BuildObject("bvmisl", 5, x.pos)
		x.pos = GetTransform(x.ecam[9])
		RemoveObject(x.ecam[9])
		x.ecam[9] = BuildObject("bvtank", 5, x.pos)
		x.pos = GetTransform(x.ecam[10])
		RemoveObject(x.ecam[10])
		x.ecam[10] = BuildObject("bvrckt", 5, x.pos) 
		x.pos = GetTransform(x.ecam[11]) --CAMERA FOLLOWS THIS ONE
		RemoveObject(x.ecam[11])
		x.ecam[11] = BuildObject("bvtank", 5, x.pos)
		x.spine = x.spine + 1
	end

	--POST FIRST ATTACK MESSAGE
	if x.spine == 2 and not IsAlive(x.eatk[1]) and not IsAlive(x.eatk[2]) then --and not IsAlive(x.eatk[3]) then
		x.waittime = GetTime() + 4.0
		x.spine = x.spine + 1
	end 
	
	--WAIT FOR UNIT MESSAGES TO END THEN PLAY CUTSCENE MESSAGES
	if x.spine == 3 and x.waittime < GetTime() then
		AudioMessage("tcrb0203.wav") --Americans destroyed. BUT full platoon on the hill.
		AudioMessage("tcrb0204.wav") --Too many. We must surrender.
		x.audio1 = AudioMessage("tcrb0205.wav") --No terms. You will be destroyed. Cowboy1 (BDogs)
    x.userfov = IFace_GetInteger("options.graphics.defaultfov")
    CameraReady()
    IFace_SetInteger("options.graphics.defaultfov", x.camfov)
		x.spine = x.spine + 1
	end
	
	--RUN CAMERA ON BDS SQUAD AND END CAMERA
	if x.spine == 4 and (CameraPath("pcam1", 600, 450, x.ecam[11]) or IsAudioMessageDone(x.audio1) or CameraCancelled()) then
    CameraFinish()
    IFace_SetInteger("options.graphics.defaultfov", x.userfov)
		SetColorFade(6.0, 0.5, "BLACK")
		AudioMessage("tcrb0206.wav") --We must get to Lpad. Run for our lives.
		for index = 1, 11 do 
			RemoveObject(x.ecam[index])
		end
		x.eatk[1] = BuildObject("bvmbike", 5, "ep1")
		SetEjectRatio(x.eatk[1], 0.0)
		SetSkill(x.eatk[1], x.skillsetting)
		Attack(x.eatk[1], x.fapc[3])
		x.eatk[2] = BuildObject("bvmisl", 5, "ep1")
		SetEjectRatio(x.eatk[2], 0.0)
		SetSkill(x.eatk[2], x.skillsetting)
		Attack(x.eatk[2], x.fapc[2])  	
		x.fnav[1] = BuildObject("apcamrs", 1, "path1")
		SetObjectiveName(x.fnav[1], "One")
		x.fnav[2] = BuildObject("apcamrs", 1, "path3")
		SetObjectiveName(x.fnav[2], "Two")
		x.fnav[3] = BuildObject("apcamrs", 1, "path5")
		SetObjectiveName(x.fnav[3], "Three")
		x.fnav[4] = BuildObject("apcamrs", 1, "path6")
		SetObjectiveName(x.fnav[4], "Four")
		x.fnav[5] = BuildObject("apcamrs", 1, "path9")
		SetObjectiveName(x.fnav[5], "Five")
		x.fnav[6] = BuildObject("apcamrs", 1, "path11")
		SetObjectiveName(x.fnav[6], "Six")
		x.fnav[7] = BuildObject("apcamrs", 1, "pnavpad")
		SetObjectiveName(x.fnav[7], "Launchpad")
		x.whinetime = GetTime() --start the whining
		x.spine = x.spine + 1
	end

	--IF TRANSPORTS SAFE TO LPAD - WINNER WINNER WINNER
	if x.spine == 5 and x.fapcsafe[1] and x.fapcsafe[2] and x.fapcsafe[3] then
		x.eatkspecial[3] = 2 --turn off of below
		AudioMessage("tcrb0213.wav") --Well lucky day Red. Next time won’t be so fortune (BDogs)
		AudioMessage("tcrb0214.wav") --P1 SUCCEED - Romenski to Karnov, convoy at LPad
		x.audio1 = AudioMessage("tcrb0215.wav") --P2 SUCCEED - Kar - see Chesti takes of safely.
		x.MCAcheck = true
		x.spine = x.spine + 1
	end
	
	--SUCCEED MISSION
	if x.spine == 6 and IsAudioMessageDone(x.audio1) then
		SucceedMission(GetTime() + 1.0, "tcrb02w1.des") --WINNER WINNER WINNER
		x.spine = x.spine + 1
	end
	----------END MAIN SPINE ----------
	
	--HAS EACH APC ARRIVED SAFELY
	if not x.getiton then
		if not x.fapcarrive and IsAlive(x.fapc[1]) and IsAlive(x.fapc[2]) and IsAlive(x.fapc[3]) and ((GetDistance(x.fapc[1], "pnavpad") < 100) or (GetDistance(x.fapc[2], "pnavpad") < 100) or (GetDistance(x.fapc[3], "pnavpad") < 100)) then
			ClearObjectives() --yes, just to do this, I have all the code around it, yeash
			x.fapcarrive = true
		end
		
		if x.fapcarrive then
			for index = 1, 3 do
				if not x.fapcsafe[index] and IsAlive(x.fapc[index]) and (GetDistance(x.fapc[index], "pnavpad") < 150) then 
					x.fapcsafe[index] = true
					SetCurHealth(x.fapc[index], 4000)
					if index == 1 then
						AudioMessage("tcrb0216.wav") --A - Trans 1 at LPad
						AddObjective("tcrb0201.txt", "GREEN")
					elseif index == 2 then
						AudioMessage("tcrb0217.wav") --B - Trans 2 at LPad
						AddObjective("tcrb0202.txt", "GREEN")
					elseif index == 3 then
						AudioMessage("tcrb0218.wav") --C - Trans 3 at LPad
						AddObjective("tcrb0203.txt", "GREEN")
					end
				end
			end
		end
	end
	
	--BDS ENCOUNTER ATTACKS
	for index = 1, 3 do
		--is an apc close to an "encounter" point
		for index2 = 1, 11 do
			if x.eatkencounter[index2] == 0 and (GetDistance(x.fapc[index], ("path%d"):format(index2)) < 200) then
				x.eatkencounter[index2] = 1
			end
			
			--set aside for special attacks
			if index2 == 5 and x.eatkencounter[index2] == 1 and x.eatkspecial[1] == 0 then
				x.eatkencounter[index2] = 2 --bypass regular
				x.eatkspecial[1] = 1 --artillery
			elseif index2 == 6 and x.eatkencounter[index2] == 1 and x.eatkspecial[2] == 0 then
				x.eatkencounter[index2] = 2 --bypass regular
				x.eatkspecial[2] = 1 --recycler/patrol
			elseif index2 == 11 and x.eatkencounter[index2] == 1 and x.eatkspecial[3] == 0 then
				x.eatkencounter[index2] = 2 --bypass regular
				AudioMessage("tcrb0602.wav") --Mines ahead --FROM ANOTTHER MISSION RB06
				ClearObjectives()
				AddObjective("tcrb0201.txt")
				AddObjective("tcrb0202.txt")
				AddObjective("tcrb0203.txt")
				AddObjective("\nClear the minefield. Thumper and soldiers may help.")
				--AddObjective("\nAuthorized to be away from transports if necessary", "CYAN")
				x.eatkspecial[3] = 1 --minefield
				for index = 1, 3 do
					x.eatk[index] = nil --clear these out, just in case
					x.eatkstate[index] = 1 --init to 1
					x.eatkcool[index] = GetTime() --zero float
					x.eatkfaster[index] = 0.0 --zero float
				end
			end
			
			--build and send the random units attack for the correct encounter location
			if x.eatkencounter[index2] == 1 then
				for index3 = 1, 3 do
					while x.randompick == x.randomlast do --random the random
						x.randompick = math.floor(GetRandomFloat(1.0, 15.0))
					end
					x.randomlast = x.randompick
					
					if x.randompick == 1 or x.randompick == 6 or x.randompick == 10 or x.randompick == 13 or x.randompick == 15 then
						x.eatk[index3] = BuildObject("bvscout", 5, ("path%d_%d"):format(index2, index3))
						GiveWeapon(x.eatk[index3], "gminia_c")
						GiveWeapon(x.eatk[index3], "gfafma_c")
					elseif x.randompick == 2 or x.randompick == 7 or x.randompick == 11 or x.randompick == 14 then
						x.eatk[index3] = BuildObject("bvmbike", 5, ("path%d_%d"):format(index2, index3))
            GiveWeapon(x.eatk[index3], "gfafma_c")
					elseif x.randompick == 3 or x.randompick == 8 or x.randompick == 12 then
						x.eatk[index3] = BuildObject("bvmisl", 5, ("path%d_%d"):format(index2, index3))
            GiveWeapon(x.eatk[index3], "gfafma_c")
					elseif x.randompick == 4 or x.randompick == 9 then
						x.eatk[index3] = BuildObject("bvtank", 5, ("path%d_%d"):format(index2, index3))
					else
						x.eatk[index3] = BuildObject("bvrckt", 5, ("path%d_%d"):format(index2, index3))
            GiveWeapon(x.eatk[index3], "gfafma_c")
					end
					SetEjectRatio(x.eatk[index3], 0.0)
					SetSkill(x.eatk[index3], x.skillsetting)
					SetObjectiveName(x.eatk[index3], ("Kill %d"):format(index3))
					Attack(x.eatk[index3], x.fapc[index3])
					x.eatkencounter[index2] = 2
				end
			end
		end
	end

	--BDS ARTILLERY (path5)
	if x.eatkspecial[1] == 1 then
		AudioMessage("tcrb0210.wav") --Picking up artillery on surrounding ridges
		for index = 1, 4 do 
			x.eatk[index] = BuildObject("bvartl", 5, ("path5_%d"):format(index))
			SetSkill(x.eatk[index], x.skillsetting)
			Defend(x.eatk[index])
			SetObjectiveOn(x.eatk[index])
		end
		x.eatk[5] = BuildObject("bvtank", 5, "path5_5")
		SetEjectRatio(x.eatk[5], 0.0)
		SetSkill(x.eatk[5], x.skillsetting)
		Defend2(x.eatk[5], x.eatk[1])
		x.eatk[6] = BuildObject("bvtank", 5, "path5_6")
		SetEjectRatio(x.eatk[6], 0.0)
		SetSkill(x.eatk[6], x.skillsetting)
		Defend2(x.eatk[6], x.eatk[3])
		x.eatk[7] = BuildObject("bvtank", 5, "path5_7")
		SetSkill(x.eatk[7], x.skillsetting)
		Goto(x.eatk[7], "path5_7", 1)
		x.eatk[8] = BuildObject("bvtank", 5, "path5_8")
		SetSkill(x.eatk[8], x.skillsetting)
		Goto(x.eatk[8], "path5_8", 1)
		x.eatkspecial[1] = 2
	end
	
	--BDS RECYCLER (path6)
	if x.eatkspecial[2] == 1 then
		x.eatk[4] = BuildObject("bvmbike", 5, "path6_1")
		x.eatk[5] = BuildObject("bvmisl", 5, "path6_2")
		x.eatk[6] = BuildObject("bvtank", 5, "path6_3")
		x.eatk[7] = BuildObject("bvmisl", 5, "path6_1")
		x.eatk[8] = BuildObject("bvtank", 5, "path6_2")
		x.eatk[9] = BuildObject("bvmbike", 5, "path6_3")
		for index = 4, 12 do
			SetEjectRatio(x.eatk[index], 0.0)
			SetSkill(x.eatk[index], x.skillsetting)
			Patrol(x.eatk[index], "ppatrol1")
		end
		AudioMessage("tcrb0219.wav") --Amer patrol left outpost. Avoid or they alert Bdogs
		x.eatkspecial[2] = 2
	elseif x.eatkspecial[2] == 2 then --if too close to bds erecy forces then attack
		for index = 1, 3 do
			for index2 = 4, 9 do
				if GetDistance(x.fapc[index], x.eatk[index2]) < 120 then
					x.ercyatktooclose = true
				end
			end
		end
		if x.ercyatktooclose then
			AudioMessage("tcrb0220.wav") --Discovered. Move to take out BDog Recy
      if IsAlive(x.eatk[4]) and GetTeamNum(x.eatk[4]) ~= 1 then
        Attack(x.eatk[4], x.fapc[1])
      end
      if IsAlive(x.eatk[5]) and GetTeamNum(x.eatk[5]) ~= 1 then
        Attack(x.eatk[5], x.fapc[2])
      end
      if IsAlive(x.eatk[6]) and GetTeamNum(x.eatk[6]) ~= 1 then
        Attack(x.eatk[6], x.fapc[3])
      end
      if IsAlive(x.eatk[7]) and GetTeamNum(x.eatk[7]) ~= 1 then
        Attack(x.eatk[7], x.fapc[1])
      end
      if IsAlive(x.eatk[8]) and GetTeamNum(x.eatk[8]) ~= 1 then
        Attack(x.eatk[8], x.fapc[2])
      end
      if IsAlive(x.eatk[9]) and GetTeamNum(x.eatk[9]) ~= 1 then
        Attack(x.eatk[9], x.fapc[3])
      end
			x.ercyatktooclose = false
			x.eatkspecial[2] = 3
		end
	end
	
	--BDS Recy dead 
	if x.eatkspecial[2] < 4 and not IsAlive(x.ercy) then --if bds recy killed, retreat the tanks if alive
		for index = 4, 9 do
			if IsAlive(x.eatk[index]) and GetTeamNum(x.eatk[index]) ~= 1 then
				Retreat(x.eatk[index], "ep1")
			end
		end
		x.eatkspecial[2] = 4
	end
	
	--BDS MINES ATTACK (path11)
	if x.eatkspecial[3] == 1 then
		for index = 1, 3 do
			if x.eatkstate[index] == 0 and not IsAlive(x.eatk[index]) then
				x.eatkcool[index] = GetTime() + 5.0 - x.eatkfaster[index]
				if x.eatkfaster[index] < 5.0 then
					x.eatkfaster[index] = x.eatkfaster[index] + 1.0
				end
				x.eatkstate[index] = 1
			end
			
			if x.eatkstate[index] == 1 and x.eatkcool[index] < GetTime() then
				x.eatk[index] = BuildObject("bvtank", 5, ("path11_%d"):format(index))
				SetEjectRatio(x.eatk[index], 0.0)
				SetSkill(x.eatk[index], x.skillsetting)
				Attack(x.eatk[index], x.fapc[index])
				SetObjectiveName(x.eatk[index], ("Kill %d"):format(index))
				x.eatkstate[index] = 0
			end
		end
	end
	
	--BDS SURVEILLANCE CAMS AND SUPPLIES
	for index = 1, 4 do
		--is player cloes enough to bds camera and supplies
		if x.enavfound[index] == 0 and IsAlive(x.enav[index]) and GetDistance(x.player, ("enav%d"):format(index)) < 200 then
			SetObjectiveName(x.enav[index], "BDS supplies")
			SetObjectiveOn(x.enav[index])
			AudioMessage("tcrb0207.wav") --Picking up surveillance cameras ahead.
			x.enavfound[index] = 1
			x.enavtime[index] = GetTime() + 25.0 --msg 10.5 secs
		end
		
		--if killed, give more time (to pick up service pods)
		if x.enavfound[index] == 1 and not IsAlive(x.enav[index]) then
			AudioMessage("tcrb0208.wav") --Excellent. Move trans thru b4 amer know navcam dead
			x.enavtime[index] = GetTime() + 90.0
			x.enavfound[index] = 2
		end
		
		--if player moves far away in time, the player escaped, for now, reset location
		if x.enavfound[index] == 1 and x.enavtime[index] > GetTime() and GetDistance(x.player, ("enav%d"):format(index)) > 260 then
			SetObjectiveOff(x.enav[index])
			x.enavtime[index] = GetTime() + 99999.9
			x.enavfound[index] = 0
		end
		
		--if nav time runs out send extra BDS attack
		if (x.enavfound[index] == 1 or x.enavfound[index] == 2) and x.enavtime[index] < GetTime() and GetDistance(x.player, ("enav%d"):format(index)) < 250 then
			SetObjectiveOff(x.enav[index])
			AudioMessage("tcrb0209.wav") --Nice try pinko, but you can't shake the BDogs easily (BDogs)
			x.enavatk[1] = BuildObject("bvscout", 5, ("enavatk%d"):format(index))
			x.enavatk[2] = BuildObject("bvmbike", 5, ("enavatk%d"):format(index))
			x.enavatk[3] = BuildObject("bvscout", 5, ("enavatk%d"):format(index))
			for index = 1, 3 do
				SetEjectRatio(x.enavatk[index], 0.0)
				SetSkill(x.enavatk[index], x.skillsetting)
				Attack(x.enavatk[index], x.fapc[index])
			end
			x.enavfound[index] = 3
			x.enavtime[index] = 99999.9
		end
	end
	
	--ANNOY THE PLAYER IF THEY GET TOO FAR FROM THE TRANSPORTS
	if x.eatkspecial[3] == 0 and x.whinetime < GetTime() then
		for index = 1, 3 do
			if IsAlive(x.fapc[index]) and GetDistance(x.player, x.fapc[index]) > 330 then
				AudioMessage("alertpulse.wav")
				ClearObjectives()
				AddObjective("tcrb0201.txt")
				AddObjective("tcrb0202.txt")
				AddObjective("tcrb0203.txt")
				AddObjective("\nStay within 300m of all transports", "YELLOW", 4.0)
				x.whinefail = x.whinefail + 1
				x.whinetime = GetTime() + 4.0
				break
			end 
			--close enough to at least one transport
			if IsAlive(x.fapc[index]) and GetDistance(x.player, x.fapc[index]) < 320 then
				x.whinefail = 0
				break
			end
		end
	end
	
	--CHECK STATUS OF MCA ----------------------------------
	if not x.MCAcheck then	
		for index = 1, 3 do
			if not IsAround(x.fapc[index]) then
				x.fapcdead[index] = true
			end
		end
		
		if x.fapcdead[1] or x.fapcdead[2] or x.fapcdead[3] then --lost a transport
			AudioMessage("tcrb0212.wav") --FAIL - lost a transport 
			ClearObjectives()  		
			for index = 1, 3 do
				if not x.fapcdead[index] then
					AddObjective(("tcrb020%d.txt"):format(index), "WHITE")
				else
					AddObjective(("tcrb020%d.txt"):format(index), "RED")
				end
			end 
			FailMission(GetTime() + 10.0, "tcrb02f1.des") --LOSER LOSER LOSER
			x.spine = 666
			x.MCAcheck = true
		end
		
		if x.gotcone and not IsAlive(x.fpad) or not IsAlive(x.fcne) then --destroy lpad or cone
			AudioMessage("alertpulse.wav")
			ClearObjectives()
			AddObjective("You were not authorized to destroy that.\n\nMISSION FAILED!", "RED")
			FailMission(GetTime() + 3.0, "tcrb02f1.des") --LOSER LOSER LOSER
			x.spine = 666
			x.MCAcheck = true
		end
		
		if x.whinefail == 8 then
			AudioMessage("alertpulse.wav")
			ClearObjectives()
			AddObjective("Failed to stay with transports.\n\nMISSION FAILED!", "RED")
			FailMission(GetTime() + 3.0, "tcrb02f2.des") --LOSER LOSER LOSER
			x.spine = 666
			x.MCAcheck = true
		end
	end
end
--[[END OF SCRIPT]]