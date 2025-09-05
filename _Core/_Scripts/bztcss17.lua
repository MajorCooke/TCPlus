--bztcss17 - Battlezone Total Command - Stars and Stripes - 17/17 - THE ULTIMATE QUAKE
assert(load(assert(LoadFile("_requirefix.lua")),"_requirefix.lua"))();
TCC = require("TC_Core")
MisnNum = 58;
--DECLARE variables --f-friend, e-enemy, atk-attack, rcy-recycler, etc..., 
local index = 1
local indexadd = 1
local x = {
	FIRST = true, 
	MCAcheck = false, --stock stuff
	quicktime = 99999.9, 
	quickcool = 0.0, 
	waittime = 99999.9,
	audio1 = nil, 
	player = nil, 
	mytank = nil, 
	skillsetting = 0, 
	fnav = {}, 
	frcy = nil, 
	ffac = nil, 
	farm = nil, 
	spine = 0,
	casualty = 0,
	randompick = 0, 
	randomlast = 0, 
	pos = {},	
	egun = {}, 
	fdrp = {}, --dropship
	fdrppos1 = {}, 
	fdrppos2 = {}, 
	fdrppos3 = {}, 
	fdrpevac = 0, 
	fally = {}, 
	flyer = {}, --the actual roids
	holder = {}, 
	camplay = 0, --camera 
	camheight = 0,
	camtime = 99999.9, 
	camfov = 60,  --185 default
	userfov = 90,  --seed
	bigtimefail = 99999.9, 
	eshipfound = false, --fury transport
	eship = nil, 
	eshipboom = false, 
	eshipcheck = 99999.9, 
	dummy = nil, 
	gotdummy = false, 
	warntime = 99999.9, 
	rcktgotit = false, --rocket thrusters
	rckt = {},
	rcktmsg = {}, 
	rcktdead = {},	
	rcktcheck = 0, 
	rcktlast = nil,
	rcktlasthealth = 0, 
	rcktlaststate = 0, 
	eleftbehindtime = 99999.9,
	quaketime = 99999.9, --earthquake
	quakeamount = 0, 
	eatk = {},
	fleetime = 99999.9, --flee stuff
	fleewarntime = 99999.9,
	fleemsg = 0, 
	frcyremove = false, 
	timeescape = 99999.9,
	timesup = 99999.9, 
	wrongway = false, 
	achlprop = nil, --end cineractive
	endball = {}, --what camera looks at
	roid = {}, --obj spawn for roid
	fin = {}, --obj destination for roid
	endcamstart = false, 
	endwaitxpl = 99999.9, 
	endstg = 0, 
	endcamtime = 99999.9, 
	eturtime = 99999.9, --eturrets, 
	eturlength = 4, 
	etur = {}, 
	eturcool = {}, 
	eturallow = {}, 
	eturlife = {}, 
	epattime = 99999.9, --epatrols
	epatlength = 3, 
	epat = {}, 
	epatcool = {}, 
	epatallow = {}, 
	epatlife = {}, 
	ekillfrcytime = 99999.9, --killrecy
	ekillfrcybuild = false, 
	ekillfrcylength = 0, 
	ekillfrcy = {}, 
	ekillfrcybuild = false, 
	ekillfrcyreset = false, 
	ekillfrcywave = 0,	
	econvoystart = 0, --convoy stuff
	econvoycooladd = 0.0, 
	econvoystate = {},
	econvoycool = {}, 
	econvoy = {}, 
	easn = nil, --assassin
	easntime = 99999.9, 
	easnallow = false, 
	envirotime = 99999.9, --environment
	envirowait = 99999.9, 
	envirostate = 0, 
	envirochange = 0, 
	domambr = 100, 
	domambg = 120, 
	domambb = 100, 
	skycolr = 145, 
	skycolg = 155, 
	skycolb = 145, 
	skyfogr = 145, 
	skyfogg = 155, 
	skyfogb = 145, 
	skyambr = 100, 
	skyambg = 110, 
	skyambb = 125, 
	suncolr = 200, 
	suncolg = 220, 
	suncolb = 240, 
	fogfar = 0, 
	fornear = 0, 
	boomstate = 0, --boom splosion stuff
	boomclock = 99999.9, 
	boomtime = 99999.9, 
	boomcool = 20.0, 
	boompick = 0, 
	boomlast = 0, 
	boomobj = nil,
	cnslcmdvalue = 0, --volume change
	LAST = true
}
--PATHS: pboom1-3(0-100), lowarea, midarea, toparea,



function InitialSetup()
	SetAutoGroupUnits(true)
	
	local odfpreload = {
		"ybship", "ybsrkt", "ybship2", "yvscout", "yvmbike", "yvtank", "yvrckt", "yvartl",	"yvturr", "yvhtnk", "yvwalk", "ybpgen1", "ybgtow", 
		"avscout", "avmbike", "avmisl", "avtank", "avrckt", "avdolly", "avdrop", "avbiometalroid", "stayput", "bvdolly", "oboompot", "apcamra"
	}
	for k,v in pairs(odfpreload) do
		PreloadODF(v)
	end
	
	x.frcy = GetHandle("frcy")
	x.ffac = GetHandle("ffac")
	x.farm = GetHandle("farm")
	x.achlprop = GetHandle("achlprop")
	x.fdrp[1] = GetHandle("fdrp1")
	x.fdrp[2] = GetHandle("fdrp2")
	x.fdrp[3] = GetHandle("fdrp3")
	for index = 1, 4 do
		x.egun[index] = GetHandle(("egun%d"):format(index))
	end
	for index = 1, 5 do
		x.endball[index] = GetHandle(("ssend%d"):format(index))
		x.roid[index] = GetHandle(("roid%d"):format(index))
		x.fin[index] = GetHandle(("fin%d"):format(index))
	end
	SetColorFade(6.0, 0.5, "BLACK")
	TCC.InitialSetup();
end

function Save()
	return
	index, indexadd, x, TCC.Save();
end

function Load(a, b, c, coreData)
	index = a;
	indexadd = b;
	x = c;
	TCC.Load(coreData)
end

function Start()
	TCC.Start();
end

function AddObject(h)
	if (GetTeamNum(h) > 0) then
		h = RepObject(h); -- [MC] Replace armories and factories
		if (IsPlayer(h) or IsCraftButNotPerson(h)) then
			ReplaceStabber(h);
		end
	end

	if not x.gotdummy and IsOdf(h, "dummy00") then --get camera dummy
		x.dummy = h
		x.gotdummy = true
	end
	
	if not x.rcktgotit then --get the 4 thrusters
		if (not IsAlive(x.rckt[1]) or x.rckt[1] == nil) and IsOdf(h, "ybsrkt") then
			if h ~= x.rckt[2] and h ~= x.rckt[3] and h ~= x.rckt[4] then
				x.rckt[1] = h
			end
		elseif (not IsAlive(x.rckt[2]) or x.rckt[2] == nil) and IsOdf(h, "ybsrkt") then
			if h ~= x.rckt[1] and h ~= x.rckt[3] and h ~= x.rckt[4] then
				x.rckt[2] = h
			end
		elseif (not IsAlive(x.rckt[3]) or x.rckt[3] == nil) and IsOdf(h, "ybsrkt") then
			if h ~= x.rckt[1] and h ~= x.rckt[2] and h ~= x.rckt[4] then
				x.rckt[3] = h
			end
		elseif (not IsAlive(x.rckt[4]) or x.rckt[4] == nil) and IsOdf(h, "ybsrkt") then
			if h ~= x.rckt[1] and h ~= x.rckt[2] and h ~= x.rckt[3] then
				x.rckt[4] = h
				x.rcktgotit = true
			end
		end
	end
	--[[ Now handled entirely on the TC_Core side by simply setting SetEjectRatio to 0.
	if IsOdf(h, "yspilo") then --no recy and bz1 consistency
		RemoveObject(h)
	end
	]]
	
	if IsCraftButNotPerson(x.player) then --assassin attack player if NOT pilot
		x.easnallow = true
	else
		x.easnallow = false
	end
	
	if IsOdf(h, "avscout") or IsOdf(h, "avmbike") or IsOdf(h, "avmisl") or IsOdf(h, "avtank") or IsOdf(h, "avrckt") or IsOdf(h, "avhtnk") or IsOdf(h, "avwalk") then --skill adjust for player
		SetSkill(h, x.skillsetting)
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
	

	--[[TEST END CUTSCENE (need to drive to navpt (nw))
	if x.spine == 0 then
		x.fdrppos1 = GetTransform(x.fdrp[1])
		RemoveObject(x.fdrp[1])
		x.fdrp[1] = BuildObject("avdrop", 0, x.fdrppos1)
		SetAnimation(x.fdrp[1], "open", 1)
		x.fdrppos2 = GetTransform(x.fdrp[2])
		RemoveObject(x.fdrp[2])
		x.fdrp[2] = BuildObject("avdrop", 0, x.fdrppos2)
		SetAnimation(x.fdrp[2], "open", 1)
		x.fdrppos3 = GetTransform(x.fdrp[3])
		RemoveObject(x.fdrp[3])
		x.fdrp[3] = BuildObject("avdrop", 0, x.fdrppos3)
		SetAnimation(x.fdrp[3], "open", 1)
		x.sidespine = 3 
		x.spine = 4
		StartEarthQuake(30)
	end --TEST END CUTSCENE--]]
	
	--START THE MISSION BASICS
	if x.spine == 0 then
		x.mytank = BuildObject("avtank", 1, "pmytank")
		SetAsUser(x.mytank, 1)
		RemoveObject(x.player)
		x.player = GetPlayerHandle()
		x.eship = BuildObject("ybship", 5, "epship")  
		x.fally[1] = BuildObject("avscout", 1, "fpg1")
		x.fally[2] = BuildObject("avmbike", 1, "fpg2")
		x.fally[3] = BuildObject("avmisl", 1, "fpg3")
		x.fally[4] = BuildObject("avtank", 1, "fpg4")
		x.fally[5] = BuildObject("avrckt", 1, "fpg5")
		for index = 1, 5 do
			SetSkill(x.fally[index], 3)
			SetGroup(x.fally[index], 0)
			LookAt(x.fally[index], x.player, 0)
			x.fally[index] = nil
		end
		for index = 1, 4 do
			x.pos = GetTransform(x.egun[index])
			RemoveObject(x.egun[index])
			x.egun[index] = BuildObject("ybgtow", 5, x.pos)
			SetSkill(x.egun[index], 3)
		end
		x.fdrppos1 = GetTransform(x.fdrp[1])
		RemoveObject(x.fdrp[1])
		x.fdrppos2 = GetTransform(x.fdrp[2])
		RemoveObject(x.fdrp[2])
		x.fdrppos3 = GetTransform(x.fdrp[3])
		RemoveObject(x.fdrp[3])
		SetScrap(1, 40)
		x.quicktime = GetTime() + 600.0
		x.audio1 = AudioMessage("tcss1701.wav") --INTRO - Factory destruct destabilize moon. Destroy Fury transport.
		x.camtime = GetTime() + 18.0
    x.userfov = IFace_GetInteger("options.graphics.defaultfov")
    CameraReady()
    IFace_SetInteger("options.graphics.defaultfov", x.camfov)
		x.spine = x.spine + 1
	end

	--GIVE 1ST OBJECTIVE AND SEND INIT ATTACKS
	if x.spine == 1 and x.camplay == 3 then
		AddObjective("tcss1701.txt")
		x.fnav[1] = BuildObject("apcamra", 1, "fpnav1")
		SetObjectiveName(x.fnav[1], "NSDF base")
		x.fnav[4] = BuildObject("apcamra", 1, "fpnav4")
		SetObjectiveName(x.fnav[4], "North bio-metal pool")
		x.fnav[3] = BuildObject("apcamra", 1, "fpnav3")
		SetObjectiveName(x.fnav[3], "East bio-metal pool")
		x.fnav[2] = BuildObject("apcamra", 1, "fpnav2")
		SetObjectiveName(x.fnav[2], "West bio-metal pool")
		x.player = GetPlayerHandle()
		x.eatk[1] = BuildObject("yvrckt", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
		Attack(x.eatk[1], x.frcy)
		x.eatk[2] = BuildObject("yvrckt", 5, "epwest")
		Attack(x.eatk[2], x.ffac)
		x.eatk[3] = BuildObject("yvrckt", 5, "epeast")
		Attack(x.eatk[3], x.frcy)
		for index = 1, 3 do
			SetSkill(x.eatk[index], x.skillsetting)
		end
		x.quakeamount = 4 --start small, it'll get big
		StartEarthQuake(x.quakeamount)
		local bigtimer = 3600;
		x.eshipcheck = GetTime()
		x.quaketime = GetTime() + 300.0
		x.timeescape = GetTime() + 600.0 --6.5min --bz1 10min
		x.bigtimefail = GetTime() + bigtimer;
		StartCockpitTimer(bigtimer, 900, 180)
		x.boomcool = 25.0
		x.boomclock = GetTime() + 600.0
		x.warntime = GetTime() + 300.0 --3min warn
		x.envirotime = GetTime() + 120.0
		x.envirowait = GetTime() + 1.0
		x.envirostate = 1
		x.domambr = 100 --following from map settings
		x.domambg = 120
		x.domambb = 100
		x.skycolr = 145
		x.skycolg = 155
		x.skycolb = 145
		x.skyfogr = 145
		x.skyfogg = 155
		x.skyfogb = 145
		x.skyambr = 100
		x.skyambg = 80
		x.skyambb = 60
		x.suncolr = 200
		x.suncolg = 220
		x.suncolb = 240
		x.fogfar = 400
		x.fognear = 300
		x.spine = x.spine + 1
	end
	
	--HAS PLAYER REACHED THE FURY SHIP FIRST TIME
	if x.spine == 2 and GetDistance(x.player, x.eship) < 350 and x.timeescape > GetTime() then
		TCC.SetTeamNum(x.eship, 0) --can see in sat view, but ai won't attack directly
		AudioMessage("tcss1716.wav") --Alright Grz1, take out all 4 thrusters on that transport.
		ClearObjectives()
		AddObjective("tcss1701.txt", "GREEN")
		AddObjective("	")
		AddObjective("tcss1702.txt")
		for index = 1, 4 do
			SetObjectiveName(x.rckt[index], ("Thruster %d"):format(index))
			SetObjectiveOn(x.rckt[index])
		end
		x.timeescape = GetTime() + 120.0
		x.eshipfound = true
		x.ekillfrcytime = GetTime() + 90.0
		x.easntime = GetTime() + 90.0
		x.sidespine = 1
		x.spine = x.spine + 1
	end
	
	--START TURRETS AND PATROLS
	if x.spine == 3 and x.timeescape < GetTime() then 
		x.epattime = GetTime() --init epat
		for index = 1, x.epatlength do --init epat
			SetPathType(("ppatrol%d"):format(index), 2) --0once, 1return, 2loop
			x.epatcool[index] = GetTime()
			x.epatallow[index] = true
			x.epatlife[index] = 0
		end
		x.eturtime = GetTime() --init etur
		for index = 1, x.eturlength do --init etur
			x.eturcool[index] = GetTime()
			x.eturallow[index] = true
			x.eturlife[index] = 0
		end
		x.timeescape = 99999.9
		x.spine = x.spine + 1
	end
	
	--HAS THE PLAYER REACHED THE DUSTOFF SITE
	if x.spine == 4 and x.sidespine >= 3 and (x.fleetime > GetTime()) and (GetDistance(x.player, "fpnav1") < 100) then
		Damage(x.epat[1], 60000) --keep whole number
		Damage(x.epat[2], 60000) --keep whole number
		Damage(x.easn, 60000) --keep whole number
		for index = 1, 8 do
			Damage(x.ekillfrcy[index], 60000) --keep whole number
		end
		for index = 1, 10 do
			Damage(x.econvoy[index], 60000) --keep whole number
		end
		StopCockpitTimer()
		HideCockpitTimer() 
		ClearObjectives()
		AddObjective("tcss1707.txt", "GREEN")
		x.audio1 = AudioMessage("tcss1708.wav") --SUCCEED - Recycle craft and prepare evac.
		x.waittime = GetTime() + 8.0
		x.fleetime = 99999.9
		x.boomstate = 100
		x.boomtime = 99999.9
		x.MCAcheck = true
		for index = 1, 5 do
			if index > 1 then --BUILD FIRST BIOMETAL ASTEROID AFTER Achilles BLOWS
				x.flyer[index] = BuildObject("avbiometalroid", 0, x.roid[index])
			end
			x.holder[index] = BuildObject("stayput", 0, x.fally[index]) --since still earthquake
		end
		x.spine = x.spine + 1
	end
	
	--TURN OFF THE WORLD
	if x.spine == 5 and IsAudioMessageDone(x.audio1) then
		x.quaketime = 99999.9
		StopEarthQuake()
		x.envirotime = 99999.9 --stop global climate change - it really is that easy
		x.cnslcmdvalue = IFace_GetInteger("options.audio.music") --get "music" volume value of player instance
		x.waittime = GetTime() + 1.0
		x.spine = x.spine + 1
	end
	
	--SETUP END MACHINIMA
	if x.spine == 6 and x.waittime < GetTime() then
		IFace_ConsoleCmd("options.audio.music 5") --adjust player "music" volume instance
		for index = 1, 5 do
			RemoveObject(x.holder[index])
		end
		x.audio1 = AudioMessage("tcss1719.wav")
		x.endcamstart = true
		x.endcamtime = GetTime() --Seed Value
		x.endwaitxpl = GetTime() + 2.5
		IFace_ConsoleCmd("sky.fogrange 300 400")
		IFace_ConsoleCmd("sky.fogcolor 5 5 10" ,1)
		IFace_ConsoleCmd("sky.ambientcolor 250 240 230")
		IFace_ConsoleCmd("sky.color 255 255 255 100")
		IFace_ConsoleCmd("sun.color 180 170 160 400")
		IFace_ConsoleCmd("sun.angle 4.0")
		ClearObjectives()
    x.userfov = IFace_GetInteger("options.graphics.defaultfov")
    CameraReady()
    IFace_SetInteger("options.graphics.defaultfov", x.camfov)
		x.spine = x.spine + 1
	end
	
	--"PAUSE" TO RESTORE MUSIC VOLUME
	if x.spine == 7 and IsAudioMessageDone(x.audio1) then --Watch my machinima bitch! Watch it! no cancel
		IFace_ConsoleCmd(("options.audio.music %d"):format(x.cnslcmdvalue)) --return player "music volume" to previous setting
		x.waittime = GetTime() + 1.0
		x.spine = x.spine + 1
	end
	
	--SUCCEED MISSION
	if x.spine == 8 and x.waittime < GetTime() then
    CameraFinish()
    IFace_SetInteger("options.graphics.defaultfov", x.userfov)
		TCC.SucceedMission(GetTime(), "tcss17w1.des") --WINNER WINNER WINNER (No more than 1s for player music volume reset safety)
		x.spine = x.spine + 1
	end
	----------END MAIN SPINE ----------
	
	--AUTO-QUICKSAVE
	--[[this works better (than ss17) but still not happy with adding files to player's save list
	if x.quicktime < GetTime() then
		x.quickcool = x.quickcool + 600.0 --add time for less saves
		x.quicktime = GetTime() + x.quickcool
		AudioMessage("quicksavesfx.wav")
		IFace_ConsoleCmd("game.quicksave", true)
	end--]]

	--CAMERA FURY SHIP
	if x.camplay == 0 then
		if x.camheight == 0 then --so I can changve value here
			x.camheight = 1000
		end
		if x.camheight >= 100 then
			x.camheight = x.camheight - 5
		end
		CameraPath("pcam0", x.camheight, 2500, x.dummy)
		if x.camtime < GetTime() then --PREP WEST
			x.camplay = 1
			x.camtime = GetTime() + 10.0
			x.fally[3] = BuildObject("avdolly", 0, "pcam1")
			Goto(x.fally[3], "pcam1")
			x.fally[1] = BuildObject("avdolly", 0, "pcam1")
			Goto(x.fally[1], "pcam1")
		end
	end
	
	--CAMERA WEST PATH
	if x.camplay == 1 then
		CameraObject(x.fally[1], 0, 0, -10, x.fally[3])
		--POPS TOO MUCH, even with smoother curves
		--CameraPathDir("pcam1", 5000, 5000)
		if x.camtime < GetTime() then --PREP EAST
			x.camplay = 2
			RemoveObject(x.fally[3]) 
			RemoveObject(x.fally[1])   
			x.fally[4] = BuildObject("avdolly", 0, "pcam2")
			Goto(x.fally[4], "pcam2")
			x.fally[2] = BuildObject("avdolly", 0, "pcam2")
			Goto(x.fally[2], "pcam2")
		end
	end
	
	--CAMERA EAST PATH
	if x.camplay == 2 then
		CameraObject(x.fally[2], 0, 0, -10, x.fally[4])
		--SEE ABOVE CameraPathDir("pcam2", 5000, 5000)
	end
	
	--END OR CANCEL FIRST CAMERA SET
	if (x.camplay >= 0 and x.camplay < 3) and (IsAudioMessageDone(x.audio1) or CameraCancelled()) then
    CameraFinish()
    IFace_SetInteger("options.graphics.defaultfov", x.userfov)
		RemoveObject(x.fally[4]) 
		RemoveObject(x.fally[2])
		x.camplay = 3
	end
	
	--SHAKE RATTLE AND ROLL update and cap quake
	if x.quaketime < GetTime() then
		if x.quakeamount < 70 then
			x.quakeamount = x.quakeamount + 1
		end
		StopEarthQuake() --so quake sfx doesn't pile up
		StartEarthQuake(x.quakeamount) --b/c quake won't restart after savegame load
		x.quaketime = GetTime() + 90.0
	end
	
	--ROCKET POD DESTROYED MESSAGES
	if x.sidespine == 1 and not x.rcktmsg[4] then
		for index = 1, 4 do
			if not IsAlive(x.rckt[index]) and not x.rcktdead[index] then
				x.rcktdead[index] = true
				x.rcktcheck = x.rcktcheck + 1
			end
		end
		if x.rcktcheck == 1 and not x.rcktmsg[1] then
			x.egun[1] = BuildObject("yvrckt", 5, "epeast")
			SetSkill(x.egun[1], x.skillsetting)
			Attack(x.egun[1], x.frcy)
			x.egun[2] = BuildObject("yvrckt", 5, "epwest")
			SetSkill(x.egun[2], x.skillsetting)
			Attack(x.egun[2], x.frcy)
			AudioMessage("tcss1713.wav") --That's one down sir. Three to go.
			x.rcktmsg[1] = true
		elseif x.rcktcheck == 2 and not x.rcktmsg[2] then
			x.egun[1] = BuildObject("yvrckt", 5, "epeast")
			SetSkill(x.egun[1], x.skillsetting)
			Attack(x.egun[1], x.frcy)
			x.egun[2] = BuildObject("yvrckt", 5, "epwest")
			SetSkill(x.egun[2], x.skillsetting)
			Attack(x.egun[2], x.frcy)
			AudioMessage("tcss1714.wav") --Two thrusters have been destroyed Cmd. We're half there.
			x.rcktmsg[2] = true
		elseif x.rcktcheck == 3 and not x.rcktmsg[3] then
			x.egun[1] = BuildObject("yvrckt", 5, "epeast")
			SetSkill(x.egun[1], x.skillsetting)
			Attack(x.egun[1], x.frcy)
			x.egun[2] = BuildObject("yvrckt", 5, "epwest")
			SetSkill(x.egun[2], x.skillsetting)
			Attack(x.egun[2], x.frcy)
			AudioMessage("tcss1715.wav") --Alright Cmd, take out last thruster and we're out.
			for index = 1, 4 do --get the last living rocket thruster
				if IsAlive(x.rckt[index]) then
					x.rcktlast = x.rckt[index]
					break
				end
			end
			x.rcktmsg[3] = true
		elseif x.rcktcheck == 4 and not x.rcktmsg[4] then
			x.eshipboom = true
			x.eshipcheck = 99999.9
			Damage(x.eship, (GetMaxHealth(x.eship)+100))
			AudioMessage("tcss1704.wav") --Good job now get to Texas. You have 3 minutes.
			ClearObjectives()
			AddObjective("tcss1702.txt", "GREEN")
			x.waittime = GetTime() + 3.0
			x.sidespine = 2
			x.bigtimefail = 99999.9
			StopCockpitTimer()
			HideCockpitTimer()
			x.boomstate = 5 --turn up the boom if not already there
			x.boomcool = 0.0
			x.rcktmsg[4] = true
		end
	end
	
	--FURY CONVOY
	if x.econvoystart == 0 then --WARN TO RECON FURY TRANSPORT
		if x.warntime < GetTime() and not x.eshipfound and GetDistance(x.player, x.eship) > 500 then
			AudioMessage("alertpulse.wav")
			AddObjective("	")
			AddObjective("Recon the transport ASAP.", "YELLOW");
			AddObjective("You have 5 minutes.", "ORANGE");
			x.econvoystart = 1
		elseif (GetDistance(x.player, "epship") < 600 or GetDistance(x.player, "epatk3") < 500 or GetDistance(x.player, "epatk6") < 500) then
			x.econvoystart = 1
		end
	elseif x.econvoystart == 1 then --INIT CONVOY
		SetPathType("epatk3", 2)
		SetPathType("epatk6", 2)
		for index = 1, 2 do
			x.eatk[index] = BuildObject("yvartl", 5, ("ephome%d"):format(index))
			SetSkill(x.eatk[index], x.skillsetting)
			Patrol(x.eatk[index], ("epatk%d"):format(index*3))
		end
		x.warntime = 99999.9
		x.waittime = GetTime() + 120.0
		x.econvoystart = 2
	elseif x.econvoystart == 2 and x.waittime < GetTime() then
		for index = 1, 10 do --init convoy
			x.econvoystate[index] = 1 --init to 1
			x.econvoy[index] = nil
		end
		x.econvoycool[1] = GetTime() + 30.0
		x.econvoycool[2] = GetTime() + 90.0
		x.econvoycool[3] = GetTime() + 150.0
		x.econvoycool[4] = GetTime() + 210.0
		x.econvoycool[5] = GetTime() + 270.0
		x.econvoycool[6] = GetTime() + 330.0
		x.econvoycool[7] = GetTime() + 60.0
		x.econvoycool[8] = GetTime() + 120.0
		x.econvoycool[9] = GetTime() + 90.0
		x.econvoycool[10] = GetTime() + 150.0
		x.econvoystart = 3
	elseif x.econvoystart == 3 then --RUN CONVOY
		for index = 1, 10 do
			if x.econvoystate[index] == 0 and not IsAlive(x.econvoy[index]) then
				x.econvoycool[index] = GetTime() + 240.0 + x.econvoycooladd
				x.econvoycooladd = x.econvoycooladd + 30.0
				x.econvoystate[index] = x.econvoystate[index] + 1
			end
			if x.econvoystate[index] == 1 and x.econvoycool[index] < GetTime() then
				if index == 1 then
					x.econvoy[1] = BuildObject("yvartl", 5, "ephome1")
				elseif index == 2 then
					x.econvoy[2] = BuildObject("yvrckt", 5, "ephome1")
				elseif index == 3 then
					x.econvoy[3] = BuildObject("yvwalk", 5, "ephome1")
				elseif index == 4 then
					x.econvoy[4] = BuildObject("yvhtnk", 5, "ephome1")
				elseif index == 5 then
					x.econvoy[5] = BuildObject("yvtank", 5, "ephome1")
				elseif index == 6 then
					x.econvoy[6] = BuildObject("yvmisl", 5, "ephome1")
				elseif index == 7 then
					x.econvoy[7] = BuildObject("yvartl", 5, "ephome2")
				elseif index == 8 then
					x.econvoy[8] = BuildObject("yvwalk", 5, "ephome2")
				elseif index == 9 then
					x.econvoy[9] = BuildObject("yvrckt", 5, "ephome3")
				elseif index == 10 then
					x.econvoy[10] = BuildObject("yvhtnk", 5, "ephome3")
				end
				SetSkill(x.econvoy[index], x.skillsetting)
				if index <= 6 and IsAlive(x.econvoy[index]) and GetDistance(x.econvoy[index], "epship") > 400 then
					Goto(x.econvoy[index], "ephome1")
				elseif index == 7 or index == 8 and IsAlive(x.econvoy[index]) and GetDistance(x.econvoy[index], "epship") > 400 then
					Goto(x.econvoy[index], "ephome2") --odd 2
				elseif index == 9 or index == 10 and IsAlive(x.econvoy[index]) and GetDistance(x.econvoy[index], "epship") > 400 then
					Goto(x.econvoy[index], "ephome3") --even 3
				end
				x.econvoystate[index] = x.econvoystate[index] + 1
			elseif x.econvoystate[index] == 2 and IsAlive(x.econvoy[index]) and GetDistance(x.econvoy[index], "epship") < 400 then
				Goto(x.econvoy[index], ("pc%d"):format(index))
				x.econvoystate[index] = 0 --reset
			end
		end
	end
	
	--KEEP LAST ROCKET ALIVE IF PLAYER IS TOO FAR AWAY
	x.player = GetPlayerHandle()
	if x.rcktlaststate == 0 and IsAround(x.rcktlast) and IsAlive(x.eship) and GetDistance(x.player, x.eship) > 300 then
		x.rcktlasthealth = GetCurHealth(x.rcktlast)
		x.rcktlaststate = x.rcktlaststate + 1
	elseif x.rcktlaststate == 1 and IsAlive(x.eship) and GetDistance(x.player, x.eship) > 300 then
		SetCurHealth(x.rcktlast, x.rcktlasthealth) --might cause weirdness if all done in one line
		if GetCurHealth(x.rcktlast) < 3000 then
			SetCurHealth(x.rcktlast, 3000)
		end
	elseif x.rcktlaststate == 1 and GetDistance(x.player, x.eship) <= 300 then
		x.rcktlaststate = 0
	end
	
	--KEEP FURY TRANSPORT ALIVE
	if not x.eshipboom and IsAlive(x.eship) and x.eshipcheck < GetTime() then
		SetCurHealth(x.eship, GetMaxHealth(x.eship))
		x.eshipcheck = GetTime() + 5.0
	end
	
	--GIVE FINAL OBJECTIVE
	if x.sidespine == 2 and x.waittime < GetTime() then
		x.epattime = 99999.9
		x.ekillfrcytime = 99999.9
		x.econvoystart = 666 --turn off convoy
		x.easntime = 99999.9
		x.eleftbehindtime = GetTime()
		x.fleetime = GetTime() + 180.0
		x.fleewarntime = GetTime() + 60.0
		x.fdrpevac = 1
		AddObjective(" ")
		AddObjective("tcss1703.txt")
		x.fnav[5] = BuildObject("apcamra", 1, "fpnav1") --can't delete camera beacon
		SetObjectiveName(x.fnav[5], "Dustoff")
		SetObjectiveOn(x.fnav[5])
		StartCockpitTimer(180, 60, 30)
		x.sidespine = 3
	end
	
	--WARN PLAYER IF TAKING WEST PATH TO ESCAPE
	if not x.wrongway and x.sidespine == 3 and GetDistance(x.player, "epatk1") < 200 then
		AudioMessage("tcss1705.wav") --We detect a lot of Fury on this path. Take other route home.
		x.wrongway = true
	end

	--PLAYER RETREATING MESSAGES after 1st minute and then every 30s
	if x.sidespine == 3 then
		if x.fleemsg == 0 and x.fleewarntime < GetTime() then
			x.audio1 = AudioMessage("tcss1709.wav") --You better hurry. Ground unstable here.
			x.fleewarntime = GetTime() + 30.0
			x.fleemsg = 1
		elseif x.fleemsg == 1 and x.fleewarntime < GetTime() then
			x.frcyremove = true --frcy can die and not fail mission
			if GetDistance(x.player, "fpnav1") > 300 then
				x.audio1 = AudioMessage("tcss1710.wav") --Texas taking damage. Can't hold out much longer.
			end
			x.fleewarntime = GetTime() + 30.0
			x.fleemsg = 2
		elseif x.fleemsg == 2 and x.fleewarntime < GetTime() then
			if GetDistance(x.player, "fpnav1") > 300 then
				x.audio1 = AudioMessage("tcss1711.wav") --Where are you Griz 1 we need to get out.
			end
			x.fleewarntime = GetTime() + 30.0
			x.fleemsg = 3
		elseif x.fleemsg == 3 and x.fleewarntime < GetTime() then
			if GetDistance(x.player, "fpnav1") > 250 then
				x.audio1 = AudioMessage("tcss1712.wav") --Griz one you need to get here now. Ach breaking up
			end
			x.sidespine = 777
		end
	end
	
	--DROPSHIP EVACUATE
	if x.fdrpevac == 1 and GetDistance(x.player, "fpnav1") < 600 then
		x.fdrp[1] = BuildObject("avdrop", 0, x.fdrppos1)
		x.fdrp[2] = BuildObject("avdrop", 0, x.fdrppos2)
		x.fdrp[3] = BuildObject("avdrop", 0, x.fdrppos3)
		for index = 1, 3 do
			SetAnimation(x.fdrp[index], "land", 1)
		end
		x.fdrpevac = x.fdrpevac + 1
	elseif x.fdrpevac == 2 and GetDistance(x.player, "fpnav1") < 120 then
		for index = 1, 3 do
			SetAnimation(x.fdrp[index], "open", 1)
		end
		x.fdrpevac = x.fdrpevac + 1
	end
	
	--FURY GROUP TURRET GENERIC
	if x.eturtime < GetTime() then
		for index = 1, x.eturlength do
			if not IsAlive(x.etur[index]) and not x.eturallow[index] and x.eturlife[index] < 2 then
				x.eturcool[index] = GetTime() + 240.0
				x.eturallow[index] = true
			end
			if x.eturallow[index] and x.eturcool[index] < GetTime() then
				x.etur[index] = BuildObject("yvturr", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
				SetSkill(x.etur[index], x.skillsetting)
				--SetObjectiveName(x.etur[index], ("Teucer %d"):format(index))
				Goto(x.etur[index], ("eptur%d"):format(index))
				x.eturallow[index] = false
				x.eturlife[index] = x.eturlife[index] + 1
			end
		end
		x.eturtime = GetTime() + 60.0
	end
	
	--FURY GROUP SCOUT PATROLS
	if x.epattime < GetTime() then
		for index = 1, x.epatlength do
			if not IsAlive(x.epat[index]) and not x.epatallow[index] and x.epatlife[index] < 3 then
				x.epatcool[index] = GetTime() + 240.0
				x.epatallow[index] = true
			end
			if not IsAlive(x.epat[index]) and x.epatallow[index] and x.epatcool[index] < GetTime() then
				while x.randompick == x.randomlast do --random the random
					x.randompick = math.floor(GetRandomFloat(1.0, 9.0))
				end
				x.randomlast = x.randompick
				if x.randompick == 1 or x.randompick == 4 or x.randompick == 7 then
					x.epat[index] = BuildObject("yvmbike", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
				elseif x.randompick == 2 or x.randompick == 5 or x.randompick == 8 then
					x.epat[index] = BuildObject("yvmisl", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
				else
					x.epat[index] = BuildObject("yvtank", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn 
				end
				SetSkill(x.epat[index], x.skillsetting)
				Patrol(x.epat[index], ("ppatrol%d"):format(index))
				--SetObjectiveName(x.epat[index], ("Patrol %d"):format(index))
				x.epatallow[index] = false
				x.epatlife[index] = x.epatlife[index] + 1
			end
		end
		x.epattime = GetTime() + 60.0
	end
	
	--FURY KILL RECYCLER
	if x.ekillfrcytime < GetTime() and IsAlive(x.frcy) then
		if not x.ekillfrcybuild then
			for index = 1, x.ekillfrcylength do
				if not IsAlive(x.ekillfrcy[index]) then
					x.casualty = x.casualty + 1
				end
			end
			if x.casualty < math.floor(x.ekillfrcylength * 0.8) then
				x.casualty = 0
			elseif not x.ekillfrcyreset then
				x.casualty = 0
				x.ekillfrcybuild = true
				x.ekillfrcyreset = true
				x.ekillfrcywave = x.ekillfrcywave + 1
				if x.ekillfrcywave > 4 then
					x.ekillfrcywave = 1
				end
				if x.ekillfrcywave == 1 then
					x.ekillfrcylength = 2
				elseif x.ekillfrcywave == 2 then
					x.ekillfrcylength = 4
				elseif x.ekillfrcywave == 3 then
					x.ekillfrcylength = 6
				else
					x.ekillfrcylength = 10
					AudioMessage("tcss1717.wav") --Grz, Furies attacking Texas. Protect it.
				end
			end
		end
		if x.ekillfrcybuild then
			for index = 1, x.ekillfrcylength do
				while x.randompick == x.randomlast do
					x.randompick = math.floor(GetRandomFloat(1.0, 20.0))
				end
				x.randomlast = x.randompick
				if x.randompick == 1 or x.randompick == 9 or x.randompick == 17 then
					x.ekillfrcy[index] = BuildObject("yvrckt", 5, GetPositionNear("epeast", 0, 12, 24))  --"epeast")
				elseif x.randompick == 2 or x.randompick == 10 or x.randompick == 18 then
					x.ekillfrcy[index] = BuildObject("yvrckt", 5, GetPositionNear("epwest", 0, 12, 24))  --"epwest")
				elseif x.randompick == 3 or x.randompick == 11 then
					x.ekillfrcy[index] = BuildObject("yvartl", 5, GetPositionNear("epeast", 0, 12, 24))  --"epeast")
				elseif x.randompick == 4 or x.randompick == 12 then
					x.ekillfrcy[index] = BuildObject("yvartl", 5, GetPositionNear("epwest", 0, 12, 24))  --"epwest")
				elseif x.randompick == 5 or x.randompick == 13 or x.randompick == 19 then
					x.ekillfrcy[index] = BuildObject("yvwalk", 5, GetPositionNear("epeast", 0, 12, 24))  --"epeast")
          if index == 13 then
            GiveWeapon(x.ekillfrcy[index], "gfplsy_a")
          end
				elseif x.randompick == 6 or x.randompick == 14 or x.randompick == 20 then
					x.ekillfrcy[index] = BuildObject("yvwalk", 5, GetPositionNear("epwest", 0, 12, 24))  --"epwest")
          if index == 14 then
            GiveWeapon(x.ekillfrcy[index], "gfplsy_a")
          end
				elseif x.randompick == 7 or x.randompick == 15 then
					x.ekillfrcy[index] = BuildObject("yvhtnk", 5, GetPositionNear("epeast", 0, 12, 24))  --"epeast")
				else
					x.ekillfrcy[index] = BuildObject("yvhtnk", 5, GetPositionNear("epwest", 0, 12, 24))  --"epwest")
				end
				SetSkill(x.ekillfrcy[index], x.skillsetting)
				--SetObjectiveName(x.ekillfrcy[index], ("Recy Killer %d"):format(index)) --Texas Assassin
			end
			x.ekillfrcyreset = false
			x.ekillfrcybuild = false
		end
		if not x.ekillfrcybuild then
			for index = 1, x.ekillfrcylength do
				if IsAlive(x.ekillfrcy[index]) then
					Attack(x.ekillfrcy[index], x.frcy)
					x.ekillfrcytime = GetTime() + 240.0
				end
			end
		end
	end
	
	--FURY PLAYER ASSASSIN
	if x.easntime < GetTime() then
		if not IsAlive(x.easn) then
			x.easn = BuildObject("yvrckt", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
			SetSkill(x.easn, x.skillsetting)
		end
		if x.easnallow then
			Attack(x.easn, x.player)
			x.easntime = GetTime() + 180.0
		else
			x.easntime = GetTime() + 20.0
		end
	end

	--FURY LEFT BEHIND ATTACK
	if x.eleftbehindtime < GetTime() then
		x.eatk[1] = BuildObject("yvrckt", 5, "epatk1") --WEST PATH
		x.eatk[2] = BuildObject("yvartl", 5, "epatk2")
		x.eatk[3] = BuildObject("yvrckt", 5, "epatk3")
		x.eatk[4] = BuildObject("yvartl", 5, "epatk4")
		x.eatk[5] = BuildObject("yvartl", 5, "epatk5") --EAST PATH
		x.eatk[6] = BuildObject("yvrckt", 5, "epatk6")
		x.eatk[7] = BuildObject("yvartl", 5, "epatk7")
		for index = 1, 7 do
			SetSkill(x.eatk[index], x.skillsetting)
			Defend(x.eatk[index])
		end
		x.eleftbehindtime = 99999.9
	end
	
	--CHANGE ENVIRONMENT COLORS --On savegame load, it takes ~minute for the saved changes to be reinstated.
	--"Everybody talks about the weather, but nobody does anything about it." Until now. bawahahahahahahahaha
	if x.envirotime < GetTime() then
		x.envirochange = 4
		if x.envirostate == 1 and x.envirowait < GetTime() then
			if x.domambr < 255 then
				x.domambr = x.domambr + 1 + x.envirochange
			end
			if x.domambg > 30 then
				x.domambg = x.domambg - 1 - x.envirochange
			end
			if x.domambb > 0 then
				x.domambb = x.domambb - 1 - x.envirochange
			end
			IFace_ConsoleCmd(("dome.ambient %d %d %d"):format(x.domambr, x.domambg, x.domambb)) --dome.ambient 100 120 100
			x.envirostate = x.envirostate + 1
			x.envirowait = GetTime() + 1.0
		elseif x.envirostate == 2 and x.envirowait < GetTime() then
			if x.skycolr < 255 then
				x.skycolr = x.skycolr + x.envirochange
			end
			if x.skycolg > 50 then
				x.skycolg = x.skycolg - x.envirochange
			end
			if x.skycolb > 0 then
				x.skycolb = x.skycolb - x.envirochange
			end
			IFace_ConsoleCmd(("sky.color %d %d %d 100"):format(x.skycolr, x.skycolg, x.skycolb)) --sky.color 145 155 145 100
			x.envirostate = x.envirostate + 1
			x.envirowait = GetTime() + 1.0
		elseif x.envirostate == 3 and x.envirowait < GetTime() then
			if x.skyfogr < 255 then
				x.skyfogr = x.skyfogr + x.envirochange
			end
			if x.skyfogg > 50 then
				x.skyfogg = x.skyfogg - x.envirochange
			end
			if x.skyfogb > 0 then
				x.skyfogb = x.skyfogb - x.envirochange
			end
			IFace_ConsoleCmd(("sky.fogcolor %d %d %d"):format(x.skyfogr, x.skyfogg, x.skyfogb)) --sky.fogcolor 145 155 145
			x.envirostate = x.envirostate + 1
			x.envirowait = GetTime() + 1.0
		elseif x.envirostate == 4 and x.envirowait < GetTime() then
			if x.skyambr < 255 then
				x.skyambr = x.skyambr + x.envirochange
			end
			if x.skyambg > 50 then
				x.skyambg = x.skyambg - x.envirochange
			end
			if x.skyambb > 0 then
				x.skyambb = x.skyambb - x.envirochange
			end
			IFace_ConsoleCmd(("sky.ambientcolor %d %d %d"):format(x.skyambr, x.skyambg, x.skyambb)) --sky.ambientcolor 100 110 125
			x.envirostate = x.envirostate + 1
			x.envirowait = GetTime() + 1.0
		elseif x.envirostate == 5 and x.envirowait < GetTime() then
			if x.suncolr < 255 then
				x.suncolr = x.suncolr + x.envirochange
			end
			if x.suncolg > 50 then
				x.suncolg = x.suncolg - x.envirochange
			end
			if x.suncolb > 0 then
				x.suncolb = x.suncolb - x.envirochange
			end
			IFace_ConsoleCmd(("sun.color %d %d %d 200"):format(x.suncolr, x.suncolg, x.suncolb)) --sun.color 200 220 240 200
			x.envirostate = x.envirostate + 1
			x.envirowait = GetTime() + 1.0
		elseif x.envirostate == 6 and x.envirowait < GetTime() then
			if x.fognear > -30 then
				x.fognear = x.fognear - 1 - x.envirochange
			end
			IFace_ConsoleCmd(("sky.fogrange %d %d"):format(x.fognear, x.fogfar)) --sky.fogrange 300 400
			x.envirostate = 1 --reset
			x.envirowait = GetTime() + 1.0
			x.envirotime = GetTime() + 60.0 --reset
		end
	end
	
	--BOOM SPLOSIONS CLOCK
	if x.boomstate < 5 and x.boomclock < GetTime() then
		x.boomcool = x.boomcool - 5.0
		x.boomtime = GetTime() + x.boomcool
		x.boomclock = GetTime() + 600.0
		x.boomstate = x.boomstate + 1
	end

	--BOOM SPLOSIONS DETONATE
	if x.boomtime < GetTime() then
		for index = 1, 12 do
			x.randompick = math.floor(GetRandomFloat(1.0, 9.0))
		end
		while x.boompick == x.boomlast do
			x.boompick = math.floor(GetRandomFloat(1.0, 100.0))
		end
		x.boomlast = x.boompick
		if x.randompick == 1 or x.randompick == 4 or x.randompick == 7 then
			x.boomobj = BuildObject("oboompot", 0, "pboom1", x.boompick)
		elseif x.randompick == 2 or x.randompick == 5 or x.randompick == 8 then
			x.boomobj = BuildObject("oboompot", 0, "pboom2", x.boompick)
		else
			x.boomobj = BuildObject("oboompot", 0, "pboom3", x.boompick)
		end
		x.boomtime = x.boomcool + GetTime()
	end
	
	--RUN ENDING CINERACTIVE
	if x.endcamstart then
		if x.endwaitxpl < GetTime() then --blow achilles and spawn biometalroid
			x.flyer[1] = BuildObject("avbiometalroid", 0, x.achlprop)
			Damage(x.achlprop, 10000)
			Retreat(x.flyer[1], x.fin[1]) --start first off here
		end
		
		if x.endstg < 5 and x.endcamtime < GetTime() then --set time and send other roids out
			x.endstg = x.endstg + 1
			Retreat(x.flyer[x.endstg], x.fin[x.endstg])
			x.endcamtime = GetTime() + 9.0
		end
		
		if x.endcamtime > GetTime() and x.endstg < 6 then --show each roid to player
			CameraPath(("pend2%d"):format(x.endstg), 6400, 0, x.endball[x.endstg])
		end
	end
	
	--CHECK STATUS OF MCA
	if not x.MCAcheck then
		if not x.frcyremove and not IsAlive(x.frcy) then --frecy killed
			AudioMessage("tcss1718.wav") --FAIL - Recy Texas lost.
			ClearObjectives()
			AddObjective("tcss1704.txt", "RED") --Texas lost mission failed
			TCC.FailMission(GetTime() + 5.0, "tcss17f3.des") --LOSER LOSER LOSER
			x.spine = 666
			x.MCAcheck = true
		end
		
		if not x.eshipfound and x.timeescape < GetTime() then --fury escape
			x.pos = GetTransform(x.eship)
			RemoveObject(x.eship)
			x.eship = BuildObject("ybship2", 0, x.pos)
			for index = 1, 4 do
				RemoveObject(x.rckt[index])
			end
			SetAnimation(x.eship, "launch", 1)
			AudioMessage("tcss1706.wav") --FAIL - Fury escaped.
			ClearObjectives()
			AddObjective("tcss1705.txt", "RED")
			TCC.FailMission(GetTime() + 6.0, "tcss17f1.des") --LOSER LOSER LOSER
			x.spine = 666
			x.MCAcheck = true
		end
		
		if x.fleetime < GetTime() then --left behind
			AudioMessage("tcss1707.wav") --FAIL - Left behind.
			ClearObjectives()
			AddObjective("tcss1706.txt", "RED")
			TCC.FailMission(GetTime() + 6.0, "tcss17f2.des") --LOSER LOSER LOSER
			x.spine = 666
			x.MCAcheck = true
		end
		
		if x.bigtimefail < GetTime() then --out of time
			StopCockpitTimer()
			HideCockpitTimer()
			SetColorFade(15.0, 0.5, "RED")
			AudioMessage("xemt2.wav")
			TCC.FailMission(GetTime() + 2.0, "tcss17f4.des") --LOSER LOSER LOSER
			x.spine = 666
			x.MCAcheck = true
		end
	end
end
--[[END OF SCRIPT]]