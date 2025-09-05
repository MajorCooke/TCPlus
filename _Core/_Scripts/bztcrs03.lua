--bztcrs03 - Battlezone Total Command - Red Storm - 3/8 - RESCUE ME
assert(load(assert(LoadFile("_requirefix.lua")),"_requirefix.lua"))();
TCC = require("TC_Core")
MisnNum = 16;
--DECLARE variables --f-friend, e-enemy, atk-attack, rcy-recycler, etc..., 
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
	easy = 0, 
	medium = 1, 
	hard = 2, --tried 1-3, in 185, 3 didn't seem to make any difference, 
	randompick = 0, 
	randomlast = 0, 
	casualty = 0, 
	pos = {},	
	audio1 = nil, 
	audio6 = nil, 
	fnav = {}, 
	fally = {}, 
	pilot = nil,
	fartfixinphase = 0, --artillery
	fart = {}, 
	farthealed = {},
	fartonline = {}, 
	fartready = {}, 
	fartcount = 0,
	farttime = 99999.9, 
	fartdone = 0, 
	failstate = 0, 
	fustate = 0, --Fu stuff
	fufound = 0, 
	fupick = 0, 
	egun = {}, 
	eapc = {}, --EAPC stuff
	eapcbuilt = false, 
	eapcreturn = {}, 
	eapcreturntime = 99999.9, 
	eapcout = {}, 
	eapcwarn = {}, 
	eatk = {}, 
	egun = {}, 
	etur = {}, 
	easn = {}, --assassins
	easnbuilt = false, 
	easntime = 99999.9, 
	epattime = 99999.9, --epatrols
	epatlength = 6, 
	epat = {}, 
	epatcool = {}, 
	epatallow = {},
	randomfloat = 99999.9, --random vars
	LAST = true
}
--Paths: fpnav1, fpnav2, fp1-10, epapc1-6, epath1-6, epout1-6, ppatrol1-6, epasnalt	//	Obj: egun1-6, dummy: etur1-6, fart1-6

function InitialSetup()
	SetAutoGroupUnits(true)
	
	local odfpreload = {
		"svscout", "svmbike", "svmisl", "svtank", "svrckt", "svturr", "svapc", "svapcrs03",
		"kvscout", "kvmbike", "kvmisl", "kvtank", "kvrckt", "kvhtnk", "kvserv", "kvartl", "apcamrk"
	}
	for k,v in pairs(odfpreload) do
		PreloadODF(v)
	end

	x.mytank = GetHandle("mytank")
	for index = 1, 6 do
		x.fart[index] = GetHandle(("fart%d"):format(index))
		x.etur[index] = GetHandle(("etur%d"):format(index))
		x.egun[index] = GetHandle(("egun%d"):format(index))
	end
	Ally(1, 4) --4 Artil
	Ally(4, 1)
	Ally(1, 2) --2 apcs - so friendlies focus on other cca
	Ally(5, 2)
	Ally(2, 1)
	Ally(2, 5)
	--not 4 and 2, so 4 will fire on 2	
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
	TCC.Update()
	
	--SETUP MISSION BASICS
	if x.spine == 0 then
		x.audio1 = AudioMessage("tcrs0301b.wav") --Get artil units working. Factory removed.
		x.pos = GetTransform(x.mytank)
		RemoveObject(x.mytank)
		x.mytank = BuildObject("kvserv", 1, x.pos)
		SetAsUser(x.mytank, 1)
		RemoveObject(x.player)
		x.player = GetPlayerHandle()
		for index = 1, 6 do --set artillery
			x.farthealed[index] = 0 --init these tables
			x.fartonline[index] = 0
			x.fartready[index] = 0
			x.eapcwarn[index] = 0
			x.eapcreturn[index] = 0
			x.eapcout[index] = 0
			x.pos = GetTransform(x.fart[index])
			RemoveObject(x.fart[index])
			x.fart[index] = BuildObject("kvartl", 0, x.pos)
			SetSkill(x.fart[index], 3) --x.skillsetting)
			SetCurHealth(x.fart[index], math.floor(GetMaxHealth(x.fart[index]) * 0.6))
			SetCurAmmo(x.fart[index], math.floor(GetMaxAmmo(x.fart[index]) * 0.6))
			SetObjectiveName(x.fart[index], ("OFFLINE Archer %d"):format(index))
			SetObjectiveOn(x.fart[index])
			SetSkill(x.egun[index], x.skillsetting)
			KillPilot(x.fart[index])
			x.pos = GetTransform(x.etur[index]) --set turrets
			RemoveObject(x.etur[index])
			x.etur[index] = BuildObject("svturr", 5, x.pos) 
			SetEjectRatio(x.etur[index], 0.0)
			SetSkill(x.etur[index], x.skillsetting)
		end
		x.epattime = GetTime() --init epat
		for index = 1, x.epatlength do
			x.epatcool[index] = GetTime()
			x.epatallow[index] = true
		end
		x.fnav[1] = BuildObject("apcamrk", 1, "fpnav1")
		SetObjectiveName(x.fnav[1], "Drop Point")
		x.fnav[2] = BuildObject("apcamrk", 1, "fpnav2")
		SetObjectiveName(x.fnav[2], "CCA base")
		AddObjective("tcrs0301.txt")
    x.spine = x.spine + 1
  end
  
  if x.spine == 1 and IsAudioMessageDone(x.audio1) then
		StartCockpitTimer(600, 240, 120) --RUN THE CLOCK
		x.farttime = GetTime() + 602.0 --TIME LIMIT FOR ARTIL
		x.spine = x.spine + 1
	end
	
	--HAS PLAYER READIED ALL ARTILLERY
	if x.spine == 2 then
		for index = 1, 6 do
			if x.fartready[index] == 0 then
				if IsAround(x.fart[index]) 
				and (GetCurHealth(x.fart[index]) >= math.floor(GetMaxHealth(x.fart[index]) * 0.9)) 
				and (GetCurAmmo(x.fart[index]) >= math.floor(GetMaxAmmo(x.fart[index]) * 0.9)) then 
					x.farthealed[index] = 1
				end
				--REMOVED NEED FOR PLAYER TO ENTER AND EXIT ARTILLERY B/C WAS ANNOYING AND DIDN'T ADD TO GAMEPLAY
				if x.fartonline[index] == 0 and x.farthealed[index] == 1 then
					AudioMessage("tcrs0302.wav") --CPU - automatic fire procedures initiated
					x.fartonline[index] = 1
				end
				
				if x.fartonline[index] == 1 and x.fartready[index] == 0 and not HasPilot(x.fart[index]) then
					AddPilotByHandle(x.fart[index])
					TCC.SetTeamNum(x.fart[index], 4)
					SetSkill(x.fart[index], x.skillsetting)
					SetObjectiveOff(x.fart[index])
					SetObjectiveName(x.fart[index], ("Archer %d"):format(index))
					x.fartready[index] = 1
				end
			end
			
			if x.fartready[index] == 1 then
				x.fartcount = x.fartcount + 1
			end
		end
			
		if x.fartcount == 6 then
			x.failstate = 2
			ClearObjectives()
			AddObjective("tcrs0302.txt", "GREEN")
			AddObjective("	")
			AddObjective("tcrs0303.txt")
			if not IsAlive(x.fnav[1]) then
				x.fnav[1] = BuildObject("apcamr", 1, "fpnav1")
			end
			SetObjectiveOn(x.fnav[1])
			SetObjectiveName(x.fnav[1], "Rally Pt.")
			x.farttime = 99999.9
			StopCockpitTimer()
			HideCockpitTimer()
			x.fartdone = 1
			for index = 1, 6 do --create and init multidim array - filled later
				x.eatk[index] = {} --"rows"
				for index2 = 1, 6 do
					x.eatk[index][index2] = nil --"columns", init value (handle in this case)
				end
			end
			x.spine = x.spine + 1 --INCREMENT HERE
		end
		x.fartcount = 0
	end
 
	--BUILD EAPC AND ESCORTS, PICK AND BUILD FU, SEND OUT APC
	if x.spine == 3 and GetDistance(x.player, "fpnav1") < 2000 then
		for index = 1, 6 do
			x.eapc[index] = BuildObject("svapc", 2, ("epapc%d"):format(index))
			SetObjectiveName(x.eapc[index], ("Revmir %d"):format(index))
			SetObjectiveOn(x.eapc[index])
			x.eatk[index][1] = BuildObject("svscout", 5, ("epapc%d"):format(index))
			x.eatk[index][2] = BuildObject("svscout", 5, ("epapc%d"):format(index))
			x.eatk[index][3] = BuildObject("svmbike", 5, ("epapc%d"):format(index))
			x.eatk[index][4] = BuildObject("svmisl", 5, ("epapc%d"):format(index))
			x.eatk[index][5] = BuildObject("svtank", 5, ("epapc%d"):format(index))
			x.eatk[index][6] = BuildObject("svrckt", 5, ("epapc%d"):format(index))
			for index2 = 1, 6 do
				SetEjectRatio(x.eatk[index][index2], 0.0)
				SetSkill(x.eatk[index][index2], x.skillsetting)
				Defend2(x.eatk[index][index2], x.eapc[index])
			end
		end
		x.eapcbuilt = true
		for index = 1, 31 do
			x.randomfloat = math.floor(GetRandomFloat(1.0, 21.0))
		end
		if x.randomfloat == 1 then
			x.fupick = 1
		elseif x.randomfloat == 2 then
			x.fupick = 2
		elseif x.randomfloat == 3 or x.randomfloat == 7 or x.randomfloat == 11 then
			x.fupick = 3
		elseif x.randomfloat == 4 or x.randomfloat == 8 or x.randomfloat == 12 or x.randomfloat == 15 then
			x.fupick = 4
		elseif x.randomfloat == 5 or x.randomfloat == 9 or x.randomfloat == 13 or x.randomfloat == 16 or x.randomfloat == 18 then
			x.fupick = 5
		elseif x.randomfloat == 6 or x.randomfloat == 10 or x.randomfloat == 14 or x.randomfloat == 17 or x.randomfloat == 19 or x.randomfloat == 20 or x.randomfloat == 21 then
			x.fupick = 6
		end
		x.pos = GetTransform(x.eapc[x.fupick]) --get fu
		RemoveObject(x.eapc[x.fupick])
		x.eapc[x.fupick] = BuildObject("svapcrs03", 2, x.pos) --special inf card and wider snipe radius
		SetEjectRatio(x.eapc[x.fupick], 0.0)
		SetSkill(x.eapc[x.fupick], x.skillsetting)
		SetObjectiveName(x.eapc[x.fupick], ("Revmir %d"):format(x.fupick))
		SetObjectiveOn(x.eapc[x.fupick])
		--SetObjectiveName(x.eapc[x.fupick], "this be fu") --TESTING ONLY
		x.fustate = 1
		for index = 1, 6 do
			Defend2(x.eatk[x.fupick][index], x.eapc[x.fupick])
		end
		for index = 1, 6 do
			Retreat(x.eapc[index], ("epath%d"):format(index))
		end
		x.eapcreturntime = GetTime() + 60.0
		AudioMessage("alertpulse.wav")
		AddObjective("\nTransports have entered the battlezone.")
		x.spine = x.spine + 1
	end
	
	--INCREMENT FU FOR POTENTIAL RTB
	if x.spine == 4 and GetDistance(x.eapc[x.fupick], "fpnav2") > 200 then
		x.fustate = 2
		x.spine = x.spine + 1
	end
	
	--PLAYER RETURNED TO DROPZONE, GIVE FALLY
	if x.spine == 5 and GetDistance(x.player, "fpnav1") < 150 then
		ClearObjectives()
		AddObjective("tcrs0304.txt", "ALLYBLUE")
		AddObjective("	")
		AddObjective("tcrs0305.txt")
		SetObjectiveOff(x.fnav[1])
		x.fally[1] = BuildObject("kvscout", 1, "fp1")
		x.fally[2] = BuildObject("kvmbike", 1, "fp2")
		x.fally[3] = BuildObject("kvmisl", 1, "fp3")
		x.fally[4] = BuildObject("kvtank", 1, "fp4")
		x.fally[5] = BuildObject("kvrckt", 1, "fp5")
		x.fally[6] = BuildObject("kvscout", 1, "fp6")
		if x.skillsetting >= x.medium then
			x.fally[7] = BuildObject("kvmbike", 1, "fp7")
			x.fally[8] = BuildObject("kvmisl", 1, "fp8")
		end
		if x.skillsetting >= x.hard then
			x.fally[9] = BuildObject("kvtank", 1, "fp9")
			x.fally[10] = BuildObject("kvrckt", 1, "fp10")
		end
		for index = 1, 10 do
			SetEjectRatio(x.fally[index], 0.0)
			SetSkill(x.fally[index], x.skillsetting)
			SetGroup(x.fally[index], 0)
			Goto(x.fally[index], ("fp%d"):format(index), 0)
		end
		x.spine = x.spine + 1
	end
	
	--PLAYER RECAPTURED FU APC
	if x.spine == 6 and IsOdf(x.player, "svapcrs03") then --special inf card and wider snipe radius
		x.fufound = 1 --*IF* player snipes and occupies Fu w/out 1st IDing him
		AudioMessage("tcrs0306.wav") --Fu - At last, now get me back to base this instant
		ClearObjectives()
		AddObjective("tcrs0305.txt", "GREEN")
		AddObjective("	")
		AddObjective("tcrs0306.txt")
		if not IsAlive(x.fnav[1]) then
			x.fnav[1] = BuildObject("apcamr", 1, "fpnav1")
		end
		SetObjectiveName(x.fnav[1], "Return Fu")
		SetObjectiveOn(x.fnav[1])
		TCC.SetTeamNum(x.eapc[x.fupick], 1)
		if x.fupick == 1 then
			x.easntime = GetTime() + 6.0 --8.0
		elseif x.fupick == 2 then
			x.easntime = GetTime() + 5.0 --7.0
		elseif x.fupick == 3 then
			x.easntime = GetTime() + 4.0 --6.0
		elseif x.fupick == 4 then
			x.easntime = GetTime() + 3.0 --5.0
		elseif x.fupick == 5 then
			x.easntime = GetTime() + 2.0 --4.0
		elseif x.fupick == 6 then
			x.easntime = GetTime() --+ 3.0
		end
		x.spine = x.spine + 1
	end
	
	--FUAPC AT DROPZONE
	if x.spine == 7 and IsAlive(x.eapc[x.fupick]) and GetDistance(x.eapc[x.fupick], "fpnav1") < 100 then
		SetObjectiveOff(x.fnav[1])
		ClearObjectives()
		AddObjective("tcrs0307.txt", "GREEN")
		x.audio1 = AudioMessage("tcrs0310.wav") --modified from 0206
		if GetCurHealth(x.eapc[x.fupick]) < math.floor(GetMaxHealth(x.eapc[x.fupick]) * 0.3) then
			SetCurHealth(x.eapc[x.fupick], math.floor(GetMaxHealth(x.eapc[x.fupick]) * 0.3))
		end
		x.fally[1] = BuildObject("kvhtnk", 1, "fp1")
		SetGroup(x.fally[1], 4)
		Defend2(x.fally[1], x.player, 0)
		x.fally[5] = BuildObject("kvhtnk", 1, "fp9")
		SetGroup(x.fally[5], 4)
		Defend2(x.fally[5], x.player, 0)
		x.spine = x.spine + 1
	end
	
	--SUCCEED MSSION	
	if x.spine == 8 and IsAround(x.eapc[x.fupick]) and IsAudioMessageDone(x.audio1) then
		TCC.SucceedMission(GetTime() + 2.0, "tcrs03w.des") --winner winner winner
		x.spine = x.spine + 1
	end
	----------END MAIN SPINE ----------
	
	--HIGHLIGHT FU WHEN FOUND, TURN OFF OTHERS
	if (x.fufound == 0 and IsInfo("svapcrs03")) or x.fufound == 1 then
		for index = 1, 6 do
			SetObjectiveOff(x.eapc[index])
		end
		if x.fufound == 0 then
			AudioMessage("emdotcox.wav")
			SetObjectiveName(x.eapc[x.fupick], "General Fu")
			SetObjectiveOn(x.eapc[x.fupick])
		end
		x.fufound = 2
	end
	
	--CCA APC REACHED ARTIL
	if x.eapcbuilt then
		for index = 1, 6 do
			if x.eapcwarn[index] == 0 and IsAlive(x.fart[index]) and GetDistance(x.eapc[index], x.fart[index]) < 300 then
				if index == 1 then
					AudioMessage("tcrs0303.wav") --CPU - Eastern artillery commencing bombardment.
					FireAt(x.fart[index], x.eapc[index], false)
				elseif index == 2 then
					AudioMessage("tcrs0303.wav") --CPU - Eastern artillery commencing bombardment.
					FireAt(x.fart[index], x.eapc[index], false)
				elseif index == 3 then
					AudioMessage("tcrs0304.wav") --CPU - Northern artillery commencing bombardment.
					FireAt(x.fart[index], x.eapc[index], false)
				elseif index == 4 then
					AudioMessage("tcrs0304.wav") --CPU - Northern artillery commencing bombardment.
					FireAt(x.fart[index], x.eapc[index], false)
				elseif index == 5 then
					AudioMessage("tcrs0305.wav") --CPU - Western artillery commencing bombardment.
					FireAt(x.fart[index], x.eapc[index], false)
				elseif index == 6 then
					AudioMessage("tcrs0305.wav") --CPU - Western artillery commencing bombardment.
					FireAt(x.fart[index], x.eapc[index], false)
				end
				x.eapcwarn[index] = 1
			end
		end
	end
	
	--CCA APC RTB IF TOO DAMAGED, REMOVE IF NEEDED
	if x.eapcbuilt and x.eapcreturntime < GetTime() then
		for index = 1, 6 do
			if x.eapcreturn[index] == 0 and IsAround(x.eapc[index])
			and (GetCurHealth(x.eapc[index]) < math.floor(GetMaxHealth(x.eapc[index]) * 0.7)) 
			and (GetDistance(x.eapc[index], ("epout%d"):format(index)) > 200) 
			and x.eapc[index] ~= x.player then
				Goto(x.eapc[index], "fpnav2")
				x.eapcreturn[index] = 1
			elseif x.eapcreturn[index] == 1 and IsAround(x.eapc[index]) 
			and GetDistance(x.eapc[index], "fpnav2") < 64 and x.eapc[index] ~= x.player then
				RemoveObject(x.eapc[index])
				for index2 = 1, 6 do
					RemoveObject(x.eatk[index][index2])
				end
				x.eapcreturn[index] = 2
			end
		end
	end
	
	--CCA APC ESCAPED, SO REMOVE
	if x.eapcbuilt then
		for index = 1, 6 do
			if x.eapcout[index] == 0 and IsAround(x.eapc[index]) and (GetDistance(x.eapc[index], ("epout%d"):format(index)) < 32) then
				RemoveObject(x.eapc[index])
				for index2 = 1, 6 do
					RemoveObject(x.eatk[index][index2])
				end
				x.eapcout[index] = 1
			end
		end
	end
	
	--CCA ASSASSIN
	if x.easntime < GetTime() then
		if not x.easnbuilt then
			for index = 1, 6 do
        if index == 1 or index == 2 then
          x.easn[index] = BuildObject("svscout", 5, "epasnalt")
        end
				x.easn[index] = BuildObject("svscout", 5, ("epapc%d"):format(index))
				SetEjectRatio(x.easn[index], 0.0)
				SetSkill(x.easn[index], x.skillsetting)
			end
			x.epattime = 99999.9
			x.easnbuilt = true
		end
		for index = 1, 6 do
			Attack(x.easn[index], x.player) --allow player swap Fu w/ ally and send him on his way
			if IsAlive(x.epat[index]) then
				Attack(x.epat[index], x.player)
			end
			if IsAlive(x.epat[index]) then
				Attack(x.eatk[x.fupick][index], x.player)
			end
		end
		x.easntime = GetTime() + 30.0
	end
	
	--CCA GROUP SCOUT PATROLS
	if x.epattime < GetTime() then
		for index = 1, 6 do
			if not IsAlive(x.epat[index]) and not x.epatallow[index] then
				x.epatcool[index] = GetTime() + 20.0
				x.epatallow[index] = true
			end
			if x.epatallow[index] and x.epatcool[index] < GetTime() then
				while x.randompick == x.randomlast do --random the random
					x.randompick = math.floor(GetRandomFloat(1.0, 15.0))
				end
				x.randomlast = x.randompick
				if x.randompick == 1 or x.randompick == 6 or x.randompick == 11 then
					x.epat[index] = BuildObject("svscout", 5, ("epapc%d"):format(index))
				elseif x.randompick == 2 or x.randompick == 7 or x.randompick == 12 then
					x.epat[index] = BuildObject("svmbike", 5, ("epapc%d"):format(index))
				elseif x.randompick == 3 or x.randompick == 8 or x.randompick == 13 then
					x.epat[index] = BuildObject("svmisl", 5, ("epapc%d"):format(index))
				elseif x.randompick == 4 or x.randompick == 9 or x.randompick == 14 then
					x.epat[index] = BuildObject("svtank", 5, ("epapc%d"):format(index))
				else
					x.epat[index] = BuildObject("svrckt", 5, ("epapc%d"):format(index))
				end
				SetEjectRatio(x.epat[index], 0.0)
				SetSkill(x.epat[index], x.skillsetting)
				--SetObjectiveName(x.epat[index], ("Patrol %d"):format(index))
				Patrol(x.epat[index], ("ppatrol%d"):format(index))
				x.epatallow[index] = false
			end
		end
		x.epattime = GetTime() + 20.0
	end
 
	--CHECK STATUS OF MCA ----------------------------------
	if not x.MCAcheck then
		if x.failstate == 0 and x.fartcount < 6 then --destroyed an artil before all repaired
			for index = 1, 6 do
				if not IsAround(x.fart[index]) then
					x.failstate = 1
					break
				end
			end
		end
		
		if x.farttime < GetTime() or x.failstate == 1 then --fail to fix artil on time
			x.audio6 = AudioMessage("tcrs0307.wav") --FAIL – fail to fix artillery
			ClearObjectives()
			AddObjective("tcrs0308.txt", "RED")
			TCC.FailMission(GetTime() + 15.0, "tcrs03f1.des") --LOSER LOSER LOSER
			x.spine = 666
			x.MCAcheck = true
		end
		
		if x.fustate > 0 and x.eapcout[x.fupick] == 0 and x.eapcreturn[x.fupick] < 2 and not IsAround(x.eapc[x.fupick]) then --fu killed
			x.audio6 = AudioMessage("tcrs0308.wav") --FAIL - gen fu apc killed
			ClearObjectives()
			AddObjective("tcrs0309.txt", "RED")
			TCC.FailMission(GetTime() + 12.0, "tcrs03f2.des") --LOSER LOSER LOSER --orig f2 content swapped with f3 content
			x.spine = 666
			x.MCAcheck = true
		end
		
		if x.eapcout[x.fupick] == 1 then
			x.audio6 = AudioMessage("tcrs0309.wav") --FAIL – fu apc escaped
			ClearObjectives()
			AddObjective("tcrs0310.txt", "RED")
			TCC.FailMission(GetTime() + 7.0, "tcrs03f3.des") --LOSER LOSER LOSER
			x.spine = 666
			x.MCAcheck = true
		end
		
		if x.fustate == 2 and x.eapcreturn[x.fupick] == 2 then
			x.audio6 = AudioMessage("tcrs0309.wav") --FAIL –-fu apc retreated back to CCA base
			ClearObjectives()
			AddObjective("tcrs0311.txt", "RED")
			TCC.FailMission(GetTime() + 7.0, "tcrs03f4.des") --LOSER LOSER LOSER
			x.spine = 666
			x.MCAcheck = true
		end
		--FYI, from orig, "tcrs03f5.des" --factory destroyed, NA since no factory
	end
end
--[[END OF SCRIPT]]