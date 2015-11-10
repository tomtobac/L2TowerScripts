----------------------- FUNCTION : TARGETMOBS ---------------------------------
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

    return currentmob;
end;

----------------------- FUNCTION : SUMMON GIVES MANA ---------------------------------

function summonGivesMana()
	local mana = 484;
	local perce_mana = 75; -- Percentage of mana
	if(GetMe():GetMp() < (mana * perce_mana / 100)) then
	Command("/useshortcut 1 3"); -- Summon uses recharge
	end;
end;

---------------------- FUNCTION : DONT MOVE ---------------------

function checkSpot(location)
	local mana = 484;
	SpotLocation = location;
	if (GetDistanceVector(GetMe():GetLocation(),SpotLocation) > 60) and (GetDistanceVector(SpotLocation,GetMe():GetLocation()) < 2500) then
		MoveToNoWait(SpotLocation);
		Sleep(5000);
		if (GetMe():GetMp() < (mana * 40 / 100)) then -- Mana below 40% ~
		Command("/sit");
		elseif (GetMe():GetMp() > (mana * 80 / 100)  and GetMe():IsSiting()) then -- Mana over 80% ~
		Command("/stand");
		end;
    end;
end;

----------------------- SCRIPT ---------------------------------


local old_id = 0; -- Doesn't matter.
local range = 2500; -- Range 
local location = GetMe():GetLocation();
local continue
--local id_skill = GetSkillIdByName("Aqua Swirl");
repeat
target=targetMobs(range)
    if (target~=nil and target:GetHp()>0 and not target:IsAlikeDeath() and (target:GetId()~=old_id) and not (GetMe():IsSiting()) ) then  
        Command("/target "..tostring(target:GetName()));
        old_id = target:GetId(); -- Get new ID.
		summonGivesMana();
        repeat -- Waitting for the dead of target.
		Sleep(1500);
		--UseSkillRaw(id_skill, false, false);
		Command("/useshortcut 1 1")
		Command("/targetnext")
        until (target:IsAlikeDeath() or GetTarget() == nil); -- Until the mob is dead or he don't have target.

        CancelTarget(true); -- Cancel current Target (ESC).
    end;
Sleep(1000);
checkSpot(location);
until false
