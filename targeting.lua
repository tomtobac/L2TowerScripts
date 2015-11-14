---------------------- Final Variable configuration ------------------------

--Global variables don't need declaration
location = GetMe():GetLocation()		-- Location of the main spot.
range = 3000; 					-- Range of targeting
overhit_damage = 200; 				-- Overhit damage
totalmana = 484;				-- Max pool of ur mana character
perce_mana_summon = 75; 			-- Summon restore mana at Percentage
perce_mana_sit = 40;				-- Percentage to sit
perce_mana_stand = 80;				-- Percentage to stand
perce_hp_heal = 75;
restoring_mp = false				-- Are we restoring mp?
overhit_damage_perce = 40


--Bar controls:
aqua_swirl_id = 1175;
wind_strike_id = 1177;
ice_bolt_id = 1184
solar_spark = 1264
mainNuke = aqua_swirl_id
overHitNuke = solar_spark
summonRestoreMp = "/useshortcut 1 3";
skillHeal ="/useshortcut 1 5";
attack_pony = "/useshortcut 1 6";
----------------------- FUNCTION : TARGETMOBS ---------------------------------
function targetMobs(range)
local moblist = GetMonsterList();
local currentrange=range;

	currentmob = nil
    for mob in moblist.list do	
		local maxRange = GetDistanceVector(location,GetMe():GetLocation()) + mob:GetDistance();
        if (currentrange > maxRange and mob:GetHp()>0 and  not mob:IsAlikeDeath()) then
            currentrange=mob:GetDistance(); -- Looking for the nearest mob.
            currentmob=mob;
        end;
    end;

    return currentmob;
end;

----------------------- FUNCTION : SUMMON GIVES MANA ---------------------------------

function summonGivesMana()
	if(GetMe():GetMp() < (totalmana * perce_mana_summon / 100)) then		
		Command(summonRestoreMp); -- Summon uses recharge
	end;
end;

---------------------- FUNCTION : DONT MOVE ---------------------

function checkSpot(location)
		selfHeal()
		MoveToNoWait(location)
		
    	checkMana() -- call 'check mana' after it moves.
end

----------------------- FUNCTION : CHECK MANA ------------------

function checkMana()
	if (GetMe():GetMp() < (totalmana * perce_mana_sit / 100) and not restoring_mp) then -- Mana below 40% ~
		Command("/sit");
		restoring_mp = true
	elseif (GetMe():GetMp() > (totalmana * perce_mana_stand / 100) and GetMe():IsSiting() and restoring_mp) then -- Mana over 80% ~
		Command("/stand");
		restoring_mp = false
	elseif (not GetMe():IsSiting() and restoring_mp) then
		fight()
		restoring_mp = false
	end
		
	if (not GetMe():IsSiting()) then
		summonGivesMana() -- check if summon has to give us mana.
	end
end

---------------------- Function: useFightSkills -----------------------


function useFightSkills()
	if (GetTarget()~=nil) then	
		if (overhit_damage_perce > GetTarget():GetHpPercent() and not GetTarget():IsAlikeDeath()) then
			--Command(overHitNuke) 	--OverhitNuke
			
			UseSkill(overHitNuke);
		else
			--Command(mainNuke)	--Main nuke
			UseSkill(mainNuke);
		end
		Command(attack_pony)
	end
end


----------------------- FUNCTION : TARGET MOB  ---------------------------------

function targetMob()
local target=targetMobs(range)
	if (target~=nil) then -- Target is not null
		if (target:GetHp() > 0) then -- Target Hp is superior to 0.
			if (not target:IsAlikeDeath()) then  -- Target is not dead
				if (not restoring_mp) then -- I am not restoring mana
					return "/target "..tostring(target:GetName())
				end
			end
		end
	end

	return nil;
end

----------------------- FUNCTION : TARGET MOB  ---------------------------------

function selfHeal()
	if (GetMe():GetHpPercent() < perce_hp_heal) then -- Target is not nul
		Command("/target Mengo")
		Sleep(1000)
		Command(skillHeal);
		Sleep(4000)
		CancelTarget(true) -- Cancel current Target (ESC).
	end
end

function fight()
	repeat -- Waitting for the dead of target.
				Sleep(1500); -- Give us time to use skills!!
				useFightSkills() -- Using skills	
	until (GetTarget() == nil or GetTarget():IsAlikeDeath()); -- Until the mob is dead or he don't have target.
end
----------------------- SCRIPT ---------------------------------

repeat
		

		local target = targetMob()
		if(target ~= nil) then
			Command(target); -- Target next Mob
		end
		
        fight();
		
		
        CancelTarget(true) -- Cancel current Target (ESC).
        
	Sleep(1000)
	checkSpot(location) -- Are we far away from spot? brb, comming back
	
until false
