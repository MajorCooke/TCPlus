--[[
Upgrades

Handles gathering and setting up of upgrades and objectives.

]]--

local M = {};	-- FUNCTION table (don't save)
local N = 		-- VARIABLE table (save)
{
	InfoStart = "", -- On reading it in for the first time, 
	Info = "",
	Path = "",
	
	ScrapEarned = -1,
    ScrapUsed = -1,
};

function M.InitialSetup()
    
end

function M.Start()
	local plr = GetPlayerHandle();
	local pname = GetPlayerName(plr);
	N.Path = pname.."_upgrades.txt";
	local file = LoadFile(N.Path);
	if (file == nil) then
		WriteToFile(N.Path, "", false);
		FailMission(0, "reboot.txt");
	else
		PrintConsoleMessage(N.Path.." loaded.");
		N.InfoStart = file;
		N.Info = N.InfoStart;
	end	

end

function M.WriteInfo()
	WriteToFile(N.Path, N.Info, false);
end

function M.Save()
	return N;
end

function M.Load(_N)
	N = _N
end



-- Returns how much of the upgrade was purchased.
function M.Get(name)
	return 0;
end;

return M;