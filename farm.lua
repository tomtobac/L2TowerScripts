---------------------- Final Variable configuration ------------------------

--Global variables don't need declaration
location = GetMe():GetLocation()		-- Location of the main spot.
range = 2500; 					-- Range of targeting
overhit_damage = 200; 			-- Overhit damage			-- 


--Skills ID
blaze_id = 1220;
auraburn_id = 1172;
heal_id = 1011;


----------------------- FUNCTION : TARGETMOBS ---------------------------------

-- Llista els mobs en un àrea i retorna el mes proper
function getMobMesProper(range)
	local moblist = GetMonsterList();
	local currentrange = 0;

	while(currentrange <= range) do
		for mob in moblist.list do
			if(mob:GetDistance()<currentrange and mob:GetHpPercent()>50 and  not mob:IsAlikeDeath()) then
				return "/target "..tostring(mob:GetName())
			end
		end
		currentrange = currentrange + 500;
	end

end


----------------------- FUNCTION : SUMMON GIVES MANA ---------------------------------

function summonGivesMana()
	if(GetMe():GetMpPercent() < 75) then
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
end

----------------------- FUNCTION : CHECK MANA ------------------

function checkMana()
	if (not GetMe():IsSiting() and GetMe():GetMpPercent() < 40) then -- Mana below 40% ~
		Command("/sit");
		return true
	else if ( GetMe():IsSiting() and GetMe():GetMpPercent() > 80) then -- Mana over 80% ~
		Command("/stand");
		return false
	end
end
----------------------- FUNCTION : CHECK HP ------------------
function checkHP()
	if (GetMe():GetHpPercent() < 80 )then
    	Command("/target Bruixot");
    	UseSkill(heal_id)
    	Sleep(1500);
    	CancelTarget(true)
    end
end
---------------------- Function: useFightSkills -----------------------


function useFightSkills()
	if (GetTarget()~=nil) then
		if (GetTarget():GetDistance() < 300) then
			UseSkill(auraburn_id); 	--closerange
		else
			UseSkill(blaze_id);	--Main nuke
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



----------------------- FUNCTION : POSTCOMBAT ---------------------------------

function postCombat()
	--donam mana i cancelam es target
	CancelTarget(true) -- Cancel current Target (ESC).
	summonGivesMana() -- check if summon has to give us mana.
	--coim drop
	local contador = 0
	while (contador~=3) do
		Command("/pickup")
		Sleep(1000);
		contador = contador + 1
    end
    
    checkHP(); --mira si ens hem de curar
    --si necessitam mana es seu, polling cada 5s
    while ( checkMana() ) do
    	Sleep(5000)
    end
end
----------------------- SCRIPT ---------------------------------


repeat
		
		--TARGET
		while (GetTarget() == nil) do
        	Command(getMobMesProper()); -- Target next Mob
        	Sleep(2000);
        end
        --empra skills fins que el mata
        repeat 
			
			useFightSkills() -- Using skills
			Sleep(1250); -- Give us time to use skills!!
			
        until (GetTarget() == nil or GetTarget():IsAlikeDeath()); -- Until the mob is dead or he don't have target.
		
		-- DROP I HEAL
		postCombat()

        
		Sleep(1000)
		checkSpot(location) -- Are we far away from spot? brb, comming back
		imDeath() -- Are we dead? Logout.
	
until false
