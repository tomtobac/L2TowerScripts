function targetMobs(range)
local moblist = GetMonsterList();
local currentrange=range;
local list = " \n ";
    
    for mob in moblist.list do
            list = list .. tostring(mob:GetName()) .. " \n ";
        if (currentrange>mob:GetDistance() and mob:GetHp()>0 and  not mob:IsAlikeDeath()) then
            currentrange=mob:GetDistance(); -- Looking for the nearest mob.
            currentmob=mob;
        end;
    end;

    ShowToClient("MOB LIST",  list);

    return currentmob;
end;

local old_id = 0; -- Doesn't matter.
local range = 1000; -- Range 
repeat
target=targetMobs(range)
    if (target~=nil and target:GetHp()>0 and not target:IsAlikeDeath() and (target:GetId()~=old_id) ) then  
        ShowToClient("BOT",  tostring("NEW TARGET: "..target:GetName().." - id: " .. target:GetId()));
        Command("/target "..tostring(target:GetName()));
        old_id = target:GetId(); -- Get new ID.

        repeat -- Waitting for the dead of target.
            Sleep(500);
			UseSkill(GetSkillIdByName("Aqua Swirl"));
        until (target:IsAlikeDeath()); -- Until the mob is dead.

        CancelTarget(true); -- Cancel current Target (ESC).
        ShowToClient("BOT", tostring(target:GetName()).." is dead.");
    end;
Sleep(1000);
until false
