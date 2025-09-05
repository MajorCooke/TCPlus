--bztcbd05 - Battlezone Total Command - Rise of the Black Dogs - 5/10 - THE LAST STAND
assert(load(assert(LoadFile("_requirefix.lua")),"_requirefix.lua"))();
TCC = require("TC_Core")
MisnNum = 19;
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
	camstate = 0, 
	camfov = 60,  --185 default
	userfov = 90,  --seed
	fnav = {},	
	casualty = 0,
	randompick = 0, 
	randomlast = 0,
	frcystate = 0, 
	fgrp = {},
	frcy = nil, 
	ffac = nil, 
	farm = nil, 
	fcom = nil, 
	fpwr = {}, 
	fgun = {}, 
	fscv = {}, 
	fsrv = {}, 
	ercy = nil, 
	efac = nil, 
	earm = nil, 
	ecom = nil, 
	ehng = nil, 
	etrn = nil, 
	epwr = {}, 
	etur = {}, 
	eatk = {}, 
	etug = {}, 
	pool = nil, 
	poolstate = 0, --bomb biometal stuff
	pooltime = 99999.9, 
	nuke = nil, 
	dummy = nil, 
	dummy2 = nil, 
	bomb = nil, 
	wavecounter = 0, 
	wavecountermax = 0, 
	attackecom = false, 
	freestuff = {}, --free stuff
	freestuffstate = {0, 0, 0}, 
	freefinder = nil, 
	freestufffound = 0, 
	freefoundstate = {0, 0, 0}, 
	freegotit = 0, 
	ewardeclare = false, --WARCODE --1 recy, 2 fact, 3 armo, 4 base 
	ewartotal = 2, 
	ewarrior = {}, 
	ewartime = {},
	ewartimecool = {},
	ewartimeadd = {},
	ewarabort = {}, 
	ewarstate = {}, 
	ewarsize = {}, 
	ewarwave = {}, 
	ewarwavemax = {}, 
	ewarwavereset = {}, 
	ewarmeet = {}, 
	escv = {}, --scav stuff
	escvlength = 2, 
	wreckbank = false, --have 2
	escvbuildtime = {}, 
	escvstate = {}, 
	LAST = true
}
--PATHS: pmytank, fpgrp(0-16), fpscv(0-3), fpsrv(0-4), epatk(0-10), eptur(0-25), pcam1, eptug, pcam1, pscrap(0-100), epgfac, stage1-2(0-6)

function InitialSetup()
	SetAutoGroupUnits(true)
		
	local odfpreload = {
		"mvtug", "mvscout", "mvmbike", "mvmisl", "mvtank", "mvrckt", "mvturr", "abnukeprop00", "apdwqka2", "scrfld4g", 
		"bvscout", "bvmbike", "bvmisl", "bvtank", "bvrckt", "bvscav", "bvserv", "ablpad", "mbtrain", "dummy00", "apcamrb" 
	}
	for k,v in pairs(odfpreload) do
		PreloadODF(v)
	end
	
	x.pool = GetHandle("fpool")
	x.frcy = GetHandle("frcy")
	x.ffac = GetHandle("ffac")
	x.fpad = GetHandle("fpad")
	x.fcom = GetHandle("fcom")
	for index = 1, 6 do
		x.fgun[index] = GetHandle(("fgun%d"):format(index))
	end
	x.fpwr[1] = GetHandle("fpwr1")
	x.fpwr[2] = GetHandle("fpwr2")
	x.fpwr[3] = GetHandle("fpwr3")
	x.ercy = GetHandle("ercy")
	x.efac = GetHandle("efac")
	x.ecom = GetHandle("ecom")
	x.ehng = GetHandle("ehng")
	x.etrn = GetHandle("etrn")
	x.freestuff[1] = GetHandle("hart1")
	x.freestuff[2] = GetHandle("hart2")
	x.freestuff[3] = GetHandle("hart3")
	SetColorFade(6.0, 0.5, "BLACK")
	TCC.InitialSetup();
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

function AddObject(h)
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
		x.mytank = BuildObject("bvtank", 1, "pmytank")
		GiveWeapon(x.mytank, "gminia_c")
		SetAsUser(x.mytank, 1)
		RemoveObject(x.player)
		x.player = GetPlayerHandle()
		x.pos = GetTransform(x.fpad)
		RemoveObject(x.fpad)
		x.fpad = BuildObject("ablpad", 1, x.pos)
		for index = 1, 3 do --12 units player
			x.fgrp[index] = BuildObject("bvmbike", 1, "fpgrp", index)
			SetSkill(x.fgrp[index], 3)
			SetGroup(x.fgrp[index], 0)
			x.fgrp[index+5] = BuildObject("bvmisl", 1, "fpgrp", index+5)
			SetSkill(x.fgrp[index+5], 3)
			SetGroup(x.fgrp[index+5], 1)
			x.fgrp[index+10] = BuildObject("bvtank", 1, "fpgrp", index+10)
			SetSkill(x.fgrp[index+10], 3)
			SetGroup(x.fgrp[index+10], 2)
			x.fgrp[index+15] = BuildObject("bvrckt", 1, "fpgrp", index+15)
			SetSkill(x.fgrp[index+15], 3)
			SetGroup(x.fgrp[index+15], 3)
		end
		for index = 1, 3 do --scav
			x.fscv[index] = BuildObject("bvscav", 1, "fpscv", index)
			SetGroup(x.fscv[index], 7)
		end
		for index = 1, 4 do --serv
			x.fsrv[index] = BuildObject("bvserv", 1, "fpsrv", index)
			SetGroup(x.fsrv[index], 4)
		end
		for index = 1, 25 do	 --turrets
			x.etur[index] = BuildObject("mvturr", 5, "eptur", index)
			SetSkill(x.etur[index], x.skillsetting)
		end
		x.eatk[1] = BuildObject("mvtank", 5, "epatk", 1)
		x.eatk[2] = BuildObject("mvmisl", 5, "epatk", 2)
		x.eatk[3] = BuildObject("mvmbike", 5, "epatk", 3)
		x.eatk[4] = BuildObject("mvtank", 5, "epatk", 4)
		x.eatk[5] = BuildObject("mvscout", 5, "epatk", 5)
		x.eatk[6] = BuildObject("mvscout", 5, "epatk", 6)
		x.eatk[7] = BuildObject("mvtank", 5, "epatk", 7)
		x.eatk[8] = BuildObject("mvmisl", 5, "epatk", 8)
		x.eatk[9] = BuildObject("mvmbike", 5, "epatk", 9)
		x.eatk[10] = BuildObject("mvtank", 5, "epatk", 10)
		x.eatk[11] = BuildObject("mvmisl", 5, "epatk", 1)
		x.eatk[12] = BuildObject("mvtank", 5, "epatk", 2)
		x.eatk[13] = BuildObject("mvtank", 5, "epatk", 3)
		x.eatk[14] = BuildObject("mvmbike", 5, "epatk", 4)
		x.eatk[15] = BuildObject("mvmbike", 5, "epatk", 5)
		x.eatk[16] = BuildObject("mvscout", 5, "epatk", 6)
		x.eatk[17] = BuildObject("mvscout", 5, "epatk", 7)
		x.eatk[18] = BuildObject("mvtank", 5, "epatk", 8)
		x.eatk[19] = BuildObject("mvtank", 5, "epatk", 9)
		x.eatk[20] = BuildObject("mvmisl", 5, "epatk", 10)
		for index = 1, 20 do 
			SetSkill(x.eatk[index], x.skillsetting)
		end
		x.pos = GetTransform(x.etrn)
		RemoveObject(x.etrn)
		x.etrn = BuildObject("mbtrain",	5, x.pos)
		for index = 1, 3 do
			TCC.SetTeamNum(x.freestuff[index], 5)
		end
		x.spine = x.spine + 1	
	end
	
	--BLOW UP BIO-METAL POOL
	if x.spine == 1 then
		if x.poolstate == 0 then
			x.audio1 = AudioMessage("tcbd0504.wav") --ADDED --Damn, that was our only Silo. Cobra One, 
			x.dummy = BuildObject("dummy00", 0, "pcam1")
			x.dummy2 = BuildObject("dummy00", 0, x.pool)
			x.etug = BuildObject("mvtug", 5, "eptug")
			x.nuke = BuildObject("abnukeprop00", 5, "eptug")
			Pickup(x.etug, x.nuke)
			x.poolwait = GetTime() + 4.0
			x.poolstate = x.poolstate + 1
		elseif x.poolstate == 1 and x.poolwait < GetTime() then
			Goto(x.etug, x.pool)
			x.camstate = 1
      x.userfov = IFace_GetInteger("options.graphics.defaultfov")
      CameraReady()
      IFace_SetInteger("options.graphics.defaultfov", x.camfov)
			x.poolstate = x.poolstate + 1
		elseif x.poolstate == 2 and IsAlive(x.etug) and GetDistance(x.etug, x.pool, 1) < 25 then
			Dropoff(x.etug, x.nuke)
			x.poolwait = GetTime () + 2.0
			x.poolstate = x.poolstate + 1
		elseif x.poolstate == 3 and x.poolwait < GetTime() then
			Goto(x.etug, "eptug")
			x.poolwait = GetTime () + 8.0
			x.poolstate = x.poolstate + 1
		elseif x.poolstate == 4 and x.poolwait < GetTime() then
			x.bomb = BuildObject("apdwqka2", 5, x.nuke)
			x.poolwait = GetTime () + 2.0
			x.poolstate = x.poolstate + 1
		elseif x.poolstate == 5 and x.poolwait < GetTime() then
			x.pos = GetTransform(x.pool)
			RemoveObject(x.nuke)
			RemoveObject(x.pool)
			x.nuke = BuildObject("scrfld4g", 0, x.pos)
			x.poolwait = GetTime () + 6.0
			x.poolstate = x.poolstate + 1
			x.camstate = 2
		elseif x.poolstate == 6 and x.poolwait < GetTime() then
			Damage(x.fgun[1], 10000)
			Damage(x.fgun[2], 10000)
			Damage(x.fgun[3], 10000)
			Damage(x.farm, 15000)
			Damage(x.ffac, 15000)
			Damage(x.fpwr[1], 10000)
			Damage(x.fpwr[2], 2000)  --keep this one alive ... barely
			x.poolwait = GetTime () + 6.0
			x.poolstate = x.poolstate + 1
			x.camstate = 2
		elseif x.poolstate == 7 and x.poolwait < GetTime() then
			x.camstate = 0
      CameraFinish()
      IFace_SetInteger("options.graphics.defaultfov", x.userfov)
			RemoveObject(x.etug)
			RemoveObject(x.dummy)
			RemoveObject(x.dummy2)
			for index = 1, 100 do
				x.fnav[1] = BuildObject("npscrx", 0, "pscrap", index)
			end
			x.poolstate = x.poolstate + 1
			x.spine = x.spine + 1
		end
	end

	--GIVE FIRST OBJECTIVE
	if x.spine == 2 and (IsAudioMessageDone(x.audio1) or CameraCancelled()) then
		AudioMessage("tcbd0501.wav") --Sov destroyed only bio-metal pool/ Cmd base is being overrun.
		AddObjective("tcbd0501.txt")
		for index = 1, 5 do
			Attack(x.eatk[index], x.fcom)
		end
		for index = 11, 15 do
			Attack(x.eatk[index], x.frcy)
		end		
		for index = 1, x.ewartotal do --init WARCODE
			x.ewardeclare = true
			x.ewarrior[index] = {} --"rows"
			for index2 = 1, 6 do --SPECIAL FOR BD05
				x.ewarrior[index][index2] = nil --"columns", init (handle in this case)
			end
			x.ewarstate[index] = 1
			x.ewartime[1] = GetTime() + 60.0 --recy
			x.ewartime[2] = GetTime() + 120.0 --fcom
			x.ewartimecool[index] = 60.0
			x.ewartimeadd[index] = 0.0
			x.ewarabort[index] = 99999.9
			x.ewarsize[index] = 0
			x.ewarwave[index] = 0
			x.ewarwavemax[index] = 5
			x.ewarwavereset[index] = 2
			x.ewarmeet[index] = 2
		end
		for index = 1, x.escvlength do --init escv
			x.escvbuildtime[index] = GetTime()
			x.escvstate[index] = 1
		end
		x.waittime = GetTime() + 60.0
		x.spine = x.spine + 1
	end
	
	--SECOND ATTACK WAVE
	if x.spine == 3 and x.waittime < GetTime() then
		for index = 6, 10 do
			Attack(x.eatk[index], x.fcom)
		end
		for index = 16, 20 do
			Attack(x.eatk[index], x.frcy)
		end	 
		x.spine = x.spine + 1
	end
	
	--ATTACK ECOM
	if x.spine == 4 and (x.attackecom or x.frcystate == 1) then
		x.audio1 = AudioMessage("tcbd0502.wav") --Cobra One, we need you to destroy the Soviet Communications tower. 
		ClearObjectives()
		AddObjective("tcbd0502.txt")
		SetObjectiveOn(x.ecom)
		x.spine = x.spine + 1
	end
	
	--MISSION SUCCESS
	if x.spine == 5 and not IsAlive(x.ecom) then
		AudioMessage("tcbd0505.wav") --ADDED --CCA Comm Tower down we’re now able to transmit for help.
		ClearObjectives()
		AddObjective("tcbd0501.txt", "GREEN")
		AddObjective("	")
		AddObjective("tcbd0502.txt", "GREEN")
		AddObjective("	")
		AddObjective("\n\nMISSION COMPLETE!", "GREEN")
		x.frcystate = 1
		TCC.SucceedMission(GetTime() + 11.0, "tcbd05w.des") --WINNER WINNER WINNER
		x.spine = 666
		x.MCAcheck = true
	end
	----------END MAIN SPINE ----------
	
	--CAMERA SEQUENCES
	if x.camstate == 1 then
		CameraObject(x.dummy, 0, 30, 0, x.dummy2)
	elseif x.camstate == 2 then --ON CCA PILOT
		CameraPath("pcam1", 3000, 5000, x.dummy2)
	end
	
	--RECYCLER KILLED
	if x.frcystate == 0 and not IsAlive(x.frcy) then
		AudioMessage("tcbd0503.wav") --We just lost our main Recycler. We're out of options. Kill cca comm
		x.frcystate = 1
	end
	
	--MARK FOUND FREE STUFF
	if x.freestufffound < 3 then
		for index = 1, 3 do
			if x.freefoundstate[index] == 0 and IsAlive(x.freestuff[index]) and GetDistance(x.freestuff[index], GetNearestEnemy(x.freestuff[index], 1, 0, 450)) < 444 then
				TCC.SetTeamNum(x.freestuff[index], 0)
				StartSoundEffect("emspin.wav") --world zoom 6s plus long silence keep as sfx
				SetObjectiveName(x.freestuff[index], "ID Artifact")
				SetObjectiveOn(x.freestuff[index])
				x.freefoundstate[index] = 1
				x.freestufffound = x.freestufffound + 1
			end
		end
	end
	
	--HAND OUT FREE STUFF TO THE CURIOUS
	if x.freegotit < 3 then
		if IsAlive(x.freestuff[1]) and IsInfo("yvcatass07a") and x.freestuffstate[1] == 0 then
			index = 1
		elseif IsAlive(x.freestuff[2]) and IsInfo("yvcatass07b") and x.freestuffstate[2] == 0 then
			index = 2
		elseif IsAlive(x.freestuff[3]) and IsInfo("yvcatass07c") and x.freestuffstate[3] == 0 then
			index = 3
		end
		if index > 0 then
			SetObjectiveOff(x.freestuff[index])
			SetObjectiveName(x.freestuff[index], "Catapult art")
			TCC.SetTeamNum(x.freestuff[index], 1)
			SetGroup(x.freestuff[index], 9)
			SetSkill(x.freestuff[index], 2)
			x.freestuffstate[index] = 1
			x.freegotit = x.freegotit + 1
		end
		index = 0
	end
	
	--CHECK FOR EARLY SHUTDOWN
	if x.ewardeclare and not IsAlive(x.ercy) and not IsAlive(x.efac) then
		x.ewardeclare = false
	end
	
	--AI GROUP SCAVENGERS
	if IsAlive(x.ercy) then
		if GetScrap(5) > 39 and not x.wreckbank then --don't interfere with daywrecker
			SetScrap(5, (GetMaxScrap(5) - 40))
		end
		for index = 1, x.escvlength do
			if x.escvstate[index] == 1 and not IsAlive(x.escv[index]) then
				x.escvbuildtime[index] = GetTime() + 180.0
				x.escvstate[index] = 2
			elseif x.escvstate[index] == 2 and x.escvbuildtime[index] < GetTime() then
				x.escv[index] = BuildObject("mvscav", 5, GetPositionNear("epgrcy", 0, 16, 32)) --grpspwn
				x.escvstate[index] = 1
			end
		end
	end
	
	--WARCODE --special, unit built based on individual building alive
	if x.ewardeclare then
		for index = 1, x.ewartotal do	
			if x.ewartime[index] < GetTime() then 
				--SET WAVE NUMBER AND BUILD SIZE
				if x.ewarstate[index] == 1 then
					x.ewarwave[index] = x.ewarwave[index] + 1
					if x.ewarwave[index] > x.ewarwavemax[index] then
						x.ewarwave[index] = x.ewarwavereset[index]
					end
					if x.ewarwave[index] == 1 then
							x.ewarsize[index] = 4
              if x.attackecom or x.frcystate == 1 then
                x.ewarsize[index] = 3
              end
					elseif x.ewarwave[index] == 2 then
							x.ewarsize[index] = 6
              if x.attackecom or x.frcystate == 1 then
                x.ewarsize[index] = 4
              end
					elseif x.ewarwave[index] == 3 then
							x.ewarsize[index] = 8
              if x.attackecom or x.frcystate == 1 then
                x.ewarsize[index] = 5
              end
					elseif x.ewarwave[index] == 4 then
							x.ewarsize[index] = 10
              if x.attackecom or x.frcystate == 1 then
                x.ewarsize[index] = 6
              end
					else --x.ewarwave[index] == 5 then
							x.ewarsize[index] = 12
              if x.attackecom or x.frcystate == 1 then
                x.ewarsize[index] = 8
              end
					end
					x.ewarstate[index] = x.ewarstate[index] + 1
				end
				
				--BUILD FORCE
				if x.ewarstate[index] == 2 then
					for index2 = 1, x.ewarsize[index] do
						while x.randompick == x.randomlast do --random the random
							x.randompick = math.floor(GetRandomFloat(1.0, 15.0))
						end
						x.randomlast = x.randompick
						if IsAlive(x.ercy) and (x.randompick == 1 or x.randompick == 6 or x.randompick == 11) then
							x.ewarrior[index][index2] = BuildObject("mvscout", 5, GetPositionNear("epgrcy", 0, 16, 32)) --grpspwn
						elseif IsAlive(x.efac) and (x.randompick == 2 or x.randompick == 7 or x.randompick == 12) then
							x.ewarrior[index][index2] = BuildObject("mvmbike", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
						elseif IsAlive(x.efac) and (x.randompick == 3 or x.randompick == 8 or x.randompick == 13) then
							x.ewarrior[index][index2] = BuildObject("mvmisl", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
						elseif IsAlive(x.efac) and (x.randompick == 4 or x.randompick == 9 or x.randompick == 14) then
							x.ewarrior[index][index2] = BuildObject("mvtank", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
						elseif IsAlive(x.efac) then
							x.ewarrior[index][index2] = BuildObject("mvrckt", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
						elseif IsAlive(x.ercy) then
							x.ewarrior[index][index2] = BuildObject("mvscout", 5, GetPositionNear("epgrcy", 0, 16, 32)) --grpspwn
						elseif IsAlive(x.ehng) then
							x.ewarrior[index][index2] = BuildObject("mvscout", 5, x.ehng)
						end
            if IsAlive(x.ewarrior[index][index2]) then
              if index2 % 3 == 0 then
                SetSkill(x.ewarrior[index][index2], x.skillsetting+1)
              end
              SetSkill(x.ewarrior[index][index2], x.skillsetting)
            end
					end
					x.ewarabort[index] = GetTime() + 300.0 --here first in case stage goes wrong
					x.ewarstate[index] = x.ewarstate[index] + 1
				end
				
				--GIVE MARCHING ORDERS
				if x.ewarstate[index] == 3 then
					if x.ewarmeet[index] == 2 then
						x.ewarmeet[index] = 1
					else
						x.ewarmeet[index] = 2
					end
					for index2 = 1, x.ewarsize[index] do
						if IsAlive(x.ewarrior[index][index2]) then
							Goto(x.ewarrior[index][index2], ("stage%d"):format(x.ewarmeet[index]))
						end
					end
					x.ewarstate[index] = x.ewarstate[index] + 1
				end
				
				--A UNIT AT STAGE PT
				if x.ewarstate[index] == 4 then
					for index2 = 1, x.ewarsize[index] do
						if IsAlive(x.ewarrior[index][index2]) and GetDistance(x.ewarrior[index][index2], ("stage%d"):format(x.ewarmeet[index]), 6) < 100 then
							x.ewarstate[index] = x.ewarstate[index] + 1
							break
						end
					end
				end
				
				--GIVE ATTACK ORDER
				if x.ewarstate[index] == 5 then
					for index2 = 1, x.ewarsize[index] do
						if IsAlive(x.ewarrior[index][index2]) and GetTeamNum(x.ewarrior[index][index2]) ~= 1 then
							if index == 1 then
								if IsAlive(x.frcy) then
									Attack(x.ewarrior[index][index2], x.frcy)
								else
									Attack(x.ewarrior[index][index2], x.fcom)
								end
							elseif index == 2 then
								Attack(x.ewarrior[index][index2], x.fcom)
							end
							x.ewarabort[index] = x.ewartime[index] + 240.0
						end
					end
					x.ewarstate[index] = x.ewarstate[index] + 1
				end
				
				--CHECK CASUALTY AND RESET
				if x.ewarstate[index] == 6 then
					for index2 = 1, x.ewarsize[index] do
						if not IsAlive(x.ewarrior[index][index2]) then
							x.casualty = x.casualty + 1
						end
					end
					if x.casualty >= math.floor(x.ewarsize[index] * 0.8) then
						x.ewarabort[index] = 99999.9
						x.ewartime[index] = GetTime() + x.ewartimecool[index] + x.ewartimeadd[index]
						if x.ewarwave[index] == 5 then --extra time after last wave to "ease up"
							x.ewartime[index] = GetTime() + x.ewartimecool[index] + x.ewartimeadd[index] + 90.0
						end
						
						--FOR THIS MISSION BD05 - CHECK IF CLEAR TO ATTACK ECOM
						if not x.attackecom and x.ewarwave[2] == 3 then  --wave was 4
							x.attackecom = true
							x.ewartimeadd[1] = 60.0 --lil easier after comm notification ...
							x.ewartimeadd[2] = 60.0 --...so player can build force and attack
						end
						x.ewarstate[index] = 1 --RESET
					end
					x.casualty = 0
				end
			end
			
			--ABORT AND RESET IF NEEDED
			if x.ewarabort[index] < GetTime() then
				x.ewartime[index] = GetTime()
				x.ewarstate[index] = 1 --RESET
				x.ewarabort[index] = 99999.9
			end
		end
	end--WARCODE END

	--CHECK STATUS OF MCA 
	if not x.MCAcheck then	
		if not IsAlive(x.fcom) then --comm tower lost
			ClearObjectives()
			AddObjective("tcbd0501.txt", "RED")
			AddObjective("\n\nMISSION FAILED!", "RED")
			TCC.FailMission(GetTime() + 4.0, "tcbd05f1.des") --LOSER LOSER LOSER
			x.spine = 666
			x.MCAcheck = true
		end
	end
end
--[[END OF SCRIPT]]