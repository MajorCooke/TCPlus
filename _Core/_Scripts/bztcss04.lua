--bztcss04 - Battlezone Total Command - Stars and Stripes - 4/17 - AN UNEXPECTED CONNECTION
assert(load(assert(LoadFile("_requirefix.lua")),"_requirefix.lua"))();
TCC = require("TC_Core")
MisnNum = 6;
--DECLARE variables --p-path, f-friend, e-enemy, atk-attack, rcy-recycler
local index = 0
local index2 = 0
local indexadd = 0
local x = {
	FIRST =	true, 
	MCAcheck = false, 
	player = nil, 
	mytank = nil, 
	skillsetting = 0,
	easy = 0, 
	medium = 1, 
	hard = 2,	
	audio1 = nil, 
	audioercy = nil, 
	pos = {},
	spine = 0, 
	casualty = 0, 
	randompick = 0, 
	randomlast = 0, 
	--for some dumb reason I rearranged by type rather than group
	give1 = false, 
	lemnospresent = false, 
	eldridgebuilt = false, 
	ekillfrcyreset = false, 
	ekillfrcybuild = false, 
	ekillffacreset = false, 
	ekillffacbuild = false, 
	elemreset = false, 
	elembuild = false, 
	egrendelreset = false, 
	egrendelbuild = false, 
	egrendellooker = false, 
	ekillassistreset = false, 
	ekillassistbuild = false, 
	escv = {}, --scav stuff
	escvlength = 2, 
	wreckbank = false, --have 2
	escvbuildtime = {}, 
	escvstate = {}, 
	waittime = 99999.9, 
	warnordertime = 99999.9, 
	order1time = 99999.9, 
	eturtime = 99999.9, 
	elemtime = 99999.9, 
	elemresendtime = 99999.9,	
	epattime = 99999.9, --patrol
	epatlength = 6, --6 paths
	epat = {},
	epatcool = {}, 
	epatallow = {}, 
	epooltime = 99999.9, --pool patrol
	epoollength = 6, --3 at 2 pools
	epool = {},
	epoolcool = {}, 
	epoolallow = {}, 
	ekillfrcytime = 99999.9, 
	ekillfrcyresendtime = 99999.9, 
	ekillffactime = 99999.9, 
	ekillffacresendtime = 99999.9, 
	eldtime = 99999.9, 
	egrendeltime = 99999.9, 
	egrendelresendtime = 99999.9, 
	ekillassisttime = 99999.9, 
	ekillassistresendtime = 99999.9, 
  efacreset = false, 
	efactime = 99999.9, 
	epattime = 99999.9, 
  ercystate = 0, 
  ercytime = 99999.9, 
	egrendellookertime = 99999.9, 
	frcy = nil, 
	ffac = nil, 
	farm = nil, 
	fnav1 = nil,
	lemnos = nil, 
	lemnosbldg = nil, 
	cyclops = nil, 
	eblt = {}, 
	eldridge = nil, 
	eldscort = {}, 
	etur = {}, 
	ekillfrcy = {}, 
	ekillffac = {}, 
	elem = {}, 
	egrendel = {}, 
	ekillassist = {}, 
	epat = {}, 
	ebltlength = 25, 
	eturlength = 10, 
	ekillfrcylength = 6, 
	ekillffaclength = 4, 
	elemlength = 28, 
	elemwavecount = 0, 
	elemwavemax = 2, 
	egrendellength = 10, 
	ekillassistlength = 6, 
	eldscortlength = 4, 
	fartlength = 10, --fart killers
	fart = {}, 
	ekillarttime = 99999.9,
	ekillartlength = 4, 
	ekillart = {}, 
	ekillartcool = {}, 
	ekillartallow = {}, 
	ekillarttarget = nil, 
	ekillartmarch = false, 
	LAST = true
}
--PATHS: pmytank, fprcy, fparm, fpnav, fpwest, fpeast, epgrcy, epgfac, epblt0-24, fpeld, eptur0-15, pnavne, pnavse, pnavnw, ppool1-2, eplem, eplemtur0-7, eppatrol0-5, eplemrally1-3, ercyspn, efacspn, lemspn, epgrn1-2, eppwr1-4

function InitialSetup()
	SetAutoGroupUnits(true)
	
	local odfpreload = {
		"svrecy", "svfact", "sbgtow", "sbpgen2", "svscout", "svmbike", "svtank", "svrckt", 
		"avtank", "avrecyss04", "avarmoss04", "avfactss04", "olybolt2", "yvcycl", "apcamra"
	}
	for k,v in pairs(odfpreload) do
		PreloadODF(v)
	end
	
	x.ercy = GetHandle("ercy")
	x.efac = GetHandle("efac")
	x.lemnos = GetHandle("lemnos")
	Ally(1, 2)
	Ally(2, 1) --x.eldridge group
	SetTeamColor(2, 50, 150, 255) --x.eldridge 6th Plt	
	SetColorFade(6.0, 0.5, "BLACK")
	TCC.Init()
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

function Start()
	TCC.Start();
end

function AddObject(h)  
	if not IsAlive(x.farm) and (IsOdf(h, "avarmoss04:1") or IsOdf(h, "abarmoss04")) then --new factory?
		x.farm = h
	end
	if not IsAlive(x.ffac) and (IsOdf(h, "avfactss04:1") or IsOdf(h, "abfactss04")) then --new armory?
		x.ffac = h
	end
	
	for indexadd = 1, x.fartlength do --new artillery? 
		if (not IsAlive(x.fart[indexadd]) or x.fart[indexadd] == nil) and IsOdf(h, "avartlss04:1") then
			x.fart[indexadd] = h
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

	--START THE MISSION BASICS
	if x.spine == 0 then
		x.mytank = BuildObject("avtank", 1, "pmytank")
		x.frcy = BuildObject("avrecyss04", 1, "fprcy")
		x.farm = BuildObject("avarmoss04", 1, "fparm")
		SetAsUser(x.mytank, 1)
		RemoveObject(x.player)
		x.player = GetPlayerHandle()
		SetSkill(x.frcy, x.skillsetting)
		SetGroup(x.frcy,0)
		SetGroup(x.farm,1)
		SetScrap(1, 40)
		SetScrap(5, 40)
		x.audio1 = AudioMessage("tcss0401.wav") --22 INTRO - Struc inside volc. Inspect area. Secure volc perix.
		x.fnav1 = BuildObject("apcamra", 1, "fpnav")
		SetObjectiveName(x.fnav1, "Volcano")
		x.fnav1 = BuildObject("apcamra", 1, "fpwest")
		SetObjectiveName(x.fnav1, "DZ Alpha")
		x.fnav1 = BuildObject("apcamra", 1, "fpeast")
		SetObjectiveName(x.fnav1, "DZ Bravo")
		for index = 1, x.ebltlength do
			x.eblt[index] = BuildObject("olybolt2", 5, ("epblt%d"):format(index))
		end
		x.fnav1 = BuildObject("olybolt2", 5, "epgrn1")
		x.fnav1 = BuildObject("olybolt2", 5, "epgrn2")
		x.cyclops = BuildObject("yvcycl", 0, "pcycl")
		KillPilot(x.cyclops)
		x.eturtime = GetTime() + 180.0
		x.epattime = GetTime() + 240.0
		for index = 1, x.epatlength do --init epat
			x.epatcool[index] = GetTime()
			x.epatallow[index] = true
		end
		for index = 1, x.epoollength do --init pool patrol
			x.epoolcool[index] = GetTime()
			x.epoolallow[index] = true
		end
		x.warnordertime = GetTime() + 180.0
		x.order1time = GetTime() + 240.0
    x.efactime = GetTime() + 240.0
		Goto(x.frcy, "fprcy", 0)
		Goto(x.farm, "fparm", 0)
		x.spine = x.spine + 1
	end

	--GIVE FIRST OBJECTIVE
	if x.spine == 1 and IsAudioMessageDone(x.audio1) then
		ClearObjectives()
		AddObjective("tcss0401.txt")
		AddObjective("	")
		AddObjective("tcss0402.txt", "ALLYBLUE")
		x.spine = x.spine + 1
	end
	
	--ONCE x.player GETS NEAR VOLCANO
	if x.spine == 2 and GetDistance(x.player, "eplem") < 530 then
		x.audio1 = AudioMessage("tcss0402.wav") --4 Not picking up struc around volc
		x.order1time = GetTime() + 120.0
		x.spine = x.spine + 1
	end

	--ONCE PLAYER FINDS LEMNOS FACTORY
	if x.spine == 3 and IsAudioMessageDone(x.audio1) and GetDistance(x.player, "eplem") < 250 then
		x.warnordertime = 99999.9
		AudioMessage("tcss0403.wav") --4 P1 There is is. Lt Corb, Griz 1 has found struct
		x.audio1 = AudioMessage("tcss0404.wav") --5 P2 Good job Cmd. Recon obj. Shut down all psg to struct
		x.epooltime = GetTime()
		x.ekillfrcytime = GetTime()
		x.ekillffactime = GetTime()
		for index = 1, x.ekillartlength do --init ekillart
			x.ekillarttime = GetTime()
			x.ekillart[index] = nil 
			x.ekillartcool[index] = 99999.9 
			x.ekillartallow[index] = false
		end
		for index = 1, x.escvlength do --init escv
			x.escvbuildtime[index] = GetTime()
			x.escvstate[index] = 1
		end
		x.elemtime = GetTime()
		x.spine = x.spine + 1
	end
	
	--GIVE LEMNOS ID ORDER
	if x.spine == 4 and IsAudioMessageDone(x.audio1) then
		ClearObjectives()
		AddObjective("tcss0402.txt", "GREEN")
		AddObjective("	")
		AddObjective("tcss0403.txt", "YELLOW")
		x.order1time = GetTime() + 30.0
		x.spine = x.spine + 1
	end

	--SETUP BATTLE FOR LEMNOS
	if x.spine == 5 and IsInfo("olylemnosb") then --id "b" version
		x.order1time = 99999.9
		AudioMessage("tcss0406.wav") --10 GRiz 1, u must hold fact. Cmd x.eldridg will reinforce.
		ClearObjectives()
		AddObjective("tcss0403.txt", "GREEN")
		x.waittime = GetTime() + 10.0
		x.spine = x.spine + 1
	end

	--DEFEND LEMNOS OBJECTIVE
	if x.spine == 6 and x.waittime < GetTime() then
		ClearObjectives()
		AddObjective("tcss0404.txt")
		x.waittime = GetTime() + 20.0
		x.spine = x.spine + 1
	end

	--SEND MESSAGE FOR 1ST CCA LEMNOS GUARD SQUAD
	if x.spine == 7 and x.waittime < GetTime() then
		AudioMessage("tcss0405.wav") --3 Cmd, incoming CCA
		x.spine = x.spine + 1
	end

	--MESSAGE LEM DEF KILLED, ELDRIDGE 10MIN OUT 
	if x.spine == 8 and x.elemwavecount > x.elemwavemax then
		x.elemtime = 99999.9
		AudioMessage("tcss0408.wav") --6 P1 - Looks like thats the last.
		x.audio1 = AudioMessage("tcss0409.wav") --4 P2 - Stay sharp Corp. Secure fact until sixth arrives.
		ClearObjectives()
		AddObjective("	")
		AddObjective("tcss0405.txt", "YELLOW")
		x.spine = x.spine + 1
	end

	--MESSAGE ELDRIDGE 10MIN OUT TURN OFF LEMNOS ALLOW GRENDEL
	if x.spine == 9 and IsAudioMessageDone(x.audio1) then
		AudioMessage("tcss0407.wav") --5 Griz 1, x.eldrig of the 6th platoon. We 10 minutes out.
		x.eldtime = GetTime() + 600.0
		TCC.SetTeamNum(x.lemnos, 1) --so enemy ai will attack it		
		x.eturtime = 99999.9 --TURN OFF
		x.epattime = 99999.9 --TURN OFF
		x.epooltime = 99999.9 --TURN OFF
		x.ekillfrcytime = 99999.9 --TURN OFF
		x.ekillffactime = 99999.9 --TURN OFF
		x.elemtime = 99999.9 --TURN OFF
		x.egrendeltime = GetTime() --ON ON ON
		if x.skillsetting == x.easy then
			x.grendellength = 6
		elseif x.skillsetting == x.medium then
			x.grendellength = 7
		else --x.hard
			x.grendellength = 8
		end
		x.ekillassisttime = GetTime() --ON ON ON
		x.waittime = GetTime() + 30.0
		x.spine = x.spine + 1
	end

	--SEND INCOMING CCA GRENDEL MESSAGE
	if x.spine == 10 and x.waittime < GetTime() then
		AudioMessage("tcss0410.wav") --7 Incoming bombers heading to fact
		ClearObjectives()
		AddObjective("tcss0406.txt", "YELLOW")
		x.waittime = GetTime() + 570.0
		x.spine = x.spine + 1
	end

	--BUILD ELDRIDGE FORCE AND SEND TO LEMNOS
	if x.spine == 11 and x.eldtime < GetTime() then
		for index = 1, x.ebltlength do
			RemoveObject(x.eblt[index]) --just in case for x.eldridge 
		end
		x.eldridge = BuildObject("avrecyss04", 2, "fpeld")
		SetObjectiveName(x.eldridge, "Cmd Eldridge")
		SetObjectiveOn(x.eldridge)
		Goto(x.eldridge, "eplem")
		for index = 1, x.eldscortlength do
			x.eldscort[index] = BuildObject("avtank", 2, "fpeld")
			Defend2(x.eldscort[index], x.eldridge)
			SetObjectiveName(x.eldscort[index], "6 Plt")
			x.eldridgebuilt = true --For MCA check
		end
    x.eldtime = GetTime() + 180.0 --safety timer in case Eldridge gets stuck
		x.spine = x.spine + 1
	end
	
	--TURN OFF GRENDEL ATTACK WHEN ELEDRIDGE NEAR
	if x.spine == 12 and IsAlive(x.eldridge) and (GetDistance(x.eldridge, "eplem") < 700  or x.eldtime < GetTime()) then
		x.egrendeltime = 99999.9
    x.eldtime = GetTime() + 180.0
		x.spine = x.spine + 1
	end
	
	--SET THE MISSION TO SUCCESS AND END
	if x.spine == 13 and IsAlive(x.eldridge) and (GetDistance(x.eldridge, "eplem") < 300 or x.eldtime < GetTime()) then
    x.eldtime = 99999.9
		TCC.SucceedMission(GetTime() + 8.0, "tcss04w1.des") --WINNER WINNER WINNER
		AudioMessage("tcss0411.wav") --3 P1 SUCCEED - Cmd x.eldrige here. Sixth at your cmd.
		AudioMessage("tcss0412.wav") --3 P2 SUCCEED - Good Work. Fact secure
		ClearObjectives()
		AddObjective("tcss0407.txt", "GREEN")
		x.spine = 666
	end
	----------END MAIN SPINE ----------

	--SEND WARNING MESSAGE IF NOT FOLLOWING ORDERS----------------
	if x.warnordertime < GetTime() then
		AudioMessage("alertpulse.wav")
		AddObjective(" ")
		AddObjective("tcss0409.txt", "YELLOW")
		x.warnordertime = GetTime() + 90.0
	end

	--HAND OUT FREE STUFF TO THE CURIOUS
	if IsInfo("yvcycl") and not x.give1 then
		x.pos = GetTransform(x.cyclops)
		RemoveObject(x.cyclops)
		x.cyclops = BuildObject("yvcycl", 1, x.pos)
		SetSkill(x.cyclops, x.skillsetting)
		SetGroup(x.cyclops, 9) --group 10
		StartSoundEffect("fvscav01.wav")
		x.fnav1 = BuildObject("apcamra", 1, "pnavnw")
		SetObjectiveName(x.fnav1, "NW Pool")
		x.fnav1 = BuildObject("apcamra", 1, "pnavne")
		SetObjectiveName(x.fnav1, "NE Pool")
		x.fnav1 = BuildObject("apcamra", 1, "pnavse")
		SetObjectiveName(x.fnav1, "SE Pool")
		AddObjective("\nDeploy the Cyclops on a bio-metal pool.", "ALLYBLUE")
		x.give1 = true
	end

	--CCA GROUP TURRET GROUP
	if x.eturtime < GetTime() then
		for index = 1, x.eturlength do
			if not IsAlive(x.etur[index]) then
				x.etur[index] = BuildObject("svturr", 5, GetPositionNear("epgrcy", 0, 16, 32)) --grpspwn
				SetSkill(x.etur[index], x.skillsetting)
				Goto(x.etur[index], ("eptur%d"):format (index))
			end
		end
		x.eturtime = GetTime() + 120.0
	end
	
	--CCA POOL PATROL ----------------------------------
	if x.epooltime < GetTime() then
		for index = 1, x.epoollength do
			if not IsAlive(x.epool[index]) and not x.epoolallow[index] then
				x.epoolcool[index] = GetTime() + 360.0
				x.epoolallow[index] = true
			end
			
			if x.epoolallow[index] and x.epoolcool[index] < GetTime() then
				while x.randompick == x.randomlast do --random the random
					x.randompick = math.floor(GetRandomFloat(1.0,16.0))
				end
				x.randomlast = x.randompick
				if x.randompick >=1 and x.randompick <=5 then
					x.epool[index] = BuildObject("svscout", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
				elseif x.randompick >=6 and x.randompick <=10 then
					x.epool[index] = BuildObject("svmbike", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
				else
					x.epool[index] = BuildObject("svtank", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
				end
				SetSkill(x.epool[index], x.skillsetting)
				if index <= (x.epoollength/2) then
					Goto(x.epool[index], "ppool1")
					--SetObjectiveName(x.epool[index], ("Pool 1 Guard %d"):format(index))
				else
					Goto(x.epool[index], "ppool2")
					--SetObjectiveName(x.epool[index], ("Pool 2 Guard %d"):format(index))
				end
				x.epoolallow[index] = false
			end
		end
		x.epooltime = GetTime() + 30.0
	end

	--CCA GROUP killrecylcer---NON-WARCODE VER--REALLY SHOULD REDO AS WARCODE... BUT IT WORKS... SO I'M GONNA BE LAZY
	if x.ekillfrcytime < GetTime() then
		if not x.ekillfrcybuild then
			for index = 1, x.ekillfrcylength do --check alive force
				if not IsAlive(x.ekillfrcy[index]) then
					x.casualty = x.casualty + 1
				end
			end
			if x.casualty ~= x.ekillfrcylength then
				x.casualty = 0
			elseif not x.ekillfrcyreset then
				x.casualty = 0
				x.ekillfrcybuild = true
				x.ekillfrcytime = GetTime() + 120.0
				x.ekillfrcyreset = true
			end
		end

		if x.ekillfrcybuild then --if left alive, kill it
			for index = 1, x.ekillfrcylength do
				if IsAlive(x.ekillfrcy[index]) then
					Damage(x.ekillfrcy[index],10000)
				end
			end
			for index = 1, x.ekillfrcylength do --clear out table
				x.ekillfrcy[index] = nil
			end
			for index = 1, x.ekillfrcylength do --build force
				while x.randompick == x.randomlast do --random the random
					x.randompick = math.floor(GetRandomFloat(1.0,16.0))
				end
				x.randomlast = x.randompick
				if x.randompick >=1 and x.randompick <=5 then
					x.ekillfrcy[index] = BuildObject("svscout", 5, GetPositionNear("epgrcy", 0, 16, 32)) --grpspwn
					Goto(x.ekillfrcy[index], "stage1")
				elseif x.randompick >=6 and x.randompick <=10 then
					x.ekillfrcy[index] = BuildObject("svmbike", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
					Goto(x.ekillfrcy[index], "stage2")
				else
					x.ekillfrcy[index] = BuildObject("svtank", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
					Goto(x.ekillfrcy[index], "stage3")
				end
				SetSkill(x.ekillfrcy[index], x.skillsetting)
				if index % 3 == 0 then
					SetSkill(x.ekillfrcy[index], x.skillsetting+1)
				end
			end
			x.ekillfrcyresendtime = GetTime() --KEEP - seed on newly built squad
			x.casualty = 0
			x.ekillfrcyreset = false
			x.ekillfrcybuild = false
		end

		if x.ekillfrcyresendtime < GetTime() then
			for index = 1, x.ekillfrcylength do
				if IsAlive(x.ekillfrcy[index]) and GetTeamNum(x.ekillfrcy[index]) ~= 1 then
					Attack(x.ekillfrcy[index], x.frcy)
				end
			end
			x.ekillfrcyresendtime = GetTime() + 30.0
		end
	end

	--CCA GROUP killfactory/armory---NON-WARCODE VER---------------------------
	if x.ekillffactime < GetTime() then
		if not x.ekillffacbuild then
			for index = 1, x.ekillffaclength do --check alive force
				if not IsAlive(x.ekillffac[index]) or (IsAlive(x.ekillffac[index]) and GetTeamNum(x.ekillffac[index]) == 1) then
					x.casualty = x.casualty + 1
				end
			end
			
			if x.casualty ~= x.ekillffaclength then
				x.casualty = 0
			elseif not x.ekillffacreset then
				x.casualty = 0
				x.ekillffacbuild = true
				x.ekillffactime = GetTime() + 60.0
				x.ekillffacreset = true
			end
		end

		if x.ekillffacbuild then
			for index = 1, x.ekillffaclength do --if left alive, kill it
				if IsAlive( x.ekillffac[index]) and GetTeamNum(x.ekillffac[index]) ~= 1 then
					Damage( x.ekillffac[index],10000)
				end
			end
			
			for index = 1, x.ekillffaclength do --clear out table
				x.ekillffac[index] = nil
			end
			
			for index = 1, x.ekillffaclength do --build force
				while x.randompick == x.randomlast do --random the random
					x.randompick = math.floor(GetRandomFloat(1.0,16.0))
				end
				x.randomlast = x.randompick
				if x.randompick >=1 and x.randompick <=5 then 
					x.ekillffac[index] = BuildObject("svscout", 5, GetPositionNear("epgrcy", 0, 16, 32)) --grpspwn
					Goto(x.ekillffac[index], "stage1")
				elseif x.randompick >=6 and x.randompick <=10 then
					x.ekillffac[index] = BuildObject("svmbike", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
					Goto(x.ekillffac[index], "stage2")
				else
					x.ekillffac[index] = BuildObject("svtank", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
					Goto(x.ekillffac[index], "stage3")
				end
				SetSkill(x.ekillffac[index], x.skillsetting)
				if index % 3 == 0 then
					SetSkill(x.ekillffac[index], x.skillsetting+1)
				end
			end
			x.ekillffacresendtime = GetTime() --KEEP - seed on newly built squad
			x.casualty = 0
			x.ekillffacreset = false
			x.ekillffacbuild = false
		end

		if x.ekillffacresendtime < GetTime() then
			for index = 1, x.ekillffaclength do
				if IsAlive(x.ekillffac[index]) and GetTeamNum(x.ekillffac[index]) ~= 1 then
					if IsAlive(x.ffac) then
						Attack(x.ekillffac[index], x.ffac)
					elseif IsAlive(x.farm) then
						Attack(x.ekillffac[index], x.farm)
					else
						Attack(x.ekillffac[index], x.frcy)
					end
				end
			end
			x.ekillffacresendtime = GetTime() + 60.0
		end
	end

	--CCA GROUP lemnos guard------------------------------------
	if x.elemtime < GetTime() then
		if not x.elembuild then
			for index = 1, x.elemlength do --check alive force
				if not IsAlive(x.elem[index]) or (IsAlive(x.elem[index]) and GetTeamNum(x.elem[index]) == 1) then
					x.casualty = x.casualty + 1
				end
			end
			if x.casualty <= math.floor(x.elemlength * 0.75) then
				x.casualty = 0
			else
				x.casualty = 0
				x.elembuild = true
				x.elemtime = GetTime() + 30.0
				x.elemreset = true
				x.elemwavecount = x.elemwavecount + 1
			end
		end
		
		if x.elemwavecount <= x.elemwavemax and x.elembuild then
			for index = 1, x.elemlength do
				if IsAlive(x.elem[index]) then
					Damage(x.elem[index],10000)
				end
			end
		end
		
		if x.elemwavecount <= x.elemwavemax and x.elembuild then
			for index = 1, x.elemlength do
				x.elem[index] = nil
			end
		end
		
		if x.elemwavecount <= x.elemwavemax and x.elembuild then
			for index = 1, x.elemlength do --build force
				if index <= 20 then
					while x.randompick == x.randomlast do --random the random
						x.randompick = math.floor(GetRandomFloat(1.0,16.0))
					end
					x.randomlast = x.randompick
					if (x.randompick >=1 and x.randompick <=5) and IsAlive(x.ercy) then 
						x.elem[index] = BuildObject("svscout", 5, GetPositionNear("epgrcy", 0, 16, 32)) --grpspwn
						Goto(x.elem[index], "stage1")
					elseif (x.randompick >=6 and x.randompick <= 10) and IsAlive(x.efac) then
						x.elem[index] = BuildObject("svmbike", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
						Goto(x.elem[index], "stage2")
					elseif IsAlive(x.efac) then
						x.elem[index] = BuildObject("svtank", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
						Goto(x.elem[index], "stage3")
					end
				elseif IsAlive(x.ercy) then --index 21-28 - 8 turrets
					x.elem[index] = BuildObject("svturr", 5, GetPositionNear("epgrcy", 0, 16, 32)) --grpspwn
					Goto(x.elem[index], "stage1")
				end
				SetSkill(x.elem[index], x.skillsetting)
				if index % 3 == 0 then
					SetSkill(x.elem[index], x.skillsetting+1)
				end
			end
			x.elemresendtime = GetTime() --KEEP - seed on newly built squad
			x.elemreset = false
			x.elembuild = false
		end

		if x.elemwavecount <= x.elemwavemax and x.elemresendtime < GetTime() then
			for index = 1, x.elemlength do
				if index <= 7 then
					Goto(x.elem[index], "eplemrally1")
				elseif index >= 8 and index <= 13 then
					Goto(x.elem[index], "eplemrally2")
				elseif index >= 14 and index <= 20 then
					Goto(x.elem[index], "eplemrally3")
				elseif index == 21 then
					Goto(x.elem[index], "eplemtur1")
				elseif index == 22 then
					Goto(x.elem[index], "eplemtur2")
				elseif index == 23 then
					Goto(x.elem[index], "eplemtur3")
				elseif index == 24 then
					Goto(x.elem[index], "eplemtur4")
				elseif index == 25 then
					Goto(x.elem[index], "eplemtur5")
				elseif index == 26 then
					Goto(x.elem[index], "eplemtur6")
				elseif index == 27 then
					Goto(x.elem[index], "eplemtur7")
				else
					Goto(x.elem[index], "eplemtur8")
				end
			end
			x.elemresendtime = GetTime() + 120.0
		end
	end

	--CCA GROUP grendel------------------------------------------
	if x.egrendeltime < GetTime() then
		if not x.egrendelbuild then
			for index = 1, x.egrendellength do
				if not IsAlive(x.egrendel[index]) or (IsAlive(x.egrendel[index]) and GetTeamNum(x.egrendel[index]) == 1) then
					x.casualty = x.casualty + 1
				end
			end
			if x.casualty < math.floor(x.egrendellength * 0.75) then
				x.casualty = 0
			elseif not x.egrendelreset then
				x.casualty = 0
				x.egrendelbuild = true
				x.egrendeltime = GetTime() + 20.0
				x.egrendelreset = true
			end
		end

		if x.egrendelbuild then
			if x.skillsetting == x.easy then
				x.egrendellength = 6
			elseif x.skillsetting == x.medium then
				x.egrendellength = 8
			else --x.hard
				x.egrendellength = 10
			end
			for index = 1, x.egrendellength do
				if index % 2 == 0 then
					x.egrendel[index] = BuildObject("svrckt", 5, GetPositionNear("epgrn2", 0, 16, 32)) --grpspwn
				else
					x.egrendel[index] = BuildObject("svrckt", 5, GetPositionNear("epgrn1", 0, 16, 32)) --grpspwn
				end
				SetSkill(x.egrendel[index], x.skillsetting)
				if index % 3 == 0 then
					SetSkill(x.egrendel[index], x.skillsetting+1)
				end
				x.egrendelresendtime = GetTime() --seed on newly built squad
				x.casualty = 0
				x.egrendelreset = false
				x.egrendelbuild = false
			end
		end

		if x.egrendelresendtime < GetTime() then
			for index = 1, x.egrendellength do
				if IsAlive(x.egrendel[index]) then
					Goto(x.egrendel[index], "fpnav")  --change 3/17/21  "eplemrally3") --path of attack not work, so "Goto"
					SetMaxAmmo(x.egrendel[index], 6000)
					AddAmmo(x.egrendel[index], 2000)
				end
			end
			x.egrendelresendtime = GetTime() + 20.0
			x.egrendellooker = true
			x.egrendellookertime = GetTime()
		end
	end
	
	--CHECK WHEN GRENDEL GETS CLOSE TO LEMNOS AND ATTACK
	if x.egrendellooker and x.egrendellookertime < GetTime() then
		for index = 1, x.egrendellength do
			if IsAlive(x.egrendel[index]) and not IsPlayer(x.egrendel[index]) and GetDistance(x.egrendel[index], "fpnav") < 250 then  --"eplemrally3"
				Attack(x.egrendel[index], x.lemnos)
			end
		end
		x.egrendellookertime = GetTime() + 10.0
	end
	
	--CCA GROUP lemnos killer assist----------------------------
	if x.ekillassisttime < GetTime() then
		if not x.ekillassistbuild then
			for index = 1, x.ekillassistlength do --check alive force
				if not IsAlive(x.ekillassist[index]) or (IsAlive(x.ekillassist[index]) and GetTeamNum(x.ekillassist[index]) == 1) then
					x.casualty = x.casualty + 1
				end
			end
			
			if x.casualty ~= x.ekillassistlength then
				x.casualty = 0
			elseif not x.ekillassistreset then
				x.casualty = 0
				x.ekillassistbuild = true
				x.ekillassisttime = GetTime() + 30.0
				x.ekillassistreset = true
			end
		end
		
		if x.ekillassistbuild then
			for index = 1, x.ekillassistlength do --build force
				while x.randompick == x.randomlast do --random the random
					x.randompick = math.floor(GetRandomFloat(1.0,16.0))
				end
				x.randomlast = x.randompick
				if (x.randompick == 2 or x.randompick == 5 or x.randompick == 8 or x.randompick == 11 or x.randompick == 14) and IsAlive(x.efac) then
					x.ekillassist[index] = BuildObject("svmbike", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
					Goto(x.ekillassist[index], "stage2")
				elseif (x.randompick == 3 or x.randompick == 6 or x.randompick == 9 or x.randompick == 12 or x.randompick == 15) and IsAlive(x.efac) then
					x.ekillassist[index] = BuildObject("svtank", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
					Goto(x.ekillassist[index], "stage3")
				else
					x.ekillassist[index] = BuildObject("svscout", 5, GetPositionNear("epgrcy", 0, 16, 32)) --grpspwn
					Goto(x.ekillassist[index], "stage1")
				end
			end
			SetSkill(x.ekillassist[index], x.skillsetting)
			x.ekillassistresendtime = GetTime() --KEEP - seed on newly built squad
			x.casualty = 0
			x.ekillassistreset = false
			x.ekillassistbuild = false
		end
		
		if x.ekillassistresendtime < GetTime() then
			for index = 1, x.ekillassistlength do
				if IsAlive(x.ekillassist[index]) then
					Goto(x.ekillassist[index], "eplemrally3")
				end
			end
			x.ekillassistresendtime = GetTime() + 30.0
		end
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
				x.escv[index] = BuildObject("svscav", 5, GetPositionNear("epgrcy", 0, 16, 32)) --grpspwn
				x.escvstate[index] = 1
			end
		end
	end

	--CCA REBUILD FACTORY --------------------------------------
	if x.efactime < GetTime() then
		if not x.efacreset and IsAlive(x.ercy) and not IsAlive(x.efac) then
      x.efactime = GetTime() + 120.0
			x.efacreset = true
		elseif x.efacreset and x.efactime < GetTime() and IsAlive(x.ercy) and GetDistance(x.player, x.efac) > 400 then
			x.efac = BuildObject("sbfact", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
			x.efacreset = false
		end
	end

	--CCA GROUP SCOUT PATROLS ----------------------------------
	if x.epattime < GetTime() and IsAlive(x.efac) then
		for index = 1, x.epatlength do
			if not IsAlive(x.epat[index]) and not x.epatallow[index] then
				x.epatcool[index] = GetTime() + 360.0
				x.epatallow[index] = true
			end
			
			if x.epatallow[index] and x.epatcool[index] < GetTime() then
				if index == 1 then
					x.epat[index] = BuildObject("svscout", 5, ("ppatrol%d"):format(index))
				elseif index == 2 then
					x.epat[index] = BuildObject("svmbike", 5, ("ppatrol%d"):format(index))
				elseif index == 3 then
					x.epat[index] = BuildObject("svmisl", 5, ("ppatrol%d"):format(index))
				elseif index == 4 then
					x.epat[index] = BuildObject("svtank", 5, ("ppatrol%d"):format(index))
				end
				SetSkill(x.epat[index], x.skillsetting)
				Patrol(x.epat[index], ("ppatrol%d"):format(index))
				--SetObjectiveName(x.epat[index], ("Patrol %d"):format(index))
				x.epatallow[index] = false
			end
		end
		x.epattime = GetTime() + 30.0
	end

	--AI ARTILLERY ASSASSIN
	if x.ekillarttime < GetTime() and IsAlive(x.efac) then
		for index = 1, x.ekillartlength do
			if (not IsAlive(x.ekillart[index]) or (IsAlive(x.ekillart[index]) and GetTeamNum(x.ekillart[index]) == 1)) and not x.ekillartallow[index] then
				x.ekillartcool[index] = GetTime() + 70.0
				x.ekillartallow[index] = true
			end
			if x.ekillartallow[index] and x.ekillartcool[index] < GetTime() and GetDistance(x.player, "epgfac") > 300 then
				x.ekillart[index] = BuildObject("svtank", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
				SetSkill(x.ekillart[index], x.skillsetting)
				--SetObjectiveName(x.ekillart[index], "Artl Killer")
				if IsAlive(x.ercy) then
					Defend2(x.ekillart[index], x.ercy)
				else
					Defend2(x.ekillart[index], x.efac)
				end
				x.ekillartallow[index] = false
			end
		end
		for index = 1, x.fartlength do
			if IsAlive(x.fart[index]) and GetDistance(x.fart[index], x.ercy) < 600 then
				x.ekillarttarget = x.fart[index]
				x.ekillartmarch = true
				break
			end
		end
		if x.ekillartmarch then
			for index = 1, x.ekillartlength do
        if IsAlive(x.ekillart[index]) and GetTeamNum(x.ekillart[index]) ~= 1 then
          Attack(x.ekillart[index], x.ekillarttarget)
        end
			end
			x.ekillarttime = GetTime() + 180.0 --give time for attack
			x.ekillartmarch = false
		end
	end

	--CHECK CCA RECYCLER IF DEAD MOVE TO GRENDEL ATTACK --------
	if x.ercystate == 0 and not IsAlive(x.ercy) then --If cca recycler dead, go to grendel attack
		AudioMessage("tcss0416.wav") --4 Gen, Grizzly 1 has elim the CCA Recycler
		x.audioercy = AudioMessage("tcss0417.wav") --6 Good work Cmd. Now kill any CCA that could kill factory.
		x.elemtime = 99999.9
    for index = 1, x.elemlength do --check alive force
      if IsAlive(x.elem[index]) then
        Goto(x.elem[index], "fpnav")
      end
    end
    x.ercytime = GetTime() + 90.0
    x.ercystate = x.ercystate + 1
  elseif x.ercystate == 1 and x.ercytime < GetTime() then --early start lemnos
		x.elemwavecount = x.elemwavemax + 1
		x.spine = 8 --jump
    x.ercystate = x.ercystate + 1
	end

	--CHECK STATUS OF MISSION-CRITICAL ASSETS (MCA) --------------
	if not x.MCAcheck then
		if not IsAlive(x.frcy) then
			AudioMessage("tcss0413.wav") --7 FAIL - Recyler lost eldridge specific
			TCC.FailMission(GetTime() + 9.0, "tcss04f1.des") --LOSER LOSER LOSER
			ClearObjectives()
			AddObjective("failrecycox.txt", "RED") --Your Recycler was destroyed. MISSION FAILEDnot 
			x.spine = 666
			x.MCAcheck = true
		end
		
		if not IsAlive(x.lemnos) then --Check Lemnos factory
			AudioMessage("tcss0414.wav") --7 FAIL - All units fall back
			TCC.FailMission(GetTime() + 9.0, "tcss04f2.des") --LOSER LOSER LOSER
			ClearObjectives()
			AddObjective("tcss0408.txt", "RED")
			x.spine = 666
			x.MCAcheck = true
		end
		
		if x.order1time < GetTime() then --follow orders soldier
			AudioMessage("tcss0394.wav") --9 FAIL - time up for follow order orig bz1 0694 copy of ss0594
			TCC.FailMission(GetTime() + 11.0, "tcss04f3.des") --"failordr.des") --LOSER LOSER LOSER
			ClearObjectives()
			AddObjective("failordr.txt", "RED")
			x.spine = 666
			x.MCAcheck = true
		end
		
		if x.eldridgebuilt and not IsAlive(x.eldridge) then --just in case
			AudioMessage("failrecygencol.wav") --7 FAIL - Recyler lost x.eldridge specific
			TCC.FailMission(GetTime() + 9.0, "failmcabcox.des") --LOSER LOSER LOSER
			ClearObjectives()
			AddObjective("failmcabcox.txt", "RED") --lost a mission critical asset
			x.spine = 666
			x.MCAcheck = true
		end
	end
end
--[[END OF SCRIPT]]