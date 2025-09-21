-- Not to be confused with challenges. This is just a bunch of wrapper handles to allow for easier customization of the objectives idsplay.

local M = {} 
local N = 
{
    CurText = "",
    AddText = "",
    RevertTime = -1.0,

	Lines = {},		-- Each line of text, key-val pair where there val is a hex color.
}
local edit = false;

function M.InitialSetup()
	
end

function M.Start()

end

function M.Update()
	if (edit) then
		edit = false;

	end
end

function M.Save()
	return N;
end

function M.Load(_N)
	N = _N;
end
--[[

Custom functions

--]]



function M.ClearObjectives()
	ClearObjectives();
	N.Lines = {};
end


function ValidateRGB(r,g,b)
	r = r or 255;	r = ClampInt(r, 0, 255);
	g = g or 255;	g = ClampInt(g, 0, 255);
	b = b or 255;	b = ClampInt(b, 0, 255);

	return r,g,b;
end
function M.ColorObjective(des, rr, gg, bb)
	edit = true;
	r, g, b = ValidateRGB(rr,gg,bb);
	for _, entry in pairs(N.Lines) do
		if (entry and entry.desc and entry.desc == des) then
			entry.r = rr;
			entry.g = gg;
			entry.b = bb;
			return;
		end
	end

	table.insert(N.Lines, {desc = des, r = rr, g = gg, b = bb});
end

function M.AddObjective(desc, r, g, b)
	edit = true;
	r = r or 255;
	g = g or 255;
	b = b or 255;

end

function M.RemoveObjective(desc)
	
end

-- Misc functions for other places
function HexToRGB(hex)
	hex = hex:gsub("#", "");
	
	if (#hex > 6) then
		hex = hex:sub(hex, 1, 6); -- Ensure it's only 6.
	elseif (#hex < 6) then
		while (#hex < 6) do
			hex = hex.."0";
		end
	end
	local r = tonumber(hex:sub(1, 2), 16);
    local g = tonumber(hex:sub(3, 4), 16);
    local b = tonumber(hex:sub(5, 6), 16);
	return r, g, b;
end

function RGBToHex(r, g, b)
	r = r or 255;
	g = g or 255;
	b = b or 255;

	return string.format("%02X%02X%02X", r, g, b);
end

return M;