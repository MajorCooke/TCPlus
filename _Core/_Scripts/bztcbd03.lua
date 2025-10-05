--bztcbd03 - Battlezone Total Command - Rise of the Black Dogs - 3/10 - EXPLORATORY
assert(load(assert(LoadFile("_requirefix.lua")),"_requirefix.lua"))();
TCC = require("TC_Core")
MisnNum = 7;
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
	fnav = {},	
	casualty = 0,
	repel = {}, 
	value1 = 0, 
	value2 = 0, 
	finalrun = false, 
	finaltime = 99999.9, 
	warnstate = {},
	warntime = {99999.9, 99999.9, 99999.9}, 
	fdrp = nil, 
	fdrppos = {}, 
	etug = nil, 
	emam = nil, 
	ercy = nil, 
	ecom = {}, 
	ehng = nil, 
	etec = nil, 
	emam = nil, 
	etur = {}, 
	epwr = {}, 
	egun = {}, 
	etrn = nil, 
	eatk = {}, 
	eatkstate = {},
	eatktime = {}, 
	epatstate = {}, 
	epattime = {}, 
	failstate = 0, 
	gtowatk = false, 
	gtowtug = false, 
	camstate = 0, 
	camtime = 99999.9, 
	camfov = 60,  --185 default
	userfov = 90,  --seed
	LAST = true
}
--PATHS: pmytank, pcam1, fpnav1-5, epatk1-16, eptur1-8, ppatrol1-4,13-16(0-5)

function InitialSetup()
	SetAutoGroupUnits(true)
		
	local odfpreload = {
		"bspilobd03", "bvdrop", "sbtrain", "svscout", "svrckt", "svturr", "repelenemy400", "apcamrb" 
	}
	for k,v in pairs(odfpreload) do
		PreloadODF(v)
	end
	
	x.mytank = GetHandle("mytank")
	x.ercy = GetHandle("ercy")
	x.ehng = GetHandle("ehng")
	x.etec = GetHandle("etec")
	x.etrn = GetHandle("etrn")
	x.emam = GetHandle("emam")
	x.ecom[1] = GetHandle("ecom1")
	x.ecom[2] = GetHandle("ecom2")
	x.ecom[3] = GetHandle("ecom3")
	x.fdrp = GetHandle("fdrop")
	x.etug = GetHandle("etug")
	for index = 1, 8 do 
		x.egun[index] = GetHandle(("egun%d"):format(index))
	end
	for index = 1, 6 do
		x.epwr[index] = GetHandle(("epwr%d"):format(index))
	end
	for index = 5, 8 do --ally stuff
		for index2 = 5, 8 do
			Ally(index, index2)
		end
	end
	
	SetColorFade(6.0, 0.5, "BLACK")
	TCC.InitialSetup();
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

function Update()
	x.player = GetPlayerHandle() --EVERY PASS SO IF PLAYER CHANGES VEHICLES
	x.skillsetting = IFace_GetInteger("options.play.difficulty")
	TCC.Update();
	--START THE MISSION BASICS
	if x.spine == 0 then
		x.audio1 = AudioMessage("tcbd0301.wav") --Welcome to Mars, Cobra one. disturbing reports about super-weapon, codenamed, Mammoth.
		x.pos = GetTransform(x.mytank)
		RemoveObject(x.mytank)
		x.mytank = BuildObject("bspilobd03", 1, x.pos) --doing special pilot
		SetAsUser(x.mytank, 1)
		RemoveObject(x.player)
		x.player = GetPlayerHandle()
		x.pos = GetTransform(x.etrn)
		RemoveObject(x.etrn)
		x.etrn = BuildObject("sbtrain", 5, x.pos)
		x.camstate = 1
    x.userfov = IFace_GetInteger("options.graphics.defaultfov")
    CameraReady()
    IFace_SetInteger("options.graphics.defaultfov", x.camfov)
		x.spine = x.spine + 1
	end
	
	--BUILD STUFF WHILE CAMERA RUNNING
	if x.spine == 1 then
		x.repel[1] = BuildObject("repelenemy400", 5, x.ecom[2])
		x.repel[2] = BuildObject("repelenemy400", 5, x.ecom[3])
		x.repel[3] = BuildObject("repelenemy400", 5, x.emam)
		for index = 6, 8 do
			x.eatkstate[index] = 0
			x.eatktime[index] = GetTime()
			x.warnstate[index] = 0
		end
		for index = 13, 16 do
			x.epatstate[index] = 0 
			x.epattime[index] = GetTime()
		end
		x.fdrppos = GetTransform(x.fdrp)
		RemoveObject(x.fdrp)
		for index = 1, 8 do 
			x.etur[index] = BuildObject("svturr", 5, "eptur", index)
			SetSkill(x.etur[index], x.skillsetting)
		end
		x.eatk[1] = BuildObject("svscout", 5, "epatk", 1) --grp 1
		x.eatk[2] = BuildObject("svrckt", 5, "epatk", 2)
		x.eatk[3] = BuildObject("svrckt", 5, "epatk", 3)
		x.eatk[4] = BuildObject("svscout", 5, "epatk", 4) --grp 2
		x.eatk[5] = BuildObject("svrckt", 5, "epatk", 5)
		x.eatk[6] = BuildObject("svrckt", 5, "epatk", 6)
		x.eatk[7] = BuildObject("svscout", 5, "epatk", 7) --grp 3
		x.eatk[8] = BuildObject("svrckt", 5, "epatk", 8)
		x.eatk[9] = BuildObject("svrckt", 5, "epatk", 9)
		x.eatk[10] = BuildObject("svscout", 5, "epatk", 10) --grp 4
		x.eatk[11] = BuildObject("svrckt", 5, "epatk", 11)
		x.eatk[12] = BuildObject("svrckt", 5, "epatk", 12)
		x.eatk[13] = BuildObject("svscout", 5, "epatk", 13) --detached
		x.eatk[14] = BuildObject("svscout", 5, "epatk", 14)
		x.eatk[15] = BuildObject("svscout", 5, "epatk", 15)
		x.eatk[16] = BuildObject("svscout", 5, "epatk", 16)
		for index = 1, 16 do 
			SetSkill(x.eatk[index], x.skillsetting)
		end
		for index = 1, 3 do
			Patrol(x.eatk[index], "ppatrol1")
			Patrol(x.eatk[index+3], "ppatrol2")
			Patrol(x.eatk[index+6], "ppatrol3")
			Patrol(x.eatk[index+9], "ppatrol4")
		end
		for index = 13, 16 do
			Patrol(x.eatk[index], ("ppatrol%d"):format(index))
		end
		x.spine = x.spine + 1
	end
	
	--GIVE FIRST OBJECTIVE
	if x.spine == 2 and (IsAudioMessageDone(x.audio1) or CameraCancelled()) then
		x.camstate = 0
    CameraFinish()
    IFace_SetInteger("options.graphics.defaultfov", x.userfov)
		AddObjective("tcbd0301.txt")
		x.fnav[1] = BuildObject("apcamrb", 1, "fpnav1")
		SetObjectiveName(x.fnav[1], "Goto Hangar")
		SetObjectiveOn(x.fnav[1])
		x.spine = x.spine + 1	
	end
	
	--AT HANGAR, GOTO TUG
	if x.spine == 3 and IsAlive(x.player) and IsAlive(x.ehng) and GetDistance(x.player, x.ehng) < 64 then
		AudioMessage("tcbd0302.wav") --According to the hangar computer, there is a tug at Nav2.
		ClearObjectives()
		AddObjective("tcbd0301.txt", "GREEN")
		AddObjective("	")
		AddObjective("tcbd0302.txt")
		SetObjectiveOff(x.fnav[1])
		x.fnav[2] = BuildObject("apcamrb", 1, "fpnav2")
		SetObjectiveName(x.fnav[2], "Steal Tug")
		SetObjectiveOn(x.fnav[2])
		x.failstate = 1
		RemovePilot(x.etug)
		RemoveObject(x.repel[1])
		x.spine = x.spine + 1
	end
	
	--GOT TUG, GOTO FIELD LAB
	if x.spine == 4 and IsAlive(x.player) and IsOdf(x.player, "svtug") then
		AudioMessage("tcbd0303.wav")
		ClearObjectives()
		AddObjective("tcbd0302.txt", "GREEN")
		AddObjective("	")
		AddObjective("tcbd0303.txt")
		SetObjectiveOff(x.fnav[2])
		x.fnav[3] = BuildObject("apcamrb", 1, "fpnav3")
		SetObjectiveName(x.fnav[3], "Destroy Field Lab")
		SetObjectiveOn(x.fnav[3])
		RemoveObject(x.repel[2])
		x.spine = x.spine + 1
	end
	
	--LAB DEAD, GOTO MAMMOTH
	if x.spine == 5 and not IsAlive(x.etec) then
		AudioMessage("tcbd0304.wav")
		ClearObjectives()
		AddObjective("tcbd0303.txt", "GREEN")
		AddObjective("	")
		AddObjective("tcbd0304.txt")
		SetObjectiveOff(x.fnav[3])
		x.fnav[4] = BuildObject("apcamrb", 1, "fpnav4")
		SetObjectiveName(x.fnav[4], "Inspect Mammoth")
		SetObjectiveOn(x.fnav[4])
		RemoveObject(x.repel[3])
		x.spine = x.spine + 1
	end
	
	--INSPECTED MAMMOTH
	if x.spine == 6 and IsAlive(x.emam) and IsInfo("svstnk") then
		x.audio1 = AudioMessage("tcbd0305.wav") --Goto extraction quick
		ClearObjectives()
		AddObjective("tcbd0304.txt", "GREEN")
		AddObjective("	")
		AddObjective("tcbd0305.txt", "CYAN")
		AddObjective("	")
		AddObjective("tcbd0306.txt")
		SetObjectiveOff(x.fnav[4])
		x.fnav[5] = BuildObject("apcamrb", 1, "fpnav5")
		SetObjectiveName(x.fnav[5], "Extraction")
		SetObjectiveOn(x.fnav[5])
		x.spine = x.spine + 1
	end
	
	--SPAWN DROPSHIP
	if x.spine == 7 then
		x.fdrp = BuildObject("bvdrop", 0, x.fdrppos)
		x.spine = x.spine + 1
	end
	
	--START THE ESCAPE CLOCK
	if x.spine == 8 and IsAudioMessageDone(x.audio1) then
		if x.skillsetting == x.easy then
			x.finaltime = GetTime() + 210.0
			StartCockpitTimer(210, 105, 52)
		elseif x.skillsetting == x.medium then
			x.finaltime = GetTime() + 180.0
			StartCockpitTimer(180, 90, 45)
		else
			x.finaltime = GetTime() + 150.0
			StartCockpitTimer(150, 75, 35)
		end
		if IsOdf(x.player, "svtug") then
			x.waittime = GetTime() + 30.0
		elseif IsPerson(x.player) then
			x.waittime = GetTime() + 80.0
		else
			x.waittime = GetTime() + 5.0
		end
		x.spine = x.spine + 1
	end
	
	--SEND IN ATTACK
	if x.spine == 9 and x.waittime < GetTime() then
		x.finalrun = true
		SetPerceivedTeam(x.player, 1)
		for index = 1, 16 do
			SetSkill(x.eatk[index], x.skillsetting)
			Attack(x.eatk[index], x.player)
		end
		x.spine = x.spine + 1
	end
	
	--RUN DROPSHIP LANDING
	if x.spine == 10 and IsAlive(x.player) and GetDistance(x.player, "fpnav5") < 470 then
		SetAnimation(x.fdrp, "land", 1)
		x.spine = x.spine + 1
	end
	
	--DROPSHIP OPEN
	if x.spine == 11 and IsAlive(x.player) and GetDistance(x.player, "fpnav5") < 160 then
		SetAnimation(x.fdrp, "open", 1)
		x.spine = x.spine + 1
	end
	
	--MISSION SUCCESS
	if x.spine == 12 and IsAlive(x.player) and GetDistance(x.player, "fpnav5") < 64 then
		AudioMessage("emdotcox.wav")
		ClearObjectives()
		AddObjective("tcbd0306.txt", "GREEN")
		AddObjective("\n\nMISSION COMPLETE!", "GREEN")
		AudioMessage("win.wav")
		SetCurHealth(x.player, 10000)
		for index = 1, 16 do
			Retreat(x.eatk[index], "fpnav4")
		end
		x.finaltime = 99999.9
		x.finalrun = false
		TCC.SucceedMission(GetTime() + 5.0, "tcbd03w.des") --WINNER WINNER WINNER
		x.spine = 666
		x.MCAcheck = true
	end
	----------END MAIN SPINE ----------

	--CAMERA ON MAMMOTH
	if x.camstate == 1 then
		CameraPath("pcam1", 2000, 1000, x.emam)
	end
	
	--WARN IF TOO CLOSE
	if not x.finalrun and IsAlive(x.player) and (IsPerson(x.player) and IsAlive(x.etec) and GetDistance(x.player, x.etec) > 160) then
		for index = 6, 8 do
			if x.warnstate[index] == 0 and GetPower(index) >= 0 and IsAlive(x.ecom[index-5]) and IsAlive(x.player) and GetDistance(x.player, x.ecom[index-5]) < 300 then
				StartSoundEffect("alertpulse.wav")
				AddObjective("\n\nStay 280m from Comm Tower until destroyed or unpowered.", "YELLOW") --instead of 0307
				x.warntime[index-5] = GetTime() + 10.0
				x.warnstate[index] = 1
			end
			
			if x.eatkstate[index] == 0 and x.warntime[index-5] < GetTime() and GetPower(index) >= 0 and IsAlive(x.ecom[index-5]) and IsAlive(x.player) and IsPerson(x.player) and GetDistance(x.player, x.ecom[index-5]) < 280 then
				x.eatktime[index] = GetTime()
				x.eatkstate[index] = 1
			end
			
			if x.eatkstate[index] == 1 and x.eatktime[index] < GetTime() then
				if index == 6 then
					x.value1 = 1
					x.value2 = 3
				elseif index == 7 then
					x.value1 = 4
					x.value2 = 6
				elseif index == 8 then
					x.value1 = 7
					x.value2 = 9
				end
				for index2 = x.value1, x.value2 do
					SetSkill(x.eatk[index2], x.skillsetting)
					Attack(x.eatk[index2], x.player)
				end
				x.eatktime[index] = GetTime() + 60.0
			end
			
			if x.eatkstate[index] == 1 then
				for index2 = x.value1, x.value2 do
					if not IsAlive(x.eatk[index2]) then
						x.casualty = x.casualty + 1
					end
				end
				
				if x.casualty == 3 then
					x.eatkstate[index] = 2
				end
				x.casualty = 0
			end
		end
	end
	
	--PLAYER IS PERSON AT GUN TOWERS
	if not x.gtowatk and IsAlive(x.etec) or (IsAlive(x.player) and IsPerson(x.player)) then --not IsOdf(x.player, "svtug") then
		for index = 7, 8 do
			if GetDistance(x.player, x.egun[index]) < 250 or GetDistance(x.player, x.emam) < 250 then
				SetPerceivedTeam(x.player, 1)
				x.gtowatk = true
			end
		end
	end
	
	--PLAYER IS TUG AT GUN TOWERS
	if not x.gtowtug and not x.finalrun and IsAlive(x.player) and IsOdf(x.player, "svtug") then
		for index = 7, 8 do
			if GetDistance(x.player, x.egun[index]) < 250 or GetDistance(x.player, x.emam) < 250 then
				SetPerceivedTeam(x.player, 5)
				x.gtowtug = true
				x.gtowatk = true
			end
		end
	end
	
	--CHECK STATUS OF MCA 
	if not x.MCAcheck then	 
		if not IsAlive(x.emam) or (GetCurHealth(x.emam) < math.floor(GetMaxHealth(x.emam) * 0.98)) then --lost mammoth
			AudioMessage("alertpulse.wav")
			ClearObjectives()
			AddObjective("Mammoth destroyed.\n\nMISSION FAILED!", "RED")
			TCC.FailMission(GetTime() + 4.0, "tcbd03f1.des") --LOSER LOSER LOSER
			x.spine = 666
			x.MCAcheck = true
		end
		
		if x.finalrun and x.finaltime < GetTime() then --out of time
			AudioMessage("alertpulse.wav")
			ClearObjectives()
			AddObjective("Time's up. Launch window closed.\n\nMISSION FAILED!", "RED")
			TCC.FailMission(GetTime() + 4.0, "tcbd03f2.des") --LOSER LOSER LOSER
			x.spine = 666
			x.MCAcheck = true
		end
		
		if not x.finalrun and not IsAround(x.etug) then
			AudioMessage("alertpulse.wav")
			ClearObjectives()
			AddObjective("Tractor tug destroyed. It was needed to get to the Mammoth.\n\nMISSION FAILED!", "RED")
			TCC.FailMission(GetTime() + 4.0, "tcbd03f3.des") --LOSER LOSER LOSER
			x.spine = 666
			x.MCAcheck = true
		end
		
		if x.failstate == 0 and not IsAlive(x.ehng) then --hangar destroyed
			AudioMessage("alertpulse.wav")
			ClearObjectives()
			AddObjective("Hangar destroyed.\n\nMISSION FAILED!", "RED")
			TCC.FailMission(GetTime() + 4.0, "tcbd03f4.des") --LOSER LOSER LOSER
			x.spine = 666
			x.MCAcheck = true
		end
	end
end
--[[END OF SCRIPT]]