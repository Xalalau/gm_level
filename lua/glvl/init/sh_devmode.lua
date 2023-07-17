if not GLVL.isValidMap then return end

local state_devmode_glvl = GetConVar("state_devmode_" .. GLVL.id)

-- Block map cleanup, noclip, weapons and spawn menu
-- Devmode will also remove some limitations like flashlight and moving speeds

if SERVER then
    hook.Add(GLVL.id .. "_devmode", "glvl_devmode_toggled", function(state)
        if state == true then
            SEv.Map:BlockCleanup(false)

            for k, ply in ipairs(player.GetHumans()) do
                SEv.Ply:BlockNoclip(ply, false)

                ply:AllowFlashlight(true)

                timer.Simple(0.1, function()
                    if not ply:IsValid() then return end

                    ply:Give("gmod_tool")
                    ply:Give("weapon_smg1")
                    ply:Give("weapon_physgun")
                    ply:Give("gmod_camera")
                end)

                ply:SetRunSpeed(500)
                ply:SetWalkSpeed(300)
                ply:SetJumpPower(200)
            end
        else
            SEv.Map:BlockCleanup(true)

            for k, ply in ipairs(player.GetHumans()) do
                SEv.Ply:BlockNoclip(ply, true)

                ply:StripWeapons()

                ply:Flashlight(false)
                ply:AllowFlashlight(false)
            end
        end
    end)

    hook.Add("PlayerInitialSpawn", "glvl_ply_initial_spawn", function(ply)
        local state = state_devmode_glvl:GetBool()

        SEv.Ply:BlockNoclip(ply, not state)

        if not state then
            ply:StripWeapons()
        end
    end)

    hook.Add("PlayerCanPickupWeapon", "glvl_extra_block_weapons", function(ply, weapon)
        return state_devmode_glvl:GetBool()
    end)
end

if CLIENT then
    hook.Add("SpawnMenuOpen", "glvl_block_spawn_menu", function()
        return state_devmode_glvl:GetBool()
    end)
end
