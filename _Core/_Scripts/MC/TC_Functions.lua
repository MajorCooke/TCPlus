--[[
Major Cooke's Functions

This is designed to provide a bunch of helper functions to shorten the amount of code repetition.
For storage and AI enhancements, see _MCModules.lua.

If you borrow this code, please keep this comment intact. Thank you!
]]--

-- THIS IS INTENTIONALLY NOT SAVED BECAUSE EDITING ODF FILES CAN CHANGE EVERYTHING.
-- Every time a game is loaded, this should absolutely be empty.
local CLStore = {};

function IsType(h, className)
	return IsOdf(h, className);
	--[[
	local s = ""..GetODF(h);
	local c = className..".odf";
	if (s == c) then 
		return true;
	else return IsChildOf(h, className); end;
	]]
end

-- Iterates through an ODF series in order to find if it inherits from a certain ODF.
--[[
function IsChildOf(h, className)
	if (h == nil) then return false; end
	
	local block = "GameObjectClass";
	local key  = "classlabel";
	PrintConsoleMessage(GetCfg(h).."-->");
	local cur, found = GetODFString(h, block, key);
	local limit = 40;
	local res = false;
	
	while (limit > 0 and found and cur) do
		PrintConsoleMessage(cur.."-->");
		if (cur == className) then 
			res = true; break;	
		end
		cur, found = GetODFString(cur..".odf", block, key);
		limit = limit - 1;
		
	end
	if (cur) then PrintConsoleMessage("--> "..cur);
	else PrintConsoleMessage("--> nothing."); end;
	
	if (limit < 1) then PrintConsoleMessage("WARNING! Limit reached!"); end;

	return res;
end
]]
-- Performs map-specific replacements for certain things.
---@param h Handle Object to attempt replacing with
function RepObject(h)
	local rep = h;
	-- [MC] Global replacements are here
	-- [MC] Mission specific replacements begin here
--	PrintConsoleMessage("RepObject called.");
	if ((IsAlive(h) or IsBuilding(h)) and MisnNum > 42) then
--		PrintConsoleMessage("Attempting to replace "..GetODF(h).."...");
		if (IsType(h, "abarmo")) then
	--	if (IsODF(h, "abarmo")) then
			rep = TCC.ReplaceObject(h, "abarmopl");
		elseif (IsType(h, "bbarmo")) then 
			rep = TCC.ReplaceObject(h, "bbarmopl");
	--	elseif (IsType(h, "avarmo")) then
	--		rep = TCC.ReplaceObject(h, "avarmopl");
	--	elseif (IsType(h, "bvarmo")) then
	--		rep = TCC.ReplaceObject(h, "bvarmopl");
		elseif (MisnNum == 58) then
			if (IsType(h, "abfact")) then
				rep = TCC.ReplaceObject(h, "abfactss17");
			end
		end
	end
	return rep or h;
end

-- Replaces a handle's weapon 'wepName' with 'wepRep' if possible.
-- handle, string, string
---@param h Handle Handle of the object to affect.
---@param wepName string The weapon to be replaced.
---@param wepRep string Replaces wepName with this if valid.
function ReplaceWeapon(h, wepName, wepRep)
	if IsAlive(h) or IsPlayer(h) then
		for ind = 0, 4 do
			if GetWeaponConfig(h, ind) == wepName then
				GiveWeapon(h, wepRep, ind);
			end
		end
	end
end

-- Convenient function for replacing all AT Stabbers with Plasma Stabbers
-- in later levels.
---@param h Handle Vehicle to replace weapons.

function ReplaceStabber(h)
	if IsAlive(h) or IsPlayer(h) then
		local race = GetRace(h)
		if ((race == "a" or race == "b") or (MisnNum >= 50 and (race == "s" or race == "k"))) then 
			ReplaceWeapon(h, "gstbaa_c", "gstbla_c");
			ReplaceWeapon(h, "gstbaa_a", "gstbla_a");
			ReplaceWeapon(h, "gstbas_c", "gstbla_c");
			ReplaceWeapon(h, "gstbas_a", "gstbla_a");
			ReplaceWeapon(h, "gstbaa_c_gun", "gstbla_c_gun");
			ReplaceWeapon(h, "gstbaa_a_gun", "gstbla_a_gun");
			ReplaceWeapon(h, "gstbas_c_gun", "gstbla_c_gun");
			ReplaceWeapon(h, "gstbas_a_gun", "gstbla_a_gun");
		end
	end
end

-- [MC] Wrapper function because I keep forgetting the capitalization and it's annoying.
function IsODF(h, ODF)	return IsOdf(h, ODF);	end
function GetODF(h)		return GetOdf(h);		end

function AudioMessageVol(FileName, vol)
	local id = AudioMessage(FileName);
	if (id) then SetVolume(id, vol, true); end;
	return id;
end