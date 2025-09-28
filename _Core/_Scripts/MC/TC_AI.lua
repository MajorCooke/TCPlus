--[[
Major Cooke's Modules

Used primarily for storing and performing maintenance on certain units.

If you borrow this code, please keep this comment intact. Thank you!
]]--

-- Primary storage
local MaxTeams = 16;
local M = {};	-- FUNCTION table (dont save)
local Bombs =	
{
}

local Teams =
{

};

function M.InitialSetup()
	for i = 0, MaxTeams do --yes, including team 0.
		Teams[i] = 
		{
			units = {},			-- misc
			offensive = {},		-- offensive
			defensive =  {},	-- defensive
			utility = {},		-- tugs & scavs
			buildings = {},
			production = {},	-- production units (recy, fact, armory, NOT constructors!)
			pilots = {},
			player = nil,
		}
	end
end

function M.Start()
	
end

local LoadGame = false;
--function M.Load(_N)
function M.Load()
	M.InitialSetup();
	LoadGame = true;
--	N = _N;
end
--[[
function M.Save()
	return N;
end
]]

function M.Update()
	if (LoadGame) then
		LoadGame = false;
		local objs = GetAllGameObjectHandles();

		for i = 1, #objs do
			M.AddObject(objs[i]);
		end
	end

	-- Always keep this up to date.
	for i = 1, MaxTeams do 
		Teams.player = GetPlayerHandle(i);
	end
	
	if (not IsEmpty(Bombs)) then
		M.HandleBombTargets();
	end


end

function M.AddObject(h)
	if (IsAround(h)) then
		if (GetClassLabel(h) == "CLASS_DAYWRECKER") then
			print("Day wrecker registered.");
		--	table.insert(Bombs,h);
			Bombs[h] = h;
		else
			M.AddEnt(h);
		end
	end
end

function M.DeleteObject(h)
	M.RemoveEnt(h);
end

function M.ReplaceObject(h, className)
	return M.ReplaceEnt(h, className);
end

function M.ObjectKilled(DeadObject, Killer)
	--0: EJECTKILLRETCODES_DOEJECTPILOT
	--1: EJECTKILLRETCODES_DORESPAWNSAFEST
	--2: EJECTKILLRETCODES_DLLHANDLED
	--3: EJECTKILLRETCODES_DOGAMEOVER
	-- Currently string variants don't work.
	return 0;
end

function M.PreSnipe(world, shooter, victim, OrdTeam, OrdODF)
	return -1;
end



--[[-------------------------------------------------------------------------

Custom Functions

---------------------------------------------------------------------------]]

function M.HandleBombTargets()
	local count = 0;
	for i, team in ipairs(Teams) do
		if (team) then
			for j, h in ipairs(team.offensive) do
				
				if (h and IsAround(h) and IsAlive(h)) then
					local who = GetCurrentWho(h);
					if (who and GetCurrentCommand(h) == 5 and --CMD_FOLLOW
						IsOdf(who, "apdwrka")) then
							count = count + 1;
							Attack(h, who, 0);
					end
				end
			end
		end
	end
	if (count > 0) then
		print("Reordering %d units to attack daywrecker.", count);
	end
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

	local team = Teams[GetTeamNum(h)];
		if (type == TCC_OFFENSIVE) then 	return team.offensive;
	elseif (type == TCC_DEFENSIVE) then		return team.defensive;
	elseif (type == TCC_UTILITY) then 		return team.utility;
	elseif (type == TCC_PRODUCTION) then	return team.production;
	elseif (type == TCC_OTHER) then			return team.units; -- gun towers, other things
	elseif (type == TCC_PILOT) then			return team.pilots;
	elseif (type == TCC_BUILDING) then		return team.buildings;
	end
	return nil;
end

local function InsertHandle(h, arr)
	if (arr == nil) then return; end;
	if (h and arr) then
		arr[h] = h; -- LUA seriously defies logic...
	end
end

local function RemoveHandle(h, arr)
	--[[
	if (arr == nil) then return; end;
	if (h and arr) then
		arr[h] = nil;
	end
	]]
end

function M.AddEnt(h)
	if (IsPlayer(h)) then
		local team = Teams[GetTeamNum(h)];
		team.player = h;
	else
		local arr = GetCategory(h);
		if (arr ~= nil) then 
		--	arr[h] = h; 
			InsertHandle(h, arr);
		end
	end
end

function M.RemoveEnt(h)
	if (IsPlayer(h)) then
		local team = Teams[GetTeamNum(h)];
		team.player = nil;
	else
		local arr = GetCategory(h);
		if (arr ~= nil) then 
			RemoveHandle(h, arr);
		end
	end
end

function M.ReplaceEnt(h, className)
	if (h) then 
		M.RemoveEnt(h);
		h = ReplaceObject(h, className);
		M.AddEnt(h);
	end
	return h;
end

-- Changes the team number of the ent.
function M.SetTeamNum(h, num)
	if (h == nil) then return; end;
	M.RemoveEnt(h);
	SetTeamNum(h, num);
	M.AddEnt(h);
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
	PrintConsoleMessage("Boom Called");
	for _, i in pairs(Teams) do
		local skip = false;
		-- Found a team to exclude so don't touch them.
		for j, _ in ipairs(teams) do
			if (teams[j] == i) then skip = true; break; end;
		end

		-- Team not excluded, start iterating through all arrays.
		if (not skip) then
			local team = Teams[i];

			-- Teams[i] --> Grab each table...
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