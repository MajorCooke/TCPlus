local M = {};
local N = 
{
	InfoStart = "", -- On reading it in for the first time, 
	Info = "",
	Path = "",
	Lines = {}
};

function M.InitialSetup()
    
end

function M.Start()
	local plr = GetPlayerHandle();
	local pname = GetPlayerName(plr);
	N.Path = pname.."_challenges.txt";
	local file = LoadFile(N.Path);
	if (file == nil) then
		WriteToFile(N.Path, ".", false);
		FailMission(0, "reboot.txt");
	else
		PrintConsoleMessage(N.Path.." loaded.");
		N.InfoStart = file;
		N.Info = N.InfoStart;
		--[[
		for line in string.gmatch(N.Info, "([^\n]+)") do
			table.insert(N.Lines, line);
		end
		for i, line in ipairs(N.Lines) do
			
		end
		]]
	end
end

function M.WriteInfo()
	WriteToFile(N.Path, N.Info, false);
end

function M.GetChallenge(name)
	local pos, pend = string.find(N.Info, name..":");

	-- Get the number between : and newline (\nl), convert it and return it.
	if (pos) then
		local nl = string.find(N.Info, "\n", pos);
		local ns = string.sub(N.Info, pend+1, nl);
		local num = tonumber(ns);
		return num;
	end
	return nil;
end

function M.Save()
	return N;
end

function M.Load(_N)
	N = _N
end