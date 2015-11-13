--[[
Final variables
--]]

local follow_player = "Mengo"
local rest_point
local buff_mage = {}
local buff_warrior = {}
local party_members
local primary_heal_id = 11 -- Heal
local primary_heal_percentage = 65
local secundary_heal_id = 22 -- Battle Heal
local secundary_heal_percentage = 35

function goFollow()
  for i = 1, 2, 1 do
  Command("/target "..follow_player)
  Sleep(1000)
  end
end

function getPartyMembers()
  party_members = GetPartyList()
end

function checkHeal()
  getPartyMembers()
  if (party_members ~= nil) then
    for member in party_members do
      if (member:GetMaxHp() < secundary_heal_percentage * member:GetMaxHp() / 100) then
        Command("/target "..member:GetName())
        Sleep(500)
        UseSkill(secundary_heal_id)
      elseif (member:GetMaxHp() < primary_heal_percentage * member:GetMaxHp() / 100) then
        Command("/target "..member:GetName())
        Sleep(500)
        UseSkill(primary_heal_id)
      end
    end
  end
end


ShowToClient("Supp", "Initialized")
repeat
goFollow()
checkHeal()
until false
