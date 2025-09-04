--[[ Returns a position 'near' Pos, in the ring between MinRadiusAway
 and MaxRadiusAway, and with roughly the same terrain height as the
 terrain at the original position. This is used to place allies near
 their starting point, and randomize respawns near a location so
 it's harder to multi-kill by firing at a fixed location
]]

--[[
    Vector GetPositionNearTransform(Matrix xfrmPos, number minRadiusAway, number maxRadiusAway)
    Vector GetPositionNearPosition(Vector pos, number minRadiusAway, number maxRadiusAway)
    Vector GetPositionNearObject(Handle obj, number minRadiusAway, number maxRadiusAway)
    Vector GetPositionNearPath(string path, int point, number minRadiusAway, number maxRadiusAway)
]]

-- Why? ... Why not?
PI = math.pi; -- 3.1415926535898

--[[
>>> Vector GetPositionNear(Matrix Pos, number MinRadius, number MaxRadius)
    Vector GetPositionNear(Vector Pos, number MinRadius, number MaxRadius)
    Vector GetPositionNear(Handle obj, number MinRadius, number MaxRadius)
    Vector GetPositionNear(string Path, int Point, number MinRadius, number MaxRadius)
]]

function GetPositionNearTransform(xfrmPos, minRadiusAway, maxRadiusAway)
    
    -- How much vertical displacement is tolerated from the center's position?
    local maxVerticalDisplacement = math.max( 3.0, (maxRadiusAway * 0.5) );
    -- How many times to try and find a suitable location?
    local maxRetries = 256;
    
    pos = xfrmPos.posit;
    
    local newPos = pos;
    pos.y = TerrainFindFloor(pos.x, pos.z);
    
    local gotPosition = false;
    local onTry = 0;
    local angle = 0;
    local radius = 0;
    local bestDiff = 9999.0;
    local bestPos = pos;

    repeat
        local angle = GetRandomFloat(2*PI);
        local radius = minRadiusAway + GetRandomFloat(1.0) * (maxRadiusAway - minRadiusAway);
        local rayHitOk = true;
        
        for checkStep = 0.0, 0.9, 0.05 do
            newPos = GetCircularPos(pos, radius*checkStep, angle);
            if math.abs(newPos.y - pos.y) > (maxVerticalDisplacement * 2.0) then
                rayHitOk = false;
                break;
            end
        end
        if rayHitOk then
            heightDiff = math.abs(newPos.y - pos.y);
            if heightDiff < bestDiff then
                bestPos = newPos;
                bestDiff = heightDiff;
            end
            if heightDiff < maxVerticalDisplacement then
                bestPos = newPos;
                gotPosition = true;
            end
        end
        onTry = onTry + 1;
        if math.fmod(onTry,16) == 0 then
            radius = 0.9 * radius;
        end
    until not ( gotPosition and (onTry < maxRetries) )

    return bestPos;
end


--[[
    Vector GetPositionNear(Matrix Pos, number MinRadius, number MaxRadius)
>>> Vector GetPositionNear(Vector Pos, number MinRadius, number MaxRadius)
    Vector GetPositionNear(Handle Pos, number MinRadius, number MaxRadius)
    Vector GetPositionNear(string Path, int Point, number MinRadius, number MaxRadius)
]]

function GetPositionNearPosition(pos, minRadiusAway, maxRadiusAway)
    
    local maxVerticalDisplacement = math.max( 3.0, (maxRadiusAway * 0.5) );
    local maxRetries = 256;
    
    local newPos = pos;
    pos.y = TerrainFindFloor(pos.x, pos.z);
    
    local gotPosition = false;
    local onTry = 0;
    local angle = 0;
    local radius = 0;
    local bestDiff = 9999.0;
    local bestPos = pos;

    repeat
        local angle = GetRandomFloat(2*PI);
        local radius = minRadiusAway + GetRandomFloat(1.0) * (maxRadiusAway - minRadiusAway);
        local rayHitOk = true;
        
        for checkStep = 0.0, 0.9, 0.05 do
            newPos = GetCircularPos(pos, radius*checkStep, angle);
            if math.abs(newPos.y - pos.y) > (maxVerticalDisplacement * 2.0) then
                rayHitOk = false;
                break;
            end
        end
        if rayHitOk then
            heightDiff = math.abs(newPos.y - pos.y);
            if heightDiff < bestDiff then
                bestPos = newPos;
                bestDiff = heightDiff;
            end
            if heightDiff < maxVerticalDisplacement then
                bestPos = newPos;
                gotPosition = true;
            end
        end
        onTry = onTry + 1;
        if math.fmod(onTry,16) == 0 then
            radius = 0.9 * radius;
        end
    until not ( gotPosition and (onTry < maxRetries) )

    return bestPos;
end



--[[
    Vector GetPositionNear(Matrix Pos, number MinRadius, number MaxRadius)
    Vector GetPositionNear(Vector Pos, number MinRadius, number MaxRadius)
>>> Vector GetPositionNear(Handle obj, number MinRadius, number MaxRadius)
    Vector GetPositionNear(string Path, int Point, number MinRadius, number MaxRadius)
]]

function GetPositionNearObject(obj, minRadiusAway, maxRadiusAway)
    
    local maxVerticalDisplacement = math.max( 3.0, (maxRadiusAway * 0.5) );
    local maxRetries = 256;
    
    -- LOL THIS IS THE ONLY DIFFERENCE
    if IsValid(obj) then
        pos = GetPosition(obj);
    else
        -- OBJECT IS IN PROCESS OF DYING?
        pos = GetPosition2(obj);
        -- SOMETHING IS VERY WRONG, PLEASE GO BELLY UP
        if IsNullVector(pos) then
            return nil;
        end
    end
    
    local newPos = pos
    pos.y = TerrainFindFloor(pos.x, pos.z);
    
    local gotPosition = false;
    local onTry = 0;
    local angle = 0;
    local radius = 0;
    local bestDiff = 9999.0;
    local bestPos = pos;

    repeat
        local angle = GetRandomFloat(2*PI);
        local radius = minRadiusAway + GetRandomFloat(1.0) * (maxRadiusAway - minRadiusAway);
        local rayHitOk = true;
        
        for checkStep = 0.0, 0.9, 0.05 do
            newPos = GetCircularPos(pos, radius*checkStep, angle);
            if math.abs(newPos.y - pos.y) > (maxVerticalDisplacement * 2.0) then
                rayHitOk = false;
                break;
            end
        end
        if rayHitOk then
            heightDiff = math.abs(newPos.y - pos.y);
            if heightDiff < bestDiff then
                bestPos = newPos;
                bestDiff = heightDiff;
            end
            if heightDiff < maxVerticalDisplacement then
                bestPos = newPos;
                gotPosition = true;
            end
        end
        onTry = onTry + 1;
        if math.fmod(onTry,16) == 0 then
            radius = 0.9 * radius;
        end
    until not ( gotPosition and (onTry < maxRetries) )

    return bestPos;
end



--[[
    Vector GetPositionNear(Matrix Pos, number MinRadius, number MaxRadius)
    Vector GetPositionNear(Vector Pos, number MinRadius, number MaxRadius)
    Vector GetPositionNear(Handle obj, number MinRadius, number MaxRadius)
>>> Vector GetPositionNear(string Path, int Point, number MinRadius, number MaxRadius)
]]

function GetPositionNearPath(path, point, minRadiusAway, maxRadiusAway)
    
    local maxVerticalDisplacement = math.max( 3.0, (maxRadiusAway * 0.5) );
    local maxRetries = 256;
    
    pos = GetPosition(path, point);
    
    local newPos = pos
    pos.y = TerrainFindFloor(pos.x, pos.z);
    
    local gotPosition = false;
    local onTry = 0;
    local angle = 0;
    local radius = 0;
    local bestDiff = 9999.0;
    local bestPos = pos;

    repeat
        local angle = GetRandomFloat(2*PI);
        local radius = minRadiusAway + GetRandomFloat(1.0) * (maxRadiusAway - minRadiusAway);
        local rayHitOk = true;
        
        for checkStep = 0.0, 0.9, 0.05 do
            newPos = GetCircularPos(pos, radius*checkStep, angle);
            if math.abs(newPos.y - pos.y) > (maxVerticalDisplacement * 2.0) then
                rayHitOk = false;
                break;
            end
        end
        if rayHitOk then
            heightDiff = math.abs(newPos.y - pos.y);
            if heightDiff < bestDiff then
                bestPos = newPos;
                bestDiff = heightDiff;
            end
            if heightDiff < maxVerticalDisplacement then
                bestPos = newPos;
                gotPosition = true;
            end
        end
        onTry = onTry + 1;
        if math.fmod(onTry,16) == 0 then
            radius = 0.9 * radius;
        end
    until not ( gotPosition and (onTry < maxRetries) )

    return bestPos;
end