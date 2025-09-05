--bztcss10 - Battlezone Total Command - Stars and Stripes - 10/17 - BRING IT HOME
assert(load(assert(LoadFile("_requirefix.lua")),"_requirefix.lua"))();
TCC = require("TC_Core")
MisnNum = 26;
--DECLARE variables --f-friend, e-enemy, atk-attack, rcy-recycler, etc...
local index = 0
local x = {
	FIRST = true, 
	getiton = false, 
	MCAcheck = false, 
	spine = 0, 
	casualty = 0, 
	fnav1 = nil, 
	player = nil, 
	mytank = nil, 
	skillsetting = 0, 
  easy = 0, 
  medium = 1, 
  hard = 2, 
	pos = {}, 
	waittime = 99999.9, 
	eblockdead = false, 
	warnepad = false, 
	relic3gone = false, 
	eblockbuild = false, 
	fpadstate = 0,	
	backupsent = false, 
	eblocktime = 99999.9, 
	epadkilltime = 99999.9, --epadkill fpad1
	epadkill = {}, 
	fpaddietime = 99999.9, 
	elasttime = 99999.9, 
	ftnk = {}, 
	ftnklength = 0, 
	fhelp = {}, 
	ftug = {}, 
	efac = nil, 
	relic1 = nil, 
	relic2 = nil, 
	relic3 = nil, 
	epad = nil, 
	fpad1 = nil, 
	fpad2 = nil, 
	etur = {}, 
	eblock = {}, 
	elast = {}, 
	eblocklength = 4, 
	twoczar = false, 
	twoflank = false, 
	LAST = true
}
--PATHS: fnav1-3, pmytank, fpg1-8, fptug1-3, eptur1-9, epart1-5, eppad, fppad1-2, fppwr, epgfac (for assassins), eplast, fpath1, fpath2, fpath3, fpath4, ephome

function InitialSetup()
	SetAutoGroupUnits(true)

	local odfpreload = {
		"avscout", "avmbike", "avmisl", "avtank", "avrckt", "avtug", "apstbsa", "abtrain", "ablpad2", 
		"svscout", "svmbike", "svmisl", "svtank", "svwalk", "svartl", "svturr", "sblpad2", 
		"hadrelic01", "hadrelic02", "hadrelic03", "apcamra"
	}
	for k,v in pairs(odfpreload) do
		PreloadODF(v)
	end
	
	x.fpad1 = GetHandle("fpad")
	x.fpad2 = GetHandle("fpad2")
	x.epad = GetHandle("epad")
	x.efac = GetHandle("efac")  
	x.ftrn = GetHandle("ftrn")
	Ally(1, 4)
	Ally(4, 1)  
	SetColorFade(6.0, 0.5, "BLACK")
	TCC.Init()
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
	TCC.Update()

	--START THE MISSION BASICS
	if x.spine == 0 then
		x.mytank = BuildObject("avtank", 1, "pmytank")
		x.ftnk[1] = BuildObject("avtank", 1, "fpg1")
		x.ftnk[2] = BuildObject("avtank", 1, "fpg2")
		x.ftnk[3] = BuildObject("avmisl", 1, "fpg3")
    x.ftnk[4] = BuildObject("avrckt", 1, "fpg4")
    x.ftnklength = 4  --8 pts avail
    if x.skillsetting >= x.medium then
      x.ftnk[5] = BuildObject("avmbike", 1, "fpg5")
      x.ftnklength = 5
		end
    if x.skillsetting >= x.hard then
      x.ftnk[6] = BuildObject("avmbike", 1, "fpg6")
      x.ftnklength = 6
    end
		SetAsUser(x.mytank, 1)
		RemoveObject(x.player)
		x.player = GetPlayerHandle()
		for index = 1, x.ftnklength do
			SetSkill(x.ftnk[index], x.skillsetting)
			SetGroup(x.ftnk[index], 0)
		end
		x.ftug[1] = BuildObject("avtug", 1, "fptug1")
    SetCanSnipe(x.ftug[1], 0)
		x.relic1 = BuildObject("hadrelic01", 0, "fptug1")
		Pickup(x.ftug[1], x.relic1)
		x.ftug[2] = BuildObject("avtug", 1, "fptug2")
    SetCanSnipe(x.ftug[2], 0)
		x.relic2 = BuildObject("hadrelic02", 0, "fptug2")
		Pickup(x.ftug[2], x.relic2)
		x.ftug[3] = BuildObject("avtug", 1, "fptug3")
    SetCanSnipe(x.ftug[3], 0)  --So (Herp) can't snipe Arkin
		x.relic3 = BuildObject("hadrelic03", 0, "fptug3")
		Pickup(x.ftug[3], x.relic3)
		--[[x.fnav1 = BuildObject("apcamra", 1, "fpnav1") --like it better w/out them
		SetObjectiveName(x.fnav1, "Waypoint 1")
		x.fnav1 = BuildObject("apcamra", 1, "fpnav2")
		SetObjectiveName(x.fnav1, "Waypoint 2")--]]
		x.fnav1 = BuildObject("apcamra", 1, "fpnav3")
		SetObjectiveName(x.fnav1, "Launch Pad")
		--x.fnav1 = BuildObject("abpgen0", 4, "fppwr")
		for index = 1, 9 do
			x.etur[index] = BuildObject("svturr", 5, ("eptur%d"):format(index))
			SetSkill(x.etur[index], x.skillsetting)
		end
		for index = 10, 13 do
			x.etur[index] = BuildObject("svartl", 5, ("epart%d"):format(index-9))
			SetSkill(x.etur[index], x.skillsetting)
		end
		x.pos = GetTransform(x.fpad1)
		RemoveObject(x.fpad1)
		x.fpad1 = BuildObject("ablpad2", 1, x.pos)
		x.pos = GetTransform(x.epad)
		RemoveObject(x.epad)
		x.epad = BuildObject("sblpad2", 5,	x.pos)
		x.pos = GetTransform(x.ftrn)
		RemoveObject(x.ftrn)
		x.ftrn = BuildObject("abtrain", 1, x.pos)
		x.pos = GetTransform(x.fpad2) --DO NOT USE X.POS AGAIN, NEEDED FOR FPAD2
		RemoveObject(x.fpad2)
		x.waittime = GetTime() + 7.0
		SetScrap(1, 0)
		AudioMessage("tcss1001.wav") --17 INTRO - Get x.rel to Lpad and off Io to Mars. 8th provide assistance
		x.spine = x.spine + 1
	end

	--Give 1st objective
	if x.spine == 1 and x.waittime < GetTime() then
		ClearObjectives()
		AddObjective("tcss1001.txt")
		for index = 1, 3 do
			SetObjectiveName(x.ftug[index], ("Tug %d"):format(index))
			SetObjectiveOn(x.ftug[index])
		end
		x.waittime = GetTime() + 3.0
		x.spine = x.spine + 1
	end
	
	--Start tug run to nav1
	if x.spine == 2 and x.waittime < GetTime() then
		AudioMessage("tcss1002.wav") --1 Moving out
		Goto(x.ftug[1], "fpath1", 1)
		Follow(x.ftug[2], x.ftug[1])
		x.twoflank = true
		x.waittime = GetTime() + 7.0
		x.spine = x.spine + 1
	end
	
	--Delay 3rd tug takeoff
	if x.spine == 3 and x.waittime < GetTime() then
		Follow(x.ftug[3], x.ftug[2])
		x.spine = x.spine + 1
	end

	--Send ftug1 to nav2
	if x.spine == 4 and IsAlive(x.ftug[1]) and GetDistance(x.ftug[1], "fpnav1") < 16 then
		Goto(x.ftug[1], "fpath2", 1)
		x.spine = x.spine + 1
	end

	--Start Arkin betrayal
	if x.spine == 5 and IsAlive(x.ftug[3]) and GetDistance(x.ftug[3], "fpnav1") < 75 then
		Goto(x.ftug[3], "ephome", 1)
		x.waittime = GetTime() + 2.0
		x.spine = x.spine + 1
	end

	--msg tug leaving AND build blockade
	if x.spine == 6 and x.waittime < GetTime() then
		AudioMessage("tcss1003.wav") --4 one of the transports is breaking from path
		SetObjectiveName(x.ftug[3], "Traitor Arkin")
		SetObjectiveOn(x.ftug[3])
		x.eblocktime = GetTime()
		x.waittime = GetTime() + 5.0
		x.spine = x.spine + 1
	end

	--msg Arkin farewell
	if x.spine == 7 and x.waittime < GetTime() then
		AudioMessage("tcss1004.wav") --3 Farewell bourgeois imperialist pigs
		x.waittime = GetTime() + 4.0
		x.spine = x.spine + 1
	end

	--msg what up with that, reset ftug3
	if x.spine == 8 and x.waittime < GetTime() then
		AudioMessage("tcss1005.wav") --7 Arkin, what's with the accent. He's stealing trans. He's a mole.
		x.waittime = GetTime() + 8.0
		TCC.SetTeamNum(x.ftug[3], 5)
		x.spine = x.spine + 1
	end

	--msg pursue carefully
	if x.spine == 9 and x.waittime < GetTime() then
		AudioMessage("tcss1006.wav") --10 Grz pursue 3 w/ caution. Do not lose trans 1 and 2.
		x.waittime = GetTime() + 11.0
		x.spine = x.spine + 1
	end

	--msg cca detected stop ftug1
	if x.spine == 10 and IsAlive(x.ftug[1]) and GetDistance(x.ftug[1], "fpnav2") < 16 then
		Stop(x.ftug[1])
		AudioMessage("tcss1007.wav") --6 We detected force ahead. Stopping convoy until clear (tugs then
		x.waittime = GetTime() + 4.0
		x.spine = x.spine + 1
	end

	--Show new objective
	if x.spine == 11 and x.waittime < GetTime() then
		ClearObjectives()
		AddObjective("tcss1002.txt")
		for index = 1, 2 do
			x.elast[index] = BuildObject("svscout", 5, "epblock1")
			SetSkill(x.elast[index], x.skillsetting)
			Attack(x.elast[index], x.ftug[index])
		end
		for index = 1, 2 do
			x.elast[index] = BuildObject("svtank", 5, "epblock4")
			SetSkill(x.elast[index], x.skillsetting)
			Attack(x.elast[index], x.ftug[index])
		end
		x.spine = x.spine + 1
	end

	--send lpad killer
	if x.spine == 12 and x.eblockdead then
		x.waittime = GetTime() + 3.0
		x.epadkilltime = GetTime()
		x.spine = x.spine + 1
	end

	--send ftug1 to nav3
	if x.spine == 13 and x.waittime < GetTime() then
		AudioMessage("tcss1002.wav") --1 Moving out (transports then
		Goto(x.ftug[1], "fpath3", 1)
		SetObjectiveName(x.fpad1, "Launch Pad")
		SetObjectiveOn(x.fpad1)
		x.waittime = GetTime() + 5.0
		x.spine = x.spine + 1
	end

	--msg CCA attack launchpad
	if x.spine == 14 and x.waittime < GetTime() then
		AudioMessage("tcss1008.wav") --6 Collin here, add CCA moving in to attack the Lpad
		x.spine = x.spine + 1
	end

	--msg lpad1 destroyed
	if x.spine == 15 and not IsAlive(x.fpad1) then
		AudioMessage("tcss1009.wav") --10 Grz1, Lpad lost. LtCorb setting up new site.
		x.elasttime = GetTime()
		x.waittime = GetTime() + 25.0
		x.twoczar = true
		x.spine = x.spine + 1
	end

	--msg setup lpad2 build fpad2
	if x.spine == 16 and x.waittime < GetTime() then
		AudioMessage("tcss1010.wav") --4 Corb - 2nd lpad up. Go there.
		x.fpad2 = BuildObject("ablpad2", 1, x.pos)
		TCC.SetTeamNum(x.fpad2, 1)
		SetObjectiveName(x.fpad2, "Launch Pad B")
		SetObjectiveOn(x.fpad2)
		x.waittime = GetTime() + 3.0
		x.spine = x.spine + 1
	end

	--Show new objective to alt pad
	if x.spine == 17 and x.waittime < GetTime() then
		ClearObjectives()
		AddObjective("tcss1003.txt")
		x.waittime = GetTime() + 3.0
		x.spine = x.spine + 1
	end

	--msg tug move to lpad2
	if x.spine == 18 and x.waittime < GetTime() then
		AudioMessage("tcss1002.wav") --1 Moving out (transports then
		Goto(x.ftug[1], "fpath4", 1)
		x.spine = x.spine + 1
	end

	--SUCCEED MISSION	tug at fppad 
	if x.spine == 19 and IsAlive(x.ftug[1]) and GetDistance(x.ftug[1], "fppad2") < 100 then
		x.MCAcheck = true
		AudioMessage("tcss1013.wav") --10 SUCCEED - Losing Arkin a setback but a win.
		ClearObjectives()
		AddObjective("tcss1004.txt", "GREEN")
		TCC.SucceedMission(GetTime() + 12.0, "tcss10w1.des") --WINNER WINNER WINNER
		x.spine = x.spine + 1
	end
	----------END MAIN SPINE ----------
	
	--INITIAL FLANKER ATTACK
	if x.twoflank then
		x.elast[1] = BuildObject("svscout", 5, "fpnav1")
		SetSkill(x.elast[1], x.skillsetting)
		Attack(x.elast[1], x.ftug[1])
		x.elast[2] = BuildObject("svscout", 5, "fpnav2")
		SetSkill(x.elast[2], x.skillsetting)
		Attack(x.elast[2], x.ftug[2])
		x.twoflank = false
	end

	--SEND BACKUP UNDER CERTAIN CONDITIONS
	if not x.backupsent then	
		for index = 1, x.ftnklength do
			if not IsAlive(x.ftnk[index]) then
				x.casualty = x.casualty + 1
			end
		end
		if x.casualty >= math.floor(x.ftnklength * 0.5) and (x.eblockdead or not IsAlive(x.fpad1)) then
			for index = 1, 2 do
				x.fhelp[index] = BuildObject("avscout", 1, "pbackup", index)
				SetSkill(x.fhelp[index], x.skillsetting)
				Defend2(x.fhelp[index], x.player, 0)
			end
			x.backupsent = true
		end
		x.casualty = 0
	end
		
	--PROTECT ftug[3]
	if IsAround(x.ftug[3]) then	
		SetCurHealth(x.ftug[3], 3000)
	end
	
	--kill 1st launchpad if cca can't
	if x.fpadstate == 0 and x.eblockdead and GetCurHealth(x.fpad1) < 2500 then
		x.fpaddietime = GetTime() + 30.0
		x.fpadstate = 1
	elseif not x.fpadstate == 1 and IsAlive(x.fpad1) and x.fpaddietime < GetTime() then
		Damage(x.fpad1, 10000)
		x.fpadstate = 2
	elseif x.fpadstate == 1 and not IsAlive(x.fpad1) then
		x.fpadstate = 2
	end

	--WARN PLAYER IF NEAR CCA BASE
	if not x.warnepad and GetDistance(x.player, "eppad") < 400 then
		AudioMessage("tcss1014.wav") --12 Stay away from trans 3. CCA base nearby.
		x.warnepad = true
	end

	--REMOVE RELIC3 AND ARKIN
	if not x.relic3gone and GetDistance(x.ftug[3], "eppad") < 50 then
		RemoveObject(x.relic3)
		RemoveObject(x.ftug[3])
		x.relic3gone = true
	end

	--SETUP CCA BLOCKADE
	if x.eblocktime < GetTime() then
		if not x.eblockbuild then
			x.eblock[1] = BuildObject("svwalk", 5, "epblock1")
			x.eblock[2] = BuildObject("svmbike", 5, "epblock2")
			x.eblock[3] = BuildObject("svmisl", 5, "epblock3")
			x.eblock[4] = BuildObject("svscout", 5, "epblock4")
			for index = 1, 4 do
				SetSkill(x.eblock[index], x.skillsetting)
				Goto(x.eblock[index], ("epblock%d"):format(index))
			end
			x.eblockbuild = true
		end

		for index = 1, x.eblocklength do
			if not IsAlive(x.eblock[index]) or (IsAlive(x.eblock[index]) and GetTeamNum(x.eblock[index]) == 1) then
				x.casualty = x.casualty + 1
			end
		end

		if x.casualty == x.eblocklength then
			x.eblocktime = 99999.9
			x.eblockdead = true
			x.eblock[1] = BuildObject("svtank", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn --second attack wave
			x.eblock[2] = BuildObject("svmisl", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
			x.eblock[3] = BuildObject("svtank", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
			x.eblock[4] = BuildObject("svmisl", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
			for index = 1, 2 do
				Attack(x.eblock[index], x.ftug[1])
				Attack(x.eblock[index+2], x.ftug[2])
				SetSkill(x.epadkill[index], x.skillsetting)
				SetSkill(x.epadkill[index+2], x.skillsetting)
			end
		end
		x.casualty = 0
	end

	--SETUP CCA LPAD KILL
	if x.epadkilltime < GetTime() then
		if IsAlive(x.fpad1) then
			if not IsAlive(x.epadkill[1]) or x.epadkill[1] == nil then
				x.epadkill[1] = BuildObject("svtank", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
				SetSkill(x.epadkill[index], x.skillsetting)
				Attack(x.epadkill[1], x.fpad1)
			end
			if not IsAlive(x.epadkill[2]) or x.epadkill[2] == nil then
				x.epadkill[2] = BuildObject("svtank", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
				SetSkill(x.epadkill[2], x.skillsetting)
				Attack(x.epadkill[2], x.fpad1)
			end
			if not IsAlive(x.epadkill[3]) or x.epadkill[3] == nil then
				x.epadkill[3] = BuildObject("svmisl", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
				SetSkill(x.epadkill[3], x.skillsetting)
				Attack(x.epadkill[3], x.fpad1)
			end
			if not IsAlive(x.epadkill[4]) or x.epadkill[4] == nil then
				x.epadkill[4] = BuildObject("svmisl", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
				SetSkill(x.epadkill[4], x.skillsetting)
				Attack(x.epadkill[4], x.fpad1)
			end
		end
		
		if IsAlive(x.fpad1) then
			Damage(x.fpad1, 2)
		end
		
		if not IsAlive(x.fpad1) then
			Defend2(x.epadkill[1], x.relic1)
			Defend2(x.epadkill[2], x.relic2)
			Defend2(x.epadkill[3], x.relic1)
			Defend2(x.epadkill[4], x.relic2)
			x.epadkilltime = 99999.9
		end
	end
	
	--SEND 2 EXTRA CZAR UNDER CERTAIN CONDITIONS
	if not x.twoczar and IsAlive(x.fpad1) and GetCurHealth(x.fpad1) < math.floor(GetMaxHealth(x.fpad1) * 0.7) then
		for index = 1, 4 do
			if not IsAlive(x.epadkill[index]) then
				x.casualty = x.casualty + 1
			end
		end
		if x.casualty >= 2 then
			for index = 1, 2 do
				x.epadkill[index+4] = BuildObject("svtank", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
				SetSkill(x.epadkill[index+4], x.skillsetting)
				Attack(x.epadkill[index+4], x.ftug[index])
			end
			x.twoczar = true
		end
		x.casualty = 0
	end

	--LAST CHANCE ATTACK
	if x.elasttime < GetTime() then
		for index = 1, 2 do
			if not IsAlive(x.elast[index]) then
				x.elast[index] = BuildObject("svscout", 5, "eplast")
				SetSkill(x.elast[index], x.skillsetting)
				Attack(x.elast[index], x.ftug[index])
			end
		end
		if GetDistance(x.ftug[1], "fppad2") < 200 then
			x.elasttime = 99999.9
		end
	end

	--CHECK STATUS OF MCA 
	if not x.MCAcheck then
		if not IsAlive(x.ftug[1]) or not IsAlive(x.ftug[2]) or (not x.relic3gone and not IsAlive(x.ftug[3])) then --x.ftug[ destroyed
			AudioMessage("tcss1011.wav") --2 FAIL - Buz - One of the transports is destroyed
			AudioMessage("tcss1012.wav") --8 FAIL - GenC - Convoy disaster
			TCC.FailMission(GetTime() + 20.0, "tcss10f1.des") --LOSER LOSER LOSER
			ClearObjectives()
			AddObjective("tcss1005.txt", "RED")
			x.spine = 666
			x.MCAcheck = true
		end

		if not IsAlive(x.relic1) or not IsAlive(x.relic2) or (not x.relic3gone and not IsAlive(x.relic3)) then --x.relic destroyed
			AudioMessage("tcss0903.wav") --5 FAIL - x.relic destroyed
			AudioMessage("tcss1012.wav") --8 FAIL - GenC - Convoy disaster
			TCC.FailMission(GetTime() + 20.0, "tcss10f1.des") --LOSER LOSER LOSER
			ClearObjectives()
			AddObjective("tcss1005.txt", "RED")
			x.spine = 666
			x.MCAcheck = true
		end
		
		--KILL NSDF ROCKET WITH LPAD
		if not IsAlive(x.fpad1) and IsAlive(x.fcne1) then
			Damage(x.fcne1, 15000)
		end
	end
end
--[[END OF SCRIPT]]