--bztcrs07 - Battlezone Total Command - Red Storm - 7/8 - LEAVE HOME
assert(load(assert(LoadFile("_requirefix.lua")),"_requirefix.lua"))();
TCC = require("TC_Core")
MisnNum = 25;
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
	pos = {},	
	audio1 = nil, 
	fnav = nil,
	ecom = nil, 
	epwr = {}, 
	eprx = {}, 
	etur = {}, 
	epat = {}, 
	ebase = {}, --cca base pilots
	ebaseatk = {},
	ebasecasualty = 0, 
	ebasetime = 99999.9,	
	eapc = {}, --convoy stuff
	eapclive = {}, 
	eapctime = 99999.9, 
	eatk = {},
	targetapc = 0, 
	targetset = false, 
	ecrate = nil,	 
	edolly = {}, --dummy soldier for com cam entrance
	eroute = 0, 
	eapcpast = false, 
	playerstate = 0, 
	randompick = 0, 
	randomlast = 0, 
	casualty = 0, 
	epilo = {}, --cca pilots field
	epilostate = 0, 
	epilospawn = {},	
	spawnrange = 0, 
	eally = {}, --cca pilots drop
	fally = {}, --cra pilots drop
	fdrp = nil, 
	fdrppos = {}, 
	camstate = 0, 
  camfov = 60,  --185 default
	userfov = 90,  --seed
	insidebase = 0, 
	LAST = true
}
--Paths: pmytank, safespace, fpnav1-3, pcam0-2, ppatrol1-6, ebase (0-6pts), epilpat1-3, epmine1-2 (0-8 pts), eptur1-2(0-8), pcrate1-2, epapc1-3, eproute1-2, eppast1-2, ephome, ebase1-6, epally, fpally, fphome, eppwr (0-6), ecompath, eppilo1-3 (0-16), epsnip1-3 (0-16), apcarea, epbase

function InitialSetup()
	SetAutoGroupUnits(true)
	
	local odfpreload = {
		"sspilo", "sspilors07", "svturr", "svscout", "svapc", "sbcrat00rs07", "kspilo", "kssold", "kvdrop", "oproxars01", "apcamrk"
	}
	for k,v in pairs(odfpreload) do
		PreloadODF(v)
	end

	x.mytank = GetHandle("mytank")
	x.ecom = GetHandle("ecom")
	x.fdrp = GetHandle("fdrp")
	Ally(1, 4)
	Ally(4, 1) --4 cra dropship
	Ally(5, 6) --5 base cca
	Ally(5, 7)
	Ally(6, 5) --6 field CCA 
	Ally(6, 7)
	Ally(7, 5) --7 convoy
	Ally(7, 6)
	SetTeamColor(4, 150, 180, 150)  
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
	TCC.Update()
	
	--SETUP MISSION BASICS
	if x.spine == 0 then
		AudioMessage("tcrs0701.wav") --Rus convoy coming. Look Russian. Go to Comm tow. steal info
		x.mytank = BuildObject("sspilors07", 1, "pcam0", 1) --"pmytank")
		SetAsUser(x.mytank, 1)
		x.fdrppos = GetTransform(x.fdrp)
		RemoveObject(x.fdrp)
		RemoveObject(x.player)
		x.player = GetPlayerHandle()
		for index = 1, 6 do --powerplants and scout patrols
			x.epwr[index] = BuildObject("sbpgen0", 5, "eppwr", index)
			x.epat[index] = BuildObject("svscout", 5, ("ppatrol%d"):format(index))
			SetCanSnipe(x.epat[index], 0)
			SetSkill(x.epat[index], x.skillsetting)
			Patrol(x.epat[index], ("ppatrol%d"):format(index))
			x.ebase[index] = BuildObject("sspilo", 5, "ebase", index) --0-6 pts --patrol pilots
			x.ebaseatk[index] = 0 --init
		end
		Patrol(x.ebase[1], "epilpat1")
		Patrol(x.ebase[2], "epilpat1")
		Patrol(x.ebase[3], "epilpat2")
		Patrol(x.ebase[4], "epilpat2")
		Patrol(x.ebase[5], "epilpat3")
		Patrol(x.ebase[6], "epilpat3")
		for index = 1, 3 do --create and init multidim array - filled later
			x.eatk[index] = {} --"rows"
			for index2 = 1, 2 do
				x.eatk[index][index2] = nil --"columns", init value (handle in this case)
			end
			x.eapclive[index] = 0 --init for apc works here
		end
		x.spawnrange = 400 --400 in map
    x.userfov = IFace_GetInteger("options.graphics.defaultfov")
    CameraReady()
    IFace_SetInteger("options.graphics.defaultfov", x.camfov)
		x.spine = x.spine + 1
	end
	
	--RUN CCA BASE CAMERA THEN CONTINUE
	if x.spine == 1 and (CameraPath("pcam0", 200, 1200, x.ecom) or CameraCancelled()) then
    CameraFinish()
    IFace_SetInteger("options.graphics.defaultfov", x.userfov)
		AddObjective("tcrs0700.txt")  
		x.spine = x.spine + 1
	end
	
	--PLAYER NEAR COMM TOWER
	if x.spine == 2 and IsAlive(x.ecom) and GetDistance(x.player, x.ecom) < 80 then
		x.pos = GetTransform(x.player)
		x.edolly[1] = BuildObject("sspilo", 5, "ecomcam")
		x.edolly[2] = BuildObject("sspilo", 5, "ecompath")
		Goto(x.edolly[2], "ecompath")
		x.waittime = GetTime() + 15.0
		x.camstate = 1
    x.userfov = IFace_GetInteger("options.graphics.defaultfov")
    CameraReady()
    IFace_SetInteger("options.graphics.defaultfov", x.camfov)
		x.spine = x.spine + 1
	end
	
	--PICK ROUTE
	if x.spine == 3 and (x.waittime < GetTime() or CameraCancelled())then
    CameraFinish()
    IFace_SetInteger("options.graphics.defaultfov", x.userfov)
		x.camstate = 0
		RemoveObject(x.edolly[1])
		RemoveObject(x.edolly[2])
		x.mytank = BuildObject("sspilors07", 1, "ecompath", 2)
		SetAsUser(x.mytank, 1)
		RemoveObject(x.player)
		x.player = GetPlayerHandle()
		TCC.SetTeamNum(x.player, 1)--JUST IN CASE
		for index = 1, 30 do
			x.randompick = math.floor(GetRandomFloat(1.0,16.0)) --single 0-n inclusive, or double n1-nx inclusive
		end
		if x.randompick % 2 == 0 then
			x.eroute = 2 --east
			x.audio1 = AudioMessage("tcrs0703.wav") --The convoy will use the Eastern bridge. Snipe crate explosive
		else
			x.eroute = 1 --north
			x.audio1 = AudioMessage("tcrs0702.wav") --The convoy will use the Northern bridge. Snipe crate explosive
		end
		x.crate = BuildObject("sbcrat00rs07", 0, ("pcrate%d"):format(x.eroute))
    x.userfov = IFace_GetInteger("options.graphics.defaultfov")
    CameraReady()
    IFace_SetInteger("options.graphics.defaultfov", x.camfov)
		x.spine = x.spine + 1
	end
	
	--RUN EROUTE PICK CAMERA THEN MARK PATH
	if x.spine == 4 and (CameraPath(("pcam%d"):format(x.eroute), 2000, 3500, x.crate) or CameraCancelled()) then
    CameraFinish()
    IFace_SetInteger("options.graphics.defaultfov", x.userfov)
		if x.eroute == 2 then --east
			ClearObjectives()
			AddObjective("tcrs0702.txt")
		elseif x.eroute == 1 then --north
			ClearObjectives()
			AddObjective("tcrs0701.txt")
		end
		x.fnav = BuildObject("apcamrk", 1, ("fpnav%d"):format(x.eroute))
		SetObjectiveName(x.fnav, "Stop Convoy")
		for index = 1, 8 do
			x.eprx[index] = BuildObject("oproxars01", 6, "epmine1", index) --std prox w/ long lifespan
			x.eprx[index+8] = BuildObject("oproxars01", 6, "epmine2", index) --std prox w/ long lifespan
			x.etur[index] = BuildObject("svturr", 6, "eptur1", index)
			x.etur[index+8] = BuildObject("svturr", 6, "eptur2", index)
		end
		for index = 1, 80 do --prep for field enemies
			x.epilospawn[index] = 0
		end
		x.epilostate = 1
		x.spine = x.spine + 1
	end
	
	--THREE MINUTE WARNING
	if x.spine == 5 and GetDistance(x.player, ("pcrate%d"):format(x.eroute)) < 900 then
		--1 min less for actual convoy spawn and arrival
		if x.skillsetting == x.easy then
			x.waittime = GetTime() + 180.0
		elseif x.skillsetting == x.medium then
			x.waittime = GetTime() + 160.0
		else
			x.waittime = GetTime() + 140.0
		end
		AudioMessage("tcrs0705.wav") --You have 3 minutes until convoy arrive
		x.eapctime = GetTime()
		x.spine = x.spine + 1
	end
	
	--BUILD EAPC AND ESCORTS, AND SEND OUT
	if x.spine == 6 and (x.waittime < GetTime() or GetDistance(x.player, "pcrate%d") < 301) then --300 sniper range
		Patrol(x.ebase[1], "epilpat1") --RTB base patrol ...
		Patrol(x.ebase[2], "epilpat1") --so don't bunch up ..
		Patrol(x.ebase[3], "epilpat2") --on player ...
		Patrol(x.ebase[4], "epilpat2") --at snipe site.
		Patrol(x.ebase[5], "epilpat3")
		Patrol(x.ebase[6], "epilpat3")
		if x.eapctime < GetTime() then
			for index = 1, 3 do
				if x.eapclive[index] == 0 then
					x.eapc[index] = BuildObject("mvapc", 7, ("epapc%d"):format(index))
					SetCanSnipe(x.eapc[index], 0)
					for index2 = 1, 2 do
						x.eatk[index][index2] = BuildObject("mvscout", 7, ("epapc%d"):format(index))
						SetSkill(x.eatk[index][index2], x.skillsetting)
						SetCanSnipe(x.eatk[index][index2], 0)
						Defend2(x.eatk[index][index2], x.eapc[index])
					end
					Retreat(x.eapc[index], ("eproute%d"):format(x.eroute))
					x.eapclive[index] = 1
					x.eapctime = 99999.9
					break
				end
			end
		end
		for index = 1, 3 do 
			if x.eapclive[index] == 1 and not IsInsideArea("apcarea", x.eapc[index]) then
				x.eapctime = GetTime()
				x.eapclive[index] = 2
			end
		end
		if IsAlive(x.eapc[3]) then
			x.spine = x.spine + 1
		end
	end
	
	--PICK TARGET APC
	if x.spine == 7 then
		for index = 1, 30 do
			while x.randompick == x.randomlast do --random the random
				x.randompick = math.floor(GetRandomFloat(1.0,3.0)) --single 0-n inclusive, or double n1-nx inclusive
			end
			x.randomlast = x.randompick
		end
		x.targetapc = math.floor(x.randompick)
		SetObjectiveName(x.eapc[x.targetapc], ("Portal Parts"):format(x.targetapc))
		x.spine = x.spine + 1
	end
	
	--TARGET APC DEAD, START EXTRACTION
	if x.spine == 8 and not IsAlive(x.eapc[x.targetapc]) then
		AudioMessage("tcrs0708.wav") --Good work, return to the dropzone.
		ClearObjectives()
		AddObjective("tcrs0704.txt", "GREEN")
		AddObjective(" ")
		AddObjective("tcrs0705.txt")
		RemoveObject(x.fnav)
		x.fnav = BuildObject("apcamrk", 1, "fpnav3")
		SetObjectiveName(x.fnav, "Dropzone")
		x.eapcpast = true
		for index = 1, 6 do --send back base foot patrol...
			if not IsAlive(x.ebase[index]) then
				x.ebase[index] = BuildObject("sspilo", 5, "fpnav3") --or rebuld at nav... ooh, you ahole
			end
			Attack(x.ebase[index], x.player) --for one last try to kill player
		end
		x.spine = x.spine + 1
	end
	
	--PLAYER AT EXTRACTION
	if x.spine == 9 and GetDistance(x.player, "fpnav3") < 250 then
		x.fdrp = BuildObject("kvdrop", 4, x.fdrppos)
		SetAnimation(x.fdrp, "open", 1) --let me in met me in
		for index = 1, 8 do --turn off thrusters
			StopEmitter(x.fdrp, index)
		end
		AudioMessage("pow_done.wav")
		ClearObjectives()
		AddObjective("tcrs0706.txt", "CYAN")
		RemoveObject(x.fnav)
		SetObjectiveOn(x.fdrp)
		x.spine = x.spine + 1
	end
	
	--SPAWN SHOOTOUT
	if x.spine == 10 and GetDistance(x.player, "fphome") < 450 then
		for index = 1, 10 do
			x.eally[index] = BuildObject("sspilo", 5, "epally", index)
			x.fally[index] = BuildObject("kspilo", 4, "fpally", index)
		end
		x.spine = x.spine + 1
	end
	
	--PLAYER AT DROPSHIP SUCCEED MISSION
	if x.spine == 11 and GetDistance(x.player, x.fdrp) < 40 then
		AudioMessage("tcrs0709.wav") --SUCCEED - welcome back Maj. now let us return to Ganymede
		ClearObjectives()
		AddObjective("tcrs0707.txt", "GREEN")
		SetCurHealth(x.player, 10000)
		TCC.SucceedMission(GetTime() + 5.0, "tcrs07w.des") --winner winner winner
		x.MCAcheck = true
		x.spine = x.spine + 1
	end
	----------END MAIN SPINE ----------
	
	--RUN COMM TOWER CAM
	if x.camstate == 1 then
		CameraObject(x.edolly[1], 0, 3, -20, x.edolly[2])
	end
	
	--SNOWFLAKE IN A SAFESPACE
	if x.playerstate == 0 and x.insidebase == 0 and IsInsideArea("safespace", x.player) then
		x.playerstate = 1
		Ally(5, 1)
	end
	
	--HAS PLAYER ENTERED BASE
	if x.playerstate == 1 and IsInsideArea("epbase", x.player) then
		Ally(5, 1)
		x.insidebase = 1
	end
	
	--HAS PLAYER EXITED BASE
	if (x.insidebase == 1 and not IsInsideArea("epbase", x.player)) or (x.insidebase == 0 and not IsInsideArea("safespace", x.player)) then
		AudioMessage("tcrs0704.wav") --RUS - security breach. kill intruder
		UnAlly(5, 1)
		x.playerstate = 2
		x.ebasetime = GetTime()
		x.insidebase = 2
	end
	
	--CCA BASE ATTACK PLAYER
	if x.insidebase == 2 and x.ebasecasualty < 6 then 
		for index = 1, 6 do
			if x.ebaseatk[index] == 0 and x.ebasetime < GetTime() then
				Attack(x.ebase[index], x.player)
				x.ebaseatk[index] = 1
				if x.skillsetting == x.easy then
					x.ebasetime = GetTime() + 12.0
				elseif x.skillsetting == x.medium then
					x.ebasetime = GetTime() + 10.0
				else
					x.ebasetime = GetTime() + 8.0
				end
				x.ebasecasualty = x.ebasecasualty + 1
				break
			end
		end 
	end
	
	--SPAWN CCA GUARDS
	if x.epilostate == 1 then
		for index = 1, 16 do
			--waiters 1-16 NORTH
			if x.epilospawn[index] == 0 and GetDistance(x.player, "eppilo1", index) < (x.spawnrange+10) then --400 visibilityrange in map
				x.epilo[index] = BuildObject("sspilors01", 6, "eppilo1", index)
				SetSkill(x.epilo[index], x.skillsetting + 1)
				Attack(x.epilo[index], x.player)
				x.epilospawn[index] = 1
			end
			
			--waiters 17-32 EAST
			if x.epilospawn[index+16] == 0 and GetDistance(x.player, "eppilo2", index) < (x.spawnrange+10) then --400 visibilityrange in map
				x.epilo[index+16] = BuildObject("sspilors01", 6, "eppilo2", index)
				SetSkill(x.epilo[index+16], x.skillsetting + 1)
				Attack(x.epilo[index+16], x.player)
				x.epilospawn[index+16] = 1
			end
			
			--snipers 33-48 NORTH
			if x.epilospawn[index+32] == 0 and GetDistance(x.player, "epsnip1", index) < (x.spawnrange+10) then --400 visibilityrange in map
				x.epilo[index+32] = BuildObject("sspilors01", 6, "epsnip1", index)
				SetSkill(x.epilo[index+32], 3) --sniper need help
				SetWeaponMask(x.epilo[index+32], 10)
				Deploy(x.epilo[index+32])
				FireAt(x.epilo[index+32], x.player, true) --so will deploy to snip right away, and will shoot player at long range
				x.epilospawn[index+32] = 1
			--elseif x.epilospawn[index+32] == 1 and IsAlive(x.epilo[index+32]) and GetCurAmmo(x.epilo[index+32]) < math.floor(GetMaxAmmo(x.epilo[index+32]) * 0.5)) then
				--AddAmmo(x.epilo[index+32], 80) --so can snipe faster
			elseif x.epilospawn[index+32] == 1 and IsAlive(x.epilo[index+32]) and GetCurLocalAmmo(x.epilo[index+32], 2) < 1 then --NEED TO SWITCH TO LOCAL B/C SNIPE NOW LOCAL
				SetCurLocalAmmo(x.epilo[index+32], 3, 2) --so can snipe faster
			end
			
			--snipers 49-64 EAST
			if x.epilospawn[index+48] == 0 and GetDistance(x.player, "epsnip2", index) < (x.spawnrange+10) then --400 visibilityrange in map
				x.epilo[index+48] = BuildObject("sspilors01", 6, "epsnip2", index)
				SetSkill(x.epilo[index+48], 3) --sniper need help
				SetWeaponMask(x.epilo[index+48], 10)
				Deploy(x.epilo[index+48])
				FireAt(x.epilo[index+48], x.player, true) --so will deploy to snip right away, and will shoot player at long range
				x.epilospawn[index+48] = 1
			--elseif x.epilospawn[index+48] == 1 and IsAlive(x.epilo[index+48]) and GetCurAmmo(x.epilo[index+48]) < math.floor(GetMaxAmmo(x.epilo[index+48]) * 0.5) then
				--AddAmmo(x.epilo[index+48], 80) --so can snipe faster
			elseif x.epilospawn[index+48] == 1 and IsAlive(x.epilo[index+48]) and GetCurLocalAmmo(x.epilo[index+48], 2) < 1 then --NEED TO SWITCH TO LOCAL B/C SNIPE NOW LOCAL
				SetCurLocalAmmo(x.epilo[index+48], 3, 2) --so can snipe faster
			end
			
			--snipers 65-80 NORTHEAST
			if x.epilospawn[index+64] == 0 and GetDistance(x.player, "epsnip3", index) < (x.spawnrange+10) then --400 visibilityrange in map
				x.epilo[index+64] = BuildObject("sspilors01", 6, "epsnip3", index)
				SetSkill(x.epilo[index+64], 3) --sniper need help
				SetWeaponMask(x.epilo[index+64], 10)
				Deploy(x.epilo[index+64])
				FireAt(x.epilo[index+64], x.player, true) --so will deploy to snip right away, and will shoot player at long range
				x.epilospawn[index+64] = 1
			--elseif x.epilospawn[index+64] == 1 and IsAlive(x.epilo[index+64]) and GetCurAmmo(x.epilo[index+64]) < math.floor(GetMaxAmmo(x.epilo[index+64]) * 0.5) then
				--AddAmmo(x.epilo[index+64], 80) --so can snipe faster
			elseif x.epilospawn[index+64] == 1 and IsAlive(x.epilo[index+64]) and GetCurLocalAmmo(x.epilo[index+64], 2) < 1 then --NEED TO SWITCH TO LOCAL B/C SNIPE NOW LOCAL
				SetCurLocalAmmo(x.epilo[index+64], 3, 2) --so can snipe faster
			end
		end
	end
	
	--PLAYER AT BRIDGE, GIVE ORDERS
	if x.playerstate == 2 and GetDistance(x.player, ("pcrate%d"):format(x.eroute)) < 300 then
		ClearObjectives()
		AddObjective("tcrs0703.txt", "CYAN")
		AddObjective(" ")
		AddObjective("tcrs0704.txt")
		x.playerstate = 3
	end
	
	--HIGHLIGHT TARGET APC WHEN CLOSE TO CRATE --works better than player targeting
	if not x.targetset and IsAlive(x.eapc[x.targetapc]) and GetDistance(x.eapc[x.targetapc], ("pcrate%d"):format(x.eroute)) < 40 then
		SetObjectiveOn(x.eapc[x.targetapc])
		x.targetset = true
	end
	
	--CONVOY GOT PAST BRIDGE
	if not x.eapcpast and IsAlive(x.eapc[x.targetapc]) and (GetDistance(x.eapc[x.targetapc], "eppast1") < 50 or GetDistance(x.eapc[x.targetapc], "eppast2") < 50) then
		AudioMessage("tcrs0706.wav") --Imbecile convoy past crates.
		ClearObjectives()
		AddObjective("tcrs0708.txt", "YELLOW")
		x.eapcpast = true
	end
	
	--CHECK STATUS OF MCA ----------------------------------
	if not x.MCAcheck then
		if IsAlive(x.eapc[x.targetapc]) and GetDistance(x.eapc[x.targetapc], "ephome") < 100 then
			AudioMessage("tcrs0707.wav") --FAIL - Russians now have tech.
			ClearObjectives()
			AddObjective("tcrs0709.txt", "RED")
			TCC.FailMission(GetTime() + 13.0, "tcrs07f1.des")
			x.MCAcheck = true
			x.spine = 666
		end
		
		if x.playerstate == 1 and (not IsAlive(x.ecom) or not IsAlive(x.epwr[1]) or not IsAlive(x.epwr[2]) or not IsAlive(x.epwr[3]) or not IsAlive(x.epwr[4])) then
			ClearObjectives()
			AddObjective("You were not authorized to destroy that.", "RED")
			AddObjective(" ")
			AddObjective("MISSION FAILED!", "RED")
			TCC.FailMission(GetTime() + 3.0, "tcrs07f1.des")
			x.MCAcheck = true
			x.spine = 666
		end
	end
end 

function ObjectSniped(p, k) --SO PLAYER KNOWS THEY WERE SNIPED FER SUR
	if p == x.player then
		SetColorFade(10.0, 0.5, "DKRED")
		ClearObjectives()
		AddObjective("tcrs0817.txt", "RED")
		AudioMessage("alertpulse.wav")
		TCC.FailMission(GetTime() + 3.0, "tcrs07f2.des") --LOSER LOSER LOSER
		MCAcheck = true
		x.spine = 666
	end
end
--[[END OF SCRIPT]]