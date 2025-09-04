-- 

local M = {} 
local N = 
{
    CurText = "",
    AddText = "",
    RevertTime = -1.0,
}
local s = "";

function M.InitialSetup()
	
end

function M.Start()

end


function AppendObjective(str)

end

function M.Save()
	return N;
end

function M.Load(_N)
	N = _N;
end



return M;