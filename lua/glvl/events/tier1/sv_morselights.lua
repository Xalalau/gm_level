local eventName = "morseLights"

local function CreateEvent()
    local newLight = ents.Create("sev_light")

    -- O vetor abaixo é a posição da lâmpada. Usa o comando devmode_glvl_toggle pra ver a ferramenta de posição e copia uma do jogo para cá
    newLight:Setup(GLVL, eventName, "light_morse", Vector(-14417.21, -9354.69, 42.03), Color(252, 255, 212, 2), 1000, 256)
    -- "Isso eh um teste fantastico."
    SEv.Light:StartMorse(newLight, 0.1, ".. ... ... --- / . .... / ..- -- / - . ... - . / ..-. .- -. - .- ... - .. -.-. --- .-.-.-")

    return true
end

GLVL.Event:OnEnabled(eventName, CreateEvent)
