--[[
    Anomaly Research Center (A.R.C.) Exploration
    Revealing and exposing curses.
]]

GLVL = {
    id = "glvl",
    luaFolder = "glvl",
    dataFolder = "glvl",
    maps = { "gm_hall_test", "gm_level!", "gm_level__v7", "gm_level__v8", "gm_lvl_proposul_event_05", "gm_level_v9" },
    enableEvents = true,
    Ent = {}
}

GLVL.isValidMap = table.HasValue(GLVL.maps, game.GetMap())

-- Hotload Sandbox Events System (SandEv or SEv)
hook.Add("OnGamemodeLoaded", "SEv_init", function()
    if SEv or file.Exists( "autorun/sev_init.lua", "LUA" ) then return end
    file.CreateDir("sandev")
    timer.Simple(0, function()
        http.Fetch("https://raw.githubusercontent.com/Xalalau/SandEv/main/lua/sandev/init/autohotloader.lua", function(SEvHotloader)
            file.Write("sandev/sevloader.txt", SEvHotloader)
            RunString(SEvHotloader)
            StartSEvHotload(false)
        end, function()
            local SEvHotloader = file.Read("sandev/sevloader.txt", "DATA")
            if SEvHotloader then
                RunString(SEvHotloader, "DATA")
                StartSEvHotload(false)
            end
        end)
    end)
end)

hook.Add("sandev_init", GLVL.luaFolder, function(SEv)
    SEv:AddInstance(GLVL)
end)