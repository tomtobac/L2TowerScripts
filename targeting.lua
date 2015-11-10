---------------------- Final Variable configuration ------------------------

--Global variables don't need declaration
location = GetMe():GetLocation()		-- Location of the main spot.
range = 1500; 					-- Range of targeting
overhit_damage = 200; 				-- Overhit damage
totalmana = 484;				-- Max pool of ur mana character
perce_mana_summon = 75; 			-- Summon restore mana at Percentage
perce_mana_sit = 40;				-- Percentage to sit
perce_mana_stand = 80;				-- Percentage to stand
restoring_mp = false				-- Are we restoring mp?

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
	SpotLocation = location;
	if (GetDistanceVector(GetMe():GetLocation(),SpotLocation) > 60) and (GetDistanceVector(SpotLocation,GetMe():GetLocation()) < 2500) then
		MoveToNoWait(SpotLocation)
		Sleep(2500)
    	end
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
	end
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

----------------------- FUNCTION : imDeath ---------------------------------

function imDeath()
	if (GetMe():IsAlikeDeath()) then
	    SetPause(true)
	    LogOut()
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
end

----------------------- SCRIPT ---------------------------------


repeat
		target = targetMob(target)
		while (target == nil and GetTarget() == nil) do -- Check if there are mob arround and we don't have one targeted 
		--There are not mobs available, we can /sit and wait for it
			if (not GetMe():IsSiting()) then
			Command("/sit")
			Sleep(1500)
			end
		target = targetMob();
		end
		if (GetMe():IsSiting()) then -- Check if we're sitting. -- We were sitting because we didn't have mobs around, we're standing up
		Command("/stand")
		Sleep(2500) -- Give us time to stand up!
		end
        Command(targetMob()); -- Target next Mob

        repeat -- Waitting for the dead of target.
			Sleep(1500); -- Give us time to use skills!!
			useFightSkills() -- Using skills
			--Command("/targetnext") -- Not sure about it. :''(
			
        until (GetTarget() == nil or GetTarget():IsAlikeDeath()); -- Until the mob is dead or he don't have target.
	
		summonGivesMana() -- check if summon has to give us mana.
        CancelTarget(true) -- Cancel current Target (ESC).
        
	Sleep(1000)
	checkSpot(location) -- Are we far away from spot? brb, comming back
	imDeath() -- Are we dead? Logout.
	
until false
