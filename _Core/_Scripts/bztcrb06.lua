--bztcrb06 - Battlezone Total Command - The Red Brigade - 6/8 - CLEAR THE PATH
assert(load(assert(LoadFile("_requirefix.lua")),"_requirefix.lua"))();
TCC = require("TC_Core")
MisnNum = 36;
local index = 0
local index2 = 0
local x = {
	FIRST = true,
	spine = 0,
	getiton = false, 
	MCAcheck = false,
	waittime = 99999.9,
	playfail = false, 
	casualty = 0, 
	player = nil, 
	mytank = nil, 
	skillsetting = 0,	
	pos = {}, 
	pilot = nil, 
	audio1 = nil, 
	audio6 = nil, 
	fnav = {},
	fgrp = {}, --CCA mission specific
	fgrpcount = 0, 
	frcy = nil, 
	ftank = nil, 
	ewlk = {}, 
	ewlklength = 10, 
	ewlkrecy = 0, 
	etrip = {}, --tripline stuff 
	etripstate = 0, 
	etriptime = 99999.9, 
	ewlkstate = 0, --redline stuff
	eredtime = 99999.9, 
	eminlife = {}, --mine stuff
	eminlifetotal = 2, 
	emintime = 99999.9, --eminelayers
	emingo = {}, 
	emin = {}, 
	emincool = {}, 
	eminallow = {},	
	eart = {}, --artl stuff
	edef = nil, 
	eartfound = {0, 0}, 
	esilalldead = false, --silo stuff
	esiltotal = 6,
	esilstate = {}, 
	esilkill = {}, 
	esil = {}, 
	eturtime = 99999.9, --turr stuff
	eturlength = 6, 
	eturcount = {},
	etur = {}, 
	eturcool = {}, 
	eturallow = {}, 
	eturlivestotal = 3, 
	epattime = 99999.9, --epatrols
	epatlength = 4, 
	epat = {}, 
	epatcool = {}, 
	epatreduce = {}, --special this mission
	epatallow = {}, 
	eatk = {}, --ebase attacks
	eatklength = 0, 
	ered = {}, --redline attack forces
	ewlksafetime = 99999.9, 
	etec = nil, 
	ehqr = nil, 
	ebay = nil,
  egun = {}, 
	proxmine = {},	
	LAST = true
}
--PATHS: fnav1-2 (me them), pmine1-3, epspn1-5, epartnav1-2, epart1_1-2, epart2_1-2, edef1_1, edef2_1, eptripline, epredline, eptur1-6, pmine1-30, ppatrol1-4

function InitialSetup()
	SetAutoGroupUnits(true)
	
	local odfpreload = {
		"bbgtow", "bvturr", "bvscout", "bvmbike", "bvmisl", "bvtank", "bvrckt", "bvwalk", "bvartl", "bvmine", 
		"svrecyrb05", "svwalk", "svtank", "gstbsa_c", "oproxa", "apcamrs"
	}
	for k,v in pairs(odfpreload) do
		PreloadODF(v)
	end
	
	x.mytank = GetHandle("mytank")
	x.frcy = GetHandle("frcy")
	x.etec = GetHandle("etec")
	x.ehqr = GetHandle("ehqr")
	x.ebay = GetHandle("ebay")
  for index = 1, 8 do  --added so cell will be later build
    x.egun[index] = GetHandle(("egun%d"):format(index))
  end
	for index = 1, x.esiltotal do
		x.esil[index] = GetHandle(("escv%d"):format(index))
	end
	for index = 1, 6 do --the player force
		x.fgrp[index] = GetHandle(("fgrp%d"):format(index))
	end	
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
	if (IsAlive(h) and GetRace(h) == "b") then
		SetEjectRatio(h, 0);
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

function PreDamage(curWorld, h, DamageType, pContext, value, base, armor, shield, owner, source, SelfDamage, FriendlyFireDamage)
	return TCC.PreDamage(curWorld, h, DamageType, pContext, value, base, armor, shield, owner, source, SelfDamage, FriendlyFireDamage);
end

function Update()
	x.player = GetPlayerHandle() --EVERY PASS SO IF PLAYER CHANGES VEHICLES
	x.skillsetting = IFace_GetInteger("options.play.difficulty")
	TCC.Update()
	
	--Set up mission basics
	if x.spine == 0 then
		x.audio1 = AudioMessage("tcrb0601.wav") --INTRO - break through canyon defense. Destroy Bdogs
		x.pos = GetTransform(x.mytank)
		RemoveObject(x.mytank)
		x.mytank = BuildObject("svtank", 1, x.pos)
		GiveWeapon(x.mytank, "gstbsa_c")
		SetAsUser(x.mytank, 1)
		RemoveObject(x.player)
		x.player = GetPlayerHandle()
		for index = 1, 6 do
			x.pos = GetTransform(x.fgrp[index])
			RemoveObject(x.fgrp[index])
			x.fgrp[index] = BuildObject("svwalk", 1, x.pos)
			SetSkill(x.fgrp[index], 3)
		end
		for index = 1, 3 do
			SetGroup(x.fgrp[index], 0)
		end
		for index = 4, 6 do
			SetGroup(x.fgrp[index], 1)
		end
		x.pos = GetTransform(x.frcy)
		RemoveObject(x.frcy)
		x.frcy = BuildObject("svrecyrb05", 1, x.pos) --USE THE SAME AS RB05 MISSION
		for index = 1, 6 do
			SetSkill(x.fgrp[index], x.skillsetting)
		end
    for index = 1, 8 do
      x.pos = GetTransform(x.egun[index])
      RemoveObject(x.egun[index])
      x.egun[index] = BuildObject("bbgtow", 5, x.pos)
    end
		x.emintime = GetTime()
		for index = 1, 3 do
			x.emin[index] = BuildObject("bvmine", 5, ("epmin%d"):format(index)) --BUILD INITIAL GROUP
			SetSkill(x.emin[index], x.skillsetting)
			SetObjectiveName(x.emin[index], ("Unabomber %d"):format(index)) --BUILD INIT GROUP
			x.eminlife[index] = 1
			x.emingo[index] = true --SPECIAL SO WILL GO RIGHT AWAY
		end
		for index = 1, x.esiltotal do
			x.esilstate[index] = 0
			x.esilkill[index] =false
		end
		x.eturtime = GetTime()
		for index = 1, x.eturlength do --init etur
			x.etur[index] = BuildObject("bvturr", 5, ("eptur%d"):format(index)) --BUILD INITIAL GROUP
			SetSkill(x.etur[index], x.skillsetting)
			x.eturcool[index] = GetTime()
			x.eturallow[index] = false --special since seed built above
			x.eturcount[index] = 1 --how many lives has "index" tur existed
		end
		x.epattime = GetTime() --init epat
		for index = 1, x.epatlength do --init epat
			x.epatcool[index] = GetTime()
			x.epatreduce[index] = 0.0
			x.epatallow[index] = true
		end
		for index = 1, 2 do --1-4 avail
			x.eart[index] = BuildObject("bvartl", 5, ("epart1_%d"):format(index)) --west
			SetSkill(x.eart[index], x.skillsetting)
			x.eart[index+2] = BuildObject("bvartl", 5, ("epart2_%d"):format(index)) --east
			SetSkill(x.eart[index+2], x.skillsetting)
		end
		x.edef = BuildObject("bvturr", 5, "epdef1_1")
		SetSkill(x.edef, x.skillsetting)
		x.edef = BuildObject("bvturr", 5, "epdef2_1")
		SetSkill(x.edef, x.skillsetting)
		for index = 1, 30 do --prox mines
			x.proxmine[index] = BuildObject("oproxa", 5, "pmine", index)
		end
		x.fnav[1] = BuildObject("apcamrs", 1, "fnav1")
		SetObjectiveName(x.fnav[1], "CCA Base")
		x.fnav[2] = BuildObject("apcamrs", 1, "fnav2")
		SetObjectiveName(x.fnav[2], "BDS Outpost")
		SetScrap(1, 40)
		x.spine = x.spine + 1
	end
	
	--SEND FIRST OBJECTIVE
	if x.spine == 1 and IsAudioMessageDone(x.audio1) then
		ClearObjectives()
		AddObjective("tcrb0601.txt")
		x.waittime = GetTime() + 60.0
		x.spine = x.spine + 1
	end

	--SEND FIRST ATTACK
	if x.spine == 2 and x.waittime < GetTime() then
		x.eatk[1] = BuildObject("bvmbike", 5, "epspn1")
		x.eatk[2] = BuildObject("bvmisl", 5, "epspn2")
		x.eatk[3] = BuildObject("bvscout", 5, "epspn1")
		x.eatk[4] = BuildObject("bvscout", 5, "epspn2")
		for index = 1, 4 do
			SetSkill(x.eatk[index], x.skillsetting)
			Attack(x.eatk[index], x.frcy)
		end
		x.spine = x.spine + 1
	end

	--CHECK IF BDS OUTPOST DESTROYED
	if x.spine == 3	and not IsAlive(x.etec) and not IsAlive(x.ehqr) and not IsAlive(x.ebay) then
		x.audio1 = AudioMessage("tcrb0609.wav") --SUCCEED We broke enemy lines. Will crush when reinforce arrive.
		ClearObjectives()
		AddObjective("tcrb0602.txt", "GREEN")
		x.MCAcheck = true
		x.spine = x.spine + 1
	end
	
	--SUCCEED MISSION
	if x.spine == 4 and IsAudioMessageDone(x.audio1) then
		TCC.SucceedMission(GetTime(), "tcrb06w1.des") --WINNER WINNER WINNER
		x.spine = x.spine + 1
	end
	----------END MAIN SPINE ----------
	
	--PLAYER FINDS MINEFIELD
	if not x.eminefound and ((GetDistance(x.player, "epmin1") < 200) or (GetDistance(x.player, "epmin2") < 200) or (GetDistance(x.player, "epmin3") < 200)) then
		AudioMessage("tcrb0602.wav") --Mines ahead
		x.eminefound = true
	end
	
	--BDS MINELAYER SQUAD ---SPECIAL FOR THIS MISSION LIMITED LIVES -------------------------------
	if x.emintime < GetTime() then
		for index = 1, 3 do
			if x.eminlife[index] < x.eminlifetotal and not x.eminallow[index] and (not IsAlive(x.emin[index]) or (IsAlive(x.emin[index]) and GetTeamNum(x.emin[index]) == 1)) then
				x.emincool[index] = GetTime() + 240.0
				x.eminallow[index] = true
			end
			
			if x.eminallow[index] and x.emincool[index] < GetTime() then
				x.emin[index] = BuildObject("bvmine", 5, "epspn2")
				SetSkill(x.emin[index], x.skillsetting)
				SetObjectiveName(x.emin[index], ("Unabomber %d"):format(index))
				Goto(x.emin[index], ("epmin%d"):format(index)) --resend orders
				x.eminlife[index] = x.eminlife[index] + 1 --SPECIAL THIS MISSION
				x.emingo[index] = true
				x.eminallow[index] = false
				x.emintime = GetTime() + 120.0
			end
			
			if IsAlive(x.emin[index]) and GetCurAmmo(x.emin[index]) <= math.floor(GetMaxAmmo(x.emin[index]) * 0.5) and GetTeamNum(x.emin[index]) ~= 1 then
				SetCurAmmo(x.emin[index], GetMaxAmmo(x.emin[index]))
				Goto(x.emin[index], ("epmin%d"):format(index)) --resend orders
				x.emingo[index] = true
			end
			
			if x.emingo[index] and GetDistance(x.emin[index], ("epmin%d"):format(index)) < 30 and GetTeamNum(x.emin[index]) ~= 1 then
				Mine(x.emin[index], ("epmin%d"):format(index))
				x.emingo[index] = false
			end
		end
	end

	--BDS ARTILLERY
	if not x.getiton then --for collapse		
		if x.eartfound[1] == 0 then
			x.ftank = GetNearestVehicle("epartnav1")
			if (GetTeamNum(x.ftank) == 1 and GetDistance(x.ftank, "epartnav1") < 350) or (GetDistance(x.player, "epartnav1") < 350) then
				AudioMessage("tcrb0605.wav") --Instrument detect BDog artil. It is marked on your radar. NAV
				x.fnav[1] = BuildObject("apcamrs", 1, "epartnav1")
				SetObjectiveName(x.fnav[1], "West Artillery")
				SetObjectiveOn(x.fnav[1])
				x.eartfound[1] = 1
			end
		elseif x.eartfound[1] == 1 and not IsAlive(x.eart[1]) and not IsAlive(x.eart[2]) then
			AudioMessage("tcrb0606.wav") --NIO - We cleared artillery. Continue to push forward.
			x.eartfound[1] = 2
		end
		
		if x.eartfound[2] == 0 then
			x.ftank = GetNearestVehicle("epartnav2")
			if (GetTeamNum(x.ftank) == 1 and GetDistance(x.ftank, "epartnav2") < 350) or (GetDistance(x.player, "epartnav2") < 350) then
				AudioMessage("tcrb0605.wav") --Instrument detect BDog artil. It is marked on your radar. NAV
				x.fnav[2] = BuildObject("apcamrs", 1, "epartnav2")
				SetObjectiveName(x.fnav[2], "East Artillery")
				SetObjectiveOn(x.fnav[2])
				x.eartfound[2] = 1
			end
		elseif x.eartfound[2] == 1 and not IsAlive(x.eart[3]) and not IsAlive(x.eart[4]) then
			AudioMessage("tcrb0606.wav") --NIO - We cleared artillery. Continue to push forward.
			x.eartfound[2] = 2
		end
	end
	
	--BDS SILO escv1 AND escv2 KILLS
	if not x.esilalldead then
		for index = 1, x.esiltotal do
			if x.esilstate[index] == 0 and not IsAlive(x.esil[index]) then
				x.eatk[1] = BuildObject("bvscout", 5, ("epspn1"):format(index))
				x.eatk[2] = BuildObject("bvscout", 5, ("epspn2"):format(index))
				x.eatk[3] = BuildObject("bvmbike", 5, ("epspn1"):format(index))
				x.eatk[4] = BuildObject("bvmbike", 5, ("epspn2"):format(index))
				x.eatk[5] = BuildObject("bvmisl", 5, ("epspn1"):format(index))
				x.eatklength = 5
				if not IsAlive(x.esil[4]) or not IsAlive(x.esil[5]) or not IsAlive(x.esil[6]) then
					x.eatk[6] = BuildObject("bvmisl", 5, ("epspn2"):format(index))
					x.eatk[7] = BuildObject("bvtank", 5, ("epspn1"):format(index))
					x.eatk[8] = BuildObject("bvtank", 5, ("epspn2"):format(index))
					x.eatk[9] = BuildObject("bvrckt", 5, ("epspn1"):format(index))
					x.eatk[10] = BuildObject("bvrckt", 5, ("epspn2"):format(index))
					x.eatklength = 10
				end
				for index2 = 1, x.eatklength do
					SetSkill(x.eatk[index2], x.skillsetting)
					Attack(x.eatk[index2], x.frcy)
				end
				if not x.esilkill[1] and not IsAlive(x.esil[1]) then
					AudioMessage("tcrb0603.wav") --The Bdog counterattacking from NW
					x.esilkill[1] = true
				end
				if not x.esilkill[2] and not IsAlive(x.esil[2]) then
					AudioMessage("tcrb0604.wav") --NIO - The BDog counterattacking from SE
					x.esilkill[2] = true
				end
				x.esilstate[index] = x.esilstate[index] + 1
			end
			
			if not IsAlive(x.esil[index]) then
				x.casualty = x.casualty + 1
			end
			if x.casualty == x.esiltotal then
				x.esilalldead = true
			end
			x.casualty = 0
		end
	end
	
	--BDS TRIPLINE ATTACKS
	if x.etripstate == 0 and GetDistance(x.player, "eptripline") < 150 then
		AudioMessage("tcrb0607.wav") --NIO - The BDogs are well entrenched ahead.
		x.etriptime = GetTime() + 20.0
		x.etripstate = 1
	elseif x.etripstate == 1 and x.ewlkstate == 0 and x.etriptime < GetTime() then
		if not IsAlive(x.etrip[1]) then
			x.etrip[1] = BuildObject("bvmbike", 5, "epspn5")
		end
		if not IsAlive(x.etrip[2]) then
			x.etrip[2] = BuildObject("bvmisl", 5, "epspn5")
		end
		if not IsAlive(x.etrip[3]) then
			x.etrip[3] = BuildObject("bvtank", 5, "epspn5")
		end
		if not IsAlive(x.etrip[4]) then
			x.etrip[4] = BuildObject("bvrckt", 5, "epspn5")
		end
		for index = 1, 4 do
			SetSkill(x.etrip[index], x.skillsetting)
			Patrol(x.etrip[index], "eptripline")
		end
		x.etripstate = x.etripstate + 1
	elseif x.etripstate == 2 and x.etriptime < GetTime() then
		x.etriptime = GetTime() + 300.0
		x.etripstate = 1
	end

	--BDS REDLINE WALKER ATTACK
	if x.ewlkstate == 0 and GetMaxScrap(1) >= 70 and (not IsAlive(x.esil[4]) or not IsAlive(x.esil[5]) or not IsAlive(x.esil[6]) or GetDistance(x.player, "epredline") < 150) then
		AudioMessage("tcrb0608.wav") --NIO - The Bdogs moving their Sasquatch in prep for counterattack
		ClearObjectives()
		AddObjective("tcrb0606.txt", "YELLOW")
		for index = 1, x.ewlklength do
			x.ewlk[index] = BuildObject("bvwalk", 5, "epspn5")
			SetSkill(x.ewlk[index], x.skillsetting) --lil help
			Patrol(x.ewlk[index], "epredline")
		end
		x.ewlksafetime = GetTime() + 600.0 --safety timer
		x.ewlkstate = x.ewlkstate + 1
	--CONTROL WALKERS - b/c walkers aren't worth shit, and will ignore guntowers and other buildings to the point that they get gunned down. 
	--But holyfudgeripplecornsticks, will they stop to waste time and ammo on scavs ... even while a gt or tank is blasting them apart.
	--So play to their weaknesses, and stop them at locations where they might stop and actually shoot back at a gt.
	elseif x.ewlkstate == 1 then
		for index = 1, x.ewlklength do
			if GetDistance(x.ewlk[index], "epredline") < 50 then
				for index2 = 1, x.ewlklength do
					Stop(x.ewlk[index2])
				end
				x.waittime = GetTime() + 60.0
				x.ewlkstate = x.ewlkstate + 1
				break
			end
		end
	elseif x.ewlkstate == 2 and x.waittime < GetTime() then
		for index = 1, x.ewlklength do
			Patrol(x.ewlk[index], "eptripline")
		end
		x.ewlkstate = x.ewlkstate + 1
	elseif x.ewlkstate == 3 then
		for index = 1, x.ewlklength do
			if GetDistance(x.ewlk[index], "eptripline") < 50 then
				for index2 = 1, x.ewlklength do
					Stop(x.ewlk[index2])
				end
				x.waittime = GetTime() + 60.0
				x.ewlkstate = x.ewlkstate + 1
				break
			end
		end
	elseif x.ewlkstate == 4 and x.waittime < GetTime() then
		for index = 1, x.ewlklength do
			Patrol(x.ewlk[index], "fnav1")
		end
		x.waittime = 99999.9
		x.ewlkstate = x.ewlkstate + 1
	elseif x.ewlkstate == 5 then
		if x.ewlkrecy == 0 then --since ewlkstate advances elsewhere
			for index = 1, x.ewlklength do
				if GetDistance(x.ewlk[index], x.frcy) < 200 then
					for index2 = 1, x.ewlklength do
						Attack(x.ewlk[index], x.frcy)
					end
					x.ewlkrecy = 1
					break
				end
			end
		end
	--EWALKSTATE IS INCREMENTED BELOW TO 6
	elseif x.ewlkstate == 6 and x.waittime < GetTime() then
		AudioMessage("tcrb0612.wav") --NIO -I recog a good strat posit. Move MUF. U know 2 if U good Cmd
		ClearObjectives()
		AddObjective("tcrb0603.txt")
		AddObjective("SAVE", "DKGREY")
		x.fnav[3] = BuildObject("apcamrs", 1, "epredline")
		SetObjectiveName(x.fnav[3], "Redeploy Grozny")
		x.waittime = GetTime() + 300.0
		StartCockpitTimer(300, 150, 60)
		x.ewlkstate = x.ewlkstate + 1
	elseif x.ewlkstate == 7 then
		if (GetDistance(x.frcy, "epredline") <= 200) and IsOdf(x.frcy, "sbrecyrb05") and x.waittime >= GetTime() then
			StopCockpitTimer()
			HideCockpitTimer()
			ClearObjectives()
			AddObjective("tcrb0601.txt")
			x.waittime = GetTime() + 120.0
			x.ewlkstate = x.ewlkstate + 1
		elseif IsOdf(x.frcy, "svrecyrb05") and x.waittime < GetTime() then
			x.ewlkstate = 100 --KEEP, 100 IS A FAIL STATE
		end
	elseif x.ewlkstate == 8 and x.waittime < GetTime() then
		for index = 1, 4 do
			x.ered[index] = BuildObject("bvscout", 5, ("epspn%d"):format(index))
			x.ered[index+4] = BuildObject("bvmbike", 5, ("epspn%d"):format(index))
			x.ered[index+8] = BuildObject("bvmisl", 5, ("epspn%d"):format(index))
			x.ered[index+12] = BuildObject("bvtank", 5, ("epspn%d"):format(index))
			x.ered[index+16] = BuildObject("bvrckt", 5, ("epspn%d"):format(index))
			x.ered[index+20] = BuildObject("bvwalk", 5, "epspn5")
		end
		for index = 1, 24 do
			SetSkill(x.ered[index], x.skillsetting)
			Attack(x.ered[index], x.frcy)
		end
		x.waittime = GetTime() + 10.0
		x.ewlkstate = x.ewlkstate + 1
	elseif x.ewlkstate == 9 and x.waittime < GetTime() then
		AudioMessage("tcrb0613.wav") --NIO - It’s a trap. We're being surrounded.
		x.ewlkstate = x.ewlkstate + 1
	elseif x.ewlkstate == 10 then
		x.ftank = GetWhoShotMe(x.frcy)
		if GetTeamNum(x.ftank) == 5 then
			AudioMessage("tcrb0610.wav") --NIO - Our attack outpost (base?) is under heavy attack.
			x.ewlkstate = x.ewlkstate + 1
		end
	elseif x.ewlkstate == 100 then --fail to relocate and redeploy recycler
		ClearObjectives()
		AddObjective("tcrb0605.txt", "RED") --REUSE FROM OTHER MISSION
		x.audio1 = AudioMessage("tcrb0113.wav") --FAIL – B2 need more competent officer --REUSE FROM OTHER MISSION
		x.spine = 666
		x.MCAcheck = true
		x.ewlkstate = 200 --KEEP, 200 IS A FAIL STATE
	elseif x.ewlkstate == 200 and IsAudioMessageDone(x.audio1) then
		TCC.FailMission(GetTime(), "tcrb06f2.des") --LOSER LOSER LOSER
		x.ewlkstate = x.ewlkstate + 1
	end
	
	--INCREMENT TO 6 ABOVE
	if x.ewlkstate > 1 and x.ewlkstate < 6 then
		for index = 1, x.ewlklength do --do casualty check
			if not IsAlive(x.ewlk[index]) then
				x.casualty = x.casualty + 1
			end
		end
		if (x.casualty >= math.floor(x.ewlklength * 0.8)) or x.ewlksafetime < GetTime() then
			x.ewlksafetime = 99999.9
			x.ewlkstate = 6 --//////////////////////////////////////////////
			x.waittime = GetTime() + 30.0
		end
		x.casualty = 0
	end
	
	--BDS GROUP TURRET GENERIC ----------------------------------
	if x.eturtime < GetTime() then
		for index = 1, x.eturlength do
			if not IsAlive(x.etur[index]) and not x.eturallow[index] and x.eturcount[index] < x.eturlivestotal then
				x.eturcool[index] = GetTime() + 300.0
				x.eturallow[index] = true
			end
			if x.eturallow[index] and x.eturcool[index] < GetTime() and x.eturcount[index] < x.eturlivestotal then
				if x.eturallow[1] and x.eturcool[1] < GetTime() and x.eturcount[1] < x.eturlivestotal then
					x.etur[1] = BuildObject("bvturr", 5, "epspn1")
				elseif x.eturallow[2] and x.eturcool[2] < GetTime() and x.eturcount[2] < x.eturlivestotal then
					x.etur[2] = BuildObject("bvturr", 5, "epspn2")
				elseif x.eturallow[3] and x.eturcool[3] < GetTime() and x.eturcount[3] < x.eturlivestotal then
					x.etur[3] = BuildObject("bvturr", 5, "epspn2")
				else
					x.etur[index] = BuildObject("bvturr", 5, "epspn5")
				end
				SetSkill(x.etur[index], x.skillsetting)
				Goto(x.etur[index], ("eptur%d"):format(index))
				x.eturallow[index] = false
				x.eturcount[index] = x.eturcount[index] + 1
			end
		end
		x.eturtime = GetTime() + 30.0
	end
	
	--BDS GROUP SCOUT PATROLS ----------------------------------
	if x.epattime < GetTime() then
		for index = 1, x.epatlength do
			if not IsAlive(x.epat[index]) and not x.epatallow[index] then
				x.epatcool[index] = GetTime() + 180.0 - x.epatreduce[index]
				x.epatallow[index] = true
				if x.epatreduce[index] < 120.0 then
					x.epatreduce[index] = x.epatreduce[index] + 10.0
				end
			end
			if x.epatallow[index] and x.epatcool[index] < GetTime() then
				x.epat[index] = BuildObject("bvtank", 5, "ppatrol1")
				SetSkill(x.epat[index], x.skillsetting)
				Patrol(x.epat[index], ("ppatrol%d"):format(index))
				--SetObjectiveName(x.epat[index], ("Patrol %d"):format(index))
				x.epatallow[index] = false
			end
		end
		x.epattime = GetTime() + 30.0
	end
	
	--CHECK STATUS OF MCA ----------------------------------
	if not x.MCAcheck then	
		if not IsAlive(x.frcy) and not x.playfail then --frecy killed
			ClearObjectives()
			AddObjective("tcrb0604.txt", "RED")
			x.audio6 = AudioMessage("tcrb0611.wav") --NIO - FAIL - Recy Grozny	lost (fearsome redoubtable, also Chechen cap city)
			x.spine = 666
			x.playfail = true
		elseif x.playfail and IsAudioMessageDone(x.audio6) then
			TCC.FailMission(GetTime(), "tcrb06f1.des") --LOSER LOSER LOSER
			x.MCAcheck = true
		end
	end
end
--[[END OF SCRIPT]]