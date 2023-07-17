local eventName = "gm13HallEntrance"

-- Set the hall rules
-- No flashlight
local function CreateEvent()
    local hallEntrance = ents.FindByName("hall_101_flashlight_killer")[1]

    if not IsValid(hallEntrance) then return end
    
    local hallTrigger = ents.Create("sev_trigger")
    hallTrigger:Setup(GLVL, eventName, "hallTrigger", hallEntrance:GetPos() + Vector(90, 90, 120), hallEntrance:GetPos() - Vector(90, 90, 0))

    function hallTrigger:StartTouch(ent)
        if not ent:IsPlayer() then return end

        if not GetConVar("state_devmode_" .. GLVL.id):GetBool() then
            ent:Flashlight(false)
            ent:AllowFlashlight(false)
        end

        ent.glvl_in_gm13_hall = true -- Bloquear qualquer um de entar nessa área, essa é a chave
    end

    return true
end

GLVL.Event:OnEnabled(eventName, CreateEvent)