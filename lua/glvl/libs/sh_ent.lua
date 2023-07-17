-- Find an entrance foward vector
--   The entrance must be aligned with the x or y axes and be planced touching at least 1 wall
--   The function will create "fake invible doors" rotated around the real door origin and assume that the fully in-map one represents forward
function GLVL.Ent:GetEntranceForward(eventName, ent)
    local tester = ents.Create("sev_marker")
    tester:Setup(GLVL, eventName, "ent_forward_tester", Vector(-109.56, 4.52, 36.03), Vector(-145.06, -30.61, 1.3)) -- These rel vectors work nicely with doors

    local forward
    local pos = ent:GetPos()

    local isIn1
    local isIn2

    tester:SetPos(pos + Vector(-70, -10, 0))
    isIn1 = tester:IsInWorld()
    tester:SetPos(pos + Vector(-70, 10, 0))
    isIn2 = tester:IsInWorld()

    if isIn1 and isIn2 then
        forward = Vector(-1, 0, 0)
    end

    if not forward then
        tester:SetPos(pos + Vector(70, -10, 0))
        isIn1 = tester:IsInWorld()
        tester:SetPos(pos + Vector(70, 10, 0))
        isIn2 = tester:IsInWorld()

        if isIn1 and isIn2 then
            forward = Vector(1, 0, 0)
        end
    end

    if not forward then
        tester:SetPos(pos + Vector(-10, -70, 0))
        isIn1 = tester:IsInWorld()
        tester:SetPos(pos + Vector(10, -70, 0))
        isIn2 = tester:IsInWorld()

        if isIn1 and isIn2 then
            forward = Vector(0, -1, 0)
        end
    end

    if not forward then
        tester:SetPos(pos + Vector(-10, 70, 0))
        isIn1 = tester:IsInWorld()
        tester:SetPos(pos + Vector(10, 70, 0))
        isIn2 = tester:IsInWorld()

        if isIn1 and isIn2 then
            forward = Vector(0, 1, 0)
        end
    end

    tester:Remove()

    return forward
end
