local eventName = "poolExit"

local function CreatePoolPortals()
    local randomLight = table.Random(hallEnts[1].lights)
    local portalHallPos = randomLight:GetPos()
    
    local exitTriggerPos = ents.FindByName("pool_start")[1]:GetPos()
    local portalPoolPos = ents.FindByName("pool_exit")[1]:GetPos()

    local startTriggersInfo = {
        {
            vecA = exitTriggerPos + Vector(20, 20, 20),
            vecB = exitTriggerPos - Vector(20, 20, 20),
            probability = 100
        }
    }
    
    local portalInfo = {
        {
            {
                pos = portalPoolPos,
                ang = Angle(90, 90, 180),
                sizeX = 0.2,
                sizeY = 0.2,
                sizeZ = 0.41,
            },
            {
                pos = portalHallPos,
                ang = Angle(0, -90, 180),
                sizeX = 0.2,
                sizeY = 0.2,
                sizeZ = 0.41,
                noRender = true
            }
        }
    }

    local maxAreaTriggersInfo = {
        {
            vecA = portalPoolPos + Vector(200, 200, 200),
            vecB = portalPoolPos - Vector(200, 200, 200)
        },
        {
            vecA = portalHallPos + Vector(20, 20, 20),
            vecB = portalHallPos - Vector(20, 20, 20)
        }
    }

    local callbacks = {
        plyExitMaxAreas = function()
            isExitOpen = false
        end
    }

    SEv.Custom:CreatePortalAreas(GLVL, eventName, maxAreaTriggersInfo, startTriggersInfo, portalInfo, callbacks)
end

local function CreateEvent()
    hook.Add("glvl_gm13hall_ents", "glvl_wait_ents_pool", function()
        CreatePoolPortals()
    end)
end

GLVL.Event:SetCall(eventName, CreateEvent)
