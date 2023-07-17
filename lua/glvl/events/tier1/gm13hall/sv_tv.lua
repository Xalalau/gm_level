local eventName = "coolTv"

GLVL.Event.Memory.Dependency:SetProvider(eventName, "tvIsOn")

local function CreateEvent()
    if GLVL.Event.Memory:Get("tvIsOn") then
        timer.Simple(0.5, function()
            GLVL.Event.Memory:Set("tvIsOn")
        end)
    end

    local theTv = ents.FindByName("nice_tv")[1]

    if not IsValid(theTv) then return end

    local tvTrigger = ents.Create("sev_trigger")
    tvTrigger:Setup(GLVL, eventName, "tvTrigger", theTv:GetPos() + Vector(85, 85, 25), theTv:GetPos() - Vector(85, 85, 50))

    function tvTrigger:StartTouch(ent)
        if not ent:IsPlayer() then return end

        local tvImage = ents.Create("sev_func_image")
        tvImage:Setup(GLVL, eventName, "tvImage", theTv:GetPos() - Vector(6, 1.6, 1.8), 14, 15, Angle(14.063, 120, -178.187), "props/tvscreen001a")

        timer.Simple(0.02, function()
            if tvImage:IsValid() then
                tvImage:EmitSound("ambient/energy/spark2.wav")
                
                SEv.Net:Start("sev_create_sparks")
                net.WriteVector(theTv:GetPos() - Vector(0, 3, 1.8))
                net.Broadcast()
            end
        end)

        timer.Simple(0.22, function()
            if tvImage:IsValid() then
                tvImage:StartLoopingSound("ambient/energy/electric_loop.wav")

                local darkRoomDoor = ents.FindByName("main_arc_corridor_102_door")[1]

                if darkRoomDoor:IsValid() then
                    darkRoomDoor:Fire("Unlock")
                    darkRoomDoor:Fire("Open")
                end

                GLVL.Event.Memory:Set("tvIsOn", true)
            end

            if tvTrigger:IsValid() then
                tvTrigger:Remove()
            end
        end)
    end

    return true
end

GLVL.Event:SetCall(eventName, CreateEvent)