--[[
Final variables
--]]

local follow_player = "Bruixot"
--local rest_point
--local buff_mage = {}
--local buff_warrior = {}
local party_members
local primary_heal_id = 1011 -- Heal
local primary_heal_percentage = 65
local secundary_heal_id = 1015 -- Battle Heal
local secundary_heal_percentage = 35

function goFollow()
  for i = 1, 2, 1 do
  Command("/target "..follow_player)
  Sleep(200)
  end
end

function getPartyMembers()
	if (GetPartyList() ~= nil) then
	party_members = GetPartyList()
	end
end

function checkHeal()
  getPartyMembers()
  if (party_members ~= nil) then
    for member in party_members.list do
      if (member:GetHp() < secundary_heal_percentage * member:GetMaxHp() / 100) then
		Command("#" .. member:GetName() .. " has lower hp than " .. tostring(secundary_heal_percentage * member:GetMaxHp() / 100))
        Command("/target "..member:GetName())
        UseSkill(secundary_heal_id)
        Sleep(1300)
      elseif (member:GetHp() < primary_heal_percentage * member:GetMaxHp() / 100) then
	  	Command("#" .. member:GetName() .. " has lower hp than " .. tostring(primary_heal_percentage * member:GetMaxHp() / 100))
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
until false
