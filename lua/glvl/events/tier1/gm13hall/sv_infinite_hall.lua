local eventName = "infiniteHall"

local function UnstuckPly(ent, safePos)
    if IsValid(ent) and ent:IsPlayer() then
        timer.Simple(0.2, function()
            if SEv.Ply:IsPlayerStuck(ent) then
                ent:SetPos(safePos)
            end
        end)

        timer.Simple(1, function()
            if SEv.Ply:IsPlayerStuck(ent) then
                ent:SetPos(safePos)
            end
        end)

        timer.Simple(2.5, function()
            if SEv.Ply:IsPlayerStuck(ent) then
                ent:SetPos(safePos)
            end
        end)
    end
end

local function CreateEvent()
    local pEnts = {
        triggerEntranceVecA = ents.FindByName("infinite_hall_entrance_vec_a")[1],
        triggerEntranceVecB = ents.FindByName("infinite_hall_entrance_vec_b")[1],

        triggerMaxVecA = ents.FindByName("infinite_hall_max_area_vec_a")[1],
        triggerMaxVecB = ents.FindByName("infinite_hall_max_area_vec_b")[1],

        portalStart = ents.FindByName("infinite_hall_start")[1],
        portalEnd = ents.FindByName("infinite_hall_end")[1],
    }

    if not next(pEnts) then return end

    for _, ent in pairs(pEnts) do
        if not IsValid(ent) then
            return false
        end
    end

    local startPos = pEnts.portalStart:GetPos()
    local endPos = pEnts.portalEnd:GetPos()

    local startForward = GLVL.Ent:GetEntranceForward(eventName, pEnts.portalStart)
    local endForward = GLVL.Ent:GetEntranceForward(eventName, pEnts.portalEnd)

    local startAngles = startForward:Angle() + Angle(-90, -180, 0)
    local endAngles = endForward:Angle() + Angle(-90, -180, 0)

    local maxAreaTriggersInfo = {
        {
            vecA = pEnts.triggerMaxVecA:GetPos() - Vector(0, 0, 132), -- Max point A goes under the map
            vecB = pEnts.triggerMaxVecB:GetPos() + Vector(0, 0, 276), -- Max point B goes over the map
        }
    }

    local startTriggersInfo = {
        {
            vecA = pEnts.triggerEntranceVecA:GetPos(),
            vecB = pEnts.triggerEntranceVecB:GetPos(),
            probability = 100
        }
    }

    local portalInfo = {
        {
            {
                pos = startPos + startForward * 4.5,
                ang = startAngles,
                sizeX = 1.34,
                sizeY = 2.023,
                sizeZ = 1
            },
            {
                pos = endPos + endForward * 3,
                ang = endAngles,
                sizeX = 1.34,
                sizeY = 2.023,
                sizeZ = 1
            }
        }
    }

    local safePosStart = startPos + startForward * 25 - Vector(0, 0, 40)
    local checkCrossedStart = ents.Create("sev_trigger")
    checkCrossedStart:Setup(GLVL, eventName, "check_crossed_infinite_hall_start", startPos + Vector(80, 80, 20), startPos - Vector(80, 80, 60))

    function checkCrossedStart:StartTouch(ent)
        UnstuckPly(ent, safePosStart)
    end

    SEv.Custom:CreatePortalAreas(GLVL, eventName, maxAreaTriggersInfo, startTriggersInfo, portalInfo)    

    return true
end

GLVL.Event:SetCall(eventName, CreateEvent)
