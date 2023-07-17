local eventName = "fakeDoors"

local doorTime = 1


-- Find a suitable exit door 
local function GetExitDoor(hallNumber, oppenedDoor)
    local exitDoor

    local found = false
    local possibleDoors = {}
    local possibleRoomDoors = {}
    local doorsInUseExist = false

    for k, door in ipairs(hallEnts[hallNumber].roomDoors) do
        if not found and door == oppenedDoor then
            found = k
            break
        else
            if not door.inUse then
                table.insert(possibleRoomDoors, door)
            end
        end
    end

    for k, door in ipairs(hallEnts[hallNumber].doors) do
        if not found and door == oppenedDoor then
            found = k
        elseif found and k > found + 1 then
            if not door.inUse then
                table.insert(possibleDoors, door)
            else
                doorsInUseExist = true
            end
        end
    end

    if next(possibleDoors) then
        if next(possibleRoomDoors) and math.random(1, #possibleDoors + 1) > #possibleDoors then
            exitDoor = table.Random(possibleRoomDoors)
        else
            exitDoor = table.Random(possibleDoors)
        end
    elseif not doorsInUseExist then
        if next(possibleRoomDoors) and math.random(1, 100) <= 12 then
            exitDoor = table.Random(possibleRoomDoors)
        else
            exitDoor = hallEnts[hallNumber].doors[found - 1]

            if exitDoor.inUse then
                exitDoor = nil
            end
        end
    end

    return exitDoor
end

-- Set the door state as oppenig
local function SetDoorsOppening(door1, door2)
    door1.openning = true
    door2.openning = true
    timer.Simple(doorTime, function()
        door1.openning = false
        door2.openning = false
    end)
end

-- Set the door state as closing
local function SetDoorsClosing(door1, door2)
    door1.closing = true
    door2.closing = true
    timer.Simple(doorTime, function()
        door1.closing = false
        door2.closing = false
    end)
end

-- Close the portals between doors
local function RemoveDoorPortal(closedDoor)
    local otherDoor = closedDoor.otherDoor
    local createdPortalEnts = otherDoor.createdPortalEnts

    closedDoor:Input("Use")
    otherDoor:Input("Use")

    SetDoorsClosing(closedDoor, otherDoor)

    timer.Simple(doorTime, function()
        for k, ent in ipairs(createdPortalEnts) do
            if ent:IsValid() then
                GLVL.Event:RemoveRenderInfoEntity(ent)
                ent:Remove()
            end
        end

        if closedDoor:IsValid() then
            closedDoor:SetSolid(SOLID_BSP)
            closedDoor.inUse = false
            closedDoor.createdPortalEnts = nil
            closedDoor.otherDoor = nil    
        end

        if otherDoor:IsValid() then
            otherDoor:SetSolid(SOLID_BSP)
            otherDoor.inUse = false
            otherDoor.createdPortalEnts = nil
            otherDoor.otherDoor = nil
        end
    end)
end

-- Create portals between doors
local function SetDoorPortal(oppenedDoor)
    local doorName = oppenedDoor:GetName()
    local hallNumber = tonumber(string.Explode("_", doorName)[3])
    local exitDoor = GetExitDoor(hallNumber, oppenedDoor)

    if not exitDoor then
        oppenedDoor:EmitSound("doors/door_locked2.wav")
        return true
    end

    oppenedDoor:SetSolid(SOLID_NONE)
    exitDoor:SetSolid(SOLID_NONE)

    exitDoor:Input("Use")

    SetDoorsOppening(oppenedDoor, exitDoor)

    local correctDown
    if hallNumber > 100 then
        correctDown = Vector(0, 0, 0)
    else
        correctDown = Vector(0, 0, 8)
    end

    local enterForward = GLVL.Ent:GetEntranceForward(eventName, oppenedDoor)
    local enterRight = enterForward:Angle():Right()

    local portalEnterPos = oppenedDoor:GetPos() - enterRight * 24 - correctDown
    local portalEnterAng = enterForward:Angle() + Angle(-90, -180, 0)

    local enterVecA = oppenedDoor:GetPos() + Vector(400, -400, -60) + enterForward * 98
    local enterVecB = oppenedDoor:GetPos() + Vector(-400, 400, 60) + enterForward * 98

    local exitForward = GLVL.Ent:GetEntranceForward(eventName, exitDoor)
    local exitRight = exitForward:Angle():Right()

    local portalExitPos = exitDoor:GetPos() - exitRight * 24 - correctDown
    local portalExitAng = exitForward:Angle() + Angle(-90, -180, 0)

    local exitVecA = exitDoor:GetPos() + Vector(400, -400, -60) + exitForward * 98
    local exitVecB = exitDoor:GetPos() + Vector(-400, 400, 60) + exitForward * 98

    local startTriggersInfo = {
        {
            vecA = enterVecA,
            vecB = enterVecB,
            probability = 100
        }
    }

    portalInfo = {
        {
            {
                pos = portalEnterPos,
                ang = portalEnterAng,
                sizeY = 0.475,
                sizeZ = 0.41,
            },
            {
                pos = portalExitPos,
                ang = portalExitAng,
                sizeY = 0.475,
                sizeZ = 0.41,
                noRender = string.find(exitDoor:GetName(), "invis") and true or false
            }
        }
    }

    if hallNumber > 100 then
        portalInfo[1][1].sizeX = 1.07
    else
        portalInfo[1][1].sizeX = 1.15
    end
    portalInfo[1][2].sizeX = portalInfo[1][1].sizeX

    local maxAreaTriggersInfo = {
        {
            vecA = enterVecA,
            vecB = enterVecB
        },
        {
            vecA = exitVecA,
            vecB = exitVecB
        }
    }

    local createdPortalEnts








    -- É possível sair tão rápido da área dos portais que a gente tenta fechar as portas antes delas estarem prontas pra isso?????

    local callbacks = {
        endPortals = function()
            RemoveDoorPortal(oppenedDoor)
        end
    }







    createdPortalEnts = SEv.Custom:CreatePortalAreas(GLVL, eventName, maxAreaTriggersInfo, startTriggersInfo, portalInfo, callbacks)
    local extraId = #ents.FindByClass("sev_portal")

    local checkCrossed = ents.Create("sev_trigger")
    checkCrossed:Setup(GLVL, eventName, "check_crossed_" .. extraId, exitDoor:GetPos() + Vector(50, 50, 50), exitDoor:GetPos() - Vector(50, 50, 50))
    table.insert(createdPortalEnts, checkCrossed)

    timer.Create("glvl_check_door_time", doorTime, 1, function() end)

    function checkCrossed:StartTouch(ent)
        if IsValid(ent) and ent:IsPlayer() then
            local safePos = oppenedDoor:GetPos() + enterForward * 25 - Vector(0, 0, 40)

            timer.Simple(0.2, function()
                if SEv.Ply:IsPlayerStuck(ent) then
                    ent:SetPos(safePos)
                end
            end)

            timer.Simple(0.6, function()
                if SEv.Ply:IsPlayerStuck(ent) then
                    ent:SetPos(safePos)
                end
            end)

            timer.Simple(1.5, function()
                if SEv.Ply:IsPlayerStuck(ent) then
                    ent:SetPos(safePos)
                end
            end)
        end
    end

    function checkCrossed:EndTouch(ent)
        if IsValid(ent) and ent:IsPlayer() then
            timer.Simple(timer.TimeLeft("glvl_check_door_time") or 0, function()
                RemoveDoorPortal(oppenedDoor)
            end)
        end
    end

    oppenedDoor.inUse = true
    oppenedDoor.createdPortalEnts = createdPortalEnts
    oppenedDoor.otherDoor = exitDoor

    exitDoor.inUse = true
    exitDoor.createdPortalEnts = createdPortalEnts
    exitDoor.otherDoor = oppenedDoor

    return false
end

local function CreateEvent()
    hook.Add("AcceptInput", "level!_open_door", function(ent, input, activator, caller, value)
        if IsValid(ent) and
           IsValid(activator) and
           input == "Use" and
           activator:IsPlayer(activator) and
           ent.GetName and
           string.find(ent:GetName(), "main_corridor_", nil, true)
          then
            if ent.closing or ent.openning then return true end

            if ent.inUse then
                RemoveDoorPortal(ent)
            else
                return SetDoorPortal(ent)
            end
        end
    end)

    return true
end

local function RemoveEvent()
    hook.Remove("AcceptInput", "level!_open_door")

    return true
end

GLVL.Event:OnEnabled(eventName, CreateEvent)
GLVL.Event:OnDisabled(eventName, RemoveEvent)
