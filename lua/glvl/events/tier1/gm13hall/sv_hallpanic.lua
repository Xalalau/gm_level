local eventName = "hallPanic"

GLVL.Event.Memory.Dependency:SetDependent(eventName, "tvIsOn")

-- Check if the player is in a good range
local function CheckAlive(ply, k, total)
    local maxDist = 1300
    local subtract = 200

    local newMaxDist = maxDist - subtract * k * 1.2

    local destiny = ents.FindByName("main_arc_corridor_102_door")[1]:GetPos()

    if (destiny:Distance(ply:GetPos()) > newMaxDist or k == total) and not ply.glvl_in_darkroom then
        ply:Kill()
        return false
    end

    return true
end

-- Good bye Hall 1
local function StartHall1Sequence()
    timer.Simple(2, function()
        timer.Simple(0, function()
            local delay = 10
            
            for k, lamp in ipairs(hallEnts[101].lamps) do
                timer.Simple(k == 1 and 0.1 or delay, function() -- Make the path darker
                    if lamp:IsValid() then
                        lamp:SetModel("models/props_c17/light_domelight02_off.mdl")
                    end
                end)
    
                delay = delay / 3
            end
        end)
    
        timer.Simple(0, function()
            local delay = 10
    
            for k, light in ipairs(hallEnts[101].lights) do
                local newLight = ents.Create("sev_light")
                newLight:Setup(GLVL, eventName, "light_1_" .. k, light:GetPos(), Color(252, 255, 212, 2), 1000, 256)

                if k == 1 and light:IsValid() then
                    light:Fire("TurnOff")
                end

                timer.Simple(k == 1 and 0.1 or delay, function()
                    if newLight:IsValid() then
                        newLight:SetOn(false)
                        newLight:EmitSound("plats/elevator_stop1.wav", 125)
                    end
                end)
    
                delay = delay / 3
            end
        end)
    end)
end

-- Good bye Hall 2
local function StartHall2Sequence(ply)
    timer.Simple(0, function()
        timer.Simple(0, function()
            local delay = 10
            
            for k = #hallEnts[102].lamps, 1, -1 do
                local lamp = hallEnts[102].lamps[k]
    
                timer.Simple(delay, function()
                    if lamp:IsValid() then
                        lamp:SetModel("models/props_c17/light_domelight02_off.mdl")
                    end
                end)
    
                delay = delay / 2
            end
        end)

        timer.Simple(0, function()
            local delay = 10
            local normalLightsOn = true
            local total = #hallEnts[102].lights
            local isPlayerAlive = true
    
            for k = total, 1, -1 do
                local light = hallEnts[102].lights[k]
    
                if normalLightsOn then
                    if light:IsValid() then
                        light:Fire("TurnOff")
                    end
                end

                local newLight = ents.Create("sev_light")
                newLight:Setup(GLVL, eventName, "light_2_" .. k, light:GetPos(), Color(252, 255, 212, 2), 1000, 256)
    
                timer.Simple(delay, function()    
                    if newLight:IsValid() then
                        newLight:SetOn(false)
                        newLight:EmitSound("plats/elevator_stop1.wav", 125)
                    end

                    if isPlayerAlive then
                        isPlayerAlive = CheckAlive(ply, k, total)
                    end
                end)
    
                delay = delay / 2
            end
        end)
    end)
end

local function CreateEvent()
    local hallPanic1Target = ents.FindByName("hall_panic_1")[1]
    local hallPanic2Target = ents.FindByName("hall_panic_2")[1]

    if not IsValid(hallPanic1Target) or not IsValid(hallPanic2Target) then return end

    local panicStart = ents.Create("sev_trigger")
    panicStart:Setup(GLVL, eventName, "panicStart", hallPanic1Target:GetPos(), hallPanic2Target:GetPos())

    function panicStart:StartTouch(ent)
        if not ent:IsPlayer() then return end

        StartHall1Sequence()
        StartHall2Sequence(ent)
    end

    hook.Add("AcceptInput", "hall_force_way", function(ent, input, activator, caller, value)
        if IsValid(ent) and
           IsValid(activator) and
           input == "Use" and
           activator:IsPlayer(activator) and
           ent.GetName and
           string.find(ent:GetName(), "main_arc_corridor_102_door", nil, true)
          then
            return true
        end
    end)

    return true
end

local function RemoveEvent()
    hook.Remove("AcceptInput", "hall_force_way")

    return true
end

GLVL.Event:SetCall(eventName, CreateEvent)
GLVL.Event:SetDisableCall(eventName, RemoveEvent)
