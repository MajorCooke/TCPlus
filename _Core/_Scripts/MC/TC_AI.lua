--[[
Major Cooke's Modules

Used primarily for storing and performing maintenance on certain units.

If you borrow this code, please keep this comment intact. Thank you!
]]--

-- Primary storage
local MaxTeams = 16;
local M = {};	-- FUNCTION table (dont save)
local N =		-- VARIABLE table (save)
{
	CleanTimer = 0.0,
	CleanIntervals = 10.0, --every ten seconds
	Team = {},
	Bombs = {}, -- Daywreckers
}

function M.InitialSetup()
	for i = 0, MaxTeams do --yes, including team 0.
		N.Team[i] = 
		{
			units = {},			-- misc
			offensive = {},		-- offensive
			defensive =  {},	-- defensive
			utility = {},		-- tugs & scavs
			buildings = {},
			production = {},	-- production units (recy, fact, armory, NOT constructors!)
			pilots = {}, -- 
			player = nil,
		}
	end
	N.CleanTimer = 10.0;
end

function M.Start()

end

function M.Load(_N)
	N = _N;
end

function M.Save()
	return N;
end



function M.Update()
	-- Always keep this up to date.
	for i = 1, MaxTeams do 
		N.Team.player = GetPlayerHandle(i);
	end

	if (GetTime() > N.CleanTimer) then
		CleanTeams();
	end

	if (not IsEmpty(N.Bombs)) then
		M.HandleBombTargets();
	else
		N.Bombs = {};
	end

end



function M.AddObject(h)
	if (IsAround(h)) then
		if (GetClassLabel(h) == "CLASS_DAYWRECKER") then
			PrintConsoleMessage("Day wrecker registered.");
			table.insert(N.Bombs,h);
		else
			M.AddEnt(h);
		end
	end
end

function M.DeleteObject(h)
	
end

function M.ReplaceObject(h, className)
	return M.ReplaceEnt(h, className);
end

function M.ObjectKilled(Dead, Killer)

end

function M.PreSnipe(world, shooter, victim, OrdTeam, OrdODF)
	return -1;
end



--[[-------------------------------------------------------------------------

Custom Functions

---------------------------------------------------------------------------]]

function M.HandleBombTargets()
	for _, i in pairs(N.Teams) do
		local units = N.Teams[i].offensive;

		for _, j in pairs(units) do
			local h = units[j];

			if (IsAlive(h)) then
				local who = GetCurrentWho(h);
				if (who and GetCurrentCommand(h) == 5 and --CMD_FOLLOW
					IsOdf(who, "apdwrka")) then
					Attack(h, who, 0);
				end
			end
		end
	end
end


local function IsEntValid(h)
	return (IsAround(h) and (IsPlayer(h) or IsCraftOrPerson(h) or IsBuilding(h)));
end

local function FindEnt(h, arr)
	if (h and arr) then
		for _, i in pairs(arr) do
			if (h == arr[i]) then return i; end;
		end
	end
	return -1;
end

function IsEmpty(arr)
	local count = 0;
	for _, v in pairs(arr) do
		if (arr[v]) then return false; end;
	end
	return true;
end


local TCC_PLAYER = 1;
local TCC_OFFENSIVE = 2;
local TCC_DEFENSIVE = 3;
local TCC_UTILITY = 4;
local TCC_PRODUCTION = 5;
local TCC_OTHER = 6;
local TCC_PILOT = 7;
local TCC_BUILDING = 8;

local function CheckEntType(h)
	if (IsAround(h)) then
		local cls = GetClassSig(h);
		if (not (
			cls == "CLASS_ID_CRAFT" or
			cls == "CLASS_ID_BUILDING" or
			cls == "CLASS_ID_PERSON"
			)) then
			return 0;
		end
		cls = GetClassLabel(h);
		if (IsPlayer(h)) then
			return TCC_PLAYER;
		elseif (IsCraftButNotPerson(h)) then 
			if (cls == "CLASS_WINGMAN" or 
				cls == "CLASS_WALKER" or
				cls == "CLASS_ASSAULTTANK" or 
				cls == "CLASS_ASSAULTHOVER" or 
				cls == "CLASS_MORPHTANK" or
				cls == "CLASS_SAV") then
				return TCC_OFFENSIVE;
			elseif (
				cls == "CLASS_TURRETTANK" or
				cls == "CLASS_ARTILLERY" or
				cls == "CLASS_MINELAYER") then
				return TCC_DEFENSIVE;
			elseif (
				cls == "CLASS_SCAVENGER" or
				cls == "CLASS_SCAVENGERH" or
				cls == "CLASS_TUG") then 
				return TCC_UTILITY;
			elseif(
				cls == "CLASS_RECYCLERVEHICLEH" or
				cls == "CLASS_RECYCLERVEHICLE" or
				cls == "CLASS_RECYCLER" or 
				cls == "CLASS_CONSTRUCTIONRIG" or
				cls == "CLASS_CONSTRUCTIONRIGT") then
				return TCC_PRODUCTION;
			else
				return TCC_OTHER;
			end
		elseif (IsPerson(h)) then
			return TCC_PILOT;
		elseif (IsBuilding(h)) then
			return TCC_BUILDING;
		end
	end
	return 0;
end

local function GetCategory(h)

	local type = CheckEntType(h);
	if (type <= 0) then return nil; end;

	local team = N.Team[GetTeamNum(h)];
		if (type == TCC_OFFENSIVE) then 	return team.offensive;
	elseif (type == TCC_DEFENSIVE) then		return team.defensive;
	elseif (type == TCC_UTILITY) then 		return team.utility;
	elseif (type == TCC_PRODUCTION) then	return team.production;
	elseif (type == TCC_OTHER) then			return team.units; -- gun towers, other things
	elseif (type == TCC_PILOT) then			return team.pilots;
	elseif (type == TCC_BUILDING) then		return team.buildings;
	else return nil;
	end
	
end

local function InsertHandle(h, arr)
	table.insert(arr, h);
	--[[
	if (FindEnt(h, arr) < 0) then
		table.insert(arr, h);
		return true;
	end
	return false;
	]]
end

local function RemoveHandle(h, arr)
	if (h == nil) then return; end;

	for _, i in pairs(arr) do
		if arr[i] == h then
			table.remove(arr, i);
			return;
		end
	end
end

function M.AddEnt(h)
	if (IsPlayer(h)) then
		local team = N.Team[GetTeamNum(h)];
		team.player = h;
	else
		local arr = GetCategory(h);
		if (arr) then InsertHandle(h, arr);	end
	end
end

function M.ReplaceEnt(h, className)
	if (h) then 
		local num = GetTeamNum(h);
		M.RemoveEnt(h);
		h = ReplaceObject(h, className);
		M.AddEnt(h);
	end
	return h;
end

function M.RemoveEnt(h)
	if (IsPlayer(h)) then
		local team = N.Team[GetTeamNum(h)];
		team.player = nil;
	else
		local arr = GetCategory(h);
		if (arr) then RemoveHandle(h, arr);	end
	end
end

-- Changes the team number of the ent.
function M.SetTeamNum(h, num)
	if (h == nil) then return; end;
	M.RemoveEnt(h);
	SetTeamNum(h, num);
	M.AddEnt(h);
end


local function CleanObjects(array)
	local com = {};
	for _, i in pairs(array) do
		if (array[i]) then
			table.insert(com, array[i]);
		end
	end
	return com;
end

local function CleanTeamArrays(team)
	for k,v in pairs(team) do
		if (type(v) == "table" and #v > 0) then
			team[k] = CleanObjects(v);
		end
	end
end

-- Helper functions.
function CleanTeams()
	N.CleanTimer = GetTime() + N.CleanIntervals;
	for i = 0, MaxTeams do
		CleanTeamArrays(N.Team[i]);
	end
end

-------------------------------------------------------------------
-- Custom Explosions
-- Calculates the damage falloff.
local function GetFalloff(dist, radius, full)
	-- Object inside full damage radius
	if (dist < full or full >= radius or full <= 0.0 or radius - full <= 0.0) then
		return 1.0;
	elseif (dist > full and dist < radius) then
		local size = radius - full;
		if (size < 1.0) then return 1.0;
		else return (1.0 - ((dist - full) / size));	end
	end
	-- shouldn't happen but just in case...
	return 1.0;
end

local function RadialDamage(dmger, victim, damage, radius, fullrad, type)
	local radsq = radius * radius;
	local fullsq = fullrad * fullrad;
	local dist = Distance3DSquared(dmger, victim);
	local mul = GetFalloff(dist, radsq, fullsq);
	local dmg = math.floor(damage * mul);
	
	if (dist < radius and dmg ~= 0) then
		if (dmg < 0) then
			AddHealth(victim, dmg);
		elseif (dmg > 0) then
			Damage(victim, dmger, dmg);
		end
	end
end

-- Performs custom explosion code with some extra goodies mixed in, including healing.
--- @param owner Handle Who did the damage
--- @param proj Handle The projectile dealing the damage
--- @param damage number Amount to deal to surrounding
--- @param radius number How far away this explosion reaches
--- @param fullrad number If units are closer than this, guaranteed to receive full damage
--- @param dmgself boolean If false, don't damage owner
--- @param teams table integer table of teams to NOT affect
--- @param type string Damage type (similar to GZDoom's DamageType property)
function M.Explode(owner, proj, damage, radius, fullrad, dmgself, teams, type)
	dmgself = dmgself or true;
	teams = teams or {};
	type = type or "none";

	local radsq = radius * radius;
	local fullsq = fullrad * fullrad;
	local dmger = proj or owner;

	for _, i in pairs(N.Team) do
		local skip = false;
		-- Found a team to exclude so don't touch them.
		for _, j in ipairs(teams) do
			if (teams[j] == i) then skip = true; break; end;
		end

		-- Team not excluded, start iterating through all arrays.
		if (not skip) then
			local team = N.Team[i];

			-- N.Teams[i] --> Grab each table...
			for k,v in pairs(team) do
				if (type(v) == "table" and #v > 0) then
					local tab = team[k];

					-- ...and iterate through the objects in each table. Holy fuck...
					for _,l in pairs(tab) do
						local unit = tab[l];
						if (IsAround(unit) and (owner ~= unit)) then
							RadialDamage(dmger, unit, damage, radius, fullrad, type);
						end
					end
				end
			end
			if (dmgself) then
				RadialDamage(dmger, owner, damage, radius, fullrad, type);
			end
		end
	end
	

	return damage;
end




return M;