function bubbleSort(A)
  local itemCount=#A
  local hasChanged
  repeat
    hasChanged = false
    itemCount=itemCount - 1
    for i = 0, itemCount do
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
        if (distance>mob:GetDistance() and mob:GetHp()>0 and  not mob:IsAlikeDeath()) then
            array[index] = mob;
            index = index + 1;
        end;
    end;
    bubbleSort(array) -- Sorting the array to lower distance to highest. highlight: http://ideone.com/DLj1kW
    return array;
end;

local tmp = arrangedMobListbyDistance(2000);
ShowToClient("", "List Mobs: ");
if (tmp == nil) then
	ShowToClient("", "No mobs arround.");
else
	for i, mob in pairs(tmp) do
		ShowToClient(tostring(i), "Name: " .. tostring(mob:GetName()) .. " - distance: " .. tostring(mob:GetDistance()));
	end
end;
