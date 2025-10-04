--[[
Major Cooke's Functions

This is designed to provide a bunch of helper functions to shorten the amount of code repetition.
For storage and AI enhancements, see _MCModules.lua.

If you borrow this code, please keep this comment intact. Thank you!
]]--

-- THIS IS INTENTIONALLY NOT SAVED BECAUSE EDITING ODF FILES CAN CHANGE EVERYTHING.
-- Every time a game is loaded, this should absolutely be empty.
local CLStore = {};

-- Code by Nielk1, modified by me.
--- Is the object a the given classname or odf
--- @param h Handle|string Object or odf (no .odf extension)
--- @param className string  name or odf (no .odf extension)
function IsType(h, className)
    if (h == nil or className == nil) then return false; end;
    className = className:lower();
	local name = GetOdf(h):lower():gsub("%.odf$", "");

	if name == className then
		return true;
	end
    
    -- by this point h contains the ODF in lowercase with no .odf
	local check = name..":"..className;
    local r = CLStore[check];
    if r then return r end;

    local candidate = name;
    local found = true;
    while (found) do
        candidate, found = GetODFString(candidate..'.odf', "GameObjectClass", "classlabel");
        if (not found or not candidate) then 
			CLStore[check] = false;
			return false;
		end -- failed to read ODF value or read as nil
        candidate = candidate:lower();
        if (candidate == className) then
            CLStore[check] = true;
            return true;
        end
    end
	CLStore[check] = false;
    return false;
end

local SkipReplace = false;
-- Performs map-specific replacements for certain things.
---@param h Handle Object to attempt replacing with
---@return Handle, boolean
function RepObject(h)
	if (SkipReplace) then
		SkipReplace = false;
		return h, false;
	end
	local rep = h;
	-- [MC] Global replacements are here
	-- [MC] Mission specific replacements begin here
	if (h and (IsAlive(h) or IsBuilding(h)) and MisnNum > 42) then
		if (IsType(h, "abarmo")) then		SkipReplace = true;
			rep = TCC.ReplaceObject(h, "abarmopl");
		elseif (IsType(h, "bbarmo")) then 	SkipReplace = true;
			rep = TCC.ReplaceObject(h, "bbarmopl");
		elseif (MisnNum >= 58) then
			if (IsType(h, "abfact")) then 	SkipReplace = true;
				rep = TCC.ReplaceObject(h, "abfactss17");
			end
		end
	end
	return rep, (rep ~= h);
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
	if (IsCraftButNotPerson(h) or IsPlayer(h)) then
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

-- [MC] Wrapper function because I keep forgetting the capitalization and it's annoying.
function IsODF(h, ODF)	return IsOdf(h, ODF);	end
function GetODF(h)		return GetOdf(h);		end

function AudioMessageVol(FileName, vol)
	local id = AudioMessage(FileName);
	if (id) then SetVolume(id, vol, true); end;
	return id;
end