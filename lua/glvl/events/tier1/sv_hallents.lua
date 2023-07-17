local eventName = "hallEnts"

-- Create ordered hall entity lists
hallEnts = {
    -- [int hall number] = {
    --     curve = Vector hall end,
    --     doors = { entity door, ... }, -- Ordered by distance from "curve"
    --     roomDoors = { entity door, ... }, -- Unsorted
    --     lights = { entity light, ... }, -- Ordered by distance from "curve"
    --     lamps = { entity lamp, ... }, -- Ordered by distance from "curve"
    -- },
}

local function SetInvisibleDoor(door)
    door:SetRenderMode(RENDERMODE_TRANSALPHA)
    door:SetColor(Color(255, 255, 255, 0))
end

local function GetHallEnts(hallNumber)
    local hall = hallEnts[hallNumber]

    local hallDoors = ents.FindByName("main_corridor_" .. hallNumber .. "_door")
    local hallRoomDoors = ents.FindByName("main_corridor_" .. hallNumber .. "_door_room")
    local hallRoomDoorsInvis = ents.FindByName("main_corridor_" .. hallNumber .. "_door_room_invis")
    local hallDoorsDistances = {}

    for k, door in ipairs(hallDoors) do
        hallDoorsDistances[door] = door:GetPos():Distance(hall.curve)
    end

    for door, dist in SortedPairsByValue(hallDoorsDistances) do
        table.insert(hall.doors, door)
    end
    
    for k, door in ipairs(hallRoomDoors) do
        table.insert(hall.roomDoors, door)
    end

    for k, door in ipairs(hallRoomDoorsInvis) do
        SetInvisibleDoor(door)
        table.insert(hall.roomDoors, door)
    end

    local hallLights = ents.FindByName("main_corridor_" ..  hallNumber .. "_light")
    local hallLightsDistances = {}

    for k, light in ipairs(hallLights) do
        hallLightsDistances[light] = light:GetPos():Distance(hall.curve)
    end
    
    for light, dist in SortedPairsByValue(hallLightsDistances) do
        table.insert(hall.lights, light)
    end

    local hallLamps = ents.FindByName("main_corridor_" .. hallNumber .. "_lamp")
    local hallLampsDistances = {}

    for k, lamp in ipairs(hallLamps) do
        hallLampsDistances[lamp] = lamp:GetPos():Distance(hall.curve)
    end
    
    for lamp, dist in SortedPairsByValue(hallLampsDistances) do
        table.insert(hall.lamps, lamp)
    end
end

local function CreateEvent()
    if not IsValid(ents.FindByName("hall_1_end")[1]) then return end

    local hallNumbers = {
        1,
        101,
        102
    }

    for k, hallNumber in ipairs(hallNumbers) do
        hallEnts[hallNumber] = {
            curve = ents.FindByName("hall_" .. hallNumber .. "_end")[1]:GetPos(),
            doors = {},
            roomDoors = {},
            lights = {},
            lamps = {},  
        }
    end

    timer.Simple(1, function()
        for hallNumber, hallInfo in pairs(hallEnts) do
            GetHallEnts(hallNumber)
        end

        hook.Run("glvl_gm13hall_ents")
    end)

    return true
end

GLVL.Event:SetCall(eventName, CreateEvent)