function ClampInt(var, min, max)
	return math.max(min, math.min(max, var));
end