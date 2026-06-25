local M = {};
local N = 
{
	InfoStart = "", -- On reading it in for the first time, 
	Info = "",
	Path = "",
	Lines = {},
	Goals = {},	-- holds the string names of the goals
};

--[[
A typical challenge file will look like this:

m<mission number><name>:<amount> -- Name of the challenge, how much scrap's been earned

I.e. Red Arrival's looks like this:

M02ScrapUsed:10

]]

function M.InitialSetup()
    
end

function M.Start()
	M.ReadIn(false);
end

function M.ReadIn(allgoals)
	allgoals = allgoals or false;
--	local plr = GetPlayerHandle();
--	local pname = GetPlayerName(GetPlayerHandle());
	local pname = GetProfileName();
	N.Path = pname.."_challenges.txt";
	local file = LoadFile(N.Path);
	if (file == nil) then
		WriteToFile(N.Path, "", false);
		FailMission(0, "reboot.txt"); -- don't call TCC's version, we want EVERYTHING to abort.
	else
		PrintConsoleMessage(N.Path.." loaded.");
		N.Info = file;
		N.InfoStart = N.Info;

		local ind = 0;

		if (N.Info == "") then
			PrintConsoleMessage("Empty challenge file.");
			return 0;
		end
		
		local mnum = PrefixMisnNum(""); 
		local count = 0;
		-- split all lines with newline into N.Lines
		for line in string.gmatch(N.Info, "[^\r\n]+") do
			table.insert(N.Lines, line);
			-- look for 
			local varName, num = line:match("^(.-):(%d+)$");
			if (varName and num) then
				-- only load in the mission number specified, i.e. m13<name> for mission 13, etc.
				if (allgoals or (varName:sub(1, #mnum) == mnum)) then
					M.SetBonusGoal(varName, tonumber(num), true, false);
				end
			end
		end

		return count;
	end
	return 0;
end

-- Grabs the data from N.Goals, updates N.Lines, then concatenates it back to N.Info, finally writing it out.
function M.WriteInfo()
	for goalName, goalValue in pairs(N.Goals) do
		local found = false

		for i, line in ipairs(N.Lines) do
			local varName = line:match("^(.-):%d+$")
			if (varName == goalName) then
				N.Lines[i] = goalName..":"..tostring(goalValue);
				found = true;
				break;
			end
		end

		if (not found) then
			table.insert(N.Lines, goalName..":"..tostring(goalValue));
		end
	end
	N.Info = table.concat(N.Lines, "\n");
	WriteToFile(N.Path, N.Info, false);
end

function M.Save()
	return N;
end

function M.Load(_N)
	N = _N
end

function MisnNumStr()
	local snum = string.format("%02d", MisnNum);
	return snum;
end

-- Adds the proper string to format and apply IFace vars.
function FormatBonusGoal(goal)
	return "script."..goal;
end

function PrefixMisnNum(goal)
	return "m"..MisnNumStr()..goal;
end

function M.GetBonusGoal(goal)
	return IFace_GetInteger(FormatBonusGoal(goal));
end

function M.Win(Amount)
	M.SetBonusGoal("victory", Amount);
end

-- Sets the bonus goal variable to the specified amount. Takes the RAW name without preformatting!
-- By default it uses whatever is higher, set force to true to bypass this rule.
---@param goal string Name of the goal.
---@param amount number Ancient Scrap to award. Clamps to which is higher: how much they've earned so far, and what they will earn on mission success.
---@param force boolean? False. If true, ignores clamping and resets the amount earned from this goal.
---@param prefix boolean? True. DO NOT CHANGE. Adds the mission number behind the variable to ensure unique naming.
function M.SetBonusGoal(goal, amount, force, prefix)
	if (prefix == nil) then prefix = true; end;
	if (force == nil) then force = false; end;
	amount = amount or 0;

	if (prefix) then
		goal = PrefixMisnNum(goal);
	end

	local formatted = FormatBonusGoal(goal);
	local check = IFace_GetInteger(FormatBonusGoal(goal));

	if (check) then	
		if (check < amount or force) then
			IFace_SetInteger(formatted, amount);
			N.Goals[goal] = amount;
		end
	else
		IFace_CreateInteger(formatted, amount);
		N.Goals[goal] = amount;
	end

	if (not force and amount > 0) then
		StartSoundEffect("AncientScrap.ogg");
	end
	
end

return M;