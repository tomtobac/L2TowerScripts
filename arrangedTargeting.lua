function bubbleSort(A)
  local itemCount=#A
  local hasChanged
  repeat
    hasChanged = false
    itemCount=itemCount - 1
    for i = 1, itemCount do
      if A[i]:GetDistance() > A[i + 1]:GetDistance() then
        A[i], A[i + 1] = A[i + 1], A[i]
        hasChanged = true
      end
    end
  until hasChanged == false
end

function arrangedMobListbyDistance(distance)
    local array = {};
    local moblist = GetMonsterList();
    local index = 0;
    for mob in moblist.list do
        if (distance<mob:GetDistance() and mob:GetHp()>0 and  not mob:IsAlikeDeath()) then
            array[index] = mob;
            index = index + 1;
        end;
    end;
    bubbleSort(array) -- Sorting the array to lower distance to highest.
    return array;
end;

local var = arrangedMobListbyDistance(2000);
local index = 0;
ShowToClient("", "List Mobs: ");
if (var == nil) then
	ShowToClient("", "No mobs arround.");
else
	for index = 0, table.getn(var) do
	ShowToClient(tostring(index), "Name: " .. tostring(var[index]:GetName()) .. " - distance: " .. tostring(var[index]:GetDistance()));
	end;
end;
