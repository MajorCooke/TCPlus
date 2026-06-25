-- Clamps a value between min and max.
---@param var number
---@param min number
---@param max number
function ClampInt(var, min, max)
	return ClampVal(var, min, max);
end

-- Clamps a value between min and max.
---@param var number
---@param min number
---@param max number
function ClampVal(var, min, max)
	return math.max(min, math.min(max, var));
end