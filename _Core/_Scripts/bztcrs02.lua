--bztcrs02 - Battlezone Total Command - Red Storm - 2/8 - PROTECTION
assert(load(assert(LoadFile("_requirefix.lua")),"_requirefix.lua"))();
TCC = require("TC_Core")
MisnNum = 14;
require("bzccGPNfix");
local GetPositionNear = GetPositionNearPath
local index = 1
local index2 = 1
local x = {
	FIRST = true,
	spine = 0,
	MCAcheck = false,
	waittime = 99999.9,
	player = nil, 
	mytank = nil, 
	skillsetting = 0, 
	pos = {},	
	casualty = 0, 
	randompick = 0, 
	randomspawn = 0, --for ftec attacks
	randomlast = 0,
	audio1 = nil, 
	audio6 = nil, 
	camstate = 0, 
	camheight = 0, 
  camfov = 60,  --185 default
	userfov = 90,  --seed
	eatk = {}, --ftec attackers
	eart = {}, --artillery
	eatktime = 99999.9, 
	eatkwarnstate = 0, 
	eatkartl = 0, 
	escort = {}, --1 defector golem, 2 Gen Fu
	ewlkstate = 0, 
	fapcstate = 0, 
	fuhurt = false, 
	fally = {}, 
	fnav = {},
	frcy = nil, 
	ffac = nil, 
	farm = nil, 
	ftec = nil, 
	fscv = {}, 
	fcon = nil, 
	fpad = nil, 
	eventstate = 0, 
	easn = {}, --assassin stuff
	easnspn = 0, 
	easnbuilt = {}, 
	easnstate = 0, 
	easntime = 99999.9,	 
	eturtime = 99999.9, 
	eturlength = 6,	
	etur = {}, 
	eturcool = {}, 
	eturallow = {}, 
	ewardeclare = false, --WARCODE --1 recy, 2 fact, 3 armo, 4 base 
	ewartotal = 3, --NO BASE IN THIS ONE
	ewarrior = {}, 
	ewartrgt = {}, 
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
	LAST = true
}
--Paths: epwlk, fpapc, pcam, ep1_1-4, ep2_1-4, ep3_1-4, ep4_1-4, ep5_1-4, eptur1-6, epg1-6, stage1, stage2, pasn1-2

function InitialSetup()
	SetAutoGroupUnits(true)
	
	local odfpreload = {
		"svscout", "svmbike", "svmisl", "svtank", "svrckt", "svwalk", "svartl", "svturr", "aprktba", "kblpad", "apcamrk"
	}
	for k,v in pairs(odfpreload) do
		PreloadODF(v)
	end

	x.mytank = GetHandle("mytank")
	x.frcy = GetHandle("frcy")
	x.ffac = GetHandle("ffac")
	x.farm = GetHandle("farm")
	x.ftec = GetHandle("ftec")
	x.fscv[1] = GetHandle("fscv1")
	x.fscv[2] = GetHandle("fscv2")
	x.fcon = GetHandle("fcon")
	x.fpad = GetHandle("fpad")
	for index = 1, 6 do
		x.fally[index] = GetHandle(("fally%d"):format(index))
	end
	Ally(1, 4) --4 Defector and General
	Ally(4, 1)
	SetTeamColor(4, 90, 100, 70)  
	SetColorFade(6.0, 0.5, "BLACK")
	TCC.Init()
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
	if (not IsAlive(x.farm) or x.farm == nil) and (IsOdf(h, "kvarmors01:1") or IsOdf(h, "kbarmors01")) then
		x.farm = h
	elseif (not IsAlive(x.ffac) or x.ffac == nil) and (IsOdf(h, "kvfactrs01:1") or IsOdf(h, "kbfactrs01")) then
		x.ffac = h
	end
	TCC.AddObject(h)
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
	
	--SETUP MISSION BASICS
	if x.spine == 0 then
		AudioMessage("tcrs0201.wav") --Eng set to work on Peg. Fend off Russian attacks (hangar)
		x.pos = GetTransform(x.mytank)
		RemoveObject(x.mytank)
		x.mytank = BuildObject("kvtanknc", 1, x.pos)
		x.pos = GetTransform(x.fscv[1])
		RemoveObject(x.fscv[1])
		x.fscv[1] = BuildObject("kvscav", 1, x.pos)
		SetGroup(x.fscv[1], 1)
		x.pos = GetTransform(x.fscv[2])
		RemoveObject(x.fscv[2])
		x.fscv[2] = BuildObject("kvscav", 1, x.pos)
		SetGroup(x.fscv[2], 2)
		x.pos = GetTransform(x.fcon)
		RemoveObject(x.fcon)
		x.fcon = BuildObject("kvconsrs01", 1, x.pos)
		SetGroup(x.fcon, 3)
		x.pos = GetTransform(x.fally[1])
		RemoveObject(x.fally[1])
		x.fally[1] = BuildObject("kvscoutnc", 1, x.pos)
		x.pos = GetTransform(x.fally[2])
		RemoveObject(x.fally[2])
		x.fally[2] = BuildObject("kvscoutnc", 1, x.pos)
		x.pos = GetTransform(x.fally[3])
		RemoveObject(x.fally[3])
		x.fally[3] = BuildObject("kvmbikenc", 1, x.pos)
		x.pos = GetTransform(x.fally[4])
		RemoveObject(x.fally[4])
		x.fally[4] = BuildObject("kvmbikenc", 1, x.pos)
		x.pos = GetTransform(x.fally[5])
		RemoveObject(x.fally[5])
		if x.skillsetting >= 1 then
			x.fally[5] = BuildObject("kvtanknc", 1, x.pos)
		end
		x.pos = GetTransform(x.fally[6])
		RemoveObject(x.fally[6])
		if x.skillsetting >= 2 then
			x.fally[6] = BuildObject("kvtanknc", 1, x.pos)  
		end
		x.pos = GetTransform(x.fpad)
		RemoveObject(x.fpad)
		x.fpad = BuildObject("kblpad", 1, x.pos)
		SetAsUser(x.mytank, 1)
		RemoveObject(x.player)
		x.player = GetPlayerHandle()
		GiveWeapon(x.player, "grktba_c")
		for index = 1, 6 do
			SetSkill(x.fally[6], x.skillsetting)
			SetGroup(x.fally[index], 0)
		end
		for index = 1, 30 do
			x.easnbuilt[index] = 0
		end
		x.camstate = 1
		x.camheight = 200
    x.userfov = IFace_GetInteger("options.graphics.defaultfov")
    CameraReady()
    IFace_SetInteger("options.graphics.defaultfov", x.camfov)
		x.waittime = GetTime() + 15.0
		x.spine = x.spine + 1
	end
	
	--SEND ATTACKS
	if x.spine == 1 and (CameraCancelled() or x.waittime < GetTime()) then
    CameraFinish()
    IFace_SetInteger("options.graphics.defaultfov", x.userfov)
		x.camstate = 0
		AddObjective("tcrs0201.txt")
		SetObjectiveName(x.ftec, "Protect Field Lab")
		SetObjectiveOn(x.ftec)
		x.eatk[1] = BuildObject("svscout", 5, GetPositionNear("ep4_1", 0, 8, 16))
		x.eatk[2] = BuildObject("svscout", 5, GetPositionNear("ep4_2", 0, 8, 16))
		x.eatk[3] = BuildObject("svmbike", 5, GetPositionNear("ep4_3", 0, 8, 16))
		x.eatk[4] = BuildObject("svmbike", 5, GetPositionNear("ep4_1", 0, 8, 16))
		x.eatk[5] = BuildObject("svmisl", 5, GetPositionNear("ep4_2", 0, 8, 16))
		x.eatk[6] = BuildObject("svmisl", 5, GetPositionNear("ep4_3", 0, 8, 16))
		x.eatkwarnstate = 1 --init run
		for index = 1, 6 do
			SetEjectRatio(x.eatk[index], 0.0)
			SetSkill(x.eatk[index], x.skillsetting)
			Attack(x.eatk[index], x.ftec)
		end
		x.eturtime = GetTime()
		for index = 1, x.eturlength do --init etur
			x.eturcool[index] = GetTime()
			x.eturallow[index] = true
		end
		for index = 1, x.ewartotal do --init WARCODE
			x.ewardeclare = true
			x.ewarrior[index] = {} --"rows"
			for index2 = 1, 10 do --10 per wave max avail
				x.ewarrior[index][index2] = nil --"columns", init (handle in this case)
			end
			x.ewartrgt[index] = nil
			x.ewarstate[index] = 1
			x.ewartime[1] = GetTime() --recy
			x.ewartime[2] = GetTime() + 30.0 --fact
			x.ewartime[3] = GetTime() + 60.0 --armo --NO BASE IN THIS ONE
			x.ewartimecool[index] = 160.0
			x.ewartimeadd[index] = 0.0
			x.ewarabort[index] = 99999.9
			x.ewarsize[index] = 0
			x.ewarwave[index] = 0
			x.ewarwavemax[index] = 5
			x.ewarwavereset[index] = 2
			x.ewarmeet[index] = 2
		end
		x.eatktime = GetTime() + 120.0 --etec attacks replace base attacks
		x.spine = x.spine + 1
	end
	
	--START THE GOLEM PHASE
	if x.spine == 2 and x.ewlkstate == 1 then
		AudioMessage("tcrs0207.wav") --CRA - Russian walker approach. RUS - Rus walker Omega-7
		AddObjective("	")
		AddObjective("tcrs0202.txt")
		AddObjective("SAVE", "DKGREY")
		x.escort[1] = BuildObject("svwalk", 4, "epwlk")
		Retreat(x.escort[1], x.frcy)
		SetObjectiveName(x.escort[1], "Defector")
		SetObjectiveOn(x.escort[1])
		x.ewlkstate = 2
		x.easnstate = 1 --start assassin set 1
		x.easntime = GetTime() + 35.0
		x.spine = x.spine + 1 
	end
	
	--HAS GOLEM ARRIVED
	if x.spine == 3 and IsAlive(x.escort[1]) and IsAlive(x.frcy) and GetDistance(x.escort[1], x.frcy) < 40 then
		x.audio1 = AudioMessage("tcrs0208.wav") --It seems we have another new piece of equip for the struggle
		x.spine = x.spine + 1
	end
	
	--FINISH THE GOLEM PHASE
	if x.spine == 4 and IsAudioMessageDone(x.audio1) then
		AudioMessage("emdotcox.wav")
		ClearObjectives()
		AddObjective("tcrs0201.txt")
		AddObjective("	")
		AddObjective("tcrs0202.txt", "GREEN")
		AddObjective("SAVE", "DKGREY")
		x.ewlkstate = 3
		x.easnstate = 2 --stop assassin set 1
		--RemoveObject(x.escort[1])
		SetCurHealth(x.escort[1], GetMaxHealth(x.escort[1]))
		TCC.SetTeamNum(x.escort[1], 1)
		Stop(x.escort[1], 0)
		SetGroup(x.escort[1], 9)
		SetObjectiveOff(x.escort[1])
		x.spine = x.spine + 1
	end
	
	--START THE GEN FU PHASE
	if x.spine == 5 and x.fapcstate == 1 then
		x.audio1 = AudioMessage("tcrs0203.wav") --Engineer require cobalt 7 regulators. Gen Fu coming with convoy.
		x.spine = x.spine + 1
	end
	
	--BUILD AND SEND GENERAL FU
	if x.spine == 6 and IsAudioMessageDone(x.audio1) then
		ClearObjectives()
		AddObjective("tcrs0201.txt")
		AddObjective("	")
		AddObjective("tcrs0203.txt")
		x.escort[2] = BuildObject("kvapc", 4, "fpapc")
		Retreat(x.escort[2], x.ftec)
		SetObjectiveName(x.escort[2], "General Fu")
		SetObjectiveOn(x.escort[2])
		for index = 1, 2 do
			x.fally[index] = BuildObject("kvscoutnc", 4, "fpapc")
			SetSkill(x.fally[index], x.skillsetting)
			Defend2(x.fally[index], x.escort[2])
		end
		x.fapcstate = 2
		x.easnstate = 4 --start assassin set 2
		x.easntime = GetTime() + 12.0
		x.spine = x.spine + 1
	end
	
	--HAS GENERAL FU ARRIVED
	if x.spine == 7 and IsAlive(x.escort[2]) and IsAlive(x.ftec) and GetDistance(x.escort[2], x.ftec) < 20 then
		x.audio1 = AudioMessage("tcrs0205.wav") --SUCCEED - well done
		ClearObjectives()
		AddObjective("tcrs0204.txt", "GREEN")
		Stop(x.escort[2])
		x.fapcstate = 0
		x.MCAcheck = true
		x.spine = x.spine + 1
	end
	
	--SUCCEED MSSION	
	if x.spine == 8 and IsAudioMessageDone(x.audio1) then
		TCC.SucceedMission(GetTime(), "tcrs02w.des") --winner winner winner
		x.spine = x.spine + 1
	end
	----------END MAIN SPINE ----------
	
	--RUN INTRO CAMERA
	if x.camstate == 1 then
		CameraPath("pcam", x.camheight, 3150, x.ftec)
		x.camheight = x.camheight + 8
	end

	--CCA ASSASSINS WALKER AND FU
	if x.easnstate == 1 and x.easntime < GetTime() then
		for index = 1, 20 do
			if x.easnbuilt[index] == 0 then
				x.easntime = GetTime() + 13.0
				x.easnspn = 0
				if index > 15 then --so later can catch up a little
					x.easntime = GetTime() + 5.0
					x.easnspn = 3
				elseif index > 10 then
					x.easntime = GetTime() + 9.0
					x.easnspn = 2
				elseif index > 5 then 
					x.easntime = GetTime() + 11.0
					x.easnspn = 1
				end
				x.easn[index] = BuildObject("svtank", 5, "pasn1", x.easnspn) --"epg6")
				SetEjectRatio(x.easn[index], 0.0)
				SetSkill(x.easn[index], x.skillsetting)
				Attack(x.easn[index], x.escort[1])
				SetObjectiveName(x.easn[index], ("Assassin %d"):format(index))
				x.easnbuilt[index] = 1
				break
			end
		end
	elseif x.easnstate == 2 then --clear out easn after defector
		for index = 1, 20 do
			if IsAlive(x.easn[index]) then
				SetSkill(x.easn[index], x.skillsetting)
				Attack(x.easn[index], x.frcy)
			end
			x.easnbuilt[index] = 0 --reset for Fu
		end
		x.easnstate = 3
	elseif x.easnstate == 4 and x.easntime < GetTime() then
		for index = 1, 20 do
			if x.easnbuilt[index] == 0 then
				x.easntime = GetTime() + 12.0
				x.easnspn = 0
				if index > 15 then --so later can catch up a little
					x.easntime = GetTime() + 5.0
					x.easnspn = 3
				elseif index > 10 then
					x.easntime = GetTime() + 8.0
					x.easnspn = 2
				elseif index > 5 then
					x.easntime = GetTime() + 10.0
					x.easnspn = 1
				end
				x.easn[index] = BuildObject("svscout", 5, "pasn2", x.easnspn) --"epg1")
				SetEjectRatio(x.easn[index], 0.0)
				SetSkill(x.easn[index], x.skillsetting)
				Attack(x.easn[index], x.escort[2])
				SetObjectiveName(x.easn[index], ("Assassin %d"):format(index))
				x.easnbuilt[index] = 1
				break
			end
		end
	end
	
	--GENERAL FU ATTACKED AND COMPLAINING
	if not x.fuhurt and x.fapcstate > 0 and IsAlive(x.escort[2]) and GetCurHealth(x.escort[2]) < math.floor(GetMaxHealth(x.escort[2]) * 0.8) then
		AudioMessage("tcrs0204.wav") --This is Gen Fu. Under attack. blah blah
		x.fuhurt = true
	end
	
	--CCA GROUP KILL FIELD LAB
	if x.eatktime < GetTime() then
		for index = 1, 4 do --added so make sure eatk don't overlap
			if not IsAlive(x.eatk[index]) or x.eatk[index] == nil or (IsAlive(x.eatk[index]) and GetTeamNum(x.eatk[index]) == 1) then
				x.casualty = x.casualty + 1
			end
		end
		if x.casualty >= 3 then --1 less than total
			for index = 1, 10 do --random the spawn location
				x.randompick = math.floor(GetRandomFloat(1.0, 5.0))
			end
			x.randomlast = x.randompick
			for index = 1, 30 do --random the spawn location
				x.randomspawn = math.floor(GetRandomFloat(1.0, 9.0))
			end
			if x.randompick == 1 or x.randompick == 5 then
				x.eatk[1] = BuildObject("svtank", 5, GetPositionNear(("ep%d_1"):format(x.randomspawn), 0, 16, 32))
				x.eatk[2] = BuildObject("svrckt", 5, GetPositionNear(("ep%d_2"):format(x.randomspawn), 0, 16, 32))
				x.eatk[3] = BuildObject("svrckt", 5, GetPositionNear(("ep%d_3"):format(x.randomspawn), 0, 16, 32))
				x.eatk[4] = BuildObject("svtank", 5, GetPositionNear(("ep%d_4"):format(x.randomspawn), 0, 16, 32))
			elseif x.randompick == 2 or x.randompick == 6 then
				x.eatk[1] = BuildObject("svwalk", 5, GetPositionNear(("ep%d_1"):format(x.randomspawn), 0, 16, 32))
				x.eatk[2] = BuildObject("svwalk", 5, GetPositionNear(("ep%d_2"):format(x.randomspawn), 0, 16, 32))
				x.eatk[3] = BuildObject("svwalk", 5, GetPositionNear(("ep%d_3"):format(x.randomspawn), 0, 16, 32))
				x.eatk[4] = BuildObject("svwalk", 5, GetPositionNear(("ep%d_4"):format(x.randomspawn), 0, 16, 32))
			elseif x.randompick == 3 or x.randompick == 7 then
				x.eatk[1] = BuildObject("svmbike", 5, GetPositionNear(("ep%d_1"):format(x.randomspawn), 0, 16, 32))
				x.eatk[2] = BuildObject("svmisl", 5, GetPositionNear(("ep%d_2"):format(x.randomspawn), 0, 16, 32))
				x.eatk[3] = BuildObject("svtank", 5, GetPositionNear(("ep%d_3"):format(x.randomspawn), 0, 16, 32))
				x.eatk[4] = BuildObject("svrckt", 5, GetPositionNear(("ep%d_4"):format(x.randomspawn), 0, 16, 32))
			else --4 8 9
				x.eatk[1] = BuildObject("svartl", 5, GetPositionNear(("ep%d_1"):format(x.randomspawn), 0, 16, 32))
				x.eatk[2] = BuildObject("svartl", 5, GetPositionNear(("ep%d_2"):format(x.randomspawn), 0, 16, 32))
				x.eatk[3] = BuildObject("svartl", 5, GetPositionNear(("ep%d_3"):format(x.randomspawn), 0, 16, 32))
				x.eatk[4] = BuildObject("svartl", 5, GetPositionNear(("ep%d_4"):format(x.randomspawn), 0, 16, 32))
				for index = 1, 4 do --make sure art unique
					x.eart[index] = x.eatk[index] --simpler as new handle than set label
				end
				x.eatkartl = 1
			end
			x.eatktime = GetTime() + 60.0
			x.eatkwarnstate = 1
		end
		x.casualty = 0
		for index = 1, 4 do
			SetEjectRatio(x.eatk[index], 0.0)
			SetSkill(x.eatk[index], x.skillsetting)
      if x.eatkartl == 1 and IsAlive(x.eatk[index]) and GetTeamNum(x.eatk[index]) == 5 and IsOdf(x.eatk[index], "svartl:5") then
        Goto(x.eatk[index], x.ftec)  --attack order below
      elseif IsAlive(x.eatk[index]) and GetTeamNum(x.eatk[index]) == 5 then
        Attack(x.eatk[index], x.ftec)
      end
		end
	end
	
	--ATTACK WARNING
	if x.eatkwarnstate == 1 and IsAlive(x.ftec) then
		for index = 1, 4 do
			if IsAlive(x.ftec) and ((IsAlive(x.eatk[index]) and GetDistance(x.eatk[index], x.ftec) < 500) or (x.eatkartl == 1 and IsAlive(x.eart[index]) and GetDistance(x.eart[index], x.ftec) < 700)) then
				if x.eatkartl == 1 then
					for index2 = 1, 4 do --multiple art especially deadly at higher diff. so mark to get to them faster
						if IsAlive(x.eart[index]) and GetTeamNum(x.eart[index]) ~= 1 then
              SetObjectiveOn(x.eart[index2])
              Attack(x.eart[index], x.ftec)
            end
					end
				end
				AudioMessage("tcrs0202.wav") --Incoming CCA forces sir.
				x.eatkwarnstate = 0
				x.eatkartl = 0
				break
			end
		end
	end
	
	--CCA GROUP TURRET GENERIC --overkill for this one but doesn't hurt
	if x.eturtime < GetTime() then
		for index = 1, x.eturlength do
			if not IsAlive(x.etur[index]) and not x.eturallow[index] then
				x.eturcool[index] = GetTime() + 180.0
				x.eturallow[index] = true
			end
			if x.eturallow[index] and x.eturcool[index] < GetTime() then
				x.etur[index] = BuildObject("svturr", 5, ("epg%d"):format(index))
				SetEjectRatio(x.etur[index], 0.0)
				SetSkill(x.etur[index], x.skillsetting)
				SetObjectiveName(x.etur[index], ("Pak %d"):format(index))
				Goto(x.etur[index], ("eptur%d"):format(index))
				x.eturallow[index] = false
			end
		end	
		x.eturtime = GetTime() + 60.0
	end
	
	--WARCODE (non-AIP or temp AIP replacement) --special spawn locations
	if x.ewardeclare then
		for index = 1, x.ewartotal do	
			if x.ewartime[index] < GetTime() then 
				--SET WAVE NUMBER AND BUILD SIZE --INCREMENT EVENTSTATE
				if x.ewarstate[index] == 1 then
					x.ewarwave[index] = x.ewarwave[index] + 1
					if x.ewarwave[index] > x.ewarwavemax[index] then
						x.ewarwave[index] = x.ewarwavereset[index]
					end
					if x.ewarwave[index] == 1 then
						if index == 1 then
							x.ewarsize[index] = 2
						elseif index == 2 then
							x.ewarsize[index] = 2
						elseif index == 3 then
							x.ewarsize[index] = 2
						else
							x.ewarsize[index] = 2
						end
					elseif x.ewarwave[index] == 2 then
						if index == 1 then
							x.ewarsize[index] = 4
						elseif index == 2 then
							x.ewarsize[index] = 3
						elseif index == 3 then
							x.ewarsize[index] = 3
						else
							x.ewarsize[index] = 2
						end
					elseif x.ewarwave[index] == 3 then
						if index == 1 then
							x.ewarsize[index] = 6
						elseif index == 2 then
							x.ewarsize[index] = 5
						elseif index == 3 then
							x.ewarsize[index] = 4
						else
							x.ewarsize[index] = 3
						end
					elseif x.ewarwave[index] == 4 then
						if index == 1 then
							x.ewarsize[index] = 8
						elseif index == 2 then
							x.ewarsize[index] = 7
						elseif index == 3 then
							x.ewarsize[index] = 5
						else
							x.ewarsize[index] = 4
						end 
					else --x.ewarwave[index] == 5 then
						if index == 1 then
							x.ewarsize[index] = 10
						elseif index == 2 then
							x.ewarsize[index] = 9
						elseif index == 3 then
							x.ewarsize[index] = 6
						else
							x.ewarsize[index] = 5
						end
					end
					x.ewarstate[index] = x.ewarstate[index] + 1
					x.eventstate = x.eventstate + 1
					if x.eventstate == 9 then
						x.ewlkstate = 1
					elseif x.eventstate == 14 then
						x.fapcstate = 1
					end
				end
				
				--BUILD FORCE
				if x.ewarstate[index] == 2 then
					for index2 = 1, x.ewarsize[index] do
						while x.randompick == x.randomlast do --random the random
							x.randompick = math.floor(GetRandomFloat(1.0, 18.0)) --single 0-n inclusive, or double n1-nx inclusive
						end
						x.randomlast = x.randompick
						if x.randompick == 1 or x.randompick == 7 or x.randompick == 13 then
							x.ewarrior[index][index2] = BuildObject("svscout", 5, GetPositionNear("epg1", 0, 16, 32))
							if x.ewarwave[index] == 3 or x.ewarwave[index] == 4 then
								GiveWeapon(x.ewarrior[index][index2], "glasea_c")
							end
						elseif x.randompick == 2 or x.randompick == 8 or x.randompick == 14 then
							x.ewarrior[index][index2] = BuildObject("svmbike", 5, GetPositionNear("epg2", 0, 16, 32))
							if x.ewarwave[index] == 2 or x.ewarwave[index] == 4 then
								GiveWeapon(x.ewarrior[index][index2], "gstbva_c")
							end
						elseif x.randompick == 3 or x.randompick == 9 or x.randompick == 15 then
							x.ewarrior[index][index2] = BuildObject("svmisl", 5, GetPositionNear("epg3", 0, 16, 32))
							if x.ewarwave[index] == 3 or x.ewarwave[index] == 5 then
								GiveWeapon(x.ewarrior[index][index2], "gfafma_c")
							end
						elseif x.randompick == 4 or x.randompick == 10 or x.randompick == 16 then
							x.ewarrior[index][index2] = BuildObject("svtank", 5, GetPositionNear("epg4", 0, 16, 32))
							if x.ewarwave[index] == 4 or x.ewarwave[index] == 5 then
								GiveWeapon(x.ewarrior[index][index2], "gstbsa_c")
							end
						elseif x.randompick == 5 or x.randompick == 11 or x.randompick == 17 then
							x.ewarrior[index][index2] = BuildObject("svrckt", 5, GetPositionNear("epg5", 0, 16, 32))
							if x.ewarwave[index] == 3 or x.ewarwave[index] == 5 then
								GiveWeapon(x.ewarrior[index][index2], "gshdwa_a") --cluster rckt
							end
						else
							x.ewarrior[index][index2] = BuildObject("svwalk", 5, GetPositionNear("epg6", 0, 16, 32))
						end
						SetEjectRatio(x.ewarrior[index][index2], 0.0)
						SetSkill(x.ewarrior[index][index2], x.skillsetting)
						if index2 % 3 == 0 then
							SetSkill(x.ewarrior[index][index2], x.skillsetting+1)
						end
					end
					x.ewarabort[index] = GetTime() + 360.0 --here first in case stage goes wrong
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
						if IsAlive(x.ewarrior[index][index2]) and GetDistance(x.ewarrior[index][index2], ("stage%d"):format(x.ewarmeet[index])) < 100 and GetTeamNum(x.ewarrior[index][index2]) ~= 1 then
							x.ewarstate[index] = x.ewarstate[index] + 1
							break
						end
					end
				end
				
				--GIVE ATTACK ORDER
				if x.ewarstate[index] == 5 then
					for index2 = 1, x.ewarsize[index] do
						if IsAlive(x.ewarrior[index][index2]) then
							if index == 1 then
								if IsAlive(x.frcy) then
									x.ewartrgt[index] = x.frcy
								elseif IsAlive(x.ffac) then
									x.ewartrgt[index] = x.ffac
								elseif IsAlive(x.farm) then
									x.ewartrgt[index] = x.farm
								else
									x.ewartrgt[index] = x.player
								end
								--SetObjectiveName(x.ewarrior[index][index2], ("Recy Killer %d"):format(index2))
							elseif index == 2 then
								if IsAlive(x.ffac) then
									x.ewartrgt[index] = x.ffac
								elseif IsAlive(x.farm) then
									x.ewartrgt[index] = x.farm
								elseif IsAlive(x.frcy) then
									x.ewartrgt[index] = x.frcy
								else
									x.ewartrgt[index] = x.player
								end
								--SetObjectiveName(x.ewarrior[index][index2], ("Fact Killer %d"):format(index2))
							elseif index == 3 then
								if IsAlive(x.farm) then
									x.ewartrgt[index] = x.farm
								elseif IsAlive(x.ffac) then
									x.ewartrgt[index] = x.ffac
								elseif IsAlive(x.frcy) then
									x.ewartrgt[index] = x.frcy
								else
									x.ewartrgt[index] = x.player
								end
								--SetObjectiveName(x.ewarrior[index][index2], ("Armo Killer %d"):format(index2))
							else --safety call --shouldn't ever run
								x.ewartrgt[index] = x.player
								--SetObjectiveName(x.ewarrior[index][index2], ("Mass Assassin %d"):format(index2))
							end
							Attack(x.ewarrior[index][index2], x.ewartrgt[index])
							x.ewarabort[index] = x.ewartime[index] + 420.0
						end
					end
					x.ewarstate[index] = x.ewarstate[index] + 1
				end
				
				--CHECK CASUALTY AND RESET
				if x.ewarstate[index] == 6 then
					for index2 = 1, x.ewarsize[index] do
						if not IsAlive(x.ewarrior[index][index2]) or (IsAlive(x.ewarrior[index][index2]) and GetTeamNum(x.ewarrior[index][index2]) == 1) then
							x.casualty = x.casualty + 1
						end
					end
					if x.casualty >= math.floor(x.ewarsize[index] * 0.8) then
						x.ewarabort[index] = 99999.9
						x.ewartime[index] = GetTime() + x.ewartimecool[index] + x.ewartimeadd[index]
						if x.ewarwave[index] == 5 then --extra time after last wave to "ease up"
							x.ewartime[index] = GetTime() + x.ewartimecool[index] + x.ewartimeadd[index] + 120.0
						end
						x.ewarstate[index] = 1 --RESET
					end
					x.casualty = 0
					
					if not IsAlive(x.ewartrgt[index]) then --if orig target gone, then find new one
						if IsAlive(x.frcy) then
							x.ewartrgt[index] = x.frcy
						elseif IsAlive(x.ffac) then
							x.ewartrgt[index] = x.ffac
						elseif IsAlive(x.farm) then
							x.ewartrgt[index] = x.farm
						else
							x.ewartrgt[index] = x.player
						end
						for index2 = 1, x.ewarsize[index] do
							if IsAlive(x.ewarrior[index][index2]) and not IsPlayer(x.ewarrior[index][index2]) then
								Attack(x.ewarrior[index][index2], x.ewartrgt[index])
							end
						end
					end
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
	
	--CHECK STATUS OF MCA ----------------------------------
	if not x.MCAcheck then
		if not IsAlive(x.ftec) then --lost Field Lab
			x.audio6 = AudioMessage("tcrs0206.wav") --5 FAIL - generic
			ClearObjectives()
			AddObjective("tcrs0205.txt", "RED")
			x.failtype = 1
			x.spine = 666
			x.MCAcheck = true
		end
		
		if x.ewlkstate == 2 and not IsAlive(x.escort[1]) then --golem lost
			x.audio6 = AudioMessage("tcrs0206.wav") --5 FAIL - generic
			ClearObjectives()
			AddObjective("tcrs0206.txt", "RED")
			x.failtype = 2
			x.spine = 666
			x.MCAcheck = true
		end
		
		if x.fapcstate == 2 and not IsAlive(x.escort[2]) then --Gen. Fu killed
			x.audio6 = AudioMessage("tcrs0206.wav") --5 FAIL - generic
			ClearObjectives()
			AddObjective("tcrs0207.txt", "RED")
			x.failtype = 3
			x.spine = 666
			x.MCAcheck = true
		end
		
		if not IsAlive(x.frcy) then --recycler dead
			x.audio6 = AudioMessage("tcrs0206.wav") --5 FAIL - generic
			ClearObjectives()
			AddObjective("tcrs0208.txt", "RED") --You lost your Recycler.	MISSION FAILED!
			x.failtype = 4
			x.spine = 666
			x.MCAcheck = true
		end
	end
	
	--LET AUDIO6 PLAY BEFORE ENDING
	if x.failtype == 1 and IsAudioMessageDone(x.audio6) then
		TCC.FailMission(GetTime(), "tcrs02f1.des") --LOSER LOSER LOSER
	elseif x.failtype == 2 and IsAudioMessageDone(x.audio6) then
		TCC.FailMission(GetTime(), "tcrs02f2.des") --LOSER LOSER LOSER
	elseif x.failtype == 3 and IsAudioMessageDone(x.audio6) then
		TCC.FailMission(GetTime(), "tcrs02f3.des") --LOSER LOSER LOSER
	elseif x.failtype == 4 and IsAudioMessageDone(x.audio6) then	
		TCC.FailMission(GetTime(), "tcrs02f4.des") --LOSER LOSER LOSER
	end
end
--[[END OF SCRIPT]]