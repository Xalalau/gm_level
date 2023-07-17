local eventName = "lvlDarkroom"

local function StartPressure()

end

local function StartTransition(ply, darkVecA)
    -- Save the player from the hall darkness
    ply.glvl_in_darkroom = true

    -- Close the door
    local door = ents.FindByName("main_arc_corridor_102_door")[1]

    timer.Simple(4, function()
        door:Fire("Close")

        timer.Simple(1, function()
            local doorWall = ents.FindByName("close_dark_room")[1]
            doorWall:Fire("Toggle")
        end)
    end)

    -- Create an aura
    local plyAura = ents.Create("sev_light")
    plyAura:Setup(GLVL, eventName, "plyAura", ply:GetPos(), Color(252, 255, 212, 2), 1000, 256)
    plyAura:SetParent(ply)
    ply.glvl_aura = plyAura

    -- Add music
    plyAura:EmitSound("music/hl1_song14.mp3")

    -- Throw the player in
    local target = ents.FindByName("enter_darkroom_in")[1]:GetPos()
    local throwDec = target - darkVecA

    ply:SetVelocity(throwDec * 16)

    -- Make the player slow
    ply:SetRunSpeed(50)
    ply:SetWalkSpeed(50)
    ply:SetJumpPower(70)
end

local function CreateEvent()
    if GLVL.Event.Memory:Get("tvIsOn") then
        timer.Simple(0.5, function()
            GLVL.Event.Memory:Set("tvIsOn")
        end)
    end

    local darkA = ents.FindByName("enter_darkroom_1")[1]
    local darkB = ents.FindByName("enter_darkroom_2")[1]

    if not IsValid(darkA) or not IsValid(darkB) then return end

    local darkVecA = darkA:GetPos()
    local darkVecB = darkB:GetPos()

    local darkTrigger = ents.Create("sev_trigger")
    darkTrigger:Setup(GLVL, eventName, "darkTrigger", darkVecA, darkVecB)

    function darkTrigger:StartTouch(ent)
        if not ent:IsPlayer() then return end

        StartTransition(ent, darkVecA)
    end

    return true
end

GLVL.Event:SetCall(eventName, CreateEvent)
