local eventName = "infiniteStair"

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
        triggerEntranceVecA = ents.FindByName("infinite_stair_entrance_vec_a")[1],
        triggerEntranceVecB = ents.FindByName("infinite_stair_entrance_vec_b")[1],

        triggerMaxVecCenter = ents.FindByName("infinite_stair_center")[1],

        portalTop = ents.FindByName("infinite_stair_top")[1],
        portalBottom = ents.FindByName("infinite_stair_bottom")[1],
    }

    if not next(pEnts) then return end

    for _, ent in pairs(pEnts) do
        if not IsValid(ent) then
            return false
        end
    end

    local topPos = pEnts.portalTop:GetPos()
    local bottomPos = pEnts.portalBottom:GetPos()

    local topForward = GLVL.Ent:GetEntranceForward(eventName, pEnts.portalTop)
    local bottomForward = GLVL.Ent:GetEntranceForward(eventName, pEnts.portalBottom)

    local topAngles = topForward:Angle() + Angle(-90, -180, 0)
    local bottomAngles = bottomForward:Angle() + Angle(-90, -180, 0)

    local maxAreaTriggersInfo = {
        {
            vecA = pEnts.triggerMaxVecCenter:GetPos() + Vector(272, 272, 264),
            vecB = pEnts.triggerMaxVecCenter:GetPos() - Vector(272, 272, 264),
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
                pos = topPos - topForward * 2,
                ang = topAngles,
                sizeX = 2.77,
                sizeY = 0.76,
                sizeZ = 1
            },
            {
                pos = bottomPos - bottomForward * 2,
                ang = bottomAngles,
                sizeX = 2.77,
                sizeY = 0.76,
                sizeZ = 1
            }
        }
    }

    local safePosTop = topPos + topForward * 25 - Vector(0, 0, 130)
    local checkCrossedTop = ents.Create("sev_trigger")
    checkCrossedTop:Setup(GLVL, eventName, "check_crossed_infinite_stair_top", topPos + Vector(50, 50, 0), topPos - Vector(50, 50, 100))

    function checkCrossedTop:StartTouch(ent)
        UnstuckPly(ent, safePosTop)
    end

    SEv.Custom:CreatePortalAreas(GLVL, eventName, maxAreaTriggersInfo, startTriggersInfo, portalInfo)    

    return true
end

GLVL.Event:SetCall(eventName, CreateEvent)
