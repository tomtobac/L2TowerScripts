---------------------- Final Variable configuration ------------------------

--Global variables don't need declaration
location = GetMe():GetLocation()		-- Location of the main spot.
range = 20; 					-- Range of targeting
overhit_damage = 200; 				-- Overhit damage
totalmana = 484;				-- Max pool of ur mana character
perce_mana_summon = 75; 			-- Summon restore mana at Percentage
perce_mana_sit = 40;				-- Percentage to sit
perce_mana_stand = 80;				-- Percentage to stand
perce_hp_heal = 75;
restoring_mp = false				-- Are we restoring mp?

--Bar controls:
mainNuke = "/useshortcut 1 1";
overHitNuke = "/useshortcut 1 2";
summonRestoreMp = "/useshortcut 1 3";
skillHeal ="/useshortcut 1 5";
----------------------- FUNCTION : TARGETMOBS ---------------------------------
function targetMobs(range)
local moblist = GetMonsterList();
local currentrange=range;
local currentmob = nil

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
	Command("/pickup")
	Sleep(1000)
	Command("/pickup")
	Sleep(1000)
	MoveToNoWait(location)
		
    	checkMana() -- call 'check mana' after it moves.
end

----------------------- FUNCTION : CHECK MANA ------------------

function checkMana()
	if (GetMe():GetMp() < (totalmana * perce_mana_sit / 100)) then -- Mana below 40% ~
		Command("/sit");
		restoring_mp = true
	elseif (GetMe():GetMp() > (totalmana * perce_mana_stand / 100) and GetMe():IsSiting() and restoring_mp) then -- Mana over 80% ~
		Command("/stand");
		restoring_mp = false
	elseif (restoring_mp or GetTarget()~=nil) then
		Sleep(1000)
		Command("/pickup")
	end --Si hi ha un target q te pega.... hem de fer algp
end

---------------------- Function: useFightSkills -----------------------


function useFightSkills()
	if (GetTarget()~=nil) then	
		if (GetTarget():GetHp()< overhit_damage and not GetTarget():IsAlikeDeath()) then
			Command(overHitNuke) 	--OverhitNuke
		else
			Command(mainNuke)	--Main nuke
		end
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
		Sleep(3000)
	end
end

----------------------- SCRIPT ---------------------------------

repeat
		

	local target = targetMob()
	if(target ~= nil){
		Command(target); -- Target next Mob
	}
        repeat -- Waitting for the dead of target.
			Sleep(1500); -- Give us time to use skills!!
			useFightSkills() -- Using skills	
        until (GetTarget() == nil or GetTarget():IsAlikeDeath()); -- Until the mob is dead or he don't have target.
	
		summonGivesMana() -- check if summon has to give us mana.
        CancelTarget(true) -- Cancel current Target (ESC).
        
	Sleep(1000)
	checkSpot(location) -- Are we far away from spot? brb, comming back
	
until false
