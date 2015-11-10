
---------------------- Final Variable configuration ------------------------

--(Global variables don't need declaration)
range = 2500; 			-- Range of targeting
overhit_damage = 200; 		-- Overhit damage
Totalmana = 484;		-- Max pool of ur mana character
perce_mana_summon = 75; 	-- Summon restore mana at Percentage
perce_mana_sit = 40;		-- Percentage to sit
perce_mana_stand = 80;		-- Percentage to stand

--Bar controls:
mainNuke = "/useshortcut 1 1";
overHitNuke = "/useshortcut 1 2";
summonRestoreMp = "/useshortcut 1 3";

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

    --ShowToClient("MOB LIST",  list);

    return currentmob;
end;

----------------------- FUNCTION : SUMMON GIVES MANA ---------------------------------

function summonGivesMana()
	if(GetMe():GetMp() < (mana * perce_mana_summon / 100)) then
		Command(summonRestoreMp);
	end;
end;

---------------------- FUNCTION : DONT MOVE ---------------------

function checkSpot(location)

	SpotLocation = location;
	if (GetDistanceVector(GetMe():GetLocation(),SpotLocation) > 60) and (GetDistanceVector(SpotLocation,GetMe():GetLocation()) < 2500) then
		MoveToNoWait(SpotLocation);
		Sleep(5000);
		if (GetMe():GetMp() < (mana * perce_mana_sit / 100)) then -- Mana below 40% ~
			Command("/sit");
		elseif (GetMe():GetMp() > (mana * perce_mana_stand / 100)  and GetMe():IsSiting()) then -- Mana over 80% ~
			Command("/stand");
		end;
    end;
end;

---------------------- Function: useFightSkills -----------------------

function useFightSkills()
	if (target:GetHp()< overhit_damage){
		Command(overHitNuke) 	--OverhitNuke
	}else{
		Command(mainNuke)	--Main nuke
	}

end;

----------------------- SCRIPT ---------------------------------


local old_id = 0; -- Doesn't matter.
local location = GetMe():GetLocation();

--local id_skill = GetSkillIdByName("Aqua Swirl");
repeat
	target=targetMobs(range)
    	if (target~=nil and target:GetHp()>0 and not target:IsAlikeDeath() and (target:GetId()~=old_id) ) then  
        --ShowToClient("BOT",  tostring("NEW TARGET: "..target:GetName().." - id: " .. target:GetId()));
        	Command("/target "..tostring(target:GetName()));
        	old_id = target:GetId(); -- Get new ID.
		
		repeat -- Waitting for the dead of target.
            		Sleep(1000);
			summonGivesMana();
			--UseSkillRaw(id_skill, false, false);
			useFightSkills();
			
        	until (target:IsAlikeDeath() or GetTarget() == nil); -- Until the mob is dead or he don't have target.
		CancelTarget(true); -- Cancel current Target (ESC).
        	--ShowToClient("BOT", tostring(target:GetName()).." is dead.");
    	end;
	Sleep(1000);
	
	checkSpot(location); --Return to the begin zone
until false

