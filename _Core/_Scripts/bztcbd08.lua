--bztcbd08 - Battlezone Total Command - Stars and Stripes - 8/10 - THE SILENCERS
assert(load(assert(LoadFile("_requirefix.lua")),"_requirefix.lua"))();
TCC = require("TC_Core")
MisnNum = 51;
local index = 0;
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
	hard = 2, --tried 1-3, in 185, 3 didn't seem to make any difference,
	audio1 = nil, 
	audio2 = nil, 
	fnav = {}, 
	pos = {}, 
	missiontime = 99999.9, 
	repel = {}, 
	fgrp = {}, 
	fdrp = nil, 
	fdrpos = {}, 
	edish = nil, 
	ecom = {}, 
	eatk = {}, 
	epat = {}, 
	datastate = 0, --data stuff
	datastart = 0, 
	datapingtime = 99999.9, 
	datatime = 99999.9, 
	datawarn = false, 
	datastart = false, 
	epwr = {}, --power gen stuff
	epwrstate = {0, 0, 0}, 
	epwrdead = 0, 
	easn = {}, --assassin stuff
	easnsend = false, 
	easnlength = 0, 
	easnstate = {0, 0, 0, 0}, 
	easntime = {99999.9, 99999.9, 99999.9, 99999.9}, 
	easnresend = 99999.9,
	easncool = 60.0, --init here
	easnsooner = false, 
	easnextra = 0, 
	LAST	= true
}
--PATHS: fpnav1-5, ppatrol1-7, epasn(0-4), eptur(0-8), epwlk(0-4), epatk(0-12), epart(0-12), prepel1-3

function InitialSetup()
	SetAutoGroupUnits(true)
	
	local odfpreload = {
		"bvhtnk", "nvscout", "nvmbike", "nvmisl", "nvtank", "nvrckt", "nvwalk", "nvturr", "nvartl", 
		"mvscout", "mvmbike", "mvmisl", "mvtank", "mvrckt", "mvstnk", "repelenemy100", "repelenemy200", "apcamrb"
	}
	for k,v in pairs(odfpreload) do
		PreloadODF(v)
	end
	
	x.mytank = GetHandle("mytank")
	x.fdrp = GetHandle("fdrp")
	x.ecom[1] = GetHandle("ecom1")
	x.ecom[2] = GetHandle("ecom2")
	x.ecom[3] = GetHandle("ecom3")
	x.edish = GetHandle("edish")
	for index = 1, 7 do
		x.epwr[index] = GetHandle(("epwr%d"):format(index))
	end
	for index = 1, 10 do
		x.fgrp[index] = GetHandle(("fgrp%d"):format(index))
	end
	Ally(5, 6)
	Ally(5, 7)
	Ally(5, 8)
	Ally(6, 5)
	Ally(7, 5)
	Ally(8, 5)
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
		x.audio1 = AudioMessage("tcbd0801b.wav") --"b" Shorter version 
		x.fdrppos = GetTransform(x.fdrp)
		RemoveObject(x.fdrp)
		x.pos = GetTransform(x.mytank)
		RemoveObject(x.mytank)
		x.mytank = BuildObject("bvhtnk", 1, x.pos)
		SetAsUser(x.mytank, 1)
		RemoveObject(x.player)
		x.player = GetPlayerHandle()
		for index = 1, 10 do
			x.pos = GetTransform(x.fgrp[index])
			RemoveObject(x.fgrp[index])
			if index <= 5 then
				x.fgrp[index] = BuildObject("bvhtnk", 1, x.pos)
			end
			if x.skillsetting > x.easy and index > 5 and index <= 7 then
				x.fgrp[index] = BuildObject("bvhtnk", 1, x.pos)
			end
			if x.skillsetting > x.medium and index > 7 and index <= 9 then
				x.fgrp[index] = BuildObject("bvhtnk", 1, x.pos)
			end
			SetGroup(x.fgrp[index], 0)
			SetSkill(x.fgrp[index], 2)
		end
		for index = 1, 12 do
			x.eatk[index] = BuildObject("nvartl", 5, "epart", index)
			SetSkill(x.eatk[index], x.skillsetting)
		end
		for index = 1, 4 do
			x.eatk[index] = BuildObject("nvwalk", 5, "epwlk", index)
			SetSkill(x.eatk[index], x.skillsetting)
		end
		for index = 1, 8 do
			x.eatk[index] = BuildObject("nvturr", 5, "eptur", index)
			SetSkill(x.eatk[index], x.skillsetting)
		end
		for index = 1, 12 do --Build units for each base
			while x.randompick == x.randomlast do --random the random
				x.randompick = math.floor(GetRandomFloat(1.0, 18.0))
			end
			x.randomlast = x.randompick
			if x.randompick == 1 or x.randompick == 7 or x.randompick == 13 then
				x.eatk[index] = BuildObject("mvscout", 5, "epatk", index)
			elseif x.randompick == 2 or x.randompick == 8 or x.randompick == 14 or x.randompick == 17 then
				x.eatk[index] = BuildObject("mvmbike", 5, "epatk", index)
			elseif x.randompick == 3 or x.randompick == 9 or x.randompick == 15 or x.randompick == 18 then
				x.eatk[index] = BuildObject("mvmisl", 5, "epatk", index)
			elseif x.randompick == 4	or x.randompick == 10 or x.randompick == 16 then
				x.eatk[index] = BuildObject("mvtank", 5, "epatk", index)
			elseif x.randompick == 5 or x.randompick == 11 then
				x.eatk[index] = BuildObject("mvrckt", 5, "epatk", index)
			else --6, 12
				x.eatk[index] = BuildObject("mvstnk", 5, "epatk", index)
			end
			SetSkill(x.eatk[index], x.skillsetting)
		end
		for index = 1, 7 do --CBB patrols
			while x.randompick == x.randomlast do --random the random
				x.randompick = math.floor(GetRandomFloat(1.0, 13.0))
			end
			x.randomlast = x.randompick
			if x.randompick == 1 or x.randompick == 6 or x.randompick == 11 then
				x.epat[index] = BuildObject("mvscout", 5, ("ppatrol%d"):format(index))
			elseif x.randompick == 2 or x.randompick == 7 then
				x.epat[index] = BuildObject("mvmbike", 5, ("ppatrol%d"):format(index))
			elseif x.randompick == 3 or x.randompick == 8 or x.randompick == 12 then
				x.epat[index] = BuildObject("mvmisl", 5, ("ppatrol%d"):format(index))
			elseif x.randompick == 4 or x.randompick == 9 then
				x.epat[index] = BuildObject("mvtank", 5, ("ppatrol%d"):format(index))
			else --5 10 13
				x.epat[index] = BuildObject("mvrckt", 5, ("ppatrol%d"):format(index))
			end
			SetSkill(x.epat[index], x.skillsetting)
			Patrol(x.epat[index], ("ppatrol%d"):format(index))
		end
		x.repel[1] = BuildObject("repelenemy200", 5, "prepel1")
		x.repel[2] = BuildObject("repelenemy100", 5, "prepel2")
		x.repel[3] = BuildObject("repelenemy100", 5, "prepel3")
		x.spine = x.spine + 1
	end

	--START TIMER AND FIRST OBJECTIVE
	if x.spine == 1 and IsAudioMessageDone(x.audio1) then
		AddObjective("Disable the Comm Towers by destroying their L-power generators.\n\nTime is limited before AIP reinforcements arrive.")
		x.fnav[1] = BuildObject("apcamrb", 1, "fpnav1")
		SetObjectiveName(x.fnav[1], "Destroy L-power 1")
		SetObjectiveOn(x.fnav[1])
		StartCockpitTimer(600, 300, 150)
		x.missiontime = GetTime() + 602.0
		for index = 1, 3 do --don't make so easy to acc. kill
			if x.skillsetting == x.easy then
				SetCurHealth(x.ecom[index], (GetMaxHealth(x.ecom[index])+3000))
			elseif x.skillsetting == x.medium then
				SetCurHealth(x.ecom[index], (GetMaxHealth(x.ecom[index])+1500))
			end
		end
		x.spine = x.spine + 1
	end
	
	--REGISTER EPWR DESTROYED AND COMM TOWER DISABLED
	if x.spine == 2 then
		for index = 1 ,3 do
			if x.epwrstate[index] == 0 and not IsAlive(x.epwr[index]) then
				x.epwrdead = x.epwrdead + 1
				x.epwrstate[index] = 1
				x.pos = GetTransform(x.ecom[index]) --long, but assured change for AI perception
				RemoveObject(x.ecom[index])
				x.ecom[index] = BuildObject("mbcbun", 0, x.pos)
				if x.epwrdead == 1 then
					AudioMessage("tcbd0802.wav") --One down, two to go. The jamming signal has definitely decreased in power.
					ClearObjectives()
					AddObjective("Tower 1 disabled.", "GREEN")
					AddObjective("\n\nDisable the second Comm Tower.")
					SetObjectiveOff(x.fnav[1])
					x.fnav[2] = BuildObject("apcamrb", 1, "fpnav2")
					SetObjectiveName(x.fnav[2], "Destroy L-power 2")
					SetObjectiveOn(x.fnav[2])
					RemoveObject(x.repel[1])
				elseif x.epwrdead == 2 then
					AudioMessage("tcbd0803.wav") --That's two towers down. We can almost get a signal through.
					ClearObjectives()
					AddObjective("Tower 2 disabled.", "GREEN")
					AddObjective("\n\nDisable the third Comm Tower.")
					SetObjectiveOff(x.fnav[2])
					x.fnav[3] = BuildObject("apcamrb", 1, "fpnav3")
					SetObjectiveName(x.fnav[3], "Destroy L-power 3")
					SetObjectiveOn(x.fnav[3])
					RemoveObject(x.repel[2])
				elseif x.epwrdead == 3 then 
					AudioMessage("tcbd0804.wav") --ADDED --Third tower disabled. Go to the transmission array, tap in, and send the warning message.
					ClearObjectives()
					AddObjective("Tower 3 disabled.", "GREEN")
					AddObjective("\n\nDestroy Crimson Bears base defenses.", "ALLYBLUE")
					AddObjective("Keep one L-power, and the transmitter alive.", "YELLOW")
					AddObjective("\n\nGet within 40m of the Deep-Space Transmitter to send warning.")
					SetObjectiveOff(x.fnav[3])
					x.fnav[4] = BuildObject("apcamrb", 1, "fpnav4")
					SetObjectiveName(x.fnav[4], "Send Warning Signal")
					SetObjectiveOn(x.fnav[4])
					RemoveObject(x.repel[3])
					x.easnsend = true
					x.easnresend = GetTime() + 30.0
					x.spine = x.spine + 1
				end
			end
		end 
	end
	
	--PLAYER AT ARRAY, START TRANSMISSION PHASE
	if x.spine == 3 and IsAlive(x.player) and IsAlive(x.edish) and GetDistance(x.player, x.edish) < 40 and IsPowered(x.edish) then
		AudioMessage("tcbd0805.wav") --ADDED --Hold position, sending warning transmission.
		StopCockpitTimer()
		HideCockpitTimer()
		x.missiontime = 99999.9 --GetTime() + 300.0
		x.datastate = 1
		x.spine = x.spine + 1
	end
	
	--TRANSMISSION SENT GO TO GRIGG
	if x.spine == 4 and x.datastate == 2 then
		x.audio1 = AudioMessage("tcbd0806.wav") --Nice work, Cobra One. AIP units are advancing on your position, get out of there.
		ClearObjectives()
		AddObjective("Warning transmission sent to Moon base.", "GREEN")
		AddObjective("\n\nMeet Pvt. Grigg at the Extraction Beacon.")
		SetObjectiveOff(x.fnav[4])
		x.fnav[5] = BuildObject("apcamrb", 1, "fpnav5")
		SetObjectiveName(x.fnav[5], "Extraction")
		SetObjectiveOn(x.fnav[5])
		x.fdrp = BuildObject("bvdrop", 0, x.fdrppos)
		SetObjectiveName(x.fdrp, "Pvt. Grigg")
		SetAnimation(x.fdrp, "open", 1)
		x.spine = x.spine + 1
	end
	
	--ENSURE PLAYER IS AI ENEMY (IF WAS IN SNIPED VEHICLE)
	if x.spine == 5 and IsAudioMessageDone(x.audio1) then
		x.easncool = 3.0
		x.waittime = GetTime() + 10.0 --KEEP
		x.easnextra = 1
		if GetPerceivedTeam(x.player) ~= 1 then
			SetPerceivedTeam(x.player, 1)
		end
    for index = 1, 10 do
      StopEmitter(x.fdrp, index)
    end
		x.spine = x.spine + 1
	end
	
	--HIGHLIGHT GRIGG
	if x.spine == 6 and IsAlive(x.player) and GetDistance(x.player, "fpnav5") < 400 then
		SetObjectiveOn(x.fdrp)
		x.spine = x.spine + 1
	end
	
	--MISSION SUCCESS
	if x.spine == 7 and x.missiontime > GetTime() and IsAlive(x.player) and GetDistance(x.player, "fpnav5") < 100 then
		x.missiontime = 99999.9
		StopCockpitTimer()
		SetObjectiveOff(x.fnav[5])
		AudioMessage("tcbd0807.wav") --ADDED --Mission Complete. Board for takeoff.
		ClearObjectives()
		AddObjective("Meet Pvt. Grigg at the Extraction Beacon.\n\nMISSION COMPLETE.", "GREEN")
		TCC.SucceedMission(GetTime() + 7.0, "tcbd08w.des") --WINNER WINNER WINNER
		x.MCAcheck = true
		x.spine = x.spine + 1
	end
	----------END MAIN SPINE ----------
	
	--ASSASSINS
	if x.easnsend then
		if x.skillsetting == x.easy then
			x.easnlength = 4
		elseif x.skillsetting == x.medium then
			x.easnlength = 5
		else
			x.easnlength = 6
		end
		for index = 1, x.easnlength do
			if x.easnstate[index] == 0 and not IsAlive(x.easn[index]) then
				x.easntime[index] = GetTime() + x.easncool
				x.easnstate[index] = 1
			elseif x.easnstate[index] == 1 and x.easntime[index] < GetTime() then
				while x.randompick == x.randomlast do --random the random
					x.randompick = math.floor(GetRandomFloat(1.0, 13.0))
				end
				x.randomlast = x.randompick
				if x.randompick == 1 or x.randompick == 6 or x.randompick == 11 then
					x.easn[index] = BuildObject("nvscout", 5, "epasn", index)
				elseif x.randompick == 2 or x.randompick == 7 or x.randompick == 12 then
					x.easn[index] = BuildObject("nvmbike", 5, "epasn", index)
				elseif x.randompick == 3 or x.randompick == 8 or x.randompick == 13 then
					x.easn[index] = BuildObject("nvmisl", 5, "epasn", index)
				elseif x.randompick == 4 or x.randompick == 9 then
					x.easn[index] = BuildObject("nvtank", 5, "epasn", index)
				else --5 10
					x.easn[index] = BuildObject("nvrckt", 5, "epasn", index)
				end
				SetSkill(x.easn[index], x.skillsetting)
				Attack(x.easn[index], x.player)
				x.easnstate[index] = 2
			elseif x.easnstate[index] == 2 and not IsAlive(x.easn[index]) then
				x.easnstate[index] = 0
			end
		end
		for index = 1, x.easnlength do
			if IsAlive(x.easn[index]) and GetTeamNum(x.easn[index]) ~= 1 and x.easnresend < GetTime() then
				Attack(x.easn[index], x.player)
			end
		end
		x.easnresend = GetTime() + 30.0
	end

	--SEND THE TRANSMISSION
	if x.datastate == 1 then
		if not x.datastart and IsAlive(x.player) and IsAlive(x.edish) and IsPowered(x.edish) and GetDistance(x.player, x.edish) <= 40 then --transmission start
			x.audio2 = AudioMessage("tcss1101.wav") --Init comm uplink. Computer
			ClearObjectives()
			AddObjective("Stay within 40m of Dish for 60 secs.", "ALLYBLUE")
			StartCockpitTimerUp(0, 30, 59)
			x.datapingtime = GetTime()
			x.datatime = GetTime() + 60.0
			x.datawarn = true
			x.datastart = true
		end
		if x.datastart and x.datawarn and IsAlive(x.player) and IsAlive(x.edish) and GetDistance(x.player, x.edish) > 40 then --warn
			x.audio2 = AudioMessage("tcss1102.wav") --Losing comm uplink. Computer
			x.datawarn = false
		end
		if not x.datawarn and IsAlive(x.player) and IsAlive(x.edish) and GetDistance(x.player, x.edish) <= 40 then --warn reset
			x.datawarn = true
		end
		if x.datastart and IsAlive(x.player) and IsAlive(x.edish) and (GetDistance(x.player, x.edish) > 45 or not IsPowered(x.edish)) then --stop
			x.audio2 = AudioMessage("tcss1103.wav") --Comm uplink lost Computer
			x.datatime = 99999.9
			x.datastart = false
			x.datawarn = false
			StopCockpitTimer()
			HideCockpitTimer()
		end
		if x.datastart and x.datapingtime < GetTime() and IsAudioMessageDone(x.audio2) then --pulse
			StartSoundEffect("tcss1112.wav") --scanning sound
			x.datapingtime = GetTime() + 3.0
		end
		if not x.easnsooner and (x.datatime - 30.0) < GetTime() then --decrease easncool time
			x.easncool = 20.0
			x.easnsooner = true
		end
		if x.datatime < GetTime() then --done
			StopCockpitTimer()
			HideCockpitTimer()
			x.datatime = 99999.9
			x.datapingtime = 99999.9
			x.datastate = 2
		end
	end
	
	--AIP REINFORCEMENTS
	if x.easnextra == 1 and x.casualty < 10 and x.waittime < GetTime() then
		x.eatk[1] = BuildObject("nvtank", 5, "epasn", 3) --"fpnav5")
		SetSkill(x.eatk[1], x.skillsetting)
		Attack(x.eatk[1], x.player)
		x.waittime = GetTime() + 10.0
		x.casualty = x.casualty + 1
	end

	--CHECK STATUS OF MCA ----------------------------------
	if not x.MCAcheck then	 
		--destroyed a comm tower or hi-speed transmitter dish
		if x.datastate < 2 
		and (not IsAlive(x.ecom[1]) or not IsAlive(x.ecom[2]) or not IsAlive(x.ecom[3]) or not IsAlive(x.edish)) then
		--or (not IsAlive(x.epwr[4]) and not IsAlive(x.epwr[5]) and not IsAlive(x.epwr[6]) and not IsAlive(x.epwr[7]))) then 
			AudioMessage("alertpulse.wav") 
			ClearObjectives()
			AddObjective("You were not authorized to destroy that structure.\n\nMISSION FAILED!", "RED")
			TCC.FailMission(GetTime() + 5.0, "tcbd08f1.des") --LOSER LOSER LOSER
			x.spine = 666
			x.MCAcheck = true
		end
		
		--no power for transmistter
		if x.datastate < 2 and (not IsAlive(x.epwr[4]) and not IsAlive(x.epwr[5]) and not IsAlive(x.epwr[6]) and not IsAlive(x.epwr[7])) then
		--and not IsAlive(x.fgrp[1]) and not IsAlive(x.fgrp[2]) and not IsAlive(x.fgrp[3]) and not IsAlive(x.fgrp[4]) and not IsAlive(x.fgrp[5]) 
		--and not IsAlive(x.fgrp[6]) and not IsAlive(x.fgrp[7]) and not IsAlive(x.fgrp[8]) and not IsAlive(x.fgrp[9]) and not IsAlive(x.fgrp[10]) then
			AudioMessage("alertpulse.wav") 
			ClearObjectives()
			AddObjective("No power for Transmitter.\n\nMISSION FAILED!", "RED")
			TCC.FailMission(GetTime() + 5.0, "tcbd08f1.des") --LOSER LOSER LOSER
			x.spine = 666
			x.MCAcheck = true
		end
		
		--out of time
		if x.missiontime < GetTime() then	
			AudioMessage("alertpulse.wav") 
			ClearObjectives()
			AddObjective("You're out of time.\nAIP reinforcements have arrived.\n\nMISSION FAILED!", "RED")
			TCC.FailMission(GetTime() + 5.0, "tcbd08f1.des") --LOSER LOSER LOSER
			x.spine = 666
			x.MCAcheck = true
		end
	end
end
--END OF SCRIPT