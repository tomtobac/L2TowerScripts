-- Snippets
 
-- Myself.
 GetMe()
-- Players
GetPlayerList()
-- Get ID of NPC.
ShowToClient("", tostring(GetTarget():GetNpcId()))
-- Get ID
ShowToClient("", tostring(GetTarget():GetId()))
-- Get NickName of NPC/Monster
GetNickName();
-- GetSkills
skills = GetSkills();
for skill in skills.list do
    ShowToClient("Skills:", skill.name .. " - " .. tostring(skill.skillId));
end;
-- Get 1 Skill
GetSkillIdByName("Wind Strike");


(me:GotBuff(CheckSonataID6)

