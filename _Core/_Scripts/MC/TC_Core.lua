assert(load(assert(LoadFile("_requirefix.lua")),"_requirefix.lua"))();
require('TC_Functions'); --Just a bunch of functions that don't need saving
local AI =			require('TC_AI');
local Goals =		require('TC_Objectives');
local Upgrades =	require('TC_Upgrades');
local Challenges =	require('TC_Challenges');
local M = {};	-- FUNCTION table
local N =		-- VARIABLE table
{
	-- Used for save data only. Keep it clear otherwise.
	AI = {},
	Goals = {},
	Upgrades = {},
	Challenges = {},
	-- Core vars here
}

-- Put in all hooks first

function M.Save()
	N.AI = AI.Save();
	N.Goals = Goals.Save();
	N.Upgrades = Upgrades.Save();
	N.Challenges = Challenges.Save();
	return N;
end

function M.Load(_N)
	N = _N;
	AI.Load(N.AI); 					_N.AI = {};
	Goals.Load(N.Goals); 			_N.Goals = {};
	Upgrades.Load(N.Upgrades);		_N.Upgrades = {};
	Challenges.Load(N.Challenges);	_N.Challenges = {};
end

function M.FailMission(Time, Debrief)
	FailMission(Time, Debrief);
end

-- This version writes out the 
function M.SucceedMission(Time, Debrief)
	Challenges.WriteInfo(); -- Success, save the challenges out with their new values.
	SucceedMission(Time, Debrief);
end

function M.Update()
	AI.Update();
end

function M.InitialSetup()
	AI.InitialSetup();
	Goals.InitialSetup();
	Upgrades.InitialSetup();
	Challenges.InitialSetup();
end

function M.Init() 
	M.InitialSetup();
end

function M.Start()
	AI.Start();
	Upgrades.Start();
	Challenges.Start();
end

function M.ObjectKilled(DeadObject, Killer)
	AI.ObjectKilled(DeadObject, Killer);
end

function M.AddObject(h)
	-- Disable Fury pilot ejections. 
	if (IsCraftButNotPerson(h) and GetRace(h) == "y") then
		SetEjectRatio(h, 0.0);
	end

	AI.AddObject(h);
end

function M.DeleteObject(h)
	AI.DeleteObject(h);
end



function M.PreSnipe(world, shooter, victim, OrdTeam, OrdODF)
	-- 1 prevents, 0 allows
	local snipe = AI.PreSnipe(world, shooter, victim, OrdTeam, OrdODF);
	if (snipe > -1) then
		return snipe;
	elseif (GetPlayerHandle() == victim and Upgrades.Get("bulletproof")) then
		return 1;
	end
	return 0;
end

function M.PreGetIn(world, pilot, craft)
	-- 0 prevents, 1 allows
	-- if craft is player's previous ship and has ID lock and pilot isn't friend, 
	-- return 0
	return 1;
end

function M.PrePickupPowerup(world, who, item)
	-- 0 prevents, 1 allows
	return 1;
end

function M.PostTargetChangedCallback(craft, prev, cur)

end

function M.SetTeamNum(h, team)
	AI.SetTeamNum(h, team);
end

----------------------------
-- Custom Functions below --
----------------------------

function M.ReplaceObject(h, className)
	return AI.ReplaceObject(h, className);
end

function M.GetBonusGoal(challenge)
	return Challenges.GetBonusGoal(challenge);
end

function M.SetBonusGoal(challenge, amount)
	Challenges.SetBonusGoal(challenge, amount);	
end

return M;