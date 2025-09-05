--bztcss13 - Battlezone Total Command - Stars and Stripes - 13/17 - THE THREE BEACONS
assert(load(assert(LoadFile("_requirefix.lua")),"_requirefix.lua"))();
TCC = require("TC_Core")
MisnNum = 49;
require("bzccGPNfix");
--require("_MCFunctions");
--DECLARE variables --f-friend, e-enemy, atk-attack, rcy-recycler, etc...
local index = 0
local index2 = 0
local indexadd = 0
local vartostring = 0
local GetPositionNear = GetPositionNearPath
local x = {
	FIRST = true,
	getiton = false, 
	MCAcheck = false,
	player = nil, 
	mytank = nil, 
	skillsetting = 0, 
	spine = 0, 
	casualty = 0, 
	randompick = 0, 
	fnav0 = nil, 
	fnav1 = nil, 
	audio1 = nil, 
	waittime = 99999.9, 
	pos = {}, 
	free_player = false, 
	controls = {braccel = 0, strafe = 0, jump = 0, deploy = 0, eject = 0, abandon = 0, fire = 0}, 
	holder = {}, 
	fescortalive = false, 
	fpilopresent = false, 
	frcydie = false, 
	camtoggle1 = false, 
	camplay = 0,	
	camstop1 = false, 
	camfov = 60,  --185 default
	userfov = 90,  --seed
	giveorder = false, 
	rescuecam = false, 
	rescuebuild = 0, 
	fescortReadyCCA = false, 
	etrndie = false, 
	rescueDistance = false, 
	efuryfrcybuild = false, 
	efuryfrcyreset = false, 
	efuryfrcytime = 99999.9, 
	efuryfesctime = 99999.9, 
	efuryfesc = {}, 
	efuryfescwave = 0, 
	rescueasn = false, 
	reminder = false, 
	camtime = 99999.9, 
	collinsTime1 = 99999.9, 
	collinsTime2 = 99999.9, 
	rescueTime = 99999.9, 
	ercy = nil, 
	efac = nil, 
	earm = nil, 
	esil = {}, 
	holder = {},
	fdrp = {}, 
	ftnk = {}, 
	fscv1 = nil, 
	fscv2 = nil, 
	frcy = nil, 
	ffac = nil, 
	farm = nil, 
	fescort = nil, 
	fpilo = {}, 
	rescueasn = nil, 
	efuryfrcy = {}, 
	ypilo = nil, 
	randomlast = 0, 
	rescueasnsqd = 0, 
	efuryfrcylength = 4, 
	furymsg = false, 
	eturtime = 99999.9, --etur stuff
	eturlength = 12, 
	etur = {}, 
	eturcool = {}, 
	eturallow = {}, 
	epattime = 99999.9, --epat stuff
	epatlength = 4, 
	epat = {}, 
	epatcool = {}, 
	epatallow = {}, 
	fpwr = {nil, nil, nil, nil}, 
	fcom = nil, 
	fbay = nil, 
	ftrn = nil, 
	ftec = nil, 
	fhqr = nil, 
	fsld = nil,	
	escv = {}, 
	escvbuildtime = 99999.9,
	ewardeclare = false, --WARCODE --1 recy, 2 fact, 3 armo, 4 base 
	ewartotal = 4,
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
	ewartrgt = {}, 
	LAST = true
}
--PATHS: fnav1-5, epgrcy, epgfac, eptur0-11, ppatrol1-7, stage1-2, pdrp, pcam0, pcam1, prescue1-4, ppilo10-2, ppilo20-2, ppilo30-2, pasn1abc-3abc, pescape, pfryapc(0-4), pfryrcy(0-4)

function InitialSetup()
	SetAutoGroupUnits(true)
	
	local odfpreload = {
		"avrecyss13", "avfactss13", "avarmo", "avconsss13", "avscout", "avmbike", "avscav", "avtank", "avturr", "avdrop", 
		"yvscoutss13", "yvmbikess13", "yvmislss13", "yvrcktss13", "svmine", "svartl", "stayput", "apcamra"
	}
	for k,v in pairs(odfpreload) do
		PreloadODF(v)
	end

	x.ercy = GetHandle("ercy")
	x.efac = GetHandle("efac")
	x.earm = GetHandle("earm")
	x.etrn = GetHandle("etrn")
	x.esil[1] = GetHandle("escv1") --predeployed
	x.esil[2] = GetHandle("escv2") --..CCA
	x.esil[3] = GetHandle("escv3") --...scav
	x.esil[4] = GetHandle("escv4") --....silo
	x.frcy = GetHandle("frcy")
	x.ffac = GetHandle("ffac")
	x.farm = GetHandle("farm")
	x.mytank = GetHandle("mytank")
	x.fdrp[1] = GetHandle("drp1") --no "f" drp prefix
	x.fdrp[2] = GetHandle("drp2")
	x.fdrp[3] = GetHandle("drp3")
	x.fdrp[4] = GetHandle("drp4")
	x.ftnk[1] = GetHandle("fgrp1")
	x.ftnk[2] = GetHandle("fgrp2")
	x.ftnk[3] = GetHandle("fgrp3")
	x.ftnk[4] = GetHandle("fgrp4")
	x.fscv1 = GetHandle("fgrp5")
	x.fscv2 = GetHandle("fgrp6")
	Ally(1, 4)
	Ally(4, 1) --4 aspilo rescues
  Ally(4, 5)
  Ally(5, 4)
	Ally(2, 5) --2 Furies
	Ally(5, 2)
	Ally(5, 6) --5 cca enemey
	Ally(5, 7)
	Ally(6, 5) --6 assassin purple
	Ally(7, 5) --7 assassin blac
	SetTeamColor(6, 100, 70, 100)
	SetTeamColor(7, 50, 30, 50)  
	SetColorFade(6.0, 0.5, "BLACK")
	TCC.Init()
end

function Start()
	TCC.Start();
end
function Save()
	return
	index, index2, indexadd, vartostring, x, TCC.Save()
end

function Load(a, b, c, d, e, coreData)
	index = a;
	index2 = b;
	indexadd = c;
	vartostring = d;
	x = e;
	TCC.Load(coreData)
end

function AddObject(h)
	if not x.fescortalive and IsOdf(h, "avapc:1") then --APC to be x.fescort
		x.fescort = h
		SetObjectiveName(x.fescort, "PROTECT APC")
		SetObjectiveOn(x.fescort)
		x.fescortalive = true
	end

	local r = GetRace(h);
	if (r == "s" or r == "y") then
		SetEjectRatio(h, 0.0);
	end
	--[[
	if IsOdf(h, "yspilo") then
		RemoveObject(h);
		return;
	end
	
	if IsOdf(h, "sspilo") then
		if GetTeamNum(h) ~= 5 then
			RemoveObject(h);
			return;
		end
	end
	]]
	if (not IsAlive(x.farm) or x.farm == nil) and (IsOdf(h, "avarmo") or IsOdf(h, "abarmo")) then
		x.farm = RepObject(h);
		h = x.farm;
	elseif (not IsAlive(x.ffac) or x.ffac == nil) and (IsOdf(h, "avfact") or IsOdf(h, "abfact")) then
		x.ffac = h
	elseif (not IsAlive(x.fsld) or x.fsld == nil) and IsOdf(h, "abshld") then
		x.fsld = h
	elseif (not IsAlive(x.fhqr) or x.fhqr == nil) and IsOdf(h, "abhqtr") then
		x.fhqr = h
	elseif (not IsAlive(x.ftec) or x.ftec == nil) and IsOdf(h, "abtcen") then
		x.ftec = h
	elseif (not IsAlive(x.ftrn) or x.ftrn == nil) and IsOdf(h, "abtrain") then
		x.ftrn = h
	elseif (not IsAlive(x.fbay) or x.fbay == nil) and IsOdf(h, "absbay") then
		x.fbay = h
	elseif (not IsAlive(x.fcom) or x.fcom == nil) and IsOdf(h, "abcbun") then
		x.fcom = h
	elseif IsOdf(h, "abpgen2") then
		for indexadd = 1, 4 do
			if x.fpwr[indexadd] == nil or not IsAlive(x.fpwr[indexadd]) then
				x.fpwr[indexadd] = h
				break
			end
		end
	elseif (IsAlive(h) or IsPlayer(h)) then
		ReplaceStabber(h);
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
		x.pos = GetTransform(x.mytank)
		RemoveObject(x.mytank)
		x.mytank = BuildObject("avtank", 1, x.pos)  	
		x.pos = GetTransform(x.frcy)
		RemoveObject(x.frcy)
		x.frcy = BuildObject("avrecyss13", 1, x.pos)
		x.pos = GetTransform(x.ffac)
		RemoveObject(x.ffac)
		x.ffac = BuildObject("avfactss13", 1, x.pos)
		x.pos = GetTransform (x.farm)
		RemoveObject(x.farm)
		x.farm = BuildObject("avarmo", 1,	x.pos)
		x.pos = GetTransform(x.ftnk[1])
		RemoveObject(x.ftnk[1])
		x.ftnk[1] = BuildObject("avscout", 1, x.pos)
		x.pos = GetTransform(x.ftnk[2])
		RemoveObject(x.ftnk[2])
		x.ftnk[2] = BuildObject("avrckt", 1, x.pos)
		x.pos = GetTransform(x.ftnk[3])
		RemoveObject(x.ftnk[3])
		x.ftnk[3] = BuildObject("avconsss13", 1, x.pos)
		x.pos = GetTransform(x.ftnk[4])
		RemoveObject(x.ftnk[4])
		x.ftnk[4] = BuildObject("avturr", 1, x.pos)
		x.pos = GetTransform(x.fscv1)
		RemoveObject(x.fscv1)
		SetAsUser(x.mytank, 1)
		RemoveObject(x.player)
		x.player = GetPlayerHandle()
		SetSkill(x.frcy, x.skillsetting)
		SetSkill(x.ffac, x.skillsetting)
		SetGroup(x.ftnk[1], 3)
		SetGroup(x.ftnk[2], 3)
		SetGroup(x.ftnk[3], 4)
		SetGroup(x.ftnk[4], 5)
		for index = 1, 4 do
			SetSkill(x.ftnk[index], x.skillsetting)
		end
		x.fscv1 = BuildObject("avscav", 1, x.pos)
		SetGroup(x.fscv1, 6)
		x.pos = GetTransform(x.fscv2)
		RemoveObject(x.fscv2)
		x.fscv2 = BuildObject("avscav", 1, x.pos)
		SetGroup(x.fscv2, 6)
		x.fnav1 = BuildObject("apcamra", 1, "fnav0")
		SetObjectiveName(x.fnav1, "Dropzone")
		x.fnav1 = BuildObject("apcamra", 1, "fnav5")
		SetObjectiveName(x.fnav1, "CCA base")
		--[[x.fnav1 = BuildObject("apcamra", 1, "fnav1")
		SetObjectiveName(x.fnav1, "S pool")
		x.fnav1 = BuildObject("apcamra", 1, "fnav2")
		SetObjectiveName(x.fnav1, "SE pool")
		x.fnav1 = BuildObject("apcamra", 1, "fnav3")
		SetObjectiveName(x.fnav1, "SW pool")
		x.fnav1 = BuildObject("apcamra", 1, "fnav4")
		SetObjectiveName(x.fnav1, "NW pool")--]]
		for index = 1, x.eturlength do
			x.etur[index] = BuildObject("svturr", 5, ("eptur%d"):format(index))
			SetSkill(x.etur[index], x.skillsetting)
		end
		x.eturtime = GetTime() + 600.0
		x.epattime = GetTime() + 600.0
		x.escvbuildtime = GetTime() + 600.0
		x.ekillarttime = GetTime() + 300.0
		for index = 1, x.ewartotal do --init WARCODE
			x.ewardeclare = true
			x.ewarrior[index] = {} --"rows"
			x.ewartrgt[index] = nil
			for index2 = 1, 10 do --10 per wave max avail
				x.ewarrior[index][index2] = nil --"columns", init (handle in this case)
			end
			x.ewarstate[index] = 1
			x.ewartime[1] = GetTime() + 120.0 --recy
			x.ewartime[2] = GetTime() + 180.0 --fact
			x.ewartime[3] = GetTime() + 240.0 --armo
			x.ewartime[4] = GetTime() + 300.0 --base
			x.ewartimecool[index] = 360.0
			x.ewartimeadd[index] = 0.0
			x.ewarabort[index] = 99999.9
			x.ewarsize[index] = 0
			x.ewarwave[index] = 0
			x.ewarwavemax[index] = 5
			x.ewarwavereset[index] = 2
			x.ewarmeet[index] = 2
		end
		SetScrap(1, 40)
		x.spine = x.spine + 1	
	end

	--Setup camera and start first audio
	if x.spine == 1 then
		x.camtime = GetTime() + 11.0 --NSDF segment
		x.camtoggle1 = true
		x.camplay = 1
    x.userfov = IFace_GetInteger("options.graphics.defaultfov")
    CameraReady()
    IFace_SetInteger("options.graphics.defaultfov", x.camfov)
		AudioMessage("tcss1301.wav") --INTRO - Drop where Lib Free left forces. Marking CCA base.
		x.spine = x.spine + 1
	end

	--DROPSHIP LANDING SEQUENCE - START QUAKE FOR FLYING EFFECT
	if x.spine == 2 then
		for index = 1, 4 do
			for index2 = 1, 10 do
				StopEmitter(x.fdrp[index], index2)
			end
		end
		x.holder[1] = BuildObject("stayput", 0, x.player) --fdrp1 dropship 1
		x.holder[2] = BuildObject("stayput", 0, x.ftnk[1])
		x.holder[3] = BuildObject("stayput", 0, x.ftnk[2])
		x.holder[4] = BuildObject("stayput", 0, x.ftnk[3])
		x.holder[5] = BuildObject("stayput", 0, x.ftnk[4])
		x.holder[6] = BuildObject("stayput", 0, x.frcy) --fdrp2 dropship 2
		x.holder[7] = BuildObject("stayput", 0, x.ffac) --fdrp3 dropship 3
		x.holder[8] = BuildObject("stayput", 0, x.farm) --fdrp4 dropship 4
		x.holder[9] = BuildObject("stayput", 0, x.fscv1)
		x.holder[10] = BuildObject("stayput", 0, x.fscv2)  	
		Stop(x.ffac) --no ordering in dropship
		Stop(x.frcy)
		Stop(x.farm)
		Stop(x.fscv1)
		Stop(x.fscv2)
		for index = 1, 4 do
			Stop(x.ftnk[index])
		end
		x.waittime = GetTime() + 1.0
		x.spine = x.spine + 1
	end

	--OPEN DROPSHIP DOORS, REMOVE HOLDERS
	if x.spine == 3 and x.waittime < GetTime() then
		for index = 1, 4 do
			SetAnimation(x.fdrp[index], "open", 1)
		end
		for index = 1, 10 do
			RemoveObject(x.holder[index])
		end
		x.waittime = GetTime() + 5.0
		x.spine = x.spine + 1
	end
	
	--DOORS FULLY OPEN, GIVE MOVE ORDER
	if x.spine == 4 and x.waittime < GetTime() then
		Goto(x.frcy, "fmeet2", 0)
		Goto(x.ffac, "fmeet3", 0)
		Goto(x.fscv1, "fmeet4", 0)
		Goto(x.fscv2, "fmeet4", 0)
		Goto(x.farm, "fmeet4", 0)
		for index = 1, 4 do
			Goto(x.ftnk[index], "fmeet1", 0)
		end
		x.waittime = GetTime() + 1.0
		x.spine = x.spine + 1
	end

	--GIVE PLAYER CONTROL OF THEIR AVATAR
	if x.spine == 5 and x.waittime < GetTime() then
		x.free_player = true
		x.spine = x.spine + 1
	end
	
	--CHECK IF PLAYER HAS LEFT DROPSHIP
	if x.spine == 6 then
		x.player = GetPlayerHandle()
		
		if IsCraftButNotPerson(x.player) and GetDistance(x.player, x.fdrp[1]) > 60 then
			TCC.SetTeamNum(x.frcy, 1)
			TCC.SetTeamNum(x.ffac, 1)
			TCC.SetTeamNum(x.farm, 1)
			x.spine = x.spine + 1
		end
	end
	
	--DROPSHIPS TAKEOFF
	if x.spine == 7 then
		for index = 1, 4 do
			for index2 = 1, 10 do
				StartEmitter(x.fdrp[index], index2)
			end
			SetAnimation(x.fdrp[index], "takeoff", 1)
			StartSoundEffect("dropleav.wav", x.fdrp[index])
		end
		x.waittime = GetTime() + 15.0
		x.spine = x.spine + 1
	end

	--REMOVE DROPSHIPS
	if x.spine == 8 and x.waittime < GetTime() then
		for index = 1, 4 do
			RemoveObject(x.fdrp[index])
		end
		x.spine = x.spine + 1
	end

	--wait for player to build an APC
	if x.spine == 9 and IsAlive(x.fescort) then
		x.waittime = GetTime() + 20.0
		x.spine = x.spine + 1
	end

	--Ping squad 1
	if x.spine == 10 and x.waittime < GetTime() then
		AudioMessage("tcss1316.wav") --3 beacons picked up. Go pickup survivors
		x.waittime = 99999.9
		x.rescuebuild = 1
		x.spine = x.spine + 1
	end

	--Ping squad 2 and release Furies
	if x.spine == 11 and x.waittime < GetTime() then
		x.waittime = 99999.9
		x.rescuebuild = 2
		x.efuryfrcytime = GetTime()
		x.spine = x.spine + 1
	end

	--Ping squad 3
	if x.spine == 12 and x.waittime < GetTime() then
		x.waittime = 99999.9 --RESET ELSEWHERE
		x.rescuebuild = 3
		x.spine = x.spine + 1
	end

	--CCA MESSAGE 1
	if x.spine == 13 and x.waittime < GetTime() then
		AudioMessage("tcss1304.wav") --7.1 Mayday, base needs help. (soviet then
		x.waittime = GetTime() + 10.0
		x.spine = x.spine + 1
	end

	--CCA MESSAGE 2
	if x.spine == 14 and x.waittime < GetTime() then
		AudioMessage("tcss1312.wav") --aaarrrrggggghhhhhhh
		x.waittime = GetTime() + 10.0
		x.efuryfrcylength = 8
		x.spine = x.spine + 1
	end

	--CCA MESSAGE 3
	if x.spine == 15 and x.waittime < GetTime() then
		AudioMessage("tcss1305.wav") --5.1 Sounds like CCA scheme.
		x.waittime = GetTime() + 30.0
		x.spine = x.spine + 1
	end

	--CCA MESSAGE 4
	if x.spine == 16 and x.waittime < GetTime() then
		AudioMessage("tcss1306.wav") --11.5 GenC. - Those not NSDF attacking CCA. Consolidate forces.
		x.waittime = GetTime() + 30.0
		x.spine = x.spine + 1
	end

	--TURN OFF CCA
	if x.spine == 17 and x.waittime < GetTime() then
		AudioMessage("tcss1307.wav") --15.3 GenC. - CCA has surrende"RED" Esc APC and x.rescue scientists
		Ally(1, 5) --NSDF and CCA are...
		Ally(5, 1) --allied now.
		UnAlly(5, 2) --Make sure CCA ...
		UnAlly(2, 5) --and Furies are enemies
		x.fescortReadyCCA = true
		x.collinsTime1 = GetTime() + 60.0 --90.0
		x.collinsTime2 = GetTime() + 120.0 --180.0
		x.eturtime = 99999.9
		x.ewardeclare = false
		x.ekillarttime = 99999.9
		x.escvbuildtime = 99999.9
		x.epattime = 99999.9
		SetObjectiveName(x.etrn, "RESCUE CCA")
		SetObjectiveOn(x.etrn)
		x.camplay = 3
		x.camtime = GetTime() + 16.0
    x.userfov = IFace_GetInteger("options.graphics.defaultfov")
    CameraReady()
    IFace_SetInteger("options.graphics.defaultfov", x.camfov)
		x.spine = x.spine + 1
	end

	--FESCORT CLOSE TO etrn SETUP CAMERA
	if x.spine == 18 and IsAlive(x.fescort) and IsAlive(x.etrn) and GetDistance(x.fescort, x.etrn) < 100 then
		x.fpilo[1] = BuildObject("sspilo", 5, "ppilo40") --5 since they b ally now
		x.fpilo[2] = BuildObject("sspilo", 5, "ppilo41")
		x.fpilo[3] = BuildObject("sspilo", 5, "ppilo42")
		x.collinsTime1 = 99999.9
		x.collinsTime2 = 99999.9
		TCC.SetTeamNum(x.fescort, 4)
		Goto(x.fescort, x.etrn, 1)
		x.spine = x.spine + 1
	end

	--FESCORT AT etrn BEGIN RESCUE
	if x.spine == 19 and IsAlive(x.fescort) and IsAlive(x.etrn) and GetDistance(x.fescort, x.etrn) < 30 then
		Stop(x.fescort, 1)
		ClearObjectives() 
		AudioMessage("tcss1309X.wav") --We're begin evac. X REMOVED>>Ready to move in 30 seconds.
		for index = 1, 3 do
			Goto(x.fpilo[index], x.fescort, 1)
		end
		x.camtime = GetTime() + 10.0
		x.camplay = 4
    x.userfov = IFace_GetInteger("options.graphics.defaultfov")
    CameraReady()
    IFace_SetInteger("options.graphics.defaultfov", x.camfov)
		x.spine = x.spine + 1
	end

	--SPAWN DROPSHIP
	if x.spine == 20 and IsAlive(x.fescort) and GetDistance(x.fescort, "pdrp") < 500 then
		x.fdrp[1] = BuildObject("avdrop", 1, "pdrp")
		SetAnimation(x.fdrp[1], "land", 1)
		RemoveObject(x.fnav0)
		x.efuryfesctime = 99999.9
		x.spine = x.spine + 1
	end

	--OPEN DROPSHIP
	if x.spine == 21 and IsAlive(x.fescort) and GetDistance(x.fescort, "pdrp") < 180 then
		SetAnimation(x.fdrp[1], "open", 1)
		x.spine = x.spine + 1
	end
	
	--UBA WINER
	if x.spine == 22 and IsAlive(x.fescort) and GetDistance(x.fescort, "pdrp") < 64 then
		SetCurHealth(x.fescort, 5000)
		x.MCAcheck = true
		AudioMessage("tcss1311.wav") --SUCCEED - Good job Cmd. RTB while interrogate CCA.
		ClearObjectives()
		AddObjective("tcss1306.txt", "GREEN")
		AddObjective("	")
		AddObjective("tcss1310.txt", "GREEN")
		TCC.SucceedMission(GetTime() + 10.0, "tcss13w1.des")
		x.spine = x.spine + 1
	end
	---------END MAIN SPINE ----------
	
	--ENSURE PLAYER CAN'T DO ANYTHING WHILE IN DROPSHIP ----------------------------
	if not x.free_player then
		x.controls = {braccel = 0, strafe = 0, jump = 0, deploy = 0, eject = 0, abandon = 0, fire = 0}
		SetControls(x.player, x.controls)
	end

	--Beauty NSDF recycler cam run
	if x.camplay == 1 then
		CameraPath("pcam0", 4000, 300, x.frcy)
		if x.camtime < GetTime() then
			x.camtime = GetTime() + 9.0 --CCA segment
			x.camplay = 2
		end
	end

	--Beauty CCA recyler cam run
	if x.camplay == 2 then
		CameraPath("pcam1", 2000, 1000, x.ercy)
		if x.camtime < GetTime() then
			x.camstop1 = true
			x.camplay = 0
		end
	end

	--STOP CAMERA INTRO
	if x.camtoggle1 then
		if x.camstop1 or CameraCancelled() then
      CameraFinish()
      IFace_SetInteger("options.graphics.defaultfov", x.userfov)
			x.camtime = 99999.9
			x.giveorder = true
			x.camstop1 = false
			x.camtoggle1 = false
		end
	end
	
	--GIVE FIRST OBJECTIVE MESSAGE
	if x.giveorder then
		ClearObjectives()
		AddObjective("tcss1301.txt")
		x.giveorder = false
	end

	--BUILD AND RUN THE RESCUE PHASE ----------------------------------
	if x.rescuebuild == 1 or x.rescuebuild == 2 or x.rescuebuild == 3 then
		AudioMessage("tcss1315.wav") --Bring APC to pickup the survivors
		for index = 1, 3 do
			if x.rescuebuild == 1 then
				x.fpilo[index] = BuildObject("aspilo", 4, ("ppilo1%d"):format(index))
        Stop(x.fpilo[index], 0)
				ClearObjectives()  --runs 3 times, doesn't hurt anything
				AddObjective("tcss1302.txt")  --runs 3 times, doesn't hurt anything
			elseif x.rescuebuild == 2 then
				x.fpilo[index] = BuildObject("aspilo", 4, ("ppilo2%d"):format(index))
        Stop(x.fpilo[index], 0)
				ClearObjectives()  --runs 3 times, doesn't hurt anything
				AddObjective("tcss1303.txt")  --runs 3 times, doesn't hurt anything
			elseif x.rescuebuild == 3 then
				x.fpilo[index] = BuildObject("aspilo", 4, ("ppilo3%d"):format(index))
        Stop(x.fpilo[index], 0)
				ClearObjectives()  --runs 3 times, doesn't hurt anything
				AddObjective("tcss1304.txt")  --runs 3 times, doesn't hurt anything
			end
		end
		x.fpilopresent = true
		x.rescueDistance = true
		vartostring = x.rescuebuild
		x.rescuebuild = 0
	end
	
	--REBUILD RESCUE NAV BEACON
	if x.fpilopresent and not IsAlive(x.fnav0) then --prob not needed, but if orig gets destroyed
		x.fnav0 = BuildObject("apcamra", 1, ("prescue%d"):format(vartostring))
		SetObjectiveName(x.fnav0, ("RESCUE %d"):format(vartostring))
		SetObjectiveOn(x.fnav0)
	end

	--If rescue apc at location, collect pilots
	if x.rescueDistance and IsAlive(x.fescort) and GetDistance(x.fescort, ("prescue%d"):format(vartostring)) < 30 then
		for index = 1, 3 do
			Defend2(x.fpilo[index], x.fescort, 1)
		end
		ClearObjectives()
		AudioMessage("tcss1309X.wav") --We're begin evac. X REMOVED>>Ready to move in 30 seconds.
		x.reminder = true
    x.userfov = IFace_GetInteger("options.graphics.defaultfov")
    CameraReady()
    IFace_SetInteger("options.graphics.defaultfov", x.camfov)
		x.camtime = GetTime() + 10.0
		x.rescuecam = true
		x.rescueDistance = false
	end

	--run the rescue cameras
	if x.rescuecam then
		CameraObject(x.fescort, 30, 30, -30, x.fescort) --in meters
		if x.camtime < GetTime() or CameraCancelled() then
      CameraFinish()
      IFace_SetInteger("options.graphics.defaultfov", x.userfov)
			x.camtime = 99999.9
			x.fpilopresent = false
			RemoveObject(x.fnav0)
			for index = 1, 3 do
				RemoveObject(x.fpilo[index])
			end
			x.rescueasnsqd = x.rescueasnsqd + 1
			x.rescueasn = true
			x.rescuecam = false
		end
	end

	--player near rescue point, remind to bring APC
	if not x.reminder and x.rescueDistance and GetDistance(x.player, ("prescue%d"):format(vartostring)) < 64 and IsAlive(x.fescort) and GetDistance(x.fescort, ("prescue%d"):format(vartostring)) > 200 then
		AudioMessage("tcss1315.wav") --Bring APC to pickup the survivors
		x.reminder = true
	end

	--Send fescort assassin squads
	if x.rescueasn then
		if x.rescueasnsqd == 1 then
			x.rescueasn = BuildObject("svscout", 6, "pasn1a")
			SetSkill(x.rescueasn, x.skillsetting)
			Attack(x.rescueasn, x.fescort)
			x.rescueasn = BuildObject("svmbike", 6, "pasn1b")
			SetSkill(x.rescueasn, x.skillsetting)
			Attack(x.rescueasn, x.fescort)
			x.rescueasn = BuildObject("svmisl", 6, "pasn1c")
			SetSkill(x.rescueasn, x.skillsetting)
			Attack(x.rescueasn, x.fescort)
			x.rescueasn = BuildObject("svtank", 6, "pasn1a")
			SetSkill(x.rescueasn, x.skillsetting)
			Attack(x.rescueasn, x.fescort)
			x.rescueTime = GetTime() + 2.0
		end

		if x.rescueasnsqd == 2 then
			x.rescueasn = BuildObject("svscout", 7, "pasn2a")
			SetSkill(x.rescueasn, x.skillsetting)
			Attack(x.rescueasn, x.fescort)
			x.rescueasn = BuildObject("svmbike", 7, "pasn2b")
			SetSkill(x.rescueasn, x.skillsetting)
			Attack(x.rescueasn, x.fescort)
			x.rescueasn = BuildObject("svmisl", 7, "pasn2c")
			SetSkill(x.rescueasn, x.skillsetting)
			Attack(x.rescueasn, x.fescort)
			x.rescueasn = BuildObject("svtank", 7, "pasn2a")
			SetSkill(x.rescueasn, x.skillsetting)
			Attack(x.rescueasn, x.fescort)
			x.rescueTime = GetTime() + 2.0
		end

		if x.rescueasnsqd == 3 then
			x.rescueasn = BuildObject("yvscoutss13", 2, "pasn3a")
			SetSkill(x.rescueasn, x.skillsetting)
			Attack(x.rescueasn, x.fescort)
			x.rescueasn = BuildObject("yvmbikess13", 2, "pasn3b")
			SetSkill(x.rescueasn, x.skillsetting)
			Attack(x.rescueasn, x.fescort)
			x.rescueasn = BuildObject("yvmislss13", 2, "pasn3c")
			SetSkill(x.rescueasn, x.skillsetting)
			Attack(x.rescueasn, x.fescort)
			x.rescueasn = BuildObject("yvmislss13", 2, "pasn3a")
			SetSkill(x.rescueasn, x.skillsetting)
			Attack(x.rescueasn, x.fescort)
			x.rescueTime = GetTime() + 2.0
		end

		x.reminder = false --reset here
		x.rescueasn = false
	end

	--MESSAGE AFTER EACH RESCUE -------------------------------
	if x.rescueasnsqd == 1 and x.rescueTime < GetTime() then
		AudioMessage("tcss1317.wav") --Nav 3 It was Furies. CCA built and sent out. x.relentless.
	elseif x.rescueasnsqd == 2 and x.rescueTime < GetTime() then
		AudioMessage("tcss1318.wav") --Nav 2 They're out of control. Attack CCA too.
	elseif x.rescueasnsqd == 3 and x.rescueTime < GetTime() then
		AudioMessage("tcss1319.wav") --Nav 1 Get me out of here. I'm not going back in.
	end
	
	--PAUSE BETWEEN RESCUES
	if x.rescueTime < GetTime() then
		x.waittime = GetTime() + 120.0
		x.rescueTime = 99999.9
	end

	--Misc Messages -------------------------------
	if not x.getiton then
		if x.fescortReadyCCA and IsAlive(x.fescort) then
			AudioMessage("tcss1308.wav") --Apc built, escort to base.
			x.fescortReadyCCA = false
		end

		if x.collinsTime1 < GetTime() and GetDistance(x.fescort, x.ercy) >= 150 then
			AudioMessage("tcss1320.wav") --Get those men. We need their info.
			x.collinsTime1 = 99999.9
		end

		if x.collinsTime2 < GetTime() and GetDistance(x.fescort, x.ercy) >= 150 then
			AudioMessage("tcss1327.wav") --GenC - I know you have Sit, but get to survivors
			x.collinsTime2 = 99999.9
		end
	end

	--Beauty etrn cam run ----------------------------------
	if x.camplay == 3 then
		CameraPath("pcam1", 1500, 500, x.etrn)

		if x.camtime < GetTime() or CameraCancelled() then
      CameraFinish()
      IFace_SetInteger("options.graphics.defaultfov", x.userfov)
			x.camtime = 99999.9
			ClearObjectives()
			AddObjective("tcss1305.txt")
			x.camplay = 0
		end
	end

	--FINISH UP THE CAMERA ON CCA LAB ------------------------------
	if x.camplay == 4 then
		CameraObject(x.etrn, -10, 20, -30, x.fescort)
		if x.camtime < GetTime() or CameraCancelled() then
			for index = 1, 3 do
				RemoveObject(x.fpilo[index])
			end
      CameraFinish()
      IFace_SetInteger("options.graphics.defaultfov", x.userfov)
			x.camtime = 99999.9
			Goto(x.fescort, "pescape", 1)
			x.fnav0 = BuildObject("apcamra", 1, "pdrp")
			SetObjectiveName(x.fnav0, "Extraction")
			SetObjectiveOn(x.fnav0)
			SetObjectiveOff(x.etrn)
			AudioMessage("tcss1310.wav") --All scientists aboard. Escort back to base.
			ClearObjectives()
			AddObjective("tcss1305.txt", "GREEN")
			AddObjective("	")
			AddObjective("tcss1306.txt", "YELLOW")
      AudioMessage("alertpulse.wav")
			x.efuryfesctime = GetTime() + 20.0
			x.frcydie = true --It's okay if recycler is killed at this point.
			x.etrndie = true --It's okay if etrn is killed at this point.
			x.camplay = 0
		end
	end

	--FURY GROUP KILL FRIENDLY RECYCLER --SPECIAL THIS MISSION ONLY ----------------
	if x.efuryfrcytime < GetTime() then
		if not x.efuryfrcybuild then
			for index = 1, x.efuryfrcylength do
				if not IsAlive(x.efuryfrcy[index]) then
					x.casualty = x.casualty + 1
				end
			end

			if x.casualty < x.efuryfrcylength * 0.5 then
				x.casualty = 0
			elseif not x.efuryfrcyreset then
				x.casualty = 0
				x.efuryfrcybuild = true
				x.efuryfrcyreset = true
			end
		end

		if x.efuryfrcybuild then
			for index = 1, x.efuryfrcylength do
				while x.randompick == x.randomlast do --random the random
					x.randompick = math.floor(GetRandomFloat(1.0,12.0))
				end
				x.randomlast = x.randompick
				if x.randompick == 1 or x.randompick == 4 or x.randompick == 7 or x.randompick == 10 then
					x.efuryfrcy[index] = BuildObject("yvrcktss13", 2, GetPositionNear("pfryrcy", x.randompick, 16, 32))
				elseif x.randompick == 2 or x.randompick == 5 or x.randompick == 8 or x.randompick == 11 then
					x.efuryfrcy[index] = BuildObject("yvscoutss13", 2, GetPositionNear("pfryrcy", x.randompick, 16, 32))
				else  --3 6 9 12
					x.efuryfrcy[index] = BuildObject("yvmbikess13", 2, GetPositionNear("pfryrcy", x.randompick, 16, 32))
				end
				SetSkill(x.efuryfrcy[index], x.skillsetting)
        Attack(x.efuryfrcy[index], x.frcy)
			end
			if not x.furymsg then
				AudioMessage("tcss1303.wav") --Picking up unID obj. Could be Commie version of saucers
				x.furymsg = true
			end
			x.efuryfrcyreset = false
			x.efuryfrcybuild = false
		end
		x.efuryfrcytime = GetTime() + 60.0
	end

	--FURY FINAL ATTACK ON "PROTECT APC" --SPECIAL THIS MISSION ONLY --------------------
	if x.efuryfesctime < GetTime() then
		if x.efuryfescwave == 0 or x.efuryfescwave == 1 then
			x.efuryfesc[1] = BuildObject("yvrcktss13", 2, "pfryapc", 1)
			--not needed w/ new non-sav sav x.efuryfesc[2] = BuildObject("yvscoutss13", 2, "pfryapc", 4)
		elseif x.efuryfescwave == 2 then
			x.efuryfesc[1] = BuildObject("yvrcktss13", 2, "pfryapc", 2)
			--x.efuryfesc[2] = BuildObject("yvscoutss13", 2, "pfryapc", 4)
		elseif x.efuryfescwave == 3 then
			x.efuryfesc[1] = BuildObject("yvrcktss13", 2, "pfryapc", 3)
			--x.efuryfesc[2] = BuildObject("yvscoutss13", 2, "pfryapc", 4)
		elseif x.efuryfescwave == 4 then
			x.efuryfesc[1] = BuildObject("yvrcktss13", 2, "pfryapc", 4)
			--x.efuryfesc[2] = BuildObject("yvscoutss13", 2, "pfryapc", 4)
		end
		SetSkill(x.efuryfesc[1], x.skillsetting)
		Attack(x.efuryfesc[1], x.fescort)
		--SetSkill(x.efuryfesc[2], x.skillsetting)
		--Attack(x.efuryfesc[2], x.fescort)
		x.efuryfescwave = x.efuryfescwave + 1
		x.efuryfesctime = GetTime() + 30.0
	end

	--CCA GROUP TURRET GENERIC ----------------------------------
	if x.eturtime < GetTime() then
		for index = 1, x.eturlength do
			if not IsAlive(x.etur[index]) and not x.eturallow[index] then
				x.eturcool[index] = GetTime() + 360.0
				x.eturallow[index] = true
			end
			if x.eturallow[index] and x.eturcool[index] < GetTime() then
				x.etur[index] = BuildObject("svturr", 5, "epalt")
				SetSkill(x.etur[index], x.skillsetting)
				SetObjectiveName(x.etur[index], ("Pak %d"):format(index))
				Goto(x.etur[index], ("eptur%d"):format(index))
				x.eturallow[index] = false
			end
		end
		x.eturtime = GetTime() + 60.0
	end
	
	--CCA GROUP SCOUT PATROLS ----------------------------------
	if x.epattime < GetTime() then
		for index = 1, x.epatlength do
			if not IsAlive(x.epat[index]) and not x.epatallow[index] then
				x.epatcool[index] = GetTime() + 360.0
				x.epatallow[index] = true
			end
			if x.epatallow[index] and x.epatcool[index] < GetTime() then
				while x.randompick == x.randomlast do --random the random
					x.randompick = math.floor(GetRandomFloat(1.0, 15.0))
				end
				x.randomlast = x.randompick
				if x.randompick == 1 or x.randompick == 6 or x.randompick == 11 then
					x.epat[index] = BuildObject("svscout", 5, ("ppatrol%d"):format(index))
				elseif x.randompick == 2 or x.randompick == 7 or x.randompick == 12 then
					x.epat[index] = BuildObject("svmbike", 5, ("ppatrol%d"):format(index))
				elseif x.randompick == 3 or x.randompick == 8 or x.randompick == 13 then
					x.epat[index] = BuildObject("svmisl", 5, ("ppatrol%d"):format(index))
				elseif x.randompick == 4 or x.randompick == 9 or x.randompick == 14 then
					x.epat[index] = BuildObject("svtank", 5, ("ppatrol%d"):format(index))
				else
					x.epat[index] = BuildObject("svrckt", 5, ("ppatrol%d"):format(index))
				end
				SetSkill(x.epat[index], x.skillsetting)
				Patrol(x.epat[index], ("ppatrol%d"):format(index))
				--SetObjectiveName(x.epat[index], ("Patrol %d"):format(index))
				x.epatallow[index] = false
			end
		end
		x.epattime = GetTime() + 30.0
	end
	
	--WARCODE (non-AIP or temp AIP replacement)
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
						x.ewarsize[index] = 2
					elseif x.ewarwave[index] == 2 then
						x.ewarsize[index] = 3
					elseif x.ewarwave[index] == 3 then
						x.ewarsize[index] = 4
					elseif x.ewarwave[index] == 4 then
						x.ewarsize[index] = 5
					else --x.ewarwave[index] == 5 then
						x.ewarsize[index] = 6
					end
					x.ewarstate[index] = x.ewarstate[index] + 1
				end
				
				--BUILD FORCE --SPECIAL SS13
				if x.ewarstate[index] == 2 then
					for index2 = 1, x.ewarsize[index] do
						while x.randompick == x.randomlast do --random the random
							x.randompick = math.floor(GetRandomFloat(1.0, 15.0))
						end
						x.randomlast = x.randompick
						if not IsAlive(x.efac) then
							x.randompick = 1
						end
						if x.randompick == 1 or x.randompick == 6 or x.randompick == 11 then
							x.ewarrior[index][index2] = BuildObject("svscout", 5, GetPositionNear("epgrcy", 0, 16, 32)) --grpspwn
							if x.ewarwave[index] == 3 or x.ewarwave[index] == 4 then
								GiveWeapon(x.ewarrior[index][index2], "glasea_c")
							end
						elseif x.randompick == 2 or x.randompick == 7 or x.randompick == 12 then
							x.ewarrior[index][index2] = BuildObject("svmbike", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
							if x.ewarwave[index] == 2 or x.ewarwave[index] == 4 then
								GiveWeapon(x.ewarrior[index][index2], "gstbva_c")
							end
						elseif x.randompick == 3 or x.randompick == 8 or x.randompick == 13 then
							x.ewarrior[index][index2] = BuildObject("svmisl", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
							if x.ewarwave[index] == 3 or x.ewarwave[index] == 5 then
								GiveWeapon(x.ewarrior[index][index2], "gfafma_c")
							end
						elseif x.randompick == 4 or x.randompick == 9 or x.randompick == 14 then
							x.ewarrior[index][index2] = BuildObject("svtank", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
							if x.ewarwave[index] == 4 or x.ewarwave[index] == 5 then
								GiveWeapon(x.ewarrior[index][index2], "gstbsa_c")
							end
						else
							x.ewarrior[index][index2] = BuildObject("svrckt", 5, GetPositionNear("epgfac", 0, 16, 32)) --grpspwn
							if x.ewarwave[index] == 3 or x.ewarwave[index] == 5 then
								GiveWeapon(x.ewarrior[index][index2], "gshdwa_a") --salvo rckt
							end
						end
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
						x.ewarmeet[index] = 1
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
						if IsAlive(x.ewarrior[index][index2]) and GetTeamNum(x.ewarrior[index][index2]) ~= 1 then
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
							elseif index == 4 then
								if IsAlive(x.fsld) then
									x.ewartrgt[index] = x.fsld
								elseif IsAlive(x.fhqr) then
									x.ewartrgt[index] = x.fhqr
								elseif IsAlive(x.ftec) then
									x.ewartrgt[index] = x.ftec
								elseif IsAlive(x.ftrn) then
									x.ewartrgt[index] = x.ftrn
								elseif IsAlive(x.fbay) then
									x.ewartrgt[index] = x.fbay
								elseif IsAlive(x.fcom) then
									x.ewartrgt[index] = x.fcom
								elseif IsAlive(x.fpwr[4]) then
									x.ewartrgt[index] = x.fpwr[4]
								elseif IsAlive(x.fpwr[3]) then
									x.ewartrgt[index] = x.fpwr[3]
								elseif IsAlive(x.fpwr[2]) then
									x.ewartrgt[index] = x.fpwr[2]
								elseif IsAlive(x.fpwr[1]) then
									x.ewartrgt[index] = x.fpwr[1]
								elseif IsAlive(x.farm) then
									x.ewartrgt[index] = x.farm
								elseif IsAlive(x.ffac) then
									x.ewartrgt[index] = x.ffac
								elseif IsAlive(x.frcy) then
									x.ewartrgt[index] = x.frcy
								else
									x.ewartrgt[index] = x.player
								end
								--SetObjectiveName(x.ewarrior[index][index2], ("Kill Base %d"):format(index2))
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

	--BUILD CCA SCAVS FOR LOOKS ----------------------------------
	if IsAlive(x.ercy) then
		if GetScrap(5) > 39 then
			SetScrap(5, 0)
		end
		for index = 1, 2 do
			if not IsAlive(x.escv[index]) and x.escvbuildtime < GetTime() then
				x.escv[index] = BuildObject("svscav", 5, GetPositionNear("epgrcy", 0, 16, 32)) --grpspwn
				x.escvbuildtime = GetTime() + 360.0
			end
		end
	end

	--CHECK STATUS OF MCA ----------------------------------
	if not x.MCAcheck then
		if not x.frcydie and not IsAlive(x.frcy) then --frecy killed
			AudioMessage("tcss1314.wav") --FAIL - Recy Texas lost 
			ClearObjectives()
			AddObjective("tcss1309.txt", "RED") --Texas lost mission failed
			TCC.FailMission(GetTime() + 6.0, "tcss13f1.des") --LOSER LOSER LOSER
			x.spine = 666
			x.MCAcheck = true
		end
		
		if x.fescortalive and not IsAlive(x.fescort) then --apc with soldier killed
			AudioMessage("tcss1313.wav") --FAIL - APC IS LOST WITH MEN ON BOARD
			ClearObjectives()
			AddObjective("tcss1308.txt", "RED")
			TCC.FailMission(GetTime() + 10.0, "tcss13f4.des") --LOSER LOSER LOSER
			x.spine = 666
			x.MCAcheck = true
		end
		
		if x.fpilopresent then
			for index = 1, 3 do
				if not IsAlive(x.fpilo[index]) then
					x.casualty = x.casualty + 1
				end
			end
			
			if x.casualty > 0 then
				AudioMessage("tcss1321.wav") --FAIL - lost the men at beacon
				ClearObjectives()
				AddObjective("tcss1307.txt", "RED")
				TCC.FailMission(GetTime() + 13.0, "tcss13f2.des") --LOSER LOSER LOSER
				x.spine = 666
				x.MCAcheck = true
			end
		end
		
		if not x.etrndie and not IsAlive(x.etrn) then --x.etrn killed
			AudioMessage("tcss1321.wav") --FAIL - lost the men at beacon
			ClearObjectives()
			AddObjective("tcss1307.txt", "RED")
			TCC.FailMission(GetTime() + 13.0, "tcss13f3.des") --LOSER LOSER LOSER
			x.spine = 666
			x.MCAcheck = true
		end
	end
end
--[[END OF SCRIPT]]