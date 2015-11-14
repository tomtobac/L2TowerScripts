--[[
Final variables
--]]

local follow_player = "Mengo"
--local rest_point
--local buff_mage = {}
--local buff_warrior = {}
local party_members
local primary_heal_id = 1011 -- Heal
local primary_heal_percentage = 65
local secundary_heal_id = 1015 -- Battle Heal
local secundary_heal_percentage = 35
local shield_id = 1040
local ww_id = 1204
local concentration = 1078

function goFollow()
	if (GetTarget() ~= nil and GetTarget() == follow_player) then
		Command("/target %target")
	else
		Command("/target " .. follow_player)
		Sleep(500)
		Command("/target " .. follow_player)
	end
end

function getPartyMembers()
	if (GetPartyList() ~= nil) then
	party_members = GetPartyList()
	end
end

function buff(user, skill_id)
	if (not user:GotBuff(skill_id)) then
		Command("/target "..user:GetName())
		UseSkill(skill_id)
		Sleep(1500)
	end
end

function checkBuff()
  getPartyMembers()
  if (party_members ~= nil) then
    for member in party_members.list do
		buff(member, shield_id)
		buff(member, ww_id)
		buff(member, concentration)	
    end
  end
end

function checkBuffMyself()
		local me = GetMe()
		buff(me, shield_id)
		buff(me, ww_id)
		buff(me, concentration)	
end


function checkLeaderSit()
	Command("/target " .. follow_player)
	if (GetTarget() ~= nil) then
		if (GetTarget():IsSiting() and  not GetMe():IsSiting()) then
		Sleep(1500)
		Command("/sit")
		Sleep(1000)
		elseif (not GetTarget():IsSiting() and GetMe():IsSiting()) then
		Sleep(1500)
		Command("/stand")
		Sleep(1000)
		end
	end
end


function checkHeal()
  getPartyMembers()
  if (party_members ~= nil) then
    for member in party_members.list do
      if (member:GetHp() < secundary_heal_percentage * member:GetMaxHp() / 100) then
		--Command("#" .. member:GetName() .. " has lower hp than " .. tostring(secundary_heal_percentage * member:GetMaxHp() / 100))
        Command("/target "..member:GetName())
        UseSkill(secundary_heal_id)
        Sleep(1300)
      elseif (member:GetHp() < primary_heal_percentage * member:GetMaxHp() / 100) then
	  	--Command("#" .. member:GetName() .. " has lower hp than " .. tostring(primary_heal_percentage * member:GetMaxHp() / 100))
        Command("/target "..member:GetName())
        UseSkill(primary_heal_id)
		Sleep(1300)
      end
    end
  end
end


ShowToClient("Supp", "Initialized")
repeat
goFollow()
checkHeal()
checkBuff()
--checkBuffMyself()
checkLeaderSit()
until false
