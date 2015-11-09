
function arrangedMobListbyDistance(distance)
    local array = {};
    local moblist = GetMonsterList();
    local index = 0;
    for mob in moblist.list do
        if (distance>mob:GetDistance() and mob:GetHp()>0 and  not mob:IsAlikeDeath()) then
            array[index] = mob;
            index = index + 1;
        end;
    end;
        local sort_func = function( a,b ) return a.GetDistance() < b.GetDistance() end
        table.sort( array, sort_func )
    return array;
end;

local var = arrangedMobListbyDistance(2000)
local index = 0;
ShowToClient("", "List Mobs: ");
for mob in var.list do
ShowToClient(tostring(index), "Name: " .. tostring(mob:GetName()) .. " - distance: " .. tostring(mob:GetDistance()));
index = index + 1;
end;
