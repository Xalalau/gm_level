local eventName = "ambientGM13Hall"

local function CreateEvent()
    local fakeAmbient = ents.FindByName("fake_ambient")[1]

    if not IsValid(fakeAmbient) then return end

    -- I couldn't find this sound to play on hammer lol
    local outside = ents.Create("sev_marker")
    outside:Setup(GLVL, eventName, "ambientHole", fakeAmbient:GetPos())

    timer.Simple(0.1, function()
        outside:StartLoopingSound("ambient/atmosphere/hole_amb3.wav")
    end)

    hook.Add("glvl_gm13hall_ents", "glvl_gm13hall_ents_add_sounds", function()
        for k, lamp in ipairs(hallEnts[101].lamps) do
            local hallSound = ents.Create("sev_marker")
            hallSound:Setup(GLVL, eventName, "hallSound_101_" .. k, lamp:GetPos() + Vector(0, 0, 1000))

            timer.Simple(0.1, function()
                hallSound:StartLoopingSound("ambient/wind/wind1.wav")
            end)
        end

        for k, lamp in ipairs(hallEnts[102].lamps) do
            local hallSound = ents.Create("sev_marker")
            hallSound:Setup(GLVL, eventName, "hallSound_102_" .. k, lamp:GetPos() + Vector(0, 0, 1000))

            timer.Simple(0.1, function()
                hallSound:StartLoopingSound("ambient/wind/wind1.wav")
            end)
        end
    end)

    return true
end

GLVL.Event:OnEnabled(eventName, CreateEvent)
